package com.shopsphere.controller;

import com.shopsphere.model.User;
import com.shopsphere.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<User> users = userService.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load users.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("userId");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int userId = Integer.parseInt(idParam.trim());

                if ("toggleStatus".equalsIgnoreCase(action)) {
                    boolean status = Boolean.parseBoolean(request.getParameter("status"));
                    userService.toggleUserStatus(userId, status);
                }

            } catch (SQLException e) {
                throw new ServletException("Unable to update user status.", e);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
