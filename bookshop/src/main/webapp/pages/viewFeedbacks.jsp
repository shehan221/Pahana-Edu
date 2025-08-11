<%@ page import="java.sql.*, com.bookstore.util.DatabaseUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Feedbacks</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            padding: 40px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
        }

        th, td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: left;
            font-size: 14px;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .error {
            background-color: #fdecea;
            color: #c62828;
            border: 1px solid #f44336;
            padding: 10px 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            width: 100%;
            max-width: 800px;
            margin: 0 auto;
        }
    </style>
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
