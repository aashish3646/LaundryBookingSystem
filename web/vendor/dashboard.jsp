<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Vendor" %>
<%
    String contextPath = request.getContextPath();
    String userName = (String) session.getAttribute("userName");
    String vendorError = (String) session.getAttribute("vendorError");
    session.removeAttribute("vendorError");
    Vendor vendor = (Vendor) request.getAttribute("vendor");
    if (vendor == null && vendorError == null) {
        response.sendRedirect(contextPath + "/vendor");
        return;
    }
    int assignedOrders = request.getAttribute("assignedOrders") != null ? (Integer) request.getAttribute("assignedOrders") : 0;
    int pendingOrders = request.getAttribute("pendingOrders") != null ? (Integer) request.getAttribute("pendingOrders") : 0;
    int inProgressOrders = request.getAttribute("inProgressOrders") != null ? (Integer) request.getAttribute("inProgressOrders") : 0;
    int deliveredOrders = request.getAttribute("deliveredOrders") != null ? (Integer) request.getAttribute("deliveredOrders") : 0;
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Dashboard | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<div class="dashboard-shell">
    <aside class="sidebar">
        <a class="brand" href="<%= contextPath %>/vendor"><span class="brand-mark">QW</span><span>QuickWash</span></a>
        <p class="sidebar-label">Vendor portal</p>
        <nav class="side-nav">
            <a class="active" href="<%= contextPath %>/vendor"><span class="side-icon">DB</span>Dashboard</a>
            <a href="<%= contextPath %>/vendor?action=orders"><span class="side-icon">OR</span>Orders</a>
            <a href="<%= contextPath %>/vendor?action=availability"><span class="side-icon">AV</span>Availability</a>
        </nav>
        <div class="sidebar-bottom">
            <nav class="side-nav">
                <a href="<%= contextPath %>/index.jsp"><span class="side-icon">HM</span>Public Site</a>
                <a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a>
            </nav>
        </div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar">
            <div class="header-main">
                <h1>Welcome, <%= userName != null ? userName : "Vendor" %></h1>
                <% if (vendor != null) { %>
                    <span class="badge badge-green ml-2">✓ Approved</span>
                <% } %>
            </div>
            <div class="topbar-actions"><span class="avatar">V</span></div>
        </header>

        <section class="dashboard-content">
            <% if (vendorError != null) { %>
                <div class="alert alert-error"><%= vendorError %></div>
            <% } else { %>
                <p class="muted"><%= vendor != null ? vendor.getVendorName() + " - " + vendor.getArea() : "" %></p>

                <div class="stats-grid">
                    <article class="stat-card"><span class="icon-box">AS</span><p>Assigned Orders</p><strong class="stat-value"><%= assignedOrders %></strong></article>
                    <article class="stat-card"><span class="icon-box">PN</span><p>Pending Orders</p><strong class="stat-value"><%= pendingOrders %></strong></article>
                    <article class="stat-card"><span class="icon-box">IP</span><p>In Progress</p><strong class="stat-value"><%= inProgressOrders %></strong></article>
                    <article class="stat-card"><span class="icon-box">DL</span><p>Delivered</p><strong class="stat-value"><%= deliveredOrders %></strong></article>
                </div>

                <div class="dashboard-grid">
                    <section class="table-card">
                        <div class="panel-title">
                            <h2>Recent Orders</h2>
                            <a href="<%= contextPath %>/vendor?action=orders">View Orders</a>
                        </div>
                        <table>
                            <thead>
                            <tr><th>Order</th><th>Customer</th><th>Service</th><th>Status</th><th>Created</th></tr>
                            </thead>
                            <tbody>
                            <% if (bookings == null || bookings.isEmpty()) { %>
                                <tr><td colspan="5">No assigned orders yet.</td></tr>
                            <% } else {
                                int shown = 0;
                                for (Booking booking : bookings) {
                                    if (shown++ >= 5) { break; }
                            %>
                                <tr>
                                    <td>#QW-<%= booking.getBookingId() %></td>
                                    <td><%= booking.getCustomerName() %></td>
                                    <td><%= booking.getServiceName() %></td>
                                    <td><span class="badge badge-blue"><%= booking.getBookingStatus() %></span></td>
                                    <td><%= booking.getCreatedAt() %></td>
                                </tr>
                            <% } } %>
                            </tbody>
                        </table>
                    </section>

                    <aside class="panel quick-actions-blue">
                        <div class="panel-title"><h2>Quick Actions</h2></div>
                        <div class="quick-list">
                            <a class="quick-link" href="<%= contextPath %>/vendor?action=orders">View Orders <strong>Open</strong></a>
                            <a class="quick-link" href="<%= contextPath %>/vendor?action=availability">Manage Availability <strong>Edit</strong></a>
                        </div>
                    </aside>
                </div>
            <% } %>
        </section>
    </main>
</div>
</body>
</html>
