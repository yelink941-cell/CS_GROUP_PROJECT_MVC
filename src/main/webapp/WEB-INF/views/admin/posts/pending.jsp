<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Pending Posts</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />
    <main class="page-container">
    <h2>Pending Posts</h2>

    <p>
        <a href="${pageContext.request.contextPath}/admin-dashboard">Back to Dashboard</a>
    </p>

    <c:if test="${empty posts}">
        <p>No pending posts found.</p>
    </c:if>

    <c:if test="${not empty posts}">
        <div class="table-wrap">
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Slug</th>
                    <th>Category</th>
                    <th>Author</th>
                    <th>Created At</th>
                    <th>Status</th>
                    <th>Approve</th>
                    <th>Reject Reason</th>
                    <th>Reject</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="post" items="${posts}">
                    <tr>
                        <td><c:out value="${post.id}" /></td>
                        <td><c:out value="${post.title}" /></td>
                        <td><c:out value="${post.slug}" /></td>
                        <td><c:out value="${post.category.name}" /></td>
                        <td><c:out value="${post.author.username}" /></td>
                        <td><c:out value="${post.createdAt}" /></td>
                        <td><c:out value="${post.status}" /></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/posts/approve/${post.id}" method="post">
                                <button type="submit">Approve</button>
                            </form>
                        </td>
                        <td>
                            <form id="rejectForm${post.id}" action="${pageContext.request.contextPath}/admin/posts/reject/${post.id}" method="post">
                                <textarea name="rejectionReason" rows="3" cols="30" required></textarea>
                            </form>
                        </td>
                        <td>
                            <button type="submit" form="rejectForm${post.id}">Reject</button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        </div>
    </c:if>
    </main>
</body>
</html>
