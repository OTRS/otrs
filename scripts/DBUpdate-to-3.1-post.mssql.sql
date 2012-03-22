-- ----------------------------------------------------------
--  driver: mssql, generated: 2012-03-22 12:01:09
-- ----------------------------------------------------------
                DECLARE @defnameticketfreetext1 VARCHAR(200), @cmdticketfreetext1 VARCHAR(2000)
                SET @defnameticketfreetext1 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext1'
                    )
                )
                SET @cmdticketfreetext1 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext1
                EXEC(@cmdticketfreetext1)
;
                    DECLARE @sqlticketfreetext1 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext1 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext1'
                        )
                        IF @sqlticketfreetext1 IS NULL BREAK
                        EXEC (@sqlticketfreetext1)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext1;
                DECLARE @defnameticketfreetext2 VARCHAR(200), @cmdticketfreetext2 VARCHAR(2000)
                SET @defnameticketfreetext2 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext2'
                    )
                )
                SET @cmdticketfreetext2 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext2
                EXEC(@cmdticketfreetext2)
;
                    DECLARE @sqlticketfreetext2 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext2 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext2'
                        )
                        IF @sqlticketfreetext2 IS NULL BREAK
                        EXEC (@sqlticketfreetext2)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext2;
                DECLARE @defnameticketfreetext3 VARCHAR(200), @cmdticketfreetext3 VARCHAR(2000)
                SET @defnameticketfreetext3 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext3'
                    )
                )
                SET @cmdticketfreetext3 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext3
                EXEC(@cmdticketfreetext3)
;
                    DECLARE @sqlticketfreetext3 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext3 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext3'
                        )
                        IF @sqlticketfreetext3 IS NULL BREAK
                        EXEC (@sqlticketfreetext3)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext3;
                DECLARE @defnameticketfreetext4 VARCHAR(200), @cmdticketfreetext4 VARCHAR(2000)
                SET @defnameticketfreetext4 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext4'
                    )
                )
                SET @cmdticketfreetext4 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext4
                EXEC(@cmdticketfreetext4)
;
                    DECLARE @sqlticketfreetext4 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext4 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext4'
                        )
                        IF @sqlticketfreetext4 IS NULL BREAK
                        EXEC (@sqlticketfreetext4)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext4;
                DECLARE @defnameticketfreetext5 VARCHAR(200), @cmdticketfreetext5 VARCHAR(2000)
                SET @defnameticketfreetext5 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext5'
                    )
                )
                SET @cmdticketfreetext5 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext5
                EXEC(@cmdticketfreetext5)
;
                    DECLARE @sqlticketfreetext5 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext5 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext5'
                        )
                        IF @sqlticketfreetext5 IS NULL BREAK
                        EXEC (@sqlticketfreetext5)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext5;
                DECLARE @defnameticketfreetext6 VARCHAR(200), @cmdticketfreetext6 VARCHAR(2000)
                SET @defnameticketfreetext6 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext6'
                    )
                )
                SET @cmdticketfreetext6 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext6
                EXEC(@cmdticketfreetext6)
;
                    DECLARE @sqlticketfreetext6 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext6 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext6'
                        )
                        IF @sqlticketfreetext6 IS NULL BREAK
                        EXEC (@sqlticketfreetext6)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext6;
                DECLARE @defnameticketfreetext7 VARCHAR(200), @cmdticketfreetext7 VARCHAR(2000)
                SET @defnameticketfreetext7 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext7'
                    )
                )
                SET @cmdticketfreetext7 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext7
                EXEC(@cmdticketfreetext7)
;
                    DECLARE @sqlticketfreetext7 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext7 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext7'
                        )
                        IF @sqlticketfreetext7 IS NULL BREAK
                        EXEC (@sqlticketfreetext7)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext7;
                DECLARE @defnameticketfreetext8 VARCHAR(200), @cmdticketfreetext8 VARCHAR(2000)
                SET @defnameticketfreetext8 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext8'
                    )
                )
                SET @cmdticketfreetext8 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext8
                EXEC(@cmdticketfreetext8)
