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

.button-link {
    background: none;
    border: none;
    color: #4038ff;
    cursor: pointer;
    padding: 0;
    text-decoration: underline;
    font-size: 13px;
}

/* Like ခလုတ် အရောင်ပြောင်း Class များ */
.liked-btn {
    background-color: #007bff !important;
    color: white !important;
    border: 1px solid #007bff !important;
}

.unliked-btn {
    background-color: #ffffff !important;
    color: #333333 !important;
    border: 1px solid #cccccc !important;
}

/* Rating Section Styles */
.rating-section {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-top: 20px;
    margin-bottom: 20px;
    border-bottom: 1px solid #eee;
    padding-bottom: 15px;
}
.star-rating {
    direction: rtl;
    display: inline-flex;
    font-size: 24px;
    unicode-bidi: bidi-override;
}
.star-rating input {
    display: none;
}
.star-rating label {
    color: #ccc;
    cursor: pointer;
    transition: color 0.2s;
}
.star-rating label:hover,
.star-rating label:hover ~ label,
.star-rating input:checked ~ label {
    color: #ffc107; /* ရွှေရောင် */
}
.average-rating-box {
    font-size: 15px;
    background: #fff3cd;
    padding: 6px 12px;
    border-radius: 6px;
    border: 1px solid #ffeeba;
}
/* Bookmark ခလုတ် အရောင်ပြောင်း Class များ */
.bookmarked-btn {
    background-color: #ffc107 !important;
    color: #333333 !important;
    border: 1px solid #ffc107 !important;
}

.unbookmarked-btn {
    background-color: #ffffff !important;
    color: #333333 !important;
    border: 1px solid #cccccc !important;
}

.btn-report {
    background-color: #fff5f5 !important;
    color: #dc2626 !important;
    border: 1px solid #fecaca !important;
}

.btn-report:hover {
    background-color: #fee2e2 !important;
}

.report-modal-backdrop {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(15, 23, 42, 0.45);
    z-index: 1000;
    align-items: center;
    justify-content: center;
}

.report-modal-backdrop.active {
    display: flex;
}

.report-modal {
    background: #ffffff;
    border-radius: 12px;
    padding: 24px;
    width: min(420px, 92vw);
    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.18);
}

.report-modal h3 {
    margin: 0 0 16px;
}

.report-modal label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 6px;
    color: #374151;
}

.report-modal select,
.report-modal textarea {
    width: 100%;
    box-sizing: border-box;
    margin-bottom: 14px;
    padding: 10px 12px;
    border: 1px solid #d1d5db;
    border-radius: 8px;
    font-size: 14px;
}

.report-modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
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
                <span><strong>Views:</strong> <c:out value="${empty post.viewCount ? 0 : post.viewCount}" /></span>
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

       <%-- action လမ်းကြောင်းကို သေချာစစ်ပါ --%>
<form action="${pageContext.request.contextPath}/user/collections/add-post" method="post">
    <input type="hidden" name="postId" value="${post.id}">
    <input type="hidden" name="slug" value="${post.slug}">
    
    <select id="collectionSelect" name="collectionId" required>
        <option value="">-- Select --</option>
        <c:forEach var="col" items="${collections}">
            <option value="${col.id}">${col.name}</option>
        </c:forEach>
    </select>
    
    <button type="submit">➕ Add to Folder</button>
</form>

      <div class="rating-section">
    <div class="star-rating">
        <c:forEach begin="1" end="5" var="i">
            <input type="radio" id="star${i}" name="rating" value="${i}" 
                   class="star-input"
                   data-post-id="${post.id}"
                   <c:if test="${userRating == i}">checked</c:if>>
            <label for="star${i}">★</label>
        </c:forEach>
    </div>
    <div class="average-rating-box">
        <strong>⭐ Average:</strong> <span id="avgRatingValue">${not empty averageRating ? averageRating : 0.0}</span>
    </div>
</div>

    <div class="comments-section">
      <div class="like-section">
   <button type="button" 
        onclick="toggleLikePost('${post.id}', this)" 
        class="button ${hasUserLiked ? 'liked-btn' : 'unliked-btn'}">
    <span id="likeIcon-${post.id}">
        ${hasUserLiked ? '👍 Unlike' : '👍🏻 Like'}
    </span>
</button>
    <span id="likeCount-${post.id}">${likeCount}</span>
            
    <button type="button" 
            onclick="toggleBookmark('${post.id}', this)" 
            id="bookmarkBtn-${post.id}"
            class="btn ${hasUserBookmarked ? 'btn-warning' : 'btn-outline-warning'}">
        <span id="bookmarkText-${post.id}">${hasUserBookmarked ? 'Bookmarked' : 'Bookmark'}</span>
    </button>

    <c:if test="${sessionScope.userId != null && sessionScope.userId != post.author.id}">
        <button type="button"
                class="button btn-report"
                onclick="openReportModal('post', ${post.id})">
            ⚠ Report Post
        </button>
    </c:if>
