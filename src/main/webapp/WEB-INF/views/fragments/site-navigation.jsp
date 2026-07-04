<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
   
    .site-nav {
        background-color: #0f172a;
        padding: 10px 0;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }

    .nav-inner {
        display: flex;
        justify-content: space-between;
        align-items: center;
        width: 100%;
        max-width: 1300px; 
        margin: 0 auto;
        padding: 0 20px;
        flex-wrap: wrap; 
        gap: 15px;
    }
    
    .nav-right-zone {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 16px;
        flex-grow: 1;
        flex-wrap: wrap;
    }

    /* ============================================
       YOUTUBE STYLE SEARCH
       ============================================ */
    .search-wrapper {
        position: relative;
        display: inline-block;
        flex: 1;
        max-width: 400px;
        min-width: 180px;
    }
    
    .nav-search-form {
        display: flex;
        align-items: center;
        width: 100%;
        margin: 0;
        position: relative;
        background: #1e293b;
        border-radius: 24px;
        border: 1px solid #334155;
        transition: all 0.3s ease;
    }
    
    .nav-search-form:focus-within {
        border-color: #38bdf8;
        box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.15);
    }
    
    .nav-search-input {
        flex: 1;
        padding: 8px 16px;
        background: transparent;
        color: #ffffff;
        border: none;
        border-radius: 24px;
        outline: none;
        font-size: 13px;
        min-width: 80px;
    }
    
    .nav-search-input::placeholder {
        color: #94a3b8;
    }
    
    .nav-search-button {
        padding: 8px 18px;
        background: transparent;
        color: #94a3b8;
        border: none;
        border-radius: 0 24px 24px 0;
        cursor: pointer;
        font-weight: 600;
        font-size: 14px;
        transition: color 0.2s;
    }
    
    .nav-search-button:hover {
        color: #38bdf8;
    }

    /* ============================================
       YOUTUBE STYLE SUGGESTIONS DROPDOWN
       ============================================ */
    .suggestions-dropdown {
        position: absolute;
        top: calc(100% + 6px);
        left: 0;
        right: 0;
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 16px;
        max-height: 380px;
        overflow-y: auto;
        display: none;
        z-index: 9999;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.6);
        padding: 6px 0;
    }
    
    .suggestions-dropdown.show {
        display: block;
    }
    
    .suggestion-item {
        padding: 10px 18px;
        color: #e2e8f0;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 12px;
        transition: background 0.15s ease;
        border-bottom: 1px solid #2d3748;
    }
    
    .suggestion-item:last-child {
        border-bottom: none;
    }
    
    .suggestion-item:hover {
        background: #334155;
    }
    
    .suggestion-item .icon {
        color: #64748b;
        font-size: 16px;
        flex-shrink: 0;
    }
    
    .suggestion-item .text {
        flex: 1;
        font-size: 14px;
        color: #e2e8f0;
    }
    
    .suggestion-item .text .highlight {
        color: #fbbf24;
        font-weight: 700;
    }
    
    .suggestion-item .badge-suggestion {
        font-size: 10px;
        color: #fbbf24;
        background: #2d3748;
        padding: 2px 12px;
        border-radius: 12px;
        flex-shrink: 0;
        border: 1px solid #4a5568;
    }
    
    .suggestion-item.selected {
        background: #334155;
        border-left: 3px solid #fbbf24;
    }
    
    .suggestion-empty {
        padding: 16px 18px;
        color: #94a3b8;
        text-align: center;
        font-size: 14px;
    }
    
    .suggestion-empty .icon {
        margin-right: 8px;
        color: #fbbf24;
    }
    
    .suggestions-dropdown::-webkit-scrollbar {
        width: 5px;
    }
    
    .suggestions-dropdown::-webkit-scrollbar-track {
        background: #1e293b;
        border-radius: 8px;
    }
    
    .suggestions-dropdown::-webkit-scrollbar-thumb {
        background: #fbbf24;
        border-radius: 8px;
    }
    
    .suggestions-dropdown::-webkit-scrollbar-thumb:hover {
        background: #f59e0b;
    }

    .nav-history-btn, .nav-collections-btn, .nav-notifications-btn {
        text-decoration: none;
        font-weight: 600;
        padding: 6px 14px;
        background: #1e293b;
        border-radius: 20px;
        font-size: 13px;
        display: inline-flex;
        align-items: center;
        white-space: nowrap;
    }
    .nav-collections-btn { color: #10b981; border: 1px solid #065f46; gap: 6px; }
    .nav-notifications-btn { color: #fbbf24; border: 1px solid #92400e; gap: 6px; position: relative; }
    .nav-notif-badge {
        background: #ef4444;
        color: white;
        font-size: 10px;
        font-weight: 700;
        min-width: 18px;
        height: 18px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0 4px;
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 18px; 
    }

    .nav-link {
        color: #f8fafc;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        white-space: nowrap;
        transition: color 0.2s;
    }
    .nav-link:hover {
        color: #38bdf8;
    }

    .nav-link-primary {
        background-color: #2563eb;
        padding: 6px 16px;
        border-radius: 8px;
        color: white !important;
        font-weight: 600;
    }
    .nav-link-primary:hover {
        background-color: #1d4ed8;
    }

    .nav-dropdown {
        position: relative;
        align-self: stretch;
        display: flex;
        align-items: center;
    }

    .nav-dropdown-menu {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        z-index: 9999;
        min-width: 280px;
        padding: 8px 0;
        overflow: hidden;
        border: 1px solid #e5e7eb;
        border-radius: 10px;
        background: #ffffff;
        box-shadow: 0 18px 42px rgba(15, 23, 42, 0.2);
    }

    .nav-dropdown-menu a {
        display: block;
        padding: 11px 18px;
        color: #1e293b;
        background: #ffffff;
        text-decoration: none;
        font-size: 0.92rem;
        font-weight: 500;
        line-height: 1.4;
        white-space: nowrap;
        transition: color 0.15s ease, background 0.15s ease;
    }

    .nav-dropdown-menu a:hover {
        color: #0f172a;
        background: #f1f5f9;
    }

    .nav-dropdown-menu a::before {
        content: "→ ";
        opacity: 0.5;
    }

    .nav-dropdown:hover .nav-dropdown-menu,
    .nav-dropdown:focus-within .nav-dropdown-menu {
        display: block;
    }

    @media (max-width: 768px) {
        .search-wrapper {
            max-width: 100%;
            width: 100%;
        }
        
        .nav-inner {
            flex-direction: column;
            align-items: stretch;
        }
        
        .nav-right-zone {
            flex-direction: column;
            align-items: stretch;
        }
        
        .nav-links {
            flex-wrap: wrap;
            justify-content: center;
        }
    }
</style>

<nav class="site-nav">
    <div class="nav-inner">
        <a class="brand" href="${pageContext.request.contextPath}/">CheatSheet Hub</a>

        <div class="nav-right-zone">
            
            <c:if test="${not empty sessionScope.currentUser}">
                <a href="${pageContext.request.contextPath}/notifications" class="nav-notifications-btn">
                    &#128276; Notifications
                    <c:if test="${unreadNotificationCount > 0}">
                        <span class="nav-notif-badge">${unreadNotificationCount}</span>
                    </c:if>
                </a>
            </c:if>
            
            <c:if test="${not empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/user/collections" class="nav-collections-btn">
                    &#128193; My Collections
                </a>
            </c:if>
            
            <!-- ✅ YouTube Style Search -->
            <div class="search-wrapper">
                <form action="${pageContext.request.contextPath}/doSearch" method="post" class="nav-search-form" id="searchForm" autocomplete="off">
                    <input type="text" 
                           name="keyword" 
                           id="searchInput" 
                           class="nav-search-input" 
                           placeholder="Search categories, users, posts..." 
                           value="<c:out value='${searchedKeyword}'/>" 
                           autocomplete="off"
                           required>
                    <button type="submit" class="nav-search-button">🔍</button>
                </form>
                
                <!-- Suggestions Dropdown -->
                <div class="suggestions-dropdown" id="suggestionsDropdown">
                    <div id="suggestionsList"></div>
                </div>
            </div>

            <div class="nav-links">
                <c:choose>
                    <c:when test="${sessionScope.role == 'ADMIN'}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin-dashboard">Dashboard</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/categories">Categories</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/tags">Tags</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/posts/pending">Pending Posts</a>
                        <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/logout">Logout</a>
                    </c:when>

                <c:when test="${sessionScope.role == 'USER'}">
                    <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    <div class="nav-item nav-dropdown">
                        <a class="nav-link" href="${pageContext.request.contextPath}/posts/public">View Posts</a>
                        <div class="nav-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/posts/public">&#128196; All Public Posts</a>
                            <a href="${pageContext.request.contextPath}/posts/categories">&#128218; Cheat Sheets by Category</a>
                            <a href="${pageContext.request.contextPath}/posts/tags">&#127991; Cheat Sheets by Tag</a>
                            <a href="${pageContext.request.contextPath}/posts/popular">&#11088; Popular Cheat Sheets</a>
                            <a href="${pageContext.request.contextPath}/posts/trending">&#128293; Trending Cheat Sheets</a>
                            <a href="${pageContext.request.contextPath}/posts/new">&#127381; New Cheat Sheets</a>
                        </div>
                    </div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/posts">My Posts</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/posts/new">Create Post</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/profile">My Profile</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/user/posts/bookmark">My Bookmarks</a>
                    <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/logout">Logout</a>
                </c:when>

                <c:otherwise>
                    <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    <div class="nav-item nav-dropdown">
                        <a class="nav-link" href="${pageContext.request.contextPath}/posts/public">View Posts</a>
                        <div class="nav-dropdown-menu">
                            <a href="${pageContext.request.contextPath}/posts/public">&#128196; All Public Posts</a>
                            <a href="${pageContext.request.contextPath}/posts/categories">&#128218; Cheat Sheets by Category</a>
                            <a href="${pageContext.request.contextPath}/posts/tags">&#127991; Cheat Sheets by Tag</a>
                            <a href="${pageContext.request.contextPath}/posts/popular">&#11088; Popular Cheat Sheets</a>
                            <a href="${pageContext.request.contextPath}/posts/trending">&#128293; Trending Cheat Sheets</a>
                            <a href="${pageContext.request.contextPath}/posts/new">&#127381; New Cheat Sheets</a>
                        </div>
                    </div>
                    <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                    <a class="nav-link nav-link-primary" href="${pageContext.request.contextPath}/register">Register</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<script>
    (function() {
        var searchInput = document.getElementById('searchInput');
        var suggestionsDropdown = document.getElementById('suggestionsDropdown');
        var suggestionsList = document.getElementById('suggestionsList');
        var debounceTimer;
        var selectedIndex = -1;

        // Function to fetch suggestions
        function fetchSuggestions(query) {
            if (query.length < 1) {
                suggestionsDropdown.classList.remove('show');
                return;
            }

            var url = '${pageContext.request.contextPath}/search/suggestions?q=' + encodeURIComponent(query);
            
            fetch(url)
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    renderSuggestions(data.suggestions, query);
                })
                .catch(function(error) {
                    console.error('Error fetching suggestions:', error);
                    suggestionsDropdown.classList.remove('show');
                });
        }

        // Render suggestions
        function renderSuggestions(suggestions, query) {
            if (!suggestions || suggestions.length === 0) {
                suggestionsList.innerHTML = `
                    <div class="suggestion-empty">
                        <span class="icon">🔍</span> No suggestions found for "<strong>${query}</strong>"
                    </div>
                `;
                suggestionsDropdown.classList.add('show');
                return;
            }

            var html = '';
            for (var i = 0; i < suggestions.length; i++) {
                var item = suggestions[i];
                var lowerItem = item.toLowerCase();
                var lowerQuery = query.toLowerCase();
                var index = lowerItem.indexOf(lowerQuery);
                var displayText = item;
                if (index !== -1) {
                    var before = item.substring(0, index);
                    var match = item.substring(index, index + query.length);
                    var after = item.substring(index + query.length);
                    displayText = before + '<span class="highlight">' + match + '</span>' + after;
                }
                
                html += `
                    <div class="suggestion-item" data-keyword="${item}">
                        <span class="icon">🔍</span>
                        <span class="text">${displayText}</span>
                        <span class="badge-suggestion">suggestion</span>
                    </div>
                `;
            }

            suggestionsList.innerHTML = html;
            suggestionsDropdown.classList.add('show');
            selectedIndex = -1;

            // Add click listeners to suggestion items
            var items = document.querySelectorAll('.suggestion-item');
            for (var i = 0; i < items.length; i++) {
                (function(el) {
                    el.addEventListener('click', function() {
                        var keyword = this.getAttribute('data-keyword');
                        searchInput.value = keyword;
                        document.getElementById('searchForm').submit();
                    });
                })(items[i]);
            }
        }

        // Input event with debouncing
        searchInput.addEventListener('input', function() {
            clearTimeout(debounceTimer);
            var query = this.value.trim();
            
            if (query.length < 1) {
                suggestionsDropdown.classList.remove('show');
                return;
            }
            
            debounceTimer = setTimeout(function() {
                fetchSuggestions(query);
            }, 300);
        });

        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            var wrapper = document.querySelector('.search-wrapper');
            if (!wrapper.contains(e.target)) {
                suggestionsDropdown.classList.remove('show');
            }
        });

        // Close on Escape
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                suggestionsDropdown.classList.remove('show');
                searchInput.blur();
            }
        });

        // Keyboard navigation
        document.addEventListener('keydown', function(e) {
            if (!suggestionsDropdown.classList.contains('show')) return;
            
            var items = document.querySelectorAll('.suggestion-item');
            if (items.length === 0) return;
            
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectedIndex = Math.min(selectedIndex + 1, items.length - 1);
                highlightItem(items, selectedIndex);
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectedIndex = Math.max(selectedIndex - 1, -1);
                highlightItem(items, selectedIndex);
            } else if (e.key === 'Enter') {
                if (selectedIndex >= 0 && selectedIndex < items.length) {
                    e.preventDefault();
                    var keyword = items[selectedIndex].getAttribute('data-keyword');
                    searchInput.value = keyword;
                    document.getElementById('searchForm').submit();
                }
            }
        });

        function highlightItem(items, index) {
            for (var i = 0; i < items.length; i++) {
                if (i === index) {
                    items[i].classList.add('selected');
                    items[i].scrollIntoView({ block: 'nearest' });
                } else {
                    items[i].classList.remove('selected');
                }
            }
        }
    })();
</script>