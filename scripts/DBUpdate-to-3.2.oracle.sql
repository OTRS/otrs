-- ----------------------------------------------------------
--  driver: oracle, generated: 2014-03-29 16:35:45
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
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
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_pm_process';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_pm_process
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_pm_process_t
BEFORE INSERT ON pm_process
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_pm_process.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
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
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_pm_activity';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_pm_activity
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_pm_activity_t
BEFORE INSERT ON pm_activity
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_pm_activity.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
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
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_pm_activity_dialog';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_pm_activity_dialog
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_pm_activity_dialog_t
BEFORE INSERT ON pm_activity_dialog
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_pm_activity_dialog.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX FK_pm_activity_dialog_change65 ON pm_activity_dialog (change_by);
CREATE INDEX FK_pm_activity_dialog_create86 ON pm_activity_dialog (create_by);
-- ----------------------------------------------------------
--  create table pm_transition
-- ----------------------------------------------------------
CREATE TABLE pm_transition (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_transition_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_transition ADD CONSTRAINT PK_pm_transition PRIMARY KEY (id);
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_pm_transition';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_pm_transition
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_pm_transition_t
BEFORE INSERT ON pm_transition
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_pm_transition.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX FK_pm_transition_change_by ON pm_transition (change_by);
CREATE INDEX FK_pm_transition_create_by ON pm_transition (create_by);
-- ----------------------------------------------------------
--  create table pm_transition_action
-- ----------------------------------------------------------
CREATE TABLE pm_transition_action (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_transition_action_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_transition_action ADD CONSTRAINT PK_pm_transition_action PRIMARY KEY (id);
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_pm_transition_action';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_pm_transition_action
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_pm_transition_action_t
BEFORE INSERT ON pm_transition_action
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_pm_transition_action.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX FK_pm_transition_action_chan4f ON pm_transition_action (change_by);
CREATE INDEX FK_pm_transition_action_crea78 ON pm_transition_action (create_by);
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
DROP TABLE sessions CASCADE CONSTRAINTS;
-- ----------------------------------------------------------
--  create table sessions
-- ----------------------------------------------------------
CREATE TABLE sessions (
    id NUMBER (20, 0) NOT NULL,
    session_id VARCHAR2 (100) NOT NULL,
    data_key VARCHAR2 (100) NOT NULL,
    data_value CLOB NULL,
    serialized NUMBER (5, 0) NOT NULL
);
ALTER TABLE sessions ADD CONSTRAINT PK_sessions PRIMARY KEY (id);
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_sessions';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_sessions
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_sessions_t
BEFORE INSERT ON sessions
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_sessions.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX sessions_data_key ON sessions (data_key);
CREATE INDEX sessions_session_id_data_key ON sessions (session_id, data_key);
SET DEFINE OFF;
SET SQLBLANKLINES ON;
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_create32 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_changee5 FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_transition ADD CONSTRAINT FK_pm_transition_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_transition ADD CONSTRAINT FK_pm_transition_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_transition_action ADD CONSTRAINT FK_pm_transition_action_crea8b FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_transition_action ADD CONSTRAINT FK_pm_transition_action_chan8c FOREIGN KEY (change_by) REFERENCES users (id);
