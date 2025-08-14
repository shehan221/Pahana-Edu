<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Bookstore Management System</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register_style.css">
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

    <div class="register-container">
        <!-- Left Side - Branding -->
        <div class="register-branding">
            <div class="brand-logo">
                <div class="brand-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <h1 class="brand-title">Join Pahana Edu</h1>
                <p class="brand-subtitle">Create your management account</p>
            </div>
            
            <div class="brand-benefits">
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <span>Secure Account Protection</span>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-tachometer-alt"></i>
                    </div>
                    <span>Full Dashboard Access</span>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <span>Team Collaboration</span>
                </div>
                <div class="benefit-item">
                    <div class="benefit-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <span>24/7 Support Access</span>
                </div>
            </div>
        </div>

        <!-- Right Side - Registration Form -->
        <div class="register-form-section">
            <div class="form-header">
                <h2 class="form-title">Create Account</h2>
                <p class="form-subtitle">Join our bookstore management system</p>
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

            <!-- Registration Form -->
            <form method="post" action="${pageContext.request.contextPath}/register" id="registrationForm">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="username" class="form-label">Username</label>
                        <div class="input-wrapper">
                            <i class="input-icon fas fa-user"></i>
                            <input type="text" 
                                   id="username" 
                                   name="username" 
                                   class="form-input"
                                   placeholder="Choose username"
                                   required 
                                   autofocus>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="fullName" class="form-label">Full Name</label>
                        <div class="input-wrapper">
                            <i class="input-icon fas fa-id-card"></i>
                            <input type="text" 
                                   id="fullName" 
                                   name="fullName" 
                                   class="form-input"
                                   placeholder="Enter full name"
                                   required>
                        </div>
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="email" class="form-label">Email Address</label>
                    <div class="input-wrapper">
                        <i class="input-icon fas fa-envelope"></i>
                        <input type="email" 
                               id="email" 
                               name="email" 
                               class="form-input"
                               placeholder="Enter email address">
                    </div>
                </div>

                <div class="form-group full-width">
                    <label for="password" class="form-label">Password</label>
                    <div class="input-wrapper">
                        <i class="input-icon fas fa-lock"></i>
                        <input type="password" 
                               id="password" 
                               name="password" 
                               class="form-input"
                               placeholder="Create secure password"
                               required>
                        <button type="button" class="password-toggle" onclick="togglePassword()">
                            <i class="fas fa-eye" id="passwordToggleIcon"></i>
                        </button>
                    </div>
                    <div class="password-strength" id="passwordStrength">
                        <div class="strength-bar">
                            <div class="strength-fill" id="strengthFill"></div>
                        </div>
                        <div class="strength-text" id="strengthText">Password strength</div>
                    </div>
                </div>

                <button type="submit" class="submit-btn" id="submitBtn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>

            <div class="login-link">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
            </div>

            <div class="register-footer">
                <p>&copy; 2025 Pahana Edu Bookstore Management System</p>
            </div>
        </div>
    </div>
  <script src="${pageContext.request.contextPath}/js/register.js"></script>
</body>
</html>