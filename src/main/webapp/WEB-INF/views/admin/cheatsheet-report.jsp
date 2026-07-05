<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CheatSheet Analytics & Reporting Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-light: #f8fafc;
            --panel-bg: #ffffff;
            --panel-border: #e2e8f0;
            --accent-primary: #0284c7;
            --accent-indigo: #4f46e5;
            --accent-rose: #e11d48;
            --accent-emerald: #059669;
            --accent-amber: #d97706;
            --text-main: #0f172a;
            --text-muted: #475569;
            --text-subtle: #64748b;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Plus Jakarta Sans', sans-serif; }
        
        body { 
            display: flex; 
            min-height: 100vh; 
            background-color: var(--bg-light);
            color: var(--text-main); 
            overflow-x: hidden;
        }

        /* Sidebar Styling - Dark Contrast Sidebar for Premium Look */
        .sidebar { 
            width: 270px; 
            background: #0f172a; 
            color: #ffffff;
            display: flex; 
            flex-direction: column; 
            position: fixed; 
            height: 100vh; 
            z-index: 100; 
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.05);
        }

        .sidebar-brand { 
            padding: 24px; 
            font-size: 20px; 
            font-weight: 800; 
            background: #090d16; 
            display: flex; 
            align-items: center; 
            gap: 12px; 
            letter-spacing: -0.5px;
            border-bottom: 1px solid #1e293b;
        }
        .brand-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: linear-gradient(135deg, #0284c7, #4f46e5);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 18px;
            box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3);
        }
        .brand-text {
            color: #ffffff;
        }

        .menu-category { 
            padding: 22px 24px 8px; 
            font-size: 11px; 
            font-weight: 700; 
            text-transform: uppercase; 
            color: #64748b; 
            letter-spacing: 1px; 
        }
        
        .sidebar-menu { list-style: none; flex-grow: 1; padding: 8px 0; overflow-y: auto; }
        .sidebar-item { margin: 4px 14px; }
        .sidebar-link { 
            display: flex; 
            align-items: center; 
            gap: 14px; 
            padding: 11px 16px; 
            color: #94a3b8; 
            text-decoration: none; 
            border-radius: 10px; 
            font-size: 14px; 
            font-weight: 500; 
            transition: all 0.2s ease; 
        }
        .sidebar-link:hover { 
            background: #1e293b; 
            color: #ffffff; 
            transform: translateX(3px);
        }
        .sidebar-link.active { 
            background: #0284c7; 
            color: #ffffff; 
            font-weight: 600; 
            box-shadow: 0 4px 12px rgba(2, 132, 199, 0.3); 
        }
        .sidebar-link i { font-size: 16px; width: 22px; text-align: center; }

        /* Main Workspace */
        .main-workspace { margin-left: 270px; flex-grow: 1; display: flex; flex-direction: column; min-width: 0; }
        
        /* Top Navigation Header */
        .top-navbar { 
            height: 70px; 
            background: #ffffff; 
            display: flex; 
            align-items: center; 
            justify-content: space-between; 
            padding: 0 36px; 
            border-bottom: 1px solid var(--panel-border); 
            position: sticky; 
            top: 0; 
            z-index: 90; 
            box-shadow: 0 1px 3px rgba(0,0,0,0.02);
        }

        .nav-left { display: flex; align-items: center; gap: 30px; }
        .nav-search {
            position: relative;
            display: flex;
            align-items: center;
        }
        .nav-search i {
            position: absolute;
            left: 14px;
            color: var(--text-subtle);
            font-size: 14px;
        }
        .nav-search input {
            background: #f1f5f9;
            border: 1px solid var(--panel-border);
            border-radius: 20px;
            padding: 8px 16px 8px 40px;
            color: var(--text-main);
            font-size: 13px;
            width: 260px;
            outline: none;
            transition: all 0.2s ease;
        }
        .nav-search input:focus {
            background: #ffffff;
            border-color: var(--accent-primary);
            box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15);
            width: 320px;
        }

        .system-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
            color: var(--accent-emerald);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .pulse-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--accent-emerald);
            box-shadow: 0 0 8px var(--accent-emerald);
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(0.95); opacity: 0.8; }
            70% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(0.95); opacity: 0.8; }
        }

        .user-profile { display: flex; align-items: center; gap: 14px; }
        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent-primary), var(--accent-indigo));
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            color: white;
            box-shadow: 0 2px 8px rgba(2, 132, 199, 0.25);
        }

        /* Content Area */
        .content-area { padding: 36px; max-width: 1400px; width: 100%; margin: 0 auto; }
        
        /* Hero Banner */
        .hero-banner { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 32px; 
            background: #ffffff;
            border: 1px solid var(--panel-border);
            padding: 28px 32px;
            border-radius: 20px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
            border-left: 6px solid var(--accent-primary);
        }
        .hero-title { 
            font-size: 28px; 
            font-weight: 800; 
            color: var(--text-main);
            letter-spacing: -0.5px; 
        }
        .hero-subtitle { font-size: 14px; color: var(--text-subtle); margin-top: 4px; }
        
        .action-group { display: flex; gap: 14px; }
        .btn-glow { 
            display: inline-flex; 
            align-items: center; 
            gap: 10px; 
            padding: 12px 22px; 
            border-radius: 12px; 
            font-size: 14px; 
            font-weight: 700; 
            text-decoration: none; 
            border: none; 
            cursor: pointer; 
            transition: all 0.25s ease; 
        }
        .btn-pdf-glow { 
            background: linear-gradient(135deg, #ef4444, #dc2626); 
            color: white; 
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.25); 
        }
        .btn-pdf-glow:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.35); 
        }
        .btn-excel-glow { 
            background: linear-gradient(135deg, #10b981, #059669); 
            color: white; 
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.25); 
        }
        .btn-excel-glow:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.35); 
        }

        /* Analytics Metric Cards */
        .metrics-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 22px; margin-bottom: 32px; }
        .metric-card { 
            background: var(--panel-bg); 
            padding: 24px; 
            border-radius: 16px; 
            border: 1px solid var(--panel-border); 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
            transition: all 0.25s ease;
            position: relative;
        }
        .metric-card:hover {
            transform: translateY(-4px);
            border-color: #cbd5e1;
            box-shadow: 0 10px 20px -3px rgba(0, 0, 0, 0.05);
        }
        .metric-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
        .metric-title { font-size: 13px; font-weight: 700; color: var(--text-subtle); text-transform: uppercase; letter-spacing: 0.5px; }
        .metric-icon { 
            width: 44px; 
            height: 44px; 
            border-radius: 12px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 20px; 
        }
        .icon-blue-soft { background: #e0f2fe; color: #0284c7; }
        .icon-rose-soft { background: #ffe4e6; color: #e11d48; }
        .icon-emerald-soft { background: #d1fae5; color: #059669; }
        .icon-amber-soft { background: #fef3c7; color: #d97706; }
        
        .metric-big-val { font-size: 32px; font-weight: 800; color: var(--text-main); letter-spacing: -1px; }
        .metric-subtext { font-size: 12px; color: var(--text-subtle); margin-top: 6px; display: flex; align-items: center; gap: 6px; }
        
        .link-trigger {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            padding: 6px 14px;
            border-radius: 8px;
            transition: all 0.2s;
        }
        .link-rose { background: #ffe4e6; color: #e11d48; border: 1px solid #fecdd3; }
        .link-rose:hover { background: #fecdd3; }
        .link-emerald { background: #d1fae5; color: #059669; border: 1px solid #a7f3d0; }
        .link-emerald:hover { background: #a7f3d0; }

        /* Data Matrix Table Card */
        .matrix-card { 
            background: var(--panel-bg); 
            border-radius: 20px; 
            border: 1px solid var(--panel-border); 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03), 0 2px 4px -1px rgba(0, 0, 0, 0.02);
            overflow: hidden; 
        }
        
        .matrix-header {
            padding: 22px 28px;
            border-bottom: 1px solid var(--panel-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ffffff;
        }
        .matrix-header-title {
            font-size: 17px;
            font-weight: 700;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .matrix-header-title i { color: var(--accent-primary); }
        .records-counter {
            font-size: 13px;
            color: var(--text-muted);
            background: #f1f5f9;
            padding: 4px 14px;
            border-radius: 20px;
            font-weight: 600;
        }

        /* Table Styling */
        .data-table { width: 100%; border-collapse: collapse; text-align: left; }
        .data-table th { 
            padding: 18px 28px; 
            font-size: 12px; 
            font-weight: 700; 
            color: #475569; 
            text-transform: uppercase; 
            letter-spacing: 0.5px; 
            border-bottom: 2px solid var(--panel-border); 
            background: #f8fafc;
        }
        .data-table td { 
            padding: 20px 28px; 
            border-bottom: 1px solid var(--panel-border); 
            font-size: 14px; 
            color: var(--text-main); 
            vertical-align: middle; 
            transition: background 0.15s;
        }
        .data-table tr:hover td { background: #f8fafc; }

        .rank-badge {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 13px;
            background: #f1f5f9;
            color: #475569;
        }
        .rank-top1 { background: #fef3c7; color: #b45309; }
        .rank-top2 { background: #e0f2fe; color: #0369a1; }
        .rank-top3 { background: #e0e7ff; color: #4338ca; }

        .post-title-cell { font-weight: 600; color: var(--text-main); display: flex; align-items: center; gap: 10px; }
        .post-title-cell i { color: var(--accent-primary); font-size: 14px; }
        
        .author-badge { display: inline-flex; align-items: center; gap: 8px; font-weight: 500; }
        .author-avatar {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: #e0f2fe;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            color: var(--accent-primary);
        }

        .date-code { 
            font-family: 'JetBrains Mono', monospace; 
            font-size: 12px; 
            color: var(--text-muted); 
            background: #f1f5f9;
            padding: 4px 10px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
        }

        .reaction-pill { 
            display: inline-flex; 
            align-items: center; 
            gap: 6px;
            padding: 6px 14px; 
            border-radius: 20px; 
            font-weight: 700; 
            font-size: 13px; 
            background: #e0f2fe;
            color: #0284c7;
        }

        /* Pagination Bar */
        .pagination-container {
            padding: 20px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ffffff;
            border-top: 1px solid var(--panel-border);
        }
        .pagination-info { font-size: 13px; color: var(--text-muted); }
        
        .pagination-controls { display: flex; gap: 8px; }
        .page-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 36px;
            height: 36px;
            padding: 0 12px;
            border-radius: 10px;
            background: #ffffff;
            border: 1px solid var(--panel-border);
            color: var(--text-main);
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .page-btn:hover:not(.disabled) {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }
        .page-btn.active {
            background: var(--accent-primary);
            border-color: var(--accent-primary);
            color: white;
            box-shadow: 0 2px 8px rgba(2, 132, 199, 0.3);
        }
        .page-btn.disabled {
            opacity: 0.4;
            cursor: not-allowed;
            pointer-events: none;
        }

        .no-records { padding: 50px; text-align: center; color: var(--text-subtle); font-style: italic; }
    </style>
</head>
<body>

<%
    User currentUser = (User) session.getAttribute("currentUser");
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();

    String displayUsername = "Administrator";
    if (currentUser != null) {
        displayUsername = currentUser.getUsername();
    } else if (auth != null && auth.isAuthenticated()) {
        displayUsername = auth.getName();
    }
    String userInitial = displayUsername.substring(0, 1).toUpperCase();
%>

    <!-- Left Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="brand-icon">
                <i class="fa-solid fa-code"></i>
            </div>
            <span class="brand-text">CheatSheet Pro</span>
        </div>
        
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Overview Dashboard</span>
                </a>
            </li>
            
            <div class="menu-category">Data & Reporting</div>
            
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link active">
                    <i class="fa-solid fa-cube"></i>
                    <span>CheatSheet Analytics</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link">
                    <i class="fa-solid fa-shield-cat"></i>
                    <span>Report Logs</span>
                </a>
            </li>
            
            <div class="menu-category">Platform Admin</div>
            
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <i class="fa-solid fa-layer-group"></i>
                    <span>Category Matrix</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/tags" class="sidebar-link">
                    <i class="fa-solid fa-tags"></i>
                    <span>Tag Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <i class="fa-solid fa-user-gear"></i>
                    <span>User Registry</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts" class="sidebar-link">
                    <i class="fa-solid fa-folder-open"></i>
                    <span>CheatSheets List</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/comments" class="sidebar-link">
                    <i class="fa-solid fa-comments"></i>
                    <span>Comments Moderation</span>
                </a>
            </li>
        </ul>
    </aside>

    <!-- Main Workspace -->
    <div class="main-workspace">
        <!-- Top Navbar -->
        <header class="top-navbar">
            <div class="nav-left">
                <div class="system-badge">
                    <div class="pulse-dot"></div>
                    <span>ANALYTICS ENGINE ONLINE</span>
                </div>
                <div class="nav-search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input type="text" id="filterInput" onkeyup="filterTable()" placeholder="Quick filter CheatSheets...">
                </div>
            </div>
            
            <div class="user-profile">
                <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); text-decoration: none; font-size: 13px; font-weight: 600; margin-right: 10px;">
                    <i class="fa-solid fa-globe"></i> Main App
                </a>
                <div class="user-avatar"><%= userInitial %></div>
                <span style="font-size: 14px; font-weight: 600; color: var(--text-main);"><%= displayUsername %></span>
                <a href="${pageContext.request.contextPath}/logout" style="color: var(--text-subtle); text-decoration: none; font-size: 14px; margin-left: 8px;">
                    <i class="fa-solid fa-right-from-bracket"></i>
                </a>
            </div>
        </header>

        <!-- Main Content Area -->
        <main class="content-area">
            <!-- Hero Banner -->
            <div class="hero-banner">
                <div>
                    <h1 class="hero-title">CheatSheet Intelligence Portal</h1>
                    <p class="hero-subtitle">Real-time performance analytics, report compilation, and automated data exports.</p>
                </div>
                <div class="action-group">
                    <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet/pdf" target="_blank" class="btn-glow btn-pdf-glow">
                        <i class="fa-solid fa-file-pdf"></i> Generate PDF Report
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet/excel" class="btn-glow btn-excel-glow">
                        <i class="fa-solid fa-file-excel"></i> Export Excel (.xlsx)
                    </a>
                </div>
            </div>

            <!-- Analytics Metric Cards -->
            <div class="metrics-grid">
                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-title">Total CheatSheets</span>
                        <div class="metric-icon icon-blue-soft">
                            <i class="fa-solid fa-file-code"></i>
                        </div>
                    </div>
                    <div class="metric-big-val">${totalCheatSheets}</div>
                    <div class="metric-subtext">
                        <i class="fa-solid fa-arrow-trend-up" style="color: var(--accent-emerald);"></i> Active database records
                    </div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-title">PDF Intelligence</span>
                        <div class="metric-icon icon-rose-soft">
                            <i class="fa-solid fa-file-pdf"></i>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet/pdf" target="_blank" class="link-trigger link-rose">
                            <i class="fa-solid fa-download"></i> Download PDF
                        </a>
                    </div>
                    <div class="metric-subtext">JasperReports compiled PDF</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-title">Excel Data Matrix</span>
                        <div class="metric-icon icon-emerald-soft">
                            <i class="fa-solid fa-file-excel"></i>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet/excel" class="link-trigger link-emerald">
                            <i class="fa-solid fa-download"></i> Download XLSX
                        </a>
                    </div>
                    <div class="metric-subtext">Full raw data spreadsheet</div>
                </div>

                <div class="metric-card">
                    <div class="metric-top">
                        <span class="metric-title">Timestamp</span>
                        <div class="metric-icon icon-amber-soft">
                            <i class="fa-regular fa-clock"></i>
                        </div>
                    </div>
                    <div style="font-size: 15px; font-weight: 700; color: var(--text-main); font-family: 'JetBrains Mono', monospace;">
                        ${reportTime}
                    </div>
                    <div class="metric-subtext"><i class="fa-solid fa-rotate-right"></i> Auto synchronized</div>
                </div>
            </div>

            <!-- Data Matrix Table -->
            <div class="matrix-card">
                <div class="matrix-header">
                    <div class="matrix-header-title">
                        <i class="fa-solid fa-table-cells"></i>
                        <span>CheatSheets Data Matrix</span>
                    </div>
                    <div class="records-counter">
                        Showing ${startItem}-${endItem} of ${totalItems} CheatSheets
                    </div>
                </div>

                <table class="data-table" id="reportDataTable">
                    <thead>
                        <tr>
                            <th style="width: 80px;">RANK</th>
                            <th>CHEATSHEET TITLE</th>
                            <th>CREATOR USER</th>
                            <th>CREATED DATE</th>
                            <th style="width: 160px; text-align: center;">REACTION COUNT</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${reportData}">
                            <tr>
                                <td>
                                    <span class="rank-badge ${item.no == 1 ? 'rank-top1' : (item.no == 2 ? 'rank-top2' : (item.no == 3 ? 'rank-top3' : ''))}">
                                        #${item.no}
                                    </span>
                                </td>
                                <td>
                                    <div class="post-title-cell">
                                        <i class="fa-solid fa-file-lines"></i>
                                        <span><c:out value="${item.title}" /></span>
                                    </div>
                                </td>
                                <td>
                                    <div class="author-badge">
                                        <div class="author-avatar">
                                            <c:out value="${item.author != null && item.author.length() > 0 ? item.author.substring(0, 1).toUpperCase() : 'U'}" />
                                        </div>
                                        <span><c:out value="${item.author}" /></span>
                                    </div>
                                </td>
                                <td>
                                    <span class="date-code"><c:out value="${item.formattedCreatedDate}" /></span>
                                </td>
                                <td style="text-align: center;">
                                    <span class="reaction-pill">
                                        <i class="fa-solid fa-fire"></i> ${item.like_count}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty reportData}">
                            <tr>
                                <td colspan="5" class="no-records">
                                    <i class="fa-solid fa-folder-open" style="font-size: 24px; margin-bottom: 8px; display: block;"></i>
                                    No CheatSheets records found in database.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>

                <!-- Pagination Bar (Splits every 10 items) -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Page <strong>${currentPage}</strong> of <strong>${totalPages}</strong>
                    </div>
                    <div class="pagination-controls">
                        <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet?page=${currentPage - 1}&pageSize=${pageSize}" 
                           class="page-btn ${currentPage <= 1 ? 'disabled' : ''}">
                            <i class="fa-solid fa-chevron-left"></i> Prev
                        </a>

                        <c:forEach var="p" begin="1" end="${totalPages}">
                            <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet?page=${p}&pageSize=${pageSize}" 
                               class="page-btn ${p == currentPage ? 'active' : ''}">
                                ${p}
                            </a>
                        </c:forEach>

                        <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet?page=${currentPage + 1}&pageSize=${pageSize}" 
                           class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}">
                            Next <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        function filterTable() {
            var input = document.getElementById("filterInput");
            var filter = input.value.toUpperCase();
            var table = document.getElementById("reportDataTable");
            var tr = table.getElementsByTagName("tr");

            for (var i = 1; i < tr.length; i++) {
                var show = false;
                var tdArray = tr[i].getElementsByTagName("td");
                for (var j = 0; j < tdArray.length; j++) {
                    if (tdArray[j]) {
                        var txtValue = tdArray[j].textContent || tdArray[j].innerText;
                        if (txtValue.toUpperCase().indexOf(filter) > -1) {
                            show = true;
                            break;
                        }
                    }
                }
                tr[i].style.display = show ? "" : "none";
            }
        }
    </script>
</body>
</html>