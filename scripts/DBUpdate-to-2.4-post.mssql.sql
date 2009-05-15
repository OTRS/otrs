-- ----------------------------------------------------------
--  driver: mssql, generated: 2009-05-15 11:45:50
-- ----------------------------------------------------------
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'queue' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('queue') AND name = 'move_notify'
                    )
                )
                SET @cmd = 'ALTER TABLE queue DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE queue DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='queue' and column_name='move_notify'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue DROP COLUMN move_notify;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'queue' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('queue') AND name = 'state_notify'
                    )
                )
                SET @cmd = 'ALTER TABLE queue DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE queue DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='queue' and column_name='state_notify'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue DROP COLUMN state_notify;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'queue' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('queue') AND name = 'lock_notify'
                    )
                )
                SET @cmd = 'ALTER TABLE queue DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE queue DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='queue' and column_name='lock_notify'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue DROP COLUMN lock_notify;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'queue' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('queue') AND name = 'owner_notify'
                    )
                )
                SET @cmd = 'ALTER TABLE queue DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE queue DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='queue' and column_name='owner_notify'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue DROP COLUMN owner_notify;
