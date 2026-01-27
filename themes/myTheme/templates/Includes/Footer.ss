<footer class="footer-gradient pt-5 pb-4">
    <div class="container">
        <div class="row">

            <!-- LOGO + SLOGAN -->
            <div class="col-md-4 mb-4 mb-md-0 text-md-start">
                <div class="d-flex flex-column align-items-md-start align-items-center">
                    <% if $SiteConfig.logo %>
                        <img src="$SiteConfig.logo.URL" 
                             alt="Logo" 
                             class="img-fluid" 
                             style="max-height:80px; margin-bottom: -5px;">
                    <% end_if %>

                    <p class="fw-semibold mt-2 slogan-text">GET YOUR TICKET</p>
                </div>
            </div>

            <!-- NAVIGATION -->
            <div class="col-md-4 mb-4 mb-md-0 text-md-start text-center">
                <nav class="footer-nav">
                    <ul class="list-unstyled m-0 p-0">
                        <li class="my-2"><a href="$BaseHref/Home" class="footer-link">HOME</a></li>
                        <li class="my-2"><a href="$BaseHref/event" class="footer-link">EVENTS</a></li>
                        <li class="my-2"><a href="$BaseHref/wishlist" class="footer-link">WISHLIST</a></li>
                    </ul>
                </nav>
            </div>

            <!-- CONTACT -->
            <div class="col-md-4 text-md-start text-center">
                <h6 class="fw-bold mb-3">CONTACT US</h6>

                <p class="mb-2">
                    <i class="bi bi-geo-alt footer-icon"></i>
                    $SiteConfig.Address
                </p>

                <p class="mb-2">
                    <i class="bi bi-envelope footer-icon"></i>
                    $SiteConfig.Email
                </p>

                <p class="mb-0">
                    <i class="bi bi-telephone footer-icon"></i>
                    $SiteConfig.Phone
                </p>
            </div>

        </div>
    </div>
</footer>

<style>
/* Bagian atas putih, bawah gradient ungu */
.footer-gradient {
    background: #f3d7ff;
    color: #000;
}

/* GET YOUR TICKET lebih rapat dengan logo */
.slogan-text {
    margin-top: -10px;
    letter-spacing: 1px;
    font-weight: 600;
}

/* Menu */
.footer-link {
    text-decoration: none;
    color: #000;
    font-weight: 600;
    letter-spacing: .5px;
    font-size: 15px;
}

.footer-link:hover {
    color: #7a35d3;
}

/* Icon warna ungu pastel */
.footer-icon {
    color: #7a35d3;
    font-size: 17px;
    margin-right: 6px;
}

/* Rata kiri biar mirip desain */
.footer-nav ul li {
    text-align: left;
}

</style>