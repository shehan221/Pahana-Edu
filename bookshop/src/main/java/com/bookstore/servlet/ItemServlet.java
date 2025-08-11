package com.bookstore.servlet;

import com.bookstore.model.Item;
import com.bookstore.dao.ItemDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/items")
public class ItemServlet extends HttpServlet {

    private ItemDAO itemDAO;

    @Override
    public void init() throws ServletException {
        itemDAO = new ItemDAO(); // Make sure this DAO is implemented
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch all items and forward to JSP
        List<Item> items = itemDAO.getAllItems();
        request.setAttribute("items", items);
        request.getRequestDispatcher("/items.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            addItem(request);
        } else if ("delete".equalsIgnoreCase(action)) {
            deleteItem(request);
        }

        // Redirect to avoid resubmission issues
        response.sendRedirect("items");
    }

    private void addItem(HttpServletRequest request) {
        Item item = new Item();
        item.setItemCode(request.getParameter("item_code"));
        item.setTitle(request.getParameter("title"));
        item.setAuthor(request.getParameter("author"));
        item.setCategory(request.getParameter("category"));
        item.setPrice(Double.parseDouble(request.getParameter("price")));
        item.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        item.setPublisher(request.getParameter("publisher"));
        item.setIsbn(request.getParameter("isbn"));
        item.setDescription(request.getParameter("description"));

        itemDAO.addItem(item);
    }

    private void deleteItem(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        itemDAO.deleteItem(id);
    }
}
