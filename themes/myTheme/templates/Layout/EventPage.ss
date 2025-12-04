<div class="container">
    <div class="row">
        <!-- Sidebar Filter -->
        <div class="col-lg-3 mb-4">
            <div class="filter-sidebar">
                <h5 class="filter-sidebar-title">FILTER</h5>
                
                <form method="get" action="$Link" id="filter-form">
                    <!-- Price Range Slider -->
                    <div class="filter-group">
                        <label class="filter-group-label">Harga</label>
                        <div class="price-range-display">
                            <span class="price-min-display">Rp <span id="min-price-display">$MinPriceRange</span></span>
                            <span class="price-max-display">Rp <span id="max-price-display">$MaxPriceRange</span></span>
                        </div>
                        <div class="price-slider-container">
                            <input type="range" 
                                   name="min_price" 
                                   id="min-price-slider"
                                   class="price-slider"
                                   min="0" 
                                   max="$MaxPriceRange"
                                   value="$CurrentMinPrice"
                                   step="10000">
                            <input type="range" 
                                   name="max_price" 
                                   id="max-price-slider"
                                   class="price-slider"
                                   min="0" 
                                   max="$MaxPriceRange"
                                   value="<% if $CurrentMaxPrice %>$CurrentMaxPrice<% else %>$MaxPriceRange<% end_if %>"
                                   step="10000">
                        </div>
                    </div>

                    <!-- Province & City -->
                    <div class="row">
                        <div class="col-6">
                            <div class="filter-group">
                                <label class="filter-group-label">Provinsi</label>
                                <select name="province" id="province-filter" class="filter-select-sidebar">
                                    <option value=""></option>
                                    <% loop $ProvinceList %>
                                        <option value="$ID" <% if $Selected %>selected<% end_if %>>$Name</option>
                                    <% end_loop %>
                                </select>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="filter-group">
                                <label class="filter-group-label">Kota</label>
                                <select name="city" id="city-filter" class="filter-select-sidebar"
                                        <% if not $CurrentProvince %>disabled<% end_if %>>
                                    <option value=""></option>
                                    <% loop $CityList %>
                                        <option value="$ID" <% if $Selected %>selected<% end_if %>>$Name</option>
                                    <% end_loop %>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Month & Year -->
                    <div class="row">
                        <div class="col-6">
                            <div class="filter-group">
                                <label class="filter-group-label">Bulan</label>
                                <select name="month" class="filter-select-sidebar">
                                    <option value=""></option>
                                    <% loop $MonthList %>
                                        <option value="$Value" <% if $Selected %>selected<% end_if %>>$Label</option>
                                    <% end_loop %>
                                </select>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="filter-group">
                                <label class="filter-group-label">Tahun</label>
                                <select name="year" class="filter-select-sidebar">
                                    <option value=""></option>
                                    <% loop $YearList %>
                                        <option value="$Value" <% if $Selected %>selected<% end_if %>>$Label</option>
                                    <% end_loop %>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Sort -->
                    <div class="filter-group">
                        <label class="filter-group-label">Urutkan</label>
                        <select name="sort" class="filter-select-sidebar">
                            <option value="date_asc" <% if $CurrentSort == 'date_asc' %>selected<% end_if %>>Tanggal (Terlama)</option>
                            <option value="date_desc" <% if $CurrentSort == 'date_desc' %>selected<% end_if %>>Tanggal (Terbaru)</option>
                            <option value="name_asc" <% if $CurrentSort == 'name_asc' %>selected<% end_if %>>Nama (A-Z)</option>
                            <option value="name_desc" <% if $CurrentSort == 'name_desc' %>selected<% end_if %>>Nama (Z-A)</option>
                            <option value="price_asc" <% if $CurrentSort == 'price_asc' %>selected<% end_if %>>Harga (Termurah)</option>
                            <option value="price_desc" <% if $CurrentSort == 'price_desc' %>selected<% end_if %>>Harga (Termahal)</option>
                        </select>
                    </div>

                    <!-- Action Buttons -->
                    <div class="filter-actions-sidebar">
                        <button type="submit" class="btn-filter-sidebar">
                            <i class="bi bi-funnel"></i> Filter
                        </button>
                        <a href="$Link" class="btn-reset-sidebar">
                            <i class="bi bi-arrow-clockwise"></i> Reset
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-lg-9">
            <!-- Active Filters -->
            <% if $HasActiveFilters %>
                <div class="active-filters-inline mb-3">
                    <span class="active-filter-label-inline">Filter aktif:</span>
                    <% if $CurrentYear %>
                        <span class="active-filter-tag-inline">
                            Tahun: $CurrentYear
                            <a href="$LinkWithoutFilter('year')" class="remove-filter-inline">×</a>
                        </span>
                    <% end_if %>
                    <% if $CurrentMaxPrice %>
                        <span class="active-filter-tag-inline">
                            Max: Rp {$CurrentMaxPrice.Nice}
                            <a href="$LinkWithoutFilter('max_price')" class="remove-filter-inline">×</a>
                        </span>
                    <% end_if %>
                    <% if $CurrentProvinceName %>
                        <span class="active-filter-tag-inline">
                            Provinsi: $CurrentProvinceName
                            <a href="$LinkWithoutFilter('province')" class="remove-filter-inline">×</a>
                        </span>
                    <% end_if %>
                    <% if $CurrentCityName %>
                        <span class="active-filter-tag-inline">
                            Kota: $CurrentCityName
                            <a href="$LinkWithoutFilter('city')" class="remove-filter-inline">×</a>
                        </span>
                    <% end_if %>
                    <% if $CurrentMonth %>
                        <span class="active-filter-tag-inline">
                            Bulan: $CurrentMonthName
                            <a href="$LinkWithoutFilter('month')" class="remove-filter-inline">×</a>
                        </span>
                    <% end_if %>
                    <% if $CurrentMinPrice %>
                        <span class="active-filter-tag-inline">
                            Min: Rp {$CurrentMinPrice.Nice}
                            <a href="$LinkWithoutFilter('min_price')" class="remove-filter-inline">×</a>
                        </span>
                    <% end_if %>
                </div>
            <% end_if %>

            <!-- Results Count -->
            <div class="results-count mb-3">
                Menampilkan <strong>$Tickets.Count</strong> event
            </div>

            <!-- Tickets Grid -->
            <% if $Tickets.Count > 0 %>
                <div class="row g-3">
                    <% loop $Tickets %>
                        <div class="col-md-6 col-lg-4">
                            <div class="ticket-card-sidebar <% if $IsExpired %>ticket-expired<% end_if %>">
                                <a href="$Link" class="ticket-img-link">
                                    <div class="ticket-img-wrapper">
                                        <img src="$Image.URL" class="ticket-img-sidebar" alt="$Title">
                                        
                                        <!-- Badge Status -->
                                        <% if $IsExpired %>
                                            <span class="ticket-status-badge expired">
                                                <i class="bi bi-x-circle"></i> BERAKHIR
                                            </span>
                                       
                                        <% end_if %>
                                    </div>
                                </a>
                                <div class="ticket-body-sidebar">
                                    <h6 class="ticket-title-sidebar">
                                        <a href="$Link">$Title</a>
                                    </h6>
                                    <p class="ticket-date-sidebar">
                                        <i class="bi bi-calendar3" style="color: #7B68EE;"></i> $EventDate.Nice
                                    </p>
                                    <p class="ticket-location-sidebar">
                                        <i class="bi bi-geo-alt" style="color: #7B68EE;"></i> $Location
                                    </p>
                                    <div class="ticket-footer-sidebar">
                                        <% if $IsExpired %>
                                            <span class="ticket-price-sidebar expired-price">
                                                BERAKHIR
                                            </span>
                                        <% else %>
                                            <span class="ticket-price-sidebar">$PriceLabel</span>
                                        <% end_if %>
                                        
                                        <% if $Top.IsLoggedIn %>
                                            <% if $canBeOrdered %>
                                                <% if $IsInWishlist %>
                                                    <a href="$BaseHref/wishlist/toggle/$ID" 
                                                       class="wishlist-icon-sidebar active"
                                                       title="Hapus dari wishlist">
                                                        <i class="bi bi-heart-fill"></i>
                                                    </a>
                                                <% else %>
                                                    <a href="$BaseHref/wishlist/toggle/$ID" 
                                                       class="wishlist-icon-sidebar"
                                                       title="Tambah ke wishlist">
                                                        <i class="bi bi-heart"></i>
                                                    </a>
                                                <% end_if %>
                                            <% else %>
                                                <span class="wishlist-icon-sidebar disabled" title="Event berakhir">
                                                    <i class="bi bi-heart"></i>
                                                </span>
                                            <% end_if %>
                                        <% else %>
                                            <a href="$BaseHref/auth/login" 
                                               class="wishlist-icon-sidebar"
                                               title="Login untuk wishlist">
                                                <i class="bi bi-heart"></i>
                                            </a>
                                        <% end_if %>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% end_loop %>
                </div>
            <% else %>
                <div class="empty-state-sidebar">
                    <div class="empty-state-icon">
                        <i class="bi bi-ticket-perforated"></i>
                    </div>
                    <h3 class="empty-state-title">Tidak ada event yang ditemukan</h3>
                    <p class="empty-state-text">
                        Coba ubah filter atau <a href="$Link">lihat semua event</a>
                    </p>
                </div>
            <% end_if %>
        </div>
    </div>
