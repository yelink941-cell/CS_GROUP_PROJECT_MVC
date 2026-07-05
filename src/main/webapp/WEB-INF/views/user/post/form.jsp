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
    /* ============================================
       POST FORM - SAME COLORS AS CATEGORY
       ============================================ */
    
    body {
        background: #f0f4f8;
    }
    
    .page-container {
        max-width: 900px;
        margin: 0 auto;
        padding: 30px 20px 60px;
    }
    
    /* ===== FORM CARD ===== */
    .form-card {
        background: #ffffff;
        border-radius: 16px;
        padding: 35px 40px 45px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
        border: 1px solid #e8edf4;
    }
    
    .form-card h1 {
        font-size: 28px;
        font-weight: 800;
        color: #1e293b;
        margin: 0 0 8px 0;
        padding-bottom: 16px;
        border-bottom: 2px solid #f1f5f9;
    }
    
    .form-card h1::before {
        content: "✏️ ";
    }
    
    /* ===== FORM ELEMENTS ===== */
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group label {
        display: block;
        font-weight: 600;
        font-size: 14px;
        color: #1e293b;
        margin-bottom: 6px;
    }
    
    .form-group label .required {
        color: #ef4444;
        margin-left: 2px;
    }
    
    .form-control {
        width: 100%;
        padding: 10px 14px;
        border: 1px solid #d1d9e6;
        border-radius: 10px;
        font-size: 14px;
        font-family: inherit;
        transition: border-color 0.2s, box-shadow 0.2s;
        background: #fafcff;
        color: #1e293b;
        box-sizing: border-box;
    }
    
    .form-control:focus {
        outline: none;
        border-color: #4f46e5;
        box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.12);
        background: #ffffff;
    }
    
    .form-control::placeholder {
        color: #94a3b8;
    }
    
    select.form-control {
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23475669' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 12px center;
        padding-right: 36px;
        cursor: pointer;
    }
    
    textarea.form-control {
        resize: vertical;
        min-height: 80px;
    }
    
    /* ===== MESSAGE ===== */
    .form-message-error {
        background: #fee2e2;
        color: #991b1b;
        padding: 14px 20px;
        border-radius: 10px;
        border-left: 4px solid #ef4444;
        margin-bottom: 20px;
        font-weight: 500;
    }
    
    .form-message-error::before {
        content: "❌ ";
    }
    
    /* ===== SECTION BUILDER ===== */
    .section-builder {
        margin: 30px 0;
        padding-top: 26px;
        border-top: 2px solid #e8edf4;
    }

    .section-builder-heading {
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 16px;
    }

    .section-builder-heading h2 {
        margin: 0;
        font-size: 18px;
        font-weight: 700;
        color: #1e293b;
    }

    .section-builder-heading p {
        margin: 4px 0 0;
        color: #64748b;
        font-size: 14px;
    }

    .section-editor {
        margin-bottom: 18px;
        padding: 22px 24px;
        border: 1px solid #e2e8f0;
        border-radius: 14px;
        background: #f8fafc;
        transition: border-color 0.2s;
    }
    
    .section-editor:hover {
        border-color: #c7d2fe;
    }

    .section-editor-header {
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
    }
    
    .section-editor-header h3 {
        margin: 0;
        font-size: 15px;
        font-weight: 600;
        color: #1e293b;
    }
    
    .section-editor-header h3::before {
        content: "📄 ";
    }

    /* ===== BUTTONS ===== */
    .button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        padding: 10px 24px;
        border: none;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.25s ease;
        text-decoration: none;
        background: #4f46e5;
        color: white;
    }
    
    .button:hover {
        background: #4338ca;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
    }
    
    .button-secondary {
        background: #f1f5f9;
        color: #1e293b;
        border: 1px solid #e2e8f0;
    }
    
    .button-secondary:hover {
        background: #e2e8f0;
        color: #0f172a;
        box-shadow: none;
        transform: translateY(-2px);
    }
    
    .button-danger {
        background: #fee2e2;
        color: #991b1b;
        border: 1px solid #fecaca;
    }
    
    .button-danger:hover {
        background: #fecaca;
        color: #7f1d1d;
        box-shadow: none;
        transform: translateY(-2px);
    }
    
    .card-actions {
        display: flex;
        gap: 12px;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 2px solid #f1f5f9;
    }
    
    .remove-section {
        min-height: 34px;
        padding: 7px 14px;
        font-size: 13px;
    }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 768px) {
        .page-container {
            padding: 20px 14px 40px;
        }
        
        .form-card {
            padding: 24px 18px 30px;
        }
        
        .form-card h1 {
            font-size: 22px;
        }
        
        .section-builder-heading {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .section-editor-header {
            flex-direction: column;
            align-items: flex-start;
        }
        
        .card-actions {
            flex-wrap: wrap;
        }
        
        .card-actions .button {
            width: 100%;
            justify-content: center;
        }
    }
    
    @media (max-width: 480px) {
        .form-card h1 {
            font-size: 18px;
        }
        
        .section-editor {
            padding: 16px;
        }
        
        .form-control {
            font-size: 13px;
            padding: 8px 12px;
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
            <label for="title">Title <span class="required">*</span></label>
            <input class="form-control" type="text" id="title" name="title" value="${post.title}" required placeholder="Enter post title...">
        </div>

        <div class="form-group">
            <label for="slug">Slug <span class="required">*</span></label>
            <input class="form-control" type="text" id="slug" name="slug" value="${post.slug}" required placeholder="e.g. java-spring-boot-guide">
        </div>

        <div class="form-group">
            <label for="excerpt">Excerpt</label>
            <textarea class="form-control" id="excerpt" name="excerpt" rows="5" placeholder="Brief description of your post..."><c:out value="${post.excerpt}" /></textarea>
        </div>

        <div class="form-group">
            <label for="categoryId">Category <span class="required">*</span></label>
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
            <small style="color: #94a3b8; font-size: 13px;">Hold Ctrl/Cmd to select multiple tags</small>
        </div>

        <div class="form-group">
            <label for="visibility">Visibility <span class="required">*</span></label>
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
                        <h2>📝 Sections</h2>
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
                                <label>Content Data <span class="required">*</span></label>
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
            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts">← Back to List</a>
            <button class="button" type="submit">💾 Save Post</button>
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