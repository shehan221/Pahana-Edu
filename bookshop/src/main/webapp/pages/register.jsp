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
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f8fffe 0%, #f0f9ff 50%, #ecfdf5 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        /* Background Elements */
        .bg-decoration {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .bg-decoration::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="books" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse"><rect fill="rgba(5,150,105,0.03)" width="20" height="20"/><path d="M2 2h16v16H2z" fill="none" stroke="rgba(5,150,105,0.08)" stroke-width="0.5"/><circle cx="10" cy="10" r="2" fill="rgba(5,150,105,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23books)"/></svg>') repeat;
            animation: backgroundMove 30s linear infinite;
        }

        @keyframes backgroundMove {
            0% { transform: translate(0, 0); }
            100% { transform: translate(-20px, -20px); }
        }

        /* Floating Books */
        .floating-books {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .floating-book {
            position: absolute;
            font-size: 2rem;
            color: rgba(5, 150, 105, 0.1);
            animation: floatAnimation 20s infinite linear;
        }

        .floating-book:nth-child(1) { left: 10%; animation-delay: 0s; }
        .floating-book:nth-child(2) { left: 30%; animation-delay: 4s; }
        .floating-book:nth-child(3) { left: 50%; animation-delay: 8s; }
        .floating-book:nth-child(4) { left: 70%; animation-delay: 12s; }
        .floating-book:nth-child(5) { left: 90%; animation-delay: 16s; }

        @keyframes floatAnimation {
            0% {
                transform: translateY(100vh) rotate(0deg);
                opacity: 0;
            }
            10% {
                opacity: 1;
            }
            90% {
                opacity: 1;
            }
            100% {
                transform: translateY(-100px) rotate(360deg);
                opacity: 0;
            }
        }

        /* Main Container */
        .register-container {
            background: white;
            border-radius: 24px;
            box-shadow: 
                0 25px 50px rgba(0, 0, 0, 0.08),
                0 0 0 1px rgba(5, 150, 105, 0.05);
            overflow: hidden;
            width: 100%;
            max-width: 1100px;
            display: grid;
            grid-template-columns: 1fr 1fr;
            min-height: 650px;
            animation: containerEntrance 0.8s ease-out;
        }

        @keyframes containerEntrance {
            0% {
                opacity: 0;
                transform: translateY(30px) scale(0.95);
            }
            100% {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Left Side - Branding */
        .register-branding {
            background: linear-gradient(135deg, #059669, #10b981);
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .register-branding::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400"><defs><pattern id="brandPattern" x="0" y="0" width="40" height="40" patternUnits="userSpaceOnUse"><circle cx="20" cy="20" r="15" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="1"/><rect x="10" y="10" width="20" height="20" fill="none" stroke="rgba(255,255,255,0.05)" stroke-width="0.5"/></pattern></defs><rect width="400" height="400" fill="url(%23brandPattern)"/></svg>') repeat;
            animation: brandPatternMove 25s linear infinite;
        }

        @keyframes brandPatternMove {
            0% { transform: translate(0, 0); }
            100% { transform: translate(-40px, -40px); }
        }

        .brand-logo {
            position: relative;
            z-index: 2;
            margin-bottom: 2rem;
        }

        .brand-icon {
            width: 80px;
            height: 80px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 1.5rem;
            animation: logoFloat 3s ease-in-out infinite;
        }

        @keyframes logoFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .brand-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            position: relative;
            z-index: 2;
        }

        .brand-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-bottom: 2rem;
            position: relative;
            z-index: 2;
        }

        .brand-benefits {
            position: relative;
            z-index: 2;
            text-align: left;
        }

        .benefit-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
            font-size: 0.95rem;
            opacity: 0.9;
        }

        .benefit-icon {
            width: 35px;
            height: 35px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
        }

        /* Right Side - Registration Form */
        .register-form-section {
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .form-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }

        .form-subtitle {
            color: #6b7280;
            font-size: 1rem;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
            animation: alertSlide 0.5s ease-out;
        }

        .alert-error {
            background: linear-gradient(135deg, #fef2f2, #fee2e2);
            color: #dc2626;
            border-left: 4px solid #dc2626;
        }

        .alert-success {
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            color: #059669;
            border-left: 4px solid #059669;
        }

        @keyframes alertSlide {
            0% {
                opacity: 0;
                transform: translateY(-10px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Form Elements */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 600;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #059669;
            font-size: 1rem;
            z-index: 2;
        }

        .form-input {
            width: 100%;
            padding: 0.875rem 0.875rem 0.875rem 2.75rem;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background: #f9fafb;
            color: #1f2937;
        }

        .form-input:focus {
            outline: none;
            border-color: #059669;
            background: white;
            box-shadow: 0 0 0 3px rgba(5, 150, 105, 0.1);
            transform: translateY(-1px);
        }

        .form-input::placeholder {
            color: #9ca3af;
            font-size: 0.9rem;
        }

        .password-toggle {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6b7280;
            cursor: pointer;
            font-size: 0.95rem;
            z-index: 3;
            transition: color 0.3s ease;
        }

        .password-toggle:hover {
            color: #059669;
        }

        /* Password Strength Indicator */
        .password-strength {
            margin-top: 0.5rem;
            display: none;
        }

        .strength-bar {
            height: 4px;
            background: #e5e7eb;
            border-radius: 2px;
            overflow: hidden;
            margin-bottom: 0.5rem;
        }

        .strength-fill {
            height: 100%;
            width: 0%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .strength-text {
            font-size: 0.8rem;
            color: #6b7280;
        }

        .strength-weak .strength-fill { background: #dc2626; width: 25%; }
        .strength-fair .strength-fill { background: #f59e0b; width: 50%; }
        .strength-good .strength-fill { background: #3b82f6; width: 75%; }
        .strength-strong .strength-fill { background: #059669; width: 100%; }

        /* Submit Button */
        .submit-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #059669, #10b981);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 1rem;
            position: relative;
            overflow: hidden;
        }

        .submit-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.6s ease;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(5, 150, 105, 0.3);
        }

        .submit-btn:hover::before {
            left: 100%;
        }

        .submit-btn:active {
            transform: translateY(0);
        }

        .submit-btn.loading {
            color: transparent;
            pointer-events: none;
        }

        .submit-btn.loading::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 20px;
            height: 20px;
            border: 2px solid rgba(255,255,255,0.3);
            border-top: 2px solid white;
            border-radius: 50%;
            animation: buttonSpin 1s linear infinite;
        }

        @keyframes buttonSpin {
            0% { transform: translate(-50%, -50%) rotate(0deg); }
            100% { transform: translate(-50%, -50%) rotate(360deg); }
        }

        /* Login Link */
        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e5e7eb;
            color: #6b7280;
            font-size: 0.9rem;
        }

        .login-link a {
            color: #059669;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        .login-link a:hover {
            color: #047857;
        }

        /* Footer */
        .register-footer {
            text-align: center;
            margin-top: 1rem;
            color: #6b7280;
            font-size: 0.8rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .register-container {
                grid-template-columns: 1fr;
                max-width: 450px;
            }

            .register-branding {
                padding: 2rem;
                min-height: 300px;
            }

            .brand-title {
                font-size: 2rem;
            }

            .register-form-section {
                padding: 2rem 1.5rem;
            }

            .form-title {
                font-size: 1.75rem;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .brand-benefits {
                display: none;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 10px;
            }

            .register-container {
                border-radius: 16px;
            }

            .register-branding {
                padding: 1.5rem;
            }

            .register-form-section {
                padding: 1.5rem 1rem;
            }
        }

        /* Accessibility */
        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>
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

    <script>
        // Password toggle functionality
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const toggleIcon = document.getElementById('passwordToggleIcon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                toggleIcon.className = 'fas fa-eye-slash';
            } else {
                passwordField.type = 'password';
                toggleIcon.className = 'fas fa-eye';
            }
        }

        // Password strength checker
        function checkPasswordStrength(password) {
            const strengthIndicator = document.getElementById('passwordStrength');
            const strengthFill = document.getElementById('strengthFill');
            const strengthText = document.getElementById('strengthText');
            
            if (password.length === 0) {
                strengthIndicator.style.display = 'none';
                return;
            }
            
            strengthIndicator.style.display = 'block';
            
            let score = 0;
            let feedback = '';
            
            // Length check
            if (password.length >= 8) score++;
            if (password.length >= 12) score++;
            
            // Character variety checks
            if (/[a-z]/.test(password)) score++;
            if (/[A-Z]/.test(password)) score++;
            if (/[0-9]/.test(password)) score++;
            if (/[^A-Za-z0-9]/.test(password)) score++;
            
            // Remove all strength classes
            strengthIndicator.className = 'password-strength';
            
            if (score < 3) {
                strengthIndicator.classList.add('strength-weak');
                feedback = 'Weak - Add more characters and variety';
            } else if (score < 4) {
                strengthIndicator.classList.add('strength-fair');
                feedback = 'Fair - Consider adding special characters';
            } else if (score < 6) {
                strengthIndicator.classList.add('strength-good');
                feedback = 'Good - Strong password!';
            } else {
                strengthIndicator.classList.add('strength-strong');
                feedback = 'Excellent - Very secure password!';
            }
            
            strengthText.textContent = feedback;
        }

        // Form submission with loading animation
        document.getElementById('registrationForm').addEventListener('submit', function() {
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.classList.add('loading');
            submitBtn.disabled = true;
        });

        // Input field enhancements
        document.querySelectorAll('.form-input').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'scale(1.02)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'scale(1)';
            });
            
            // Real-time validation feedback
            input.addEventListener('input', function() {
                if (this.checkValidity()) {
                    this.style.borderColor = '#059669';
                } else {
                    this.style.borderColor = '#e5e7eb';
                }
            });
        });

        // Password strength monitoring
        document.getElementById('password').addEventListener('input', function() {
            checkPasswordStrength(this.value);
        });

        // Username availability checker (visual feedback)
        document.getElementById('username').addEventListener('blur', function() {
            const username = this.value.trim();
            if (username.length >= 3) {
                // Simulate username check (you can implement real check via AJAX)
                setTimeout(() => {
                    this.style.borderColor = '#059669';
                    showToast('Username looks good!', 'success');
                }, 500);
            }
        });

        // Email validation
        document.getElementById('email').addEventListener('blur', function() {
            const email = this.value.trim();
            if (email && this.checkValidity()) {
                this.style.borderColor = '#059669';
            }
        });

        // Toast notification system
        function showToast(message, type = 'info') {
            const toast = document.createElement('div');
            toast.textContent = message;
            
            const colors = {
                success: '#059669',
                error: '#dc2626',
                info: '#3b82f6'
            };
            
            toast.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: ${colors[type]};
                color: white;
                padding: 12px 20px;
                border-radius: 8px;
                font-size: 14px;
                z-index: 10000;
                animation: slideInToast 0.3s ease;
            `;
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.style.animation = 'slideOutToast 0.3s ease forwards';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        // Add toast animations
        const toastStyle = document.createElement('style');
        toastStyle.textContent = `
            @keyframes slideInToast {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOutToast {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(toastStyle);

        // Auto-hide alerts
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-10px)';
                setTimeout(() => alert.remove(), 300);
            });
        }, 5000);

        // Form validation before submit
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const username = document.getElementById('username').value;
            const fullName = document.getElementById('fullName').value;
            
            if (password.length < 6) {
                e.preventDefault();
                showToast('Password must be at least 6 characters long', 'error');
                return;
            }
            
            if (username.length < 3) {
                e.preventDefault();
                showToast('Username must be at least 3 characters long', 'error');
                return;
            }
            
            if (fullName.trim().length < 2) {
                e.preventDefault();
                showToast('Please enter your full name', 'error');
                return;
            }
        });

        // Add ripple effect to button
        document.querySelector('.submit-btn').addEventListener('click', function(e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;
            
            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.classList.add('ripple');
            
            this.appendChild(ripple);
            
            setTimeout(() => {
                ripple.remove();
            }, 600);
        });

        // Add ripple CSS
        const rippleStyle = document.createElement('style');
        rippleStyle.textContentrippleStyle.textContent = `
           .ripple {
               position: absolute;
               border-radius: 50%;
               background: rgba(255, 255, 255, 0.3);
               transform: scale(0);
               animation: rippleEffect 0.6s linear;
               pointer-events: none;
           }
           
           @keyframes rippleEffect {
               to {
                   transform: scale(2);
                   opacity: 0;
               }
           }
       `;
       document.head.appendChild(rippleStyle);

       // Keyboard shortcuts
       document.addEventListener('keydown', function(e) {
           // Escape to clear form
           if (e.key === 'Escape') {
               if (confirm('Clear all form data?')) {
                   document.getElementById('registrationForm').reset();
                   document.getElementById('passwordStrength').style.display = 'none';
                   showToast('Form cleared', 'info');
               }
           }
       });

       // Auto-format inputs
       document.getElementById('fullName').addEventListener('input', function() {
           // Capitalize first letter of each word
           this.value = this.value.replace(/\b\w/g, char => char.toUpperCase());
       });

       // Username input formatting
       document.getElementById('username').addEventListener('input', function() {
           // Remove spaces and special characters except underscore and dash
           this.value = this.value.toLowerCase().replace(/[^a-z0-9_-]/g, '');
       });

       // Enhanced form interactions
       document.querySelectorAll('.form-input').forEach((input, index) => {
           // Tab navigation enhancement
           input.addEventListener('keydown', function(e) {
               if (e.key === 'Enter') {
                   e.preventDefault();
                   const inputs = document.querySelectorAll('.form-input');
                   const nextInput = inputs[index + 1];
                   if (nextInput) {
                       nextInput.focus();
                   } else {
                       document.getElementById('submitBtn').focus();
                   }
               }
           });
       });

       // Progressive form completion indicator
       function updateFormProgress() {
           const inputs = document.querySelectorAll('.form-input[required]');
           let completed = 0;
           
           inputs.forEach(input => {
               if (input.value.trim() !== '' && input.checkValidity()) {
                   completed++;
               }
           });
           
           const progress = (completed / inputs.length) * 100;
           
           // You can add a progress bar if needed
           if (progress === 100) {
               document.getElementById('submitBtn').style.background = 
                   'linear-gradient(135deg, #047857, #059669)';
           } else {
               document.getElementById('submitBtn').style.background = 
                   'linear-gradient(135deg, #059669, #10b981)';
           }
       }

       // Monitor form completion
       document.querySelectorAll('.form-input').forEach(input => {
           input.addEventListener('input', updateFormProgress);
           input.addEventListener('blur', updateFormProgress);
       });

       // Initialize form on page load
       document.addEventListener('DOMContentLoaded', function() {
           // Focus first input
           document.getElementById('username').focus();
           
           // Initialize progress
           updateFormProgress();
       });

       // Smooth scroll to alerts
       function scrollToAlert() {
           const alert = document.querySelector('.alert');
           if (alert) {
               alert.scrollIntoView({ behavior: 'smooth', block: 'center' });
           }
       }

       // Call on page load if there are alerts
       if (document.querySelector('.alert')) {
           setTimeout(scrollToAlert, 100);
       }
   </script>
</body>
</html>