;
                    DECLARE @sqlticketfreetext8 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext8 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext8'
                        )
                        IF @sqlticketfreetext8 IS NULL BREAK
                        EXEC (@sqlticketfreetext8)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext8;
                DECLARE @defnameticketfreetext9 VARCHAR(200), @cmdticketfreetext9 VARCHAR(2000)
                SET @defnameticketfreetext9 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext9'
                    )
                )
                SET @cmdticketfreetext9 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext9
                EXEC(@cmdticketfreetext9)
;
                    DECLARE @sqlticketfreetext9 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext9 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext9'
                        )
                        IF @sqlticketfreetext9 IS NULL BREAK
                        EXEC (@sqlticketfreetext9)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext9;
                DECLARE @defnameticketfreetext10 VARCHAR(200), @cmdticketfreetext10 VARCHAR(2000)
                SET @defnameticketfreetext10 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext10'
                    )
                )
                SET @cmdticketfreetext10 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext10
                EXEC(@cmdticketfreetext10)
;
                    DECLARE @sqlticketfreetext10 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext10 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext10'
                        )
                        IF @sqlticketfreetext10 IS NULL BREAK
                        EXEC (@sqlticketfreetext10)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext10;
                DECLARE @defnameticketfreetext11 VARCHAR(200), @cmdticketfreetext11 VARCHAR(2000)
                SET @defnameticketfreetext11 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext11'
                    )
                )
                SET @cmdticketfreetext11 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext11
                EXEC(@cmdticketfreetext11)
;
                    DECLARE @sqlticketfreetext11 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext11 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext11'
                        )
                        IF @sqlticketfreetext11 IS NULL BREAK
                        EXEC (@sqlticketfreetext11)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext11;
                DECLARE @defnameticketfreetext12 VARCHAR(200), @cmdticketfreetext12 VARCHAR(2000)
                SET @defnameticketfreetext12 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext12'
                    )
                )
                SET @cmdticketfreetext12 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext12
                EXEC(@cmdticketfreetext12)
;
                    DECLARE @sqlticketfreetext12 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext12 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext12'
                        )
                        IF @sqlticketfreetext12 IS NULL BREAK
                        EXEC (@sqlticketfreetext12)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext12;
                DECLARE @defnameticketfreetext13 VARCHAR(200), @cmdticketfreetext13 VARCHAR(2000)
                SET @defnameticketfreetext13 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext13'
                    )
                )
                SET @cmdticketfreetext13 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext13
                EXEC(@cmdticketfreetext13)
;
                    DECLARE @sqlticketfreetext13 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext13 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext13'
                        )
                        IF @sqlticketfreetext13 IS NULL BREAK
                        EXEC (@sqlticketfreetext13)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext13;
                DECLARE @defnameticketfreetext14 VARCHAR(200), @cmdticketfreetext14 VARCHAR(2000)
                SET @defnameticketfreetext14 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext14'
                    )
                )
                SET @cmdticketfreetext14 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext14
                EXEC(@cmdticketfreetext14)
;
                    DECLARE @sqlticketfreetext14 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext14 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext14'
                        )
                        IF @sqlticketfreetext14 IS NULL BREAK
                        EXEC (@sqlticketfreetext14)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext14;
                DECLARE @defnameticketfreetext15 VARCHAR(200), @cmdticketfreetext15 VARCHAR(2000)
                SET @defnameticketfreetext15 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext15'
                    )
                )
                SET @cmdticketfreetext15 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext15
                EXEC(@cmdticketfreetext15)
;
                    DECLARE @sqlticketfreetext15 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext15 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext15'
                        )
                        IF @sqlticketfreetext15 IS NULL BREAK
                        EXEC (@sqlticketfreetext15)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext15;
                DECLARE @defnameticketfreetext16 VARCHAR(200), @cmdticketfreetext16 VARCHAR(2000)
                SET @defnameticketfreetext16 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetext16'
                    )
                )
                SET @cmdticketfreetext16 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetext16
                EXEC(@cmdticketfreetext16)
