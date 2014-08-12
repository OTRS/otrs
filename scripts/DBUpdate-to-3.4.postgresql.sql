-- ----------------------------------------------------------
--  driver: postgresql
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
DROP INDEX dynamic_field_value_field_values;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id, field_id);
-- ----------------------------------------------------------
--  alter table web_upload_cache
-- ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD disposition VARCHAR (15) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD disposition VARCHAR (15) NULL;
ALTER TABLE ticket DROP CONSTRAINT FK_ticket_valid_id_id;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP valid_id;
ALTER TABLE ticket_history DROP CONSTRAINT FK_ticket_history_valid_id_id;
-- ----------------------------------------------------------
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history DROP valid_id;
DROP TABLE pm_entity;
-- ----------------------------------------------------------
--  create table personal_services
-- ----------------------------------------------------------
CREATE TABLE personal_services (
    user_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL
);
CREATE INDEX personal_services_queue_id ON personal_services (service_id);
CREATE INDEX personal_services_user_id ON personal_services (user_id);
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD from_cloud INTEGER NULL;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD visible INTEGER NULL;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD downloadable INTEGER NULL;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD removable INTEGER NULL;
SET standard_conforming_strings TO ON;
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
