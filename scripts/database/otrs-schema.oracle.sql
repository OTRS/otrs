-- ----------------------------------------------------------
--  driver: oracle, generated: 2008-05-10 11:15:59
-- ----------------------------------------------------------
SET DEFINE OFF;
-- ----------------------------------------------------------
--  create table valid
-- ----------------------------------------------------------
CREATE TABLE valid (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT valid_name UNIQUE (name)
);
ALTER TABLE valid ADD CONSTRAINT PK_valid PRIMARY KEY (id);
DROP SEQUENCE SE_valid;
CREATE SEQUENCE SE_valid;
CREATE OR REPLACE TRIGGER SE_valid_t
before insert on valid
for each row
begin
    select SE_valid.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_valid_change_by ON valid (change_by);
CREATE INDEX FK_valid_create_by ON valid (create_by);
-- ----------------------------------------------------------
--  create table ticket_priority
-- ----------------------------------------------------------
CREATE TABLE ticket_priority (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT ticket_priority_name UNIQUE (name)
);
ALTER TABLE ticket_priority ADD CONSTRAINT PK_ticket_priority PRIMARY KEY (id);
DROP SEQUENCE SE_ticket_priority;
CREATE SEQUENCE SE_ticket_priority;
CREATE OR REPLACE TRIGGER SE_ticket_priority_t
before insert on ticket_priority
for each row
begin
    select SE_ticket_priority.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_ticket_priority_change_by ON ticket_priority (change_by);
CREATE INDEX FK_ticket_priority_create_by ON ticket_priority (create_by);
-- ----------------------------------------------------------
--  create table ticket_type
-- ----------------------------------------------------------
CREATE TABLE ticket_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT ticket_type_name UNIQUE (name)
);
ALTER TABLE ticket_type ADD CONSTRAINT PK_ticket_type PRIMARY KEY (id);
DROP SEQUENCE SE_ticket_type;
CREATE SEQUENCE SE_ticket_type;
CREATE OR REPLACE TRIGGER SE_ticket_type_t
before insert on ticket_type
for each row
begin
    select SE_ticket_type.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_ticket_type_change_by ON ticket_type (change_by);
CREATE INDEX FK_ticket_type_create_by ON ticket_type (create_by);
CREATE INDEX FK_ticket_type_valid_id ON ticket_type (valid_id);
-- ----------------------------------------------------------
--  create table ticket_lock_type
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT ticket_lock_type_name UNIQUE (name)
);
ALTER TABLE ticket_lock_type ADD CONSTRAINT PK_ticket_lock_type PRIMARY KEY (id);
DROP SEQUENCE SE_ticket_lock_type;
CREATE SEQUENCE SE_ticket_lock_type;
CREATE OR REPLACE TRIGGER SE_ticket_lock_type_t
before insert on ticket_lock_type
for each row
begin
    select SE_ticket_lock_type.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_ticket_lock_type_change_by ON ticket_lock_type (change_by);
CREATE INDEX FK_ticket_lock_type_create_by ON ticket_lock_type (create_by);
CREATE INDEX FK_ticket_lock_type_valid_id ON ticket_lock_type (valid_id);
-- ----------------------------------------------------------
--  create table system_user
-- ----------------------------------------------------------
CREATE TABLE system_user (
    id NUMBER (12, 0) NOT NULL,
    login VARCHAR2 (100) NOT NULL,
    pw VARCHAR2 (50) NOT NULL,
    salutation VARCHAR2 (50),
    first_name VARCHAR2 (100) NOT NULL,
    last_name VARCHAR2 (100) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT system_user_login UNIQUE (login)
);
ALTER TABLE system_user ADD CONSTRAINT PK_system_user PRIMARY KEY (id);
DROP SEQUENCE SE_system_user;
CREATE SEQUENCE SE_system_user;
CREATE OR REPLACE TRIGGER SE_system_user_t
before insert on system_user
for each row
begin
    select SE_system_user.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_system_user_change_by ON system_user (change_by);
CREATE INDEX FK_system_user_create_by ON system_user (create_by);
CREATE INDEX FK_system_user_valid_id ON system_user (valid_id);
-- ----------------------------------------------------------
--  create table user_preferences
-- ----------------------------------------------------------
CREATE TABLE user_preferences (
    user_id NUMBER (12, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250)
);
CREATE INDEX user_preferences_user_id ON user_preferences (user_id);
-- ----------------------------------------------------------
--  create table groups
-- ----------------------------------------------------------
CREATE TABLE groups (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT groups_name UNIQUE (name)
);
ALTER TABLE groups ADD CONSTRAINT PK_groups PRIMARY KEY (id);
DROP SEQUENCE SE_groups;
CREATE SEQUENCE SE_groups;
CREATE OR REPLACE TRIGGER SE_groups_t
before insert on groups
for each row
begin
    select SE_groups.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_groups_change_by ON groups (change_by);
