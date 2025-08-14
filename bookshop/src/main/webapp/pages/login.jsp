<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Bookstore Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login_style.css">
   
</head>
<body>
    <!-- Background Decoration -->
    <div class="bg-decoration"></div>
    
    <!-- Floating Books -->
    <div class="floating-books">
        <div class="floating-book"><i class="fas fa-book"></i></div>
        <div class="floating-book"><i class="fas fa-book-open"></i></div>
        <div class="floating-book"><i class="fas fa-graduation-cap"></i></div>
        <div class="floating-book"><i class="fas fa-feather-alt"></i></div>
        <div class="floating-book"><i class="fas fa-bookmark"></i></div>
    </div>

    <div class="login-container">
        <!-- Left Side - Branding -->
        <div class="login-branding">
            <div class="brand-logo">
                <div class="brand-icon">
                    <i class="fas fa-book-reader"></i>
                </div>
                <h1 class="brand-title">Pahana Edu Bookstore</h1>
                <p class="brand-subtitle">Management System Portal</p>
            </div>
            
            <div class="brand-features">
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <span>Customer Management</span>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-warehouse"></i>
                    </div>
                    <span>Inventory Control</span>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-receipt"></i>
                    </div>
                    <span>Smart Billing</span>
                </div>
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <span>Business Analytics</span>
                </div>
            </div>
        </div>

        <!-- Right Side - Login Form -->
        <div class="login-form-section">
            <div class="form-header">
                <h2 class="form-title">Welcome Back</h2>
                <p class="form-subtitle">Sign in to access your dashboard</p>
            </div>

            <!-- Display Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>${errorMessage}</span>
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${successMessage}</span>
                </div>
            </c:if>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
                <input type="hidden" name="action" value="login">
                
                <div class="form-group">
                    <label for="username" class="form-label">Username</label>
                    <div class="input-wrapper">
                        <i class="input-icon fas fa-user"></i>
                        <input type="text" 
                               id="username" 
                               name="username" 
                               class="form-input"
                               placeholder="Enter your username"
                               value="${username}" 
                               required 
                               autofocus>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-wrapper">
                        <i class="input-icon fas fa-lock"></i>
                        <input type="password" 
                               id="password" 
                               name="password" 
                               class="form-input"
                               placeholder="Enter your password"
                               required>
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye" id="passwordToggleIcon"></i>
                        </button>
                    </div>
                </div>
                
                <button type="submit" class="submit-btn" id="loginBtn">
                    <i class="fas fa-sign-in-alt"></i> Sign In to Dashboard
                </button>
            </form>
       
            
              <div class="login-link">
                <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Login here</a></p>
            </div>

            <div class="login-footer">
                <p>&copy; 2025 Pahana Edu Bookstore Management System</p>
                <p>Secure portal for authorized personnel only</p>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/login.js"></script>
</body>
</html>