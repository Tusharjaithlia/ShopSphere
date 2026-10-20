package com.shopsphere.service;

import com.shopsphere.dao.OrderDAO;
import com.shopsphere.model.Order;
import com.shopsphere.model.OrderItem;

import java.sql.SQLException;
import java.util.List;

public class OrderService {

    private final OrderDAO orderDAO = new OrderDAO();

    public Order getOrderById(int orderId) throws SQLException {
        if (orderId <= 0) return null;
        return orderDAO.getOrderById(orderId);
    }

    public List<OrderItem> getOrderItems(int orderId) throws SQLException {
        if (orderId <= 0) return List.of();
        return orderDAO.getOrderItems(orderId);
    }

    public List<Order> getOrdersByUserId(int userId) throws SQLException {
        if (userId <= 0) return List.of();
        return orderDAO.getOrdersByUserId(userId);
    }

    public List<Order> getAllOrders() throws SQLException {
        return orderDAO.getAllOrders();
    }

    public boolean updateOrderStatus(int orderId, String newStatus) throws SQLException {
        if (orderId <= 0 || newStatus == null || newStatus.isBlank()) return false;
        return orderDAO.updateOrderStatus(orderId, newStatus.trim().toUpperCase());
    }

    public boolean updatePaymentStatus(int orderId, String paymentStatus) throws SQLException {
        if (orderId <= 0 || paymentStatus == null || paymentStatus.isBlank()) return false;
        return orderDAO.updatePaymentStatus(orderId, paymentStatus.trim().toUpperCase());
    }

    public int getOrderCount() throws SQLException {
        return orderDAO.getOrderCount();
    }

    public double getTotalRevenue() throws SQLException {
        return orderDAO.getTotalRevenue();
    }
}
