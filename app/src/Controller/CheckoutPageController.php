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
        // PENTING: Definisikan $member di awal
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $member = Security::getCurrentUser(); // DEFINISIKAN MEMBER DI SINI

        // Ambil data tiket dari POST atau GET
        $ticketTypeID = $request->postVar('ticket_type_id') ?? $request->getVar('ticket_type_id');
        $quantity = (int) ($request->postVar('quantity') ?? $request->getVar('quantity'));

        error_log('CheckoutPageController::index - TicketTypeID: ' . $ticketTypeID);
        error_log('CheckoutPageController::index - Quantity: ' . $quantity);

        if (!$ticketTypeID || $quantity < 1) {
            return $this->customise([
                'ErrorMessage' => 'Tidak ada tiket yang dipilih. Silakan kembali ke halaman event dan pilih tiket.',
                'CurrentUser' => $member,
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        $ticketType = TicketType::get()->byID($ticketTypeID);
        if (!$ticketType || !$ticketType->exists()) {
            return $this->customise([
                'ErrorMessage' => 'Tipe tiket tidak ditemukan.',
                'CurrentUser' => $member,
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        // VALIDASI 1: Cek kapasitas tiket
        if ($ticketType->Capacity < $quantity) {
            return $this->customise([
                'ErrorMessage' => 'Maaf, tiket yang tersedia hanya ' . $ticketType->Capacity . ' tiket.',
                'CurrentUser' => $member,
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        // VALIDASI 2: Cek MaxPerMember
        $canPurchase = Order::canMemberPurchaseMore($member->ID, $ticketTypeID, $quantity);
        $remainingQuota = Order::getRemainingQuota($member->ID, $ticketTypeID);
        
        if (!$canPurchase) {
            $totalPurchased = Order::getTotalPurchasedByMember($member->ID, $ticketTypeID);
            
            $errorMsg = 'Anda telah membeli ' . $totalPurchased . ' tiket dari tipe ini. ';
            $errorMsg .= 'Maksimal pembelian per member adalah ' . $ticketType->MaxPerMember . ' tiket. ';
            
            if ($remainingQuota > 0) {
                $errorMsg .= 'Anda hanya dapat membeli ' . $remainingQuota . ' tiket lagi.';
            } else {
                $errorMsg .= 'Anda tidak dapat membeli tiket ini lagi.';
            }
            
            error_log('CheckoutPageController::index - MaxPerMember limit reached');
            
            return $this->customise([
                'ErrorMessage' => $errorMsg,
                'CurrentUser' => $member,
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        // Hitung total harga tiket
        $totalPrice = $ticketType->Price * $quantity;
        $isFreeTicket = ($totalPrice <= 0);

        error_log('CheckoutPageController::index - Total Price: ' . $totalPrice . ' | Is Free: ' . ($isFreeTicket ? 'yes' : 'no'));

        // Ambil payment methods dari Duitku (hanya jika bukan tiket gratis)
        $paymentMethods = new ArrayList();
        if (!$isFreeTicket) {
            try {
                $duitku = new DuitkuService();
                $rawPaymentMethods = $duitku->getPaymentMethods($totalPrice);
                
                error_log('CheckoutPageController::index - Raw payment methods: ' . json_encode($rawPaymentMethods));
                
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
        }

        return $this->customise([
            'TicketType' => $ticketType,
            'Ticket' => $ticketType->Ticket(),
            'Quantity' => $quantity,
            'TotalPrice' => $totalPrice,
            'FormattedTotal' => 'Rp ' . number_format($totalPrice, 0, ',', '.'),
            'PaymentMethods' => $paymentMethods,
            'CurrentUser' => $member,
            'IsFreeTicket' => $isFreeTicket,
            'RemainingQuota' => $remainingQuota,
        ])->renderWith(['CheckoutPage', 'Page']);
    }

    public function processOrder(HTTPRequest $request)
    {
        // PENTING: Definisikan $member di awal
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $member = Security::getCurrentUser(); // DEFINISIKAN MEMBER DI SINI

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
        error_log('  MemberID: ' . $member->ID);

        $ticketType = TicketType::get()->byID($ticketTypeID);
        if (!$ticketType || !$ticketType->exists()) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Tipe tiket tidak ditemukan.');
            return $this->redirectBack();
        }

        if ($quantity <= 0) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Jumlah tiket tidak valid.');
            return $this->redirectBack();
        }

        // VALIDASI KAPASITAS
        if ($ticketType->Capacity < $quantity) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Tiket yang tersedia hanya ' . $ticketType->Capacity . ' tiket.');
            return $this->redirectBack();
        }

        // VALIDASI MAXPERMEMBER - PENTING!
        if (!Order::canMemberPurchaseMore($member->ID, $ticketTypeID, $quantity)) {
            $totalPurchased = Order::getTotalPurchasedByMember($member->ID, $ticketTypeID);
            $remainingQuota = Order::getRemainingQuota($member->ID, $ticketTypeID);
            
            $errorMsg = 'Anda telah membeli ' . $totalPurchased . ' tiket dari tipe ini. ';
            $errorMsg .= 'Maksimal pembelian adalah ' . $ticketType->MaxPerMember . ' tiket per member. ';
            
            if ($remainingQuota > 0) {
                $errorMsg .= 'Anda hanya dapat membeli ' . $remainingQuota . ' tiket lagi.';
            } else {
                $errorMsg .= 'Anda telah mencapai batas maksimal pembelian.';
            }
            
            error_log('CheckoutPageController::processOrder - MaxPerMember validation failed');
            $this->getRequest()->getSession()->set('CheckoutError', $errorMsg);
            return $this->redirectBack();
        }

        $totalPrice = $ticketType->Price * $quantity;
        $isFreeTicket = ($totalPrice <= 0);

        if (!$isFreeTicket && empty($paymentMethod)) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Silakan pilih metode pembayaran.');
            return $this->redirectBack();
        }

        if ($useProfile) {
            $fullName = trim($member->FirstName . ' ' . $member->Surname);
            $email = $member->Email;
        } else {
            $fullName = trim($request->postVar('FullName'));
            $email = $request->postVar('Email');
        }

        if (empty($fullName) || empty($email)) {
            $this->getRequest()->getSession()->set('CheckoutError', 'Nama lengkap dan email wajib diisi.');
            return $this->redirectBack();
        }

        try {
            $paymentFee = 0;
            if (!$isFreeTicket) {
                try {
                    $duitku = new DuitkuService();
                    $paymentFee = $duitku->calculatePaymentFee($totalPrice, $paymentMethod);
                    error_log('CheckoutPageController::processOrder - Payment fee calculated: ' . $paymentFee);
                } catch (Exception $e) {
                    error_log('CheckoutPageController::processOrder - Error calculating payment fee: ' . $e->getMessage());
                }
            }

            $order = Order::create();
            $order->MemberID = $member->ID;
            $order->OrderCode = 'EVT-' . date('Y') . '-' . str_pad(Order::get()->count() + 1, 6, '0', STR_PAD_LEFT);
            $order->TicketTypeID = $ticketType->ID;
            $order->Quantity = $quantity;
            $order->TotalPrice = $totalPrice;
            $order->PaymentFee = $paymentFee;
            $order->PaymentMethod = $isFreeTicket ? 'free' : $paymentMethod;
            $order->Status = $isFreeTicket ? 'completed' : 'pending_payment';
            $order->PaymentStatus = $isFreeTicket ? 'paid' : 'unpaid';
            $order->FullName = $fullName;
            $order->Email = $email;
            $order->CreatedAt = date('Y-m-d H:i:s');
            $order->UpdatedAt = date('Y-m-d H:i:s');
            
            if ($isFreeTicket) {
                $order->CompletedAt = date('Y-m-d H:i:s');
            }
            
            $order->write();

            // Generate unique QR code data
            $order->QRCodeData = 'TICKET-' . $order->ID . '-' . md5($order->OrderCode . $order->CreatedAt);
            $order->write();

            error_log('CheckoutPageController::processOrder - Order created: ' . $order->ID .
                     ' | Total: ' . $totalPrice . ' | Fee: ' . $paymentFee . ' | Grand Total: ' . $order->getGrandTotal());

            // HANDLE TIKET GRATIS
            if ($isFreeTicket) {
                error_log('CheckoutPageController::processOrder - Free ticket detected, processing automatically');
                
                if ($order->markAsPaid()) {
                    error_log('CheckoutPageController::processOrder - Free ticket marked as paid and capacity reduced');
                    
                    try {
                        InvoiceController::sendInvoiceAfterPayment($order);
                        $this->getRequest()->getSession()->set('OrderSuccess', 
                            'Selamat! Tiket gratis Anda berhasil dipesan. Invoice dan tiket telah dikirim ke email ' . $order->Email);
                    } catch (Exception $e) {
                        error_log('CheckoutPageController::processOrder - Failed to send invoice: ' . $e->getMessage());
                        $this->getRequest()->getSession()->set('OrderSuccess', 
                            'Selamat! Tiket gratis Anda berhasil dipesan.');
                    }
                    
                    return $this->redirect(Director::absoluteBaseURL() . '/order/detail/' . $order->ID);
                    
                } else {
                    error_log('CheckoutPageController::processOrder - Failed to mark free ticket as paid');
                    $this->getRequest()->getSession()->set('CheckoutError', 
                        'Gagal memproses tiket gratis. Kapasitas mungkin tidak mencukupi. Silakan coba lagi.');
                    return $this->redirectBack();
                }
            }

            // HANDLE TIKET BERBAYAR - Lanjut ke payment gateway
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