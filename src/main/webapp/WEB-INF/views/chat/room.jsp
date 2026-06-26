<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="my">
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
            --bubble-me: #111111;
            --bubble-me-text: #ffffff;
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

        .bubble.me .bubble-meta { color: rgba(255, 255, 255, 0.7); }
        .bubble.other .bubble-meta { color: var(--text-muted); }

        .bubble-time {
            font-size: 9px;
            margin-left: 10px;
            opacity: 0.8;
            align-self: flex-end;
            text-align: right;
            display: block;
            margin-top: 4px;
        }

        .bubble.me .bubble-time { color: rgba(255, 255, 255, 0.6); }
        .bubble.other .bubble-time { color: var(--text-muted); }

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
        /* ၁။ Chat ထဲက ပုံတွေကို Pointer ပြောင်းရန် */
.bubble-media-container img {
    cursor: pointer;
    transition: opacity 0.2s ease;
}
.bubble-media-container img:hover {
    opacity: 0.9;
}

/* ၂။ ပုံကြီးပြပေးမည့် မျက်နှာပြင် (Lightbox) စတိုင် */
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
    display: none; /* စစချင်းမှာ ဝှက်ထားမည် */
    position: absolute;
    bottom: 85px; /* စာရိုက်တဲ့ Input Area ရဲ့ အပေါ်နားတင် ပေါ်ရန် */
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
                    <c:when test="${isGroup}">📁 ${conversationTitle}</c:when>
                    <c:otherwise>
                        ${conversationTitle}
                        <c:if test="${partnerRole == 'ADMIN'}"><span class="badge-admin">Admin</span></c:if>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="status-container">
                <span id="statusDot" class="status-dot connecting"></span>
                <span id="statusText" class="status-text">Connecting...</span>
            </div>
        </div>
    </div>

    <div id="chatBox"></div>

    <div class="footer">
        <div id="uploadHint" class="upload-hint" style="display: none;">
            <span class="status-dot connecting" style="width:6px;height:6px;"></span> Sending media files...
        </div>

        <div id="attachmentPreview" class="attachment-preview-container"></div>

        <div class="input-row">
            <input type="file" id="mediaFile" accept="image/*,video/*" multiple>
            <button type="button" class="icon-btn attach" id="btnAttach" title="Attach Files">📎</button>
            <input type="text" id="messageText" placeholder="စာတို ရေးရန်..." autocomplete="off">
            <button type="button" class="icon-btn" id="btnSend" title="Send">➤</button>
        </div>
    </div>
</div>
<div id="imageLightbox" class="image-lightbox-modal">
    <span class="lightbox-close">&times;</span>
    <img class="lightbox-content" id="lightboxTargetImg" alt="Enlarged Chat Frame">
</div>
<button type="button" id="btnScrollBottom" class="scroll-bottom-btn">↓</button>

