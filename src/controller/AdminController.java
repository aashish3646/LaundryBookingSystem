package controller;

import dao.BookingDAO;
import dao.ServiceDAO;
import dao.UserDAO;
import dao.VendorDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin")
public class AdminController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final VendorDAO vendorDAO = new VendorDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request, response)) {
            return;
        }

        String action = getAction(request);
        switch (action) {
            case "users":
                showUsers(request, response);
                break;
            case "toggle-user-status":
                toggleUserStatus(request, response);
                break;
            case "delete-user":
                deleteUser(request, response);
                break;
            case "orders":
                showOrders(request, response);
                break;
            case "reports":
                showReports(request, response);
                break;
            case "approve-user":
                approveUser(request, response);
                break;
            case "reject-user":
                rejectUser(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }

    private void approveUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = parseInt(request.getParameter("id"));
        boolean updated = userId > 0 && userDAO.updateApprovalStatus(userId, "approved");
        redirect(response, request, "users", updated ? "User approved." : "Unable to approve user.", !updated);
    }

    private void rejectUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = parseInt(request.getParameter("id"));
        boolean updated = userId > 0 && userDAO.updateApprovalStatus(userId, "rejected");
        redirect(response, request, "users", updated ? "User rejected." : "Unable to reject user.", !updated);
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalUsers", userDAO.countUsers());
        request.setAttribute("totalVendors", vendorDAO.countVendors());
        request.setAttribute("totalServices", serviceDAO.countServices());
        request.setAttribute("totalBookings", bookingDAO.countBookings());
        request.setAttribute("recentBookings", bookingDAO.getAllBookings());
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("users", userDAO.getAllUsers());
        request.getRequestDispatcher("/admin/manage-users.jsp").forward(request, response);
    }

    private void toggleUserStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = parseInt(request.getParameter("id"));
        if (userId <= 0) {
            redirect(response, request, "users", "Invalid user selected.", true);
            return;
        }

        boolean updated = userDAO.toggleUserStatus(userId);
        redirect(response, request, "users", updated ? "User status updated." : "Unable to update user status.", !updated);
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = parseInt(request.getParameter("id"));
        Integer currentUserId = (Integer) request.getSession().getAttribute("userId");

        if (userId <= 0) {
            redirect(response, request, "users", "Invalid user selected.", true);
            return;
        }
        if (currentUserId != null && currentUserId == userId) {
            redirect(response, request, "users", "You cannot delete your own admin account.", true);
            return;
        }

        boolean deleted = userDAO.deleteUser(userId);
        redirect(response, request, "users", deleted ? "User deleted." : "Unable to delete user. It may be linked to bookings.", !deleted);
    }

    private void showOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("bookings", bookingDAO.getAllBookings());
        request.getRequestDispatcher("/admin/all-orders.jsp").forward(request, response);
    }

    private void showReports(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalUsers", userDAO.countUsers());
        request.setAttribute("totalVendors", vendorDAO.countVendors());
        request.setAttribute("totalServices", serviceDAO.countServices());
        request.setAttribute("totalBookings", bookingDAO.countBookings());
        
        // Detailed analysis for requirement 2d
        request.setAttribute("pendingBookings", bookingDAO.countByStatus("Pending"));
        request.setAttribute("acceptedBookings", bookingDAO.countByStatus("Accepted"));
        request.setAttribute("deliveredBookings", bookingDAO.countByStatus("Delivered"));
        request.setAttribute("totalRevenue", bookingDAO.countRevenue());
        
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }

    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return false;
        }
        return true;
    }

    private String getAction(HttpServletRequest request) {
        String action = request.getParameter("action");
        return action == null ? "dashboard" : action;
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, String action, String message, boolean error) throws IOException {
        String key = error ? "error" : "success";
        response.sendRedirect(request.getContextPath() + "/admin?action=" + action + "&" + key + "=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
}
