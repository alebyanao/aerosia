<header class="event-navbar py-3" role="banner">
<div class="container">
  <div class="event-nav-container d-flex align-items-center justify-content-between">

      <!-- Brand -->
      <a href="$BaseHref" class="navbar-brand d-flex align-items-center">
          <% if $SiteConfig.logo %>
              <img src="$SiteConfig.logo.URL" alt="Logo" 
                  class="img-fluid" style="max-height:60px;">
          <% end_if %>
      </a>

      <!-- Navigation -->
      <nav class="main-nav d-flex align-items-center">
          <% include Navigation %>
      </nav>

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