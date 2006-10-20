-- --
-- Update an existing OTRS database from 2.0 to 2.1
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.1.postgresql.sql,v 1.15 2006-10-20 14:02:12 rk Exp $
-- --
--
-- usage: cat DBUpdate-to-2.1.postgresql.sql | psql otrs
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD responsible_user_id INTEGER NOT NULL DEFAULT 1;
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

--
-- queue, add calendar
--
ALTER TABLE queue ADD COLUMN calendar_name varchar (100);


CREATE TABLE ticket_watcher (
    ticket_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
CREATE INDEX ticket_id ON ticket_watcher (ticket_id);

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

--
-- change to support char keys (not only integer)
--
ALTER TABLE object_link RENAME TO object_link_old;
CREATE TABLE object_link (
    object_link_a_id VARCHAR (80) NOT NULL,
    object_link_b_id VARCHAR (80) NOT NULL,
    object_link_a_object VARCHAR (200) NOT NULL,
    object_link_b_object VARCHAR (200) NOT NULL,
    object_link_type VARCHAR (200) NOT NULL
);
INSERT INTO object_link (
     object_link_a_id,
     object_link_b_id,
     object_link_a_object,
     object_link_b_object,
     object_link_type)
SELECT
     object_link_a_id,
     object_link_b_id,
     object_link_a_object,
     object_link_b_object,
     object_link_type
FROM object_link_old;
DROP TABLE object_link_old;

--
-- faq
--


CREATE TABLE faq_voting (
    id serial,
    created_by VARCHAR (200) NOT NULL,
    item_id INTEGER NOT NULL,
    interface VARCHAR (80),
    ip VARCHAR (50),
    rate INTEGER NOT NULL,
    created timestamp(0),
    PRIMARY KEY(id)
);

ALTER TABLE faq_category ADD parent_id INTEGER;
ALTER TABLE faq_category ADD valid_id INTEGER;

UPDATE faq_category SET parent_id = 0;
UPDATE faq_category SET valid_id = 1;

ALTER TABLE faq_category RENAME create_time TO created;
ALTER TABLE faq_category RENAME change_time TO changed;
ALTER TABLE faq_category RENAME create_by TO created_by;
ALTER TABLE faq_category RENAME change_by TO changed_by;

ALTER TABLE faq_history RENAME create_time TO created;
ALTER TABLE faq_history RENAME change_time TO changed;
ALTER TABLE faq_history RENAME create_by TO created_by;
ALTER TABLE faq_history RENAME change_by TO changed_by;

ALTER TABLE faq_item RENAME create_time TO created;
ALTER TABLE faq_item RENAME change_time TO changed;
ALTER TABLE faq_item RENAME create_by TO created_by;
ALTER TABLE faq_item RENAME change_by TO changed_by;

ALTER TABLE faq_attachment RENAME create_time TO created;
ALTER TABLE faq_attachment RENAME change_time TO changed;
ALTER TABLE faq_attachment RENAME create_by TO created_by;
ALTER TABLE faq_attachment RENAME change_by TO changed_by;