CREATE INDEX FK_groups_create_by ON groups (create_by);
CREATE INDEX FK_groups_valid_id ON groups (valid_id);
-- ----------------------------------------------------------
--  create table group_user
-- ----------------------------------------------------------
CREATE TABLE group_user (
    user_id NUMBER (12, 0) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    permission_key VARCHAR2 (20) NOT NULL,
    permission_value NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_group_user_change_by ON group_user (change_by);
CREATE INDEX FK_group_user_create_by ON group_user (create_by);
CREATE INDEX group_user_group_id ON group_user (group_id);
CREATE INDEX group_user_user_id ON group_user (user_id);
-- ----------------------------------------------------------
--  create table group_role
-- ----------------------------------------------------------
CREATE TABLE group_role (
    role_id NUMBER (12, 0) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    permission_key VARCHAR2 (20) NOT NULL,
    permission_value NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_group_role_change_by ON group_role (change_by);
CREATE INDEX FK_group_role_create_by ON group_role (create_by);
CREATE INDEX group_role_group_id ON group_role (group_id);
CREATE INDEX group_role_role_id ON group_role (role_id);
-- ----------------------------------------------------------
--  create table group_customer_user
-- ----------------------------------------------------------
CREATE TABLE group_customer_user (
    user_id VARCHAR2 (100) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    permission_key VARCHAR2 (20) NOT NULL,
    permission_value NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_group_customer_user_chang04 ON group_customer_user (change_by);
CREATE INDEX FK_group_customer_user_creata6 ON group_customer_user (create_by);
CREATE INDEX group_customer_user_group_id ON group_customer_user (group_id);
CREATE INDEX group_customer_user_user_id ON group_customer_user (user_id);
-- ----------------------------------------------------------
--  create table roles
-- ----------------------------------------------------------
CREATE TABLE roles (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT roles_name UNIQUE (name)
);
ALTER TABLE roles ADD CONSTRAINT PK_roles PRIMARY KEY (id);
DROP SEQUENCE SE_roles;
CREATE SEQUENCE SE_roles;
CREATE OR REPLACE TRIGGER SE_roles_t
before insert on roles
for each row
begin
    select SE_roles.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_roles_change_by ON roles (change_by);
CREATE INDEX FK_roles_create_by ON roles (create_by);
CREATE INDEX FK_roles_valid_id ON roles (valid_id);
-- ----------------------------------------------------------
--  create table role_user
-- ----------------------------------------------------------
CREATE TABLE role_user (
    user_id NUMBER (12, 0) NOT NULL,
    role_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_role_user_change_by ON role_user (change_by);
CREATE INDEX FK_role_user_create_by ON role_user (create_by);
CREATE INDEX role_user_role_id ON role_user (role_id);
CREATE INDEX role_user_user_id ON role_user (user_id);
-- ----------------------------------------------------------
--  create table personal_queues
-- ----------------------------------------------------------
CREATE TABLE personal_queues (
    user_id NUMBER (12, 0) NOT NULL,
    queue_id NUMBER (12, 0) NOT NULL
);
CREATE INDEX personal_queues_queue_id ON personal_queues (queue_id);
CREATE INDEX personal_queues_user_id ON personal_queues (user_id);
-- ----------------------------------------------------------
--  create table theme
-- ----------------------------------------------------------
CREATE TABLE theme (
    id NUMBER (5, 0) NOT NULL,
    theme VARCHAR2 (100) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT theme_theme UNIQUE (theme)
);
ALTER TABLE theme ADD CONSTRAINT PK_theme PRIMARY KEY (id);
DROP SEQUENCE SE_theme;
CREATE SEQUENCE SE_theme;
CREATE OR REPLACE TRIGGER SE_theme_t
before insert on theme
for each row
begin
    select SE_theme.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_theme_change_by ON theme (change_by);
CREATE INDEX FK_theme_create_by ON theme (create_by);
CREATE INDEX FK_theme_valid_id ON theme (valid_id);
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT ticket_state_name UNIQUE (name)
);
ALTER TABLE ticket_state ADD CONSTRAINT PK_ticket_state PRIMARY KEY (id);
DROP SEQUENCE SE_ticket_state;
CREATE SEQUENCE SE_ticket_state;
CREATE OR REPLACE TRIGGER SE_ticket_state_t
before insert on ticket_state
for each row
begin
    select SE_ticket_state.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_ticket_state_change_by ON ticket_state (change_by);
CREATE INDEX FK_ticket_state_create_by ON ticket_state (create_by);
CREATE INDEX FK_ticket_state_type_id ON ticket_state (type_id);
CREATE INDEX FK_ticket_state_valid_id ON ticket_state (valid_id);
-- ----------------------------------------------------------
--  create table ticket_state_type
-- ----------------------------------------------------------
CREATE TABLE ticket_state_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (120) NOT NULL,
    comments VARCHAR2 (250),
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT ticket_state_type_name UNIQUE (name)
);
ALTER TABLE ticket_state_type ADD CONSTRAINT PK_ticket_state_type PRIMARY KEY (id);
DROP SEQUENCE SE_ticket_state_type;
CREATE SEQUENCE SE_ticket_state_type;
CREATE OR REPLACE TRIGGER SE_ticket_state_type_t
before insert on ticket_state_type
for each row
begin
    select SE_ticket_state_type.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_ticket_state_type_change_by ON ticket_state_type (change_by);
CREATE INDEX FK_ticket_state_type_create_by ON ticket_state_type (create_by);
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT salutation_name UNIQUE (name)
);
ALTER TABLE salutation ADD CONSTRAINT PK_salutation PRIMARY KEY (id);
DROP SEQUENCE SE_salutation;
CREATE SEQUENCE SE_salutation;
CREATE OR REPLACE TRIGGER SE_salutation_t
before insert on salutation
for each row
begin
    select SE_salutation.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_salutation_change_by ON salutation (change_by);
CREATE INDEX FK_salutation_create_by ON salutation (create_by);
CREATE INDEX FK_salutation_valid_id ON salutation (valid_id);
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT signature_name UNIQUE (name)
);
ALTER TABLE signature ADD CONSTRAINT PK_signature PRIMARY KEY (id);
DROP SEQUENCE SE_signature;
CREATE SEQUENCE SE_signature;
CREATE OR REPLACE TRIGGER SE_signature_t
before insert on signature
for each row
begin
    select SE_signature.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_signature_change_by ON signature (change_by);
