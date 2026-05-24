<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FashionHub - Smart Fashion Marketplace</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>

<header>
    <nav class="navbar">
        <div class="logo">
            <a href="index.jsp">FASHIONHUB</a>
        </div>
        <ul class="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="products">Shop</a></li>
            <li><a href="sell_used.jsp">Used Market</a></li>
            <c:if test="${not empty sessionScope.user}">
                <%
                    if (session.getAttribute("userId") != null) {
                        int userId = (int) session.getAttribute("userId");
                        com.fashionhub.dao.NotificationDAO nDao = new com.fashionhub.dao.NotificationDAO();
                        int unreadCount = nDao.getUnreadCount(userId);
                        pageContext.setAttribute("unreadNotifications", unreadCount);
                    }
                %>
                <li>
                    <a href="notifications.jsp" style="position: relative;">
                        🔔 
                        <c:if test="${unreadNotifications > 0}">
                            <span class="cart-badge" style="background: #e74c3c;">${unreadNotifications}</span>
                        </c:if>
                    </a>
                </li>
                <li>
                    <a href="cart" style="position: relative;">
                        Cart 
                        <span id="cart-count-badge" class="cart-badge">${sessionScope.cartCount > 0 ? sessionScope.cartCount : ''}</span>
                    </a>
                </li>
                <li><a href="wallet">Wallet</a></li>
                <li><a href="products?action=my_listings">My Listings</a></li>
                <li><a href="my-orders">My Orders</a></li>
                <li><a href="auth?action=logout" style="color: #e74c3c;">Logout</a></li>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <li><a href="login.jsp">Login</a></li>
                <li><a href="register.jsp">Register</a></li>
            </c:if>
            <c:if test="${sessionScope.userRole eq 'ADMIN'}">
                <li><a href="admin" style="color: #f1c40f;">Admin</a></li>
            </c:if>
        </ul>
        <div class="header-search">
            <form action="products" method="get" style="display:flex;">
                <input type="hidden" name="action" value="search">
                <input type="text" name="q" placeholder="Search fashion products...">
                <button type="submit">Search</button>
            </form>
        </div>
    </nav>
</header>

<div class="sub-header">
    <div class="sub-header-container">
        <a href="products?action=category&id=1" class="pill-link">Men</a>
        <a href="products?action=category&id=2" class="pill-link">Women</a>
        <a href="products?action=category&id=3" class="pill-link">Kids</a>
        <a href="products?action=category&id=5" class="pill-link">Shoes</a>
        <a href="products?action=category&id=4" class="pill-link">Accessories</a>
        <a href="products" class="pill-link">All Products</a>
    </div>
</div>

<main>
