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
            font-family: Arial, sans-serif;
            font-size: 11pt;
            color: #333;
            line-height: 1.6;
        }
        .invoice-container { 
            width: 100%; 
            max-width: 900px; 
            margin: 0 auto;
        }

        /* Header */
        .header-top {
            text-align: center;
            margin-bottom: 30px;
        }
        .company-logo {
            max-width: 80px;
            max-height: 80px;
            margin-bottom: 15px;
        }
        .company-name {
            font-size: 18pt;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }
        .invoice-title {
            font-size: 26pt;
            font-weight: bold;
            color: #000;
            margin-bottom: 10px;
            letter-spacing: 2px;
        }
        .invoice-meta {
            font-size: 9pt;
            color: #666;
            margin-bottom: 25px;
        }

        /* Two Column Layout */
        .content-wrapper {
            display: table;
            width: 100%;
            margin-bottom: 30px;
        }
        .left-column {
            display: table-cell;
            width: 50%;
            padding-right: 30px;
            vertical-align: top;
        }
        .right-column {
            display: table-cell;
            width: 50%;
            padding-left: 30px;
            vertical-align: top;
            border-left: 1px solid #e0e0e0;
        }

        /* Info Sections */
        .info-section {
            margin-bottom: 25px;
        }
        .section-title {
            font-size: 10pt;
            font-weight: bold;
            color: #333;
            margin-bottom: 12px;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 8px;
        }
        .info-row {
            display: table;
            width: 100%;
            margin-bottom: 8px;
            font-size: 9pt;
        }
        .info-label {
            display: table-cell;
            width: 35%;
            color: #666;
            vertical-align: top;
        }
        .info-value {
            display: table-cell;
            width: 65%;
            color: #333;
            font-weight: 500;
            word-break: break-word;
        }

        /* Table */
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin: 30px 0;
            font-size: 10pt;
        }
        .items-table thead {
            background-color: #f5f5f5;
            border-top: 1px solid #333;
            border-bottom: 1px solid #333;
        }
        .items-table th {
            padding: 12px 10px;
            text-align: left;
            font-weight: bold;
            color: #333;
            border: 1px solid #ccc;
        }
        .items-table th:last-child {
            text-align: right;
        }
        .items-table td {
            padding: 12px 10px;
            border: 1px solid #ccc;
        }
        .items-table td:last-child {
            text-align: right;
        }
        .items-table tbody tr:last-child td {
            border-bottom: 1px solid #333;
        }

        /* Totals */
        .totals-wrapper {
            margin-top: 15px;
            border: 1px solid #ccc;
        }
        .totals-content {
            padding: 15px;
        }
        .total-row {
            display: table;
            width: 100%;
            margin-bottom: 10px;
            font-size: 10pt;
        }
        .total-row:last-child {
            margin-bottom: 0;
        }
        .total-label {
            display: table-cell;
            width: 70%;
            color: #333;
        }
        .total-value {
            display: table-cell;
            width: 30%;
            text-align: right;
            color: #333;
            font-weight: 500;
        }
        .total-label.bold {
            font-weight: bold;
        }
        .total-value.bold {
            font-weight: bold;
            font-size: 11pt;
        }

        /* Footer */
        .invoice-footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            text-align: center;
            font-size: 8pt;
            color: #999;
            line-height: 1.8;
        }

        /* Horizontal Line */
        .divider {
            border-top: 1px solid #e0e0e0;
            margin: 10px 0;
        }

        /* QR Code Section */
        .qr-section {
            text-align: center;
            margin: 30px 0;
            padding: 20px;
            background-color: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 3px;
        }
        .qr-section h3 {
            font-size: 11pt;
            color: #333;
            margin-bottom: 15px;
        }
        .qr-section img {
            max-width: 150px;
            max-height: 150px;
        }
        .qr-code-text {
            font-size: 8pt;
            color: #666;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="invoice-container">
        <!-- Header -->
        <div class="header-top">
            <% if $LogoCID %>
                <img src="$LogoCID" alt="$SiteConfig.Title" class="company-logo">
            <% else_if $SiteConfig.Logo %>
                <img src="$SiteConfig.Logo.AbsoluteURL" alt="$SiteConfig.Title" class="company-logo">
            <% end_if %>
            <div class="invoice-title">INVOICE</div>
            <div class="invoice-meta">
                No: $InvoiceNumber | Tanggal: $InvoiceDate | Order: $Order.OrderCode
            </div>
        </div>

        <!-- Main Content -->
        <div class="content-wrapper">
            <!-- Left Column - Billing Info -->
            <div class="left-column">
                <div class="info-section">
                    <div class="section-title">Ditagih Kepada</div>
                    <div class="info-row">
                        <div class="info-label">Nama:</div>
                        <div class="info-value">$BuyerName</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email:</div>
                        <div class="info-value">$BuyerEmail</div>
                    </div>
                </div>
            </div>

            <!-- Right Column - Order Details -->
            <div class="right-column">
                <div class="info-section">
                    <div class="section-title">Detail Pesanan</div>
                    <div class="info-row">
                        <div class="info-label">Kode Pesanan:</div>
                        <div class="info-value">$Order.OrderCode</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Tanggal Pesanan:</div>
                        <div class="info-value">$Order.CreatedAt.Nice</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Status:</div>
                        <div class="info-value">
                            <% if $PaymentStatus == 'paid' %>
                                Sudah Dibayar
                            <% else %>
                                Belum Dibayar
                            <% end_if %>
                        </div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Metode Bayar:</div>
                        <div class="info-value">$PaymentMethod</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Event Details (if applicable) -->
        <% if $EventName %>
        <div class="info-section" style="background-color: #f9f9f9; padding: 15px; border: 1px solid #e0e0e0; margin-bottom: 25px;">
            <div class="section-title" style="margin-bottom: 10px; border-bottom: none;">Detail Event</div>
            <div class="info-row">
                <div class="info-label">Nama Event:</div>
                <div class="info-value"><strong>$EventName</strong></div>
            </div>
            <% if $EventDate %>
            <div class="info-row">
                <div class="info-label">Tanggal Event:</div>
                <div class="info-value">$Ticket.EventDate.Nice</div>
            </div>
            <% end_if %>
            <% if $EventLocation %>
            <div class="info-row">
                <div class="info-label">Lokasi:</div>
                <div class="info-value">$EventLocation</div>
            </div>
            <% end_if %>
        </div>
        <% end_if %>

        <!-- Items Table -->
        <table class="items-table">
            <thead>
                <tr>
                    <th style="width: 50%;">Deskripsi</th>
                    <th style="width: 12%; text-align: center;">Qty</th>
                    <th style="width: 19%; text-align: right;">Harga Satuan</th>
                    <th style="width: 19%; text-align: right;">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>$TicketTypeName</strong><br><span style="font-size: 8pt; color: #666;">Event: $EventName</span></td>
                    <td style="text-align: center;">$Quantity</td>
                    <td style="text-align: right;">$FormattedUnitPrice</td>
                    <td style="text-align: right;"><strong>$FormattedTotalPrice</strong></td>
                </tr>
            </tbody>
        </table>

        <!-- Totals -->
        <div class="totals-wrapper">
            <div class="totals-content">
                <div class="total-row">
                    <div class="total-label">Subtotal Produk:</div>
                    <div class="total-value">$FormattedTotalPrice</div>
                </div>
                <div class="total-row">
                    <div class="total-label">Biaya Admin ($PaymentMethod):</div>
                    <div class="total-value">$FormattedPaymentFee</div>
                </div>
                <div class="divider"></div>
                <div class="total-row">
                    <div class="total-label bold">TOTAL:</div>
                    <div class="total-value bold">$FormattedGrandTotal</div>
                </div>
            </div>
        </div>

        <!-- QR Code -->
        <% if $QRCodePath %>
        <div class="qr-section">
            <h3>QR Code Tiket/Pesanan</h3>
            <img src="$QRCodePath" alt="QR Code">
            <div class="qr-code-text">
                Tunjukkan kode ini saat pengambilan pesanan<br>
                Kode: $Order.QRCodeData
            </div>
        </div>
        <% end_if %>

        <!-- Footer -->
        <div class="invoice-footer">
            <p>Invoice ini digenerate secara otomatis pada $InvoiceDate</p>
            <p>© <% if $SiteConfig.Copyright %>$SiteConfig.Copyright<% else %>All Copyright Reserved<% end_if %></p>
        </div>
    </div>
</body>
</html>