CREATE INDEX FK_signature_create_by ON signature (create_by);
CREATE INDEX FK_signature_valid_id ON signature (valid_id);
-- ----------------------------------------------------------
--  create table system_address
-- ----------------------------------------------------------
CREATE TABLE system_address (
    id NUMBER (5, 0) NOT NULL,
    value0 VARCHAR2 (200) NOT NULL,
    value1 VARCHAR2 (200) NOT NULL,
    value2 VARCHAR2 (200),
    value3 VARCHAR2 (200),
    queue_id NUMBER (12, 0) NOT NULL,
    comments VARCHAR2 (200),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE system_address ADD CONSTRAINT PK_system_address PRIMARY KEY (id);
DROP SEQUENCE SE_system_address;
CREATE SEQUENCE SE_system_address;
CREATE OR REPLACE TRIGGER SE_system_address_t
before insert on system_address
for each row
begin
    select SE_system_address.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_system_address_change_by ON system_address (change_by);
CREATE INDEX FK_system_address_create_by ON system_address (create_by);
CREATE INDEX FK_system_address_valid_id ON system_address (valid_id);
-- ----------------------------------------------------------
--  create table follow_up_possible
-- ----------------------------------------------------------
CREATE TABLE follow_up_possible (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT follow_up_possible_name UNIQUE (name)
);
ALTER TABLE follow_up_possible ADD CONSTRAINT PK_follow_up_possible PRIMARY KEY (id);
DROP SEQUENCE SE_follow_up_possible;
CREATE SEQUENCE SE_follow_up_possible;
CREATE OR REPLACE TRIGGER SE_follow_up_possible_t
before insert on follow_up_possible
for each row
begin
    select SE_follow_up_possible.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_follow_up_possible_change8f ON follow_up_possible (change_by);
CREATE INDEX FK_follow_up_possible_create7e ON follow_up_possible (create_by);
CREATE INDEX FK_follow_up_possible_valid_id ON follow_up_possible (valid_id);
-- ----------------------------------------------------------
--  create table queue
-- ----------------------------------------------------------
CREATE TABLE queue (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    unlock_timeout NUMBER (12, 0),
    first_response_time NUMBER (12, 0),
    first_response_notify NUMBER (5, 0),
    update_time NUMBER (12, 0),
    update_notify NUMBER (5, 0),
    solution_time NUMBER (12, 0),
    solution_notify NUMBER (5, 0),
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT queue_name UNIQUE (name)
);
ALTER TABLE queue ADD CONSTRAINT PK_queue PRIMARY KEY (id);
DROP SEQUENCE SE_queue;
CREATE SEQUENCE SE_queue;
CREATE OR REPLACE TRIGGER SE_queue_t
before insert on queue
for each row
begin
    select SE_queue.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_queue_change_by ON queue (change_by);
CREATE INDEX FK_queue_create_by ON queue (create_by);
CREATE INDEX FK_queue_follow_up_id ON queue (follow_up_id);
CREATE INDEX FK_queue_salutation_id ON queue (salutation_id);
CREATE INDEX FK_queue_signature_id ON queue (signature_id);
CREATE INDEX FK_queue_system_address_id ON queue (system_address_id);
CREATE INDEX FK_queue_valid_id ON queue (valid_id);
CREATE INDEX queue_group_id ON queue (group_id);
-- ----------------------------------------------------------
--  create table queue_preferences
-- ----------------------------------------------------------
CREATE TABLE queue_preferences (
    queue_id NUMBER (12, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250)
);
CREATE INDEX queue_preferences_queue_id ON queue_preferences (queue_id);
-- ----------------------------------------------------------
--  create table ticket
-- ----------------------------------------------------------
CREATE TABLE ticket (
    id NUMBER (20, 0) NOT NULL,
    tn VARCHAR2 (50) NOT NULL,
    title VARCHAR2 (255),
    queue_id NUMBER (12, 0) NOT NULL,
    ticket_lock_id NUMBER (5, 0) NOT NULL,
    ticket_answered NUMBER (5, 0) NOT NULL,
    type_id NUMBER (5, 0),
    service_id NUMBER (12, 0),
    sla_id NUMBER (12, 0),
    user_id NUMBER (12, 0) NOT NULL,
    responsible_user_id NUMBER (12, 0) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    ticket_priority_id NUMBER (5, 0) NOT NULL,
    ticket_state_id NUMBER (5, 0) NOT NULL,
    group_read NUMBER (5, 0),
    group_write NUMBER (5, 0),
    other_read NUMBER (5, 0),
    other_write NUMBER (5, 0),
    customer_id VARCHAR2 (150),
    customer_user_id VARCHAR2 (250),
    timeout NUMBER (12, 0),
    until_time NUMBER (12, 0),
    escalation_start_time NUMBER (12, 0) NOT NULL,
    escalation_response_time NUMBER (12, 0) NOT NULL,
    escalation_solution_time NUMBER (12, 0) NOT NULL,
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT ticket_tn UNIQUE (tn)
);
ALTER TABLE ticket ADD CONSTRAINT PK_ticket PRIMARY KEY (id);
DROP SEQUENCE SE_ticket;
CREATE SEQUENCE SE_ticket;
CREATE OR REPLACE TRIGGER SE_ticket_t
before insert on ticket
for each row
begin
    select SE_ticket.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_ticket_change_by ON ticket (change_by);
CREATE INDEX FK_ticket_create_by ON ticket (create_by);
CREATE INDEX FK_ticket_service_id ON ticket (service_id);
CREATE INDEX FK_ticket_sla_id ON ticket (sla_id);
CREATE INDEX FK_ticket_valid_id ON ticket (valid_id);
CREATE INDEX ticket_answered ON ticket (ticket_answered);
CREATE INDEX ticket_customer_id ON ticket (customer_id);
CREATE INDEX ticket_customer_user_id ON ticket (customer_user_id);
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
--  create table object_link
-- ----------------------------------------------------------
CREATE TABLE object_link (
    object_link_a_id VARCHAR2 (80) NOT NULL,
    object_link_b_id VARCHAR2 (80) NOT NULL,
    object_link_a_object VARCHAR2 (200) NOT NULL,
    object_link_b_object VARCHAR2 (200) NOT NULL,
    object_link_type VARCHAR2 (200) NOT NULL
);
CREATE INDEX object_link_a_id ON object_link (object_link_a_id);
CREATE INDEX object_link_a_object ON object_link (object_link_a_object);
CREATE INDEX object_link_b_id ON object_link (object_link_b_id);
CREATE INDEX object_link_b_object ON object_link (object_link_b_object);
CREATE INDEX object_link_type ON object_link (object_link_type);
-- ----------------------------------------------------------
--  create table ticket_history
-- ----------------------------------------------------------
CREATE TABLE ticket_history (
    id NUMBER (20, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    history_type_id NUMBER (5, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0),
    type_id NUMBER (5, 0) NOT NULL,
    queue_id NUMBER (12, 0) NOT NULL,
    owner_id NUMBER (12, 0) NOT NULL,
    priority_id NUMBER (5, 0) NOT NULL,
    state_id NUMBER (5, 0) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE ticket_history ADD CONSTRAINT PK_ticket_history PRIMARY KEY (id);
DROP SEQUENCE SE_ticket_history;
CREATE SEQUENCE SE_ticket_history;
CREATE OR REPLACE TRIGGER SE_ticket_history_t
before insert on ticket_history
for each row
begin
    select SE_ticket_history.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_ticket_history_article_id ON ticket_history (article_id);
CREATE INDEX FK_ticket_history_change_by ON ticket_history (change_by);
CREATE INDEX FK_ticket_history_create_by ON ticket_history (create_by);
CREATE INDEX FK_ticket_history_valid_id ON ticket_history (valid_id);
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
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT ticket_history_type_name UNIQUE (name)
);
ALTER TABLE ticket_history_type ADD CONSTRAINT PK_ticket_history_type PRIMARY KEY (id);
DROP SEQUENCE SE_ticket_history_type;
CREATE SEQUENCE SE_ticket_history_type;
CREATE OR REPLACE TRIGGER SE_ticket_history_type_t
before insert on ticket_history_type
for each row
begin
    select SE_ticket_history_type.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_ticket_history_type_chang16 ON ticket_history_type (change_by);
CREATE INDEX FK_ticket_history_type_creat39 ON ticket_history_type (create_by);
CREATE INDEX FK_ticket_history_type_validad ON ticket_history_type (valid_id);
-- ----------------------------------------------------------
--  create table article_type
-- ----------------------------------------------------------
CREATE TABLE article_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT article_type_name UNIQUE (name)
);
ALTER TABLE article_type ADD CONSTRAINT PK_article_type PRIMARY KEY (id);
DROP SEQUENCE SE_article_type;
CREATE SEQUENCE SE_article_type;
CREATE OR REPLACE TRIGGER SE_article_type_t
before insert on article_type
for each row
begin
    select SE_article_type.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_article_type_change_by ON article_type (change_by);
CREATE INDEX FK_article_type_create_by ON article_type (create_by);
CREATE INDEX FK_article_type_valid_id ON article_type (valid_id);
-- ----------------------------------------------------------
--  create table article_sender_type
-- ----------------------------------------------------------
CREATE TABLE article_sender_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT article_sender_type_name UNIQUE (name)
);
ALTER TABLE article_sender_type ADD CONSTRAINT PK_article_sender_type PRIMARY KEY (id);
DROP SEQUENCE SE_article_sender_type;
CREATE SEQUENCE SE_article_sender_type;
CREATE OR REPLACE TRIGGER SE_article_sender_type_t
before insert on article_sender_type
for each row
begin
    select SE_article_sender_type.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_article_sender_type_chang7b ON article_sender_type (change_by);
