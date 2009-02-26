-- --
-- Update an existing OTRS database from 1.2 to 1.3
-- Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
-- --
-- $Id: DBUpdate-to-1.3.mysql.sql,v 1.17 2009-02-26 11:10:53 tr Exp $
-- --
--
-- usage: cat DBUpdate-to-1.3.mysql.sql | mysql -f -u root otrs
--
-- --

--
-- drop not used ticket log types
--
DELETE FROM ticket_history_type WHERE name = 'WatingForClose+';
DELETE FROM ticket_history_type WHERE name = 'WatingForClose-';
DELETE FROM ticket_history_type WHERE name = 'WatingForReminder';
DELETE FROM ticket_history_type WHERE name = 'Open';
DELETE FROM ticket_history_type WHERE name = 'Reopen';
DELETE FROM ticket_history_type WHERE name = 'Close unsuccessful';
DELETE FROM ticket_history_type WHERE name = 'Close successful';
DELETE FROM ticket_history_type WHERE name = 'SetPending';

--
-- new ticket history stuff
--
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TicketLinkAdd', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TicketLinkDelete', 1, 1, current_timestamp, 1, current_timestamp);

--
-- alter article table (just a bug in mysql script!)
--
ALTER TABLE article CHANGE ticket_id ticket_id BIGINT;

--
-- add more attachment info
--
ALTER TABLE article_attachment ADD content_size VARCHAR (30);


--
-- change max customer user login size
--
ALTER TABLE group_customer_user CHANGE user_id user_id VARCHAR (100);

--
-- postmaster filter table
--
CREATE TABLE postmaster_filter
(
    f_name varchar (200) NOT NULL,
    f_type varchar (20) NOT NULL,
    f_key varchar (200) NOT NULL,
    f_value varchar (200) NOT NULL
);

--
-- generic_agent_jobs
--
CREATE TABLE generic_agent_jobs
(
    job_name varchar (200) NOT NULL,
    job_key varchar (200) NOT NULL,
    job_value varchar (200) NOT NULL
);

--
-- change size for message id
--
ALTER TABLE article CHANGE a_message_id a_message_id MEDIUMTEXT;

--
-- index for message id
--
ALTER TABLE article ADD INDEX article_message_id (a_message_id(255));

--
-- ticket_history
--
ALTER TABLE ticket_history CHANGE system_queue_id queue_id INTEGER NOT NULL;
ALTER TABLE ticket_history ADD owner_id INTEGER NOT NULL;
ALTER TABLE ticket_history ADD priority_id SMALLINT NOT NULL;
ALTER TABLE ticket_history ADD state_id SMALLINT NOT NULL;

--
-- queue, add default sign key option
--
ALTER TABLE queue ADD default_sign_key varchar (100);

--
-- customer notifications (en)
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::QueueUpdate', 'iso-8859-1', 'en', 'New Queue "<OTRS_CUSTOMER_Queue>"!', '*** THIS IS JUST A NOTE ***

The queue of your ticket "<OTRS_TICKET_NUMBER>" has been changed by
"<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>" to "<OTRS_CUSTOMER_Queue>".

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

*** THIS IS JUST A NOTE ***
', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::OwnerUpdate', 'iso-8859-1', 'en', 'New Owner "<OTRS_CUSTOMER_UserFirstname>"!', '*** THIS IS JUST A NOTE ***

The owner of your ticket "<OTRS_TICKET_NUMBER>" has been changed to
"<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

*** THIS IS JUST A NOTE ***
', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::StateUpdate', 'iso-8859-1', 'en', 'New State "<OTRS_CUSTOMER_State>"!', '*** THIS IS JUST A NOTE ***

The state of your ticket "<OTRS_TICKET_NUMBER>" has been changed by
"<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>" to "<OTRS_CUSTOMER_State>".

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Your OTRS Notification Master

*** THIS IS JUST A NOTE ***
', current_timestamp, 1, current_timestamp, 1);

--
-- customer notifications (de)
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::QueueUpdate', 'iso-8859-1', 'de', 'Neue Queue "<OTRS_CUSTOMER_Queue>"!', '*** NUR EINE INFO ***

Die Queue Ihres Tickets "<OTRS_TICKET_NUMBER>" hat
"<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>" auf "<OTRS_CUSTOMER_Queue>" geaendert.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Dein OTRS Benachrichtigungs-Master

*** NUR EINE INFO ***
', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::OwnerUpdate', 'iso-8859-1', 'de', 'Neuer Besitzer "<OTRS_CUSTOMER_UserFirstname>"!', '*** NUR EINE INFO ***

Der Besitzer des Tickets "<OTRS_TICKET_NUMBER>" hat sich auf
"<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname> geaendert.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Dein OTRS Benachrichtigungs-Master

*** NUR EINE INFO ***
', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::StateUpdate', 'iso-8859-1', 'de', 'Neuer Status "<OTRS_CUSTOMER_State>"!', '*** NUR EINE INFO ***

Der Status des Tickets "<OTRS_TICKET_NUMBER>" hat sich durch
"<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>" auf "<OTRS_CUSTOMER_State>" veraendert.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_ID>

Dein OTRS Benachrichtigungs-Master

*** NUR EINE INFO ***
', current_timestamp, 1, current_timestamp, 1);
