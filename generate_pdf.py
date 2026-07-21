import os
import sys
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, HRFlowable, PageBreak
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

# Register Myanmar Text Font
font_path = "C:\\Windows\\Fonts\\mmrtext.ttf"
font_bold_path = "C:\\Windows\\Fonts\\mmrtextb.ttf"

if os.path.exists(font_path):
    pdfmetrics.registerFont(TTFont('MMFont', font_path))
    font_name = 'MMFont'
else:
    font_name = 'Helvetica'

if os.path.exists(font_bold_path):
    pdfmetrics.registerFont(TTFont('MMFontBold', font_bold_path))
    font_bold_name = 'MMFontBold'
else:
    font_bold_name = font_name

pdf_path = r"c:\Users\user\OJT\CS_GROUP_PROJECT_MVC\Presentation_Code_Guide_CS_Group_Project.pdf"

doc = SimpleDocTemplate(
    pdf_path,
    pagesize=letter,
    rightMargin=36, leftMargin=36, topMargin=36, bottomMargin=36
)

styles = getSampleStyleSheet()

# Custom Styles
title_style = ParagraphStyle(
    'DocTitle',
    parent=styles['Heading1'],
    fontName=font_bold_name,
    fontSize=18,
    leading=23,
    textColor=colors.HexColor('#1E293B'),
    alignment=1, # Center
    spaceAfter=8
)

subtitle_style = ParagraphStyle(
    'DocSubTitle',
    parent=styles['Normal'],
    fontName=font_name,
    fontSize=10,
    leading=14,
    textColor=colors.HexColor('#475569'),
    alignment=1,
    spaceAfter=15
)

h1_style = ParagraphStyle(
    'SectionH1',
    parent=styles['Heading2'],
    fontName=font_bold_name,
    fontSize=13,
    leading=17,
    textColor=colors.HexColor('#0F172A'),
    spaceBefore=12,
    spaceAfter=6,
    keepWithNext=True
)

h2_style = ParagraphStyle(
    'SectionH2',
    parent=styles['Heading3'],
    fontName=font_bold_name,
    fontSize=10.5,
    leading=14,
    textColor=colors.HexColor('#2563EB'),
    spaceBefore=8,
    spaceAfter=4,
    keepWithNext=True
)

body_style = ParagraphStyle(
    'BodyTextCustom',
    parent=styles['Normal'],
    fontName=font_name,
    fontSize=9,
    leading=13,
    textColor=colors.HexColor('#334155'),
    spaceAfter=5
)

table_header_style = ParagraphStyle(
    'TableHeader',
    parent=styles['Normal'],
    fontName=font_bold_name,
    fontSize=9,
    leading=12,
    textColor=colors.white
)

table_cell_style = ParagraphStyle(
    'TableCell',
    parent=styles['Normal'],
    fontName=font_name,
    fontSize=8,
    leading=11,
    textColor=colors.HexColor('#1E293B')
)

func_header_style = ParagraphStyle(
    'FuncHeader',
    parent=styles['Normal'],
    fontName=font_bold_name,
    fontSize=9,
    leading=13,
    textColor=colors.HexColor('#1E3A8A'),
    spaceBefore=4,
    spaceAfter=2,
    keepWithNext=True
)

func_desc_style = ParagraphStyle(
    'FuncDesc',
    parent=styles['Normal'],
    fontName=font_name,
    fontSize=8,
    leading=11.5,
    textColor=colors.HexColor('#475569'),
    leftIndent=12,
    spaceAfter=3
)

elements = []

# Title Banner
elements.append(Paragraph("CS Group Project MVC - Code & Presentation Guide", title_style))
elements.append(Paragraph("Presentation Reference Document for 5 Modules: Chat, Report, Jasper Report, Notifications, Event Announcements", subtitle_style))
elements.append(HRFlowable(width="100%", thickness=1.5, color=colors.HexColor('#2563EB'), spaceAfter=15))

