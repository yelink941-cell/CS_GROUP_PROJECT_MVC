<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${conversationTitle}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        :root {
            --bg-main: #ffffff;
            --panel-bg: #ffffff;
            --border-clean: #e5e7eb;
            --accent-black: #111111;
            --accent-gray: #f5f6f6;
            --text-main: #111111;
            --text-muted: #707579; /* Telegram Style Secondary Muted */
          --bubble-me: #ffffff;
--bubble-me-text: #111111;
            --bubble-other: #f5f6f6;
            --bubble-other-text: #111111;
            --success-color: #00c853;
            --warning-color: #f59e0b;
            --error-color: #ef4444;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body { 
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; 
            background: var(--bg-main); 
            color: var(--text-main); 
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow-x: hidden;
        }

        /* Full Screen Desktop & Mobile App Layout */
        .app-container { 
            width: 100%;
            max-width: 100%; 
            height: 100vh;
            background: var(--panel-bg);
            display: flex; 
            flex-direction: column; 
            overflow: hidden;
            position: relative;
        }

        /* Solid Matte Black Header */
        .header { 
            background: var(--accent-black); 
            border-bottom: 1px solid var(--accent-black);
            padding: 14px 20px; 
            display: flex; 
            align-items: center; 
            gap: 14px; 
            z-index: 10;
            color: #ffffff;
        }

        .header a { 
            color: #ffffff; 
            text-decoration: none; 
            font-size: 20px; 
            transition: opacity 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 50%;
        }

        .header a:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .header-title-container {
            flex: 1;
            min-width: 0;
        }

        .header-title { 
            font-size: 16px; 
            font-weight: 600; 
            color: #ffffff;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .badge-admin { 
            background: rgba(255, 255, 255, 0.2); 
            color: #ffffff; 
            border: 1px solid rgba(255, 255, 255, 0.4);
            font-size: 10px; 
            padding: 2px 6px; 
            border-radius: 6px; 
            font-weight: 600;
        }

        .header-menu-wrap {
            position: relative;
            flex-shrink: 0;
        }

        .header-menu-btn {
            width: 36px;
            height: 36px;
            border: none;
            border-radius: 50%;
            background: transparent;
            color: #ffffff;
            font-size: 22px;
            line-height: 1;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            letter-spacing: 1px;
            transition: background 0.2s;
        }

        .header-menu-btn:hover,
        .header-menu-btn.active {
            background: rgba(255, 255, 255, 0.12);
        }

        .header-dropdown {
            display: none;
            position: absolute;
            top: calc(100% + 8px);
            right: 0;
            min-width: 180px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.18), 0 2px 8px rgba(0, 0, 0, 0.08);
            padding: 6px 0;
            z-index: 120;
            animation: menuPop 0.15s ease-out;
            overflow: hidden;
        }

        .header-dropdown.active {
            display: block;
        }

        .header-dropdown button {
            display: flex;
            align-items: center;
            gap: 12px;
            width: 100%;
            padding: 10px 18px;
            border: none;
            background: transparent;
            font-size: 14px;
            font-family: inherit;
            color: var(--error-color);
            cursor: pointer;
            text-align: left;
        }

        .header-dropdown button:hover {
            background: var(--accent-gray);
        }

        .header-dropdown .menu-icon {
            width: 20px;
            text-align: center;
            font-size: 15px;
        }

        .header-dropdown-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 119;
            background: transparent;
        }

        .header-dropdown-backdrop.active {
            display: block;
        }

        /* Circular Clean Avatar */
        .avatar { 
            width: 38px; 
            height: 38px; 
            border-radius: 50%; 
            background: var(--accent-gray);
            color: var(--text-main); 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-weight: 600; 
            font-size: 14px; 
            flex-shrink: 0; 
            position: relative;
            overflow: hidden;
            border: 1px solid var(--border-clean);
        }

        /* Connection Status */
        .status-container {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: 2px;
        }

        .status-text {
            font-size: 11px;
            color: #b0b5b9;
        }

        .status-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            display: inline-block;
        }

        .status-dot.online {
            background-color: var(--success-color);
        }

        .status-dot.offline {
            background-color: var(--text-muted);
        }

        .status-dot.connecting {
            background-color: var(--warning-color);
            animation: pulse 1.5s infinite;
        }

        /* Chat Box Frame */
        #chatBox { 
            flex: 1; 
            overflow-y: auto; 
            padding: 20px 24px; 
            display: flex;
            flex-direction: column;
            gap: 10px;
            background: var(--bg-main);
        }

        #chatBox::-webkit-scrollbar {
            width: 5px;
        }
        #chatBox::-webkit-scrollbar-thumb {
            background: var(--border-clean);
            border-radius: 10px;
        }

        /* Telegram-like Message Rows */
        .message-row {
            display: flex;
            width: 100%;
            margin: 1px 0;
            animation: fadeInUp 0.25s ease-out forwards;
            gap: 10px;
            align-items: flex-end;
        }

        .message-row.me { justify-content: flex-end; }
        .message-row.other { justify-content: flex-start; }

        /* Minimalist High-Contrast Bubbles */
        .bubble { 
            max-width: 65%; 
            padding: 10px 14px 8px; 
            border-radius: 16px; 
            word-wrap: break-word; 
            position: relative;
            font-size: 14px;
            line-height: 1.5;
            cursor: pointer;
            user-select: none;
        }

        .bubble.me { 
            background: var(--bubble-me); 
            color: var(--bubble-me-text);
            border-bottom-right-radius: 4px;
        }

        .bubble.other { 
            background: var(--bubble-other); 
            color: var(--bubble-other-text);
            border: 1px solid var(--border-clean);
            border-bottom-left-radius: 4px;
        }

        .bubble-meta { 
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 10px; 
            margin-bottom: 4px;
            font-weight: 600;
        }

