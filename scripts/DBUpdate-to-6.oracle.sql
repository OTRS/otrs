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
