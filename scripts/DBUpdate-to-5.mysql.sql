# ----------------------------------------------------------
#  driver: mysql
# ----------------------------------------------------------
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
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
ALTER TABLE notification_event_message ADD CONSTRAINT FK_notification_event_message_notification_id_id FOREIGN KEY (notification_id) REFERENCES notification_event (id);
