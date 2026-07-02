SET @view_count_exists = (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'posts'
      AND COLUMN_NAME = 'view_count'
);

SET @view_count_sql = IF(
    @view_count_exists = 0,
    'ALTER TABLE posts ADD COLUMN view_count INT NOT NULL DEFAULT 0',
    'ALTER TABLE posts MODIFY COLUMN view_count INT NOT NULL DEFAULT 0'
);

PREPARE view_count_statement FROM @view_count_sql;
EXECUTE view_count_statement;
DEALLOCATE PREPARE view_count_statement;

CREATE TABLE IF NOT EXISTS post_views (
    id BIGINT NOT NULL AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id BIGINT NULL,
    guest_token VARCHAR(255) NULL,
    viewer_name VARCHAR(150) NULL,
    ip_address VARCHAR(45) NULL,
    user_agent VARCHAR(500) NULL,
    viewed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_post_views_post
        FOREIGN KEY (post_id) REFERENCES posts(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_post_views_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL,
    INDEX idx_post_views_post_id (post_id),
    INDEX idx_post_views_viewed_at (viewed_at),
    INDEX idx_post_views_post_user_time (post_id, user_id, viewed_at),
    INDEX idx_post_views_post_guest_time (post_id, guest_token, viewed_at)
);

SET @user_id_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND COLUMN_NAME = 'user_id'
);
SET @user_id_sql = IF(
    @user_id_exists = 0,
    'ALTER TABLE post_views ADD COLUMN user_id BIGINT NULL AFTER post_id',
    'ALTER TABLE post_views MODIFY COLUMN user_id BIGINT NULL'
);
PREPARE user_id_statement FROM @user_id_sql;
EXECUTE user_id_statement;
DEALLOCATE PREPARE user_id_statement;

SET @guest_token_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND COLUMN_NAME = 'guest_token'
);
SET @guest_token_sql = IF(
    @guest_token_exists = 0,
    'ALTER TABLE post_views ADD COLUMN guest_token VARCHAR(255) NULL AFTER user_id',
    'ALTER TABLE post_views MODIFY COLUMN guest_token VARCHAR(255) NULL'
);
PREPARE guest_token_statement FROM @guest_token_sql;
EXECUTE guest_token_statement;
DEALLOCATE PREPARE guest_token_statement;

SET @viewer_name_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND COLUMN_NAME = 'viewer_name'
);
SET @viewer_name_sql = IF(
    @viewer_name_exists = 0,
    'ALTER TABLE post_views ADD COLUMN viewer_name VARCHAR(150) NULL AFTER user_id',
    'SELECT 1'
);
PREPARE viewer_name_statement FROM @viewer_name_sql;
EXECUTE viewer_name_statement;
DEALLOCATE PREPARE viewer_name_statement;

SET @ip_address_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND COLUMN_NAME = 'ip_address'
);
SET @ip_address_sql = IF(
    @ip_address_exists = 0,
    'ALTER TABLE post_views ADD COLUMN ip_address VARCHAR(45) NULL AFTER viewer_name',
    'SELECT 1'
);
PREPARE ip_address_statement FROM @ip_address_sql;
EXECUTE ip_address_statement;
DEALLOCATE PREPARE ip_address_statement;

SET @user_agent_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND COLUMN_NAME = 'user_agent'
);
SET @user_agent_sql = IF(
    @user_agent_exists = 0,
    'ALTER TABLE post_views ADD COLUMN user_agent VARCHAR(500) NULL AFTER ip_address',
    'SELECT 1'
);
PREPARE user_agent_statement FROM @user_agent_sql;
EXECUTE user_agent_statement;
DEALLOCATE PREPARE user_agent_statement;

SET @user_fk_exists = (
    SELECT COUNT(*)
    FROM information_schema.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND CONSTRAINT_NAME = 'fk_post_views_user'
);
SET @drop_user_fk_sql = IF(
    @user_fk_exists > 0,
    'ALTER TABLE post_views DROP FOREIGN KEY fk_post_views_user',
    'SELECT 1'
);
PREPARE drop_user_fk_statement FROM @drop_user_fk_sql;
EXECUTE drop_user_fk_statement;
DEALLOCATE PREPARE drop_user_fk_statement;

ALTER TABLE post_views
    ADD CONSTRAINT fk_post_views_user
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE SET NULL;

SET @unique_view_exists = (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND INDEX_NAME = 'uq_post_views_post_user'
);
SET @unique_view_sql = IF(
    @unique_view_exists > 0,
    'ALTER TABLE post_views DROP INDEX uq_post_views_post_user',
    'SELECT 1'
);
PREPARE unique_view_statement FROM @unique_view_sql;
EXECUTE unique_view_statement;
DEALLOCATE PREPARE unique_view_statement;

SET @user_time_index_exists = (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND INDEX_NAME = 'idx_post_views_post_user_time'
);
SET @user_time_index_sql = IF(
    @user_time_index_exists = 0,
    'ALTER TABLE post_views ADD INDEX idx_post_views_post_user_time (post_id, user_id, viewed_at)',
    'SELECT 1'
);
PREPARE user_time_index_statement FROM @user_time_index_sql;
EXECUTE user_time_index_statement;
DEALLOCATE PREPARE user_time_index_statement;

SET @guest_time_index_exists = (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND INDEX_NAME = 'idx_post_views_post_guest_time'
);
SET @guest_time_index_sql = IF(
    @guest_time_index_exists = 0,
    'ALTER TABLE post_views ADD INDEX idx_post_views_post_guest_time (post_id, guest_token, viewed_at)',
    'SELECT 1'
);
PREPARE guest_time_index_statement FROM @guest_time_index_sql;
EXECUTE guest_time_index_statement;
DEALLOCATE PREPARE guest_time_index_statement;
