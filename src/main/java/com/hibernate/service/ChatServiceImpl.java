package com.hibernate.service;

import com.hibernate.entity.Conversation;
import com.hibernate.entity.ConversationParticipant;
import com.hibernate.entity.Message;
import com.hibernate.repository.ConversationRepository;
import com.hibernate.repository.MessageRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service // Spring ကို "ဒါဟာ Service Layer ဖြစ်တယ်" လို့ မှတ်ပုံတင်ခိုင်းတာပါ
@Transactional // 💡 အရေးကြီးဆုံးပါ! SessionFactory သုံးထားလို့ Transaction ဖွင့်/ပိတ်ပေးဖို့ မဖြစ်မနေ ပါရပါမယ်
public class ChatServiceImpl implements ChatService { // 💡 implements သုံးထားပါတယ်

    // 💡 Repository တွေကို ပြင်ပကနေ ပြင်လို့မရအောင် private final နဲ့ သတ်မှတ်ခြင်း
    private final ConversationRepository conversationRepository;
    private final MessageRepository messageRepository;

    // 💡 ဆရာအကြိုက် Constructor Injection စနစ်နဲ့ သော့လှမ်းပေးခြင်း
    public ChatServiceImpl(ConversationRepository conversationRepository, MessageRepository messageRepository) {
        this.conversationRepository = conversationRepository;
        this.messageRepository = messageRepository;
    }

    // ၁။ စကားဝိုင်းအသစ် တည်ဆောက်ခြင်း Logic
    @Override
    public Conversation createConversation(String title, boolean isGroup, List<Long> userIds) {
        Conversation conversation = new Conversation();
        conversation.setTitle(title);
        conversation.setGroup(isGroup);

        // ပါဝင်မယ့် လူစာရင်း (User IDs) တွေကို ယူပြီး Participant Object တွေအဖြစ် ပြောင်းလဲချိတ်ဆက်ခြင်း
        List<ConversationParticipant> participants = new ArrayList<>();
        for (Long userId : userIds) {
            ConversationParticipant participant = new ConversationParticipant();
            participant.setConversation(conversation);
            participant.setUserId(userId);
            participants.add(participant);
        }
        
        // Conversation ထဲကို Participant စာရင်း တစ်ခါတည်း ထည့်ပေးလိုက်ခြင်း
        conversation.setParticipants(participants);

        // Repository ကနေတစ်ဆင့် ဒေတာဘေ့စ်ထဲ သွားသိမ်းခိုင်းလိုက်တာပါ
        return conversationRepository.save(conversation);
    }

    // ၂။ စာပို့ခြင်း Logic
    @Override
    public Message sendMessage(Long conversationId, Long senderId, String text) {
        // အရင်ဆုံး စာပို့မယ့် အခန်း တကယ်ရှိမရှိ ရှာဖွေတယ်
        Conversation conversation = conversationRepository.findById(conversationId);
        if (conversation == null) {
            throw new RuntimeException("စကားဝိုင်း အခန်းနံပါတ် " + conversationId + " ကို ရှာမတွေ့ပါ။");
        }

        // မက်ဆေ့ခ်ျ Object အသစ်တစ်ခု တည်ဆောက်ပြီး Data တွေ ဖြည့်သွင်းခြင်း
        Message message = new Message();
        message.setConversation(conversation);
        message.setSenderId(senderId);
        message.setMessageText(text);

        // Message Repository ကနေတစ်ဆင့် ဒေတာဘေ့စ်ထဲ သွားသိမ်းခိုင်းပါတယ်
        return messageRepository.save(message);
    }

    // ၃။ Chat History ပြန်ခေါ်ခြင်း Logic
    @Override
    public List<Message> getChatHistory(Long conversationId) {
        // Message Repository ထဲက အချိန်အလိုက် စီပေးမယ့် Method ကို လှမ်းခေါ်လိုက်ရုံပါပဲ
        return messageRepository.findByConversationId(conversationId);
    }
}