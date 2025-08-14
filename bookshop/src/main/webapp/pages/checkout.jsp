<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
// Check if user is logged in
if (session.getAttribute("user") == null) {
    response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
    return;
}

// Get user object from session with enhanced debugging
Object userObj = session.getAttribute("user");
int userId = 0;
String username = "";

System.out.println("=== CHECKOUT DEBUG START ===");
System.out.println("User object from session: " + userObj);
System.out.println("User object class: " + (userObj != null ? userObj.getClass().getName() : "null"));

// Extract user ID and username with comprehensive error handling
if (userObj != null) {
    try {
        // Method 1: Try reflection approach for User objects
        try {
            java.lang.reflect.Method getIdMethod = userObj.getClass().getMethod("getId");
            java.lang.reflect.Method getUsernameMethod = userObj.getClass().getMethod("getUsername");
            
            Object userIdResult = getIdMethod.invoke(userObj);
            Object usernameResult = getUsernameMethod.invoke(userObj);
            
            if (userIdResult != null) {
                userId = (Integer) userIdResult;
            }
            if (usernameResult != null) {
                username = (String) usernameResult;
            }
            
            System.out.println("SUCCESS: User extracted via reflection - ID: " + userId + ", Username: " + username);
            
        } catch (Exception reflectionException) {
            System.out.println("INFO: Reflection failed, trying alternative methods");
            
            // Method 2: Try direct session attributes
            Object userIdObj = session.getAttribute("user_id");
            Object usernameObj = session.getAttribute("username");
            
            System.out.println("Direct session - user_id: " + userIdObj + ", username: " + usernameObj);
            
            if (userIdObj != null) {
                if (userIdObj instanceof Integer) {
                    userId = (Integer) userIdObj;
                } else if (userIdObj instanceof String) {
                    userId = Integer.parseInt((String) userIdObj);
                }
            }
            
            if (usernameObj != null) {
                username = (String) usernameObj;
            }
            
            System.out.println("SUCCESS: User extracted from direct session - ID: " + userId + ", Username: " + username);
            
            // Method 3: Try field access if methods above failed
            if (userId == 0 || username.isEmpty()) {
                try {
                    java.lang.reflect.Field[] fields = userObj.getClass().getDeclaredFields();
                    System.out.println("Available fields in user object:");
                    for (java.lang.reflect.Field field : fields) {
                        field.setAccessible(true);
                        System.out.println("  " + field.getName() + " = " + field.get(userObj));
                        
                        if (field.getName().equalsIgnoreCase("id") || field.getName().equalsIgnoreCase("userId")) {
                            Object value = field.get(userObj);
                            if (value instanceof Integer) {
                                userId = (Integer) value;
                            }
                        }
                        if (field.getName().equalsIgnoreCase("username") || field.getName().equalsIgnoreCase("name")) {
                            Object value = field.get(userObj);
                            if (value instanceof String) {
                                username = (String) value;
                            }
                        }
                    }
                    
                    System.out.println("SUCCESS: User extracted via fields - ID: " + userId + ", Username: " + username);
                    
                } catch (Exception fieldException) {
                    System.out.println("ERROR: Field access failed: " + fieldException.getMessage());
                }
            }
        }
        
    } catch (Exception e) {
        System.out.println("ERROR: All user extraction methods failed: " + e.getMessage());
        e.printStackTrace();
    }
}

// If we still don't have user info, try hardcoded values for testing
if (userId <= 0) {
    System.out.println("WARNING: Could not extract user ID, using default for testing");
    userId = 1; // Default for testing - change this in production
}
if (username == null || username.trim().isEmpty()) {
    System.out.println("WARNING: Could not extract username, using default for testing");
    username = "Test User"; // Default for testing - change this in production
}

System.out.println("FINAL: User ID: " + userId + ", Username: " + username);

// Handle checkout processing
boolean orderProcessed = false;
String orderNumber = null;
java.util.Date orderDate = new java.util.Date();
String errorMessage = null;
String successMessage = null;

