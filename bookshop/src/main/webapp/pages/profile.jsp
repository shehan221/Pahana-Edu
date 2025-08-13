<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>

<%!
    // Password hashing method
    public String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
%>

<%
    // Handle logout action
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Check if user is logged in
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Handle profile update
    if ("updateProfile".equals(request.getParameter("action")) && "POST".equalsIgnoreCase(request.getMethod())) {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        
        // Database configuration - UPDATE THESE
        String DB_URL = "jdbc:mysql://localhost:3306/bookstore_db";
        String DB_USER = "root";
        String DB_PASS = "your_password";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            
            // Get username from session
            String username = "";
            try {
                java.lang.reflect.Method getUsernameMethod = userObj.getClass().getMethod("getUsername");
                username = (String) getUsernameMethod.invoke(userObj);
            } catch (Exception e1) {
                try {
                    java.lang.reflect.Field usernameField = userObj.getClass().getDeclaredField("username");
                    usernameField.setAccessible(true);
                    username = (String) usernameField.get(userObj);
                } catch (Exception e2) {
                    username = request.getParameter("hiddenUsername");
                }
            }
            
            if (username != null && !username.trim().isEmpty()) {
                // Get user_id for database operations
                String getUserIdSql = "SELECT user_id FROM users WHERE username = ?";
                pstmt = conn.prepareStatement(getUserIdSql);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();
                
                int userId = 0;
                if (rs.next()) {
                    userId = rs.getInt("user_id");
                }
                rs.close();
                pstmt.close();
                
                if (userId > 0) {
                    // Validate inputs
                    if (fullName == null || fullName.trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Full name is required.");
                    } else if (email == null || email.trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Email is required.");
                    } else {
                        // Check if email already exists for other users
                        String checkEmailSql = "SELECT COUNT(*) FROM users WHERE email = ? AND user_id != ?";
                        pstmt = conn.prepareStatement(checkEmailSql);
                        pstmt.setString(1, email.trim());
                        pstmt.setInt(2, userId);
                        rs = pstmt.executeQuery();
                        
                        if (rs.next() && rs.getInt(1) > 0) {
                            request.setAttribute("errorMessage", "Email address is already in use by another account.");
                        } else {
                            rs.close();
                            pstmt.close();
                            
                            // Check password if provided
                            if (newPassword != null && !newPassword.trim().isEmpty() && newPassword.length() < 6) {
                                request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
                            } else {
                                // Update user information using user_id
                                String updateSql = "UPDATE users SET full_name = ?, email = ?";
                                if (newPassword != null && !newPassword.trim().isEmpty()) {
                                    updateSql += ", password = ?";
                                }
                                updateSql += " WHERE user_id = ?";
                                
                                pstmt = conn.prepareStatement(updateSql);
                                pstmt.setString(1, fullName.trim());
                                pstmt.setString(2, email.trim());
                                
                                int paramIndex = 3;
                                if (newPassword != null && !newPassword.trim().isEmpty()) {
                                    String hashedNewPassword = hashPassword(newPassword);
                                    pstmt.setString(paramIndex++, hashedNewPassword);
                                }
                                pstmt.setInt(paramIndex, userId);
                                
                                int updated = pstmt.executeUpdate();
                                if (updated > 0) {
                                    request.setAttribute("successMessage", "Profile updated successfully!");
                                    
                                    // Update session user object
                                    try {
                                        java.lang.reflect.Method setFullNameMethod = userObj.getClass().getMethod("setFullName", String.class);
                                        setFullNameMethod.invoke(userObj, fullName.trim());
                                        
                                        java.lang.reflect.Method setEmailMethod = userObj.getClass().getMethod("setEmail", String.class);
                                        setEmailMethod.invoke(userObj, email.trim());
                                        
                                        session.setAttribute("user", userObj);
                                    } catch (Exception e) {
                                        // Continue even if reflection fails
                                    }
                                } else {
                                    request.setAttribute("errorMessage", "Failed to update profile. Please try again.");
                                }
                            }
                        }
                    }
                } else {
                    request.setAttribute("errorMessage", "User not found. Please login again.");
                }
            }
            
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred while updating profile.");
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #e6f9f0;
            min-height: 100vh;
            padding: 20px;
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
            min-width: 200px;
        }

        .profile-avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid #52b788;
            background-color: #52b788;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            color: white;
            font-size: 3rem;
        }

        .profile-right {
            flex: 2;
            min-width: 300px;
        }

        h2 {
            color: #2d6a4f;
            border-bottom: 2px solid #b2dfdb;
            padding-bottom: 10px;
            margin-bottom: 20px;
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
            flex-wrap: wrap;
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

        /* Alert Messages */
        .alert {
            padding: 15px 20px;
            margin: 0 0 20px 0;
            border-radius: 8px;
            font-weight: 500;
            width: 100%;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        /* Edit Profile Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: #fff;
            margin: 5% auto;
            padding: 0;
            border-radius: 15px;
            width: 90%;
            max-width: 600px;
            max-height: 85vh;
            overflow-y: auto;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }

        .modal-header {
            background-color: #52b788;
            color: white;
            padding: 20px;
            border-radius: 15px 15px 0 0;
            position: relative;
        }

        .modal-header h3 {
            margin: 0;
            font-size: 1.4rem;
        }

        .close {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: white;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            opacity: 0.7;
        }

        .modal-body {
            padding: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #374151;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 1rem;
            box-sizing: border-box;
        }

        .form-group input:focus {
            outline: none;
            border-color: #52b788;
        }

        .password-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 4px solid #52b788;
        }

        .password-section h4 {
            color: #2d6a4f;
            margin-bottom: 15px;
            font-size: 1rem;
        }

        .form-note {
            font-size: 0.85rem;
            color: #6b7280;
            font-style: italic;
            margin-top: 5px;
        }

        .btn-save {
            background-color: #52b788;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            margin-right: 10px;
        }

        .btn-save:hover {
            background-color: #40916c;
        }

        .btn-cancel {
            background-color: #6b7280;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
        }

        .btn-cancel:hover {
            background-color: #4b5563;
        }

        /* Logout Modal */
        .logout-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }

        .logout-modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 0;
            border-radius: 15px;
            width: 90%;
            max-width: 400px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }

        .logout-header {
            background-color: #d00000;
            color: white;
            padding: 20px;
            border-radius: 15px 15px 0 0;
            text-align: center;
        }

        .logout-header h3 {
            margin: 0;
            font-size: 1.3rem;
        }

        .logout-body {
            padding: 25px;
            text-align: center;
        }

        .logout-body p {
            margin-bottom: 20px;
            color: #333;
        }

        .logout-buttons {
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .btn-confirm {
            background-color: #d00000;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-confirm:hover {
            background-color: #a40000;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                margin: 20px auto;
                padding: 15px;
            }

            .profile-left, .profile-right {
                flex: none;
                width: 100%;
            }

            .btn-group {
                flex-direction: column;
            }

            .btn {
                text-align: center;
            }

            .modal-content {
                width: 95%;
                margin: 5% auto;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <c:if test="${not empty user}">
        <!-- Display Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ✅ ${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                ❌ ${errorMessage}
            </div>
        </c:if>

        <div class="profile-left">
            <div class="profile-avatar">
                👤
            </div>
        </div>

        <div class="profile-right">
            <h2>Welcome, ${user.fullName}</h2>

            <div class="info"><span class="label">UserName:</span> ${user.username}</div>
            <div class="info"><span class="label">FullName:</span> ${user.fullName}</div>
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
                <button onclick="openEditModal()" class="btn btn-edit">Edit Profile</button>
                <button onclick="openLogoutModal()" class="btn btn-logout">Logout</button>
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

<!-- Edit Profile Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>✏️ Edit Profile Information</h3>
            <span class="close" onclick="closeEditModal()">&times;</span>
        </div>
        
        <div class="modal-body">
            <form id="editProfileForm" method="post" action="">
                <input type="hidden" name="action" value="updateProfile">
                <input type="hidden" name="hiddenUsername" value="${user.username}">
                
                <div class="form-group">
                    <label for="editFullName">👤 Full Name:</label>
                    <input type="text" id="editFullName" name="fullName" value="${user.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label for="editEmail">📧 Email Address:</label>
                    <input type="email" id="editEmail" name="email" value="${user.email}" required>
                </div>
                
                <div class="password-section">
                    <h4>🔒 Change Password (Optional)</h4>
                    <div class="form-note">Leave this field empty if you don't want to change your password.</div>
                    
                    <div class="form-group">
                        <label for="newPassword">New Password:</label>
                        <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password (minimum 6 characters)">
                        <div class="form-note">Password must be at least 6 characters long</div>
                    </div>
                </div>
                
                <div style="text-align: center; margin-top: 25px;">
                    <button type="submit" class="btn-save">💾 Save Changes</button>
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">❌ Cancel</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Logout Confirmation Modal -->
<div id="logoutModal" class="logout-modal">
    <div class="logout-modal-content">
        <div class="logout-header">
            <h3>🚪 Confirm Logout</h3>
        </div>
        <div class="logout-body">
            <p>Are you sure you want to logout?</p>
            <div class="logout-buttons">
                <button onclick="confirmLogout()" class="btn-confirm">Yes, Logout</button>
                <button onclick="closeLogoutModal()" class="btn-cancel">Cancel</button>
            </div>
        </div>
    </div>
</div>

<script>
    // Edit Profile Modal Functions
    function openEditModal() {
        document.getElementById('editModal').style.display = 'block';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
        document.getElementById('editProfileForm').reset();
        // Reset values to current user data
        document.getElementById('editFullName').value = '${user.fullName}';
        document.getElementById('editEmail').value = '${user.email}';
    }

    // Logout Modal Functions
    function openLogoutModal() {
        document.getElementById('logoutModal').style.display = 'block';
    }

    function closeLogoutModal() {
        document.getElementById('logoutModal').style.display = 'none';
    }

    function confirmLogout() {
        window.location.href = '?action=logout';
    }

    // Form validation
    document.getElementById('editProfileForm').addEventListener('submit', function(e) {
        var fullName = document.getElementById('editFullName').value.trim();
        var email = document.getElementById('editEmail').value.trim();
        var newPassword = document.getElementById('newPassword').value;
        
        if (!fullName) {
            e.preventDefault();
            alert('Full name is required.');
            document.getElementById('editFullName').focus();
            return;
        }
        
        if (!email) {
            e.preventDefault();
            alert('Email address is required.');
            document.getElementById('editEmail').focus();
            return;
        }
        
        // Email format validation
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            e.preventDefault();
            alert('Please enter a valid email address.');
            document.getElementById('editEmail').focus();
            return;
        }
        
        // Password validation (if provided)
        if (newPassword && newPassword.length < 6) {
            e.preventDefault();
            alert('Password must be at least 6 characters long.');
            document.getElementById('newPassword').focus();
            return;
        }
    });

    // Auto-format full name (capitalize words)
    document.getElementById('editFullName').addEventListener('input', function() {
        this.value = this.value.replace(/\b\w/g, function(char) {
            return char.toUpperCase();
        });
    });

    // Close modals when clicking outside
    window.onclick = function(event) {
        var editModal = document.getElementById('editModal');
        var logoutModal = document.getElementById('logoutModal');
        
        if (event.target == editModal) {
            closeEditModal();
        }
        if (event.target == logoutModal) {
            closeLogoutModal();
        }
    }

    // Auto-hide alerts after 5 seconds
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert');
        for (var i = 0; i < alerts.length; i++) {
            alerts[i].style.opacity = '0';
            alerts[i].style.transform = 'translateY(-10px)';
        }
    }, 5000);
</script>

</body>
</html>