.bubble.me .bubble-meta { color: var(--accent-black); }        .bubble.other .bubble-meta { color: var(--text-muted); }

        .bubble-time {
            font-size: 9px;
            margin-left: 10px;
            opacity: 0.8;
            align-self: flex-end;
            text-align: right;
            display: block;
            margin-top: 4px;
        }

.bubble.me .bubble-time { color: var(--text-muted); }        .bubble.other .bubble-time { color: var(--text-muted); }

        .reply-preview {
            border-left: 3px solid var(--accent-black);
            padding: 4px 8px;
            margin-bottom: 6px;
            background: rgba(0, 0, 0, 0.04);
            border-radius: 4px;
            font-size: 12px;
            color: var(--text-muted);
        }

        .reply-bar {
            display: none;
            align-items: center;
            gap: 8px;
            padding: 8px 12px;
            background: var(--accent-gray);
            border-top: 1px solid var(--border-clean);
            font-size: 12px;
        }

        .reply-bar.active { display: flex; }

        .reply-bar-text {
            flex: 1;
            min-width: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: var(--text-muted);
        }

        .msg-context-backdrop {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 200;
            background: transparent;
        }
        .msg-context-backdrop.active { display: block; }

        .msg-context-menu {
            display: none;
            position: fixed;
            z-index: 201;
            min-width: 180px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.18), 0 2px 8px rgba(0, 0, 0, 0.08);
            padding: 6px 0;
            animation: menuPop 0.15s ease-out;
            overflow: hidden;
        }
        .msg-context-menu.active { display: block; }

        .msg-context-menu button {
            display: flex;
            align-items: center;
            gap: 12px;
            width: 100%;
            padding: 10px 18px;
            border: none;
            background: transparent;
            font-size: 14px;
            font-family: inherit;
            color: var(--text-main);
            cursor: pointer;
            text-align: left;
        }
        .msg-context-menu button:hover {
            background: var(--accent-gray);
        }
        .msg-context-menu button.danger {
            color: var(--error-color);
        }
        .msg-context-menu .menu-icon {
            width: 20px;
            text-align: center;
            font-size: 15px;
            opacity: 0.85;
        }
        .msg-context-menu .menu-divider {
            height: 1px;
            background: var(--border-clean);
            margin: 4px 0;
        }

        @keyframes menuPop {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }

        .bubble-media-container video {
            cursor: default;
        }

        .read-receipt {
            font-size: 10px;
            margin-left: 4px;
            color: var(--success-color);
        }

        .edited-label {
            font-size: 10px;
            color: var(--text-muted);
            font-style: italic;
            margin-left: 4px;
        }

        /* Clean Minimalist Input Area */
        .footer { 
            background: var(--panel-bg); 
            padding: 14px 24px; 
            display: flex; 
            flex-direction: column;
            gap: 8px;
            border-top: 1px solid var(--border-clean); 
        }

        .input-row {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .input-row input[type=text] { 
            flex: 1; 
            border: 1px solid var(--border-clean); 
            border-radius: 12px; 
            padding: 12px 16px; 
            font-size: 14px; 
            outline: none; 
            background: var(--accent-gray);
            color: var(--text-main);
            transition: all 0.2s ease;
        }

        .input-row input[type=text]:focus { 
            border-color: var(--accent-black);
            background: var(--panel-bg);
        }

        /* Icon Buttons Styles */
        .icon-btn { 
            width: 42px; 
            height: 42px; 
            border: none; 
            border-radius: 12px; 
            background: var(--accent-black); 
            color: #ffffff; 
            font-size: 16px; 
            cursor: pointer; 
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0; 
            transition: opacity 0.2s ease;
        }

        .icon-btn:hover { opacity: 0.9; }

        .icon-btn.attach { 
            background: transparent; 
            border: 1px solid var(--border-clean);
            color: var(--text-muted);
        }

        .icon-btn.attach:hover {
            background: var(--accent-gray);
            color: var(--text-main);
        }

        .icon-btn:disabled { 
            opacity: 0.3; 
            cursor: not-allowed; 
        }

        #mediaFile { display: none; }

        /* Attachment Previews Horizontal Panel */
        .attachment-preview-container {
            display: none;
            background: var(--accent-gray);
            border: 1px solid var(--border-clean);
            border-radius: 12px;
            padding: 10px;
            gap: 12px;
            overflow-x: auto;
            position: relative;
        }

        .attachment-preview-container::-webkit-scrollbar { height: 4px; }
        .attachment-preview-container::-webkit-scrollbar-thumb { background: var(--border-clean); }

        .preview-card {
            position: relative; 
            width: 60px; 
            height: 60px; 
            flex-shrink: 0; 
            border-radius: 8px; 
            border: 1px solid var(--border-clean); 
            overflow: hidden; 
            background: #fafafa;
        }

        /* Fixed Flash Issue by adding style="display: none;" */
        .upload-hint { 
            font-size: 12px; 
            color: var(--warning-color); 
            display: none; 
            align-items: center;
            gap: 6px;
            font-weight: 600;
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.1); opacity: 0.6; }
            100% { transform: scale(1); opacity: 1; }
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
        /* Chat image pointer styling */
