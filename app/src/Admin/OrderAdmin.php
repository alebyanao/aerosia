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

    public function getEditForm($id = null, $fields = null)
{
    $form = parent::getEditForm($id, $fields);
    $gridField = $form->Fields()->fieldByName($this->sanitiseClassName($this->modelClass));
    
    // Pastikan kita hanya memproses tab Order
    if ($gridField && $this->modelClass == Order::class) {
        $list = $this->getList();

        // 1. Ambil data yang benar-benar sudah lunas
        $paidList = $list->filter('PaymentStatus', 'paid');

        // 2. Hitung Total (Menggunakan nama kolom asli di DB: TotalPrice & PaymentFee)
        $totalTicketIncome = (double)$paidList->sum('TotalPrice');
        $totalAdminFee     = (double)$paidList->sum('PaymentFee');
        $totalAll = $totalTicketIncome + $totalAdminFee;
        
        // Pendapatan bersih adalah TotalPrice saja (karena PaymentFee biasanya lari ke gateway/vendor)
        // Atau jika pendapatan bersih menurutmu adalah TotalPrice, biarkan saja.
        
        $form->Fields()->insertBefore(
            $this->sanitiseClassName($this->modelClass),
            \SilverStripe\Forms\LiteralField::create(
                'RevenueSummary',
                sprintf(
                    '<div class="message info" style="font-size:1rem; border-left: 5px solid #0073aa;">
                        <p style="margin:0 0 10px 0;"><strong>Ringkasan Pendapatan (Status: Lunas)</strong></p>
                        <table style="width:100%%; max-width:400px;">
                            <tr>
                                <td style="padding:2px 0;">Total Penjualan Tiket</td>
                                <td style="text-align:right;"><strong>Rp %s</strong></td>
                            </tr>
                            <tr>
                                <td style="padding:2px 0;">Total Biaya Admin (Fee)</td>
                                <td style="text-align:right; color:#d9534f;">- Rp %s</td>
                            </tr>
                            <tr style="border-top:1px solid #ccd0d4; font-size:1.1rem;">
                                <td style="padding:8px 0 0 0;"><strong>Pendapatan Bersih</strong></td>
                                <td style="padding:8px 0 0 0; text-align:right; color:#28a745;"><strong>Rp %s</strong></td>
                            </tr>
                        </table>
                    </div>',
                    number_format($totalAll,  0, ',', '.'),
                    number_format($totalAdminFee, 0, ',', '.'),
                    number_format($totalTicketIncome, 0, ',', '.') // Menampilkan TotalPrice sebagai pendapatan bersih
                )
            )
        );
    }

    return $form;
}
}