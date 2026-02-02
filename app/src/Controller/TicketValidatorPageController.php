<?php

use SilverStripe\Control\HTTPRequest;
use SilverStripe\Control\HTTPResponse;
use SilverStripe\Security\Security;
use SilverStripe\ORM\FieldType\DBDatetime;
use SilverStripe\Security\Permission;
use SilverStripe\Security\PermissionProvider;

class TicketValidatorPageController extends PageController implements PermissionProvider
{
    private static $allowed_actions = [
        'index',
        'validateTicket'
    ];

    private static $url_handlers = [
        'validate' => 'validateTicket',
        '' => 'index'
    ];

    public function providePermissions()
    {
        return [
            'SCAN_TICKET' => [
                'name' => 'Bisa melakukan Scan Tiket',
                'category' => 'Akses Event',
                'help' => 'Izinkan user ini untuk menggunakan scanner tiket'
            ]
        ];
    }

    public function init()
    {
        parent::init();
        $user = Security::getCurrentUser();

        if (!$user) {
            return Security::permissionFailure($this, 'Silakan login.');
        }

        if (!Permission::check('SCAN_TICKET')) {
            return Security::permissionFailure($this, 'Akses ditolak.');
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

        $order = Order::get()->filterAny([
            'OrderCode' => $code,
            'QRCodeData' => $code
        ])->first();

        if (!$order) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Tiket TIDAK DITEMUKAN!'], 404);
        }

        if ($order->PaymentStatus != 'paid') {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Tiket BELUM LUNAS.'], 400);
        }

        if ($order->QRCodeScanned) {
            return $this->jsonResponse([
                'status' => 'error', 
                'message' => "Tiket SUDAH DIGUNAKAN!",
                'detail' => "Check-in pada: " . date('d M Y H:i', strtotime($order->ScannedAt))
            ], 400);
        }

        // UPDATE DATA
        $currentUser = Security::getCurrentUser();
        $order->QRCodeScanned = true;
        $order->ScannedAt = DBDatetime::now()->getValue();
        $order->ScannedBy = $currentUser ? ($currentUser->FirstName . ' ' . $currentUser->Surname) : 'System';
        $order->write();

        return $this->jsonResponse([
            'status' => 'success',
            'message' => 'Check-in Berhasil!',
            'data' => [
                'Name' => $order->FullName,
                'Ticket' => $order->TicketType()->TypeName
            ]
        ]);
    }
}