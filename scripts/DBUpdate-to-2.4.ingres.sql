-- ----------------------------------------------------------
--  driver: ingres, generated: 2009-05-15 11:45:14
-- ----------------------------------------------------------
CREATE SEQUENCE notification_event_741;\g
CREATE TABLE notification_event (
    id INTEGER NOT NULL DEFAULT notification_event_741.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    text VARCHAR(4000) NOT NULL,
    content_type VARCHAR(100) NOT NULL,
    charset VARCHAR(100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY notification_event TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE notification_event ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE TABLE notification_event_item (
    notification_id INTEGER NOT NULL,
    event_key VARCHAR(200) NOT NULL,
    event_value VARCHAR(200) NOT NULL
);\g
MODIFY notification_event_item TO btree;\g
CREATE INDEX notification_event_item_event_key ON notification_event_item (event_key);\g
CREATE INDEX notification_event_item_event_value ON notification_event_item (event_value);\g
CREATE INDEX notification_event_item_notification_id ON notification_event_item (notification_id);\g
-- ----------------------------------------------------------
--  alter table postmaster_filter
-- ----------------------------------------------------------
ALTER TABLE postmaster_filter ADD COLUMN f_stop SMALLINT;\g
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD COLUMN a_in_reply_to VARCHAR(3800);\g
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD COLUMN a_references VARCHAR(3800);\g
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD COLUMN content_id VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD COLUMN content_alternative VARCHAR(50);\g
CREATE TABLE service_preferences (
    service_id INTEGER NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY service_preferences TO btree;\g
CREATE INDEX service_preferences_service_id ON service_preferences (service_id);\g
CREATE TABLE sla_preferences (
    sla_id INTEGER NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY sla_preferences TO btree;\g
CREATE INDEX sla_preferences_sla_id ON sla_preferences (sla_id);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN phone VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN fax VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN mobile VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN street VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN zip VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN city VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN country VARCHAR(150);\g
-- ----------------------------------------------------------
--  alter table salutation
-- ----------------------------------------------------------
ALTER TABLE salutation ADD COLUMN content_type VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table signature
-- ----------------------------------------------------------
ALTER TABLE signature ADD COLUMN content_type VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table standard_response
-- ----------------------------------------------------------
ALTER TABLE standard_response ADD COLUMN content_type VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table auto_response
-- ----------------------------------------------------------
ALTER TABLE auto_response ADD COLUMN content_type VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table notifications
-- ----------------------------------------------------------
ALTER TABLE notifications ADD COLUMN content_type VARCHAR(250);\g
-- ----------------------------------------------------------
--  alter table web_upload_cache
-- ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD COLUMN content_id VARCHAR(250);\g
ALTER TABLE notification_event ADD FOREIGN KEY (create_by) REFERENCES users(id);\g
ALTER TABLE notification_event ADD FOREIGN KEY (change_by) REFERENCES users(id);\g
ALTER TABLE notification_event ADD FOREIGN KEY (valid_id) REFERENCES valid(id);\g
ALTER TABLE notification_event_item ADD FOREIGN KEY (notification_id) REFERENCES notification_event(id);\g
ALTER TABLE service_preferences ADD FOREIGN KEY (service_id) REFERENCES service(id);\g
ALTER TABLE sla_preferences ADD FOREIGN KEY (sla_id) REFERENCES sla(id);\g
