<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trending Today - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=7">
    
    <style>
        /* ============================================
           TRENDING PAGE - SAME COLORS AS CATEGORY
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
        .library-header {
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
        
        .library-header::before {
            content: '';
            position: absolute;
            top: -60%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 50%;
        }
        
        .library-header::after {
            content: '';
            position: absolute;
            bottom: -50%;
            left: -5%;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 50%;
        }
        
        .library-header .header-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .library-header .header-icon {
            font-size: 48px;
            display: block;
            margin-bottom: 12px;
        }
        
        .library-header span {
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 3px;
            opacity: 0.7;
            display: block;
            margin-bottom: 8px;
            color: #c7d2fe;
        }
        
        .library-header h1 {
            font-size: 40px;
            font-weight: 800;
            margin: 0 0 12px 0;
            color: #ffffff;
            letter-spacing: -0.5px;
        }
        
        .library-header h1 span {
            background: rgba(255, 255, 255, 0.12);
            padding: 4px 16px;
            border-radius: 12px;
            display: inline-block;
            letter-spacing: 0;
            text-transform: none;
            font-size: 40px;
        }
        
        .library-header p {
            font-size: 18px;
            opacity: 0.85;
            margin: 0;
            color: #c7d2fe;
            line-height: 1.6;
        }
        
        /* ===== POST GRID ===== */
        .library-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 24px;
            margin-top: 35px;
        }
        
        /* ===== POST CARD ===== */
        .library-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            border: 1px solid #e8edf4;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }
        
        .library-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 32px -8px rgba(0, 0, 0, 0.12);
            border-color: #c7d2fe;
        }
        
        .library-card .card-content {
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        
        .library-card .card-topline {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        
        .library-card .category-label {
            background: #dbeafe;
            color: #1d4ed8;
            padding: 4px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .library-card .metric-label {
            font-size: 12px;
            color: #94a3b8;
            font-weight: 500;
        }
        
        .library-card .metric-label::before {
            content: "🔥 ";
        }
        
        .library-card .card-title {
            font-size: 20px;
            font-weight: 700;
            color: #1e293b;
            text-decoration: none;
            margin: 0 0 8px 0;
            line-height: 1.3;
            transition: color 0.2s;
        }
        
        .library-card .card-title:hover {
            color: #4f46e5;
        }
        
        .library-card .card-excerpt {
            font-size: 14px;
            color: #64748b;
            line-height: 1.6;
            margin: 0 0 16px 0;
            flex: 1;
        }
        
        .library-card .card-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 16px;
        }
        
        .library-card .card-tags span {
            background: #f1f5f9;
            color: #475569;
            padding: 2px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .library-card .card-tags span::before {
            content: "#";
        }
        
        .library-card .card-meta {
            display: flex;
            align-items: center;
            gap: 12px;
            padding-top: 14px;
            border-top: 1px solid #f1f5f9;
            margin-bottom: 16px;
        }
        
        .library-card .author-initial {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #4f46e5;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            flex-shrink: 0;
        }
        
        .library-card .card-meta strong {
            font-size: 14px;
            color: #1e293b;
            display: block;
        }
        
        .library-card .card-meta small {
            font-size: 12px;
            color: #94a3b8;
        }
        
        .library-card .read-link {
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
            margin-top: auto;
        }
        
        .library-card .read-link:hover {
            background: #4f46e5;
            color: white;
            border-color: #4f46e5;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(79, 70, 229, 0.3);
        }
        
        .library-card .read-link span {
            transition: transform 0.25s;
        }
        
        .library-card .read-link:hover span {
            transform: translateX(6px);
        }
        
        /* ===== TRENDING RANK BADGE ===== */
        .trending-rank {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #fef3c7;
            color: #92400e;
            padding: 2px 12px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 700;
        }
        
        .trending-rank.top1 { background: #fcd34d; color: #78350f; }
        .trending-rank.top2 { background: #e2e8f0; color: #475569; }
        .trending-rank.top3 { background: #fed7aa; color: #9a3412; }
        
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
            content: "🔥 ";
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
            
            .library-header {
                padding: 40px 16px 35px;
            }
            
            .library-header h1 {
                font-size: 28px;
            }
            
            .library-header h1 span {
                font-size: 28px;
            }
            
            .library-header p {
                font-size: 15px;
            }
            
            .library-grid {
                grid-template-columns: 1fr;
                gap: 18px;
            }
            
            .library-card {
                padding: 20px;
            }
            
            .library-card .card-title {
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
            .library-header {
                padding: 30px 14px 25px;
            }
            
            .library-header h1 {
                font-size: 22px;
            }
            
            .library-header h1 span {
                font-size: 22px;
            }
            
            .library-header .header-icon {
                font-size: 32px;
            }
            
            .library-header p {
                font-size: 13px;
            }
            
            .library-card .card-topline {
                flex-direction: column;
                align-items: flex-start;
                gap: 6px;
            }
        }
    </style>
</head>
<body class="public-list-page">

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main>
        
        <!-- ===== HERO - FULL WIDTH (SAME AS CATEGORY) ===== -->
        <header class="library-header">
            <div class="header-content">
                <span class="header-icon">🔥</span>
                <span>Today's activity</span>
                <h1><span>Trending Cheat Sheets</span></h1>
                <p>Public guides receiving the most reader attention today.</p>
            </div>
        </header>

        <div class="page-container">
            
            <!-- ===== POST LIST ===== -->
            <c:if test="${empty trendingPosts}">
                <section class="empty-state">
                    <span class="icon">🔥</span>
                    <h2>No trending posts yet</h2>
                    <p>Today's trending list will appear after public posts receive views.</p>
                </section>
            </c:if>

            <c:if test="${not empty trendingPosts}">
                <section class="library-grid" aria-label="Trending posts">
                    <c:forEach var="item" items="${trendingPosts}" varStatus="loop">
                        <c:set var="post" value="${item.post}" />
                        <c:url var="detailsUrl" value="/posts/${post.slug}" />
                        <article class="library-card">
                            <div class="card-content">
                                <div class="card-topline">
                                    <span class="category-label"><c:out value="${post.category.name}" /></span>
                                    <span class="metric-label"><c:out value="${item.todayViewCount}" /> views today</span>
                                </div>

                                <a class="card-title" href="${detailsUrl}"><c:out value="${post.title}" /></a>
                                <p class="card-excerpt">
                                    <c:choose>
                                        <c:when test="${not empty post.excerpt}"><c:out value="${post.excerpt}" /></c:when>
                                        <c:otherwise>A concise guide designed for quick reference.</c:otherwise>
                                    </c:choose>
                                </p>

                                <c:if test="${not empty post.tags}">
                                    <div class="card-tags">
                                        <c:forEach var="tag" items="${post.tags}">
                                            <span><c:out value="${tag.name}" /></span>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <div class="card-meta">
                                    <span class="author-initial"><c:out value="${fn:substring(post.author.username, 0, 1)}" /></span>
                                    <div>
                                        <strong><c:out value="${post.author.username}" /></strong>
                                        <small>
                                            <span class="trending-rank 
                                                <c:if test="${loop.count == 1}">top1</c:if>
                                                <c:if test="${loop.count == 2}">top2</c:if>
                                                <c:if test="${loop.count == 3}">top3</c:if>
                                            ">
                                                #${loop.count} trending
                                            </span>
                                        </small>
                                    </div>
                                </div>

                                <a class="read-link" href="${detailsUrl}">Read cheat sheet <span>→</span></a>
                            </div>
                        </article>
                    </c:forEach>
                </section>
            </c:if>
            
        </div>
        
    </main>

</body>
</html>