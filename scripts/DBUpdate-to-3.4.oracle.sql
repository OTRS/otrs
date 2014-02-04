-- ----------------------------------------------------------
--  driver: oracle
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
DROP INDEX dynamic_field_value_field_va6e;
CREATE INDEX dynamic_field_value_field_va6e ON dynamic_field_value (object_id, field_id);
SET DEFINE OFF;
SET SQLBLANKLINES ON;
