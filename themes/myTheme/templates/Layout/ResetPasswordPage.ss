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
    display: flex;
    align-items: center;
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
      margin-bottom: 12px;
  }

  .auth-form .subtitle {
      color: #6b7280;
      font-size: 14px;
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
      let countdown = 3;
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
      
      const alertEl = document.getElementById('flashAlert');
      if (alertEl) {
        alertEl.addEventListener('closed.bs.alert', function() {
          clearInterval(timer);
        });
      }
    </script>
    <% end_if %>
    <% end_if %>

    <div class="row align-items-center justify-content-center">

      <!-- CENTERED FORM -->
      <div class="col-lg-5 col-md-7">
        <form action="$BaseHref/auth/reset-password?token=$Token" method="POST" class="auth-form mx-auto">

          <h4>RESET SANDI</h4>
          <p class="subtitle">Masukkan password baru untuk akun Anda.</p>

          <label class="form-label small mb-1">Password Baru</label>
          <input type="password" class="form-control mb-3" name="new_password_1" required minlength="6">

          <label class="form-label small mb-1">Konfirmasi Password Baru</label>
          <input type="password" class="form-control mb-4" name="new_password_2" required minlength="6">

          <button type="submit" class="btn btn-purple w-100 mb-3">
            Reset Password
          </button>

          <div class="text-center small">
            <p class="mb-0">Kembali ke
              <a href="$BaseHref/auth/login" class="fw-semibold" style="color:#7c3aed;">halaman login</a>
            </p>
          </div>

        </form>
      </div>

    </div>
  </div>
</main>