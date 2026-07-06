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
        .public-content-grid {
            display: grid !important;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)) !important;
            gap: 24px !important;
            margin-top: 30px !important;
        }

        .public-content-card {
            background: #f3f1ff !important;
            border-radius: 12px !important;
            overflow: hidden !important;
            box-shadow: 0 12px 26px rgba(37, 28, 180, .12) !important;
        }

        .public-content-card-header {
            background: #4038ff !important;
            color: white !important;
            padding: 14px 18px !important;
        }

        .public-content-card-header h2 {
            color: white !important;
            margin: 0 !important;
            font-size: 20px !important;
        }

        .public-content-card-header span {
            display: inline-block;
            margin-top: 6px;
            font-size: 12px;
            opacity: .85;
            font-weight: 700;
        }

        .public-content-card-body {
            background: #f7f6ff !important;
            padding: 18px !important;
            line-height: 1.7 !important;
        }

        .public-code-content {
            background: #111827 !important;
            color: #e5e7eb !important;
            padding: 16px !important;
            border-radius: 10px !important;
            white-space: pre-wrap !important;
            overflow-x: auto !important;
        }

        .public-section-image {
            max-width: 100%;
            border-radius: 10px;
            display: block;
        }

        .public-back-actions {
            margin-top: 35px !important;
        }

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

        .btn-add-collection:disabled {
            background-color: #94a3b8 !important;
            color: #f1f5f9 !important;
            cursor: not-allowed;
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

        .rating-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-top: 20px;
            margin-bottom: 20px;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            flex-wrap: wrap;
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
            color: #ffc107;
        }

        .average-rating-box {
            font-size: 15px;
            background: #fff3cd;
            padding: 6px 12px;
            border-radius: 6px;
            border: 1px solid #ffeeba;
        }

        #reportModal {
            display: none;
            position: fixed;
            z-index: 9999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, .55);
            align-items: center;
            justify-content: center;
        }

        .report-modal-box {
            background: #ffffff;
            padding: 24px;
            border-radius: 14px;
            max-width: 460px;
            width: 92%;
            box-shadow: 0 20px 60px rgba(15, 23, 42, .25);
        }

        .report-modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 12px;
        }

        .report-modal-header h3 {
            margin: 0;
            color: #0f172a;
            font-size: 18px;
        }

        .report-close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #64748b;
        }

        .report-field {
            margin-bottom: 14px;
        }

        .report-field label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            color: #475569;
            margin-bottom: 6px;
        }

        .report-field select,
        .report-field textarea {
            width: 100%;
            padding: 9px 12px;
            border-radius: 8px;
            border: 1px solid #cbd5e1;
            font-size: 14px;
            box-sizing: border-box;
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
                <c:when test="${not empty post.excerpt}">
                    <c:out value="${post.excerpt}" />
                </c:when>
                <c:otherwise>No excerpt provided.</c:otherwise>
            </c:choose>
        </div>

        <c:if test="${not empty sessionScope.userId}">
            <div class="collection-box">
                <form action="${pageContext.request.contextPath}/user/collections/add-post" method="post" class="collection-form">
                    <input type="hidden" name="postId" value="${post.id}">
                    <input type="hidden" name="slug" value="${post.slug}">

                    <label for="collectionSelect" class="collection-label">📁 Save to Folder:</label>

                    <select id="collectionSelect" name="collectionId" required class="collection-select" onchange="checkFolderStatus()">
                        <option value="">-- Select Your Collection --</option>
                        <c:forEach var="col" items="${collections}">
                            <option value="${col.id}" data-saved="${col.posts.contains(post) ? 'true' : 'false'}">
                                <c:out value="${col.name}" />
                            </option>
                        </c:forEach>
                    </select>

                    <button id="addFolderBtn" type="submit" class="btn-add-collection">➕ Add to Folder</button>
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
                    <div class="star-rating" onclick="alert('Please login to rate this post.'); window.location.href='${pageContext.request.contextPath}/login';" style="cursor: pointer;" title="Click to rate">
                        <label style="color: ${averageRating >= 1 ? '#ffc107' : '#ccc'};">★</label>
                        <label style="color: ${averageRating >= 2 ? '#ffc107' : '#ccc'};">★</label>
                        <label style="color: ${averageRating >= 3 ? '#ffc107' : '#ccc'};">★</label>
                        <label style="color: ${averageRating >= 4 ? '#ffc107' : '#ccc'};">★</label>
                        <label style="color: ${averageRating >= 5 ? '#ffc107' : '#ccc'};">★</label>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="average-rating-box">
                <strong>⭐ Average Rating:</strong>
                <span id="avgRatingValue">${not empty averageRating ? averageRating : 0.0}</span>/5
                (<span id="totalRatingCount">${not empty totalRatings ? totalRatings : 0}</span> ratings)
            </div>
        </div>

        <div class="like-section" style="margin-bottom: 25px; display: flex; align-items: center; gap: 20px; flex-wrap: wrap; border-bottom: 1px solid #eee; padding-bottom: 15px;">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <button type="button" onclick="toggleLikePost(${post.id}, this)" class="button ${hasUserLiked ? 'liked-btn' : 'unliked-btn'}" style="display: inline-flex; align-items: center; gap: 8px;">
                        <span id="likeIcon-${post.id}">
                            <c:choose>
                                <c:when test="${hasUserLiked}">👍 Unlike</c:when>
                                <c:otherwise>👍🏻 Like</c:otherwise>
                            </c:choose>
                        </span>
                    </button>
                    <span style="font-size: 16px;"><strong>Likes:</strong> <span id="likeCount-${post.id}">${not empty likeCount ? likeCount : 0}</span></span>
                </c:when>
                <c:otherwise>
                    <button type="button" onclick="alert('Please login to like this post.'); window.location.href='${pageContext.request.contextPath}/login';" class="button unliked-btn">
                        👍🏻 Like
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
                    <button type="button" onclick="alert('Please login to bookmark this post.'); window.location.href='${pageContext.request.contextPath}/login';" class="button unbookmarked-btn">
                        ⭐ Bookmark
                    </button>
                </c:otherwise>
            </c:choose>

            <button type="button" id="commentCountBtn" class="button button-secondary" onclick="toggleCommentsSection()">
                💬 Comments (${not empty totalComments ? totalComments : 0})
            </button>

            <c:if test="${sessionScope.userId != post.author.id}">
                <button type="button" onclick="openReportModal('post', ${post.id})" class="button button-secondary" style="display: inline-flex; align-items: center; gap: 8px; color: #dc2626; border-color: #fca5a5;">
                    🚩 Report Post
                </button>
            </c:if>
        </div>

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
                                    <c:when test="${not empty content.subtitle}">
                                        <c:out value="${content.subtitle}" />
                                    </c:when>
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
                                    <c:choose>
                                        <c:when test="${fn:startsWith(content.contentData, '/')}">
                                            <img class="public-section-image" src="${pageContext.request.contextPath}${fn:escapeXml(content.contentData)}" alt="${fn:escapeXml(content.subtitle)}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="public-section-image" src="${fn:escapeXml(content.contentData)}" alt="${fn:escapeXml(content.subtitle)}">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${content.contentType == 'VIDEO'}">
                                    <video class="public-section-video" controls src="${fn:escapeXml(content.contentData)}"></video>
                                </c:when>
                                <c:when test="${content.contentType == 'LINK'}">
                                    <a class="public-section-link" href="${fn:escapeXml(content.contentData)}" target="_blank" rel="noopener noreferrer">
                                        <c:out value="${content.contentData}" />
                                    </a>
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

        <div id="commentsToggleWrapper" style="display: none; margin-top: 32px;">
            <h2 id="commentCountHeader" data-count="${not empty totalComments ? totalComments : 0}">
                Comments (${not empty totalComments ? totalComments : 0})
            </h2>

            <c:if test="${not empty userLoggedIn}">
                <form id="commentForm" style="margin-bottom: 30px;">
                    <input type="hidden" id="postId" name="postId" value="${post.id}">
                    <div class="form-group">
                        <textarea id="commentText" name="commentText" rows="3" required placeholder="Write a comment..." style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc;"></textarea>
                    </div>
                    <button type="submit" class="button button-primary" style="margin-top: 10px;">Post Comment</button>
                </form>
            </c:if>

            <c:if test="${empty userLoggedIn}">
                <p style="color: #666;">Please <a href="${pageContext.request.contextPath}/login">Login</a> to write a comment.</p>
            </c:if>

            <c:if test="${empty comments}">
                <p style="color: #888;" id="noCommentsMessage">No comments yet.</p>
            </c:if>

            <c:if test="${not empty comments}">
                <div id="commentListContainer" class="comment-list" style="display: flex; flex-direction: column; gap: 16px;">
                    <c:forEach var="comment" items="${comments}">
                        <div class="comment-item" id="comment-${comment.id}" style="border-bottom: 1px solid #f0f0f0; padding-bottom: 12px;">
                            <div style="display: flex; justify-content: space-between; font-size: 14px; color: #555; margin-bottom: 6px;">
                                <strong><c:out value="${comment.user.username}" /></strong>
                                <span><c:out value="${comment.createdAt}" /></span>
                            </div>

                            <p style="margin: 0 0 6px 0; line-height: 1.5; color: #333;">
                                <c:out value="${comment.content}" />
                            </p>

                            <div style="display: flex; gap: 12px; margin-bottom: 8px;">
                                <button type="button" class="button-link" onclick="toggleReplyForm('c-${comment.id}')">Reply</button>

                                <c:if test="${sessionScope.userId == comment.user.id}">
                                    <button type="button" class="button-link" style="color: #dc3545;" onclick="deleteComment(${comment.id})">Delete</button>
                                </c:if>

                                <button type="button" class="button-link" style="color: #dc2626;" onclick="openReportModal('comment', ${comment.id})">Report</button>
                            </div>

                            <div id="replyFormContainer-c-${comment.id}" style="display: none; margin-top: 6px; margin-left: 20px;">
                                <form onsubmit="submitReply(event, 'c-${comment.id}', ${comment.id}, ${post.id})">
                                    <textarea id="replyText-c-${comment.id}" rows="2" required placeholder="Write a reply..." style="width: 100%; padding: 6px; border-radius: 6px; border: 1px solid #ccc;"></textarea>
                                    <br>
                                    <button type="submit" class="button button-secondary" style="font-size: 11px; padding: 3px 8px; margin-top: 4px;">Post Reply</button>
                                </form>
                            </div>

                            <div id="replyListContainer-${comment.id}">
                                <ul style="margin-left: 20px; padding-left: 0; list-style-type: none;" id="replySubListContainer-${comment.id}">
                                    <c:if test="${not empty comment.replies}">
                                        <c:set var="replyList" value="${comment.replies}" scope="request"/>
                                        <jsp:include page="reply-recurse.jsp" />
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </article>

    <div class="public-back-actions">
        <a class="button button-secondary" href="${pageContext.request.contextPath}/posts/public">Back to Posts</a>
    </div>
</main>

<div id="reportModal" onclick="closeReportModal()">
    <div class="report-modal-box" onclick="event.stopPropagation()">
        <div class="report-modal-header">
            <h3 id="reportModalTitle">Report Content</h3>
            <button type="button" class="report-close-btn" onclick="closeReportModal()">&times;</button>
        </div>

        <form id="reportForm" onsubmit="handleReportSubmit(event)">
            <input type="hidden" id="reportTargetType" value="comment">
            <input type="hidden" id="reportTargetId" value="">

            <div class="report-field">
                <label for="reportReason">Reason</label>
                <select id="reportReason" required>
                    <option value="TEXT">Inappropriate Text</option>
                    <option value="LINK">Spam / Dangerous Link</option>
                    <option value="OTHER">Other</option>
                </select>
            </div>

            <div class="report-field">
                <label for="reportDescription">Description (Optional)</label>
                <textarea id="reportDescription" rows="3" placeholder="Provide additional details..."></textarea>
            </div>

            <div class="report-modal-actions">
                <button type="button" onclick="closeReportModal()" class="button button-secondary">Cancel</button>
                <button type="submit" class="button" style="background-color: #dc2626; color: #ffffff; border: none;">Submit Report</button>
            </div>
        </form>
    </div>
</div>

<script>
function getCsrfHeaders(contentType = 'application/json') {
    const csrfHeaderMeta = document.querySelector("meta[name='_csrf_header']");
    const csrfMeta = document.querySelector("meta[name='_csrf']");

    const headers = {
        'Content-Type': contentType,
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
    };

    if (csrfHeaderMeta && csrfMeta) {
        const headerName = csrfHeaderMeta.getAttribute("content");
        const tokenValue = csrfMeta.getAttribute("content");

        if (headerName && tokenValue && !headerName.startsWith('$')) {
            headers[headerName] = tokenValue;
        }
    }

    return headers;
}

function getCleanUrl(path) {
    let ctx = '${pageContext.request.contextPath}';

    if (ctx === '/') {
        ctx = '';
    }

    return ctx + path;
}

function updateUrlHash(hash) {
    try {
        history.replaceState(null, '', '#' + hash);
    } catch (e) {
        // ignore
    }
}

function showCommentsSection() {
    const el = document.getElementById('commentsToggleWrapper');

    if (el) {
        el.style.display = 'block';
    }
}

function escapeHtml(str) {
    if (str === null || str === undefined) {
        return '';
    }

    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

function updateCommentCount(newCount) {
    const header = document.getElementById('commentCountHeader');

    if (header) {
        header.setAttribute('data-count', newCount);
        header.innerText = 'Comments (' + newCount + ')';
    }

    const btn = document.getElementById('commentCountBtn');

    if (btn) {
        btn.innerText = '💬 Comments (' + newCount + ')';
    }
}

function checkFolderStatus() {
    const selectBox = document.getElementById('collectionSelect');
    const actionBtn = document.getElementById('addFolderBtn');

    if (!selectBox || !actionBtn) {
        return;
    }

    const selectedOption = selectBox.options[selectBox.selectedIndex];
    const isSaved = selectedOption.getAttribute('data-saved');

    if (selectBox.value === '') {
        actionBtn.innerHTML = '➕ Add to Folder';
        actionBtn.disabled = false;
    } else if (isSaved === 'true') {
        actionBtn.innerHTML = '✓ Saved';
        actionBtn.disabled = true;
    } else {
        actionBtn.innerHTML = '➕ Add to Folder';
        actionBtn.disabled = false;
    }
}

let commentFormListenerAttached = false;

function attachCommentFormListener() {
    if (commentFormListenerAttached) {
        return;
    }

    const commentForm = document.getElementById('commentForm');

    if (!commentForm) {
        return;
    }

    commentFormListenerAttached = true;

    commentForm.addEventListener('submit', function (e) {
        e.preventDefault();

        const postId = document.querySelector('#postId').value;
        const commentInput = document.getElementById('commentText');
        const commentText = commentInput.value;

        fetch(getCleanUrl('/comments/add'), {
            method: 'POST',
            headers: getCsrfHeaders('application/x-www-form-urlencoded'),
            body: 'postId=' + encodeURIComponent(postId) + '&commentText=' + encodeURIComponent(commentText)
        })
        .then(r => r.text().then(text => {
            let data;

            try {
                data = JSON.parse(text);
            } catch (e) {
                data = { status: 'error', message: text };
            }

            return { ok: r.ok, status: r.status, data: data };
        }))
        .then(res => {
            if (!res.ok) {
                if (res.status === 401) {
                    window.location.href = getCleanUrl('/login');
                    return;
                }

                alert(res.data.message || 'Comment error (' + res.status + ')');
                return;
            }

            const data = res.data;

            if (data.status !== 'success') {
                alert('Comment error: ' + (data.message || ''));
                return;
            }

            commentInput.value = '';

            let container = document.getElementById('commentListContainer');

            if (!container) {
                container = document.createElement('div');
                container.id = 'commentListContainer';
                container.className = 'comment-list';
                container.style.cssText = 'display: flex; flex-direction: column; gap: 16px;';
                document.getElementById('commentsToggleWrapper').appendChild(container);
            }

            const noCommentsMsg = document.getElementById('noCommentsMessage');

            if (noCommentsMsg) {
                noCommentsMsg.remove();
            }

            const safeUser = escapeHtml(data.username);
            const safeContent = escapeHtml(data.content);
            const safeDate = escapeHtml(data.createdAt);

            const newComment = document.createElement('div');
            newComment.className = 'comment-item';
            newComment.id = 'comment-' + data.commentId;
            newComment.style.cssText = 'border-bottom: 1px solid #f0f0f0; padding-bottom: 12px;';

            newComment.innerHTML =
                '<div style="display: flex; justify-content: space-between; font-size: 14px; color: #555; margin-bottom: 6px;">' +
                    '<strong>' + safeUser + '</strong>' +
                    '<span>' + safeDate + '</span>' +
                '</div>' +
                '<p style="margin: 0 0 6px 0; line-height: 1.5; color: #333;">' + safeContent + '</p>' +
                '<div style="display: flex; gap: 12px; margin-bottom: 8px;">' +
                    '<button type="button" class="button-link" onclick="toggleReplyForm(\\'c-' + data.commentId + '\\')">Reply</button>' +
                    '<button type="button" class="button-link" style="color: #dc3545;" onclick="deleteComment(' + data.commentId + ')">Delete</button>' +
                    '<button type="button" class="button-link" style="color: #dc2626;" onclick="openReportModal(\\'comment\\', ' + data.commentId + ')">Report</button>' +
                '</div>' +
                '<div id="replyFormContainer-c-' + data.commentId + '" style="display: none; margin-top: 6px; margin-left: 20px;">' +
                    '<form onsubmit="submitReply(event, \\'c-' + data.commentId + '\\', ' + data.commentId + ', ' + postId + ')">' +
                        '<textarea id="replyText-c-' + data.commentId + '" rows="2" required placeholder="Write a reply..." style="width: 100%; padding: 6px; border-radius: 6px; border: 1px solid #ccc;"></textarea>' +
                        '<br>' +
                        '<button type="submit" class="button button-secondary" style="font-size: 11px; padding: 3px 8px; margin-top: 4px;">Post Reply</button>' +
                    '</form>' +
                '</div>' +
                '<div id="replyListContainer-' + data.commentId + '"></div>';

            container.appendChild(newComment);

            const header = document.getElementById('commentCountHeader');

            if (header) {
                const newCount = parseInt(header.getAttribute('data-count') || '0', 10) + 1;
                updateCommentCount(newCount);
            }

            showCommentsSection();
            updateUrlHash('comment');
        })
        .catch(err => {
            console.error('Comment request failed:', err);
            alert('Comment error: ' + (err.message || 'Failed to post comment. Please try again.'));
        });
    });
}

function toggleReplyForm(commentId) {
    const replyForm = document.getElementById('replyFormContainer-' + commentId);

    if (!replyForm) {
        return;
    }

    const isVisible = replyForm.style.display === 'block';

    document.querySelectorAll('[id^="replyFormContainer-"]').forEach(function (form) {
        form.style.display = 'none';
    });

    replyForm.style.display = isVisible ? 'none' : 'block';
}

function submitReply(e, commentId, parentId, postId) {
    e.preventDefault();

    const replyInput = document.getElementById('replyText-' + commentId);

    if (!replyInput) {
        console.error('Reply textarea element not found for ID: replyText-' + commentId);
        return;
    }

    const replyText = replyInput.value.trim();

    if (!replyText) {
        alert('Reply content cannot be empty.');
        return;
    }

    fetch(getCleanUrl('/comments/reply'), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'postId=' + encodeURIComponent(postId) +
              '&parentId=' + encodeURIComponent(parentId) +
              '&content=' + encodeURIComponent(replyText)
    })
    .then(r => r.text().then(text => {
        let data;

        try {
            data = JSON.parse(text);
        } catch (e) {
            data = { status: 'error', message: text };
        }

        return { ok: r.ok, status: r.status, data: data };
    }))
    .then(res => {
        if (!res.ok) {
            if (res.status === 401) {
                window.location.href = getCleanUrl('/login');
                return;
            }

            alert(res.data.message || 'Reply error (' + res.status + ')');
            return;
        }

        const data = res.data;

        if (data.status !== 'success') {
            alert('Reply error: ' + (data.message || ''));
            return;
        }

        replyInput.value = '';

        const realParentId = data.parentId || parentId;
        let subList = document.getElementById('replySubListContainer-' + realParentId);

        if (!subList) {
            subList = document.createElement('ul');
            subList.id = 'replySubListContainer-' + realParentId;
            subList.style.cssText = 'margin-left: 20px; padding-left: 0; list-style-type: none;';

            const wrap = document.getElementById('replyListContainer-' + realParentId);

            if (wrap) {
                wrap.appendChild(subList);
            }
        }

        if (!subList) {
            return;
        }

        const safeUser = escapeHtml(data.username);
        const safeContent = escapeHtml(data.content);
        const safeDate = escapeHtml(data.createdAt);

        const replyEl = document.createElement('li');
        replyEl.id = 'reply-item-' + data.replyId;
        replyEl.style.cssText = 'list-style: none; margin-bottom: 12px;';
        replyEl.innerHTML =
            '<div style="display: flex; justify-content: space-between; align-items: center; font-size: 14px; margin-bottom: 6px;">' +
                '<strong>' + safeUser + '</strong>' +
                '<span>' + safeDate + '</span>' +
            '</div>' +
            '<p style="margin: 0 0 6px 0; line-height: 1.5; color: #333;">' + safeContent + '</p>' +
            '<div class="comment-actions" style="display: flex; gap: 12px; margin-bottom: 8px;">' +
                '<button type="button" class="button-link" onclick="toggleReplyForm(\\'r-' + data.replyId + '\\')">Reply</button>' +
                '<button type="button" class="button-link" style="color: #dc3545;" onclick="deleteComment(' + data.replyId + ')">Delete</button>' +
                '<button type="button" class="button-link" style="color: #dc2626;" onclick="openReportModal(\\'comment\\', ' + data.replyId + ')">Report</button>' +
            '</div>' +
            '<div id="replyFormContainer-r-' + data.replyId + '" style="display: none; margin-top: 8px; margin-left: 20px;">' +
                '<form onsubmit="submitReply(event, \\'r-' + data.replyId + '\\', ' + data.replyId + ', ' + postId + ')">' +
                    '<textarea id="replyText-r-' + data.replyId + '" rows="2" required placeholder="Write a reply..." style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #ccc;"></textarea>' +
                    '<button type="submit" class="button button-secondary" style="font-size: 12px; padding: 4px 10px; margin-top: 4px;">Submit Reply</button>' +
                '</form>' +
            '</div>' +
            '<ul id="replySubListContainer-' + data.replyId + '" style="margin-left: 20px; padding-left: 0; list-style: none;"></ul>';

        subList.appendChild(replyEl);

        const replyForm = document.getElementById('replyFormContainer-' + commentId);

        if (replyForm) {
            replyForm.style.display = 'none';
        }

        const header = document.getElementById('commentCountHeader');

        if (header) {
            const newCount = parseInt(header.getAttribute('data-count') || '0', 10) + 1;
            updateCommentCount(newCount);
        }

        showCommentsSection();
        updateUrlHash('reply');
    })
    .catch(err => {
        console.error('Reply request failed:', err);
        alert('Reply error: ' + (err.message || 'Failed to submit reply'));
    });
}

function deleteComment(commentId) {
    if (!confirm('Delete?')) {
        return;
    }

    fetch(getCleanUrl('/comments/delete/') + encodeURIComponent(commentId), {
        method: 'POST',
        headers: getCsrfHeaders()
    })
    .then(r => {
        if (!r.ok) {
            throw new Error('HTTP ' + r.status);
        }

        return r.json();
    })
    .then(data => {
        if (data.status !== 'success') {
            alert('Delete failed: ' + (data.message || ''));
            return;
        }

        let deletedCount = 0;
        const mainEl = document.getElementById('comment-' + commentId);
        const replyEl = document.getElementById('reply-item-' + commentId);

        if (mainEl) {
            deletedCount = 1 + mainEl.querySelectorAll('[id^="reply-item-"]').length;
            mainEl.remove();
        } else if (replyEl) {
            deletedCount = 1 + replyEl.querySelectorAll('[id^="reply-item-"]').length;
            replyEl.remove();
        }

        const container = document.getElementById('commentListContainer');

        if (container && container.children.length === 0) {
            container.remove();

            let msg = document.getElementById('noCommentsMessage');

            if (!msg) {
                msg = document.createElement('p');
                msg.style.color = '#888';
                msg.id = 'noCommentsMessage';
                msg.innerText = 'No comments yet.';
                document.getElementById('commentsToggleWrapper').appendChild(msg);
            }
        }

        const header = document.getElementById('commentCountHeader');

        if (header) {
            let newCount = parseInt(header.getAttribute('data-count') || '0', 10) - deletedCount;

            if (newCount < 0) {
                newCount = 0;
            }

            updateCommentCount(newCount);
        }
    })
    .catch(err => {
        console.error('Delete request failed:', err);

        if (err.message && err.message.includes('401')) {
            window.location.href = getCleanUrl('/login');
        } else {
            alert('Delete failed');
        }
    });
}

function toggleLikePost(postId, btn) {
    fetch(getCleanUrl('/api/toggle-like'), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'postId=' + encodeURIComponent(postId)
    })
    .then(r => {
        if (!r.ok) {
            throw new Error('HTTP ' + r.status);
        }

        return r.json();
    })
    .then(data => {
        if (data.status !== 'success') {
            alert('Like မအောင်မြင်ပါ: ' + (data.message || 'Unknown error'));
            return;
        }

        const countEl = document.getElementById('likeCount-' + postId);

        if (countEl) {
            countEl.innerText = data.totalLikes;
        }

        const icon = document.getElementById('likeIcon-' + postId);

        if (data.isLiked) {
            icon.innerHTML = '👍 Unlike';
            btn.className = 'button liked-btn';
        } else {
            icon.innerHTML = '👍🏻 Like';
            btn.className = 'button unliked-btn';
        }

        updateUrlHash('like');
    })
    .catch(err => {
        console.error('Like request failed:', err);

        if (err.message && err.message.includes('401')) {
            window.location.href = getCleanUrl('/login');
        } else {
            alert('Like ပြုလုပ်၍မရပါ။ Error: ' + err.message);
        }
    });
}

