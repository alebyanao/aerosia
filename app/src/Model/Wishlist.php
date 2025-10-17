<?php

use SebastianBergmann\Type\StaticType;
use SilverStripe\ORM\DataObject;
use SilverStripe\Security\Member;

class Wishlist extends DataObject
{
    private static $table_name = "Wishlist";

    private static $has_one = [
        'Ticket' => Ticket::class,
        'Member' => Member::class,
    ];
}