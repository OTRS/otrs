-- ----------------------------------------------------------
--  driver: postgresql, generated: 2012-11-08 09:22:12
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
DROP TABLE sessions;
-- ----------------------------------------------------------
--  create table sessions
-- ----------------------------------------------------------
CREATE TABLE sessions (
    id serial NOT NULL,
    session_id VARCHAR (100) NOT NULL,
    data_key VARCHAR (100) NOT NULL,
    data_value VARCHAR NULL,
    serialized INTEGER NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX sessions_data_key ON sessions (data_key);
CREATE INDEX sessions_session_id_data_key ON sessions (session_id, data_key);
SET standard_conforming_strings TO ON;
