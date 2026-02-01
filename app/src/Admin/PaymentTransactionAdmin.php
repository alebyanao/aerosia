<?php

use SilverStripe\Admin\ModelAdmin;
use SilverStripe\Security\Security;
use SilverStripe\Security\Permission;

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
        if ($this->modelClass == Order::class) {
            $list = $list->filter('TicketType.Ticket.MemberID', $member->ID);
        }
        if ($this->modelClass == PaymentTransaction::class) {
            $list = $list->filter('Order.TicketType.Ticket.MemberID', $member->ID);
        }

        return $list;
    }
    
}