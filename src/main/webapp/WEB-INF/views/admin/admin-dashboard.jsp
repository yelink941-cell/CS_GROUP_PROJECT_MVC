<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Portal - Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">

    <style>
        body { background: #f3f6fb; }

        .welcome-card {
            background: #ffffff;
            padding: 35px 40px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-left: 8px solid #0284c7;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }

        .welcome-card h2 {
            font-size: 26px;
            color: #1e293b;
            margin: 0 0 5px 0;
        }

        .welcome-card p {
            font-size: 15px;
            color: #64748b;
            line-height: 1.6;
            margin: 0;
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
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
            opacity: 0.35;
        }

        .card-bottom {
            padding: 12px 24px;
            background: rgba(0,0,0,0.02);
            font-size: 13px;
            color: #64748b;
            border-top: 1px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-bottom .trend-up { color: #10b981; }
        .card-bottom .trend-down { color: #ef4444; }

        .dashboard-section-title {
            margin: 8px 0 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .dashboard-section-title h2 {
            margin: 0;
            font-size: 20px;
            color: #1e293b;
            font-weight: 800;
        }

        .dashboard-section-title p {
            margin: 4px 0 0;
            color: #64748b;
            font-size: 14px;
        }

        .dashboard-card-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 30px;
        }

        .dashboard-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 24px 22px;
            text-decoration: none;
            color: #1e293b;
            box-shadow: 0 4px 14px rgba(15, 23, 42, 0.06);
            transition: all 0.25s ease;
            min-height: 145px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 16px 30px rgba(15, 23, 42, 0.12);
            border-color: #93c5fd;
        }

        .dashboard-card-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            margin-bottom: 16px;
        }

        .dashboard-card h3 {
            margin: 0;
            font-size: 17px;
            font-weight: 800;
            color: #0f172a;
        }

        .dashboard-card p {
            margin: 8px 0 14px;
            color: #64748b;
            font-size: 13px;
            line-height: 1.5;
        }

        .dashboard-card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #2563eb;
            font-weight: 700;
            font-size: 13px;
        }

        .icon-blue { background: #dbeafe; color: #2563eb; }
        .icon-green { background: #dcfce7; color: #16a34a; }
        .icon-orange { background: #ffedd5; color: #ea580c; }
        .icon-purple { background: #ede9fe; color: #7c3aed; }
        .icon-red { background: #fee2e2; color: #dc2626; }
        .icon-cyan { background: #cffafe; color: #0891b2; }
        .icon-yellow { background: #fef9c3; color: #ca8a04; }
        .icon-slate { background: #e2e8f0; color: #475569; }

        @media (max-width: 1200px) {
            .dashboard-card-grid { grid-template-columns: repeat(3, 1fr); }
        }

        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .dashboard-card-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            .sidebar { width: 200px; }
            .main-workspace { margin-left: 200px; width: calc(100% - 200px); }
            .stats-grid, .dashboard-card-grid { grid-template-columns: 1fr; }
            .content-area { padding: 20px; }
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
            .welcome-card h2 { font-size: 20px; }
        }

        @media (max-width: 480px) {
            .sidebar { display: none; }
            .main-workspace { margin-left: 0; width: 100%; }
            .content-area { padding: 15px; }
            .card-top .stat-value { font-size: 24px; }
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

    String displayUsername = currentUser != null ? currentUser.getUsername() : auth.getName();
    String displayRole = currentUser != null ? currentUser.getRole().name() : "ADMIN";
%>

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

            <div class="welcome-card">
                <div>
                    <h2>System Administrator! Panel Loaded.</h2>
                    <p>Use the dashboard cards to manage categories, tags, posts, users, events, and reports.</p>
                </div>
                <div class="date-time">
                    <div class="time" id="currentTime">--:--:--</div>
                    <div id="currentDate">--/--/----</div>
                </div>
            </div>

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
            </div>

            <div class="dashboard-section-title">
                <div>
                    <h2>Management Shortcuts</h2>
                    <p>Cards below match the admin sidebar modules.</p>
                </div>
            </div>

            <div class="dashboard-card-grid">
                <a href="${pageContext.request.contextPath}/admin/categories" class="dashboard-card">
                    <div>
                        <div class="dashboard-card-icon icon-blue">📁</div>
                        <h3>Category Management</h3>
                        <p>Create, update, activate, deactivate, and organize cheat sheet categories.</p>
                    </div>
                    <div class="dashboard-card-footer"><span>Open Category</span><span>→</span></div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/tags" class="dashboard-card">
                    <div>
                        <div class="dashboard-card-icon icon-orange">🏷️</div>
                        <h3>Tags Management</h3>
                        <p>Manage searchable tags used by posts and category-based filtering.</p>
                    </div>
                    <div class="dashboard-card-footer"><span>Open Tags</span><span>→</span></div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/posts" class="dashboard-card">
                    <div>
                        <div class="dashboard-card-icon icon-purple">📄</div>
                        <h3>Post Management</h3>
                        <p>View, archive, remove, and moderate published or existing posts.</p>
                    </div>
                    <div class="dashboard-card-footer"><span>Manage Posts</span><span>→</span></div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="dashboard-card">
                    <div>
                        <div class="dashboard-card-icon icon-yellow">⏳</div>
                        <h3>Pending Posts</h3>
                        <p>Review posts submitted by users before publishing them to the public.</p>
                    </div>
                    <div class="dashboard-card-footer"><span>Review Queue</span><span>→</span></div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/users" class="dashboard-card">
                    <div>
                        <div class="dashboard-card-icon icon-green">👥</div>
                        <h3>User Management</h3>
                        <p>Inspect users, roles, account status, and platform user activity.</p>
                    </div>
                    <div class="dashboard-card-footer"><span>Manage Users</span><span>→</span></div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/announcements" class="dashboard-card">
                    <div>
                        <div class="dashboard-card-icon icon-cyan">&#128364;</div>
                        <h3>Event Announcements</h3>
                        <p>Create and manage announcements or events shown to platform users.</p>
                    </div>
                    <div class="dashboard-card-footer"><span>Open Events</span><span>→</span></div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="dashboard-card">
                    <div>
                        <div class="dashboard-card-icon icon-slate">&#128196;</div>
                        <h3>CheatSheet Report</h3>
                        <p>Generate and download cheat sheet reports for administrative review.</p>
                    </div>
                    <div class="dashboard-card-footer"><span>Generate Report</span><span>→</span></div>
                </a>

                <a href="${pageContext.request.contextPath}/admin/reports" class="dashboard-card">
                    <div>
                        <div class="dashboard-card-icon icon-red">📊</div>
                        <h3>Report Logs</h3>
                        <p>Review user-submitted reports, moderation logs, and system issues.</p>
                    </div>
                    <div class="dashboard-card-footer"><span>View Logs</span><span>→</span></div>
                </a>
            </div>

        </main>
    </div>

    <script>
        function updateTime() {
            const now = new Date();

            document.getElementById('currentTime').textContent =
                now.toLocaleTimeString('en-US', { hour12: false });

            document.getElementById('currentDate').textContent =
                now.toLocaleDateString('en-US', {
                    weekday: 'long',
                    year: 'numeric',
                    month: 'long',
                    day: 'numeric'
                });
        }

        updateTime();
        setInterval(updateTime, 1000);
    </script>

</body>
</html>
