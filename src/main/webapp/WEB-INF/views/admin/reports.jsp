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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Report Logs & Moderation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f8fafc; color: #1e293b; }
       
        .main-workspace { margin-left: 260px; flex-grow: 1; display: flex; flex-direction: column; }
        .top-navbar { height: 70px; background-color: #ffffff; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .nav-title { font-size: 18px; font-weight: 600; color: #475569; }
        .user-profile-badge { display: flex; align-items: center; gap: 10px; }
        .badge { background-color: #ef4444; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .content-area { padding: 40px; max-width: 1350px; width: 100%; margin: 0 auto; }
        
        .flash-msg { padding: 14px 20px; border-radius: 10px; margin-bottom: 20px; font-size: 14px; font-weight: 600; display: flex; align-items: center; gap: 10px; }
        .flash-success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .flash-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }

        .section-card { background: white; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; margin-bottom: 40px; overflow: hidden; }
        .section-header { background: #0f172a; color: white; padding: 18px 24px; font-size: 18px; font-weight: 600; display: flex; justify-content: space-between; align-items: center; }
        .section-body { padding: 0; }
        
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th { background: #f1f5f9; padding: 16px 20px; font-weight: 600; color: #475569; border-bottom: 2px solid #e2e8f0; font-size: 13px; text-transform: uppercase; }
        td { padding: 18px 20px; border-bottom: 1px solid #e2e8f0; font-size: 14px; color: #334155; vertical-align: top; }
        tr:hover { background: #f8fafc; }
        
        .reason-badge { background: #fee2e2; color: #991b1b; padding: 4px 8px; border-radius: 6px; font-size: 11px; font-weight: bold; text-transform: uppercase; display: inline-block; }
        .status-badge { padding: 4px 10px; border-radius: 6px; font-size: 11px; font-weight: bold; text-transform: uppercase; display: inline-block; }
        .status-pending { background: #fef3c7; color: #92400e; }
        .status-resolved { background: #dcfce7; color: #166534; }
        .status-dismissed { background: #e2e8f0; color: #475569; }
        .status-other { background: #fef3c7; color: #92400e; }
        
        .auto-delete-badge { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; padding: 4px 8px; border-radius: 6px; font-size: 11px; font-weight: 800; display: inline-flex; align-items: center; gap: 4px; margin-top: 6px; }

        .action-cell { display: flex; gap: 8px; flex-wrap: wrap; }
        .btn { padding: 6px 12px; border: none; border-radius: 6px; font-size: 12px; font-weight: bold; cursor: pointer; transition: all 0.2s; display: inline-flex; align-items: center; gap: 5px; text-decoration: none; }
        .btn-resolve { background-color: #dc2626; color: white; border: none; }
        .btn-resolve:hover { background-color: #b91c1c; }
        .btn-dismiss { background-color: #64748b; color: white; border: none; }
        .btn-dismiss:hover { background-color: #475569; }
        
        .btn-unban { background-color: #ecfdf5; color: #047857; border: 1px solid #a7f3d0; }
        .btn-unban:hover { background-color: #d1fae5; }
        .btn-ban { background-color: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
        .btn-ban:hover { background-color: #fee2e2; }
        .btn-edit { background-color: #eff6ff; color: #1d4ed8; border: 1px solid #bfdbfe; }
        .btn-edit:hover { background-color: #dbeafe; }
        
        .input-reason { padding: 6px 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 12px; width: 140px; }
        .select-scope { padding: 6px 8px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 12px; background: #fff; font-weight: 600; color: #1e293b; }
        
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

        .type-tag-badge { background: #fee2e2; color: #991b1b; padding: 3px 8px; border-radius: 6px; font-size: 11px; font-weight: 700; display: inline-block; margin-top: 4px; border: 1px solid #fecaca; }

        /* ===== MODAL SYSTEM ===== */
        .modal-mask { 
            position: fixed; top:0; left:0; width:100vw; height:100vh; 
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(8px);
            display: flex; align-items: center; justify-content: center; 
            opacity: 0; pointer-events: none; transition: opacity 0.3s ease; z-index: 999; 
        }
        .modal-mask.open { opacity: 1; pointer-events: auto; }
        .modal-body { 
            background: #ffffff; width: 100%; max-width: 520px; padding: 32px; border-radius: 16px; 
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
    String currentRedirectUrl = "/admin/reports?type=" + reportType + "&view=" + reportView;
%>

    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin Panel 👑</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                    <span>📊 Core Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <span>📁 Category Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/tags" class="sidebar-link">
                    <span>🏷️ Tags Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts" class="sidebar-link">
                    <span>📄 Post Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="sidebar-link">
                    <span>⏳ Pending Posts</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <span>👥 User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/announcements" class="sidebar-link">
                    <span>📢 Event Announcements</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link">
                    <span>📄 CheatSheet Report</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link active">
                    <span>🚩 Moderation Reports</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/chat" class="sidebar-link">
                    <span>💬 Chat / Messages</span>
                </a>
            </li>
        </ul>
    </aside>

    <div class="main-workspace">
        <header class="top-navbar">
            <div class="nav-title"><%= isPostType ? "Post Report Logs & Moderation Flow" : "Comment Report Logs & Moderation Flow" %></div>
            <div class="user-profile-badge">
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">

            <% if (session.getAttribute("success") != null || request.getAttribute("success") != null) { %>
                <div class="flash-msg flash-success">
                    ✓ <%= request.getAttribute("success") != null ? request.getAttribute("success") : session.getAttribute("success") %>
                </div>
                <% session.removeAttribute("success"); %>
            <% } %>
            <% if (session.getAttribute("error") != null || request.getAttribute("error") != null) { %>
                <div class="flash-msg flash-error">
                    ⚠ <%= request.getAttribute("error") != null ? request.getAttribute("error") : session.getAttribute("error") %>
                </div>
                <% session.removeAttribute("error"); %>
            <% } %>

            <div class="type-tabs">
                <a href="<%= ctx %>/admin/reports?type=posts&view=<%= reportView %>"
                   class="type-tab <%= isPostType ? "active" : "" %>">📄 Post Reports</a>
                <a href="<%= ctx %>/admin/reports?type=comments&view=<%= reportView %>"
                   class="type-tab <%= !isPostType ? "active" : "" %>">💬 Comment Reports</a>
            </div>

            <div class="view-tabs">
                <a href="<%= ctx %>/admin/reports?type=<%= reportType %>&view=queue"
                   class="view-tab <%= !isHistoryView ? "active" : "" %>">⏳ Pending Queue</a>
                <a href="<%= ctx %>/admin/reports?type=<%= reportType %>&view=history"
                   class="view-tab <%= isHistoryView ? "active" : "" %>">📜 Audit & Moderation History</a>
            </div>
            
            <% if (isPostType) { %>
            <!-- POST REPORTS SECTION -->
            <div class="section-card">
                <div class="section-header">
                    <span><%= isHistoryView ? "📜 Post Report & Moderation History" : "📋 Pending Grouped Post Reports" %></span>
                    <span style="font-size: 13px; font-weight: normal; background: #38bdf8; color: #0f172a; padding: 2px 10px; border-radius: 9999px;">
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
                                        <th>Post Details</th>
                                        <th>Parties Involved</th>
                                        <th>Report Status</th>
                                        <th style="text-align: right;">Moderation Controls</th>
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
                                        boolean isPostBanned = (r.getPost() != null && (Boolean.TRUE.equals(r.getPost().getIsDeleted()) || r.getPost().getStatus() == com.hibernate.entity.enums.PostStatus.BANNED));
                                    %>
                                        <tr>
                                            <td>
                                                <span class="reason-badge"><%= r.getReason() %></span><br/>
                                                <p style="margin-top:8px; font-size:13px; color:#475569;"><%= r.getDescription() != null && !r.getDescription().isEmpty() ? r.getDescription() : "<em>No additional description provided</em>" %></p>
                                                <div class="date-meta">Reported: <%= r.getCreatedAt() %></div>
                                            </td>
                                            <td>
                                                <strong>Title:</strong>
                                                <% if (r.getPost() != null) { %>
                                                    <a href="<%= ctx %>/admin/posts/view/<%= r.getPost().getId() %>" target="_blank" style="color: #0284c7; font-weight: bold; text-decoration: none;"><%= r.getPost().getTitle() %></a>
                                                <% } else { %>
                                                    N/A
                                                <% } %>
                                                <br/>
                                                <span style="font-size:12px; color:#64748b;">Slug: <%= r.getPost() != null ? r.getPost().getSlug() : "N/A" %></span><br/>
                                                <span style="font-size:12px; color:<%= isPostBanned ? "#dc2626" : "#059669" %>; font-weight:600;">
                                                    Status: <%= r.getPost() != null ? r.getPost().getStatus() : "N/A" %>
                                                </span>
                                            </td>
                                            <td>
                                                <span style="font-size:12px;"><strong>Reporter:</strong> @<%= r.getReporter() != null ? r.getReporter().getUsername() : "N/A" %></span><br/>
                                                <span style="font-size:12px;"><strong>Author:</strong> @<%= author != null ? author.getUsername() : "N/A" %></span>
                                            </td>
                                            <td>
                                                <span class="status-badge <%= statusClass %>"><%= status %></span>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                                                    
                                                    <%-- Post Ban / Restore Buttons --%>
                                                    <% if (r.getPost() != null) { %>
                                                        <div style="display:flex; gap:4px;">
                                                            <a href="<%= ctx %>/admin/posts/view/<%= r.getPost().getId() %>" target="_blank" class="btn btn-edit">
                                                                📄 View Details
                                                            </a>
                                                            <% if (isPostBanned) { %>
                                                                <form action="<%= ctx %>/admin/posts/<%= r.getPost().getId() %>/unban" method="POST" style="margin:0;">
                                                                    <button type="submit" class="btn btn-unban" onclick="return confirm('Restore visibility for post: <%= r.getPost().getTitle().replace("'", "\\'") %>?');">
                                                                        🎉 Restore (Unban) Post
                                                                    </button>
                                                                </form>
                                                            <% } else { %>
                                                                <form action="<%= ctx %>/admin/posts/<%= r.getPost().getId() %>/hide" method="POST" style="margin:0;">
                                                                    <input type="hidden" name="reason" value="<%= r.getReason() %>" />
                                                                    <button type="submit" class="btn btn-ban" onclick="return confirm('Ban / Hide post: <%= r.getPost().getTitle().replace("'", "\\'") %>?');">
                                                                        🚫 Ban / Hide Post
                                                                    </button>
                                                                </form>
                                                            <% } %>
                                                        </div>
                                                    <% } %>

                                                    <%-- Author Moderation Controls --%>
                                                    <% if (author != null) { %>
                                                        <% if (isAuthorBanned) { %>
                                                            <div style="display:flex; gap:4px; margin-top:2px;">
                                                                <button type="button" class="btn btn-edit" onclick="openBanModal('<%= author.getId() %>', '<%= author.getUsername().replace("'", "\\'") %>', '<%= author.getBanType() != null ? author.getBanType() : "POST_ONLY" %>', '<%= author.getBanReason() != null ? author.getBanReason().replace("'", "\\'") : "" %>', true)">
                                                                    ✏️ Edit/Unban Author
                                                                </button>
                                                            </div>
                                                            <span class="type-tag-badge">Author Banned</span>
                                                        <% } else { %>
                                                            <button type="button" class="btn btn-ban" onclick="openBanModal('<%= author.getId() %>', '<%= author.getUsername().replace("'", "\\'") %>', 'POST_ONLY', '', false)">
                                                                🚫 Ban Author Account
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
                            <div class="no-data">No pending post reports in queue.</div>
                        <% } else { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Post Details & Author</th>
                                        <th>Report Summary</th>
                                        <th style="width: 480px; text-align: right;">Moderation Flow (Resolve / Dismiss)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (GroupedPostReportDto g : groupedPostReports) {
                                        String detailsId = "post-details-" + g.getPost().getId();
                                        User author = g.getPost().getAuthor();
                                        boolean isAuthorBanned = (author != null && author.isCurrentlyBanned());
                                        boolean isAutoDeleted = (g.getReportCount() >= 10 || Boolean.TRUE.equals(g.getPost().getIsDeleted()) || g.getPost().getStatus() == com.hibernate.entity.enums.PostStatus.BANNED);
                                    %>
                                        <tr>
                                            <td>
                                                <strong style="font-size: 15px;">
                                                    <a href="<%= ctx %>/admin/posts/view/<%= g.getPost().getId() %>" target="_blank" style="color: #0284c7; font-weight: bold; text-decoration: none;"><%= g.getPost().getTitle() %></a>
                                                </strong><br/>
                                                <span style="font-size: 12px; color: #64748b;">Slug: <%= g.getPost().getSlug() %></span><br/>
                                                <span style="font-size: 12px; color: #475569;">Author: <strong>@<%= author != null ? author.getUsername() : "N/A" %></strong></span>
                                                <br/>
                                                <% if (isAutoDeleted) { %>
                                                    <span class="auto-delete-badge">🚨 Auto-Deleted (10+ Reports Threshold Triggered)</span><br/>
                                                <% } %>
                                                <div style="display:flex; gap:6px; flex-wrap:wrap; margin-top:8px;">
                                                    <a href="<%= ctx %>/admin/posts/view/<%= g.getPost().getId() %>" target="_blank" class="btn btn-edit" style="font-size:12px; margin-top:0;">
                                                        📄 View Post Details
                                                    </a>
                                                    <button type="button" class="btn-toggle-details" style="margin-top:0;" onclick="toggleDetails('<%= detailsId %>')">
                                                        👁️ View Reporter Details (<%= g.getReportCount() %>)
                                                    </button>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="count-badge">🔥 <%= g.getReportCount() %> <%= g.getReportCount() > 1 ? "Reports" : "Report" %></span>
                                                <div style="margin-top: 8px;">
                                                    <% for (Map.Entry<ReportReason, Integer> entry : g.getReasonCounts().entrySet()) { %>
                                                        <span class="reason-pill"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                                                    <% } %>
                                                </div>
                                                <div class="date-meta">Latest: <%= g.getLatestReportedAt() %></div>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">

                                                    <%-- RESOLVE & BAN FORM --%>
                                                    <form action="${pageContext.request.contextPath}/admin/reports/posts/group/<%= g.getPost().getId() %>/resolve" method="POST" style="display:flex; flex-wrap:wrap; gap:4px; justify-content:flex-end; align-items:center;">
                                                        <select name="banType" class="select-scope" title="Restriction Scope">
                                                            <option value="POST_ONLY">🚫 Post Ban</option>
                                                            <option value="COMMENT_ONLY">💬 Comment Ban</option>
                                                            <option value="FULL">🔒 Full Ban</option>
                                                        </select>

                                                        <input type="text" name="reason" class="input-reason" placeholder="Ban reason..." required />
                                                        <button type="submit" class="btn btn-resolve" onclick="return confirm('Resolve report, ban post, and restrict author?')">
                                                            ⚔️ Resolve & Ban
                                                        </button>
                                                    </form>

                                                    <%-- DISMISS REPORT FORM --%>
                                                    <form action="${pageContext.request.contextPath}/admin/reports/posts/group/<%= g.getPost().getId() %>/dismiss" method="POST" style="margin:0;">
                                                        <button type="submit" class="btn btn-dismiss" onclick="return confirm('Dismiss reports for this post as invalid / false report?')">
                                                            ✖ Dismiss Reports
                                                        </button>
                                                    </form>
                                                    
                                                    <% if (author != null && isAuthorBanned) { %>
                                                        <span class="type-tag-badge">Author Banned</span>
                                                    <% } %>

                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="<%= detailsId %>" class="details-row">
                                            <td colspan="3">
                                                <div class="details-container">
                                                    <strong style="font-size: 13px; color: #0284c7;">📋 Individual Reports (<%= g.getReportCount() %>):</strong>
                                                    <table class="details-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Reporter</th>
                                                                <th>Reason</th>
                                                                <th>Description</th>
                                                                <th>Date</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (PostReport r : g.getReports()) { %>
                                                                <tr>
                                                                    <td><strong>@<%= r.getReporter().getUsername() %></strong></td>
                                                                    <td><span class="reason-badge"><%= r.getReason() %></span></td>
                                                                    <td><%= r.getDescription() != null && !r.getDescription().isEmpty() ? r.getDescription() : "<em>No description</em>" %></td>
                                                                    <td><%= r.getCreatedAt() %></td>
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
            <!-- COMMENT REPORTS SECTION -->
            <div class="section-card">
                <div class="section-header">
                    <span><%= isHistoryView ? "📜 Comment Report & Moderation History" : "📋 Pending Grouped Comment Reports" %></span>
                    <span style="font-size: 13px; font-weight: normal; background: #38bdf8; color: #0f172a; padding: 2px 10px; border-radius: 9999px;">
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
                                        <th>Comment Details</th>
                                        <th>Parties Involved</th>
                                        <th>Report Status</th>
                                        <th style="text-align: right;">Moderation Controls</th>
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
                                        boolean isCommentHidden = (r.getComment() != null && Boolean.TRUE.equals(r.getComment().getIsDeleted()));
                                    %>
                                        <tr>
                                            <td>
                                                <span class="reason-badge"><%= r.getReason() %></span><br/>
                                                <p style="margin-top:8px; font-size:13px; color:#475569;"><%= r.getDescription() != null && !r.getDescription().isEmpty() ? r.getDescription() : "<em>No additional description provided</em>" %></p>
                                                <div class="date-meta">Reported: <%= r.getCreatedAt() %></div>
                                            </td>
                                            <td>
                                                <p style="background: #f8fafc; padding: 8px; border-radius: 6px; font-size:13px; border-left:3px solid #cbd5e1;">
                                                    "<%= r.getComment() != null ? r.getComment().getContent() : "Deleted Comment" %>"
                                                </p>
                                                <span style="font-size:11px; color:#64748b; margin-top:4px; display:block;">
                                                    On Post:
                                                    <% if (r.getComment() != null && r.getComment().getPost() != null) { %>
                                                        <a href="<%= ctx %>/admin/posts/view/<%= r.getComment().getPost().getId() %>" target="_blank" style="color: #0284c7; font-weight: bold; text-decoration: none;"><%= r.getComment().getPost().getTitle() %></a>
                                                    <% } else { %>
                                                        N/A
                                                    <% } %>
                                                </span>
                                                <span style="font-size:11px; color:<%= isCommentHidden ? "#dc2626" : "#059669" %>; font-weight:600; display:block; margin-bottom:4px;">
                                                    Visibility: <%= isCommentHidden ? "Hidden / Banned" : "Visible" %>
                                                </span>
                                            </td>
                                            <td>
                                                <span style="font-size:12px;"><strong>Reporter:</strong> @<%= r.getReporter() != null ? r.getReporter().getUsername() : "N/A" %></span><br/>
                                                <span style="font-size:12px;"><strong>Commenter:</strong> @<%= commenter != null ? commenter.getUsername() : "N/A" %></span>
                                            </td>
                                            <td>
                                                <span class="status-badge <%= statusClass %>"><%= status %></span>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                                                    
                                                    <%-- Comment Ban / Restore Buttons --%>
                                                    <% if (r.getComment() != null) { %>
                                                         <div style="display:flex; gap:4px;">
                                                             <% if (r.getComment().getPost() != null) { %>
                                                                 <a href="<%= ctx %>/admin/posts/view/<%= r.getComment().getPost().getId() %>" target="_blank" class="btn btn-edit">
                                                                     📄 View Details
                                                                 </a>
                                                             <% } %>
                                                             <% if (isCommentHidden) { %>
                                                                <form action="<%= ctx %>/admin/comments/<%= r.getComment().getId() %>/unban" method="POST" style="margin:0;">
                                                                    <button type="submit" class="btn btn-unban" onclick="return confirm('Restore comment visibility?');">
                                                                        🎉 Restore (Unban) Comment
                                                                    </button>
                                                                </form>
                                                            <% } else { %>
                                                                <form action="<%= ctx %>/admin/comments/<%= r.getComment().getId() %>/hide" method="POST" style="margin:0;">
                                                                    <input type="hidden" name="reason" value="<%= r.getReason() %>" />
                                                                    <button type="submit" class="btn btn-ban" onclick="return confirm('Hide / Ban comment?');">
                                                                        🚫 Ban / Hide Comment
                                                                    </button>
                                                                </form>
                                                            <% } %>
                                                        </div>
                                                    <% } %>

                                                    <%-- Commenter Moderation Controls --%>
                                                    <% if (commenter != null) { %>
                                                        <% if (isCommenterBanned) { %>
                                                            <div style="display:flex; gap:4px; margin-top:2px;">
                                                                <button type="button" class="btn btn-edit" onclick="openBanModal('<%= commenter.getId() %>', '<%= commenter.getUsername().replace("'", "\\'") %>', '<%= commenter.getBanType() != null ? commenter.getBanType() : "COMMENT_ONLY" %>', '<%= commenter.getBanReason() != null ? commenter.getBanReason().replace("'", "\\'") : "" %>', true)">
                                                                    ✏️ Edit/Unban Commenter
                                                                </button>
                                                            </div>
                                                            <span class="type-tag-badge">Commenter Banned</span>
                                                        <% } else { %>
                                                            <button type="button" class="btn btn-ban" onclick="openBanModal('<%= commenter.getId() %>', '<%= commenter.getUsername().replace("'", "\\'") %>', 'COMMENT_ONLY', '', false)">
                                                                🚫 Ban Commenter Account
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
                            <div class="no-data">No pending comment reports in queue.</div>
                        <% } else { %>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Comment Content & Author</th>
                                        <th>Report Summary</th>
                                        <th style="width: 480px; text-align: right;">Moderation Flow (Resolve / Dismiss)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (GroupedCommentReportDto g : groupedCommentReports) {
                                        String detailsId = "comment-details-" + g.getComment().getId();
                                        User commenter = g.getComment().getUser();
                                        boolean isCommenterBanned = (commenter != null && commenter.isCurrentlyBanned());
                                        boolean isAutoDeleted = (g.getReportCount() >= 10 || Boolean.TRUE.equals(g.getComment().getIsDeleted()));
                                     %>
                                        <tr>
                                            <td>
                                                <p style="background: #f8fafc; padding: 10px; border-radius: 6px; font-size:13px; border-left:3px solid #0284c7; color: #1e293b;">
                                                    "<%= g.getComment().getContent() %>"
                                                </p>
                                                <span style="font-size:12px; color:#64748b; margin-top:4px; display:block;">
                                                    On Post:
                                                    <% if (g.getComment().getPost() != null) { %>
                                                        <a href="<%= ctx %>/admin/posts/view/<%= g.getComment().getPost().getId() %>" target="_blank" style="color: #0284c7; font-weight: bold; text-decoration: none;"><%= g.getComment().getPost().getTitle() %></a>
                                                    <% } else { %>
                                                        N/A
                                                    <% } %>
                                                </span>
                                                <span style="font-size:12px; color:#475569;">Commenter: <strong>@<%= commenter != null ? commenter.getUsername() : "N/A" %></strong></span>
                                                <br/>
                                                <% if (isAutoDeleted) { %>
                                                    <span class="auto-delete-badge">🚨 Auto-Deleted (10+ Reports Threshold Triggered)</span><br/>
                                                <% } %>
                                                <div style="display:flex; gap:6px; flex-wrap:wrap; margin-top:8px;">
                                                    <% if (g.getComment().getPost() != null) { %>
                                                        <a href="<%= ctx %>/admin/posts/view/<%= g.getComment().getPost().getId() %>" target="_blank" class="btn btn-edit" style="font-size:12px; text-decoration:none; margin-top:0;">
                                                            📄 View Post Details
                                                        </a>
                                                    <% } %>
                                                    <button type="button" class="btn-toggle-details" style="margin-top:0;" onclick="toggleDetails('<%= detailsId %>')">
                                                        👁️ View Reporter Details (<%= g.getReportCount() %>)
                                                    </button>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="count-badge">🔥 <%= g.getReportCount() %> <%= g.getReportCount() > 1 ? "Reports" : "Report" %></span>
                                                <div style="margin-top: 8px;">
                                                    <% for (Map.Entry<ReportReason, Integer> entry : g.getReasonCounts().entrySet()) { %>
                                                        <span class="reason-pill"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                                                    <% } %>
                                                </div>
                                                <div class="date-meta">Latest: <%= g.getLatestReportedAt() %></div>
                                            </td>
                                            <td style="text-align: right;">
                                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">

                                                    <%-- RESOLVE & BAN FORM --%>
                                                    <form action="${pageContext.request.contextPath}/admin/reports/comments/group/<%= g.getComment().getId() %>/resolve" method="POST" style="display:flex; flex-wrap:wrap; gap:4px; justify-content:flex-end; align-items:center;">
                                                        <select name="banType" class="select-scope" title="Restriction Scope">
                                                            <option value="COMMENT_ONLY">💬 Comment Ban</option>
                                                            <option value="POST_ONLY">🚫 Post Ban</option>
                                                            <option value="FULL">🔒 Full Ban</option>
                                                        </select>

                                                        <input type="text" name="reason" class="input-reason" placeholder="Ban reason..." required />
                                                        <button type="submit" class="btn btn-resolve" onclick="return confirm('Resolve report, hide comment, and restrict commenter?')">
                                                            ⚔️ Resolve & Ban
                                                        </button>
                                                    </form>

                                                    <%-- DISMISS REPORT FORM --%>
                                                    <form action="${pageContext.request.contextPath}/admin/reports/comments/group/<%= g.getComment().getId() %>/dismiss" method="POST" style="margin:0;">
                                                        <button type="submit" class="btn btn-dismiss" onclick="return confirm('Dismiss reports for this comment as invalid / false report?')">
                                                            ✖ Dismiss Reports
                                                        </button>
                                                    </form>

                                                    <% if (commenter != null && isCommenterBanned) { %>
                                                        <span class="type-tag-badge">Commenter Banned</span>
                                                    <% } %>

                                                </div>
                                            </td>
                                        </tr>
                                        <tr id="<%= detailsId %>" class="details-row">
                                            <td colspan="3">
                                                <div class="details-container">
                                                    <strong style="font-size: 13px; color: #0284c7;">📋 Individual Reports (<%= g.getReportCount() %>):</strong>
                                                    <table class="details-table">
                                                        <thead>
                                                            <tr>
                                                                <th>Reporter</th>
                                                                <th>Reason</th>
                                                                <th>Description</th>
                                                                <th>Date</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% for (CommentReport r : g.getReports()) { %>
                                                                <tr>
                                                                    <td><strong>@<%= r.getReporter().getUsername() %></strong></td>
                                                                    <td><span class="reason-badge"><%= r.getReason() %></span></td>
                                                                    <td><%= r.getDescription() != null && !r.getDescription().isEmpty() ? r.getDescription() : "<em>No description</em>" %></td>
                                                                    <td><%= r.getCreatedAt() %></td>
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

    <!-- ===== USER SUSPENSION & EDIT MODAL ===== -->
    <div class="modal-mask" id="banModal" onclick="if(event.target.classList.contains('modal-mask')) this.classList.remove('open')">
        <div class="modal-body" onclick="event.stopPropagation()">
            <button class="modal-close-x" onclick="document.getElementById('banModal').classList.remove('open')">&times;</button>
            <h3 style="font-size: 18px; color: #0f172a; margin-bottom: 8px;">🚫 Suspend / Edit User Restriction</h3>
            <p style="color: #64748b; font-size: 13px; margin-bottom: 16px;">
                Target User: <strong id="banTargetUsername" style="color: #2563eb;">@username</strong>
            </p>

            <form id="banForm" action="" method="POST">
                <input type="hidden" name="redirectUrl" value="<%= currentRedirectUrl %>" />

                <div style="margin-bottom: 14px;">
                    <label style="display: block; font-size: 11px; font-weight: 700; color: #475569; margin-bottom: 4px; text-transform: uppercase;">
                        Restriction Scope:
                    </label>
                    <select id="banTypeSelect" name="banType" style="width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 13px;">
                        <option value="POST_ONLY">Post Creation Restriction Only (Post Ban)</option>
                        <option value="COMMENT_ONLY">Comment Restriction Only (Comment Ban)</option>
                        <option value="FULL">Full Account Suspension (Full Ban)</option>
                    </select>
                </div>

                <div style="margin-bottom: 16px;">
                    <label style="display: block; font-size: 11px; font-weight: 700; color: #475569; margin-bottom: 4px; text-transform: uppercase;">
                        Reason for Suspension:
                    </label>
                    <textarea id="banReasonInput" name="reason" rows="3" required placeholder="Violated community guidelines..." style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 13px;"></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 8px;">
                    <button type="button" class="btn btn-dismiss" onclick="document.getElementById('banModal').classList.remove('open')">Cancel</button>
                    <button type="button" id="unbanModalBtn" class="btn btn-unban" style="display: none;">🔓 Unban User</button>
                    <button type="submit" class="btn btn-resolve"><i class="fas fa-save"></i> Save Ban Settings</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Hidden Unban Form -->
    <form id="modalUnbanForm" action="" method="POST" style="display:none;">
        <input type="hidden" name="redirectUrl" value="<%= currentRedirectUrl %>" />
    </form>

    <script>
        function openBanModal(userId, username, banType, reason, isBanned) {
            document.getElementById('banTargetUsername').textContent = '@' + username;
            document.getElementById('banForm').action = '<%= ctx %>/admin/users/' + userId + '/ban';
            if (banType) {
                document.getElementById('banTypeSelect').value = banType;
            } else {
                document.getElementById('banTypeSelect').selectedIndex = 0;
            }
            if (reason) {
                document.getElementById('banReasonInput').value = reason;
            } else {
                document.getElementById('banReasonInput').value = '';
            }

            var unbanBtn = document.getElementById('unbanModalBtn');
            if (isBanned) {
                unbanBtn.style.display = 'inline-flex';
                unbanBtn.onclick = function() {
                    if (confirm('Pardon and unban user @' + username + '?')) {
                        var form = document.getElementById('modalUnbanForm');
                        form.action = '<%= ctx %>/admin/users/' + userId + '/unban';
                        form.submit();
                    }
                };
            } else {
                unbanBtn.style.display = 'none';
            }

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