function submitRating(postId, rating) {
    fetch(getCleanUrl('/api/toggle-rating'), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'postId=' + encodeURIComponent(postId) + '&rating=' + encodeURIComponent(rating)
    })
    .then(r => {
        if (!r.ok) {
            throw new Error('HTTP ' + r.status);
        }

        return r.json();
    })
    .then(data => {
        if (data.status !== 'success') {
            alert('Rating error: ' + (data.message || ''));
            return;
        }

        document.getElementById('avgRatingValue').innerText = data.averageRating;
        document.getElementById('totalRatingCount').innerText = data.totalRatings;

        const starInputs = document.querySelectorAll('.star-rating input[name="rating"]');

        starInputs.forEach(function (input) {
            if (!data.hasRated) {
                input.checked = false;
            } else if (parseInt(input.value, 10) === rating) {
                input.checked = true;
            }
        });

        updateUrlHash('rating');
    })
    .catch(err => {
        console.error('Rating request failed:', err);

        if (err.message && err.message.includes('401')) {
            window.location.href = getCleanUrl('/login');
        } else {
            alert('Rating ပြုလုပ်၍မရပါ။ ပြန်လည်စမ်းကြည့်ပါ။');
        }
    });
}

function toggleBookmark(postId, btn) {
    const isLoggedIn = '${sessionScope.userId != null}' === 'true';

    if (!isLoggedIn) {
        window.location.href = getCleanUrl('/login');
        return;
    }

    fetch(getCleanUrl('/api/toggle-bookmark'), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'postId=' + encodeURIComponent(postId)
    })
    .then(r => {
        if (!r.ok) {
            throw new Error('HTTP ' + r.status);
        }

        return r.json();
    })
    .then(data => {
        if (data.status !== 'success') {
            alert('Bookmark error: ' + (data.message || ''));
            return;
        }

        const icon = document.getElementById('bookmarkIcon-' + postId);

        if (data.isBookmarked) {
            icon.innerHTML = '⭐ Bookmarked';
            btn.className = 'button bookmarked-btn';
        } else {
            icon.innerHTML = '⭐ Bookmark';
            btn.className = 'button unbookmarked-btn';
        }

        updateUrlHash('bookmark');
    })
    .catch(err => {
        console.error('Bookmark request failed:', err);

        if (err.message && err.message.includes('401')) {
            window.location.href = getCleanUrl('/login');
        } else {
            alert('Bookmark ပြုလုပ်၍မရပါ။ ပြန်လည်စမ်းကြည့်ပါ။');
        }
    });
}

