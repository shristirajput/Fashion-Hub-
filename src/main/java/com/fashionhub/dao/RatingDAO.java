package com.fashionhub.dao;

import com.fashionhub.model.Rating;
import com.fashionhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RatingDAO {

    public boolean addOrUpdateRating(Rating rating) {
        String sql = "INSERT INTO ratings (product_id, user_id, stars, review) VALUES (?, ?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE stars = VALUES(stars), review = VALUES(review)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, rating.getProductId());
            stmt.setInt(2, rating.getUserId());
            stmt.setInt(3, rating.getStars());
            stmt.setString(4, rating.getReview());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Rating> getRatingsByProduct(int productId) {
        List<Rating> list = new ArrayList<>();
        String sql = "SELECT r.*, u.username FROM ratings r JOIN users u ON r.user_id = u.id " +
                     "WHERE r.product_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Rating r = new Rating();
                r.setId(rs.getInt("id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setStars(rs.getInt("stars"));
                r.setReview(rs.getString("review"));
                r.setUsername(rs.getString("username"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(stars) as avg_stars FROM ratings WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getDouble("avg_stars");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getRatingCount(int productId) {
        String sql = "SELECT COUNT(*) FROM ratings WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Rating getUserRatingForProduct(int userId, int productId) {
        String sql = "SELECT r.*, u.username FROM ratings r JOIN users u ON r.user_id = u.id " +
                     "WHERE r.product_id = ? AND r.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Rating r = new Rating();
                r.setId(rs.getInt("id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setStars(rs.getInt("stars"));
                r.setReview(rs.getString("review"));
                r.setUsername(rs.getString("username"));
                return r;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
