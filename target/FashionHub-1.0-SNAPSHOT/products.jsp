<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<c:if test="${not empty param.msg}">
    <div class="msg-success" style="margin-top: 1rem;">${param.msg}</div>
</c:if>

<div class="products-grid" style="margin-top: 2rem;">
    <c:forEach var="product" items="${products}">
        <div class="product-card">
            <a href="products?action=view&id=${product.id}">
                <img src="${product.imageUrl}" alt="${product.name}" class="product-image" onerror="this.src='https://via.placeholder.com/300x300?text=No+Image'">
            </a>
            <div class="product-info">
                <div class="product-title">${product.name}</div>
                <!-- Assuming description holds brand for now, or just hardcoding based on image -->
                <div class="product-brand">
                    <c:choose>
                        <c:when test="${product.name.contains('Hoodie')}">H&M</c:when>
                        <c:when test="${product.name.contains('Nike') || product.name.contains('Shoes')}">NIKE</c:when>
                        <c:otherwise>ZARA</c:otherwise>
                    </c:choose>
                </div>
                <div class="product-price">&#8377;${product.price}</div>
                
                <a href="products?action=view&id=${product.id}" class="btn btn-black" style="display:block; text-align:center; margin-top:auto;">View Product</a>
                
                <c:if test="${not empty sessionScope.user}">
                    <button onclick="addToCart(${product.id})" class="btn btn-primary" style="display:block; width:100%; margin-top:0.5rem; background: #2ecc71;">Add to Cart</button>
                </c:if>
            </div>
        </div>
    </c:forEach>
    
    <c:if test="${empty products}">
        <p>No products found.</p>
    </c:if>
</div>

<div class="pagination" style="text-align: center; margin-top: 2rem;">
    <c:if test="${not empty totalPages && totalPages > 1}">
        <c:if test="${currentPage > 1}">
            <a href="products?page=${currentPage - 1}" class="btn" style="margin: 0 5px;">Previous</a>
        </c:if>
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="products?page=${i}" class="btn" style="margin: 0 5px; ${i == currentPage ? 'background: #333; color: #fff;' : ''}">${i}</a>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
            <a href="products?page=${currentPage + 1}" class="btn" style="margin: 0 5px;">Next</a>
        </c:if>
    </c:if>
</div>
<jsp:include page="footer.jsp" />
