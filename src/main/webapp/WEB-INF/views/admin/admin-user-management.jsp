<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="com.hibernate.entity.UserProfile" %>
<%@ page import="com.hibernate.entity.UserPreference" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
    <style>
        /* ============================================
           USER MANAGEMENT - ADDITIONAL STYLES
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
            border-left: 8px solid #10b981;
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
        .user-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .user-stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 6px solid #10b981;
            transition: all 0.3s ease;
        }
        
        .user-stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }
        
        .user-stat-card.blue { border-left-color: #3b82f6; }
        .user-stat-card.green { border-left-color: #10b981; }
        .user-stat-card.red { border-left-color: #ef4444; }
        
        .user-stat-number {
            font-size: 30px;
            font-weight: 800;
            color: #1e293b;
        }
        
        .user-stat-label {
            font-size: 14px;
            color: #64748b;
            margin-top: 4px;
        }
        
        .user-stat-icon {
            float: right;
            font-size: 26px;
            opacity: 0.25;
        }
        
        /* Search Bar */
        .search-bar {
            display: flex;
            gap: 10px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
        
        .search-bar input[type="text"] {
            flex: 1;
            min-width: 200px;
            padding: 10px 16px;
            border: 1px solid #d1d9e6;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            transition: border-color 0.2s;
        }
        
        .search-bar input[type="text"]:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .search-bar .btn-search {
            padding: 10px 24px;
            background: #3b82f6;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .search-bar .btn-search:hover {
            background: #2563eb;
        }
        
        .search-bar .btn-clear {
            padding: 10px 20px;
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .search-bar .btn-clear:hover {
            background: #e2e8f0;
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
        
        /* Mini Avatar */
        .mini-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e2e8f0;
        }
        
        .avatar-letter {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e2e8f0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #475569;
            border: 2px solid #e2e8f0;
            font-size: 16px;
        }
        
        /* Status Badges */
        .badge-status {
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .badge-status.active { background: #dcfce7; color: #16a34a; }
        .badge-status.inactive { background: #fee2e2; color: #dc2626; }
        
        .badge-role {
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .badge-role.admin { background: #dbeafe; color: #1d4ed8; }
        .badge-role.user { background: #e2e8f0; color: #475569; }
        
        /* Select Dropdowns */
        .form-select {
            padding: 6px 10px;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 13px;
            color: #334155;
            background-color: #fff;
            outline: none;
            cursor: pointer;
            transition: border-color 0.2s;
        }
        
        .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        /* Action Buttons */
        .action-btn {
            padding: 5px 12px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
        }
        
        .action-btn.update {
            background: #10b981;
            color: white;
        }
        
        .action-btn.update:hover {
            background: #059669;
        }
        
        .action-btn.view {
            background: #3b82f6;
            color: white;
        }
        
        .action-btn.view:hover {
            background: #2563eb;
        }
        
        .action-btn.delete {
            background: #fee2e2;
            color: #dc2626;
        }
        
        .action-btn.delete:hover {
            background: #fecaca;
        }
        
        /* Pagination */
        .pagination-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }
        
        .pagination-bar .page-info {
            font-size: 14px;
            color: #64748b;
        }
        
        .pagination-bar .page-info strong {
            color: #0f1724;
        }
        
        .pagination-bar .pagination-links {
            display: flex;
            gap: 8px;
        }
        
        .pagination-bar .btn-page {
            padding: 8px 16px;
            border: 1px solid #d1d9e6;
            border-radius: 8px;
            background: white;
            color: #475569;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.2s;
        }
        
        .pagination-bar .btn-page:hover {
            background: #f8fafc;
            border-color: #94a3b8;
        }
        
        .pagination-bar .btn-page.active {
            background: #3b82f6;
            color: white;
            border-color: #3b82f6;
        }
        
        .pagination-bar .btn-page.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        /* Modal */
        .modal-mask {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 23, 42, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s ease;
            z-index: 999;
        }
        
        .modal-mask.open {
            opacity: 1;
            pointer-events: auto;
        }
        
        .modal-body {
            background: white;
            width: 100%;
            max-width: 500px;
            padding: 32px;
            border-radius: 16px;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);
            transform: scale(0.9);
            transition: transform 0.3s ease;
            position: relative;
            max-height: 90vh;
            overflow-y: auto;
        }
        
        .modal-mask.open .modal-body {
            transform: scale(1);
        }
        
        .modal-close-x {
            position: absolute;
            top: 16px;
            right: 20px;
            background: none;
            border: none;
            font-size: 24px;
            color: #94a3b8;
            cursor: pointer;
            transition: color 0.2s;
        }
        
        .modal-close-x:hover {
            color: #1e293b;
        }
        
        .modal-header-profile {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 20px;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 16px;
        }
        
        .modal-avatar {
            width: 75px;
            height: 75px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #f1f5f9;
        }
        
        .modal-avatar-letter {
            width: 75px;
            height: 75px;
            border-radius: 50%;
            background: #e2e8f0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #475569;
            border: 3px solid #f1f5f9;
            font-size: 28px;
        }
        
        .modal-name {
            font-size: 20px;
            font-weight: 700;
            color: #0f172a;
        }
        
        .modal-username {
            color: #0284c7;
            font-weight: 600;
            font-size: 14px;
        }
        
        .modal-section-title {
            font-size: 12px;
            font-weight: 700;
            color: #64748b;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin: 16px 0 8px 0;
            display: block;
        }
        
        .modal-bio {
            font-size: 14px;
            color: #475569;
            font-style: italic;
            background: #f8fafc;
            padding: 12px;
            border-radius: 8px;
            line-height: 1.5;
            min-height: 42px;
        }
        
        .modal-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            font-size: 14px;
            background: #f8fafc;
            padding: 14px;
            border-radius: 8px;
        }
        
        .modal-info-row {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        
        .modal-label {
            color: #64748b;
            font-weight: 500;
            font-size: 12px;
        }
        
        .modal-val {
            color: #1e293b;
            font-weight: 600;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .user-stats {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        @media (max-width: 768px) {
            .user-stats {
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
            
            .search-bar {
                flex-direction: column;
            }
            
            .search-bar input[type="text"] {
                width: 100%;
            }
            
            .pagination-bar {
                flex-direction: column;
                align-items: center;
            }
        }
        
        @media (max-width: 480px) {
            .data-table th,
            .data-table td {
                padding: 10px 12px;
                font-size: 12px;
            }
            
            .action-btn {
                padding: 4px 8px;
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
                <a href="${pageContext.request.contextPath}/admin/comments" class="sidebar-link">
                    <span>💬 Comment Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link active">
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
            <div class="nav-title">👥 User Management</div>
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
                <h2>👥 User Management</h2>
                <p>Manage all registered users. View profiles, update roles and status, or delete users.</p>
            </div>

            <!-- Success/Error Messages -->
            <c:if test="${not empty successMessage}">
                <div class="alert-success">✅ ${successMessage}</div>
            </c:if>
            
            <c:if test="${not empty errorMessage}">
                <div class="alert-error">❌ ${errorMessage}</div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="user-stats">
                <div class="user-stat-card">
                    <span class="user-stat-icon">👥</span>
                    <div class="user-stat-number">${totalUsers}</div>
                    <div class="user-stat-label">Total Users</div>
                </div>
                <div class="user-stat-card blue">
                    <span class="user-stat-icon">✅</span>
                    <div class="user-stat-number">${activeUsers}</div>
                    <div class="user-stat-label">Active Users</div>
                </div>
                <div class="user-stat-card red">
                    <span class="user-stat-icon">🚫</span>
                    <div class="user-stat-number">${inactiveUsers}</div>
                    <div class="user-stat-label">Inactive Users</div>
                </div>
            </div>

            <!-- Search Bar -->
            <div class="search-bar">
                <form action="${pageContext.request.contextPath}/admin/users" method="GET" style="display: flex; gap: 10px; flex: 1; flex-wrap: wrap;">
                    <input type="text" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>" 
                           placeholder="Search by name, username, or email...">
                    <button type="submit" class="btn-search">🔍 Search</button>
                </form>
                <% if(request.getParameter("search") != null && !request.getParameter("search").trim().isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn-clear">✕ Clear</a>
                <% } %>
            </div>

            <!-- User Table -->
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Photo</th>
                            <th>Account Details</th>
                            <th>Full Name</th>
                            <th>Gender</th>
                            <th>Bio Snippet</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th style="text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            List<User> users = (List<User>) request.getAttribute("users");
                            if(users != null) {
                                for(User u : users) {
                                    UserProfile prof = u.getProfile(); 
                                    
                                    String fullName = (prof != null && prof.getFullName() != null) ? prof.getFullName() : "No Profile";
                                    String gender = (prof != null && prof.getGender() != null) ? prof.getGender() : "N/A";
                                    String bio = (prof != null && prof.getBio() != null) ? prof.getBio() : "No biography yet.";
                                    
                                    String initialLetter = "U";
                                    if (u.getUsername() != null && !u.getUsername().trim().isEmpty()) {
                                        initialLetter = u.getUsername().substring(0, 1).toUpperCase();
                                    }
                                    
                                    boolean hasRealAvatar = (prof != null && prof.getAvatar() != null && prof.getAvatar().length > 0);
                                    String imgHtml = "<div class='avatar-letter'>" + initialLetter + "</div>";
                                    
                                    if (hasRealAvatar) {
                                        String base64Img = Base64.getEncoder().encodeToString(prof.getAvatar());
                                        String rawAvatarSrc = "data:image/jpeg;base64," + base64Img.replaceAll("[\\r\\n\\s]+", "");
                                        imgHtml = "<img src='" + rawAvatarSrc + "' class='mini-avatar' alt='Avatar' />";
                                    }
                                    
                                    String roleClass = u.getRole().name().equals("ADMIN") ? "admin" : "user";
                                    String statusClass = u.getStatus().name().toLowerCase();
                        %>
                        <tr>
                            <td><%= imgHtml %></td>
                            <td>
                                <strong>@<%= u.getUsername() %></strong><br/>
                                <span style="font-size:12px; color:#64748b;"><%= u.getEmail() %></span>
                            </td>
                            <td><%= fullName %></td>
                            <td><span style="text-transform: capitalize;"><%= gender %></span></td>
                            <td>
                                <div style="max-width: 140px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-style: italic; font-size: 13px; color: #64748b;" 
                                     title="<%= bio %>">
                                    "<%= bio %>"
                                </div>
                            </td>
                            <td>
                                <span class="badge-role <%= roleClass %>"><%= u.getRole().name() %></span>
                            </td>
                            <td>
                                <span class="badge-status <%= statusClass %>"><%= u.getStatus().name() %></span>
                            </td>
                            <td style="text-align: center; white-space: nowrap;">
                                <form action="${pageContext.request.contextPath}/admin/users/update-status" method="POST" style="display: inline-block;">
                                    <input type="hidden" name="userId" value="<%= u.getId() %>" />
                                    <!-- ✅ Role Dropdown ဖယ်ပါ - Role ကို static text အနေနဲ့ပြပါ -->
                                    <select name="role" class="form-select" style="display: inline-block; width: auto; margin-bottom: 4px;">
                                        <option value="USER" <%= u.getRole().name().equals("USER")?"selected":"" %>>USER</option>
                                        <option value="ADMIN" <%= u.getRole().name().equals("ADMIN")?"selected":"" %>>ADMIN</option>
                                    </select>
                                    <select name="status" class="form-select" style="display: inline-block; width: auto; margin-bottom: 4px;">
                                        <option value="ACTIVE" <%= u.getStatus().name().equals("ACTIVE")?"selected":"" %>>ACTIVE</option>
                                        <option value="INACTIVE" <%= u.getStatus().name().equals("INACTIVE")?"selected":"" %>>INACTIVE</option>
                                    </select>
                                    <button type="submit" class="action-btn update">Update</button>
                                </form>
                                <br>
                                <button type="button" 
                                        class="action-btn view" 
                                        data-name="<%= fullName.replace("\"", "&quot;") %>"
                                        data-username="<%= u.getUsername() != null ? u.getUsername().replace("\"", "&quot;") : "" %>"
                                        data-gender="<%= gender %>"
                                        data-bio="<%= bio.replace("\"", "&quot;").replace("\n", " ").replace("\r", "") %>"
                                        data-hasavatar="<%= hasRealAvatar %>"
                                        data-letter="<%= initialLetter %>"
                                        data-role="<%= u.getRole().name() %>"
                                        data-status="<%= u.getStatus().name() %>"
                                        data-email="<%= u.getEmail() %>"
                                        onclick="openProfileInspector(this)">View</button>
                                <a href="${pageContext.request.contextPath}/admin/users/delete?id=<%= u.getId() %>" 
                                   class="action-btn delete" 
                                   onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                            </td>
                        </tr>
                        <%      }
                            } 
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <% 
                Integer currentPage = (Integer) request.getAttribute("currentPage");
                Integer totalPages = (Integer) request.getAttribute("totalPages");
                
                if (currentPage != null && totalPages != null && totalPages > 1) {
                    String currentSearch = request.getParameter("search");
                    String searchQueryString = (currentSearch != null && !currentSearch.trim().isEmpty()) 
                        ? "&search=" + java.net.URLEncoder.encode(currentSearch, "UTF-8") : "";
            %>
            <div class="pagination-bar">
                <span class="page-info">
                    Showing page <strong><%= currentPage %></strong> of <strong><%= totalPages %></strong>
                </span>
                <div class="pagination-links">
                    <% if (currentPage > 1) { %>
                        <a href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage - 1 %><%= searchQueryString %>" class="btn-page">
                            ← Previous
                        </a>
                    <% } else { %>
                        <span class="btn-page disabled">← Previous</span>
                    <% } %>
                    
                    <% if (currentPage < totalPages) { %>
                        <a href="${pageContext.request.contextPath}/admin/users?page=<%= currentPage + 1 %><%= searchQueryString %>" class="btn-page active">
                            Next →
                        </a>
                    <% } else { %>
                        <span class="btn-page disabled">Next →</span>
                    <% } %>
                </div>
            </div>
            <% } %>

        </main>
    </div>

    <!-- Modal -->
    <div class="modal-mask" id="inspectorModal" onclick="closeProfileInspector(event)">
        <div class="modal-body" onclick="event.stopPropagation()">
            <button class="modal-close-x" onclick="document.getElementById('inspectorModal').classList.remove('open')">&times;</button>
            
            <div class="modal-header-profile">
                <div id="modalAvatarSlot"></div>
                <div>
                    <div class="modal-name" id="modalName">Name</div>
                    <div class="modal-username" id="modalUsername">@username</div>
                </div>
            </div>
            
            <span class="modal-section-title">Biography</span>
            <div class="modal-bio" id="modalBio">"Bio."</div>
            
            <span class="modal-section-title">Core Identity Profile</span>
            <div class="modal-info-grid" style="margin-bottom: 14px;">
                <div class="modal-info-row"><span class="modal-label">Gender:</span><span class="modal-val" id="modalGender">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">System Role:</span><span class="modal-val" id="modalRole">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Account Status:</span><span class="modal-val" id="modalStatus">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Email:</span><span class="modal-val" id="modalEmail">N/A</span></div>
            </div>
        </div>
    </div>

    <script>
        function openProfileInspector(button) {
            const name = button.getAttribute('data-name') || 'No Name';
            const username = button.getAttribute('data-username');
            const gender = button.getAttribute('data-gender') || 'N/A';
            const bio = button.getAttribute('data-bio') || 'No biography yet.';
            const hasAvatar = button.getAttribute('data-hasavatar') === 'true';
            const fallbackLetter = button.getAttribute('data-letter') || 'U';
            
            const role = button.getAttribute('data-role') || 'N/A';
            const status = button.getAttribute('data-status') || 'N/A';
            const email = button.getAttribute('data-email') || 'N/A';
        
            document.getElementById('modalName').textContent = name;
            document.getElementById('modalUsername').textContent = username ? "@" + username : "@User";
            document.getElementById('modalBio').textContent = `"${bio}"`;
            
            document.getElementById('modalGender').textContent = gender;
            document.getElementById('modalRole').textContent = role;
            document.getElementById('modalStatus').textContent = status;
            document.getElementById('modalEmail').textContent = email;
            
            const avatarSlot = document.getElementById('modalAvatarSlot');
            avatarSlot.innerHTML = ""; 
            
            if (hasAvatar) {
                const currentRow = button.closest('tr');
                const workingTableImg = currentRow ? currentRow.querySelector('.mini-avatar') : null;
                
                if (workingTableImg) {
                    const clonedImg = workingTableImg.cloneNode(true);
                    clonedImg.className = "modal-avatar"; 
                    avatarSlot.appendChild(clonedImg);
                } else {
                    avatarSlot.innerHTML = `<div class="modal-avatar-letter">${fallbackLetter}</div>`;
                }
            } else {
                avatarSlot.innerHTML = `<div class="modal-avatar-letter">${fallbackLetter}</div>`;
            }
            
            document.getElementById('inspectorModal').classList.add('open');
        }
        
        function closeProfileInspector(event) {
            if (event.target === event.currentTarget) {
                document.getElementById('inspectorModal').classList.remove('open');
            }
        }
        
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                document.getElementById('inspectorModal').classList.remove('open');
            }
        });
    </script>

</body>
</html>