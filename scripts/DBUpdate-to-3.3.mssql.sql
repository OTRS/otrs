-- ----------------------------------------------------------
--  driver: mssql, generated: 2013-09-23 09:59:46
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('TitleUpdate', 1, 1, current_timestamp, 1, current_timestamp);
DROP INDEX dynamic_field_value.index_search_date;
CREATE INDEX dynamic_field_value_search_date ON dynamic_field_value (field_id, value_date);
DROP INDEX dynamic_field_value.index_search_int;
CREATE INDEX dynamic_field_value_search_int ON dynamic_field_value (field_id, value_int);
DROP INDEX dynamic_field_value.index_field_values;
CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id);
DROP INDEX article.article_message_id;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD a_message_id_md5 NVARCHAR (32) NULL;
CREATE INDEX article_message_id_md5 ON article (a_message_id_md5);
DROP INDEX article_search.article_search_message_id;
                DECLARE @defnamearticle_searcha_message_id VARCHAR(200), @cmdarticle_searcha_message_id VARCHAR(2000)
                SET @defnamearticle_searcha_message_id = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'article_search' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('article_search') AND name = 'a_message_id'
                    )
                )
                SET @cmdarticle_searcha_message_id = 'ALTER TABLE article_search DROP CONSTRAINT ' + @defnamearticle_searcha_message_id
                EXEC(@cmdarticle_searcha_message_id)
;
                    DECLARE @sqlarticle_searcha_message_id NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlarticle_searcha_message_id = (SELECT TOP 1 'ALTER TABLE article_search DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='article_search' and column_name='a_message_id'
                        )
                        IF @sqlarticle_searcha_message_id IS NULL BREAK
                        EXEC (@sqlarticle_searcha_message_id)
                    END
;
-- ----------------------------------------------------------
--  alter table article_search
-- ----------------------------------------------------------
ALTER TABLE article_search DROP COLUMN a_message_id;
-- ----------------------------------------------------------
--  create table system_data
-- ----------------------------------------------------------
CREATE TABLE system_data (
    data_key NVARCHAR (160) NOT NULL,
    data_value NVARCHAR (MAX) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(data_key)
);
GO
ALTER TABLE user_preferences ALTER COLUMN preferences_value NVARCHAR (MAX) NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_user_preferences_preferences_value' )
ALTER TABLE user_preferences DROP CONSTRAINT DF_user_preferences_preferences_value;
ALTER TABLE standard_response DROP CONSTRAINT FK_standard_response_valid_id_id;
ALTER TABLE standard_response DROP CONSTRAINT FK_standard_response_create_by_id;
ALTER TABLE standard_response DROP CONSTRAINT FK_standard_response_change_by_id;
ALTER TABLE queue_standard_response DROP CONSTRAINT FK_queue_standard_response_standard_response_id_id;
ALTER TABLE queue_standard_response DROP CONSTRAINT FK_queue_standard_response_queue_id_id;
ALTER TABLE queue_standard_response DROP CONSTRAINT FK_queue_standard_response_create_by_id;
ALTER TABLE queue_standard_response DROP CONSTRAINT FK_queue_standard_response_change_by_id;
ALTER TABLE standard_response_attachment DROP CONSTRAINT FK_standard_response_attachment_standard_response_id_id;
ALTER TABLE standard_response_attachment DROP CONSTRAINT FK_standard_response_attachment_standard_attachment_id_id;
ALTER TABLE standard_response_attachment DROP CONSTRAINT FK_standard_response_attachment_create_by_id;
ALTER TABLE standard_response_attachment DROP CONSTRAINT FK_standard_response_attachment_change_by_id;
ALTER TABLE standard_response DROP CONSTRAINT standard_response_name;
-- ----------------------------------------------------------
--  alter table standard_template
-- ----------------------------------------------------------
GO
EXEC sp_rename 'standard_response', 'standard_template'
GO
;
-- ----------------------------------------------------------
--  alter table queue_standard_template
-- ----------------------------------------------------------
GO
EXEC sp_rename 'queue_standard_response', 'queue_standard_template'
GO
;
-- ----------------------------------------------------------
--  alter table standard_template_attachment
-- ----------------------------------------------------------
GO
EXEC sp_rename 'standard_response_attachment', 'standard_template_attachment'
GO
;
ALTER TABLE standard_template ADD CONSTRAINT standard_template_name UNIQUE (name);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
GO
EXECUTE sp_rename N'queue_standard_template.standard_response_id', N'standard_template_id', 'COLUMN';
GO
ALTER TABLE queue_standard_template ALTER COLUMN standard_template_id INTEGER NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_queue_standard_template_standard_template_id' )
ALTER TABLE queue_standard_template DROP CONSTRAINT DF_queue_standard_template_standard_template_id;
GO
UPDATE queue_standard_template SET standard_template_id = 0 WHERE standard_template_id IS NULL;
GO
ALTER TABLE queue_standard_template ALTER COLUMN standard_template_id INTEGER NOT NULL;
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_standard_template_id_id FOREIGN KEY (standard_template_id) REFERENCES standard_template (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
GO
EXECUTE sp_rename N'standard_template_attachment.standard_response_id', N'standard_template_id', 'COLUMN';
GO
ALTER TABLE standard_template_attachment ALTER COLUMN standard_template_id INTEGER NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_standard_template_attachment_standard_template_id' )
ALTER TABLE standard_template_attachment DROP CONSTRAINT DF_standard_template_attachment_standard_template_id;
GO
UPDATE standard_template_attachment SET standard_template_id = 0 WHERE standard_template_id IS NULL;
GO
ALTER TABLE standard_template_attachment ALTER COLUMN standard_template_id INTEGER NOT NULL;
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_standard_template_id_id FOREIGN KEY (standard_template_id) REFERENCES standard_template (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_standard_attachment_id_id FOREIGN KEY (standard_attachment_id) REFERENCES standard_attachment (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
-- ----------------------------------------------------------
--  alter table postmaster_filter
-- ----------------------------------------------------------
ALTER TABLE postmaster_filter ADD f_not SMALLINT NULL;
DROP INDEX virtual_fs.virtual_fs_filename;
CREATE INDEX virtual_fs_filename ON virtual_fs (filename);
DROP INDEX virtual_fs_db.virtual_fs_db_filename;
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
