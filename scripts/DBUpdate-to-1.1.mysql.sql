-- --
-- Update an existing OTRS database from 1.0 to 1.1 
-- Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-1.1.mysql.sql,v 1.2 2003-02-25 18:48:28 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-1.1.mysql.sql | mysql -f -u root otrs
--
-- --

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
