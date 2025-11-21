<?php

use SilverStripe\Control\Director;
use SilverStripe\Control\HTTPRequest;
use SilverStripe\Control\HTTPResponse;

class WishlistPageController extends PageController
{
    private static $allowed_actions = [
        'ticket',
        'add',
        'remove',
        'index',
        'toggle'
    ];

    private static $url_segment = 'wishlist';

    private static $table_name = 'wishlist';

    private static $url_handlers = [
        'ticket/$ID' => 'ticket', 
        'add/$ID' => 'add',
        'remove/$ID' => 'remove',
        'toggle/$ID' => 'toggle',
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
            if ($request->isAjax()) {
                $response = new HTTPResponse(json_encode(['success' => false, 'message' => 'Not logged in']));
                $response->addHeader('Content-Type', 'application/json');
                return $response;
            }
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $ticketID = $request->param('ID');
        $ticket = Ticket::get()->byID($ticketID);

        if (!$ticket) {
            if ($request->isAjax()) {
                $response = new HTTPResponse(json_encode(['success' => false, 'message' => 'Ticket not found']));
                $response->addHeader('Content-Type', 'application/json');
                return $response;
            }
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
            
            if ($request->isAjax()) {
                $response = new HTTPResponse(json_encode([
                    'success' => true,
                    'wishlistId' => $wishlist->ID,
                    'message' => 'Added to wishlist'
                ]));
                $response->addHeader('Content-Type', 'application/json');
                return $response;
            }
        } else {
            if ($request->isAjax()) {
                $response = new HTTPResponse(json_encode([
                    'success' => true,
                    'wishlistId' => $existingWishlist->ID,
                    'message' => 'Already in wishlist'
                ]));
                $response->addHeader('Content-Type', 'application/json');
                return $response;
            }
        }

        return $this->redirectBack();
    }

    /**
     * Menghapus Produk di dalam wishlist
     */
    public function remove(HTTPRequest $request)
    {
        if (!$this->isLoggedIn()) {
            if ($request->isAjax()) {
                $response = new HTTPResponse(json_encode(['success' => false, 'message' => 'Not logged in']));
                $response->addHeader('Content-Type', 'application/json');
                return $response;
            }
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
            
            if ($request->isAjax()) {
                $response = new HTTPResponse(json_encode([
                    'success' => true,
                    'message' => 'Removed from wishlist'
                ]));
                $response->addHeader('Content-Type', 'application/json');
                return $response;
            }
        } else {
            if ($request->isAjax()) {
                $response = new HTTPResponse(json_encode(['success' => false, 'message' => 'Wishlist not found']));
                $response->addHeader('Content-Type', 'application/json');
                return $response;
            }
        }

        return $this->redirectBack();
    }

    public function toggle(HTTPRequest $request)
    {
        // user login
        if (!$this->isLoggedIn()) {
            return $this->redirect(Director::absoluteBaseURL() . '/auth/login');
        }

        $ticketID = $request->param('ID');
        $ticket = Ticket::get()->byID($ticketID);

        if (!$ticket) {
            return $this->httpError(404);
        }

        $user = $this->getCurrentUser();

        // Cek apakah sudah ada di wishlist
        $existing = Wishlist::get()->filter([
            'TicketID' => $ticketID,
            'MemberID' => $user->ID
        ])->first();

        if ($existing) {
            // Kalau sudah → hapus
            $existing->delete();
        } else {
            // Kalau belum → tambahkan
            $wishlist = Wishlist::create();
            $wishlist->TicketID = $ticketID;
            $wishlist->MemberID = $user->ID;
            $wishlist->write();
        }

        return $this->redirectBack();
    }
}