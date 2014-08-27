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
CREATE INDEX personal_services_service_id ON personal_services (service_id);
CREATE INDEX personal_services_user_id ON personal_services (user_id);
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository DROP COLUMN content_size;
-- ----------------------------------------------------------
--  create table system_maintenance
-- ----------------------------------------------------------
CREATE TABLE system_maintenance (
    id NUMBER (12, 0) NOT NULL,
    start_date NUMBER (12, 0) NOT NULL,
    stop_date NUMBER (12, 0) NOT NULL,
    comments VARCHAR2 (250) NOT NULL,
    login_message VARCHAR2 (250) NULL,
    show_login_message NUMBER (5, 0) NULL,
    notify_message VARCHAR2 (250) NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE system_maintenance ADD CONSTRAINT PK_system_maintenance PRIMARY KEY (id);
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE SE_system_maintenance';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--;
CREATE SEQUENCE SE_system_maintenance
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_system_maintenance_t
BEFORE INSERT ON system_maintenance
FOR EACH ROW
BEGIN
  IF :new.id IS NULL THEN
    SELECT SE_system_maintenance.nextval
    INTO :new.id
    FROM DUAL;
  END IF;
END;
/
--;
CREATE INDEX FK_system_maintenance_changefb ON system_maintenance (change_by);
CREATE INDEX FK_system_maintenance_createf5 ON system_maintenance (create_by);
CREATE INDEX FK_system_maintenance_valid_id ON system_maintenance (valid_id);
SET DEFINE OFF;
SET SQLBLANKLINES ON;
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_service42 FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_user_id23 FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_created6 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_change48 FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_valid_49 FOREIGN KEY (valid_id) REFERENCES valid (id);
