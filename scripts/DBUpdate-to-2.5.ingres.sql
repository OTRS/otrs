-- ----------------------------------------------------------
--  driver: ingres, generated: 2009-11-12 16:42:32
-- ----------------------------------------------------------
CREATE SEQUENCE virtual_fs_358;\g
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL DEFAULT virtual_fs_358.NEXTVAL,
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
CREATE SEQUENCE virtual_fs_db_279;\g
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL DEFAULT virtual_fs_db_279.NEXTVAL,
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
ALTER TABLE virtual_fs_preferences ADD FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs(id);\g
