<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="header.jsp" />

</div> <!-- End of main container started in header (wait, I moved <main> out, so need to close <main> differently if needed. Actually in header.jsp I opened <main>. I will just close it in footer.) -->
</main>

<div class="hero">
    <h1>Define Your Style</h1>
    <p>Discover premium fashion, shop trending outfits, and trade used styles using reward coins.</p>
    <div class="hero-buttons">
        <a href="products" class="btn btn-hero yellow">Shop Now</a>
        <a href="sell_used.jsp" class="btn btn-hero outline">Used Market</a>
    </div>
</div>

<div class="info-cards">
    <div class="info-card">
        <h3 style="display: flex; align-items: center; justify-content: center; gap: 0.5rem;"><span style="color: #000;">&#128085;</span> Premium Fashion</h3>
        <p>Explore curated fashion collections from top brands.</p>
    </div>
    <div class="info-card">
        <h3 style="display: flex; align-items: center; justify-content: center; gap: 0.5rem;"><span style="color: #000;">&#9851;</span> Trade & Earn Coins</h3>
        <p>Sell used fashion and earn coins for shopping.</p>
    </div>
    <div class="info-card">
        <h3 style="display: flex; align-items: center; justify-content: center; gap: 0.5rem;"><span style="color: #3498db;">&#128142;</span> Exclusive Deals</h3>
        <p>Unlock special discounts using your reward coins.</p>
    </div>
</div>

<main>
    <!-- Empty main block here to keep footer spacing correct as footer closes main -->

<jsp:include page="footer.jsp" />
