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
            --bg:        #0d1117;
            --surface:   #161b22;
            --surface2:  #1c2128;
            --border:    #30363d;
            --accent:    #7c3aed;
            --accent-glow: rgba(124,58,237,0.25);
            --text:      #e6edf3;
            --muted:     #8b949e;
            --red:       #ef4444;
            --radius:    14px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: var(--bg);
            color: var(--text);
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
            color: var(--muted);
            text-decoration: none;
            margin-bottom: 28px;
            transition: color 0.15s;
        }
        .back-link:hover { color: var(--text); }

        /* ── Form header ────────────────────────── */
        .form-header {
            margin-bottom: 32px;
        }
        .form-header h1 {
            font-size: 26px;
            font-weight: 800;
            letter-spacing: -0.03em;
            background: linear-gradient(135deg, #a78bfa, #7c3aed);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .form-header p {
            font-size: 13px;
            color: var(--muted);
            margin-top: 6px;
        }

        /* ── Card wrapper ───────────────────────── */
        .form-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 36px 40px;
            box-shadow: 0 24px 64px rgba(0,0,0,0.3);
        }

        /* ── Private badge ──────────────────────── */
        .private-notice {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(124,58,237,0.12);
            border: 1px solid rgba(124,58,237,0.3);
            color: #a78bfa;
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
            color: var(--muted);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .form-input, .form-textarea {
            width: 100%;
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 13px 16px;
            color: var(--text);
            font-family: 'Inter', sans-serif;
            font-size: 15px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-input::placeholder,
        .form-textarea::placeholder { color: var(--muted); }
        .form-input:focus,
        .form-textarea:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px var(--accent-glow);
        }
        .form-textarea {
            resize: vertical;
            min-height: 280px;
            line-height: 1.7;
        }

        /* Character counter */
        .char-hint {
            font-size: 11px;
            color: var(--muted);
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
            background: linear-gradient(135deg, #7c3aed, #6d28d9);
            color: #fff;
            font-weight: 700;
            font-size: 15px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 0 0 18px var(--accent-glow);
            transition: transform 0.15s, box-shadow 0.15s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 28px rgba(124,58,237,0.5);
        }
        .btn-save:active { transform: translateY(0); }

        .btn-cancel {
            padding: 13px 24px;
            background: var(--surface2);
            border: 1px solid var(--border);
            color: var(--muted);
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
            background: var(--border);
            color: var(--text);
        }

        /* Divider */
        .divider {
            height: 1px;
            background: var(--border);
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

            <form action="${pageContext.request.contextPath}/notes/save" method="POST" id="noteForm">
                <%-- Hidden id for edit mode --%>
                <c:if test="${isEdit}">
                    <input type="hidden" name="id" value="${note.id}">
                </c:if>

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
