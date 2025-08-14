<%@ page import="java.sql.*, com.bookstore.util.DatabaseUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Feedback Form</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feedback_style.css">
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
