# ----------------------------------------------------------
#  driver: mysql, generated: 2012-06-28 14:27:31
# ----------------------------------------------------------
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP group_read;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP group_write;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP other_read;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP other_write;
DROP INDEX ticket_answered ON ticket;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP ticket_answered;
DROP INDEX article_flag_create_by ON article_flag;
DROP INDEX article_flag_article_id_article_key ON article_flag;
DROP INDEX ticket_queue_view ON ticket;
# ----------------------------------------------------------
#  alter table ticket
# ----------------------------------------------------------
ALTER TABLE ticket DROP group_id;
CREATE INDEX ticket_queue_view ON ticket (ticket_state_id, ticket_lock_id);
