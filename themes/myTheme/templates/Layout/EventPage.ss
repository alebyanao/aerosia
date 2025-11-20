<div class="container py-4">
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
                                    <!-- SUDAH DI WISHLIST - MERAH PENUH ❤️ -->
                                    <button class="wishlist-icon-modern active" 
                                            data-ticket-id="$ID" 
                                            data-wishlist-id="$WishlistID"
                                            onclick="toggleWishlist(this, event)">
                                        <i class="bi bi-heart-fill"></i>
                                    </button>
                                <% else %>
                                    <!-- BELUM DI WISHLIST - PUTIH KOSONG 🤍 -->
                                    <button class="wishlist-icon-modern" 
                                            data-ticket-id="$ID"
                                            onclick="toggleWishlist(this, event)">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                <% end_if %>
                            <% else %>
                                <!-- BELUM LOGIN -->
                                <a href="{$BaseURL}auth/login" class="wishlist-icon-modern">
                                    <i class="bi bi-heart"></i>
                                </a>
                            <% end_if %>
                        </div>
                    </div>
                </div>
            </div>
        <% end_loop %>
    </div>
</div>

<style>
/* --- CARD STYLE --- */
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
</style>

<script>
function toggleWishlist(button, event) {
    event.preventDefault();
    event.stopPropagation();
    
    const ticketId = button.getAttribute('data-ticket-id');
    const wishlistId = button.getAttribute('data-wishlist-id');
    const isActive = button.classList.contains('active');
    const icon = button.querySelector('i');
    
    // Disable button sementara untuk mencegah double click
    button.disabled = true;
    
    // Animasi bounce
    button.style.transform = 'scale(1.3)';
    setTimeout(() => {
        button.style.transform = 'scale(1)';
    }, 200);
    
    const baseUrl = window.location.origin + '/';
    
    if (isActive) {
        // REMOVE from wishlist
        fetch(`$BaseHref/wishlist/remove/${wishlistId}`, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Update UI - Ubah ke heart KOSONG (putih) 🤍
                button.classList.remove('active');
                icon.classList.remove('bi-heart-fill');
                icon.classList.add('bi-heart');
                button.removeAttribute('data-wishlist-id');
                console.log('✅ Dihapus dari wishlist');
            }
        })
        .catch(error => {
            console.error('❌ Error:', error);
        })
        .finally(() => {
            button.disabled = false;
        });
    } else {
        // ADD to wishlist
        fetch(`$BaseHref/wishlist/add/${ticketId}`, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Update UI - Ubah ke heart PENUH (merah) ❤️
                button.classList.add('active');
                icon.classList.remove('bi-heart');
                icon.classList.add('bi-heart-fill');
                button.setAttribute('data-wishlist-id', data.wishlistId);
                console.log('✅ Ditambahkan ke wishlist, ID:', data.wishlistId);
            }
        })
        .catch(error => {
            console.error('❌ Error:', error);
        })
        .finally(() => {
            button.disabled = false;
        });
    }
}
</script>