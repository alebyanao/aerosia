
    <title>Get Your Ticket</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            overflow-x: hidden;
            background: #fff;
        }

        /* ================= HERO ================= */
        .hero-section {
            background: linear-gradient(135deg, #d4a5ff 0%, #8b5fbf 100%);
            min-height: 85vh;
            position: relative;
            padding: 5rem 1rem 8rem;
            text-align: center;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        /* Animated background circles */
        .hero-bg-circles {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            overflow: hidden;
            z-index: 1;
        }

        .circle {
            position: absolute;
            border-radius: 50%;
            opacity: 0.1;
            animation: float 8s ease-in-out infinite;
        }

        .circle1 {
            width: 300px;
            height: 300px;
            background: #fff;
            top: -100px;
            left: -100px;
            animation-delay: 0s;
        }

        .circle2 {
            width: 250px;
            height: 250px;
            background: #fff;
            bottom: -50px;
            right: -50px;
            animation-delay: 2s;
        }

        .circle3 {
            width: 200px;
            height: 200px;
            background: #fff;
            top: 50%;
            right: 10%;
            animation-delay: 4s;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(30px); }
        }

        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 800px;
        }

        .hero-title {
            font-size: 3.8rem;
            font-weight: 900;
            color: #fff;
            margin-bottom: 1.5rem;
            animation: slideDown 0.8s ease-out;
            letter-spacing: -1px;
            line-height: 1.1;
        }

        .highlight-word {
            background: linear-gradient(90deg, #7c3aed 0%, #ec4899 50%, #f97316 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: inline-block;
            animation: cycleWords 12s ease-in-out infinite;
            min-width: 200px;
            height: 1.2em;
            position: relative;
        }

        @keyframes cycleWords {
            0% { 
                opacity: 1;
            }
            24% { 
                opacity: 1;
            }
            25% { 
                opacity: 0;
            }
            26% { 
                opacity: 0;
            }
            27% { 
                opacity: 1;
            }
            49% { 
                opacity: 1;
            }
            50% { 
                opacity: 0;
            }
            51% { 
                opacity: 0;
            }
            52% { 
                opacity: 1;
            }
            74% { 
                opacity: 1;
            }
            75% { 
                opacity: 0;
            }
            76% { 
                opacity: 0;
            }
            77% { 
                opacity: 1;
            }
            100% { 
                opacity: 1;
            }
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero-subtitle {
            font-size: 1.1rem;
            color: rgba(255,255,255,.95);
            max-width: 600px;
            margin: 0 auto 2.5rem;
            line-height: 1.7;
            animation: slideDown 0.8s ease-out 0.2s backwards;
        }

        .hero-buttons {
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            flex-wrap: wrap;
            animation: slideDown 0.8s ease-out 0.4s backwards;
            margin-bottom: 3rem;
        }

        .btn-primary {
            background: #fff;
            color: #8b5fbf;
            padding: 1rem 2.5rem;
            border: none;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,.15);
        }

        .btn-primary:hover {
            transform: translateY(-4px);
            box-shadow: 0 15px 40px rgba(0,0,0,.2);
        }

        .btn-secondary {
            background: transparent;
            color: #fff;
            padding: 1rem 2.5rem;
            border: 2px solid #fff;
            border-radius: 50px;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: rgba(255,255,255,.15);
            transform: translateY(-4px);
        }

        /* Stats section */
        .hero-stats {
            display: flex;
            gap: 3rem;
            justify-content: center;
            flex-wrap: wrap;
            animation: slideDown 0.8s ease-out 0.6s backwards;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 900;
            color: #fff;
        }

        .stat-label {
            font-size: 0.9rem;
            color: rgba(255,255,255,.85);
            margin-top: 0.5rem;
        }

        /* ================= FEATURES (FLOATING) ================= */
        .features-section {
            margin-top: -6rem;
            position: relative;
            z-index: 1;
            padding: 0 1rem 4rem;
        }

        .features-container {
            background: #fff;
            max-width: 900px;
            margin: 0 auto;
            padding: 2.5rem;
            border-radius: 24px; 
            box-shadow: 0 20px 60px rgba(0,0,0,.18);
            position: relative;
            z-index: 1;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 2rem;
        }

        .feature-item {
            display: flex;
            gap: 1rem;
            align-items: flex-start;
            transition: transform 0.3s ease;
        }

        .feature-item:hover {
            transform: translateX(8px);
        }

        .feature-icon {
            width: 52px;
            height: 52px;
            background: #f3eaff;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #8b5fbf;
            font-size: 1.4rem;
            flex-shrink: 0;
            transition: all 0.3s ease;
        }

        .feature-item:hover .feature-icon {
            background: #8b5fbf;
            color: #fff;
            transform: scale(1.1);
        }

        .feature-text h4 {
            font-size: 0.95rem;
            font-weight: 700;
            color: #333;
            margin-bottom: .25rem;
        }

        .feature-text p {
            font-size: 0.85rem;
            color: #666;
            line-height: 1.5;
        }

        /* ================= CARDS (WHITE SECTION) ================= */
        .cards-section {
            background: #fff;
            padding: 6rem 1rem;
        }

        .section-header {
            text-align: center;
            margin-bottom: 4rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .section-header h2 {
            font-size: 2.5rem;
            font-weight: 900;
            color: #333;
            margin-bottom: 1rem;
        }

        .section-header p {
            font-size: 1.1rem;
            color: #666;
            line-height: 1.6;
        }

        .cards-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
        }

        .card-item {
            background: #fff;
            border-radius: 22px;
            padding: 2.5rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,.1);
            transition: .3s ease;
            position: relative;
            overflow: hidden;
        }

        .card-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #d4a5ff, #8b5fbf);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }

        .card-item:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 50px rgba(0,0,0,.18);
        }

        .card-item:hover::before {
            transform: scaleX(1);
        }

        .card-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, #d4a5ff, #b88ad4);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.3rem;
            color: #fff;
            transition: transform 0.3s ease;
        }

        .card-item:hover .card-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .card-item h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #333;
            margin-bottom: .75rem;
        }

        .card-item p {
            font-size: .95rem;
            color: #666;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .card-link {
            display: inline-block;
            color: #8b5fbf;
            font-weight: 600;
            text-decoration: none;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            position: relative;
        }

        .card-link::after {
            content: '→';
            margin-left: 0.5rem;
            transition: transform 0.3s ease;
        }

        .card-link:hover::after {
            transform: translateX(4px);
        }

        /* ================= RESPONSIVE ================= */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.2rem;
            }

            .hero-subtitle {
                font-size: 1rem;
                margin-bottom: 2rem;
            }

            .hero-buttons {
                gap: 1rem;
                margin-bottom: 2rem;
            }

            .btn-primary, .btn-secondary {
                padding: 0.9rem 2rem;
                font-size: 0.95rem;
            }

            .hero-stats {
                gap: 2rem;
            }

            .stat-number {
                font-size: 2rem;
            }

            .features-section {
                margin-top: -4rem;
            }

            .section-header h2 {
                font-size: 1.8rem;
            }
        }
