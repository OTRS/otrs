-- ----------------------------------------------------------
--  driver: db2, generated: 2009-11-12 16:42:32
-- ----------------------------------------------------------
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);

CREATE INDEX ticket_until_time ON ticket (until_time);

-- ----------------------------------------------------------
--  create table virtual_fs
-- ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    filename VARCHAR (350) NOT NULL,
    backend VARCHAR (60) NOT NULL,
    backend_key VARCHAR (160) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
);

CREATE INDEX virtual_fs_backend ON virtual_fs (backend);

CREATE INDEX virtual_fs_filename ON virtual_fs (filename);

-- ----------------------------------------------------------
--  create table virtual_fs_preferences
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (350)
);

CREATE INDEX virtual_fs_preferences_virtualf6 ON virtual_fs_preferences (virtual_fs_id);

-- ----------------------------------------------------------
--  create table virtual_fs_db
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    filename VARCHAR (350) NOT NULL,
    content BLOB (30M) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
);

CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);

SET INTEGRITY FOR customer_user OFF;

-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN title VARCHAR (50) GENERATED ALWAYS AS (salutation);

SET INTEGRITY FOR customer_user IMMEDIATE CHECKED FORCE GENERATED;

-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ALTER title DROP EXPRESSION;

-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user DROP COLUMN salutation;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN title SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN title DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN login SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN login DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

UPDATE customer_user SET login = '' WHERE login IS NULL;

ALTER TABLE customer_user ALTER COLUMN login SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN customer_id SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN customer_id DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

UPDATE customer_user SET customer_id = '' WHERE customer_id IS NULL;

ALTER TABLE customer_user ALTER COLUMN customer_id SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN zip SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN zip DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN city SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN city DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN country SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN country DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

SET INTEGRITY FOR users OFF;

-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users ADD COLUMN title VARCHAR (50) GENERATED ALWAYS AS (salutation);

SET INTEGRITY FOR users IMMEDIATE CHECKED FORCE GENERATED;

-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users ALTER title DROP EXPRESSION;

-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users DROP COLUMN salutation;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

ALTER TABLE users ALTER COLUMN title SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

ALTER TABLE users ALTER COLUMN title DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

ALTER TABLE users ALTER COLUMN login SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

ALTER TABLE users ALTER COLUMN login DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

UPDATE users SET login = '' WHERE login IS NULL;

ALTER TABLE users ALTER COLUMN login SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

ALTER TABLE valid ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE valid');

ALTER TABLE valid ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE valid');

UPDATE valid SET name = '' WHERE name IS NULL;

ALTER TABLE valid ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE valid');

ALTER TABLE ticket_priority ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_priority');

ALTER TABLE ticket_priority ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_priority');

UPDATE ticket_priority SET name = '' WHERE name IS NULL;

ALTER TABLE ticket_priority ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_priority');

ALTER TABLE ticket_type ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_type');

ALTER TABLE ticket_type ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_type');

UPDATE ticket_type SET name = '' WHERE name IS NULL;

ALTER TABLE ticket_type ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_type');

ALTER TABLE ticket_lock_type ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_lock_type');

ALTER TABLE ticket_lock_type ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_lock_type');

UPDATE ticket_lock_type SET name = '' WHERE name IS NULL;

ALTER TABLE ticket_lock_type ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_lock_type');

ALTER TABLE groups ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE groups');

ALTER TABLE groups ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE groups');

UPDATE groups SET name = '' WHERE name IS NULL;

ALTER TABLE groups ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE groups');

ALTER TABLE roles ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE roles');

ALTER TABLE roles ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE roles');

UPDATE roles SET name = '' WHERE name IS NULL;

ALTER TABLE roles ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE roles');

ALTER TABLE ticket_state ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_state');

ALTER TABLE ticket_state ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_state');

UPDATE ticket_state SET name = '' WHERE name IS NULL;

ALTER TABLE ticket_state ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_state');

ALTER TABLE ticket_state_type ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_state_type');

ALTER TABLE ticket_state_type ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_state_type');

UPDATE ticket_state_type SET name = '' WHERE name IS NULL;

ALTER TABLE ticket_state_type ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_state_type');

ALTER TABLE salutation ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE salutation');

ALTER TABLE salutation ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE salutation');

UPDATE salutation SET name = '' WHERE name IS NULL;

ALTER TABLE salutation ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE salutation');

ALTER TABLE signature ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE signature');

ALTER TABLE signature ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE signature');

UPDATE signature SET name = '' WHERE name IS NULL;

ALTER TABLE signature ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE signature');

ALTER TABLE system_address ALTER COLUMN comments SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE system_address');

ALTER TABLE system_address ALTER COLUMN comments DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE system_address');

ALTER TABLE follow_up_possible ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE follow_up_possible');

ALTER TABLE follow_up_possible ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE follow_up_possible');

