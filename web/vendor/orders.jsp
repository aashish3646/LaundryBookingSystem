<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="dao.BookingDAO" %>
<html>
<head>
    <title>Assigned Orders - QuickWash</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="dashboard-container">
        <h1>Assigned Laundry Orders</h1>
        <a href="dashboard.jsp">Back to Dashboard</a>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>User ID</th>
                        <th>Type</th>
                        <th>Quantity</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // For simplicity, we fetch directly here or could use a controller
                        int vendorId = (int) session.getAttribute("userId"); // Assuming vendor ID is stored in userId session attr
                        BookingDAO bookingDAO = new BookingDAO();
                        List<Booking> bookings = bookingDAO.getBookingsByVendor(vendorId);
                        if (bookings != null && !bookings.isEmpty()) {
                            for (Booking b : bookings) {
                    %>
                        <tr>
                            <td>#<%= b.getBookingId() %></td>
                            <td><%= b.getUserId() %></td>
                            <td><%= b.getClothesType() %></td>
                            <td><%= b.getQuantity() %> kg</td>
                            <td><span class="status-<%= b.getBookingStatus().toLowerCase() %>"><%= b.getBookingStatus() %></span></td>
                            <td>
                                <form action="${pageContext.request.contextPath}/bookings" method="get" style="display:inline;">
                                    <input type="hidden" name="action" value="update-status">
                                    <input type="hidden" name="id" value="<%= b.getBookingId() %>">
                                    <select name="status" onchange="this.form.submit()">
                                        <option value="Pending" <%= "Pending".equals(b.getBookingStatus()) ? "selected" : "" %>>Pending</option>
                                        <option value="In Progress" <%= "In Progress".equals(b.getBookingStatus()) ? "selected" : "" %>>In Progress</option>
                                        <option value="Completed" <%= "Completed".equals(b.getBookingStatus()) ? "selected" : "" %>>Completed</option>
                                        <option value="Cancelled" <%= "Cancelled".equals(b.getBookingStatus()) ? "selected" : "" %>>Cancelled</option>
                                    </select>
                                </form>
                            </td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6">No orders assigned.</td>
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
