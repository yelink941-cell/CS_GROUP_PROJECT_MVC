<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Popular Cheat Sheets - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=7">
</head>
<body class="public-list-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container public-list-container">
        <header class="library-header">
            <span>Most viewed</span>
            <h1>Popular Cheat Sheets</h1>
            <p>Published public guides ordered by their total number of views.</p>
        </header>

        <c:if test="${empty posts}">
            <section class="empty-state">
                <h2>No popular posts yet</h2>
                <p>Popular cheat sheets will appear after readers begin viewing posts.</p>
            </section>
        </c:if>

        <c:if test="${not empty posts}">
            <section class="library-grid" aria-label="Popular posts">
                <c:forEach var="post" items="${posts}">
                    <c:url var="detailsUrl" value="/posts/${post.slug}" />
                    <article class="library-card">
                        <div class="card-content">
                            <div class="card-topline">
                                <span class="category-label"><c:out value="${post.category.name}" /></span>
                                <span class="metric-label"><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /> total views</span>
                            </div>

                            <a class="card-title" href="${detailsUrl}"><c:out value="${post.title}" /></a>
                            <p class="card-excerpt">
                                <c:choose>
                                    <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
                                    <c:otherwise>A concise guide designed for quick reference.</c:otherwise>
                                </c:choose>
                            </p>

                            <c:if test="${not empty post.tags}">
                                <div class="card-tags">
                                    <c:forEach var="tag" items="${post.tags}">
                                        <span><c:out value="${tag.name}" /></span>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <div class="card-meta">
                                <span class="author-initial"><c:out value="${fn:substring(post.author.username, 0, 1)}" /></span>
                                <div>
                                    <strong><c:out value="${post.author.username}" /></strong>
                                    <small>Community creator</small>
                                </div>
                            </div>

                            <a class="read-link" href="${detailsUrl}">Read cheat sheet <span>→</span></a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>
    </main>
</body>
</html>
