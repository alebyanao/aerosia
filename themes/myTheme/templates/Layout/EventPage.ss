<div class="container py-4">
    <!-- Filter Section -->
    <div class="filter-section-modern">
        <form method="get" action="$Link" class="filter-form-modern" id="filter-form">
            <div class="filter-row-modern">
                <!-- Province Filter -->
                <div class="filter-item-modern">
                    <label class="filter-label-modern">Provinsi</label>
                    <select name="province" id="province-filter" class="filter-select-modern">
                        <option value="">Semua Provinsi</option>
                        <% loop $ProvinceList %>
                            <option value="$ID" <% if $Selected %>selected<% end_if %>>$Name</option>
                        <% end_loop %>
                    </select>
                </div>
                
                <!-- City Filter -->
                <div class="filter-item-modern">
                    <label class="filter-label-modern">Kota/Kabupaten</label>
                    <select name="city" id="city-filter" class="filter-select-modern" 
                            <% if not $CurrentProvince %>disabled<% end_if %>>
                        <option value="">
                            <% if $CurrentProvince %>Semua Kota<% else %>Pilih Provinsi Dulu<% end_if %>
                        </option>
                        <% loop $CityList %>
                            <option value="$ID" <% if $Selected %>selected<% end_if %>>$Name</option>
                        <% end_loop %>
                    </select>
                </div>

                <!-- Month Filter -->
                <div class="filter-item-modern">
                    <label class="filter-label-modern">Bulan</label>
                    <select name="month" class="filter-select-modern">
                        <option value="">Semua Bulan</option>
                        <% loop $MonthList %>
                            <option value="$Value" <% if $Selected %>selected<% end_if %>>$Label</option>
                        <% end_loop %>
                    </select>
                </div>

                <!-- Year Filter -->
                <div class="filter-item-modern">
                    <label class="filter-label-modern">Tahun</label>
                    <select name="year" class="filter-select-modern">
                        <option value="">Semua Tahun</option>
                        <% loop $YearList %>
                            <option value="$Value" <% if $Selected %>selected<% end_if %>>$Label</option>
                        <% end_loop %>
                    </select>
                </div>
            </div>

            <div class="filter-row-modern mt-3">
                <!-- Min Price -->
                <div class="filter-item-modern">
                    <label class="filter-label-modern">Harga Minimal</label>
                    <input type="number" 
                           name="min_price" 
                           class="filter-input-modern" 
                           placeholder="Rp 0"
                           value="$CurrentMinPrice"
                           min="0">
                </div>

                <!-- Max Price -->
                <div class="filter-item-modern">
                    <label class="filter-label-modern">Harga Maksimal</label>
                    <input type="number" 
                           name="max_price" 
                           class="filter-input-modern" 
                           placeholder="Rp 1.000.000"
                           value="$CurrentMaxPrice"
                           min="0">
                </div>

                <!-- Sort By -->
                <div class="filter-item-modern">
                    <label class="filter-label-modern">Urutkan</label>
                    <select name="sort" class="filter-select-modern">
                        <option value="date_asc" <% if $CurrentSort == 'date_asc' %>selected<% end_if %>>
                            Tanggal (Terlama)
                        </option>
                        <option value="date_desc" <% if $CurrentSort == 'date_desc' %>selected<% end_if %>>
                            Tanggal (Terbaru)
                        </option>
                        <option value="name_asc" <% if $CurrentSort == 'name_asc' %>selected<% end_if %>>
                            Nama (A-Z)
                        </option>
                        <option value="name_desc" <% if $CurrentSort == 'name_desc' %>selected<% end_if %>>
                            Nama (Z-A)
                        </option>
                        <option value="price_asc" <% if $CurrentSort == 'price_asc' %>selected<% end_if %>>
                            Harga (Termurah)
                        </option>
                        <option value="price_desc" <% if $CurrentSort == 'price_desc' %>selected<% end_if %>>
                            Harga (Termahal)
                        </option>
                    </select>
                </div>
                
                <!-- Action Buttons -->
                <div class="filter-actions-modern">
                    <button type="submit" class="btn-filter-modern">
                        <i class="bi bi-funnel"></i> Filter
                    </button>
                    <a href="$Link" class="btn-reset-modern">
                        <i class="bi bi-arrow-clockwise"></i> Reset
                    </a>
                </div>
            </div>
        </form>
    </div>

    <!-- Active Filters Display -->
    <% if $HasActiveFilters %>
        <div class="active-filters-modern mb-3">
            <span class="active-filter-label">Filter aktif:</span>
            <% if $CurrentProvinceName %>
                <span class="active-filter-tag">
                    Provinsi: $CurrentProvinceName
                    <a href="$LinkWithoutFilter('province')" class="remove-filter">×</a>
                </span>
            <% end_if %>
            <% if $CurrentCityName %>
                <span class="active-filter-tag">
                    Kota: $CurrentCityName
                    <a href="$LinkWithoutFilter('city')" class="remove-filter">×</a>
                </span>
            <% end_if %>
            <% if $CurrentMonth %>
                <span class="active-filter-tag">
                    Bulan: $CurrentMonthName
                    <a href="$LinkWithoutFilter('month')" class="remove-filter">×</a>
                </span>
            <% end_if %>
            <% if $CurrentYear %>
                <span class="active-filter-tag">
                    Tahun: $CurrentYear
                    <a href="$LinkWithoutFilter('year')" class="remove-filter">×</a>
                </span>
            <% end_if %>
            <% if $CurrentMinPrice %>
                <span class="active-filter-tag">
                    Min: Rp {$CurrentMinPrice.Nice}
                    <a href="$LinkWithoutFilter('min_price')" class="remove-filter">×</a>
                </span>
            <% end_if %>
            <% if $CurrentMaxPrice %>
                <span class="active-filter-tag">
                    Max: Rp {$CurrentMaxPrice.Nice}
                    <a href="$LinkWithoutFilter('max_price')" class="remove-filter">×</a>
                </span>
            <% end_if %>
        </div>
    <% end_if %>

    <!-- Tickets Grid -->
    <% if $Tickets.Count > 0 %>
        <div class="mb-3 text-muted">
            Menampilkan $Tickets.Count event
        </div>
        <div class="row g-2 g-md-3">
            <% loop $Tickets %>
                <div class="col-6 col-lg-3">
                    <div class="ticket-card-modern">
                        <a href="$Link">
                            <img src="$Image.URL" class="ticket-img-modern" alt="$Title">
                        </a>
                        <div class="ticket-body-modern">
                            <a href="$Link" class="ticket-title-modern">
                                $Title
                            </a>
                            <p class="ticket-date-modern">$EventDate.Nice</p>
                            <p class="ticket-location-modern">
                                $Location
                            </p>
                            <div class="ticket-footer-modern">
                                <span class="ticket-price-modern">$PriceLabel</span>
                                
                                <% if $Top.IsLoggedIn %>
                                    <% if $IsInWishlist %>
                                        <a href="$BaseHref/wishlist/toggle/$ID" 
                                           class="wishlist-icon-modern active"
                                           title="Hapus dari wishlist">
                                            <i class="bi bi-heart-fill"></i>
                                        </a>
                                    <% else %>
                                        <a href="$BaseHref/wishlist/toggle/$ID" 
                                           class="wishlist-icon-modern"
                                           title="Tambah ke wishlist">
                                            <i class="bi bi-heart"></i>
                                        </a>
                                    <% end_if %>
                                <% else %>
                                    <a href="$BaseHref/auth/login" 
                                       class="wishlist-icon-modern"
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
        <!-- Empty State -->
        <div class="empty-state-modern">
            <div class="empty-state-icon">
                <i class="bi bi-ticket-perforated"></i>
            </div>
            <h3 class="empty-state-title">
                Tidak ada event yang ditemukan
            </h3>
            <p class="empty-state-text">
                Coba ubah filter atau <a href="$Link">lihat semua event</a>
            </p>
        </div>
    <% end_if %>
