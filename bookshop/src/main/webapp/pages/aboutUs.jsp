<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Pahana Edu Book Shop</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        /* Base Styles - Same as Dashboard */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: 'Inter', sans-serif; 
            background: #f9fafb; 
            line-height: 1.6;
            color: #333;
        }

        /* Header Styles - Consistent with Dashboard */
        .header {
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
            padding: 1rem 2rem;
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            align-items: center;
            transition: all 0.3s ease;
        }

        .header.shrink {
            padding: 0.75rem 2rem;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            backdrop-filter: blur(10px);
        }

        /* Logo Styles - Same as Dashboard */
        .header .logo { 
            font-family: 'Playfair Display', serif; 
            font-size: 1.8rem; 
            font-weight: 700; 
            color: #059669; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
            text-decoration: none;
            transition: transform 0.3s ease;
        }

        .header.shrink .logo {
            transform: scale(0.9);
        }

        /* Navigation Center */
        .nav-center {
            text-align: center;
        }

        .nav-link {
            color: #374151;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 8px 16px;
            border-radius: 8px;
        }

        .nav-link:hover {
            color: #059669;
            background: rgba(5, 150, 105, 0.1);
            transform: translateY(-1px);
        }

        /* Back Button */
        .back-btn {
            justify-self: end;
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.3);
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(5, 150, 105, 0.4);
        }

        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        /* Hero Section */
        .hero-section {
            padding: 3rem 0;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            margin-bottom: 0;
        }

        .hero-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            align-items: center;
        }

        .hero-text h1 {
            font-family: 'Playfair Display', serif;
            font-size: 3.2rem;
            color: #1f2937;
            margin-bottom: 1.5rem;
            line-height: 1.2;
        }

        .hero-text p {
            font-size: 1.1rem;
            color: #6b7280;
            margin-bottom: 1.5rem;
            line-height: 1.7;
        }

        .hero-image {
            text-align: center;
        }

        .hero-image img,
        .image-placeholder {
            max-width: 100%;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            transition: transform 0.3s ease;
        }

        .hero-image img:hover,
        .image-placeholder:hover {
            transform: scale(1.02);
        }

        /* Section Styling */
        .section {
            padding: 4rem 0;
        }

        .section:nth-child(even) {
            background: white;
        }

        .section:nth-child(odd) {
            background: linear-gradient(45deg, #f8fffe 0%, #f0fdf4 100%);
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            text-align: center;
            margin-bottom: 3rem;
            color: #111827;
            position: relative;
        }

        .section-title::after {
            content: '';
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            border-radius: 2px;
        }

        /* Stats Grid - Same style as Dashboard book cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .stat-card {
            background: #fff;
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
            border: 1px solid #f1f5f9;
            transition: all 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            color: #059669;
            margin-bottom: 0.5rem;
            font-family: 'Playfair Display', serif;
        }

        .stat-label {
            font-size: 1.1rem;
            color: #374151;
            font-weight: 600;
        }

        /* Story Content */
        .story-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            align-items: center;
        }

        .story-text h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            color: #1f2937;
            margin-bottom: 1.5rem;
            font-weight: 600;
        }

        .story-text p {
            font-size: 1.1rem;
            color: #6b7280;
            margin-bottom: 1.5rem;
            line-height: 1.7;
        }

        /* Team Grid - Similar to book cards */
        .team-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .team-card {
            background: #fff;
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
            border: 1px solid #f1f5f9;
            transition: all 0.3s ease;
            overflow: hidden;
        }

        .team-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .team-photo {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            margin: 0 auto 1.5rem;
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            border: 4px solid #a7f3d0;
            transition: transform 0.3s ease;
        }

        .team-card:hover .team-photo {
            transform: scale(1.1);
        }

        .team-photo img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }

        .team-name {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0.5rem;
        }

        .team-role {
            font-size: 1rem;
            color: #059669;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .team-bio {
            font-size: 0.9rem;
            color: #6b7280;
            line-height: 1.6;
        }

        /* Values Grid */
        .values-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .value-card {
            background: #fff;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
            border: 1px solid #f1f5f9;
            border-left: 5px solid #059669;
            transition: all 0.3s ease;
        }

        .value-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .value-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #059669;
        }

        .value-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 1rem;
        }

        .value-description {
            color: #6b7280;
            line-height: 1.6;
        }

        /* Gallery Grid */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .gallery-item {
            position: relative;
            overflow: hidden;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            background: #fff;
        }

        .gallery-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .gallery-item img,
        .gallery-placeholder {
            width: 100%;
            height: 250px;
            object-fit: cover;
            border-radius: 20px 20px 0 0;
        }

        .gallery-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.8));
            color: white;
            padding: 2rem;
            transform: translateY(100%);
            transition: transform 0.3s ease;
        }

        .gallery-item:hover .gallery-overlay {
            transform: translateY(0);
        }

        .gallery-overlay h3 {
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        /* Contact Section */
        .contact-section {
            background: linear-gradient(135deg, #1f2937 0%, #111827 100%);
            color: white;
            text-align: center;
        }

        .contact-content {
            max-width: 600px;
            margin: 0 auto;
        }

        .contact-section h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            margin-bottom: 1.5rem;
            color: white;
        }

        .contact-section p {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }

        .contact-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .contact-item {
            padding: 2rem;
            background: rgba(255,255,255,0.1);
            border-radius: 20px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.3s ease;
        }

        .contact-item:hover {
            transform: translateY(-5px);
            background: rgba(255,255,255,0.15);
        }

        .contact-icon {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #a7f3d0;
        }

        .contact-label {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #a7f3d0;
        }

        /* Footer - Same as Dashboard */
        .footer {
            text-align: center;
            padding: 3rem 2rem;
            background: linear-gradient(135deg, #1f2937 0%, #111827 100%);
            color: #d1d5db;
            font-size: 0.95rem;
        }

        /* Image Placeholder Styling */
        .image-placeholder,
        .gallery-placeholder {
            background: linear-gradient(45deg, #f0fdf4, #a7f3d0);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #059669;
            font-weight: 600;
            font-size: 1.1rem;
            text-align: center;
            border-radius: 20px;
            border: 2px dashed #059669;
            min-height: 250px;
        }

        /* Animation Classes */
        .fade-in {
            animation: fadeInUp 0.6s ease-out;
        }

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

        /* Responsive Design - Same breakpoints as Dashboard */
        @media (max-width: 768px) {
            .hero-content,
            .story-content {
                grid-template-columns: 1fr;
                gap: 2rem;
            }

            .hero-text h1 {
                font-size: 2.5rem;
                text-align: center;
            }

            .section-title {
                font-size: 2rem;
            }

            .container {
                padding: 0 1rem;
            }

            .header {
                padding: 1rem;
                grid-template-columns: auto 1fr auto;
                gap: 1rem;
            }

            .stats-grid,
            .team-grid,
            .values-grid,
            .gallery-grid {
                grid-template-columns: 1fr;
            }

            .contact-info {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 0.75rem;
            }

            .header .logo {
                font-size: 1.5rem;
            }

            .hero-text h1 {
                font-size: 2rem;
            }

            .section {
                padding: 3rem 0;
            }
        }
    </style>
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
                    <!-- Replace this div with: <img src="images/bookstore-front.jpg" alt="Pahana Edu Book Shop Front"> -->
                    <div class="image-placeholder">
                        <div>
                            <i class="fas fa-store" style="font-size: 3rem; margin-bottom: 1rem; display: block;"></i>
                            📖 Add bookstore front image here<br>
                            <small>(images/bookstore-front.jpg)</small>
                        </div>
                    </div>
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
                    <!-- Replace this div with: <img src="images/founder-story.jpg" alt="Our Founder's Story"> -->
                    <div class="image-placeholder">
                        <div>
                            <i class="fas fa-user-tie" style="font-size: 3rem; margin-bottom: 1rem; display: block;"></i>
                            👨‍💼 Add founder/story image here<br>
                            <small>(images/founder-story.jpg)</small>
                        </div>
                    </div>
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

    <!-- Team Section -->
    <section class="section" id="team">
        <div class="container">
            <h2 class="section-title">Meet Our Team</h2>
            <div class="team-grid">
                <div class="team-card">
                    <div class="team-photo">
                        <!-- Replace with: <img src="images/team-manager.jpg" alt="Store Manager"> -->
                        <i class="fas fa-user-tie"></i>
                    </div>
                    <div class="team-name">Sarah Johnson</div>
                    <div class="team-role">Store Manager</div>
                    <div class="team-bio">With 8 years of experience in educational retail, Sarah ensures our customers find exactly what they need for their learning journey.</div>
                </div>
                <div class="team-card">
                    <div class="team-photo">
                        <!-- Replace with: <img src="images/team-coordinator.jpg" alt="Education Coordinator"> -->
                        <i class="fas fa-graduation-cap"></i>
                    </div>
                    <div class="team-name">Michael Chen</div>
                    <div class="team-role">Education Coordinator</div>
                    <div class="team-bio">Michael works closely with schools and educators to curate our collection and provide expert recommendations.</div>
                </div>
                <div class="team-card">
                    <div class="team-photo">
                        <!-- Replace with: <img src="images/team-specialist.jpg" alt="Customer Service Specialist"> -->
                        <i class="fas fa-headset"></i>
                    </div>
                    <div class="team-name">Emily Rodriguez</div>
                    <div class="team-role">Customer Service Specialist</div>
                    <div class="team-bio">Emily is dedicated to providing exceptional customer service and helping families find the perfect educational resources.</div>
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

    <!-- Gallery Section -->
    <section class="section" id="gallery">
        <div class="container">
            <h2 class="section-title">Our Store Gallery</h2>
            <div class="gallery-grid">
                <div class="gallery-item">
                    <!-- Replace with: <img src="images/store-interior-1.jpg" alt="Store Interior"> -->
                    <div class="gallery-placeholder">
                        <div>
                            <i class="fas fa-store" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                            Store Interior 1<br>
                            <small>(images/store-interior-1.jpg)</small>
                        </div>
                    </div>
                    <div class="gallery-overlay">
                        <h3>Spacious Learning Environment</h3>
                        <p>Our comfortable browsing areas make book shopping a pleasure</p>
                    </div>
                </div>
                <div class="gallery-item">
                    <!-- Replace with: <img src="images/book-collection.jpg" alt="Book Collection"> -->
                    <div class="gallery-placeholder">
                        <div>
                            <i class="fas fa-books" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                            Book Collection<br>
                            <small>(images/book-collection.jpg)</small>
                        </div>
                    </div>
                    <div class="gallery-overlay">
                        <h3>Extensive Collection</h3>
                        <p>From textbooks to reference materials, we have it all</p>
                    </div>
                </div>
                <div class="gallery-item">
                    <!-- Replace with: <img src="images/customer-service.jpg" alt="Customer Service"> -->
                    <div class="gallery-placeholder">
                        <div>
                            <i class="fas fa-handshake" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                            Customer Service<br>
                            <small>(images/customer-service.jpg)</small>
                        </div>
                    </div>
                    <div class="gallery-overlay">
                        <h3>Expert Assistance</h3>
                        <p>Our knowledgeable staff is always ready to help</p>
                    </div>
                </div>
                <div class="gallery-item">
                    <!-- Replace with: <img src="images/study-area.jpg" alt="Study Area"> -->
                    <div class="gallery-placeholder">
                        <div>
                            <i class="fas fa-book-open" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                            Reading Area<br>
                            <small>(images/study-area.jpg)</small>
                        </div>
                    </div>
                    <div class="gallery-overlay">
                        <h3>Quiet Study Space</h3>
                        <p>A perfect place to preview books and study</p>
                    </div>
                </div>
                <div class="gallery-item">
                    <!-- Replace with: <img src="images/events.jpg" alt="Educational Events"> -->
                    <div class="gallery-placeholder">
                        <div>
                            <i class="fas fa-calendar-alt" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                            Educational Events<br>
                            <small>(images/events.jpg)</small>
                        </div>
                    </div>
                    <div class="gallery-overlay">
                        <h3>Community Events</h3>
                        <p>Regular workshops and educational seminars</p>
                    </div>
                </div>
                <div class="gallery-item">
                    <!-- Replace with: <img src="images/digital-resources.jpg" alt="Digital Resources"> -->
                    <div class="gallery-placeholder">
                        <div>
                            <i class="fas fa-laptop" style="font-size: 2rem; margin-bottom: 0.5rem; display: block;"></i>
                            Digital Resources<br>
                            <small>(images/digital-resources.jpg)</small>
                        </div>
                    </div>
                    <div class="gallery-overlay">
                        <h3>Digital Integration</h3>
                        <p>Modern learning tools and e-resources available</p>
                    </div>
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

    <script>
        // Smooth scrolling for navigation links - Same as Dashboard
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

        // Header shrinking effect on scroll - Same as Dashboard
        document.addEventListener("scroll", function() {
            const header = document.querySelector(".header");
            
            if (window.scrollY > 50) {
                header.classList.add("shrink");
            } else {
                header.classList.remove("shrink");
            }
        });

        // Add fade-in animation on scroll - Same as Dashboard
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in');
                }
            });
        }, observerOptions);

        // Observe all sections for animation
        document.querySelectorAll('.section').forEach(section => {
            observer.observe(section);
        });

        // Add interactive hover effects - Enhanced from Dashboard
        document.querySelectorAll('.stat-card, .team-card, .value-card, .gallery-item, .contact-item').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-10px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });

        // Counter animation for stats - Same as Dashboard book loading feel
        function animateCounters() {
            const counters = document.querySelectorAll('.stat-number');
            counters.forEach(counter => {
                const target = parseInt(counter.textContent.replace(/[^0-9]/g, ''));
                const suffix = counter.textContent.replace(/[0-9]/g, '');
                let current = 0;
                const increment = target / 50;
                
                const updateCounter = () => {
                    if (current < target) {
                        current += increment;
                        counter.textContent = Math.floor(current) + suffix;
                        requestAnimationFrame(updateCounter);
                    } else {
                        counter.textContent = target + suffix;
                    }
                };
                
                updateCounter();
            });
        }

        // Trigger counter animation when stats section is visible
        const statsObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateCounters();
                    statsObserver.unobserve(entry.target);
                }
            });
        });

        const statsSection = document.querySelector('.stats-grid');
        if (statsSection) {
            statsObserver.observe(statsSection);
        }

        // Add staggered animation for cards
        function staggerAnimation(selector, delay = 100) {
            const elements = document.querySelectorAll(selector);
            elements.forEach((element, index) => {
                setTimeout(() => {
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * delay);
            });
        }

        // Initialize staggered animations
        document.addEventListener('DOMContentLoaded', function() {
            // Set initial state for staggered elements
            const staggerElements = document.querySelectorAll('.stat-card, .team-card, .value-card, .gallery-item');
            staggerElements.forEach(element => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                element.style.transition = 'all 0.6s ease';
            });

            // Trigger animations when sections come into view
            const sectionObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const section = entry.target;
                        if (section.querySelector('.stat-card')) {
                            staggerAnimation('.stat-card', 150);
                        } else if (section.querySelector('.team-card')) {
                            staggerAnimation('.team-card', 200);
                        } else if (section.querySelector('.value-card')) {
                            staggerAnimation('.value-card', 150);
                        } else if (section.querySelector('.gallery-item')) {
                            staggerAnimation('.gallery-item', 100);
                        }
                        sectionObserver.unobserve(section);
                    }
                });
            }, { threshold: 0.2 });

            // Observe sections for staggered animations
            document.querySelectorAll('.section').forEach(section => {
                sectionObserver.observe(section);
            });
        });

        // Console logging for debugging - Same style as Dashboard
        console.log('About Us page loaded successfully');
        console.log('Animations initialized');
        console.log('Dashboard-style design applied');
    </script>
</body>
</html>