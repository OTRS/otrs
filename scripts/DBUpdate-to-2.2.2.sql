-- --
-- Update an existing OTRS database from 2.2.1 to 2.2.2
-- Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.2.2.sql,v 1.3 2008-04-24 11:47:39 tr Exp $
-- --
--
-- Example usage only for mysql and postgresql, SQL is also usable for
-- other databases.
--
-- usage mysql:      cat DBUpdate-to-2.2.2.sql | mysql -f -u root otrs
-- usage postgresql: cat DBUpdate-to-2.2.2.sql | psql otrs
--
-- --

ALTER TABLE ticket ADD escalation_response_time INTEGER;
ALTER TABLE ticket ADD escalation_solution_time INTEGER;

