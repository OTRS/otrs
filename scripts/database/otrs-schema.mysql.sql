
# -----------------------------------------------------------------------
# valid
# -----------------------------------------------------------------------
drop table if exists valid;

CREATE TABLE valid
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (50) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# ticket_priority
# -----------------------------------------------------------------------
drop table if exists ticket_priority;

CREATE TABLE ticket_priority
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (50) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# ticket_lock_type
# -----------------------------------------------------------------------
drop table if exists ticket_lock_type;

CREATE TABLE ticket_lock_type
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (50) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# system_user
# -----------------------------------------------------------------------
drop table if exists system_user;

CREATE TABLE system_user
(
    id INTEGER NOT NULL AUTO_INCREMENT,
    login VARCHAR (100) NOT NULL,
    pw VARCHAR (50) NOT NULL,
    salutation VARCHAR (50),
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (login)
);

# -----------------------------------------------------------------------
# user_preferences
# -----------------------------------------------------------------------
drop table if exists user_preferences;

CREATE TABLE user_preferences
(
    user_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250),
    INDEX index_user_preferences_user_id (user_id)
);

# -----------------------------------------------------------------------
# groups
# -----------------------------------------------------------------------
drop table if exists groups;

CREATE TABLE groups
(
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# group_user
# -----------------------------------------------------------------------
drop table if exists group_user;

CREATE TABLE group_user
(
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);

# -----------------------------------------------------------------------
# personal_queues
# -----------------------------------------------------------------------
drop table if exists personal_queues;

CREATE TABLE personal_queues
(
    user_id INTEGER NOT NULL,
    queue_id INTEGER NOT NULL
);

# -----------------------------------------------------------------------
# theme
# -----------------------------------------------------------------------
drop table if exists theme;

CREATE TABLE theme
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    theme VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (theme)
);

# -----------------------------------------------------------------------
# charset
# -----------------------------------------------------------------------
drop table if exists charset;

CREATE TABLE charset
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    charset VARCHAR (50) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# ticket_state
# -----------------------------------------------------------------------
drop table if exists ticket_state;

CREATE TABLE ticket_state
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# salutation
# -----------------------------------------------------------------------
drop table if exists salutation;

CREATE TABLE salutation
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    text MEDIUMTEXT NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# signature
# -----------------------------------------------------------------------
drop table if exists signature;

CREATE TABLE signature
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    text MEDIUMTEXT NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# system_address
# -----------------------------------------------------------------------
drop table if exists system_address;

CREATE TABLE system_address
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    value0 VARCHAR (200) NOT NULL,
    value1 VARCHAR (200) NOT NULL,
    value2 VARCHAR (200),
    value3 VARCHAR (200),
    queue_id INTEGER NOT NULL,
    comment VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);

# -----------------------------------------------------------------------
# follow_up_possible
# -----------------------------------------------------------------------
drop table if exists follow_up_possible;

CREATE TABLE follow_up_possible
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    comment VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# queue
# -----------------------------------------------------------------------
drop table if exists queue;

