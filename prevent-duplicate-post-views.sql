SET @guest_token_exists = (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
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

SET @unique_view_exists = (
    SELECT COUNT(*)
    FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'post_views'
      AND INDEX_NAME = 'uq_post_views_post_user'
);

SET @drop_unique_view_sql = IF(
    @unique_view_exists > 0,
    'ALTER TABLE post_views DROP INDEX uq_post_views_post_user',
    'SELECT 1'
);

PREPARE drop_unique_view_statement FROM @drop_unique_view_sql;
EXECUTE drop_unique_view_statement;
DEALLOCATE PREPARE drop_unique_view_statement;

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
