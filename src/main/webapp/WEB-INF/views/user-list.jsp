<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User List</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>

    <h1>Registered Users</h1>
    
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Email</th>
                <th>Role</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%-- Controller ကပို့ပေးတဲ့ users list ကို loop ပတ်ထုတ်ပြခြင်း --%>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td>${user.id}</td>
                    <td>${user.email}</td>
                    <td>${user.role}</td>
                    <td>
	                    <%-- View Detail link အသစ်ထည့်လိုက်ခြင်း --%>
    					<a href="${pageContext.request.contextPath}/user-detail?id=${user.id}">View</a>
                		<%-- Delete လုပ်ရန် --%>
                		<a href="${pageContext.request.contextPath}/admin/deleteUser?id=${user.id}">Delete</a>
                
                | 
                
                		<%-- Ban လုပ်ရန် --%>
                		<a href="${pageContext.request.contextPath}/admin/banUser?id=${user.id}">Ban</a>
            </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>
    <a href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a>

</body>
</html>