CREATE TABLE queue
(
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    group_id INTEGER NOT NULL,
    unlock_timeout INTEGER,
    escalation_time INTEGER,
    system_address_id SMALLINT NOT NULL,
    salutation_id SMALLINT NOT NULL,
    signature_id SMALLINT NOT NULL,
    follow_up_id SMALLINT NOT NULL,
    follow_up_lock SMALLINT NOT NULL,
    comment VARCHAR (200),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# ticket
# -----------------------------------------------------------------------
drop table if exists ticket;

CREATE TABLE ticket
(
    id BIGINT NOT NULL AUTO_INCREMENT,
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
    freekey1 VARCHAR (150),
    freetext1 VARCHAR (150),
    freekey2 VARCHAR (150),
    freetext2 VARCHAR (150),
    valid_id SMALLINT NOT NULL,
    create_time_unix INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (tn),
    INDEX index_ticket_queue_view (ticket_state_id, group_id, ticket_lock_id, group_id)
        ,INDEX index_ticket_user (user_id)
        ,INDEX index_ticket_answered (ticket_answered)
   
);

# -----------------------------------------------------------------------
# ticket_history
# -----------------------------------------------------------------------
drop table if exists ticket_history;

CREATE TABLE ticket_history
(
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    history_type_id SMALLINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT,
    system_queue_id SMALLINT,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX ticket_history_ticket_id (ticket_id),
    INDEX ticket_history_create_time (create_time)
);

# -----------------------------------------------------------------------
# ticket_history_type
# -----------------------------------------------------------------------
drop table if exists ticket_history_type;

CREATE TABLE ticket_history_type
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# article_type
# -----------------------------------------------------------------------
drop table if exists article_type;

CREATE TABLE article_type
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# article_sender_type
# -----------------------------------------------------------------------
drop table if exists article_sender_type;

CREATE TABLE article_sender_type
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (100) NOT NULL,
    comment VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# article
# -----------------------------------------------------------------------
drop table if exists article;

CREATE TABLE article
(
    id BIGINT NOT NULL AUTO_INCREMENT,
    ticket_id INTEGER NOT NULL,
    article_type_id SMALLINT NOT NULL,
    article_sender_type_id SMALLINT NOT NULL,
    a_from MEDIUMTEXT,
    a_reply_to VARCHAR (255),
    a_to MEDIUMTEXT,
    a_cc MEDIUMTEXT,
    a_subject MEDIUMTEXT,
    a_message_id VARCHAR (250),
    a_content_type VARCHAR (250),
    a_body MEDIUMTEXT NOT NULL,
    incoming_time INTEGER NOT NULL,
    content_path VARCHAR (250),
    a_freekey1 VARCHAR (250),
    a_freetext1 VARCHAR (250),
    a_freekey2 VARCHAR (250),
    a_freetext2 VARCHAR (250),
    a_freekey3 VARCHAR (250),
    a_freetext3 VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX article_ticket_id (ticket_id)
   
);

# -----------------------------------------------------------------------
# article_plain
# -----------------------------------------------------------------------
drop table if exists article_plain;

CREATE TABLE article_plain
(
    id BIGINT NOT NULL AUTO_INCREMENT,
    article_id BIGINT NOT NULL,
    body MEDIUMTEXT,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX article_id (article_id)
   
);

# -----------------------------------------------------------------------
# article_attachment
# -----------------------------------------------------------------------
drop table if exists article_attachment;

CREATE TABLE article_attachment
(
    id BIGINT NOT NULL AUTO_INCREMENT,
    article_id BIGINT NOT NULL,
    filename VARCHAR (250),
    content_type VARCHAR (250),
    content LONGBLOB,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX article_id (article_id)
   
);

# -----------------------------------------------------------------------
# standard_response
# -----------------------------------------------------------------------
drop table if exists standard_response;

CREATE TABLE standard_response
(
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (80) NOT NULL,
    text MEDIUMTEXT NOT NULL,
    comment VARCHAR (80),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# queue_standard_response
# -----------------------------------------------------------------------
drop table if exists queue_standard_response;

CREATE TABLE queue_standard_response
(
    queue_id INTEGER NOT NULL,
    standard_response_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
);

# -----------------------------------------------------------------------
# auto_response_type
# -----------------------------------------------------------------------
drop table if exists auto_response_type;

CREATE TABLE auto_response_type
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (50) NOT NULL,
    comment VARCHAR (80),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# auto_response
# -----------------------------------------------------------------------
drop table if exists auto_response;

CREATE TABLE auto_response
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (80) NOT NULL,
    text0 MEDIUMTEXT,
    text1 MEDIUMTEXT,
    text2 MEDIUMTEXT,
    type_id SMALLINT NOT NULL,
    system_address_id SMALLINT NOT NULL,
    charset_id SMALLINT NOT NULL,
    comment VARCHAR (100),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# queue_auto_response
# -----------------------------------------------------------------------
drop table if exists queue_auto_response;

CREATE TABLE queue_auto_response
(
    id INTEGER NOT NULL AUTO_INCREMENT,
    queue_id INTEGER NOT NULL,
    auto_response_id INTEGER NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id)
);

# -----------------------------------------------------------------------
# time_accounting
# -----------------------------------------------------------------------
drop table if exists time_accounting;

CREATE TABLE time_accounting
(
    id BIGINT NOT NULL AUTO_INCREMENT,
    ticket_id BIGINT NOT NULL,
    article_id BIGINT,
    time_unit SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    INDEX time_accouning_ticket_id(ticket_id)

);


# -----------------------------------------------------------------------
# faq
# -----------------------------------------------------------------------
drop table if exists faq;

CREATE TABLE faq
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    text VARCHAR (255) NOT NULL,
    language_id SMALLINT NOT NULL,
    comment VARCHAR (80),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# session
# -----------------------------------------------------------------------
drop table if exists session;

CREATE TABLE session
(
    session_id VARCHAR (120) NOT NULL,
    value MEDIUMTEXT NOT NULL,
    UNIQUE (session_id),
    INDEX index_session_id (session_id)
);

# -----------------------------------------------------------------------
# ticket_index 
# -----------------------------------------------------------------------
drop table if exists ticket_index;

CREATE TABLE ticket_index
(
    ticket_id BIGINT NOT NULL,
    queue_id INTEGER NOT NULL,
    queue VARCHAR (70) NOT NULL,
    group_id INTEGER NOT NULL,
    s_lock VARCHAR (70) NOT NULL,
    s_state VARCHAR (70) NOT NULL,
    create_time_unix BIGINT NOT NULL,
    INDEX index_ticket_id (ticket_id)
);  

# -----------------------------------------------------------------------
# ticket_lock_index 
# -----------------------------------------------------------------------
drop table if exists ticket_lock_index;

CREATE TABLE ticket_lock_index
(
    ticket_id BIGINT NOT NULL,
    INDEX index_lock_ticket_id (ticket_id)
);  

# -----------------------------------------------------------------------
# customer_user
# -----------------------------------------------------------------------
drop table if exists customer_user;

CREATE TABLE customer_user
(
    id INTEGER NOT NULL AUTO_INCREMENT,
    login VARCHAR (100) NOT NULL,
    email VARCHAR (150) NOT NULL,
    customer_id VARCHAR (200) NOT NULL,
    pw VARCHAR (50) NOT NULL,
    salutation VARCHAR (50),
    first_name VARCHAR (100) NOT NULL,
    last_name VARCHAR (100) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comment VARCHAR (250) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (login)
);

# -----------------------------------------------------------------------
# customer_preferences
# -----------------------------------------------------------------------
drop table if exists customer_preferences;

CREATE TABLE customer_preferences
(
    user_id VARCHAR (250) NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250),
    INDEX index_customer_preferences_user_id (user_id)
);

