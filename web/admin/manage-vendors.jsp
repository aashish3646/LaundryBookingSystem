<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Vendor" %>
<html>
<head>
    <title>Manage Vendors - QuickWash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-container">
        <h1>Vendor Management</h1>
        <a href="dashboard.jsp">Back to Dashboard</a> | 
        <a href="${pageContext.request.contextPath}/vendors?action=new">Add New Vendor</a>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Area</th>
                        <th>Contact</th>
                        <th>Service</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Vendor> listVendor = (List<Vendor>) request.getAttribute("listVendor");
                        if (listVendor != null) {
                            for (Vendor v : listVendor) {
                    %>
                        <tr>
                            <td><%= v.getVendorId() %></td>
                            <td><%= v.getVendorName() %></td>
                            <td><%= v.getArea() %></td>
                            <td><%= v.getContact() %></td>
                            <td><%= v.getServiceType() %></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/vendors?action=edit&id=<%= v.getVendorId() %>">Edit</a> | 
                                <a href="${pageContext.request.contextPath}/vendors?action=delete&id=<%= v.getVendorId() %>" onclick="return confirm('Are you sure?')">Delete</a>
                            </td>
                        </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