</div>

<script>
// Dynamic city dropdown
document.addEventListener('DOMContentLoaded', function() {
    const provinceFilter = document.getElementById('province-filter');
    const cityFilter = document.getElementById('city-filter');
    
    if (provinceFilter && cityFilter) {
        provinceFilter.addEventListener('change', function() {
            const provinceId = this.value;
            
            cityFilter.innerHTML = '<option value="">Loading...</option>';
            cityFilter.disabled = true;
            
            if (!provinceId) {
                cityFilter.innerHTML = '<option value=""></option>';
                return;
            }
            
            fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${provinceId}.json`)
                .then(response => response.json())
                .then(data => {
                    cityFilter.innerHTML = '<option value=""></option>';
                    data.forEach(city => {
                        const option = document.createElement('option');
                        option.value = city.id;
                        option.textContent = city.name;
                        cityFilter.appendChild(option);
                    });
                    cityFilter.disabled = false;
                })
                .catch(error => {
                    console.error('Error:', error);
                    cityFilter.innerHTML = '<option value="">Error</option>';
                });
        });
    }

    // Price Range Slider
    const minSlider = document.getElementById('min-price-slider');
    const maxSlider = document.getElementById('max-price-slider');
    const minDisplay = document.getElementById('min-price-display');
    const maxDisplay = document.getElementById('max-price-display');
    
    if (minSlider && maxSlider) {
        function formatPrice(price) {
            return parseInt(price).toLocaleString('id-ID');
        }
        
        function updatePriceDisplay() {
            let minVal = parseInt(minSlider.value);
            let maxVal = parseInt(maxSlider.value);
            
            if (minVal > maxVal) {
                [minVal, maxVal] = [maxVal, minVal];
                minSlider.value = minVal;
                maxSlider.value = maxVal;
            }
            
            minDisplay.textContent = formatPrice(minVal);
            maxDisplay.textContent = formatPrice(maxVal);
        }
        
        minSlider.addEventListener('input', updatePriceDisplay);
        maxSlider.addEventListener('input', updatePriceDisplay);
        
        updatePriceDisplay();
    }
});
</script>

<style>
/* Sidebar Filter Styles */
.filter-sidebar {
    background: linear-gradient(135deg, #e3d5ff 0%, #d4c5f9 80%);
    border-radius: 20px;
    padding: 24px;
    position: sticky;
    top: 20px;
}

.filter-sidebar-title {
    font-size: 18px;
    font-weight: 700;
    color: #333;
    margin-bottom: 20px;
    letter-spacing: 1px;
}

.filter-group {
    margin-bottom: 20px;
}

.filter-group-label {
    display: block;
    font-size: 13px;
    font-weight: 600;
    color: #333;
    margin-bottom: 8px;
}

.filter-select-sidebar {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid rgba(0,0,0,0.1);
    border-radius: 8px;
    background: #fff;
    font-size: 14px;
    color: #333;
    transition: all 0.2s;
}

.filter-select-sidebar:focus {
    outline: none;
    border-color: #a87af8ff;
    box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.1);
}

.filter-select-sidebar:disabled {
    background: #f5f5f5;
    cursor: not-allowed;
}

/* Price Range Slider */
.price-range-display {
    display: flex;
    justify-content: space-between;
    margin-bottom: 12px;
    font-size: 13px;
    font-weight: 600;
    color: #333;
}

.price-slider-container {
    position: relative;
    height: 40px;
}

.price-slider {
    position: absolute;
    width: 100%;
    height: 6px;
    -webkit-appearance: none;
    background: transparent;
    pointer-events: none;
}

.price-slider::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: #7c3aed;
    cursor: pointer;
    pointer-events: all;
    border: 3px solid #fff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.price-slider::-moz-range-thumb {
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: #7c3aed;
    cursor: pointer;
    pointer-events: all;
    border: 3px solid #fff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.price-slider::-webkit-slider-runnable-track {
    width: 100%;
    height: 6px;
    background: #fff;
    border-radius: 3px;
}

.price-slider::-moz-range-track {
    width: 100%;
    height: 6px;
    background: #fff;
    border-radius: 3px;
}

/* Action Buttons */
.filter-actions-sidebar {
    display: flex;
    gap: 10px;
    margin-top: 24px;
}

.btn-filter-sidebar,
.btn-reset-sidebar {
    flex: 1;
    padding: 12px;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 600;
    text-align: center;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    transition: all 0.2s;
    border: none;
    cursor: pointer;
}

.btn-filter-sidebar {
    background: #7c3aed;
    color: #fff;
}

.btn-filter-sidebar:hover {
    background: #6d28d9;
    transform: translateY(-2px);
}

.btn-reset-sidebar {
    background: #fff;
    color: #7c3aed;
    border: 2px solid #7c3aed;
}

.btn-reset-sidebar:hover {
    background: #f5f3ff;
}

/* Active Filters Inline */
.active-filters-inline {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    align-items: center;
    padding: 12px 16px;
    background: #f9fafb;
    border-radius: 10px;
}

.active-filter-label-inline {
    font-size: 14px;
    font-weight: 600;
    color: #666;
}

.active-filter-tag-inline {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    background: #fff;
    border: 1px solid #e5e7eb;
    border-radius: 20px;
    font-size: 13px;
    color: #333;
}

.remove-filter-inline {
    color: #999;
    font-size: 18px;
    line-height: 1;
    text-decoration: none;
    transition: color 0.2s;
}

.remove-filter-inline:hover {
    color: #ef4444;
}

/* Results Count */
.results-count {
    font-size: 14px;
    color: #666;
}

/* Ticket Cards */
.ticket-card-sidebar {
    background: #fff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: all 0.25s;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.ticket-card-sidebar:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.12);
}

/* Expired Ticket Styling */
.ticket-card-sidebar.ticket-expired {
    opacity: 0.75;
}

.ticket-card-sidebar.ticket-expired:hover {
    transform: translateY(-2px);
}

.ticket-img-link {
    display: block;
    position: relative;
}

.ticket-img-wrapper {
    position: relative;
    overflow: hidden;
}

.ticket-img-sidebar {
    width: 100%;
    height: 180px;
    object-fit: cover;
    transition: transform 0.3s;
}

.ticket-card-sidebar:hover .ticket-img-sidebar {
    transform: scale(1.05);
}

/* Status Badge */
.ticket-status-badge {
    position: absolute;
    top: 12px;
    right: 12px;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.5px;
    display: inline-flex;
    align-items: center;
    gap: 4px;
    backdrop-filter: blur(8px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.15);
    z-index: 10;
}

.ticket-status-badge.expired {
    background: rgba(239, 68, 68, 0.95);
    color: #fff;
}

.ticket-status-badge.available {
    background: rgba(34, 197, 94, 0.95);
    color: #fff;
}

.ticket-body-sidebar {
    padding: 16px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.ticket-title-sidebar {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 8px;
    line-height: 1.3;
}

.ticket-title-sidebar a {
    color: #1f2937;
    text-decoration: none;
}

.ticket-title-sidebar a:hover {
    color: #7c3aed;
}

.ticket-date-sidebar,
.ticket-location-sidebar {
    font-size: 13px;
    color: #6b7280;
    margin-bottom: 6px;
    display: flex;
    align-items: center;
    gap: 6px;
}

.ticket-footer-sidebar {
    border-top: 1px solid #f3f4f6;
    padding-top: 12px;
    margin-top: auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.ticket-price-sidebar {
    font-size: 16px;
    font-weight: 700;
    color: #1f2937;
}

.ticket-price-sidebar.expired-price {
    color: #ef4444;
    font-size: 14px;
}

.wishlist-icon-sidebar {
    font-size: 20px;
    color: #d1d5db;
    text-decoration: none;
    transition: all 0.2s;
}

.wishlist-icon-sidebar:hover {
    color: #ef4444;
    transform: scale(1.1);
}

.wishlist-icon-sidebar.active {
    color: #ef4444;
}

.wishlist-icon-sidebar.disabled {
    color: #e5e7eb;
    cursor: not-allowed;
    pointer-events: none;
}

/* Empty State */
.empty-state-sidebar {
    text-align: center;
    padding: 60px 20px;
}

.empty-state-icon {
    font-size: 64px;
    color: #e5e7eb;
    margin-bottom: 16px;
}

.empty-state-title {
    font-size: 20px;
    font-weight: 600;
    color: #374151;
    margin-bottom: 8px;
}

.empty-state-text {
    font-size: 15px;
    color: #6b7280;
}

.empty-state-text a {
    color: #7c3aed;
    text-decoration: none;
    font-weight: 600;
}

.empty-state-text a:hover {
    text-decoration: underline;
}

/* Responsive */
@media (max-width: 991px) {
    .filter-sidebar {
        position: static;
        margin-bottom: 20px;
    }
}
</style>