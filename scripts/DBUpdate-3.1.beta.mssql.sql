-- ----------------------------------------------------------
--  driver: mssql, generated: 2011-12-12 09:14:09
-- ----------------------------------------------------------
GO
ALTER TABLE dynamic_field_value ALTER COLUMN value_text NVARCHAR (3800) NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_dynamic_field_value_value_text' )
ALTER TABLE dynamic_field_value DROP CONSTRAINT DF_dynamic_field_value_value_text;
