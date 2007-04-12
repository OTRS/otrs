-- ----------------------------------------------------------
--  driver: oracle, generated: 2007-04-12 11:19:18
-- ----------------------------------------------------------
SET DEFINE OFF;
-- ----------------------------------------------------------
--  create table valid
-- ----------------------------------------------------------
CREATE TABLE valid (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT valid_U_1 UNIQUE (name)
);
ALTER TABLE valid ADD CONSTRAINT valid_PK PRIMARY KEY (id);
DROP SEQUENCE valid_seq;
CREATE SEQUENCE valid_seq;
CREATE OR REPLACE TRIGGER valid_s_t
before insert on valid
for each row
begin
    select valid_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table ticket_priority
-- ----------------------------------------------------------
CREATE TABLE ticket_priority (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT ticket_priority_U_1 UNIQUE (name)
);
ALTER TABLE ticket_priority ADD CONSTRAINT ticket_priority_PK PRIMARY KEY (id);
DROP SEQUENCE ticket_priority_seq;
CREATE SEQUENCE ticket_priority_seq;
CREATE OR REPLACE TRIGGER ticket_priority_s_t
before insert on ticket_priority
for each row
begin
    select ticket_priority_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table ticket_type
-- ----------------------------------------------------------
CREATE TABLE ticket_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT ticket_type_U_1 UNIQUE (name)
);
ALTER TABLE ticket_type ADD CONSTRAINT ticket_type_PK PRIMARY KEY (id);
DROP SEQUENCE ticket_type_seq;
CREATE SEQUENCE ticket_type_seq;
CREATE OR REPLACE TRIGGER ticket_type_s_t
before insert on ticket_type
for each row
begin
    select ticket_type_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table ticket_lock_type
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT ticket_lock_type_U_1 UNIQUE (name)
);
ALTER TABLE ticket_lock_type ADD CONSTRAINT ticket_lock_type_PK PRIMARY KEY (id);
DROP SEQUENCE ticket_lock_type_seq;
CREATE SEQUENCE ticket_lock_type_seq;
CREATE OR REPLACE TRIGGER ticket_lock_type_s_t
before insert on ticket_lock_type
for each row
begin
    select ticket_lock_type_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table system_user
-- ----------------------------------------------------------
CREATE TABLE system_user (
    id NUMBER NOT NULL,
    login VARCHAR2 (100) NOT NULL,
    pw VARCHAR2 (50) NOT NULL,
    salutation VARCHAR2 (50),
    first_name VARCHAR2 (100) NOT NULL,
    last_name VARCHAR2 (100) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT system_user_U_1 UNIQUE (login)
);
ALTER TABLE system_user ADD CONSTRAINT system_user_PK PRIMARY KEY (id);
DROP SEQUENCE system_user_seq;
CREATE SEQUENCE system_user_seq;
CREATE OR REPLACE TRIGGER system_user_s_t
before insert on system_user
for each row
begin
    select system_user_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table user_preferences
-- ----------------------------------------------------------
CREATE TABLE user_preferences (
    user_id NUMBER NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250)
);
CREATE INDEX index_user_preferences_user_id ON user_preferences (user_id);
-- ----------------------------------------------------------
--  create table groups
-- ----------------------------------------------------------
CREATE TABLE groups (
    id NUMBER NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT groups_U_1 UNIQUE (name)
);
ALTER TABLE groups ADD CONSTRAINT groups_PK PRIMARY KEY (id);
DROP SEQUENCE groups_seq;
CREATE SEQUENCE groups_seq;
CREATE OR REPLACE TRIGGER groups_s_t
before insert on groups
for each row
begin
    select groups_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table group_user
