<!-- File: header.ss -->
<header class="event-navbar py-3 position-sticky top-0 w-100 z-3" role="banner" style="background: transparent;">
<div class="container">
  <div class="event-nav-container d-flex align-items-center justify-content-between">

      <!-- Brand -->
      <a href="$BaseHref" class="navbar-brand d-flex align-items-center">
          <% if $SiteConfig.logo %>
              <img src="$SiteConfig.logo.URL" alt="Logo" 
                  class="img-fluid" style="max-height:60px;">
          <% end_if %>
      </a>

      <!-- Desktop Search Form -->
      <form role="search" action="$BaseHref/event" method="GET" class="search-form-modern d-none d-lg-block">
            <div class="search-wrapper-modern">
                <div class="search-input-group-modern">
                    <i class="bi bi-search search-icon-modern"></i>
                    <input
                        type="text"
                        name="search"
                        class="search-input-modern"
                        placeholder="Cari event"
                        aria-label="Search"
                        value="$SearchQuery"
                    />
                    <% if $SearchQuery %>
                    <a href="$Link" class="search-clear-modern" title="Clear search">
                        <i class="bi bi-x-circle-fill"></i>
                    </a>
                    <% end_if %>
                </div>
                <button class="search-btn-modern" type="submit">
                    Cari
                </button>
            </div>
        </form>

      <!-- Desktop Navigation -->
      <nav class="main-nav d-none d-lg-flex align-items-center">
          <% include Navigation %>
      </nav>
    
      <!-- Desktop Wishlist & User -->
      <div class="d-none d-lg-flex align-items-center gap-3 text-dark">
        <% if $IsLoggedIn %>
            <a href="$BaseHref/wishlist" class="position-relative text-decoration-none">
                <i class="bi bi-heart" style="cursor: pointer; font-size: 1.5rem; color: #000000;"></i>
                <span id="wishlist-count"
                    class="position-absolute top-0 start-100 translate-middle badge rounded-pill"
                    style="background-color: #8c52ff; color: white; font-size: 0.7rem;
                        display: <% if $WishlistCount %>inline-block<% else %>none<% end_if %>;">
                    $WishlistCount
                </span>
            </a>
        <% else %>
            <a href="$BaseHref/auth/login" class="position-relative text-decoration-none">
            <i class="bi bi-heart" style="cursor: pointer; font-size: 1.5rem; color: #000000;"></i>
            </a>
        <% end_if %>

        <!-- User dropdown -->
        <div class="dropdown">
            <button class="btn account-btn dropdown-toggle d-flex align-items-center gap-2"
                    id="userDropdown" data-bs-toggle="dropdown">
                <i class="bi bi-person"></i>
                <% if $IsLoggedIn %>
                    <span>$CurrentUser.FirstName</span>
                <% else %>
                    <span>Akun</span>
                <% end_if %>
            </button>

            <ul class="dropdown-menu dropdown-menu-end">
                <% if $IsLoggedIn %>
                    <li><a class="dropdown-item" href="$BaseHref/profile">Profil</a></li>
                    <li><a class="dropdown-item" href="$BaseHref/order">Pesanan</a></li>
                    <li><hr class="dropdown-divider"></li>
                    <li><a class="dropdown-item text-danger" href="$BaseHref/auth/logout">Keluar</a></li>
                <% else %>
                    <li><a class="dropdown-item" href="$BaseHref/auth/login">Masuk</a></li>
                    <li><a class="dropdown-item" href="$BaseHref/auth/register">Daftar</a></li>
                <% end_if %>
            </ul>
        </div>
      </div>

      <!-- Mobile Hamburger Menu -->
      <button class="mobile-menu-toggle d-lg-none" id="mobileMenuToggle" aria-label="Toggle menu">
          <span></span>
          <span></span>
          <span></span>
      </button>

  </div>

  <!-- Mobile Menu Dropdown -->
  <div class="mobile-menu" id="mobileMenu">
      <!-- Mobile Search -->
      <form role="search" action="$BaseHref/event" method="GET" class="mobile-search-form">
            <div class="search-wrapper-modern">
                <div class="search-input-group-modern">
                    <i class="bi bi-search search-icon-modern"></i>
                    <input
                        type="text"
                        name="search"
                        class="search-input-modern"
                        placeholder="Cari event"
                        aria-label="Search"
                        value="$SearchQuery"
                    />
                    <% if $SearchQuery %>
                    <a href="$Link" class="search-clear-modern" title="Clear search">
                        <i class="bi bi-x-circle-fill"></i>
                    </a>
                    <% end_if %>
                </div>
                <button class="search-btn-modern" type="submit">
                    Cari
                </button>
            </div>
        </form>

      <!-- Mobile Navigation Links -->
      <div class="mobile-nav-links">
          <a href="$BaseHref/home" class="mobile-nav-link">
              <i class="bi bi-house-door"></i>
              <span>Home</span>
          </a>
          <a href="$BaseHref/event" class="mobile-nav-link">
              <i class="bi bi-calendar-event"></i>
              <span>Event</span>
          </a>
          <a href="<% if $IsLoggedIn %>$BaseHref/wishlist<% else %>$BaseHref/auth/login<% end_if %>" class="mobile-nav-link">
              <i class="bi bi-heart"></i>
              <span>Wishlist</span>
              <% if $IsLoggedIn && $WishlistCount %>
              <span class="badge rounded-pill ms-auto" style="background-color: #8c52ff;">$WishlistCount</span>
              <% end_if %>
          </a>
      </div>

      <!-- Mobile Account Section -->
      <div class="mobile-account-section">
          <% if $IsLoggedIn %>
              <div class="mobile-user-info">
                  <i class="bi bi-person-circle"></i>
                  <span>$CurrentUser.FirstName</span>
              </div>
              <a href="$BaseHref/profile" class="mobile-nav-link">
                  <i class="bi bi-person"></i>
                  <span>Profil</span>
              </a>
              <a href="$BaseHref/order" class="mobile-nav-link">
                  <i class="bi bi-bag"></i>
                  <span>Pesanan</span>
              </a>
              <a href="$BaseHref/auth/logout" class="mobile-nav-link text-danger">
                  <i class="bi bi-box-arrow-right"></i>
                  <span>Keluar</span>
              </a>
          <% else %>
              <a href="$BaseHref/auth/login" class="mobile-nav-link">
                  <i class="bi bi-box-arrow-in-right"></i>
                  <span>Masuk</span>
              </a>
              <a href="$BaseHref/auth/register" class="mobile-nav-link">
                  <i class="bi bi-person-plus"></i>
                  <span>Daftar</span>
              </a>
          <% end_if %>
      </div>
  </div>
