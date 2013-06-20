-- ----------------------------------------------------------
--  driver: postgresql_before_8_2, generated: 2013-06-20 10:38:00
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('TitleUpdate', 1, 1, current_timestamp, 1, current_timestamp);
DROP INDEX index_search_date;
CREATE INDEX dynamic_field_value_search_date ON dynamic_field_value (field_id, value_date);
DROP INDEX index_search_int;
CREATE INDEX dynamic_field_value_search_int ON dynamic_field_value (field_id, value_int);
DROP INDEX index_field_values;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id);
DROP INDEX article_message_id;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD a_message_id_md5 VARCHAR (32) NULL;
CREATE INDEX article_message_id_md5 ON article (a_message_id_md5);
DROP INDEX article_search_message_id;
-- ----------------------------------------------------------
--  alter table article_search
-- ----------------------------------------------------------
ALTER TABLE article_search DROP a_message_id;
-- ----------------------------------------------------------
--  create table system_data
-- ----------------------------------------------------------
CREATE TABLE system_data (
    data_key VARCHAR (160) NOT NULL,
    data_value TEXT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(data_key)
);
-- ----------------------------------------------------------
--  create table acl
-- ----------------------------------------------------------
CREATE TABLE acl (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NOT NULL,
    description VARCHAR (250) NULL,
    valid_id INTEGER NOT NULL,
    stop_after_match INTEGER NULL,
    config_match TEXT NULL,
    config_change TEXT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT acl_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table acl_sync
-- ----------------------------------------------------------
CREATE TABLE acl_sync (
    acl_id VARCHAR (200) NOT NULL,
    sync_state VARCHAR (30) NOT NULL,
    create_time timestamp(0) NOT NULL,
    change_time timestamp(0) NOT NULL
);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE acl ADD CONSTRAINT FK_acl_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE acl ADD CONSTRAINT FK_acl_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE acl ADD CONSTRAINT FK_acl_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
