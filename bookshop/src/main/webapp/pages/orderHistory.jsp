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

// Get current user info
Object userObj = session.getAttribute("user");
int currentUserId = 0;
String currentUsername = "";

// Extract current user info - same as checkout
if (userObj != null) {
    try {
        java.lang.reflect.Method getIdMethod = userObj.getClass().getMethod("getId");
        java.lang.reflect.Method getUsernameMethod = userObj.getClass().getMethod("getUsername");
        
        Object userIdResult = getIdMethod.invoke(userObj);
        Object usernameResult = getUsernameMethod.invoke(userObj);
        
        if (userIdResult != null) {
            currentUserId = ((Integer) userIdResult).intValue();
        }
        if (usernameResult != null) {
            currentUsername = (String) usernameResult;
        }
        
    } catch (Exception e) {
        Object userIdObj = session.getAttribute("user_id");
        Object usernameObj = session.getAttribute("username");
        
        if (userIdObj != null) {
            if (userIdObj instanceof Integer) {
                currentUserId = ((Integer) userIdObj).intValue();
            } else if (userIdObj instanceof String) {
                currentUserId = Integer.parseInt((String) userIdObj);
            }
        }
        
        if (usernameObj != null) {
            currentUsername = (String) usernameObj;
        }
    }
}

// Default values
if (currentUserId <= 0) {
    currentUserId = 1;
}
if (currentUsername == null || currentUsername.trim().isEmpty()) {
    currentUsername = "Administrator";
}

System.out.println("=== ADMIN ORDERS VIEW ===");
System.out.println("Admin: " + currentUsername + " (ID: " + currentUserId + ")");

// Initialize variables
List allOrders = new ArrayList();
String errorMessage = null;

// Database connection - SAME AS CHECKOUT
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
    // Database connection - EXACT SAME AS CHECKOUT
    String jdbcURL = "jdbc:mysql://localhost:3306/bookstore_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    String dbUsername = "root";
    String dbPassword = "123456";
    
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);
    
    // Query to get ALL orders with real customer names from users table
    String selectSQL = "SELECT o.*, " +
                      "CASE " +
                      "  WHEN u.full_name IS NOT NULL THEN u.full_name " +
                      "  WHEN u.username IS NOT NULL THEN u.username " +
                      "  ELSE CONCAT('Customer_', o.user_id) " +
                      "END as customer_name, " +
                      "u.email as customer_email, " +
                      "u.username as customer_username, " +
                      "u.role as customer_role " +
                      "FROM orders o " +
                      "LEFT JOIN users u ON o.user_id = u.user_id " +
                      "ORDER BY o.order_date DESC";
    
    System.out.println("SQL Query: " + selectSQL);
    
    pstmt = conn.prepareStatement(selectSQL);
    rs = pstmt.executeQuery();
    
    while (rs.next()) {
        Map order = new HashMap();
        
        order.put("order_id", new Integer(rs.getInt("order_id")));
        order.put("user_id", new Integer(rs.getInt("user_id")));
        order.put("customer_name", rs.getString("customer_name"));
        order.put("customer_email", rs.getString("customer_email"));
        order.put("customer_username", rs.getString("customer_username"));
        order.put("customer_role", rs.getString("customer_role"));
        order.put("book_titles", rs.getString("book_titles"));
        order.put("quantities", rs.getString("quantities"));
        order.put("prices", rs.getString("prices"));
        order.put("total_amount", new Double(rs.getDouble("total_amount")));
        order.put("order_date", rs.getTimestamp("order_date"));
        
        // Count total items
        String quantities = rs.getString("quantities");
        int totalItems = 0;
        if (quantities != null && !quantities.isEmpty()) {
            String[] qtyArray = quantities.split(",");
            for (int i = 0; i < qtyArray.length; i++) {
                try {
                    totalItems += Integer.parseInt(qtyArray[i].trim());
                } catch (NumberFormatException e) {
                    totalItems += 1;
                }
            }
        }
        order.put("total_items", new Integer(totalItems));
        
        allOrders.add(order);
        
        System.out.println("Order " + rs.getInt("order_id") + 
                         " - Customer: " + rs.getString("customer_name") + 
                         " (Username: " + rs.getString("customer_username") + 
                         ", ID: " + rs.getInt("user_id") + 
                         ", Role: " + rs.getString("customer_role") + ")");
    }
    
    System.out.println("Retrieved " + allOrders.size() + " orders");
    
} catch (Exception e) {
    errorMessage = "Error retrieving orders: " + e.getMessage();
    System.out.println("ERROR: " + errorMessage);
    e.printStackTrace();
} finally {
    try {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        System.out.println("Error closing resources: " + e.getMessage());
    }
}

