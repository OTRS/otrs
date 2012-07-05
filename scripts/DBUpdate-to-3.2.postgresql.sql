-- ----------------------------------------------------------
--  driver: postgresql, generated: 2012-07-05 07:36:37
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP group_read;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP group_write;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP other_read;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP other_write;
DROP INDEX ticket_answered;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP ticket_answered;
DROP INDEX article_flag_create_by;
DROP INDEX article_flag_article_id_article_key;
DROP INDEX ticket_queue_view;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP group_id;
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
-- ----------------------------------------------------------
--  create table pm_process
-- ----------------------------------------------------------
CREATE TABLE pm_process (
    id serial NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    state_id INTEGER NOT NULL,
    layout TEXT NULL,
    config TEXT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_process_entity_id UNIQUE (entity_id)
);
-- ----------------------------------------------------------
--  create table pm_activity
-- ----------------------------------------------------------
CREATE TABLE pm_activity (
    id serial NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_activity_entity_id UNIQUE (entity_id)
);
SET standard_conforming_strings TO ON;
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
