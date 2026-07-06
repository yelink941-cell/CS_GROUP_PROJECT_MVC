<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Sections - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-detail.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <header class="page-heading">
            <div>
                <h1><c:out value="${post.title}" /></h1>
                <p>Build this cheat sheet with text, code, and uploaded image sections.</p>
            </div>
            <a class="button" href="${pageContext.request.contextPath}/user/posts/${post.id}/contents/new">Add Section</a>
        </header>

        <c:if test="${not empty errorMessage}">
            <p class="form-message-error"><c:out value="${errorMessage}" /></p>
        </c:if>

        <c:if test="${empty contents}">
            <section class="empty-state">
                <h2>No sections yet</h2>
                <p>Add the first section to start building your cheat sheet.</p>
            </section>
        </c:if>

        <c:if test="${not empty contents}">
            <section class="content-grid" aria-label="Post content sections">
                <c:forEach var="content" items="${contents}">
                    <article class="content-card">
                        <div class="content-card-heading">
                            <div>
                                <span class="content-type-badge"><c:out value="${content.contentType}" /></span>
                                <h2>
                                    <c:choose>
                                        <c:when test="${not empty content.subtitle}">
                                            <c:out value="${content.subtitle}" />
                                        </c:when>
                                        <c:otherwise>Untitled Section</c:otherwise>
                                    </c:choose>
                                </h2>
                            </div>
                        </div>

                        <div class="content-preview">
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
                                <c:when test="${content.contentType == 'VIDEO'}">
                                    <video class="content-video" controls src="${fn:escapeXml(content.contentData)}"></video>
                                </c:when>
                                <c:when test="${content.contentType == 'LINK'}">
                                    <a href="${fn:escapeXml(content.contentData)}" target="_blank" rel="noopener noreferrer">
                                        <c:out value="${content.contentData}" />
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-content"><c:out value="${content.contentData}" /></div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card-actions">
                            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts/${post.id}/contents/edit/${content.id}">Edit</a>
                            <a class="button button-danger"
                               href="${pageContext.request.contextPath}/user/posts/${post.id}/contents/delete/${content.id}"
                               onclick="return confirm('Delete this section?');">Delete</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>

        <div class="page-footer-actions">
            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts">Back to My Posts</a>
        </div>
    </main>
</body>
</html>
