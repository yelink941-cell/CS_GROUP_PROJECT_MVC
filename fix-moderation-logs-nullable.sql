-- moderation_logs: post_id / comment_id / target_user_id are optional per action type
-- BAN uses target_user_id only; HIDDEN(post) uses post_id only; HIDDEN(comment) uses comment_id only
ALTER TABLE moderation_logs MODIFY COLUMN post_id INT NULL;
ALTER TABLE moderation_logs MODIFY COLUMN comment_id INT NULL;
ALTER TABLE moderation_logs MODIFY COLUMN target_user_id INT NULL;
