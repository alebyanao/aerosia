<?php

use SilverStripe\ORM\ArrayList;
use SilverStripe\ORM\DataObject;
use SilverStripe\Security\Member;

class TicketOrder extends DataObject
{
    private static $table_name = "ticketorder";
    
    private static $db = [
        "OrderCode" => "Varchar(255)",
        "Status" => "Enum('pending,pending_payment,paid,completed,cancelled', 'pending')",
        "TotalPrice" => "Double",
        "PaymentFee" => "Double",
        "PaymentMethod" => "Varchar(255)",
        "PaymentStatus" => "Enum('unpaid,paid,failed,refunded', 'unpaid')",
        "CreateAt" => "Datetime",
        "UpdateAt" => "Datetime",
        "ExpiresAt" => "Datetime",
        "CapacityReduced" => "Boolean(0)", // Flag untuk track apakah kapasitas sudah dikurangi
        "Notes" => "Text", // Catatan dari pembeli
    ];

    private static $has_one = [
        "Member" => Member::class,
    ];
    
    private static $has_many = [
        "TicketOrderItem" => TicketOrderItem::class,
        "PaymentTransaction" => PaymentTransaction::class,
    ];
    
    private static $summary_fields = [
        "Member.FirstName" => "Nama",
        "OrderCode" => "Kode Order",
        "Status" => "Status",
        "TotalPrice" => "Total Harga",
        "PaymentMethod" => "Metode Pembayaran",
        "PaymentStatus" => "Status Pembayaran",
        "CreateAt" => "Tanggal Order",
    ];

    /**
     * Set default values dan expiry time
     */
    public function onBeforeWrite()
    {
        parent::onBeforeWrite();

        if (!$this->CreateAt) {
            $this->CreateAt = date('Y-m-d H:i:s');
        }

        $this->UpdateAt = date('Y-m-d H:i:s');

        // Order tiket expired dalam 1 jam jika belum dibayar
        if ($this->Status == 'pending' && !$this->ExpiresAt) {
            $this->ExpiresAt = date('Y-m-d H:i:s', strtotime('+1 hour'));
        }

        // Generate order code jika belum ada
        if (!$this->OrderCode) {
            $this->OrderCode = 'TKT-' . date('Ymd') . '-' . strtoupper(substr(md5(uniqid()), 0, 8));
        }
    }

    /**
     * Get grand total termasuk payment fee
     */
    public function getGrandTotal()
    {
        return $this->TotalPrice + $this->PaymentFee;
    }

    /**
     * Get formatted grand total
     */
    public function getFormattedGrandTotal()
    {
        return 'Rp ' . number_format($this->getGrandTotal(), 0, ',', '.');
    }

    /**
     * Get formatted total price
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
     * Validate if all ticket types have sufficient capacity
     */
    private function validateCapacity()
    {
        $orderItems = $this->TicketOrderItem();
        
        foreach ($orderItems as $item) {
            $ticketType = $item->TicketType();
            if (!$ticketType) {
                error_log('TicketOrder::validateCapacity - TicketType not found for item: ' . $item->ID);
                return false;
            }
            
            // Hitung total pembelian member ini untuk tipe tiket ini (termasuk order lain yang sudah paid)
            $memberPurchased = $this->getMemberPurchasedCount($this->MemberID, $ticketType->ID);
            
            // Validasi MaxPerMember
            if (($memberPurchased + $item->Quantity) > $ticketType->MaxPerMember) {
                error_log('TicketOrder::validateCapacity - Exceeded MaxPerMember for TicketType: ' . $ticketType->ID . 
                         ' (Member purchased: ' . $memberPurchased . ', Requested: ' . $item->Quantity . ', Max: ' . $ticketType->MaxPerMember . ')');
                return false;
            }
            
            // Validasi Capacity
            $currentCapacity = $ticketType->Capacity - $this->getTotalSoldCount($ticketType->ID);
            if ($currentCapacity < $item->Quantity) {
                error_log('TicketOrder::validateCapacity - Insufficient capacity for TicketType: ' . $ticketType->ID . 
                         ' (Available: ' . $currentCapacity . ', Required: ' . $item->Quantity . ')');
                return false;
            }
        }
        
        return true;
    }

    /**
     * Get total tiket yang sudah terjual untuk tipe tiket tertentu
     */
    private function getTotalSoldCount($ticketTypeID)
    {
        $soldItems = TicketOrderItem::get()->filter([
            'TicketTypeID' => $ticketTypeID,
            'Order.Status' => ['paid', 'completed'],
            'Order.PaymentStatus' => 'paid'
        ]);
        
        $total = 0;
        foreach ($soldItems as $item) {
            $total += $item->Quantity;
        }
        
        return $total;
    }

