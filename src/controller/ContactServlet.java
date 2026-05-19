package controller;

import dao.ContactDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ContactMessage;
import util.ValidationUtil;

import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private final ContactDAO contactDAO = new ContactDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = trim(request.getParameter("name"));
        String email = trim(request.getParameter("email"));
        String subject = trim(request.getParameter("subject"));
        String message = trim(request.getParameter("message"));

        String error = validateContact(name, email, subject, message);
        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        ContactMessage contactMessage = new ContactMessage(name, email, subject, message);
        boolean saved = contactDAO.saveMessage(contactMessage);
        request.setAttribute(saved ? "success" : "error",
                saved ? "Message sent successfully. QuickWash will contact you soon." : "Unable to send message. Please try again.");
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }

    private String validateContact(String name, String email, String subject, String message) {
        if (!ValidationUtil.isValidName(name)) {
            return "Name is required and cannot contain numbers or special characters.";
        }
        if (!ValidationUtil.isValidEmail(email)) {
            return "Please enter a valid email address.";
        }
        if (ValidationUtil.isEmpty(subject)) {
            return "Subject is required.";
        }
        if (ValidationUtil.isEmpty(message)) {
            return "Message is required.";
        }
        return null;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
