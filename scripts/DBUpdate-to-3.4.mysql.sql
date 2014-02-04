# ----------------------------------------------------------
#  driver: mysql
# ----------------------------------------------------------
DROP INDEX dynamic_field_value_field_values ON dynamic_field_value;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id, field_id);
