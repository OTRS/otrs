-- ----------------------------------------------------------
--  driver: db2, generated: 2011-12-08 11:52:20
-- ----------------------------------------------------------
ALTER TABLE dynamic_field_value ALTER COLUMN value_text SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE dynamic_field_value');

ALTER TABLE dynamic_field_value ALTER COLUMN value_text DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE dynamic_field_value');
