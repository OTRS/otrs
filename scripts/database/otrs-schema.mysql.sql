# ----------------------------------------------------------
#  driver: mysql
# ----------------------------------------------------------
# ----------------------------------------------------------
#  create table acl
# ----------------------------------------------------------
CREATE TABLE acl (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    description VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    stop_after_match SMALLINT NULL,
    config_match LONGBLOB NULL,
    config_change LONGBLOB NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX acl_name (name)
);
# ----------------------------------------------------------
#  create table acl_sync
# ----------------------------------------------------------
CREATE TABLE acl_sync (
    acl_id VARCHAR (200) NOT NULL,
    sync_state VARCHAR (30) NOT NULL,
    create_time DATETIME NOT NULL,
    change_time DATETIME NOT NULL
);
# ----------------------------------------------------------
#  create table valid
# ----------------------------------------------------------
CREATE TABLE valid (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX valid_name (name)
);
# ----------------------------------------------------------
#  create table users
# ----------------------------------------------------------
CREATE TABLE users (
    id INTEGER NOT NULL AUTO_INCREMENT,
    login VARCHAR (200) NOT NULL,
    pw VARCHAR (64) NOT NULL,
    title VARCHAR (50) NULL,
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX users_login (login)
);
# ----------------------------------------------------------
#  create table user_preferences
# ----------------------------------------------------------
CREATE TABLE user_preferences (
    user_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value LONGBLOB NULL,
    INDEX user_preferences_user_id (user_id)
);
# ----------------------------------------------------------
#  create table groups
# ----------------------------------------------------------
CREATE TABLE groups (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX groups_name (name)
);
# ----------------------------------------------------------
#  create table group_user
# ----------------------------------------------------------
CREATE TABLE group_user (
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX group_user_group_id (group_id),
    INDEX group_user_user_id (user_id)
);
# ----------------------------------------------------------
#  create table group_role
# ----------------------------------------------------------
CREATE TABLE group_role (
    role_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX group_role_group_id (group_id),
    INDEX group_role_role_id (role_id)
);
# ----------------------------------------------------------
#  create table group_customer_user
# ----------------------------------------------------------
CREATE TABLE group_customer_user (
    user_id VARCHAR (100) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX group_customer_user_group_id (group_id),
    INDEX group_customer_user_user_id (user_id)
);
# ----------------------------------------------------------
#  create table group_customer
# ----------------------------------------------------------
CREATE TABLE group_customer (
    customer_id VARCHAR (150) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    permission_context VARCHAR (100) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX group_customer_customer_id (customer_id),
    INDEX group_customer_group_id (group_id)
);
# ----------------------------------------------------------
#  create table roles
# ----------------------------------------------------------
CREATE TABLE roles (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX roles_name (name)
);
# ----------------------------------------------------------
#  create table role_user
# ----------------------------------------------------------
CREATE TABLE role_user (
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX role_user_role_id (role_id),
    INDEX role_user_user_id (user_id)
);
# ----------------------------------------------------------
#  create table personal_queues
# ----------------------------------------------------------
CREATE TABLE personal_queues (
    user_id INTEGER NOT NULL,
    queue_id INTEGER NOT NULL,
    INDEX personal_queues_queue_id (queue_id),
    INDEX personal_queues_user_id (user_id)
);
# ----------------------------------------------------------
#  create table personal_services
# ----------------------------------------------------------
CREATE TABLE personal_services (
    user_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    INDEX personal_services_service_id (service_id),
    INDEX personal_services_user_id (user_id)
);
# ----------------------------------------------------------
#  create table salutation
# ----------------------------------------------------------
CREATE TABLE salutation (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    text TEXT NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX salutation_name (name)
);
# ----------------------------------------------------------
#  create table signature
# ----------------------------------------------------------
CREATE TABLE signature (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    text TEXT NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX signature_name (name)
);
# ----------------------------------------------------------
#  create table system_address
# ----------------------------------------------------------
CREATE TABLE system_address (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    value0 VARCHAR (200) NOT NULL,
    value1 VARCHAR (200) NOT NULL,
    value2 VARCHAR (200) NULL,
    value3 VARCHAR (200) NULL,
    queue_id INTEGER NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table system_maintenance
# ----------------------------------------------------------
CREATE TABLE system_maintenance (
    id INTEGER NOT NULL AUTO_INCREMENT,
    start_date INTEGER NOT NULL,
    stop_date INTEGER NOT NULL,
    comments VARCHAR (250) NOT NULL,
    login_message VARCHAR (250) NULL,
    show_login_message SMALLINT NULL,
    notify_message VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table follow_up_possible
# ----------------------------------------------------------
CREATE TABLE follow_up_possible (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX follow_up_possible_name (name)
);
# ----------------------------------------------------------
#  create table queue
# ----------------------------------------------------------
CREATE TABLE queue (
    id INTEGER NOT NULL AUTO_INCREMENT,
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
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX queue_name (name),
    INDEX queue_group_id (group_id)
);
# ----------------------------------------------------------
#  create table queue_preferences
# ----------------------------------------------------------
CREATE TABLE queue_preferences (
    queue_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL,
    INDEX queue_preferences_queue_id (queue_id)
);
# ----------------------------------------------------------
#  create table ticket_priority
# ----------------------------------------------------------
CREATE TABLE ticket_priority (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX ticket_priority_name (name)
);
# ----------------------------------------------------------
#  create table ticket_type
# ----------------------------------------------------------
CREATE TABLE ticket_type (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX ticket_type_name (name)
);
# ----------------------------------------------------------
#  create table ticket_lock_type
# ----------------------------------------------------------
CREATE TABLE ticket_lock_type (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX ticket_lock_type_name (name)
);
# ----------------------------------------------------------
#  create table ticket_state
# ----------------------------------------------------------
CREATE TABLE ticket_state (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    type_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX ticket_state_name (name)
);
# ----------------------------------------------------------
#  create table ticket_state_type
# ----------------------------------------------------------
CREATE TABLE ticket_state_type (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX ticket_state_type_name (name)
);
# ----------------------------------------------------------
#  create table ticket
# ----------------------------------------------------------
CREATE TABLE ticket (
    id BIGINT NOT NULL AUTO_INCREMENT,
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
    archive_flag SMALLINT NOT NULL DEFAULT 0,
    create_time_unix BIGINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX ticket_tn (tn),
    INDEX ticket_archive_flag (archive_flag),
    INDEX ticket_create_time (create_time),
    INDEX ticket_create_time_unix (create_time_unix),
    INDEX ticket_customer_id (customer_id),
    INDEX ticket_customer_user_id (customer_user_id),
    INDEX ticket_escalation_response_time (escalation_response_time),
    INDEX ticket_escalation_solution_time (escalation_solution_time),
    INDEX ticket_escalation_time (escalation_time),
    INDEX ticket_escalation_update_time (escalation_update_time),
    INDEX ticket_queue_id (queue_id),
    INDEX ticket_queue_view (ticket_state_id, ticket_lock_id),
    INDEX ticket_responsible_user_id (responsible_user_id),
    INDEX ticket_ticket_lock_id (ticket_lock_id),
    INDEX ticket_ticket_priority_id (ticket_priority_id),
    INDEX ticket_ticket_state_id (ticket_state_id),
    INDEX ticket_timeout (timeout),
    INDEX ticket_title (title),
    INDEX ticket_type_id (type_id),
    INDEX ticket_until_time (until_time),
    INDEX ticket_user_id (user_id)
);
# ----------------------------------------------------------
#  create table ticket_flag
# ----------------------------------------------------------
CREATE TABLE ticket_flag (
    ticket_id BIGINT NOT NULL,
    ticket_key VARCHAR (50) NOT NULL,
    ticket_value VARCHAR (50) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    UNIQUE INDEX ticket_flag_per_user (ticket_id, ticket_key, create_by),
    INDEX ticket_flag_ticket_id (ticket_id),
    INDEX ticket_flag_ticket_id_create_by (ticket_id, create_by),
    INDEX ticket_flag_ticket_id_ticket_key (ticket_id, ticket_key)
);
# ----------------------------------------------------------
#  create table ticket_history
# ----------------------------------------------------------
CREATE TABLE ticket_history (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    history_type_id SMALLINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NULL,
    type_id SMALLINT NOT NULL,
    queue_id INTEGER NOT NULL,
    owner_id INTEGER NOT NULL,
    priority_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX ticket_history_article_id (article_id),
    INDEX ticket_history_create_time (create_time),
    INDEX ticket_history_history_type_id (history_type_id),
    INDEX ticket_history_owner_id (owner_id),
    INDEX ticket_history_priority_id (priority_id),
    INDEX ticket_history_queue_id (queue_id),
    INDEX ticket_history_state_id (state_id),
    INDEX ticket_history_ticket_id (ticket_id),
    INDEX ticket_history_type_id (type_id)
);
# ----------------------------------------------------------
#  create table ticket_history_type
# ----------------------------------------------------------
CREATE TABLE ticket_history_type (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX ticket_history_type_name (name)
);
# ----------------------------------------------------------
#  create table ticket_watcher
# ----------------------------------------------------------
CREATE TABLE ticket_watcher (
    ticket_id BIGINT NOT NULL,
    user_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX ticket_watcher_ticket_id (ticket_id),
    INDEX ticket_watcher_user_id (user_id)
);
# ----------------------------------------------------------
#  create table ticket_index
# ----------------------------------------------------------
CREATE TABLE ticket_index (
    ticket_id BIGINT NOT NULL,
    queue_id INTEGER NOT NULL,
    queue VARCHAR (200) NOT NULL,
    group_id INTEGER NOT NULL,
    s_lock VARCHAR (200) NOT NULL,
    s_state VARCHAR (200) NOT NULL,
    create_time_unix BIGINT NOT NULL,
    INDEX ticket_index_group_id (group_id),
    INDEX ticket_index_queue_id (queue_id),
    INDEX ticket_index_ticket_id (ticket_id)
);
# ----------------------------------------------------------
#  create table ticket_lock_index
# ----------------------------------------------------------
CREATE TABLE ticket_lock_index (
    ticket_id BIGINT NOT NULL,
    INDEX ticket_lock_index_ticket_id (ticket_id)
);
# ----------------------------------------------------------
#  create table ticket_loop_protection
# ----------------------------------------------------------
CREATE TABLE ticket_loop_protection (
    sent_to VARCHAR (250) NOT NULL,
    sent_date VARCHAR (150) NOT NULL,
    INDEX ticket_loop_protection_sent_date (sent_date),
    INDEX ticket_loop_protection_sent_to (sent_to)
);
# ----------------------------------------------------------
#  create table article_sender_type
# ----------------------------------------------------------
CREATE TABLE article_sender_type (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX article_sender_type_name (name)
);
# ----------------------------------------------------------
#  create table article_flag
# ----------------------------------------------------------
CREATE TABLE article_flag (
    article_id BIGINT NOT NULL,
    article_key VARCHAR (50) NOT NULL,
    article_value VARCHAR (50) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    INDEX article_flag_article_id (article_id),
    INDEX article_flag_article_id_create_by (article_id, create_by)
);
# ----------------------------------------------------------
#  create table communication_channel
# ----------------------------------------------------------
CREATE TABLE communication_channel (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    module VARCHAR (200) NOT NULL,
    package_name VARCHAR (200) NOT NULL,
    channel_data LONGBLOB NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX communication_channel_name (name)
);
# ----------------------------------------------------------
#  create table article
# ----------------------------------------------------------
CREATE TABLE article (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    communication_channel_id BIGINT NOT NULL,
    is_visible_for_customer SMALLINT NOT NULL,
    insert_fingerprint VARCHAR (64) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX article_article_sender_type_id (article_sender_type_id),
    INDEX article_communication_channel_id (communication_channel_id),
    INDEX article_ticket_id (ticket_id)
);
# ----------------------------------------------------------
#  create table article_data_mime
# ----------------------------------------------------------
CREATE TABLE article_data_mime (
    id BIGINT NOT NULL AUTO_INCREMENT,
    article_id BIGINT NOT NULL,
    a_from MEDIUMTEXT NULL,
    a_reply_to MEDIUMTEXT NULL,
    a_to MEDIUMTEXT NULL,
    a_cc MEDIUMTEXT NULL,
    a_subject TEXT NULL,
    a_message_id TEXT NULL,
    a_message_id_md5 VARCHAR (32) NULL,
    a_in_reply_to MEDIUMTEXT NULL,
    a_references MEDIUMTEXT NULL,
    a_content_type VARCHAR (250) NULL,
    a_body MEDIUMTEXT NOT NULL,
    incoming_time INTEGER NOT NULL,
    content_path VARCHAR (250) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX article_data_mime_article_id (article_id),
    INDEX article_data_mime_message_id_md5 (a_message_id_md5)
);
# ----------------------------------------------------------
#  create table article_search_index
# ----------------------------------------------------------
CREATE TABLE article_search_index (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NOT NULL,
    article_key VARCHAR (200) NOT NULL,
    article_value MEDIUMTEXT NULL,
    PRIMARY KEY(id),
    INDEX article_search_index_article_id (article_id),
    INDEX article_search_index_ticket_id (ticket_id)
);
# ----------------------------------------------------------
#  create table article_data_mime_plain
# ----------------------------------------------------------
CREATE TABLE article_data_mime_plain (
    id BIGINT NOT NULL AUTO_INCREMENT,
    article_id BIGINT NOT NULL,
    body LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX article_data_mime_plain_article_id (article_id)
);
# ----------------------------------------------------------
#  create table article_data_mime_attachment
# ----------------------------------------------------------
CREATE TABLE article_data_mime_attachment (
    id BIGINT NOT NULL AUTO_INCREMENT,
    article_id BIGINT NOT NULL,
    filename VARCHAR (250) NULL,
    content_size VARCHAR (30) NULL,
    content_type TEXT NULL,
    content_id VARCHAR (250) NULL,
    content_alternative VARCHAR (50) NULL,
    disposition VARCHAR (15) NULL,
    content LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX article_data_mime_attachment_article_id (article_id)
);
# ----------------------------------------------------------
#  create table time_accounting
# ----------------------------------------------------------
CREATE TABLE time_accounting (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT NULL,
    time_unit DECIMAL (10,2) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX time_accounting_ticket_id (ticket_id)
);
# ----------------------------------------------------------
#  create table standard_template
# ----------------------------------------------------------
CREATE TABLE standard_template (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    text TEXT NULL,
    content_type VARCHAR (250) NULL,
    template_type VARCHAR (100) NOT NULL DEFAULT 'Answer',
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX standard_template_name (name)
);
# ----------------------------------------------------------
#  create table queue_standard_template
# ----------------------------------------------------------
CREATE TABLE queue_standard_template (
    queue_id INTEGER NOT NULL,
    standard_template_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);
# ----------------------------------------------------------
#  create table standard_attachment
# ----------------------------------------------------------
CREATE TABLE standard_attachment (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    content_type VARCHAR (250) NOT NULL,
    content LONGBLOB NOT NULL,
    filename VARCHAR (250) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX standard_attachment_name (name)
);
# ----------------------------------------------------------
#  create table standard_template_attachment
# ----------------------------------------------------------
CREATE TABLE standard_template_attachment (
    id INTEGER NOT NULL AUTO_INCREMENT,
    standard_attachment_id INTEGER NOT NULL,
    standard_template_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table auto_response_type
# ----------------------------------------------------------
CREATE TABLE auto_response_type (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX auto_response_type_name (name)
);
# ----------------------------------------------------------
#  create table auto_response
# ----------------------------------------------------------
CREATE TABLE auto_response (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    text0 TEXT NULL,
    text1 TEXT NULL,
    type_id SMALLINT NOT NULL,
    system_address_id SMALLINT NOT NULL,
    content_type VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX auto_response_name (name)
);
# ----------------------------------------------------------
#  create table queue_auto_response
# ----------------------------------------------------------
CREATE TABLE queue_auto_response (
    id INTEGER NOT NULL AUTO_INCREMENT,
    queue_id INTEGER NOT NULL,
    auto_response_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table service
# ----------------------------------------------------------
CREATE TABLE service (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (250) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX service_name (name)
);
# ----------------------------------------------------------
#  create table service_preferences
# ----------------------------------------------------------
CREATE TABLE service_preferences (
    service_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL,
    INDEX service_preferences_service_id (service_id)
);
# ----------------------------------------------------------
#  create table service_customer_user
# ----------------------------------------------------------
CREATE TABLE service_customer_user (
    customer_user_login VARCHAR (200) NOT NULL,
    service_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    INDEX service_customer_user_customer_user_login (customer_user_login(10)),
    INDEX service_customer_user_service_id (service_id)
);
# ----------------------------------------------------------
#  create table sla
# ----------------------------------------------------------
CREATE TABLE sla (
    id INTEGER NOT NULL AUTO_INCREMENT,
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
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX sla_name (name)
);
# ----------------------------------------------------------
#  create table sla_preferences
# ----------------------------------------------------------
CREATE TABLE sla_preferences (
    sla_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL,
    INDEX sla_preferences_sla_id (sla_id)
);
# ----------------------------------------------------------
#  create table service_sla
# ----------------------------------------------------------
CREATE TABLE service_sla (
    service_id INTEGER NOT NULL,
    sla_id INTEGER NOT NULL,
    UNIQUE INDEX service_sla_service_sla (service_id, sla_id)
);
# ----------------------------------------------------------
#  create table sessions
# ----------------------------------------------------------
CREATE TABLE sessions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    session_id VARCHAR (100) NOT NULL,
    data_key VARCHAR (100) NOT NULL,
    data_value TEXT NULL,
    serialized SMALLINT NOT NULL,
    PRIMARY KEY(id),
    INDEX sessions_data_key (data_key),
    INDEX sessions_session_id_data_key (session_id, data_key)
);
# ----------------------------------------------------------
#  create table customer_user
# ----------------------------------------------------------
CREATE TABLE customer_user (
    id INTEGER NOT NULL AUTO_INCREMENT,
    login VARCHAR (200) NOT NULL,
    email VARCHAR (150) NOT NULL,
    customer_id VARCHAR (150) NOT NULL,
    pw VARCHAR (64) NULL,
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
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX customer_user_login (login)
);
# ----------------------------------------------------------
#  create table customer_preferences
# ----------------------------------------------------------
CREATE TABLE customer_preferences (
    user_id VARCHAR (250) NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250) NULL,
    INDEX customer_preferences_user_id (user_id)
);
# ----------------------------------------------------------
#  create table customer_company
# ----------------------------------------------------------
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
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(customer_id),
    UNIQUE INDEX customer_company_name (name)
);
# ----------------------------------------------------------
#  create table customer_user_customer
# ----------------------------------------------------------
CREATE TABLE customer_user_customer (
    user_id VARCHAR (100) NOT NULL,
    customer_id VARCHAR (150) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    INDEX customer_user_customer_customer_id (customer_id),
    INDEX customer_user_customer_user_id (user_id)
);
# ----------------------------------------------------------
#  create table mail_account
# ----------------------------------------------------------
CREATE TABLE mail_account (
    id INTEGER NOT NULL AUTO_INCREMENT,
    login VARCHAR (200) NOT NULL,
    pw VARCHAR (200) NOT NULL,
    host VARCHAR (200) NOT NULL,
    account_type VARCHAR (20) NOT NULL,
    queue_id INTEGER NOT NULL,
    trusted SMALLINT NOT NULL,
    imap_folder VARCHAR (250) NULL,
    comments VARCHAR (250) NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table postmaster_filter
# ----------------------------------------------------------
CREATE TABLE postmaster_filter (
    f_name VARCHAR (200) NOT NULL,
    f_stop SMALLINT NULL,
    f_type VARCHAR (20) NOT NULL,
    f_key VARCHAR (200) NOT NULL,
    f_value VARCHAR (200) NOT NULL,
    f_not SMALLINT NULL,
    INDEX postmaster_filter_f_name (f_name)
);
# ----------------------------------------------------------
#  create table generic_agent_jobs
# ----------------------------------------------------------
CREATE TABLE generic_agent_jobs (
    job_name VARCHAR (200) NOT NULL,
    job_key VARCHAR (200) NOT NULL,
    job_value VARCHAR (200) NULL,
    INDEX generic_agent_jobs_job_name (job_name)
);
# ----------------------------------------------------------
#  create table search_profile
# ----------------------------------------------------------
CREATE TABLE search_profile (
    login VARCHAR (200) NOT NULL,
    profile_name VARCHAR (200) NOT NULL,
    profile_type VARCHAR (30) NOT NULL,
    profile_key VARCHAR (200) NOT NULL,
    profile_value VARCHAR (200) NULL,
    INDEX search_profile_login (login),
    INDEX search_profile_profile_name (profile_name)
);
# ----------------------------------------------------------
#  create table process_id
# ----------------------------------------------------------
CREATE TABLE process_id (
    process_name VARCHAR (200) NOT NULL,
    process_id VARCHAR (200) NOT NULL,
    process_host VARCHAR (200) NOT NULL,
    process_create INTEGER NOT NULL,
    process_change INTEGER NOT NULL
);
# ----------------------------------------------------------
#  create table web_upload_cache
# ----------------------------------------------------------
CREATE TABLE web_upload_cache (
    form_id VARCHAR (250) NULL,
    filename VARCHAR (250) NULL,
    content_id VARCHAR (250) NULL,
    content_size VARCHAR (30) NULL,
    content_type VARCHAR (250) NULL,
    disposition VARCHAR (15) NULL,
    content LONGBLOB NOT NULL,
    create_time_unix BIGINT NOT NULL
);
# ----------------------------------------------------------
#  create table notification_event
# ----------------------------------------------------------
CREATE TABLE notification_event (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (250) NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX notification_event_name (name)
);
# ----------------------------------------------------------
#  create table notification_event_message
# ----------------------------------------------------------
CREATE TABLE notification_event_message (
    id INTEGER NOT NULL AUTO_INCREMENT,
    notification_id INTEGER NOT NULL,
    subject VARCHAR (200) NOT NULL,
    text TEXT NOT NULL,
    content_type VARCHAR (250) NOT NULL,
    language VARCHAR (60) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX notification_event_message_notification_id_language (notification_id, language),
    INDEX notification_event_message_language (language),
    INDEX notification_event_message_notification_id (notification_id)
);
# ----------------------------------------------------------
#  create table notification_event_item
# ----------------------------------------------------------
CREATE TABLE notification_event_item (
    notification_id INTEGER NOT NULL,
    event_key VARCHAR (200) NOT NULL,
    event_value VARCHAR (200) NOT NULL,
    INDEX notification_event_item_event_key (event_key),
    INDEX notification_event_item_event_value (event_value),
    INDEX notification_event_item_notification_id (notification_id)
);
# ----------------------------------------------------------
#  create table link_type
# ----------------------------------------------------------
CREATE TABLE link_type (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX link_type_name (name)
);
# ----------------------------------------------------------
#  create table link_state
# ----------------------------------------------------------
CREATE TABLE link_state (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX link_state_name (name)
);
# ----------------------------------------------------------
#  create table link_object
# ----------------------------------------------------------
CREATE TABLE link_object (
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX link_object_name (name)
);
# ----------------------------------------------------------
#  create table link_relation
# ----------------------------------------------------------
CREATE TABLE link_relation (
    source_object_id SMALLINT NOT NULL,
    source_key VARCHAR (50) NOT NULL,
    target_object_id SMALLINT NOT NULL,
    target_key VARCHAR (50) NOT NULL,
    type_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    UNIQUE INDEX link_relation_view (source_object_id, source_key, target_object_id, target_key, type_id),
    INDEX link_relation_list_source (source_object_id, source_key, state_id),
    INDEX link_relation_list_target (target_object_id, target_key, state_id)
);
# ----------------------------------------------------------
#  create table system_data
# ----------------------------------------------------------
CREATE TABLE system_data (
    data_key VARCHAR (160) NOT NULL,
    data_value LONGBLOB NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(data_key)
);
# ----------------------------------------------------------
#  create table xml_storage
# ----------------------------------------------------------
CREATE TABLE xml_storage (
    xml_type VARCHAR (200) NOT NULL,
    xml_key VARCHAR (250) NOT NULL,
    xml_content_key VARCHAR (250) NOT NULL,
    xml_content_value MEDIUMTEXT NULL,
    INDEX xml_storage_key_type (xml_key(10), xml_type(10)),
    INDEX xml_storage_xml_content_key (xml_content_key(100))
);
# ----------------------------------------------------------
#  create table virtual_fs
# ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL AUTO_INCREMENT,
    filename TEXT NOT NULL,
    backend VARCHAR (60) NOT NULL,
    backend_key VARCHAR (160) NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX virtual_fs_backend (backend(60)),
    INDEX virtual_fs_filename (filename(255))
);
# ----------------------------------------------------------
#  create table virtual_fs_preferences
# ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value TEXT NULL,
    INDEX virtual_fs_preferences_key_value (preferences_key, preferences_value(150)),
    INDEX virtual_fs_preferences_virtual_fs_id (virtual_fs_id)
);
# ----------------------------------------------------------
#  create table virtual_fs_db
# ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL AUTO_INCREMENT,
    filename TEXT NOT NULL,
    content LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX virtual_fs_db_filename (filename(255))
);
# ----------------------------------------------------------
#  create table package_repository
# ----------------------------------------------------------
CREATE TABLE package_repository (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    version VARCHAR (250) NOT NULL,
    vendor VARCHAR (250) NOT NULL,
    install_status VARCHAR (250) NOT NULL,
    filename VARCHAR (250) NULL,
    content_type VARCHAR (250) NULL,
    content LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table gi_webservice_config
# ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX gi_webservice_config_name (name)
);
# ----------------------------------------------------------
#  create table gi_webservice_config_history
# ----------------------------------------------------------
CREATE TABLE gi_webservice_config_history (
    id BIGINT NOT NULL AUTO_INCREMENT,
    config_id INTEGER NOT NULL,
    config LONGBLOB NOT NULL,
    config_md5 VARCHAR (32) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX gi_webservice_config_history_config_md5 (config_md5)
);
# ----------------------------------------------------------
#  create table gi_debugger_entry
# ----------------------------------------------------------
CREATE TABLE gi_debugger_entry (
    id BIGINT NOT NULL AUTO_INCREMENT,
    communication_id VARCHAR (32) NOT NULL,
    communication_type VARCHAR (50) NOT NULL,
    remote_ip VARCHAR (50) NULL,
    webservice_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX gi_debugger_entry_communication_id (communication_id),
    INDEX gi_debugger_entry_create_time (create_time)
);
# ----------------------------------------------------------
#  create table gi_debugger_entry_content
# ----------------------------------------------------------
CREATE TABLE gi_debugger_entry_content (
    id BIGINT NOT NULL AUTO_INCREMENT,
    gi_debugger_entry_id BIGINT NOT NULL,
    debug_level VARCHAR (50) NOT NULL,
    subject VARCHAR (255) NOT NULL,
    content LONGBLOB NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    INDEX gi_debugger_entry_content_create_time (create_time),
    INDEX gi_debugger_entry_content_debug_level (debug_level)
);
# ----------------------------------------------------------
#  create table smime_signer_cert_relations
# ----------------------------------------------------------
CREATE TABLE smime_signer_cert_relations (
    id INTEGER NOT NULL AUTO_INCREMENT,
    cert_hash VARCHAR (8) NOT NULL,
    cert_fingerprint VARCHAR (59) NOT NULL,
    ca_hash VARCHAR (8) NOT NULL,
    ca_fingerprint VARCHAR (59) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table dynamic_field_value
# ----------------------------------------------------------
CREATE TABLE dynamic_field_value (
    id INTEGER NOT NULL AUTO_INCREMENT,
    field_id INTEGER NOT NULL,
    object_id BIGINT NOT NULL,
    value_text TEXT NULL,
    value_date DATETIME NULL,
    value_int BIGINT NULL,
    PRIMARY KEY(id),
    INDEX dynamic_field_value_field_values (object_id, field_id),
    INDEX dynamic_field_value_search_date (field_id, value_date),
    INDEX dynamic_field_value_search_int (field_id, value_int),
    INDEX dynamic_field_value_search_text (field_id, value_text(150))
);
# ----------------------------------------------------------
#  create table dynamic_field
# ----------------------------------------------------------
CREATE TABLE dynamic_field (
    id INTEGER NOT NULL AUTO_INCREMENT,
    internal_field SMALLINT NOT NULL DEFAULT 0,
    name VARCHAR (200) NOT NULL,
    label VARCHAR (200) NOT NULL,
    field_order INTEGER NOT NULL,
    field_type VARCHAR (200) NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    config LONGBLOB NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX dynamic_field_name (name)
);
# ----------------------------------------------------------
#  create table dynamic_field_obj_id_name
# ----------------------------------------------------------
CREATE TABLE dynamic_field_obj_id_name (
    object_id INTEGER NOT NULL AUTO_INCREMENT,
    object_name VARCHAR (200) NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    PRIMARY KEY(object_id),
    UNIQUE INDEX dynamic_field_object_name (object_name, object_type)
);
# ----------------------------------------------------------
#  create table pm_process
# ----------------------------------------------------------
CREATE TABLE pm_process (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    state_entity_id VARCHAR (50) NOT NULL,
    layout LONGBLOB NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_process_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_activity
# ----------------------------------------------------------
CREATE TABLE pm_activity (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_activity_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_activity_dialog
# ----------------------------------------------------------
CREATE TABLE pm_activity_dialog (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_activity_dialog_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_transition
# ----------------------------------------------------------
CREATE TABLE pm_transition (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_transition_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_transition_action
# ----------------------------------------------------------
CREATE TABLE pm_transition_action (
    id INTEGER NOT NULL AUTO_INCREMENT,
    entity_id VARCHAR (50) NOT NULL,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX pm_transition_action_entity_id (entity_id)
);
# ----------------------------------------------------------
#  create table pm_entity_sync
# ----------------------------------------------------------
CREATE TABLE pm_entity_sync (
    entity_type VARCHAR (30) NOT NULL,
    entity_id VARCHAR (50) NOT NULL,
    sync_state VARCHAR (30) NOT NULL,
    create_time DATETIME NOT NULL,
    change_time DATETIME NOT NULL,
    UNIQUE INDEX pm_entity_sync_list (entity_type, entity_id)
);
# ----------------------------------------------------------
#  create table scheduler_task
# ----------------------------------------------------------
CREATE TABLE scheduler_task (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ident BIGINT NOT NULL,
    name VARCHAR (150) NULL,
    task_type VARCHAR (150) NOT NULL,
    task_data LONGBLOB NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    lock_update_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX scheduler_task_ident (ident),
    INDEX scheduler_task_ident_id (ident, id),
    INDEX scheduler_task_lock_key_id (lock_key, id)
);
# ----------------------------------------------------------
#  create table scheduler_future_task
# ----------------------------------------------------------
CREATE TABLE scheduler_future_task (
    id BIGINT NOT NULL AUTO_INCREMENT,
    ident BIGINT NOT NULL,
    execution_time DATETIME NOT NULL,
    name VARCHAR (150) NULL,
    task_type VARCHAR (150) NOT NULL,
    task_data LONGBLOB NOT NULL,
    attempts SMALLINT NOT NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX scheduler_future_task_ident (ident),
    INDEX scheduler_future_task_ident_id (ident, id),
    INDEX scheduler_future_task_lock_key_id (lock_key, id)
);
# ----------------------------------------------------------
#  create table scheduler_recurrent_task
# ----------------------------------------------------------
CREATE TABLE scheduler_recurrent_task (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (150) NOT NULL,
    task_type VARCHAR (150) NOT NULL,
    last_execution_time DATETIME NOT NULL,
    last_worker_task_id BIGINT NULL,
    last_worker_status SMALLINT NULL,
    last_worker_running_time INTEGER NULL,
    lock_key BIGINT NOT NULL,
    lock_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    change_time DATETIME NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX scheduler_recurrent_task_name_task_type (name, task_type),
    INDEX scheduler_recurrent_task_lock_key_id (lock_key, id),
    INDEX scheduler_recurrent_task_task_type_name (task_type, name)
);
# ----------------------------------------------------------
#  create table cloud_service_config
# ----------------------------------------------------------
CREATE TABLE cloud_service_config (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    config LONGBLOB NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX cloud_service_config_name (name)
);
# ----------------------------------------------------------
#  create table sysconfig_default
# ----------------------------------------------------------
CREATE TABLE sysconfig_default (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (250) NOT NULL,
    description LONGBLOB NOT NULL,
    navigation VARCHAR (200) NOT NULL,
    is_invisible SMALLINT NOT NULL,
    is_readonly SMALLINT NOT NULL,
    is_required SMALLINT NOT NULL,
    is_valid SMALLINT NOT NULL,
    has_configlevel SMALLINT NOT NULL,
    user_modification_possible SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    user_preferences_group VARCHAR (250) NULL,
    xml_content_raw LONGBLOB NOT NULL,
    xml_content_parsed LONGBLOB NOT NULL,
    xml_filename VARCHAR (250) NOT NULL,
    effective_value LONGBLOB NOT NULL,
    is_dirty SMALLINT NOT NULL,
    exclusive_lock_guid VARCHAR (32) NOT NULL,
    exclusive_lock_user_id INTEGER NULL,
    exclusive_lock_expiry_time DATETIME NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX sysconfig_default_name (name)
);
# ----------------------------------------------------------
#  create table sysconfig_default_version
# ----------------------------------------------------------
CREATE TABLE sysconfig_default_version (
    id INTEGER NOT NULL AUTO_INCREMENT,
    sysconfig_default_id INTEGER NULL,
    name VARCHAR (250) NOT NULL,
    description LONGBLOB NOT NULL,
    navigation VARCHAR (200) NOT NULL,
    is_invisible SMALLINT NOT NULL,
    is_readonly SMALLINT NOT NULL,
    is_required SMALLINT NOT NULL,
    is_valid SMALLINT NOT NULL,
    has_configlevel SMALLINT NOT NULL,
    user_modification_possible SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    user_preferences_group VARCHAR (250) NULL,
    xml_content_raw LONGBLOB NOT NULL,
    xml_content_parsed LONGBLOB NOT NULL,
    xml_filename VARCHAR (250) NOT NULL,
    effective_value LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table sysconfig_modified
# ----------------------------------------------------------
CREATE TABLE sysconfig_modified (
    id INTEGER NOT NULL AUTO_INCREMENT,
    sysconfig_default_id INTEGER NOT NULL,
    name VARCHAR (250) NOT NULL,
    user_id INTEGER NULL,
    is_valid SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    effective_value LONGBLOB NOT NULL,
    is_dirty SMALLINT NOT NULL,
    reset_to_default SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX sysconfig_modified_per_user (sysconfig_default_id, user_id)
);
# ----------------------------------------------------------
#  create table sysconfig_modified_version
# ----------------------------------------------------------
CREATE TABLE sysconfig_modified_version (
    id INTEGER NOT NULL AUTO_INCREMENT,
    sysconfig_default_version_id INTEGER NOT NULL,
    name VARCHAR (250) NOT NULL,
    user_id INTEGER NULL,
    is_valid SMALLINT NOT NULL,
    user_modification_active SMALLINT NOT NULL,
    effective_value LONGBLOB NOT NULL,
    reset_to_default SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table sysconfig_deployment_lock
# ----------------------------------------------------------
CREATE TABLE sysconfig_deployment_lock (
    id INTEGER NOT NULL AUTO_INCREMENT,
    exclusive_lock_guid VARCHAR (32) NULL,
    exclusive_lock_user_id INTEGER NULL,
    exclusive_lock_expiry_time DATETIME NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table sysconfig_deployment
# ----------------------------------------------------------
CREATE TABLE sysconfig_deployment (
    id INTEGER NOT NULL AUTO_INCREMENT,
    comments VARCHAR (250) NULL,
    user_id INTEGER NULL,
    effective_value LONGBLOB NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table calendar
# ----------------------------------------------------------
CREATE TABLE calendar (
    id BIGINT NOT NULL AUTO_INCREMENT,
    group_id INTEGER NOT NULL,
    name VARCHAR (200) NOT NULL,
    salt_string VARCHAR (64) NOT NULL,
    color VARCHAR (7) NOT NULL,
    ticket_appointments LONGBLOB NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE INDEX calendar_name (name)
);
# ----------------------------------------------------------
#  create table calendar_appointment
# ----------------------------------------------------------
CREATE TABLE calendar_appointment (
    id BIGINT NOT NULL AUTO_INCREMENT,
    parent_id BIGINT NULL,
    calendar_id BIGINT NOT NULL,
    unique_id VARCHAR (255) NOT NULL,
    title VARCHAR (255) NOT NULL,
    description TEXT NULL,
    location VARCHAR (255) NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    all_day SMALLINT NULL,
    notify_time DATETIME NULL,
    notify_template VARCHAR (255) NULL,
    notify_custom VARCHAR (255) NULL,
    notify_custom_unit_count BIGINT NULL,
    notify_custom_unit VARCHAR (255) NULL,
    notify_custom_unit_point VARCHAR (255) NULL,
    notify_custom_date DATETIME NULL,
    team_id TEXT NULL,
    resource_id TEXT NULL,
    recurring SMALLINT NULL,
    recur_type VARCHAR (20) NULL,
    recur_freq VARCHAR (255) NULL,
    recur_count INTEGER NULL,
    recur_interval INTEGER NULL,
    recur_until DATETIME NULL,
    recur_id DATETIME NULL,
    recur_exclude TEXT NULL,
    ticket_appointment_rule_id VARCHAR (32) NULL,
    create_time DATETIME NULL,
    create_by INTEGER NULL,
    change_time DATETIME NULL,
    change_by INTEGER NULL,
    PRIMARY KEY(id)
);
# ----------------------------------------------------------
#  create table calendar_appointment_ticket
# ----------------------------------------------------------
CREATE TABLE calendar_appointment_ticket (
    calendar_id BIGINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    rule_id VARCHAR (32) NOT NULL,
    appointment_id BIGINT NOT NULL,
    UNIQUE INDEX calendar_appointment_ticket_calendar_id_ticket_id_rule_id (calendar_id, ticket_id, rule_id),
    INDEX calendar_appointment_ticket_appointment_id (appointment_id),
    INDEX calendar_appointment_ticket_calendar_id (calendar_id),
    INDEX calendar_appointment_ticket_rule_id (rule_id),
    INDEX calendar_appointment_ticket_ticket_id (ticket_id)
);
