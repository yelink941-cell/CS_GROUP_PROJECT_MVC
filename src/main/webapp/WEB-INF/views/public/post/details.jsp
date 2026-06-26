<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${post.title}" /> - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-detail.css">

<style>
.public-content-grid{
    display:grid !important;
    grid-template-columns:repeat(auto-fit,minmax(320px,1fr)) !important;
    gap:24px !important;
    margin-top:30px !important;
}

.public-content-card{
    background:#f3f1ff !important;
    border-radius:12px !important;
    overflow:hidden !important;
    box-shadow:0 12px 26px rgba(37,28,180,.12) !important;
}

.public-content-card-header{
    background:#4038ff !important;
    color:white !important;
    padding:14px 18px !important;
}

.public-content-card-header h2{
    color:white !important;
    margin:0 !important;
    font-size:20px !important;
}

.public-content-card-body{
    background:#f7f6ff !important;
    padding:18px !important;
    line-height:1.7 !important;
}

.public-code-content{
    background:#111827 !important;
    color:#e5e7eb !important;
    padding:16px !important;
    border-radius:10px !important;
    white-space:pre-wrap !important;
    overflow-x:auto !important;
}

.public-back-actions{
    margin-top:35px !important;
}

/* 📁 Collection Selector Styling */
.collection-box {
    margin-top: 24px; 
    padding-top: 20px; 
    border-top: 1px dashed #e2e8f0;
}
.collection-form {
    display: flex; 
    align-items: center; 
    gap: 12px; 
    flex-wrap: wrap;
}
.collection-label {
    font-size: 14px; 
    font-weight: 600; 
    color: #4b5563;
}
.collection-select {
    padding: 10px 16px; 
    border: 1px solid #d1d5db; 
    border-radius: 10px; 
    background-color: #ffffff; 
    color: #374151; 
    font-size: 14px; 
    min-width: 220px; 
    outline: none; 
    cursor: pointer;
}
.btn-add-collection {
    background: #4038ff; 
    color: white; 
    border: none; 
    padding: 10px 20px; 
    border-radius: 10px; 
    font-weight: 600; 
    cursor: pointer; 
    transition: background 0.2s, background-color 0.2s;
}
.btn-add-collection:hover {
    background: #312bc4;
}

