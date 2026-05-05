<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Service" %>
<%
    String contextPath = request.getContextPath();
    List<Service> services = (List<Service>) request.getAttribute("services");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Services | QuickWash</title>
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
            <a class="active" href="<%= contextPath %>/services?action=list"><span class="side-icon">SV</span>Manage Services</a>
            <a href="<%= contextPath %>/admin?action=orders"><span class="side-icon">OR</span>All Orders</a>
            <a href="<%= contextPath %>/admin?action=reports"><span class="side-icon">RP</span>Reports</a>
        </nav>
        <div class="sidebar-bottom"><nav class="side-nav"><a href="<%= contextPath %>/index.jsp"><span class="side-icon">HM</span>Public Site</a><a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a></nav></div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar">
            <h1>Manage Services</h1>
            <a class="btn btn-primary" href="<%= contextPath %>/services?action=new">Add Service</a>
        </header>

        <section class="dashboard-content">
            <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

            <section class="table-card">
                <div class="panel-title"><h2>All Services</h2></div>
                <table>
                    <thead>
                    <tr>
                        <th>Service</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (services == null || services.isEmpty()) { %>
                        <tr><td colspan="5">No services found.</td></tr>
                    <% } else {
                        for (Service service : services) {
                    %>
                        <tr>
                            <td><span class="table-main"><%= service.getServiceName() %></span></td>
                            <td><%= service.getDescription() %></td>
                            <td><strong>Rs. <%= String.format("%.2f", service.getPrice()) %></strong></td>
                            <td><span class="badge <%= "active".equals(service.getStatus()) ? "badge-green" : "badge-amber" %>"><%= service.getStatus() %></span></td>
                            <td class="table-actions">
                                <a class="btn btn-secondary btn-small" href="<%= contextPath %>/services?action=edit&id=<%= service.getServiceId() %>">Edit</a>
                                <a class="btn btn-danger btn-small" href="<%= contextPath %>/services?action=delete&id=<%= service.getServiceId() %>" onclick="return confirm('Delete this service?');">Delete</a>
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