;
                    DECLARE @sqlticketfreetext16 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetext16 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetext16'
                        )
                        IF @sqlticketfreetext16 IS NULL BREAK
                        EXEC (@sqlticketfreetext16)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetext16;
                DECLARE @defnameticketfreekey1 VARCHAR(200), @cmdticketfreekey1 VARCHAR(2000)
                SET @defnameticketfreekey1 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey1'
                    )
                )
                SET @cmdticketfreekey1 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey1
                EXEC(@cmdticketfreekey1)
;
                    DECLARE @sqlticketfreekey1 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey1 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey1'
                        )
                        IF @sqlticketfreekey1 IS NULL BREAK
                        EXEC (@sqlticketfreekey1)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey1;
                DECLARE @defnameticketfreekey2 VARCHAR(200), @cmdticketfreekey2 VARCHAR(2000)
                SET @defnameticketfreekey2 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey2'
                    )
                )
                SET @cmdticketfreekey2 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey2
                EXEC(@cmdticketfreekey2)
;
                    DECLARE @sqlticketfreekey2 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey2 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey2'
                        )
                        IF @sqlticketfreekey2 IS NULL BREAK
                        EXEC (@sqlticketfreekey2)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey2;
                DECLARE @defnameticketfreekey3 VARCHAR(200), @cmdticketfreekey3 VARCHAR(2000)
                SET @defnameticketfreekey3 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey3'
                    )
                )
                SET @cmdticketfreekey3 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey3
                EXEC(@cmdticketfreekey3)
;
                    DECLARE @sqlticketfreekey3 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey3 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey3'
                        )
                        IF @sqlticketfreekey3 IS NULL BREAK
                        EXEC (@sqlticketfreekey3)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey3;
                DECLARE @defnameticketfreekey4 VARCHAR(200), @cmdticketfreekey4 VARCHAR(2000)
                SET @defnameticketfreekey4 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey4'
                    )
                )
                SET @cmdticketfreekey4 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey4
                EXEC(@cmdticketfreekey4)
;
                    DECLARE @sqlticketfreekey4 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey4 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey4'
                        )
                        IF @sqlticketfreekey4 IS NULL BREAK
                        EXEC (@sqlticketfreekey4)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey4;
                DECLARE @defnameticketfreekey5 VARCHAR(200), @cmdticketfreekey5 VARCHAR(2000)
                SET @defnameticketfreekey5 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey5'
                    )
                )
                SET @cmdticketfreekey5 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey5
                EXEC(@cmdticketfreekey5)
;
                    DECLARE @sqlticketfreekey5 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey5 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey5'
                        )
                        IF @sqlticketfreekey5 IS NULL BREAK
                        EXEC (@sqlticketfreekey5)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey5;
                DECLARE @defnameticketfreekey6 VARCHAR(200), @cmdticketfreekey6 VARCHAR(2000)
                SET @defnameticketfreekey6 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey6'
                    )
                )
                SET @cmdticketfreekey6 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey6
                EXEC(@cmdticketfreekey6)
;
                    DECLARE @sqlticketfreekey6 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey6 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey6'
                        )
                        IF @sqlticketfreekey6 IS NULL BREAK
                        EXEC (@sqlticketfreekey6)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey6;
                DECLARE @defnameticketfreekey7 VARCHAR(200), @cmdticketfreekey7 VARCHAR(2000)
                SET @defnameticketfreekey7 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey7'
                    )
                )
                SET @cmdticketfreekey7 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey7
                EXEC(@cmdticketfreekey7)
