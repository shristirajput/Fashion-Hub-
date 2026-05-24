package com.fashionhub.controller;

import com.fashionhub.dao.RatingDAO;
import com.fashionhub.model.Rating;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/rate")
public class RatingServlet extends HttpServlet {
    private RatingDAO ratingDAO;

    @Override
    public void init() { ratingDAO = new RatingDAO(); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        int productId = Integer.parseInt(request.getParameter("product_id"));
        int stars = Integer.parseInt(request.getParameter("stars"));
        String review = request.getParameter("review");

        Rating rating = new Rating();
        rating.setUserId(userId);
        rating.setProductId(productId);
        rating.setStars(stars);
        rating.setReview(review);

        ratingDAO.addOrUpdateRating(rating);
        response.sendRedirect("products?action=view&id=" + productId + "#reviews");
    }
}
