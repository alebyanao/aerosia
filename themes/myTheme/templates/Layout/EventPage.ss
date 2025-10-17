
<div class="container my-5">
    <h1 class="mb-4">Daftar Event Tersedia</h1>
    
    <div class="row g-4">
        <% loop $Tickets %>
            <div class="col-12 col-md-4">
                <div class="card h-100 shadow-sm hover-card">
                    <% if $Image %>
                        <img src="$Image.URL" class="card-img-top" alt="$Title" style="height: 200px; object-fit: cover;">
                    <% end_if %>
                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title fw-bold">$Title</h5>
                        <p class="card-text text-muted mb-1">
                            <i class="bi bi-calendar-event"></i> $EventDate.Nice
                        </p>
                        <p class="card-text text-muted mb-3">
                            <i class="bi bi-geo-alt"></i> $Location
                        </p>
                        
                        <% if $TicketTypes.Count > 0 %>
                            <div class="mt-auto">
                                <p class="fw-bold text-primary fs-5 mb-3">
                                    $PriceLabel
                                     <% if $Price == 0 %>
                                                    <span class="badge bg-success ms-2">GRATIS</span>
                                                <% end_if %>
                                </p>
                                <%-- <a href="$Link" class="btn btn-primary w-100">
                                    Lihat Detail & Pilih Tiket
                                </a> --%>
                                <div class="d-flex gap-2 mt-auto">
    <a href="$Link" class="btn btn-primary flex-fill">
        <i class="bi bi-ticket-perforated"></i> Detail
    </a>

    <% if $Top.CurrentUser %>
        <% if $Top.CurrentUser.Wishlists.Filter('TicketID', $ID).Count > 0 %>
            <!-- Jika tiket ini sudah ada di wishlist -->
            <a href="$Top.Link(remove)/{$Top.CurrentUser.Wishlists.Filter('TicketID', $ID).First.ID}" 
               class="btn btn-outline-danger flex-fill">
                <i class="bi bi-heart-fill"></i> Hapus
            </a>
        <% else %>
            <!-- Jika belum ada di wishlist -->
            <a href="$BaseHref/wishlist/add/$ID" 
               class="btn btn-outline-secondary flex-fill">
                <i class="bi bi-heart"></i> Wishlist
            </a>
        <% end_if %>
    <% else %>
        <!-- Jika belum login -->
        <a href="{$BaseURL}auth/login" class="btn btn-outline-secondary flex-fill">
            <i class="bi bi-heart"></i> Wishlist
        </a>
    <% end_if %>
</div>

                            </div>
                        <% else %>
                            <div class="mt-auto">
                                <p class="text-warning mb-0">
                                    <i class="bi bi-exclamation-circle"></i> Harga belum tersedia
                                </p>
                            </div>
                        <% end_if %>
                    </div>
                </div>
            </div>
        <% end_loop %>
    </div>
</div>

<style>
.hover-card {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.hover-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.2) !important;
}
</style>