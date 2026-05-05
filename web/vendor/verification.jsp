<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Vendor" %>
<%
    String contextPath = request.getContextPath();
    Vendor vendor = (Vendor) request.getAttribute("vendor");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vendor Verification | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<div class="dashboard-shell">
    <aside class="sidebar">
        <a class="brand" href="<%= contextPath %>/vendor"><span class="brand-mark">QW</span><span>QuickWash</span></a>
        <p class="sidebar-label">Vendor portal</p>
        <nav class="side-nav">
            <a class="active" href="<%= contextPath %>/vendor"><span class="side-icon">DB</span>Verification</a>
        </nav>
        <div class="sidebar-bottom">
            <nav class="side-nav">
                <a class="logout-link" href="<%= contextPath %>/logout"><span class="side-icon">LO</span>Logout</a>
            </nav>
        </div>
    </aside>

    <main class="dashboard-main">
        <header class="dashboard-topbar">
            <h1>Vendor Verification</h1>
        </header>

        <section class="dashboard-content">
            <% if (success != null) { %><div class="alert alert-success"><%= success %></div><% } %>
            <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

            <% if (vendor != null && "pending".equals(vendor.getApprovalStatus())) { %>
                <div class="status-card pending">
                    <div class="status-icon">⏳</div>
                    <h2>Profile Pending Approval</h2>
                    <p>Your vendor verification profile has been submitted and is currently being reviewed by our administration. Please check back later.</p>
                    <div class="submitted-details">
                        <h3>Submitted Details:</h3>
                        <ul>
                            <li><strong>Vendor Name:</strong> <%= vendor.getVendorName() %></li>
                            <li><strong>Owner Name:</strong> <%= vendor.getOwnerName() %></li>
                            <li><strong>Contact:</strong> <%= vendor.getContact() %></li>
                        </ul>
                    </div>
                </div>
            <% } else if (vendor != null && "rejected".equals(vendor.getApprovalStatus())) { %>
                <div class="status-card rejected">
                    <div class="status-icon">❌</div>
                    <h2>Profile Rejected</h2>
                    <p>Your vendor verification request was rejected by the administrator.</p>
                    <% if (vendor.getAdminRemarks() != null && !vendor.getAdminRemarks().isEmpty()) { %>
                        <div class="admin-remarks">
                            <strong>Admin Remarks:</strong>
                            <p><%= vendor.getAdminRemarks() %></p>
                        </div>
                    <% } %>
                    <p class="mt-2">You can update your details and resubmit the verification form below.</p>
                </div>
                <!-- Show form again for resubmission -->
                <% renderForm(vendor, contextPath, out); %>
            <% } else { %>
                <div class="info-card">
                    <h2>Complete Your Profile</h2>
                    <p>To start receiving laundry bookings, you must complete your vendor verification profile. Please provide accurate information and upload a valid identity or business document.</p>
                </div>
                <% renderForm(vendor, contextPath, out); %>
            <% } %>
        </section>
    </main>
</div>

<%! 
    void renderForm(Vendor vendor, String contextPath, jakarta.servlet.jsp.JspWriter out) throws java.io.IOException {
        String vName = (vendor != null) ? vendor.getVendorName() : "";
        String oName = (vendor != null) ? vendor.getOwnerName() : "";
        String area = (vendor != null) ? vendor.getArea() : "";
        String contact = (vendor != null) ? vendor.getContact() : "";
        String sType = (vendor != null) ? vendor.getServiceType() : "";
        String pRange = (vendor != null) ? vendor.getPriceRange() : "";
        String dType = (vendor != null) ? vendor.getDocumentType() : "";
%>
    <section class="form-card wide">
        <h2>Verification Details</h2>
        <form action="<%= contextPath %>/vendor/upload-document" method="post" enctype="multipart/form-data" class="form two-column">
            <div class="form-group">
                <label for="vendor_name">Laundry Business Name</label>
                <input type="text" id="vendor_name" name="vendor_name" value="<%= vName %>" required placeholder="e.g. Nischal Fresh Wash">
            </div>
            <div class="form-group">
                <label for="owner_name">Owner Full Name</label>
                <input type="text" id="owner_name" name="owner_name" value="<%= oName %>" required placeholder="e.g. Nischal Karki">
            </div>
            <div class="form-group">
                <label for="area">Service Area / Location</label>
                <input type="text" id="area" name="area" value="<%= area %>" required placeholder="e.g. Dharan-10, Sunsari">
            </div>
            <div class="form-group">
                <label for="contact">Contact Number</label>
                <input type="text" id="contact" name="contact" value="<%= contact %>" required placeholder="e.g. 9841XXXXXX">
            </div>
            <div class="form-group">
                <label for="service_type">Service Types Offered</label>
                <input type="text" id="service_type" name="service_type" value="<%= sType %>" required placeholder="e.g. Wash and Iron, Dry Cleaning">
            </div>
            <div class="form-group">
                <label for="price_range">Approximate Price Range</label>
                <input type="text" id="price_range" name="price_range" value="<%= pRange %>" required placeholder="e.g. Rs. 150 - Rs. 500">
            </div>
            <div class="form-group">
                <label for="document_type">Document Type</label>
                <select id="document_type" name="document_type" required>
                    <option value="" disabled <%= dType.isEmpty() ? "selected" : "" %>>Select Document Type</option>
                    <option value="Citizenship" <%= "Citizenship".equals(dType) ? "selected" : "" %>>Citizenship (Nagarikta)</option>
                    <option value="PAN Card" <%= "PAN Card".equals(dType) ? "selected" : "" %>>PAN / VAT Certificate</option>
                    <option value="Business License" <%= "Business License".equals(dType) ? "selected" : "" %>>Business Registration License</option>
                </select>
            </div>
            <div class="form-group">
                <label for="document">Upload Identity/Business Document (PDF/JPG/PNG, Max 2MB)</label>
                <input type="file" id="document" name="document" accept=".pdf,.jpg,.jpeg,.png" required>
            </div>
            
            <div class="form-span mt-2">
                <button type="submit" class="btn btn-primary">Submit for Verification</button>
            </div>
        </form>
    </section>
<% } %>

</body>
</html>
