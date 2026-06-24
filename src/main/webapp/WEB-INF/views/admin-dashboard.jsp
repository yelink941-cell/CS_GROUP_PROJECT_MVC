<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Portal - Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; color: #333; }
        
        /* --- SIDEBAR STYLES --- */
        .sidebar { width: 260px; background-color: #1e293b; color: #fff; display: flex; flex-direction: column; position: fixed; height: 100vh; }
        .sidebar-brand { padding: 24px; font-size: 20px; font-weight: bold; background-color: #0f172a; text-align: center; color: #38bdf8; }
        .sidebar-menu { list-style: none; flex-grow: 1; padding: 20px 0; }
        .sidebar-item { margin: 4px 15px; }
        .sidebar-link { display: flex; align-items: center; padding: 12px 16px; color: #cbd5e1; text-decoration: none; border-radius: 6px; font-size: 15px; transition: all 0.2s; }
        .sidebar-link:hover { background-color: #334155; color: #fff; }
        .sidebar-link.active { background-color: #0284c7; color: #fff; font-weight: 6px; }
        .sidebar-link[href="#"] { display: none; }
        
        /* --- MAIN LAYOUT WORKSPACE --- */
        .main-workspace { margin-left: 260px; flex-grow: 1; display: flex; flex-direction: column; }
        
        /* Top Navigation Header Bar */
        .top-navbar { height: 70px; background-color: #ffffff; display: flex; align-items: center; justify-content: space-between; padding: 0 30px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .nav-title { font-size: 18px; font-weight: 6px; color: #475569; }
        .user-profile-badge { display: flex; align-items: center; gap: 10px; }
        .badge { background-color: #ef4444; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; }
        
        /* Page Body Content Wrap */
        .content-area { padding: 40px; max-width: 1200px; width: 100%; margin: 0 auto; }
        .welcome-card { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border-left: 5px solid #0284c7; }
        
        /* Quick Action Shortcut Cards Grid */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-top: 30px; }
        .stat-card { background: white; padding: 24px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); border: 1px solid #e2e8f0; text-decoration: none; color: inherit; transition: transform 0.2s; }
        .stat-card:hover { transform: translateY(-3px); border-color: #0284c7; }
        .stat-card h3 { color: #0284c7; font-size: 16px; margin-bottom: 8px; }
        .stat-card p { font-size: 13px; color: #64748b; }
        
        .btn-logout { background-color: #64748b; color: white; padding: 8px 16px; text-decoration: none; border-radius: 6px; font-size: 14px; }
        .btn-logout:hover { background-color: #475569; }
    </style>
</head>
<body>

    <%
    User currentUser = (User) session.getAttribute("user");
    String currentRole = (String) session.getAttribute("role");

    if (currentUser == null || !"ADMIN".equals(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin Panel 👑</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="sidebar-link active">
                    <span>📊 Core Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <span>🗂️ Category Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/tags" class="sidebar-link">
                    <span>Tag Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="#" class="sidebar-link">
                    <span>📝 Post Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="sidebar-link">
                    <span>Pending Posts</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="#" class="sidebar-link">
                    <span>👥 User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="#" class="sidebar-link">
                    <span>🚨 Report Logs</span>
                </a>
            </li>
        </ul>
    </aside>

    <div class="main-workspace">
        
        <header class="top-navbar">
            <div class="nav-title">System Overview Workspace</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong><%= currentUser.getUsername() %></strong></span>
                <span class="badge"><%= currentUser.getRole() %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
            </div>
        </header>

        <main class="content-area">
            <div class="welcome-card">
                <h2>Good Evening, System Administrator! Panel Loaded.</h2>
                <p style="color: #64748b; margin-top: 5px;">Use the left sidebar navigation matrix to modify system collections, handle tags, or review reports.</p>
            </div>

            <div class="stats-grid">
                <a href="${pageContext.request.contextPath}/admin/categories" class="stat-card">
                    <h3>Categories Config Matrix</h3>
                    <p>Manage categories, set visibility flags, and organize platform sections.</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/tags" class="stat-card">
                    <h3>Tags Config Matrix</h3>
                    <p>Manage tags and organize searchable post labels.</p>
                </a>
                <div class="stat-card">
                    <h3>Active Post Items</h3>
                    <p>Review system sheet documents, code samples, and compiled attachment downloads.</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="stat-card">
                    <h3>Pending Post Reviews</h3>
                    <p>Approve or reject public posts submitted by users.</p>
                </a>
                <div class="stat-card">
                    <h3>Moderation Queues</h3>
                    <p>Inspect flagged user reports, descriptions, and ban actions.</p>
                </div>
            </div>
        </main>
    </div>

</body>
</html>
