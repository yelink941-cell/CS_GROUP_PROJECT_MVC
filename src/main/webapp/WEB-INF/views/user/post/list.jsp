<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Post Management</title>
</head>
<body>
    <h2>Post Management</h2>

    <p>
        <a href="${pageContext.request.contextPath}/user/posts/new">Create Post</a>
    </p>

    <c:if test="${empty posts}">
        <p>No posts found.</p>
    </c:if>

    <c:if test="${not empty posts}">
        <table border="1" cellpadding="8" cellspacing="0">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Slug</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="post" items="${posts}">
                    <tr>
                        <td><c:out value="${post.id}" /></td>
                        <td><c:out value="${post.title}" /></td>
                        <td><c:out value="${post.slug}" /></td>
                        <td><c:out value="${post.category.name}" /></td>
                        <td><c:out value="${post.status}" /></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/user/posts/edit/${post.id}">Edit</a>
                            |
                            <a href="${pageContext.request.contextPath}/user/posts/delete/${post.id}">Delete</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
</body>
</html>
