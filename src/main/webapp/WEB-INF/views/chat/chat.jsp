<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
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
        
        /* Topbar Layout */
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
        .avatar-wrap { position: relative; display: inline-flex; flex-shrink: 0; }
        .avatar { width: 48px; height: 48px; border-radius: 50%; background: #dfe5e7; color: #54656f; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 18px; flex-shrink: 0; }
        .status-dot-avatar {
            position: absolute;
            bottom: 2px;
            right: 2px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            border: 2px solid #fff;
            background-color: #cbd5e1;
        }
        .status-dot-avatar.online { background-color: #22c55e; }
        
        /* Group Avatar */
        .avatar.group { background: #333333; color: #fff; }
        
        .chat-row { display: flex; align-items: center; gap: 8px; padding: 0; border-bottom: 1px solid #f0f2f5; position: relative; }
        .chat-row:hover { background: #f5f6f6; }
        .chat-row-link { flex: 1; min-width: 0; display: flex; align-items: center; gap: 14px; padding: 14px 0 14px 20px; text-decoration: none; color: inherit; }
        .chat-row-link:hover { background: transparent; }
        .chat-row-side { display: flex; flex-direction: column; align-items: flex-end; justify-content: center; gap: 6px; padding: 14px 12px 14px 0; flex-shrink: 0; }
        .chat-menu-btn {
            width: 32px;
            height: 32px;
            border: none;
            border-radius: 50%;
            background: transparent;
            color: #667781;
            font-size: 20px;
            line-height: 1;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            transition: background 0.2s, opacity 0.2s;
        }
        .chat-row:hover .chat-menu-btn,
        .chat-menu-btn.active { opacity: 1; }
        .chat-menu-btn:hover,
        .chat-menu-btn.active { background: rgba(0, 0, 0, 0.06); color: #111; }
        .chat-meta { flex: 1; min-width: 0; }
        .chat-meta-top { display: flex; justify-content: space-between; gap: 8px; align-items: baseline; }
        .chat-name { font-size: 16px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .chat-time { font-size: 12px; color: #667781; white-space: nowrap; }
        .chat-preview { font-size: 14px; color: #667781; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-top: 2px; }

        .chat-list-menu-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 150;
            background: transparent;
        }
        .chat-list-menu-backdrop.active { display: block; }

        .chat-list-menu {
            display: none;
            position: fixed;
            z-index: 151;
            min-width: 180px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.18), 0 2px 8px rgba(0, 0, 0, 0.08);
            padding: 6px 0;
            animation: menuPop 0.15s ease-out;
            overflow: hidden;
        }
        .chat-list-menu.active { display: block; }
        .chat-list-menu button {
            display: flex;
            align-items: center;
            gap: 12px;
            width: 100%;
            padding: 10px 18px;
            border: none;
            background: transparent;
            font-size: 14px;
            font-family: inherit;
            color: #111;
            cursor: pointer;
            text-align: left;
        }
        .chat-list-menu button:hover { background: #f5f6f6; }
        .chat-list-menu button.danger { color: #ef4444; }
        .chat-list-menu .menu-icon { width: 20px; text-align: center; font-size: 15px; }
        .chat-list-menu .menu-divider { height: 1px; background: #f0f2f5; margin: 4px 0; }

        @keyframes menuPop {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        
        /* Badges */
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
            .chat-row-link { padding: 12px 0 12px 14px; }
            .chat-row-side { padding: 12px 8px 12px 0; }
            .chat-menu-btn { opacity: 1; }
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
                <input type="text" id="searchInput" placeholder="Search users..." autocomplete="off">
                <div id="searchResults" class="search-results"></div>
            </div>
            <a href="${ctx}/chat/create-group" class="fab-group">+ Group</a>
        </div>
    </div>

    <div id="chatList" style="flex:1;">
        <c:forEach var="item" items="${inboxItems}">
            <div class="chat-row"
                 data-conversation-id="${item.conversationId}"
                 data-is-group="${item.group}"
                 data-partner-id="${item.partnerUserId != null ? item.partnerUserId : ''}"
                 data-blocked-by-me="${item.blockedByMe}">
                <a href="${ctx}/chat/room?id=${item.conversationId}" class="chat-row-link">
                    <div class="avatar-wrap">
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
                        <c:if test="${!item.group}">
                            <span class="status-dot-avatar ${item.partnerOnline ? 'online' : 'offline'}" title="${item.partnerOnline ? 'Online' : (not empty item.partnerLastSeenFormatted ? item.partnerLastSeenFormatted : 'Offline')}"></span>
                        </c:if>
                    </div>
                    <div class="chat-meta">
                        <div class="chat-meta-top">
                            <div class="chat-name">
                                <c:out value="${item.displayName}"/>
                                <c:if test="${!item.group && item.displayRole == 'ADMIN'}">
                                    <span class="badge-admin">Admin</span>
                                </c:if>
                            </div>
                        </div>
                        <div class="chat-preview">
                            <c:out value="${not empty item.lastMessagePreview ? item.lastMessagePreview : 'No messages yet'}"/>
                        </div>
                    </div>
                </a>
                <div class="chat-row-side">
                    <c:if test="${not empty item.lastMessageAt}">
                        <span class="chat-time">${item.lastMessageAt.toString().substring(11,16)}</span>
                    </c:if>
                    <button type="button" class="chat-menu-btn" title="More options" aria-label="More options">&#8942;</button>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty inboxItems}">
            <div class="empty">
                <p style="font-size:40px;margin:0;">💬</p>
                <p>No chats yet</p>
                <p style="font-size:14px;">Use the Search bar above to find a user (Admin/User) and start chatting</p>
            </div>
        </c:if>
    </div>
</div>

<div id="chatListMenuBackdrop" class="chat-list-menu-backdrop"></div>
<div id="chatListMenu" class="chat-list-menu"></div>

<script>
    const ctx = '${ctx}';
    let searchTimer;
    let activeChatRow = null;

    let socket = null;
    let reconnectTimer = null;

    $(document).ready(function() {
        connectWebSocket();

        $(document).on('click', '.chat-menu-btn', function(e) {
       		     e.preventDefault();
            e.stopPropagation();
            openChatListMenu($(this).closest('.chat-row'), this);
        });

        $('#chatListMenuBackdrop').click(closeChatListMenu);

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

        $(document).keydown(function(e) {
            if (e.key === 'Escape') closeChatListMenu();
        });
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

    $(document).click(function(e) {
        if (!$(e.target).closest('.search-container').length) {
            $('#searchResults').hide();
        }
        if (!$(e.target).closest('.chat-list-menu, .chat-menu-btn').length) {
            closeChatListMenu();
        }
    });

    function openChatListMenu(row, anchorEl) {
        closeChatListMenu();
        activeChatRow = row;

        var isGroup = row.data('is-group') === true || String(row.data('is-group')) === 'true';
        var partnerId = row.data('partner-id');
        var menu = $('#chatListMenu').empty();

        menu.append(
            '<button type="button" data-action="delete" class="danger">' +
            '<span class="menu-icon">🗑</span>Delete chat</button>'
        );

        if (!isGroup && partnerId) {
            menu.append('<div class="menu-divider"></div>');
            var isBlocked = row.data('blocked-by-me') === true || String(row.data('blocked-by-me')) === 'true';
            if (isBlocked) {
                menu.append(
                    '<button type="button" data-action="unblock">' +
                    '<span class="menu-icon">🔓</span>Unblock user</button>'
                );
            } else {
                menu.append(
                    '<button type="button" data-action="block" class="danger">' +
                    '<span class="menu-icon">🚫</span>Block user</button>'
                );
            }
        }

        menu.addClass('active');
        var rect = anchorEl.getBoundingClientRect();
        var menuW = menu.outerWidth();
        var top = rect.bottom + 8;
        var left = rect.right - menuW;
        left = Math.max(8, Math.min(left, window.innerWidth - menuW - 8));

        if (top + menu.outerHeight() > window.innerHeight - 8) {
            top = rect.top - menu.outerHeight() - 8;
        }

        menu.css({ top: top + 'px', left: left + 'px' });
        $('#chatListMenuBackdrop').addClass('active');
        $(anchorEl).addClass('active');
    }

    function closeChatListMenu() {
        activeChatRow = null;
        $('.chat-menu-btn').removeClass('active');
        $('#chatListMenu').removeClass('active').empty();
        $('#chatListMenuBackdrop').removeClass('active');
    }

    function deleteChatFromList(row) {
        var conversationId = row.data('conversation-id');
        if (!confirm('Are you sure you want to delete this chat from your inbox?')) return;

        $.ajax({
            url: ctx + '/api/chat/conversations/' + conversationId,
            type: 'DELETE',
            success: function() {
                row.fadeOut(200, function() {
                    $(this).remove();
                    if ($('.chat-row').length === 0) {
                        location.reload();
                    }
                });
            },
            error: function(xhr) {
                alert('Chat delete failed: ' + xhr.responseText);
            }
        });
    }

    function blockUserFromList(row) {
        var partnerId = row.data('partner-id');
        if (!partnerId) return;
        if (!confirm('Are you sure you want to block this user?')) return;

        $.ajax({
            url: ctx + '/api/chat/users/' + partnerId + '/block',
            type: 'POST',
            success: function() {
                location.reload();
            },
            error: function(xhr) {
                alert('Block failed: ' + xhr.responseText);
            }
        });
    }

    function unblockUserFromList(row) {
        var partnerId = row.data('partner-id');
        if (!partnerId) return;
        if (!confirm('Are you sure you want to unblock this user?')) return;

        $.ajax({
            url: ctx + '/api/chat/users/' + partnerId + '/unblock',
            type: 'POST',
            success: function() {
                location.reload();
            },
            error: function(xhr) {
                alert('Unblock failed: ' + xhr.responseText);
            }
        });
    }

    function searchUsers(keyword) {
        $.get(ctx + '/api/chat/users/search', { q: keyword }, function(users) {
            const box = $('#searchResults').empty();
            if (!users.length) {
                box.append('<div class="search-item" style="cursor:default;color:#667781;font-size:13px;justify-content:center;">No results found</div>').show();
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
            window.location.href = ctx + '/chat/room?id=' + data.conversationId;
        }).fail(function(xhr) {
            alert(xhr.responseText || 'Could not start chat');
        });
    }

    function escapeHtml(text) {
        return $('<div>').text(text).html();
    }

    function connectWebSocket() {
        if (socket && (socket.readyState === WebSocket.OPEN || socket.readyState === WebSocket.CONNECTING)) {
            return;
        }

        const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = wsProtocol + '//' + window.location.host + ctx + '/ws/chat';

        socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log('[Inbox WebSocket] Connected successfully');
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

                if (data.type === 'message' || data.type === 'message_edited') {
                    const msg = data.payload;
                    if (msg && msg.conversationId) {
                        updateInboxRow(msg);
                    }
                } else if (data.type === 'conversation_cleared' || data.type === 'message_deleted') {
                    refreshInbox();
                }
            } catch (e) {
                console.error('[Inbox WebSocket] Error parsing message:', e);
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

    function updateInboxRow(msg) {
        const conversationId = String(msg.conversationId);
        let row = $('.chat-row[data-conversation-id="' + conversationId + '"]');

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
            let timeSpan = row.find('.chat-time');
            if (timeSpan.length === 0) {
                row.find('.chat-row-side').prepend('<span class="chat-time">' + timeStr + '</span>');
            } else {
                timeSpan.text(timeStr);
            }
            // Move row to the top of chatList
            $('#chatList').prepend(row);
        } else {
            // New conversation row, refresh inbox list
            refreshInbox();
        }
    }

    function refreshInbox() {
        $.ajax({
            url: ctx + '/api/chat/inbox',
            type: 'GET',
            success: function(items) {
                if (items && items.length) {
                    location.reload();
                }
            }
        });
    }
</script>

</body>
</html>