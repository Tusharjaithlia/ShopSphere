package com.shopsphere.controller;

import com.shopsphere.dao.WishlistDAO;
import com.shopsphere.model.User;
import com.shopsphere.model.WishlistItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();

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
            List<WishlistItem> items = wishlistDAO.getWishlistByUserId(user.getUserId());
            request.setAttribute("wishlistItems", items);
            request.getRequestDispatcher("/wishlist.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load wishlist.", e);
        }
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
        String pIdParam = request.getParameter("productId");

        if (pIdParam != null && !pIdParam.isBlank()) {
            try {
                int productId = Integer.parseInt(pIdParam.trim());
                if ("remove".equalsIgnoreCase(action)) {
                    wishlistDAO.removeFromWishlist(user.getUserId(), productId);
                } else {
                    // Default action: add to wishlist
                    wishlistDAO.addToWishlist(user.getUserId(), productId);
                }
            } catch (SQLException ignored) {
            } catch (NumberFormatException ignored) {
            }
        }

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isBlank() && !referer.contains("/wishlist") && "add".equalsIgnoreCase(action)) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }
}
