<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Post Details</title>
</head>
<body>

    <h3>Comments</h3>
    <ul>
        <c:forEach var="comment" items="${comments}">
            <li>
                <strong>${comment.user.username}:</strong> ${comment.content}
                <br><small>${comment.createdAt}</small>
                
            </li>
        </c:forEach>
        
        
    </ul>

    <hr>

    <h2>Add Comment</h2>
    <form action="${pageContext.request.contextPath}/comments/add" method="POST" onsubmit="alert('Submitting Post ID: ' + document.getElementsByName('postId')[0].value + '\nContent: ' + document.getElementsByName('content')[0].value);">
    <input type="hidden" name="postId" value="${post.id}" />
    <textarea name="content" required placeholder="Write a comment..."></textarea>
    <br>
    <button type="submit">Post Comment</button>
</form>
</body>
</html>