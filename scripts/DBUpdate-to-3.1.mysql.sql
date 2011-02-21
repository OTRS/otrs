# ----------------------------------------------------------
#  driver: mysql, generated: 2011-02-21 14:12:53
# ----------------------------------------------------------
# ----------------------------------------------------------
#  alter table ticket_index
# ----------------------------------------------------------
ALTER TABLE ticket_index CHANGE queue queue VARCHAR (200) NULL;
ALTER TABLE ticket_index ALTER queue DROP DEFAULT;
UPDATE ticket_index SET queue = '' WHERE queue IS NULL;
ALTER TABLE ticket_index CHANGE queue queue VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table ticket_index
# ----------------------------------------------------------
ALTER TABLE ticket_index CHANGE s_state s_state VARCHAR (200) NULL;
ALTER TABLE ticket_index ALTER s_state DROP DEFAULT;
UPDATE ticket_index SET s_state = '' WHERE s_state IS NULL;
ALTER TABLE ticket_index CHANGE s_state s_state VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  alter table ticket_index
# ----------------------------------------------------------
ALTER TABLE ticket_index CHANGE s_lock s_lock VARCHAR (200) NULL;
ALTER TABLE ticket_index ALTER s_lock DROP DEFAULT;
UPDATE ticket_index SET s_lock = '' WHERE s_lock IS NULL;
ALTER TABLE ticket_index CHANGE s_lock s_lock VARCHAR (200) NOT NULL;
# ----------------------------------------------------------
#  create table gi_webservice_config
# ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    config_md5 VARCHAR (32) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX gi_webservice_config_name (name)
);
# ----------------------------------------------------------
#  create table gi_webservice_config_history
# ----------------------------------------------------------
CREATE TABLE gi_webservice_config_history (
    id BIGINT NOT NULL AUTO_INCREMENT,
    config_id INTEGER NOT NULL,
    config LONGBLOB NOT NULL,
    config_md5 VARCHAR (32) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table scheduler_task_list
# ----------------------------------------------------------
CREATE TABLE scheduler_task_list (
    id BIGINT NOT NULL AUTO_INCREMENT,
    task_data TEXT NOT NULL,
    task_data_md5 VARCHAR (32) NOT NULL,
    task_type VARCHAR (200) NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table gi_debugger_entry
# ----------------------------------------------------------
CREATE TABLE gi_debugger_entry (
    id BIGINT NOT NULL AUTO_INCREMENT,
    communication_id VARCHAR (32) NOT NULL,
    communication_type VARCHAR (50) NOT NULL,
    remote_ip VARCHAR (50) NULL,
    webservice_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX gi_debugger_entry_communication_id (communication_id),
    INDEX gi_debugger_entry_create_time (create_time)
);
# ----------------------------------------------------------
#  create table gi_debugger_entry_content
# ----------------------------------------------------------
CREATE TABLE gi_debugger_entry_content (
    id BIGINT NOT NULL AUTO_INCREMENT,
    gi_debugger_entry_id BIGINT NOT NULL,
    debug_level VARCHAR (50) NOT NULL,
    subject VARCHAR (255) NOT NULL,
    content LONGBLOB NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX gi_debugger_entry_content_create_time (create_time),
    INDEX gi_debugger_entry_content_debug_level (debug_level)
);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_config_id_id FOREIGN KEY (config_id) REFERENCES gi_webservice_config (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE gi_debugger_entry ADD CONSTRAINT FK_gi_debugger_entry_webservice_id_id FOREIGN KEY (webservice_id) REFERENCES gi_webservice_config (id);
ALTER TABLE gi_debugger_entry_content ADD CONSTRAINT FK_gi_debugger_entry_content_gi_debugger_entry_id_id FOREIGN KEY (gi_debugger_entry_id) REFERENCES gi_debugger_entry (id);
