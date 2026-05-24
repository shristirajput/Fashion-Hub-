<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div class="checkout-container" style="max-width: 1000px; margin: 2rem auto; display: grid; grid-template-columns: 1.5fr 1fr; gap: 2rem;">
    <div class="checkout-details" style="background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
        <h2 style="margin-bottom: 1.5rem; color: #2c3e50;">Shipping Information</h2>
        <form id="checkoutForm" action="order" method="post">
            <input type="hidden" name="action" value="placeOrder">
            <input type="hidden" name="total" value="${total}">
            
            <div class="form-group" style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Full Name</label>
                <input type="text" name="name" value="${sessionScope.user.username}" required style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px;">
            </div>
            
            <div class="form-group" style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Shipping Address</label>
                <textarea name="address" required style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px; min-height: 100px;" placeholder="Enter your full delivery address..."></textarea>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group" style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">City</label>
                    <input type="text" name="city" required style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px;">
                </div>
                <div class="form-group" style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Pincode</label>
                    <input type="text" name="pincode" required style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px;">
                </div>
            </div>
            
            <h2 style="margin: 2rem 0 1.5rem; color: #2c3e50;">Payment Method</h2>
            <div style="background: #f8f9fa; padding: 1rem; border-radius: 8px; display: flex; align-items: center; gap: 1rem; border: 1px solid #3498db;">
                <input type="radio" checked disabled>
                <div>
                    <strong style="display: block;">FashionHub Wallet</strong>
                    <span style="font-size: 0.9rem; color: #666;">Available Balance: &#8377;${sessionScope.user.walletBalance}</span>
                </div>
                <span style="margin-left: auto; color: #3498db; font-weight: 700;">&#10003; Selected</span>
            </div>
        </form>
    </div>

    <div class="order-summary" style="background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); height: fit-content;">
        <h2 style="margin-bottom: 1.5rem; color: #2c3e50;">Order Summary</h2>
        
        <div style="margin-bottom: 1.5rem; max-height: 300px; overflow-y: auto;">
            <c:forEach var="item" items="${cartItems}">
                <div style="display: flex; gap: 1rem; margin-bottom: 1rem; align-items: center;">
                    <img src="${item.product.imageUrl}" alt="product" style="width: 60px; height: 60px; object-fit: cover; border-radius: 6px;">
                    <div style="flex: 1;">
                        <span style="display: block; font-weight: 600; font-size: 0.9rem;">${item.product.name}</span>
                        <span style="font-size: 0.85rem; color: #666;">Qty: ${item.quantity}</span>
                    </div>
                    <span style="font-weight: 600;">&#8377;${item.product.price * item.quantity}</span>
                </div>
            </c:forEach>
        </div>
        
        <hr style="border: 0; border-top: 1px solid #eee; margin-bottom: 1.5rem;">
        
        <div style="display: flex; justify-content: space-between; margin-bottom: 0.5rem; font-size: 1.1rem;">
            <span>Subtotal</span>
            <span>&#8377;${total}</span>
        </div>
        <div style="display: flex; justify-content: space-between; margin-bottom: 1.5rem; color: #2ecc71; font-weight: 600;">
            <span>Shipping</span>
            <span>FREE</span>
        </div>
        
        <div style="display: flex; justify-content: space-between; margin-bottom: 2rem; font-size: 1.5rem; font-weight: 800; color: #333;">
            <span>Total</span>
            <span>&#8377;${total}</span>
        </div>
        
        <c:choose>
            <c:when test="${sessionScope.user.walletBalance >= total}">
                <button type="submit" form="checkoutForm" class="btn btn-black" style="width: 100%; padding: 1rem; font-size: 1.2rem; border-radius: 8px;">Place Order</button>
            </c:when>
            <c:otherwise>
                <div style="text-align: center;">
                    <p style="color: #e74c3c; margin-bottom: 1rem; font-weight: 600;">Insufficient Balance</p>
                    <a href="wallet" class="btn btn-primary" style="width: 100%; padding: 0.8rem; border-radius: 8px;">Add Funds to Wallet</a>
                </div>
            </c:otherwise>
        </c:choose>
        
        <p style="text-align: center; margin-top: 1.5rem; font-size: 0.8rem; color: #888;">
            By placing your order, you agree to FashionHub's terms of use and privacy policy.
        </p>
    </div>
</div>

<jsp:include page="footer.jsp" />
