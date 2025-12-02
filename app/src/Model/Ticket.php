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
        'ProvinceName'       => 'Provinsi',
        'CityName'           => 'Kota', 
        'Location'           => 'Lokasi',
        'MinPriceFormatted'  => 'Harga Mulai Dari',
    ];

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        $fields->removeByName(['TicketTypes', 'ProvinceID', 'ProvinceName', 'CityID', 'CityName']);

        // Get provinces from API
        $provinces = IndonesiaRegionAPI::getProvinces();
        
        // Provinsi Dropdown
        $provinceField = DropdownField::create('ProvinceID', 'Provinsi')
            ->setSource($provinces)
            ->setEmptyString('-- Pilih Provinsi --')
            ->setAttribute('data-dynamic-target', 'city'); // Tambahkan attribute
        
        // Kota Dropdown - selalu load cities jika provinsi sudah ada
        $citySource = ['Loading...'];
        if ($this->ProvinceID) {
            $citySource = IndonesiaRegionAPI::getCitiesByProvince($this->ProvinceID);
        }
        
        $cityField = DropdownField::create('CityID', 'Kota/Kabupaten')
            ->setSource($citySource)
            ->setEmptyString($this->ProvinceID ? '-- Pilih Kota/Kabupaten --' : '-- Pilih Provinsi Terlebih Dahulu --')
            ->setAttribute('data-dynamic-city', 'true'); // Tambahkan attribute
        
        $fields->addFieldsToTab('Root.Main', [
            $provinceField,
            $cityField,
            
            // JavaScript yang lebih reliable
            LiteralField::create('DynamicCityScript', '
                <script>
                (function() {
                    // Function untuk attach event listener
                    function attachProvinceListener() {
                        const provinceSelect = document.querySelector("[name=\'ProvinceID\']");
                        const citySelect = document.querySelector("[name=\'CityID\']");
                        
                        if (!provinceSelect || !citySelect) {
                            // Retry setelah 100ms jika element belum ada
                            setTimeout(attachProvinceListener, 100);
                            return;
                        }
                        
                        // Remove existing listener jika ada
                        provinceSelect.removeEventListener("change", handleProvinceChange);
                        provinceSelect.addEventListener("change", handleProvinceChange);
                        
                        function handleProvinceChange() {
                            const provinceId = this.value;
                            
                            // Reset city dropdown
                            citySelect.innerHTML = "<option value=\'\'>Loading...</option>";
                            citySelect.disabled = true;
                            
                            if (!provinceId) {
                                citySelect.innerHTML = "<option value=\'\'>-- Pilih Provinsi Terlebih Dahulu --</option>";
                                citySelect.disabled = false;
                                return;
                            }
                            
                            // Fetch cities from API
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
                    
                    // Initial attach
                    attachProvinceListener();
                    
                    // Re-attach setelah form reload (SilverStripe AJAX)
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
}