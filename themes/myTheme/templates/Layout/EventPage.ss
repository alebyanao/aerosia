<div class="container py-4">
    <!-- Tickets Grid -->
    <% if $Tickets.Count > 0 %>
        <div class="row g-2 g-md-3">
            <% loop $Tickets %>
                <div class="col-6 col-lg-3">
                    <div class="ticket-card-modern">
                        <a href="$Link">
                            <img src="$Image.URL" class="ticket-img-modern" alt="$Title">
                        </a>
                        <div class="ticket-body-modern">
                            <a href="$Link" class="ticket-title-modern">
                                $Title
                            </a>
                            <p class="ticket-date-modern">$EventDate.Nice</p>
                            <p class="ticket-location-modern">$Location</p>
                            <div class="ticket-footer-modern">
                                <span class="ticket-price-modern">$PriceLabel</span>
                                
                                <% if $Top.IsLoggedIn %>
                                    <% if $IsInWishlist %>
                                        <a href="$BaseHref/wishlist/toggle/$ID" 
                                        class="wishlist-icon-modern active">
                                            <i class="bi bi-heart-fill"></i>
                                        </a>
                                    <% else %>
                                        <a href="$BaseHref/wishlist/toggle/$ID" 
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
            <% end_loop %>
        </div>
    <% else %>
        <!-- Empty State -->
        <div class="empty-state-modern">
            <div class="empty-state-icon">
                <i class="bi bi-ticket-perforated"></i>
            </div>
            <h3 class="empty-state-title">
                <% if $SearchQuery %>
                    Tidak ada event yang ditemukan
                <% else %>
                    Belum ada event tersedia
                <% end_if %>
            </h3>
            <p class="empty-state-text">
                <% if $SearchQuery %>
                    Coba gunakan kata kunci yang berbeda atau <a href="$Link">lihat semua event</a>
                <% else %>
                    Event akan segera hadir. Silakan cek kembali nanti!
                <% end_if %>
            </p>
        </div>
    <% end_if %>
</div>

<style>

/* --- EXISTING CARD STYLES --- */
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

.ticket-img-modern {
    height: 120px;
    width: 100%;
    object-fit: cover;
}

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

.ticket-date-modern {
    font-size: 12px;
    color: #7a7a7a;
    margin: 0 0 2px 0;
}

.ticket-location-modern {
    font-size: 12px;
    color: #7a7a7a;
    margin-bottom: 10px;
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

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

.wishlist-icon-modern {
    font-size: 18px;
    color: #ccc;
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
    transform: scale(1.1);
}

.wishlist-icon-modern.active {
    color: #ff0033 !important;
}

.wishlist-icon-modern.active:hover {
    color: #cc0028 !important;
}

/* --- RESPONSIVE --- */
@media (max-width: 767px) {
    .search-wrapper-modern {
        flex-direction: column;
    }
    
    .search-btn-modern {
        width: 100%;
        padding: 12px 24px;
    }
    
    .search-input-modern {
        padding: 12px 40px 12px 44px;
        font-size: 14px;
    }
    
   
    
    .empty-state-modern {
        padding: 40px 20px;
    }
    
    .empty-state-icon {
        font-size: 48px;
    }
    
    .empty-state-title {
        font-size: 18px;
    }
    
    .empty-state-text {
        font-size: 14px;
    }
}

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
    
    .search-section-modern {
        padding: 24px;
    }
}
</style>    