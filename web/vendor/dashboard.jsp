<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Vendor Dashboard - QuickWash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <h1>QuickWash - Vendor Dashboard</h1>
    <p>Welcome, Vendor</p>

    <div>
        <a href="orders.jsp">View Assigned Orders</a><br><br>
        <a href="update-status.jsp">Update Order Status</a><br><br>
        <a href="availability.jsp">Manage Availability</a><br><br>
        <a href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</body>
</html>