import dao.DBConnection;
import java.sql.Connection;

    public class Main {
        public static void main(String[] args) {
            Connection conn = DBConnection.getConnection();

            if (conn != null) {
                System.out.println("Connection test successful.");
            } else {
                System.out.println("Connection test failed.");
            }
        }
    }