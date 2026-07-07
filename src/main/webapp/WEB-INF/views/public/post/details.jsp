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
:root {
    --primary: #4038ff;
    --secondary: #6366f1;
    --bg: #f8fafc;
    --text: #111827;
    --muted: #64748b;
    --border: #e5e7eb;
    --soft-border: #eef2f7;
    --code: #111827;
    --white: #ffffff;
}

body {
    margin: 0;
    background: var(--bg) !important;
    color: var(--text);
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    font-size: 15px;
    line-height: 1.65;
}

.page-container {
    max-width: 1350px !important;
    margin: 0 auto !important;
    padding: 28px 20px 40px !important;
}

.detail-card {
    background: var(--white) !important;
    border: 1px solid var(--border) !important;
    border-radius: 10px !important;
    box-shadow: 0 8px 22px rgba(15, 23, 42, 0.05) !important;
    padding: 24px !important;
    margin-bottom: 18px !important;
}

.detail-card h1 {
    margin: 0 0 14px !important;
    color: var(--text) !important;
    font-size: 36px !important;
    line-height: 1.2 !important;
    letter-spacing: -0.03em;
    font-weight: 800;
}

.post-meta {
    display: flex !important;
    flex-wrap: wrap;
    align-items: center !important;
    gap: 10px 18px !important;
    color: var(--muted);
    font-size: 14px;
    margin-bottom: 14px;
}

.post-meta span {
    display: inline-flex;
    align-items: center;
    gap: 5px;
}

.post-meta strong {
    color: var(--text);
    font-weight: 700;
}

.post-meta a {
    color: var(--primary) !important;
    text-decoration: none !important;
    font-weight: 700 !important;
}

.post-meta a:hover {
    text-decoration: underline !important;
}

.post-meta form {
    margin: 0 !important;
}

.post-meta button {
    border-radius: 999px !important;
    transition: transform 0.18s ease, box-shadow 0.18s ease;
}

.post-meta button:hover {
    transform: translateY(-2px);
}

.badge-row {
    display: flex !important;
    flex-wrap: wrap;
    gap: 8px !important;
    margin: 12px 0 !important;
}

.visibility-badge,
.status-badge,
.tag-pill {
    display: inline-flex;
    align-items: center;
    border-radius: 999px !important;
    padding: 5px 10px !important;
    font-size: 12px !important;
    font-weight: 700 !important;
    line-height: 1;
    text-transform: uppercase;
}

.visibility-public {
    background: #eef2ff !important;
    color: var(--primary) !important;
}

.visibility-private {
    background: #f3f4f6 !important;
    color: #4b5563 !important;
}

.status-published {
    background: #ecfdf5 !important;
    color: #047857 !important;
}

.tag-list {
    display: flex !important;
    flex-wrap: wrap;
    gap: 8px;
    margin: 12px 0 0 !important;
    padding: 0 !important;
    list-style: none;
}

.tag-pill {
    background: #f1f5f9 !important;
    color: #334155 !important;
    border: 1px solid var(--border);
}

.detail-excerpt {
    margin-top: 18px !important;
    padding-top: 18px;
    border-top: 1px solid var(--soft-border);
    color: #334155 !important;
    font-size: 15px;
    line-height: 1.75;
}

.public-content-grid {
    display: grid !important;
    grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
    gap: 16px !important;
    margin-top: 22px !important;
}

.public-content-card {
    background: var(--white) !important;
    border: 1px solid var(--border) !important;
    border-radius: 10px !important;
    overflow: hidden !important;
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.04) !important;
    transition: transform 0.18s ease, box-shadow 0.18s ease;
}

.public-content-card:hover {
    transform: translateY(-2px) !important;
    box-shadow: 0 12px 24px rgba(15, 23, 42, 0.07) !important;
}

.public-content-card-header {
    display: flex !important;
    justify-content: space-between !important;
    align-items: flex-start !important;
    gap: 12px !important;
    background: #ffffff !important;
    color: var(--text) !important;
    border-bottom: 1px solid var(--border);
    padding: 14px 16px !important;
}

.public-content-card-header h2 {
    margin: 0 !important;
    color: var(--text) !important;
    font-size: 20px !important;
    line-height: 1.3;
    font-weight: 800 !important;
}

.public-content-card-header span {
    flex: 0 0 auto;
    padding: 4px 8px !important;
    border-radius: 999px !important;
    background: #eef2ff !important;
    color: var(--primary) !important;
    font-size: 11px !important;
    font-weight: 800 !important;
    letter-spacing: 0.04em !important;
}

.public-content-card-body {
    background: var(--white) !important;
    padding: 16px !important;
    color: #334155;
    font-size: 15px;
    line-height: 1.7 !important;
}

.public-text-content {
    margin: 0;
    white-space: pre-line;
}

.public-code-content {
    position: relative;
    background: var(--code) !important;
    color: #e5e7eb !important;
    border-radius: 10px !important;
    padding: 16px !important;
    margin: 0;
    font-size: 14px !important;
    line-height: 1.65;
    white-space: pre !important;
    overflow-x: auto !important;
    font-family: Consolas, "Courier New", monospace !important;
}

.public-code-content::before {
    content: "Copy";
    position: absolute;
    top: 8px;
    right: 8px;
    background: #1f2937;
    color: #cbd5e1;
    border: 1px solid #374151;
    border-radius: 6px;
    padding: 3px 8px;
    font-family: system-ui, sans-serif;
    font-size: 11px;
    font-weight: 700;
}

.public-code-content code {
    color: #e5e7eb;
    font-family: Consolas, "Courier New", monospace;
}

.public-section-image {
    display: block;
    width: 100%;
    height: auto;
    border-radius: 10px;
    border: 1px solid var(--border);
}

.public-section-video {
    display: block;
    width: 100%;
    aspect-ratio: 16 / 9;
    border-radius: 10px;
    background: var(--code);
}

.public-section-link {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 9px 13px;
    border-radius: 8px;
    background: var(--primary);
    color: #ffffff !important;
    text-decoration: none;
    font-weight: 700;
    transition: transform 0.18s ease, background 0.18s ease;
}

.public-section-link:hover {
    transform: translateY(-2px);
    background: var(--secondary);
}

.collection-box,
.rating-section,
.action-bar {
    margin: 0 !important;
    padding: 0 !important;
    border: 0 !important;
}

.detail-card .collection-box {
    margin-top: 20px !important;
}

