<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Category Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
    <style>
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
        
        .action-btn.toggle-active {
            background: #dcfce7;
            color: #16a34a;
        }
        
        .action-btn.toggle-active:hover {
            background: #bbf7d0;
        }
        
        .action-btn.toggle-inactive {
            background: #fef3c7;
            color: #d97706;
        }
        
        .action-btn.toggle-inactive:hover {
            background: #fde68a;
        }
        
        .action-btn.toggle {
            background: #fef3c7;
            color: #d97706;
        }
        
        .action-btn.toggle:hover {
            background: #fde68a;
        }
        
        /* Badges */
        .badge-active {
            background: #dcfce7;
            color: #16a34a;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .badge-inactive {
            background: #fee2e2;
            color: #dc2626;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        /* Stats Cards */
        .category-stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .category-stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 6px solid #3b82f6;
            transition: all 0.3s ease;
        }
        
        .category-stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .category-stat-card.green { border-left-color: #10b981; }
        .category-stat-card.orange { border-left-color: #f59e0b; }
        .category-stat-card.purple { border-left-color: #8b5cf6; }
        
        .category-stat-number {
            font-size: 30px;
            font-weight: 800;
            color: #1e293b;
        }
        
        .category-stat-label {
            font-size: 14px;
            color: #64748b;
            margin-top: 4px;
        }
        
        .category-stat-icon {
            float: right;
            font-size: 26px;
            opacity: 0.25;
        }
        
        .create-category-btn {
            display: inline-block;
            padding: 12px 28px;
            background: #3b82f6;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-bottom: 25px;
            border: none;
            cursor: pointer;
        }
        
        .create-category-btn:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(59, 130, 246, 0.35);
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
        }
        
        .data-table tbody tr:hover {
            background: #f8fafc;
        }
        
        .data-table tbody tr:last-child td {
            border-bottom: none;
        }
        
        .welcome-card {
            background: #ffffff;
            padding: 30px 35px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 8px solid #0284c7;
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
        
        .btn-logout {
            background: #64748b;
            color: white;
            padding: 8px 18px;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            transition: background 0.2s;
        }
        
        .btn-logout:hover {
            background: #475569;
        }
        
        .badge {
            background: #ef4444;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
        }
        
        @media (max-width: 768px) {
            .category-stats {
                grid-template-columns: 1fr 1fr;
            }
            
            .data-table {
                min-width: 600px;
            }
        }
        
        @media (max-width: 480px) {
            .category-stats {
                grid-template-columns: 1fr;
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
            <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link active">
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
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/chat" class="sidebar-link">
                    <span>💬 Chat / Messages</span>
                </a>
            </li>
    </ul>
</aside>

    <!-- Main Workspace -->
    <div class="main-workspace">
        
        <header class="top-navbar">
            <div class="nav-title">📁 Category Management</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong>Admin</strong></span>
                <span class="badge">ADMIN</span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">
            
            <div class="welcome-card">
                <h2>Category Management</h2>
                <p>Manage your cheat sheet categories. Create, edit, or delete categories to organize content effectively.</p>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success">✅ ${successMessage}</div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">❌ ${errorMessage}</div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="category-stats">
                <div class="category-stat-card">
                    <span class="category-stat-icon">📊</span>
                    <div class="category-stat-number">${totalCategories}</div>
                    <div class="category-stat-label">Total Categories</div>
                </div>
               
                <%-- <div class="category-stat-card purple">
                    <span class="category-stat-icon">📚</span>
                    <div class="category-stat-number">${totalPosts}</div>
                    <div class="category-stat-label">Posts in Categories</div>
                </div> --%>
            </div>

            <!-- Create Button -->
            <a href="${pageContext.request.contextPath}/admin/categories/new" class="create-category-btn">
                + Create New Category
            </a>

            <!-- Categories Table -->
            <c:if test="${empty categories}">
                <div class="empty-state">
                    <div class="icon">📁</div>
                    <h3>No Categories Found</h3>
                    <p>Get started by creating your first category.</p>
                    <br>
                    <a href="${pageContext.request.contextPath}/admin/categories/new" class="create-category-btn">
                        + Create Category
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty categories}">
                <div class="table-wrap">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Category Name</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th style="text-align: center;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="category" items="${categories}">
                                <tr>
                                    <td><strong>#${category.id}</strong></td>
                                    <td><strong><c:out value="${category.name}" /></strong></td>
                                    <td><c:out value="${category.description}" /></td>
                                  
                                    <td style="text-align: center; white-space: nowrap;">
                                        <!-- Edit Button -->
                                        <a href="${pageContext.request.contextPath}/admin/categories/edit/${category.id}" 
                                           class="action-btn edit">
                                            ✏️ Edit
                                        </a>
                                        
                                        <!-- Toggle Status Button (NEW) -->
                                        
                                        
                                        <!-- Delete Button -->
                                        <a href="${pageContext.request.contextPath}/admin/categories/delete/${category.id}" 
                                           class="action-btn delete"
                                           onclick="return confirm('Are you sure you want to delete this category?')">
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