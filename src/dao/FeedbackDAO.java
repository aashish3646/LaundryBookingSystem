package dao;

import model.Feedback;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean submitFeedback(int userId, int bookingId, int rating, String comment) {
        String sql = "INSERT INTO feedback (user_id, booking_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookingId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Feedback> getFeedbackByVendor(int vendorId) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, u.name as user_name FROM feedback f " +
                     "JOIN bookings b ON f.booking_id = b.booking_id " +
                     "JOIN users u ON f.user_id = u.user_id " +
                     "WHERE b.vendor_id = ? ORDER BY f.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setFeedbackId(rs.getInt("feedback_id"));
                    fb.setRating(rs.getInt("rating"));
                    fb.setComment(rs.getString("comment"));
                    fb.setCreatedAt(rs.getString("created_at"));
                    fb.setUserName(rs.getString("user_name"));
                    feedbacks.add(fb);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
}
