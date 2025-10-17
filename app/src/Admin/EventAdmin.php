<?php

use SilverStripe\Admin\ModelAdmin;

class EventAdmin extends ModelAdmin
{
    private static $url_segment = 'tickets';
    private static $menu_title = 'Tickets';
    private static $menu_icon_class = 'font-icon-calendar';
    private static $managed_models = [
        Ticket::class,
    ];
}
