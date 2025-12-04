<% require css('https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css') %>
<% require css('https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.11.1/font/bootstrap-icons.min.css') %>

<style>
   
    body {
        background: #ffffffff;
    }
    .event-image {
        width: 100%;
        border-radius: 16px;
        object-fit: cover;
        position: relative;
    }
    
    /* Badge Expired pada Image */
    .image-wrapper {
        position: relative;
        margin-bottom: 1rem;
    }
    
    .expired-badge-overlay {
        position: absolute;
        top: 20px;
        right: 20px;
        background: rgba(239, 68, 68, 0.95);
        color: white;
        padding: 10px 20px;
        border-radius: 25px;
        font-weight: 700;
        font-size: 1rem;
        letter-spacing: 1px;
        display: flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4);
        z-index: 10;
        backdrop-filter: blur(8px);
    }
    
    .expired-image-overlay {
        position: absolute;
        inset: 0;
        background: rgba(0, 0, 0, 0.3);
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .event-info-card {
        background: #fff;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
        border-radius: 16px;
        padding: 24px;
    }
    
   
    
    .event-title {
        font-weight: 700;
        font-size: 1.5rem;
        margin-bottom: 20px;
    }
    
    .event-title.expired {
        color: #6b7280;
    }
    
    .event-meta {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 12px;
        color: #555;
        font-size: 0.95rem;
    }
    
    .event-meta.expired {
        color: #9ca3af;
        text-decoration: line-through;
    }
    
    .event-meta i {
        color: #7B68EE;
        font-size: 1.1rem;
    }
    
    .event-meta.expired i {
        color: #d1d5db;
    }
    
    .tabs-container {
        display: flex;
        border-bottom: 2px solid #e0e0e0;
        margin-bottom: 20px;
    }
    .tab-item {
        padding: 12px 40px;
        cursor: pointer;
        font-weight: 500;
        color: #666;
        position: relative;
    }
    .tab-item.active {
        color: #7B68EE;
    }
    .tab-item.active::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        right: 0;
        height: 3px;
        background: #7B68EE;
        border-radius: 2px;
    }
    .tab-content {
        display: none;
    }
    .tab-content.active {
        display: block;
    }
    .ticket-card {
        background: linear-gradient(135deg, #E8E0F0 0%, #F5F0FA 100%);
        border-radius: 16px;
        padding: 24px;
        position: relative;
        display: flex;
        align-items: center;
        margin-bottom: 16px;
        transition: all 0.3s ease;
    }
    
    /* Ticket Card Expired State */
    .ticket-card.expired-ticket {
        background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
        opacity: 0.7;
    }
    
    .ticket-card::before {
        content: '';
        position: absolute;
        left: 30%;
        top: 0;
        bottom: 0;
        border-left: 2px dashed #C4B5D8;
    }
    
    .ticket-card.expired-ticket::before {
        border-left-color: #d1d5db;
    }
    
    .ticket-left {
        width: 28%;
        text-align: center;
        padding-right: 20px;
    }
    .ticket-type-name {
        font-weight: 700;
        font-size: 1rem;
        color: #333;
        text-transform: uppercase;
        line-height: 1.4;
    }
    
    .ticket-card.expired-ticket .ticket-type-name {
        color: #9ca3af;
    }
    
    .ticket-price {
        font-weight: 600;
        font-size: 1.4rem;
        color: #7B68EE;
        margin-top: 8px;
    }
    
    .ticket-card.expired-ticket .ticket-price {
        color: #d1d5db;
    }
    
    .ticket-right {
        width: 72%;
        padding-left: 30px;
    }
    .ticket-description {
        color: #000000ff;
        font-size: 0.9rem;
        text-align: center;
        margin-bottom: 12px;
        line-height: 1.5;
    }
    
    .ticket-card.expired-ticket .ticket-description {
        color: #9ca3af;
    }
    
    .ticket-stock {
        font-size: 0.75rem;
        color: #888;
        text-align: center;
        margin-bottom: 12px;
    }
    
    .ticket-card.expired-ticket .ticket-stock {
        color: #d1d5db;
    }
    
    .btn-pilih {
        background: #7B68EE;
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 10px 32px;
        font-weight: 500;
        display: block;
        margin: 0 auto;
        cursor: pointer;
        transition: all 0.3s;
    }
    .btn-pilih:hover {
        background: #6A5ACD;
        color: #fff;
    }
    .btn-pilih.disabled {
        background: #aaa;
        cursor: not-allowed;
    }
    
    .btn-pilih.expired-btn {
     
        cursor: not-allowed;
        pointer-events: none;
    }
    
    .quantity-control {
        display: none;
        align-items: center;
        justify-content: center;
        gap: 12px;
        margin: 0 auto;
        max-width: 150px;
    }
    .quantity-control.active {
        display: flex;
    }
    .qty-btn {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        border: none;
        background: #7B68EE;
        color: #fff;
        font-size: 1.2rem;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: all 0.3s;
        flex-shrink: 0;
    }
    .qty-btn:hover:not(:disabled) {
        background: #6A5ACD;
    }
    .qty-btn:disabled {
        background: #ccc;
        cursor: not-allowed;
    }
    .qty-display {
        width: 40px;
        text-align: center;
        font-size: 1.1rem;
        font-weight: 600;
        color: #333;
    }
    .quantity-alert {
        font-size: 0.75rem;
        color: #dc3545;
        text-align: center;
        margin-top: 8px;
    }
    .checkout-card {
        background: #fff;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        border-radius: 16px;
        padding: 20px;
    }
    
    /* Checkout Card Expired */
    .checkout-card.expired-checkout {
        background: linear-gradient(135deg, #ffffffff 0%, #ffff 100%);

    }
    
    .expired-notice {
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        margin-bottom: 16px;
    }
    
    .expired-notice i {
        font-size: 3rem;
        color: #dc2626;
        margin-bottom: 12px;
    }
    
    .expired-notice-title {
        font-weight: 700;
        color: #991b1b;
        font-size: 1.1rem;
        margin-bottom: 8px;
    }
    
    .expired-notice-text {
        color: #7f1d1d;
        font-size: 0.9rem;
        margin-bottom: 16px;
    }
    
    .btn-back-events {
        background: #fff;
        color: #dc2626;
        border: 2px solid #dc2626;
        border-radius: 8px;
        padding: 10px 20px;
        font-weight: 600;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: all 0.3s;
    }
    
    .btn-back-events:hover {
        background: #dc2626;
        color: #fff;
    }
    
    .total-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
    }
    .total-label {
        font-weight: 500;
        color: #333;
    }
    .total-price {
        font-weight: 600;
        color: #7B68EE;
    }
    
    .total-price.expired {
        color: #d1d5db;
    }
    
    .btn-beli {
        background: #7B68EE;
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 12px;
        width: 100%;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
    }
    .btn-beli:hover:not(.disabled) {
        background: #6A5ACD;
        color: #fff;
    }
    .btn-beli.disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }
    
    .btn-beli.expired {
        background: #9ca3af;
        cursor: not-allowed;
        pointer-events: none;
    }
    
    .ticket-card.selected {
        box-shadow: 0 0 0 3px #7B68EE;
    }
    .event-description-content {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
    }
