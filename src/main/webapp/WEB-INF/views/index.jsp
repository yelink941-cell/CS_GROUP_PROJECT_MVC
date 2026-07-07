<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/post-list.css?v=8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css?v=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .home-main-content { 
            padding: 42px 20px 70px; 
            max-width: 1180px; 
            margin: 0 auto; 
            width: 100%;
        }
        
        .welcome-msg { 
            color: #0f766e; 
            background-color: #f0fdfa;
            border: 1px solid #ccfbf1;
            padding: 12px 20px;
            border-radius: 20px;
            margin-bottom: 24px;
            font-weight: 500;
        }

        .results-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            border: 1px solid #e2e8f0;
        }
        
        .result-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: #475569;
            font-weight: 700;
            padding-bottom: 8px;
            border-bottom: 2px solid #f1f5f9;
            margin-bottom: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .result-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 14px 16px;
            background: #f8fafc;
            border-radius: 10px;
            margin-bottom: 10px;
            border: 1px solid #e2e8f0;
            transition: all 0.2s ease;
            color: #1e293b;
        }
        .result-item:hover {
            background: #f1f5f9;
            transform: translateY(-1px);
        }
        .result-item a {
            color: #2563eb;
            text-decoration: none;
        }
        .result-item a:hover {
            text-decoration: underline;
        }
        .badge {
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 20px;
            background: #e2e8f0;
            color: #475569;
        }
        .clear-search-btn {
            display: inline-block;
            margin-top: 15px;
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        .clear-search-btn:hover {
            color: #0f172a;
            text-decoration: underline;
        }

        .hero-card {
            background: linear-gradient(135deg, #4038ff 0%, #6366f1 100%);
            color: white;
            padding: 45px 40px;
            border-radius: 24px;
            box-shadow: 0 10px 30px rgba(64, 56, 255, 0.25);
        }
        .hero-card h2 {
            margin: 0 0 12px 0;
            font-size: 28px;
            font-weight: 800;
            color: #ffffff;
        }
        .hero-card p {
            margin: 0;
            font-size: 16px;
            opacity: 0.9;
            line-height: 1.6;
            color: #ffffff;
        }
        .accent-label {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 16px;
            color: #ffffff;
        }

        .chat-fab {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: #4038ff;
            color: white;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            text-decoration: none;
            box-shadow: 0 6px 20px rgba(64, 56, 255, 0.4);
            transition: all 0.2s ease;
            z-index: 999;
            position: relative;
        }
        .chat-fab:hover {
            transform: scale(1.1) translateY(-3px);
            background: #312bc4;
        }
        .chat-fab-badge {
            position: absolute;
            top: -4px;
            right: -4px;
            background: #ef4444;
            color: white;
            font-size: 11px;
            font-weight: 700;
            min-width: 20px;
            height: 20px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #ffffff;
            box-shadow: 0 2px 6px rgba(239, 68, 68, 0.45);
            padding: 0 4px;
        }

        /* ============================================
           RELATED SEARCHES (Search History with Delete)
           ============================================ */
        .related-searches-section {
            background: #f5f3ff;
            border: 1px solid #ddd6fe;
            border-radius: 12px;
            padding: 20px 24px;
            margin-top: 25px;
        }
        
        .related-searches-section .section-title {
            color: #7c3aed;
            border-bottom-color: #ddd6fe;
        }
        
        .related-searches {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 14px;
        }
        
        .related-search-item {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 14px 8px 18px;
            background: white;
            color: #1e293b;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.25s ease;
        }
        
        .related-search-item:hover {
            border-color: #7c3aed;
            box-shadow: 0 2px 8px rgba(124, 58, 237, 0.1);
        }
        
        .related-search-item .search-link {
            color: #1e293b;
            text-decoration: none;
            cursor: pointer;
            background: none;
            border: none;
            font-size: 14px;
            font-weight: 500;
            padding: 0;
        }
        
        .related-search-item .search-link:hover {
            color: #7c3aed;
        }
        
        .related-search-item .delete-btn {
            color: #94a3b8;
            font-size: 13px;
            background: none;
            border: none;
            cursor: pointer;
            padding: 2px 6px;
            border-radius: 50%;
            transition: all 0.2s;
            line-height: 1;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .related-search-item .delete-btn:hover {
            color: #ef4444;
            background: #fee2e2;
        }
        
        .related-empty {
            color: #94a3b8;
            font-size: 14px;
            font-style: italic;
            padding: 10px 0;
        }
        
        .related-empty .icon {
            font-size: 24px;
        }
        
        .delete-history-form {
            display: inline;
            margin: 0;
            padding: 0;
        }
        
        .alert-success {
            background: #dcfce7;
            color: #16a34a;
            padding: 12px 18px;
            border-radius: 8px;
            margin-bottom: 16px;
            border-left: 4px solid #16a34a;
        }
        
        .alert-error {
            background: #fee2e2;
            color: #dc2626;
            padding: 12px 18px;
            border-radius: 8px;
            margin-bottom: 16px;
            border-left: 4px solid #dc2626;
        }
        
        /* Search Suggestion Colors */
        .suggestion-item .highlight {
            color: #f59e0b;
            font-weight: 700;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container home-main-content">
        
        <c:if test="${not empty successMessage}">
            <div class="alert-success">✅ ${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert-error">❌ ${errorMessage}</div>
        </c:if>
        
        <c:if test="${not empty message}">
            <div class="welcome-msg">
                <c:out value="${message}"/>
            </div>
        </c:if>

        <c:choose>
            <%-- CONDITION A: INLINE SEARCH RESULTS VIEW SCREEN --%>
            <c:when test="${isSearching}">
                <div class="results-container">
                    <h3 style="color: #0f172a; font-size: 20px; margin-bottom: 20px;">
                        Search Results for "<span style="color: #2563eb;">${searchedKeyword}</span>"
                    </h3>
                    
                    <%-- 1. Cheat Sheets (Posts) Section --%>
                    <div class="result-section">
                        <div class="section-title" style="color: #2563eb; border-bottom: 2px solid #dbeafe;">📄 Cheat Sheets</div>
                        <c:choose>
                            <c:when test="${not empty postResults}">
                                <c:forEach var="p" items="${postResults}">
                                    <div class="result-item">
                                        <div>
                                            <a href="${pageContext.request.contextPath}/posts/${p.slug}" 
                                               style="color: #2563eb; font-weight: 600; font-size: 16px;">
                                                <c:out value="${p.title}" />
                                            </a>
                                            <div style="font-size: 13px; color: #64748b; margin-top: 4px;">
                                                <c:out value="${not empty p.excerpt ? p.excerpt : 'No description available.'}" />
                                            </div>
                                        </div>
                                        <span class="badge" style="background: #dbeafe; color: #2563eb;">CheatSheet</span>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="padding: 10px; color: #64748b;">No cheat sheets found.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- 2. Folders Section --%>
                    <c:if test="${not empty collectionResults}">
                        <div class="result-section">
                            <div class="section-title" style="color: #d97706; border-bottom: 2px solid #fef3c7;">📁 Folders (Collections)</div>
                            <c:forEach var="col" items="${collectionResults}">
                                <div class="result-item">
                                    <div>
                                        <a href="${pageContext.request.contextPath}/user/collections/view?id=${col.id}" 
                                           style="color: #d97706; font-weight: 600; font-size: 16px;">
                                            📁 <c:out value="${col.name}" />
                                        </a>
                                        <div style="font-size: 13px; color: #64748b; margin-top: 4px;">Created by: @${col.user.username}</div>
                                    </div>
                                    <span class="badge" style="background: #fef3c7; color: #d97706;">Folder</span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    
                    <%-- 3. Categories Section --%>
                    <c:if test="${not empty categoryResults}">
                        <div class="result-section">
                            <div class="section-title">📁 Categories</div>
                            <c:forEach var="cat" items="${categoryResults}">
                                <div class="result-item">
                                    <div>
                                   <a href="${pageContext.request.contextPath}/categories/${cat.id}" style="color: #d97706; font-weight: 600; font-size: 15px; text-decoration: none;">📁 <c:out value="${cat.name}"/></a>
                                        <div style="font-size: 13px; color: #64748b; margin-top: 4px;"><c:out value="${cat.description}"/></div>
                                    </div>
                                    <span class="badge">Category</span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <%-- 4. Users Section (Fixed to correctly route to public views) --%>
                    <c:if test="${not empty userResults}">
                        <div class="result-section">
                            <div class="section-title">👥 Users</div>
                            <c:forEach var="u" items="${userResults}">
                                <div class="result-item">
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.currentUser}">
                                                <%-- 🔗 Pointing to the specific public view mapping --%>
                                                <a href="${pageContext.request.contextPath}/profile/view?id=${u.id}" 
                                                   style="color: #0f766e; font-weight: 600;">
                                                    @<c:out value="${u.username}"/>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #1e293b; font-weight: 600;">
                                                    @<c:out value="${u.username}"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span style="color: #64748b; font-size: 13px; margin-left: 6px;">(<c:out value="${u.email}"/>)</span>
                                    </div>
                                    <span class="badge" style="background: #e0f2fe; color: #0284c7;">User</span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <%-- ✅ 5. RELATED SEARCHES (Search History with Delete - STAY ON PAGE) --%>
                    <div class="related-searches-section">
                        <div class="section-title">
                            <span>🔄 Related Searches</span>
                            <span style="font-size: 12px; color: #94a3b8; font-weight: 400;">
                                ${searchHistory != null ? searchHistory.size() : 0} searches
                            </span>
                        </div>
                        
                        <c:choose>
                            <c:when test="${not empty searchHistory}">
                                <div class="related-searches">
                                    <c:forEach var="history" items="${searchHistory}">
                                        <div class="related-search-item">
                                            <%-- Search Link --%>
                                            <form action="${pageContext.request.contextPath}/doSearch" method="POST" style="display: inline;">
                                                <input type="hidden" name="keyword" value="${history.keyword}" />
                                                <button type="submit" class="search-link">
                                                    🔍 ${history.keyword}
                                                </button>
                                            </form>
                                            
                                            <%-- Delete Button - ✅ STAY ON SEARCH RESULTS PAGE --%>
                                            <form action="${pageContext.request.contextPath}/history/delete" method="GET" class="delete-history-form">
                                                <input type="hidden" name="id" value="${history.id}" />
                                                <input type="hidden" name="keyword" value="${searchedKeyword}" />
                                                <button type="submit" class="delete-btn" 
                                                        onclick="return confirm('Delete this search history?')" 
                                                        title="Delete this search">
                                                    ✕
                                                </button>
                                            </form>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="related-empty">
                                    <span class="icon">🔍</span>
                                    No related searches found. Start searching to see related queries here.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%-- Fallback Layout --%>
                    <c:if test="${empty postResults && empty collectionResults && empty categoryResults && empty userResults}">
                        <div style="background: #f8fafc; padding: 40px; text-align: center; border-radius: 16px; color: #64748b; border: 1px solid #e2e8f0; margin-top: 20px;">
                            <span style="font-size: 48px; display: block; margin-bottom: 10px;">🔍</span>
                            No matching results found for "<strong>${searchedKeyword}</strong>".
                        </div>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/" class="clear-search-btn">← Clear search results</a>
                </div>
            </c:when>

            <%-- CONDITION B: UNIFIED HOME SCREEN LAYOUT --%>
            <c:otherwise>
               <section style="background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%); color: white; padding: 60px 40px; border-radius: 24px; position: relative; overflow: hidden; margin-bottom: 30px; box-shadow: 0 20px 25px -5px rgba(79, 70, 229, 0.2);">
    
    <!-- Decorator circles for modern look -->
   <!-- ညာဘက်အပေါ်ထောင့် အဝိုင်း (Screen အစွန်းထိ ရောက်အောင်) -->
    <div style="position: absolute; top: -50px; right: -50px; width: 250px; height: 250px; background: rgba(255,255,255,0.15); border-radius: 50%; pointer-events: none;"></div>
    
    <!-- ဘယ်ဘက်အောက်ထောင့် အဝိုင်း (Screen အစွန်းထိ ရောက်အောင်) -->
    <div style="position: absolute; bottom: -80px; left: -50px; width: 200px; height: 200px; background: rgba(0,0,0,0.1); border-radius: 50%; pointer-events: none;"></div>

    <!-- ကျန်တဲ့ Content တွေ ဒီနေရာမှာ ထည့်ပါ -->
    <div style="position: relative; z-index: 1;">
        <!-- Content -->
    </div>
    <c:choose>
        <c:when test="${not empty sessionScope.currentUser}">
            <div style="max-width: 700px; position: relative; z-index: 1;">
                <span style="background: rgba(255,255,255,0.2); padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;">Dashboard Active</span>
                <h2 style="font-size: 40px; margin: 20px 0;">Welcome back, <c:out value="${sessionScope.currentUser.username}"/> &#128075;</h2>
                <p style="font-size: 1.1rem; opacity: 0.9; line-height: 1.6; margin-bottom: 25px;">
                    Explore categories, discover popular cheat sheets, and continue learning from community-approved guides. You can now manage your private notes easily.
                </p>
                <a href="${pageContext.request.contextPath}/notes" style="display: inline-flex; align-items: center; gap: 8px; padding: 12px 24px; background: white; color: #4f46e5; text-decoration: none; border-radius: 12px; font-weight: 700; font-size: 15px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);">
                    📝 My Private Notes
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <div style="max-width: 700px; position: relative; z-index: 1;">
                <span style="background: rgba(255,255,255,0.2); padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;">Public Library</span>
                <h2 style="font-size: 40px; margin: 20px 0;">Explore Cheat Sheets</h2>
                <p style="font-size: 1.2rem; opacity: 0.9; line-height: 1.6;">
                    Simple, practical guides created by the community and approved for everyone. Start your learning journey today.
                </p>
            </div>
        </c:otherwise>
    </c:choose>
</section>

                <section class="home-section">
                    <div class="home-section-header">
                        <div>
                            <span class="section-kicker">Browse Topics</span>
                            <h2>Categories</h2>
                        </div>
                        <a href="${pageContext.request.contextPath}/posts/categories">View all categories</a>
                    </div>

                    <c:choose>
                        <c:when test="${not empty categorySummaries}">
                            <div class="category-grid">
                                <c:forEach var="summary" items="${categorySummaries}">
                                    <c:set var="category" value="${summary[0]}" />
                                    <c:set var="postCount" value="${summary[1]}" />
                                    <a class="category-card" href="${pageContext.request.contextPath}/categories/${category.id}">
                                        <span class="category-count"><c:out value="${postCount}" /> posts</span>
                                        <h3><c:out value="${category.name}" /></h3>
                                        <p>
                                            <c:choose>
                                                <c:when test="${not empty category.description}">
                                                    <c:out value="${category.description}" />
                                                </c:when>
                                                <c:otherwise>Explore public cheat sheets from this category.</c:otherwise>
                                            </c:choose>
                                        </p>
                                    </a>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="home-empty">No categories are available yet.</div>
                        </c:otherwise>
                    </c:choose>
                </section>

              <section style="padding: 40px 20px; background: #ffffff; border-radius: 20px; margin-top: 20px;">
    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px;">
        <div>
            <span style="color: #8b5cf6; font-weight: 600; font-size: 14px; letter-spacing: 0.5px; text-transform: uppercase;">
                Most Viewed
            </span>
            <h2 style="margin: 5px 0 0 0; color: #1e293b; font-size: 28px;">
                <span style="background: linear-gradient(135deg, #8b5cf6, #6d28d9); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    Popular Posts
                </span>
            </h2>
        </div>
        <a href="${pageContext.request.contextPath}/posts/popular" style="color: #7c3aed; text-decoration: none; font-weight: 600; font-size: 14px;">
            See more →
        </a>
    </div>

    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px;">
        <c:choose>
            <c:when test="${not empty popularPosts}">
                <c:forEach var="post" items="${popularPosts}">
                    <article style="background: #f8fafc; padding: 24px; border-radius: 16px; border: 1px solid #e2e8f0; display: flex; flex-direction: column;">
                        <span style="font-size: 11px; background: #ede9fe; color: #7c3aed; padding: 4px 10px; border-radius: 12px; font-weight: 700; align-self: flex-start; margin-bottom: 10px;">
                            <c:out value="${post.category.name}" />
                        </span>
                        
                        <h3 style="margin: 0 0 10px 0; color: #1e293b; font-size: 1.25rem;">
                            <c:out value="${post.title}" />
                        </h3>
                        
                        <p style="margin: 0 0 20px 0; color: #64748b; font-size: 0.9rem; line-height: 1.5; flex-grow: 1;">
                            <c:out value="${empty post.excerpt ? 'No excerpt available.' : post.excerpt}" />
                        </p>
                        
                        <div style="display: flex; justify-content: space-between; font-size: 0.8rem; color: #94a3b8; margin-bottom: 15px;">
                            <span>By <c:out value="${empty post.author ? '-' : post.author.username}" /></span>
                            <span>👁️ <c:out value="${empty post.viewCount ? 0 : post.viewCount}" /></span>
                        </div>
                        
                        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #e2e8f0; pt: 15px;">
                            <small style="color: #94a3b8;"><c:out value="${post.createdAt}" /></small>
                            <a href="${pageContext.request.contextPath}/posts/${post.slug}" style="color: #7c3aed; text-decoration: none; font-weight: 600; font-size: 0.9rem;">Read More →</a>
                        </div>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="grid-column: 1/-1; padding: 40px; text-align: center; color: #94a3b8;">
                    No popular posts are available yet.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

                <section style="padding: 40px 20px; background: #ffffff; border-radius: 20px; margin-top: 20px;">
    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px;">
        <div>
            <span style="color: #e11d48; font-weight: 600; font-size: 14px; letter-spacing: 0.5px; text-transform: uppercase;">
                Last 30 Days
            </span>
            <h2 style="margin: 5px 0 0 0; color: #1e293b; font-size: 28px;">
                <span style="background: linear-gradient(135deg, #e11d48, #9f1239); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    Trending Posts
                </span>
            </h2>
        </div>
        <a href="${pageContext.request.contextPath}/posts/trending" style="color: #e11d48; text-decoration: none; font-weight: 600; font-size: 14px;">
            See more →
        </a>
    </div>

    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px;">
        <c:choose>
            <c:when test="${not empty trendingPosts}">
                <c:forEach var="post" items="${trendingPosts}">
                    <article style="background: #fff1f2; padding: 24px; border-radius: 16px; border: 1px solid #fda4af; display: flex; flex-direction: column;">
                        <span style="font-size: 11px; background: #fecdd3; color: #9f1239; padding: 4px 10px; border-radius: 12px; font-weight: 700; align-self: flex-start; margin-bottom: 10px;">
                            <c:out value="${post.category.name}" />
                        </span>
                        
                        <h3 style="margin: 0 0 10px 0; color: #1e293b; font-size: 1.25rem;">
                            <c:out value="${post.title}" />
                        </h3>
                        
                        <p style="margin: 0 0 20px 0; color: #64748b; font-size: 0.9rem; line-height: 1.5; flex-grow: 1;">
                            <c:out value="${empty post.excerpt ? 'No excerpt available.' : post.excerpt}" />
                        </p>
                        
                        <div style="display: flex; justify-content: space-between; font-size: 0.8rem; color: #94a3b8; margin-bottom: 15px;">
                            <span>By <c:out value="${empty post.author ? '-' : post.author.username}" /></span>
                            <span>🔥 <c:out value="${empty post.viewCount ? 0 : post.viewCount}" /> views</span>
                        </div>
                        
                        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #fda4af; padding-top: 15px;">
                            <small style="color: #94a3b8;"><c:out value="${post.createdAt}" /></small>
                            <a href="${pageContext.request.contextPath}/posts/${post.slug}" style="color: #e11d48; text-decoration: none; font-weight: 600; font-size: 0.9rem;">Read More →</a>
                        </div>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="grid-column: 1/-1; padding: 40px; text-align: center; color: #94a3b8;">
                    No trending posts are available yet.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>
                <section style="padding: 40px 20px; background: #ffffff; border-radius: 20px; margin-top: 20px;">
    <!-- Header -->
    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px;">
        <div>
            <span style="color: #0284c7; font-weight: 600; font-size: 14px; letter-spacing: 0.5px; text-transform: uppercase;">
                Fresh Guides
            </span>
            <h2 style="margin: 5px 0 0 0; color: #1e293b; font-size: 28px;">
                <span style="background: linear-gradient(135deg, #0284c7, #0369a1); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    New Posts
                </span>
            </h2>
        </div>
        <a href="${pageContext.request.contextPath}/posts/new" style="color: #0284c7; text-decoration: none; font-weight: 600; font-size: 14px;">
            See more →
        </a>
    </div>

    <!-- Grid -->
    <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px;">
        <c:choose>
            <c:when test="${not empty newPosts}">
                <c:forEach var="post" items="${newPosts}">
                    <article style="background: #f0f9ff; padding: 24px; border-radius: 16px; border: 1px solid #bae6fd; display: flex; flex-direction: column;">
                        <span style="font-size: 11px; background: #e0f2fe; color: #0369a1; padding: 4px 10px; border-radius: 12px; font-weight: 700; align-self: flex-start; margin-bottom: 10px;">
                            <c:out value="${post.category.name}" />
                        </span>
                        
                        <h3 style="margin: 0 0 10px 0; color: #1e293b; font-size: 1.25rem;">
                            <c:out value="${post.title}" />
                        </h3>
                        
                        <p style="margin: 0 0 20px 0; color: #64748b; font-size: 0.9rem; line-height: 1.5; flex-grow: 1;">
                            <c:out value="${empty post.excerpt ? 'No excerpt available.' : post.excerpt}" />
                        </p>
                        
                        <div style="display: flex; justify-content: space-between; font-size: 0.8rem; color: #94a3b8; margin-bottom: 15px;">
                            <span>By <c:out value="${empty post.author ? '-' : post.author.username}" /></span>
                            <span>✨ <c:out value="${empty post.viewCount ? 0 : post.viewCount}" /> views</span>
                        </div>
                        
                        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #bae6fd; padding-top: 15px;">
                            <small style="color: #94a3b8;"><c:out value="${post.createdAt}" /></small>
                            <a href="${pageContext.request.contextPath}/posts/${post.slug}" style="color: #0284c7; text-decoration: none; font-weight: 600; font-size: 0.9rem;">Read More →</a>
                        </div>
                    </article>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="grid-column: 1/-1; padding: 40px; text-align: center; color: #94a3b8;">
                    No new posts are available yet.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- ===== FOOTER - DARK THEME (SAME AS POPULAR.JSP STYLE) ===== -->
<footer class="site-footer">
    <div class="footer-container">
        <div class="footer-brand">
            <h2>📚 CheatSheet Hub</h2>
            <p>Community-built cheat sheets for quick learning, practical references, and clean knowledge sharing. Your go-to resource for developer guides and technical references.</p>
        </div>
        <div class="footer-links">
            <h3>Quick Links</h3>
            <nav>
                <a href="${pageContext.request.contextPath}/">🏠 Home</a>
                <a href="${pageContext.request.contextPath}/posts/public">📄 View Posts</a>
                <a href="${pageContext.request.contextPath}/posts/categories">📁 Categories</a>
                <a href="${pageContext.request.contextPath}/posts/popular">🔥 Popular</a>
                <a href="${pageContext.request.contextPath}/posts/trending">📈 Trending</a>
            </nav>
        </div>
       
    </div>
    <div class="footer-bottom">
        <small>&copy; 2026 CheatSheet Hub. All rights reserved.</small>
        <div class="footer-legal">
            <a href="#"><i class="fas fa-lock"></i> Privacy Policy</a>
            <a href="#"><i class="fas fa-file-contract"></i> Terms of Service</a>
            <a href="#"><i class="fas fa-envelope"></i> Contact</a>
        </div>
    </div>
</footer>

    <c:if test="${not empty sessionScope.currentUser}">
        <a href="${pageContext.request.contextPath}/chat" class="chat-fab" title="Messages" style="position:fixed; bottom:30px; right:30px;">
            💬
            <c:if test="${totalUnreadChatCount > 0}">
                <span class="chat-fab-badge">
                    <c:choose>
                        <c:when test="${totalUnreadChatCount > 99}">99+</c:when>
                        <c:otherwise>${totalUnreadChatCount}</c:otherwise>
                    </c:choose>
                </span>
            </c:if>
        </a>
    </c:if>

</body>
</html>