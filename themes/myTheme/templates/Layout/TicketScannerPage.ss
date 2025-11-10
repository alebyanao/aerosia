<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card shadow-lg">
                <div class="card-header bg-primary text-white">
                    <h2 class="mb-0">
                        <i class="fas fa-qrcode"></i> Scanner Tiket Event
                    </h2>
                </div>
                
                <div class="card-body">
                    <!-- Scanner Area -->
                    <div id="scanner-container" class="mb-4">
                        <div class="alert alert-info">
                            <h5>Cara Menggunakan:</h5>
                            <ol class="mb-0">
                                <li>Masukkan kode QR secara manual di form bawah, atau</li>
                                <li>Gunakan aplikasi QR scanner di HP untuk scan QR dari PDF invoice</li>
                                <li>Copy hasil scan dan paste ke form di bawah</li>
                            </ol>
                        </div>
                    </div>

                    <!-- Manual Input Form -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <h5 class="card-title">Input Manual QR Code</h5>
                            <form id="qr-verify-form">
                                <div class="mb-3">
                                    <label for="qr-input" class="form-label">Kode QR Tiket:</label>
                                    <input 
                                        type="text" 
                                        class="form-control form-control-lg" 
                                        id="qr-input" 
                                        placeholder="Contoh: TICKET-123-a3f5c8b2e1d4f6a7b8c9d0e1f2a3b4c5"
                                        required
                                    >
                                    <small class="text-muted">Format: TICKET-[ID]-[HASH]</small>
                                </div>
                                
                                <button type="submit" class="btn btn-primary btn-lg w-100">
                                    <i class="fas fa-search"></i> Verifikasi QR Code
                                </button>
                            </form>
                        </div>
                    </div>

                    <!-- Result Area -->
                    <div id="result-container"></div>
                </div>
            </div>

            <!-- History -->
            <div class="card shadow mt-4">
                <div class="card-header bg-secondary text-white">
                    <h5 class="mb-0">Riwayat Scan</h5>
                </div>
                <div class="card-body">
                    <div id="scan-history" class="list-group">
                        <p class="text-muted">Belum ada scan hari ini</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.result-card {
    border-left: 5px solid #28a745;
    animation: slideIn 0.3s ease;
}