.featured-event {
    padding: 4rem 0;
    background: #fff;
}

.event-header {
    display: grid;
    grid-template-columns: 1fr auto 1fr;
    align-items: end;
    margin-bottom: 1.5rem;
}

.event-header > div:first-child {
    grid-column: 2;
    text-align: center;
}

.event-nav {
    grid-column: 3;
    justify-self: end;
}


.event-title {
    font-size: 2.4rem;
    font-weight: 800;
    color: #111827;
}

.event-subtitle {
    font-size: 1.1rem;
    color: #6b7280;
    margin-top: 4px;
}


.swiper-button-next,
.swiper-button-prev {
    position: static;
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: #f3f4f6;
    color: #374151;
    box-shadow: 0 4px 12px rgba(0,0,0,.1);
}

.swiper-button-next:hover,
.swiper-button-prev:hover {
    background: #7c3aed;
    color: #fff;
}

.swiper-button-next::after,
.swiper-button-prev::after {
    font-size: 14px;
    font-weight: bold;
}


.swiper-slide {
    height: auto;
}

.event-nav {
    display: flex;
    gap: 10px;
}

.event-nav .swiper-button-prev,
.event-nav .swiper-button-next {
    position: static;
    margin: 0;
}

    </style>
    <!-- HERO -->
    <section class="hero-section">
        <div class="hero-bg-circles">
            <div class="circle circle1"></div>
            <div class="circle circle2"></div>
            <div class="circle circle3"></div>
        </div>

        <div class="hero-content">
            <h1 class="hero-title">GET YOUR TICKET,<br><span class="highlight-word" data-words="Simplified,Effective,Reliable,Instant">Simplified</span></h1>
            <p class="hero-subtitle">
                Semua tiket event dalam satu platform.<br>
                Cepat, aman, dan langsung dari penyelenggara.
            </p>

            <div class="hero-buttons">
                <a href="$BaseHref/event" class="btn-primary">
                    Cari Tiket Sekarang
                </a>
            </div>
          
        </div>
    </section>

    <!-- HERO -->
    <script>
        const words = ['Simplified', 'Effective', 'Reliable', 'Instant'];
        let currentIndex = 0;
        const highlightElement = document.querySelector('.highlight-word');

        setInterval(() => {
            currentIndex = (currentIndex + 1) % words.length;
            highlightElement.textContent = words[currentIndex];
        }, 3000);
    </script>

    <!-- FEATURES FLOATING -->
    <section class="features-section">
        <div class="features-container">
            <div class="features-grid">

                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <div class="feature-text">
                        <h4>Pembayaran Aman</h4>
                        <p>Transaksi terlindungi dengan enkripsi terbaru</p>
                    </div>
                </div>

                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fa-solid fa-bolt"></i>
                    </div>
                    <div class="feature-text">
                        <h4>Proses Cepat</h4>
                        <p>Verifikasi instan kurang dari 1 menit</p>
                    </div>
                </div>

                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fa-solid fa-envelope"></i>
                    </div>
                    <div class="feature-text">
                        <h4>Tiket via Email</h4>
                        <p>Langsung masuk ke inbox Anda</p>
                    </div>
                </div>

            </div>
        </div>
    </section>

