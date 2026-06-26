<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Posts - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=6">
</head>
<body class="my-posts-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container my-posts-container">
        <header class="my-posts-header">
    <div>
        <span>Workspace</span>
        <c:choose>
            <c:when test="${activeTab == 'bookmarks'}">
                <h1>My Bookmarks</h1>
                <p>Manage your saved and bookmarked cheat sheets.</p>
            </c:when>
            <c:otherwise>
                <h1>My Posts</h1>
                <p>Manage your drafts, submissions, published guides, and private notes.</p>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="my-posts-header-actions">
        <small><strong><c:out value="${fn:length(posts)}" /></strong> total items</small>
        <c:if test="${activeTab != 'bookmarks'}">
            <a class="button" href="${pageContext.request.contextPath}/user/posts/new">+ Create Post</a>
        </c:if>
    </div>
</header>

        <c:if test="${empty posts}">
            <section class="empty-state">
                <h2>No posts found</h2>
                <p>Create your first cheat sheet to start building your collection.</p>
            </section>
        </c:if>

        <c:if test="${not empty posts}">
            <section class="my-posts-grid" aria-label="My posts">
                <c:forEach var="post" items="${posts}">
                    <c:choose>
                        <c:when test="${post.status == 'PUBLISHED'}"><c:set var="statusClass" value="is-published" /></c:when>
                        <c:when test="${post.status == 'PENDING'}"><c:set var="statusClass" value="is-pending" /></c:when>
                        <c:when test="${post.status == 'REJECTED'}"><c:set var="statusClass" value="is-rejected" /></c:when>
                        <c:otherwise><c:set var="statusClass" value="is-draft" /></c:otherwise>
                    </c:choose>

                    <article class="my-post-card ${statusClass}">
                        <div class="my-post-card-top">
                            <span class="my-category"><c:out value="${post.category.name}" /></span>
                            <div class="badge-row">
                                <span class="visibility-badge ${post.visibility == 'PUBLIC' ? 'visibility-public' : 'visibility-private'}">
                                    <c:out value="${post.visibility}" />
                                </span>
                                <span class="status-badge status-${fn:toLowerCase(post.status)}"><c:out value="${post.status}" /></span>
                            </div>
                        </div>

                        <h2><c:out value="${post.title}" /></h2>
                        <p class="my-post-slug">/<c:out value="${post.slug}" /></p>

                        <c:if test="${post.status == 'REJECTED' && not empty post.rejectionReason}">
                            <p class="rejection-reason"><strong>Reason:</strong> <c:out value="${post.rejectionReason}" /></p>
                        </c:if>

                        <div class="my-post-actions">
                            <a class="my-action-link primary" href="${pageContext.request.contextPath}/user/posts/${post.id}/contents">Sections</a>
                            <a class="my-action-link" href="${pageContext.request.contextPath}/user/posts/${post.id}/files">Files</a>
                            <a class="my-action-link" href="${pageContext.request.contextPath}/user/posts/edit/${post.id}">Edit</a>
                            <a class="my-action-link danger" href="${pageContext.request.contextPath}/user/posts/delete/${post.id}"
                               onclick="return confirm('Delete this post?');">Delete</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>
    </main>
</body>
</html>
