<?php

namespace {

    use SilverStripe\CMS\Controllers\ContentController;
    use SilverStripe\SiteConfig\SiteConfig;
    use SilverStripe\Security\Security;
    use SilverStripe\View\ArrayData;

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
         * Get filtered tickets (dengan search, province, dan city filter)
         * Method ini bisa di-override di child controller kalau perlu
         */
        public function getFilteredTickets($searchQuery = null, $provinceId = null, $cityId = null)
        {
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

            return $tickets->sort('EventDate ASC');
        }
    }
}