<main class="order-page py-5">
  <div class="container my-4">
    <!-- Page Header -->
    <div class="page-header mb-4">
      <h1 class="page-title">Pesanan Saya</h1>
      <p class="page-subtitle">Kelola semua pesanan tiket event Anda</p>
    </div>

    <!-- Filter Tabs -->
    <div class="filter-tabs mb-4">
      <div class="tab-container">
        <a href="$Link" class="tab-item <% if not $StatusFilter %>active<% end_if %>">
          <span class="tab-text">Semua</span>
        </a>
        <a href="$Link?status=pending" class="tab-item <% if $StatusFilter == 'pending' %>active<% end_if %>">
          <span class="tab-text">Menunggu Pembayaran</span>
        </a>
        <a href="$Link?status=completed" class="tab-item <% if $StatusFilter == 'completed' %>active<% end_if %>">
          <span class="tab-text">Selesai</span>
        </a>
        <a href="$Link?status=cancelled" class="tab-item <% if $StatusFilter == 'cancelled' %>active<% end_if %>">
          <span class="tab-text">Dibatalkan</span>
        </a>
      </div>
    </div>

    <!-- Orders List -->
    <div class="orders-container">
      <% if $Orders %>
        <% loop $Orders %>
          <div class="modern-card order-card mb-3">
            <div class="card-body-modern">
              <!-- Order Header -->
              <div class="order-header">
                <div class="order-code">$OrderCode</div>
                <% if $Status == 'pending' || $Status == 'pending_payment' %>
                  <span class="status-badge status-pending">
                    <i class="bi bi-clock"></i>
                    Menunggu Pembayaran
                  </span>
                <% else_if $Status == 'completed' %>
                  <span class="status-badge status-success">
                    <i class="bi bi-check-circle"></i>
                    Selesai
                  </span>
                <% else_if $Status == 'cancelled' %>
                  <span class="status-badge status-cancelled">
                    <i class="bi bi-x-circle"></i>
                    Dibatalkan
                  </span>
                <% end_if %>
              </div>

              <div class="divider-line my-3"></div>

              <!-- Order Content -->
              <div class="order-content">
                <div class="order-info">
                  <% with $TicketType %>
                    <% with $Ticket %>
                      <div class="event-name">
                        <i class="bi bi-calendar-event"></i>
                        $Title
                      </div>
                      <% if $EventDate %>
                        <div class="event-detail">
                          <i class="bi bi-calendar3"></i>
                          $EventDate.Nice
                        </div>
                      <% end_if %>
                    <% end_with %>
                    <div class="event-detail">
                      <i class="bi bi-ticket-perforated"></i>
                      $TypeName × $Up.Quantity tiket
                    </div>
                  <% end_with %>

                  <div class="order-time">
                    <i class="bi bi-clock"></i>
                    Dipesan: $CreatedAt.Nice
                  </div>
                  <% if $Status == 'completed' && $CompletedAt %>
                    <div class="order-time text-success">
                      <i class="bi bi-check-circle"></i>
                      Selesai: $CompletedAt.Nice
                    </div>
                  <% end_if %>
                </div>

                <div class="order-actions">
                  <div class="total-section">
                    <span class="total-label">TOTAL PEMBAYARAN</span>
                    <span class="total-amount">$FormattedGrandTotal</span>
                  </div>

                  <div class="action-buttons">
                    <a href="$BaseHref/order/detail/$ID" class="btn-action btn-primary-action">
                      <i class="bi bi-eye"></i>
                      Lihat Detail
                    </a>

                    <% if $Status == 'pending_payment' && $canBePaid %>
                      <a href="$BaseHref/payment/initiate/$ID" class="btn-action btn-success-action" target="_blank">
                        <i class="bi bi-credit-card"></i>
                        Bayar Sekarang
                      </a>
                    <% end_if %>

                    <% if $Status == 'completed' && $PaymentStatus == 'paid' %>
                      <a href="$BaseHref/invoice/download/$ID" class="btn-action btn-outline-action">
                        <i class="bi bi-download"></i>
                        Download Invoice
                      </a>
                    <% end_if %>

                    <% if $canBeCancelled %>
                      <a href="$BaseHref/order/cancel/$ID" class="btn-action btn-danger-action" 
                         onclick="return confirm('Apakah Anda yakin ingin membatalkan pesanan ini?')">
                        <i class="bi bi-x-circle"></i>
                        Batalkan
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
        <div class="modern-card empty-state">
          <div class="card-body-modern text-center py-5">
            <div class="empty-icon">
              <i class="bi bi-inbox"></i>
            </div>
            <h4 class="empty-title">Belum Ada Pesanan</h4>
            <p class="empty-text">
              <% if $StatusFilter %>
                Tidak ada pesanan dengan status ini.
              <% else %>
                Anda belum memiliki pesanan tiket. Mulai jelajahi event menarik!
              <% end_if %>
            </p>
            <a href="$BaseHref/event" class="btn-submit">
              <i class="bi bi-search me-2"></i>
              Jelajahi Event
            </a>
          </div>
        </div>
      <% end_if %>
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
  background-color: #ffffffff;
  color: #333;
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

