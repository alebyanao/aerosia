<?php

namespace {

    use SilverStripe\CMS\Controllers\ContentController;
    use SilverStripe\SiteConfig\SiteConfig;
    use SilverStripe\Security\Security;
    use SilverStripe\View\ArrayData;
    use SilverStripe\ORM\ArrayList;
    use SilverStripe\ORM\DB;
    use SilverStripe\Control\HTTPRequest;

    class PageController extends ContentController
    {
        /**
         * Get common data untuk semua pages
         */
        protected function getCommonData()
        {
            return [
                "IsLoggedIn" => $this->isLoggedIn(),
                "CurrentUser" => $this->getCurrentUser(),
                "WishlistCount" => $this->getWishlistCount(),
                "CustomSiteConfig" => SiteConfig::current_site_config(),
                "SearchQuery" => $this->getRequest()->getVar('search'),
                "ProvinceFilter" => $this->getRequest()->getVar('province'),
                "CityFilter" => $this->getRequest()->getVar('city'),
            ];
        }

        public function index(HTTPRequest $request)
        {
            $carouselImages = CarouselImage::get();
            $categories = Category::get();

        
            $data = array_merge($this->getCommonData(), [
                "CarouselImage" => $carouselImages,
                "Category" => $categories,
            ]);

            return $this->customise($data)->renderWith('Page');
        }

        /**
         * Check if user is logged in
         */
        public function isLoggedIn()
        {
            return Security::getCurrentUser() ? true : false;
        }

        /**
         * Get current logged in user
         */
        public function getCurrentUser()
        {
            return Security::getCurrentUser();
        }

        /**
         * Get user message from session
         */
        public function getUserMessage()
        {
            $message = $this->getRequest()->getSession()->get('UserMessage');
            if ($message) {
                $this->getRequest()->getSession()->clear('UserMessage');
                return $message;
            }
            return null;
        }

        /**
         * Get wishlist count for current user
         */
        public function getWishlistCount()
        {
            if ($this->isLoggedIn()) {
                $user = $this->getCurrentUser();
                if ($user && $user->exists()) {
                    try {
                        $count = Wishlist::get()->filter('MemberID', $user->ID)->count();
                        return $count ? (int) $count : 0;
                    } catch (Exception $e) {
                        error_log("Error getting wishlist count: " . $e->getMessage());
                        return 0;
                    }
                }   
            }
            return 0;
        }
        public function getFilteredTickets(
            $searchQuery = null, 
            $provinceId = null, 
            $cityId = null,
            $month = null,
            $year = null,
            $minPrice = null,
            $maxPrice = null,
            $sort = 'date_asc'
        ) {
            $tickets = Ticket::get();

            // Filter by search query
            if ($searchQuery) {
                $tickets = $tickets->filterAny([
                    'Title:PartialMatch' => $searchQuery,
                    'Description:PartialMatch' => $searchQuery,
                    'Location:PartialMatch' => $searchQuery,
                ]);
            }

            // Filter by Province
            if ($provinceId) {
                $tickets = $tickets->filter('ProvinceID', $provinceId);
            }

            // Filter by City
            if ($cityId) {
                $tickets = $tickets->filter('CityID', $cityId);
            }

            // Filter by month
            if ($month) {
                $tickets = $tickets->where("MONTH(EventDate) = " . (int)$month);
            }
            
            // Filter by year
            if ($year) {
                $tickets = $tickets->where("YEAR(EventDate) = " . (int)$year);
            }
            
            // Filter by price range
            if ($minPrice !== null || $maxPrice !== null) {
                // Get ticket IDs that match price criteria
                $sql = "SELECT DISTINCT TicketID FROM TicketType WHERE 1=1";
                
                if ($minPrice !== null && $minPrice !== '') {
                    $sql .= " AND Price >= " . (int)$minPrice;
                }
                
                if ($maxPrice !== null && $maxPrice !== '') {
                    $sql .= " AND Price <= " . (int)$maxPrice;
                }
                
                $result = DB::query($sql);
                $ticketIds = [];
                
                foreach ($result as $row) {
                    $ticketIds[] = $row['TicketID'];
                }
                
                if (empty($ticketIds)) {
                    // No tickets match price criteria
                    return ArrayList::create();
                }
                
                $tickets = $tickets->filter('ID', $ticketIds);
            }
            
            // Apply sorting with expired events at bottom
            return $this->sortTicketsWithExpiredAtBottom($tickets, $sort);
        }
        protected function sortTicketsWithExpiredAtBottom($tickets, $sort)
        {
            $ticketArray = $tickets->toArray();
            $today = date('Y-m-d');
            
            // Separate expired and active tickets
            $activeTickets = [];
            $expiredTickets = [];
            
            foreach ($ticketArray as $ticket) {
                if ($ticket->EventDate < $today) {
                    $expiredTickets[] = $ticket;
                } else {
                    $activeTickets[] = $ticket;
                }
            }
            
            // Sort active tickets
            $activeTickets = $this->sortTicketArray($activeTickets, $sort);
            
            // Sort expired tickets (same logic)
            $expiredTickets = $this->sortTicketArray($expiredTickets, $sort);
            
            // Merge: active first, expired last
            $sortedTickets = array_merge($activeTickets, $expiredTickets);
            
            return ArrayList::create($sortedTickets);
        }
        protected function sortTicketArray($ticketArray, $sort)
        {
            switch ($sort) {
                case 'date_desc':
                    usort($ticketArray, function($a, $b) {
                        return strcmp($b->EventDate, $a->EventDate);
                    });
                    break;
                    
                case 'name_asc':
                    usort($ticketArray, function($a, $b) {
                        return strcmp($a->Title, $b->Title);
                    });
                    break;
                    
                case 'name_desc':
                    usort($ticketArray, function($a, $b) {
                        return strcmp($b->Title, $a->Title);
                    });
                    break;
                    
                case 'price_asc':
                    usort($ticketArray, function($a, $b) {
                        $priceA = $a->getMinPrice();
                        $priceB = $b->getMinPrice();
                        
                        if ($priceA === 0 || $priceA === null) $priceA = PHP_INT_MAX;
                        if ($priceB === 0 || $priceB === null) $priceB = PHP_INT_MAX;
                        
                        return $priceA <=> $priceB;
                    });
                    break;
                    
                case 'price_desc':
                    usort($ticketArray, function($a, $b) {
                        $priceA = $a->getMinPrice();
                        $priceB = $b->getMinPrice();
                        
                        if ($priceA === 0 || $priceA === null) $priceA = -1;
                        if ($priceB === 0 || $priceB === null) $priceB = -1;
                        
                        return $priceB <=> $priceA;
                    });
                    break;
                    
                default: 
                    usort($ticketArray, function($a, $b) {
                        return strcmp($a->EventDate, $b->EventDate);
                    });
            }
            
            return $ticketArray;
        }
        protected function sortTicketsByPrice($tickets, $direction)
        {
            return $this->sortTicketsWithExpiredAtBottom($tickets, $direction);
        }

    public function UpcomingTickets()
    {
        return Ticket::get()
            ->filter([
                'IsExpired' => false,
            ])
            ->filter('EventDate:GreaterThanOrEqual', date('Y-m-d'))
            ->sort('EventDate', 'ASC')
            ->limit(6);
    }

    /**
     * Event berakhir
     */
    public function ExpiredTickets()
    {
        return Ticket::get()
            ->filter('IsExpired', true)
            ->sort('EventDate', 'DESC')
            ->limit(6);
    }

    }
}