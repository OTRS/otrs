-- ----------------------------------------------------------
--  driver: oracle
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
DROP INDEX dynamic_field_value_field_va6e;
CREATE INDEX dynamic_field_value_field_va6e ON dynamic_field_value (object_id, field_id);
-- ----------------------------------------------------------
--  alter table web_upload_cache
-- ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD disposition VARCHAR2 (15) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD disposition VARCHAR2 (15) NULL;
SET DEFINE OFF;
SET SQLBLANKLINES ON;
