<div class="page-wishlist">
<div class="container my-5">
    <% if $Wishlists.Count > 0 %>
        <!-- Ticket Grid - Same as EventPage -->
        <div class="row g-3">
            <% loop $Wishlists %>
                <% with $Ticket %>
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="ticket-card-sidebar <% if $IsExpired %>ticket-expired<% end_if %>">
                            <a href="$Link" class="ticket-img-link">
                                <div class="ticket-img-wrapper">
                                    <% if $Image %>
                                        <img src="$Image.URL" class="ticket-img-sidebar" alt="$Title">
                                    <% else %>
                                        <div class="ticket-img-sidebar bg-light d-flex align-items-center justify-content-center">
                                            <i class="bi bi-image text-secondary" style="font-size: 2rem;"></i>
                                        </div>
                                    <% end_if %>
                                    
                                    <!-- Badge Status -->
                                    <% if $IsExpired %>
                                        <span class="ticket-status-badge expired">
                                            <i class="bi bi-x-circle"></i> BERAKHIR
                                        </span>
                                    <% end_if %>
                                </div>
                            </a>
                            <div class="ticket-body-sidebar">
                                <h6 class="ticket-title-sidebar">
                                    <a href="$Link">$Title</a>
                                </h6>
                                <p class="ticket-date-sidebar">
                                    <i class="bi bi-calendar3" style="color: #7B68EE;"></i> $EventDate.Nice
                                </p>
                                <p class="ticket-location-sidebar">
                                    <i class="bi bi-geo-alt" style="color: #7B68EE;"></i> $Location
                                </p>
                                <div class="ticket-footer-sidebar">
                                    <% if $IsExpired %>
                                        <span class="ticket-price-sidebar expired-price">
                                            BERAKHIR
                                        </span>
                                    <% else %>
                                        <span class="ticket-price-sidebar">$PriceLabel</span>
                                    <% end_if %>
                                    
                                    <% if $Top.IsLoggedIn %>
                                        <% if $IsInWishlist %>
                                            <a href="$BaseHref/wishlist/remove/$WishlistID" 
                                               class="wishlist-icon-sidebar active"
                                               title="Hapus dari wishlist">
                                                <i class="bi bi-heart-fill"></i>
                                            </a>
                                        <% else %>
                                            <a href="$BaseHref/wishlist/add/$ID" 
                                               class="wishlist-icon-sidebar"
                                               title="Tambah ke wishlist">
                                                <i class="bi bi-heart"></i>
                                            </a>
                                        <% end_if %>
                                    <% else %>
                                        <a href="$BaseHref/auth/login" 
                                           class="wishlist-icon-sidebar"
                                           title="Login untuk wishlist">
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
</div>

<style>
.page-wishlist {
    padding-top: 100px; /* sesuaikan tinggi header */
}

/* ===== TICKET CARD STYLE (SAMA DENGAN EVENTPAGE) ===== */
.ticket-card-sidebar {
    background: #fff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: all 0.25s;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.ticket-card-sidebar:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.12);
}

.ticket-card-sidebar.ticket-expired {
    opacity: 0.75;
}

.ticket-card-sidebar.ticket-expired:hover {
    transform: translateY(-2px);
}

.ticket-img-link {
    display: block;
    position: relative;
}

.ticket-img-wrapper {
    position: relative;
    overflow: hidden;
}

.ticket-img-sidebar {
    width: 100%;
    height: 180px;
    object-fit: cover;
    transition: transform 0.3s;
}

.ticket-card-sidebar:hover .ticket-img-sidebar {
    transform: scale(1.05);
}

/* Status Badge */
.ticket-status-badge {
    position: absolute;
    top: 12px;
    right: 12px;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.5px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    backdrop-filter: blur(8px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    z-index: 10;
}

.ticket-status-badge.expired {
    background: rgba(239, 68, 68, 0.95);
    color: #fff;
}

.ticket-body-sidebar {
    padding: 16px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.ticket-title-sidebar {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 8px;
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.ticket-title-sidebar a {
    color: #1f2937;
    text-decoration: none;
}

.ticket-title-sidebar a:hover {
    color: #7c3aed;
}

.ticket-date-sidebar,
.ticket-location-sidebar {
    font-size: 13px;
    color: #6b7280;
    margin-bottom: 6px;
    display: flex;
    align-items: center;
    gap: 6px;
}

.ticket-location-sidebar {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.ticket-footer-sidebar {
    border-top: 1px solid #f3f4f6;
    padding-top: 12px;
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.ticket-price-sidebar {
    font-size: 16px;
    font-weight: 700;
    color: #1f2937;
}

.ticket-price-sidebar.expired-price {
    color: #ef4444;
    font-size: 14px;
}

/* Wishlist Heart Icon */
.wishlist-icon-sidebar {
    font-size: 20px;
    color: #d1d5db;
    text-decoration: none;
    transition: all 0.2s;
}

.wishlist-icon-sidebar:hover {
    color: #ef4444;
    transform: scale(1.1);
}

.wishlist-icon-sidebar.active {
    color: #ef4444;
}

/* Empty State */
.empty-wishlist-icon {
    animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

/* ===== RESPONSIVE ===== */
@media (max-width: 991px) {
    .ticket-img-sidebar {
        height: 160px;
    }
}

@media (max-width: 767px) {
    .ticket-img-sidebar {
        height: 140px;
    }
    
    .ticket-body-sidebar {
        padding: 14px;
    }
    
    .ticket-title-sidebar {
        font-size: 15px;
    }
    
    .ticket-date-sidebar,
    .ticket-location-sidebar {
        font-size: 12px;
    }
    
    .ticket-price-sidebar {
        font-size: 15px;
    }
}

@media (max-width: 576px) {
    .ticket-img-sidebar {
        height: 120px;
    }
    
    .ticket-body-sidebar {
        padding: 12px;
    }
    
    .ticket-title-sidebar {
        font-size: 14px;
    }
    
    .ticket-date-sidebar,
    .ticket-location-sidebar {
        font-size: 11px;
    }
    
    .ticket-price-sidebar {
        font-size: 14px;
    }
    
    .wishlist-icon-sidebar {
        font-size: 18px;
    }
}
</style>