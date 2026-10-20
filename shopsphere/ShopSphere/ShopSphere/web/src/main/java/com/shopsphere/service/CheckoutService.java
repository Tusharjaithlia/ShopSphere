package com.shopsphere.service;

import com.shopsphere.dao.CouponDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.Order;
import com.shopsphere.model.OrderItem;
import com.shopsphere.model.Payment;
import com.shopsphere.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CheckoutService {

    private static final Logger LOGGER = Logger.getLogger(CheckoutService.class.getName());
    private final CouponDAO couponDAO = new CouponDAO();

    public Order processCheckout(int userId, String shippingAddress, String paymentMethod, String couponCode, List<CartItem> cartItems)
            throws SQLException, IllegalArgumentException {

        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalArgumentException("Your shopping cart is empty.");
        }
        if (shippingAddress == null || shippingAddress.trim().isEmpty()) {
            throw new IllegalArgumentException("Please provide a valid delivery address.");
        }
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Begin Transaction

            double subtotal = 0.0;
            List<OrderItem> orderItemsToSave = new ArrayList<>();

            // 1. Verify stock and calculate subtotal with row locks (FOR UPDATE)
            String checkProductSql = "SELECT product_id, name, price, discount, stock, status FROM products WHERE product_id = ? FOR UPDATE";
            String deductStockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";

            for (CartItem item : cartItems) {
                int pid = item.getProductId();
                int requestedQty = item.getQuantity();

                try (PreparedStatement checkPs = con.prepareStatement(checkProductSql)) {
                    checkPs.setInt(1, pid);
                    try (ResultSet rs = checkPs.executeQuery()) {
                        if (!rs.next() || !rs.getBoolean("status")) {
                            throw new IllegalArgumentException("Product is no longer available: " + item.getProductName());
                        }

                        int currentStock = rs.getInt("stock");
                        if (currentStock < requestedQty) {
                            throw new IllegalArgumentException("Insufficient stock for '" + rs.getString("name") + "'. Available: " + currentStock);
                        }

                        double unitPrice = rs.getDouble("price");
                        double discount = rs.getDouble("discount");
                        if (discount > 0 && discount < 100) {
                            unitPrice = Math.round((unitPrice - (unitPrice * discount / 100.0)) * 100.0) / 100.0;
                        }

                        subtotal += unitPrice * requestedQty;

                        OrderItem oi = new OrderItem();
                        oi.setProductId(pid);
                        oi.setProductName(rs.getString("name"));
                        oi.setPrice(unitPrice);
                        oi.setQuantity(requestedQty);
                        orderItemsToSave.add(oi);
                    }
                }

                // Deduct stock safely
                try (PreparedStatement deductPs = con.prepareStatement(deductStockSql)) {
                    deductPs.setInt(1, requestedQty);
                    deductPs.setInt(2, pid);
                    deductPs.setInt(3, requestedQty);
                    int updated = deductPs.executeUpdate();
                    if (updated == 0) {
                        throw new IllegalArgumentException("Could not reserve stock for item: " + item.getProductName());
                    }
                }
            }

            // 2. Validate coupon if applied
            double discountAmount = 0.0;
            if (couponCode != null && !couponCode.trim().isEmpty()) {
                Coupon coupon = couponDAO.getCouponByCode(couponCode.trim());
                if (coupon != null) {
                    discountAmount = coupon.calculateDiscount(subtotal);
                }
            }

            double finalTotal = Math.max(0.0, Math.round((subtotal - discountAmount) * 100.0) / 100.0);

            // 3. Payment Status Setup
            String paymentStatus;
            String orderStatus;
            String txnRef = null;

            if ("COD".equalsIgnoreCase(paymentMethod)) {
                paymentStatus = "PENDING";
                orderStatus = "PLACED";
            } else {
                // Demo Payment verification flow
                paymentStatus = "COMPLETED";
                orderStatus = "PROCESSING";
                txnRef = "DEMO-TXN-" + System.currentTimeMillis();
            }

            // 4. Insert into orders table
            String insertOrderSql = "INSERT INTO orders (user_id, total_amount, discount, payment_method, payment_status, order_status, shipping_address) " +
                                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            int orderId = -1;
            try (PreparedStatement orderPs = con.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                orderPs.setInt(1, userId);
                orderPs.setDouble(2, finalTotal);
                orderPs.setDouble(3, discountAmount);
                orderPs.setString(4, paymentMethod.toUpperCase());
                orderPs.setString(5, paymentStatus);
                orderPs.setString(6, orderStatus);
                orderPs.setString(7, shippingAddress);

                orderPs.executeUpdate();
                try (ResultSet keys = orderPs.getGeneratedKeys()) {
                    if (keys.next()) {
                        orderId = keys.getInt(1);
                    }
                }
            }

            if (orderId <= 0) {
                throw new SQLException("Failed to generate order record.");
            }

            // 5. Insert order items
            String insertItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price, product_name) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement itemPs = con.prepareStatement(insertItemSql)) {
                for (OrderItem oi : orderItemsToSave) {
                    itemPs.setInt(1, orderId);
                    itemPs.setInt(2, oi.getProductId());
                    itemPs.setInt(3, oi.getQuantity());
                    itemPs.setDouble(4, oi.getPrice());
                    itemPs.setString(5, oi.getProductName());
                    itemPs.addBatch();
                }
                itemPs.executeBatch();
            }

            // 6. Record payment record
            String insertPaymentSql = "INSERT INTO payments (order_id, payment_method, transaction_reference, amount, payment_status) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement payPs = con.prepareStatement(insertPaymentSql)) {
                payPs.setInt(1, orderId);
                payPs.setString(2, paymentMethod.toUpperCase());
                payPs.setString(3, txnRef != null ? txnRef : "COD-PENDING");
                payPs.setDouble(4, finalTotal);
                payPs.setString(5, paymentStatus);
                payPs.executeUpdate();
            }

            // 7. Clear persistent cart for this user
            if (userId > 0) {
                String clearCartSql = "DELETE FROM cart_items WHERE user_id = ?";
                try (PreparedStatement clearPs = con.prepareStatement(clearCartSql)) {
                    clearPs.setInt(1, userId);
                    clearPs.executeUpdate();
                }
            }

            // 8. Commit Transaction
            con.commit();

            Order completedOrder = new Order();
            completedOrder.setOrderId(orderId);
            completedOrder.setUserId(userId);
            completedOrder.setTotalAmount(finalTotal);
            completedOrder.setDiscount(discountAmount);
            completedOrder.setPaymentMethod(paymentMethod.toUpperCase());
            completedOrder.setPaymentStatus(paymentStatus);
            completedOrder.setOrderStatus(orderStatus);
            completedOrder.setShippingAddress(shippingAddress);

            return completedOrder;

        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackEx) {
                    LOGGER.log(Level.SEVERE, "Rollback failed", rollbackEx);
                }
            }
            if (e instanceof IllegalArgumentException) {
                throw (IllegalArgumentException) e;
            }
            throw new SQLException("Checkout failed: " + e.getMessage(), e);
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException ignored) {
                }
            }
        }
    }
}
