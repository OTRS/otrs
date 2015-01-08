-- ----------------------------------------------------------
--  driver: postgresql
-- ----------------------------------------------------------
SET standard_conforming_strings TO ON;
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
SET standard_conforming_strings TO ON;
