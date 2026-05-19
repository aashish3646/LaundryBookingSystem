package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/shortlist")
public class ShortlistServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String vendorIdStr = request.getParameter("vendor_id");
        
        if (vendorIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
            return;
        }
        
        int vendorId = Integer.parseInt(vendorIdStr);
        HttpSession session = request.getSession();
        List<Integer> shortlist = (List<Integer>) session.getAttribute("shortlist");
        
        if (shortlist == null) {
            shortlist = new ArrayList<>();
        }
        
        if ("add".equals(action)) {
            if (!shortlist.contains(vendorId)) {
                shortlist.add(vendorId);
            }
        } else if ("remove".equals(action)) {
            shortlist.remove(Integer.valueOf(vendorId));
        }
        
        session.setAttribute("shortlist", shortlist);
        response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?success=Shortlist updated");
    }
}
