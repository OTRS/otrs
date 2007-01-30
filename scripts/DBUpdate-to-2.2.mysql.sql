-- --
-- Update an existing OTRS database from 2.1 to 2.2
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.2.mysql.sql,v 1.3 2007-01-30 19:58:24 mh Exp $
-- --
--
-- usage: cat DBUpdate-to-2.2.mysql.sql | mysql -f -u root otrs
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD freetime3 DATETIME;
ALTER TABLE ticket ADD freetime4 DATETIME;
ALTER TABLE ticket ADD freetime5 DATETIME;
ALTER TABLE ticket ADD freetime6 DATETIME;

--
-- ticket_priority
--
ALTER TABLE ticket_priority ADD valid_id SMALLINT NOT NULL;
UPDATE ticket_priority SET valid_id = 1;

