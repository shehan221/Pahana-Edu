<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu - Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: #f9fafb;
            margin: 0;
        }

        /* Header */
        .header {
            background: #ffffff;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            position: sticky;
            top: 0;
            z-index: 999;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header .logo {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: #059669;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }

        .header .logo:hover {
            text-decoration: underline;
        }

        .header .user-info {
            font-weight: 500;
            color: #374151;
        }

        .admin-badge {
            background: #fef3c7;
            color: #92400e;
            padding: 2px 6px;
            border-radius: 10px;
            font-size: 10px;
            margin-left: 8px;
            font-weight: 600;
        }

        /* Navigation Bar */
        .navbar {
            background-color: #f2f2f2; /* Light gray background */
            padding: 12px 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); /* Subtle shadow */
        }

        .nav-links {
            display: flex;
            justify-content: center;
            gap: 30px;
        }

        .nav-links a {
            text-decoration: none;
            color: #333; /* Dark gray text */
            font-size: 16px;
            font-weight: 500;
            transition: color 0.3s ease, transform 0.3s ease;
        }

        .nav-links a:hover {
            color: #007bff; /* Smooth blue on hover */
            transform: translateY(-2px); /* Lift effect */
        }

        .main {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .hero {
            margin-top: 2rem; /* Add this line */
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            align-items: center;
            margin-bottom: 4rem;
        }

        .hero img {
            width: 100%;
            border-radius: 20px;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
        }

        .hero h1 {
            font-size: 3rem;
            font-family: 'Playfair Display', serif;
            color: #1f2937;
        }

        .hero p {
            font-size: 1.1rem;
            color: #6b7280;
            margin-top: 1rem;
        }

        .books-section {
            margin-top: 4rem;
        }

        .books-section h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            text-align: center;
            margin-bottom: 2rem;
            color: #111827;
            position: relative;
        }

        .books-section h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 3px;
            background: #059669;
        }

        .book-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }

        .book-card {
            background: #ffffff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s;
        }

        .book-card:hover {
            transform: translateY(-5px);
        }

        .book-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }

        .book-info {
            padding: 1rem;
        }

        .book-info h3 {
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
            color: #1f2937;
        }

        .book-info p {
            color: #059669;
            font-weight: 600;
        }

        footer {
            text-align: center;
            padding: 2rem;
            background: #1f2937;
            color: #d1d5db;
            margin-top: 4rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .hero {
                grid-template-columns: 1fr;
                text-align: center;
            }
            
            .hero h1 {
                font-size: 2rem;
            }
            
            .main {
                padding: 0 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Header with Role-Based Logic -->
   <c:choose>
    <c:when test="${fn:toLowerCase(sessionScope.user.role) == 'admin'}">
        <c:set var="userPageUrl" value="${pageContext.request.contextPath}/pages/profile.jsp" />
    </c:when>
    <c:otherwise>
        <c:set var="userPageUrl" value="${pageContext.request.contextPath}/pages/profile.jsp" />
    </c:otherwise>
</c:choose>

<header class="header">
    <c:choose>
        <c:when test="${fn:toLowerCase(sessionScope.user.role) == 'admin'}">
            <a href="<c:url value='/pages/adminDashboard.jsp' />" class="logo">
                <i class="fas fa-user-shield"></i> Pahana Edu Admin
            </a>
        </c:when>
        <c:otherwise>
            <a href="<c:url value='/pages/dashboard.jsp' />" class="logo">
                <i class="fas fa-book-reader"></i> Pahana Edu
            </a>
        </c:otherwise>
    </c:choose>

    <div class="user-info">
        <a href="${userPageUrl}" style="display: flex; align-items: center; gap: 12px; text-decoration: none; color: #374151;">
            <img src="<c:url value='/images/dashboard/profile.png' />" alt="User Icon" style="width: 36px; height: 36px; border-radius: 50%; object-fit: cover;">
            <span style="font-weight: 500; font-size: 14px; line-height: 1;">
                <c:out value="${sessionScope.user.username}" default="Guest" />
                <c:if test="${fn:toLowerCase(sessionScope.user.role) == 'admin'}">
                    <span class="admin-badge">
                        <i class="fas fa-shield-alt"></i> ADMIN
                    </span>
                </c:if>
            </span>
        </a>
    </div>
</header>


    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Home</a>
            <a href="#books-section">Books</a>
            <a href="#">About</a>
            <a href="feedback.jsp">feedback</a>
            <!-- Admin-specific navigation -->
            <c:if test="${sessionScope.user.role == 'admin'}">
                <a href="${pageContext.request.contextPath}/admindashboard.jsp" style="color: #f59e0b; font-weight: 600;">
                    <i class="fas fa-cogs"></i> Admin Panel
                </a>
            </c:if>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main">
        <!-- Hero Section -->
        <section class="hero">
            <div>
                <h1>Explore Knowledge with Pahana Edu</h1>
                <p>Serving the heart of Colombo with quality books, smart billing, and modern inventory systems. Discover what makes us Sri Lanka's trusted bookshop since 1995.</p>
                
                <!-- Role-specific welcome message -->
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <div style="margin-top: 1.5rem; padding: 1rem; background: #fef3c7; border-left: 4px solid #f59e0b; border-radius: 6px;">
                        <p style="color: #92400e; font-weight: 600; margin: 0;">
                            <i class="fas fa-crown"></i> Welcome Administrator! 
                            <a href="${pageContext.request.contextPath}/admindashboard.jsp" style="color: #92400e; text-decoration: underline;">
                                Access Admin Dashboard
                            </a>
                        </p>
                    </div>
                </c:if>
            </div>
            <img src="<c:url value='/images/dashboard/bookshop.png' />" alt="Bookstore Image">
        </section>

        <!-- Books Section -->
        <section class="books-section" id="books-section">
            <h2>Popular Books</h2>
            <div class="book-grid">
                <div class="book-card">
                   <img src="<c:url value='/images/dashboard/banjo.jpg' />" alt="Book 1">
                    <div class="book-info">
                        <h3>Bonjo</h3>
                        <p>LKR 2,500</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="<c:url value='/images/dashboard/dry ur tears.jpg' />" alt="Book 2">
                    <div class="book-info">
                        <h3>Dry Your Tears</h3>
                        <p>LKR 1,800</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="<c:url value='/images/dashboard/sonny boy.jpg' />" alt="Book 3">
                    <div class="book-info">
                        <h3>Sonny Boy</h3>
                        <p>LKR 2,100</p>
                    </div>
                </div>
                <div class="book-card">
                    <img src="<c:url value='/images/dashboard/Irene.jpg' />" alt="Book 4">
                    <div class="book-info">
                        <h3>Rich Dad Poor Dad</h3>
                        <p>LKR 1,750</p>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <footer>
        <p>&copy; 2025 Pahana Edu Bookstore | All rights reserved | Version 2.0</p>
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

        // Console log for debugging
        console.log('Dashboard loaded for user:', '${sessionScope.user.username}');
        console.log('User role:', '${sessionScope.user.role}');
    </script>
</body>
</html>