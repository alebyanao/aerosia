
    <title>Scanner Tiket</title>
<script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
<style>
#ticket-scanner-wrapper {
    max-width: 480px;
    margin: 20px auto;
    background: #ffffff;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 8px 24px rgba(0,0,0,0.1);
    text-align: center;
}

#ticket-scanner-wrapper h2 {
    margin-bottom: 20px;
    color: inherit; /* Mengikuti warna font tema */
}

/* Area Kamera */
#reader { 
    width: 100%; 
    border-radius: 8px; 
    overflow: hidden; 
    background: #222; 
    margin-bottom: 20px; 
    border: 2px solid #eee;
}

/* Hasil Scan */
#ticket-scanner-wrapper .result-box { 
    display: none; 
    padding: 20px; 
    margin-top: 20px; 
    border-radius: 8px; 
    text-align: left; 
    animation: ticketPopIn 0.3s ease; 
}

#ticket-scanner-wrapper .result-box.success { 
    background-color: #d1e7dd !important; 
    border: 1px solid #badbcc; 
    color: #0f5132; 
}

#ticket-scanner-wrapper .result-box.error { 
    background-color: #f8d7da !important; 
    border: 1px solid #f5c6cb; 
    color: #842029; 
}

#ticket-scanner-wrapper .result-title { 
    font-size: 1.3em; 
    font-weight: bold; 
    display: block; 
    margin-bottom: 10px; 
    text-align: center; 
}

#ticket-scanner-wrapper .result-detail { 
    font-size: 0.95em; 
    line-height: 1.6; 
}

/* Tombol */
#ticket-scanner-wrapper .btn-reset { 
    display: block; 
    width: 100%; 
    padding: 14px; 
    margin-top: 20px; 
    background: #0d6efd; 
    color: #ffffff; 
    border: none; 
    border-radius: 6px; 
    font-weight: 600;
    cursor: pointer;
}

#ticket-scanner-wrapper .btn-reset:hover { 
    background: #0b5ed7; 
}

@keyframes ticketPopIn { 
    from { transform: scale(0.95); opacity: 0; } 
    to { transform: scale(1); opacity: 1; } 
}
</style>

<div id="ticket-scanner-wrapper">
    <h2>Scan Tiket</h2>
    
    <div id="reader"></div>
    
    <div id="result-area" class="result-box">
        <span id="res-icon" class="result-title"></span>
        <div id="res-content" class="result-detail"></div>
        <button class="btn-reset" onclick="resetScanner()">Scan Berikutnya</button>
    </div>

    <p style="font-size: 0.8em; color: #666; margin-top: 20px; border-top: 1px solid #eee; pt-10px;">
        Petugas: $CurrentMember.FirstName
    </p>
</div>

<input type="hidden" id="csrf_token" value="$SecurityID">

<script>
    const html5QrCode = new Html5Qrcode("reader");
    let isProcessing = false;

    // Config Kamera
    const config = { 
        fps: 10, 
        qrbox: { width: 250, height: 250 },
        aspectRatio: 1.0
    };

    // Fungsi saat QR terdeteksi
    const onScanSuccess = (decodedText, decodedResult) => {
        if (isProcessing) return;
        
        isProcessing = true;
        html5QrCode.pause(); // Stop kamera sementara
        
        // Mainkan suara 'beep'
        playBeep(); 

        validateTicket(decodedText);
    };

    // Mulai Scanner (Kamera Belakang)
    html5QrCode.start({ facingMode: "environment" }, config, onScanSuccess)
    .catch(err => {
        console.error("Gagal memulai kamera", err);
        alert("Gagal akses kamera. Pastikan izin diberikan.");
    });

    function validateTicket(code) {
        const csrfToken = document.getElementById('csrf_token').value;
        const resultArea = document.getElementById('result-area');
        const resIcon = document.getElementById('res-icon');
        const resContent = document.getElementById('res-content');

        // Tampilkan Loading
        resultArea.style.display = 'block';
        resultArea.className = 'result-box';
        resIcon.innerText = "⏳";
        resContent.innerText = "Memproses data...";

        // Kirim ke Backend
        const formData = new FormData();
        formData.append('code', code);
        formData.append('SecurityID', csrfToken);

        fetch('$Link("validateTicket")', { // $Link akan diganti SilverStripe jadi URL Controller
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                // SUKSES
                resultArea.className = 'result-box success';
                resIcon.innerText = "✅ VALID";
                resContent.innerHTML = `
                    <strong>${data.data.Name}</strong><br>
                    ${data.data.Ticket} (${data.data.Qty} Pax)<br>
                    <small>Silakan Masuk</small>
                `;
            } else {
                // GAGAL
                resultArea.className = 'result-box error';
                resIcon.innerText = "❌ DITOLAK";
                resContent.innerHTML = `
                    <strong>${data.message}</strong><br>
                    ${data.detail || ''}<br>
                    ${data.data ? 'Nama: ' + data.data.Name : ''}
                `;
                playErrorSound();
            }
        })
        .catch(err => {
            resultArea.className = 'result-box error';
            resIcon.innerText = "⚠️ ERROR";
            resContent.innerText = "Gagal koneksi ke server.";
        });
    }

    function resetScanner() {
        document.getElementById('result-area').style.display = 'none';
        isProcessing = false;
        html5QrCode.resume(); // Nyalakan kamera lagi
    }

    // Sound Effects (Opsional)
    function playBeep() {
        // Nada pendek frekuensi tinggi
        const ctx = new (window.AudioContext || window.webkitAudioContext)();
        const osc = ctx.createOscillator();
        osc.connect(ctx.destination);
        osc.frequency.value = 800;
        osc.start();
        setTimeout(() => osc.stop(), 100);
    }
    
    function playErrorSound() {
        const ctx = new (window.AudioContext || window.webkitAudioContext)();
        const osc = ctx.createOscillator();
        osc.type = 'sawtooth';
        osc.connect(ctx.destination);
        osc.frequency.value = 200;
        osc.start();
        setTimeout(() => osc.stop(), 300);
    }
</script>
