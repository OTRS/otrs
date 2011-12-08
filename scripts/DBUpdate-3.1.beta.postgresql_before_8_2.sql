-- ----------------------------------------------------------
--  driver: postgresql_before_8_2, generated: 2011-12-08 11:52:21
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table dynamic_field_value
-- ----------------------------------------------------------
ALTER TABLE dynamic_field_value ALTER value_text TYPE VARCHAR (3800);
ALTER TABLE dynamic_field_value ALTER value_text DROP DEFAULT;
