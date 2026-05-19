<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body class="public-page">
<header class="site-header">
    <nav class="nav-container">
        <a class="brand" href="<%= contextPath %>/index.jsp">
            <span class="brand-mark">QW</span>
            <span>QuickWash</span>
        </a>
        <div class="nav-links">
            <a class="nav-link" href="<%= contextPath %>/index.jsp">Home</a>
            <a class="nav-link" href="<%= contextPath %>/about.jsp">About</a>
            <a class="nav-link active" href="<%= contextPath %>/contact.jsp">Contact</a>
            <a class="nav-link" href="<%= contextPath %>/login.jsp">Login</a>
            <a class="nav-button" href="<%= contextPath %>/register.jsp">Register</a>
        </div>
    </nav>
</header>

<main class="contact-layout">
    <section class="form-card">
        <p class="eyebrow">Support</p>
        <h1>Contact QuickWash</h1>
        <p class="muted">Send your question, vendor request, or booking support message.</p>

        <% if (error != null) { %>
            <div class="alert alert-error"><%= error %></div>
        <% } %>
        <% if (success != null) { %>
            <div class="alert alert-success"><%= success %></div>
        <% } %>

        <form action="<%= contextPath %>/contact" method="post" class="form">
            <div>
                <label for="name">Name</label>
                <input type="text" id="name" name="name" placeholder="Purusottam Subedi" required>
            </div>

            <div>
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="name@example.com" required>
            </div>

            <div>
                <label for="subject">Subject</label>
                <input type="text" id="subject" name="subject" placeholder="Vendor registration request" required>
            </div>

            <div>
                <label for="message">Message</label>
                <textarea id="message" name="message" rows="5" placeholder="Write your message here..." required></textarea>
            </div>

            <button type="submit" class="btn btn-primary btn-full">Send Message</button>
        </form>
    </section>

    <aside class="contact-card">
        <h2>QuickWash Office</h2>
        <p><strong>Location:</strong> Itahari, Sunsari, Nepal</p>
        <p><strong>Phone:</strong> 98XXXXXXXX</p>
        <p><strong>Email:</strong> support@quickwash.com.np</p>
        <div class="contact-note">
            Serving laundry customers and vendors across Itahari, Dharan, Biratnagar, and Kathmandu.
        </div>
    </aside>
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
