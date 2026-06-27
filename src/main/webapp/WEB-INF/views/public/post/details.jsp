<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
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

        <div class="rating-section">
            <c:choose>
                <c:when test="${not empty userLoggedIn}">
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5" onclick="submitRating(${post.id}, 5)" ${userRating == 5 ? 'checked' : ''}><label for="star5" title="5 stars">★</label>
                        <input type="radio" id="star4" name="rating" value="4" onclick="submitRating(${post.id}, 4)" ${userRating == 4 ? 'checked' : ''}><label for="star4" title="4 stars">★</label>
                        <input type="radio" id="star3" name="rating" value="3" onclick="submitRating(${post.id}, 3)" ${userRating == 3 ? 'checked' : ''}><label for="star3" title="3 stars">★</label>
                        <input type="radio" id="star2" name="rating" value="2" onclick="submitRating(${post.id}, 2)" ${userRating == 2 ? 'checked' : ''}><label for="star2" title="2 stars">★</label>
                        <input type="radio" id="star1" name="rating" value="1" onclick="submitRating(${post.id}, 1)" ${userRating == 1 ? 'checked' : ''}><label for="star1" title="1 star">★</label>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="star-rating" style="pointer-events: none;">
                        <label style="color: ${averageRating >= 1 ? '#ffc107' : '#ccc'};">★</label>
                        <label style="color: ${averageRating >= 2 ? '#ffc107' : '#ccc'};">★</label>
                        <label style="color: ${averageRating >= 3 ? '#ffc107' : '#ccc'};">★</label>
                        <label style="color: ${averageRating >= 4 ? '#ffc107' : '#ccc'};">★</label>
                        <label style="color: ${averageRating >= 5 ? '#ffc107' : '#ccc'};">★</label>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="average-rating-box">
                <strong>⭐ AverageRating:</strong> <span id="avgRatingValue">${not empty averageRating ? averageRating : 0.0}</span>/5 
                (<span id="totalRatingCount">${totalRatings}</span> ratings)
            </div>
        </div>
        
        <div class="like-section" style="margin-bottom: 25px; display: flex; align-items: center; gap: 20px; flex-wrap: wrap; border-bottom: 1px solid #eee; padding-bottom: 15px;">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <button type="button" onclick="toggleLikePost(${post.id}, this)" class="button ${hasUserLiked ? 'liked-btn' : 'unliked-btn'}" style="display: inline-flex; align-items: center; gap: 8px;">
                        <span id="likeIcon-${post.id}" style="display: inline-flex; align-items: center; gap: 6px;">
                            <c:choose>
                                <c:when test="${hasUserLiked}">👍 Unlike</c:when>
                                <c:otherwise>👍🏻 Like</c:otherwise>
                            </c:choose>
                        </span>
                    </button>
                    <span style="font-size: 16px;"><strong>Likes:</strong> <span id="likeCount-${post.id}">${not empty likeCount ? likeCount : 0}</span></span>
                </c:when>
                <c:otherwise>
                    <button type="button" onclick="alert('Like ပြုလုပ်ရန် Login ဝင်ရန် လိုအပ်ပါသည်။'); window.location.href='${pageContext.request.contextPath}/login';" class="button unliked-btn" style="display: inline-flex; align-items: center; gap: 8px;">
                        
                    </button>
                </c:otherwise>
            </c:choose>
            
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <button type="button" onclick="toggleBookmark(${post.id}, this)" class="button ${hasUserBookmarked ? 'bookmarked-btn' : 'unbookmarked-btn'}" style="display: inline-flex; align-items: center; gap: 8px;">
                        <span id="bookmarkIcon-${post.id}">
                            <c:choose>
                                <c:when test="${hasUserBookmarked}">⭐ Bookmarked</c:when>
                                <c:otherwise>⭐ Bookmark</c:otherwise>
                            </c:choose>
                        </span>
                    </button>
                </c:when>
                <c:otherwise>
                    <button type="button" onclick="alert('Bookmark ပြုလုပ်ရန် Login ဝင်ရန် လိုအပ်ပါသည်။'); window.location.href='${pageContext.request.contextPath}/login';" class="button unbookmarked-btn" style="display: inline-flex; align-items: center; gap: 8px;">
                    </button>
                </c:otherwise>
            </c:choose>

            <button type="button" class="button button-secondary" onclick="toggleCommentsSection()">
                💬 Comments (${not empty totalComments ? totalComments : 0})
            </button>
        </div>

        <div id="commentsToggleWrapper" style="display: none;">
            <h2 id="commentCountHeader" data-count="${totalComments}"> Comments (${totalComments})</h2>
            <c:if test="${not empty userLoggedIn}">
                <form id="commentForm" style="margin-bottom: 30px;">
                    <input type="hidden" id="postId" name="postId" value="${post.id}" />
                    <div class="form-group">
                        <textarea id="commentText" name="commentText" rows="3" required placeholder="Comment တစ်ခုခုရေးပါ..." style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc;"></textarea>
                    </div>
                    <button type="submit" class="button button-primary" style="margin-top: 10px;">Comment ပို့မည်</button>
                </form>
            </c:if>
            
            <c:if test="${empty userLoggedIn}">
                <p style="color: #666;"><a href="${pageContext.request.contextPath}/login"></a></p>
            </c:if>

            <c:if test="${empty comments}">
                <p style="color: #888;"></p>
            </c:if>
            
            <c:if test="${not empty comments}">
                <div id="commentListContainer" class="comment-list" style="display: flex; flex-direction: column; gap: 16px;">
                    <c:forEach var="comment" items="${comments}">
                        <div class="comment-item" id="comment-${comment.id}" style="border-bottom: 1px solid #f0f0f0; padding-bottom: 12px;">
                            <div style="display: flex; justify-content: space-between; font-size: 14px; color: #555; margin-bottom: 6px;">
                                <strong><c:out value="${comment.user.username}" /></strong>
                                <span>${comment.createdAt}</span>
                            </div>
                            <p style="margin: 0 0 6px 0; line-height: 1.5; color: #333;"><c:out value="${comment.content}" /></p>
                            
                            <div style="display: flex; gap: 12px; margin-bottom: 8px;">
                                <button type="button" class="button-link" onclick="toggleReplyForm('c-${comment.id}')">Reply</button>
                                <c:if test="${sessionScope.userId == comment.user.id}">
                                    <button type="button" class="button-link" style="color: #dc3545;" onclick="deleteComment(${comment.id})">Delete</button>
                                </c:if>
                            </div>

                            <%-- Main Comment Reply Form --%>
                            <div id="replyFormContainer-c-${comment.id}" style="display: none; margin-top: 6px; margin-left: 20px;">
                                <form onsubmit="submitReply(event, 'c-${comment.id}', ${comment.id}, ${post.id})">
                                    <textarea id="replyText-c-${comment.id}" rows="2" required placeholder="Reply ပြန်ရန်..." style="width: 100%; padding: 6px; border-radius: 6px; border: 1px solid #ccc;"></textarea>
                                    <br>
                                    <button type="submit" class="button button-secondary" style="font-size: 11px; padding: 3px 8px; margin-top: 4px;">Reply ပို့မည်</button>
                                </form>
                            </div>

                            <div id="replyListContainer-${comment.id}">
                                <c:if test="${not empty comment.replies}">
                                    <ul style="margin-left: 20px; padding-left: 0; list-style-type: none;" id="replySubListContainer-${comment.id}">
                                        <c:set var="replyList" value="${comment.replies}" scope="request"/>
                                        <jsp:include page="reply-recurse.jsp" />
                                    </ul>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
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
        
        if (!selectBox || !actionBtn) return;
        
        var selectedOption = selectBox.options[selectBox.selectedIndex];
        var isSaved = selectedOption.getAttribute("data-saved");

        if (selectBox.value === "") {
            actionBtn.innerHTML = "➕ Add to Folder";
            actionBtn.disabled = false;
        } 
        else if (isSaved === "true") {
            actionBtn.innerHTML = "✓ Saved";
            actionBtn.disabled = true;
        } 
        else {
            actionBtn.innerHTML = "➕ Add to Folder";
            actionBtn.disabled = false;
        }
    }

    document.getElementById('commentForm')?.addEventListener('submit', function(e) {
        e.preventDefault();
        const postId = document.querySelector('#commentForm input[id="postId"]').value;
        const commentText = document.getElementById('commentText').value;

        const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.getAttribute("content");
        const csrfToken = document.querySelector("meta[name='_csrf']")?.getAttribute("content");

        fetch('${pageContext.request.contextPath}/comments/add', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest', // 🟢 Added Header
                [csrfHeader]: csrfToken
            },
            body: 'postId=' + postId + '&commentText=' + encodeURIComponent(commentText)
        })
        .then(response => {
            if (response.status === 401) throw new Error('Unauthorized');
            return response.json();
        })
        .then(data => {
            if (data.status === 'success') {
                sessionStorage.setItem('isCommentsOpen', 'true');
                window.location.href = window.location.pathname + window.location.search + '#commentsToggleWrapper';
                location.reload();
            } else {
                alert('Comment သိမ်းဆည်းရာတွင် အမှားအယွင်းဖြစ်သွားပါသည်။');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Session ပြတ်တောက်သွားပါသည် (သို့) Login ဝင်ရန် လိုအပ်ပါသည်။');
            window.location.href = '${pageContext.request.contextPath}/login';
        });
    });

    function toggleReplyForm(uniqueId) {
        const replyForm = document.getElementById('replyFormContainer-' + uniqueId);
        if (replyForm) {
            const isVisible = (replyForm.style.display === "block");
            const allForms = document.querySelectorAll('[id^="replyFormContainer-"]');
            allForms.forEach(form => form.style.display = "none");
            
            if (!isVisible) {
                replyForm.style.display = "block";
            }
        }
    }

    function submitReply(e, uniqueId, parentId, formPostId) {
        e.preventDefault();
        const replyTextArea = document.getElementById('replyText-' + uniqueId);
        const replyContent = replyTextArea.value;
        const postId = formPostId || document.querySelector('#commentForm input[id="postId"]').value;

        const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.getAttribute("content");
        const csrfToken = document.querySelector("meta[name='_csrf']")?.getAttribute("content");

        fetch('${pageContext.request.contextPath}/comments/reply', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest', // 🟢 Added Header
                [csrfHeader]: csrfToken
            },
            body: 'postId=' + encodeURIComponent(postId) + 
                  '&parentId=' + encodeURIComponent(parentId) + 
                  '&content=' + encodeURIComponent(replyContent)
        })
        .then(response => {
            if (response.ok) {
                sessionStorage.setItem('isCommentsOpen', 'true');
                window.location.href = window.location.pathname + window.location.search + '#commentsToggleWrapper';
                location.reload();
            } else {
                alert('Reply သိမ်းဆည်းရာတွင် အမှားအယွင်းဖြစ်သွားပါသည်။');
            }
        })
        .catch(error => console.error('Error:', error));
    }

    function deleteComment(commentId) {
        if (!confirm('ဤ comment ကို အမှန်တကယ် ဖျက်မှာလား?')) return;
        
        const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.getAttribute("content");
        const csrfToken = document.querySelector("meta[name='_csrf']")?.getAttribute("content");

        fetch('${pageContext.request.contextPath}/comments/delete/' + commentId, {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest', // 🟢 Added Header
                [csrfHeader]: csrfToken
            }
        })
        .then(response => {
            if (response.ok) {
                sessionStorage.setItem('isCommentsOpen', 'true');
                window.location.href = window.location.pathname + window.location.search + '#commentsToggleWrapper';
                location.reload();
            } else {
                alert('ဖျက်ဆီးရာတွင် အမှားအယွင်းဖြစ်သွားပါသည်။');
            }
        })
        .catch(error => console.error('Error:', error));
    }

    document.addEventListener("DOMContentLoaded", function() {
        checkFolderStatus();

        const urlParams = new URLSearchParams(window.location.search);
        const activeTab = urlParams.get('tab');

        if (activeTab) {
            if (activeTab === 'comment') {
                const commentWrapper = document.getElementById('commentsToggleWrapper');
                if (commentWrapper) {
                    commentWrapper.style.display = 'block';
                    commentWrapper.scrollIntoView({ behavior: 'smooth' });
                }
            } else if (activeTab === 'rating') {
                const ratingSection = document.querySelector('.rating-section');
                if (ratingSection) {
                    ratingSection.scrollIntoView({ behavior: 'smooth' });
                }
            } else if (activeTab === 'like') {
                const likeSection = document.querySelector('.like-section');
                if (likeSection) {
                    likeSection.scrollIntoView({ behavior: 'smooth' });
                }
            }
        }

        if (sessionStorage.getItem('isCommentsOpen') === 'true') {
            const commentWrapper = document.getElementById('commentsToggleWrapper');
            if (commentWrapper) {
                commentWrapper.style.display = 'block';
            }
            sessionStorage.removeItem('isCommentsOpen');
        }
    });

    function toggleLikePost(postId, buttonElement) {
        const csrfMeta = document.querySelector("meta[name='_csrf']");
        const csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");
        const csrfToken = csrfMeta ? csrfMeta.getAttribute("content") : "";
        const csrfHeader = csrfHeaderMeta ? csrfHeaderMeta.getAttribute("content") : "";

        fetch('${pageContext.request.contextPath}/api/toggle-like', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest',
                [csrfHeader]: csrfToken
            },
            body: 'postId=' + encodeURIComponent(postId)
        })
        .then(response => {
            if (response.status === 401) throw new Error('Unauthorized');
            return response.json();
        })
        .then(data => {
            if (data.status === 'success') {
                const likeCountSpan = document.getElementById('likeCount-' + postId);
                if (likeCountSpan) {
                    likeCountSpan.innerText = data.totalLikes;
                }
                
                const iconSpan = document.getElementById('likeIcon-' + postId);
                if (iconSpan) {
                    if (data.isLiked) {
                        iconSpan.innerHTML = "👍 Unlike";
                        buttonElement.className = "button liked-btn";
                    } else {
                        iconSpan.innerHTML = "👍🏻 Like";
                        buttonElement.className = "button unliked-btn";
                    }
                }
            } else {
                alert(data.message || "Operation failed.");
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Session ပြတ်တောက်သွားပါသည် (သို့) Login ဝင်ရန် လိုအပ်ပါသည်။');
            window.location.href = '${pageContext.request.contextPath}/login';
        });
    }

    function updateCommentCount(change) {
        const countHeader = document.getElementById('commentCountHeader');
        if (!countHeader) return;
        const currentCount = parseInt(countHeader.getAttribute('data-count') || '0', 10);
        const newCount = Math.max(0, currentCount + change);
        countHeader.setAttribute('data-count', newCount);
        countHeader.textContent = 'Comments (' + newCount + ')';
    }

    function escapeHtml(string) {
        return String(string).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function toggleCommentsSection() {
        const commentWrapper = document.getElementById('commentsToggleWrapper');
        if (commentWrapper) {
            if (commentWrapper.style.display === 'none' || commentWrapper.style.display === '') {
                commentWrapper.style.display = 'block';
            } else {
                commentWrapper.style.display = 'none';
            }
        }
    }

    function submitRating(postId, ratingValue) {
        const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.getAttribute("content");
        const csrfToken = document.querySelector("meta[name='_csrf']")?.getAttribute("content");

        fetch('${pageContext.request.contextPath}/api/toggle-rating', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest', // 🟢 Added Header
                [csrfHeader]: csrfToken
            },
            body: 'postId=' + postId + '&rating=' + ratingValue
        })
        .then(response => {
            if (response.status === 401) throw new Error('Unauthorized');
            return response.json();
        })
        .then(data => {
            if (data.status === 'success') {
                const avgRatingSpan = document.getElementById('avgRatingValue');
                if (avgRatingSpan) avgRatingSpan.innerText = data.averageRating;
                
                const totalRatingSpan = document.getElementById('totalRatingCount');
                if (totalRatingSpan) totalRatingSpan.innerText = data.totalRatings;
                
                alert('Rating ပေးခြင်း အောင်မြင်ပါသည်။');
            } else {
                alert(data.message || 'Rating သိမ်းဆည်းရာတွင် အမှားအယွင်းဖြစ်သွားပါသည်။');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Session ပြတ်တောက်သွားပါသည် (သို့) Login ဝင်ရန် လိုအပ်ပါသည်။');
            window.location.href = '${pageContext.request.contextPath}/login';
        });
    }

    function toggleBookmark(postId, buttonElement) {
        const csrfHeader = document.querySelector("meta[name='_csrf_header']")?.getAttribute("content");
        const csrfToken = document.querySelector("meta[name='_csrf']")?.getAttribute("content");

        fetch('${pageContext.request.contextPath}/api/toggle-bookmark', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest', // 🟢 Added Header
                [csrfHeader]: csrfToken
            },
            body: 'postId=' + postId
        })
        .then(response => {
            if (response.status === 401) throw new Error('Unauthorized');
            return response.json();
        })
        .then(data => {
            if (data.status === 'success') {
                const iconSpan = document.getElementById('bookmarkIcon-' + postId);
                if (iconSpan) {
                    if (data.isBookmarked) {
                        iconSpan.innerHTML = "⭐ Bookmarked";
                        buttonElement.className = "button bookmarked-btn";
                    } else {
                        iconSpan.innerHTML = "⭐ Bookmark";
                        buttonElement.className = "button unbookmarked-btn";
                    }
                }
                const bookmarkCountSpan = document.getElementById('bookmarkCount-' + postId);
                if (bookmarkCountSpan) {
                    bookmarkCountSpan.innerText = data.totalBookmarks;
                }
            } else {
                alert(data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Session ပြတ်တောက်သွားပါသည် (သို့) Login ဝင်ရန် လိုအပ်ပါသည်။');
            window.location.href = '${pageContext.request.contextPath}/login';
        });
    }
</script>
</body>
</html>