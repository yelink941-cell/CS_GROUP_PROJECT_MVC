<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Testing Screen</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f6f9; }
        .box { max-width: 500px; margin: 0 auto; background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h2, h3 { color: #333; }
        input[type="text"] { width: 70%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        input[type="submit"] { width: 25%; padding: 10px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        input[type="submit"]:hover { background-color: #218838; }
        .list { margin-top: 20px; list-style: none; padding: 0; }
        .item { padding: 12px; border-bottom: 1px solid #edf2f7; display: flex; justify-content: space-between; }
        .date { font-size: 12px; color: #a0aec0; }
    </style>
</head>
<body>

    <div class="box">
        <h2>Search Feature Test</h2>
        <form action="${pageContext.request.contextPath}/doSearch" method="post">
            <input type="text" name="keyword" placeholder="What are you looking for?" required>
            <input type="submit" value="Search">
        </form>

        <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e2e8f0;">

        <h3>Your Search History</h3>
        <ul class="list">
            <c:choose>
                <c:when test="${not empty searchHistory}">
                    <c:forEach var="history" items="${searchHistory}">
                        <li class="item">
                            <span>🔍 ${history.keyword}</span>
                            <span class="date">${history.searchedAt}</span>
                        </li>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <li style="color: #999; text-align: center; padding: 10px;">No history records found.</li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>

</body>
</html>