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
CREATE INDEX personal_services_service_id ON personal_services (service_id);
CREATE INDEX personal_services_user_id ON personal_services (user_id);
                DECLARE @defnamepackage_repositorycontent_size VARCHAR(200), @cmdpackage_repositorycontent_size VARCHAR(2000)
                SET @defnamepackage_repositorycontent_size = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'package_repository' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('package_repository') AND name = 'content_size'
                    )
                )
                SET @cmdpackage_repositorycontent_size = 'ALTER TABLE package_repository DROP CONSTRAINT ' + @defnamepackage_repositorycontent_size
                EXEC(@cmdpackage_repositorycontent_size)
;
                    DECLARE @sqlpackage_repositorycontent_size NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlpackage_repositorycontent_size = (SELECT TOP 1 'ALTER TABLE package_repository DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='package_repository' and column_name='content_size'
                        )
                        IF @sqlpackage_repositorycontent_size IS NULL BREAK
                        EXEC (@sqlpackage_repositorycontent_size)
                    END
;
-- ----------------------------------------------------------
--  alter table package_repository
-- ----------------------------------------------------------
ALTER TABLE package_repository DROP COLUMN content_size;
-- ----------------------------------------------------------
--  create table system_maintenance
-- ----------------------------------------------------------
CREATE TABLE system_maintenance (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    start_date INTEGER NOT NULL,
    stop_date INTEGER NOT NULL,
    comments NVARCHAR (250) NOT NULL,
    login_message NVARCHAR (250) NULL,
    show_login_message SMALLINT NULL,
    notify_message NVARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  alter table postmaster_filter
-- ----------------------------------------------------------
ALTER TABLE postmaster_filter ADD f_not SMALLINT NULL;
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
