-- ----------------------------------------------------------
--  driver: mssql, generated: 2012-07-05 09:13:21
-- ----------------------------------------------------------
GO
ALTER TABLE ticket_index ALTER COLUMN queue NVARCHAR (200) NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_ticket_index_queue' )
ALTER TABLE ticket_index DROP CONSTRAINT DF_ticket_index_queue;
GO
UPDATE ticket_index SET queue = '' WHERE queue IS NULL;
GO
ALTER TABLE ticket_index ALTER COLUMN queue NVARCHAR (200) NOT NULL;
GO
ALTER TABLE ticket_index ALTER COLUMN s_state NVARCHAR (200) NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_ticket_index_s_state' )
ALTER TABLE ticket_index DROP CONSTRAINT DF_ticket_index_s_state;
GO
UPDATE ticket_index SET s_state = '' WHERE s_state IS NULL;
GO
ALTER TABLE ticket_index ALTER COLUMN s_state NVARCHAR (200) NOT NULL;
GO
ALTER TABLE ticket_index ALTER COLUMN s_lock NVARCHAR (200) NULL;
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_ticket_index_s_lock' )
ALTER TABLE ticket_index DROP CONSTRAINT DF_ticket_index_s_lock;
GO
UPDATE ticket_index SET s_lock = '' WHERE s_lock IS NULL;
GO
ALTER TABLE ticket_index ALTER COLUMN s_lock NVARCHAR (200) NOT NULL;
-- ----------------------------------------------------------
--  create table gi_webservice_config
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name NVARCHAR (200) NOT NULL,
    config NVARCHAR (MAX) NOT NULL,
    config_md5 NVARCHAR (32) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_config_md5 UNIQUE (config_md5),
    CONSTRAINT gi_webservice_config_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table gi_webservice_config_history
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config_history (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    config_id INTEGER NOT NULL,
    config NVARCHAR (MAX) NOT NULL,
    config_md5 NVARCHAR (32) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_history_config_md5 UNIQUE (config_md5)
);
-- ----------------------------------------------------------
--  create table scheduler_task_list
-- ----------------------------------------------------------
CREATE TABLE scheduler_task_list (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    task_data NVARCHAR (MAX) NOT NULL,
    task_data_md5 NVARCHAR (32) NOT NULL,
    task_type NVARCHAR (200) NOT NULL,
    due_time DATETIME NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_task_list_task_data_md5 UNIQUE (task_data_md5)
);
-- ----------------------------------------------------------
--  create table gi_debugger_entry
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    communication_id NVARCHAR (32) NOT NULL,
    communication_type NVARCHAR (50) NOT NULL,
    remote_ip NVARCHAR (50) NULL,
    webservice_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_debugger_entry_communication_id UNIQUE (communication_id)
);
CREATE INDEX gi_debugger_entry_create_time ON gi_debugger_entry (create_time);
-- ----------------------------------------------------------
--  create table gi_debugger_entry_content
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry_content (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    gi_debugger_entry_id BIGINT NOT NULL,
    debug_level NVARCHAR (50) NOT NULL,
    subject NVARCHAR (255) NOT NULL,
    content NVARCHAR (MAX) NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX gi_debugger_entry_content_create_time ON gi_debugger_entry_content (create_time);
CREATE INDEX gi_debugger_entry_content_debug_level ON gi_debugger_entry_content (debug_level);
-- ----------------------------------------------------------
--  create table gi_object_lock_state
-- ----------------------------------------------------------
CREATE TABLE gi_object_lock_state (
    webservice_id INTEGER NOT NULL,
    object_type NVARCHAR (30) NOT NULL,
    object_id BIGINT NOT NULL,
    lock_state NVARCHAR (30) NOT NULL,
    lock_state_counter INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    change_time DATETIME NOT NULL,
    CONSTRAINT gi_object_lock_state_list UNIQUE (webservice_id, object_type, object_id)
);
CREATE INDEX object_lock_state_list_state ON gi_object_lock_state (webservice_id, object_type, object_id, lock_state);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationSolutionTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationResponseTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationUpdateTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationSolutionTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationResponseTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationUpdateTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationSolutionTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationResponseTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationUpdateTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  create table smime_signer_cert_relations
-- ----------------------------------------------------------
CREATE TABLE smime_signer_cert_relations (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    cert_hash NVARCHAR (8) NOT NULL,
    cert_fingerprint NVARCHAR (59) NOT NULL,
    ca_hash NVARCHAR (8) NOT NULL,
    ca_fingerprint NVARCHAR (59) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  alter table process_id
-- ----------------------------------------------------------
ALTER TABLE process_id ADD process_change INTEGER NULL;
GO
UPDATE process_id SET process_change = 0 WHERE process_change IS NULL;
GO
ALTER TABLE process_id ALTER COLUMN process_change INTEGER NOT NULL;
-- ----------------------------------------------------------
--  create table dynamic_field_value
-- ----------------------------------------------------------
CREATE TABLE dynamic_field_value (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    field_id INTEGER NOT NULL,
    object_id BIGINT NOT NULL,
    value_text NVARCHAR (3800) NULL,
    value_date DATETIME NULL,
    value_int BIGINT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX index_field_values ON dynamic_field_value (field_id, object_id);
CREATE INDEX index_search_date ON dynamic_field_value (field_id, value_date);
CREATE INDEX index_search_int ON dynamic_field_value (field_id, value_int);
-- ----------------------------------------------------------
--  create table dynamic_field
-- ----------------------------------------------------------
CREATE TABLE dynamic_field (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name NVARCHAR (200) NOT NULL,
    label NVARCHAR (200) NOT NULL,
    field_order INTEGER NOT NULL,
    field_type NVARCHAR (200) NOT NULL,
    object_type NVARCHAR (200) NOT NULL,
    config NVARCHAR (MAX) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT dynamic_field_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  alter table mail_account
-- ----------------------------------------------------------
ALTER TABLE mail_account ADD imap_folder NVARCHAR (250) NULL;
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_config_id_id FOREIGN KEY (config_id) REFERENCES gi_webservice_config (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE gi_debugger_entry ADD CONSTRAINT FK_gi_debugger_entry_webservice_id_id FOREIGN KEY (webservice_id) REFERENCES gi_webservice_config (id);
ALTER TABLE gi_debugger_entry_content ADD CONSTRAINT FK_gi_debugger_entry_content_gi_debugger_entry_id_id FOREIGN KEY (gi_debugger_entry_id) REFERENCES gi_debugger_entry (id);
ALTER TABLE gi_object_lock_state ADD CONSTRAINT FK_gi_object_lock_state_webservice_id_id FOREIGN KEY (webservice_id) REFERENCES gi_webservice_config (id);
ALTER TABLE smime_signer_cert_relations ADD CONSTRAINT FK_smime_signer_cert_relations_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE smime_signer_cert_relations ADD CONSTRAINT FK_smime_signer_cert_relations_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE dynamic_field_value ADD CONSTRAINT FK_dynamic_field_value_field_id_id FOREIGN KEY (field_id) REFERENCES dynamic_field (id);
ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
