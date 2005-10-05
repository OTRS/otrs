-- --
-- Update an existing OTRS database from 1.1 to 1.2
-- Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-1.2.postgresql.sql,v 1.16 2005-10-05 23:47:34 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-1.1.postgresql.sql | psql otrs
--
-- --

--
-- new ticket history stuff
--
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('EmailAgent', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('EmailCustomer', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('WebRequestCustomer', 1, 1, current_timestamp, 1, current_timestamp);

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
-- ticket link table
--
CREATE TABLE ticket_link
(
    ticket_id_master serial NOT NULL,
    ticket_id_slave serial NOT NULL
);

--
-- add move/create/owner/priority/... options to group_user table
--
ALTER TABLE group_user ADD permission_key VARCHAR (20);
ALTER TABLE group_user ADD permission_value SMALLINT;
UPDATE group_user SET permission_value = 0;
ALTER TABLE group_user ALTER COLUMN permission_value SET NOT NULL;

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
    user_id VARCHAR (40) NOT NULL,
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

--
-- faq stuff
--
INSERT INTO groups
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('faq',  1, 1, current_timestamp, 1, current_timestamp);

CREATE TABLE faq_item
(
    id serial,
    f_name VARCHAR (200) NOT NULL,
    f_language_id SMALLINT NOT NULL,
    f_subject VARCHAR (200),
    state_id SMALLINT NOT NULL,
    category_id SMALLINT NOT NULL,
    f_keywords TEXT,
    f_field1 TEXT,
    f_field2 TEXT,
    f_field3 TEXT,
    f_field4 TEXT,
    f_field5 TEXT,
    f_field6 TEXT,
    free_key1 VARCHAR (80),
    free_value1 VARCHAR (200),
    free_key2 VARCHAR (80),
    free_value2 VARCHAR (200),
    free_key3 VARCHAR (80),
    free_value3 VARCHAR (200),
    free_key4 VARCHAR (80),
    free_value4 VARCHAR (200),
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (f_name)
);

CREATE TABLE faq_language
(
    id serial,
    name VARCHAR (200) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

CREATE TABLE faq_history
(
    id serial,
    name VARCHAR (200) NOT NULL,
    item_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE faq_category
(
    id serial,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (220) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

CREATE TABLE faq_state
(
    id serial,
    name VARCHAR (200) NOT NULL,
    type_id INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

CREATE TABLE faq_state_type
(
    id serial,
    name VARCHAR (200) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

INSERT INTO faq_item
  (f_name, f_language_id, f_subject, state_id, category_id, f_field1, f_field2, f_field3, create_time, create_by, change_time, change_by)
  VALUES
  ('welcome', 1, 'Welcome!', 1, 1, 'symptom...', 'problem...', 'solution...', current_timestamp, 1, current_timestamp, 1);

INSERT INTO faq_history
  (name, item_id, create_time, create_by, change_time, change_by)
  VALUES
  ('Created', 1, current_timestamp, 1, current_timestamp, 1);

INSERT INTO faq_language (name) VALUES ('en');
INSERT INTO faq_language (name) VALUES ('de');
INSERT INTO faq_language (name) VALUES ('es');
INSERT INTO faq_language (name) VALUES ('fr');

INSERT INTO faq_category
  (name, comments, create_time, create_by, change_time, change_by)
  VALUES
  ('all', 'default category', current_timestamp, 1, current_timestamp, 1);

INSERT INTO faq_state (name, type_id) VALUES ('internal (agent)', 1);
INSERT INTO faq_state (name, type_id) VALUES ('external (customer)', 2);
INSERT INTO faq_state (name, type_id) VALUES ('public (all)', 3);

INSERT INTO faq_state_type (name) VALUES ('internal');
INSERT INTO faq_state_type (name) VALUES ('external');
INSERT INTO faq_state_type (name) VALUES ('public');

--
-- auto_response update
--
ALTER TABLE auto_response ADD charset VARCHAR (80);
UPDATE auto_response SET charset = 'ISO-8859-1';
ALTER TABLE auto_response ALTER COLUMN charset SET NOT NULL;

--
-- agent notifications
--
CREATE TABLE notifications
(
    id serial,
    notification_type varchar (200) NOT NULL,
    notification_charset varchar (60) NOT NULL,
    notification_language varchar (60) NOT NULL,
    subject varchar (250) NOT NULL,
    text varchar NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::NewTicket', 'iso-8859-1', 'en', 'New ticket notification! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,there is a new ticket in "<OTRS_QUEUE>"!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::FollowUp', 'iso-8859-1', 'en', 'You got follow up! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,you got a follow up!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::LockTimeout', 'iso-8859-1', 'en', 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,unlocked (lock timeout) your locked ticket [<OTRS_TICKET_NUMBER>].<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[8]><snip> <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::OwnerUpdate', 'iso-8859-1', 'en', 'Ticket assigned to you! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,a ticket [<OTRS_TICKET_NUMBER>] is assigned to you by "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>".Comment:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::AddNote', 'iso-8859-1', 'en', 'New note! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" added a new note to ticket [<OTRS_TICKET_NUMBER>].Note:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Move', 'iso-8859-1', 'en', 'Moved ticket in "<OTRS_CUSTOMER_QUEUE>" queue! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" moved a ticket [<OTRS_TICKET_NUMBER>] into "<OTRS_CUSTOMER_QUEUE>".<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::PendingReminder', 'iso-8859-1', 'en', 'Ticket Reminder!', 'Hi <OTRS_OWNER_USERFIRSTNAME>,the ticket "<OTRS_TICKET_NUMBER>" has reached the reminder time!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[8]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Escalation', 'iso-8859-1', 'en', 'Ticket Escalation!', 'Hi <OTRS_USERFIRSTNAME>,the ticket "<OTRS_TICKET_NUMBER>" is escalated!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[8]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::NewTicket', 'iso-8859-1', 'de', 'Neues Ticket! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,es ist ein neues Ticket in "<OTRS_QUEUE>"!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Dein OTRS Benachrichiguns-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::FollowUp', 'iso-8859-1', 'de', 'Nachfrage! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,Du hast eine Nachfrage bekommen!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Dein OTRS Benachrichiguns-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::LockTimeout', 'iso-8859-1', 'de', 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,aufhebung der Sperre auf Dein gesperrtes Ticket [<OTRS_TICKET_NUMBER>].<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[8]><snip> <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Dein OTRS Benachrichiguns-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::OwnerUpdate', 'iso-8859-1', 'de', 'Ticket uebertragen an Dich! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,ein Ticket [<OTRS_TICKET_NUMBER>] wurde an Dich von "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" uebertragen.Kommentar:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Dein OTRS Benachrichiguns-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::AddNote', 'iso-8859-1', 'de', 'Neue Notiz! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" fuegte eine Notiz an Ticket [<OTRS_TICKET_NUMBER>].Notiz:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Dein OTRS Benachrichiguns-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Move', 'iso-8859-1', 'de', 'Ticket verschoben in "<OTRS_CUSTOMER_QUEUE>" Queue! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" verschob Ticket [<OTRS_TICKET_NUMBER>] nach "<OTRS_CUSTOMER_QUEUE>".<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Dein OTRS Benachrichiguns-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::PendingReminder', 'iso-8859-1', 'de', 'Ticket Erinnerung!', 'Hi <OTRS_OWNER_USERFIRSTNAME>,das Ticket "<OTRS_TICKET_NUMBER>" hat die Erinnerungszeit erreicht!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[8]><snip>Bitte um weitere Bearbeutung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Dein OTRS Benachrichiguns-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Escalation', 'iso-8859-1', 'de', 'Ticket Eskalation!', 'Hi <OTRS_USERFIRSTNAME>,das Ticket "<OTRS_TICKET_NUMBER>" ist eskaliert!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[8]><snip>Bitte um Bearbeutung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_ID>Dein OTRS Benachrichiguns-Master', current_timestamp, 1, current_timestamp, 1);

--
-- rename comment to comments column
--
ALTER TABLE groups RENAME comment TO comments;
ALTER TABLE charset RENAME comment TO comments;
ALTER TABLE ticket_state RENAME comment TO comments;
ALTER TABLE ticket_state_type RENAME comment TO comments;
ALTER TABLE salutation RENAME comment TO comments;
ALTER TABLE signature RENAME comment TO comments;
ALTER TABLE system_address RENAME comment TO comments;
ALTER TABLE follow_up_possible RENAME comment TO comments;
ALTER TABLE queue RENAME comment TO comments;
ALTER TABLE ticket_history_type RENAME comment TO comments;
ALTER TABLE article_type RENAME comment TO comments;
ALTER TABLE article_sender_type RENAME comment TO comments;
ALTER TABLE standard_response RENAME comment TO comments;
ALTER TABLE auto_response_type RENAME comment TO comments;
ALTER TABLE auto_response RENAME comment TO comments;
ALTER TABLE customer_user RENAME comment TO comments;
ALTER TABLE standard_attachment RENAME comment TO comments;
ALTER TABLE pop3_account RENAME comment TO comments;

