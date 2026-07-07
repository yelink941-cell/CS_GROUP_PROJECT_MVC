<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Portal - Chat Support</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .admin-chat-split-container {
            display: flex;
            flex: 1;
            overflow: hidden;
            background: #ffffff;
            height: calc(100vh - 70px);
        }

        /* Left Pane (Inbox List) */
        .admin-inbox-panel {
            width: 350px;
            border-right: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            background: #ffffff;
            flex-shrink: 0;
        }

        .search-container {
            padding: 16px;
            border-bottom: 1px solid #e2e8f0;
            position: relative;
            background: #ffffff;
        }
        .search-container input {
            width: 100%;
            padding: 10px 14px 10px 38px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            font-size: 14px;
            outline: none;
            background: #f8fafc;
            transition: all 0.25s ease;
        }
        .search-container input:focus {
            border-color: #3b82f6;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
        }
        .search-icon {
            position: absolute;
            left: 28px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 14px;
            color: #94a3b8;
            pointer-events: none;
        }
        .search-results {
            position: absolute;
            left: 16px;
            right: 16px;
            top: calc(100% - 8px);
            background: #ffffff;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            z-index: 100;
            display: none;
            max-height: 255px;
            overflow-y: auto;
        }
        .search-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 14px;
            cursor: pointer;
            border-bottom: 1px solid #f1f5f9;
            transition: background 0.15s;
        }
        .search-item:hover {
            background: #f8fafc;
        }
        .badge-admin, .badge-user {
            font-size: 10px;
            font-weight: 600;
            padding: 2px 6px;
            border-radius: 4px;
            margin-left: 6px;
        }
        .badge-admin { background: #fee2e2; color: #dc2626; }
        .badge-user { background: #dbeafe; color: #2563eb; }

        .inbox-list {
            flex: 1;
            overflow-y: auto;
        }
        .chat-row {
            display: flex;
            align-items: center;
            border-bottom: 1px solid #f1f5f9;
            position: relative;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .chat-row:hover {
            background: #f8fafc;
        }
        .chat-row.active {
            background: #eff6ff;
            border-left: 4px solid #2563eb;
        }
        .chat-row-link {
            flex: 1;
            min-width: 0;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 14px 16px;
            text-decoration: none;
            color: inherit;
        }
        .chat-row-side {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            justify-content: center;
            padding-right: 14px;
            gap: 6px;
            flex-shrink: 0;
        }
        .chat-menu-btn {
            background: none;
            border: none;
            color: #94a3b8;
            font-size: 18px;
            cursor: pointer;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }
        .chat-menu-btn:hover, .chat-menu-btn.active {
            background: #e2e8f0;
            color: #475569;
        }

        /* Avatar & online status styling */
        .avatar-wrap { position: relative; display: inline-flex; flex-shrink: 0; }
        .avatar {
            width: 46px;
            height: 46px;
            border-radius: 50%;
            background: #dfe5e7;
            color: #475569;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
            flex-shrink: 0;
            box-shadow: inset 0 0 0 1px rgba(0,0,0,0.05);
        }
        .avatar.group {
            background: #0f172a;
            color: #ffffff;
        }
        .status-dot-avatar {
            position: absolute;
            bottom: 1px;
            right: 1px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid #ffffff;
            background-color: #cbd5e1;
        }
        .status-dot-avatar.online {
            background-color: #22c55e;
        }
        .unread-badge {
            background-color: #2563eb;
            color: white;
            font-size: 11px;
            font-weight: 700;
            min-width: 18px;
            height: 18px;
            border-radius: 9px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0 5px;
            flex-shrink: 0;
            box-shadow: 0 2px 4px rgba(37,99,235,0.2);
        }

        /* Right Pane (Chat Room) */
        .admin-room-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #f8fafc;
            position: relative;
        }

        .no-chat-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #64748b;
            text-align: center;
            padding: 40px;
        }
        .no-chat-placeholder .icon {
            font-size: 64px;
            margin-bottom: 20px;
            animation: bounce 2s infinite;
        }

        .active-chat-interface {
            display: none;
            flex-direction: column;
            height: 100%;
        }

        .chat-room-header {
            background: #0f172a;
            padding: 14px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: white;
            flex-shrink: 0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .header-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: #38bdf8;
            color: #0f172a;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
            flex-shrink: 0;
        }
        .header-dropdown-item {
            width: 100%;
            padding: 10px 14px;
            text-align: left;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            color: #1e293b;
        }
        .header-dropdown-item:hover {
            background: #f1f5f9;
        }
        .header-dropdown-item.danger {
            color: #ef4444;
        }
        .header-dropdown-item.danger:hover {
            background: #fef2f2;
        }

        .chat-messages-box {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        /* Message Bubble Styles */
        .message-row {
            display: flex;
            width: 100%;
            gap: 8px;
        }
        .message-row.me {
            justify-content: flex-end;
        }
        .message-row.other {
            justify-content: flex-start;
        }
        .bubble {
            max-width: 65%;
            padding: 10px 14px;
            border-radius: 16px;
            font-size: 14px;
            line-height: 1.5;
            position: relative;
            box-shadow: 0 1px 2px rgba(15, 23, 42, 0.05);
            display: flex;
            flex-direction: column;
            cursor: pointer;
            transition: transform 0.15s ease;
        }
        .bubble:hover {
            transform: scale(1.01);
        }
        .bubble.me {
            background: #2563eb;
            color: #ffffff;
            border-bottom-right-radius: 4px;
        }
        .bubble.other {
            background: #ffffff;
            color: #1e293b;
            border-bottom-left-radius: 4px;
            border: 1px solid #e2e8f0;
        }
        .bubble-meta {
            display: flex;
            justify-content: space-between;
            font-size: 11px;
            margin-bottom: 4px;
            opacity: 0.8;
            font-weight: 600;
        }
        .bubble.me .bubble-meta {
            color: rgba(255, 255, 255, 0.9);
        }
        .bubble.other .bubble-meta {
            color: #64748b;
        }
        .bubble-text {
            word-break: break-word;
            white-space: pre-wrap;
        }
        .bubble-time {
            font-size: 10px;
            margin-top: 6px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 4px;
            opacity: 0.75;
        }
        .bubble.me .bubble-time {
            color: rgba(255, 255, 255, 0.8);
        }
        .bubble.other .bubble-time {
            color: #64748b;
        }
        .edited-label {
            font-style: italic;
            font-size: 9px;
        }
        .read-receipt {
            font-weight: bold;
        }
        .reply-preview {
            background: rgba(0,0,0,0.06);
            border-left: 3px solid currentColor;
            padding: 6px 10px;
            border-radius: 4px;
            margin-bottom: 6px;
            font-size: 12px;
            font-style: italic;
            text-overflow: ellipsis;
            overflow: hidden;
            white-space: nowrap;
        }
        .bubble.me .reply-preview {
            background: rgba(255,255,255,0.15);
        }

        /* Context Menu Styles */
        .msg-context-menu {
            position: fixed;
            z-index: 9999;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
            min-width: 180px;
            display: none;
            overflow: hidden;
            flex-direction: column;
        }
        .msg-context-menu.active {
            display: flex;
        }
        .msg-context-menu button {
            background: none;
            border: none;
            width: 100%;
            text-align: left;
            padding: 10px 16px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: background 0.15s;
        }
        .msg-context-menu button:hover {
            background: #f1f5f9;
        }
        .msg-context-menu button.danger {
            color: #ef4444;
        }
        .msg-context-menu button.danger:hover {
            background: #fef2f2;
        }
        .msg-context-backdrop, .chat-list-menu-backdrop, #headerDropdownBackdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 9998;
            background: transparent;
            display: none;
        }
        .msg-context-backdrop.active, .chat-list-menu-backdrop.active, #headerDropdownBackdrop.active {
            display: block;
        }

        /* Inbox Row Menu Styles */
        .chat-list-menu {
            position: fixed;
            z-index: 9999;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            min-width: 160px;
            display: none;
            overflow: hidden;
            flex-direction: column;
        }
        .chat-list-menu.active {
            display: flex;
        }
        .chat-list-menu button {
            background: none;
            border: none;
            width: 100%;
            text-align: left;
            padding: 10px 14px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .chat-list-menu button:hover {
            background: #f1f5f9;
        }
        .chat-list-menu button.danger {
            color: #ef4444;
        }
        .chat-list-menu button.danger:hover {
            background: #fef2f2;
        }
        .menu-divider {
            height: 1px;
            background: #e2e8f0;
            margin: 4px 0;
        }

        /* Lightbox Image Preview Modal */
        .image-lightbox-modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(15, 23, 42, 0.95);
            align-items: center;
            justify-content: center;
        }
        .lightbox-content {
            max-width: 90%;
            max-height: 90%;
            border-radius: 8px;
            object-fit: contain;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
        }
        .lightbox-close {
            position: absolute;
            top: 30px;
            right: 40px;
            color: #fff;
            font-size: 44px;
            font-weight: 300;
            cursor: pointer;
            user-select: none;
            transition: opacity 0.2s;
        }
        .lightbox-close:hover { opacity: 0.7; }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        /* Clean Minimalist Input Area */
        .chat-room-footer {
            background: #ffffff;
            padding: 14px 20px;
            display: flex;
            align-items: flex-end;
            gap: 12px;
            border-top: 1px solid #e2e8f0;
            flex-shrink: 0;
            box-sizing: border-box;
        }

        #messageText {
            flex: 1;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            padding: 10px 14px;
            font-size: 14px;
            line-height: 1.5;
            min-height: 42px;
            max-height: 120px;
            resize: none;
            outline: none;
            background: #f8fafc;
            color: #1e293b;
            transition: all 0.2s ease;
            font-family: inherit;
            box-sizing: border-box;
        }

        #messageText:focus {
            border-color: #2563eb;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
        }

        #btnAttach, #btnSend {
            width: 42px;
            height: 42px;
            border: none;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
            box-sizing: border-box;
        }

        #btnAttach {
            background: transparent;
            border: 1px solid #cbd5e1;
            color: #64748b;
        }

        #btnAttach:hover {
            background: #f1f5f9;
            color: #1e293b;
            border-color: #94a3b8;
        }

        #btnSend {
            background: #2563eb;
            color: #ffffff;
            font-size: 18px;
            box-shadow: 0 2px 4px rgba(37, 99, 235, 0.2);
        }

        #btnSend:hover {
            background: #1d4ed8;
            box-shadow: 0 4px 6px rgba(37, 99, 235, 0.3);
        }

        #btnSend:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            box-shadow: none;
        }

        #replyBar, #attachmentBar {
            display: none;
            align-items: center;
            justify-content: space-between;
            padding: 8px 20px;
            background: #f1f5f9;
            border-top: 1px solid #e2e8f0;
            border-bottom: 1px solid #e2e8f0;
            flex-shrink: 0;
            box-sizing: border-box;
        }

        #typingIndicator {
            display: none;
            padding: 6px 20px;
            font-size: 12px;
            color: #64748b;
            font-style: italic;
            background: transparent;
            flex-shrink: 0;
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
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <span>👥 User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/announcements" class="sidebar-link">
                    <span>📢 Event Announcements</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link">
                    <span>📄 CheatSheet Report</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link">
                    <span>📊 Report Logs</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/chat" class="sidebar-link active">
                    <span>💬 Chat / Messages</span>
                </a>
            </li>
        </ul>
    </aside>

    <div class="main-workspace" style="display: flex; flex-direction: column; height: 100vh; overflow: hidden; background: #ffffff;">
        <header class="top-navbar" style="flex-shrink: 0;">
            <div class="nav-title">💬 Admin Support Center</div>
            <div class="user-profile-badge">
                <a href="${pageContext.request.contextPath}/" class="btn-logout">🏠 Home</a>
                <span>Welcome, <strong><%= displayUsername %></strong></span>
                <span class="badge"><%= displayRole %></span>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Sign Out</a>
            </div>
        </header>

        <div class="admin-chat-split-container">
            <!-- Left Pane: Inbox List -->
            <div class="admin-inbox-panel">
                <div class="search-container">
                    <input type="text" id="searchInput" placeholder="Search users to chat..." autocomplete="off">
                    <span class="search-icon">🔍</span>
                    <div id="searchResults" class="search-results"></div>
                </div>

                <div class="inbox-list" id="chatList">
                    <!-- Inbox Items rendered via JSTL initially -->
                    <c:forEach var="item" items="${inboxItems}">
                        <div class="chat-row" id="row-${item.conversationId}" 
                             data-conversation-id="${item.conversationId}"
                             data-is-group="${item.group}"
                             data-partner-id="${item.partnerUserId}"
                             data-blocked-by-me="${item.blockedByMe}"
                             data-partner-name="${item.displayName}">
                            <div class="chat-row-link" onclick="selectChat(${item.conversationId})">
                                <div class="avatar-wrap">
                                    <div class="avatar ${item.group ? 'group' : ''}">
                                        <c:choose>
                                            <c:when test="${not empty item.displayName}">
                                                ${item.displayName.toUpperCase().charAt(0)}
                                            </c:when>
                                            <c:otherwise>U</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <c:if test="${not item.group}">
                                        <span class="status-dot-avatar ${item.partnerOnline ? 'online' : 'offline'}" title="${item.partnerOnline ? 'Online' : item.partnerLastSeenFormatted}"></span>
                                    </c:if>
                                </div>
                                <div style="flex: 1; min-width: 0;">
                                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">
                                        <strong style="font-size:14px; font-weight:600; color:#1e293b; text-overflow:ellipsis; overflow:hidden; white-space:nowrap;">
                                            <c:out value="${item.displayName}" />
                                        </strong>
                                        <span class="chat-time" style="font-size:11px; color:#64748b;"></span>
                                    </div>
                                    <div style="display:flex; justify-content:space-between; align-items:center;">
                                        <span class="chat-preview" style="font-size:12px; color:#64748b; text-overflow:ellipsis; overflow:hidden; white-space:nowrap; flex:1; margin-right:8px;">
                                            <c:out value="${item.lastMessagePreview}" />
                                        </span>
                                        <c:if test="${item.unreadCount > 0}">
                                            <span class="unread-badge">
                                                <c:choose>
                                                    <c:when test="${item.unreadCount > 99}">99+</c:when>
                                                    <c:otherwise>${item.unreadCount}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <div class="chat-row-side">
                                <button type="button" class="chat-menu-btn" onclick="handleChatRowMenu(event, ${item.conversationId}, this)">⋮</button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Right Pane: Active Chat Room -->
            <div class="admin-room-panel">
                <!-- Placeholder when no conversation is active -->
                <div class="no-chat-placeholder">
                    <div class="icon">💬</div>
                    <h3 style="margin: 0 0 8px 0; font-size: 20px; font-weight: 700; color: #1e293b;">No Conversation Selected</h3>
                    <p style="margin: 0; font-size: 14px; max-width: 340px; line-height: 1.6;">Select a chat from the inbox on the left, or search for a user to start a conversation.</p>
                </div>

                <!-- Active Chat Room Content -->
                <div class="active-chat-interface">
                    <div class="chat-room-header">
                        <div style="display: flex; align-items: center; gap: 12px; min-width: 0;">
                            <div class="header-avatar"></div>
                            <div style="min-width: 0;">
                                <div class="header-name" style="font-weight: 600; font-size: 15px; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;"></div>
                                <div class="header-status" style="font-size: 12px; color: #94a3b8; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">Offline</div>
                            </div>
                        </div>
                        <div style="position: relative;">
                            <button id="btnHeaderMenu" onclick="toggleHeaderDropdown()" style="background: none; border: none; color: white; font-size: 20px; cursor: pointer; padding: 4px 10px; border-radius: 50%;">⋮</button>
                            <div id="headerDropdown" style="display: none; position: absolute; right: 0; top: calc(100% + 8px); background: white; border: 1px solid #e2e8f0; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); z-index: 100; min-width: 160px; overflow: hidden;">
                                <button type="button" class="header-dropdown-item danger" id="btnDeleteChat" onclick="deleteChat()">
                                    <span style="font-size: 14px;">🗑</span> Delete Chat
                                </button>
                                <div class="menu-divider"></div>
                                <button type="button" class="header-dropdown-item" id="btnBlockUser" onclick="toggleBlockUser()">
                                    <span style="font-size: 14px;">🚫</span> Block User
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Scrollable Chat messages -->
                    <div id="chatBox" class="chat-messages-box"></div>

                    <!-- Typing indicator -->
                    <div id="typingIndicator"></div>

                    <!-- Reply context bar -->
                    <div id="replyBar">
                        <div style="display: flex; align-items: center; gap: 8px; min-width: 0;">
                            <span style="font-size: 14px; color: #64748b;">Reply to:</span>
                            <span id="replyBarText" style="font-size: 13px; font-weight: 500; color: #1e293b; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;"></span>
                        </div>
                        <button type="button" onclick="cancelReply()" style="background: none; border: none; color: #ef4444; font-size: 18px; cursor: pointer; font-weight: bold;">×</button>
                    </div>

                    <!-- Attachment preview bar -->
                    <div id="attachmentBar">
                        <div style="display: flex; align-items: center; gap: 8px; min-width: 0;">
                            <span style="font-size: 14px; color: #64748b;">Files:</span>
                            <span id="attachmentBarText" style="font-size: 13px; font-weight: 500; color: #1e293b; text-overflow: ellipsis; overflow: hidden; white-space: nowrap;"></span>
                        </div>
                        <button type="button" onclick="clearAttachments()" style="background: none; border: none; color: #ef4444; font-size: 18px; cursor: pointer; font-weight: bold;">×</button>
                    </div>

                    <!-- Input panel -->
                    <div class="chat-room-footer">
                        <button id="btnAttach" type="button" onclick="$('#fileInput').click()">📎</button>
                        <input type="file" id="fileInput" multiple style="display: none;" onchange="handleFileSelection(event)">
                        
                        <textarea id="messageText" placeholder="Write a message..." onkeydown="handleTextareaKeydown(event)" oninput="handleTextareaInput()"></textarea>
                        
                        <button id="btnSend" onclick="handleSend()">➔</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals & Context Menus -->
    <div id="imageLightbox" class="image-lightbox-modal">
        <span class="lightbox-close">&times;</span>
        <img class="lightbox-content" id="lightboxTargetImg" alt="Enlarged Image View">
    </div>

    <div id="msgContextMenu" class="msg-context-menu"></div>
    <div id="msgContextBackdrop" class="msg-context-backdrop"></div>

    <div id="chatListMenu" class="chat-list-menu"></div>
    <div id="chatListMenuBackdrop" class="chat-list-menu-backdrop"></div>
    <div id="headerDropdownBackdrop" onclick="closeHeaderDropdown()"></div>

