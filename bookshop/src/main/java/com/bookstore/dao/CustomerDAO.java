package com.bookstore.dao;

import com.bookstore.model.Customer;
import com.bookstore.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    
    // SQL queries
    private static final String INSERT_CUSTOMER = 
        "INSERT INTO customers (account_number, name, address, telephone_number, email, total_purchases, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_CUSTOMER_BY_ID = 
        "SELECT * FROM customers WHERE customer_id = ? AND is_active = true";
    
    private static final String SELECT_CUSTOMER_BY_ACCOUNT = 
        "SELECT * FROM customers WHERE account_number = ? AND is_active = true";
    
    private static final String SELECT_ALL_CUSTOMERS = 
        "SELECT * FROM customers WHERE is_active = true ORDER BY name";
    
    private static final String UPDATE_CUSTOMER = 
        "UPDATE customers SET account_number = ?, name = ?, address = ?, telephone_number = ?, email = ?, total_purchases = ? WHERE customer_id = ?";
    
    private static final String DELETE_CUSTOMER = 
        "UPDATE customers SET is_active = false WHERE customer_id = ?";
    
    private static final String SEARCH_CUSTOMERS = 
        "SELECT * FROM customers WHERE (name LIKE ? OR account_number LIKE ? OR telephone_number LIKE ?) AND is_active = true ORDER BY name";
    
    private static final String UPDATE_TOTAL_PURCHASES = 
        "UPDATE customers SET total_purchases = total_purchases + ? WHERE customer_id = ?";
    
    /**
     * Insert a new customer
     */
    public boolean insertCustomer(Customer customer) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_CUSTOMER, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, customer.getAccountNumber());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getTelephoneNumber());
            stmt.setString(5, customer.getEmail());
            stmt.setDouble(6, customer.getTotalPurchases());
            stmt.setBoolean(7, customer.isActive());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        customer.setCustomerId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("Customer inserted successfully: " + customer.getName());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error inserting customer: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Select customer by ID
     */
    public Customer selectCustomerById(int customerId) {
        Customer customer = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_CUSTOMER_BY_ID)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    customer = mapResultSetToCustomer(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting customer by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return customer;
    }
    
    /**
     * Select customer by account number
     */
    public Customer selectCustomerByAccount(String accountNumber) {
        Customer customer = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_CUSTOMER_BY_ACCOUNT)) {
            
            stmt.setString(1, accountNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    customer = mapResultSetToCustomer(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting customer by account: " + e.getMessage());
            e.printStackTrace();
        }
        
        return customer;
    }
    
    /**
     * Select all customers
     */
    public List<Customer> selectAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_CUSTOMERS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting all customers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return customers;
    }
    
    /**
     * Update customer
     */
    public boolean updateCustomer(Customer customer) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_CUSTOMER)) {
            
            stmt.setString(1, customer.getAccountNumber());
            stmt.setString(2, customer.getName());
            stmt.setString(3, customer.getAddress());
            stmt.setString(4, customer.getTelephoneNumber());
            stmt.setString(5, customer.getEmail());
            stmt.setDouble(6, customer.getTotalPurchases());
            stmt.setInt(7, customer.getCustomerId());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Customer updated successfully: " + customer.getName());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error updating customer: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete customer (soft delete)
     */
    public boolean deleteCustomer(int customerId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_CUSTOMER)) {
            
            stmt.setInt(1, customerId);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Customer deleted successfully (ID: " + customerId + ")");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error deleting customer: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Search customers by name, account number, or phone
     */
    public List<Customer> searchCustomers(String searchTerm) {
        List<Customer> customers = new ArrayList<>();
        String searchPattern = "%" + searchTerm + "%";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SEARCH_CUSTOMERS)) {
            
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add(mapResultSetToCustomer(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching customers: " + e.getMessage());
            e.printStackTrace();
        }
        
        return customers;
    }
    
    /**
     * Update customer's total purchases
     */
    public boolean updateTotalPurchases(int customerId, double amount) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_TOTAL_PURCHASES)) {
            
            stmt.setDouble(1, amount);
            stmt.setInt(2, customerId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating total purchases: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if account number exists
     */
    public boolean accountNumberExists(String accountNumber) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_CUSTOMER_BY_ACCOUNT)) {
            
            stmt.setString(1, accountNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking account number existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Generate unique account number
     */
    public String generateAccountNumber() {
        String accountNumber;
        do {
            accountNumber = "ACC" + System.currentTimeMillis();
        } while (accountNumberExists(accountNumber));
        
        return accountNumber;
    }
    
    /**
     * Get customer count
     */
    public int getCustomerCount() {
        String query = "SELECT COUNT(*) FROM customers WHERE is_active = true";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting customer count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Map ResultSet to Customer object
     */
    private Customer mapResultSetToCustomer(ResultSet rs) throws SQLException {
        Customer customer = new Customer();
        customer.setCustomerId(rs.getInt("customer_id"));
        customer.setAccountNumber(rs.getString("account_number"));
        customer.setName(rs.getString("name"));
        customer.setAddress(rs.getString("address"));
        customer.setTelephoneNumber(rs.getString("telephone_number"));
        customer.setEmail(rs.getString("email"));
        customer.setTotalPurchases(rs.getDouble("total_purchases"));
        customer.setActive(rs.getBoolean("is_active"));
        return customer;
    }
}