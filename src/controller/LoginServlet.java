package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.ValidationUtil;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (ValidationUtil.isEmpty(email) || ValidationUtil.isEmpty(password)) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (!ValidationUtil.isValidEmail(email.trim())) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.loginUser(email.trim(), password);

        if (user == null) {
            request.setAttribute("error", "Invalid email or password, or your account is inactive.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (!"approved".equals(user.getApprovalStatus())) {
            String msg = "pending".equals(user.getApprovalStatus()) 
                ? "Your account is awaiting administrator approval." 
                : "Your registration request was rejected. Please contact support.";
            request.setAttribute("error", msg);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("userEmail", user.getEmail());
        session.setAttribute("userRole", user.getRole());

        handleRememberEmailCookie(request, response, user.getEmail());
        redirectByRole(request, response, user.getRole());
    }

    private void handleRememberEmailCookie(HttpServletRequest request, HttpServletResponse response, String email) {
        boolean rememberEmail = "on".equals(request.getParameter("rememberEmail"));
        Cookie cookie = new Cookie("rememberedEmail", rememberEmail ? email : "");
        cookie.setPath(getCookiePath(request));
        cookie.setHttpOnly(true);
        cookie.setMaxAge(rememberEmail ? 7 * 24 * 60 * 60 : 0);
        response.addCookie(cookie);
    }

    private String getCookiePath(HttpServletRequest request) {
        String contextPath = request.getContextPath();
        return contextPath == null || contextPath.isEmpty() ? "/" : contextPath;
    }

    private void redirectByRole(HttpServletRequest request, HttpServletResponse response, String role) throws IOException {
        String contextPath = request.getContextPath();

        if ("admin".equals(role)) {
            response.sendRedirect(contextPath + "/admin");
        } else if ("vendor".equals(role)) {
            response.sendRedirect(contextPath + "/vendor");
        } else {
            response.sendRedirect(contextPath + "/user/dashboard.jsp");
        }
    }
}
