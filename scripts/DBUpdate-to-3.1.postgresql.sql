-- ----------------------------------------------------------
--  driver: postgresql, generated: 2011-05-18 15:31:57
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table ticket_index
-- ----------------------------------------------------------
ALTER TABLE ticket_index ALTER queue TYPE VARCHAR (200);
ALTER TABLE ticket_index ALTER queue DROP DEFAULT;
UPDATE ticket_index SET queue = '' WHERE queue IS NULL;
ALTER TABLE ticket_index ALTER queue SET NOT NULL;
-- ----------------------------------------------------------
--  alter table ticket_index
-- ----------------------------------------------------------
ALTER TABLE ticket_index ALTER s_state TYPE VARCHAR (200);
ALTER TABLE ticket_index ALTER s_state DROP DEFAULT;
UPDATE ticket_index SET s_state = '' WHERE s_state IS NULL;
ALTER TABLE ticket_index ALTER s_state SET NOT NULL;
-- ----------------------------------------------------------
--  alter table ticket_index
-- ----------------------------------------------------------
ALTER TABLE ticket_index ALTER s_lock TYPE VARCHAR (200);
ALTER TABLE ticket_index ALTER s_lock DROP DEFAULT;
UPDATE ticket_index SET s_lock = '' WHERE s_lock IS NULL;
ALTER TABLE ticket_index ALTER s_lock SET NOT NULL;
-- ----------------------------------------------------------
--  create table gi_webservice_config
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    config_md5 VARCHAR (32) NOT NULL,
    valid_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_config_md5 UNIQUE (config_md5),
    CONSTRAINT gi_webservice_config_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table gi_webservice_config_history
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config_history (
    id serial NOT NULL,
    config_id INTEGER NOT NULL,
    config TEXT NOT NULL,
    config_md5 VARCHAR (32) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_history_config_md5 UNIQUE (config_md5)
);
-- ----------------------------------------------------------
--  create table scheduler_task_list
-- ----------------------------------------------------------
CREATE TABLE scheduler_task_list (
    id serial NOT NULL,
    task_data VARCHAR (8000) NOT NULL,
    task_data_md5 VARCHAR (32) NOT NULL,
    task_type VARCHAR (200) NOT NULL,
    due_time timestamp(0) NOT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_task_list_task_data_md5 UNIQUE (task_data_md5)
);
-- ----------------------------------------------------------
--  create table gi_debugger_entry
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry (
    id serial NOT NULL,
    communication_id VARCHAR (32) NOT NULL,
    communication_type VARCHAR (50) NOT NULL,
    remote_ip VARCHAR (50) NULL,
    webservice_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_debugger_entry_communication_id UNIQUE (communication_id)
);
CREATE INDEX gi_debugger_entry_create_time ON gi_debugger_entry (create_time);
-- ----------------------------------------------------------
--  create table gi_debugger_entry_content
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry_content (
    id serial NOT NULL,
    gi_debugger_entry_id INTEGER NOT NULL,
    debug_level VARCHAR (50) NOT NULL,
    subject VARCHAR (255) NOT NULL,
    content TEXT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX gi_debugger_entry_content_create_time ON gi_debugger_entry_content (create_time);
CREATE INDEX gi_debugger_entry_content_debug_level ON gi_debugger_entry_content (debug_level);
-- ----------------------------------------------------------
--  create table gi_object_lock_state
-- ----------------------------------------------------------
CREATE TABLE gi_object_lock_state (
    webservice_id INTEGER NOT NULL,
    object_type VARCHAR (30) NOT NULL,
    object_id INTEGER NOT NULL,
    lock_state VARCHAR (30) NOT NULL,
    lock_state_counter INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    change_time timestamp(0) NOT NULL,
    CONSTRAINT gi_object_lock_state_U_79 UNIQUE (webservice_id, object_type, object_id)
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
    id serial NOT NULL,
    cert_hash VARCHAR (8) NOT NULL,
    cert_fingerprint VARCHAR (59) NOT NULL,
    ca_hash VARCHAR (8) NOT NULL,
    ca_fingerprint VARCHAR (59) NOT NULL,
    changed timestamp(0) NOT NULL,
    changed_by INTEGER NOT NULL,
    created timestamp(0) NOT NULL,
    created_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
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
