<%@ page import="java.util.List" %>
<%@ page import="model.Vendor" %>
<%@ page import="dao.VendorDAO" %>
<%@ page import="java.util.ArrayList" %>
<%
    String contextPath = request.getContextPath();
    String userName = (String) session.getAttribute("userName");
    
    String searchQuery = request.getParameter("search");
    VendorDAO vendorDAO = new VendorDAO();
    List<Vendor> vendors;
    
    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        vendors = vendorDAO.searchVendors(searchQuery.trim());
    } else {
        vendors = new ArrayList<>(); // Empty initially or show featured
    }
    
    List<Integer> shortlistIds = (List<Integer>) session.getAttribute("shortlist");
    List<Vendor> shortlistedVendors = new ArrayList<>();
    if (shortlistIds != null && !shortlistIds.isEmpty()) {
        for (int id : shortlistIds) {
            Vendor v = vendorDAO.getVendorById(id);
            if (v != null) shortlistedVendors.add(v);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard | QuickWash</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/style.css">
</head>
<body>
<header class="site-header">
    <nav class="navbar">
        <a class="brand" href="<%= contextPath %>/user/dashboard.jsp">
            <span class="brand-mark">QW</span>
            <span>QuickWash</span>
        </a>
        <div class="nav-links">
            <a class="active" href="<%= contextPath %>/user/dashboard.jsp">Dashboard</a>
            <a href="<%= contextPath %>/bookings?action=new">Book Laundry</a>
            <a href="<%= contextPath %>/bookings?action=my-orders">My Orders</a>
            <a href="<%= contextPath %>/bookings?action=track">Track Status</a>
            <a href="<%= contextPath %>/user/profile.jsp">Profile</a>
            <a class="nav-button" href="<%= contextPath %>/logout">Logout</a>
        </div>
    </nav>
</header>

<main class="dashboard-content">
    <section class="welcome-block">
        <div class="header-main">
            <h2>Welcome, <%= userName != null ? userName : "Customer" %></h2>
        </div>
        <p class="muted">Book laundry services, track orders, and manage your QuickWash profile.</p>
        
        <!-- Search Bar Section -->
        <div class="search-section mt-2">
            <form id="search-form" action="<%= contextPath %>/user/dashboard.jsp" method="get" class="search-form">
                <input type="text" id="live-search" name="search" placeholder="Type to search laundry (e.g. Dharan)..." value="<%= searchQuery != null ? searchQuery : "" %>" autocomplete="off">
                <button type="submit" class="btn btn-primary">Search</button>
                <% if (searchQuery != null) { %>
                    <a href="<%= contextPath %>/user/dashboard.jsp" class="btn btn-secondary">Clear</a>
                <% } %>
            </form>
        </div>
    </section>

    <!-- Search Results Section -->
    <section class="section-spacer" id="results-section" style="<%= searchQuery != null ? "" : "display:none;" %>">
        <div class="panel-title"><h3>Laundry Search Results</h3></div>
        <div class="vendor-grid" id="search-results-container">
            <% if (searchQuery != null) { %>
                <jsp:include page="/user/vendor-list-fragment.jsp">
                    <jsp:param name="vendors" value="<%= vendors %>" />
                </jsp:include>
            <% } %>
        </div>
    </section>

    <!-- Shortlist Section (Session-based) -->
    <% if (!shortlistedVendors.isEmpty()) { %>
        <section class="section-spacer">
            <div class="panel-title"><h3>My Shortlist (Session Saved)</h3></div>
            <div class="vendor-grid">
                <% for (Vendor v : shortlistedVendors) { %>
                    <div class="vendor-card-mini">
                        <div class="v-info">
                            <strong><%= v.getVendorName() %></strong>
                            <small><%= v.getArea() %></small>
                        </div>
                        <div class="v-actions">
                            <a href="<%= contextPath %>/shortlist?action=remove&vendor_id=<%= v.getVendorId() %>" class="text-danger">Remove</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </section>
    <% } %>

    <section class="card-grid three section-spacer">
        <a class="card" href="<%= contextPath %>/bookings?action=new">
            <span class="icon-box">BK</span>
            <h3>Book Laundry</h3>
            <p>Select vendor, service, pickup slot, address, clothes type, and quantity.</p>
        </a>
        <a class="card" href="<%= contextPath %>/bookings?action=my-orders">
            <span class="icon-box">OR</span>
            <h3>My Orders</h3>
            <p>View your bookings and cancel pending orders when needed.</p>
        </a>
        <a class="card" href="<%= contextPath %>/bookings?action=track">
            <span class="icon-box">TR</span>
            <h3>Track Status</h3>
            <p>Follow each order from Pending through Delivered or Cancelled.</p>
        </a>
    </section>
</main>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('live-search');
    const resultsContainer = document.getElementById('search-results-container');
    const resultsSection = document.getElementById('results-section');
    const searchForm = document.getElementById('search-form');

    // Prevent full page reload on Enter
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            performSearch(searchInput.value);
        });
    }

    let timeout = null;
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                performSearch(this.value);
            }, 300); // Wait 300ms after typing
        });
    }

    function performSearch(query) {
        if (query.trim().length === 0) {
            resultsSection.style.display = 'none';
            return;
        }

        resultsSection.style.display = 'block';
        resultsContainer.innerHTML = '<p class="p-4">Searching...</p>';

        fetch('<%= contextPath %>/vendors?action=ajax-search&query=' + encodeURIComponent(query))
            .then(response => response.text())
            .then(html => {
                resultsContainer.innerHTML = html;
            })
            .catch(err => {
                console.error('Search failed:', err);
                resultsContainer.innerHTML = '<p class="p-4 text-danger">Error fetching results.</p>';
            });
    }
});
</script>
</body>
</html>
