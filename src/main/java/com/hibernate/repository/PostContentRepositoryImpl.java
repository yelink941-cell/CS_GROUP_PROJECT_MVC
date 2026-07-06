package com.hibernate.repository;

import com.hibernate.entity.PostContent;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class PostContentRepositoryImpl implements PostContentRepository {
    private final SessionFactory sessionFactory;

    @Override
    public PostContent save(PostContent postContent) {
        sessionFactory.getCurrentSession().save(postContent);
        return postContent;
    }

    @Override
    public PostContent update(PostContent postContent) {
        sessionFactory.getCurrentSession().update(postContent);
        return postContent;
    }

    @Override
    public void delete(PostContent postContent) {
        sessionFactory.getCurrentSession().delete(postContent);
    }

    @Override
    public Optional<PostContent> findByIdAndPostId(Integer id, Integer postId) {
        PostContent postContent = sessionFactory.getCurrentSession()
                .createQuery(
                        "select pc from PostContent pc "
                                + "join fetch pc.post "
                                + "where pc.id = :id and pc.post.id = :postId",
                        PostContent.class)
                .setParameter("id", id)
                .setParameter("postId", postId)
                .uniqueResult();

        return Optional.ofNullable(postContent);
    }

    @Override
    public List<PostContent> findByPostId(Integer postId) {
        return sessionFactory.getCurrentSession()
                .createQuery(
                        "from PostContent pc "
                                + "where pc.post.id = :postId "
                                + "order by pc.id asc",
                        PostContent.class)
                .setParameter("postId", postId)
                .getResultList();
    }
}
