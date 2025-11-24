<?php
use SilverStripe\ORM\DataObject;
use SilverStripe\Forms\NumericField;
use SilverStripe\Forms\TextField;
use SilverStripe\Forms\TextareaField;

class TicketType extends DataObject
{
    private static $table_name = 'TicketType';
    
    private static $db = [
        'TypeName'     => 'Varchar(100)',
        'Price'        => 'Int',
        'Description'  => 'Text',
        'Capacity'     => 'Int',
        'MaxPerMember' => 'Int',
        'SortOrder'    => 'Int'
    ];
    
    private static $has_one = [
        'Ticket' => Ticket::class
    ];
    
    private static $summary_fields = [
        'TypeName'        => 'Tipe Tiket',
        'FormattedPrice'  => 'Harga',
        'Capacity'        => 'Kapasitas',
        'MaxPerMember'    => 'Maks per Member',
        'Description'     => 'Deskripsi'
    ];
    
    private static $defaults = [
        'MaxPerMember' => 5
    ];
    
    private static $default_sort = 'SortOrder ASC, Price ASC';
    
    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        $fields->removeByName(['TicketID', 'SortOrder']);
        
        $fields->addFieldsToTab('Root.Main', [
            TextField::create('TypeName', 'Nama Tipe Tiket')
                ->setDescription('Contoh: Early Bird, Regular, VIP, VVIP'),
            
            NumericField::create('Price', 'Harga (Rp)')
                ->setDescription('Masukkan harga tanpa titik atau koma, contoh: 150000 untuk Rp 150.000'),
            
            NumericField::create('Capacity', 'Kapasitas Tiket')
                ->setDescription('Jumlah tiket yang tersedia untuk tipe ini'),
            
            NumericField::create('MaxPerMember', 'Maksimal Pembelian per Member')
                ->setDescription('Jumlah maksimal tiket yang dapat dibeli oleh satu member untuk tipe ini')
                ->setAttribute('min', 1),
            
            TextareaField::create('Description', 'Deskripsi')
                ->setDescription('Deskripsi singkat tentang tipe tiket ini. <strong>MAKSIMAL 20 KATA</strong>')
                ->setRows(1)
                ->setAttribute('maxlength', 200) // Batasi karakter sebagai proteksi tambahan
        ]);
        
        return $fields;
    }
    
    public function getFormattedPrice()
    {
        if ($this->Price == 0) {
            return 'GRATIS';
        }
        return 'Rp ' . number_format($this->Price, 0, ',', '.');
    }
    
    public function getTitle()
    {
        return $this->TypeName;
    }
    
    /**
     * Validate before writing to database
     */
    public function validate()
    {
        $result = parent::validate();
        
        // Validate Description word count
        if ($this->Description) {
            $wordCount = str_word_count(trim($this->Description), 0, 'àáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿĀāĂăĄą');
            
            if ($wordCount > 20) {
                $result->addError(
                    "Deskripsi tidak boleh lebih dari 20 kata. " .
                    "Jumlah kata saat ini: <strong>{$wordCount} kata</strong>. " .
                    "Silakan hapus " . ($wordCount - 20) . " kata."
                );
            }
        }
        
        return $result;
    }
    
    /**
     * Automatically truncate description to 20 words before saving
     * Uncomment this if you want auto-truncate instead of validation error
     */
    /*
    public function onBeforeWrite()
    {
        parent::onBeforeWrite();
        
        if ($this->Description) {
            $words = preg_split('/\s+/', trim($this->Description));
            if (count($words) > 20) {
                $this->Description = implode(' ', array_slice($words, 0, 20));
            }
        }
    }
    */
    
    /**
     * Get purchase info for member
     */
    public function getPurchaseInfo($memberID)
    {
        $totalPurchased = Order::getTotalPurchasedByMember($memberID, $this->ID);
        $remaining = $this->MaxPerMember - $totalPurchased;
        
        return [
            'TotalPurchased' => $totalPurchased,
            'MaxPerMember' => $this->MaxPerMember,
            'Remaining' => max(0, $remaining),
            'HasReachedLimit' => $remaining <= 0
        ];
    }
}