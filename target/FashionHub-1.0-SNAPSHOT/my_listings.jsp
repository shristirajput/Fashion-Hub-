<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div style="max-width: 1000px; margin: 0 auto;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <div>
            <h2 style="font-size: 1.8rem; color: #2c3e50; margin-bottom: 0.5rem;">My Listings</h2>
            <p style="color: #888;">Track the approval status of your used products.</p>
        </div>
        <a href="sell_used.jsp" class="btn btn-primary">Sell Another Item</a>
    </div>

    <c:choose>
        <c:when test="${not empty myListings}">
            <div class="products-grid" style="margin-top: 0;">
                <c:forEach var="product" items="${myListings}">
                    <div class="product-card" style="box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #eee;">
                        <img src="${product.imageUrl}" alt="${product.name}" class="product-image" onerror="this.src='https://via.placeholder.com/300x300?text=No+Image'">
                        <div class="product-info">
                            <c:choose>
                                <c:when test="${product.status == 'APPROVED'}">
                                    <span class="badge" style="background: #2ecc71; color: white;">Approved</span>
                                </c:when>
                                <c:when test="${product.status == 'PENDING'}">
                                    <span class="badge" style="background: #f39c12; color: white;">Pending</span>
                                </c:when>
                                <c:when test="${product.status == 'REJECTED'}">
                                    <span class="badge" style="background: #e74c3c; color: white;">Rejected</span>
                                </c:when>
                            </c:choose>
                            <div class="product-title" style="margin-top: 0.5rem;">${product.name}</div>
                            <div class="product-price">$${product.price}</div>
                            <p style="font-size: 0.9rem; color: #666; margin-bottom: 1rem; height: 40px; overflow: hidden;">${product.description}</p>
                            
                            <c:if test="${product.status == 'REJECTED' && not empty product.rejectionReason}">
                                <div style="background: #f8d7da; color: #721c24; padding: 0.75rem; border-radius: 6px; font-size: 0.85rem; border: 1px solid #f5c6cb;">
                                    <strong>Reason for Rejection:</strong><br>
                                    ${product.rejectionReason}
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div style="background: #fff; padding: 3rem; border-radius: 12px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                <h3 style="color: #666;">You haven't listed any items yet.</h3>
                <p style="margin-top: 0.5rem; margin-bottom: 1.5rem;">Start selling your pre-loved fashion items today!</p>
                <a href="sell_used.jsp" class="btn btn-primary">List an Item</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="footer.jsp" />
