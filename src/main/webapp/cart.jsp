<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<h2>Your Shopping Cart</h2>

<c:if test="${not empty param.msg}">
    <div class="msg-success">${param.msg}</div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="msg-error">${param.error}</div>
</c:if>

<c:choose>
    <c:when test="${not empty cartItems}">
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Product</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Subtotal</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cartItems}">
                    <tr>
                        <td>
                            <div style="display: flex; align-items: center; gap: 1rem;">
                                <img src="${item.product.imageUrl}" alt="product" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;" onerror="this.src='https://via.placeholder.com/50'">
                                <span>${item.product.name}</span>
                            </div>
                        </td>
                        <td>&#8377;${item.product.price}</td>
                        <td>
                            <form action="cart" method="post" style="display: flex; gap: 0.5rem;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="cart_id" value="${item.id}">
                                <input type="number" name="quantity" value="${item.quantity}" min="1" style="width: 60px; padding: 0.2rem;">
                                <button type="submit" class="btn btn-outline" style="padding: 0.2rem 0.5rem; font-size: 0.8rem;">Update</button>
                            </form>
                        </td>
                        <td>&#8377;${item.product.price * item.quantity}</td>
                        <td>
                            <form action="cart" method="post">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="cart_id" value="${item.id}">
                                <button type="submit" class="btn btn-danger" style="padding: 0.3rem 0.8rem;">Remove</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="cart-summary">
            <h3>Total: &#8377;${total}</h3>
            <p style="color: #666; margin-bottom: 1.5rem;">Wallet Balance: &#8377;${sessionScope.user.walletBalance}</p>
            
            <c:choose>
                <c:when test="${sessionScope.user.walletBalance >= total}">
                    <a href="order?action=checkout" class="btn btn-primary" style="font-size: 1.2rem; padding: 1rem 2rem; display: inline-block;">Proceed to Checkout</a>
                </c:when>
                <c:otherwise>
                    <p class="msg-error" style="display: inline-block;">Insufficient Wallet Balance. <a href="wallet" style="text-decoration: underline;">Add funds</a></p>
                </c:otherwise>
            </c:choose>
        </div>
    </c:when>
    <c:otherwise>
        <div style="text-align: center; margin-top: 3rem;">
            <p style="font-size: 1.2rem; margin-bottom: 1rem;">Your cart is empty.</p>
            <a href="products" class="btn btn-primary">Continue Shopping</a>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="footer.jsp" />
