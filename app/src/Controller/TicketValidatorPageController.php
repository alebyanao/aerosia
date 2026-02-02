<?php

use SilverStripe\Control\HTTPRequest;
use SilverStripe\Control\HTTPResponse;
use SilverStripe\Security\Security;
use SilverStripe\ORM\FieldType\DBDatetime;
use SilverStripe\Security\Permission;

class TicketValidatorPageController extends PageController 
{
    private static $allowed_actions = [
        'index',
        'validateTicket'
    ];

    private static $url_handlers = [
        'validate' => 'validateTicket',
        '' => 'index'
    ];

    public function init()
    {
        parent::init();

        // Harus login
        if (!Security::getCurrentUser()) {
            return Security::permissionFailure(
                $this,
                'Silakan login sebagai admin untuk mengakses scanner.'
            );
        }

        // Harus punya permission SCAN_TICKET
        if (!Permission::check('SCAN_TICKET')) {
            return Security::permissionFailure(
                $this,
                'Anda tidak memiliki hak untuk melakukan scan tiket.'
            );
        }
    }

    public function index(HTTPRequest $request)
    {
        return $this->renderWith(['TicketValidatorPage', 'Page']);
    }

    public function validateTicket(HTTPRequest $request)
    {
        if (!$request->isPOST()) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Method not allowed'], 405);
        }

        $code = $request->postVar('code');

        if (!$code) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Kode tidak terbaca'], 400);
        }

        // 1. Cari Order berdasarkan OrderCode
        // Asumsi: QR Code Anda berisi OrderCode (misal: INV-ORD-123)
        $order = Order::get()->filter(['OrderCode' => $code])->first();

        // Jika tidak ketemu via OrderCode, coba cari via QRCodeData (jika Anda pakai hash unik)
        if (!$order) {
            $order = Order::get()->filter(['QRCodeData' => $code])->first();
        }

        // Cek 1: Tiket ditemukan?
        if (!$order) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Tiket TIDAK DITEMUKAN!'], 404);
        }

        // Cek 2: Apakah sudah lunas?
        if ($order->PaymentStatus != 'paid') {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Tiket BELUM LUNAS. Status: ' . $order->PaymentStatus], 400);
        }

        // Cek 3: Apakah sudah pernah discan? (Logic Hangus)
        if ($order->QRCodeScanned) {
            $scanTime = date('d M Y H:i', strtotime($order->ScannedAt));
            $scanner = $order->ScannedBy ? " oleh " . $order->ScannedBy : "";
            
            return $this->jsonResponse([
                'status' => 'error', 
                'message' => "Tiket SUDAH DIGUNAKAN!",
                'detail' => "Check-in pada: $scanTime $scanner",
                'data' => [
                    'Name' => $order->FullName,
                    'Ticket' => $order->TicketType()->TypeName
                ]
            ], 400);
        }

        // == LOLOS VALIDASI: UPDATE DATA ==
        
        $order->QRCodeScanned = true; // Tandai sudah dipakai
        $order->ScannedAt = DBDatetime::now()->getValue();
        
        // Catat siapa yang scan (Admin/Staff yang sedang login)
        $currentUser = Security::getCurrentUser();
        $order->ScannedBy = $currentUser ? $currentUser->FirstName : 'System';
        
        $order->write();

        return $this->jsonResponse([
            'status' => 'success',
            'message' => 'Check-in Berhasil!',
            'data' => [
                'Name' => $order->FullName,
                'Ticket' => $order->TicketType()->TypeName,
                'Qty' => $order->Quantity
            ]
        ]);
    }

    private function jsonResponse($data, $code = 200)
    {
        $response = new HTTPResponse(json_encode($data), $code);
        $response->addHeader('Content-Type', 'application/json');
        return $response;
    }

    
}