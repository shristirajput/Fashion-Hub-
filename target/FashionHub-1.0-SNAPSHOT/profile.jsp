<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<div style="max-width: 700px; margin: 0 auto;">
    <h2 style="margin-bottom: 0.5rem; color: #2c3e50;">My Profile</h2>
    <p style="color: #888; margin-bottom: 2rem;">Manage your account details and security settings.</p>

    <c:if test="${not empty param.msg}">
        <div class="msg-success" style="margin-bottom: 1rem;">${param.msg}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="msg-error" style="margin-bottom: 1rem;">${param.error}</div>
    </c:if>

    <!-- Profile Avatar Card -->
    <div style="background:#fff; border-radius:12px; box-shadow:0 4px 15px rgba(0,0,0,0.06); padding:2rem; margin-bottom:1.5rem; display:flex; align-items:center; gap:2rem;">
        <div style="width:80px;height:80px;border-radius:50%;background:linear-gradient(135deg,#667eea,#764ba2);display:flex;align-items:center;justify-content:center;font-size:2rem;color:#fff;font-weight:700;flex-shrink:0;">
            ${sessionScope.user.username.substring(0,1).toUpperCase()}
        </div>
        <div>
            <h3 style="margin:0 0 0.3rem;color:#2c3e50;font-size:1.4rem;">${sessionScope.user.username}</h3>
            <p style="color:#888;margin:0 0 0.5rem;">${sessionScope.user.email}</p>
            <span style="background:${sessionScope.userRole eq 'ADMIN' ? '#fff3cd' : '#d4edda'};color:${sessionScope.userRole eq 'ADMIN' ? '#856404' : '#155724'};padding:0.2rem 0.8rem;border-radius:20px;font-size:0.8rem;font-weight:600;">
                ${sessionScope.userRole}
            </span>
        </div>
        <div style="margin-left:auto;text-align:right;">
            <div style="font-size:1.4rem;font-weight:800;color:#2c3e50;">&#8377;${sessionScope.user.walletBalance}</div>
            <div style="font-size:0.8rem;color:#888;">Wallet Balance</div>
        </div>
    </div>

    <!-- Tab Navigation -->
    <div style="display:flex;gap:0;margin-bottom:1.5rem;background:#fff;border-radius:10px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.06);">
        <button onclick="switchTab('info')" id="tab-info"
                style="flex:1;padding:0.9rem;border:none;cursor:pointer;font-weight:600;font-size:0.95rem;background:${empty param.tab ? '#333' : '#fff'};color:${empty param.tab ? '#fff' : '#555'};">
            &#128100; Personal Info
        </button>
        <button onclick="switchTab('password')" id="tab-password"
                style="flex:1;padding:0.9rem;border:none;cursor:pointer;font-weight:600;font-size:0.95rem;background:${param.tab eq 'password' ? '#333' : '#fff'};color:${param.tab eq 'password' ? '#fff' : '#555'};">
            &#128274; Change Password
        </button>
    </div>

    <!-- Personal Info Form -->
    <div id="panel-info" style="background:#fff;border-radius:12px;box-shadow:0 4px 15px rgba(0,0,0,0.06);padding:2rem;display:${empty param.tab ? 'block' : 'none'};">
        <h3 style="margin-bottom:1.5rem;color:#2c3e50;">Personal Information</h3>
        <form action="profile" method="post">
            <input type="hidden" name="action" value="updateProfile">
            <div style="margin-bottom:1.2rem;">
                <label style="display:block;font-weight:600;margin-bottom:0.5rem;">Username</label>
                <input type="text" name="username" value="${sessionScope.user.username}" required
                       style="width:100%;padding:0.8rem;border:1px solid #ddd;border-radius:6px;font-size:0.95rem;">
            </div>
            <div style="margin-bottom:1.5rem;">
                <label style="display:block;font-weight:600;margin-bottom:0.5rem;">Email Address</label>
                <input type="email" name="email" value="${sessionScope.user.email}" required
                       style="width:100%;padding:0.8rem;border:1px solid #ddd;border-radius:6px;font-size:0.95rem;">
            </div>
            <button type="submit" class="btn btn-black" style="padding:0.8rem 2rem;border-radius:8px;">Save Changes</button>
        </form>
    </div>

    <!-- Change Password Form -->
    <div id="panel-password" style="background:#fff;border-radius:12px;box-shadow:0 4px 15px rgba(0,0,0,0.06);padding:2rem;display:${param.tab eq 'password' ? 'block' : 'none'};">
        <h3 style="margin-bottom:1.5rem;color:#2c3e50;">Change Password</h3>
        <form action="profile" method="post">
            <input type="hidden" name="action" value="changePassword">
            <div style="margin-bottom:1.2rem;">
                <label style="display:block;font-weight:600;margin-bottom:0.5rem;">Current Password</label>
                <input type="password" name="currentPassword" required
                       style="width:100%;padding:0.8rem;border:1px solid #ddd;border-radius:6px;">
            </div>
            <div style="margin-bottom:1.2rem;">
                <label style="display:block;font-weight:600;margin-bottom:0.5rem;">New Password</label>
                <input type="password" name="newPassword" required minlength="6"
                       style="width:100%;padding:0.8rem;border:1px solid #ddd;border-radius:6px;">
            </div>
            <div style="margin-bottom:1.5rem;">
                <label style="display:block;font-weight:600;margin-bottom:0.5rem;">Confirm New Password</label>
                <input type="password" name="confirmPassword" required minlength="6"
                       style="width:100%;padding:0.8rem;border:1px solid #ddd;border-radius:6px;">
            </div>
            <button type="submit" class="btn btn-black" style="padding:0.8rem 2rem;border-radius:8px;">Update Password</button>
        </form>
    </div>

    <!-- Quick Links -->
    <div style="display:flex;gap:1rem;margin-top:1.5rem;flex-wrap:wrap;">
        <a href="my-orders" class="btn btn-outline" style="padding:0.7rem 1.2rem;border-radius:8px;">&#128722; My Orders</a>
        <a href="wallet" class="btn btn-outline" style="padding:0.7rem 1.2rem;border-radius:8px;">&#128181; My Wallet</a>
        <a href="sell_used.jsp" class="btn btn-outline" style="padding:0.7rem 1.2rem;border-radius:8px;">&#9851; Sell Used Item</a>
    </div>
</div>

<script>
function switchTab(tab) {
    document.getElementById('panel-info').style.display = tab === 'info' ? 'block' : 'none';
    document.getElementById('panel-password').style.display = tab === 'password' ? 'block' : 'none';
    document.getElementById('tab-info').style.background = tab === 'info' ? '#333' : '#fff';
    document.getElementById('tab-info').style.color = tab === 'info' ? '#fff' : '#555';
    document.getElementById('tab-password').style.background = tab === 'password' ? '#333' : '#fff';
    document.getElementById('tab-password').style.color = tab === 'password' ? '#fff' : '#555';
}
</script>

<jsp:include page="footer.jsp" />