<script>
    const ctx = '${pageContext.request.contextPath}';
    const myUserId = '<%= currentUser != null ? currentUser.getId() : "" %>';
    
    let activeChatId = null;
    let partnerUserId = null;
    let partnerDisplayName = null;
    let partnerRole = null;
    let isGroup = false;
    let canModerate = false;
    let blockedByMe = false;
    let blockedByPartner = false;
    let blockedEitherWay = false;
    let partnerOnline = false;
    
    let socket = null;
    let reconnectTimer = null;
    let searchTimer = null;
    let typingTimer = null;
    let isTyping = false;

    let replyToMessage = null;
    let editingMessageId = null;
    let contextMenuMessage = null;
    let activeChatRow = null;
    let selectedFiles = [];

    $(document).ready(function() {
        $.ajaxSetup({ cache: false });
        connectWebSocket();

        // Close search results or context menus when clicking outside
        $(document).click(function(e) {
            if (!$(e.target).closest('.search-container').length) {
                $('#searchResults').hide();
            }
            if (!$(e.target).closest('.chat-list-menu, .chat-menu-btn').length) {
                closeChatListMenu();
            }
            if (!$(e.target).closest('.msg-context-menu, .bubble').length) {
                closeMessageContextMenu();
            }
        });

        $('#searchInput').on('input', function() {
            clearTimeout(searchTimer);
            const q = $(this).val().trim();
            if (q.length < 1) {
                $('#searchResults').hide().empty();
                return;
            }
            searchTimer = setTimeout(function() { searchUsers(q); }, 250);
        });

        // Close image lightbox
        $('#imageLightbox, .lightbox-close').click(function() {
            $('#imageLightbox').hide();
            $('#lightboxTargetImg').attr('src', ''); 
        });

        // Click bubble to open context menu
        $(document).on('click', '.bubble', function(e) {
            if ($(e.target).closest('.bubble-media-container img, .bubble-media-container video').length) return;
            if ($(e.target).is('a, button, input, video')) return;
            var row = $(this).closest('.message-row');
            var msg = row.data('msg');
            if (msg) openMessageContextMenu(msg, this);
        });

        // Double click/Context actions
        $('#msgContextMenu').on('click', 'button', function(e) {
            e.stopPropagation();
            var action = $(this).data('action');
            var msg = contextMenuMessage;
            closeMessageContextMenu();
            if (!msg) return;

            if (action === 'reply') {
                startReply(msg);
            } else if (action === 'edit') {
                startEdit(msg);
            } else if (action === 'delete') {
                deleteMessage(msg);
            }
        });

        $('#chatListMenu').on('click', 'button', function(e) {
            e.stopPropagation();
            var action = $(this).data('action');
            var row = activeChatRow;
            closeChatListMenu();
            if (!row) return;

            if (action === 'delete') {
                deleteChatFromList(row);
            } else if (action === 'block') {
                blockUserFromList(row);
            } else if (action === 'unblock') {
                unblockUserFromList(row);
            }
        });

        // Escape keys
        $(document).keydown(function(e) {
            if (e.key === 'Escape') {
                closeChatListMenu();
                closeMessageContextMenu();
                closeHeaderDropdown();
                $('#imageLightbox').hide();
            }
        });

        // Check if there is an ?id=X parameter in the URL and auto select it
        const urlParams = new URLSearchParams(window.location.search);
        const autoSelectId = urlParams.get('id');
        if (autoSelectId) {
            selectChat(Number(autoSelectId));
        }
    });

    // -------------------------------------------------------------
    // Chat Selection & Room Loading
    // -------------------------------------------------------------
    function selectChat(conversationId) {
        if (activeChatId === conversationId) return;

        $('.chat-row').removeClass('active');
        $('#row-' + conversationId).addClass('active');

        activeChatId = conversationId;

        // Clear input states
        cancelReply();
        clearAttachments();
        cancelEdit();
        $('#typingIndicator').hide();

        // Clear unread badge in sidebar row
        $('#row-' + conversationId).find('.unread-badge').remove();

        // Load details via REST
        $.get(ctx + '/api/chat/room/details', { conversationId: conversationId }, function(room) {
            partnerUserId = room.partnerUserId;
            partnerRole = room.partnerRole;
            isGroup = room.group;
            canModerate = room.canModerate;
            blockedByMe = room.blockedByMe;
            blockedByPartner = room.blockedByPartner;
            blockedEitherWay = room.blockedEitherWay;
            partnerOnline = room.partnerOnline;
            partnerDisplayName = room.title;

            // Display components
            $('.no-chat-placeholder').hide();
            $('.active-chat-interface').css('display', 'flex');

            // Header UI populate
            $('.header-name').text(room.title);
            $('.header-avatar').text(room.title.charAt(0).toUpperCase());
            updateHeaderStatus(room.partnerOnline, room.partnerLastSeenFormatted);
            updateOptionsDropdown(room.blockedByMe, room.group);

            // Load history
            loadChatMessages(conversationId);
        }).fail(function(xhr) {
            alert('Could not open conversation: ' + xhr.responseText);
        });
    }

    function updateHeaderStatus(online, lastSeenFormatted) {
        if (isGroup) {
            $('.header-status').text('Group Chat');
            return;
        }
        if (online) {
            $('.header-status').text('Online').css('color', '#22c55e');
        } else {
            $('.header-status').text(lastSeenFormatted || 'Offline').css('color', '#94a3b8');
        }
    }

    function updateOptionsDropdown(blocked, group) {
        if (group) {
            $('#btnBlockUser').hide();
        } else {
            $('#btnBlockUser').show();
            if (blocked) {
                $('#btnBlockUser').html('<span style="font-size: 14px;">🔓</span> Unblock User');
            } else {
                $('#btnBlockUser').html('<span style="font-size: 14px;">🚫</span> Block User');
            }
        }
    }

    function loadChatMessages(conversationId) {
        $('#chatBox').html('<div style="text-align:center;padding:40px;color:#64748b;">Loading messages...</div>');
        $.ajax({
            url: ctx + '/api/chat/history',
            type: 'GET',
            data: { conversationId: conversationId },
            success: function(messages) {
                $('#chatBox').empty();
                if (messages.length === 0) {
                    $('#chatBox').html(
                        '<div id="emptyChat" style="text-align:center;padding:40px;color:#64748b;">No messages yet. Send a message to start! 👋</div>'
                    );
                } else {
                    messages.reverse().forEach(appendMessage);
                    scrollToBottom();
                    markReadUpTo(messages[messages.length - 1].id);
                }
            },
            error: function(xhr) {
                $('#chatBox').html('<div style="padding:20px;color:red;text-align:center;">❌ Failed to load messages: ' + xhr.responseText + '</div>');
            }
        });
    }

    // -------------------------------------------------------------
    // Messaging, Files & Typing
    // -------------------------------------------------------------
    function handleFileSelection(e) {
        var files = Array.from(e.target.files);
        if (files.length === 0) return;
        selectedFiles = files;
        
        var names = files.map(function(f) { return f.name; }).join(', ');
        $('#attachmentBarText').text(names);
        $('#attachmentBar').css('display', 'flex');
        $('#messageText').focus();
    }

    function clearAttachments() {
        selectedFiles = [];
        $('#fileInput').val('');
        $('#attachmentBar').hide();
        $('#attachmentBarText').text('');
    }

    function resetTextareaHeight() {
        const el = document.getElementById('messageText');
        if (el) {
            el.style.height = '42px';
        }
    }

    function handleTextareaInput() {
        if (!activeChatId || !socket || socket.readyState !== WebSocket.OPEN) return;
        
        if (!isTyping) {
            isTyping = true;
            socket.send(JSON.stringify({
                type: 'user_typing',
                conversationId: activeChatId,
                senderId: myUserId
            }));
        }
        
        clearTimeout(typingTimer);
        typingTimer = setTimeout(function() {
            isTyping = false;
            socket.send(JSON.stringify({
                type: 'user_stopped_typing',
                conversationId: activeChatId,
                senderId: myUserId
            }));
        }, 1500);

        // Auto-grow height
        const el = document.getElementById('messageText');
        if (el) {
            el.style.height = 'auto';
            el.style.height = (el.scrollHeight) + 'px';
        }
    }

    function handleTextareaKeydown(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            handleSend();
        }
    }

    function handleSend() {
        const text = $('#messageText').val().trim();
        if (editingMessageId) {
            submitEdit(text);
            return;
        }
        if (selectedFiles.length > 0) {
            sendMedia(text);
            return;
        }
        if (!text) return;

        sendTextFallback(text);
    }

    function sendTextFallback(text) {
        $('#btnSend').prop('disabled', true);
        $.ajax({
            url: ctx + '/api/chat/messages',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                conversationId: Number(activeChatId),
                text: text,
                parentMessageId: replyToMessage ? replyToMessage.id : null
            }),
            success: function() {
                $('#messageText').val('');
                resetTextareaHeight();
                cancelReply();
                $('#btnSend').prop('disabled', false);
            },
            error: function(xhr) {
                alert('Send failed: ' + xhr.responseText);
                $('#btnSend').prop('disabled', false);
            }
        });
    }

    function sendMedia(caption) {
        var chatId = activeChatId;
        if (!chatId || selectedFiles.length === 0) return;
        
        $('#btnSend').prop('disabled', true);
        
        var formData = new FormData();
        formData.append('conversationId', chatId);
        selectedFiles.forEach(function(file) { formData.append('files', file); });
        if (caption) formData.append('caption', caption);
        
        $.ajax({
            url: ctx + '/api/chat/messages/media',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function() {
                $('#messageText').val('');
                resetTextareaHeight();
                clearAttachments();
                $('#btnSend').prop('disabled', false);
            },
            error: function(xhr) {
                alert('Media upload failed: ' + xhr.responseText);
                $('#btnSend').prop('disabled', false);
            }
        });
    }

    function submitEdit(text) {
        if (!text) return;
        $.ajax({
            url: ctx + '/api/chat/messages/' + editingMessageId,
            type: 'PUT',
            contentType: 'application/json',
            data: JSON.stringify({ text: text }),
            success: function(updated) {
                updateMessageDom(updated);
                cancelEdit();
            },
            error: function(xhr) {
                alert('Edit failed: ' + xhr.responseText);
            }
        });
    }

    function startEdit(msg) {
        editingMessageId = msg.id;
        replyToMessage = null;
        $('#replyBar').removeClass('active');
        $('#messageText').val(msg.messageText || '').focus();
        $('#btnSend').text('✓');
    }

    function cancelEdit() {
        editingMessageId = null;
        $('#messageText').val('');
        resetTextareaHeight();
        $('#btnSend').text('➔');
    }

    function startReply(msg) {
        editingMessageId = null;
        replyToMessage = msg;
        $('#replyBarText').text(msg.messageText || 'Attachment');
        $('#replyBar').css('display', 'flex');
        $('#messageText').focus();
    }

    function cancelReply() {
        replyToMessage = null;
        $('#replyBar').hide();
        $('#replyBarText').text('');
    }

    // -------------------------------------------------------------
    // Context Menu & Actions
    // -------------------------------------------------------------
    function openMessageContextMenu(msg, anchorEl) {
        closeMessageContextMenu();
        contextMenuMessage = msg;
        var menu = $('#msgContextMenu');
        menu.empty();

        var quickBar = $('<div class="quick-reaction-bar" style="display:flex; justify-content:space-around; align-items:center; padding:8px 12px; border-bottom:1px solid #e2e8f0;"></div>');
        ['👍', '❤️', '😂', '😮', '😢', '🔥'].forEach(function(emoji) {
            var btn = $('<button type="button" class="reaction-btn" style="background:none; border:none; font-size:18px; cursor:pointer; padding:4px 6px; border-radius:6px; transition:transform 0.15s ease;"></button>')
                .text(emoji)
                .click(function(e) {
                    e.stopPropagation();
                    toggleReaction(msg.id, emoji);
                });
            quickBar.append(btn);
        });
        menu.append(quickBar);

        var isMe = String(msg.senderId) === String(myUserId);
        var hasText = msg.messageText && msg.messageText.trim().length > 0;
        
        // Reply option
        menu.append('<button type="button" data-action="reply"><span class="menu-icon">↩</span>Reply</button>');
        
        if (isMe) {
            if (hasText) {
                menu.append('<button type="button" data-action="edit"><span class="menu-icon">✎</span>Edit</button>');
            }
            menu.append('<div class="menu-divider"></div>');
            menu.append('<button type="button" data-action="delete" class="danger"><span class="menu-icon">🗑</span>Delete</button>');
        } else if (canModerate) {
            menu.append('<div class="menu-divider"></div>');
            menu.append('<button type="button" data-action="delete" class="danger"><span class="menu-icon">🗑</span>Delete</button>');
        }

        menu.addClass('active');
        var rect = anchorEl.getBoundingClientRect();
        var menuW = menu.outerWidth();
        var menuH = menu.outerHeight();
        var top = rect.top - menuH - 8;
        if (top < 8) top = rect.bottom + 8;
        var left = isMe ? rect.right - menuW : rect.left;
        left = Math.max(8, Math.min(left, window.innerWidth - menuW - 8));
        
        menu.css({ top: top + 'px', left: left + 'px' });
        $('#msgContextBackdrop').addClass('active');
    }

    function closeMessageContextMenu() {
        contextMenuMessage = null;
        $('#msgContextMenu').removeClass('active').empty();
        $('#msgContextBackdrop').removeClass('active');
    }

    function toggleReaction(messageId, emoji) {
        closeMessageContextMenu();
        $.ajax({
            url: ctx + '/api/chat/messages/' + messageId + '/reactions',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ emoji: emoji }),
            success: function(updatedMsg) {
                updateMessageReactions(updatedMsg);
            },
            error: function(xhr) {
                alert('Reaction failed: ' + xhr.responseText);
            }
        });
    }

    function updateMessageReactions(msg) {
        var row = $('#msg-' + msg.id);
        if (!row.length) return;
        row.data('msg', msg);
        var bubble = row.find('.bubble');
        bubble.find('.message-reactions').remove();
        if (msg.reactions && msg.reactions.length) {
            bubble.append(renderReactionsHtml(msg));
        }
    }

    function renderReactionsHtml(msg) {
        var reactionsContainer = $('<div class="message-reactions" style="display:flex; flex-wrap:wrap; gap:4px; margin-top:6px;"></div>');
        msg.reactions.forEach(function(r) {
            var userIds = (r.userIds || []).map(String);
            var uniqueUserIds = Array.from(new Set(userIds));
            var count = uniqueUserIds.length > 0 ? uniqueUserIds.length : (r.count || 1);
            var hasUserReacted = uniqueUserIds.includes(String(myUserId));
            
            var badge = $('<span class="reaction-badge" style="display:inline-flex; align-items:center; gap:3px; border-radius:12px; padding:2px 7px; font-size:12px; cursor:pointer; user-select:none; transition: all 0.2s;"></span>')
                .html(r.emoji + ' <span style="font-size:11px; opacity:0.9;">' + count + '</span>')
                .click(function(e) {
                    e.stopPropagation();
                    toggleReaction(msg.id, r.emoji);
                });
            if (hasUserReacted) {
                badge.css({
                    'background': 'rgba(56, 189, 248, 0.25)',
                    'border': '1px solid #38bdf8',
                    'color': '#0284c7'
                });
            } else {
                badge.css({
                    'background': 'rgba(15, 23, 42, 0.05)',
                    'border': '1px solid rgba(15, 23, 42, 0.1)',
                    'color': '#475569'
                });
            }
            reactionsContainer.append(badge);
        });
        return reactionsContainer;
    }

    function deleteMessage(msg) {
        if (!confirm('Are you sure you want to delete this message?')) return;
        $.ajax({
            url: ctx + '/api/chat/messages/' + msg.id,
            type: 'DELETE',
            error: function(xhr) { alert('Delete failed: ' + xhr.responseText); }
        });
    }

    function removeMessageDom(messageId) {
        $('#msg-' + messageId).fadeOut(200, function() { 
            $(this).remove(); 
            if ($('#chatBox').children().length === 0) {
                clearChatBox();
            }
        });
    }

    function updateMessageDom(msg) {
        const row = $('#msg-' + msg.id);
        if (!row.length) return;
        row.data('msg', msg);
        row.find('.bubble-text').text(msg.messageText || '');
        row.find('.edited-label').toggle(!!msg.edited);
        row.find('.reply-preview').remove();
        if (msg.parentMessagePreview) {
            row.find('.bubble').prepend('<div class="reply-preview">' + escapeHtml(msg.parentMessagePreview) + '</div>');
        }
    }

    function clearChatBox() {
        $('#chatBox').empty().html(
            '<div id="emptyChat" style="text-align:center;padding:40px;color:#64748b;">No messages yet. Send a message to start! 👋</div>'
        );
    }

    // -------------------------------------------------------------
    // Header dropdown Actions
    // -------------------------------------------------------------
    function toggleHeaderDropdown() {
        const dd = $('#headerDropdown');
        if (dd.css('display') === 'none') {
            dd.show();
            $('#headerDropdownBackdrop').addClass('active');
        } else {
            closeHeaderDropdown();
        }
    }

    function closeHeaderDropdown() {
        $('#headerDropdown').hide();
        $('#headerDropdownBackdrop').removeClass('active');
    }

    function deleteChat() {
        closeHeaderDropdown();
        if (!activeChatId) return;
        if (!confirm('Are you sure you want to delete this chat from your inbox?')) return;

        $.ajax({
            url: ctx + '/api/chat/conversations/' + activeChatId,
            type: 'DELETE',
            success: function() {
                // Delete active row, select next or clear
                const row = $('#row-' + activeChatId);
                row.remove();
                activeChatId = null;
                $('.active-chat-interface').hide();
                $('.no-chat-placeholder').show();
            },
            error: function(xhr) {
                alert('Chat delete failed: ' + xhr.responseText);
            }
        });
    }

    function toggleBlockUser() {
        closeHeaderDropdown();
        if (!partnerUserId) return;
        
        const confirmMsg = blockedByMe 
            ? 'Are you sure you want to unblock this user?' 
            : 'Are you sure you want to block this user?';
            
        if (!confirm(confirmMsg)) return;
        
        const urlPath = blockedByMe ? '/unblock' : '/block';
        
        $.ajax({
            url: ctx + '/api/chat/users/' + partnerUserId + urlPath,
            type: 'POST',
            success: function() {
                blockedByMe = !blockedByMe;
                updateOptionsDropdown(blockedByMe, isGroup);
                
                // Update inbox list row data-attribute
                $('#row-' + activeChatId).attr('data-blocked-by-me', blockedByMe);
            },
            error: function(xhr) {
                alert('Action failed: ' + xhr.responseText);
            }
        });
    }

    // -------------------------------------------------------------
    // Left panel Row Menu
    // -------------------------------------------------------------
    function handleChatRowMenu(event, conversationId, btnEl) {
        event.stopPropagation();
        closeChatListMenu();
        
        const row = $('#row-' + conversationId);
        activeChatRow = row;
        
        const groupVal = row.attr('data-is-group') === 'true' || row.data('is-group') === true;
        const partnerIdVal = row.attr('data-partner-id');
        const blockedVal = row.attr('data-blocked-by-me') === 'true' || row.data('blocked-by-me') === true;
        
        const menu = $('#chatListMenu').empty();
        menu.append('<button type="button" data-action="delete" class="danger"><span class="menu-icon">🗑</span>Delete chat</button>');
        
        if (!groupVal && partnerIdVal) {
            menu.append('<div class="menu-divider"></div>');
            if (blockedVal) {
                menu.append('<button type="button" data-action="unblock"><span class="menu-icon">🔓</span>Unblock user</button>');
            } else {
                menu.append('<button type="button" data-action="block" class="danger"><span class="menu-icon">🚫</span>Block user</button>');
            }
        }
        
        menu.addClass('active');
        const rect = btnEl.getBoundingClientRect();
        const menuW = menu.outerWidth();
        let top = rect.bottom + 8;
        let left = rect.right - menuW;
        left = Math.max(8, Math.min(left, window.innerWidth - menuW - 8));
        
        if (top + menu.outerHeight() > window.innerHeight - 8) {
            top = rect.top - menu.outerHeight() - 8;
        }
        
        menu.css({ top: top + 'px', left: left + 'px' });
        $('#chatListMenuBackdrop').addClass('active');
        $(btnEl).addClass('active');
    }

    function closeChatListMenu() {
        activeChatRow = null;
        $('.chat-menu-btn').removeClass('active');
        $('#chatListMenu').removeClass('active').empty();
        $('#chatListMenuBackdrop').removeClass('active');
    }

    function deleteChatFromList(row) {
        const conversationId = row.data('conversation-id');
        if (!confirm('Are you sure you want to delete this chat from your inbox?')) return;

        $.ajax({
            url: ctx + '/api/chat/conversations/' + conversationId,
            type: 'DELETE',
            success: function() {
                row.fadeOut(200, function() {
                    $(this).remove();
                    if (activeChatId === conversationId) {
                        activeChatId = null;
                        $('.active-chat-interface').hide();
                        $('.no-chat-placeholder').show();
                    }
                });
            },
            error: function(xhr) {
                alert('Chat delete failed: ' + xhr.responseText);
            }
        });
    }

    function blockUserFromList(row) {
        const partnerId = row.attr('data-partner-id');
        if (!partnerId) return;
        if (!confirm('Are you sure you want to block this user?')) return;

        $.ajax({
            url: ctx + '/api/chat/users/' + partnerId + '/block',
            type: 'POST',
            success: function() {
                row.attr('data-blocked-by-me', 'true');
                if (Number(activeChatId) === Number(row.attr('data-conversation-id'))) {
                    blockedByMe = true;
                    updateOptionsDropdown(true, isGroup);
                }
            },
            error: function(xhr) {
                alert('Block failed: ' + xhr.responseText);
            }
        });
    }

    function unblockUserFromList(row) {
        const partnerId = row.attr('data-partner-id');
        if (!partnerId) return;
        if (!confirm('Are you sure you want to unblock this user?')) return;

        $.ajax({
            url: ctx + '/api/chat/users/' + partnerId + '/unblock',
            type: 'POST',
            success: function() {
                row.attr('data-blocked-by-me', 'false');
                if (Number(activeChatId) === Number(row.attr('data-conversation-id'))) {
                    blockedByMe = false;
                    updateOptionsDropdown(false, isGroup);
                }
            },
            error: function(xhr) {
                alert('Unblock failed: ' + xhr.responseText);
            }
        });
    }

    // -------------------------------------------------------------
    // User Search & Start Chat autocomplete
    // -------------------------------------------------------------
    function searchUsers(keyword) {
        $.get(ctx + '/api/chat/users/search', { q: keyword }, function(users) {
            const box = $('#searchResults').empty();
            if (!users.length) {
                box.append('<div class="search-item" style="cursor:default;color:#64748b;font-size:13px;justify-content:center;">No results found</div>').show();
                return;
            }
            users.forEach(function(user) {
                const badge = user.role === 'ADMIN'
                    ? '<span class="badge-admin">Admin</span>'
                    : '<span class="badge-user">User</span>';
                const displayName = user.displayName || user.username;
                const row = $('<div class="search-item"></div>');
                row.html(
                    '<div class="avatar" style="width:32px;height:32px;font-size:14px;">' + displayName.charAt(0).toUpperCase() + '</div>' +
                    '<div style="font-size:14px;"><strong>' + escapeHtml(displayName) + '</strong> ' + badge + '</div>'
                );
                row.click(function() { startChat(user.id); });
                box.append(row);
            });
            box.show();
        });
    }

    function startChat(userId) {
        $.post(ctx + '/api/chat/start', { userId: userId }, function(data) {
            $('#searchInput').val('');
            $('#searchResults').hide().empty();
            
            const conversationId = data.conversationId;
            const existingRow = $('#row-' + conversationId);
            if (existingRow.length > 0) {
                selectChat(conversationId);
            } else {
                refreshInboxListAndSelect(conversationId);
            }
        }).fail(function(xhr) {
            alert(xhr.responseText || 'Could not start chat');
        });
    }

    function refreshInboxListAndSelect(selectId) {
        $.get(ctx + '/api/chat/inbox', function(items) {
            renderInboxList(items);
            if (selectId) {
                selectChat(selectId);
            }
        });
    }

    // -------------------------------------------------------------
    // WebSocket Connection & Real-Time Events
    // -------------------------------------------------------------
    function connectWebSocket() {
        if (socket && (socket.readyState === WebSocket.OPEN || socket.readyState === WebSocket.CONNECTING)) {
            return;
        }

        const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = wsProtocol + '//' + window.location.host + ctx + '/ws/chat';

        socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log('[Admin WebSocket] Connected successfully');
            if (reconnectTimer) {
                clearTimeout(reconnectTimer);
                reconnectTimer = null;
            }
        };

        socket.onmessage = function(event) {
            try {
                const data = JSON.parse(event.data);
                if (data.type === 'error') return;

                if (data.type === 'user_status_changed' && data.payload) {
                    const userId = String(data.payload.userId);
                    const isOnline = data.payload.isOnline;
                    const lastSeen = data.payload.lastSeenFormatted || 'Offline';
                    
                    if (partnerUserId && String(partnerUserId) === userId) {
                        updateHeaderStatus(isOnline, lastSeen);
                    }
                    
                    $('.chat-row[data-partner-id="' + userId + '"]').each(function() {
                        const dot = $(this).find('.status-dot-avatar');
                        if (isOnline) {
                            dot.addClass('online').removeClass('offline').attr('title', 'Online');
                        } else {
                            dot.addClass('offline').removeClass('online').attr('title', lastSeen);
                        }
                    });
                    return;
                }

                if (data.type === 'user_typing' && data.payload) {
                    const cid = String(data.payload.conversationId);
                    const senderId = String(data.payload.senderId);
                    if (cid === String(activeChatId) && senderId !== String(myUserId)) {
                        $('#typingIndicator').text(data.payload.senderName + ' is typing...').show();
                    }
                    return;
                }

                if (data.type === 'user_stopped_typing' && data.payload) {
                    const cid = String(data.payload.conversationId);
                    const senderId = String(data.payload.senderId);
                    if (cid === String(activeChatId) && senderId !== String(myUserId)) {
                        $('#typingIndicator').hide();
                    }
                    return;
                }

                if (data.type === 'message') {
                    const msg = data.payload;
                    if (msg && msg.conversationId) {
                        updateInboxRowPreview(msg);
                        if (String(msg.conversationId) === String(activeChatId)) {
                            appendMessage(msg);
                            scrollToBottom();
                            markReadUpTo(msg.id);
                        }
                    }
                } else if (data.type === 'message_edited') {
                    const msg = data.payload;
                    if (msg && msg.conversationId) {
                        updateInboxRowPreview(msg);
                        if (String(msg.conversationId) === String(activeChatId)) {
                            updateMessageDom(msg);
                        }
                    }
                } else if (data.type === 'message_reaction') {
                    const msg = data.payload;
                    if (msg && String(msg.conversationId) === String(activeChatId)) {
                        updateMessageReactions(msg);
                    }
                } else if (data.type === 'message_deleted') {
                    const cid = String(data.payload.conversationId);
                    const mid = String(data.payload.messageId);
                    if (cid === String(activeChatId)) {
                        removeMessageDom(mid);
                    }
                    refreshInboxListSilently();
                } else if (data.type === 'conversation_cleared') {
                    const cid = String(data.payload.conversationId);
                    if (cid === String(activeChatId)) {
                        clearChatBox();
                    }
                    refreshInboxListSilently();
                } else if (data.type === 'messages_read') {
                    const payload = data.payload;
                    if (payload && String(payload.conversationId) === String(activeChatId)) {
                        applyReadReceipt(payload);
                    }
                }
            } catch (e) {
                console.error('[Admin WebSocket] Error parsing message:', e);
            }
        };

        socket.onclose = function() {
            if (reconnectTimer) clearTimeout(reconnectTimer);
            reconnectTimer = setTimeout(connectWebSocket, 3000);
        };

        socket.onerror = function() {
            try { socket.close(); } catch(e) {}
        };
    }

    function updateInboxRowPreview(msg) {
        const conversationId = String(msg.conversationId);
        let row = $('#row-' + conversationId);
        
        let timeStr = '00:00';
        if (msg.createdAt) {
            try {
                if (Array.isArray(msg.createdAt)) {
                    var hrs = String(msg.createdAt[3]).padStart(2, '0');
                    var mins = String(msg.createdAt[4]).padStart(2, '0');
                    timeStr = hrs + ':' + mins;
                } else {
                    var parts = msg.createdAt.split('T');
                    if (parts.length > 1) timeStr = parts[1].substring(0, 5);
                }
            } catch(e) {}
        }

        let previewText = msg.messageText || '';
        if (!previewText) {
            if (msg.messageType === 'IMAGE') previewText = '📷 Photo';
            else if (msg.messageType === 'VIDEO') previewText = '🎬 Video';
            else if (msg.messageType === 'DOCUMENT') previewText = '📄 Document';
            else if (msg.attachments && msg.attachments.length) {
                const att = msg.attachments[0];
                const ft = (att.fileType || '').toLowerCase();
                const fu = (att.fileUrl || '').toLowerCase();
                if (ft.startsWith('video/') || fu.match(/\.(mp4|webm|mov|avi)$/i)) previewText = '🎬 Video';
                else if (ft.startsWith('image/') || fu.match(/\.(jpg|jpeg|png|gif|webp)$/i)) previewText = '📷 Photo';
                else previewText = '📄 Document';
            }
            else previewText = 'Message';
        }

        if (row.length > 0) {
            row.find('.chat-preview').text(previewText);
            row.find('.chat-time').text(timeStr);

            if (String(msg.conversationId) !== String(activeChatId) && String(msg.senderId) !== String(myUserId)) {
                let badge = row.find('.unread-badge');
                if (badge.length === 0) {
                    row.find('.chat-preview').after('<span class="unread-badge">1</span>');
                } else {
                    let count = parseInt(badge.text() || '0', 10);
                    if (isNaN(count)) count = 0;
                    count++;
                    badge.text(count > 99 ? '99+' : count).show();
                }
            }
            $('#chatList').prepend(row);
        } else {
            refreshInboxListSilently();
        }
    }

    function refreshInboxListSilently() {
        $.get(ctx + '/api/chat/inbox', function(items) {
            renderInboxList(items);
        });
    }

    function renderInboxList(items) {
        const list = $('#chatList').empty();
        if (!items || items.length === 0) {
            list.html('<div style="text-align:center;padding:40px;color:#64748b;font-size:14px;">No chats yet.</div>');
            return;
        }
        items.forEach(function(item) {
            const row = $('<div class="chat-row" id="row-' + item.conversationId + '"></div>');
            row.attr({
                'data-conversation-id': item.conversationId,
                'data-is-group': item.group,
                'data-partner-id': item.partnerUserId,
                'data-blocked-by-me': item.blockedByMe,
                'data-partner-name': item.displayName
            });
            if (Number(activeChatId) === Number(item.conversationId)) {
                row.addClass('active');
            }
            
            let timeStr = '';
            if (item.lastMessageAt) {
                try {
                    if (Array.isArray(item.lastMessageAt)) {
                        var hrs = String(item.lastMessageAt[3]).padStart(2, '0');
                        var mins = String(item.lastMessageAt[4]).padStart(2, '0');
                        timeStr = hrs + ':' + mins;
                    } else {
                        var parts = item.lastMessageAt.split('T');
                        if (parts.length > 1) timeStr = parts[1].substring(0, 5);
                    }
                } catch(e) {}
            }
            
            const avatarInitial = item.displayName ? item.displayName.charAt(0).toUpperCase() : 'U';
            const groupClass = item.group ? 'group' : '';
            const onlineClass = item.partnerOnline ? 'online' : 'offline';
            const onlineTitle = item.partnerOnline ? 'Online' : (item.partnerLastSeenFormatted || 'Offline');
            const onlineDot = item.group ? '' : '<span class="status-dot-avatar ' + onlineClass + '" title="' + onlineTitle + '"></span>';
            const unreadBadge = item.unreadCount > 0 ? '<span class="unread-badge">' + (item.unreadCount > 99 ? '99+' : item.unreadCount) + '</span>' : '';
            
            const contentHtml = 
                '<div class="chat-row-link" onclick="selectChat(' + item.conversationId + ')">' +
                    '<div class="avatar-wrap">' +
                        '<div class="avatar ' + groupClass + '">' + avatarInitial + '</div>' +
                        onlineDot +
                    '</div>' +
                    '<div style="flex: 1; min-width: 0;">' +
                        '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">' +
                            '<strong style="font-size:14px; font-weight:600; color:#1e293b; text-overflow:ellipsis; overflow:hidden; white-space:nowrap;">' + escapeHtml(item.displayName) + '</strong>' +
                            '<span class="chat-time" style="font-size:11px; color:#64748b;">' + timeStr + '</span>' +
                        '</div>' +
                        '<div style="display:flex; justify-content:space-between; align-items:center;">' +
                            '<span class="chat-preview" style="font-size:12px; color:#64748b; text-overflow:ellipsis; overflow:hidden; white-space:nowrap; flex:1; margin-right:8px;">' + escapeHtml(item.lastMessagePreview || '') + '</span>' +
                            unreadBadge +
                        '</div>' +
                    '</div>' +
                '</div>' +
                '<div class="chat-row-side">' +
                    '<button type="button" class="chat-menu-btn" onclick="handleChatRowMenu(event, ' + item.conversationId + ', this)">⋮</button>' +
                '</div>';
                
            row.html(contentHtml);
            list.append(row);
        });
    }

    // -------------------------------------------------------------
    // Helper & Render Functions
    // -------------------------------------------------------------
    function appendMessage(msg) {
        $('#emptyChat').remove();
        var isMe = String(msg.senderId) === String(myUserId);
        var cls = isMe ? 'me' : 'other';
        var label = isMe ? 'You' : (msg.senderDisplayName || partnerDisplayName || 'User');

        var row = $('<div class="message-row ' + cls + '" id="msg-' + msg.id + '" data-msg-id="' + msg.id + '" data-sender-me="' + isMe + '"></div>');
        row.data('msg', msg);
        
        if (!isMe) {
            var senderAvatar = $('<div class="avatar" style="width:30px; height:30px; font-size:10px; box-shadow:none; flex-shrink:0; border-radius:50%; margin-bottom: 2px;">' +
                '<img src="' + ctx + '/user/avatar/' + msg.senderId + '" onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'flex\';" style="width:100%; height:100%; object-fit:cover; border-radius:50%;" />' +
                '<div class="avatar-initials" style="display:none; width:100%; height:100%; border-radius:50%; align-items:center; justify-content:center; background: #cbd5e1; color: #1e293b;">' +
                    label.charAt(0).toUpperCase() +
                '</div>' +
            '</div>');
            row.append(senderAvatar);
        }
        
        var bubble = $('<div class="bubble ' + cls + '"></div>');
        var meta = $('<div class="bubble-meta"></div>');
        meta.html('<span>' + label + '</span>');
        bubble.append(meta);

        if (msg.parentMessagePreview) {
            bubble.append('<div class="reply-preview">' + escapeHtml(msg.parentMessagePreview) + '</div>');
        }

        if (msg.messageText) {
            bubble.append($('<div class="bubble-text"></div>').text(msg.messageText));
        }

        // Attachments
        if (msg.attachments && msg.attachments.length) {
            var mediaContainer = $('<div class="bubble-media-container" style="display:flex; flex-direction:column; gap:6px; margin-top:6px;"></div>');

            msg.attachments.forEach(function(att) {
                var url = ctx + att.fileUrl;
                var fileType = (att.fileType || '').toLowerCase();
                var fileUrl = (att.fileUrl || '').toLowerCase();

                var isVideo = fileType.indexOf('video/') === 0 || fileUrl.match(/\.(mp4|webm|mov|avi)$/i);
                var isImage = fileType.indexOf('image/') === 0 || fileUrl.match(/\.(jpg|jpeg|png|gif|webp)$/i);
                var isAudio = fileType.indexOf('audio/') === 0 || fileUrl.match(/\.(mp3|wav|ogg|m4a)$/i);

                if (isVideo) {
                    var mediaWrapper = $('<div style="width:100%; max-width:320px; border-radius: 8px; overflow: hidden; border: 1px solid #e2e8f0; background: #f8fafc;"></div>');
                    mediaWrapper.append('<video controls src="' + url + '" style="width:100%; display:block; max-height:220px; object-fit:cover;"></video>');
                    mediaContainer.append(mediaWrapper);
                } else if (isImage) {
                    var mediaWrapper = $('<div style="width:100%; max-width:320px; border-radius: 8px; overflow: hidden; border: 1px solid #e2e8f0; background: #f8fafc;"></div>');
                    mediaWrapper.append('<img src="' + url + '" alt="photo" style="width:100%; display:block; max-height:240px; object-fit:cover; cursor:pointer;" onclick="openLightbox(\'' + url + '\')"/>');
                    mediaContainer.append(mediaWrapper);
                } else if (isAudio) {
                    var mediaWrapper = $('<div style="width:100%; max-width:300px; padding:6px; border-radius:8px; background:#f8fafc; border:1px solid #e2e8f0;"></div>');
                    mediaWrapper.append('<audio controls src="' + url + '" style="width:100%; height:36px;"></audio>');
                    mediaContainer.append(mediaWrapper);
                } else {
                    var rawFileName = att.fileUrl ? att.fileUrl.substring(att.fileUrl.lastIndexOf('/') + 1) : 'file';
                    if (rawFileName.indexOf('_') > -1) {
                        rawFileName = rawFileName.substring(rawFileName.indexOf('_') + 1);
                    }

                    var icon = '📄';
                    if (fileUrl.endsWith('.pdf')) icon = '📕';
                    else if (fileUrl.match(/\.(doc|docx)$/i)) icon = '📘';
                    else if (fileUrl.match(/\.(xls|xlsx|csv)$/i)) icon = '📊';
                    else if (fileUrl.match(/\.(ppt|pptx)$/i)) icon = '📙';
                    else if (fileUrl.match(/\.(zip|rar|7z|tar|gz)$/i)) icon = '📦';

                    var sizeText = att.fileSize ? (' • ' + Math.round(att.fileSize / 1024) + ' KB') : '';
                    var bgStyle = isMe ? 'background: rgba(255,255,255,0.18); border: 1px solid rgba(255,255,255,0.3); color:#ffffff;' : 'background: #f1f5f9; border: 1px solid #cbd5e1; color:#1e293b;';
                    var btnStyle = isMe ? 'background: #ffffff; color: #2563eb;' : 'background: #2563eb; color: #ffffff;';

                    var docCard = $('<div class="doc-attachment-card" style="display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; ' + bgStyle + ' width:280px; max-width:100%; box-sizing:border-box;"></div>');
                    docCard.append('<span style="font-size:26px; flex-shrink:0;">' + icon + '</span>');
                    docCard.append('<div style="flex:1; min-width:0;"><div style="font-weight:600; font-size:13px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;" title="' + escapeHtml(rawFileName) + '">' + escapeHtml(rawFileName) + '</div><div style="font-size:11px; opacity:0.8;">Document' + sizeText + '</div></div>');
                    docCard.append('<a href="' + url + '" target="_blank" download style="padding:6px 12px; border-radius:6px; ' + btnStyle + ' text-decoration:none; font-size:12px; font-weight:600; flex-shrink:0; display:inline-flex; align-items:center;">Open ↗</a>');

                    mediaContainer.append(docCard);
                }
            });
            bubble.append(mediaContainer);
        }

        var timeStr = '00:00';
        if (msg.createdAt) {
            try {
                if (Array.isArray(msg.createdAt)) {
                    var hrs = String(msg.createdAt[3]).padStart(2, '0');
                    var mins = String(msg.createdAt[4]).padStart(2, '0');
                    timeStr = hrs + ':' + mins;
                } else {
                    var parts = msg.createdAt.split('T');
                    if (parts.length > 1) timeStr = parts[1].substring(0, 5);
                }
            } catch(e) {}
        }
        var timeHtml = '<span class="bubble-time">' + timeStr;
        if (msg.edited) {
            timeHtml += ' <span class="edited-label">(edited)</span>';
        }
        if (isMe) {
            var readMark = (msg.readCount && msg.readCount > 0) ? '✓✓' : '✓';
            timeHtml += ' <span class="read-receipt">' + readMark + '</span>';
        }
        timeHtml += '</span>';
        bubble.append(timeHtml);

        if (msg.reactions && msg.reactions.length) {
            bubble.append(renderReactionsHtml(msg));
        }

        row.append(bubble);
        $('#chatBox').append(row);
    }

    function scrollToBottom() {
        const box = $('#chatBox');
        box.scrollTop(box[0].scrollHeight);
    }

    function markReadUpTo(messageId) {
        if (!activeChatId) return;
        $.ajax({
            url: ctx + '/api/chat/messages/read',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ conversationId: Number(activeChatId), upToMessageId: messageId })
        });
    }

    function applyReadReceipt(payload) {
        if (!payload || String(payload.conversationId) !== String(activeChatId)) return;
        $('[data-sender-me="true"]').each(function() {
            const row = $(this);
            if (Number(row.attr('data-msg-id')) <= Number(payload.upToMessageId)) {
                row.find('.read-receipt').text('✓✓');
            }
        });
    }

    function openLightbox(imgSrc) {
        $('#lightboxTargetImg').attr('src', imgSrc);
        $('#imageLightbox').css('display', 'flex');
    }

    function escapeHtml(text) {
        return $('<div/>').text(text).html();
    }
</script>
</body>
</html>
