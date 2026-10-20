package com.shopsphere.model;

public class WishlistItem {
    private int wishlistId;
    private int userId;
    private int productId;
    private Product product;

    public WishlistItem() {
    }

    public WishlistItem(int wishlistId, int userId, int productId, Product product) {
        this.wishlistId = wishlistId;
        this.userId = userId;
        this.productId = productId;
        this.product = product;
    }

    public int getWishlistId() { return wishlistId; }
    public void setWishlistId(int id) { this.wishlistId = id; }

    public int getUserId() { return userId; }
    public void setUserId(int id) { this.userId = id; }

    public int getProductId() { return productId; }
    public void setProductId(int id) { this.productId = id; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    // Convenience getters for JSP Expression Language
    public String getProductName() {
        return product != null ? product.getName() : "";
    }

    public double getPrice() {
        return product != null ? product.getEffectivePrice() : 0.0;
    }

    public String getImageUrl() {
        return product != null ? product.getImageUrl() : "";
    }
}