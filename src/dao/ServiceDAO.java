package dao;

import model.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, price, status FROM services ORDER BY service_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                services.add(mapService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return services;
    }

    public Service getServiceById(int serviceId) {
        String sql = "SELECT service_id, service_name, description, price, status FROM services WHERE service_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapService(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<Service> getActiveServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, service_name, description, price, status FROM services WHERE status = 'active' ORDER BY service_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                services.add(mapService(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return services;
    }

    public boolean saveService(Service service) {
        if (service.getServiceId() > 0) {
            return updateService(service);
        }
        return addService(service);
    }

    public boolean addService(Service service) {
        String sql = "INSERT INTO services (service_name, price, description, status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setDouble(2, service.getPrice());
            ps.setString(3, service.getDescription());
            ps.setString(4, service.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateService(Service service) {
        String sql = "UPDATE services SET service_name = ?, price = ?, description = ?, status = ? WHERE service_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setDouble(2, service.getPrice());
            ps.setString(3, service.getDescription());
            ps.setString(4, service.getStatus());
            ps.setInt(5, service.getServiceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteService(int serviceId) {
        String sql = "DELETE FROM services WHERE service_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, serviceId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int countServices() {
        String sql = "SELECT COUNT(*) FROM services";

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

    private Service mapService(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setServiceId(rs.getInt("service_id"));
        service.setServiceName(rs.getString("service_name"));
        service.setDescription(rs.getString("description"));
        service.setPrice(rs.getDouble("price"));
        service.setStatus(rs.getString("status"));
        return service;
    }
}
