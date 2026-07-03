<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Posts</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
    <style>
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
        
        .welcome-card {
            background: #ffffff;
            padding: 30px 35px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 8px solid #f59e0b;
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
            min-width: 900px;
        }
        
        .data-table thead {
            background: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .data-table th {
            padding: 14px 16px;
            text-align: left;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #475569;
            white-space: nowrap;
        }
        
        .data-table td {
            padding: 14px 16px;
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
        
        .badge-pending {
            background: #fef3c7;
            color: #d97706;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
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
        
        .action-btn.approve {
            background: #dcfce7;
            color: #16a34a;
        }
        
        .action-btn.approve:hover {
            background: #bbf7d0;
        }
        
        .action-btn.reject {
            background: #fee2e2;
            color: #dc2626;
        }
        
        .action-btn.reject:hover {
            background: #fecaca;
        }
        
        .reject-textarea {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 13px;
            font-family: inherit;
            resize: vertical;
            min-height: 50px;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        
        .reject-textarea:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
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
        
        .back-btn {
            display: inline-block;
            padding: 10px 24px;
            background: #64748b;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-bottom: 25px;
        }
        
        .back-btn:hover {
            background: #475569;
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .data-table {
                min-width: 700px;
            }
            
            .welcome-card {
                padding: 20px;
            }
            
            .welcome-card h2 {
                font-size: 20px;
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
            <!-- ✅ Tags Management ထည့်ပြီး -->
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
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="sidebar-link active">
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
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link">
                    <span>📊 Report Logs</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Workspace -->
    <div class="main-workspace">
        
        <header class="top-navbar">
            <div class="nav-title">⏳ Pending Posts</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong>Admin</strong></span>
                <span class="badge">ADMIN</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">
            
            <!-- Welcome Card -->
            <div class="welcome-card">
                <h2>⏳ Pending Posts</h2>
                <p>Review and moderate posts that are waiting for approval.</p>
            </div>

            <!-- Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success">✅ ${successMessage}</div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">❌ ${errorMessage}</div>
            </c:if>

            <!-- Table -->
            <c:if test="${empty posts}">
                <div class="empty-state">
                    <div class="icon">🎉</div>
                    <h3>No Pending Posts</h3>
                    <p>All posts have been reviewed. Great job!</p>
                </div>
            </c:if>

            <c:if test="${not empty posts}">
                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Author</th>
                                <th>Created</th>
                                <th>Status</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="post" items="${posts}">
                                <tr>
                                    <td><strong>#${post.id}</strong></td>
                                    <td>
                                        <strong><c:out value="${post.title}" /></strong>
                                        <br>
                                        <small style="color: #94a3b8; font-size: 11px;">
                                            Slug: <c:out value="${post.slug}" />
                                        </small>
                                    </td>
                                    <td>
                                        <span style="background: #e2e8f0; padding: 2px 10px; border-radius: 12px; font-size: 12px;">
                                            <c:out value="${post.category.name}" />
                                        </span>
                                    </td>
                                    <td><c:out value="${post.author.username}" /></td>
                                    <td><c:out value="${post.createdAt}" /></td>
                                    <td>
                                        <span class="badge-pending">⏳ Pending</span>
                                    </td>
                                    <td style="text-align: center; white-space: nowrap;">
                                        <!-- Approve -->
                                        <form action="${pageContext.request.contextPath}/admin/posts/approve/${post.id}" 
                                              method="post" style="display: inline-block;">
                                            <button type="submit" class="action-btn approve" 
                                                    onclick="return confirm('Approve this post?')">
                                                ✅ Approve
                                            </button>
                                        </form>
                                        
                                        <!-- Reject Reason -->
                                        <form id="rejectForm${post.id}" 
                                              action="${pageContext.request.contextPath}/admin/posts/reject/${post.id}" 
                                              method="post" style="display: inline-block;">
                                            <textarea name="rejectionReason" class="reject-textarea" 
                                                      placeholder="Enter reason..." required></textarea>
                                        </form>
                                        
                                        <!-- Reject -->
                                        <button type="submit" form="rejectForm${post.id}" 
                                                class="action-btn reject"
                                                onclick="return confirm('Reject this post?')">
                                            ❌ Reject
                                        </button>
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