package com.hibernate.repository;

import java.util.List;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.SearchHistory;

@Repository
public class SearchHistoryRepositoryImpl implements SearchHistoryRepository {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(SearchHistory history) {
        sessionFactory.getCurrentSession().saveOrUpdate(history);
    }

    @Override
    public List<SearchHistory> findByUserId(int userId) {
        String hql = "FROM SearchHistory sh WHERE sh.user.id = :uid ORDER BY sh.searchedAt DESC";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, SearchHistory.class)
                .setParameter("uid", (long) userId)
                .getResultList();
    }

    @Override
    public SearchHistory findByUserIdAndKeyword(int userId, String keyword) {
        // 🎯 HQL သုံးပြီး သက်ဆိုင်ရာ User ရဲ့ ရိုက်ရှာထားတဲ့ Keyword အဟောင်း ရှိမရှိ စစ်ဆေးခြင်း
        String hql = "FROM SearchHistory sh WHERE sh.user.id = :uid AND sh.keyword = :kw";
        List<SearchHistory> list = sessionFactory.getCurrentSession()
                .createQuery(hql, SearchHistory.class)
                .setParameter("uid", (long) userId)
                .setParameter("kw", keyword)
                .getResultList();
        
        // ရှိရင် ပထမဆုံး Record ကိုပြန်ပေးပြီး မရှိရင် null ပြန်ပေးမည်
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public void deleteById(int historyId) {
        SearchHistory history = sessionFactory.getCurrentSession().get(SearchHistory.class, historyId);
        if (history != null) {
            sessionFactory.getCurrentSession().delete(history);
        }
    }
    @Override
    public List<String> findByUserIdAndKeywordLike(int userId, String keywordPattern) {
        String hql = "SELECT sh.keyword FROM SearchHistory sh " +
                     "WHERE sh.user.id = :uid AND LOWER(sh.keyword) LIKE :kw " +
                     "GROUP BY sh.keyword ORDER BY MAX(sh.searchedAt) DESC";
        return sessionFactory.getCurrentSession()
                .createQuery(hql, String.class)
                .setParameter("uid", (long) userId)
                .setParameter("kw", keywordPattern)
                .setMaxResults(10)
                .getResultList();
    }
}