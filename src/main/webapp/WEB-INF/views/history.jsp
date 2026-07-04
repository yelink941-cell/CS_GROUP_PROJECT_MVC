<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Search History</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f4f6f9; }
        header { background-color: #ffffff; padding: 15px 30px; display: flex; align-items: center; gap: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .back-btn { display: inline-flex; align-items: center; padding: 8px 16px; background-color: #f1f5f9; color: #334155; text-decoration: none; border-radius: 6px; font-size: 14px; font-weight: bold; border: 1px solid #e2e8f0; }
        .back-btn:hover { background-color: #e2e8f0; transform: translateX(-3px); transition: all 0.2s; }
        .container { max-width: 800px; margin: 30px auto; padding: 0 20px; }
        .history-box { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .section-title { font-size: 18px; color: #4a5568; border-bottom: 2px solid #e2e8f0; padding-bottom: 8px; margin-bottom: 15px; font-weight: bold; }
        .history-item { padding: 12px; border-bottom: 1px solid #f0f4f8; display: flex; justify-content: space-between; align-items: center; }
        .history-item:last-child { border-bottom: none; }
        
        /* 🔍 Clickable Search Query Style */
        .search-link { color: #2d3748; font-weight: bold; text-decoration: none; transition: color 0.2s; cursor: pointer; background: none; border: none; padding: 0; font-size: 16px; }
        .search-link:hover { color: #008069; text-decoration: underline; }

        /* 🗑️ Delete Button Hover Style */
        .delete-btn { color: #dc3545; text-decoration: none; font-size: 13px; font-weight: 600; padding: 6px 12px; background: #ffebeb; border-radius: 12px; transition: all 0.2s; }
        .delete-btn:hover { background: #fbd5d5; transform: scale(1.03); }
    </style>
</head>
<body>

    <form id="historySearchForm" action="${pageContext.request.contextPath}/doSearch" method="POST" style="display: none;">
        <input type="hidden" id="searchKeyword" name="keyword">
    </form>

    <header>
        <a href="${pageContext.request.contextPath}/" class="back-btn">⬅ Back to Home</a>
        <h2 style="margin: 0;">🕒 Your Search History</h2>
    </header>

    <div class="container">
        <div class="history-box">
            <div class="section-title">Recent Queries</div>
            <ul style="list-style: none; padding: 0; margin: 0;">
                <c:choose>
                    <c:when test="${not empty searchHistory}">
                        <c:forEach var="history" items="${searchHistory}">
                            <li class="history-item">
                                <div>
                                    <button class="search-link" onclick="submitHistorySearch('${history.keyword}')">
                                        🔍 ${history.keyword}
                                    </button>
                                    <span style="font-size: 13px; color: #a0aec0; margin-left: 15px;">${history.searchedAt}</span>
                                </div>
                                
                                <a href="${pageContext.request.contextPath}/history/delete?id=${history.id}" 
                                   class="delete-btn"
                                   onclick="return confirm('Are you sure you want to delete this search history?');">
                                   ✕ Delete
                                </a>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li style="color: #aaa; text-align: center; padding: 20px;">No search history found yet.</li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>

    <script>
        function submitHistorySearch(keyword) {
            document.getElementById('searchKeyword').value = keyword;
            document.getElementById('historySearchForm').submit();
        }
    </script>

</body>
</html>