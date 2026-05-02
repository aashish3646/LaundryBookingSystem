<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<html>
<head>
    <title>My Orders - QuickWash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-container">
        <h1>My Laundry Orders</h1>
        <a href="dashboard.jsp">Back to Dashboard</a> | 
        <a href="${pageContext.request.contextPath}/bookings?action=new">Book New Order</a>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Type</th>
                        <th>Quantity</th>
                        <th>Status</th>
                        <th>Date Booked</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                        if (bookings != null && !bookings.isEmpty()) {
                            for (Booking b : bookings) {
                    %>
                        <tr>
                            <td>#<%= b.getBookingId() %></td>
                            <td><%= b.getClothesType() %></td>
                            <td><%= b.getQuantity() %> kg</td>
                            <td><span class="status-<%= b.getBookingStatus().toLowerCase() %>"><%= b.getBookingStatus() %></span></td>
                            <td><%= b.getCreatedAt() %></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="5">No orders found.</td>
                        </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
