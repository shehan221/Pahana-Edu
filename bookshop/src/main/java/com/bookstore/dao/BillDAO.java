package com.bookstore.dao;

import com.bookstore.model.Bill;
import com.bookstore.model.Bill.BillItem;
import com.bookstore.util.DatabaseUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class BillDAO {
    
    // SQL queries for bills
    private static final String INSERT_BILL = 
        "INSERT INTO bills (bill_number, customer_id, customer_name, customer_address, customer_phone, bill_date, subtotal, tax_amount, discount, total_amount, payment_method, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String INSERT_BILL_ITEM = 
        "INSERT INTO bill_items (bill_id, item_id, item_code, item_title, author, unit_price, quantity, total_price) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_BILL_BY_ID = 
        "SELECT * FROM bills WHERE bill_id = ?";
    
    private static final String SELECT_BILL_BY_NUMBER = 
        "SELECT * FROM bills WHERE bill_number = ?";
    
    private static final String SELECT_ALL_BILLS = 
        "SELECT * FROM bills ORDER BY bill_date DESC";
    
    private static final String SELECT_BILLS_BY_CUSTOMER = 
        "SELECT * FROM bills WHERE customer_id = ? ORDER BY bill_date DESC";
    
    private static final String SELECT_BILL_ITEMS = 
        "SELECT * FROM bill_items WHERE bill_id = ?";
    
    private static final String UPDATE_BILL = 
        "UPDATE bills SET customer_name = ?, customer_address = ?, customer_phone = ?, subtotal = ?, tax_amount = ?, discount = ?, total_amount = ?, payment_method = ?, status = ? WHERE bill_id = ?";
    
    private static final String DELETE_BILL = 
        "DELETE FROM bills WHERE bill_id = ?";
    
    private static final String DELETE_BILL_ITEMS = 
        "DELETE FROM bill_items WHERE bill_id = ?";
    
    private static final String SELECT_BILLS_BY_DATE_RANGE = 
        "SELECT * FROM bills WHERE bill_date BETWEEN ? AND ? ORDER BY bill_date DESC";
    
    private static final String SELECT_DAILY_SALES = 
        "SELECT DATE(bill_date) as sale_date, SUM(total_amount) as daily_total FROM bills WHERE status = 'COMPLETED' GROUP BY DATE(bill_date) ORDER BY sale_date DESC LIMIT 30";
    
    /**
     * Insert a new bill with all items
     */
    public boolean insertBill(Bill bill) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Insert the bill
            try (PreparedStatement billStmt = conn.prepareStatement(INSERT_BILL, Statement.RETURN_GENERATED_KEYS)) {
                billStmt.setString(1, bill.getBillNumber());
                billStmt.setInt(2, bill.getCustomerId());
                billStmt.setString(3, bill.getCustomerName());
                billStmt.setString(4, bill.getCustomerAddress());
                billStmt.setString(5, bill.getCustomerPhone());
                billStmt.setTimestamp(6, Timestamp.valueOf(bill.getBillDate()));
                billStmt.setDouble(7, bill.getSubtotal());
                billStmt.setDouble(8, bill.getTaxAmount());
                billStmt.setDouble(9, bill.getDiscount());
                billStmt.setDouble(10, bill.getTotalAmount());
                billStmt.setString(11, bill.getPaymentMethod());
                billStmt.setString(12, bill.getStatus());
                
                int rowsAffected = billStmt.executeUpdate();
                
                if (rowsAffected > 0) {
                    try (ResultSet generatedKeys = billStmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            bill.setBillId(generatedKeys.getInt(1));
                        }
                    }
                    
                    // Insert bill items
                    if (insertBillItems(conn, bill)) {
                        conn.commit(); // Commit transaction
                        System.out.println("Bill inserted successfully: " + bill.getBillNumber());
                        return true;
                    }
                }
            }
            
            conn.rollback(); // Rollback if something failed
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
            System.err.println("Error inserting bill: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
        
        return false;
    }
    
    /**
     * Insert bill items
     */
    private boolean insertBillItems(Connection conn, Bill bill) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(INSERT_BILL_ITEM)) {
            for (BillItem item : bill.getBillItems()) {
                stmt.setInt(1, bill.getBillId());
                stmt.setInt(2, item.getItemId());
                stmt.setString(3, item.getItemCode());
                stmt.setString(4, item.getItemTitle());
                stmt.setString(5, item.getAuthor());
                stmt.setDouble(6, item.getUnitPrice());
                stmt.setInt(7, item.getQuantity());
                stmt.setDouble(8, item.getTotalPrice());
                stmt.addBatch();
            }
            
            int[] results = stmt.executeBatch();
            return results.length == bill.getBillItems().size();
        }
    }
    
    /**
     * Select bill by ID
     */
    public Bill selectBillById(int billId) {
        Bill bill = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BILL_BY_ID)) {
            
            stmt.setInt(1, billId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    bill = mapResultSetToBill(rs);
                    loadBillItems(conn, bill);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting bill by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bill;
    }
    
    /**
     * Select bill by bill number
     */
    public Bill selectBillByNumber(String billNumber) {
        Bill bill = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BILL_BY_NUMBER)) {
            
            stmt.setString(1, billNumber);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    bill = mapResultSetToBill(rs);
                    loadBillItems(conn, bill);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting bill by number: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bill;
    }
    
    /**
     * Select all bills
     */
    public List<Bill> selectAllBills() {
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_BILLS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Bill bill = mapResultSetToBill(rs);
                loadBillItems(conn, bill);
                bills.add(bill);
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting all bills: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bills;
    }
    
    /**
     * Select bills by customer
     */
    public List<Bill> selectBillsByCustomer(int customerId) {
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BILLS_BY_CUSTOMER)) {
            
            stmt.setInt(1, customerId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bill bill = mapResultSetToBill(rs);
                    loadBillItems(conn, bill);
                    bills.add(bill);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting bills by customer: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bills;
    }
    
    /**
     * Load bill items for a bill
     */
    private void loadBillItems(Connection conn, Bill bill) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(SELECT_BILL_ITEMS)) {
            stmt.setInt(1, bill.getBillId());
            
            try (ResultSet rs = stmt.executeQuery()) {
                List<BillItem> items = new ArrayList<>();
                while (rs.next()) {
                    BillItem item = new BillItem(
                        rs.getInt("item_id"),
                        rs.getString("item_code"),
                        rs.getString("item_title"),
                        rs.getString("author"),
                        rs.getDouble("unit_price"),
                        rs.getInt("quantity")
                    );
                    item.setTotalPrice(rs.getDouble("total_price"));
                    items.add(item);
                }
                bill.setBillItems(items);
            }
        }
    }
    
    /**
     * Update bill
     */
    public boolean updateBill(Bill bill) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_BILL)) {
            
            stmt.setString(1, bill.getCustomerName());
            stmt.setString(2, bill.getCustomerAddress());
            stmt.setString(3, bill.getCustomerPhone());
            stmt.setDouble(4, bill.getSubtotal());
            stmt.setDouble(5, bill.getTaxAmount());
            stmt.setDouble(6, bill.getDiscount());
            stmt.setDouble(7, bill.getTotalAmount());
            stmt.setString(8, bill.getPaymentMethod());
            stmt.setString(9, bill.getStatus());
            stmt.setInt(10, bill.getBillId());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Bill updated successfully: " + bill.getBillNumber());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error updating bill: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete bill and its items
     */
    public boolean deleteBill(int billId) {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false);
            
            // Delete bill items first
            try (PreparedStatement stmt1 = conn.prepareStatement(DELETE_BILL_ITEMS)) {
                stmt1.setInt(1, billId);
                stmt1.executeUpdate();
            }
            
            // Delete bill
            try (PreparedStatement stmt2 = conn.prepareStatement(DELETE_BILL)) {
                stmt2.setInt(1, billId);
                int rowsAffected = stmt2.executeUpdate();
                
                if (rowsAffected > 0) {
                    conn.commit();
                    System.out.println("Bill deleted successfully (ID: " + billId + ")");
                    return true;
                }
            }
            
            conn.rollback();
            
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                System.err.println("Error rolling back transaction: " + ex.getMessage());
            }
            System.err.println("Error deleting bill: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
        
        return false;
    }
    
    /**
     * Get bills by date range
     */
    public List<Bill> getBillsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        List<Bill> bills = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_BILLS_BY_DATE_RANGE)) {
            
            stmt.setTimestamp(1, Timestamp.valueOf(startDate));
            stmt.setTimestamp(2, Timestamp.valueOf(endDate));
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Bill bill = mapResultSetToBill(rs);
                    loadBillItems(conn, bill);
                    bills.add(bill);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting bills by date range: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bills;
    }
    
    /**
     * Get total sales amount
     */
    public double getTotalSales() {
        String query = "SELECT SUM(total_amount) FROM bills WHERE status = 'COMPLETED'";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total sales: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    /**
     * Get bill count
     */
    public int getBillCount() {
        String query = "SELECT COUNT(*) FROM bills";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting bill count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Map ResultSet to Bill object
     */
    private Bill mapResultSetToBill(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setBillNumber(rs.getString("bill_number"));
        bill.setCustomerId(rs.getInt("customer_id"));
        bill.setCustomerName(rs.getString("customer_name"));
        bill.setCustomerAddress(rs.getString("customer_address"));
        bill.setCustomerPhone(rs.getString("customer_phone"));
        bill.setBillDate(rs.getTimestamp("bill_date").toLocalDateTime());
        bill.setSubtotal(rs.getDouble("subtotal"));
        bill.setTaxAmount(rs.getDouble("tax_amount"));
        bill.setDiscount(rs.getDouble("discount"));
        bill.setTotalAmount(rs.getDouble("total_amount"));
        bill.setPaymentMethod(rs.getString("payment_method"));
        bill.setStatus(rs.getString("status"));
        return bill;
    }
}