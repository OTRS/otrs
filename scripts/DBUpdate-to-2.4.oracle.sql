-- ----------------------------------------------------------
--  driver: oracle, generated: 2009-03-25 02:28:08
-- ----------------------------------------------------------
SET DEFINE OFF;
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
ALTER TABLE service_preferences ADD CONSTRAINT FK_service_preferences_servi62 FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE sla_preferences ADD CONSTRAINT FK_sla_preferences_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id);
