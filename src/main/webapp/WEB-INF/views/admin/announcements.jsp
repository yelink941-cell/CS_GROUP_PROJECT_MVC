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
    <title>Event Announcements Broadcast - Admin Panel</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
    
    <!-- ✅ Admin CSS for sidebar -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    
    <style>
        /* ============================================
           ANNOUNCEMENTS PAGE STYLES (Keep as is)
           ============================================ */
        
        /* Flash Alerts */
        .alert-flash {
            padding: 16px 24px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-success { background: #d1fae5; color: #065f46; border: 1px solid #a7f3d0; }
        .alert-error { background: #ffe4e6; color: #9f1239; border: 1px solid #fecdd3; }

        /* Form Card */
        .form-card {
            background: var(--panel-bg, #ffffff);
            border-radius: 20px;
            border: 1px solid var(--panel-border, #e2e8f0);
            padding: 32px;
            margin-bottom: 36px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03);
        }

        .form-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--panel-border, #e2e8f0);
        }
        .form-header h2 { font-size: 20px; font-weight: 800; color: #0f172a; }
        .form-header i { font-size: 22px; color: #0284c7; }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group { display: flex; flex-direction: column; gap: 8px; }
        .form-group.full-width { grid-column: span 2; }
        
        .form-label {
            font-size: 13px;
            font-weight: 700;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .form-input, .form-select, .form-textarea {
            padding: 12px 16px;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            background: #f8fafc;
            color: #0f172a;
            font-size: 14px;
            outline: none;
            transition: all 0.2s ease;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            background: #ffffff;
            border-color: #0284c7;
            box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.15);
        }
        .form-textarea { resize: vertical; min-height: 100px; }

        .btn-broadcast {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 28px;
            border-radius: 12px;
            background: linear-gradient(135deg, #0284c7, #4f46e5);
            color: white;
            font-size: 15px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            transition: all 0.25s ease;
            box-shadow: 0 4px 14px rgba(2, 132, 199, 0.3);
        }
        .btn-broadcast:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(2, 132, 199, 0.4);
        }

        /* History Table Card */
        .matrix-card { 
            background: #ffffff; 
            border-radius: 20px; 
            border: 1px solid #e2e8f0; 
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03); 
            overflow: hidden; 
        }
        
        .matrix-header {
            padding: 22px 28px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .matrix-header-title { font-size: 17px; font-weight: 700; color: #0f172a; display: flex; align-items: center; gap: 10px; }
        .matrix-header-title i { color: #0284c7; }

        .data-table { width: 100%; border-collapse: collapse; text-align: left; }
        .data-table th { 
            padding: 18px 28px; 
            font-size: 12px; 
            font-weight: 700; 
            color: #475569; 
            text-transform: uppercase; 
            letter-spacing: 0.5px; 
            border-bottom: 2px solid #e2e8f0; 
            background: #f8fafc;
        }
        .data-table td { 
            padding: 20px 28px; 
            border-bottom: 1px solid #e2e8f0; 
            font-size: 14px; 
            color: #0f172a; 
            vertical-align: middle; 
        }

        .type-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }
        .type-event { background: #d1fae5; color: #065f46; }
        .type-announcement { background: #e0f2fe; color: #0369a1; }
        .type-system { background: #fef3c7; color: #92400e; }
        .type-maintenance { background: #ffe4e6; color: #9f1239; }

        .btn-delete {
            background: #ffe4e6;
            color: #e11d48;
            border: 1px solid #fecdd3;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-delete:hover { background: #fecdd3; }

        .no-records { padding: 40px; text-align: center; color: #64748b; font-style: italic; }
        
        /* Content Area */
        .content-area { padding: 30px 35px; max-width: 1400px; width: 100%; margin: 0 auto; }
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
    String displayRole = (currentUser != null) ? currentUser.getRole().name() : "ADMIN";
    String userInitial = displayUsername.substring(0, 1).toUpperCase();
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
                <a href="${pageContext.request.contextPath}/admin/announcements" class="sidebar-link active">
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
        <!-- Top Navbar -->
        <header class="top-navbar">
            <div class="nav-title">📢 Event Announcements</div>
            <div class="user-profile-badge">
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <!-- Main Content Area -->
        <main class="content-area">
            <c:if test="${not empty successMessage}">
                <div class="alert-flash alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    <span>${successMessage}</span>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert-flash alert-error">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                    <span>${errorMessage}</span>
                </div>
            </c:if>

            <!-- Event Form Card -->
            <div class="form-card">
                <div class="form-header">
                    <i class="fa-solid fa-paper-plane"></i>
                    <h2>Compose Event Announcement & Broadcast</h2>
                </div>

                <form action="${pageContext.request.contextPath}/admin/announcements/broadcast" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">Event / Announcement Title *</label>
                            <input type="text" name="title" class="form-input" placeholder="e.g. Annual Hackathon 2026 / System Update" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Announcement Type *</label>
                            <select name="type" class="form-select" required>
                                <option value="EVENT">🎉 EVENT (Event Announcement)</option>
                                <option value="ANNOUNCEMENT">📢 ANNOUNCEMENT (General Notice)</option>
                                <option value="SYSTEM">🔔 SYSTEM (System Alert)</option>
                                <option value="MAINTENANCE">🛠️ MAINTENANCE (Platform Maintenance)</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Event Date & Time (Optional)</label>
                            <input type="datetime-local" name="eventDate" class="form-input">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Action URL / Reference Link (Optional)</label>
                            <input type="url" name="actionUrl" class="form-input" placeholder="e.g. https://cheatsheet.com/events/hackathon">
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label">Event Description & Broadcast Message *</label>
                            <textarea name="content" class="form-textarea" placeholder="Provide full details about the event, schedule, instructions, etc." required></textarea>
                        </div>
                    </div>

                    <button type="submit" class="btn-broadcast">
                        <i class="fa-solid fa-paper-plane"></i> Broadcast Event Notification to All Users
                    </button>
                </form>
            </div>

            <!-- Sent Announcements Log Table -->
            <div class="matrix-card">
                <div class="matrix-header">
                    <div class="matrix-header-title">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        <span>Broadcast History & Announcement Logs</span>
                    </div>
                </div>

                <table class="data-table">
                    <thead>
                        <tr>
                            <th>TYPE</th>
                            <th>TITLE & EVENT DETAILS</th>
                            <th>EVENT DATE</th>
                            <th>PUBLISHED DATE</th>
                            <th style="width: 100px; text-align: center;">ACTION</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${announcements}">
                            <tr>
                                <td>
                                    <span class="type-badge ${item.type == 'EVENT' ? 'type-event' : (item.type == 'ANNOUNCEMENT' ? 'type-announcement' : (item.type == 'SYSTEM' ? 'type-system' : 'type-maintenance'))}">
                                        <c:choose>
                                            <c:when test="${item.type == 'EVENT'}">🎉 EVENT</c:when>
                                            <c:when test="${item.type == 'ANNOUNCEMENT'}">📢 NOTICE</c:when>
                                            <c:when test="${item.type == 'SYSTEM'}">🔔 SYSTEM</c:when>
                                            <c:otherwise>🛠️ MAINTENANCE</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>
                                    <strong style="color: #0f172a; font-size: 15px;"><c:out value="${item.title}" /></strong>
                                    <div style="font-size: 13px; color: #475569; margin-top: 4px;"><c:out value="${item.content}" /></div>
                                    <c:if test="${not empty item.actionUrl}">
                                        <a href="${item.actionUrl}" target="_blank" style="font-size: 12px; color: #0284c7; margin-top: 4px; display: inline-block;">
                                            <i class="fa-solid fa-link"></i> <c:out value="${item.actionUrl}" />
                                        </a>
                                    </c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.eventDate}">
                                            <span style="font-family: 'JetBrains Mono', monospace; font-size: 12px; background: #f1f5f9; padding: 4px 8px; border-radius: 6px;">
                                                ${item.eventDate}
                                            </span>
                                        </c:when>
                                        <c:otherwise><span style="color: #64748b;">-</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span style="font-size: 13px; color: #64748b;">${item.createdAt}</span>
                                </td>
                                <td style="text-align: center;">
                                    <form action="${pageContext.request.contextPath}/admin/announcements/${item.id}/delete" method="post" style="display: inline;" onsubmit="return confirm('Delete this announcement log?');">
                                        <button type="submit" class="btn-delete">
                                            <i class="fa-solid fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty announcements}">
                            <tr>
                                <td colspan="5" class="no-records">No broadcast announcements sent yet.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

</body>
</html>