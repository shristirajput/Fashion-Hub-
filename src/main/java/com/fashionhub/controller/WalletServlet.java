package com.fashionhub.controller;

import com.fashionhub.dao.WalletDAO;
import com.fashionhub.dao.UserDAO;
import com.fashionhub.model.Transaction;
import com.fashionhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/wallet")
public class WalletServlet extends HttpServlet {
    private WalletDAO walletDAO;
    private UserDAO userDAO;

    @Override
    public void init() {
        walletDAO = new WalletDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        
        // Refresh user details to get updated wallet balance
        User user = userDAO.getUserById(userId);
        session.setAttribute("user", user); // Update session with new balance

        List<Transaction> transactions = walletDAO.getTransactionsByUserId(userId);
        request.setAttribute("transactions", transactions);
        
        request.getRequestDispatcher("wallet.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("add_funds".equals(action)) {
            int userId = (int) session.getAttribute("userId");
            double amount = Double.parseDouble(request.getParameter("amount"));
            
            if (walletDAO.addFunds(userId, amount, "Wallet Top-up via Credit Card")) {
                response.sendRedirect("wallet?msg=Funds added successfully");
            } else {
                response.sendRedirect("wallet?error=Failed to add funds");
            }
        }
    }
}
