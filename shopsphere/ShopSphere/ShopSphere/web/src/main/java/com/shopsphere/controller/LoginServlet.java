package com.shopsphere.controller;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.model.CartItem;
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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/products");
            }
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please provide both email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userService.loginUser(email.trim(), password.trim());

            if (user != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);

                // Sync persistent cart into session
                try {
                    List<CartItem> dbCart = cartDAO.getCartByUserId(user.getUserId());
                    if (dbCart != null && !dbCart.isEmpty()) {
                        session.setAttribute("cartItems", dbCart);
                    }
                } catch (Exception ignored) {
                }

                // Check for redirect URL
                String redirect = (String) session.getAttribute("redirectAfterLogin");
                session.removeAttribute("redirectAfterLogin");
                session.removeAttribute("authMessage");

                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else if (redirect != null && !redirect.isBlank() && !redirect.contains("/login")) {
                    response.sendRedirect(redirect);
                } else {
                    response.sendRedirect(request.getContextPath() + "/products");
                }
            } else {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            throw new ServletException("Unable to process login.", e);
        }
    }
}