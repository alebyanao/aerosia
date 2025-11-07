<?php

use SilverStripe\Control\Director;
use SilverStripe\Control\HTTPRequest;
use SilverStripe\Control\HTTPResponse;
use SilverStripe\Security\Security;

class OrderPageController extends PageController
{
    private static $allowed_actions = [
        'index',
        'detail',
        'cancelOrder',
        'resendInvoice'
    ];

    private static $url_handlers = [
        'detail/$ID' => 'detail',
        'cancel/$ID' => 'cancelOrder',
        'resend-invoice/$ID' => 'resendInvoice',
        '' => 'index'
    ];

    /**
     * List all orders for current user
     */
    public function index(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $user = $this->getCurrentUser();

        error_log('OrderPageController::index - User ID: ' . $user->ID);

        // Auto-cancel expired orders
        $expiredOrders = Order::get()->filter([
            'MemberID' => $user->ID,
            'Status' => ['pending', 'pending_payment'],
            'PaymentStatus' => 'unpaid'
        ]);

        foreach ($expiredOrders as $order) {
            if ($order->checkAndCancelIfExpired()) {
                error_log('OrderPageController::index - Auto-cancelled expired order: ' . $order->ID);
            }
        }

        // Get all orders for this user
        $orders = Order::get()
            ->filter('MemberID', $user->ID)
            ->sort('Created DESC');

        error_log('OrderPageController::index - Total orders: ' . $orders->count());

        // Get filter from query string
        $statusFilter = $request->getVar('status');
        
        if ($statusFilter) {
            switch ($statusFilter) {
                case 'pending':
                    $orders = $orders->filter('Status', ['pending', 'pending_payment']);
                    break;
                case 'completed':
                    $orders = $orders->filter('Status', 'completed');
                    break;
                case 'cancelled':
                    $orders = $orders->filter('Status', 'cancelled');
                    break;
            }
        }

        $data = [
            'Orders' => $orders,
            'Title' => 'Daftar Pesanan Tiket',
            'CurrentUser' => $user,
            'StatusFilter' => $statusFilter
        ];

        return $this->customise($data)->renderWith(['OrderPage', 'Page']);
    }

    /**
     * Order detail page
     */
    public function detail(HTTPRequest $request)
    {
        $orderID = $request->param('ID');

        error_log('OrderPageController::detail - Order ID: ' . $orderID);

        if (!$orderID) {
            return $this->httpError(400, 'Order ID required');
        }

        $order = Order::get()->byID($orderID);

        if (!$order || !$order->exists()) {
            error_log('OrderPageController::detail - Order not found: ' . $orderID);
            return $this->httpError(404, 'Order not found');
        }

        // Check ownership
        $currentUser = $this->getCurrentUser();
        if (!$currentUser || $order->MemberID != $currentUser->ID) {
            error_log('OrderPageController::detail - Access denied for user: ' . ($currentUser ? $currentUser->ID : 'not logged in'));
            return $this->httpError(403, 'Access denied');
        }

        // Auto-cancel if expired
        $wasCancelled = $order->checkAndCancelIfExpired();
        if ($wasCancelled) {
            error_log('OrderPageController::detail - Order auto-cancelled: ' . $orderID);
            $request->getSession()->set('OrderWarning', 'Pesanan ini telah dibatalkan karena melewati batas waktu pembayaran.');
        }

        // Get ticket type and event info
        $ticketType = $order->TicketType();
        $ticket = $ticketType ? $ticketType->Ticket() : null;

        // Get payment transactions
        $transactions = PaymentTransaction::get()
            ->filter('OrderID', $order->ID)
            ->sort('CreatedAt DESC')
            ->limit(10); // Limit to last 10 transactions

        // Calculate time remaining for payment (if pending)
        $timeRemaining = null;
        if (in_array($order->Status, ['pending', 'pending_payment']) && $order->ExpiresAt) {
            $now = time();
            $expiryTime = strtotime($order->ExpiresAt);
            $diff = $expiryTime - $now;
            
            if ($diff > 0) {
                $hours = floor($diff / 3600);
                $minutes = floor(($diff % 3600) / 60);
                $timeRemaining = sprintf('%d jam %d menit', $hours, $minutes);
            }
        }

        $data = [
            'Order' => $order,
            'TicketType' => $ticketType,
            'Ticket' => $ticket,
            'Transactions' => $transactions,
            'TimeRemaining' => $timeRemaining,
            'Title' => 'Detail Pesanan ' . $order->OrderCode,
            'CurrentUser' => $currentUser,
            
            // Session messages
            'OrderSuccess' => $request->getSession()->get('OrderSuccess'),
            'OrderError' => $request->getSession()->get('OrderError'),
            'OrderWarning' => $request->getSession()->get('OrderWarning'),
            'PaymentSuccess' => $request->getSession()->get('PaymentSuccess'),
            'PaymentError' => $request->getSession()->get('PaymentError'),
            'InvoiceSuccess' => $request->getSession()->get('InvoiceSuccess'),
            'InvoiceError' => $request->getSession()->get('InvoiceError'),
        ];

        // Clear session messages after retrieving
        $request->getSession()->clear('OrderSuccess');
        $request->getSession()->clear('OrderError');
        $request->getSession()->clear('OrderWarning');
        $request->getSession()->clear('PaymentSuccess');
        $request->getSession()->clear('PaymentError');
        $request->getSession()->clear('InvoiceSuccess');
        $request->getSession()->clear('InvoiceError');

        return $this->customise($data)->renderWith(['OrderDetailPage', 'Page']);
    }

