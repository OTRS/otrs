-- ----------------------------------------------------------
--  driver: oracle, generated: 2013-06-17 11:23:58
-- ----------------------------------------------------------
SET DEFINE OFF;
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
SET DEFINE OFF;
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
