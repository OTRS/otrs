-- ----------------------------------------------------------
--  driver: mssql
-- ----------------------------------------------------------
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
-- ----------------------------------------------------------
--  create table scheduler_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_task (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    ident BIGINT NOT NULL,
    name NVARCHAR (200) NULL,
    task_type NVARCHAR (200) NOT NULL,
    task_data NVARCHAR (MAX) NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    lock_update_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_task_ident UNIQUE (ident)
);
CREATE INDEX scheduler_task_ident_id ON scheduler_task (ident, id);
CREATE INDEX scheduler_task_lock_key_id ON scheduler_task (lock_key, id);
-- ----------------------------------------------------------
--  create table scheduler_future_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_future_task (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    ident BIGINT NOT NULL,
    execution_time DATETIME NOT NULL,
    name NVARCHAR (200) NULL,
    task_type NVARCHAR (200) NOT NULL,
    task_data NVARCHAR (MAX) NOT NULL,
    attempts SMALLINT NOT NULL,
    maximum_parallel_instances SMALLINT NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_future_task_ident UNIQUE (ident)
);
CREATE INDEX scheduler_future_task_ident_id ON scheduler_future_task (ident, id);
CREATE INDEX scheduler_future_task_lock_key_id ON scheduler_future_task (lock_key, id);
-- ----------------------------------------------------------
--  create table scheduler_recurrent_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_recurrent_task (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    name NVARCHAR (200) NOT NULL,
    task_type NVARCHAR (200) NOT NULL,
    last_execution_time DATETIME NOT NULL,
    last_worker_task_id BIGINT NULL,
    last_worker_status SMALLINT NULL,
    last_worker_running_time INTEGER NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    change_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_recurrent_task_name_task_type UNIQUE (name, task_type)
);
CREATE INDEX scheduler_recurrent_task_lock_key_id ON scheduler_recurrent_task (lock_key, id);
CREATE INDEX scheduler_recurrent_task_task_type_name ON scheduler_recurrent_task (task_type, name);
DROP TABLE scheduler_task_list;
                DECLARE @defnameauto_responsetext2 VARCHAR(200), @cmdauto_responsetext2 VARCHAR(2000)
                SET @defnameauto_responsetext2 = (
                    SELECT name FROM sysobjects so JOIN sysconstraints sc ON so.id = sc.constid
                    WHERE object_name(so.parent_obj) = 'auto_response' AND so.xtype = 'D' AND sc.colid = (
                        SELECT colid FROM syscolumns WHERE id = object_id('auto_response') AND name = 'text2'
                    )
                )
                SET @cmdauto_responsetext2 = 'ALTER TABLE auto_response DROP CONSTRAINT ' + @defnameauto_responsetext2
                EXEC(@cmdauto_responsetext2)
;
                    DECLARE @sqlauto_responsetext2 NVARCHAR(4000)

                    WHILE 1=1
                    BEGIN
                        SET @sqlauto_responsetext2 = (SELECT TOP 1 'ALTER TABLE auto_response DROP CONSTRAINT [' + constraint_name + ']'
                        -- SELECT *
                        FROM information_schema.CONSTRAINT_COLUMN_USAGE where table_name='auto_response' and column_name='text2'
                        )
                        IF @sqlauto_responsetext2 IS NULL BREAK
                        EXEC (@sqlauto_responsetext2)
                    END
;
-- ----------------------------------------------------------
--  alter table auto_response
-- ----------------------------------------------------------
ALTER TABLE auto_response DROP COLUMN text2;
-- ----------------------------------------------------------
--  create table notification_event_message
-- ----------------------------------------------------------
CREATE TABLE notification_event_message (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    notification_id INTEGER NOT NULL,
    subject NVARCHAR (200) NOT NULL,
    text NVARCHAR (4000) NOT NULL,
    content_type NVARCHAR (250) NOT NULL,
    language NVARCHAR (60) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT notification_event_message_notification_id_language UNIQUE (notification_id, language)
);
CREATE INDEX notification_event_message_language ON notification_event_message (language);
CREATE INDEX notification_event_message_notification_id ON notification_event_message (notification_id);
ALTER TABLE notification_event_message ADD CONSTRAINT FK_notification_event_message_notification_id_id FOREIGN KEY (notification_id) REFERENCES notification_event (id);
