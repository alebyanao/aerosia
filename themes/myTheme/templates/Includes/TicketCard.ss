    <div class="ticket-card-sidebar <% if $IsExpired %>ticket-expired<% end_if %>">
        <a href="$Link" class="ticket-img-link">
            <div class="ticket-img-wrapper">
                <img src="$Image.URL" class="ticket-img-sidebar" alt="$Title">

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
                <i class="bi bi-calendar3"></i> $EventDate.Nice
            </p>

            <p class="ticket-location-sidebar">
                <i class="bi bi-geo-alt"></i> $Location
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
                    <% if $canBeOrdered %>
                        <% if $IsInWishlist %>
                            <a href="$BaseHref/wishlist/toggle/$ID"
                               class="wishlist-icon-sidebar active">
                                <i class="bi bi-heart-fill"></i>
                            </a>
                        <% else %>
                            <a href="$BaseHref/wishlist/toggle/$ID"
                               class="wishlist-icon-sidebar">
                                <i class="bi bi-heart"></i>
                            </a>
                        <% end_if %>
                    <% else %>
                        <span class="wishlist-icon-sidebar disabled">
                            <i class="bi bi-heart"></i>
                        </span>
                    <% end_if %>
                <% else %>
                    <a href="$BaseHref/auth/login"
                       class="wishlist-icon-sidebar">
                        <i class="bi bi-heart"></i>
                    </a>
                <% end_if %>
            </div>
        </div>
    </div>

<style>
/* Ticket Cards */
.ticket-card-sidebar {
    background: #fff;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 8px 24px rgba(0,0,0,0.08);
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

.ticket-status-badge.available {
    background: rgba(34, 197, 94, 0.95);
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

.wishlist-icon-sidebar.disabled {
    color: #e5e7eb;
    cursor: not-allowed;
    pointer-events: none;
}
</style>