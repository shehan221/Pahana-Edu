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
     <script src="${pageContext.request.contextPath}/js/aboutUs.js"></script>
</body>
</html>