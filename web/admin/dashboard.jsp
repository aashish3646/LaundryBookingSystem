<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin Dashboard - QuickWash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <h1>QuickWash - Admin Dashboard</h1>
    <p>Welcome, Admin</p>

    <div>
        <a href="manage-users.jsp">Manage Users</a><br><br>
        <a href="manage-vendors.jsp">Manage Vendors</a><br><br>
        <a href="manage-services.jsp">Manage Services</a><br><br>
        <a href="all-orders.jsp">View All Orders</a><br><br>
        <a href="reports.jsp">Reports</a><br><br>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</body>
</html>