<script>
    const ctx = '${ctx}';
    const chatId = '${conversationId}';
    const myUserId = '${currentUser.id}';
    
    let socket = null;
    let isReconnecting = false;
    let selectedFiles = [];

    $(document).ready(function() {
        loadChatHistory();
        connectWebSocket();

        $('#btnSend').click(handleSend);
        $('#btnAttach').click(function() { $('#mediaFile').click(); });
        $('#mediaFile').change(handleFileSelect);
        
        $('#messageText').keypress(function(e) {
            if (e.which === 13) handleSend();
        });
     // User က အပေါ်ကို Scroll ဆွဲလိုက်ရင် Floating Button ပြပေးရန်
        $('#chatBox').scroll(function() {
            if ($(this).scrollTop() + $(this).innerHeight() < $(this)[0].scrollHeight - 100) {
                $('#btnScrollBottom').css('display', 'flex');
            } else {
                $('#btnScrollBottom').hide();
            }
        });

        // မြှားခလုတ်ကို နှိပ်လိုက်ရင် အောက်ဆုံးကို Smooth အနေနဲ့ ဆင်းသွားရန်
        $('#btnScrollBottom').click(function() {
            scrollToBottom();
        });

        // ပုံကို နှိပ်လိုက်လျှင် Lightbox Modal ပွင့်လာစေရန်
        $(document).on('click', '.bubble-media-container img', function() {
            const imgSrc = $(this).attr('src');
            $('#lightboxTargetImg').attr('src', imgSrc);
            $('#imageLightbox').css('display', 'flex');
        });

        // မည်သည့်နေရာကိုမဆို ပြန်နှိပ်လိုက်လျှင် Lightbox ပိတ်သွားစေရန်
        $('#imageLightbox, .lightbox-close').click(function() {
            $('#imageLightbox').hide();
            $('#lightboxTargetImg').attr('src', ''); 
        });

    });
 // မူရင်း function ကို Smooth Scroll လေးနဲ့ အစားထိုးပါ
    function scrollToBottom() {
        var box = $('#chatBox');
        if (box.length) {
            box.animate({ scrollTop: box[0].scrollHeight }, 300); // 300ms Smooth Scroll Effect
        }
    }

    function updateConnectionStatus(status) {
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

    function connectWebSocket() {
        const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = wsProtocol + '//' + window.location.host + ctx + '/ws/chat';
        
        updateConnectionStatus('connecting');
        socket = new WebSocket(wsUrl);

        socket.onopen = function() {
            console.log('WebSocket Connected');
            updateConnectionStatus('online');
            isReconnecting = false;
        };

        socket.onmessage = function(event) {
            try {
                const data = JSON.parse(event.data);
                if (data.type === 'error') return;

                const msgChatId = String(data.conversationId);
                if (msgChatId === String(chatId)) {
                    if ($('#msg-' + data.id).length === 0) {
                        appendMessage(data);
                        scrollToBottom();
                    }
                }
            } catch (e) {
                console.error('Failed to parse socket message:', e);
            }
        };

        socket.onclose = function(e) {
            updateConnectionStatus('offline');
            if (!isReconnecting) {
                isReconnecting = true;
                setTimeout(connectWebSocket, 3000);
            }
        };

        socket.onerror = function(err) {
            updateConnectionStatus('offline');
            socket.close();
        };
    }

    function loadChatHistory() {
        $.ajax({
            url: ctx + '/api/chat/history',
            type: 'GET',
            data: { conversationId: chatId },
            success: function(messages) {
                $('#chatBox').empty();
                messages.reverse().forEach(appendMessage);
                scrollToBottom();
            },
            error: function(xhr) {
                console.error('Failed to load history:', xhr.responseText);
            }
        });
    }

    function handleSend() {
        const text = $('#messageText').val().trim();
        if (selectedFiles.length > 0) {
            sendMedia(text);
            return;
        }
        if (!text) return;

        if (socket && socket.readyState === WebSocket.OPEN) {
            const payload = { conversationId: Number(chatId), text: text };
            socket.send(JSON.stringify(payload));
            $('#messageText').val('');
        } else {
            sendTextFallback(text);
        }
    }

    function sendTextFallback(text) {
        $('#btnSend').prop('disabled', true);
        $.ajax({
            url: ctx + '/api/chat/messages',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ conversationId: Number(chatId), text: text }),
            success: function(newMsg) {
                if ($('#msg-' + newMsg.id).length === 0) {
                    appendMessage(newMsg);
                    scrollToBottom();
                }
                $('#messageText').val('');
            },
            error: function(xhr) {
                alert('စာပို့ခြင်း မအောင်မြင်ပါ: ' + xhr.responseText);
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
                card.append('<div style="width:100%; height:100%; display:flex; align-items:center; justify-content:center; font-size:16px;">📄</div>');
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
                alert('Media ပို့ခြင်း မအောင်မြင်ပါ:\n' + xhr.responseText);
            },
            complete: function() {
                $('#btnAttach, #btnSend').prop('disabled', false);
                $('#uploadHint').css('display', 'none'); // Explicit hidden rewrite
            }
        });
    }

    function appendMessage(msg) {
        var isMe = String(msg.senderId) === String(myUserId);
        var cls = isMe ? 'me' : 'other';
        var label = isMe ? 'You' : 'User ' + msg.senderId;

        var row = $('<div class="message-row ' + cls + '" id="msg-' + msg.id + '"></div>');
        
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

        if (msg.messageText) {
            var textDiv = $('<div></div>').text(msg.messageText);
            bubble.append(textDiv);
        }

        // Clean Collage Design for Media Files
        if (msg.attachments && msg.attachments.length) {
            var mediaContainer = $('<div class="bubble-media-container" style="display:flex; flex-wrap:wrap; gap:4px; margin-top:6px;"></div>');
            var itemWidth = msg.attachments.length === 1 ? '100%' : 'calc(50% - 2px)';
            if (msg.attachments.length > 2 && msg.attachments.length % 3 === 0) {
                itemWidth = 'calc(33.33% - 3px)';
            }
            
            msg.attachments.forEach(function(att) {
                var url = ctx + att.fileUrl;
                var mediaWrapper = $('<div style="width: ' + itemWidth + '; min-width: 90px; border-radius: 6px; overflow: hidden; border: 1px solid var(--border-clean); background: var(--accent-gray);"></div>');
                
                if (att.fileType && att.fileType.indexOf('video/') === 0) {
                    mediaWrapper.append('<video controls src="' + url + '" style="width:100%; display:block; max-height:200px; object-fit:cover;"></video>');
                } else if (att.fileUrl && att.fileUrl.match(/\.(mp4|webm|mov|avi)$/i)) {
                    mediaWrapper.append('<video controls src="' + url + '" style="width:100%; display:block; max-height:200px; object-fit:cover;"></video>');
                } else {
                    mediaWrapper.append('<img src="' + url + '" alt="photo" style="width:100%; display:block; max-height:200px; object-fit:cover;"/>');
                }
                mediaContainer.append(mediaWrapper);
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
        bubble.append('<span class="bubble-time">' + timeStr + '</span>');

        row.append(bubble);
        $('#chatBox').append(row);
    }

 
</script>

</body>
</html>