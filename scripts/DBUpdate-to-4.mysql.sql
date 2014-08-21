# ----------------------------------------------------------
#  driver: mysql
# ----------------------------------------------------------
DROP INDEX dynamic_field_value_field_values ON dynamic_field_value;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id, field_id);
# ----------------------------------------------------------
#  alter table web_upload_cache
# ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD disposition VARCHAR (15) NULL;
# ----------------------------------------------------------
#  alter table article_attachment
# ----------------------------------------------------------
ALTER TABLE article_attachment ADD disposition VARCHAR (15) NULL;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'ticket' AND constraint_name = 'FK_ticket_valid_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE ticket DROP FOREIGN KEY FK_ticket_valid_id_id', 'SELECT ''INFO: Foreign key constraint FK_ticket_valid_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP valid_id;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'ticket_history' AND constraint_name = 'FK_ticket_history_valid_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE ticket_history DROP FOREIGN KEY FK_ticket_history_valid_id_id', 'SELECT ''INFO: Foreign key constraint FK_ticket_history_valid_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
# ----------------------------------------------------------
#  alter table ticket_history
# ----------------------------------------------------------
ALTER TABLE ticket_history DROP valid_id;
DROP TABLE IF EXISTS pm_entity;
# ----------------------------------------------------------
#  create table personal_services
# ----------------------------------------------------------
CREATE TABLE personal_services (
    user_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    INDEX personal_services_queue_id (service_id),
    INDEX personal_services_user_id (user_id)
);
# ----------------------------------------------------------
#  alter table package_repository
# ----------------------------------------------------------
ALTER TABLE package_repository DROP content_size;
# ----------------------------------------------------------
#  create table system_maintenance
# ----------------------------------------------------------
CREATE TABLE system_maintenance (
    id INTEGER NOT NULL AUTO_INCREMENT,
    start_date INTEGER NOT NULL,
    stop_date INTEGER NOT NULL,
    comments VARCHAR (250) NULL,
    login_message VARCHAR (250) NULL,
    show_login_message SMALLINT NULL,
    notify_message VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
