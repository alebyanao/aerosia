<?php

use SilverStripe\Control\Director;
use SilverStripe\Control\HTTPRequest;

class WishlistPageController extends PageController
{
    private static $allowed_actions = [
        'ticket',
        'add',
        'remove',
        'index'
    ];

    private static $url_segment = 'wishlist';

    private static $table_name = 'wishlist';

    private static $url_handlers = [
        'ticket/$ID' => 'ticket', 
        'add/$ID' => 'add',
        'remove/$ID' => 'remove',
        '' => 'index'
    ];

    public function index(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $user = $this->getCurrentUser();
        $wishlists = Wishlist::get()->filter('MemberID', $user->ID);

        $data = array_merge($this->getCommonData(), [
            'Title' => 'My Wishlists',
            'Wishlists' => $wishlists
        ]);

        return $this->customise($data)->renderWith(['WishlistPage', 'Page']);
    }
    
    /**
     * Menambahkan Produk ke dalam wishlist
     */
    public function add(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $ticketID = $request->param('ID');
        $ticket = Ticket::get()->byID($ticketID);

        if (!$ticket) {
            return $this->httpError(404);
        }

        $user = $this->getCurrentUser();
        $existingWishlist = Wishlist::get()->filter([
            'TicketID' => $ticketID,
            'MemberID' => $user->ID
        ])->first();

        if (!$existingWishlist) {
            $wishlist = Wishlist::create();
            $wishlist->TicketID = $ticketID;
            $wishlist->MemberID = $user->ID;
            $wishlist->write();
        }

        return $this->redirectBack();
    }

    /**
     * Menhapus Produk di dalam wishlist
     */
    public function remove(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $wishlistID = $request->param('ID');
        $user = $this->getCurrentUser();

        $wishlist = Wishlist::get()->filter([
            'ID' => $wishlistID,
            'MemberID' => $user->ID
        ])->first();

        if ($wishlist) {
            $wishlist->delete();
        }

        return $this->redirectBack();
    }
}