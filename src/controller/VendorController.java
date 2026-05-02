package controller;

import dao.VendorDAO;
import model.Vendor;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/vendors")
public class VendorController extends HttpServlet {

    private VendorDAO vendorDAO;

    @Override
    public void init() {
        vendorDAO = new VendorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "insert":
                insertVendor(request, response);
                break;
            case "delete":
                deleteVendor(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "update":
                updateVendor(request, response);
                break;
            default:
                listVendors(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void listVendors(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Vendor> listVendor = vendorDAO.getAllVendors();
        request.setAttribute("listVendor", listVendor);
        request.getRequestDispatcher("admin/manage-vendors.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("admin/vendor-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Vendor existingVendor = vendorDAO.getVendorById(id);
        request.setAttribute("vendor", existingVendor);
        request.getRequestDispatcher("admin/vendor-form.jsp").forward(request, response);
    }

    private void insertVendor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("name");
        String area = request.getParameter("area");
        String contact = request.getParameter("contact");
        String serviceType = request.getParameter("serviceType");
        String priceRange = request.getParameter("priceRange");

        Vendor newVendor = new Vendor(0, name, area, contact, serviceType, priceRange);
        vendorDAO.addVendor(newVendor);
        response.sendRedirect("vendors?action=list");
    }

    private void updateVendor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String area = request.getParameter("area");
        String contact = request.getParameter("contact");
        String serviceType = request.getParameter("serviceType");
        String priceRange = request.getParameter("priceRange");

        Vendor vendor = new Vendor(id, name, area, contact, serviceType, priceRange);
        vendorDAO.updateVendor(vendor);
        response.sendRedirect("vendors?action=list");
    }

    private void deleteVendor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        vendorDAO.deleteVendor(id);
        response.sendRedirect("vendors?action=list");
    }
}
