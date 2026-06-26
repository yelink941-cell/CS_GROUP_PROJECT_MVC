<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cheat Sheets by Category - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <section class="hero">
            <h1>Cheat Sheets by Category</h1>
            <p>Choose a category to browse its published public cheat sheets.</p>
        </section>

        <c:if test="${empty categorySummaries}">
            <section class="empty-state">
                <h2>No categories found</h2>
                <p>No categories currently contain public published posts.</p>
            </section>
        </c:if>

        <c:if test="${not empty categorySummaries}">
            <section class="post-grid" aria-label="Public post categories">
                <c:forEach var="summary" items="${categorySummaries}">
                    <article class="post-card">
                        <h2><c:out value="${summary[0].name}" /></h2>
                        <p class="post-excerpt">
                            <c:choose>
                                <c:when test="${not empty summary[0].description}">
                                    <c:out value="${summary[0].description}" />
                                </c:when>
                                <c:otherwise>Browse cheat sheets in this category.</c:otherwise>
                            </c:choose>
                        </p>
                        <div class="post-meta">
                            <span><strong>Published posts:</strong> <c:out value="${summary[1]}" /></span>
                        </div>
                        <div class="card-actions">
                            <a class="button" href="${pageContext.request.contextPath}/posts/categories/${summary[0].id}">View Category</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>
    </main>
</body>
</html>
