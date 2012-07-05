-- ----------------------------------------------------------
--  driver: db2, generated: 2012-07-05 09:13:21
-- ----------------------------------------------------------
ALTER TABLE ticket_index ALTER COLUMN queue DROP NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN queue SET DATA TYPE VARCHAR (200);

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN queue SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN queue DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

UPDATE ticket_index SET queue = '' WHERE queue IS NULL;

ALTER TABLE ticket_index ALTER COLUMN queue SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_state DROP NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_state SET DATA TYPE VARCHAR (200);

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_state SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_state DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

UPDATE ticket_index SET s_state = '' WHERE s_state IS NULL;

ALTER TABLE ticket_index ALTER COLUMN s_state SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_lock DROP NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket_index');

ALTER TABLE ticket_index ALTER COLUMN s_lock SET DATA TYPE VARCHAR (200);

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
    config_md5 VARCHAR (32) NOT NULL,
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
    config_md5 VARCHAR (32) NOT NULL,
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
    task_data_md5 VARCHAR (32) NOT NULL,
    task_type VARCHAR (200) NOT NULL,
    due_time TIMESTAMP NOT NULL,
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

-- ----------------------------------------------------------
--  create table gi_object_lock_state
-- ----------------------------------------------------------
CREATE TABLE gi_object_lock_state (
    webservice_id INTEGER NOT NULL,
    object_type VARCHAR (30) NOT NULL,
    object_id BIGINT NOT NULL,
    lock_state VARCHAR (30) NOT NULL,
    lock_state_counter INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    change_time TIMESTAMP NOT NULL,
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
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    cert_hash VARCHAR (8) NOT NULL,
    cert_fingerprint VARCHAR (59) NOT NULL,
    ca_hash VARCHAR (8) NOT NULL,
    ca_fingerprint VARCHAR (59) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);

-- ----------------------------------------------------------
--  alter table process_id
-- ----------------------------------------------------------
ALTER TABLE process_id ADD process_change INTEGER;

UPDATE process_id SET process_change = 0 WHERE process_change IS NULL;

ALTER TABLE process_id ALTER COLUMN process_change SET NOT NULL;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE process_id');

-- ----------------------------------------------------------
--  create table dynamic_field_value
-- ----------------------------------------------------------
CREATE TABLE dynamic_field_value (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    field_id INTEGER NOT NULL,
    object_id BIGINT NOT NULL,
    value_text VARCHAR (3800),
    value_date TIMESTAMP,
    value_int BIGINT,
    PRIMARY KEY(id)
);

CREATE INDEX index_field_values ON dynamic_field_value (field_id, object_id);

CREATE INDEX index_search_date ON dynamic_field_value (field_id, value_date);

CREATE INDEX index_search_int ON dynamic_field_value (field_id, value_int);

-- ----------------------------------------------------------
--  create table dynamic_field
-- ----------------------------------------------------------
CREATE TABLE dynamic_field (
    id INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    name VARCHAR (200) NOT NULL,
    label VARCHAR (200) NOT NULL,
    field_order INTEGER NOT NULL,
    field_type VARCHAR (200) NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    config BLOB (30M),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT dynamic_field_name UNIQUE (name)
);

-- ----------------------------------------------------------
--  alter table mail_account
-- ----------------------------------------------------------
ALTER TABLE mail_account ADD imap_folder VARCHAR (250);

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
