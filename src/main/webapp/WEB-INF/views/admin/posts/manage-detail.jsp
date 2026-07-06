<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Post - Admin</title>
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; font-family: "Segoe UI", Arial, sans-serif; background: #f4f6f9; color: #1f2937; }
        .admin-page { max-width: 1180px; margin: 0 auto; padding: 32px; }
        .top-actions { display: flex; justify-content: space-between; align-items: center; margin-bottom: 22px; gap: 12px; }
        .back-link, .download-link { text-decoration: none; font-weight: 700; border-radius: 10px; padding: 10px 14px; }
        .back-link { color: #0369a1; background: #e0f2fe; }
        .download-link { color: #fff; background: #2563eb; }
        .detail-card { background: #fff; border-radius: 18px; padding: 28px; box-shadow: 0 12px 32px rgba(15,23,42,.08); border: 1px solid #e5e7eb; }
        h1 { margin: 0 0 10px; color: #0f172a; font-size: 34px; }
        .excerpt { color: #475569; line-height: 1.7; margin: 16px 0 22px; }
        .meta-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 14px; margin: 22px 0; }
        .meta-item { background: #f8fafc; border: 1px solid #e2e8f0; padding: 14px; border-radius: 12px; }
        .meta-item strong { display: block; color: #334155; margin-bottom: 5px; font-size: 13px; text-transform: uppercase; letter-spacing: .04em; }
        .badge { display: inline-flex; align-items: center; padding: 5px 10px; border-radius: 999px; font-size: 12px; font-weight: 800; text-transform: uppercase; }
        .status-draft { background: #e5e7eb; color: #374151; }
        .status-pending { background: #ffedd5; color: #9a3412; }
        .status-published { background: #dcfce7; color: #166534; }
        .status-rejected { background: #fee2e2; color: #991b1b; }
        .status-archived { background: #e0e7ff; color: #3730a3; }
        .status-removed { background: #111827; color: #fff; }
        .status-user_deleted { background: #fef2f2; color: #7f1d1d; border: 1px solid #fecaca; }
        .visibility-public { background: #dbeafe; color: #1d4ed8; }
        .visibility-private { background: #f3f4f6; color: #4b5563; }
        .section-title { margin: 34px 0 14px; font-size: 22px; color: #0f172a; }
        .tag-list { display: flex; flex-wrap: wrap; gap: 10px; padding: 0; margin: 0; list-style: none; }
        .tag-pill { background: #ecfeff; color: #0e7490; padding: 8px 12px; border-radius: 999px; font-weight: 700; font-size: 13px; }
        .content-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 18px; }
        .content-card { border: 1px solid #dbeafe; border-radius: 14px; overflow: hidden; background: #fff; }
        .content-header { background: linear-gradient(135deg, #2563eb, #7c3aed); color: #fff; padding: 12px 14px; }
        .content-header h3 { margin: 0; font-size: 17px; }
        .content-header span { font-size: 12px; opacity: .9; }
        .content-body { padding: 16px; line-height: 1.7; background: #f8fafc; white-space: pre-wrap; }
        pre { margin: 0; padding: 14px; background: #111827; color: #e5e7eb; border-radius: 10px; overflow-x: auto; white-space: pre-wrap; }
        .content-image { max-width: 100%; border-radius: 10px; border: 1px solid #e5e7eb; }
        .notice { background: #fff7ed; color: #9a3412; border: 1px solid #fed7aa; padding: 14px; border-radius: 12px; margin-top: 18px; }
        .read-only-note { margin-top: 18px; color: #64748b; font-size: 13px; }
    </style>
</head>
<body>
<main class="admin-page">
    <div class="top-actions">
        <a class="back-link" href="${pageContext.request.contextPath}/admin/posts">← Back to Post Management</a>
        <c:if test="${post.status != 'USER_DELETED' && empty post.deletedAt}">
            <a class="download-link" href="${pageContext.request.contextPath}/posts/${post.slug}/download-pdf">Download PDF</a>
        </c:if>
    </div>

    <article class="detail-card">
        <h1><c:out value="${post.title}" /></h1>
        <div>
            <span class="badge status-${fn:toLowerCase(post.status)}"><c:out value="${post.status}" /></span>
            <span class="badge ${post.visibility == 'PUBLIC' ? 'visibility-public' : 'visibility-private'}">
                <c:out value="${post.visibility}" />
            </span>
        </div>

        <p class="excerpt">
            <c:choose>
                <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
                <c:otherwise>No excerpt provided.</c:otherwise>
            </c:choose>
        </p>

        <section class="meta-grid">
            <div class="meta-item">
                <strong>Author</strong>
                <span><c:out value="${empty post.author ? '-' : post.author.username}" /></span>
            </div>
            <div class="meta-item">
                <strong>Category</strong>
                <span><c:out value="${empty post.category ? '-' : post.category.name}" /></span>
            </div>
            <div class="meta-item">
                <strong>Views</strong>
                <span><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /></span>
            </div>
            <div class="meta-item">
                <strong>Created Date</strong>
                <span><c:out value="${post.createdAt}" /></span>
            </div>
            <div class="meta-item">
                <strong>Archived Date</strong>
                <span><c:out value="${empty post.archivedAt ? '-' : post.archivedAt}" /></span>
            </div>
            <div class="meta-item">
                <strong>Removed Date</strong>
                <span><c:out value="${empty post.removedAt ? '-' : post.removedAt}" /></span>
            </div>
            <div class="meta-item">
                <strong>Deleted Date</strong>
                <span><c:out value="${empty post.deletedAt ? '-' : post.deletedAt}" /></span>
            </div>
        </section>

        <c:if test="${post.status == 'REJECTED' && not empty post.rejectionReason}">
            <div class="notice"><strong>Rejection Reason:</strong> <c:out value="${post.rejectionReason}" /></div>
        </c:if>

        <c:if test="${post.status == 'REMOVED' && not empty post.removalReason}">
            <div class="notice"><strong>Removal Reason:</strong> <c:out value="${post.removalReason}" /></div>
        </c:if>

        <h2 class="section-title">Tags</h2>
        <c:choose>
            <c:when test="${empty post.tags}">
                <p class="read-only-note">No tags available.</p>
            </c:when>
            <c:otherwise>
                <ul class="tag-list">
                    <c:forEach var="tag" items="${post.tags}">
                        <li class="tag-pill"><c:out value="${tag.name}" /></li>
                    </c:forEach>
                </ul>
            </c:otherwise>
        </c:choose>

        <h2 class="section-title">Post Content</h2>
        <c:choose>
            <c:when test="${empty contents}">
                <p class="read-only-note">No content sections available.</p>
            </c:when>
            <c:otherwise>
                <section class="content-grid">
                    <c:forEach var="content" items="${contents}">
                        <article class="content-card">
                            <div class="content-header">
                                <h3><c:out value="${empty content.subtitle ? 'Untitled Section' : content.subtitle}" /></h3>
                                <span><c:out value="${content.contentType}" /></span>
                            </div>
                            <div class="content-body">
                                <c:choose>
                                    <c:when test="${content.contentType == 'CODE'}">
                                        <pre><code><c:out value="${content.contentData}" /></code></pre>
                                    </c:when>
                                    <c:when test="${content.contentType == 'IMAGE'}">
                                        <c:choose>
                                            <c:when test="${fn:startsWith(content.contentData, '/')}">
                                                <img class="content-image" src="${pageContext.request.contextPath}${fn:escapeXml(content.contentData)}" alt="${fn:escapeXml(content.subtitle)}">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="content-image" src="${fn:escapeXml(content.contentData)}" alt="${fn:escapeXml(content.subtitle)}">
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <c:out value="${content.contentData}" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </article>
                    </c:forEach>
                </section>
            </c:otherwise>
        </c:choose>

        <p class="read-only-note">This page is read-only. Admins cannot edit post content from Post Management.</p>
    </article>
</main>
</body>
</html>
