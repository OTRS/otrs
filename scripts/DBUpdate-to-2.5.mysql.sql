# ----------------------------------------------------------
#  driver: mysql, generated: 2009-09-18 01:05:52
# ----------------------------------------------------------
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);
CREATE INDEX ticket_until_time ON ticket (until_time);
# ----------------------------------------------------------
#  create table virtual_fs
# ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL AUTO_INCREMENT,
    filename TEXT NOT NULL,
    backend VARCHAR (60) NOT NULL,
    backend_key VARCHAR (160) NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX virtual_fs_backend (backend(60)),
    INDEX virtual_fs_filename (filename(350))
);
# ----------------------------------------------------------
#  create table virtual_fs_preferences
# ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value TEXT NULL,
    INDEX virtual_fs_preferences_virtual_fs_id (virtual_fs_id)
);
# ----------------------------------------------------------
#  create table virtual_fs_db
# ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL AUTO_INCREMENT,
    filename TEXT NOT NULL,
    content LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX virtual_fs_db_filename (filename(350))
);
ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_virtual_fs_id_id FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id);
