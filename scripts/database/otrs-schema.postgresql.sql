
-----------------------------------------------------------------------------
-- valid
-----------------------------------------------------------------------------
CREATE TABLE valid
(
    id serial,
    name varchar (50) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- ticket_priority
-----------------------------------------------------------------------------
CREATE TABLE ticket_priority
(
    id serial,
    name varchar (50) NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- ticket_lock_type
-----------------------------------------------------------------------------
CREATE TABLE ticket_lock_type
(
    id serial,
    name varchar (50) NOT NULL,
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- system_user
-----------------------------------------------------------------------------
CREATE TABLE system_user
(
    id serial,
    login varchar (100) NOT NULL,
    pw varchar (500) NOT NULL,
    salutation varchar (50),
    first_name varchar (100) NOT NULL,
    last_name varchar (100) NOT NULL,
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (login)
);

-----------------------------------------------------------------------------
-- user_preferences
-----------------------------------------------------------------------------
CREATE TABLE user_preferences
(
    user_id integer NOT NULL,
    preferences_key varchar (150) NOT NULL,
    preferences_value varchar (250)
);
create  INDEX index_user_id ON user_preferences (user_id);

-----------------------------------------------------------------------------
-- groups
-----------------------------------------------------------------------------
CREATE TABLE groups
(
    id serial,
    name varchar (100) NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- group_user
-----------------------------------------------------------------------------
CREATE TABLE group_user
(
    user_id integer NOT NULL,
    group_id integer NOT NULL,
    permission_key VARCHAR (20),
    permission_value SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL
);

-----------------------------------------------------------------------------
-- group_customer_user
-----------------------------------------------------------------------------
CREATE TABLE group_customer_user
(
    user_id integer NOT NULL,
    group_id integer NOT NULL,
    permission_key VARCHAR (20),
    permission_value SMALLINT NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL
);

-----------------------------------------------------------------------------
-- personal_queues
-----------------------------------------------------------------------------
CREATE TABLE personal_queues
(
    user_id integer NOT NULL,
    queue_id integer NOT NULL
);

-----------------------------------------------------------------------------
-- theme
-----------------------------------------------------------------------------
CREATE TABLE theme
(
    id serial,
    theme varchar (100) NOT NULL,
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (theme)
);

-----------------------------------------------------------------------------
-- charset
-----------------------------------------------------------------------------
CREATE TABLE charset
(
    id serial,
    name varchar (200) NOT NULL,
    charset varchar (50) NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- ticket_state
-----------------------------------------------------------------------------
CREATE TABLE ticket_state
(
    id serial,
    name varchar (100) NOT NULL,
    comment varchar (250),
    type_id smallint NOT NULL,
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- ticket_state_type
-----------------------------------------------------------------------------
CREATE TABLE ticket_state_type
(
    id serial,
    name VARCHAR (120) NOT NULL,
    comment VARCHAR (250),
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- salutation
-----------------------------------------------------------------------------
CREATE TABLE salutation
(
    id serial,
    name varchar (100) NOT NULL,
    text varchar NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- signature
-----------------------------------------------------------------------------
CREATE TABLE signature
(
    id serial,
    name varchar (100) NOT NULL,
    text varchar NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- system_address
-----------------------------------------------------------------------------
CREATE TABLE system_address
(
    id serial,
    value0 varchar (200) NOT NULL,
    value1 varchar (200) NOT NULL,
    value2 varchar (200), 
    value3 varchar (200),
    queue_id smallint NOT NULL,
    comment varchar (200),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);

-----------------------------------------------------------------------------
-- follow_up_possible
-----------------------------------------------------------------------------
CREATE TABLE follow_up_possible
(
    id serial,
    name varchar (100) NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- queue
-----------------------------------------------------------------------------
CREATE TABLE queue
(
    id serial,
    name varchar (200) NOT NULL,
    group_id smallint NOT NULL,
    unlock_timeout integer,
    escalation_time integer,
    system_address_id smallint NOT NULL,
    salutation_id smallint NOT NULL,
    signature_id smallint NOT NULL,
    follow_up_id smallint NOT NULL,
    follow_up_lock smallint NOT NULL,
    move_notify smallint NOT NULL,
    lock_notify smallint NOT NULL,
    state_notify smallint NOT NULL,
    owner_notify smallint NOT NULL,
    comment varchar (200),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- ticket
-----------------------------------------------------------------------------
CREATE TABLE ticket
(
    id serial,
    tn varchar (50) NOT NULL,
    queue_id integer NOT NULL,
    ticket_lock_id smallint NOT NULL,
    ticket_answered smallint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL,
    ticket_priority_id smallint NOT NULL,
    ticket_state_id smallint NOT NULL,
    group_read smallint,
    group_write smallint,
    other_read smallint,
    other_write smallint,
    customer_id varchar (150),
    customer_user_id varchar (250),
    timeout integer,
    until_time integer,
    freekey1 varchar (80),
    freetext1 varchar (150),
    freekey2 varchar (80),
    freetext2 varchar (150),
    freekey3 varchar (80),
    freetext3 varchar (150),
    freekey4 varchar (80),
    freetext4 varchar (150),
    freekey5 varchar (80),
    freetext5 varchar (150),
    freekey6 varchar (80),
    freetext6 varchar (150),
    freekey7 varchar (80),
    freetext7 varchar (150),
    freekey8 varchar (80),
    freetext8 varchar (150),
    valid_id smallint NOT NULL,
    create_time_unix integer NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (tn)
);
create  INDEX index_ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id, group_id);
create  INDEX index_ticket_user ON ticket (user_id);
create  INDEX index_ticket_answered ON ticket (ticket_answered);

-----------------------------------------------------------------------------
-- ticket_history
-----------------------------------------------------------------------------
CREATE TABLE ticket_history
(
    id serial,
    name varchar (200) NOT NULL,
    history_type_id smallint NOT NULL,
    ticket_id bigint NOT NULL,
    article_id bigint,
    system_queue_id smallint,
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);
create  INDEX ticket_history_ticket_id ON ticket_history (ticket_id);
create  INDEX ticket_history_create_time ON ticket_history (create_time);

-----------------------------------------------------------------------------
-- ticket_history_type
-----------------------------------------------------------------------------
CREATE TABLE ticket_history_type
(
    id serial,
    name varchar (100) NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- article_type
-----------------------------------------------------------------------------
CREATE TABLE article_type
(
    id serial,
    name varchar (100) NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- article_sender_type
-----------------------------------------------------------------------------
CREATE TABLE article_sender_type
(
    id serial,
    name varchar (100) NOT NULL,
    comment varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- article
-----------------------------------------------------------------------------
CREATE TABLE article
(
    id serial8,
    ticket_id bigint NOT NULL,
    article_type_id smallint NOT NULL,
    article_sender_type_id smallint NOT NULL,
    a_from varchar,
    a_reply_to varchar (255),
    a_to varchar,
    a_cc varchar,
    a_subject varchar,
    a_message_id varchar (250),
    a_content_type varchar (250),
    a_body varchar NOT NULL,
    incoming_time integer NOT NULL,
    content_path varchar (250),
    a_freekey1 varchar (250),
    a_freetext1 varchar (250),
    a_freekey2 varchar (250),
    a_freetext2 varchar (250),
    a_freekey3 varchar (250),
    a_freetext3 varchar (250),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);
create INDEX article_ticket_id ON article (ticket_id);

-----------------------------------------------------------------------------
-- article_attachment
-----------------------------------------------------------------------------
CREATE TABLE article_attachment
(
    id serial,
    article_id BIGINT NOT NULL,
    filename VARCHAR (250),
    content_type VARCHAR (250),
    content text,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);
create INDEX index_article_attachment_article_id ON article_attachment (article_id);

-----------------------------------------------------------------------------
-- article_plain
-----------------------------------------------------------------------------
CREATE TABLE article_plain
(
    id serial,
    article_id BIGINT NOT NULL,
    body text,
    create_time timestamp(0) NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)

);
create INDEX index_article_plain_article_id ON article_plain (article_id);


-----------------------------------------------------------------------------
-- standard_response
-----------------------------------------------------------------------------
CREATE TABLE standard_response
(
    id serial,
    name varchar (80) NOT NULL,
    text varchar NOT NULL,
    comment varchar (80),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- queue_standard_response
-----------------------------------------------------------------------------
CREATE TABLE queue_standard_response
(
    queue_id integer NOT NULL,
    standard_response_id integer NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL
);

-----------------------------------------------------------------------------
-- standard_attachment
-----------------------------------------------------------------------------
CREATE TABLE standard_attachment
(
    id serial,
    name varchar (150) NOT NULL,
    content_type varchar (150) NOT NULL,
    content varchar NOT NULL,
    filename varchar (250) NOT NULL,
    comment varchar (150),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- standard_response_attachment
-----------------------------------------------------------------------------
CREATE TABLE standard_response_attachment 
(
    id serial,
    standard_attachment_id integer NOT NULL,
    standard_response_id integer NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);

-----------------------------------------------------------------------------
-- auto_response_type
-----------------------------------------------------------------------------
CREATE TABLE auto_response_type
(
    id serial,
    name varchar (50) NOT NULL,
    comment varchar (80),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- auto_response
-----------------------------------------------------------------------------
CREATE TABLE auto_response
(
    id serial,
    name varchar (80) NOT NULL,
    text0 varchar,
    text1 varchar,
    text2 varchar,
    type_id smallint NOT NULL,
    system_address_id smallint NOT NULL,
    charset_id smallint NOT NULL,
    comment varchar (100),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- queue_auto_response
-----------------------------------------------------------------------------
CREATE TABLE queue_auto_response
(
    id serial,
    queue_id integer NOT NULL,
    auto_response_id integer NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);

-----------------------------------------------------------------------------
-- time_accounting
-----------------------------------------------------------------------------
CREATE TABLE time_accounting
(
    id serial8,
    ticket_id bigint NOT NULL,
    article_id bigint,
    time_unit smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);
create  INDEX time_accounting_ticket_id ON time_accounting (ticket_id);

-----------------------------------------------------------------------------
-- faq
-----------------------------------------------------------------------------
CREATE TABLE faq
(
    id serial,
    name varchar (200) NOT NULL,
    text varchar (255) NOT NULL,
    language_id smallint NOT NULL,
    comment varchar (80),
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

-----------------------------------------------------------------------------
-- session
-----------------------------------------------------------------------------
CREATE TABLE session
(
    session_id varchar (120) NOT NULL,
    value varchar NOT NULL,
    UNIQUE (session_id)
);
create  INDEX index_session_id ON session (session_id);

-----------------------------------------------------------------------------
-- ticket_index
-----------------------------------------------------------------------------
CREATE TABLE ticket_index
(
    ticket_id bigint NOT NULL,
    queue_id integer NOT NULL,
    queue varchar (70) NOT NULL,
    group_id integer NOT NULL,
    s_lock varchar (70) NOT NULL,
    s_state varchar (70) NOT NULL,
    create_time_unix bigint NOT NULL
);
create  INDEX index_ticket_id ON ticket_index (ticket_id);

-----------------------------------------------------------------------------
-- ticket_lock_index
-----------------------------------------------------------------------------
CREATE TABLE ticket_lock_index
(
    ticket_id bigint NOT NULL
);
create  INDEX index_lock_ticket_id ON ticket_lock_index (ticket_id);

-----------------------------------------------------------------------------
-- customer_user
-----------------------------------------------------------------------------
CREATE TABLE customer_user
(
    id serial,
    login varchar (100) NOT NULL,
    email varchar (150) NOT NULL,
    customer_id VARCHAR (200) NOT NULL,
    pw varchar (50) NOT NULL,
    salutation varchar (50),
    first_name varchar (100) NOT NULL,
    last_name varchar (100) NOT NULL,
    comment varchar (250) NOT NULL,
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (login)
);

-----------------------------------------------------------------------------
-- customer_preferences
-----------------------------------------------------------------------------
CREATE TABLE customer_preferences
(
    user_id varchar (250) NOT NULL,
    preferences_key varchar (150) NOT NULL,
    preferences_value varchar (250)
);
create INDEX index_cuser_id ON customer_preferences (user_id);

-----------------------------------------------------------------------------
-- ticket_loop_protection
-----------------------------------------------------------------------------
CREATE TABLE ticket_loop_protection
(
    sent_to VARCHAR (250) NOT NULL,
    sent_date VARCHAR (150) NOT NULL
);
CREATE INDEX index_ticket_loop_protection_to ON ticket_loop_protection (sent_to);
CREATE INDEX index_ticket_loop_protection_da ON ticket_loop_protection (sent_date);

-----------------------------------------------------------------------------
-- pop3_account
-----------------------------------------------------------------------------
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
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);

-----------------------------------------------------------------------------
-- search_profile
-----------------------------------------------------------------------------
CREATE TABLE search_profile
(
    login varchar (200) NOT NULL,
    profile_name varchar (200) NOT NULL,
    profile_key varchar (200) NOT NULL,
    profile_value varchar (200) NOT NULL
);

----------------------------------------------------------------------------
-- session
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- valid
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- ticket_priority
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- ticket_lock_type
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- system_user
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- user_preferences
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- groups
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- group_user
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- personal_queues
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- theme
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- charset
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- ticket_state
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- salutation
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- signature
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- system_address
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- follow_up_possible
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- queue
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- ticket
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- ticket_history
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- ticket_history_type
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- article_type
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- article_sender_type
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- article
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- standard_response
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- queue_standard_response
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- auto_response_type
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- auto_response
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- queue_auto_response
----------------------------------------------------------------------------

----------------------------------------------------------------------------
-- faq
----------------------------------------------------------------------------

