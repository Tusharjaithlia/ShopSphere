package com.shopsphere.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for managing database connections.
 * Supports configurable credentials via db.properties, system properties, and environment variables.
 */
public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static String url = "jdbc:mysql://localhost:3306/shopsphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static String user = "root";
    private static String password = "root";

    static {
        // 1. Register MySQL JDBC driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            try {
                // Fallback direct instantiation in case of classloader isolation
                DriverManager.registerDriver((Driver) Class.forName("com.mysql.cj.jdbc.Driver", true,
                        DBConnection.class.getClassLoader()).getDeclaredConstructor().newInstance());
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Failed to register MySQL JDBC driver", ex);
            }
        }

        // 2. Load configurations from classpath properties if available
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                Properties props = new Properties();
                props.load(in);
                if (props.getProperty("db.url") != null) url = props.getProperty("db.url").trim();
                if (props.getProperty("db.user") != null) user = props.getProperty("db.user").trim();
                if (props.getProperty("db.password") != null) password = props.getProperty("db.password").trim();
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "db.properties not loaded, using defaults", e);
        }

        // 3. Override with System properties or Environment variables if set
        String sysUrl = System.getProperty("db.url", System.getenv("SHOPSPHERE_DB_URL"));
        String sysUser = System.getProperty("db.user", System.getenv("SHOPSPHERE_DB_USER"));
        String sysPass = System.getProperty("db.password", System.getenv("SHOPSPHERE_DB_PASSWORD"));

        if (sysUrl != null && !sysUrl.isBlank()) url = sysUrl;
        if (sysUser != null && !sysUser.isBlank()) user = sysUser;
        if (sysPass != null) password = sysPass;
    }

    public static Connection getConnection() throws SQLException {
        try {
            // Re-verify driver registration to prevent Tomcat thread-local context loss
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ignored) {
        }
        return DriverManager.getConnection(url, user, password);
    }

    public static void setCredentials(String newUrl, String newUser, String newPassword) {
        if (newUrl != null) url = newUrl;
        if (newUser != null) user = newUser;
        if (newPassword != null) password = newPassword;
    }

    public static String getUrl() {
        return url;
    }

    public static String getUser() {
        return user;
    }
}