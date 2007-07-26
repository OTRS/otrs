// ----------------------------------------------------------
//  driver: maxdb, generated: 2007-07-23 15:23:19
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
    UNIQUE (customer_id),
    UNIQUE (name)
)
//
// ----------------------------------------------------------
//  alter table queue
// ----------------------------------------------------------
ALTER TABLE queue ADD first_response_time INTEGER
//
// ----------------------------------------------------------
//  alter table queue
// ----------------------------------------------------------
ALTER TABLE queue ADD solution_time INTEGER
//
// ----------------------------------------------------------
//  alter table queue
// ----------------------------------------------------------
ALTER TABLE queue CHANGE escalation_time update_time INTEGER
//
// ----------------------------------------------------------
//  alter table ticket_priority
// ----------------------------------------------------------
ALTER TABLE ticket_priority ADD valid_id SMALLINT
//
UPDATE ticket_priority SET valid_id = 1 WHERE valid_id IS NULL
//
ALTER TABLE ticket_priority CHANGE valid_id valid_id SMALLINT NOT NULL
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
    UNIQUE (name)
)
//
// ----------------------------------------------------------
//  insert into table ticket_type
// ----------------------------------------------------------
INSERT INTO ticket_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('default', 1, 1, timestamp, 1, timestamp)
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD freetime3 timestamp
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD freetime4 timestamp
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD freetime5 timestamp
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD freetime6 timestamp
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD type_id INTEGER
//
UPDATE ticket SET type_id = 1 WHERE type_id IS NULL
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD service_id INTEGER
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD sla_id INTEGER
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD escalation_response_time INTEGER;
//
// ----------------------------------------------------------
//  alter table ticket
// ----------------------------------------------------------
ALTER TABLE ticket ADD escalation_solution_time INTEGER;
//
// ----------------------------------------------------------
//  alter table ticket_history
// ----------------------------------------------------------
ALTER TABLE ticket_history ADD type_id INTEGER
//
// ----------------------------------------------------------
//  insert into table ticket_history_type
// ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('TypeUpdate', 1, 1, timestamp, 1, timestamp)
//
// ----------------------------------------------------------
//  insert into table ticket_history_type
// ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ServiceUpdate', 1, 1, timestamp, 1, timestamp)
//
// ----------------------------------------------------------
//  insert into table ticket_history_type
// ----------------------------------------------------------
INSERT INTO ticket_history_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('SLAUpdate', 1, 1, timestamp, 1, timestamp)
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
    UNIQUE (name)
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
CREATE INDEX service_customer_use80 ON service_customer_user (customer_user_login)
//
CREATE INDEX service_customer_use32 ON service_customer_user (service_id)
//
// ----------------------------------------------------------
//  create table sla
// ----------------------------------------------------------
CREATE TABLE sla
(
    id serial,
    service_id INTEGER NOT NULL,
    name VARCHAR (200) NOT NULL,
    calendar_name VARCHAR (100),
    first_response_time INTEGER NOT NULL,
    update_time INTEGER NOT NULL,
    solution_time INTEGER NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (200),
    create_time timestamp NOT NULL,
    create_by INTEGER NOT NULL,
    change_time timestamp NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
)
//
