<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Public Posts - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=5">
    <style>
        .chat-fab {
            position: fixed;
            right: 24px;
            bottom: 24px;
            width: 54px;
            height: 54px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            background: #0f766e;
            border-radius: 50%;
            box-shadow: 0 6px 18px rgba(15, 118, 110, 0.25);
            font-size: 24px;
            text-decoration: none;
            z-index: 20;
        }
    </style>
</head>
<body class="public-list-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container public-list-container">
        <header class="library-header">
            <span>Public Library</span>
            <h1>Explore Cheat Sheets</h1>
            <p>Simple, practical guides created by the community and approved for everyone.</p>
        </header>

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
            <section class="library-grid" aria-label="Published public posts">
                <c:forEach var="post" items="${posts}">
                    <c:url var="detailsUrl" value="/posts/${post.slug}" />

                    <article class="library-card">
                        <div class="card-content">
                            <div class="card-topline">
                                <span class="category-label"><c:out value="${post.category.name}" /></span>
                                <span class="public-label">Public</span>
                            </div>

                            <a class="card-title" href="${detailsUrl}"><c:out value="${post.title}" /></a>

                            <p class="card-excerpt">
                                <c:choose>
                                    <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
                                    <c:otherwise>A concise guide designed for fast learning and everyday reference.</c:otherwise>
                                </c:choose>
                            </p>

                            <div class="card-meta">
                                <span class="author-initial"><c:out value="${fn:substring(post.author.username, 0, 1)}" /></span>
                                <div>
                                    <strong><c:out value="${post.author.username}" /></strong>
                                    <c:if test="${not empty post.createdAt}">
                                        <small><c:out value="${fn:substring(post.createdAt, 0, 10)}" /></small>
                                    </c:if>
                                </div>
                            </div>

                            <a class="read-link" href="${detailsUrl}">Read cheat sheet <span>→</span></a>
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
