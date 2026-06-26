<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cheatography - Cheat Sheets and References</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Base Styling Resets */
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Inter', sans-serif; }
        body { background-color: #f1f5f9; color: #1e293b; min-height: 100vh; display: flex; flex-direction: column; }

        /* Modernized Fixed Top Navigation Header */
        header { background-color: #0f172a; padding: 16px 48px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 100; }
        .logo { color: #ffffff; font-size: 24px; font-weight: 700; text-decoration: none; letter-spacing: -0.5px; display: flex; align-items: center; gap: 8px; }
        .logo span { border-bottom: 3px solid #f39c12; padding-bottom: 2px; }
        .auth-buttons { display: flex; gap: 14px; align-items: center; }
        
        /* Navigation Actions */
        .btn-nav { text-decoration: none; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 14px; transition: all 0.2s ease-in-out; text-transform: capitalize; border: none; cursor: pointer; }
        .btn-login { color: #f8fafc; background: rgba(255,255,255,0.1); }
        .btn-login:hover { background: rgba(255,255,255,0.2); }
        .btn-register { color: #ffffff; background: #e67e22; box-shadow: 0 4px 12px rgba(230, 126, 34, 0.2); }
        .btn-register:hover { background: #d35400; transform: translateY(-1px); }
        .btn-profile { color: #ffffff; background: #10b981; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2); }
        .btn-profile:hover { background: #059669; transform: translateY(-1px); }
        .btn-logout { color: #ffffff; background: #ef4444; }
        .btn-logout:hover { background: #dc2626; }

        /* Core Canvas Container */
        .container { max-width: 1200px; width: 100%; margin: 0 auto; padding: 60px 24px; flex-grow: 1; }
        
        /* Hero Callout Frame */
        .hero-section { text-align: center; margin-bottom: 54px; max-width: 800px; margin-left: auto; margin-right: auto; }
        .hero-title { color: #0f172a; font-size: 38px; font-weight: 800; line-height: 1.2; letter-spacing: -1px; margin-bottom: 16px; }
        .hero-subtitle { color: #64748b; font-size: 16px; font-weight: 400; line-height: 1.6; }

        /* Status & Feedback Flashers */
        .msg-alert { max-width: 600px; margin: 0 auto 32px auto; background-color: #ecfdf5; color: #065f46; padding: 14px 20px; border-radius: 10px; text-align: center; font-weight: 500; border: 1px solid #a7f3d0; box-shadow: 0 2px 4px rgba(0,0,0,0.02); display: flex; align-items: center; justify-content: center; gap: 8px; opacity: 1; }
        .msg-error { background-color: #fef2f2; color: #991b1b; border-color: #fca5a5; }

        /* Dynamic Grid Engine */
        .grid-container { display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 28px; }
        
        /* Premium Card Mechanics */
        .card { background: #ffffff; border-radius: 16px; padding: 36px 28px; text-align: left; color: #1e293b; text-decoration: none; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02), 0 2px 4px -1px rgba(0,0,0,0.01); transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1); display: flex; gap: 20px; align-items: center; }
        .card:hover { transform: translateY(-4px); box-shadow: 0 20px 25px -5px rgba(0,0,0,0.05), 0 10px 10px -5px rgba(0,0,0,0.02); border-color: #cbd5e1; }
        
        /* Card Left Icon Assembly */
        .icon-box { width: 64px; height: 64px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; transition: all 0.2s ease; }
        
        /* Individual Theme Palette Accents */
        .card-programming .icon-box { background: #eff6ff; color: #2563eb; }
        .card-software .icon-box { background: #fdf2f8; color: #db2777; }
        .card-business .icon-box { background: #f0fdf4; color: #16a34a; }
        .card-education .icon-box { background: #fdf6ee; color: #ea580c; }
        .card-health .icon-box { background: #f5f3ff; color: #7c3aed; }
        .card-games .icon-box { background: #f0fdfa; color: #0d9488; }

        /* Card Content Stack Typography */
        .card-details { display: flex; flex-direction: column; gap: 4px; }
        .card-title { font-size: 18px; font-weight: 700; color: #0f172a; }
        .card-subtitle { font-size: 14px; color: #64748b; font-weight: 500; display: flex; align-items: center; gap: 6px; }
        .card-subtitle::after { content: '→'; font-weight: bold; opacity: 0; transform: translateX(-4px); transition: all 0.2s ease; }
        
        /* Micro-Interaction Animation */
        .card:hover .card-subtitle::after { opacity: 1; transform: translateX(0); color: #0f172a; }

        /* ⚡ Premium Footer Layout Styling */
        footer { background-color: #0f172a; color: #94a3b8; border-top: 1px solid #1e293b; margin-top: auto; padding-top: 48px; }
        .footer-container { max-width: 1200px; margin: 0 auto; padding: 0 24px 40px 24px; display: flex; flex-wrap: wrap; justify-content: space-between; gap: 40px; }
        .footer-brand-side { max-width: 400px; }
        .footer-logo { color: #ffffff; font-size: 20px; font-weight: 700; text-decoration: none; display: flex; align-items: center; gap: 8px; margin-bottom: 16px; }
        .footer-logo span { border-bottom: 2px solid #f39c12; padding-bottom: 2px; }
        .footer-tagline { font-size: 14px; line-height: 1.6; color: #64748b; }
        .footer-links-side { display: flex; gap: 64px; }
        .footer-nav-col { display: flex; flex-direction: column; gap: 12px; }
        .footer-nav-col h4 { color: #f8fafc; font-size: 14px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .footer-nav-col a { color: #94a3b8; font-size: 14px; text-decoration: none; transition: color 0.2s; }
        .footer-nav-col a:hover { color: #e67e22; }
        .footer-bottom { background-color: #020617; text-align: center; padding: 24px; font-size: 13px; color: #475569; border-top: 1px solid #0f172a; }
        @media (max-width: 640px) { .footer-links-side { gap: 32px; width: 100%; justify-content: space-between; } }
    </style>
</head>
<body>

    <header>
        <a href="${pageContext.request.contextPath}/" class="logo">
            <i class="fa-solid fa-bolt" style="color: #f39c12;"></i> <span>Cheatography</span>
        </a>
        
        <div class="auth-buttons">
            <% if (session.getAttribute("currentUser") != null) { %>
                <a href="${pageContext.request.contextPath}/profile" class="btn-nav btn-profile"><i class="fa-solid fa-user-gear"></i> My Profile</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn-nav btn-logout"><i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login" class="btn-nav btn-login">Login</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-nav btn-register">Register</a>
            <% } %>
        </div>
    </header>

    <div class="container">
        
        <% 
            String msgAttr = (String) request.getAttribute("msg");
            String logoutParam = request.getParameter("logout");
            String errorParam = request.getParameter("error");
            
            if (msgAttr != null || logoutParam != null || errorParam != null) { 
        %>
            <div id="statusAlert" class="msg-alert <%= (errorParam != null) ? "msg-error" : "" %>">
                <% if (errorParam != null) { %>
                    <i class="fa-solid fa-triangle-exclamation"></i> Invalid credentials. Please check your details.
                <% } else if (logoutParam != null) { %>
                    <i class="fa-solid fa-circle-check"></i> You have logged out successfully.
                <% } else { %>
                    <i class="fa-solid fa-circle-info"></i> <%= msgAttr %>
                <% } %>
            </div>
        <% } %>

        <div class="hero-section">
            <h1 class="hero-title">Over 6,000 Free Cheat Sheets, Revision Aids and Quick References!</h1>
            <p class="hero-subtitle">Join our community of developers, students, and professionals to share and discover clear, concise reference summaries for any technical topic.</p>
        </div>

        <div class="grid-container">
            
            <a href="#" class="card card-programming">
                <div class="icon-box"><i class="fa-solid fa-code"></i></div>
                <div class="card-details">
                    <div class="card-title">Programming</div>
                    <div class="card-subtitle">Browse references</div>
                </div>
            </a>

            <a href="#" class="card card-software">
                <div class="icon-box"><i class="fa-solid fa-laptop-code"></i></div>
                <div class="card-details">
                    <div class="card-title">Software Applications</div>
                    <div class="card-subtitle">Browse references</div>
                </div>
            </a>

            <a href="#" class="card card-business">
                <div class="icon-box"><i class="fa-solid fa-chart-line"></i></div>
                <div class="card-details">
                    <div class="card-title">Business & Marketing</div>
                    <div class="card-subtitle">Browse references</div>
                </div>
            </a>

            <a href="#" class="card card-education">
                <div class="icon-box"><i class="fa-solid fa-graduation-cap"></i></div>
                <div class="card-details">
                    <div class="card-title">Education & Science</div>
                    <div class="card-subtitle">Browse references</div>
                </div>
            </a>

            <a href="#" class="card card-health">
                <div class="icon-box"><i class="fa-solid fa-heart-pulse"></i></div>
                <div class="card-details">
                    <div class="card-title">Home & Health</div>
                    <div class="card-subtitle">Browse references</div>
                </div>
            </a>

            <a href="#" class="card card-games">
                <div class="icon-box"><i class="fa-solid fa-gamepad"></i></div>
                <div class="card-details">
                    <div class="card-title">Games & Hobbies</div>
                    <div class="card-subtitle">Browse references</div>
                </div>
            </a>

        </div>
    </div>

    <footer>
        <div class="footer-container">
            <div class="footer-brand-side">
                <a href="${pageContext.request.contextPath}/" class="footer-logo">
                    <i class="fa-solid fa-bolt" style="color: #f39c12;"></i> <span>Cheatography</span>
                </a>
                <p class="footer-tagline">Your ultimate repository for crisp, concise, and developer-grade technical quick references and cheat sheets.</p>
            </div>
            
            <div class="footer-links-side">
                <div class="footer-nav-col">
                    <h4>Explore</h4>
                    <a href="#">Programming</a>
                    <a href="#">Applications</a>
                    <a href="#">Science Aids</a>
                </div>
                <div class="footer-nav-col">
                    <h4>Community</h4>
                    <a href="#">Create Sheet</a>
                    <a href="#">Popular Guides</a>
                    <a href="#">Discussions</a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 Cheatography Engine. Built for engineers, students, and speed learners.</p>
        </div>
    </footer>

    <script>
        window.addEventListener('DOMContentLoaded', () => {
            const alertBox = document.getElementById('statusAlert');
            if (alertBox) {
                setTimeout(() => {
                    alertBox.style.transition = "opacity 0.6s ease";
                    alertBox.style.opacity = "0";
                    
                    setTimeout(() => {
                        alertBox.style.display = "none";
                        const cleanUrl = window.location.protocol + "//" + window.location.host + window.location.pathname;
                        window.history.replaceState({ path: cleanUrl }, '', cleanUrl);
                    }, 600);
                }, 3000); 
            }
        });
    </script>
</body>
</html>