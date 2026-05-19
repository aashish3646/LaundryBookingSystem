<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Vendor" %>
<%@ page import="model.Service" %>
<%@ page import="model.Slot" %>
<%
    String contextPath = request.getContextPath();
    String userName = (String) session.getAttribute("userName");
    String error = (String) request.getAttribute("error");
    Booking booking = (Booking) request.getAttribute("booking");
    if (booking == null) {
        booking = new Booking();
    }
    List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<Slot> slots = (List<Slot>) request.getAttribute("slots");
    if (vendors == null || services == null || slots == null) {
        response.sendRedirect(contextPath + "/bookings?action=new");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Laundry | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<header class="site-header">
    <nav class="navbar">
        <a class="brand" href="<%= contextPath %>/user/dashboard.jsp"><span class="brand-mark">QW</span><span>QuickWash</span></a>
        <div class="nav-links">
            <a href="<%= contextPath %>/user/dashboard.jsp">Dashboard</a>
            <a class="active" href="<%= contextPath %>/bookings?action=new">Book Laundry</a>
            <a href="<%= contextPath %>/bookings?action=my-orders">My Orders</a>
            <a href="<%= contextPath %>/bookings?action=track">Track Status</a>
            <a href="<%= contextPath %>/user/profile.jsp">Profile</a>
            <a class="nav-button" href="<%= contextPath %>/logout">Logout</a>
        </div>
    </nav>
</header>

<main class="dashboard-content">
    <section class="welcome-block">
        <h2>Book Laundry Service</h2>
        <p class="muted">Namaste, <%= userName != null ? userName : "Customer" %>. Choose your laundry vendor, service, slot, and pickup details.</p>
    </section>

    <section class="form-card wide">
        <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>
        <form action="<%= contextPath %>/bookings?action=create" method="post" class="form two-column">
            <div>
                <label for="vendor_id">Vendor</label>
                <select id="vendor_id" name="vendor_id" required>
                    <option value="">Select vendor</option>
                    <% if (vendors != null) {
                        for (Vendor vendor : vendors) {
                    %>
                        <option value="<%= vendor.getVendorId() %>" <%= booking.getVendorId() == vendor.getVendorId() ? "selected" : "" %>><%= vendor.getVendorName() %> - <%= vendor.getArea() %></option>
                    <% } } %>
                </select>
            </div>

            <div>
                <label for="service_id">Service</label>
                <select id="service_id" name="service_id" required>
                    <option value="">Select service</option>
                    <% if (services != null) {
                        for (Service service : services) {
                    %>
                        <option value="<%= service.getServiceId() %>" <%= booking.getServiceId() == service.getServiceId() ? "selected" : "" %>><%= service.getServiceName() %> - Rs. <%= String.format("%.2f", service.getPrice()) %></option>
                    <% } } %>
                </select>
            </div>

            <div class="form-span">
                <label for="slot_id">Pickup Slot</label>
                <select id="slot_id" name="slot_id" required>
                    <option value="">Select available slot</option>
                    <% if (slots != null) {
                        for (Slot slot : slots) {
                    %>
                        <option value="<%= slot.getSlotId() %>" <%= booking.getSlotId() == slot.getSlotId() ? "selected" : "" %>><%= slot.getVendorName() %> - <%= slot.getSlotDate() %> - <%= slot.getSlotTime() %></option>
                    <% } } %>
                </select>
                <p class="muted">Choose a slot that belongs to your selected vendor.</p>
            </div>

            <div class="form-span">
                <label for="pickup_address">Pickup Address</label>
                <input type="text" id="pickup_address" name="pickup_address" value="<%= booking.getPickupAddress() != null ? booking.getPickupAddress() : "" %>" placeholder="Bargachhi, Biratnagar" required>
            </div>

            <div>
                <label for="clothes_type">Clothes Type</label>
                <input type="text" id="clothes_type" name="clothes_type" value="<%= booking.getClothesType() != null ? booking.getClothesType() : "" %>" placeholder="Formal Wear, School Uniform" required>
            </div>

            <div>
                <label for="quantity">Quantity</label>
                <input type="number" min="1" id="quantity" name="quantity" value="<%= booking.getQuantity() > 0 ? booking.getQuantity() : 1 %>" required>
            </div>

            <div class="form-span">
                <label for="pickup_note">Pickup Note</label>
                <textarea id="pickup_note" name="pickup_note" rows="4" placeholder="Any pickup or washing instructions..."><%= booking.getPickupNote() != null ? booking.getPickupNote() : "" %></textarea>
            </div>

            <button type="submit" class="btn btn-primary btn-full form-span">Create Booking</button>
        </form>
    </section>
</main>
</body>
</html>
