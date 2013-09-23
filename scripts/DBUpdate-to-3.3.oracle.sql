-- ----------------------------------------------------------
--  driver: oracle, generated: 2013-09-23 09:59:46
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('TitleUpdate', 1, 1, current_timestamp, 1, current_timestamp);
DROP INDEX index_search_date;
CREATE INDEX dynamic_field_value_search_db3 ON dynamic_field_value (field_id, value_date);
DROP INDEX index_search_int;
CREATE INDEX dynamic_field_value_search_int ON dynamic_field_value (field_id, value_int);
DROP INDEX index_field_values;
CREATE INDEX dynamic_field_value_field_va6e ON dynamic_field_value (object_id);
DROP INDEX article_message_id;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD a_message_id_md5 VARCHAR2 (32) NULL;
CREATE INDEX article_message_id_md5 ON article (a_message_id_md5);
DROP INDEX article_search_message_id;
-- ----------------------------------------------------------
--  alter table article_search
-- ----------------------------------------------------------
ALTER TABLE article_search DROP COLUMN a_message_id;
-- ----------------------------------------------------------
--  create table system_data
-- ----------------------------------------------------------
CREATE TABLE system_data (
    data_key VARCHAR2 (160) NOT NULL,
    data_value CLOB NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE system_data ADD CONSTRAINT PK_system_data PRIMARY KEY (data_key);
CREATE INDEX FK_system_data_change_by ON system_data (change_by);
CREATE INDEX FK_system_data_create_by ON system_data (create_by);
ALTER TABLE user_preferences ADD preferences_value_TEMP CLOB NULL;
UPDATE user_preferences SET preferences_value_TEMP = preferences_value;
ALTER TABLE user_preferences DROP COLUMN preferences_value;
ALTER TABLE user_preferences RENAME COLUMN preferences_value_TEMP TO preferences_value;
ALTER TABLE standard_response DROP CONSTRAINT FK_standard_response_valid_ife;
ALTER TABLE standard_response DROP CONSTRAINT FK_standard_response_create_21;
ALTER TABLE standard_response DROP CONSTRAINT FK_standard_response_change_a1;
ALTER TABLE queue_standard_response DROP CONSTRAINT FK_queue_standard_response_s29;
ALTER TABLE queue_standard_response DROP CONSTRAINT FK_queue_standard_response_q4c;
ALTER TABLE queue_standard_response DROP CONSTRAINT FK_queue_standard_response_c10;
ALTER TABLE queue_standard_response DROP CONSTRAINT FK_queue_standard_response_c38;
ALTER TABLE standard_response_attachment DROP CONSTRAINT FK_standard_response_attachmb9;
ALTER TABLE standard_response_attachment DROP CONSTRAINT FK_standard_response_attachm3d;
ALTER TABLE standard_response_attachment DROP CONSTRAINT FK_standard_response_attachme5;
ALTER TABLE standard_response_attachment DROP CONSTRAINT FK_standard_response_attachmfb;
ALTER TABLE standard_response DROP CONSTRAINT standard_response_name;
-- ----------------------------------------------------------
--  alter table standard_template
-- ----------------------------------------------------------
ALTER TABLE standard_response RENAME TO standard_template;
-- ----------------------------------------------------------
--  alter table queue_standard_template
-- ----------------------------------------------------------
ALTER TABLE queue_standard_response RENAME TO queue_standard_template;
-- ----------------------------------------------------------
--  alter table standard_template_attachment
-- ----------------------------------------------------------
ALTER TABLE standard_response_attachment RENAME TO standard_template_attachment;
ALTER TABLE standard_template ADD CONSTRAINT standard_template_name UNIQUE (name);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_valid_i25 FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_create_e4 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_change_15 FOREIGN KEY (change_by) REFERENCES users (id);
-- ----------------------------------------------------------
--  alter table queue_standard_template
-- ----------------------------------------------------------
ALTER TABLE queue_standard_template RENAME COLUMN standard_response_id TO standard_template_id;
ALTER TABLE queue_standard_template MODIFY standard_template_id NUMBER (12, 0) DEFAULT NULL;
UPDATE queue_standard_template SET standard_template_id = 0 WHERE standard_template_id IS NULL;
ALTER TABLE queue_standard_template MODIFY standard_template_id NUMBER (12, 0) NOT NULL;
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_s29 FOREIGN KEY (standard_template_id) REFERENCES standard_template (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_q01 FOREIGN KEY (queue_id) REFERENCES queue (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_c93 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_cdd FOREIGN KEY (change_by) REFERENCES users (id);
-- ----------------------------------------------------------
--  alter table standard_template_attachment
-- ----------------------------------------------------------
ALTER TABLE standard_template_attachment RENAME COLUMN standard_response_id TO standard_template_id;
ALTER TABLE standard_template_attachment MODIFY standard_template_id NUMBER (12, 0) DEFAULT NULL;
UPDATE standard_template_attachment SET standard_template_id = 0 WHERE standard_template_id IS NULL;
ALTER TABLE standard_template_attachment MODIFY standard_template_id NUMBER (12, 0) NOT NULL;
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachm7e FOREIGN KEY (standard_template_id) REFERENCES standard_template (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachm17 FOREIGN KEY (standard_attachment_id) REFERENCES standard_attachment (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachm64 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachm83 FOREIGN KEY (change_by) REFERENCES users (id);
-- ----------------------------------------------------------
--  alter table postmaster_filter
-- ----------------------------------------------------------
ALTER TABLE postmaster_filter ADD f_not NUMBER (5, 0) NULL;
DROP INDEX virtual_fs_filename;
CREATE INDEX virtual_fs_filename ON virtual_fs (filename);
DROP INDEX virtual_fs_db_filename;
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);
SET DEFINE OFF;
SET SQLBLANKLINES ON;
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
