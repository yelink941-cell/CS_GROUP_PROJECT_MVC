package com.hibernate.repository;

import com.hibernate.entity.PostFile;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class PostFileRepositoryImpl implements PostFileRepository {
    private final SessionFactory sessionFactory;

    @Override
    public PostFile save(PostFile postFile) {
        sessionFactory.getCurrentSession().save(postFile);
        return postFile;
    }

    @Override
    public List<PostFile> findByPostId(Integer postId) {
        return sessionFactory.getCurrentSession()
                .createQuery(
                        "from PostFile pf "
                                + "where pf.post.id = :postId "
                                + "order by pf.createdAt desc",
                        PostFile.class)
                .setParameter("postId", postId)
                .getResultList();
    }

    @Override
    public Optional<PostFile> findByIdAndPostId(Integer id, Integer postId) {
        PostFile postFile = sessionFactory.getCurrentSession()
                .createQuery(
                        "select pf from PostFile pf "
                                + "join fetch pf.post "
                                + "where pf.id = :id and pf.post.id = :postId",
                        PostFile.class)
                .setParameter("id", id)
                .setParameter("postId", postId)
                .uniqueResult();

        return Optional.ofNullable(postFile);
    }
}
