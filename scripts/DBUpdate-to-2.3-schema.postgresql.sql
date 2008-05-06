-- ----------------------------------------------------------
--  driver: postgresql, generated: 2008-05-07 00:26:11
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  create table queue_preferences
-- ----------------------------------------------------------
CREATE TABLE queue_preferences (
    queue_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
);
CREATE INDEX queue_preferences_queue_id ON queue_preferences (queue_id);
CREATE INDEX user_preferences_user_id ON user_preferences (user_id);
CREATE INDEX group_user_user_id ON group_user (user_id);
CREATE INDEX group_user_group_id ON group_user (group_id);
CREATE INDEX group_role_role_id ON group_role (role_id);
CREATE INDEX group_role_group_id ON group_role (group_id);
CREATE INDEX group_customer_user_id ON group_customer_user (user_id);
CREATE INDEX group_customer_user_group_id ON group_customer_user (group_id);
CREATE INDEX role_user_user_id ON role_user (user_id);
CREATE INDEX role_user_role_id ON role_user (role_id);
CREATE INDEX personal_queues_user_id ON personal_queues (user_id);
CREATE INDEX personal_queues_queue_id ON personal_queues (queue_id);
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD first_response_notify INTEGER;
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD update_notify INTEGER;
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue ADD solution_notify INTEGER;
CREATE INDEX queue_group_id ON queue (group_id);
CREATE INDEX ticket_title ON ticket (title);
CREATE INDEX ticket_customer_user_id ON ticket (customer_user_id);
CREATE INDEX ticket_customer_id ON ticket (customer_id);
CREATE INDEX ticket_queue_id ON ticket (queue_id);
CREATE INDEX ticket_ticket_lock_id ON ticket (lock_id);
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
CREATE INDEX ticket_history_priority_id ON ticket_history (priority_id);
-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD first_response_notify INTEGER;
-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD update_notify INTEGER;
-- ----------------------------------------------------------
--  alter table sla
-- ----------------------------------------------------------
ALTER TABLE sla ADD solution_notify INTEGER;
CREATE INDEX article_article_type_id ON article (article_type_id);
CREATE INDEX article_sender_type_id ON article (article_sender_type_id);
CREATE INDEX ticket_watcher_user_id ON ticket_watcher (user_id);
ALTER TABLE ticket_watcher ADD FOREIGN KEY (ticket_id) REFERENCES ticket(id);
ALTER TABLE ticket_watcher ADD FOREIGN KEY (user_id) REFERENCES system_user(id);
ALTER TABLE ticket_watcher ADD FOREIGN KEY (create_by) REFERENCES system_user(id);
ALTER TABLE ticket_watcher ADD FOREIGN KEY (change_by) REFERENCES system_user(id);
CREATE INDEX ticket_index_queue_id ON ticket_index (queue_id);
CREATE INDEX ticket_index_group_id ON ticket_index (group_id);
ALTER TABLE ticket_index ADD FOREIGN KEY (ticket_id) REFERENCES ticket(id);
ALTER TABLE ticket_index ADD FOREIGN KEY (queue_id) REFERENCES queue(id);
ALTER TABLE ticket_index ADD FOREIGN KEY (group_id) REFERENCES groups(id);
CREATE INDEX postmaster_filter_f_name ON postmaster_filter (f_name);
CREATE INDEX generic_agent_job_name ON generic_agent_jobs (job_name);
-- ----------------------------------------------------------
--  alter table mail_account
-- ----------------------------------------------------------
ALTER TABLE pop3_account RENAME TO mail_account;
-- ----------------------------------------------------------
--  alter table mail_account
-- ----------------------------------------------------------
ALTER TABLE mail_account ADD account_type VARCHAR (20);
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_body TYPE VARCHAR;
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ALTER a_body SET NOT NULL;
-- ----------------------------------------------------------
--  alter table xml_storage
-- ----------------------------------------------------------
ALTER TABLE xml_storage ALTER xml_content_value TYPE VARCHAR;
-- ----------------------------------------------------------
--  alter table xml_storage
-- ----------------------------------------------------------
ALTER TABLE xml_storage ALTER xml_content_value DROP NOT NULL;
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
