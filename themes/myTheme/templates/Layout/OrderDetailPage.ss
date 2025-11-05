<main class="order-detail-page py-5">
  <div class="container my-5">
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

    <!-- Back Button -->
    <div class="mb-4">
      <a href="$BaseHref/order" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-left me-2"></i> Kembali ke Daftar Pesanan
      </a>
    </div>

    <% with $Order %>
      <!-- Order Header -->
      <div class="card border-0 shadow-sm mb-4">
        <div class="card-body p-4">
          <div class="row align-items-center">
            <div class="col-lg-8">
              <h2 class="fw-bold mb-2">Pesanan #$OrderCode</h2>
              <p class="text-muted mb-0">
                <i class="bi bi-clock me-1"></i>
                Dipesan pada: $CreatedAt.Nice
              </p>
            </div>
            <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
              <% if $Status == 'pending' || $Status == 'pending_payment' %>
                <span class="badge bg-warning text-dark fs-6 px-3 py-2">
                  <i class="bi bi-clock me-1"></i> Menunggu Pembayaran
                </span>
              <% else_if $Status == 'paid' %>
                <span class="badge bg-success fs-6 px-3 py-2">
                  <i class="bi bi-check-circle me-1"></i> Sudah Dibayar
                </span>
              <% else_if $Status == 'completed' %>
                <span class="badge bg-primary fs-6 px-3 py-2">
                  <i class="bi bi-check-all me-1"></i> Selesai
                </span>
              <% else_if $Status == 'cancelled' %>
                <span class="badge bg-danger fs-6 px-3 py-2">
                  <i class="bi bi-x-circle me-1"></i> Dibatalkan
                </span>
              <% end_if %>
            </div>
          </div>

          <!-- Payment Timer (for pending orders) -->
          <% if $Status == 'pending_payment' && $Up.TimeRemaining %>
            <div class="alert alert-warning mt-3 mb-0">
              <i class="bi bi-clock-history me-2"></i>
              <strong>Waktu pembayaran tersisa:</strong> $Up.TimeRemaining
              <br>
              <small>Setelah melewati batas waktu, pesanan akan dibatalkan otomatis.</small>
            </div>
          <% end_if %>
        </div>
      </div>

      <div class="row">
        <!-- Left Column -->
        <div class="col-lg-8">
          <!-- Event Details -->
          <% with $Up.Ticket %>
            <div class="card border-0 shadow-sm mb-4">
              <div class="card-body p-4">
                <h5 class="fw-bold mb-3">
                  <i class="bi bi-calendar-event text-primary me-2"></i>
                  Detail Event
                </h5>

                <% if $Image %>
                  <img src="$Image.URL" alt="$Title" class="img-fluid rounded mb-3" style="max-height: 250px; width: 100%; object-fit: cover;">
                <% end_if %>

                <h4 class="fw-bold mb-3">$Title</h4>

                <div class="event-info">
                  <% if $EventDate %>
                    <p class="mb-2">
                      <i class="bi bi-calendar3 text-muted me-2"></i>
                      <strong>Tanggal:</strong> $EventDate.Nice
                    </p>
                  <% end_if %>

                  <% if $Location %>
                    <p class="mb-2">
                      <i class="bi bi-geo-alt text-muted me-2"></i>
                      <strong>Lokasi:</strong> $Location
                    </p>
                  <% end_if %>

                  <p class="mb-0">
                    <i class="bi bi-ticket-perforated text-muted me-2"></i>
                    <strong>Tipe Tiket:</strong> $Up.Up.TicketType.TypeName
                  </p>
                </div>
              </div>
            </div>
          <% end_with %>

          <!-- Buyer Information -->
          <div class="card border-0 shadow-sm mb-4">
            <div class="card-body p-4">
              <h5 class="fw-bold mb-3">
                <i class="bi bi-person-circle text-primary me-2"></i>
                Data Pemesan
              </h5>
              <p class="mb-2">
                <strong>Nama:</strong> $FullName
              </p>
              <p class="mb-2">
                <strong>Email:</strong> $Email
              </p>
              <% if $Phone %>
                <p class="mb-0">
                  <strong>Telepon:</strong> $Phone
                </p>
              <% end_if %>
            </div>
          </div>

          <!-- Payment Transactions (if any) -->
          <% if $Up.Transactions %>
            <div class="card border-0 shadow-sm mb-4">
              <div class="card-body p-4">
                <h5 class="fw-bold mb-3">
                  <i class="bi bi-credit-card text-primary me-2"></i>
                  Riwayat Transaksi
                </h5>
                <div class="table-responsive">
                  <table class="table table-sm">
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
                          <td><code>$TransactionID</code></td>
                          <td>$CreatedAt.Nice</td>
                          <td>
                            <% if $Status == 'success' %>
                              <span class="badge bg-success">Success</span>
                            <% else_if $Status == 'failed' %>
                              <span class="badge bg-danger">Failed</span>
                            <% else %>
                              <span class="badge bg-warning text-dark">Pending</span>
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
          <!-- Price Summary -->
          <div class="card border-0 shadow-sm mb-4 sticky-top" style="top: 100px;">
            <div class="card-body p-4">
              <h5 class="fw-bold mb-3">
                <i class="bi bi-receipt text-primary me-2"></i>
                Ringkasan Pembayaran
              </h5>

              <div class="price-row mb-2">
                <div class="d-flex justify-content-between">
                  <span class="text-muted">Harga per Tiket</span>
                  <strong>$FormattedTotalPrice.RAW / $Quantity</strong>
                </div>
              </div>

              <div class="price-row mb-2">
                <div class="d-flex justify-content-between">
                  <span class="text-muted">Jumlah Tiket</span>
                  <strong>$Quantity tiket</strong>
                </div>
              </div>

              <hr>

              <div class="price-row mb-2">
                <div class="d-flex justify-content-between">
                  <span>Subtotal</span>
                  <strong>$FormattedTotalPrice</strong>
                </div>
              </div>

              <div class="price-row mb-3">
                <div class="d-flex justify-content-between">
                  <span>Biaya Admin</span>
                  <span>$FormattedPaymentFee</span>
                </div>
              </div>

              <hr class="my-3">

              <div class="price-row">
                <div class="d-flex justify-content-between align-items-center">
                  <h5 class="mb-0">Total Bayar</h5>
                  <h4 class="mb-0 text-success fw-bold">$FormattedGrandTotal</h4>
                </div>
              </div>

              <hr class="my-3">

              <!-- Action Buttons -->
              <div class="d-grid gap-2">
                <% if $canBePaid %>
                  <a href="$BaseHref/payment/initiate/$ID" class="btn btn-success">
                    <i class="bi bi-credit-card me-2"></i> Bayar Sekarang
                  </a>
                <% end_if %>

                <% if $PaymentStatus == 'paid' %>
                  <a href="$BaseHref/invoice/download/$ID" class="btn btn-primary" target="_blank">
                    <i class="bi bi-download me-2"></i> Download Invoice
                  </a>
                  <a href="$BaseHref/invoice/send/$ID" class="btn btn-outline-primary">
                    <i class="bi bi-envelope me-2"></i> Kirim Ulang Invoice
                  </a>
                <% end_if %>

                <% if $canBeCancelled %>
                  <a href="$BaseHref/order/cancel/$ID" class="btn btn-outline-danger" 
                     onclick="return confirm('Apakah Anda yakin ingin membatalkan pesanan ini? Tindakan ini tidak dapat dibatalkan.')">
                    <i class="bi bi-x-circle me-2"></i> Batalkan Pesanan
                  </a>
                <% end_if %>
              </div>

              <% if $PaymentStatus == 'paid' %>
                <div class="alert alert-info mt-3 mb-0 small">
                  <i class="bi bi-info-circle me-1"></i>
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
.sticky-top {
  position: sticky;
}

@media (max-width: 991px) {
  .sticky-top {
    position: relative !important;
    top: 0 !important;
  }
}

.event-info p {
  display: flex;
  align-items: start;
}

.event-info i {
  flex-shrink: 0;
  margin-top: 3px;
}
</style>

<script>
// Auto-dismiss alerts after 5 seconds
setTimeout(function() {
  const alerts = document.querySelectorAll('.alert-dismissible');
  alerts.forEach(alert => {
    setTimeout(() => {
      alert.classList.remove('show');
      setTimeout(() => alert.remove(), 150);
    }, 5000);
  });
}, 100);
</script>