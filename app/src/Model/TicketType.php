<?php

use SilverStripe\ORM\DataObject;
use SilverStripe\Forms\NumericField;
use SilverStripe\Forms\TextField;

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
            
            TextField::create('Description', 'Deskripsi')
                ->setDescription('Deskripsi singkat tentang tipe tiket ini')
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

    // ========================================
    // TAMBAHKAN METHOD INI DI BAWAH
    // ========================================

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