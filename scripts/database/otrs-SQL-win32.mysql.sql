
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
    user_id INTEGER NOT NULL,
    group_id INTEGER NOT NULL,
    permission_read SMALLINT NOT NULL,
    permission_write SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL
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
    type_id SMALLINT NOT NULL,
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);

# -----------------------------------------------------------------------
# ticket_state_type
# -----------------------------------------------------------------------
drop table if exists ticket_state_type;

CREATE TABLE ticket_state_type
(
    id SMALLINT NOT NULL AUTO_INCREMENT,
    name VARCHAR (120) NOT NULL,
    comment VARCHAR (250),
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
    move_notify SMALLINT NOT NULL,
    lock_notify SMALLINT NOT NULL,
    state_notify SMALLINT NOT NULL,
    owner_notify SMALLINT NOT NULL,
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
    INDEX index_ticket_queue_view (ticket_state_id, ticket_lock_id, group_id)
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

-- --
-- initial_insert.sql - provides initial system data
-- Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: otrs-SQL-win32.mysql.sql,v 1.3 2003-04-30 10:04:48 robert Exp $
-- 
-- $Log: not supported by cvs2svn $
-- Revision 1.9  2003/04/22 21:23:23  martin
-- added missing StateUpdate to ticket_history_type table
--
-- Revision 1.8  2003/04/12 21:34:12  martin
-- added log type for ticket free text update
--
-- Revision 1.7  2003/03/28 18:41:31  martin
-- fixed queue inital insert
--
-- Revision 1.6  2003/03/13 19:02:02  martin
-- changed docu.otrs.org to doc.otrs.org
--
-- Revision 1.5  2003/03/10 21:25:50  martin
-- added customer email notification on move, state update
--     or owner update (config option for each queue).
--     http://lists.otrs.org/pipermail/dev/2002-June/000005.html
--
-- Revision 1.4  2003/03/08 17:58:00  martin
-- changed reserved SQL words (read, write) to (permission_read, permission_write)
--
-- Revision 1.3  2003/03/03 23:41:45  martin
-- added ticket_state_type values and updated ticket_state values
--
-- Revision 1.2  2003/02/08 21:13:29  martin
-- added number prefix to priority for sort
--
-- Revision 1.1  2003/02/08 11:54:29  martin
-- moved from install/database to scripts/database
--
-- Revision 1.35  2003/01/06 21:40:51  martin
-- removed language table, not longer used
--
-- Revision 1.34  2002/12/25 09:31:39  martin
-- added pending states and removed waiting states
--
-- Revision 1.33  2002/12/15 00:58:21  martin
-- fixed "successful" typo - http://bugs.otrs.org/show_bug.cgi?id=53
--
-- Revision 1.32  2002/11/27 10:33:54  martin
-- removed old stuff and added Windows-1251 charset
--
-- Revision 1.31  2002/11/15 14:12:13  martin
-- added Dutch and Bulgarian translation!
--
-- Revision 1.30  2002/10/20 12:33:02  martin
-- removed personal_queues entry for root@localhost
--
-- Revision 1.29  2002/08/27 21:17:37  martin
-- changed OpenTRS to OTRS
--
-- Revision 1.28  2002/08/27 21:16:22  martin
-- added Cyrillic Charset (KOI8-R)
--
-- Revision 1.27  2002/07/31 23:17:23  martin
-- added time accounting feature
--
-- Revision 1.26  2002/07/25 20:21:28  martin
-- added iso-8859-7 - greek charset
--
-- Revision 1.25  2002/07/23 20:20:38  martin
-- removed test queues
--
-- Revision 1.24  2002/07/13 12:33:05  martin
-- added more articke types and more history types
--
-- Revision 1.23  2002/07/02 08:40:55  martin
-- added iso-8859-15
--
-- Revision 1.22  2002/06/15 20:01:28  martin
-- changed text of welcome ticket
--
-- Revision 1.21  2002/05/30 13:39:55  martin
-- fixed some stuff, added postgresql support.
--
-- Revision 1.20  2002/05/26 22:59:33  martin
-- added escalation_time and unlock_timeout to default queues,
--
-- Revision 1.19  2002/05/21 21:46:05  martin
-- changed default auto responses.
--
-- Revision 1.18  2002/05/14 00:18:19  martin
-- added ticket_history_type SendAgentNotification
--
-- Revision 1.17  2002/05/12 19:25:07  martin
-- added personal_queues for root user.
--
-- Revision 1.16  2002/05/09 23:39:20  martin
-- added French language and added queue_id to initial system address
--
-- Revision 1.15  2002/05/07 22:16:03  martin
-- added emty answer to each queue
--
-- Revision 1.14  2002/05/05 13:45:57  martin
-- added bavarian language.
--
-- Revision 1.13  2002/05/04 20:35:03  martin
-- renamed user table and removed comment row from user table.
--
-- Revision 1.12  2002/05/01 17:34:28  martin
-- added <OTRS_CUSTOMER_REALNAME> tags.
--
-- Revision 1.11  2002/04/30 00:14:48  martin
-- added stats group.
--
-- Revision 1.10  2002/04/14 18:25:17  martin
-- removed preferenvers from user table
--
-- Revision 1.9  2002/04/14 13:34:20  martin
-- replaced article type email with email-external
--
-- Revision 1.8  2002/04/08 14:17:40  martin
-- bin/PostMaster.pl
--
-- Revision 1.7  2002/02/03 22:48:20  martin
-- typo in welcome ticket.
--
-- Revision 1.6  2002/02/03 17:58:45  martin
-- added welcome ticket.
--
-- Revision 1.5  2002/01/30 16:45:09  martin
-- changed otrs@otrs.org to otrs@localhost
--
-- Revision 1.4  2002/01/20 22:23:55  martin
-- no note-normal anymore.
--
-- Revision 1.3  2002/01/10 20:14:00  martin
-- added cvs log.
--
--
-- --
-- This software comes with ABSOLUTELY NO WARRANTY. For details, see
-- the enclosed file COPYING for license information (GPL). If you
-- did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
-- --

-- table valid
INSERT INTO valid
    (name, create_by, create_time, change_by, change_time)
    VALUES
    ('valid', 1, current_timestamp, 1, current_timestamp);
INSERT INTO valid
    (name, create_by, create_time, change_by, change_time)
    VALUES
    ('invalid', 1, current_timestamp, 1, current_timestamp);
INSERT INTO valid
    (name, create_by, create_time, change_by, change_time)
    VALUES
    ('invalid-temporarily', 1, current_timestamp, 1, current_timestamp);
 
-- ticket_priority
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('1 very low', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('2 low', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('3 normal', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('4 high', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('5 very high', 1, current_timestamp, 1, current_timestamp);

-- ticket_lock_type
INSERT INTO ticket_lock_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('unlock', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_lock_type
    (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('lock', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_lock_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('tmp_lock', 1, 1, current_timestamp, 1, current_timestamp);

-- user 
INSERT INTO system_user
    (first_name, last_name, login, pw, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Admin', 'OTRS', 'root@localhost', 'roK20XGbWEsSM', 1, 1, current_timestamp, 1, current_timestamp);

-- groups
INSERT INTO groups
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('users',  1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO groups
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('admin',  1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO groups
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('stats',  1, 1, current_timestamp, 1, current_timestamp);

-- group_user (add admin to groups)
INSERT INTO group_user
    (user_id, permission_read, permission_write, group_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO group_user
    (user_id, permission_read, permission_write, group_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, 2, 1, current_timestamp, 1, current_timestamp);
INSERT INTO group_user
    (user_id, permission_read, permission_write, group_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, 3, 1, current_timestamp, 1, current_timestamp);

-- theme
INSERT INTO theme
    (theme, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Standard', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO theme
    (theme, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Lite', 1, 1, current_timestamp, 1, current_timestamp);

-- charset
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Latin-1 (iso-8859-1)', 'iso-8859-1', 'Western European languages.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Latin-2 (iso-8859-2)', 'iso-8859-2', 'Slavic and Central  European  languages.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Latin-3 (iso-8859-3)', 'iso-8859-3', 'Esperanto, Galician, Maltese, and Turkish.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Latin-4 (iso-8859-4)', 'iso-8859-4', 'Estonian, Latvian, and Lithuanian.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Cyrillic (iso-8859-5)', 'iso-8859-5', 'Bulgarian, Byelorussian, Macedonian, Russian, Serbian  and  Ukrainian.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Greek (iso-8859-7)', 'iso-8859-7', 'Modern monotonic Greek.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Unicode (UTF-8)', 'UTF-8', 'Unicode UTF-8', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Cyrillic Charset (KOI8-R)', 'KOI8-R', 'Unicode UTF-8', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Cyrillic Charset (Windows-1251)', 'Windows-1251', 'Windows-1251 - cp1251', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Turkish (iso-8859-9)', 'iso-8859-9', 'Turkish.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO charset
        (name, charset, comment, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Latin-15 (iso-8859-15)', 'iso-8859-15', 'Western European languages with euro.', 1, 1, current_timestamp, 1, current_timestamp);

-- ticket_state
INSERT INTO ticket_state (name, comment, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('new', 'ticket is new', 1, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comment, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('closed successful', 'ticket is closed successful', 3, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comment, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('closed unsuccessful', 'ticket is closed unsuccessful', 3, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comment, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('open', 'ticket is open', 2, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comment, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('removed', 'customer removed ticket (can reactivate)', 6, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comment, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('pending reminder', 'ticket is pending for agent reminder', 4, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comment, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('pending auto close+', 'ticket is pending for automatic close', 5, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comment, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('pending auto close-', 'ticket is pending for automatic close', 5, 1, 1, current_timestamp, 1, current_timestamp);
-- ticket_state_type
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('new', 'all new state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('open', 'all open state types (default: viewable)', 1, current_timestamp, 1, current_timestamp); 
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('closed', 'all closed state types (default: not viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('pending reminder', 'all "pending reminder" state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('pending auto', 'all "pending auto *" state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comment, create_by, create_time, change_by, change_time)
    VALUES
    ('removed', 'all "removed" state types (default: not viewable)', 1, current_timestamp, 1, current_timestamp);
-- salutation
INSERT INTO salutation
    (name, text, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('system standard salutation (en)', 'Dear <OTRS_CUSTOMER_REALNAME>,

Thank you for your request.
', 'std. salutation', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO salutation
    (name, text, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('system standard salutation (de/buiss)', 'Sehr geehrter <OTRS_CUSTOMER_REALNAME>,

Danke für Ihre Anfrage.
', 'std. salutation', 1, 1, current_timestamp, 1, current_timestamp);

-- signature
INSERT INTO signature
    (name, text, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('system standard signature (en)', '
Your OTRS-Team

 -
 <OTRS_FIRST_NAME> <OTRS_LAST_NAME> 
--
', 'std signature', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO signature
    (name, text, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('system standard signature (de/buiss)', '
Ihr OTRS Team

-- 
  <OTRS_FIRST_NAME> <OTRS_LAST_NAME> 
--
', 'std. signature', 1, 1, current_timestamp, 1, current_timestamp);

-- system_address
INSERT INTO system_address
    (value0, value1, comment, valid_id, queue_id, create_by, create_time, change_by, change_time)
    VALUES
    ('otrs@localhost', 'OTRS System', 'Std. Address', 1, 1, 1, current_timestamp, 1, current_timestamp);

-- follow_up_possible
INSERT INTO follow_up_possible
    (name, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('possible', 'Follow ups after closed(+|-) possible. Ticket will be reopen.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO follow_up_possible
    (name, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('reject', 'Follow ups after closed(+|-) not possible. No new ticket will be created.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO follow_up_possible
    (name, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('new ticket', 'Follow ups after closed(+|-) not possible. A new ticket will be created.', 1, 1, current_timestamp, 1, current_timestamp);

-- queue
INSERT INTO queue
    (name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, escalation_time, unlock_timeout, move_notify, lock_notify, state_notify, owner_notify, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Postmaster', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'master queue', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue
    (name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, escalation_time, unlock_timeout, move_notify, lock_notify, state_notify, owner_notify, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Raw', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'all incoming tickets', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue
    (name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, escalation_time, unlock_timeout, move_notify, lock_notify, state_notify, owner_notify, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Junk', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'all junk tickets', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue
    (name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, escalation_time, unlock_timeout, move_notify, lock_notify, state_notify, owner_notify, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Misc', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'all misk tickets', 1, 1, current_timestamp, 1, current_timestamp);

-- ticket_history_type
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('NewTicket', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('FollowUp', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAutoReject', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAutoReply', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAutoFollowUp', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Forward', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Bounce', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAnswer', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAgentNotification', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendCustomerNotification', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('PhoneCallAgent', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('PhoneCallCustomer', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Close successful', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Close unsuccessful', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('AddNote', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Open', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Reopen', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Move', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Lock', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Unlock', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Remove', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TimeAccounting', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('CustomerUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('PriorityUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('OwnerUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('LoopProtection', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Misc', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SetPendingTime', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SetPending', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('StateUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TicketFreeTextUpdate', 1, 1, current_timestamp, 1, current_timestamp);

-- article_type
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-external', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-internal', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-notification-ext', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-notification-int', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('phone', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('fax', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('sms', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('webrequest', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('note-internal', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('note-external', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('note-report', 1, 1, current_timestamp, 1, current_timestamp);

-- article_article_sender_type
INSERT INTO article_sender_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('agent', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_sender_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('system', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_sender_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('customer', 1, 1, current_timestamp, 1, current_timestamp);

-- standard_response
INSERT INTO standard_response
        (name, text, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('empty answer', '', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO standard_response
        (name, text, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('test answer', 'test answer ...', 1, 1, current_timestamp, 1, current_timestamp);

-- queue_standard_response
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (5, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (6, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (7, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (8, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (9, 1, 1, current_timestamp, 1, current_timestamp);

-- auto_response_type
INSERT INTO auto_response_type
    (name, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto reply', 'auto replay after a new ticket.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO auto_response_type
    (name, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto reject', 'auto reject.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO auto_response_type
    (name, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto follow up', 'auto follow up after a follow up.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO auto_response_type
    (name, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto reply/new ticket', 'auto reply after a follow up. Because the ticket is closed.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO auto_response_type
    (name, comment, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto remove', 'auto remove after a remove e-mail.', 1, 1, current_timestamp, 1, current_timestamp);

-- auto_response
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset_id, comment, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (1, 1, 'default reply', 'This is a demo text which is send to every inquery.
It could contain something like:

Thanks for your e-mail. A new ticket has been created.

You wrote:
<OTRS_CUSTOMER_EMAIL[6]>

Your e-mail will be answered by a human asap

Have fun with OTRS! :-)

  Your OTRS Team
', 'RE: <OTRS_CUSTOMER_SUBJECT[20]>', 1, 'default', 1, current_timestamp, 1, current_timestamp, 1);
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset_id, comment, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (2, 1, 'default reject', 'Reject.', 'thank you for your e-mail. But you forgot importand infos. Pleace write again with all informations. Thanks', 1, 'default', 1, current_timestamp, 1, current_timestamp, 1);
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset_id, comment, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (3, 1, 'default follow up', 'Thanks for your follow up e-mail

You wrote:
<OTRS_CUSTOMER_EMAIL[6]>

Your e-mail will be answered by a human asap.

Have fun with OTRS!

Your OTRS Team
', 'RE: <OTRS_CUSTOMER_SUBJECT[20]>', 1, 'default', 1, current_timestamp, 1, current_timestamp, 1);
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset_id, comment, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (4, 1, 'default closed -> new ticket', 'New ticket after follow up.', 'thank you for your e-mail. The old ticket is closed. You have a new ticket now.', 1, 'default', 1, current_timestamp, 1, current_timestamp, 1);
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset_id, comment, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (5, 1, 'default remove', 'Ticket removed.', 'thank you for your remove e-mail. The ticket is closed.', 1, 'default', 1, current_timestamp, 1, current_timestamp, 1);

-- queue_auto_response
INSERT INTO queue_auto_response
    (queue_id, auto_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (11, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_auto_response
    (queue_id, auto_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (11, 2, 1, current_timestamp, 1, current_timestamp);

-- faq
INSERT INTO faq
    (name, text, comment, language_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('What is OTRS?', 'Open Ticket Request System ...', 'test fax', 1, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO faq
    (name, text, comment, language_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Was ist OTRS?', 'Open Ticket Request System ...', 'test faq', 2, 1, 1, current_timestamp, 1, current_timestamp);


-- --
-- welcome ticket
-- 2002-02-03 added by martin+code at otrs.org 
-- --
INSERT INTO article 
  (ticket_id, article_type_id, article_sender_type_id, a_from, a_to, a_subject, a_message_id, a_body, incoming_time, content_path, valid_id, create_time, create_by, change_time, change_by)
  VALUES 
  (1,1,3, 'OTRS Feedback <feedback@otrs.org>', 'Your OTRS System <otrs@localhost>', 
  'Welcome to OTRS!', '<007@localhost>',
  'Welcome to OTRS!

thank you for installing OTRS.

You will find updates and patches at http://otrs.org/. Online
documentation is available at http://doc.otrs.org/. You can also
take advantage of our mailing lists http://lists.otrs.org/.


Your OTRS Team

    Manage your communication!',
  1012757943, '2002/02/3', 1, current_timestamp,1,current_timestamp,1);

INSERT INTO ticket 
  (tn, queue_id, ticket_lock_id, ticket_answered, user_id, group_id, ticket_priority_id, ticket_state_id, valid_id, create_time_unix, create_time, create_by, change_time, change_by)
  VALUES 
  ('1010001', 2, 1, 0, 1, 1, 3, 1, 1, 1012757943, current_timestamp, 1, current_timestamp, 1);

INSERT INTO ticket_history 
  (name, history_type_id, ticket_id, article_id, valid_id, create_time, create_by, change_time, change_by) 
  VALUES 
  ('New Ticket [1010001] created.',1,1,1,1, current_timestamp,1,current_timestamp,1);