<section class="page-event">
    <div class="container pt-5">
        <div class="event-header">
            <div>
                <h2 class="event-title">Event Terdekat</h2>
                <p class="event-subtitle">Jangan lewatkan event yang akan datang</p>
            </div>

            <div class="event-nav">
                <div class="swiper-button-prev upcoming-prev"></div>
                <div class="swiper-button-next upcoming-next"></div>
            </div>
        </div>

        <div class="swiper upcoming-swiper">
            <div class="swiper-wrapper">
                <% loop $UpcomingTickets %>
                    <div class="swiper-slide">
                        <% include TicketCard %>
                    </div>
                <% end_loop %>
            </div>
        </div>
    </div>
</section>

<section class="page-event">
    <div class="container pt-5">
        <div class="event-header">
            <div>
                <h2 class="event-title">Event Berakhir</h2>
                <p class="event-subtitle">Event yang sudah selesai</p>
            </div>

            <div class="event-nav">
                <div class="swiper-button-prev expired-prev"></div>
                <div class="swiper-button-next expired-next"></div>
            </div>
        </div>

        <div class="swiper expired-swiper">
            <div class="swiper-wrapper">
                <% loop $ExpiredTickets %>
                    <div class="swiper-slide">
                        <% include TicketCard %>
                    </div>
                <% end_loop %>
            </div>
        </div>
    </div>
</section>

    <!-- WHITE SECTION -->
    <section class="cards-section">
        <div class="cards-container">
            <div class="section-header">
                <h2>Jenis Event</h2>
                <p>Temukan berbagai kategori event menarik dengan harga terbaik dan pengalaman terpercaya.</p>
            </div>

            <div class="cards-grid">

                <div class="card-item">
                    <div class="card-icon">
                        <i class="fa-solid fa-music"></i>
                    </div>
                    <h3>Konser Musik</h3>
                    <p>Nikmati pengalaman live music artis favorit Anda dengan kualitas suara terbaik.</p>
                </div>

                <div class="card-item">
                    <div class="card-icon">
                        <i class="fa-solid fa-film"></i>
                    </div>
                    <h3>Festival Film</h3>
                    <p>Akses premiere film dan acara eksklusif bersama komunitas pecinta film.</p>
                </div>

                <div class="card-item">
                    <div class="card-icon">
                        <i class="fa-solid fa-users"></i>
                    </div>
                    <h3>Event Komunitas</h3>
                    <p>Temukan dan ikuti event komunitas terbaik sesuai minat dan passion Anda.</p>
                </div>

            </div>
        </div>
    </section>

<script>
document.addEventListener("DOMContentLoaded", function () {
new Swiper(".upcoming-swiper", {
    slidesPerView: 2,
    spaceBetween: 16,

    autoplay: {
        delay: 3000,
        disableOnInteraction: false,
        pauseOnMouseEnter: true,        
    },

    loop: true, 

    navigation: {
        nextEl: ".upcoming-next",
        prevEl: ".upcoming-prev",
    },

    breakpoints: {
        576: { slidesPerView: 2 },
        768: { slidesPerView: 3 },
        1200: { slidesPerView: 4 },
    },
});
new Swiper(".expired-swiper", {
    slidesPerView: 2,
    spaceBetween: 16,

    autoplay: {
        delay: 4000,
        disableOnInteraction: false,
        pauseOnMouseEnter: true,
    },

    loop: true,

    navigation: {
        nextEl: ".expired-next",
        prevEl: ".expired-prev",
    },

    breakpoints: {
        576: { slidesPerView: 2 },
        768: { slidesPerView: 3 },
        1200: { slidesPerView: 4 },
    },
});

});


</script>

