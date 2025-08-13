<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<%
// Handle Add to Cart functionality
boolean cartOperationPerformed = false;
if ("POST".equals(request.getMethod()) && request.getParameter("action") != null) {
    String action = request.getParameter("action");
    cartOperationPerformed = true;
    
    if ("addToCart".equals(action)) {
        java.util.List<java.util.Map<String, Object>> cart = 
            (java.util.List<java.util.Map<String, Object>>) session.getAttribute("cart");
        
        if (cart == null) {
            cart = new java.util.ArrayList<java.util.Map<String, Object>>();
        }
        
        String title = request.getParameter("title");
        String priceStr = request.getParameter("price");
        String imageUrl = request.getParameter("image");
        
        try {
            double price = Double.parseDouble(priceStr);
            
            // Check if item already exists in cart
            boolean itemExists = false;
            for (java.util.Map<String, Object> item : cart) {
                if (title.equals(item.get("title"))) {
                    // Increase quantity if item exists
                    int currentQuantity = (Integer) item.get("quantity");
                    item.put("quantity", currentQuantity + 1);
                    itemExists = true;
                    break;
                }
            }
            
            // Add new item if it doesn't exist
            if (!itemExists) {
                java.util.Map<String, Object> cartItem = new java.util.HashMap<String, Object>();
                cartItem.put("title", title);
                cartItem.put("price", price);
                cartItem.put("image", imageUrl);
                cartItem.put("quantity", 1);
                cart.add(cartItem);
            }
            
            // Update cart in session
            session.setAttribute("cart", cart);
            session.setAttribute("cartMessage", "Item added to cart successfully!");
            
        } catch (NumberFormatException e) {
            session.setAttribute("cartError", "Invalid price format");
        }
    }
    
    if ("removeFromCart".equals(action)) {
        java.util.List<java.util.Map<String, Object>> cart = 
            (java.util.List<java.util.Map<String, Object>>) session.getAttribute("cart");
        
        if (cart != null) {
            String titleToRemove = request.getParameter("title");
            cart.removeIf(item -> titleToRemove.equals(item.get("title")));
            session.setAttribute("cart", cart);
            session.setAttribute("cartMessage", "Item removed from cart!");
        }
    }
    
    if ("updateQuantity".equals(action)) {
        java.util.List<java.util.Map<String, Object>> cart = 
            (java.util.List<java.util.Map<String, Object>>) session.getAttribute("cart");
        
        if (cart != null) {
            String title = request.getParameter("title");
            String quantityStr = request.getParameter("quantity");
            
            try {
                int quantity = Integer.parseInt(quantityStr);
                if (quantity <= 0) {
                    cart.removeIf(item -> title.equals(item.get("title")));
                } else {
                    for (java.util.Map<String, Object> item : cart) {
                        if (title.equals(item.get("title"))) {
                            item.put("quantity", quantity);
                            break;
                        }
                    }
                }
                session.setAttribute("cart", cart);
            } catch (NumberFormatException e) {
                session.setAttribute("cartError", "Invalid quantity");
            }
        }
    }
    
    if ("clearCart".equals(action)) {
        session.removeAttribute("cart");
        session.setAttribute("cartMessage", "Cart cleared!");
        cartOperationPerformed = false; // Don't reopen cart for clear operation
    }
}

// Calculate cart total and item count
double cartTotal = 0.0;
int cartItemCount = 0;
java.util.List<java.util.Map<String, Object>> cart = 
    (java.util.List<java.util.Map<String, Object>>) session.getAttribute("cart");

if (cart != null) {
    for (java.util.Map<String, Object> item : cart) {
        double price = (Double) item.get("price");
        int quantity = (Integer) item.get("quantity");
        cartTotal += price * quantity;
        cartItemCount += quantity;
    }
}

pageContext.setAttribute("cartTotal", cartTotal);
pageContext.setAttribute("cartItemCount", cartItemCount);
pageContext.setAttribute("cartOperationPerformed", cartOperationPerformed);
%>

