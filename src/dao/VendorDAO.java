package dao;

import model.Vendor;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VendorDAO {

    public List<Vendor> getAllVendors() {
        List<Vendor> vendors = new ArrayList<>();
        String sql = "SELECT * FROM vendors";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                vendors.add(mapResultSetToVendor(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vendors;
    }

    public Vendor getVendorById(int id) {
        String sql = "SELECT * FROM vendors WHERE vendor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToVendor(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addVendor(Vendor vendor) {
        String sql = "INSERT INTO vendors (vendor_name, area, contact, service_type, price_range) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, vendor.getVendorName());
            stmt.setString(2, vendor.getArea());
            stmt.setString(3, vendor.getContact());
            stmt.setString(4, vendor.getServiceType());
            stmt.setString(5, vendor.getPriceRange());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateVendor(Vendor vendor) {
        String sql = "UPDATE vendors SET vendor_name=?, area=?, contact=?, service_type=?, price_range=? WHERE vendor_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, vendor.getVendorName());
            stmt.setString(2, vendor.getArea());
            stmt.setString(3, vendor.getContact());
            stmt.setString(4, vendor.getServiceType());
            stmt.setString(5, vendor.getPriceRange());
            stmt.setInt(6, vendor.getVendorId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteVendor(int id) {
        String sql = "DELETE FROM vendors WHERE vendor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Vendor mapResultSetToVendor(ResultSet rs) throws SQLException {
        Vendor vendor = new Vendor();
        vendor.setVendorId(rs.getInt("vendor_id"));
        vendor.setVendorName(rs.getString("vendor_name"));
        vendor.setArea(rs.getString("area"));
        vendor.setContact(rs.getString("contact"));
        vendor.setServiceType(rs.getString("service_type"));
        vendor.setPriceRange(rs.getString("price_range"));
        return vendor;
    }
}
