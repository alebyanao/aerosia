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

    /**
     * Mendaftarkan permission SCAN_TICKET ke CMS.
     * Setelah flush, Anda bisa melihat ini di Security > Groups > Permissions.
     */
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

        // 1. Harus login
        if (!$user) {
            return Security::permissionFailure(
                $this,
                'Silakan login untuk mengakses scanner.'
            );
        }

        /**
         * 2. Cek Hak Akses
         * Permission::check otomatis mengembalikan TRUE jika:
         * - User adalah Superadmin (memiliki akses ADMIN)
         * - User berada di grup yang sudah kita centang "Bisa melakukan Scan Tiket"
         */
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

        // Cari Order berdasarkan OrderCode atau QRCodeData
        $order = Order::get()->filterAny([
            'OrderCode' => $code,
            'QRCodeData' => $code
        ])->first();

        // Cek 1: Tiket ditemukan?
        if (!$order) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Tiket TIDAK DITEMUKAN!'], 404);
        }

        // Cek 2: Apakah sudah lunas?
        if ($order->PaymentStatus != 'paid') {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Tiket BELUM LUNAS.'], 400);
        }

        // Cek 3: Apakah sudah pernah discan?
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