<%@ page import="java.sql.*, com.bookstore.util.DatabaseUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Feedbacks</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/viewFeedback.css">
</head>
<body>

<h2>All Feedbacks</h2>

<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DatabaseUtil.getConnection();

        // ✅ Removed ORDER BY id DESC, since "id" doesn't exist
        String sql = "SELECT name, email, feedback_type, rating, subject, message, contact_preference FROM feedback";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();
%>

<table>
    <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Type</th>
        <th>Rating</th>
        <th>Subject</th>
        <th>Message</th>
        <th>Contact Preference</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("feedback_type") %></td>
        <td><%= rs.getInt("rating") %></td>
        <td><%= rs.getString("subject") %></td>
        <td><%= rs.getString("message") %></td>
        <td><%= rs.getString("contact_preference") %></td>
    </tr>
<%
    }
%>

</table>

<%
    } catch (SQLException e) {
%>
    <div class="error">❌ An error occurred: <%= e.getMessage() %></div>
<%
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        DatabaseUtil.closeConnection(conn);
    }
%>

</body>
</html>
