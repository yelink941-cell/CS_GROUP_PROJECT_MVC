<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trending Today - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=7">
</head>
<body class="public-list-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container public-list-container">
        <header class="library-header">
            <span>Today&apos;s activity</span>
            <h1>Trending Cheat Sheets</h1>
            <p>Public guides receiving the most reader attention today.</p>
        </header>

        <c:if test="${empty trendingPosts}">
            <section class="empty-state">
                <h2>No trending posts yet</h2>
                <p>Today&apos;s trending list will appear after public posts receive views.</p>
            </section>
        </c:if>

        <c:if test="${not empty trendingPosts}">
            <section class="library-grid" aria-label="Trending posts">
                <c:forEach var="item" items="${trendingPosts}" varStatus="loop">
                    <c:set var="post" value="${item.post}" />
                    <c:url var="detailsUrl" value="/posts/${post.slug}" />
                    <article class="library-card">
                        <div class="card-content">
                            <div class="card-topline">
                                <span class="category-label"><c:out value="${post.category.name}" /></span>
                                <span class="metric-label"><c:out value="${item.todayViewCount}" /> views today</span>
                            </div>

                            <a class="card-title" href="${detailsUrl}"><c:out value="${post.title}" /></a>
                            <p class="card-excerpt">
                                <c:choose>
                                    <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
                                    <c:otherwise>A concise guide designed for quick reference.</c:otherwise>
                                </c:choose>
                            </p>

                            <div class="card-meta">
                                <span class="author-initial"><c:out value="${fn:substring(post.author.username, 0, 1)}" /></span>
                                <div>
                                    <strong><c:out value="${post.author.username}" /></strong>
                                    <small>Trending rank #<c:out value="${loop.count}" /></small>
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
