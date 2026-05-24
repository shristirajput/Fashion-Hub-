</main>

<div id="toast" class="toast"></div>

<footer>
    <p>&copy; 2026 FashionHub. All Rights Reserved. MVC Project Demo.</p>
</footer>

<script>
function showToast(message, type = 'success') {
    const toast = document.getElementById('toast');
    toast.textContent = message;
    toast.className = 'toast show toast-' + type;
    
    setTimeout(() => {
        toast.className = 'toast';
    }, 3000);
}

function addToCart(productId, quantity = 1) {
    const params = new URLSearchParams();
    params.append('action', 'add');
    params.append('product_id', productId);
    params.append('quantity', quantity);
    params.append('ajax', 'true');

    fetch('cart', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => {
        if (response.redirected) {
            window.location.href = response.url;
            return;
        }
        return response.json();
    })
    .then(data => {
        if (data && data.status === 'success') {
            showToast(data.message);
            const badge = document.getElementById('cart-count-badge');
            if (badge) {
                badge.textContent = data.cartCount;
                badge.style.display = 'flex';
            }
        } else if (data && data.status === 'error') {
            showToast(data.message, 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showToast('Failed to add to cart', 'error');
    });
}
</script>
</body>
</html>
