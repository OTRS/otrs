-- ----------------------------------------------------------
--  driver: oracle, generated: 2009-12-09 12:36:20
-- ----------------------------------------------------------
SET DEFINE OFF;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket ADD archive_flag NUMBER (5, 0) NULL;
UPDATE ticket SET archive_flag = 0 WHERE archive_flag IS NULL;
ALTER TABLE ticket MODIFY archive_flag NUMBER (5, 0) DEFAULT 0 NOT NULL;
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);
CREATE INDEX ticket_create_time ON ticket (create_time);
CREATE INDEX ticket_until_time ON ticket (until_time);
CREATE INDEX ticket_archive_flag ON ticket (archive_flag);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ArchiveFlagUpdate', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  create table virtual_fs
-- ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id NUMBER (20, 0) NOT NULL,
    filename VARCHAR2 (350) NOT NULL,
    backend VARCHAR2 (60) NOT NULL,
    backend_key VARCHAR2 (160) NOT NULL,
    create_time DATE NOT NULL
);
ALTER TABLE virtual_fs ADD CONSTRAINT PK_virtual_fs PRIMARY KEY (id);
DROP SEQUENCE SE_virtual_fs;
CREATE SEQUENCE SE_virtual_fs;
CREATE OR REPLACE TRIGGER SE_virtual_fs_t
before insert on virtual_fs
for each row
begin
  if :new.id IS NULL then
    select SE_virtual_fs.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX virtual_fs_backend ON virtual_fs (backend);
CREATE INDEX virtual_fs_filename ON virtual_fs (filename);
-- ----------------------------------------------------------
--  create table virtual_fs_preferences
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id NUMBER (20, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (350) NULL
);
CREATE INDEX virtual_fs_preferences_virtuf6 ON virtual_fs_preferences (virtual_fs_id);
-- ----------------------------------------------------------
--  create table virtual_fs_db
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id NUMBER (20, 0) NOT NULL,
    filename VARCHAR2 (350) NOT NULL,
    content CLOB NOT NULL,
    create_time DATE NOT NULL
);
ALTER TABLE virtual_fs_db ADD CONSTRAINT PK_virtual_fs_db PRIMARY KEY (id);
DROP SEQUENCE SE_virtual_fs_db;
CREATE SEQUENCE SE_virtual_fs_db;
CREATE OR REPLACE TRIGGER SE_virtual_fs_db_t
before insert on virtual_fs_db
for each row
begin
  if :new.id IS NULL then
    select SE_virtual_fs_db.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user RENAME COLUMN salutation TO title;
ALTER TABLE customer_user MODIFY title VARCHAR2 (50) DEFAULT NULL;
ALTER TABLE customer_user MODIFY login VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE customer_user MODIFY customer_id VARCHAR2 (150) DEFAULT NULL;
ALTER TABLE customer_user MODIFY zip VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE customer_user MODIFY city VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE customer_user MODIFY country VARCHAR2 (200) DEFAULT NULL;
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users RENAME COLUMN salutation TO title;
ALTER TABLE users MODIFY title VARCHAR2 (50) DEFAULT NULL;
ALTER TABLE users MODIFY login VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE valid MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE ticket_priority MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE ticket_type MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE ticket_lock_type MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE groups MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE roles MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE ticket_state MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE ticket_state_type MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE salutation MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE signature MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE system_address MODIFY comments VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE follow_up_possible MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE queue MODIFY comments VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE ticket_history_type MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE article_type MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE article_sender_type MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE standard_response MODIFY comments VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE standard_response MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE standard_attachment MODIFY comments VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE standard_attachment MODIFY content_type VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE standard_attachment MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE auto_response_type MODIFY comments VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE auto_response_type MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE auto_response MODIFY comments VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE auto_response MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE service MODIFY comments VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE service_customer_user MODIFY customer_user_login VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE sla MODIFY comments VARCHAR2 (250) DEFAULT NULL;
ALTER TABLE customer_company MODIFY customer_id VARCHAR2 (150) DEFAULT NULL;
ALTER TABLE customer_company MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE notification_event MODIFY content_type VARCHAR2 (250) DEFAULT NULL;
-- ----------------------------------------------------------
--  alter table notification_event
-- ----------------------------------------------------------
ALTER TABLE notification_event ADD comments VARCHAR2 (250) NULL;
ALTER TABLE package_repository MODIFY name VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE article_attachment MODIFY content_type VARCHAR2 (450) DEFAULT NULL;
SET DEFINE OFF;
ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_vib1 FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id);
