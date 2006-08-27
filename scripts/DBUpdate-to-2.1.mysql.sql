-- --
-- Update an existing OTRS database from 2.0 to 2.1
-- Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-2.1.mysql.sql,v 1.7 2006-08-27 22:18:31 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-2.1.mysql.sql | mysql -f -u root otrs
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD responsible_user_id INTEGER NOT NULL;
ALTER TABLE ticket ADD freekey9 VARCHAR (80);
ALTER TABLE ticket ADD freetext9 VARCHAR (150);
ALTER TABLE ticket ADD freekey10 VARCHAR (80);
ALTER TABLE ticket ADD freetext10 VARCHAR (150);
ALTER TABLE ticket ADD freekey11 VARCHAR (80);
ALTER TABLE ticket ADD freetext11 VARCHAR (150);
ALTER TABLE ticket ADD freekey12 VARCHAR (80);
ALTER TABLE ticket ADD freetext12 VARCHAR (150);
ALTER TABLE ticket ADD freekey13 VARCHAR (80);
ALTER TABLE ticket ADD freetext13 VARCHAR (150);
ALTER TABLE ticket ADD freekey14 VARCHAR (80);
ALTER TABLE ticket ADD freetext14 VARCHAR (150);
ALTER TABLE ticket ADD freekey15 VARCHAR (80);
ALTER TABLE ticket ADD freetext15 VARCHAR (150);
ALTER TABLE ticket ADD freekey16 VARCHAR (80);
ALTER TABLE ticket ADD freetext16 VARCHAR (150);

INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('ResponsibleUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Subscribe', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Unsubscribe', 1, 1, current_timestamp, 1, current_timestamp);

CREATE TABLE ticket_watcher (
    ticket_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX ticket_id (ticket_id)
);

--
-- queue, add calendar
--
ALTER TABLE queue ADD calendar_name varchar (100);

--
-- change because of moduls like incident and IDMEFConsole
--
ALTER TABLE object_link MODIFY object_link_a_id VARCHAR (80);
ALTER TABLE object_link MODIFY object_link_b_id VARCHAR (80);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::ResponsibleUpdate', 'iso-8859-1', 'en', 'Ticket responsible assigned to you! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_RESPONSIBLE_USERFIRSTNAME>,

a ticket [<OTRS_TICKET_TicketNumber>] is assigned to you by "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>".

Comment:
<OTRS_COMMENT>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>

Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::ResponsibleUpdate', 'iso-8859-1', 'de', 'Ticket Verantwortung uebertragen an Sie! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_RESPONSIBLE_USERFIRSTNAME>,

die Verantwortung des Tickets [<OTRS_TICKET_TicketNumber>] wurde an Sie von "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" uebertragen.

Kommentar:
<OTRS_COMMENT>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>

Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

