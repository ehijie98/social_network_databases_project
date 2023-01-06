TRUNCATE TABLE posts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO posts (title, content, views, user_account_id) VALUES ('ABC', 'abc', 40, 1);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('DEF', 'def', 20, 2);
INSERT INTO posts (title, content, views, user_account_id) VALUES ('GHI', 'ghi', 45, 1);
