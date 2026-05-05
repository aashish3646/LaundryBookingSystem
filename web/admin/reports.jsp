<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    int totalUsers = request.getAttribute("totalUsers") != null ? (Integer) request.getAttribute("totalUsers") : 0;
    int totalVendors = request.getAttribute("totalVendors") != null ? (Integer) request.getAttribute("totalVendors") : 0;
    int totalServices = request.getAttribute("totalServices") != null ? (Integer) request.getAttribute("totalServices") : 0;
    int totalBookings = request.getAttribute("totalBookings") != null ? (Integer) request.getAttribute("totalBookings") : 0;
    
    int pending = request.getAttribute("pendingBookings") != null ? (Integer) request.getAttribute("pendingBookings") : 0;
    int accepted = request.getAttribute("acceptedBookings") != null ? (Integer) request.getAttribute("acceptedBookings") : 0;
    int delivered = request.getAttribute("deliveredBookings") != null ? (Integer) request.getAttribute("deliveredBookings") : 0;
    double revenue = request.getAttribute("totalRevenue") != null ? (Double) request.getAttribute("totalRevenue") : 0.0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports | QuickWash</title>
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
            <a href="<%= contextPath %>/admin?action=orders"><span class="side-icon">OR</span>All Orders</a>
            <a class="active" href="<%= contextPath %>/admin?action=reports"><span class="side-icon">RP</span>Reports</a>
        </nav>
        <div class="sidebar-bottom"><nav class="side-nav"><a href="<%= contextPath %>/index.jsp"><span class="side-icon">HM</span>Public Site</a><a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a></nav></div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar"><h1>System Reports & Analysis</h1></header>
        <section class="dashboard-content">
            <div class="stats-grid">
                <article class="stat-card"><span class="icon-box">US</span><p>Total Users</p><strong class="stat-value"><%= totalUsers %></strong></article>
                <article class="stat-card"><span class="icon-box">VN</span><p>Total Vendors</p><strong class="stat-value"><%= totalVendors %></strong></article>
                <article class="stat-card"><span class="icon-box">BK</span><p>Total Bookings</p><strong class="stat-value"><%= totalBookings %></strong></article>
                <article class="stat-card"><span class="icon-box">RS</span><p>Total Revenue</p><strong class="stat-value">Rs. <%= String.format("%.2f", revenue) %></strong></article>
            </div>

            <div class="dashboard-grid">
                <section class="table-card">
                    <div class="panel-title"><h2>Booking Status Analysis</h2></div>
                    <div class="p-4">
                        <div class="report-row"><span>Pending Orders</span><strong><%= pending %></strong></div>
                        <div class="report-row"><span>Accepted Orders</span><strong><%= accepted %></strong></div>
                        <div class="report-row"><span>Delivered Orders</span><strong><%= delivered %></strong></div>
                        <div class="report-row border-top mt-2 pt-2"><span>Completion Rate</span><strong><%= totalBookings > 0 ? (delivered * 100 / totalBookings) : 0 %>%</strong></div>
                    </div>
                </section>

                <aside class="panel">
                    <div class="panel-title"><h2>Insights</h2></div>
                    <p class="muted small">Reports are generated in real-time from the database to aid in decision-making and business planning.</p>
                </aside>
            </div>
        </section>
    </main>
</div>
</body>
</html>