;
                    DECLARE @sqlticketfreekey7 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey7 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey7'
                        )
                        IF @sqlticketfreekey7 IS NULL BREAK
                        EXEC (@sqlticketfreekey7)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey7;
                DECLARE @defnameticketfreekey8 VARCHAR(200), @cmdticketfreekey8 VARCHAR(2000)
                SET @defnameticketfreekey8 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey8'
                    )
                )
                SET @cmdticketfreekey8 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey8
                EXEC(@cmdticketfreekey8)
;
                    DECLARE @sqlticketfreekey8 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey8 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey8'
                        )
                        IF @sqlticketfreekey8 IS NULL BREAK
                        EXEC (@sqlticketfreekey8)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey8;
                DECLARE @defnameticketfreekey9 VARCHAR(200), @cmdticketfreekey9 VARCHAR(2000)
                SET @defnameticketfreekey9 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey9'
                    )
                )
                SET @cmdticketfreekey9 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey9
                EXEC(@cmdticketfreekey9)
;
                    DECLARE @sqlticketfreekey9 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey9 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey9'
                        )
                        IF @sqlticketfreekey9 IS NULL BREAK
                        EXEC (@sqlticketfreekey9)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey9;
                DECLARE @defnameticketfreekey10 VARCHAR(200), @cmdticketfreekey10 VARCHAR(2000)
                SET @defnameticketfreekey10 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey10'
                    )
                )
                SET @cmdticketfreekey10 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey10
                EXEC(@cmdticketfreekey10)
;
                    DECLARE @sqlticketfreekey10 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey10 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey10'
                        )
                        IF @sqlticketfreekey10 IS NULL BREAK
                        EXEC (@sqlticketfreekey10)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey10;
                DECLARE @defnameticketfreekey11 VARCHAR(200), @cmdticketfreekey11 VARCHAR(2000)
                SET @defnameticketfreekey11 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey11'
                    )
                )
                SET @cmdticketfreekey11 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey11
                EXEC(@cmdticketfreekey11)
;
                    DECLARE @sqlticketfreekey11 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey11 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey11'
                        )
                        IF @sqlticketfreekey11 IS NULL BREAK
                        EXEC (@sqlticketfreekey11)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey11;
                DECLARE @defnameticketfreekey12 VARCHAR(200), @cmdticketfreekey12 VARCHAR(2000)
                SET @defnameticketfreekey12 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey12'
                    )
                )
                SET @cmdticketfreekey12 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey12
                EXEC(@cmdticketfreekey12)
;
                    DECLARE @sqlticketfreekey12 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey12 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey12'
                        )
                        IF @sqlticketfreekey12 IS NULL BREAK
                        EXEC (@sqlticketfreekey12)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey12;
                DECLARE @defnameticketfreekey13 VARCHAR(200), @cmdticketfreekey13 VARCHAR(2000)
                SET @defnameticketfreekey13 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey13'
                    )
                )
                SET @cmdticketfreekey13 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey13
                EXEC(@cmdticketfreekey13)
;
                    DECLARE @sqlticketfreekey13 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey13 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey13'
                        )
                        IF @sqlticketfreekey13 IS NULL BREAK
                        EXEC (@sqlticketfreekey13)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey13;
                DECLARE @defnameticketfreekey14 VARCHAR(200), @cmdticketfreekey14 VARCHAR(2000)
                SET @defnameticketfreekey14 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey14'
                    )
                )
                SET @cmdticketfreekey14 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey14
                EXEC(@cmdticketfreekey14)
;
                    DECLARE @sqlticketfreekey14 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey14 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey14'
                        )
                        IF @sqlticketfreekey14 IS NULL BREAK
                        EXEC (@sqlticketfreekey14)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey14;
                DECLARE @defnameticketfreekey15 VARCHAR(200), @cmdticketfreekey15 VARCHAR(2000)
                SET @defnameticketfreekey15 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey15'
                    )
                )
                SET @cmdticketfreekey15 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey15
                EXEC(@cmdticketfreekey15)
