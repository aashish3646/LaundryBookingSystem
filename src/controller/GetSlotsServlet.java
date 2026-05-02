package controller;

import dao.SlotDAO;
import model.Slot;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/get-slots")
public class GetSlotsServlet extends HttpServlet {

    private SlotDAO slotDAO;

    @Override
    public void init() {
        slotDAO = new SlotDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int vendorId = Integer.parseInt(request.getParameter("vendorId"));
        List<Slot> slots = slotDAO.getAvailableSlots(vendorId);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < slots.size(); i++) {
            Slot s = slots.get(i);
            json.append("{")
                .append("\"slotId\":").append(s.getSlotId()).append(",")
                .append("\"slotDate\":\"").append(s.getSlotDate()).append("\",")
                .append("\"slotTime\":\"").append(s.getSlotTime()).append("\"")
                .append("}");
            if (i < slots.size() - 1) json.append(",");
        }
        json.append("]");
        
        out.print(json.toString());
        out.flush();
    }
}
