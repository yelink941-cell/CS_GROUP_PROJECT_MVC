package com.hibernate.controller;

import com.hibernate.entity.Conversation;
import com.hibernate.entity.Message;
import com.hibernate.service.ChatService;
import org.springframework.stereotype.Controller; // 💡 REST API မဟုတ်လို့ @Controller ကို သုံးရပါမယ်
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/chat") // 💡 ဒီ Controller ထဲက အလုပ်အားလုံးက http://localhost:8080/chat ကနေ စပါမယ်
public class ChatController {

    // 💡 Service ကို ပြင်ပကနေ ပြင်လို့မရအောင် private final သတ်မှတ်ခြင်း
    private final ChatService chatService;

    // 💡 စီနီယာကျကျ Constructor Injection နဲ့ သော့လှမ်းပေးခြင်း
    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    // ၁။ စကားဝိုင်းအသစ် တည်ဆောက်ရန် Form စာမျက်နှာကို ပြပေးခြင်း
    @GetMapping("/new")
    public String showCreateChatForm() {
        // src/main/webapp/WEB-INF/views/chat/create.jsp (သို့) Thymeleaf စာမျက်နှာကို ပြခိုင်းတာပါ
        return "chat/create"; 
    }

    // ၂။ Form ကနေ Submit နှိပ်လိုက်တဲ့အခါ စကားဝိုင်းအသစ်ကို တကယ်ဆောက်ပေးခြင်း
    @PostMapping("/create")
    public String createChat(
            @RequestParam String title,
            @RequestParam boolean isGroup,
            @RequestParam("userIds") Long[] userIds) { // ပါဝင်မယ့် လူတွေရဲ့ ID စာရင်း
        
        // Service ကို လှမ်းခေါ်ပြီး Database ထဲ သိမ်းခိုင်းလိုက်တယ်
        Conversation conversation = chatService.createConversation(title, isGroup, Arrays.asList(userIds));
        
        // စကားဝိုင်း ဆောက်ပြီးသွားရင် အဲ့ဒီအခန်းထဲကို တိုက်ရိုက် ခေါ်သွားခိုင်းတာပါ (Redirect စနစ်)
        return "redirect:/chat/room/" + conversation.getId();
    }

    // ၃။ စကားဝိုင်း (Chat Room) တစ်ခုချင်းစီကို ဝင်ရောက်ကြည့်ရှုခြင်း
    @GetMapping("/room/{conversationId}")
    public String viewChatRoom(@PathVariable Long conversationId, Model model) {
        
        // Service ကနေတစ်ဆင့် အဲ့ဒီအခန်းရဲ့ စာရာဇဝင် (Chat History) ကို ဆွဲထုတ်တယ်
        List<Message> chatHistory = chatService.getChatHistory(conversationId);
        
        // 💡 Model (Data အိတ်) ထဲကို "messages" ဆိုတဲ့ နာမည်နဲ့ Data အိတ်ထည့်လိုက်တာပါ
        // ဒါမှ JSP ဝဘ်စာမျက်နှာပေါ်ရောက်ရင် ဒီနာမည်နဲ့ စာတွေကို Loop ပတ်ပြီး ထုတ်ပြလို့ရမှာပါ
        model.addAttribute("messages", chatHistory);
        model.addAttribute("conversationId", conversationId);
        
        // chat/room.jsp စာမျက်နှာကို ဖွင့်ပြပါလို့ အမိန့်ပေးတာ ဖြစ်ပါတယ်
        return "chat/room"; 
    }

    // ၄။ Chat Room ထဲကနေ စာအသစ်လှမ်းပို့တဲ့အခါ ကိုင်တွယ်ခြင်း
    @PostMapping("/room/{conversationId}/send")
    public String sendMessage(
            @PathVariable Long conversationId,
            @RequestParam Long senderId,
            @RequestParam String messageText) {
        
        // Service ကိုခေါ်ပြီး စာကို Database ထဲ သိမ်းခိုင်းတယ်
        chatService.sendMessage(conversationId, senderId, messageText);
        
        // စာပို့ပြီးတာနဲ့ လက်ရှိ Chat Room စာမျက်နှာဆီကိုပဲ အလိုအလျောက် Refresh (Redirect) ပြန်လုပ်ခိုင်းတာပါ
        return "redirect:/chat/room/" + conversationId;
    }
}