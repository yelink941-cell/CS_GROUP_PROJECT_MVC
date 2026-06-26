<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile Settings</title>
    <style>
        :root {
            --primary: #10b981;
            --primary-hover: #059669;
            --bg: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        body { 
            font-family: 'Inter', -apple-system, sans-serif; 
            background-color: var(--bg); 
            margin: 0;
            padding: 40px 20px; 
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            box-sizing: border-box;
        }
        .edit-container { 
            background: var(--card-bg); 
            padding: 40px; 
            border-radius: 16px; 
            width: 100%;
            max-width: 440px; 
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05); 
        }
        h2 { color: var(--text-main); margin: 0 0 6px 0; font-size: 22px; font-weight: 700; text-align: center; }
        .subtitle { text-align: center; color: var(--text-muted); font-size: 14px; margin-bottom: 28px; }
        
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 500; color: var(--text-main); font-size: 14px; }
        .form-group input, .form-group textarea { 
            width: 100%; padding: 12px 14px; box-sizing: border-box; border: 1px solid var(--border); 
            border-radius: 8px; font-size: 14px; background: #fafafa; outline: none; transition: all 0.2s ease;
            color: var(--text-main);
        }
        .form-group input:focus, .form-group textarea:focus { 
            border-color: var(--primary); background: #fff; box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1); 
        }
        
        .btn-submit { 
            width: 100%; padding: 12px; background-color: var(--primary); color: white; 
            border: none; border-radius: 8px; font-weight: 600; cursor: pointer; 
            font-size: 15px; margin-top: 10px; transition: background-color 0.2s ease; 
        }
        .btn-submit:hover { background-color: var(--primary-hover); }
        
        .cancel-link { 
            display: block; text-align: center; margin-top: 16px; color: var(--text-muted); 
            text-decoration: none; font-size: 14px; font-weight: 500; transition: color 0.2s ease;
        }
        .cancel-link:hover { color: var(--text-main); }
    </style>
</head>
<body>
<div class="edit-container">
    <h2>Update Profile</h2>
    <p class="subtitle">Modify your public facing metadata choices</p>
    
    <form:form action="${pageContext.request.contextPath}/profile/update" method="POST" modelAttribute="userProfile" enctype="multipart/form-data">
        <div class="form-group">
            <label>Full Display Name</label>
            <form:input path="fullName" required="required" placeholder="Enter your display name" />
        </div>
        <div class="form-group">
            <label>Short Biography</label>
            <form:textarea path="bio" rows="3" placeholder="Tell us about yourself..." />
        </div>
        <div class="form-group">
            <label>Update Avatar File</label>
            <input type="file" name="avatarFile" accept="image/*" style="background: transparent; border: none; padding: 4px 0;" />
        </div>
        
        <button type="submit" class="btn-submit">Save Settings</button>
        <a href="${pageContext.request.contextPath}/profile" class="cancel-link">Discard Changes</a>
    </form:form>
</div>
</body>
</html>