</div>
</header>

<style>
body {
  margin: 0;
  padding: 0;
}

/* Capsule background */
.event-nav-container {
    background: linear-gradient(180deg, #d4d4d4ff 0%, #e9e9e9ff 100%);
    border-radius: 50px;
    padding: 10px 25px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    white-space: nowrap;
    position: relative;
}

/* --- SEARCH SECTION --- */
.search-form-modern {
    margin-bottom: 0;
}

.search-wrapper-modern {
    display: flex;
    gap: 12px;
    align-items: stretch;
}

.search-input-group-modern {
    position: relative;
    flex: 1;
    display: flex;
    align-items: center;
}

.search-icon-modern {
    position: absolute;
    left: 16px;
    color: #9ca3af;
    font-size: 18px;
    pointer-events: none;
    z-index: 1;
}

.search-input-modern {
    width: 100%;
    padding: 14px 45px 14px 48px;
    border: 2px solid #e5e7eb;
    border-radius: 12px;
    font-size: 15px;
    transition: all 0.3s ease;
    background: #fff;
}

.search-input-modern:focus {
    outline: none;
    border-color: #7b2ddf;
    box-shadow: 0 0 0 3px rgba(123, 45, 223, 0.1);
}

.search-input-modern::placeholder {
    color: #9ca3af;
}

.search-clear-modern {
    position: absolute;
    right: 16px;
    color: #9ca3af;
    font-size: 18px;
    cursor: pointer;
    transition: color 0.2s ease;
    text-decoration: none;
    z-index: 1;
}

.search-clear-modern:hover {
    color: #ef4444;
}

.search-btn-modern {
    padding: 14px 32px;
    background: #7b2ddf;
    color: white;
    border: none;
    border-radius: 12px;
    font-weight: 600;
    font-size: 15px;
    cursor: pointer;
    transition: all 0.3s ease;
    white-space: nowrap;
}

.search-btn-modern:hover {
    background: #6a25c7;
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(123, 45, 223, 0.3);
}

.search-btn-modern:active {
    transform: translateY(0);
}

/* Navigation horizontal */
.main-nav ul {
    display: flex !important;
    gap: 25px;
    margin: 0;
    padding: 0;
    list-style: none;
}

/* Link */
.nav-link {
    color: #2b2b2b !important;
    font-weight: 600;
    padding: 6px 10px !important;
    text-decoration: none;
}

.nav-link:hover {
    color: #6a2cbf !important;
}

/* Account button */
.account-btn {
    border: 1px solid #2b2b2b;
    border-radius: 25px;
    padding: 6px 14px;
    font-weight: 600;
    color: #2b2b2b;
    background: transparent;
}

.account-btn:hover {
    background: rgba(106, 44, 191, 0.1);
    border-color: #6a2cbf;
}

/* --- MOBILE HAMBURGER MENU --- */
.mobile-menu-toggle {
    display: none;
    flex-direction: column;
    gap: 5px;
    background: transparent;
    border: none;
    padding: 8px;
    cursor: pointer;
    z-index: 1001;
}

.mobile-menu-toggle span {
    display: block;
    width: 25px;
    height: 3px;
    background: #2b2b2b;
    border-radius: 3px;
    transition: all 0.3s ease;
}

.mobile-menu-toggle.active span:nth-child(1) {
    transform: rotate(45deg) translate(8px, 8px);
}

.mobile-menu-toggle.active span:nth-child(2) {
    opacity: 0;
}

.mobile-menu-toggle.active span:nth-child(3) {
    transform: rotate(-45deg) translate(7px, -7px);
}

/* Mobile Menu Dropdown */
.mobile-menu {
    display: none;
    background: linear-gradient(180deg, #e9e9e9ff 0%, #f5f5f5ff 100%);
    border-radius: 20px;
    margin-top: 15px;
    padding: 20px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.mobile-menu.active {
    display: block;
    animation: slideDown 0.3s ease;
}

@keyframes slideDown {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.mobile-search-form {
    margin-bottom: 20px;
}

.mobile-nav-links {
    display: flex;
    flex-direction: column;
    gap: 5px;
    margin-bottom: 20px;
    padding-bottom: 20px;
    border-bottom: 1px solid #d4d4d4;
}

.mobile-nav-link {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 15px;
    color: #2b2b2b;
    text-decoration: none;
    border-radius: 12px;
    transition: all 0.2s ease;
    font-weight: 500;
}

.mobile-nav-link i {
    font-size: 20px;
    width: 24px;
}

.mobile-nav-link:hover {
    background: rgba(123, 45, 223, 0.1);
    color: #6a2cbf;
}

.mobile-account-section {
    display: flex;
    flex-direction: column;
    gap: 5px;
}

.mobile-user-info {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 15px;
    background: rgba(123, 45, 223, 0.1);
    border-radius: 12px;
    margin-bottom: 10px;
    font-weight: 600;
    color: #2b2b2b;
}

.mobile-user-info i {
    font-size: 24px;
}

/* --- RESPONSIVE --- */
@media (max-width: 991px) {
    .mobile-menu-toggle {
        display: flex;
    }

    .event-nav-container {
        padding: 12px 20px;
    }

    .navbar-brand img {
        max-height: 45px !important;
    }
}

@media (max-width: 576px) {
    .event-nav-container {
        padding: 10px 15px;
        border-radius: 25px;
    }

    .navbar-brand img {
        max-height: 40px !important;
    }

    .mobile-menu {
        padding: 15px;
        border-radius: 15px;
    }

    .search-input-modern {
        padding: 12px 40px 12px 45px;
        font-size: 14px;
    }

    .search-btn-modern {
        padding: 12px 20px;
        font-size: 14px;
    }

    .mobile-nav-link {
        padding: 10px 12px;
        font-size: 15px;
    }
}
</style>

<script>
// Toggle mobile menu
document.addEventListener('DOMContentLoaded', function() {
    const menuToggle = document.getElementById('mobileMenuToggle');
    const mobileMenu = document.getElementById('mobileMenu');
    
    if (menuToggle && mobileMenu) {
        menuToggle.addEventListener('click', function() {
            this.classList.toggle('active');
            mobileMenu.classList.toggle('active');
        });

        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!menuToggle.contains(event.target) && !mobileMenu.contains(event.target)) {
                menuToggle.classList.remove('active');
                mobileMenu.classList.remove('active');
            }
        });
    }
});
</script>