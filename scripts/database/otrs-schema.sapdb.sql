// -----------------------------------------------------------------------
// valid
// -----------------------------------------------------------------------
CREATE TABLE valid
(
    id serial,
    name VARCHAR (50) NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// ticket_priority
// -----------------------------------------------------------------------
CREATE TABLE ticket_priority
(
    id serial,
    name VARCHAR (50) NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// ticket_lock_type
// -----------------------------------------------------------------------
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
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// system_user
// -----------------------------------------------------------------------
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
    UNIQUE (login)
)
// -----------------------------------------------------------------------
// user_preferences
// -----------------------------------------------------------------------
CREATE TABLE user_preferences
(
    user_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
)
//
CREATE INDEX index_user_preferences_user_id ON user_preferences (user_id)
// -----------------------------------------------------------------------
// groups
// -----------------------------------------------------------------------
CREATE TABLE groups
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// group_user
// -----------------------------------------------------------------------
CREATE TABLE group_user
(
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20),
    permission_value SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
// -----------------------------------------------------------------------
// group_customer_user
// -----------------------------------------------------------------------
CREATE TABLE group_customer_user
(
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_key VARCHAR (20),
    permission_value SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
// -----------------------------------------------------------------------
// personal_queues
// -----------------------------------------------------------------------
CREATE TABLE personal_queues
(
    user_id INTEGER NOT NULL,
    queue_id INTEGER NOT NULL
)
// -----------------------------------------------------------------------
// theme
// -----------------------------------------------------------------------
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
    UNIQUE (theme)
)
// -----------------------------------------------------------------------
// charset
// -----------------------------------------------------------------------
CREATE TABLE charset
(
    id serial,
    name VARCHAR (200) NOT NULL,
    charset VARCHAR (50) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// ticket_state
// -----------------------------------------------------------------------
CREATE TABLE ticket_state
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    type_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// ticket_state_type
// -----------------------------------------------------------------------
CREATE TABLE ticket_state_type
(
    id serial,
    name VARCHAR (120) NOT NULL,
    comment VARCHAR (250),
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// salutation
// -----------------------------------------------------------------------
CREATE TABLE salutation
(
    id serial,
    name VARCHAR (100) NOT NULL,
    text LONG NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// signature
// -----------------------------------------------------------------------
CREATE TABLE signature
(
    id serial,
    name VARCHAR (100) NOT NULL,
    text LONG NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// system_address
// -----------------------------------------------------------------------
CREATE TABLE system_address
(
    id serial,
    value0 VARCHAR (200) NOT NULL,
    value1 VARCHAR (200) NOT NULL,
    value2 VARCHAR (200),
    value3 VARCHAR (200),
    queue_id INTEGER NOT NULL,
    comment VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
// -----------------------------------------------------------------------
// follow_up_possible
// -----------------------------------------------------------------------
CREATE TABLE follow_up_possible
(
    id serial,
    name VARCHAR (200) NOT NULL,
    comment VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// queue
// -----------------------------------------------------------------------
CREATE TABLE queue
(
    id serial,
    name VARCHAR (200) NOT NULL,
    group_id INTEGER NOT NULL,
    unlock_timeout INTEGER,
    escalation_time INTEGER,
    system_address_id SMALLINT NOT NULL,
    salutation_id SMALLINT NOT NULL,
    signature_id SMALLINT NOT NULL,
    follow_up_id SMALLINT NOT NULL,
    follow_up_lock SMALLINT NOT NULL,
    move_notify SMALLINT NOT NULL,
    lock_notify SMALLINT NOT NULL,
    state_notify SMALLINT NOT NULL,
    owner_notify SMALLINT NOT NULL,
    comment VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// ticket
// -----------------------------------------------------------------------
CREATE TABLE ticket
(
    id serial,
    tn VARCHAR (50) NOT NULL,
    queue_id INTEGER NOT NULL,
    ticket_lock_id SMALLINT NOT NULL,
    ticket_answered SMALLINT NOT NULL,
    user_id INTEGER NOT NULL,
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
    valid_id SMALLINT NOT NULL,
    create_time_unix INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (tn)
)
//
CREATE INDEX index_ticket_queue_view on ticket (ticket_state_id, group_id, ticket_lock_id)
//
CREATE INDEX  index_ticket_user on ticket (user_id)
//
CREATE INDEX index_ticket_answered on ticket (ticket_answered)
// -----------------------------------------------------------------------
// ticket_history
// -----------------------------------------------------------------------
CREATE TABLE ticket_history
(
    id serial,
    name VARCHAR (200) NOT NULL,
    history_type_id SMALLINT NOT NULL,
    ticket_id INTEGER NOT NULL,
    article_id INTEGER,
    system_queue_id SMALLINT,
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX ticket_history_ticket_id on ticket_history (ticket_id)
//
CREATE INDEX ticket_history_create_time on ticket_history (create_time)
// -----------------------------------------------------------------------
// ticket_history_type
// -----------------------------------------------------------------------
CREATE TABLE ticket_history_type
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// article_type
// -----------------------------------------------------------------------
CREATE TABLE article_type
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// article_sender_type
// -----------------------------------------------------------------------
CREATE TABLE article_sender_type
(
    id serial,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// article
// -----------------------------------------------------------------------
CREATE TABLE article
(
    id serial,
    ticket_id INTEGER NOT NULL,
    article_type_id SMALLINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    a_from VARCHAR (500),
    a_reply_to VARCHAR (500),
    a_to VARCHAR (500),
    a_cc VARCHAR (500),
    a_subject VARCHAR (500),
    a_message_id VARCHAR (500),
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
CREATE INDEX article_ticket_id on article (ticket_id)
// -----------------------------------------------------------------------
// article_plain
// -----------------------------------------------------------------------
CREATE TABLE article_plain
(
    id serial,
    article_id INTEGER NOT NULL,
    body LONG,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX article_id ON article_plain (article_id)
// -----------------------------------------------------------------------
// article_attachment
// -----------------------------------------------------------------------
CREATE TABLE article_attachment
(
    id serial,
    article_id INTEGER NOT NULL,
    filename VARCHAR (250),
    content_type VARCHAR (250),
    content LONG NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX article_id ON article_attachment (article_id)
// -----------------------------------------------------------------------
// standard_response
// -----------------------------------------------------------------------
CREATE TABLE standard_response
(
    id serial,
    name VARCHAR (80) NOT NULL,
    text LONG NOT NULL,
    comment VARCHAR (80),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// queue_standard_response
// -----------------------------------------------------------------------
CREATE TABLE queue_standard_response
(
    queue_id INTEGER NOT NULL,
    standard_response_id INTEGER NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL
)
// -----------------------------------------------------------------------
// auto_response_type
// -----------------------------------------------------------------------
CREATE TABLE auto_response_type
(
    id serial,
    name VARCHAR (50) NOT NULL,
    comment VARCHAR (80),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// auto_response
// -----------------------------------------------------------------------
CREATE TABLE auto_response
(
    id serial,
    name VARCHAR (80) NOT NULL,
    text0 LONG,
    text1 LONG,
    text2 LONG,
    type_id SMALLINT NOT NULL,
    system_address_id SMALLINT NOT NULL,
    charset VARCHAR (80) NOT NULL,
    comment VARCHAR (100),
    valid_id SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// queue_auto_response
// -----------------------------------------------------------------------
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
// -----------------------------------------------------------------------
// time_accounting
// -----------------------------------------------------------------------
CREATE TABLE time_accounting
(
    id serial,
    ticket_id INTEGER NOT NULL,
    article_id INTEGER,
    time_unit SMALLINT NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
)
//
CREATE INDEX time_accounting_ticket_id ON time_accounting (ticket_id)
// -----------------------------------------------------------------------
// ticket_index 
// -----------------------------------------------------------------------
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
CREATE INDEX index_ticket_id ON ticket_index (ticket_id)
// -----------------------------------------------------------------------
// ticket_lock_index 
// -----------------------------------------------------------------------
CREATE TABLE ticket_lock_index
(
    ticket_id INTEGER NOT NULL
)
//
CREATE INDEX index_lock_ticket_id ON ticket_lock_index (ticket_id)
// -----------------------------------------------------------------------
// customer_user
// -----------------------------------------------------------------------
CREATE TABLE customer_user
(
    id serial,
    login VARCHAR (100) NOT NULL,
    email VARCHAR (150) NOT NULL,
    customer_id VARCHAR (200) NOT NULL,
    pw VARCHAR (50) NOT NULL,
    salutation VARCHAR (50),
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comment VARCHAR (250) NOT NULL,
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (login)
)
// -----------------------------------------------------------------------
// customer_preferences
// -----------------------------------------------------------------------
CREATE TABLE customer_preferences
(
    user_id VARCHAR (250) NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
)
//
CREATE INDEX index_cust_pref_user_id ON customer_preferences (user_id)
// -----------------------------------------------------------------------
// ticket_loop_protection
// -----------------------------------------------------------------------
CREATE TABLE ticket_loop_protection
(
    sent_to VARCHAR (250) NOT NULL,
    sent_date VARCHAR (150) NOT NULL
)
//
CREATE INDEX index_t_loop_protect_sent_to ON ticket_loop_protection (sent_to)
//
CREATE INDEX index_t_loop_protect_sent_date ON ticket_loop_protection (sent_date)
// -----------------------------------------------------------------------
// standard_attachment
// -----------------------------------------------------------------------
CREATE TABLE standard_attachment
(
    id serial,
    name varchar (150) NOT NULL,
    content_type varchar (150) NOT NULL,
    content LONG NOT NULL,
    filename varchar (250) NOT NULL,
    comment varchar (150),
    valid_id smallint NOT NULL,
    create_time timestamp NOT NULL, 
    create_by integer NOT NULL,
    change_time timestamp NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
// -----------------------------------------------------------------------
// standard_response_attachment 
// -----------------------------------------------------------------------
CREATE TABLE standard_response_attachment
(   
    id serial,
    standard_attachment_id integer NOT NULL,
    standard_response_id integer NOT NULL,
    create_time timestamp NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
)
// -----------------------------------------------------------------------
// pop3_account
// -----------------------------------------------------------------------
CREATE TABLE pop3_account
(
    id serial,
    login varchar (200) NOT NULL,
    pw varchar (200) NOT NULL,
    host varchar (200) NOT NULL,
    queue_id integer NOT NULL,
    trusted smallint NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
)
