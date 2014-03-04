-- ----------------------------------------------------------
--  driver: postgresql
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
DROP INDEX dynamic_field_value_field_values;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id, field_id);
-- ----------------------------------------------------------
--  alter table web_upload_cache
-- ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD disposition VARCHAR (15) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD disposition VARCHAR (15) NULL;
SET standard_conforming_strings TO ON;
