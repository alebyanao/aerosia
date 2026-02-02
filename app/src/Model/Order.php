<?php

use SilverStripe\ORM\ArrayList;
use SilverStripe\ORM\DataObject;
use SilverStripe\Security\Member;

class Order extends DataObject
{
    private static $table_name = "Order";
    
    private static $db = [
        "OrderCode" => "Varchar(255)",
        "MerchantOrderID" => "Varchar(255)",
        "Status" => "Enum('pending,pending_payment,completed,cancelled', 'pending')",
        "Quantity" => "Int",
        "TotalPrice" => "Double",
        "PaymentFee" => "Double",
        "PaymentMethod" => "Varchar(255)",
        "PaymentStatus" => "Enum('unpaid,paid,failed,refunded', 'unpaid')",
        
        "FullName" => "Varchar(255)",
        "Email" => "Varchar(255)",
        "Phone" => "Varchar(50)",
        
        "CreatedAt" => "Datetime",
        "UpdatedAt" => "Datetime",
        "ExpiresAt" => "Datetime",
        "CompletedAt" => "Datetime",
        
        "CapacityReduced" => "Boolean(0)",
        "InvoiceSent" => "Boolean(0)",

        "QRCodeData" => "Varchar(255)",
        "QRCodeScanned" => "Boolean",
        "ScannedAt" => "Datetime",
        "ScannedBy" => "Varchar(100)",
    ];
    
    private static $has_one = [
        "Member" => Member::class,
        "TicketType" => TicketType::class,
    ];
    
    private static $has_many = [
        "PaymentTransaction" => PaymentTransaction::class,
        "OrderItems" => OrderItem::class,
    ];
    
    private static $summary_fields = [
        "OrderCode" => "Order Code",
        "Member.FirstName" => "Member",
        "FullName" => "Nama Pemesan",
        "Email" => "Email",
        "TicketType.TypeName" => "Tipe Tiket",
        "Quantity" => "Jumlah",
        "FormattedTotalPrice" => "Harga Tiket",
        "FormattedPaymentFee" => "Biaya Payment",
        "FormattedGrandTotal" => "Total Bayar",
        "Status" => "Status",
        "PaymentStatus" => "Status Bayar",
        "CreatedAt" => "Tanggal Order",
        "CompletedAt" => "Tanggal Selesai",
    ];

    /**
     * Set default values and expiry time
     */
    public function onBeforeWrite()
    {
        parent::onBeforeWrite();

        if (!$this->CreatedAt) {
            $this->CreatedAt = date('Y-m-d H:i:s');
        }

        $this->UpdatedAt = date('Y-m-d H:i:s');

        // Set expiry untuk order pending (24 jam)
        if ($this->Status == 'pending' && !$this->ExpiresAt) {
            $this->ExpiresAt = date('Y-m-d H:i:s', strtotime('+24 hours'));
        }
    }

    /**
     * ✅ IMPROVED: Create OrderItems immediately when Order is created
     * No need to wait for payment
     */
    public function onAfterWrite() 
    {
        parent::onAfterWrite();
        
        // Check jika OrderItems belum ada
        if ($this->OrderItems()->count() == 0 && $this->Quantity > 0) {
            error_log('Order::onAfterWrite - Creating ' . $this->Quantity . ' OrderItems for Order: ' . $this->ID);
            
            for ($i = 1; $i <= $this->Quantity; $i++) {
                $item = OrderItem::create();
                $item->OrderID = $this->ID;
                $item->TicketTypeID = $this->TicketTypeID;
                
                // ✅ Format TicketCode konsisten: EVT-2026-000001-01
                $item->TicketCode = $this->OrderCode . '-' . str_pad($i, 2, '0', STR_PAD_LEFT);
                $item->write();
                
                error_log('Order::onAfterWrite - OrderItem created: ' . $item->TicketCode);
            }
        }
    }

    public function getGrandTotal()
    {
        return $this->TotalPrice + $this->PaymentFee;
    }

