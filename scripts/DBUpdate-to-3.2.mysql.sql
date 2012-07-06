# ----------------------------------------------------------
#  driver: mysql, generated: 2012-07-06 10:40:29
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
DROP INDEX article_flag_create_by ON article_flag;
DROP INDEX article_flag_article_id_article_key ON article_flag;
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
    state_id SMALLINT NOT NULL,
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
#  alter table dynamic_field
# ----------------------------------------------------------
ALTER TABLE dynamic_field ADD internal_field SMALLINT NULL;
UPDATE dynamic_field SET internal_field = 0 WHERE internal_field IS NULL;
ALTER TABLE dynamic_field CHANGE internal_field internal_field SMALLINT DEFAULT 0 NOT NULL;
# ----------------------------------------------------------
#  insert into table dynamic_field
# ----------------------------------------------------------
INSERT INTO dynamic_field (id, internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'ProcessManagementProcessID', 'ProcessManagementProcessID', 1, 'Text', 'Ticket', '---DefaultValue: \'\'', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table dynamic_field
# ----------------------------------------------------------
INSERT INTO dynamic_field (id, internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'ProcessManagementActivityID', 'ProcessManagementActivityID', 1, 'Text', 'Ticket', '---DefaultValue: \'\'', 1, 1, current_timestamp, 1, current_timestamp);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