.collection-form,
.rating-section,
.action-bar {
    display: flex !important;
    align-items: center !important;
    flex-wrap: wrap !important;
    gap: 8px !important;
}

.collection-form {
    padding: 14px !important;
    border: 1px solid var(--border);
    border-radius: 10px;
    background: #ffffff;
}

.collection-label {
    font-size: 14px;
    font-weight: 700;
    color: #334155;
}

.collection-select {
    min-width: 190px;
    height: 38px;
    border: 1px solid var(--border);
    border-radius: 8px;
    background: #ffffff;
    color: #334155;
    padding: 0 10px;
    font-size: 14px;
}

.rating-section,
.action-bar {
    margin-top: 10px !important;
    padding: 14px !important;
    border: 1px solid var(--border) !important;
    border-radius: 10px;
    background: #ffffff;
}

.star-rating {
    direction: rtl;
    display: inline-flex;
    font-size: 20px;
    unicode-bidi: bidi-override;
}

.star-rating input {
    display: none;
}

.star-rating label {
    color: #cbd5e1;
    cursor: pointer;
    transition: color 0.18s ease;
}

.star-rating label:hover,
.star-rating label:hover ~ label,
.star-rating input:checked ~ label {
    color: #f59e0b;
}

.average-rating-box {
    background: #fffbeb;
    border: 1px solid #fde68a;
    color: #92400e;
    border-radius: 8px;
    padding: 7px 10px;
    font-size: 13px;
    font-weight: 700;
}

.button,
.btn,
.btn-add-collection,
.action-bar button,
.collection-form button {
    display: inline-flex !important;
    align-items: center !important;
    justify-content: center !important;
    min-height: 38px;
    border-radius: 8px !important;
    border: 1px solid transparent;
    padding: 8px 12px !important;
    font-size: 14px !important;
    font-weight: 700 !important;
    text-decoration: none !important;
    cursor: pointer;
    transition: transform 0.18s ease, background 0.18s ease, border-color 0.18s ease;
}

.button:hover,
.btn:hover,
.btn-add-collection:hover,
.action-bar button:hover,
.collection-form button:hover {
    transform: translateY(-2px);
}

.button,
.btn-add-collection,
.collection-form button {
    background: var(--primary) !important;
    color: #ffffff !important;
}

.button:hover,
.btn-add-collection:hover,
.collection-form button:hover {
    background: var(--secondary) !important;
}

.button-secondary {
    background: #eef2ff !important;
    color: var(--primary) !important;
    border-color: #dbe4ff !important;
}

.liked-btn {
    background: var(--primary) !important;
    color: white !important;
    border-color: var(--primary) !important;
}

.unliked-btn,
.button.bookmarked-btn {
    background: #f59e0b !important;
    color: white !important;
    border: 1px solid #d97706 !important;
}

.button.unbookmarked-btn {
    background: white !important;
    color: #334155 !important;
    border: 1px solid #cbd5e1 !important;
}

.btn-outline-warning {
    background: #ffffff !important;
    color: var(--primary) !important;
    border: 1px solid #dbe4ff !important;
}

.btn-report {
    background: #fff1f2 !important;
    color: #dc2626 !important;
    border: 1px solid #fecdd3 !important;
}

.btn-report:hover {
    background: #ffe4e6 !important;
}

.button-link {
    background: none;
    border: none;
    color: var(--primary);
    cursor: pointer;
    padding: 0;
    text-decoration: underline;
    font-size: 13px;
    font-weight: 600;
}

#commentsToggleWrapper {
    margin-top: 18px !important;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 12px; /* Border-radius နည်းနည်းတိုးပါ */
    box-shadow: 0 10px 25px -5px rgba(15, 23, 42, 0.1), 0 8px 10px -6px rgba(15, 23, 42, 0.1); /* အရိပ်ကို ပိုထင်ရှားအောင် */
    padding: 20px !important; /* Padding နည်းနည်းတိုးပါ */
}

#commentCountHeader {
    margin: 0 0 20px !important; /* အောက်က margin တိုးပါ */
    font-size: 22px !important; /* Font size နည်းနည်းတိုးပါ */
    font-weight: 800 !important;
    color: var(--text) !important;
    border-bottom: 2px solid var(--border); /* ခေါင်းစဉ်အောက်မှာမျဉ်းတားပါ */
    padding-bottom: 10px;
}

.comment-form-box,
#commentForm {
    margin: 0 0 24px !important; /* Form အောက်က ကွာဟချက်တိုးပါ */
    background: var(--bg-body);
    padding: 15px;
    border-radius: 8px;
    border: 1px solid var(--border);
}

#commentText,
textarea[id^="replyText-"] {
    width: 100% !important;
    padding: 14px !important; /* Padding တိုးပါ */
    border: 2px solid var(--border) !important; /* Border ကို ပိုထူပြီး သိသာအောင် */
    border-radius: 10px !important;
    resize: vertical !important;
    font-size: 16px; /* Font size တိုးပါ */
    box-sizing: border-box;
    background: var(--white);
}
#commentText:focus, textarea[id^="replyText-"]:focus {
    border-color: #4f46e5 !important; /* Focus ဝင်ရင် အပြာရောင်ပြောင်းပါ */
    outline: none;
}

/* Comment Item တစ်ခုချင်းစီကို သိသာအောင် ပြင်ခြင်း */
.comment-item,
[id^="comment-"],
[id^="reply-item-"] {
    border: 1px solid var(--border) !important;
    background: var(--comment-bg) !important; /* Comment background လေးထည့်ပါ */
    border-radius: 8px;
    padding: 15px !important;
    margin-bottom: 15px !important; /* အောက်က ကွာဟချက် */
}

/* Reply တွေကို ခွဲခြားသိသာအောင် အနည်းငယ် အတွင်းသို့ရွှေ့ပါ */
/* Reply တွေအတွက် CSS ကို အောက်ပါအတိုင်း ပြင်ပါ */
[id^="reply-item-"] {
    margin-left: 18px !important; /* အတွင်းကို နည်းနည်းရွှေ့ */
    padding: 10px !important;
    background: #e2e8f0 !important;
    border-radius: 8px;
    width: calc(100% - 30px); /* 100% မယူဘဲ နေရာချန်ထားပါ */
    margin-top: 10px;
}

.public-back-actions {
    margin-top: 18px !important;
    text-align: center;
}

