<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div class="order-success">
    <div class="checkmark">&#10003;</div>
    <h1 style="font-size: 2rem; color: #2c3e50; margin-bottom: 0.75rem;">Order Placed!</h1>
    <p style="color: #666; font-size: 1.1rem; margin-bottom: 0.5rem;">
        Thank you for shopping with <strong>FashionHub</strong>.
    </p>
    <p style="color: #888; font-size: 0.95rem; margin-bottom: 2rem;">
        Your order has been confirmed and is being processed. You will receive it soon!
    </p>

    <div style="background: #f8f9fa; border-radius: 10px; padding: 1.5rem; margin-bottom: 2rem; text-align: left;">
        <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem;">
            <span style="color: #888;">Order Status</span>
            <span style="font-weight: 700; color: #2ecc71;">&#9679; Confirmed</span>
        </div>
        <div style="display: flex; justify-content: space-between; margin-bottom: 0.75rem;">
            <span style="color: #888;">Payment</span>
            <span style="font-weight: 600;">FashionHub Wallet</span>
        </div>
        <div style="display: flex; justify-content: space-between;">
            <span style="color: #888;">Amount Paid</span>
            <span style="font-weight: 700; font-size: 1.2rem;">&#8377;${param.total}</span>
        </div>
    </div>

    <div style="display: flex; gap: 1rem; justify-content: center;">
        <a href="products" class="btn btn-black" style="padding: 0.9rem 2rem; border-radius: 8px; font-size: 1rem;">Continue Shopping</a>
        <a href="wallet" class="btn btn-outline" style="padding: 0.9rem 2rem; border-radius: 8px; font-size: 1rem;">View Wallet</a>
    </div>
</div>

<jsp:include page="footer.jsp" />
