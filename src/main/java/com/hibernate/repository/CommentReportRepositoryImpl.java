package com.hibernate.repository;

import com.hibernate.entity.CommentReport;
import lombok.RequiredArgsConstructor;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
@RequiredArgsConstructor
public class CommentReportRepositoryImpl implements CommentReportRepository {

    private final SessionFactory sessionFactory;

    private Session getSession() {
        return sessionFactory.getCurrentSession();
    }

    @Override
    public void save(CommentReport report) {
        getSession().saveOrUpdate(report);
    }

    @Override
    public CommentReport findPendingByCommentAndReporter(Integer commentId, Long reporterId) {
        List<CommentReport> results = getSession()
                .createQuery(
                    "FROM CommentReport r WHERE r.comment.id = :commentId AND r.reporter.id = :reporterId AND r.status = 'PENDING'",
                    CommentReport.class)
                .setParameter("commentId", commentId)
                .setParameter("reporterId", reporterId)
                .getResultList();
        return results.isEmpty() ? null : results.get(0);
    }

    @Override
    public CommentReport findById(Integer id) {
        return getSession().get(CommentReport.class, id);
    }

    @Override
    public List<CommentReport> findPendingByCommentId(Integer commentId) {
        return getSession()
                .createQuery(
                    "FROM CommentReport r JOIN FETCH r.comment c JOIN FETCH c.post JOIN FETCH c.user JOIN FETCH r.reporter WHERE r.comment.id = :commentId AND r.status = 'PENDING'",
                    CommentReport.class)
                .setParameter("commentId", commentId)
                .getResultList();
    }

    @Override
    public List<CommentReport> findAllPending() {
        return getSession()
                .createQuery(
                    "FROM CommentReport r JOIN FETCH r.comment c JOIN FETCH c.post JOIN FETCH c.user JOIN FETCH r.reporter WHERE r.status = 'PENDING' ORDER BY r.createdAt DESC",
                    CommentReport.class)
                .getResultList();
    }

    @Override
    public List<CommentReport> findAllHistory() {
        return getSession()
                .createQuery(
                    "FROM CommentReport r JOIN FETCH r.comment c JOIN FETCH c.post JOIN FETCH c.user JOIN FETCH r.reporter "
                            + "WHERE r.status <> 'PENDING' ORDER BY r.createdAt DESC",
                    CommentReport.class)
                .getResultList();
    }
}
