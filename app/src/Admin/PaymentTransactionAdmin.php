<?php

use SilverStripe\Admin\ModelAdmin;
use SilverStripe\Security\Security;
use SilverStripe\Security\Permission;
use SilverStripe\Forms\LiteralField; // Tambahkan ini

class PaymentTransactionAdmin extends ModelAdmin
{
    private static $menu_title = "Transaksi pembayaran";
    private static $url_segment = "payment-transaction";
    private static $menu_icon_class = "font-icon-credit-card";

    private static $managed_models = [
        PaymentTransaction::class,
    ];

    public function getList()
    {
        $list = parent::getList();
        $member = Security::getCurrentUser();

        if (!$member || Permission::check('ADMIN')) {
            return $list;
        }

        // Filter agar user hanya melihat transaksi milik event mereka sendiri
        if ($this->modelClass == PaymentTransaction::class) {
            $list = $list->filter('Order.TicketType.Ticket.MemberID', $member->ID);
        }

        return $list;
    }

    public function getEditForm($id = null, $fields = null)
    {
        $form = parent::getEditForm($id, $fields);

        if ($this->modelClass == PaymentTransaction::class) {
            // Ambil list yang sudah terfilter oleh search dan getList()
            $list = $this->getList();

            // Hitung Total Success
            $totalSuccess = $list->filter('Status', 'success')->sum('Amount');

            // Hitung Total Pending
            $totalPending = $list->filter('Status', 'pending')->sum('Amount');

            // Format ke Rupiah
            $formattedSuccess = 'Rp ' . number_format($totalSuccess, 0, ',', '.');
            $formattedPending = 'Rp ' . number_format($totalPending, 0, ',', '.');

            // Tambahkan tampilan di atas GridField
            $form->Fields()->insertBefore(
                'PaymentTransaction', // Nama model yang dikelola
                LiteralField::create(
                    'TotalAmountStats',
                    "<div class='message info' style='display: flex; gap: 20px; font-weight: bold; margin-bottom: 15px;'>
                        <div style='color: #28a745;'>Total Success: {$formattedSuccess}</div>
                        <div style='color: #ffc107;'>Total Pending: {$formattedPending}</div>
                    </div>"
                )
            );
        }

        return $form;
    }
}