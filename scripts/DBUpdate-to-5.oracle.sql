-- ----------------------------------------------------------
--  driver: oracle
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
-- ----------------------------------------------------------
--  create table scheduler_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_task (
    id NUMBER (20, 0) NOT NULL,
    ident NUMBER (20, 0) NOT NULL,
    name VARCHAR2 (150) NULL,
    task_type VARCHAR2 (150) NOT NULL,
    task_data CLOB NOT NULL,
    attempts NUMBER (5, 0) NOT NULL,
    lock_key NUMBER (20, 0) NOT NULL,
    lock_time DATE NULL,
    lock_update_time DATE NULL,
    create_time DATE NOT NULL,
    CONSTRAINT scheduler_task_ident UNIQUE (ident)
);
ALTER TABLE scheduler_task ADD CONSTRAINT PK_scheduler_task PRIMARY KEY (id);
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_scheduler_task';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_scheduler_task
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_scheduler_task_t
BEFORE INSERT ON scheduler_task
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_scheduler_task.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX scheduler_task_ident_id ON scheduler_task (ident, id);
CREATE INDEX scheduler_task_lock_key_id ON scheduler_task (lock_key, id);
-- ----------------------------------------------------------
--  create table scheduler_future_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_future_task (
    id NUMBER (20, 0) NOT NULL,
    ident NUMBER (20, 0) NOT NULL,
    execution_time DATE NOT NULL,
    name VARCHAR2 (150) NULL,
    task_type VARCHAR2 (150) NOT NULL,
    task_data CLOB NOT NULL,
    attempts NUMBER (5, 0) NOT NULL,
    lock_key NUMBER (20, 0) NOT NULL,
    lock_time DATE NULL,
    create_time DATE NOT NULL,
    CONSTRAINT scheduler_future_task_ident UNIQUE (ident)
);
ALTER TABLE scheduler_future_task ADD CONSTRAINT PK_scheduler_future_task PRIMARY KEY (id);
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_scheduler_future_task';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_scheduler_future_task
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_scheduler_future_task_t
BEFORE INSERT ON scheduler_future_task
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_scheduler_future_task.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX scheduler_future_task_ident_id ON scheduler_future_task (ident, id);
CREATE INDEX scheduler_future_task_lock_kbd ON scheduler_future_task (lock_key, id);
-- ----------------------------------------------------------
--  create table scheduler_recurrent_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_recurrent_task (
    id NUMBER (20, 0) NOT NULL,
    name VARCHAR2 (150) NOT NULL,
    task_type VARCHAR2 (150) NOT NULL,
    last_execution_time DATE NOT NULL,
    last_worker_task_id NUMBER (20, 0) NULL,
    last_worker_status NUMBER (5, 0) NULL,
    last_worker_running_time NUMBER (12, 0) NULL,
    lock_key NUMBER (20, 0) NOT NULL,
    lock_time DATE NULL,
    create_time DATE NOT NULL,
    change_time DATE NOT NULL,
    CONSTRAINT scheduler_recurrent_task_nam4e UNIQUE (name, task_type)
);
ALTER TABLE scheduler_recurrent_task ADD CONSTRAINT PK_scheduler_recurrent_task PRIMARY KEY (id);
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_scheduler_recurrent_task';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_scheduler_recurrent_task
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_scheduler_recurrent_task_t
BEFORE INSERT ON scheduler_recurrent_task
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_scheduler_recurrent_task.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX scheduler_recurrent_task_locb6 ON scheduler_recurrent_task (lock_key, id);
CREATE INDEX scheduler_recurrent_task_tas3a ON scheduler_recurrent_task (task_type, name);
DROP TABLE scheduler_task_list CASCADE CONSTRAINTS;
-- ----------------------------------------------------------
--  alter table auto_response
-- ----------------------------------------------------------
ALTER TABLE auto_response DROP COLUMN text2;
-- ----------------------------------------------------------
--  create table notification_event_message
-- ----------------------------------------------------------
CREATE TABLE notification_event_message (
    id NUMBER (12, 0) NOT NULL,
    notification_id NUMBER (12, 0) NOT NULL,
    subject VARCHAR2 (200) NOT NULL,
    text VARCHAR2 (4000) NOT NULL,
    content_type VARCHAR2 (250) NOT NULL,
    language VARCHAR2 (60) NOT NULL,
    CONSTRAINT notification_event_message_nb4 UNIQUE (notification_id, language)
);
ALTER TABLE notification_event_message ADD CONSTRAINT PK_notification_event_message PRIMARY KEY (id);
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_notification_event_messe4';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_notification_event_messe4
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_notification_event_messe4_t
BEFORE INSERT ON notification_event_message
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_notification_event_messe4.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX notification_event_message_lb8 ON notification_event_message (language);
CREATE INDEX notification_event_message_n1c ON notification_event_message (notification_id);
SET DEFINE OFF;
SET SQLBLANKLINES ON;
ALTER TABLE notification_event_message ADD CONSTRAINT FK_notification_event_messag16 FOREIGN KEY (notification_id) REFERENCES notification_event (id);
