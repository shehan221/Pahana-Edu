package com.bookstore.servlet;

import com.bookstore.dao.ItemDAO;
import com.bookstore.model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/item")
public class ItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private ItemDAO itemDAO;
    
    @Override
    public void init() throws ServletException {
        itemDAO = new ItemDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        if (!isUserLoggedIn(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "list") {
                case "new":
                    showNewForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    showItemDetails(request, response);
                    break;
                case "delete":
                    deleteItem(request, response);
                    break;
                case "search":
                    searchItems(request, response);
                    break;
                case "category":
                    filterByCategory(request, response);
                    break;
                case "lowstock":
                    showLowStockItems(request, response);
                    break;
                case "list":
                default:
                    listItems(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in ItemServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/pages/item-list.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        if (!isUserLoggedIn(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action != null ? action : "") {
                case "insert":
                    insertItem(request, response);
                    break;
                case "update":
                    updateItem(request, response);
                    break;
                case "search":
                    searchItems(request, response);
                    break;
                default:
                    listItems(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in ItemServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/pages/item-list.jsp").forward(request, response);
        }
    }
    
    private void listItems(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Item> items = itemDAO.selectAllItems();
        request.setAttribute("items", items);
        request.getRequestDispatcher("/pages/item-list.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Generate unique item code
        String itemCode = itemDAO.generateItemCode();
        request.setAttribute("itemCode", itemCode);
        request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int itemId = Integer.parseInt(request.getParameter("id"));
        Item item = itemDAO.selectItemById(itemId);
        
        if (item != null) {
            request.setAttribute("item", item);
            request.getRequestDispatcher("/pages/edit-item.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Item not found");
            listItems(request, response);
        }
    }
    
    private void showItemDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int itemId = Integer.parseInt(request.getParameter("id"));
        Item item = itemDAO.selectItemById(itemId);
        
        if (item != null) {
            request.setAttribute("item", item);
            request.getRequestDispatcher("/pages/item-details.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Item not found");
            listItems(request, response);
        }
    }
    
    private void insertItem(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String itemCode = request.getParameter("itemCode");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String description = request.getParameter("description");
        String publisher = request.getParameter("publisher");
        String isbn = request.getParameter("isbn");
        
        // Validate required fields
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Item title is required");
            request.setAttribute("itemCode", itemCode);
            request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
            return;
        }
        
        if (priceStr == null || priceStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Item price is required");
            setFormAttributes(request, itemCode, title, author, category, null, quantityStr, description, publisher, isbn);
            request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
            return;
        }
        
        // Check if item code already exists
        if (itemDAO.itemCodeExists(itemCode)) {
            request.setAttribute("errorMessage", "Item code already exists");
            request.setAttribute("itemCode", itemDAO.generateItemCode());
            setFormAttributes(request, null, title, author, category, priceStr, quantityStr, description, publisher, isbn);
            request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
            return;
        }
        
        try {
            double price = Double.parseDouble(priceStr);
            int quantity = quantityStr != null && !quantityStr.trim().isEmpty() ? 
                          Integer.parseInt(quantityStr) : 0;
            
            if (price < 0) {
                request.setAttribute("errorMessage", "Price cannot be negative");
                setFormAttributes(request, itemCode, title, author, category, priceStr, quantityStr, description, publisher, isbn);
                request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
                return;
            }
            
            if (quantity < 0) {
                request.setAttribute("errorMessage", "Quantity cannot be negative");
                setFormAttributes(request, itemCode, title, author, category, priceStr, quantityStr, description, publisher, isbn);
                request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
                return;
            }
            
            // Create new item
            Item item = new Item(itemCode, title.trim(), author, category, price, quantity);
            item.setDescription(description);
            item.setPublisher(publisher);
            item.setIsbn(isbn);
            
            if (itemDAO.insertItem(item)) {
                request.setAttribute("successMessage", "Item added successfully");
                listItems(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to add item");
                setFormAttributes(request, itemCode, title, author, category, priceStr, quantityStr, description, publisher, isbn);
                request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid price or quantity format");
            setFormAttributes(request, itemCode, title, author, category, priceStr, quantityStr, description, publisher, isbn);
            request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error inserting item: " + e.getMessage());
            request.setAttribute("errorMessage", "Error adding item: " + e.getMessage());
            request.getRequestDispatcher("/pages/add-item.jsp").forward(request, response);
        }
    }
    
    private void updateItem(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        int itemId = Integer.parseInt(request.getParameter("itemId"));
        String itemCode = request.getParameter("itemCode");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String description = request.getParameter("description");
        String publisher = request.getParameter("publisher");
        String isbn = request.getParameter("isbn");
        
        // Validate required fields
        if (title == null || title.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Item title is required");
            Item item = itemDAO.selectItemById(itemId);
            request.setAttribute("item", item);
            request.getRequestDispatcher("/pages/edit-item.jsp").forward(request, response);
            return;
        }
        
        try {
            double price = Double.parseDouble(priceStr);
            int quantity = Integer.parseInt(quantityStr);
            
            if (price < 0 || quantity < 0) {
                request.setAttribute("errorMessage", "Price and quantity cannot be negative");
                Item item = itemDAO.selectItemById(itemId);
                request.setAttribute("item", item);
                request.getRequestDispatcher("/pages/edit-item.jsp").forward(request, response);
                return;
            }
            
            // Create item object with updated data
            Item item = new Item(itemId, itemCode, title.trim(), author, category, 
                               price, quantity, description, publisher, isbn, true);
            
            if (itemDAO.updateItem(item)) {
                request.setAttribute("successMessage", "Item updated successfully");
                listItems(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to update item");
                request.setAttribute("item", item);
                request.getRequestDispatcher("/pages/edit-item.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid price or quantity format");
            Item item = itemDAO.selectItemById(itemId);
            request.setAttribute("item", item);
            request.getRequestDispatcher("/pages/edit-item.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("Error updating item: " + e.getMessage());
            request.setAttribute("errorMessage", "Error updating item: " + e.getMessage());
            Item item = itemDAO.selectItemById(itemId);
            request.setAttribute("item", item);
            request.getRequestDispatcher("/pages/edit-item.jsp").forward(request, response);
        }
    }
    
    private void deleteItem(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int itemId = Integer.parseInt(request.getParameter("id"));
        
        try {
            if (itemDAO.deleteItem(itemId)) {
                request.setAttribute("successMessage", "Item deleted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to delete item");
            }
        } catch (Exception e) {
            System.err.println("Error deleting item: " + e.getMessage());
            request.setAttribute("errorMessage", "Error deleting item: " + e.getMessage());
        }
        
        listItems(request, response);
    }
    
    private void searchItems(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("searchTerm");
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            List<Item> items = itemDAO.searchItems(searchTerm.trim());
            request.setAttribute("items", items);
            request.setAttribute("searchTerm", searchTerm);
            
            if (items.isEmpty()) {
                request.setAttribute("infoMessage", "No items found for: " + searchTerm);
            }
        } else {
            listItems(request, response);
            return;
        }
        
        request.getRequestDispatcher("/pages/item-list.jsp").forward(request, response);
    }
    
    private void filterByCategory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("category");
        
        if (category != null && !category.trim().isEmpty()) {
            List<Item> items = itemDAO.selectItemsByCategory(category.trim());
            request.setAttribute("items", items);
            request.setAttribute("selectedCategory", category);
            
            if (items.isEmpty()) {
                request.setAttribute("infoMessage", "No items found in category: " + category);
            }
        } else {
            listItems(request, response);
            return;
        }
        
        request.getRequestDispatcher("/pages/item-list.jsp").forward(request, response);
    }
    
    private void showLowStockItems(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int threshold = 5; // Low stock threshold
        List<Item> items = itemDAO.getLowStockItems(threshold);
        request.setAttribute("items", items);
        request.setAttribute("isLowStockView", true);
        
        if (items.isEmpty()) {
            request.setAttribute("infoMessage", "No low stock items found");
        }
        
        request.getRequestDispatcher("/pages/item-list.jsp").forward(request, response);
    }
    
    private void setFormAttributes(HttpServletRequest request, String itemCode, String title, 
                                  String author, String category, String price, String quantity,
                                  String description, String publisher, String isbn) {
        request.setAttribute("itemCode", itemCode);
        request.setAttribute("title", title);
        request.setAttribute("author", author);
        request.setAttribute("category", category);
        request.setAttribute("price", price);
        request.setAttribute("quantity", quantity);
        request.setAttribute("description", description);
        request.setAttribute("publisher", publisher);
        request.setAttribute("isbn", isbn);
    }
    
    private boolean isUserLoggedIn(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}