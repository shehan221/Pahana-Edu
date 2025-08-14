<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Items CRUD</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/iteamCrud.css">
</head>
<body>

<!-- Navigation Bar -->
 <nav class="navbar">
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/dashboard">Home</a>
            <a href="#books-section">Books</a>
            <a href="adminDashboard">Admin pannel</a>
            <a href="#">feedback check</a>
            <!-- Admin-specific navigation -->
            <c:if test="${sessionScope.user.role == 'admin'}">
                <a href="${pageContext.request.contextPath}/admindashboard.jsp" style="color: #f59e0b; font-weight: 600;">
                    <i class="fas fa-cogs"></i> Admin Panel
                </a>
            </c:if>
        </div>
    </nav>
<h1 id="home">📚 Items CRUD</h1>

<%
    String url = "jdbc:mysql://localhost:3306/bookstore_db";
    String user = "root";
    String pass = "123456";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        // CREATE
        if ("add".equals(request.getParameter("action"))) {
            conn = DriverManager.getConnection(url, user, pass);
            ps = conn.prepareStatement("INSERT INTO items (item_code, title, author, category, price, quantity, description, publisher, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, request.getParameter("item_code"));
            ps.setString(2, request.getParameter("title"));
            ps.setString(3, request.getParameter("author"));
            ps.setString(4, request.getParameter("category"));
            ps.setDouble(5, Double.parseDouble(request.getParameter("price")));
            ps.setInt(6, Integer.parseInt(request.getParameter("quantity")));
            ps.setString(7, request.getParameter("description"));
            ps.setString(8, request.getParameter("publisher"));
            ps.setString(9, request.getParameter("image_url"));
            ps.setBoolean(10, true);
            ps.executeUpdate();
            out.println("<p style='color:green;'>Item added successfully!</p>");
        }

        // DELETE
        if ("delete".equals(request.getParameter("action"))) {
            conn = DriverManager.getConnection(url, user, pass);
            ps = conn.prepareStatement("DELETE FROM items WHERE item_id=?");
            ps.setInt(1, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            out.println("<p style='color:red;'>Item deleted successfully!</p>");
        }

        // UPDATE
        if ("update".equals(request.getParameter("action"))) {
            conn = DriverManager.getConnection(url, user, pass);
            ps = conn.prepareStatement("UPDATE items SET item_code=?, title=?, author=?, category=?, price=?, quantity=?, description=?, publisher=?, image_url=? WHERE item_id=?");
            ps.setString(1, request.getParameter("item_code"));
            ps.setString(2, request.getParameter("title"));
            ps.setString(3, request.getParameter("author"));
            ps.setString(4, request.getParameter("category"));
            ps.setDouble(5, Double.parseDouble(request.getParameter("price")));
            ps.setInt(6, Integer.parseInt(request.getParameter("quantity")));
            ps.setString(7, request.getParameter("description"));
            ps.setString(8, request.getParameter("publisher"));
            ps.setString(9, request.getParameter("image_url"));
            ps.setInt(10, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            out.println("<p style='color:blue;'>Item updated successfully!</p>");
        }

    } catch(Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (ps != null) ps.close(); if (conn != null) conn.close(); } catch(Exception ex) {}
    }
%>

<!-- Add Form -->
<h2>Add New Item</h2>
<form method="post">
    <input type="hidden" name="action" value="add">
    <input type="text" name="item_code" placeholder="Item Code" required>
    <input type="text" name="title" placeholder="Title" required>
    <input type="text" name="author" placeholder="Author">
    <input type="text" name="category" placeholder="Category">
    <input type="number" step="0.01" name="price" placeholder="Price" required>
    <input type="number" name="quantity" placeholder="Quantity">
    <input type="text" name="publisher" placeholder="Publisher">
    <input type="text" name="image_url" placeholder="Image URL">
    <textarea name="description" placeholder="Description"></textarea>
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
        <td><img src="<%= request.getContextPath() + imageUrl %>" width="60" alt="Item Image"></td>
        <td>
            <button class="btn-edit" onclick="openEditModal(
                '<%= rs.getInt("item_id") %>',
                '<%= rs.getString("item_code") %>',
                '<%= rs.getString("title").replace("'", "\\'") %>',
                '<%= rs.getString("author").replace("'", "\\'") %>',
                '<%= rs.getString("category") %>',
                '<%= rs.getDouble("price") %>',
                '<%= rs.getInt("quantity") %>',
                '<%= rs.getString("publisher") %>',
                '<%= rs.getString("image_url").replace("'", "\\'") %>',
                '<%= rs.getString("description").replace("'", "\\'") %>'
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
        <form method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="edit_id">
            <input type="text" name="item_code" id="edit_item_code" placeholder="Item Code" required>
            <input type="text" name="title" id="edit_title" placeholder="Title" required>
            <input type="text" name="author" id="edit_author" placeholder="Author">
            <input type="text" name="category" id="edit_category" placeholder="Category">
            <input type="number" step="0.01" name="price" id="edit_price" placeholder="Price" required>
            <input type="number" name="quantity" id="edit_quantity" placeholder="Quantity">
            <input type="text" name="publisher" id="edit_publisher" placeholder="Publisher">
            <input type="text" name="image_url" id="edit_image_url" placeholder="Image URL">
            <textarea name="description" id="edit_description" placeholder="Description"></textarea>
            <button type="submit" class="btn">Update Item</button>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/iteamCrud.js"></script>
</body>
</html>
