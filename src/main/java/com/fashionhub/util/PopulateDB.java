package com.fashionhub.util;

import java.sql.*;
import java.nio.file.*;

public class PopulateDB {
    public static void main(String[] args) {
        String URL = "jdbc:mysql://localhost:3306/product_db?useSSL=false&allowPublicKeyRetrieval=true";
        String USER = "root";
        String PASS = "root@123";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             Statement stmt = conn.createStatement()) {
            
            stmt.execute("SET FOREIGN_KEY_CHECKS=0");
            String sql = new String(Files.readAllBytes(Paths.get("c:/FashionHub/database.sql")));
            String[] commands = sql.split(";");
            for (String cmd : commands) {
                if (!cmd.trim().isEmpty()) {
                    stmt.execute(cmd);
                }
            }
            stmt.execute("SET FOREIGN_KEY_CHECKS=1");
            System.out.println("Database populated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
