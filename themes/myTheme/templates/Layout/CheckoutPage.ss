<main class="checkout-page py-5">
  <div class="container my-5">
    <div class="row g-5 align-items-start">
      <!-- Ringkasan Pembelian -->
      <div class="col-md-6 order-md-2">
        <div class="card border-0 shadow-sm p-4 h-100">
          <h3 class="fw-bold mb-3">
            <i class="bi bi-ticket-detailed me-2"></i> Ringkasan Pembelian
          </h3>
          <div>
            <h5 class="mb-1">$TicketType.TypeName</h5>
            <p class="text-muted mb-1">$TicketType.Description</p>
            <p class="mb-0"><strong>Harga:</strong> $TicketType.FormattedPrice</p>
            <p class="mb-0"><strong>Jumlah:</strong> $Quantity</p>
            <h4 class="mt-3 text-success fw-bold">$FormattedTotal</h4>
          </div>
        </div>
      </div>

      <!-- Data Pemesan -->
      <div class="col-md-6">
        <div class="card border-0 shadow-sm p-4 h-100">
          <h3 class="fw-bold mb-4">
            <i class="bi bi-person-circle me-2"></i> Data Pemesan
          </h3>

          <form method="post" action="/checkout/processOrder" id="checkoutForm">
            <div class="form-check mb-4">
              <input class="form-check-input" type="checkbox" id="useProfile" name="use_profile" checked>
              <label class="form-check-label fw-semibold" for="useProfile">
                Gunakan data dari profil saya
              </label>
            </div>

            <div class="mb-3">
            <label for="FullName" class="form-label">Nama Lengkap</label>
            <input type="text" class="form-control" id="FullName" name="FullName"
                    value="$CurrentUser.FirstName $CurrentUser.Surname"
                    data-profile-value="$CurrentUser.FirstName $CurrentUser.Surname"
                    required>
            </div>

            <div class="mb-3">
            <label for="Email" class="form-label">Email</label>
            <input type="email" class="form-control" id="Email" name="Email"
                    value="$CurrentUser.Email"
                    data-profile-value="$CurrentUser.Email"
                    required>
            </div>

            <div class="mb-3">
            <label for="Phone" class="form-label">No. Telepon</label>
            <input type="text" class="form-control" id="Phone" name="Phone"
                    value="$CurrentUser.Phone"
                    data-profile-value="$CurrentUser.Phone"
                    required>
            </div>
            <div class="mt-4">
              <button type="submit" class="btn btn-primary w-100 py-2">
                <i class="bi bi-credit-card me-2"></i> Lanjut ke Pembayaran
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
  const useProfile = document.getElementById('useProfile');
  const inputs = {
    FullName: document.getElementById('FullName'),
    Email: document.getElementById('Email'),
    Phone: document.getElementById('Phone')
  };

  // Ambil nilai profil dari atribut data-profile-value
  const profileValues = {
    FullName: inputs.FullName?.getAttribute('data-profile-value') || '',
    Email: inputs.Email?.getAttribute('data-profile-value') || '',
    Phone: inputs.Phone?.getAttribute('data-profile-value') || ''
  };

  // Simpan manual values ketika user beralih ke profile (biar bisa restore saat uncheck)
  let manualValues = {
    FullName: inputs.FullName.value || '',
    Email: inputs.Email.value || '',
    Phone: inputs.Phone.value || ''
  };

  // Fungsi toggle: jika pakai profile -> isi dengan profileValues dan lock field.
  // jika tidak pakai -> isi dengan manualValues (jika ada) dan unlock field.
  function applyUseProfile(use) {
    if (use) {
      // simpan current manual sebelum overwrite (jika belum disimpan)
      manualValues.FullName = manualValues.FullName || inputs.FullName.value;
      manualValues.Email = manualValues.Email || inputs.Email.value;
      manualValues.Phone = manualValues.Phone || inputs.Phone.value;

      // set nilai profile
      inputs.FullName.value = profileValues.FullName;
      inputs.Email.value = profileValues.Email;
      inputs.Phone.value = profileValues.Phone;

      // readonly agar user tidak bisa ubah; tapi tetap submit
      inputs.FullName.readOnly = true;
      inputs.Email.readOnly = true;
      inputs.Phone.readOnly = false;

      // beri kelas visual agar terlihat disabled (opsional)
      inputs.FullName.classList.add('bg-light');
      inputs.Email.classList.add('bg-light');
      inputs.Phone.classList.add('bg-light');
    } else {
      // restore manual values (jika user sebelumnya mengisi manual)
      inputs.FullName.value = manualValues.FullName || '';
      inputs.Email.value = manualValues.Email || '';
      inputs.Phone.value = manualValues.Phone || '';

      // unlock field untuk diubah
      inputs.FullName.readOnly = false;
      inputs.Email.readOnly = false;
      inputs.Phone.readOnly = false;

      inputs.FullName.classList.remove('bg-light');
      inputs.Email.classList.remove('bg-light');
      inputs.Phone.classList.remove('bg-light');
    }
  }

  // Saat user mengetik manual, update manualValues
  Object.keys(inputs).forEach(key => {
    inputs[key].addEventListener('input', (e) => {
      // hanya simpan jika saat ini tidak memakai profile
      if (!useProfile.checked) {
        manualValues[key] = e.target.value;
      }
    });
  });

  // Toggle checkbox change
  useProfile.addEventListener('change', function() {
    applyUseProfile(this.checked);
  });

  // Inisialisasi awal
  applyUseProfile(useProfile.checked);
});
</script>
