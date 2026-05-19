package dao;

import model.ContactMessage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ContactDAO {

    public boolean saveMessage(ContactMessage contactMessage) {
        String sql = "INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, contactMessage.getName());
            ps.setString(2, contactMessage.getEmail());
            ps.setString(3, contactMessage.getSubject());
            ps.setString(4, contactMessage.getMessage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
