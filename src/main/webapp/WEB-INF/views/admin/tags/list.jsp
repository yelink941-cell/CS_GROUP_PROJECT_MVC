<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tag Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
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
                <a href="${pageContext.request.contextPath}/admin/tags" class="sidebar-link active">
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
                    <span>&#128364; Event Announcements</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link">
                    <span>&#128196; CheatSheet Report</span>
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
            <div class="nav-title">🏷️ Tag Management</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong>Admin</strong></span>
                <span class="badge">ADMIN</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">
            
            <div class="welcome-card">
                <h2>🏷️ Tag Management</h2>
                <p>Manage your cheat sheet tags. Create, edit, or delete tags to categorize content effectively.</p>
            </div>

            <c:if test="${not empty successMessage}">
                <div class="alert-success">✅ ${successMessage}</div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">❌ ${errorMessage}</div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="tag-stats">
                <div class="tag-stat-card">
                    <span class="tag-stat-icon">🏷️</span>
                    <div class="tag-stat-number">${totalTags}</div>
                    <div class="tag-stat-label">Total Tags</div>
                </div>
                <div class="tag-stat-card blue">
                    <span class="tag-stat-icon">📝</span>
                    <div class="tag-stat-number">${totalPosts}</div>
                    <div class="tag-stat-label">Total Posts</div>
                </div>
                <div class="tag-stat-card green">
                    <span class="tag-stat-icon">📊</span>
                    <div class="tag-stat-number">${avgTagsPerPost}</div>
                    <div class="tag-stat-label">Avg Tags per Post</div>
                </div>
                <div class="tag-stat-card orange">
                    <span class="tag-stat-icon">🔥</span>
                    <div class="tag-stat-number">${mostUsedTag}</div>
                    <div class="tag-stat-label">Most Used Tag</div>
                </div>
            </div>

            <a href="${pageContext.request.contextPath}/admin/tags/new" class="create-tag-btn">
                + Create New Tag
            </a>

            <c:if test="${empty tags}">
                <div class="empty-state">
                    <div class="icon">🏷️</div>
                    <h3>No Tags Found</h3>
                    <p>Get started by creating your first tag.</p>
                    <br>
                    <a href="${pageContext.request.contextPath}/admin/tags/new" class="create-tag-btn">
                        + Create Tag
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty tags}">
                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Tag Name</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="tag" items="${tags}">
                                <tr>
                                    <td><strong>#${tag.id}</strong></td>
                                    <td>
                                        <span class="tag-badge"><c:out value="${tag.name}" /></span>
                                    </td>
                                    <td style="text-align: center; white-space: nowrap;">
                                        <a href="${pageContext.request.contextPath}/admin/tags/edit/${tag.id}" 
                                           class="action-btn edit">
                                            ✏️ Edit
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin/tags/delete/${tag.id}" 
                                           class="action-btn delete"
                                           onclick="return confirm('Are you sure you want to delete this tag?')">
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
            border-left: 8px solid #8b5cf6;
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
        
        .tag-stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .tag-stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 6px solid #8b5cf6;
            transition: all 0.3s ease;
        }
        
        .tag-stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .tag-stat-card.blue { border-left-color: #3b82f6; }
        .tag-stat-card.green { border-left-color: #10b981; }
        .tag-stat-card.orange { border-left-color: #f59e0b; }
        .tag-stat-card.purple { border-left-color: #8b5cf6; }
        
        .tag-stat-number {
            font-size: 30px;
            font-weight: 800;
            color: #1e293b;
        }
        
        .tag-stat-label {
            font-size: 14px;
            color: #64748b;
            margin-top: 4px;
        }
        
        .tag-stat-icon {
            float: right;
            font-size: 26px;
            opacity: 0.25;
        }
        
        .create-tag-btn {
            display: inline-block;
            padding: 12px 28px;
            background: #8b5cf6;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-bottom: 25px;
            border: none;
            cursor: pointer;
        }
        
        .create-tag-btn:hover {
            background: #7c3aed;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(139, 92, 246, 0.35);
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
        }
        
        .data-table thead {
            background: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .data-table th {
            padding: 16px 20px;
            text-align: left;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #475569;
        }
        
        .data-table td {
            padding: 16px 20px;
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
        
        .tag-badge {
            display: inline-block;
            background: #ede9fe;
            color: #7c3aed;
            padding: 4px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }
        
        .tag-badge::before {
            content: "#";
        }
        
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
        
        .action-btn.edit {
            background: #dbeafe;
            color: #1d4ed8;
        }
        
        .action-btn.edit:hover {
            background: #bfdbfe;
        }
        
        .action-btn.delete {
            background: #fee2e2;
            color: #dc2626;
        }
        
        .action-btn.delete:hover {
            background: #fecaca;
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
        
        @media (max-width: 1024px) {
            .tag-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .tag-stats {
                grid-template-columns: 1fr;
            }
            
            .data-table {
                min-width: 500px;
            }
            
            .welcome-card {
                padding: 20px;
            }
            
            .welcome-card h2 {
                font-size: 20px;
            }
        }
        
        @media (max-width: 480px) {
            .data-table th,
            .data-table td {
                padding: 10px 12px;
                font-size: 13px;
            }
            
            .action-btn {
                padding: 4px 10px;
                font-size: 12px;
            }
        }
    </style>

</body>
</html>