<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div style="display: flex; gap: 2rem;">
    <!-- Wallet Summary & Add Funds -->
    <div style="flex: 1; background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); height: fit-content;">
        <h2>My Virtual Wallet</h2>
        <div style="margin: 2rem 0;">
            <p style="font-size: 1.1rem; color: #666;">Current Balance</p>
            <p style="font-size: 3rem; font-weight: 700; color: #2ecc71;">$${sessionScope.user.walletBalance}</p>
        </div>
        
        <c:if test="${not empty param.msg}">
            <div class="msg-success">${param.msg}</div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div class="msg-error">${param.error}</div>
        </c:if>

        <h3 style="margin-bottom: 1rem;">Add Funds</h3>
        <form action="wallet" method="post">
            <input type="hidden" name="action" value="add_funds">
            <div class="form-group">
                <label for="amount">Amount ($)</label>
                <input type="number" id="amount" name="amount" min="1" step="0.01" required>
            </div>
            <!-- Dummy payment method selection -->
            <div class="form-group">
                <label for="payment">Payment Method (Simulation)</label>
                <select id="payment" name="payment">
                    <option value="card">Credit/Debit Card</option>
                    <option value="paypal">PayPal</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary" style="width: 100%;">Add to Wallet</button>
        </form>
    </div>

    <!-- Transaction History -->
    <div style="flex: 2;">
        <h2>Transaction History</h2>
        
        <c:choose>
            <c:when test="${not empty transactions}">
                <table class="transaction-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Description</th>
                            <th>Amount</th>
                            <th>Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="tx" items="${transactions}">
                            <tr>
                                <td>${tx.createdAt}</td>
                                <td>${tx.description}</td>
                                <td>$${tx.amount}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tx.transactionType eq 'CREDIT'}">
                                            <span style="color: #2ecc71; font-weight: 600;">+ $${tx.amount}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #e74c3c; font-weight: 600;">- $${tx.amount}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p style="margin-top: 1rem; color: #666;">No transactions found.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="footer.jsp" />
