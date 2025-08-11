package com.bookstore.dao;

import com.bookstore.model.Feedback;
import java.sql.*;

public class FeedbackDAO {
    private static final String URL = "jdbc:mysql://localhost:3306/bookstore_db";
    private static final String USER = "root";
    private static final String PASS = "123456";

    public void saveFeedback(Feedback feedback) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS)) {
            String sql = "INSERT INTO feedback (user_id, name, email, feedback_type, rating, subject, message, contact_preference) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {

                // Handle nullable user_id
                if (feedback.getUserId() == null || feedback.getUserId() == 0) {
                    stmt.setNull(1, java.sql.Types.INTEGER);
                } else {
                    stmt.setInt(1, feedback.getUserId());
                }

                stmt.setString(2, feedback.getName());
                stmt.setString(3, feedback.getEmail());
                stmt.setString(4, feedback.getFeedbackType());
                stmt.setInt(5, feedback.getRating());
                stmt.setString(6, feedback.getSubject());
                stmt.setString(7, feedback.getMessage());
                stmt.setString(8, feedback.getContactPreference());

                stmt.executeUpdate();
            }
        }
    }
}
