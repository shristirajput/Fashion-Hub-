<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div class="auth-container">
    <div class="form-card">
        <h2>Login</h2>
        
        <c:if test="${not empty requestScope.error}">
            <div class="msg-error">${requestScope.error}</div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="msg-success">${param.success}</div>
        </c:if>

        <form action="auth" method="post">
            <input type="hidden" name="action" value="login">
            
            <div class="form-group">
                <input type="email" name="email" placeholder="Email" required>
            </div>
            
            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>
            
            <button type="submit" class="btn btn-black">Login</button>
        </form>
        
        <p>Don't have an account? <a href="register.jsp">Register</a></p>
    </div>
</div>

<jsp:include page="footer.jsp" />
