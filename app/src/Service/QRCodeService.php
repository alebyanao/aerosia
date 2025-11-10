<?php

use Endroid\QrCode\QrCode;
use Endroid\QrCode\Writer\PngWriter;
use Endroid\QrCode\Encoding\Encoding;
use Endroid\QrCode\ErrorCorrectionLevel\ErrorCorrectionLevelHigh;
use Endroid\QrCode\RoundBlockSizeMode\RoundBlockSizeModeMargin;
use SilverStripe\ORM\DataObject;
class QRCodeService
{
    /**
     * Generate QR Code as base64 PNG image
     */
    public static function generateQRCode(string $data, int $size = 300): string
    {
        // Buat objek QR Code (pakai syntax create() untuk versi 4.x - 5.x)
        $qrCode = QrCode::create($data)
            ->setEncoding(new Encoding('UTF-8'))
            ->setErrorCorrectionLevel(new ErrorCorrectionLevelHigh())
            ->setSize($size)
            ->setMargin(10)
            ->setRoundBlockSizeMode(new RoundBlockSizeModeMargin());

        // Gunakan writer PNG
        $writer = new PngWriter();
        $result = $writer->write($qrCode);

        // Return sebagai base64 data URI
        return $result->getDataUri();
    }

    /**
     * Generate QR Code untuk order tertentu
     */
    public static function generateOrderQRCode(DataObject $order, int $size = 300): string
    {
        if (!$order->QRCodeData) {
            $order->QRCodeData = 'TICKET-' . $order->ID . '-' . md5($order->OrderCode . $order->CreatedAt);
            $order->write();
        }

        return self::generateQRCode($order->QRCodeData, $size);
    }

    /**
     * Verifikasi keaslian QR Code tiket
     */
    public static function verifyQRCode(string $qrData): array
    {
        $order = \Order::get()->filter('QRCodeData', $qrData)->first();

        if (!$order) {
            return [
                'valid' => false,
                'message' => 'QR Code tidak valid'
            ];
        }

        if ($order->Status !== 'completed' || $order->PaymentStatus !== 'paid') {
            return [
                'valid' => false,
                'message' => 'Tiket belum dibayar atau order belum selesai'
            ];
        }

        if ($order->QRCodeScanned) {
            return [
                'valid' => false,
                'message' => 'Tiket sudah pernah di-scan pada ' . $order->ScannedAt,
                'order' => $order
            ];
        }

        return [
            'valid' => true,
            'message' => 'Tiket valid',
            'order' => $order
        ];
    }

    /**
     * Tandai tiket sudah di-scan oleh petugas
     */
    public static function markAsScanned(DataObject $order, string $scannedBy = 'Admin'): bool
    {
        try {
            $order->QRCodeScanned = true;
            $order->ScannedAt = date('Y-m-d H:i:s');
            $order->ScannedBy = $scannedBy;
            $order->write();
            return true;
        } catch (Exception $e) {
            error_log('QRCodeService::markAsScanned - Error: ' . $e->getMessage());
            return false;
        }
    }
}
