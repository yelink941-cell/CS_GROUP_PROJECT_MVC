-- USER_DELETED uses the existing posts.status column.
-- If your database column is VARCHAR(20), no schema change is required.
-- Run this only if your MySQL status column was created as ENUM and rejects USER_DELETED.

ALTER TABLE posts
MODIFY COLUMN status VARCHAR(20) NOT NULL DEFAULT 'DRAFT';
