<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Items CRUD</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/iteamCrud.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/iteamCrud.css">
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar">
    <div class="nav-links">
        <a href="<c:url value='/pages/dashboard.jsp' />" class="nav-link">
            <i class="fas fa-home"></i> Home
        </a>
        <a href="<c:url value='/pages/adminDashboard.jsp' />" class="nav-link">
            <i class="fas fa-book"></i>admin Dashboard
        </a>
        <a href="<c:url value='/pages/profile.jsp' />" class="nav-link">
            <i class="fas fa-comments"></i> profile
        </a>
        
        <!-- Admin-specific navigation -->
        <c:if test="${sessionScope.user.role == 'admin'}">
            <a href="<c:url value='/pages/adminDashboard.jsp' />" 
               class="nav-link admin-link">
                <i class="fas fa-cogs"></i> Admin Dashboard
            </a>
        </c:if>
        
        <div class="header-buttons">
            <a href="<c:url value='/pages/login.jsp' />" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
</nav>
<h1 id="home">📚 Pahana edu</h1>

<%
    String url = "jdbc:mysql://localhost:3306/bookstore_db";
    String user = "root";
    String pass = "123456";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    String errorMessage = "";
    String successMessage = "";
    boolean hasError = false;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // CREATE
        if ("add".equals(request.getParameter("action"))) {
            String itemCode = request.getParameter("item_code");
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");
            String description = request.getParameter("description");
            String publisher = request.getParameter("publisher");
            String imageUrl = request.getParameter("image_url");
            
            // Server-side validation
            StringBuilder errors = new StringBuilder();
            
            if (itemCode == null || itemCode.trim().isEmpty()) {
                errors.append("Item Code is required. ");
            } else if (itemCode.length() > 20) {
                errors.append("Item Code must be 20 characters or less. ");
            }
            
            if (title == null || title.trim().isEmpty()) {
                errors.append("Title is required. ");
            } else if (title.length() > 255) {
                errors.append("Title must be 255 characters or less. ");
            }
            
            if (priceStr == null || priceStr.trim().isEmpty()) {
                errors.append("Price is required. ");
            } else {
                try {
                    double price = Double.parseDouble(priceStr);
                    if (price < 0) {
                        errors.append("Price must be positive. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Price must be a valid number. ");
                }
            }
            
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                try {
                    int quantity = Integer.parseInt(quantityStr);
                    if (quantity < 0) {
                        errors.append("Quantity must be non-negative. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Quantity must be a valid number. ");
                }
            }
            
            // Image URL validation for update
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                String urlPattern = "^(https?://.*\\.(jpg|jpeg|png|gif|webp|bmp).*|/.*\\.(jpg|jpeg|png|gif|webp|bmp).*)$";
                if (!imageUrl.toLowerCase().matches(urlPattern)) {
                    errors.append("Image URL must be a valid image file (jpg, jpeg, png, gif, webp, bmp). ");
                }
            }
            
            // Image URL validation
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                String urlPattern = "^(https?://.*\\.(jpg|jpeg|png|gif|webp|bmp).*|/.*\\.(jpg|jpeg|png|gif|webp|bmp).*)$";
                if (!imageUrl.toLowerCase().matches(urlPattern)) {
                    errors.append("Image URL must be a valid image file (jpg, jpeg, png, gif, webp, bmp). ");
                }
            }
            
            // Check for duplicate item code
            if (itemCode != null && !itemCode.trim().isEmpty()) {
                conn = DriverManager.getConnection(url, user, pass);
                ps = conn.prepareStatement("SELECT COUNT(*) FROM items WHERE item_code = ?");
                ps.setString(1, itemCode.trim());
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    errors.append("Item Code already exists. ");
                }
                ps.close();
                rs.close();
            }
            
            if (errors.length() > 0) {
                errorMessage = errors.toString();
                hasError = true;
            } else {
                if (conn == null) conn = DriverManager.getConnection(url, user, pass);
                ps = conn.prepareStatement("INSERT INTO items (item_code, title, author, category, price, quantity, description, publisher, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                ps.setString(1, itemCode.trim());
                ps.setString(2, title.trim());
                ps.setString(3, author != null ? author.trim() : "");
                ps.setString(4, category != null ? category.trim() : "");
                ps.setDouble(5, Double.parseDouble(priceStr));
                ps.setInt(6, quantityStr != null && !quantityStr.trim().isEmpty() ? Integer.parseInt(quantityStr) : 0);
                ps.setString(7, description != null ? description.trim() : "");
                ps.setString(8, publisher != null ? publisher.trim() : "");
                ps.setString(9, imageUrl != null ? imageUrl.trim() : "");
                ps.setBoolean(10, true);
                ps.executeUpdate();
                successMessage = "Item added successfully!";
            }
        }

        // DELETE
        if ("delete".equals(request.getParameter("action"))) {
            String idStr = request.getParameter("id");
            try {
                if (idStr == null || idStr.trim().isEmpty()) {
                    throw new NumberFormatException("Invalid ID");
                }
                conn = DriverManager.getConnection(url, user, pass);
                ps = conn.prepareStatement("DELETE FROM items WHERE item_id=?");
                ps.setInt(1, Integer.parseInt(idStr));
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    successMessage = "Item deleted successfully!";
                } else {
                    errorMessage = "Item not found or could not be deleted.";
                    hasError = true;
                }
            } catch (NumberFormatException e) {
                errorMessage = "Invalid item ID for deletion.";
                hasError = true;
            }
        }

        // UPDATE
        if ("update".equals(request.getParameter("action"))) {
            String itemId = request.getParameter("id");
            String itemCode = request.getParameter("item_code");
            String title = request.getParameter("title");
            String author = request.getParameter("author");
            String category = request.getParameter("category");
            String priceStr = request.getParameter("price");
            String quantityStr = request.getParameter("quantity");
            String description = request.getParameter("description");
            String publisher = request.getParameter("publisher");
            String imageUrl = request.getParameter("image_url");
            
            // Server-side validation for update
            StringBuilder errors = new StringBuilder();
            
            if (itemId == null || itemId.trim().isEmpty()) {
                errors.append("Invalid item ID. ");
            }
            
            if (itemCode == null || itemCode.trim().isEmpty()) {
                errors.append("Item Code is required. ");
            } else if (itemCode.length() > 20) {
                errors.append("Item Code must be 20 characters or less. ");
            }
            
            if (title == null || title.trim().isEmpty()) {
                errors.append("Title is required. ");
            } else if (title.length() > 255) {
                errors.append("Title must be 255 characters or less. ");
            }
            
            if (priceStr == null || priceStr.trim().isEmpty()) {
                errors.append("Price is required. ");
            } else {
                try {
                    double price = Double.parseDouble(priceStr);
                    if (price < 0) {
                        errors.append("Price must be positive. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Price must be a valid number. ");
                }
            }
            
            if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                try {
                    int quantity = Integer.parseInt(quantityStr);
                    if (quantity < 0) {
                        errors.append("Quantity must be non-negative. ");
                    }
                } catch (NumberFormatException e) {
                    errors.append("Quantity must be a valid number. ");
                }
            }
            
            // Check for duplicate item code (excluding current item)
            if (itemCode != null && !itemCode.trim().isEmpty() && itemId != null && !itemId.trim().isEmpty()) {
                conn = DriverManager.getConnection(url, user, pass);
                ps = conn.prepareStatement("SELECT COUNT(*) FROM items WHERE item_code = ? AND item_id != ?");
                ps.setString(1, itemCode.trim());
                ps.setInt(2, Integer.parseInt(itemId));
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    errors.append("Item Code already exists. ");
                }
                ps.close();
                rs.close();
            }
            
            if (errors.length() > 0) {
                errorMessage = errors.toString();
                hasError = true;
            } else {
                if (conn == null) conn = DriverManager.getConnection(url, user, pass);
                ps = conn.prepareStatement("UPDATE items SET item_code=?, title=?, author=?, category=?, price=?, quantity=?, description=?, publisher=?, image_url=? WHERE item_id=?");
                ps.setString(1, itemCode.trim());
                ps.setString(2, title.trim());
                ps.setString(3, author != null ? author.trim() : "");
                ps.setString(4, category != null ? category.trim() : "");
                ps.setDouble(5, Double.parseDouble(priceStr));
                ps.setInt(6, quantityStr != null && !quantityStr.trim().isEmpty() ? Integer.parseInt(quantityStr) : 0);
                ps.setString(7, description != null ? description.trim() : "");
                ps.setString(8, publisher != null ? publisher.trim() : "");
                ps.setString(9, imageUrl != null ? imageUrl.trim() : "");
                ps.setInt(10, Integer.parseInt(itemId));
                int rowsAffected = ps.executeUpdate();
                if (rowsAffected > 0) {
                    successMessage = "Item updated successfully!";
                } else {
                    errorMessage = "Item not found or could not be updated.";
                    hasError = true;
                }
            }
        }

    } catch(Exception e) {
        errorMessage = "Error: " + e.getMessage();
        hasError = true;
    } finally {
        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (conn != null) conn.close(); } catch(Exception ex) {}
    }
