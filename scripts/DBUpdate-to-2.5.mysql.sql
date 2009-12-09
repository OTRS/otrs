# ----------------------------------------------------------
#  driver: mysql, generated: 2009-12-09 12:36:20
# ----------------------------------------------------------
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket ADD archive_flag SMALLINT NULL;
UPDATE ticket SET archive_flag = 0 WHERE archive_flag IS NULL;
ALTER TABLE ticket CHANGE archive_flag archive_flag SMALLINT DEFAULT 0 NOT NULL;
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);
CREATE INDEX ticket_create_time ON ticket (create_time);
CREATE INDEX ticket_until_time ON ticket (until_time);
CREATE INDEX ticket_archive_flag ON ticket (archive_flag);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (40, 'ArchiveFlagUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  create table virtual_fs
# ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL AUTO_INCREMENT,
    filename TEXT NOT NULL,
    backend VARCHAR (60) NOT NULL,
    backend_key VARCHAR (160) NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX virtual_fs_backend (backend(60)),
    INDEX virtual_fs_filename (filename(350))
);
# ----------------------------------------------------------
#  create table virtual_fs_preferences
# ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value TEXT NULL,
    INDEX virtual_fs_preferences_virtual_fs_id (virtual_fs_id)
);
# ----------------------------------------------------------
#  create table virtual_fs_db
# ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL AUTO_INCREMENT,
    filename TEXT NOT NULL,
    content LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX virtual_fs_db_filename (filename(350))
);
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user CHANGE salutation title VARCHAR (50) NULL;
ALTER TABLE customer_user ALTER title DROP DEFAULT;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user CHANGE login login VARCHAR (200) NULL;
ALTER TABLE customer_user ALTER login DROP DEFAULT;
UPDATE customer_user SET login = '' WHERE login IS NULL;
ALTER TABLE customer_user CHANGE login login VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user CHANGE customer_id customer_id VARCHAR (150) NULL;
ALTER TABLE customer_user ALTER customer_id DROP DEFAULT;
UPDATE customer_user SET customer_id = '' WHERE customer_id IS NULL;
ALTER TABLE customer_user CHANGE customer_id customer_id VARCHAR (150) NOT NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user CHANGE zip zip VARCHAR (200) NULL;
ALTER TABLE customer_user ALTER zip DROP DEFAULT;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user CHANGE city city VARCHAR (200) NULL;
ALTER TABLE customer_user ALTER city DROP DEFAULT;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user CHANGE country country VARCHAR (200) NULL;
ALTER TABLE customer_user ALTER country DROP DEFAULT;
# ----------------------------------------------------------
#  alter table users
# ----------------------------------------------------------
ALTER TABLE users CHANGE salutation title VARCHAR (50) NULL;
ALTER TABLE users ALTER title DROP DEFAULT;
# ----------------------------------------------------------
#  alter table users
# ----------------------------------------------------------
ALTER TABLE users CHANGE login login VARCHAR (200) NULL;
ALTER TABLE users ALTER login DROP DEFAULT;
UPDATE users SET login = '' WHERE login IS NULL;
ALTER TABLE users CHANGE login login VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table valid
# ----------------------------------------------------------
ALTER TABLE valid CHANGE name name VARCHAR (200) NULL;
ALTER TABLE valid ALTER name DROP DEFAULT;
UPDATE valid SET name = '' WHERE name IS NULL;
ALTER TABLE valid CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table ticket_priority
# ----------------------------------------------------------
ALTER TABLE ticket_priority CHANGE name name VARCHAR (200) NULL;
ALTER TABLE ticket_priority ALTER name DROP DEFAULT;
UPDATE ticket_priority SET name = '' WHERE name IS NULL;
ALTER TABLE ticket_priority CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table ticket_type
# ----------------------------------------------------------
ALTER TABLE ticket_type CHANGE name name VARCHAR (200) NULL;
ALTER TABLE ticket_type ALTER name DROP DEFAULT;
UPDATE ticket_type SET name = '' WHERE name IS NULL;
ALTER TABLE ticket_type CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table ticket_lock_type
# ----------------------------------------------------------
ALTER TABLE ticket_lock_type CHANGE name name VARCHAR (200) NULL;
ALTER TABLE ticket_lock_type ALTER name DROP DEFAULT;
UPDATE ticket_lock_type SET name = '' WHERE name IS NULL;
ALTER TABLE ticket_lock_type CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table groups
# ----------------------------------------------------------
ALTER TABLE groups CHANGE name name VARCHAR (200) NULL;
ALTER TABLE groups ALTER name DROP DEFAULT;
UPDATE groups SET name = '' WHERE name IS NULL;
ALTER TABLE groups CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table roles
# ----------------------------------------------------------
ALTER TABLE roles CHANGE name name VARCHAR (200) NULL;
ALTER TABLE roles ALTER name DROP DEFAULT;
UPDATE roles SET name = '' WHERE name IS NULL;
ALTER TABLE roles CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table ticket_state
# ----------------------------------------------------------
ALTER TABLE ticket_state CHANGE name name VARCHAR (200) NULL;
ALTER TABLE ticket_state ALTER name DROP DEFAULT;
UPDATE ticket_state SET name = '' WHERE name IS NULL;
ALTER TABLE ticket_state CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table ticket_state_type
# ----------------------------------------------------------
ALTER TABLE ticket_state_type CHANGE name name VARCHAR (200) NULL;
ALTER TABLE ticket_state_type ALTER name DROP DEFAULT;
UPDATE ticket_state_type SET name = '' WHERE name IS NULL;
ALTER TABLE ticket_state_type CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table salutation
# ----------------------------------------------------------
ALTER TABLE salutation CHANGE name name VARCHAR (200) NULL;
ALTER TABLE salutation ALTER name DROP DEFAULT;
UPDATE salutation SET name = '' WHERE name IS NULL;
ALTER TABLE salutation CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table signature
# ----------------------------------------------------------
ALTER TABLE signature CHANGE name name VARCHAR (200) NULL;
ALTER TABLE signature ALTER name DROP DEFAULT;
UPDATE signature SET name = '' WHERE name IS NULL;
ALTER TABLE signature CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table system_address
# ----------------------------------------------------------
ALTER TABLE system_address CHANGE comments comments VARCHAR (250) NULL;
ALTER TABLE system_address ALTER comments DROP DEFAULT;
# ----------------------------------------------------------
#  alter table follow_up_possible
# ----------------------------------------------------------
ALTER TABLE follow_up_possible CHANGE name name VARCHAR (200) NULL;
ALTER TABLE follow_up_possible ALTER name DROP DEFAULT;
UPDATE follow_up_possible SET name = '' WHERE name IS NULL;
ALTER TABLE follow_up_possible CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table queue
# ----------------------------------------------------------
ALTER TABLE queue CHANGE comments comments VARCHAR (250) NULL;
ALTER TABLE queue ALTER comments DROP DEFAULT;
# ----------------------------------------------------------
#  alter table ticket_history_type
# ----------------------------------------------------------
ALTER TABLE ticket_history_type CHANGE name name VARCHAR (200) NULL;
ALTER TABLE ticket_history_type ALTER name DROP DEFAULT;
UPDATE ticket_history_type SET name = '' WHERE name IS NULL;
ALTER TABLE ticket_history_type CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table article_type
# ----------------------------------------------------------
ALTER TABLE article_type CHANGE name name VARCHAR (200) NULL;
ALTER TABLE article_type ALTER name DROP DEFAULT;
UPDATE article_type SET name = '' WHERE name IS NULL;
ALTER TABLE article_type CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table article_sender_type
# ----------------------------------------------------------
ALTER TABLE article_sender_type CHANGE name name VARCHAR (200) NULL;
ALTER TABLE article_sender_type ALTER name DROP DEFAULT;
UPDATE article_sender_type SET name = '' WHERE name IS NULL;
ALTER TABLE article_sender_type CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table standard_response
# ----------------------------------------------------------
ALTER TABLE standard_response CHANGE comments comments VARCHAR (250) NULL;
ALTER TABLE standard_response ALTER comments DROP DEFAULT;
# ----------------------------------------------------------
#  alter table standard_response
# ----------------------------------------------------------
ALTER TABLE standard_response CHANGE name name VARCHAR (200) NULL;
ALTER TABLE standard_response ALTER name DROP DEFAULT;
UPDATE standard_response SET name = '' WHERE name IS NULL;
ALTER TABLE standard_response CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table standard_attachment
# ----------------------------------------------------------
ALTER TABLE standard_attachment CHANGE comments comments VARCHAR (250) NULL;
ALTER TABLE standard_attachment ALTER comments DROP DEFAULT;
# ----------------------------------------------------------
#  alter table standard_attachment
# ----------------------------------------------------------
ALTER TABLE standard_attachment CHANGE content_type content_type VARCHAR (250) NULL;
ALTER TABLE standard_attachment ALTER content_type DROP DEFAULT;
UPDATE standard_attachment SET content_type = '' WHERE content_type IS NULL;
ALTER TABLE standard_attachment CHANGE content_type content_type VARCHAR (250) NOT NULL;
# ----------------------------------------------------------
#  alter table standard_attachment
# ----------------------------------------------------------
ALTER TABLE standard_attachment CHANGE name name VARCHAR (200) NULL;
ALTER TABLE standard_attachment ALTER name DROP DEFAULT;
UPDATE standard_attachment SET name = '' WHERE name IS NULL;
ALTER TABLE standard_attachment CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table auto_response_type
# ----------------------------------------------------------
ALTER TABLE auto_response_type CHANGE comments comments VARCHAR (250) NULL;
ALTER TABLE auto_response_type ALTER comments DROP DEFAULT;
# ----------------------------------------------------------
#  alter table auto_response_type
# ----------------------------------------------------------
ALTER TABLE auto_response_type CHANGE name name VARCHAR (200) NULL;
ALTER TABLE auto_response_type ALTER name DROP DEFAULT;
UPDATE auto_response_type SET name = '' WHERE name IS NULL;
ALTER TABLE auto_response_type CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table auto_response
# ----------------------------------------------------------
ALTER TABLE auto_response CHANGE comments comments VARCHAR (250) NULL;
ALTER TABLE auto_response ALTER comments DROP DEFAULT;
# ----------------------------------------------------------
#  alter table auto_response
# ----------------------------------------------------------
ALTER TABLE auto_response CHANGE name name VARCHAR (200) NULL;
ALTER TABLE auto_response ALTER name DROP DEFAULT;
UPDATE auto_response SET name = '' WHERE name IS NULL;
ALTER TABLE auto_response CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table service
# ----------------------------------------------------------
ALTER TABLE service CHANGE comments comments VARCHAR (250) NULL;
ALTER TABLE service ALTER comments DROP DEFAULT;
# ----------------------------------------------------------
#  alter table service_customer_user
# ----------------------------------------------------------
ALTER TABLE service_customer_user CHANGE customer_user_login customer_user_login VARCHAR (200) NULL;
ALTER TABLE service_customer_user ALTER customer_user_login DROP DEFAULT;
UPDATE service_customer_user SET customer_user_login = '' WHERE customer_user_login IS NULL;
ALTER TABLE service_customer_user CHANGE customer_user_login customer_user_login VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table sla
# ----------------------------------------------------------
ALTER TABLE sla CHANGE comments comments VARCHAR (250) NULL;
ALTER TABLE sla ALTER comments DROP DEFAULT;
# ----------------------------------------------------------
#  alter table customer_company
# ----------------------------------------------------------
ALTER TABLE customer_company CHANGE customer_id customer_id VARCHAR (150) NULL;
ALTER TABLE customer_company ALTER customer_id DROP DEFAULT;
UPDATE customer_company SET customer_id = '' WHERE customer_id IS NULL;
ALTER TABLE customer_company CHANGE customer_id customer_id VARCHAR (150) NOT NULL;
# ----------------------------------------------------------
#  alter table customer_company
# ----------------------------------------------------------
ALTER TABLE customer_company CHANGE name name VARCHAR (200) NULL;
ALTER TABLE customer_company ALTER name DROP DEFAULT;
UPDATE customer_company SET name = '' WHERE name IS NULL;
ALTER TABLE customer_company CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table notification_event
# ----------------------------------------------------------
ALTER TABLE notification_event CHANGE content_type content_type VARCHAR (250) NULL;
ALTER TABLE notification_event ALTER content_type DROP DEFAULT;
UPDATE notification_event SET content_type = '' WHERE content_type IS NULL;
ALTER TABLE notification_event CHANGE content_type content_type VARCHAR (250) NOT NULL;
# ----------------------------------------------------------
#  alter table notification_event
# ----------------------------------------------------------
ALTER TABLE notification_event ADD comments VARCHAR (250) NULL;
# ----------------------------------------------------------
#  alter table package_repository
# ----------------------------------------------------------
ALTER TABLE package_repository CHANGE name name VARCHAR (200) NULL;
ALTER TABLE package_repository ALTER name DROP DEFAULT;
UPDATE package_repository SET name = '' WHERE name IS NULL;
ALTER TABLE package_repository CHANGE name name VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table article_attachment
# ----------------------------------------------------------
ALTER TABLE article_attachment CHANGE content_type content_type TEXT NULL;
ALTER TABLE article_attachment ALTER content_type DROP DEFAULT;
ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_virtual_fs_id_id FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id);
