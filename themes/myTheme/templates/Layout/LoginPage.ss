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

          <!-- Email -->
          <label class="form-label small mb-1">Email</label>
          <input type="email" class="form-control mb-3" name="login_email" required>

          <!-- Password -->
          <label class="form-label small mb-1">Sandi</label>
          <input type="password" class="form-control mb-3" name="login_password" required>

          <!-- Remember -->
          <div class="form-check mb-3">
            <input type="checkbox" class="form-check-input" id="login_remember" name="login_remember" value="1">
            <label class="form-check-label" for="login_remember">Ingat saya</label>
          </div>

          <button type="submit" class="btn btn-purple w-100 mb-3">
            Masuk
          </button>

          <!-- Google -->
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
