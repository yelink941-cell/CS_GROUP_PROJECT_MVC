<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Public Posts - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/posts.css">
    <style>
        .chat-fab {
            position: fixed;
            right: 24px;
            bottom: 24px;
            width: 58px;
            height: 58px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: #008069;
            border-radius: 50%;
            box-shadow: 0 4px 14px rgba(0, 128, 105, 0.4);
            font-size: 26px;
            text-decoration: none;
            transition: transform 0.2s ease, background 0.2s ease;
            z-index: 20;
        }

        .chat-fab:hover {
            background: #006b58;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <section class="hero">
            <h1>Explore Public Cheat Sheets</h1>
            <p>Browse community posts that have been reviewed and published for everyone.</p>
        </section>

        <c:if test="${not empty msg}">
            <p><c:out value="${msg}" /></p>
        </c:if>

        <c:if test="${empty posts}">
            <section class="empty-state">
                <h2>No public posts yet</h2>
                <p>Published public posts will appear here after admin approval.</p>
            </section>
        </c:if>

        <c:if test="${not empty posts}">
            <section class="post-grid" aria-label="Published public posts">
                <c:forEach var="post" items="${posts}">
                    <c:url var="detailsUrl" value="/posts/public/details">
                        <c:param name="slug" value="${post.slug}" />
                    </c:url>

                    <article class="post-card">
                        <h2><c:out value="${post.title}" /></h2>

                        <div class="post-meta">
                            <span><strong>Category:</strong> <c:out value="${post.category.name}" /></span>
                            <span><strong>Author:</strong> <c:out value="${post.author.username}" /></span>
                        </div>

                        <p class="post-excerpt">
                            <c:choose>
                                <c:when test="${not empty post.excerpt}">
                                    <c:out value="${post.excerpt}" />
                                </c:when>
                                <c:otherwise>No excerpt provided.</c:otherwise>
                            </c:choose>
                        </p>

                        <div class="badge-row">
                            <span class="visibility-badge visibility-public">PUBLIC</span>
                            <span class="status-badge status-published">PUBLISHED</span>
                        </div>

                        <div class="card-actions">
                            <a class="button" href="${detailsUrl}">View Details</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>
    </main>

    <c:if test="${not empty sessionScope.currentUser}">
        <a href="${pageContext.request.contextPath}/chat" class="chat-fab" title="Messages">&#128172;</a>
    </c:if>
</body>
</html>
