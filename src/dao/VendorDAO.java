package dao;

import model.Vendor;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class VendorDAO {

    public List<Vendor> getAllVendors() {
        List<Vendor> vendors = new ArrayList<>();
        String sql = "SELECT * FROM vendors ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                vendors.add(mapVendor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vendors;
    }

    public List<Vendor> searchVendors(String query) {
        List<Vendor> vendors = new ArrayList<>();
        String sql = "SELECT v.*, " +
                     "(SELECT AVG(f.rating) FROM feedback f JOIN bookings b ON f.booking_id = b.booking_id WHERE b.vendor_id = v.vendor_id) as avg_rating, " +
                     "(SELECT COUNT(f.feedback_id) FROM feedback f JOIN bookings b ON f.booking_id = b.booking_id WHERE b.vendor_id = v.vendor_id) as review_count " +
                     "FROM vendors v " +
                     "WHERE (v.vendor_name LIKE ? OR v.area LIKE ? OR v.service_type LIKE ?) " +
                     "AND v.status = 'active' AND v.approval_status = 'approved'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchPattern = "%" + query + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Vendor vendor = mapVendor(rs);
                    vendor.setAverageRating(rs.getDouble("avg_rating"));
                    vendor.setReviewCount(rs.getInt("review_count"));
                    vendors.add(vendor);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vendors;
    }

    public Vendor getVendorById(int vendorId) {
        String sql = "SELECT * FROM vendors WHERE vendor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVendor(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public Vendor getVendorByUserId(int userId) {
        String sql = "SELECT * FROM vendors WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVendor(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Vendor> getActiveVendors() {
        List<Vendor> vendors = new ArrayList<>();
        String sql = "SELECT * FROM vendors WHERE status = 'active' AND approval_status = 'approved' ORDER BY vendor_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                vendors.add(mapVendor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vendors;
    }

    public boolean saveVendor(Vendor vendor) {
        if (vendor.getVendorId() > 0) {
            return updateVendor(vendor);
        }
        return addVendor(vendor);
    }

    public boolean addVendor(Vendor vendor) {
        String sql = "INSERT INTO vendors (user_id, vendor_name, owner_name, area, contact, service_type, price_range, document_type, document_path, approval_status, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (vendor.getUserId() != null) ps.setInt(1, vendor.getUserId()); else ps.setNull(1, java.sql.Types.INTEGER);
            ps.setString(2, vendor.getVendorName());
            ps.setString(3, vendor.getOwnerName());
            ps.setString(4, vendor.getArea());
            ps.setString(5, vendor.getContact());
            ps.setString(6, vendor.getServiceType());
            ps.setString(7, vendor.getPriceRange());
            ps.setString(8, vendor.getDocumentType());
            ps.setString(9, vendor.getDocumentPath());
            ps.setString(10, vendor.getApprovalStatus() == null ? "pending" : vendor.getApprovalStatus());
            ps.setString(11, vendor.getStatus() == null ? "active" : vendor.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVendor(Vendor vendor) {
        String sql = "UPDATE vendors SET vendor_name = ?, owner_name = ?, area = ?, contact = ?, service_type = ?, price_range = ?, "
                + "document_type = ?, document_path = ?, approval_status = ?, admin_remarks = ?, status = ? WHERE vendor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, vendor.getVendorName());
            ps.setString(2, vendor.getOwnerName());
            ps.setString(3, vendor.getArea());
            ps.setString(4, vendor.getContact());
            ps.setString(5, vendor.getServiceType());
            ps.setString(6, vendor.getPriceRange());
            ps.setString(7, vendor.getDocumentType());
            ps.setString(8, vendor.getDocumentPath());
            ps.setString(9, vendor.getApprovalStatus());
            ps.setString(10, vendor.getAdminRemarks());
            ps.setString(11, vendor.getStatus());
            ps.setInt(12, vendor.getVendorId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateApprovalStatus(int vendorId, String status, String remarks) {
        String sql = "UPDATE vendors SET approval_status = ?, admin_remarks = ? WHERE vendor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setInt(3, vendorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteVendor(int vendorId) {
        String sql = "DELETE FROM vendors WHERE vendor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, vendorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateDocumentPath(int vendorId, String documentPath) {
        String sql = "UPDATE vendors SET document_path = ? WHERE vendor_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, documentPath);
            ps.setInt(2, vendorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countVendors() {
        String sql = "SELECT COUNT(*) FROM vendors";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    private Vendor mapVendor(ResultSet rs) throws SQLException {
        Vendor vendor = new Vendor();
        vendor.setVendorId(rs.getInt("vendor_id"));
        int userId = rs.getInt("user_id");
        vendor.setUserId(rs.wasNull() ? null : userId);
        vendor.setVendorName(rs.getString("vendor_name"));
        vendor.setOwnerName(rs.getString("owner_name"));
        vendor.setArea(rs.getString("area"));
        vendor.setContact(rs.getString("contact"));
        vendor.setServiceType(rs.getString("service_type"));
        vendor.setPriceRange(rs.getString("price_range"));
        vendor.setDocumentType(rs.getString("document_type"));
        vendor.setDocumentPath(rs.getString("document_path"));
        vendor.setApprovalStatus(rs.getString("approval_status"));
        vendor.setAdminRemarks(rs.getString("admin_remarks"));
        vendor.setStatus(rs.getString("status"));
        vendor.setCreatedAt(rs.getString("created_at"));
        return vendor;
    }

    private String buildVendorEmail(Vendor vendor) {
        String base = valueOrDefault(vendor.getVendorName(), "vendor").toLowerCase().replaceAll("[^a-z0-9]+", ".");
        base = base.replaceAll("^\\.+|\\.+$", "");
        if (base.isEmpty()) {
            base = "vendor";
        }
        return base + "." + System.currentTimeMillis() + "@quickwash.local";
    }

    private String valueOrDefault(String value, String defaultValue) {
        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
    }
}