CREATE INDEX FK_article_sender_type_creat54 ON article_sender_type (create_by);
CREATE INDEX FK_article_sender_type_validfb ON article_sender_type (valid_id);
-- ----------------------------------------------------------
--  create table article_flag
-- ----------------------------------------------------------
CREATE TABLE article_flag (
    article_id NUMBER (20, 0) NOT NULL,
    article_flag VARCHAR2 (50) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX article_flag_article_id ON article_flag (article_id);
CREATE INDEX article_flag_create_by ON article_flag (create_by);
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
    incoming_time NUMBER (12, 0) NOT NULL,
    content_path VARCHAR2 (250),
    a_freekey1 VARCHAR2 (250),
    a_freetext1 VARCHAR2 (250),
    a_freekey2 VARCHAR2 (250),
    a_freetext2 VARCHAR2 (250),
    a_freekey3 VARCHAR2 (250),
    a_freetext3 VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE article ADD CONSTRAINT PK_article PRIMARY KEY (id);
DROP SEQUENCE SE_article;
CREATE SEQUENCE SE_article;
CREATE OR REPLACE TRIGGER SE_article_t
before insert on article
for each row
begin
    select SE_article.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_article_change_by ON article (change_by);
CREATE INDEX FK_article_create_by ON article (create_by);
CREATE INDEX FK_article_valid_id ON article (valid_id);
CREATE INDEX article_article_sender_type_id ON article (article_sender_type_id);
CREATE INDEX article_article_type_id ON article (article_type_id);
CREATE INDEX article_message_id ON article (a_message_id);
CREATE INDEX article_ticket_id ON article (ticket_id);
-- ----------------------------------------------------------
--  create table article_plain
-- ----------------------------------------------------------
CREATE TABLE article_plain (
    id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0) NOT NULL,
    body CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE article_plain ADD CONSTRAINT PK_article_plain PRIMARY KEY (id);
DROP SEQUENCE SE_article_plain;
CREATE SEQUENCE SE_article_plain;
CREATE OR REPLACE TRIGGER SE_article_plain_t
before insert on article_plain
for each row
begin
    select SE_article_plain.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_article_plain_change_by ON article_plain (change_by);
CREATE INDEX FK_article_plain_create_by ON article_plain (create_by);
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE article_attachment ADD CONSTRAINT PK_article_attachment PRIMARY KEY (id);
DROP SEQUENCE SE_article_attachment;
CREATE SEQUENCE SE_article_attachment;
CREATE OR REPLACE TRIGGER SE_article_attachment_t
before insert on article_attachment
for each row
begin
    select SE_article_attachment.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_article_attachment_change1e ON article_attachment (change_by);
CREATE INDEX FK_article_attachment_create01 ON article_attachment (create_by);
CREATE INDEX article_attachment_article_id ON article_attachment (article_id);
-- ----------------------------------------------------------
--  create table standard_response
-- ----------------------------------------------------------
CREATE TABLE standard_response (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (80) NOT NULL,
    text CLOB,
    comments VARCHAR2 (100),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT standard_response_name UNIQUE (name)
);
ALTER TABLE standard_response ADD CONSTRAINT PK_standard_response PRIMARY KEY (id);
DROP SEQUENCE SE_standard_response;
CREATE SEQUENCE SE_standard_response;
CREATE OR REPLACE TRIGGER SE_standard_response_t
before insert on standard_response
for each row
begin
    select SE_standard_response.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_standard_response_change_by ON standard_response (change_by);
CREATE INDEX FK_standard_response_create_by ON standard_response (create_by);
CREATE INDEX FK_standard_response_valid_id ON standard_response (valid_id);
-- ----------------------------------------------------------
--  create table queue_standard_response
-- ----------------------------------------------------------
CREATE TABLE queue_standard_response (
    queue_id NUMBER (12, 0) NOT NULL,
    standard_response_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_queue_standard_response_c24 ON queue_standard_response (change_by);
CREATE INDEX FK_queue_standard_response_c28 ON queue_standard_response (create_by);
CREATE INDEX FK_queue_standard_response_q92 ON queue_standard_response (queue_id);
CREATE INDEX FK_queue_standard_response_s15 ON queue_standard_response (standard_response_id);
-- ----------------------------------------------------------
--  create table standard_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_attachment (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (150) NOT NULL,
    content_type VARCHAR2 (150) NOT NULL,
    content CLOB NOT NULL,
    filename VARCHAR2 (250) NOT NULL,
    comments VARCHAR2 (200),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT standard_attachment_name UNIQUE (name)
);
ALTER TABLE standard_attachment ADD CONSTRAINT PK_standard_attachment PRIMARY KEY (id);
DROP SEQUENCE SE_standard_attachment;
CREATE SEQUENCE SE_standard_attachment;
CREATE OR REPLACE TRIGGER SE_standard_attachment_t
before insert on standard_attachment
for each row
begin
    select SE_standard_attachment.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_standard_attachment_chang1b ON standard_attachment (change_by);
CREATE INDEX FK_standard_attachment_creat8b ON standard_attachment (create_by);
CREATE INDEX FK_standard_attachment_validfe ON standard_attachment (valid_id);
-- ----------------------------------------------------------
--  create table standard_response_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_response_attachment (
    id NUMBER (12, 0) NOT NULL,
    standard_attachment_id NUMBER (12, 0) NOT NULL,
    standard_response_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE standard_response_attachment ADD CONSTRAINT PK_standard_response_attachm02 PRIMARY KEY (id);
DROP SEQUENCE SE_standard_response_attace7;
CREATE SEQUENCE SE_standard_response_attace7;
CREATE OR REPLACE TRIGGER SE_standard_response_attace7_t
before insert on standard_response_attachment
for each row
begin
    select SE_standard_response_attace7.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_standard_response_attachmeb ON standard_response_attachment (change_by);
CREATE INDEX FK_standard_response_attachmf2 ON standard_response_attachment (create_by);
CREATE INDEX FK_standard_response_attachmce ON standard_response_attachment (standard_attachment_id);
CREATE INDEX FK_standard_response_attachmea ON standard_response_attachment (standard_response_id);
-- ----------------------------------------------------------
--  create table auto_response_type
-- ----------------------------------------------------------
CREATE TABLE auto_response_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    comments VARCHAR2 (200),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT auto_response_type_name UNIQUE (name)
);
ALTER TABLE auto_response_type ADD CONSTRAINT PK_auto_response_type PRIMARY KEY (id);
DROP SEQUENCE SE_auto_response_type;
CREATE SEQUENCE SE_auto_response_type;
CREATE OR REPLACE TRIGGER SE_auto_response_type_t
before insert on auto_response_type
for each row
begin
    select SE_auto_response_type.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_auto_response_type_changeec ON auto_response_type (change_by);
CREATE INDEX FK_auto_response_type_created6 ON auto_response_type (create_by);
CREATE INDEX FK_auto_response_type_valid_id ON auto_response_type (valid_id);
-- ----------------------------------------------------------
--  create table auto_response
-- ----------------------------------------------------------
CREATE TABLE auto_response (
    id NUMBER (12, 0) NOT NULL,
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT auto_response_name UNIQUE (name)
);
ALTER TABLE auto_response ADD CONSTRAINT PK_auto_response PRIMARY KEY (id);
DROP SEQUENCE SE_auto_response;
CREATE SEQUENCE SE_auto_response;
CREATE OR REPLACE TRIGGER SE_auto_response_t
before insert on auto_response
for each row
begin
    select SE_auto_response.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_auto_response_change_by ON auto_response (change_by);
CREATE INDEX FK_auto_response_create_by ON auto_response (create_by);
CREATE INDEX FK_auto_response_system_addr26 ON auto_response (system_address_id);
CREATE INDEX FK_auto_response_type_id ON auto_response (type_id);
CREATE INDEX FK_auto_response_valid_id ON auto_response (valid_id);
-- ----------------------------------------------------------
--  create table queue_auto_response
-- ----------------------------------------------------------
CREATE TABLE queue_auto_response (
    id NUMBER (12, 0) NOT NULL,
    queue_id NUMBER (12, 0) NOT NULL,
    auto_response_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE queue_auto_response ADD CONSTRAINT PK_queue_auto_response PRIMARY KEY (id);
DROP SEQUENCE SE_queue_auto_response;
CREATE SEQUENCE SE_queue_auto_response;
CREATE OR REPLACE TRIGGER SE_queue_auto_response_t
before insert on queue_auto_response
for each row
begin
    select SE_queue_auto_response.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_queue_auto_response_auto_3d ON queue_auto_response (auto_response_id);
CREATE INDEX FK_queue_auto_response_changc3 ON queue_auto_response (change_by);
CREATE INDEX FK_queue_auto_response_creat75 ON queue_auto_response (create_by);
CREATE INDEX FK_queue_auto_response_queue7a ON queue_auto_response (queue_id);
-- ----------------------------------------------------------
--  create table time_accounting
-- ----------------------------------------------------------
CREATE TABLE time_accounting (
    id NUMBER (20, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0),
    time_unit DECIMAL (10,2) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE time_accounting ADD CONSTRAINT PK_time_accounting PRIMARY KEY (id);
DROP SEQUENCE SE_time_accounting;
CREATE SEQUENCE SE_time_accounting;
CREATE OR REPLACE TRIGGER SE_time_accounting_t
before insert on time_accounting
for each row
begin
    select SE_time_accounting.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_time_accounting_article_id ON time_accounting (article_id);
CREATE INDEX FK_time_accounting_change_by ON time_accounting (change_by);
CREATE INDEX FK_time_accounting_create_by ON time_accounting (create_by);
CREATE INDEX time_accounting_ticket_id ON time_accounting (ticket_id);
-- ----------------------------------------------------------
--  create table ticket_watcher
-- ----------------------------------------------------------
CREATE TABLE ticket_watcher (
    ticket_id NUMBER (20, 0) NOT NULL,
    user_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_ticket_watcher_change_by ON ticket_watcher (change_by);
CREATE INDEX FK_ticket_watcher_create_by ON ticket_watcher (create_by);
CREATE INDEX ticket_watcher_ticket_id ON ticket_watcher (ticket_id);
CREATE INDEX ticket_watcher_user_id ON ticket_watcher (user_id);
-- ----------------------------------------------------------
--  create table service
-- ----------------------------------------------------------
CREATE TABLE service (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (200),
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT service_name UNIQUE (name)
);
ALTER TABLE service ADD CONSTRAINT PK_service PRIMARY KEY (id);
DROP SEQUENCE SE_service;
CREATE SEQUENCE SE_service;
CREATE OR REPLACE TRIGGER SE_service_t
before insert on service
for each row
begin
    select SE_service.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_service_change_by ON service (change_by);
CREATE INDEX FK_service_create_by ON service (create_by);
-- ----------------------------------------------------------
--  create table service_customer_user
-- ----------------------------------------------------------
CREATE TABLE service_customer_user (
    customer_user_login VARCHAR2 (100) NOT NULL,
    service_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_service_customer_user_creb7 ON service_customer_user (create_by);
CREATE INDEX service_customer_user_custom7e ON service_customer_user (customer_user_login);
CREATE INDEX service_customer_user_servic99 ON service_customer_user (service_id);
-- ----------------------------------------------------------
--  create table sla
-- ----------------------------------------------------------
CREATE TABLE sla (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    calendar_name VARCHAR2 (100),
    first_response_time NUMBER (12, 0) NOT NULL,
    first_response_notify NUMBER (5, 0),
    update_time NUMBER (12, 0) NOT NULL,
    update_notify NUMBER (5, 0),
    solution_time NUMBER (12, 0) NOT NULL,
    solution_notify NUMBER (5, 0),
    valid_id NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (200),
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT sla_name UNIQUE (name)
);
ALTER TABLE sla ADD CONSTRAINT PK_sla PRIMARY KEY (id);
DROP SEQUENCE SE_sla;
CREATE SEQUENCE SE_sla;
CREATE OR REPLACE TRIGGER SE_sla_t
before insert on sla
for each row
begin
    select SE_sla.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_sla_change_by ON sla (change_by);
CREATE INDEX FK_sla_create_by ON sla (create_by);
-- ----------------------------------------------------------
--  create table service_sla
-- ----------------------------------------------------------
CREATE TABLE service_sla (
    service_id NUMBER (12, 0) NOT NULL,
    sla_id NUMBER (12, 0) NOT NULL,
    CONSTRAINT service_sla_service_sla UNIQUE (service_id, sla_id)
);
CREATE INDEX FK_service_sla_service_id ON service_sla (service_id);
CREATE INDEX FK_service_sla_sla_id ON service_sla (sla_id);
-- ----------------------------------------------------------
--  create table sessions
-- ----------------------------------------------------------
CREATE TABLE sessions (
    session_id VARCHAR2 (150) NOT NULL,
    session_value CLOB NOT NULL
);
ALTER TABLE sessions ADD CONSTRAINT PK_sessions PRIMARY KEY (session_id);
-- ----------------------------------------------------------
--  create table ticket_index
-- ----------------------------------------------------------
CREATE TABLE ticket_index (
    ticket_id NUMBER (20, 0) NOT NULL,
    queue_id NUMBER (12, 0) NOT NULL,
    queue VARCHAR2 (70) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    s_lock VARCHAR2 (70) NOT NULL,
    s_state VARCHAR2 (70) NOT NULL,
    create_time_unix NUMBER (20, 0) NOT NULL
);
CREATE INDEX ticket_index_group_id ON ticket_index (group_id);
CREATE INDEX ticket_index_queue_id ON ticket_index (queue_id);
CREATE INDEX ticket_index_ticket_id ON ticket_index (ticket_id);
-- ----------------------------------------------------------
--  create table ticket_lock_index
-- ----------------------------------------------------------
CREATE TABLE ticket_lock_index (
    ticket_id NUMBER (20, 0) NOT NULL
);
CREATE INDEX ticket_lock_index_ticket_id ON ticket_lock_index (ticket_id);
-- ----------------------------------------------------------
--  create table customer_user
-- ----------------------------------------------------------
CREATE TABLE customer_user (
    id NUMBER (12, 0) NOT NULL,
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT customer_user_login UNIQUE (login)
);
ALTER TABLE customer_user ADD CONSTRAINT PK_customer_user PRIMARY KEY (id);
DROP SEQUENCE SE_customer_user;
CREATE SEQUENCE SE_customer_user;
CREATE OR REPLACE TRIGGER SE_customer_user_t
before insert on customer_user
for each row
begin
    select SE_customer_user.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_customer_user_change_by ON customer_user (change_by);
CREATE INDEX FK_customer_user_create_by ON customer_user (create_by);
CREATE INDEX FK_customer_user_valid_id ON customer_user (valid_id);
-- ----------------------------------------------------------
--  create table customer_preferences
-- ----------------------------------------------------------
CREATE TABLE customer_preferences (
    user_id VARCHAR2 (250) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250)
);
CREATE INDEX customer_preferences_user_id ON customer_preferences (user_id);
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
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT customer_company_name UNIQUE (name)
);
ALTER TABLE customer_company ADD CONSTRAINT PK_customer_company PRIMARY KEY (customer_id);
-- ----------------------------------------------------------
--  create table ticket_loop_protection
-- ----------------------------------------------------------
CREATE TABLE ticket_loop_protection (
    sent_to VARCHAR2 (250) NOT NULL,
    sent_date VARCHAR2 (150) NOT NULL
);
CREATE INDEX ticket_loop_protection_sent_37 ON ticket_loop_protection (sent_date);
CREATE INDEX ticket_loop_protection_sent_to ON ticket_loop_protection (sent_to);
-- ----------------------------------------------------------
--  create table mail_account
-- ----------------------------------------------------------
CREATE TABLE mail_account (
    id NUMBER (12, 0) NOT NULL,
    login VARCHAR2 (200) NOT NULL,
    pw VARCHAR2 (200) NOT NULL,
    host VARCHAR2 (200) NOT NULL,
    account_type VARCHAR2 (20) NOT NULL,
    queue_id NUMBER (12, 0) NOT NULL,
    trusted NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (250),
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE mail_account ADD CONSTRAINT PK_mail_account PRIMARY KEY (id);
DROP SEQUENCE SE_mail_account;
CREATE SEQUENCE SE_mail_account;
CREATE OR REPLACE TRIGGER SE_mail_account_t
before insert on mail_account
for each row
begin
    select SE_mail_account.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_mail_account_change_by ON mail_account (change_by);
CREATE INDEX FK_mail_account_create_by ON mail_account (create_by);
CREATE INDEX FK_mail_account_valid_id ON mail_account (valid_id);
-- ----------------------------------------------------------
--  create table postmaster_filter
-- ----------------------------------------------------------
CREATE TABLE postmaster_filter (
    f_name VARCHAR2 (200) NOT NULL,
    f_type VARCHAR2 (20) NOT NULL,
    f_key VARCHAR2 (200) NOT NULL,
    f_value VARCHAR2 (200) NOT NULL
);
CREATE INDEX postmaster_filter_f_name ON postmaster_filter (f_name);
-- ----------------------------------------------------------
--  create table generic_agent_jobs
-- ----------------------------------------------------------
CREATE TABLE generic_agent_jobs (
    job_name VARCHAR2 (200) NOT NULL,
    job_key VARCHAR2 (200) NOT NULL,
    job_value VARCHAR2 (200)
);
CREATE INDEX generic_agent_job_name ON generic_agent_jobs (job_name);
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
CREATE INDEX search_profile_login ON search_profile (login);
CREATE INDEX search_profile_profile_name ON search_profile (profile_name);
-- ----------------------------------------------------------
--  create table process_id
-- ----------------------------------------------------------
CREATE TABLE process_id (
    process_name VARCHAR2 (200) NOT NULL,
    process_id VARCHAR2 (200) NOT NULL,
    process_host VARCHAR2 (200) NOT NULL,
    process_create NUMBER (12, 0) NOT NULL
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
    id NUMBER (12, 0) NOT NULL,
    notification_type VARCHAR2 (200) NOT NULL,
    notification_charset VARCHAR2 (60) NOT NULL,
    notification_language VARCHAR2 (60) NOT NULL,
    subject VARCHAR2 (200) NOT NULL,
    text VARCHAR2 (4000) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE notifications ADD CONSTRAINT PK_notifications PRIMARY KEY (id);
DROP SEQUENCE SE_notifications;
CREATE SEQUENCE SE_notifications;
CREATE OR REPLACE TRIGGER SE_notifications_t
before insert on notifications
for each row
begin
    select SE_notifications.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_notifications_change_by ON notifications (change_by);
CREATE INDEX FK_notifications_create_by ON notifications (create_by);
-- ----------------------------------------------------------
--  create table xml_storage
-- ----------------------------------------------------------
CREATE TABLE xml_storage (
    xml_type VARCHAR2 (200) NOT NULL,
    xml_key VARCHAR2 (250) NOT NULL,
    xml_content_key VARCHAR2 (250) NOT NULL,
    xml_content_value CLOB
);
CREATE INDEX xml_storage_key_type ON xml_storage (xml_key, xml_type);
CREATE INDEX xml_storage_xml_content_key ON xml_storage (xml_content_key);
-- ----------------------------------------------------------
--  create table package_repository
-- ----------------------------------------------------------
CREATE TABLE package_repository (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (250) NOT NULL,
    version VARCHAR2 (250) NOT NULL,
    vendor VARCHAR2 (250) NOT NULL,
    install_status VARCHAR2 (250) NOT NULL,
    filename VARCHAR2 (250),
    content_size VARCHAR2 (30),
    content_type VARCHAR2 (250),
    content CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE package_repository ADD CONSTRAINT PK_package_repository PRIMARY KEY (id);
DROP SEQUENCE SE_package_repository;
CREATE SEQUENCE SE_package_repository;
CREATE OR REPLACE TRIGGER SE_package_repository_t
before insert on package_repository
for each row
begin
    select SE_package_repository.nextval
    into :new.id
    from dual;
end;
/
--;
CREATE INDEX FK_package_repository_changed7 ON package_repository (change_by);
CREATE INDEX FK_package_repository_create99 ON package_repository (create_by);
