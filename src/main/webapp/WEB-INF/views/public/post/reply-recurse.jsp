<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:forEach var="reply" items="${replyList}">
    <c:if test="${reply.deletedAt == null && not empty reply.content}">
        <%-- 🟢 သတိပြုရန် - အကယ်၍ မိဘ (Parent) ကွန်မန့်ကိုယ်တိုင်က ဖျက်ဆီးခံထားရ (deleted) ဖြစ်ပါက ဤ reply ကိုပါ အလိုအလျောက် ပုန်းသွားစေရန် (မပြသရန်) logic လိုအပ်ပါက isParentDeleted(reply) ကို ဤနေရာတွင် စစ်ဆေးနိုင်ပါသည် 🟢 --%>
        <li style="margin-bottom: 8px; list-style-type: none;" id="reply-item-${reply.id}">
        
            <div style="display: flex; justify-content: space-between; align-items: center; font-size: 14px; margin-bottom: 6px;">
    <strong>${reply.user.username}</strong>
    <span style="white-space: nowrap; margin-left: 10px;">${reply.createdAt}</span>
</div>

<p style="margin:0 0 6px 0;">
    ${reply.content}
</p>

            <div class="comment-actions">
    <button type="button" class="btn-action" onclick="toggleReplyForm('r-${reply.id}')">Reply</button>
    <c:if test="${sessionScope.userId == reply.user.id}">
        <button type="button" class="btn-action btn-delete" onclick="deleteComment(${reply.id})">Delete</button>
    </c:if>
</div>

            <c:if test="${sessionScope.userId != null}">
                <div id="replyFormContainer-r-${reply.id}" style="display: none; margin-top: 8px; margin-left: 20px;">
                    <%-- 🟢 FIX: JSTL မှတဆင့် postId ကိုပါ parameter အနေဖြင့် parameter/attribute ထည့်ပေးရန် သို့မဟုတ် Hidden input ထည့်ပေးရန်လိုအပ်သည် - ဤနေရာတွင် function အတွင်းသို့ post.id အား တိုက်ရိုက်ထည့်ပေးလိုက်ပါသည် 🟢 --%>
                    <form onsubmit="submitReply(event, 'r-${reply.id}', ${reply.id}, ${post.id})">
                        <textarea id="replyText-r-${reply.id}" rows="2" required placeholder="Reply ပြန်ရန်..." style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #ccc;"></textarea>
                        <br>
                        <button type="submit" class="button button-secondary" style="font-size: 12px; padding: 4px 10px; margin-top: 4px;">Submit Reply</button>
                    </form>
                </div>
            </c:if>
            
            <%-- မိမိကိုယ်တိုင် ပြန်လည် ထပ်ဆင့်ခေါ်ယူခြင်း (Recursive Calling) --%>
            <c:if test="${not empty reply.replies}">
                <ul style="margin-left:20px; list-style-type: none; padding-left: 0;" id="replySubListContainer-${reply.id}">
                    <c:set var="replyList" value="${reply.replies}" scope="request"/>
                    <jsp:include page="reply-recurse.jsp" />
                </ul>
            </c:if>
        </li>  
    </c:if>
</c:forEach>