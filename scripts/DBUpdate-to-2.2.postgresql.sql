-- --
-- Update an existing OTRS database from 2.1 to 2.2
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.2.postgresql.sql,v 1.1 2007-01-30 09:47:47 mh Exp $
-- --
--
-- usage: cat DBUpdate-to-2.2.postgresql.sql | psql otrs
--
-- --

--
-- ticket_priority
--
ALTER TABLE ticket_priority ADD valid_id SMALLINT NOT NULL DEFAULT 1;
