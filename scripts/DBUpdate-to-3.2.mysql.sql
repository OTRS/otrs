# ----------------------------------------------------------
#  driver: mysql, generated: 2014-03-29 16:35:45
# ----------------------------------------------------------
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP group_read;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP group_write;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP other_read;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP other_write;
DROP INDEX ticket_answered ON ticket;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP ticket_answered;
DROP INDEX ticket_queue_view ON ticket;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP group_id;
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
# ----------------------------------------------------------
#  create table pm_process
# ----------------------------------------------------------
CREATE TABLE pm_process (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    state_entity_id VARCHAR (50) NOT NULL,
    layout LONGBLOB NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_process_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_activity
# ----------------------------------------------------------
CREATE TABLE pm_activity (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_activity_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_activity_dialog
# ----------------------------------------------------------
CREATE TABLE pm_activity_dialog (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_activity_dialog_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_transition
# ----------------------------------------------------------
CREATE TABLE pm_transition (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_transition_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_transition_action
# ----------------------------------------------------------
CREATE TABLE pm_transition_action (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_transition_action_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_entity
# ----------------------------------------------------------
CREATE TABLE pm_entity (
    entity_type VARCHAR (50) NOT NULL,
    entity_counter INTEGER NOT NULL
);
# ----------------------------------------------------------
#  create table pm_entity_sync
# ----------------------------------------------------------
CREATE TABLE pm_entity_sync (
    entity_type VARCHAR (30) NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    sync_state VARCHAR (30) NOT NULL,
    create_time DATETIME NOT NULL,
    change_time DATETIME NOT NULL,
    UNIQUE INDEX pm_entity_sync_list (entity_type, entity_id)
);
# ----------------------------------------------------------
#  alter table dynamic_field
# ----------------------------------------------------------
ALTER TABLE dynamic_field ADD internal_field SMALLINT NULL;
UPDATE dynamic_field SET internal_field = 0 WHERE internal_field IS NULL;
ALTER TABLE dynamic_field CHANGE internal_field internal_field SMALLINT DEFAULT 0 NOT NULL;
# ----------------------------------------------------------
#  insert into table dynamic_field
# ----------------------------------------------------------
INSERT INTO dynamic_field (internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'ProcessManagementProcessID', 'ProcessManagementProcessID', 1, 'Text', 'Ticket', '---DefaultValue: \'\'', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table dynamic_field
# ----------------------------------------------------------
INSERT INTO dynamic_field (internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'ProcessManagementActivityID', 'ProcessManagementActivityID', 1, 'Text', 'Ticket', '---DefaultValue: \'\'', 1, 1, current_timestamp, 1, current_timestamp);
DROP TABLE IF EXISTS sessions;
# ----------------------------------------------------------
#  create table sessions
# ----------------------------------------------------------
CREATE TABLE sessions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    session_id VARCHAR (100) NOT NULL,
    data_key VARCHAR (100) NOT NULL,
    data_value TEXT NULL,
    serialized SMALLINT NOT NULL,
    PRIMARY KEY(id),
    INDEX sessions_data_key (data_key),
    INDEX sessions_session_id_data_key (session_id, data_key)
);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_transition ADD CONSTRAINT FK_pm_transition_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_transition ADD CONSTRAINT FK_pm_transition_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_transition_action ADD CONSTRAINT FK_pm_transition_action_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_transition_action ADD CONSTRAINT FK_pm_transition_action_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
