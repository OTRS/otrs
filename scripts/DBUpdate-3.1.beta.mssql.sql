-- ----------------------------------------------------------
--  driver: mssql, generated: 2011-12-08 11:52:21
-- ----------------------------------------------------------
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_dynamic_field_value_value_text' )
ALTER TABLE dynamic_field_value DROP CONSTRAINT DF_dynamic_field_value_value_text;