%>

<!-- Display Messages -->
<% if (!successMessage.isEmpty()) { %>
    <div class="success-message">
        <i class="fas fa-check-circle"></i> <%= successMessage %>
    </div>
<% } %>

<% if (hasError && !errorMessage.isEmpty()) { %>
    <div class="error-message">
        <i class="fas fa-exclamation-triangle"></i> <%= errorMessage %>
    </div>
<% } %>

<!-- Add Form -->
<h2>Add New Item</h2>
<form method="post" onsubmit="return validateForm()">
    <input type="hidden" name="action" value="add">
    <input type="text" name="item_code" id="item_code" placeholder="Item Code" required maxlength="20" value="<%= request.getParameter("item_code") != null ? request.getParameter("item_code") : "" %>">
    <span class="field-error" id="item_code_error"></span>
    
    <input type="text" name="title" id="title" placeholder="Title" required maxlength="255" value="<%= request.getParameter("title") != null ? request.getParameter("title") : "" %>">
    <span class="field-error" id="title_error"></span>
    
    <input type="text" name="author" id="author" placeholder="Author" value="<%= request.getParameter("author") != null ? request.getParameter("author") : "" %>">
    <span class="field-error" id="author_error"></span>
    
    <input type="text" name="category" id="category" placeholder="Category" value="<%= request.getParameter("category") != null ? request.getParameter("category") : "" %>">
    <span class="field-error" id="category_error"></span>
    
    <input type="number" step="0.01" name="price" id="price" placeholder="Price" required min="0" value="<%= request.getParameter("price") != null ? request.getParameter("price") : "" %>">
    <span class="field-error" id="price_error"></span>
    
    <input type="number" name="quantity" id="quantity" placeholder="Quantity" min="0" value="<%= request.getParameter("quantity") != null ? request.getParameter("quantity") : "" %>">
    <span class="field-error" id="quantity_error"></span>
    
    <input type="text" name="publisher" id="publisher" placeholder="Publisher" value="<%= request.getParameter("publisher") != null ? request.getParameter("publisher") : "" %>">
    <span class="field-error" id="publisher_error"></span>
    
    <input type="text" name="image_url" id="image_url" placeholder="Image URL" value="<%= request.getParameter("image_url") != null ? request.getParameter("image_url") : "" %>">
    <span class="field-error" id="image_url_error"></span>
    
    <textarea name="description" id="description" placeholder="Description"><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
    <span class="field-error" id="description_error"></span>
    
    <button type="submit" class="btn">Add Item</button>
