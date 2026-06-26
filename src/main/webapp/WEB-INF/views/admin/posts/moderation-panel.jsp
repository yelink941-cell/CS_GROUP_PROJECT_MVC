<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Comment Management - CheatSheet Hub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

         
    <jsp:include page="/WEB-INF/views/admin-header.jsp" />

    <div class="container my-4">
        <h2>Comment Management Panel</h2>
        
        <div class="card shadow-sm border-0 mt-4">
            <div class="card-body">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>User</th>
                            <th>Post Title</th>
                            <th>Comment</th>
                            <th>Action</th> </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="comment" items="${comments}">
    <tr>
        <td>${comment.id}</td>
        <td>${comment.user.username}</td>
        <td>${comment.post.title}</td>
        <td>${comment.content}</td>
        <td>
            
            <a href="${pageContext.request.contextPath}/admin/comments/delete/${comment.id}" 
               class="btn btn-sm btn-outline-danger" 
               onclick="return confirm('Delete this comment?')">Delete</a>
        </td>
    </tr>
</c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>