package controller;

import dao.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Service;
import util.ValidationUtil;

import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/services")
public class ServiceController extends HttpServlet {
    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request, response)) {
            return;
        }

        String action = getAction(request);
        switch (action) {
            case "new":
                request.setAttribute("service", new Service());
                request.getRequestDispatcher("/admin/service-form.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteService(request, response);
                break;
            case "list":
            default:
                showServiceList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request, response)) {
            return;
        }

        String action = getAction(request);
        if ("save".equals(action)) {
            saveService(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/services?action=list");
        }
    }

    private void showServiceList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("services", serviceDAO.getAllServices());
        request.getRequestDispatcher("/admin/manage-services.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int serviceId = parseInt(request.getParameter("id"));
        Service service = serviceDAO.getServiceById(serviceId);
        if (service == null) {
            redirect(response, request, "Service not found.", true);
            return;
        }
        request.setAttribute("service", service);
        request.getRequestDispatcher("/admin/service-form.jsp").forward(request, response);
    }

    private void saveService(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Service service = new Service();
        service.setServiceId(parseInt(request.getParameter("service_id")));
        service.setServiceName(trim(request.getParameter("service_name")));
        service.setDescription(trim(request.getParameter("description")));
        service.setPrice(parseDouble(request.getParameter("price")));
        service.setStatus(trim(request.getParameter("status")));

        String error = validateService(service);
        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("service", service);
            request.getRequestDispatcher("/admin/service-form.jsp").forward(request, response);
            return;
        }

        boolean saved = serviceDAO.saveService(service);
        redirect(response, request, saved ? "Service saved." : "Unable to save service.", !saved);
    }

    private void deleteService(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int serviceId = parseInt(request.getParameter("id"));
        boolean deleted = serviceId > 0 && serviceDAO.deleteService(serviceId);
        redirect(response, request, deleted ? "Service deleted." : "Unable to delete service. It may be linked to bookings.", !deleted);
    }

    private String validateService(Service service) {
        if (ValidationUtil.isEmpty(service.getServiceName())) {
            return "Service name is required.";
        }
        if (ValidationUtil.isEmpty(service.getDescription())) {
            return "Description is required.";
        }
        if (!ValidationUtil.isPositiveNumber(service.getPrice())) {
            return "Price must be greater than zero.";
        }
        if (!"active".equals(service.getStatus()) && !"inactive".equals(service.getStatus())) {
            return "Please select a valid status.";
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

    private String getAction(HttpServletRequest request) {
        String action = request.getParameter("action");
        return action == null ? "list" : action;
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private double parseDouble(String value) {
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, String message, boolean error) throws IOException {
        String key = error ? "error" : "success";
        response.sendRedirect(request.getContextPath() + "/services?action=list&" + key + "=" + URLEncoder.encode(message, "UTF-8"));
    }
}
