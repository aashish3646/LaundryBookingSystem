<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Vendor" %>
<html>
<head>
    <title>Vendor Form - QuickWash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-container">
        <%
            Vendor vendor = (Vendor) request.getAttribute("vendor");
            String title = (vendor != null) ? "Edit Vendor" : "Add New Vendor";
            String action = (vendor != null) ? "update" : "insert";
        %>
        <h1><%= title %></h1>
        <a href="${pageContext.request.contextPath}/vendors?action=list">Back to List</a>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/vendors" method="get">
                <input type="hidden" name="action" value="<%= action %>">
                <% if (vendor != null) { %>
                    <input type="hidden" name="id" value="<%= vendor.getVendorId() %>">
                <% } %>

                <label>Vendor Name:</label><br>
                <input type="text" name="name" value="<%= (vendor != null) ? vendor.getVendorName() : "" %>" required><br><br>

                <label>Area:</label><br>
                <input type="text" name="area" value="<%= (vendor != null) ? vendor.getArea() : "" %>" required><br><br>

                <label>Contact:</label><br>
                <input type="text" name="contact" value="<%= (vendor != null) ? vendor.getContact() : "" %>" required><br><br>

                <label>Service Type:</label><br>
                <input type="text" name="serviceType" value="<%= (vendor != null) ? vendor.getServiceType() : "" %>" required><br><br>

                <label>Price Range:</label><br>
                <input type="text" name="priceRange" value="<%= (vendor != null) ? vendor.getPriceRange() : "" %>" required><br><br>

                <button type="submit" class="btn">Save Vendor</button>
            </form>
        </div>
    </div>
</body>
</html>
