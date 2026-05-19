<%@ page import="java.util.List" %>
<%@ page import="model.Vendor" %>
<%
    List<Vendor> vendors = (List<Vendor>) request.getAttribute("vendors");
    String contextPath = request.getContextPath();
    List<Integer> shortlistIds = (List<Integer>) session.getAttribute("shortlist");

    if (vendors == null || vendors.isEmpty()) {
%>
    <p class="p-4 muted">No vendors found matching your search.</p>
<%
    } else {
        for (Vendor v : vendors) {
            boolean isShortlisted = shortlistIds != null && shortlistIds.contains(v.getVendorId());
%>
    <div class="vendor-card-large">
        <div class="v-info">
            <h4><%= v.getVendorName() %></h4>
            <div class="v-rating">
                <span class="stars" style="color: #ffc107;">
                    <%= v.getAverageRating() > 0 ? String.format("%.1f", v.getAverageRating()) + " ★" : "No ratings" %>
                </span>
                <small class="muted">(<%= v.getReviewCount() %> reviews)</small>
            </div>
            <p class="muted"><%= v.getArea() %></p>
            <span class="price-tag"><%= v.getPriceRange() %></span>
        </div>
        <div class="v-actions">
            <a href="<%= contextPath %>/bookings?action=new&vendor_id=<%= v.getVendorId() %>" class="btn btn-primary btn-small">Book Now</a>
            <a href="<%= contextPath %>/shortlist?action=<%= isShortlisted ? "remove" : "add" %>&vendor_id=<%= v.getVendorId() %>" 
               class="btn <%= isShortlisted ? "btn-danger" : "btn-secondary" %> btn-small">
               <%= isShortlisted ? "♥ Remove" : "♡ Shortlist" %>
            </a>
        </div>
    </div>
<%
        }
    }
%>
