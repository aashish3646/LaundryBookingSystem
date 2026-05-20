import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBTest {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/laundry_booking_system";
        String user = "root";
        String password = "7041";

        System.out.println("Testing connection to: " + url);
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                System.out.println("SUCCESS: Connected to the database!");
                
                String query = "SELECT email, password, role, approval_status FROM users";
                try (java.sql.PreparedStatement ps = conn.prepareStatement(query);
                     java.sql.ResultSet rs = ps.executeQuery()) {
                     while (rs.next()) {
                          String email = rs.getString("email");
                          String dbHash = rs.getString("password");
                          String role = rs.getString("role");
                          String appStatus = rs.getString("approval_status");
                          String testPass = "admin123";
                          if ("user".equals(role)) testPass = "user123";
                          if ("vendor".equals(role)) testPass = "vendor123";
                          boolean matches = util.PasswordUtil.verifyPassword(testPass, dbHash);
                          System.out.println("User: " + email + " | Role: " + role + " | Approval: " + appStatus + " | Password Matches (" + testPass + ")? " + matches);
                     }
                }
            }
        } catch (ClassNotFoundException e) {
            System.out.println(" ERROR: MySQL Driver not found.");
        } catch (SQLException e) {
            System.out.println(" ERROR: Database connection failed!");
            System.out.println("Message: " + e.getMessage());
        }
    }
}
