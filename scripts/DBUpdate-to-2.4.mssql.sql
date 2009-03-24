-- ----------------------------------------------------------
--  driver: mssql, generated: 2009-03-24 12:54:58
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table postmaster_filter
-- ----------------------------------------------------------
ALTER TABLE postmaster_filter ADD f_stop SMALLINT NULL;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD a_in_reply_to VARCHAR (3800) NULL;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD a_references VARCHAR (3800) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD content_id VARCHAR (250) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD content_alternative VARCHAR (50) NULL;
-- ----------------------------------------------------------
--  create table service_preferences
-- ----------------------------------------------------------
CREATE TABLE service_preferences (
    service_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL
);
CREATE INDEX service_preferences_service_id ON service_preferences (service_id);
-- ----------------------------------------------------------
--  create table sla_preferences
-- ----------------------------------------------------------
CREATE TABLE sla_preferences (
    sla_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL
);
CREATE INDEX sla_preferences_sla_id ON sla_preferences (sla_id);
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD phone VARCHAR (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD fax VARCHAR (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD mobile VARCHAR (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD street VARCHAR (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD zip VARCHAR (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD city VARCHAR (150) NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD country VARCHAR (150) NULL;
-- ----------------------------------------------------------
--  alter table salutation
-- ----------------------------------------------------------
ALTER TABLE salutation ADD content_type VARCHAR (250) NULL;
-- ----------------------------------------------------------
--  alter table signature
-- ----------------------------------------------------------
ALTER TABLE signature ADD content_type VARCHAR (250) NULL;
-- ----------------------------------------------------------
--  alter table standard_response
-- ----------------------------------------------------------
ALTER TABLE standard_response ADD content_type VARCHAR (250) NULL;
-- ----------------------------------------------------------
--  alter table auto_response
-- ----------------------------------------------------------
ALTER TABLE auto_response ADD content_type VARCHAR (250) NULL;
-- ----------------------------------------------------------
--  alter table notifications
-- ----------------------------------------------------------
ALTER TABLE notifications ADD content_type VARCHAR (250) NULL;
ALTER TABLE service_preferences ADD CONSTRAINT FK_service_preferences_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE sla_preferences ADD CONSTRAINT FK_sla_preferences_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id);
