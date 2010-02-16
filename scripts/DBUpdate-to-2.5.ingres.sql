-- ----------------------------------------------------------
--  driver: ingres, generated: 2010-02-16 15:28:33
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket ADD COLUMN archive_flag SMALLINT NOT NULL WITH DEFAULT;\g
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (40, 'ArchiveFlagUpdate', 1, 1, current_timestamp, 1, current_timestamp);\g
CREATE TABLE ticket_flag (
    ticket_id BIGINT NOT NULL,
    ticket_key VARCHAR(50) NOT NULL,
    ticket_value VARCHAR(50),
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL
);\g
MODIFY ticket_flag TO btree;\g
CREATE INDEX ticket_flag_ticket_id_ticket_key ON ticket_flag (ticket_id, ticket_key);\g
CREATE INDEX ticket_flag_ticket_id ON ticket_flag (ticket_id);\g
CREATE INDEX ticket_flag_ticket_id_create_by ON ticket_flag (ticket_id, create_by);\g
-- ----------------------------------------------------------
--  alter table article_flag
-- ----------------------------------------------------------
ALTER TABLE article_flag ADD COLUMN article_key VARCHAR(50) NOT NULL WITH DEFAULT;\g
UPDATE article_flag SET article_key = article_flag WHERE 1=1;\g
-- ----------------------------------------------------------
--  alter table article_flag
-- ----------------------------------------------------------
ALTER TABLE article_flag DROP COLUMN article_flag RESTRICT;\g
-- ----------------------------------------------------------
--  alter table article_flag
-- ----------------------------------------------------------
ALTER TABLE article_flag ADD COLUMN article_value VARCHAR(50);\g
CREATE SEQUENCE virtual_fs_594;\g
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL DEFAULT virtual_fs_594.NEXTVAL,
    filename VARCHAR(350) NOT NULL,
    backend VARCHAR(60) NOT NULL,
    backend_key VARCHAR(160) NOT NULL,
    create_time TIMESTAMP NOT NULL
);\g
MODIFY virtual_fs TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE virtual_fs ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX virtual_fs_filename ON virtual_fs (filename);\g
CREATE INDEX virtual_fs_backend ON virtual_fs (backend);\g
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(350)
);\g
MODIFY virtual_fs_preferences TO btree;\g
CREATE INDEX virtual_fs_preferences_virtual_fs_id ON virtual_fs_preferences (virtual_fs_id);\g
CREATE INDEX virtual_fs_preferences_key_value ON virtual_fs_preferences (preferences_key, preferences_value);\g
CREATE SEQUENCE virtual_fs_db_742;\g
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL DEFAULT virtual_fs_db_742.NEXTVAL,
    filename VARCHAR(350) NOT NULL,
    content LONG BYTE NOT NULL,
    create_time TIMESTAMP NOT NULL
);\g
MODIFY virtual_fs_db TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE virtual_fs_db ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN title VARCHAR(50);\g
UPDATE customer_user SET title = salutation WHERE 1=1;\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user DROP COLUMN salutation RESTRICT;\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ALTER COLUMN login VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ALTER COLUMN customer_id VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ALTER COLUMN zip VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ALTER COLUMN city VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ALTER COLUMN country VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users ADD COLUMN title VARCHAR(50);\g
UPDATE users SET title = salutation WHERE 1=1;\g
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users DROP COLUMN salutation RESTRICT;\g
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users ALTER COLUMN login VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table valid
-- ----------------------------------------------------------
ALTER TABLE valid ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table ticket_priority
-- ----------------------------------------------------------
ALTER TABLE ticket_priority ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table ticket_type
-- ----------------------------------------------------------
ALTER TABLE ticket_type ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table ticket_lock_type
-- ----------------------------------------------------------
ALTER TABLE ticket_lock_type ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table groups
-- ----------------------------------------------------------
ALTER TABLE groups ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table roles
-- ----------------------------------------------------------
ALTER TABLE roles ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table ticket_state
-- ----------------------------------------------------------
ALTER TABLE ticket_state ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table ticket_state_type
-- ----------------------------------------------------------
ALTER TABLE ticket_state_type ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table salutation
-- ----------------------------------------------------------
ALTER TABLE salutation ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table signature
-- ----------------------------------------------------------
ALTER TABLE signature ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table system_address
-- ----------------------------------------------------------
ALTER TABLE system_address ALTER COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table follow_up_possible
-- ----------------------------------------------------------
ALTER TABLE follow_up_possible ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ALTER COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table ticket_history_type
-- ----------------------------------------------------------
ALTER TABLE ticket_history_type ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table article_type
-- ----------------------------------------------------------
ALTER TABLE article_type ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table article_sender_type
-- ----------------------------------------------------------
ALTER TABLE article_sender_type ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table standard_response
-- ----------------------------------------------------------
ALTER TABLE standard_response ALTER COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table standard_response
-- ----------------------------------------------------------
ALTER TABLE standard_response ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table standard_attachment
-- ----------------------------------------------------------
ALTER TABLE standard_attachment ALTER COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table standard_attachment
-- ----------------------------------------------------------
ALTER TABLE standard_attachment ALTER COLUMN content_type VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table standard_attachment
-- ----------------------------------------------------------
ALTER TABLE standard_attachment ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table auto_response_type
-- ----------------------------------------------------------
ALTER TABLE auto_response_type ALTER COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table auto_response_type
-- ----------------------------------------------------------
ALTER TABLE auto_response_type ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table auto_response
-- ----------------------------------------------------------
ALTER TABLE auto_response ALTER COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table auto_response
-- ----------------------------------------------------------
ALTER TABLE auto_response ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table service
-- ----------------------------------------------------------
ALTER TABLE service ALTER COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table service_customer_user
-- ----------------------------------------------------------
ALTER TABLE service_customer_user ALTER COLUMN customer_user_login VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ALTER COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table customer_company
-- ----------------------------------------------------------
ALTER TABLE customer_company ALTER COLUMN customer_id VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table customer_company
-- ----------------------------------------------------------
ALTER TABLE customer_company ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table notification_event
-- ----------------------------------------------------------
ALTER TABLE notification_event ALTER COLUMN content_type VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table notification_event
-- ----------------------------------------------------------
ALTER TABLE notification_event ADD COLUMN comments VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ALTER COLUMN name VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ALTER COLUMN content_type VARCHAR(450);\g
ALTER TABLE ticket_flag ADD FOREIGN KEY (create_by) REFERENCES users(id);\g
ALTER TABLE ticket_flag ADD FOREIGN KEY (ticket_id) REFERENCES ticket(id);\g
ALTER TABLE virtual_fs_preferences ADD FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs(id);\g
