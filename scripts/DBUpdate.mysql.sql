-- --
-- Update an existing OpenTRS database to the current state.
-- Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate.mysql.sql,v 1.1 2002-05-27 07:23:08 martin Exp $
-- --
--
-- usage: cat DBUpdate.mysql.sql | mysql -f -u root otrs
--
-- --

-- --
-- set db to BETA5 state
-- --
-- modify table ticket
ALTER TABLE ticket ADD ticket_answered SMALLINT DEFAULT 0;

-- add ticket_history_type
INSERT INTO ticket_history_type
    (name, valid_id, create_by, change_by, change_time)
VALUES
    ('SendAgentNotification', 1, 1, 1, current_timestamp); 

-- added frech language
INSERT INTO language
    (language, valid_id, create_by, change_by, change_time)
    VALUES
    ('French', 1, 1, 1, current_timestamp);

-- add article_type
INSERT INTO article_type
        (name, valid_id, create_by, change_by, change_time)
        VALUES
        ('email-external', 1, 1, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, change_by, change_time)
        VALUES
        ('email-internal', 1, 1, 1, current_timestamp);

-- create user_preferences
CREATE TABLE user_preferences
(
    user_id INTEGER NOT NULL,
    preferences_key VARCHAR (100) NOT NULL,
    preferences_value VARCHAR (250),
    PRIMARY KEY(user_id) 
);  

-- create session table
CREATE TABLE session
(
    id BIGINT NOT NULL AUTO_INCREMENT,
    session_id VARCHAR (120) NOT NULL,
    value MEDIUMTEXT NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (session_id),
    INDEX index_session_id (session_id)
);

