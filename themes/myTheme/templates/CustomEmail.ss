<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pesan Kontak</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
            line-height: 1.6;
            color: #333;
        }
        
        .email-container {
            max-width: 650px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #b78a57 0%, #d4a574 100%);
            padding: 30px 40px;
            text-align: center;
            border-bottom: 3px solid #a67c52;
        }
        
        .header h1 {
            color: white;
            font-size: 28px;
            font-weight: 600;
            margin: 0;
            letter-spacing: 0.5px;
        }
        
        .header-subtitle {
            color: rgba(255, 255, 255, 0.9);
            font-size: 14px;
            margin-top: 8px;
            font-weight: 300;
        }
        
        .content {
            padding: 40px;
        }
        
        .info-section {
            background: #fafbfc;
            border: 1px solid #e1e8ed;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .info-header {
            background: #f8f9fa;
            padding: 15px 25px;
            border-bottom: 1px solid #e1e8ed;
            font-weight: 600;
            color: #495057;
            font-size: 16px;
        }
        
        .info-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .info-table tr {
            border-bottom: 1px solid #f1f3f4;
        }
        
        .info-table tr:last-child {
            border-bottom: none;
        }
        
        .info-table td {
            padding: 18px 25px;
            vertical-align: top;
        }
        
        .info-table .label {
            width: 120px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
            background: #f8f9fa;
            border-right: 1px solid #e9ecef;
        }
        
        .info-table .value {
            color: #333;
            font-size: 15px;
            word-wrap: break-word;
        }
        
        .message-content {
            background: white;
            padding: 20px;
            border-left: 4px solid #b78a57;
            border-radius: 4px;
            line-height: 1.7;
            white-space: pre-wrap;
        }
        
        .action-section {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 25px;
            text-align: center;
            margin: 30px 0;
        }
        
        .action-title {
            font-size: 18px;
            font-weight: 600;
            color: #495057;
            margin-bottom: 15px;
        }
        
        .action-description {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        
        .action-button {
            display: inline-block;
            background-color: #b78a57;
            color: white;
            padding: 14px 32px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 15px;
            border: 2px solid #b78a57;
            margin-bottom: 15px;
        }
        
        .alternative-link {
            background: #e9ecef;
            padding: 15px;
            border-radius: 6px;
            margin-top: 15px;
        }
        
        .alternative-link .label {
            font-weight: 600;
            color: #495057;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }
        
        .alternative-link .link {
            color: #6c757d;
            font-size: 12px;
            word-break: break-all;
            font-family: 'Courier New', monospace;
            background: white;
            padding: 8px 12px;
            border-radius: 4px;
            border: 1px solid #dee2e6;
        }
        
        .warning-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-left: 4px solid #fdcb6e;
            padding: 15px 20px;
            border-radius: 6px;
            margin: 20px 0;
        }
        
        .warning-box .title {
            font-weight: 600;
            color: #856404;
            margin-bottom: 5px;
            font-size: 14px;
        }
        
        .warning-box .text {
            color: #856404;
            font-size: 13px;
            line-height: 1.4;
        }
        
        .divider {
            height: 1px;
            background: linear-gradient(to right, transparent, #e9ecef, transparent);
            margin: 40px 0;
        }
        
        .footer {
            background: #f8f9fa;
            padding: 25px 40px;
            border-top: 1px solid #e9ecef;
            text-align: center;
        }
        
        .footer-content {
            color: #6c757d;
            font-size: 13px;
            line-height: 1.5;
        }
        
        .footer-company {
            font-weight: 600;
            color: #495057;
            margin-bottom: 5px;
        }
        
        .footer-timestamp {
            color: #adb5bd;
            font-size: 11px;
            margin-top: 10px;
            font-style: italic;
        }
        
        @media (max-width: 600px) {
            body { padding: 10px; }
            .content { padding: 25px 20px; }
            .header { padding: 25px 20px; }
            .footer { padding: 20px 15px; }
            .info-table .label { width: 100px; }
            .info-table td { padding: 12px 15px; }
        }
    </style>
</head>
<body>
    <div class="email-container">
        <div class="header">
            <h1>Pesan Kontak</h1>
        </div>
        
        <div class="content">
            <div class="info-section">
                <div class="info-header">Informasi Pengirim</div>
                <table class="info-table">
                    <tr>
                        <td class="label">Nama</td>
                        <td class="value">$Name</td>
                    </tr>
                    <tr>
                        <td class="label">Email</td>
                        <td class="value">$SenderEmail</td>
                    </tr>
                    <tr>
                        <td class="label">Pesan</td>
                        <td class="value">
                            <div class="message-content">$MessageContent</div>
                        </td>
                    </tr>
                </table>
            </div>
            
            <% if $ResetLink %>
            <div class="action-section">
                <div class="action-title">Reset Password</div>
                <div class="action-description">
                    Klik tombol di bawah ini untuk melanjutkan proses reset password Anda.
                </div>
                <a href="$ResetLink" class="action-button">Reset Password Sekarang</a>
                
                <div class="alternative-link">
                    <div class="label">Link Alternatif</div>
                    <div class="link">$ResetLink</div>
                </div>
                
                <div class="warning-box">
                    <div class="title">Penting!</div>
                    <div class="text">Link ini berlaku selama 1 jam dan hanya dapat digunakan sekali untuk keamanan akun Anda.</div>
                </div>
            </div>
            <% end_if %>
            
            <% if $VerificationLink %>
            <div class="action-section">
                <div class="action-title">Verifikasi Email</div>
                <div class="action-description">
                    Silakan verifikasi alamat email Anda untuk mengaktifkan akun.
                </div>
                <a href="$VerificationLink" class="action-button">Verifikasi Email</a>
                
                <div class="alternative-link">
                    <div class="label">Link Alternatif</div>
                    <div class="link">$VerificationLink</div>
                </div>
            </div>
            <% end_if %>
            
            <div class="divider"></div>
        </div>
        
        <div class="footer">
            <div class="footer-content">
                <div class="footer-company">$SiteName</div>
                <div>Email ini dikirim secara otomatis dari sistem formulir kontak.</div>
                <div>Mohon tidak membalas email ini.</div>
                <div class="footer-timestamp">Dikirim pada: {$Now.Format('d/m/Y H:i')} WIB</div>
            </div>
        </div>
    </div>
</body>
</html>