</div>

        <div id="commentsToggleWrapper">
            <c:forEach var="comment" items="${comments}">
                <div id="comment-${comment.id}">
                    <strong>${comment.user.username}</strong>
                    <p>${comment.content}</p>
                    <button type="button" onclick="toggleReplyForm('c-${comment.id}')">Reply</button>
                    <c:if test="${sessionScope.userId != null && sessionScope.userId != comment.user.id}">
                        <button type="button" class="button-link" style="color:#dc2626; margin-left:8px;"
                                onclick="openReportModal('comment', ${comment.id})">Report</button>
                    </c:if>
                    
                    <div id="replyFormContainer-c-${comment.id}" style="display: none;">
                        <form onsubmit="submitReply(event, 'c-${comment.id}', '${comment.id}', '${post.id}')">
                            <textarea id="replyText-c-${comment.id}"></textarea>
                            <button type="submit">Reply ပို့မည်</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
            <div class="card-actions" style="margin-top: 20px;">
                <a class="button" href="${pageContext.request.contextPath}/posts/${post.slug}/download-pdf">
                    Download Full PDF
                </a>
            </div>
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
                               href="${pageContext.request.contextPath}/posts/files/${postFile.id}/download">
                                Download <c:out value="${postFile.fileName}" />
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

    <div id="reportModalBackdrop" class="report-modal-backdrop" onclick="closeReportModal(event)">
        <div class="report-modal" onclick="event.stopPropagation()">
            <h3 id="reportModalTitle">Report Content</h3>
            <label for="reportReason">Reason</label>
            <select id="reportReason">
                <option value="TEXT">Inappropriate text</option>
                <option value="CODE">Harmful code</option>
                <option value="IMAGE">Inappropriate image</option>
                <option value="VIDEO">Inappropriate video</option>
                <option value="LINK">Suspicious link</option>
            </select>
            <label for="reportDescription">Details (optional)</label>
            <textarea id="reportDescription" rows="4" placeholder="Describe the issue..."></textarea>
            <div class="report-modal-actions">
                <button type="button" class="button button-secondary" onclick="closeReportModal()">Cancel</button>
                <button type="button" class="button btn-report" onclick="submitReport()">Submit Report</button>
            </div>
        </div>
    </div>

  <script>
    // 🟢 အရေးကြီး: JSP ကနေ contextPath ကို တစ်ခါတည်း JS variable အဖြစ် ယူထားပါ
   const contextPath = "${pageContext.request.contextPath}";
   let reportTarget = { type: null, id: null };

    function openReportModal(type, id) {
        reportTarget = { type, id };
        document.getElementById('reportModalTitle').innerText =
            type === 'post' ? 'Report Post' : 'Report Comment';
        document.getElementById('reportReason').value = 'TEXT';
        document.getElementById('reportDescription').value = '';
        document.getElementById('reportModalBackdrop').classList.add('active');
    }

    function closeReportModal(event) {
        if (event && event.target !== event.currentTarget) {
            return;
        }
        document.getElementById('reportModalBackdrop').classList.remove('active');
        reportTarget = { type: null, id: null };
    }

    function submitReport() {
        if (!reportTarget.type || !reportTarget.id) {
            return;
        }

        const reason = document.getElementById('reportReason').value;
        const description = document.getElementById('reportDescription').value || '';
        const url = reportTarget.type === 'post'
            ? contextPath + '/posts/report/' + reportTarget.id
            : contextPath + '/comments/report/' + reportTarget.id;

        fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'reason=' + encodeURIComponent(reason) + '&description=' + encodeURIComponent(description)
        })
        .then(response => response.text().then(text => ({ ok: response.ok, text })))
        .then(result => {
            closeReportModal();
            alert(result.text || (result.ok ? 'Report submitted.' : 'Report failed.'));
        })
        .catch(() => alert('Report failed. Please try again.'));
    }

    // --- ၁။ Folder Status စစ်ဆေးခြင်း ---
    function checkFolderStatus() {
        var selectBox = document.getElementById("collectionSelect");
        var actionBtn = document.getElementById("addFolderBtn");
        if (!selectBox || !actionBtn) return;
        
        var selectedOption = selectBox.options[selectBox.selectedIndex];
        var isSaved = selectedOption.getAttribute("data-saved");

        if (selectBox.value === "") {
            actionBtn.innerHTML = "➕ Add to Folder";
            actionBtn.disabled = false;
        } else if (isSaved === "true") {
            actionBtn.innerHTML = "✓ Saved";
            actionBtn.disabled = true;
        } else {
            actionBtn.innerHTML = "➕ Add to Folder";
            actionBtn.disabled = false;
        }
    }

    // --- ၂။ Main Comment တင်ခြင်း ---
    document.getElementById('commentForm')?.addEventListener('submit', function(e) {
        e.preventDefault(); 
        const postId = document.getElementById('postId').value;
        const commentText = document.getElementById('commentText').value;

        fetch(contextPath + '/comments/add', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'postId=' + encodeURIComponent(postId) + '&commentText=' + encodeURIComponent(commentText)
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                sessionStorage.setItem('isCommentsOpen', 'true');
                location.reload(); 
            } else {
                alert('Comment သိမ်းဆည်းရာတွင် အမှားအယွင်းဖြစ်သွားပါသည်။');
            }
        });
    });

    // --- ၃။ Reply လုပ်ဆောင်ချက် ---
   function toggleReplyForm(id) {
            const el = document.getElementById('replyFormContainer-' + id);
            el.style.display = (el.style.display === 'none') ? 'block' : 'none';
        }

    function submitReply(e, uniqueId, parentId, formPostId) {
        e.preventDefault();
        const content = document.getElementById('replyText-' + uniqueId).value;
        fetch(contextPath + '/comments/reply', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'postId=' + encodeURIComponent(formPostId) + '&parentId=' + encodeURIComponent(parentId) + '&content=' + encodeURIComponent(content)
        })
        .then(res => { if (res.ok) location.reload(); });
    }
    // --- ၄။ Comment ဖျက်ခြင်း ---
    function deleteComment(commentId) {
        if (!confirm('ဤ comment ကို အမှန်တကယ် ဖျက်မှာလား?')) return;
        fetch(contextPath + '/comments/delete/' + commentId, { method: 'POST' })
        .then(response => { if (response.ok) location.reload(); });
    }

    // --- ၅။ Like / Bookmark / Rating ---