/* Filter Tabs */
.filter-tabs {
  margin-bottom: 24px;
}

.tab-container {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.tab-item {
  padding: 10px 20px;
  background-color: #fff;
  border: 2px solid #e8e8e8;
  border-radius: 8px;
  color: #666;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.3s;
  cursor: pointer;
}

.tab-item:hover {
  border-color: #6366f1;
  background-color: #f8f9ff;
  color: #6366f1;
}

.tab-item.active {
  background-color: #6366f1;
  border-color: #6366f1;
  color: #fff;
}

.tab-text {
  display: inline-block;
}

/* Modern Card */
.modern-card {
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
}

.modern-card:hover {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  transform: translateY(-2px);
}

.card-body-modern {
  padding: 24px;
}

/* Order Card */
.order-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.order-code {
  font-size: 16px;
  font-weight: 700;
  color: #333;
}

.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
}

.status-badge i {
  font-size: 14px;
}

.status-pending {
  background-color: #fff3cd;
  color: #856404;
}

.status-success {
  background-color: #d4edda;
  color: #155724;
}

.status-cancelled {
  background-color: #f8d7da;
  color: #721c24;
}

.divider-line {
  height: 1px;
  background-color: #e8e8e8;
  margin: 16px 0;
}

/* Order Content */
.order-content {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 24px;
  align-items: start;
}

.order-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.event-name {
  font-size: 15px;
  font-weight: 600;
  color: #333;
  display: flex;
  align-items: center;
  gap: 8px;
}

.event-name i {
  color: #6366f1;
  font-size: 16px;
}

.event-detail {
  font-size: 13px;
  color: #666;
  display: flex;
  align-items: center;
  gap: 8px;
}

.event-detail i {
  color: #999;
  font-size: 14px;
}

.order-time {
  font-size: 12px;
  color: #999;
  display: flex;
  align-items: center;
  gap: 6px;
  margin-top: 8px;
}

.order-time i {
  font-size: 13px;
}

.order-time.text-success {
  color: #28a745 !important;
}

/* Order Actions */
.order-actions {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 16px;
}

.total-section {
  text-align: right;
}

.total-label {
  display: block;
  font-size: 11px;
  color: #999;
  font-weight: 600;
  letter-spacing: 0.5px;
  margin-bottom: 4px;
}

.total-amount {
  display: block;
  font-size: 22px;
  font-weight: 700;
  color: #333;
}

.action-buttons {
  display: flex;
  flex-direction: column;
  gap: 8px;
  min-width: 180px;
}

.btn-action {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s;
  cursor: pointer;
  border: 2px solid transparent;
  white-space: nowrap;
}

.btn-action i {
  font-size: 14px;
}

.btn-primary-action {
  background-color: #6366f1;
  color: #fff;
}

.btn-primary-action:hover {
  background-color: #4f46e5;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
}

.btn-success-action {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: #fff;
}

.btn-success-action:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
}

.btn-outline-action {
  background-color: #fff;
  color: #6366f1;
  border-color: #6366f1;
}

.btn-outline-action:hover {
  background-color: #6366f1;
  color: #fff;
}

.btn-danger-action {
  background-color: #fff;
  color: #dc3545;
  border-color: #dc3545;
}

.btn-danger-action:hover {
  background-color: #dc3545;
  color: #fff;
}

/* Empty State */
.empty-state .card-body-modern {
  padding: 60px 24px;
}

.empty-icon {
  font-size: 80px;
  color: #e0e0e0;
  margin-bottom: 24px;
}

.empty-title {
  font-size: 20px;
  font-weight: 700;
  color: #333;
  margin-bottom: 12px;
}

.empty-text {
  font-size: 14px;
  color: #666;
  margin-bottom: 24px;
}

.btn-submit {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 12px 32px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 8px;
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  text-decoration: none;
}

.btn-submit:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
  color: #fff;
}

/* Responsive */
@media (max-width: 991px) {
  .order-content {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .order-actions {
    align-items: stretch;
  }

  .total-section {
    text-align: left;
    padding-bottom: 12px;
    border-bottom: 1px solid #e8e8e8;
  }

  .action-buttons {
    width: 100%;
    min-width: auto;
  }

  .tab-container {
    gap: 8px;
  }

  .tab-item {
    padding: 8px 16px;
    font-size: 13px;
  }
}

@media (max-width: 576px) {
  .page-title {
    font-size: 24px;
  }

  .card-body-modern {
    padding: 20px;
  }

  .order-code {
    font-size: 14px;
  }

  .status-badge {
    font-size: 11px;
    padding: 5px 12px;
  }

  .total-amount {
    font-size: 20px;
  }

  .btn-action {
    padding: 10px 16px;
    font-size: 12px;
  }

  .tab-item {
    flex: 1 1 calc(50% - 4px);
    text-align: center;
    padding: 10px 12px;
    font-size: 12px;
  }
}
</style>