    /**
     * Get formatted total price (harga tiket saja)
     */
    public function getFormattedTotalPrice()
    {
        return 'Rp ' . number_format($this->TotalPrice, 0, ',', '.');
    }

    /**
     * Get formatted payment fee
     */
    public function getFormattedPaymentFee()
    {
        return 'Rp ' . number_format($this->PaymentFee, 0, ',', '.');
    }

    /**
     * Get formatted grand total (total yang harus dibayar)
     */
    public function getFormattedGrandTotal()
    {
        return 'Rp ' . number_format($this->getGrandTotal(), 0, ',', '.');
    }

    /**
     * Check if order can be paid
     */
    public function canBePaid()
    {
        return in_array($this->Status, ['pending', 'pending_payment']) &&
            $this->PaymentStatus == 'unpaid' &&
            !$this->isExpired();
    }

    /**
     * Check if order can be cancelled
     */
    public function canBeCancelled()
    {
        return in_array($this->Status, ['pending', 'pending_payment']) &&
            $this->PaymentStatus != 'paid';
    }

    /**
     * Check if order is expired
     */
    public function isExpired()
    {
        if (!$this->ExpiresAt) {
            return false;
        }
        return strtotime($this->ExpiresAt) < time();
    }

    /**
     * Cancel expired orders
     */
    public function checkAndCancelIfExpired()
    {
        if ($this->isExpired() && $this->canBeCancelled()) {
            $this->Status = 'cancelled';
            $this->PaymentStatus = 'failed';
            $this->write();
            return true;
        }
        return false;
    }

    /**
     * Cancel order manually
     */
    public function cancelOrder()
    {
        if ($this->canBeCancelled()) {
            $this->Status = 'cancelled';
            if ($this->PaymentStatus == 'unpaid') {
                $this->PaymentStatus = 'failed';
            }
            
            // Restore capacity jika sudah dikurangi
            if ($this->CapacityReduced) {
                $this->restoreCapacity();
            }
            
            $this->write();
            return true;
        }
        return false;
    }

    /**
     * Mark order as paid, reduce capacity, and mark as completed
     */
    public function markAsPaid()
    {
        // Validasi kapasitas tiket sebelum menandai sebagai paid
        if (!$this->validateCapacity()) {
            error_log('Order::markAsPaid - Capacity validation failed for order: ' . $this->ID);
            return false;
        }

        $this->Status = 'completed';
        $this->PaymentStatus = 'paid';
        $this->CompletedAt = date('Y-m-d H:i:s');
        
        // Kurangi kapasitas tiket jika belum dikurangi
        if (!$this->CapacityReduced) {
            $capacityReduced = $this->reduceCapacity();
            if ($capacityReduced) {
                $this->CapacityReduced = true;
                error_log('Order::markAsPaid - Capacity reduced successfully for order: ' . $this->ID);
            } else {
                error_log('Order::markAsPaid - Failed to reduce capacity for order: ' . $this->ID);
                return false;
            }
        }
        
        $this->write();
        
        error_log('Order::markAsPaid - Order ' . $this->OrderCode . ' marked as completed automatically');
        
        return true;
    }

    /**
     * Validate if ticket has sufficient capacity
     */
    private function validateCapacity()
    {
        $ticketType = $this->TicketType();
        
        if (!$ticketType || !$ticketType->exists()) {
            error_log('Order::validateCapacity - TicketType not found for Order: ' . $this->ID);
            return false;
        }
        
        if ($ticketType->Capacity < $this->Quantity) {
            error_log('Order::validateCapacity - Insufficient capacity for TicketType: ' . $ticketType->ID . 
                     ' (Available: ' . $ticketType->Capacity . ', Required: ' . $this->Quantity . ')');
            return false;
        }
        
        return true;
    }

