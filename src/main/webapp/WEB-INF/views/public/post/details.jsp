<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${post.title}" /> - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/posts.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <article class="detail-card">
            <h1><c:out value="${post.title}" /></h1>

            <div class="post-meta">
                <span><strong>Category:</strong> <c:out value="${post.category.name}" /></span>
                <span><strong>Author:</strong> <c:out value="${post.author.username}" /></span>
            </div>

            <div class="badge-row" style="margin-top: 18px;">
                <span class="visibility-badge visibility-public">PUBLIC</span>
                <span class="status-badge status-published">PUBLISHED</span>
            </div>

            <div class="detail-excerpt"><c:out value="${post.excerpt}" /></div>

            <a class="button button-secondary" href="${pageContext.request.contextPath}/posts/public">Back to Posts</a>
        </article>
    </main>
</body>
</html>
