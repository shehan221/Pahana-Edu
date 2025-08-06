package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            handleLogin(request, response, username, password);
        } else if ("logout".equals(action)) {
            handleLogout(request, response);
        }
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response, 
                            String username, String password) throws ServletException, IOException {
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Username and password are required");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            return;
        }
        
        try {
            // Validate user credentials
            User user = userDAO.validateUser(username.trim(), password);
            
            if (user != null) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userRole", user.getRole());
                session.setAttribute("userId", user.getUserId());
                
                // Set session timeout (30 minutes)
                session.setMaxInactiveInterval(30 * 60);
                
                System.out.println("User logged in successfully: " + user.getUsername());
                
                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/dashboard");
                
            } else {
                // Login failed
                request.setAttribute("errorMessage", "Invalid username or password");
                request.setAttribute("username", username); // Keep username in form
                request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("errorMessage", "System error occurred. Please try again.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }
    
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            String username = (String) session.getAttribute("username");
            session.invalidate();
            System.out.println("User logged out: " + username);
        }
        
        // Redirect to login page with success message
        request.setAttribute("successMessage", "You have been logged out successfully");
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }
}