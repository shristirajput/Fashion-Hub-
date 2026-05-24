package com.fashionhub.controller;

import com.fashionhub.dao.UserDAO;
import com.fashionhub.model.User;
import com.fashionhub.util.SecurityUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() { userDAO = new UserDAO(); }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); return;
        }
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp"); return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        if ("updateProfile".equals(action)) {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            if (userDAO.updateProfile(userId, username, email)) {
                // Update session user
                User user = (User) session.getAttribute("user");
                user.setUsername(username);
                user.setEmail(email);
                session.setAttribute("user", user);
                response.sendRedirect("profile?msg=Profile updated successfully!");
            } else {
                response.sendRedirect("profile?error=Update failed. Email may already be in use.");
            }

        } else if ("changePassword".equals(action)) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            User user = (User) session.getAttribute("user");

            if (!newPassword.equals(confirmPassword)) {
                response.sendRedirect("profile?error=New passwords do not match.&tab=password"); return;
            }
            if (!SecurityUtil.checkPassword(currentPassword, user.getPassword())) {
                response.sendRedirect("profile?error=Current password is incorrect.&tab=password"); return;
            }
            if (userDAO.changePassword(userId, newPassword)) {
                // Refresh user in session
                User updated = userDAO.getUserById(userId);
                session.setAttribute("user", updated);
                response.sendRedirect("profile?msg=Password changed successfully!&tab=password");
            } else {
                response.sendRedirect("profile?error=Password change failed.&tab=password");
            }
        }
    }
}
