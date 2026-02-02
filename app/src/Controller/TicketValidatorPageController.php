<?php

use SilverStripe\Control\HTTPRequest;
use SilverStripe\Security\Security;
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
            ]
        ];
    }

    public function init()
    {
        parent::init();
        if (!Security::getCurrentUser() || !Permission::check('SCAN_TICKET')) {
            return Security::permissionFailure($this, 'Akses scanner ditolak.');
        }
    }

    public function index(HTTPRequest $request)
    {
        return $this->renderWith(['TicketValidatorPage', 'Page']);
    }

    /**
     * LOGIC BARU: Mencari berdasarkan kepingan tiket (OrderItem)
     */
    public function validateTicket(HTTPRequest $request)
    {
        if (!$request->isPOST()) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Method not allowed'], 405);
        }

        $code = $request->postVar('code'); // Berisi misal: EVT-2026-000058-1

        if (!$code) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'Kode tidak terbaca'], 400);
        }

        // 1. CARI DI TABEL OrderItem (Bukan tabel Order)
        $ticketItem = OrderItem::get()->filter(['TicketCode' => $code])->first();

        if (!$ticketItem) {
            return $this->jsonResponse(['status' => 'error', 'message' => 'TIKET TIDAK VALID!'], 404);
        }

        // 2. Cek status pembayaran dari Order induknya
        $parentOrder = $ticketItem->Order();
        if (!$parentOrder || $parentOrder->PaymentStatus != 'paid') {
            return $this->jsonResponse(['status' => 'error', 'message' => 'ORDER BELUM LUNAS!'], 400);
        }

        // 3. Cek apakah keping tiket spesifik ini sudah pernah digunakan
        if ($ticketItem->IsScanned) {
            $scanTime = date('d M Y H:i', strtotime($ticketItem->ScannedAt));
            return $this->jsonResponse([
                'status' => 'error', 
                'message' => "TIKET SUDAH TERPAKAI!",
                'detail' => "Check-in: $scanTime oleh $ticketItem->ScannedBy"
            ], 400);
        }

        // == LOLOS VALIDASI: UPDATE DATA ITEM ==
        $currentUser = Security::getCurrentUser();
        
        $ticketItem->IsScanned = true;
        $ticketItem->ScannedAt = date('Y-m-d H:i:s');
        $ticketItem->ScannedBy = $currentUser ? $currentUser->FirstName : 'System';
        $ticketItem->write();

        return $this->jsonResponse([
            'status' => 'success',
            'message' => 'Check-in Berhasil!',
            'data' => [
                'Name' => $parentOrder->FullName,
                'Type' => $ticketItem->TicketType()->TypeName,
                'Code' => $ticketItem->TicketCode
            ]
        ]);
    }

    /**
     * SOLUSI ERROR GAMBAR 1: 
     * Pastikan visibilitas protected agar kompatibel dengan PageController
     */
    protected function jsonResponse($data, $code = 200)
    {
        $response = $this->getResponse();
        $response->setStatusCode($code);
        $response->addHeader('Content-Type', 'application/json');
        $response->setBody(json_encode($data));
        return $response;
    }
}