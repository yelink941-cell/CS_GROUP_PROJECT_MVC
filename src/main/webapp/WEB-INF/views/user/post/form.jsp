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
 <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
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

    .section-image-group {
        display: none;
    }

    .section-image-help {
        margin: 8px 0 0;
        color: #64748b;
        font-size: 0.9rem;
    }

    /* ===== TAG MULTI SELECT ===== */
    .tag-multiselect {
        position: relative;
    }

    .tag-selector-box {
        padding: 10px;
        border: 1px solid #cbd5e1;
        border-radius: 12px;
        background: #fff;
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .tag-selector-box:focus-within {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }

    .tag-chip-list {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        min-height: 34px;
    }

    .tag-chip {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 7px 10px;
        border-radius: 999px;
        background: #e0f2fe;
        color: #075985;
        font-size: 0.92rem;
        font-weight: 700;
    }

    .tag-remove {
        width: 20px;
        height: 20px;
        border: 0;
        border-radius: 999px;
        background: rgba(7, 89, 133, 0.14);
        color: #075985;
        cursor: pointer;
        font-weight: 800;
        line-height: 1;
    }

    .tag-search-input {
        margin-top: 8px;
        border: 0;
        box-shadow: none;
        padding-left: 2px;
    }

    .tag-search-input:focus {
        box-shadow: none;
        outline: none;
    }

    .tag-options {
        position: absolute;
        top: calc(100% + 8px);
        left: 0;
        right: 0;
        z-index: 30;
        max-height: 230px;
        overflow-y: auto;
        border: 1px solid #dbe3ef;
        border-radius: 12px;
        background: #fff;
        box-shadow: 0 18px 40px rgba(15, 23, 42, 0.14);
        display: none;
    }

    .tag-options.is-open {
        display: block;
    }

    .tag-option {
        display: block;
        width: 100%;
        padding: 11px 14px;
        border: 0;
        background: transparent;
        color: #1e293b;
        cursor: pointer;
        text-align: left;
        font-weight: 600;
    }

    .tag-option:hover,
    .tag-option.is-active {
        background: #eff6ff;
        color: #1d4ed8;
    }

    .tag-empty {
        padding: 12px 14px;
        color: #64748b;
    }

    .tag-hidden-select {
        display: none;
    }

    .form-help {
        margin: 8px 0 0;
        color: #64748b;
        font-size: 0.9rem;
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

        .section-builder-heading,
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

            <form action="${formAction}" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="title">Title <span class="required">*</span></label>
                    <input class="form-control" type="text" id="title" name="title" value="${post.title}" required placeholder="Enter post title...">
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
                            <c:choose>
                                <c:when test="${categorySelected}">
                                    <option value="${category.id}" selected>
                                        <c:out value="${category.name}" />
                                    </option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${category.id}">
                                        <c:out value="${category.name}" />
                                    </option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="tagSearch">Tags</label>
                    <div class="tag-multiselect" data-tag-multiselect>
                        <div class="tag-selector-box">
                            <div class="tag-chip-list" id="selectedTagChips" aria-live="polite"></div>
                            <input class="form-control tag-search-input"
                                   type="text"
                                   id="tagSearch"
                                   placeholder="Search existing tags..."
                                   autocomplete="off"
                                   aria-controls="tagOptions"
                                   aria-expanded="false">
                        </div>
                        <div class="tag-options" id="tagOptions" role="listbox" aria-label="Available tags"></div>
                        <select class="tag-hidden-select" id="tagIds" name="tagIds" multiple aria-hidden="true" tabindex="-1">
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
                                <c:choose>
                                    <c:when test="${tagSelected}">
                                        <option value="${tag.id}" selected>
                                            <c:out value="${tag.name}" />
                                        </option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${tag.id}">
                                            <c:out value="${tag.name}" />
                                        </option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </select>
                        <p class="form-help">Select existing tags only. New tags are managed by admin.</p>
                    </div>
                </div>

                <div class="form-group">
                    <label for="visibility">Visibility <span class="required">*</span></label>
                    <select class="form-control" id="visibility" name="visibility" required>
                        <c:forEach var="visibility" items="${visibilities}">
                            <c:choose>
                                <c:when test="${post.visibility == visibility}">
                                    <option value="${visibility}" selected>
                                        <c:out value="${visibility}" />
                                    </option>
                                </c:when>
                                <c:otherwise>
                                    <option value="${visibility}">
                                        <c:out value="${visibility}" />
                                    </option>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </select>
                </div>

                <c:if test="${post.id == null}">
                    <section class="section-builder">
                        <div class="section-builder-heading">
                            <div>
                                <h2>📝 Sections</h2>
                                <p>Add text, code, or image sections while creating this post.</p>
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
                                        <select class="form-control section-content-type" name="contentTypes[]" required>
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

                                    <input class="content-data-hidden" type="hidden" name="contentDataList[]"
                                           value="<c:out value='${submittedContent}' />">

                                    <div class="form-group section-text-group">
                                        <label>Content Data</label>
                                        <textarea class="form-control section-content-text" rows="8"
                                                  placeholder="Enter section text or code"><c:out value="${submittedContent}" /></textarea>
                                    </div>

                                    <div class="form-group section-image-group">
                                        <label>Section Image</label>
                                        <input class="form-control section-image-input"
                                               type="file"
                                               name="contentImageFiles[]"
                                               accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp">
                                        <p class="section-image-help">Upload JPG, JPEG, PNG, or WEBP. Maximum size: 5MB.</p>
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
<footer class="site-footer">
    <div class="footer-container">
        <div class="footer-brand">
            <h2>📚 CheatSheet Hub</h2>
            <p>Community-built cheat sheets for quick learning, practical references, and clean knowledge sharing. Your go-to resource for developer guides and technical references.</p>
        </div>
        <div class="footer-links">
            <h3>Quick Links</h3>
            <nav>
                <a href="${pageContext.request.contextPath}/">🏠 Home</a>
                <a href="${pageContext.request.contextPath}/posts/public">📄 View Posts</a>
                <a href="${pageContext.request.contextPath}/posts/categories">📁 Categories</a>
                <a href="${pageContext.request.contextPath}/posts/popular">🔥 Popular</a>
                <a href="${pageContext.request.contextPath}/posts/trending">📈 Trending</a>
            </nav>
        </div>
 
    </div>
    <div class="footer-bottom">
        <small>&copy; 2026 CheatSheet Hub. All rights reserved.</small>
        <div class="footer-legal">
            <a href="#"><i class="fas fa-lock"></i> Privacy Policy</a>
            <a href="#"><i class="fas fa-file-contract"></i> Terms of Service</a>
            <a href="#"><i class="fas fa-envelope"></i> Contact</a>
        </div>
    </div>
</footer>
    <script>
        (function () {
            const tagWidget = document.querySelector("[data-tag-multiselect]");

            if (!tagWidget) {
                return;
            }

            const select = tagWidget.querySelector("#tagIds");
            const searchInput = tagWidget.querySelector("#tagSearch");
            const chipList = tagWidget.querySelector("#selectedTagChips");
            const optionsPanel = tagWidget.querySelector("#tagOptions");
            const tags = Array.from(select.options).map(function (option) {
                return {
                    id: option.value,
                    name: option.textContent.trim(),
                    option: option
                };
            });
            let activeIndex = -1;

            function getSelectedTags() {
                return tags.filter(function (tag) {
                    return tag.option.selected;
                });
            }

            function getAvailableTags() {
                const keyword = searchInput.value.trim().toLowerCase();

                return tags.filter(function (tag) {
                    return !tag.option.selected && tag.name.toLowerCase().includes(keyword);
                });
            }

            function renderChips() {
                const selectedTags = getSelectedTags();
                chipList.innerHTML = "";

                selectedTags.forEach(function (tag) {
                    const chip = document.createElement("span");
                    chip.className = "tag-chip";
                    chip.textContent = tag.name;

                    const removeButton = document.createElement("button");
                    removeButton.className = "tag-remove";
                    removeButton.type = "button";
                    removeButton.setAttribute("aria-label", "Remove " + tag.name);
                    removeButton.textContent = "x";
                    removeButton.addEventListener("click", function () {
                        tag.option.selected = false;
                        render();
                        searchInput.focus();
                    });

                    chip.appendChild(removeButton);
                    chipList.appendChild(chip);
                });
            }

            function renderOptions() {
                const availableTags = getAvailableTags();
                optionsPanel.innerHTML = "";

                if (availableTags.length === 0) {
                    const empty = document.createElement("div");
                    empty.className = "tag-empty";
                    empty.textContent = "No matching existing tags.";
                    optionsPanel.appendChild(empty);
                    activeIndex = -1;
                    return;
                }

                if (activeIndex >= availableTags.length) {
                    activeIndex = availableTags.length - 1;
                }

                availableTags.forEach(function (tag, index) {
                    const button = document.createElement("button");
                    button.className = "tag-option";
                    button.type = "button";
                    button.setAttribute("role", "option");
                    button.textContent = tag.name;

                    if (index === activeIndex) {
                        button.classList.add("is-active");
                    }

                    button.addEventListener("mousedown", function (event) {
                        event.preventDefault();
                    });
                    button.addEventListener("click", function () {
                        selectTag(tag);
                    });

                    optionsPanel.appendChild(button);
                });
            }

            function openOptions() {
                optionsPanel.classList.add("is-open");
                searchInput.setAttribute("aria-expanded", "true");
            }

            function closeOptions() {
                optionsPanel.classList.remove("is-open");
                searchInput.setAttribute("aria-expanded", "false");
                activeIndex = -1;
            }

            function selectTag(tag) {
                tag.option.selected = true;
                searchInput.value = "";
                activeIndex = -1;
                render();
                searchInput.focus();
            }

            function removeLastSelectedTag() {
                const selectedTags = getSelectedTags();

                if (selectedTags.length === 0) {
                    return;
                }

                selectedTags[selectedTags.length - 1].option.selected = false;
                render();
            }

            function render() {
                renderChips();
                renderOptions();
            }

            searchInput.addEventListener("focus", function () {
                renderOptions();
                openOptions();
            });

            searchInput.addEventListener("input", function () {
                activeIndex = 0;
                renderOptions();
                openOptions();
            });

            searchInput.addEventListener("keydown", function (event) {
                const availableTags = getAvailableTags();

                if (event.key === "ArrowDown") {
                    event.preventDefault();
                    activeIndex = availableTags.length === 0 ? -1 : (activeIndex + 1) % availableTags.length;
                    renderOptions();
                    openOptions();
                }

                if (event.key === "ArrowUp") {
                    event.preventDefault();
                    activeIndex = availableTags.length === 0
                            ? -1
                            : (activeIndex - 1 + availableTags.length) % availableTags.length;
                    renderOptions();
                    openOptions();
                }

                if (event.key === "Enter" && activeIndex >= 0 && availableTags[activeIndex]) {
                    event.preventDefault();
                    selectTag(availableTags[activeIndex]);
                }

                if (event.key === "Escape") {
                    closeOptions();
                }

                if (event.key === "Backspace" && searchInput.value.trim() === "") {
                    removeLastSelectedTag();
                }
            });

            document.addEventListener("click", function (event) {
                if (!tagWidget.contains(event.target)) {
                    closeOptions();
                }
            });

            render();
        }());
    </script>

    <c:if test="${post.id == null}">
        <script>
            (function () {
                const sectionsContainer = document.getElementById("sectionsContainer");
                const addSectionButton = document.getElementById("addSectionButton");
                const postForm = document.querySelector("form");

                function updateSectionFields(section) {
                    const contentType = section.querySelector(".section-content-type");
                    const textGroup = section.querySelector(".section-text-group");
                    const textInput = section.querySelector(".section-content-text");
                    const imageGroup = section.querySelector(".section-image-group");
                    const imageInput = section.querySelector(".section-image-input");
                    const hiddenInput = section.querySelector(".content-data-hidden");
                    const isImage = contentType && contentType.value === "IMAGE";

                    textGroup.style.display = isImage ? "none" : "block";
                    imageGroup.style.display = isImage ? "block" : "none";

                    if (isImage) {
                        textInput.removeAttribute("required");
                        imageInput.setAttribute("required", "required");
                        hiddenInput.value = "";
                        return;
                    }

                    textInput.setAttribute("required", "required");
                    imageInput.removeAttribute("required");
                    imageInput.value = "";
                    hiddenInput.value = textInput.value;
                }

                function syncSectionContentData() {
                    sectionsContainer.querySelectorAll(".section-editor").forEach(function (section) {
                        const contentType = section.querySelector(".section-content-type");
                        const textInput = section.querySelector(".section-content-text");
                        const hiddenInput = section.querySelector(".content-data-hidden");

                        if (contentType.value === "IMAGE") {
                            hiddenInput.value = "";
                            return;
                        }

                        hiddenInput.value = textInput.value;
                    });
                }

                function addSection() {
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
                            <select class="form-control section-content-type" name="contentTypes[]" required>
                                <option value="TEXT">TEXT</option>
                                <option value="CODE">CODE</option>
                                <option value="IMAGE">IMAGE</option>
                            </select>
                        </div>
                        <input class="content-data-hidden" type="hidden" name="contentDataList[]" value="">
                        <div class="form-group section-text-group">
                            <label>Content Data</label>
                            <textarea class="form-control section-content-text" rows="8"
                                      placeholder="Enter section text or code"></textarea>
                        </div>
                        <div class="form-group section-image-group">
                            <label>Section Image</label>
                            <input class="form-control section-image-input"
                                   type="file"
                                   name="contentImageFiles[]"
                                   accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp">
                            <p class="section-image-help">Upload JPG, JPEG, PNG, or WEBP. Maximum size: 5MB.</p>
                        </div>`;
                    sectionsContainer.appendChild(section);
                    updateSectionFields(section);
                }

                addSectionButton.addEventListener("click", addSection);

                sectionsContainer.addEventListener("click", function (event) {
                    if (event.target.classList.contains("remove-section")) {
                        event.target.closest(".section-editor").remove();
                    }
                });

                sectionsContainer.addEventListener("change", function (event) {
                    if (event.target.classList.contains("section-content-type")) {
                        updateSectionFields(event.target.closest(".section-editor"));
                    }
                });

                sectionsContainer.addEventListener("input", function (event) {
                    if (event.target.classList.contains("section-content-text")) {
                        const section = event.target.closest(".section-editor");
                        section.querySelector(".content-data-hidden").value = event.target.value;
                    }
                });

                postForm.addEventListener("submit", syncSectionContentData);

                sectionsContainer.querySelectorAll(".section-editor").forEach(updateSectionFields);

                if (sectionsContainer.children.length === 0) {
                    addSection();
                }
            }());
        </script>
    </c:if>
</body>
</html>
