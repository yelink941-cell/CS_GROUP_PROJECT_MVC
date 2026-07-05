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
            --bg:        #f8fafc; /* Changed to subtle gray for better contrast with cards */
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
            --radius:    16px; /* Slightly rounder edges */
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', -apple-system, sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* ── Page layout ───────────────────────── */
        .notes-page {
            max-width: 1100px;
            margin: 0 auto;
            padding: 56px 24px 80px;
        }

        /* ── Header ────────────────────────────── */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 40px;
            gap: 16px;
            flex-wrap: wrap;
        }

        .page-title-block h1 {
            font-size: 32px; /* Slightly larger title */
            font-weight: 800;
            letter-spacing: -0.03em;
            color: var(--text);
        }

        .page-title-block p {
            font-size: 15px;
            color: var(--muted);
            margin-top: 6px;
        }

        .btn-create {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #fff;
            font-weight: 700;
            font-size: 14px;
            border-radius: 12px;
            text-decoration: none;
            box-shadow: 0 4px 14px var(--accent-glow);
            transition: all 0.2s ease;
            white-space: nowrap;
        }
        .btn-create:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
        }

        /* ── Flash messages ─────────────────────── */
        .flash {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 32px;
            font-size: 14px;
            font-weight: 600;
            animation: slideDown 0.3s ease;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
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
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }

        /* ── Note card ──────────────────────────── */
        .note-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            min-height: 200px;
            transition: all 0.25s ease;
            position: relative;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
        }
        .note-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent), #818cf8);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .note-card:hover {
            border-color: #c7d2fe;
            transform: translateY(-4px);
            box-shadow: 0 12px 24px rgba(99, 102, 241, 0.08);
        }
        .note-card:hover::before { opacity: 1; }

        .note-private-badge {
            position: absolute;
            top: 16px; right: 16px;
            background: #eeeffe;
            border: 1px solid #c7d2fe;
            color: var(--accent2);
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .note-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--text);
            padding-right: 70px;
            line-height: 1.4;
            word-break: break-word;
        }

        .note-snippet {
            font-size: 14px;
            color: var(--muted);
            line-height: 1.6;
            flex: 1;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 4;
            -webkit-box-orient: vertical;
            word-break: break-word;
        }

        .note-meta {
            font-size: 12px;
            color: #94a3b8;
            display: flex;
            align-items: center;
            gap: 6px;
            border-top: 1px solid #f1f5f9;
            padding-top: 12px;
            margin-top: auto;
        }

        /* ── Card action buttons ────────────────── */
        .note-actions {
            display: flex;
            gap: 10px;
            margin-top: 12px;
        }

        .btn-edit, .btn-delete {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            flex: 1;
            padding: 8px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-edit {
            background: #f1f5f9;
            color: #475569;
        }
        .btn-edit:hover { 
            background: #e2e8f0; 
            color: var(--text);
        }

        .btn-delete {
            background: #fff;
            color: var(--red);
            border: 1px solid #fecaca;
        }
        .btn-delete:hover { 
            background: #fef2f2; 
        }

        /* ── Empty state ────────────────────────── */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            grid-column: 1 / -1;
            background: var(--surface);
            border: 2px dashed #cbd5e1;
            border-radius: var(--radius);
        }
        .empty-icon {
            font-size: 64px;
            margin-bottom: 24px;
            display: block;
            opacity: 0.9;
            animation: floatIcon 3s ease-in-out infinite;
        }
        @keyframes floatIcon {
            0%, 100% { transform: translateY(0); }
            50%       { transform: translateY(-10px); }
        }
        .empty-state h2 { font-size: 24px; font-weight: 700; color: var(--text); margin-bottom: 12px; }
        .empty-state p  { font-size: 15px; color: var(--muted); margin-bottom: 32px; }

        /* ── Delete confirm modal ───────────────── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.5); /* Slightly darker backdrop */
            z-index: 1000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(4px);
        }
        .modal-overlay.active { display: flex; }
        .modal-box {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px; /* Rounder modal */
            padding: 32px;
            max-width: 420px;
            width: 90%;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
            color: var(--text);
            animation: popIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        @keyframes popIn {
            from { opacity: 0; transform: scale(0.95) translateY(10px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }
        .modal-title { font-size: 20px; font-weight: 700; color: var(--text); margin-bottom: 12px; }
        .modal-body  { font-size: 15px; color: var(--muted); margin-bottom: 28px; line-height: 1.6; }
        .modal-actions { display: flex; gap: 12px; justify-content: flex-end; }
        .modal-cancel {
            padding: 10px 22px; border-radius: 10px;
            background: #f1f5f9; border: 1px solid #cbd5e1;
            color: #334155; font-weight: 600; font-size: 14px;
            cursor: pointer; transition: background 0.2s;
        }
        .modal-cancel:hover { background: #e2e8f0; }
        .modal-confirm {
            padding: 10px 22px; border-radius: 10px;
            background: var(--red); border: none;
            color: #fff; font-weight: 700; font-size: 14px;
            cursor: pointer; transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
        }
        .modal-confirm:hover { 
            background: #dc2626; 
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.3);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="notes-page">

        <%-- Page header --%>
        <div class="page-header">
            <div class="page-title-block">
                <h1>📝 My Private Notes</h1>
                <p>Personal notes</p>
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
                        <h2>No Notes Yet</h2>
                        <p>Click "New Note" to start writing your personal notes.</p>
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
                                <i class="fas fa-clock" style="font-size:11px;"></i>
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
                Are you sure you want to delete this note? This action cannot be undone.
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
                'Are you sure you want to delete "' + title + '"? This action cannot be undone.';
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
                el.style.transition = 'opacity 0.5s ease';
                el.style.opacity = '0';
                setTimeout(() => el.remove(), 500);
            });
        }, 4000);
    </script>
</body>
</html>