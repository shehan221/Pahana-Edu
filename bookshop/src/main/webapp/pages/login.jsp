<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>

<%!
    // User class that matches what the profile page expects
    public static class User {
        private int userId;
        private String username;
        private String fullName;
        private String email;
        private String role;
        private boolean active;
        
        public User() {}
        
        public User(int userId, String username, String fullName, String email, String role, boolean active) {
            this.userId = userId;
            this.username = username;
            this.fullName = fullName;
            this.email = email;
            this.role = role;
            this.active = active;
        }
        
        // Getters that the profile page uses
        public int getUserId() { return userId; }
        public String getUsername() { return username; }
        public String getFullName() { return fullName; }
        public String getEmail() { return email; }
        public String getRole() { return role; }
        public boolean isActive() { return active; }
        public boolean getActive() { return active; } 
        
        // Setters that the profile page uses for updates
        public void setUserId(int userId) { this.userId = userId; }
        public void setUsername(String username) { this.username = username; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        public void setEmail(String email) { this.email = email; }
        public void setRole(String role) { this.role = role; }
        public void setActive(boolean active) { this.active = active; }
    }
%>

<%
// Check if user is already logged in
if (session.getAttribute("user") != null) {
    response.sendRedirect(request.getContextPath() + "/pages/dashboard.jsp");
    return;
}

// Handle Login
String errorMessage = "";
String successMessage = "";

if ("POST".equals(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    
    // Validation
    if (username == null || username.trim().isEmpty()) {
        errorMessage = "Username is required!";
    } else if (password == null || password.trim().isEmpty()) {
        errorMessage = "Password is required!";
    } else {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Database configuration 
            String DB_URL = "jdbc:mysql://localhost:3306/bookstore_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String DB_USER = "root";
            String DB_PASS = "123456"; 
            
            // Alternative URLs 
            String[] alternativeUrls = {
                "jdbc:mysql://127.0.0.1:3306/bookstore_db?useSSL=false",
                "jdbc:mysql://localhost:3306/bookstore_db",
                "jdbc:mysql://127.0.0.1:3306/bookstore_db"
            };
            
            // Trying main URL first
            try {
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                System.out.println("Connected successfully with main URL");
            } catch (SQLException e) {
                System.out.println("Main URL failed: " + e.getMessage());
                
                // Trying alternative URLs
                for (String altUrl : alternativeUrls) {
                    try {
                        conn = DriverManager.getConnection(altUrl, DB_USER, DB_PASS);
                        System.out.println("Connected successfully with: " + altUrl);
                        break;
                    } catch (SQLException e2) {
                        System.out.println("Failed: " + altUrl + " - " + e2.getMessage());
                    }
                }
                
                if (conn == null) {
                    throw new SQLException("Could not connect to database with any URL. Check if MySQL is running and credentials are correct.");
                }
            }
            
            // Check user credentials - using plain text password to match profile page
            stmt = conn.prepareStatement(
                "SELECT user_id, username, full_name, email, role, is_active FROM users WHERE username = ? AND password = ?");
            stmt.setString(1, username.trim());
            stmt.setString(2, password); // Plain text password comparison 
            
            rs = stmt.executeQuery();
            
            if (rs.next()) {
                boolean isActive = rs.getBoolean("is_active");
                if (!isActive) {
                    errorMessage = "Your account has been deactivated. Please contact administrator.";
                } else {
                    // Create User object that the profile page can work with
                    User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("role"),
                        isActive
                    );
                    
                    session.setAttribute("user", user);
                    session.setMaxInactiveInterval(3600); // 1 hour session timeout
                    
                    // Redirect to profile page or dashboard
                    response.sendRedirect(request.getContextPath() + "/pages/dashboard.jsp");
                    return;
                }
            } else {
                errorMessage = "Invalid username or password!";
            }
            
        } catch (ClassNotFoundException e) {
            errorMessage = "Database driver not found. Please ensure MySQL JDBC driver is installed.";
            System.err.println("MySQL Driver error: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            errorMessage = "Database connection failed: " + e.getMessage() + ". Please check if MySQL is running.";
            System.err.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "An error occurred during login: " + e.getMessage();
            System.err.println("General error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    pageContext.setAttribute("errorMessage", errorMessage);
    pageContext.setAttribute("username", username != null ? username : "");
}

// Check for logout message from profile page
if ("true".equals(request.getParameter("logout"))) {
    successMessage = "You have been logged out successfully!";
    pageContext.setAttribute("successMessage", successMessage);
}

// Check for registration success
if ("success".equals(request.getParameter("register"))) {
    successMessage = "Registration successful! Please login with your credentials.";
    pageContext.setAttribute("successMessage", successMessage);
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Pahana Edu</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login_style.css">
</head>
<body>
    <div class="login-container">
        <!-- Left Side - Branding -->
        <div class="login-left">
            <div class="brand-logo">
                <i class="fas fa-book-open"></i>
            </div>
            <h1 class="brand-title">Pahana Edu<br>Bookstore</h1>
            <p class="brand-subtitle">Management System Portal</p>
            
            <ul class="features">
                <li><i class="fas fa-users"></i> Customer Management</li>
                <li><i class="fas fa-boxes"></i> Inventory Control</li>
                <li><i class="fas fa-receipt"></i> Smart Billing</li>
                <li><i class="fas fa-chart-line"></i> Business Analytics</li>
            </ul>
        </div>
        
        <!-- Right Side - Login Form -->
        <div class="login-right">
            <div class="login-header">
                <h2>Welcome Back</h2>
                <p>Sign in to access your dashboard</p>
            </div>
            
            <!-- Error/Success Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> ${errorMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i> ${successMessage}
                </div>
            </c:if>
            
            <form method="post" id="loginForm">
                <div class="form-group">
                    <label for="username">Username</label>
                    <div class="input-icon">
                        <i class="fas fa-user"></i>
                        <input type="text" id="username" name="username" 
                               value="${username}" required maxlength="50"
                               placeholder="Enter your username">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="input-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" 
                               required maxlength="255"
                               placeholder="Enter your password">
                    </div>
                </div>
                
                <button type="submit" class="login-btn">
                    <i class="fas fa-sign-in-alt"></i> Sign In to Dashboard
                </button>
            </form>
            
            <div class="register-link">
                Don't have an account? 
                <a href="${pageContext.request.contextPath}/pages/register.jsp">Register here</a>
            </div>
            
            
            <div class="footer-text">
                © 2025 Pahana Edu Bookstore Management System<br>
                Secure portal for authorized personnel only
            </div>
        </div>
    </div>

    <script>
        // Form validation
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (!username) {
                e.preventDefault();
                alert('Please enter your username!');
                document.getElementById('username').focus();
                return false;
            }
            
            if (!password) {
                e.preventDefault();
                alert('Please enter your password!');
                document.getElementById('password').focus();
                return false;
            }
            
            // Show loading state
            const submitBtn = document.querySelector('.login-btn');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Signing In...';
            submitBtn.disabled = true;
        });

        // Auto-hide success messages
        document.addEventListener('DOMContentLoaded', function() {
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                setTimeout(function() {
                    successAlert.style.opacity = '0';
                    successAlert.style.transform = 'translateY(-10px)';
                    setTimeout(function() {
                        successAlert.remove();
                    }, 300);
                }, 5000);
            }
            
            // Auto-hide error messages after 8 seconds
            const errorAlert = document.querySelector('.alert-error');
            if (errorAlert) {
                setTimeout(function() {
                    errorAlert.style.opacity = '0';
                    errorAlert.style.transform = 'translateY(-10px)';
                }, 8000);
            }
        });

        // Focus first input
        document.getElementById('username').focus();

        // Clear form if there was an error
        if (window.location.search.includes('error')) {
            document.getElementById('password').value = '';
        }

        console.log('Compatible login page loaded - Works with profile JSP system');
    </script>
</body>
</html>