function toggleCommentsSection() {
    const el = document.getElementById('commentsToggleWrapper');

    if (!el) {
        return;
    }

    const willShow = el.style.display !== 'block';
    el.style.display = willShow ? 'block' : 'none';

    if (willShow) {
        updateUrlHash('comment');
        attachCommentFormListener();
    }
}

if (window.location.hash === '#comment' || window.location.hash === '#reply') {
    showCommentsSection();
    attachCommentFormListener();
}

function openReportModal(targetType, targetId) {
    const isLoggedIn = '${sessionScope.userId != null}' === 'true';

    if (!isLoggedIn) {
        alert('Report ပြုလုပ်ရန် Login ဝင်ရန် လိုအပ်ပါသည်။');
        window.location.href = getCleanUrl('/login');
        return;
    }

    document.getElementById('reportTargetType').value = targetType;
    document.getElementById('reportTargetId').value = targetId;
    document.getElementById('reportModalTitle').innerText = targetType === 'post' ? 'Report Post' : 'Report Comment';
    document.getElementById('reportReason').value = 'TEXT';
    document.getElementById('reportDescription').value = '';

    document.getElementById('reportModal').style.display = 'flex';
}

function closeReportModal() {
    const modal = document.getElementById('reportModal');

    if (modal) {
        modal.style.display = 'none';
    }
}

function handleReportSubmit(e) {
    e.preventDefault();

    const type = document.getElementById('reportTargetType').value;
    const id = document.getElementById('reportTargetId').value;
    const reason = document.getElementById('reportReason').value;
    const description = document.getElementById('reportDescription').value;

    const path = type === 'post'
        ? '/posts/report/' + encodeURIComponent(id)
        : '/comments/reports/report/' + encodeURIComponent(id);

    fetch(getCleanUrl(path), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'reason=' + encodeURIComponent(reason) + '&description=' + encodeURIComponent(description)
    })
    .then(r => r.text().then(text => ({ ok: r.ok, status: r.status, text: text })))
    .then(res => {
        if (res.ok) {
            alert(res.text || 'Report submitted successfully.');
            closeReportModal();
        } else {
            alert('Report error: ' + (res.text || ('HTTP ' + res.status)));
        }
    })
    .catch(err => {
        console.error('Report submission failed:', err);
        alert('Report submission failed. Please try again.');
    });
}
</script>
</body>
</html>
