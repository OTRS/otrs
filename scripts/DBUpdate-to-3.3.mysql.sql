# ----------------------------------------------------------
#  driver: mysql, generated: 2013-08-20 12:30:12
# ----------------------------------------------------------
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('TitleUpdate', 1, 1, current_timestamp, 1, current_timestamp);
DROP INDEX index_search_date ON dynamic_field_value;
CREATE INDEX dynamic_field_value_search_date ON dynamic_field_value (field_id, value_date);
DROP INDEX index_search_int ON dynamic_field_value;
CREATE INDEX dynamic_field_value_search_int ON dynamic_field_value (field_id, value_int);
DROP INDEX index_field_values ON dynamic_field_value;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id);
DROP INDEX article_message_id ON article;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article ADD a_message_id_md5 VARCHAR (32) NULL;
CREATE INDEX article_message_id_md5 ON article (a_message_id_md5);
DROP INDEX article_search_message_id ON article_search;
# ----------------------------------------------------------
#  alter table article_search
# ----------------------------------------------------------
ALTER TABLE article_search DROP a_message_id;
# ----------------------------------------------------------
#  create table system_data
# ----------------------------------------------------------
CREATE TABLE system_data (
    data_key VARCHAR (160) NOT NULL,
    data_value LONGBLOB NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(data_key)
);
# ----------------------------------------------------------
#  alter table user_preferences
# ----------------------------------------------------------
ALTER TABLE user_preferences CHANGE preferences_value preferences_value LONGBLOB NULL;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'standard_response' AND constraint_name = 'FK_standard_response_valid_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE standard_response DROP FOREIGN KEY FK_standard_response_valid_id_id', 'SELECT ''INFO: Foreign key constraint FK_standard_response_valid_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'standard_response' AND constraint_name = 'FK_standard_response_create_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE standard_response DROP FOREIGN KEY FK_standard_response_create_by_id', 'SELECT ''INFO: Foreign key constraint FK_standard_response_create_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'standard_response' AND constraint_name = 'FK_standard_response_change_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE standard_response DROP FOREIGN KEY FK_standard_response_change_by_id', 'SELECT ''INFO: Foreign key constraint FK_standard_response_change_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'queue_standard_response' AND constraint_name = 'FK_queue_standard_response_standard_response_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE queue_standard_response DROP FOREIGN KEY FK_queue_standard_response_standard_response_id_id', 'SELECT ''INFO: Foreign key constraint FK_queue_standard_response_standard_response_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'queue_standard_response' AND constraint_name = 'FK_queue_standard_response_queue_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE queue_standard_response DROP FOREIGN KEY FK_queue_standard_response_queue_id_id', 'SELECT ''INFO: Foreign key constraint FK_queue_standard_response_queue_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'queue_standard_response' AND constraint_name = 'FK_queue_standard_response_create_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE queue_standard_response DROP FOREIGN KEY FK_queue_standard_response_create_by_id', 'SELECT ''INFO: Foreign key constraint FK_queue_standard_response_create_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'queue_standard_response' AND constraint_name = 'FK_queue_standard_response_change_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE queue_standard_response DROP FOREIGN KEY FK_queue_standard_response_change_by_id', 'SELECT ''INFO: Foreign key constraint FK_queue_standard_response_change_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'standard_response_attachment' AND constraint_name = 'FK_standard_response_attachment_standard_response_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE standard_response_attachment DROP FOREIGN KEY FK_standard_response_attachment_standard_response_id_id', 'SELECT ''INFO: Foreign key constraint FK_standard_response_attachment_standard_response_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'standard_response_attachment' AND constraint_name = 'FK_standard_response_attachment_standard_attachment_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE standard_response_attachment DROP FOREIGN KEY FK_standard_response_attachment_standard_attachment_id_id', 'SELECT ''INFO: Foreign key constraint FK_standard_response_attachment_standard_attachment_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'standard_response_attachment' AND constraint_name = 'FK_standard_response_attachment_create_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE standard_response_attachment DROP FOREIGN KEY FK_standard_response_attachment_create_by_id', 'SELECT ''INFO: Foreign key constraint FK_standard_response_attachment_create_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'standard_response_attachment' AND constraint_name = 'FK_standard_response_attachment_change_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE standard_response_attachment DROP FOREIGN KEY FK_standard_response_attachment_change_by_id', 'SELECT ''INFO: Foreign key constraint FK_standard_response_attachment_change_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
ALTER TABLE standard_response DROP INDEX standard_response_name;
# ----------------------------------------------------------
#  alter table standard_template
# ----------------------------------------------------------
ALTER TABLE standard_response RENAME standard_template;
# ----------------------------------------------------------
#  alter table queue_standard_template
# ----------------------------------------------------------
ALTER TABLE queue_standard_response RENAME queue_standard_template;
# ----------------------------------------------------------
#  alter table standard_template_attachment
# ----------------------------------------------------------
ALTER TABLE standard_response_attachment RENAME standard_template_attachment;
# ----------------------------------------------------------
#  alter table standard_template
# ----------------------------------------------------------
ALTER TABLE standard_template ADD template_type VARCHAR (100) NULL;
UPDATE standard_template SET template_type = 'Answer' WHERE template_type IS NULL;
ALTER TABLE standard_template CHANGE template_type template_type VARCHAR (100) DEFAULT 'Answer' NOT NULL;
ALTER TABLE standard_template ADD CONSTRAINT standard_template_name UNIQUE INDEX (name);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
# ----------------------------------------------------------
#  alter table queue_standard_template
# ----------------------------------------------------------
ALTER TABLE queue_standard_template CHANGE standard_response_id standard_template_id INTEGER NULL;
ALTER TABLE queue_standard_template ALTER standard_template_id DROP DEFAULT;
UPDATE queue_standard_template SET standard_template_id = 0 WHERE standard_template_id IS NULL;
ALTER TABLE queue_standard_template CHANGE standard_template_id standard_template_id INTEGER NOT NULL;
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_standard_template_id_id FOREIGN KEY (standard_template_id) REFERENCES standard_template (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
# ----------------------------------------------------------
#  alter table standard_template_attachment
# ----------------------------------------------------------
ALTER TABLE standard_template_attachment CHANGE standard_response_id standard_template_id INTEGER NULL;
ALTER TABLE standard_template_attachment ALTER standard_template_id DROP DEFAULT;
UPDATE standard_template_attachment SET standard_template_id = 0 WHERE standard_template_id IS NULL;
ALTER TABLE standard_template_attachment CHANGE standard_template_id standard_template_id INTEGER NOT NULL;
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_standard_template_id_id FOREIGN KEY (standard_template_id) REFERENCES standard_template (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_standard_attachment_id_id FOREIGN KEY (standard_attachment_id) REFERENCES standard_attachment (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
# ----------------------------------------------------------
#  alter table postmaster_filter
# ----------------------------------------------------------
ALTER TABLE postmaster_filter ADD f_not SMALLINT NULL;
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