function toggleLikePost(postId, btn) {
    fetch(contextPath + '/user/posts/like', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'postId=' + encodeURIComponent(postId)
    })
    .then(res => res.json())
    .then(data => {
        if(data.status === 'success') {
            document.getElementById('likeCount-' + postId).innerText = data.totalLikes;
            
            // Class ပြောင်းလဲမှု
            btn.className = "button " + (data.isLiked ? "liked-btn" : "unliked-btn");
            
            // Icon ပြောင်းလဲမှု
            document.getElementById('likeIcon-' + postId).innerHTML = data.isLiked ? "👍 Unlike" : "👍🏻 Like";
        }
    })
    .catch(err => console.error("Error:", err));
}

   function submitRating(postId, ratingValue) {
       fetch(contextPath + '/api/toggle-rating', {
           method: 'POST',
           headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
           body: 'postId=' + encodeURIComponent(postId) + '&rating=' + encodeURIComponent(ratingValue)
       })
       .then(response => response.json())
       .then(data => {
           if (data.status === 'success') {
               // UI မှာ Average Rating ကို အပ်ဒိတ်လုပ်ပါ
               document.getElementById('avgRatingValue').innerText = data.averageRating;
           } else {
               alert('Rating ပေးရာတွင် အမှားဖြစ်နေပါသည်။');
           }
       })
       .catch(error => {
           console.error('Error:', error);
           alert('Server နှင့် ချိတ်ဆက်မှု အဆင်မပြေပါ။');
       });
   }
    function toggleBookmark(postId, buttonElement) {
        fetch(contextPath + '/api/toggle-bookmark', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'postId=' + postId
        })
        .then(response => response.json())
        .then(data => {
            if (data.isBookmarked) {
                document.getElementById('bookmarkIcon-' + postId).innerHTML = "⭐ Bookmarked";
                buttonElement.className = "button bookmarked-btn";
            } else {
                document.getElementById('bookmarkIcon-' + postId).innerHTML = "⭐ Bookmark";
                buttonElement.className = "button unbookmarked-btn";
            }
        });
    }

    function resetCleanUrl(postId) {
        const cleanUrl = contextPath + '/user/posts/details/' + postId;
        if (window.history.replaceState) window.history.replaceState(null, '', cleanUrl);
    }

    // --- ၆။ Page Load ---
   function checkFolderStatus() {
    var selectBox = document.getElementById("collectionSelect");
    var actionBtn = document.getElementById("addFolderBtn");
    
    if (!selectBox || !actionBtn) return;
    
    // ရွေးထားတဲ့ option ကို ယူပါ
    var selectedOption = selectBox.options[selectBox.selectedIndex];
    var isSaved = selectedOption.getAttribute("data-saved"); // 'true' သို့မဟုတ် 'false' ရရှိပါမယ်

    if (selectBox.value === "") {
        actionBtn.innerHTML = "➕ Add to Folder";
        actionBtn.disabled = false;
    } else if (isSaved === "true") {
        actionBtn.innerHTML = "✓ Saved";
        actionBtn.disabled = true; // ရပြီးသားဆိုရင် ခလုတ်ပိတ်မယ်
    } else {
        actionBtn.innerHTML = "➕ Add to Folder";
        actionBtn.disabled = false;
    }
}
    document.querySelectorAll('.star-input').forEach(input => {
        input.addEventListener('change', function() {
            // HTML ထဲက data-post-id ကို ယူပါ
            const postId = this.getAttribute('data-post-id');
            const rating = this.value;
            
            // Rating ပေးခြင်း
            submitRating(postId, rating);
        });
    });
</script>
</body>
</html>