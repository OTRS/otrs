-- ----------------------------------------------------------
--  driver: oracle
-- ----------------------------------------------------------
SET DEFINE OFF;
SET SQLBLANKLINES ON;
-- ----------------------------------------------------------
--  create table acl
-- ----------------------------------------------------------
CREATE TABLE acl (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    comments VARCHAR2 (250) NULL,
    description VARCHAR2 (250) NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    stop_after_match NUMBER (5, 0) NULL,
    config_match CLOB NULL,
    config_change CLOB NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT acl_name UNIQUE (name)
);
ALTER TABLE acl ADD CONSTRAINT PK_acl PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_ACL';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_ACL';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_ACL
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_ACL_t
before insert on acl
for each row
begin
  if :new.id IS NULL then
    select SE_ACL.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_acl_change_by ON acl (change_by);
CREATE INDEX FK_acl_create_by ON acl (create_by);
CREATE INDEX FK_acl_valid_id ON acl (valid_id);
-- ----------------------------------------------------------
--  create table acl_sync
-- ----------------------------------------------------------
CREATE TABLE acl_sync (
    acl_id VARCHAR2 (200) NOT NULL,
    sync_state VARCHAR2 (30) NOT NULL,
    create_time DATE NOT NULL,
    change_time DATE NOT NULL
);
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_VALID';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_VALID';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_VALID
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_VALID_t
before insert on valid
for each row
begin
  if :new.id IS NULL then
    select SE_VALID.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_valid_change_by ON valid (change_by);
