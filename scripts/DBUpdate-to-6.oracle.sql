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
SET DEFINE OFF;
SET SQLBLANKLINES ON;
