<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verifikasi Email</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #ffff;
            min-height: 100vh;
        }
        
        .verification-container {
            max-width: 480px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        .verification-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            border: none;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        
        .verification-card:hover {
            transform: translateY(-2px);
        }
        
        .card-header {
            background: white;
            border: none;
            padding: 2.5rem 2rem 1rem;
            text-align: center;
        }
        
        .verification-icon {
            width: 64px;
            height: 64px;
            background: #f8f9fa;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            border: 3px solid #e9ecef;
        }
        
        .verification-icon svg {
            width: 28px;
            height: 28px;
            color: #6c757d;
        }
        
        .card-title {
            font-size: 1.75rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 0.5rem;
        }
        
        .card-subtitle {
            color: #6c757d;
            font-size: 1rem;
            margin-bottom: 0;
        }
        
        .card-body {
            padding: 1rem 2rem 2.5rem;
        }
        
        .alert {
            border: none;
            border-radius: 12px;
            padding: 1.25rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        
        .alert-success {
            background: #f8f9fa;
            color: #495057;
            border-left: 4px solid #28a745;
        }
        
        .alert-danger {
            background: #f8f9fa;
            color: #495057;
            border-left: 4px solid #dc3545;
        }
        
        .btn-login {
            background: #c4965c;
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            border-radius: 12px;
            font-weight: 500;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            min-width: 120px;
        }
        
        .btn-login:hover {
            background: #495057;
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        @media (max-width: 576px) {
            .verification-container {
                padding: 1rem;
            }
            
            .card-header {
                padding: 2rem 1.5rem 1rem;
            }
            
            .card-body {
                padding: 1rem 1.5rem 2rem;
            }
            
            .card-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <main class="d-flex align-items-center min-vh-100">
        <div class="verification-container w-100">
            <div class="verification-card card">
                <div class="card-header">
                    <div class="verification-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/>
                            <polyline points="22,6 12,13 2,6"/>
                        </svg>
                    </div>
                    <h2 class="card-title">Verifikasi Email</h2>
                    <p class="card-subtitle">Konfirmasi status verifikasi akun Anda</p>
                </div>
                
                <div class="card-body text-center">
                    <% if $Content %>
                    <div class="alert alert-success">
                        $Content.RAW
                    </div>
                    <% else %>
                    <div class="alert alert-danger">
                        Token tidak valid atau akun sudah terverifikasi.
                    </div>
                    <% end_if %>

                    <a href="$BaseHref/auth/login" class="btn-login">Masuk</a>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>