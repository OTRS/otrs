-- ----------------------------------------------------------
--  driver: db2, generated: 2012-03-22 12:01:09
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext1;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext2;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext3;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext4;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext5;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext6;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext7;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext8;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext9;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext10;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext11;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext12;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext13;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext14;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext15;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetext16;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey1;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey2;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey3;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey4;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey5;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey6;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey7;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey8;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey9;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey10;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey11;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey12;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey13;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey14;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey15;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freekey16;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetime1;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetime2;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetime3;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetime4;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetime5;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table ticket
-- ----------------------------------------------------------
ALTER TABLE ticket DROP freetime6;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE ticket');

-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP a_freetext1;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP a_freetext2;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP a_freetext3;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP a_freekey1;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP a_freekey2;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article DROP a_freekey3;

CALL SYSPROC.ADMIN_CMD ('REORG TABLE article');

ALTER TABLE ticket_flag ADD CONSTRAINT ticket_flag_per_user UNIQUE (ticket_id, ticket_key, create_by);