.report-modal-backdrop {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(15, 23, 42, 0.45);
    z-index: 9999;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.report-modal {
    background: #ffffff;
    border-radius: 10px;
    padding: 20px;
    width: min(420px, 92vw);
    box-shadow: 0 20px 40px rgba(15, 23, 42, 0.18);
    border: 1px solid var(--border);
}

.report-modal select,
.report-modal textarea {
    width: 100%;
    box-sizing: border-box;
    margin-bottom: 14px;
    padding: 10px 12px;
    border: 1px solid var(--border);
    border-radius: 8px;
    font-size: 14px;
}

.report-modal-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}

@media (max-width: 1024px) {
    .public-content-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
    }
}

@media (max-width: 680px) {
    .page-container {
        padding: 18px 12px 30px !important;
    }

    .detail-card {
        padding: 18px !important;
    }

    .detail-card h1 {
        font-size: 30px !important;
    }

    .public-content-grid {
        grid-template-columns: 1fr !important;
    }

    .collection-form,
    .rating-section,
    .action-bar {
        align-items: stretch !important;
        flex-direction: column !important;
    }

    .collection-select,
    .collection-form .button,
    .collection-form button,
    .action-bar .button,
    .action-bar button {
        width: 100%;
    }
}
/* Screenshot-inspired compact Cheatography-like detail UI */
body {
    background: #fbf8f8 !important;
    color: #3f3f37;
    font-family: Georgia, "Times New Roman", serif;
}

.page-container {
    max-width: 1450px !important;
    padding: 0 50px 40px !important;
}

.detail-card {
    width: 100% !important;
    max-width: none !important;
    background: transparent !important;
    border: 0 !important;
    box-shadow: none !important;
    border-radius: 0 !important;
    padding: 0 !important;
    margin: 0 !important;
}

.detail-card h1 {
    margin: 0 0 14px !important;
    color: #4a4a40 !important;
    font-family: Georgia, "Times New Roman", serif !important;
    font-size: 42px !important;
    line-height: 1.12 !important;
    letter-spacing: -0.02em;
    font-weight: 700 !important;
}

.detail-title-author {
    font-size: 30px;
    font-weight: 400;
    color: #4a4a40;
}

.detail-title-author-name {
    color: #f47b33;
    border-bottom: 1px dotted #f47b33;
}

.post-meta {
    margin: 0 0 6px !important;
    padding: 0 !important;
    color: #6b665d !important;
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif !important;
    font-size: 14px !important;
    line-height: 1.4 !important;
}

.post-meta span {
    color: #6b665d !important;
    letter-spacing: 0 !important;
}

.post-meta strong {
    color: #4a4a40 !important;
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif !important;
    font-size: 14px !important;
    font-weight: 700 !important;
}

.badge-row,
.tag-list {
    margin-top: 8px !important;
}

.visibility-badge,
.status-badge,
.tag-pill {
    border-radius: 4px !important;
    padding: 4px 8px !important;
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    font-size: 11px !important;
}

.detail-excerpt {
    width: 100% !important;
    max-width: 960px !important;
    margin: 10px 0 0 !important;
    padding: 0 0 10px !important;
    border-top: 0 !important;
    border-bottom: 1px dotted #ded7d2;
    color: #4f4f46 !important;
    font-family: Georgia, "Times New Roman", serif !important;
    font-size: 18px !important;
    line-height: 1.45 !important;
    text-align: left !important;
}

.public-content-grid {
    grid-template-columns: repeat(3, minmax(0, 1fr)) !important;
    width: 100% !important;
    align-items: start;
    gap: 28px 26px !important;
    margin-top: 14px !important;
}

.public-content-card {
    min-width: 0 !important;
    width: 100% !important;
    background: transparent !important;
    border: 0 !important;
    border-radius: 0 !important;
    box-shadow: none !important;
    overflow: visible !important;
}

.public-content-card:hover {
    transform: none !important;
    box-shadow: none !important;
}

.public-content-card-header {
    display: block !important;
    background: transparent !important;
    border: 0 !important;
    padding: 0 16px 10px !important;
}

.public-content-card-header h2 {
    color: #b00000 !important;
    font-family: Georgia, "Times New Roman", serif !important;
    font-size: 21px !important;
    font-weight: 700 !important;
    line-height: 1.2 !important;
}

.public-content-card-header span {
    display: none !important;
}

.public-content-card-body {
    min-width: 0 !important;
    width: 100% !important;
    box-sizing: border-box !important;
    background: #ffffff !important;
    border: 1px solid #eee8e8 !important;
    border-radius: 4px !important;
    box-shadow: 0 2px 7px rgba(0, 0, 0, 0.08) !important;
    padding: 0 !important;
    color: #46443f;
    font-family: Georgia, "Times New Roman", serif !important;
    font-size: 22px !important;
    line-height: 1.55 !important;
}

.public-text-content {
    margin: 0 !important;
    padding: 14px 16px !important;
    white-space: pre-line;
}

.public-text-content,
.public-table-content {
    background:
        repeating-linear-gradient(
            to bottom,
            #ffffff 0,
            #ffffff 58px,
            #fbf7f7 58px,
            #fbf7f7 116px
        );
}

.public-code-content {
    display: block !important;
    max-width: 100% !important;
    box-sizing: border-box !important;
    margin: 0 !important;
    border-radius: 4px !important;
    background: #111827 !important;
    color: #e5e7eb !important;
    font-family: Consolas, "Courier New", monospace !important;
    font-size: 14px !important;
    line-height: 1.6 !important;
    white-space: pre-wrap !important;
    word-break: break-word !important;
    overflow-x: auto !important;
}

.public-code-content::before {
    display: none !important;
}

.public-section-image,
.public-section-video {
    max-width: calc(100% - 24px);
    box-sizing: border-box;
    width: calc(100% - 24px);
    margin: 12px;
    border-radius: 4px;
    border: 1px solid #eee8e8;
}

.public-section-link {
    margin: 14px 16px;
    background: transparent !important;
    color: #b00000 !important;
    border-bottom: 1px dotted #b00000;
    border-radius: 0;
    padding: 0;
    box-shadow: none;
    font-family: Georgia, "Times New Roman", serif;
    font-size: 22px;
}

.collection-box,
.rating-section,
.action-bar,
#commentsToggleWrapper,
.public-back-actions {
    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
}

.detail-card .collection-box {
    margin-top: 38px !important;
}

@media (max-width: 1024px) {
    .public-content-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr)) !important;
    }
}

