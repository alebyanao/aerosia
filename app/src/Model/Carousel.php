<?php

use SilverStripe\ORM\DataObject;
use SilverStripe\Assets\Image;
use SilverStripe\AssetAdmin\Forms\UploadField;

class Carousel extends DataObject
{
    private static $table_name = 'Carousel';

    private static $many_many = [
        'Images' => Image::class
    ];

    private static $owns = [
        'Images'
    ];

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        $fields->removeByName('Images');
        $fields->addFieldToTab(
            'Root.Main',
            UploadField::create('Images', 'Banner Carousel Images')
                ->setFolderName('carousel')
                ->setAllowedExtensions(['jpg', 'jpeg', 'png', 'webp'])
                ->setDescription('Upload images for banner carousel')
        );

        return $fields;
    }
}
