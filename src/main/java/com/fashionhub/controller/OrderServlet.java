package com.fashionhub.controller;

import com.fashionhub.dao.CartDAO;
import com.fashionhub.dao.OrderDAO;
import com.fashionhub.model.Cart;
import com.fashionhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;
    private CartDAO cartDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("checkout".equals(action)) {
            showCheckoutPage(request, response);
        } else {
            // Default to orders history (if implemented) or redirect to shop
            response.sendRedirect("products");
        }
    }

    private void showCheckoutPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");
        List<Cart> cartItems = cartDAO.getCartByUserId(userId);

        if (cartItems.isEmpty()) {
            response.sendRedirect("cart?error=Your cart is empty.");
            return;
        }

        double total = 0;
        for (Cart item : cartItems) {
            total += item.getQuantity() * item.getProduct().getPrice();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("placeOrder".equals(action)) {
            double total = Double.parseDouble(request.getParameter("total"));
            boolean success = orderDAO.checkout(userId, total);

            if (success) {
                // Update session user balance
                User user = (User) session.getAttribute("user");
                user.setWalletBalance(user.getWalletBalance() - total);
                session.setAttribute("user", user);
                session.setAttribute("cartCount", 0); // Cart is cleared

                response.sendRedirect("order_success.jsp?total=" + total);
            } else {
                response.sendRedirect("order?action=checkout&error=Order placement failed. Insufficient funds or error.");
            }
        }
    }
}
