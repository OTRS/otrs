-- --
-- Update an existing OTRS database from 1.2 to 1.3 
-- Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-1.3.postgresql.sql,v 1.1 2004-04-15 12:08:07 martin Exp $
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
DELETE FROM ticket_history_type WHERE name = 'SetPending';

--
-- add more attachment info
--
ALTER TABLE article_attachment ADD content_size VARCHAR (30);
