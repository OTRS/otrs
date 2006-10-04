-- --
-- Update an existing OTRS database from 2.0 to 2.1
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.1.oracle.sql,v 1.4 2006-10-04 10:46:50 rk Exp $
-- --
--
-- usage: cat DBUpdate-to-2.1.oracle.sql | sqlplus "user/password"
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD responsible_user_id INTEGER;
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
    ticket_id NUMBER(20) NOT NULL,
    user_id NUMBER NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);

CREATE INDEX ticket_id ON ticket_watcher (ticket_id);

--
-- queue, add calendar
--
ALTER TABLE queue ADD calendar_name varchar (100);

--
-- change because of moduls like incident and IDMEFConsole
--
CREATE TABLE object_link_tmp (
    object_link_a_id VARCHAR2 (80) NOT NULL,
    object_link_b_id VARCHAR2 (80) NOT NULL,
    object_link_a_object VARCHAR2 (200) NOT NULL,
    object_link_b_object VARCHAR2 (200) NOT NULL,
    object_link_type VARCHAR2 (200) NOT NULL
);

INSERT INTO object_link_tmp SELECT * FROM object_link;
DROP TABLE object_link;

CREATE TABLE object_link (
    object_link_a_id VARCHAR2 (80) NOT NULL,
    object_link_b_id VARCHAR2 (80) NOT NULL,
    object_link_a_object VARCHAR2 (200) NOT NULL,
    object_link_b_object VARCHAR2 (200) NOT NULL,
    object_link_type VARCHAR2 (200) NOT NULL
);

INSERT INTO object_link SELECT * FROM object_link_tmp;
DROP TABLE object_link_tmp;


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
-- faq
--

CREATE TABLE faq_voting (
    id NUMBER (20) NOT NULL,
    created_by VARCHAR2 (200) NOT NULL,
    item_id NUMBER NOT NULL,
    interface VARCHAR2 (80),
    ip VARCHAR2 (50),
    rate NUMBER NOT NULL,
    created DATE
);

ALTER TABLE faq_category ADD parent_id NUMBER;
ALTER TABLE faq_category ADD valid_id NUMBER;

UPDATE faq_category SET parent_id = 0;
UPDATE faq_category SET valid_id = 1;

ALTER TABLE faq_category CHANGE create_by created_by NUMBER;
ALTER TABLE faq_category CHANGE change_by changed_by NUMBER;
ALTER TABLE faq_category CHANGE create_time created DATE;
ALTER TABLE faq_category CHANGE change_time changed DATE;

ALTER TABLE faq_history CHANGE create_by created_by NUMBER;
ALTER TABLE faq_history CHANGE change_by changed_by NUMBER;
ALTER TABLE faq_history CHANGE create_time created DATE;
ALTER TABLE faq_history CHANGE change_time changed DATE;

ALTER TABLE faq_item CHANGE create_by created_by NUMBER;
ALTER TABLE faq_item CHANGE change_by changed_by NUMBER;
ALTER TABLE faq_item CHANGE create_time created DATE;
ALTER TABLE faq_item CHANGE change_time changed DATE;


