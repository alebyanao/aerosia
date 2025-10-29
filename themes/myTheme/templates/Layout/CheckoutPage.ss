<main class="checkout-page py-5">
  <div class="container my-5">
    <!-- Alert Error -->
    <% if $ErrorMessage %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        $ErrorMessage
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>

    <% if $Session.CheckoutError %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        $Session.CheckoutError
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>
    
    <div class="row g-4">
      <!-- Ringkasan Pembelian (Sticky Sidebar) -->
      <div class="col-lg-5 order-lg-2">
        <div class="card border-0 shadow-sm sticky-top" style="top: 100px;">
          <div class="card-body p-4">
            <h4 class="fw-bold mb-4">
              <i class="bi bi-ticket-detailed-fill me-2 text-primary"></i> 
              Ringkasan Pembelian
            </h4>
            
            <!-- Event Info -->
            <% if $Ticket %>
              <div class="event-info mb-4 p-3 bg-light rounded">
                <% if $Ticket.Image %>
                  <img src="$Ticket.Image.URL" alt="$Ticket.Title" class="img-fluid rounded mb-3" style="max-height: 200px; width: 100%; object-fit: cover;">
                <% end_if %>
                <h6 class="text-muted mb-1 small">Event</h6>
                <h5 class="mb-2 fw-bold">$Ticket.Title</h5>
                <% if $Ticket.EventDate %>
                  <p class="mb-1 small">
                    <i class="bi bi-calendar-event me-1"></i> 
                    $Ticket.EventDate.Nice
                  </p>
                <% end_if %>
                <% if $Ticket.Location %>
                  <p class="mb-0 small">
                    <i class="bi bi-geo-alt me-1"></i> 
                    $Ticket.Location
                  </p>
                <% end_if %>
              </div>
            <% end_if %>

            <!-- Ticket Type Info -->
            <div class="ticket-info mb-4">
              <h6 class="text-muted mb-2 small">Tipe Tiket</h6>
              <div class="d-flex justify-content-between align-items-start mb-2">
                <div>
                  <h5 class="mb-1 fw-bold">$TicketType.TypeName</h5>
                  <% if $TicketType.Description %>
                    <p class="text-muted small mb-0">$TicketType.Description</p>
                  <% end_if %>
                </div>
              </div>
            </div>

            <hr class="my-3">

            <!-- Price Breakdown -->
            <div class="price-breakdown">
              <div class="d-flex justify-content-between mb-2">
                <span class="text-muted">Harga per tiket</span>
                <strong>$TicketType.FormattedPrice</strong>
              </div>

              <div class="d-flex justify-content-between mb-3">
                <span class="text-muted">Jumlah tiket</span>
                <strong>$Quantity tiket</strong>
              </div>

              <hr class="my-3">

              <div class="d-flex justify-content-between mb-2">
                <span class="fw-semibold">Subtotal</span>
                <strong class="text-dark">$FormattedTotal</strong>
              </div>

              <div class="d-flex justify-content-between mb-2" id="payment-fee-row" style="display: none !important;">
                <span class="text-muted small">Biaya Admin</span>
                <span class="text-muted small" id="payment-fee-value">Rp 0</span>
              </div>

              <hr class="my-3">

              <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold">Total Bayar</h5>
                <h4 class="mb-0 text-success fw-bold" id="grand-total-display">$FormattedTotal</h4>
              </div>
            </div>

            <!-- Security Info -->
            <div class="alert alert-info mt-4 mb-0 small">
              <i class="bi bi-shield-check me-2"></i>
              Transaksi Anda aman dan terenkripsi
            </div>
          </div>
        </div>
      </div>

      <!-- Form Checkout -->
      <div class="col-lg-7">
        <form method="post" action="$BaseHref/checkout/processOrder" id="checkoutForm">
          <!-- Hidden Fields -->
          <input type="hidden" name="ticket_type_id" value="$TicketType.ID">
          <input type="hidden" name="quantity" value="$Quantity">

          <!-- Step 1: Data Pemesan -->
          <div class="card border-0 shadow-sm mb-4">
            <div class="card-body p-4">
              <h5 class="fw-bold mb-4">
                <span class="badge bg-primary me-2">1</span>
                <i class="bi bi-person-circle me-2"></i> 
                Data Pemesan
              </h5>

              <div class="form-check mb-4 p-3 bg-light rounded">
                <input class="form-check-input" type="checkbox" id="useProfile" name="use_profile" checked>
                <label class="form-check-label fw-semibold" for="useProfile">
                  <i class="bi bi-check-circle-fill text-success me-1"></i>
                  Gunakan data dari profil saya
                </label>
              </div>

              <div class="mb-3">
                <label for="FullName" class="form-label fw-semibold">
                  Nama Lengkap <span class="text-danger">*</span>
                </label>
                <input type="text" class="form-control" id="FullName" name="FullName"
                       value="$CurrentUser.FirstName $CurrentUser.Surname"
                       data-profile-value="$CurrentUser.FirstName $CurrentUser.Surname"
                       placeholder="Masukkan nama lengkap"
                       required>
              </div>

              <div class="mb-3">
                <label for="Email" class="form-label fw-semibold">
                  Email <span class="text-danger">*</span>
                </label>
                <input type="email" class="form-control" id="Email" name="Email"
                       value="$CurrentUser.Email"
                       data-profile-value="$CurrentUser.Email"
                       placeholder="contoh@email.com"
                       required>
                <small class="text-muted">
                  <i class="bi bi-info-circle me-1"></i>
                  Invoice dan e-ticket akan dikirim ke email ini
                </small>
              </div>

              <div class="mb-0">
                <label for="Phone" class="form-label fw-semibold">
                  No. Telepon <span class="text-danger">*</span>
                </label>
                <input type="tel" class="form-control" id="Phone" name="Phone"
                       value="$CurrentUser.Phone"
                       data-profile-value="$CurrentUser.Phone"
                       placeholder="08123456789"
                       pattern="[0-9]{10,15}"
                       required>
                <small class="text-muted">
                  <i class="bi bi-info-circle me-1"></i>
                  Format: 08xxxxxxxxxx (10-15 digit)
                </small>
              </div>
            </div>
          </div>

          <!-- Step 2: Metode Pembayaran -->
          <div class="card border-0 shadow-sm mb-4">
            <div class="card-body p-4">
              <h5 class="fw-bold mb-4">
                <span class="badge bg-primary me-2">2</span>
                <i class="bi bi-credit-card me-2"></i> 
                Metode Pembayaran
              </h5>

              <% if $PaymentMethods %>
                <div id="payment-methods-container">
                  <% loop $PaymentMethods %>
                    <div class="payment-method-item border rounded p-3 mb-3 cursor-pointer">
                      <div class="form-check">
                        <input class="form-check-input" type="radio" name="payment_method" 
                               id="payment_$paymentMethod" 
                               value="$paymentMethod"
                               data-fee="$totalFee"
                               required>
                        <label class="form-check-label w-100 cursor-pointer" for="payment_$paymentMethod">
                          <div class="d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center">
                              <% if $paymentImage %>
                                <img src="$paymentImage" alt="$paymentName" class="me-3" style="height: 30px; max-width: 80px; object-fit: contain;">
                              <% end_if %>
                              <div>
                                <strong class="d-block">$paymentName</strong>
                                <small class="text-muted">Biaya admin: Rp <span class="fw-semibold">{$totalFee}</span></small>
                              </div>
                            </div>
                            <i class="bi bi-check-circle-fill text-success fs-4 payment-check d-none"></i>
                          </div>
                        </label>
                      </div>
                    </div>
                  <% end_loop %>
                </div>

                <div class="alert alert-warning small mt-3 mb-0">
                  <i class="bi bi-exclamation-triangle-fill me-2"></i>
                  <strong>Perhatian:</strong> Biaya admin akan ditambahkan ke total pembayaran sesuai metode yang dipilih.
                </div>
              <% else %>
                <div class="alert alert-danger">
                  <i class="bi bi-exclamation-circle me-2"></i>
                  <strong>Metode pembayaran tidak tersedia.</strong><br>
                  Silakan hubungi admin atau coba lagi nanti.
                </div>
              <% end_if %>
            </div>
          </div>

          <!-- Submit Button -->
          <div class="card border-0 shadow-sm">
            <div class="card-body p-4">
              <div class="d-grid gap-2">
                <button type="submit" class="btn btn-success btn-lg py-3" id="submitBtn" disabled>
                  <i class="bi bi-lock-fill me-2"></i> 
                  <span id="submitBtnText">Lanjutkan ke Pembayaran</span>
                </button>
                <a href="<% if $Ticket %>$Ticket.Link<% else %>$BaseHref/events<% end_if %>" class="btn btn-outline-secondary btn-lg">
                  <i class="bi bi-arrow-left me-2"></i> Kembali
                </a>
              </div>

              <p class="text-center text-muted small mt-3 mb-0">
                Dengan melanjutkan, Anda menyetujui <a href="#">Syarat & Ketentuan</a> kami
              </p>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</main>

