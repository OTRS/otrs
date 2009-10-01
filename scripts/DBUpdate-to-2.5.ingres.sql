-- ----------------------------------------------------------
--  driver: ingres, generated: 2009-10-01 10:44:02
-- ----------------------------------------------------------
CREATE SEQUENCE virtual_fs_670;\g
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL DEFAULT virtual_fs_670.NEXTVAL,
    filename VARCHAR(350) NOT NULL,
    backend VARCHAR(60) NOT NULL,
    backend_key VARCHAR(160) NOT NULL,
    create_time TIMESTAMP NOT NULL
);\g
MODIFY virtual_fs TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE virtual_fs ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX virtual_fs_filename ON virtual_fs (filename);\g
CREATE INDEX virtual_fs_backend ON virtual_fs (backend);\g
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(350)
);\g
MODIFY virtual_fs_preferences TO btree;\g
CREATE INDEX virtual_fs_preferences_virtual_fs_id ON virtual_fs_preferences (virtual_fs_id);\g
CREATE SEQUENCE virtual_fs_db_752;\g
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL DEFAULT virtual_fs_db_752.NEXTVAL,
    filename VARCHAR(350) NOT NULL,
    content LONG BYTE NOT NULL,
    create_time TIMESTAMP NOT NULL
);\g
MODIFY virtual_fs_db TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE virtual_fs_db ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user ADD COLUMN title VARCHAR(50);\g
UPDATE customer_user SET title = salutation WHERE 1=1;\g
-- ----------------------------------------------------------
--  alter table customer_user
-- ----------------------------------------------------------
ALTER TABLE customer_user DROP COLUMN salutation RESTRICT;\g
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users ADD COLUMN title VARCHAR(50);\g
UPDATE users SET title = salutation WHERE 1=1;\g
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE users DROP COLUMN salutation RESTRICT;\g
ALTER TABLE virtual_fs_preferences ADD FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs(id);\g
