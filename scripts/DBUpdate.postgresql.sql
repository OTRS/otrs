-- --
-- Update an existing OpenTRS database to the current state.
-- Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate.postgresql.sql,v 1.3 2002-10-20 12:34:08 martin Exp $
-- --
--
-- usage: cat DBUpdate.postgresql.sql | psql otrs 
--
-- --

-- --
-- BETA 8 upgrate
-- --
-- add ticket_index index
create  INDEX index_ticket_id ON ticket_index (ticket_id);
-- customer_user
CREATE TABLE customer_user
(
    id serial,
    login varchar (80) NOT NULL,
    email varchar (120) NOT NULL,
    pw varchar (20) NOT NULL,
    salutation varchar (20),
    first_name varchar (40) NOT NULL,
    last_name varchar (40) NOT NULL,
    comment varchar (120) NOT NULL,
    valid_id smallint NOT NULL,
    create_time timestamp(0) NOT NULL,
    create_by integer NOT NULL,
    change_time timestamp(0) NOT NULL,
    change_by integer NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (login)
);
-- customer preferences
CREATE TABLE customer_preferences
(
    user_id integer NOT NULL,
    preferences_key varchar (100) NOT NULL,
    preferences_value varchar (250)
);
create  INDEX index_user_id ON customer_preferences (user_id);
-- add ticket_history index
create  INDEX ticket_history_create_time ON ticket_history (create_time);


-- --
-- BETA 7 upgrate
-- --
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

-- new time accounting table
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
create INDEX time_accounting_ticket_id ON time_accounting (ticket_id);

-- new ticket history type
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TimeAccounting', 1, 1, current_timestamp, 1, current_timestamp);

-- new article types
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-notification-ext', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-notification-int', 1, 1, current_timestamp, 1, current_timestamp);

-- new ticket history types
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Forward', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Bounce', 1, 1, current_timestamp, 1, current_timestamp);
-- content_type to display the right charset and it is also used
-- for utf-8 support.
ALTER TABLE article ADD a_content_type varchar (100);

