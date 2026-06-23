package com.hibernate.repository;

import com.hibernate.entity.Collection;
import com.hibernate.entity.Post;

import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class CollectionRepositoryImpl implements CollectionRepository {
    private final SessionFactory sessionFactory;

    private Session getCurrentSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public Collection save(Collection collection) {
        getCurrentSession().save(collection);
        return collection;
    }

    @Override
    public Collection update(Collection collection) {
        getCurrentSession().update(collection);
        return collection;
    }

    @Override
    public void delete(Integer id) {
        findById(id).ifPresent(getCurrentSession()::delete);
    }

    @Override
    public Optional<Collection> findById(Integer id) {
        return Optional.ofNullable(getCurrentSession().get(Collection.class, id));
    }

    @Override
    public List<Collection> findByUserId(Long userId) {
        return getCurrentSession()
                .createQuery("SELECT DISTINCT c FROM Collection c LEFT JOIN FETCH c.posts WHERE c.user.id = :userId ORDER BY c.createdAt DESC", Collection.class)
                .setParameter("userId", userId)
                .getResultList();
    }

    @Override
    public List<Collection> findPublicCollections() {
        return getCurrentSession()
                .createQuery("SELECT DISTINCT c FROM Collection c LEFT JOIN FETCH c.posts WHERE c.isPublic = true ORDER BY c.createdAt DESC", Collection.class)
                .getResultList();
    }

    @Override
	public List<Post> findPostsByCollectionId(Integer collectionId) {
		// 🎯 🌟 Join Table (collection_posts) ထဲကနေ Post များကို ဆွဲထုတ်ပေးမည့် SQL Query
		String sql = "SELECT p.* FROM posts p " +
		             "JOIN collection_posts cp ON p.id = cp.post_id " +
		             "WHERE cp.collection_id = :collectionId";
                     
		return getCurrentSession()
				.createNativeQuery(sql, Post.class)
				.setParameter("collectionId", collectionId)
				.getResultList();
	
	}
    @Override
    public void removePostFromCollection(Integer collectionId, Integer postId) {
        String sql = "DELETE FROM collection_posts WHERE collection_id = :collectionId AND post_id = :postId";
        getCurrentSession()
            .createNativeQuery(sql)
            .setParameter("collectionId", collectionId)
            .setParameter("postId", postId)
            .executeUpdate();
    }
}