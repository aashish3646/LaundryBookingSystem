<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%
    String contextPath = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
    String errorType = request.getParameter("error");
    String rememberedEmail = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("rememberedEmail".equals(cookie.getName())) {
                rememberedEmail = cookie.getValue();
                break;
            }
        }
    }
    String escapedRememberedEmail = rememberedEmail
            .replace("&", "&amp;")
            .replace("\"", "&quot;")
            .replace("<", "&lt;")
            .replace(">", "&gt;");
    if (error == null && "login_required".equals(errorType)) {
        error = "Please login to access that page.";
    } else if (error == null && "unauthorized".equals(errorType)) {
        error = "You are not authorized to access that dashboard.";
    }
    if (success == null) {
        success = (String) session.getAttribute("success");
        session.removeAttribute("success");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | QuickWash</title>
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
            <a class="nav-link" href="<%= contextPath %>/contact.jsp">Contact</a>
            <a class="nav-link active" href="<%= contextPath %>/login.jsp">Login</a>
            <a class="nav-button" href="<%= contextPath %>/register.jsp">Register</a>
        </div>
    </nav>
</header>

<main class="auth-shell">
    <section class="auth-visual">
        <div>
            <h1>Fresh clothes, delivered daily.</h1>
            <p>
                QuickWash bridges local laundry vendors and digital convenience across Nepal with
                transparent Rs. pricing and role-based dashboards.
            </p>
            <div class="auth-feature">
                <span class="icon-box">V</span>
                <div>
                    <strong>Verified Vendors</strong>
                    <p>Local laundry partners in Kathmandu, Itahari, Dharan, and Biratnagar.</p>
                </div>
            </div>
            <div class="auth-feature">
                <span class="icon-box">P</span>
                <div>
                    <strong>Doorstep Pickup</strong>
                    <p>Track laundry orders from pickup to delivery in one clean flow.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="auth-page">
        <div class="auth-card-plain">
            <a class="auth-brand" href="<%= contextPath %>/index.jsp">
                <span class="brand-mark">QW</span>
                <span>QuickWash</span>
            </a>
            <h1>Welcome Back</h1>
            <p class="muted">Manage your laundry services effortlessly.</p>

            <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>
            <% if (success != null) { %>
                <div class="alert alert-success"><%= success %></div>
            <% } %>

            <form action="<%= contextPath %>/login" method="post" class="form">
                <div>
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="admin@quickwash.com" value="<%= escapedRememberedEmail %>" required>
                </div>

                <div>
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>

                <label class="checkbox-row" for="rememberEmail">
                    <input type="checkbox" id="rememberEmail" name="rememberEmail" <%= rememberedEmail.isEmpty() ? "" : "checked" %>>
                    <span>Remember my email</span>
                </label>

                <button type="submit" class="btn btn-primary btn-full">Login</button>
            </form>

            <p class="form-link">Don't have an account? <a href="<%= contextPath %>/register.jsp">Register Now</a></p>
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
