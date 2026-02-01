<?php

use SilverStripe\Admin\ModelAdmin;
use SilverStripe\Security\Security;
use SilverStripe\Security\Permission;

class OrderAdmin extends ModelAdmin
{
    private static $managed_models = [
        Order::class,
        PaymentTransaction::class
    ];

    private static $url_segment = 'order';
    private static $menu_title = 'Order';
    private static $menu_icon_class = 'font-icon-clipboard-pencil';

    /**
     * LOGIC UTAMA FILTERING
     * Membatasi tampilan data agar User hanya melihat order dari tiket buatannya sendiri.
     */
    public function getList()
    {
        $list = parent::getList();
        
        // 1. Ambil User yang sedang login
        $member = Security::getCurrentUser();

        // 2. Jika tidak ada user login, kembalikan list kosong/default
        if (!$member) {
            return $list;
        }

        // 3. Jika user adalah SUPER ADMIN, tampilkan SEMUA data (jangan difilter)
        if (Permission::check('ADMIN')) {
            return $list;
        }

        // 4. Jika user Biasa (Moderator/EO), filter berdasarkan model yang sedang dibuka
        
        // A. Jika sedang membuka tab 'Order'
        if ($this->modelClass == Order::class) {
            // Filter: Order -> TicketType -> Ticket -> MemberID
            $list = $list->filter('TicketType.Ticket.MemberID', $member->ID);
        }

        // B. Jika sedang membuka tab 'PaymentTransaction'
        if ($this->modelClass == PaymentTransaction::class) {
            // Filter: PaymentTransaction -> Order -> TicketType -> Ticket -> MemberID
            $list = $list->filter('Order.TicketType.Ticket.MemberID', $member->ID);
        }

        return $list;
    }

    // Agar kolom export rapi
    public function getExportFields()
    {
        $fields = [
            'OrderCode' => 'Order Code',
            'CreatedAt' => 'Tanggal Order',
            'FullName' => 'Nama Pemesan',
            'Email' => 'Email',
            'TicketType.TypeName' => 'Tipe Tiket',
            'TicketType.Ticket.Title' => 'Nama Event', // Tambahan: Biar tau ini order event apa
            'Quantity' => 'Qty',
            'FormattedGrandTotal' => 'Total Bayar',
            'Status' => 'Status Order',
            'PaymentStatus' => 'Status Pembayaran'
        ];
        return $fields;
    }
}