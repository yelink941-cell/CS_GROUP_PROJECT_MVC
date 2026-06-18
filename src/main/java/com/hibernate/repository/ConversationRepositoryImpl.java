package com.hibernate.repository;

import com.hibernate.entity.Conversation;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class ConversationRepositoryImpl implements ConversationRepository {

    // 💡 သင်တောင်းဆိုထားတဲ့ private final ပုံစံဖြစ်ပါတယ်
    private final SessionFactory sessionFactory;

    // Beginner များ သတိပြုရန် - Variable ကို final လို့ ကြေညာထားရင် 
    // ဒီလို Constructor ထဲမှာ မဖြစ်မနေ တန်ဖိုး (Value) အရင်ထည့်ပေးရပါတယ်။ (Constructor Injection)
    public ConversationRepositoryImpl(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    // လက်ရှိအသုံးပြုနေတဲ့ လမ်းကြောင်း (Session) ကို စက်ရုံဆီကနေ လှမ်းယူတဲ့အကူအညီပေးမယ့် Function လေးပါ
    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Conversation save(Conversation conversation) {
        if (conversation.getId() == null) {
            // ID မရှိသေးရင် ဒေတာဘေ့စ်ထဲ အသစ်သွားသိမ်းမယ်
            getCurrentSession().save(conversation);
            return conversation;
        } else {
            // ID ရှိပြီးသားဆိုရင် တန်ဖိုးတွေကို သွားပြင် (Update) မယ်
            getCurrentSession().update(conversation);
            return conversation;
        }
    }

    @Override
    public Conversation findById(Long id) {
        // ID ကိုပေးပြီး စကားဝိုင်းကို ရှာဖွေတာပါ
        return getCurrentSession().get(Conversation.class, id);
    }

    @Override
    public List<Conversation> findConversationsByUserId(Long userId) {
        // Hibernate ရဲ့ HQL Query ရေးနည်း ဖြစ်ပါတယ်။ 
        // :userId ဆိုပြီး သတ်မှတ်ပြီး .setParameter နဲ့ Data လှမ်းထည့်တာပါ
        String hql = "SELECT cp.conversation FROM ConversationParticipant cp WHERE cp.userId = :userId";
        return getCurrentSession().createQuery(hql, Conversation.class)
                .setParameter("userId", userId)
                .getResultList();
    }
}