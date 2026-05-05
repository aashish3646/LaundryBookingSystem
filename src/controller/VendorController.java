package controller;

import dao.BookingDAO;
import dao.SlotDAO;
import dao.VendorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Slot;
import model.Vendor;

import java.io.IOException;
import java.net.URLEncoder;

@WebServlet({"/vendors", "/vendor"})
public class VendorController extends HttpServlet {
    private final VendorDAO vendorDAO = new VendorDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final SlotDAO slotDAO = new SlotDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (isVendorPortal(request)) {
            handleVendorGet(request, response);
            return;
        }

        if (!isAdmin(request, response)) {
            return;
        }

        String action = getAction(request);
        switch (action) {
            case "new":
                request.setAttribute("vendor", new Vendor());
                request.getRequestDispatcher("/admin/vendor-form.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteVendor(request, response);
                break;
            case "approve":
                approveVendor(request, response);
                break;
            case "ajax-search":
                ajaxSearch(request, response);
                break;
            case "list":
            default:
                showVendorList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (isVendorPortal(request)) {
            handleVendorPost(request, response);
            return;
        }

        if (!isAdmin(request, response)) {
            return;
        }

        String action = getAction(request);
        if ("save".equals(action)) {
            saveVendor(request, response);
        } else if ("reject".equals(action)) {
            rejectVendor(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/vendors?action=list");
        }
    }

    private void handleVendorGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int userId = (Integer) session.getAttribute("userId");
        Vendor vendor = vendorDAO.getVendorByUserId(userId);

        if (vendor == null || !"approved".equals(vendor.getApprovalStatus())) {
            request.setAttribute("vendor", vendor);
            request.getRequestDispatcher("/vendor/verification.jsp").forward(request, response);
            return;
        }

        String action = getAction(request);
        switch (action) {
            case "orders":
                showVendorOrders(request, response, vendor);
                break;
            case "availability":
                showAvailability(request, response, vendor);
                break;
            case "delete-slot":
                deleteSlot(request, response, vendor);
                break;
            default:
                showVendorDashboard(request, response, vendor);
                break;
        }
    }

    private void handleVendorPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Vendor vendor = vendorDAO.getVendorByUserId((Integer) session.getAttribute("userId"));
        
        if (vendor == null || !"approved".equals(vendor.getApprovalStatus())) {
            response.sendRedirect(request.getContextPath() + "/vendor");
            return;
        }

        String action = getAction(request);
        switch (action) {
            case "update-status":
                updateBookingStatus(request, response, vendor);
                break;
            case "add-slot":
                addSlot(request, response, vendor);
                break;
            case "update-slot":
                updateSlotStatus(request, response, vendor);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/vendor");
                break;
        }
    }

    private void showVendorDashboard(HttpServletRequest request, HttpServletResponse response, Vendor vendor) throws ServletException, IOException {
        int vendorId = vendor.getVendorId();
        request.setAttribute("vendor", vendor);
        request.setAttribute("assignedOrders", bookingDAO.countBookingsByVendorId(vendorId));
        request.setAttribute("pendingOrders", bookingDAO.countBookingsByVendorStatus(vendorId, "Pending"));
        request.setAttribute("inProgressOrders", bookingDAO.countInProgressBookingsByVendor(vendorId));
        request.setAttribute("deliveredOrders", bookingDAO.countBookingsByVendorStatus(vendorId, "Delivered"));
        request.setAttribute("bookings", bookingDAO.getBookingsByVendorId(vendorId));
        request.getRequestDispatcher("/vendor/dashboard.jsp").forward(request, response);
    }

