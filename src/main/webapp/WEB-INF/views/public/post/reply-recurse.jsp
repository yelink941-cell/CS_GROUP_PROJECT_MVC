<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:forEach var="reply" items="${replyList}">
    <c:if test="${reply.deletedAt == null && not empty reply.content}">

        <li id="reply-item-${reply.id}" style="list-style:none; margin-bottom:12px;">

            <!-- Header -->
            <div style="display:flex; justify-content:space-between; align-items:center; font-size:14px; margin-bottom:6px;">
                <strong><c:out value="${reply.user.username}" /></strong>
                <span><c:out value="${reply.createdAt}" /></span>
            </div>

            <!-- Content -->
            <p style="margin:0 0 6px 0; line-height:1.5; color:#333;">
                <c:out value="${reply.content}" />
            </p>

            <!-- Actions -->
            <div class="comment-actions" style="display: flex; gap: 12px; margin-bottom: 8px;">
                <button type="button"
                        class="button-link"
                        onclick="toggleReplyForm('r-${reply.id}')">
                    Reply
                </button>

                <c:if test="${sessionScope.userId == reply.user.id}">
                    <button type="button"
                            class="button-link"
                            style="color: #dc3545;"
                            onclick="deleteComment(${reply.id})">
                        Delete
                    </button>
                </c:if>

                <button type="button"
                        class="button-link"
                        style="color: #dc2626;"
                        onclick="openReportModal('comment', ${reply.id})">
                    Report
                </button>
            </div>

            <!-- Reply Form -->
            <c:if test="${sessionScope.userId != null}">
                <div id="replyFormContainer-r-${reply.id}"
                     style="display:none; margin-top:8px; margin-left:20px;">

                    <form onsubmit="submitReply(event,'r-${reply.id}',${reply.id},${post.id})">

                        <textarea id="replyText-r-${reply.id}"
                                  rows="2"
                                  required
                                  placeholder="Reply ပြန်ရန်..."
                                  style="width:100%; padding:8px; border-radius:6px; border:1px solid #ccc;">
                        </textarea>

                        <button type="submit"
                                class="button button-secondary"
                                style="font-size:12px; padding:4px 10px; margin-top:4px;">
                            Submit Reply
                        </button>

                    </form>
                </div>
            </c:if>

            <!-- Nested Replies (CLEAN FIXED VERSION) -->
            <c:if test="${not empty reply.replies}">
                <ul id="replySubListContainer-${reply.id}"
                    style="margin-left:20px; padding-left:0; list-style:none;">

                    <c:set var="replyList" value="${reply.replies}" scope="request"/>
                    <jsp:include page="reply-recurse.jsp"/>

                </ul>
            </c:if>

        </li>

    </c:if>
</c:forEach>