</style>

<div class="container my-4">
    <div class="row g-4">
        <!-- Kolom Kiri -->
        <div class="col-lg-8">
            <% with $Ticket %>
                <!-- Event Image with Expired Badge -->
                <% if $Image %>
                    <div class="image-wrapper">
                        <img src="$Image.Fill(700,350).URL" class="event-image" alt="$Title" style="box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);">
                        
                        <% if $IsExpired %>
                            <div class="expired-badge-overlay">
                                <i class="bi bi-x-circle-fill"></i>
                                BERAKHIR
                            </div>
                        <% end_if %>
                    </div>
                <% end_if %>
                
                <!-- Tabs -->
                <div class="tabs-container">
                    <div class="tab-item" data-tab="deskripsi">DESKRIPSI</div>
                    <div class="tab-item active" data-tab="tiket">TIKET</div>
                </div>

                <!-- Tab Content: Deskripsi -->
                <div class="tab-content" id="tab-deskripsi">
                    <div class="event-description-content">
                        $Description
                    </div>
                </div>

                <!-- Tab Content: Tiket -->
                <div class="tab-content active" id="tab-tiket">
                    <% if $TicketTypes %>
                        <% loop $TicketTypes %>
                            <div class="ticket-card ticket-type-item <% if $Up.IsExpired %>expired-ticket<% end_if %>" 
                                 data-ticket-id="$ID" 
                                 data-price="$Price" 
                                 data-max="$MaxPerMember"
                                 data-capacity="$Capacity"
                                 data-expired="<% if $Up.IsExpired %>true<% else %>false<% end_if %>">
                                <div class="ticket-left">
                                    <div class="ticket-type-name">$TypeName</div>
                                    <div class="ticket-price">$FormattedPrice</div>
                                </div>
                                <div class="ticket-right">
                                    <% if $Description %>
                                        <p class="ticket-description">$Description</p>
                                    <% end_if %>
                                    
                                    <% if $Up.IsExpired %>
                                        <p class="ticket-stock text-danger fw-bold">
                                            <i class="bi bi-clock-history"></i> EVENT BERAKHIR
                                        </p>
                                        <div class="btn-pilih expired-btn">
                                            TIDAK TERSEDIA
                                        </div>
                                    <% else_if $Capacity > 0 %>
                                        <p class="ticket-stock">
                                            <i class="bi bi-ticket-perforated"></i> Tersedia: $Capacity tiket
                                        </p>
                                        <button class="btn-pilih select-ticket-btn">Pilih Tiket</button>
                                        
                                        <!-- Quantity Control -->
                                        <div class="quantity-control">
                                            <button type="button" class="qty-btn qty-minus">−</button>
                                            <span class="qty-display">1</span>
                                            <button type="button" class="qty-btn qty-plus">+</button>
                                        </div>
                                        
                                        <!-- Alert -->
                                        <div class="quantity-alert d-none">
                                            Maksimal <span class="max-limit">$MaxPerMember</span> tiket
                                        </div>
                                    <% else %>
                                        <p class="ticket-stock text-danger fw-bold">
                                            <i class="bi bi-exclamation-circle"></i> SOLD OUT
                                        </p>
                                        <div class="btn-pilih disabled">
                                            SOLD OUT
                                        </div>
                                    <% end_if %>
                                </div>
                            </div>
                        <% end_loop %>
                    <% else %>
                        <div class="alert alert-warning" role="alert">
                            <i class="bi bi-exclamation-triangle"></i> Belum ada tipe tiket yang tersedia untuk event ini.
                        </div>
                    <% end_if %>
                </div>
            <% end_with %>
        </div>

        <!-- Kolom Kanan -->
        <div class="col-lg-4">
            <div class="sticky-top" style="top: 20px;">
                <% with $Ticket %>
                    <!-- Event Info Card -->
                    <div class="event-info-card mb-3">
                        
                        <h2 class="event-title">$Title</h2>

                        <!-- Tanggal -->
                        <div class="event-meta">
                            <i class="bi bi-calendar3"></i>
                            <span>$EventDate.Nice</span>
                        </div>

                        <!-- Waktu -->
                        <div class="event-meta">
                            <i class="bi bi-clock"></i>
                            <% if $EventTimeFormatted %>
                                <span class="small">$EventTimeFormatted</span>
                            <% else %>
                                <span class="small">-</span>
                            <% end_if %>
                        </div>

                        <!-- Lokasi -->
                        <div class="event-meta">
                            <i class="bi bi-geo-alt"></i>
                            <% if $EventMapURL %>
                                <a href="{$EventMapURL}" target="_blank" class="small text-dark text-decoration-none">
                                    $Location
                                </a>
                            <% else %>
                                $Location
                            <% end_if %>
                        </div>

                        <% if $InstagramURL %>
                            <!-- Garis pemisah -->
                            <hr class="my-2">

                            <!-- Instagram Row -->
                            <div class="event-meta">
                                <img src="https://cdn-icons-png.flaticon.com/512/1384/1384063.png"
                                    alt="Instagram"
                                    style="width:18px; height:18px; margin-right:6px; object-fit:contain;">

                                <a href="$InstagramURL" target="_blank" class="small text-dark text-decoration-none">
                                    @$Instagram
                                </a>
                            </div>
                        <% end_if %>
                    </div>

                    <!-- Checkout Card -->
                    <div class="checkout-card <% if $IsExpired %>expired-checkout<% end_if %>">
                       
                            <div class="total-row">
                                <span class="total-label">Total harga :</span>
                                <span class="total-price" id="total-amount">Rp. ...</span>
                            </div>
                            <form id="checkoutForm" action="$BaseHref/checkout" method="post">
                                <input type="hidden" name="ticket_type_id" id="ticketTypeId">
                                <input type="hidden" name="quantity" id="ticketQty">
                                <button type="submit" id="buy-btn" class="btn-beli disabled" aria-disabled="true">
                                    Beli Tiket
                                </button>
                            </form>
               
                    </div>
                <% end_with %>
            </div>
        </div>
    </div>

    <!-- Tombol Kembali -->
    <div class="row mt-4">
        <div class="col-12">
            <a href="$BackLink" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Kembali ke Daftar Event
            </a>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // Tab switching
    const tabItems = document.querySelectorAll('.tab-item');
    tabItems.forEach(tab => {
        tab.addEventListener('click', () => {
            tabItems.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.getElementById('tab-' + tab.dataset.tab).classList.add('active');
        });
    });

    // Ticket selection with quantity control
    const ticketItems = document.querySelectorAll('.ticket-type-item');
    const totalAmountEl = document.getElementById('total-amount');
    const buyBtn = document.getElementById('buy-btn');

    let selectedTicket = null;

    ticketItems.forEach(item => {
        // Skip jika tiket expired
        if (item.dataset.expired === 'true') {
            return;
        }
        
        const selectBtn = item.querySelector('.select-ticket-btn');
        const qtyControl = item.querySelector('.quantity-control');
        const qtyDisplay = item.querySelector('.qty-display');
        const qtyPlus = item.querySelector('.qty-plus');
        const qtyMinus = item.querySelector('.qty-minus');
        const alertMsg = item.querySelector('.quantity-alert');
        
        const maxLimit = parseInt(item.dataset.max);
        const price = parseInt(item.dataset.price);
        const capacity = parseInt(item.dataset.capacity);

        if (capacity === 0 || !selectBtn) {
            return;
        }

        let currentQty = 1;

        // Click "Pilih Tiket" button
        selectBtn.addEventListener('click', () => {
            // Reset semua tiket lain
            ticketItems.forEach(i => {
                i.classList.remove('selected');
                const btn = i.querySelector('.select-ticket-btn');
                const ctrl = i.querySelector('.quantity-control');
                const alert = i.querySelector('.quantity-alert');
                
                if (btn) btn.style.display = 'block';
                if (ctrl) ctrl.classList.remove('active');
                if (alert) alert.classList.add('d-none');
            });

            // Aktifkan tiket ini
            item.classList.add('selected');
            selectBtn.style.display = 'none';
            qtyControl.classList.add('active');
            
            currentQty = 1;
            qtyDisplay.textContent = currentQty;

            selectedTicket = { item, price, maxLimit, capacity, currentQty };
            updateTotal();
        });

        // Plus button
        qtyPlus.addEventListener('click', () => {
            const effectiveMax = Math.min(maxLimit, capacity);
            
            if (currentQty < effectiveMax) {
                currentQty++;
                qtyDisplay.textContent = currentQty;
                selectedTicket.currentQty = currentQty;
                alertMsg.classList.add('d-none');
                updateTotal();
            } else {
                alertMsg.querySelector('.max-limit').textContent = effectiveMax;
                alertMsg.classList.remove('d-none');
            }
        });

        // Minus button
        qtyMinus.addEventListener('click', () => {
            if (currentQty > 1) {
                currentQty--;
                qtyDisplay.textContent = currentQty;
                selectedTicket.currentQty = currentQty;
                alertMsg.classList.add('d-none');
                updateTotal();
            }
        });
    });

    function updateTotal() {
        if (!selectedTicket) {
            if (totalAmountEl) {
                totalAmountEl.textContent = 'Rp. ...';
            }
            disableBuy();
            return;
        }

        const total = selectedTicket.currentQty * selectedTicket.price;
        if (totalAmountEl) {
            totalAmountEl.textContent = 'Rp. ' + total.toLocaleString('id-ID');
        }
        enableBuy();
    }

    function enableBuy() {
        if (buyBtn) {
            buyBtn.classList.remove('disabled');
            buyBtn.removeAttribute('aria-disabled');
        }
    }

    function disableBuy() {
        if (buyBtn) {
            buyBtn.classList.add('disabled');
            buyBtn.setAttribute('aria-disabled', 'true');
        }
    }

    if (buyBtn) {
        buyBtn.addEventListener('click', (e) => {
            e.preventDefault();
            if (!selectedTicket || buyBtn.classList.contains('disabled')) return;

            document.getElementById('ticketTypeId').value = selectedTicket.item.dataset.ticketId;
            document.getElementById('ticketQty').value = selectedTicket.currentQty;

            document.getElementById('checkoutForm').submit();
        });
    }
});
</script>