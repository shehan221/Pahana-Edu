<%@ page import="java.sql.*, com.bookstore.util.DatabaseUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Feedback Form</title>
  <style>
    /* Reset & base styles */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f4f6f9;
        display: flex;
        flex-direction: column;
        align-items: center;
        min-height: 100vh;
        padding: 40px 20px;
    }

    h2 {
        color: #333;
        margin-bottom: 30px;
        font-size: 28px;
        text-align: center;
    }

    form {
        background: #ffffff;
        padding: 30px 35px;
        border-radius: 10px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        width: 100%;
        max-width: 500px;
    }

    label {
        font-weight: 600;
        color: #333;
        display: block;
        margin-bottom: 8px;
    }

    input[type="text"],
    input[type="email"],
    input[type="number"],
    textarea,
    select {
        width: 100%;
        padding: 12px 14px;
        border: 1px solid #ccc;
        border-radius: 6px;
        margin-bottom: 20px;
        font-size: 15px;
        transition: border-color 0.3s;
        background-color: #fefefe;
    }

    input:focus,
    textarea:focus,
    select:focus {
        border-color: #4CAF50;
        outline: none;
    }

    textarea {
        resize: vertical;
        min-height: 100px;
    }

    input[type="submit"] {
        background-color: #4CAF50;
        color: #fff;
        padding: 12px 25px;
        font-size: 16px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
    }

    /* Message box styles */
    .message {
        margin-top: 20px;
        padding: 15px 20px;
        border-radius: 6px;
        font-size: 15px;
        font-weight: 500;
        width: 100%;
        max-width: 500px;
        text-align: center;
    }

    .success {
        background-color: #e6f9ed;
        color: #2e7d32;
        border: 1px solid #a5d6a7;
    }

    .error {
        background-color: #fdecea;
        color: #c62828;
        border: 1px solid #f44336;
    }

    /* Responsive layout */
    @media (max-width: 600px) {
        form {
            padding: 25px 20px;
        }

        input[type="submit"] {
            width: 100%;
        }

        .message {
            font-size: 14px;
        }
    }
</style>
</head>
<body>

<h2>Submit Your Feedback</h2>

<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String feedbackType = request.getParameter("feedback_type");
    String ratingStr = request.getParameter("rating");
    String subject = request.getParameter("subject");
    String message = request.getParameter("message");
    String contactPref = request.getParameter("contact_preference");

    // Get userId from session (set during login)
    Integer userId = (Integer) session.getAttribute("userId");

    boolean formSubmitted = name != null && email != null && subject != null && message != null;

    if (formSubmitted) {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            int rating = Integer.parseInt(ratingStr);

            conn = DatabaseUtil.getConnection();

            String sql = "INSERT INTO feedback (user_id, name, email, feedback_type, rating, subject, message, contact_preference) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            stmt = conn.prepareStatement(sql);

            // Handle nullable user_id
            if (userId == null) {
                stmt.setNull(1, java.sql.Types.INTEGER);
            } else {
                stmt.setInt(1, userId);
            }

            stmt.setString(2, name);
            stmt.setString(3, email);
            stmt.setString(4, feedbackType);
            stmt.setInt(5, rating);
            stmt.setString(6, subject);
            stmt.setString(7, message);
            stmt.setString(8, contactPref);

            int result = stmt.executeUpdate();

            if (result > 0) {
%>
                <div class="message success">✅ Thank you, <strong><%= name %></strong>. Your feedback has been submitted successfully!</div>
<%
            } else {
%>
                <div class="message error">❌ Feedback submission failed. Please try again.</div>
<%
            }
        } catch (NumberFormatException nfe) {
%>
            <div class="message error">⚠️ Rating must be a number between 1 and 5.</div>
<%
        } catch (SQLException sqle) {
%>
            <div class="message error">❌ Database error: <%= sqle.getMessage() %></div>
<%
            sqle.printStackTrace();
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException ignore) {}
            DatabaseUtil.closeConnection(conn);
        }
    }
%>

<form method="post" action="feedback.jsp">
    <label for="name">Name:</label>
    <input type="text" id="name" name="name" value="<%= name != null ? name : "" %>" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" value="<%= email != null ? email : "" %>" required>

    <label for="feedback_type">Feedback Type:</label>
    <select id="feedback_type" name="feedback_type" required>
        <option value="general" <%= "general".equals(feedbackType) ? "selected" : "" %>>General</option>
        <option value="suggestion" <%= "suggestion".equals(feedbackType) ? "selected" : "" %>>Suggestion</option>
        <option value="complaint" <%= "complaint".equals(feedbackType) ? "selected" : "" %>>Complaint</option>
        <option value="compliment" <%= "compliment".equals(feedbackType) ? "selected" : "" %>>Compliment</option>
        <option value="bug" <%= "bug".equals(feedbackType) ? "selected" : "" %>>Bug</option>
    </select>

    <label for="rating">Rating (1 to 5):</label>
    <input type="number" id="rating" name="rating" min="1" max="5" value="<%= ratingStr != null ? ratingStr : "" %>" required>

    <label for="subject">Subject:</label>
    <input type="text" id="subject" name="subject" value="<%= subject != null ? subject : "" %>" required>

    <label for="message">Message:</label>
    <textarea id="message" name="message" rows="5" required><%= message != null ? message : "" %></textarea>

    <label for="contact_preference">Contact Preference:</label>
    <select id="contact_preference" name="contact_preference">
        <option value="email" <%= "email".equals(contactPref) ? "selected" : "" %>>Email</option>
        <option value="no-response" <%= "no-response".equals(contactPref) ? "selected" : "" %>>No Response</option>
        <option value="phone" <%= "phone".equals(contactPref) ? "selected" : "" %>>Phone</option>
    </select>

    <input type="submit" value="Submit Feedback">
</form>

</body>
</html>
