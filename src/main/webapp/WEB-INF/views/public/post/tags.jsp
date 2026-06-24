<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cheat Sheets by Tag - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <section class="hero">
            <h1>Cheat Sheets by Tag</h1>
            <p>Choose a tag to browse related published public cheat sheets.</p>
        </section>

        <c:if test="${empty tagSummaries}">
            <section class="empty-state">
                <h2>No tags found</h2>
                <p>No tags currently contain public published posts.</p>
            </section>
        </c:if>

        <c:if test="${not empty tagSummaries}">
            <section class="post-grid" aria-label="Public post tags">
                <c:forEach var="summary" items="${tagSummaries}">
                    <article class="post-card">
                        <h2><c:out value="${summary[0].name}" /></h2>
                        <div class="post-meta">
                            <span><strong>Published posts:</strong> <c:out value="${summary[1]}" /></span>
                        </div>
                        <div class="card-actions">
                            <a class="button" href="${pageContext.request.contextPath}/posts/tags/${summary[0].id}">View Tag</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>
    </main>
</body>
</html>
