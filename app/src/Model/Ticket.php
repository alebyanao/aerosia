<?php

use SilverStripe\ORM\DataObject;
use SilverStripe\Assets\Image;
use SilverStripe\AssetAdmin\Forms\UploadField;
use SilverStripe\Forms\GridField\GridField;
use SilverStripe\Forms\GridField\GridFieldConfig_RecordEditor;
use Silverstripe\Forms\HTMLEditor\HTMLEditorField;
use SilverStripe\Security\Security;
use SilverStripe\Forms\TimeField;
use SilverStripe\Forms\TextField;

class Ticket extends DataObject
{
    private static $table_name = 'Ticket';

    private static $db = [
        'Title'       => 'Varchar(255)',
        'EventDate'   => 'Date',
        'EventTime'   => 'Time',
        'Location'    => 'Varchar(255)',
        'EventMapURL' => 'Varchar(255)',
        'Instagram' => 'Varchar(50)',
        'InstagramURL' => 'Varchar(50)',
        'Description' => 'HTMLText',
    ];

    private static $has_one = [
        'Image' => Image::class
    ];

    private static $has_many = [
        'TicketTypes' => TicketType::class,
        'Wishlist' => Wishlist::class
    ];

    private static $owns = [
        'Image'
    ];

    private static $summary_fields = [
        'Title'              => 'Judul Event',
        'EventDate'          => 'Tanggal Event',
        'Location'           => 'Lokasi',
        'MinPriceFormatted'  => 'Harga Mulai Dari'
    ];

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();

        $fields->removeByName(['TicketTypes']);

        $fields->addFieldsToTab('Root.Main', [
            TextField::create('Location', 'Lokasi Event'),
            TextField::create('EventMapURL', 'Google Map URL'),
            TimeField::create('EventTime', 'Jam Acara')
                ->setHTML5(true), 
            TextField::create('Instagram', 'Username Instagram (opsional)'),
            TextField::create('InstagramURL', 'Link Instagram (opsional)'),
            UploadField::create('Image', 'Gambar Tiket')
                ->setFolderName('tickets')
                ->setAllowedExtensions(['jpg', 'jpeg', 'png', 'gif', 'svg']),
            HTMLEditorField::create('Description', 'Deskripsi Event')->setRows(15),
            
        ]);

        // GridField untuk mengelola tipe tiket
        if ($this->ID) {
            $ticketTypesConfig = GridFieldConfig_RecordEditor::create();
            
            $fields->addFieldToTab(
                'Root.TipeHarga',
                GridField::create(
                    'TicketTypes',
                    'Tipe & Harga Tiket',
                    $this->TicketTypes(),
                    $ticketTypesConfig
                )
            );
        } else {
            $fields->addFieldToTab(
                'Root.TipeHarga',
                \SilverStripe\Forms\LiteralField::create(
                    'FirstSaveNotice',
                    '<p class="alert alert-info">Simpan tiket terlebih dahulu sebelum menambahkan tipe & harga tiket.</p>'
                )
            );
        }

        return $fields;
    }

    /**
     * Mendapatkan harga termurah dari semua tipe tiket
     */
    public function getMinPrice()
    {
        $types = $this->TicketTypes();
        if ($types->count() > 0) {
            return $types->min('Price');
        }
        return 0;
    }

    /**
     * Format harga termurah
     */
    public function getMinPriceFormatted()
    {
        $minPrice = $this->getMinPrice();

        if ($minPrice === null) {
            return '-';
        }

        // Kalau 0 atau tidak ada harga, tampilkan GRATIS
        if ((float)$minPrice <= 0) {
            return 'GRATIS';
        }

        // Kalau ada harga, tampilkan format rupiah
        return 'Rp ' . number_format($minPrice, 0, ',', '.');
    }

    /**
     * Mendapatkan label harga untuk card
     */
    public function getPriceLabel()
    {
        $count = $this->TicketTypes()->count();
        if ($count > 0) {
            return ' ' . $this->getMinPriceFormatted();
        }
        return 'Harga belum tersedia';
    }

    /**
     * Mendapatkan link ke halaman detail tiket
     */
    public function Link()
    {
        $page = EventPage::get()->first();
        if ($page) {
            return $page->Link('ticket/' . $this->ID);
        }
        return '';
    }

    /**
     * Alias untuk Link() - untuk kompatibilitas template
     */
    public function getLink()
    {
        return $this->Link();
    }

    /**
     * Check if current user has this ticket in wishlist
     * 
     * @return bool
     */
    public function getIsInWishlist()
    {
        $user = Security::getCurrentUser();
        
        if (!$user) {
            return false;
        }
        
        $wishlist = Wishlist::get()->filter([
            'TicketID' => $this->ID,
            'MemberID' => $user->ID
        ])->first();
        
        return $wishlist ? true : false;
    }
    
    /**
     * Get wishlist ID for current user (untuk remove dari wishlist)
     * 
     * @return int|null
     */
    public function getWishlistID()
    {
        $user = Security::getCurrentUser();
        
        if (!$user) {
            return null;
        }
        
        $wishlist = Wishlist::get()->filter([
            'TicketID' => $this->ID,
            'MemberID' => $user->ID
        ])->first();
        
        return $wishlist ? $wishlist->ID : null;
    }

    public function getEventTimeFormatted()
    {
        if (!$this->EventTime) {
            return null;
        }

        // Format: 08.00
        $formatted = date('H.i', strtotime($this->EventTime));

        return $formatted . ' WIB';
    }

}