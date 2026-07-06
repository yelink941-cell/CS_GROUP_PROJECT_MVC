<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Post Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f4f7fb;
            color: #172033;
        }

        /* ===== ADMIN TOP BAR ===== */
        .admin-shell {
            margin-left: 260px;
            min-height: 100vh;
        }

        .admin-topbar {
            height: 78px;
            background: #ffffff;
            border-bottom: 1px solid #e5eaf2;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 34px;
            box-shadow: 0 2px 10px rgba(15, 23, 42, 0.04);
            position: sticky;
            top: 0;
            z-index: 20;
        }

        .topbar-title {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 18px;
            font-weight: 800;
            color: #172033;
        }

        .topbar-user {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #172033;
            font-size: 15px;
        }

        .role-chip {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            border-radius: 6px;
            background: #ef4444;
            color: #fff;
            font-size: 12px;
            font-weight: 900;
            letter-spacing: .04em;
        }

        .signout-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 18px;
            border-radius: 8px;
            background: #64748b;
            color: #fff;
            text-decoration: none;
            font-weight: 700;
        }

        .signout-btn:hover { background: #475569; }

        /* ===== PAGE ===== */
        .admin-page {
            padding: 34px 34px 70px;
        }

        .hero-panel {
            background: #ffffff;
            border-radius: 18px;
            padding: 34px 38px;
            border-left: 8px solid #0ea5e9;
            box-shadow: 0 10px 28px rgba(15, 23, 42, 0.06);
            margin-bottom: 28px;
        }

        .hero-panel h1 {
            margin: 0 0 12px;
            font-size: 30px;
            line-height: 1.2;
            color: #172033;
            font-weight: 900;
        }

        .hero-panel p {
            margin: 0;
            color: #64748b;
            font-size: 16px;
            line-height: 1.6;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(180px, 1fr));
            gap: 20px;
            margin-bottom: 28px;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 14px;
            padding: 26px 26px;
            border: 1px solid #e5eaf2;
            box-shadow: 0 8px 20px rgba(15, 23, 42, 0.05);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: "";
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 6px;
            background: #3b82f6;
        }

        .stat-card.published::before { background: #10b981; }
        .stat-card.archived::before { background: #8b5cf6; }
        .stat-card.removed::before { background: #ef4444; }

        .stat-value {
            font-size: 34px;
            font-weight: 900;
            color: #172033;
            margin-bottom: 8px;
        }

        .stat-label {
            color: #64748b;
            font-size: 14px;
        }

        .stat-icon {
            position: absolute;
            right: 26px;
            top: 28px;
            font-size: 28px;
            opacity: .22;
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
        }

        .toolbar h2 {
            margin: 0;
            font-size: 20px;
            color: #172033;
            font-weight: 900;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #0284c7;
            text-decoration: none;
            font-weight: 800;
            background: #e0f2fe;
            padding: 10px 16px;
            border-radius: 10px;
        }

        .back-link:hover { background: #bae6fd; }

        .message {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 16px;
            font-weight: 700;
        }

        .message.success { background: #dcfce7; color: #166534; border: 1px solid #86efac; }
        .message.error { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }

        /* ===== TABLE ===== */
        .table-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 10px 28px rgba(15,23,42,.07);
            overflow: hidden;
            border: 1px solid #dfe7f1;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 17px 20px;
            text-align: left;
            vertical-align: middle;
            border-bottom: 1px solid #edf2f7;
        }

        th {
            background: #0f172a;
            color: #fff;
            font-size: 13px;
            letter-spacing: .08em;
            text-transform: uppercase;
            font-weight: 900;
        }

        td {
            font-size: 15px;
            color: #334155;
        }

        tbody tr:hover {
            background: #f8fbff;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .post-title {
            font-weight: 900;
            color: #0f172a;
            max-width: 280px;
            margin-bottom: 4px;
        }

        .muted {
            color: #94a3b8;
            font-size: 13px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 13px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 900;
            text-transform: uppercase;
            letter-spacing: .04em;
            white-space: nowrap;
        }

        .status-draft { background: #e5e7eb; color: #374151; }
        .status-pending { background: #ffedd5; color: #9a3412; }
        .status-published { background: #dcfce7; color: #166534; }
        .status-rejected { background: #fee2e2; color: #991b1b; }
        .status-archived { background: #e0e7ff; color: #3730a3; }
        .status-removed { background: #111827; color: #fff; }
        .status-user_deleted { background: #fef2f2; color: #7f1d1d; border: 1px solid #fecaca; }

        .visibility-public { background: #dbeafe; color: #1d4ed8; }
        .visibility-private { background: #f3f4f6; color: #4b5563; }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 9px;
        }

        .btn, button.btn {
            border: 0;
            border-radius: 9px;
            padding: 9px 13px;
            font-weight: 900;
            cursor: pointer;
            text-decoration: none;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            font-family: inherit;
            transition: transform .16s ease, box-shadow .16s ease, background .16s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 7px 16px rgba(15, 23, 42, 0.10);
        }

        .btn-view { background: #e0f2fe; color: #0369a1; }
        .btn-archive { background: #ede9fe; color: #5b21b6; }
        .btn-remove { background: #fee2e2; color: #991b1b; }
        .btn-permanent-delete { background: #7f1d1d; color: #fff; }
        .inline-form { display: inline; }

        .empty-state {
            padding: 50px;
            text-align: center;
            color: #64748b;
            font-weight: 700;
        }

        /* ===== MODAL ===== */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15,23,42,.55);
            z-index: 999;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-overlay.active { display: flex; }

        .modal {
            width: 100%;
            max-width: 520px;
            background: #fff;
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 24px 70px rgba(0,0,0,.25);
        }

        .modal h2 { margin: 0 0 8px; color: #111827; }
        .modal p { margin: 0 0 18px; color: #64748b; }

        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 800; color: #172033; }

        .form-control {
            width: 100%;
            padding: 11px 13px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            font: inherit;
        }

        textarea.form-control { min-height: 110px; resize: vertical; }

        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 18px;
        }

        .btn-cancel { background: #e5e7eb; color: #374151; }

        @media (max-width: 1100px) {
            .admin-shell { margin-left: 0; }
            .table-card { overflow-x: auto; }
            table { min-width: 1100px; }
            .stats-grid { grid-template-columns: repeat(2, minmax(180px, 1fr)); }
        }

        @media (max-width: 640px) {
            .admin-page { padding: 20px 14px 44px; }
            .admin-topbar { padding: 0 16px; height: auto; min-height: 78px; flex-direction: column; align-items: flex-start; justify-content: center; gap: 10px; }
            .hero-panel { padding: 26px 24px; }
            .stats-grid { grid-template-columns: 1fr; }
            .toolbar { flex-direction: column; align-items: flex-start; }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin Panel 👑</div>
        <ul class="sidebar-menu">
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">
                    <span>📊 Core Dashboard</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/categories" class="sidebar-link">
                    <span>📁 Category Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/tags" class="sidebar-link">
                    <span>🏷️ Tags Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts" class="sidebar-link active">
                    <span>📄 Post Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/posts/pending" class="sidebar-link">
                    <span>⏳ Pending Posts</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link">
                    <span>👥 User Management</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/announcements" class="sidebar-link">
                    <span>&#128364; Event Announcements</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports/cheatsheet" class="sidebar-link">
                    <span>&#128196; CheatSheet Report</span>
                </a>
            </li>
            <li class="sidebar-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="sidebar-link">
                    <span>📊 Report Logs</span>
                </a>
            </li>
        </ul>
    </aside>

    <div class="admin-shell">
        <header class="admin-topbar">
            <div class="topbar-title">📄 Post Management</div>
            <div class="topbar-user">
                <span>Welcome, <strong>Admin</strong></span>
                <span class="role-chip">ADMIN</span>
                <a class="signout-btn" href="${pageContext.request.contextPath}/logout">Sign Out</a>
            </div>
        </header>

        <main class="admin-page">
            <section class="hero-panel">
                <h1>Post Management</h1>
                <p>Manage public posts, archived posts, removed posts, and user-deleted records without changing the existing approval/rejection workflow.</p>
            </section>

            <c:set var="totalPosts" value="0" />
            <c:set var="publishedPosts" value="0" />
            <c:set var="archivedPosts" value="0" />
            <c:set var="removedPosts" value="0" />
            <c:forEach var="post" items="${posts}">
                <c:set var="totalPosts" value="${totalPosts + 1}" />
                <c:if test="${post.status == 'PUBLISHED'}">
                    <c:set var="publishedPosts" value="${publishedPosts + 1}" />
                </c:if>
                <c:if test="${post.status == 'ARCHIVED'}">
                    <c:set var="archivedPosts" value="${archivedPosts + 1}" />
                </c:if>
                <c:if test="${post.status == 'REMOVED' || post.status == 'USER_DELETED'}">
                    <c:set var="removedPosts" value="${removedPosts + 1}" />
                </c:if>
            </c:forEach>

            <section class="stats-grid">
                <div class="stat-card">
                    <span class="stat-icon">📄</span>
                    <div class="stat-value"><c:out value="${totalPosts}" /></div>
                    <div class="stat-label">Total Posts</div>
                </div>
                <div class="stat-card published">
                    <span class="stat-icon">✅</span>
                    <div class="stat-value"><c:out value="${publishedPosts}" /></div>
                    <div class="stat-label">Published Posts</div>
                </div>
                <div class="stat-card archived">
                    <span class="stat-icon">📦</span>
                    <div class="stat-value"><c:out value="${archivedPosts}" /></div>
                    <div class="stat-label">Archived Posts</div>
                </div>
                <div class="stat-card removed">
                    <span class="stat-icon">🚫</span>
                    <div class="stat-value"><c:out value="${removedPosts}" /></div>
                    <div class="stat-label">Removed / Deleted</div>
                </div>
            </section>

            <div class="toolbar">
                <h2>All Managed Posts</h2>
               
            </div>

            <c:if test="${not empty successMessage}">
                <div class="message success"><c:out value="${successMessage}" /></div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="message error"><c:out value="${errorMessage}" /></div>
            </c:if>

            <section class="table-card">
                <c:choose>
                    <c:when test="${empty posts}">
                        <div class="empty-state">No posts found.</div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Author</th>
                                    <th>Category</th>
                                    <th>Status</th>
                                    <th>Visibility</th>
                                    <th>Created Date</th>
                                    <th>Views</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="post" items="${posts}">
                                    <tr>
                                        <td>
                                            <div class="post-title"><c:out value="${post.title}" /></div>
                                            <div class="muted">/<c:out value="${post.slug}" /></div>
                                        </td>
                                        <td><c:out value="${empty post.author ? '-' : post.author.username}" /></td>
                                        <td><c:out value="${empty post.category ? '-' : post.category.name}" /></td>
                                        <td>
                                            <span class="badge status-${fn:toLowerCase(post.status)}">
                                                <c:out value="${post.status}" />
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge ${post.visibility == 'PUBLIC' ? 'visibility-public' : 'visibility-private'}">
                                                <c:out value="${post.visibility}" />
                                            </span>
                                        </td>
                                        <td><c:out value="${post.createdAt}" /></td>
                                        <td><strong><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /></strong></td>
                                        <td>
                                            <div class="actions">
                                                <a class="btn btn-view" href="${pageContext.request.contextPath}/admin/posts/view/${post.id}">👁 View</a>

                                                <c:choose>
                                                    <c:when test="${post.status == 'USER_DELETED'}">
                                                        <form class="inline-form" method="post" action="${pageContext.request.contextPath}/admin/posts/${post.id}/permanent-delete">
                                                            <button class="btn btn-permanent-delete" type="submit"
                                                                    onclick="return confirm('Permanently delete this user-deleted post and all related data? This cannot be undone.');">
                                                                🗑 Permanent Delete
                                                            </button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:choose>
                                                            <c:when test="${post.status == 'ARCHIVED'}">
                                                                <form class="inline-form" method="post" action="${pageContext.request.contextPath}/admin/posts/${post.id}/restore">
                                                                    <button class="btn btn-archive" type="submit">↩ Restore</button>
                                                                </form>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:if test="${post.status != 'REMOVED'}">
                                                                    <form class="inline-form" method="post" action="${pageContext.request.contextPath}/admin/posts/${post.id}/archive">
                                                                        <button class="btn btn-archive" type="submit">📦 Archive</button>
                                                                    </form>
                                                                </c:if>
                                                            </c:otherwise>
                                                        </c:choose>

                                                        <c:if test="${post.status != 'REMOVED'}">
                                                            <button class="btn btn-remove" type="button"
                                                                    data-remove-url="${pageContext.request.contextPath}/admin/posts/${post.id}/remove"
                                                                    data-post-title="${fn:escapeXml(post.title)}"
                                                                    onclick="openRemoveModal(this)">
                                                                🚫 Remove
                                                            </button>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </section>
        </main>
    </div>

    <div id="removeModal" class="modal-overlay" aria-hidden="true">
        <div class="modal">
            <h2>Remove Post</h2>
            <p id="removePostTitle">Please select a reason before removing this post.</p>

            <form id="removeForm" method="post">
                <div class="form-group">
                    <label for="reason">Removal Reason</label>
                    <select id="reason" name="reason" class="form-control" required onchange="toggleCustomReason()">
                        <option value="">-- Select Reason --</option>
                        <option value="Spam">Spam</option>
                        <option value="Duplicate">Duplicate</option>
                        <option value="Copyright Violation">Copyright Violation</option>
                        <option value="Offensive Content">Offensive Content</option>
                        <option value="Low Quality">Low Quality</option>
                        <option value="Incorrect Information">Incorrect Information</option>
                        <option value="Wrong Category">Wrong Category</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div id="customReasonGroup" class="form-group" style="display:none;">
                    <label for="customReason">Custom Reason</label>
                    <textarea id="customReason" name="customReason" class="form-control" placeholder="Write a clear reason for the author..."></textarea>
                </div>

                <div class="modal-actions">
                    <button class="btn btn-cancel" type="button" onclick="closeRemoveModal()">Cancel</button>
                    <button class="btn btn-remove" type="submit" onclick="return validateRemoveReason()">Confirm Remove</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openRemoveModal(button) {
            document.getElementById('removeForm').action = button.getAttribute('data-remove-url');
            document.getElementById('removePostTitle').textContent =
                'Remove "' + button.getAttribute('data-post-title') + '"? This action keeps the record but hides it from users.';
            document.getElementById('reason').value = '';
            document.getElementById('customReason').value = '';
            document.getElementById('customReasonGroup').style.display = 'none';
            document.getElementById('removeModal').classList.add('active');
        }

        function closeRemoveModal() {
            document.getElementById('removeModal').classList.remove('active');
        }

        function toggleCustomReason() {
            var reason = document.getElementById('reason').value;
            document.getElementById('customReasonGroup').style.display = reason === 'Other' ? 'block' : 'none';
        }

        function validateRemoveReason() {
            var reason = document.getElementById('reason').value;
            var customReason = document.getElementById('customReason').value.trim();

            if (!reason) {
                alert('Please select a removal reason.');
                return false;
            }

            if (reason === 'Other' && !customReason) {
                alert('Please write a custom reason.');
                return false;
            }

            return confirm('Are you sure you want to remove this post?');
        }
    </script>
</body>
</html>
