package com.shopsphere.controller;

import com.shopsphere.model.Order;
import com.shopsphere.model.OrderItem;
import com.shopsphere.service.OrderService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        try {
            if (idParam != null && !idParam.isBlank()) {
                int orderId = Integer.parseInt(idParam.trim());
                Order order = orderService.getOrderById(orderId);
                List<OrderItem> items = orderService.getOrderItems(orderId);
                request.setAttribute("selectedOrder", order);
                request.setAttribute("orderItems", items);
            }

            List<Order> orders = orderService.getAllOrders();
            request.setAttribute("orders", orders);

            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Unable to load orders.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("orderId");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int orderId = Integer.parseInt(idParam.trim());

                if ("updateStatus".equalsIgnoreCase(action)) {
                    String status = request.getParameter("orderStatus");
                    orderService.updateOrderStatus(orderId, status);
                } else if ("updatePayment".equalsIgnoreCase(action)) {
                    String paymentStatus = request.getParameter("paymentStatus");
                    orderService.updatePaymentStatus(orderId, paymentStatus);
                }

            } catch (SQLException e) {
                throw new ServletException("Unable to update order.", e);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