;
                    DECLARE @sqlticketfreekey15 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey15 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey15'
                        )
                        IF @sqlticketfreekey15 IS NULL BREAK
                        EXEC (@sqlticketfreekey15)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey15;
                DECLARE @defnameticketfreekey16 VARCHAR(200), @cmdticketfreekey16 VARCHAR(2000)
                SET @defnameticketfreekey16 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freekey16'
                    )
                )
                SET @cmdticketfreekey16 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreekey16
                EXEC(@cmdticketfreekey16)
;
                    DECLARE @sqlticketfreekey16 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreekey16 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freekey16'
                        )
                        IF @sqlticketfreekey16 IS NULL BREAK
                        EXEC (@sqlticketfreekey16)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freekey16;
                DECLARE @defnameticketfreetime1 VARCHAR(200), @cmdticketfreetime1 VARCHAR(2000)
                SET @defnameticketfreetime1 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime1'
                    )
                )
                SET @cmdticketfreetime1 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetime1
                EXEC(@cmdticketfreetime1)
;
                    DECLARE @sqlticketfreetime1 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetime1 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime1'
                        )
                        IF @sqlticketfreetime1 IS NULL BREAK
                        EXEC (@sqlticketfreetime1)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime1;
                DECLARE @defnameticketfreetime2 VARCHAR(200), @cmdticketfreetime2 VARCHAR(2000)
                SET @defnameticketfreetime2 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime2'
                    )
                )
                SET @cmdticketfreetime2 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetime2
                EXEC(@cmdticketfreetime2)
;
                    DECLARE @sqlticketfreetime2 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetime2 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime2'
                        )
                        IF @sqlticketfreetime2 IS NULL BREAK
                        EXEC (@sqlticketfreetime2)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime2;
                DECLARE @defnameticketfreetime3 VARCHAR(200), @cmdticketfreetime3 VARCHAR(2000)
                SET @defnameticketfreetime3 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime3'
                    )
                )
                SET @cmdticketfreetime3 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetime3
                EXEC(@cmdticketfreetime3)
;
                    DECLARE @sqlticketfreetime3 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetime3 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime3'
                        )
                        IF @sqlticketfreetime3 IS NULL BREAK
                        EXEC (@sqlticketfreetime3)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime3;
                DECLARE @defnameticketfreetime4 VARCHAR(200), @cmdticketfreetime4 VARCHAR(2000)
                SET @defnameticketfreetime4 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime4'
                    )
                )
                SET @cmdticketfreetime4 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetime4
                EXEC(@cmdticketfreetime4)
;
                    DECLARE @sqlticketfreetime4 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetime4 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime4'
                        )
                        IF @sqlticketfreetime4 IS NULL BREAK
                        EXEC (@sqlticketfreetime4)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime4;
                DECLARE @defnameticketfreetime5 VARCHAR(200), @cmdticketfreetime5 VARCHAR(2000)
                SET @defnameticketfreetime5 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime5'
                    )
                )
                SET @cmdticketfreetime5 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetime5
                EXEC(@cmdticketfreetime5)
;
                    DECLARE @sqlticketfreetime5 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetime5 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime5'
                        )
                        IF @sqlticketfreetime5 IS NULL BREAK
                        EXEC (@sqlticketfreetime5)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime5;
                DECLARE @defnameticketfreetime6 VARCHAR(200), @cmdticketfreetime6 VARCHAR(2000)
                SET @defnameticketfreetime6 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'freetime6'
                    )
                )
                SET @cmdticketfreetime6 = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketfreetime6
                EXEC(@cmdticketfreetime6)
;
                    DECLARE @sqlticketfreetime6 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketfreetime6 = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='freetime6'
                        )
                        IF @sqlticketfreetime6 IS NULL BREAK
                        EXEC (@sqlticketfreetime6)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN freetime6;
                DECLARE @defnamearticlea_freetext1 VARCHAR(200), @cmdarticlea_freetext1 VARCHAR(2000)
                SET @defnamearticlea_freetext1 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freetext1'
                    )
                )
                SET @cmdarticlea_freetext1 = 'ALTER TABLE article DROP CONSTRAINT ' + @defnamearticlea_freetext1
                EXEC(@cmdarticlea_freetext1)
