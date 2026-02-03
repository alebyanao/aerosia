<?php 

use SilverStripe\Admin\ModelAdmin;
use SilverStripe\Security\Security;
use SilverStripe\Security\Permission;
use SilverStripe\Forms\LiteralField;
use SilverStripe\View\Requirements;

class OrderAdmin extends ModelAdmin
{
    private static $managed_models = [
        Order::class,
    ];

    private static $url_segment = 'order';
    private static $menu_title = 'Order';
    private static $menu_icon_class = 'font-icon-clipboard-pencil';

    public function getList()
    {
        $list = parent::getList();
        $member = Security::getCurrentUser();
        
        if (!$member) {
            return $list;
        }
        
        if (Permission::check('ADMIN')) {
            return $list;
        }

        // Filter data berdasarkan kepemilikan event untuk user biasa (Evan)
        if ($this->modelClass == Order::class) {
            $list = $list->filter('TicketType.Ticket.MemberID', $member->ID);
        }
        
        if ($this->modelClass == PaymentTransaction::class) {
            $list = $list->filter('Order.TicketType.Ticket.MemberID', $member->ID);
        }

        return $list;
    }

    public function getExportFields()
    {
        return [
            'OrderCode' => 'Order Code',
            'CreatedAt' => 'Tanggal Order',
            'FullName' => 'Nama Pemesan',
            'Email' => 'Email',
            'TicketType.TypeName' => 'Tipe Tiket',
            'TicketType.Ticket.Title' => 'Nama Event', 
            'Quantity' => 'Qty',
            'FormattedGrandTotal' => 'Total Bayar',
            'Status' => 'Status Order',
            'PaymentStatus' => 'Status Pembayaran'
        ];
    }

    public function getEditForm($id = null, $fields = null)
    {
        $form = parent::getEditForm($id, $fields);
        $modelClass = $this->sanitiseClassName($this->modelClass);
        $gridField = $form->Fields()->fieldByName($modelClass);

        Requirements::customCSS("
            /* Container GridField agar tabel bisa di-scroll */
            .grid-field {
                max-height: 70vh; 
                overflow-y: auto;
                overflow-x: auto;   
                position: sticky;
            }
            
            /* Sticky Header Tabel */
            .grid-field table thead th {
                position: sticky;
                top: 0;
                z-index: 5;
                background: #f1f1f1 !important;
                box-shadow: inset 0 -1px 0 #ccd0d4;
            }

            /* Container Ringkasan agar tetap diam (Sticky) */
            .revenue-summary-container {
                position: sticky;
                top: 0;
                z-index: 10;
                padding-bottom: 15px;
                margin-top: -10px;
            }
        ");

        if ($gridField && $this->modelClass == Order::class) {
            $list = $this->getList();
            $paidList = $list->filter('PaymentStatus', 'paid');
            
            // Kalkulasi Pendapatan
            $totalTicketIncome = (double)$paidList->sum('TotalPrice');
            $totalAdminFee     = (double)$paidList->sum('PaymentFee');
            $totalAll          = $totalTicketIncome + $totalAdminFee;

            // 2. Tambahkan Ringkasan Pendapatan sebagai LiteralField
            $form->Fields()->insertBefore(
                $modelClass,
                LiteralField::create(
                    'RevenueSummary',
                    sprintf(
                        '<div class="revenue-summary-container">
                            <div class="message info" style="font-size:1rem; border-left: 5px solid #0073aa; background: #fff; margin: 0; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                                <p style="margin:0 0 10px 0;"><strong>Ringkasan Pendapatan (Status: Lunas)</strong></p>
                                <table style="width:100%%; max-width:400px; border-collapse: collapse;">
                                    <tr>
                                        <td style="padding:2px 0;">Total Penjualan Tiket</td>
                                        <td style="text-align:right;"><strong>Rp %s</strong></td>
                                    </tr>
                                    <tr>
                                        <td style="padding:2px 0;">Total Biaya Admin (Fee)</td>
                                        <td style="text-align:right; color:#d9534f;">- Rp %s</td>
                                    </tr>
                                    <tr style="border-top:1px solid #ccd0d4; font-size:1.1rem;">
                                        <td style="padding:8px 0 0 0;"><strong>Pendapatan Bersih</strong></td>
                                        <td style="padding:8px 0 0 0; text-align:right; color:#28a745;"><strong>Rp %s</strong></td>
                                    </tr>
                                </table>
                            </div>
                        </div>',
                        number_format($totalAll, 0, ',', '.'),
                        number_format($totalAdminFee, 0, ',', '.'),
                        number_format($totalTicketIncome, 0, ',', '.') 
                    )
                )
            );
        }

        return $form;
    }
}