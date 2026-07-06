<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cheat Sheets by Tag - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css">
    
    <style>
        /* ============================================
           TAG PAGE - SAME COLORS AS CATEGORY
           ============================================ */
        
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            background: #f0f4f8;
        }
        
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px 60px;
        }
        
        /* ===== HERO / HEADER - FULL WIDTH (SAME AS CATEGORY) ===== */
        .hero {
            width: 100vw;
            margin-left: calc(-50vw + 50%);
            padding: 60px 20px 50px;
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #4f46e5 100%);
            color: white;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 30px rgba(79, 70, 229, 0.25);
        }
        
        .hero::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
        }
        
        .hero::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 50%;
        }
        
        .hero .hero-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .hero .hero-icon {
            font-size: 48px;
            display: block;
            margin-bottom: 12px;
        }
        
        .hero h1 {
            font-size: 40px;
            font-weight: 800;
            margin: 0 0 12px 0;
            color: #ffffff;
            letter-spacing: -0.5px;
        }
        
        .hero h1 span {
            background: rgba(255, 255, 255, 0.12);
            padding: 4px 16px;
            border-radius: 12px;
            display: inline-block;
        }
        
        .hero p {
            font-size: 18px;
            opacity: 0.85;
            margin: 0;
            color: #c7d2fe;
            line-height: 1.6;
        }
        
        /* ===== TAG GRID ===== */
        .post-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
            margin-top: 35px;
        }
        
        /* ===== TAG CARD ===== */
        .post-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 28px 24px 30px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
        
        .post-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px -8px rgba(0, 0, 0, 0.12);
            border-color: #c7d2fe;
        }
        
        .post-card .card-top {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 10px;
        }
        
        .post-card .card-top .icon {
            font-size: 32px;
            flex-shrink: 0;
            background: #f0f4ff;
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .post-card .card-top .icon.has-posts {
            background: #4f46e5;
            color: white;
        }
        
        .post-card h2 {
            font-size: 19px;
            font-weight: 700;
            color: #1e293b;
            margin: 0;
            line-height: 1.3;
        }
        
        .post-card h2 .hash {
            color: #4f46e5;
            margin-right: 2px;
        }
        
        .post-card .post-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 13px;
            color: #94a3b8;
            margin-bottom: 16px;
            padding-top: 12px;
            border-top: 1px solid #f1f5f9;
        }
        
        .post-card .post-meta .count-badge {
            background: #f1f5f9;
            color: #475569;
            padding: 2px 16px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 13px;
        }
        
        .post-card .post-meta .count-badge.has-posts {
            background: #4f46e5;
            color: white;
        }
        
        .post-card .card-actions {
            margin-top: auto;
        }
        
        .post-card .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 11px 24px;
            background: #f1f5f9;
            color: #1e293b;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            cursor: pointer;
            width: 100%;
        }
        
        .post-card .button:hover {
            background: #4f46e5;
            color: white;
            border-color: #4f46e5;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
        }
        
        .post-card .button::after {
            content: "→";
            transition: transform 0.25s;
        }
        
        .post-card .button:hover::after {
            transform: translateX(6px);
        }
        
        /* ===== EMPTY STATE ===== */
        .empty-state {
            background: #ffffff;
            border-radius: 16px;
            padding: 60px 30px;
            text-align: center;
            border: 2px dashed #e2e8f0;
            margin-top: 35px;
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
            content: "🏷️ ";
        }
        
        .empty-state p {
            color: #64748b;
            font-size: 15px;
            margin: 0;
        }
        
        /* ===== VIEW ALL LINK ===== */
        .view-all-section {
            text-align: center;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #e8edf4;
        }
        
        .view-all-section a {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 40px;
            background: #4f46e5;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .view-all-section a:hover {
            background: #4338ca;
            transform: translateY(-3px);
            box-shadow: 0 8px 28px rgba(79, 70, 229, 0.35);
        }
        
        /* ===== RESPONSIVE ===== */
        @media (max-width: 768px) {
            .page-container {
                padding: 0 14px 40px;
            }
            
            .hero {
                padding: 40px 16px 35px;
            }
            
            .hero h1 {
                font-size: 28px;
            }
            
            .hero p {
                font-size: 15px;
            }
            
            .post-grid {
                grid-template-columns: 1fr;
                gap: 18px;
            }
            
            .post-card {
                padding: 20px 18px 22px;
            }
            
            .post-card .card-top {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .post-card .card-top .icon {
                width: 44px;
                height: 44px;
                font-size: 24px;
            }
            
            .post-card h2 {
                font-size: 17px;
            }
            
            .view-all-section a {
                padding: 12px 24px;
                font-size: 14px;
                width: 100%;
                justify-content: center;
            }
        }
        
        @media (max-width: 480px) {
            .hero {
                padding: 30px 14px 25px;
            }
            
            .hero h1 {
                font-size: 22px;
            }
            
            .hero .hero-icon {
                font-size: 32px;
            }
            
            .hero p {
                font-size: 13px;
            }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main>
        
        <!-- ===== HERO - FULL WIDTH (SAME AS CATEGORY) ===== -->
        <div class="hero">
            <div class="hero-content">
                <span class="hero-icon">🏷️</span>
                <h1><span>Cheat Sheets by Tag</span></h1>
                <p>Choose a tag to browse related published public cheat sheets.</p>
            </div>
        </div>

        <div class="page-container">
            
            <!-- ===== TAG LIST ===== -->
            <c:if test="${empty tagSummaries}">
                <div class="empty-state">
                    <span class="icon">🏷️</span>
                    <h2>No tags found</h2>
                    <p>No tags currently contain public published posts.</p>
                </div>
            </c:if>

            <c:if test="${not empty tagSummaries}">
                <section class="post-grid" aria-label="Public post tags">
                    <c:forEach var="summary" items="${tagSummaries}">
                        <c:set var="postCount" value="${summary[1]}" />
                        <article class="post-card">
                            <div class="card-top">
                                <span class="icon ${postCount > 0 ? 'has-posts' : ''}">🏷️</span>
                                <h2><span class="hash">#</span><c:out value="${summary[0].name}" /></h2>
                            </div>
                            <!-- ✅ description ကိုဖယ်လိုက်ပါ -->
                            <div class="post-meta">
                                <span>📄</span>
                                <span><c:out value="${postCount}" /> post<c:if test="${postCount > 1}">s</c:if></span>
                                <span class="count-badge ${postCount > 0 ? 'has-posts' : ''}">
                                    <c:out value="${postCount}" />
                                </span>
                            </div>
                            <div class="card-actions">
                                <a class="button" href="${pageContext.request.contextPath}/posts/tags/${summary[0].id}">View Tag</a>
                            </div>
                        </article>
                    </c:forEach>
                </section>
                
            </c:if>
            
        </div>
        
    </main>

</body>
</html>