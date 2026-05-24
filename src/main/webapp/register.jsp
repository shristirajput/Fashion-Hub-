<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div class="auth-container">
    <div class="form-card">
        <h2>Create Account</h2>
        
        <c:if test="${not empty requestScope.error}">
            <div class="msg-error">${requestScope.error}</div>
        </c:if>

        <form action="auth" method="post">
            <input type="hidden" name="action" value="register">
            
            <div class="form-group">
                <input type="text" name="username" placeholder="Full Name" required>
            </div>

            <div class="form-group">
                <input type="email" name="email" placeholder="Email" required>
            </div>
            
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <div class="form-group">
                <input type="text" name="phone" placeholder="Phone Number">
            </div>
            
            <button type="submit" class="btn btn-black">Register</button>
        </form>
        
        <p>Already have an account? <a href="login.jsp">Login</a></p>
    </div>
</div>

<jsp:include page="footer.jsp" />
