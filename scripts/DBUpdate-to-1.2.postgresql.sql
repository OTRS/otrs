-- --
-- Update an existing OTRS database from 1.1 to 1.2 
-- Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-1.2.postgresql.sql,v 1.3 2003-11-20 22:03:26 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-1.1.postgresql.sql | psql otrs 
--
-- --

--
-- for new user serach profiles
--
CREATE TABLE search_profile
(
    login varchar (200) NOT NULL,
    profile_name varchar (200) NOT NULL,
    profile_key varchar (200) NOT NULL,
    profile_value varchar (200) NOT NULL
);

--
-- add move/create/owner/priority/... options to group_user table
--
ALTER TABLE group_user ADD permission_key VARCHAR (20);
ALTER TABLE group_user ADD permission_value SMALLINT NOT NULL;

UPDATE group_user SET permission_key = 'ro', permission_value = 1 WHERE permission_read = 1;
UPDATE group_user SET permission_key = 'rw', permission_value = 1 WHERE permission_write = 1;
UPDATE group_user SET permission_key = 'rw', permission_value = 1 WHERE permission_write = 0 and permission_read = 0;

ALTER TABLE group_user DROP permission_read;
ALTER TABLE group_user DROP permission_write;

