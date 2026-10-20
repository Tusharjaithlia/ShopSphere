package com.shopsphere.model;

import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private String userName;
    private String userEmail;
    private int addressId;
    private double totalAmount;
    private double discount;
    private String paymentMethod;
    private String paymentStatus;
    private String orderStatus;
    private String shippingAddress;
    private Timestamp createdAt;

    public Order() {
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int id) { this.orderId = id; }

    public int getUserId() { return userId; }
    public void setUserId(int id) { this.userId = id; }

    public String getUserName() { return userName; }
    public void setUserName(String name) { this.userName = name; }

    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String email) { this.userEmail = email; }

    public int getAddressId() { return addressId; }
    public void setAddressId(int id) { this.addressId = id; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double amount) {
        this.totalAmount = amount;
    }

    public double getDiscount() { return discount; }
    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String method) {
        this.paymentMethod = method;
    }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String status) {
        this.paymentStatus = status;
    }

    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String status) {
        this.orderStatus = status;
    }

    // Alias for JSP EL compatibility (${order.status})
    public String getStatus() { return orderStatus; }
    public void setStatus(String status) { this.orderStatus = status; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String address) { this.shippingAddress = address; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}