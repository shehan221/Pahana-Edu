<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<%
// Handle Registration
String errorMessage = "";
String successMessage = "";

if ("POST".equals(request.getMethod())) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String fullName = request.getParameter("fullName");
    String email = request.getParameter("email");
    
    // Validation
    if (username == null || username.trim().isEmpty()) {
        errorMessage = "Username is required!";
    } else if (password == null || password.trim().isEmpty()) {
        errorMessage = "Password is required!";
    } else if (fullName == null || fullName.trim().isEmpty()) {
        errorMessage = "Full name is required!";
    } else if (email == null || email.trim().isEmpty()) {
        errorMessage = "Email is required!";
    } else if (!password.equals(confirmPassword)) {
        errorMessage = "Passwords do not match!";
    } else if (password.length() < 6) {
        errorMessage = "Password must be at least 6 characters long!";
    } else {
        // Check if username already exists
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            java.sql.Connection conn = java.sql.DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/bookstore_db", "root", "123456");
            
            // Check existing username
            java.sql.PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE username = ?");
            checkStmt.setString(1, username);
            java.sql.ResultSet rs = checkStmt.executeQuery();
            rs.next();
            
            if (rs.getInt(1) > 0) {
                errorMessage = "Username already exists! Please choose a different username.";
            } else {
                // Check existing email
                java.sql.PreparedStatement checkEmailStmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM users WHERE email = ?");
                checkEmailStmt.setString(1, email);
                java.sql.ResultSet emailRs = checkEmailStmt.executeQuery();
                emailRs.next();
                
                if (emailRs.getInt(1) > 0) {
                    errorMessage = "Email already registered! Please use a different email.";
                } else {
                    // Insert new user
                    java.sql.PreparedStatement insertStmt = conn.prepareStatement(
                        "INSERT INTO users (username, password, full_name, email, role, is_active) VALUES (?, ?, ?, ?, 'USER', TRUE)");
                    insertStmt.setString(1, username);
                    insertStmt.setString(2, password); 
                    insertStmt.setString(3, fullName);
                    insertStmt.setString(4, email);
                    
                    int result = insertStmt.executeUpdate();
                    if (result > 0) {
                        successMessage = "Registration successful! You can now login.";
                        // Clear form fields
                        username = "";
                        fullName = "";
                        email = "";
                    } else {
                        errorMessage = "Registration failed! Please try again.";
                    }
                    insertStmt.close();
                }
                emailRs.close();
                checkEmailStmt.close();
            }
            rs.close();
            checkStmt.close();
            conn.close();
            
        } catch (Exception e) {
            errorMessage = "Database error: " + e.getMessage();
            e.printStackTrace();
        }
    }
    
    pageContext.setAttribute("errorMessage", errorMessage);
    pageContext.setAttribute("successMessage", successMessage);
    pageContext.setAttribute("username", username != null ? username : "");
    pageContext.setAttribute("fullName", fullName != null ? fullName : "");
    pageContext.setAttribute("email", email != null ? email : "");
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Pahana Edu</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register_style.css">
</head>
<body>
    <div class="register-container">
        <!-- Left Side - Branding -->
        <div class="register-left">
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
        
        <!-- Right Side - Register Form -->
        <div class="register-right">
            <div class="register-header">
                <h2>Create Account</h2>
                <p>Join our bookstore management system</p>
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
            
            <form method="post" id="registerForm">
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
                    <label for="fullName">Full Name</label>
                    <div class="input-icon">
                        <i class="fas fa-id-card"></i>
                        <input type="text" id="fullName" name="fullName" 
                               value="${fullName}" required maxlength="100"
                               placeholder="Enter your full name">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <div class="input-icon">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" 
                               value="${email}" required maxlength="100"
                               placeholder="Enter your email address">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" 
                                   required minlength="6" maxlength="255"
                                   placeholder="Enter password">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <div class="input-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="confirmPassword" name="confirmPassword" 
                                   required minlength="6" maxlength="255"
                                   placeholder="Confirm password">
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="register-btn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>
            
            <div class="login-link">
                Already have an account? 
                <a href="${pageContext.request.contextPath}/pages/login.jsp">Sign In</a>
            </div>
            
            <div class="footer-text">
                © 2025 Pahana Edu Bookstore Management System<br>
                Secure portal for authorized personnel only
            </div>
        </div>
    </div>

    <script>
        // Form validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('Password must be at least 6 characters long!');
                return false;
            }
        });

        // Real-time password confirmation check
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.style.borderColor = '#e53e3e';
                this.style.backgroundColor = '#fed7d7';
            } else {
                this.style.borderColor = '#e1e8ed';
                this.style.backgroundColor = '#f8f9fa';
            }
        });

        // Auto-hide success message and redirect to login
        document.addEventListener('DOMContentLoaded', function() {
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                setTimeout(function() {
                    window.location.href = '${pageContext.request.contextPath}/pages/login.jsp';
                }, 3000);
            }
        });

        console.log('Register page loaded');
    </script>
</body>
</html>