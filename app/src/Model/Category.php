<?php

use SilverStripe\ORM\DataObject;
use SilverStripe\Forms\TextField;
use SilverStripe\Forms\TextareaField;
use SilverStripe\Forms\GridField\GridField;
use SilverStripe\Forms\GridField\GridFieldConfig_RecordEditor;

class Category extends DataObject
{
    private static $table_name = 'Category';

    private static $db = [
        'Name' => 'Varchar(100)',
        'Sort' => 'Int'
    ];

    private static $has_many = [
        'Tickets' => Ticket::class
    ];

    private static $default_sort = 'Sort ASC, Name ASC';

    private static $summary_fields = [
        'Name' => 'Nama Kategori',
        'TicketCount' => 'Jumlah Event'
    ];

    private static $searchable_fields = [
        'Name',
    ];

    public function getCMSFields()
    {
        $fields = parent::getCMSFields();
        
        $fields->removeByName(['Sort', 'Tickets']);

        $fields->addFieldsToTab('Root.Main', [
            TextField::create('Name', 'Nama Kategori')
                ->setDescription('Contoh: Musik, Olahraga, Seminar, Festival')
                ->setAttribute('placeholder', 'Masukkan nama kategori'),
        ]);

        // GridField untuk melihat tiket yang menggunakan kategori ini
        if ($this->ID) {
            $ticketsConfig = GridFieldConfig_RecordEditor::create();
            
            $fields->addFieldToTab(
                'Root.Event',
                GridField::create(
                    'Tickets',
                    'Event dalam Kategori Ini',
                    $this->Tickets(),
                    $ticketsConfig
                )
            );
        }

        return $fields;
    }

    /**
     * Get jumlah tiket yang menggunakan kategori ini
     */
    public function getTicketCount()
    {
        return $this->Tickets()->count();
    }

    /**
     * Validasi sebelum menyimpan
     */
    public function validate()
    {
        $result = parent::validate();

        if (empty($this->Name)) {
            $result->addError('Nama kategori harus diisi');
        }

        // Cek duplikasi nama kategori
        $existing = Category::get()->filter('Name', $this->Name)->exclude('ID', $this->ID)->first();
        if ($existing) {
            $result->addError('Kategori dengan nama ini sudah ada');
        }

        return $result;
    }

    /**
     * Prevent deletion if category is being used
     */
    public function canDelete($member = null)
    {
        if ($this->Tickets()->count() > 0) {
            return false;
        }
        return parent::canDelete($member);
    }

    public function onBeforeWrite()
    {
        parent::onBeforeWrite();

        // Auto set sort order jika belum ada
        if (!$this->Sort) {
            $maxSort = Category::get()->max('Sort');
            $this->Sort = $maxSort ? $maxSort + 1 : 1;
        }
    }
}