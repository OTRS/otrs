-- ----------------------------------------------------------
--  driver: ingres, generated: 2009-09-18 01:05:52
-- ----------------------------------------------------------
CREATE SEQUENCE virtual_fs_258;\g
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL DEFAULT virtual_fs_258.NEXTVAL,
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
CREATE SEQUENCE virtual_fs_db_91;\g
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL DEFAULT virtual_fs_db_91.NEXTVAL,
    filename VARCHAR(350) NOT NULL,
    content LONG BYTE NOT NULL,
    create_time TIMESTAMP NOT NULL
);\g
MODIFY virtual_fs_db TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE virtual_fs_db ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);\g
ALTER TABLE virtual_fs_preferences ADD FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs(id);\g
