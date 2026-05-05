<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.User" %>
<%
    String contextPath = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");
    User user = null;
    if (userId != null) {
        user = new UserDAO().getUserById(userId);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<header class="site-header">
    <nav class="navbar">
        <a class="brand" href="<%= contextPath %>/user/dashboard.jsp"><span class="brand-mark">QW</span><span>QuickWash</span></a>
        <div class="nav-links">
            <a href="<%= contextPath %>/user/dashboard.jsp">Dashboard</a>
            <a href="<%= contextPath %>/bookings?action=new">Book Laundry</a>
            <a href="<%= contextPath %>/bookings?action=my-orders">My Orders</a>
            <a href="<%= contextPath %>/bookings?action=track">Track Status</a>
            <a class="active" href="<%= contextPath %>/user/profile.jsp">Profile</a>
            <a class="nav-button" href="<%= contextPath %>/logout">Logout</a>
        </div>
    </nav>
</header>

<main class="dashboard-content">
    <section class="welcome-block">
        <h2>Profile</h2>
        <p class="muted">Your QuickWash account details.</p>
    </section>

    <section class="panel">
        <% if (user == null) { %>
            <div class="alert alert-error">Unable to load profile details.</div>
        <% } else { %>
            <div class="card-grid three">
                <article class="card"><span class="table-sub">Name</span><h3><%= user.getName() %></h3></article>
                <article class="card"><span class="table-sub">Email</span><h3><%= user.getEmail() %></h3></article>
                <article class="card"><span class="table-sub">Phone</span><h3><%= user.getPhone() %></h3></article>
                <article class="card"><span class="table-sub">Role</span><h3><%= user.getRole() %></h3></article>
                <article class="card"><span class="table-sub">Status</span><h3><%= user.getStatus() %></h3></article>
                <article class="card"><span class="table-sub">Created</span><h3><%= user.getCreatedAt() %></h3></article>
            </div>
        <% } %>
    </section>
</main>
</body>
</html>
