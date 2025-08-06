package com.bookstore.servlet;

import com.bookstore.dao.CustomerDAO;
import com.bookstore.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/customer")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CustomerDAO customerDAO;
    
    @Override
    public void init() throws ServletException {
        customerDAO = new CustomerDAO();
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
                    showCustomerDetails(request, response);
                    break;
                case "delete":
                    deleteCustomer(request, response);
                    break;
                case "search":
                    searchCustomers(request, response);
                    break;
                case "list":
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in CustomerServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/pages/customer-list.jsp").forward(request, response);
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
                    insertCustomer(request, response);
                    break;
                case "update":
                    updateCustomer(request, response);
                    break;
                case "search":
                    searchCustomers(request, response);
                    break;
                default:
                    listCustomers(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in CustomerServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/pages/customer-list.jsp").forward(request, response);
        }
    }
    
    private void listCustomers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Customer> customers = customerDAO.selectAllCustomers();
        request.setAttribute("customers", customers);
        request.getRequestDispatcher("/pages/customer-list.jsp").forward(request, response);
    }
    
    private void showNewForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Generate unique account number
        String accountNumber = customerDAO.generateAccountNumber();
        request.setAttribute("accountNumber", accountNumber);
        request.getRequestDispatcher("/pages/add-customer.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int customerId = Integer.parseInt(request.getParameter("id"));
        Customer customer = customerDAO.selectCustomerById(customerId);
        
        if (customer != null) {
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/pages/edit-customer.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Customer not found");
            listCustomers(request, response);
        }
    }
    
    private void showCustomerDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int customerId = Integer.parseInt(request.getParameter("id"));
        Customer customer = customerDAO.selectCustomerById(customerId);
        
        if (customer != null) {
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/pages/customer-details.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Customer not found");
            listCustomers(request, response);
        }
    }
    
    private void insertCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String accountNumber = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephoneNumber = request.getParameter("telephoneNumber");
        String email = request.getParameter("email");
        
        // Validate input
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Customer name is required");
            request.setAttribute("accountNumber", accountNumber);
            request.getRequestDispatcher("/pages/add-customer.jsp").forward(request, response);
            return;
        }
        
        // Check if account number already exists
        if (customerDAO.accountNumberExists(accountNumber)) {
            request.setAttribute("errorMessage", "Account number already exists");
            request.setAttribute("accountNumber", customerDAO.generateAccountNumber());
            request.getRequestDispatcher("/pages/add-customer.jsp").forward(request, response);
            return;
        }
        
        try {
            // Create new customer
            Customer customer = new Customer(accountNumber, name.trim(), address, telephoneNumber, email);
            
            if (customerDAO.insertCustomer(customer)) {
                request.setAttribute("successMessage", "Customer added successfully");
                listCustomers(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to add customer");
                request.setAttribute("accountNumber", accountNumber);
                request.setAttribute("name", name);
                request.setAttribute("address", address);
                request.setAttribute("telephoneNumber", telephoneNumber);
                request.setAttribute("email", email);
                request.getRequestDispatcher("/pages/add-customer.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error inserting customer: " + e.getMessage());
            request.setAttribute("errorMessage", "Error adding customer: " + e.getMessage());
            request.getRequestDispatcher("/pages/add-customer.jsp").forward(request, response);
        }
    }
    
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String accountNumber = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String telephoneNumber = request.getParameter("telephoneNumber");
        String email = request.getParameter("email");
        double totalPurchases = Double.parseDouble(request.getParameter("totalPurchases"));
        
        // Validate input
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Customer name is required");
            Customer customer = customerDAO.selectCustomerById(customerId);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/pages/edit-customer.jsp").forward(request, response);
            return;
        }
        
        try {
            // Create customer object with updated data
            Customer customer = new Customer(customerId, accountNumber, name.trim(), address, 
                                           telephoneNumber, email, totalPurchases, true);
            
            if (customerDAO.updateCustomer(customer)) {
                request.setAttribute("successMessage", "Customer updated successfully");
                listCustomers(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to update customer");
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/pages/edit-customer.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error updating customer: " + e.getMessage());
            request.setAttribute("errorMessage", "Error updating customer: " + e.getMessage());
            Customer customer = customerDAO.selectCustomerById(customerId);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/pages/edit-customer.jsp").forward(request, response);
        }
    }
    
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int customerId = Integer.parseInt(request.getParameter("id"));
        
        try {
            if (customerDAO.deleteCustomer(customerId)) {
                request.setAttribute("successMessage", "Customer deleted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to delete customer");
            }
        } catch (Exception e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            request.setAttribute("errorMessage", "Error deleting customer: " + e.getMessage());
        }
        
        listCustomers(request, response);
    }
    
    private void searchCustomers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String searchTerm = request.getParameter("searchTerm");
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            List<Customer> customers = customerDAO.searchCustomers(searchTerm.trim());
            request.setAttribute("customers", customers);
            request.setAttribute("searchTerm", searchTerm);
            
            if (customers.isEmpty()) {
                request.setAttribute("infoMessage", "No customers found for: " + searchTerm);
            }
        } else {
            listCustomers(request, response);
            return;
        }
        
        request.getRequestDispatcher("/pages/customer-list.jsp").forward(request, response);
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