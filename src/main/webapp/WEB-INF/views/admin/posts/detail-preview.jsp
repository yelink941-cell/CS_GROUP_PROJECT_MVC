<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${post.title}" /> - Moderation Preview</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-detail.css">

<style>
:root {
    --primary: #4038ff;
    --secondary: #6366f1;
    --bg: #f8fafc;
    --text: #111827;
    --muted: #64748b;
    --border: #e5e7eb;
    --soft-border: #eef2f7;
    --code: #111827;
    --white: #ffffff;
}

body {
    margin: 0;
    background: var(--bg) !important;
    color: var(--text);
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    font-size: 15px;
    line-height: 1.65;
}

.page-container {
    width: min(1500px, calc(100% - 120px)) !important;
    max-width: 1500px !important;
    margin: 0 auto !important;
    padding: 24px 0 40px !important;
    box-sizing: border-box !important;
}

.detail-card {
    background: var(--white) !important;
    border: 1px solid var(--border) !important;
    border-radius: 10px !important;
    box-shadow: 0 8px 22px rgba(15, 23, 42, 0.05) !important;
    padding: 24px !important;
    margin-bottom: 18px !important;
}

.detail-card h1 {
    margin: 0 0 14px !important;
    color: var(--text) !important;
    font-size: 38px !important;
    line-height: 1.2 !important;
    letter-spacing: -0.03em;
    font-weight: 800;
}

.post-meta {
    display: flex !important;
    flex-wrap: wrap;
    align-items: center !important;
    gap: 10px 18px !important;
    color: var(--muted);
    font-size: 14px;
    margin-bottom: 4px !important;
}

.post-meta span {
    display: inline-flex;
    align-items: center;
    gap: 5px;
}

.post-meta strong {
    color: var(--text);
    font-weight: 700;
}

.badge-row {
    display: flex !important;
    flex-wrap: wrap;
    gap: 8px !important;
    margin: 6px 0 !important;
}

.visibility-badge,
.status-badge,
.tag-pill {
    display: inline-flex;
    align-items: center;
    border-radius: 999px !important;
    padding: 5px 10px !important;
    font-size: 12px !important;
    font-weight: 700 !important;
    line-height: 1;
    text-transform: uppercase;
}

.visibility-public {
    background: #eef2ff !important;
    color: var(--primary) !important;
}

.visibility-private {
    background: #f3f4f6 !important;
    color: #4b5563 !important;
}

.status-published {
    background: #ecfdf5 !important;
    color: #047857 !important;
}

.tag-list {
    display: flex !important;
    flex-wrap: wrap;
    gap: 8px;
    margin: 6px 0 0 !important;
    padding: 0 !important;
    list-style: none;
}

.tag-pill {
    background: #f1f5f9 !important;
    color: #475569 !important;
}

.detail-excerpt {
    display: block !important;
    width: 100% !important;
    max-width: none !important;
    margin: 14px 0 0 !important;
    padding-bottom: 16px !important;
    font-size: 17px !important;
    line-height: 1.45 !important;
    color: #334155;
    border-bottom: 1px dashed var(--border);
}

.public-content-grid {
    margin-top: 24px !important;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
    gap: 22px 28px !important;
}

.public-content-card {
    background: #ffffff;
    border: 1px solid var(--border);
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.02);
    overflow: hidden;
}

