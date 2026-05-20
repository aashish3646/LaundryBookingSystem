import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.nio.file.Files;
import java.nio.file.Paths;

public class DBInit {
    public static void main(String[] args) {
        // Need allowMultiQueries=true to run the whole script if we pass it as one string
        String url = "jdbc:mysql://localhost:3306/?allowMultiQueries=true";
        String user = "root";
        String password = "7041";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, user, password);
                 Statement stmt = conn.createStatement()) {
                
                System.out.println("Connected to MySQL server.");
                
                String sql = new String(Files.readAllBytes(Paths.get("database/schema.sql")));
                
                System.out.println("Executing schema.sql...");
                stmt.execute(sql);
                
                System.out.println("SUCCESS: Database schema has been updated successfully!");
                
            }
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
