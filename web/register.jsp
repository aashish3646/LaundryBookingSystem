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
    <title>Register | QuickWash</title>
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
            <a class="nav-link" href="<%= contextPath %>/login.jsp">Login</a>
            <a class="nav-button active" href="<%= contextPath %>/register.jsp">Register</a>
        </div>
    </nav>
</header>

<main class="auth-page">
    <section class="form-card wide">
        <div class="register-layout">
            <aside class="promo-card">
                <p class="eyebrow">Join QuickWash</p>
                <h1>Join the future of laundry in Nepal</h1>
                <p>
                    Create a customer or vendor account and access QuickWash booking tools,
                    role dashboards, and local Rs. pricing.
                </p>
                <div class="auth-feature">
                    <span class="icon-box">5K</span>
                    <div>
                        <strong>Trusted by local users</strong>
                        <p>Serving Kathmandu, Itahari, Dharan, and Biratnagar.</p>
                    </div>
                </div>
            </aside>

            <div>
                <p class="eyebrow">Create account</p>
                <h1>Create Account</h1>
                <p class="muted">Enter your details to start your QuickWash journey.</p>

                <% if (error != null) { %>
                    <div class="alert alert-error"><%= error %></div>
                <% } %>
                <% if (success != null) { %>
                    <div class="alert alert-success"><%= success %></div>
                <% } %>

                <form action="<%= contextPath %>/register" method="post" class="form two-column">
                    <div>
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" placeholder="Aashish Ghimire" required>
                    </div>

                    <div>
                        <label for="phone">Phone Number</label>
                        <input type="text" id="phone" name="phone" placeholder="98XXXXXXXX" required>
                    </div>

                    <div class="form-span">
                        <label for="email">Email Address</label>
                        <input type="email" id="email" name="email" placeholder="name@example.com" required>
                    </div>

                    <div class="form-span">
                        <label>Register As</label>
                        <div class="role-options">
                            <label class="role-option">
                                <input type="radio" name="role" value="user" checked required>
                                <span>User</span>
                            </label>
                            <label class="role-option">
                                <input type="radio" name="role" value="vendor" required>
                                <span>Vendor</span>
                            </label>
                        </div>
                    </div>

                    <div>
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" placeholder="Minimum 6 characters" required>
                    </div>

                    <div>
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-full form-span">Register</button>
                </form>

                <p class="form-link">Already have an account? <a href="<%= contextPath %>/login.jsp">Login</a></p>
            </div>
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
