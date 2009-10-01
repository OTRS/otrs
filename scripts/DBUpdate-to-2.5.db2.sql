-- ----------------------------------------------------------
--  driver: db2, generated: 2009-10-01 10:44:02
-- ----------------------------------------------------------
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);

CREATE INDEX ticket_until_time ON ticket (until_time);

-- ----------------------------------------------------------
--  create table virtual_fs
-- ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    filename VARCHAR (350) NOT NULL,
    backend VARCHAR (60) NOT NULL,
    backend_key VARCHAR (160) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
);

CREATE INDEX virtual_fs_backend ON virtual_fs (backend);

CREATE INDEX virtual_fs_filename ON virtual_fs (filename);

-- ----------------------------------------------------------
--  create table virtual_fs_preferences
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (350)
);

CREATE INDEX virtual_fs_preferences_virtualf6 ON virtual_fs_preferences (virtual_fs_id);

-- ----------------------------------------------------------
--  create table virtual_fs_db
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1),
    filename VARCHAR (350) NOT NULL,
    content BLOB (30M) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    PRIMARY KEY(id)
);

CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);

SET INTEGRITY FOR customer_user OFF;

-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN title VARCHAR (50) GENERATED ALWAYS AS (salutation);

SET INTEGRITY FOR customer_user IMMEDIATE CHECKED FORCE GENERATED;

-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ALTER title DROP EXPRESSION;

-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user DROP COLUMN salutation;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN title SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

ALTER TABLE customer_user ALTER COLUMN title DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE customer_user');

SET INTEGRITY FOR users OFF;

-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users ADD COLUMN title VARCHAR (50) GENERATED ALWAYS AS (salutation);

SET INTEGRITY FOR users IMMEDIATE CHECKED FORCE GENERATED;

-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users ALTER title DROP EXPRESSION;

-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users DROP COLUMN salutation;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

ALTER TABLE users ALTER COLUMN title SET DEFAULT '';

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

ALTER TABLE users ALTER COLUMN title DROP DEFAULT;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE users');

ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_virtual_fs_id_id FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id);
