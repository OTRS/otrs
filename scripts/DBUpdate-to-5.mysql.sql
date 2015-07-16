# ----------------------------------------------------------
#  driver: mysql
# ----------------------------------------------------------
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
# ----------------------------------------------------------
#  create table scheduler_task
# ----------------------------------------------------------
CREATE TABLE scheduler_task (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ident BIGINT NOT NULL,
    name VARCHAR (150) NULL,
    task_type VARCHAR (150) NOT NULL,
    task_data LONGBLOB NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    lock_update_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX scheduler_task_ident (ident),
    INDEX scheduler_task_ident_id (ident, id),
    INDEX scheduler_task_lock_key_id (lock_key, id)
);
# ----------------------------------------------------------
#  create table scheduler_future_task
# ----------------------------------------------------------
CREATE TABLE scheduler_future_task (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ident BIGINT NOT NULL,
    execution_time DATETIME NOT NULL,
    name VARCHAR (150) NULL,
    task_type VARCHAR (150) NOT NULL,
    task_data LONGBLOB NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX scheduler_future_task_ident (ident),
    INDEX scheduler_future_task_ident_id (ident, id),
    INDEX scheduler_future_task_lock_key_id (lock_key, id)
);
# ----------------------------------------------------------
#  create table scheduler_recurrent_task
# ----------------------------------------------------------
CREATE TABLE scheduler_recurrent_task (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (150) NOT NULL,
    task_type VARCHAR (150) NOT NULL,
    last_execution_time DATETIME NOT NULL,
    last_worker_task_id BIGINT NULL,
    last_worker_status SMALLINT NULL,
    last_worker_running_time INTEGER NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    change_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX scheduler_recurrent_task_name_task_type (name, task_type),
    INDEX scheduler_recurrent_task_lock_key_id (lock_key, id),
    INDEX scheduler_recurrent_task_task_type_name (task_type, name)
);
DROP TABLE IF EXISTS scheduler_task_list;
# ----------------------------------------------------------
#  alter table auto_response
# ----------------------------------------------------------
ALTER TABLE auto_response DROP text2;
# ----------------------------------------------------------
#  create table notification_event_message
# ----------------------------------------------------------
CREATE TABLE notification_event_message (
    id INTEGER NOT NULL AUTO_INCREMENT,
    notification_id INTEGER NOT NULL,
    subject VARCHAR (200) NOT NULL,
    text TEXT NOT NULL,
    content_type VARCHAR (250) NOT NULL,
    language VARCHAR (60) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX notification_event_message_notification_id_language (notification_id, language),
    INDEX notification_event_message_language (language),
    INDEX notification_event_message_notification_id (notification_id)
);
# ----------------------------------------------------------
#  create table cloud_service_config
# ----------------------------------------------------------
CREATE TABLE cloud_service_config (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    config_md5 VARCHAR (32) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX cloud_service_config_config_md5 (config_md5),
    UNIQUE INDEX cloud_service_config_name (name)
);
ALTER TABLE notification_event_message ADD CONSTRAINT FK_notification_event_message_notification_id_id FOREIGN KEY (notification_id) REFERENCES notification_event (id);
ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