    /**
     * Cancel order
     */
    public function cancelOrder(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $orderID = $request->param('ID');
        
        error_log('OrderPageController::cancelOrder - Order ID: ' . $orderID);

        if (!$orderID) {
            $request->getSession()->set('OrderError', 'Order ID tidak ditemukan');
            return $this->redirectBack();
        }

        $order = Order::get()->filter([
            'ID' => $orderID,
            'MemberID' => $this->getCurrentUser()->ID
        ])->first();

        if (!$order) {
            error_log('OrderPageController::cancelOrder - Order not found or access denied');
            $request->getSession()->set('OrderError', 'Pesanan tidak ditemukan atau Anda tidak memiliki akses');
            return $this->redirect(Director::absoluteBaseURL() . 'order');
        }

        // Check if order can be cancelled
        if (!$order->canBeCancelled()) {
            error_log('OrderPageController::cancelOrder - Order cannot be cancelled. Status: ' . $order->Status);
            $request->getSession()->set('OrderError', 'Pesanan dengan status "' . $order->Status . '" tidak dapat dibatalkan');
            return $this->redirect(Director::absoluteBaseURL() . 'order/detail/' . $orderID);
        }

        // Cancel the order
        if ($order->cancelOrder()) {
            error_log('OrderPageController::cancelOrder - Order cancelled successfully: ' . $order->OrderCode);
            $request->getSession()->set('OrderSuccess', 'Pesanan ' . $order->OrderCode . ' berhasil dibatalkan');
        } else {
            error_log('OrderPageController::cancelOrder - Failed to cancel order');
            $request->getSession()->set('OrderError', 'Gagal membatalkan pesanan. Silakan coba lagi');
        }

        return $this->redirect(Director::absoluteBaseURL() . '/order/detail/' . $orderID);
    }

    /**
     * Resend invoice email
     */
    public function resendInvoice(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $orderID = $request->param('ID');
        
        error_log('OrderPageController::resendInvoice - Order ID: ' . $orderID);

        if (!$orderID) {
            $request->getSession()->set('InvoiceError', 'Order ID tidak ditemukan');
            return $this->redirectBack();
        }

        $order = Order::get()->filter([
            'ID' => $orderID,
            'MemberID' => $this->getCurrentUser()->ID
        ])->first();

        if (!$order) {
            error_log('OrderPageController::resendInvoice - Order not found or access denied');
            $request->getSession()->set('InvoiceError', 'Pesanan tidak ditemukan atau Anda tidak memiliki akses');
            return $this->redirect(Director::absoluteBaseURL() . 'order');
        }

        // Only allow resend for completed orders with paid status
        if ($order->Status != 'completed' || $order->PaymentStatus != 'paid') {
            error_log('OrderPageController::resendInvoice - Order not completed. Status: ' . $order->Status . ', Payment: ' . $order->PaymentStatus);
            $request->getSession()->set('InvoiceError', 'Invoice hanya dapat dikirim untuk pesanan yang sudah selesai');
            return $this->redirect(Director::absoluteBaseURL() . 'order/detail/' . $orderID);
        }

        // Resend invoice
        try {
            error_log('OrderPageController::resendInvoice - Attempting to send invoice to: ' . $order->Email);
            
            $result = InvoiceController::sendInvoiceAfterPayment($order);
            
            if ($result) {
                error_log('OrderPageController::resendInvoice - Invoice sent successfully');
                $request->getSession()->set('InvoiceSuccess', 'Invoice berhasil dikirim ulang ke ' . $order->Email);
            } else {
                error_log('OrderPageController::resendInvoice - Failed to send invoice');
                $request->getSession()->set('InvoiceError', 'Gagal mengirim invoice. Silakan coba lagi');
            }
            
        } catch (Exception $e) {
            error_log('OrderPageController::resendInvoice - Exception: ' . $e->getMessage());
            $request->getSession()->set('InvoiceError', 'Terjadi kesalahan: ' . $e->getMessage());
        }

        return $this->redirect(Director::absoluteBaseURL() . 'order/detail/' . $orderID);
    }

    /**
     * Get order statistics for current user
     */
    public function getOrderStats()
    {
        if (!$this->isLoggedIn()) {
            return null;
        }

        $user = $this->getCurrentUser();

        $stats = [
            'Total' => Order::get()->filter('MemberID', $user->ID)->count(),
            'Pending' => Order::get()->filter([
                'MemberID' => $user->ID,
                'Status' => ['pending', 'pending_payment']
            ])->count(),
            'Completed' => Order::get()->filter([
                'MemberID' => $user->ID,
                'Status' => 'completed'
            ])->count(),
            'Cancelled' => Order::get()->filter([
                'MemberID' => $user->ID,
                'Status' => 'cancelled'
            ])->count(),
        ];

        return $stats;
    }
}