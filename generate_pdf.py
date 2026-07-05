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
    fontSize=20,
    leading=26,
    textColor=colors.HexColor('#1E293B'),
    alignment=1, # Center
    spaceAfter=10
)

subtitle_style = ParagraphStyle(
    'DocSubTitle',
    parent=styles['Normal'],
    fontName=font_name,
    fontSize=11,
    leading=16,
    textColor=colors.HexColor('#64748B'),
    alignment=1,
    spaceAfter=20
)

h1_style = ParagraphStyle(
    'SectionH1',
    parent=styles['Heading2'],
    fontName=font_bold_name,
    fontSize=14,
    leading=18,
    textColor=colors.HexColor('#0F172A'),
    spaceBefore=14,
    spaceAfter=8
)

h2_style = ParagraphStyle(
    'SectionH2',
    parent=styles['Heading3'],
    fontName=font_bold_name,
    fontSize=11,
    leading=15,
    textColor=colors.HexColor('#2563EB'),
    spaceBefore=8,
    spaceAfter=4
)

body_style = ParagraphStyle(
    'BodyTextCustom',
    parent=styles['Normal'],
    fontName=font_name,
    fontSize=9.5,
    leading=14,
    textColor=colors.HexColor('#334155'),
    spaceAfter=6
)

code_style = ParagraphStyle(
    'CodeStyle',
    parent=styles['Normal'],
    fontName='Courier',
    fontSize=8.5,
    leading=11,
    textColor=colors.HexColor('#0F172A')
)

table_header_style = ParagraphStyle(
    'TableHeader',
    parent=styles['Normal'],
    fontName=font_bold_name,
    fontSize=9.5,
    leading=13,
    textColor=colors.white
)

table_cell_style = ParagraphStyle(
    'TableCell',
    parent=styles['Normal'],
    fontName=font_name,
    fontSize=8.5,
    leading=12,
    textColor=colors.HexColor('#1E293B')
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
    
    t = Table(formatted_data, colWidths=[160, 200, 180])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#1E293B')),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 5),
        ('TOPPADDING', (0, 0), (-1, -1), 5),
        ('LEFTPADDING', (0, 0), (-1, -1), 6),
        ('RIGHTPADDING', (0, 0), (-1, -1), 6),
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
    ["ChatPageController.java", "src/main/java/com/hibernate/controller/ChatPageController.java", "Page routing for /chat and /chat/room/{id} views."],
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
elements.append(Spacer(1, 12))

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
elements.append(Spacer(1, 12))

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
elements.append(Spacer(1, 12))

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
elements.append(Spacer(1, 12))

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
elements.append(Spacer(1, 16))

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
