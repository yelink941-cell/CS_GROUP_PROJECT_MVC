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
    <title>CheatSheet Analytics & Reporting Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* ============================================
           REPORT PAGE ADDITIONAL STYLES
           ============================================ */
        
        /* Hero Banner */
        .hero-banner { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 30px; 
            background: #ffffff;
            border: 1px solid #e2e8f0;
            padding: 28px 32px;
            border-radius: 16px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03);
            border-left: 6px solid #0284c7;
        }
        .hero-title { 
            font-size: 24px; 
            font-weight: 700; 
            color: #1e293b;
            letter-spacing: -0.5px; 
        }
        .hero-subtitle { font-size: 14px; color: #64748b; margin-top: 4px; }
        
        .action-group { display: flex; gap: 14px; flex-wrap: wrap; }
        .btn-glow { 
            display: inline-flex; 
            align-items: center; 
            gap: 10px; 
            padding: 10px 20px; 
            border-radius: 10px; 
            font-size: 14px; 
            font-weight: 600; 
            text-decoration: none; 
            border: none; 
            cursor: pointer; 
            transition: all 0.25s ease; 
        }
        .btn-pdf-glow { 
            background: #ef4444; 
            color: white; 
            box-shadow: 0 4px 14px rgba(239, 68, 68, 0.25); 
        }
        .btn-pdf-glow:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(239, 68, 68, 0.35); 
        }
        .btn-excel-glow { 
            background: #10b981; 
            color: white; 
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.25); 
        }
        .btn-excel-glow:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 6px 20px rgba(16, 185, 129, 0.35); 
        }

        /* Analytics Metric Cards */
        .metrics-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .metric-card { 
            background: #ffffff; 
            padding: 20px 24px; 
            border-radius: 12px; 
            border: 1px solid #e2e8f0; 
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.03);
            transition: all 0.25s ease;
        }
        .metric-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 16px -4px rgba(0, 0, 0, 0.06);
        }
        .metric-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; }
        .metric-title { font-size: 13px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }
        .metric-icon { 
            width: 40px; 
            height: 40px; 
            border-radius: 10px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 18px; 
        }
        .icon-blue-soft { background: #e0f2fe; color: #0284c7; }
        .icon-rose-soft { background: #ffe4e6; color: #e11d48; }
        .icon-emerald-soft { background: #d1fae5; color: #059669; }
        .icon-amber-soft { background: #fef3c7; color: #d97706; }
        
        .metric-big-val { font-size: 28px; font-weight: 800; color: #1e293b; letter-spacing: -1px; }
        .metric-subtext { font-size: 12px; color: #64748b; margin-top: 4px; }
        
        .link-trigger {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            padding: 4px 12px;
            border-radius: 6px;
            transition: all 0.2s;
        }
        .link-rose { background: #ffe4e6; color: #e11d48; border: 1px solid #fecdd3; }
        .link-rose:hover { background: #fecdd3; }
        .link-emerald { background: #d1fae5; color: #059669; border: 1px solid #a7f3d0; }
        .link-emerald:hover { background: #a7f3d0; }

        /* Data Matrix Table Card */
        .matrix-card { 
            background: #ffffff; 
            border-radius: 16px; 
            border: 1px solid #e2e8f0; 
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.03);
            overflow: hidden; 
        }
        
        .matrix-header {
            padding: 18px 24px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ffffff;
            flex-wrap: wrap;
            gap: 10px;
        }
        .matrix-header-title {
            font-size: 16px;
            font-weight: 700;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .matrix-header-title i { color: #0284c7; }
        .records-counter {
            font-size: 13px;
            color: #475569;
            background: #f1f5f9;
            padding: 4px 14px;
            border-radius: 20px;
            font-weight: 600;
        }

        /* Table Styling */
        .data-table { width: 100%; border-collapse: collapse; text-align: left; }
        .data-table th { 
            padding: 14px 24px; 
            font-size: 12px; 
            font-weight: 700; 
            color: #475569; 
            text-transform: uppercase; 
            letter-spacing: 0.5px; 
            border-bottom: 2px solid #e2e8f0; 
            background: #f8fafc;
        }
        .data-table td { 
            padding: 16px 24px; 
            border-bottom: 1px solid #e2e8f0; 
            font-size: 14px; 
            color: #1e293b; 
            vertical-align: middle; 
            transition: background 0.15s;
        }
        .data-table tr:hover td { background: #f8fafc; }

        .rank-badge {
            width: 30px;
            height: 30px;
            border-radius: 6px;
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

        .post-title-cell { font-weight: 600; color: #1e293b; display: flex; align-items: center; gap: 10px; }
        .post-title-cell i { color: #0284c7; font-size: 14px; }
        
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
            color: #0284c7;
        }

        .date-code { 
            font-family: 'Courier New', monospace; 
            font-size: 12px; 
            color: #475569; 
            background: #f1f5f9;
            padding: 4px 10px;
            border-radius: 6px;
            border: 1px solid #e2e8f0;
        }

        .reaction-pill { 
            display: inline-flex; 
            align-items: center; 
            gap: 6px;
            padding: 4px 14px; 
            border-radius: 20px; 
            font-weight: 700; 
            font-size: 13px; 
            background: #e0f2fe;
            color: #0284c7;
        }

        /* Pagination Bar */
        .pagination-container {
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #ffffff;
            border-top: 1px solid #e2e8f0;
            flex-wrap: wrap;
            gap: 10px;
        }
        .pagination-info { font-size: 13px; color: #475569; }
        
        .pagination-controls { display: flex; gap: 6px; flex-wrap: wrap; }
        .page-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 34px;
            height: 34px;
            padding: 0 12px;
            border-radius: 8px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            color: #1e293b;
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
            background: #0284c7;
            border-color: #0284c7;
            color: white;
            box-shadow: 0 2px 8px rgba(2, 132, 199, 0.3);
        }
        .page-btn.disabled {
            opacity: 0.4;
            cursor: not-allowed;
            pointer-events: none;
        }

        .no-records { padding: 40px; text-align: center; color: #64748b; font-style: italic; }

        /* Responsive */
        @media (max-width: 1024px) {
            .metrics-grid {
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
            .metrics-grid {
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
            .hero-banner {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            .action-group {
                justify-content: center;
            }
            .data-table {
                min-width: 700px;
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
            .hero-title {
                font-size: 20px;
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

     <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin Panel 👑</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ">
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
                <a href="${pageContext.request.contextPath}/admin/announcements" class="sidebar-link ">
                    <span>&#128364; Event Announcements</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link active">
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
            <div class="nav-title">📊 CheatSheet Analytics</div>
            <div class="user-profile-badge">
               
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

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
                        <i class="fa-solid fa-arrow-trend-up" style="color: #059669;"></i> Active database records
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
                    <div style="font-size: 15px; font-weight: 700; color: #1e293b; font-family: 'Courier New', monospace;">
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

                <!-- Pagination Bar -->
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

</body>
</html>