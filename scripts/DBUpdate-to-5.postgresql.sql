-- ----------------------------------------------------------
--  driver: postgresql
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
-- ----------------------------------------------------------
--  create table scheduler_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_task (
    id bigserial NOT NULL,
    ident BIGINT NOT NULL,
    name VARCHAR (150) NULL,
    task_type VARCHAR (150) NOT NULL,
    task_data TEXT NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time timestamp(0) NULL,
    lock_update_time timestamp(0) NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_task_ident UNIQUE (ident)
);
CREATE INDEX scheduler_task_ident_id ON scheduler_task (ident, id);
CREATE INDEX scheduler_task_lock_key_id ON scheduler_task (lock_key, id);
-- ----------------------------------------------------------
--  create table scheduler_future_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_future_task (
    id bigserial NOT NULL,
    ident BIGINT NOT NULL,
    execution_time timestamp(0) NOT NULL,
    name VARCHAR (150) NULL,
    task_type VARCHAR (150) NOT NULL,
    task_data TEXT NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time timestamp(0) NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_future_task_ident UNIQUE (ident)
);
CREATE INDEX scheduler_future_task_ident_id ON scheduler_future_task (ident, id);
CREATE INDEX scheduler_future_task_lock_key_id ON scheduler_future_task (lock_key, id);
-- ----------------------------------------------------------
--  create table scheduler_recurrent_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_recurrent_task (
    id bigserial NOT NULL,
    name VARCHAR (150) NOT NULL,
    task_type VARCHAR (150) NOT NULL,
    last_execution_time timestamp(0) NOT NULL,
    last_worker_task_id BIGINT NULL,
    last_worker_status SMALLINT NULL,
    last_worker_running_time INTEGER NULL,
    lock_key BIGINT NOT NULL,
    lock_time timestamp(0) NULL,
    create_time timestamp(0) NOT NULL,
    change_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_recurrent_task_name_task_type UNIQUE (name, task_type)
);
CREATE INDEX scheduler_recurrent_task_lock_key_id ON scheduler_recurrent_task (lock_key, id);
CREATE INDEX scheduler_recurrent_task_task_type_name ON scheduler_recurrent_task (task_type, name);
DROP TABLE scheduler_task_list;
-- ----------------------------------------------------------
--  alter table auto_response
-- ----------------------------------------------------------
ALTER TABLE auto_response DROP text2;
-- ----------------------------------------------------------
--  create table notification_event_message
-- ----------------------------------------------------------
CREATE TABLE notification_event_message (
    id serial NOT NULL,
    notification_id INTEGER NOT NULL,
    subject VARCHAR (200) NOT NULL,
    text VARCHAR (4000) NOT NULL,
    content_type VARCHAR (250) NOT NULL,
    language VARCHAR (60) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT notification_event_message_notification_id_language UNIQUE (notification_id, language)
);
CREATE INDEX notification_event_message_language ON notification_event_message (language);
CREATE INDEX notification_event_message_notification_id ON notification_event_message (notification_id);
-- ----------------------------------------------------------
--  create table cloud_service_config
-- ----------------------------------------------------------
CREATE TABLE cloud_service_config (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    config_md5 VARCHAR (32) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT cloud_service_config_config_md5 UNIQUE (config_md5),
    CONSTRAINT cloud_service_config_name UNIQUE (name)
);
SET standard_conforming_strings TO ON;
ALTER TABLE notification_event_message ADD CONSTRAINT FK_notification_event_message_notification_id_id FOREIGN KEY (notification_id) REFERENCES notification_event (id);
ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
