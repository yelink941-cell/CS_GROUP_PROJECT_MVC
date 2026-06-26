<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="my">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Chats</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: #fff; color: #111; }
        
        /* Full Width Container */
        .app { width: 100%; max-width: 100%; min-height: 100vh; display: flex; flex-direction: column; }
        
        /* Topbar Layout - အစိမ်းမှ အမည်းရောင် (Black) သို့ ပြောင်းလဲထားသည် */
        .topbar { background: #111111; color: #fff; padding: 10px 20px; display: flex; align-items: center; justify-content: space-between; gap: 16px; }
        
        /* Back Button */
        .back-btn { 
            color: #fff; 
            text-decoration: none; 
            font-size: 18px; 
            width: 36px; 
            height: 36px; 
            display: inline-flex; 
            align-items: center; 
            justify-content: center; 
            border-radius: 50%; 
            transition: background 0.2s; 
        }
        .back-btn:hover { background: rgba(255, 255, 255, 0.15); }

        /* Topbar Actions */
        .topbar-actions { display: flex; align-items: center; gap: 12px; flex: 1; justify-content: flex-end; }
        
        /* Compact Search Bar */
        .search-container { position: relative; width: 100%; max-width: 260px; }
        .search-container input { 
            width: 100%; 
            border: none; 
            border-radius: 20px; 
            padding: 8px 14px 8px 34px; 
            font-size: 14px; 
            outline: none; 
            background: rgba(255, 255, 255, 0.15); 
            color: #fff; 
            transition: all 0.2s; 
        }
        .search-container input::placeholder { color: rgba(255, 255, 255, 0.75); }
        .search-container input:focus { background: #fff; color: #111; }
        
        .search-icon { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); font-size: 13px; color: rgba(255, 255, 255, 0.75); pointer-events: none; }
        .search-container input:focus ~ .search-icon { color: #667781; }

        /* Search Dropdown */
        .search-results { 
            position: absolute; 
            right: 0; 
            left: auto; 
            width: 100%; 
            min-width: 260px; 
            top: 42px; 
            background: #fff; 
            border-radius: 10px; 
            box-shadow: 0 8px 24px rgba(0,0,0,.15); 
            z-index: 20; 
            display: none; 
            max-height: 280px; 
            overflow-y: auto; 
            color: #111; 
        }
        .search-item { display: flex; align-items: center; gap: 12px; padding: 12px 14px; cursor: pointer; border-bottom: 1px solid #f0f2f5; }
        .search-item:hover { background: #f5f6f6; }
        
        /* Avatar & Chat Rows */
        .avatar { width: 48px; height: 48px; border-radius: 50%; background: #dfe5e7; color: #54656f; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 18px; flex-shrink: 0; }
        
        /* Group Avatar - အစိမ်းမှ Dark Charcoal အမည်းရောင်သန်းသော အရောင်သို့ ပြောင်းလဲထားသည် */
        .avatar.group { background: #333333; color: #fff; }
        
        .chat-row { display: flex; align-items: center; gap: 14px; padding: 14px 20px; text-decoration: none; color: inherit; border-bottom: 1px solid #f0f2f5; }
        .chat-row:hover { background: #f5f6f6; }
        .chat-meta { flex: 1; min-width: 0; }
        .chat-meta-top { display: flex; justify-content: space-between; gap: 8px; align-items: baseline; }
        .chat-name { font-size: 16px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .chat-time { font-size: 12px; color: #667781; white-space: nowrap; }
        .chat-preview { font-size: 14px; color: #667781; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 2px; }
        
        /* Badges - User Badge ကိုလည်း အမည်းရောင်သို့ ပြောင်းလဲထားသည် */
        .badge-admin { background: #ff9800; color: #fff; font-size: 10px; padding: 2px 6px; border-radius: 8px; margin-left: 6px; vertical-align: middle; }
        .badge-user { background: #111111; color: #fff; font-size: 10px; padding: 2px 6px; border-radius: 8px; margin-left: 6px; vertical-align: middle; }
        .empty { text-align: center; color: #667781; padding: 80px 24px; }
        
        .fab-group { display: inline-block; background: rgba(255,255,255,.2); padding: 7px 12px; border-radius: 16px; font-size: 13px; text-decoration: none; color: #fff; font-weight: 500; white-space: nowrap; }
        .fab-group:hover { background: rgba(255,255,255,.3); }

        /* Responsive Mobile UI */
        @media (max-width: 500px) {
            .topbar { padding: 10px 12px; gap: 8px; }
            .search-container { max-width: 150px; }
            .search-results { min-width: 150px; top: 38px; }
            .search-container input { padding: 6px 10px 6px 28px; font-size: 12px; }
            .search-icon { left: 10px; font-size: 11px; }
            .fab-group { font-size: 12px; padding: 6px 10px; }
            .chat-row { padding: 12px 14px; }
        }
    </style>
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="app">
    <div class="topbar">
        <div>
            <a href="${ctx}/" class="back-btn">←</a>
        </div>
        
        <div class="topbar-actions">
            <div class="search-container">
                <span class="search-icon">🔍</span>
                <input type="text" id="searchInput" placeholder="လူရှာရန်..." autocomplete="off">
                <div id="searchResults" class="search-results"></div>
            </div>
            <a href="${ctx}/chat/create-group" class="fab-group">+ Group</a>
        </div>
    </div>

    <div id="chatList" style="flex:1;">
        <c:forEach var="item" items="${inboxItems}">
            <a href="${ctx}/chat/room?id=${item.conversationId}" class="chat-row">
                <div class="avatar ${item.group ? 'group' : ''}">
                    <c:choose>
                        <c:when test="${item.group}">👥</c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${not empty item.displayName}">${item.displayName.substring(0,1).toUpperCase()}</c:when>
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
                <p style="font-size:14px;">အပေါ်ရှိ Search bar ဖြင့် user (Admin/User) ကို ရှာပြီး chat စတင်ပါ</p>
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
        if (!$(e.target).closest('.search-container').length) {
            $('#searchResults').hide();
        }
    });

    function searchUsers(keyword) {
        $.get(ctx + '/api/chat/users/search', { q: keyword }, function(users) {
            const box = $('#searchResults').empty();
            if (!users.length) {
                box.append('<div class="search-item" style="cursor:default;color:#667781;font-size:13px;justify-content:center;">ရှာမတွေ့ပါ</div>').show();
                return;
            }
            users.forEach(function(user) {
                const badge = user.role === 'ADMIN'
                    ? '<span class="badge-admin">Admin</span>'
                    : '<span class="badge-user">User</span>';
                const row = $('<div class="search-item"></div>');
                row.html(
                    '<div class="avatar" style="width:32px;height:32px;font-size:14px;">' + user.username.charAt(0).toUpperCase() + '</div>' +
                    '<div style="font-size:14px;"><strong>' + escapeHtml(user.username) + '</strong> ' + badge + '</div>'
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