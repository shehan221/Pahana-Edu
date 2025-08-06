package com.bookstore.servlet;

import com.bookstore.dao.CustomerDAO;
import com.bookstore.dao.ItemDAO;
import com.bookstore.dao.BillDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CustomerDAO customerDAO;
    private ItemDAO itemDAO;
    private BillDAO billDAO;
    
    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
        itemDAO = new ItemDAO();
        billDAO = new BillDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get dashboard statistics
            loadDashboardData(request);
            
            // Forward to dashboard page
            request.getRequestDispatcher("/pages/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading dashboard: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("errorMessage", "Error loading dashboard data");
            request.getRequestDispatcher("/pages/dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void loadDashboardData(HttpServletRequest request) {
        try {
            // Get counts and statistics
            int totalCustomers = customerDAO.getCustomerCount();
            int totalItems = itemDAO.getItemCount();
            int totalBills = billDAO.getBillCount();
            double totalSales = billDAO.getTotalSales();
            double inventoryValue = itemDAO.getTotalInventoryValue();
            
            // Get low stock items (items with quantity <= 5)
            var lowStockItems = itemDAO.getLowStockItems(5);
            
            // Set attributes for JSP
            request.setAttribute("totalCustomers", totalCustomers);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("totalBills", totalBills);
            request.setAttribute("totalSales", totalSales);
            request.setAttribute("inventoryValue", inventoryValue);
            request.setAttribute("lowStockItems", lowStockItems);
            request.setAttribute("lowStockCount", lowStockItems.size());
            
            System.out.println("Dashboard data loaded successfully");
            
        } catch (Exception e) {
            System.err.println("Error loading dashboard data: " + e.getMessage());
            e.printStackTrace();
            
            // Set default values in case of error
            request.setAttribute("totalCustomers", 0);
            request.setAttribute("totalItems", 0);
            request.setAttribute("totalBills", 0);
            request.setAttribute("totalSales", 0.0);
            request.setAttribute("inventoryValue", 0.0);
            request.setAttribute("lowStockCount", 0);
        }
    }
}