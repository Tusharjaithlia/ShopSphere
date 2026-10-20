package com.shopsphere.model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int cartId;
    private int userId;
    private int productId;
    private String productName;
    private double price;
    private int quantity;
    private String imageUrl;
    private Product product;

    public CartItem() {
    }

    public CartItem(int productId, String productName, double price, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
    }

    public CartItem(int productId, String productName, double price, int quantity, String imageUrl) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.imageUrl = imageUrl;
    }

    public int getCartId() { return cartId; }
    public void setCartId(int id) { this.cartId = id; }

    public int getUserId() { return userId; }
    public void setUserId(int id) { this.userId = id; }

    public int getProductId() { return productId; }
    public void setProductId(int id) { this.productId = id; }

    public String getProductName() {
        if (productName != null) return productName;
        return product != null ? product.getName() : "";
    }
    public void setProductName(String productName) { this.productName = productName; }

    public double getPrice() {
        if (price > 0) return price;
        return product != null ? product.getEffectivePrice() : 0.0;
    }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getImageUrl() {
        if (imageUrl != null) return imageUrl;
        return product != null ? product.getImageUrl() : "";
    }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) {
        this.product = product;
        if (product != null) {
            this.productId = product.getProductId();
            this.productName = product.getName();
            this.price = product.getEffectivePrice();
            this.imageUrl = product.getImageUrl();
        }
    }

    public double getSubtotal() {
        return Math.round(getPrice() * quantity * 100.0) / 100.0;
    }
}