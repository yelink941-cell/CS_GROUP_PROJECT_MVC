package com.hibernate.repository;

import java.util.List;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.hibernate.entity.SearchHistory;

@Repository
public class SearchHistoryRepositoryImpl implements SearchHistoryRepository {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void save(SearchHistory searchHistory) {
        sessionFactory.getCurrentSession().save(searchHistory);
    }

    @Override
    public List<SearchHistory> findByUserId(int userId) {
        String hql = "FROM SearchHistory s WHERE s.user.id = :userId ORDER BY s.searchedAt DESC";
        Query<SearchHistory> query = sessionFactory.getCurrentSession().createQuery(hql, SearchHistory.class);
        query.setParameter("userId", userId);
        return query.getResultList();
    }
}