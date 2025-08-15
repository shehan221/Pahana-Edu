<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%!
    // No password hashing - storing plain text passwords
    
    // Order class to hold order data
    public static class Order {
        private int orderId;
        private String bookTitles;
        private String quantities;
        private String prices;
        private double totalAmount;
        private Timestamp orderDate;
        
        public Order(int orderId, String bookTitles, String quantities, String prices, double totalAmount, Timestamp orderDate) {
            this.orderId = orderId;
            this.bookTitles = bookTitles;
            this.quantities = quantities;
            this.prices = prices;
            this.totalAmount = totalAmount;
            this.orderDate = orderDate;
        }
        
        // Getters
        public int getOrderId() { return orderId; }
        public String getBookTitles() { return bookTitles; }
        public String getQuantities() { return quantities; }
        public String getPrices() { return prices; }
        public double getTotalAmount() { return totalAmount; }
        public Timestamp getOrderDate() { return orderDate; }
        
        // Format date for display
        public String getFormattedDate() {
            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
            return sdf.format(orderDate);
        }
        
        // Get individual book titles as array
        public String[] getBookTitlesArray() {
            if (bookTitles == null || bookTitles.trim().isEmpty()) {
                return new String[0];
            }
            return bookTitles.split(",");
        }
        
        // Get individual quantities as array
        public String[] getQuantitiesArray() {
            if (quantities == null || quantities.trim().isEmpty()) {
                return new String[0];
            }
            return quantities.split(",");
        }
        
        // Get individual prices as array
        public String[] getPricesArray() {
            if (prices == null || prices.trim().isEmpty()) {
                return new String[0];
            }
            return prices.split(",");
        }
    }
%>

