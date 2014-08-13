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
DROP TABLE pm_entity;
-- ----------------------------------------------------------
--  create table personal_services
-- ----------------------------------------------------------
CREATE TABLE personal_services (
    user_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL
);
CREATE INDEX personal_services_queue_id ON personal_services (service_id);
CREATE INDEX personal_services_user_id ON personal_services (user_id);
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD from_cloud SMALLINT NULL;
GO
UPDATE package_repository SET from_cloud = 1 WHERE from_cloud IS NULL;
GO
ALTER TABLE package_repository ALTER COLUMN from_cloud SMALLINT NULL;
GO
ALTER TABLE package_repository ADD CONSTRAINT DF_package_repository_from_cloud DEFAULT (1) FOR from_cloud;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD visible SMALLINT NULL;
GO
UPDATE package_repository SET visible = 1 WHERE visible IS NULL;
GO
ALTER TABLE package_repository ALTER COLUMN visible SMALLINT NULL;
GO
ALTER TABLE package_repository ADD CONSTRAINT DF_package_repository_visible DEFAULT (1) FOR visible;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD downloadable SMALLINT NULL;
GO
UPDATE package_repository SET downloadable = 1 WHERE downloadable IS NULL;
GO
ALTER TABLE package_repository ALTER COLUMN downloadable SMALLINT NULL;
GO
ALTER TABLE package_repository ADD CONSTRAINT DF_package_repository_downloadable DEFAULT (1) FOR downloadable;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository ADD removable SMALLINT NULL;
GO
UPDATE package_repository SET removable = 1 WHERE removable IS NULL;
GO
ALTER TABLE package_repository ALTER COLUMN removable SMALLINT NULL;
GO
ALTER TABLE package_repository ADD CONSTRAINT DF_package_repository_removable DEFAULT (1) FOR removable;
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
