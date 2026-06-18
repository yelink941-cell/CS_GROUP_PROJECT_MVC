<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Post Form</title>
</head>
<body>
    <c:set var="formAction" value="${pageContext.request.contextPath}/user/posts/" />
    <c:if test="${post.id != null}">
        <c:set var="formAction" value="${pageContext.request.contextPath}/user/posts/update/${post.id}" />
    </c:if>

    <h2>
        <c:if test="${post.id == null}">Create Post</c:if>
        <c:if test="${post.id != null}">Edit Post</c:if>
    </h2>

    <c:if test="${not empty errorMessage}">
        <p style="color: red;"><c:out value="${errorMessage}" /></p>
    </c:if>

    <form action="${formAction}" method="post">
        <p>
            <label for="title">Title</label><br>
            <input type="text" id="title" name="title" value="${post.title}" required>
        </p>

        <p>
            <label for="slug">Slug</label><br>
            <input type="text" id="slug" name="slug" value="${post.slug}" required>
        </p>

        <p>
            <label for="excerpt">Excerpt</label><br>
            <textarea id="excerpt" name="excerpt" rows="5" cols="60"><c:out value="${post.excerpt}" /></textarea>
        </p>

        <p>
            <label for="categoryId">Category</label><br>
            <select id="categoryId" name="categoryId" required>
                <option value="">Select Category</option>
                <c:forEach var="category" items="${categories}">
                    <c:set var="categorySelected" value="false" />
                    <c:if test="${selectedCategoryId == category.id || post.category.id == category.id}">
                        <c:set var="categorySelected" value="true" />
                    </c:if>
                    <c:if test="${categorySelected}">
                        <option value="${category.id}" selected>
                            <c:out value="${category.name}" />
                        </option>
                    </c:if>
                    <c:if test="${not categorySelected}">
                        <option value="${category.id}">
                            <c:out value="${category.name}" />
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </p>

        <p>
            <label for="tagIds">Tags</label><br>
            <select id="tagIds" name="tagIds" multiple size="6">
                <c:forEach var="tag" items="${tags}">
                    <c:set var="tagSelected" value="false" />
                    <c:forEach var="selectedTagId" items="${selectedTagIds}">
                        <c:if test="${selectedTagId == tag.id}">
                            <c:set var="tagSelected" value="true" />
                        </c:if>
                    </c:forEach>
                    <c:forEach var="postTag" items="${post.tags}">
                        <c:if test="${postTag.id == tag.id}">
                            <c:set var="tagSelected" value="true" />
                        </c:if>
                    </c:forEach>
                    <c:if test="${tagSelected}">
                        <option value="${tag.id}" selected>
                            <c:out value="${tag.name}" />
                        </option>
                    </c:if>
                    <c:if test="${not tagSelected}">
                        <option value="${tag.id}">
                            <c:out value="${tag.name}" />
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </p>

        <p>
            <label for="status">Status</label><br>
            <select id="status" name="status" required>
                <c:forEach var="status" items="${statuses}">
                    <c:if test="${post.status == status}">
                        <option value="${status}" selected>
                            <c:out value="${status}" />
                        </option>
                    </c:if>
                    <c:if test="${post.status != status}">
                        <option value="${status}">
                            <c:out value="${status}" />
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </p>

        <p>
            <button type="submit">Save</button>
            <a href="${pageContext.request.contextPath}/user/posts/">Back to List</a>
        </p>
    </form>
</body>
</html>