def make_table(data):
    formatted_data = []
    for i, row in enumerate(data):
        formatted_row = []
        for cell in row:
            if i == 0:
                formatted_row.append(Paragraph(cell, table_header_style))
            else:
                formatted_row.append(Paragraph(cell, table_cell_style))
        formatted_data.append(formatted_row)
    
    t = Table(formatted_data, colWidths=[150, 200, 190])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#1E293B')),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('LEFTPADDING', (0, 0), (-1, -1), 5),
        ('RIGHTPADDING', (0, 0), (-1, -1), 5),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#CBD5E1')),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor('#F8FAFC')])
    ]))
    return t

# --- MODULE 1 ---
elements.append(Paragraph("1. 💬 Chat System (Direct & Group Chat with WebSockets)", h1_style))
elements.append(Paragraph("<b>Overview:</b> Real-time direct & group messaging system using WebSockets for live updates, REST APIs for message operations (send, edit, delete, react, report, block), and database persistence using Hibernate JPA.", body_style))

chat_data = [
    ["File Name", "Role / Path", "Key Functionality / Notes"],
    ["ChatController.java", "src/main/java/com/hibernate/controller/ChatController.java", "REST endpoints for messaging actions (send, edit, delete, react, block, report)."],
    ["ChatPageController.java", "src/main/java/com/hibernate/controller/ChatPageController.java", "Page routing for /chat and /chat/room views."],
    ["ChatWebSocketHandler.java", "src/main/java/com/hibernate/websocket/ChatWebSocketHandler.java", "WebSocket connection session handler & text payload routing."],
    ["ChatEventBroadcaster.java", "src/main/java/com/hibernate/websocket/ChatEventBroadcaster.java", "Broadcasts real-time events (new message, typing, reactions, read receipts)."],
    ["ChatService.java / Impl", "src/main/java/com/hibernate/service/ChatServiceImpl.java", "Core business logic for conversation creation, message saving & read status."],
    ["MessageMapper.java", "src/main/java/com/hibernate/service/MessageMapper.java", "Converts Message entities into MessageResponse DTOs."],
    ["Conversation.java", "src/main/java/com/hibernate/entity/Conversation.java", "Entity table storing chat room metadata (direct vs group)."],
    ["ConversationParticipant.java", "src/main/java/com/hibernate/entity/ConversationParticipant.java", "Mapping table linking users to chat rooms with roles."],
    ["Message.java", "src/main/java/com/hibernate/entity/Message.java", "Entity storing message text, sender, timestamp, and edit flags."],
    ["MessageAttachment.java", "src/main/java/com/hibernate/entity/MessageAttachment.java", "Stores attached file paths and media metadata."],
    ["MessageReaction.java", "src/main/java/com/hibernate/entity/MessageReaction.java", "Stores user emoji reactions on messages."],
    ["MessageSeenStatus.java", "src/main/java/com/hibernate/entity/MessageSeenStatus.java", "Tracks read/seen status for each room participant."],
    ["chat.jsp", "src/main/webapp/WEB-INF/views/chat/chat.jsp", "Main Inbox UI listing active chat conversations."],
    ["room.jsp", "src/main/webapp/WEB-INF/views/chat/room.jsp", "Active Chat Room UI with WebSocket JS client connection."],
    ["create-group.jsp", "src/main/webapp/WEB-INF/views/chat/create-group.jsp", "UI dialog for starting a new group conversation."]
]
elements.append(make_table(chat_data))
elements.append(Spacer(1, 6))

elements.append(Paragraph("<b>🛠️ Key Functions and Capabilities (What They Can Do)</b>", h2_style))

