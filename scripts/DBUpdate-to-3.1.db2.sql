-- ----------------------------------------------------------
--  driver: db2, generated: 2011-02-22 10:35:28
-- ----------------------------------------------------------
ALTER TABLE ticket_index ALTER COLUMN queue SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN queue DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

UPDATE ticket_index SET queue = '' WHERE queue IS NULL;

ALTER TABLE ticket_index ALTER COLUMN queue SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_state SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_state DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

UPDATE ticket_index SET s_state = '' WHERE s_state IS NULL;

ALTER TABLE ticket_index ALTER COLUMN s_state SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_lock SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_lock DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

UPDATE ticket_index SET s_lock = '' WHERE s_lock IS NULL;

ALTER TABLE ticket_index ALTER COLUMN s_lock SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

-- ----------------------------------------------------------
--  create table gi_webservice_config
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    name VARCHAR (200) NOT NULL,
    config BLOB (30M) NOT NULL,
    config_md5 VARCHAR (42) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_config_md5 UNIQUE (config_md5),
    CONSTRAINT gi_webservice_config_name UNIQUE (name)
);

-- ----------------------------------------------------------
--  create table gi_webservice_config_history
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config_history (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    config_id INTEGER NOT NULL,
    config BLOB (30M) NOT NULL,
    config_md5 VARCHAR (42) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_history_config_md5 UNIQUE (config_md5)
);

-- ----------------------------------------------------------
--  create table scheduler_task_list
-- ----------------------------------------------------------
CREATE TABLE scheduler_task_list (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    task_data CLOB (62K) NOT NULL,
    task_data_md5 VARCHAR (42) NOT NULL,
    task_type VARCHAR (200) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_task_list_task_data_md5 UNIQUE (task_data_md5)
);

-- ----------------------------------------------------------
--  create table gi_debugger_entry
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    communication_id VARCHAR (32) NOT NULL,
    communication_type VARCHAR (50) NOT NULL,
    remote_ip VARCHAR (50),
    webservice_id INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_debugger_entry_communication_id UNIQUE (communication_id)
);

CREATE INDEX gi_debugger_entry_create_time ON gi_debugger_entry (create_time);

-- ----------------------------------------------------------
--  create table gi_debugger_entry_content
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry_content (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    gi_debugger_entry_id BIGINT NOT NULL,
    debug_level VARCHAR (50) NOT NULL,
    subject VARCHAR (255) NOT NULL,
    content BLOB (30M),
    create_time TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
);

CREATE INDEX gi_debugger_entry_content_crea4e ON gi_debugger_entry_content (create_time);

CREATE INDEX gi_debugger_entry_content_debua1 ON gi_debugger_entry_content (debug_level);

ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);

ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);

ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);

ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_config_id_id FOREIGN KEY (config_id) REFERENCES gi_webservice_config (id);

ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);

ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);

ALTER TABLE gi_debugger_entry ADD CONSTRAINT FK_gi_debugger_entry_webservice_id_id FOREIGN KEY (webservice_id) REFERENCES gi_webservice_config (id);

ALTER TABLE gi_debugger_entry_content ADD CONSTRAINT FK_gi_debugger_entry_content_gi_debugger_entry_id_id FOREIGN KEY (gi_debugger_entry_id) REFERENCES gi_debugger_entry (id);
