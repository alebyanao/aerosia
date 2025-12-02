<?php

namespace {

    use SilverStripe\CMS\Controllers\ContentController;
    use SilverStripe\SiteConfig\SiteConfig;
    use SilverStripe\Security\Security;
    use SilverStripe\View\ArrayData;
    use SilverStripe\ORM\ArrayList;
    use SilverStripe\ORM\DB;

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

        /**
         * Get filtered tickets dengan enhanced filters
         * Method ini bisa di-override di child controller kalau perlu
         * 
         * @param string|null $searchQuery Search term
         * @param string|null $provinceId Province ID
         * @param string|null $cityId City ID
         * @param string|null $month Month (1-12)
         * @param string|null $year Year (YYYY)
         * @param string|null $minPrice Minimum price
         * @param string|null $maxPrice Maximum price
         * @param string $sort Sort option (date_asc, date_desc, name_asc, name_desc, price_asc, price_desc)
         * @return \SilverStripe\ORM\DataList|\SilverStripe\ORM\ArrayList
         */
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
            
            // Apply sorting
            switch ($sort) {
                case 'date_desc':
                    $tickets = $tickets->sort('EventDate DESC');
                    break;
                case 'name_asc':
                    $tickets = $tickets->sort('Title ASC');
                    break;
                case 'name_desc':
                    $tickets = $tickets->sort('Title DESC');
                    break;
                case 'price_asc':
                case 'price_desc':
                    // For price sorting, we need custom logic
                    return $this->sortTicketsByPrice($tickets, $sort);
                default: // date_asc
                    $tickets = $tickets->sort('EventDate ASC');
            }

            return $tickets;
        }

        /**
         * Sort tickets by price (min price)
         * 
         * @param \SilverStripe\ORM\DataList $tickets
         * @param string $direction 'price_asc' or 'price_desc'
         * @return \SilverStripe\ORM\ArrayList
         */
        protected function sortTicketsByPrice($tickets, $direction)
        {
            $ticketArray = $tickets->toArray();
            
            usort($ticketArray, function($a, $b) use ($direction) {
                $priceA = $a->getMinPrice();
                $priceB = $b->getMinPrice();
                
                // Handle null/zero prices - push to end
                if ($priceA === 0 || $priceA === null) $priceA = PHP_INT_MAX;
                if ($priceB === 0 || $priceB === null) $priceB = PHP_INT_MAX;
                
                if ($direction === 'price_asc') {
                    return $priceA <=> $priceB;
                } else {
                    return $priceB <=> $priceA;
                }
            });
            
            return ArrayList::create($ticketArray);
        }
    }
}