// Set page attributes
pageContext.setAttribute("allOrders", allOrders);
pageContext.setAttribute("errorMessage", errorMessage);
pageContext.setAttribute("currentUsername", currentUsername);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Orders - Admin</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orderHistory.css">
</head>
<body>
    <div class="header">
        <h1><i class="fas fa-table"></i> All Customer Orders</h1>
        <p>Administrator: <strong>${currentUsername}</strong></p>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="error-message">
            <i class="fas fa-exclamation-triangle"></i>
            ${errorMessage}
        </div>
    </c:if>

    <div class="orders-container">
        <div class="table-header">
            <i class="fas fa-list"></i> Orders List (${fn:length(allOrders)} total)
        </div>

        <c:choose>
            <c:when test="${empty allOrders}">
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No Orders Found</h3>
                    <p>No orders available in the database.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="orders-table">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Customer</th>
                            <th>Order Date</th>
                            <th>Books Ordered</th>
                            <th>Total Items</th>
                            <th>Total Amount</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${allOrders}">
                            <tr>
                                <td>
                                    <span class="order-id">#${order.order_id}</span>
                                </td>
                                <td>
                                    <div class="customer-name">${order.customer_name}</div>
                                    <div class="customer-id">ID: ${order.user_id}</div>
                                    <c:if test="${not empty order.customer_username}">
                                        <div style="font-size: 11px; color: #666;">
                                            <i class="fas fa-user"></i> @${order.customer_username}
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty order.customer_email}">
                                        <div style="font-size: 11px; color: #007bff; margin-top: 2px;">
                                            <i class="fas fa-envelope"></i> ${order.customer_email}
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty order.customer_role && order.customer_role != 'USER'}">
                                        <div style="font-size: 10px; color: #dc3545; font-weight: bold; margin-top: 2px;">
                                            <i class="fas fa-shield-alt"></i> ${order.customer_role}
                                        </div>
                                    </c:if>
                                </td>
                                <td>
                                    <div><fmt:formatDate value="${order.order_date}" pattern="dd/MM/yyyy" /></div>
                                    <div style="font-size: 12px; color: #666;">
                                        <fmt:formatDate value="${order.order_date}" pattern="HH:mm:ss" />
                                    </div>
                                </td>
                                <td>
                                    <div class="items-summary">
                                        <c:set var="titles" value="${fn:split(order.book_titles, ',')}" />
                                        <c:set var="quantities" value="${fn:split(order.quantities, ',')}" />
                                        
                                        <strong>${fn:length(titles)} different books</strong>
                                    </div>
                                    <div class="books-list">
                                        <c:forEach var="i" begin="0" end="${fn:length(titles) - 1}">
                                            <c:if test="${i < fn:length(titles) && i < fn:length(quantities)}">
                                                <div class="book-item">
                                                    <strong>${titles[i]}</strong> (Qty: ${quantities[i]})
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </td>
                                <td>
                                    <strong>${order.total_items} items</strong>
                                </td>
                                <td>
                                    <div class="total-amount">
                                        LKR <fmt:formatNumber value="${order.total_amount}" pattern="#,##0.00" />
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <div style="text-align: center;">
        <a href="<c:url value='/pages/dashboard.jsp' />" class="back-link">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
    </div>
 <script src="${pageContext.request.contextPath}/js/orderHistory.js"></script>
</body>
</html>