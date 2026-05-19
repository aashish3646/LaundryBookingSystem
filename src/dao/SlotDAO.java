package dao;

import model.Slot;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SlotDAO {

    public List<Slot> getAvailableSlots() {
        List<Slot> slots = new ArrayList<>();
        String sql = "SELECT sl.slot_id, sl.vendor_id, sl.slot_date, sl.slot_time, sl.availability_status, v.vendor_name "
                + "FROM slots sl JOIN vendors v ON sl.vendor_id = v.vendor_id "
                + "WHERE sl.availability_status = 'available' AND v.status = 'active' "
                + "ORDER BY sl.slot_date, sl.slot_time";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                slots.add(mapSlot(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return slots;
    }

    public List<Slot> getAvailableSlotsByVendor(int vendorId) {
        List<Slot> slots = new ArrayList<>();
        String sql = "SELECT sl.slot_id, sl.vendor_id, sl.slot_date, sl.slot_time, sl.availability_status, v.vendor_name "
                + "FROM slots sl JOIN vendors v ON sl.vendor_id = v.vendor_id "
                + "WHERE sl.availability_status = 'available' AND v.status = 'active' AND sl.vendor_id = ? "
                + "ORDER BY sl.slot_date, sl.slot_time";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    slots.add(mapSlot(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return slots;
    }

    public List<Slot> getSlotsByVendor(int vendorId) {
        List<Slot> slots = new ArrayList<>();
        String sql = "SELECT sl.slot_id, sl.vendor_id, sl.slot_date, sl.slot_time, sl.availability_status, v.vendor_name "
                + "FROM slots sl JOIN vendors v ON sl.vendor_id = v.vendor_id "
                + "WHERE sl.vendor_id = ? ORDER BY sl.slot_date, sl.slot_time";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    slots.add(mapSlot(rs));
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
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, slot.getVendorId());
            ps.setString(2, slot.getSlotDate());
            ps.setString(3, slot.getSlotTime());
            ps.setString(4, slot.getAvailabilityStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateSlotStatus(int slotId, int vendorId, String status) {
        String sql = "UPDATE slots SET availability_status = ? WHERE slot_id = ? AND vendor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, slotId);
            ps.setInt(3, vendorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteSlotIfUnused(int slotId, int vendorId) {
        String sql = "DELETE FROM slots WHERE slot_id = ? AND vendor_id = ? "
                + "AND NOT EXISTS (SELECT 1 FROM bookings WHERE bookings.slot_id = slots.slot_id)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            ps.setInt(2, vendorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean slotBelongsToVendor(int slotId, int vendorId) {
        String sql = "SELECT slot_id FROM slots WHERE slot_id = ? AND vendor_id = ? AND availability_status = 'available'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            ps.setInt(2, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Slot mapSlot(ResultSet rs) throws SQLException {
        Slot slot = new Slot();
        slot.setSlotId(rs.getInt("slot_id"));
        slot.setVendorId(rs.getInt("vendor_id"));
        slot.setSlotDate(rs.getString("slot_date"));
        slot.setSlotTime(rs.getString("slot_time"));
        slot.setAvailabilityStatus(rs.getString("availability_status"));
        slot.setVendorName(rs.getString("vendor_name"));
        return slot;
    }
}