</div>

<script>
// Dynamic city dropdown di frontend
document.addEventListener('DOMContentLoaded', function() {
    const provinceFilter = document.getElementById('province-filter');
    const cityFilter = document.getElementById('city-filter');
    
    if (!provinceFilter || !cityFilter) return;
    
    // Load cities when province changes
    provinceFilter.addEventListener('change', function() {
        const provinceId = this.value;
        
        // Reset city dropdown
        cityFilter.innerHTML = '<option value="">Loading...</option>';
        cityFilter.disabled = true;
        
        if (!provinceId) {
            cityFilter.innerHTML = '<option value="">Pilih Provinsi Dulu</option>';
            return;
        }
        
        // Fetch cities from API
        fetch(`https://www.emsifa.com/api-wilayah-indonesia/api/regencies/${provinceId}.json`)
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                cityFilter.innerHTML = '<option value="">Semua Kota</option>';
                
                data.forEach(city => {
                    const option = document.createElement('option');
                    option.value = city.id;
                    option.textContent = city.name;
                    cityFilter.appendChild(option);
                });
                
                cityFilter.disabled = false;
            })
            .catch(error => {
                console.error('Error loading cities:', error);
                cityFilter.innerHTML = '<option value="">Error loading cities</option>';
                alert('Gagal memuat data kota. Silakan refresh halaman atau coba lagi nanti.');
            });
    });
});
</script>

