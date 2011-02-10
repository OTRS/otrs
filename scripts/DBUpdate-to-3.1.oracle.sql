-- ----------------------------------------------------------
--  driver: oracle, generated: 2011-02-10 17:13:00
-- ----------------------------------------------------------
SET DEFINE OFF;
ALTER TABLE ticket_index MODIFY queue VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE ticket_index MODIFY s_state VARCHAR2 (200) DEFAULT NULL;
ALTER TABLE ticket_index MODIFY s_lock VARCHAR2 (200) DEFAULT NULL;
-- ----------------------------------------------------------
--  create table gi_webservice_config
-- ----------------------------------------------------------
CREATE TABLE gi_webservice_config (
    id NUMBER (12, 0) NOT NULL,
    name VARCHAR2 (200) NOT NULL,
    config CLOB NOT NULL,
    valid_id NUMBER (5, 0) NOT NULL,
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL,
    CONSTRAINT gi_webservice_config_name UNIQUE (name)
);
ALTER TABLE gi_webservice_config ADD CONSTRAINT PK_gi_webservice_config PRIMARY KEY (id);
DROP SEQUENCE SE_gi_webservice_config;
CREATE SEQUENCE SE_gi_webservice_config;
CREATE OR REPLACE TRIGGER SE_gi_webservice_config_t
before insert on gi_webservice_config
for each row
begin
  if :new.id IS NULL then
    select SE_gi_webservice_config.nextval
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
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL,
    change_time DATE NOT NULL,
    change_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT PK_gi_webservice_config_hist06 PRIMARY KEY (id);
DROP SEQUENCE SE_gi_webservice_config_hi2f;
CREATE SEQUENCE SE_gi_webservice_config_hi2f;
CREATE OR REPLACE TRIGGER SE_gi_webservice_config_hi2f_t
before insert on gi_webservice_config_history
for each row
begin
  if :new.id IS NULL then
    select SE_gi_webservice_config_hi2f.nextval
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
    create_time DATE NOT NULL,
    create_by NUMBER (12, 0) NOT NULL
);
ALTER TABLE scheduler_task_list ADD CONSTRAINT PK_scheduler_task_list PRIMARY KEY (id);
DROP SEQUENCE SE_scheduler_task_list;
CREATE SEQUENCE SE_scheduler_task_list;
CREATE OR REPLACE TRIGGER SE_scheduler_task_list_t
before insert on scheduler_task_list
for each row
begin
  if :new.id IS NULL then
    select SE_scheduler_task_list.nextval
    into :new.id
    from dual;
  end if;
end;
/
--;
CREATE INDEX FK_scheduler_task_list_creat79 ON scheduler_task_list (create_by);
SET DEFINE OFF;
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_crea72 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_chan93 FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config ADD CONSTRAINT FK_gi_webservice_config_valife FOREIGN KEY (valid_id) REFERENCES valid (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_hist66 FOREIGN KEY (config_id) REFERENCES gi_webservice_config (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_hist54 FOREIGN KEY (create_by) REFERENCES users (id);
ALTER TABLE gi_webservice_config_history ADD CONSTRAINT FK_gi_webservice_config_histeb FOREIGN KEY (change_by) REFERENCES users (id);
ALTER TABLE scheduler_task_list ADD CONSTRAINT FK_scheduler_task_list_creat68 FOREIGN KEY (create_by) REFERENCES users (id);
