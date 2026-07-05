<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="com.hibernate.entity.PostReport" %>
<%@ page import="com.hibernate.entity.CommentReport" %>
<%@ page import="com.hibernate.dto.GroupedPostReportDto" %>
<%@ page import="com.hibernate.dto.GroupedCommentReportDto" %>
<%@ page import="com.hibernate.entity.enums.ReportReason" %>
<%@ page import="com.hibernate.entity.enums.ReportStatus" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin - Report Logs Queue</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        .content-area { padding: 40px; max-width: 1300px; width: 100%; margin: 0 auto; }
        
        .section-card { background: white; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; margin-bottom: 40px; overflow: hidden; }
        .section-header { background: #0f172a; color: white; padding: 18px 24px; font-size: 18px; font-weight: 600; display: flex; justify-content: space-between; align-items: center; }
        .section-body { padding: 0; }
        
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background: #f1f5f9; padding: 16px 20px; font-weight: 600; color: #475569; border-bottom: 2px solid #e2e8f0; font-size: 13px; text-transform: uppercase; }
        td { padding: 18px 20px; border-bottom: 1px solid #e2e8f0; font-size: 14px; color: #334155; vertical-align: top; }
        tr:hover { background: #f8fafc; }
        
        .reason-badge { background: #fee2e2; color: #991b1b; padding: 4px 8px; border-radius: 6px; font-size: 11px; font-weight: bold; text-transform: uppercase; display: inline-block; }
        .status-badge { background: #fef3c7; color: #92400e; padding: 4px 8px; border-radius: 6px; font-size: 11px; font-weight: bold; text-transform: uppercase; display: inline-block; }
        
        .action-cell { display: flex; gap: 8px; flex-wrap: wrap; }
        .btn { padding: 6px 12px; border: none; border-radius: 6px; font-size: 12px; font-weight: bold; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 4px; text-decoration: none; }
        .btn-dismiss { background-color: #cbd5e1; color: #334155; }
        .btn-dismiss:hover { background-color: #94a3b8; color: white; }
        .btn-resolve { background-color: #ef4444; color: white; }
        .btn-resolve:hover { background-color: #dc2626; }
        
        .btn-unban { background-color: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; }
        .btn-unban:hover { background-color: #d1fae5; }
        .btn-ban { background-color: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .btn-ban:hover { background-color: #fee2e2; }
        
        .input-reason { padding: 8px 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px; width: 140px; margin-right: 5px; }
        
        .no-data { padding: 30px; text-align: center; color: #64748b; font-style: italic; }
        .btn-logout { background-color: #64748b; color: white; padding: 8px 16px; text-decoration: none; border-radius: 6px; font-size: 14px; }
        .btn-logout:hover { background-color: #475569; }

        .view-tabs { display: flex; gap: 8px; margin-bottom: 16px; flex-wrap: wrap; }
        .view-tab { padding: 10px 20px; border-radius: 8px; font-size: 14px; font-weight: 600; text-decoration: none; color: #475569; background: #e2e8f0; transition: all 0.2s; }
        .view-tab:hover { background: #cbd5e1; color: #1e293b; }
        .view-tab.active { background: #0284c7; color: white; }

        .type-tabs { display: flex; gap: 8px; margin-bottom: 12px; flex-wrap: wrap; }
        .type-tab { padding: 10px 20px; border-radius: 8px; font-size: 14px; font-weight: 600; text-decoration: none; color: #475569; background: #f1f5f9; border: 2px solid #e2e8f0; transition: all 0.2s; }
        .type-tab:hover { border-color: #94a3b8; color: #1e293b; }
        .type-tab.active { background: #0f172a; border-color: #0f172a; color: white; }

        .status-resolved { background: #dcfce7; color: #166534; }
        .status-dismissed { background: #e2e8f0; color: #475569; }
        .status-other { background: #fef3c7; color: #92400e; }
        .date-meta { font-size: 12px; color: #64748b; margin-top: 6px; }

        /* Grouped Reports UI Styles */
        .count-badge { background: #ef4444; color: white; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 700; display: inline-flex; align-items: center; gap: 4px; }
        .reason-pill { background: #fee2e2; color: #991b1b; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; margin-right: 4px; margin-bottom: 4px; display: inline-block; }
        .btn-toggle-details { background: #f1f5f9; color: #0284c7; border: 1px solid #cbd5e1; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; margin-top: 8px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; transition: all 0.2s; }
        .btn-toggle-details:hover { background: #e2e8f0; color: #0369a1; }
        .details-row { display: none; background: #f8fafc; }
        .details-container { padding: 16px 20px; border-top: 1px dashed #cbd5e1; }
        .details-table { width: 100%; margin-top: 8px; border: 1px solid #e2e8f0; border-radius: 6px; overflow: hidden; background: white; border-collapse: collapse; }
        .details-table th { background: #f1f5f9; font-size: 12px; padding: 10px; border-bottom: 1px solid #e2e8f0; text-transform: uppercase; color: #475569; }
        .details-table td { padding: 10px; font-size: 12px; border-bottom: 1px solid #f1f5f9; color: #334155; }

        /* ===== MODAL SYSTEM ===== */
        .modal-mask { 
            position: fixed; top:0; left:0; width:100vw; height:100vh; 
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(8px);
            display: flex; align-items: center; justify-content: center; 
            opacity: 0; pointer-events: none; transition: opacity 0.3s ease; z-index: 999; 
        }
        .modal-mask.open { opacity: 1; pointer-events: auto; }
        .modal-body { 
            background: #ffffff; width: 100%; max-width: 500px; padding: 32px; border-radius: 16px; 
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.25); position: relative; 
        }
        .modal-close-x { 
            position: absolute; top: 16px; right: 20px; background: #f1f4f9; border: none; width: 32px; height: 32px; border-radius: 50%; font-size: 18px; color: #64748b; cursor: pointer; display: flex; align-items: center; justify-content: center;
        }
    </style>
    <script>
        function toggleDetails(id) {
            var el = document.getElementById(id);
            if (el) {
                el.style.display = (el.style.display === 'table-row') ? 'none' : 'table-row';
            }
        }
    </script>
</head>
<body>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    String displayUsername = (currentUser != null) ? currentUser.getUsername() : "ADMIN";
    String displayRole = (currentUser != null) ? currentUser.getRole().name() : "ADMIN";
    
    List<PostReport> postReports = (List<PostReport>) request.getAttribute("postReports");
    List<CommentReport> commentReports = (List<CommentReport>) request.getAttribute("commentReports");
    List<GroupedPostReportDto> groupedPostReports = (List<GroupedPostReportDto>) request.getAttribute("groupedPostReports");
    List<GroupedCommentReportDto> groupedCommentReports = (List<GroupedCommentReportDto>) request.getAttribute("groupedCommentReports");

    String reportType = (String) request.getAttribute("reportType");
    String reportView = (String) request.getAttribute("reportView");
    if (reportType == null) reportType = "posts";
    if (reportView == null) reportView = "queue";
    boolean isPostType = "posts".equals(reportType);
    boolean isHistoryView = "history".equals(reportView);
    String ctx = request.getContextPath();
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
                <a href="${pageContext.request.contextPath}/admin/announcements" class="sidebar-link">
                    <span>&#128364; Event Announcements</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link">
                    <span>&#128196; CheatSheet Report</span>
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
            <div class="nav-title"><%= isPostType ? "Post Report Logs" : "Comment Report Logs" %></div>
            <div class="user-profile-badge">
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">

            <div class="type-tabs">
                <a href="<%= ctx %>/admin/reports?type=posts&view=<%= reportView %>"
                   class="type-tab <%= isPostType ? "active" : "" %>">&#128196; Post Reports</a>
                <a href="<%= ctx %>/admin/reports?type=comments&view=<%= reportView %>"
                   class="type-tab <%= !isPostType ? "active" : "" %>">&#128172; Comment Reports</a>
            </div>

            <div class="view-tabs">
                <a href="<%= ctx %>/admin/reports?type=<%= reportType %>&view=queue"
                   class="view-tab <%= !isHistoryView ? "active" : "" %>">&#128203; Pending Queue</a>
                <a href="<%= ctx %>/admin/reports?type=<%= reportType %>&view=history"
                   class="view-tab <%= isHistoryView ? "active" : "" %>">&#128337; History</a>
            </div>
            
            <% if (isPostType) { %>
            <!-- POST REPORTS -->
            <div class="section-card">
                <div class="section-header">
                    <span><%= isHistoryView ? "&#128218; Post Report History" : "&#128196; Pending Grouped Post Reports" %></span>
                    <span style="font-size: 13px; font-weight: normal; background: #38bdf8; color: #0f172a; padding: 2px 8px; border-radius: 9999px;">
                        <%= isHistoryView ? (postReports != null ? postReports.size() : 0) : (groupedPostReports != null ? groupedPostReports.size() : 0) %> <%= isHistoryView ? "records" : "reported posts" %>
                    </span>
                </div>
                <div class="section-body">
                    <% if (isHistoryView) { %>
                        <% if (postReports == null || postReports.isEmpty()) { %>
                            <div class="no-data">No post report history found.</div>
                        <% } else { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Report Details</th>
                                        <th>Post Info</th>
                                        <th>Parties Involved</th>
                                        <th>Outcome</th>
                                        <th style="text-align: right;">Admin Control</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (PostReport r : postReports) {
                                        ReportStatus status = r.getStatus();
                                        String statusClass = "status-other";
                                        if (ReportStatus.RESOLVED.equals(status)) statusClass = "status-resolved";
                                        else if (ReportStatus.DISMISSED.equals(status)) statusClass = "status-dismissed";
                                        User author = (r.getPost() != null) ? r.getPost().getAuthor() : null;
                                        boolean isAuthorBanned = (author != null && author.isCurrentlyBanned());
                                    %>
                                        <tr>
                                            <td>
                                                <span class="reason-badge"><%= r.getReason() %></span><br/>
                                                <p style="margin-top:8px; font-size:13px; color:#475569;"><%= r.getDescription() %></p>
                                                <div class="date-meta">Reported: <%= r.getCreatedAt() %></div>
                                            </td>
                                            <td>
                                                <strong>Title:</strong> <%= r.getPost() != null ? r.getPost().getTitle() : "N/A" %><br/>
                                                <span style="font-size:12px; color:#64748b;">Slug: <%= r.getPost() != null ? r.getPost().getSlug() : "N/A" %></span>
                                            </td>
                                            <td>
                                                <span style="font-size:12px;"><strong>Reporter:</strong> @<%= r.getReporter() != null ? r.getReporter().getUsername() : "N/A" %></span><br/>
                                                <span style="font-size:12px;"><strong>Author:</strong> @<%= author != null ? author.getUsername() : "N/A" %></span>
                                            </td>
                                            <td>
                                                <span class="status-badge <%= statusClass %>"><%= status %></span>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 6px;">
                                                    <% if (author != null) { %>
                                                        <% if (isAuthorBanned) { %>
                                                            <form action="<%= ctx %>/admin/users/<%= author.getId() %>/unban" method="POST" style="margin:0;">
                                                                <button type="submit" class="btn btn-unban" onclick="return confirm('Author အား ကင်းလွှတ်ခွင့် ပေးပြီး (Unban) ပြန်ဖွင့်ပေးမှာ သေချာပါသလား။');">
                                                                    <i class="fas fa-key"></i> 🎉 Unban (ကင်းလွှတ်ခွင့်)
                                                                </button>
                                                            </form>
                                                            <span style="font-size:10px; color:#dc2626; font-weight:600;"><%= author.getBanRemainingText() %></span>
                                                        <% } else { %>
                                                            <button type="button" class="btn btn-ban" onclick="openBanModal('<%= author.getId() %>', '<%= author.getUsername().replace("'", "\\'") %>')">
                                                                <i class="fas fa-ban"></i> Ban Author
                                                            </button>
                                                        <% } %>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    <% } else { %>
                        <!-- PENDING QUEUE (GROUPED BY POST) -->
                        <% if (groupedPostReports == null || groupedPostReports.isEmpty()) { %>
                            <div class="no-data">No pending post reports found.</div>
                        <% } else { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Post Details & Author</th>
                                        <th>Report Summary</th>
                                        <th style="width: 340px; text-align: right;">Group Actions & Admin Control</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (GroupedPostReportDto g : groupedPostReports) {
                                        String detailsId = "post-details-" + g.getPost().getId();
                                        User author = g.getPost().getAuthor();
                                        boolean isAuthorBanned = (author != null && author.isCurrentlyBanned());
                                    %>
                                        <tr>
                                            <td>
                                                <strong style="font-size: 15px; color: #0f172a;"><%= g.getPost().getTitle() %></strong><br/>
                                                <span style="font-size: 12px; color: #64748b;">Slug: <%= g.getPost().getSlug() %></span><br/>
                                                <span style="font-size: 12px; color: #475569;">Author: <strong>@<%= author != null ? author.getUsername() : "N/A" %></strong></span>
                                                <br/>
                                                <button type="button" class="btn-toggle-details" onclick="toggleDetails('<%= detailsId %>')">
                                                    &#128065; View Reporter Details (<%= g.getReportCount() %>)
                                                </button>
                                            </td>
                                            <td>
                                                <span class="count-badge">&#128293; <%= g.getReportCount() %> <%= g.getReportCount() > 1 ? "Reports" : "Report" %></span>
                                                <div style="margin-top: 8px;">
                                                    <% for (Map.Entry<ReportReason, Integer> entry : g.getReasonCounts().entrySet()) { %>
                                                        <span class="reason-pill"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                                                    <% } %>
                                                </div>
                                                <div class="date-meta">Latest: <%= g.getLatestReportedAt() %></div>
                                            </td>
                                            <td style="text-align: right;">
                                                <div class="action-cell" style="justify-content: flex-end;">
                                                    <form action="${pageContext.request.contextPath}/admin/reports/posts/group/<%= g.getPost().getId() %>/dismiss" method="POST" style="display:inline;">
                                                        <button type="submit" class="btn btn-dismiss" onclick="return confirm('Dismiss ALL <%= g.getReportCount() %> reports for this post as false alarm?')">Dismiss Group</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/reports/posts/group/<%= g.getPost().getId() %>/resolve" method="POST" style="display:inline; margin-top:4px;">
                                                        <input type="text" name="reason" class="input-reason" placeholder="Resolution reason..." required />
                                                        <button type="submit" class="btn btn-resolve" onclick="return confirm('Resolve group: remove post and clear all <%= g.getReportCount() %> pending reports?')">Resolve & Remove</button>
                                                    </form>
                                                    
                                                    <% if (author != null) { %>
                                                        <% if (isAuthorBanned) { %>
                                                            <form action="<%= ctx %>/admin/users/<%= author.getId() %>/unban" method="POST" style="display:inline; margin-top:4px;">
                                                                <button type="submit" class="btn btn-unban" onclick="return confirm('Author အား ကင်းလွှတ်ခွင့် ပေးပြီး (Unban) ပြန်ဖွင့်ပေးမှာ သေချာပါသလား။');">
                                                                    <i class="fas fa-key"></i> 🎉 Unban Author
                                                                </button>
                                                            </form>
                                                        <% } else { %>
                                                            <button type="button" class="btn btn-ban" style="margin-top:4px;" onclick="openBanModal('<%= author.getId() %>', '<%= author.getUsername().replace("'", "\\'") %>')">
                                                                <i class="fas fa-ban"></i> Ban Author
                                                            </button>
                                                        <% } %>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="<%= detailsId %>" class="details-row">
                                            <td colspan="3">
                                                <div class="details-container">
                                                    <strong style="font-size: 13px; color: #0284c7;">&#128203; Individual Reports (<%= g.getReportCount() %>):</strong>
                                                    <table class="details-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Reporter</th>
                                                                <th>Reason</th>
                                                                <th>Description</th>
                                                                <th>Date</th>
                                                                <th>Individual Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (PostReport r : g.getReports()) { %>
                                                                <tr>
                                                                    <td><strong>@<%= r.getReporter().getUsername() %></strong></td>
                                                                    <td><span class="reason-badge"><%= r.getReason() %></span></td>
                                                                    <td><%= r.getDescription() != null && !r.getDescription().isEmpty() ? r.getDescription() : "<em>No description</em>" %></td>
                                                                    <td><%= r.getCreatedAt() %></td>
                                                                    <td>
                                                                        <form action="${pageContext.request.contextPath}/admin/reports/posts/<%= r.getId() %>/dismiss" method="POST" style="display:inline;">
                                                                            <button type="submit" class="btn btn-dismiss" style="padding: 4px 8px; font-size:11px;" onclick="return confirm('Dismiss only this single report?')">Dismiss</button>
                                                                        </form>
                                                                    </td>
                                                                </tr>
                                                            <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <% } else { %>
            <!-- COMMENT REPORTS -->
            <div class="section-card">
                <div class="section-header">
                    <span><%= isHistoryView ? "&#128218; Comment Report History" : "&#128172; Pending Grouped Comment Reports" %></span>
                    <span style="font-size: 13px; font-weight: normal; background: #38bdf8; color: #0f172a; padding: 2px 8px; border-radius: 9999px;">
                        <%= isHistoryView ? (commentReports != null ? commentReports.size() : 0) : (groupedCommentReports != null ? groupedCommentReports.size() : 0) %> <%= isHistoryView ? "records" : "reported comments" %>
                    </span>
                </div>
                <div class="section-body">
                    <% if (isHistoryView) { %>
                        <% if (commentReports == null || commentReports.isEmpty()) { %>
                            <div class="no-data">No comment report history found.</div>
                        <% } else { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Report Details</th>
                                        <th>Comment Info</th>
                                        <th>Parties Involved</th>
                                        <th>Outcome</th>
                                        <th style="text-align: right;">Admin Control</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (CommentReport r : commentReports) {
                                        ReportStatus status = r.getStatus();
                                        String statusClass = "status-other";
                                        if (ReportStatus.RESOLVED.equals(status)) statusClass = "status-resolved";
                                        else if (ReportStatus.DISMISSED.equals(status)) statusClass = "status-dismissed";
                                        User commenter = (r.getComment() != null) ? r.getComment().getUser() : null;
                                        boolean isCommenterBanned = (commenter != null && commenter.isCurrentlyBanned());
                                    %>
                                        <tr>
                                            <td>
                                                <span class="reason-badge"><%= r.getReason() %></span><br/>
                                                <p style="margin-top:8px; font-size:13px; color:#475569;"><%= r.getDescription() %></p>
                                                <div class="date-meta">Reported: <%= r.getCreatedAt() %></div>
                                            </td>
                                            <td>
                                                <p style="background: #f8fafc; padding: 8px; border-radius: 6px; font-size:13px; border-left:3px solid #cbd5e1;">
                                                    "<%= r.getComment() != null ? r.getComment().getContent() : "Deleted Comment" %>"
                                                </p>
                                                <span style="font-size:11px; color:#64748b; margin-top:4px; display:block;">On Post: <%= (r.getComment() != null && r.getComment().getPost() != null) ? r.getComment().getPost().getTitle() : "N/A" %></span>
                                            </td>
                                            <td>
                                                <span style="font-size:12px;"><strong>Reporter:</strong> @<%= r.getReporter() != null ? r.getReporter().getUsername() : "N/A" %></span><br/>
                                                <span style="font-size:12px;"><strong>Commenter:</strong> @<%= commenter != null ? commenter.getUsername() : "N/A" %></span>
                                            </td>
                                            <td>
                                                <span class="status-badge <%= statusClass %>"><%= status %></span>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 6px;">
                                                    <% if (commenter != null) { %>
                                                        <% if (isCommenterBanned) { %>
                                                            <!-- 🎉 UNBAN / PARDON BUTTON IN HISTORY -->
                                                            <form action="<%= ctx %>/admin/users/<%= commenter.getId() %>/unban" method="POST" style="margin:0;">
                                                                <button type="submit" class="btn btn-unban" onclick="return confirm('Commenter အား ကင်းလွှတ်ခွင့် ပေးပြီး (Unban) ပြန်ဖွင့်ပေးမှာ သေချာပါသလား။');">
                                                                    <i class="fas fa-key"></i> 🎉 Unban (ကင်းလွှတ်ခွင့်)
                                                                </button>
                                                            </form>
                                                            <span style="font-size:10px; color:#dc2626; font-weight:600;"><%= commenter.getBanRemainingText() %></span>
                                                        <% } else { %>
                                                            <button type="button" class="btn btn-ban" onclick="openBanModal('<%= commenter.getId() %>', '<%= commenter.getUsername().replace("'", "\\'") %>')">
                                                                <i class="fas fa-ban"></i> Ban Commenter
                                                            </button>
                                                        <% } %>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    <% } else { %>
                        <!-- PENDING QUEUE (GROUPED BY COMMENT) -->
                        <% if (groupedCommentReports == null || groupedCommentReports.isEmpty()) { %>
                            <div class="no-data">No pending comment reports found.</div>
                        <% } else { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Comment Content & Author</th>
                                        <th>Report Summary</th>
                                        <th style="width: 340px; text-align: right;">Group Actions & Admin Control</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (GroupedCommentReportDto g : groupedCommentReports) {
                                        String detailsId = "comment-details-" + g.getComment().getId();
                                        User commenter = g.getComment().getUser();
                                        boolean isCommenterBanned = (commenter != null && commenter.isCurrentlyBanned());
                                    %>
                                        <tr>
                                            <td>
                                                <p style="background: #f8fafc; padding: 10px; border-radius: 6px; font-size:13px; border-left:3px solid #0284c7; color: #1e293b;">
                                                    "<%= g.getComment().getContent() %>"
                                                </p>
                                                <span style="font-size:12px; color:#64748b; margin-top:4px; display:block;">On Post: <strong><%= g.getComment().getPost() != null ? g.getComment().getPost().getTitle() : "N/A" %></strong></span>
                                                <span style="font-size:12px; color:#475569;">Commenter: <strong>@<%= commenter != null ? commenter.getUsername() : "N/A" %></strong></span>
                                                <br/>
                                                <button type="button" class="btn-toggle-details" onclick="toggleDetails('<%= detailsId %>')">
                                                    &#128065; View Reporter Details (<%= g.getReportCount() %>)
                                                </button>
                                            </td>
                                            <td>
                                                <span class="count-badge">&#128293; <%= g.getReportCount() %> <%= g.getReportCount() > 1 ? "Reports" : "Report" %></span>
                                                <div style="margin-top: 8px;">
                                                    <% for (Map.Entry<ReportReason, Integer> entry : g.getReasonCounts().entrySet()) { %>
                                                        <span class="reason-pill"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                                                    <% } %>
                                                </div>
                                                <div class="date-meta">Latest: <%= g.getLatestReportedAt() %></div>
                                            </td>
                                            <td style="text-align: right;">
                                                <div class="action-cell" style="justify-content: flex-end;">
                                                    <form action="${pageContext.request.contextPath}/admin/reports/comments/group/<%= g.getComment().getId() %>/dismiss" method="POST" style="display:inline;">
                                                        <button type="submit" class="btn btn-dismiss" onclick="return confirm('Dismiss ALL <%= g.getReportCount() %> reports for this comment as false alarm?')">Dismiss Group</button>
                                                    </form>
                                                    <form action="${pageContext.request.contextPath}/admin/reports/comments/group/<%= g.getComment().getId() %>/resolve" method="POST" style="display:inline; margin-top:4px;">
                                                        <input type="text" name="reason" class="input-reason" placeholder="Resolution reason..." required />
                                                        <button type="submit" class="btn btn-resolve" onclick="return confirm('Resolve group: delete comment, ban commenter, and clear all <%= g.getReportCount() %> pending reports?')">Resolve & Ban</button>
                                                    </form>

                                                    <% if (commenter != null) { %>
                                                        <% if (isCommenterBanned) { %>
                                                            <form action="<%= ctx %>/admin/users/<%= commenter.getId() %>/unban" method="POST" style="display:inline; margin-top:4px;">
                                                                <button type="submit" class="btn btn-unban" onclick="return confirm('Commenter အား ကင်းလွှတ်ခွင့် ပေးပြီး (Unban) ပြန်ဖွင့်ပေးမှာ သေချာပါသလား။');">
                                                                    <i class="fas fa-key"></i> 🎉 Unban Commenter
                                                                </button>
                                                            </form>
                                                        <% } else { %>
                                                            <button type="button" class="btn btn-ban" style="margin-top:4px;" onclick="openBanModal('<%= commenter.getId() %>', '<%= commenter.getUsername().replace("'", "\\'") %>')">
                                                                <i class="fas fa-ban"></i> Ban Commenter
                                                            </button>
                                                        <% } %>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="<%= detailsId %>" class="details-row">
                                            <td colspan="3">
                                                <div class="details-container">
                                                    <strong style="font-size: 13px; color: #0284c7;">&#128203; Individual Reports (<%= g.getReportCount() %>):</strong>
                                                    <table class="details-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Reporter</th>
                                                                <th>Reason</th>
                                                                <th>Description</th>
                                                                <th>Date</th>
                                                                <th>Individual Action</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (CommentReport r : g.getReports()) { %>
                                                                <tr>
                                                                    <td><strong>@<%= r.getReporter().getUsername() %></strong></td>
                                                                    <td><span class="reason-badge"><%= r.getReason() %></span></td>
                                                                    <td><%= r.getDescription() != null && !r.getDescription().isEmpty() ? r.getDescription() : "<em>No description</em>" %></td>
                                                                    <td><%= r.getCreatedAt() %></td>
                                                                    <td>
                                                                        <form action="${pageContext.request.contextPath}/admin/reports/comments/<%= r.getId() %>/dismiss" method="POST" style="display:inline;">
                                                                            <button type="submit" class="btn btn-dismiss" style="padding: 4px 8px; font-size:11px;" onclick="return confirm('Dismiss only this single report?')">Dismiss</button>
                                                                        </form>
                                                                    </td>
                                                                </tr>
                                                            <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>

        </main>
    </div>

    <!-- ===== TIMED BAN MODAL ===== -->
    <div class="modal-mask" id="banModal" onclick="if(event.target.classList.contains('modal-mask')) this.classList.remove('open')">
        <div class="modal-body" onclick="event.stopPropagation()">
            <button class="modal-close-x" onclick="document.getElementById('banModal').classList.remove('open')">&times;</button>
            <h3 style="font-size: 18px; color: #0f1724; margin-bottom: 8px;">🚫 Suspend / Ban User</h3>
            <p style="color: #64748b; font-size: 13px; margin-bottom: 16px;">
                Target User: <strong id="banTargetUsername" style="color: #2563eb;">@username</strong>
            </p>

            <form id="banForm" action="" method="POST">
                <div style="margin-bottom: 14px;">
                    <label style="display: block; font-size: 11px; font-weight: 700; color: #475569; margin-bottom: 4px; text-transform: uppercase;">
                        Ban Duration (အချိန်ကာလ သတ်မှတ်ချက်):
                    </label>
                    <select name="duration" style="width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 13px;">
                        <option value="1_WEEK">1 Week (၁ ပတ်)</option>
                        <option value="1_MONTH">1 Month (၁ လ)</option>
                        <option value="1_YEAR">1 Year (၁ နှစ်)</option>
                        <option value="PERMANENT">Permanent Ban (ထာဝရ ပိတ်ပင်မည်)</option>
                    </select>
                </div>

                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 11px; font-weight: 700; color: #475569; margin-bottom: 4px; text-transform: uppercase;">
                        Reason for Suspension (အကြောင်းအရင်း):
                    </label>
                    <textarea name="reason" rows="3" required placeholder="Violated community guidelines..." style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 13px;"></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 8px;">
                    <button type="button" class="btn btn-dismiss" onclick="document.getElementById('banModal').classList.remove('open')">Cancel</button>
                    <button type="submit" class="btn btn-resolve">Confirm Ban / Suspend</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openBanModal(userId, username) {
            document.getElementById('banTargetUsername').textContent = '@' + username;
            document.getElementById('banForm').action = '<%= ctx %>/admin/users/' + userId + '/ban';
            document.getElementById('banModal').classList.add('open');
        }

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                var modal = document.getElementById('banModal');
                if (modal) modal.classList.remove('open');
            }
        });
    </script>

</body>
</html>