<style>
/* --- FILTER STYLES --- */
.filter-section-modern {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 16px;
    padding: 20px;
    margin-bottom: 24px;
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.filter-form-modern {
    width: 100%;
}

.filter-row-modern {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    align-items: flex-end;
}

.filter-item-modern {
    flex: 1;
    min-width: 180px;
}

.filter-label-modern {
    display: block;
    color: #fff;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 6px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.filter-select-modern,
.filter-input-modern {
    width: 100%;
    padding: 10px 14px;
    border: 2px solid rgba(255,255,255,0.3);
    border-radius: 8px;
    background: rgba(255,255,255,0.95);
    font-size: 14px;
    transition: all 0.3s ease;
    color: #333;
}

.filter-select-modern:focus,
.filter-input-modern:focus {
    outline: none;
    border-color: #fff;
    background: #fff;
    box-shadow: 0 0 0 3px rgba(255,255,255,0.2);
}

.filter-select-modern:disabled {
    background: rgba(255,255,255,0.5);
    cursor: not-allowed;
    color: #999;
}

.filter-actions-modern {
    display: flex;
    gap: 8px;
    align-items: flex-end;
}

.btn-filter-modern,
.btn-reset-modern {
    padding: 10px 20px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    transition: all 0.3s ease;
    border: none;
    cursor: pointer;
    white-space: nowrap;
}

.btn-filter-modern {
    background: #fff;
    color: #667eea;
}

.btn-filter-modern:hover {
    background: #f0f0f0;
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.btn-reset-modern {
    background: rgba(255,255,255,0.2);
    color: #fff;
    border: 2px solid rgba(255,255,255,0.5);
}

.btn-reset-modern:hover {
    background: rgba(255,255,255,0.3);
    border-color: #fff;
}

/* --- ACTIVE FILTERS --- */
.active-filters-modern {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    align-items: center;
}

.active-filter-label {
    font-size: 14px;
    font-weight: 600;
    color: #666;
}

.active-filter-tag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    background: #f0f0f0;
    border-radius: 20px;
    font-size: 13px;
    color: #333;
}

.remove-filter {
    color: #999;
    font-size: 18px;
    line-height: 1;
    text-decoration: none;
    transition: color 0.2s;
}

.remove-filter:hover {
    color: #ff4444;
}

/* --- CARD STYLES --- */
.ticket-card-modern {
    background: #fff;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: .25s ease;
    height: 100%;
    display: flex;
    flex-direction: column;
}

.ticket-card-modern:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.12);
}

.ticket-img-modern {
    height: 120px;
    width: 100%;
    object-fit: cover;
}

.ticket-body-modern {
    padding: 10px 12px 12px 12px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}

.ticket-title-modern {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #000;
    text-decoration: none;
    margin-bottom: 4px;
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

.ticket-title-modern:hover {
    color: #7b2ddf;
}

.ticket-date-modern {
    font-size: 12px;
    color: #7a7a7a;
    margin: 0 0 2px 0;
}

.ticket-location-modern {
    font-size: 12px;
    color: #7a7a7a;
    margin-bottom: 10px;
    line-height: 1.3;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.ticket-footer-modern {
    border-top: 1px solid #eaeaea;
    padding-top: 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: auto;
}

.ticket-price-modern {
    font-size: 14px;
    font-weight: 700;
    color: #000 !important;
}

.wishlist-icon-modern {
    font-size: 18px;
    color: #ccc;
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
    text-decoration: none;
    transition: all .3s ease;
    display: inline-flex;
    align-items: center;
    justify-content: center;
}

.wishlist-icon-modern:hover {
    color: #ff4466;
    transform: scale(1.1);
}

.wishlist-icon-modern.active {
    color: #ff0033 !important;
}

.wishlist-icon-modern.active:hover {
    color: #cc0028 !important;
}

/* --- EMPTY STATE --- */
.empty-state-modern {
    text-align: center;
    padding: 60px 20px;
}

.empty-state-icon {
    font-size: 64px;
    color: #ddd;
    margin-bottom: 16px;
}

.empty-state-title {
    font-size: 20px;
    font-weight: 600;
    color: #333;
    margin-bottom: 8px;
}

.empty-state-text {
    font-size: 15px;
    color: #666;
}

.empty-state-text a {
    color: #667eea;
    text-decoration: none;
    font-weight: 600;
}

.empty-state-text a:hover {
    text-decoration: underline;
}

/* --- RESPONSIVE --- */
@media (max-width: 767px) {
    .filter-row-modern {
        flex-direction: column;
    }
    
    .filter-item-modern {
        width: 100%;
        min-width: 100%;
    }
    
    .filter-actions-modern {
        width: 100%;
    }
    
    .btn-filter-modern,
    .btn-reset-modern {
        flex: 1;
        justify-content: center;
    }
    
    .filter-section-modern {
        padding: 16px;
    }
    
    .empty-state-modern {
        padding: 40px 20px;
    }
    
    .empty-state-icon {
        font-size: 48px;
    }
    
    .empty-state-title {
        font-size: 18px;
    }
    
    .empty-state-text {
        font-size: 14px;
    }
}

@media (min-width: 768px) {
    .ticket-img-modern {
        height: 140px;
    }
    
    .ticket-title-modern {
        font-size: 15px;
    }
    
    .ticket-date-modern,
    .ticket-location-modern {
        font-size: 13px;
    }
    
    .ticket-price-modern {
        font-size: 15px;
    }
    
    .filter-actions-modern {
        flex-shrink: 0;
    }
}

@media (min-width: 992px) {
    .ticket-body-modern {
        padding: 12px 14px 14px 14px;
    }
    
    .filter-section-modern {
        padding: 24px;
    }
}
</style>