
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
  