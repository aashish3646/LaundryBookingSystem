<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Service" %>
<%
    String contextPath = request.getContextPath();
    Service service = (Service) request.getAttribute("service");
    if (service == null) {
        service = new Service();
    }
    boolean editing = service.getServiceId() > 0;
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= editing ? "Edit" : "Add" %> Service | QuickWash</title>
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
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar">
            <h1><%= editing ? "Edit Service" : "Add Service" %></h1>
            <a class="btn btn-secondary" href="<%= contextPath %>/services?action=list">Back to Services</a>
        </header>

        <section class="dashboard-content">
            <section class="form-card wide">
                <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>
                <form action="<%= contextPath %>/services?action=save" method="post" class="form two-column">
                    <input type="hidden" name="service_id" value="<%= service.getServiceId() %>">

                    <div>
                        <label for="service_name">Service Name</label>
                        <input type="text" id="service_name" name="service_name" value="<%= service.getServiceName() != null ? service.getServiceName() : "" %>" required>
                    </div>

                    <div>
                        <label for="price">Price</label>
                        <input type="number" step="0.01" min="1" id="price" name="price" value="<%= service.getPrice() > 0 ? service.getPrice() : "" %>" required>
                    </div>

                    <div class="form-span">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="4" required><%= service.getDescription() != null ? service.getDescription() : "" %></textarea>
                    </div>

                    <div>
                        <label for="status">Status</label>
                        <select id="status" name="status" required>
                            <option value="active" <%= "inactive".equals(service.getStatus()) ? "" : "selected" %>>Active</option>
                            <option value="inactive" <%= "inactive".equals(service.getStatus()) ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary btn-full form-span">Save Service</button>
                </form>
            </section>
        </section>
    </main>
</div>
</body>
</html>
