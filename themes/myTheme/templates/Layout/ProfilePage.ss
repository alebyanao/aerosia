<main class="profile-page py-5">
    <div class="container my-4">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <!-- Page Header -->
                <div class="page-header mb-4">
                    <h1 class="page-title">Profil Saya</h1>
                    <p class="page-subtitle">Kelola informasi profil dan keamanan akun Anda</p>
                </div>
                
                <!-- Alerts -->
                <% if $UpdateSuccess %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>
                        $UpdateSuccess
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% end_if %>
                
                <% if $UpdateErrors %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        $UpdateErrors.RAW
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% end_if %>
                
                <% if $Member %>
                    <form method="POST" action="$BaseHref/profile" class="profile-form">
                        <input type="hidden" name="SecurityID" value="$SecurityID" />
                        
                        <!-- Personal Information -->
                        <div class="modern-card mb-4">
                            <div class="card-header-modern">
                                <h5 class="section-title">
                                    <i class="bi bi-person-circle"></i>
                                    INFORMASI PRIBADI
                                </h5>
                            </div>
                            <div class="card-body-modern">
                                <div class="form-group-modern mb-3">
                                    <label class="form-label-modern">Nama Depan <span class="required">*</span></label>
                                    <input type="text" class="form-control-modern" id="first_name" name="first_name" value="$Member.FirstName" placeholder="Masukkan nama depan" required>
                                </div>
                                
                                <div class="form-group-modern mb-3">
                                    <label class="form-label-modern">Nama Belakang <span class="required">*</span></label>
                                    <input type="text" class="form-control-modern" id="last_name" name="last_name" value="$Member.Surname" placeholder="Masukkan nama belakang" required>
                                </div>
                                
                                <div class="form-group-modern mb-0">
                                    <label class="form-label-modern">Email <span class="required">*</span></label>
                                    <input type="email" class="form-control-modern" id="email" name="email" value="$Member.Email" placeholder="email@example.com" required>
                                    <small class="form-hint">Email digunakan untuk login dan menerima notifikasi</small>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Change Password -->
                        <div class="modern-card mb-4">
                            <div class="card-header-modern">
                                <h5 class="section-title">
                                    <i class="bi bi-shield-lock"></i>
                                    UBAH KATA SANDI
                                </h5>
                            </div>
                            <div class="card-body-modern">
                                <p class="section-description">Kosongkan jika tidak ingin mengubah kata sandi</p>
                                
                                <div class="form-group-modern mb-3">
                                    <label class="form-label-modern">Kata Sandi Saat Ini</label>
                                    <div class="password-input-wrapper">
                                        <input type="password" class="form-control-modern" id="current_password" name="current_password" placeholder="Masukkan kata sandi saat ini">
                                        <button type="button" class="password-toggle" data-target="current_password">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                    <small class="form-hint">Diperlukan jika ingin mengubah kata sandi</small>
                                </div>
                                
                                <div class="form-group-modern mb-3">
                                    <label class="form-label-modern">Kata Sandi Baru</label>
                                    <div class="password-input-wrapper">
                                        <input type="password" class="form-control-modern" id="new_password" name="new_password" placeholder="Minimal 8 karakter">
                                        <button type="button" class="password-toggle" data-target="new_password">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                    <small class="form-hint">Minimal 8 karakter, kombinasi huruf dan angka</small>
                                </div>
                                
                                <div class="form-group-modern mb-0">
                                    <label class="form-label-modern">Konfirmasi Kata Sandi Baru</label>
                                    <div class="password-input-wrapper">
                                        <input type="password" class="form-control-modern" id="confirm_password" name="confirm_password" placeholder="Ketik ulang kata sandi baru">
                                        <button type="button" class="password-toggle" data-target="confirm_password">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Action Buttons -->
                        <div class="action-buttons-profile">
                            <a href="$BaseHref" class="btn-cancel">
                                <i class="bi bi-x-circle"></i>
                                Batal
                            </a>
                            <button type="submit" class="btn-submit">
                                <i class="bi bi-check-circle"></i>
                                Perbarui Profil
                            </button>
                        </div>
                    </form>
                <% end_if %>
            </div>
        </div>
    </div>
</main>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  background-color: #fff;
  color: #333;
  padding-top: 100px;
}

