<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Posts - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/posts.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <header class="page-heading">
            <div>
                <h1>My Posts</h1>
                <p>Manage every post you created, including pending and rejected submissions.</p>
            </div>
            <a class="button" href="${pageContext.request.contextPath}/user/posts/new">Create Post</a>
        </header>

        <c:if test="${empty posts}">
            <section class="empty-state">
                <h2>No posts found</h2>
                <p>Create your first cheat sheet to start building your collection.</p>
            </section>
        </c:if>

        <c:if test="${not empty posts}">
            <section class="post-grid" aria-label="My posts">
                <c:forEach var="post" items="${posts}">
                    <article class="post-card">
                        <h2><c:out value="${post.title}" /></h2>

                        <div class="post-meta">
                            <span><strong>Category:</strong> <c:out value="${post.category.name}" /></span>
                            <span><strong>Slug:</strong> <c:out value="${post.slug}" /></span>
                        </div>

                        <div class="badge-row">
                            <c:choose>
                                <c:when test="${post.visibility == 'PUBLIC'}">
                                    <span class="visibility-badge visibility-public">PUBLIC</span>
                                </c:when>
                                <c:when test="${post.visibility == 'PRIVATE'}">
                                    <span class="visibility-badge visibility-private">PRIVATE</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="visibility-badge visibility-unset">NOT SET</span>
                                </c:otherwise>
                            </c:choose>

                            <c:choose>
                                <c:when test="${post.status == 'PENDING'}">
                                    <span class="status-badge status-pending">PENDING</span>
                                </c:when>
                                <c:when test="${post.status == 'PUBLISHED'}">
                                    <span class="status-badge status-published">PUBLISHED</span>
                                </c:when>
                                <c:when test="${post.status == 'REJECTED'}">
                                    <span class="status-badge status-rejected">REJECTED</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-draft"><c:out value="${post.status}" /></span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <c:if test="${post.status == 'REJECTED' && not empty post.rejectionReason}">
                            <p class="rejection-reason">
                                <strong>Reason:</strong> <c:out value="${post.rejectionReason}" />
                            </p>
                        </c:if>

                        <div class="card-actions">
                            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts/edit/${post.id}">Edit</a>
                            <a class="button button-danger" href="${pageContext.request.contextPath}/user/posts/delete/${post.id}">Delete</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>
    </main>
</body>
</html>
