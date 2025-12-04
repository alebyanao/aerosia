<?php

use SilverStripe\Dev\BuildTask;
use SilverStripe\ORM\DB;

/**
 * Task untuk mengupdate status tiket yang sudah expired
 * 
 * Jalankan manual via: /dev/tasks/UpdateExpiredTicketsTask
 * Atau setup cron job untuk otomatis
 */
class UpdateExpiredTicketsTask extends BuildTask
{
    private static $segment = 'UpdateExpiredTicketsTask';
    
    protected $title = 'Update Status Tiket yang Berakhir';
    
    protected $description = 'Mengecek dan mengupdate status tiket yang eventnya sudah melewati tanggal dan waktu penyelenggaraan';

    public function run($request)   
    {
        $this->log('=== Memulai Update Status Tiket ===');
        
        // Ambil semua tiket yang belum expired
        $tickets = Ticket::get()->filter(['IsExpired' => false]);
        
        $updatedCount = 0;
        $checkedCount = 0;
        
        foreach ($tickets as $ticket) {
            $checkedCount++;
            
            // Cek apakah tiket sudah expired
            if ($ticket->checkIfExpired()) {
                $ticket->IsExpired = true;
                $ticket->write();
                $updatedCount++;
                
                $this->log("✓ Tiket #{$ticket->ID} - {$ticket->Title} - BERAKHIR");
            }
        }
        
        $this->log("=== Selesai ===");
        $this->log("Total tiket yang dicek: {$checkedCount}");
        $this->log("Total tiket yang diupdate: {$updatedCount}");
        
        // Update juga tiket yang mungkin secara manual di-set expired tapi eventnya belum lewat
        $reactivateCount = 0;
        $expiredTickets = Ticket::get()->filter(['IsExpired' => true]);
        
        foreach ($expiredTickets as $ticket) {
            if (!$ticket->checkIfExpired()) {
                $ticket->IsExpired = false;
                $ticket->write();
                $reactivateCount++;
                
                $this->log("↺ Tiket #{$ticket->ID} - {$ticket->Title} - DIAKTIFKAN KEMBALI");
            }
        }
        
        if ($reactivateCount > 0) {
            $this->log("Total tiket yang diaktifkan kembali: {$reactivateCount}");
        }
    }
    
    /**
     * Helper untuk log dengan output yang rapi
     */
    private function log($message)
    {
        if (PHP_SAPI === 'cli') {
            echo $message . PHP_EOL;
        } else {
            echo $message . "<br>";
        }
    }

}