.public-content-card-header {
    background: #f8fafc;
    border-bottom: 1px solid var(--border);
    padding: 12px 18px !important;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.public-content-card-header h2 {
    margin: 0;
    font-size: 16px;
    font-weight: 700;
    color: #0f172a;
}

.public-content-card-header span {
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    color: var(--muted);
    background: #e2e8f0;
    padding: 3px 8px;
    border-radius: 6px;
}

.public-content-card-body {
    padding: 16px;
    font-size: 14px;
}

.public-code-content {
    margin: 0;
    padding: 14px;
    background: #0f172a;
    color: #e2e8f0;
    border-radius: 8px;
    overflow-x: auto;
    font-family: Consolas, monospace;
}

.public-section-image {
    max-width: 100%;
    border-radius: 8px;
    border: 1px solid var(--border);
}

.public-section-video {
    width: 100%;
    border-radius: 8px;
}

.public-section-link {
    color: var(--primary);
    font-weight: 600;
    text-decoration: none;
    word-break: break-all;
}

.public-section-link:hover {
    text-decoration: underline;
}

.preview-badge {
    background: #475569;
    color: #ffffff;
    padding: 6px 12px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}
</style>
</head>
<body>

<main class="page-container">
    <div style="background: #f1f5f9; border: 1px solid #cbd5e1; border-left: 5px solid #475569; color: #334155; padding: 16px 20px; border-radius: 12px; margin-bottom: 24px; font-weight: 600; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 12px rgba(0,0,0,0.02);">
        <div style="display: flex; align-items: center; gap: 12px;">
            <span style="font-size: 1.4rem;">👁️</span>
            <div>
                <strong style="font-size: 1rem; display: block; color: #1e293b;">Moderator Look-Only Mode</strong>
                <span style="font-size: 0.88rem; color: #475569;">You are previewing this cheat sheet in read-only mode for moderation. Interaction controls are disabled.</span>
            </div>
        </div>
        <span class="preview-badge">Preview Mode</span>
    </div>

    <article class="detail-card">
        <h1>
            <c:out value="${post.title}" />
            <span style="font-size: 18px; color: var(--muted); font-weight: normal; margin-left: 8px;">
                by @<c:out value="${post.author.username}" />
            </span>
        </h1>

        <div class="post-meta">
            <span><strong>Category:</strong> <c:out value="${post.category.name}" /></span>
            <span><strong>Author:</strong> <c:out value="${post.author.username}" /></span>
            <c:if test="${not empty post.createdAt}">
                <span><strong>Created:</strong> <c:out value="${post.createdAt}" /></span>
            </c:if>
        </div>

        <div class="badge-row">
            <span class="visibility-badge ${post.visibility == 'PUBLIC' ? 'visibility-public' : 'visibility-private'}">
                <c:out value="${post.visibility}" />
            </span>
            <span class="status-badge status-published">
                <c:out value="${post.status}" />
            </span>
        </div>

        <c:if test="${not empty post.tags}">
            <ul class="tag-list" aria-label="Post tags">
                <c:forEach var="tag" items="${post.tags}">
                    <li class="tag-pill"><c:out value="${tag.name}" /></li>
                </c:forEach>
            </ul>
        </c:if>

        <div class="detail-excerpt">
            <c:choose>
                <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
                <c:otherwise>No excerpt provided.</c:otherwise>
            </c:choose>
        </div>

        <%-- Post Content Grid --%>
        <c:if test="${not empty contents}">
            <div class="public-content-grid" aria-label="Cheat sheet sections">
                <c:forEach var="content" items="${contents}">
                    <article class="public-content-card">
                        <header class="public-content-card-header">
                            <h2>
                                <c:choose>
                                    <c:when test="${not empty content.subtitle}">
                                        <c:out value="${content.subtitle}" />
                                    </c:when>
                                    <c:otherwise>Untitled Section</c:otherwise>
                                </c:choose>
                            </h2>
                            <span><c:out value="${content.contentType}" /></span>
                        </header>

                        <div class="public-content-card-body">
                            <c:choose>
                                <c:when test="${content.contentType == 'CODE'}">
                                    <pre class="public-code-content"><code><c:out value="${content.contentData}" /></code></pre>
                                </c:when>

                                <c:when test="${content.contentType == 'IMAGE'}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(content.contentData, '/')}">
                                            <img class="public-section-image"
                                                 src="${pageContext.request.contextPath}${fn:escapeXml(content.contentData)}"
                                                 alt="${fn:escapeXml(content.subtitle)}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="public-section-image"
                                                 src="${fn:escapeXml(content.contentData)}"
                                                 alt="${fn:escapeXml(content.subtitle)}">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>

                                <c:when test="${content.contentType == 'VIDEO'}">
                                    <video class="public-section-video" controls src="${fn:escapeXml(content.contentData)}"></video>
                                </c:when>

                                <c:when test="${content.contentType == 'LINK'}">
                                    <a class="public-section-link"
                                       href="${fn:escapeXml(content.contentData)}"
                                       target="_blank"
                                       rel="noopener noreferrer">
                                        <c:out value="${content.contentData}" />
                                    </a>
                                </c:when>

                                <c:otherwise>
                                    <p class="public-text-content" style="margin:0; line-height:1.6;">
                                        <c:out value="${content.contentData}" />
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </c:if>

        <%-- Rating Display (Read-Only) --%>
        <div style="margin-top: 30px; padding: 16px; background: #f8fafc; border: 1px solid var(--border); border-radius: 10px; display: flex; align-items: center; justify-content: space-between;">
            <div style="display: flex; align-items: center; gap: 8px;">
                <span style="font-size: 20px; color: #ffc107;">
                    <c:forEach begin="1" end="5" var="i">
                        ${averageRating >= i ? '★' : '☆'}
                    </c:forEach>
                </span>
                <span style="font-size: 14px; font-weight: 600; color: #334155;">
                    Average Rating: <c:out value="${not empty averageRating ? averageRating : 0.0}" />/5 (${not empty totalRatings ? totalRatings : 0} ratings)
                </span>
            </div>
            <div style="font-size: 14px; font-weight: 600; color: #475569;">
                👍 Likes: ${not empty likeCount ? likeCount : 0} | ⭐ Bookmarks: ${not empty totalBookmarks ? totalBookmarks : 0}
            </div>
        </div>

        <%-- Comments Section (Read-Only List) --%>
        <section style="margin-top: 40px; border-top: 1px solid var(--border); padding-top: 24px;">
            <h3 style="font-size: 20px; font-weight: 700; color: #0f172a; margin-bottom: 20px;">
                💬 Comments (${not empty totalComments ? totalComments : (not empty comments ? fn:length(comments) : 0)})
            </h3>

            <c:choose>
                <c:when test="${not empty comments}">
                    <div class="comment-list" style="display: flex; flex-direction: column; gap: 16px;">
                        <c:forEach var="comment" items="${comments}">
                            <div class="comment-item" style="border-bottom: 1px solid #f1f5f9; padding-bottom: 12px;">
                                <div style="display: flex; justify-content: space-between; font-size: 13px; color: var(--muted); margin-bottom: 4px;">
                                    <strong>@<c:out value="${comment.user.username}" /></strong>
                                    <span><c:out value="${comment.createdAt}" /></span>
                                </div>
                                <p style="margin: 0; line-height: 1.5; color: #333;">
                                    <c:out value="${comment.content}" />
                                </p>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: var(--muted); font-style: italic;">No comments posted yet.</p>
                </c:otherwise>
            </c:choose>
        </section>
    </article>
</main>
</body>
</html>
