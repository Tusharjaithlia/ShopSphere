package com.shopsphere.controller;

import com.shopsphere.model.Order;
import com.shopsphere.model.OrderItem;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/orders", "/order-details", "/order-success"})
public class OrderServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();

        try {
            if ("/order-success".equals(path)) {
                String idParam = request.getParameter("orderId");
                Order order = null;
                if (idParam != null && !idParam.isBlank()) {
                    try {
                        int orderId = Integer.parseInt(idParam.trim());
                        order = orderService.getOrderById(orderId);
                    } catch (NumberFormatException ignored) {
                    }
                }
                if (order == null) {
                    order = (Order) session.getAttribute("lastPlacedOrder");
                }
                request.setAttribute("order", order);
                request.getRequestDispatcher("/order-success.jsp").forward(request, response);

            } else if ("/order-details".equals(path)) {
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/orders");
                    return;
                }

                int orderId = Integer.parseInt(idParam.trim());
                Order order = orderService.getOrderById(orderId);

                if (order == null || (order.getUserId() != user.getUserId() && !user.isAdmin())) {
                    request.setAttribute("error", "Order not found or access denied.");
                    response.sendRedirect(request.getContextPath() + "/orders");
                    return;
                }

                List<OrderItem> items = orderService.getOrderItems(orderId);
                request.setAttribute("order", order);
                request.setAttribute("orderItems", items);
                request.getRequestDispatcher("/order-details.jsp").forward(request, response);

            } else {
                // Customer order history
                List<Order> orders = orderService.getOrdersByUserId(user.getUserId());
                request.setAttribute("orders", orders);
                request.getRequestDispatcher("/orders.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            throw new ServletException("Unable to retrieve order details.", e);
        }
    }
}
