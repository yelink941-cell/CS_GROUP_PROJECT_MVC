package com.hibernate.repository;

import com.hibernate.entity.PostReport;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class PostReportRepositoryImpl implements PostReportRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void save(PostReport report) {
        getSession().saveOrUpdate(report);
    }

    @Override
    public PostReport findPendingByPostAndReporter(Integer postId, Long reporterId) {
        List<PostReport> results = getSession()
                .createQuery(
                    "FROM PostReport r WHERE r.post.id = :postId AND r.reporter.id = :reporterId AND r.status = 'PENDING'",
                    PostReport.class)
                .setParameter("postId", postId)
                .setParameter("reporterId", reporterId)
                .getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public PostReport findById(Integer id) {
        return getSession().get(PostReport.class, id);
    }

    @Override
    public List<PostReport> findAllPending() {
        return getSession()
                .createQuery(
                    "FROM PostReport r JOIN FETCH r.post JOIN FETCH r.reporter WHERE r.status = 'PENDING' ORDER BY r.createdAt DESC",
                    PostReport.class)
                .getResultList();
    }
}
