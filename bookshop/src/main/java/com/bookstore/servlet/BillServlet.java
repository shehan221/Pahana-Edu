package com.bookstore.servlet;

import com.bookstore.dao.BillDAO;
import com.bookstore.dao.CustomerDAO;
import com.bookstore.dao.ItemDAO;
import com.bookstore.model.Bill;
import com.bookstore.model.Customer;
import com.bookstore.model.Item;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private BillDAO billDAO;
    private CustomerDAO customerDAO;
    private ItemDAO itemDAO;
    
    @Override
    public void init() throws ServletException {
        billDAO = new BillDAO();
        customerDAO = new CustomerDAO();
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
                    showNewBillForm(request, response);
                    break;
                case "view":
                    showBillDetails(request, response);
                    break;
                case "print":
                    printBill(request, response);
                    break;
                case "delete":
                    deleteBill(request, response);
                    break;
                case "customer":
                    getBillsByCustomer(request, response);
                    break;
                case "list":
                default:
                    listBills(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in BillServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/pages/bill-list.jsp").forward(request, response);
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
                case "create":
                    createBill(request, response);
                    break;
                case "additem":
                    addItemToBill(request, response);
                    break;
                case "removeitem":
                    removeItemFromBill(request, response);
                    break;
                case "finalize":
                    finalizeBill(request, response);
                    break;
                default:
                    listBills(request, response);
                    break;
            }
        } catch (Exception e) {
            System.err.println("Error in BillServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/pages/create-bill.jsp").forward(request, response);
        }
    }
    
    private void listBills(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Bill> bills = billDAO.selectAllBills();
        request.setAttribute("bills", bills);
        request.getRequestDispatcher("/pages/bill-list.jsp").forward(request, response);
    }
    
    private void showNewBillForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get all customers and items for dropdowns
        List<Customer> customers = customerDAO.selectAllCustomers();
        List<Item> items = itemDAO.selectAllItems();
        
        request.setAttribute("customers", customers);
        request.setAttribute("items", items);
        request.getRequestDispatcher("/pages/create-bill.jsp").forward(request, response);
    }
    
    private void showBillDetails(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int billId = Integer.parseInt(request.getParameter("id"));
        Bill bill = billDAO.selectBillById(billId);
        
        if (bill != null) {
            request.setAttribute("bill", bill);
            request.getRequestDispatcher("/pages/bill-details.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Bill not found");
            listBills(request, response);
        }
    }
    
    private void printBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int billId = Integer.parseInt(request.getParameter("id"));
        Bill bill = billDAO.selectBillById(billId);
        
        if (bill != null) {
            request.setAttribute("bill", bill);
            request.getRequestDispatcher("/pages/print-bill.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Bill not found");
            listBills(request, response);
        }
    }
    
    private void createBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get customer information
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        Customer customer = customerDAO.selectCustomerById(customerId);
        
        if (customer == null) {
            request.setAttribute("errorMessage", "Customer not found");
            showNewBillForm(request, response);
            return;
        }
        
        try {
            // Create new bill
            Bill bill = new Bill(customer.getCustomerId(), customer.getName(), 
                               customer.getAddress(), customer.getTelephoneNumber());
            
            // Store bill in session for adding items
            HttpSession session = request.getSession();
            session.setAttribute("currentBill", bill);
            
            // Get items for adding to bill
            List<Item> items = itemDAO.selectAllItems();
            request.setAttribute("items", items);
            request.setAttribute("bill", bill);
            request.setAttribute("customer", customer);
            
            request.getRequestDispatcher("/pages/create-bill.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error creating bill: " + e.getMessage());
            request.setAttribute("errorMessage", "Error creating bill: " + e.getMessage());
            showNewBillForm(request, response);
        }
    }
    
    private void addItemToBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Bill bill = (Bill) session.getAttribute("currentBill");
        
        if (bill == null) {
            request.setAttribute("errorMessage", "No active bill found");
            showNewBillForm(request, response);
            return;
        }
        
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                request.setAttribute("errorMessage", "Quantity must be greater than 0");
                showCurrentBill(request, response, bill);
                return;
            }
            
            Item item = itemDAO.selectItemById(itemId);
            if (item == null) {
                request.setAttribute("errorMessage", "Item not found");
                showCurrentBill(request, response, bill);
                return;
            }
            
            if (item.getQuantity() < quantity) {
                request.setAttribute("errorMessage", "Insufficient stock. Available: " + item.getQuantity());
                showCurrentBill(request, response, bill);
                return;
            }
            
            // Add item to bill
            bill.addItem(item, quantity);
            
            // Update session
            session.setAttribute("currentBill", bill);
            
            request.setAttribute("successMessage", "Item added to bill");
            showCurrentBill(request, response, bill);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid item or quantity");
            showCurrentBill(request, response, bill);
        } catch (Exception e) {
            System.err.println("Error adding item to bill: " + e.getMessage());
            request.setAttribute("errorMessage", "Error adding item: " + e.getMessage());
            showCurrentBill(request, response, bill);
        }
    }
    
    private void removeItemFromBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Bill bill = (Bill) session.getAttribute("currentBill");
        
        if (bill == null) {
            request.setAttribute("errorMessage", "No active bill found");
            showNewBillForm(request, response);
            return;
        }
        
        try {
            int itemId = Integer.parseInt(request.getParameter("itemId"));
            bill.removeItem(itemId);
            
            // Update session
            session.setAttribute("currentBill", bill);
            
            request.setAttribute("successMessage", "Item removed from bill");
            showCurrentBill(request, response, bill);
            
        } catch (Exception e) {
            System.err.println("Error removing item from bill: " + e.getMessage());
            request.setAttribute("errorMessage", "Error removing item: " + e.getMessage());
            showCurrentBill(request, response, bill);
        }
    }
    
    private void finalizeBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Bill bill = (Bill) session.getAttribute("currentBill");
        
        if (bill == null) {
            request.setAttribute("errorMessage", "No active bill found");
            showNewBillForm(request, response);
            return;
        }
        
        if (bill.getBillItems().isEmpty()) {
            request.setAttribute("errorMessage", "Cannot finalize empty bill");
            showCurrentBill(request, response, bill);
            return;
        }
        
        try {
            // Get payment method and discount
            String paymentMethod = request.getParameter("paymentMethod");
            String discountStr = request.getParameter("discount");
            
            double discount = 0.0;
            if (discountStr != null && !discountStr.trim().isEmpty()) {
                discount = Double.parseDouble(discountStr);
            }
            
            // Set bill details
            bill.setPaymentMethod(paymentMethod);
            bill.applyDiscount(discount);
            bill.setStatus("COMPLETED");
            
            // Save bill to database
            if (billDAO.insertBill(bill)) {
                // Update item quantities
                for (Bill.BillItem billItem : bill.getBillItems()) {
                    itemDAO.updateQuantity(billItem.getItemId(), billItem.getQuantity());
                }
                
                // Update customer total purchases
                customerDAO.updateTotalPurchases(bill.getCustomerId(), bill.getTotalAmount());
                
                // Clear session
                session.removeAttribute("currentBill");
                
                request.setAttribute("successMessage", "Bill created successfully");
                request.setAttribute("bill", bill);
                request.getRequestDispatcher("/pages/print-bill.jsp").forward(request, response);
                
            } else {
                request.setAttribute("errorMessage", "Failed to save bill");
                showCurrentBill(request, response, bill);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid discount amount");
            showCurrentBill(request, response, bill);
        } catch (Exception e) {
            System.err.println("Error finalizing bill: " + e.getMessage());
            request.setAttribute("errorMessage", "Error finalizing bill: " + e.getMessage());
            showCurrentBill(request, response, bill);
        }
    }
    
    private void deleteBill(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int billId = Integer.parseInt(request.getParameter("id"));
        
        try {
            if (billDAO.deleteBill(billId)) {
                request.setAttribute("successMessage", "Bill deleted successfully");
            } else {
                request.setAttribute("errorMessage", "Failed to delete bill");
            }
        } catch (Exception e) {
            System.err.println("Error deleting bill: " + e.getMessage());
            request.setAttribute("errorMessage", "Error deleting bill: " + e.getMessage());
        }
        
        listBills(request, response);
    }
    
    private void getBillsByCustomer(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        
        List<Bill> bills = billDAO.selectBillsByCustomer(customerId);
        Customer customer = customerDAO.selectCustomerById(customerId);
        
        request.setAttribute("bills", bills);
        request.setAttribute("customer", customer);
        request.setAttribute("isCustomerView", true);
        
        if (bills.isEmpty()) {
            request.setAttribute("infoMessage", "No bills found for this customer");
        }
        
        request.getRequestDispatcher("/pages/bill-list.jsp").forward(request, response);
    }
    
    private void showCurrentBill(HttpServletRequest request, HttpServletResponse response, Bill bill) 
            throws ServletException, IOException {
        
        List<Item> items = itemDAO.selectAllItems();
        Customer customer = customerDAO.selectCustomerById(bill.getCustomerId());
        
        request.setAttribute("items", items);
        request.setAttribute("bill", bill);
        request.setAttribute("customer", customer);
        
        request.getRequestDispatcher("/pages/create-bill.jsp").forward(request, response);
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