-- ----------------------------------------------------------
--  driver: db2, generated: 2011-12-12 10:02:46
-- ----------------------------------------------------------
ALTER TABLE dynamic_field_value ALTER COLUMN value_text DROP NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE dynamic_field_value');

ALTER TABLE dynamic_field_value ALTER COLUMN value_text SET DATA TYPE VARCHAR (3800);

CALL SYSPROC.ADMIN_CMD ('REORG TABLE dynamic_field_value');

ALTER TABLE dynamic_field_value ALTER COLUMN value_text SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE dynamic_field_value');

ALTER TABLE dynamic_field_value ALTER COLUMN value_text DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE dynamic_field_value');
