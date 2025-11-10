<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>Invoice - $InvoiceNumber</title>
    <style>
        @page {
            margin: 20mm;
            size: A4 portrait;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'DejaVu Sans', sans-serif;
            font-size: 11pt;
            color: #333;
            line-height: 1.6;
        }
        .invoice-container { width: 100%; max-width: 800px; margin: 0 auto; }

        /* Header */
        .invoice-header {
            border-bottom: 3px solid #667eea;
            padding-bottom: 20px;
            margin-bottom: 30px;
            display: table;
            width: 100%;
        }
        .company-info { display: table-cell; width: 60%; vertical-align: top; }
        .company-logo { max-width: 180px; max-height: 80px; margin-bottom: 10px; }
        .company-details { font-size: 9pt; color: #666; line-height: 1.5; }
        .invoice-title-section { display: table-cell; width: 40%; text-align: right; vertical-align: top; }
        .invoice-title { font-size: 28pt; font-weight: bold; color: #667eea; margin-bottom: 10px; }
        .invoice-meta { font-size: 9pt; color: #666; }
        .invoice-meta strong { color: #333; }

        /* Status Badge */
        .status-badge {
            display: inline-block; padding: 5px 12px; border-radius: 3px;
            font-size: 8pt; font-weight: bold; text-transform: uppercase;
            margin-top: 8px;
        }
        .status-paid { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .status-unpaid { background-color: #fff3cd; color: #856404; border: 1px solid #ffeaa7; }

        /* Info Boxes */
        .info-section { margin-bottom: 25px; display: table; width: 100%; }
        .info-box {
            display: table-cell; width: 48%; padding: 15px;
            background-color: #f8f9fa; border-radius: 5px; vertical-align: top;
        }
        .info-box + .info-box { margin-left: 4%; }
        .info-box h3 {
            font-size: 11pt; color: #667eea; margin-bottom: 10px;
            border-bottom: 2px solid #667eea; padding-bottom: 5px;
        }
        .info-box p { margin: 5px 0; font-size: 9pt; }
        .info-box strong { color: #333; }

        /* Event Details */
        .event-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; padding: 20px; border-radius: 8px; margin-bottom: 25px;
        }
        .event-section h2 { font-size: 16pt; margin-bottom: 12px; }
        .event-detail { margin: 8px 0; font-size: 10pt; }
        .event-icon { display: inline-block; width: 20px; font-weight: bold; }

        /* Table */
        .items-table {
            width: 100%; border-collapse: collapse; margin: 25px 0; font-size: 10pt;
        }
        .items-table thead { background-color: #667eea; color: white; }
        .items-table th {
            padding: 12px 10px; text-align: left; font-weight: bold;
        }
        .items-table th:last-child, .items-table td:last-child { text-align: right; }
        .items-table tbody tr { border-bottom: 1px solid #e0e0e0; }
        .items-table tbody tr:last-child { border-bottom: 2px solid #667eea; }
        .items-table td { padding: 12px 10px; }
        .items-table .item-description { color: #666; font-size: 8pt; margin-top: 3px; }

        /* Totals */
        .totals-section { width: 50%; margin-left: auto; margin-top: 20px; }
        .total-row { display: table; width: 100%; padding: 8px 0; }
        .total-label { display: table-cell; text-align: left; font-size: 10pt; }
        .total-value { display: table-cell; text-align: right; font-size: 10pt; }
        .total-divider { border-top: 1px solid #e0e0e0; margin: 10px 0; }
        .grand-total {
            background-color: #667eea; color: white;
            padding: 12px; border-radius: 5px; margin-top: 10px;
        }
        .grand-total .total-label, .grand-total .total-value {
            font-size: 13pt; font-weight: bold;
        }

        /* Notes */
        .notes-section {
            margin-top: 30px; padding: 15px;
            background-color: #f8f9fa; border-left: 4px solid #667eea; border-radius: 3px;
        }
        .notes-section h4 { font-size: 10pt; color: #667eea; margin-bottom: 8px; }
        .notes-section ul { margin-left: 20px; font-size: 9pt; color: #666; }
        .notes-section li { margin: 5px 0; }

        /* Footer */
        .invoice-footer {
            margin-top: 40px; padding-top: 20px;
            border-top: 2px solid #e0e0e0; text-align: center;
            font-size: 8pt; color: #999;
        }

        /* QR Section */
        .barcode-section { text-align: center; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="invoice-container">
        <!-- Header -->
        <div class="invoice-header">
            <div class="company-info">
                <% if $LogoCID %>
                    <img src="$LogoCID" alt="$SiteConfig.Title" class="company-logo">
                <% else_if $SiteConfig.Logo %>
                    <img src="$SiteConfig.Logo.AbsoluteURL" alt="$SiteConfig.Title" class="company-logo">
                <% end_if %>

                <div class="company-details">
                    <% if $SiteConfig.Email %>Email: $SiteConfig.Email<br><% end_if %>
                    <% if $SiteConfig.Phone %>Telp: $SiteConfig.Phone<br><% end_if %>
                    <% if $SiteConfig.Address %>$SiteConfig.Address<% end_if %>
                </div>
            </div>

            <div class="invoice-title-section">
                <div class="invoice-title">INVOICE</div>
                <div class="invoice-meta">
                    <strong>No:</strong> $InvoiceNumber<br>
                    <strong>Tanggal:</strong> $InvoiceDate<br>
                    <strong>Order:</strong> $Order.OrderCode
                </div>
                <div>
                    <% if $PaymentStatus == 'paid' %>
                        <span class="status-badge status-paid">✓ LUNAS</span>
                    <% else %>
                        <span class="status-badge status-unpaid">⏳ BELUM BAYAR</span>
                    <% end_if %>
                </div>
            </div>
        </div>

        <!-- Customer & Payment Info -->
        <div class="info-section">
            <div class="info-box">
                <h3>📋 Ditagih Kepada</h3>
                <p><strong>Nama:</strong> $BuyerName</p>
                <p><strong>Email:</strong> $BuyerEmail</p>
                <% if $BuyerPhone %>
                    <p><strong>Telepon:</strong> $BuyerPhone</p>
                <% end_if %>
            </div>

            <div class="info-box">
                <h3>📊 Informasi Pembayaran</h3>
                <p><strong>Metode:</strong> $PaymentMethod</p>
                <p><strong>Status:</strong> <% if $PaymentStatus == 'paid' %>Sudah Dibayar<% else %>Belum Dibayar<% end_if %></p>
                <p><strong>Tanggal Order:</strong> $Order.CreatedAt.Nice</p>
            </div>
        </div>

        <!-- Event -->
        <div class="event-section">
            <h2>🎫 Detail Event</h2>
            <div class="event-detail"><span class="event-icon">🎉</span> <strong>$EventName</strong></div>
            <% if $EventDate %><div class="event-detail"><span class="event-icon">📅</span> $EventDate.Nice</div><% end_if %>
            <% if $EventLocation %><div class="event-detail"><span class="event-icon">📌</span> $EventLocation</div><% end_if %>
        </div>

        <!-- Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th>Deskripsi</th>
                    <th style="text-align:center;">Qty</th>
                    <th style="text-align:right;">Harga Satuan</th>
                    <th style="text-align:right;">Jumlah</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Tiket: $TicketTypeName</strong><div class="item-description">Event: $EventName</div></td>
                    <td style="text-align:center;">$Quantity</td>
                    <td style="text-align:right;">$FormattedUnitPrice</td>
                    <td style="text-align:right;"><strong>$FormattedTotalPrice</strong></td>
                </tr>
            </tbody>
        </table>

        <!-- Totals -->
        <div class="totals-section">
            <div class="total-row"><div class="total-label">Subtotal Tiket:</div><div class="total-value">$FormattedTotalPrice</div></div>
            <div class="total-row"><div class="total-label">Biaya Admin ($PaymentMethod):</div><div class="total-value">$FormattedPaymentFee</div></div>
            <div class="total-divider"></div>
            <div class="grand-total">
                <div class="total-row"><div class="total-label">TOTAL PEMBAYARAN:</div><div class="total-value">$FormattedGrandTotal</div></div>
            </div>
        </div>

        <!-- Notes -->
        <div class="notes-section">
            <h4>📌 Catatan Penting:</h4>
            <ul>
                <li>Simpan invoice ini sebagai bukti pembelian yang sah</li>
                <li>Tunjukkan e-ticket atau QR code saat memasuki venue event</li>
                <li>Tiket yang sudah dibeli tidak dapat dikembalikan atau diuangkan</li>
                <li>Untuk pertanyaan lebih lanjut, hubungi customer service kami</li>
            </ul>
        </div>

        <!-- QR Code -->
        <div class="barcode-section">
            <h3 style="color:#667eea; margin-bottom:15px;">🎫 QR Code Tiket Anda</h3>
           <% if $QRCodePath %>
  <div style="text-align:center; margin-top:20px;">
      <img src="$QRCodePath" alt="QR Code" width="200" height="200" style="display:inline-block;">
  </div>
<% end_if %>

            <p style="margin-top:10px; font-size:9pt; color:#666;">Tunjukkan QR Code ini saat memasuki venue</p>
            <p style="font-size:8pt; color:#999; margin-top:5px;">Kode: $Order.QRCodeData</p>
        </div>

        <!-- Footer -->
        <div class="invoice-footer">
            <p><strong>Terima kasih atas pembelian Anda!</strong></p>
            <p>Dokumen ini digenerate secara otomatis dan sah tanpa tanda tangan</p>
        </div>
    </div>
</body>
</html>