CREATE INDEX FK_valid_create_by ON valid (create_by);
-- ----------------------------------------------------------
--  create table users
-- ----------------------------------------------------------
CREATE TABLE users (
    id NUMBER (12, 0) NOT NULL,
    login VARCHAR2 (200) NOT NULL,
    pw VARCHAR2 (64) NOT NULL,
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_USERS';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_USERS';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_USERS
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_USERS_t
before insert on users
for each row
begin
  if :new.id IS NULL then
    select SE_USERS.nextval
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
    preferences_value CLOB NULL
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_GROUPS';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_GROUPS';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_GROUPS
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_GROUPS_t
before insert on groups
for each row
begin
  if :new.id IS NULL then
    select SE_GROUPS.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_ROLES';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_ROLES';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_ROLES
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_ROLES_t
before insert on roles
for each row
begin
  if :new.id IS NULL then
    select SE_ROLES.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_SALUTATION';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_SALUTATION';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_SALUTATION
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_SALUTATION_t
before insert on salutation
for each row
begin
  if :new.id IS NULL then
    select SE_SALUTATION.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_SIGNATURE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_SIGNATURE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_SIGNATURE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_SIGNATURE_t
before insert on signature
for each row
begin
  if :new.id IS NULL then
    select SE_SIGNATURE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_SYSTEM_ADDRESS';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_SYSTEM_ADDRESS';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_SYSTEM_ADDRESS
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_SYSTEM_ADDRESS_t
before insert on system_address
for each row
begin
  if :new.id IS NULL then
    select SE_SYSTEM_ADDRESS.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_FOLLOW_UP_POSSIBLE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_FOLLOW_UP_POSSIBLE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_FOLLOW_UP_POSSIBLE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_FOLLOW_UP_POSSIBLE_t
before insert on follow_up_possible
for each row
begin
  if :new.id IS NULL then
    select SE_FOLLOW_UP_POSSIBLE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_QUEUE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_QUEUE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_QUEUE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_QUEUE_t
before insert on queue
for each row
begin
  if :new.id IS NULL then
    select SE_QUEUE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TICKET_PRIORITY';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TICKET_PRIORITY';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TICKET_PRIORITY
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TICKET_PRIORITY_t
before insert on ticket_priority
for each row
begin
  if :new.id IS NULL then
    select SE_TICKET_PRIORITY.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TICKET_TYPE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TICKET_TYPE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TICKET_TYPE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TICKET_TYPE_t
before insert on ticket_type
for each row
begin
  if :new.id IS NULL then
    select SE_TICKET_TYPE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TICKET_LOCK_TYPE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TICKET_LOCK_TYPE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TICKET_LOCK_TYPE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TICKET_LOCK_TYPE_t
before insert on ticket_lock_type
for each row
begin
  if :new.id IS NULL then
    select SE_TICKET_LOCK_TYPE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TICKET_STATE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TICKET_STATE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TICKET_STATE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TICKET_STATE_t
before insert on ticket_state
for each row
begin
  if :new.id IS NULL then
    select SE_TICKET_STATE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TICKET_STATE_TYPE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TICKET_STATE_TYPE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TICKET_STATE_TYPE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TICKET_STATE_TYPE_t
before insert on ticket_state_type
for each row
begin
  if :new.id IS NULL then
    select SE_TICKET_STATE_TYPE.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_ticket_state_type_change_by ON ticket_state_type (change_by);
CREATE INDEX FK_ticket_state_type_create_by ON ticket_state_type (create_by);
-- ----------------------------------------------------------
--  create table ticket
-- ----------------------------------------------------------
CREATE TABLE ticket (
    id NUMBER (20, 0) NOT NULL,
    tn VARCHAR2 (50) NOT NULL,
    title VARCHAR2 (255) NULL,
    queue_id NUMBER (12, 0) NOT NULL,
    ticket_lock_id NUMBER (5, 0) NOT NULL,
    type_id NUMBER (5, 0) NULL,
    service_id NUMBER (12, 0) NULL,
    sla_id NUMBER (12, 0) NULL,
    user_id NUMBER (12, 0) NOT NULL,
    responsible_user_id NUMBER (12, 0) NOT NULL,
    ticket_priority_id NUMBER (5, 0) NOT NULL,
    ticket_state_id NUMBER (5, 0) NOT NULL,
    customer_id VARCHAR2 (150) NULL,
    customer_user_id VARCHAR2 (250) NULL,
    timeout NUMBER (12, 0) NOT NULL,
    until_time NUMBER (12, 0) NOT NULL,
    escalation_time NUMBER (12, 0) NOT NULL,
    escalation_update_time NUMBER (12, 0) NOT NULL,
    escalation_response_time NUMBER (12, 0) NOT NULL,
    escalation_solution_time NUMBER (12, 0) NOT NULL,
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TICKET';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TICKET';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TICKET
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TICKET_t
before insert on ticket
for each row
begin
  if :new.id IS NULL then
    select SE_TICKET.nextval
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
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
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
--  create table ticket_flag
-- ----------------------------------------------------------
CREATE TABLE ticket_flag (
    ticket_id NUMBER (20, 0) NOT NULL,
    ticket_key VARCHAR2 (50) NOT NULL,
    ticket_value VARCHAR2 (50) NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT ticket_flag_per_user UNIQUE (ticket_id, ticket_key, create_by)
);
CREATE INDEX FK_ticket_flag_create_by ON ticket_flag (create_by);
CREATE INDEX ticket_flag_ticket_id ON ticket_flag (ticket_id);
CREATE INDEX ticket_flag_ticket_id_create7d ON ticket_flag (ticket_id, create_by);
CREATE INDEX ticket_flag_ticket_id_ticketca ON ticket_flag (ticket_id, ticket_key);
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TICKET_HISTORY';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TICKET_HISTORY';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TICKET_HISTORY
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TICKET_HISTORY_t
before insert on ticket_history
for each row
begin
  if :new.id IS NULL then
    select SE_TICKET_HISTORY.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TICKET_HISTORY_TYPE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TICKET_HISTORY_TYPE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TICKET_HISTORY_TYPE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TICKET_HISTORY_TYPE_t
before insert on ticket_history_type
for each row
begin
  if :new.id IS NULL then
    select SE_TICKET_HISTORY_TYPE.nextval
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
--  create table ticket_index
-- ----------------------------------------------------------
CREATE TABLE ticket_index (
    ticket_id NUMBER (20, 0) NOT NULL,
    queue_id NUMBER (12, 0) NOT NULL,
    queue VARCHAR2 (200) NOT NULL,
    group_id NUMBER (12, 0) NOT NULL,
    s_lock VARCHAR2 (200) NOT NULL,
    s_state VARCHAR2 (200) NOT NULL,
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
--  create table ticket_loop_protection
-- ----------------------------------------------------------
CREATE TABLE ticket_loop_protection (
    sent_to VARCHAR2 (250) NOT NULL,
    sent_date VARCHAR2 (150) NOT NULL
);
CREATE INDEX ticket_loop_protection_sent_37 ON ticket_loop_protection (sent_date);
CREATE INDEX ticket_loop_protection_sent_to ON ticket_loop_protection (sent_to);
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_ARTICLE_TYPE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_ARTICLE_TYPE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_ARTICLE_TYPE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_ARTICLE_TYPE_t
before insert on article_type
for each row
begin
  if :new.id IS NULL then
    select SE_ARTICLE_TYPE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_ARTICLE_SENDER_TYPE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_ARTICLE_SENDER_TYPE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_ARTICLE_SENDER_TYPE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_ARTICLE_SENDER_TYPE_t
before insert on article_sender_type
for each row
begin
  if :new.id IS NULL then
    select SE_ARTICLE_SENDER_TYPE.nextval
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
    article_key VARCHAR2 (50) NOT NULL,
    article_value VARCHAR2 (50) NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_article_flag_create_by ON article_flag (create_by);
CREATE INDEX article_flag_article_id ON article_flag (article_id);
CREATE INDEX article_flag_article_id_crea15 ON article_flag (article_id, create_by);
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
    a_message_id_md5 VARCHAR2 (32) NULL,
    a_in_reply_to VARCHAR2 (3800) NULL,
    a_references VARCHAR2 (3800) NULL,
    a_content_type VARCHAR2 (250) NULL,
    a_body CLOB NOT NULL,
    incoming_time NUMBER (12, 0) NOT NULL,
    content_path VARCHAR2 (250) NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE article ADD CONSTRAINT PK_article PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_ARTICLE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_ARTICLE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_ARTICLE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_ARTICLE_t
before insert on article
for each row
begin
  if :new.id IS NULL then
    select SE_ARTICLE.nextval
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
CREATE INDEX article_message_id_md5 ON article (a_message_id_md5);
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
    a_body CLOB NOT NULL,
    incoming_time NUMBER (12, 0) NOT NULL
);
ALTER TABLE article_search ADD CONSTRAINT PK_article_search PRIMARY KEY (id);
CREATE INDEX article_search_article_sendec7 ON article_search (article_sender_type_id);
CREATE INDEX article_search_article_type_id ON article_search (article_type_id);
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_ARTICLE_PLAIN';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_ARTICLE_PLAIN';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_ARTICLE_PLAIN
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_ARTICLE_PLAIN_t
before insert on article_plain
for each row
begin
  if :new.id IS NULL then
    select SE_ARTICLE_PLAIN.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_ARTICLE_ATTACHMENT';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_ARTICLE_ATTACHMENT';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_ARTICLE_ATTACHMENT
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_ARTICLE_ATTACHMENT_t
before insert on article_attachment
for each row
begin
  if :new.id IS NULL then
    select SE_ARTICLE_ATTACHMENT.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_TIME_ACCOUNTING';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_TIME_ACCOUNTING';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_TIME_ACCOUNTING
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_TIME_ACCOUNTING_t
before insert on time_accounting
for each row
begin
  if :new.id IS NULL then
    select SE_TIME_ACCOUNTING.nextval
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
--  create table standard_template
-- ----------------------------------------------------------
CREATE TABLE standard_template (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    text CLOB NULL,
    content_type VARCHAR2 (250) NULL,
    template_type VARCHAR2 (100) DEFAULT 'Answer' NOT NULL,
    comments VARCHAR2 (250) NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT standard_template_name UNIQUE (name)
);
ALTER TABLE standard_template ADD CONSTRAINT PK_standard_template PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_STANDARD_TEMPLATE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_STANDARD_TEMPLATE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_STANDARD_TEMPLATE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_STANDARD_TEMPLATE_t
before insert on standard_template
for each row
begin
  if :new.id IS NULL then
    select SE_STANDARD_TEMPLATE.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_standard_template_change_by ON standard_template (change_by);
CREATE INDEX FK_standard_template_create_by ON standard_template (create_by);
CREATE INDEX FK_standard_template_valid_id ON standard_template (valid_id);
-- ----------------------------------------------------------
--  create table queue_standard_template
-- ----------------------------------------------------------
CREATE TABLE queue_standard_template (
    queue_id NUMBER (12, 0) NOT NULL,
    standard_template_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
CREATE INDEX FK_queue_standard_template_c33 ON queue_standard_template (change_by);
CREATE INDEX FK_queue_standard_template_c0d ON queue_standard_template (create_by);
CREATE INDEX FK_queue_standard_template_q63 ON queue_standard_template (queue_id);
CREATE INDEX FK_queue_standard_template_s54 ON queue_standard_template (standard_template_id);
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_STANDARD_ATTACHMENT';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_STANDARD_ATTACHMENT';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_STANDARD_ATTACHMENT
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_STANDARD_ATTACHMENT_t
before insert on standard_attachment
for each row
begin
  if :new.id IS NULL then
    select SE_STANDARD_ATTACHMENT.nextval
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
--  create table standard_template_attachment
-- ----------------------------------------------------------
CREATE TABLE standard_template_attachment (
    id NUMBER (12, 0) NOT NULL,
    standard_attachment_id NUMBER (12, 0) NOT NULL,
    standard_template_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE standard_template_attachment ADD CONSTRAINT PK_standard_template_attachmb7 PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_STANDARD_TEMPLATE_ATTACC3';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_STANDARD_TEMPLATE_ATTACC3';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_STANDARD_TEMPLATE_ATTACC3
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_STANDARD_TEMPLATE_ATTACC3_t
before insert on standard_template_attachment
for each row
begin
  if :new.id IS NULL then
    select SE_STANDARD_TEMPLATE_ATTACC3.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_standard_template_attachmbd ON standard_template_attachment (change_by);
CREATE INDEX FK_standard_template_attachmb7 ON standard_template_attachment (create_by);
CREATE INDEX FK_standard_template_attachm9e ON standard_template_attachment (standard_attachment_id);
CREATE INDEX FK_standard_template_attachm29 ON standard_template_attachment (standard_template_id);
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_AUTO_RESPONSE_TYPE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_AUTO_RESPONSE_TYPE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_AUTO_RESPONSE_TYPE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_AUTO_RESPONSE_TYPE_t
before insert on auto_response_type
for each row
begin
  if :new.id IS NULL then
    select SE_AUTO_RESPONSE_TYPE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_AUTO_RESPONSE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_AUTO_RESPONSE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_AUTO_RESPONSE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_AUTO_RESPONSE_t
before insert on auto_response
for each row
begin
  if :new.id IS NULL then
    select SE_AUTO_RESPONSE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_QUEUE_AUTO_RESPONSE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_QUEUE_AUTO_RESPONSE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_QUEUE_AUTO_RESPONSE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_QUEUE_AUTO_RESPONSE_t
before insert on queue_auto_response
for each row
begin
  if :new.id IS NULL then
    select SE_QUEUE_AUTO_RESPONSE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_SERVICE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_SERVICE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_SERVICE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_SERVICE_t
before insert on service
for each row
begin
  if :new.id IS NULL then
    select SE_SERVICE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_SLA';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_SLA';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_SLA
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_SLA_t
before insert on sla
for each row
begin
  if :new.id IS NULL then
    select SE_SLA.nextval
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
    id NUMBER (20, 0) NOT NULL,
    session_id VARCHAR2 (100) NOT NULL,
    data_key VARCHAR2 (100) NOT NULL,
    data_value CLOB NULL,
    serialized NUMBER (5, 0) NOT NULL
);
ALTER TABLE sessions ADD CONSTRAINT PK_sessions PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_SESSIONS';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_SESSIONS';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_SESSIONS
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_SESSIONS_t
before insert on sessions
for each row
begin
  if :new.id IS NULL then
    select SE_SESSIONS.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX sessions_data_key ON sessions (data_key);
CREATE INDEX sessions_session_id_data_key ON sessions (session_id, data_key);
-- ----------------------------------------------------------
--  create table customer_user
-- ----------------------------------------------------------
CREATE TABLE customer_user (
    id NUMBER (12, 0) NOT NULL,
    login VARCHAR2 (200) NOT NULL,
    email VARCHAR2 (150) NOT NULL,
    customer_id VARCHAR2 (150) NOT NULL,
    pw VARCHAR2 (64) NULL,
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_CUSTOMER_USER';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_CUSTOMER_USER';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_CUSTOMER_USER
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_CUSTOMER_USER_t
before insert on customer_user
for each row
begin
  if :new.id IS NULL then
    select SE_CUSTOMER_USER.nextval
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
    imap_folder VARCHAR2 (250) NULL,
    comments VARCHAR2 (250) NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE mail_account ADD CONSTRAINT PK_mail_account PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_MAIL_ACCOUNT';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_MAIL_ACCOUNT';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_MAIL_ACCOUNT
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_MAIL_ACCOUNT_t
before insert on mail_account
for each row
begin
  if :new.id IS NULL then
    select SE_MAIL_ACCOUNT.nextval
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
    f_value VARCHAR2 (200) NOT NULL,
    f_not NUMBER (5, 0) NULL
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
    process_create NUMBER (12, 0) NOT NULL,
    process_change NUMBER (12, 0) NOT NULL
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_NOTIFICATIONS';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_NOTIFICATIONS';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_NOTIFICATIONS
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_NOTIFICATIONS_t
before insert on notifications
for each row
begin
  if :new.id IS NULL then
    select SE_NOTIFICATIONS.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_NOTIFICATION_EVENT';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_NOTIFICATION_EVENT';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_NOTIFICATION_EVENT
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_NOTIFICATION_EVENT_t
before insert on notification_event
for each row
begin
  if :new.id IS NULL then
    select SE_NOTIFICATION_EVENT.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_LINK_TYPE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_LINK_TYPE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_LINK_TYPE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_LINK_TYPE_t
before insert on link_type
for each row
begin
  if :new.id IS NULL then
    select SE_LINK_TYPE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_LINK_STATE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_LINK_STATE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_LINK_STATE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_LINK_STATE_t
before insert on link_state
for each row
begin
  if :new.id IS NULL then
    select SE_LINK_STATE.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_LINK_OBJECT';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_LINK_OBJECT';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_LINK_OBJECT
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_LINK_OBJECT_t
before insert on link_object
for each row
begin
  if :new.id IS NULL then
    select SE_LINK_OBJECT.nextval
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
--  create table system_data
-- ----------------------------------------------------------
CREATE TABLE system_data (
    data_key VARCHAR2 (160) NOT NULL,
    data_value CLOB NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE system_data ADD CONSTRAINT PK_system_data PRIMARY KEY (data_key);
CREATE INDEX FK_system_data_change_by ON system_data (change_by);
CREATE INDEX FK_system_data_create_by ON system_data (create_by);
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_VIRTUAL_FS';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_VIRTUAL_FS';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_VIRTUAL_FS
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_VIRTUAL_FS_t
before insert on virtual_fs
for each row
begin
  if :new.id IS NULL then
    select SE_VIRTUAL_FS.nextval
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
CREATE INDEX virtual_fs_preferences_key_v7c ON virtual_fs_preferences (preferences_key, preferences_value);
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_VIRTUAL_FS_DB';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_VIRTUAL_FS_DB';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_VIRTUAL_FS_DB
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_VIRTUAL_FS_DB_t
before insert on virtual_fs_db
for each row
begin
  if :new.id IS NULL then
    select SE_VIRTUAL_FS_DB.nextval
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
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_PACKAGE_REPOSITORY';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_PACKAGE_REPOSITORY';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_PACKAGE_REPOSITORY
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_PACKAGE_REPOSITORY_t
before insert on package_repository
for each row
begin
  if :new.id IS NULL then
    select SE_PACKAGE_REPOSITORY.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_package_repository_changed7 ON package_repository (change_by);
CREATE INDEX FK_package_repository_create99 ON package_repository (create_by);
-- ----------------------------------------------------------
--  create table gi_webservice_config
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    config_md5 VARCHAR2 (32) NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT gi_webservice_config_config_89 UNIQUE (config_md5),
    CONSTRAINT gi_webservice_config_name UNIQUE (name)
);
ALTER TABLE gi_webservice_config ADD CONSTRAINT PK_gi_webservice_config PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_GI_WEBSERVICE_CONFIG';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_GI_WEBSERVICE_CONFIG';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_GI_WEBSERVICE_CONFIG
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_GI_WEBSERVICE_CONFIG_t
before insert on gi_webservice_config
for each row
begin
  if :new.id IS NULL then
    select SE_GI_WEBSERVICE_CONFIG.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_gi_webservice_config_chan16 ON gi_webservice_config (change_by);
CREATE INDEX FK_gi_webservice_config_crea62 ON gi_webservice_config (create_by);
CREATE INDEX FK_gi_webservice_config_vali90 ON gi_webservice_config (valid_id);
-- ----------------------------------------------------------
--  create table gi_webservice_config_history
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config_history (
    id NUMBER (20, 0) NOT NULL,
    config_id NUMBER (12, 0) NOT NULL,
    config CLOB NOT NULL,
    config_md5 VARCHAR2 (32) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT gi_webservice_config_history8b UNIQUE (config_md5)
);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT PK_gi_webservice_config_hist06 PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_GI_WEBSERVICE_CONFIG_HI2F';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_GI_WEBSERVICE_CONFIG_HI2F';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_GI_WEBSERVICE_CONFIG_HI2F
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_GI_WEBSERVICE_CONFIG_HI2F_t
before insert on gi_webservice_config_history
for each row
begin
  if :new.id IS NULL then
    select SE_GI_WEBSERVICE_CONFIG_HI2F.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_gi_webservice_config_histe6 ON gi_webservice_config_history (change_by);
CREATE INDEX FK_gi_webservice_config_histeb ON gi_webservice_config_history (config_id);
CREATE INDEX FK_gi_webservice_config_hist3d ON gi_webservice_config_history (create_by);
-- ----------------------------------------------------------
--  create table scheduler_task_list
-- ----------------------------------------------------------
CREATE TABLE scheduler_task_list (
    id NUMBER (20, 0) NOT NULL,
    task_data CLOB NOT NULL,
    task_data_md5 VARCHAR2 (32) NOT NULL,
    task_type VARCHAR2 (200) NOT NULL,
    due_time DATE NOT NULL,
    create_time DATE NOT NULL,
    CONSTRAINT scheduler_task_list_task_dat81 UNIQUE (task_data_md5)
);
ALTER TABLE scheduler_task_list ADD CONSTRAINT PK_scheduler_task_list PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_SCHEDULER_TASK_LIST';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_SCHEDULER_TASK_LIST';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_SCHEDULER_TASK_LIST
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_SCHEDULER_TASK_LIST_t
before insert on scheduler_task_list
for each row
begin
  if :new.id IS NULL then
    select SE_SCHEDULER_TASK_LIST.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
-- ----------------------------------------------------------
--  create table gi_debugger_entry
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry (
    id NUMBER (20, 0) NOT NULL,
    communication_id VARCHAR2 (32) NOT NULL,
    communication_type VARCHAR2 (50) NOT NULL,
    remote_ip VARCHAR2 (50) NULL,
    webservice_id NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    CONSTRAINT gi_debugger_entry_communicat94 UNIQUE (communication_id)
);
ALTER TABLE gi_debugger_entry ADD CONSTRAINT PK_gi_debugger_entry PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_GI_DEBUGGER_ENTRY';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_GI_DEBUGGER_ENTRY';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_GI_DEBUGGER_ENTRY
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_GI_DEBUGGER_ENTRY_t
before insert on gi_debugger_entry
for each row
begin
  if :new.id IS NULL then
    select SE_GI_DEBUGGER_ENTRY.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_gi_debugger_entry_webserv43 ON gi_debugger_entry (webservice_id);
CREATE INDEX gi_debugger_entry_create_time ON gi_debugger_entry (create_time);
-- ----------------------------------------------------------
--  create table gi_debugger_entry_content
-- ----------------------------------------------------------
CREATE TABLE gi_debugger_entry_content (
    id NUMBER (20, 0) NOT NULL,
    gi_debugger_entry_id NUMBER (20, 0) NOT NULL,
    debug_level VARCHAR2 (50) NOT NULL,
    subject VARCHAR2 (255) NOT NULL,
    content CLOB NULL,
    create_time DATE NOT NULL
);
ALTER TABLE gi_debugger_entry_content ADD CONSTRAINT PK_gi_debugger_entry_content PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_GI_DEBUGGER_ENTRY_CONTENT';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_GI_DEBUGGER_ENTRY_CONTENT';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_GI_DEBUGGER_ENTRY_CONTENT
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_GI_DEBUGGER_ENTRY_CONTENT_t
before insert on gi_debugger_entry_content
for each row
begin
  if :new.id IS NULL then
    select SE_GI_DEBUGGER_ENTRY_CONTENT.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_gi_debugger_entry_contentc3 ON gi_debugger_entry_content (gi_debugger_entry_id);
CREATE INDEX gi_debugger_entry_content_cr4e ON gi_debugger_entry_content (create_time);
CREATE INDEX gi_debugger_entry_content_dea1 ON gi_debugger_entry_content (debug_level);
-- ----------------------------------------------------------
--  create table gi_object_lock_state
-- ----------------------------------------------------------
CREATE TABLE gi_object_lock_state (
    webservice_id NUMBER (12, 0) NOT NULL,
    object_type VARCHAR2 (30) NOT NULL,
    object_id NUMBER (20, 0) NOT NULL,
    lock_state VARCHAR2 (30) NOT NULL,
    lock_state_counter NUMBER (12, 0) NOT NULL,
    create_time DATE NOT NULL,
    change_time DATE NOT NULL,
    CONSTRAINT gi_object_lock_state_list UNIQUE (webservice_id, object_type, object_id)
);
CREATE INDEX FK_gi_object_lock_state_webs55 ON gi_object_lock_state (webservice_id);
CREATE INDEX object_lock_state_list_state ON gi_object_lock_state (webservice_id, object_type, object_id, lock_state);
-- ----------------------------------------------------------
--  create table smime_signer_cert_relations
-- ----------------------------------------------------------
CREATE TABLE smime_signer_cert_relations (
    id NUMBER (12, 0) NOT NULL,
    cert_hash VARCHAR2 (8) NOT NULL,
    cert_fingerprint VARCHAR2 (59) NOT NULL,
    ca_hash VARCHAR2 (8) NOT NULL,
    ca_fingerprint VARCHAR2 (59) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE smime_signer_cert_relations ADD CONSTRAINT PK_smime_signer_cert_relations PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_SMIME_SIGNER_CERT_RELATEF';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_SMIME_SIGNER_CERT_RELATEF';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_SMIME_SIGNER_CERT_RELATEF
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_SMIME_SIGNER_CERT_RELATEF_t
before insert on smime_signer_cert_relations
for each row
begin
  if :new.id IS NULL then
    select SE_SMIME_SIGNER_CERT_RELATEF.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_smime_signer_cert_relatiob7 ON smime_signer_cert_relations (change_by);
CREATE INDEX FK_smime_signer_cert_relatiobb ON smime_signer_cert_relations (create_by);
-- ----------------------------------------------------------
--  create table dynamic_field_value
-- ----------------------------------------------------------
CREATE TABLE dynamic_field_value (
    id NUMBER (12, 0) NOT NULL,
    field_id NUMBER (12, 0) NOT NULL,
    object_id NUMBER (20, 0) NOT NULL,
    value_text VARCHAR2 (3800) NULL,
    value_date DATE NULL,
    value_int NUMBER (20, 0) NULL
);
ALTER TABLE dynamic_field_value ADD CONSTRAINT PK_dynamic_field_value PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_DYNAMIC_FIELD_VALUE';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_DYNAMIC_FIELD_VALUE';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_DYNAMIC_FIELD_VALUE
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_DYNAMIC_FIELD_VALUE_t
before insert on dynamic_field_value
for each row
begin
  if :new.id IS NULL then
    select SE_DYNAMIC_FIELD_VALUE.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_dynamic_field_value_field90 ON dynamic_field_value (field_id);
CREATE INDEX dynamic_field_value_field_va6e ON dynamic_field_value (object_id, field_id);
CREATE INDEX dynamic_field_value_search_db3 ON dynamic_field_value (field_id, value_date);
CREATE INDEX dynamic_field_value_search_int ON dynamic_field_value (field_id, value_int);
-- ----------------------------------------------------------
--  create table dynamic_field
-- ----------------------------------------------------------
CREATE TABLE dynamic_field (
    id NUMBER (12, 0) NOT NULL,
    internal_field NUMBER (5, 0) DEFAULT 0 NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    label VARCHAR2 (200) NOT NULL,
    field_order NUMBER (12, 0) NOT NULL,
    field_type VARCHAR2 (200) NOT NULL,
    object_type VARCHAR2 (200) NOT NULL,
    config CLOB NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT dynamic_field_name UNIQUE (name)
);
ALTER TABLE dynamic_field ADD CONSTRAINT PK_dynamic_field PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_DYNAMIC_FIELD';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_DYNAMIC_FIELD';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_DYNAMIC_FIELD
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_DYNAMIC_FIELD_t
before insert on dynamic_field
for each row
begin
  if :new.id IS NULL then
    select SE_DYNAMIC_FIELD.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_dynamic_field_change_by ON dynamic_field (change_by);
CREATE INDEX FK_dynamic_field_create_by ON dynamic_field (create_by);
CREATE INDEX FK_dynamic_field_valid_id ON dynamic_field (valid_id);
-- ----------------------------------------------------------
--  create table pm_process
-- ----------------------------------------------------------
CREATE TABLE pm_process (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    state_entity_id VARCHAR2 (50) NOT NULL,
    layout CLOB NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_process_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_process ADD CONSTRAINT PK_pm_process PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_PM_PROCESS';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_PM_PROCESS';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_PM_PROCESS
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_PM_PROCESS_t
before insert on pm_process
for each row
begin
  if :new.id IS NULL then
    select SE_PM_PROCESS.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_pm_process_change_by ON pm_process (change_by);
CREATE INDEX FK_pm_process_create_by ON pm_process (create_by);
-- ----------------------------------------------------------
--  create table pm_activity
-- ----------------------------------------------------------
CREATE TABLE pm_activity (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_activity_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_activity ADD CONSTRAINT PK_pm_activity PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_PM_ACTIVITY';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_PM_ACTIVITY';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_PM_ACTIVITY
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_PM_ACTIVITY_t
before insert on pm_activity
for each row
begin
  if :new.id IS NULL then
    select SE_PM_ACTIVITY.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_pm_activity_change_by ON pm_activity (change_by);
CREATE INDEX FK_pm_activity_create_by ON pm_activity (create_by);
-- ----------------------------------------------------------
--  create table pm_activity_dialog
-- ----------------------------------------------------------
CREATE TABLE pm_activity_dialog (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_activity_dialog_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_activity_dialog ADD CONSTRAINT PK_pm_activity_dialog PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_PM_ACTIVITY_DIALOG';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_PM_ACTIVITY_DIALOG';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_PM_ACTIVITY_DIALOG
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_PM_ACTIVITY_DIALOG_t
before insert on pm_activity_dialog
for each row
begin
  if :new.id IS NULL then
    select SE_PM_ACTIVITY_DIALOG.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_pm_activity_dialog_change65 ON pm_activity_dialog (change_by);
CREATE INDEX FK_pm_activity_dialog_create86 ON pm_activity_dialog (create_by);
-- ----------------------------------------------------------
--  create table pm_transition
-- ----------------------------------------------------------
CREATE TABLE pm_transition (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_transition_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_transition ADD CONSTRAINT PK_pm_transition PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_PM_TRANSITION';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_PM_TRANSITION';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_PM_TRANSITION
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_PM_TRANSITION_t
before insert on pm_transition
for each row
begin
  if :new.id IS NULL then
    select SE_PM_TRANSITION.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_pm_transition_change_by ON pm_transition (change_by);
CREATE INDEX FK_pm_transition_create_by ON pm_transition (create_by);
-- ----------------------------------------------------------
--  create table pm_transition_action
-- ----------------------------------------------------------
CREATE TABLE pm_transition_action (
    id NUMBER (12, 0) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT pm_transition_action_entity_id UNIQUE (entity_id)
);
ALTER TABLE pm_transition_action ADD CONSTRAINT PK_pm_transition_action PRIMARY KEY (id);
DECLARE
    v_seq NUMBER;

BEGIN
    SELECT 1
    INTO v_seq
    FROM user_sequences
    WHERE sequence_name = 'SE_PM_TRANSITION_ACTION';

    IF v_seq = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE SE_PM_TRANSITION_ACTION';
    END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;

END;
;
CREATE SEQUENCE SE_PM_TRANSITION_ACTION
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCYCLE
CACHE 20
ORDER;
CREATE OR REPLACE TRIGGER SE_PM_TRANSITION_ACTION_t
before insert on pm_transition_action
for each row
begin
  if :new.id IS NULL then
    select SE_PM_TRANSITION_ACTION.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_pm_transition_action_chan4f ON pm_transition_action (change_by);
CREATE INDEX FK_pm_transition_action_crea78 ON pm_transition_action (create_by);
-- ----------------------------------------------------------
--  create table pm_entity
-- ----------------------------------------------------------
CREATE TABLE pm_entity (
    entity_type VARCHAR2 (50) NOT NULL,
    entity_counter NUMBER (12, 0) NOT NULL
);
-- ----------------------------------------------------------
--  create table pm_entity_sync
-- ----------------------------------------------------------
CREATE TABLE pm_entity_sync (
    entity_type VARCHAR2 (30) NOT NULL,
    entity_id VARCHAR2 (50) NOT NULL,
    sync_state VARCHAR2 (30) NOT NULL,
    create_time DATE NOT NULL,
    change_time DATE NOT NULL,
    CONSTRAINT pm_entity_sync_list UNIQUE (entity_type, entity_id)
);
