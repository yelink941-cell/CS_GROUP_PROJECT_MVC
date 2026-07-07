package com.hibernate.repository;

import com.hibernate.entity.Tag;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class TagRepositoryImpl implements TagRepository {
    private final SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Tag save(Tag tag) {
        getCurrentSession().save(tag);
        return tag;
    }

    @Override
    public Tag update(Tag tag) {
        return (Tag) getCurrentSession().merge(tag);
    }

    @Override
    public void delete(Integer id) {
        findById(id).ifPresent(getCurrentSession()::delete);
    }

    @Override
    public Optional<Tag> findById(Integer id) {
        return Optional.ofNullable(getCurrentSession().get(Tag.class, id));
    }

    @Override
    public List<Tag> findAll() {
        return getCurrentSession()
                .createQuery("FROM Tag", Tag.class)
                .getResultList();
    }

    @Override
    public boolean existsByName(String name) {
        Long count = getCurrentSession()
                .createQuery("SELECT COUNT(t.id) FROM Tag t WHERE t.name = :name", Long.class)
                .setParameter("name", name)
                .uniqueResult();

        return count != null && count > 0;
    }
    // ✅ ဒီ method တွေကို ထည့်ပါ
    @Override
    public double findAverageTagsPerPost() {
        try {
            // Get total posts count
            Long totalPosts = getCurrentSession()
                    .createQuery("SELECT COUNT(p) FROM Post p WHERE p.deletedAt IS NULL", Long.class)
                    .uniqueResult();
            
            if (totalPosts == null || totalPosts == 0) {
                return 0.0;
            }
            
            // Get total tag-post relationships
            Long totalTagPosts = getCurrentSession()
                    .createQuery("SELECT COUNT(tp) FROM TagPost tp", Long.class)
                    .uniqueResult();
            
            if (totalTagPosts == null || totalTagPosts == 0) {
                return 0.0;
            }
            
            return (double) totalTagPosts / totalPosts;
        } catch (Exception e) {
            return 0.0;
        }
    }
    @Override
    public String findMostUsedTagName() {
        try {
            Object[] result = getCurrentSession()
                    .createQuery(
                        "SELECT t.name, COUNT(tp) as count FROM Tag t " +
                        "LEFT JOIN t.posts tp " +
                        "GROUP BY t.id, t.name " +
                        "ORDER BY COUNT(tp) DESC", 
                        Object[].class)
                    .setMaxResults(1)
                    .uniqueResult();
            
            if (result != null && result.length > 0) {
                return (String) result[0];
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }
    @Override
    public List<Tag> findAllWithPostCount() {
        return getCurrentSession()
                .createQuery(
                    "SELECT DISTINCT t FROM Tag t " +
                    "LEFT JOIN FETCH t.posts", 
                    Tag.class)
                .getResultList();
    }
}
