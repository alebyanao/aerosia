<?php

use SilverStripe\Control\HTTPRequest;
use SilverStripe\Control\HTTPResponse;
use SilverStripe\Security\Security;

class PaymentController extends PageController
{
    private static $allowed_actions = [
        'initiate',
        'callback',
        'return'
    ];

    private static $url_handlers = [
        'initiate/$ID' => 'initiate',
        'callback' => 'callback',
        'return' => 'return'
    ];

    /**
     * /payment/initiate/{orderID}
     */
    public function initiate(HTTPRequest $request)
    {
        $orderID = $request->param('ID');
        if (!$orderID) return $this->httpError(400, 'Order ID required');

        $order = Order::get()->byID($orderID);
        if (!$order) return $this->httpError(404, 'Order not found');

        $currentUser = Security::getCurrentUser();
        if (!$currentUser || $order->MemberID != $currentUser->ID) {
            return $this->httpError(403, 'Access denied');
        }

        // Cek kadaluarsa
        if (method_exists($order, 'isExpired') && $order->isExpired()) {
            $order->cancelOrder();
            $request->getSession()->set('PaymentError', 'Pesanan telah kedaluwarsa');
            return $this->redirect('/order/detail/' . $orderID);
        }

        // Cek kelayakan pembayaran
        if (method_exists($order, 'canBePaid') && !$order->canBePaid()) {
            $request->getSession()->set('PaymentError', 'Pesanan tidak dapat dibayar');
            return $this->redirect('/order/detail/' . $orderID);
        }

        // Cek transaksi pending
        $existing = PaymentTransaction::get()
            ->filter([
                'OrderID' => $order->ID,
                'Status'  => 'pending'
            ])
            ->first();

        if ($existing && $existing->PaymentURL) {
            return $this->redirect($existing->PaymentURL);
        }

        // Pastikan order punya MerchantOrderID tetap
        if (!$order->MerchantOrderID) {
            $order->MerchantOrderID = 'ORDER-' . $order->ID;
            $order->write();
        }

        // Buat transaksi baru ke Duitku
        $duitku = new DuitkuService();
        $response = $duitku->createTransaction($order, $order->MerchantOrderID);

        if ($response && !empty($response['success'])) {
            $transaction = PaymentTransaction::create();
            $transaction->OrderID = $order->ID;
            $transaction->PaymentGateway = 'duitku';
            $transaction->TransactionID = $response['merchantOrderId'] ?? $order->MerchantOrderID;
            $transaction->Amount = $order->getGrandTotal();
            $transaction->Status = 'pending';
            $transaction->PaymentURL = $response['paymentUrl'] ?? null;
            $transaction->CreatedAt = date('Y-m-d H:i:s');
            $transaction->write();

            $order->Status = 'pending_payment';
            $order->write();

            return $this->redirect($transaction->PaymentURL);
        }

        $errorMessage = $response['error'] ?? 'Gagal membuat transaksi pembayaran';
        $request->getSession()->set('PaymentError', $errorMessage);
        return $this->redirect('/order/detail/' . $orderID);
    }

    /**
     * Callback dari Duitku
     */
    public function callback(HTTPRequest $request)
    {
        if (!$request->isPOST() && !$request->isGET()) {
            return $this->httpError(405, 'Method not allowed');
        }

        $data = [];
        if ($request->isPOST()) {
            $data = json_decode($request->getBody(), true) ?: $request->postVars();
        } else {
            $data = $request->getVars();
        }

        if (empty($data)) {
            return new HTTPResponse('No data received', 400);
        }

        $duitku = new DuitkuService();
        if (!$duitku->verifyCallback($data)) { //INI CALLBACK DARI DUITKU
            return new HTTPResponse('Invalid signature', 400);
        }

        $merchantOrderId = $data['merchantOrderId'] ?? '';
        $resultCode = $data['resultCode'] ?? '';

        $transaction = PaymentTransaction::get()->filter('TransactionID', $merchantOrderId)->first();
        if (!$transaction) {
            return new HTTPResponse('Transaction not found', 404);
        }

        $order = $transaction->Order();
        if (!$order) {
            return new HTTPResponse('Order not found', 404);
        }

        $transaction->ResponseData = json_encode($data);

        if ($resultCode == '00') {
            $transaction->Status = 'success';
            $order->markAsPaid();

            $this->sendPaymentSuccessNotification($order);

            try {
                InvoiceController::sendInvoiceAfterPayment($order);
            } catch (Exception $e) {
                error_log('Invoice send failed: ' . $e->getMessage());
            }

        } else {
            $transaction->Status = 'failed';
            $order->Status = 'cancelled';
            $order->PaymentStatus = 'failed';
            $order->write();

            $this->sendPaymentFailedNotification($order);
        }

        $transaction->write();

        return new HTTPResponse('OK', 200);
    }

    /**
     * Return dari Duitku setelah user selesai bayar
     */
    public function return(HTTPRequest $request)
    {
        $merchantOrderId = $request->getVar('merchantOrderId');
        $resultCode = $request->getVar('resultCode');

        if (!$merchantOrderId) {
            return $this->redirect('/order');
        }

        $transaction = PaymentTransaction::get()->filter('TransactionID', $merchantOrderId)->first();
        $order = $transaction ? $transaction->Order() : null;

        if (!$order) {
            return $this->redirect('/order');
        }

        if ($resultCode == '00') {
            $transaction->Status = 'success';
            $transaction->write();

            $order->markAsPaid();

            try {
                InvoiceController::sendInvoiceAfterPayment($order);
                $request->getSession()->set('PaymentSuccess', 'Pembayaran berhasil! Pesanan Anda sedang diproses. Invoice telah dikirim ke email Anda.');
            } catch (Exception $e) {
                $request->getSession()->set('PaymentSuccess', 'Pembayaran berhasil! Pesanan Anda sedang diproses.');
            }
        } else {
            $transaction->Status = 'failed';
            $transaction->write();

            $order->Status = 'cancelled';
            $order->PaymentStatus = 'failed';
            $order->write();

            $request->getSession()->set('PaymentError', 'Pembayaran gagal atau dibatalkan. Pesanan telah dibatalkan.');
        }

        return $this->redirect('/order/detail/' . $order->ID);
    }

    private function sendPaymentSuccessNotification($order)
    {
        error_log('Payment success for order: ' . $order->ID);
    }

    private function sendPaymentFailedNotification($order)
    {
        error_log('Payment failed for order: ' . $order->ID);
    }
}
