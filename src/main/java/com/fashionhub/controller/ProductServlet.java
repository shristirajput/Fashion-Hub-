package com.fashionhub.controller;

import com.fashionhub.dao.ProductDAO;
import com.fashionhub.model.Product;
import com.fashionhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/products")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("view".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(id);
            request.setAttribute("product", product);
            
            com.fashionhub.dao.RatingDAO ratingDAO = new com.fashionhub.dao.RatingDAO();
            request.setAttribute("ratings", ratingDAO.getRatingsByProduct(id));
            request.setAttribute("avgRating", ratingDAO.getAverageRating(id));
            request.setAttribute("ratingCount", ratingDAO.getRatingCount(id));
            
            request.getRequestDispatcher("product_details.jsp").forward(request, response);
        } else if ("search".equals(action)) {
            String query = request.getParameter("q");
            List<Product> products = productDAO.searchProducts(query);
            request.setAttribute("products", products);
            request.getRequestDispatcher("products.jsp").forward(request, response);
        } else if ("category".equals(action)) {
            int catId = Integer.parseInt(request.getParameter("id"));
            List<Product> products = productDAO.getProductsByCategory(catId);
            request.setAttribute("products", products);
            request.getRequestDispatcher("products.jsp").forward(request, response);
        } else if ("my_listings".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("userId") != null) {
                int userId = (int) session.getAttribute("userId");
                List<Product> myListings = productDAO.getProductsBySeller(userId);
                request.setAttribute("myListings", myListings);
                request.getRequestDispatcher("my_listings.jsp").forward(request, response);
            } else {
                response.sendRedirect("login.jsp");
            }
        } else {
            // Default list all approved products with pagination
            int page = 1;
            int limit = 6; // products per page
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            int offset = (page - 1) * limit;
            
            List<Product> products = productDAO.getAllApprovedProducts(offset, limit);
            int totalProducts = productDAO.getTotalApprovedProductsCount();
            int totalPages = (int) Math.ceil((double) totalProducts / limit);
            
            request.setAttribute("products", products);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.getRequestDispatcher("products.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("sell_used".equals(action)) {
            sellUsedProduct(request, response, user);
        }
    }

    private void sellUsedProduct(HttpServletRequest request, HttpServletResponse response, User user) throws IOException, ServletException {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String imageUrlParam = request.getParameter("image_url");

        String finalImageUrl = "";

        // Try file upload first
        Part filePart = request.getPart("image");
        String fileName = (filePart != null) ? extractFileName(filePart) : "";

        if (filePart != null && fileName != null && !fileName.isEmpty()) {
            String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "products";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(uploadPath + File.separator + uniqueFileName);
            finalImageUrl = "images/products/" + uniqueFileName;
        } else if (imageUrlParam != null && !imageUrlParam.trim().isEmpty()) {
            // Use provided URL
            finalImageUrl = imageUrlParam.trim();
        } else {
            // Default placeholder
            finalImageUrl = "https://via.placeholder.com/400x400?text=Used+Product";
        }

        Product product = new Product();
        product.setName(name);
        product.setDescription(description);
        product.setPrice(price);
        product.setStock(1);
        product.setCategoryId(categoryId);
        product.setImageUrl(finalImageUrl);
        product.setType("USED");
        product.setSellerId(user.getId());
        product.setStatus("PENDING");

        if (productDAO.addProduct(product)) {
            response.sendRedirect("sell_used.jsp?msg=Your product has been submitted! Admin will review it shortly.");
        } else {
            response.sendRedirect("sell_used.jsp?error=Failed to submit product. Please try again.");
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
