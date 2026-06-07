<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuickWash | Laundry Booking in Nepal</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body class="public-page home-page">
<header class="site-header">
    <nav class="nav-container">
        <a class="brand" href="<%= contextPath %>/index.jsp">
            <span class="brand-mark">QW</span>
            <span>QuickWash</span>
        </a>
        <div class="nav-links">
            <a class="nav-link active" href="<%= contextPath %>/index.jsp">Home</a>
            <a class="nav-link" href="<%= contextPath %>/about.jsp">About</a>
            <a class="nav-link" href="<%= contextPath %>/contact.jsp">Contact</a>
            <a class="nav-link" href="<%= contextPath %>/login.jsp">Login</a>
            <a class="nav-button" href="<%= contextPath %>/register.jsp">Register</a>
        </div>
    </nav>
</header>

<main>
    <section class="hero home-hero">
        <div class="hero-content">
            <h1>Fast, Reliable Laundry Booking in Nepal</h1>
            <p class="hero-text">
                Experience the ultimate convenience of digital laundry management. Book online,
                schedule professional pickups, and track your clothes from wash to delivery across
                Kathmandu and beyond.
            </p>
            <div class="hero-actions">
                <a class="btn btn-primary" href="<%= contextPath %>/register.jsp">Get Started</a>
                <a class="btn btn-secondary" href="<%= contextPath %>/login.jsp">Sign In</a>
            </div>
            
            <!-- Public Search Bar -->
            <div class="public-search mt-2">
                <form action="<%= contextPath %>/login.jsp" method="get" class="search-form-hero">
                    <input type="text" name="query" placeholder="Search laundry near you (e.g. Kathmandu)...">
                    <button type="submit" class="btn btn-primary">Search</button>
                </form>
                <p class="small muted mt-1">Try "Dharan" or "Wash and Iron"</p>
            </div>
            <div class="trust-row">
                <span><i class="dot"></i>100% Insured</span>
                <span><i class="dot"></i>Verified Vendors</span>
            </div>
        </div>

        <div class="hero-image-panel">
            <div class="hero-image-card">
                <img src="<%= contextPath %>/images/laundry-hero.svg" alt="Modern laundry machines and folded clothes">
            </div>
        </div>
    </section>

    <section class="section-soft">
        <div class="section-heading center">
            <p class="eyebrow">Why choose QuickWash?</p>
            <h2>Premium laundry management with a local touch</h2>
        </div>
        <div class="card-grid three">
            <article class="card">
                <span class="icon-box">01</span>
                <h3>Easy Booking</h3>
                <p>Schedule your laundry service in under 60 seconds with a clean flow for service, vendor, slot, and address.</p>
            </article>
            <article class="card">
                <span class="icon-box">02</span>
                <h3>Pickup and Delivery</h3>
                <p>Doorstep collection and delivery across Itahari, Dharan, Biratnagar, and Kathmandu.</p>
            </article>
            <article class="card">
                <span class="icon-box">03</span>
                <h3>Trusted Vendors</h3>
                <p>Partner laundries are organized in one system so users, vendors, and admins stay in sync.</p>
            </article>
        </div>
    </section>

    <section class="section">
        <div class="section-heading">
            <p class="eyebrow">Popular services</p>
            <h2>Professional care priced in Rs.</h2>
        </div>
        <div class="service-grid">
            <article class="service-card">
                <div class="service-art"></div>
                <div class="service-body">
                    <span>Wash Only</span>
                    <strong>Rs. 120</strong>
                </div>
            </article>
            <article class="service-card">
                <div class="service-art"></div>
                <div class="service-body">
                    <span>Wash and Iron</span>
                    <strong>Rs. 180</strong>
                </div>
            </article>
            <article class="service-card">
                <div class="service-art"></div>
                <div class="service-body">
                    <span>Dry Cleaning</span>
                    <strong>Rs. 350</strong>
                </div>
            </article>
            <article class="service-card">
                <div class="service-art"></div>
                <div class="service-body">
                    <span>Express Service</span>
                    <strong>Rs. 250</strong>
                </div>
            </article>
        </div>
    </section>

    <section class="section vendor-showcase">
        <div>
            <p class="eyebrow">Regional presence</p>
            <h2>Available vendors in Itahari, Dharan, Biratnagar, and Kathmandu</h2>
            <p class="muted">
                QuickWash connects customers with organized local laundry partners for simple ordering,
                transparent prices, and professional service.
            </p>
            <div class="vendor-list">
                <div class="vendor-row">
                    <span><strong>Himalayan Dhobi Service</strong><small>Dharan - expert care</small></span>
                    <strong>Rs. 180+</strong>
                </div>
                <div class="vendor-row">
                    <span><strong>Itahari Fresh Wash</strong><small>Itahari - fast delivery</small></span>
                    <strong>Rs. 120+</strong>
                </div>
            </div>
        </div>
        <div class="hero-image-panel">
            <div class="hero-image-card">
                <img src="<%= contextPath %>/images/laundry-hero.svg" alt="Laundry machines inside a modern cleaning facility">
            </div>
        </div>
    </section>

    <section class="container cta-band">
        <h2>Ready for a cleaner experience?</h2>
        <p>Join QuickWash to book trusted laundry services and manage orders through one simple JSP and Servlet system.</p>
        <a class="btn btn-light" href="<%= contextPath %>/register.jsp">Create Account</a>
    </section>
</main>

<footer class="footer">
    <div class="footer-grid">
        <div>
            <h3>QuickWash</h3>
            <p>Nepal's laundry booking platform for reliable washing, ironing, dry cleaning, and vendor management.</p>
        </div>
        <div>
            <h4>Services</h4>
            <span>Wash and Fold</span>
            <span>Dry Cleaning</span>
            <span>Ironing</span>
        </div>
        <div>
            <h4>Quick Links</h4>
            <a href="<%= contextPath %>/index.jsp">Home</a>
            <a href="<%= contextPath %>/about.jsp">About</a>
            <a href="<%= contextPath %>/contact.jsp">Contact</a>
        </div>
        <div>
            <h4>Contact</h4>
            <span>Itahari, Sunsari, Nepal</span>
            <span>support@quickwash.com.np</span>
        </div>
    </div>
    <div class="footer-bottom">&copy; 2026 QuickWash Nepal. Serving Kathmandu and Itahari.</div>
</footer>
</body>
</html>
