-- ----------------------------------------------------------
--  driver: oracle, generated: 2008-05-15 19:28:07
-- ----------------------------------------------------------
SET DEFINE OFF;
-- ----------------------------------------------------------
--  create table queue_preferences
-- ----------------------------------------------------------
CREATE TABLE queue_preferences (
    queue_id NUMBER (12, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250)
);
CREATE INDEX queue_preferences_queue_id ON queue_preferences (queue_id);
-- ----------------------------------------------------------
--  create table service_sla
-- ----------------------------------------------------------
CREATE TABLE service_sla (
    service_id NUMBER (12, 0) NOT NULL,
    sla_id NUMBER (12, 0) NOT NULL,
    CONSTRAINT service_sla_service_sla UNIQUE (service_id, sla_id)
);
CREATE INDEX FK_service_sla_service_id ON service_sla (service_id);
CREATE INDEX FK_service_sla_sla_id ON service_sla (sla_id);
-- ----------------------------------------------------------
--  create table link_object_type
-- ----------------------------------------------------------
CREATE TABLE link_object_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT link_object_type_name UNIQUE (name)
);
ALTER TABLE link_object_type ADD CONSTRAINT PK_link_object_type PRIMARY KEY (id);
DROP SEQUENCE SE_link_object_type;
CREATE SEQUENCE SE_link_object_type;
CREATE OR REPLACE TRIGGER SE_link_object_type_t
before insert on link_object_type
for each row
begin
    select SE_link_object_type.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_link_object_type_change_by ON link_object_type (change_by);
CREATE INDEX FK_link_object_type_create_by ON link_object_type (create_by);
CREATE INDEX FK_link_object_type_valid_id ON link_object_type (valid_id);
-- ----------------------------------------------------------
--  create table link_object_state
-- ----------------------------------------------------------
CREATE TABLE link_object_state (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT link_object_state_name UNIQUE (name)
);
ALTER TABLE link_object_state ADD CONSTRAINT PK_link_object_state PRIMARY KEY (id);
DROP SEQUENCE SE_link_object_state;
CREATE SEQUENCE SE_link_object_state;
CREATE OR REPLACE TRIGGER SE_link_object_state_t
before insert on link_object_state
for each row
begin
    select SE_link_object_state.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_link_object_state_change_by ON link_object_state (change_by);
CREATE INDEX FK_link_object_state_create_by ON link_object_state (create_by);
CREATE INDEX FK_link_object_state_valid_id ON link_object_state (valid_id);
-- ----------------------------------------------------------
--  create table link_object_object
-- ----------------------------------------------------------
CREATE TABLE link_object_object (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    CONSTRAINT link_object_object_name UNIQUE (name)
);
ALTER TABLE link_object_object ADD CONSTRAINT PK_link_object_object PRIMARY KEY (id);
DROP SEQUENCE SE_link_object_object;
CREATE SEQUENCE SE_link_object_object;
CREATE OR REPLACE TRIGGER SE_link_object_object_t
before insert on link_object_object
for each row
begin
    select SE_link_object_object.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table link_object
