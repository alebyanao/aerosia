<?php

use SilverStripe\Control\HTTPRequest;
use SilverStripe\ORM\ValidationException;
use SilverStripe\Security\Security;
use SilverStripe\Control\Director;
use SilverStripe\Control\HTTPResponse;

class CheckoutPageController extends PageController
{
    private static $allowed_actions = [
        'index',
        'processOrder'
    ];

    public function index(HTTPRequest $request)
    {
         if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }
        // Ambil data tiket dari POST
        $ticketTypeID = $request->postVar('ticket_type_id');
        $quantity = (int) $request->postVar('quantity');

        if (!$ticketTypeID || $quantity < 1) {
            return $this->customise([
                'ErrorMessage' => 'Tidak ada tiket yang dipilih. Silakan kembali ke halaman event dan pilih tiket.',
                'CurrentUser' => Security::getCurrentUser(), // 🔹 Tambahkan ini
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        $ticketType = TicketType::get()->byID($ticketTypeID);
        if (!$ticketType || !$ticketType->exists()) {
            return $this->customise([
                'ErrorMessage' => 'Tipe tiket tidak ditemukan.',
                'CurrentUser' => Security::getCurrentUser(), // 🔹 Tambahkan ini
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        // Hitung total harga
        $total = $ticketType->Price * $quantity;

        return $this->customise([
            'TicketType' => $ticketType,
            'Quantity' => $quantity,
            'TotalPrice' => $total,
            'FormattedTotal' => 'Rp ' . number_format($total, 0, ',', '.'),
            'CurrentUser' => Security::getCurrentUser(), 
        ])->renderWith(['CheckoutPage', 'Page']);
    }


    public function processOrder(HTTPRequest $request)
    {
        $data = $request->postVars();
        $member = Security::getCurrentUser();

        // Pastikan user sudah login
        if (!$member) {
            $this->getRequest()->getSession()->set('UserMessage', 'Silakan login terlebih dahulu untuk melanjutkan.');
            return $this->redirectBack();
        }

        // Ambil data tiket
        $ticketTypeID = $data['ticket_type_id'] ?? null;
        $quantity = isset($data['quantity']) ? (int)$data['quantity'] : 0;
        $useProfile = isset($data['use_profile']) && $data['use_profile'] == 'on';

        $ticketType = TicketType::get()->byID($ticketTypeID);
        if (!$ticketType) {
            return $this->httpError(404, 'Tipe tiket tidak ditemukan.');
        }

        // Ambil data pemesan
        if ($useProfile) {
            $fullName = trim($member->FirstName . ' ' . $member->Surname);
            $email = $member->Email;
            $phone = $member->Phone ?? '';
        } else {
            $fullName = trim($data['FullName'] ?? '');
            $email = $data['Email'] ?? '';
            $phone = $data['Phone'] ?? '';
        }

        // Validasi data minimal
        if (empty($fullName) || empty($email)) {
            return $this->customise([
                'ErrorMessage' => 'Nama lengkap dan email wajib diisi.'
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        if ($quantity <= 0) {
            return $this->customise([
                'ErrorMessage' => 'Jumlah tiket tidak valid.'
            ])->renderWith(['CheckoutPage', 'Page']);
        }

        try {
            $order = Order::create();
            $order->MemberID = $member->ID;
            $order->TicketTypeID = $ticketType->ID;
            $order->Quantity = $quantity;
            $order->TotalPrice = $ticketType->Price * $quantity;
            $order->Status = 'pending_payment';
            $order->FullName = $fullName;
            $order->Email = $email;
            $order->Phone = $phone;
            $order->write();

            return $this->redirect('/payment?order=' . $order->ID);

        } catch (ValidationException $e) {
            return $this->customise([
                'ErrorMessage' => 'Terjadi kesalahan saat membuat pesanan. Silakan coba lagi.'
            ])->renderWith(['CheckoutPage', 'Page']);
        } catch (Exception $e) {
            return $this->customise([
                'ErrorMessage' => 'Terjadi error tidak terduga: ' . $e->getMessage()
            ])->renderWith(['CheckoutPage', 'Page']);
        }
    }

}