elements.append(Paragraph("<b>ChatController.java (REST API Endpoints)</b>", func_header_style))
elements.append(Paragraph("• <code>toggleReaction(messageId, request, session)</code>: Toggles a user's emoji reaction on a message (adds if absent, removes if present) and broadcasts the event via WebSockets.", func_desc_style))
elements.append(Paragraph("• <code>getInbox(session)</code>: Fetches all active direct and group conversations for the logged-in user's inbox list.", func_desc_style))
elements.append(Paragraph("• <code>searchUsers(keyword, session)</code>: Searches for users by username or display name to initiate new direct chats.", func_desc_style))
elements.append(Paragraph("• <code>startDirectChat(userId, session)</code>: Initiates a direct message room between the logged-in user and target user (or returns the existing room ID).", func_desc_style))
elements.append(Paragraph("• <code>createConversation(request, session)</code>: Creates a group conversation with a designated title and user participant IDs.", func_desc_style))
elements.append(Paragraph("• <code>sendMessage(request, session)</code>: Persists a new text message in the database, handling replies via parent message ID, and triggers WebSocket broadcast.", func_desc_style))
elements.append(Paragraph("• <code>editMessage(messageId, request, session)</code>: Modifies an existing message's text, tags it as edited, and broadcasts the modification.", func_desc_style))
elements.append(Paragraph("• <code>markMessagesAsRead(request, session)</code>: Marks all messages in a conversation up to a specific message ID as read for the user, broadcasting read receipts.", func_desc_style))
elements.append(Paragraph("• <code>reportMessage(messageId, request, session)</code>: Submits a moderation report for a chat message, defining the violation reason and description.", func_desc_style))
elements.append(Paragraph("• <code>deleteConversation(conversationId, session)</code>: Performs a soft-delete (clears history) of a conversation for the active user.", func_desc_style))
elements.append(Paragraph("• <code>blockUser(userId, session)</code> / <code>unblockUser(userId, session)</code>: Blocks/unblocks a user to restrict or restore direct messaging capabilities.", func_desc_style))
elements.append(Paragraph("• <code>deleteMessage(messageId, session)</code>: Deletes a message from the database and broadcasts the deletion to room participants.", func_desc_style))
elements.append(Paragraph("• <code>sendMediaMessage(conversationId, caption, files, session)</code>: Handles multi-file uploads (attachments), saves the media message, and broadcasts it.", func_desc_style))
elements.append(Paragraph("• <code>getChatHistory(conversationId, lastMessageId, session)</code>: Fetches past messages from a room using pagination for infinite scrolling.", func_desc_style))
elements.append(Paragraph("• <code>getRoomDetails(conversationId, session)</code>: Retrieves metadata, partner info, and blocking status of a specific chat room.", func_desc_style))

elements.append(Paragraph("<b>ChatPageController.java (Page Routing)</b>", func_header_style))
elements.append(Paragraph("• <code>showChatDashboard(session, model)</code>: Renders the inbox view showing all active chats.", func_desc_style))
elements.append(Paragraph("• <code>showChatRoom(conversationId, session, model)</code>: Fetches conversation info, partner statuses, blocking parameters, and renders the chat room page.", func_desc_style))
elements.append(Paragraph("• <code>showCreateGroupForm(session)</code>: Displays the page to create new group chat conversations.", func_desc_style))
elements.append(Paragraph("• <code>createGroupChat(title, usernames, session, model)</code>: Validates group title and participant usernames, saves the group chat room, and redirects the user to the new room.", func_desc_style))

elements.append(Paragraph("<b>ChatWebSocketHandler.java (WebSocket Routing & Connections)</b>", func_header_style))
elements.append(Paragraph("• <code>afterConnectionEstablished(session)</code>: Registers active WebSocket sessions, updates user online status in the database, and broadcasts the status.", func_desc_style))
elements.append(Paragraph("• <code>handleTextMessage(session, message)</code>: Parses and handles client JSON payloads for typing indicators, stopped typing indicators, message edits, and new message sends.", func_desc_style))
elements.append(Paragraph("• <code>afterConnectionClosed(session, status)</code>: Unregisters sessions, sets user status to offline if no active connections remain, and broadcasts the status (with last seen time).", func_desc_style))

