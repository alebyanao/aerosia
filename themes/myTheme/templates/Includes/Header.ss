<header class="navbar navbar-expand-lg navbar-light bg-light shadow-sm py-3" role="banner">
  <div class="container">
    <!-- Brand -->
    <a href="$BaseHref" class="navbar-brand d-flex align-items-center" rel="home">
      <div>
        <h1 class="h4 mb-0 fw-bold">$SiteConfig.Title</h1>
        <% if $SiteConfig.Tagline %>
          <small class="text-muted">$SiteConfig.Tagline</small>
        <% end_if %>
      </div>
    </a>

    <!-- Toggle button for mobile -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar"
      aria-controls="mainNavbar" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Navigation -->
    <div class="collapse navbar-collapse justify-content-end" id="mainNavbar">
      <% include Navigation %>

      <% if $SearchForm %>
        <form class="d-flex ms-lg-3 mt-3 mt-lg-0" role="search">
          $SearchForm
        </form>
      <% end_if %>

      <!-- Login & register -->
      <div class="dropdown">
        <button class="btn btn-outline-secondary dropdown-toggle d-flex align-items-center gap-2" type="button"
          id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
          <i class="bi bi-person"></i>
          <% if $IsLoggedIn %>
            <span class="d-none d-sm-inline">$CurrentUser.FirstName</span>
          <% else %>
            <span class="d-none d-sm-inline">Akun</span>
          <% end_if %>
        </button>
        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
          <% if $IsLoggedIn %>
            <li><a class="dropdown-item" href="$BaseHref/profile"><i class="bi bi-person me-2"></i>Profil</a></li>
            <li><a class="dropdown-item" href="$BaseHref/order"><i class="bi bi-box me-2"></i>Pesanan</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="$BaseHref/auth/logout"><i class="bi bi-box-arrow-right me-2"></i>Keluar</a></li>
          <% else %>
            <li><a class="dropdown-item" href="$BaseHref/auth/login"><i class="bi bi-box-arrow-in-right me-2"></i>Masuk</a></li>
            <li><a class="dropdown-item" href="$BaseHref/auth/register"><i class="bi bi-person-plus me-2"></i>Daftar</a></li>
          <% end_if %>
        </ul>
      </div>

    </div>
  </div>
</header>