</form>

<!-- Items Table -->
<h2>Items List</h2>
<table>
    <tr>
        <th>ID</th><th>Code</th><th>Title</th><th>Author</th><th>Category</th>
        <th>Price</th><th>Qty</th><th>Publisher</th><th>Image</th><th>Actions</th>
    </tr>
<%
    try {
        conn = DriverManager.getConnection(url, user, pass);
        ps = conn.prepareStatement("SELECT * FROM items");
        rs = ps.executeQuery();
        while(rs.next()) {
            // Get and encode image URL
            String imageUrl = rs.getString("image_url");
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = "/images/default.png"; // fallback image
            } else {
                imageUrl = imageUrl.replace(" ", "%20"); // encode spaces
            }
            
            // Handle null values safely
            String title = rs.getString("title") != null ? rs.getString("title").replace("'", "\\'") : "";
            String author = rs.getString("author") != null ? rs.getString("author").replace("'", "\\'") : "";
            String publisher = rs.getString("publisher") != null ? rs.getString("publisher") : "";
            String description = rs.getString("description") != null ? rs.getString("description").replace("'", "\\'") : "";
            String imageUrlSafe = rs.getString("image_url") != null ? rs.getString("image_url").replace("'", "\\'") : "";
%>
    <tr>
        <td><%= rs.getInt("item_id") %></td>
        <td><%= rs.getString("item_code") %></td>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("author") %></td>
        <td><%= rs.getString("category") %></td>
        <td><%= rs.getDouble("price") %></td>
        <td><%= rs.getInt("quantity") %></td>
        <td><%= rs.getString("publisher") %></td>
        <td><img src="<%= request.getContextPath() + imageUrl %>" width="60" alt="Item Image" 
                 onerror="this.src='<%= request.getContextPath() %>/images/default.png'; this.style.border='2px solid #ff6b6b';" 
                 onload="this.style.border='none';" style="max-width:60px; max-height:60px; object-fit:cover;"></td>
        <td>
            <button class="btn-edit" onclick="openEditModal(
                '<%= rs.getInt("item_id") %>',
                '<%= rs.getString("item_code") %>',
                '<%= title %>',
                '<%= author %>',
                '<%= rs.getString("category") %>',
                '<%= rs.getDouble("price") %>',
                '<%= rs.getInt("quantity") %>',
                '<%= publisher %>',
                '<%= imageUrlSafe %>',
                '<%= description %>'
            )">Edit</button>
            <form method="post" style="display:inline;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%= rs.getInt("item_id") %>">
                <button type="submit" class="btn-danger" onclick="return confirm('Delete this item?')">Delete</button>
            </form>
        </td>
    </tr>
