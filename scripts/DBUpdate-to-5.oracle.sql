-- ----------------------------------------------------------
--  driver: oracle
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
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
