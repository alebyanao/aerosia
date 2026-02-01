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
use SilverStripe\Forms\DropdownField;
use SilverStripe\Forms\LiteralField;
use SilverStripe\Forms\CheckboxField;
use SilverStripe\Forms\CheckboxSetField;
use SilverStripe\Security\Permission;
use SilverStripe\Security\Member;

class Ticket extends DataObject
{
    private static $table_name = 'Ticket';

    private static $db = [  
        'Title'       => 'Varchar(255)',
        'EventDate'   => 'Date',
        'EventTime'   => 'Time',
        'ProvinceID'  => 'Varchar(10)',  
        'ProvinceName'=> 'Varchar(100)', 
        'CityID'      => 'Varchar(10)',  
        'CityName'    => 'Varchar(100)', 
        'Location'    => 'Varchar(255)',
        'EventMapURL' => 'Varchar(255)',
        'Instagram' => 'Varchar(50)',
        'InstagramURL' => 'Varchar(50)',
        'Description' => 'HTMLText',
    ];

    private static $has_many = [
        'TicketTypes' => TicketType::class,
        'Wishlist' => Wishlist::class
    ];

    private static $has_one = [
        'Image' => Image::class,
        'Category' => Category::class,
        'Member' => Member::class,
    ];

    private static $owns = [
        'Image',
    ];

    private static $summary_fields = [
        'Title'              => 'Judul Event',
        'EventDate'          => 'Tanggal Event',
        'Category.Name'      => 'Kategori',
        'ProvinceName'       => 'Provinsi',
        'CityName'           => 'Kota', 
        'Location'           => 'Lokasi',
        'MinPriceFormatted'  => 'Harga Mulai Dari',
        'StatusBadge'        => 'Status',
    ];


    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        $fields->removeByName(['TicketTypes', 'ProvinceID', 'ProvinceName', 'CityID', 'CityName', 'IsExpired', 'CategoryID']);

        // Get provinces from API
        $provinces = IndonesiaRegionAPI::getProvinces();
        
        // Provinsi Dropdown
        $provinceField = DropdownField::create('ProvinceID', 'Provinsi')
            ->setSource($provinces)
            ->setEmptyString('-- Pilih Provinsi --')
            ->setAttribute('data-dynamic-target', 'city');
        
        // Kota Dropdown
        $citySource = ['Loading...'];
        if ($this->ProvinceID) {
            $citySource = IndonesiaRegionAPI::getCitiesByProvince($this->ProvinceID);
        }
        
        $cityField = DropdownField::create('CityID', 'Kota/Kabupaten')
            ->setSource($citySource)
            ->setEmptyString($this->ProvinceID ? '-- Pilih Kota/Kabupaten --' : '-- Pilih Provinsi Terlebih Dahulu --')
            ->setAttribute('data-dynamic-city', 'true');

        // Category Dropdown
        $categoryField = DropdownField::create(
            'CategoryID',
            'Kategori Event',
            Category::get()->map('ID', 'Name')
        )
        ->setEmptyString('-- Pilih Kategori --')
        ->setDescription('Pilih kategori untuk event ini');
        
