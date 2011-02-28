-- ----------------------------------------------------------
--  driver: ingres, generated: 2011-02-17 16:57:22
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table ticket_index
-- ----------------------------------------------------------
ALTER TABLE ticket_index ALTER COLUMN queue VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table ticket_index
-- ----------------------------------------------------------
ALTER TABLE ticket_index ALTER COLUMN s_state VARCHAR(200);\g
-- ----------------------------------------------------------
--  alter table ticket_index
-- ----------------------------------------------------------
ALTER TABLE ticket_index ALTER COLUMN s_lock VARCHAR(200);\g
CREATE SEQUENCE gi_webservice_config_970;\g
CREATE TABLE gi_webservice_config (
    id INTEGER NOT NULL DEFAULT gi_webservice_config_970.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    config LONG BYTE NOT NULL,
    config_md5 VARCHAR(32) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name),
    UNIQUE (config_md5)
);\g
MODIFY gi_webservice_config TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE gi_webservice_config ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE gi_webservice_config_history_256;\g
CREATE TABLE gi_webservice_config_history (
    id BIGINT NOT NULL DEFAULT gi_webservice_config_history_256.NEXTVAL,
    config_id INTEGER NOT NULL,
    config LONG BYTE NOT NULL,
    config_md5 VARCHAR(32) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (config_md5)
);\g
MODIFY gi_webservice_config_history TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE gi_webservice_config_history ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE scheduler_task_list_954;\g
CREATE TABLE scheduler_task_list (
    id BIGINT NOT NULL DEFAULT scheduler_task_list_954.NEXTVAL,
    task_data VARCHAR(8000) NOT NULL,
    task_data_md5 VARCHAR(32) NOT NULL,
    task_type VARCHAR(200) NOT NULL,
    due_time TIMESTAMP NOT NULL,
    create_time TIMESTAMP NOT NULL,
    UNIQUE (task_data_md5)
);\g
MODIFY scheduler_task_list TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE scheduler_task_list ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE gi_debugger_entry_205;\g
CREATE TABLE gi_debugger_entry (
    id BIGINT NOT NULL DEFAULT gi_debugger_entry_205.NEXTVAL,
    communication_id VARCHAR(32) NOT NULL,
    communication_type VARCHAR(50) NOT NULL,
    remote_ip VARCHAR(50),
    webservice_id INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    UNIQUE (communication_id)
);\g
MODIFY gi_debugger_entry TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE gi_debugger_entry ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX gi_debugger_entry_create_time ON gi_debugger_entry (create_time);\g
CREATE SEQUENCE gi_debugger_entry_content_572;\g
CREATE TABLE gi_debugger_entry_content (
    id BIGINT NOT NULL DEFAULT gi_debugger_entry_content_572.NEXTVAL,
    gi_debugger_entry_id BIGINT NOT NULL,
    debug_level VARCHAR(50) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    content LONG BYTE,
    create_time TIMESTAMP NOT NULL
);\g
MODIFY gi_debugger_entry_content TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE gi_debugger_entry_content ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX gi_debugger_entry_content_debug_level ON gi_debugger_entry_content (debug_level);\g
CREATE INDEX gi_debugger_entry_content_create_time ON gi_debugger_entry_content (create_time);\g
ALTER TABLE gi_webservice_config ADD FOREIGN KEY (create_by) REFERENCES users(id);\g
ALTER TABLE gi_webservice_config ADD FOREIGN KEY (change_by) REFERENCES users(id);\g
ALTER TABLE gi_webservice_config ADD FOREIGN KEY (valid_id) REFERENCES valid(id);\g
ALTER TABLE gi_webservice_config_history ADD FOREIGN KEY (config_id) REFERENCES gi_webservice_config(id);\g
ALTER TABLE gi_webservice_config_history ADD FOREIGN KEY (create_by) REFERENCES users(id);\g
ALTER TABLE gi_webservice_config_history ADD FOREIGN KEY (change_by) REFERENCES users(id);\g
ALTER TABLE gi_debugger_entry ADD FOREIGN KEY (webservice_id) REFERENCES gi_webservice_config(id);\g
ALTER TABLE gi_debugger_entry_content ADD FOREIGN KEY (gi_debugger_entry_id) REFERENCES gi_debugger_entry(id);\g

-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationResponseTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationUpdateTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationSolutionTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationResponseTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationUpdateTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationSolutionTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationResponseTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationUpdateTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('EscalationSolutionTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
