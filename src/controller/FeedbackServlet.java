package controller;

import dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("booking_id");
        request.setAttribute("bookingId", bookingId);
        request.getRequestDispatcher("/user/give-feedback.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String sessionToken = (String) session.getAttribute("csrfToken");
        String requestToken = request.getParameter("csrf_token");
        if (sessionToken == null || !sessionToken.equals(requestToken)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF token.");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        int bookingId = util.ValidationUtil.parseInt(request.getParameter("booking_id"), 0);
        int rating = util.ValidationUtil.parseInt(request.getParameter("rating"), 0);
        String comment = request.getParameter("comment");

        boolean success = feedbackDAO.submitFeedback(userId, bookingId, rating, comment);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/bookings?action=my-orders&success=" + URLEncoder.encode("Thank you for your feedback!", "UTF-8"));
        } else {
            response.sendRedirect(request.getContextPath() + "/bookings?action=my-orders&error=" + URLEncoder.encode("Unable to submit feedback.", "UTF-8"));
        }
    }
}