.result-card.invalid {
    border-left-color: #dc3545;
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(-20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.ticket-info {
    background: #f8f9fa;
    border-radius: 8px;
    padding: 15px;
    margin: 10px 0;
}

.ticket-info-item {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
    border-bottom: 1px solid #dee2e6;
}

.ticket-info-item:last-child {
    border-bottom: none;
}

.scan-history-item {
    padding: 10px;
    border-bottom: 1px solid #eee;
}

.scan-history-item:last-child {
    border-bottom: none;
}

.btn-scan-confirm {
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0%, 100% {
        box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7);
    }
    50% {
        box-shadow: 0 0 0 10px rgba(40, 167, 69, 0);
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('qr-verify-form');
    const input = document.getElementById('qr-input');
    const resultContainer = document.getElementById('result-container');
    const historyContainer = document.getElementById('scan-history');
    
    let scanHistory = [];

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const qrData = input.value.trim();
        
        if (!qrData) {
            showError('Masukkan kode QR terlebih dahulu');
            return;
        }

        verifyQRCode(qrData);
    });

    function verifyQRCode(qrData) {
        // Show loading
        resultContainer.innerHTML = `
            <div class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p class="mt-2">Memverifikasi QR Code...</p>
            </div>
        `;

        fetch('/ticket-scanner/verify', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: 'qr_data=' + encodeURIComponent(qrData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.valid) {
                showValidTicket(data, qrData);
            } else {
                showInvalidTicket(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showError('Terjadi kesalahan saat verifikasi');
        });
    }

    function showValidTicket(data, qrData) {
        resultContainer.innerHTML = `
            <div class="card result-card">
                <div class="card-body">
                    <div class="text-center mb-3">
                        <i class="fas fa-check-circle text-success" style="font-size: 64px;"></i>
                        <h3 class="text-success mt-2">TIKET VALID ✓</h3>
                    </div>
                    
                    <div class="ticket-info">
                        <div class="ticket-info-item">
                            <strong>Order Code:</strong>
                            <span>${data.data.order_code}</span>
                        </div>
                        <div class="ticket-info-item">
                            <strong>Nama Pembeli:</strong>
                            <span>${data.data.buyer_name}</span>
                        </div>
                        <div class="ticket-info-item">
                            <strong>Email:</strong>
                            <span>${data.data.buyer_email}</span>
                        </div>
                        <div class="ticket-info-item">
                            <strong>Event:</strong>
                            <span>${data.data.event_name}</span>
                        </div>
                        <div class="ticket-info-item">
                            <strong>Tipe Tiket:</strong>
                            <span>${data.data.ticket_type}</span>
                        </div>
                        <div class="ticket-info-item">
                            <strong>Jumlah:</strong>
                            <span>${data.data.quantity} tiket</span>
                        </div>
                    </div>

                    <button 
                        class="btn btn-success btn-lg w-100 mt-3 btn-scan-confirm" 
                        onclick="confirmScan('${qrData}', ${data.data.order_id})"
                    >
                        <i class="fas fa-check"></i> KONFIRMASI SCAN & MASUK
                    </button>

                    <button 
                        class="btn btn-outline-secondary w-100 mt-2" 
                        onclick="resetScanner()"
                    >
                        <i class="fas fa-redo"></i> Scan Tiket Lain
                    </button>
                </div>
            </div>
        `;
    }

    function showInvalidTicket(message) {
        resultContainer.innerHTML = `
            <div class="card result-card invalid">
                <div class="card-body">
                    <div class="text-center mb-3">
                        <i class="fas fa-times-circle text-danger" style="font-size: 64px;"></i>
                        <h3 class="text-danger mt-2">TIKET TIDAK VALID ✗</h3>
                    </div>
                    
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle"></i>
                        <strong>Alasan:</strong> ${message}
                    </div>

                    <button 
                        class="btn btn-outline-secondary w-100 mt-2" 
                        onclick="resetScanner()"
                    >
                        <i class="fas fa-redo"></i> Coba Lagi
                    </button>
                </div>
            </div>
        `;
    }

    function showError(message) {
        resultContainer.innerHTML = `
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${message}
            </div>
        `;
    }

    window.confirmScan = function(qrData, orderId) {
        if (!confirm('Yakin ingin mengkonfirmasi scan tiket ini? Tiket tidak dapat di-scan lagi setelah dikonfirmasi.')) {
            return;
        }

        fetch('/ticket-scanner/scan', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: 'qr_data=' + encodeURIComponent(qrData)
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Add to history
                addToHistory(qrData, orderId);
                
                resultContainer.innerHTML = `
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <strong>Berhasil!</strong> Tiket telah di-scan dan dicatat. Peserta dapat masuk.
                    </div>
                `;
                
                // Reset form
                setTimeout(() => {
                    resetScanner();
                }, 3000);
            } else {
                showError(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showError('Terjadi kesalahan saat konfirmasi scan');
        });
    };

    window.resetScanner = function() {
        input.value = '';
        resultContainer.innerHTML = '';
        input.focus();
    };

    function addToHistory(qrData, orderId) {
        const now = new Date();
        const timeStr = now.toLocaleTimeString('id-ID');
        
        scanHistory.unshift({
            qrData: qrData,
            orderId: orderId,
            time: timeStr
        });

        updateHistoryDisplay();
    }

    function updateHistoryDisplay() {
        if (scanHistory.length === 0) {
            historyContainer.innerHTML = '<p class="text-muted">Belum ada scan hari ini</p>';
            return;
        }

        historyContainer.innerHTML = scanHistory.map((item, index) => `
            <div class="scan-history-item">
                <div class="d-flex justify-content-between">
                    <div>
                        <strong>#${index + 1}</strong> - Order ID: ${item.orderId}
                    </div>
                    <small class="text-muted">${item.time}</small>
                </div>
                <small class="text-muted">${item.qrData}</small>
            </div>
        `).join('');
    }

    // Auto focus on input
    input.focus();
});
</script>