<sql:setDataSource var="ds" driver="com.mysql.cj.jdbc.Driver"
                   url="jdbc:mysql://localhost:3306/bookstore_db"
                   user="root" password="123456" />

<sql:query dataSource="${ds}" var="books">
    SELECT title, price, image_url 
    FROM items 
    WHERE is_active = TRUE
    ORDER BY created_at DESC;
</sql:query>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu - Dashboard</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        /* Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: 'Inter', sans-serif; 
            background: #f9fafb; 
            line-height: 1.6;
        }

        /* Header Styles */
        .header {
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            position: sticky;
            top: 0;
            z-index: 1000;
            padding: 1rem 2rem;
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            align-items: center;
            transition: all 0.3s ease;
        }

        .header.shrink {
            padding: 0.75rem 2rem;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            backdrop-filter: blur(10px);
        }

        /* Logo Styles */
        .header .logo { 
            font-family: 'Playfair Display', serif; 
            font-size: 1.8rem; 
            font-weight: 700; 
            color: #059669; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
            text-decoration: none;
            transition: transform 0.3s ease;
        }

        .header.shrink .logo {
            transform: scale(0.9);
        }

        /* Cart Icon Styles */
        .cart-icon {
            text-align: center;
            position: relative;
        }

        .cart-link {
            color: #374151;
            text-decoration: none;
            font-size: 1.5rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .cart-link:hover {
            color: #059669;
            transform: scale(1.1);
        }

        .cart-badge {
            position: absolute;
            top: -8px;
            right: -10px;
            background: #ef4444;
            color: white;
            border-radius: 50%;
            font-size: 0.75rem;
            padding: 2px 6px;
            font-weight: bold;
            min-width: 18px;
            height: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Profile Styles */
        .user-info {
            justify-self: end;
        }

        .profile-link {
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            color: #374151;
            transition: transform 0.3s ease;
        }

        .profile-link:hover {
            transform: translateY(-1px);
        }

        .profile-img {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e5e7eb;
            transition: border-color 0.3s ease;
        }

        .profile-link:hover .profile-img {
            border-color: #059669;
        }

        .admin-badge { 
            background: #fef3c7; 
            color: #92400e; 
            padding: 2px 8px; 
            border-radius: 12px; 
            font-size: 10px; 
            margin-left: 8px; 
            font-weight: 600; 
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Navigation Styles */
        .navbar { 
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: 16px 20px; 
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            border-bottom: 1px solid #e2e8f0;
            position: sticky;
            top: 73px;
            z-index: 999;
            transition: top 0.3s ease;
        }

        .navbar.shrink-nav {
            top: 65px;
        }

        .nav-links { 
            display: flex; 
            justify-content: center; 
            gap: 40px; 
            max-width: 1200px;
            margin: 0 auto;
        }

        .nav-links a { 
            text-decoration: none; 
            color: #475569; 
            font-size: 15px; 
            font-weight: 500; 
            transition: all 0.3s ease;
            padding: 8px 16px;
            border-radius: 8px;
            position: relative;
        }

        .nav-links a:hover { 
            color: #059669; 
            background: rgba(5, 150, 105, 0.1);
            transform: translateY(-1px);
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 50%;
            width: 0;
            height: 2px;
            background: #059669;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-links a:hover::after {
            width: 80%;
        }

        /* Add to Cart Button Styles */
        .cart-btn {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            color: white;
            border: none;
            border-radius: 10px;
            padding: 12px 18px;
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.3);
            transition: all 0.3s ease;
            width: 100%;
            justify-content: center;
        }

        .cart-btn i {
            font-size: 1rem;
            transition: transform 0.3s ease;
        }

        .cart-btn:hover {
            background: linear-gradient(135deg, #047857 0%, #065f46 100%);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(5, 150, 105, 0.4);
        }

        .cart-btn:hover i {
            transform: scale(1.1);
        }

        .cart-btn:active {
            transform: translateY(0);
            box-shadow: 0 4px 15px rgba(5, 150, 105, 0.3);
        }

        /* Main Content Styles */
        .main { 
            max-width: 1200px; 
            margin: 2rem auto; 
            padding: 0 2rem; 
        }

        /* Hero Section Styles */
        .hero { 
            margin-top: 2rem; 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 3rem; 
            align-items: center; 
            margin-bottom: 4rem; 
        }

        .hero img { 
            width: 100%; 
            max-height: 400px;
            object-fit: cover;
            border-radius: 20px; 
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            transition: transform 0.3s ease;
        }

        .hero img:hover {
            transform: scale(1.02);
        }

        .hero h1 { 
            font-size: 3.2rem; 
            font-family: 'Playfair Display', serif; 
            color: #1f2937;
            line-height: 1.2;
            margin-bottom: 1rem;
        }

        .hero p { 
            font-size: 1.1rem; 
            color: #6b7280; 
            margin-top: 1rem;
            line-height: 1.7;
        }

        /* Books Section Styles */
        .books-section { 
            margin-top: 5rem; 
        }

        .books-section h2 { 
            font-family: 'Playfair Display', serif; 
            font-size: 2.5rem; 
            text-align: center; 
            margin-bottom: 3rem; 
            color: #111827; 
            position: relative; 
        }

        .books-section h2::after { 
            content: ''; 
            position: absolute; 
            bottom: -15px; 
            left: 50%; 
            transform: translateX(-50%); 
            width: 80px; 
            height: 4px; 
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            border-radius: 2px;
        }

        .book-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
            gap: 2rem; 
        }

        .book-card { 
            background: #fff; 
            border-radius: 20px; 
            overflow: hidden; 
            box-shadow: 0 8px 30px rgba(0,0,0,0.1); 
            transition: all 0.3s ease;
            border: 1px solid #f1f5f9;
        }

        .book-card:hover { 
            transform: translateY(-8px); 
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }

        .book-card img { 
            width: 100%; 
            height: 250px; 
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .book-card:hover img {
            transform: scale(1.02);
        }

        .book-info { 
            padding: 1.25rem; 
        }

        .book-info h3 { 
            font-size: 1.1rem; 
            margin-bottom: 0.6rem; 
            color: #1f2937;
            font-weight: 600;
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .book-info p { 
            color: #059669; 
            font-weight: 700;
            font-size: 1rem;
            margin-bottom: 1rem;
        }

        /* Footer Styles */
        footer { 
            text-align: center; 
            padding: 3rem 2rem; 
            background: linear-gradient(135deg, #1f2937 0%, #111827 100%);
            color: #d1d5db; 
            margin-top: 5rem;
            font-size: 0.95rem;
        }

        /* Admin Alert Styles */
        .admin-alert {
            margin-top: 1.5rem; 
            padding: 1.2rem; 
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            border-left: 4px solid #f59e0b; 
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.2);
        }

        .admin-alert p {
            color: #92400e; 
            font-weight: 600; 
            margin: 0;
        }

        .admin-alert a {
            color: #92400e; 
            text-decoration: underline;
            transition: color 0.3s ease;
        }

        .admin-alert a:hover {
            color: #78350f;
        }

        /* Cart Modal Styles */
        .cart-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 10000;
            display: none;
            align-items: center;
            justify-content: center;
        }

        .cart-modal.show {
            display: flex;
        }

        .cart-content {
            background: white;
            border-radius: 20px;
            width: 90%;
            max-width: 600px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
        }

        .cart-header {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .cart-header h2 {
            font-family: 'Playfair Display', serif;
            color: #1f2937;
            margin: 0;
        }

        .close-cart {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #6b7280;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .close-cart:hover {
            color: #ef4444;
        }

        .cart-body {
            padding: 1.5rem 2rem;
        }

        .cart-item {
            display: grid;
            grid-template-columns: 80px 1fr auto auto;
            gap: 1rem;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f3f4f6;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .cart-item img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 10px;
        }

        .cart-item-info h4 {
            color: #1f2937;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .cart-item-info p {
            color: #059669;
            font-weight: 600;
            margin: 0;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .quantity-btn {
            background: #f3f4f6;
            border: none;
            width: 30px;
            height: 30px;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.3s ease;
        }

        .quantity-btn:hover {
            background: #e5e7eb;
        }

        .quantity-input {
            width: 40px;
            text-align: center;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            padding: 4px;
        }

        .remove-btn {
            background: #fef2f2;
            color: #ef4444;
            border: 1px solid #fecaca;
            border-radius: 6px;
            padding: 0.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .remove-btn:hover {
            background: #fee2e2;
        }

        .cart-footer {
            padding: 1.5rem 2rem;
            border-top: 1px solid #e5e7eb;
            background: #f9fafb;
        }

        .cart-total {
            text-align: center;
            margin-bottom: 1rem;
        }

        .cart-total h3 {
            color: #1f2937;
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
        }

        .cart-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
        }

        .checkout-btn {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(5, 150, 105, 0.4);
        }

        .clear-btn {
            background: #f3f4f6;
            color: #374151;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .clear-btn:hover {
            background: #e5e7eb;
        }

        .empty-cart {
            text-align: center;
            padding: 3rem 2rem;
            color: #6b7280;
        }

        .empty-cart i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #d1d5db;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1rem;
            font-weight: 500;
        }

        .alert-success {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* Responsive Design */
        @media (max-width: 768px) { 
            .hero { 
                grid-template-columns: 1fr; 
                text-align: center;
                gap: 2rem;
            } 
            
            .hero h1 { 
                font-size: 2.5rem; 
            } 
            
            .main { 
                padding: 0 1rem; 
            }
            
            .header {
                padding: 1rem;
                grid-template-columns: auto 1fr auto;
                gap: 1rem;
            }
            
            .nav-links {
                gap: 20px;
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .nav-links a {
                font-size: 14px;
                padding: 6px 12px;
            }
            
            .book-grid {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 1.5rem;
            }
            
            .books-section h2 {
                font-size: 2rem;
            }

            .cart-item {
                grid-template-columns: 60px 1fr;
                gap: 0.75rem;
            }

            .quantity-control,
            .remove-btn {
                grid-column: 1 / -1;
                justify-self: start;
                margin-top: 0.5rem;
            }
        }

        @media (max-width: 480px) {
            .header {
                padding: 0.75rem;
            }
            
            .header .logo {
                font-size: 1.5rem;
            }
            
            .navbar {
                padding: 12px;
            }
            
            .nav-links {
                gap: 15px;
            }
            
            .hero h1 {
                font-size: 2rem;
            }
            
            .book-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>

    <!-- Role Handling -->
    <c:choose>
        <c:when test="${fn:toLowerCase(sessionScope.user.role) == 'admin'}">
            <c:set var="userPageUrl" value="${pageContext.request.contextPath}/pages/profile.jsp" />
        </c:when>
        <c:otherwise>
            <c:set var="userPageUrl" value="${pageContext.request.contextPath}/pages/profile.jsp" />
        </c:otherwise>
    </c:choose>

    <!-- Header -->
    <header class="header">
        <!-- Logo -->
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

        <!-- Cart Icon (center) -->
        <div class="cart-icon">
            <span class="cart-link" onclick="toggleCart()">
                <i class="fas fa-shopping-cart"></i>
                <c:if test="${cartItemCount > 0}">
                    <span class="cart-badge">${cartItemCount}</span>
                </c:if>
            </span>
        </div>

        <!-- Profile (right) -->
        <div class="user-info">
            <a href="${userPageUrl}" class="profile-link">
                <img src="<c:url value='/images/dashboard/profile.png' />" alt="User Icon" class="profile-img">
                <span>
                    <c:out value="${sessionScope.user.username}" default="Guest" />
                    <c:if test="${fn:toLowerCase(sessionScope.user.role) == 'admin'}">
                        <span class="admin-badge"><i class="fas fa-shield-alt"></i> ADMIN</span>
                    </c:if>
                </span>
            </a>
        </div>
    </header>

    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/pages/dashboard.jsp">Home</a>
            <a href="#books-section">Books</a>
            <a href="${pageContext.request.contextPath}/pages/about.jsp">About</a>
            <a href="${pageContext.request.contextPath}/pages/feedback.jsp">Feedback</a>
            <c:if test="${sessionScope.user.role == 'admin'}">
                <a href="${pageContext.request.contextPath}/pages/adminDashboard.jsp" style="color: #f59e0b; font-weight: 600;">
                    <i class="fas fa-cogs"></i> Admin Panel
                </a>
            </c:if>
        </div>
    </nav>

    <!-- Cart Modal -->
    <div class="cart-modal" id="cartModal">
        <div class="cart-content">
            <div class="cart-header">
                <h2><i class="fas fa-shopping-cart"></i> Shopping Cart</h2>
                <button class="close-cart" onclick="toggleCart()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div class="cart-body">
                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.cartMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> ${sessionScope.cartMessage}
                    </div>
                    <c:remove var="cartMessage" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.cartError}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i> ${sessionScope.cartError}
                    </div>
                    <c:remove var="cartError" scope="session" />
                </c:if>

                <c:choose>
                    <c:when test="${empty sessionScope.cart}">
                        <div class="empty-cart">
                            <i class="fas fa-shopping-cart"></i>
                            <h3>Your cart is empty</h3>
                            <p>Add some books to get started!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${sessionScope.cart}">
                            <div class="cart-item">
                                <img src="<c:url value='${item.image}' />" alt="${item.title}">
                                <div class="cart-item-info">
                                    <h4>${item.title}</h4>
                                    <p>LKR ${item.price}</p>
                                </div>
                                <div class="quantity-control">
                                    <form method="post" style="display: inline;" onsubmit="return keepCartOpen(this);">
                                        <input type="hidden" name="action" value="updateQuantity">
                                        <input type="hidden" name="title" value="${item.title}">
                                        <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                        <button type="submit" class="quantity-btn">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                    </form>
                                    <span class="quantity-input">${item.quantity}</span>
                                    <form method="post" style="display: inline;" onsubmit="return keepCartOpen(this);">
                                        <input type="hidden" name="action" value="updateQuantity">
                                        <input type="hidden" name="title" value="${item.title}">
                                        <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                        <button type="submit" class="quantity-btn">
                                            <i class="fas fa-plus"></i>
                                        </button>
                                    </form>
                                </div>
                                <form method="post" style="display: inline;" onsubmit="return keepCartOpen(this);">
                                    <input type="hidden" name="action" value="removeFromCart">
                                    <input type="hidden" name="title" value="${item.title}">
                                    <button type="submit" class="remove-btn">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <c:if test="${not empty sessionScope.cart}">
                <div class="cart-footer">
                    <div class="cart-total">
                        <h3>Total: LKR <span id="cartTotal">${cartTotal}</span></h3>
                        <p>${cartItemCount} items in cart</p>
                    </div>
                    <div class="cart-actions">
                        <button class="checkout-btn" onclick="checkout()">
                            <i class="fas fa-credit-card"></i> Checkout
                        </button>
                        <form method="post" style="display: inline;">
                            <input type="hidden" name="action" value="clearCart">
                            <button type="submit" class="clear-btn">
                                <i class="fas fa-trash"></i> Clear Cart
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Main -->
    <main class="main">
        <!-- Hero -->
        <section class="hero">
            <div>
                <h1>Explore Knowledge with Pahana Edu</h1>
                <p>Serving the heart of Colombo with quality books, smart billing, and modern inventory systems.</p>
                <c:if test="${sessionScope.user.role == 'admin'}">
                    <div class="admin-alert">
                        <p>
                            <i class="fas fa-crown"></i> Welcome Administrator! 
                            <a href="${pageContext.request.contextPath}/admindashboard.jsp">
                                Access Admin Dashboard
                            </a>
                        </p>
                    </div>
                </c:if>
            </div>
            <img src="<c:url value='/images/dashboard/bookshop.png' />" alt="Bookstore Image">
        </section>

        <!-- Books -->
        <section class="books-section" id="books-section">
            <h2>Popular Books</h2>
            <div class="book-grid">
                <c:forEach var="book" items="${books.rows}">
                    <div class="book-card">
                        <img src="<c:url value='${book.image_url}' />" alt="${book.title}">
                        <div class="book-info">
                            <h3>${book.title}</h3>
                            <p>LKR ${book.price}</p>

                            <!-- Add to Cart Button -->
                            <c:if test="${not empty sessionScope.user}">
                                <form method="post" onsubmit="return keepCartOpen(this);">
                                    <input type="hidden" name="action" value="addToCart">
                                    <input type="hidden" name="title" value="${book.title}">
                                    <input type="hidden" name="price" value="${book.price}">
                                    <input type="hidden" name="image" value="${book.image_url}">
                                    <button type="submit" class="cart-btn">
                                        <i class="fas fa-cart-plus"></i> Add to Cart
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer>
        <p>&copy; 2025 Pahana Edu Bookstore | All rights reserved | Version 2.0</p>
    </footer>

    <script>
        // Cart functionality
        function toggleCart() {
            const cartModal = document.getElementById('cartModal');
            cartModal.classList.toggle('show');
        }

        // Close cart when clicking outside
        document.getElementById('cartModal').addEventListener('click', function(e) {
            if (e.target === this) {
                toggleCart();
            }
        });

        // Keep cart open after form submissions
        function keepCartOpen(form) {
            // Add a flag to indicate cart operation
            const hiddenInput = document.createElement('input');
            hiddenInput.type = 'hidden';
            hiddenInput.name = 'keepCartOpen';
            hiddenInput.value = 'true';
            form.appendChild(hiddenInput);
            return true;
        }

        // Automatically reopen cart if there was a cart operation
        document.addEventListener('DOMContentLoaded', function() {
            const cartOperationPerformed = ${cartOperationPerformed};
            const urlParams = new URLSearchParams(window.location.search);
            const keepCartOpen = urlParams.get('keepCartOpen') === 'true' || 
                                 '${param.keepCartOpen}' === 'true' || 
                                 cartOperationPerformed;
            
            if (keepCartOpen) {
                setTimeout(function() {
                    document.getElementById('cartModal').classList.add('show');
                }, 100);
            }

            // Auto-close alerts after 3 seconds
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    alert.style.opacity = '0';
                    setTimeout(function() {
                        alert.remove();
                    }, 300);
                }, 3000);
            });
        });

        // Checkout function
       // Checkout function
function checkout() {
    // Check if cart has items
    const cartItemCount = ${cartItemCount};
    if (cartItemCount === 0) {
        alert('Your cart is empty! Please add some items before checkout.');
        return;
    }
    
    // Redirect to checkout page
    window.location.href = '${pageContext.request.contextPath}/pages/checkout.jsp';
}

        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            });
        });

        // Header shrinking effect on scroll
        document.addEventListener("scroll", function() {
            const header = document.querySelector(".header");
            const navbar = document.querySelector(".navbar");
            
            if (window.scrollY > 50) {
                header.classList.add("shrink");
                navbar.classList.add("shrink-nav");
            } else {
                header.classList.remove("shrink");
                navbar.classList.remove("shrink-nav");
            }
        });

        // Console logging (keep original functionality)
        console.log('Dashboard loaded for user:', '${sessionScope.user.username}');
        console.log('User role:', '${sessionScope.user.role}');
        console.log('Cart items:', ${cartItemCount});
        console.log('Cart total:', ${cartTotal});
        console.log('Cart operation performed:', ${cartOperationPerformed});
    </script>
</body>
</html>