<?php

use SilverStripe\ORM\DataObject;

class PaymentTransaction extends DataObject
{
    private static $table_name = "paymenttransaction";
    
    private static $db = [
        "PaymentGateway" => "Varchar(255)",
        "TransactionID" => "Varchar(255)",
        "Amount" => "Double",
        "Status" => "Enum('pending,success,failed','pending')",
        "PaymentURL" => "Varchar(500)", 
        "ResponseData" => "Text",
        "CreatedAt" => "Datetime", 
    ];
    
    private static $has_one = [
        "Order" => Order::class,
    ];
    
    private static $summary_fields = [
        "Order.OrderCode" => "Order Code",
        "PaymentGateway" => "Payment Gateway",
        "TransactionID" => "Transaction ID",
        "Amount" => "Amount",
        "Status" => "Status",
        "CreatedAt" => "Created At",
    ];

    public function onBeforeWrite()
    {
        parent::onBeforeWrite();

        if (!$this->CreatedAt) {
            $this->CreatedAt = date('Y-m-d H:i:s');
        }
    }
}