/* Page Header */
.page-header {
  margin-bottom: 24px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.page-subtitle {
  font-size: 14px;
  color: #666;
  margin: 0;
}

/* Modern Card */
.modern-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.card-header-modern {
  padding: 20px 24px;
  border-bottom: 1px solid #e8e8e8;
}

.section-title {
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 0.5px;
  color: #333;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 8px;
}

.section-title i {
  font-size: 16px;
  color: #6366f1;
}

.card-body-modern {
  padding: 24px;
}

.section-description {
  font-size: 13px;
  color: #666;
  margin-bottom: 20px;
}

/* Form Elements */
.form-group-modern {
  margin-bottom: 20px;
}

.form-label-modern {
  display: block;
  font-size: 14px;
  color: #333;
  margin-bottom: 8px;
  font-weight: 600;
}

.required {
  color: #dc3545;
  font-weight: 700;
}

.form-control-modern {
  width: 100%;
  padding: 12px 16px;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s;
  background-color: #fff;
  color: #333;
}

.form-control-modern:focus {
  outline: none;
  border-color: #6366f1;
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

.form-control-modern::placeholder {
  color: #999;
}

.form-hint {
  display: block;
  font-size: 12px;
  color: #999;
  margin-top: 6px;
}

/* Password Input */
.password-input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.password-input-wrapper .form-control-modern {
  padding-right: 45px;
}

.password-toggle {
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  color: #999;
  cursor: pointer;
  padding: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: color 0.3s;
}

.password-toggle:hover {
  color: #6366f1;
}

.password-toggle i {
  font-size: 18px;
}

/* Alerts */
.alert {
  border-radius: 10px;
  border: none;
  padding: 16px;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.alert i {
  font-size: 20px;
  margin-right: 8px;
}

/* Action Buttons */
.action-buttons-profile {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 24px;
}

.btn-cancel,
.btn-submit {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 32px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s;
  cursor: pointer;
  border: 2px solid transparent;
}

.btn-cancel {
  background-color: #fff;
  color: #666;
  border-color: #e0e0e0;
}

.btn-cancel:hover {
  background-color: #f8f8f8;
  border-color: #999;
  color: #333;
}

.btn-submit {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  border: none;
}

.btn-submit:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
}

.btn-cancel i,
.btn-submit i {
  font-size: 16px;
}

/* Responsive */
@media (max-width: 768px) {
  .page-title {
    font-size: 24px;
  }

  .card-body-modern {
    padding: 20px;
  }

  .card-header-modern {
    padding: 16px 20px;
  }

  .action-buttons-profile {
    flex-direction: column-reverse;
  }

  .btn-cancel,
  .btn-submit {
    width: 100%;
  }
}

@media (max-width: 576px) {
  .container {
    padding-left: 16px;
    padding-right: 16px;
  }

  .col-md-8 {
    padding-left: 0;
    padding-right: 0;
  }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
  // Password Toggle
  const passwordToggles = document.querySelectorAll('.password-toggle');
  
  passwordToggles.forEach(toggle => {
    toggle.addEventListener('click', function() {
      const targetId = this.getAttribute('data-target');
      const input = document.getElementById(targetId);
      const icon = this.querySelector('i');
      
      if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('bi-eye');
        icon.classList.add('bi-eye-slash');
      } else {
        input.type = 'password';
        icon.classList.remove('bi-eye-slash');
        icon.classList.add('bi-eye');
      }
    });
  });

  // Form Validation
  const form = document.querySelector('.profile-form');
  
  if (form) {
    form.addEventListener('submit', function(e) {
      const currentPassword = document.getElementById('current_password').value;
      const newPassword = document.getElementById('new_password').value;
      const confirmPassword = document.getElementById('confirm_password').value;
      
      // Check if user wants to change password
      if (newPassword || confirmPassword) {
        if (!currentPassword) {
          e.preventDefault();
          alert('Masukkan kata sandi saat ini untuk mengubah kata sandi');
          document.getElementById('current_password').focus();
          return false;
        }
        
        if (newPassword.length < 8) {
          e.preventDefault();
          alert('Kata sandi baru minimal 8 karakter');
          document.getElementById('new_password').focus();
          return false;
        }
        
        if (newPassword !== confirmPassword) {
          e.preventDefault();
          alert('Konfirmasi kata sandi tidak cocok');
          document.getElementById('confirm_password').focus();
          return false;
        }
      }
    });
  }

  // Auto-dismiss Alerts
  setTimeout(function() {
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
      setTimeout(() => {
        const closeBtn = alert.querySelector('.btn-close');
        if (closeBtn) closeBtn.click();
      }, 5000);
    });
  }, 100);
});
</script>