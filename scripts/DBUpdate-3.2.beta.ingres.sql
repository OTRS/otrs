-- ----------------------------------------------------------
--  driver: ingres, generated: 2012-11-08 09:22:12
-- ----------------------------------------------------------
DROP TABLE sessions;\g
CREATE SEQUENCE sessions_14;\g
CREATE TABLE sessions (
    id BIGINT NOT NULL DEFAULT sessions_14.NEXTVAL,
    session_id VARCHAR(100) NOT NULL,
    data_key VARCHAR(100) NOT NULL,
    data_value VARCHAR(10000),
    serialized SMALLINT NOT NULL
);\g
MODIFY sessions TO btree unique ON id WITH unique_scope = statement;\g
ALTER TABLE sessions ADD PRIMARY KEY ( id ) WITH index = base table structure;\g
CREATE INDEX sessions_data_key ON sessions (data_key);\g
CREATE INDEX sessions_session_id_data_key ON sessions (session_id, data_key);\g
