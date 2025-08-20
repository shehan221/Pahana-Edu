<%@ page import="java.sql.*, com.bookstore.util.DatabaseUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Feedback Form - Pahana Edu</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feedback_style.css">
   
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar">
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/pages/dashboard.jsp">
            <i class="fas fa-home"></i> Home
        </a>
        <a href="${pageContext.request.contextPath}/pages/books.jsp">
            <i class="fas fa-book"></i> Books
        </a>
        <a href="${pageContext.request.contextPath}/pages/aboutUs.jsp">
            <i class="fas fa-info-circle"></i> About
        </a>
        <a href="${pageContext.request.contextPath}/pages/feedback.jsp" class="active">
            <i class="fas fa-comments"></i> Feedback
        </a>
    </div>
</nav>

<h2><i class="fas fa-comment-alt"></i> Submit Your Feedback</h2>

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
                <div class="message success">
                    <i class="fas fa-check-circle"></i> 
                    Thank you, <strong><%= name %></strong>! Your feedback has been submitted successfully!
                    <br><small>We appreciate your time and will review your feedback shortly.</small>
                </div>
<%
            } else {
%>
                <div class="message error">
                    <i class="fas fa-exclamation-circle"></i> 
                    Feedback submission failed. Please try again.
                </div>
<%
            }
        } catch (NumberFormatException nfe) {
%>
            <div class="message error">
                <i class="fas fa-exclamation-triangle"></i> 
                Rating must be a number between 1 and 5.
            </div>
<%
        } catch (SQLException sqle) {
%>
            <div class="message error">
                <i class="fas fa-database"></i> 
                Database error: <%= sqle.getMessage() %>
            </div>
<%
            sqle.printStackTrace();
        } finally {
            try { if (stmt != null) stmt.close(); } catch (SQLException ignore) {}
            DatabaseUtil.closeConnection(conn);
        }
    }
%>

<form method="post" action="feedback.jsp">
    <label for="name">
        <i class="fas fa-user"></i> Full Name:
    </label>
    <input type="text" id="name" name="name" 
           value="<%= name != null ? name : "" %>" 
           placeholder="Enter your full name" required>

    <label for="email">
        <i class="fas fa-envelope"></i> Email Address:
    </label>
    <input type="email" id="email" name="email" 
           value="<%= email != null ? email : "" %>" 
           placeholder="Enter your email address" required>

    <label for="feedback_type">
        <i class="fas fa-tags"></i> Feedback Type:
    </label>
    <select id="feedback_type" name="feedback_type" required>
        <option value="" disabled <%= feedbackType == null ? "selected" : "" %>>Choose feedback type</option>
        <option value="general" <%= "general".equals(feedbackType) ? "selected" : "" %>>General Feedback</option>
        <option value="suggestion" <%= "suggestion".equals(feedbackType) ? "selected" : "" %>>Suggestion</option>
        <option value="complaint" <%= "complaint".equals(feedbackType) ? "selected" : "" %>>Complaint</option>
        <option value="compliment" <%= "compliment".equals(feedbackType) ? "selected" : "" %>>Compliment</option>
        <option value="bug" <%= "bug".equals(feedbackType) ? "selected" : "" %>>Bug Report</option>
    </select>

    <label for="rating">
        <i class="fas fa-star"></i> Overall Rating:
    </label>
    <input type="number" id="rating" name="rating" min="1" max="5" 
           value="<%= ratingStr != null ? ratingStr : "" %>" 
           placeholder="Rate us from 1 to 5 stars" required>
    <small style="color: #6b7280; font-size: 0.9em; margin-top: -1rem; margin-bottom: 1rem; display: block;">
        ⭐ 1 = Poor, 5 = Excellent
    </small>

    <label for="subject">
        <i class="fas fa-heading"></i> Subject:
    </label>
    <input type="text" id="subject" name="subject" 
           value="<%= subject != null ? subject : "" %>" 
           placeholder="Brief subject line" required>

    <label for="message">
        <i class="fas fa-comment"></i> Your Message:
    </label>
    <textarea id="message" name="message" rows="6" 
              placeholder="Please share your detailed feedback here..." required><%= message != null ? message : "" %></textarea>

    <label for="contact_preference">
        <i class="fas fa-phone"></i> Contact Preference:
    </label>
    <select id="contact_preference" name="contact_preference">
        <option value="email" <%= "email".equals(contactPref) || contactPref == null ? "selected" : "" %>>Email Response</option>
        <option value="no-response" <%= "no-response".equals(contactPref) ? "selected" : "" %>>No Response Needed</option>
        <option value="phone" <%= "phone".equals(contactPref) ? "selected" : "" %>>Phone Call</option>
    </select>

    <input type="submit" value="Submit Feedback">
</form>

<script>
// Form enhancement JavaScript
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('form');
    const submitBtn = document.querySelector('input[type="submit"]');
    
    // Add loading state to submit button
    form.addEventListener('submit', function() {
        submitBtn.style.opacity = '0.7';
        submitBtn.value = 'Submitting...';
        submitBtn.disabled = true;
    });
    
    // Rating input enhancement
    const ratingInput = document.getElementById('rating');
    ratingInput.addEventListener('input', function() {
        const value = this.value;
        if (value >= 1 && value <= 5) {
            this.style.borderColor = '#059669';
        } else {
            this.style.borderColor = '#ef4444';
        }
    });

    // Navigation scroll effect
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('shrink-nav');
        } else {
            navbar.classList.remove('shrink-nav');
        }
    });
});
</script>

</body>
</html>