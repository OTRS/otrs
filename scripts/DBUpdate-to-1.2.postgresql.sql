-- --
-- Update an existing OTRS database from 1.1 to 1.2 
-- Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-1.2.postgresql.sql,v 1.5 2003-12-15 20:26:50 martin Exp $
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

--
-- create customer user <-> group relation
--
CREATE TABLE group_customer_user
(
    user_id integer NOT NULL,
    group_id integer NOT NULL,
    permission_key VARCHAR (20),
    permission_value SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL
);

--
-- add more free text col. to ticket table 
--
ALTER TABLE ticket ADD freekey3 VARCHAR (80);
ALTER TABLE ticket ADD freetext3 VARCHAR (150);
ALTER TABLE ticket ADD freekey4 VARCHAR (80);
ALTER TABLE ticket ADD freetext4 VARCHAR (150);
ALTER TABLE ticket ADD freekey5 VARCHAR (80);
ALTER TABLE ticket ADD freetext5 VARCHAR (150);
ALTER TABLE ticket ADD freekey6 VARCHAR (80);
ALTER TABLE ticket ADD freetext6 VARCHAR (150);
ALTER TABLE ticket ADD freekey7 VARCHAR (80);
ALTER TABLE ticket ADD freetext7 VARCHAR (150);
ALTER TABLE ticket ADD freekey8 VARCHAR (80);
ALTER TABLE ticket ADD freetext8 VARCHAR (150);

