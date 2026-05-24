<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div style="display: flex; gap: 3rem; margin-top: 2rem; background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
    <div style="flex: 1;">
        <img src="${product.imageUrl}" alt="${product.name}" style="width: 100%; border-radius: 8px; max-height: 500px; object-fit: contain; background: #f8f9fa;" onerror="this.src='https://via.placeholder.com/500x500?text=No+Image'">
    </div>
    
    <div style="flex: 1;">
        <c:choose>
            <c:when test="${product.type eq 'NEW'}">
                <span class="badge badge-new">New Product</span>
            </c:when>
            <c:otherwise>
                <span class="badge badge-used">Used Product</span>
            </c:otherwise>
        </c:choose>
        
        <h1 style="margin: 1rem 0; color: #2c3e50;">${product.name}</h1>
        <p style="font-size: 2rem; color: #e74c3c; font-weight: 700; margin-bottom: 1.5rem;">&#8377;${product.price}</p>
        
        <div style="margin-bottom: 2rem;">
            <h3>Description</h3>
            <p style="color: #666; line-height: 1.6; margin-top: 0.5rem;">${product.description}</p>
        </div>
        
        <div style="display: flex; gap: 1rem; align-items: center;">
            <div style="display: flex; align-items: center; gap: 0.5rem;">
                <label for="quantity" style="font-weight: 600;">Quantity:</label>
                <input type="number" id="quantity" name="quantity" value="1" min="1" max="${product.stock}" style="padding: 0.5rem; width: 80px; border: 1px solid #ddd; border-radius: 4px;">
            </div>
            
            <button type="button" onclick="addToCart(${product.id}, document.getElementById('quantity').value)" class="btn btn-primary" style="padding: 0.8rem 2rem; font-size: 1.1rem; background: #2ecc71;">Add to Cart</button>
        </div>
    </div>
</div>

<div style="margin-top: 3rem; background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
    <h3>Customer Reviews & Ratings</h3>
    
    <div style="display: flex; align-items: center; gap: 1rem; margin-top: 1rem; margin-bottom: 2rem;">
        <div style="font-size: 3rem; font-weight: 700; color: #f1c40f;">
            ${avgRating > 0 ? String.format("%.1f", avgRating) : "0.0"}
        </div>
        <div>
            <div style="color: #f1c40f; font-size: 1.5rem;">&#9733;</div>
            <div style="color: #666; font-size: 0.9rem;">Based on ${ratingCount} reviews</div>
        </div>
    </div>
    
    <c:if test="${not empty sessionScope.user}">
        <div style="margin-bottom: 2rem; padding: 1.5rem; background: #f8f9fa; border-radius: 8px;">
            <h4 style="margin-bottom: 1rem;">Write a Review</h4>
            <form action="rating" method="post">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="product_id" value="${product.id}">
                
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Rating (1-5 Stars):</label>
                    <select name="stars" style="padding: 0.5rem; width: 100px; border-radius: 4px; border: 1px solid #ddd;">
                        <option value="5">5 - Excellent</option>
                        <option value="4">4 - Good</option>
                        <option value="3">3 - Average</option>
                        <option value="2">2 - Poor</option>
                        <option value="1">1 - Terrible</option>
                    </select>
                </div>
                
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Your Review:</label>
                    <textarea name="review" rows="4" style="width: 100%; padding: 0.8rem; border-radius: 4px; border: 1px solid #ddd; resize: vertical;" placeholder="What did you like or dislike?"></textarea>
                </div>
                
                <button type="submit" class="btn btn-black">Submit Review</button>
            </form>
        </div>
    </c:if>
    
    <c:if test="${empty sessionScope.user}">
        <p style="margin-bottom: 2rem;"><a href="login.jsp" style="color: #3498db; text-decoration: underline;">Log in</a> to write a review.</p>
    </c:if>

    <div class="reviews-list">
        <c:forEach var="rating" items="${ratings}">
            <div style="border-bottom: 1px solid #eee; padding-bottom: 1rem; margin-bottom: 1rem;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem;">
                    <strong>${rating.username}</strong>
                    <span style="color: #f1c40f;">
                        <c:forEach begin="1" end="${rating.stars}">&#9733;</c:forEach>
                        <c:forEach begin="${rating.stars + 1}" end="5"><span style="color:#ddd;">&#9733;</span></c:forEach>
                    </span>
                </div>
                <p style="color: #555; margin: 0;">${rating.review}</p>
                <div style="font-size: 0.8rem; color: #999; margin-top: 0.5rem;">${rating.createdAt}</div>
            </div>
        </c:forEach>
        
        <c:if test="${empty ratings}">
            <p style="color: #666; font-style: italic;">No reviews yet. Be the first to review this product!</p>
        </c:if>
    </div>
</div>

<jsp:include page="footer.jsp" />
