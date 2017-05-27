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
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'dynamic_field_value' AND index_name = 'dynamic_field_value_search_text');
SET @IndexSQLStatement := IF( @IndexExists = 0, 'CREATE INDEX dynamic_field_value_search_text ON dynamic_field_value (field_id, value_text(150))', 'SELECT ''INFO: Index dynamic_field_value_search_text already exists, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
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
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_body a_body MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article_attachment
# ----------------------------------------------------------
ALTER TABLE article_attachment CHANGE content content LONGBLOB NULL;
# ----------------------------------------------------------
#  alter table virtual_fs_db
# ----------------------------------------------------------
ALTER TABLE virtual_fs_db CHANGE content content LONGBLOB NULL;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'ticket_history' AND index_name = 'ticket_history_article_id');
SET @IndexSQLStatement := IF( @IndexExists = 0, 'CREATE INDEX ticket_history_article_id ON ticket_history (article_id)', 'SELECT ''INFO: Index ticket_history_article_id already exists, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
# ----------------------------------------------------------
#  create table communication_channel
# ----------------------------------------------------------
CREATE TABLE communication_channel (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    module VARCHAR (200) NOT NULL,
    package_name VARCHAR (200) NOT NULL,
    channel_data LONGBLOB NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX communication_channel_name (name)
);
# ----------------------------------------------------------
#  insert into table communication_channel
# ----------------------------------------------------------
INSERT INTO communication_channel (id, name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'Email', 'Kernel::System::CommunicationChannel::Email', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table communication_channel
# ----------------------------------------------------------
INSERT INTO communication_channel (id, name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'Phone', 'Kernel::System::CommunicationChannel::Phone', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table communication_channel
# ----------------------------------------------------------
INSERT INTO communication_channel (id, name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'Internal', 'Kernel::System::CommunicationChannel::Internal', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table communication_channel
# ----------------------------------------------------------
INSERT INTO communication_channel (id, name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'Chat', 'Kernel::System::CommunicationChannel::Chat', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataIsDroppable: 0
ArticleDataTables:
- article_data_otrs_chat
', 1, 1, current_timestamp, 1, current_timestamp);
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article' AND constraint_name = 'FK_article_valid_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article DROP FOREIGN KEY FK_article_valid_id_id', 'SELECT ''INFO: Foreign key constraint FK_article_valid_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article' AND index_name = 'FK_article_valid_id_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_valid_id_id ON article', 'SELECT ''INFO: Index FK_article_valid_id_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article' AND constraint_name = 'FK_article_ticket_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article DROP FOREIGN KEY FK_article_ticket_id_id', 'SELECT ''INFO: Foreign key constraint FK_article_ticket_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article' AND index_name = 'FK_article_ticket_id_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_ticket_id_id ON article', 'SELECT ''INFO: Index FK_article_ticket_id_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article' AND constraint_name = 'FK_article_article_type_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article DROP FOREIGN KEY FK_article_article_type_id_id', 'SELECT ''INFO: Foreign key constraint FK_article_article_type_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article' AND index_name = 'FK_article_article_type_id_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_article_type_id_id ON article', 'SELECT ''INFO: Index FK_article_article_type_id_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article' AND constraint_name = 'FK_article_article_sender_type_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article DROP FOREIGN KEY FK_article_article_sender_type_id_id', 'SELECT ''INFO: Foreign key constraint FK_article_article_sender_type_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article' AND index_name = 'FK_article_article_sender_type_id_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_article_sender_type_id_id ON article', 'SELECT ''INFO: Index FK_article_article_sender_type_id_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article' AND constraint_name = 'FK_article_create_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article DROP FOREIGN KEY FK_article_create_by_id', 'SELECT ''INFO: Foreign key constraint FK_article_create_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article' AND index_name = 'FK_article_create_by_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_create_by_id ON article', 'SELECT ''INFO: Index FK_article_create_by_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article' AND constraint_name = 'FK_article_change_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article DROP FOREIGN KEY FK_article_change_by_id', 'SELECT ''INFO: Foreign key constraint FK_article_change_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article' AND index_name = 'FK_article_change_by_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_change_by_id ON article', 'SELECT ''INFO: Index FK_article_change_by_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
DROP INDEX article_ticket_id ON article;
DROP INDEX article_article_type_id ON article;
DROP INDEX article_article_sender_type_id ON article;
DROP INDEX article_message_id_md5 ON article;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article_plain' AND constraint_name = 'FK_article_plain_article_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article_plain DROP FOREIGN KEY FK_article_plain_article_id_id', 'SELECT ''INFO: Foreign key constraint FK_article_plain_article_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article_plain' AND index_name = 'FK_article_plain_article_id_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_plain_article_id_id ON article_plain', 'SELECT ''INFO: Index FK_article_plain_article_id_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article_plain' AND constraint_name = 'FK_article_plain_create_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article_plain DROP FOREIGN KEY FK_article_plain_create_by_id', 'SELECT ''INFO: Foreign key constraint FK_article_plain_create_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article_plain' AND index_name = 'FK_article_plain_create_by_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_plain_create_by_id ON article_plain', 'SELECT ''INFO: Index FK_article_plain_create_by_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article_plain' AND constraint_name = 'FK_article_plain_change_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article_plain DROP FOREIGN KEY FK_article_plain_change_by_id', 'SELECT ''INFO: Foreign key constraint FK_article_plain_change_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article_plain' AND index_name = 'FK_article_plain_change_by_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_plain_change_by_id ON article_plain', 'SELECT ''INFO: Index FK_article_plain_change_by_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
DROP INDEX article_plain_article_id ON article_plain;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article_attachment' AND constraint_name = 'FK_article_attachment_article_id_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article_attachment DROP FOREIGN KEY FK_article_attachment_article_id_id', 'SELECT ''INFO: Foreign key constraint FK_article_attachment_article_id_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article_attachment' AND index_name = 'FK_article_attachment_article_id_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_attachment_article_id_id ON article_attachment', 'SELECT ''INFO: Index FK_article_attachment_article_id_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article_attachment' AND constraint_name = 'FK_article_attachment_create_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article_attachment DROP FOREIGN KEY FK_article_attachment_create_by_id', 'SELECT ''INFO: Foreign key constraint FK_article_attachment_create_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article_attachment' AND index_name = 'FK_article_attachment_create_by_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_attachment_create_by_id ON article_attachment', 'SELECT ''INFO: Index FK_article_attachment_create_by_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
#  MySQL does not create foreign key constraints in MyISAM. Dropping nonexisting constraints in MyISAM works just fine.;
#  However, if the table is converted to InnoDB, this will result in an error. Therefore, only drop constraints if they exist.;
SET @FKExists := (SELECT COUNT(*) FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'article_attachment' AND constraint_name = 'FK_article_attachment_change_by_id');
SET @FKSQLStatement := IF( @FKExists > 0, 'ALTER TABLE article_attachment DROP FOREIGN KEY FK_article_attachment_change_by_id', 'SELECT ''INFO: Foreign key constraint FK_article_attachment_change_by_id does not exist, skipping.''' );
PREPARE FKStatement FROM @FKSQLStatement;
EXECUTE FKStatement;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'article_attachment' AND index_name = 'FK_article_attachment_change_by_id');
SET @IndexSQLStatement := IF( @IndexExists > 0, 'DROP INDEX FK_article_attachment_change_by_id ON article_attachment', 'SELECT ''INFO: Index FK_article_attachment_change_by_id does not exist, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
DROP INDEX article_attachment_article_id ON article_attachment;
# ----------------------------------------------------------
#  alter table article_data_mime
# ----------------------------------------------------------
ALTER TABLE article RENAME article_data_mime;
# ----------------------------------------------------------
#  alter table article_data_mime_plain
# ----------------------------------------------------------
ALTER TABLE article_plain RENAME article_data_mime_plain;
# ----------------------------------------------------------
#  alter table article_data_mime_attachment
# ----------------------------------------------------------
ALTER TABLE article_attachment RENAME article_data_mime_attachment;
# ----------------------------------------------------------
#  create table article
# ----------------------------------------------------------
CREATE TABLE article (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    communication_channel_id BIGINT NOT NULL,
    is_visible_for_customer SMALLINT NOT NULL,
    insert_fingerprint VARCHAR (64) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX article_article_sender_type_id (article_sender_type_id),
    INDEX article_communication_channel_id (communication_channel_id),
    INDEX article_ticket_id (ticket_id)
);
# ----------------------------------------------------------
#  alter table article_data_mime
# ----------------------------------------------------------
ALTER TABLE article_data_mime ADD article_id BIGINT NULL;
UPDATE article_data_mime SET article_id = 0 WHERE article_id IS NULL;
ALTER TABLE article_data_mime CHANGE article_id article_id BIGINT NOT NULL;
SET @IndexExists := (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'ticket_history' AND index_name = 'ticket_history_article_id');
SET @IndexSQLStatement := IF( @IndexExists = 0, 'CREATE INDEX ticket_history_article_id ON ticket_history (article_id)', 'SELECT ''INFO: Index ticket_history_article_id already exists, skipping.''' );
PREPARE IndexStatement FROM @IndexSQLStatement;
EXECUTE IndexStatement;
# ----------------------------------------------------------
#  alter table ticket_history
# ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_communication_channel_id BIGINT NULL;
# ----------------------------------------------------------
#  alter table ticket_history
# ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_sender_type_id SMALLINT NULL;
# ----------------------------------------------------------
#  alter table ticket_history
# ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_is_visible_for_customer SMALLINT NULL;
ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_a_communication_channel_id_id FOREIGN KEY (a_communication_channel_id) REFERENCES communication_channel (id);
ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_a_sender_type_id_id FOREIGN KEY (a_sender_type_id) REFERENCES article_sender_type (id);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ArticleCreate', 1, 1, current_timestamp, 1, current_timestamp);
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
# ----------------------------------------------------------
#  create table article_data_otrs_chat
# ----------------------------------------------------------
CREATE TABLE article_data_otrs_chat (
    id BIGINT NOT NULL AUTO_INCREMENT,
    article_id BIGINT NOT NULL,
    chat_participant_id VARCHAR (255) NOT NULL,
    chat_participant_name VARCHAR (255) NOT NULL,
    chat_participant_type VARCHAR (255) NOT NULL,
    message_text TEXT NOT NULL,
    system_generated SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX article_data_otrs_chat_article_id (article_id)
);
# ----------------------------------------------------------
#  create table article_search_index
# ----------------------------------------------------------
CREATE TABLE article_search_index (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NOT NULL,
    article_key VARCHAR (200) NOT NULL,
    article_value MEDIUMTEXT NULL,
    PRIMARY KEY(id),
    INDEX article_search_index_article_id (article_id, article_key),
    INDEX article_search_index_ticket_id (ticket_id, article_key)
);
DROP TABLE IF EXISTS article_search;
# ----------------------------------------------------------
#  alter table users
# ----------------------------------------------------------
ALTER TABLE users CHANGE pw pw VARCHAR (128) NULL;
ALTER TABLE users ALTER pw DROP DEFAULT;
UPDATE users SET pw = '' WHERE pw IS NULL;
ALTER TABLE users CHANGE pw pw VARCHAR (128) NOT NULL;
# ----------------------------------------------------------
#  alter table customer_user
# ----------------------------------------------------------
ALTER TABLE customer_user CHANGE pw pw VARCHAR (128) NULL;
ALTER TABLE customer_user ALTER pw DROP DEFAULT;
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
