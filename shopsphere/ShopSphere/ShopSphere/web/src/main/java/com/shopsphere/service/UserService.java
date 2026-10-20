package com.shopsphere.service;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;
import com.shopsphere.util.PasswordUtil;

import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserService {

    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());
    private final UserDAO userDAO = new UserDAO();

    public User getUserByEmail(String email) throws SQLException {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        return userDAO.getUserByEmail(email.trim());
    }

    public User getUserById(int userId) throws SQLException {
        if (userId <= 0) return null;
        return userDAO.getUserById(userId);
    }

    public User loginUser(String email, String password) throws SQLException {
        if (email == null || password == null) return null;

        User user = getUserByEmail(email);
        if (user == null || !user.isStatus()) {
            return null;
        }

        String storedHash = user.getPassword();
        boolean verified = false;

        if (storedHash != null && storedHash.contains(":")) {
            try {
                verified = PasswordUtil.verifyPassword(password, storedHash);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Failed to verify PBKDF2 password hash", e);
            }
        } else if (storedHash != null) {
            // Plaintext fallback for initial seed data
            verified = storedHash.equals(password);
            if (verified) {
                // Automatically upgrade to PBKDF2 hash!
                try {
                    String newHash = PasswordUtil.hashPassword(password);
                    userDAO.updatePassword(user.getUserId(), newHash);
                    user.setPassword(newHash);
                } catch (Exception ignored) {
                }
            }
        }

        return verified ? user : null;
    }

    public boolean registerUser(User user) throws SQLException {
        if (user == null
                || user.getName() == null || user.getName().trim().isEmpty()
                || user.getEmail() == null || user.getEmail().trim().isEmpty()
                || user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            return false;
        }

        // Check if email already registered
        User existing = getUserByEmail(user.getEmail());
        if (existing != null) {
            return false;
        }

        try {
            String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
            user.setPassword(hashedPassword);
        } catch (Exception e) {
            throw new SQLException("Unable to hash password securely.", e);
        }

        return userDAO.registerUser(user);
    }

    public boolean updateProfile(User user) throws SQLException {
        if (user == null || user.getUserId() <= 0) return false;
        return userDAO.updateUser(user);
    }

    public boolean changePassword(int userId, String oldPassword, String newPassword) throws SQLException {
        User user = userDAO.getUserById(userId);
        if (user == null) return false;

        boolean verified = false;
        String storedHash = user.getPassword();
        if (storedHash != null && storedHash.contains(":")) {
            try {
                verified = PasswordUtil.verifyPassword(oldPassword, storedHash);
            } catch (Exception ignored) {
            }
        } else if (storedHash != null) {
            verified = storedHash.equals(oldPassword);
        }

        if (!verified) return false;

        try {
            String newHashed = PasswordUtil.hashPassword(newPassword);
            return userDAO.updatePassword(userId, newHashed);
        } catch (Exception e) {
            throw new SQLException("Error hashing new password", e);
        }
    }

    public List<User> getAllUsers() throws SQLException {
        return userDAO.getAllUsers();
    }

    public boolean toggleUserStatus(int userId, boolean status) throws SQLException {
        return userDAO.updateUserStatus(userId, status);
    }

    public int getUserCount() throws SQLException {
        return userDAO.getUserCount();
    }
}