-- ----------------------------------------------------------
--  driver: oracle, generated: 2009-09-18 01:05:52
-- ----------------------------------------------------------
SET DEFINE OFF;
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);
CREATE INDEX ticket_until_time ON ticket (until_time);
-- ----------------------------------------------------------
--  create table virtual_fs
-- ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id NUMBER (20, 0) NOT NULL,
    filename VARCHAR2 (350) NOT NULL,
    backend VARCHAR2 (60) NOT NULL,
    backend_key VARCHAR2 (160) NOT NULL,
    create_time DATE NOT NULL
);
ALTER TABLE virtual_fs ADD CONSTRAINT PK_virtual_fs PRIMARY KEY (id);
DROP SEQUENCE SE_virtual_fs;
CREATE SEQUENCE SE_virtual_fs;
CREATE OR REPLACE TRIGGER SE_virtual_fs_t
before insert on virtual_fs
for each row
begin
  if :new.id IS NULL then
    select SE_virtual_fs.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX virtual_fs_backend ON virtual_fs (backend);
CREATE INDEX virtual_fs_filename ON virtual_fs (filename);
-- ----------------------------------------------------------
--  create table virtual_fs_preferences
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id NUMBER (20, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (350) NULL
);
CREATE INDEX virtual_fs_preferences_virtuf6 ON virtual_fs_preferences (virtual_fs_id);
-- ----------------------------------------------------------
--  create table virtual_fs_db
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id NUMBER (20, 0) NOT NULL,
    filename VARCHAR2 (350) NOT NULL,
    content CLOB NOT NULL,
    create_time DATE NOT NULL
);
ALTER TABLE virtual_fs_db ADD CONSTRAINT PK_virtual_fs_db PRIMARY KEY (id);
DROP SEQUENCE SE_virtual_fs_db;
CREATE SEQUENCE SE_virtual_fs_db;
CREATE OR REPLACE TRIGGER SE_virtual_fs_db_t
before insert on virtual_fs_db
for each row
begin
  if :new.id IS NULL then
    select SE_virtual_fs_db.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);
SET DEFINE OFF;
ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_vib1 FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id);
