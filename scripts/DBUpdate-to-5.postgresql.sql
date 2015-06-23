-- ----------------------------------------------------------
--  driver: postgresql
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
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
SET standard_conforming_strings TO ON;
ALTER TABLE notification_event_message ADD CONSTRAINT FK_notification_event_message_notification_id_id FOREIGN KEY (notification_id) REFERENCES notification_event (id);