-- ----------------------------------------------------------
CREATE TABLE link_object (
    source_object_id NUMBER (5, 0) NOT NULL,
    source_key VARCHAR2 (50) NOT NULL,
    target_object_id NUMBER (5, 0) NOT NULL,
    target_key VARCHAR2 (50) NOT NULL,
    type_id NUMBER (5, 0) NOT NULL,
    state_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT link_object_relation UNIQUE (source_object_id, source_key, target_object_id, target_key, type_id)
);
CREATE INDEX FK_link_object_create_by ON link_object (create_by);
CREATE INDEX FK_link_object_source_object93 ON link_object (source_object_id);
CREATE INDEX FK_link_object_state_id ON link_object (state_id);
CREATE INDEX FK_link_object_target_objectff ON link_object (target_object_id);
CREATE INDEX FK_link_object_type_id ON link_object (type_id);
CREATE INDEX user_preferences_user_id ON user_preferences (user_id);
CREATE INDEX group_user_user_id ON group_user (user_id);
CREATE INDEX group_user_group_id ON group_user (group_id);
CREATE INDEX group_role_role_id ON group_role (role_id);
CREATE INDEX group_role_group_id ON group_role (group_id);
CREATE INDEX group_customer_user_user_id ON group_customer_user (user_id);
CREATE INDEX group_customer_user_group_id ON group_customer_user (group_id);
CREATE INDEX role_user_user_id ON role_user (user_id);
CREATE INDEX role_user_role_id ON role_user (role_id);
CREATE INDEX personal_queues_user_id ON personal_queues (user_id);
CREATE INDEX personal_queues_queue_id ON personal_queues (queue_id);
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD first_response_notify NUMBER (5, 0);
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD update_notify NUMBER (5, 0);
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD solution_notify NUMBER (5, 0);
CREATE INDEX queue_group_id ON queue (group_id);
CREATE INDEX ticket_title ON ticket (title);
CREATE INDEX ticket_customer_user_id ON ticket (customer_user_id);
CREATE INDEX ticket_customer_id ON ticket (customer_id);
CREATE INDEX ticket_queue_id ON ticket (queue_id);
CREATE INDEX ticket_ticket_lock_id ON ticket (ticket_lock_id);
CREATE INDEX ticket_responsible_user_id ON ticket (responsible_user_id);
CREATE INDEX ticket_ticket_state_id ON ticket (ticket_state_id);
CREATE INDEX ticket_ticket_priority_id ON ticket (ticket_priority_id);
CREATE INDEX index_object_link_a_id ON object_link (object_link_a_id);
CREATE INDEX index_object_link_b_id ON object_link (object_link_b_id);
CREATE INDEX index_object_link_a_object ON object_link (object_link_a_object);
CREATE INDEX index_object_link_b_object ON object_link (object_link_b_object);
CREATE INDEX index_object_link_type ON object_link (object_link_type);
CREATE INDEX ticket_history_history_type_id ON ticket_history (history_type_id);
CREATE INDEX ticket_history_queue_id ON ticket_history (queue_id);
CREATE INDEX ticket_history_type_id ON ticket_history (type_id);
CREATE INDEX ticket_history_owner_id ON ticket_history (owner_id);
CREATE INDEX ticket_history_priority_id ON ticket_history (priority_id);
CREATE INDEX ticket_history_state_id ON ticket_history (state_id);
-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD first_response_notify NUMBER (5, 0);
-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD update_notify NUMBER (5, 0);
-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD solution_notify NUMBER (5, 0);
CREATE INDEX article_article_type_id ON article (article_type_id);
CREATE INDEX article_article_sender_type_id ON article (article_sender_type_id);
CREATE INDEX ticket_watcher_user_id ON ticket_watcher (user_id);
ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket(id);
ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_user_id_id FOREIGN KEY (user_id) REFERENCES system_user(id);
ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_create_by_id FOREIGN KEY (create_by) REFERENCES system_user(id);
ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_change_by_id FOREIGN KEY (change_by) REFERENCES system_user(id);
CREATE INDEX ticket_index_queue_id ON ticket_index (queue_id);
CREATE INDEX ticket_index_group_id ON ticket_index (group_id);
ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket(id);
ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue(id);
ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_group_id_id FOREIGN KEY (group_id) REFERENCES groups(id);
CREATE INDEX postmaster_filter_f_name ON postmaster_filter (f_name);
CREATE INDEX generic_agent_jobs_job_name ON generic_agent_jobs (job_name);
-- ----------------------------------------------------------
--  alter table mail_account
-- ----------------------------------------------------------
ALTER TABLE pop3_account RENAME TO mail_account;
-- ----------------------------------------------------------
--  alter table mail_account
-- ----------------------------------------------------------
ALTER TABLE mail_account ADD account_type VARCHAR2 (20);
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article MODIFY a_body CLOB NOT NULL;
-- ----------------------------------------------------------
--  alter table xml_storage
-- ----------------------------------------------------------
ALTER TABLE xml_storage MODIFY xml_content_value CLOB NULL;
-- ----------------------------------------------------------
--  alter table users
-- ----------------------------------------------------------
ALTER TABLE system_user RENAME TO users;
-- ----------------------------------------------------------
--  insert into table notifications
-- ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'iso-8859-1', 'en', 'Ticket Escalation Warning! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,the ticket "<OTRS_TICKET_TicketNumber>" will escalate!Escalation at: <OTRS_TICKET_EscalationDestinationDate>Escalation in: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table notifications
-- ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'iso-8859-1', 'de', 'Ticket Eskalations-Warnung! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,das Ticket "<OTRS_TICKET_TicketNumber>" wird bald eskalieren!Eskalation um: <OTRS_TICKET_EscalationDestinationDate>Eskalation in: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Bitte um Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table link_object_type
-- ----------------------------------------------------------
INSERT INTO link_object_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Normal', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table link_object_type
-- ----------------------------------------------------------
INSERT INTO link_object_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ParentChild', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table link_object_state
-- ----------------------------------------------------------
INSERT INTO link_object_state (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Valid', 1, 1, current_timestamp, 1, current_timestamp);
-- ----------------------------------------------------------
--  insert into table link_object_state
-- ----------------------------------------------------------
INSERT INTO link_object_state (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Temporary', 1, 1, current_timestamp, 1, current_timestamp);
SET DEFINE OFF;
ALTER TABLE queue_preferences ADD CONSTRAINT FK_queue_preferences_queue_id9 FOREIGN KEY (queue_id) REFERENCES queue(id);
ALTER TABLE service_sla ADD CONSTRAINT FK_service_sla_service_id_id FOREIGN KEY (service_id) REFERENCES service(id);
ALTER TABLE service_sla ADD CONSTRAINT FK_service_sla_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla(id);
ALTER TABLE link_object_type ADD CONSTRAINT FK_link_object_type_create_b4c FOREIGN KEY (create_by) REFERENCES system_user(id);
ALTER TABLE link_object_type ADD CONSTRAINT FK_link_object_type_change_bce FOREIGN KEY (change_by) REFERENCES system_user(id);
ALTER TABLE link_object_type ADD CONSTRAINT FK_link_object_type_valid_id18 FOREIGN KEY (valid_id) REFERENCES valid(id);
ALTER TABLE link_object_state ADD CONSTRAINT FK_link_object_state_create_0a FOREIGN KEY (create_by) REFERENCES system_user(id);
ALTER TABLE link_object_state ADD CONSTRAINT FK_link_object_state_change_84 FOREIGN KEY (change_by) REFERENCES system_user(id);
ALTER TABLE link_object_state ADD CONSTRAINT FK_link_object_state_valid_i3d FOREIGN KEY (valid_id) REFERENCES valid(id);
ALTER TABLE link_object ADD CONSTRAINT FK_link_object_source_object0b FOREIGN KEY (source_object_id) REFERENCES link_object_object(id);
ALTER TABLE link_object ADD CONSTRAINT FK_link_object_target_object72 FOREIGN KEY (target_object_id) REFERENCES link_object_object(id);
ALTER TABLE link_object ADD CONSTRAINT FK_link_object_state_id_id FOREIGN KEY (state_id) REFERENCES link_object_state(id);
ALTER TABLE link_object ADD CONSTRAINT FK_link_object_type_id_id FOREIGN KEY (type_id) REFERENCES link_object_type(id);
ALTER TABLE link_object ADD CONSTRAINT FK_link_object_create_by_id FOREIGN KEY (create_by) REFERENCES system_user(id);
