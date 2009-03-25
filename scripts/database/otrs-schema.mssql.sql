-- ----------------------------------------------------------
--  driver: mssql, generated: 2009-03-25 02:23:42
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  create table valid
-- ----------------------------------------------------------
CREATE TABLE valid (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (50) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT valid_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_priority
-- ----------------------------------------------------------
CREATE TABLE ticket_priority (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_priority_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_type
-- ----------------------------------------------------------
CREATE TABLE ticket_type (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_lock_type
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_type (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_lock_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table users
-- ----------------------------------------------------------
CREATE TABLE users (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    login VARCHAR (100) NOT NULL,
    pw VARCHAR (50) NOT NULL,
    salutation VARCHAR (50) NULL,
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
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
    preferences_value VARCHAR (250) NULL
);
CREATE INDEX user_preferences_user_id ON user_preferences (user_id);
-- ----------------------------------------------------------
--  create table groups
-- ----------------------------------------------------------
CREATE TABLE groups (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
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
    permission_value SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);
CREATE INDEX group_user_group_id ON group_user (group_id);
CREATE INDEX group_user_user_id ON group_user (user_id);
-- ----------------------------------------------------------
--  create table group_role
-- ----------------------------------------------------------
CREATE TABLE group_role (
    role_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);
CREATE INDEX group_role_group_id ON group_role (group_id);
CREATE INDEX group_role_role_id ON group_role (role_id);
-- ----------------------------------------------------------
--  create table group_customer_user
-- ----------------------------------------------------------
CREATE TABLE group_customer_user (
    user_id VARCHAR (100) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);
CREATE INDEX group_customer_user_group_id ON group_customer_user (group_id);
CREATE INDEX group_customer_user_user_id ON group_customer_user (user_id);
-- ----------------------------------------------------------
--  create table roles
-- ----------------------------------------------------------
CREATE TABLE roles (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
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
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);
CREATE INDEX role_user_role_id ON role_user (role_id);
CREATE INDEX role_user_user_id ON role_user (user_id);
-- ----------------------------------------------------------
--  create table personal_queues
-- ----------------------------------------------------------
CREATE TABLE personal_queues (
    user_id INTEGER NOT NULL,
    queue_id INTEGER NOT NULL
);
CREATE INDEX personal_queues_queue_id ON personal_queues (queue_id);
CREATE INDEX personal_queues_user_id ON personal_queues (user_id);
-- ----------------------------------------------------------
--  create table theme
-- ----------------------------------------------------------
CREATE TABLE theme (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    theme VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT theme_theme UNIQUE (theme)
);
-- ----------------------------------------------------------
--  create table ticket_state
-- ----------------------------------------------------------
CREATE TABLE ticket_state (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250) NULL,
    type_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_state_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_state_type
-- ----------------------------------------------------------
CREATE TABLE ticket_state_type (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (120) NOT NULL,
    comments VARCHAR (250) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_state_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table salutation
-- ----------------------------------------------------------
CREATE TABLE salutation (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    text VARCHAR (3000) NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT salutation_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table signature
-- ----------------------------------------------------------
CREATE TABLE signature (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    text VARCHAR (3000) NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT signature_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table system_address
-- ----------------------------------------------------------
CREATE TABLE system_address (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    value0 VARCHAR (200) NOT NULL,
    value1 VARCHAR (200) NOT NULL,
    value2 VARCHAR (200) NULL,
    value3 VARCHAR (200) NULL,
    queue_id INTEGER NOT NULL,
    comments VARCHAR (200) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table follow_up_possible
-- ----------------------------------------------------------
CREATE TABLE follow_up_possible (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT follow_up_possible_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table queue
-- ----------------------------------------------------------
CREATE TABLE queue (
    id INTEGER NOT NULL IDENTITY(1,1) ,
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
    move_notify SMALLINT NOT NULL,
    state_notify SMALLINT NOT NULL,
    lock_notify SMALLINT NOT NULL,
    owner_notify SMALLINT NOT NULL,
    comments VARCHAR (200) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT queue_name UNIQUE (name)
);
CREATE INDEX queue_group_id ON queue (group_id);
-- ----------------------------------------------------------
--  create table queue_preferences
-- ----------------------------------------------------------
CREATE TABLE queue_preferences (
    queue_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL
);
CREATE INDEX queue_preferences_queue_id ON queue_preferences (queue_id);
-- ----------------------------------------------------------
--  create table ticket
-- ----------------------------------------------------------
CREATE TABLE ticket (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    tn VARCHAR (50) NOT NULL,
    title VARCHAR (255) NULL,
    queue_id INTEGER NOT NULL,
    ticket_lock_id SMALLINT NOT NULL,
    ticket_answered SMALLINT NOT NULL,
    type_id SMALLINT NULL,
    service_id INTEGER NULL,
    sla_id INTEGER NULL,
    user_id INTEGER NOT NULL,
    responsible_user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    ticket_priority_id SMALLINT NOT NULL,
    ticket_state_id SMALLINT NOT NULL,
    group_read SMALLINT NULL,
    group_write SMALLINT NULL,
    other_read SMALLINT NULL,
    other_write SMALLINT NULL,
    customer_id VARCHAR (150) NULL,
    customer_user_id VARCHAR (250) NULL,
    timeout INTEGER NULL,
    until_time INTEGER NULL,
    escalation_time INTEGER NOT NULL,
    escalation_update_time INTEGER NOT NULL,
    escalation_response_time INTEGER NOT NULL,
    escalation_solution_time INTEGER NOT NULL,
    freekey1 VARCHAR (80) NULL,
    freetext1 VARCHAR (150) NULL,
    freekey2 VARCHAR (80) NULL,
    freetext2 VARCHAR (150) NULL,
    freekey3 VARCHAR (80) NULL,
    freetext3 VARCHAR (150) NULL,
    freekey4 VARCHAR (80) NULL,
    freetext4 VARCHAR (150) NULL,
    freekey5 VARCHAR (80) NULL,
    freetext5 VARCHAR (150) NULL,
    freekey6 VARCHAR (80) NULL,
    freetext6 VARCHAR (150) NULL,
    freekey7 VARCHAR (80) NULL,
    freetext7 VARCHAR (150) NULL,
    freekey8 VARCHAR (80) NULL,
    freetext8 VARCHAR (150) NULL,
    freekey9 VARCHAR (80) NULL,
    freetext9 VARCHAR (150) NULL,
    freekey10 VARCHAR (80) NULL,
    freetext10 VARCHAR (150) NULL,
    freekey11 VARCHAR (80) NULL,
    freetext11 VARCHAR (150) NULL,
    freekey12 VARCHAR (80) NULL,
    freetext12 VARCHAR (150) NULL,
    freekey13 VARCHAR (80) NULL,
    freetext13 VARCHAR (150) NULL,
    freekey14 VARCHAR (80) NULL,
    freetext14 VARCHAR (150) NULL,
    freekey15 VARCHAR (80) NULL,
    freetext15 VARCHAR (150) NULL,
    freekey16 VARCHAR (80) NULL,
    freetext16 VARCHAR (150) NULL,
    freetime1 DATETIME NULL,
    freetime2 DATETIME NULL,
    freetime3 DATETIME NULL,
    freetime4 DATETIME NULL,
    freetime5 DATETIME NULL,
    freetime6 DATETIME NULL,
    valid_id SMALLINT NOT NULL,
    create_time_unix BIGINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_tn UNIQUE (tn)
);
CREATE INDEX ticket_answered ON ticket (ticket_answered);
CREATE INDEX ticket_customer_id ON ticket (customer_id);
CREATE INDEX ticket_customer_user_id ON ticket (customer_user_id);
CREATE INDEX ticket_escalation_response_time ON ticket (escalation_response_time);
CREATE INDEX ticket_escalation_solution_time ON ticket (escalation_solution_time);
CREATE INDEX ticket_escalation_time ON ticket (escalation_time);
CREATE INDEX ticket_escalation_update_time ON ticket (escalation_update_time);
CREATE INDEX ticket_queue_id ON ticket (queue_id);
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id, group_id);
CREATE INDEX ticket_responsible_user_id ON ticket (responsible_user_id);
CREATE INDEX ticket_ticket_lock_id ON ticket (ticket_lock_id);
CREATE INDEX ticket_ticket_priority_id ON ticket (ticket_priority_id);
CREATE INDEX ticket_ticket_state_id ON ticket (ticket_state_id);
CREATE INDEX ticket_title ON ticket (title);
CREATE INDEX ticket_type_id ON ticket (type_id);
CREATE INDEX ticket_user_id ON ticket (user_id);
-- ----------------------------------------------------------
--  create table link_type
-- ----------------------------------------------------------
CREATE TABLE link_type (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT link_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table link_state
-- ----------------------------------------------------------
CREATE TABLE link_state (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT link_state_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table link_object
-- ----------------------------------------------------------
CREATE TABLE link_object (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
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
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    CONSTRAINT link_relation_view UNIQUE (source_object_id, source_key, target_object_id, target_key, type_id)
);
-- ----------------------------------------------------------
--  create table ticket_history
-- ----------------------------------------------------------
CREATE TABLE ticket_history (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (200) NOT NULL,
    history_type_id SMALLINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NULL,
    type_id SMALLINT NOT NULL,
    queue_id INTEGER NOT NULL,
    owner_id INTEGER NOT NULL,
    priority_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX ticket_history_create_time ON ticket_history (create_time);
CREATE INDEX ticket_history_history_type_id ON ticket_history (history_type_id);
CREATE INDEX ticket_history_owner_id ON ticket_history (owner_id);
CREATE INDEX ticket_history_priority_id ON ticket_history (priority_id);
CREATE INDEX ticket_history_queue_id ON ticket_history (queue_id);
CREATE INDEX ticket_history_state_id ON ticket_history (state_id);
CREATE INDEX ticket_history_ticket_id ON ticket_history (ticket_id);
CREATE INDEX ticket_history_type_id ON ticket_history (type_id);
-- ----------------------------------------------------------
--  create table ticket_history_type
-- ----------------------------------------------------------
CREATE TABLE ticket_history_type (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT ticket_history_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table article_type
-- ----------------------------------------------------------
CREATE TABLE article_type (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT article_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table article_sender_type
-- ----------------------------------------------------------
CREATE TABLE article_sender_type (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT article_sender_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table article_flag
-- ----------------------------------------------------------
CREATE TABLE article_flag (
    article_id BIGINT NOT NULL,
    article_flag VARCHAR (50) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL
);
CREATE INDEX article_flag_article_id ON article_flag (article_id);
CREATE INDEX article_flag_create_by ON article_flag (create_by);
-- ----------------------------------------------------------
--  create table article
-- ----------------------------------------------------------
CREATE TABLE article (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    ticket_id BIGINT NOT NULL,
    article_type_id SMALLINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    a_from VARCHAR (3800) NULL,
    a_reply_to VARCHAR (500) NULL,
    a_to VARCHAR (3800) NULL,
    a_cc VARCHAR (3800) NULL,
    a_subject VARCHAR (3800) NULL,
    a_message_id VARCHAR (3800) NULL,
    a_in_reply_to VARCHAR (3800) NULL,
    a_references VARCHAR (3800) NULL,
    a_content_type VARCHAR (250) NULL,
    a_body TEXT NOT NULL,
    incoming_time INTEGER NOT NULL,
    content_path VARCHAR (250) NULL,
    a_freekey1 VARCHAR (250) NULL,
    a_freetext1 VARCHAR (250) NULL,
    a_freekey2 VARCHAR (250) NULL,
    a_freetext2 VARCHAR (250) NULL,
    a_freekey3 VARCHAR (250) NULL,
    a_freetext3 VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX article_article_sender_type_id ON article (article_sender_type_id);
CREATE INDEX article_article_type_id ON article (article_type_id);
CREATE INDEX article_message_id ON article (a_message_id);
CREATE INDEX article_ticket_id ON article (ticket_id);
-- ----------------------------------------------------------
--  create table article_search
-- ----------------------------------------------------------
CREATE TABLE article_search (
    id BIGINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_type_id SMALLINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    a_from VARCHAR (3800) NULL,
    a_to VARCHAR (3800) NULL,
    a_cc VARCHAR (3800) NULL,
    a_subject VARCHAR (3800) NULL,
    a_message_id VARCHAR (3800) NULL,
    a_body TEXT NOT NULL,
    incoming_time INTEGER NOT NULL,
    a_freekey1 VARCHAR (250) NULL,
    a_freetext1 VARCHAR (250) NULL,
    a_freekey2 VARCHAR (250) NULL,
    a_freetext2 VARCHAR (250) NULL,
    a_freekey3 VARCHAR (250) NULL,
    a_freetext3 VARCHAR (250) NULL,
    PRIMARY KEY(id)
);
CREATE INDEX article_search_article_sender_type_id ON article_search (article_sender_type_id);
CREATE INDEX article_search_article_type_id ON article_search (article_type_id);
CREATE INDEX article_search_message_id ON article_search (a_message_id);
CREATE INDEX article_search_ticket_id ON article_search (ticket_id);
-- ----------------------------------------------------------
--  create table article_plain
-- ----------------------------------------------------------
CREATE TABLE article_plain (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    article_id BIGINT NOT NULL,
    body TEXT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX article_plain_article_id ON article_plain (article_id);
-- ----------------------------------------------------------
--  create table article_attachment
-- ----------------------------------------------------------
CREATE TABLE article_attachment (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    article_id BIGINT NOT NULL,
    filename VARCHAR (250) NULL,
    content_size VARCHAR (30) NULL,
    content_type VARCHAR (250) NULL,
    content_id VARCHAR (250) NULL,
    content_alternative VARCHAR (50) NULL,
    content TEXT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX article_attachment_article_id ON article_attachment (article_id);
-- ----------------------------------------------------------
--  create table standard_response
-- ----------------------------------------------------------
CREATE TABLE standard_response (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (80) NOT NULL,
    text TEXT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (100) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT standard_response_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table queue_standard_response
-- ----------------------------------------------------------
CREATE TABLE queue_standard_response (
    queue_id INTEGER NOT NULL,
    standard_response_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);
-- ----------------------------------------------------------
--  create table standard_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_attachment (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (150) NOT NULL,
    content_type VARCHAR (150) NOT NULL,
    content TEXT NOT NULL,
    filename VARCHAR (250) NOT NULL,
    comments VARCHAR (200) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT standard_attachment_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table standard_response_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_response_attachment (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    standard_attachment_id INTEGER NOT NULL,
    standard_response_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table auto_response_type
-- ----------------------------------------------------------
CREATE TABLE auto_response_type (
    id SMALLINT NOT NULL IDENTITY(1,1) ,
    name VARCHAR (50) NOT NULL,
    comments VARCHAR (200) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT auto_response_type_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table auto_response
-- ----------------------------------------------------------
CREATE TABLE auto_response (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (100) NOT NULL,
    text0 VARCHAR (6000) NULL,
    text1 VARCHAR (6000) NULL,
    text2 VARCHAR (6000) NULL,
    type_id SMALLINT NOT NULL,
    system_address_id SMALLINT NOT NULL,
    charset VARCHAR (80) NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (100) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    CONSTRAINT auto_response_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table queue_auto_response
-- ----------------------------------------------------------
CREATE TABLE queue_auto_response (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    queue_id INTEGER NOT NULL,
    auto_response_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table time_accounting
-- ----------------------------------------------------------
CREATE TABLE time_accounting (
    id BIGINT NOT NULL IDENTITY(1,1) ,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NULL,
    time_unit DECIMAL (10,2) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX time_accounting_ticket_id ON time_accounting (ticket_id);
-- ----------------------------------------------------------
--  create table ticket_watcher
-- ----------------------------------------------------------
CREATE TABLE ticket_watcher (
    ticket_id BIGINT NOT NULL,
    user_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);
CREATE INDEX ticket_watcher_ticket_id ON ticket_watcher (ticket_id);
CREATE INDEX ticket_watcher_user_id ON ticket_watcher (user_id);
-- ----------------------------------------------------------
--  create table service
-- ----------------------------------------------------------
CREATE TABLE service (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (200) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
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
CREATE INDEX service_preferences_service_id ON service_preferences (service_id);
-- ----------------------------------------------------------
--  create table service_customer_user
-- ----------------------------------------------------------
CREATE TABLE service_customer_user (
    customer_user_login VARCHAR (100) NOT NULL,
    service_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL
);
CREATE INDEX service_customer_user_customer_user_login ON service_customer_user (customer_user_login);
CREATE INDEX service_customer_user_service_id ON service_customer_user (service_id);
-- ----------------------------------------------------------
--  create table sla
-- ----------------------------------------------------------
CREATE TABLE sla (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (200) NOT NULL,
    calendar_name VARCHAR (100) NULL,
    first_response_time INTEGER NOT NULL,
    first_response_notify SMALLINT NULL,
    update_time INTEGER NOT NULL,
    update_notify SMALLINT NULL,
    solution_time INTEGER NOT NULL,
    solution_notify SMALLINT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (200) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
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
CREATE INDEX sla_preferences_sla_id ON sla_preferences (sla_id);
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
    session_id VARCHAR (150) NOT NULL,
    session_value TEXT NOT NULL,
    PRIMARY KEY(session_id)
);
-- ----------------------------------------------------------
--  create table ticket_index
-- ----------------------------------------------------------
CREATE TABLE ticket_index (
    ticket_id BIGINT NOT NULL,
    queue_id INTEGER NOT NULL,
    queue VARCHAR (70) NOT NULL,
    group_id INTEGER NOT NULL,
    s_lock VARCHAR (70) NOT NULL,
    s_state VARCHAR (70) NOT NULL,
    create_time_unix BIGINT NOT NULL
);
CREATE INDEX ticket_index_group_id ON ticket_index (group_id);
CREATE INDEX ticket_index_queue_id ON ticket_index (queue_id);
CREATE INDEX ticket_index_ticket_id ON ticket_index (ticket_id);
-- ----------------------------------------------------------
--  create table ticket_lock_index
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_index (
    ticket_id BIGINT NOT NULL
);
CREATE INDEX ticket_lock_index_ticket_id ON ticket_lock_index (ticket_id);
-- ----------------------------------------------------------
--  create table customer_user
-- ----------------------------------------------------------
CREATE TABLE customer_user (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    login VARCHAR (100) NOT NULL,
    email VARCHAR (150) NOT NULL,
    customer_id VARCHAR (200) NOT NULL,
    pw VARCHAR (50) NULL,
    salutation VARCHAR (50) NULL,
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    phone VARCHAR (150) NULL,
    fax VARCHAR (150) NULL,
    mobile VARCHAR (150) NULL,
    street VARCHAR (150) NULL,
    zip VARCHAR (150) NULL,
    city VARCHAR (150) NULL,
    country VARCHAR (150) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
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
CREATE INDEX customer_preferences_user_id ON customer_preferences (user_id);
-- ----------------------------------------------------------
--  create table customer_company
-- ----------------------------------------------------------
CREATE TABLE customer_company (
    customer_id VARCHAR (100) NOT NULL,
    name VARCHAR (100) NOT NULL,
    street VARCHAR (200) NULL,
    zip VARCHAR (200) NULL,
    city VARCHAR (200) NULL,
    country VARCHAR (200) NULL,
    url VARCHAR (200) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(customer_id),
    CONSTRAINT customer_company_name UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_loop_protection
-- ----------------------------------------------------------
CREATE TABLE ticket_loop_protection (
    sent_to VARCHAR (250) NOT NULL,
    sent_date VARCHAR (150) NOT NULL
);
CREATE INDEX ticket_loop_protection_sent_date ON ticket_loop_protection (sent_date);
CREATE INDEX ticket_loop_protection_sent_to ON ticket_loop_protection (sent_to);
-- ----------------------------------------------------------
--  create table mail_account
-- ----------------------------------------------------------
CREATE TABLE mail_account (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    login VARCHAR (200) NOT NULL,
    pw VARCHAR (200) NOT NULL,
    host VARCHAR (200) NOT NULL,
    account_type VARCHAR (20) NOT NULL,
    queue_id INTEGER NOT NULL,
    trusted SMALLINT NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
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
    f_value VARCHAR (200) NOT NULL
);
CREATE INDEX postmaster_filter_f_name ON postmaster_filter (f_name);
-- ----------------------------------------------------------
--  create table generic_agent_jobs
-- ----------------------------------------------------------
CREATE TABLE generic_agent_jobs (
    job_name VARCHAR (200) NOT NULL,
    job_key VARCHAR (200) NOT NULL,
    job_value VARCHAR (200) NULL
);
CREATE INDEX generic_agent_jobs_job_name ON generic_agent_jobs (job_name);
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
CREATE INDEX search_profile_login ON search_profile (login);
CREATE INDEX search_profile_profile_name ON search_profile (profile_name);
-- ----------------------------------------------------------
--  create table process_id
-- ----------------------------------------------------------
CREATE TABLE process_id (
    process_name VARCHAR (200) NOT NULL,
    process_id VARCHAR (200) NOT NULL,
    process_host VARCHAR (200) NOT NULL,
    process_create INTEGER NOT NULL
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
    content TEXT NOT NULL,
    create_time_unix BIGINT NOT NULL
);
-- ----------------------------------------------------------
--  create table notifications
-- ----------------------------------------------------------
CREATE TABLE notifications (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    notification_type VARCHAR (200) NOT NULL,
    notification_charset VARCHAR (60) NOT NULL,
    notification_language VARCHAR (60) NOT NULL,
    subject VARCHAR (200) NOT NULL,
    text VARCHAR (4000) NOT NULL,
    content_type VARCHAR (250) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
-- ----------------------------------------------------------
--  create table xml_storage
-- ----------------------------------------------------------
CREATE TABLE xml_storage (
    xml_type VARCHAR (200) NOT NULL,
    xml_key VARCHAR (250) NOT NULL,
    xml_content_key VARCHAR (250) NOT NULL,
    xml_content_value TEXT NULL
);
CREATE INDEX xml_storage_key_type ON xml_storage (xml_key, xml_type);
CREATE INDEX xml_storage_xml_content_key ON xml_storage (xml_content_key);
-- ----------------------------------------------------------
--  create table package_repository
-- ----------------------------------------------------------
CREATE TABLE package_repository (
    id INTEGER NOT NULL IDENTITY(1,1) ,
    name VARCHAR (250) NOT NULL,
    version VARCHAR (250) NOT NULL,
    vendor VARCHAR (250) NOT NULL,
    install_status VARCHAR (250) NOT NULL,
    filename VARCHAR (250) NULL,
    content_size VARCHAR (30) NULL,
    content_type VARCHAR (250) NULL,
    content TEXT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
