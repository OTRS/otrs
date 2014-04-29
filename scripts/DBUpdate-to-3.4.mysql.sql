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
