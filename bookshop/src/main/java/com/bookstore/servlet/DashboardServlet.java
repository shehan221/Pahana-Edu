package com.bookstore.servlet;

import com.bookstore.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("\n=== DASHBOARD ACCESS ===");
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("❌ User not logged in, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get user from session
        User user = (User) session.getAttribute("user");
        System.out.println("✅ Dashboard accessed by user: " + user.getUsername());
        System.out.println("✅ User details: " + user.toString());
        
        // Set user data for JSP
        request.setAttribute("user", user);
        
        // Try to forward to dashboard JSP
        try {
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
        } catch (ServletException e) {
            System.err.println("❌ Could not find /dashboard.jsp, trying /pages/dashboard.jsp");
            try {
                request.getRequestDispatcher("/pages/dashboard.jsp").forward(request, response);
            } catch (ServletException e2) {
                System.err.println("❌ Could not find dashboard JSP, creating HTML response");
                createDashboardResponse(request, response, user);
            }
        }
        
        System.out.println("=== END DASHBOARD ACCESS ===\n");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    // Create dashboard HTML response if JSP not found
    private void createDashboardResponse(HttpServletRequest request, HttpServletResponse response, User user) 
            throws IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html lang='en'>");
        out.println("<head>");
        out.println("  <meta charset='UTF-8'>");
        out.println("  <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("  <title>Dashboard - Pahana Edu</title>");
        out.println("  <link href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css' rel='stylesheet'>");
        out.println("  <style>");
        out.println("    * { margin: 0; padding: 0; box-sizing: border-box; }");
        out.println("    body { font-family: Arial, sans-serif; background-color: #f5f5f5; min-height: 100vh; }");
        out.println("    .header { background: #059669; color: white; padding: 1rem 2rem; }");
        out.println("    .header-content { display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto; }");
        out.println("    .logo { display: flex; align-items: center; gap: 0.5rem; font-size: 1.5rem; font-weight: bold; }");
        out.println("    .user-info { display: flex; align-items: center; gap: 1rem; }");
        out.println("    .logout-btn { background: rgba(255,255,255,0.2); color: white; padding: 0.5rem 1rem; ");
        out.println("                  border: none; border-radius: 4px; text-decoration: none; transition: all 0.3s; }");
        out.println("    .logout-btn:hover { background: rgba(255,255,255,0.3); }");
        out.println("    .main-content { max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }");
        out.println("    .card { background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); ");
        out.println("            margin-bottom: 2rem; overflow: hidden; }");
        out.println("    .card-header { background: #f8f9fa; padding: 1.5rem; border-bottom: 1px solid #e9ecef; }");
        out.println("    .card-body { padding: 2rem; }");
        out.println("    .welcome-card { text-align: center; }");
        out.println("    .welcome-title { font-size: 2rem; color: #333; margin-bottom: 0.5rem; }");
        out.println("    .welcome-subtitle { color: #666; font-size: 1rem; }");
        out.println("    .user-details table { width: 100%; border-collapse: collapse; }");
        out.println("    .user-details th, .user-details td { padding: 0.75rem; text-align: left; border-bottom: 1px solid #e9ecef; }");
        out.println("    .user-details th { background-color: #f8f9fa; font-weight: 600; width: 30%; }");
        out.println("    .status-active { color: #059669; font-weight: 600; }");
        out.println("    .status-inactive { color: #dc2626; font-weight: 600; }");
        out.println("    .actions { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-top: 1rem; }");
        out.println("    .action-btn { background: #059669; color: white; padding: 0.75rem 1rem; border: none; ");
        out.println("                  border-radius: 4px; text-decoration: none; text-align: center; transition: all 0.3s; }");
        out.println("    .action-btn:hover { background: #047857; transform: translateY(-1px); }");
        out.println("    .action-btn.secondary { background: #6b7280; }");
        out.println("    .action-btn.secondary:hover { background: #4b5563; }");
        out.println("    @media (max-width: 768px) {");
        out.println("      .header-content { flex-direction: column; gap: 1rem; text-align: center; }");
        out.println("      .main-content { padding: 0 1rem; }");
        out.println("      .actions { grid-template-columns: 1fr; }");
        out.println("    }");
        out.println("  </style>");
        out.println("</head>");
        out.println("<body>");
        
        // Header
        out.println("  <header class='header'>");
        out.println("    <div class='header-content'>");
        out.println("      <div class='logo'>");
        out.println("        <i class='fas fa-graduation-cap'></i>");
        out.println("        <span>Pahana Edu</span>");s
        out.println("      </div>");
        out.println("      <div class='user-info'>");
        out.println("        <span>Welcome, " + user.getFullName() + "!</span>");
        out.println("        <a href='" + request.getContextPath() + "/logout' class='logout-btn'>");
        out.println("          <i class='fas fa-sign-out-alt'></i> Logout");
        out.println("        </a>");
        out.println("      </div>");
        out.println("    </div>");
        out.println("  </header>");
        
        // Main content
        out.println("  <main class='main-content'>");
        
        // Welcome card
        out.println("    <div class='card welcome-card'>");
        out.println("      <div class='card-body'>");
        out.println("        <h1 class='welcome-title'>Dashboard</h1>");
        out.println("        <p class='welcome-subtitle'>Welcome to your education management dashboard</p>");
        out.println("      </div>");
        out.println("    </div>");
        
        // User details card
        out.println("    <div class='card'>");
        out.println("      <div class='card-header'>");
        out.println("        <h3><i class='fas fa-user-circle'></i> Your Account Information</h3>");
        out.println("      </div>");
        out.println("      <div class='card-body user-details'>");
        out.println("        <table>");
        out.println("          <tr><th>User ID</th><td>#" + user.getUserId() + "</td></tr>");
        out.println("          <tr><th>Username</th><td>" + user.getUsername() + "</td></tr>");
        out.println("          <tr><th>Full Name</th><td>" + user.getFullName() + "</td></tr>");
        out.println("          <tr><th>Email</th><td>" + (user.getEmail() != null ? user.getEmail() : "Not provided") + "</td></tr>");
        out.println("          <tr><th>Role</th><td>" + user.getRole() + "</td></tr>");
        out.println("          <tr><th>Account Status</th><td>");
        
        if (user.isActive()) {
            out.println("            <span class='status-active'><i class='fas fa-check-circle'></i> Active</span>");
        } else {
            out.println("            <span class='status-inactive'><i class='fas fa-times-circle'></i> Inactive</span>");
        }
        
        out.println("          </td></tr>");
        out.println("        </table>");
        out.println("      </div>");
        out.println("    </div>");
        
        // Actions card
        out.println("    <div class='card'>");
        out.println("      <div class='card-header'>");
        out.println("        <h3><i class='fas fa-tasks'></i> Quick Actions</h3>");
        out.println("      </div>");
        out.println("      <div class='card-body'>");
        out.println("        <div class='actions'>");
        out.println("          <a href='#' class='action-btn'>");
        out.println("            <i class='fas fa-user-edit'></i> Update Profile");
        out.println("          </a>");
        out.println("          <a href='#' class='action-btn'>");
        out.println("            <i class='fas fa-key'></i> Change Password");
        out.println("          </a>");
        out.println("          <a href='#' class='action-btn secondary'>");
        out.println("            <i class='fas fa-cog'></i> Settings");
        out.println("          </a>");
        out.println("          <a href='" + request.getContextPath() + "/logout' class='action-btn secondary'>");
        out.println("            <i class='fas fa-sign-out-alt'></i> Logout");
        out.println("          </a>");
        out.println("        </div>");
        out.println("      </div>");
        out.println("    </div>");
        
        // System info card
        out.println("    <div class='card'>");
        out.println("      <div class='card-header'>");
        out.println("        <h3><i class='fas fa-info-circle'></i> System Information</h3>");
        out.println("      </div>");
        out.println("      <div class='card-body'>");
        out.println("        <p><strong>Login Time:</strong> " + new java.util.Date() + "</p>");
        out.println("        <p><strong>Session ID:</strong> " + request.getSession().getId() + "</p>");
        out.println("        <p><strong>Context Path:</strong> " + request.getContextPath() + "</p>");
        out.println("        <p style='margin-top: 1rem; padding: 1rem; background: #fff3cd; border-radius: 4px; color: #856404;'>");
        out.println("          <i class='fas fa-exclamation-triangle'></i> ");
        out.println("          <strong>Note:</strong> This dashboard is generated by the servlet. ");
        out.println("          Create a dashboard.jsp file for a custom design.");
        out.println("        </p>");
        out.println("      </div>");
        out.println("    </div>");
        
        out.println("  </main>");
        out.println("</body>");
        out.println("</html>");
    }
}