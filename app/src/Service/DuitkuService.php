<?php

use SilverStripe\Core\Environment;

class DuitkuService
{
    private $merchantCode;
    private $apiKey;
    private $baseUrl;
    private $callbackUrl;
    private $returnUrl;

    public function __construct()
    {
        $this->merchantCode = Environment::getEnv('DUITKU_MERCHANT_CODE');
        $this->apiKey = Environment::getEnv('DUITKU_API_KEY');
        $this->baseUrl = Environment::getEnv('DUITKU_BASE_URL');

        // Fixed: Handle ngrok URL properly
        $ngrokUrl = Environment::getEnv('NGROK_URL') ?: 'https://549e904c09fc.ngrok-free.app';
        
        // Construct proper callback URLs
        $this->callbackUrl = $ngrokUrl . '/payment/callback';
        $this->returnUrl = $ngrokUrl . '/payment/return';

        error_log('DuitkuService - Initialization:');
        error_log('  Merchant Code: ' . $this->merchantCode);
        error_log('  API Key: ' . substr($this->apiKey, 0, 10) . '...');
        error_log('  Base URL: ' . $this->baseUrl);
        error_log('  Callback URL: ' . $this->callbackUrl);
        error_log('  Return URL: ' . $this->returnUrl);
    }

    /**
     * Get available payment methods with fee
     * Returns array structure compatible with SilverStripe templates
     */
    public function getPaymentMethods($amount)
    {
        $datetime = date('Y-m-d H:i:s');
        $signature = hash('sha256', $this->merchantCode . $amount . $datetime . $this->apiKey);

        $params = [
            'merchantcode' => $this->merchantCode,
            'amount' => $amount,
            'datetime' => $datetime,
            'signature' => $signature
        ];

        $url = Environment::getEnv('DUITKU_GETPAYMENTMETHOD_URL');
        
        error_log('DuitkuService::getPaymentMethods - Request:');
        error_log('  URL: ' . $url);
        error_log('  Amount: ' . $amount);
        error_log('  DateTime: ' . $datetime);
        
        $response = $this->makeRequest($url, $params);

        error_log('DuitkuService::getPaymentMethods - Response type: ' . gettype($response));

        if (is_array($response)) {
            // Duitku returns: {"paymentFee": [...array of payment methods...]}
            if (isset($response['paymentFee']) && is_array($response['paymentFee'])) {
                error_log('DuitkuService::getPaymentMethods - Success: ' . count($response['paymentFee']) . ' methods found');
                return $response['paymentFee'];
            }
            
            // Handle direct array response
            if (isset($response[0]) && isset($response[0]['paymentMethod'])) {
                error_log('DuitkuService::getPaymentMethods - Success: ' . count($response) . ' methods (direct array)');
                return $response;
            }
            
            // Handle error response
            if (isset($response['responseCode']) || isset($response['statusCode'])) {
                error_log('DuitkuService::getPaymentMethods - API Error: ' . json_encode($response));
            }
        }

        error_log('DuitkuService::getPaymentMethods - Failed: No valid payment methods');
        return [];
    }

    /**
     * Calculate payment fee for selected payment method
     */
    public function calculatePaymentFee($totalPrice, $paymentMethodCode)
    {
        error_log('DuitkuService::calculatePaymentFee - Method: ' . $paymentMethodCode . ', Amount: ' . $totalPrice);
        
        $paymentMethods = $this->getPaymentMethods($totalPrice);
        
        foreach ($paymentMethods as $method) {
            if (isset($method['paymentMethod']) && $method['paymentMethod'] == $paymentMethodCode) {
                $fee = $method['totalFee'] ?? 0;
                error_log('DuitkuService::calculatePaymentFee - Fee found: ' . $fee);
                return $fee;
            }
        }
        
        error_log('DuitkuService::calculatePaymentFee - No fee found, returning 0');
        return 0;
    }

