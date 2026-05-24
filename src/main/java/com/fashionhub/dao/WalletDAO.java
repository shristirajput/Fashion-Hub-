package com.fashionhub.dao;

import com.fashionhub.model.Transaction;
import com.fashionhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WalletDAO {

    public boolean addFunds(int userId, double amount, String description) {
        Connection conn = DBConnection.getConnection();
        try {
            conn.setAutoCommit(false);
            
            // 1. Update user balance
            String updateSql = "UPDATE users SET wallet_balance = wallet_balance + ? WHERE id = ?";
            try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                updateStmt.setDouble(1, amount);
                updateStmt.setInt(2, userId);
                updateStmt.executeUpdate();
            }
            
            // 2. Add transaction record
            String transSql = "INSERT INTO transactions (user_id, amount, transaction_type, description) VALUES (?, ?, 'CREDIT', ?)";
            try (PreparedStatement transStmt = conn.prepareStatement(transSql)) {
                transStmt.setInt(1, userId);
                transStmt.setDouble(2, amount);
                transStmt.setString(3, description);
                transStmt.executeUpdate();
            }
            
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

    // Helper to deduct funds within an existing transaction (used by OrderDAO)
    public boolean deductFunds(int userId, double amount, String description, Connection conn) throws SQLException {
        // 1. Update user balance
        String updateSql = "UPDATE users SET wallet_balance = wallet_balance - ? WHERE id = ?";
        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
            updateStmt.setDouble(1, amount);
            updateStmt.setInt(2, userId);
            int updated = updateStmt.executeUpdate();
            if (updated == 0) return false;
        }
        
        // 2. Add transaction record
        String transSql = "INSERT INTO transactions (user_id, amount, transaction_type, description) VALUES (?, ?, 'DEBIT', ?)";
        try (PreparedStatement transStmt = conn.prepareStatement(transSql)) {
            transStmt.setInt(1, userId);
            transStmt.setDouble(2, amount);
            transStmt.setString(3, description);
            transStmt.executeUpdate();
        }
        return true;
    }

    public List<Transaction> getTransactionsByUserId(int userId) {
        List<Transaction> transactions = new ArrayList<>();
        String sql = "SELECT * FROM transactions WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Transaction t = new Transaction();
                t.setId(rs.getInt("id"));
                t.setUserId(rs.getInt("user_id"));
                t.setAmount(rs.getDouble("amount"));
                t.setTransactionType(rs.getString("transaction_type"));
                t.setDescription(rs.getString("description"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                transactions.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactions;
    }
}
