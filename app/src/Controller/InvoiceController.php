<?php

// FILE: app/src/Controllers/InvoiceController.php
// UPDATED VERSION dengan QR Code Generation

use SilverStripe\Control\Director;
use SilverStripe\Control\Email\Email;
use SilverStripe\Control\HTTPRequest;
use SilverStripe\Control\HTTPResponse;
use SilverStripe\Core\Environment;
use SilverStripe\SiteConfig\SiteConfig;
use Dompdf\Dompdf;
use Dompdf\Options;
use Endroid\QrCode\QrCode;
use Endroid\QrCode\Writer\PngWriter;

class InvoiceController extends PageController
{
    private static $allowed_actions = [
        'generateInvoice',
        'sendInvoiceEmail',
        'downloadInvoice'
    ];

    private static $url_handlers = [
        'generate/$ID' => 'generateInvoice',
        'send/$ID' => 'sendInvoiceEmail',
        'download/$ID' => 'downloadInvoice'
    ];

    /**
     * Generate PDF invoice
     */
    public function generateInvoice(HTTPRequest $request)
    {
        $orderID = $request->param('ID');

        if (!$orderID) {
            return $this->httpError(400, 'Order ID required');
        }

        $order = Order::get()->byID($orderID);

        if (!$order) {
            return $this->httpError(404, 'Order not found');
        }

        $currentUser = $this->getCurrentUser();
        if (!$currentUser || ($order->MemberID != $currentUser->ID && !$currentUser->inGroup('administrators'))) {
            return $this->httpError(403, 'Access denied');
        }

        $pdfContent = $this->generatePDFContent($order);

        return HTTPResponse::create($pdfContent, 200)
            ->addHeader('Content-Type', 'application/pdf')
            ->addHeader('Content-Disposition', 'inline; filename="Invoice-' . $order->OrderCode . '.pdf"');
    }

    /**
     * Send invoice via email
     */
    public function sendInvoiceEmail(HTTPRequest $request)
    {
        $orderID = $request->param('ID');

        if (!$orderID) {
            return $this->httpError(400, 'Order ID required');
        }

        $order = Order::get()->byID($orderID);

        if (!$order) {
            return $this->httpError(404, 'Order not found');
        }

        $currentUser = $this->getCurrentUser();
        if (!$currentUser || ($order->MemberID != $currentUser->ID && !$currentUser->inGroup('administrators'))) {
            return $this->httpError(403, 'Access denied');
        }

        $result = $this->sendInvoiceToMember($order);

        if ($result) {
            $request->getSession()->set('InvoiceSuccess', 'Invoice berhasil dikirim ke email');
        } else {
            $request->getSession()->set('InvoiceError', 'Gagal mengirim invoice ke email');
        }

        return $this->redirect(Director::absoluteBaseURL() . '/order/detail/' . $orderID);
    }

    /**
     * Download invoice PDF
     */
    public function downloadInvoice(HTTPRequest $request)
    {
        $orderID = $request->param('ID');

        if (!$orderID) {
            return $this->httpError(400, 'Order ID required');
        }

        $order = Order::get()->byID($orderID);

        if (!$order) {
            return $this->httpError(404, 'Order not found');
        }

        $currentUser = $this->getCurrentUser();
        if (!$currentUser || ($order->MemberID != $currentUser->ID && !$currentUser->inGroup('administrators'))) {
            return $this->httpError(403, 'Access denied');
        }

        $pdfContent = $this->generatePDFContent($order);

        return HTTPResponse::create($pdfContent, 200)
            ->addHeader('Content-Type', 'application/pdf')
            ->addHeader('Content-Disposition', 'attachment; filename="Invoice-' . $order->OrderCode . '.pdf"');
    }