System.out.println("Request method: " + request.getMethod());
System.out.println("Action parameter: " + request.getParameter("action"));

// Check if this is a POST request with processOrder action
if ("POST".equals(request.getMethod()) && "processOrder".equals(request.getParameter("action"))) {
    System.out.println("=== PROCESSING ORDER ===");
    
    // Generate unique order number
    orderNumber = "ORD" + System.currentTimeMillis();
    System.out.println("Generated order number: " + orderNumber);
    
    // Get cart from session
    java.util.List<java.util.Map<String, Object>> cart = 
        (java.util.List<java.util.Map<String, Object>>) session.getAttribute("cart");
    
    System.out.println("Cart retrieved: " + (cart != null ? "Yes" : "No"));
    System.out.println("Cart size: " + (cart != null ? cart.size() : "null"));
    
    // Validate cart and user
    if (cart == null || cart.isEmpty()) {
        errorMessage = "Cannot process order: Cart is empty";
        System.out.println("ERROR: " + errorMessage);
    } else if (userId <= 0) {
        errorMessage = "Cannot process order: User not identified";
        System.out.println("ERROR: " + errorMessage);
    } else {
        // Process cart items
        StringBuilder bookTitles = new StringBuilder();
        StringBuilder quantities = new StringBuilder();
        StringBuilder prices = new StringBuilder();
        double totalAmount = 0.0;
        double taxRate = 0.08; // 8% tax
        double deliveryFee = 250.0; // Fixed delivery fee
        
        System.out.println("Processing " + cart.size() + " cart items...");
        
        for (int i = 0; i < cart.size(); i++) {
            java.util.Map<String, Object> item = cart.get(i);
            
            // Extract item details
            String title = (String) item.get("title");
            if (title == null || title.trim().isEmpty()) {
                title = "Unknown Book";
            }
            
            // Handle price safely
            double price = 0.0;
            Object priceObj = item.get("price");
            if (priceObj instanceof Number) {
                price = ((Number) priceObj).doubleValue();
            } else if (priceObj instanceof String) {
                try {
                    price = Double.parseDouble((String) priceObj);
                } catch (NumberFormatException e) {
                    System.out.println("ERROR: Invalid price format: " + priceObj);
                    price = 0.0;
                }
            }
            
            // Handle quantity safely
            int quantity = 1;
            Object quantityObj = item.get("quantity");
            if (quantityObj instanceof Number) {
                quantity = ((Number) quantityObj).intValue();
            } else if (quantityObj instanceof String) {
                try {
                    quantity = Integer.parseInt((String) quantityObj);
                } catch (NumberFormatException e) {
                    System.out.println("ERROR: Invalid quantity format: " + quantityObj);
                    quantity = 1;
                }
            }
            
            System.out.println("Item " + (i+1) + ": " + title + ", Price: " + price + ", Qty: " + quantity);
            
            // Build comma-separated strings
            if (i > 0) {
                bookTitles.append(",");
                quantities.append(",");
                prices.append(",");
            }
            
            bookTitles.append(title.replace(",", ";")); // Replace commas to avoid parsing issues
            quantities.append(quantity);
            prices.append(String.format("%.2f", price));
            
            totalAmount += price * quantity;
        }
        
        // Calculate final totals
        double taxAmount = totalAmount * taxRate;
        double finalTotal = totalAmount + taxAmount + deliveryFee;
        
        System.out.println("=== ORDER TOTALS ===");
        System.out.println("Subtotal: " + totalAmount);
        System.out.println("Tax: " + taxAmount);
        System.out.println("Delivery: " + deliveryFee);
        System.out.println("Final Total: " + finalTotal);
        
        // Database insertion
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            System.out.println("=== DATABASE CONNECTION ===");
            
            // Database connection parameters - UPDATE THESE FOR YOUR SETUP
            String jdbcURL = "jdbc:mysql://localhost:3306/bookstore_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            String dbUsername = "root"; // Change this
            String dbPassword = "123456"; // Change this
            
            System.out.println("Connecting to: " + jdbcURL);
            System.out.println("DB Username: " + dbUsername);
            
            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Establish connection
            conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);
            System.out.println("SUCCESS: Database connection established");
            
            // Test connection
            if (conn.isValid(5)) {
                System.out.println("SUCCESS: Connection is valid");
            } else {
                throw new SQLException("Invalid connection");
            }
            
            // Check if orders table exists
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet tables = metadata.getTables(null, null, "orders", null);
            
            if (!tables.next()) {
                System.out.println("ERROR: Orders table does not exist!");
                errorMessage = "Database table 'orders' not found. Please create the table first.";
            } else {
                System.out.println("SUCCESS: Orders table exists");
                
                // Prepare SQL statement - Updated for your table structure
                String insertSQL = "INSERT INTO orders (user_id, book_titles, quantities, prices, total_amount, order_date) VALUES (?, ?, ?, ?, ?, ?)";
                System.out.println("SQL: " + insertSQL);
                
                pstmt = conn.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS);
                pstmt.setInt(1, userId);
                pstmt.setString(2, bookTitles.toString());
                pstmt.setString(3, quantities.toString());
                pstmt.setString(4, prices.toString());
                pstmt.setDouble(5, finalTotal);
                pstmt.setTimestamp(6, new Timestamp(orderDate.getTime()));
                
                System.out.println("=== SQL PARAMETERS ===");
                System.out.println("1. user_id: " + userId);
                System.out.println("2. book_titles: " + bookTitles.toString());
                System.out.println("3. quantities: " + quantities.toString());
                System.out.println("4. prices: " + prices.toString());
                System.out.println("5. total_amount: " + finalTotal);
                System.out.println("6. order_date: " + new Timestamp(orderDate.getTime()));
                
                // Execute the insert
                int rowsAffected = pstmt.executeUpdate();
                System.out.println("Rows affected: " + rowsAffected);
                
                if (rowsAffected > 0) {
                    // Get generated order ID (order_id in your table)
                    ResultSet generatedKeys = pstmt.getGeneratedKeys();
                    int orderId = 0;
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getInt(1);
                    }
                    generatedKeys.close();
                    
                    orderProcessed = true;
                    successMessage = "Order placed successfully!";
                    
                    // Clear cart and set success attributes
                    session.removeAttribute("cart");
                    session.setAttribute("orderNumber", orderNumber);
                    session.setAttribute("orderDate", orderDate);
                    session.setAttribute("orderId", orderId);
                    
                    System.out.println("SUCCESS: Order saved with order_id: " + orderId);
                    System.out.println("SUCCESS: Cart cleared, session updated");
                    
                } else {
                    errorMessage = "Failed to save order to database";
                    System.out.println("ERROR: " + errorMessage);
                }
            }
            tables.close();
            
        } catch (ClassNotFoundException e) {
            errorMessage = "MySQL JDBC driver not found: " + e.getMessage();
            System.out.println("ERROR: " + errorMessage);
            e.printStackTrace();
        } catch (SQLException e) {
            errorMessage = "Database error: " + e.getMessage();
            System.out.println("ERROR: SQLException");
            System.out.println("  Message: " + e.getMessage());
            System.out.println("  SQL State: " + e.getSQLState());
            System.out.println("  Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            errorMessage = "Unexpected error: " + e.getMessage();
            System.out.println("ERROR: Exception - " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Close resources
            try {
                if (pstmt != null) {
                    pstmt.close();
                    System.out.println("PreparedStatement closed");
                }
            } catch (SQLException e) {
                System.out.println("Error closing PreparedStatement: " + e.getMessage());
            }
            
            try {
                if (conn != null) {
                    conn.close();
                    System.out.println("Connection closed");
                }
            } catch (SQLException e) {
                System.out.println("Error closing Connection: " + e.getMessage());
            }
        }
    }
    
    System.out.println("=== ORDER PROCESSING COMPLETE ===");
    System.out.println("Order processed: " + orderProcessed);
    System.out.println("Error message: " + errorMessage);
    System.out.println("Success message: " + successMessage);
}

