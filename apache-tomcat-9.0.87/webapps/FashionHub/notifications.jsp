<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.fashionhub.dao.NotificationDAO, com.fashionhub.model.Notification, java.util.List" %>
<%
    // Mark all as read when user visits this page
    if (session.getAttribute("userId") != null) {
        int userId = (int) session.getAttribute("userId");
        NotificationDAO nDao = new NotificationDAO();
        List<Notification> notifications = nDao.getUserNotifications(userId);
        pageContext.setAttribute("notifications", notifications);
        nDao.markAllAsRead(userId);
    } else {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<jsp:include page="header.jsp" />

<div style="max-width: 800px; margin: 0 auto;">
    <div style="margin-bottom: 2rem;">
        <h2 style="font-size: 1.8rem; color: #2c3e50; margin-bottom: 0.5rem;">My Notifications</h2>
        <p style="color: #888;">Stay updated on your listings and orders.</p>
    </div>

    <c:choose>
        <c:when test="${not empty notifications}">
            <div style="background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); overflow: hidden;">
                <c:forEach var="notif" items="${notifications}">
                    <div style="padding: 1.25rem 1.5rem; border-bottom: 1px solid #eee; display: flex; align-items: flex-start; gap: 1rem; ${notif.read ? 'background: #fafafa;' : 'background: #fff;'}">
                        <div style="background: ${notif.message.contains('rejected') ? '#f8d7da' : '#d4edda'}; color: ${notif.message.contains('rejected') ? '#721c24' : '#155724'}; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.2rem;">
                            ${notif.message.contains('rejected') ? '✕' : '✓'}
                        </div>
                        <div style="flex: 1;">
                            <p style="margin: 0; color: #2c3e50; font-size: 0.95rem; line-height: 1.5;">${notif.message}</p>
                            <span style="font-size: 0.8rem; color: #999; margin-top: 0.5rem; display: block;">${notif.createdAt}</span>
                        </div>
                        <c:if test="${!notif.read}">
                            <span style="width: 10px; height: 10px; background: #3498db; border-radius: 50%; display: block; margin-top: 0.5rem;"></span>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div style="background: #fff; padding: 3rem; border-radius: 12px; text-align: center; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                <h3 style="color: #666;">No notifications</h3>
                <p style="margin-top: 0.5rem;">You're all caught up!</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="footer.jsp" />
