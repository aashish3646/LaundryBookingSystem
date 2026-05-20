package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import java.util.logging.Logger;
import java.util.logging.Level;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static final String URL = getEnv("DB_URL", "jdbc:mysql://localhost:3306/laundry_booking_system");
    private static final String USERNAME = getEnv("DB_USER", "root");
    private static final String PASSWORD = getEnv("DB_PASSWORD", "7041");

    private static String getEnv(String key, String localDefault) {
        String value = System.getenv(key);
        if (value != null && !value.trim().isEmpty()) {
            return value;
        }
        String env = System.getenv("APP_ENV");
        if ("production".equalsIgnoreCase(env)) {
            throw new RuntimeException("CRITICAL: Missing environment variable " + key + " in production environment.");
        }
        return localDefault;
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "Database connection failed: MySQL Connector/J driver was not found. Expected driver class: com.mysql.cj.jdbc.Driver. Add mysql-connector-j.jar to WEB-INF/lib.", e);
            throw new SQLException("MySQL JDBC Driver not found. Add mysql-connector-j.jar to WEB-INF/lib.", e);
        }

        try {
            return DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection failed for URL: " + URL + " and Username: " + USERNAME + ". Check that MySQL is running, the database exists, and the password is correct.", e);
            throw e;
        }
    }
}
