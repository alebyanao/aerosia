<?php

use SilverStripe\Admin\ModelAdmin;
use SilverStripe\Security\Permission;
use SilverStripe\Security\Security;

class EventAdmin extends ModelAdmin
{
    private static $managed_models = [
        Ticket::class
    ];

    private static $url_segment = 'tickets';
    private static $menu_title = 'Tickets';

    public function getList()
    {
        $list = parent::getList();
        $member = Security::getCurrentUser();
        if ($member && !Permission::check('ADMIN')) {
            $list = $list->filter('MemberID', $member->ID);
        }

        return $list;
    }
}