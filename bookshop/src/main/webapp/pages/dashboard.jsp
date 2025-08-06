<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookstore Management System - Perera Co.</title>
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
            color: #1f2937;
            line-height: 1.6;
        }

        /* Header */
        .header {
            background: white;
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.08);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            backdrop-filter: blur(10px);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: #059669;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #059669, #10b981);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            list-style: none;
        }

        .nav-links a {
            text-decoration: none;
            color: #6b7280;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            transition: all 0.3s ease;
            position: relative;
        }

        .nav-links a.active,
        .nav-links a:hover {
            color: #059669;
            background: rgba(5, 150, 105, 0.1);
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 0.5rem 1rem;
            background: #f3f4f6;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .user-profile:hover {
            background: #e5e7eb;
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, #059669, #10b981);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.9rem;
        }

        /* Main Content */
        .main-content {
            margin-top: 80px;
            padding: 3rem 0;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        /* Hero Section */
        .hero-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
            margin-bottom: 6rem;
        }

        .hero-content h1 {
            font-family: 'Playfair Display', serif;
            font-size: 3.5rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }

        .hero-content .highlight {
            color: #059669;
            position: relative;
        }

        .hero-content .highlight::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(90deg, #059669, #10b981);
            border-radius: 2px;
        }

        .hero-description {
            font-size: 1.2rem;
            color: #6b7280;
            margin-bottom: 2.5rem;
            line-height: 1.7;
        }

        .cta-buttons {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .btn {
            padding: 1rem 2rem;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            border: none;
            font-size: 1rem;
        }

        .btn-primary {
            background: linear-gradient(135deg, #059669, #10b981);
            color: white;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(5, 150, 105, 0.4);
        }

        .btn-secondary {
            background: white;
            color: #059669;
            border: 2px solid #059669;
        }

        .btn-secondary:hover {
            background: #059669;
            color: white;
            transform: translateY(-2px);
        }

        /* Hero Image */
        .hero-image {
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
        }

        .hero-image img {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }

        .image-overlay {
            position: absolute;
            bottom: 2rem;
            left: 2rem;
            right: 2rem;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            padding: 1.5rem;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .overlay-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }

        .overlay-stats {
            display: flex;
            gap: 1.5rem;
            font-size: 0.9rem;
            color: #6b7280;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .stat-icon {
            color: #059669;
        }

        /* Company Info Section */
        .company-section {
            background: white;
            border-radius: 20px;
            padding: 3rem;
            margin: 4rem 0;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            border: 1px solid #f1f5f9;
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 600;
            text-align: center;
            color: #1f2937;
            margin-bottom: 3rem;
            position: relative;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: linear-gradient(90deg, #059669, #10b981);
            border-radius: 2px;
        }

        .company-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .info-card {
            background: linear-gradient(135deg, #f8fffe 0%, #f0fdf4 100%);
            padding: 2rem;
            border-radius: 15px;
            border-left: 4px solid #059669;
            transition: transform 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
        }

        .info-card-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #059669, #10b981);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .info-card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }

        .info-card p {
            color: #6b7280;
            font-size: 0.95rem;
        }

        /* Features Section */
        .features-section {
            margin: 6rem 0;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .feature-card {
            background: white;
            padding: 2.5rem;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border: 1px solid #f1f5f9;
            position: relative;
            overflow: hidden;
        }

        .feature-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #059669, #10b981);
        }

        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #f0fdf4, #dcfce7);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #059669;
            font-size: 1.8rem;
            margin-bottom: 1.5rem;
        }

        .feature-card h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 1rem;
        }

        .feature-card p {
            color: #6b7280;
            line-height: 1.7;
        }

        /* Footer */
        .footer {
            background: #1f2937;
            color: white;
            padding: 3rem 0 2rem;
            margin-top: 6rem;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            text-align: center;
        }

        .footer-logo {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: #10b981;
        }

        .footer-text {
            color: #9ca3af;
            margin-bottom: 2rem;
        }

        .footer-bottom {
            border-top: 1px solid #374151;
            padding-top: 2rem;
            color: #6b7280;
            font-size: 0.9rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .nav-container {
                padding: 1rem;
            }

            .nav-links {
                display: none;
            }

            .hero-section {
                grid-template-columns: 1fr;
                gap: 2rem;
                text-align: center;
            }

            .hero-content h1 {
                font-size: 2.5rem;
            }

            .cta-buttons {
                justify-content: center;
                flex-wrap: wrap;
            }

            .company-section {
                padding: 2rem 1.5rem;
            }

            .section-title {
                font-size: 2rem;
            }

            .company-info-grid {
                grid-template-columns: 1fr;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in-up {
            animation: fadeInUp 0.8s ease forwards;
        }

        .delay-1 { animation-delay: 0.2s; }
        .delay-2 { animation-delay: 0.4s; }
        .delay-3 { animation-delay: 0.6s; }
        .delay-4 { animation-delay: 0.8s; }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <nav class="nav-container">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-book-reader"></i>
                </div>
                Perera Bookstore
            </div>
            
            <ul class="nav-links">
                <li><a href="#" class="active">Home</a></li>
                <li><a href="#about">About</a></li>
                <li><a href="#features">Features</a></li>
                <li><a href="#contact">Contact</a></li>
            </ul>
            
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="user-profile">
                        <div class="user-avatar">
                            <i class="fas fa-user"></i>
                        </div>
                        <span>${sessionScope.user.username}</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="user-profile">
                        <div class="user-avatar">
                            <i class="fas fa-user-circle"></i>
                        </div>
                        <span>Guest User</span>
                    </div>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <!-- Hero Section -->
            <section class="hero-section">
                <div class="hero-content fade-in-up">
                    <h1>Welcome to <span class="highlight">Bookstore</span> Management System</h1>
                    <p class="hero-description">
                        Your comprehensive solution for managing bookstore operations with advanced inventory control, 
                        customer management, and intelligent billing systems. Experience seamless book retail management 
                        with our cutting-edge technology platform.
                    </p>
                    
                    <div class="cta-buttons">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                                    <i class="fas fa-tachometer-alt"></i> Go to Dashboard
                                </a>
                                <a href="${pageContext.request.contextPath}/login?action=logout" class="btn btn-secondary">
                                    <i class="fas fa-sign-out-alt"></i> Logout
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                                    <i class="fas fa-sign-in-alt"></i> Login to System
                                </a>
                                <a href="#features" class="btn btn-secondary">
                                    <i class="fas fa-eye"></i> View Features
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="hero-image fade-in-up delay-2">
                    <img src="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 600 400'><defs><linearGradient id='bookshelf' x1='0%25' y1='0%25' x2='100%25' y2='100%25'><stop offset='0%25' style='stop-color:%23f0fdf4'/><stop offset='100%25' style='stop-color:%23dcfce7'/></linearGradient></defs><rect width='600' height='400' fill='url(%23bookshelf)'/><rect x='50' y='50' width='500' height='300' fill='%23374151' rx='10'/><rect x='70' y='80' width='460' height='40' fill='%23059669'/><rect x='80' y='90' width='20' height='20' fill='%23ef4444'/><rect x='110' y='90' width='20' height='20' fill='%23f59e0b'/><rect x='140' y='90' width='20' height='20' fill='%233b82f6'/><rect x='170' y='90' width='20' height='20' fill='%23059669'/><rect x='200' y='90' width='20' height='20' fill='%23dc2626'/><rect x='230' y='90' width='20' height='20' fill='%236366f1'/><rect x='80' y='140' width='20' height='20' fill='%23059669'/><rect x='110' y='140' width='20' height='20' fill='%23f59e0b'/><rect x='140' y='140' width='20' height='20' fill='%23ef4444'/><rect x='170' y='140' width='20' height='20' fill='%233b82f6'/><rect x='200' y='140' width='20' height='20' fill='%236366f1'/><rect x='230' y='140' width='20' height='20' fill='%23dc2626'/><text x='300' y='220' font-family='Inter' font-size='24' font-weight='600' fill='%23059669' text-anchor='middle'>BOOKSTORE</text><text x='300' y='250' font-family='Inter' font-size='16' fill='%236b7280' text-anchor='middle'>Management System</text><rect x='80' y='280' width='440' height='2' fill='%23059669'/><circle cx='150' cy='320' r='8' fill='%23059669'/><circle cx='300' cy='320' r='8' fill='%23059669'/><circle cx='450' cy='320' r='8' fill='%23059669'/></svg>" alt="Bookstore Management System">
                    
                    <div class="image-overlay">
                        <h3 class="overlay-title">Perera Co. - Leading Bookshop</h3>
                        <div class="overlay-stats">
                            <div class="stat-item">
                                <i class="fas fa-map-marker-alt stat-icon"></i>
                                <span>Colombo City</span>
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-users stat-icon"></i>
                                <span>500+ Customers</span>
                            </div>
                            <div class="stat-item">
                                <i class="fas fa-calendar stat-icon"></i>
                                <span>Since 1995</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Company Info Section -->
            <section class="company-section fade-in-up delay-3" id="about">
                <h2 class="section-title">Why Choose Perera Bookstore</h2>
                
                <div class="company-info-grid">
                    <div class="info-card">
                        <div class="info-card-icon">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <h3>Prime Location</h3>
                        <p>Strategically located in the heart of Colombo City, Sri Lanka, serving the literary community with easy accessibility.</p>
                    </div>
                    
                    <div class="info-card">
                        <div class="info-card-icon">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h3>Vast Collection</h3>
                        <p>Comprehensive inventory featuring books, educational materials, and stationery to meet all your reading and learning needs.</p>
                    </div>
                    
                    <div class="info-card">
                        <div class="info-card-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3>Trusted Service</h3>
                        <p>Proudly serving hundreds of satisfied customers each month with personalized service and expert recommendations.</p>
                    </div>
                </div>
            </section>

            <!-- Features Section -->
            <section class="features-section fade-in-up delay-4" id="features">
                <h2 class="section-title">Advanced Management Features</h2>
                
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-users-cog"></i>
                        </div>
                        <h3>Customer Management</h3>
                        <p>Comprehensive customer database with detailed profiles, purchase history, loyalty tracking, and personalized service capabilities for enhanced customer relationships.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-warehouse"></i>
                        </div>
                        <h3>Smart Inventory</h3>
                        <p>Real-time inventory tracking, automated stock alerts, barcode integration, and comprehensive catalog management with supplier coordination.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-receipt"></i>
                        </div>
                        <h3>Intelligent Billing</h3>
                        <p>Advanced billing system with automatic tax calculations, discount management, multiple payment options, and professional invoice generation.</p>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-logo">
                <i class="fas fa-book-reader"></i> Perera Bookstore
            </div>
            <p class="footer-text">
                Empowering bookstore operations with innovative management solutions since 1995
            </p>
            <div class="footer-bottom">
                <p>&copy; 2025 Perera Co. Bookstore Management System | All rights reserved | Version 2.0</p>
            </div>
        </div>
    </footer>

    <script>
        // Smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe all fade-in-up elements
        document.querySelectorAll('.fade-in-up').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(30px)';
            observer.observe(el);
        });

        // Add scroll effect to header
        window.addEventListener('scroll', () => {
            const header = document.querySelector('.header');
            if (window.scrollY > 100) {
                header.style.background = 'rgba(255, 255, 255, 0.95)';
            } else {
                header.style.background = 'white';
            }
        });

        // Button click effects
        document.querySelectorAll('.btn').forEach(button => {
            button.addEventListener('click', function(e) {
                // Create ripple effect
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
        });

        // Add ripple CSS
        const style = document.createElement('style');
        style.textContent = `
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
        document.head.appendChild(style);
    </script>
</body>
</html>