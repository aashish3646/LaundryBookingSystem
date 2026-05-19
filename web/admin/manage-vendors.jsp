<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Vendor" %>
<%
    String contextPath = request.getContextPath();
    List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Vendors | QuickWash</title>
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
            <a class="active" href="<%= contextPath %>/vendors?action=list"><span class="side-icon">VN</span>Manage Vendors</a>
            <a href="<%= contextPath %>/services?action=list"><span class="side-icon">SV</span>Manage Services</a>
            <a href="<%= contextPath %>/admin?action=orders"><span class="side-icon">OR</span>All Orders</a>
            <a href="<%= contextPath %>/admin?action=reports"><span class="side-icon">RP</span>Reports</a>
        </nav>
        <div class="sidebar-bottom"><nav class="side-nav"><a href="<%= contextPath %>/index.jsp"><span class="side-icon">HM</span>Public Site</a><a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a></nav></div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar">
            <h1>Manage Vendors</h1>
            <a class="btn btn-primary" href="<%= contextPath %>/vendors?action=new">Add Vendor</a>
        </header>

        <section class="dashboard-content">
            <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

            <section class="table-card">
                <table>
                    <thead>
                    <tr>
                        <th>Vendor Profile</th>
                        <th>Location & Contact</th>
                        <th>Service & Price</th>
                        <th>Documents</th>
                        <th>Approval</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (vendors == null || vendors.isEmpty()) { %>
                        <tr><td colspan="7">No vendors found.</td></tr>
                    <% } else {
                        for (Vendor v : vendors) {
                            String statusClass = "badge-grey";
                            if ("approved".equals(v.getApprovalStatus())) statusClass = "badge-green";
                            else if ("pending".equals(v.getApprovalStatus())) statusClass = "badge-amber";
                            else if ("rejected".equals(v.getApprovalStatus())) statusClass = "badge-red";
                    %>
                        <tr>
                            <td>
                                <span class="table-main"><%= v.getVendorName() %></span>
                                <span class="table-sub">Owner: <%= v.getOwnerName() != null ? v.getOwnerName() : "N/A" %></span>
                                <span class="table-sub text-muted">ID: <%= v.getVendorId() %></span>
                            </td>
                            <td>
                                <span class="table-main"><%= v.getArea() %></span>
                                <span class="table-sub"><%= v.getContact() %></span>
                            </td>
                            <td>
                                <span class="table-main"><%= v.getServiceType() %></span>
                                <span class="table-sub"><%= v.getPriceRange() %></span>
                            </td>
                            <td>
                                <% if (v.getDocumentPath() != null) { %>
                                    <a class="link-btn" href="<%= contextPath %>/<%= v.getDocumentPath() %>" target="_blank">View <%= v.getDocumentType() != null ? v.getDocumentType() : "File" %></a>
                                <% } else { %>
                                    <span class="muted">No File</span>
                                <% } %>
                            </td>
                            <td>
                                <span class="badge <%= statusClass %>"><%= v.getApprovalStatus() != null ? v.getApprovalStatus().toUpperCase() : "N/A" %></span>
                                <% if ("rejected".equals(v.getApprovalStatus()) && v.getAdminRemarks() != null) { %>
                                    <span class="table-sub text-danger" title="<%= v.getAdminRemarks() %>">Remarks: <%= v.getAdminRemarks() %></span>
                                <% } %>
                            </td>
                            <td><span class="badge <%= "active".equals(v.getStatus()) ? "badge-green" : "badge-amber" %>"><%= v.getStatus() %></span></td>
                            <td class="table-actions">
                                <div class="action-stack">
                                    <% if ("pending".equals(v.getApprovalStatus()) || "rejected".equals(v.getApprovalStatus())) { %>
                                        <a class="btn btn-primary btn-small" href="<%= contextPath %>/vendors?action=approve&id=<%= v.getVendorId() %>">Approve</a>
                                    <% } %>
                                    <% if ("pending".equals(v.getApprovalStatus()) || "approved".equals(v.getApprovalStatus())) { %>
                                        <button class="btn btn-danger btn-small" onclick="showRejectModal(<%= v.getVendorId() %>, '<%= v.getVendorName() %>')">Reject</button>
                                    <% } %>
                                    <a class="btn btn-secondary btn-small" href="<%= contextPath %>/vendors?action=edit&id=<%= v.getVendorId() %>">Edit</a>
                                    <a class="btn btn-danger btn-small" href="<%= contextPath %>/vendors?action=delete&id=<%= v.getVendorId() %>" onclick="return confirm('Permanently delete this vendor?');">Delete</a>
                                </div>
                            </td>
                        </tr>
                    <% } } %>
                    </tbody>
                </table>
            </section>
        </section>
    </main>
</div>

<!-- Simple Reject Modal -->
<div id="rejectModal" class="modal">
    <div class="modal-content">
        <h3>Reject Vendor: <span id="rejectVendorName"></span></h3>
        <form action="<%= contextPath %>/vendors?action=reject" method="post" class="form">
            <input type="hidden" name="vendor_id" id="rejectVendorId">
            <div class="form-group">
                <label for="admin_remarks">Rejection Remarks</label>
                <textarea name="admin_remarks" id="admin_remarks" placeholder="e.g. Identity document is unclear. Please re-upload." required></textarea>
            </div>
            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="closeRejectModal()">Cancel</button>
                <button type="submit" class="btn btn-danger">Confirm Rejection</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showRejectModal(id, name) {
        document.getElementById('rejectVendorId').value = id;
        document.getElementById('rejectVendorName').innerText = name;
        document.getElementById('rejectModal').style.display = 'flex';
    }
    function closeRejectModal() {
        document.getElementById('rejectModal').style.display = 'none';
    }
</script>
</body>
</html>
