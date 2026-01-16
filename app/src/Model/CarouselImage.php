<?php

use SilverStripe\AssetAdmin\Forms\UploadField;
use SilverStripe\Assets\Image;
use SilverStripe\Forms\TextField;
use SilverStripe\ORM\DataObject;

class CarouselImage extends DataObject
{
    private static $table_name = "CarouselImage";

    private static $db = [
        "Name" => "Varchar(255)",
    ];
    private static $has_one = [
        "Image" => Image::class,
    ];
    private static $owns = [
        "Image",
    ];
    private static $summary_fields = [
        "Name" => "Name",
        "Image.CMSThumbnail" => "Image",
    ];
    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        $fields->addFieldToTab(
            "Root.Main",
            TextField::create("Name", "Image Name")
        );
        $fields->addFieldToTab(
            "Root.Main",
            UploadField::create("Image", "Carousel Image")
        );
        return $fields;
    }
}