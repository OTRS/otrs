-- ----------------------------------------------------------
--  driver: postgresql
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_acl_create_by_id')
    ) THEN
    ALTER TABLE acl ADD CONSTRAINT FK_acl_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_acl_change_by_id')
    ) THEN
    ALTER TABLE acl ADD CONSTRAINT FK_acl_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_acl_valid_id_id')
    ) THEN
    ALTER TABLE acl ADD CONSTRAINT FK_acl_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_valid_create_by_id')
    ) THEN
    ALTER TABLE valid ADD CONSTRAINT FK_valid_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_valid_change_by_id')
    ) THEN
    ALTER TABLE valid ADD CONSTRAINT FK_valid_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_users_create_by_id')
    ) THEN
    ALTER TABLE users ADD CONSTRAINT FK_users_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_users_change_by_id')
    ) THEN
    ALTER TABLE users ADD CONSTRAINT FK_users_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_users_valid_id_id')
    ) THEN
    ALTER TABLE users ADD CONSTRAINT FK_users_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_user_preferences_user_id_id')
    ) THEN
    ALTER TABLE user_preferences ADD CONSTRAINT FK_user_preferences_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_groups_create_by_id')
    ) THEN
    ALTER TABLE groups ADD CONSTRAINT FK_groups_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_groups_change_by_id')
    ) THEN
    ALTER TABLE groups ADD CONSTRAINT FK_groups_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_groups_valid_id_id')
    ) THEN
    ALTER TABLE groups ADD CONSTRAINT FK_groups_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_user_group_id_id')
    ) THEN
    ALTER TABLE group_user ADD CONSTRAINT FK_group_user_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_user_create_by_id')
    ) THEN
    ALTER TABLE group_user ADD CONSTRAINT FK_group_user_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_user_change_by_id')
    ) THEN
    ALTER TABLE group_user ADD CONSTRAINT FK_group_user_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_user_user_id_id')
    ) THEN
    ALTER TABLE group_user ADD CONSTRAINT FK_group_user_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_role_group_id_id')
    ) THEN
    ALTER TABLE group_role ADD CONSTRAINT FK_group_role_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_role_role_id_id')
    ) THEN
    ALTER TABLE group_role ADD CONSTRAINT FK_group_role_role_id_id FOREIGN KEY (role_id) REFERENCES roles (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_role_create_by_id')
    ) THEN
    ALTER TABLE group_role ADD CONSTRAINT FK_group_role_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_role_change_by_id')
    ) THEN
    ALTER TABLE group_role ADD CONSTRAINT FK_group_role_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_customer_user_group_id_id')
    ) THEN
    ALTER TABLE group_customer_user ADD CONSTRAINT FK_group_customer_user_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_customer_user_create_by_id')
    ) THEN
    ALTER TABLE group_customer_user ADD CONSTRAINT FK_group_customer_user_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_customer_user_change_by_id')
    ) THEN
    ALTER TABLE group_customer_user ADD CONSTRAINT FK_group_customer_user_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_customer_group_id_id')
    ) THEN
    ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_customer_create_by_id')
    ) THEN
    ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_group_customer_change_by_id')
    ) THEN
    ALTER TABLE group_customer ADD CONSTRAINT FK_group_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_roles_create_by_id')
    ) THEN
    ALTER TABLE roles ADD CONSTRAINT FK_roles_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_roles_change_by_id')
    ) THEN
    ALTER TABLE roles ADD CONSTRAINT FK_roles_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_roles_valid_id_id')
    ) THEN
    ALTER TABLE roles ADD CONSTRAINT FK_roles_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_role_user_create_by_id')
    ) THEN
    ALTER TABLE role_user ADD CONSTRAINT FK_role_user_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_role_user_change_by_id')
    ) THEN
    ALTER TABLE role_user ADD CONSTRAINT FK_role_user_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_role_user_user_id_id')
    ) THEN
    ALTER TABLE role_user ADD CONSTRAINT FK_role_user_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_personal_queues_queue_id_id')
    ) THEN
    ALTER TABLE personal_queues ADD CONSTRAINT FK_personal_queues_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_personal_queues_user_id_id')
    ) THEN
    ALTER TABLE personal_queues ADD CONSTRAINT FK_personal_queues_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_personal_services_service_id_id')
    ) THEN
    ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_personal_services_user_id_id')
    ) THEN
    ALTER TABLE personal_services ADD CONSTRAINT FK_personal_services_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_salutation_create_by_id')
    ) THEN
    ALTER TABLE salutation ADD CONSTRAINT FK_salutation_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_salutation_change_by_id')
    ) THEN
    ALTER TABLE salutation ADD CONSTRAINT FK_salutation_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_salutation_valid_id_id')
    ) THEN
    ALTER TABLE salutation ADD CONSTRAINT FK_salutation_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_signature_create_by_id')
    ) THEN
    ALTER TABLE signature ADD CONSTRAINT FK_signature_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_signature_change_by_id')
    ) THEN
    ALTER TABLE signature ADD CONSTRAINT FK_signature_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_signature_valid_id_id')
    ) THEN
    ALTER TABLE signature ADD CONSTRAINT FK_signature_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_system_address_create_by_id')
    ) THEN
    ALTER TABLE system_address ADD CONSTRAINT FK_system_address_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_system_address_change_by_id')
    ) THEN
    ALTER TABLE system_address ADD CONSTRAINT FK_system_address_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_system_address_valid_id_id')
    ) THEN
    ALTER TABLE system_address ADD CONSTRAINT FK_system_address_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_system_maintenance_create_by_id')
    ) THEN
    ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_system_maintenance_change_by_id')
    ) THEN
    ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_system_maintenance_valid_id_id')
    ) THEN
    ALTER TABLE system_maintenance ADD CONSTRAINT FK_system_maintenance_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_follow_up_possible_create_by_id')
    ) THEN
    ALTER TABLE follow_up_possible ADD CONSTRAINT FK_follow_up_possible_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_follow_up_possible_change_by_id')
    ) THEN
    ALTER TABLE follow_up_possible ADD CONSTRAINT FK_follow_up_possible_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_follow_up_possible_valid_id_id')
    ) THEN
    ALTER TABLE follow_up_possible ADD CONSTRAINT FK_follow_up_possible_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_follow_up_id_id')
    ) THEN
    ALTER TABLE queue ADD CONSTRAINT FK_queue_follow_up_id_id FOREIGN KEY (follow_up_id) REFERENCES follow_up_possible (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_group_id_id')
    ) THEN
    ALTER TABLE queue ADD CONSTRAINT FK_queue_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_salutation_id_id')
    ) THEN
    ALTER TABLE queue ADD CONSTRAINT FK_queue_salutation_id_id FOREIGN KEY (salutation_id) REFERENCES salutation (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_signature_id_id')
    ) THEN
    ALTER TABLE queue ADD CONSTRAINT FK_queue_signature_id_id FOREIGN KEY (signature_id) REFERENCES signature (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_system_address_id_id')
    ) THEN
    ALTER TABLE queue ADD CONSTRAINT FK_queue_system_address_id_id FOREIGN KEY (system_address_id) REFERENCES system_address (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_create_by_id')
    ) THEN
    ALTER TABLE queue ADD CONSTRAINT FK_queue_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_change_by_id')
    ) THEN
    ALTER TABLE queue ADD CONSTRAINT FK_queue_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_valid_id_id')
    ) THEN
    ALTER TABLE queue ADD CONSTRAINT FK_queue_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_preferences_queue_id_id')
    ) THEN
    ALTER TABLE queue_preferences ADD CONSTRAINT FK_queue_preferences_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_priority_create_by_id')
    ) THEN
    ALTER TABLE ticket_priority ADD CONSTRAINT FK_ticket_priority_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_priority_change_by_id')
    ) THEN
    ALTER TABLE ticket_priority ADD CONSTRAINT FK_ticket_priority_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_type_create_by_id')
    ) THEN
    ALTER TABLE ticket_type ADD CONSTRAINT FK_ticket_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_type_change_by_id')
    ) THEN
    ALTER TABLE ticket_type ADD CONSTRAINT FK_ticket_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_type_valid_id_id')
    ) THEN
    ALTER TABLE ticket_type ADD CONSTRAINT FK_ticket_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_lock_type_create_by_id')
    ) THEN
    ALTER TABLE ticket_lock_type ADD CONSTRAINT FK_ticket_lock_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_lock_type_change_by_id')
    ) THEN
    ALTER TABLE ticket_lock_type ADD CONSTRAINT FK_ticket_lock_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_lock_type_valid_id_id')
    ) THEN
    ALTER TABLE ticket_lock_type ADD CONSTRAINT FK_ticket_lock_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_state_type_id_id')
    ) THEN
    ALTER TABLE ticket_state ADD CONSTRAINT FK_ticket_state_type_id_id FOREIGN KEY (type_id) REFERENCES ticket_state_type (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_state_create_by_id')
    ) THEN
    ALTER TABLE ticket_state ADD CONSTRAINT FK_ticket_state_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_state_change_by_id')
    ) THEN
    ALTER TABLE ticket_state ADD CONSTRAINT FK_ticket_state_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_state_valid_id_id')
    ) THEN
    ALTER TABLE ticket_state ADD CONSTRAINT FK_ticket_state_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_state_type_create_by_id')
    ) THEN
    ALTER TABLE ticket_state_type ADD CONSTRAINT FK_ticket_state_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_state_type_change_by_id')
    ) THEN
    ALTER TABLE ticket_state_type ADD CONSTRAINT FK_ticket_state_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_queue_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_service_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_sla_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_ticket_lock_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_ticket_lock_id_id FOREIGN KEY (ticket_lock_id) REFERENCES ticket_lock_type (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_ticket_priority_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_ticket_priority_id_id FOREIGN KEY (ticket_priority_id) REFERENCES ticket_priority (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_ticket_state_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_ticket_state_id_id FOREIGN KEY (ticket_state_id) REFERENCES ticket_state (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_type_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_type_id_id FOREIGN KEY (type_id) REFERENCES ticket_type (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_create_by_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_change_by_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_user_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_responsible_user_id_id')
    ) THEN
    ALTER TABLE ticket ADD CONSTRAINT FK_ticket_responsible_user_id_id FOREIGN KEY (responsible_user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_flag_ticket_id_id')
    ) THEN
    ALTER TABLE ticket_flag ADD CONSTRAINT FK_ticket_flag_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_flag_create_by_id')
    ) THEN
    ALTER TABLE ticket_flag ADD CONSTRAINT FK_ticket_flag_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_article_id_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_queue_id_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_ticket_id_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_history_type_id_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_history_type_id_id FOREIGN KEY (history_type_id) REFERENCES ticket_history_type (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_priority_id_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_priority_id_id FOREIGN KEY (priority_id) REFERENCES ticket_priority (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_state_id_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_state_id_id FOREIGN KEY (state_id) REFERENCES ticket_state (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_type_id_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_type_id_id FOREIGN KEY (type_id) REFERENCES ticket_type (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_owner_id_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_owner_id_id FOREIGN KEY (owner_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_create_by_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_change_by_id')
    ) THEN
    ALTER TABLE ticket_history ADD CONSTRAINT FK_ticket_history_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_type_create_by_id')
    ) THEN
    ALTER TABLE ticket_history_type ADD CONSTRAINT FK_ticket_history_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_type_change_by_id')
    ) THEN
    ALTER TABLE ticket_history_type ADD CONSTRAINT FK_ticket_history_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_history_type_valid_id_id')
    ) THEN
    ALTER TABLE ticket_history_type ADD CONSTRAINT FK_ticket_history_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_watcher_ticket_id_id')
    ) THEN
    ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_watcher_user_id_id')
    ) THEN
    ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_watcher_create_by_id')
    ) THEN
    ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_watcher_change_by_id')
    ) THEN
    ALTER TABLE ticket_watcher ADD CONSTRAINT FK_ticket_watcher_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_index_group_id_id')
    ) THEN
    ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_index_queue_id_id')
    ) THEN
    ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_index_ticket_id_id')
    ) THEN
    ALTER TABLE ticket_index ADD CONSTRAINT FK_ticket_index_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_ticket_lock_index_ticket_id_id')
    ) THEN
    ALTER TABLE ticket_lock_index ADD CONSTRAINT FK_ticket_lock_index_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_sender_type_create_by_id')
    ) THEN
    ALTER TABLE article_sender_type ADD CONSTRAINT FK_article_sender_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_sender_type_change_by_id')
    ) THEN
    ALTER TABLE article_sender_type ADD CONSTRAINT FK_article_sender_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_sender_type_valid_id_id')
    ) THEN
    ALTER TABLE article_sender_type ADD CONSTRAINT FK_article_sender_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_flag_article_id_id')
    ) THEN
    ALTER TABLE article_flag ADD CONSTRAINT FK_article_flag_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_flag_create_by_id')
    ) THEN
    ALTER TABLE article_flag ADD CONSTRAINT FK_article_flag_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_communication_channel_create_by_id')
    ) THEN
    ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_communication_channel_change_by_id')
    ) THEN
    ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_communication_channel_valid_id_id')
    ) THEN
    ALTER TABLE communication_channel ADD CONSTRAINT FK_communication_channel_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_article_sender_type_id_id')
    ) THEN
    ALTER TABLE article ADD CONSTRAINT FK_article_article_sender_type_id_id FOREIGN KEY (article_sender_type_id) REFERENCES article_sender_type (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_communication_channel_id_id')
    ) THEN
    ALTER TABLE article ADD CONSTRAINT FK_article_communication_channel_id_id FOREIGN KEY (communication_channel_id) REFERENCES communication_channel (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_ticket_id_id')
    ) THEN
    ALTER TABLE article ADD CONSTRAINT FK_article_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_create_by_id')
    ) THEN
    ALTER TABLE article ADD CONSTRAINT FK_article_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_change_by_id')
    ) THEN
    ALTER TABLE article ADD CONSTRAINT FK_article_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_article_id_id')
    ) THEN
    ALTER TABLE article_data_mime ADD CONSTRAINT FK_article_data_mime_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_create_by_id')
    ) THEN
    ALTER TABLE article_data_mime ADD CONSTRAINT FK_article_data_mime_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_change_by_id')
    ) THEN
    ALTER TABLE article_data_mime ADD CONSTRAINT FK_article_data_mime_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_search_index_article_id_id')
    ) THEN
    ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_search_index_ticket_id_id')
    ) THEN
    ALTER TABLE article_search_index ADD CONSTRAINT FK_article_search_index_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_plain_article_id_id')
    ) THEN
    ALTER TABLE article_data_mime_plain ADD CONSTRAINT FK_article_data_mime_plain_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_plain_create_by_id')
    ) THEN
    ALTER TABLE article_data_mime_plain ADD CONSTRAINT FK_article_data_mime_plain_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_plain_change_by_id')
    ) THEN
    ALTER TABLE article_data_mime_plain ADD CONSTRAINT FK_article_data_mime_plain_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_attachment_article_id_id')
    ) THEN
    ALTER TABLE article_data_mime_attachment ADD CONSTRAINT FK_article_data_mime_attachment_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_attachment_create_by_id')
    ) THEN
    ALTER TABLE article_data_mime_attachment ADD CONSTRAINT FK_article_data_mime_attachment_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_attachment_change_by_id')
    ) THEN
    ALTER TABLE article_data_mime_attachment ADD CONSTRAINT FK_article_data_mime_attachment_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_mime_send_error_article_id_id')
    ) THEN
    ALTER TABLE article_data_mime_send_error ADD CONSTRAINT FK_article_data_mime_send_error_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_article_data_otrs_chat_article_id_id')
    ) THEN
    ALTER TABLE article_data_otrs_chat ADD CONSTRAINT FK_article_data_otrs_chat_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_time_accounting_article_id_id')
    ) THEN
    ALTER TABLE time_accounting ADD CONSTRAINT FK_time_accounting_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_time_accounting_ticket_id_id')
    ) THEN
    ALTER TABLE time_accounting ADD CONSTRAINT FK_time_accounting_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_time_accounting_create_by_id')
    ) THEN
    ALTER TABLE time_accounting ADD CONSTRAINT FK_time_accounting_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_time_accounting_change_by_id')
    ) THEN
    ALTER TABLE time_accounting ADD CONSTRAINT FK_time_accounting_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_template_create_by_id')
    ) THEN
    ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_template_change_by_id')
    ) THEN
    ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_template_valid_id_id')
    ) THEN
    ALTER TABLE standard_template ADD CONSTRAINT FK_standard_template_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_standard_template_queue_id_id')
    ) THEN
    ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_standard_template_standard_template_id_id')
    ) THEN
    ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_standard_template_id_id FOREIGN KEY (standard_template_id) REFERENCES standard_template (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_standard_template_create_by_id')
    ) THEN
    ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_standard_template_change_by_id')
    ) THEN
    ALTER TABLE queue_standard_template ADD CONSTRAINT FK_queue_standard_template_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_attachment_create_by_id')
    ) THEN
    ALTER TABLE standard_attachment ADD CONSTRAINT FK_standard_attachment_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_attachment_change_by_id')
    ) THEN
    ALTER TABLE standard_attachment ADD CONSTRAINT FK_standard_attachment_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_attachment_valid_id_id')
    ) THEN
    ALTER TABLE standard_attachment ADD CONSTRAINT FK_standard_attachment_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_template_attachment_standard_attachment_id_id')
    ) THEN
    ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_standard_attachment_id_id FOREIGN KEY (standard_attachment_id) REFERENCES standard_attachment (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_template_attachment_standard_template_id_id')
    ) THEN
    ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_standard_template_id_id FOREIGN KEY (standard_template_id) REFERENCES standard_template (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_template_attachment_create_by_id')
    ) THEN
    ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_standard_template_attachment_change_by_id')
    ) THEN
    ALTER TABLE standard_template_attachment ADD CONSTRAINT FK_standard_template_attachment_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_auto_response_type_create_by_id')
    ) THEN
    ALTER TABLE auto_response_type ADD CONSTRAINT FK_auto_response_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_auto_response_type_change_by_id')
    ) THEN
    ALTER TABLE auto_response_type ADD CONSTRAINT FK_auto_response_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_auto_response_type_valid_id_id')
    ) THEN
    ALTER TABLE auto_response_type ADD CONSTRAINT FK_auto_response_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_auto_response_type_id_id')
    ) THEN
    ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_type_id_id FOREIGN KEY (type_id) REFERENCES auto_response_type (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_auto_response_system_address_id_id')
    ) THEN
    ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_system_address_id_id FOREIGN KEY (system_address_id) REFERENCES system_address (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_auto_response_create_by_id')
    ) THEN
    ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_auto_response_change_by_id')
    ) THEN
    ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_auto_response_valid_id_id')
    ) THEN
    ALTER TABLE auto_response ADD CONSTRAINT FK_auto_response_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_auto_response_auto_response_id_id')
    ) THEN
    ALTER TABLE queue_auto_response ADD CONSTRAINT FK_queue_auto_response_auto_response_id_id FOREIGN KEY (auto_response_id) REFERENCES auto_response (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_auto_response_queue_id_id')
    ) THEN
    ALTER TABLE queue_auto_response ADD CONSTRAINT FK_queue_auto_response_queue_id_id FOREIGN KEY (queue_id) REFERENCES queue (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_auto_response_create_by_id')
    ) THEN
    ALTER TABLE queue_auto_response ADD CONSTRAINT FK_queue_auto_response_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_queue_auto_response_change_by_id')
    ) THEN
    ALTER TABLE queue_auto_response ADD CONSTRAINT FK_queue_auto_response_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_service_create_by_id')
    ) THEN
    ALTER TABLE service ADD CONSTRAINT FK_service_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_service_change_by_id')
    ) THEN
    ALTER TABLE service ADD CONSTRAINT FK_service_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_service_preferences_service_id_id')
    ) THEN
    ALTER TABLE service_preferences ADD CONSTRAINT FK_service_preferences_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_service_customer_user_service_id_id')
    ) THEN
    ALTER TABLE service_customer_user ADD CONSTRAINT FK_service_customer_user_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_service_customer_user_create_by_id')
    ) THEN
    ALTER TABLE service_customer_user ADD CONSTRAINT FK_service_customer_user_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sla_create_by_id')
    ) THEN
    ALTER TABLE sla ADD CONSTRAINT FK_sla_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sla_change_by_id')
    ) THEN
    ALTER TABLE sla ADD CONSTRAINT FK_sla_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sla_preferences_sla_id_id')
    ) THEN
    ALTER TABLE sla_preferences ADD CONSTRAINT FK_sla_preferences_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_service_sla_service_id_id')
    ) THEN
    ALTER TABLE service_sla ADD CONSTRAINT FK_service_sla_service_id_id FOREIGN KEY (service_id) REFERENCES service (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_service_sla_sla_id_id')
    ) THEN
    ALTER TABLE service_sla ADD CONSTRAINT FK_service_sla_sla_id_id FOREIGN KEY (sla_id) REFERENCES sla (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_customer_user_create_by_id')
    ) THEN
    ALTER TABLE customer_user ADD CONSTRAINT FK_customer_user_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_customer_user_change_by_id')
    ) THEN
    ALTER TABLE customer_user ADD CONSTRAINT FK_customer_user_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_customer_user_valid_id_id')
    ) THEN
    ALTER TABLE customer_user ADD CONSTRAINT FK_customer_user_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_customer_user_customer_create_by_id')
    ) THEN
    ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_customer_user_customer_change_by_id')
    ) THEN
    ALTER TABLE customer_user_customer ADD CONSTRAINT FK_customer_user_customer_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_mail_account_create_by_id')
    ) THEN
    ALTER TABLE mail_account ADD CONSTRAINT FK_mail_account_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_mail_account_change_by_id')
    ) THEN
    ALTER TABLE mail_account ADD CONSTRAINT FK_mail_account_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_mail_account_valid_id_id')
    ) THEN
    ALTER TABLE mail_account ADD CONSTRAINT FK_mail_account_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_notification_event_create_by_id')
    ) THEN
    ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_notification_event_change_by_id')
    ) THEN
    ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_notification_event_valid_id_id')
    ) THEN
    ALTER TABLE notification_event ADD CONSTRAINT FK_notification_event_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_notification_event_message_notification_id_id')
    ) THEN
    ALTER TABLE notification_event_message ADD CONSTRAINT FK_notification_event_message_notification_id_id FOREIGN KEY (notification_id) REFERENCES notification_event (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_notification_event_item_notification_id_id')
    ) THEN
    ALTER TABLE notification_event_item ADD CONSTRAINT FK_notification_event_item_notification_id_id FOREIGN KEY (notification_id) REFERENCES notification_event (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_type_create_by_id')
    ) THEN
    ALTER TABLE link_type ADD CONSTRAINT FK_link_type_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_type_change_by_id')
    ) THEN
    ALTER TABLE link_type ADD CONSTRAINT FK_link_type_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_type_valid_id_id')
    ) THEN
    ALTER TABLE link_type ADD CONSTRAINT FK_link_type_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_state_create_by_id')
    ) THEN
    ALTER TABLE link_state ADD CONSTRAINT FK_link_state_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_state_change_by_id')
    ) THEN
    ALTER TABLE link_state ADD CONSTRAINT FK_link_state_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_state_valid_id_id')
    ) THEN
    ALTER TABLE link_state ADD CONSTRAINT FK_link_state_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_relation_source_object_id_id')
    ) THEN
    ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_source_object_id_id FOREIGN KEY (source_object_id) REFERENCES link_object (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_relation_target_object_id_id')
    ) THEN
    ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_target_object_id_id FOREIGN KEY (target_object_id) REFERENCES link_object (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_relation_state_id_id')
    ) THEN
    ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_state_id_id FOREIGN KEY (state_id) REFERENCES link_state (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_relation_type_id_id')
    ) THEN
    ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_type_id_id FOREIGN KEY (type_id) REFERENCES link_type (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_link_relation_create_by_id')
    ) THEN
    ALTER TABLE link_relation ADD CONSTRAINT FK_link_relation_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_system_data_create_by_id')
    ) THEN
    ALTER TABLE system_data ADD CONSTRAINT FK_system_data_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_system_data_change_by_id')
    ) THEN
    ALTER TABLE system_data ADD CONSTRAINT FK_system_data_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_virtual_fs_preferences_virtual_fs_id_id')
    ) THEN
    ALTER TABLE virtual_fs_preferences ADD CONSTRAINT FK_virtual_fs_preferences_virtual_fs_id_id FOREIGN KEY (virtual_fs_id) REFERENCES virtual_fs (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_package_repository_create_by_id')
    ) THEN
    ALTER TABLE package_repository ADD CONSTRAINT FK_package_repository_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_package_repository_change_by_id')
    ) THEN
    ALTER TABLE package_repository ADD CONSTRAINT FK_package_repository_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_gi_webservice_config_create_by_id')
    ) THEN
    ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_gi_webservice_config_change_by_id')
    ) THEN
    ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_gi_webservice_config_valid_id_id')
    ) THEN
    ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_gi_webservice_config_history_config_id_id')
    ) THEN
    ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_config_id_id FOREIGN KEY (config_id) REFERENCES gi_webservice_config (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_gi_webservice_config_history_create_by_id')
    ) THEN
    ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_gi_webservice_config_history_change_by_id')
    ) THEN
    ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_history_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_gi_debugger_entry_webservice_id_id')
    ) THEN
    ALTER TABLE gi_debugger_entry ADD CONSTRAINT FK_gi_debugger_entry_webservice_id_id FOREIGN KEY (webservice_id) REFERENCES gi_webservice_config (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_gi_debugger_entry_content_gi_debugger_entry_id_id')
    ) THEN
    ALTER TABLE gi_debugger_entry_content ADD CONSTRAINT FK_gi_debugger_entry_content_gi_debugger_entry_id_id FOREIGN KEY (gi_debugger_entry_id) REFERENCES gi_debugger_entry (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_smime_signer_cert_relations_create_by_id')
    ) THEN
    ALTER TABLE smime_signer_cert_relations ADD CONSTRAINT FK_smime_signer_cert_relations_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_smime_signer_cert_relations_change_by_id')
    ) THEN
    ALTER TABLE smime_signer_cert_relations ADD CONSTRAINT FK_smime_signer_cert_relations_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_dynamic_field_value_field_id_id')
    ) THEN
    ALTER TABLE dynamic_field_value ADD CONSTRAINT FK_dynamic_field_value_field_id_id FOREIGN KEY (field_id) REFERENCES dynamic_field (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_dynamic_field_create_by_id')
    ) THEN
    ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_dynamic_field_change_by_id')
    ) THEN
    ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_dynamic_field_valid_id_id')
    ) THEN
    ALTER TABLE dynamic_field ADD CONSTRAINT FK_dynamic_field_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_process_create_by_id')
    ) THEN
    ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_process_change_by_id')
    ) THEN
    ALTER TABLE pm_process ADD CONSTRAINT FK_pm_process_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_activity_create_by_id')
    ) THEN
    ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_activity_change_by_id')
    ) THEN
    ALTER TABLE pm_activity ADD CONSTRAINT FK_pm_activity_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_activity_dialog_create_by_id')
    ) THEN
    ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_activity_dialog_change_by_id')
    ) THEN
    ALTER TABLE pm_activity_dialog ADD CONSTRAINT FK_pm_activity_dialog_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_transition_create_by_id')
    ) THEN
    ALTER TABLE pm_transition ADD CONSTRAINT FK_pm_transition_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_transition_change_by_id')
    ) THEN
    ALTER TABLE pm_transition ADD CONSTRAINT FK_pm_transition_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_transition_action_create_by_id')
    ) THEN
    ALTER TABLE pm_transition_action ADD CONSTRAINT FK_pm_transition_action_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_pm_transition_action_change_by_id')
    ) THEN
    ALTER TABLE pm_transition_action ADD CONSTRAINT FK_pm_transition_action_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_cloud_service_config_create_by_id')
    ) THEN
    ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_cloud_service_config_change_by_id')
    ) THEN
    ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_cloud_service_config_valid_id_id')
    ) THEN
    ALTER TABLE cloud_service_config ADD CONSTRAINT FK_cloud_service_config_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_default_create_by_id')
    ) THEN
    ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_default_change_by_id')
    ) THEN
    ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_default_exclusive_lock_user_id_id')
    ) THEN
    ALTER TABLE sysconfig_default ADD CONSTRAINT FK_sysconfig_default_exclusive_lock_user_id_id FOREIGN KEY (exclusive_lock_user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_default_version_sysconfig_default_id_id')
    ) THEN
    ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version_sysconfig_default_id_id FOREIGN KEY (sysconfig_default_id) REFERENCES sysconfig_default (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_default_version_create_by_id')
    ) THEN
    ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_default_version_change_by_id')
    ) THEN
    ALTER TABLE sysconfig_default_version ADD CONSTRAINT FK_sysconfig_default_version_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_modified_sysconfig_default_id_id')
    ) THEN
    ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_sysconfig_default_id_id FOREIGN KEY (sysconfig_default_id) REFERENCES sysconfig_default (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_modified_user_id_id')
    ) THEN
    ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_modified_create_by_id')
    ) THEN
    ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_modified_change_by_id')
    ) THEN
    ALTER TABLE sysconfig_modified ADD CONSTRAINT FK_sysconfig_modified_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_modified_version_sysconfig_default_version_idaf')
    ) THEN
    ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_version_sysconfig_default_version_idaf FOREIGN KEY (sysconfig_default_version_id) REFERENCES sysconfig_default_version (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_modified_version_user_id_id')
    ) THEN
    ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_version_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_modified_version_create_by_id')
    ) THEN
    ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_version_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_modified_version_change_by_id')
    ) THEN
    ALTER TABLE sysconfig_modified_version ADD CONSTRAINT FK_sysconfig_modified_version_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_deployment_lock_exclusive_lock_user_id_id')
    ) THEN
    ALTER TABLE sysconfig_deployment_lock ADD CONSTRAINT FK_sysconfig_deployment_lock_exclusive_lock_user_id_id FOREIGN KEY (exclusive_lock_user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_deployment_user_id_id')
    ) THEN
    ALTER TABLE sysconfig_deployment ADD CONSTRAINT FK_sysconfig_deployment_user_id_id FOREIGN KEY (user_id) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_sysconfig_deployment_create_by_id')
    ) THEN
    ALTER TABLE sysconfig_deployment ADD CONSTRAINT FK_sysconfig_deployment_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_group_id_id')
    ) THEN
    ALTER TABLE calendar ADD CONSTRAINT FK_calendar_group_id_id FOREIGN KEY (group_id) REFERENCES groups (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_create_by_id')
    ) THEN
    ALTER TABLE calendar ADD CONSTRAINT FK_calendar_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_change_by_id')
    ) THEN
    ALTER TABLE calendar ADD CONSTRAINT FK_calendar_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_valid_id_id')
    ) THEN
    ALTER TABLE calendar ADD CONSTRAINT FK_calendar_valid_id_id FOREIGN KEY (valid_id) REFERENCES valid (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_appointment_calendar_id_id')
    ) THEN
    ALTER TABLE calendar_appointment ADD CONSTRAINT FK_calendar_appointment_calendar_id_id FOREIGN KEY (calendar_id) REFERENCES calendar (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_appointment_parent_id_id')
    ) THEN
    ALTER TABLE calendar_appointment ADD CONSTRAINT FK_calendar_appointment_parent_id_id FOREIGN KEY (parent_id) REFERENCES calendar_appointment (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_appointment_create_by_id')
    ) THEN
    ALTER TABLE calendar_appointment ADD CONSTRAINT FK_calendar_appointment_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_appointment_change_by_id')
    ) THEN
    ALTER TABLE calendar_appointment ADD CONSTRAINT FK_calendar_appointment_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_appointment_ticket_calendar_id_id')
    ) THEN
    ALTER TABLE calendar_appointment_ticket ADD CONSTRAINT FK_calendar_appointment_ticket_calendar_id_id FOREIGN KEY (calendar_id) REFERENCES calendar (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_appointment_ticket_appointment_id_id')
    ) THEN
    ALTER TABLE calendar_appointment_ticket ADD CONSTRAINT FK_calendar_appointment_ticket_appointment_id_id FOREIGN KEY (appointment_id) REFERENCES calendar_appointment (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_calendar_appointment_ticket_ticket_id_id')
    ) THEN
    ALTER TABLE calendar_appointment_ticket ADD CONSTRAINT FK_calendar_appointment_ticket_ticket_id_id FOREIGN KEY (ticket_id) REFERENCES ticket (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_mail_queue_article_id_id')
    ) THEN
    ALTER TABLE mail_queue ADD CONSTRAINT FK_mail_queue_article_id_id FOREIGN KEY (article_id) REFERENCES article (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_communication_log_object_communication_id_id')
    ) THEN
    ALTER TABLE communication_log_object ADD CONSTRAINT FK_communication_log_object_communication_id_id FOREIGN KEY (communication_id) REFERENCES communication_log (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_communication_log_object_entry_communication_log_objectaa')
    ) THEN
    ALTER TABLE communication_log_object_entry ADD CONSTRAINT FK_communication_log_object_entry_communication_log_objectaa FOREIGN KEY (communication_log_object_id) REFERENCES communication_log_object (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_communication_log_obj_lookup_communication_log_object_i0f')
    ) THEN
    ALTER TABLE communication_log_obj_lookup ADD CONSTRAINT FK_communication_log_obj_lookup_communication_log_object_i0f FOREIGN KEY (communication_log_object_id) REFERENCES communication_log_object (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_form_draft_create_by_id')
    ) THEN
    ALTER TABLE form_draft ADD CONSTRAINT FK_form_draft_create_by_id FOREIGN KEY (create_by) REFERENCES users (id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_constraint
    WHERE LOWER(conname) = LOWER('FK_form_draft_change_by_id')
    ) THEN
    ALTER TABLE form_draft ADD CONSTRAINT FK_form_draft_change_by_id FOREIGN KEY (change_by) REFERENCES users (id);
END IF;
END$$;
;
