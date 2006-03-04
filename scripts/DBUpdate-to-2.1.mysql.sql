-- --
-- Update an existing OTRS database from 2.0 to 2.1
-- Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: DBUpdate-to-2.1.mysql.sql,v 1.2 2006-03-04 11:24:33 martin Exp $
-- --
--
-- usage: cat DBUpdate-to-2.1.mysql.sql | mysql -f -u root otrs
--
-- --

--
-- ticket
--
ALTER TABLE ticket ADD responsible_user_id INTEGER NOT NULL;
ALTER TABLE ticket ADD freekey9 VARCHAR (80);
ALTER TABLE ticket ADD freetext9 VARCHAR (150);
ALTER TABLE ticket ADD freekey10 VARCHAR (80);
ALTER TABLE ticket ADD freetext10 VARCHAR (150);
ALTER TABLE ticket ADD freekey11 VARCHAR (80);
ALTER TABLE ticket ADD freetext11 VARCHAR (150);
ALTER TABLE ticket ADD freekey12 VARCHAR (80);
ALTER TABLE ticket ADD freetext12 VARCHAR (150);
ALTER TABLE ticket ADD freekey13 VARCHAR (80);
ALTER TABLE ticket ADD freetext13 VARCHAR (150);
ALTER TABLE ticket ADD freekey14 VARCHAR (80);
ALTER TABLE ticket ADD freetext14 VARCHAR (150);
ALTER TABLE ticket ADD freekey15 VARCHAR (80);
ALTER TABLE ticket ADD freetext15 VARCHAR (150);
ALTER TABLE ticket ADD freekey16 VARCHAR (80);
ALTER TABLE ticket ADD freetext16 VARCHAR (150);

INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('ResponsibleUpdate', 1, 1, current_timestamp, 1, current_timestamp);