    /**
     * Reduce ticket capacity
     */
    private function reduceCapacity()
    {
        $ticketType = $this->TicketType();
        
        if (!$ticketType || !$ticketType->exists()) {
            error_log('Order::reduceCapacity - TicketType not found');
            return false;
        }
        
        try {
            // Validasi kapasitas sekali lagi sebelum pengurangan
            if ($ticketType->Capacity < $this->Quantity) {
                throw new Exception('Insufficient capacity for TicketType: ' . $ticketType->TypeName . 
                                  ' (Available: ' . $ticketType->Capacity . ', Required: ' . $this->Quantity . ')');
            }
            
            // Kurangi kapasitas
            $oldCapacity = $ticketType->Capacity;
            $ticketType->Capacity = $ticketType->Capacity - $this->Quantity;
            $ticketType->write();
            
            error_log('Order::reduceCapacity - TicketType: ' . $ticketType->TypeName . 
                     ' capacity reduced from ' . $oldCapacity . ' to ' . $ticketType->Capacity);
            
            return true;
            
        } catch (Exception $e) {
            error_log('Order::reduceCapacity - Error: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Restore ticket capacity when order is cancelled
     */
    private function restoreCapacity()
    {
        $ticketType = $this->TicketType();
        
        if ($ticketType && $ticketType->exists()) {
            $oldCapacity = $ticketType->Capacity;
            $ticketType->Capacity = $ticketType->Capacity + $this->Quantity;
            $ticketType->write();
            
            error_log('Order::restoreCapacity - TicketType: ' . $ticketType->TypeName . 
                     ' capacity restored from ' . $oldCapacity . ' to ' . $ticketType->Capacity);
            
            $this->CapacityReduced = false;
        }
    }

    /**
     * DEPRECATED: No longer needed - orders are completed automatically after payment
     */
    public function markAsProcessing()
    {
        error_log('Order::markAsProcessing - This method is deprecated. Orders are completed automatically.');
        return false;
    }

    /**
     * DEPRECATED: No longer needed - orders are completed automatically after payment
     */
    public function markAsCompleted()
    {
        error_log('Order::markAsCompleted - This method is deprecated. Orders are completed automatically.');
        return false;
    }

    /**
     * Get status label with color
     */
    public function getStatusLabel()
    {
        switch ($this->Status) {
            case 'pending':
                return '<span class="badge bg-secondary">Menunggu Konfirmasi</span>';
            case 'pending_payment':
                return '<span class="badge bg-warning">Menunggu Pembayaran</span>';
            case 'completed':
                return '<span class="badge bg-success">Selesai</span>';
            case 'cancelled':
                return '<span class="badge bg-danger">Dibatalkan</span>';
            default:
                return '<span class="badge bg-secondary">Unknown</span>';
        }
    }

    /**
     * Get payment status label
     */
    public function getPaymentStatusLabel()
    {
        switch ($this->PaymentStatus) {
            case 'paid':
                return '<span class="badge bg-success">Lunas</span>';
            case 'failed':
                return '<span class="badge bg-danger">Gagal</span>';
            case 'refunded':
                return '<span class="badge bg-warning">Dikembalikan</span>';
            default:
                return '<span class="badge bg-secondary">Belum Bayar</span>';
        }
    }

    /**
     * Get ticket information
     */
    public function getTicketInfo()
    {
        $ticketType = $this->TicketType();
        if ($ticketType && $ticketType->exists()) {
            $ticket = $ticketType->Ticket();
            if ($ticket && $ticket->exists()) {
                return $ticket->Title . ' - ' . $ticketType->TypeName;
            }
            return $ticketType->TypeName;
        }
        return 'Tiket tidak ditemukan';
    }

    /**
     * Get event name
     */
    public function getEventName()
    {
        $ticketType = $this->TicketType();
        if ($ticketType && $ticketType->exists()) {
            $ticket = $ticketType->Ticket();
            if ($ticket && $ticket->exists()) {
                return $ticket->Title;
            }
        }
        return '-';
    }

    /**
     * Get range helper for templates
     */
    public function Range($start, $end)
    {
        $result = [];
        for ($i = $start; $i <= $end; $i++) {
            $result[] = ['Pos' => $i];
        }
        return new ArrayList($result);
    }
    
    public static function getTotalPurchasedByMember($memberID, $ticketTypeID)
    {
        $orders = self::get()->filter([
            'MemberID' => $memberID,
            'TicketTypeID' => $ticketTypeID,
            'Status' => 'completed',
            'PaymentStatus' => 'paid'
        ]);

        $total = 0;
        foreach ($orders as $order) {
            $total += $order->Quantity;
        }

        return $total;
    }

    /**
     * Check if member can purchase more tickets
     */
    public static function canMemberPurchaseMore($memberID, $ticketTypeID, $requestedQty)
    {
        $ticketType = TicketType::get()->byID($ticketTypeID);
        
        if (!$ticketType || !$ticketType->exists()) {
            return false;
        }

        $totalPurchased = self::getTotalPurchasedByMember($memberID, $ticketTypeID);
        $remainingQuota = $ticketType->MaxPerMember - $totalPurchased;
        
        return $requestedQty <= $remainingQuota;
    }

    /**
     * Get remaining quota for member
     */
    public static function getRemainingQuota($memberID, $ticketTypeID)
    {
        $ticketType = TicketType::get()->byID($ticketTypeID);
        
        if (!$ticketType || !$ticketType->exists()) {
            return 0;
        }

        $totalPurchased = self::getTotalPurchasedByMember($memberID, $ticketTypeID);
        $remaining = $ticketType->MaxPerMember - $totalPurchased;
        
        return max(0, $remaining);
    }

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();

        $paymentGrid = $fields->dataFieldByName('PaymentTransaction');
        $fields->removeByName('PaymentTransaction');

        $fields->addFieldsToTab('Root.Main', [
            SilverStripe\Forms\HeaderField::create('InfoHeader', 'Informasi Order', 2),
            $fields->dataFieldByName('OrderCode')->setReadonly(true),
            $fields->dataFieldByName('CreatedAt')->setReadonly(true),
            $fields->dataFieldByName('Status'),
            $fields->dataFieldByName('PaymentStatus'),
            
            SilverStripe\Forms\HeaderField::create('CustomerHeader', 'Data Pemesan', 2),
            $fields->dataFieldByName('FullName')->setReadonly(true),
            $fields->dataFieldByName('Email')->setReadonly(true),
            $fields->dataFieldByName('Phone')->setReadonly(true),

            SilverStripe\Forms\HeaderField::create('PaymentHeader', 'Rincian Biaya', 2),
            $fields->dataFieldByName('Quantity')->setReadonly(true),
            $fields->dataFieldByName('TotalPrice')->setTitle('Subtotal Tiket')->setReadonly(true),
            $fields->dataFieldByName('PaymentFee')->setTitle('Biaya Admin')->setReadonly(true),
        ]);

        if ($this->ID) {
            $fields->addFieldToTab('Root.RiwayatPembayaran', $paymentGrid);
        }

        $fields->removeByName(['MemberID', 'TicketTypeID', 'QRCodeData']);

        return $fields;
    }

    public function canView($member = null)
    {
        if (SilverStripe\Security\Permission::check('ADMIN')) {
            return true;
        }

        if (!$member) $member = SilverStripe\Security\Security::getCurrentUser();
        return SilverStripe\Security\Permission::checkMember($member, 'CMS_ACCESS_OrderAdmin');
    }

    public function canEdit($member = null)
    {
        if (SilverStripe\Security\Permission::check('ADMIN')) {
            return true;
        }
        if (!$member) $member = SilverStripe\Security\Security::getCurrentUser();
        return SilverStripe\Security\Permission::checkMember($member, 'CMS_ACCESS_OrderAdmin');
    }

    public function canDelete($member = null)
    {
        return SilverStripe\Security\Permission::check('ADMIN');
    }

    public function canCreate($member = null, $context = [])
    {
        if (SilverStripe\Security\Permission::check('ADMIN')) {
            return true;
        }
        if (!$member) $member = SilverStripe\Security\Security::getCurrentUser();
        return SilverStripe\Security\Permission::checkMember($member, 'CMS_ACCESS_OrderAdmin');
    }
}