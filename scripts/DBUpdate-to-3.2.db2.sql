-- ----------------------------------------------------------
--  driver: db2, generated: 2012-06-26 12:11:54
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

DROP INDEX ticket_queue_view;

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP group_id;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
