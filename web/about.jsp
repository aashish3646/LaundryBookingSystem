<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body class="public-page about-page">
<header class="site-header">
    <nav class="nav-container">
        <a class="brand" href="<%= contextPath %>/index.jsp">
            <span class="brand-mark">QW</span>
            <span>QuickWash</span>
        </a>
        <div class="nav-links">
            <a class="nav-link" href="<%= contextPath %>/index.jsp">Home</a>
            <a class="nav-link active" href="<%= contextPath %>/about.jsp">About</a>
            <a class="nav-link" href="<%= contextPath %>/contact.jsp">Contact</a>
            <a class="nav-link" href="<%= contextPath %>/login.jsp">Login</a>
            <a class="nav-button" href="<%= contextPath %>/register.jsp">Register</a>
        </div>
    </nav>
</header>

<main>
    <section class="page-hero">
        <p class="eyebrow">About QuickWash</p>
        <h1>Nepal-based laundry booking and vendor management</h1>
        <p>
            QuickWash is a simple dynamic web application designed for laundry customers, vendors,
            and administrators. It helps users book services, choose pickup slots, track laundry
            orders, and connect with local vendors around Itahari, Dharan, Biratnagar, and Kathmandu.
        </p>
    </section>

    <section class="section">
        <div class="card-grid three">
            <article class="card">
                <h3>For Customers</h3>
                <p>Users can book Wash Only, Wash and Iron, Dry Cleaning, Blanket Wash, and Express Service.</p>
            </article>
            <article class="card">
                <h3>For Vendors</h3>
                <p>Vendors like Himalayan Dhobi Service and Itahari Fresh Wash can manage assigned orders.</p>
            </article>
            <article class="card">
                <h3>For Admins</h3>
                <p>Admins can manage users, vendors, services, orders, and reports from a central dashboard.</p>
            </article>
        </div>
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
