<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            <p class="form-help">Choose a content type and enter the section data.</p>

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

            <form method="post" action="${formAction}" enctype="multipart/form-data">
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

                <input id="contentData" type="hidden" name="contentData" value="<c:out value='${postContent.contentData}' />">

                <div class="form-group content-text-group">
                    <label for="contentTextInput">Content Data</label>
                    <textarea class="form-control content-data-input" id="contentTextInput" rows="14"
                              placeholder="Enter text or code"><c:out value="${postContent.contentData}" /></textarea>
                </div>

                <div class="form-group content-image-group" style="display: none;">
                    <label for="imageFile">Section Image</label>
                    <input class="form-control"
                           id="imageFile"
                           name="imageFile"
                           type="file"
                           accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp">
                    <p class="form-help">Upload JPG, JPEG, PNG, or WEBP. Maximum size: 5MB.</p>

                    <c:if test="${postContent.contentType == 'IMAGE' && not empty postContent.contentData}">
                        <div style="margin-top: 14px;">
                            <p class="form-help">Current image:</p>
                            <c:choose>
                                <c:when test="${fn:startsWith(postContent.contentData, '/')}">
                                    <img style="max-width: 260px; border-radius: 12px;"
                                         src="${pageContext.request.contextPath}${fn:escapeXml(postContent.contentData)}"
                                         alt="<c:out value='${postContent.subtitle}' />">
                                </c:when>
                                <c:otherwise>
                                    <img style="max-width: 260px; border-radius: 12px;"
                                         src="${fn:escapeXml(postContent.contentData)}"
                                         alt="<c:out value='${postContent.subtitle}' />">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>

                <div class="card-actions">
                    <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts/${postId}/contents">Cancel</a>
                    <button class="button" type="submit">${empty postContent.id ? 'Add Section' : 'Update Section'}</button>
                </div>
            </form>
        </section>
    </main>
    <script>
        (function () {
            const form = document.querySelector("form");
            const contentType = document.getElementById("contentType");
            const hiddenData = document.getElementById("contentData");
            const textGroup = document.querySelector(".content-text-group");
            const textInput = document.getElementById("contentTextInput");
            const imageGroup = document.querySelector(".content-image-group");
            const imageFile = document.getElementById("imageFile");
            const hasExistingImage = contentType.value === "IMAGE" && hiddenData.value.trim() !== "";

            function updateFields() {
                const isImage = contentType.value === "IMAGE";
                textGroup.style.display = isImage ? "none" : "block";
                imageGroup.style.display = isImage ? "block" : "none";

                if (isImage) {
                    textInput.removeAttribute("required");
                    if (!hasExistingImage) {
                        imageFile.setAttribute("required", "required");
                    }
                    return;
                }

                textInput.setAttribute("required", "required");
                imageFile.removeAttribute("required");
                imageFile.value = "";
                hiddenData.value = textInput.value;
            }

            contentType.addEventListener("change", updateFields);
            textInput.addEventListener("input", function () {
                if (contentType.value !== "IMAGE") {
                    hiddenData.value = textInput.value;
                }
            });
            form.addEventListener("submit", function () {
                if (contentType.value !== "IMAGE") {
                    hiddenData.value = textInput.value;
                }
            });

            updateFields();
        }());
    </script>
</body>
</html>