elements.append(Paragraph("<b>ChatEventBroadcaster.java (Event Dispatcher)</b>", func_header_style))
elements.append(Paragraph("• <code>broadcastPayload(conversationId, payload)</code>: Dispatches a JSON packet to active WebSocket sessions of conversation participants.", func_desc_style))
elements.append(Paragraph("• <code>broadcastNewMessage(...) / broadcastEditedMessage(...) / broadcastDeletedMessage(...)</code>: Transmits message changes to subscribers in real-time.", func_desc_style))
elements.append(Paragraph("• <code>broadcastReaction(...) / broadcastReadReceipt(...)</code>: Delivers reaction changes and read indicators instantly.", func_desc_style))
elements.append(Paragraph("• <code>broadcastUserTyping(...) / broadcastUserStoppedTyping(...)</code>: Delivers active typing states to room participants.", func_desc_style))
elements.append(Paragraph("• <code>broadcastUserStatus(userId, isOnline, lastSeen)</code>: Broadcasts a user's status change (online/offline) to all active WebSocket sessions globally.", func_desc_style))

elements.append(Spacer(1, 10))
elements.append(PageBreak())

# --- MODULE 2 ---
elements.append(Paragraph("2. 🚩 Report System (Post, Comment & Message Moderation)", h1_style))
elements.append(Paragraph("<b>Overview:</b> Multi-tiered reporting system allowing users to report inappropriate posts, comments, or chat messages. Admin dashboard groups reports per item and allows moderation actions (dismiss or delete content).", body_style))

report_data = [
    ["File Name", "Role / Path", "Key Functionality / Notes"],
    ["ReportController.java", "src/main/java/com/hibernate/controller/ReportController.java", "User API endpoint to submit post reports (/api/reports)."],
    ["CommentReportController.java", "src/main/java/com/hibernate/controller/CommentReportController.java", "User API endpoint to report comments (/api/comments/{id}/report)."],
    ["AdminReportController.java", "src/main/java/com/hibernate/controller/AdminReportController.java", "Admin Controller to review grouped reports & execute dismiss/delete actions."],
    ["ReportService / Impl", "src/main/java/com/hibernate/service/ReportServiceImpl.java", "Groups multiple reports by target post, calculates counts and reason lists."],
    ["AdminCommentService / Impl", "src/main/java/com/hibernate/service/AdminCommentServiceImpl.java", "Service logic for fetching and managing grouped comment reports."],
    ["PostReport.java", "src/main/java/com/hibernate/entity/PostReport.java", "Entity table storing post report entries."],
    ["CommentReport.java", "src/main/java/com/hibernate/entity/CommentReport.java", "Entity table storing comment report entries."],
    ["GroupedPostReportDto.java", "src/main/java/com/hibernate/dto/GroupedPostReportDto.java", "DTO containing post info, total report count, and list of reporter reasons."],
    ["GroupedCommentReportDto.java", "src/main/java/com/hibernate/dto/GroupedCommentReportDto.java", "DTO containing comment info and aggregated report data."],
    ["reports.jsp", "src/main/webapp/WEB-INF/views/admin/reports.jsp", "Admin Moderation Dashboard UI for reviewing reported posts and comments."]
]
elements.append(make_table(report_data))
elements.append(Spacer(1, 6))

elements.append(Paragraph("<b>🛠️ Key Functions and Capabilities (What They Can Do)</b>", h2_style))

elements.append(Paragraph("<b>ReportController.java (Post Reporting)</b>", func_header_style))
elements.append(Paragraph("• <code>reportPost(id, reason, description, session)</code>: Saves a post report record, saving the reporting user ID, target post ID, violation category, and optional custom text.", func_desc_style))

elements.append(Paragraph("<b>CommentReportController.java (Comment Reporting)</b>", func_header_style))
elements.append(Paragraph("• <code>reportComment(id, reason, description, session)</code>: Saves a comment report record for a comment ID, logging the violator and description.", func_desc_style))

elements.append(Paragraph("<b>AdminReportController.java (Moderation Dashboard & Actions)</b>", func_header_style))
elements.append(Paragraph("• <code>viewReports(type, view, model, session)</code>: Renders the reports list filtered by type (posts/comments) and view (active queue/historical reports).", func_desc_style))
elements.append(Paragraph("• <code>dismissPostReport(id, session) / dismissCommentReport(id, session)</code>: Dismisses a specific report by marking the item as safe in the database.", func_desc_style))
elements.append(Paragraph("• <code>resolvePostReport(id, reason, session) / resolveCommentReport(id, reason, session)</code>: Resolves a single report by marking it resolved and deleting the reported content.", func_desc_style))
elements.append(Paragraph("• <code>dismissGroupedPostReport(postId, session) / dismissGroupedCommentReport(commentId, session)</code>: Dismisses all active reports targeting a specific post or comment in bulk.", func_desc_style))
elements.append(Paragraph("• <code>resolveGroupedPostReport(postId, reason, duration, banType, session) / resolveGroupedCommentReport(commentId, reason, duration, banType, session)</code>: Bulk-resolves reports by deleting the post or comment and applying a temporary user suspension (banning the user's posting, commenting, or all privileges) for a set duration.", func_desc_style))

