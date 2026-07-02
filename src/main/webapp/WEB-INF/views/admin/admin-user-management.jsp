<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hibernate.entity.User" %>
<%@ page import="com.hibernate.entity.UserProfile" %>
<%@ page import="com.hibernate.entity.UserPreference" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Panel - User Management</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; color: #1e293b; }
        
        .sidebar { width: 260px; background-color: #1e293b; color: #fff; position: fixed; height: 100vh; }
        .sidebar-brand { padding: 24px; font-size: 20px; font-weight: bold; background-color: #0f172a; text-align: center; color: #38bdf8; }
        .sidebar-menu { list-style: none; padding: 20px 0; }
        .sidebar-link { display: block; padding: 12px 16px; color: #cbd5e1; text-decoration: none; margin: 4px 15px; border-radius: 6px; font-size: 15px; }
        .sidebar-link:hover { background-color: #334155; color: #fff; }
        .sidebar-link.active { background-color: #0284c7; color: #fff; font-weight: 600; }
        
        .main-workspace { margin-left: 260px; flex-grow: 1; padding: 40px; }
        h2 { font-size: 24px; color: #0f172a; font-weight: 700; margin-bottom: 20px; }
        .table-container { background: white; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); padding: 24px; border: 1px solid #e2e8f0; overflow-x: auto; }
        
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 14px; border-bottom: 1px solid #e2e8f0; font-size: 14px; vertical-align: middle; }
        th { background-color: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; font-size: 12px; letter-spacing: 0.5px; }
        
        .mini-avatar { width: 45px; height: 45px; border-radius: 50%; object-fit: cover; border: 2px solid #f1f5f9; }
        .avatar-letter { width: 45px; height: 45px; border-radius: 50%; background: #e2e8f0; display: inline-flex; align-items: center; justify-content: center; font-weight: bold; color: #475569; border: 2px solid #f1f5f9; }
        .bio-text { font-size: 13px; color: #64748b; max-width: 160px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-style: italic; }
        
        select { padding: 6px 10px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 13px; color: #334155; background-color: #fff; outline: none; }
        
        .btn { padding: 6px 14px; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; text-decoration: none; font-size: 12px; display: inline-flex; align-items: center; transition: all 0.2s; }
        .btn-update { background-color: #10b981; color: white; margin-right: 4px; }
        .btn-view { background-color: #3b82f6; color: white; margin-right: 4px; }
        .btn-delete { background-color: #ef4444; color: white; }
        
        /* --- VIEW MODAL STYLES --- */
        .modal-mask { position: fixed; top:0; left:0; width:100vw; height:100vh; background: rgba(15, 23, 42, 0.6); display: flex; align-items: center; justify-content: center; opacity: 0; pointer-events: none; transition: opacity 0.3s ease; z-index: 999; }
        .modal-mask.open { opacity: 1; pointer-events: auto; }
        .modal-body { background: white; width: 100%; max-width: 500px; padding: 32px; border-radius: 16px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); transform: scale(0.9); transition: transform 0.3s ease; position: relative; }
        .modal-mask.open .modal-body { transform: scale(1); }
        
        .modal-header-profile { display: flex; align-items: center; gap: 20px; margin-bottom: 20px; border-bottom: 2px solid #f1f5f9; padding-bottom: 16px; }
        .modal-avatar { width: 75px; height: 75px; border-radius: 50%; object-fit: cover; border: 3px solid #f1f5f9; }
        .modal-avatar-letter { width: 75px; height: 75px; border-radius: 50%; background: #e2e8f0; display: inline-flex; align-items: center; justify-content: center; font-weight: bold; color: #475569; border: 3px solid #f1f5f9; font-size: 28px; }
        
        .modal-name { font-size: 20px; font-weight: 700; color: #0f172a; }
        .modal-username { color: #0284c7; font-weight: 600; font-size: 14px; }
        
        .modal-section-title { font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; margin: 16px 0 8px 0; display: block; }
        .modal-bio { font-size: 14px; color: #475569; font-style: italic; background: #f8fafc; padding: 12px; border-radius: 8px; line-height: 1.5; min-height: 42px; }
        
        .modal-info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; font-size: 14px; background: #f8fafc; padding: 14px; border-radius: 8px; }
        .modal-info-row { display: flex; flex-direction: column; gap: 2px; }
        .modal-label { color: #64748b; font-weight: 500; font-size: 12px; }
        .modal-val { color: #1e293b; font-weight: 600; }
        
        .modal-close-x { position: absolute; top: 16px; right: 20px; background: none; border: none; font-size: 20px; color: #94a3b8; cursor: pointer; }
    </style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-brand">CheatSheet Admin 👑</div>
        <ul class="sidebar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link">📊 Core Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users" class="sidebar-link active">👥 User Management</a></li>
        </ul>
    </aside>

    <div class="main-workspace">
        <h2>System User Registry & Full Profiles</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Photo</th>
                        <th>Account Details</th>
                        <th>Full Name</th>
                        <th>Gender</th>
                        <th>Biography Snippet</th>
                        <th>System Role</th>
                        <th>Account Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<User> users = (List<User>) request.getAttribute("users");
                        if(users != null) {
                            for(User u : users) {
                                UserProfile prof = u.getProfile(); 
                                
                                String fullName = (prof != null && prof.getFullName() != null) ? prof.getFullName() : "No Profile Linked";
                                String gender = (prof != null && prof.getGender() != null) ? prof.getGender() : "N/A";
                                String bio = (prof != null && prof.getBio() != null) ? prof.getBio() : "No biography compiled yet.";
                                
                                // 🔥 FIX: Changed getPreference() to getPreferences() to match your entity model!
                                UserPreference pref = u.getPreferences();
                                
                                String theme = (pref != null && pref.getTheme() != null) ? pref.getTheme().name() : "SYSTEM";
                                String lang = (pref != null && pref.getLanguageCode() != null) ? pref.getLanguageCode() : "en";
                                String mailAlerts = (pref != null && pref.getEmailNotifications() != null && pref.getEmailNotifications()) ? "Enabled" : "Disabled";
                                String pushAlerts = (pref != null && pref.getPushNotifications() != null && pref.getPushNotifications()) ? "Enabled" : "Disabled";
                                String allowDMs = (pref != null && pref.getAllowMessages() != null && pref.getAllowMessages()) ? "Allowed" : "Blocked";
                                String visibility = (pref != null && pref.getProfileVisibility() != null) ? pref.getProfileVisibility().name() : "PUBLIC";
                                
                                String initialLetter = "U";
                                if (u.getUsername() != null && !u.getUsername().trim().isEmpty()) {
                                    initialLetter = u.getUsername().substring(0, 1).toUpperCase();
                                }
                                
                                boolean hasRealAvatar = (prof != null && prof.getAvatar() != null && prof.getAvatar().length > 0);
                                String rawAvatarSrc = "";
                                String imgHtml = "<div class='avatar-letter'>" + initialLetter + "</div>";
                                
                                if (hasRealAvatar) {
                                    String base64Img = Base64.getEncoder().encodeToString(prof.getAvatar());
                                    rawAvatarSrc = "data:image/jpeg;base64," + base64Img.replaceAll("[\\r\\n\\s]+", "");
                                    imgHtml = "<img src='" + rawAvatarSrc + "' class='mini-avatar' alt='Avatar' />";
                                }
                    %>
                    <tr>
                        <td><%= imgHtml %></td>
                        <td>
                            <strong>@<%= u.getUsername() %></strong><br/>
                            <span style="font-size:12px; color:#64748b;"><%= u.getEmail() %></span>
                        </td>
                        <td><%= fullName %></td>
                        <td><span style="text-transform: capitalize;"><%= gender %></span></td>
                        <td><div class="bio-text" title="<%= bio %>">"<%= bio %>"</div></td>
                        
                        <form action="${pageContext.request.contextPath}/admin/users/update-status" method="POST">
                            <input type="hidden" name="userId" value="<%= u.getId() %>" />
                            <td>
                                <select name="role">
                                    <option value="USER" <%= u.getRole().name().equals("USER")?"selected":"" %>>USER</option>
                                    <option value="ADMIN" <%= u.getRole().name().equals("ADMIN")?"selected":"" %>>ADMIN</option>
                                </select>
                            </td>
                            <td>
                                <select name="status">
                                    <option value="ACTIVE" <%= u.getStatus().name().equals("ACTIVE")?"selected":"" %>>ACTIVE</option>
                                    <option value="SUSPENDED" <%= u.getStatus().name().equals("SUSPENDED")?"selected":"" %>>SUSPENDED</option>
                                    <option value="INACTIVE" <%= u.getStatus().name().equals("INACTIVE")?"selected":"" %>>INACTIVE</option>
                                </select>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center;">
                                    <button type="submit" class="btn btn-update">Update</button>
                                    
                                    <button type="button" 
                                            class="btn btn-view" 
                                            data-name="<%= fullName.replace("\"", "&quot;") %>"
                                            data-username="<%= u.getUsername() != null ? u.getUsername().replace("\"", "&quot;") : "" %>"
                                            data-gender="<%= gender %>"
                                            data-bio="<%= bio.replace("\"", "&quot;").replace("\n", " ").replace("\r", "") %>"
                                            data-hasavatar="<%= hasRealAvatar %>"
                                            data-letter="<%= initialLetter %>"
                                            data-role="<%= u.getRole().name() %>"
                                            data-status="<%= u.getStatus().name() %>"
                                            data-theme="<%= theme %>"
                                            data-lang="<%= lang %>"
                                            data-mail="<%= mailAlerts %>"
                                            data-push="<%= pushAlerts %>"
                                            data-dms="<%= allowDMs %>"
                                            data-visibility="<%= visibility %>"
                                            onclick="openProfileInspector(this)">View</button>                                    
                                    <a href="${pageContext.request.contextPath}/admin/users/delete?id=<%= u.getId() %>" class="btn btn-delete" onclick="return confirm('Execute Soft Delete?');">Delete</a>
                                </div>
                            </td>
                        </form>
                    </tr>
                    <%      }
                        } 
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal-mask" id="inspectorModal" onclick="closeProfileInspector(event)">
        <div class="modal-body" onclick="event.stopPropagation()">
            <button class="modal-close-x" onclick="document.getElementById('inspectorModal').classList.remove('open')">&times;</button>
            
            <div class="modal-header-profile">
                <div id="modalAvatarSlot"></div>
                <div>
                    <div class="modal-name" id="modalName">Name</div>
                    <div class="modal-username" id="modalUsername">@username</div>
                </div>
            </div>
            
            <span class="modal-section-title">Biography</span>
            <div class="modal-bio" id="modalBio">"Bio."</div>
            
            <span class="modal-section-title">Core Identity Profile</span>
            <div class="modal-info-grid" style="margin-bottom: 14px;">
                <div class="modal-info-row"><span class="modal-label">Gender Axis:</span><span class="modal-val" id="modalGender">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">System Role:</span><span class="modal-val" id="modalRole">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Account Status:</span><span class="modal-val" id="modalStatus">N/A</span></div>
            </div>

            <span class="modal-section-title">User Default App Parameters</span>
            <div class="modal-info-grid">
                <div class="modal-info-row"><span class="modal-label">UI Theme Canvas:</span><span class="modal-val" id="modalTheme">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Language Node:</span><span class="modal-val" id="modalLang">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Mail Digests:</span><span class="modal-val" id="modalMailAlerts">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Push Alerts:</span><span class="modal-val" id="modalPushAlerts">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Direct Messages:</span><span class="modal-val" id="modalDMs">N/A</span></div>
                <div class="modal-info-row"><span class="modal-label">Discovery Privacy:</span><span class="modal-val" id="modalVisibility">N/A</span></div>
            </div>
        </div>
    </div>

    <script>
        function openProfileInspector(button) {
            const name = button.getAttribute('data-name') || 'No Name Attached';
            const username = button.getAttribute('data-username');
            const gender = button.getAttribute('data-gender') || 'N/A';
            const bio = button.getAttribute('data-bio') || 'No biography compiled yet.';
            const hasAvatar = button.getAttribute('data-hasavatar') === 'true';
            const fallbackLetter = button.getAttribute('data-letter') || 'U';
            
            const role = button.getAttribute('data-role') || 'N/A';
            const status = button.getAttribute('data-status') || 'N/A';
            const theme = button.getAttribute('data-theme') || 'N/A';
            const lang = button.getAttribute('data-lang') || 'N/A';
            const mailAlerts = button.getAttribute('data-mail') || 'N/A';
            const pushAlerts = button.getAttribute('data-push') || 'N/A';
            const allowDMs = button.getAttribute('data-dms') || 'N/A';
            const visibility = button.getAttribute('data-visibility') || 'N/A';
        
            document.getElementById('modalName').textContent = name;
            document.getElementById('modalUsername').textContent = username ? "@" + username : "@User";
            document.getElementById('modalBio').textContent = `"${bio}"`;
            
            document.getElementById('modalGender').textContent = gender;
            document.getElementById('modalRole').textContent = role;
            document.getElementById('modalStatus').textContent = status;
            document.getElementById('modalTheme').textContent = theme;
            document.getElementById('modalLang').textContent = lang.toUpperCase();
            document.getElementById('modalMailAlerts').textContent = mailAlerts;
            document.getElementById('modalPushAlerts').textContent = pushAlerts;
            document.getElementById('modalDMs').textContent = allowDMs;
            document.getElementById('modalVisibility').textContent = visibility;
            
            const avatarSlot = document.getElementById('modalAvatarSlot');
            avatarSlot.innerHTML = ""; 
            
            if (hasAvatar) {
                const currentRow = button.closest('tr');
                const workingTableImg = currentRow ? currentRow.querySelector('.mini-avatar') : null;
                
                if (workingTableImg) {
                    const clonedImg = workingTableImg.cloneNode(true);
                    clonedImg.className = "modal-avatar"; 
                    avatarSlot.appendChild(clonedImg);
                } else {
                    avatarSlot.innerHTML = `<div class="modal-avatar-letter">${fallbackLetter}</div>`;
                }
            } else {
                avatarSlot.innerHTML = `<div class="modal-avatar-letter">${fallbackLetter}</div>`;
            }
            
            document.getElementById('inspectorModal').classList.add('open');
        }
        
        function closeProfileInspector(event) {
            document.getElementById('inspectorModal').classList.remove('open');
        }
    </script>
</body>
</html>