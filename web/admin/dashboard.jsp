<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%
    String contextPath = request.getContextPath();
    String userName = (String) session.getAttribute("userName");
    int totalUsers = request.getAttribute("totalUsers") != null ? (Integer) request.getAttribute("totalUsers") : 0;
    int totalVendors = request.getAttribute("totalVendors") != null ? (Integer) request.getAttribute("totalVendors") : 0;
    int totalServices = request.getAttribute("totalServices") != null ? (Integer) request.getAttribute("totalServices") : 0;
    int totalBookings = request.getAttribute("totalBookings") != null ? (Integer) request.getAttribute("totalBookings") : 0;
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<div class="dashboard-shell">
    <aside class="sidebar">
        <a class="brand" href="<%= contextPath %>/admin">
            <span class="brand-mark">QW</span>
            <span>Admin Panel</span>
        </a>
        <p class="sidebar-label">QuickWash management</p>

        <nav class="side-nav">
            <a class="active" href="<%= contextPath %>/admin"><span class="side-icon">DB</span>Dashboard</a>
            <a href="<%= contextPath %>/admin?action=users"><span class="side-icon">US</span>Manage Users</a>
            <a href="<%= contextPath %>/vendors?action=list"><span class="side-icon">VN</span>Manage Vendors</a>
            <a href="<%= contextPath %>/services?action=list"><span class="side-icon">SV</span>Manage Services</a>
            <a href="<%= contextPath %>/admin?action=orders"><span class="side-icon">OR</span>All Orders</a>
            <a href="<%= contextPath %>/admin?action=reports"><span class="side-icon">RP</span>Reports</a>
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
            <h1>Admin Dashboard</h1>
            <div class="topbar-actions">
                <span class="avatar">A</span>
                <div>
                    <strong><%= userName != null ? userName : "Admin User" %></strong>
                    <span class="table-sub">Super Administrator</span>
                </div>
            </div>
        </header>

        <section class="dashboard-content">
            <div class="stats-grid">
                <article class="stat-card">
                    <span class="icon-box">US</span>
                    <p>Total Users</p>
                    <strong class="stat-value"><%= totalUsers %></strong>
                </article>
                <article class="stat-card">
                    <span class="icon-box">VN</span>
                    <p>Total Vendors</p>
                    <strong class="stat-value"><%= totalVendors %></strong>
                </article>
                <article class="stat-card">
                    <span class="icon-box">SV</span>
                    <p>Total Services</p>
                    <strong class="stat-value"><%= totalServices %></strong>
                </article>
                <article class="stat-card">
                    <span class="icon-box">BK</span>
                    <p>Total Bookings</p>
                    <strong class="stat-value"><%= totalBookings %></strong>
                </article>
            </div>

            <!-- Revenue Analysis Card -->
            <section class="table-card section-spacer p-4">
                <div class="panel-title">
                    <h2>System Revenue Goal</h2>
                    <span class="badge badge-green">Target: Rs. 50,000.00</span>
                </div>
                <div class="progress-container mt-2">
                    <% 
                        double revenue = 0.0;
                        if (request.getAttribute("recentBookings") != null) {
                            for (Booking b : (List<Booking>) request.getAttribute("recentBookings")) {
                                if ("Delivered".equals(b.getBookingStatus())) revenue += b.getServicePrice();
                            }
                        }
                        double progress = (revenue / 50000.0) * 100.0;
                        if (progress > 100) progress = 100;
                    %>
                    <div class="progress-bar-bg">
                        <div class="progress-bar-fill" style="width: <%= progress %>%; background: var(--blue-600);"></div>
                    </div>
                    <div class="mt-1 flex justify-between">
                        <small>Current: <strong>Rs. <%= String.format("%.2f", revenue) %></strong></small>
                        <small><%= String.format("%.1f", progress) %>% of monthly target</small>
                    </div>
                </div>
            </section>

            <div class="dashboard-grid">
                <section class="table-card">
                    <div class="panel-title">
                        <h2>Recent Orders</h2>
                        <a href="<%= contextPath %>/admin?action=orders">View All</a>
                    </div>
                    <table>
                        <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Vendor</th>
                            <th>Service</th>
                            <th>Status</th>
                            <th>Amount</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% if (recentBookings == null || recentBookings.isEmpty()) { %>
                            <tr><td colspan="6">No bookings found yet.</td></tr>
                        <% } else {
                            int shown = 0;
                            for (Booking booking : recentBookings) {
                                if (shown++ >= 5) {
                                    break;
                                }
                        %>
                            <tr>
                                <td>#QW-<%= booking.getBookingId() %></td>
                                <td><span class="table-main"><%= booking.getCustomerName() %></span><span class="table-sub"><%= booking.getPickupAddress() %></span></td>
                                <td><%= booking.getVendorName() %></td>
                                <td><%= booking.getServiceName() %></td>
                                <td><span class="badge badge-blue"><%= booking.getBookingStatus() %></span></td>
                                <td><strong>Rs. <%= String.format("%.2f", booking.getServicePrice()) %></strong></td>
                            </tr>
                        <% } } %>
                        </tbody>
                    </table>
                </section>

                <aside class="panel">
                    <div class="panel-title">
                        <h2>Quick Admin Actions</h2>
                    </div>
                    <div class="quick-list">
                        <a class="quick-link" href="<%= contextPath %>/admin?action=users">Manage Users <strong>Open</strong></a>
                        <a class="quick-link" href="<%= contextPath %>/vendors?action=new">Add Vendor <strong>New</strong></a>
                        <a class="quick-link" href="<%= contextPath %>/services?action=new">Add Service <strong>New</strong></a>
                        <a class="quick-link" href="<%= contextPath %>/admin?action=reports">Reports <strong>View</strong></a>
                    </div>
                </aside>
            </div>
        </section>
    </main>
</div>
</body>
</html>
