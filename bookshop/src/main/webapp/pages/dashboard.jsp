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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard_style.css">
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
            <a href="${pageContext.request.contextPath}/pages/aboutUs.jsp">About</a>
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