UPDATE follow_up_possible SET name = '' WHERE name IS NULL;

ALTER TABLE follow_up_possible ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE follow_up_possible');

ALTER TABLE queue ALTER COLUMN comments SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE queue');

ALTER TABLE queue ALTER COLUMN comments DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE queue');

ALTER TABLE ticket_history_type ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_history_type');

ALTER TABLE ticket_history_type ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_history_type');

UPDATE ticket_history_type SET name = '' WHERE name IS NULL;

ALTER TABLE ticket_history_type ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_history_type');

ALTER TABLE article_type ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article_type');

ALTER TABLE article_type ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article_type');

UPDATE article_type SET name = '' WHERE name IS NULL;

ALTER TABLE article_type ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article_type');

ALTER TABLE article_sender_type ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article_sender_type');

ALTER TABLE article_sender_type ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article_sender_type');

UPDATE article_sender_type SET name = '' WHERE name IS NULL;

ALTER TABLE article_sender_type ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article_sender_type');

ALTER TABLE standard_response ALTER COLUMN comments SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_response');

ALTER TABLE standard_response ALTER COLUMN comments DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_response');

ALTER TABLE standard_response ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_response');

ALTER TABLE standard_response ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_response');

UPDATE standard_response SET name = '' WHERE name IS NULL;

ALTER TABLE standard_response ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_response');

ALTER TABLE standard_attachment ALTER COLUMN comments SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_attachment');

ALTER TABLE standard_attachment ALTER COLUMN comments DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_attachment');

ALTER TABLE standard_attachment ALTER COLUMN content_type SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_attachment');

ALTER TABLE standard_attachment ALTER COLUMN content_type DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_attachment');

UPDATE standard_attachment SET content_type = '' WHERE content_type IS NULL;

ALTER TABLE standard_attachment ALTER COLUMN content_type SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_attachment');

ALTER TABLE standard_attachment ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_attachment');

ALTER TABLE standard_attachment ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_attachment');

UPDATE standard_attachment SET name = '' WHERE name IS NULL;

ALTER TABLE standard_attachment ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE standard_attachment');

ALTER TABLE auto_response_type ALTER COLUMN comments SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response_type');

ALTER TABLE auto_response_type ALTER COLUMN comments DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response_type');

ALTER TABLE auto_response_type ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response_type');

ALTER TABLE auto_response_type ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response_type');

UPDATE auto_response_type SET name = '' WHERE name IS NULL;

ALTER TABLE auto_response_type ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response_type');

ALTER TABLE auto_response ALTER COLUMN comments SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response');

ALTER TABLE auto_response ALTER COLUMN comments DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response');

ALTER TABLE auto_response ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response');

ALTER TABLE auto_response ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response');

UPDATE auto_response SET name = '' WHERE name IS NULL;

ALTER TABLE auto_response ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE auto_response');

ALTER TABLE service ALTER COLUMN comments SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE service');

ALTER TABLE service ALTER COLUMN comments DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE service');

ALTER TABLE service_customer_user ALTER COLUMN customer_user_login SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE service_customer_user');

ALTER TABLE service_customer_user ALTER COLUMN customer_user_login DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE service_customer_user');

UPDATE service_customer_user SET customer_user_login = '' WHERE customer_user_login IS NULL;

ALTER TABLE service_customer_user ALTER COLUMN customer_user_login SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE service_customer_user');

ALTER TABLE sla ALTER COLUMN comments SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE sla');

ALTER TABLE sla ALTER COLUMN comments DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE sla');

ALTER TABLE customer_company ALTER COLUMN customer_id SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_company');

ALTER TABLE customer_company ALTER COLUMN customer_id DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_company');

UPDATE customer_company SET customer_id = '' WHERE customer_id IS NULL;

ALTER TABLE customer_company ALTER COLUMN customer_id SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_company');

ALTER TABLE customer_company ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_company');

ALTER TABLE customer_company ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_company');

UPDATE customer_company SET name = '' WHERE name IS NULL;

ALTER TABLE customer_company ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_company');

ALTER TABLE notification_event ALTER COLUMN content_type SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE notification_event');

ALTER TABLE notification_event ALTER COLUMN content_type DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE notification_event');

UPDATE notification_event SET content_type = '' WHERE content_type IS NULL;

ALTER TABLE notification_event ALTER COLUMN content_type SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE notification_event');

-- ----------------------------------------------------------
--  alter table notification_event
-- ----------------------------------------------------------
ALTER TABLE notification_event ADD comments VARCHAR (250);

ALTER TABLE package_repository ALTER COLUMN name SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE package_repository');

ALTER TABLE package_repository ALTER COLUMN name DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE package_repository');

UPDATE package_repository SET name = '' WHERE name IS NULL;

ALTER TABLE package_repository ALTER COLUMN name SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE package_repository');

ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_virtual_fs_id_id FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id);
