<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #34495e;
            color: white;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header h1 {
            margin: 0;
            font-size: 22px;
        }
        .header-buttons {
            display: flex;
            gap: 10px;
        }
        .header-buttons a {
            background-color: #2ecc71;
            color: white;
            padding: 8px 15px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 14px;
        }
        .header-buttons a.logout {
            background-color: #e74c3c;
        }
        main {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 50px;
        }
        .dashboard-option {
            background-color: white;
            padding: 20px;
            margin: 15px;
            border-radius: 8px;
            width: 250px;
            text-align: center;
            box-shadow: 0px 4px 6px rgba(0,0,0,0.1);
            transition: 0.3s;
        }
        .dashboard-option:hover {
            background-color: #ecf0f1;
            transform: scale(1.05);
        }
        .dashboard-option a {
            text-decoration: none;
            color: #34495e;
            font-weight: bold;
        }
    </style>
</head>
<body>

<header>
    <h1>Admin Dashboard</h1>
    <div class="header-buttons">
        <a href="profile.jsp">Profile</a>
        <a href="logout" class="logout">Logout</a>
    </div>
</header>

<main>
    <div class="dashboard-option">
        <a href="Items CRUD.jsp">📚 Manage Books</a>
    </div>
    <div class="dashboard-option">
        <a href="viewFeedback.jsp">💬 View Feedback</a>
    </div>
    <div class="dashboard-option">
        <a href="customers">👥 Edit Customers</a>
    </div>
</main>

</body>
</html>
