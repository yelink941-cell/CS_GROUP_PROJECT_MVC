<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications — CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .notifications-page {
            max-width: 900px;
            margin: 0 auto;
            padding: 40px 20px 80px;
        }
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }
        .page-header h1 {
            margin: 0;
            font-size: 28px;
            color: #0f172a;
        }
        .page-header p {
            margin: 6px 0 0;
            color: #64748b;
        }
        .btn-mark-all {
            background: #2563eb;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-mark-all:hover {
            background: #1d4ed8;
        }
        .notification-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .notification-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 16px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .notification-card.unread {
            border-left: 4px solid #2563eb;
            background: #f8fafc;
        }
        .notification-title {
            font-size: 16px;
            font-weight: 700;
            color: #0f172a;
            margin: 0 0 6px;
        }
        .notification-message {
            color: #475569;
            margin: 0 0 10px;
            line-height: 1.5;
        }
        .notification-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #94a3b8;
        }
        .badge-type {
            background: #e2e8f0;
            color: #475569;
            padding: 2px 8px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 11px;
        }
        .btn-read {
            background: transparent;
            border: 1px solid #cbd5e1;
            color: #475569;
            padding: 4px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
            background: #f8fafc;
            border-radius: 12px;
            border: 1px dashed #cbd5e1;
        }
        .flash-success, .flash-error {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
        }
        .flash-success { background: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
        .flash-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

<main class="notifications-page">
    <div class="page-header">
        <div>
            <h1>&#128276; Notifications</h1>
            <p>သင့်အတွက် အရေးကြီးသော အကြောင်းကြားချက်များ</p>
        </div>
        <c:if test="${unreadCount > 0}">
            <form action="${pageContext.request.contextPath}/notifications/read-all" method="POST" style="margin:0;">
                <button type="submit" class="btn-mark-all">Mark all as read</button>
            </form>
        </c:if>
    </div>

    <c:if test="${not empty success}">
        <div class="flash-success"><c:out value="${success}"/></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="flash-error"><c:out value="${error}"/></div>
    </c:if>

    <div class="notification-list">
        <c:choose>
            <c:when test="${empty notifications}">
                <div class="empty-state">
                    <p style="font-size:18px; margin-bottom:8px;">&#128236; No notifications yet</p>
                    <p>Admin actions သို့မဟုတ် moderation updates ရောက်လာရင် ဒီမှာ ပြပါမယ်။</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="n" items="${notifications}">
                    <div class="notification-card ${n.isRead ? '' : 'unread'}">
                        <h3 class="notification-title"><c:out value="${n.title}"/></h3>
                        <p class="notification-message"><c:out value="${n.message}"/></p>
                        <div class="notification-meta">
                            <span>
                                <span class="badge-type"><c:out value="${n.type}"/></span>
                                &nbsp;·&nbsp;
                                <c:out value="${n.createdAt}"/>
                            </span>
                            <c:if test="${!n.isRead}">
                                <form action="${pageContext.request.contextPath}/notifications/${n.id}/read" method="POST" style="margin:0;">
                                    <button type="submit" class="btn-read">Mark read</button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</main>

</body>
</html>