/* 🎯 🌟 🔒 Item ရှိပြီးသား ဖိုဒါဆိုလျှင် ပြသမည့် ခလုတ်စတိုင်လ် (Disabled Style) */
.btn-add-collection:disabled {
    background-color: #94a3b8 !important; /* မီးခိုးရောင်မှိန်မှိန် */
    color: #f1f5f9 !important;
    cursor: not-allowed; /* နှိပ်လို့မရကြောင်း ပြောင်းလဲရန် */
    transform: none !important;
}
</style>
    
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <article class="detail-card">
            <h1><c:out value="${post.title}" /></h1>

            <div class="post-meta">
                <span><strong>Category:</strong> <c:out value="${post.category.name}" /></span>
                <span><strong>Author:</strong> <c:out value="${post.author.username}" /></span>
            </div>

            <div class="badge-row" style="margin-top: 18px;">
                <span class="visibility-badge visibility-public">PUBLIC</span>
                <span class="status-badge status-published">PUBLISHED</span>
            </div>

            <c:if test="${not empty post.tags}">
                <ul class="tag-list" aria-label="Post tags">
                    <c:forEach var="tag" items="${post.tags}">
                        <li class="tag-pill"><c:out value="${tag.name}" /></li>
                    </c:forEach>
                </ul>
            </c:if>

            <div class="detail-excerpt">
                <c:choose>
                    <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
                    <c:otherwise>No excerpt provided.</c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty sessionScope.userId}">
                <div class="collection-box">
                    <form action="${pageContext.request.contextPath}/user/collections/add-post" method="post" class="collection-form">
                        <input type="hidden" name="postId" value="${post.id}">
                        <input type="hidden" name="slug" value="${post.slug}">
                        
                        <label for="collectionSelect" class="collection-label">
                            📁 Save to Folder:
                        </label>
                        
                        <select id="collectionSelect" name="collectionId" required class="collection-select" onchange="checkFolderStatus()">
                            <option value="">-- Select Your Collection --</option>
                            <c:forEach var="col" items="${collections}">
                                <option value="${col.id}" data-saved="${col.posts.contains(post) ? 'true' : 'false'}">
                                    <c:out value="${col.name}" />
                                </option>
                            </c:forEach>
                        </select>
                        
                        <button id="addFolderBtn" type="submit" class="btn-add-collection">
                            ➕ Add to Folder
                        </button>
                    </form>
                </div>
            </c:if>
        </article>

        <section class="public-content-section">
            <c:if test="${empty contents}">
                <section class="empty-state">
                    <h2>No content sections yet</h2>
                </section>
            </c:if>

            <c:if test="${not empty contents}">
                <div class="public-content-grid" aria-label="Cheat sheet sections">
                    <c:forEach var="content" items="${contents}">
                        <article class="public-content-card">
                            <header class="public-content-card-header">
                                <h2>
                                    <c:choose>
                                        <c:when test="${not empty content.subtitle}"><c:out value="${content.subtitle}" /></c:when>
                                        <c:otherwise>Untitled Section</c:otherwise>
                                    </c:choose>
                                </h2>
                                <span><c:out value="${content.contentType}" /></span>
                            </header>

                            <div class="public-content-card-body">
                                <c:choose>
                                    <c:when test="${content.contentType == 'CODE'}">
                                        <pre class="public-code-content"><code><c:out value="${content.contentData}" /></code></pre>
                                    </c:when>
                                    <c:when test="${content.contentType == 'IMAGE'}">
                                        <img class="public-section-image" src="${fn:escapeXml(content.contentData)}" alt="${fn:escapeXml(content.subtitle)}">
                                    </c:when>
                                    <c:when test="${content.contentType == 'VIDEO'}">
                                        <video class="public-section-video" controls src="${fn:escapeXml(content.contentData)}"></video>
                                    </c:when>
                                    <c:when test="${content.contentType == 'LINK'}">
                                        <a class="public-section-link" href="${fn:escapeXml(content.contentData)}" target="_blank" rel="noopener noreferrer">
                                            <c:out value="${content.contentData}" />
                                        </a>
                                    </c:when>
                                    <c:when test="${content.contentType == 'TABLE'}">
                                        <pre class="public-table-content"><c:out value="${content.contentData}" /></pre>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="public-text-content"><c:out value="${content.contentData}" /></p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </c:if>
        </section>

        <c:if test="${not empty postFiles}">
            <section class="attachment-panel">
                <h2>Attachments</h2>
                <ul class="attachment-list">
                    <c:forEach var="postFile" items="${postFiles}">
                        <li>
                            <a class="button button-secondary"
                               href="${pageContext.request.contextPath}/posts/${post.slug}/files/${postFile.id}"
                               target="_blank">
                                <c:out value="${postFile.fileName}" />
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </section>
        </c:if>

        <div class="public-back-actions">
            <a class="button button-secondary" href="${pageContext.request.contextPath}/posts/public">Back to Posts</a>
        </div>
    </main>

    <script>
        function checkFolderStatus() {
            var selectBox = document.getElementById("collectionSelect");
            var actionBtn = document.getElementById("addFolderBtn");
            
            // Login မဝင်ထားသော User များ ကြည့်သည့်အခါ Element မရှိလျှင် Error မတက်စေရန်
            if (!selectBox || !actionBtn) return;
            
            // ရွေးချယ်ထားသော option ကို ယူခြင်း
            var selectedOption = selectBox.options[selectBox.selectedIndex];
            
            // Custom attribute ဖြစ်သော data-saved တန်ဖိုးကို လှမ်းဖတ်ခြင်း
            var isSaved = selectedOption.getAttribute("data-saved");

            if (selectBox.value === "") {
                // ဘာမှမရွေးချယ်ထားပါက မူရင်းအတိုင်း ပြန်ထားမည်
                actionBtn.innerHTML = "➕ Add to Folder";
                actionBtn.disabled = false;
            } 
            else if (isSaved === "true") {
                // 🎯 ရှိပြီးသား Folder ဖြစ်ပါက နှိပ်မရအောင် ပိတ်ပြီး စာသားပြောင်းမည်
                actionBtn.innerHTML = "✓ Saved";
                actionBtn.disabled = true;
            } 
            else {
                // 🎯 မရှိသေးသော Folder အသစ်ဖြစ်ပါက ပုံမှန်အတိုင်း ပြန်ဖွင့်ပေးမည်
                actionBtn.innerHTML = "➕ Add to Folder";
                actionBtn.disabled = false;
            }
        }
        
        // စာမျက်နှာ စတင်ပွင့်ပွင့်ချင်းမှာ အခြေအနေ မှန်ကန်နေစေရန် တစ်ကြိမ် Run ပေးခြင်း
        document.addEventListener("DOMContentLoaded", function() {
            checkFolderStatus();
        });
    </script>
</body>
</html>