// Calculate cart totals for display
double cartTotal = 0.0;
double taxRate = 0.08;
double deliveryFee = 250.0;
int cartItemCount = 0;

java.util.List<java.util.Map<String, Object>> cart = 
    (java.util.List<java.util.Map<String, Object>>) session.getAttribute("cart");

if (cart != null) {
    for (java.util.Map<String, Object> item : cart) {
        Object priceObj = item.get("price");
        Object quantityObj = item.get("quantity");
        
        double price = 0.0;
        int quantity = 0;
        
        if (priceObj instanceof Number) {
            price = ((Number) priceObj).doubleValue();
        } else if (priceObj instanceof String) {
            try {
                price = Double.parseDouble((String) priceObj);
            } catch (NumberFormatException e) {
                // Handle error
            }
        }
        
        if (quantityObj instanceof Number) {
            quantity = ((Number) quantityObj).intValue();
        } else if (quantityObj instanceof String) {
            try {
                quantity = Integer.parseInt((String) quantityObj);
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }
        
        cartTotal += price * quantity;
        cartItemCount += quantity;
    }
}

double taxAmount = cartTotal * taxRate;
double finalTotal = cartTotal + taxAmount + deliveryFee;

// Set page context attributes
pageContext.setAttribute("cartTotal", cartTotal);
pageContext.setAttribute("taxAmount", taxAmount);
pageContext.setAttribute("deliveryFee", deliveryFee);
pageContext.setAttribute("finalTotal", finalTotal);
pageContext.setAttribute("cartItemCount", cartItemCount);
pageContext.setAttribute("orderProcessed", orderProcessed);
pageContext.setAttribute("orderNumber", orderNumber);
pageContext.setAttribute("orderDate", orderDate);
pageContext.setAttribute("errorMessage", errorMessage);
pageContext.setAttribute("successMessage", successMessage);
pageContext.setAttribute("username", username);
pageContext.setAttribute("userId", userId);

System.out.println("=== CHECKOUT DEBUG END ===");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Pahana Edu</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css">
</head>
<body>
    <!-- Debug Toggle Button -->
    <button class="debug-toggle" onclick="toggleDebug()">
        <i class="fas fa-bug"></i> Debug
    </button>

    <!-- Debug Panel -->
    <div id="debugPanel" class="debug-panel hidden">
        <h4><i class="fas fa-info-circle"></i> Debug Information</h4>
        <div class="debug-item debug-success">User ID: ${userId}</div>
        <div class="debug-item debug-success">Username: ${username}</div>
        <div class="debug-item">Request Method: <%= request.getMethod() %></div>
        <div class="debug-item">Action Parameter: <%= request.getParameter("action") %></div>
        <div class="debug-item">Cart Items: ${cartItemCount}</div>
        <div class="debug-item">Cart Total: LKR <fmt:formatNumber value="${cartTotal}" pattern="#,##0.00" /></div>
        <div class="debug-item">Order Processed: ${orderProcessed}</div>
        <c:if test="${not empty errorMessage}">
            <div class="debug-item debug-error">Error: ${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="debug-item debug-success">Success: ${successMessage}</div>
        </c:if>
        <div class="debug-item debug-warning">Check server console for detailed logs</div>
    </div>

    <!-- Header -->
    <header class="header">
        <a href="<c:url value='/pages/dashboard.jsp' />" class="logo">
            <i class="fas fa-book-reader"></i> Pahana Edu
        </a>

        <div class="checkout-title">
            <h2><i class="fas fa-credit-card"></i> Checkout</h2>
        </div>

        <div class="user-info">
            <a href="<c:url value='/pages/profile.jsp' />" class="profile-link">
                <img src="<c:url value='/images/dashboard/profile.png' />" alt="User" class="profile-img">
                <span>${username}</span>
            </a>
        </div>
    </header>

    <main class="main">
        <!-- Display Messages -->
        <c:if test="${not empty errorMessage}">
            <div class="message error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <c:if test="${not empty successMessage}">
            <div class="message success-message">
                <i class="fas fa-check-circle"></i>
                <span>${successMessage}</span>
            </div>
        </c:if>

        <div class="checkout-container">
            <c:choose>
                <c:when test="${orderProcessed}">
                    <!-- Success Message -->
                    <div class="checkout-header">
                        <h1><i class="fas fa-check-circle"></i> Order Confirmed!</h1>
                        <p>Thank you for your purchase</p>
                    </div>
                    
                    <div class="success-container">
                        <div class="success-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <h2>Order Successfully Placed!</h2>
                        <p>Your order has been confirmed and saved to our database.</p>
                        
                        <div class="order-details">
                            <h3 style="color: #059669; margin-bottom: 1rem;">
                                <i class="fas fa-receipt"></i> Order Details
                            </h3>
                            <div class="info-row">
                                <span>Order Number:</span>
                                <span><strong>${orderNumber}</strong></span>
                            </div>
                            <div class="info-row">
                                <span>Order Date:</span>
                                <span><fmt:formatDate value="${orderDate}" pattern="dd/MM/yyyy HH:mm:ss" /></span>
                            </div>
                            <div class="info-row">
                                <span>Customer:</span>
                                <span>${username}</span>
                            </div>
                            <div class="info-row">
                                <span>Total Amount:</span>
                                <span style="color: #059669; font-weight: 700;">
                                    LKR <fmt:formatNumber value="${finalTotal}" pattern="#,##0.00" />
                                </span>
                            </div>
                        </div>
                        
                        <div class="checkout-actions">
                            <button onclick="window.print()" class="btn btn-secondary">
                                <i class="fas fa-print"></i> Print Receipt
                            </button>
                            <a href="<c:url value='/pages/dashboard.jsp' />" class="btn btn-primary">
                                <i class="fas fa-home"></i> Continue Shopping
                            </a>
                        </div>
                    </div>
                </c:when>

                <c:when test="${empty sessionScope.cart}">
                    <!-- Empty Cart -->
                    <div class="checkout-header">
                        <h1><i class="fas fa-shopping-cart"></i> Checkout</h1>
                        <p>Your cart is empty</p>
                    </div>
                    
                    <div class="empty-cart">
                        <i class="fas fa-shopping-cart"></i>
                        <h2>No items in cart</h2>
                        <p>Add some books to your cart before proceeding to checkout.</p>
                        <br>
                        <a href="<c:url value='/pages/dashboard.jsp' />" class="btn btn-primary">
                            <i class="fas fa-book"></i> Browse Books
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- Checkout Form -->
                    <div class="checkout-header">
                        <h1><i class="fas fa-credit-card"></i> Checkout</h1>
                        <p>Review your order and complete your purchase</p>
                    </div>

                    <div class="order-summary">
                        <!-- Customer Information -->
                        <h2 class="section-title">
                            <i class="fas fa-user"></i> Customer Information
                        </h2>
                        <div class="order-details">
                            <div class="info-row">
                                <span>Customer Name:</span>
                                <span>${username}</span>
                            </div>
                            <div class="info-row">
                                <span>User ID:</span>
                                <span>${userId}</span>
                            </div>
                            <div class="info-row">
                                <span>Order Date:</span>
                                <span>
                                    <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss" />
                                </span>
                            </div>
                        </div>

                        <!-- Order Items -->
                        <h2 class="section-title">
                            <i class="fas fa-list"></i> Order Summary
                        </h2>
                        <div class="order-items">
                            <div class="item-row header">
                                <div>Image</div>
                                <div>Book Title</div>
                                <div>Price</div>
                                <div>Qty</div>
                                <div>Total</div>
                            </div>
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <div class="item-row">
                                    <img src="<c:url value='${item.image}' />" alt="${item.title}" class="item-image">
                                    <div><strong>${item.title}</strong></div>
                                    <div>LKR <fmt:formatNumber value="${item.price}" pattern="#,##0.00" /></div>
                                    <div>${item.quantity}</div>
                                    <div><strong>
                                        LKR <fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00" />
                                    </strong></div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Bill Summary -->
                        <div class="bill-summary">
                            <h3 style="margin-bottom: 1rem; color: #1f2937;">
                                <i class="fas fa-calculator"></i> Bill Summary
                            </h3>
                            <div class="bill-row">
                                <span>Subtotal (${cartItemCount} items):</span>
                                <span><strong>LKR <fmt:formatNumber value="${cartTotal}" pattern="#,##0.00" /></strong></span>
                            </div>
                            <div class="bill-row">
                                <span>Tax (8%):</span>
                                <span><strong>LKR <fmt:formatNumber value="${taxAmount}" pattern="#,##0.00" /></strong></span>
                            </div>
                            <div class="bill-row">
                                <span>Delivery Fee:</span>
                                <span><strong>LKR <fmt:formatNumber value="${deliveryFee}" pattern="#,##0.00" /></strong></span>
                            </div>
                            <div class="bill-row total">
                                <span>Total Amount:</span>
                                <span style="color: #059669; font-size: 1.3rem;">
                                    <strong>LKR <fmt:formatNumber value="${finalTotal}" pattern="#,##0.00" /></strong>
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="checkout-actions">
                        <a href="<c:url value='/pages/dashboard.jsp' />" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Continue Shopping
                        </a>
                        <form method="post" style="display: inline;">
                            <input type="hidden" name="action" value="processOrder">
                            <button type="submit" class="btn btn-primary" id="placeOrderBtn">
                                <i class="fas fa-check"></i> Place Order
                            </button>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <script>
        // Debug panel toggle
        function toggleDebug() {
            const panel = document.getElementById('debugPanel');
            panel.classList.toggle('hidden');
        }

        // Enhanced order confirmation
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form[method="post"]');
            const placeOrderBtn = document.getElementById('placeOrderBtn');
            
            if (form && placeOrderBtn) {
                // Focus on place order button
                placeOrderBtn.focus();
                
                // Add loading state and confirmation
                form.addEventListener('submit', function(e) {
                    const confirmed = confirm(
                        'Confirm Order Placement\n\n' +
                        'Customer: ${username}\n' +
                        'Total Amount: LKR <fmt:formatNumber value="${finalTotal}" pattern="#,##0.00" />\n' +
                        'Items: ${cartItemCount}\n\n' +
                        'Are you sure you want to place this order?'
                    );
                    
                    if (confirmed) {
                        // Show loading state
                        placeOrderBtn.disabled = true;
                        placeOrderBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                        
                        console.log('Order submission started...');
                        console.log('Form action:', form.action);
                        console.log('Form method:', form.method);
                        
                        // Log form data
                        const formData = new FormData(form);
                        for (let pair of formData.entries()) {
                            console.log('Form data:', pair[0], '=', pair[1]);
                        }
                        
                        return true; // Allow form submission
                    } else {
                        e.preventDefault();
                        return false;
                    }
                });
            }
            
            // Auto-hide debug panel after 10 seconds if there's an error
            <c:if test="${not empty errorMessage}">
                setTimeout(function() {
                    const panel = document.getElementById('debugPanel');
                    if (!panel.classList.contains('hidden')) {
                        panel.style.display = 'block';
                        panel.classList.remove('hidden');
                    }
                }, 2000);
            </c:if>
        });

        // Console logging for debugging
        console.log('=== CHECKOUT PAGE DEBUG ===');
        console.log('User ID: ${userId}');
        console.log('Username: ${username}');
        console.log('Cart Items: ${cartItemCount}');
        console.log('Cart Total: ${cartTotal}');
        console.log('Final Total: ${finalTotal}');
        console.log('Order Processed: ${orderProcessed}');
        console.log('Error Message: ${errorMessage}');
        console.log('Success Message: ${successMessage}');
        
        <c:if test="${orderProcessed}">
        console.log('SUCCESS: Order placed successfully!');
        console.log('Order Number: ${orderNumber}');
        </c:if>
        
        <c:if test="${not empty errorMessage}">
        console.error('ERROR: ${errorMessage}');
        console.log('Check server console for detailed database logs');
        </c:if>
    </script>
</body>
</html>