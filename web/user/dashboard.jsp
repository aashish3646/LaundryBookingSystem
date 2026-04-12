<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Object loggedInUser = session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<html>
<head>
    <title>User Dashboard - QuickWash</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <h1>QuickWash - User Dashboard</h1>
    <p>Welcome, User</p>

    <div>
        <a href="book-order.jsp">Book Laundry</a><br><br>
        <a href="my-orders.jsp">My Orders</a><br><br>
        <a href="track-status.jsp">Track Status</a><br><br>
        <a href="profile.jsp">Edit Profile</a><br><br>
        <a href="../logout">Logout</a>
    </div>
</body>
</html>