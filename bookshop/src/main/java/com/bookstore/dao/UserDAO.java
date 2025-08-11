package com.bookstore.dao;

import com.bookstore.model.User;
import com.bookstore.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    // SQL queries
    private static final String INSERT_USER = 
        "INSERT INTO users (username, password, full_name, email, role, is_active) VALUES (?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_USER_BY_ID = 
        "SELECT * FROM users WHERE user_id = ?";
    
    private static final String SELECT_USER_BY_USERNAME = 
        "SELECT * FROM users WHERE username = ? AND is_active = true";
    
    private static final String SELECT_ALL_USERS = 
        "SELECT * FROM users WHERE is_active = true ORDER BY user_id DESC";
    
    private static final String SELECT_ALL_USERS_INCLUDING_INACTIVE = 
        "SELECT * FROM users ORDER BY user_id DESC";
    
    private static final String UPDATE_USER = 
        "UPDATE users SET username = ?, password = ?, full_name = ?, email = ?, role = ? WHERE user_id = ?";
    
    private static final String DELETE_USER = 
        "UPDATE users SET is_active = false WHERE user_id = ?";
    
    private static final String ACTIVATE_USER = 
        "UPDATE users SET is_active = true WHERE user_id = ?";
    
    private static final String VALIDATE_USER = 
        "SELECT * FROM users WHERE username = ? AND password = ? AND is_active = true";
    
    private static final String COUNT_USERS_BY_ROLE = 
        "SELECT COUNT(*) FROM users WHERE role = ? AND is_active = true";
    
    private static final String COUNT_ACTIVE_USERS = 
        "SELECT COUNT(*) FROM users WHERE is_active = true";
    
    private static final String COUNT_TOTAL_USERS = 
        "SELECT COUNT(*) FROM users";
    
    /**
     * Validate user login credentials
     */
    public User validateUser(String username, String password) {
        User user = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(VALIDATE_USER)) {
            
            stmt.setString(1, username);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                    System.out.println("✅ User validation successful: " + user.getUsername() + " (Role: " + user.getRole() + ")");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error validating user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Insert a new user
     */
    public boolean insertUser(User user) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getRole());
            stmt.setBoolean(6, user.isActive());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setUserId(generatedKeys.getInt(1));
                    }
                }
                System.out.println("✅ User created successfully: " + user.getUsername() + " (ID: " + user.getUserId() + ")");
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error inserting user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Select user by ID
     */
    public User selectUserById(int userId) {
        User user = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_USER_BY_ID)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Select user by username
     */
    public User selectUserByUsername(String username) {
        User user = null;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_USER_BY_USERNAME)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error selecting user by username: " + e.getMessage());
            e.printStackTrace();
        }
        
        return user;
    }
    
    /**
     * Select all active users (for regular admin view)
     */
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("📋 Retrieved " + users.size() + " active users");
            
        } catch (SQLException e) {
            System.err.println("Error selecting all users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Select all users including inactive ones (for full admin view)
     */
    public List<User> selectAllUsersIncludingInactive() {
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_USERS_INCLUDING_INACTIVE);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("📋 Retrieved " + users.size() + " total users (including inactive)");
            
        } catch (SQLException e) {
            System.err.println("Error selecting all users including inactive: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Update user
     */
    public boolean updateUser(User user) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_USER)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getRole());
            stmt.setInt(6, user.getUserId());
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ User updated successfully: " + user.getUsername());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete user (soft delete)
     */
    public boolean deleteUser(int userId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_USER)) {
            
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ User deactivated (soft delete): ID " + userId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Activate user (reactivate deactivated user)
     */
    public boolean activateUser(int userId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(ACTIVATE_USER)) {
            
            stmt.setInt(1, userId);
            
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ User reactivated: ID " + userId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error activating user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if username exists (for registration validation)
     */
    public boolean usernameExists(String username) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_USER_BY_USERNAME)) {
            
            stmt.setString(1, username);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking username existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Count users by role (for dashboard statistics)
     */
    public int countUsersByRole(String role) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_USERS_BY_ROLE)) {
            
            stmt.setString(1, role);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error counting users by role: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Count active users (for dashboard statistics)
     */
    public int countActiveUsers() {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_ACTIVE_USERS)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error counting active users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Count total users including inactive (for dashboard statistics)
     */
    public int countTotalUsers() {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(COUNT_TOTAL_USERS)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error counting total users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get dashboard statistics for admin panel
     */
    public UserStats getDashboardStats() {
        UserStats stats = new UserStats();
        stats.totalUsers = countActiveUsers();
        stats.adminUsers = countUsersByRole("admin");
        stats.regularUsers = countUsersByRole("user");
        stats.inactiveUsers = countTotalUsers() - stats.totalUsers;
        
        System.out.println("📊 Dashboard Stats: " + stats.toString());
        return stats;
    }
    
    /**
     * Check if user has admin privileges
     */
    public boolean isAdminUser(String username) {
        User user = selectUserByUsername(username);
        return user != null && "admin".equalsIgnoreCase(user.getRole());
    }
    
    /**
     * Map ResultSet to User object
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRole(rs.getString("role"));
        user.setActive(rs.getBoolean("is_active"));
        
        // Handle optional timestamp fields if they exist in your table
        try {
            user.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            // Column doesn't exist, ignore
        }
        
        try {
            user.setLastLogin(rs.getTimestamp("last_login"));
        } catch (SQLException e) {
            // Column doesn't exist, ignore
        }
        
        return user;
    }
    
    /**
     * Inner class for user statistics (for admin dashboard)
     */
    public static class UserStats {
        public int totalUsers;
        public int adminUsers;
        public int regularUsers;
        public int inactiveUsers;
        
        @Override
        public String toString() {
            return "UserStats{" +
                    "totalUsers=" + totalUsers +
                    ", adminUsers=" + adminUsers +
                    ", regularUsers=" + regularUsers +
                    ", inactiveUsers=" + inactiveUsers +
                    '}';
        }
    }
}