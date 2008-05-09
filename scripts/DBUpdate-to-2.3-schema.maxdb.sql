// ----------------------------------------------------------
//  driver: maxdb, generated: 2008-05-09 15:39:53
// ----------------------------------------------------------
// ----------------------------------------------------------
//  create table queue_preferences
// ----------------------------------------------------------
CREATE TABLE queue_preferences
(
    queue_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
)
//
CREATE INDEX queue_preferences_qu47 ON queue_preferences (queue_id)
//
// ----------------------------------------------------------
//  alter table queue
// ----------------------------------------------------------
ALTER TABLE queue ADD first_response_notify SMALLINT
//
// ----------------------------------------------------------
//  alter table queue
// ----------------------------------------------------------
ALTER TABLE queue ADD update_notify SMALLINT
//
// ----------------------------------------------------------
//  alter table queue
// ----------------------------------------------------------
ALTER TABLE queue ADD solution_notify SMALLINT
//
// ----------------------------------------------------------
//  alter table sla
// ----------------------------------------------------------
ALTER TABLE sla ADD first_response_notify SMALLINT
//
// ----------------------------------------------------------
//  alter table sla
// ----------------------------------------------------------
ALTER TABLE sla ADD update_notify SMALLINT
//
// ----------------------------------------------------------
//  alter table sla
// ----------------------------------------------------------
ALTER TABLE sla ADD solution_notify SMALLINT
//
// ----------------------------------------------------------
//  create table service_sla
// ----------------------------------------------------------
CREATE TABLE service_sla
(
    service_id INTEGER NOT NULL,
    sla_id INTEGER NOT NULL,
    UNIQUE service_sla (service_id, sla_id)
)
//
// ----------------------------------------------------------
//  alter table mail_account
// ----------------------------------------------------------
ALTER TABLE pop3_account TO mail_account
//
// ----------------------------------------------------------
//  alter table mail_account
// ----------------------------------------------------------
ALTER TABLE mail_account ADD account_type VARCHAR (20)
//
// ----------------------------------------------------------
//  alter table article
// ----------------------------------------------------------
ALTER TABLE article CHANGE a_body a_body LONG NOT NULL
//
// ----------------------------------------------------------
//  alter table xml_storage
// ----------------------------------------------------------
ALTER TABLE xml_storage CHANGE xml_content_value xml_content_value LONG
//
// ----------------------------------------------------------
//  insert into table notifications
// ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'iso-8859-1', 'en', 'Ticket Escalation Warning! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,the ticket "<OTRS_TICKET_TicketNumber>" will escalate!Escalation at: <OTRS_TICKET_EscalationDestinationDate>Escalation in: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 1, timestamp, 1, timestamp)
//
// ----------------------------------------------------------
//  insert into table notifications
// ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'iso-8859-1', 'de', 'Ticket Eskalations-Warnung! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,das Ticket "<OTRS_TICKET_TicketNumber>" wird bald eskalieren!Eskalation um: <OTRS_TICKET_EscalationDestinationDate>Eskalation in: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Bitte um Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 1, timestamp, 1, timestamp)
//
