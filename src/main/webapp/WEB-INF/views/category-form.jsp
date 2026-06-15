<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Save Category</title>
    <style>
        body { font-family: sans-serif; margin: 40px; background-color: #f4f6f9; }
        .form-box { background: white; padding: 30px; border-radius: 8px; max-width: 500px; margin: auto; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .form-group { margin-bottom: 15px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input[type="text"], textarea { width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
        .btn-submit { background: #007bff; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>

<div class="form-box">
    <h3>
        <c:choose>
            <c:when test="${category.id == 0}">Create New Category</c:when>
            <c:otherwise>Modify Category ID: ${category.id}</c:otherwise>
        </c:choose>
    </h3>
    
    <form:form action="${pageContext.request.contextPath}/admin/categories/save" method="POST" modelAttribute="category">
        
        <form:hidden path="id"/>

        <div class="form-group">
            <label>Category Name:</label>
            <form:input path="name" placeholder="e.g. Technology, Education" required="required"/>
        </div>

        <div class="form-group">
            <label>Description:</label>
            <form:textarea path="description" rows="4" placeholder="Brief metadata explanation regarding posts under this topic..."/>
        </div>

        <div class="form-group">
            <label>Availability Status:</label>
            <form:select path="isActive">
                <form:option value="true">Active (Visible)</form:option>
                <form:option value="false">Inactive (Hidden)</form:option>
            </form:select>
        </div>

        <button type="submit" class="btn-submit">Save Category Structure</button>
        <a href="${pageContext.request.contextPath}/admin/categories" style="margin-left:15px; color:#666;">Cancel</a>
    </form:form>
</div>

</body>
</html>