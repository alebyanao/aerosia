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

       <form role="search" action="$BaseHref/event" method="GET" class="search-form-modern">
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

      <!-- Navigation -->
      <nav class="main-nav d-flex align-items-center">
          <% include Navigation %>
      </nav>
    
        <%-- WISHLIST --%>
        <div class="d-flex align-items-center gap-3 text-dark">
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
</div>
</header>

<style>
  body {
  margin: 0;
  padding: 0;
}


/* --- SEARCH SECTION --- */
.search-section-modern {
    background: #fff;
    border-radius: 16px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

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

/* Search Results Info */
.search-results-info {
    margin-top: 16px;
    padding: 12px 16px;
    background: #f3f4f6;
    border-radius: 8px;
    color: #4b5563;
    font-size: 14px;
}

.search-results-info strong {
    color: #1f2937;
}

/* --- EMPTY STATE --- */
.empty-state-modern {
    text-align: center;
    padding: 60px 20px;
    background: #fff;
    border-radius: 16px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}

.empty-state-icon {
    font-size: 64px;
    color: #d1d5db;
    margin-bottom: 20px;
}

.empty-state-title {
    font-size: 22px;
    font-weight: 600;
    color: #1f2937;
    margin-bottom: 12px;
}

.empty-state-text {
    font-size: 15px;
    color: #6b7280;
    margin-bottom: 0;
}

.empty-state-text a {
    color: #7b2ddf;
    text-decoration: none;
    font-weight: 600;
}

.empty-state-text a:hover {
    text-decoration: underline;
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
}

/* Navigation d-flex horizontal */
.main-nav ul {
    display: flex !important;
    gap: 25px;                 
    margin: 0;
    padding: 0;
}

/* Link */
.nav-link {
    color: #2b2b2b !important;
    font-weight: 600;
    padding: 6px 10px !important;
}

/* Hover */
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
}

/* Jangan turun di layar kecil kecuali sangat kecil */
@media (max-width: 768px) {
    .event-nav-container {
        flex-wrap: wrap;  
        justify-content: center;
        gap: 15px;
    }

    .main-nav ul {
        gap: 15px;
    }
}
</style>
