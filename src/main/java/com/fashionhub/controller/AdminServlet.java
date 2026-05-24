package com.fashionhub.controller;

import com.fashionhub.dao.ProductDAO;
import com.fashionhub.dao.NotificationDAO;
import com.fashionhub.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private ProductDAO productDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("pending_products".equals(action)) {
            List<Product> pendingProducts = productDAO.getPendingProducts();
            request.setAttribute("pendingProducts", pendingProducts);
            request.getRequestDispatcher("admin_pending_products.jsp").forward(request, response);
        } else {
            // Admin dashboard
            request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("approve_product".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("product_id"));
            Product p = productDAO.getProductById(productId);
            if (p != null) {
                productDAO.updateProductStatus(productId, "APPROVED");
                if (p.getSellerId() != null) {
                    notificationDAO.addNotification(p.getSellerId(), "Your listing '" + p.getName() + "' has been approved!");
                }
            }
            response.sendRedirect("admin?action=pending_products&msg=Product approved");
        } else if ("reject_product".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("product_id"));
            String reason = request.getParameter("rejection_reason");
            Product p = productDAO.getProductById(productId);
            if (p != null) {
                productDAO.rejectProduct(productId, reason);
                if (p.getSellerId() != null) {
                    notificationDAO.addNotification(p.getSellerId(), "Your listing '" + p.getName() + "' was rejected. Reason: " + reason);
                }
            }
            response.sendRedirect("admin?action=pending_products&msg=Product rejected");
        }
    }
}
