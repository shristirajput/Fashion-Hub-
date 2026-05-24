<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.fashionhub.util.DBConnection, java.sql.*" %>
<%
    boolean dbConnected = false;
    int totalUsers = 0, totalProducts = 0, pendingCount = 0, totalOrders = 0;
    try (Connection conn = DBConnection.getConnection()) {
        dbConnected = (conn != null && !conn.isClosed());
        if (dbConnected) {
            try (Statement s = conn.createStatement()) {
                ResultSet r1 = s.executeQuery("SELECT COUNT(*) FROM users"); if(r1.next()) totalUsers = r1.getInt(1);
                ResultSet r2 = s.executeQuery("SELECT COUNT(*) FROM products WHERE status='APPROVED'"); if(r2.next()) totalProducts = r2.getInt(1);
                ResultSet r3 = s.executeQuery("SELECT COUNT(*) FROM products WHERE status='PENDING'"); if(r3.next()) pendingCount = r3.getInt(1);
                ResultSet r4 = s.executeQuery("SELECT COUNT(*) FROM orders"); if(r4.next()) totalOrders = r4.getInt(1);
            }
        }
    } catch(Exception e) { dbConnected = false; }
    pageContext.setAttribute("dbConnected", dbConnected);
    pageContext.setAttribute("totalUsers", totalUsers);
    pageContext.setAttribute("totalProducts", totalProducts);
    pageContext.setAttribute("pendingCount", pendingCount);
    pageContext.setAttribute("totalOrders", totalOrders);
%>
<jsp:include page="header.jsp" />

<div style="display: flex; gap: 2rem;">
    <!-- Sidebar -->
    <div style="width: 220px; background: #fff; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); height: fit-content;">
        <h3 style="margin-bottom: 1.5rem; color: #2c3e50;">Admin Menu</h3>
        <ul style="display: flex; flex-direction: column; gap: 1rem;">
            <li><a href="admin" style="font-weight: 700; color: #e74c3c;">&#9632; Dashboard</a></li>
            <li><a href="admin?action=pending_products">&#128338; Pending Approvals <c:if test="${pendingCount > 0}"><span style="background:#e74c3c;color:#fff;border-radius:50%;padding:1px 6px;font-size:0.75rem;margin-left:4px;">${pendingCount}</span></c:if></a></li>
            <li><a href="products">&#128722; All Products</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div style="flex: 1;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
            <div>
                <h2 style="color: #2c3e50; margin-bottom: 0.25rem;">Admin Dashboard</h2>
                <p style="color: #888; font-size: 0.9rem;">Welcome back, ${sessionScope.user.username}</p>
            </div>

            <!-- DB Status Badge -->
            <div style="background: #fff; padding: 0.75rem 1.2rem; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); display: flex; align-items: center; gap: 0.6rem;">
                <c:choose>
                    <c:when test="${dbConnected}">
                        <span style="width: 10px; height: 10px; background: #2ecc71; border-radius: 50%; display: inline-block; box-shadow: 0 0 6px #2ecc71;"></span>
                        <span style="font-size: 0.85rem; font-weight: 600; color: #2c3e50;">MySQL Connected</span>
                        <span style="font-size: 0.8rem; color: #888;">product_db @ localhost:3306</span>
                    </c:when>
                    <c:otherwise>
                        <span style="width: 10px; height: 10px; background: #e74c3c; border-radius: 50%; display: inline-block;"></span>
                        <span style="font-size: 0.85rem; font-weight: 600; color: #e74c3c;">DB Disconnected</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Stats Cards -->
        <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.2rem; margin-bottom: 2rem;">
            <div style="background: #fff; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: center; border-top: 3px solid #3498db;">
                <h3 style="color: #888; font-size: 0.85rem; margin-bottom: 0.5rem; text-transform: uppercase; letter-spacing: 0.5px;">Total Users</h3>
                <p style="font-size: 2.5rem; font-weight: 800; color: #3498db;">${totalUsers}</p>
            </div>
            <div style="background: #fff; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: center; border-top: 3px solid #2ecc71;">
                <h3 style="color: #888; font-size: 0.85rem; margin-bottom: 0.5rem; text-transform: uppercase; letter-spacing: 0.5px;">Active Products</h3>
                <p style="font-size: 2.5rem; font-weight: 800; color: #2ecc71;">${totalProducts}</p>
            </div>
            <div style="background: #fff; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: center; border-top: 3px solid #f39c12;">
                <h3 style="color: #888; font-size: 0.85rem; margin-bottom: 0.5rem; text-transform: uppercase; letter-spacing: 0.5px;">Pending Approvals</h3>
                <p style="font-size: 2.5rem; font-weight: 800; color: #f39c12;">${pendingCount}</p>
            </div>
            <div style="background: #fff; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); text-align: center; border-top: 3px solid #9b59b6;">
                <h3 style="color: #888; font-size: 0.85rem; margin-bottom: 0.5rem; text-transform: uppercase; letter-spacing: 0.5px;">Total Orders</h3>
                <p style="font-size: 2.5rem; font-weight: 800; color: #9b59b6;">${totalOrders}</p>
            </div>
        </div>

        <!-- DB Info Card -->
        <div style="background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 2rem;">
            <h3 style="margin-bottom: 1.2rem; color: #2c3e50;">&#128196; Database Configuration</h3>
            <table style="width: 100%; border-collapse: collapse; font-size: 0.9rem;">
                <tr style="border-bottom: 1px solid #eee;"><td style="padding: 0.6rem; color: #888;">Engine</td><td style="padding: 0.6rem; font-weight: 600;">MySQL 8.x</td></tr>
                <tr style="border-bottom: 1px solid #eee;"><td style="padding: 0.6rem; color: #888;">Database</td><td style="padding: 0.6rem; font-weight: 600;">product_db</td></tr>
                <tr style="border-bottom: 1px solid #eee;"><td style="padding: 0.6rem; color: #888;">Host</td><td style="padding: 0.6rem; font-weight: 600;">localhost:3306</td></tr>
                <tr style="border-bottom: 1px solid #eee;"><td style="padding: 0.6rem; color: #888;">Username</td><td style="padding: 0.6rem; font-weight: 600;">root</td></tr>
                <tr><td style="padding: 0.6rem; color: #888;">Status</td>
                    <td style="padding: 0.6rem;">
                        <c:choose>
                            <c:when test="${dbConnected}"><span style="color:#2ecc71; font-weight:700;">&#10003; Connected</span></c:when>
                            <c:otherwise><span style="color:#e74c3c; font-weight:700;">&#10007; Disconnected</span></c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </table>
        </div>

        <!-- Quick Actions -->
        <div style="background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
            <h3 style="margin-bottom: 1.2rem; color: #2c3e50;">&#9889; Quick Actions</h3>
            <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                <a href="admin?action=pending_products" class="btn btn-primary" style="padding: 0.7rem 1.5rem; border-radius: 8px;">Review Pending Products</a>
                <a href="products" class="btn btn-outline" style="padding: 0.7rem 1.5rem; border-radius: 8px;">View All Products</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp" />
