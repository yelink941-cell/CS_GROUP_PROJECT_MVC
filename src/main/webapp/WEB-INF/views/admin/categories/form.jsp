<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Category Form</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/posts.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

<c:set var="formAction" value="${pageContext.request.contextPath}/admin/categories" />
<c:if test="${category.id != null}">
    <c:set var="formAction" value="${pageContext.request.contextPath}/admin/categories/update/${category.id}" />
</c:if>

<h2>
    <c:if test="${category.id == null}">Create Category</c:if>
    <c:if test="${category.id != null}">Edit Category</c:if>
</h2>

<c:if test="${not empty errorMessage}">
    <p style="color:red;"><c:out value="${errorMessage}" /></p>
</c:if>

<form action="${formAction}" method="post">
    <p>
        <label>Name</label><br>
        <input type="text" name="name" value="${category.name}" required>
    </p>

    <p>
        <label>Description</label><br>
        <textarea name="description" rows="5" cols="60"><c:out value="${category.description}" /></textarea>
    </p>

    <p>
        <label>Active</label>
        <input type="checkbox" name="isActive" value="true"
            <c:if test="${category.isActive == true || category.id == null}">checked</c:if>>
    </p>

    <button type="submit">Save</button>
    <a href="${pageContext.request.contextPath}/admin/categories">Back</a>
</form>

</body>
</html>
