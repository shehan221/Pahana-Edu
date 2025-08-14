<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Pahana Edu</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admindashboard_style.css">
</head>
<body>

    <header class="header">
        <a href="<c:url value='/pages/adminDashboard.jsp' />" class="logo">
            <i class="fas fa-user-shield"></i> Pahana Edu Admin
        </a>

        <div class="header-buttons">
            <a href="<c:url value='/pages/profile.jsp' />" class="profile-btn">
                <i class="fas fa-user"></i> Profile
            </a>
            <a href="<c:url value='/pages/login.jsp' />" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </header>

    <main class="main">
        <div class="welcome">
            <h1><i class="fas fa-crown"></i> Admin Dashboard</h1>
            <p>Manage your bookstore with these essential tools</p>
        </div>

        <div class="dashboard-grid">
            <div class="dashboard-option">
                <div class="icon">
                    <i class="fas fa-book"></i>
                </div>
                <h3>Manage Books</h3>
                <a href="<c:url value='/pages/Items CRUD.jsp' />">
                    <i class="fas fa-edit"></i> Go to Books
                </a>
            </div>

            <div class="dashboard-option">
                <div class="icon">
                    <i class="fas fa-comments"></i>
                </div>
                <h3>View Feedback</h3>
                <a href="<c:url value='/pages/viewFeedbacks.jsp' />">
                    <i class="fas fa-eye"></i> View Feedback
                </a>
            </div>

            <div class="dashboard-option">
                <div class="icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h3>Order History</h3>
                <a href="<c:url value='/pages/orderHistory.jsp' />">
                    <i class="fas fa-list"></i> View Orders
                </a>
            </div>
        </div>
    </main>

    <footer>
        <p>&copy; 2025 Pahana Edu Bookstore | Admin Panel</p>
    </footer>

</body>
</html>