<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Notes — CheatSheet Hub</title>
    <meta name="description" content="Your private personal notes. Only visible to you.">
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
            --accent2:   #4f46e5;
            --accent-glow: rgba(99, 102, 241, 0.15);
            --gold:      #d97706;
            --green:     #10b981;
            --red:       #ef4444;
            --text:      #0f172a;
            --muted:     #64748b;
            --radius:    14px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: #ffffff;
            color: #0f172a;
            min-height: 100vh;
        }

        /* ── Page layout ───────────────────────── */
        .notes-page {
            max-width: 1100px;
            margin: 0 auto;
            padding: 48px 24px 80px;
        }

        /* ── Header ────────────────────────────── */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 36px;
            gap: 16px;
            flex-wrap: wrap;
        }

        .page-title-block h1 {
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: #0f172a;
        }

        .page-title-block p {
            font-size: 14px;
            color: var(--muted);
            margin-top: 4px;
        }

        .btn-create {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 22px;
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: #fff;
            font-weight: 700;
            font-size: 14px;
            border-radius: 10px;
            text-decoration: none;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.35);
            transition: transform 0.15s, box-shadow 0.15s;
            white-space: nowrap;
        }
        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.45);
        }

        /* ── Flash messages ─────────────────────── */
        .flash {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 14px 18px;
            border-radius: var(--radius);
            margin-bottom: 28px;
            font-size: 14px;
            font-weight: 500;
            animation: slideDown 0.3s ease;
        }
        .flash-success { background: #ecfdf5; border: 1px solid #a7f3d0; color: #047857; }
        .flash-error   { background: #fef2f2; border: 1px solid #fecaca; color: #b91c1c; }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Notes grid ─────────────────────────── */
        .notes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }

        /* ── Note card ──────────────────────────── */
        .note-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: var(--radius);
            padding: 22px 24px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            transition: border-color 0.2s, transform 0.2s, box-shadow 0.2s;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.03);
        }
        .note-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, #6366f1, #818cf8);
            opacity: 0;
            transition: opacity 0.25s;
        }
        .note-card:hover {
            border-color: #6366f1;
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(99, 102, 241, 0.12);
        }
        .note-card:hover::before { opacity: 1; }

        .note-private-badge {
            position: absolute;
            top: 14px; right: 14px;
            background: #eeeffe;
            border: 1px solid #c7d2fe;
            color: #4f46e5;
            font-size: 10px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 20px;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .note-title {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            padding-right: 60px;
            line-height: 1.4;
            word-break: break-word;
        }

        .note-snippet {
            font-size: 13px;
            color: #475569;
            line-height: 1.6;
            flex: 1;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 4;
            -webkit-box-orient: vertical;
            word-break: break-word;
        }

        .note-meta {
            font-size: 11px;
            color: #64748b;
            display: flex;
            align-items: center;
            gap: 6px;
            border-top: 1px solid #f1f5f9;
            padding-top: 10px;
            margin-top: 4px;
        }

        /* ── Card action buttons ────────────────── */
        .note-actions {
            display: flex;
            gap: 8px;
        }

        .btn-edit, .btn-delete {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 7px 14px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            text-decoration: none;
            transition: background 0.15s, transform 0.12s;
        }
        .btn-edit {
            background: #eeeffe;
            color: #4f46e5;
            border: 1px solid #c7d2fe;
        }
        .btn-edit:hover { background: #e0e7ff; transform: translateY(-1px); }

        .btn-delete {
            background: #fef2f2;
            color: #ef4444;
            border: 1px solid #fecaca;
        }
        .btn-delete:hover { background: #fee2e2; transform: translateY(-1px); }

        /* ── Empty state ────────────────────────── */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            grid-column: 1 / -1;
        }
        .empty-icon {
            font-size: 64px;
            margin-bottom: 20px;
            display: block;
            opacity: 0.8;
            animation: floatIcon 3s ease-in-out infinite;
        }
        @keyframes floatIcon {
            0%, 100% { transform: translateY(0); }
            50%       { transform: translateY(-10px); }
        }
        .empty-state h2 { font-size: 22px; font-weight: 700; color: #0f172a; margin-bottom: 10px; }
        .empty-state p  { font-size: 14px; color: #64748b; margin-bottom: 28px; }

        /* ── Delete confirm modal ───────────────── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.4);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(4px);
        }
        .modal-overlay.active { display: flex; }
        .modal-box {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 32px;
            max-width: 420px;
            width: 90%;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.12);
            color: #0f172a;
            animation: popIn 0.2s ease;
        }
        @keyframes popIn {
            from { opacity: 0; transform: scale(0.9); }
            to   { opacity: 1; transform: scale(1); }
        }
        .modal-title { font-size: 18px; font-weight: 700; color: #0f172a; margin-bottom: 10px; }
        .modal-body  { font-size: 14px; color: #64748b; margin-bottom: 24px; line-height: 1.6; }
        .modal-actions { display: flex; gap: 12px; justify-content: flex-end; }
        .modal-cancel {
            padding: 9px 20px; border-radius: 8px;
            background: #f1f5f9; border: 1px solid #cbd5e1;
            color: #334155; font-weight: 600; font-size: 14px;
            cursor: pointer; transition: background 0.15s;
        }
        .modal-cancel:hover { background: #e2e8f0; }
        .modal-confirm {
            padding: 9px 20px; border-radius: 8px;
            background: var(--red); border: none;
            color: #fff; font-weight: 700; font-size: 14px;
            cursor: pointer; transition: opacity 0.15s;
        }
        .modal-confirm:hover { opacity: 0.85; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="notes-page">

        <%-- Page header --%>
        <div class="page-header">
            <div class="page-title-block">
                <h1>📝 My Private Notes</h1>
                <p>personal notes </p>
            </div>
            <a href="${pageContext.request.contextPath}/notes/new" class="btn-create" id="btn-new-note">
                <i class="fas fa-plus"></i> New Note
            </a>
        </div>

        <%-- Flash messages --%>
        <c:if test="${not empty success}">
            <div class="flash flash-success"><i class="fas fa-check-circle"></i> ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="flash flash-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        </c:if>

        <%-- Notes grid --%>
        <div class="notes-grid">
            <c:choose>
                <c:when test="${empty notes}">
                    <div class="empty-state">
                        <span class="empty-icon">📒</span>
                        <h2>Note တစ်ခုမှ မရှိသေး</h2>
                        <p>ကိုယ်ပိုင် note များ ရေးမှတ်ထားဖို့ "New Note" ကို နှိပ်ပါ။</p>
                        <a href="${pageContext.request.contextPath}/notes/new" class="btn-create">
                            <i class="fas fa-plus"></i> Create your first note
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="note" items="${notes}">
                        <div class="note-card">
                            <span class="note-private-badge">🔒 Private</span>
                            <div class="note-title"><c:out value="${note.title}" /></div>
                            <div class="note-snippet"><c:out value="${note.content}" /></div>
                            <div class="note-meta">
                                <i class="fas fa-clock" style="font-size:10px;"></i>
                                Updated: <c:out value="${note.displayUpdatedAt}" />
                            </div>
                            <div class="note-actions">
                                <a href="${pageContext.request.contextPath}/notes/${note.id}/edit"
                                   class="btn-edit" id="edit-note-${note.id}">
                                    <i class="fas fa-pen"></i> Edit
                                </a>
                                <button type="button"
                                        class="btn-delete"
                                        id="delete-note-${note.id}"
                                        onclick="confirmDelete(${note.id}, '<c:out value="${note.title}" />')">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <%-- Delete confirmation modal --%>
    <div class="modal-overlay" id="deleteModal">
        <div class="modal-box">
            <div class="modal-title">🗑️ Delete Note?</div>
            <div class="modal-body" id="modalBody">
                ဤ note ကို ဖျက်မည်။ ဤလုပ်ဆောင်မှုကို ပြန်မလှန်နိုင်ပါ။
            </div>
            <div class="modal-actions">
                <button class="modal-cancel" onclick="closeModal()">Cancel</button>
                <form id="deleteForm" method="POST" action="${pageContext.request.contextPath}/notes/delete" style="margin:0;">
                    <input type="hidden" name="id" id="deleteNoteId">
                    <button type="submit" class="modal-confirm">Delete</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id, title) {
            document.getElementById('deleteNoteId').value = id;
            document.getElementById('modalBody').textContent =
                '"' + title + '" ကို ဖျက်မည်။ ဤလုပ်ဆောင်မှုကို ပြန်မလှန်နိုင်ပါ။';
            document.getElementById('deleteModal').classList.add('active');
        }
        function closeModal() {
            document.getElementById('deleteModal').classList.remove('active');
        }
        // Click outside to close
        document.getElementById('deleteModal').addEventListener('click', function(e) {
            if (e.target === this) closeModal();
        });

        // Auto-hide flash after 4s
        setTimeout(() => {
            document.querySelectorAll('.flash').forEach(el => {
                el.style.transition = 'opacity 0.5s';
                el.style.opacity = '0';
                setTimeout(() => el.remove(), 500);
            });
        }, 4000);
    </script>
</body>
</html>
