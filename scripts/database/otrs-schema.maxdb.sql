// ----------------------------------------------------------
//  driver: maxdb, generated: 2008-05-09 15:26:19
// ----------------------------------------------------------
// ----------------------------------------------------------
//  create table valid
// ----------------------------------------------------------
CREATE TABLE valid
(
    id serial,
    name VARCHAR (50) NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE valid_name (name)
)
//
// ----------------------------------------------------------
//  create table ticket_priority
// ----------------------------------------------------------
CREATE TABLE ticket_priority
(
    id serial,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE ticket_priority_name (name)
)
//
// ----------------------------------------------------------
//  create table ticket_type
// ----------------------------------------------------------
CREATE TABLE ticket_type
(
    id serial,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE ticket_type_name (name)
)
//
// ----------------------------------------------------------
//  create table ticket_lock_type
// ----------------------------------------------------------
CREATE TABLE ticket_lock_type
(
    id serial,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE ticket_lock_type_name (name)
)
//
// ----------------------------------------------------------
//  create table system_user
// ----------------------------------------------------------
CREATE TABLE system_user
(
    id serial,
    login VARCHAR (100) NOT NULL,
    pw VARCHAR (50) NOT NULL,
    salutation VARCHAR (50),
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE system_user_login (login)
)
//
// ----------------------------------------------------------
//  create table user_preferences
// ----------------------------------------------------------
CREATE TABLE user_preferences
(
    user_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
)
//
CREATE INDEX user_preferences_use95 ON user_preferences (user_id)
//
// ----------------------------------------------------------
//  create table groups
// ----------------------------------------------------------
CREATE TABLE groups
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE groups_name (name)
)
//
// ----------------------------------------------------------
//  create table group_user
// ----------------------------------------------------------
CREATE TABLE group_user
(
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
//
CREATE INDEX group_user_group_id ON group_user (group_id)
//
CREATE INDEX group_user_user_id ON group_user (user_id)
//
// ----------------------------------------------------------
//  create table group_role
// ----------------------------------------------------------
CREATE TABLE group_role
(
    role_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
//
CREATE INDEX group_role_group_id ON group_role (group_id)
//
CREATE INDEX group_role_role_id ON group_role (role_id)
//
// ----------------------------------------------------------
//  create table group_customer_user
// ----------------------------------------------------------
CREATE TABLE group_customer_user
(
    user_id VARCHAR (100) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
//
CREATE INDEX group_customer_user_44 ON group_customer_user (group_id)
//
CREATE INDEX group_customer_user_52 ON group_customer_user (user_id)
//
// ----------------------------------------------------------
//  create table roles
// ----------------------------------------------------------
CREATE TABLE roles
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE roles_name (name)
)
//
// ----------------------------------------------------------
//  create table role_user
// ----------------------------------------------------------
CREATE TABLE role_user
(
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
//
CREATE INDEX role_user_role_id ON role_user (role_id)
//
CREATE INDEX role_user_user_id ON role_user (user_id)
//
// ----------------------------------------------------------
//  create table personal_queues
// ----------------------------------------------------------
CREATE TABLE personal_queues
(
    user_id INTEGER NOT NULL,
    queue_id INTEGER NOT NULL
)
//
CREATE INDEX personal_queues_queu76 ON personal_queues (queue_id)
//
CREATE INDEX personal_queues_user54 ON personal_queues (user_id)
//
// ----------------------------------------------------------
//  create table theme
// ----------------------------------------------------------
CREATE TABLE theme
(
    id serial,
    theme VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE theme_theme (theme)
)
//
// ----------------------------------------------------------
//  create table ticket_state
// ----------------------------------------------------------
CREATE TABLE ticket_state
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    type_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE ticket_state_name (name)
)
//
// ----------------------------------------------------------
//  create table ticket_state_type
// ----------------------------------------------------------
CREATE TABLE ticket_state_type
(
    id serial,
    name VARCHAR (120) NOT NULL,
    comments VARCHAR (250),
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE ticket_state_type_name (name)
)
//
// ----------------------------------------------------------
//  create table salutation
// ----------------------------------------------------------
CREATE TABLE salutation
(
    id serial,
    name VARCHAR (100) NOT NULL,
    text VARCHAR (3000) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE salutation_name (name)
)
//
// ----------------------------------------------------------
//  create table signature
// ----------------------------------------------------------
CREATE TABLE signature
(
    id serial,
    name VARCHAR (100) NOT NULL,
    text VARCHAR (3000) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE signature_name (name)
)
//
// ----------------------------------------------------------
//  create table system_address
// ----------------------------------------------------------
CREATE TABLE system_address
(
    id serial,
    value0 VARCHAR (200) NOT NULL,
    value1 VARCHAR (200) NOT NULL,
    value2 VARCHAR (200),
    value3 VARCHAR (200),
    queue_id INTEGER NOT NULL,
    comments VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
// ----------------------------------------------------------
//  create table follow_up_possible
// ----------------------------------------------------------
CREATE TABLE follow_up_possible
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE follow_up_possible_name (name)
)
//
// ----------------------------------------------------------
//  create table queue
// ----------------------------------------------------------
CREATE TABLE queue
(
    id serial,
    name VARCHAR (200) NOT NULL,
    group_id INTEGER NOT NULL,
    unlock_timeout INTEGER,
    first_response_time INTEGER,
    first_response_notify SMALLINT,
    update_time INTEGER,
    update_notify SMALLINT,
    solution_time INTEGER,
    solution_notify SMALLINT,
    system_address_id SMALLINT NOT NULL,
    calendar_name VARCHAR (100),
    default_sign_key VARCHAR (100),
    salutation_id SMALLINT NOT NULL,
    signature_id SMALLINT NOT NULL,
    follow_up_id SMALLINT NOT NULL,
    follow_up_lock SMALLINT NOT NULL,
    move_notify SMALLINT NOT NULL,
    state_notify SMALLINT NOT NULL,
    lock_notify SMALLINT NOT NULL,
    owner_notify SMALLINT NOT NULL,
    comments VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE queue_name (name)
)
//
CREATE INDEX queue_group_id ON queue (group_id)
//
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
CREATE INDEX queue_preferences_qu69 ON queue_preferences (queue_id)
//
// ----------------------------------------------------------
//  create table ticket
// ----------------------------------------------------------
CREATE TABLE ticket
(
    id serial,
    tn VARCHAR (50) NOT NULL,
    title VARCHAR (255),
    queue_id INTEGER NOT NULL,
    ticket_lock_id SMALLINT NOT NULL,
    ticket_answered SMALLINT NOT NULL,
    type_id SMALLINT,
    service_id INTEGER,
    sla_id INTEGER,
    user_id INTEGER NOT NULL,
    responsible_user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    ticket_priority_id SMALLINT NOT NULL,
    ticket_state_id SMALLINT NOT NULL,
    group_read SMALLINT,
    group_write SMALLINT,
    other_read SMALLINT,
    other_write SMALLINT,
    customer_id VARCHAR (150),
    customer_user_id VARCHAR (250),
    timeout INTEGER,
    until_time INTEGER,
    escalation_start_time INTEGER NOT NULL,
    escalation_response_time INTEGER NOT NULL,
    escalation_solution_time INTEGER NOT NULL,
    freekey1 VARCHAR (80),
    freetext1 VARCHAR (150),
    freekey2 VARCHAR (80),
    freetext2 VARCHAR (150),
    freekey3 VARCHAR (80),
    freetext3 VARCHAR (150),
    freekey4 VARCHAR (80),
    freetext4 VARCHAR (150),
    freekey5 VARCHAR (80),
    freetext5 VARCHAR (150),
    freekey6 VARCHAR (80),
    freetext6 VARCHAR (150),
    freekey7 VARCHAR (80),
    freetext7 VARCHAR (150),
    freekey8 VARCHAR (80),
    freetext8 VARCHAR (150),
    freekey9 VARCHAR (80),
    freetext9 VARCHAR (150),
    freekey10 VARCHAR (80),
    freetext10 VARCHAR (150),
    freekey11 VARCHAR (80),
    freetext11 VARCHAR (150),
    freekey12 VARCHAR (80),
    freetext12 VARCHAR (150),
    freekey13 VARCHAR (80),
    freetext13 VARCHAR (150),
    freekey14 VARCHAR (80),
    freetext14 VARCHAR (150),
    freekey15 VARCHAR (80),
    freetext15 VARCHAR (150),
    freekey16 VARCHAR (80),
    freetext16 VARCHAR (150),
    freetime1 timestamp,
    freetime2 timestamp,
    freetime3 timestamp,
    freetime4 timestamp,
    freetime5 timestamp,
    freetime6 timestamp,
    valid_id SMALLINT NOT NULL,
    create_time_unix INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE ticket_tn (tn)
)
//
CREATE INDEX ticket_answered ON ticket (ticket_answered)
//
CREATE INDEX ticket_customer_id ON ticket (customer_id)
//
CREATE INDEX ticket_customer_user61 ON ticket (customer_user_id)
//
CREATE INDEX ticket_queue_id ON ticket (queue_id)
//
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id, group_id)
//
CREATE INDEX ticket_responsible_u59 ON ticket (responsible_user_id)
//
CREATE INDEX ticket_ticket_lock_i89 ON ticket (ticket_lock_id)
//
CREATE INDEX ticket_ticket_priori59 ON ticket (ticket_priority_id)
//
CREATE INDEX ticket_ticket_state_34 ON ticket (ticket_state_id)
//
CREATE INDEX ticket_title ON ticket (title)
//
CREATE INDEX ticket_type_id ON ticket (type_id)
//
CREATE INDEX ticket_user_id ON ticket (user_id)
//
// ----------------------------------------------------------
//  create table object_link
// ----------------------------------------------------------
CREATE TABLE object_link
(
    object_link_a_id VARCHAR (80) NOT NULL,
    object_link_b_id VARCHAR (80) NOT NULL,
    object_link_a_object VARCHAR (200) NOT NULL,
    object_link_b_object VARCHAR (200) NOT NULL,
    object_link_type VARCHAR (200) NOT NULL
)
//
CREATE INDEX object_link_a_id ON object_link (object_link_a_id)
//
CREATE INDEX object_link_a_object38 ON object_link (object_link_a_object)
//
CREATE INDEX object_link_b_id ON object_link (object_link_b_id)
//
CREATE INDEX object_link_b_object32 ON object_link (object_link_b_object)
//
CREATE INDEX object_link_type ON object_link (object_link_type)
//
// ----------------------------------------------------------
//  create table ticket_history
// ----------------------------------------------------------
CREATE TABLE ticket_history
(
    id serial,
    name VARCHAR (200) NOT NULL,
    history_type_id SMALLINT NOT NULL,
    ticket_id INTEGER NOT NULL,
    article_id INTEGER,
    type_id SMALLINT NOT NULL,
    queue_id INTEGER NOT NULL,
    owner_id INTEGER NOT NULL,
    priority_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX ticket_history_creat75 ON ticket_history (create_time)
//
CREATE INDEX ticket_history_histo92 ON ticket_history (history_type_id)
//
CREATE INDEX ticket_history_owner15 ON ticket_history (owner_id)
//
CREATE INDEX ticket_history_prior72 ON ticket_history (priority_id)
//
CREATE INDEX ticket_history_queue16 ON ticket_history (queue_id)
//
CREATE INDEX ticket_history_state52 ON ticket_history (state_id)
//
CREATE INDEX ticket_history_ticke78 ON ticket_history (ticket_id)
//
CREATE INDEX ticket_history_type_77 ON ticket_history (type_id)
//
// ----------------------------------------------------------
//  create table ticket_history_type
// ----------------------------------------------------------
CREATE TABLE ticket_history_type
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE ticket_history_type_name (name)
)
//
// ----------------------------------------------------------
//  create table article_type
// ----------------------------------------------------------
CREATE TABLE article_type
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE article_type_name (name)
)
//
// ----------------------------------------------------------
//  create table article_sender_type
// ----------------------------------------------------------
CREATE TABLE article_sender_type
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE article_sender_type_name (name)
)
//
// ----------------------------------------------------------
//  create table article_flag
// ----------------------------------------------------------
CREATE TABLE article_flag
(
    article_id INTEGER NOT NULL,
    article_flag VARCHAR (50) NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL
)
//
CREATE INDEX article_flag_article20 ON article_flag (article_id)
//
CREATE INDEX article_flag_create_33 ON article_flag (create_by)
//
// ----------------------------------------------------------
//  create table article
// ----------------------------------------------------------
CREATE TABLE article
(
    id serial,
    ticket_id INTEGER NOT NULL,
    article_type_id SMALLINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    a_from VARCHAR (3800),
    a_reply_to VARCHAR (500),
    a_to VARCHAR (3800),
    a_cc VARCHAR (3800),
    a_subject VARCHAR (3800),
    a_message_id VARCHAR (3800),
    a_content_type VARCHAR (250),
    a_body LONG NOT NULL,
    incoming_time INTEGER NOT NULL,
    content_path VARCHAR (250),
    a_freekey1 VARCHAR (250),
    a_freetext1 VARCHAR (250),
    a_freekey2 VARCHAR (250),
    a_freetext2 VARCHAR (250),
    a_freekey3 VARCHAR (250),
    a_freetext3 VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX article_article_send68 ON article (article_sender_type_id)
//
CREATE INDEX article_article_type67 ON article (article_type_id)
//
CREATE INDEX article_message_id ON article (a_message_id)
//
CREATE INDEX article_ticket_id ON article (ticket_id)
//
// ----------------------------------------------------------
//  create table article_plain
// ----------------------------------------------------------
CREATE TABLE article_plain
(
    id serial,
    article_id INTEGER NOT NULL,
    body LONG NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX article_plain_articl40 ON article_plain (article_id)
//
// ----------------------------------------------------------
//  create table article_attachment
// ----------------------------------------------------------
CREATE TABLE article_attachment
(
    id serial,
    article_id INTEGER NOT NULL,
    filename VARCHAR (250),
    content_size VARCHAR (30),
    content_type VARCHAR (250),
    content LONG NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX article_attachment_a60 ON article_attachment (article_id)
//
// ----------------------------------------------------------
//  create table standard_response
// ----------------------------------------------------------
CREATE TABLE standard_response
(
    id serial,
    name VARCHAR (80) NOT NULL,
    text LONG,
    comments VARCHAR (100),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE standard_response_name (name)
)
//
// ----------------------------------------------------------
//  create table queue_standard_response
// ----------------------------------------------------------
CREATE TABLE queue_standard_response
(
    queue_id INTEGER NOT NULL,
    standard_response_id INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
//
// ----------------------------------------------------------
//  create table standard_attachment
// ----------------------------------------------------------
CREATE TABLE standard_attachment
(
    id serial,
    name VARCHAR (150) NOT NULL,
    content_type VARCHAR (150) NOT NULL,
    content LONG NOT NULL,
    filename VARCHAR (250) NOT NULL,
    comments VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE standard_attachment_name (name)
)
//
// ----------------------------------------------------------
//  create table standard_response_attachment
// ----------------------------------------------------------
CREATE TABLE standard_response_attachment
(
    id serial,
    standard_attachment_id INTEGER NOT NULL,
    standard_response_id INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
// ----------------------------------------------------------
//  create table auto_response_type
// ----------------------------------------------------------
CREATE TABLE auto_response_type
(
    id serial,
    name VARCHAR (50) NOT NULL,
    comments VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE auto_response_type_name (name)
)
//
// ----------------------------------------------------------
//  create table auto_response
// ----------------------------------------------------------
CREATE TABLE auto_response
(
    id serial,
    name VARCHAR (100) NOT NULL,
    text0 LONG,
    text1 LONG,
    text2 LONG,
    type_id SMALLINT NOT NULL,
    system_address_id SMALLINT NOT NULL,
    charset VARCHAR (80) NOT NULL,
    comments VARCHAR (100),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE auto_response_name (name)
)
//
// ----------------------------------------------------------
//  create table queue_auto_response
// ----------------------------------------------------------
CREATE TABLE queue_auto_response
(
    id serial,
    queue_id INTEGER NOT NULL,
    auto_response_id INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
// ----------------------------------------------------------
//  create table time_accounting
// ----------------------------------------------------------
CREATE TABLE time_accounting
(
    id serial,
    ticket_id INTEGER NOT NULL,
    article_id INTEGER,
    time_unit DECIMAL (10,2) NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX time_accounting_tick24 ON time_accounting (ticket_id)
//
// ----------------------------------------------------------
//  create table ticket_watcher
// ----------------------------------------------------------
CREATE TABLE ticket_watcher
(
    ticket_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
//
CREATE INDEX ticket_watcher_ticke5 ON ticket_watcher (ticket_id)
//
CREATE INDEX ticket_watcher_user_28 ON ticket_watcher (user_id)
//
// ----------------------------------------------------------
//  create table service
// ----------------------------------------------------------
CREATE TABLE service
(
    id serial,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (200),
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE service_name (name)
)
//
// ----------------------------------------------------------
//  create table service_customer_user
// ----------------------------------------------------------
CREATE TABLE service_customer_user
(
    customer_user_login VARCHAR (100) NOT NULL,
    service_id INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL
)
//
CREATE INDEX service_customer_use59 ON service_customer_user (customer_user_login)
//
CREATE INDEX service_customer_use58 ON service_customer_user (service_id)
//
// ----------------------------------------------------------
//  create table sla
// ----------------------------------------------------------
CREATE TABLE sla
(
    id serial,
    name VARCHAR (200) NOT NULL,
    calendar_name VARCHAR (100),
    first_response_time INTEGER NOT NULL,
    first_response_notify SMALLINT,
    update_time INTEGER NOT NULL,
    update_notify SMALLINT,
    solution_time INTEGER NOT NULL,
    solution_notify SMALLINT,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (200),
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE sla_name (name)
)
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
//  create table sessions
// ----------------------------------------------------------
CREATE TABLE sessions
(
    session_id VARCHAR (150) NOT NULL,
    session_value LONG NOT NULL,
    PRIMARY KEY(session_id)
)
//
// ----------------------------------------------------------
//  create table ticket_index
// ----------------------------------------------------------
CREATE TABLE ticket_index
(
    ticket_id INTEGER NOT NULL,
    queue_id INTEGER NOT NULL,
    queue VARCHAR (70) NOT NULL,
    group_id INTEGER NOT NULL,
    s_lock VARCHAR (70) NOT NULL,
    s_state VARCHAR (70) NOT NULL,
    create_time_unix INTEGER NOT NULL
)
//
CREATE INDEX ticket_index_group_i63 ON ticket_index (group_id)
//
CREATE INDEX ticket_index_queue_i10 ON ticket_index (queue_id)
//
CREATE INDEX ticket_index_ticket_91 ON ticket_index (ticket_id)
//
// ----------------------------------------------------------
//  create table ticket_lock_index
// ----------------------------------------------------------
CREATE TABLE ticket_lock_index
(
    ticket_id INTEGER NOT NULL
)
//
CREATE INDEX ticket_lock_index_ti23 ON ticket_lock_index (ticket_id)
//
// ----------------------------------------------------------
//  create table customer_user
// ----------------------------------------------------------
CREATE TABLE customer_user
(
    id serial,
    login VARCHAR (100) NOT NULL,
    email VARCHAR (150) NOT NULL,
    customer_id VARCHAR (200) NOT NULL,
    pw VARCHAR (50),
    salutation VARCHAR (50),
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE customer_user_login (login)
)
//
// ----------------------------------------------------------
//  create table customer_preferences
// ----------------------------------------------------------
CREATE TABLE customer_preferences
(
    user_id VARCHAR (250) NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
)
//
CREATE INDEX customer_preferences63 ON customer_preferences (user_id)
//
// ----------------------------------------------------------
//  create table customer_company
// ----------------------------------------------------------
CREATE TABLE customer_company
(
    customer_id VARCHAR (100) NOT NULL,
    name VARCHAR (100) NOT NULL,
    street VARCHAR (200),
    zip VARCHAR (200),
    city VARCHAR (200),
    country VARCHAR (200),
    url VARCHAR (200),
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(customer_id),
    UNIQUE customer_company_name (name)
)
//
// ----------------------------------------------------------
//  create table ticket_loop_protection
// ----------------------------------------------------------
CREATE TABLE ticket_loop_protection
(
    sent_to VARCHAR (250) NOT NULL,
    sent_date VARCHAR (150) NOT NULL
)
//
CREATE INDEX ticket_loop_protecti26 ON ticket_loop_protection (sent_date)
//
CREATE INDEX ticket_loop_protecti14 ON ticket_loop_protection (sent_to)
//
// ----------------------------------------------------------
//  create table mail_account
// ----------------------------------------------------------
CREATE TABLE mail_account
(
    id serial,
    login VARCHAR (200) NOT NULL,
    pw VARCHAR (200) NOT NULL,
    host VARCHAR (200) NOT NULL,
    account_type VARCHAR (20) NOT NULL,
    queue_id INTEGER NOT NULL,
    trusted SMALLINT NOT NULL,
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
// ----------------------------------------------------------
//  create table postmaster_filter
// ----------------------------------------------------------
CREATE TABLE postmaster_filter
(
    f_name VARCHAR (200) NOT NULL,
    f_type VARCHAR (20) NOT NULL,
    f_key VARCHAR (200) NOT NULL,
    f_value VARCHAR (200) NOT NULL
)
//
CREATE INDEX postmaster_filter_f_3 ON postmaster_filter (f_name)
//
// ----------------------------------------------------------
//  create table generic_agent_jobs
// ----------------------------------------------------------
CREATE TABLE generic_agent_jobs
(
    job_name VARCHAR (200) NOT NULL,
    job_key VARCHAR (200) NOT NULL,
    job_value VARCHAR (200)
)
//
CREATE INDEX generic_agent_job_na54 ON generic_agent_jobs (job_name)
//
// ----------------------------------------------------------
//  create table search_profile
// ----------------------------------------------------------
CREATE TABLE search_profile
(
    login VARCHAR (200) NOT NULL,
    profile_name VARCHAR (200) NOT NULL,
    profile_type VARCHAR (30) NOT NULL,
    profile_key VARCHAR (200) NOT NULL,
    profile_value VARCHAR (200)
)
//
CREATE INDEX search_profile_login45 ON search_profile (login)
//
CREATE INDEX search_profile_profi82 ON search_profile (profile_name)
//
// ----------------------------------------------------------
//  create table process_id
// ----------------------------------------------------------
CREATE TABLE process_id
(
    process_name VARCHAR (200) NOT NULL,
    process_id VARCHAR (200) NOT NULL,
    process_host VARCHAR (200) NOT NULL,
    process_create INTEGER NOT NULL
)
//
// ----------------------------------------------------------
//  create table web_upload_cache
// ----------------------------------------------------------
CREATE TABLE web_upload_cache
(
    form_id VARCHAR (250),
    filename VARCHAR (250),
    content_size VARCHAR (30),
    content_type VARCHAR (250),
    content LONG NOT NULL,
    create_time_unix INTEGER NOT NULL
)
//
// ----------------------------------------------------------
//  create table notifications
// ----------------------------------------------------------
CREATE TABLE notifications
(
    id serial,
    notification_type VARCHAR (200) NOT NULL,
    notification_charset VARCHAR (60) NOT NULL,
    notification_language VARCHAR (60) NOT NULL,
    subject VARCHAR (200) NOT NULL,
    text LONG NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
// ----------------------------------------------------------
//  create table xml_storage
// ----------------------------------------------------------
CREATE TABLE xml_storage
(
    xml_type VARCHAR (200) NOT NULL,
    xml_key VARCHAR (250) NOT NULL,
    xml_content_key VARCHAR (250) NOT NULL,
    xml_content_value LONG
)
//
CREATE INDEX xml_storage_key_type64 ON xml_storage (xml_key, xml_type)
//
CREATE INDEX xml_storage_xml_cont29 ON xml_storage (xml_content_key)
//
// ----------------------------------------------------------
//  create table package_repository
// ----------------------------------------------------------
CREATE TABLE package_repository
(
    id serial,
    name VARCHAR (250) NOT NULL,
    version VARCHAR (250) NOT NULL,
    vendor VARCHAR (250) NOT NULL,
    install_status VARCHAR (250) NOT NULL,
    filename VARCHAR (250),
    content_size VARCHAR (30),
    content_type VARCHAR (250),
    content LONG NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
