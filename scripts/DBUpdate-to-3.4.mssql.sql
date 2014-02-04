-- ----------------------------------------------------------
--  driver: mssql
-- ----------------------------------------------------------
DROP INDEX dynamic_field_value.dynamic_field_value_field_values;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id, field_id);
