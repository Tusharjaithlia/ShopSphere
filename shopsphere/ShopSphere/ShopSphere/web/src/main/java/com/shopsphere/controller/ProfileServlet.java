package com.shopsphere.controller;

import com.shopsphere.dao.AddressDAO;
import com.shopsphere.model.Address;
import com.shopsphere.model.User;
import com.shopsphere.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        try {
            // Refresh user data from database
            User refreshed = userService.getUserById(user.getUserId());
            if (refreshed != null) {
                session.setAttribute("user", refreshed);
            }
            List<Address> addresses = addressDAO.getAddressesByUserId(user.getUserId());
            request.setAttribute("addresses", addresses);

        } catch (SQLException ignored) {
        }

        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("updateProfile".equalsIgnoreCase(action)) {
                String name = request.getParameter("name");
                String phone = request.getParameter("phone");

                if (name != null && !name.trim().isEmpty()) {
                    user.setName(name.trim());
                    user.setPhone(phone != null ? phone.trim() : "");
                    userService.updateProfile(user);
                    session.setAttribute("user", user);
                    request.setAttribute("successMessage", "Profile updated successfully!");
                }
            } else if ("changePassword".equalsIgnoreCase(action)) {
                String oldPass = request.getParameter("oldPassword");
                String newPass = request.getParameter("newPassword");
                String confirmPass = request.getParameter("confirmPassword");

                if (newPass == null || newPass.trim().length() < 6) {
                    request.setAttribute("error", "New password must be at least 6 characters.");
                } else if (!newPass.equals(confirmPass)) {
                    request.setAttribute("error", "New password and confirmation do not match.");
                } else {
                    boolean changed = userService.changePassword(user.getUserId(), oldPass, newPass);
                    if (changed) {
                        request.setAttribute("successMessage", "Password changed successfully!");
                    } else {
                        request.setAttribute("error", "Current password does not match.");
                    }
                }
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Unable to update profile: " + e.getMessage());
        }

        doGet(request, response);
    }
}
