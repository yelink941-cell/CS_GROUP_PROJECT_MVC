<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${folder.name} - CheatSheet Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/navigation.css">
   <style>
        .back-link {
            text-decoration: none;
            color: #10b981;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            margin-bottom: 1.5rem;
            font-size: 14px;
        }
        .back-link:hover {
            color: #059669;
        }
        .items-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }
        
        /* 🎯 🌟 ၁။ 🗑️ Icon ကို ကတ်ပြားရဲ့အတွင်းမှာ အမှီပြုပြီး နေရာချနိုင်ရန် Wrapper ထည့်ပေးပါသည် */
        .cheat-sheet-card-wrapper {
            position: relative; 
        }

        .cheat-sheet-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 1px solid #eee;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
            text-decoration: none;
            color: inherit;
            display: block;
            transition: transform 0.2s, border-color 0.2s;
            
            /* 🎯 🌟 ၂။ စာသားခေါင်းစဉ်ရှည်သွားရင် 🗑️ Icon နဲ့ မထပ်မိစေရန် ညာဘက်ကို Padding 3rem ချန်ထားပေးပါသည် */
            padding-right: 3rem; 
        }
        .cheat-sheet-card:hover {
            transform: translateY(-3px);
            border-color: #38bdf8;
            box-shadow: 0 6px 12px rgba(0,0,0,0.05);
        }
        .cheat-sheet-title {
            color: #1e293b;
            margin: 0 0 0.5rem 0;
            font-size: 1.2rem;
        }
        
        /* 🎯 🌟 ၃။ 🗑️ Icon အတွက် စတိုင်လ်အသစ် (ခပ်မှိန်မှိန်လေးပေါ်နေပြီး Mouse တင်ရင် အနီရောင်ပြောင်းမည့်စနစ်) */
        .btn-delete-item {
            position: absolute;
            top: 1.5rem;
            right: 1.2rem;
            background: none;
            border: none;
            font-size: 1.1rem;
            cursor: pointer;
            color: #94a3b8; /* မူရင်းအရောင် ခပ်မှိန်မှိန် */
            transition: color 0.2s, transform 0.2s;
            text-decoration: none;
            z-index: 10; /* ကတ်ပြားရဲ့ အပေါ်ဆုံးလွှာမှာ ရှိနေစေရန် (မရှိရင် နှိပ်မရဖြစ်တတ်ပါသည်) */
        }
        .btn-delete-item:hover {
            color: #ef4444; /* Mouse တင်လိုက်ရင် အနီရောင်တောက်တောက်ပြောင်းရန် */
            transform: scale(1.15); /* နည်းနည်းလေး ကြီးလာစေရန် */
        }

        .empty-state {
            background: #f8fafc;
            border: 2px dashed #cbd5e1;
            border-radius: 8px;
            padding: 3rem;
            text-align: center;
            color: #64748b;
            grid-column: 1 / -1;
        }
    </style>
</head>
<body class="public-list-page">
    <jsp:include page="/WEB-INF/views/fragments/site-navigation.jsp" />

    <main class="page-container" style="padding: 2rem; max-width: 1200px; margin: 0 auto;">
        
        <a href="${pageContext.request.contextPath}/user/collections" class="back-link">
            ⬅ Back to Folders
        </a>

        <header class="library-header" style="margin-bottom: 2rem;">
            <span>📁 Collection Folder Items</span>
            <h1 style="margin-top: 0.5rem;">Items inside: <c:out value="${folder.name}"/></h1>
            <p style="color: #64748b;"><c:out value="${folder.description}"/></p>
        </header>

        <section class="items-grid">
            <c:choose>
                <c:when test="${empty savedPosts}">
                    <div class="empty-state">
                        <p style="font-size: 1.1rem; margin: 0;">No cheat sheets saved in this folder yet.</p>
                    </div>
                </c:when>
                <c:otherwise>
                 <c:forEach var="post" items="${savedPosts}">
    <!-- 🎯 အပြင်ဘက်ဆုံးမှာ Wrapper Class သေချာပေါက် ရှိနေရပါမည် -->
    <div class="cheat-sheet-card-wrapper">
        
        <!-- မင်းရဲ့ မူရင်းကတ်ပြား -->
        <a href="${pageContext.request.contextPath}/posts/${post.slug}" class="cheat-sheet-card">
            <h3 class="cheat-sheet-title">📄 <c:out value="${post.title}"/></h3>
            <span style="font-size: 0.85rem; color: #64748b;">View Details ➔</span>
        </a>
        
        <!-- 🗑️ ခလုတ်လေးကို Wrapper ထဲတွင် သီးသန့် ညှပ်ပေးလိုက်ခြင်း -->
        <a href="${pageContext.request.contextPath}/user/collections/${folder.id}/remove-post/${post.id}" 
           class="btn-delete-item" 
           onclick="return confirm('Are you sure you want to remove this item from this folder?');"
           title="Remove from folder">
            🗑️
        </a>
        
    </div>
</c:forEach>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>