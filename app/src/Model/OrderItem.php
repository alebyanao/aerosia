<?php

use SilverStripe\ORM\DataObject;
use SilverStripe\Security\Member;

class OrderItem extends DataObject 
{
    private static $table_name = 'OrderItem';

    private static $db = [
        'TicketCode' => 'Varchar(50)',
        'IsScanned' => 'Boolean',
        'ScannedAt' => 'Datetime',
        'ScannedBy' => 'Varchar(100)'
    ];

    private static $has_one = [
        'Order' => Order::class,
        'TicketType' => TicketType::class
    ];

    public function onBeforeWrite() {
        parent::onBeforeWrite();
        if (!$this->TicketCode) {
            $this->TicketCode = $this->Order()->OrderCode . '-' . $this->ID;
        }
    }
}