<%
        }
    } catch(Exception e) {
        out.println("Error loading items: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (conn != null) conn.close(); } catch(Exception ex) {}
    }
%>
</table>

<!-- Edit Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h2>Edit Item</h2>
        <form method="post" onsubmit="return validateEditForm()">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="edit_id">
            
            <input type="text" name="item_code" id="edit_item_code" placeholder="Item Code" required maxlength="20">
            <span class="field-error" id="edit_item_code_error"></span>
            
            <input type="text" name="title" id="edit_title" placeholder="Title" required maxlength="255">
            <span class="field-error" id="edit_title_error"></span>
            
            <input type="text" name="author" id="edit_author" placeholder="Author">
            <span class="field-error" id="edit_author_error"></span>
            
            <input type="text" name="category" id="edit_category" placeholder="Category">
            <span class="field-error" id="edit_category_error"></span>
            
            <input type="number" step="0.01" name="price" id="edit_price" placeholder="Price" required min="0">
            <span class="field-error" id="edit_price_error"></span>
            
            <input type="number" name="quantity" id="edit_quantity" placeholder="Quantity" min="0">
            <span class="field-error" id="edit_quantity_error"></span>
            
            <input type="text" name="publisher" id="edit_publisher" placeholder="Publisher">
            <span class="field-error" id="edit_publisher_error"></span>
            
            <input type="text" name="image_url" id="edit_image_url" placeholder="Image URL">
            <span class="field-error" id="edit_image_url_error"></span>
            
            <textarea name="description" id="edit_description" placeholder="Description"></textarea>
            <span class="field-error" id="edit_description_error"></span>
            
            <button type="submit" class="btn">Update Item</button>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/iteamCrud.js"></script>
</body>
</html>