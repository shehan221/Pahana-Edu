package com.bookstore.servlet;

import com.bookstore.dao.UserDAO;
import com.bookstore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        System.out.println("RegisterServlet initialized successfully");
        
        // Test database connection
        try {
            if (userDAO.testConnection()) {
                System.out.println("✓ Database connection verified in RegisterServlet");
            } else {
                System.err.println("✗ Database connection failed in RegisterServlet");
            }
        } catch (Exception e) {
            System.err.println("✗ Database test failed: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("\n=== REGISTRATION ATTEMPT ===");
        
        // Get parameters and handle null values
        String username = getParameter(request, "username");
        String password = getParameter(request, "password");
        String fullName = getParameter(request, "fullName");
        String email = getParameter(request, "email");
        
        System.out.println("Username: '" + username + "'");
        System.out.println("Full Name: '" + fullName + "'");
        System.out.println("Email: '" + email + "'");
        
        // Basic validation
        if (username.isEmpty() || password.isEmpty() || fullName.isEmpty()) {
            System.out.println("❌ Validation failed: Missing required fields");
            setErrorAndRedirect(request, response, "Please fill in all required fields.");
            return;
        }
        
        // Check minimum lengths
        if (username.length() < 3) {
            System.out.println("❌ Validation failed: Username too short");
            setErrorAndRedirect(request, response, "Username must be at least 3 characters long.");
            return;
        }
        
        if (password.length() < 6) {
            System.out.println("❌ Validation failed: Password too short");
            setErrorAndRedirect(request, response, "Password must be at least 6 characters long.");
            return;
        }
        
        try {
            System.out.println("🔍 Checking if username exists...");
            
            if (userDAO.usernameExists(username)) {
                System.out.println("❌ Username already exists: " + username);
                setErrorAndRedirect(request, response, "Username already exists. Please choose another.");
                return;
            }
            
            System.out.println("✓ Username is available");
            
            // Create user object
            User user = new User(username, password, fullName, email, "USER");
            System.out.println("📝 Created user object: " + user.toString());
            
            // Insert user into database
            System.out.println("💾 Attempting to save user to database...");
            boolean success = userDAO.insertUser(user);
            
            if (success) {
                System.out.println("✅ User registration SUCCESSFUL: " + username);
                
                // Set success message and redirect to login
                HttpSession session = request.getSession();
                session.setAttribute("successMessage", "Registration successful! Please log in with your new account.");
                session.removeAttribute("errorMessage");
                
                System.out.println("🔄 Redirecting to login page");
                response.sendRedirect(request.getContextPath() + "/login");
                
            } else {
                System.err.println("❌ User registration FAILED: " + username);
                setErrorAndRedirect(request, response, "Registration failed. Please try again.");
            }
            
        } catch (Exception e) {
            System.err.println("💥 Exception during registration: " + e.getMessage());
            e.printStackTrace();
            setErrorAndRedirect(request, response, "System error occurred. Please try again later.");
        }
        
        System.out.println("=== END REGISTRATION ATTEMPT ===\n");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("📄 RegisterServlet doGet - Showing registration form");
        
        // Get messages from session and put them in request scope for JSP
        HttpSession session = request.getSession(false);
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
        
        // Forward to register JSP
        try {
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        } catch (ServletException e) {
            System.err.println("❌ Could not find /register.jsp, trying /pages/register.jsp");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
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
        response.sendRedirect(request.getContextPath() + "/register");
    }
}