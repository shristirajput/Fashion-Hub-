<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

<c:if test="${empty sessionScope.user}">
    <script>window.location.href = 'login.jsp?error=Please login to sell a product.';</script>
</c:if>

<div style="max-width: 640px; margin: 0 auto;">
    <div style="text-align: center; margin-bottom: 2rem;">
        <h2 style="font-size: 1.8rem; color: #2c3e50; margin-bottom: 0.5rem;">Sell on Used Market</h2>
        <p style="color: #888;">List your pre-loved fashion items. An admin will review and approve your listing before it goes live.</p>
    </div>

    <div style="background: #fff3cd; border-left: 4px solid #f1c40f; padding: 1rem 1.5rem; border-radius: 8px; margin-bottom: 1.5rem; font-size: 0.9rem; color: #856404;">
        &#9432; Your listing will appear on the marketplace once approved by our admin team.
    </div>

    <c:if test="${not empty param.error}">
        <div class="msg-error">${param.error}</div>
    </c:if>
    <c:if test="${not empty param.msg}">
        <div class="msg-success">${param.msg}</div>
    </c:if>

    <div style="background: #fff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.06);">
        <form action="products" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="sell_used">

            <div class="form-group" style="margin-bottom: 1.2rem;">
                <label style="display: block; font-weight: 600; margin-bottom: 0.5rem;">Product Title</label>
                <input type="text" name="name" required placeholder="e.g. Vintage Denim Jacket"
                       style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95rem;">
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1.2rem;">
                <div class="form-group">
                    <label style="display: block; font-weight: 600; margin-bottom: 0.5rem;">Category</label>
                    <select name="category_id" required style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95rem;">
                        <option value="1">Men</option>
                        <option value="2">Women</option>
                        <option value="3">Kids</option>
                        <option value="4">Accessories</option>
                        <option value="5">Shoes</option>
                    </select>
                </div>
                <div class="form-group">
                    <label style="display: block; font-weight: 600; margin-bottom: 0.5rem;">Price (&#8377;)</label>
                    <input type="number" name="price" min="1" step="0.01" required
                           placeholder="e.g. 1500"
                           style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95rem;">
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 1.2rem;">
                <label style="display: block; font-weight: 600; margin-bottom: 0.5rem;">Description <span style="color:#888; font-weight: 400;">(Include condition, brand, size)</span></label>
                <textarea name="description" rows="4" required placeholder="e.g. Lightly worn once. Original brand tag intact. Size M."
                          style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px; font-size: 0.95rem; resize: vertical;"></textarea>
            </div>

            <div class="form-group" style="margin-bottom: 1.5rem;">
                <label style="display: block; font-weight: 600; margin-bottom: 0.5rem;">Product Image</label>
                <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                    <div>
                        <label style="font-size: 0.85rem; color: #666; margin-bottom: 0.3rem; display: block;">Upload from device:</label>
                        <input type="file" name="image" accept="image/*"
                               style="width: 100%; padding: 0.7rem; border: 1px dashed #ddd; border-radius: 6px; background: #fafafa;">
                    </div>
                    <div style="text-align:center; color: #aaa; font-size: 0.85rem;">— or paste an image URL below —</div>
                    <div>
                        <label style="font-size: 0.85rem; color: #666; margin-bottom: 0.3rem; display: block;">Image URL:</label>
                        <input type="text" name="image_url" placeholder="https://example.com/my-product.jpg"
                               style="width: 100%; padding: 0.8rem; border: 1px solid #ddd; border-radius: 6px; font-size: 0.9rem;">
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-black" style="width: 100%; padding: 1rem; font-size: 1.05rem; border-radius: 8px;">
                Submit for Admin Approval
            </button>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
