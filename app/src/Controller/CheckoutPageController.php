<?php

use SilverStripe\Control\HTTPRequest;
use SilverStripe\ORM\ValidationException;
use SilverStripe\Security\Security;
use SilverStripe\Control\Director;
use SilverStripe\Control\HTTPResponse;
use SilverStripe\View\ArrayData;
use SilverStripe\ORM\ArrayList;

class CheckoutPageController extends PageController
{
    private static $allowed_actions = [
        'index',
        'processOrder',
        'getPaymentMethod'
    ];

    public function index(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        // Ambil data tiket dari POST atau GET
        $ticketTypeID = $request->postVar('ticket_type_id') ?? $request->getVar('ticket_type_id');
        $quantity = (int) ($request->postVar('quantity') ?? $request->getVar('quantity'));

        // Debug logging
        error_log('CheckoutPageController::index - TicketTypeID: ' . $ticketTypeID);
        error_log('CheckoutPageController::index - Quantity: ' . $quantity);

        if (!$ticketTypeID || $quantity < 1) {
            return $this->customise([
                'ErrorMessage' => 'Tidak ada tiket yang dipilih. Silakan kembali ke halaman event dan pilih tiket.',
                'CurrentUser' => Security::getCurrentUser(),
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        $ticketType = TicketType::get()->byID($ticketTypeID);
        if (!$ticketType || !$ticketType->exists()) {
            return $this->customise([
                'ErrorMessage' => 'Tipe tiket tidak ditemukan.',
                'CurrentUser' => Security::getCurrentUser(),
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        // Validasi kapasitas tiket
        if ($ticketType->Capacity < $quantity) {
            return $this->customise([
                'ErrorMessage' => 'Maaf, tiket yang tersedia hanya ' . $ticketType->Capacity . ' tiket.',
                'CurrentUser' => Security::getCurrentUser(),
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        // Hitung total harga tiket
        $totalPrice = $ticketType->Price * $quantity;

        // Ambil payment methods dari Duitku
        $paymentMethods = new ArrayList();
        try {
            $duitku = new DuitkuService();
            $rawPaymentMethods = $duitku->getPaymentMethods($totalPrice);
            
            error_log('CheckoutPageController::index - Raw payment methods: ' . json_encode($rawPaymentMethods));
            
            // Convert array to ArrayList for template compatibility
            if (is_array($rawPaymentMethods) && !empty($rawPaymentMethods)) {
                foreach ($rawPaymentMethods as $method) {
                    $paymentMethods->push(new ArrayData([
                        'paymentMethod' => $method['paymentMethod'] ?? '',
                        'paymentName' => $method['paymentName'] ?? '',
                        'paymentImage' => $method['paymentImage'] ?? '',
                        'totalFee' => $method['totalFee'] ?? 0,
                    ]));
                }
                error_log('CheckoutPageController::index - Payment methods count: ' . $paymentMethods->count());
            } else {
                error_log('CheckoutPageController::index - No payment methods returned from Duitku');
            }
        } catch (Exception $e) {
            error_log('CheckoutPageController::index - Error getting payment methods: ' . $e->getMessage());
        }

        return $this->customise([
            'TicketType' => $ticketType,
            'Ticket' => $ticketType->Ticket(),
            'Quantity' => $quantity,
            'TotalPrice' => $totalPrice,
            'FormattedTotal' => 'Rp ' . number_format($totalPrice, 0, ',', '.'),
            'PaymentMethods' => $paymentMethods,
            'CurrentUser' => Security::getCurrentUser(),
        ])->renderWith(['CheckoutPage', 'Page']);
    }

    public function processOrder(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $member = Security::getCurrentUser();

        if (!$request->isPOST()) {
            return $this->redirectBack();
        }

        $ticketTypeID = $request->postVar('ticket_type_id');
        $quantity = (int)$request->postVar('quantity');
        $paymentMethod = $request->postVar('payment_method');
        $useProfile = $request->postVar('use_profile') === 'on';

        error_log('CheckoutPageController::processOrder - Data received:');
        error_log('  TicketTypeID: ' . $ticketTypeID);
        error_log('  Quantity: ' . $quantity);
        error_log('  PaymentMethod: ' . $paymentMethod);
        error_log('  UseProfile: ' . ($useProfile ? 'yes' : 'no'));

        $ticketType = TicketType::get()->byID($ticketTypeID);
        if (!$ticketType || !$ticketType->exists()) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Tipe tiket tidak ditemukan.');
            return $this->redirectBack();
        }

        if ($quantity <= 0) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Jumlah tiket tidak valid.');
            return $this->redirectBack();
        }

        if ($ticketType->Capacity < $quantity) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Tiket yang tersedia hanya ' . $ticketType->Capacity . ' tiket.');
            return $this->redirectBack();
        }

        if (empty($paymentMethod)) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Silakan pilih metode pembayaran.');
            return $this->redirectBack();
        }

        if ($useProfile) {
            $fullName = trim($member->FirstName . ' ' . $member->Surname);
            $email = $member->Email;
            $phone = $member->Phone ?? '';
        } else {
            $fullName = trim($request->postVar('FullName'));
            $email = $request->postVar('Email');
            $phone = $request->postVar('Phone');
        }

        if (empty($fullName) || empty($email)) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Nama lengkap dan email wajib diisi.');
            return $this->redirectBack();
        }

        try {
            $totalPrice = $ticketType->Price * $quantity;

            $paymentFee = 0;
            try {
                $duitku = new DuitkuService();
                $paymentFee = $duitku->calculatePaymentFee($totalPrice, $paymentMethod);
                error_log('CheckoutPageController::processOrder - Payment fee calculated: ' . $paymentFee);
            } catch (Exception $e) {
                error_log('CheckoutPageController::processOrder - Error calculating payment fee: ' . $e->getMessage());
            }

            $order = Order::create();
            $order->MemberID = $member->ID;
            $order->OrderCode = 'EVT-' . date('Y') . '-' . str_pad(Order::get()->count() + 1, 6, '0', STR_PAD_LEFT);
            $order->TicketTypeID = $ticketType->ID;
            $order->Quantity = $quantity;
            $order->TotalPrice = $totalPrice;
            $order->PaymentFee = $paymentFee;
            $order->PaymentMethod = $paymentMethod;
            $order->Status = 'pending_payment';
            $order->PaymentStatus = 'unpaid';
            $order->FullName = $fullName;
            $order->Email = $email;
            $order->Phone = $phone;
            $order->CreatedAt = date('Y-m-d H:i:s');
            $order->UpdatedAt = date('Y-m-d H:i:s');
            $order->write();

            error_log('CheckoutPageController::processOrder - Order created: ' . $order->ID .
                     ' | Total: ' . $totalPrice . ' | Fee: ' . $paymentFee . ' | Grand Total: ' . $order->getGrandTotal());

            return $this->redirect(Director::absoluteBaseURL() . '/payment/initiate/' . $order->ID);

        } catch (ValidationException $e) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Validasi gagal: ' . $e->getMessage());
            return $this->redirectBack();
        } catch (Exception $e) {
            error_log('CheckoutPageController::processOrder - Error: ' . $e->getMessage());
            $this->getRequest()->getSession()->set('CheckoutError', 'Terjadi error: ' . $e->getMessage());
            return $this->redirectBack();
        }
    }

    public function getPaymentMethod(HTTPRequest $request)
    {
        if (!$request->isAjax()) {
            return $this->httpError(400, 'Invalid request');
        }

        $amount = (float) $request->getVar('amount');
        
        if ($amount <= 0) {
            return HTTPResponse::create(
                json_encode(['error' => 'Invalid amount']),
                400
            )->addHeader('Content-Type', 'application/json');
        }

        try {
            $duitku = new DuitkuService();
            $paymentMethods = $duitku->getPaymentMethods($amount);

            return HTTPResponse::create(
                json_encode(['success' => true, 'data' => $paymentMethods]),
                200
            )->addHeader('Content-Type', 'application/json');

        } catch (Exception $e) {
            error_log('CheckoutPageController::getPaymentMethod - Error: ' . $e->getMessage());
            
            return HTTPResponse::create(
                json_encode(['error' => 'Failed to get payment methods']),
                500
            )->addHeader('Content-Type', 'application/json');
        }
    }
}