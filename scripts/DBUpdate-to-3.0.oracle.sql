-- ----------------------------------------------------------
--  driver: oracle, generated: 2011-01-10 15:36:34
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
CREATE INDEX ticket_archive_flag ON ticket (archive_flag);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ArchiveFlagUpdate', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  create table ticket_flag
-- ----------------------------------------------------------
CREATE TABLE ticket_flag (
    ticket_id NUMBER (20, 0) NOT NULL,
    ticket_key VARCHAR2 (50) NOT NULL,
    ticket_value VARCHAR2 (50) NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_ticket_flag_create_by ON ticket_flag (create_by);
CREATE INDEX ticket_flag_ticket_id ON ticket_flag (ticket_id);
CREATE INDEX ticket_flag_ticket_id_create7d ON ticket_flag (ticket_id, create_by);
CREATE INDEX ticket_flag_ticket_id_ticketca ON ticket_flag (ticket_id, ticket_key);
-- ----------------------------------------------------------
--  alter table article_flag
-- ----------------------------------------------------------
ALTER TABLE article_flag RENAME COLUMN article_flag TO article_key;
ALTER TABLE article_flag MODIFY article_key VARCHAR2 (50) DEFAULT NULL;
-- ----------------------------------------------------------
--  alter table article_flag
-- ----------------------------------------------------------
ALTER TABLE article_flag ADD article_value VARCHAR2 (50) NULL;
CREATE INDEX article_flag_article_id_crea15 ON article_flag (article_id, create_by);
CREATE INDEX article_flag_article_id_artif0 ON article_flag (article_id, article_key);
DROP INDEX article_flag_create_by;
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
ALTER TABLE customer_user MODIFY pw VARCHAR2 (64) DEFAULT NULL;
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users RENAME COLUMN salutation TO title;
ALTER TABLE users MODIFY title VARCHAR2 (50) DEFAULT NULL;
ALTER TABLE users MODIFY login VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE users MODIFY pw VARCHAR2 (64) DEFAULT NULL;
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
ALTER TABLE ticket_flag ADD CONSTRAINT FK_ticket_flag_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
ALTER TABLE ticket_flag ADD CONSTRAINT FK_ticket_flag_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
