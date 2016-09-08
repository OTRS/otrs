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
--;
CREATE SEQUENCE SE_dynamic_field_obj_id_name
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
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
--;
CREATE INDEX dynamic_field_value_search_tbc ON dynamic_field_value (field_id, value_text);
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
SET DEFINE OFF;
SET SQLBLANKLINES ON;
