-- ----------------------------------------------------------
--  driver: db2, generated: 2009-05-15 11:45:50
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue DROP move_notify;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE queue');

-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue DROP state_notify;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE queue');

-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue DROP lock_notify;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE queue');

-- ----------------------------------------------------------
--  alter table queue
-- ----------------------------------------------------------
ALTER TABLE queue DROP owner_notify;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE queue');
