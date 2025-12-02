<?php

use SilverStripe\Security\Security;
use SilverStripe\View\ArrayData;
use SilverStripe\Control\HTTPRequest;

class EventPageController extends PageController
{
    private static $allowed_actions = [
        'detail',
        'ticket' // Tambahkan ini jika menggunakan method ticket()
    ];

    private static $url_handlers = [
        'ticket/$ID' => 'detail' // atau 'ticket' jika method-nya ticket()
    ];

    /**
     * Index method dengan search functionality
     */
    public function index(HTTPRequest $request)
    {
        $searchQuery = $request->getVar('search');
        $tickets = $this->getFilteredTickets($searchQuery);

        $data = array_merge($this->getCommonData(), [
            'Tickets' => $tickets,
            'SearchQuery' => $searchQuery,
        ]);

        return $this->customise($data)->renderWith(['EventPage', 'Page']);
    }

    

    /**
     * Menampilkan daftar semua tiket
     */
    public function Tickets()
    {
        return Ticket::get()->sort('EventDate ASC');
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

        error_log('EventPageController::detail - Ticket ID: ' . $id . ', Member ID: ' . ($memberID ?? 'not logged in'));

        // Enhance ticket types with purchase info
        $ticketTypes = $ticket->TicketTypes();
        
        if ($memberID && $ticketTypes->count() > 0) {
            error_log('EventPageController::detail - Processing ' . $ticketTypes->count() . ' ticket types');
            
            foreach ($ticketTypes as $ticketType) {
                $purchaseInfo = $ticketType->getPurchaseInfo($memberID);
                
                error_log('EventPageController::detail - TicketType: ' . $ticketType->TypeName);
                error_log('  Purchase Info: ' . json_encode($purchaseInfo));
                
                // Wrap in ArrayData untuk template
                $ticketType->PurchaseInfo = new ArrayData($purchaseInfo);
            }
        } else {
            error_log('EventPageController::detail - No member logged in or no ticket types');
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