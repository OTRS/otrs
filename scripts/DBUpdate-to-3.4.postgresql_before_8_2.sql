-- ----------------------------------------------------------
--  driver: postgresql_before_8_2
-- ----------------------------------------------------------
DROP INDEX dynamic_field_value_field_values;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id, field_id);
