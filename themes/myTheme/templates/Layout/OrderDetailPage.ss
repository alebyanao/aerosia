<main class="order-detail-page py-5">
  <div class="container my-4">
    <!-- Session Messages -->
    <% if $OrderSuccess %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>
        $OrderSuccess
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>

    <% if $OrderError %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        $OrderError
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>

    <% if $OrderWarning %>
      <div class="alert alert-warning alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-circle-fill me-2"></i>
        $OrderWarning
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>

    <% if $PaymentSuccess %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-check-circle-fill me-2"></i>
        $PaymentSuccess
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>

    <% if $PaymentError %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-exclamation-triangle-fill me-2"></i>
        $PaymentError
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>

    <% if $InvoiceSuccess %>
      <div class="alert alert-success alert-dismissible fade show" role="alert">
        <i class="bi bi-envelope-check-fill me-2"></i>
        $InvoiceSuccess
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>

    <% if $InvoiceError %>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="bi bi-envelope-x-fill me-2"></i>
        $InvoiceError
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    <% end_if %>

    <% with $Order %>
      <!-- Order Header -->
      <div class="modern-card mb-4">
        <div class="card-body-modern">
          <div class="order-header-detail">
            <div class="order-info-header">
              <h2 class="order-title">Pesanan #$OrderCode</h2>
              <p class="order-date">
                <i class="bi bi-clock"></i>
                Dipesan pada: $CreatedAt.Nice
              </p>
            </div>
            <div class="order-status-header">
              <% if $Status == 'pending' || $Status == 'pending_payment' %>
                <span class="status-badge-large status-pending">
                  <i class="bi bi-clock"></i>
                  Menunggu Pembayaran
                </span>
              <% else_if $Status == 'paid' %>
                <span class="status-badge-large status-success">
                  <i class="bi bi-check-circle"></i>
                  Sudah Dibayar
                </span>
              <% else_if $Status == 'completed' %>
                <span class="status-badge-large status-primary">
                  <i class="bi bi-check-all"></i>
                  Selesai
                </span>
              <% else_if $Status == 'cancelled' %>
                <span class="status-badge-large status-cancelled">
                  <i class="bi bi-x-circle"></i>
                  Dibatalkan
                </span>
              <% end_if %>
            </div>
          </div>

          <!-- Payment Timer -->
          <% if $Status == 'pending_payment' && $Up.TimeRemaining %>
            <div class="payment-timer">
              <i class="bi bi-clock-history"></i>
              <div>
                <strong>Waktu pembayaran tersisa: $Up.TimeRemaining</strong>
                <br>
                <small>Setelah melewati batas waktu, pesanan akan dibatalkan otomatis.</small>
              </div>
            </div>
          <% end_if %>
        </div>
      </div>

      <div class="row g-4">
        <!-- Left Column -->
        <div class="col-lg-8">
          <!-- Event Details -->
          <% with $Up.Ticket %>
            <div class="modern-card mb-4">
              <div class="card-header-modern">
                <h5 class="section-title">
                  <i class="bi bi-calendar-event"></i>
                  DETAIL EVENT
                </h5>
              </div>
              <div class="card-body-modern">
                <% if $Image %>
                  <img src="$Image.URL" alt="$Title" class="event-detail-image">
                <% end_if %>

                <h4 class="event-title-detail">$Title</h4>

                <div class="event-info-detail">
                  <% if $EventDate %>
                    <div class="info-item">
                      <i class="bi bi-calendar3"></i>
                      <div>
                        <span class="info-label">Tanggal</span>
                        <span class="info-value">$EventDate.Nice</span>
                      </div>
                    </div>
                  <% end_if %>

                  <% if $Location %>
                    <div class="info-item">
                      <i class="bi bi-geo-alt"></i>
                      <div>
                        <span class="info-label">Lokasi</span>
                        <span class="info-value">$Location</span>
                      </div>
                    </div>
                  <% end_if %>

                  <div class="info-item">
                    <i class="bi bi-ticket-perforated"></i>
                    <div>
                      <span class="info-label">Tipe Tiket</span>
                      <span class="info-value">$Up.Up.TicketType.TypeName</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          <% end_with %>

          <!-- Buyer Information -->
          <div class="modern-card mb-4">
            <div class="card-header-modern">
              <h5 class="section-title">
                <i class="bi bi-person-circle"></i>
                DATA PEMESAN
              </h5>
            </div>
            <div class="card-body-modern">
              <div class="buyer-info">
                <div class="buyer-item">
                  <span class="buyer-label">Nama</span>
                  <span class="buyer-value">$FullName</span>
                </div>
                <div class="buyer-item">
                  <span class="buyer-label">Email</span>
                  <span class="buyer-value">$Email</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Payment Transactions -->
          <% if $Up.Transactions %>
            <div class="modern-card mb-4">
              <div class="card-header-modern">
                <h5 class="section-title">
                  <i class="bi bi-credit-card"></i>
                  RIWAYAT TRANSAKSI
                </h5>
              </div>
              <div class="card-body-modern">
                <div class="table-responsive">
                  <table class="transaction-table">
                    <thead>
                      <tr>
                        <th>Transaction ID</th>
                        <th>Tanggal</th>
                        <th>Status</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% loop $Up.Transactions %>
                        <tr>
                          <td><code class="transaction-code">$TransactionID</code></td>
                          <td>$CreatedAt.Nice</td>
                          <td>
                            <% if $Status == 'success' %>
                              <span class="status-badge-small status-success">Success</span>
                            <% else_if $Status == 'failed' %>
                              <span class="status-badge-small status-cancelled">Failed</span>
                            <% else %>
                              <span class="status-badge-small status-pending">Pending</span>
                            <% end_if %>
                          </td>
                        </tr>
                      <% end_loop %>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          <% end_if %>
        </div>

        <!-- Right Column (Summary) -->
        <div class="col-lg-4">
          <div class="modern-card summary-card-sticky">
            <div class="card-header-modern">
              <h5 class="section-title">
                <i class="bi bi-receipt"></i>
                RINGKASAN PEMBAYARAN
              </h5>
            </div>
            <div class="card-body-modern">
              <!-- Price Breakdown -->
              <div class="summary-detail-row">
                <span class="summary-detail-label">Harga per Tiket</span>
                <span class="summary-detail-value">$TicketType.FormattedPrice</span>
              </div>

              <div class="summary-detail-row">
                <span class="summary-detail-label">Jumlah Tiket</span>
                <span class="summary-detail-value">$Quantity tiket</span>
              </div>

              <div class="divider-line"></div>

              <div class="summary-detail-row">
                <span class="summary-detail-label">Subtotal</span>
                <span class="summary-detail-value">$FormattedTotalPrice</span>
              </div>

              <div class="summary-detail-row">
                <span class="summary-detail-label">Biaya Admin</span>
                <span class="summary-detail-value">$FormattedPaymentFee</span>
              </div>

              <div class="divider-line"></div>

              <!-- Grand Total -->
              <div class="grand-total-row">
                <span class="grand-total-label">TOTAL BAYAR</span>
                <span class="grand-total-value">$FormattedGrandTotal</span>
              </div>

              <div class="divider-line"></div>

              <!-- Action Buttons -->
              <div class="action-buttons-detail">
                <% if $canBePaid %>
                  <a href="$BaseHref/payment/initiate/$ID" target="_blank" class="btn-submit">
                    <i class="bi bi-credit-card"></i>
                    Bayar Sekarang
                  </a>
                <% end_if %>

                <% if $PaymentStatus == 'paid' %>
                  <a href="$BaseHref/invoice/download/$ID" class="btn-primary-detail">
                    <i class="bi bi-download"></i>
                    Download Invoice
                  </a>
                  <a href="$BaseHref/invoice/send/$ID" class="btn-outline-detail">
                    <i class="bi bi-envelope"></i>
                    Kirim Ulang Invoice
                  </a>
                <% end_if %>

                <% if $canBeCancelled %>
                  <a href="$BaseHref/order/cancel/$ID" class="btn-danger-detail" 
                     onclick="return confirm('Apakah Anda yakin ingin membatalkan pesanan ini? Tindakan ini tidak dapat dibatalkan.')">
                    <i class="bi bi-x-circle"></i>
                    Batalkan Pesanan
                  </a>
                <% end_if %>
              </div>

              <% if $PaymentStatus == 'paid' %>
                <div class="info-alert">
                  <i class="bi bi-info-circle"></i>
                  E-ticket telah dikirim ke email Anda
                </div>
              <% end_if %>
            </div>
          </div>
        </div>
      </div>
    <% end_with %>
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
  background-color: #ffffffff;
  color: #333;
  padding-top: 100px;
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