@media (max-width: 680px) {
    .page-container {
        padding: 0 14px 30px !important;
    }

    .detail-card h1 {
        font-size: 32px !important;
    }

    .detail-title-author {
        display: block;
        margin-top: 4px;
        font-size: 22px;
    }

    .detail-excerpt {
        font-size: 18px;
    }

    .public-content-grid {
        grid-template-columns: 1fr !important;
        gap: 26px !important;
        margin-top: 36px !important;
    }

    .public-content-card-body {
        font-size: 18px !important;
    }
}

/* Final compact override */
.page-container {
    width: min(1500px, calc(100% - 120px)) !important;
    max-width: 1500px !important;
    margin: 0 auto !important;
    padding: 0 0 36px !important;
    box-sizing: border-box !important;
}

.detail-card h1 {
    font-size: 38px !important;
    margin-bottom: 8px !important;
}

.post-meta {
    margin-bottom: 4px !important;
}

.badge-row {
    margin: 6px 0 !important;
}

.tag-list {
    margin: 6px 0 0 !important;
}

.detail-excerpt {
    display: block !important;
    width: 100% !important;
    max-width: none !important;
    margin: 14px 0 0 !important;
    padding-bottom: 16px !important;
    font-size: 17px !important;
    line-height: 1.35 !important;
    min-height: auto !important;
    max-height: 46px !important;
    overflow: hidden !important;
    text-overflow: clip !important;
    white-space: normal !important;
}

.public-content-grid {
    margin-top: 24px !important;
    gap: 22px 28px !important;
}

.public-content-card-header {
    padding-bottom: 8px !important;
}


</style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

