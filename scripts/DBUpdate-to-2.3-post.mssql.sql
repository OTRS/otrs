-- ----------------------------------------------------------
--  driver: mssql, generated: 2008-07-21 09:20:50
-- ----------------------------------------------------------
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'sla' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('sla') AND name = 'service_id'
                    )
                )
                SET @cmd = 'ALTER TABLE sla DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                     SET @sql = (SELECT TOP 1 'ALTER TABLE sla DROP CONSTRAINT [' + constraint_name + ']'
                      -- SELECT *
                      FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='sla' and column_name='service_id'
                     )
                     IF @sql IS NULL BREAK
                     EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla DROP COLUMN service_id;
DROP TABLE object_link;
