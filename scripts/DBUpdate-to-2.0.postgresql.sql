-- --
-- Update an existing OTRS database from 1.3 to 2.0
-- Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-2.0.postgresql.sql,v 1.5 2004-09-29 09:50:01 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-2.0.postgresql.sql | mysql -f -u root otrs
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD title varchar (255);

--
-- object_link
--
CREATE TABLE object_link
(
    object_link_a_id BIGINT NOT NULL,
    object_link_b_id BIGINT NOT NULL,
    object_link_a_object VARCHAR (200) NOT NULL,
    object_link_b_object VARCHAR (200) NOT NULL,
    object_link_type VARCHAR (200) NOT NULL
);

--
-- group_role
--
CREATE TABLE group_role
(
    role_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20),
    permission_value SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);

--
-- roles
--
CREATE TABLE roles
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

--
-- role_user
--
CREATE TABLE role_user
(
    role_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);

--
-- improve search profile table
--
ALTER TABLE search_profile ADD profile_type VARCHAR (30);
UPDATE search_profile SET profile_type='TicketSearch' where profile_type IS NULL ;
ALTER TABLE search_profile ALTER profile_type SET NOT NULL;

--
-- process_id
--
CREATE TABLE process_id
(
    process_name varchar (200) NOT NULL,
    process_id varchar (200) NOT NULL,
    process_host varchar (200) NOT NULL,
    process_create integer NOT NULL
);