<main class="page-container">
    <c:if test="${isBannedNotice}">
        <div style="background: #fef2f2; border: 1px solid #fecaca; border-left: 5px solid #ef4444; color: #991b1b; padding: 16px 20px; border-radius: 12px; margin-bottom: 24px; font-weight: 600; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 12px rgba(239, 68, 68, 0.1);">
            <div style="display: flex; align-items: center; gap: 12px;">
                <i class="fa-solid fa-triangle-exclamation" style="font-size: 1.4rem; color: #dc2626;"></i>
                <div>
                    <strong style="font-size: 1rem; display: block; color: #7f1d1d;">Banned Cheat Sheet (Admin Moderation View)</strong>
                    <span style="font-size: 0.88rem; color: #991b1b;">This cheat sheet is currently <strong>BANNED / Hidden</strong> from public users. Reason: <c:out value="${post.removalReason}" default="Moderation Policy Violation" /></span>
                </div>
            </div>
            <span style="background: #ef4444; color: white; padding: 6px 12px; border-radius: 8px; font-size: 0.75rem; text-transform: uppercase; font-weight: 800; letter-spacing: 0.5px;">ADMIN VIEW ONLY</span>
        </div>
    </c:if>

    <article class="detail-card">
        <h1>
            <c:out value="${post.title}" />
            <span class="detail-title-author">
                by <span class="detail-title-author-name"><c:out value="${post.author.username}" /></span>
            </span>
        </h1>

        <div class="post-meta">
            <span><strong>Category:</strong> <c:out value="${post.category.name}" /></span>
            <span><strong>Author:</strong> <c:out value="${post.author.username}" /></span>
            <c:if test="${not empty post.createdAt}">
                <span><strong>Created:</strong> <c:out value="${post.createdAt}" /></span>
            </c:if>
        </div>

        <div class="badge-row" style="margin-top: 14px; display: flex; gap: 8px;">
            <span class="visibility-badge ${post.visibility == 'PUBLIC' ? 'visibility-public' : 'visibility-private'}">
                <c:out value="${post.visibility}" />
            </span>
            <span class="status-badge status-published">
                <c:out value="${post.status}" />
            </span>
        </div>

        <c:if test="${not empty post.tags}">
            <ul class="tag-list" aria-label="Post tags">
                <c:forEach var="tag" items="${post.tags}">
                    <li class="tag-pill"><c:out value="${tag.name}" /></li>
                </c:forEach>
            </ul>
        </c:if>

        <div class="detail-excerpt"><c:choose>
            <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
            <c:otherwise>No excerpt provided.</c:otherwise>
        </c:choose></div>

        <%-- Post Content Grid --%>
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
                                            <img class="public-section-image"
                                                 src="${pageContext.request.contextPath}${fn:escapeXml(content.contentData)}"
                                                 alt="${fn:escapeXml(content.subtitle)}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="public-section-image"
                                                 src="${fn:escapeXml(content.contentData)}"
                                                 alt="${fn:escapeXml(content.subtitle)}">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>

                                <c:when test="${content.contentType == 'VIDEO'}">
                                    <video class="public-section-video" controls src="${fn:escapeXml(content.contentData)}"></video>
                                </c:when>

                                <c:when test="${content.contentType == 'LINK'}">
                                    <a class="public-section-link"
                                       href="${fn:escapeXml(content.contentData)}"
                                       target="_blank"
                                       rel="noopener noreferrer">
                                        <c:out value="${content.contentData}" />
                                    </a>
                                </c:when>

                                <c:otherwise>
                                    <p class="public-text-content">
                                        <c:out value="${content.contentData}" />
                                    </p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </c:if>

        <%-- Collection Box --%>
        <c:if test="${not empty sessionScope.userId}">
            <div class="collection-box">
                <form action="${pageContext.request.contextPath}/user/collections/add-post"
                      method="post"
                      class="collection-form">

                    <input type="hidden" name="postId" value="${post.id}">
                    <input type="hidden" name="slug" value="${post.slug}">

                    <label for="collectionSelect" class="collection-label">
                        📁 Save to Folder:
                    </label>

                    <select id="collectionSelect"
                            name="collectionId"
                            required
                            class="collection-select"
                            onchange="checkFolderStatus()">
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

        <%-- Rating Section --%>
        <div class="rating-section">
            <c:choose>
                <c:when test="${not empty userLoggedIn || not empty sessionScope.userId}">
                    <div class="star-rating">
                        <input type="radio" id="star5" name="rating" value="5"
                               onclick="submitRating(${post.id}, 5)" ${userRating == 5 ? 'checked' : ''}>
                        <label for="star5" title="5 stars">★</label>

                        <input type="radio" id="star4" name="rating" value="4"
                               onclick="submitRating(${post.id}, 4)" ${userRating == 4 ? 'checked' : ''}>
                        <label for="star4" title="4 stars">★</label>

                        <input type="radio" id="star3" name="rating" value="3"
                               onclick="submitRating(${post.id}, 3)" ${userRating == 3 ? 'checked' : ''}>
                        <label for="star3" title="3 stars">★</label>

                        <input type="radio" id="star2" name="rating" value="2"
                               onclick="submitRating(${post.id}, 2)" ${userRating == 2 ? 'checked' : ''}>
                        <label for="star2" title="2 stars">★</label>

                        <input type="radio" id="star1" name="rating" value="1"
                               onclick="submitRating(${post.id}, 1)" ${userRating == 1 ? 'checked' : ''}>
                        <label for="star1" title="1 star">★</label>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="star-rating"
                         onclick="alert('Please login to rate this post.'); window.location.href='${pageContext.request.contextPath}/login';"
                         style="cursor: pointer;"
                         title="Click to rate">
                        <label style="color: ${averageRating >= 1 ? '#ffc107' : '#ccc'}; cursor: pointer;">★</label>
                        <label style="color: ${averageRating >= 2 ? '#ffc107' : '#ccc'}; cursor: pointer;">★</label>
                        <label style="color: ${averageRating >= 3 ? '#ffc107' : '#ccc'}; cursor: pointer;">★</label>
                        <label style="color: ${averageRating >= 4 ? '#ffc107' : '#ccc'}; cursor: pointer;">★</label>
                        <label style="color: ${averageRating >= 5 ? '#ffc107' : '#ccc'}; cursor: pointer;">★</label>
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="average-rating-box">
                <strong>⭐ Average:</strong>
                <span id="avgRatingValue">${not empty averageRating ? averageRating : 0.0}</span>/5
                (<span id="totalRatingCount">${not empty totalRatings ? totalRatings : 0}</span> ratings)
            </div>
        </div>

        <%-- Action Bar --%>
        <div class="action-bar">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <button type="button"
                            onclick="toggleLikePost(${post.id}, this)"
                            class="button ${hasUserLiked ? 'liked-btn' : 'unliked-btn'}"
                            style="display: inline-flex; align-items: center; gap: 8px;">
                        <span id="likeIcon-${post.id}">
                            <c:choose>
                                <c:when test="${hasUserLiked}">👍 Unlike</c:when>
                                <c:otherwise>👍 Like</c:otherwise>
                            </c:choose>
                        </span>
                    </button>

                    <span style="font-size: 14px; font-weight: 600; color: #475569;">
                        Likes: <span id="likeCount-${post.id}">${not empty likeCount ? likeCount : 0}</span>
                    </span>
                </c:when>

                <c:otherwise>
                    <button type="button"
                            onclick="alert('Please login to like this post.'); window.location.href='${pageContext.request.contextPath}/login';"
                            class="button unliked-btn"
                            style="display: inline-flex; align-items: center; gap: 8px;">
                        👍 Like
                    </button>

                    <span style="font-size: 14px; font-weight: 600; color: #475569;">
                        Likes: <span id="likeCount-${post.id}">${not empty likeCount ? likeCount : 0}</span>
                    </span>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <button type="button"
                            onclick="toggleBookmark(${post.id}, this)"
                            class="button ${hasUserBookmarked ? 'bookmarked-btn' : 'unbookmarked-btn'}"
                            style="display: inline-flex; align-items: center; gap: 8px;">
                        <span id="bookmarkIcon-${post.id}">
                            <c:choose>
                                <c:when test="${hasUserBookmarked}">⭐ Bookmarked</c:when>
                                <c:otherwise>⭐ Bookmark</c:otherwise>
                            </c:choose>
                        </span>
                    </button>
                </c:when>

                <c:otherwise>
                    <button type="button"
                            onclick="alert('Please login to bookmark this post.'); window.location.href='${pageContext.request.contextPath}/login';"
                            class="button unbookmarked-btn"
                            style="display: inline-flex; align-items: center; gap: 8px;">
                        ⭐ Bookmark
                    </button>
                </c:otherwise>
            </c:choose>

            <button type="button"
                    id="commentCountBtn"
                    class="button button-secondary"
                    onclick="toggleCommentsSection()">
                💬 Comments (${not empty totalComments ? totalComments : (not empty comments ? fn:length(comments) : 0)})
            </button>

            <c:if test="${post.status != 'USER_DELETED' && empty post.deletedAt}">
                <a class="button button-secondary"
                   href="${pageContext.request.contextPath}/posts/${post.slug}/download-pdf"
                   style="display: inline-flex; align-items: center; gap: 6px; text-decoration: none;">
                    📄 Download PDF
                </a>
            </c:if>

            <c:if test="${sessionScope.userId != post.author.id}">
                <button type="button"
                        onclick="openReportModal('post', ${post.id})"
                        class="button button-secondary"
                        style="display: inline-flex; align-items: center; gap: 8px; color: #dc2626; border-color: #fca5a5;">
                    🚩 Report Post
                </button>
            </c:if>
        </div>

        <%-- Comments Section --%>
        <section id="commentsToggleWrapper"
                 class="comments-section"
                 style="display: none; margin-top: 35px; padding-top: 25px; border-top: 1px solid #e2e8f0;">

            <h2 id="commentCountHeader"
                data-count="${not empty totalComments ? totalComments : (not empty comments ? fn:length(comments) : 0)}"
                style="font-size: 20px; color: #1e293b; margin-bottom: 20px;">
                💬 Comments (${not empty totalComments ? totalComments : (not empty comments ? fn:length(comments) : 0)})
            </h2>

            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <form id="commentForm" style="margin-bottom: 25px;">
                        <input type="hidden" id="postId" name="postId" value="${post.id}">

                        <textarea id="commentText"
                                  name="commentText"
                                  rows="3"
                                  required
                                  placeholder="Write a comment..."
                                  style="width: 100%; padding: 12px; border-radius: 10px; border: 1px solid #cbd5e1; font-family: inherit; font-size: 14px; box-sizing: border-box; resize: vertical;"></textarea>

                        <button type="submit"
                                class="button button-primary"
                                style="margin-top: 10px; padding: 10px 20px; background: #4038ff; color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">
                            Post Comment
                        </button>
                    </form>
                </c:when>

                <c:otherwise>
                    <div style="padding: 14px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; margin-bottom: 25px; color: #64748b; font-size: 14px;">
                        Please <a href="${pageContext.request.contextPath}/login" style="color: #4038ff; font-weight: 600;">login</a> to leave a comment.
                    </div>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${not empty comments}">
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

                                    <c:if test="${sessionScope.userId != comment.user.id}">
                                        <button type="button" class="button-link" style="color: #dc2626;" onclick="openReportModal('comment', ${comment.id})">Report</button>
                                    </c:if>
                                </div>

                                <c:if test="${not empty sessionScope.userId}">
                                    <div id="replyFormContainer-c-${comment.id}" style="display: none; margin-top: 6px; margin-left: 20px;">
                                        <form onsubmit="submitReply(event, 'c-${comment.id}', ${comment.id}, ${post.id})">
                                            <textarea id="replyText-c-${comment.id}"
                                                      rows="2"
                                                      required
                                                      placeholder="Write a reply..."
                                                      style="width: 100%; padding: 6px; border-radius: 6px; border: 1px solid #ccc; font-family: inherit; font-size: 13px; box-sizing: border-box;"></textarea>

                                            <br>

                                            <button type="submit"
                                                    class="button button-secondary"
                                                    style="font-size: 11px; padding: 4px 10px; margin-top: 4px; cursor: pointer;">
                                                Post Reply
                                            </button>
                                        </form>
                                    </div>
                                </c:if>

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
                </c:when>

                <c:otherwise>
                    <p id="noCommentsMessage" style="color: #888;">No comments yet.</p>
                </c:otherwise>
            </c:choose>
        </section>
    </article>

    <div class="public-back-actions">
        <a class="button button-secondary" href="${pageContext.request.contextPath}/posts/public">
            Back to Posts
        </a>
    </div>
