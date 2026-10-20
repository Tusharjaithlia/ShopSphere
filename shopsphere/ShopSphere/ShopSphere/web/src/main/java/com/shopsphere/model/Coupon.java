package com.shopsphere.model;

import java.io.Serializable;
import java.sql.Date;

public class Coupon implements Serializable {
    private static final long serialVersionUID = 1L;

    private int couponId;
    private String code;
    private String discountType = "PERCENTAGE"; // PERCENTAGE or FIXED
    private double discountValue;
    private double minimumOrder;
    private double maximumDiscount;
    private Date expiryDate;
    private boolean status = true;

    public Coupon() {
    }

    public int getCouponId() { return couponId; }
    public void setCouponId(int id) { this.couponId = id; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String type) {
        this.discountType = type;
    }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double value) {
        this.discountValue = value;
    }

    public double getMinimumOrder() { return minimumOrder; }
    public void setMinimumOrder(double amount) {
        this.minimumOrder = amount;
    }

    public double getMaximumDiscount() { return maximumDiscount; }
    public void setMaximumDiscount(double amount) {
        this.maximumDiscount = amount;
    }

    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date date) {
        this.expiryDate = date;
    }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }

    public double calculateDiscount(double orderTotal) {
        if (!status) return 0.0;
        if (expiryDate != null && expiryDate.before(new java.util.Date(System.currentTimeMillis() - 86400000L))) {
            return 0.0;
        }
        if (orderTotal < minimumOrder) {
            return 0.0;
        }
        double discount = 0.0;
        if ("FIXED".equalsIgnoreCase(discountType)) {
            discount = discountValue;
        } else {
            discount = (orderTotal * discountValue) / 100.0;
        }
        if (maximumDiscount > 0 && discount > maximumDiscount) {
            discount = maximumDiscount;
        }
        if (discount > orderTotal) {
            discount = orderTotal;
        }
        return Math.round(discount * 100.0) / 100.0;
    }
}
