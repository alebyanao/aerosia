<?php

use SilverStripe\ORM\ArrayList;
use SilverStripe\ORM\DataObject;
use SilverStripe\Security\Member;

class Order extends DataObject
{
    private static $table_name = "Order";
    
    private static $db = [
        "OrderCode" => "Varchar(255)",
        "MerchantOrderID" => "Varchar(255)", // Untuk Duitku
        "Status" => "Enum('pending,pending_payment,completed,cancelled', 'pending')", // Removed 'paid' and 'processing'
        "Quantity" => "Int",
        "TotalPrice" => "Double", // Harga tiket x quantity
        "PaymentFee" => "Double", // Fee dari payment gateway (Duitku)
        "PaymentMethod" => "Varchar(255)", // Metode pembayaran yang dipilih
        "PaymentStatus" => "Enum('unpaid,paid,failed,refunded', 'unpaid')",
        
        // Data Pemesan
        "FullName" => "Varchar(255)",
        "Email" => "Varchar(255)",
        "Phone" => "Varchar(50)",
        
        // Timestamps
        "CreatedAt" => "Datetime",
        "UpdatedAt" => "Datetime",
        "ExpiresAt" => "Datetime",
        "CompletedAt" => "Datetime", // Timestamp ketika order completed
        
        // Flags
        "CapacityReduced" => "Boolean(0)", // Flag untuk track apakah kapasitas sudah dikurangi
        "InvoiceSent" => "Boolean(0)",
    ];
    
    private static $has_one = [
        "Member" => Member::class,
        "TicketType" => TicketType::class,
    ];
    
    private static $has_many = [
        "PaymentTransaction" => PaymentTransaction::class,
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
     * Get grand total (harga tiket + payment fee)
     */
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
     * UPDATED: Langsung mark sebagai completed setelah paid
     */
    public function markAsPaid()
    {
        // Validasi kapasitas tiket sebelum menandai sebagai paid
        if (!$this->validateCapacity()) {
            error_log('Order::markAsPaid - Capacity validation failed for order: ' . $this->ID);
            return false;
        }

        $this->Status = 'completed'; // Langsung completed, bukan 'paid'
        $this->PaymentStatus = 'paid';
        $this->CompletedAt = date('Y-m-d H:i:s'); // Set waktu completed
        
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
}