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
            font-size: 10pt;
            color: #333;
            line-height: 1.4;
            padding: 0;
            margin: 0;
        }
        .invoice-container { 
            width: 100%; 
            margin: 0;
            padding: 0;
        }

        /* Header */
        .header-top {
            text-align: center;
            margin-bottom: 18px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f0f0f0;
        }
        .company-logo {
            max-width: 70px;
            max-height: 70px;
            margin-bottom: 10px;
        }
        .company-name {
            font-size: 14pt;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        .invoice-title {
            font-size: 22pt;
            font-weight: bold;
            color: #000;
            margin-bottom: 6px;
            letter-spacing: 2px;
        }
        .invoice-meta {
            font-size: 8.5pt;
            color: #666;
            margin-bottom: 0;
        }

        /* Two Column Layout */
        .content-wrapper {
            display: table;
            width: 100%;
            margin-bottom: 15px;
        }
        .left-column {
            display: table-cell;
            width: 50%;
            padding-right: 20px;
            vertical-align: top;
        }
        .right-column {
            display: table-cell;
            width: 50%;
            padding-left: 20px;
            vertical-align: top;
            border-left: 1px solid #e0e0e0;
        }

        /* Info Sections */
        .info-section {
            margin-bottom: 14px;
        }
        .section-title {
            font-size: 9.5pt;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 5px;
        }
        .info-row {
            display: table;
            width: 100%;
            margin-bottom: 5px;
            font-size: 8.5pt;
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
            margin: 14px 0;
            font-size: 9pt;
        }
        .items-table thead {
            background-color: #f5f5f5;
            border-top: 1px solid #333;
            border-bottom: 1px solid #333;
        }
        .items-table th {
            padding: 8px 10px;
            text-align: left;
            font-weight: bold;
            color: #333;
            border: 1px solid #ccc;
        }
        .items-table th:last-child {
            text-align: right;
        }
        .items-table td {
            padding: 8px 10px;
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
            margin-top: 12px;
            margin-bottom: 12px;
            border: 1px solid #ccc;
        }
        .totals-content {
            padding: 12px;
        }
        .total-row {
            display: table;
            width: 100%;
            margin-bottom: 7px;
            font-size: 9pt;
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
            font-size: 10pt;
        }

        /* QR Code Section */
        .qr-section {
            text-align: center;
            margin: 12px 0 0 0;
            padding: 12px;
            background-color: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-radius: 2px;
        }
        .qr-section h3 {
            font-size: 10pt;
            color: #333;
            margin-bottom: 10px;
        }
        .qr-section img {
            max-width: 110px;
            max-height: 110px;
        }
        .qr-code-text {
            font-size: 7.5pt;
            color: #666;
            margin-top: 8px;
            line-height: 1.4;
        }

        /* Footer */
        .invoice-footer {
            margin-top: 12px;
            padding-top: 10px;
            border-top: 1px solid #e0e0e0;
            text-align: center;
            font-size: 7.5pt;
            color: #999;
            line-height: 1.5;
        }

        /* Divider */
        .divider {
            border-top: 1px solid #e0e0e0;
            margin: 6px 0;
        }

        /* Event Details */
        .event-section {
            background-color: #f9f9f9;
            padding: 12px;
            border: 1px solid #e0e0e0;
            margin-bottom: 12px;
            font-size: 8.5pt;
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
                No: $InvoiceNumber | Tgl: $InvoiceDate | Order: $Order.OrderCode
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
                        <div class="info-label">Kode:</div>
                        <div class="info-value">$Order.OrderCode</div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Tanggal:</div>
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
                        <div class="info-label">Metode:</div>
                        <div class="info-value">$PaymentMethod</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Event Details (if applicable) -->
        <% if $EventName %>
        <div class="event-section">
            <div class="section-title" style="margin-bottom: 6px; border-bottom: none;">Detail Event</div>
            <div class="info-row">
                <div class="info-label">Event:</div>
                <div class="info-value"><strong>$EventName</strong></div>
            </div>
            <% if $EventDate %>
            <div class="info-row">
                <div class="info-label">Tgl Event:</div>
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
                    <th style="width: 19%; text-align: right;">Harga</th>
                    <th style="width: 19%; text-align: right;">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>$TicketTypeName</strong><br><span style="font-size: 7pt; color: #666;">$EventName</span></td>
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
                    <div class="total-label">Subtotal:</div>
                    <div class="total-value">$FormattedTotalPrice</div>
                </div>
                <div class="total-row">
                    <div class="total-label">Biaya Admin:</div>
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
            <h3>QR Code Pesanan</h3>
            <img src="$QRCodePath" alt="QR Code">
            <div class="qr-code-text">
                Kode: $Order.QRCodeData
            </div>
        </div>
        <% end_if %>

        <!-- Footer -->
        <div class="invoice-footer">
            <p style="margin: 0;">© <% if $SiteConfig.Copyright %>$SiteConfig.Copyright<% else %>All Copyright Reserved<% end_if %></p>
        </div>
    </div>
</body>
</html>