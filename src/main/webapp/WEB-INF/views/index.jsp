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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* FIXED: Kept layout styling clean without overriding system global body rules */
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

        /* Search Results Layout Styling */
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
            color: #64748b;
            font-weight: 700;
            padding-bottom: 8px;
            border-bottom: 2px solid #f1f5f9;
            margin-bottom: 14px;
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
        }
        .result-item:hover {
            background: #f1f5f9;
            transform: translateY(-1px);
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

        /* Home Layout Main Banner Styling */
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
        }
        .hero-card p {
            margin: 0;
            font-size: 16px;
            opacity: 0.9;
            line-height: 1.6;
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
        }

        /* Floating Action Chat Button */
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
        }
        .chat-fab:hover {
            transform: scale(1.1) translateY(-3px);
            background: #312bc4;
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container home-main-content">
        
        <c:if test="${not empty message}">
            <div class="welcome-msg">
                <c:out value="${message}"/>
            </div>
        </c:if>

        <c:choose>
            <%-- CONDITION A: INLINE SEARCH RESULTS VIEW SCREEN --%>
            <c:when test="${isSearching}">
                <div class="results-container">
                    <h3 style="color: #0f172a; font-size: 20px; margin-bottom: 20px;">Search Results for "${searchedKeyword}"</h3>
                    
                    <%-- 1. Cheat Sheets (Posts) Section --%>
                    <div class="result-section">
                        <div class="section-title" style="color: #4038ff; border-bottom: 2px solid #f3f1ff;">&#128196; Cheat Sheets</div>
                        <c:choose>
                            <c:when test="${not empty postResults}">
                                <c:forEach var="p" items="${postResults}">
                                    <div class="result-item">
                                        <div>
                                            <a href="${pageContext.request.contextPath}/posts/${p.slug}" 
                                               style="text-decoration: none; color: #4038ff; font-weight: 700; font-size: 16px;"
                                               onmouseover="this.style.textDecoration='underline'" 
                                               onmouseout="this.style.textDecoration='none'">
                                                <c:out value="${p.title}" />
                                            </a>
                                            <div style="font-size: 13px; color: #64748b; margin-top: 4px;">
                                                <c:out value="${not empty p.excerpt ? p.excerpt : 'No description available.'}" />
                                            </div>
                                        </div>
                                        <span class="badge" style="background: #f3f1ff; color: #4038ff;">CheatSheet</span>
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
                            <div class="section-title" style="color: #f59e0b; border-bottom: 2px solid #fef3c7;">&#128193; Folders (Collections)</div>
                            <c:forEach var="col" items="${collectionResults}">
                                <div class="result-item">
                                    <div>
                                        <a href="${pageContext.request.contextPath}/user/collections/view?id=${col.id}" 
                                           style="text-decoration: none; color: #d97706; font-weight: 700; font-size: 16px;"
                                           onmouseover="this.style.textDecoration='underline'" 
                                           onmouseout="this.style.textDecoration='none'">
                                            &#128193; <c:out value="${col.name}" />
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
                            <div class="section-title">Categories</div>
                            <c:forEach var="cat" items="${categoryResults}">
                                <div class="result-item">
                                    <div>
                                        <strong style="color: #1e293b; font-size: 15px;"><c:out value="${cat.name}"/></strong>
                                        <div style="font-size: 13px; color: #64748b; margin-top: 4px;"><c:out value="${cat.description}"/></div>
                                    </div>
                                    <span class="badge">Category</span>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>

                    <%-- 4. Users Section --%>
                    <c:if test="${not empty userResults}">
                        <div class="result-section">
                            <div class="section-title">Users</div>
                            <c:forEach var="u" items="${userResults}">
                                <div class="result-item">
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.currentUser}">
                                                <a href="${pageContext.request.contextPath}/profile?id=${u.id}" 
                                                   style="text-decoration: none; color: #0f766e; font-weight: 600;">
                                                    @<c:out value="${u.username}"/>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #1e293b; font-weight: 600; cursor: not-allowed;" title="Please login to view profile">
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

                    <%-- Fallback Layout --%>
                    <c:if test="${empty postResults && empty collectionResults && empty categoryResults && empty userResults}">
                        <div style="background: white; padding: 40px; text-align: center; border-radius: 16px; color: #64748b; border: 1px solid #e2e8f0;">
                            <span style="font-size: 24px; display: block; margin-bottom: 10px;">&#128269;</span> No matching results found for "${searchedKeyword}".
                        </div>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/" class="clear-search-btn">&larr; Clear search results</a>
                </div>
            </c:when>

            <%-- CONDITION B: UNIFIED HOME SCREEN LAYOUT --%>
            <c:otherwise>
                <section class="home-hero">
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <div class="accent-label">Dashboard Active</div>
                            <h2>Welcome back, <c:out value="${sessionScope.currentUser.username}"/> &#128075;</h2>
                            <p>Explore categories, discover popular cheat sheets, and continue learning from community-approved guides.</p>
                            <p>You can now use the top navigation bar from your dashboard to look up references and manage your private notes.</p>
                            <div style="margin-top: 18px;">
                                <a href="${pageContext.request.contextPath}/notes" style="display: inline-flex; align-items: center; gap: 8px; padding: 10px 20px; background: rgba(255,255,255,0.2); color: white; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 14px; backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.3); transition: all 0.2s;">
                                    📝 My Private Notes
                                </a>
                            </div>
                        </c:when>
                        
                        <c:otherwise>
                            <div class="accent-label">Public Library</div>
                            <h2>Explore Cheat Sheets</h2>
                            <p>Simple, practical guides created by the community and approved for everyone.</p>
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

                <section class="home-section">
                    <div class="home-section-header">
                        <div>
                            <span class="section-kicker">Most Viewed</span>
                            <h2>Popular Posts</h2>
                        </div>
                        <a href="${pageContext.request.contextPath}/posts/popular">See more</a>
                    </div>
                    <div class="post-card-grid">
                        <c:choose>
                            <c:when test="${not empty popularPosts}">
                                <c:forEach var="post" items="${popularPosts}">
                                    <article class="home-post-card">
                                        <span class="post-category"><c:out value="${post.category.name}" /></span>
                                        <h3><c:out value="${post.title}" /></h3>
                                        <p><c:out value="${empty post.excerpt ? 'No excerpt available.' : post.excerpt}" /></p>
                                        <div class="post-meta">
                                            <span>By <c:out value="${empty post.author ? '-' : post.author.username}" /></span>
                                            <span><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /> views</span>
                                        </div>
                                        <div class="post-footer">
                                            <small><c:out value="${post.createdAt}" /></small>
                                            <a href="${pageContext.request.contextPath}/posts/${post.slug}">Read More</a>
                                        </div>
                                    </article>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="home-empty">No popular posts are available yet.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <section class="home-section">
                    <div class="home-section-header">
                        <div>
                            <span class="section-kicker">Last 30 Days</span>
                            <h2>Trending Posts</h2>
                        </div>
                        <a href="${pageContext.request.contextPath}/posts/trending">See more</a>
                    </div>
                    <div class="post-card-grid">
                        <c:choose>
                            <c:when test="${not empty trendingPosts}">
                                <c:forEach var="post" items="${trendingPosts}">
                                    <article class="home-post-card">
                                        <span class="post-category"><c:out value="${post.category.name}" /></span>
                                        <h3><c:out value="${post.title}" /></h3>
                                        <p><c:out value="${empty post.excerpt ? 'No excerpt available.' : post.excerpt}" /></p>
                                        <div class="post-meta">
                                            <span>By <c:out value="${empty post.author ? '-' : post.author.username}" /></span>
                                            <span><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /> views</span>
                                        </div>
                                        <div class="post-footer">
                                            <small><c:out value="${post.createdAt}" /></small>
                                            <a href="${pageContext.request.contextPath}/posts/${post.slug}">Read More</a>
                                        </div>
                                    </article>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="home-empty">No trending posts are available yet.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>

                <section class="home-section">
                    <div class="home-section-header">
                        <div>
                            <span class="section-kicker">Fresh Guides</span>
                            <h2>New Posts</h2>
                        </div>
                        <a href="${pageContext.request.contextPath}/posts/new">See more</a>
                    </div>
                    <div class="post-card-grid">
                        <c:choose>
                            <c:when test="${not empty newPosts}">
                                <c:forEach var="post" items="${newPosts}">
                                    <article class="home-post-card">
                                        <span class="post-category"><c:out value="${post.category.name}" /></span>
                                        <h3><c:out value="${post.title}" /></h3>
                                        <p><c:out value="${empty post.excerpt ? 'No excerpt available.' : post.excerpt}" /></p>
                                        <div class="post-meta">
                                            <span>By <c:out value="${empty post.author ? '-' : post.author.username}" /></span>
                                            <span><c:out value="${empty post.viewCount ? 0 : post.viewCount}" /> views</span>
                                        </div>
                                        <div class="post-footer">
                                            <small><c:out value="${post.createdAt}" /></small>
                                            <a href="${pageContext.request.contextPath}/posts/${post.slug}">Read More</a>
                                        </div>
                                    </article>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="home-empty">No new posts are available yet.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </section>
            </c:otherwise>
        </c:choose>
    </main>

    <footer class="site-footer">
        <div>
            <h2>CheatSheet Hub</h2>
            <p>Community-built cheat sheets for quick learning, practical references, and clean knowledge sharing.</p>
        </div>
        <nav>
            <a href="${pageContext.request.contextPath}/">Home</a>
            <a href="${pageContext.request.contextPath}/posts/public">View Posts</a>
            <a href="${pageContext.request.contextPath}/posts/categories">Categories</a>
            <a href="${pageContext.request.contextPath}/posts/popular">Popular</a>
        </nav>
        <small>&copy; 2026 CheatSheet Hub. All rights reserved.</small>
    </footer>

    <c:if test="${not empty sessionScope.currentUser}">
        <a href="${pageContext.request.contextPath}/chat" class="chat-fab" title="Messages">&#128172;</a>
    </c:if>

</body>
</html>
