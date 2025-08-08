<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e6f9f0;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 50px auto;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border: 1px solid #b2dfdb;
        }

        .profile-left {
            flex: 1;
            text-align: center;
        }

        .profile-left img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid #52b788;
            object-fit: cover;
        }

        .profile-right {
            flex: 2;
        }

        h2 {
            color: #2d6a4f;
            border-bottom: 2px solid #b2dfdb;
            padding-bottom: 10px;
        }

        .info {
            margin: 12px 0;
            font-size: 16px;
            color: #333;
        }

        .label {
            font-weight: bold;
            color: #1b4332;
        }

        .status-active {
            color: #2b9348;
            font-weight: bold;
        }

        .status-inactive {
            color: #d00000;
            font-weight: bold;
        }

        .btn-group {
            margin-top: 25px;
            display: flex;
            gap: 20px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            color: white;
            transition: 0.3s ease;
        }

        .btn-edit {
            background-color: #52b788;
        }

        .btn-edit:hover {
            background-color: #40916c;
        }

        .btn-logout {
            background-color: #d00000;
        }

        .btn-logout:hover {
            background-color: #a40000;
        }

        .exclusive {
            margin-top: 40px;
            background-color: #f1fdf7;
            padding: 20px;
            border: 1px dashed #95d5b2;
            border-radius: 10px;
        }

        .exclusive h3 {
            color: #2d6a4f;
            margin-bottom: 10px;
        }

        .exclusive p {
            font-size: 15px;
            color: #444;
        }
    </style>
</head>
<body>

<div class="container">

    <c:if test="${not empty user}">
        <div class="profile-left">
            <img src="${pageContext.request.contextPath}/images/dashboard/profile.png" alt="Profile Picture">
        </div>

        <div class="profile-right">
            <h2>Welcome, ${user.fullName}</h2>

            <div class="info"><span class="label">Username:</span> ${user.username}</div>
            <div class="info"><span class="label">Email:</span> ${user.email}</div>
            <div class="info"><span class="label">Role:</span> ${user.role}</div>
            <div class="info"><span class="label">Status:</span>
                <c:choose>
                    <c:when test="${user.active}">
                        <span class="status-active">Active</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-inactive">Inactive</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/edit-profile.jsp" class="btn btn-edit">Edit Info</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-logout">Logout</a>
            </div>

            <div class="exclusive">
                <h3>🎉 Customer Exclusives</h3>
                <p>As a valued user, you get early access to discounts, free shipping on select items, and VIP previews of new arrivals.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${empty user}">
        <div style="text-align: center; width: 100%;">
            <h2>User Profile</h2>
            <p>No profile data found. Please <a href="${pageContext.request.contextPath}/login.jsp">log in</a>.</p>
        </div>
    </c:if>

</div>

</body>
</html>