/* Alerts */
.alert {
  border-radius: 10px;
  border: none;
  padding: 16px;
  margin-bottom: 20px;
}

/* Back Button */
.btn-back {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  background-color: #fff;
  border: 2px solid #e8e8e8;
  border-radius: 8px;
  color: #666;
  text-decoration: none;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s;
}

.btn-back:hover {
  border-color: #6366f1;
  background-color: #f8f9ff;
  color: #6366f1;
}

.btn-back i {
  font-size: 16px;
}

/* Order Header */
.order-header-detail {
  display: flex;
  justify-content: space-between;
  align-items: start;
  flex-wrap: wrap;
  gap: 16px;
}

.order-info-header {
  flex: 1;
}

.order-title {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  margin-bottom: 8px;
}

.order-date {
  font-size: 14px;
  color: #666;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 6px;
}

.order-date i {
  font-size: 15px;
  color: #999;
}

.order-status-header {
  display: flex;
  align-items: center;
}

.status-badge-large {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 700;
}

.status-badge-large i {
  font-size: 16px;
}

.status-pending {
  background-color: #fff3cd;
  color: #856404;
}

.status-success {
  background-color: #d4edda;
  color: #155724;
}

.status-primary {
  background-color: #cfe2ff;
  color: #084298;
}

.status-cancelled {
  background-color: #f8d7da;
  color: #721c24;
}

