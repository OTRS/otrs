-- ----------------------------------------------------------
--  driver: mssql, generated: 2013-05-27 04:17:20
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
