<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Slot" %>
<%@ page import="model.Vendor" %>
<%
    String contextPath = request.getContextPath();
    List<Slot> slots = (List<Slot>) request.getAttribute("slots");
    Vendor vendor = (Vendor) request.getAttribute("vendor");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    if (slots == null) {
        response.sendRedirect(contextPath + "/vendor?action=availability");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Availability | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<div class="dashboard-shell">
    <aside class="sidebar">
        <a class="brand" href="<%= contextPath %>/vendor"><span class="brand-mark">QW</span><span>QuickWash</span></a>
        <p class="sidebar-label">Vendor portal</p>
        <nav class="side-nav">
            <a href="<%= contextPath %>/vendor"><span class="side-icon">DB</span>Dashboard</a>
            <a href="<%= contextPath %>/vendor?action=orders"><span class="side-icon">OR</span>Orders</a>
            <a class="active" href="<%= contextPath %>/vendor?action=availability"><span class="side-icon">AV</span>Availability</a>
        </nav>
        <div class="sidebar-bottom"><nav class="side-nav"><a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a></nav></div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar"><h1>Vendor Availability</h1></header>
        <section class="dashboard-content">
            <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

            <section class="form-card wide">
                <h2>Add Slot</h2>
                <form action="<%= contextPath %>/vendor?action=add-slot" method="post" class="form two-column">
                    <div>
                        <label for="slot_date">Slot Date</label>
                        <input type="date" id="slot_date" name="slot_date" required>
                    </div>
                    <div>
                        <label for="slot_time">Slot Time</label>
                        <input type="text" id="slot_time" name="slot_time" placeholder="07:00 AM - 09:00 AM" required>
                    </div>
                    <div>
                        <label for="availability_status">Availability</label>
                        <select id="availability_status" name="availability_status" required>
                            <option value="available">Available</option>
                            <option value="booked">Booked</option>
                            <option value="unavailable">Unavailable</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary form-span">Add Slot</button>
                </form>
            </section>

            <section class="form-card wide section-spacer">
                <h2>Verification Document</h2>
                <p class="muted">Upload a JPG, PNG, or PDF document up to 2MB for vendor verification records.</p>
                <% if (vendor != null && vendor.getDocumentPath() != null && !vendor.getDocumentPath().trim().isEmpty()) { %>
                    <div class="upload-current">
                        Current document:
                        <a href="<%= contextPath %>/<%= vendor.getDocumentPath() %>" target="_blank" rel="noopener">View uploaded file</a>
                    </div>
                <% } %>
                <form action="<%= contextPath %>/vendor/upload-document" method="post" enctype="multipart/form-data" class="form upload-form">
                    <div>
                        <label for="document">Upload document</label>
                        <input class="file-input" type="file" id="document" name="document" accept=".jpg,.jpeg,.png,.pdf" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Upload Document</button>
                </form>
            </section>

            <section class="table-card section-spacer">
                <div class="panel-title"><h2>Your Slots</h2></div>
                <table>
                    <thead>
                    <tr><th>Date</th><th>Time</th><th>Status</th><th>Update</th><th>Delete</th></tr>
                    </thead>
                    <tbody>
                    <% if (slots.isEmpty()) { %>
                        <tr><td colspan="5">No slots created yet.</td></tr>
                    <% } else {
                        for (Slot slot : slots) {
                    %>
                        <tr>
                            <td><%= slot.getSlotDate() %></td>
                            <td><%= slot.getSlotTime() %></td>
                            <td><span class="badge <%= "available".equals(slot.getAvailabilityStatus()) ? "badge-green" : "booked".equals(slot.getAvailabilityStatus()) ? "badge-blue" : "badge-grey" %>"><%= slot.getAvailabilityStatus() %></span></td>
                            <td>
                                <form action="<%= contextPath %>/vendor?action=update-slot" method="post" class="inline-form">
                                    <input type="hidden" name="slot_id" value="<%= slot.getSlotId() %>">
                                    <select name="availability_status" required>
                                        <option value="available" <%= "available".equals(slot.getAvailabilityStatus()) ? "selected" : "" %>>Available</option>
                                        <option value="booked" <%= "booked".equals(slot.getAvailabilityStatus()) ? "selected" : "" %>>Booked</option>
                                        <option value="unavailable" <%= "unavailable".equals(slot.getAvailabilityStatus()) ? "selected" : "" %>>Unavailable</option>
                                    </select>
                                    <button type="submit" class="btn btn-secondary btn-small">Update</button>
                                </form>
                            </td>
                            <td><a class="btn btn-danger btn-small" href="<%= contextPath %>/vendor?action=delete-slot&id=<%= slot.getSlotId() %>" onclick="return confirm('Delete this slot?');">Delete</a></td>
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
