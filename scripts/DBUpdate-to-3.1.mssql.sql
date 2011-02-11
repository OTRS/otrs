-- ----------------------------------------------------------
--  driver: mssql, generated: 2011-02-11 11:45:22
-- ----------------------------------------------------------
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_ticket_index_queue' )
ALTER TABLE ticket_index DROP CONSTRAINT DF_ticket_index_queue;
GO
UPDATE ticket_index SET queue = '' WHERE queue IS NULL;
GO
ALTER TABLE ticket_index ALTER COLUMN queue VARCHAR (200) NOT NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_ticket_index_s_state' )
ALTER TABLE ticket_index DROP CONSTRAINT DF_ticket_index_s_state;
GO
UPDATE ticket_index SET s_state = '' WHERE s_state IS NULL;
GO
ALTER TABLE ticket_index ALTER COLUMN s_state VARCHAR (200) NOT NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_ticket_index_s_lock' )
ALTER TABLE ticket_index DROP CONSTRAINT DF_ticket_index_s_lock;
GO
UPDATE ticket_index SET s_lock = '' WHERE s_lock IS NULL;
GO
ALTER TABLE ticket_index ALTER COLUMN s_lock VARCHAR (200) NOT NULL;
-- ----------------------------------------------------------
--  create table gi_webservice_config
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table gi_webservice_config_history
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config_history (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    config_id INTEGER NOT NULL,
    config TEXT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table scheduler_task_list
-- ----------------------------------------------------------
CREATE TABLE scheduler_task_list (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    task_data VARCHAR (8000) NOT NULL,
    task_type VARCHAR (200) NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id)
);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_config_id_id FOREIGN KEY (config_id) REFERENCES gi_webservice_config (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
