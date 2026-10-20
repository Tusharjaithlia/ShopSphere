package com.shopsphere.model;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private int userId;
    private String userName;
    private int productId;
    private int rating;
    private String reviewText;
    private Timestamp createdAt;

    public Review() {
    }

    public Review(int reviewId, int userId, String userName, int productId, int rating, String reviewText, Timestamp createdAt) {
        this.reviewId = reviewId;
        this.userId = userId;
        this.userName = userName;
        this.productId = productId;
        this.rating = rating;
        this.reviewText = reviewText;
        this.createdAt = createdAt;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int id) { this.reviewId = id; }

    public int getUserId() { return userId; }
    public void setUserId(int id) { this.userId = id; }

    public String getUserName() { return userName; }
    public void setUserName(String name) { this.userName = name; }

    public int getProductId() { return productId; }
    public void setProductId(int id) { this.productId = id; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getReviewText() { return reviewText; }
    public void setReviewText(String text) {
        this.reviewText = text;
    }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
