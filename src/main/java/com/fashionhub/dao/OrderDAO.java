package com.fashionhub.dao;

import com.fashionhub.model.Cart;
import com.fashionhub.model.Order;
import com.fashionhub.model.OrderItem;
import com.fashionhub.model.Product;
import com.fashionhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    
    public boolean checkout(int userId, double totalAmount) {
        Connection conn = DBConnection.getConnection();
        CartDAO cartDAO = new CartDAO();
        WalletDAO walletDAO = new WalletDAO();
        
        try {
            conn.setAutoCommit(false);
            
            // 1. Check wallet balance
            String balanceSql = "SELECT wallet_balance FROM users WHERE id = ?";
            double balance = 0;
            try (PreparedStatement stmt = conn.prepareStatement(balanceSql)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    balance = rs.getDouble("wallet_balance");
                }
            }
            
            if (balance < totalAmount) {
                return false; // Insufficient funds
            }
            
            // 2. Deduct funds
            boolean fundsDeducted = walletDAO.deductFunds(userId, totalAmount, "Order Checkout", conn);
            if (!fundsDeducted) {
                conn.rollback();
                return false;
            }
            
            // 3. Create Order
            String orderSql = "INSERT INTO orders (user_id, total_amount, status) VALUES (?, ?, 'COMPLETED')";
            int orderId = -1;
            try (PreparedStatement stmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setInt(1, userId);
                stmt.setDouble(2, totalAmount);
                stmt.executeUpdate();
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }
            
            // 4. Create Order Items and update stock
            List<Cart> cartItems = cartDAO.getCartByUserId(userId);
            String orderItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
            String stockSql = "UPDATE products SET stock = stock - ? WHERE id = ?";
            
            try (PreparedStatement itemStmt = conn.prepareStatement(orderItemSql);
                 PreparedStatement stockStmt = conn.prepareStatement(stockSql)) {
                 
                for (Cart item : cartItems) {
                    itemStmt.setInt(1, orderId);
                    itemStmt.setInt(2, item.getProductId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setDouble(4, item.getProduct().getPrice());
                    itemStmt.addBatch();
                    
                    stockStmt.setInt(1, item.getQuantity());
                    stockStmt.setInt(2, item.getProductId());
                    stockStmt.addBatch();
                }
                itemStmt.executeBatch();
                stockStmt.executeBatch();
            }
            
            // 5. Clear Cart
            cartDAO.clearCart(userId, conn);
            
            conn.commit();
            return true;
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String orderSql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        String itemSql = "SELECT oi.*, p.name as p_name, p.image_url as p_image FROM order_items oi " +
                         "JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement orderStmt = conn.prepareStatement(orderSql)) {

            orderStmt.setInt(1, userId);
            ResultSet orderRs = orderStmt.executeQuery();

            while (orderRs.next()) {
                Order order = new Order();
                order.setId(orderRs.getInt("id"));
                order.setUserId(orderRs.getInt("user_id"));
                order.setTotalAmount(orderRs.getDouble("total_amount"));
                order.setStatus(orderRs.getString("status"));
                order.setCreatedAt(orderRs.getTimestamp("created_at"));

                // Fetch items for this order
                List<OrderItem> items = new ArrayList<>();
                try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                    itemStmt.setInt(1, order.getId());
                    ResultSet itemRs = itemStmt.executeQuery();
                    while (itemRs.next()) {
                        OrderItem item = new OrderItem();
                        item.setId(itemRs.getInt("id"));
                        item.setOrderId(order.getId());
                        item.setProductId(itemRs.getInt("product_id"));
                        item.setQuantity(itemRs.getInt("quantity"));
                        item.setPrice(itemRs.getDouble("price"));

                        Product p = new Product();
                        p.setId(itemRs.getInt("product_id"));
                        p.setName(itemRs.getString("p_name"));
                        p.setImageUrl(itemRs.getString("p_image"));
                        p.setPrice(itemRs.getDouble("price"));
                        item.setProduct(p);

                        items.add(item);
                    }
                }
                order.setItems(items);
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }
}
