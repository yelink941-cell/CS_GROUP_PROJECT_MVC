<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:forEach var="reply" items="${replyList}">
    <%-- 🌟 Null နှင့် DeletedAt ကို အဓိက အာရုံစိုက် စစ်ထုတ်ခြင်း 🌟 --%>
    <c:if test="${reply.deletedAt == null && not empty reply.content}">
        <li style="margin-bottom: 8px;">
            <strong>${reply.user.username}:</strong>
            ${reply.content}
            <br>
            <small>${reply.createdAt}</small>
            <br>

            <button onclick="toggleBox('replyForm-${reply.id}')">Reply</button>

            <c:if test="${sessionScope.user != null && sessionScope.user.id == reply.user.id}">
                <form action="${pageContext.request.contextPath}/comments/delete" method="post" style="display:inline;">
                    <input type="hidden" name="commentId" value="${reply.id}">
                    <input type="hidden" name="postId" value="${post.id}">
                    <button type="submit" onclick="return confirm('ဒီ Reply ကို တကယ်ဖျက်မှာလား?');">Delete</button>
                </form>
            </c:if>

            <c:if test="${sessionScope.user != null}">
                <form id="replyForm-${reply.id}"
                      action="${pageContext.request.contextPath}/comments/reply"
                      method="post" 
                      class="reply-box-form"> 
                    <input type="hidden" name="postId" value="${post.id}">
                    <input type="hidden" name="parentId" value="${reply.id}">
                    <textarea name="content" required style="width: 300px; height: 60px;"></textarea>
                    <br>
                    <button type="submit">Submit Reply</button>
                </form>
            </c:if>
            
            <%-- သားစဉ်မြေးဆက် Replies များအတွက် ထပ်ဆင့် ဝင်ရောက်စစ်ဆေးခြင်း --%>
            <c:if test="${not empty reply.replies}">
                <ul style="margin-left:20px; list-style-type: disc;">
                    <c:set var="replyList" value="${reply.replies}" scope="request"/>
                    <jsp:include page="reply-recurse.jsp" />
                </ul>
            </c:if>
        </li>  
    </c:if>
</c:forEach>