<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Tag Form</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/posts.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

<c:set var="formAction" value="${pageContext.request.contextPath}/admin/tags" />
<c:if test="${tag.id != null}">
    <c:set var="formAction" value="${pageContext.request.contextPath}/admin/tags/update/${tag.id}" />
</c:if>

<h2>
    <c:if test="${tag.id == null}">Create Tag</c:if>
    <c:if test="${tag.id != null}">Edit Tag</c:if>
</h2>

<c:if test="${not empty errorMessage}">
    <p style="color:red;"><c:out value="${errorMessage}" /></p>
</c:if>

<form action="${formAction}" method="post">
    <p>
        <label>Name</label><br>
        <input type="text" name="name" value="${tag.name}" required>
    </p>

    <button type="submit">Save</button>
    <a href="${pageContext.request.contextPath}/admin/tags">Back</a>
</form>

</body>
</html>
