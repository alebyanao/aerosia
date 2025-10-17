<?php

namespace {

    use SilverStripe\CMS\Controllers\ContentController;
    use SilverStripe\SiteConfig\SiteConfig;
    use SilverStripe\Security\Security;
    use SilverStripe\View\ArrayData;

    class PageController extends ContentController
    {
       
        // private static $allowed_actions = [];

        // protected function init()
        // {
        //     parent::init();
    
        // }

        protected function getCommonData()
        {
            return [
                "IsLoggedIn" => $this->isLoggedIn(),
                "CurrentUser" => $this->getCurrentUser(),
                "WishlistCount" => $this->getWishlistCount(),
                // "CartCount" => $this->getCartCount(),
                // "PaymentMethod" => PaymentMethod::get(),
                "CustomSiteConfig" => SiteConfig::current_site_config(),
            ];
        }

        public function isLoggedIn()
        {
            return Security::getCurrentUser() ? true : false;
        }

        public function getCurrentUser()
        {
            return Security::getCurrentUser();
        }

        public function getUserMessage()
        {
             $message = $this->getRequest()->getSession()->get('UserMessage');
            if ($message) {
                $this->getRequest()->getSession()->clear('UserMessage');
                return $message;
            }
            return null;
        }

        public function getWishlistCount()
        {
            if ($this->isLoggedIn()) {
                $user = $this->getCurrentUser();
                if ($user && $user->exists()) {
                    try {
                        $count = Wishlist::get()->filter('MemberID', $user->ID)->count();
                        return $count ? (int) $count : 0;
                    } catch (Exception $e) {
                        // Log error atau debug
                        error_log("Error getting wishlist count: " . $e->getMessage());
                        return 0;
                    }
                }
            }
            return 0;
        }

    }
}