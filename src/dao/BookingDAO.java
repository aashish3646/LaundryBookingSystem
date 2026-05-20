package dao;

import model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import java.util.logging.Level;

public class BookingDAO {

    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.user_id, b.vendor_id, b.service_id, b.slot_id, b.pickup_address, b.clothes_type, "
                + "b.quantity, b.pickup_note, b.booking_status, b.created_at, b.total_price, u.name AS customer_name, "
                + "v.vendor_name, s.service_name, sl.slot_date, sl.slot_time "
                + "FROM bookings b "
                + "JOIN users u ON b.user_id = u.user_id "
                + "JOIN vendors v ON b.vendor_id = v.vendor_id "
                + "JOIN services s ON b.service_id = s.service_id "
                + "JOIN slots sl ON b.slot_id = sl.slot_id "
                + "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                bookings.add(mapBooking(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getAllBookings", e);
        }

        return bookings;
    }

    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.user_id, b.vendor_id, b.service_id, b.slot_id, b.pickup_address, b.clothes_type, "
                + "b.quantity, b.pickup_note, b.booking_status, b.created_at, b.total_price, u.name AS customer_name, "
                + "v.vendor_name, s.service_name, sl.slot_date, sl.slot_time "
                + "FROM bookings b "
                + "JOIN users u ON b.user_id = u.user_id "
                + "JOIN vendors v ON b.vendor_id = v.vendor_id "
                + "JOIN services s ON b.service_id = s.service_id "
                + "JOIN slots sl ON b.slot_id = sl.slot_id "
                + "WHERE b.user_id = ? "
                + "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBooking(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getBookingsByUserId", e);
        }

        return bookings;
    }

    public List<Booking> getBookingsByVendorId(int vendorId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.booking_id, b.user_id, b.vendor_id, b.service_id, b.slot_id, b.pickup_address, b.clothes_type, "
                + "b.quantity, b.pickup_note, b.booking_status, b.created_at, b.total_price, u.name AS customer_name, "
                + "v.vendor_name, s.service_name, sl.slot_date, sl.slot_time "
                + "FROM bookings b "
                + "JOIN users u ON b.user_id = u.user_id "
                + "JOIN vendors v ON b.vendor_id = v.vendor_id "
                + "JOIN services s ON b.service_id = s.service_id "
                + "JOIN slots sl ON b.slot_id = sl.slot_id "
                + "WHERE b.vendor_id = ? "
                + "ORDER BY b.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBooking(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getBookingsByVendorId", e);
        }

        return bookings;
    }

    public boolean createBooking(Booking booking, double totalPrice) {
        String lockSlotSql = "SELECT availability_status FROM slots WHERE slot_id = ? AND vendor_id = ? FOR UPDATE";
        String updateSlotSql = "UPDATE slots SET availability_status = 'booked' WHERE slot_id = ?";
        String insertBookingSql = "INSERT INTO bookings (user_id, vendor_id, service_id, slot_id, clothes_type, quantity, pickup_address, pickup_note, total_price, booking_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'Pending')";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement lockPs = conn.prepareStatement(lockSlotSql)) {
                lockPs.setInt(1, booking.getSlotId());
                lockPs.setInt(2, booking.getVendorId());
                try (ResultSet rs = lockPs.executeQuery()) {
                    if (!rs.next() || !"available".equals(rs.getString("availability_status"))) {
                        conn.rollback();
                        return false;
                    }
                }
            }

            try (PreparedStatement updatePs = conn.prepareStatement(updateSlotSql)) {
                updatePs.setInt(1, booking.getSlotId());
                if (updatePs.executeUpdate() <= 0) {
                    conn.rollback();
                    return false;
                }
            }

            try (PreparedStatement insertPs = conn.prepareStatement(insertBookingSql)) {
                insertPs.setInt(1, booking.getUserId());
                insertPs.setInt(2, booking.getVendorId());
                insertPs.setInt(3, booking.getServiceId());
                insertPs.setInt(4, booking.getSlotId());
                insertPs.setString(5, booking.getClothesType());
                insertPs.setInt(6, booking.getQuantity());
                insertPs.setString(7, booking.getPickupAddress());
                insertPs.setString(8, booking.getPickupNote());
                insertPs.setDouble(9, totalPrice);
                if (insertPs.executeUpdate() <= 0) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in createBooking transaction", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error during rollback in createBooking", ex);
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing connection in createBooking", e);
                }
            }
        }
    }

    public boolean cancelPendingBooking(int bookingId, int userId) {
        String sql = "UPDATE bookings SET booking_status = 'Cancelled' WHERE booking_id = ? AND user_id = ? AND booking_status = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in cancelPendingBooking", e);
            return false;
        }
    }

    public boolean updateBookingStatusForVendor(int bookingId, int vendorId, String status) {
        String sql = "UPDATE bookings SET booking_status = ? WHERE booking_id = ? AND vendor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, bookingId);
            ps.setInt(3, vendorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in updateBookingStatusForVendor", e);
            return false;
        }
    }

    public int countBookingsByVendorId(int vendorId) {
        return countByVendor(vendorId, null);
    }

    public int countBookingsByVendorStatus(int vendorId, String status) {
        return countByVendor(vendorId, status);
    }

    public int countInProgressBookingsByVendor(int vendorId) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE vendor_id = ? AND booking_status IN ('Accepted', 'Picked Up', 'Washing', 'Ready')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countInProgressBookingsByVendor", e);
        }

        return 0;
    }

    private int countByVendor(int vendorId, String status) {
        String sql = status == null
                ? "SELECT COUNT(*) FROM bookings WHERE vendor_id = ?"
                : "SELECT COUNT(*) FROM bookings WHERE vendor_id = ? AND booking_status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vendorId);
            if (status != null) {
                ps.setString(2, status);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countByVendor", e);
        }

        return 0;
    }

    public int countBookings() {
        String sql = "SELECT COUNT(*) FROM bookings";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countBookings", e);
        }

        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE booking_status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countByStatus", e);
        }
        return 0;
    }

    public double countRevenue() {
        String sql = "SELECT SUM(total_price) FROM bookings WHERE booking_status = 'Delivered'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in countRevenue", e);
        }
        return 0.0;
    }

    public Booking getBookingById(int bookingId) {
        String sql = "SELECT b.booking_id, b.user_id, b.vendor_id, b.service_id, b.slot_id, b.pickup_address, b.clothes_type, "
                + "b.quantity, b.pickup_note, b.booking_status, b.created_at, b.total_price, u.name AS customer_name, "
                + "v.vendor_name, s.service_name, sl.slot_date, sl.slot_time "
                + "FROM bookings b "
                + "JOIN users u ON b.user_id = u.user_id "
                + "JOIN vendors v ON b.vendor_id = v.vendor_id "
                + "JOIN services s ON b.service_id = s.service_id "
                + "JOIN slots sl ON b.slot_id = sl.slot_id "
                + "WHERE b.booking_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBooking(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in getBookingById", e);
        }
        return null;
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setVendorId(rs.getInt("vendor_id"));
        booking.setServiceId(rs.getInt("service_id"));
        booking.setSlotId(rs.getInt("slot_id"));
        booking.setPickupAddress(rs.getString("pickup_address"));
        booking.setClothesType(rs.getString("clothes_type"));
        booking.setQuantity(rs.getInt("quantity"));
        booking.setPickupNote(rs.getString("pickup_note"));
        booking.setBookingStatus(rs.getString("booking_status"));
        booking.setCreatedAt(rs.getString("created_at"));
        booking.setServicePrice(rs.getDouble("total_price"));
        booking.setCustomerName(rs.getString("customer_name"));
        booking.setVendorName(rs.getString("vendor_name"));
        booking.setServiceName(rs.getString("service_name"));
        booking.setSlotDate(rs.getString("slot_date"));
        booking.setSlotTime(rs.getString("slot_time"));
        return booking;
    }
}
