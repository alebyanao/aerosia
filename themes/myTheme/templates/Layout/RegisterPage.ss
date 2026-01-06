<style>
  body {
    margin: 0;
    padding: 0;
  }

  .auth-bg {
    min-height: 100vh;
    background:
        linear-gradient(135deg, rgba(68, 0, 139, 0.55), rgba(121, 0, 182, 0.55)),
        url('$SiteConfig.BackgroundPage.URL') center/cover no-repeat;
    padding-top: 140px;
  }

  .auth-form {
      background: #ffffff;
      border-radius: 80px;
      padding: 35px 40px;
      width: 100%;
      max-width: 420px;
      border: 2px solid #e5e7eb;
  }

  .auth-form h4 {
      font-weight: 700;
      font-size: 20px;
      margin-bottom: 22px;
  }

  .form-control {
      border-radius: 50px !important;
      padding: 10px 16px;
      border: 1px solid #111 !important;
  }

  .btn-purple {
      background: #8b5cf6;
      border-radius: 50px;
      padding: 10px;
      font-weight: 600;
      color: white;
      border: none;
      box-shadow: inset 0 -3px 0 rgba(0,0,0,0.25);
  }

  .btn-google {
      border-radius: 50px;
      border: 1px solid #111 !important;
      background: #fff;
      padding: 10px;
  }

  .hero-text {
      font-weight: 800;
      font-size: 48px;
      line-height: 1.2;
      color: white;
      max-width: 500px;
  }

  /* Custom Alert Styling */
  .custom-alert {
    border-radius: 20px;
    padding: 20px 25px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    animation: slideDown 0.5s ease-out;
    border: none;
  }

  .custom-alert.alert-success {
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
    border-left: 5px solid #047857;
  }

  .custom-alert.alert-danger {
    background: linear-gradient(135deg, #ef4444, #dc2626);
    color: white;
    border-left: 5px solid #b91c1c;
  }

  .custom-alert .btn-close {
    filter: brightness(0) invert(1);
  }

  @keyframes slideDown {
    from {
      transform: translateY(-100px);
      opacity: 0;
    }
    to {
      transform: translateY(0);
      opacity: 1;
    }
  }

  @media(max-width: 992px){
    .hero-text {
        text-align: center;
        font-size: 38px;
        margin-bottom: 30px;
    }
    .auth-form {
        margin: 0 auto;
    }
  }
</style>

<main class="auth-bg">
  <div class="container">

    <% if $FlashMessage %>
    <div class="row">
      <div class="col-12 mb-3">
        <div class="alert custom-alert alert-{$FlashMessage.Type} alert-dismissible fade show" role="alert" id="flashAlert">
          <strong>
            <% if $FlashMessage.Type == 'success' %>
              <i class="bi bi-check-circle-fill me-2"></i>
            <% else_if $FlashMessage.Type == 'danger' %>
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <% end_if %>
          </strong>
          $FlashMessage.Message
          <% if $FlashMessage.Type == 'success' %>
            <div class="mt-2 small">
              <i class="bi bi-clock me-1"></i>Mengalihkan ke halaman login dalam <span id="countdown">3</span> detik...
            </div>
          <% end_if %>
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
      </div>
    </div>
    
    <% if $FlashMessage.Type == 'success' %>
    <script>
      // Auto redirect setelah 5 detik untuk success message
      let countdown = 5;
      const countdownEl = document.getElementById('countdown');
      
      const timer = setInterval(function() {
        countdown--;
        if (countdownEl) {
          countdownEl.textContent = countdown;
        }
        
        if (countdown <= 0) {
          clearInterval(timer);
          window.location.href = '$BaseHref/auth/login';
        }
      }, 1000);
      
      // Jika user close alert, cancel redirect
      const alertEl = document.getElementById('flashAlert');
      if (alertEl) {
        alertEl.addEventListener('closed.bs.alert', function() {
          clearInterval(timer);
        });
      }
    </script>
    <% end_if %>
    <% end_if %>
    
    <div class="row align-items-center">

      <!-- LEFT TEXT -->
      <div class="col-lg-6 mb-5 mb-lg-0 ps-lg-5">
        <h1 class="hero-text">
          Bikin event makin dekat, tiket makin mudah didapat.
        </h1>
      </div>

      <!-- RIGHT FORM -->
      <div class="col-lg-6 d-flex justify-content-lg-end justify-content-center">
        <form action="$BaseHref/auth/register" method="POST" class="auth-form">

          <h4>DAFTAR</h4>

          <!-- Nama Depan + Belakang -->
          <label class="form-label small mb-1">Nama Depan</label>
          <div class="row g-2 mb-3">
            <div class="col-6">
              <input type="text" class="form-control" name="register_first_name" required>
            </div>
            <div class="col-6">
              <input type="text" class="form-control" name="register_last_name" required>
            </div>
          </div>

          <label class="form-label small mb-1">Email</label>
          <input type="email" class="form-control mb-3" name="register_email" required>

          <label class="form-label small mb-1">Sandi</label>
          <input type="password" class="form-control mb-3" name="register_password_1" required>

          <label class="form-label small mb-1">Konfirmasi Sandi</label>
          <input type="password" class="form-control mb-4" name="register_password_2" required>

          <button type="submit" class="btn btn-purple w-100 mb-3">
            Daftar
          </button>

          <!-- Google -->
          <a href="$BaseHref/auth/google-login" class="btn btn-google w-100 mb-3 d-flex align-items-center justify-content-center">
              <img src="https://www.svgrepo.com/show/475656/google-color.svg" width="20" class="me-2">
              Daftar dengan Google
          </a>

          <p class="text-center small mb-0">
            Sudah memiliki akun?
            <a href="$BaseHref/auth/login" class="fw-semibold" style="color:#7c3aed;">Masuk di sini</a>
          </p>

        </form>
      </div>

    </div>
  </div>
</main>