    /**
     * ✅ IMPROVED: Generate QR Code dari TicketCode
     */
    private function generateQRCode($ticketCode)
    {
        try {
            $qrCode = new QrCode($ticketCode);
            $qrCode->setSize(300);
            $qrCode->setMargin(10);

            $writer = new PngWriter();
            $result = $writer->write($qrCode);
            
            $imageData = $result->getString();
            return 'data:image/png;base64,' . base64_encode($imageData);
        } catch (Exception $e) {
            error_log('InvoiceController::generateQRCode - Error: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * ✅ IMPROVED: Prepare invoice data dengan QR codes
     */
    private function prepareInvoiceData($order)
    {
        $siteConfig = SiteConfig::current_site_config();
        $ticketType = $order->TicketType();
        $ticket = $ticketType ? $ticketType->Ticket() : null;
        
        // PENTING: Ambil OrderItems
        $orderItems = $order->OrderItems();
        
        // ✅ BARU: Generate QR code untuk tiap item
        $qrCodes = [];
        foreach ($orderItems as $index => $item) {
            $qrCodeImage = $this->generateQRCode($item->TicketCode);
            $qrCodes[] = [
                'TicketCode' => $item->TicketCode,
                'QRCode' => $qrCodeImage,
                'Position' => $index + 1,
            ];
        }

        return [
            'Order' => $order,
            'Member' => $order->Member(),
            'OrderItems' => $orderItems,
            'QRCodes' => $qrCodes, // ✅ BARU
            'TicketType' => $ticketType,
            'Ticket' => $ticket,
            'EventName' => $ticket ? $ticket->Title : 'Event',
            'EventDate' => $ticket ? $ticket->EventDate : '',
            'EventLocation' => $ticket ? $ticket->Location : '',
            'TicketTypeName' => $ticketType ? $ticketType->TypeName : '',
            'Quantity' => $order->Quantity,
            'UnitPrice' => $ticketType ? $ticketType->Price : 0,
            'FormattedUnitPrice' => 'Rp ' . number_format($ticketType ? $ticketType->Price : 0, 0, ',', '.'),
            
            'BuyerName' => $order->FullName,
            'BuyerEmail' => $order->Email,
            'BuyerPhone' => $order->Phone,
            
            'TotalPrice' => $order->TotalPrice,
            'FormattedTotalPrice' => $order->getFormattedTotalPrice(),
            'PaymentFee' => $order->PaymentFee,
            'FormattedPaymentFee' => $order->getFormattedPaymentFee(),
            'GrandTotal' => $order->getGrandTotal(),
            'FormattedGrandTotal' => $order->getFormattedGrandTotal(),
            
            'SiteConfig' => $siteConfig,
            
            'InvoiceDate' => date('d F Y', strtotime($order->CreatedAt)),
            'InvoiceNumber' => 'INV-' . $order->OrderCode . '-' . date('Ymd', strtotime($order->CreatedAt)),
            'PaymentMethod' => $order->PaymentMethod,
            'PaymentStatus' => $order->PaymentStatus,
        ];
    }

    /**
     * Generate PDF content from template
     */
    private function generatePDFContent($order)
    {
        $data = $this->prepareInvoiceData($order);
        $template = $this->customise($data)->renderWith('InvoicePDF');

        $options = new Options();
        $options->set('isHtml5ParserEnabled', true);
        $options->set('isPhpEnabled', true);
        $options->set('isRemoteEnabled', true);
        $options->set('defaultFont', 'DejaVu Sans');

        $dompdf = new Dompdf($options);
        $dompdf->loadHtml($template);
        $dompdf->setPaper('A4', 'portrait');
        $dompdf->render();

        return $dompdf->output();
    }

    /**
     * ✅ IMPROVED: Send invoice to member via email dengan QR inline
     */
    public function sendInvoiceToMember($order)
    {
        try {
            $member = $order->Member();
            $siteConfig = SiteConfig::current_site_config();
            $emails = explode(',', $siteConfig->Email);
            $companyEmail = trim($emails[0]);
            
            $pdfContent = $this->generatePDFContent(order: $order);
            $emailData = $this->prepareInvoiceData($order);
            
            // Create email
            $email = Email::create()
                ->setHTMLTemplate('InvoiceEmail')
                ->setFrom($companyEmail)
                ->setTo($order->Email)
                ->setSubject('Invoice Tiket - ' . $order->OrderCode)
                ->addAttachmentFromData(
                    $pdfContent,
                    'Invoice-' . $order->OrderCode . '.pdf',
                    'application/pdf'
                );

            // Attach logo if exists
            if ($siteConfig->logo && $siteConfig->logo->exists()) {
                $logoName = $siteConfig->logo->Name;
                $fullLogoPath = BASE_PATH . '/public/assets/Uploads/' . $logoName;

                if (file_exists($fullLogoPath)) {
                    $logoData = file_get_contents($fullLogoPath);
                    $imageInfo = getimagesize($fullLogoPath);
                    $logoMimeType = $imageInfo['mime'] ?? 'image/png';
                    $logoExtension = pathinfo($logoName, PATHINFO_EXTENSION);
                    $logoFilename = 'company-logo.' . $logoExtension;

                    $email->addAttachmentFromData(
                        $logoData,
                        $logoFilename,
                        $logoMimeType,
                    );

                    $emailData['LogoCID'] = 'cid:' . $logoFilename;
                    error_log('Logo attached as inline with CID: ' . $emailData['LogoCID']);
                }
            }

            // ✅ IMPROVED: Attach QR codes inline untuk tiap ticket
            if (!empty($emailData['QRCodes'])) {
                foreach ($emailData['QRCodes'] as &$qrItem) {
                    if ($qrItem['QRCode']) {
                        $qrImageData = base64_decode(str_replace('data:image/png;base64,', '', $qrItem['QRCode']));
                        $qrCid = 'qr-code-' . uniqid() . '.png';
                        
                        $email->addAttachmentFromData(
                            $qrImageData,
                            $qrCid,
                            'image/png'
                        );
                        
                        // Update reference agar bisa diakses di email template
                        $qrItem['QRCodeCID'] = 'cid:' . $qrCid;
                        error_log('QR Code attached for: ' . $qrItem['TicketCode']);
                    }
                }
            }

            $email->setData($emailData);
            $email->send();

            error_log('InvoiceController::sendInvoiceToMember - Invoice sent successfully to: ' . $order->Email);
            return true;

        } catch (Exception $e) {
            error_log('InvoiceController::sendInvoiceToMember - Error: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Static method to automatically send invoice after payment
     */
    public static function sendInvoiceAfterPayment($order)
    {
        if ($order->InvoiceSent) {
            error_log('Invoice already sent for order ID: ' . $order->ID);
            return false;
        }

        static $alreadySent = [];
        if (in_array($order->ID, $alreadySent)) {
            error_log('Invoice already sent in this request for order ID: ' . $order->ID);
            return false;
        }
        $alreadySent[] = $order->ID;

        $controller = new InvoiceController();
        $sent = $controller->sendInvoiceToMember($order);

        if ($sent) {
            $order->InvoiceSent = true;
            $order->write();
            error_log('Invoice sent and marked for order ID: ' . $order->ID);
        }

        return $sent;
    }
}