/* Payment Timer */
.payment-timer {
  margin-top: 20px;
  padding: 16px;
  background-color: #fff3cd;
  border-radius: 8px;
  display: flex;
  gap: 12px;
  align-items: start;
}

.payment-timer i {
  font-size: 24px;
  color: #856404;
  flex-shrink: 0;
}

.payment-timer strong {
  color: #856404;
  font-size: 14px;
}

.payment-timer small {
  color: #856404;
  font-size: 12px;
}

/* Event Detail Image */
.event-detail-image {
  width: 100%;
  height: 250px;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 20px;
}

.event-title-detail {
  font-size: 20px;
  font-weight: 700;
  color: #333;
  margin-bottom: 20px;
}

/* Event Info Detail */
.event-info-detail {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.info-item {
  display: flex;
  align-items: start;
  gap: 12px;
}

.info-item i {
  font-size: 20px;
  color: #6366f1;
  flex-shrink: 0;
  margin-top: 2px;
}

.info-item > div {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-label {
  font-size: 12px;
  color: #999;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.info-value {
  font-size: 14px;
  color: #333;
  font-weight: 600;
}

/* Buyer Info */
.buyer-info {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.buyer-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 16px;
  border-bottom: 1px solid #f0f0f0;
}

.buyer-item:last-child {
  border-bottom: none;
  padding-bottom: 0;
}

.buyer-label {
  font-size: 13px;
  color: #666;
  font-weight: 500;
}

.buyer-value {
  font-size: 14px;
  color: #333;
  font-weight: 600;
  text-align: right;
}

/* Transaction Table */
.table-responsive {
  overflow-x: auto;
}

.transaction-table {
  width: 100%;
  border-collapse: collapse;
}

.transaction-table thead {
  background-color: #f8f8f8;
}

.transaction-table th {
  padding: 12px;
  text-align: left;
  font-size: 12px;
  font-weight: 700;
  color: #666;
  text-transform: uppercase;
  letter-spacing: 0.3px;
  border-bottom: 2px solid #e8e8e8;
}

.transaction-table td {
  padding: 12px;
  font-size: 13px;
  color: #333;
  border-bottom: 1px solid #f0f0f0;
}

.transaction-code {
  background-color: #f8f8f8;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  color: #6366f1;
  font-family: 'Courier New', monospace;
}

.status-badge-small {
  display: inline-block;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 600;
}

/* Summary Detail */
.summary-card-sticky {
  position: sticky;
}

.summary-detail-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

.summary-detail-label {
  font-size: 13px;
  color: #666;
  font-weight: 500;
}

.summary-detail-value {
  font-size: 14px;
  color: #333;
  font-weight: 600;
}

.divider-line {
  height: 1px;
  background-color: #e8e8e8;
  margin: 16px 0;
}

.grand-total-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0;
}

.grand-total-label {
  font-size: 13px;
  color: #666;
  font-weight: 700;
  letter-spacing: 0.5px;
}

.grand-total-value {
  font-size: 24px;
  color: #333;
  font-weight: 700;
}

/* Action Buttons Detail */
.action-buttons-detail {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.btn-submit,
.btn-primary-detail,
.btn-outline-detail,
.btn-danger-detail {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px 20px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s;
  cursor: pointer;
  border: 2px solid transparent;
}

.btn-submit {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: #fff;
}

.btn-submit:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
  color: #fff;
}

.btn-primary-detail {
  background-color: #6366f1;
  color: #fff;
}

.btn-primary-detail:hover {
  background-color: #4f46e5;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
  color: #fff;
}

.btn-outline-detail {
  background-color: #fff;
  color: #6366f1;
  border-color: #6366f1;
}

.btn-outline-detail:hover {
  background-color: #6366f1;
  color: #fff;
}

.btn-danger-detail {
  background-color: #fff;
  color: #dc3545;
  border-color: #dc3545;
}

.btn-danger-detail:hover {
  background-color: #dc3545;
  color: #fff;
}

.info-alert {
  margin-top: 16px;
  padding: 12px;
  background-color: #cfe2ff;
  border-radius: 8px;
  font-size: 12px;
  color: #084298;
  display: flex;
  align-items: center;
  gap: 8px;
}

.info-alert i {
  font-size: 16px;
}

/* Responsive */
@media (max-width: 991px) {
  .summary-card-sticky {
    position: relative !important;
    top: 0 !important;
  }

  .order-header-detail {
    flex-direction: column;
  }

  .order-status-header {
    width: 100%;
  }

  .status-badge-large {
    width: 100%;
    justify-content: center;
  }

  .event-detail-image {
    height: 200px;
  }
}

@media (max-width: 576px) {
  .order-title {
    font-size: 20px;
  }

  .card-body-modern {
    padding: 20px;
  }

  .card-header-modern {
    padding: 16px 20px;
  }

  .event-detail-image {
    height: 180px;
  }

  .grand-total-value {
    font-size: 20px;
  }

  .transaction-table {
    font-size: 12px;
  }

  .transaction-table th,
  .transaction-table td {
    padding: 10px 8px;
  }
}
</style>

<script>
// Auto-dismiss alerts after 5 seconds
setTimeout(function() {
  const alerts = document.querySelectorAll('.alert-dismissible');
  alerts.forEach(alert => {
    setTimeout(() => {
      const closeBtn = alert.querySelector('.btn-close');
      if (closeBtn) closeBtn.click();
    }, 5000);
  });
}, 100);
</script>