        $fields->addFieldsToTab('Root.Main', [
            $categoryField,
            $provinceField,
            $cityField,
            
            LiteralField::create('DynamicCityScript', '
                <script>
                (function() {
                    function attachProvinceListener() {
                        const provinceSelect = document.querySelector("[name=\'ProvinceID\']");
                        const citySelect = document.querySelector("[name=\'CityID\']");
                        
                        if (!provinceSelect || !citySelect) {
                            setTimeout(attachProvinceListener, 100);
                            return;
                        }
                        
                        provinceSelect.removeEventListener("change", handleProvinceChange);
                        provinceSelect.addEventListener("change", handleProvinceChange);
                        
                        function handleProvinceChange() {
                            const provinceId = this.value;
                            
                            citySelect.innerHTML = "<option value=\'\'>Loading...</option>";
                            citySelect.disabled = true;
                            
                            if (!provinceId) {
                                citySelect.innerHTML = "<option value=\'\'>-- Pilih Provinsi Terlebih Dahulu --</option>";
                                citySelect.disabled = false;
                                return;
                            }
                            
                            fetch(`/admin/tickets/citylist?province=${provinceId}`)
                                .then(response => response.json())
                                .then(data => {
                                    citySelect.innerHTML = "<option value=\'\'>-- Pilih Kota/Kabupaten --</option>";
                                    
                                    data.forEach(city => {
                                        const option = document.createElement("option");
                                        option.value = city.id;
                                        option.textContent = city.name;
                                        citySelect.appendChild(option);
                                    });
                                    
                                    citySelect.disabled = false;
                                })
                                .catch(error => {
                                    console.error("Error loading cities:", error);
                                    citySelect.innerHTML = "<option value=\'\'>Error loading cities</option>";
                                    citySelect.disabled = false;
                                });
                        }
                    }
                    
                    attachProvinceListener();
                    
                    if (typeof jQuery !== "undefined") {
                        jQuery(document).on("ajaxComplete", function() {
                            setTimeout(attachProvinceListener, 100);
                        });
                    }
                })();
                </script>
            '),
            
            TextField::create('Location', 'Lokasi Lengkap Event')
                ->setDescription('Contoh: Gedung Serbaguna, Jl. Sudirman No. 123'),
                
            TextField::create('EventMapURL', 'Google Map URL'),
            TimeField::create('EventTime', 'Jam Acara')->setHTML5(true), 
            TextField::create('Instagram', 'Username Instagram (opsional)'),
            TextField::create('InstagramURL', 'Link Instagram (opsional)'),
            UploadField::create('Image', 'Gambar Tiket')
                ->setFolderName('tickets')
                ->setAllowedExtensions(['jpg', 'jpeg', 'png', 'gif', 'svg']),
            HTMLEditorField::create('Description', 'Deskripsi Event')->setRows(15),
        ]);

        // Tampilkan status expired di CMS (read-only)
        if ($this->exists()) {
            $statusField = CheckboxField::create('IsExpired', 'Event Berakhir')
                ->setReadonly(true)
                ->setDescription('Status ini diupdate otomatis oleh sistem');
            $fields->addFieldToTab('Root.Main', $statusField);
        }

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
                LiteralField::create(
                    'FirstSaveNotice',
                    '<p class="alert alert-info">Simpan tiket terlebih dahulu sebelum menambahkan tipe & harga tiket.</p>'
                )
            );
        }

        return $fields;
    }

    public function checkIfExpired()
    {
        if (!$this->EventDate) {
            return false;
        }

        $eventDateTime = $this->EventDate;
        if ($this->EventTime) {
            $eventDateTime .= ' ' . $this->EventTime;
        } else {
            $eventDateTime .= ' 23:59:59';
        }

        $eventTimestamp = strtotime($eventDateTime);
        $currentTimestamp = time();

        return $currentTimestamp > $eventTimestamp;
    }

    /**
     * Get status badge untuk CMS GridField
     */
    public function getStatusBadge()
    {
        if ($this->IsExpired) {
            return '<span style="background: #dc3545; color: white; padding: 3px 8px; border-radius: 3px; font-size: 11px;">BERAKHIR</span>';
        }
        return '<span style="background: #28a745; color: white; padding: 3px 8px; border-radius: 3px; font-size: 11px;">AKTIF</span>';
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
    public function getMinPriceFormatted()
    {
        if ($this->IsExpired) {
            return 'BERAKHIR';
        }

        $minPrice = $this->getMinPrice();

        if ($minPrice === null) {
            return '-';
        }

        if ((float)$minPrice <= 0) {
            return 'GRATIS';
        }

        return 'Rp ' . number_format($minPrice, 0, ',', '.');
    }

    /**
     * Mendapatkan label harga untuk card
     */
    public function getPriceLabel()
    {
        if ($this->IsExpired) {
            return 'Event Telah Berakhir';
        }

        $count = $this->TicketTypes()->count();
        if ($count > 0) {
            return ' ' . $this->getMinPriceFormatted();
        }
        return 'Harga belum tersedia';
    }

    /**
     * Check apakah tiket bisa dipesan
     */
    public function canBeOrdered()
    {
        return !$this->IsExpired;
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
     * Alias untuk Link()
     */
    public function getLink()
    {
        return $this->Link();
    }

    /**
     * Check if current user has this ticket in wishlist
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
     * Get wishlist ID for current user
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

        $formatted = date('H.i', strtotime($this->EventTime));
        return $formatted . ' WIB';
    }

    public function onBeforeWrite(): void
    {
        parent::onBeforeWrite();

        if (!$this->MemberID && ($member = Security::getCurrentUser())) {
            $this->MemberID = $member->ID;
        }

        $this->IsExpired = $this->checkIfExpired();

        // Jika province berubah, reset city
        if ($this->isChanged('ProvinceID')) {
            $this->CityID = null;
            $this->CityName = null;
        }

        if ($this->ProvinceID) {
            $this->ProvinceName = IndonesiaRegionAPI::getProvinceName(
                provinceId: $this->ProvinceID
            );
        }

        if ($this->CityID && $this->ProvinceID) {
            $this->CityName = IndonesiaRegionAPI::getCityName(
                provinceId: $this->ProvinceID,
                cityId: $this->CityID
            );
        }
    }
// ... code atas tetap sama ...

    /**
     * PERMISSION FIX
     */

    public function canView($member = null)
    {
        if (!$member) $member = Security::getCurrentUser();
        if (!$member) return false;

        // 1. Super Admin Bebas
        if (Permission::checkMember($member, 'ADMIN')) return true;

        // 2. FIX: Jika tiket BELUM ADA di database (lagi create baru),
        // izinkan lihat form-nya asalkan dia punya akses CMS
        if (!$this->exists() && Permission::checkMember($member, 'CMS_ACCESS_EventAdmin')) {
            return true;
        }

        // 3. Jika tiket SUDAH ADA, cek kepemilikan
        return $member->ID == $this->MemberID;
    }

    public function canEdit($member = null)
    {
        if (!$member) $member = Security::getCurrentUser();
        if (!$member) return false;

        if (Permission::checkMember($member, 'ADMIN')) return true;

        // FIX: Izinkan edit (isi form) untuk tiket baru
        if (!$this->exists() && Permission::checkMember($member, 'CMS_ACCESS_EventAdmin')) {
            return true;
        }

        return $member->ID == $this->MemberID;
    }
    
    // Pastikan canCreate juga tetap ada
    public function canCreate($member = null, $context = [])
    {
        if (!$member) $member = Security::getCurrentUser();
        if (!$member) return false;
        
        return Permission::checkMember($member, 'CMS_ACCESS_EventAdmin') || 
               Permission::checkMember($member, 'ADMIN');
    }

    // ... sisa code ...

    /**
     * Siapa yang boleh menghapus tiket ini?
     */
    public function canDelete($member = null)
    {
        if (!$member) $member = Security::getCurrentUser();
        
        if (Permission::checkMember($member, 'ADMIN')) return true;

        return $member && $member->ID == $this->MemberID;
    }

}