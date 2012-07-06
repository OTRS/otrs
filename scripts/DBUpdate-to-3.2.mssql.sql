-- ----------------------------------------------------------
--  driver: mssql, generated: 2012-07-05 22:24:16
-- ----------------------------------------------------------
                DECLARE @defnameticketgroup_read VARCHAR(200), @cmdticketgroup_read VARCHAR(2000)
                SET @defnameticketgroup_read = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'group_read'
                    )
                )
                SET @cmdticketgroup_read = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketgroup_read
                EXEC(@cmdticketgroup_read)
;
                    DECLARE @sqlticketgroup_read NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketgroup_read = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='group_read'
                        )
                        IF @sqlticketgroup_read IS NULL BREAK
                        EXEC (@sqlticketgroup_read)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_read;
                DECLARE @defnameticketgroup_write VARCHAR(200), @cmdticketgroup_write VARCHAR(2000)
                SET @defnameticketgroup_write = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'group_write'
                    )
                )
                SET @cmdticketgroup_write = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketgroup_write
                EXEC(@cmdticketgroup_write)
;
                    DECLARE @sqlticketgroup_write NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketgroup_write = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='group_write'
                        )
                        IF @sqlticketgroup_write IS NULL BREAK
                        EXEC (@sqlticketgroup_write)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_write;
                DECLARE @defnameticketother_read VARCHAR(200), @cmdticketother_read VARCHAR(2000)
                SET @defnameticketother_read = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'other_read'
                    )
                )
                SET @cmdticketother_read = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketother_read
                EXEC(@cmdticketother_read)
;
                    DECLARE @sqlticketother_read NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketother_read = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='other_read'
                        )
                        IF @sqlticketother_read IS NULL BREAK
                        EXEC (@sqlticketother_read)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN other_read;
                DECLARE @defnameticketother_write VARCHAR(200), @cmdticketother_write VARCHAR(2000)
                SET @defnameticketother_write = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'other_write'
                    )
                )
                SET @cmdticketother_write = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketother_write
                EXEC(@cmdticketother_write)
;
                    DECLARE @sqlticketother_write NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketother_write = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='other_write'
                        )
                        IF @sqlticketother_write IS NULL BREAK
                        EXEC (@sqlticketother_write)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN other_write;
DROP INDEX ticket.ticket_answered;
                DECLARE @defnameticketticket_answered VARCHAR(200), @cmdticketticket_answered VARCHAR(2000)
                SET @defnameticketticket_answered = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'ticket_answered'
                    )
                )
                SET @cmdticketticket_answered = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketticket_answered
                EXEC(@cmdticketticket_answered)
;
                    DECLARE @sqlticketticket_answered NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketticket_answered = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='ticket_answered'
                        )
                        IF @sqlticketticket_answered IS NULL BREAK
                        EXEC (@sqlticketticket_answered)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN ticket_answered;
DROP INDEX article_flag.article_flag_create_by;
DROP INDEX article_flag.article_flag_article_id_article_key;
DROP INDEX ticket.ticket_queue_view;
                DECLARE @defnameticketgroup_id VARCHAR(200), @cmdticketgroup_id VARCHAR(2000)
                SET @defnameticketgroup_id = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'group_id'
                    )
                )
                SET @cmdticketgroup_id = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketgroup_id
                EXEC(@cmdticketgroup_id)
;
                    DECLARE @sqlticketgroup_id NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketgroup_id = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='group_id'
                        )
                        IF @sqlticketgroup_id IS NULL BREAK
                        EXEC (@sqlticketgroup_id)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_id;
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
-- ----------------------------------------------------------
--  create table pm_process
-- ----------------------------------------------------------
CREATE TABLE pm_process (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    entity_id NVARCHAR (50) NOT NULL,
    name NVARCHAR (200) NOT NULL,
    state_id SMALLINT NOT NULL,
    layout NVARCHAR (MAX) NOT NULL,
    config NVARCHAR (MAX) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_process_entity_id UNIQUE (entity_id)
);
-- ----------------------------------------------------------
--  create table pm_activity
-- ----------------------------------------------------------
CREATE TABLE pm_activity (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    entity_id NVARCHAR (50) NOT NULL,
    name NVARCHAR (200) NOT NULL,
    config NVARCHAR (MAX) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_activity_entity_id UNIQUE (entity_id)
);
-- ----------------------------------------------------------
--  create table pm_activity_dialog
-- ----------------------------------------------------------
CREATE TABLE pm_activity_dialog (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    entity_id NVARCHAR (50) NOT NULL,
    name NVARCHAR (200) NOT NULL,
    config NVARCHAR (MAX) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_activity_dialog_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
