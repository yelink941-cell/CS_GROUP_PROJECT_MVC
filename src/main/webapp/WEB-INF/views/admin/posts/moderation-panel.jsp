<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comment Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
    <style>
        /* ============================================
           COMMENT MANAGEMENT - ADDITIONAL STYLES
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
            border-left: 8px solid #ec4899;
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
        .comment-stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .comment-stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 6px solid #ec4899;
            transition: all 0.3s ease;
        }
        
        .comment-stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .comment-stat-card.blue { border-left-color: #3b82f6; }
        .comment-stat-card.green { border-left-color: #10b981; }
        .comment-stat-card.orange { border-left-color: #f59e0b; }
        .comment-stat-card.purple { border-left-color: #8b5cf6; }
        
        .comment-stat-number {
            font-size: 30px;
            font-weight: 800;
            color: #1e293b;
        }
        
        .comment-stat-label {
            font-size: 14px;
            color: #64748b;
            margin-top: 4px;
        }
        
        .comment-stat-icon {
            float: right;
            font-size: 26px;
            opacity: 0.25;
        }
        
        /* Table */
        .table-wrap {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
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
        
        /* Comment Content */
        .comment-content {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        /* User Badge */
        .user-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #e2e8f0;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
        }
        
        .user-badge .avatar {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #3b82f6;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 700;
        }
        
        /* Post Badge */
        .post-badge {
            display: inline-block;
            background: #dbeafe;
            color: #1d4ed8;
            padding: 2px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        /* Action Buttons */
        .action-btn {
            padding: 5px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
        }
        
        .action-btn.delete {
            background: #fee2e2;
            color: #dc2626;
        }
        
        .action-btn.delete:hover {
            background: #fecaca;
        }
        
        .action-btn.view {
            background: #dbeafe;
            color: #1d4ed8;
        }
        
        .action-btn.view:hover {
            background: #bfdbfe;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        }
        
        .empty-state .icon {
            font-size: 60px;
            margin-bottom: 16px;
        }
        
        .empty-state h3 {
            color: #1e293b;
            font-size: 20px;
            margin-bottom: 8px;
        }
        
        .empty-state p {
            color: #64748b;
            margin-bottom: 20px;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .comment-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .comment-stats {
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
            
            .comment-content {
                max-width: 150px;
            }
        }
        
        @media (max-width: 480px) {
            .data-table th,
            .data-table td {
                padding: 10px 12px;
                font-size: 12px;
            }
            
            .action-btn {
                padding: 4px 10px;
                font-size: 11px;
            }
        }
    </style>
</head>
<body>

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
                <a href="${pageContext.request.contextPath}/admin/comments" class="sidebar-link active">
                    <span>💬 Comment Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <span>👥 User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link">
                    <span>📊 Report Logs</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Workspace -->
    <div class="main-workspace">
        
        <!-- Top Navbar -->
        <header class="top-navbar">
            <div class="nav-title">💬 Comment Management</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong>Admin</strong></span>
                <span class="badge">ADMIN</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <!-- Content Area -->
        <main class="content-area">
            
            <!-- Welcome Card -->
            <div class="welcome-card">
                <h2>💬 Comment Management</h2>
                <p>Manage all comments across the platform. Review, moderate, and delete inappropriate comments.</p>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success">✅ ${successMessage}</div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">❌ ${errorMessage}</div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="comment-stats">
                <div class="comment-stat-card">
                    <span class="comment-stat-icon">💬</span>
                    <div class="comment-stat-number">${totalComments}</div>
                    <div class="comment-stat-label">Total Comments</div>
                </div>
                <div class="comment-stat-card blue">
                    <span class="comment-stat-icon">📝</span>
                    <div class="comment-stat-number">${totalPosts}</div>
                    <div class="comment-stat-label">Total Posts</div>
                </div>
                <div class="comment-stat-card green">
                    <span class="comment-stat-icon">👥</span>
                    <div class="comment-stat-number">${totalUsers}</div>
                    <div class="comment-stat-label">Total Users</div>
                </div>
                <div class="comment-stat-card orange">
                    <span class="comment-stat-icon">📊</span>
                    <div class="comment-stat-number">${avgCommentsPerPost}</div>
                    <div class="comment-stat-label">Avg Comments per Post</div>
                </div>
            </div>

            <!-- Comments Table -->
            <c:if test="${empty comments}">
                <div class="empty-state">
                    <div class="icon">💬</div>
                    <h3>No Comments Found</h3>
                    <p>There are no comments to manage at the moment.</p>
                </div>
            </c:if>

            <c:if test="${not empty comments}">
                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Post</th>
                                <th>Comment</th>
                                <th>Date</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="comment" items="${comments}">
                                <tr>
                                    <td><strong>#${comment.id}</strong></td>
                                    <td>
                                        <span class="user-badge">
                                            <span class="avatar">
                                                <c:out value="${comment.user.username.charAt(0)}" />
                                            </span>
                                            <c:out value="${comment.user.username}" />
                                        </span>
                                    </td>
                                    <td>
                                        <span class="post-badge">
                                            <c:out value="${comment.post.title}" />
                                        </span>
                                    </td>
                                    <td>
                                        <div class="comment-content" title="<c:out value="${comment.content}" />">
                                            <c:out value="${comment.content}" />
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </td>
                                    <td style="text-align: center; white-space: nowrap;">
                                        <a href="${pageContext.request.contextPath}/admin/posts/${comment.post.slug}" 
                                           class="action-btn view"
                                           target="_blank">
                                            👁️ View Post
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/comments/delete/${comment.id}" 
                                           class="action-btn delete"
                                           onclick="return confirm('Are you sure you want to delete this comment?')">
                                            🗑️ Delete
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>

        </main>
    </div>

</body>
</html>