elements.append(Paragraph("<b>ReportService.java (Moderation Business Logic)</b>", func_header_style))
elements.append(Paragraph("• <code>getGroupedPendingPostReports() / getGroupedPendingCommentReports()</code>: Groups database reports by target content and wraps them inside DTOs, counting total reports and aggregating reporter reasons for cleaner UI listing.", func_desc_style))
elements.append(Paragraph("• <code>dismissAllPostReportsByPostId(adminId, postId) / dismissAllCommentReportsByCommentId(...)</code>: Performs database updates to change status of all reports on a specific content to DISMISSED.", func_desc_style))
elements.append(Paragraph("• <code>resolveAllPostReportsByPostId(...) / resolveAllCommentReportsByCommentId(...)</code>: Marks reports as RESOLVED, soft-deletes the target item, and inserts a user suspension row.", func_desc_style))

elements.append(Spacer(1, 10))
elements.append(PageBreak())

# --- MODULE 3 ---
elements.append(Paragraph("3. 📊 Jasper Report Generation (Monthly CheatSheet Report)", h1_style))
elements.append(Paragraph("<b>Overview:</b> Analytics PDF report generation using JasperReports library. Fetches monthly data, compiles XML template (.jrxml), populates DTO fields, and streams PDF directly to admin browser.", body_style))

jasper_data = [
    ["File Name", "Role / Path", "Key Functionality / Notes"],
    ["CheatSheetReportController.java", "src/main/java/com/hibernate/controller/CheatSheetReportController.java", "Admin REST endpoints (/admin/reports/cheatsheet/pdf) to trigger PDF export."],
    ["CheatSheetReportService / Impl", "src/main/java/com/hibernate/service/CheatSheetReportServiceImpl.java", "Compiles JRXML template, fills data source, and converts report to byte[] PDF."],
    ["CheatSheetReportDto.java", "src/main/java/com/hibernate/dto/CheatSheetReportDto.java", "Data Transfer Object holding total posts, total views, active users, top posts."],
    ["monthly_cheat_sheet_report.jrxml", "src/main/resources/reports/monthly_cheat_sheet_report.jrxml", "Jasper Studio XML design template defining tables, headers, styling."],
    ["cheatsheet-report.jsp", "src/main/webapp/WEB-INF/views/admin/cheatsheet-report.jsp", "Admin page UI to select month/year and preview/download PDF reports."]
]
elements.append(make_table(jasper_data))
elements.append(Spacer(1, 6))

elements.append(Paragraph("<b>🛠️ Key Functions and Capabilities (What They Can Do)</b>", h2_style))

elements.append(Paragraph("<b>CheatSheetReportController.java (Report Request Controller)</b>", func_header_style))
elements.append(Paragraph("• <code>viewCheatSheetReport(page, pageSize, model, session)</code>: Fetches paginated cheat sheet statistics list and renders the dashboard UI.", func_desc_style))
elements.append(Paragraph("• <code>downloadPdf(session)</code>: Invokes PDF generation and returns the binary array as an inline PDF attachment stream to the browser.", func_desc_style))
elements.append(Paragraph("• <code>downloadExcel(session)</code>: Invokes Excel generation and returns the binary array as a downloadable spreadsheet.", func_desc_style))

