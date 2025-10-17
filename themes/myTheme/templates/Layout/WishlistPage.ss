<div class="container my-5">
    <div class="text-center mb-5">
        <h1 class="fw-bold mb-3">Wishlist Saya</h1>
        <p class="text-muted">Berikut adalah tiket/event yang kamu simpan untuk dilihat nanti.</p>
    </div>

    <% if $Wishlists.Count > 0 %>
        <div class="row g-4">
            <% loop $Wishlists %>
                <% with $Ticket %>
                    <div class="col-12 col-md-4 col-lg-3">
                        <div class="card h-100 shadow-sm border-0 hover-card">
                            <% if $Image %>
                                <img src="$Image.URL" class="card-img-top" alt="$Title" style="height: 180px; object-fit: cover;">
                            <% else %>
                                <div class="bg-light d-flex align-items-center justify-content-center" style="height: 180px;">
                                    <i class="bi bi-image text-secondary fs-1"></i>
                                </div>
                            <% end_if %>

                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title fw-bold text-truncate">$Title</h5>
                                <p class="card-text text-muted mb-1">
                                    <i class="bi bi-calendar-event"></i> $EventDate.Nice
                                </p>
                                <p class="card-text text-muted mb-3">
                                    <i class="bi bi-geo-alt"></i> $Location
                                </p>

                                <div class="mt-auto">
                                    <p class="fw-semibold text-primary mb-3">$PriceLabel</p>
                                    <div class="d-grid gap-2">
                                        <a href="$Link" class="btn btn-outline-primary btn-sm">
                                            <i class="bi bi-ticket-detailed"></i> Lihat Tiket
                                        </a>
                                        <a href="$Top.Link(remove)/$Up.ID" class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-trash"></i> Hapus
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                <% end_with %>
            <% end_loop %>
        </div>
    <% else %>
        <div class="text-center py-5">
            <i class="bi bi-heart text-danger display-4"></i>
            <h4 class="mt-3">Belum ada wishlist</h4>
            <p class="text-muted">Kamu belum menambahkan event atau tiket apa pun ke wishlist.</p>
            <a href="{$BaseURL}event" class="btn btn-primary mt-2">
                <i class="bi bi-search"></i> Jelajahi Event
            </a>
        </div>
    <% end_if %>
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
