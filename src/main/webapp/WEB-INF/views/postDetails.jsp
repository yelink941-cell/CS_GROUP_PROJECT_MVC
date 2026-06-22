<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${post.title}</title>
    
    <style>
        .liked-btn {
            color: blue;
            font-weight: bold;
            cursor: pointer; 
            border: 1px solid #ccc; 
            padding: 5px 10px;
        }
        .unliked-btn {
            color: black;
            font-weight: normal;
            cursor: pointer; 
            border: 1px solid #ccc; 
            padding: 5px 10px;
        }
        .reply-box-form {
            display: none; 
            margin-top: 8px;
            background-color: #f8f9fa;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            width: fit-content;
            margin-left: 15px;
        }
        ul.nested-comments, ul.nested-comments ul {
            list-style-type: circle;
            margin-left: 20px;
        }
    </style>
</head>
<body>

    <article>
        <h1>${post.title}</h1>
        <p><strong>Category:</strong> ${post.category.name}</p>
        <p><strong>Author:</strong> ${post.author.username}</p>
        <hr>
        <div>
            <p>${post.excerpt}</p>
        </div>
        <hr>
    </article>
	
	<div style="margin-bottom: 20px;">
    <%-- 🌟 likeBtn နှင့် likeText, likeCount တို့ကို id များ အတိအကျပေးပါ 🌟 --%>
    <button id="likeBtn" onclick="toggleLike(${post.id}, event)" class="${isLiked ? 'liked-btn' : 'unliked-btn'}">
        <span id="likeText">${isLiked ? 'Liked' : 'Like'}</span> 👍
    </button>
    
    <span style="margin-left: 10px;">
        <span id="likeCount">${totalLikes}</span> Likes
    </span>
</div>

    <h3>Comments (${totalCommentCount})</h3>
    <hr>
    <hr>
    
    <ul style="margin-left:20px;">
        <%-- အဓိက Root Level Comments များကိုသာ loop ပတ်ထုတ်ခြင်း (parent == null ဖြစ်သော Comment အစစ်များ) --%>
        <c:forEach var="comment" items="${comments}">
            <c:if test="${comment.parent == null && comment.deletedAt == null && not empty comment.content}">
                <li style="margin-bottom: 15px;">
                    <strong>${comment.user.username}:</strong>
                    ${comment.content}
                    <br>
                    <small>${comment.createdAt}</small>
            
                    <br>
                    <button onclick="toggleBox('commentForm-${comment.id}')">Reply</button>

                    <c:if test="${sessionScope.user != null && sessionScope.user.id == comment.user.id}">
                <form action="${pageContext.request.contextPath}/comments/delete" method="post" style="display:inline;">
                    <input type="hidden" name="commentId" value="${comment.id}">
                    <input type="hidden" name="postId" value="${post.id}">
                    <button type="submit" onclick="return confirm('ဒီ Comment ကို တကယ်ဖျက်မှာလား?');">Delete</button>
                </form>
            </c:if>

                    <c:if test="${sessionScope.user != null}">
                <form id="commentForm-${comment.id}"
                      action="${pageContext.request.contextPath}/comments/reply"
                      method="post"
                      class="reply-box-form">

                    <input type="hidden" name="postId" value="${post.id}">
                    <input type="hidden" name="parentId" value="${comment.id}">
                    <textarea name="content" required style="width: 300px; height: 60px;"></textarea>
                    <br>
                    <button type="submit">Submit Reply</button>
                </form>
            </c:if>

                   <%-- သားစဉ်မြေးဆက် Replies များရှိပါက JSTL Include ဖြင့် ဆက်လက်ခေါ်ယူခြင်း --%>
            <c:if test="${not empty comment.replies}">
                <ul class="nested-comments">
                    <c:set var="replyList" value="${comment.replies}" scope="request"/>
                    <jsp:include page="reply-recurse.jsp" />
                </ul>
            </c:if>
                </li>
            </c:if>
        </c:forEach>
    </ul>
    <hr>

    <h3>Leave a comment</h3>
    <form action="${pageContext.request.contextPath}/comments/add" method="POST">
        <input type="hidden" name="postId" value="${post.id}" />
        <textarea name="content" required placeholder="Write your thoughts..." style="width: 100%; height: 100px;"></textarea>
        <br>
        <button type="submit">Post Comment</button>
    </form>

    <br>
    <a href="${pageContext.request.contextPath}/">Back to Home</a>

    <script>
        function toggleBox(formId) {
            var form = document.getElementById(formId);
            if (form) {
                if (form.style.display === 'none' || form.style.display === '') {
                    form.style.display = 'block';
                } else {
                    form.style.display = 'none';
                }
            }
        }
        
        function toggleLike(postId, event) {
            if (event) { event.preventDefault(); }
            
            fetch('${pageContext.request.contextPath}/api/toggle-like', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: new URLSearchParams({ 'postId': postId })
            })
            .then(response => {
                if (response.status === 401) {
                    alert("Like နှိပ်ရန် Login ဝင်ဖို့ လိုအပ်ပါတယ်။");
                    window.location.href = "${pageContext.request.contextPath}/login";
                    return null;
                }
                return response.json(); 
            })
            .then(data => {
                if (data && data.status === 'success') {
                    let likeBtn = document.getElementById('likeBtn');
                    let likeText = document.getElementById('likeText');
                    let likeCount = document.getElementById('likeCount');

                    if (data.isLiked === true || data.isLiked === 'true') {
                        likeBtn.classList.add('liked-btn');
                        likeBtn.classList.remove('unliked-btn');
                        likeText.innerText = 'Liked';
                    } else {
                        likeBtn.classList.add('unliked-btn');
                        likeBtn.classList.remove('liked-btn');
                        likeText.innerText = 'Like';
                    }
                    likeCount.innerText = data.totalLikes; 
                }
            })
            .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>