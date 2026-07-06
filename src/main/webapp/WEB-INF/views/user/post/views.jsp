<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Views - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=9">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
</head>
<body class="my-posts-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container viewer-page-container">
        <header class="viewer-page-header">
            <div>
                <span>Viewer History</span>
                <h1><c:out value="${post.title}" /></h1>
                <p>See the accounts and guests who opened this public post.</p>
            </div>
            <div class="viewer-total">
                <strong><c:out value="${totalViews}" /></strong>
                <span>Total Views</span>
            </div>
        </header>

        <c:if test="${empty postViews}">
            <section class="empty-state">
                <h2>No views yet</h2>
                <p>Viewer history will appear when another user or guest opens this post.</p>
            </section>
        </c:if>

        <c:if test="${not empty postViews}">
            <div class="viewer-table-wrap">
                <table class="viewer-table">
                    <thead>
                        <tr>
                            <th>Viewer</th>
                            <th>Viewed At</th>
                            <th>IP Address</th>
                            <th>User Agent</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="view" items="${postViews}">
                            <tr>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty view.viewerName}"><c:out value="${view.viewerName}" /></c:when>
                                        <c:otherwise>Guest</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${view.viewedAt}" /></td>
                                <td><c:out value="${view.ipAddress}" /></td>
                                <td class="user-agent-cell" title="${fn:escapeXml(view.userAgent)}">
                                    <c:choose>
                                        <c:when test="${fn:length(view.userAgent) > 90}">
                                            <c:out value="${fn:substring(view.userAgent, 0, 90)}" />...
                                        </c:when>
                                        <c:otherwise><c:out value="${view.userAgent}" /></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <div class="viewer-page-actions">
            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts">Back to My Posts</a>
        </div>
    </main>
    <footer class="site-footer">
    <div class="footer-container">
        <div class="footer-brand">
            <h2>📚 CheatSheet Hub</h2>
            <p>Community-built cheat sheets for quick learning, practical references, and clean knowledge sharing. Your go-to resource for developer guides and technical references.</p>
        </div>
        <div class="footer-links">
            <h3>Quick Links</h3>
            <nav>
                <a href="${pageContext.request.contextPath}/">🏠 Home</a>
                <a href="${pageContext.request.contextPath}/posts/public">📄 View Posts</a>
                <a href="${pageContext.request.contextPath}/posts/categories">📁 Categories</a>
                <a href="${pageContext.request.contextPath}/posts/popular">🔥 Popular</a>
                <a href="${pageContext.request.contextPath}/posts/trending">📈 Trending</a>
            </nav>
        </div>
       
    </div>
    <div class="footer-bottom">
        <small>&copy; 2026 CheatSheet Hub. All rights reserved.</small>
        <div class="footer-legal">
            <a href="#"><i class="fas fa-lock"></i> Privacy Policy</a>
            <a href="#"><i class="fas fa-file-contract"></i> Terms of Service</a>
            <a href="#"><i class="fas fa-envelope"></i> Contact</a>
        </div>
    </div>
</footer>
</body>
</html>
