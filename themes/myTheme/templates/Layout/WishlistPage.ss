<div class="container my-5">
    <% if $Wishlists.Count > 0 %>
        <!-- Ticket Grid - Same as EventPage -->
        <div class="row g-2 g-md-3">
            <% loop $Wishlists %>
                <% with $Ticket %>
                    <div class="col-6 col-lg-3">
                        <div class="ticket-card-modern">
                            <!-- Image -->
                            <a href="$Link">
                                <% if $Image %>
                                    <img src="$Image.URL" class="ticket-img-modern" alt="$Title">
                                <% else %>
                                    <div class="ticket-img-modern bg-light d-flex align-items-center justify-content-center">
                                        <i class="bi bi-image text-secondary" style="font-size: 2rem;"></i>
                                    </div>
                                <% end_if %>
                            </a>
                            
                            <!-- Body -->
                            <div class="ticket-body-modern">
                                <a href="$Link" class="ticket-title-modern">
                                    $Title
                                </a>
                                <p class="ticket-date-modern">
                                    <i class="bi bi-calendar-event"></i> $EventDate.Nice
                                </p>
                                <p class="ticket-location-modern">
                                    <i class="bi bi-geo-alt"></i> $Location
                                </p>
                                
                                <!-- Footer: Price + Wishlist Button -->
                                <div class="ticket-footer-modern">
                                    <span class="ticket-price-modern">$PriceLabel</span>
                                    
                                    <!-- Wishlist Button - Always Active (Red) karena ini halaman wishlist -->
                                    <% if $Top.IsLoggedIn %>
    <% if $IsInWishlist %>
        <a href="$BaseHref/wishlist/remove/$WishlistID" 
           class="wishlist-icon-modern active">
            <i class="bi bi-heart-fill"></i>
        </a>
    <% else %>
        <a href="$BaseHref/wishlist/add/$ID" 
           class="wishlist-icon-modern">
            <i class="bi bi-heart"></i>
        </a>
    <% end_if %>
<% else %>
    <a href="$BaseHref/auth/login" class="wishlist-icon-modern">
        <i class="bi bi-heart"></i>
    </a>
<% end_if %>

                                </div>
                            </div>
                        </div>
                    </div>
                <% end_with %>
            <% end_loop %>
        </div>
        
        <!-- Summary Info -->
        <div class="text-center mt-4">
            <p class="text-muted">
                <i class="bi bi-info-circle"></i> 
                Total <strong>{$Wishlists.Count}</strong> tiket di wishlist Anda
            </p>
        </div>
        
    <% else %>
        <!-- Empty State -->
        <div class="text-center py-5">
            <div class="empty-wishlist-icon mb-4">
                <i class="bi bi-heart text-muted" style="font-size: 5rem; opacity: 0.3;"></i>
            </div>
            <h4 class="mb-3">Wishlist Kamu Masih Kosong</h4>
            <p class="text-muted mb-4">
                Yuk jelajahi event menarik dan tambahkan ke wishlist!
            </p>
            <a href="{$BaseURL}event" class="btn text-white rounded-pill" style="background-color: #8c52ff;">
                <i class="bi bi-search"></i> Jelajahi Event
            </a>
        </div>
    <% end_if %>
</div>

<style>
/* --- CARD STYLE (SAMA DENGAN EVENTPAGE) --- */
.ticket-card-modern {
    background: #fff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: .25s ease;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.ticket-card-modern:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.12);
}

/* --- IMAGE --- */
.ticket-img-modern {
    height: 120px;
    width: 100%;
    object-fit: cover;
}

/* --- BODY CONTENT --- */
.ticket-body-modern {
    padding: 10px 12px 12px 12px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.ticket-title-modern {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #000;
    text-decoration: none;
    margin-bottom: 4px;
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.ticket-title-modern:hover {
    color: #7b2ddf;
}

.ticket-date-modern,
.ticket-location-modern {
    font-size: 12px;
    color: #7a7a7a;
    margin: 0 0 2px 0;
}

.ticket-location-modern {
    margin-bottom: 10px;
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

/* --- FOOTER PRICE + WISHLIST --- */
.ticket-footer-modern {
    border-top: 1px solid #eaeaea;
    padding-top: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: auto;
}

.ticket-price-modern {
    font-size: 14px;
    font-weight: 700;
    color: #000 !important;
}

/* --- WISHLIST HEART --- */
.wishlist-icon-modern {
    font-size: 18px;
    color: #d1d1d1;
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
    text-decoration: none;
    transition: all .3s ease;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.wishlist-icon-modern:hover {
    color: #ff4466;
    transform: scale(1.15);
}

.wishlist-icon-modern.active {
    color: #ff0033 !important;
}

.wishlist-icon-modern.active:hover {
    color: #dd0028 !important;
    transform: scale(1.15);
}

/* --- EMPTY STATE --- */
.empty-wishlist-icon {
    animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

/* --- RESPONSIVE --- */
@media (min-width: 768px) {
    .ticket-img-modern {
        height: 140px;
    }
    .ticket-title-modern {
        font-size: 15px;
    }
    .ticket-date-modern,
    .ticket-location-modern {
        font-size: 13px;
    }
    .ticket-price-modern {
        font-size: 15px;
    }
}

@media (min-width: 992px) {
    .ticket-body-modern {
        padding: 12px 14px 14px 14px;
    }
}

/* --- NOTIFICATION ANIMATIONS --- */
@keyframes slideInRight {
    from {
        transform: translateX(400px);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

@keyframes slideOutRight {
    from {
        transform: translateX(0);
        opacity: 1;
    }
    to {
        transform: translateX(400px);
        opacity: 0;
    }
}
</style>
