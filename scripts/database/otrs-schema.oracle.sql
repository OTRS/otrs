-- ----------------------------------------------------------
--  driver: oracle, generated: 2009-12-09 12:34:00
-- ----------------------------------------------------------
SET DEFINE OFF;
-- ----------------------------------------------------------
--  create table valid
-- ----------------------------------------------------------
CREATE TABLE valid (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
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
  if :new.id IS NULL then
    select SE_valid.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
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
  if :new.id IS NULL then
    select SE_ticket_priority.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
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
  if :new.id IS NULL then
    select SE_ticket_type.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
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
  if :new.id IS NULL then
    select SE_ticket_lock_type.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_ticket_lock_type_change_by ON ticket_lock_type (change_by);
CREATE INDEX FK_ticket_lock_type_create_by ON ticket_lock_type (create_by);
CREATE INDEX FK_ticket_lock_type_valid_id ON ticket_lock_type (valid_id);
-- ----------------------------------------------------------
--  create table users
-- ----------------------------------------------------------
CREATE TABLE users (
    id NUMBER (12, 0) NOT NULL,
    login VARCHAR2 (200) NOT NULL,
    pw VARCHAR2 (50) NOT NULL,
    title VARCHAR2 (50) NULL,
    first_name VARCHAR2 (100) NOT NULL,
    last_name VARCHAR2 (100) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT users_login UNIQUE (login)
);
ALTER TABLE users ADD CONSTRAINT PK_users PRIMARY KEY (id);
DROP SEQUENCE SE_users;
CREATE SEQUENCE SE_users;
CREATE OR REPLACE TRIGGER SE_users_t
before insert on users
for each row
begin
  if :new.id IS NULL then
    select SE_users.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_users_change_by ON users (change_by);
CREATE INDEX FK_users_create_by ON users (create_by);
CREATE INDEX FK_users_valid_id ON users (valid_id);
-- ----------------------------------------------------------
--  create table user_preferences
-- ----------------------------------------------------------
CREATE TABLE user_preferences (
    user_id NUMBER (12, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250) NULL
);
CREATE INDEX user_preferences_user_id ON user_preferences (user_id);
-- ----------------------------------------------------------
--  create table groups
-- ----------------------------------------------------------
CREATE TABLE groups (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_groups.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_roles.nextval
    into :new.id
    from dual;
  end if;
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
  if :new.id IS NULL then
    select SE_theme.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_ticket_state.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_ticket_state_type.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    text VARCHAR2 (3000) NOT NULL,
    content_type VARCHAR2 (250) NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_salutation.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    text VARCHAR2 (3000) NOT NULL,
    content_type VARCHAR2 (250) NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_signature.nextval
    into :new.id
    from dual;
  end if;
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
    value2 VARCHAR2 (200) NULL,
    value3 VARCHAR2 (200) NULL,
    queue_id NUMBER (12, 0) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_system_address.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_follow_up_possible.nextval
    into :new.id
    from dual;
  end if;
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
    unlock_timeout NUMBER (12, 0) NULL,
    first_response_time NUMBER (12, 0) NULL,
    first_response_notify NUMBER (5, 0) NULL,
    update_time NUMBER (12, 0) NULL,
    update_notify NUMBER (5, 0) NULL,
    solution_time NUMBER (12, 0) NULL,
    solution_notify NUMBER (5, 0) NULL,
    system_address_id NUMBER (5, 0) NOT NULL,
    calendar_name VARCHAR2 (100) NULL,
    default_sign_key VARCHAR2 (100) NULL,
    salutation_id NUMBER (5, 0) NOT NULL,
    signature_id NUMBER (5, 0) NOT NULL,
    follow_up_id NUMBER (5, 0) NOT NULL,
    follow_up_lock NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_queue.nextval
    into :new.id
    from dual;
  end if;
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
    preferences_value VARCHAR2 (250) NULL
);
CREATE INDEX queue_preferences_queue_id ON queue_preferences (queue_id);
-- ----------------------------------------------------------
--  create table ticket
-- ----------------------------------------------------------
CREATE TABLE ticket (
    id NUMBER (20, 0) NOT NULL,
    tn VARCHAR2 (50) NOT NULL,
    title VARCHAR2 (255) NULL,
    queue_id NUMBER (12, 0) NOT NULL,
    ticket_lock_id NUMBER (5, 0) NOT NULL,
    ticket_answered NUMBER (5, 0) NOT NULL,
    type_id NUMBER (5, 0) NULL,
    service_id NUMBER (12, 0) NULL,
    sla_id NUMBER (12, 0) NULL,
    user_id NUMBER (12, 0) NOT NULL,
    responsible_user_id NUMBER (12, 0) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    ticket_priority_id NUMBER (5, 0) NOT NULL,
    ticket_state_id NUMBER (5, 0) NOT NULL,
    group_read NUMBER (5, 0) NULL,
    group_write NUMBER (5, 0) NULL,
    other_read NUMBER (5, 0) NULL,
    other_write NUMBER (5, 0) NULL,
    customer_id VARCHAR2 (150) NULL,
    customer_user_id VARCHAR2 (250) NULL,
    timeout NUMBER (12, 0) NOT NULL,
    until_time NUMBER (12, 0) NOT NULL,
    escalation_time NUMBER (12, 0) NOT NULL,
    escalation_update_time NUMBER (12, 0) NOT NULL,
    escalation_response_time NUMBER (12, 0) NOT NULL,
    escalation_solution_time NUMBER (12, 0) NOT NULL,
    freekey1 VARCHAR2 (80) NULL,
    freetext1 VARCHAR2 (150) NULL,
    freekey2 VARCHAR2 (80) NULL,
    freetext2 VARCHAR2 (150) NULL,
    freekey3 VARCHAR2 (80) NULL,
    freetext3 VARCHAR2 (150) NULL,
    freekey4 VARCHAR2 (80) NULL,
    freetext4 VARCHAR2 (150) NULL,
    freekey5 VARCHAR2 (80) NULL,
    freetext5 VARCHAR2 (150) NULL,
    freekey6 VARCHAR2 (80) NULL,
    freetext6 VARCHAR2 (150) NULL,
    freekey7 VARCHAR2 (80) NULL,
    freetext7 VARCHAR2 (150) NULL,
    freekey8 VARCHAR2 (80) NULL,
    freetext8 VARCHAR2 (150) NULL,
    freekey9 VARCHAR2 (80) NULL,
    freetext9 VARCHAR2 (150) NULL,
    freekey10 VARCHAR2 (80) NULL,
    freetext10 VARCHAR2 (150) NULL,
    freekey11 VARCHAR2 (80) NULL,
    freetext11 VARCHAR2 (150) NULL,
    freekey12 VARCHAR2 (80) NULL,
    freetext12 VARCHAR2 (150) NULL,
    freekey13 VARCHAR2 (80) NULL,
    freetext13 VARCHAR2 (150) NULL,
    freekey14 VARCHAR2 (80) NULL,
    freetext14 VARCHAR2 (150) NULL,
    freekey15 VARCHAR2 (80) NULL,
    freetext15 VARCHAR2 (150) NULL,
    freekey16 VARCHAR2 (80) NULL,
    freetext16 VARCHAR2 (150) NULL,
    freetime1 DATE NULL,
    freetime2 DATE NULL,
    freetime3 DATE NULL,
    freetime4 DATE NULL,
    freetime5 DATE NULL,
    freetime6 DATE NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    archive_flag NUMBER (5, 0) DEFAULT 0 NOT NULL,
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
  if :new.id IS NULL then
    select SE_ticket.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_ticket_change_by ON ticket (change_by);
CREATE INDEX FK_ticket_create_by ON ticket (create_by);
CREATE INDEX FK_ticket_service_id ON ticket (service_id);
CREATE INDEX FK_ticket_sla_id ON ticket (sla_id);
CREATE INDEX FK_ticket_valid_id ON ticket (valid_id);
CREATE INDEX ticket_answered ON ticket (ticket_answered);
CREATE INDEX ticket_archive_flag ON ticket (archive_flag);
CREATE INDEX ticket_create_time ON ticket (create_time);
CREATE INDEX ticket_create_time_unix ON ticket (create_time_unix);
CREATE INDEX ticket_customer_id ON ticket (customer_id);
CREATE INDEX ticket_customer_user_id ON ticket (customer_user_id);
CREATE INDEX ticket_escalation_response_t29 ON ticket (escalation_response_time);
CREATE INDEX ticket_escalation_solution_td9 ON ticket (escalation_solution_time);
CREATE INDEX ticket_escalation_time ON ticket (escalation_time);
CREATE INDEX ticket_escalation_update_time ON ticket (escalation_update_time);
CREATE INDEX ticket_queue_id ON ticket (queue_id);
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id, group_id);
CREATE INDEX ticket_responsible_user_id ON ticket (responsible_user_id);
CREATE INDEX ticket_ticket_lock_id ON ticket (ticket_lock_id);
CREATE INDEX ticket_ticket_priority_id ON ticket (ticket_priority_id);
CREATE INDEX ticket_ticket_state_id ON ticket (ticket_state_id);
CREATE INDEX ticket_timeout ON ticket (timeout);
CREATE INDEX ticket_title ON ticket (title);
CREATE INDEX ticket_type_id ON ticket (type_id);
CREATE INDEX ticket_until_time ON ticket (until_time);
CREATE INDEX ticket_user_id ON ticket (user_id);
-- ----------------------------------------------------------
--  create table link_type
-- ----------------------------------------------------------
CREATE TABLE link_type (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT link_type_name UNIQUE (name)
);
ALTER TABLE link_type ADD CONSTRAINT PK_link_type PRIMARY KEY (id);
DROP SEQUENCE SE_link_type;
CREATE SEQUENCE SE_link_type;
CREATE OR REPLACE TRIGGER SE_link_type_t
before insert on link_type
for each row
begin
  if :new.id IS NULL then
    select SE_link_type.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_link_type_change_by ON link_type (change_by);
CREATE INDEX FK_link_type_create_by ON link_type (create_by);
CREATE INDEX FK_link_type_valid_id ON link_type (valid_id);
-- ----------------------------------------------------------
--  create table link_state
-- ----------------------------------------------------------
CREATE TABLE link_state (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (50) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT link_state_name UNIQUE (name)
);
ALTER TABLE link_state ADD CONSTRAINT PK_link_state PRIMARY KEY (id);
DROP SEQUENCE SE_link_state;
CREATE SEQUENCE SE_link_state;
CREATE OR REPLACE TRIGGER SE_link_state_t
before insert on link_state
for each row
begin
  if :new.id IS NULL then
    select SE_link_state.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_link_state_change_by ON link_state (change_by);
CREATE INDEX FK_link_state_create_by ON link_state (create_by);
CREATE INDEX FK_link_state_valid_id ON link_state (valid_id);
-- ----------------------------------------------------------
--  create table link_object
-- ----------------------------------------------------------
CREATE TABLE link_object (
    id NUMBER (5, 0) NOT NULL,
    name VARCHAR2 (100) NOT NULL,
    CONSTRAINT link_object_name UNIQUE (name)
);
ALTER TABLE link_object ADD CONSTRAINT PK_link_object PRIMARY KEY (id);
DROP SEQUENCE SE_link_object;
CREATE SEQUENCE SE_link_object;
CREATE OR REPLACE TRIGGER SE_link_object_t
before insert on link_object
for each row
begin
  if :new.id IS NULL then
    select SE_link_object.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
-- ----------------------------------------------------------
--  create table link_relation
-- ----------------------------------------------------------
CREATE TABLE link_relation (
    source_object_id NUMBER (5, 0) NOT NULL,
    source_key VARCHAR2 (50) NOT NULL,
    target_object_id NUMBER (5, 0) NOT NULL,
    target_key VARCHAR2 (50) NOT NULL,
    type_id NUMBER (5, 0) NOT NULL,
    state_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT link_relation_view UNIQUE (source_object_id, source_key, target_object_id, target_key, type_id)
);
CREATE INDEX FK_link_relation_create_by ON link_relation (create_by);
CREATE INDEX FK_link_relation_source_obje3c ON link_relation (source_object_id);
CREATE INDEX FK_link_relation_state_id ON link_relation (state_id);
CREATE INDEX FK_link_relation_target_obje99 ON link_relation (target_object_id);
CREATE INDEX FK_link_relation_type_id ON link_relation (type_id);
-- ----------------------------------------------------------
--  create table ticket_history
-- ----------------------------------------------------------
CREATE TABLE ticket_history (
    id NUMBER (20, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    history_type_id NUMBER (5, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_id NUMBER (20, 0) NULL,
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
  if :new.id IS NULL then
    select SE_ticket_history.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_ticket_history_type.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_article_type.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_article_sender_type.nextval
    into :new.id
    from dual;
  end if;
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
    a_from VARCHAR2 (3800) NULL,
    a_reply_to VARCHAR2 (500) NULL,
    a_to VARCHAR2 (3800) NULL,
    a_cc VARCHAR2 (3800) NULL,
    a_subject VARCHAR2 (3800) NULL,
    a_message_id VARCHAR2 (3800) NULL,
    a_in_reply_to VARCHAR2 (3800) NULL,
    a_references VARCHAR2 (3800) NULL,
    a_content_type VARCHAR2 (250) NULL,
    a_body CLOB NOT NULL,
    incoming_time NUMBER (12, 0) NOT NULL,
    content_path VARCHAR2 (250) NULL,
    a_freekey1 VARCHAR2 (250) NULL,
    a_freetext1 VARCHAR2 (250) NULL,
    a_freekey2 VARCHAR2 (250) NULL,
    a_freetext2 VARCHAR2 (250) NULL,
    a_freekey3 VARCHAR2 (250) NULL,
    a_freetext3 VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_article.nextval
    into :new.id
    from dual;
  end if;
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
--  create table article_search
-- ----------------------------------------------------------
CREATE TABLE article_search (
    id NUMBER (20, 0) NOT NULL,
    ticket_id NUMBER (20, 0) NOT NULL,
    article_type_id NUMBER (5, 0) NOT NULL,
    article_sender_type_id NUMBER (5, 0) NOT NULL,
    a_from VARCHAR2 (3800) NULL,
    a_to VARCHAR2 (3800) NULL,
    a_cc VARCHAR2 (3800) NULL,
    a_subject VARCHAR2 (3800) NULL,
    a_message_id VARCHAR2 (3800) NULL,
    a_body CLOB NOT NULL,
    incoming_time NUMBER (12, 0) NOT NULL,
    a_freekey1 VARCHAR2 (250) NULL,
    a_freetext1 VARCHAR2 (250) NULL,
    a_freekey2 VARCHAR2 (250) NULL,
    a_freetext2 VARCHAR2 (250) NULL,
    a_freekey3 VARCHAR2 (250) NULL,
    a_freetext3 VARCHAR2 (250) NULL
);
ALTER TABLE article_search ADD CONSTRAINT PK_article_search PRIMARY KEY (id);
CREATE INDEX article_search_article_sendec7 ON article_search (article_sender_type_id);
CREATE INDEX article_search_article_type_id ON article_search (article_type_id);
CREATE INDEX article_search_message_id ON article_search (a_message_id);
CREATE INDEX article_search_ticket_id ON article_search (ticket_id);
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
  if :new.id IS NULL then
    select SE_article_plain.nextval
    into :new.id
    from dual;
  end if;
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
    filename VARCHAR2 (250) NULL,
    content_size VARCHAR2 (30) NULL,
    content_type VARCHAR2 (450) NULL,
    content_id VARCHAR2 (250) NULL,
    content_alternative VARCHAR2 (50) NULL,
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
  if :new.id IS NULL then
    select SE_article_attachment.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    text CLOB NULL,
    content_type VARCHAR2 (250) NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_standard_response.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    content_type VARCHAR2 (250) NOT NULL,
    content CLOB NOT NULL,
    filename VARCHAR2 (250) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_standard_attachment.nextval
    into :new.id
    from dual;
  end if;
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
  if :new.id IS NULL then
    select SE_standard_response_attace7.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_auto_response_type.nextval
    into :new.id
    from dual;
  end if;
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
    name VARCHAR2 (200) NOT NULL,
    text0 CLOB NULL,
    text1 CLOB NULL,
    text2 CLOB NULL,
    type_id NUMBER (5, 0) NOT NULL,
    system_address_id NUMBER (5, 0) NOT NULL,
    charset VARCHAR2 (80) NOT NULL,
    content_type VARCHAR2 (250) NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_auto_response.nextval
    into :new.id
    from dual;
  end if;
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
  if :new.id IS NULL then
    select SE_queue_auto_response.nextval
    into :new.id
    from dual;
  end if;
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
    article_id NUMBER (20, 0) NULL,
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
  if :new.id IS NULL then
    select SE_time_accounting.nextval
    into :new.id
    from dual;
  end if;
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
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_service.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_service_change_by ON service (change_by);
CREATE INDEX FK_service_create_by ON service (create_by);
-- ----------------------------------------------------------
--  create table service_preferences
-- ----------------------------------------------------------
CREATE TABLE service_preferences (
    service_id NUMBER (12, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250) NULL
);
CREATE INDEX service_preferences_service_id ON service_preferences (service_id);
-- ----------------------------------------------------------
--  create table service_customer_user
-- ----------------------------------------------------------
CREATE TABLE service_customer_user (
    customer_user_login VARCHAR2 (200) NOT NULL,
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
    calendar_name VARCHAR2 (100) NULL,
    first_response_time NUMBER (12, 0) NOT NULL,
    first_response_notify NUMBER (5, 0) NULL,
    update_time NUMBER (12, 0) NOT NULL,
    update_notify NUMBER (5, 0) NULL,
    solution_time NUMBER (12, 0) NOT NULL,
    solution_notify NUMBER (5, 0) NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_sla.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_sla_change_by ON sla (change_by);
CREATE INDEX FK_sla_create_by ON sla (create_by);
-- ----------------------------------------------------------
--  create table sla_preferences
-- ----------------------------------------------------------
CREATE TABLE sla_preferences (
    sla_id NUMBER (12, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (250) NULL
);
CREATE INDEX sla_preferences_sla_id ON sla_preferences (sla_id);
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
    login VARCHAR2 (200) NOT NULL,
    email VARCHAR2 (150) NOT NULL,
    customer_id VARCHAR2 (150) NOT NULL,
    pw VARCHAR2 (50) NULL,
    title VARCHAR2 (50) NULL,
    first_name VARCHAR2 (100) NOT NULL,
    last_name VARCHAR2 (100) NOT NULL,
    phone VARCHAR2 (150) NULL,
    fax VARCHAR2 (150) NULL,
    mobile VARCHAR2 (150) NULL,
    street VARCHAR2 (150) NULL,
    zip VARCHAR2 (200) NULL,
    city VARCHAR2 (200) NULL,
    country VARCHAR2 (200) NULL,
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_customer_user.nextval
    into :new.id
    from dual;
  end if;
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
    preferences_value VARCHAR2 (250) NULL
);
CREATE INDEX customer_preferences_user_id ON customer_preferences (user_id);
-- ----------------------------------------------------------
--  create table customer_company
-- ----------------------------------------------------------
CREATE TABLE customer_company (
    customer_id VARCHAR2 (150) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    street VARCHAR2 (200) NULL,
    zip VARCHAR2 (200) NULL,
    city VARCHAR2 (200) NULL,
    country VARCHAR2 (200) NULL,
    url VARCHAR2 (200) NULL,
    comments VARCHAR2 (250) NULL,
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
    comments VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_mail_account.nextval
    into :new.id
    from dual;
  end if;
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
    f_stop NUMBER (5, 0) NULL,
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
    job_value VARCHAR2 (200) NULL
);
CREATE INDEX generic_agent_jobs_job_name ON generic_agent_jobs (job_name);
-- ----------------------------------------------------------
--  create table search_profile
-- ----------------------------------------------------------
CREATE TABLE search_profile (
    login VARCHAR2 (200) NOT NULL,
    profile_name VARCHAR2 (200) NOT NULL,
    profile_type VARCHAR2 (30) NOT NULL,
    profile_key VARCHAR2 (200) NOT NULL,
    profile_value VARCHAR2 (200) NULL
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
    form_id VARCHAR2 (250) NULL,
    filename VARCHAR2 (250) NULL,
    content_id VARCHAR2 (250) NULL,
    content_size VARCHAR2 (30) NULL,
    content_type VARCHAR2 (250) NULL,
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
    content_type VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_notifications.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_notifications_change_by ON notifications (change_by);
CREATE INDEX FK_notifications_create_by ON notifications (create_by);
-- ----------------------------------------------------------
--  create table notification_event
-- ----------------------------------------------------------
CREATE TABLE notification_event (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    subject VARCHAR2 (200) NOT NULL,
    text VARCHAR2 (4000) NOT NULL,
    content_type VARCHAR2 (250) NOT NULL,
    charset VARCHAR2 (100) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    comments VARCHAR2 (250) NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT notification_event_name UNIQUE (name)
);
ALTER TABLE notification_event ADD CONSTRAINT PK_notification_event PRIMARY KEY (id);
DROP SEQUENCE SE_notification_event;
CREATE SEQUENCE SE_notification_event;
CREATE OR REPLACE TRIGGER SE_notification_event_t
before insert on notification_event
for each row
begin
  if :new.id IS NULL then
    select SE_notification_event.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_notification_event_changeaf ON notification_event (change_by);
CREATE INDEX FK_notification_event_create9d ON notification_event (create_by);
CREATE INDEX FK_notification_event_valid_id ON notification_event (valid_id);
-- ----------------------------------------------------------
--  create table notification_event_item
-- ----------------------------------------------------------
CREATE TABLE notification_event_item (
    notification_id NUMBER (12, 0) NOT NULL,
    event_key VARCHAR2 (200) NOT NULL,
    event_value VARCHAR2 (200) NOT NULL
);
CREATE INDEX notification_event_item_even64 ON notification_event_item (event_key);
CREATE INDEX notification_event_item_evene4 ON notification_event_item (event_value);
CREATE INDEX notification_event_item_notidc ON notification_event_item (notification_id);
-- ----------------------------------------------------------
--  create table xml_storage
-- ----------------------------------------------------------
CREATE TABLE xml_storage (
    xml_type VARCHAR2 (200) NOT NULL,
    xml_key VARCHAR2 (250) NOT NULL,
    xml_content_key VARCHAR2 (250) NOT NULL,
    xml_content_value CLOB NULL
);
CREATE INDEX xml_storage_key_type ON xml_storage (xml_key, xml_type);
CREATE INDEX xml_storage_xml_content_key ON xml_storage (xml_content_key);
-- ----------------------------------------------------------
--  create table virtual_fs
-- ----------------------------------------------------------
CREATE TABLE virtual_fs (
    id NUMBER (20, 0) NOT NULL,
    filename VARCHAR2 (350) NOT NULL,
    backend VARCHAR2 (60) NOT NULL,
    backend_key VARCHAR2 (160) NOT NULL,
    create_time DATE NOT NULL
);
ALTER TABLE virtual_fs ADD CONSTRAINT PK_virtual_fs PRIMARY KEY (id);
DROP SEQUENCE SE_virtual_fs;
CREATE SEQUENCE SE_virtual_fs;
CREATE OR REPLACE TRIGGER SE_virtual_fs_t
before insert on virtual_fs
for each row
begin
  if :new.id IS NULL then
    select SE_virtual_fs.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX virtual_fs_backend ON virtual_fs (backend);
CREATE INDEX virtual_fs_filename ON virtual_fs (filename);
-- ----------------------------------------------------------
--  create table virtual_fs_preferences
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_preferences (
    virtual_fs_id NUMBER (20, 0) NOT NULL,
    preferences_key VARCHAR2 (150) NOT NULL,
    preferences_value VARCHAR2 (350) NULL
);
CREATE INDEX virtual_fs_preferences_virtuf6 ON virtual_fs_preferences (virtual_fs_id);
-- ----------------------------------------------------------
--  create table virtual_fs_db
-- ----------------------------------------------------------
CREATE TABLE virtual_fs_db (
    id NUMBER (20, 0) NOT NULL,
    filename VARCHAR2 (350) NOT NULL,
    content CLOB NOT NULL,
    create_time DATE NOT NULL
);
ALTER TABLE virtual_fs_db ADD CONSTRAINT PK_virtual_fs_db PRIMARY KEY (id);
DROP SEQUENCE SE_virtual_fs_db;
CREATE SEQUENCE SE_virtual_fs_db;
CREATE OR REPLACE TRIGGER SE_virtual_fs_db_t
before insert on virtual_fs_db
for each row
begin
  if :new.id IS NULL then
    select SE_virtual_fs_db.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX virtual_fs_db_filename ON virtual_fs_db (filename);
-- ----------------------------------------------------------
--  create table package_repository
-- ----------------------------------------------------------
CREATE TABLE package_repository (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    version VARCHAR2 (250) NOT NULL,
    vendor VARCHAR2 (250) NOT NULL,
    install_status VARCHAR2 (250) NOT NULL,
    filename VARCHAR2 (250) NULL,
    content_size VARCHAR2 (30) NULL,
    content_type VARCHAR2 (250) NULL,
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
  if :new.id IS NULL then
    select SE_package_repository.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_package_repository_changed7 ON package_repository (change_by);
CREATE INDEX FK_package_repository_create99 ON package_repository (create_by);
