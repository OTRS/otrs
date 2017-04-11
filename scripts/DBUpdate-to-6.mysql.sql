# ----------------------------------------------------------
#  driver: mysql
# ----------------------------------------------------------
# ----------------------------------------------------------
#  create table dynamic_field_obj_id_name
# ----------------------------------------------------------
CREATE TABLE dynamic_field_obj_id_name (
    object_id INTEGER NOT NULL AUTO_INCREMENT,
    object_name VARCHAR (200) NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    PRIMARY KEY(object_id),
    UNIQUE INDEX dynamic_field_object_name (object_name, object_type)
);
CREATE INDEX dynamic_field_value_search_text ON dynamic_field_value (field_id, value_text(150));
# ----------------------------------------------------------
#  create table sysconfig_default
# ----------------------------------------------------------
CREATE TABLE sysconfig_default (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (250) NOT NULL,
    description LONGBLOB NOT NULL,
    navigation VARCHAR (200) NOT NULL,
    is_invisible SMALLINT NOT NULL,
    is_readonly SMALLINT NOT NULL,
    is_required SMALLINT NOT NULL,
    is_valid SMALLINT NOT NULL,
    has_configlevel SMALLINT NOT NULL,
    user_modification_possible SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    user_preferences_group VARCHAR (250) NULL,
    xml_content_raw LONGBLOB NOT NULL,
    xml_content_parsed LONGBLOB NOT NULL,
    xml_filename VARCHAR (250) NOT NULL,
    effective_value LONGBLOB NOT NULL,
    is_dirty SMALLINT NOT NULL,
    exclusive_lock_guid VARCHAR (32) NOT NULL,
    exclusive_lock_user_id INTEGER NULL,
    exclusive_lock_expiry_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX sysconfig_default_name (name)
);
# ----------------------------------------------------------
#  create table sysconfig_default_version
# ----------------------------------------------------------
CREATE TABLE sysconfig_default_version (
    id INTEGER NOT NULL AUTO_INCREMENT,
    sysconfig_default_id INTEGER NULL,
    name VARCHAR (250) NOT NULL,
    description LONGBLOB NOT NULL,
    navigation VARCHAR (200) NOT NULL,
    is_invisible SMALLINT NOT NULL,
    is_readonly SMALLINT NOT NULL,
    is_required SMALLINT NOT NULL,
    is_valid SMALLINT NOT NULL,
    has_configlevel SMALLINT NOT NULL,
    user_modification_possible SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    user_preferences_group VARCHAR (250) NULL,
    xml_content_raw LONGBLOB NOT NULL,
    xml_content_parsed LONGBLOB NOT NULL,
    xml_filename VARCHAR (250) NOT NULL,
    effective_value LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table sysconfig_modified
# ----------------------------------------------------------
CREATE TABLE sysconfig_modified (
    id INTEGER NOT NULL AUTO_INCREMENT,
    sysconfig_default_id INTEGER NOT NULL,
    name VARCHAR (250) NOT NULL,
    user_id INTEGER NULL,
    is_valid SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    effective_value LONGBLOB NOT NULL,
    reset_to_default SMALLINT NOT NULL,
    is_dirty SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX sysconfig_modified_per_user (sysconfig_default_id, user_id)
);
# ----------------------------------------------------------
#  create table sysconfig_modified_version
# ----------------------------------------------------------
CREATE TABLE sysconfig_modified_version (
    id INTEGER NOT NULL AUTO_INCREMENT,
    sysconfig_default_version_id INTEGER NOT NULL,
    name VARCHAR (250) NOT NULL,
    user_id INTEGER NULL,
    is_valid SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    effective_value LONGBLOB NOT NULL,
    reset_to_default SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table sysconfig_deployment_lock
# ----------------------------------------------------------
CREATE TABLE sysconfig_deployment_lock (
    id INTEGER NOT NULL AUTO_INCREMENT,
    exclusive_lock_guid VARCHAR (32) NULL,
    exclusive_lock_user_id INTEGER NULL,
    exclusive_lock_expiry_time DATETIME NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table sysconfig_deployment
# ----------------------------------------------------------
CREATE TABLE sysconfig_deployment (
    id INTEGER NOT NULL AUTO_INCREMENT,
    comments VARCHAR (250) NULL,
    user_id INTEGER NULL,
    effective_value LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX dynamic_field_value_search_text ON dynamic_field_value (field_id, value_text(150));
ALTER TABLE gi_webservice_config DROP INDEX gi_webservice_config_config_md5;
# ----------------------------------------------------------
#  alter table gi_webservice_config
# ----------------------------------------------------------
ALTER TABLE gi_webservice_config DROP config_md5;
ALTER TABLE cloud_service_config DROP INDEX cloud_service_config_config_md5;
# ----------------------------------------------------------
#  alter table cloud_service_config
# ----------------------------------------------------------
ALTER TABLE cloud_service_config DROP config_md5;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_from a_from MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_reply_to a_reply_to MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_to a_to MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_cc a_cc MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_references a_references MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_in_reply_to a_in_reply_to MEDIUMTEXT NULL;
CREATE INDEX ticket_history_article_id ON ticket_history (article_id);
# ----------------------------------------------------------
#  create table group_customer
# ----------------------------------------------------------
CREATE TABLE group_customer (
    customer_id VARCHAR (150) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    permission_context VARCHAR (100) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX group_customer_customer_id (customer_id),
    INDEX group_customer_group_id (group_id)
);
# ----------------------------------------------------------
#  create table customer_user_customer
# ----------------------------------------------------------
CREATE TABLE customer_user_customer (
    user_id VARCHAR (100) NOT NULL,
    customer_id VARCHAR (150) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX customer_user_customer_customer_id (customer_id),
    INDEX customer_user_customer_user_id (user_id)
);
ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_exclusive_lock_user_id_id FOREIGN KEY (exclusive_lock_user_id) REFERENCES users (id);
ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version_sysconfig_default_id_id FOREIGN KEY (sysconfig_default_id) REFERENCES sysconfig_default (id);
ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_sysconfig_default_id_id FOREIGN KEY (sysconfig_default_id) REFERENCES sysconfig_default (id);
ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_version_sysconfig_default_version_idaf FOREIGN KEY (sysconfig_default_version_id) REFERENCES sysconfig_default_version (id);
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_version_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_version_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_version_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE sysconfig_deployment_lock ADD CONSTRAINT FK_sysconfig_deployment_lock_exclusive_lock_user_id_id FOREIGN KEY (exclusive_lock_user_id) REFERENCES users (id);
ALTER TABLE sysconfig_deployment ADD CONSTRAINT FK_sysconfig_deployment_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABLE sysconfig_deployment ADD CONSTRAINT FK_sysconfig_deployment_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