</main>

<%-- Report Modal Container --%>
<div id="reportModal" class="report-modal-backdrop" onclick="closeReportModal()">
    <div class="report-modal" onclick="event.stopPropagation()">
        <h3 id="reportModalTitle" style="margin-top: 0; font-size: 18px; color: #1e293b;">Report Content</h3>
        <form id="reportForm" onsubmit="handleReportSubmit(event)">
            <input type="hidden" id="reportTargetType" value="post">
            <input type="hidden" id="reportTargetId" value="">
            
            <div style="margin-bottom: 14px;">
                <label for="reportReason" style="display: block; font-size: 13px; font-weight: 600; color: #475569; margin-bottom: 6px;">Reason</label>
                <select id="reportReason" required style="width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 14px; background-color: #fff;">
                    <option value="TEXT">Inappropriate Text</option>
                    <option value="CODE">Harmful / Malicious Code</option>
                    <option value="IMAGE">Inappropriate Image</option>
                    <option value="VIDEO">Inappropriate Video</option>
                    <option value="LINK">Spam / Dangerous Link</option>
                    <option value="OTHER">Other</option>
                </select>
            </div>
            
            <div style="margin-bottom: 18px;">
                <label for="reportDescription" style="display: block; font-size: 13px; font-weight: 600; color: #475569; margin-bottom: 6px;">Description (Optional)</label>
                <textarea id="reportDescription" rows="3" placeholder="Provide additional details..." style="width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 14px; resize: vertical; box-sizing: border-box;"></textarea>
            </div>
            
            <div style="display: flex; justify-content: flex-end; gap: 10px;">
                <button type="button" onclick="closeReportModal()" class="button button-secondary" style="padding: 8px 16px; border-radius: 6px; cursor: pointer;">Cancel</button>
                <button type="submit" class="button" style="background-color: #dc2626; color: #ffffff; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-weight: 600;">Submit Report</button>
            </div>
        </form>
    </div>
</div>

<script>
/* =========================
   🔐 CSRF HELPER
========================= */
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

/* =========================
   🔗 URL HASH HELPER
========================= */
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

/* =========================
   🔡 HTML ESCAPE HELPER
========================= */
function escapeHtml(str) {
    if (str === null || str === undefined) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
}

/* =========================
   💬 COMMENT COUNT UPDATE HELPER
========================= */
function updateCommentCount(newCount) {
    const header = document.getElementById('commentCountHeader');
    if (header) {
        header.setAttribute('data-count', newCount);
        header.innerText = '💬 Comments (' + newCount + ')';
    }
    const btn = document.getElementById('commentCountBtn');
    if (btn) {
        btn.innerText = '💬 Comments (' + newCount + ')';
    }
}

/* =========================
   📁 Folder Check
========================= */
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

