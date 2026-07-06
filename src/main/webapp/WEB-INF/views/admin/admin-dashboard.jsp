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
        /* ============================================
           DASHBOARD ADDITIONAL STYLES
           ============================================ */
        
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

    String displayUsername = currentUser != null ? currentUser.getUsername() : auth.getName();
    String displayRole = currentUser != null ? currentUser.getRole().name() : "ADMIN";
%>

    <!-- Sidebar (Same as form.jsp) -->
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
        </ul>
    </aside>

    <!-- Main Workspace -->
    <div class="main-workspace">
        <header class="top-navbar">
            <div class="nav-title">📊 System Overview Workspace</div>
            <div class="user-profile-badge">
                <a href="${pageContext.request.contextPath}/" class="btn-logout">🏠 Home</a>
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <main class="content-area">
            <!-- Welcome Card -->
            <div class="welcome-card">
                <div>
                    <h2>System Administrator! Panel Loaded.</h2>
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

               <%--  <a href="${pageContext.request.contextPath}/admin/comments" class="stat-card">
                    <div class="card-top" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                        <div>Comments</div>
                        <div class="stat-value">${totalComments}</div>
                        <div class="stat-icon">💬</div>
                    </div>
                    <div class="card-bottom">
                        <span>View Details &rsaquo;</span>
                        <span class="trend-up">↑ 8%</span>
                    </div>
                </a> --%>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/admin/categories/new" class="quick-action-btn">
                    <span class="icon">📁</span>
                    <span class="label">New Category</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="quick-action-btn">
                    <span class="icon">✅</span>
                    <span class="label">Review Pending</span>
                </a>
                <a href="${pageContext.request.contextPath}/admin/tags" class="quick-action-btn">
                    <span class="icon">🏷️</span>
                    <span class="label">Manage Tags</span>
                </a>
                 <a href="${pageContext.request.contextPath}/admin/tags" class="quick-action-btn">
                    <span class="icon">🏷️</span>
                    <span class="label">Manage Tags</span>
                     <a href="${pageContext.request.contextPath}/admin/" class="quick-action-btn">
                    <span class="icon">🏷️</span>
                    <span class="label">Manage Tags</span>
                </a>
                </a>
            </div>

        </main>
    </div>

    <!-- Current Time Script -->
    <script>
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
    </script>

</body>
</html>