-- ----------------------------------------------------------
CREATE TABLE group_user (
    user_id NUMBER NOT NULL,
    group_id NUMBER NOT NULL,
    permission_key VARCHAR2 (20) NOT NULL,
    permission_value NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
-- ----------------------------------------------------------
--  create table group_role
-- ----------------------------------------------------------
CREATE TABLE group_role (
    role_id NUMBER NOT NULL,
    group_id NUMBER NOT NULL,
    permission_key VARCHAR2 (20) NOT NULL,
    permission_value NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
-- ----------------------------------------------------------
--  create table group_customer_user
-- ----------------------------------------------------------
CREATE TABLE group_customer_user (
    user_id VARCHAR2 (100) NOT NULL,
    group_id NUMBER NOT NULL,
    permission_key VARCHAR2 (20) NOT NULL,
    permission_value NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
-- ----------------------------------------------------------
--  create table roles
-- ----------------------------------------------------------
CREATE TABLE roles (
    id NUMBER NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT roles_U_1 UNIQUE (name)
);
ALTER TABLE roles ADD CONSTRAINT roles_PK PRIMARY KEY (id);
DROP SEQUENCE roles_seq;
CREATE SEQUENCE roles_seq;
CREATE OR REPLACE TRIGGER roles_s_t
before insert on roles
for each row
begin
    select roles_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table role_user
-- ----------------------------------------------------------
CREATE TABLE role_user (
    user_id NUMBER NOT NULL,
    role_id NUMBER NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
-- ----------------------------------------------------------
--  create table personal_queues
-- ----------------------------------------------------------
CREATE TABLE personal_queues (
    user_id NUMBER NOT NULL,
    queue_id NUMBER NOT NULL
);
-- ----------------------------------------------------------
--  create table theme
-- ----------------------------------------------------------
CREATE TABLE theme (
    id NUMBER (5, 0) NOT NULL,
    theme VARCHAR2 (100) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT theme_U_1 UNIQUE (theme)
);
ALTER TABLE theme ADD CONSTRAINT theme_PK PRIMARY KEY (id);
DROP SEQUENCE theme_seq;
CREATE SEQUENCE theme_seq;
CREATE OR REPLACE TRIGGER theme_s_t
before insert on theme
for each row
begin
    select theme_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table ticket_state
-- ----------------------------------------------------------
CREATE TABLE ticket_state (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    type_id NUMBER (5, 0) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT ticket_state_U_1 UNIQUE (name)
);
ALTER TABLE ticket_state ADD CONSTRAINT ticket_state_PK PRIMARY KEY (id);
DROP SEQUENCE ticket_state_seq;
CREATE SEQUENCE ticket_state_seq;
CREATE OR REPLACE TRIGGER ticket_state_s_t
before insert on ticket_state
for each row
begin
    select ticket_state_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table ticket_state_type
-- ----------------------------------------------------------
CREATE TABLE ticket_state_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (120) NOT NULL,
    comments VARCHAR2 (250),
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT ticket_state_type_U_1 UNIQUE (name)
);
ALTER TABLE ticket_state_type ADD CONSTRAINT ticket_state_type_PK PRIMARY KEY (id);
DROP SEQUENCE ticket_state_type_seq;
CREATE SEQUENCE ticket_state_type_seq;
CREATE OR REPLACE TRIGGER ticket_state_type_s_t
before insert on ticket_state_type
for each row
begin
    select ticket_state_type_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table salutation
-- ----------------------------------------------------------
CREATE TABLE salutation (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    text VARCHAR2 (3000) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT salutation_U_1 UNIQUE (name)
);
ALTER TABLE salutation ADD CONSTRAINT salutation_PK PRIMARY KEY (id);
DROP SEQUENCE salutation_seq;
CREATE SEQUENCE salutation_seq;
CREATE OR REPLACE TRIGGER salutation_s_t
before insert on salutation
for each row
begin
    select salutation_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table signature
-- ----------------------------------------------------------
CREATE TABLE signature (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    text VARCHAR2 (3000) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT signature_U_1 UNIQUE (name)
);
ALTER TABLE signature ADD CONSTRAINT signature_PK PRIMARY KEY (id);
DROP SEQUENCE signature_seq;
CREATE SEQUENCE signature_seq;
CREATE OR REPLACE TRIGGER signature_s_t
before insert on signature
for each row
begin
    select signature_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table system_address
-- ----------------------------------------------------------
CREATE TABLE system_address (
    id NUMBER (5, 0) NOT NULL,
    value0 VARCHAR2 (200) NOT NULL,
    value1 VARCHAR2 (200) NOT NULL,
    value2 VARCHAR2 (200),
    value3 VARCHAR2 (200),
    queue_id NUMBER NOT NULL,
    comments VARCHAR2 (200),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE system_address ADD CONSTRAINT system_address_PK PRIMARY KEY (id);
DROP SEQUENCE system_address_seq;
CREATE SEQUENCE system_address_seq;
CREATE OR REPLACE TRIGGER system_address_s_t
before insert on system_address
for each row
begin
    select system_address_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table follow_up_possible
-- ----------------------------------------------------------
CREATE TABLE follow_up_possible (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT follow_up_possible_U_1 UNIQUE (name)
);
ALTER TABLE follow_up_possible ADD CONSTRAINT follow_up_possible_PK PRIMARY KEY (id);
DROP SEQUENCE follow_up_possible_seq;
CREATE SEQUENCE follow_up_possible_seq;
CREATE OR REPLACE TRIGGER follow_up_possible_s_t
before insert on follow_up_possible
for each row
begin
    select follow_up_possible_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table queue
-- ----------------------------------------------------------
CREATE TABLE queue (
    id NUMBER NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    group_id NUMBER NOT NULL,
    unlock_timeout NUMBER,
    first_response_time NUMBER,
    update_time NUMBER,
    solution_time NUMBER,
    system_address_id NUMBER (5, 0) NOT NULL,
    calendar_name VARCHAR2 (100),
    default_sign_key VARCHAR2 (100),
    salutation_id NUMBER (5, 0) NOT NULL,
    signature_id NUMBER (5, 0) NOT NULL,
    follow_up_id NUMBER (5, 0) NOT NULL,
    follow_up_lock NUMBER (5, 0) NOT NULL,
    move_notify NUMBER (5, 0) NOT NULL,
    state_notify NUMBER (5, 0) NOT NULL,
    lock_notify NUMBER (5, 0) NOT NULL,
    owner_notify NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (200),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT queue_U_1 UNIQUE (name)
);
ALTER TABLE queue ADD CONSTRAINT queue_PK PRIMARY KEY (id);
DROP SEQUENCE queue_seq;
CREATE SEQUENCE queue_seq;
CREATE OR REPLACE TRIGGER queue_s_t
before insert on queue
for each row
begin
    select queue_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table ticket
-- ----------------------------------------------------------
CREATE TABLE ticket (
    id NUMBER (20, 0) NOT NULL,
    tn VARCHAR2 (50) NOT NULL,
    title VARCHAR2 (255),
    queue_id NUMBER NOT NULL,
    ticket_lock_id NUMBER (5, 0) NOT NULL,
    ticket_answered NUMBER (5, 0) NOT NULL,
    type_id NUMBER,
    service_id NUMBER,
    sla_id NUMBER,
    user_id NUMBER NOT NULL,
    responsible_user_id NUMBER NOT NULL,
    group_id NUMBER NOT NULL,
    ticket_priority_id NUMBER (5, 0) NOT NULL,
    ticket_state_id NUMBER (5, 0) NOT NULL,
    group_read NUMBER (5, 0),
    group_write NUMBER (5, 0),
    other_read NUMBER (5, 0),
    other_write NUMBER (5, 0),
    customer_id VARCHAR2 (150),
    customer_user_id VARCHAR2 (250),
    timeout NUMBER,
    until_time NUMBER,
    escalation_start_time NUMBER NOT NULL,
    freekey1 VARCHAR2 (80),
    freetext1 VARCHAR2 (150),
    freekey2 VARCHAR2 (80),
    freetext2 VARCHAR2 (150),
    freekey3 VARCHAR2 (80),
    freetext3 VARCHAR2 (150),
    freekey4 VARCHAR2 (80),
    freetext4 VARCHAR2 (150),
    freekey5 VARCHAR2 (80),
    freetext5 VARCHAR2 (150),
    freekey6 VARCHAR2 (80),
    freetext6 VARCHAR2 (150),
    freekey7 VARCHAR2 (80),
    freetext7 VARCHAR2 (150),
    freekey8 VARCHAR2 (80),
    freetext8 VARCHAR2 (150),
    freekey9 VARCHAR2 (80),
    freetext9 VARCHAR2 (150),
    freekey10 VARCHAR2 (80),
    freetext10 VARCHAR2 (150),
    freekey11 VARCHAR2 (80),
    freetext11 VARCHAR2 (150),
    freekey12 VARCHAR2 (80),
    freetext12 VARCHAR2 (150),
    freekey13 VARCHAR2 (80),
    freetext13 VARCHAR2 (150),
    freekey14 VARCHAR2 (80),
    freetext14 VARCHAR2 (150),
    freekey15 VARCHAR2 (80),
    freetext15 VARCHAR2 (150),
    freekey16 VARCHAR2 (80),
    freetext16 VARCHAR2 (150),
    freetime1 DATE,
    freetime2 DATE,
    freetime3 DATE,
    freetime4 DATE,
    freetime5 DATE,
    freetime6 DATE,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time_unix NUMBER (20, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT ticket_U_1 UNIQUE (tn)
);
ALTER TABLE ticket ADD CONSTRAINT ticket_PK PRIMARY KEY (id);
DROP SEQUENCE ticket_seq;
CREATE SEQUENCE ticket_seq;
CREATE OR REPLACE TRIGGER ticket_s_t
before insert on ticket
for each row
begin
    select ticket_seq.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX index_ticket_user ON ticket (user_id);
CREATE INDEX index_ticket_type ON ticket (type_id);
CREATE INDEX index_ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id, group_id);
CREATE INDEX index_ticket_answered ON ticket (ticket_answered);
-- ----------------------------------------------------------
--  create table object_link
-- ----------------------------------------------------------
CREATE TABLE object_link (
    object_link_a_id VARCHAR2 (80) NOT NULL,
    object_link_b_id VARCHAR2 (80) NOT NULL,
    object_link_a_object VARCHAR2 (200) NOT NULL,
    object_link_b_object VARCHAR2 (200) NOT NULL,
    object_link_type VARCHAR2 (200) NOT NULL
);
-- ----------------------------------------------------------
--  create table ticket_history
-- ----------------------------------------------------------
CREATE TABLE ticket_history (
    id NUMBER (20, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    history_type_id NUMBER (5, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0),
    type_id NUMBER NOT NULL,
    queue_id NUMBER NOT NULL,
    owner_id NUMBER NOT NULL,
    priority_id NUMBER (5, 0) NOT NULL,
    state_id NUMBER (5, 0) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE ticket_history ADD CONSTRAINT ticket_history_PK PRIMARY KEY (id);
DROP SEQUENCE ticket_history_seq;
CREATE SEQUENCE ticket_history_seq;
CREATE OR REPLACE TRIGGER ticket_history_s_t
before insert on ticket_history
for each row
begin
    select ticket_history_seq.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX ticket_history_ticket_id ON ticket_history (ticket_id);
CREATE INDEX ticket_history_create_time ON ticket_history (create_time);
-- ----------------------------------------------------------
--  create table ticket_history_type
-- ----------------------------------------------------------
CREATE TABLE ticket_history_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT ticket_history_type_U_1 UNIQUE (name)
);
ALTER TABLE ticket_history_type ADD CONSTRAINT ticket_history_type_PK PRIMARY KEY (id);
DROP SEQUENCE ticket_history_type_seq;
CREATE SEQUENCE ticket_history_type_seq;
CREATE OR REPLACE TRIGGER ticket_history_type_s_t
before insert on ticket_history_type
for each row
begin
    select ticket_history_type_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table article_type
-- ----------------------------------------------------------
CREATE TABLE article_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT article_type_U_1 UNIQUE (name)
);
ALTER TABLE article_type ADD CONSTRAINT article_type_PK PRIMARY KEY (id);
DROP SEQUENCE article_type_seq;
CREATE SEQUENCE article_type_seq;
CREATE OR REPLACE TRIGGER article_type_s_t
before insert on article_type
for each row
begin
    select article_type_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table article_sender_type
-- ----------------------------------------------------------
CREATE TABLE article_sender_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT article_sender_type_U_1 UNIQUE (name)
);
ALTER TABLE article_sender_type ADD CONSTRAINT article_sender_type_PK PRIMARY KEY (id);
DROP SEQUENCE article_sender_type_seq;
CREATE SEQUENCE article_sender_type_seq;
CREATE OR REPLACE TRIGGER article_sender_type_s_t
before insert on article_sender_type
for each row
begin
    select article_sender_type_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table article_flag
-- ----------------------------------------------------------
CREATE TABLE article_flag (
    article_id NUMBER (20, 0) NOT NULL,
    article_flag VARCHAR2 (50) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL
);
CREATE INDEX article_flag_create_by ON article_flag (create_by);
CREATE INDEX article_flag_article_id ON article_flag (article_id);
-- ----------------------------------------------------------
--  create table article
-- ----------------------------------------------------------
CREATE TABLE article (
    id NUMBER (20, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_type_id NUMBER (5, 0) NOT NULL,
    article_sender_type_id NUMBER (5, 0) NOT NULL,
    a_from VARCHAR2 (3800),
    a_reply_to VARCHAR2 (500),
    a_to VARCHAR2 (3800),
    a_cc VARCHAR2 (3800),
    a_subject VARCHAR2 (3800),
    a_message_id VARCHAR2 (3800),
    a_content_type VARCHAR2 (250),
    a_body CLOB NOT NULL,
    incoming_time NUMBER NOT NULL,
    content_path VARCHAR2 (250),
    a_freekey1 VARCHAR2 (250),
    a_freetext1 VARCHAR2 (250),
    a_freekey2 VARCHAR2 (250),
    a_freetext2 VARCHAR2 (250),
    a_freekey3 VARCHAR2 (250),
    a_freetext3 VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE article ADD CONSTRAINT article_PK PRIMARY KEY (id);
DROP SEQUENCE article_seq;
CREATE SEQUENCE article_seq;
CREATE OR REPLACE TRIGGER article_s_t
before insert on article
for each row
begin
    select article_seq.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX article_ticket_id ON article (ticket_id);
CREATE INDEX article_message_id ON article (a_message_id);
-- ----------------------------------------------------------
--  create table article_plain
-- ----------------------------------------------------------
CREATE TABLE article_plain (
    id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0) NOT NULL,
    body CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE article_plain ADD CONSTRAINT article_plain_PK PRIMARY KEY (id);
DROP SEQUENCE article_plain_seq;
CREATE SEQUENCE article_plain_seq;
CREATE OR REPLACE TRIGGER article_plain_s_t
before insert on article_plain
for each row
begin
    select article_plain_seq.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX article_plain_article_id ON article_plain (article_id);
-- ----------------------------------------------------------
--  create table article_attachment
-- ----------------------------------------------------------
CREATE TABLE article_attachment (
    id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0) NOT NULL,
    filename VARCHAR2 (250),
    content_size VARCHAR2 (30),
    content_type VARCHAR2 (250),
    content CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE article_attachment ADD CONSTRAINT article_attachment_PK PRIMARY KEY (id);
DROP SEQUENCE article_attachment_seq;
CREATE SEQUENCE article_attachment_seq;
CREATE OR REPLACE TRIGGER article_attachment_s_t
before insert on article_attachment
for each row
begin
    select article_attachment_seq.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX article_attachment_article_id ON article_attachment (article_id);
-- ----------------------------------------------------------
--  create table standard_response
-- ----------------------------------------------------------
CREATE TABLE standard_response (
    id NUMBER NOT NULL,
    name VARCHAR2 (80) NOT NULL,
    text CLOB,
    comments VARCHAR2 (100),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT standard_response_U_1 UNIQUE (name)
);
ALTER TABLE standard_response ADD CONSTRAINT standard_response_PK PRIMARY KEY (id);
DROP SEQUENCE standard_response_seq;
CREATE SEQUENCE standard_response_seq;
CREATE OR REPLACE TRIGGER standard_response_s_t
before insert on standard_response
for each row
begin
    select standard_response_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table queue_standard_response
-- ----------------------------------------------------------
CREATE TABLE queue_standard_response (
    queue_id NUMBER NOT NULL,
    standard_response_id NUMBER NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
-- ----------------------------------------------------------
--  create table standard_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_attachment (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (150) NOT NULL,
    content_type VARCHAR2 (150) NOT NULL,
    content CLOB NOT NULL,
    filename VARCHAR2 (250) NOT NULL,
    comments VARCHAR2 (200),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT standard_attachment_U_1 UNIQUE (name)
);
ALTER TABLE standard_attachment ADD CONSTRAINT standard_attachment_PK PRIMARY KEY (id);
DROP SEQUENCE standard_attachment_seq;
CREATE SEQUENCE standard_attachment_seq;
CREATE OR REPLACE TRIGGER standard_attachment_s_t
before insert on standard_attachment
for each row
begin
    select standard_attachment_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table standard_response_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_response_attachment (
    id NUMBER NOT NULL,
    standard_attachment_id NUMBER NOT NULL,
    standard_response_id NUMBER NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE standard_response_attachment ADD CONSTRAINT standard_response_attach45_PK PRIMARY KEY (id);
DROP SEQUENCE standard_response_attach45_seq;
CREATE SEQUENCE standard_response_attach45_seq;
CREATE OR REPLACE TRIGGER standard_response_attach45_s_t
before insert on standard_response_attachment
for each row
begin
    select standard_response_attach45_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table auto_response_type
-- ----------------------------------------------------------
CREATE TABLE auto_response_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    comments VARCHAR2 (200),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT auto_response_type_U_1 UNIQUE (name)
);
ALTER TABLE auto_response_type ADD CONSTRAINT auto_response_type_PK PRIMARY KEY (id);
DROP SEQUENCE auto_response_type_seq;
CREATE SEQUENCE auto_response_type_seq;
CREATE OR REPLACE TRIGGER auto_response_type_s_t
before insert on auto_response_type
for each row
begin
    select auto_response_type_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table auto_response
-- ----------------------------------------------------------
CREATE TABLE auto_response (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    text0 CLOB,
    text1 CLOB,
    text2 CLOB,
    type_id NUMBER (5, 0) NOT NULL,
    system_address_id NUMBER (5, 0) NOT NULL,
    charset VARCHAR2 (80) NOT NULL,
    comments VARCHAR2 (100),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT auto_response_U_1 UNIQUE (name)
);
ALTER TABLE auto_response ADD CONSTRAINT auto_response_PK PRIMARY KEY (id);
DROP SEQUENCE auto_response_seq;
CREATE SEQUENCE auto_response_seq;
CREATE OR REPLACE TRIGGER auto_response_s_t
before insert on auto_response
for each row
begin
    select auto_response_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table queue_auto_response
-- ----------------------------------------------------------
CREATE TABLE queue_auto_response (
    id NUMBER NOT NULL,
    queue_id NUMBER NOT NULL,
    auto_response_id NUMBER NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE queue_auto_response ADD CONSTRAINT queue_auto_response_PK PRIMARY KEY (id);
DROP SEQUENCE queue_auto_response_seq;
CREATE SEQUENCE queue_auto_response_seq;
CREATE OR REPLACE TRIGGER queue_auto_response_s_t
before insert on queue_auto_response
for each row
begin
    select queue_auto_response_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table time_accounting
-- ----------------------------------------------------------
CREATE TABLE time_accounting (
    id NUMBER (20, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0),
    time_unit DECIMAL (10,2) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE time_accounting ADD CONSTRAINT time_accounting_PK PRIMARY KEY (id);
DROP SEQUENCE time_accounting_seq;
CREATE SEQUENCE time_accounting_seq;
CREATE OR REPLACE TRIGGER time_accounting_s_t
before insert on time_accounting
for each row
begin
    select time_accounting_seq.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX index_time_accounting_ticket51 ON time_accounting (ticket_id);
-- ----------------------------------------------------------
--  create table ticket_watcher
-- ----------------------------------------------------------
CREATE TABLE ticket_watcher (
    ticket_id NUMBER (20, 0) NOT NULL,
    user_id NUMBER NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
CREATE INDEX ticket_watcher_ticket_id ON ticket_watcher (ticket_id);
CREATE TABLE service (
    id NUMBER NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (200) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT service_U_1 UNIQUE (name)
);
ALTER TABLE service ADD CONSTRAINT service_PK PRIMARY KEY (id);
DROP SEQUENCE service_seq;
CREATE SEQUENCE service_seq;
CREATE OR REPLACE TRIGGER service_s_t
before insert on service
for each row
begin
    select service_seq.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE TABLE sla (
    id NUMBER NOT NULL,
    service_id NUMBER NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    calendar_name VARCHAR2 (100),
    first_response_time NUMBER NOT NULL,
    update_time NUMBER NOT NULL,
    solution_time NUMBER NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (200) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT sla_U_1 UNIQUE (name)
);
ALTER TABLE sla ADD CONSTRAINT sla_PK PRIMARY KEY (id);
DROP SEQUENCE sla_seq;
CREATE SEQUENCE sla_seq;
CREATE OR REPLACE TRIGGER sla_s_t
before insert on sla
for each row
begin
    select sla_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table sessions
-- ----------------------------------------------------------
CREATE TABLE sessions (
    session_id VARCHAR2 (150) NOT NULL,
    session_value CLOB NOT NULL
);
CREATE INDEX index_session_id ON sessions (session_id);
-- ----------------------------------------------------------
--  create table ticket_index
-- ----------------------------------------------------------
CREATE TABLE ticket_index (
    ticket_id NUMBER (20, 0) NOT NULL,
    queue_id NUMBER NOT NULL,
    queue VARCHAR2 (70) NOT NULL,
    group_id NUMBER NOT NULL,
    s_lock VARCHAR2 (70) NOT NULL,
    s_state VARCHAR2 (70) NOT NULL,
    create_time_unix NUMBER (20, 0) NOT NULL
);
CREATE INDEX index_ticket_index_ticket_id ON ticket_index (ticket_id);
-- ----------------------------------------------------------
--  create table ticket_lock_index
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_index (
    ticket_id NUMBER (20, 0) NOT NULL
);
CREATE INDEX index_ticket_lock_ticket_id ON ticket_lock_index (ticket_id);
-- ----------------------------------------------------------
--  create table customer_user
-- ----------------------------------------------------------
CREATE TABLE customer_user (
    id NUMBER NOT NULL,
    login VARCHAR2 (100) NOT NULL,
    email VARCHAR2 (150) NOT NULL,
    customer_id VARCHAR2 (200) NOT NULL,
    pw VARCHAR2 (50),
    salutation VARCHAR2 (50),
    first_name VARCHAR2 (100) NOT NULL,
    last_name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT customer_user_U_1 UNIQUE (login)
);
ALTER TABLE customer_user ADD CONSTRAINT customer_user_PK PRIMARY KEY (id);
DROP SEQUENCE customer_user_seq;
CREATE SEQUENCE customer_user_seq;
CREATE OR REPLACE TRIGGER customer_user_s_t
before insert on customer_user
for each row
begin
    select customer_user_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table customer_preferences
-- ----------------------------------------------------------
CREATE TABLE customer_preferences (
    user_id VARCHAR2 (250) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250)
);
CREATE INDEX index_customer_preferences_u61 ON customer_preferences (user_id);
-- ----------------------------------------------------------
--  create table customer_company
-- ----------------------------------------------------------
CREATE TABLE customer_company (
    customer_id VARCHAR2 (100) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    street VARCHAR2 (200),
    zip VARCHAR2 (200),
    city VARCHAR2 (200),
    country VARCHAR2 (200),
    url VARCHAR2 (200),
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL,
    CONSTRAINT customer_company_U_1 UNIQUE (customer_id),
    CONSTRAINT customer_company_U_2 UNIQUE (name)
);
-- ----------------------------------------------------------
--  create table ticket_loop_protection
-- ----------------------------------------------------------
CREATE TABLE ticket_loop_protection (
    sent_to VARCHAR2 (250) NOT NULL,
    sent_date VARCHAR2 (150) NOT NULL
);
CREATE INDEX index_ticket_loop_protection55 ON ticket_loop_protection (sent_to);
CREATE INDEX index_ticket_loop_protection92 ON ticket_loop_protection (sent_date);
-- ----------------------------------------------------------
--  create table pop3_account
-- ----------------------------------------------------------
CREATE TABLE pop3_account (
    id NUMBER NOT NULL,
    login VARCHAR2 (200) NOT NULL,
    pw VARCHAR2 (200) NOT NULL,
    host VARCHAR2 (200) NOT NULL,
    queue_id NUMBER NOT NULL,
    trusted NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE pop3_account ADD CONSTRAINT pop3_account_PK PRIMARY KEY (id);
DROP SEQUENCE pop3_account_seq;
CREATE SEQUENCE pop3_account_seq;
CREATE OR REPLACE TRIGGER pop3_account_s_t
before insert on pop3_account
for each row
begin
    select pop3_account_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table postmaster_filter
-- ----------------------------------------------------------
CREATE TABLE postmaster_filter (
    f_name VARCHAR2 (200) NOT NULL,
    f_type VARCHAR2 (20) NOT NULL,
    f_key VARCHAR2 (200) NOT NULL,
    f_value VARCHAR2 (200) NOT NULL
);
-- ----------------------------------------------------------
--  create table generic_agent_jobs
-- ----------------------------------------------------------
CREATE TABLE generic_agent_jobs (
    job_name VARCHAR2 (200) NOT NULL,
    job_key VARCHAR2 (200) NOT NULL,
    job_value VARCHAR2 (200) NOT NULL
);
-- ----------------------------------------------------------
--  create table search_profile
-- ----------------------------------------------------------
CREATE TABLE search_profile (
    login VARCHAR2 (200) NOT NULL,
    profile_name VARCHAR2 (200) NOT NULL,
    profile_type VARCHAR2 (30) NOT NULL,
    profile_key VARCHAR2 (200) NOT NULL,
    profile_value VARCHAR2 (200)
);
-- ----------------------------------------------------------
--  create table process_id
-- ----------------------------------------------------------
CREATE TABLE process_id (
    process_name VARCHAR2 (200) NOT NULL,
    process_id VARCHAR2 (200) NOT NULL,
    process_host VARCHAR2 (200) NOT NULL,
    process_create NUMBER NOT NULL
);
-- ----------------------------------------------------------
--  create table web_upload_cache
-- ----------------------------------------------------------
CREATE TABLE web_upload_cache (
    form_id VARCHAR2 (250),
    filename VARCHAR2 (250),
    content_size VARCHAR2 (30),
    content_type VARCHAR2 (250),
    content CLOB NOT NULL,
    create_time_unix NUMBER (20, 0) NOT NULL
);
-- ----------------------------------------------------------
--  create table notifications
-- ----------------------------------------------------------
CREATE TABLE notifications (
    id NUMBER NOT NULL,
    notification_type VARCHAR2 (200) NOT NULL,
    notification_charset VARCHAR2 (60) NOT NULL,
    notification_language VARCHAR2 (60) NOT NULL,
    subject VARCHAR2 (200) NOT NULL,
    text VARCHAR2 (4000) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE notifications ADD CONSTRAINT notifications_PK PRIMARY KEY (id);
DROP SEQUENCE notifications_seq;
CREATE SEQUENCE notifications_seq;
CREATE OR REPLACE TRIGGER notifications_s_t
before insert on notifications
for each row
begin
    select notifications_seq.nextval
    into :new.id
    from dual;
end;
/
--;
-- ----------------------------------------------------------
--  create table xml_storage
-- ----------------------------------------------------------
CREATE TABLE xml_storage (
    xml_type VARCHAR2 (200) NOT NULL,
    xml_key VARCHAR2 (250) NOT NULL,
    xml_content_key VARCHAR2 (250) NOT NULL,
    xml_content_value CLOB
);
CREATE INDEX xml_storage_xml_content_key ON xml_storage (xml_content_key);
CREATE INDEX xml_storage_key_type ON xml_storage (xml_key, xml_type);
-- ----------------------------------------------------------
--  create table package_repository
-- ----------------------------------------------------------
CREATE TABLE package_repository (
    id NUMBER NOT NULL,
    name VARCHAR2 (250) NOT NULL,
    version VARCHAR2 (250) NOT NULL,
    vendor VARCHAR2 (250) NOT NULL,
    install_status VARCHAR2 (250) NOT NULL,
    filename VARCHAR2 (250),
    content_size VARCHAR2 (30),
    content_type VARCHAR2 (250),
    content CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER NOT NULL
);
ALTER TABLE package_repository ADD CONSTRAINT package_repository_PK PRIMARY KEY (id);
DROP SEQUENCE package_repository_seq;
CREATE SEQUENCE package_repository_seq;
CREATE OR REPLACE TRIGGER package_repository_s_t
before insert on package_repository
for each row
begin
    select package_repository_seq.nextval
    into :new.id
    from dual;
end;
/
--;
