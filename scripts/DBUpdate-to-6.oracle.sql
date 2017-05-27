-- ----------------------------------------------------------
--  driver: oracle
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
-- ----------------------------------------------------------
--  create table dynamic_field_obj_id_name
-- ----------------------------------------------------------
CREATE TABLE dynamic_field_obj_id_name (
    object_id NUMBER (12, 0) NOT NULL,
    object_name VARCHAR2 (200) NOT NULL,
    object_type VARCHAR2 (200) NOT NULL,
    CONSTRAINT dynamic_field_object_name UNIQUE (object_name, object_type)
);
ALTER TABLE dynamic_field_obj_id_name ADD CONSTRAINT PK_dynamic_field_obj_id_name PRIMARY KEY (object_id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_dynamic_field_obj_id_name';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_dynamic_field_obj_id_name
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_dynamic_field_obj_id_name_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_dynamic_field_obj_id_name_t
BEFORE INSERT ON dynamic_field_obj_id_name
FOR EACH ROW
BEGIN
    IF :new.object_id IS NULL THEN
        SELECT SE_dynamic_field_obj_id_name.nextval
        INTO :new.object_id
        FROM DUAL;
    END IF;
END;
/
--
;
-- ----------------------------------------------------------
--  create table sysconfig_default
-- ----------------------------------------------------------
CREATE TABLE sysconfig_default (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (250) NOT NULL,
    description CLOB NOT NULL,
    navigation VARCHAR2 (200) NOT NULL,
    is_invisible NUMBER (5, 0) NOT NULL,
    is_readonly NUMBER (5, 0) NOT NULL,
    is_required NUMBER (5, 0) NOT NULL,
    is_valid NUMBER (5, 0) NOT NULL,
    has_configlevel NUMBER (5, 0) NOT NULL,
    user_modification_possible NUMBER (5, 0) NOT NULL,
    user_modification_active NUMBER (5, 0) NOT NULL,
    user_preferences_group VARCHAR2 (250) NULL,
    xml_content_raw CLOB NOT NULL,
    xml_content_parsed CLOB NOT NULL,
    xml_filename VARCHAR2 (250) NOT NULL,
    effective_value CLOB NOT NULL,
    is_dirty NUMBER (5, 0) NOT NULL,
    exclusive_lock_guid VARCHAR2 (32) NOT NULL,
    exclusive_lock_user_id NUMBER (12, 0) NULL,
    exclusive_lock_expiry_time DATE NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT sysconfig_default_name UNIQUE (name)
);
ALTER TABLE sysconfig_default ADD CONSTRAINT PK_sysconfig_default PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_sysconfig_default';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_sysconfig_default
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_sysconfig_default_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_sysconfig_default_t
BEFORE INSERT ON sysconfig_default
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_sysconfig_default.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
-- ----------------------------------------------------------
--  create table sysconfig_default_version
-- ----------------------------------------------------------
CREATE TABLE sysconfig_default_version (
    id NUMBER (12, 0) NOT NULL,
    sysconfig_default_id NUMBER (12, 0) NULL,
    name VARCHAR2 (250) NOT NULL,
    description CLOB NOT NULL,
    navigation VARCHAR2 (200) NOT NULL,
    is_invisible NUMBER (5, 0) NOT NULL,
    is_readonly NUMBER (5, 0) NOT NULL,
    is_required NUMBER (5, 0) NOT NULL,
    is_valid NUMBER (5, 0) NOT NULL,
    has_configlevel NUMBER (5, 0) NOT NULL,
    user_modification_possible NUMBER (5, 0) NOT NULL,
    user_modification_active NUMBER (5, 0) NOT NULL,
    user_preferences_group VARCHAR2 (250) NULL,
    xml_content_raw CLOB NOT NULL,
    xml_content_parsed CLOB NOT NULL,
    xml_filename VARCHAR2 (250) NOT NULL,
    effective_value CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE sysconfig_default_version ADD CONSTRAINT PK_sysconfig_default_version PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_sysconfig_default_version';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_sysconfig_default_version
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_sysconfig_default_version_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_sysconfig_default_version_t
BEFORE INSERT ON sysconfig_default_version
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_sysconfig_default_version.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
-- ----------------------------------------------------------
--  create table sysconfig_modified
-- ----------------------------------------------------------
CREATE TABLE sysconfig_modified (
    id NUMBER (12, 0) NOT NULL,
    sysconfig_default_id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (250) NOT NULL,
    user_id NUMBER (12, 0) NULL,
    is_valid NUMBER (5, 0) NOT NULL,
    user_modification_active NUMBER (5, 0) NOT NULL,
    effective_value CLOB NOT NULL,
    reset_to_default NUMBER (5, 0) NOT NULL,
    is_dirty NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT sysconfig_modified_per_user UNIQUE (sysconfig_default_id, user_id)
);
ALTER TABLE sysconfig_modified ADD CONSTRAINT PK_sysconfig_modified PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_sysconfig_modified';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_sysconfig_modified
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_sysconfig_modified_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_sysconfig_modified_t
BEFORE INSERT ON sysconfig_modified
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_sysconfig_modified.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
-- ----------------------------------------------------------
--  create table sysconfig_modified_version
-- ----------------------------------------------------------
CREATE TABLE sysconfig_modified_version (
    id NUMBER (12, 0) NOT NULL,
    sysconfig_default_version_id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (250) NOT NULL,
    user_id NUMBER (12, 0) NULL,
    is_valid NUMBER (5, 0) NOT NULL,
    user_modification_active NUMBER (5, 0) NOT NULL,
    effective_value CLOB NOT NULL,
    reset_to_default NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT PK_sysconfig_modified_version PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_sysconfig_modified_versf7';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_sysconfig_modified_versf7
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_sysconfig_modified_versf7_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_sysconfig_modified_versf7_t
BEFORE INSERT ON sysconfig_modified_version
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_sysconfig_modified_versf7.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
-- ----------------------------------------------------------
--  create table sysconfig_deployment_lock
-- ----------------------------------------------------------
CREATE TABLE sysconfig_deployment_lock (
    id NUMBER (12, 0) NOT NULL,
    exclusive_lock_guid VARCHAR2 (32) NULL,
    exclusive_lock_user_id NUMBER (12, 0) NULL,
    exclusive_lock_expiry_time DATE NULL
);
ALTER TABLE sysconfig_deployment_lock ADD CONSTRAINT PK_sysconfig_deployment_lock PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_sysconfig_deployment_lock';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_sysconfig_deployment_lock
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_sysconfig_deployment_lock_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_sysconfig_deployment_lock_t
BEFORE INSERT ON sysconfig_deployment_lock
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_sysconfig_deployment_lock.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
-- ----------------------------------------------------------
--  create table sysconfig_deployment
-- ----------------------------------------------------------
CREATE TABLE sysconfig_deployment (
    id NUMBER (12, 0) NOT NULL,
    comments VARCHAR2 (250) NULL,
    user_id NUMBER (12, 0) NULL,
    effective_value CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE sysconfig_deployment ADD CONSTRAINT PK_sysconfig_deployment PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_sysconfig_deployment';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_sysconfig_deployment
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_sysconfig_deployment_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_sysconfig_deployment_t
BEFORE INSERT ON sysconfig_deployment
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_sysconfig_deployment.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX dynamic_field_value_search_tbc ON dynamic_field_value (field_id, value_text)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE gi_webservice_config DROP CONSTRAINT gi_webservice_config_config_89;
-- ----------------------------------------------------------
--  alter table gi_webservice_config
-- ----------------------------------------------------------
ALTER TABLE gi_webservice_config DROP COLUMN config_md5;
ALTER TABLE cloud_service_config DROP CONSTRAINT cloud_service_config_config_39;
-- ----------------------------------------------------------
--  alter table cloud_service_config
-- ----------------------------------------------------------
ALTER TABLE cloud_service_config DROP COLUMN config_md5;
ALTER TABLE article ADD a_from_TEMP CLOB NULL;
UPDATE article SET a_from_TEMP = a_from;
ALTER TABLE article DROP COLUMN a_from;
ALTER TABLE article RENAME COLUMN a_from_TEMP TO a_from;
ALTER TABLE article ADD a_reply_to_TEMP CLOB NULL;
UPDATE article SET a_reply_to_TEMP = a_reply_to;
ALTER TABLE article DROP COLUMN a_reply_to;
ALTER TABLE article RENAME COLUMN a_reply_to_TEMP TO a_reply_to;
ALTER TABLE article ADD a_to_TEMP CLOB NULL;
UPDATE article SET a_to_TEMP = a_to;
ALTER TABLE article DROP COLUMN a_to;
ALTER TABLE article RENAME COLUMN a_to_TEMP TO a_to;
ALTER TABLE article ADD a_cc_TEMP CLOB NULL;
UPDATE article SET a_cc_TEMP = a_cc;
ALTER TABLE article DROP COLUMN a_cc;
ALTER TABLE article RENAME COLUMN a_cc_TEMP TO a_cc;
ALTER TABLE article ADD a_references_TEMP CLOB NULL;
UPDATE article SET a_references_TEMP = a_references;
ALTER TABLE article DROP COLUMN a_references;
ALTER TABLE article RENAME COLUMN a_references_TEMP TO a_references;
ALTER TABLE article ADD a_in_reply_to_TEMP CLOB NULL;
UPDATE article SET a_in_reply_to_TEMP = a_in_reply_to;
ALTER TABLE article DROP COLUMN a_in_reply_to;
ALTER TABLE article RENAME COLUMN a_in_reply_to_TEMP TO a_in_reply_to;
ALTER TABLE article ADD a_body_TEMP CLOB NULL;
UPDATE article SET a_body_TEMP = a_body;
ALTER TABLE article DROP COLUMN a_body;
ALTER TABLE article RENAME COLUMN a_body_TEMP TO a_body;
ALTER TABLE article_attachment ADD content_TEMP CLOB NULL;
UPDATE article_attachment SET content_TEMP = content;
ALTER TABLE article_attachment DROP COLUMN content;
ALTER TABLE article_attachment RENAME COLUMN content_TEMP TO content;
ALTER TABLE virtual_fs_db ADD content_TEMP CLOB NULL;
UPDATE virtual_fs_db SET content_TEMP = content;
ALTER TABLE virtual_fs_db DROP COLUMN content;
ALTER TABLE virtual_fs_db RENAME COLUMN content_TEMP TO content;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX ticket_history_article_id ON ticket_history (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  create table communication_channel
-- ----------------------------------------------------------
CREATE TABLE communication_channel (
    id NUMBER (20, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    module VARCHAR2 (200) NOT NULL,
    package_name VARCHAR2 (200) NOT NULL,
    channel_data CLOB NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT communication_channel_name UNIQUE (name)
);
ALTER TABLE communication_channel ADD CONSTRAINT PK_communication_channel PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_communication_channel';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_communication_channel
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_communication_channel_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_communication_channel_t
BEFORE INSERT ON communication_channel
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_communication_channel.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
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
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_valid_id';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article DROP CONSTRAINT FK_article_ticket_id_id;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_ticket_id';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article DROP CONSTRAINT FK_article_article_type_id_id;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_article_type_id';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article DROP CONSTRAINT FK_article_article_sender_ty29;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_article_sender_tycb';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article DROP CONSTRAINT FK_article_create_by_id;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_create_by';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article DROP CONSTRAINT FK_article_change_by_id;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_change_by';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
DROP INDEX article_ticket_id;
DROP INDEX article_article_type_id;
DROP INDEX article_article_sender_type_id;
DROP INDEX article_message_id_md5;
ALTER TABLE article_plain DROP CONSTRAINT FK_article_plain_article_id_id;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_plain_article_id';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article_plain DROP CONSTRAINT FK_article_plain_create_by_id;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_plain_create_by';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article_plain DROP CONSTRAINT FK_article_plain_change_by_id;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_plain_change_by';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
DROP INDEX article_plain_article_id;
ALTER TABLE article_attachment DROP CONSTRAINT FK_article_attachment_articlcc;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_attachment_articl37';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article_attachment DROP CONSTRAINT FK_article_attachment_create4a;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_attachment_create01';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article_attachment DROP CONSTRAINT FK_article_attachment_change59;
BEGIN
    EXECUTE IMMEDIATE 'DROP INDEX FK_article_attachment_change1e';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
DROP INDEX article_attachment_article_id;
-- ----------------------------------------------------------
--  alter table article_data_mime
-- ----------------------------------------------------------
ALTER TABLE article RENAME TO article_data_mime;
-- ----------------------------------------------------------
--  alter table article_data_mime
-- ----------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime RENAME CONSTRAINT PK_article TO PK_article_data_mime';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime
-- ----------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'ALTER INDEX PK_article RENAME TO PK_article_data_mime';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime
-- ----------------------------------------------------------
DECLARE
    sequence_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO sequence_count
    FROM user_sequences
    WHERE UPPER(sequence_name) = UPPER('SE_article');

    IF sequence_count > 0 THEN
        EXECUTE IMMEDIATE 'RENAME SE_article TO SE_article_data_mime';
    END IF;

EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime
-- ----------------------------------------------------------
DECLARE
    trigger_count NUMBER;
    pk_column_name VARCHAR(50);
BEGIN
    SELECT COUNT(*)
    INTO trigger_count
    FROM user_triggers
    WHERE UPPER(trigger_name) = UPPER('SE_article_t');

    SELECT column_name
    INTO pk_column_name
    FROM user_ind_columns
    WHERE UPPER(table_name) = UPPER('article_data_mime')
    AND UPPER(index_name) = UPPER('PK_article_data_mime');

    IF trigger_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER SE_article_t';

        EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER SE_article_data_mime_t
            BEFORE INSERT ON article_data_mime
            FOR EACH ROW
            BEGIN
                IF :new.' || pk_column_name || ' IS NULL THEN
                    SELECT SE_article_data_mime.nextval
                    INTO :new.' || pk_column_name || '
                    FROM DUAL;
                END IF;
            END;';
    END IF;

EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime_plain
-- ----------------------------------------------------------
ALTER TABLE article_plain RENAME TO article_data_mime_plain;
-- ----------------------------------------------------------
--  alter table article_data_mime_plain
-- ----------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime_plain RENAME CONSTRAINT PK_article_plain TO PK_article_data_mime_plain';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime_plain
-- ----------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'ALTER INDEX PK_article_plain RENAME TO PK_article_data_mime_plain';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime_plain
-- ----------------------------------------------------------
DECLARE
    sequence_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO sequence_count
    FROM user_sequences
    WHERE UPPER(sequence_name) = UPPER('SE_article_plain');

    IF sequence_count > 0 THEN
        EXECUTE IMMEDIATE 'RENAME SE_article_plain TO SE_article_data_mime_plain';
    END IF;

EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime_plain
-- ----------------------------------------------------------
DECLARE
    trigger_count NUMBER;
    pk_column_name VARCHAR(50);
BEGIN
    SELECT COUNT(*)
    INTO trigger_count
    FROM user_triggers
    WHERE UPPER(trigger_name) = UPPER('SE_article_plain_t');

    SELECT column_name
    INTO pk_column_name
    FROM user_ind_columns
    WHERE UPPER(table_name) = UPPER('article_data_mime_plain')
    AND UPPER(index_name) = UPPER('PK_article_data_mime_plain');

    IF trigger_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER SE_article_plain_t';

        EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER SE_article_data_mime_plain_t
            BEFORE INSERT ON article_data_mime_plain
            FOR EACH ROW
            BEGIN
                IF :new.' || pk_column_name || ' IS NULL THEN
                    SELECT SE_article_data_mime_plain.nextval
                    INTO :new.' || pk_column_name || '
                    FROM DUAL;
                END IF;
            END;';
    END IF;

EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime_attachment
-- ----------------------------------------------------------
ALTER TABLE article_attachment RENAME TO article_data_mime_attachment;
-- ----------------------------------------------------------
--  alter table article_data_mime_attachment
-- ----------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime_attachment RENAME CONSTRAINT PK_article_attachment TO PK_article_data_mime_attachmbb';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime_attachment
-- ----------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'ALTER INDEX PK_article_attachment RENAME TO PK_article_data_mime_attachmbb';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime_attachment
-- ----------------------------------------------------------
DECLARE
    sequence_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO sequence_count
    FROM user_sequences
    WHERE UPPER(sequence_name) = UPPER('SE_article_attachment');

    IF sequence_count > 0 THEN
        EXECUTE IMMEDIATE 'RENAME SE_article_attachment TO SE_article_data_mime_attac4b';
    END IF;

EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime_attachment
-- ----------------------------------------------------------
DECLARE
    trigger_count NUMBER;
    pk_column_name VARCHAR(50);
BEGIN
    SELECT COUNT(*)
    INTO trigger_count
    FROM user_triggers
    WHERE UPPER(trigger_name) = UPPER('SE_article_attachment_t');

    SELECT column_name
    INTO pk_column_name
    FROM user_ind_columns
    WHERE UPPER(table_name) = UPPER('article_data_mime_attachment')
    AND UPPER(index_name) = UPPER('PK_article_data_mime_attachmbb');

    IF trigger_count > 0 THEN
        EXECUTE IMMEDIATE 'DROP TRIGGER SE_article_attachment_t';

        EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER SE_article_data_mime_attac4b_t
            BEFORE INSERT ON article_data_mime_attachment
            FOR EACH ROW
            BEGIN
                IF :new.' || pk_column_name || ' IS NULL THEN
                    SELECT SE_article_data_mime_attac4b.nextval
                    INTO :new.' || pk_column_name || '
                    FROM DUAL;
                END IF;
            END;';
    END IF;

EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  create table article
-- ----------------------------------------------------------
CREATE TABLE article (
    id NUMBER (20, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_sender_type_id NUMBER (5, 0) NOT NULL,
    communication_channel_id NUMBER (20, 0) NOT NULL,
    is_visible_for_customer NUMBER (5, 0) NOT NULL,
    insert_fingerprint VARCHAR2 (64) NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE article ADD CONSTRAINT PK_article PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_article';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_article
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_article_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_article_t
BEFORE INSERT ON article
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_article.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX article_article_sender_type_id ON article (article_sender_type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX article_communication_channe74 ON article (communication_channel_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX article_ticket_id ON article (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table article_data_mime
-- ----------------------------------------------------------
ALTER TABLE article_data_mime ADD article_id NUMBER (20, 0) NULL;
UPDATE article_data_mime SET article_id = 0 WHERE article_id IS NULL;
ALTER TABLE article_data_mime MODIFY article_id NUMBER (20, 0) NOT NULL;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX ticket_history_article_id ON ticket_history (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_communication_channel_id NUMBER (20, 0) NULL;
-- ----------------------------------------------------------
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_sender_type_id NUMBER (5, 0) NULL;
-- ----------------------------------------------------------
--  alter table ticket_history
-- ----------------------------------------------------------
ALTER TABLE ticket_history ADD a_is_visible_for_customer NUMBER (5, 0) NULL;
ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_a_communicf7 FOREIGN KEY (a_communication_channel_id) REFERENCES communication_channel (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_a_communic6e ON ticket_history (a_communication_channel_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_a_sender_t5d FOREIGN KEY (a_sender_type_id) REFERENCES article_sender_type (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_a_sender_tbd ON ticket_history (a_sender_type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
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
    customer_id VARCHAR2 (150) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    permission_key VARCHAR2 (20) NOT NULL,
    permission_value NUMBER (5, 0) NOT NULL,
    permission_context VARCHAR2 (100) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX group_customer_customer_id ON group_customer (customer_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX group_customer_group_id ON group_customer (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  create table customer_user_customer
-- ----------------------------------------------------------
CREATE TABLE customer_user_customer (
    user_id VARCHAR2 (100) NOT NULL,
    customer_id VARCHAR2 (150) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX customer_user_customer_custo95 ON customer_user_customer (customer_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX customer_user_customer_user_id ON customer_user_customer (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  create table article_data_otrs_chat
-- ----------------------------------------------------------
CREATE TABLE article_data_otrs_chat (
    id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0) NOT NULL,
    chat_participant_id VARCHAR2 (255) NOT NULL,
    chat_participant_name VARCHAR2 (255) NOT NULL,
    chat_participant_type VARCHAR2 (255) NOT NULL,
    message_text VARCHAR2 (3800) NOT NULL,
    system_generated NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL
);
ALTER TABLE article_data_otrs_chat ADD CONSTRAINT PK_article_data_otrs_chat PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_article_data_otrs_chat';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_article_data_otrs_chat
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_article_data_otrs_chat_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_article_data_otrs_chat_t
BEFORE INSERT ON article_data_otrs_chat
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_article_data_otrs_chat.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX article_data_otrs_chat_artic16 ON article_data_otrs_chat (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
-- ----------------------------------------------------------
--  create table article_search_index
-- ----------------------------------------------------------
CREATE TABLE article_search_index (
    id NUMBER (20, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0) NOT NULL,
    article_key VARCHAR2 (200) NOT NULL,
    article_value CLOB NULL
);
ALTER TABLE article_search_index ADD CONSTRAINT PK_article_search_index PRIMARY KEY (id);
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_article_search_index';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE SEQUENCE SE_article_search_index
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER
;
BEGIN
    EXECUTE IMMEDIATE 'DROP TRIGGER SE_article_search_index_t';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
CREATE OR REPLACE TRIGGER SE_article_search_index_t
BEFORE INSERT ON article_search_index
FOR EACH ROW
BEGIN
    IF :new.id IS NULL THEN
        SELECT SE_article_search_index.nextval
        INTO :new.id
        FROM DUAL;
    END IF;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX article_search_index_article43 ON article_search_index (article_id, article_key)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX article_search_index_ticket_id ON article_search_index (ticket_id, article_key)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
DROP TABLE article_search CASCADE CONSTRAINTS;
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE SE_article_search';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE users MODIFY pw VARCHAR2 (128) DEFAULT NULL;
ALTER TABLE customer_user MODIFY pw VARCHAR2 (128) DEFAULT NULL;
SET DEFINE OFF;
SET SQLBLANKLINES ON;
ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_create_53 FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_create_by ON sysconfig_default (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_change_36 FOREIGN KEY (change_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_change_by ON sysconfig_default (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_exclusi7d FOREIGN KEY (exclusive_lock_user_id) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_exclusi26 ON sysconfig_default (exclusive_lock_user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version82 FOREIGN KEY (sysconfig_default_id) REFERENCES sysconfig_default (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_version51 ON sysconfig_default_version (sysconfig_default_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version1f FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_versionfa ON sysconfig_default_version (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_versiond1 FOREIGN KEY (change_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_version39 ON sysconfig_default_version (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_syscona0 FOREIGN KEY (sysconfig_default_id) REFERENCES sysconfig_default (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_syscon68 ON sysconfig_modified (sysconfig_default_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_user_iab FOREIGN KEY (user_id) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_user_id ON sysconfig_modified (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_create1b FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_createcf ON sysconfig_modified (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_change9c FOREIGN KEY (change_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_change22 ON sysconfig_modified (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_versioaf FOREIGN KEY (sysconfig_default_version_id) REFERENCES sysconfig_default_version (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_versioe7 ON sysconfig_modified_version (sysconfig_default_version_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_versiobb FOREIGN KEY (user_id) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_versio08 ON sysconfig_modified_version (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_versioc4 FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_versiofe ON sysconfig_modified_version (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_versio44 FOREIGN KEY (change_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_versio75 ON sysconfig_modified_version (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_deployment_lock ADD CONSTRAINT FK_sysconfig_deployment_lock49 FOREIGN KEY (exclusive_lock_user_id) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_deployment_lock70 ON sysconfig_deployment_lock (exclusive_lock_user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_deployment ADD CONSTRAINT FK_sysconfig_deployment_usereb FOREIGN KEY (user_id) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_deployment_user4a ON sysconfig_deployment (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE sysconfig_deployment ADD CONSTRAINT FK_sysconfig_deployment_creaf6 FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_deployment_creae5 ON sysconfig_deployment (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_crec7 FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_communication_channel_cre1a ON communication_channel (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_cha6b FOREIGN KEY (change_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_communication_channel_cha34 ON communication_channel (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_val71 FOREIGN KEY (valid_id) REFERENCES valid (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_communication_channel_val71 ON communication_channel (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article ADD CONSTRAINT FK_article_article_sender_ty29 FOREIGN KEY (article_sender_type_id) REFERENCES article_sender_type (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_article_sender_tycb ON article (article_sender_type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article ADD CONSTRAINT FK_article_communication_cha1c FOREIGN KEY (communication_channel_id) REFERENCES communication_channel (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_communication_cha7f ON article (communication_channel_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article ADD CONSTRAINT FK_article_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_ticket_id ON article (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article ADD CONSTRAINT FK_article_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_create_by ON article (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article ADD CONSTRAINT FK_article_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_change_by ON article (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_group_id ON group_customer (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_create_by ON group_customer (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_change_by ON group_customer (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_cr02 FOREIGN KEY (create_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_customer_user_customer_cr61 ON customer_user_customer (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_ch5b FOREIGN KEY (change_by) REFERENCES users (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_customer_user_customer_ch28 ON customer_user_customer (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article_data_otrs_chat ADD CONSTRAINT FK_article_data_otrs_chat_arcf FOREIGN KEY (article_id) REFERENCES article (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_otrs_chat_ar37 ON article_data_otrs_chat (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_artiea FOREIGN KEY (article_id) REFERENCES article (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_search_index_artie6 ON article_search_index (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_tickd8 FOREIGN KEY (ticket_id) REFERENCES ticket (id);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_search_index_tick1b ON article_search_index (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
