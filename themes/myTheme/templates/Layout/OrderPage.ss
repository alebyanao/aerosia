<main class="order-page py-5">
  <div class="container my-5">
    <!-- Page Header -->
    <div class="row mb-4">
      <div class="col-12">
        <h1 class="fw-bold mb-2">
          <i class="bi bi-receipt-cutoff me-2 text-primary"></i>
          Pesanan Saya
        </h1>
        <p class="text-muted">Kelola semua pesanan tiket event Anda</p>
      </div>
    </div>

    <!-- Filter Tabs -->
    <div class="row mb-4">
      <div class="col-12">
        <ul class="nav nav-pills">
          <li class="nav-item">
            <a class="nav-link <% if not $StatusFilter %>active<% end_if %>" href="$Link">
              <i class="bi bi-list-ul me-1"></i> Semua
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link <% if $StatusFilter == 'pending' %>active<% end_if %>" href="$Link?status=pending">
              <i class="bi bi-clock-history me-1"></i> Menunggu Pembayaran
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link <% if $StatusFilter == 'completed' %>active<% end_if %>" href="$Link?status=completed">
              <i class="bi bi-check-circle me-1"></i> Selesai
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link <% if $StatusFilter == 'cancelled' %>active<% end_if %>" href="$Link?status=cancelled">
              <i class="bi bi-x-circle me-1"></i> Dibatalkan
            </a>
          </li>
        </ul>
      </div>
    </div>

    <!-- Orders List -->
    <div class="row">
      <div class="col-12">
        <% if $Orders %>
          <% loop $Orders %>
            <div class="card border-0 shadow-sm mb-3 order-card">
              <div class="card-body p-4">
                <div class="row align-items-center">
                  <!-- Order Info -->
                  <div class="col-lg-8">
                    <div class="d-flex align-items-start mb-3">
                      <div class="flex-grow-1">
                        <div class="d-flex align-items-center mb-2">
                          <h5 class="mb-0 me-3 fw-bold">$OrderCode</h5>
                          <% if $Status == 'pending' || $Status == 'pending_payment' %>
                            <span class="badge bg-warning text-dark">
                              <i class="bi bi-clock me-1"></i> Menunggu Pembayaran
                            </span>
                          <% else_if $Status == 'completed' %>
                            <span class="badge bg-success">
                              <i class="bi bi-check-circle me-1"></i> Selesai
                            </span>
                          <% else_if $Status == 'cancelled' %>
                            <span class="badge bg-danger">
                              <i class="bi bi-x-circle me-1"></i> Dibatalkan
                            </span>
                          <% end_if %>
                        </div>
                        
                        <% with $TicketType %>
                          <% with $Ticket %>
                            <p class="text-dark mb-1">
                              <i class="bi bi-calendar-event text-primary me-1"></i>
                              <strong>$Title</strong>
                            </p>
                            <% if $EventDate %>
                            <p class="text-muted small mb-1">
                              <i class="bi bi-calendar3 me-1"></i>
                              $EventDate.Nice
                            </p>
                            <% end_if %>
                          <% end_with %>
                          <p class="text-muted small mb-0">
                            <i class="bi bi-ticket-perforated me-1"></i>
                            $TypeName × $Up.Quantity tiket
                          </p>
                        <% end_with %>
                      </div>
                    </div>

                    <div class="text-muted small">
                      <i class="bi bi-clock me-1"></i>
                      Dipesan: $CreatedAt.Nice
                      <% if $Status == 'completed' && $CompletedAt %>
                        <br>
                        <i class="bi bi-check-circle me-1 text-success"></i>
                        Selesai: $CompletedAt.Nice
                      <% end_if %>
                    </div>
                  </div>

                  <!-- Price & Actions -->
                  <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                    <div class="mb-3">
                      <p class="text-muted small mb-1">Total Pembayaran</p>
                      <h4 class="text-success fw-bold mb-0">$FormattedGrandTotal</h4>
                    </div>

                    <div class="d-flex flex-column gap-2">
                      <a href="$BaseHref/order/detail/$ID" class="btn btn-primary btn-sm">
                        <i class="bi bi-eye me-1"></i> Lihat Detail
                      </a>

                      <% if $Status == 'pending_payment' && $canBePaid %>
                        <a href="$BaseHref/payment/initiate/$ID" class="btn btn-success btn-sm" target="_blank" > 
                          <i class="bi bi-credit-card me-1"></i> Bayar Sekarang
                        </a>
                      <% end_if %>

                      <% if $Status == 'completed' && $PaymentStatus == 'paid' %>
                        <a href="$BaseHref/invoice/download/$ID" class="btn btn-outline-primary btn-sm">
                          <i class="bi bi-download me-1"></i> Download Invoice
                        </a>
                      <% end_if %>

                      <% if $canBeCancelled %>
                        <a href="$BaseHref/order/cancel/$ID" class="btn btn-outline-danger btn-sm" 
                           onclick="return confirm('Apakah Anda yakin ingin membatalkan pesanan ini?')">
                          <i class="bi bi-x-circle me-1"></i> Batalkan
                        </a>
                      <% end_if %>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          <% end_loop %>
        <% else %>
          <!-- Empty State -->
          <div class="card border-0 shadow-sm">
            <div class="card-body text-center py-5">
              <i class="bi bi-inbox display-1 text-muted mb-3"></i>
              <h4 class="mb-2">Belum Ada Pesanan</h4>
              <p class="text-muted mb-4">
                <% if $StatusFilter %>
                  Tidak ada pesanan dengan status ini.
                <% else %>
                  Anda belum memiliki pesanan tiket. Mulai jelajahi event menarik!
                <% end_if %>
              </p>
              <a href="$BaseHref/event" class="btn btn-primary">
                <i class="bi bi-search me-2"></i> Jelajahi Event
              </a>
            </div>
          </div>
        <% end_if %>
      </div>
    </div>
  </div>
</main>

<style>
.order-card {
  transition: all 0.3s ease;
}

.order-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15) !important;
}

.nav-pills .nav-link {
  color: #666;
  border-radius: 50px;
  padding: 0.5rem 1.2rem;
  margin-right: 0.5rem;
  transition: all 0.3s ease;
}

.nav-pills .nav-link:hover {
  background-color: #f8f9fa;
}

.nav-pills .nav-link.active {
  background-color: #667eea;
  color: white;
}

@media (max-width: 991px) {
  .nav-pills {
    flex-wrap: wrap;
  }
  
  .nav-pills .nav-link {
    margin-bottom: 0.5rem;
    font-size: 0.875rem;
    padding: 0.4rem 1rem;
  }
}
</style>