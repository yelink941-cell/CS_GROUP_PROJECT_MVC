<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Post Form - CheatSheet Hub</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css?v=2">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css?v=2">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-form.css?v=2">
<style>
    .section-builder {
        margin: 30px 0;
        padding-top: 26px;
        border-top: 1px solid #e2e8f0;
    }

    .section-builder-heading {
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
    }

    .section-builder-heading h2,
    .section-editor h3 {
        margin: 0;
    }

    .section-builder-heading p {
        margin: 6px 0 0;
        color: #687386;
    }

    .section-editor {
        margin-bottom: 18px;
        padding: 22px;
        border: 1px solid #e2e8f0;
        border-radius: 14px;
        background: #f8fafc;
    }

    .section-editor-header {
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
    }

    .remove-section {
        min-height: 34px;
        padding: 7px 11px;
    }

    @media (max-width: 640px) {
        .section-builder-heading,
        .section-editor-header {
            align-items: flex-start;
            flex-direction: column;
        }
    }
</style>
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

        <c:if test="${post.id == null}">
            <section class="section-builder">
                <div class="section-builder-heading">
                    <div>
                        <h2>Sections</h2>
                        <p>Add text, code, image, or table sections while creating this post.</p>
                    </div>
                    <button class="button button-secondary" id="addSectionButton" type="button">+ Add Section</button>
                </div>

                <div id="sectionsContainer">
                    <c:forEach var="submittedContent" items="${contentDataList}" varStatus="status">
                        <article class="section-editor">
                            <div class="section-editor-header">
                                <h3>Section</h3>
                                <button class="button button-danger remove-section" type="button">Remove Section</button>
                            </div>

                            <div class="form-group">
                                <label>Section Title</label>
                                <input class="form-control" type="text" name="sectionSubtitles[]"
                                       value="<c:out value='${sectionSubtitles[status.index]}' />"
                                       placeholder="Example: Java Data Types">
                            </div>

                            <div class="form-group">
                                <label>Content Type</label>
                                <select class="form-control" name="contentTypes[]" required>
                                    <c:forEach var="sectionType" items="${sectionTypes}">
                                        <c:choose>
                                            <c:when test="${selectedContentTypes[status.index] == sectionType}">
                                                <option value="${sectionType}" selected><c:out value="${sectionType}" /></option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${sectionType}"><c:out value="${sectionType}" /></option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Content Data</label>
                                <textarea class="form-control" name="contentDataList[]" rows="8" required
                                          placeholder="Enter section text, code, image URL, or table data"><c:out value="${submittedContent}" /></textarea>
                            </div>

                            <div class="form-group">
                                <label>Sort Order</label>
                                <input class="form-control" type="number" name="sortOrders[]" min="0" required
                                       value="${empty sortOrders[status.index] ? status.index + 1 : sortOrders[status.index]}">
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <div class="card-actions">
            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts">Back to List</a>
            <button class="button" type="submit">Save Post</button>
        </div>
    </form>
    </section>
    </main>

    <c:if test="${post.id == null}">
        <script>
            (function () {
                const sectionsContainer = document.getElementById("sectionsContainer");
                const addSectionButton = document.getElementById("addSectionButton");

                function addSection() {
                    const sectionNumber = sectionsContainer.children.length + 1;
                    const section = document.createElement("article");
                    section.className = "section-editor";
                    section.innerHTML = `
                        <div class="section-editor-header">
                            <h3>Section</h3>
                            <button class="button button-danger remove-section" type="button">Remove Section</button>
                        </div>
                        <div class="form-group">
                            <label>Section Title</label>
                            <input class="form-control" type="text" name="sectionSubtitles[]"
                                   placeholder="Example: Java Data Types">
                        </div>
                        <div class="form-group">
                            <label>Content Type</label>
                            <select class="form-control" name="contentTypes[]" required>
                                <option value="TEXT">TEXT</option>
                                <option value="CODE">CODE</option>
                                <option value="IMAGE">IMAGE</option>
                                <option value="TABLE">TABLE</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Content Data</label>
                            <textarea class="form-control" name="contentDataList[]" rows="8" required
                                      placeholder="Enter section text, code, image URL, or table data"></textarea>
                        </div>
                        <div class="form-group">
                            <label>Sort Order</label>
                            <input class="form-control" type="number" name="sortOrders[]" min="0"
                                   required>
                        </div>`;
                    sectionsContainer.appendChild(section);
                    section.querySelector('input[name="sortOrders[]"]').value = sectionNumber;
                }

                addSectionButton.addEventListener("click", addSection);
                sectionsContainer.addEventListener("click", function (event) {
                    if (event.target.classList.contains("remove-section")) {
                        event.target.closest(".section-editor").remove();
                    }
                });

                if (sectionsContainer.children.length === 0) {
                    addSection();
                }
            }());
        </script>
    </c:if>
</body>
</html>
