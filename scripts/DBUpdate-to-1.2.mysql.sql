-- --
-- Update an existing OTRS database from 1.1 to 1.2 
-- Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-1.2.mysql.sql,v 1.2 2003-11-19 01:32:04 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-1.1.mysql.sql | mysql -f -u root otrs
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
-- add move/create/owner/priority/state options to group_user table
--
ALTER TABLE group_user ADD permission_move SMALLINT NOT NULL;
ALTER TABLE group_user ADD permission_create SMALLINT NOT NULL;
ALTER TABLE group_user ADD permission_owner SMALLINT NOT NULL;
ALTER TABLE group_user ADD permission_priority SMALLINT NOT NULL;
ALTER TABLE group_user ADD permission_state SMALLINT NOT NULL;

