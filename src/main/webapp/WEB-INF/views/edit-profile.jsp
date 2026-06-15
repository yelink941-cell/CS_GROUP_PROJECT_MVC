<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; 
            background: #f8fafc; 
            color: #1e293b;
            min-height: 100vh;
            display: flex; 
            justify-content: center; 
            align-items: center;
            padding: 20px;
        }
        .card { 
            background: #ffffff; 
            border: 1px solid #e2e8f0; 
            border-radius: 16px; 
            width: 100%;
            max-width: 400px; 
            padding: 32px; 
            box-shadow: 0 4px 25px rgba(0, 0, 0, 0.04); 
        }
        .title {
            font-size: 22px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 24px;
            text-align: center;
        }
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            margin-bottom: 6px;
        }
        .form-control {
            width: 100%;
            padding: 10px 14px;
            font-size: 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            background: #fff;
            color: #1e293b;
            transition: border-color 0.15s ease;
        }
        .form-control:focus {
            outline: none;
            border-color: #0284c7;
            box-shadow: 0 0 0 3px rgba(2, 132, 199, 0.1);
        }
        textarea.form-control {
            resize: none;
            height: 80px;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: #0284c7;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: #0369a1;
        }
        .cancel-link {
            display: block;
            text-align: center;
            margin-top: 16px;
            font-size: 13px;
            color: #64748b;
            text-decoration: none;
        }
        .cancel-link:hover {
            color: #1e293b;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="title">Edit Profile Settings</div>
        
        <form action="${pageContext.request.contextPath}/profile/update" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" class="form-control" value="<c:out value='${userProfile.fullName}'/>" required />
            </div>
            
            <div class="form-group">
                <label>Country</label>
                <input type="text" name="country" class="form-control" value="<c:out value='${userProfile.country}'/>" required />
            </div>
            
            <div class="form-group">
                <label>Bio Description</label>
                <textarea name="bio" class="form-control"><c:out value='${userProfile.bio}'/></textarea>
            </div>
            
            <div class="form-group">
                <label>Update Profile Picture</label>
                <input type="file" name="avatarFile" class="form-control" accept="image/*" />
            </div>
            
            <button type="submit" class="btn-submit">Save Changes</button>
        </form>
        
        <a href="${pageContext.request.contextPath}/profile" class="cancel-link">Cancel and Go Back</a>
    </div>
</body>
</html>