<%
    // Handle logout action
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        session.invalidate();
        // Try different redirect options
        String redirectUrl = request.getContextPath() + "/pages/login.jsp";
        
        // Check if login.jsp exists, otherwise redirect to a safe page
        try {
            response.sendRedirect(redirectUrl);
        } catch (Exception e) {
            // If login.jsp doesn't exist, redirect to home or show logout message
            out.println("<script>alert('Logged out successfully!'); window.location.href='" + request.getContextPath() + "/';</script>");
        }
        return;
    }
    
    // Check if user is logged in
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Database configuration - CHANGE THESE TO YOUR ACTUAL SETTINGS
    String DB_URL = "jdbc:mysql://localhost:3306/bookstore_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    String DB_USER = "root";
    String DB_PASS = "123456"; // Change this: empty for XAMPP, "root" for some installations, or your actual password
    
    // Alternative URLs to try if the above doesn't work
    String[] alternativeUrls = {
        "jdbc:mysql://127.0.0.1:3306/bookstore_db?useSSL=false",
        "jdbc:mysql://localhost:3306/bookstore_db",
        "jdbc:mysql://127.0.0.1:3306/bookstore_db"
    };
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Order> userOrders = new ArrayList<Order>();
    int userId = 0;
    String username = "";
    
    // Get username from session
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
            if (username == null) username = "";
        }
    }

    // Handle profile update
    if ("updateProfile".equals(request.getParameter("action")) && "POST".equalsIgnoreCase(request.getMethod())) {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Try main URL first
            try {
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                System.out.println("Connected successfully with main URL");
            } catch (SQLException e) {
                System.out.println("Main URL failed: " + e.getMessage());
                
                // Try alternative URLs
                for (String altUrl : alternativeUrls) {
                    try {
                        conn = DriverManager.getConnection(altUrl, DB_USER, DB_PASS);
                        System.out.println("Connected successfully with: " + altUrl);
                        break;
                    } catch (SQLException e2) {
                        System.out.println("Failed: " + altUrl + " - " + e2.getMessage());
                    }
                }
                
                if (conn == null) {
                    throw new SQLException("Could not connect to database with any URL. Check if MySQL is running and credentials are correct.");
                }
            }
            
            if (username != null && !username.trim().isEmpty()) {
                // Get user_id for database operations
                String getUserIdSql = "SELECT user_id FROM users WHERE username = ?";
                pstmt = conn.prepareStatement(getUserIdSql);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();
                
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
                                    // Store password as plain text (no hashing)
                                    pstmt.setString(paramIndex++, newPassword.trim());
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
            } else {
                request.setAttribute("errorMessage", "Unable to identify user. Please login again.");
            }
            
        } catch (ClassNotFoundException e) {
            request.setAttribute("errorMessage", "Database driver not found. Please ensure MySQL JDBC driver is installed.");
            System.err.println("MySQL Driver error: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Database connection failed: " + e.getMessage() + ". Please check if MySQL is running.");
            System.err.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred while updating profile: " + e.getMessage());
            System.err.println("General error: " + e.getMessage());
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
    
    // Fetch user orders
    try {
        if (conn == null || conn.isClosed()) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Try main URL first
            try {
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            } catch (SQLException e) {
                // Try alternative URLs
                for (String altUrl : alternativeUrls) {
                    try {
                        conn = DriverManager.getConnection(altUrl, DB_USER, DB_PASS);
                        break;
                    } catch (SQLException e2) {
                        // Continue to next URL
                    }
                }
            }
        }
        
        if (conn != null && username != null && !username.trim().isEmpty()) {
            // Get user_id if we don't have it yet
            if (userId == 0) {
                String getUserIdSql = "SELECT user_id FROM users WHERE username = ?";
                pstmt = conn.prepareStatement(getUserIdSql);
                pstmt.setString(1, username);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    userId = rs.getInt("user_id");
                }
                rs.close();
                pstmt.close();
            }
            
            if (userId > 0) {
                // Fetch orders for the user
                String ordersSql = "SELECT order_id, book_titles, quantities, prices, total_amount, order_date FROM orders WHERE user_id = ? ORDER BY order_date DESC";
                pstmt = conn.prepareStatement(ordersSql);
                pstmt.setInt(1, userId);
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    Order order = new Order(
                        rs.getInt("order_id"),
                        rs.getString("book_titles"),
                        rs.getString("quantities"),
                        rs.getString("prices"),
                        rs.getDouble("total_amount"),
                        rs.getTimestamp("order_date")
                    );
                    userOrders.add(order);
                }
            }
        }
    } catch (Exception e) {
        System.err.println("Error fetching orders: " + e.getMessage());
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
    
    // Set orders as request attribute
    request.setAttribute("userOrders", userOrders);
    request.setAttribute("orderCount", userOrders.size());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile_style.css">
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

        <!-- Database troubleshooting info - remove after fixing -->
        <div class="db-status" style="display: none;" id="dbInfo">
            🔧 DB Troubleshooting: Check Tomcat console for connection attempts
        </div>

        <!-- Tab Navigation -->
        <div class="tab-buttons">
            <button class="tab-btn active" onclick="showTab('profile-tab', this)">👤 Profile</button>
            <button class="tab-btn" onclick="showTab('orders-tab', this)">📦 Order History</button>
        </div>

        <!-- Profile Tab -->
        <div id="profile-tab" class="tab-content active">
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
        </div>

        <!-- Orders Tab -->
        <div id="orders-tab" class="tab-content">
            <div class="orders-section">
                <div class="orders-header">
                    <h3>📦 Your Order History</h3>
                    <span>Total Orders: ${orderCount}</span>
                </div>
                
                <div class="orders-content">
                    <c:choose>
                        <c:when test="${not empty userOrders}">
                            <c:forEach var="order" items="${userOrders}" varStatus="status">
                                <div class="order-item">
                                    <div class="order-header">
                                        <div>
                                            <div class="order-id">Order #${order.orderId}</div>
                                            <div class="order-date">📅 ${order.formattedDate}</div>
                                        </div>
                                        <div class="order-total">$${order.totalAmount}</div>
                                    </div>
                                    
                                    <div class="book-details">
                                        <%
                                            Order currentOrder = (Order) pageContext.getAttribute("order");
                                            if (currentOrder != null) {
                                                String[] titles = currentOrder.getBookTitlesArray();
                                                String[] quantities = currentOrder.getQuantitiesArray();
                                                String[] prices = currentOrder.getPricesArray();
                                                
                                                int maxLength = Math.max(Math.max(titles.length, quantities.length), prices.length);
                                                for (int i = 0; i < maxLength; i++) {
                                                    String title = i < titles.length ? titles[i].trim() : "";
                                                    String qty = i < quantities.length ? quantities[i].trim() : "0";
                                                    String price = i < prices.length ? prices[i].trim() : "0.00";
                                        %>
                                                    <div class="book-item">
                                                        <div class="book-title">📚 <%= title %></div>
                                                        <div class="book-qty">Qty: <%= qty %></div>
                                                        <div class="book-price">$<%= price %></div>
                                                    </div>
                                        <%
                                                }
                                            }
                                        %>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="no-orders">
                                <i>📦</i>
                                <h4>No Orders Yet</h4>
                                <p>You haven't placed any orders yet. Start shopping to see your order history here!</p>
                                <button onclick="window.location.href='${pageContext.request.contextPath}/books.jsp'" class="btn btn-edit" style="margin-top: 15px;">
                                    🛒 Start Shopping
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
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
                <button onclick="confirmLogout()" class="btn-confirm" id="logoutConfirmBtn">Yes, Logout</button>
                <button onclick="closeLogoutModal()" class="btn-cancel" id="logoutCancelBtn">Cancel</button>
            </div>
            
            <!-- Alternative logout options if redirect fails -->
            <div style="margin-top: 15px; display: none;" id="alternativeLogout">
                <p style="font-size: 12px; color: #666;">If logout doesn't work, try:</p>
                <button onclick="forceLogout()" class="btn-confirm" style="font-size: 12px; padding: 5px 10px;">Force Logout</button>
                <button onclick="clearSession()" class="btn-cancel" style="font-size: 12px; padding: 5px 10px;">Clear Session</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/profile.js"></script>
<script>
    // Tab switching functionality
    function showTab(tabId, buttonElement) {
        // Hide all tab contents
        var tabContents = document.querySelectorAll('.tab-content');
        for (var i = 0; i < tabContents.length; i++) {
            tabContents[i].classList.remove('active');
        }
        
        // Remove active class from all buttons
        var tabButtons = document.querySelectorAll('.tab-btn');
        for (var i = 0; i < tabButtons.length; i++) {
            tabButtons[i].classList.remove('active');
        }
        
        // Show selected tab and activate button
        document.getElementById(tabId).classList.add('active');
        buttonElement.classList.add('active');
    }
    
    // Alternative method for older browsers
    if (!document.querySelectorAll) {
        function showTab(tabId, buttonElement) {
            // Hide all tab contents
            var tabContents = document.getElementsByClassName('tab-content');
            for (var i = 0; i < tabContents.length; i++) {
                tabContents[i].className = tabContents[i].className.replace(' active', '');
            }
            
            // Remove active class from all buttons
            var tabButtons = document.getElementsByClassName('tab-btn');
            for (var i = 0; i < tabButtons.length; i++) {
                tabButtons[i].className = tabButtons[i].className.replace(' active', '');
            }
            
            // Show selected tab and activate button
            document.getElementById(tabId).className += ' active';
            buttonElement.className += ' active';
        }
    }
</script>
</body>
</html>