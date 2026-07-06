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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* ── Color palette (inspired by the Public Library screenshot) ── */
        :root {
            --bg:        #f1f5f9;          /* soft gray-blue like the library background */
            --surface:   #ffffff;           /* crisp white cards */
            --surface2:  #f8fafc;           /* subtle input background */
            --border:    #e2e8f0;           /* light borders */
            --accent:    #0ea5e9;           /* bright sky blue (matches the "Read cheat sheet →" feel) */
            --accent2:   #0284c7;           /* deeper blue for hover/glow */
            --accent-glow: rgba(14, 165, 233, 0.20);
            --text:      #0f172a;           /* dark slate */
            --muted:     #475569;           /* muted text */
            --red:       #ef4444;
            --radius:    16px;
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
            padding: 56px 24px 80px;
        }

        /* ── Back link ──────────────────────────── */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 500;
            color: var(--muted);
            text-decoration: none;
            margin-bottom: 28px;
            transition: color 0.2s ease, transform 0.2s ease;
        }
        .back-link:hover { 
            color: var(--text); 
            transform: translateX(-2px);
        }

        /* ── Form header ────────────────────────── */
        .form-header {
            margin-bottom: 32px;
        }
        .form-header h1 {
            font-size: 32px;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: var(--text);
        }
        .form-header p {
            font-size: 15px;
            color: var(--muted);
            margin-top: 6px;
        }

        /* ── Card wrapper ───────────────────────── */
        .form-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.03);
        }

        /* ── Private badge ──────────────────────── */
        .private-notice {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #e0f2fe;          /* light blue tint */
            border: 1px solid #b8e2f8;
            color: #0369a1;               /* deep blue */
            font-size: 12px;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 20px;
            margin-bottom: 28px;
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
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            padding: 14px 16px;
            color: var(--text);
            font-family: 'Inter', sans-serif;
            font-size: 15px;
            outline: none;
            transition: all 0.2s ease;
        }
        .form-input::placeholder,
        .form-textarea::placeholder { color: #94a3b8; }
        .form-input:focus,
        .form-textarea:focus {
            background: var(--surface);
            border-color: var(--accent);
            box-shadow: 0 0 0 4px var(--accent-glow);
        }
        .form-textarea {
            resize: vertical;
            min-height: 280px;
            line-height: 1.7;
        }

        /* Character counter */
        .char-hint {
            font-size: 12px;
            color: #94a3b8;
            text-align: right;
            margin-top: 6px;
            font-weight: 500;
        }

        /* ── Action buttons ─────────────────────── */
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 16px;
            flex-wrap: wrap;
        }
        .btn-save {
            flex: 1;
            padding: 14px 28px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #fff;
            font-weight: 700;
            font-size: 15px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            box-shadow: 0 4px 14px var(--accent-glow);
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(14, 165, 233, 0.4);
        }
        .btn-save:active { transform: translateY(0); }

        .btn-cancel {
            padding: 14px 24px;
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            color: #334155;
            font-weight: 600;
            font-size: 15px;
            border-radius: 12px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s ease;
        }
        .btn-cancel:hover {
            background: #e2e8f0;
            color: var(--text);
        }

        /* Divider */
        .divider {
            height: 1px;
            background: var(--border);
            margin: 28px 0;
        }

        /* ── Responsive ─────────────────────────── */
        @media (max-width: 480px) {
            .form-card { padding: 28px 20px; }
            .form-header h1 { font-size: 26px; }
            .form-actions { flex-direction: column-reverse; }
            .btn-cancel { justify-content: center; width: 100%; }
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
                    <c:when test="${isEdit}">Edit and save your note</c:when>
                    <c:otherwise>Write a personal private note</c:otherwise>
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
<footer class="site-footer">
    <div class="footer-container">
        <div class="footer-brand">
            <h2>📚 CheatSheet Hub</h2>
            <p>Community-built cheat sheets for quick learning, practical references, and clean knowledge sharing. Your go-to resource for developer guides and technical references.</p>
        </div>
        <div class="footer-links">
            <h3>Quick Links</h3>
            <nav>
                <a href="${pageContext.request.contextPath}/">🏠 Home</a>
                <a href="${pageContext.request.contextPath}/posts/public">📄 View Posts</a>
                <a href="${pageContext.request.contextPath}/posts/categories">📁 Categories</a>
                <a href="${pageContext.request.contextPath}/posts/popular">🔥 Popular</a>
                <a href="${pageContext.request.contextPath}/posts/trending">📈 Trending</a>
            </nav>
        </div>
    </div>
    <div class="footer-bottom">
        <small>&copy; 2026 CheatSheet Hub. All rights reserved.</small>
        <div class="footer-legal">
            <a href="#"><i class="fas fa-lock"></i> Privacy Policy</a>
            <a href="#"><i class="fas fa-file-contract"></i> Terms of Service</a>
            <a href="#"><i class="fas fa-envelope"></i> Contact</a>
        </div>
    </div>
</footer>
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