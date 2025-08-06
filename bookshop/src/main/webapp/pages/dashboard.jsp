<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Pahana Edu</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            min-height: 100vh;
        }

        .header {
            background: #059669;
            color: white;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 1.5rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logout-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.3s;
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .main-content {
            padding: 2rem;
            max-width: 1000px;
            margin: 0 auto;
        }

        .welcome-card {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            text-align: center;
        }

        .welcome-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 0.5rem;
        }

        .welcome-subtitle {
            color: #666;
            font-size: 1rem;
        }

        .user-details {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }

        .user-details h3 {
            color: #333;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid #eee;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            font-weight: 600;
            color: #333;
        }

        .detail-value {
            color: #666;
        }

        .status-active {
            color: #059669;
            font-weight: 600;
        }

        .status-inactive {
            color: #dc2626;
            font-weight: 600;
        }

        .actions {
            background: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .action-btn {
            background: #059669;
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 0 0.5rem;
            transition: background-color 0.3s;
        }

        .action-btn:hover {
            background: #047857;
        }

        .action-btn.secondary {
            background: #6b7280;
        }

        .action-btn.secondary:hover {
            background: #4b5563;
        }

        @media (max-width: 768px) {
            .header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .main-content {
                padding: 1rem;
            }

            .user-info {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="logo">
            📚 Pahana Edu
        </div>
        <div class="user-info">
            <span>Welcome, ${user.fullName}!</span>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
                🚪 Logout
            </a>
        </div>
    </header>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Welcome Section -->
        <div class="welcome-card">
            <h1 class="welcome-title">Dashboard</h1>
            <p class="welcome-subtitle">Welcome to Pahana Education Management System</p>
        </div>

        <!-- User Details -->
        <div class="user-details">
            <h3>👤 Your Account Information</h3>
            
            <div class="detail-row">
                <span class="detail-label">Full Name:</span>
                <span class="detail-value">${user.fullName}</span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Username:</span>
                <span class="detail-value">${user.username}</span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Email:</span>
                <span class="detail-value">
                    <c:choose>
                        <c:when test="${not empty user.email}">
                            ${user.email}
                        </c:when>
                        <c:otherwise>
                            Not provided
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Role:</span>
                <span class="detail-value">${user.role}</span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Account Status:</span>
                <span class="detail-value">
                    <c:choose>
                        <c:when test="${user.active}">
                            <span class="status-active">✅ Active</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-inactive">❌ Inactive</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">User ID:</span>
                <span class="detail-value">#${user.userId}</span>
            </div>
        </div>

        <!-- Actions -->
        <div class="actions">
            <h3 style="margin-bottom: 1rem; color: #333;">Quick Actions</h3>
            
            <a href="#" class="action-btn">📝 Update Profile</a>
            <a href="#" class="action-btn">🔒 Change Password</a>
            <a href="#" class="action-btn secondary">⚙️ Settings</a>
            <a href="${pageContext.request.contextPath}/logout" class="action-btn secondary">🚪 Logout</a>
        </div>
    </main>
</body>
</html>