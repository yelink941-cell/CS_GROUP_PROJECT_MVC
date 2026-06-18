<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Chat Room</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f0f2f5; margin: 0; padding: 20px; }
        .chat-container { max-width: 600px; margin: 0 auto; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); overflow: hidden; }
        .chat-header { background-color: #0084ff; color: white; padding: 15px; text-align: center; font-size: 18px; font-weight: bold; }
        .chat-box { height: 400px; padding: 15px; overflow-y: auto; border-bottom: 1px solid #ddd; display: flex; flex-direction: column-reverse; }
        .message-box { margin-bottom: 15px; padding: 10px; border-radius: 8px; max-width: 75%; background-color: #e4e6eb; align-self: flex-start; }
        /* လက်ရှိ Member 5 ပို့တဲ့စာဆိုရင် ညာဘက်ကပ်ပြီး အပြာရောင်ပြမယ့် ပုံစံပါ */
        .my-message { background-color: #0084ff; color: white; align-self: flex-end; }
        .sender-title { font-size: 12px; font-weight: bold; margin-bottom: 5px; display: block; }
        .message-text { margin: 0; font-size: 15px; }
        .message-time { font-size: 10px; color: #65676b; float: right; margin-top: 5px; }
        .my-message .message-time { color: #e4e6eb; }
        .chat-form { display: flex; padding: 10px; background: #fff; }
        .chat-input { flex: 1; padding: 10px; border: 1px solid #ddd; border-radius: 20px; outline: none; font-size: 14px; }
        .send-btn { background: #0084ff; color: white; border: none; padding: 0 20px; margin-left: 10px; border-radius: 20px; cursor: pointer; font-weight: bold; }
        .send-btn:hover { background: #0066cc; }
    </style>
</head>
<body>

<div class="chat-container">
    <div class="chat-header">
        Chat Room #${conversationId}
    </div>

    <div class="chat-box">
        <%-- 💡 Controller က Model ထဲထည့်ပေးလိုက်တဲ့ 'messages' စာရင်းကို တစ်ခုချင်းစီ Loop ပတ်ထုတ်ပြတာပါ --%>
        <c:forEach var="msg" items="${messages}">
            <%-- သင့်ရဲ့ Role က Member 5 ဖြစ်လို့ senderId == 5 ဆိုရင် ကိုယ်ပို့တဲ့စာအဖြစ် အပြာရောင်ပြပါမယ် --%>
            <div class="message-box ${msg.senderId == 5 ? 'my-message' : ''}">
                <span class="sender-title">User ID: ${msg.senderId}</span>
                <p class="message-text">
                    <c:out value="${msg.messageText}"/>
                </p>
                <span class="message-time">${msg.createdAt}</span>
            </div>
        </c:forEach>
    </div>

    <%-- 💡 Form Submit လုပ်ရင် Controller ထဲက /chat/room/{id}/send ဆီကို သွားမှာပါ --%>
    <form class="chat-form" action="${pageContext.request.contextPath}/chat/room/${conversationId}/send" method="post">
        
        <input type="hidden" name="senderId" value="5"/>
        
        <input type="text" name="messageText" class="chat-input" placeholder="စာအသစ်ရိုက်ပါ..." required autocomplete="off"/>
        <button type="submit" class="send-btn">ပို့ရန်</button>
    </form>
</div>

</body>
</html>