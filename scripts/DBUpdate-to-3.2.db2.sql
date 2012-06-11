-- ----------------------------------------------------------
--  driver: db2, generated: 2012-06-11 13:38:37
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
