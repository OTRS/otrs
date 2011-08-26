-- ----------------------------------------------------------
--  driver: mssql, generated: 2011-08-26 10:51:44
-- ----------------------------------------------------------
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext1'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext1'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext1;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext2'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext2'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext2;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext3'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext3'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext3;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext4'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext4'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext4;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext5'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext5'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext5;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext6'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext6'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext6;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext7'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext7'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext7;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext8'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext8'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext8;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext9'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext9'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext9;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext10'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext10'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext10;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext11'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext11'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext11;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext12'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext12'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext12;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext13'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext13'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext13;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext14'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext14'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext14;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext15'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext15'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext15;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext16'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext16'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext16;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey1'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey1'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey1;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey2'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey2'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey2;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey3'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey3'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey3;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey4'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey4'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey4;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey5'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey5'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey5;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey6'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey6'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey6;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey7'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey7'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey7;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey8'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey8'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey8;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey9'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey9'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey9;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey10'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey10'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey10;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey11'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey11'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey11;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey12'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey12'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey12;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey13'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey13'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey13;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey14'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey14'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey14;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey15'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey15'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey15;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey16'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey16'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey16;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime1'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime1'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime1;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime2'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime2'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime2;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime3'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime3'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime3;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime4'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime4'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime4;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime5'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime5'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime5;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime6'
                    )
                )
                SET @cmd = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime6'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime6;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freetext1'
                    )
                )
                SET @cmd = 'ALTER TABLE article DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freetext1'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freetext1;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freetext2'
                    )
                )
                SET @cmd = 'ALTER TABLE article DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freetext2'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freetext2;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freetext3'
                    )
                )
                SET @cmd = 'ALTER TABLE article DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freetext3'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freetext3;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freekey1'
                    )
                )
                SET @cmd = 'ALTER TABLE article DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freekey1'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freekey1;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freekey2'
                    )
                )
                SET @cmd = 'ALTER TABLE article DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freekey2'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freekey2;
                DECLARE @defname VARCHAR(200), @cmd VARCHAR(2000)
                SET @defname = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freekey3'
                    )
                )
                SET @cmd = 'ALTER TABLE article DROP CONSTRAINT ' + @defname
                EXEC(@cmd)
;
                    DECLARE @sql NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sql = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freekey3'
                        )
                        IF @sql IS NULL BREAK
                        EXEC (@sql)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freekey3;
