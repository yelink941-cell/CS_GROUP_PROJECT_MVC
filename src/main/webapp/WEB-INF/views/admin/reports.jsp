<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="com.hibernate.entity.PostReport" %>
<%@ page import="com.hibernate.entity.CommentReport" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Report Logs Queue</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f8fafc; color: #1e293b; }
        .sidebar { width: 260px; background-color: #1e293b; color: #fff; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-brand { padding: 24px; font-size: 20px; font-weight: bold; background-color: #0f172a; text-align: center; color: #38bdf8; }
        .sidebar-menu { list-style: none; flex-grow: 1; padding: 20px 0; }
        .sidebar-item { margin: 4px 15px; }
        .sidebar-link { display: flex; align-items: center; padding: 12px 16px; color: #cbd5e1; text-decoration: none; border-radius: 6px; font-size: 15px; transition: all 0.2s; }
        .sidebar-link:hover { background-color: #334155; color: #fff; }
        .sidebar-link.active { background-color: #0284c7; color: #fff; font-weight: 600; }
        .main-workspace { margin-left: 260px; flex-grow: 1; display: flex; flex-direction: column; }
        .top-navbar { height: 70px; background-color: #ffffff; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .nav-title { font-size: 18px; font-weight: 600; color: #475569; }
        .user-profile-badge { display: flex; align-items: center; gap: 10px; }
        .badge { background-color: #ef4444; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .content-area { padding: 40px; max-width: 1200px; width: 100%; margin: 0 auto; }
        
        .section-card { background: white; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; margin-bottom: 40px; overflow: hidden; }
        .section-header { background: #0f172a; color: white; padding: 18px 24px; font-size: 18px; font-weight: 600; display: flex; justify-content: space-between; align-items: center; }
        .section-body { padding: 0; }
        
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background: #f1f5f9; padding: 16px 20px; font-weight: 600; color: #475569; border-bottom: 2px solid #e2e8f0; font-size: 14px; text-transform: uppercase; }
        td { padding: 18px 20px; border-bottom: 1px solid #e2e8f0; font-size: 14px; color: #334155; vertical-align: top; }
        tr:hover { background: #f8fafc; }
        
        .reason-badge { background: #fee2e2; color: #991b1b; padding: 4px 8px; border-radius: 6px; font-size: 11px; font-weight: bold; text-transform: uppercase; display: inline-block; }
        .status-badge { background: #fef3c7; color: #92400e; padding: 4px 8px; border-radius: 6px; font-size: 11px; font-weight: bold; text-transform: uppercase; display: inline-block; }
        
        .action-cell { display: flex; gap: 8px; flex-wrap: wrap; }
        .btn { padding: 8px 14px; border: none; border-radius: 6px; font-size: 13px; font-weight: bold; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; }
        .btn-dismiss { background-color: #cbd5e1; color: #334155; }
        .btn-dismiss:hover { background-color: #94a3b8; color: white; }
        .btn-resolve { background-color: #ef4444; color: white; }
        .btn-resolve:hover { background-color: #dc2626; }
        
        .input-reason { padding: 8px 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px; width: 150px; margin-right: 5px; }
        
        .no-data { padding: 30px; text-align: center; color: #64748b; font-style: italic; }
        .btn-logout { background-color: #64748b; color: white; padding: 8px 16px; text-decoration: none; border-radius: 6px; font-size: 14px; }
        .btn-logout:hover { background-color: #475569; }
    </style>
</head>
<body>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    String displayUsername = (currentUser != null) ? currentUser.getUsername() : "ADMIN";
    String displayRole = (currentUser != null) ? currentUser.getRole().name() : "ADMIN";
    
    List<PostReport> postReports = (List<PostReport>) request.getAttribute("postReports");
    List<CommentReport> commentReports = (List<CommentReport>) request.getAttribute("commentReports");
%>

    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin Panel &#128081;</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                    <span>&#128202; Core Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <span>&#128451; Category Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts" class="sidebar-link">
                    <span>&#128221; Post Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="sidebar-link">
                    <span>&#9203; Pending Posts</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/comments" class="sidebar-link">
                    <span>&#128172; Comment Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <span>&#128101; User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link active">
                    <span>&#128680; Report Logs</span>
                </a>
            </li>
        </ul>
    </aside>

    <div class="main-workspace">
        <header class="top-navbar">
            <div class="nav-title">Content Abuse & Reporting Logs</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">
            
            <!-- POST REPORTS -->
            <div class="section-card">
                <div class="section-header">
                    <span>&#128196; Pending Post Reports</span>
                    <span style="font-size: 13px; font-weight: normal; background: #38bdf8; color: #0f172a; padding: 2px 8px; border-radius: 9999px;">
                        <%= postReports != null ? postReports.size() : 0 %> pending
                    </span>
                </div>
                <div class="section-body">
                    <% if (postReports == null || postReports.isEmpty()) { %>
                        <div class="no-data">No pending post reports found.</div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Report Details</th>
                                    <th>Post Info</th>
                                    <th>Parties Involved</th>
                                    <th style="width: 320px;">Administrative Handling</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (PostReport r : postReports) { %>
                                    <tr>
                                        <td>
                                            <span class="reason-badge"><%= r.getReason() %></span><br/>
                                            <p style="margin-top:8px; font-size:13px; color:#475569;"><%= r.getDescription() %></p>
                                        </td>
                                        <td>
                                            <strong>Title:</strong> <%= r.getPost().getTitle() %><br/>
                                            <span style="font-size:12px; color:#64748b;">Slug: <%= r.getPost().getSlug() %></span>
                                        </td>
                                        <td>
                                            <span style="font-size:12px;"><strong>Reporter:</strong> @<%= r.getReporter().getUsername() %></span><br/>
                                            <span style="font-size:12px;"><strong>Author:</strong> @<%= r.getPost().getAuthor().getUsername() %></span>
                                        </td>
                                        <td>
                                            <div class="action-cell">
                                                <form action="${pageContext.request.contextPath}/admin/reports/posts/<%= r.getId() %>/dismiss" method="POST" style="display:inline;">
                                                    <button type="submit" class="btn btn-dismiss" onclick="return confirm('Dismiss this report as false alarm?')">Dismiss</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/reports/posts/<%= r.getId() %>/resolve" method="POST" style="display:inline;">
                                                    <input type="text" name="reason" class="input-reason" placeholder="Resolution reason..." required />
                                                    <button type="submit" class="btn btn-resolve" onclick="return confirm('Resolve report: soft delete post and BAN the author?')">Resolve & Ban</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>

            <!-- COMMENT REPORTS -->
            <div class="section-card">
                <div class="section-header">
                    <span>&#128172; Pending Comment Reports</span>
                    <span style="font-size: 13px; font-weight: normal; background: #38bdf8; color: #0f172a; padding: 2px 8px; border-radius: 9999px;">
                        <%= commentReports != null ? commentReports.size() : 0 %> pending
                    </span>
                </div>
                <div class="section-body">
                    <% if (commentReports == null || commentReports.isEmpty()) { %>
                        <div class="no-data">No pending comment reports found.</div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Report Details</th>
                                    <th>Comment Info</th>
                                    <th>Parties Involved</th>
                                    <th style="width: 320px;">Administrative Handling</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (CommentReport r : commentReports) { %>
                                    <tr>
                                        <td>
                                            <span class="reason-badge"><%= r.getReason() %></span><br/>
                                            <p style="margin-top:8px; font-size:13px; color:#475569;"><%= r.getDescription() %></p>
                                        </td>
                                        <td>
                                            <p style="background: #f8fafc; padding: 8px; border-radius: 6px; font-size:13px; border-left:3px solid #cbd5e1;">
                                                "<%= r.getComment().getContent() %>"
                                            </p>
                                            <span style="font-size:11px; color:#64748b; margin-top:4px; display:block;">On Post: <%= r.getComment().getPost().getTitle() %></span>
                                        </td>
                                        <td>
                                            <span style="font-size:12px;"><strong>Reporter:</strong> @<%= r.getReporter().getUsername() %></span><br/>
                                            <span style="font-size:12px;"><strong>Commenter:</strong> @<%= r.getComment().getUser().getUsername() %></span>
                                        </td>
                                        <td>
                                            <div class="action-cell">
                                                <form action="${pageContext.request.contextPath}/admin/reports/comments/<%= r.getId() %>/dismiss" method="POST" style="display:inline;">
                                                    <button type="submit" class="btn btn-dismiss" onclick="return confirm('Dismiss this report as false alarm?')">Dismiss</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/admin/reports/comments/<%= r.getId() %>/resolve" method="POST" style="display:inline;">
                                                    <input type="text" name="reason" class="input-reason" placeholder="Resolution reason..." required />
                                                    <button type="submit" class="btn btn-resolve" onclick="return confirm('Resolve report: soft delete comment and BAN the commenter?')">Resolve & Ban</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>

        </main>
    </div>

</body>
</html>
