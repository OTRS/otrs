-- --
-- Update an existing OTRS database from 1.3 to 2.0
-- Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-2.0.mysql.sql,v 1.6 2004-10-01 08:53:31 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-2.0.mysql.sql | mysql -f -u root otrs
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
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);

--
-- roles
--
CREATE TABLE roles
(
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
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
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);

--
-- improve ticket table
--
ALTER TABLE ticket ADD escalation_start_time INTEGER;
UPDATE ticket SET escalation_start_time = 0 WHERE escalation_start_time IS NULL;
ALTER TABLE ticket CHANGE escalation_start_time escalation_start_time INTEGER NOT NULL;

--
-- improve search profile table
--
ALTER TABLE search_profile ADD profile_type VARCHAR (30);
UPDATE search_profile SET profile_type='TicketSearch' WHERE profile_type IS NULL ;
ALTER TABLE search_profile CHANGE profile_type profile_type VARCHAR (30) NOT NULL;

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

--
-- fix for wrong saluation
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::NewTicket', 'iso-8859-1', 'en', 'New ticket notification! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,there is a new ticket in "<OTRS_QUEUE>"!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

