<?php

use SilverStripe\Admin\ModelAdmin;

class CategoryAdmin extends ModelAdmin
{
    private static $managed_models = [
        Category::class
    ];

    private static $url_segment = 'categories';

    private static $menu_title = 'Kategori Event';

    private static $menu_icon_class = 'font-icon-tag';

}