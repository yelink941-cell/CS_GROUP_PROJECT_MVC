ALTER TABLE posts
    ADD COLUMN status_before_archive VARCHAR(20) NULL,
    ADD COLUMN archived_at DATETIME NULL,
    ADD COLUMN removed_at DATETIME NULL,
    ADD COLUMN removal_reason TEXT NULL;

-- If you already ran the previous version of this migration, remove the old featured column:
-- ALTER TABLE posts DROP COLUMN is_featured;

CREATE TABLE IF NOT EXISTS admin_post_audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id BIGINT NULL,
    admin_name VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    post_id INT NULL,
    post_title VARCHAR(255) NOT NULL,
    reason TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_admin_post_audit_admin
        FOREIGN KEY (admin_id) REFERENCES users(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_admin_post_audit_post
        FOREIGN KEY (post_id) REFERENCES posts(id)
        ON DELETE SET NULL
);
