-- ----------------------------------------------------------
--  driver: ingres, generated: 2009-12-09 12:33:59
-- ----------------------------------------------------------
CREATE SEQUENCE valid_747;\g
-- ----------------------------------------------------------
--  create table valid
-- ----------------------------------------------------------
CREATE TABLE valid (
    id SMALLINT NOT NULL DEFAULT valid_747.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY valid TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE valid ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE ticket_priority_938;\g
-- ----------------------------------------------------------
--  create table ticket_priority
-- ----------------------------------------------------------
CREATE TABLE ticket_priority (
    id SMALLINT NOT NULL DEFAULT ticket_priority_938.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY ticket_priority TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE ticket_priority ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE ticket_type_984;\g
-- ----------------------------------------------------------
--  create table ticket_type
-- ----------------------------------------------------------
CREATE TABLE ticket_type (
    id SMALLINT NOT NULL DEFAULT ticket_type_984.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY ticket_type TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE ticket_type ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE ticket_lock_type_362;\g
-- ----------------------------------------------------------
--  create table ticket_lock_type
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_type (
    id SMALLINT NOT NULL DEFAULT ticket_lock_type_362.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY ticket_lock_type TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE ticket_lock_type ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE users_142;\g
-- ----------------------------------------------------------
--  create table users
-- ----------------------------------------------------------
CREATE TABLE users (
    id INTEGER NOT NULL DEFAULT users_142.NEXTVAL,
    login VARCHAR(200) NOT NULL,
    pw VARCHAR(50) NOT NULL,
    title VARCHAR(50),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (login)
);\g
MODIFY users TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE users ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table user_preferences
-- ----------------------------------------------------------
CREATE TABLE user_preferences (
    user_id INTEGER NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY user_preferences TO btree;\g
CREATE INDEX user_preferences_user_id ON user_preferences (user_id);\g
CREATE SEQUENCE groups_151;\g
-- ----------------------------------------------------------
--  create table groups
-- ----------------------------------------------------------
CREATE TABLE groups (
    id INTEGER NOT NULL DEFAULT groups_151.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY groups TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE groups ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table group_user
-- ----------------------------------------------------------
CREATE TABLE group_user (
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR(20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY group_user TO btree;\g
CREATE INDEX group_user_group_id ON group_user (group_id);\g
CREATE INDEX group_user_user_id ON group_user (user_id);\g
-- ----------------------------------------------------------
--  create table group_role
-- ----------------------------------------------------------
CREATE TABLE group_role (
    role_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR(20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY group_role TO btree;\g
CREATE INDEX group_role_role_id ON group_role (role_id);\g
CREATE INDEX group_role_group_id ON group_role (group_id);\g
-- ----------------------------------------------------------
--  create table group_customer_user
-- ----------------------------------------------------------
CREATE TABLE group_customer_user (
    user_id VARCHAR(100) NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR(20) NOT NULL,
    permission_value SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY group_customer_user TO btree;\g
CREATE INDEX group_customer_user_group_id ON group_customer_user (group_id);\g
CREATE INDEX group_customer_user_user_id ON group_customer_user (user_id);\g
CREATE SEQUENCE roles_940;\g
-- ----------------------------------------------------------
--  create table roles
-- ----------------------------------------------------------
CREATE TABLE roles (
    id INTEGER NOT NULL DEFAULT roles_940.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY roles TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE roles ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table role_user
-- ----------------------------------------------------------
CREATE TABLE role_user (
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY role_user TO btree;\g
CREATE INDEX role_user_role_id ON role_user (role_id);\g
CREATE INDEX role_user_user_id ON role_user (user_id);\g
-- ----------------------------------------------------------
--  create table personal_queues
-- ----------------------------------------------------------
CREATE TABLE personal_queues (
    user_id INTEGER NOT NULL,
    queue_id INTEGER NOT NULL
);\g
MODIFY personal_queues TO btree;\g
CREATE INDEX personal_queues_queue_id ON personal_queues (queue_id);\g
CREATE INDEX personal_queues_user_id ON personal_queues (user_id);\g
CREATE SEQUENCE theme_248;\g
-- ----------------------------------------------------------
--  create table theme
-- ----------------------------------------------------------
CREATE TABLE theme (
    id SMALLINT NOT NULL DEFAULT theme_248.NEXTVAL,
    theme VARCHAR(100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (theme)
);\g
MODIFY theme TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE theme ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE ticket_state_276;\g
-- ----------------------------------------------------------
--  create table ticket_state
-- ----------------------------------------------------------
CREATE TABLE ticket_state (
    id SMALLINT NOT NULL DEFAULT ticket_state_276.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    type_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY ticket_state TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE ticket_state ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE ticket_state_type_143;\g
-- ----------------------------------------------------------
--  create table ticket_state_type
-- ----------------------------------------------------------
CREATE TABLE ticket_state_type (
    id SMALLINT NOT NULL DEFAULT ticket_state_type_143.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY ticket_state_type TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE ticket_state_type ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE salutation_558;\g
-- ----------------------------------------------------------
--  create table salutation
-- ----------------------------------------------------------
CREATE TABLE salutation (
    id SMALLINT NOT NULL DEFAULT salutation_558.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    text VARCHAR(3000) NOT NULL,
    content_type VARCHAR(250),
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY salutation TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE salutation ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE signature_10;\g
-- ----------------------------------------------------------
--  create table signature
-- ----------------------------------------------------------
CREATE TABLE signature (
    id SMALLINT NOT NULL DEFAULT signature_10.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    text VARCHAR(3000) NOT NULL,
    content_type VARCHAR(250),
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY signature TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE signature ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE system_address_600;\g
-- ----------------------------------------------------------
--  create table system_address
-- ----------------------------------------------------------
CREATE TABLE system_address (
    id SMALLINT NOT NULL DEFAULT system_address_600.NEXTVAL,
    value0 VARCHAR(200) NOT NULL,
    value1 VARCHAR(200) NOT NULL,
    value2 VARCHAR(200),
    value3 VARCHAR(200),
    queue_id INTEGER NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY system_address TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE system_address ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE follow_up_possible_394;\g
-- ----------------------------------------------------------
--  create table follow_up_possible
-- ----------------------------------------------------------
CREATE TABLE follow_up_possible (
    id SMALLINT NOT NULL DEFAULT follow_up_possible_394.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY follow_up_possible TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE follow_up_possible ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE queue_327;\g
-- ----------------------------------------------------------
--  create table queue
-- ----------------------------------------------------------
CREATE TABLE queue (
    id INTEGER NOT NULL DEFAULT queue_327.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    group_id INTEGER NOT NULL,
    unlock_timeout INTEGER,
    first_response_time INTEGER,
    first_response_notify SMALLINT,
    update_time INTEGER,
    update_notify SMALLINT,
    solution_time INTEGER,
    solution_notify SMALLINT,
    system_address_id SMALLINT NOT NULL,
    calendar_name VARCHAR(100),
    default_sign_key VARCHAR(100),
    salutation_id SMALLINT NOT NULL,
    signature_id SMALLINT NOT NULL,
    follow_up_id SMALLINT NOT NULL,
    follow_up_lock SMALLINT NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY queue TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE queue ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX queue_group_id ON queue (group_id);\g
-- ----------------------------------------------------------
--  create table queue_preferences
-- ----------------------------------------------------------
CREATE TABLE queue_preferences (
    queue_id INTEGER NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY queue_preferences TO btree;\g
CREATE INDEX queue_preferences_queue_id ON queue_preferences (queue_id);\g
CREATE SEQUENCE ticket_222;\g
-- ----------------------------------------------------------
--  create table ticket
-- ----------------------------------------------------------
CREATE TABLE ticket (
    id BIGINT NOT NULL DEFAULT ticket_222.NEXTVAL,
    tn VARCHAR(50) NOT NULL,
    title VARCHAR(255),
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
    customer_id VARCHAR(150),
    customer_user_id VARCHAR(250),
    timeout INTEGER NOT NULL,
    until_time INTEGER NOT NULL,
    escalation_time INTEGER NOT NULL,
    escalation_update_time INTEGER NOT NULL,
    escalation_response_time INTEGER NOT NULL,
    escalation_solution_time INTEGER NOT NULL,
    freekey1 VARCHAR(80),
    freetext1 VARCHAR(150),
    freekey2 VARCHAR(80),
    freetext2 VARCHAR(150),
    freekey3 VARCHAR(80),
    freetext3 VARCHAR(150),
    freekey4 VARCHAR(80),
    freetext4 VARCHAR(150),
    freekey5 VARCHAR(80),
    freetext5 VARCHAR(150),
    freekey6 VARCHAR(80),
    freetext6 VARCHAR(150),
    freekey7 VARCHAR(80),
    freetext7 VARCHAR(150),
    freekey8 VARCHAR(80),
    freetext8 VARCHAR(150),
    freekey9 VARCHAR(80),
    freetext9 VARCHAR(150),
    freekey10 VARCHAR(80),
    freetext10 VARCHAR(150),
    freekey11 VARCHAR(80),
    freetext11 VARCHAR(150),
    freekey12 VARCHAR(80),
    freetext12 VARCHAR(150),
    freekey13 VARCHAR(80),
    freetext13 VARCHAR(150),
    freekey14 VARCHAR(80),
    freetext14 VARCHAR(150),
    freekey15 VARCHAR(80),
    freetext15 VARCHAR(150),
    freekey16 VARCHAR(80),
    freetext16 VARCHAR(150),
    freetime1 TIMESTAMP,
    freetime2 TIMESTAMP,
    freetime3 TIMESTAMP,
    freetime4 TIMESTAMP,
    freetime5 TIMESTAMP,
    freetime6 TIMESTAMP,
    valid_id SMALLINT NOT NULL,
    archive_flag SMALLINT NOT NULL,
    create_time_unix BIGINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (tn)
);\g
MODIFY ticket TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE ticket ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX ticket_ticket_state_id ON ticket (ticket_state_id);\g
CREATE INDEX ticket_user_id ON ticket (user_id);\g
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);\g
CREATE INDEX ticket_type_id ON ticket (type_id);\g
CREATE INDEX ticket_timeout ON ticket (timeout);\g
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id, group_id);\g
CREATE INDEX ticket_responsible_user_id ON ticket (responsible_user_id);\g
CREATE INDEX ticket_ticket_lock_id ON ticket (ticket_lock_id);\g
CREATE INDEX ticket_title ON ticket (title);\g
CREATE INDEX ticket_ticket_priority_id ON ticket (ticket_priority_id);\g
CREATE INDEX ticket_until_time ON ticket (until_time);\g
CREATE INDEX ticket_customer_id ON ticket (customer_id);\g
CREATE INDEX ticket_answered ON ticket (ticket_answered);\g
CREATE INDEX ticket_escalation_solution_time ON ticket (escalation_solution_time);\g
CREATE INDEX ticket_escalation_update_time ON ticket (escalation_update_time);\g
CREATE INDEX ticket_archive_flag ON ticket (archive_flag);\g
CREATE INDEX ticket_create_time ON ticket (create_time);\g
CREATE INDEX ticket_escalation_response_time ON ticket (escalation_response_time);\g
CREATE INDEX ticket_customer_user_id ON ticket (customer_user_id);\g
CREATE INDEX ticket_escalation_time ON ticket (escalation_time);\g
CREATE INDEX ticket_queue_id ON ticket (queue_id);\g
CREATE SEQUENCE link_type_279;\g
-- ----------------------------------------------------------
--  create table link_type
-- ----------------------------------------------------------
CREATE TABLE link_type (
    id SMALLINT NOT NULL DEFAULT link_type_279.NEXTVAL,
    name VARCHAR(50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY link_type TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE link_type ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE link_state_577;\g
-- ----------------------------------------------------------
--  create table link_state
-- ----------------------------------------------------------
CREATE TABLE link_state (
    id SMALLINT NOT NULL DEFAULT link_state_577.NEXTVAL,
    name VARCHAR(50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY link_state TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE link_state ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE link_object_719;\g
-- ----------------------------------------------------------
--  create table link_object
-- ----------------------------------------------------------
CREATE TABLE link_object (
    id SMALLINT NOT NULL DEFAULT link_object_719.NEXTVAL,
    name VARCHAR(100) NOT NULL,
    UNIQUE (name)
);\g
MODIFY link_object TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE link_object ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table link_relation
-- ----------------------------------------------------------
CREATE TABLE link_relation (
    source_object_id SMALLINT NOT NULL,
    source_key VARCHAR(50) NOT NULL,
    target_object_id SMALLINT NOT NULL,
    target_key VARCHAR(50) NOT NULL,
    type_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    UNIQUE (source_object_id, source_key, target_object_id, target_key, type_id)
);\g
MODIFY link_relation TO btree;\g
CREATE SEQUENCE ticket_history_869;\g
-- ----------------------------------------------------------
--  create table ticket_history
-- ----------------------------------------------------------
CREATE TABLE ticket_history (
    id BIGINT NOT NULL DEFAULT ticket_history_869.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    history_type_id SMALLINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT,
    type_id SMALLINT NOT NULL,
    queue_id INTEGER NOT NULL,
    owner_id INTEGER NOT NULL,
    priority_id SMALLINT NOT NULL,
    state_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY ticket_history TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE ticket_history ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX ticket_history_history_type_id ON ticket_history (history_type_id);\g
CREATE INDEX ticket_history_ticket_id ON ticket_history (ticket_id);\g
CREATE INDEX ticket_history_priority_id ON ticket_history (priority_id);\g
CREATE INDEX ticket_history_create_time ON ticket_history (create_time);\g
CREATE INDEX ticket_history_state_id ON ticket_history (state_id);\g
CREATE INDEX ticket_history_type_id ON ticket_history (type_id);\g
CREATE INDEX ticket_history_owner_id ON ticket_history (owner_id);\g
CREATE INDEX ticket_history_queue_id ON ticket_history (queue_id);\g
CREATE SEQUENCE ticket_history_type_882;\g
-- ----------------------------------------------------------
--  create table ticket_history_type
-- ----------------------------------------------------------
CREATE TABLE ticket_history_type (
    id SMALLINT NOT NULL DEFAULT ticket_history_type_882.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY ticket_history_type TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE ticket_history_type ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE article_type_381;\g
-- ----------------------------------------------------------
--  create table article_type
-- ----------------------------------------------------------
CREATE TABLE article_type (
    id SMALLINT NOT NULL DEFAULT article_type_381.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY article_type TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE article_type ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE article_sender_type_117;\g
-- ----------------------------------------------------------
--  create table article_sender_type
-- ----------------------------------------------------------
CREATE TABLE article_sender_type (
    id SMALLINT NOT NULL DEFAULT article_sender_type_117.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY article_sender_type TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE article_sender_type ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table article_flag
-- ----------------------------------------------------------
CREATE TABLE article_flag (
    article_id BIGINT NOT NULL,
    article_flag VARCHAR(50) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL
);\g
MODIFY article_flag TO btree;\g
CREATE INDEX article_flag_create_by ON article_flag (create_by);\g
CREATE INDEX article_flag_article_id ON article_flag (article_id);\g
CREATE SEQUENCE article_104;\g
-- ----------------------------------------------------------
--  create table article
-- ----------------------------------------------------------
CREATE TABLE article (
    id BIGINT NOT NULL DEFAULT article_104.NEXTVAL,
    ticket_id BIGINT NOT NULL,
    article_type_id SMALLINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    a_from VARCHAR(3800),
    a_reply_to VARCHAR(500),
    a_to VARCHAR(3800),
    a_cc VARCHAR(3800),
    a_subject VARCHAR(3800),
    a_message_id VARCHAR(3800),
    a_in_reply_to VARCHAR(3800),
    a_references VARCHAR(3800),
    a_content_type VARCHAR(250),
    a_body LONG VARCHAR NOT NULL,
    incoming_time INTEGER NOT NULL,
    content_path VARCHAR(250),
    a_freekey1 VARCHAR(250),
    a_freetext1 VARCHAR(250),
    a_freekey2 VARCHAR(250),
    a_freetext2 VARCHAR(250),
    a_freekey3 VARCHAR(250),
    a_freetext3 VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY article TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE article ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX article_article_sender_type_id ON article (article_sender_type_id);\g
CREATE INDEX article_message_id ON article (a_message_id);\g
CREATE INDEX article_article_type_id ON article (article_type_id);\g
CREATE INDEX article_ticket_id ON article (ticket_id);\g
-- ----------------------------------------------------------
--  create table article_search
-- ----------------------------------------------------------
CREATE TABLE article_search (
    id BIGINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_type_id SMALLINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    a_from VARCHAR(3800),
    a_to VARCHAR(3800),
    a_cc VARCHAR(3800),
    a_subject VARCHAR(3800),
    a_message_id VARCHAR(3800),
    a_body LONG VARCHAR NOT NULL,
    incoming_time INTEGER NOT NULL,
    a_freekey1 VARCHAR(250),
    a_freetext1 VARCHAR(250),
    a_freekey2 VARCHAR(250),
    a_freetext2 VARCHAR(250),
    a_freekey3 VARCHAR(250),
    a_freetext3 VARCHAR(250)
);\g
MODIFY article_search TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE article_search ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX article_search_article_sender_type_id ON article_search (article_sender_type_id);\g
CREATE INDEX article_search_message_id ON article_search (a_message_id);\g
CREATE INDEX article_search_ticket_id ON article_search (ticket_id);\g
CREATE INDEX article_search_article_type_id ON article_search (article_type_id);\g
CREATE SEQUENCE article_plain_204;\g
-- ----------------------------------------------------------
--  create table article_plain
-- ----------------------------------------------------------
CREATE TABLE article_plain (
    id BIGINT NOT NULL DEFAULT article_plain_204.NEXTVAL,
    article_id BIGINT NOT NULL,
    body LONG BYTE NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY article_plain TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE article_plain ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX article_plain_article_id ON article_plain (article_id);\g
CREATE SEQUENCE article_attachment_813;\g
-- ----------------------------------------------------------
--  create table article_attachment
-- ----------------------------------------------------------
CREATE TABLE article_attachment (
    id BIGINT NOT NULL DEFAULT article_attachment_813.NEXTVAL,
    article_id BIGINT NOT NULL,
    filename VARCHAR(250),
    content_size VARCHAR(30),
    content_type VARCHAR(450),
    content_id VARCHAR(250),
    content_alternative VARCHAR(50),
    content LONG BYTE NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY article_attachment TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE article_attachment ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX article_attachment_article_id ON article_attachment (article_id);\g
CREATE SEQUENCE standard_response_577;\g
-- ----------------------------------------------------------
--  create table standard_response
-- ----------------------------------------------------------
CREATE TABLE standard_response (
    id INTEGER NOT NULL DEFAULT standard_response_577.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    text VARCHAR(10000),
    content_type VARCHAR(250),
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY standard_response TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE standard_response ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table queue_standard_response
-- ----------------------------------------------------------
CREATE TABLE queue_standard_response (
    queue_id INTEGER NOT NULL,
    standard_response_id INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY queue_standard_response TO btree;\g
CREATE SEQUENCE standard_attachment_95;\g
-- ----------------------------------------------------------
--  create table standard_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_attachment (
    id INTEGER NOT NULL DEFAULT standard_attachment_95.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    content_type VARCHAR(250) NOT NULL,
    content LONG BYTE NOT NULL,
    filename VARCHAR(250) NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY standard_attachment TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE standard_attachment ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE standard_response_attachment_759;\g
-- ----------------------------------------------------------
--  create table standard_response_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_response_attachment (
    id INTEGER NOT NULL DEFAULT standard_response_attachment_759.NEXTVAL,
    standard_attachment_id INTEGER NOT NULL,
    standard_response_id INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY standard_response_attachment TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE standard_response_attachment ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE auto_response_type_526;\g
-- ----------------------------------------------------------
--  create table auto_response_type
-- ----------------------------------------------------------
CREATE TABLE auto_response_type (
    id SMALLINT NOT NULL DEFAULT auto_response_type_526.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY auto_response_type TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE auto_response_type ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE auto_response_4;\g
-- ----------------------------------------------------------
--  create table auto_response
-- ----------------------------------------------------------
CREATE TABLE auto_response (
    id INTEGER NOT NULL DEFAULT auto_response_4.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    text0 VARCHAR(6000),
    text1 VARCHAR(6000),
    text2 VARCHAR(6000),
    type_id SMALLINT NOT NULL,
    system_address_id SMALLINT NOT NULL,
    charset VARCHAR(80) NOT NULL,
    content_type VARCHAR(250),
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY auto_response TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE auto_response ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE queue_auto_response_662;\g
-- ----------------------------------------------------------
--  create table queue_auto_response
-- ----------------------------------------------------------
CREATE TABLE queue_auto_response (
    id INTEGER NOT NULL DEFAULT queue_auto_response_662.NEXTVAL,
    queue_id INTEGER NOT NULL,
    auto_response_id INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY queue_auto_response TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE queue_auto_response ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE time_accounting_693;\g
-- ----------------------------------------------------------
--  create table time_accounting
-- ----------------------------------------------------------
CREATE TABLE time_accounting (
    id BIGINT NOT NULL DEFAULT time_accounting_693.NEXTVAL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT,
    time_unit DECIMAL (10,2) NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY time_accounting TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE time_accounting ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX time_accounting_ticket_id ON time_accounting (ticket_id);\g
-- ----------------------------------------------------------
--  create table ticket_watcher
-- ----------------------------------------------------------
CREATE TABLE ticket_watcher (
    ticket_id BIGINT NOT NULL,
    user_id INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY ticket_watcher TO btree;\g
CREATE INDEX ticket_watcher_user_id ON ticket_watcher (user_id);\g
CREATE INDEX ticket_watcher_ticket_id ON ticket_watcher (ticket_id);\g
CREATE SEQUENCE service_505;\g
-- ----------------------------------------------------------
--  create table service
-- ----------------------------------------------------------
CREATE TABLE service (
    id INTEGER NOT NULL DEFAULT service_505.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR(250),
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY service TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE service ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table service_preferences
-- ----------------------------------------------------------
CREATE TABLE service_preferences (
    service_id INTEGER NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY service_preferences TO btree;\g
CREATE INDEX service_preferences_service_id ON service_preferences (service_id);\g
-- ----------------------------------------------------------
--  create table service_customer_user
-- ----------------------------------------------------------
CREATE TABLE service_customer_user (
    customer_user_login VARCHAR(200) NOT NULL,
    service_id INTEGER NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL
);\g
MODIFY service_customer_user TO btree;\g
CREATE INDEX service_customer_user_customer_user_login ON service_customer_user (customer_user_login);\g
CREATE INDEX service_customer_user_service_id ON service_customer_user (service_id);\g
CREATE SEQUENCE sla_781;\g
-- ----------------------------------------------------------
--  create table sla
-- ----------------------------------------------------------
CREATE TABLE sla (
    id INTEGER NOT NULL DEFAULT sla_781.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    calendar_name VARCHAR(100),
    first_response_time INTEGER NOT NULL,
    first_response_notify SMALLINT,
    update_time INTEGER NOT NULL,
    update_notify SMALLINT,
    solution_time INTEGER NOT NULL,
    solution_notify SMALLINT,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR(250),
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY sla TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE sla ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table sla_preferences
-- ----------------------------------------------------------
CREATE TABLE sla_preferences (
    sla_id INTEGER NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY sla_preferences TO btree;\g
CREATE INDEX sla_preferences_sla_id ON sla_preferences (sla_id);\g
-- ----------------------------------------------------------
--  create table service_sla
-- ----------------------------------------------------------
CREATE TABLE service_sla (
    service_id INTEGER NOT NULL,
    sla_id INTEGER NOT NULL,
    UNIQUE (service_id, sla_id)
);\g
MODIFY service_sla TO btree;\g
-- ----------------------------------------------------------
--  create table sessions
-- ----------------------------------------------------------
CREATE TABLE sessions (
    session_id VARCHAR(150) NOT NULL,
    session_value VARCHAR(25000) NOT NULL
);\g
MODIFY sessions TO btree unique ON session_id WITH unique_scope = statement;\g
ALTER TABLE sessions ADD PRIMARY KEY ( session_id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table ticket_index
-- ----------------------------------------------------------
CREATE TABLE ticket_index (
    ticket_id BIGINT NOT NULL,
    queue_id INTEGER NOT NULL,
    queue VARCHAR(70) NOT NULL,
    group_id INTEGER NOT NULL,
    s_lock VARCHAR(70) NOT NULL,
    s_state VARCHAR(70) NOT NULL,
    create_time_unix BIGINT NOT NULL
);\g
MODIFY ticket_index TO btree;\g
CREATE INDEX ticket_index_queue_id ON ticket_index (queue_id);\g
CREATE INDEX ticket_index_group_id ON ticket_index (group_id);\g
CREATE INDEX ticket_index_ticket_id ON ticket_index (ticket_id);\g
-- ----------------------------------------------------------
--  create table ticket_lock_index
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_index (
    ticket_id BIGINT NOT NULL
);\g
MODIFY ticket_lock_index TO btree;\g
CREATE INDEX ticket_lock_index_ticket_id ON ticket_lock_index (ticket_id);\g
CREATE SEQUENCE customer_user_654;\g
-- ----------------------------------------------------------
--  create table customer_user
-- ----------------------------------------------------------
CREATE TABLE customer_user (
    id INTEGER NOT NULL DEFAULT customer_user_654.NEXTVAL,
    login VARCHAR(200) NOT NULL,
    email VARCHAR(150) NOT NULL,
    customer_id VARCHAR(150) NOT NULL,
    pw VARCHAR(50),
    title VARCHAR(50),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(150),
    fax VARCHAR(150),
    mobile VARCHAR(150),
    street VARCHAR(150),
    zip VARCHAR(200),
    city VARCHAR(200),
    country VARCHAR(200),
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (login)
);\g
MODIFY customer_user TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE customer_user ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table customer_preferences
-- ----------------------------------------------------------
CREATE TABLE customer_preferences (
    user_id VARCHAR(250) NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY customer_preferences TO btree;\g
CREATE INDEX customer_preferences_user_id ON customer_preferences (user_id);\g
-- ----------------------------------------------------------
--  create table customer_company
-- ----------------------------------------------------------
CREATE TABLE customer_company (
    customer_id VARCHAR(150) NOT NULL,
    name VARCHAR(200) NOT NULL,
    street VARCHAR(200),
    zip VARCHAR(200),
    city VARCHAR(200),
    country VARCHAR(200),
    url VARCHAR(200),
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY customer_company TO btree unique ON customer_id WITH unique_scope = statement;\g
ALTER TABLE customer_company ADD PRIMARY KEY ( customer_id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table ticket_loop_protection
-- ----------------------------------------------------------
CREATE TABLE ticket_loop_protection (
    sent_to VARCHAR(250) NOT NULL,
    sent_date VARCHAR(150) NOT NULL
);\g
MODIFY ticket_loop_protection TO btree;\g
CREATE INDEX ticket_loop_protection_sent_date ON ticket_loop_protection (sent_date);\g
CREATE INDEX ticket_loop_protection_sent_to ON ticket_loop_protection (sent_to);\g
CREATE SEQUENCE mail_account_57;\g
-- ----------------------------------------------------------
--  create table mail_account
-- ----------------------------------------------------------
CREATE TABLE mail_account (
    id INTEGER NOT NULL DEFAULT mail_account_57.NEXTVAL,
    login VARCHAR(200) NOT NULL,
    pw VARCHAR(200) NOT NULL,
    host VARCHAR(200) NOT NULL,
    account_type VARCHAR(20) NOT NULL,
    queue_id INTEGER NOT NULL,
    trusted SMALLINT NOT NULL,
    comments VARCHAR(250),
    valid_id SMALLINT NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY mail_account TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE mail_account ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table postmaster_filter
-- ----------------------------------------------------------
CREATE TABLE postmaster_filter (
    f_name VARCHAR(200) NOT NULL,
    f_stop SMALLINT,
    f_type VARCHAR(20) NOT NULL,
    f_key VARCHAR(200) NOT NULL,
    f_value VARCHAR(200) NOT NULL
);\g
MODIFY postmaster_filter TO btree;\g
CREATE INDEX postmaster_filter_f_name ON postmaster_filter (f_name);\g
-- ----------------------------------------------------------
--  create table generic_agent_jobs
-- ----------------------------------------------------------
CREATE TABLE generic_agent_jobs (
    job_name VARCHAR(200) NOT NULL,
    job_key VARCHAR(200) NOT NULL,
    job_value VARCHAR(200)
);\g
MODIFY generic_agent_jobs TO btree;\g
CREATE INDEX generic_agent_jobs_job_name ON generic_agent_jobs (job_name);\g
-- ----------------------------------------------------------
--  create table search_profile
-- ----------------------------------------------------------
CREATE TABLE search_profile (
    login VARCHAR(200) NOT NULL,
    profile_name VARCHAR(200) NOT NULL,
    profile_type VARCHAR(30) NOT NULL,
    profile_key VARCHAR(200) NOT NULL,
    profile_value VARCHAR(200)
);\g
MODIFY search_profile TO btree;\g
CREATE INDEX search_profile_login ON search_profile (login);\g
CREATE INDEX search_profile_profile_name ON search_profile (profile_name);\g
-- ----------------------------------------------------------
--  create table process_id
-- ----------------------------------------------------------
CREATE TABLE process_id (
    process_name VARCHAR(200) NOT NULL,
    process_id VARCHAR(200) NOT NULL,
    process_host VARCHAR(200) NOT NULL,
    process_create INTEGER NOT NULL
);\g
MODIFY process_id TO btree;\g
-- ----------------------------------------------------------
--  create table web_upload_cache
-- ----------------------------------------------------------
CREATE TABLE web_upload_cache (
    form_id VARCHAR(250),
    filename VARCHAR(250),
    content_id VARCHAR(250),
    content_size VARCHAR(30),
    content_type VARCHAR(250),
    content LONG BYTE NOT NULL,
    create_time_unix BIGINT NOT NULL
);\g
MODIFY web_upload_cache TO btree;\g
CREATE SEQUENCE notifications_737;\g
-- ----------------------------------------------------------
--  create table notifications
-- ----------------------------------------------------------
CREATE TABLE notifications (
    id INTEGER NOT NULL DEFAULT notifications_737.NEXTVAL,
    notification_type VARCHAR(200) NOT NULL,
    notification_charset VARCHAR(60) NOT NULL,
    notification_language VARCHAR(60) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    text VARCHAR(4000) NOT NULL,
    content_type VARCHAR(250),
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY notifications TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE notifications ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE SEQUENCE notification_event_218;\g
-- ----------------------------------------------------------
--  create table notification_event
-- ----------------------------------------------------------
CREATE TABLE notification_event (
    id INTEGER NOT NULL DEFAULT notification_event_218.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    text VARCHAR(4000) NOT NULL,
    content_type VARCHAR(250) NOT NULL,
    charset VARCHAR(100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR(250),
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (name)
);\g
MODIFY notification_event TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE notification_event ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
-- ----------------------------------------------------------
--  create table notification_event_item
-- ----------------------------------------------------------
CREATE TABLE notification_event_item (
    notification_id INTEGER NOT NULL,
    event_key VARCHAR(200) NOT NULL,
    event_value VARCHAR(200) NOT NULL
);\g
MODIFY notification_event_item TO btree;\g
CREATE INDEX notification_event_item_event_value ON notification_event_item (event_value);\g
CREATE INDEX notification_event_item_event_key ON notification_event_item (event_key);\g
CREATE INDEX notification_event_item_notification_id ON notification_event_item (notification_id);\g
-- ----------------------------------------------------------
--  create table xml_storage
-- ----------------------------------------------------------
CREATE TABLE xml_storage (
    xml_type VARCHAR(200) NOT NULL,
    xml_key VARCHAR(250) NOT NULL,
    xml_content_key VARCHAR(250) NOT NULL,
    xml_content_value LONG VARCHAR
);\g
MODIFY xml_storage TO btree;\g
CREATE INDEX xml_storage_xml_content_key ON xml_storage (xml_content_key);\g
CREATE INDEX xml_storage_key_type ON xml_storage (xml_key, xml_type);\g
CREATE SEQUENCE virtual_fs_732;\g
-- ----------------------------------------------------------
--  create table virtual_fs
-- ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id BIGINT NOT NULL DEFAULT virtual_fs_732.NEXTVAL,
    filename VARCHAR(350) NOT NULL,
    backend VARCHAR(60) NOT NULL,
    backend_key VARCHAR(160) NOT NULL,
    create_time TIMESTAMP NOT NULL
);\g
MODIFY virtual_fs TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE virtual_fs ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX virtual_fs_backend ON virtual_fs (backend);\g
CREATE INDEX virtual_fs_filename ON virtual_fs (filename);\g
-- ----------------------------------------------------------
--  create table virtual_fs_preferences
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id BIGINT NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(350)
);\g
MODIFY virtual_fs_preferences TO btree;\g
CREATE INDEX virtual_fs_preferences_virtual_fs_id ON virtual_fs_preferences (virtual_fs_id);\g
CREATE SEQUENCE virtual_fs_db_366;\g
-- ----------------------------------------------------------
--  create table virtual_fs_db
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id BIGINT NOT NULL DEFAULT virtual_fs_db_366.NEXTVAL,
    filename VARCHAR(350) NOT NULL,
    content LONG BYTE NOT NULL,
    create_time TIMESTAMP NOT NULL
);\g
MODIFY virtual_fs_db TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE virtual_fs_db ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);\g
CREATE SEQUENCE package_repository_884;\g
-- ----------------------------------------------------------
--  create table package_repository
-- ----------------------------------------------------------
CREATE TABLE package_repository (
    id INTEGER NOT NULL DEFAULT package_repository_884.NEXTVAL,
    name VARCHAR(200) NOT NULL,
    version VARCHAR(250) NOT NULL,
    vendor VARCHAR(250) NOT NULL,
    install_status VARCHAR(250) NOT NULL,
    filename VARCHAR(250),
    content_size VARCHAR(30),
    content_type VARCHAR(250),
    content LONG BYTE NOT NULL,
    create_time TIMESTAMP NOT NULL,
    create_by INTEGER NOT NULL,
    change_time TIMESTAMP NOT NULL,
    change_by INTEGER NOT NULL
);\g
MODIFY package_repository TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE package_repository ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
