package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        System.out.println("LoginServlet initialized successfully");
        
        // Test database connection
        try {
            if (userDAO.testConnection()) {
                System.out.println("✓ Database connection verified in LoginServlet");
            } else {
                System.err.println("✗ Database connection failed in LoginServlet");
            }
        } catch (Exception e) {
            System.err.println("✗ Database test failed: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("\n=== LOGIN ATTEMPT ===");
        
        // Get parameters and handle null values
        String username = getParameter(request, "username");
        String password = getParameter(request, "password");
        
        System.out.println("Username: '" + username + "'");
        System.out.println("Password length: " + password.length());
        
        // Basic validation
        if (username.isEmpty() || password.isEmpty()) {
            System.out.println("❌ Validation failed: Missing credentials");
            setErrorAndRedirect(request, response, "Please enter both username and password.");
            return;
        }
        
        // Check minimum lengths
        if (username.length() < 3) {
            System.out.println("❌ Validation failed: Username too short");
            setErrorAndRedirect(request, response, "Username must be at least 3 characters long.");
            return;
        }
        
        try {
            System.out.println("🔍 Attempting user validation...");
            
            // First check if user exists at all
            User existingUser = userDAO.selectUserByUsername(username);
            if (existingUser == null) {
                System.out.println("❌ User not found: " + username);
                setErrorAndRedirect(request, response, "Invalid username or password. Please try again.");
                return;
            }
            
            System.out.println("✓ User found in database: " + existingUser.getUsername());
            System.out.println("✓ User details: ID=" + existingUser.getUserId() + ", Active=" + existingUser.isActive());
            
            // Try to validate with DAO method
            User validatedUser = userDAO.validateUser(username, password);
            
            if (validatedUser != null) {
                System.out.println("✅ User login SUCCESSFUL: " + username);
                
                // Create session for logged-in user
                HttpSession session = request.getSession();
                session.setAttribute("user", validatedUser);
                session.setAttribute("username", validatedUser.getUsername());
                session.setAttribute("fullName", validatedUser.getFullName());
                session.setAttribute("role", validatedUser.getRole());
                
                // Clear any messages
                session.removeAttribute("errorMessage");
                session.removeAttribute("successMessage");
                
                System.out.println("🔄 Redirecting to dashboard");
                response.sendRedirect(request.getContextPath() + "/dashboard");
                
            } else {
                System.out.println("❌ User login FAILED: Invalid password for " + username);
                setErrorAndRedirect(request, response, "Invalid username or password. Please try again.");
            }
            
        } catch (Exception e) {
            System.err.println("💥 Exception during login: " + e.getMessage());
            e.printStackTrace();
            setErrorAndRedirect(request, response, "System error occurred. Please try again later.");
        }
        
        System.out.println("=== END LOGIN ATTEMPT ===\n");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("📄 LoginServlet doGet - Showing login form");
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            System.out.println("🔄 User already logged in, redirecting to dashboard");
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // Get messages from session and put them in request scope for JSP
        if (session != null) {
            String errorMessage = (String) session.getAttribute("errorMessage");
            String successMessage = (String) session.getAttribute("successMessage");
            
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("errorMessage");
                System.out.println("⚠️ Displaying error message: " + errorMessage);
            }
            
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
                System.out.println("✅ Displaying success message: " + successMessage);
            }
        }
        
        // Forward to login JSP
        try {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } catch (ServletException e) {
            System.err.println("❌ Could not find /login.jsp, trying /pages/login.jsp");
            try {
                request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
            } catch (ServletException e2) {
                System.err.println("❌ Could not find /pages/login.jsp either");
                // Forward to a fallback page
                response.sendError(404, "Login page not found. Please ensure login.jsp exists in your webapp folder.");
            }
        }
    }
    
    // Helper method to safely get parameters
    private String getParameter(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return (value != null) ? value.trim() : "";
    }
    
    // Helper method to set error message and redirect
    private void setErrorAndRedirect(HttpServletRequest request, HttpServletResponse response, String message) 
            throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
        session.removeAttribute("successMessage");
        response.sendRedirect(request.getContextPath() + "/login");
    }
}