elements.append(Paragraph("<b>CheatSheetReportService.java (Jasper Report Generator)</b>", func_header_style))
elements.append(Paragraph("• <code>getReportData()</code>: Queries the database for monthly metrics, including total cheat sheets, active writers, cumulative view counts, and active post trends.", func_desc_style))
elements.append(Paragraph("• <code>getTotalCheatSheetsCount()</code>: Computes the total quantity of cheat sheets saved in the database.", func_desc_style))
elements.append(Paragraph("• <code>generatePdfReport()</code>: Loads the Jasper template (<code>.jrxml</code>), fills it with the compiled data DTOs using <code>JasperFillManager</code>, processes it into PDF format, and returns the byte array.", func_desc_style))
elements.append(Paragraph("• <code>generateExcelReport()</code>: Exports the compiled report data as an Excel binary stream.", func_desc_style))

elements.append(Spacer(1, 10))
elements.append(PageBreak())

# --- MODULE 4 ---
elements.append(Paragraph("4. 🔔 Notification System (User Notifications & Advice)", h1_style))
elements.append(Paragraph("<b>Overview:</b> In-app notification mechanism triggering alerts for likes, comments, approvals, and announcements. Uses @ControllerAdvice to inject unread counts into all view headers globally.", body_style))

notif_data = [
    ["File Name", "Role / Path", "Key Functionality / Notes"],
    ["NotificationController.java", "src/main/java/com/hibernate/controller/NotificationController.java", "REST endpoints (/api/notifications) for fetching user notifications & mark-read."],
    ["NotificationAdvice.java", "src/main/java/com/hibernate/controller/NotificationAdvice.java", "@ControllerAdvice providing global unread notification count to all JSP views."],
    ["NotificationService / Impl", "src/main/java/com/hibernate/service/NotificationServiceImpl.java", "Core service for building, linking target URLs, and persisting notifications."],
    ["Notification.java", "src/main/java/com/hibernate/entity/Notification.java", "Entity table storing notification message, recipient, sender, type, and read flag."],
    ["NotificationRepository.java", "src/main/java/com/hibernate/repository/NotificationRepository.java", "JPA Repository fetching user notifications sorted by creation date."],
    ["notifications.jsp", "src/main/webapp/WEB-INF/views/notifications/notifications.jsp", "User notification list screen."]
]
elements.append(make_table(notif_data))
elements.append(Spacer(1, 6))

elements.append(Paragraph("<b>🛠️ Key Functions and Capabilities (What They Can Do)</b>", h2_style))

elements.append(Paragraph("<b>NotificationController.java (User Notifications Endpoints)</b>", func_header_style))
elements.append(Paragraph("• <code>listNotifications(session, model)</code>: Fetches all notifications for the active user and renders the notifications list page.", func_desc_style))
elements.append(Paragraph("• <code>markAsRead(id, session)</code>: Marks a specific notification as read and redirects back to notifications.", func_desc_style))
elements.append(Paragraph("• <code>markAllAsRead(session)</code>: Marks all unread notifications of the user as read.", func_desc_style))

elements.append(Paragraph("<b>NotificationAdvice.java (Global Controller Interceptor)</b>", func_header_style))
elements.append(Paragraph("• <code>addUnreadNotificationCount(session, model)</code>: Runs globally before all controllers. It checks if the current user has been fully banned, automatically logging them out if so. If not, it updates the session and model attributes with the fresh database state (<code>dbUser</code>) and binds the global <code>unreadNotificationCount</code> and <code>totalUnreadChatCount</code> badges to display in the header menu.", func_desc_style))

elements.append(Paragraph("<b>NotificationService.java (Notification Builder & Repository Manager)</b>", func_header_style))
elements.append(Paragraph("• <code>createNotification(userId, type, title, message, referenceType, referenceId)</code>: Constructs a new notification instance (e.g. LIKE, COMMENT, APPROVE) with target URLs, saving it to the database.", func_desc_style))
elements.append(Paragraph("• <code>broadcastNotification(type, title, message, referenceType, referenceId)</code>: Instantiates and saves a notification to all registered active users in the system.", func_desc_style))
elements.append(Paragraph("• <code>getNotificationsForUser(userId)</code>: Queries all user notification records, sorted by date (newest first).", func_desc_style))
elements.append(Paragraph("• <code>getUnreadCount(userId)</code>: Returns the number of unread notifications for a user.", func_desc_style))
elements.append(Paragraph("• <code>markAsRead(notificationId, userId) / markAllAsRead(userId)</code>: Updates read status flags to true in the database.", func_desc_style))

