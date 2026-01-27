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
    padding-top: 260px;
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
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
      </div>
    </div>
    <% end_if %>

    <div class="row align-items-center">

      <!-- LEFT TEXT -->
      <div class="col-lg-6 mb-5 mb-lg-0 ps-lg-5">
        <h1 class="hero-text">
          Selamat datang kembali!<br>
          Masuk untuk mulai menemukan event menarik.
        </h1>
      </div>

      <!-- RIGHT FORM -->
      <div class="col-lg-6 d-flex justify-content-lg-end justify-content-center">
        <form action="$BaseHref/auth/login" method="POST" class="auth-form">

          <h4>MASUK</h4>

          <label class="form-label small mb-1">Email</label>
          <input type="email" class="form-control mb-3" name="login_email" required>

          <label class="form-label small mb-1">Sandi</label>
            <div class="password-wrapper mb-3">
              <input 
                type="password" 
                class="form-control" 
                name="login_password" 
                id="loginPassword"
                required
              >
              <i class="bi bi-eye toggle-password" id="togglePassword"></i>
            </div>    
          <button type="submit" class="btn btn-purple w-100 mb-3">
            Masuk
          </button>

          <a href="$BaseHref/auth/google-login" class="btn btn-google w-100 mb-3 d-flex align-items-center justify-content-center">
              <img src="https://www.svgrepo.com/show/475656/google-color.svg" width="20" class="me-2">
              Masuk dengan Google
          </a>

          <div class="text-center small">
            <p class="mb-1">Tidak memiliki akun?
              <a href="$BaseHref/auth/register" class="fw-semibold" style="color:#7c3aed;">Daftar di sini</a>
            </p>

            <p class="mb-0">Lupa sandi?
              <a href="$BaseHref/auth/forgot-password" class="fw-semibold" style="color:#7c3aed;">Atur ulang sandi</a>
            </p>
          </div>

        </form>
      </div>

    </div>
  </div>
</main>

<style>
.password-wrapper {
  position: relative;
}

.password-wrapper .form-control {
  padding-right: 45px; /* ruang untuk icon */
}

.toggle-password {
  position: absolute;
  top: 50%;
  right: 16px;
  transform: translateY(-50%);
  cursor: pointer;
  font-size: 18px;
  color: #555;
}

.toggle-password:hover {
  color: #7c3aed;
}
</style>

<script>
  const togglePassword = document.getElementById('togglePassword');
  const passwordInput = document.getElementById('loginPassword');

  togglePassword.addEventListener('click', function () {
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);

    this.classList.toggle('bi-eye');
    this.classList.toggle('bi-eye-slash');
  });
</script>
