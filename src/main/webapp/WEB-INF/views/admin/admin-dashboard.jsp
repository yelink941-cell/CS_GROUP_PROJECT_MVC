<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Portal - Dashboard</title>
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; color: #333; }
        
        /* Sidebar */
        .sidebar { 
            width: 260px; 
            background-color: #1e293b; 
            color: #fff; 
            display: flex; 
            flex-direction: column; 
            position: fixed; 
            height: 100vh; 
            overflow-y: auto;
            z-index: 1000;
        }
        .sidebar-brand { 
            padding: 24px; 
            font-size: 20px; 
            font-weight: bold; 
            background-color: #0f172a; 
            text-align: center; 
            color: #38bdf8; 
        }
        .sidebar-menu { 
            list-style: none; 
            flex-grow: 1; 
            padding: 20px 0; 
        }
        .sidebar-item { 
            margin: 4px 15px; 
        }
        .sidebar-link { 
            display: flex; 
            align-items: center; 
            padding: 12px 16px; 
            color: #cbd5e1; 
            text-decoration: none; 
            border-radius: 6px; 
            font-size: 15px; 
            transition: all 0.2s; 
        }
        .sidebar-link:hover { 
            background-color: #334155; 
            color: #fff; 
        }
        .sidebar-link.active { 
            background-color: #0284c7; 
            color: #fff; 
            font-weight: 600; 
        }
        .sidebar-link span {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        /* Main Workspace */
        .main-workspace { 
            margin-left: 260px; 
            flex-grow: 1; 
            display: flex; 
            flex-direction: column; 
            min-height: 100vh;
            width: calc(100% - 260px);
        }
        
        /* Top Navbar */
        .top-navbar { 
            height: 70px; 
            background-color: #ffffff; 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            padding: 0 30px; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.05); 
            border-bottom: 1px solid #e2e8f0;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .nav-title { 
            font-size: 18px; 
            font-weight: 600; 
            color: #475569; 
        }
        .user-profile-badge { 
            display: flex; 
            align-items: center; 
            gap: 10px; 
        }
        .badge { 
            background-color: #ef4444; 
            color: white; 
            padding: 4px 8px; 
            border-radius: 4px; 
            font-size: 12px; 
            font-weight: bold; 
            text-transform: uppercase; 
        }
        .btn-logout { 
            background-color: #64748b; 
            color: white; 
            padding: 8px 16px; 
            text-decoration: none; 
            border-radius: 6px; 
            font-size: 14px; 
            transition: background 0.2s;
        }
        .btn-logout:hover { 
            background-color: #475569; 
        }
        
        /* Content Area */
        .content-area { 
            padding: 30px 35px; 
            max-width: 1400px; 
            width: 100%; 
            margin: 0 auto; 
        }
        
        /* Welcome Card */
        .welcome-card {
            background: #ffffff;
            padding: 35px 40px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 8px solid #0284c7;
            margin-bottom: 30px;
            width: 100%;
            max-width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        .welcome-card h2 {
            font-size: 26px;
            color: #1e293b;
            margin-bottom: 5px;
        }
        .welcome-card p {
            font-size: 15px;
            color: #64748b;
            line-height: 1.6;
        }
        .welcome-card .date-time {
            font-size: 14px;
            color: #64748b;
            text-align: right;
        }
        .welcome-card .date-time .time {
            font-size: 24px;
            font-weight: 700;
            color: #1e293b;
        }
        
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 0;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
            overflow: hidden;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px -8px rgba(0, 0, 0, 0.15);
        }
        .card-top {
            padding: 20px 24px;
            color: white;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-top .stat-value {
            font-size: 30px;
            font-weight: 800;
        }
        .card-top .stat-icon {
            font-size: 32px;
            opacity: 0.3;
        }
        .card-bottom {
            padding: 12px 24px;
            background: rgba(0,0,0,0.02);
            font-size: 13px;
            color: #64748b;
            border-top: 1px solid #f1f5f9;
            transition: color 0.2s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-bottom:hover {
            color: #1e293b;
        }
        .card-bottom .trend-up { color: #10b981; }
        .card-bottom .trend-down { color: #ef4444; }
        
        /* Chart and Activity Section */
        .dashboard-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .chart-container {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }
        .chart-container h3 {
            font-size: 16px;
            color: #1e293b;
            margin-bottom: 20px;
        }
        .chart-container canvas {
            max-height: 250px;
        }
        
        .recent-activity {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }
        .recent-activity h3 {
            font-size: 16px;
            color: #1e293b;
            margin-bottom: 20px;
        }
        .activity-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 0;
            border-bottom: 1px solid #f1f5f9;
        }
        .activity-item:last-child {
            border-bottom: none;
        }
        .activity-icon {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
        }
        .activity-icon.blue { background: #dbeafe; }
        .activity-icon.green { background: #dcfce7; }
        .activity-icon.yellow { background: #fef3c7; }
        .activity-icon.red { background: #fee2e2; }
        .activity-icon.purple { background: #ede9fe; }
        
        .activity-content {
            flex: 1;
        }
        .activity-content .title {
            font-size: 14px;
            font-weight: 600;
            color: #1e293b;
        }
        .activity-content .time {
            font-size: 12px;
            color: #94a3b8;
        }
        
        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 30px;
        }
        .quick-action-btn {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            text-decoration: none;
            color: #1e293b;
            transition: all 0.3s ease;
        }
        .quick-action-btn:hover {
            background: #f8fafc;
            transform: translateY(-3px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .quick-action-btn .icon {
            font-size: 28px;
            display: block;
            margin-bottom: 8px;
        }
        .quick-action-btn .label {
            font-size: 13px;
            font-weight: 600;
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .dashboard-row {
                grid-template-columns: 1fr;
            }
            .quick-actions {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 200px;
            }
            .main-workspace {
                margin-left: 200px;
                width: calc(100% - 200px);
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .content-area {
                padding: 20px;
            }
            .top-navbar {
                flex-direction: column;
                height: auto;
                padding: 15px 20px;
                gap: 10px;
            }
            .user-profile-badge {
                flex-wrap: wrap;
                justify-content: center;
            }
            .welcome-card {
                padding: 20px;
                flex-direction: column;
                text-align: center;
            }
            .welcome-card .date-time {
                text-align: center;
                margin-top: 15px;
            }
            .welcome-card h2 {
                font-size: 20px;
            }
            .quick-actions {
                grid-template-columns: 1fr 1fr;
            }
        }
        @media (max-width: 480px) {
            .sidebar {
                display: none;
            }
            .main-workspace {
                margin-left: 0;
                width: 100%;
            }
            .content-area {
                padding: 15px;
            }
            .quick-actions {
                grid-template-columns: 1fr;
            }
            .card-top .stat-value {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();

    boolean isSpringAdmin = false;
    if (auth != null && auth.isAuthenticated()) {
        isSpringAdmin = auth.getAuthorities().stream()
                            .anyMatch(a -> a.getAuthority().equalsIgnoreCase("ROLE_ADMIN") || a.getAuthority().equalsIgnoreCase("ADMIN"));
    }

    if (currentUser == null && !isSpringAdmin) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String displayUsername = (currentUser != null) ? currentUser.getUsername() : auth.getName();
    String displayRole = (currentUser != null) ? currentUser.getRole().name() : "ADMIN";
%>

 <!-- Sidebar -->
<aside class="sidebar">
    <div class="sidebar-brand">CheatSheet Admin Panel 👑</div>
    <ul class="sidebar-menu">
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link active">
                <span>📊 Core Dashboard</span>
            </a>
        </li>
        <li class="sidebar-item">
            <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                <span>📁 Category Management</span>
            </a>
        </li>
        <!-- ✅ Tags Management ကို ဒီမှာထည့်ပါ -->
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
            <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link">
                <span>📊 Report Logs</span>
            </a>
        </li>
    </ul>
</aside>

    <!-- Main Workspace -->
    <div class="main-workspace">
        <header class="top-navbar">
            <div class="nav-title">📊 System Overview Workspace</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">
            <!-- Welcome Card -->
            <div class="welcome-card">
                <div>
                    <h2>Good Evening, System Administrator! Panel Loaded.</h2>
                    <p>Use the left sidebar navigation matrix to modify system collections, handle tags, or review reports.</p>
                </div>
                <div class="date-time">
                    <div class="time" id="currentTime">--:--:--</div>
                    <div id="currentDate">--/--/----</div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <a href="${pageContext.request.contextPath}/admin/posts" class="stat-card">
                    <div class="card-top" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                        <div>Active Posts</div>
                        <div class="stat-value">${totalPosts}</div>
                        <div class="stat-icon">📄</div>
                    </div>
                    <div class="card-bottom">
                        <span>View Details &rsaquo;</span>
                        <span class="trend-up">↑ 12%</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="stat-card">
                    <div class="card-top" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                        <div>Pending Posts</div>
                        <div class="stat-value">${pendingPosts}</div>
                        <div class="stat-icon">⏳</div>
                    </div>
                    <div class="card-bottom">
                        <span>View Details &rsaquo;</span>
                        <span class="trend-down">⚠️ Needs Review</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/users" class="stat-card">
                    <div class="card-top" style="background: linear-gradient(135deg, #10b981, #059669);">
                        <div>Total Users</div>
                        <div class="stat-value">${totalUsers}</div>
                        <div class="stat-icon">👥</div>
                    </div>
                    <div class="card-bottom">
                        <span>View Details &rsaquo;</span>
                        <span class="trend-up">↑ 5%</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/comments" class="stat-card">
                    <div class="card-top" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                        <div>Comments</div>
                        <div class="stat-value">${totalComments}</div>
                        <div class="stat-icon">💬</div>
                    </div>
                    <div class="card-bottom">
                        <span>View Details &rsaquo;</span>
                        <span class="trend-up">↑ 8%</span>
                    </div>
                </a>
            </div>

            <!-- Chart and Recent Activity -->
            <div class="dashboard-row">
                <!-- Chart -->
                <div class="chart-container">
                    <h3>📈 Monthly Activity Overview</h3>
                    <canvas id="activityChart"></canvas>
                </div>

                <!-- Recent Activity -->
                <div class="recent-activity">
                    <h3>🔄 Recent Activities</h3>
                    
                    <div class="activity-item">
                        <div class="activity-icon green">📝</div>
                        <div class="activity-content">
                            <div class="title">New post published</div>
                            <div class="time">2 minutes ago</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon yellow">👤</div>
                        <div class="activity-content">
                            <div class="title">New user registered</div>
                            <div class="time">15 minutes ago</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon blue">💬</div>
                        <div class="activity-content">
                            <div class="title">New comment added</div>
                            <div class="time">1 hour ago</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon purple">📁</div>
                        <div class="activity-content">
                            <div class="title">Category updated</div>
                            <div class="time">3 hours ago</div>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="activity-icon red">⚠️</div>
                        <div class="activity-content">
                            <div class="title">Post reported</div>
                            <div class="time">5 hours ago</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/admin/posts/new" class="quick-action-btn">
                    <span class="icon">✏️</span>
                    <span class="label">Create Post</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/categories/new" class="quick-action-btn">
                    <span class="icon">📁</span>
                    <span class="label">New Category</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="quick-action-btn">
                    <span class="icon">✅</span>
                    <span class="label">Review Pending</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/users" class="quick-action-btn">
                    <span class="icon">👥</span>
                    <span class="label">Manage Users</span>                 
                </a>
                <a href="${pageContext.request.contextPath}/admin/tags" class="quick-action-btn">
    <span class="icon">🏷️</span>
    <span class="label">Manage Tags</span>
</a>
            </div>

        </main>
    </div>

    <!-- Chart.js Script -->
    <script>
        // Current Time
        function updateTime() {
            const now = new Date();
            document.getElementById('currentTime').textContent = now.toLocaleTimeString('en-US', { hour12: false });
            document.getElementById('currentDate').textContent = now.toLocaleDateString('en-US', { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
            });
        }
        updateTime();
        setInterval(updateTime, 1000);

        // Chart
        const ctx = document.getElementById('activityChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                datasets: [{
                    label: 'Posts',
                    data: [12, 19, 15, 22, 18, 8, 5],
                    backgroundColor: 'rgba(59, 130, 246, 0.7)',
                    borderColor: '#3b82f6',
                    borderWidth: 2,
                    borderRadius: 6
                }, {
                    label: 'Comments',
                    data: [8, 15, 12, 20, 14, 6, 3],
                    backgroundColor: 'rgba(16, 185, 129, 0.7)',
                    borderColor: '#10b981',
                    borderWidth: 2,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        grid: {
                            color: 'rgba(0,0,0,0.05)'
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    </script>

</body>
</html>