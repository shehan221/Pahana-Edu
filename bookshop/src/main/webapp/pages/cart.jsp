<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Your Cart</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px; border-bottom: 1px solid #ddd; text-align: center; }
        th { background-color: #f4f4f4; }
        img { width: 80px; height: auto; }
        .total { font-weight: bold; font-size: 1.2rem; margin-top: 20px; text-align: right; }
    </style>
</head>
<body>
    <h1><i class="fas fa-shopping-cart"></i> Your Cart</h1>

    <c:if test="${empty sessionScope.cart}">
        <p>Your cart is empty.</p>
    </c:if>

    <c:if test="${not empty sessionScope.cart}">
        <table>
            <tr>
                <th>Book</th>
                <th>Price</th>
                <th>Image</th>
            </tr>
            <c:set var="total" value="0" />
            <c:forEach var="item" items="${sessionScope.cart}">
                <tr>
                    <td>${item.title}</td>
                    <td>LKR ${item.price}</td>
                    <td><img src="${item.image}" alt="${item.title}"></td>
                </tr>
                <c:set var="total" value="${total + item.price}" />
            </c:forEach>
        </table>

        <div class="total">
            Total: LKR ${total}
        </div>
    </c:if>
</body>
</html>
