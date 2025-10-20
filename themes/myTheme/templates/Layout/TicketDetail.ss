<div class="container my-5">
    <div class="row">
        <!-- Kolom Kiri -->
        <div class="col-lg-7">
            <% with $Ticket %>
                <% if $Image %>
                    <img src="$Image.URL" class="img-fluid rounded shadow mb-4" alt="$Title">
                <% end_if %>
                <h1 class="fw-bold mb-3">$Title</h1>
                <div class="mb-4">
                    <p class="text-muted mb-2"><i class="bi bi-calendar-event fs-5"></i> <strong>Tanggal:</strong> $EventDate.Nice</p>
                    <p class="text-muted mb-2"><i class="bi bi-geo-alt fs-5"></i> <strong>Lokasi:</strong> $Location</p>
                </div>
                <div class="card border-0 bg-light p-4 mb-4">
                    <h3 class="h5 fw-bold mb-3">Deskripsi</h3>
                    <div class="event-description">$Description</div>
                </div>
            <% end_with %>
        </div>

        <!-- Kolom Kanan -->
        <div class="col-lg-5">
            <div class="card shadow sticky-top" style="top: 20px;">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Pilih Tipe Tiket</h4>
                </div>
                <div class="card-body">
                    <% with $Ticket %>
                        <% if $TicketTypes %>
                            <% loop $TicketTypes %>
                                <div class="ticket-type-item p-3 mb-3 border rounded" 
                                     data-ticket-id="$ID" 
                                     data-price="$Price" 
                                     data-max="$MaxPerMember">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h5 class="fw-bold mb-1">$TypeName</h5>
                                            <% if $Description %>
                                                <p class="text-muted small mb-0">$Description</p>
                                            <% end_if %>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                        <span class="fw-bold text-primary fs-5">$FormattedPrice</span>
                                        <button class="btn btn-outline-primary btn-sm select-ticket-btn">
                                            <i class="bi bi-check2-circle"></i> Pilih
                                        </button>
                                    </div>

                                    <!-- Input Quantity (disembunyikan awalnya) -->
                                    <div class="quantity-wrapper mt-3 d-none">
                                        <label class="form-label small mb-1">Jumlah Tiket:</label>
                                        <input type="number" class="form-control form-control-sm quantity-input" value="1" min="1" step="1">
                                        <div class="text-danger small mt-1 d-none quantity-alert">Maksimal <span class="max-limit"></span> tiket per member</div>
                                    </div>
                                </div>
                            <% end_loop %>

                            <div class="mt-4 border-top pt-3">
                                <h5 class="fw-bold mb-2">Total:</h5>
                                <h3 class="fw-bold text-success" id="total-amount">Rp 0</h3>

                                <!-- Tombol beli pakai BaseHref -->
                                <a href="$BaseHref/checkout" 
                                   id="buy-btn"
                                   class="btn btn-success w-100 mt-3 disabled"
                                   aria-disabled="true">
                                    <i class="bi bi-cart-check"></i> Beli Sekarang
                                </a>
                            </div>
                        <% else %>
                            <div class="alert alert-warning" role="alert">
                                <i class="bi bi-exclamation-triangle"></i> Belum ada tipe tiket yang tersedia untuk event ini.
                            </div>
                        <% end_if %>
                    <% end_with %>
                </div>
            </div>
        </div>
    </div>

    <!-- Tombol Kembali -->
    <div class="row mt-4">
        <div class="col-12">
            <a href="$BackLink" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Kembali ke Daftar Event
            </a>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const ticketItems = document.querySelectorAll('.ticket-type-item');
    const totalAmountEl = document.getElementById('total-amount');
    const buyBtn = document.getElementById('buy-btn');

    let selectedTicket = null;

    ticketItems.forEach(item => {
        const selectBtn = item.querySelector('.select-ticket-btn');
        const qtyWrapper = item.querySelector('.quantity-wrapper');
        const qtyInput = item.querySelector('.quantity-input');
        const alertMsg = item.querySelector('.quantity-alert');
        const maxLimit = parseInt(item.dataset.max);
        const price = parseInt(item.dataset.price);

        item.querySelector('.max-limit').textContent = maxLimit;

        selectBtn.addEventListener('click', () => {
            // Reset semua
            ticketItems.forEach(i => {
                i.classList.remove('border-primary');
                i.querySelector('.quantity-wrapper').classList.add('d-none');
                i.querySelector('.select-ticket-btn').classList.remove('btn-primary');
                i.querySelector('.select-ticket-btn').classList.add('btn-outline-primary');
            });

            // Aktifkan yang dipilih
            item.classList.add('border-primary');
            qtyWrapper.classList.remove('d-none');
            selectBtn.classList.add('btn-primary');
            selectBtn.classList.remove('btn-outline-primary');

            selectedTicket = { item, price, maxLimit };
            updateTotal();
        });

        qtyInput.addEventListener('input', () => {
            const val = parseInt(qtyInput.value) || 0;
            if (val > maxLimit) {
                alertMsg.classList.remove('d-none');
                qtyInput.classList.add('is-invalid');
                disableBuy();
            } else {
                alertMsg.classList.add('d-none');
                qtyInput.classList.remove('is-invalid');
                updateTotal();
            }
        });
    });

    function updateTotal() {
        if (!selectedTicket) {
            totalAmountEl.textContent = 'Rp 0';
            disableBuy();
            return;
        }

        const qty = parseInt(selectedTicket.item.querySelector('.quantity-input').value) || 0;
        const total = qty * selectedTicket.price;

        totalAmountEl.textContent = 'Rp ' + total.toLocaleString('id-ID');
        if (qty >= 1 && qty <= selectedTicket.maxLimit) {
            enableBuy();
        } else {
            disableBuy();
        }
    }

    function enableBuy() {
        buyBtn.classList.remove('disabled');
        buyBtn.removeAttribute('aria-disabled');
    }

    function disableBuy() {
        buyBtn.classList.add('disabled');
        buyBtn.setAttribute('aria-disabled', 'true');
    }
});
</script>

<style>
.ticket-type-item {
    transition: all 0.3s ease;
    background: #f8f9fa;
}
.ticket-type-item:hover {
    background: #fff;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    transform: translateX(5px);
}
.ticket-type-item.border-primary {
    box-shadow: 0 0 0 2px #0d6efd !important;
}
</style>
