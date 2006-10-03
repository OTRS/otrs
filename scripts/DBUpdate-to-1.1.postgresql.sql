-- --
-- Update an existing OTRS database from 1.0 to 1.1
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-1.1.postgresql.sql,v 1.12 2006-10-03 14:34:47 mh Exp $
-- --
--
-- usage: cat DBUpdate-to-1.1.postgresql.sql | psql otrs
--
-- --

--
-- drop not used ticket log types
--
DELETE FROM ticket_history_type WHERE name = 'WatingForClose+';
DELETE FROM ticket_history_type WHERE name = 'WatingForClose-';
DELETE FROM ticket_history_type WHERE name = 'WatingForReminder';
DELETE FROM ticket_history_type WHERE name = 'Open';
DELETE FROM ticket_history_type WHERE name = 'Reopen';
DELETE FROM ticket_history_type WHERE name = 'Close unsuccessful';
DELETE FROM ticket_history_type WHERE name = 'Close successful';
--DELETE FROM ticket_history_type WHERE name = '';
--
-- add ticket state update log type
--
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('StateUpdate', 1, 1, current_timestamp, 1, current_timestamp);
--
-- add ticket free text update log type
--
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('TicketFreeTextUpdate', 1, 1, current_timestamp, 1, current_timestamp);
--
-- added for customer notifications
--
ALTER TABLE queue ADD move_notify SMALLINT;
ALTER TABLE queue ADD lock_notify SMALLINT;
ALTER TABLE queue ADD state_notify SMALLINT;
ALTER TABLE queue ADD owner_notify SMALLINT;
--
-- added for customer notifications
--
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('SendCustomerNotification', 1, 1, current_timestamp, 1, current_timestamp);

--
-- add read/write options to group_user table
--
ALTER TABLE group_user ADD permission_read SMALLINT;
ALTER TABLE group_user ADD permission_write SMALLINT;
UPDATE group_user SET permission_read = 1, permission_write = 1 WHERE permission_read = 0 AND permission_write = 0;

--
-- add ticket_state_type table
--
CREATE TABLE ticket_state_type
(
    id serial,
    name VARCHAR (120) NOT NULL,
    comment VARCHAR (250),
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
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
ALTER TABLE ticket_state ADD type_id SMALLINT; -- NOT NULL;
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