.bubble-media-container img {
    cursor: pointer;
    transition: opacity 0.2s ease;
}
.bubble-media-container img:hover {
    opacity: 0.9;
}

/* Lightbox modal for enlarged image view */
.image-lightbox-modal {
    display: none;
    position: fixed;
    z-index: 9999;
    left: 0; top: 0; width: 100%; height: 100%;
    background-color: rgba(0, 0, 0, 0.93);
    justify-content: center; align-items: center;
    cursor: zoom-out;
}
.lightbox-content {
    max-width: 92%; max-height: 92%;
    object-fit: contain; border-radius: 4px;
    animation: zoomEffect 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
.lightbox-close {
    position: absolute; top: 20px; right: 25px;
    color: #ffffff; font-size: 32px; font-weight: 300;
    cursor: pointer; line-height: 1; transition: opacity 0.2s;
}
.lightbox-close:hover { opacity: 0.7; }

@keyframes zoomEffect {
    from { transform: scale(0.95); opacity: 0; }
    to { transform: scale(1); opacity: 1; }
}
/* Floating Scroll to Bottom Button */
.scroll-bottom-btn {
    display: none; /* hidden initially */
    position: absolute;
    bottom: 85px; /* position above the message input area */
    right: 20px;
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: var(--accent-black);
    color: #ffffff;
    border: 1px solid var(--border-clean);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
    cursor: pointer;
    align-items: center;
    justify-content: center;
    font-size: 16px;
    z-index: 99;
    transition: all 0.2s ease;
}
.scroll-bottom-btn:hover {
    transform: translateY(-2px);
    opacity: 0.9;
}
        .blocked-banner {
            background: var(--accent-black);
            color: #ffffff;
            padding: 14px 20px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 14px;
            font-weight: 500;
        }
        .blocked-banner.muted {
            background: var(--accent-gray);
            color: var(--text-muted);
            justify-content: center;
            text-align: center;
            border: 1px solid var(--border-clean);
        }
        .banner-unblock-btn {
            background: #ffffff;
            color: var(--accent-black);
            border: none;
            padding: 7px 18px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 13px;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .banner-unblock-btn:hover { opacity: 0.9; }
    </style>
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="app-container">
    <div class="header">
        <a href="${ctx}/chat" id="btnBack">←</a>
        <c:if test="${!isGroup && not empty partnerUserId}">
            <div class="avatar" style="width:34px; height:34px;">
                <img src="${ctx}/user/avatar/${partnerUserId}" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';" class="avatar-img" alt="avatar" style="width:100%; height:100%; object-fit:cover; border-radius:50%;" />
                <div class="avatar-initials" style="display:none; width:100%; height:100%; border-radius:50%; align-items:center; justify-content:center; background: var(--border-clean); color: var(--text-main);">
                    ${conversationTitle.substring(0,1).toUpperCase()}
                </div>
            </div>
        </c:if>
        <div class="header-title-container">
            <div class="header-title" id="roomTitle">
                <c:choose>
                    <c:when test="${isGroup}"> ${conversationTitle}</c:when>
                    <c:otherwise>
                        <c:out value="${conversationTitle}" />
                        <c:if test="${partnerRole == 'ADMIN'}"><span class="badge-admin">Admin</span></c:if>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="status-container">
                <c:choose>
                    <c:when test="${isGroup}">
                        <span id="statusDot" class="status-dot connecting"></span>
                        <span id="statusText" class="status-text">Connecting...</span>
                    </c:when>
                    <c:otherwise>
                        <span id="statusDot" class="status-dot ${partnerOnline ? 'online' : 'offline'}"></span>
                        <span id="statusText" class="status-text">${partnerOnline ? 'Online' : (not empty partnerLastSeenFormatted ? partnerLastSeenFormatted : 'Offline')}</span>
                    </c:otherwise>
                </c:choose>
                <span id="typingIndicator" class="status-text" style="color: var(--success-color); font-weight: 500; margin-left: 4px;"></span>
            </div>
        </div>
        <div class="header-menu-wrap">
            <button type="button" id="btnHeaderMenu" class="header-menu-btn" title="More options" aria-label="More options">&#8942;</button>
            <div id="headerDropdown" class="header-dropdown">
                <c:if test="${!isGroup && not empty partnerUserId}">
                    <c:choose>
                        <c:when test="${blockedByMe}">
                            <button type="button" id="btnUnblockUserHeader" style="color:var(--text-main);">
                                <span class="menu-icon">🔓</span>
                                Unblock user
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" id="btnBlockUserHeader">
                                <span class="menu-icon">🚫</span>
                                Block user
                            </button>
                        </c:otherwise>
                    </c:choose>
                </c:if>
                <button type="button" id="btnDeleteChat">
                    <span class="menu-icon">🗑</span>
                    Delete chat
                </button>
            </div>
        </div>
    </div>
    <div id="headerDropdownBackdrop" class="header-dropdown-backdrop"></div>

    <div id="chatBox"></div>

    <div class="footer">
        <c:choose>
            <c:when test="${blockedEitherWay}">
                <c:choose>
                    <c:when test="${blockedByMe}">
                        <div class="blocked-banner">
                            <span>You blocked this user.</span>
                            <button type="button" id="btnFooterUnblock" class="banner-unblock-btn">UNBLOCK</button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="blocked-banner muted">
                            <span>You cannot send messages to this user because you are blocked.</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <div id="uploadHint" class="upload-hint" style="display: none;">
                    <span class="status-dot connecting" style="width:6px;height:6px;"></span> Sending media files...
                </div>

                <div id="attachmentPreview" class="attachment-preview-container"></div>

                <div id="replyBar" class="reply-bar">
                    <span>↩ Reply:</span>
                    <span id="replyBarText" class="reply-bar-text"></span>
                    <button type="button" id="btnCancelReply" style="background:transparent;border:none;cursor:pointer;">✕</button>
                </div>

                <div class="input-row">
                    <input type="file" id="mediaFile" accept="image/*,video/*,audio/*,.pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.txt,.csv,.md,.json,.xml,.zip,.rar,.7z" multiple>
                    <button type="button" class="icon-btn attach" id="btnAttach" title="Attach Files">📎</button>
                    <input type="text" id="messageText" placeholder="Type a message..." autocomplete="off">
                    <button type="button" class="icon-btn" id="btnSend" title="Send">➤</button>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
<div id="imageLightbox" class="image-lightbox-modal">
    <span class="lightbox-close">&times;</span>
    <img class="lightbox-content" id="lightboxTargetImg" alt="Enlarged Chat Frame">
</div>
<button type="button" id="btnScrollBottom" class="scroll-bottom-btn">↓</button>
<div id="msgContextBackdrop" class="msg-context-backdrop"></div>
<div id="msgContextMenu" class="msg-context-menu"></div>

<script>
    const ctx = '${ctx}';
    const chatId = '${conversationId}';
    const myUserId = '${currentUser.id}';
    const partnerUserId = '${partnerUserId}';
    const blockedByMe = ${blockedByMe};
    const blockedByPartner = ${blockedByPartner};
    const blockedEitherWay = ${blockedEitherWay};
    const canModerate = ${canModerate};
    const partnerDisplayName = '<c:out value="${conversationTitle}" />';
    
    let socket = null;
    let isReconnecting = false;
    let selectedFiles = [];
    let replyToMessage = null;
    let editingMessageId = null;
    let contextMenuMessage = null;

    $(document).ready(function() {
        // DEBUG: Check chatId and myUserId in console
        console.log('[DEBUG] chatId:', chatId, '| myUserId:', myUserId, '| ctx:', ctx);
        if (!chatId || chatId === '' || chatId === 'null') {
            $('#chatBox').html('<div style="padding:20px;color:red;">❌ ERROR: conversationId not found (chatId=' + chatId + ')</div>');
            return;
        }
        loadChatHistory();
        connectWebSocket();
        pollInterval = setInterval(pollNewMessages, 4000);
        
        $('#btnSend').click(handleSend);
        $('#btnAttach').click(function() { $('#mediaFile').click(); });
        $('#mediaFile').change(handleFileSelect);
        
        $('#messageText').keypress(function(e) {
            if (e.which === 13) handleSend();
        });
     // typing logic
        let typingTimeout;

        $('#messageText').on('input', function() {
            if (socket && socket.readyState === WebSocket.OPEN) {
                socket.send(JSON.stringify({
                    type: 'user_typing',
                    conversationId: chatId,
                    senderId: myUserId
                }));
            }

            clearTimeout(typingTimeout);

            typingTimeout = setTimeout(function() {
                if (socket && socket.readyState === WebSocket.OPEN) {
                    socket.send(JSON.stringify({
                        type: 'user_stopped_typing',
                        conversationId: chatId,
                        senderId: myUserId
                    }));
                }
            }, 1500);
        });

        $('#messageText').blur(function() {
            clearTimeout(typingTimeout);
            if (socket && socket.readyState === WebSocket.OPEN) {
                socket.send(JSON.stringify({
                    type: 'user_stopped_typing',
                    conversationId: chatId,
                    senderId: myUserId
                }));
            }
        });
        $('#btnCancelReply').click(cancelReply);
     // Scroll to bottom button
        $('#chatBox').scroll(function() {
            if ($(this).scrollTop() + $(this).innerHeight() < $(this)[0].scrollHeight - 100) {
                $('#btnScrollBottom').css('display', 'flex');
            } else {
                $('#btnScrollBottom').hide();
            }
        });

        $('#btnScrollBottom').click(function() {
            scrollToBottom();
        });

        $(document).on('click', '.bubble-media-container img', function() {
            const imgSrc = $(this).attr('src');
            $('#lightboxTargetImg').attr('src', imgSrc);
            $('#imageLightbox').css('display', 'flex');
        });

        $('#imageLightbox, .lightbox-close').click(function() {
            $('#imageLightbox').hide();
            $('#lightboxTargetImg').attr('src', ''); 
        });

        $(document).on('click', '.bubble', function(e) {
            if ($(e.target).closest('.bubble-media-container img, .bubble-media-container video').length) return;
            if ($(e.target).is('a, button, input, video')) return;
            var row = $(this).closest('.message-row');
            var msg = row.data('msg');
            if (msg) openMessageContextMenu(msg, this);
        });

        $('#msgContextBackdrop').click(closeMessageContextMenu);

        $('#msgContextMenu').on('click', 'button', function(e) {
            e.stopPropagation();
            var action = $(this).data('action');
            var msg = contextMenuMessage;
            closeMessageContextMenu();
            if (!msg) return;
            if (action === 'reply') startReply(msg);
            else if (action === 'edit') startEdit(msg);
            else if (action === 'delete') deleteMessage(msg);
        });

        $(document).keydown(function(e) {
            if (e.key === 'Escape') {
                closeMessageContextMenu();
                closeHeaderMenu();
            }
        });

        $('#btnHeaderMenu').click(function(e) {
            e.stopPropagation();
            toggleHeaderMenu();
        });

        $('#headerDropdownBackdrop').click(closeHeaderMenu);

        $('#btnDeleteChat').click(function(e) {
            e.stopPropagation();
            closeHeaderMenu();
            deleteChat();
        });

        $('#btnBlockUserHeader').click(function(e) {
            e.stopPropagation();
            closeHeaderMenu();
            blockPartnerUser();
        });

        $('#btnUnblockUserHeader, #btnFooterUnblock').click(function(e) {
            e.stopPropagation();
            closeHeaderMenu();
            unblockPartnerUser();
        });

    });
 
    function scrollToBottom() {
        var box = $('#chatBox');
        if (box.length) {
            box.animate({ scrollTop: box[0].scrollHeight }, 300);
        }
    }

    function updateConnectionStatus(status) {
        const isGroupRoom = ${isGroup};
        if (isGroupRoom) {
            const dot = $('#statusDot');
            const text = $('#statusText');
            dot.removeClass('online offline connecting');
            
            if (status === 'online') {
                dot.addClass('online');
                text.text('Online');
            } else if (status === 'connecting') {
                dot.addClass('connecting');
                text.text('Connecting...');
            } else {
                dot.addClass('offline');
                text.text('Offline');
            }
        }
    }

    let reconnectTimer = null;
    let pollInterval = null;

    function connectWebSocket() {
        if (socket && (socket.readyState === WebSocket.OPEN || socket.readyState === WebSocket.CONNECTING)) {
            return;
        }

        const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = wsProtocol + '//' + window.location.host + ctx + '/ws/chat';
        
        updateConnectionStatus('connecting');
        socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log('[WebSocket] Connected successfully');
            updateConnectionStatus('online');
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
                    const partnerId = '${partnerUserId}';
                    if (partnerId && String(data.payload.userId) === String(partnerId)) {
                        const dot = $('#statusDot');
                        const text = $('#statusText');
                        dot.removeClass('online offline connecting');
                        if (data.payload.isOnline) {
                            dot.addClass('online');
                            text.text('Online');
                        } else {
                            dot.addClass('offline');
                            text.text(data.payload.lastSeenFormatted || 'Offline');
                        }
                    }
                    return;
                }

                if (data.type === 'user_typing') {
                    if (data.payload && String(data.payload.conversationId) === String(chatId) && String(data.payload.senderId) !== String(myUserId)) {
                        const senderName = data.payload.senderName || 'User';
                        $('#typingIndicator').text(senderName + ' is typing...');
                    }
                    return;
                }

                if (data.type === 'user_stopped_typing') {
                    if (data.payload && String(data.payload.conversationId) === String(chatId)) {
                        $('#typingIndicator').text('');
                    }
                    return;
                }

                if (data.type === 'message_edited' && data.payload) {
                    updateMessageDom(data.payload);
                    return;
                }

                if (data.type === 'message_reaction' && data.payload) {
                    updateMessageReactions(data.payload);
                    return;
                }

                if (data.type === 'message_deleted' && data.payload) {
                    if (String(data.payload.conversationId) === String(chatId)) {
                        removeMessageDom(data.payload.messageId);
                    }
                    return;
                }

                if (data.type === 'conversation_cleared' && data.payload) {
                    if (String(data.payload.conversationId) === String(chatId)) {
                        clearChatBox();
                    }
                    return;
                }

                if (data.type === 'messages_read' && data.payload) {
                    applyReadReceipt(data.payload);
                    return;
                }

                const msg = data.type === 'message' ? data.payload : data;
                if (!msg || !msg.conversationId) return;

                const msgChatId = String(msg.conversationId);
                if (msgChatId === String(chatId)) {
                    if ($('#msg-' + msg.id).length === 0) {
                        appendMessage(msg);
                        scrollToBottom();
                        markReadUpTo(msg.id);
                    }
                }
            } catch (e) {
                console.error('Failed to parse socket message:', e);
            }
        };

        socket.onclose = function(e) {
            console.log('[WebSocket] Closed, scheduling reconnect...');
            updateConnectionStatus('offline');
            if (reconnectTimer) clearTimeout(reconnectTimer);
            reconnectTimer = setTimeout(connectWebSocket, 3000);
        };

        socket.onerror = function(err) {
            console.error('[WebSocket] Error occurred');
            updateConnectionStatus('offline');
            try { socket.close(); } catch(e) {}
        };
    }

    function pollNewMessages() {
        if (!chatId) return;
        $.ajax({
            url: ctx + '/api/chat/history',
            type: 'GET',
            data: { conversationId: chatId },
            success: function(messages) {
                if (messages && messages.length) {
                    let hasNew = false;
                    const reversed = messages.slice().reverse();
                    reversed.forEach(function(msg) {
                        if ($('#msg-' + msg.id).length === 0) {
                            appendMessage(msg);
                            hasNew = true;
                        }
                    });
                    if (hasNew) {
                        scrollToBottom();
                    }
                }
            }
        });
    }

    function loadChatHistory() {
        console.log('[DEBUG] loadChatHistory() called, URL:', ctx + '/api/chat/history?conversationId=' + chatId);
        $.ajax({
            url: ctx + '/api/chat/history',
            type: 'GET',
            data: { conversationId: chatId },
            success: function(messages) {
                console.log('[DEBUG] history loaded:', messages.length, 'messages', messages);
                $('#chatBox').empty();
                if (messages.length === 0) {
                	$('#chatBox').html(
                            '<div id="emptyChat" style="text-align:center;padding:40px;color:var(--text-muted);">No messages yet. Send the first message 👋</div>'
                        );
                
                } else {
                    messages.reverse().forEach(appendMessage);
                    scrollToBottom();
                    markReadUpTo(messages[messages.length - 1].id);
                }
            },
            error: function(xhr) {
                console.error('[DEBUG] history error:', xhr.status, xhr.responseText);
                $('#chatBox').html('<div style="padding:20px;color:red;">❌ Failed to load messages (' + xhr.status + '): ' + xhr.responseText + '</div>');
            }
        });
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
        $('#btnSend').attr('title', 'Save edit');
    }

    function cancelEdit() {
        editingMessageId = null;
        $('#messageText').val('');
        $('#btnSend').attr('title', 'Send');
    }

    function startReply(msg) {
        editingMessageId = null;
        replyToMessage = msg;
        $('#replyBarText').text(msg.messageText || msg.parentMessagePreview || 'Message');
        $('#replyBar').addClass('active');
        $('#messageText').focus();
    }

    function cancelReply() {
        replyToMessage = null;
        $('#replyBar').removeClass('active');
        $('#replyBarText').text('');
    }

    function markReadUpTo(messageId) {
        $.ajax({
            url: ctx + '/api/chat/messages/read',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ conversationId: Number(chatId), upToMessageId: messageId })
        });
    }

    function applyReadReceipt(payload) {
        if (!payload || String(payload.conversationId) !== String(chatId)) return;
        $('[data-sender-me="true"]').each(function() {
            const row = $(this);
            if (Number(row.attr('data-msg-id')) <= Number(payload.upToMessageId)) {
                row.find('.read-receipt').text('✓✓');
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

    function escapeHtml(text) {
        return $('<div/>').text(text).html();
    }

    function getMessageActions(msg) {
        var isMe = String(msg.senderId) === String(myUserId);
        var hasText = msg.messageText && msg.messageText.trim().length > 0;
        var actions = [{ id: 'reply', label: 'Reply', icon: '↩' }];
        if (isMe) {
            if (hasText) actions.push({ id: 'edit', label: 'Edit', icon: '✎' });
            actions.push({ id: 'delete', label: 'Delete', icon: '🗑', danger: true });
        } else {
            if (canModerate) actions.push({ id: 'delete', label: 'Delete', icon: '🗑', danger: true });
        }
        return actions;
    }

    function openMessageContextMenu(msg, anchorEl) {
        closeMessageContextMenu();
        contextMenuMessage = msg;
        var menu = $('#msgContextMenu');
        menu.empty();

        var quickBar = $('<div class="quick-reaction-bar" style="display:flex; justify-content:space-around; align-items:center; padding:8px 12px; border-bottom:1px solid var(--border-clean, #334155);"></div>');
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

        getMessageActions(msg).forEach(function(action, idx) {
            if (action.danger && idx > 0) {
                menu.append('<div class="menu-divider"></div>');
            }
            var btn = $('<button type="button"></button>')
                .addClass(action.danger ? 'danger' : '')
                .html('<span class="menu-icon">' + action.icon + '</span>' + action.label)
                .data('action', action.id);
            menu.append(btn);
        });

        menu.addClass('active');
        var rect = anchorEl.getBoundingClientRect();
        var menuW = menu.outerWidth();
        var menuH = menu.outerHeight();
        var top = rect.top - menuH - 8;
        if (top < 8) top = rect.bottom + 8;
        var left = String(msg.senderId) === String(myUserId) ? rect.right - menuW : rect.left;
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
                alert('Reaction failed: ' + (xhr.responseText || 'Error'));
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
            var reactionsEl = renderReactionsHtml(msg);
            bubble.append(reactionsEl);
        }
    }

    function renderReactionsHtml(msg) {
        var reactionsContainer = $('<div class="message-reactions" style="display:flex; flex-wrap:wrap; gap:4px; margin-top:4px;"></div>');
        if (msg.reactions && msg.reactions.length) {
            msg.reactions.forEach(function(r) {
                var hasUserReacted = r.userIds && r.userIds.map(String).includes(String(myUserId));
                var badge = $('<span class="reaction-badge ' + (hasUserReacted ? 'user-reacted' : '') + '" style="display:inline-flex; align-items:center; gap:3px; background:' + (hasUserReacted ? 'rgba(56, 189, 248, 0.25)' : 'rgba(255, 255, 255, 0.15)') + '; border:1px solid ' + (hasUserReacted ? '#38bdf8' : 'rgba(255, 255, 255, 0.2)') + '; border-radius:12px; padding:2px 7px; font-size:12px; cursor:pointer; user-select:none;"></span>')
                    .html(r.emoji + ' <span style="font-size:11px; opacity:0.9;">' + r.count + '</span>')
                    .click(function(e) {
                        e.stopPropagation();
                        toggleReaction(msg.id, r.emoji);
                    });
                reactionsContainer.append(badge);
            });
        }
        return reactionsContainer;
    }

    function deleteMessage(msg) {
        if (!confirm('Are you sure you want to delete this message?')) return;
        $.ajax({
            url: ctx + '/api/chat/messages/' + msg.id,
            type: 'DELETE',
            success: function() { removeMessageDom(msg.id); },
            error: function(xhr) { alert('Delete failed: ' + xhr.responseText); }
        });
    }

    function removeMessageDom(messageId) {
        $('#msg-' + messageId).fadeOut(200, function() { $(this).remove(); });
    }

    function clearChatBox() {
        $('#chatBox').empty().html(
            '<div style="text-align:center;padding:40px;color:var(--text-muted);">No messages yet. Send the first message 👋</div>'
        );
    }

    function toggleHeaderMenu() {
        var isOpen = $('#headerDropdown').hasClass('active');
        if (isOpen) {
            closeHeaderMenu();
        } else {
            closeMessageContextMenu();
            $('#headerDropdown').addClass('active');
            $('#headerDropdownBackdrop').addClass('active');
            $('#btnHeaderMenu').addClass('active');
        }
    }

    function closeHeaderMenu() {
        $('#headerDropdown').removeClass('active');
        $('#headerDropdownBackdrop').removeClass('active');
        $('#btnHeaderMenu').removeClass('active');
    }

    function deleteChat() {
        if (!confirm('Are you sure you want to delete this chat from your inbox?')) return;
        $.ajax({
            url: ctx + '/api/chat/conversations/' + chatId,
            type: 'DELETE',
            success: function() {
                window.location.href = ctx + '/chat';
            },
            error: function(xhr) {
                alert('Chat delete failed: ' + xhr.responseText);
            }
        });
    }

    function blockPartnerUser() {
        if (!partnerUserId) return;
        if (!confirm('Are you sure you want to block this user?')) return;
        $.ajax({
            url: ctx + '/api/chat/users/' + partnerUserId + '/block',
            type: 'POST',
            success: function() {
                location.reload();
            },
            error: function(xhr) {
                alert('Block failed: ' + xhr.responseText);
            }
        });
    }

    function unblockPartnerUser() {
        if (!partnerUserId) return;
        if (!confirm('Are you sure you want to unblock this user?')) return;
        $.ajax({
            url: ctx + '/api/chat/users/' + partnerUserId + '/unblock',
            type: 'POST',
            success: function() {
                location.reload();
            },
            error: function(xhr) {
                alert('Unblock failed: ' + xhr.responseText);
            }
        });
    }

    function sendTextFallback(text) {
        console.log('[DEBUG] sendTextFallback(), chatId:', chatId, 'text:', text);
        $('#btnSend').prop('disabled', true);
        $.ajax({
            url: ctx + '/api/chat/messages',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                conversationId: Number(chatId),
                text: text,
                parentMessageId: replyToMessage ? replyToMessage.id : null
            }),
            success: function(newMsg) {
                console.log('[DEBUG] message sent OK:', newMsg);
                if ($('#msg-' + newMsg.id).length === 0) {
                    appendMessage(newMsg);
                    scrollToBottom();
                }
                $('#messageText').val('');
                cancelReply();
            },
            error: function(xhr) {
                console.error('[DEBUG] send error:', xhr.status, xhr.responseText);
                alert('❌ Failed to send message (' + xhr.status + '): ' + xhr.responseText);
            },
            complete: function() { $('#btnSend').prop('disabled', false); }
        });
    }

    function handleFileSelect() {
        const fileInput = $('#mediaFile')[0];
        if (!fileInput.files || !fileInput.files.length) return;

        for (let i = 0; i < fileInput.files.length; i++) {
            selectedFiles.push(fileInput.files[i]);
        }
        $('#mediaFile').val('');
        renderPreviews();
    }

    function renderPreviews() {
        const container = $('#attachmentPreview').empty();
        if (selectedFiles.length === 0) {
            container.hide();
            return;
        }

        selectedFiles.forEach((file, index) => {
            const card = $('<div class="preview-card"></div>');
            const closeBtn = $('<button type="button" style="position:absolute; top:3px; right:3px; background:#ef4444; border:none; border-radius:50%; width:16px; height:16px; color:#fff; font-size:10px; font-weight:bold; cursor:pointer; display:flex; align-items:center; justify-content:center; z-index:5;">×</button>');
            
            closeBtn.click(function(e) {
                e.stopPropagation();
                removeFile(index);
            });
            card.append(closeBtn);

            if (file.type.startsWith('image/')) {
                const img = $('<img style="width:100%; height:100%; object-fit:cover;" />');
                const reader = new FileReader();
                reader.onload = function(e) { img.attr('src', e.target.result); };
                reader.readAsDataURL(file);
                card.append(img);
            } else if (file.type.startsWith('video/')) {
                const vid = $('<video style="width:100%; height:100%; object-fit:cover;"></video>');
                vid.attr('src', URL.createObjectURL(file));
                card.append(vid);
            } else {
                let icon = '📄';
                const name = file.name.toLowerCase();
                if (name.endsWith('.pdf')) icon = '📕';
                else if (name.endsWith('.doc') || name.endsWith('.docx')) icon = '📘';
                else if (name.endsWith('.xls') || name.endsWith('.xlsx') || name.endsWith('.csv')) icon = '📊';
                else if (name.endsWith('.ppt') || name.endsWith('.pptx')) icon = '📙';
                else if (name.endsWith('.zip') || name.endsWith('.rar') || name.endsWith('.7z')) icon = '📦';
                else if (name.endsWith('.txt') || name.endsWith('.md')) icon = '📝';
                else if (file.type.startsWith('audio/')) icon = '🎵';

                card.append('<div style="width:100%; height:100%; display:flex; flex-direction:column; align-items:center; justify-content:center; padding:4px; text-align:center; background:#f1f5f9;"><span style="font-size:20px;">' + icon + '</span><span style="font-size:9px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; max-width:100%; font-weight:600; color:#334155;">' + escapeHtml(file.name) + '</span></div>');
            }
            container.append(card);
        });
        container.css('display', 'flex');
    }

    function removeFile(index) {
        selectedFiles.splice(index, 1);
        renderPreviews();
    }

    function clearAttachmentPreview() {
        selectedFiles = [];
        $('#mediaFile').val('');
        $('#attachmentPreview').hide().empty();
    }

    function sendMedia(caption) {
        if (selectedFiles.length === 0) return;

        var formData = new FormData();
        formData.append('conversationId', chatId);
        selectedFiles.forEach(function(file) { formData.append('files', file); });
        if (caption) formData.append('caption', caption);

        $('#btnAttach, #btnSend').prop('disabled', true);
        $('#uploadHint').css('display', 'flex');

        $.ajax({
            url: ctx + '/api/chat/messages/media',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(newMsg) {
                if ($('#msg-' + newMsg.id).length === 0) {
                    appendMessage(newMsg);
                    scrollToBottom();
                }
                $('#messageText').val('');
                clearAttachmentPreview();
            },
            error: function(xhr) {
                alert('Media sending is fail\n' + xhr.responseText);
            },
            complete: function() {
                $('#btnAttach, #btnSend').prop('disabled', false);
                $('#uploadHint').css('display', 'none'); // Explicit hidden rewrite
            }
        });
    }

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
                '<div class="avatar-initials" style="display:none; width:100%; height:100%; border-radius:50%; align-items:center; justify-content:center; background: var(--accent-gray); color: var(--text-main);">' +
                    'U' +
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

        // Clean Collage Design for Media Files & File Cards for Documents
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
                    var mediaWrapper = $('<div style="width:100%; max-width:320px; border-radius: 8px; overflow: hidden; border: 1px solid var(--border-clean); background: var(--accent-gray);"></div>');
                    mediaWrapper.append('<video controls src="' + url + '" style="width:100%; display:block; max-height:220px; object-fit:cover;"></video>');
                    mediaContainer.append(mediaWrapper);
                } else if (isImage) {
                    var mediaWrapper = $('<div style="width:100%; max-width:320px; border-radius: 8px; overflow: hidden; border: 1px solid var(--border-clean); background: var(--accent-gray);"></div>');
                    mediaWrapper.append('<img src="' + url + '" alt="photo" style="width:100%; display:block; max-height:240px; object-fit:cover; cursor:pointer;" onclick="openLightbox(\'' + url + '\')"/>');
                    mediaContainer.append(mediaWrapper);
                } else if (isAudio) {
                    var mediaWrapper = $('<div style="width:100%; max-width:300px; padding:6px; border-radius:8px; background:var(--accent-gray); border:1px solid var(--border-clean);"></div>');
                    mediaWrapper.append('<audio controls src="' + url + '" style="width:100%; height:36px;"></audio>');
                    mediaContainer.append(mediaWrapper);
                } else {
                    // Document / File Card Design
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
                    else if (fileUrl.match(/\.(txt|md|json|xml)$/i)) icon = '📝';

                    var sizeText = att.fileSize ? (' • ' + Math.round(att.fileSize / 1024) + ' KB') : '';

                    var bgStyle = isMe ? 'background: rgba(255,255,255,0.18); border: 1px solid rgba(255,255,255,0.3); color:#ffffff;' : 'background: #f1f5f9; border: 1px solid #cbd5e1; color:#1e293b;';
                    var btnStyle = isMe ? 'background: #ffffff; color: #4038ff;' : 'background: #4038ff; color: #ffffff;';

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
            } catch(e) { console.error(e); }
        }
        var timeHtml = '<span class="bubble-time">' + timeStr;
        if (msg.edited) {
            timeHtml += '<span class="edited-label">edited</span>';
        }
        if (isMe) {
            var readMark = (msg.readCount && msg.readCount > 0) ? '✓✓' : '✓';
            timeHtml += '<span class="read-receipt">' + readMark + '</span>';
        }
        timeHtml += '</span>';
        bubble.append(timeHtml);

        if (msg.reactions && msg.reactions.length) {
            bubble.append(renderReactionsHtml(msg));
        }

        row.append(bubble);
        $('#chatBox').append(row);
    }

 
</script>

</body>
</html>