-- ----------------------------------------------------------
--  driver: oracle, generated: 2012-11-08 09:22:12
-- ----------------------------------------------------------
SET DEFINE OFF;
DROP TABLE sessions CASCADE CONSTRAINTS;
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
DROP SEQUENCE SE_sessions;
CREATE SEQUENCE SE_sessions;
CREATE OR REPLACE TRIGGER SE_sessions_t
before insert on sessions
for each row
begin
  if :new.id IS NULL then
    select SE_sessions.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX sessions_data_key ON sessions (data_key);
CREATE INDEX sessions_session_id_data_key ON sessions (session_id, data_key);
SET DEFINE OFF;
