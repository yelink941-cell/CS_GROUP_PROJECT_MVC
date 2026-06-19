<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Post Form - CheatSheet Hub</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/posts.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <c:set var="formAction" value="${pageContext.request.contextPath}/user/posts/" />
    <c:if test="${post.id != null}">
        <c:set var="formAction" value="${pageContext.request.contextPath}/user/posts/update/${post.id}" />
    </c:if>

    <main class="page-container">
    <section class="form-card">
        <h1>
            <c:if test="${post.id == null}">Create Post</c:if>
            <c:if test="${post.id != null}">Edit Post</c:if>
        </h1>

    <c:if test="${not empty errorMessage}">
        <p class="form-message-error"><c:out value="${errorMessage}" /></p>
    </c:if>

    <form action="${formAction}" method="post">
        <div class="form-group">
            <label for="title">Title</label>
            <input class="form-control" type="text" id="title" name="title" value="${post.title}" required>
        </div>

        <div class="form-group">
            <label for="slug">Slug</label>
            <input class="form-control" type="text" id="slug" name="slug" value="${post.slug}" required>
        </div>

        <div class="form-group">
            <label for="excerpt">Excerpt</label>
            <textarea class="form-control" id="excerpt" name="excerpt" rows="5"><c:out value="${post.excerpt}" /></textarea>
        </div>

        <div class="form-group">
            <label for="categoryId">Category</label>
            <select class="form-control" id="categoryId" name="categoryId" required>
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
        </div>

        <div class="form-group">
            <label for="tagIds">Tags</label>
            <select class="form-control" id="tagIds" name="tagIds" multiple size="6">
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
        </div>

        <div class="form-group">
            <label for="visibility">Visibility</label>
            <select class="form-control" id="visibility" name="visibility" required>
                <c:forEach var="visibility" items="${visibilities}">
                    <c:if test="${post.visibility == visibility}">
                        <option value="${visibility}" selected>
                            <c:out value="${visibility}" />
                        </option>
                    </c:if>
                    <c:if test="${post.visibility != visibility}">
                        <option value="${visibility}">
                            <c:out value="${visibility}" />
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>

        <div class="card-actions">
            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts">Back to List</a>
            <button class="button" type="submit">Save Post</button>
        </div>
    </form>
    </section>
    </main>
</body>
</html>
