-- ----------------------------------------------------------
--  driver: oracle, generated: 2012-06-28 14:27:31
-- ----------------------------------------------------------
SET DEFINE OFF;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_read;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_write;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN other_read;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN other_write;
DROP INDEX ticket_answered;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN ticket_answered;
DROP INDEX article_flag_create_by;
DROP INDEX article_flag_article_id_artif0;
DROP INDEX ticket_queue_view;
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP COLUMN group_id;
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
SET DEFINE OFF;
