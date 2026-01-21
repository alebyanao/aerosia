
<div class="checkout-page">
  <div class="container my-4">
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

    <!-- Alert untuk Tiket Gratis -->
    <% if $IsFreeTicket %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-gift-fill me-2"></i>
        <strong>Tiket Gratis!</strong> Anda akan langsung mendapatkan tiket setelah mengisi data pemesan.
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>
    
    <div class="row g-4">
      <!-- Form Checkout -->
      <div class="col-lg-7">
        <!-- INI YANG PENTING: Tambahkan target="_blank" di form tag -->
        <form method="post" action="$BaseHref/checkout/processOrder" id="checkoutForm" target="_blank">
          <!-- Hidden Fields -->
          <input type="hidden" name="ticket_type_id" value="$TicketType.ID">
          <input type="hidden" name="quantity" value="$Quantity">
          <input type="hidden" id="is_free_ticket" value="<% if $IsFreeTicket %>1<% else %>0<% end_if %>">

          <!-- Data Pemesan -->
          <div class="modern-card mb-4">
            <div class="card-header-modern">
              <h5 class="section-title">DATA PEMESAN</h5>
            </div>
            <div class="card-body-modern">
              <div class="form-check-modern mb-4">
                <label class="switch-label">
                  <input type="checkbox" id="useProfile" name="use_profile" checked>
                  <span class="switch-slider"></span>
                  <span class="switch-text">Samakan seperti data di profile</span>
                </label>
              </div>

              <div class="form-group-modern mb-3">
                <label class="form-label-modern">Nama lengkap</label>
                <input type="text" class="form-control-modern" id="FullName" name="FullName"
                       value="$CurrentUser.FirstName $CurrentUser.Surname"
                       data-profile-value="$CurrentUser.FirstName $CurrentUser.Surname"
                       placeholder="Masukkan nama lengkap" required>
              </div>

              <div class="form-group-modern mb-3">
                <label class="form-label-modern">Email</label>
                <input type="email" class="form-control-modern" id="Email" name="Email"
                       value="$CurrentUser.Email"
                       data-profile-value="$CurrentUser.Email"
                       placeholder="Masukkan email" required>
              </div>

              <div class="form-group-modern mb-0">
                <label class="form-label-modern">No. Telepon</label>
                <input type="tel" class="form-control-modern" id="Phone" name="Phone"
                       value="$CurrentUser.Phone"
                       data-profile-value="$CurrentUser.Phone"
                       placeholder="08123456789"
                       pattern="[0-9]{10,15}" required>
              </div>
            </div>
          </div>

          <!-- Metode Pembayaran -->
          <% if not $IsFreeTicket %>
          <div class="modern-card mb-4">
            <div class="card-header-modern">
              <h5 class="section-title">METODE PEMBAYARAN</h5>
            </div>
            <div class="card-body-modern">
              <% if $PaymentMethods %>
                <div id="payment-methods-container">
                  <% loop $PaymentMethods %>
                    <div class="payment-option" data-index="$Pos">
                      <input type="radio" name="payment_method" 
                             id="payment_$paymentMethod" 
                             value="$paymentMethod"
                             data-fee="$totalFee"
                             data-category="$paymentCategory" required>
                      <label for="payment_$paymentMethod" class="payment-label">
                        <div class="payment-content">
                          <% if $paymentImage %>
                            <img src="$paymentImage" alt="$paymentName" class="payment-logo">
                          <% end_if %>
                          <div class="payment-info">
                            <div class="payment-name">$paymentName</div>
                            <div class="payment-category">$paymentCategory</div>
                          </div>
                        </div>
                        <div class="payment-check">
                          <i class="bi bi-check-circle-fill"></i>
                        </div>
                      </label>
                    </div>
                  <% end_loop %>
                </div>

                <div class="text-center mt-3" id="load-more-container" style="display: none;">
                  <button type="button" class="btn-load-more" id="load-more-btn">
                    Tampilkan lebih banyak
                  </button>
                </div>
              <% else %>
                <div class="alert alert-danger">
                  <i class="bi bi-exclamation-circle me-2"></i>
                  Metode pembayaran tidak tersedia. Silakan hubungi admin.
                </div>
              <% end_if %>
            </div>
          </div>
          <% end_if %>

          <!-- Submit Button -->
          <div class="button-group">
            <% if $IsFreeTicket %>
              <button type="submit" class="btn-submit" id="submitBtn">
                <span id="submitBtnText">Buat Pesanan</span>
              </button>
            <% else %>
              <button type="submit" class="btn-submit" id="submitBtn" disabled>
                <span id="submitBtnText">Buat Pesanan</span>
              </button>
            <% end_if %>
          </div>
        </form>
      </div>

      <!-- Ringkasan Pembelian -->
      <div class="col-lg-5">
        <div class="modern-card summary-card" style="top: 20px;">
          <div class="card-body-modern">
            <!-- Event Info -->
            <% if $Ticket %>
              <div class="event-info-card mb-4">
                <% if $Ticket.Image %>
                  <img src="$Ticket.Image.URL" alt="$Ticket.Title" class="event-image">
                <% end_if %>
                <div class="event-details">
                  <h6 class="event-title">$Ticket.Title</h6>
                  <% if $Ticket.EventDate %>
                    <div class="event-meta">
                      <i class="bi bi-calendar3"></i>
                      <span>$Ticket.EventDate.Nice</span>
                    </div>
                  <% end_if %>
                  <% if $Ticket.EventTime %>
                    <div class="event-meta">
                      <i class="bi bi-clock"></i>
                      <span>$Ticket.EventTime WIB</span>
                    </div>
                  <% end_if %>
                  <% if $Ticket.Location %>
                    <div class="event-meta">
                      <i class="bi bi-geo-alt"></i>
                      <span>$Ticket.Location</span>
                    </div>
                  <% end_if %>
                </div>
              </div>
            <% end_if %>

            <h5 class="summary-title">RINGKASAN PEMBELIAN</h5>

            <!-- Ticket Info -->
            <div class="summary-row">
              <span class="summary-label">TIPE TICKET</span>
              <span class="summary-value">$Quantity</span>
            </div>

            <div class="divider-line"></div>

            <!-- Price Breakdown -->
            <div class="summary-row">
              <span class="summary-label">SUBTOTAL</span>
              <span class="summary-value">$FormattedTotal</span>
            </div>

            <% if not $IsFreeTicket %>
            <div class="summary-row" id="payment-fee-row" style="display: none;">
              <span class="summary-label">BIAYA ADMIN</span>
              <span class="summary-value" id="payment-fee-value">Rp. 0</span>
            </div>
            <% end_if %>

            <div class="divider-line"></div>

            <!-- Grand Total -->
            <div class="summary-row total-row">
              <span class="summary-label">TOTAL</span>
              <span class="summary-total" id="grand-total-display">$FormattedTotal</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  background-color: #ffffffff;
  color: #333;
}

