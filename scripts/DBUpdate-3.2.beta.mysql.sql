# ----------------------------------------------------------
#  driver: mysql, generated: 2012-11-08 09:22:12
# ----------------------------------------------------------
DROP TABLE IF EXISTS sessions;
# ----------------------------------------------------------
#  create table sessions
# ----------------------------------------------------------
CREATE TABLE sessions (
    id BIGINT NOT NULL AUTO_INCREMENT,
    session_id VARCHAR (100) NOT NULL,
    data_key VARCHAR (100) NOT NULL,
    data_value TEXT NULL,
    serialized SMALLINT NOT NULL,
    PRIMARY KEY(id),
    INDEX sessions_data_key (data_key),
    INDEX sessions_session_id_data_key (session_id, data_key)
);
