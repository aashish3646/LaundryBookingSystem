<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%
    String contextPath = request.getContextPath();
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    if (bookings == null) {
        response.sendRedirect(contextPath + "/vendor?action=orders");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Orders | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<div class="dashboard-shell">
    <aside class="sidebar">
        <a class="brand" href="<%= contextPath %>/vendor"><span class="brand-mark">QW</span><span>QuickWash</span></a>
        <p class="sidebar-label">Vendor portal</p>
        <nav class="side-nav">
            <a href="<%= contextPath %>/vendor"><span class="side-icon">DB</span>Dashboard</a>
            <a class="active" href="<%= contextPath %>/vendor?action=orders"><span class="side-icon">OR</span>Orders</a>
            <a href="<%= contextPath %>/vendor?action=availability"><span class="side-icon">AV</span>Availability</a>
        </nav>
        <div class="sidebar-bottom"><nav class="side-nav"><a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a></nav></div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar"><h1>Vendor Orders</h1></header>
        <section class="dashboard-content">
            <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

            <section class="table-card">
                <div class="panel-title"><h2>Assigned Booking Records</h2></div>
                <table>
                    <thead>
                    <tr>
                        <th>Booking</th>
                        <th>Customer</th>
                        <th>Service</th>
                        <th>Slot</th>
                        <th>Pickup</th>
                        <th>Items</th>
                        <th>Note</th>
                        <th>Status</th>
                        <th>Created</th>
                        <th>Update</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (bookings.isEmpty()) { %>
                        <tr><td colspan="10">No assigned orders yet.</td></tr>
                    <% } else {
                        for (Booking booking : bookings) {
                    %>
                        <tr>
                            <td>#QW-<%= booking.getBookingId() %></td>
                            <td><%= booking.getCustomerName() %></td>
                            <td><%= booking.getServiceName() %></td>
                            <td><span class="table-main"><%= booking.getSlotDate() %></span><span class="table-sub"><%= booking.getSlotTime() %></span></td>
                            <td><%= booking.getPickupAddress() %></td>
                            <td><span class="table-main"><%= booking.getClothesType() %></span><span class="table-sub">Qty: <%= booking.getQuantity() %></span></td>
                            <td><%= booking.getPickupNote() != null ? booking.getPickupNote() : "" %></td>
                            <td><span class="badge badge-blue"><%= booking.getBookingStatus() %></span></td>
                            <td><%= booking.getCreatedAt() %></td>
                            <td>
                                <form action="<%= contextPath %>/vendor?action=update-status" method="post" class="inline-form">
                                    <input type="hidden" name="booking_id" value="<%= booking.getBookingId() %>">
                                    <select name="status" required>
                                        <option value="Accepted">Accepted</option>
                                        <option value="Picked Up">Picked Up</option>
                                        <option value="Washing">Washing</option>
                                        <option value="Ready">Ready</option>
                                        <option value="Delivered">Delivered</option>
                                        <option value="Cancelled">Cancelled</option>
                                    </select>
                                    <button type="submit" class="btn btn-primary btn-small">Save</button>
                                </form>
                            </td>
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
