-- ----------------------------------------------------------
--  driver: postgresql
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
-- ----------------------------------------------------------
--  create table dynamic_field_obj_id_name
-- ----------------------------------------------------------
CREATE TABLE dynamic_field_obj_id_name (
    object_id serial NOT NULL,
    object_name VARCHAR (200) NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    PRIMARY KEY(object_id),
    CONSTRAINT dynamic_field_object_name UNIQUE (object_name, object_type)
);
-- ----------------------------------------------------------
--  create table sysconfig_default
-- ----------------------------------------------------------
CREATE TABLE sysconfig_default (
    id serial NOT NULL,
    name VARCHAR (250) NOT NULL,
    description TEXT NOT NULL,
    navigation VARCHAR (200) NOT NULL,
    is_invisible SMALLINT NOT NULL,
    is_readonly SMALLINT NOT NULL,
    is_required SMALLINT NOT NULL,
    is_valid SMALLINT NOT NULL,
    has_configlevel SMALLINT NOT NULL,
    user_modification_possible SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    user_preferences_group VARCHAR (250) NULL,
    xml_content_raw TEXT NOT NULL,
    xml_content_parsed TEXT NOT NULL,
    xml_filename VARCHAR (250) NOT NULL,
    effective_value TEXT NOT NULL,
    is_dirty SMALLINT NOT NULL,
    exclusive_lock_guid VARCHAR (32) NOT NULL,
    exclusive_lock_user_id INTEGER NULL,
    exclusive_lock_expiry_time timestamp(0) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT sysconfig_default_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table sysconfig_default_version
-- ----------------------------------------------------------
CREATE TABLE sysconfig_default_version (
    id serial NOT NULL,
    sysconfig_default_id INTEGER NULL,
    name VARCHAR (250) NOT NULL,
    description TEXT NOT NULL,
    navigation VARCHAR (200) NOT NULL,
    is_invisible SMALLINT NOT NULL,
    is_readonly SMALLINT NOT NULL,
    is_required SMALLINT NOT NULL,
    is_valid SMALLINT NOT NULL,
    has_configlevel SMALLINT NOT NULL,
    user_modification_possible SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    user_preferences_group VARCHAR (250) NULL,
    xml_content_raw TEXT NOT NULL,
    xml_content_parsed TEXT NOT NULL,
    xml_filename VARCHAR (250) NOT NULL,
    effective_value TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table sysconfig_modified
-- ----------------------------------------------------------
CREATE TABLE sysconfig_modified (
    id serial NOT NULL,
    sysconfig_default_id INTEGER NOT NULL,
    name VARCHAR (250) NOT NULL,
    user_id INTEGER NULL,
    is_valid SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    effective_value TEXT NOT NULL,
    reset_to_default SMALLINT NOT NULL,
    is_dirty SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT sysconfig_modified_per_user UNIQUE (sysconfig_default_id, user_id)
);
-- ----------------------------------------------------------
--  create table sysconfig_modified_version
-- ----------------------------------------------------------
CREATE TABLE sysconfig_modified_version (
    id serial NOT NULL,
    sysconfig_default_version_id INTEGER NOT NULL,
    name VARCHAR (250) NOT NULL,
    user_id INTEGER NULL,
    is_valid SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    effective_value TEXT NOT NULL,
    reset_to_default SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table sysconfig_deployment_lock
-- ----------------------------------------------------------
CREATE TABLE sysconfig_deployment_lock (
    id serial NOT NULL,
    exclusive_lock_guid VARCHAR (32) NULL,
    exclusive_lock_user_id INTEGER NULL,
    exclusive_lock_expiry_time timestamp(0) NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table sysconfig_deployment
-- ----------------------------------------------------------
CREATE TABLE sysconfig_deployment (
    id serial NOT NULL,
    comments VARCHAR (250) NULL,
    user_id INTEGER NULL,
    effective_value TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'dynamic_field_value_search_text'
    ) THEN
    CREATE INDEX dynamic_field_value_search_text ON dynamic_field_value (field_id, value_text);
END IF;
END$$;
;
ALTER TABLE gi_webservice_config DROP CONSTRAINT gi_webservice_config_config_md5;
-- ----------------------------------------------------------
--  alter table gi_webservice_config
-- ----------------------------------------------------------
ALTER TABLE gi_webservice_config DROP config_md5;
ALTER TABLE cloud_service_config DROP CONSTRAINT cloud_service_config_config_md5;
-- ----------------------------------------------------------
--  alter table cloud_service_config
-- ----------------------------------------------------------
ALTER TABLE cloud_service_config DROP config_md5;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_from TYPE VARCHAR;
ALTER TABLE article ALTER a_from DROP DEFAULT;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_reply_to TYPE VARCHAR;
ALTER TABLE article ALTER a_reply_to DROP DEFAULT;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_to TYPE VARCHAR;
ALTER TABLE article ALTER a_to DROP DEFAULT;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_cc TYPE VARCHAR;
ALTER TABLE article ALTER a_cc DROP DEFAULT;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_references TYPE VARCHAR;
ALTER TABLE article ALTER a_references DROP DEFAULT;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_in_reply_to TYPE VARCHAR;
ALTER TABLE article ALTER a_in_reply_to DROP DEFAULT;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_body TYPE VARCHAR;
ALTER TABLE article ALTER a_body DROP DEFAULT;
-- ----------------------------------------------------------
--  alter table article_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment ALTER content TYPE TEXT;
ALTER TABLE article_attachment ALTER content DROP DEFAULT;
-- ----------------------------------------------------------
--  alter table virtual_fs_db
-- ----------------------------------------------------------
ALTER TABLE virtual_fs_db ALTER content TYPE TEXT;
ALTER TABLE virtual_fs_db ALTER content DROP DEFAULT;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'ticket_history_article_id'
    ) THEN
    CREATE INDEX ticket_history_article_id ON ticket_history (article_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table communication_channel
-- ----------------------------------------------------------
CREATE TABLE communication_channel (
    id bigserial NOT NULL,
    name VARCHAR (200) NOT NULL,
    module VARCHAR (200) NOT NULL,
    package_name VARCHAR (200) NOT NULL,
    channel_data TEXT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT communication_channel_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table group_customer
-- ----------------------------------------------------------
CREATE TABLE group_customer (
    customer_id VARCHAR (150) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    permission_context VARCHAR (100) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'group_customer_customer_id'
    ) THEN
    CREATE INDEX group_customer_customer_id ON group_customer (customer_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'group_customer_group_id'
    ) THEN
    CREATE INDEX group_customer_group_id ON group_customer (group_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table customer_user_customer
-- ----------------------------------------------------------
CREATE TABLE customer_user_customer (
    user_id VARCHAR (100) NOT NULL,
    customer_id VARCHAR (150) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'customer_user_customer_customer_id'
    ) THEN
    CREATE INDEX customer_user_customer_customer_id ON customer_user_customer (customer_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'customer_user_customer_user_id'
    ) THEN
    CREATE INDEX customer_user_customer_user_id ON customer_user_customer (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table article_search_index
-- ----------------------------------------------------------
CREATE TABLE article_search_index (
    id bigserial NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NOT NULL,
    article_key VARCHAR (200) NOT NULL,
    article_value VARCHAR NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'article_search_index_article_id'
    ) THEN
    CREATE INDEX article_search_index_article_id ON article_search_index (article_id, article_key);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'article_search_index_ticket_id'
    ) THEN
    CREATE INDEX article_search_index_ticket_id ON article_search_index (ticket_id, article_key);
END IF;
END$$;
;
DROP TABLE article_search;
SET standard_conforming_strings TO ON;
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
ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
