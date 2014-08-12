-- ----------------------------------------------------------
--  driver: oracle
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
DROP INDEX dynamic_field_value_field_va6e;
CREATE INDEX dynamic_field_value_field_va6e ON dynamic_field_value (object_id, field_id);
-- ----------------------------------------------------------
--  alter table web_upload_cache
-- ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD disposition VARCHAR2 (15) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD disposition VARCHAR2 (15) NULL;
ALTER TABLE ticket DROP CONSTRAINT FK_ticket_valid_id_id;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN valid_id;
ALTER TABLE ticket_history DROP CONSTRAINT FK_ticket_history_valid_id_id;
-- ----------------------------------------------------------
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history DROP COLUMN valid_id;
DROP TABLE pm_entity CASCADE CONSTRAINTS;
-- ----------------------------------------------------------
--  create table personal_services
-- ----------------------------------------------------------
CREATE TABLE personal_services (
    user_id NUMBER (12, 0) NOT NULL,
    service_id NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_personal_services_service14 ON personal_services (service_id);
CREATE INDEX personal_services_queue_id ON personal_services (service_id);
CREATE INDEX personal_services_user_id ON personal_services (user_id);
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD from_cloud NUMBER (5, 0) NULL;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD visible NUMBER (5, 0) NULL;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD downloadable NUMBER (5, 0) NULL;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD removable NUMBER (5, 0) NULL;
SET DEFINE OFF;
SET SQLBLANKLINES ON;
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_service42 FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_user_id23 FOREIGN KEY (user_id) REFERENCES users (id);