    private void showVendorOrders(HttpServletRequest request, HttpServletResponse response, Vendor vendor) throws ServletException, IOException {
        request.setAttribute("vendor", vendor);
        request.setAttribute("bookings", bookingDAO.getBookingsByVendorId(vendor.getVendorId()));
        request.getRequestDispatcher("/vendor/orders.jsp").forward(request, response);
    }

    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response, Vendor vendor) throws IOException {
        int bookingId = parseInt(request.getParameter("booking_id"));
        String status = trim(request.getParameter("status"));

        if (!isValidBookingStatus(status)) {
            redirectVendor(response, request, "orders", "Invalid booking status.", true);
            return;
        }

        boolean updated = bookingId > 0 && bookingDAO.updateBookingStatusForVendor(bookingId, vendor.getVendorId(), status);
        redirectVendor(response, request, "orders", updated ? "Booking status updated." : "Unable to update booking status.", !updated);
    }

    private void showAvailability(HttpServletRequest request, HttpServletResponse response, Vendor vendor) throws ServletException, IOException {
        request.setAttribute("vendor", vendor);
        request.setAttribute("slots", slotDAO.getSlotsByVendor(vendor.getVendorId()));
        request.getRequestDispatcher("/vendor/availability.jsp").forward(request, response);
    }

    private void addSlot(HttpServletRequest request, HttpServletResponse response, Vendor vendor) throws IOException {
        Slot slot = new Slot();
        slot.setVendorId(vendor.getVendorId());
        slot.setSlotDate(trim(request.getParameter("slot_date")));
        slot.setSlotTime(trim(request.getParameter("slot_time")));
        slot.setAvailabilityStatus(trim(request.getParameter("availability_status")));

        String error = validateSlot(slot);
        if (error != null) {
            redirectVendor(response, request, "availability", error, true);
            return;
        }

        boolean added = slotDAO.addSlot(slot);
        redirectVendor(response, request, "availability", added ? "Slot added." : "Unable to add slot.", !added);
    }

    private void updateSlotStatus(HttpServletRequest request, HttpServletResponse response, Vendor vendor) throws IOException {
        int slotId = parseInt(request.getParameter("slot_id"));
        String status = trim(request.getParameter("availability_status"));

        if (!isValidSlotStatus(status)) {
            redirectVendor(response, request, "availability", "Invalid slot availability status.", true);
            return;
        }

        boolean updated = slotId > 0 && slotDAO.updateSlotStatus(slotId, vendor.getVendorId(), status);
        redirectVendor(response, request, "availability", updated ? "Slot availability updated." : "Unable to update slot.", !updated);
    }

    private void deleteSlot(HttpServletRequest request, HttpServletResponse response, Vendor vendor) throws IOException {
        int slotId = parseInt(request.getParameter("id"));
        boolean deleted = slotId > 0 && slotDAO.deleteSlotIfUnused(slotId, vendor.getVendorId());
        redirectVendor(response, request, "availability", deleted ? "Slot deleted." : "Unable to delete slot. It may already be used in a booking.", !deleted);
    }

    private void ajaxSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = trim(request.getParameter("query"));
        request.setAttribute("vendors", vendorDAO.searchVendors(query));
        request.getRequestDispatcher("/user/vendor-list-fragment.jsp").forward(request, response);
    }

    private void showVendorList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("vendors", vendorDAO.getAllVendors());
        request.getRequestDispatcher("/admin/manage-vendors.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int vendorId = parseInt(request.getParameter("id"));
        Vendor vendor = vendorDAO.getVendorById(vendorId);
        if (vendor == null) {
            redirect(response, request, "Vendor not found.", true);
            return;
        }
        request.setAttribute("vendor", vendor);
        request.getRequestDispatcher("/admin/vendor-form.jsp").forward(request, response);
    }

    private void approveVendor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int vendorId = parseInt(request.getParameter("id"));
        boolean updated = vendorId > 0 && vendorDAO.updateApprovalStatus(vendorId, "approved", "Profile approved by administrator.");
        redirect(response, request, updated ? "Vendor approved." : "Unable to approve vendor.", !updated);
    }

    private void rejectVendor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int vendorId = parseInt(request.getParameter("vendor_id"));
        String remarks = trim(request.getParameter("admin_remarks"));
        if (remarks.isEmpty()) {
            remarks = "Profile rejected by administrator.";
        }
        boolean updated = vendorId > 0 && vendorDAO.updateApprovalStatus(vendorId, "rejected", remarks);
        redirect(response, request, updated ? "Vendor rejected." : "Unable to reject vendor.", !updated);
    }

    private void saveVendor(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Vendor vendor = new Vendor();
        vendor.setVendorId(parseInt(request.getParameter("vendor_id")));
        vendor.setVendorName(trim(request.getParameter("vendor_name")));
        vendor.setOwnerName(trim(request.getParameter("owner_name")));
        vendor.setArea(trim(request.getParameter("area")));
        vendor.setContact(trim(request.getParameter("contact")));
        vendor.setServiceType(trim(request.getParameter("service_type")));
        vendor.setPriceRange(trim(request.getParameter("price_range")));
        vendor.setDocumentType(trim(request.getParameter("document_type")));
        vendor.setApprovalStatus(trim(request.getParameter("approval_status")));
        vendor.setAdminRemarks(trim(request.getParameter("admin_remarks")));
        vendor.setStatus(trim(request.getParameter("status")));

        String error = validateVendor(vendor);
        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("vendor", vendor);
            request.getRequestDispatcher("/admin/vendor-form.jsp").forward(request, response);
            return;
        }

        boolean saved = vendorDAO.saveVendor(vendor);
        redirect(response, request, saved ? "Vendor saved." : "Unable to save vendor.", !saved);
    }

    private void deleteVendor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int vendorId = parseInt(request.getParameter("id"));
        boolean deleted = vendorId > 0 && vendorDAO.deleteVendor(vendorId);
        redirect(response, request, deleted ? "Vendor deleted." : "Unable to delete vendor. It may be linked to bookings.", !deleted);
    }

    private String validateVendor(Vendor vendor) {
        if (isEmpty(vendor.getVendorName())) {
            return "Vendor name is required.";
        }
        if (isEmpty(vendor.getArea())) {
            return "Area is required.";
        }
        if (isEmpty(vendor.getContact())) {
            return "Contact is required.";
        }
        if (isEmpty(vendor.getServiceType())) {
            return "Service type is required.";
        }
        if (isEmpty(vendor.getPriceRange())) {
            return "Price range is required.";
        }
        if (!"active".equals(vendor.getStatus()) && !"inactive".equals(vendor.getStatus())) {
            return "Please select a valid status.";
        }
        if (isEmpty(vendor.getApprovalStatus())) {
            return "Approval status is required.";
        }
        return null;
    }

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return false;
        }
        return true;
    }

    private Vendor getLinkedVendor(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"vendor".equals(session.getAttribute("userRole")) || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return null;
        }

        Vendor vendor = vendorDAO.getVendorByUserId((Integer) session.getAttribute("userId"));
        if (vendor == null) {
            request.getSession().setAttribute("vendorError", "Vendor profile is not linked. Please contact admin.");
            response.sendRedirect(request.getContextPath() + "/vendor/dashboard.jsp");
        }
        return vendor;
    }

    private String getAction(HttpServletRequest request) {
        String action = request.getParameter("action");
        if (action != null) {
            return action;
        }
        return isVendorPortal(request) ? "dashboard" : "list";
    }

    private boolean isVendorPortal(HttpServletRequest request) {
        return request.getServletPath().equals("/vendor");
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, String message, boolean error) throws IOException {
        String key = error ? "error" : "success";
        response.sendRedirect(request.getContextPath() + "/vendors?action=list&" + key + "=" + URLEncoder.encode(message, "UTF-8"));
    }

    private void redirectVendor(HttpServletResponse response, HttpServletRequest request, String action, String message, boolean error) throws IOException {
        String key = error ? "error" : "success";
        response.sendRedirect(request.getContextPath() + "/vendor?action=" + action + "&" + key + "=" + URLEncoder.encode(message, "UTF-8"));
    }

    private boolean isValidBookingStatus(String status) {
        return "Accepted".equals(status)
                || "Picked Up".equals(status)
                || "Washing".equals(status)
                || "Ready".equals(status)
                || "Delivered".equals(status)
                || "Cancelled".equals(status);
    }

    private boolean isValidSlotStatus(String status) {
        return "available".equals(status) || "booked".equals(status) || "unavailable".equals(status);
    }

    private String validateSlot(Slot slot) {
        if (isEmpty(slot.getSlotDate())) {
            return "Slot date is required.";
        }
        if (isEmpty(slot.getSlotTime())) {
            return "Slot time is required.";
        }
        if (!isValidSlotStatus(slot.getAvailabilityStatus())) {
            return "Please select a valid slot availability status.";
        }
        return null;
    }
}
