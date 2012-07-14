-- ----------------------------------------------------------
--  driver: oracle, generated: 2012-07-13 23:48:12
-- ----------------------------------------------------------
SET DEFINE OFF;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_read;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_write;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN other_read;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN other_write;
DROP INDEX ticket_answered;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN ticket_answered;
DROP INDEX article_flag_create_by;
DROP INDEX article_flag_article_id_artif0;
DROP INDEX ticket_queue_view;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_id;
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
-- ----------------------------------------------------------
--  create table pm_process
-- ----------------------------------------------------------
CREATE TABLE pm_process (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    state_entity_id VARCHAR2 (50) NOT NULL,
    layout CLOB NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_process_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_process ADD CONSTRAINT PK_pm_process PRIMARY KEY (id);
DROP SEQUENCE SE_pm_process;
CREATE SEQUENCE SE_pm_process;
CREATE OR REPLACE TRIGGER SE_pm_process_t
before insert on pm_process
for each row
begin
  if :new.id IS NULL then
    select SE_pm_process.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_pm_process_change_by ON pm_process (change_by);
CREATE INDEX FK_pm_process_create_by ON pm_process (create_by);
-- ----------------------------------------------------------
--  create table pm_activity
-- ----------------------------------------------------------
CREATE TABLE pm_activity (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_activity_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_activity ADD CONSTRAINT PK_pm_activity PRIMARY KEY (id);
DROP SEQUENCE SE_pm_activity;
CREATE SEQUENCE SE_pm_activity;
CREATE OR REPLACE TRIGGER SE_pm_activity_t
before insert on pm_activity
for each row
begin
  if :new.id IS NULL then
    select SE_pm_activity.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_pm_activity_change_by ON pm_activity (change_by);
CREATE INDEX FK_pm_activity_create_by ON pm_activity (create_by);
-- ----------------------------------------------------------
--  create table pm_activity_dialog
-- ----------------------------------------------------------
CREATE TABLE pm_activity_dialog (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_activity_dialog_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT PK_pm_activity_dialog PRIMARY KEY (id);
DROP SEQUENCE SE_pm_activity_dialog;
CREATE SEQUENCE SE_pm_activity_dialog;
CREATE OR REPLACE TRIGGER SE_pm_activity_dialog_t
before insert on pm_activity_dialog
for each row
begin
  if :new.id IS NULL then
    select SE_pm_activity_dialog.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_pm_activity_dialog_change65 ON pm_activity_dialog (change_by);
CREATE INDEX FK_pm_activity_dialog_create86 ON pm_activity_dialog (create_by);
-- ----------------------------------------------------------
--  create table pm_entity
-- ----------------------------------------------------------
CREATE TABLE pm_entity (
    entity_type VARCHAR2 (50) NOT NULL,
    entity_counter NUMBER (12, 0) NOT NULL
);
-- ----------------------------------------------------------
--  create table pm_entity_sync
-- ----------------------------------------------------------
CREATE TABLE pm_entity_sync (
    entity_type VARCHAR2 (30) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    sync_state VARCHAR2 (30) NOT NULL,
    create_time DATE NOT NULL,
    change_time DATE NOT NULL,
    CONSTRAINT pm_entity_sync_list UNIQUE (entity_type, entity_id)
);
-- ----------------------------------------------------------
--  alter table dynamic_field
-- ----------------------------------------------------------
ALTER TABLE dynamic_field ADD internal_field NUMBER (5, 0) NULL;
UPDATE dynamic_field SET internal_field = 0 WHERE internal_field IS NULL;
ALTER TABLE dynamic_field MODIFY internal_field NUMBER (5, 0) DEFAULT 0 NOT NULL;
-- ----------------------------------------------------------
--  insert into table dynamic_field
-- ----------------------------------------------------------
INSERT INTO dynamic_field (internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'ProcessManagementProcessID', 'ProcessManagementProcessID', 1, 'Text', 'Ticket', '---DefaultValue: ''''', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table dynamic_field
-- ----------------------------------------------------------
INSERT INTO dynamic_field (internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'ProcessManagementActivityID', 'ProcessManagementActivityID', 1, 'Text', 'Ticket', '---DefaultValue: ''''', 1, 1, current_timestamp, 1, current_timestamp);
SET DEFINE OFF;
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_create32 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_changee5 FOREIGN KEY (change_by) REFERENCES users (id);
