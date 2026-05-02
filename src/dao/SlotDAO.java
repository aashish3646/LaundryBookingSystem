package dao;

import model.Slot;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SlotDAO {

    public List<Slot> getAvailableSlots(int vendorId) {
        List<Slot> slots = new ArrayList<>();
        String sql = "SELECT * FROM slots WHERE vendor_id = ? AND availability_status = 'available'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, vendorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    slots.add(mapResultSetToSlot(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return slots;
    }

    public boolean addSlot(Slot slot) {
        String sql = "INSERT INTO slots (vendor_id, slot_date, slot_time, availability_status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, slot.getVendorId());
            stmt.setDate(2, Date.valueOf(slot.getSlotDate()));
            stmt.setString(3, slot.getSlotTime());
            stmt.setString(4, slot.getAvailabilityStatus());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSlotStatus(int slotId, String status) {
        String sql = "UPDATE slots SET availability_status = ? WHERE slot_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, slotId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Slot mapResultSetToSlot(ResultSet rs) throws SQLException {
        Slot slot = new Slot();
        slot.setSlotId(rs.getInt("slot_id"));
        slot.setVendorId(rs.getInt("vendor_id"));
        slot.setSlotDate(rs.getDate("slot_date").toLocalDate());
        slot.setSlotTime(rs.getString("slot_time"));
        slot.setAvailabilityStatus(rs.getString("availability_status"));
        return slot;
    }
}
