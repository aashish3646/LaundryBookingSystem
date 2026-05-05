<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Vendor" %>
<%
    String contextPath = request.getContextPath();
    Vendor vendor = (Vendor) request.getAttribute("vendor");
    if (vendor == null) {
        vendor = new Vendor();
    }
    boolean editing = vendor.getVendorId() > 0;
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= editing ? "Edit" : "Add" %> Vendor | QuickWash</title>
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
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar">
            <h1><%= editing ? "Edit Vendor" : "Add Vendor" %></h1>
            <a class="btn btn-secondary" href="<%= contextPath %>/vendors?action=list">Back to Vendors</a>
        </header>

        <section class="dashboard-content">
            <section class="form-card wide">
                <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>
                <form action="<%= contextPath %>/vendors?action=save" method="post" class="form two-column">
                    <input type="hidden" name="vendor_id" value="<%= vendor.getVendorId() %>">

                    <div>
                        <label for="vendor_name">Laundry Business Name</label>
                        <input type="text" id="vendor_name" name="vendor_name" value="<%= vendor.getVendorName() != null ? vendor.getVendorName() : "" %>" required>
                    </div>

                    <div>
                        <label for="owner_name">Owner Name</label>
                        <input type="text" id="owner_name" name="owner_name" value="<%= vendor.getOwnerName() != null ? vendor.getOwnerName() : "" %>" required>
                    </div>

                    <div>
                        <label for="area">Service Area / Location</label>
                        <input type="text" id="area" name="area" value="<%= vendor.getArea() != null ? vendor.getArea() : "" %>" placeholder="Itahari, Kathmandu" required>
                    </div>

                    <div>
                        <label for="contact">Contact Number</label>
                        <input type="text" id="contact" name="contact" value="<%= vendor.getContact() != null ? vendor.getContact() : "" %>" placeholder="98XXXXXXXX" required>
                    </div>

                    <div>
                        <label for="service_type">Service Types Offered</label>
                        <input type="text" id="service_type" name="service_type" value="<%= vendor.getServiceType() != null ? vendor.getServiceType() : "" %>" placeholder="Wash, Iron, Dry Cleaning" required>
                    </div>

                    <div>
                        <label for="price_range">Price Range</label>
                        <input type="text" id="price_range" name="price_range" value="<%= vendor.getPriceRange() != null ? vendor.getPriceRange() : "" %>" placeholder="Rs. 120 - Rs. 500" required>
                    </div>

                    <div>
                        <label for="document_type">Document Type</label>
                        <input type="text" id="document_type" name="document_type" value="<%= vendor.getDocumentType() != null ? vendor.getDocumentType() : "" %>" placeholder="Citizenship, License, etc.">
                    </div>

                    <div>
                        <label for="approval_status">Approval Status</label>
                        <select id="approval_status" name="approval_status" required>
                            <option value="pending" <%= "pending".equals(vendor.getApprovalStatus()) ? "selected" : "" %>>Pending</option>
                            <option value="approved" <%= "approved".equals(vendor.getApprovalStatus()) ? "selected" : "" %>>Approved</option>
                            <option value="rejected" <%= "rejected".equals(vendor.getApprovalStatus()) ? "selected" : "" %>>Rejected</option>
                        </select>
                    </div>

                    <div class="form-span">
                        <label for="admin_remarks">Admin Remarks</label>
                        <textarea id="admin_remarks" name="admin_remarks" rows="2" placeholder="Reasons for rejection or other notes..."><%= vendor.getAdminRemarks() != null ? vendor.getAdminRemarks() : "" %></textarea>
                    </div>

                    <div>
                        <label for="status">System Status</label>
                        <select id="status" name="status" required>
                            <option value="active" <%= "inactive".equals(vendor.getStatus()) ? "" : "selected" %>>Active</option>
                            <option value="inactive" <%= "inactive".equals(vendor.getStatus()) ? "selected" : "" %>>Inactive</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary btn-full form-span">Save Vendor</button>
                </form>
            </section>
        </section>
    </main>
</div>
</body>
</html>
