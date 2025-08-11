<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="BookServlet" method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="itemId" value="${book.itemId}">

    Item Code: <input type="text" name="itemCode" value="${book.itemCode}" required><br>
    Title: <input type="text" name="title" value="${book.title}" required><br>
    Author: <input type="text" name="author" value="${book.author}"><br>
    Category: <input type="text" name="category" value="${book.category}"><br>
    Price: <input type="number" step="0.01" name="price" value="${book.price}" required><br>
    Quantity: <input type="number" name="quantity" value="${book.quantity}" required><br>
    Description: <textarea name="description">${book.description}</textarea><br>
    Publisher: <input type="text" name="publisher" value="${book.publisher}"><br>
    ISBN: <input type="text" name="isbn" value="${book.isbn}"><br>
    Active: <input type="checkbox" name="isActive" value="true" ${book.active ? "checked" : ""}><br>

    <button type="submit">Update Book</button>
</form>

</body>
</html>