;
                    DECLARE @sqlarticlea_freetext1 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlarticlea_freetext1 = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freetext1'
                        )
                        IF @sqlarticlea_freetext1 IS NULL BREAK
                        EXEC (@sqlarticlea_freetext1)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freetext1;
                DECLARE @defnamearticlea_freetext2 VARCHAR(200), @cmdarticlea_freetext2 VARCHAR(2000)
                SET @defnamearticlea_freetext2 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freetext2'
                    )
                )
                SET @cmdarticlea_freetext2 = 'ALTER TABLE article DROP CONSTRAINT ' + @defnamearticlea_freetext2
                EXEC(@cmdarticlea_freetext2)
;
                    DECLARE @sqlarticlea_freetext2 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlarticlea_freetext2 = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freetext2'
                        )
                        IF @sqlarticlea_freetext2 IS NULL BREAK
                        EXEC (@sqlarticlea_freetext2)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freetext2;
                DECLARE @defnamearticlea_freetext3 VARCHAR(200), @cmdarticlea_freetext3 VARCHAR(2000)
                SET @defnamearticlea_freetext3 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freetext3'
                    )
                )
                SET @cmdarticlea_freetext3 = 'ALTER TABLE article DROP CONSTRAINT ' + @defnamearticlea_freetext3
                EXEC(@cmdarticlea_freetext3)
;
                    DECLARE @sqlarticlea_freetext3 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlarticlea_freetext3 = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freetext3'
                        )
                        IF @sqlarticlea_freetext3 IS NULL BREAK
                        EXEC (@sqlarticlea_freetext3)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freetext3;
                DECLARE @defnamearticlea_freekey1 VARCHAR(200), @cmdarticlea_freekey1 VARCHAR(2000)
                SET @defnamearticlea_freekey1 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freekey1'
                    )
                )
                SET @cmdarticlea_freekey1 = 'ALTER TABLE article DROP CONSTRAINT ' + @defnamearticlea_freekey1
                EXEC(@cmdarticlea_freekey1)
;
                    DECLARE @sqlarticlea_freekey1 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlarticlea_freekey1 = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freekey1'
                        )
                        IF @sqlarticlea_freekey1 IS NULL BREAK
                        EXEC (@sqlarticlea_freekey1)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freekey1;
                DECLARE @defnamearticlea_freekey2 VARCHAR(200), @cmdarticlea_freekey2 VARCHAR(2000)
                SET @defnamearticlea_freekey2 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freekey2'
                    )
                )
                SET @cmdarticlea_freekey2 = 'ALTER TABLE article DROP CONSTRAINT ' + @defnamearticlea_freekey2
                EXEC(@cmdarticlea_freekey2)
;
                    DECLARE @sqlarticlea_freekey2 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlarticlea_freekey2 = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freekey2'
                        )
                        IF @sqlarticlea_freekey2 IS NULL BREAK
                        EXEC (@sqlarticlea_freekey2)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freekey2;
                DECLARE @defnamearticlea_freekey3 VARCHAR(200), @cmdarticlea_freekey3 VARCHAR(2000)
                SET @defnamearticlea_freekey3 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article') AND name = 'a_freekey3'
                    )
                )
                SET @cmdarticlea_freekey3 = 'ALTER TABLE article DROP CONSTRAINT ' + @defnamearticlea_freekey3
                EXEC(@cmdarticlea_freekey3)
;
                    DECLARE @sqlarticlea_freekey3 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlarticlea_freekey3 = (SELECT TOP 1 'ALTER TABLE article DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article' and column_name='a_freekey3'
                        )
                        IF @sqlarticlea_freekey3 IS NULL BREAK
                        EXEC (@sqlarticlea_freekey3)
                    END
;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP COLUMN a_freekey3;
ALTER TABLE ticket_flag ADD CONSTRAINT ticket_flag_per_user UNIQUE (ticket_id, ticket_key, create_by);
