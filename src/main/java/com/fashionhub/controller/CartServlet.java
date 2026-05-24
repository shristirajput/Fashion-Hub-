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
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private CartDAO cartDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        cartDAO = new CartDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        List<Cart> cartItems = cartDAO.getCartByUserId(userId);
        
        double total = 0;
        for (Cart item : cartItems) {
            total += item.getQuantity() * item.getProduct().getPrice();
        }
        
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.getRequestDispatcher("cart.jsp").forward(request, response);
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

        if ("add".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("product_id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            Cart cart = new Cart();
            cart.setUserId(userId);
            cart.setProductId(productId);
            cart.setQuantity(quantity);
            
            cartDAO.addToCart(cart);
            int newCount = cartDAO.getCartCount(userId);
            
            String ajax = request.getParameter("ajax");
            if ("true".equals(ajax)) {
                response.setContentType("application/json");
                JsonObject json = new JsonObject();
                json.addProperty("status", "success");
                json.addProperty("message", "Product added to cart!");
                json.addProperty("cartCount", newCount);
                
                PrintWriter out = response.getWriter();
                out.print(json.toString());
                out.flush();
            } else {
                response.sendRedirect("cart");
            }
            
        } else if ("remove".equals(action)) {
            int cartId = Integer.parseInt(request.getParameter("cart_id"));
            cartDAO.removeFromCart(cartId);
            response.sendRedirect("cart");
            
        } else if ("update".equals(action)) {
            int cartId = Integer.parseInt(request.getParameter("cart_id"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            cartDAO.updateQuantity(cartId, quantity);
            response.sendRedirect("cart");
        }
    }
}
