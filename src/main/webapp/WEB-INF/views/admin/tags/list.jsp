<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tag Management</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

<h2>Tag Management</h2>

<p>
    <a href="${pageContext.request.contextPath}/admin/tags/new">Create Tag</a>
</p>

<c:if test="${empty tags}">
    <p>No tags found.</p>
</c:if>

<c:if test="${not empty tags}">
    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Actions</th>
        </tr>

        <c:forEach var="tag" items="${tags}">
            <tr>
                <td>${tag.id}</td>
                <td><c:out value="${tag.name}" /></td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/tags/edit/${tag.id}">Edit</a>
                    |
                    <a href="${pageContext.request.contextPath}/admin/tags/delete/${tag.id}">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>

</body>
</html>
