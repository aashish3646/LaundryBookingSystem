<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%
    String contextPath = request.getContextPath();
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    if (bookings == null) {
        response.sendRedirect(contextPath + "/bookings?action=my-orders");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<header class="site-header">
    <nav class="navbar">
        <a class="brand" href="<%= contextPath %>/user/dashboard.jsp"><span class="brand-mark">QW</span><span>QuickWash</span></a>
        <div class="nav-links">
            <a href="<%= contextPath %>/user/dashboard.jsp">Dashboard</a>
            <a href="<%= contextPath %>/bookings?action=new">Book Laundry</a>
            <a class="active" href="<%= contextPath %>/bookings?action=my-orders">My Orders</a>
            <a href="<%= contextPath %>/bookings?action=track">Track Status</a>
            <a href="<%= contextPath %>/user/profile.jsp">Profile</a>
            <a class="nav-button" href="<%= contextPath %>/logout">Logout</a>
        </div>
    </nav>
</header>

<main class="dashboard-content">
    <section class="welcome-block">
        <h2>My Orders</h2>
        <p class="muted">Only your own bookings are shown here.</p>
    </section>

    <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>
    <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

    <section class="table-card">
        <div class="panel-title">
            <h2>Booking History</h2>
            <a class="btn btn-primary btn-small" href="<%= contextPath %>/bookings?action=new">Book Laundry</a>
        </div>
        <table>
            <thead>
            <tr>
                <th>Booking ID</th>
                <th>Vendor</th>
                <th>Service</th>
                <th>Slot</th>
                <th>Pickup</th>
                <th>Items</th>
                <th>Status</th>
                <th>Created</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% if (bookings == null || bookings.isEmpty()) { %>
                <tr><td colspan="9">No orders found. Create your first laundry booking.</td></tr>
            <% } else {
                for (Booking booking : bookings) {
            %>
                <tr>
                    <td>#QW-<%= booking.getBookingId() %></td>
                    <td><%= booking.getVendorName() %></td>
                    <td><%= booking.getServiceName() %></td>
                    <td><span class="table-main"><%= booking.getSlotDate() %></span><span class="table-sub"><%= booking.getSlotTime() %></span></td>
                    <td><%= booking.getPickupAddress() %></td>
                    <td><span class="table-main"><%= booking.getClothesType() %></span><span class="table-sub">Qty: <%= booking.getQuantity() %></span></td>
                    <td><span class="badge <%= "Cancelled".equals(booking.getBookingStatus()) ? "badge-grey" : "Pending".equals(booking.getBookingStatus()) ? "badge-amber" : "Delivered".equals(booking.getBookingStatus()) ? "badge-green" : "badge-blue" %>"><%= booking.getBookingStatus() %></span></td>
                    <td><%= booking.getCreatedAt() %></td>
                    <td>
                        <div class="table-actions">
                            <% if ("Pending".equals(booking.getBookingStatus())) { %>
                                <a class="btn btn-danger btn-small" href="<%= contextPath %>/bookings?action=cancel&id=<%= booking.getBookingId() %>" onclick="return confirm('Cancel this pending booking?');">Cancel</a>
                            <% } %>
                            <% if ("Delivered".equals(booking.getBookingStatus())) { %>
                                <a class="btn btn-primary btn-small" href="<%= contextPath %>/feedback?booking_id=<%= booking.getBookingId() %>">Rate Service</a>
                            <% } %>
                            <a class="btn btn-secondary btn-small" href="<%= contextPath %>/bookings?action=receipt&id=<%= booking.getBookingId() %>" target="_blank">View Receipt</a>
                        </div>
                    </td>
                </tr>
            <% } } %>
            </tbody>
        </table>
    </section>
</main>
</body>
</html>
