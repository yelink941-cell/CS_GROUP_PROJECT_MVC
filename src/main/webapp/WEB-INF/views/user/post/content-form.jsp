<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty postContent.id ? 'Add Section' : 'Edit Section'} - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-form.css">
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <section class="form-card">
            <h1>${empty postContent.id ? 'Add Section' : 'Edit Section'}</h1>
            <p class="form-help">Choose a content type, enter the section data, and use sort order to control its position.</p>

            <c:if test="${not empty errorMessage}">
                <p class="form-message-error"><c:out value="${errorMessage}" /></p>
            </c:if>

            <c:choose>
                <c:when test="${empty postContent.id}">
                    <c:url var="formAction" value="/user/posts/${postId}/contents/add" />
                </c:when>
                <c:otherwise>
                    <c:url var="formAction" value="/user/posts/${postId}/contents/update/${postContent.id}" />
                </c:otherwise>
            </c:choose>

            <form method="post" action="${formAction}">
                <div class="form-group">
                    <label for="subtitle">Subtitle</label>
                    <input class="form-control" id="subtitle" name="subtitle" type="text" maxlength="500"
                           value="<c:out value='${postContent.subtitle}' />" placeholder="Example: Java Data Types">
                </div>

                <div class="form-group">
                    <label for="contentType">Content Type</label>
                    <select class="form-control" id="contentType" name="contentType" required>
                        <c:forEach var="type" items="${contentTypes}">
                            <option value="${type}" ${postContent.contentType == type ? 'selected' : ''}>
                                <c:out value="${type}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="contentData">Content Data</label>
                    <textarea class="form-control content-data-input" id="contentData" name="contentData" rows="14" required
                              placeholder="Enter text, code, table data, or a media URL"><c:out value="${postContent.contentData}" /></textarea>
                </div>

                <div class="form-group">
                    <label for="sortOrder">Sort Order</label>
                    <input class="form-control" id="sortOrder" name="sortOrder" type="number" min="0"
                           value="<c:out value='${postContent.sortOrder}' />">
                </div>

                <div class="card-actions">
                    <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts/${postId}/contents">Cancel</a>
                    <button class="button" type="submit">${empty postContent.id ? 'Add Section' : 'Update Section'}</button>
                </div>
            </form>
        </section>
    </main>
</body>
</html>
