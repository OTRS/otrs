-- --
-- Update an existing OTRS database from 2.2.1 to 2.2.2
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.2.2.sql,v 1.1 2007-07-31 11:55:29 martin Exp $
-- --
--
-- usage mysql:      cat DBUpdate-to-2.2.2.sql | mysql -f -u root otrs
-- usage postgresql: cat DBUpdate-to-2.2.2.sql | psql otrs
--
-- --

ALTER TABLE queue ADD first_response_time INTEGER;
ALTER TABLE queue ADD solution_time INTEGER;

