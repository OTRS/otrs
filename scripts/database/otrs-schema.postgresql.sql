-- ----------------------------------------------------------
--  driver: postgresql
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
-- ----------------------------------------------------------
--  create table acl
-- ----------------------------------------------------------
CREATE TABLE acl (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    description VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    stop_after_match SMALLINT NULL,
    config_match TEXT NULL,
    config_change TEXT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT acl_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table acl_sync
-- ----------------------------------------------------------
CREATE TABLE acl_sync (
    acl_id VARCHAR (200) NOT NULL,
    sync_state VARCHAR (30) NOT NULL,
    create_time timestamp(0) NOT NULL,
    change_time timestamp(0) NOT NULL
);
-- ----------------------------------------------------------
--  create table valid
-- ----------------------------------------------------------
CREATE TABLE valid (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT valid_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table users
-- ----------------------------------------------------------
CREATE TABLE users (
    id serial NOT NULL,
    login VARCHAR (200) NOT NULL,
    pw VARCHAR (128) NOT NULL,
    title VARCHAR (50) NULL,
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT users_login UNIQUE (login)
);
-- ----------------------------------------------------------
--  create table user_preferences
-- ----------------------------------------------------------
CREATE TABLE user_preferences (
    user_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value TEXT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('user_preferences_user_id')
    ) THEN
    CREATE INDEX user_preferences_user_id ON user_preferences (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table groups
-- ----------------------------------------------------------
CREATE TABLE groups (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT groups_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table group_user
-- ----------------------------------------------------------
CREATE TABLE group_user (
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('group_user_group_id')
    ) THEN
    CREATE INDEX group_user_group_id ON group_user (group_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('group_user_user_id')
    ) THEN
    CREATE INDEX group_user_user_id ON group_user (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table group_role
-- ----------------------------------------------------------
CREATE TABLE group_role (
    role_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('group_role_group_id')
    ) THEN
    CREATE INDEX group_role_group_id ON group_role (group_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('group_role_role_id')
    ) THEN
    CREATE INDEX group_role_role_id ON group_role (role_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table group_customer_user
-- ----------------------------------------------------------
CREATE TABLE group_customer_user (
    user_id VARCHAR (100) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('group_customer_user_group_id')
    ) THEN
    CREATE INDEX group_customer_user_group_id ON group_customer_user (group_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('group_customer_user_user_id')
    ) THEN
    CREATE INDEX group_customer_user_user_id ON group_customer_user (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table group_customer
-- ----------------------------------------------------------
CREATE TABLE group_customer (
    customer_id VARCHAR (150) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    permission_context VARCHAR (100) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('group_customer_customer_id')
    ) THEN
    CREATE INDEX group_customer_customer_id ON group_customer (customer_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('group_customer_group_id')
    ) THEN
    CREATE INDEX group_customer_group_id ON group_customer (group_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table roles
-- ----------------------------------------------------------
CREATE TABLE roles (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT roles_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table role_user
-- ----------------------------------------------------------
CREATE TABLE role_user (
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('role_user_role_id')
    ) THEN
    CREATE INDEX role_user_role_id ON role_user (role_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('role_user_user_id')
    ) THEN
    CREATE INDEX role_user_user_id ON role_user (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table personal_queues
-- ----------------------------------------------------------
CREATE TABLE personal_queues (
    user_id INTEGER NOT NULL,
    queue_id INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('personal_queues_queue_id')
    ) THEN
    CREATE INDEX personal_queues_queue_id ON personal_queues (queue_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('personal_queues_user_id')
    ) THEN
    CREATE INDEX personal_queues_user_id ON personal_queues (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table personal_services
-- ----------------------------------------------------------
CREATE TABLE personal_services (
    user_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('personal_services_service_id')
    ) THEN
    CREATE INDEX personal_services_service_id ON personal_services (service_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('personal_services_user_id')
    ) THEN
    CREATE INDEX personal_services_user_id ON personal_services (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table salutation
-- ----------------------------------------------------------
CREATE TABLE salutation (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    text VARCHAR (3000) NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT salutation_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table signature
-- ----------------------------------------------------------
CREATE TABLE signature (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    text VARCHAR (3000) NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT signature_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table system_address
-- ----------------------------------------------------------
CREATE TABLE system_address (
    id serial NOT NULL,
    value0 VARCHAR (200) NOT NULL,
    value1 VARCHAR (200) NOT NULL,
    value2 VARCHAR (200) NULL,
    value3 VARCHAR (200) NULL,
    queue_id INTEGER NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table system_maintenance
-- ----------------------------------------------------------
CREATE TABLE system_maintenance (
    id serial NOT NULL,
    start_date INTEGER NOT NULL,
    stop_date INTEGER NOT NULL,
    comments VARCHAR (250) NOT NULL,
    login_message VARCHAR (250) NULL,
    show_login_message SMALLINT NULL,
    notify_message VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table follow_up_possible
-- ----------------------------------------------------------
CREATE TABLE follow_up_possible (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT follow_up_possible_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table queue
-- ----------------------------------------------------------
CREATE TABLE queue (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    group_id INTEGER NOT NULL,
    unlock_timeout INTEGER NULL,
    first_response_time INTEGER NULL,
    first_response_notify SMALLINT NULL,
    update_time INTEGER NULL,
    update_notify SMALLINT NULL,
    solution_time INTEGER NULL,
    solution_notify SMALLINT NULL,
    system_address_id SMALLINT NOT NULL,
    calendar_name VARCHAR (100) NULL,
    default_sign_key VARCHAR (100) NULL,
    salutation_id SMALLINT NOT NULL,
    signature_id SMALLINT NOT NULL,
    follow_up_id SMALLINT NOT NULL,
    follow_up_lock SMALLINT NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT queue_name UNIQUE (name)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('queue_group_id')
    ) THEN
    CREATE INDEX queue_group_id ON queue (group_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table queue_preferences
-- ----------------------------------------------------------
CREATE TABLE queue_preferences (
    queue_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('queue_preferences_queue_id')
    ) THEN
    CREATE INDEX queue_preferences_queue_id ON queue_preferences (queue_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table ticket_priority
-- ----------------------------------------------------------
CREATE TABLE ticket_priority (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_priority_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_type
-- ----------------------------------------------------------
CREATE TABLE ticket_type (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_lock_type
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_type (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_lock_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_state
-- ----------------------------------------------------------
CREATE TABLE ticket_state (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    type_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_state_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_state_type
-- ----------------------------------------------------------
CREATE TABLE ticket_state_type (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_state_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket
-- ----------------------------------------------------------
CREATE TABLE ticket (
    id bigserial NOT NULL,
    tn VARCHAR (50) NOT NULL,
    title VARCHAR (255) NULL,
    queue_id INTEGER NOT NULL,
    ticket_lock_id SMALLINT NOT NULL,
    type_id SMALLINT NULL,
    service_id INTEGER NULL,
    sla_id INTEGER NULL,
    user_id INTEGER NOT NULL,
    responsible_user_id INTEGER NOT NULL,
    ticket_priority_id SMALLINT NOT NULL,
    ticket_state_id SMALLINT NOT NULL,
    customer_id VARCHAR (150) NULL,
    customer_user_id VARCHAR (250) NULL,
    timeout INTEGER NOT NULL,
    until_time INTEGER NOT NULL,
    escalation_time INTEGER NOT NULL,
    escalation_update_time INTEGER NOT NULL,
    escalation_response_time INTEGER NOT NULL,
    escalation_solution_time INTEGER NOT NULL,
    archive_flag SMALLINT DEFAULT 0 NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_tn UNIQUE (tn)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_archive_flag')
    ) THEN
    CREATE INDEX ticket_archive_flag ON ticket (archive_flag);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_create_time')
    ) THEN
    CREATE INDEX ticket_create_time ON ticket (create_time);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_customer_id')
    ) THEN
    CREATE INDEX ticket_customer_id ON ticket (customer_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_customer_user_id')
    ) THEN
    CREATE INDEX ticket_customer_user_id ON ticket (customer_user_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_escalation_response_time')
    ) THEN
    CREATE INDEX ticket_escalation_response_time ON ticket (escalation_response_time);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_escalation_solution_time')
    ) THEN
    CREATE INDEX ticket_escalation_solution_time ON ticket (escalation_solution_time);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_escalation_time')
    ) THEN
    CREATE INDEX ticket_escalation_time ON ticket (escalation_time);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_escalation_update_time')
    ) THEN
    CREATE INDEX ticket_escalation_update_time ON ticket (escalation_update_time);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_queue_id')
    ) THEN
    CREATE INDEX ticket_queue_id ON ticket (queue_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_queue_view')
    ) THEN
    CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_responsible_user_id')
    ) THEN
    CREATE INDEX ticket_responsible_user_id ON ticket (responsible_user_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_ticket_lock_id')
    ) THEN
    CREATE INDEX ticket_ticket_lock_id ON ticket (ticket_lock_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_ticket_priority_id')
    ) THEN
    CREATE INDEX ticket_ticket_priority_id ON ticket (ticket_priority_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_ticket_state_id')
    ) THEN
    CREATE INDEX ticket_ticket_state_id ON ticket (ticket_state_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_timeout')
    ) THEN
    CREATE INDEX ticket_timeout ON ticket (timeout);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_title')
    ) THEN
    CREATE INDEX ticket_title ON ticket (title);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_type_id')
    ) THEN
    CREATE INDEX ticket_type_id ON ticket (type_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_until_time')
    ) THEN
    CREATE INDEX ticket_until_time ON ticket (until_time);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_user_id')
    ) THEN
    CREATE INDEX ticket_user_id ON ticket (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table ticket_flag
-- ----------------------------------------------------------
CREATE TABLE ticket_flag (
    ticket_id BIGINT NOT NULL,
    ticket_key VARCHAR (50) NOT NULL,
    ticket_value VARCHAR (50) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    CONSTRAINT ticket_flag_per_user UNIQUE (ticket_id, ticket_key, create_by)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_flag_ticket_id')
    ) THEN
    CREATE INDEX ticket_flag_ticket_id ON ticket_flag (ticket_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_flag_ticket_id_create_by')
    ) THEN
    CREATE INDEX ticket_flag_ticket_id_create_by ON ticket_flag (ticket_id, create_by);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_flag_ticket_id_ticket_key')
    ) THEN
    CREATE INDEX ticket_flag_ticket_id_ticket_key ON ticket_flag (ticket_id, ticket_key);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table ticket_history
-- ----------------------------------------------------------
CREATE TABLE ticket_history (
    id bigserial NOT NULL,
    name VARCHAR (200) NOT NULL,
    history_type_id SMALLINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NULL,
    type_id SMALLINT NOT NULL,
    queue_id INTEGER NOT NULL,
    owner_id INTEGER NOT NULL,
    priority_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_article_id')
    ) THEN
    CREATE INDEX ticket_history_article_id ON ticket_history (article_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_create_time')
    ) THEN
    CREATE INDEX ticket_history_create_time ON ticket_history (create_time);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_history_type_id')
    ) THEN
    CREATE INDEX ticket_history_history_type_id ON ticket_history (history_type_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_owner_id')
    ) THEN
    CREATE INDEX ticket_history_owner_id ON ticket_history (owner_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_priority_id')
    ) THEN
    CREATE INDEX ticket_history_priority_id ON ticket_history (priority_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_queue_id')
    ) THEN
    CREATE INDEX ticket_history_queue_id ON ticket_history (queue_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_state_id')
    ) THEN
    CREATE INDEX ticket_history_state_id ON ticket_history (state_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_ticket_id')
    ) THEN
    CREATE INDEX ticket_history_ticket_id ON ticket_history (ticket_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_history_type_id')
    ) THEN
    CREATE INDEX ticket_history_type_id ON ticket_history (type_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table ticket_history_type
-- ----------------------------------------------------------
CREATE TABLE ticket_history_type (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_history_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_watcher
-- ----------------------------------------------------------
CREATE TABLE ticket_watcher (
    ticket_id BIGINT NOT NULL,
    user_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_watcher_ticket_id')
    ) THEN
    CREATE INDEX ticket_watcher_ticket_id ON ticket_watcher (ticket_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_watcher_user_id')
    ) THEN
    CREATE INDEX ticket_watcher_user_id ON ticket_watcher (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table ticket_index
-- ----------------------------------------------------------
CREATE TABLE ticket_index (
    ticket_id BIGINT NOT NULL,
    queue_id INTEGER NOT NULL,
    queue VARCHAR (200) NOT NULL,
    group_id INTEGER NOT NULL,
    s_lock VARCHAR (200) NOT NULL,
    s_state VARCHAR (200) NOT NULL,
    create_time timestamp(0) NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_index_group_id')
    ) THEN
    CREATE INDEX ticket_index_group_id ON ticket_index (group_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_index_queue_id')
    ) THEN
    CREATE INDEX ticket_index_queue_id ON ticket_index (queue_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_index_ticket_id')
    ) THEN
    CREATE INDEX ticket_index_ticket_id ON ticket_index (ticket_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table ticket_lock_index
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_index (
    ticket_id BIGINT NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_lock_index_ticket_id')
    ) THEN
    CREATE INDEX ticket_lock_index_ticket_id ON ticket_lock_index (ticket_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table ticket_loop_protection
-- ----------------------------------------------------------
CREATE TABLE ticket_loop_protection (
    sent_to VARCHAR (250) NOT NULL,
    sent_date VARCHAR (150) NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_loop_protection_sent_date')
    ) THEN
    CREATE INDEX ticket_loop_protection_sent_date ON ticket_loop_protection (sent_date);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_loop_protection_sent_to')
    ) THEN
    CREATE INDEX ticket_loop_protection_sent_to ON ticket_loop_protection (sent_to);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table article_sender_type
-- ----------------------------------------------------------
CREATE TABLE article_sender_type (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT article_sender_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table article_flag
-- ----------------------------------------------------------
CREATE TABLE article_flag (
    article_id BIGINT NOT NULL,
    article_key VARCHAR (50) NOT NULL,
    article_value VARCHAR (50) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_flag_article_id')
    ) THEN
    CREATE INDEX article_flag_article_id ON article_flag (article_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_flag_article_id_create_by')
    ) THEN
    CREATE INDEX article_flag_article_id_create_by ON article_flag (article_id, create_by);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table communication_channel
-- ----------------------------------------------------------
CREATE TABLE communication_channel (
    id bigserial NOT NULL,
    name VARCHAR (200) NOT NULL,
    module VARCHAR (200) NOT NULL,
    package_name VARCHAR (200) NOT NULL,
    channel_data TEXT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT communication_channel_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table article
-- ----------------------------------------------------------
CREATE TABLE article (
    id bigserial NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    communication_channel_id BIGINT NOT NULL,
    is_visible_for_customer SMALLINT NOT NULL,
    search_index_needs_rebuild SMALLINT DEFAULT 1 NOT NULL,
    insert_fingerprint VARCHAR (64) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_article_sender_type_id')
    ) THEN
    CREATE INDEX article_article_sender_type_id ON article (article_sender_type_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_communication_channel_id')
    ) THEN
    CREATE INDEX article_communication_channel_id ON article (communication_channel_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_search_index_needs_rebuild')
    ) THEN
    CREATE INDEX article_search_index_needs_rebuild ON article (search_index_needs_rebuild);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_ticket_id')
    ) THEN
    CREATE INDEX article_ticket_id ON article (ticket_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table article_data_mime
-- ----------------------------------------------------------
CREATE TABLE article_data_mime (
    id bigserial NOT NULL,
    article_id BIGINT NOT NULL,
    a_from VARCHAR NULL,
    a_reply_to VARCHAR NULL,
    a_to VARCHAR NULL,
    a_cc VARCHAR NULL,
    a_subject VARCHAR (3800) NULL,
    a_message_id VARCHAR (3800) NULL,
    a_message_id_md5 VARCHAR (32) NULL,
    a_in_reply_to VARCHAR NULL,
    a_references VARCHAR NULL,
    a_content_type VARCHAR (250) NULL,
    a_body VARCHAR NULL,
    incoming_time INTEGER NOT NULL,
    content_path VARCHAR (250) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_data_mime_message_id_md5')
    ) THEN
    CREATE INDEX article_data_mime_message_id_md5 ON article_data_mime (a_message_id_md5);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table article_search_index
-- ----------------------------------------------------------
CREATE TABLE article_search_index (
    id bigserial NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NOT NULL,
    article_key VARCHAR (200) NOT NULL,
    article_value VARCHAR NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_search_index_article_id')
    ) THEN
    CREATE INDEX article_search_index_article_id ON article_search_index (article_id, article_key);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_search_index_ticket_id')
    ) THEN
    CREATE INDEX article_search_index_ticket_id ON article_search_index (ticket_id, article_key);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table article_data_mime_plain
-- ----------------------------------------------------------
CREATE TABLE article_data_mime_plain (
    id bigserial NOT NULL,
    article_id BIGINT NOT NULL,
    body TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_data_mime_plain_article_id')
    ) THEN
    CREATE INDEX article_data_mime_plain_article_id ON article_data_mime_plain (article_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table article_data_mime_attachment
-- ----------------------------------------------------------
CREATE TABLE article_data_mime_attachment (
    id bigserial NOT NULL,
    article_id BIGINT NOT NULL,
    filename VARCHAR (250) NULL,
    content_size VARCHAR (30) NULL,
    content_type VARCHAR (450) NULL,
    content_id VARCHAR (250) NULL,
    content_alternative VARCHAR (50) NULL,
    disposition VARCHAR (15) NULL,
    content TEXT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_data_mime_attachment_article_id')
    ) THEN
    CREATE INDEX article_data_mime_attachment_article_id ON article_data_mime_attachment (article_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table article_data_otrs_chat
-- ----------------------------------------------------------
CREATE TABLE article_data_otrs_chat (
    id bigserial NOT NULL,
    article_id BIGINT NOT NULL,
    chat_participant_id VARCHAR (255) NOT NULL,
    chat_participant_name VARCHAR (255) NOT NULL,
    chat_participant_type VARCHAR (255) NOT NULL,
    message_text VARCHAR (3800) NULL,
    system_generated SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('article_data_otrs_chat_article_id')
    ) THEN
    CREATE INDEX article_data_otrs_chat_article_id ON article_data_otrs_chat (article_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table time_accounting
-- ----------------------------------------------------------
CREATE TABLE time_accounting (
    id bigserial NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NULL,
    time_unit DECIMAL (10,2) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('time_accounting_ticket_id')
    ) THEN
    CREATE INDEX time_accounting_ticket_id ON time_accounting (ticket_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table standard_template
-- ----------------------------------------------------------
CREATE TABLE standard_template (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    text VARCHAR NULL,
    content_type VARCHAR (250) NULL,
    template_type VARCHAR (100) DEFAULT 'Answer' NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT standard_template_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table queue_standard_template
-- ----------------------------------------------------------
CREATE TABLE queue_standard_template (
    queue_id INTEGER NOT NULL,
    standard_template_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
-- ----------------------------------------------------------
--  create table standard_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_attachment (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    content_type VARCHAR (250) NOT NULL,
    content TEXT NOT NULL,
    filename VARCHAR (250) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT standard_attachment_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table standard_template_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_template_attachment (
    id serial NOT NULL,
    standard_attachment_id INTEGER NOT NULL,
    standard_template_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table auto_response_type
-- ----------------------------------------------------------
CREATE TABLE auto_response_type (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT auto_response_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table auto_response
-- ----------------------------------------------------------
CREATE TABLE auto_response (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    text0 VARCHAR (6000) NULL,
    text1 VARCHAR (6000) NULL,
    type_id SMALLINT NOT NULL,
    system_address_id SMALLINT NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT auto_response_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table queue_auto_response
-- ----------------------------------------------------------
CREATE TABLE queue_auto_response (
    id serial NOT NULL,
    queue_id INTEGER NOT NULL,
    auto_response_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table service
-- ----------------------------------------------------------
CREATE TABLE service (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (250) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT service_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table service_preferences
-- ----------------------------------------------------------
CREATE TABLE service_preferences (
    service_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('service_preferences_service_id')
    ) THEN
    CREATE INDEX service_preferences_service_id ON service_preferences (service_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table service_customer_user
-- ----------------------------------------------------------
CREATE TABLE service_customer_user (
    customer_user_login VARCHAR (200) NOT NULL,
    service_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('service_customer_user_customer_user_login')
    ) THEN
    CREATE INDEX service_customer_user_customer_user_login ON service_customer_user (customer_user_login);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('service_customer_user_service_id')
    ) THEN
    CREATE INDEX service_customer_user_service_id ON service_customer_user (service_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table sla
-- ----------------------------------------------------------
CREATE TABLE sla (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    calendar_name VARCHAR (100) NULL,
    first_response_time INTEGER NOT NULL,
    first_response_notify SMALLINT NULL,
    update_time INTEGER NOT NULL,
    update_notify SMALLINT NULL,
    solution_time INTEGER NOT NULL,
    solution_notify SMALLINT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (250) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT sla_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table sla_preferences
-- ----------------------------------------------------------
CREATE TABLE sla_preferences (
    sla_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('sla_preferences_sla_id')
    ) THEN
    CREATE INDEX sla_preferences_sla_id ON sla_preferences (sla_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table service_sla
-- ----------------------------------------------------------
CREATE TABLE service_sla (
    service_id INTEGER NOT NULL,
    sla_id INTEGER NOT NULL,
    CONSTRAINT service_sla_service_sla UNIQUE (service_id, sla_id)
);
-- ----------------------------------------------------------
--  create table sessions
-- ----------------------------------------------------------
CREATE TABLE sessions (
    id bigserial NOT NULL,
    session_id VARCHAR (100) NOT NULL,
    data_key VARCHAR (100) NOT NULL,
    data_value VARCHAR NULL,
    serialized SMALLINT NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('sessions_data_key')
    ) THEN
    CREATE INDEX sessions_data_key ON sessions (data_key);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('sessions_session_id_data_key')
    ) THEN
    CREATE INDEX sessions_session_id_data_key ON sessions (session_id, data_key);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table customer_user
-- ----------------------------------------------------------
CREATE TABLE customer_user (
    id serial NOT NULL,
    login VARCHAR (200) NOT NULL,
    email VARCHAR (150) NOT NULL,
    customer_id VARCHAR (150) NOT NULL,
    pw VARCHAR (128) NULL,
    title VARCHAR (50) NULL,
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    phone VARCHAR (150) NULL,
    fax VARCHAR (150) NULL,
    mobile VARCHAR (150) NULL,
    street VARCHAR (150) NULL,
    zip VARCHAR (200) NULL,
    city VARCHAR (200) NULL,
    country VARCHAR (200) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT customer_user_login UNIQUE (login)
);
-- ----------------------------------------------------------
--  create table customer_preferences
-- ----------------------------------------------------------
CREATE TABLE customer_preferences (
    user_id VARCHAR (250) NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('customer_preferences_user_id')
    ) THEN
    CREATE INDEX customer_preferences_user_id ON customer_preferences (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table customer_company
-- ----------------------------------------------------------
CREATE TABLE customer_company (
    customer_id VARCHAR (150) NOT NULL,
    name VARCHAR (200) NOT NULL,
    street VARCHAR (200) NULL,
    zip VARCHAR (200) NULL,
    city VARCHAR (200) NULL,
    country VARCHAR (200) NULL,
    url VARCHAR (200) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(customer_id),
    CONSTRAINT customer_company_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table customer_user_customer
-- ----------------------------------------------------------
CREATE TABLE customer_user_customer (
    user_id VARCHAR (100) NOT NULL,
    customer_id VARCHAR (150) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('customer_user_customer_customer_id')
    ) THEN
    CREATE INDEX customer_user_customer_customer_id ON customer_user_customer (customer_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('customer_user_customer_user_id')
    ) THEN
    CREATE INDEX customer_user_customer_user_id ON customer_user_customer (user_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table mail_account
-- ----------------------------------------------------------
CREATE TABLE mail_account (
    id serial NOT NULL,
    login VARCHAR (200) NOT NULL,
    pw VARCHAR (200) NOT NULL,
    host VARCHAR (200) NOT NULL,
    account_type VARCHAR (20) NOT NULL,
    queue_id INTEGER NOT NULL,
    trusted SMALLINT NOT NULL,
    imap_folder VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table postmaster_filter
-- ----------------------------------------------------------
CREATE TABLE postmaster_filter (
    f_name VARCHAR (200) NOT NULL,
    f_stop SMALLINT NULL,
    f_type VARCHAR (20) NOT NULL,
    f_key VARCHAR (200) NOT NULL,
    f_value VARCHAR (200) NOT NULL,
    f_not SMALLINT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('postmaster_filter_f_name')
    ) THEN
    CREATE INDEX postmaster_filter_f_name ON postmaster_filter (f_name);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table generic_agent_jobs
-- ----------------------------------------------------------
CREATE TABLE generic_agent_jobs (
    job_name VARCHAR (200) NOT NULL,
    job_key VARCHAR (200) NOT NULL,
    job_value VARCHAR (200) NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('generic_agent_jobs_job_name')
    ) THEN
    CREATE INDEX generic_agent_jobs_job_name ON generic_agent_jobs (job_name);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table search_profile
-- ----------------------------------------------------------
CREATE TABLE search_profile (
    login VARCHAR (200) NOT NULL,
    profile_name VARCHAR (200) NOT NULL,
    profile_type VARCHAR (30) NOT NULL,
    profile_key VARCHAR (200) NOT NULL,
    profile_value VARCHAR (200) NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('search_profile_login')
    ) THEN
    CREATE INDEX search_profile_login ON search_profile (login);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('search_profile_profile_name')
    ) THEN
    CREATE INDEX search_profile_profile_name ON search_profile (profile_name);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table process_id
-- ----------------------------------------------------------
CREATE TABLE process_id (
    process_name VARCHAR (200) NOT NULL,
    process_id VARCHAR (200) NOT NULL,
    process_host VARCHAR (200) NOT NULL,
    process_create INTEGER NOT NULL,
    process_change INTEGER NOT NULL
);
-- ----------------------------------------------------------
--  create table web_upload_cache
-- ----------------------------------------------------------
CREATE TABLE web_upload_cache (
    form_id VARCHAR (250) NULL,
    filename VARCHAR (250) NULL,
    content_id VARCHAR (250) NULL,
    content_size VARCHAR (30) NULL,
    content_type VARCHAR (250) NULL,
    disposition VARCHAR (15) NULL,
    content TEXT NOT NULL,
    create_time_unix BIGINT NOT NULL
);
-- ----------------------------------------------------------
--  create table notification_event
-- ----------------------------------------------------------
CREATE TABLE notification_event (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (250) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT notification_event_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table notification_event_message
-- ----------------------------------------------------------
CREATE TABLE notification_event_message (
    id serial NOT NULL,
    notification_id INTEGER NOT NULL,
    subject VARCHAR (200) NOT NULL,
    text VARCHAR (4000) NOT NULL,
    content_type VARCHAR (250) NOT NULL,
    language VARCHAR (60) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT notification_event_message_notification_id_language UNIQUE (notification_id, language)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('notification_event_message_language')
    ) THEN
    CREATE INDEX notification_event_message_language ON notification_event_message (language);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('notification_event_message_notification_id')
    ) THEN
    CREATE INDEX notification_event_message_notification_id ON notification_event_message (notification_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table notification_event_item
-- ----------------------------------------------------------
CREATE TABLE notification_event_item (
    notification_id INTEGER NOT NULL,
    event_key VARCHAR (200) NOT NULL,
    event_value VARCHAR (200) NOT NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('notification_event_item_event_key')
    ) THEN
    CREATE INDEX notification_event_item_event_key ON notification_event_item (event_key);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('notification_event_item_event_value')
    ) THEN
    CREATE INDEX notification_event_item_event_value ON notification_event_item (event_value);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('notification_event_item_notification_id')
    ) THEN
    CREATE INDEX notification_event_item_notification_id ON notification_event_item (notification_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table link_type
-- ----------------------------------------------------------
CREATE TABLE link_type (
    id serial NOT NULL,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT link_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table link_state
-- ----------------------------------------------------------
CREATE TABLE link_state (
    id serial NOT NULL,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT link_state_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table link_object
-- ----------------------------------------------------------
CREATE TABLE link_object (
    id serial NOT NULL,
    name VARCHAR (100) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT link_object_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table link_relation
-- ----------------------------------------------------------
CREATE TABLE link_relation (
    source_object_id SMALLINT NOT NULL,
    source_key VARCHAR (50) NOT NULL,
    target_object_id SMALLINT NOT NULL,
    target_key VARCHAR (50) NOT NULL,
    type_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    CONSTRAINT link_relation_view UNIQUE (source_object_id, source_key, target_object_id, target_key, type_id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('link_relation_list_source')
    ) THEN
    CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('link_relation_list_target')
    ) THEN
    CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table system_data
-- ----------------------------------------------------------
CREATE TABLE system_data (
    data_key VARCHAR (160) NOT NULL,
    data_value TEXT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(data_key)
);
-- ----------------------------------------------------------
--  create table xml_storage
-- ----------------------------------------------------------
CREATE TABLE xml_storage (
    xml_type VARCHAR (200) NOT NULL,
    xml_key VARCHAR (250) NOT NULL,
    xml_content_key VARCHAR (250) NOT NULL,
    xml_content_value VARCHAR NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('xml_storage_key_type')
    ) THEN
    CREATE INDEX xml_storage_key_type ON xml_storage (xml_key, xml_type);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('xml_storage_xml_content_key')
    ) THEN
    CREATE INDEX xml_storage_xml_content_key ON xml_storage (xml_content_key);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table virtual_fs
-- ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id bigserial NOT NULL,
    filename VARCHAR (350) NOT NULL,
    backend VARCHAR (60) NOT NULL,
    backend_key VARCHAR (160) NOT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('virtual_fs_backend')
    ) THEN
    CREATE INDEX virtual_fs_backend ON virtual_fs (backend);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('virtual_fs_filename')
    ) THEN
    CREATE INDEX virtual_fs_filename ON virtual_fs (filename);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table virtual_fs_preferences
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (350) NULL
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('virtual_fs_preferences_key_value')
    ) THEN
    CREATE INDEX virtual_fs_preferences_key_value ON virtual_fs_preferences (preferences_key, preferences_value);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('virtual_fs_preferences_virtual_fs_id')
    ) THEN
    CREATE INDEX virtual_fs_preferences_virtual_fs_id ON virtual_fs_preferences (virtual_fs_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table virtual_fs_db
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id bigserial NOT NULL,
    filename VARCHAR (350) NOT NULL,
    content TEXT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('virtual_fs_db_filename')
    ) THEN
    CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table package_repository
-- ----------------------------------------------------------
CREATE TABLE package_repository (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    version VARCHAR (250) NOT NULL,
    vendor VARCHAR (250) NOT NULL,
    install_status VARCHAR (250) NOT NULL,
    filename VARCHAR (250) NULL,
    content_type VARCHAR (250) NULL,
    content TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table gi_webservice_config
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table gi_webservice_config_history
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config_history (
    id bigserial NOT NULL,
    config_id INTEGER NOT NULL,
    config TEXT NOT NULL,
    config_md5 VARCHAR (32) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_webservice_config_history_config_md5 UNIQUE (config_md5)
);
-- ----------------------------------------------------------
--  create table gi_debugger_entry
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry (
    id bigserial NOT NULL,
    communication_id VARCHAR (32) NOT NULL,
    communication_type VARCHAR (50) NOT NULL,
    remote_ip VARCHAR (50) NULL,
    webservice_id INTEGER NOT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT gi_debugger_entry_communication_id UNIQUE (communication_id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('gi_debugger_entry_create_time')
    ) THEN
    CREATE INDEX gi_debugger_entry_create_time ON gi_debugger_entry (create_time);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table gi_debugger_entry_content
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry_content (
    id bigserial NOT NULL,
    gi_debugger_entry_id BIGINT NOT NULL,
    debug_level VARCHAR (50) NOT NULL,
    subject VARCHAR (255) NOT NULL,
    content TEXT NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('gi_debugger_entry_content_create_time')
    ) THEN
    CREATE INDEX gi_debugger_entry_content_create_time ON gi_debugger_entry_content (create_time);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('gi_debugger_entry_content_debug_level')
    ) THEN
    CREATE INDEX gi_debugger_entry_content_debug_level ON gi_debugger_entry_content (debug_level);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table smime_signer_cert_relations
-- ----------------------------------------------------------
CREATE TABLE smime_signer_cert_relations (
    id serial NOT NULL,
    cert_hash VARCHAR (8) NOT NULL,
    cert_fingerprint VARCHAR (59) NOT NULL,
    ca_hash VARCHAR (8) NOT NULL,
    ca_fingerprint VARCHAR (59) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table dynamic_field_value
-- ----------------------------------------------------------
CREATE TABLE dynamic_field_value (
    id serial NOT NULL,
    field_id INTEGER NOT NULL,
    object_id BIGINT NOT NULL,
    value_text VARCHAR (3800) NULL,
    value_date timestamp(0) NULL,
    value_int BIGINT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('dynamic_field_value_field_values')
    ) THEN
    CREATE INDEX dynamic_field_value_field_values ON dynamic_field_value (object_id, field_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('dynamic_field_value_search_date')
    ) THEN
    CREATE INDEX dynamic_field_value_search_date ON dynamic_field_value (field_id, value_date);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('dynamic_field_value_search_int')
    ) THEN
    CREATE INDEX dynamic_field_value_search_int ON dynamic_field_value (field_id, value_int);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('dynamic_field_value_search_text')
    ) THEN
    CREATE INDEX dynamic_field_value_search_text ON dynamic_field_value (field_id, value_text);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table dynamic_field
-- ----------------------------------------------------------
CREATE TABLE dynamic_field (
    id serial NOT NULL,
    internal_field SMALLINT DEFAULT 0 NOT NULL,
    name VARCHAR (200) NOT NULL,
    label VARCHAR (200) NOT NULL,
    field_order INTEGER NOT NULL,
    field_type VARCHAR (200) NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    config TEXT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT dynamic_field_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table dynamic_field_obj_id_name
-- ----------------------------------------------------------
CREATE TABLE dynamic_field_obj_id_name (
    object_id serial NOT NULL,
    object_name VARCHAR (200) NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    PRIMARY KEY(object_id),
    CONSTRAINT dynamic_field_object_name UNIQUE (object_name, object_type)
);
-- ----------------------------------------------------------
--  create table pm_process
-- ----------------------------------------------------------
CREATE TABLE pm_process (
    id serial NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    state_entity_id VARCHAR (50) NOT NULL,
    layout TEXT NOT NULL,
    config TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_process_entity_id UNIQUE (entity_id)
);
-- ----------------------------------------------------------
--  create table pm_activity
-- ----------------------------------------------------------
CREATE TABLE pm_activity (
    id serial NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_activity_entity_id UNIQUE (entity_id)
);
-- ----------------------------------------------------------
--  create table pm_activity_dialog
-- ----------------------------------------------------------
CREATE TABLE pm_activity_dialog (
    id serial NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_activity_dialog_entity_id UNIQUE (entity_id)
);
-- ----------------------------------------------------------
--  create table pm_transition
-- ----------------------------------------------------------
CREATE TABLE pm_transition (
    id serial NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_transition_entity_id UNIQUE (entity_id)
);
-- ----------------------------------------------------------
--  create table pm_transition_action
-- ----------------------------------------------------------
CREATE TABLE pm_transition_action (
    id serial NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT pm_transition_action_entity_id UNIQUE (entity_id)
);
-- ----------------------------------------------------------
--  create table pm_entity_sync
-- ----------------------------------------------------------
CREATE TABLE pm_entity_sync (
    entity_type VARCHAR (30) NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    sync_state VARCHAR (30) NOT NULL,
    create_time timestamp(0) NOT NULL,
    change_time timestamp(0) NOT NULL,
    CONSTRAINT pm_entity_sync_list UNIQUE (entity_type, entity_id)
);
-- ----------------------------------------------------------
--  create table scheduler_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_task (
    id bigserial NOT NULL,
    ident BIGINT NOT NULL,
    name VARCHAR (150) NULL,
    task_type VARCHAR (150) NOT NULL,
    task_data TEXT NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time timestamp(0) NULL,
    lock_update_time timestamp(0) NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_task_ident UNIQUE (ident)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('scheduler_task_ident_id')
    ) THEN
    CREATE INDEX scheduler_task_ident_id ON scheduler_task (ident, id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('scheduler_task_lock_key_id')
    ) THEN
    CREATE INDEX scheduler_task_lock_key_id ON scheduler_task (lock_key, id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table scheduler_future_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_future_task (
    id bigserial NOT NULL,
    ident BIGINT NOT NULL,
    execution_time timestamp(0) NOT NULL,
    name VARCHAR (150) NULL,
    task_type VARCHAR (150) NOT NULL,
    task_data TEXT NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time timestamp(0) NULL,
    create_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_future_task_ident UNIQUE (ident)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('scheduler_future_task_ident_id')
    ) THEN
    CREATE INDEX scheduler_future_task_ident_id ON scheduler_future_task (ident, id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('scheduler_future_task_lock_key_id')
    ) THEN
    CREATE INDEX scheduler_future_task_lock_key_id ON scheduler_future_task (lock_key, id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table scheduler_recurrent_task
-- ----------------------------------------------------------
CREATE TABLE scheduler_recurrent_task (
    id bigserial NOT NULL,
    name VARCHAR (150) NOT NULL,
    task_type VARCHAR (150) NOT NULL,
    last_execution_time timestamp(0) NOT NULL,
    last_worker_task_id BIGINT NULL,
    last_worker_status SMALLINT NULL,
    last_worker_running_time INTEGER NULL,
    lock_key BIGINT NOT NULL,
    lock_time timestamp(0) NULL,
    create_time timestamp(0) NOT NULL,
    change_time timestamp(0) NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT scheduler_recurrent_task_name_task_type UNIQUE (name, task_type)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('scheduler_recurrent_task_lock_key_id')
    ) THEN
    CREATE INDEX scheduler_recurrent_task_lock_key_id ON scheduler_recurrent_task (lock_key, id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('scheduler_recurrent_task_task_type_name')
    ) THEN
    CREATE INDEX scheduler_recurrent_task_task_type_name ON scheduler_recurrent_task (task_type, name);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table cloud_service_config
-- ----------------------------------------------------------
CREATE TABLE cloud_service_config (
    id serial NOT NULL,
    name VARCHAR (200) NOT NULL,
    config TEXT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT cloud_service_config_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table sysconfig_default
-- ----------------------------------------------------------
CREATE TABLE sysconfig_default (
    id serial NOT NULL,
    name VARCHAR (250) NOT NULL,
    description TEXT NOT NULL,
    navigation VARCHAR (200) NOT NULL,
    is_invisible SMALLINT NOT NULL,
    is_readonly SMALLINT NOT NULL,
    is_required SMALLINT NOT NULL,
    is_valid SMALLINT NOT NULL,
    has_configlevel SMALLINT NOT NULL,
    user_modification_possible SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    user_preferences_group VARCHAR (250) NULL,
    xml_content_raw TEXT NOT NULL,
    xml_content_parsed TEXT NOT NULL,
    xml_filename VARCHAR (250) NOT NULL,
    effective_value TEXT NOT NULL,
    is_dirty SMALLINT NOT NULL,
    exclusive_lock_guid VARCHAR (32) NOT NULL,
    exclusive_lock_user_id INTEGER NULL,
    exclusive_lock_expiry_time timestamp(0) NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT sysconfig_default_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table sysconfig_default_version
-- ----------------------------------------------------------
CREATE TABLE sysconfig_default_version (
    id serial NOT NULL,
    sysconfig_default_id INTEGER NULL,
    name VARCHAR (250) NOT NULL,
    description TEXT NOT NULL,
    navigation VARCHAR (200) NOT NULL,
    is_invisible SMALLINT NOT NULL,
    is_readonly SMALLINT NOT NULL,
    is_required SMALLINT NOT NULL,
    is_valid SMALLINT NOT NULL,
    has_configlevel SMALLINT NOT NULL,
    user_modification_possible SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    user_preferences_group VARCHAR (250) NULL,
    xml_content_raw TEXT NOT NULL,
    xml_content_parsed TEXT NOT NULL,
    xml_filename VARCHAR (250) NOT NULL,
    effective_value TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('scfv_sysconfig_default_id_name')
    ) THEN
    CREATE INDEX scfv_sysconfig_default_id_name ON sysconfig_default_version (sysconfig_default_id, name);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table sysconfig_modified
-- ----------------------------------------------------------
CREATE TABLE sysconfig_modified (
    id serial NOT NULL,
    sysconfig_default_id INTEGER NOT NULL,
    name VARCHAR (250) NOT NULL,
    user_id INTEGER NULL,
    is_valid SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    effective_value TEXT NOT NULL,
    is_dirty SMALLINT NOT NULL,
    reset_to_default SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT sysconfig_modified_per_user UNIQUE (sysconfig_default_id, user_id)
);
-- ----------------------------------------------------------
--  create table sysconfig_modified_version
-- ----------------------------------------------------------
CREATE TABLE sysconfig_modified_version (
    id serial NOT NULL,
    sysconfig_default_version_id INTEGER NOT NULL,
    name VARCHAR (250) NOT NULL,
    user_id INTEGER NULL,
    is_valid SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    effective_value TEXT NOT NULL,
    reset_to_default SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table sysconfig_deployment_lock
-- ----------------------------------------------------------
CREATE TABLE sysconfig_deployment_lock (
    id serial NOT NULL,
    exclusive_lock_guid VARCHAR (32) NULL,
    exclusive_lock_user_id INTEGER NULL,
    exclusive_lock_expiry_time timestamp(0) NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table sysconfig_deployment
-- ----------------------------------------------------------
CREATE TABLE sysconfig_deployment (
    id serial NOT NULL,
    comments VARCHAR (250) NULL,
    user_id INTEGER NULL,
    effective_value TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table calendar
-- ----------------------------------------------------------
CREATE TABLE calendar (
    id bigserial NOT NULL,
    group_id INTEGER NOT NULL,
    name VARCHAR (200) NOT NULL,
    salt_string VARCHAR (64) NOT NULL,
    color VARCHAR (7) NOT NULL,
    ticket_appointments TEXT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT calendar_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table calendar_appointment
-- ----------------------------------------------------------
CREATE TABLE calendar_appointment (
    id bigserial NOT NULL,
    parent_id BIGINT NULL,
    calendar_id BIGINT NOT NULL,
    unique_id VARCHAR (255) NOT NULL,
    title VARCHAR (255) NOT NULL,
    description VARCHAR (3800) NULL,
    location VARCHAR (255) NULL,
    start_time timestamp(0) NOT NULL,
    end_time timestamp(0) NOT NULL,
    all_day SMALLINT NULL,
    notify_time timestamp(0) NULL,
    notify_template VARCHAR (255) NULL,
    notify_custom VARCHAR (255) NULL,
    notify_custom_unit_count BIGINT NULL,
    notify_custom_unit VARCHAR (255) NULL,
    notify_custom_unit_point VARCHAR (255) NULL,
    notify_custom_date timestamp(0) NULL,
    team_id VARCHAR (3800) NULL,
    resource_id VARCHAR (3800) NULL,
    recurring SMALLINT NULL,
    recur_type VARCHAR (20) NULL,
    recur_freq VARCHAR (255) NULL,
    recur_count INTEGER NULL,
    recur_interval INTEGER NULL,
    recur_until timestamp(0) NULL,
    recur_id timestamp(0) NULL,
    recur_exclude VARCHAR (3800) NULL,
    ticket_appointment_rule_id VARCHAR (32) NULL,
    create_time timestamp(0) NULL,
    create_by INTEGER NULL,
    change_time timestamp(0) NULL,
    change_by INTEGER NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table calendar_appointment_ticket
-- ----------------------------------------------------------
CREATE TABLE calendar_appointment_ticket (
    calendar_id BIGINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    rule_id VARCHAR (32) NOT NULL,
    appointment_id BIGINT NOT NULL,
    CONSTRAINT calendar_appointment_ticket_calendar_id_ticket_id_rule_id UNIQUE (calendar_id, ticket_id, rule_id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('calendar_appointment_ticket_appointment_id')
    ) THEN
    CREATE INDEX calendar_appointment_ticket_appointment_id ON calendar_appointment_ticket (appointment_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('calendar_appointment_ticket_calendar_id')
    ) THEN
    CREATE INDEX calendar_appointment_ticket_calendar_id ON calendar_appointment_ticket (calendar_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('calendar_appointment_ticket_rule_id')
    ) THEN
    CREATE INDEX calendar_appointment_ticket_rule_id ON calendar_appointment_ticket (rule_id);
END IF;
END$$;
;
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('calendar_appointment_ticket_ticket_id')
    ) THEN
    CREATE INDEX calendar_appointment_ticket_ticket_id ON calendar_appointment_ticket (ticket_id);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table ticket_number_counter
-- ----------------------------------------------------------
CREATE TABLE ticket_number_counter (
    id bigserial NOT NULL,
    counter BIGINT NOT NULL,
    counter_uid VARCHAR (32) NOT NULL,
    create_time timestamp(0) NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_number_counter_uid UNIQUE (counter_uid)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('ticket_number_counter_create_time')
    ) THEN
    CREATE INDEX ticket_number_counter_create_time ON ticket_number_counter (create_time);
END IF;
END$$;
;
-- ----------------------------------------------------------
--  create table form_draft
-- ----------------------------------------------------------
CREATE TABLE form_draft (
    id serial NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    object_id INTEGER NOT NULL,
    action VARCHAR (200) NOT NULL,
    title VARCHAR (255) NULL,
    content TEXT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM pg_indexes
    WHERE LOWER(indexname) = LOWER('form_draft_object_type_object_id_action')
    ) THEN
    CREATE INDEX form_draft_object_type_object_id_action ON form_draft (object_type, object_id, action);
END IF;
END$$;
;