.checkout-page {
    padding-top: 100px; /* sesuaikan tinggi header */
}

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
}

.card-body-modern {
  padding: 24px;
}

/* Toggle Switch */
.form-check-modern {
  display: flex;
  align-items: center;
}

.switch-label {
  display: flex;
  align-items: center;
  cursor: pointer;
  gap: 12px;
  user-select: none;
}

.switch-label input[type="checkbox"] {
  position: absolute;
  opacity: 0;
}

.switch-slider {
  position: relative;
  width: 44px;
  height: 24px;
  background-color: #e0e0e0;
  border-radius: 24px;
  transition: background-color 0.3s;
}

.switch-slider::before {
  content: '';
  position: absolute;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background-color: #fff;
  top: 2px;
  left: 2px;
  transition: transform 0.3s;
}

.switch-label input[type="checkbox"]:checked + .switch-slider {
  background-color: #6366f1;
}

.switch-label input[type="checkbox"]:checked + .switch-slider::before {
  transform: translateX(20px);
}

.switch-text {
  font-size: 14px;
  color: #666;
}

/* Form Inputs */
.form-group-modern {
  margin-bottom: 20px;
}

.form-label-modern {
  display: block;
  font-size: 14px;
  color: #333;
  margin-bottom: 8px;
  font-weight: 500;
}

.form-control-modern {
  width: 100%;
  padding: 12px 16px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  font-size: 14px;
  transition: all 0.3s;
  background-color: #fff;
}

.form-control-modern:focus {
  outline: none;
  border-color: #6366f1;
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

.form-control-modern.bg-light {
  background-color: #f8f8f8 !important;
}

.form-control-modern:read-only {
  background-color: #f8f8f8;
  cursor: not-allowed;
}

/* Payment Options */
#payment-methods-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.payment-option {
  position: relative;
}

.payment-option input[type="radio"] {
  position: absolute;
  opacity: 0;
}

.payment-label {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 16px 12px;
  border: 2px solid #e8e8e8;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s;
  background-color: #fff;
  height: 100%;
  min-height: 100px;
  position: relative;
}

.payment-label:hover {
  border-color: #6366f1;
  background-color: #f8f9ff;
}

.payment-option input[type="radio"]:checked + .payment-label {
  border-color: #6366f1;
  background-color: #f0f1ff;
}

.payment-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  width: 100%;
}

.payment-logo {
  width: 60px;
  height: 30px;
  object-fit: contain;
}

.payment-info {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  text-align: center;
}

.payment-name {
  font-size: 12px;
  font-weight: 600;
  color: #333;
  line-height: 1.3;
}

.payment-category {
  font-size: 10px;
  color: #999;
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.payment-check {
  position: absolute;
  top: 8px;
  right: 8px;
  color: #6366f1;
  font-size: 18px;
  opacity: 0;
  transition: opacity 0.3s;
}

.payment-option input[type="radio"]:checked + .payment-label .payment-check {
  opacity: 1;
}

/* Buttons */
.btn-load-more {
  padding: 10px 24px;
  background-color: transparent;
  border: 1px solid #6366f1;
  border-radius: 8px;
  color: #6366f1;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-load-more:hover {
  background-color: #6366f1;
  color: #fff;
}

.btn-submit {
  width: 100%;
  padding: 16px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 10px;
  color: #fff;
  font-size: 15px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s;
  text-transform: capitalize;
}

.btn-submit:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
}

