package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/laundry_booking_system";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "7041";

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Database connection failed: MySQL Connector/J driver was not found.");
            System.err.println("Expected driver class: com.mysql.cj.jdbc.Driver");
            System.err.println("Add mysql-connector-j.jar to WEB-INF/lib or Tomcat's lib directory.");
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found. Add mysql-connector-j.jar to WEB-INF/lib.", e);
        }

        try {
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (SQLException e) {
            System.err.println("Database connection failed.");
            System.err.println("URL: " + URL);
            System.err.println("Username: " + USERNAME);
            System.err.println("Check that MySQL is running, the database exists, and the password is correct.");
            e.printStackTrace();
            throw e;
        }
    }
}
