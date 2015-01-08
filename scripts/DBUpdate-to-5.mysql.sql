# ----------------------------------------------------------
#  driver: mysql
# ----------------------------------------------------------
CREATE INDEX link_relation_list_source ON link_relation (source_object_id, source_key, state_id);
CREATE INDEX link_relation_list_target ON link_relation (target_object_id, target_key, state_id);
