<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%
    String contextPath = request.getContextPath();
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Orders | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<div class="dashboard-shell">
    <aside class="sidebar">
        <a class="brand" href="<%= contextPath %>/admin"><span class="brand-mark">QW</span><span>Admin Panel</span></a>
        <p class="sidebar-label">QuickWash management</p>
        <nav class="side-nav">
            <a href="<%= contextPath %>/admin"><span class="side-icon">DB</span>Dashboard</a>
            <a href="<%= contextPath %>/admin?action=users"><span class="side-icon">US</span>Manage Users</a>
            <a href="<%= contextPath %>/vendors?action=list"><span class="side-icon">VN</span>Manage Vendors</a>
            <a href="<%= contextPath %>/services?action=list"><span class="side-icon">SV</span>Manage Services</a>
            <a class="active" href="<%= contextPath %>/admin?action=orders"><span class="side-icon">OR</span>All Orders</a>
            <a href="<%= contextPath %>/admin?action=reports"><span class="side-icon">RP</span>Reports</a>
        </nav>
        <div class="sidebar-bottom"><nav class="side-nav"><a href="<%= contextPath %>/index.jsp"><span class="side-icon">HM</span>Public Site</a><a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a></nav></div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar"><h1>All Orders</h1></header>
        <section class="dashboard-content">
            <section class="table-card">
                <div class="panel-title"><h2>Booking Records</h2></div>
                <table>
                    <thead>
                    <tr>
                        <th>Order</th>
                        <th>Customer</th>
                        <th>Vendor</th>
                        <th>Service</th>
                        <th>Slot</th>
                        <th>Status</th>
                        <th>Total</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (bookings == null || bookings.isEmpty()) { %>
                        <tr><td colspan="7">No bookings found yet. This table will populate once customers place orders.</td></tr>
                    <% } else {
                        for (Booking booking : bookings) {
                    %>
                        <tr>
                            <td><span class="table-main">#QW-<%= booking.getBookingId() %></span><span class="table-sub"><%= booking.getCreatedAt() %></span></td>
                            <td><span class="table-main"><%= booking.getCustomerName() %></span><span class="table-sub"><%= booking.getPickupAddress() %></span></td>
                            <td><%= booking.getVendorName() %></td>
                            <td><%= booking.getServiceName() %></td>
                            <td><span class="table-main"><%= booking.getSlotDate() %></span><span class="table-sub"><%= booking.getSlotTime() %></span></td>
                            <td><span class="badge badge-blue"><%= booking.getBookingStatus() %></span></td>
                            <td><strong>Rs. <%= String.format("%.2f", booking.getServicePrice()) %></strong></td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
            </section>
        </section>
    </main>
</div>
</body>
</html>
