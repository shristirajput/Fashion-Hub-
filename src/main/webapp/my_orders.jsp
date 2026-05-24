<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="header.jsp" />

<h2 style="margin-bottom: 1.5rem; color: #2c3e50;">My Orders</h2>

<c:choose>
    <c:when test="${not empty orders}">
        <c:forEach var="order" items="${orders}">
            <div style="background: #fff; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.06); margin-bottom: 1.5rem; overflow: hidden;">
                <!-- Order Header -->
                <div style="display: flex; justify-content: space-between; align-items: center; padding: 1.2rem 1.5rem; background: #f8f9fa; border-bottom: 1px solid #eee;">
                    <div style="display: flex; gap: 3rem; align-items: center;">
                        <div>
                            <span style="font-size: 0.75rem; color: #888; display: block;">ORDER ID</span>
                            <span style="font-weight: 700; color: #2c3e50;">#FH-${order.id}</span>
                        </div>
                        <div>
                            <span style="font-size: 0.75rem; color: #888; display: block;">DATE</span>
                            <span style="font-weight: 600;">${order.createdAt}</span>
                        </div>
                        <div>
                            <span style="font-size: 0.75rem; color: #888; display: block;">TOTAL</span>
                            <span style="font-weight: 700; font-size: 1.1rem;">&#8377;${order.totalAmount}</span>
                        </div>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${order.status eq 'COMPLETED'}">
                                <span style="background: #d4edda; color: #155724; padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">&#9679; Completed</span>
                            </c:when>
                            <c:when test="${order.status eq 'PENDING'}">
                                <span style="background: #fff3cd; color: #856404; padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">&#9679; Pending</span>
                            </c:when>
                            <c:otherwise>
                                <span style="background: #f8d7da; color: #721c24; padding: 0.4rem 1rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">&#9679; Cancelled</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Order Items -->
                <div style="padding: 1.5rem;">
                    <c:forEach var="item" items="${order.items}">
                        <div style="display: flex; gap: 1.2rem; align-items: center; padding: 1rem 0; border-bottom: 1px solid #f0f0f0;">
                            <img src="${item.product.imageUrl}"
                                 alt="${item.product.name}"
                                 style="width: 70px; height: 70px; object-fit: cover; border-radius: 8px; background: #f1f2f6;"
                                 onerror="this.src='https://via.placeholder.com/70?text=IMG'">
                            <div style="flex: 1;">
                                <div style="font-weight: 600; font-size: 1rem; margin-bottom: 0.3rem;">${item.product.name}</div>
                                <div style="font-size: 0.85rem; color: #888;">Qty: ${item.quantity} &nbsp;&bull;&nbsp; &#8377;${item.price} each</div>
                            </div>
                            <div style="font-weight: 700; font-size: 1.05rem; color: #2c3e50;">
                                &#8377;${item.price * item.quantity}
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Order Footer -->
                <div style="padding: 1rem 1.5rem; display: flex; justify-content: flex-end; gap: 1rem; align-items: center; border-top: 1px solid #eee;">
                    <a href="products" class="btn btn-outline" style="padding: 0.5rem 1.2rem; border-radius: 6px;">Buy Again</a>
                </div>
            </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div style="text-align: center; background: #fff; padding: 5rem 2rem; border-radius: 16px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
            <div style="font-size: 4rem; margin-bottom: 1rem;">&#128722;</div>
            <h3 style="color: #2c3e50; margin-bottom: 0.75rem;">No orders yet</h3>
            <p style="color: #888; margin-bottom: 2rem;">You haven't placed any orders. Start shopping now!</p>
            <a href="products" class="btn btn-black" style="padding: 0.9rem 2.5rem; border-radius: 8px; font-size: 1rem;">Shop Now</a>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="footer.jsp" />
