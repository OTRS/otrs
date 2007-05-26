// ----------------------------------------------------------
//  driver: maxdb, generated: 2007-05-26 19:32:27
// ----------------------------------------------------------
ALTER TABLE valid ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE valid ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_priority ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_priority ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_type ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_type ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_type ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE ticket_lock_type ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_lock_type ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_lock_type ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE system_user ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE system_user ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE system_user ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE user_preferences ADD FOREIGN KEY (user_id) REFERENCES system_user(id)
//
ALTER TABLE groups ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE groups ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE groups ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE group_user ADD FOREIGN KEY (group_id) REFERENCES groups(id)
//
ALTER TABLE group_user ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE group_user ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE group_user ADD FOREIGN KEY (user_id) REFERENCES system_user(id)
//
ALTER TABLE group_role ADD FOREIGN KEY (role_id) REFERENCES roles(id)
//
ALTER TABLE group_role ADD FOREIGN KEY (group_id) REFERENCES groups(id)
//
ALTER TABLE group_role ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE group_role ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE group_customer_user ADD FOREIGN KEY (group_id) REFERENCES groups(id)
//
ALTER TABLE group_customer_user ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE group_customer_user ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE roles ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE roles ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE roles ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE role_user ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE role_user ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE role_user ADD FOREIGN KEY (user_id) REFERENCES system_user(id)
//
ALTER TABLE personal_queues ADD FOREIGN KEY (queue_id) REFERENCES queue(id)
//
ALTER TABLE personal_queues ADD FOREIGN KEY (user_id) REFERENCES system_user(id)
//
ALTER TABLE theme ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE theme ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE theme ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE ticket_state ADD FOREIGN KEY (type_id) REFERENCES ticket_state_type(id)
//
ALTER TABLE ticket_state ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_state ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_state ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE ticket_state_type ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_state_type ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE salutation ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE salutation ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE salutation ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE signature ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE signature ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE signature ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE system_address ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE system_address ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE system_address ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE follow_up_possible ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE follow_up_possible ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE follow_up_possible ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE queue ADD FOREIGN KEY (salutation_id) REFERENCES salutation(id)
//
ALTER TABLE queue ADD FOREIGN KEY (signature_id) REFERENCES signature(id)
//
ALTER TABLE queue ADD FOREIGN KEY (group_id) REFERENCES groups(id)
//
ALTER TABLE queue ADD FOREIGN KEY (follow_up_id) REFERENCES follow_up_possible(id)
//
ALTER TABLE queue ADD FOREIGN KEY (system_address_id) REFERENCES system_address(id)
//
ALTER TABLE queue ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE queue ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE queue ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (ticket_lock_id) REFERENCES ticket_lock_type(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (ticket_priority_id) REFERENCES ticket_priority(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (user_id) REFERENCES system_user(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (responsible_user_id) REFERENCES system_user(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (service_id) REFERENCES service(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (sla_id) REFERENCES sla(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (ticket_state_id) REFERENCES ticket_state(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (queue_id) REFERENCES queue(id)
//
ALTER TABLE ticket ADD FOREIGN KEY (type_id) REFERENCES ticket_type(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (priority_id) REFERENCES ticket_priority(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (owner_id) REFERENCES system_user(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (state_id) REFERENCES ticket_state(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (history_type_id) REFERENCES ticket_history_type(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (article_id) REFERENCES article(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (queue_id) REFERENCES queue(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (type_id) REFERENCES ticket_type(id)
//
ALTER TABLE ticket_history ADD FOREIGN KEY (ticket_id) REFERENCES ticket(id)
//
ALTER TABLE ticket_history_type ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_history_type ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE ticket_history_type ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE article_type ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE article_type ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE article_type ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE article_sender_type ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE article_sender_type ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE article_sender_type ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE article_flag ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE article ADD FOREIGN KEY (article_sender_type_id) REFERENCES article_sender_type(id)
//
ALTER TABLE article ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE article ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE article ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE article ADD FOREIGN KEY (article_type_id) REFERENCES article_type(id)
//
ALTER TABLE article ADD FOREIGN KEY (ticket_id) REFERENCES ticket(id)
//
ALTER TABLE article_plain ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE article_plain ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE article_plain ADD FOREIGN KEY (article_id) REFERENCES article(id)
//
ALTER TABLE article_attachment ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE article_attachment ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE article_attachment ADD FOREIGN KEY (article_id) REFERENCES article(id)
//
ALTER TABLE standard_response ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE standard_response ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE standard_response ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE queue_standard_response ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE queue_standard_response ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE queue_standard_response ADD FOREIGN KEY (standard_response_id) REFERENCES standard_response(id)
//
ALTER TABLE queue_standard_response ADD FOREIGN KEY (queue_id) REFERENCES queue(id)
//
ALTER TABLE standard_attachment ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE standard_attachment ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE standard_attachment ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE standard_response_attachment ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE standard_response_attachment ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE standard_response_attachment ADD FOREIGN KEY (standard_response_id) REFERENCES standard_response(id)
//
ALTER TABLE standard_response_attachment ADD FOREIGN KEY (standard_attachment_id) REFERENCES standard_attachment(id)
//
ALTER TABLE auto_response_type ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE auto_response_type ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE auto_response_type ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE auto_response ADD FOREIGN KEY (type_id) REFERENCES auto_response_type(id)
//
ALTER TABLE auto_response ADD FOREIGN KEY (system_address_id) REFERENCES system_address(id)
//
ALTER TABLE auto_response ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE auto_response ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE auto_response ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE queue_auto_response ADD FOREIGN KEY (auto_response_id) REFERENCES auto_response(id)
//
ALTER TABLE queue_auto_response ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE queue_auto_response ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE queue_auto_response ADD FOREIGN KEY (queue_id) REFERENCES queue(id)
//
ALTER TABLE time_accounting ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE time_accounting ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE time_accounting ADD FOREIGN KEY (article_id) REFERENCES article(id)
//
ALTER TABLE time_accounting ADD FOREIGN KEY (ticket_id) REFERENCES ticket(id)
//
ALTER TABLE service ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE service ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE sla ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE sla ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE sla ADD FOREIGN KEY (service_id) REFERENCES service(id)
//
ALTER TABLE customer_user ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE customer_user ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE customer_user ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE pop3_account ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE pop3_account ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE pop3_account ADD FOREIGN KEY (valid_id) REFERENCES valid(id)
//
ALTER TABLE notifications ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE notifications ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
ALTER TABLE package_repository ADD FOREIGN KEY (create_by) REFERENCES system_user(id)
//
ALTER TABLE package_repository ADD FOREIGN KEY (change_by) REFERENCES system_user(id)
//
