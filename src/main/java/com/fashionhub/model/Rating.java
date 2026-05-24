package com.fashionhub.model;

import java.sql.Timestamp;

public class Rating {
    private int id;
    private int productId;
    private int userId;
    private int stars;
    private String review;
    private String username;
    private Timestamp createdAt;

    public Rating() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getStars() { return stars; }
    public void setStars(int stars) { this.stars = stars; }
    public String getReview() { return review; }
    public void setReview(String review) { this.review = review; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