/* =========================
   💬 COMMENT SUBMIT
========================= */
let commentFormListenerAttached = false;
function attachCommentFormListener() {
    if (commentFormListenerAttached) return;
    const commentForm = document.getElementById('commentForm');
    if (!commentForm) return;
    commentFormListenerAttached = true;
commentForm.addEventListener('submit', function(e) {
    e.preventDefault();
    
	
    const postId = document.querySelector('#postId').value;
    const commentText = document.getElementById('commentText').value;

    fetch(getCleanUrl('/comments/add'), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'postId=' + postId + '&commentText=' + encodeURIComponent(commentText)
    })
    .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
    })
    .then(data => {
        if (data.status === 'success') {
            // 🟢 No-reload: backend မှ ပြန်လာတဲ့ data နဲ့ comment DOM အသစ်တည်ဆောက်ပြီး
            //    comment list အောက်ဆုံးမှာ တိုက်ရိုက်ထည့်မည်။
            const commentText = document.getElementById('commentText');
            commentText.value = '';

            let container = document.getElementById('commentListContainer');
            if (!container) {
                // ပထမဆုံး comment ဖြစ်နေလျှင် container အသစ်တည်ဆောက်
                container = document.createElement('div');
                container.id = 'commentListContainer';
                container.className = 'comment-list';
                container.style.cssText = 'display: flex; flex-direction: column; gap: 16px;';
                document.getElementById('commentsToggleWrapper').appendChild(container);
            }

            // ကွန်မန့်မရှိသေးပါ message ကို ဖယ်ရှားမည်
            const noCommentsMsg = document.getElementById('noCommentsMessage');
            if (noCommentsMsg) {
                noCommentsMsg.remove();
            }

            const newComment = document.createElement('div');
            newComment.className = 'comment-item';
            newComment.id = 'comment-' + data.commentId;
            newComment.style.cssText = 'border-bottom: 1px solid #f0f0f0; padding-bottom: 12px;';

            const safeUser = escapeHtml(data.username);
            const safeContent = escapeHtml(data.content);
            const safeDate = escapeHtml(data.createdAt);

            newComment.innerHTML =
                '<div style="display: flex; justify-content: space-between; font-size: 14px; color: #555; margin-bottom: 6px;">' +
                    '<strong>' + safeUser + '</strong>' +
                    '<span>' + safeDate + '</span>' +
                '</div>' +
                '<p style="margin: 0 0 6px 0; line-height: 1.5; color: #333;">' + safeContent + '</p>' +
                '<div style="display: flex; gap: 12px; margin-bottom: 8px;">' +
                    '<button type="button" class="button-link" onclick="toggleReplyForm(\'c-' + data.commentId + '\')">Reply</button>' +
                    '<button type="button" class="button-link" style="color: #dc3545;" onclick="deleteComment(' + data.commentId + ')">Delete</button>' +
                '</div>' +
                '<div id="replyFormContainer-c-' + data.commentId + '" style="display: none; margin-top: 6px; margin-left: 20px;">' +
                    '<form onsubmit="submitReply(event, \'c-' + data.commentId + '\', ' + data.commentId + ', ' + postId + ')">' +
                        '<textarea id="replyText-c-' + data.commentId + '" rows="2" required placeholder="Reply ပြန်ရန်..." style="width: 100%; padding: 6px; border-radius: 6px; border: 1px solid #ccc;"></textarea>' +
                        '<br>' +
                        '<button type="submit" class="button button-secondary" style="font-size: 11px; padding: 3px 8px; margin-top: 4px;">Reply ပို့မည်</button>' +
                    '</form>' +
                '</div>' +
                '<div id="replyListContainer-' + data.commentId + '"></div>';

            container.prepend(newComment);

            // 🟢 Comment count တိုး
            const header = document.getElementById('commentCountHeader');
            if (header) {
                const newCount = parseInt(header.getAttribute('data-count') || '0') + 1;
                updateCommentCount(newCount);
            }

            showCommentsSection();

            updateUrlHash('comment');
        } else {
            alert('Comment error: ' + (data.message || ''));
        }
    })
    .catch(err => {
        console.error('Comment request failed:', err);
        if (err.message && err.message.includes('401')) {
            window.location.href = '${pageContext.request.contextPath}/login';
        } else {
            alert('Comment ပို့၍မရပါ။ ပြန်လည်စမ်းကြည့်ပါ။');
        }
    });
});
}

/* =========================
   🔁 REPLY TOGGLE
========================= */
function toggleReplyForm(commentId) {
    const replyForm = document.getElementById('replyFormContainer-' + commentId);

    if (!replyForm) return;

    const isVisible = replyForm.style.display === "block";

    document.querySelectorAll('[id^="replyFormContainer-"]')
        .forEach(f => f.style.display = "none");

    replyForm.style.display = isVisible ? "none" : "block";
}

/* =========================
   🔁 SUBMIT REPLY
========================= */
function submitReply(e, commentId, parentId, postId) {
    e.preventDefault();

    const replyText = document.getElementById('replyText-' + commentId).value;

    fetch(getCleanUrl('/comments/reply'), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body:
            'postId=' + postId +
            '&parentId=' + parentId +
            '&content=' + encodeURIComponent(replyText)
    })
    .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
    })
    .then(data => {
        if (data.status !== 'success') {
            alert('Reply error: ' + (data.message || ''));
            return;
        }

        // 🟢 No-reload: textarea ရှင်း
        const replyInput = document.getElementById('replyText-' + commentId);
        if (replyInput) replyInput.value = '';

        // reply ထည့်ရမည့် list container (<ul>) ကို ရှာရန်/ဖန်တီးရန်
        const realParentId = data.parentId || parentId;
        let subList = document.getElementById('replySubListContainer-' + realParentId);

        if (!subList) {
            subList = document.createElement('ul');
            subList.id = 'replySubListContainer-' + realParentId;
            subList.style.cssText = 'margin-left: 20px; padding-left: 0; list-style-type: none;';

            // Find parent to append this new <ul>
            const mainCommentListWrap = document.getElementById('replyListContainer-' + realParentId);
            if (mainCommentListWrap) {
                mainCommentListWrap.appendChild(subList);
            } else {
                const parentReplyItem = document.getElementById('reply-item-' + realParentId);
                if (parentReplyItem) {
                    parentReplyItem.appendChild(subList);
                } else {
                    const mainComment = document.getElementById('comment-' + realParentId);
                    if (mainComment) {
                        const wrap = document.createElement('div');
                        wrap.id = 'replyListContainer-' + realParentId;
                        mainComment.appendChild(wrap);
                        wrap.appendChild(subList);
                    }
                }
            }
        }

        const safeUser = escapeHtml(data.username);
        const safeContent = escapeHtml(data.content);
        const safeDate = escapeHtml(data.createdAt);

        const replyEl = document.createElement('li');
        replyEl.id = 'reply-item-' + data.replyId;
        replyEl.style.cssText = 'list-style: none; margin-bottom: 12px;';
        replyEl.innerHTML =
            '<!-- Header -->' +
            '<div style="display: flex; justify-content: space-between; align-items: center; font-size: 14px; margin-bottom: 6px;">' +
                '<strong>' + safeUser + '</strong>' +
                '<span>' + safeDate + '</span>' +
            '</div>' +
            '<!-- Content -->' +
            '<p style="margin: 0 0 6px 0; line-height: 1.5; color: #333;">' + safeContent + '</p>' +
            '<!-- Actions -->' +
            '<div class="comment-actions">' +
                '<button type="button" class="btn-action" onclick="toggleReplyForm(\'r-' + data.replyId + '\')">Reply</button>' +
                '<button type="button" class="btn-action btn-delete" style="margin-left: 8px;" onclick="deleteComment(' + data.replyId + ')">Delete</button>' +
            '</div>' +
            '<!-- Reply Form -->' +
            '<div id="replyFormContainer-r-' + data.replyId + '" style="display: none; margin-top: 8px; margin-left: 20px;">' +
                '<form onsubmit="submitReply(event, \'r-' + data.replyId + '\', ' + data.replyId + ', ' + postId + ')">' +
                    '<textarea id="replyText-r-' + data.replyId + '" rows="2" required placeholder="Reply ပြန်ရန်..." style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid #ccc;"></textarea>' +
                    '<button type="submit" class="button button-secondary" style="font-size: 12px; padding: 4px 10px; margin-top: 4px;">Submit Reply</button>' +
                '</form>' +
            '</div>' +
            '<!-- Nested Replies Container -->' +
            '<ul id="replySubListContainer-' + data.replyId + '" style="margin-left: 20px; padding-left: 0; list-style: none;"></ul>';

        subList.prepend(replyEl);

        // 🟢 reply form ပိတ်ရန်
        const replyForm = document.getElementById('replyFormContainer-' + commentId);
        if (replyForm) replyForm.style.display = 'none';

        // 🟢 Comment count တိုး
        const header = document.getElementById('commentCountHeader');
        if (header) {
            const newCount = parseInt(header.getAttribute('data-count') || '0') + 1;
            updateCommentCount(newCount);
        }

        showCommentsSection();
        updateUrlHash('reply');
    })
    .catch(err => {
        console.error('Reply request failed:', err);
        if (err.message && err.message.includes('401')) {
            window.location.href = '${pageContext.request.contextPath}/login';
        } else {
            alert('Reply failed');
        }
    });
}

