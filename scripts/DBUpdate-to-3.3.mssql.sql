-- ----------------------------------------------------------
--  driver: mssql, generated: 2013-06-20 10:38:00
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
-- ----------------------------------------------------------
--  create table acl
-- ----------------------------------------------------------
CREATE TABLE acl (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name NVARCHAR (200) NOT NULL,
    comments NVARCHAR (250) NOT NULL,
    description NVARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    stop_after_match SMALLINT NULL,
    config_match NVARCHAR (MAX) NULL,
    config_change NVARCHAR (MAX) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT acl_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table acl_sync
-- ----------------------------------------------------------
CREATE TABLE acl_sync (
    acl_id NVARCHAR (200) NOT NULL,
    sync_state NVARCHAR (30) NOT NULL,
    create_time DATETIME NOT NULL,
    change_time DATETIME NOT NULL
);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE system_data ADD CONSTRAINT FK_system_data_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE acl ADD CONSTRAINT FK_acl_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE acl ADD CONSTRAINT FK_acl_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE acl ADD CONSTRAINT FK_acl_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
