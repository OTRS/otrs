# ----------------------------------------------------------
#  driver: mysql, generated: 2009-07-13 14:35:40
# ----------------------------------------------------------
# ----------------------------------------------------------
#  create table notification_event
# ----------------------------------------------------------
CREATE TABLE notification_event (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    subject VARCHAR (200) NOT NULL,
    text TEXT NOT NULL,
    content_type VARCHAR (100) NOT NULL,
    charset VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX notification_event_name (name)
);
# ----------------------------------------------------------
#  create table notification_event_item
# ----------------------------------------------------------
CREATE TABLE notification_event_item (
    notification_id INTEGER NOT NULL,
    event_key VARCHAR (200) NOT NULL,
    event_value VARCHAR (200) NOT NULL,
    INDEX notification_event_item_event_key (event_key),
    INDEX notification_event_item_event_value (event_value),
    INDEX notification_event_item_notification_id (notification_id)
);
# ----------------------------------------------------------
#  alter table postmaster_filter
# ----------------------------------------------------------
ALTER TABLE postmaster_filter ADD f_stop SMALLINT NULL;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket CHANGE until_time until_time INTEGER NULL;
ALTER TABLE ticket ALTER until_time DROP DEFAULT;
UPDATE ticket SET until_time = 0 WHERE until_time IS NULL;
ALTER TABLE ticket CHANGE until_time until_time INTEGER NOT NULL;
CREATE INDEX ticket_until_time ON ticket (until_time);
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket CHANGE timeout timeout INTEGER NULL;
ALTER TABLE ticket ALTER timeout DROP DEFAULT;
UPDATE ticket SET timeout = 0 WHERE timeout IS NULL;
ALTER TABLE ticket CHANGE timeout timeout INTEGER NOT NULL;
CREATE INDEX ticket_timeout ON ticket (timeout);
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article ADD a_in_reply_to TEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article ADD a_references TEXT NULL;
# ----------------------------------------------------------
#  alter table article_attachment
# ----------------------------------------------------------
ALTER TABLE article_attachment ADD content_id VARCHAR (250) NULL;
# ----------------------------------------------------------
#  alter table article_attachment
# ----------------------------------------------------------
ALTER TABLE article_attachment ADD content_alternative VARCHAR (50) NULL;
# ----------------------------------------------------------
#  create table service_preferences
# ----------------------------------------------------------
CREATE TABLE service_preferences (
    service_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL,
    INDEX service_preferences_service_id (service_id)
);
# ----------------------------------------------------------
#  create table sla_preferences
# ----------------------------------------------------------
CREATE TABLE sla_preferences (
    sla_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL,
    INDEX sla_preferences_sla_id (sla_id)
);
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user ADD phone VARCHAR (150) NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user ADD fax VARCHAR (150) NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user ADD mobile VARCHAR (150) NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user ADD street VARCHAR (150) NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user ADD zip VARCHAR (150) NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user ADD city VARCHAR (150) NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user ADD country VARCHAR (150) NULL;
# ----------------------------------------------------------
#  alter table salutation
# ----------------------------------------------------------
ALTER TABLE salutation ADD content_type VARCHAR (250) NULL;
# ----------------------------------------------------------
#  alter table signature
# ----------------------------------------------------------
ALTER TABLE signature ADD content_type VARCHAR (250) NULL;
# ----------------------------------------------------------
#  alter table standard_response
# ----------------------------------------------------------
ALTER TABLE standard_response ADD content_type VARCHAR (250) NULL;
# ----------------------------------------------------------
#  alter table auto_response
# ----------------------------------------------------------
ALTER TABLE auto_response ADD content_type VARCHAR (250) NULL;
# ----------------------------------------------------------
#  alter table notifications
# ----------------------------------------------------------
ALTER TABLE notifications ADD content_type VARCHAR (250) NULL;
# ----------------------------------------------------------
#  alter table web_upload_cache
# ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD content_id VARCHAR (250) NULL;
ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE notification_event_item ADD CONSTRAINT FK_notification_event_item_notification_id_id FOREIGN KEY (notification_id) REFERENCES notification_event (id);
ALTER TABLE service_preferences ADD CONSTRAINT FK_service_preferences_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE sla_preferences ADD CONSTRAINT FK_sla_preferences_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id);