    /**
     * Get total pembelian member untuk tipe tiket tertentu
     */
    private function getMemberPurchasedCount($memberID, $ticketTypeID)
    {
        $purchasedItems = TicketOrderItem::get()->filter([
            'TicketTypeID' => $ticketTypeID,
            'Order.MemberID' => $memberID,
            'Order.Status' => ['paid', 'completed'],
            'Order.PaymentStatus' => 'paid'
        ]);
        
        $total = 0;
        foreach ($purchasedItems as $item) {
            $total += $item->Quantity;
        }
        
        return $total;
    }

    /**
     * Mark order as paid dan kurangi capacity
     */
    public function markAsPaid()
    {
        // Validasi capacity sebelum menandai sebagai paid
        if (!$this->validateCapacity()) {
            error_log('TicketOrder::markAsPaid - Capacity validation failed for order: ' . $this->ID);
            return false;
        }

        $this->Status = 'paid';
        $this->PaymentStatus = 'paid';
        
        // Kurangi capacity jika belum dikurangi
        if (!$this->CapacityReduced) {
            $capacityReduced = $this->reduceCapacity();
            if ($capacityReduced) {
                $this->CapacityReduced = true;
                error_log('TicketOrder::markAsPaid - Capacity reduced successfully for order: ' . $this->ID);
            } else {
                error_log('TicketOrder::markAsPaid - Failed to reduce capacity for order: ' . $this->ID);
                return false;
            }
        }
        
        $this->write();

        return true;
    }

    /**
     * Reduce capacity for all ticket types in the order
     */
    private function reduceCapacity()
    {
        $orderItems = $this->TicketOrderItem();
        $updatedTicketTypes = [];
        
        try {
            foreach ($orderItems as $item) {
                $ticketType = $item->TicketType();
                if (!$ticketType) {
                    throw new Exception('TicketType not found for item: ' . $item->ID);
                }
                
                // Hitung capacity tersisa
                $currentSold = $this->getTotalSoldCount($ticketType->ID);
                $availableCapacity = $ticketType->Capacity - $currentSold;
                
                // Validasi capacity sekali lagi
                if ($availableCapacity < $item->Quantity) {
                    throw new Exception('Insufficient capacity for ticket type: ' . $ticketType->TypeName . 
                                      ' (Available: ' . $availableCapacity . ', Required: ' . $item->Quantity . ')');
                }
                
                // Simpan data untuk rollback
                $updatedTicketTypes[] = [
                    'ticketType' => $ticketType,
                    'oldCapacity' => $ticketType->Capacity,
                    'quantity' => $item->Quantity
                ];
                
                error_log('TicketOrder::reduceCapacity - TicketType: ' . $ticketType->TypeName . 
                         ' capacity check passed. Sold: ' . $currentSold . ', Available: ' . $availableCapacity);
            }
            
            return true;
            
        } catch (Exception $e) {
            error_log('TicketOrder::reduceCapacity - Error: ' . $e->getMessage());
            return false;
        }
    }

    /**
     * Restore capacity when order is cancelled
     */
    private function restoreCapacity()
    {
        $orderItems = $this->TicketOrderItem();
        
        foreach ($orderItems as $item) {
            $ticketType = $item->TicketType();
            if ($ticketType) {
                error_log('TicketOrder::restoreCapacity - TicketType: ' . $ticketType->TypeName . 
                         ' capacity restored (quantity: ' . $item->Quantity . ')');
            }
        }
        
        $this->CapacityReduced = false;
    }

    /**
     * Mark order as completed
     */
    public function markAsCompleted()
    {
        if ($this->Status == 'paid') {
            $this->Status = 'completed';
            $this->write();
            return true;
        }
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
            case 'paid':
                return '<span class="badge bg-success">Dibayar</span>';
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
     * Get remaining time before expiry
     */
    public function getRemainingTime()
    {
        if (!$this->ExpiresAt || $this->isExpired()) {
            return 0;
        }
        
        return strtotime($this->ExpiresAt) - time();
    }

    /**
     * Get formatted remaining time
     */
    public function getFormattedRemainingTime()
    {
        $seconds = $this->getRemainingTime();
        
        if ($seconds <= 0) {
            return 'Kadaluarsa';
        }
        
        $minutes = floor($seconds / 60);
        $hours = floor($minutes / 60);
        $minutes = $minutes % 60;
        
        if ($hours > 0) {
            return $hours . ' jam ' . $minutes . ' menit';
        }
        
        return $minutes . ' menit';
    }
}