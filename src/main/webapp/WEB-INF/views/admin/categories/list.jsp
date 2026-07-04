<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Category Management</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

<h2>Category Management</h2>

<p>
    <a href="${pageContext.request.contextPath}/admin/categories/new">Create Category</a>
</p>

<c:if test="${empty categories}">
    <p>No categories found.</p>
</c:if>

<c:if test="${not empty categories}">
    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Active</th>
            <th>Actions</th>
        </tr>

        <c:forEach var="category" items="${categories}">
            <tr>
                <td>${category.id}</td>
                <td><c:out value="${category.name}" /></td>
                <td><c:out value="${category.description}" /></td>
                <td>${category.isActive}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/categories/edit/${category.id}">Edit</a>
                    |
                    <a href="${pageContext.request.contextPath}/admin/categories/delete/${category.id}">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>

</body>
</html>