    /**
     * Create payment transaction for event ticket
     * 
     * @param Order $order - The order object containing ticket purchase details
     * @param string|null $merchantOrderId - Optional custom merchant order ID
     * @return array - Response from Duitku API
     */
    public function createTransaction($order, $merchantOrderId = null)
    {
        $merchantOrderId = $merchantOrderId ?: 'ORDER-' . $order->ID;
        
        // Total yang harus dibayar = harga tiket + payment fee
        $paymentAmount = $order->getGrandTotal();
        
        $signature = md5($this->merchantCode . $merchantOrderId . $paymentAmount . $this->apiKey);

        // Data pemesan dari order
        $customerName = $order->FullName;
        $email = $order->Email;
        $phoneNumber = $order->Phone ?: '08123456789';

        // ✅ BUILD PRODUCT DETAILS dari TicketType dan Ticket
        // Format: "Tiket: [Nama Event] - [Tipe Tiket] x[Jumlah]"
        $ticketType = $order->TicketType();
        $ticket = $ticketType ? $ticketType->Ticket() : null;
        
        // Bangun deskripsi produk untuk Duitku
        $eventName = $ticket ? $ticket->Title : 'Event';
        $ticketTypeName = $ticketType ? $ticketType->TypeName : 'Tiket';
        $quantity = $order->Quantity;
        
        // productDetails adalah string deskripsi yang dikirim ke Duitku API
        // Contoh: "Tiket: Konser Musik Rock 2024 - VIP x2"
        $productDetails = sprintf(
            'Tiket: %s - %s x%d',
            $eventName,
            $ticketTypeName,
            $quantity
        );

        // Parameter untuk Duitku API
        $params = [
            'merchantCode' => $this->merchantCode,
            'paymentAmount' => $paymentAmount,
            'paymentMethod' => $order->PaymentMethod,
            'merchantOrderId' => $merchantOrderId,
            'productDetails' => $productDetails, // ← Ini hanya string deskripsi
            'customerVaName' => $customerName,
            'email' => $email,
            'phoneNumber' => $phoneNumber,
            'callbackUrl' => $this->callbackUrl,
            'returnUrl' => $this->returnUrl,
            'signature' => $signature,
            'expiryPeriod' => 1440, // 24 jam
        ];

        error_log('DuitkuService::createTransaction - Request:');
        error_log('  Order ID: ' . $order->ID);
        error_log('  Merchant Order ID: ' . $merchantOrderId);
        error_log('  Payment Amount: Rp ' . number_format($paymentAmount, 0, ',', '.'));
        error_log('  Payment Method: ' . $order->PaymentMethod);
        error_log('  Product Details: ' . $productDetails);
        error_log('  Customer: ' . $customerName . ' (' . $email . ')');

        $response = $this->makeRequest($this->baseUrl, $params, 'POST');
        
        error_log('DuitkuService::createTransaction - Response: ' . json_encode($response));

        // Duitku success response: {"statusCode": "00", "paymentUrl": "...", ...}
        if ($response && isset($response['statusCode']) && $response['statusCode'] == '00') {
            error_log('DuitkuService::createTransaction - SUCCESS');
            return [
                'success' => true,
                'merchantOrderId' => $merchantOrderId,
                'paymentUrl' => $response['paymentUrl'] ?? null,
                'vaNumber' => $response['vaNumber'] ?? null,
                'qrString' => $response['qrString'] ?? null,
                'statusCode' => $response['statusCode'],
                'statusMessage' => $response['statusMessage'] ?? 'Transaction created successfully'
            ];
        }

        // Handle error
        $errorMessage = 'Failed to create transaction';
        if ($response) {
            error_log('DuitkuService::createTransaction - FAILED: ' . json_encode($response));
            $errorMessage = $response['statusMessage'] ?? $errorMessage;
        }

        return [
            'success' => false,
            'error' => $errorMessage,
            'response' => $response
        ];
    }

    /**
     * Verify callback signature from Duitku
     */
    public function verifyCallback($data)
    {
        $merchantOrderId = $data['merchantOrderId'] ?? '';
        $resultCode = $data['resultCode'] ?? '';
        $amount = $data['amount'] ?? 0;
        $receivedSignature = $data['signature'] ?? '';

        if (empty($merchantOrderId) || empty($receivedSignature)) {
            error_log('DuitkuService::verifyCallback - Missing required fields');
            return false;
        }

        $calculatedSignature = md5($this->merchantCode . $amount . $merchantOrderId . $this->apiKey);

        error_log('DuitkuService::verifyCallback - Verification:');
        error_log('  Merchant Order ID: ' . $merchantOrderId);
        error_log('  Amount: ' . $amount);
        error_log('  Result Code: ' . $resultCode);
        error_log('  Calculated Signature: ' . $calculatedSignature);
        error_log('  Received Signature: ' . $receivedSignature);

        $isValid = hash_equals($calculatedSignature, $receivedSignature);
        error_log('  Valid: ' . ($isValid ? 'YES' : 'NO'));

        return $isValid;
    }

    /**
     * Make HTTP request to Duitku API
     */
    private function makeRequest($url, $params, $method = 'POST')
    {
        error_log('DuitkuService::makeRequest - ' . $method . ' ' . $url);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_TIMEOUT, 30);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Accept: application/json'
        ]);

        if ($method === 'POST') {
            curl_setopt($ch, CURLOPT_POST, true);
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($params));
        }

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $curlError = curl_error($ch);

        if ($curlError) {
            error_log('DuitkuService::makeRequest - CURL Error: ' . $curlError);
            curl_close($ch);
            return false;
        }

        curl_close($ch);

        error_log('DuitkuService::makeRequest - HTTP ' . $httpCode);
        error_log('DuitkuService::makeRequest - Response: ' . substr($response, 0, 500));

        if ($httpCode == 200 && $response) {
            $decoded = json_decode($response, true);
            if (json_last_error() === JSON_ERROR_NONE) {
                return $decoded;
            } else {
                error_log('DuitkuService::makeRequest - JSON decode error: ' . json_last_error_msg());
            }
        }

        return false;
    }
}