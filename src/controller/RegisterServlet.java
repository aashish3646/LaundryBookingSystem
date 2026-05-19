package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.ValidationUtil;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        String error = validateRegistration(name, email, phone, password, confirmPassword, role);
        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email is already registered. Please use another email or login.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User(name.trim(), email.trim(), password, phone.trim(), role);
        boolean registered = userDAO.registerUser(user);

        if (registered) {
            HttpSession session = request.getSession();
            session.setAttribute("success", "Registration successful. Please login to continue.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private String validateRegistration(String name, String email, String phone, String password, String confirmPassword, String role) {
        if (!ValidationUtil.isValidName(name)) {
            return "Name is required and cannot contain numbers or special characters.";
        }
        if (!ValidationUtil.isValidEmail(email)) {
            return "Please enter a valid email address.";
        }
        if (!ValidationUtil.isValidPhone(phone)) {
            return "Phone number must contain 7 to 15 digits only.";
        }
        if (!ValidationUtil.isValidPassword(password)) {
            return "Password must be at least 6 characters long.";
        }
        if (!password.equals(confirmPassword)) {
            return "Password and confirm password do not match.";
        }
        if (!"user".equals(role) && !"vendor".equals(role)) {
            return "Please select a valid role.";
        }
        return null;
    }
}
