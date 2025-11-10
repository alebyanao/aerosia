<?php

use SilverStripe\Control\HTTPRequest;
use SilverStripe\Control\HTTPResponse;
use SilverStripe\Security\Security;

class TicketScannerController extends PageController
{
    private static $allowed_actions = [
        'index',
        'scan',
        'verify'
    ];

    private static $url_handlers = [
        'scan' => 'scan',
        'verify' => 'verify',
        '' => 'index'
    ];

    /**
     * Scanner page (untuk admin)
     */
    public function index(HTTPRequest $request)
    {
        $user = Security::getCurrentUser();
        
        if (!$user || !$user->inGroup('administrators')) {
            return $this->httpError(403, 'Access denied');
        }

        return $this->customise([
            'Title' => 'Scanner Tiket',
            'CurrentUser' => $user
        ])->renderWith(['TicketScannerPage', 'Page']);
    }

    /**
     * Verify QR code via AJAX
     */
    public function verify(HTTPRequest $request)
    {
        if (!$request->isAjax() || !$request->isPOST()) {
            return $this->httpError(400, 'Invalid request');
        }

        $user = Security::getCurrentUser();
        if (!$user || !$user->inGroup('administrators')) {
            return HTTPResponse::create(
                json_encode(['error' => 'Unauthorized']),
                403
            )->addHeader('Content-Type', 'application/json');
        }

        $qrData = $request->postVar('qr_data');
        
        if (!$qrData) {
            return HTTPResponse::create(
                json_encode(['error' => 'QR data required']),
                400
            )->addHeader('Content-Type', 'application/json');
        }

        $result = QRCodeService::verifyQRCode($qrData);
        
        if ($result['valid']) {
            $order = $result['order'];
            $ticketType = $order->TicketType();
            $ticket = $ticketType ? $ticketType->Ticket() : null;
            
            return HTTPResponse::create(
                json_encode([
                    'valid' => true,
                    'message' => $result['message'],
                    'data' => [
                        'order_code' => $order->OrderCode,
                        'buyer_name' => $order->FullName,
                        'buyer_email' => $order->Email,
                        'event_name' => $ticket ? $ticket->Title : '-',
                        'ticket_type' => $ticketType ? $ticketType->TypeName : '-',
                        'quantity' => $order->Quantity,
                        'order_id' => $order->ID
                    ]
                ]),
                200
            )->addHeader('Content-Type', 'application/json');
        }
        
        return HTTPResponse::create(
            json_encode([
                'valid' => false,
                'message' => $result['message']
            ]),
            200
        )->addHeader('Content-Type', 'application/json');
    }

    /**
     * Mark ticket as scanned
     */
    public function scan(HTTPRequest $request)
    {
        if (!$request->isAjax() || !$request->isPOST()) {
            return $this->httpError(400, 'Invalid request');
        }

        $user = Security::getCurrentUser();
        if (!$user || !$user->inGroup('administrators')) {
            return HTTPResponse::create(
                json_encode(['error' => 'Unauthorized']),
                403
            )->addHeader('Content-Type', 'application/json');
        }

        $qrData = $request->postVar('qr_data');
        
        $result = QRCodeService::verifyQRCode($qrData);
        
        if (!$result['valid']) {
            return HTTPResponse::create(
                json_encode(['success' => false, 'message' => $result['message']]),
                200
            )->addHeader('Content-Type', 'application/json');
        }

        $order = $result['order'];
        QRCodeService::markAsScanned($order, $user->getName());
        
        return HTTPResponse::create(
            json_encode([
                'success' => true,
                'message' => 'Tiket berhasil di-scan'
            ]),
            200
        )->addHeader('Content-Type', 'application/json');
    }
}