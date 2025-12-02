<?php

use SilverStripe\Security\Security;
use SilverStripe\View\ArrayData;
use SilverStripe\Control\HTTPRequest;
use SilverStripe\ORM\ArrayList;

class EventPageController extends PageController
{
    private static $allowed_actions = [
        'detail',
        'ticket'
    ];

    private static $url_handlers = [
        'ticket/$ID' => 'detail'
    ];

    /**
     * Index method dengan search + filter functionality
     */
    public function index(HTTPRequest $request)
    {
        $searchQuery = $request->getVar('search');
        $provinceId = $request->getVar('province');
        $cityId = $request->getVar('city');
        
        // Get filtered tickets (method dari parent PageController)
        $tickets = $this->getFilteredTickets($searchQuery, $provinceId, $cityId);

        $data = array_merge($this->getCommonData(), [
            'Tickets' => $tickets,
        ]);

        return $this->customise($data)->renderWith(['EventPage', 'Page']);
    }

    /**
     * Menampilkan daftar semua tiket (tanpa filter)
     */
    public function Tickets()
    {
        return Ticket::get()->sort('EventDate ASC');
    }

    /**
     * Get province list for dropdown filter
     */
    public function getProvinceList()
    {
        $request = $this->getRequest();
        $currentProvince = $request->getVar('province');
        
        $provinces = IndonesiaRegionAPI::getProvinces();
        
        $list = [];
        foreach ($provinces as $id => $name) {
            $list[] = ArrayData::create([
                'ID' => $id,
                'Name' => $name,
                'Selected' => ($id == $currentProvince)
            ]);
        }
        
        return ArrayList::create($list);
    }
    
    /**
     * Get city list for dropdown (jika province dipilih)
     */
    public function getCityList()
    {
        $request = $this->getRequest();
        $provinceId = $request->getVar('province');
        $currentCity = $request->getVar('city');
        
        if (!$provinceId) {
            return ArrayList::create();
        }
        
        $cities = IndonesiaRegionAPI::getCitiesByProvince($provinceId);
        
        $list = [];
        foreach ($cities as $id => $name) {
            $list[] = ArrayData::create([
                'ID' => $id,
                'Name' => $name,
                'Selected' => ($id == $currentCity)
            ]);
        }
        
        return ArrayList::create($list);
    }
    
    /**
     * Get current province ID (untuk template)
     */
    public function getCurrentProvince()
    {
        return $this->getRequest()->getVar('province');
    }
    
    /**
     * Get current city ID (untuk template)
     */
    public function getCurrentCity()
    {
        return $this->getRequest()->getVar('city');
    }

    /**
     * Menampilkan detail tiket dengan validasi MaxPerMember
     * URL: /events/ticket/123
     */
    public function detail(HTTPRequest $request)
    {
        $id = $request->param('ID');
        $ticket = Ticket::get()->byID($id);

        if (!$ticket) {
            return $this->httpError(404, 'Tiket tidak ditemukan');
        }

        $member = Security::getCurrentUser();
        $memberID = $member ? $member->ID : null;

        // Enhance ticket types with purchase info
        $ticketTypes = $ticket->TicketTypes();
        
        if ($memberID && $ticketTypes->count() > 0) {
            foreach ($ticketTypes as $ticketType) {
                $purchaseInfo = $ticketType->getPurchaseInfo($memberID);
                $ticketType->PurchaseInfo = new ArrayData($purchaseInfo);
            }
        }

        return $this->customise([
            'Ticket' => $ticket,
            'Title' => $ticket->Title,
            'BackLink' => $this->Link(),
            'CurrentMemberID' => $memberID,
        ])->renderWith(['TicketDetail', 'Page']);
    }

    /**
     * Mendapatkan tiket untuk halaman detail
     * Digunakan dalam template
     */
    public function getTicket()
    {
        $id = $this->getRequest()->param('ID');
        if ($id) {
            return Ticket::get()->byID($id);
        }
        return null;
    }
}