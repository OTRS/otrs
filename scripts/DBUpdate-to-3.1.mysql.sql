# ----------------------------------------------------------
#  driver: mysql, generated: 2011-02-11 11:45:22
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
