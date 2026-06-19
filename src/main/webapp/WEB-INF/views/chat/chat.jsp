<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chats</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: #fff; color: #111; }
        .app { max-width: 480px; margin: 0 auto; min-height: 100vh; border-left: 1px solid #e4e6eb; border-right: 1px solid #e4e6eb; display: flex; flex-direction: column; }
        .topbar { background: #008069; color: #fff; padding: 14px 16px; display: flex; align-items: center; justify-content: space-between; }
        .topbar h1 { margin: 0; font-size: 20px; font-weight: 600; }
        .topbar-actions a { color: #fff; text-decoration: none; font-size: 13px; margin-left: 10px; opacity: .95; }
        .search-wrap { padding: 10px 12px; background: #f0f2f5; border-bottom: 1px solid #e4e6eb; position: relative; }
        .search-wrap input { width: 100%; border: none; border-radius: 20px; padding: 10px 16px; font-size: 15px; outline: none; background: #fff; }
        .search-results { position: absolute; left: 12px; right: 12px; top: 52px; background: #fff; border-radius: 10px; box-shadow: 0 8px 24px rgba(0,0,0,.12); z-index: 20; display: none; max-height: 280px; overflow-y: auto; }
        .search-item { display: flex; align-items: center; gap: 12px; padding: 12px 14px; cursor: pointer; border-bottom: 1px solid #f0f2f5; }
        .search-item:hover { background: #f5f6f6; }
        .avatar { width: 48px; height: 48px; border-radius: 50%; background: #dfe5e7; color: #54656f; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 18px; flex-shrink: 0; }
        .avatar.group { background: #25d366; color: #fff; }
        .chat-row { display: flex; align-items: center; gap: 12px; padding: 12px 16px; text-decoration: none; color: inherit; border-bottom: 1px solid #f0f2f5; }
        .chat-row:hover { background: #f5f6f6; }
        .chat-meta { flex: 1; min-width: 0; }
        .chat-meta-top { display: flex; justify-content: space-between; gap: 8px; align-items: baseline; }
        .chat-name { font-size: 16px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .chat-time { font-size: 12px; color: #667781; white-space: nowrap; }
        .chat-preview { font-size: 14px; color: #667781; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 2px; }
        .badge-admin { background: #ff9800; color: #fff; font-size: 10px; padding: 2px 6px; border-radius: 8px; margin-left: 6px; vertical-align: middle; }
        .badge-user { background: #008069; color: #fff; font-size: 10px; padding: 2px 6px; border-radius: 8px; margin-left: 6px; vertical-align: middle; }
        .empty { text-align: center; color: #667781; padding: 48px 24px; }
        .fab-group { display: inline-block; background: rgba(255,255,255,.2); padding: 6px 10px; border-radius: 16px; font-size: 13px; text-decoration: none; color: #fff; }
    </style>
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="app">
    <div class="topbar">
        <div>
            <a href="${ctx}/" style="color:#fff;text-decoration:none;margin-right:8px;">←</a>
            <span style="font-size:14px;opacity:.9;">${currentUser.username}</span>
        </div>
        <div class="topbar-actions">
            <a href="${ctx}/chat/create-group" class="fab-group">+ Group</a>
            <a href="${ctx}/logout">Logout</a>
        </div>
    </div>

    <div class="search-wrap">
        <input type="text" id="searchInput" placeholder="🔍 လူရှာရန် (username)... " autocomplete="off">
        <div id="searchResults" class="search-results"></div>
    </div>

    <div id="chatList" style="flex:1;">
        <c:forEach var="item" items="${inboxItems}">
            <a href="${ctx}/chat/room?id=${item.conversationId}" class="chat-row">
                <div class="avatar ${item.group ? 'group' : ''}">
                    <c:choose>
                        <c:when test="${item.group}">👥</c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${not empty item.displayName}">${item.displayName.substring(0,1)}</c:when>
                                <c:otherwise>?</c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="chat-meta">
                    <div class="chat-meta-top">
                        <div class="chat-name">
                            <c:out value="${item.displayName}"/>
                            <c:if test="${!item.group && item.displayRole == 'ADMIN'}">
                                <span class="badge-admin">Admin</span>
                            </c:if>
                        </div>
                        <c:if test="${not empty item.lastMessageAt}">
                            <span class="chat-time">${item.lastMessageAt.toString().substring(11,16)}</span>
                        </c:if>
                    </div>
                    <div class="chat-preview">
                        <c:out value="${not empty item.lastMessagePreview ? item.lastMessagePreview : 'စကားမရှိသေးပါ'}"/>
                    </div>
                </div>
            </a>
        </c:forEach>

        <c:if test="${empty inboxItems}">
            <div class="empty">
                <p style="font-size:40px;margin:0;">💬</p>
                <p>Chat list မရှိသေးပါ</p>
                <p style="font-size:14px;">Search bar ဖြင့် user (Admin/User) ကို ရှာပြီး chat စတင်ပါ</p>
            </div>
        </c:if>
    </div>
</div>

<script>
    const ctx = '${ctx}';
    let searchTimer;

    $('#searchInput').on('input', function() {
        clearTimeout(searchTimer);
        const q = $(this).val().trim();
        if (q.length < 1) {
            $('#searchResults').hide().empty();
            return;
        }
        searchTimer = setTimeout(function() { searchUsers(q); }, 250);
    });

    $(document).click(function(e) {
        if (!$(e.target).closest('.search-wrap').length) {
            $('#searchResults').hide();
        }
    });

    function searchUsers(keyword) {
        $.get(ctx + '/api/chat/users/search', { q: keyword }, function(users) {
            const box = $('#searchResults').empty();
            if (!users.length) {
                box.append('<div class="search-item" style="cursor:default;color:#667781;">ရှာမတွေ့ပါ</div>').show();
                return;
            }
            users.forEach(function(user) {
                const badge = user.role === 'ADMIN'
                    ? '<span class="badge-admin">Admin</span>'
                    : '<span class="badge-user">User</span>';
                const row = $('<div class="search-item"></div>');
                row.html(
                    '<div class="avatar">' + user.username.charAt(0).toUpperCase() + '</div>' +
                    '<div><strong>' + escapeHtml(user.username) + '</strong> ' + badge + '</div>'
                );
                row.click(function() { startChat(user.id); });
                box.append(row);
            });
            box.show();
        });
    }

    function startChat(userId) {
        $.post(ctx + '/api/chat/start', { userId: userId }, function(data) {
            window.location.href = ctx + '/chat/room?id=' + data.conversationId;
        }).fail(function(xhr) {
            alert(xhr.responseText || 'Chat စတင်၍ မရပါ');
        });
    }

    function escapeHtml(text) {
        return $('<div>').text(text).html();
    }
</script>

</body>
</html>
