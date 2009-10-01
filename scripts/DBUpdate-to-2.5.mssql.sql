-- ----------------------------------------------------------
--  driver: mssql, generated: 2009-10-01 10:44:02
-- ----------------------------------------------------------
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);
CREATE INDEX ticket_until_time ON ticket (until_time);
-- ----------------------------------------------------------
--  create table virtual_fs
-- ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    filename VARCHAR (350) NOT NULL,
    backend VARCHAR (60) NOT NULL,
    backend_key VARCHAR (160) NOT NULL,
    create_time DATETIME NOT NULL,
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
    preferences_value VARCHAR (350) NULL
);
CREATE INDEX virtual_fs_preferences_virtual_fs_id ON virtual_fs_preferences (virtual_fs_id);
-- ----------------------------------------------------------
--  create table virtual_fs_db
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    filename VARCHAR (350) NOT NULL,
    content TEXT NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);
GO
EXECUTE sp_rename N'customer_user.salutation', N'title', 'COLUMN';
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_customer_user_title' )
ALTER TABLE customer_user DROP CONSTRAINT DF_customer_user_title;
GO
EXECUTE sp_rename N'users.salutation', N'title', 'COLUMN';
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'DF_users_title' )
ALTER TABLE users DROP CONSTRAINT DF_users_title;
ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_virtual_fs_id_id FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id);
