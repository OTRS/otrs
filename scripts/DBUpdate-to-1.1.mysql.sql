-- --
-- Update an existing OTRS database from 1.0 to 1.1 
-- Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-1.1.mysql.sql,v 1.5 2003-03-08 17:58:00 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-1.1.mysql.sql | mysql -f -u root otrs
--
-- --

--
-- add read/write options to group_user table
--
ALTER TABLE group_user ADD permission_read SMALLINT NOT NULL;
ALTER TABLE group_user ADD permission_write SMALLINT NOT NULL;

-- 
-- add ticket_state_type table
--
CREATE TABLE ticket_state_type
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (120) NOT NULL,
    comment VARCHAR (250),
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);  
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('new', 'all new state types (default: viewable)', 1, current_timestamp, 1, current_timestamp); 
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('open', 'all open state types (default: viewable)', 1, current_timestamp, 1, current_timestamp); 
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('closed', 'all closed state types (default: not viewable)', 1, current_timestamp, 1, current_timestamp); 
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('pending reminder', 'all "pending reminder" state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('pending auto', 'all "pending auto *" state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('removed', 'all "removed" state types (default: not viewable)', 1, current_timestamp, 1, current_timestamp);
--
-- add ticket_state_type to ticket_state
--
ALTER TABLE ticket_state ADD type_id SMALLINT NOT NULL;
-- 
-- update ticket_state table
--
UPDATE ticket_state SET type_id = 1 WHERE name = 'new';
UPDATE ticket_state SET type_id = 2 WHERE name = 'open';
UPDATE ticket_state SET type_id = 3 WHERE name = 'closed successful';
UPDATE ticket_state SET type_id = 3 WHERE name = 'closed unsuccessful';
UPDATE ticket_state SET type_id = 6 WHERE name = 'removed';
UPDATE ticket_state SET type_id = 4 WHERE name = 'pending reminder';
UPDATE ticket_state SET type_id = 5 WHERE name = 'pending auto close+';
UPDATE ticket_state SET type_id = 5 WHERE name = 'pending auto close-';
-- 
-- delete not needed queue (important for sub queue)
--
DELETE FROM queue WHERE name = '';
--
-- modify table ticket
--
ALTER TABLE ticket ADD customer_user_id VARCHAR (250); 
-- 
-- updated priority states
--
UPDATE ticket_priority SET name = '1 very low' WHERE name = 'very low';
UPDATE ticket_priority SET name = '2 low' WHERE name = 'low';
UPDATE ticket_priority SET name = '3 normal' WHERE name = 'normal';
UPDATE ticket_priority SET name = '4 high' WHERE name = 'high';
UPDATE ticket_priority SET name = '5 very high' WHERE name = 'very high';