.btn-submit:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}

.button-group {
  margin-top: 24px;
}

/* Summary Card */
.summary-card {
  border: none;
}

.event-info-card {
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid #e8e8e8;
}

.event-image {
  width: 100%;
  height: 160px;
  object-fit: cover;
}

.event-details {
  padding: 16px;
}

.event-title {
  font-size: 16px;
  font-weight: 700;
  color: #333;
  margin-bottom: 12px;
}

.event-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #666;
  margin-bottom: 6px;
}

.event-meta i {
  color: #6366f1;
  font-size: 14px;
}

.summary-title {
  font-size: 14px;
  font-weight: 700;
  letter-spacing: 0.5px;
  color: #333;
  margin-bottom: 20px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.summary-label {
  font-size: 13px;
  color: #666;
  font-weight: 500;
  letter-spacing: 0.3px;
}

.summary-value {
  font-size: 14px;
  color: #333;
  font-weight: 600;
}

.divider-line {
  height: 1px;
  background-color: #e8e8e8;
  margin: 16px 0;
}

.total-row {
  margin-top: 20px;
  margin-bottom: 0;
}

.total-row .summary-label {
  font-size: 14px;
  font-weight: 700;
  color: #333;
}

.summary-total {
  font-size: 20px;
  font-weight: 700;
  color: #333;
}

/* Responsive */
@media (max-width: 991px) {

  .modern-card {
    margin-bottom: 20px;
  }
  
  #payment-methods-container {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 576px) {
  .card-body-modern {
    padding: 20px;
  }
  
  #payment-methods-container {
    grid-template-columns: repeat(2, 1fr);
    gap: 10px;
  }
  
  .payment-label {
    padding: 12px 8px;
    min-height: 90px;
  }
  
  .payment-logo {
    width: 45px;
    height: 28px;
  }
  
  .payment-name {
    font-size: 11px;
  }
  
  .event-image {
    height: 140px;
  }
}

/* Alerts */
.alert {
  border-radius: 10px;
  border: none;
  padding: 16px;
  margin-bottom: 20px;
}

/* Animation */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.spinner-border-sm {
  display: inline-block;
  width: 1rem;
  height: 1rem;
  border: 0.2em solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spin 0.75s linear infinite;
  margin-right: 8px;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const isFreeTicket = document.getElementById('is_free_ticket').value === '1';
  
  // Data Pemesan Toggle
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

  // Payment Method - Load More
  if (!isFreeTicket) {
    const paymentItems = document.querySelectorAll('.payment-option');
    const loadMoreBtn = document.getElementById('load-more-btn');
    const loadMoreContainer = document.getElementById('load-more-container');
    const INITIAL_SHOW = 6;
    let currentlyShown = INITIAL_SHOW;

    if (paymentItems.length > INITIAL_SHOW) {
      paymentItems.forEach((item, index) => {
        if (index >= INITIAL_SHOW) {
          item.style.display = 'none';
        }
      });
      loadMoreContainer.style.display = 'block';
    }

    if (loadMoreBtn) {
      loadMoreBtn.addEventListener('click', function() {
        const hiddenItems = Array.from(paymentItems).filter(item => item.style.display === 'none');
        
        hiddenItems.slice(0, 6).forEach(item => {
          item.style.display = 'block';
          item.style.animation = 'fadeIn 0.4s ease';
        });

        currentlyShown += 6;

        if (currentlyShown >= paymentItems.length) {
          loadMoreContainer.style.display = 'none';
        }
      });
    }

    // Payment Method Selection
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

        if (paymentFeeRow) {
          paymentFeeRow.style.display = 'flex';
          paymentFeeValue.textContent = 'Rp. ' + fee.toLocaleString('id-ID');
        }

        grandTotalDisplay.textContent = 'Rp. ' + grandTotal.toLocaleString('id-ID');

        submitBtn.disabled = false;
        submitBtn.querySelector('#submitBtnText').textContent = 'Buat pesanan';
      });
    });
  }

  // Form Validation
  const form = document.getElementById('checkoutForm');
  const submitBtn = document.getElementById('submitBtn');
  const submitBtnText = document.getElementById('submitBtnText');

  form.addEventListener('submit', function(e) {
    if (!isFreeTicket) {
      const selectedPayment = document.querySelector('input[name="payment_method"]:checked');
      
      if (!selectedPayment) {
        e.preventDefault();
        alert('Silakan pilih metode pembayaran terlebih dahulu!');
        return false;
      }
    }

    const phone = inputs.Phone.value;
    const phoneRegex = /^[0-9]{10,15}$/;
    if (!phoneRegex.test(phone)) {
      e.preventDefault();
      alert('Nomor telepon tidak valid. Gunakan format: 08xxxxxxxxxx (10-15 digit)');
      inputs.Phone.focus();
      return false;
    }

    submitBtn.disabled = true;
    submitBtnText.innerHTML = '<span class="spinner-border-sm"></span>Memproses...';
    
    // PENTING: Jangan preventDefault di sini, biarkan form submit dengan target="_blank"
  });

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