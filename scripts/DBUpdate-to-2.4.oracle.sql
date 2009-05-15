-- ----------------------------------------------------------
--  driver: oracle, generated: 2009-05-15 11:45:14
-- ----------------------------------------------------------
SET DEFINE OFF;
-- ----------------------------------------------------------
--  create table notification_event
-- ----------------------------------------------------------
CREATE TABLE notification_event (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    subject VARCHAR2 (200) NOT NULL,
    text VARCHAR2 (4000) NOT NULL,
    content_type VARCHAR2 (100) NOT NULL,
    charset VARCHAR2 (100) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT notification_event_name UNIQUE (name)
);
ALTER TABLE notification_event ADD CONSTRAINT PK_notification_event PRIMARY KEY (id);
DROP SEQUENCE SE_notification_event;
CREATE SEQUENCE SE_notification_event;
CREATE OR REPLACE TRIGGER SE_notification_event_t
before insert on notification_event
for each row
begin
  if :new.id IS NULL then
    select SE_notification_event.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_notification_event_changeaf ON notification_event (change_by);
CREATE INDEX FK_notification_event_create9d ON notification_event (create_by);
CREATE INDEX FK_notification_event_valid_id ON notification_event (valid_id);
-- ----------------------------------------------------------
--  create table notification_event_item
-- ----------------------------------------------------------
CREATE TABLE notification_event_item (
    notification_id NUMBER (12, 0) NOT NULL,
    event_key VARCHAR2 (200) NOT NULL,
    event_value VARCHAR2 (200) NOT NULL
);
CREATE INDEX notification_event_item_even64 ON notification_event_item (event_key);
CREATE INDEX notification_event_item_evene4 ON notification_event_item (event_value);
CREATE INDEX notification_event_item_notidc ON notification_event_item (notification_id);
-- ----------------------------------------------------------
--  alter table postmaster_filter
-- ----------------------------------------------------------
ALTER TABLE postmaster_filter ADD f_stop NUMBER (5, 0) NULL;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD a_in_reply_to VARCHAR2 (3800) NULL;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD a_references VARCHAR2 (3800) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD content_id VARCHAR2 (250) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD content_alternative VARCHAR2 (50) NULL;
-- ----------------------------------------------------------
--  create table service_preferences
-- ----------------------------------------------------------
CREATE TABLE service_preferences (
    service_id NUMBER (12, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250) NULL
);
CREATE INDEX service_preferences_service_id ON service_preferences (service_id);
-- ----------------------------------------------------------
--  create table sla_preferences
-- ----------------------------------------------------------
CREATE TABLE sla_preferences (
    sla_id NUMBER (12, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250) NULL
);
CREATE INDEX sla_preferences_sla_id ON sla_preferences (sla_id);
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD phone VARCHAR2 (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD fax VARCHAR2 (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD mobile VARCHAR2 (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD street VARCHAR2 (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD zip VARCHAR2 (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD city VARCHAR2 (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD country VARCHAR2 (150) NULL;
-- ----------------------------------------------------------
--  alter table salutation
-- ----------------------------------------------------------
ALTER TABLE salutation ADD content_type VARCHAR2 (250) NULL;
-- ----------------------------------------------------------
--  alter table signature
-- ----------------------------------------------------------
ALTER TABLE signature ADD content_type VARCHAR2 (250) NULL;
-- ----------------------------------------------------------
--  alter table standard_response
-- ----------------------------------------------------------
ALTER TABLE standard_response ADD content_type VARCHAR2 (250) NULL;
-- ----------------------------------------------------------
--  alter table auto_response
-- ----------------------------------------------------------
ALTER TABLE auto_response ADD content_type VARCHAR2 (250) NULL;
-- ----------------------------------------------------------
--  alter table notifications
-- ----------------------------------------------------------
ALTER TABLE notifications ADD content_type VARCHAR2 (250) NULL;
-- ----------------------------------------------------------
--  alter table web_upload_cache
-- ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD content_id VARCHAR2 (250) NULL;
SET DEFINE OFF;
ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_create23 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_changefb FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_valid_51 FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE notification_event_item ADD CONSTRAINT FK_notification_event_item_nf6 FOREIGN KEY (notification_id) REFERENCES notification_event (id);
ALTER TABLE service_preferences ADD CONSTRAINT FK_service_preferences_servi62 FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE sla_preferences ADD CONSTRAINT FK_sla_preferences_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id);
