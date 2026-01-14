<?php

use SilverStripe\Admin\ModelAdmin;

class ContentAdmin extends ModelAdmin
{
    private static $managed_models = [
        Carousel::class => ['title' => 'Carousel image'],
    ];

    private static $url_segment = 'content-management';
    
    private static $menu_title = 'Content Management';
    
    private static $menu_icon_class = 'font-icon-block-content';

}
