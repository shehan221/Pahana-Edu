package com.bookstore.dao;

import com.bookstore.model.User;
import com.bookstore.util.DatabaseUtil;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    // SQL queries matching your database structure
    private static final String INSERT_USER = 
        "INSERT INTO users (username, password, full_name, email, role, is_active) VALUES (?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_USER_BY_ID = 
        "SELECT user_id, username, password, full_name, email, role, is_active FROM users WHERE user_id = ?";
    
    private static final String SELECT_USER_BY_USERNAME = 
        "SELECT user_id, username, password, full_name, email, role, is_active FROM users WHERE username = ? AND is_active = true";
    
    private static final String SELECT_ALL_USERS = 
        "SELECT user_id, username, password, full_name, email, role, is_active FROM users WHERE is_active = true";
    
    private static final String UPDATE_USER = 
        "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, role = ? WHERE user_id = ?";
    
    private static final String DELETE_USER = 
        "UPDATE users SET is_active = false WHERE user_id = ?";
    
    private static final String VALIDATE_USER = 
        "SELECT user_id, username, password, full_name, email, role, is_active FROM users WHERE username = ? AND password = ? AND is_active = true";
    
    private static final String CHECK_USERNAME_EXISTS = 
        "SELECT COUNT(*) FROM users WHERE username = ? AND is_active = true";
    
    /**
     * Hash password using SHA-256
     */
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            System.err.println("⚠️ Error hashing password: " + e.getMessage());
            return password; // Fallback to plain text (not recommended for production)
        }
    }
    
    /**
     * Test database connection
     */
    public boolean testConnection() {
        System.out.println("🔍 Testing database connection...");
        try (Connection conn = DatabaseUtil.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Database connection successful!");
                
                // Test if users table exists
                DatabaseMetaData meta = conn.getMetaData();
                ResultSet tables = meta.getTables(null, null, "users", null);
                if (tables.next()) {
                    System.out.println("✅ Users table found in database");
                } else {
                    System.err.println("❌ Users table not found!");
                    return false;
                }
                
                return true;
            } else {
                System.err.println("❌ Database connection is null or closed");
                return false;
            }
        } catch (SQLException e) {
            System.err.println("❌ Database connection failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Validate user login credentials
     */
    public User validateUser(String username, String password) {
        System.out.println("🔍 Validating user: " + username);
        
        User user = null;
        String hashedPassword = hashPassword(password);
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(VALIDATE_USER)) {
            
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            
            System.out.println("🔍 Executing validation query...");
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                    System.out.println("✅ User validation successful: " + username);
                } else {
                    System.out.println("❌ User validation failed: " + username);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error validating user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Insert a new user
     */
    public boolean insertUser(User user) {
        System.out.println("💾 Inserting user: " + user.getUsername());
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS)) {
            
            // Hash the password before storing
            String hashedPassword = hashPassword(user.getPassword());
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, hashedPassword);
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.isActive());
            
            System.out.println("📝 Prepared statement values:");
            System.out.println("   - Username: " + user.getUsername());
            System.out.println("   - Full Name: " + user.getFullName());
            System.out.println("   - Email: " + user.getEmail());
            System.out.println("   - Role: " + user.getRole());
            System.out.println("   - Active: " + user.isActive());
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("📊 Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int generatedId = generatedKeys.getInt(1);
                        user.setUserId(generatedId);
                        System.out.println("✅ User inserted successfully with ID: " + generatedId);
                    }
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error inserting user: " + e.getMessage());
            e.printStackTrace();
            
            // Check if it's a duplicate key error
            if (e.getMessage().toLowerCase().contains("duplicate")) {
                System.err.println("⚠️ Username already exists: " + user.getUsername());
            }
        }
        
        System.out.println("❌ User insertion failed");
        return false;
    }
    
    /**
     * Select user by ID
     */
    public User selectUserById(int userId) {
        System.out.println("🔍 Selecting user by ID: " + userId);
        
        User user = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_USER_BY_ID)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                    System.out.println("✅ User found: " + user.getUsername());
                } else {
                    System.out.println("❌ No user found with ID: " + userId);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error selecting user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Select user by username
     */
    public User selectUserByUsername(String username) {
        System.out.println("🔍 Selecting user by username: " + username);
        
        User user = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_USER_BY_USERNAME)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                    System.out.println("✅ User found: " + username);
                } else {
                    System.out.println("❌ No user found with username: " + username);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error selecting user by username: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Select all users
     */
    public List<User> selectAllUsers() {
        System.out.println("🔍 Selecting all users");
        
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ Found " + users.size() + " users");
            
        } catch (SQLException e) {
            System.err.println("❌ Error selecting all users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Update user
     */
    public boolean updateUser(User user) {
        System.out.println("🔄 Updating user: " + user.getUsername());
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_USER)) {
            
            // Hash password if it's being updated
            String hashedPassword = hashPassword(user.getPassword());
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, hashedPassword);
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getRole());
            stmt.setInt(6, user.getUserId());
            
            int rowsAffected = stmt.executeUpdate();
            boolean success = rowsAffected > 0;
            
            System.out.println(success ? "✅ User updated successfully" : "❌ User update failed");
            return success;
            
        } catch (SQLException e) {
            System.err.println("❌ Error updating user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete user (soft delete)
     */
    public boolean deleteUser(int userId) {
        System.out.println("🗑️ Deleting user with ID: " + userId);
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_USER)) {
            
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            boolean success = rowsAffected > 0;
            
            System.out.println(success ? "✅ User deleted successfully" : "❌ User deletion failed");
            return success;
            
        } catch (SQLException e) {
            System.err.println("❌ Error deleting user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if username exists
     */
    public boolean usernameExists(String username) {
        System.out.println("🔍 Checking if username exists: " + username);
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(CHECK_USERNAME_EXISTS)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    boolean exists = count > 0;
                    System.out.println("📊 Username '" + username + "' exists: " + exists + " (count: " + count + ")");
                    return exists;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Error checking username existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("❌ Username check failed, assuming it exists for safety");
        return true; // Assume exists for safety
    }
    
    /**
     * Map ResultSet to User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password")); // This will be hashed
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("is_active"));
        
        // Debug output
        System.out.println("📋 Mapped user from database:");
        System.out.println("   - ID: " + user.getUserId());
        System.out.println("   - Username: " + user.getUsername());
        System.out.println("   - Full Name: " + user.getFullName());
        System.out.println("   - Email: " + user.getEmail());
        System.out.println("   - Role: " + user.getRole());
        System.out.println("   - Active: " + user.isActive());
        
        return user;
    }
}