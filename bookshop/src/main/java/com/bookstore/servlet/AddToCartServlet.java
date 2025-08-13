package com.bookstore.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String price = request.getParameter("price");
        String image = request.getParameter("image");

        HttpSession session = request.getSession();
        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        Map<String, String> item = new HashMap<>();
        item.put("title", title);
        item.put("price", price);
        item.put("image", image);

        cart.add(item);
        session.setAttribute("cart", cart);

        response.sendRedirect(request.getContextPath() + "/pages/dashboard.jsp");
    }
}
