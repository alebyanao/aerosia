<?php

use SilverStripe\ORM\DataObject;
use SilverStripe\Security\Permission;
use SilverStripe\Security\Security;
use SilverStripe\Forms\TextareaField;

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
    
    // Field yang muncul di tabel list
    private static $summary_fields = [
        "TransactionID" => "Transaction ID",
        "Order.OrderCode" => "Order Code", 
        "Order.TicketType.Ticket.Title" => "Event",
        "AmountFormatted" => "Amount",
        "Status" => "Status",
        "PaymentGateway" => "Gateway",
        "CreatedAt" => "Created At",
    ];

    // Kolom pencarian
    private static $searchable_fields = [
        'TransactionID',
        'Order.OrderCode' => ['title' => 'Kode Order'],
        'Status',
        'PaymentGateway'
    ];

    private static $default_sort = 'CreatedAt DESC';

    public function onBeforeWrite()
    {
        parent::onBeforeWrite();

        if (!$this->CreatedAt) {
            $this->CreatedAt = date('Y-m-d H:i:s');
        }
    }
    public function getAmountFormatted()
    {
        return 'Rp ' . number_format($this->Amount, 0, ',', '.');
    }

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        $fields->makeFieldReadonly('PaymentGateway');
        $fields->makeFieldReadonly('TransactionID');
        $fields->makeFieldReadonly('Amount');
        $fields->makeFieldReadonly('Status');
        $fields->makeFieldReadonly('PaymentURL');
        $fields->makeFieldReadonly('CreatedAt');
        $fields->makeFieldReadonly('OrderID');
        $fields->replaceField(
            'ResponseData', 
            TextareaField::create('ResponseData', 'Raw Response Data')
                ->setRows(10)
                ->setReadonly(true)
        );

        return $fields;
    }

    public function canView($member = null)
    {
        if (!$member) $member = Security::getCurrentUser();
        if (!$member) return false;

        if (Permission::checkMember($member, 'ADMIN')) return true;

        if ($this->Order()->exists() && $this->Order()->TicketType()->exists() && $this->Order()->TicketType()->Ticket()->exists()) {
            return $this->Order()->TicketType()->Ticket()->MemberID == $member->ID;
        }

        return false;
    }

    public function canEdit($member = null)
    {
        return Permission::check('ADMIN');
    }

    public function canDelete($member = null)
    {
        return Permission::check('ADMIN');
    }

    public function canCreate($member = null, $context = [])
    {
        return false;
    }
}