# -----------------------------------------------------------------------
# ticket_loop_protection
# -----------------------------------------------------------------------
drop table if exists ticket_loop_protection;

CREATE TABLE ticket_loop_protection
(
    sent_to VARCHAR (250) NOT NULL,
    sent_date VARCHAR (150) NOT NULL,
    INDEX index_ticket_loop_protection_sent_to (sent_to),
    INDEX index_ticket_loop_protection_sent_date (sent_date)
);
# -----------------------------------------------------------------------
# standard_attachment
# -----------------------------------------------------------------------
drop table if exists standard_attachment;

CREATE TABLE standard_attachment
(
    id INTEGER NOT NULL AUTO_INCREMENT,
    name varchar (150) NOT NULL,
    content_type varchar (150) NOT NULL,
    content MEDIUMTEXT NOT NULL,
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
# -----------------------------------------------------------------------
# standard_response_attachment 
# -----------------------------------------------------------------------
drop table if exists standard_response_attachment;

CREATE TABLE standard_response_attachment
(   
    id INTEGER NOT NULL AUTO_INCREMENT,
    standard_attachment_id integer NOT NULL,
    standard_response_id integer NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id)
);
# -----------------------------------------------------------------------
# pop3_account
# -----------------------------------------------------------------------
drop table if exists pop3_account;

CREATE TABLE pop3_account
(
    id INTEGER NOT NULL AUTO_INCREMENT,
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
    PRIMARY KEY(id),
    UNIQUE (login)
);

