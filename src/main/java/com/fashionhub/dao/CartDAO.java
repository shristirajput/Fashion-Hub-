package com.fashionhub.dao;

import com.fashionhub.model.Cart;
import com.fashionhub.model.Product;
import com.fashionhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public boolean addToCart(Cart cart) {
        // Check if product already in cart
        String checkSql = "SELECT * FROM cart WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            
            checkStmt.setInt(1, cart.getUserId());
            checkStmt.setInt(2, cart.getProductId());
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next()) {
                // Update quantity
                int currentInCart = rs.getInt("quantity");
                int newQuantity = currentInCart + cart.getQuantity();
                
                // Stock Check
                String stockSql = "SELECT stock FROM products WHERE id = ?";
                try (PreparedStatement stockStmt = conn.prepareStatement(stockSql)) {
                    stockStmt.setInt(1, cart.getProductId());
                    ResultSet rsStock = stockStmt.executeQuery();
                    if (rsStock.next()) {
                        int stock = rsStock.getInt("stock");
                        if (newQuantity > stock) {
                            newQuantity = stock; // Cap at stock limit
                        }
                    }
                }
                
                return updateQuantity(rs.getInt("id"), newQuantity);
            } else {
                // Stock Check for new item
                String stockSql = "SELECT stock FROM products WHERE id = ?";
                try (PreparedStatement stockStmt = conn.prepareStatement(stockSql)) {
                    stockStmt.setInt(1, cart.getProductId());
                    ResultSet rsStock = stockStmt.executeQuery();
                    if (rsStock.next()) {
                        int stock = rsStock.getInt("stock");
                        if (cart.getQuantity() > stock) {
                            cart.setQuantity(stock);
                        }
                    }
                }

                // Insert new
                String sql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, cart.getUserId());
                    stmt.setInt(2, cart.getProductId());
                    stmt.setInt(3, cart.getQuantity());
                    return stmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Cart> getCartByUserId(int userId) {
        List<Cart> cartList = new ArrayList<>();
        String sql = "SELECT c.*, p.name as p_name, p.price as p_price, p.image_url as p_image FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Cart cart = new Cart();
                cart.setId(rs.getInt("id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setProductId(rs.getInt("product_id"));
                cart.setQuantity(rs.getInt("quantity"));
                
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("p_name"));
                product.setPrice(rs.getDouble("p_price"));
                product.setImageUrl(rs.getString("p_image"));
                cart.setProduct(product);
                
                cartList.add(cart);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cartList;
    }

    public boolean updateQuantity(int cartId, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, cartId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromCart(int cartId) {
        String sql = "DELETE FROM cart WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, cartId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean clearCart(int userId, Connection conn) throws SQLException {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        }
    }

    public int getCartCount(int userId) {
        String sql = "SELECT SUM(quantity) FROM cart WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
