<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Post Management</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Segoe UI", Arial, sans-serif; background: #f4f6f9; color: #1f2937; }
        .admin-page { max-width: 1400px; margin: 0 auto; padding: 32px; }
        .page-header { display: flex; justify-content: space-between; align-items: center; gap: 16px; margin-bottom: 24px; }
        .page-header h1 { margin: 0; font-size: 28px; color: #0f172a; }
        .page-header p { margin: 6px 0 0; color: #64748b; }
        .back-link { color: #0284c7; text-decoration: none; font-weight: 600; }
        .message { padding: 12px 16px; border-radius: 10px; margin-bottom: 16px; font-weight: 600; }
        .message.success { background: #dcfce7; color: #166534; border: 1px solid #86efac; }
        .message.error { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
        .table-card { background: #fff; border-radius: 16px; box-shadow: 0 12px 30px rgba(15,23,42,.08); overflow: hidden; border: 1px solid #e5e7eb; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 16px; text-align: left; vertical-align: middle; border-bottom: 1px solid #eef2f7; }
        th { background: #0f172a; color: #fff; font-size: 13px; letter-spacing: .04em; text-transform: uppercase; }
        td { font-size: 14px; }
        .post-title { font-weight: 700; color: #111827; max-width: 260px; }
        .muted { color: #64748b; font-size: 13px; }
        .badge { display: inline-flex; align-items: center; padding: 5px 10px; border-radius: 999px; font-size: 12px; font-weight: 700; text-transform: uppercase; }
        .status-draft { background: #e5e7eb; color: #374151; }
        .status-pending { background: #ffedd5; color: #9a3412; }
        .status-published { background: #dcfce7; color: #166534; }
        .status-rejected { background: #fee2e2; color: #991b1b; }
        .status-archived { background: #e0e7ff; color: #3730a3; }
        .status-removed { background: #111827; color: #fff; }
        .status-user_deleted { background: #fef2f2; color: #7f1d1d; border: 1px solid #fecaca; }
        .visibility-public { background: #dbeafe; color: #1d4ed8; }
        .visibility-private { background: #f3f4f6; color: #4b5563; }
        .actions { display: flex; flex-wrap: wrap; gap: 8px; }
        .btn, button.btn { border: 0; border-radius: 9px; padding: 8px 11px; font-weight: 700; cursor: pointer; text-decoration: none; font-size: 13px; display: inline-flex; align-items: center; justify-content: center; }
        .btn-view { background: #e0f2fe; color: #0369a1; }
        .btn-archive { background: #ede9fe; color: #5b21b6; }
        .btn-remove { background: #fee2e2; color: #991b1b; }
        .btn-permanent-delete { background: #7f1d1d; color: #fff; }
        .inline-form { display: inline; }
        .empty-state { padding: 40px; text-align: center; color: #64748b; }
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(15,23,42,.55); z-index: 999; align-items: center; justify-content: center; padding: 20px; }
        .modal-overlay.active { display: flex; }
        .modal { width: 100%; max-width: 520px; background: #fff; border-radius: 16px; padding: 24px; box-shadow: 0 24px 70px rgba(0,0,0,.25); }
        .modal h2 { margin: 0 0 8px; color: #111827; }
        .modal p { margin: 0 0 18px; color: #64748b; }
        .form-group { margin-bottom: 14px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 700; }
        .form-control { width: 100%; padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 10px; font: inherit; }
        textarea.form-control { min-height: 110px; resize: vertical; }
        .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 18px; }
        .btn-cancel { background: #e5e7eb; color: #374151; }
        @media (max-width: 1100px) {
            .table-card { overflow-x: auto; }
            table { min-width: 1100px; }
        }
    </style>
</head>
<body>
<main class="admin-page">
    <header class="page-header">
        <div>
            <h1>Post Management</h1>
            <p>Manage all posts without changing the existing approval/rejection workflow.</p>
        </div>
        <a class="back-link" href="${pageContext.request.contextPath}/admin/dashboard">← Back to Dashboard</a>
    </header>

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
                                        <a class="btn btn-view" href="${pageContext.request.contextPath}/admin/posts/view/${post.id}">View</a>

                                        <c:choose>
                                            <c:when test="${post.status == 'USER_DELETED'}">
                                                <form class="inline-form" method="post" action="${pageContext.request.contextPath}/admin/posts/${post.id}/permanent-delete">
                                                    <button class="btn btn-permanent-delete" type="submit"
                                                            onclick="return confirm('Permanently delete this user-deleted post and all related data? This cannot be undone.');">
                                                        Permanent Delete
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <c:choose>
                                                    <c:when test="${post.status == 'ARCHIVED'}">
                                                        <form class="inline-form" method="post" action="${pageContext.request.contextPath}/admin/posts/${post.id}/restore">
                                                            <button class="btn btn-archive" type="submit">Restore</button>
                                                        </form>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:if test="${post.status != 'REMOVED'}">
                                                            <form class="inline-form" method="post" action="${pageContext.request.contextPath}/admin/posts/${post.id}/archive">
                                                                <button class="btn btn-archive" type="submit">Archive</button>
                                                            </form>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:if test="${post.status != 'REMOVED'}">
                                                    <button class="btn btn-remove" type="button"
                                                            data-remove-url="${pageContext.request.contextPath}/admin/posts/${post.id}/remove"
                                                            data-post-title="${fn:escapeXml(post.title)}"
                                                            onclick="openRemoveModal(this)">
                                                        Remove
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
