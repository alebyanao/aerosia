<?php

use SilverStripe\ORM\DataExtension;
use SilverStripe\Assets\Image;
use SilverStripe\Forms\FieldList;
use SilverStripe\Forms\TextField;
use SilverStripe\AssetAdmin\Forms\UploadField;

class CustomSiteConfig extends DataExtension
{
    private static $table_name = "Aerosia";

    private static $db = [
        "Email" => "Varchar(255)",
        "Phone" => "Varchar(20)",
        "Address" => "Text",
    ];

    private static $has_one = [
        "logo" => Image::class
    ];

    private static $owns = [
        "logo",
    ];

    public function updateCMSFields(FieldList $fields)
    {
        $fields->addFieldsToTab('Root.Main', [
        TextField::create('Email', 'Email Company'),
        TextField::create('Phone', 'Phone Company'),
        TextField::create('Address', 'Address Company'),
        UploadField::create('logo', 'Logo'),
    ]);
    }
}