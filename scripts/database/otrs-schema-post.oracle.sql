-- ----------------------------------------------------------
--  driver: oracle
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE acl ADD CONSTRAINT FK_acl_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_acl_create_by ON acl (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE acl ADD CONSTRAINT FK_acl_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_acl_change_by ON acl (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE acl ADD CONSTRAINT FK_acl_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_acl_valid_id ON acl (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE valid ADD CONSTRAINT FK_valid_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_valid_create_by ON valid (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE valid ADD CONSTRAINT FK_valid_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_valid_change_by ON valid (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE users ADD CONSTRAINT FK_users_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_users_create_by ON users (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE users ADD CONSTRAINT FK_users_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_users_change_by ON users (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE users ADD CONSTRAINT FK_users_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_users_valid_id ON users (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE user_preferences ADD CONSTRAINT FK_user_preferences_user_id_id FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_user_preferences_user_id ON user_preferences (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE groups ADD CONSTRAINT FK_groups_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_groups_create_by ON groups (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE groups ADD CONSTRAINT FK_groups_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_groups_change_by ON groups (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE groups ADD CONSTRAINT FK_groups_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_groups_valid_id ON groups (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_user ADD CONSTRAINT FK_group_user_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_user_group_id ON group_user (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_user ADD CONSTRAINT FK_group_user_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_user_create_by ON group_user (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_user ADD CONSTRAINT FK_group_user_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_user_change_by ON group_user (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_user ADD CONSTRAINT FK_group_user_user_id_id FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_user_user_id ON group_user (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_role ADD CONSTRAINT FK_group_role_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_role_group_id ON group_role (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_role ADD CONSTRAINT FK_group_role_role_id_id FOREIGN KEY (role_id) REFERENCES roles (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_role_role_id ON group_role (role_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_role ADD CONSTRAINT FK_group_role_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_role_create_by ON group_role (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_role ADD CONSTRAINT FK_group_role_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_role_change_by ON group_role (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_customer_user ADD CONSTRAINT FK_group_customer_user_groupbb FOREIGN KEY (group_id) REFERENCES groups (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_user_group76 ON group_customer_user (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_customer_user ADD CONSTRAINT FK_group_customer_user_creat36 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_user_creata6 ON group_customer_user (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_customer_user ADD CONSTRAINT FK_group_customer_user_chang97 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_user_chang04 ON group_customer_user (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_group_id ON group_customer (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_create_by ON group_customer (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_group_customer_change_by ON group_customer (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE roles ADD CONSTRAINT FK_roles_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_roles_create_by ON roles (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE roles ADD CONSTRAINT FK_roles_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_roles_change_by ON roles (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE roles ADD CONSTRAINT FK_roles_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_roles_valid_id ON roles (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE role_user ADD CONSTRAINT FK_role_user_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_role_user_create_by ON role_user (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE role_user ADD CONSTRAINT FK_role_user_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_role_user_change_by ON role_user (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE role_user ADD CONSTRAINT FK_role_user_user_id_id FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_role_user_user_id ON role_user (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE personal_queues ADD CONSTRAINT FK_personal_queues_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_personal_queues_queue_id ON personal_queues (queue_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE personal_queues ADD CONSTRAINT FK_personal_queues_user_id_id FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_personal_queues_user_id ON personal_queues (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_service42 FOREIGN KEY (service_id) REFERENCES service (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_personal_services_service14 ON personal_services (service_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_user_id23 FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_personal_services_user_id ON personal_services (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE salutation ADD CONSTRAINT FK_salutation_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_salutation_create_by ON salutation (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE salutation ADD CONSTRAINT FK_salutation_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_salutation_change_by ON salutation (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE salutation ADD CONSTRAINT FK_salutation_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_salutation_valid_id ON salutation (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE signature ADD CONSTRAINT FK_signature_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_signature_create_by ON signature (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE signature ADD CONSTRAINT FK_signature_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_signature_change_by ON signature (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE signature ADD CONSTRAINT FK_signature_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_signature_valid_id ON signature (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE system_address ADD CONSTRAINT FK_system_address_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_system_address_create_by ON system_address (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE system_address ADD CONSTRAINT FK_system_address_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_system_address_change_by ON system_address (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE system_address ADD CONSTRAINT FK_system_address_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_system_address_valid_id ON system_address (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_created6 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_system_maintenance_createf5 ON system_maintenance (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_change48 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_system_maintenance_changefb ON system_maintenance (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_valid_49 FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_system_maintenance_valid_id ON system_maintenance (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE follow_up_possible ADD CONSTRAINT FK_follow_up_possible_createef FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_follow_up_possible_create7e ON follow_up_possible (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE follow_up_possible ADD CONSTRAINT FK_follow_up_possible_change63 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_follow_up_possible_change8f ON follow_up_possible (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE follow_up_possible ADD CONSTRAINT FK_follow_up_possible_valid_95 FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_follow_up_possible_valid_id ON follow_up_possible (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue ADD CONSTRAINT FK_queue_follow_up_id_id FOREIGN KEY (follow_up_id) REFERENCES follow_up_possible (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_follow_up_id ON queue (follow_up_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue ADD CONSTRAINT FK_queue_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_group_id ON queue (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue ADD CONSTRAINT FK_queue_salutation_id_id FOREIGN KEY (salutation_id) REFERENCES salutation (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_salutation_id ON queue (salutation_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue ADD CONSTRAINT FK_queue_signature_id_id FOREIGN KEY (signature_id) REFERENCES signature (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_signature_id ON queue (signature_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue ADD CONSTRAINT FK_queue_system_address_id_id FOREIGN KEY (system_address_id) REFERENCES system_address (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_system_address_id ON queue (system_address_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue ADD CONSTRAINT FK_queue_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_create_by ON queue (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue ADD CONSTRAINT FK_queue_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_change_by ON queue (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue ADD CONSTRAINT FK_queue_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_valid_id ON queue (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_preferences ADD CONSTRAINT FK_queue_preferences_queue_id9 FOREIGN KEY (queue_id) REFERENCES queue (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_preferences_queue_id ON queue_preferences (queue_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_priority ADD CONSTRAINT FK_ticket_priority_create_by76 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_priority_create_by ON ticket_priority (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_priority ADD CONSTRAINT FK_ticket_priority_change_byd8 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_priority_change_by ON ticket_priority (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_type ADD CONSTRAINT FK_ticket_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_type_create_by ON ticket_type (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_type ADD CONSTRAINT FK_ticket_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_type_change_by ON ticket_type (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_type ADD CONSTRAINT FK_ticket_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_type_valid_id ON ticket_type (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_lock_type ADD CONSTRAINT FK_ticket_lock_type_create_bf4 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_lock_type_create_by ON ticket_lock_type (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_lock_type ADD CONSTRAINT FK_ticket_lock_type_change_b80 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_lock_type_change_by ON ticket_lock_type (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_lock_type ADD CONSTRAINT FK_ticket_lock_type_valid_id79 FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_lock_type_valid_id ON ticket_lock_type (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_state ADD CONSTRAINT FK_ticket_state_type_id_id FOREIGN KEY (type_id) REFERENCES ticket_state_type (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_state_type_id ON ticket_state (type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_state ADD CONSTRAINT FK_ticket_state_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_state_create_by ON ticket_state (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_state ADD CONSTRAINT FK_ticket_state_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_state_change_by ON ticket_state (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_state ADD CONSTRAINT FK_ticket_state_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_state_valid_id ON ticket_state (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_state_type ADD CONSTRAINT FK_ticket_state_type_create_e7 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_state_type_create_by ON ticket_state_type (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_state_type ADD CONSTRAINT FK_ticket_state_type_change_d7 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_state_type_change_by ON ticket_state_type (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_queue_id ON ticket (queue_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_service_id_id FOREIGN KEY (service_id) REFERENCES service (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_service_id ON ticket (service_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_sla_id ON ticket (sla_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_ticket_lock_id_id FOREIGN KEY (ticket_lock_id) REFERENCES ticket_lock_type (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_ticket_lock_id ON ticket (ticket_lock_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_ticket_priority_id88 FOREIGN KEY (ticket_priority_id) REFERENCES ticket_priority (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_ticket_priority_id ON ticket (ticket_priority_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_ticket_state_id_id FOREIGN KEY (ticket_state_id) REFERENCES ticket_state (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_ticket_state_id ON ticket (ticket_state_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_type_id_id FOREIGN KEY (type_id) REFERENCES ticket_type (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_type_id ON ticket (type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_create_by ON ticket (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_change_by ON ticket (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_user_id_id FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_user_id ON ticket (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket ADD CONSTRAINT FK_ticket_responsible_user_id1 FOREIGN KEY (responsible_user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_responsible_user_id ON ticket (responsible_user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_flag ADD CONSTRAINT FK_ticket_flag_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_flag_ticket_id ON ticket_flag (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_flag ADD CONSTRAINT FK_ticket_flag_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_flag_create_by ON ticket_flag (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_article_id34 FOREIGN KEY (article_id) REFERENCES article (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_article_id ON ticket_history (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_queue_id ON ticket_history (queue_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_ticket_id ON ticket_history (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_history_ty4d FOREIGN KEY (history_type_id) REFERENCES ticket_history_type (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_history_tyfc ON ticket_history (history_type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_priority_i53 FOREIGN KEY (priority_id) REFERENCES ticket_priority (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_priority_id ON ticket_history (priority_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_state_id_id FOREIGN KEY (state_id) REFERENCES ticket_state (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_state_id ON ticket_history (state_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_type_id_id FOREIGN KEY (type_id) REFERENCES ticket_type (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_type_id ON ticket_history (type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_owner_id_id FOREIGN KEY (owner_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_owner_id ON ticket_history (owner_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_create_by ON ticket_history (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_change_by ON ticket_history (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history_type ADD CONSTRAINT FK_ticket_history_type_creat45 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_type_creat39 ON ticket_history_type (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history_type ADD CONSTRAINT FK_ticket_history_type_chang7e FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_type_chang16 ON ticket_history_type (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_history_type ADD CONSTRAINT FK_ticket_history_type_valid11 FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_history_type_validad ON ticket_history_type (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_watcher_ticket_id ON ticket_watcher (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_user_id_id FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_watcher_user_id ON ticket_watcher (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_watcher_create_by ON ticket_watcher (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_watcher_change_by ON ticket_watcher (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_index_group_id ON ticket_index (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_index_queue_id ON ticket_index (queue_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_index_ticket_id ON ticket_index (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE ticket_lock_index ADD CONSTRAINT FK_ticket_lock_index_ticket_81 FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_ticket_lock_index_ticket_id ON ticket_lock_index (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_sender_type ADD CONSTRAINT FK_article_sender_type_creat12 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_sender_type_creat54 ON article_sender_type (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_sender_type ADD CONSTRAINT FK_article_sender_type_changb0 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_sender_type_chang7b ON article_sender_type (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_sender_type ADD CONSTRAINT FK_article_sender_type_validbd FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_sender_type_validfb ON article_sender_type (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_flag ADD CONSTRAINT FK_article_flag_article_id_id FOREIGN KEY (article_id) REFERENCES article (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_flag_article_id ON article_flag (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_flag ADD CONSTRAINT FK_article_flag_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_flag_create_by ON article_flag (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_crec7 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_communication_channel_cre1a ON communication_channel (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_cha6b FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_communication_channel_cha34 ON communication_channel (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_val71 FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_communication_channel_val71 ON communication_channel (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article ADD CONSTRAINT FK_article_article_sender_ty29 FOREIGN KEY (article_sender_type_id) REFERENCES article_sender_type (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_article_sender_tycb ON article (article_sender_type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article ADD CONSTRAINT FK_article_communication_cha1c FOREIGN KEY (communication_channel_id) REFERENCES communication_channel (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_communication_cha7f ON article (communication_channel_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article ADD CONSTRAINT FK_article_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_ticket_id ON article (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article ADD CONSTRAINT FK_article_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_create_by ON article (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article ADD CONSTRAINT FK_article_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_change_by ON article (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime ADD CONSTRAINT FK_article_data_mime_article5d FOREIGN KEY (article_id) REFERENCES article (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_article63 ON article_data_mime (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime ADD CONSTRAINT FK_article_data_mime_create_db FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_create_by ON article_data_mime (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime ADD CONSTRAINT FK_article_data_mime_change_12 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_change_by ON article_data_mime (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_artiea FOREIGN KEY (article_id) REFERENCES article (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_search_index_artie6 ON article_search_index (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_tickd8 FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_search_index_tick1b ON article_search_index (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime_plain ADD CONSTRAINT FK_article_data_mime_plain_a4f FOREIGN KEY (article_id) REFERENCES article (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_plain_aa3 ON article_data_mime_plain (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime_plain ADD CONSTRAINT FK_article_data_mime_plain_cb6 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_plain_c92 ON article_data_mime_plain (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime_plain ADD CONSTRAINT FK_article_data_mime_plain_cbc FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_plain_ccf ON article_data_mime_plain (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime_attachment ADD CONSTRAINT FK_article_data_mime_attachmdb FOREIGN KEY (article_id) REFERENCES article (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_attachm68 ON article_data_mime_attachment (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime_attachment ADD CONSTRAINT FK_article_data_mime_attachm63 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_attachmb3 ON article_data_mime_attachment (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_mime_attachment ADD CONSTRAINT FK_article_data_mime_attachm5c FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_mime_attachm82 ON article_data_mime_attachment (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE article_data_otrs_chat ADD CONSTRAINT FK_article_data_otrs_chat_arcf FOREIGN KEY (article_id) REFERENCES article (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_article_data_otrs_chat_ar37 ON article_data_otrs_chat (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE time_accounting ADD CONSTRAINT FK_time_accounting_article_i95 FOREIGN KEY (article_id) REFERENCES article (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_time_accounting_article_id ON time_accounting (article_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE time_accounting ADD CONSTRAINT FK_time_accounting_ticket_id91 FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_time_accounting_ticket_id ON time_accounting (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE time_accounting ADD CONSTRAINT FK_time_accounting_create_bybb FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_time_accounting_create_by ON time_accounting (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE time_accounting ADD CONSTRAINT FK_time_accounting_change_byff FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_time_accounting_change_by ON time_accounting (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_create_e4 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_template_create_by ON standard_template (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_change_15 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_template_change_by ON standard_template (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_valid_i25 FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_template_valid_id ON standard_template (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_q01 FOREIGN KEY (queue_id) REFERENCES queue (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_standard_template_q63 ON queue_standard_template (queue_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_s29 FOREIGN KEY (standard_template_id) REFERENCES standard_template (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_standard_template_s54 ON queue_standard_template (standard_template_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_c93 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_standard_template_c0d ON queue_standard_template (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_cdd FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_standard_template_c33 ON queue_standard_template (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_attachment ADD CONSTRAINT FK_standard_attachment_creat32 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_attachment_creat8b ON standard_attachment (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_attachment ADD CONSTRAINT FK_standard_attachment_changb4 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_attachment_chang1b ON standard_attachment (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_attachment ADD CONSTRAINT FK_standard_attachment_valid6c FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_attachment_validfe ON standard_attachment (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachm17 FOREIGN KEY (standard_attachment_id) REFERENCES standard_attachment (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_template_attachm9e ON standard_template_attachment (standard_attachment_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachm7e FOREIGN KEY (standard_template_id) REFERENCES standard_template (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_template_attachm29 ON standard_template_attachment (standard_template_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachm64 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_template_attachmb7 ON standard_template_attachment (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachm83 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_standard_template_attachmbd ON standard_template_attachment (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE auto_response_type ADD CONSTRAINT FK_auto_response_type_create90 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_auto_response_type_created6 ON auto_response_type (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE auto_response_type ADD CONSTRAINT FK_auto_response_type_change40 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_auto_response_type_changeec ON auto_response_type (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE auto_response_type ADD CONSTRAINT FK_auto_response_type_valid_75 FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_auto_response_type_valid_id ON auto_response_type (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_type_id_id FOREIGN KEY (type_id) REFERENCES auto_response_type (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_auto_response_type_id ON auto_response (type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_system_addrde FOREIGN KEY (system_address_id) REFERENCES system_address (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_auto_response_system_addr26 ON auto_response (system_address_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_auto_response_create_by ON auto_response (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_auto_response_change_by ON auto_response (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_auto_response_valid_id ON auto_response (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_auto_response ADD CONSTRAINT FK_queue_auto_response_auto_c8 FOREIGN KEY (auto_response_id) REFERENCES auto_response (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_auto_response_auto_3d ON queue_auto_response (auto_response_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_auto_response ADD CONSTRAINT FK_queue_auto_response_queue4f FOREIGN KEY (queue_id) REFERENCES queue (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_auto_response_queue7a ON queue_auto_response (queue_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_auto_response ADD CONSTRAINT FK_queue_auto_response_creat36 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_auto_response_creat75 ON queue_auto_response (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE queue_auto_response ADD CONSTRAINT FK_queue_auto_response_chang71 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_queue_auto_response_changc3 ON queue_auto_response (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE service ADD CONSTRAINT FK_service_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_service_create_by ON service (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE service ADD CONSTRAINT FK_service_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_service_change_by ON service (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE service_preferences ADD CONSTRAINT FK_service_preferences_servi62 FOREIGN KEY (service_id) REFERENCES service (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_service_preferences_servi64 ON service_preferences (service_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE service_customer_user ADD CONSTRAINT FK_service_customer_user_ser07 FOREIGN KEY (service_id) REFERENCES service (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_service_customer_user_serb4 ON service_customer_user (service_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE service_customer_user ADD CONSTRAINT FK_service_customer_user_cred0 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_service_customer_user_creb7 ON service_customer_user (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sla ADD CONSTRAINT FK_sla_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sla_create_by ON sla (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sla ADD CONSTRAINT FK_sla_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sla_change_by ON sla (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sla_preferences ADD CONSTRAINT FK_sla_preferences_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sla_preferences_sla_id ON sla_preferences (sla_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE service_sla ADD CONSTRAINT FK_service_sla_service_id_id FOREIGN KEY (service_id) REFERENCES service (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_service_sla_service_id ON service_sla (service_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE service_sla ADD CONSTRAINT FK_service_sla_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_service_sla_sla_id ON service_sla (sla_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE customer_user ADD CONSTRAINT FK_customer_user_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_customer_user_create_by ON customer_user (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE customer_user ADD CONSTRAINT FK_customer_user_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_customer_user_change_by ON customer_user (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE customer_user ADD CONSTRAINT FK_customer_user_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_customer_user_valid_id ON customer_user (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_cr02 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_customer_user_customer_cr61 ON customer_user_customer (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_ch5b FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_customer_user_customer_ch28 ON customer_user_customer (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE mail_account ADD CONSTRAINT FK_mail_account_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_mail_account_create_by ON mail_account (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE mail_account ADD CONSTRAINT FK_mail_account_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_mail_account_change_by ON mail_account (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE mail_account ADD CONSTRAINT FK_mail_account_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_mail_account_valid_id ON mail_account (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_create23 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_notification_event_create9d ON notification_event (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_changefb FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_notification_event_changeaf ON notification_event (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_valid_51 FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_notification_event_valid_id ON notification_event (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE notification_event_message ADD CONSTRAINT FK_notification_event_messag16 FOREIGN KEY (notification_id) REFERENCES notification_event (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_notification_event_messagf5 ON notification_event_message (notification_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE notification_event_item ADD CONSTRAINT FK_notification_event_item_nf6 FOREIGN KEY (notification_id) REFERENCES notification_event (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_notification_event_item_n9a ON notification_event_item (notification_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_type ADD CONSTRAINT FK_link_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_type_create_by ON link_type (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_type ADD CONSTRAINT FK_link_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_type_change_by ON link_type (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_type ADD CONSTRAINT FK_link_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_type_valid_id ON link_type (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_state ADD CONSTRAINT FK_link_state_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_state_create_by ON link_state (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_state ADD CONSTRAINT FK_link_state_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_state_change_by ON link_state (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_state ADD CONSTRAINT FK_link_state_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_state_valid_id ON link_state (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_source_obje16 FOREIGN KEY (source_object_id) REFERENCES link_object (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_relation_source_obje3c ON link_relation (source_object_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_target_obje18 FOREIGN KEY (target_object_id) REFERENCES link_object (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_relation_target_obje99 ON link_relation (target_object_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_state_id_id FOREIGN KEY (state_id) REFERENCES link_state (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_relation_state_id ON link_relation (state_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_type_id_id FOREIGN KEY (type_id) REFERENCES link_type (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_relation_type_id ON link_relation (type_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_link_relation_create_by ON link_relation (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE system_data ADD CONSTRAINT FK_system_data_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_system_data_create_by ON system_data (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE system_data ADD CONSTRAINT FK_system_data_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_system_data_change_by ON system_data (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_vib1 FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_virtual_fs_preferences_vi3c ON virtual_fs_preferences (virtual_fs_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE package_repository ADD CONSTRAINT FK_package_repository_createa6 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_package_repository_create99 ON package_repository (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE package_repository ADD CONSTRAINT FK_package_repository_changea2 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_package_repository_changed7 ON package_repository (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_crea72 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_gi_webservice_config_crea62 ON gi_webservice_config (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_chan93 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_gi_webservice_config_chan16 ON gi_webservice_config (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_valife FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_gi_webservice_config_vali90 ON gi_webservice_config (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_hist66 FOREIGN KEY (config_id) REFERENCES gi_webservice_config (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_gi_webservice_config_histeb ON gi_webservice_config_history (config_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_hist54 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_gi_webservice_config_hist3d ON gi_webservice_config_history (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_histeb FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_gi_webservice_config_histe6 ON gi_webservice_config_history (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE gi_debugger_entry ADD CONSTRAINT FK_gi_debugger_entry_webserv66 FOREIGN KEY (webservice_id) REFERENCES gi_webservice_config (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_gi_debugger_entry_webserv43 ON gi_debugger_entry (webservice_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE gi_debugger_entry_content ADD CONSTRAINT FK_gi_debugger_entry_content3b FOREIGN KEY (gi_debugger_entry_id) REFERENCES gi_debugger_entry (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_gi_debugger_entry_contentc3 ON gi_debugger_entry_content (gi_debugger_entry_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE smime_signer_cert_relations ADD CONSTRAINT FK_smime_signer_cert_relatio60 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_smime_signer_cert_relatiobb ON smime_signer_cert_relations (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE smime_signer_cert_relations ADD CONSTRAINT FK_smime_signer_cert_relatio77 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_smime_signer_cert_relatiob7 ON smime_signer_cert_relations (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE dynamic_field_value ADD CONSTRAINT FK_dynamic_field_value_fieldbe FOREIGN KEY (field_id) REFERENCES dynamic_field (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_dynamic_field_value_field90 ON dynamic_field_value (field_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_dynamic_field_create_by ON dynamic_field (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_dynamic_field_change_by ON dynamic_field (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_dynamic_field_valid_id ON dynamic_field (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_process_create_by ON pm_process (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_process_change_by ON pm_process (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_activity_create_by ON pm_activity (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_activity_change_by ON pm_activity (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_create32 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_activity_dialog_create86 ON pm_activity_dialog (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_changee5 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_activity_dialog_change65 ON pm_activity_dialog (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_transition ADD CONSTRAINT FK_pm_transition_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_transition_create_by ON pm_transition (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_transition ADD CONSTRAINT FK_pm_transition_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_transition_change_by ON pm_transition (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_transition_action ADD CONSTRAINT FK_pm_transition_action_crea8b FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_transition_action_crea78 ON pm_transition_action (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE pm_transition_action ADD CONSTRAINT FK_pm_transition_action_chan8c FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_pm_transition_action_chan4f ON pm_transition_action (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_creafe FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_cloud_service_config_crea30 ON cloud_service_config (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_chan63 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_cloud_service_config_chane1 ON cloud_service_config (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_vali9c FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_cloud_service_config_valib2 ON cloud_service_config (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_create_53 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_create_by ON sysconfig_default (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_change_36 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_change_by ON sysconfig_default (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_exclusi7d FOREIGN KEY (exclusive_lock_user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_exclusi26 ON sysconfig_default (exclusive_lock_user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version82 FOREIGN KEY (sysconfig_default_id) REFERENCES sysconfig_default (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_version51 ON sysconfig_default_version (sysconfig_default_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version1f FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_versionfa ON sysconfig_default_version (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_versiond1 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_default_version39 ON sysconfig_default_version (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_syscona0 FOREIGN KEY (sysconfig_default_id) REFERENCES sysconfig_default (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_syscon68 ON sysconfig_modified (sysconfig_default_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_user_iab FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_user_id ON sysconfig_modified (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_create1b FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_createcf ON sysconfig_modified (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_change9c FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_change22 ON sysconfig_modified (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_versioaf FOREIGN KEY (sysconfig_default_version_id) REFERENCES sysconfig_default_version (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_versioe7 ON sysconfig_modified_version (sysconfig_default_version_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_versiobb FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_versio08 ON sysconfig_modified_version (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_versioc4 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_versiofe ON sysconfig_modified_version (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_versio44 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_modified_versio75 ON sysconfig_modified_version (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_deployment_lock ADD CONSTRAINT FK_sysconfig_deployment_lock49 FOREIGN KEY (exclusive_lock_user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_deployment_lock70 ON sysconfig_deployment_lock (exclusive_lock_user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_deployment ADD CONSTRAINT FK_sysconfig_deployment_usereb FOREIGN KEY (user_id) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_deployment_user4a ON sysconfig_deployment (user_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE sysconfig_deployment ADD CONSTRAINT FK_sysconfig_deployment_creaf6 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_sysconfig_deployment_creae5 ON sysconfig_deployment (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar ADD CONSTRAINT FK_calendar_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_group_id ON calendar (group_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar ADD CONSTRAINT FK_calendar_create_by_id FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_create_by ON calendar (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar ADD CONSTRAINT FK_calendar_change_by_id FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_change_by ON calendar (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar ADD CONSTRAINT FK_calendar_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_valid_id ON calendar (valid_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar_appointment ADD CONSTRAINT FK_calendar_appointment_cale2e FOREIGN KEY (calendar_id) REFERENCES calendar (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_appointment_cale00 ON calendar_appointment (calendar_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar_appointment ADD CONSTRAINT FK_calendar_appointment_pare56 FOREIGN KEY (parent_id) REFERENCES calendar_appointment (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_appointment_pare1b ON calendar_appointment (parent_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar_appointment ADD CONSTRAINT FK_calendar_appointment_creab6 FOREIGN KEY (create_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_appointment_creae2 ON calendar_appointment (create_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar_appointment ADD CONSTRAINT FK_calendar_appointment_chan95 FOREIGN KEY (change_by) REFERENCES users (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_appointment_chanf7 ON calendar_appointment (change_by)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar_appointment_ticket ADD CONSTRAINT FK_calendar_appointment_tick55 FOREIGN KEY (calendar_id) REFERENCES calendar (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_appointment_tick25 ON calendar_appointment_ticket (calendar_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar_appointment_ticket ADD CONSTRAINT FK_calendar_appointment_tick7c FOREIGN KEY (appointment_id) REFERENCES calendar_appointment (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_appointment_tick4c ON calendar_appointment_ticket (appointment_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE calendar_appointment_ticket ADD CONSTRAINT FK_calendar_appointment_ticka9 FOREIGN KEY (ticket_id) REFERENCES ticket (id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX FK_calendar_appointment_tick5f ON calendar_appointment_ticket (ticket_id)';
EXCEPTION
  WHEN OTHERS THEN NULL;
END;
/
--
;
