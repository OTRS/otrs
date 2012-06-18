-- ----------------------------------------------------------
--  driver: db2, generated: 2012-06-18 14:24:44
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP group_read;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP group_write;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP other_read;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP other_write;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

DROP INDEX article_flag_create_by;

DROP INDEX article_flag_article_id_articlf0;
