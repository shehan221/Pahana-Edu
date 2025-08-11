package com.bookstore.servlet;

import com.bookstore.dao.FeedbackDAO;
import com.bookstore.model.Feedback;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Feedback feedback = new Feedback();

        // Get logged-in user ID from session (if available)
        HttpSession session = request.getSession(false);
        Integer userId = null;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (Integer) session.getAttribute("userId");
        }
        feedback.setUserId(userId); // null for guests

        // Populate feedback fields
        feedback.setName(request.getParameter("name"));
        feedback.setEmail(request.getParameter("email"));
        feedback.setFeedbackType(request.getParameter("feedbackType"));

        try {
            feedback.setRating(Integer.parseInt(request.getParameter("rating")));
        } catch (NumberFormatException e) {
            feedback.setRating(0);
        }

        feedback.setSubject(request.getParameter("subject"));
        feedback.setMessage(request.getParameter("message"));
        feedback.setContactPreference(request.getParameter("contactPreference"));

        try {
            new FeedbackDAO().saveFeedback(feedback);
            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher("/feedback_success.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error saving feedback: " + e.getMessage());
            request.getRequestDispatcher("/feedback_form.jsp").forward(request, response);
        }
    }
}
