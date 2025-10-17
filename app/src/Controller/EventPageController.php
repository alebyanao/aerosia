<?php

use SilverStripe\Control\HTTPRequest;

class EventPageController extends PageController
{
    private static $allowed_actions = [
        'detail'
    ];

    private static $url_handlers = [
        'ticket/$ID' => 'detail'
    ];

    /**
     * Menampilkan daftar semua tiket
     */
    public function Tickets()
    {
        return Ticket::get()->sort('EventDate ASC');
    }

    /**
     * Menampilkan detail tiket
     * URL: /events/ticket/123
     */
    public function detail(HTTPRequest $request)
    {
        $id = $request->param('ID');
        $ticket = Ticket::get()->byID($id);

        if (!$ticket) {
            return $this->httpError(404, 'Tiket tidak ditemukan');
        }

        // Return data untuk template EventPage_detail.ss
        return $this->customise([
            'Ticket' => $ticket,
            'Title' => $ticket->Title
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