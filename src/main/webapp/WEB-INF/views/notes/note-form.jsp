<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? 'Edit Note' : 'New Note'} — CheatSheet Hub</title>
    <meta name="description" content="Write and save your private personal note.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg:        #ffffff;
            --surface:   #ffffff;
            --surface2:  #f8fafc;
            --border:    #e2e8f0;
            --accent:    #6366f1;
            --accent-glow: rgba(99, 102, 241, 0.15);
            --text:      #0f172a;
            --muted:     #64748b;
            --red:       #ef4444;
            --radius:    14px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: #ffffff;
            color: #0f172a;
            min-height: 100vh;
        }

        /* ── Page layout ────────────────────────── */
        .form-page {
            max-width: 760px;
            margin: 0 auto;
            padding: 48px 24px 80px;
        }

        /* ── Back link ──────────────────────────── */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #64748b;
            text-decoration: none;
            margin-bottom: 28px;
            transition: color 0.15s;
        }
        .back-link:hover { color: #0f172a; }

        /* ── Form header ────────────────────────── */
        .form-header {
            margin-bottom: 32px;
        }
        .form-header h1 {
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: #0f172a;
        }
        .form-header p {
            font-size: 14px;
            color: #64748b;
            margin-top: 6px;
        }

        /* ── Card wrapper ───────────────────────── */
        .form-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            padding: 36px 40px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
        }

        /* ── Private badge ──────────────────────── */
        .private-notice {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #eeeffe;
            border: 1px solid #c7d2fe;
            color: #4f46e5;
            font-size: 12px;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 20px;
            margin-bottom: 24px;
        }

        /* ── Form fields ────────────────────────── */
        .form-group {
            margin-bottom: 24px;
        }
        .form-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .form-input, .form-textarea {
            width: 100%;
            background: #f8fafc;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            padding: 13px 16px;
            color: #0f172a;
            font-family: 'Inter', sans-serif;
            font-size: 15px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input::placeholder,
        .form-textarea::placeholder { color: #94a3b8; }
        .form-input:focus,
        .form-textarea:focus {
            background: #ffffff;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
        }
        .form-textarea {
            resize: vertical;
            min-height: 280px;
            line-height: 1.7;
        }

        /* Character counter */
        .char-hint {
            font-size: 11px;
            color: #64748b;
            text-align: right;
            margin-top: 5px;
        }

        /* ── Action buttons ─────────────────────── */
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 10px;
            flex-wrap: wrap;
        }
        .btn-save {
            flex: 1;
            padding: 13px 28px;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: #fff;
            font-weight: 700;
            font-size: 15px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.35);
            transition: transform 0.15s, box-shadow 0.15s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.45);
        }
        .btn-save:active { transform: translateY(0); }

        .btn-cancel {
            padding: 13px 24px;
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            color: #334155;
            font-weight: 600;
            font-size: 15px;
            border-radius: 10px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: background 0.15s, color 0.15s;
        }
        .btn-cancel:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        /* Divider */
        .divider {
            height: 1px;
            background: #e2e8f0;
            margin: 24px 0;
        }

        /* ── Responsive ─────────────────────────── */
        @media (max-width: 480px) {
            .form-card { padding: 24px 20px; }
            .form-header h1 { font-size: 22px; }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="form-page">

        <a href="${pageContext.request.contextPath}/notes" class="back-link" id="back-to-notes">
            <i class="fas fa-arrow-left"></i> Back to My Notes
        </a>

        <div class="form-header">
            <h1>
                <c:choose>
                    <c:when test="${isEdit}">✏️ Edit Note</c:when>
                    <c:otherwise>📝 New Note</c:otherwise>
                </c:choose>
            </h1>
            <p>
                <c:choose>
                    <c:when test="${isEdit}">Note ကို ပြင်ဆင်ပြီး သိမ်းဆည်းပါ</c:when>
                    <c:otherwise>ကိုယ်ပိုင် private note တစ်ခု ရေးသားပါ</c:otherwise>
                </c:choose>
            </p>
        </div>

        <div class="form-card">

            <div class="private-notice">
                <i class="fas fa-lock"></i> This note is private — only you can see it
            </div>

            <c:choose>
                <c:when test="${isEdit}">
                    <form action="${pageContext.request.contextPath}/notes/${note.id}/update" method="POST" id="noteForm">
                        <input type="hidden" name="id" value="${note.id}">
                </c:when>
                <c:otherwise>
                    <form action="${pageContext.request.contextPath}/notes/save" method="POST" id="noteForm">
                </c:otherwise>
            </c:choose>

                <%-- Title --%>
                <div class="form-group">
                    <label class="form-label" for="noteTitle">Note Title *</label>
                    <input
                        type="text"
                        id="noteTitle"
                        name="title"
                        class="form-input"
                        placeholder="e.g. Algorithm notes, Meeting ideas, TODO list..."
                        value="<c:out value='${note.title}'/>"
                        maxlength="255"
                        required
                        autocomplete="off">
                    <div class="char-hint" id="titleCounter">0 / 255</div>
                </div>

                <div class="divider"></div>

                <%-- Content --%>
                <div class="form-group">
                    <label class="form-label" for="noteContent">Content</label>
                    <textarea
                        id="noteContent"
                        name="content"
                        class="form-textarea"
                        placeholder="Write anything you want — ideas, reminders, code snippets, meeting notes...&#10;&#10;Only you will see this."><c:out value="${note.content}"/></textarea>
                    <div class="char-hint" id="contentCounter">0 characters</div>
                </div>

                <%-- Actions --%>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/notes" class="btn-cancel" id="cancel-btn">
                        <i class="fas fa-times"></i> Cancel
                    </a>
                    <button type="submit" class="btn-save" id="save-btn">
                        <i class="fas fa-save"></i>
                        <c:choose>
                            <c:when test="${isEdit}">Save Changes</c:when>
                            <c:otherwise>Save Note</c:otherwise>
                        </c:choose>
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script>
        // Title character counter
        const titleInput   = document.getElementById('noteTitle');
        const titleCounter = document.getElementById('titleCounter');
        function updateTitle() {
            titleCounter.textContent = titleInput.value.length + ' / 255';
        }
        titleInput.addEventListener('input', updateTitle);
        updateTitle();

        // Content character counter
        const contentArea    = document.getElementById('noteContent');
        const contentCounter = document.getElementById('contentCounter');
        function updateContent() {
            const len = contentArea.value.length;
            contentCounter.textContent = len.toLocaleString() + ' characters';
        }
        contentArea.addEventListener('input', updateContent);
        updateContent();

        // Save button loading state
        document.getElementById('noteForm').addEventListener('submit', function() {
            const btn = document.getElementById('save-btn');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
            btn.disabled = true;
        });
    </script>
</body>
</html>
