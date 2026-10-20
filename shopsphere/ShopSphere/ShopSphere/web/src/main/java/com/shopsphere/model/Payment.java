package com.shopsphere.model;

import java.sql.Timestamp;

public class Payment {
    private int paymentId;
    private int orderId;
    private String paymentMethod;
    private String transactionReference;
    private double amount;
    private String paymentStatus;
    private Timestamp createdAt;

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int id) { this.paymentId = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int id) { this.orderId = id; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String method) {
        this.paymentMethod = method;
    }

    public String getTransactionReference() {
        return transactionReference;
    }
    public void setTransactionReference(String reference) {
        this.transactionReference = reference;
    }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String status) {
        this.paymentStatus = status;
    }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
