-- ----------------------------------------------------------
--  driver: mssql
-- ----------------------------------------------------------
DROP INDEX dynamic_field_value.dynamic_field_value_field_values;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id, field_id);
-- ----------------------------------------------------------
--  alter table web_upload_cache
-- ----------------------------------------------------------
ALTER TABLE web_upload_cache ADD disposition NVARCHAR (15) NULL;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ADD disposition NVARCHAR (15) NULL;
ALTER TABLE ticket DROP CONSTRAINT FK_ticket_valid_id_id;
                DECLARE @defnameticketvalid_id VARCHAR(200), @cmdticketvalid_id VARCHAR(2000)
                SET @defnameticketvalid_id = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket') AND name = 'valid_id'
                    )
                )
                SET @cmdticketvalid_id = 'ALTER TABLE ticket DROP CONSTRAINT ' + @defnameticketvalid_id
                EXEC(@cmdticketvalid_id)
;
                    DECLARE @sqlticketvalid_id NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticketvalid_id = (SELECT TOP 1 'ALTER TABLE ticket DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket' and column_name='valid_id'
                        )
                        IF @sqlticketvalid_id IS NULL BREAK
                        EXEC (@sqlticketvalid_id)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN valid_id;
ALTER TABLE ticket_history DROP CONSTRAINT FK_ticket_history_valid_id_id;
                DECLARE @defnameticket_historyvalid_id VARCHAR(200), @cmdticket_historyvalid_id VARCHAR(2000)
                SET @defnameticket_historyvalid_id = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'ticket_history' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('ticket_history') AND name = 'valid_id'
                    )
                )
                SET @cmdticket_historyvalid_id = 'ALTER TABLE ticket_history DROP CONSTRAINT ' + @defnameticket_historyvalid_id
                EXEC(@cmdticket_historyvalid_id)
;
                    DECLARE @sqlticket_historyvalid_id NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlticket_historyvalid_id = (SELECT TOP 1 'ALTER TABLE ticket_history DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='ticket_history' and column_name='valid_id'
                        )
                        IF @sqlticket_historyvalid_id IS NULL BREAK
                        EXEC (@sqlticket_historyvalid_id)
                    END
;
-- ----------------------------------------------------------
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history DROP COLUMN valid_id;
