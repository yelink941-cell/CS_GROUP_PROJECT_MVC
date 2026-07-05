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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report Logs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
    <style>
        /* ============================================
           REPORT LOGS - ADDITIONAL STYLES
           ============================================ */
        
        /* Alert Messages */
        .alert-success {
            background: #dcfce7;
            color: #16a34a;
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #16a34a;
        }
        
        .alert-error {
            background: #fee2e2;
            color: #dc2626;
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid #dc2626;
        }
        
        /* Welcome Card */
        .welcome-card {
            background: #ffffff;
            padding: 30px 35px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 8px solid #ef4444;
            margin-bottom: 30px;
        }
        
        .welcome-card h2 {
            font-size: 24px;
            color: #1e293b;
            margin: 0 0 8px 0;
        }
        
        .welcome-card p {
            color: #64748b;
            margin: 0;
            font-size: 15px;
            line-height: 1.6;
        }
        
        /* Stats Cards */
        .report-stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .report-stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 6px solid #ef4444;
            transition: all 0.3s ease;
        }
        
        .report-stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .report-stat-card.blue { border-left-color: #3b82f6; }
        .report-stat-card.green { border-left-color: #10b981; }
        .report-stat-card.orange { border-left-color: #f59e0b; }
        .report-stat-card.purple { border-left-color: #8b5cf6; }
        .report-stat-card.red { border-left-color: #ef4444; }
        
        .report-stat-number {
            font-size: 30px;
            font-weight: 800;
            color: #1e293b;
        }
        
        .report-stat-label {
            font-size: 14px;
            color: #64748b;
            margin-top: 4px;
        }
        
        .report-stat-icon {
            float: right;
            font-size: 26px;
            opacity: 0.25;
        }
        
        /* Section Cards */
        .section-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            margin-bottom: 30px;
            overflow: hidden;
        }
        
        .section-header {
            background: #f8fafc;
            padding: 16px 24px;
            font-size: 16px;
            font-weight: 700;
            color: #1e293b;
            border-bottom: 2px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .section-header .count-badge {
            font-size: 13px;
            font-weight: 600;
            background: #dbeafe;
            color: #1d4ed8;
            padding: 4px 16px;
            border-radius: 20px;
        }
        
        .section-body {
            padding: 0;
        }
        
        /* View Tabs */
        .view-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 16px;
            flex-wrap: wrap;
        }
        
        .view-tab {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            color: #475569;
            background: #e2e8f0;
            transition: all 0.2s;
        }
        
        .view-tab:hover {
            background: #cbd5e1;
            color: #1e293b;
        }
        
        .view-tab.active {
            background: #0284c7;
            color: white;
        }
        
        /* Type Tabs */
        .type-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }
        
        .type-tab {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            color: #475569;
            background: #f1f5f9;
            border: 2px solid #e2e8f0;
            transition: all 0.2s;
        }
        
        .type-tab:hover {
            border-color: #94a3b8;
            color: #1e293b;
        }
        
        .type-tab.active {
            background: #0f172a;
            border-color: #0f172a;
            color: white;
        }
        
        /* Table */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
        }
        
        .data-table thead {
            background: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .data-table th {
            padding: 14px 18px;
            text-align: left;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #475569;
            white-space: nowrap;
        }
        
        .data-table td {
            padding: 14px 18px;
            border-bottom: 1px solid #f1f5f9;
            color: #1e293b;
            vertical-align: middle;
        }
        
        .data-table tbody tr:hover {
            background: #f8fafc;
        }
        
        .data-table tbody tr:last-child td {
            border-bottom: none;
        }
        
        /* Reason Badge */
        .reason-badge {
            background: #fef2f2;
            color: #991b1b;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            display: inline-block;
            border: 1px solid #fecaca;
        }
        
        /* Status Badge */
        .status-badge {
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-resolved {
            background: #dcfce7;
            color: #166534;
        }
        
        .status-dismissed {
            background: #e2e8f0;
            color: #475569;
        }
        
        .status-other {
            background: #fef3c7;
            color: #92400e;
        }
        
        .date-meta {
            font-size: 12px;
            color: #64748b;
            margin-top: 6px;
        }
        
        /* Comment Preview */
        .comment-preview {
            background: #f8fafc;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 13px;
            border-left: 3px solid #3b82f6;
            color: #475569;
            margin: 0;
            font-style: italic;
            max-width: 250px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .comment-meta {
            font-size: 11px;
            color: #94a3b8;
            margin-top: 4px;
            display: block;
        }
        
        /* Action Buttons */
        .action-btn {
            padding: 6px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
        }
        
        .action-btn.dismiss {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
        
        .action-btn.dismiss:hover {
            background: #e2e8f0;
            color: #0f172a;
        }
        
        .action-btn.resolve {
            background: #ef4444;
            color: white;
        }
        
        .action-btn.resolve:hover {
            background: #dc2626;
        }
        
        .action-btn.resolve:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        /* Input */
        .input-reason {
            padding: 6px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 12px;
            width: 140px;
            transition: border-color 0.2s;
            background: #f8fafc;
        }
        
        .input-reason:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .input-reason::placeholder {
            color: #94a3b8;
            font-style: italic;
        }
        
        /* Action Cell */
        .action-cell {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            align-items: center;
        }
        
        /* No Data */
        .no-data {
            padding: 40px 20px;
            text-align: center;
            color: #94a3b8;
            font-size: 15px;
            background: #fafcff;
        }
        
        .no-data::before {
            content: "📭 ";
        }
        
        .btn-logout {
            background-color: #64748b;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .btn-logout:hover {
            background-color: #475569;
        }
        
        /* Grouped Reports UI Styles */
        .count-badge-group {
            background: #ef4444;
            color: white;
            padding: 4px 10px;
            border-radius: 9999px;
            font-size: 12px;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .reason-pill {
            background: #fee2e2;
            color: #991b1b;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            margin-right: 4px;
            margin-bottom: 4px;
            display: inline-block;
        }
        
        .btn-toggle-details {
            background: #f1f5f9;
            color: #0284c7;
            border: 1px solid #cbd5e1;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            cursor: pointer;
            margin-top: 8px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s;
        }
        
        .btn-toggle-details:hover {
            background: #e2e8f0;
            color: #0369a1;
        }
        
        .details-row {
            display: none;
            background: #f8fafc;
        }
        
        .details-container {
            padding: 16px 20px;
            border-top: 1px dashed #cbd5e1;
        }
        
        .details-table {
            width: 100%;
            margin-top: 8px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            overflow: hidden;
            background: white;
            border-collapse: collapse;
        }
        
        .details-table th {
            background: #f1f5f9;
            font-size: 12px;
            padding: 10px;
            border-bottom: 1px solid #e2e8f0;
            text-transform: uppercase;
            color: #475569;
        }
        
        .details-table td {
            padding: 10px;
            font-size: 12px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .report-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .report-stats {
                grid-template-columns: 1fr;
            }
            
            .data-table {
                min-width: 700px;
            }
            
            .welcome-card {
                padding: 20px;
            }
            
            .welcome-card h2 {
                font-size: 20px;
            }
            
            .action-cell {
                flex-direction: column;
                align-items: stretch;
            }
            
            .input-reason {
                width: 100%;
            }
            
            .action-btn {
                width: 100%;
                text-align: center;
                justify-content: center;
            }
            
            .section-header {
                flex-direction: column;
                gap: 8px;
                text-align: center;
            }
        }
    </style>
    <script>
        function toggleDetails(id) {
            var el = document.getElementById(id);
            if (el) {
                if (el.style.display === 'table-row') {
                    el.style.display = 'none';
                } else {
                    el.style.display = 'table-row';
                }
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
    
    int totalPostReports = postReports != null ? postReports.size() : 0;
    int totalCommentReports = commentReports != null ? commentReports.size() : 0;
    int totalReports = totalPostReports + totalCommentReports;
%>

    <!-- Sidebar -->
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
                <a href="${pageContext.request.contextPath}/admin/comments" class="sidebar-link">
                    <span>💬 Comment Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <span>👥 User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link active">
                    <span>🚨 Report Logs</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Workspace -->
    <div class="main-workspace">
        
        <!-- Top Navbar -->
        <header class="top-navbar">
            <div class="nav-title"><%= isPostType ? "📄 Post Report Logs" : "💬 Comment Report Logs" %></div>
            <div class="user-profile-badge">
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <!-- Content Area -->
        <main class="content-area">
            
            <!-- Welcome Card -->
            <div class="welcome-card">
                <h2>🚨 Report Logs</h2>
                <p>Review and manage all reported content. Dismiss false reports or resolve legitimate ones.</p>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success">✅ ${successMessage}</div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">❌ ${errorMessage}</div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="report-stats">
                <div class="report-stat-card">
                    <span class="report-stat-icon">🚨</span>
                    <div class="report-stat-number"><%= totalReports %></div>
                    <div class="report-stat-label">Total Reports</div>
                </div>
                <div class="report-stat-card blue">
                    <span class="report-stat-icon">📄</span>
                    <div class="report-stat-number"><%= totalPostReports %></div>
                    <div class="report-stat-label">Post Reports</div>
                </div>
                <div class="report-stat-card orange">
                    <span class="report-stat-icon">💬</span>
                    <div class="report-stat-number"><%= totalCommentReports %></div>
                    <div class="report-stat-label">Comment Reports</div>
                </div>
                <div class="report-stat-card green">
                    <span class="report-stat-icon">✅</span>
                    <div class="report-stat-number">0</div>
                    <div class="report-stat-label">Resolved Today</div>
                </div>
            </div>

            <!-- Type Tabs -->
            <div class="type-tabs">
                <a href="<%= ctx %>/admin/reports?type=posts&view=<%= reportView %>"
                   class="type-tab <%= isPostType ? "active" : "" %>">📄 Post Reports</a>
                <a href="<%= ctx %>/admin/reports?type=comments&view=<%= reportView %>"
                   class="type-tab <%= !isPostType ? "active" : "" %>">💬 Comment Reports</a>
            </div>

            <!-- View Tabs -->
            <div class="view-tabs">
                <a href="<%= ctx %>/admin/reports?type=<%= reportType %>&view=queue"
                   class="view-tab <%= !isHistoryView ? "active" : "" %>">📥 Pending Queue</a>
                <a href="<%= ctx %>/admin/reports?type=<%= reportType %>&view=history"
                   class="view-tab <%= isHistoryView ? "active" : "" %>">📜 History</a>
            </div>
            
            <!-- POST REPORTS -->
            <% if (isPostType) { %>
            <div class="section-card">
                <div class="section-header">
                    <span><%= isHistoryView ? "📜 Post Report History" : "📥 Pending Grouped Post Reports" %></span>
                    <span class="count-badge">
                        <%= isHistoryView ? (postReports != null ? postReports.size() : 0) : (groupedPostReports != null ? groupedPostReports.size() : 0) %> 
                        <%= isHistoryView ? "records" : "reported posts" %>
                    </span>
                </div>
                <div class="section-body">
                    <% if (isHistoryView) { %>
                        <% if (postReports == null || postReports.isEmpty()) { %>
                            <div class="no-data">No post report history found.</div>
                        <% } else { %>
                            <div class="table-wrap">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Report Details</th>
                                            <th>Post Info</th>
                                            <th>Parties Involved</th>
                                            <th>Outcome</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (PostReport r : postReports) {
                                            ReportStatus status = r.getStatus();
                                            String statusClass = "status-other";
                                            if (ReportStatus.RESOLVED.equals(status)) statusClass = "status-resolved";
                                            else if (ReportStatus.DISMISSED.equals(status)) statusClass = "status-dismissed";
                                        %>
                                            <tr>
                                                <td>
                                                    <span class="reason-badge"><%= r.getReason() %></span><br/>
                                                    <p style="margin-top:8px; font-size:13px; color:#475569;"><%= r.getDescription() %></p>
                                                    <div class="date-meta">Reported: <%= r.getCreatedAt() %></div>
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
                                                    <span class="status-badge <%= statusClass %>"><%= status %></span>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    <% } else { %>
                        <!-- PENDING QUEUE (GROUPED BY POST) -->
                        <% if (groupedPostReports == null || groupedPostReports.isEmpty()) { %>
                            <div class="no-data">No pending post reports found.</div>
                        <% } else { %>
                            <div class="table-wrap">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Post Details & Author</th>
                                            <th>Report Summary</th>
                                            <th style="width: 340px;">Group Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (GroupedPostReportDto g : groupedPostReports) {
                                            String detailsId = "post-details-" + g.getPost().getId();
                                        %>
                                            <tr>
                                                <td>
                                                    <strong style="font-size: 15px; color: #0f172a;"><%= g.getPost().getTitle() %></strong><br/>
                                                    <span style="font-size: 12px; color: #64748b;">Slug: <%= g.getPost().getSlug() %></span><br/>
                                                    <span style="font-size: 12px; color: #475569;">Author: <strong>@<%= g.getPost().getAuthor().getUsername() %></strong></span>
                                                    <br/>
                                                    <button type="button" class="btn-toggle-details" onclick="toggleDetails('<%= detailsId %>')">
                                                        👁️ View Reporter Details (<%= g.getReportCount() %>)
                                                    </button>
                                                </td>
                                                <td>
                                                    <span class="count-badge-group">🔥 <%= g.getReportCount() %> <%= g.getReportCount() > 1 ? "Reports" : "Report" %></span>
                                                    <div style="margin-top: 8px;">
                                                        <% for (Map.Entry<ReportReason, Integer> entry : g.getReasonCounts().entrySet()) { %>
                                                            <span class="reason-pill"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                                                        <% } %>
                                                    </div>
                                                    <div class="date-meta">Latest: <%= g.getLatestReportedAt() %></div>
                                                </td>
                                                <td>
                                                    <div class="action-cell">
                                                        <form action="${pageContext.request.contextPath}/admin/reports/posts/group/<%= g.getPost().getId() %>/dismiss" method="POST" style="display:inline;">
                                                            <button type="submit" class="action-btn dismiss" onclick="return confirm('Dismiss ALL <%= g.getReportCount() %> reports for this post as false alarm?')">Dismiss Group</button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/admin/reports/posts/group/<%= g.getPost().getId() %>/resolve" method="POST" style="display:inline; margin-top:4px;">
                                                            <input type="text" name="reason" class="input-reason" placeholder="Resolution reason..." required />
                                                            <button type="submit" class="action-btn resolve" onclick="return confirm('Resolve group: remove post and clear all <%= g.getReportCount() %> pending reports?')">Resolve & Remove</button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr id="<%= detailsId %>" class="details-row">
                                                <td colspan="3">
                                                    <div class="details-container">
                                                        <strong style="font-size: 13px; color: #0284c7;">📄 Individual Reports (<%= g.getReportCount() %>):</strong>
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
                                                                                <button type="submit" class="action-btn dismiss" style="padding: 4px 8px; font-size:11px;" onclick="return confirm('Dismiss only this single report?')">Dismiss</button>
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
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>

            <!-- COMMENT REPORTS -->
            <% if (!isPostType) { %>
            <div class="section-card">
                <div class="section-header">
                    <span><%= isHistoryView ? "📜 Comment Report History" : "📥 Pending Grouped Comment Reports" %></span>
                    <span class="count-badge">
                        <%= isHistoryView ? (commentReports != null ? commentReports.size() : 0) : (groupedCommentReports != null ? groupedCommentReports.size() : 0) %> 
                        <%= isHistoryView ? "records" : "reported comments" %>
                    </span>
                </div>
                <div class="section-body">
                    <% if (isHistoryView) { %>
                        <% if (commentReports == null || commentReports.isEmpty()) { %>
                            <div class="no-data">No comment report history found.</div>
                        <% } else { %>
                            <div class="table-wrap">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Report Details</th>
                                            <th>Comment Info</th>
                                            <th>Parties Involved</th>
                                            <th>Outcome</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (CommentReport r : commentReports) {
                                            ReportStatus status = r.getStatus();
                                            String statusClass = "status-other";
                                            if (ReportStatus.RESOLVED.equals(status)) statusClass = "status-resolved";
                                            else if (ReportStatus.DISMISSED.equals(status)) statusClass = "status-dismissed";
                                        %>
                                            <tr>
                                                <td>
                                                    <span class="reason-badge"><%= r.getReason() %></span><br/>
                                                    <p style="margin-top:8px; font-size:13px; color:#475569;"><%= r.getDescription() %></p>
                                                    <div class="date-meta">Reported: <%= r.getCreatedAt() %></div>
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
                                                    <span class="status-badge <%= statusClass %>"><%= status %></span>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    <% } else { %>
                        <!-- PENDING QUEUE (GROUPED BY COMMENT) -->
                        <% if (groupedCommentReports == null || groupedCommentReports.isEmpty()) { %>
                            <div class="no-data">No pending comment reports found.</div>
                        <% } else { %>
                            <div class="table-wrap">
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Comment Content & Author</th>
                                            <th>Report Summary</th>
                                            <th style="width: 340px;">Group Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% for (GroupedCommentReportDto g : groupedCommentReports) {
                                            String detailsId = "comment-details-" + g.getComment().getId();
                                        %>
                                            <tr>
                                                <td>
                                                    <p style="background: #f8fafc; padding: 10px; border-radius: 6px; font-size:13px; border-left:3px solid #0284c7; color: #1e293b;">
                                                        "<%= g.getComment().getContent() %>"
                                                    </p>
                                                    <span style="font-size:12px; color:#64748b; margin-top:4px; display:block;">On Post: <strong><%= g.getComment().getPost().getTitle() %></strong></span>
                                                    <span style="font-size:12px; color:#475569;">Commenter: <strong>@<%= g.getComment().getUser().getUsername() %></strong></span>
                                                    <br/>
                                                    <button type="button" class="btn-toggle-details" onclick="toggleDetails('<%= detailsId %>')">
                                                        👁️ View Reporter Details (<%= g.getReportCount() %>)
                                                    </button>
                                                </td>
                                                <td>
                                                    <span class="count-badge-group">🔥 <%= g.getReportCount() %> <%= g.getReportCount() > 1 ? "Reports" : "Report" %></span>
                                                    <div style="margin-top: 8px;">
                                                        <% for (Map.Entry<ReportReason, Integer> entry : g.getReasonCounts().entrySet()) { %>
                                                            <span class="reason-pill"><%= entry.getKey() %> (<%= entry.getValue() %>)</span>
                                                        <% } %>
                                                    </div>
                                                    <div class="date-meta">Latest: <%= g.getLatestReportedAt() %></div>
                                                </td>
                                                <td>
                                                    <div class="action-cell">
                                                        <form action="${pageContext.request.contextPath}/admin/reports/comments/group/<%= g.getComment().getId() %>/dismiss" method="POST" style="display:inline;">
                                                            <button type="submit" class="action-btn dismiss" onclick="return confirm('Dismiss ALL <%= g.getReportCount() %> reports for this comment as false alarm?')">Dismiss Group</button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/admin/reports/comments/group/<%= g.getComment().getId() %>/resolve" method="POST" style="display:inline; margin-top:4px;">
                                                            <input type="text" name="reason" class="input-reason" placeholder="Resolution reason..." required />
                                                            <button type="submit" class="action-btn resolve" onclick="return confirm('Resolve group: delete comment, ban commenter, and clear all <%= g.getReportCount() %> pending reports?')">Resolve & Ban</button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr id="<%= detailsId %>" class="details-row">
                                                <td colspan="3">
                                                    <div class="details-container">
                                                        <strong style="font-size: 13px; color: #0284c7;">📄 Individual Reports (<%= g.getReportCount() %>):</strong>
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
                                                                                <button type="submit" class="action-btn dismiss" style="padding: 4px 8px; font-size:11px;" onclick="return confirm('Dismiss only this single report?')">Dismiss</button>
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
                            </div>
                        <% } %>
                    <% } %>
                </div>
            </div>
            <% } %>

        </main>
    </div>

</body>
</html>