package controller;

import dao.BookingDAO;
import dao.SlotDAO;
import dao.VendorDAO;
import model.Booking;
import model.User;
import model.Vendor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/bookings")
public class BookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private VendorDAO vendorDAO;
    private SlotDAO slotDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        vendorDAO = new VendorDAO();
        slotDAO = new SlotDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "my-orders";
        }

        switch (action) {
            case "new":
                showBookingForm(request, response);
                break;
            case "book":
                createBooking(request, response);
                break;
            case "update-status":
                updateStatus(request, response);
                break;
            default:
                listMyOrders(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Vendor> vendors = vendorDAO.getAllVendors();
        request.setAttribute("vendors", vendors);
        request.getRequestDispatcher("user/book-order.jsp").forward(request, response);
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        int vendorId = Integer.parseInt(request.getParameter("vendorId"));
        int slotId = Integer.parseInt(request.getParameter("slotId"));
        String address = request.getParameter("address");
        String clothesType = request.getParameter("clothesType");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String note = request.getParameter("note");

        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setVendorId(vendorId);
        booking.setSlotId(slotId);
        booking.setPickupAddress(address);
        booking.setClothesType(clothesType);
        booking.setQuantity(quantity);
        booking.setPickupNote(note);
        booking.setBookingStatus("Pending");

        if (bookingDAO.createBooking(booking)) {
            slotDAO.updateSlotStatus(slotId, "booked");
            response.sendRedirect("bookings?action=my-orders");
        } else {
            response.sendRedirect("bookings?action=new&error=failed");
        }
    }

    private void listMyOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        List<Booking> bookings = bookingDAO.getBookingsByUser(userId);
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("user/my-orders.jsp").forward(request, response);
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");
        bookingDAO.updateBookingStatus(bookingId, status);
        
        String role = (String) request.getSession().getAttribute("userRole");
        if ("vendor".equalsIgnoreCase(role)) {
            response.sendRedirect("vendor/dashboard.jsp");
        } else {
            response.sendRedirect("admin/dashboard.jsp");
        }
    }
}
