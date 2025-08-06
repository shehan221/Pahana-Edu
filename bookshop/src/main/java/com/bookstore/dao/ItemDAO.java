package com.bookstore.dao;

import com.bookstore.model.Item;
import com.bookstore.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    
    // SQL queries
    private static final String INSERT_ITEM = 
        "INSERT INTO items (item_code, title, author, category, price, quantity, description, publisher, isbn, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_ITEM_BY_ID = 
        "SELECT * FROM items WHERE item_id = ? AND is_active = true";
    
    private static final String SELECT_ITEM_BY_CODE = 
        "SELECT * FROM items WHERE item_code = ? AND is_active = true";
    
    private static final String SELECT_ALL_ITEMS = 
        "SELECT * FROM items WHERE is_active = true ORDER BY title";
    
    private static final String UPDATE_ITEM = 
        "UPDATE items SET item_code = ?, title = ?, author = ?, category = ?, price = ?, quantity = ?, description = ?, publisher = ?, isbn = ? WHERE item_id = ?";
    
    private static final String DELETE_ITEM = 
        "UPDATE items SET is_active = false WHERE item_id = ?";
    
    private static final String SEARCH_ITEMS = 
        "SELECT * FROM items WHERE (title LIKE ? OR author LIKE ? OR item_code LIKE ? OR category LIKE ?) AND is_active = true ORDER BY title";
    
    private static final String UPDATE_QUANTITY = 
        "UPDATE items SET quantity = quantity - ? WHERE item_id = ? AND quantity >= ?";
    
    private static final String SELECT_ITEMS_BY_CATEGORY = 
        "SELECT * FROM items WHERE category = ? AND is_active = true ORDER BY title";
    
    private static final String SELECT_LOW_STOCK_ITEMS = 
        "SELECT * FROM items WHERE quantity <= ? AND is_active = true ORDER BY quantity";
    
    /**
     * Insert a new item
     */
    public boolean insertItem(Item item) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_ITEM, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, item.getItemCode());
            stmt.setString(2, item.getTitle());
            stmt.setString(3, item.getAuthor());
            stmt.setString(4, item.getCategory());
            stmt.setDouble(5, item.getPrice());
            stmt.setInt(6, item.getQuantity());
            stmt.setString(7, item.getDescription());
            stmt.setString(8, item.getPublisher());
            stmt.setString(9, item.getIsbn());
            stmt.setBoolean(10, item.isActive());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        item.setItemId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("Item inserted successfully: " + item.getTitle());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error inserting item: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Select item by ID
     */
    public Item selectItemById(int itemId) {
        Item item = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ITEM_BY_ID)) {
            
            stmt.setInt(1, itemId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    item = mapResultSetToItem(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting item by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return item;
    }
    
    /**
     * Select item by code
     */
    public Item selectItemByCode(String itemCode) {
        Item item = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ITEM_BY_CODE)) {
            
            stmt.setString(1, itemCode);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    item = mapResultSetToItem(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting item by code: " + e.getMessage());
            e.printStackTrace();
        }
        
        return item;
    }
    
    /**
     * Select all items
     */
    public List<Item> selectAllItems() {
        List<Item> items = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_ITEMS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                items.add(mapResultSetToItem(rs));
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting all items: " + e.getMessage());
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Update item
     */
    public boolean updateItem(Item item) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_ITEM)) {
            
            stmt.setString(1, item.getItemCode());
            stmt.setString(2, item.getTitle());
            stmt.setString(3, item.getAuthor());
            stmt.setString(4, item.getCategory());
            stmt.setDouble(5, item.getPrice());
            stmt.setInt(6, item.getQuantity());
            stmt.setString(7, item.getDescription());
            stmt.setString(8, item.getPublisher());
            stmt.setString(9, item.getIsbn());
            stmt.setInt(10, item.getItemId());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Item updated successfully: " + item.getTitle());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error updating item: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete item (soft delete)
     */
    public boolean deleteItem(int itemId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_ITEM)) {
            
            stmt.setInt(1, itemId);
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("Item deleted successfully (ID: " + itemId + ")");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error deleting item: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Search items by title, author, code, or category
     */
    public List<Item> searchItems(String searchTerm) {
        List<Item> items = new ArrayList<>();
        String searchPattern = "%" + searchTerm + "%";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SEARCH_ITEMS)) {
            
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToItem(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching items: " + e.getMessage());
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Select items by category
     */
    public List<Item> selectItemsByCategory(String category) {
        List<Item> items = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ITEMS_BY_CATEGORY)) {
            
            stmt.setString(1, category);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToItem(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting items by category: " + e.getMessage());
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Update item quantity (reduce stock)
     */
    public boolean updateQuantity(int itemId, int quantity) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_QUANTITY)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, itemId);
            stmt.setInt(3, quantity);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating item quantity: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get low stock items
     */
    public List<Item> getLowStockItems(int threshold) {
        List<Item> items = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_LOW_STOCK_ITEMS)) {
            
            stmt.setInt(1, threshold);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    items.add(mapResultSetToItem(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting low stock items: " + e.getMessage());
            e.printStackTrace();
        }
        
        return items;
    }
    
    /**
     * Check if item code exists
     */
    public boolean itemCodeExists(String itemCode) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ITEM_BY_CODE)) {
            
            stmt.setString(1, itemCode);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking item code existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Generate unique item code
     */
    public String generateItemCode() {
        String itemCode;
        do {
            itemCode = "ITEM" + System.currentTimeMillis();
        } while (itemCodeExists(itemCode));
        
        return itemCode;
    }
    
    /**
     * Get item count
     */
    public int getItemCount() {
        String query = "SELECT COUNT(*) FROM items WHERE is_active = true";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting item count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get total inventory value
     */
    public double getTotalInventoryValue() {
        String query = "SELECT SUM(price * quantity) FROM items WHERE is_active = true";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total inventory value: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    /**
     * Map ResultSet to Item object
     */
    private Item mapResultSetToItem(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setItemId(rs.getInt("item_id"));
        item.setItemCode(rs.getString("item_code"));
        item.setTitle(rs.getString("title"));
        item.setAuthor(rs.getString("author"));
        item.setCategory(rs.getString("category"));
        item.setPrice(rs.getDouble("price"));
        item.setQuantity(rs.getInt("quantity"));
        item.setDescription(rs.getString("description"));
        item.setPublisher(rs.getString("publisher"));
        item.setIsbn(rs.getString("isbn"));
        item.setActive(rs.getBoolean("is_active"));
        return item;
    }
}