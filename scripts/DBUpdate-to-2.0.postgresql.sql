-- --
-- Update an existing OTRS database from 1.3 to 2.0
-- Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-2.0.postgresql.sql,v 1.22 2005-07-31 09:18:53 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-2.0.postgresql.sql | psql otrs
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD title varchar (255);
ALTER TABLE ticket ADD freetime1 timestamp(0);
ALTER TABLE ticket ADD freetime2 timestamp(0);

--
-- time_accounting
--
CREATE TABLE time_accounting_old AS SELECT id, ticket_id, article_id, time_unit, create_time, create_by, change_time, change_by FROM time_accounting;
DROP TABLE time_accounting;
CREATE TABLE time_accounting (
    id serial,
    ticket_id INTEGER NOT NULL,
    article_id INTEGER,
    time_unit DECIMAL (10,2) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
INSERT INTO time_accounting SELECT * FROM time_accounting_old;
DROP TABLE time_accounting_old;

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
-- improve ticket table
--
ALTER TABLE ticket ADD escalation_start_time INTEGER;
UPDATE ticket SET escalation_start_time = 0 WHERE escalation_start_time IS NULL;
ALTER TABLE ticket ALTER escalation_start_time SET NOT NULL;

--
-- improve search profile table
--
ALTER TABLE search_profile ADD profile_type VARCHAR (30);
UPDATE search_profile SET profile_type='TicketSearch' WHERE profile_type IS NULL;
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

--
-- improve faq table
--
ALTER TABLE faq_item ADD f_number VARCHAR (200);
UPDATE faq_item SET f_number = 0 WHERE f_number IS NULL;
ALTER TABLE faq_item ALTER f_number SET NOT NULL;

CREATE TABLE faq_attachment
(
    id serial,
    faq_id BIGINT NOT NULL,
    filename VARCHAR (250),
    content_size VARCHAR (30),
    content_type VARCHAR (250),
    content text,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
create INDEX index_faq_attachment_faq_id ON faq_attachment (faq_id);

--
-- web_upload_cache
--
CREATE TABLE web_upload_cache (
    form_id VARCHAR (250),
    filename VARCHAR (250),
    content_size VARCHAR (30),
    content_type VARCHAR (250),
    content TEXT NOT NULL,
    create_time_unix INTEGER NOT NULL
);

--
-- drop session table
--
DROP TABLE session;

--
-- create renamed table (session -> sessions)
--
CREATE TABLE sessions (
    session_id VARCHAR (150) NOT NULL,
    session_value TEXT NOT NULL,
    UNIQUE (session_id)
);
CREATE INDEX index_session_id ON sessions (session_id);

--
--  create table article_flag
--
CREATE TABLE article_flag (
    article_id INTEGER NOT NULL,
    article_flag VARCHAR (50) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL
);
CREATE INDEX article_flag_article_id ON article_flag (article_id);
CREATE INDEX article_flag_create_by ON article_flag (create_by);

--
-- xml_storage table
--
CREATE TABLE xml_storage (
    xml_type VARCHAR (200) NOT NULL,
    xml_key VARCHAR (250) NOT NULL,
    xml_content_key VARCHAR (250) NOT NULL,
    xml_content_value TEXT NOT NULL
);
CREATE INDEX xml_content_key ON xml_storage (xml_content_key);
CREATE INDEX xml_type ON xml_storage (xml_type);
CREATE INDEX xml_key ON xml_storage (xml_key);

--
-- package_repository table
--
CREATE TABLE package_repository (
    id serial,
    name VARCHAR (250) NOT NULL,
    version VARCHAR (250) NOT NULL,
    vendor VARCHAR (250) NOT NULL,
    install_status VARCHAR (250) NOT NULL,
    filename VARCHAR (250),
    content_size VARCHAR (30),
    content_type VARCHAR (250),
    content TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);

--
-- ticket history type for new system tickets
--
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SystemRequest', 1, 1, current_timestamp, 1, current_timestamp);
--
-- ticket history type for new merged tickets
--
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Merged', 1, 1, current_timestamp, 1, current_timestamp);
--
-- ticket state type and state for merged tickets
--
INSERT INTO ticket_state_type
        (name, comments, create_by, create_time, change_by, change_time)
        VALUES
        ('merged', 'state type for merged tickets (default: not viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state
        (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('merged', 'state for merged tickets', 7, 1, 1, current_timestamp, 1, current_timestamp);

--
-- remove all old notifications
--
DELETE FROM notifications;

--
-- update agent notifications
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::NewTicket', 'iso-8859-1', 'en', 'New ticket notification! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,there is a new ticket in "<OTRS_TICKET_QUEUE>"!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::FollowUp', 'iso-8859-1', 'en', 'You got follow up! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,you got a follow up!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::LockTimeout', 'iso-8859-1', 'en', 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,unlocked (lock timeout) your locked ticket [<OTRS_TICKET_TicketNumber>].<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip> <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::OwnerUpdate', 'iso-8859-1', 'en', 'Ticket assigned to you! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,a ticket [<OTRS_TICKET_TicketNumber>] is assigned to you by "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>".Comment:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::AddNote', 'iso-8859-1', 'en', 'New note! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" added a new note to ticket [<OTRS_TICKET_TicketNumber>].Note:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Move', 'iso-8859-1', 'en', 'Moved ticket in "<OTRS_CUSTOMER_QUEUE>" queue! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" moved a ticket [<OTRS_TICKET_TicketNumber>] into "<OTRS_CUSTOMER_QUEUE>".<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::PendingReminder', 'iso-8859-1', 'en', 'Ticket Reminder!', 'Hi <OTRS_OWNER_USERFIRSTNAME>,the ticket "<OTRS_TICKET_TicketNumber>" has reached the reminder time!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Escalation', 'iso-8859-1', 'en', 'Ticket Escalation!', 'Hi <OTRS_USERFIRSTNAME>,the ticket "<OTRS_TICKET_TicketNumber>" is escaleted!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);


INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::NewTicket', 'iso-8859-1', 'de', 'Neues Ticket! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,es ist ein neues Ticket in "<OTRS_TICKET_QUEUE>"!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::FollowUp', 'iso-8859-1', 'de', 'Nachfrage! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,Du hast eine Nachfrage bekommen!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::LockTimeout', 'iso-8859-1', 'de', 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,Aufhebung der Sperre auf Dein gesperrtes Ticket [<OTRS_TICKET_TicketNumber>].<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip> <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::OwnerUpdate', 'iso-8859-1', 'de', 'Ticket uebertragen an Dich! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,ein Ticket [<OTRS_TICKET_TicketNumber>] wurde an Dich von "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" uebertragen.Kommentar:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::AddNote', 'iso-8859-1', 'de', 'Neue Notiz! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" fuegte eine Notiz an Ticket [<OTRS_TICKET_TicketNumber>].Notiz:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Move', 'iso-8859-1', 'de', 'Ticket verschoben in "<OTRS_CUSTOMER_QUEUE>" Queue! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" verschob Ticket [<OTRS_TICKET_TicketNumber>] nach "<OTRS_CUSTOMER_QUEUE>".<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::PendingReminder', 'iso-8859-1', 'de', 'Ticket Erinnerung!', 'Hi <OTRS_OWNER_USERFIRSTNAME>,das Ticket "<OTRS_TICKET_TicketNumber>" hat die Erinnerungszeit erreicht!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip>Bitte um weitere Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Escalation', 'iso-8859-1', 'de', 'Ticket Eskalation!', 'Hi <OTRS_USERFIRSTNAME>,das Ticket "<OTRS_TICKET_TicketNumber>" ist eskaliert!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip>MBitte um Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

--
-- customer notifications (en)
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::QueueUpdate', 'iso-8859-1', 'en', 'New Queue "<OTRS_TICKET_Queue>"!', '*** THIS IS JUST A NOTE ***The queue of your ticket "<OTRS_TICKET_TicketNumber>" has been changed by"<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>" to "<OTRS_TICKET_Queue>".<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master*** THIS IS JUST A NOTE ***', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::OwnerUpdate', 'iso-8859-1', 'en', 'New Owner "<OTRS_OWNER_UserFirstname>"!', '*** THIS IS JUST A NOTE ***The owner of your ticket "<OTRS_TICKET_TicketNumber>" has been changed to"<OTRS_OWNER_UserFirstname> <OTRS_OWNER_UserLastname>.<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master*** THIS IS JUST A NOTE ***', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::StateUpdate', 'iso-8859-1', 'en', 'New State "<OTRS_TICKET_State>"!', '*** THIS IS JUST A NOTE ***The state of your ticket "<OTRS_TICKET_TicketNumber>" has been changed by"<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>" to "<OTRS_TICKET_State>".<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master*** THIS IS JUST A NOTE ***', current_timestamp, 1, current_timestamp, 1);

--
-- customer notifications (de)
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::QueueUpdate', 'iso-8859-1', 'de', 'Neue Queue "<OTRS_TICKET_Queue>"!', '*** NUR EINE INFO ***Die Queue Ihres Tickets "<OTRS_TICKET_TicketNumber>" hat "<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>" auf "<OTRS_TICKET_Queue>" geaendert.<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master*** NUR EINE INFO ***', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::OwnerUpdate', 'iso-8859-1', 'de', 'Neuer Besitzer "<OTRS_OWNER_UserFirstname>"!', '*** NUR EINE INFO ***Der Besitzer des Tickets "<OTRS_TICKET_TicketNumber>" hat sich auf "<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> geaendert.<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master*** NUR EINE INFO ***', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::StateUpdate', 'iso-8859-1', 'de', 'Neuer Status "<OTRS_TICKET_State>"!', '*** NUR EINE INFO ***Der Status des Tickets "<OTRS_TICKET_TicketNumber>" hat sich durch "<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>" auf "<OTRS_TICKET_State>" veraendert.<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Dein OTRS Benachrichtigungs-Master*** NUR EINE INFO ***', current_timestamp, 1, current_timestamp, 1);

