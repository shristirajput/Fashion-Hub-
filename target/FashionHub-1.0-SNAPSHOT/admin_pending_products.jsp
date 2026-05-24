<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div style="display: flex; gap: 2rem;">
    <!-- Sidebar -->
    <div style="width: 250px; background: #fff; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); height: fit-content;">
        <h3 style="margin-bottom: 1.5rem; color: #2c3e50;">Admin Menu</h3>
        <ul style="display: flex; flex-direction: column; gap: 1rem;">
            <li><a href="admin">Dashboard</a></li>
            <li><a href="admin?action=pending_products" style="font-weight: 600; color: #e74c3c;">Pending Approvals</a></li>
            <li><a href="products">All Products</a></li>
        </ul>
    </div>

    <!-- Main Content -->
    <div style="flex: 1;">
        <h2>Pending Used Products</h2>
        <p style="margin-bottom: 2rem; color: #666;">Review and approve products submitted by users.</p>
        
        <c:if test="${not empty param.msg}">
            <div class="msg-success">${param.msg}</div>
        </c:if>

        <c:choose>
            <c:when test="${not empty pendingProducts}">
                <div class="products-grid" style="margin-top: 0;">
                    <c:forEach var="product" items="${pendingProducts}">
                        <div class="product-card" style="box-shadow: 0 4px 15px rgba(231, 76, 60, 0.15); border: 1px solid #f8d7da;">
                            <img src="${product.imageUrl}" alt="${product.name}" class="product-image" onerror="this.src='https://via.placeholder.com/300x300?text=No+Image'">
                            <div class="product-info">
                                <span class="badge badge-used">Pending</span>
                                <div class="product-title">${product.name}</div>
                                <div class="product-price">$${product.price}</div>
                                <p style="font-size: 0.9rem; color: #666; margin-bottom: 1rem; height: 40px; overflow: hidden;">${product.description}</p>
                                
                                <div style="display: flex; gap: 0.5rem; flex-direction: column;">
                                    <div style="display: flex; gap: 0.5rem;">
                                        <form action="admin" method="post" style="flex: 1;">
                                            <input type="hidden" name="action" value="approve_product">
                                            <input type="hidden" name="product_id" value="${product.id}">
                                            <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.5rem;">Approve</button>
                                        </form>
                                    </div>
                                    <form action="admin" method="post" style="display: flex; flex-direction: column; gap: 0.5rem;">
                                        <input type="hidden" name="action" value="reject_product">
                                        <input type="hidden" name="product_id" value="${product.id}">
                                        <input type="text" name="rejection_reason" placeholder="Reason for rejection (optional)" style="padding: 0.4rem; border: 1px solid #ddd; border-radius: 4px; font-size: 0.85rem;" required>
                                        <button type="submit" class="btn btn-danger" style="width: 100%; padding: 0.5rem;">Reject</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div style="background: #fff; padding: 3rem; border-radius: 12px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                    <h3 style="color: #666;">No pending products</h3>
                    <p style="margin-top: 0.5rem;">All caught up!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="footer.jsp" />
