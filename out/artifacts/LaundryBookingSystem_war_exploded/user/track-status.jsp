<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%
    String contextPath = request.getContextPath();
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null) {
        response.sendRedirect(contextPath + "/bookings?action=track");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Status | QuickWash</title>
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
            <a class="active" href="<%= contextPath %>/bookings?action=track">Track Status</a>
            <a href="<%= contextPath %>/user/profile.jsp">Profile</a>
            <a class="nav-button" href="<%= contextPath %>/logout">Logout</a>
        </div>
    </nav>
</header>

<main class="dashboard-content">
    <section class="welcome-block">
        <h2>Track Status</h2>
        <p class="muted">Follow each order from Pending to Delivered.</p>
    </section>

    <section class="card-grid">
        <% if (bookings == null || bookings.isEmpty()) { %>
            <article class="card"><h3>No orders yet</h3><p>Create a booking to start tracking laundry status.</p></article>
        <% } else {
            for (Booking booking : bookings) {
                String status = booking.getBookingStatus();
        %>
            <article class="card">
                <div class="panel-title">
                    <h3>#QW-<%= booking.getBookingId() %> - <%= booking.getServiceName() %></h3>
                    <span class="badge <%= "Cancelled".equals(status) ? "badge-grey" : "Pending".equals(status) ? "badge-amber" : "Delivered".equals(status) ? "badge-green" : "badge-blue" %>"><%= status %></span>
                </div>
                <p><strong>Vendor:</strong> <%= booking.getVendorName() %></p>
                <p><strong>Slot:</strong> <%= booking.getSlotDate() %> at <%= booking.getSlotTime() %></p>
                <div class="status-flow">
                    <span class="<%= "Pending".equals(status) ? "active" : "" %>">Pending</span>
                    <span class="<%= "Accepted".equals(status) ? "active" : "" %>">Accepted</span>
                    <span class="<%= "Picked Up".equals(status) ? "active" : "" %>">Picked Up</span>
                    <span class="<%= "Washing".equals(status) ? "active" : "" %>">Washing</span>
                    <span class="<%= "Ready".equals(status) ? "active" : "" %>">Ready</span>
                    <span class="<%= "Delivered".equals(status) ? "active" : "" %>">Delivered</span>
                    <span class="<%= "Cancelled".equals(status) ? "active cancelled" : "" %>">Cancelled</span>
                </div>
            </article>
        <% } } %>
    </section>
</main>
</body>
</html>
