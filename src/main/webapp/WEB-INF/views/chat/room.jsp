<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${conversationTitle}</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: #efeae2; }
        .app { max-width: 480px; margin: 0 auto; min-height: 100vh; display: flex; flex-direction: column; border-left: 1px solid #d1d7db; border-right: 1px solid #d1d7db; }
        .header { background: #008069; color: #fff; padding: 12px 14px; display: flex; align-items: center; gap: 10px; }
        .header a { color: #fff; text-decoration: none; font-size: 20px; }
        .header-title { font-size: 17px; font-weight: 600; }
        .badge-admin { background: #ff9800; color: #fff; font-size: 10px; padding: 2px 6px; border-radius: 8px; margin-left: 6px; }
        #chatBox { flex: 1; overflow-y: auto; padding: 12px; background: #efeae2; min-height: calc(100vh - 120px); }
        .bubble { max-width: 78%; padding: 8px 10px 6px; border-radius: 8px; margin: 3px 0; box-shadow: 0 1px 1px rgba(0,0,0,.06); word-wrap: break-word; }
        .bubble.me { background: #d9fdd3; margin-left: auto; border-top-right-radius: 0; }
        .bubble.other { background: #fff; margin-right: auto; border-top-left-radius: 0; }
        .bubble small { color: #667781; font-size: 11px; display: block; margin-bottom: 2px; }
        .bubble img, .bubble video { max-width: 240px; border-radius: 6px; margin-top: 4px; display: block; }
        .footer { background: #f0f2f5; padding: 8px 10px; display: flex; align-items: center; gap: 8px; border-top: 1px solid #d1d7db; }
        .footer input[type=text] { flex: 1; border: none; border-radius: 20px; padding: 10px 14px; font-size: 15px; outline: none; }
        .icon-btn { width: 42px; height: 42px; border: none; border-radius: 50%; background: #008069; color: #fff; font-size: 18px; cursor: pointer; flex-shrink: 0; }
        .icon-btn.attach { background: #54656f; }
        .icon-btn:disabled { opacity: .5; cursor: not-allowed; }
        #mediaFile { display: none; }
        .upload-hint { font-size: 12px; color: #667781; padding: 0 12px 6px; display: none; }
    </style>
</head>
<body>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<div class="app">
    <div class="header">
        <a href="${ctx}/chat">←</a>
        <div class="header-title">
            <c:choose>
                <c:when test="${isGroup}">👥 ${conversationTitle}</c:when>
                <c:otherwise>
                    ${conversationTitle}
                    <c:if test="${partnerRole == 'ADMIN'}"><span class="badge-admin">Admin</span></c:if>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div id="chatBox"></div>
    <div id="uploadHint" class="upload-hint">Media ပို့နေသည်...</div>

    <div class="footer">
        <input type="file" id="mediaFile" accept="image/*,video/*">
        <button type="button" class="icon-btn attach" id="btnAttach" title="Photo/Video">📎</button>
        <input type="text" id="messageText" placeholder="Message" autocomplete="off">
        <button type="button" class="icon-btn" id="btnSend">➤</button>
    </div>
</div>

<script>
    const ctx = '${ctx}';
    const chatId = '${conversationId}';
    const myUserId = '${currentUser.id}';

    $(document).ready(function() {
        loadChatHistory();
        setInterval(loadChatHistory, 4000);

        $('#btnSend').click(sendMessage);
        $('#btnAttach').click(function() { $('#mediaFile').click(); });
        $('#mediaFile').change(function() {
            if (this.files.length > 0) sendMedia();
        });
        $('#messageText').keypress(function(e) {
            if (e.which === 13) sendMessage();
        });
    });

    function loadChatHistory() {
        $.ajax({
            url: ctx + '/api/chat/history',
            type: 'GET',
            data: { conversationId: chatId },
            success: function(messages) {
                $('#chatBox').empty();
                messages.reverse().forEach(appendMessage);
                scrollToBottom();
            }
        });
    }

    function sendMessage() {
        var text = $('#messageText').val().trim();
        if (!text) return;

        $('#btnSend').prop('disabled', true);
        $.ajax({
            url: ctx + '/api/chat/messages',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ conversationId: Number(chatId), text: text }),
            success: function(newMsg) {
                appendMessage(newMsg);
                $('#messageText').val('');
                scrollToBottom();
            },
            error: function(xhr) {
                alert('စာပို့ခြင်း မအောင်မြင်ပါ: ' + xhr.responseText);
            },
            complete: function() { $('#btnSend').prop('disabled', false); }
        });
    }

    function sendMedia() {
        var fileInput = $('#mediaFile')[0];
        if (!fileInput.files || !fileInput.files.length) return;

        var formData = new FormData();
        formData.append('conversationId', chatId);
        formData.append('file', fileInput.files[0]);
        formData.append('caption', $('#messageText').val().trim());

        $('#btnAttach, #btnSend').prop('disabled', true);
        $('#uploadHint').show();

        $.ajax({
            url: ctx + '/api/chat/messages/media',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(newMsg) {
                appendMessage(newMsg);
                $('#messageText').val('');
                $('#mediaFile').val('');
                scrollToBottom();
            },
            error: function(xhr) {
                alert('Media ပို့ခြင်း မအောင်မြင်ပါ:\n' + xhr.responseText);
            },
            complete: function() {
                $('#btnAttach, #btnSend').prop('disabled', false);
                $('#uploadHint').hide();
            }
        });
    }

    function appendMessage(msg) {
        var isMe = String(msg.senderId) === String(myUserId);
        var cls = isMe ? 'bubble me' : 'bubble other';
        var label = isMe ? 'You' : 'User ' + msg.senderId;

        var html = '<div class="' + cls + '">';
        html += '<small>' + label + '</small>';

        if (msg.messageText) {
            html += '<div>' + escapeHtml(msg.messageText) + '</div>';
        }

        if (msg.attachments && msg.attachments.length) {
            msg.attachments.forEach(function(att) {
                var url = ctx + att.fileUrl;
                if (att.fileType && att.fileType.indexOf('video/') === 0) {
                    html += '<video controls src="' + url + '"></video>';
                } else if (att.fileUrl && att.fileUrl.match(/\.(mp4|webm|mov|avi)$/i)) {
                    html += '<video controls src="' + url + '"></video>';
                } else {
                    html += '<img src="' + url + '" alt="photo"/>';
                }
            });
        }

        html += '</div>';
        $('#chatBox').append(html);
    }

    function escapeHtml(text) {
        return $('<div>').text(text).html();
    }

    function scrollToBottom() {
        var box = document.getElementById('chatBox');
        box.scrollTop = box.scrollHeight;
    }
</script>

</body>
</html>
