<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Files - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-files.css">
    <style>
        .file-list { margin: 28px 0 0; padding: 0; list-style: none; display: grid; gap: 12px; }
        .file-item { padding: 16px; border: 1px solid #e2e8f0; border-radius: 10px; display: flex; align-items: center; justify-content: space-between; gap: 16px; }
        .file-details { display: grid; gap: 5px; min-width: 0; }
        .file-name { font-weight: 700; overflow-wrap: anywhere; }
        .file-type { color: #64748b; font-size: 0.9rem; }
        .form-message-success { padding: 12px 14px; color: #166534; border-radius: 8px; background: #dcfce7; }
        @media (max-width: 600px) { .file-item { align-items: flex-start; flex-direction: column; } }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <section class="form-card">
            <h1>Post Files</h1>
            <p>Upload PDF, PNG, JPG, or JPEG files. Maximum file size: 5MB.</p>

            <c:if test="${not empty successMessage}">
                <p class="form-message-success"><c:out value="${successMessage}" /></p>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <p class="form-message-error"><c:out value="${errorMessage}" /></p>
            </c:if>

            <form action="${pageContext.request.contextPath}/user/posts/${postId}/files/upload"
                  method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="file">Select File</label>
                    <input class="form-control" type="file" id="file" name="file"
                           accept=".pdf,.png,.jpg,.jpeg,application/pdf,image/png,image/jpeg" required>
                </div>

                <div class="card-actions">
                    <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts">Back to My Posts</a>
                    <button class="button" type="submit">Upload File</button>
                </div>
            </form>

            <c:if test="${empty postFiles}">
                <div class="empty-state" style="margin-top: 28px; box-shadow: none;">
                    No files uploaded for this post.
                </div>
            </c:if>

            <c:if test="${not empty postFiles}">
                <ul class="file-list">
                    <c:forEach var="postFile" items="${postFiles}">
                        <li class="file-item">
                            <div class="file-details">
                                <span class="file-name"><c:out value="${postFile.fileName}" /></span>
                                <span class="file-type"><c:out value="${postFile.fileType}" /></span>
                            </div>
                            <div class="card-actions" style="margin: 0;">
                                <a class="button button-secondary"
                                   href="${pageContext.request.contextPath}/user/posts/${postId}/files/${postFile.id}"
                                   target="_blank" rel="noopener">View</a>
                                <a class="button"
                                   href="${pageContext.request.contextPath}/posts/files/${postFile.id}/download">Download</a>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </c:if>
        </section>
    </main>
</body>
</html>
