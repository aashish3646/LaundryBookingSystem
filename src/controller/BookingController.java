package controller;

import dao.BookingDAO;
import dao.ServiceDAO;
import dao.SlotDAO;
import dao.VendorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.Service;
import util.ValidationUtil;

import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/bookings")
public class BookingController extends HttpServlet {
    private final BookingDAO bookingDAO = new BookingDAO();
    private final VendorDAO vendorDAO = new VendorDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final SlotDAO slotDAO = new SlotDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = getUserId(request, response);
        if (userId == null) {
            return;
        }

        String action = getAction(request);
        switch (action) {
            case "new":
                showBookingForm(request, response);
                break;
            case "my-orders":
                showMyOrders(request, response, userId);
                break;
            case "cancel":
                cancelBooking(request, response, userId);
                break;
            case "track":
                showTrackStatus(request, response, userId);
                break;
            case "receipt":
                showReceipt(request, response, userId);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer userId = getUserId(request, response);
        if (userId == null) {
            return;
        }

        String action = getAction(request);
        if ("create".equals(action)) {
            createBooking(request, response, userId);
        } else {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
        }
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        loadBookingFormData(request);
        request.getRequestDispatcher("/user/book-order.jsp").forward(request, response);
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setVendorId(parseInt(request.getParameter("vendor_id")));
        booking.setServiceId(parseInt(request.getParameter("service_id")));
        booking.setSlotId(parseInt(request.getParameter("slot_id")));
        booking.setPickupAddress(trim(request.getParameter("pickup_address")));
        booking.setClothesType(trim(request.getParameter("clothes_type")));
        booking.setQuantity(parseInt(request.getParameter("quantity")));
        booking.setPickupNote(trim(request.getParameter("pickup_note")));

        String error = validateBooking(booking);
        if (error == null && !slotDAO.slotBelongsToVendor(booking.getSlotId(), booking.getVendorId())) {
            error = "Please select an available pickup slot for the selected vendor.";
        }

        Service service = serviceDAO.getServiceById(booking.getServiceId());
        if (error == null && (service == null || !"active".equals(service.getStatus()))) {
            error = "Please select an active laundry service.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("booking", booking);
            loadBookingFormData(request);
            request.getRequestDispatcher("/user/book-order.jsp").forward(request, response);
            return;
        }

        double totalPrice = service.getPrice() * booking.getQuantity();
        boolean created = bookingDAO.createBooking(booking, totalPrice);
        if (created) {
            // Mark the slot as booked
            slotDAO.updateSlotStatus(booking.getSlotId(), booking.getVendorId(), "booked");
            response.sendRedirect(request.getContextPath() + "/bookings?action=my-orders&success=" + URLEncoder.encode("Booking created successfully.", "UTF-8"));
        } else {
            request.setAttribute("error", "Unable to create booking. Please try again.");
            request.setAttribute("booking", booking);
            loadBookingFormData(request);
            request.getRequestDispatcher("/user/book-order.jsp").forward(request, response);
        }
    }

    private void showMyOrders(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        request.setAttribute("bookings", bookingDAO.getBookingsByUserId(userId));
        request.getRequestDispatcher("/user/my-orders.jsp").forward(request, response);
    }

    private void showTrackStatus(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        request.setAttribute("bookings", bookingDAO.getBookingsByUserId(userId));
        request.getRequestDispatcher("/user/track-status.jsp").forward(request, response);
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response, int userId) throws IOException {
        int bookingId = parseInt(request.getParameter("id"));
        boolean cancelled = bookingId > 0 && bookingDAO.cancelPendingBooking(bookingId, userId);
        String message = cancelled ? "Pending booking cancelled." : "Only pending bookings can be cancelled.";
        String key = cancelled ? "success" : "error";
        response.sendRedirect(request.getContextPath() + "/bookings?action=my-orders&" + key + "=" + URLEncoder.encode(message, "UTF-8"));
    }

    private void showReceipt(HttpServletRequest request, HttpServletResponse response, int userId) throws ServletException, IOException {
        int bookingId = parseInt(request.getParameter("id"));
        Booking booking = bookingDAO.getBookingById(bookingId);

        if (booking == null || booking.getUserId() != userId) {
            response.sendRedirect(request.getContextPath() + "/bookings?action=my-orders&error=Invalid booking.");
            return;
        }

        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/user/receipt.jsp").forward(request, response);
    }

    private void loadBookingFormData(HttpServletRequest request) {
        request.setAttribute("vendors", vendorDAO.getActiveVendors());
        request.setAttribute("services", serviceDAO.getActiveServices());
        request.setAttribute("slots", slotDAO.getAvailableSlots());
    }

    private String validateBooking(Booking booking) {
        if (!ValidationUtil.isPositiveInteger(booking.getVendorId())) {
            return "Vendor is required.";
        }
        if (!ValidationUtil.isPositiveInteger(booking.getServiceId())) {
            return "Service is required.";
        }
        if (!ValidationUtil.isPositiveInteger(booking.getSlotId())) {
            return "Pickup slot is required.";
        }
        if (ValidationUtil.isEmpty(booking.getPickupAddress())) {
            return "Pickup address is required.";
        }
        if (ValidationUtil.isEmpty(booking.getClothesType())) {
            return "Clothes type is required.";
        }
        if (!ValidationUtil.isPositiveInteger(booking.getQuantity())) {
            return "Quantity must be positive.";
        }
        return null;
    }

    private Integer getUserId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"user".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return null;
        }
        return (Integer) session.getAttribute("userId");
    }

    private String getAction(HttpServletRequest request) {
        String action = request.getParameter("action");
        return action == null ? "my-orders" : action;
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
}
