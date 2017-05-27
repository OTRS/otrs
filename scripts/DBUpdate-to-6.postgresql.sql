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
--  insert into table communication_channel
-- ----------------------------------------------------------
INSERT INTO communication_channel (name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Email', 'Kernel::System::CommunicationChannel::Email', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table communication_channel
-- ----------------------------------------------------------
INSERT INTO communication_channel (name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Phone', 'Kernel::System::CommunicationChannel::Phone', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table communication_channel
-- ----------------------------------------------------------
INSERT INTO communication_channel (name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Internal', 'Kernel::System::CommunicationChannel::Internal', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table communication_channel
-- ----------------------------------------------------------
INSERT INTO communication_channel (name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Chat', 'Kernel::System::CommunicationChannel::Chat', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_otrs_chat
', 1, 1, current_timestamp, 1, current_timestamp);
ALTER TABLE article DROP CONSTRAINT FK_article_valid_id_id;
ALTER TABLE article DROP CONSTRAINT FK_article_ticket_id_id;
ALTER TABLE article DROP CONSTRAINT FK_article_article_type_id_id;
ALTER TABLE article DROP CONSTRAINT FK_article_article_sender_type_id_id;
ALTER TABLE article DROP CONSTRAINT FK_article_create_by_id;
ALTER TABLE article DROP CONSTRAINT FK_article_change_by_id;
DROP INDEX article_ticket_id;
DROP INDEX article_article_type_id;
DROP INDEX article_article_sender_type_id;
DROP INDEX article_message_id_md5;
ALTER TABLE article_plain DROP CONSTRAINT FK_article_plain_article_id_id;
ALTER TABLE article_plain DROP CONSTRAINT FK_article_plain_create_by_id;
ALTER TABLE article_plain DROP CONSTRAINT FK_article_plain_change_by_id;
DROP INDEX article_plain_article_id;
ALTER TABLE article_attachment DROP CONSTRAINT FK_article_attachment_article_id_id;
ALTER TABLE article_attachment DROP CONSTRAINT FK_article_attachment_create_by_id;
ALTER TABLE article_attachment DROP CONSTRAINT FK_article_attachment_change_by_id;
DROP INDEX article_attachment_article_id;
-- ----------------------------------------------------------
--  alter table article_data_mime
-- ----------------------------------------------------------
ALTER TABLE article RENAME TO article_data_mime;
-- ----------------------------------------------------------
--  alter table article_data_mime_plain
-- ----------------------------------------------------------
ALTER TABLE article_plain RENAME TO article_data_mime_plain;
-- ----------------------------------------------------------
--  alter table article_data_mime_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment RENAME TO article_data_mime_attachment;
-- ----------------------------------------------------------
--  create table article
-- ----------------------------------------------------------
CREATE TABLE article (
    id bigserial NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    communication_channel_id BIGINT NOT NULL,
    is_visible_for_customer SMALLINT NOT NULL,
    insert_fingerprint VARCHAR (64) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'article_article_sender_type_id'
    ) THEN
    CREATE INDEX article_article_sender_type_id ON article (article_sender_type_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'article_communication_channel_id'
    ) THEN
    CREATE INDEX article_communication_channel_id ON article (communication_channel_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'article_ticket_id'
    ) THEN
    CREATE INDEX article_ticket_id ON article (ticket_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  alter table article_data_mime
-- ----------------------------------------------------------
ALTER TABLE article_data_mime ADD article_id BIGINT NULL;
UPDATE article_data_mime SET article_id = 0 WHERE article_id IS NULL;
ALTER TABLE article_data_mime ALTER article_id SET NOT NULL;
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
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_communication_channel_id BIGINT NULL;
-- ----------------------------------------------------------
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_sender_type_id SMALLINT NULL;
-- ----------------------------------------------------------
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_is_visible_for_customer SMALLINT NULL;
ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_a_communication_channel_id_id FOREIGN KEY (a_communication_channel_id) REFERENCES communication_channel (id);
ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_a_sender_type_id_id FOREIGN KEY (a_sender_type_id) REFERENCES article_sender_type (id);
-- ----------------------------------------------------------
--  insert into table ticket_history_type
-- ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ArticleCreate', 1, 1, current_timestamp, 1, current_timestamp);
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
--  create table article_data_otrs_chat
-- ----------------------------------------------------------
CREATE TABLE article_data_otrs_chat (
    id bigserial NOT NULL,
    article_id BIGINT NOT NULL,
    chat_participant_id VARCHAR (255) NOT NULL,
    chat_participant_name VARCHAR (255) NOT NULL,
    chat_participant_type VARCHAR (255) NOT NULL,
    message_text VARCHAR (3800) NOT NULL,
    system_generated SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE indexname = 'article_data_otrs_chat_article_id'
    ) THEN
    CREATE INDEX article_data_otrs_chat_article_id ON article_data_otrs_chat (article_id);
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
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users ALTER pw TYPE VARCHAR (128);
ALTER TABLE users ALTER pw DROP DEFAULT;
UPDATE users SET pw = '' WHERE pw IS NULL;
ALTER TABLE users ALTER pw SET NOT NULL;
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ALTER pw TYPE VARCHAR (128);
ALTER TABLE customer_user ALTER pw DROP DEFAULT;
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
ALTER TABLE article ADD CONSTRAINT FK_article_article_sender_type_id_id FOREIGN KEY (article_sender_type_id) REFERENCES article_sender_type (id);
ALTER TABLE article ADD CONSTRAINT FK_article_communication_channel_id_id FOREIGN KEY (communication_channel_id) REFERENCES communication_channel (id);
ALTER TABLE article ADD CONSTRAINT FK_article_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
ALTER TABLE article ADD CONSTRAINT FK_article_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE article ADD CONSTRAINT FK_article_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE article_data_otrs_chat ADD CONSTRAINT FK_article_data_otrs_chat_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
