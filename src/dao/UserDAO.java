package dao;

import model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public boolean registerUser(User user) {
        String checkSql = "SELECT * FROM users WHERE email = ?";
        String insertSql = "INSERT INTO users (name, email, phone, password, role) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setString(1, user.getEmail());
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                return false;
            }

            PreparedStatement insertStmt = conn.prepareStatement(insertSql);
            insertStmt.setString(1, user.getName());
            insertStmt.setString(2, user.getEmail());
            insertStmt.setString(3, user.getPhone());
            insertStmt.setString(4, user.getPassword());
            insertStmt.setString(5, user.getRole());

            int rows = insertStmt.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}