<style>
.payment-method-item {
  cursor: pointer;
  transition: all 0.3s ease;
  background: #fff;
}

.payment-method-item:hover {
  background-color: #f8f9fa;
  border-color: #198754 !important;
  box-shadow: 0 0 0 0.2rem rgba(25, 135, 84, 0.1);
}

.payment-method-item input:checked ~ label {
  color: #198754;
}

.payment-method-item input:checked ~ label .payment-check {
  display: inline-block !important;
}

.payment-method-item input:checked {
  border-color: #198754;
  background-color: #198754;
}

.payment-method-item:has(input:checked) {
  border-color: #198754 !important;
  background-color: #f0fdf4;
  box-shadow: 0 0 0 0.2rem rgba(25, 135, 84, 0.15);
}

.cursor-pointer {
  cursor: pointer;
}

.sticky-top {
  position: sticky;
}

@media (max-width: 991px) {
  .sticky-top {
    position: relative !important;
    top: 0 !important;
  }
}

/* Loading animation */
@keyframes spin {
  to { transform: rotate(360deg); }
}

.spinner-border-sm {
  width: 1rem;
  height: 1rem;
  border-width: 0.2em;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
  // ========================================
  // 1. Data Pemesan Toggle (Use Profile)
  // ========================================
  const useProfile = document.getElementById('useProfile');
  const inputs = {
    FullName: document.getElementById('FullName'),
    Email: document.getElementById('Email'),
    Phone: document.getElementById('Phone')
  };

  const profileValues = {
    FullName: inputs.FullName?.getAttribute('data-profile-value') || '',
    Email: inputs.Email?.getAttribute('data-profile-value') || '',
    Phone: inputs.Phone?.getAttribute('data-profile-value') || ''
  };

  let manualValues = {
    FullName: inputs.FullName.value || '',
    Email: inputs.Email.value || '',
    Phone: inputs.Phone.value || ''
  };

  function applyUseProfile(use) {
    if (use) {
      manualValues.FullName = manualValues.FullName || inputs.FullName.value;
      manualValues.Email = manualValues.Email || inputs.Email.value;
      manualValues.Phone = manualValues.Phone || inputs.Phone.value;

      inputs.FullName.value = profileValues.FullName;
      inputs.Email.value = profileValues.Email;
      inputs.Phone.value = profileValues.Phone;

      inputs.FullName.readOnly = true;
      inputs.Email.readOnly = true;
      inputs.Phone.readOnly = false;

      inputs.FullName.classList.add('bg-light');
      inputs.Email.classList.add('bg-light');
    } else {
      inputs.FullName.value = manualValues.FullName || '';
      inputs.Email.value = manualValues.Email || '';
      inputs.Phone.value = manualValues.Phone || '';

      inputs.FullName.readOnly = false;
      inputs.Email.readOnly = false;
      inputs.Phone.readOnly = false;

      inputs.FullName.classList.remove('bg-light');
      inputs.Email.classList.remove('bg-light');
    }
  }

  Object.keys(inputs).forEach(key => {
    inputs[key].addEventListener('input', (e) => {
      if (!useProfile.checked) {
        manualValues[key] = e.target.value;
      }
    });
  });

  useProfile.addEventListener('change', function() {
    applyUseProfile(this.checked);
  });

  applyUseProfile(useProfile.checked);

  // ========================================
  // 2. Payment Method Selection & Fee Calculation
  // ========================================
  const paymentMethodInputs = document.querySelectorAll('input[name="payment_method"]');
  const paymentFeeRow = document.getElementById('payment-fee-row');
  const paymentFeeValue = document.getElementById('payment-fee-value');
  const grandTotalDisplay = document.getElementById('grand-total-display');
  const submitBtn = document.getElementById('submitBtn');
  const subtotal = parseFloat('$TotalPrice') || 0;

  paymentMethodInputs.forEach(input => {
    input.addEventListener('change', function() {
      const fee = parseFloat(this.getAttribute('data-fee')) || 0;
      const grandTotal = subtotal + fee;

      // Show payment fee
      paymentFeeRow.style.display = 'flex';
      paymentFeeRow.style.justifyContent = 'space-between';
      paymentFeeValue.textContent = 'Rp ' + fee.toLocaleString('id-ID');

      // Update grand total
      grandTotalDisplay.textContent = 'Rp ' + grandTotal.toLocaleString('id-ID');

      // Enable submit button
      submitBtn.disabled = false;

      // Remove highlight from all payment methods
      document.querySelectorAll('.payment-method-item').forEach(item => {
        item.classList.remove('border-success', 'bg-light');
      });

      // Highlight selected payment method
      this.closest('.payment-method-item').classList.add('border-success');
    });
  });

  // ========================================
  // 3. Form Validation & Submit
  // ========================================
  const form = document.getElementById('checkoutForm');
  const submitBtnText = document.getElementById('submitBtnText');

  form.addEventListener('submit', function(e) {
    const selectedPayment = document.querySelector('input[name="payment_method"]:checked');
    
    if (!selectedPayment) {
      e.preventDefault();
      alert('Silakan pilih metode pembayaran terlebih dahulu!');
      return false;
    }

    // Validate phone number
    const phone = inputs.Phone.value;
    const phoneRegex = /^[0-9]{10,15}$/;
    if (!phoneRegex.test(phone)) {
      e.preventDefault();
      alert('Nomor telepon tidak valid. Gunakan format: 08xxxxxxxxxx (10-15 digit)');
      inputs.Phone.focus();
      return false;
    }

    // Disable submit button & show loading
    submitBtn.disabled = true;
    submitBtnText.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status"></span>Memproses...';
    
    // Form will submit normally and redirect via controller
  });

  // ========================================
  // 4. Session Error Auto-dismiss
  // ========================================
  setTimeout(function() {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
      if (alert.querySelector('.btn-close')) {
        setTimeout(() => {
          alert.classList.remove('show');
          setTimeout(() => alert.remove(), 150);
        }, 5000);
      }
    });
  }, 100);
});
</script>

</body>
</html>