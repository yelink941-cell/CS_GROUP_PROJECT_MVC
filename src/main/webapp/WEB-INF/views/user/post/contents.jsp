<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Sections - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-detail.css">
    
    <style>
        /* ============================================
           MANAGE SECTIONS - SAME COLORS AS CATEGORY
           ============================================ */
        
        * {
            box-sizing: border-box;
        }
        
        body {
            background: #f0f4f8;
        }
        
        .page-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }
        
        /* ===== PAGE HEADING ===== */
        .page-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 30px 0 20px;
            flex-wrap: wrap;
            gap: 16px;
            border-bottom: 2px solid #e8edf4;
            margin-bottom: 30px;
        }
        
        .page-heading h1 {
            font-size: 28px;
            font-weight: 800;
            color: #1e293b;
            margin: 0;
        }
        
        .page-heading h1::before {
            content: "📝 ";
        }
        
        .page-heading p {
            font-size: 15px;
            color: #64748b;
            margin: 4px 0 0 0;
        }
        
        .button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 24px;
            background: #4f46e5;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.25s ease;
            cursor: pointer;
        }
        
        .button:hover {
            background: #4338ca;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
        }
        
        .button-secondary {
            background: #f1f5f9;
            color: #1e293b;
            border: 1px solid #e2e8f0;
        }
        
        .button-secondary:hover {
            background: #e2e8f0;
            color: #0f172a;
            box-shadow: none;
            transform: translateY(-2px);
        }
        
        .button-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }
        
        .button-danger:hover {
            background: #fecaca;
            color: #7f1d1d;
            box-shadow: none;
            transform: translateY(-2px);
        }
        
        /* ===== CONTENT GRID ===== */
        .content-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 20px;
        }
        
        /* ===== CONTENT CARD ===== */
        .content-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px 26px 20px;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            transition: all 0.3s ease;
        }
        
        .content-card:hover {
            box-shadow: 0 8px 24px -6px rgba(0, 0, 0, 0.10);
            border-color: #c7d2fe;
        }
        
        .content-card-heading {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 14px;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .content-card-heading > div {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        .content-type-badge {
            background: #dbeafe;
            color: #1d4ed8;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .content-card-heading h2 {
            font-size: 18px;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
        }
        
        .sort-order {
            font-size: 13px;
            color: #94a3b8;
            background: #f1f5f9;
            padding: 4px 14px;
            border-radius: 20px;
            white-space: nowrap;
        }
        
        .sort-order::before {
            content: "🔢 ";
        }
        
        /* ===== CONTENT PREVIEW ===== */
        .content-preview {
            background: #f8fafc;
            border-radius: 10px;
            padding: 16px 18px;
            margin-bottom: 16px;
            border: 1px solid #f1f5f9;
            max-height: 200px;
            overflow-y: auto;
        }
        
        .content-preview pre {
            margin: 0;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            white-space: pre-wrap;
            word-wrap: break-word;
            color: #1e293b;
        }
        
        .content-preview code {
            font-family: 'Courier New', monospace;
            font-size: 13px;
            color: #1e293b;
        }
        
        .content-image {
            max-width: 100%;
            max-height: 180px;
            border-radius: 8px;
            object-fit: cover;
        }
        
        .content-video {
            max-width: 100%;
            max-height: 180px;
            border-radius: 8px;
        }
        
        .text-content {
            font-size: 14px;
            color: #475569;
            line-height: 1.7;
        }
        
        .table-content {
            font-family: 'Courier New', monospace;
            font-size: 13px;
            white-space: pre-wrap;
            word-wrap: break-word;
            color: #1e293b;
            margin: 0;
        }
        
        /* ===== CARD ACTIONS ===== */
        .card-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
        }
        
        /* ===== EMPTY STATE ===== */
        .empty-state {
            background: #ffffff;
            border-radius: 16px;
            padding: 60px 30px;
            text-align: center;
            border: 2px dashed #e2e8f0;
        }
        
        .empty-state .icon {
            font-size: 56px;
            display: block;
            margin-bottom: 14px;
        }
        
        .empty-state h2 {
            font-size: 22px;
            color: #1e293b;
            margin: 0 0 8px 0;
        }
        
        .empty-state h2::before {
            content: "📄 ";
        }
        
        .empty-state p {
            color: #64748b;
            font-size: 15px;
            margin: 0;
        }
        
        /* ===== PAGE FOOTER ===== */
        .page-footer-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f1f5f9;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        /* ===== FORM MESSAGE ===== */
        .form-message-error {
            background: #fee2e2;
            color: #991b1b;
            padding: 14px 20px;
            border-radius: 10px;
            border-left: 4px solid #ef4444;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .form-message-error::before {
            content: "❌ ";
        }
        
        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .page-container {
                padding: 0 14px 40px;
            }
            
            .page-heading {
                flex-direction: column;
                align-items: stretch;
                gap: 12px;
            }
            
            .page-heading h1 {
                font-size: 22px;
            }
            
            .content-card {
                padding: 18px;
            }
            
            .content-card-heading {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .content-card-heading > div {
                flex-direction: column;
                align-items: flex-start;
                gap: 6px;
            }
            
            .content-preview {
                max-height: 150px;
            }
            
            .card-actions {
                flex-wrap: wrap;
            }
            
            .button {
                padding: 8px 16px;
                font-size: 13px;
            }
        }
        
        @media (max-width: 480px) {
            .page-heading h1 {
                font-size: 18px;
            }
            
            .page-heading p {
                font-size: 13px;
            }
            
            .content-card-heading h2 {
                font-size: 16px;
            }
            
            .content-type-badge {
                font-size: 10px;
                padding: 3px 10px;
            }
            
            .content-preview {
                padding: 12px;
                max-height: 120px;
            }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container">
        <header class="page-heading">
            <div>
                <h1><c:out value="${post.title}" /></h1>
                <p>Build this cheat sheet with text, code, and uploaded image sections.</p>
            </div>
            <a class="button" href="${pageContext.request.contextPath}/user/posts/${post.id}/contents/new">➕ Add Section</a>
        </header>

        <c:if test="${not empty errorMessage}">
            <p class="form-message-error"><c:out value="${errorMessage}" /></p>
        </c:if>

        <c:if test="${empty contents}">
            <section class="empty-state">
                <span class="icon">📄</span>
                <h2>No sections yet</h2>
                <p>Add the first section to start building your cheat sheet.</p>
            </section>
        </c:if>

        <c:if test="${not empty contents}">
            <section class="content-grid" aria-label="Post content sections">
                <c:forEach var="content" items="${contents}">
                    <article class="content-card">
                        <div class="content-card-heading">
                            <div>
                                <span class="content-type-badge"><c:out value="${content.contentType}" /></span>
                                <h2>
                                    <c:choose>
                                        <c:when test="${not empty content.subtitle}">
                                            <c:out value="${content.subtitle}" />
                                        </c:when>
                                        <c:otherwise>Untitled Section</c:otherwise>
                                    </c:choose>
                                </h2>
                            </div>
                        </div>

                        <div class="content-preview">
                            <c:choose>
                                <c:when test="${content.contentType == 'CODE'}">
                                    <pre><code><c:out value="${content.contentData}" /></code></pre>
                                </c:when>
                                <c:when test="${content.contentType == 'IMAGE'}">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(content.contentData, '/')}">
                                            <img class="content-image" src="${pageContext.request.contextPath}${fn:escapeXml(content.contentData)}" alt="${fn:escapeXml(content.subtitle)}">
                                        </c:when>
                                        <c:otherwise>
                                            <img class="content-image" src="${fn:escapeXml(content.contentData)}" alt="${fn:escapeXml(content.subtitle)}">
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:when test="${content.contentType == 'VIDEO'}">
                                    <video class="content-video" controls src="${fn:escapeXml(content.contentData)}"></video>
                                </c:when>
                                <c:when test="${content.contentType == 'LINK'}">
                                    <a href="${fn:escapeXml(content.contentData)}" target="_blank" rel="noopener noreferrer">
                                        🔗 <c:out value="${content.contentData}" />
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-content"><c:out value="${content.contentData}" /></div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="card-actions">
                            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts/${post.id}/contents/edit/${content.id}">✏️ Edit</a>
                            <a class="button button-danger"
                               href="${pageContext.request.contextPath}/user/posts/${post.id}/contents/delete/${content.id}"
                               onclick="return confirm('Delete this section?');">🗑️ Delete</a>
                        </div>
                    </article>
                </c:forEach>
            </section>
        </c:if>

        <div class="page-footer-actions">
            <a class="button button-secondary" href="${pageContext.request.contextPath}/user/posts">← Back to My Posts</a>
        </div>
    </main>

</body>
</html>