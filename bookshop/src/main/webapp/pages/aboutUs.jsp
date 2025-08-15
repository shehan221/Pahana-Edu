<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Pahana Edu Book Shop</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/aboutUs.css">
</head>
<body>

    <!-- Header - Same structure as Dashboard -->
    <header class="header">
        <!-- Logo -->
        <a href="#" class="logo">
            <i class="fas fa-book-reader"></i> Pahana Edu
        </a>

        <!-- Navigation Center -->
        <div class="nav-center">
            <a href="#about" class="nav-link">About Us</a>
        </div>

        <!-- Back Button -->
        <a href="dashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Store
        </a>
    </header>

    <!-- Hero Section -->
    <section class="hero-section" id="about">
        <div class="container">
            <div class="hero-content fade-in">
                <div class="hero-text">
                    <h1>Welcome to Pahana Edu Book Shop</h1>
                    <p>For over a decade, Pahana Edu Book Shop has been the premier destination for educational excellence in our community. We specialize in providing high-quality educational materials, textbooks, and learning resources that empower students, educators, and lifelong learners.</p>
                    <p>Our commitment goes beyond just selling books – we're passionate about fostering a love for learning and supporting educational success at every level.</p>
                </div>
                <div class="hero-image">
                    <img src="${pageContext.request.contextPath}/images/dashboard/bookshop.png" 
                         alt="Pahana Edu Book Shop Front">
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="section">
        <div class="container">
            <h2 class="section-title">Our Impact in Numbers</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-number">10+</div>
                    <div class="stat-label">Years of Service</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">50K+</div>
                    <div class="stat-label">Books Sold</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">5K+</div>
                    <div class="stat-label">Happy Students</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">200+</div>
                    <div class="stat-label">Schools Served</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Our Story Section -->
    <section class="section" id="story">
        <div class="container">
            <div class="story-content">
                <div class="story-image">
                    <img src="${pageContext.request.contextPath}/images/aboutUs/us2.jpg" 
                         alt="Our Founder's Story">
                </div>
                <div class="story-text">
                    <h2>Our Story</h2>
                    <p>Pahana Edu Book Shop was founded in 2013 with a simple yet powerful vision: to make quality educational resources accessible to everyone. What started as a small neighborhood bookstore has grown into a trusted educational hub.</p>
                    <p>Our founder, driven by a passion for education and community service, recognized the need for a dedicated space where students, teachers, and parents could find the best educational materials under one roof.</p>
                    <p>Today, we continue to honor that original mission while embracing new technologies and educational trends to serve our community better.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Values Section -->
    <section class="section" id="values">
        <div class="container">
            <h2 class="section-title">Our Core Values</h2>
            <div class="values-grid">
                <div class="value-card">
                    <div class="value-icon"><i class="fas fa-medal"></i></div>
                    <div class="value-title">Quality First</div>
                    <div class="value-description">We carefully select every book and educational material to ensure the highest quality content that truly enhances learning outcomes.</div>
                </div>
                <div class="value-card">
                    <div class="value-icon"><i class="fas fa-users"></i></div>
                    <div class="value-title">Community Focused</div>
                    <div class="value-description">We're more than a bookstore – we're a community partner committed to supporting local education and student success.</div>
                </div>
                <div class="value-card">
                    <div class="value-icon"><i class="fas fa-lightbulb"></i></div>
                    <div class="value-title">Innovation</div>
                    <div class="value-description">We embrace new educational technologies and methods while maintaining our commitment to traditional learning excellence.</div>
                </div>
                <div class="value-card">
                    <div class="value-icon"><i class="fas fa-universal-access"></i></div>
                    <div class="value-title">Accessibility</div>
                    <div class="value-description">Education should be accessible to all. We offer competitive prices and flexible solutions to meet every budget.</div>
                </div>
                <div class="value-card">
                    <div class="value-icon"><i class="fas fa-chart-line"></i></div>
                    <div class="value-title">Growth Mindset</div>
                    <div class="value-description">We believe in continuous improvement and are always evolving to better serve our educational community.</div>
                </div>
                <div class="value-card">
                    <div class="value-icon"><i class="fas fa-heart"></i></div>
                    <div class="value-title">Passion for Learning</div>
                    <div class="value-description">Our love for education drives everything we do, from book selection to customer service excellence.</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="contact-section section" id="contact">
        <div class="container">
            <div class="contact-content">
                <h2>Visit Us Today!</h2>
                <p>Ready to explore our amazing collection? We'd love to welcome you to our store and help you find the perfect educational resources.</p>
                
                <div class="contact-info">
                    <div class="contact-item">
                        <div class="contact-icon"><i class="fas fa-map-marker-alt"></i></div>
                        <div class="contact-label">Location</div>
                        <div>123 Education Street<br>Learning District<br>Your City, 12345</div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon"><i class="fas fa-phone"></i></div>
                        <div class="contact-label">Phone</div>
                        <div>(555) 123-BOOK<br>(555) 123-2665</div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon"><i class="fas fa-envelope"></i></div>
                        <div class="contact-label">Email</div>
                        <div>info@pahanaedu.com<br>orders@pahanaedu.com</div>
                    </div>
                    <div class="contact-item">
                        <div class="contact-icon"><i class="fas fa-clock"></i></div>
                        <div class="contact-label">Hours</div>
                        <div>Mon-Sat: 9AM-7PM<br>Sunday: 10AM-5PM</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer - Same as Dashboard -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Pahana Edu Book Shop | All rights reserved | Empowering Education, One Book at a Time</p>
        </div>
    </footer>
     <script src="${pageContext.request.contextPath}/js/aboutUs.js"></script>
</body>
</html>