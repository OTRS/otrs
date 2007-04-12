-- --
-- Update an existing OTRS database from 2.1 to 2.2
-- Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
-- --
-- $Id: DBUpdate-to-2.2.mysql.sql,v 1.12 2007-04-12 09:23:47 mh Exp $
-- --
--
-- usage: cat DBUpdate-to-2.2.mysql.sql | mysql -f -u root otrs
--
-- --

--
-- customer_company
--
CREATE TABLE customer_company (
    customer_id VARCHAR (100) NOT NULL,
    name VARCHAR (100) NOT NULL,
    street VARCHAR (200),
    zip VARCHAR (200),
    city VARCHAR (200),
    country VARCHAR (200),
    url VARCHAR (200),
    comments VARCHAR (250),
    valid_id SMALLINT NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    UNIQUE (customer_id),
    UNIQUE (name)
);

--
-- queue
--
ALTER TABLE queue CHANGE escalation_time update_time INTEGER;
ALTER TABLE queue ADD first_response_time INTEGER;
ALTER TABLE queue ADD solution_time INTEGER;

--
-- ticket
--
ALTER TABLE ticket ADD freetime3 DATETIME;
ALTER TABLE ticket ADD freetime4 DATETIME;
ALTER TABLE ticket ADD freetime5 DATETIME;
ALTER TABLE ticket ADD freetime6 DATETIME;
ALTER TABLE ticket ADD type_id INTEGER;
ALTER TABLE ticket ADD service_id INTEGER;
ALTER TABLE ticket ADD sla_id INTEGER;

--
-- ticket_priority
--
ALTER TABLE ticket_priority ADD valid_id SMALLINT NOT NULL;
UPDATE ticket_priority SET valid_id = 1;

--
-- ticket_type
--
CREATE TABLE ticket_type (
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
INSERT INTO ticket_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('default', 1, 1, current_timestamp, 1, current_timestamp);

--
-- ticket_history
--
ALTER TABLE ticket_history ADD type_id INTEGER;

--
-- ticket_history_type
--
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('TypeUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ServiceUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('SLAUpdate', 1, 1, current_timestamp, 1, current_timestamp);

--
-- ticket_watcher
--
ALTER TABLE ticket_watcher DROP INDEX ticket_id;
ALTER TABLE ticket_watcher ADD INDEX ticket_watcher_ticket_id (ticket_id);

--
-- service
--
CREATE TABLE service (
    id INTEGER NOT NULL AUTO_INCREMENT,
    name VARCHAR (200) NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (200) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);
ALTER TABLE service ADD FOREIGN KEY (create_by) REFERENCES `system_user(id)`;
ALTER TABLE service ADD FOREIGN KEY (change_by) REFERENCES `system_user(id)`;

--
-- sla
--
CREATE TABLE sla (
    id INTEGER NOT NULL AUTO_INCREMENT,
    service_id INTEGER NOT NULL,
    name VARCHAR (200) NOT NULL,
    calendar_name VARCHAR (100),
    first_response_time INTEGER NOT NULL,
    update_time INTEGER NOT NULL,
    solution_time INTEGER NOT NULL,
    valid_id SMALLINT NOT NULL,
    comments VARCHAR (200) NOT NULL,
    create_time DATETIME NOT NULL,
    create_by INTEGER NOT NULL,
    change_time DATETIME NOT NULL,
    change_by INTEGER NOT NULL,
    PRIMARY KEY(id),
    UNIQUE (name)
);
ALTER TABLE sla ADD FOREIGN KEY (create_by) REFERENCES `system_user(id)`;
ALTER TABLE sla ADD FOREIGN KEY (change_by) REFERENCES `system_user(id)`;
ALTER TABLE sla ADD FOREIGN KEY (service_id) REFERENCES `service(id)`;

--
-- xml_storage
--
ALTER TABLE xml_storage DROP INDEX xml_content_key;
ALTER TABLE xml_storage DROP INDEX xml_type;
ALTER TABLE xml_storage DROP INDEX xml_key;
ALTER TABLE xml_storage DROP INDEX xml_type_key;
ALTER TABLE xml_storage ADD INDEX xml_storage_xml_content_key (xml_content_key(100));
ALTER TABLE xml_storage ADD INDEX xml_storage_key_type (xml_key(10), xml_type(10));

