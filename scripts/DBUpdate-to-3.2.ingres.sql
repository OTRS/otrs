-- ----------------------------------------------------------
--  driver: ingres, generated: 2012-07-05 07:36:37
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_read RESTRICT;\g
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_write RESTRICT;\g
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN other_read RESTRICT;\g
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN other_write RESTRICT;\g
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN ticket_answered RESTRICT;\g
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_id RESTRICT;\g
CREATE SEQUENCE pm_process_886;\g
CREATE TABLE pm_process (
    id INTEGER NOT NULL DEFAULT pm_process_886.NEXTVAL,
    entity_id VARCHAR(50) NOT NULL,
    name VARCHAR(200) NOT NULL,
    state_id SMALLINT NOT NULL,
    layout LONG BYTE,
    config LONG BYTE,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (entity_id)
);\g
MODIFY pm_process TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE pm_process ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE pm_activity_162;\g
CREATE TABLE pm_activity (
    id INTEGER NOT NULL DEFAULT pm_activity_162.NEXTVAL,
    entity_id VARCHAR(50) NOT NULL,
    name VARCHAR(200) NOT NULL,
    config LONG BYTE,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (entity_id)
);\g
MODIFY pm_activity TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE pm_activity ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
ALTER TABLE pm_process ADD FOREIGN KEY (create_by) REFERENCES users(id);\g
ALTER TABLE pm_process ADD FOREIGN KEY (change_by) REFERENCES users(id);\g
ALTER TABLE pm_activity ADD FOREIGN KEY (create_by) REFERENCES users(id);\g
ALTER TABLE pm_activity ADD FOREIGN KEY (change_by) REFERENCES users(id);\g