elements.append(Spacer(1, 10))
elements.append(PageBreak())

# --- MODULE 5 ---
elements.append(Paragraph("5. 📢 Event Announcement System", h1_style))
elements.append(Paragraph("<b>Overview:</b> System-wide announcement management by Admins. Creating an announcement automatically dispatches notifications to all target users and displays banners on user feeds.", body_style))

ann_data = [
    ["File Name", "Role / Path", "Key Functionality / Notes"],
    ["AdminAnnouncementController.java", "src/main/java/com/hibernate/controller/AdminAnnouncementController.java", "Admin REST endpoints (/admin/announcements) for CRUD operations."],
    ["AnnouncementService / Impl", "src/main/java/com/hibernate/service/AnnouncementServiceImpl.java", "Saves announcement and calls NotificationService to alert all users."],
    ["Announcement.java", "src/main/java/com/hibernate/entity/Announcement.java", "Entity table storing title, content, target role, publication status, timestamps."],
    ["AnnouncementRepository.java", "src/main/java/com/hibernate/repository/AnnouncementRepository.java", "JPA Repository for querying active published announcements."],
    ["announcements.jsp", "src/main/webapp/WEB-INF/views/admin/announcements.jsp", "Admin UI for drafting, publishing, and managing announcements."]
]
elements.append(make_table(ann_data))
elements.append(Spacer(1, 6))

elements.append(Paragraph("<b>🛠️ Key Functions and Capabilities (What They Can Do)</b>", h2_style))

elements.append(Paragraph("<b>AdminAnnouncementController.java (Admin Announcement CRUD)</b>", func_header_style))
elements.append(Paragraph("• <code>listAnnouncements(...) / createAnnouncement(...) / deleteAnnouncement(...)</code>: CRUD endpoints allowing administrators to draft, edit, publish, or remove global announcements.", func_desc_style))

elements.append(Paragraph("<b>AnnouncementService.java (Announcement Broadcast Coordinator)</b>", func_header_style))
elements.append(Paragraph("• <code>publishAnnouncement(announcement)</code>: Saves the announcement and calls <code>NotificationService.broadcastNotification(...)</code> to alert all target users.", func_desc_style))

elements.append(Spacer(1, 10))
elements.append(HRFlowable(width="100%", thickness=1, color=colors.HexColor('#CBD5E1'), spaceAfter=10))

# --- ARCHITECTURE & DEFENSE TIPS ---
elements.append(Paragraph("💡 Presentation & Teacher Defense Key Points", h1_style))
bullets = [
    "<b>1. Architecture Pattern:</b> The application follows the standard <b>Spring MVC Architecture</b> (Controller → Service → Repository → Database Entity → View/JSP). REST endpoints return JSON/PDF streams while page controllers render JSP views.",
    "<b>2. Real-time Communication (WebSocket):</b> Chat functionality uses <code>ChatWebSocketHandler</code> for bidirectional low-latency messaging, combined with <code>ChatService</code> for DB persistence.",
    "<b>3. Grouped Moderation Logic:</b> To prevent duplicate UI items in admin moderation, <code>GroupedPostReportDto</code> aggregates multiple reports targeting the same post into a single row with total report counts and concatenated reasons.",
    "<b>4. Jasper Export Flow:</b> Monthly metrics are compiled into a <code>CheatSheetReportDto</code>, passed to <code>JasperFillManager</code> alongside <code>monthly_cheat_sheet_report.jrxml</code>, and rendered as a PDF byte stream via HTTP Response.",
    "<b>5. Global Notification Advice:</b> <code>NotificationAdvice</code> uses Spring's <code>@ControllerAdvice</code> to inject the unread notification count model attribute into every JSP automatically without repeating code in each controller."
]
for b in bullets:
    elements.append(Paragraph(b, body_style))

doc.build(elements)
print(f"PDF generated successfully at: {pdf_path}")
