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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* ============================================
           STYLE FROM POPULAR.JSP
           ============================================ */
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            background: #f0f4f8;
            font-family: 'Inter', -apple-system, sans-serif;
            color: #1e293b;
            min-height: 100vh;
        }
        
        /* ===== HERO - FULL WIDTH (SAME AS POPULAR.JSP) ===== */
        .library-header {
            width: 100vw;
            margin-left: calc(-50vw + 50%);
            padding: 60px 20px 50px;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #4f46e5 100%);
            color: white;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 30px rgba(79, 70, 229, 0.25);
        }
        
        .library-header::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
        }
        
        .library-header::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 50%;
        }
        
        .library-header .header-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .library-header .header-icon {
            font-size: 48px;
            display: block;
            margin-bottom: 12px;
        }
        
        .library-header .header-badge {
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 3px;
            opacity: 0.7;
            display: block;
            margin-bottom: 8px;
            color: #c7d2fe;
        }
        
        .library-header h1 {
            font-size: 40px;
            font-weight: 800;
            margin: 0 0 12px 0;
            color: #ffffff;
            letter-spacing: -0.5px;
        }
        
        .library-header h1 span {
            background: rgba(255, 255, 255, 0.12);
            padding: 4px 16px;
            border-radius: 12px;
            display: inline-block;
            letter-spacing: 0;
            text-transform: none;
            font-size: 40px;
        }
        
        .library-header p {
            font-size: 18px;
            opacity: 0.85;
            margin: 0;
            color: #c7d2fe;
            line-height: 1.6;
        }
        
        /* ===== PAGE CONTAINER ===== */
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }
        
        /* ===== PAGE HEADER ===== */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-top: 35px;
            margin-bottom: 32px;
            gap: 16px;
            flex-wrap: wrap;
        }
        
        .page-title-block h1 {
            font-size: 28px;
            font-weight: 800;
            color: #1e293b;
            letter-spacing: -0.03em;
        }
        
        .page-title-block p {
            font-size: 15px;
            color: #64748b;
            margin-top: 4px;
        }
        
        /* ===== CREATE BUTTON (SAME AS READ LINK) ===== */
        .btn-create {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 32px;
            background: #4f46e5;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(79, 70, 229, 0.20);
            white-space: nowrap;
        }
        
        .btn-create:hover {
            background: #4338ca;
            transform: translateY(-3px);
            box-shadow: 0 8px 28px rgba(79, 70, 229, 0.35);
        }
        
        /* ===== FLASH MESSAGES ===== */
        .flash {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 28px;
            font-size: 14px;
            font-weight: 600;
            animation: slideDown 0.3s ease;
        }
        
        .flash-success {
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
            color: #047857;
        }
        
        .flash-error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #b91c1c;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* ===== NOTES GRID (SAME AS POPULAR GRID) ===== */
        .notes-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
        }
        
        /* ===== NOTE CARD (SAME AS POPULAR CARD) ===== */
        .note-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            position: relative;
            min-height: 200px;
        }
        
        .note-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px -8px rgba(0, 0, 0, 0.12);
            border-color: #c7d2fe;
        }
        
        /* ===== PRIVATE BADGE (SAME AS CATEGORY LABEL) ===== */
        .note-private-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #dbeafe;
            color: #1d4ed8;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            position: absolute;
            top: 16px;
            right: 16px;
        }
        
        .note-title {
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
            margin: 0 0 8px 0;
            padding-right: 80px;
            line-height: 1.3;
            word-break: break-word;
        }
        
        .note-snippet {
            font-size: 14px;
            color: #64748b;
            line-height: 1.6;
            margin: 0 0 16px 0;
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
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
            margin-bottom: 16px;
        }
        
        /* ===== CARD ACTION BUTTONS ===== */
        .note-actions {
            display: flex;
            gap: 10px;
            margin-top: auto;
        }
        
        .btn-edit {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            flex: 1;
            padding: 10px 20px;
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-edit:hover {
            background: #e2e8f0;
            color: #1e293b;
            transform: translateY(-2px);
        }
        
        .btn-delete {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            flex: 1;
            padding: 10px 20px;
            background: #ffffff;
            color: #ef4444;
            border: 1px solid #fecaca;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-delete:hover {
            background: #fef2f2;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.15);
        }
        
        /* ===== EMPTY STATE ===== */
        .empty-state {
            background: #ffffff;
            border-radius: 16px;
            padding: 60px 30px;
            text-align: center;
            border: 2px dashed #e2e8f0;
            grid-column: 1 / -1;
        }
        
        .empty-icon {
            font-size: 56px;
            display: block;
            margin-bottom: 14px;
        }
        
        .empty-state h2 {
            font-size: 22px;
            color: #1e293b;
            margin: 0 0 8px 0;
        }
        
        .empty-state p {
            color: #64748b;
            font-size: 15px;
            margin: 0 0 28px 0;
        }
        
        .empty-state .btn-create {
            display: inline-flex;
        }
        
        /* ===== DELETE MODAL ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(4px);
        }
        
        .modal-overlay.active {
            display: flex;
        }
        
        .modal-box {
            background: #ffffff;
            border: 1px solid #e8edf4;
            border-radius: 16px;
            padding: 32px;
            max-width: 420px;
            width: 90%;
            box-shadow: 0 12px 32px -8px rgba(0, 0, 0, 0.15);
            animation: popIn 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }
        
        @keyframes popIn {
            from { opacity: 0; transform: scale(0.95) translateY(10px); }
            to { opacity: 1; transform: scale(1) translateY(0); }
        }
        
        .modal-title {
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 12px;
        }
        
        .modal-body {
            font-size: 15px;
            color: #64748b;
            margin-bottom: 28px;
            line-height: 1.6;
        }
        
        .modal-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
        }
        
        .modal-cancel {
            padding: 10px 22px;
            border-radius: 10px;
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            color: #334155;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .modal-cancel:hover {
            background: #e2e8f0;
        }
        
        .modal-confirm {
            padding: 10px 22px;
            border-radius: 10px;
            background: #ef4444;
            border: none;
            color: #fff;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
        }
        
        .modal-confirm:hover {
            background: #dc2626;
            box-shadow: 0 6px 16px rgba(239, 68, 68, 0.3);
        }
        
        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .library-header {
                padding: 40px 16px 35px;
            }
            
            .library-header h1 {
                font-size: 28px;
            }
            
            .library-header h1 span {
                font-size: 28px;
            }
            
            .library-header p {
                font-size: 15px;
            }
            
            .page-container {
                padding: 0 14px 40px;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }
            
            .btn-create {
                width: 100%;
                justify-content: center;
            }
            
            .notes-grid {
                grid-template-columns: 1fr;
                gap: 18px;
            }
            
            .note-card {
                padding: 20px;
            }
            
            .note-title {
                font-size: 17px;
                padding-right: 70px;
            }
            
            .modal-box {
                padding: 24px;
            }
        }
        
        @media (max-width: 480px) {
            .library-header {
                padding: 30px 14px 25px;
            }
            
            .library-header h1 {
                font-size: 22px;
            }
            
            .library-header h1 span {
                font-size: 22px;
            }
            
            .library-header .header-icon {
                font-size: 32px;
            }
            
            .library-header p {
                font-size: 13px;
            }
            
            .note-card {
                padding: 16px;
            }
            
            .note-actions {
                flex-direction: column;
            }
            
            .modal-actions {
                flex-direction: column-reverse;
            }
            
            .modal-cancel,
            .modal-confirm {
                width: 100%;
                justify-content: center;
            }
        }
          /* ===== BACK LINK ===== */
        .back-link-wrapper {
            margin-top: 35px;
            margin-bottom: 24px;
        }
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            color: #64748b;
            text-decoration: none;
            transition: all 0.2s ease;
            padding: 8px 16px;
            background: #ffffff;
            border-radius: 10px;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
        
        .back-link:hover {
            color: #4f46e5;
            transform: translateX(-4px);
            border-color: #c7d2fe;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.10);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main>
        <!-- ===== HERO - SAME AS POPULAR.JSP ===== -->
        <header class="library-header">
            <div class="header-content">
                <span class="header-icon">📝</span>
                <span class="header-badge">My personal notes</span>
                <h1><span>My Notes</span></h1>
                <p>Personal notes</p>
            </div>
        </header>

        <div class="page-container">
             <!-- ===== BACK LINK TO HOME ===== -->
        <div class="back-link-wrapper">
            <a href="${pageContext.request.contextPath}/" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
        </div>
            <!-- ===== PAGE HEADER ===== -->
            <div class="page-header">
                <div class="page-title-block">
                    <h1>📝 My Private Notes</h1>
                    <p>Personal notes</p>
                </div>
                <a href="${pageContext.request.contextPath}/notes/new" class="btn-create" id="btn-new-note">
                    <i class="fas fa-plus"></i> New Note
                </a>
            </div>

            <!-- ===== FLASH MESSAGES ===== -->
            <c:if test="${not empty success}">
                <div class="flash flash-success"><i class="fas fa-check-circle"></i> ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="flash flash-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
            </c:if>

            <!-- ===== NOTES GRID ===== -->
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
        </div>
    </main>

    <!-- ===== DELETE CONFIRMATION MODAL ===== -->
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