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
     * Index method dengan enhanced filters
     */
    public function index(HTTPRequest $request)
    {
        // Get all filter parameters
        $searchQuery = $request->getVar('search');
        $provinceId = $request->getVar('province');
        $cityId = $request->getVar('city');
        $month = $request->getVar('month');
        $year = $request->getVar('year');
        $minPrice = $request->getVar('min_price');
        $maxPrice = $request->getVar('max_price');
        $sort = $request->getVar('sort') ?: 'date_asc';
        
        // Get filtered tickets using parent method
        $tickets = $this->getFilteredTickets(
            $searchQuery,
            $provinceId, 
            $cityId, 
            $month, 
            $year,
            $minPrice,
            $maxPrice,
            $sort
        );

        // Get price range from database
        $priceRange = $this->getPriceRange();

        $data = array_merge($this->getCommonData(), [
            'Tickets' => $tickets,
            'CurrentProvince' => $provinceId,
            'CurrentCity' => $cityId,
            'CurrentMonth' => $month,
            'CurrentYear' => $year,
            'CurrentMinPrice' => $minPrice ?: 0,
            'CurrentMaxPrice' => $maxPrice,
            'CurrentSort' => $sort,
            'MinPriceRange' => $priceRange['min'],
            'MaxPriceRange' => $priceRange['max'],
        ]);

        return $this->customise($data)->renderWith(['EventPage', 'Page']);
    }

    /**
     * Get min and max price from all ticket types
     */
    public function getPriceRange()
    {
        $ticketTypes = TicketType::get()->filter('Price:GreaterThan', 0);
        
        $minPrice = 0;
        $maxPrice = 1000000;
        
        if ($ticketTypes->count() > 0) {
            $minPrice = (int)$ticketTypes->min('Price');
            $maxPrice = (int)$ticketTypes->max('Price');
        }
        
        return [
            'min' => $minPrice,
            'max' => $maxPrice
        ];
    }

    /**
     * Get province list for dropdown
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
     * Get city list for dropdown
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
     * Get month list for dropdown
     */
    public function getMonthList()
    {
        $request = $this->getRequest();
        $currentMonth = $request->getVar('month');
        
        $months = [
            '1' => 'Januari',
            '2' => 'Februari',
            '3' => 'Maret',
            '4' => 'April',
            '5' => 'Mei',
            '6' => 'Juni',
            '7' => 'Juli',
            '8' => 'Agustus',
            '9' => 'September',
            '10' => 'Oktober',
            '11' => 'November',
            '12' => 'Desember'
        ];
        
        $list = [];
        foreach ($months as $value => $label) {
            $list[] = ArrayData::create([
                'Value' => $value,
                'Label' => $label,
                'Selected' => ($value == $currentMonth)
            ]);
        }
        
        return ArrayList::create($list);
    }

    /**
     * Get year list for dropdown (current year - 1 to current year + 2)
     */
    public function getYearList()
    {
        $request = $this->getRequest();
        $currentYear = $request->getVar('year');
        
        $thisYear = (int)date('Y');
        $years = range($thisYear - 1, $thisYear + 2);
        
        $list = [];
        foreach ($years as $year) {
            $list[] = ArrayData::create([
                'Value' => $year,
                'Label' => $year,
                'Selected' => ($year == $currentYear)
            ]);
        }
        
        return ArrayList::create($list);
    }
    
    /**
     * Get current province
     */
    public function getCurrentProvince()
    {
        return $this->getRequest()->getVar('province');
    }
    
    /**
     * Get current city
     */
    public function getCurrentCity()
    {
        return $this->getRequest()->getVar('city');
    }

    /**
     * Get current province name
     */
    public function getCurrentProvinceName()
    {
        $provinceId = $this->getCurrentProvince();
        if (!$provinceId) return null;
        
        return IndonesiaRegionAPI::getProvinceName($provinceId);
    }

    /**
     * Get current city name
     */
    public function getCurrentCityName()
    {
        $provinceId = $this->getCurrentProvince();
        $cityId = $this->getCurrentCity();
        
        if (!$provinceId || !$cityId) return null;
        
        return IndonesiaRegionAPI::getCityName($provinceId, $cityId);
    }

    /**
     * Get current month name
     */
    public function getCurrentMonthName()
    {
        $month = $this->getRequest()->getVar('month');
        if (!$month) return null;
        
        $months = [
            '1' => 'Januari', '2' => 'Februari', '3' => 'Maret', 
            '4' => 'April', '5' => 'Mei', '6' => 'Juni',
            '7' => 'Juli', '8' => 'Agustus', '9' => 'September', 
            '10' => 'Oktober', '11' => 'November', '12' => 'Desember'
        ];
        
        return $months[$month] ?? null;
    }

    /**
     * Check if has active filters
     */
    public function getHasActiveFilters()
    {
        $request = $this->getRequest();
        return $request->getVar('province') 
            || $request->getVar('city')
            || $request->getVar('month')
            || $request->getVar('year')
            || $request->getVar('min_price')
            || $request->getVar('max_price');
    }

    /**
     * Get link without specific filter
     */
    public function LinkWithoutFilter($filterName)
    {
        $request = $this->getRequest();
        $params = $request->getVars();
        
        // Remove the specified filter
        unset($params['url']);
        unset($params[$filterName]);
        
        // If removing province, also remove city
        if ($filterName === 'province') {
            unset($params['city']);
        }
        
        $queryString = http_build_query($params);
        return $this->Link() . ($queryString ? '?' . $queryString : '');
    }

    /**
     * Detail method
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
     * Get ticket untuk template
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