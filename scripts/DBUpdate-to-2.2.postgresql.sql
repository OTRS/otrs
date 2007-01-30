-- --
-- Update an existing OTRS database from 2.1 to 2.2
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.2.postgresql.sql,v 1.3 2007-01-30 19:58:24 mh Exp $
-- --
--
-- usage: cat DBUpdate-to-2.2.postgresql.sql | psql otrs
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD freetime3 timestamp(0);
ALTER TABLE ticket ADD freetime4 timestamp(0);
ALTER TABLE ticket ADD freetime5 timestamp(0);
ALTER TABLE ticket ADD freetime6 timestamp(0);

--
-- ticket_priority
--
ALTER TABLE ticket_priority ADD valid_id SMALLINT NOT NULL DEFAULT 1;
UPDATE ticket_priority SET valid_id = 1;

