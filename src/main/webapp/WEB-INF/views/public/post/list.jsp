<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${pageTitle}" /> - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=8">
</head>
<body class="public-list-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container public-list-container">
        <header class="library-header">
            <span>Public Library</span>
            <h1><c:out value="${pageTitle}" /></h1>
            <p><c:out value="${pageDescription}" /></p>
        </header>

        <c:if test="${empty posts}">
            <section class="empty-state">
                <h2>No posts found</h2>
                <p><c:out value="${emptyMessage}" /></p>
            </section>
        </c:if>

        <c:if test="${not empty posts}">
            <section class="library-grid" aria-label="Public posts">
                <c:forEach var="post" items="${posts}">
                    <c:url var="detailsUrl" value="/posts/${post.slug}" />

                    <article class="library-card">
                        <div class="card-content">
                            <div class="card-topline">
                                <span class="category-label"><c:out value="${post.category.name}" /></span>
                                <span class="card-state">
                                    <span class="public-label">Public</span>
                                    <span class="view-count-text"><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /> views</span>
                                </span>
                            </div>

                            <a class="card-title" href="${detailsUrl}"><c:out value="${post.title}" /></a>

                            <p class="card-excerpt">
                                <c:choose>
                                    <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
                                    <c:otherwise>A concise guide designed for fast learning and everyday reference.</c:otherwise>
                                </c:choose>
                            </p>

                            <div class="card-meta" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <span class="author-initial"><c:out value="${fn:substring(post.author.username, 0, 1)}" /></span>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/profile?id=${post.author.id}" style="text-decoration: none; color: inherit;">
                                            <strong>@<c:out value="${post.author.username}" /></strong>
                                        </a>
                                        <c:if test="${not empty post.createdAt}">
                                            <br><small><c:out value="${fn:substring(post.createdAt, 0, 10)}" /></small>
                                        </c:if>
                                    </div>
                                </div>

                                <c:if test="${not empty currentUser && currentUser.id != post.author.id}">
                                    <c:choose>
                                        <c:when test="${post.followedByCurrentUser}">
                                            <form action="${pageContext.request.contextPath}/user/unfollow" method="POST" style="margin: 0;">
                                                <input type="hidden" name="targetId" value="${post.author.id}" />
                                                <button type="submit" style="background: none; border: 1px solid #cbd5e1; color: #64748b; padding: 4px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; cursor: pointer;">
                                                    ✓ Following
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/user/follow" method="POST" style="margin: 0;">
                                                <input type="hidden" name="targetId" value="${post.author.id}" />
                                                <button type="submit" style="background: #4038ff; border: none; color: white; padding: 4px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; cursor: pointer;">
                                                    ➕ Follow
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </div>

                            <a class="read-link" href="${detailsUrl}">Read More <span>→</span></a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>
    </main>
</body>
</html>