/* =========================
   🗑 DELETE COMMENT
========================= */
function deleteComment(commentId) {
    if (!confirm('Are you sure you want to delete this comment?')) return;

    fetch(getCleanUrl('/comments/delete/') + commentId, {
        method: 'POST',
        headers: getCsrfHeaders()
    })
    .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
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
            let newCount = parseInt(header.getAttribute('data-count') || '0') - deletedCount;
            if (newCount < 0) newCount = 0;
            updateCommentCount(newCount);
        }
    })
    .catch(err => {
        console.error('Delete request failed:', err);
        if (err.message && err.message.includes('401')) {
            window.location.href = '${pageContext.request.contextPath}/login';
        } else {
            alert('Delete failed');
        }
    });
}

/* =========================
   👍 LIKE
========================= */
function toggleLikePost(postId, btn) {
    var url = getCleanUrl('/api/toggle-like');

    fetch(url, {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'postId=' + postId
    })
    .then(function(r) {
        if (!r.ok) {
            return r.text().then(function(txt) {
                throw new Error('HTTP ' + r.status + ': ' + txt);
            });
        }
        return r.json();
    })
    .then(function(data) {
        if (data.status === 'success') {
            var countEl = document.getElementById('likeCount-' + postId);
            if (countEl) countEl.innerText = data.totalLikes;

            var icon = document.getElementById('likeIcon-' + postId);

            if (data.isLiked) {
                icon.innerHTML = "👍 Unlike";
                btn.className = "button liked-btn";
            } else {
                icon.innerHTML = "👍 Like";
                btn.className = "button unliked-btn";
            }

            updateUrlHash('like');
        } else {
            alert('Like error: ' + (data.message || 'Unknown error'));
        }
    })
    .catch(function(err) {
        console.error('Like request failed:', err);
        if (err.message && err.message.includes('401')) {
            window.location.href = '${pageContext.request.contextPath}/login';
        } else {
            alert('Could not complete like action.');
        }
    });
}

/* =========================
   ⭐ RATING
========================= */
function submitRating(postId, rating) {
    fetch(getCleanUrl('/api/toggle-rating'), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body:
            'postId=' + postId +
            '&rating=' + rating
    })
    .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
    })
    .then(data => {
        if (data.status === 'success'){
            document.getElementById("avgRatingValue").innerText = data.averageRating;
            document.getElementById("totalRatingCount").innerText = data.totalRatings;

            const starInputs = document.querySelectorAll('.star-rating input[name="rating"]');
            starInputs.forEach(function (input) {
                if (!data.hasRated) {
                    input.checked = false;
                } else if (parseInt(input.value) === rating) {
                    input.checked = true;
                }
            });

            updateUrlHash('rating');
        } else {
            alert('Rating error: ' + (data.message || ''));
        }
    })
    .catch(err => {
        console.error('Rating request failed:', err);
        if (err.message && err.message.includes('401')) {
            window.location.href = '${pageContext.request.contextPath}/login';
        } else {
            alert('Failed to submit rating.');
        }
    });
}

/* =========================
   🔖 BOOKMARK
========================= */
function toggleBookmark(postId, btn) {
    const isLoggedIn = "${sessionScope.userId != null}" === "true";

    if (!isLoggedIn) {
        window.location.href = '${pageContext.request.contextPath}/login';
        return;
    }

    fetch(getCleanUrl('/api/toggle-bookmark'), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'postId=' + postId
    })
    .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
    })
    .then(data => {
        if (data.status === 'success') {
            const icon = document.getElementById('bookmarkIcon-' + postId);

            if (data.isBookmarked) {
                icon.innerHTML = "⭐ Bookmarked";
                btn.className = "button bookmarked-btn";
            } else {
                icon.innerHTML = "⭐ Bookmark";
                btn.className = "button unbookmarked-btn";
            }
            updateUrlHash('bookmark');
        } else {
            alert('Bookmark error: ' + (data.message || ''));
        }
    })
    .catch(err => {
        console.error('Bookmark request failed:', err);
        if (err.message && err.message.includes('401')) {
            window.location.href = '${pageContext.request.contextPath}/login';
        } else {
            alert('Failed to update bookmark status.');
        }
    });
}

/* =========================
   💬 TOGGLE COMMENTS
========================= */
function toggleCommentsSection() {
    const el = document.getElementById('commentsToggleWrapper');
    if (!el) return;
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

/* =========================
   🚩 REPORT MODAL & SUBMISSION
========================= */
function openReportModal(targetType, targetId) {
    const isLoggedIn = "${sessionScope.userId != null}" === "true";
    if (!isLoggedIn) {
        alert('Please login to submit a report.');
        window.location.href = '${pageContext.request.contextPath}/login';
        return;
    }

    document.getElementById('reportTargetType').value = targetType;
    document.getElementById('reportTargetId').value = targetId;
    document.getElementById('reportModalTitle').innerText = targetType === 'post' ? 'Report Post' : 'Report Comment';
    document.getElementById('reportReason').value = 'TEXT';
    document.getElementById('reportDescription').value = '';

    const modal = document.getElementById('reportModal');
    if (modal) {
        modal.style.display = 'flex';
    }
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

    let path = type === 'post' ? ('/posts/report/' + id) : ('/comments/reports/report/' + id);

    fetch(getCleanUrl(path), {
        method: 'POST',
        headers: getCsrfHeaders('application/x-www-form-urlencoded'),
        body: 'reason=' + encodeURIComponent(reason) + '&description=' + encodeURIComponent(description)
    })
    .then(r => {
        return r.text().then(text => {
            return { ok: r.ok, status: r.status, text: text };
        });
    })
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
