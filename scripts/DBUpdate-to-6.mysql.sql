# ----------------------------------------------------------
#  driver: mysql
# ----------------------------------------------------------
# ----------------------------------------------------------
#  create table dynamic_field_obj_id_name
# ----------------------------------------------------------
CREATE TABLE dynamic_field_obj_id_name (
    object_id INTEGER NOT NULL AUTO_INCREMENT,
    object_name VARCHAR (200) NOT NULL,
    object_type VARCHAR (200) NOT NULL,
    PRIMARY KEY(object_id),
    UNIQUE INDEX dynamic_field_object_name (object_name, object_type)
);
CREATE INDEX dynamic_field_value_search_text ON dynamic_field_value (field_id, value_text(150));
ALTER TABLE gi_webservice_config DROP INDEX gi_webservice_config_config_md5;
# ----------------------------------------------------------
#  alter table gi_webservice_config
# ----------------------------------------------------------
ALTER TABLE gi_webservice_config DROP config_md5;
ALTER TABLE cloud_service_config DROP INDEX cloud_service_config_config_md5;
# ----------------------------------------------------------
#  alter table cloud_service_config
# ----------------------------------------------------------
ALTER TABLE cloud_service_config DROP config_md5;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_from a_from MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_reply_to a_reply_to MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_to a_to MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_cc a_cc MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_references a_references MEDIUMTEXT NULL;
# ----------------------------------------------------------
#  alter table article
# ----------------------------------------------------------
ALTER TABLE article CHANGE a_in_reply_to a_in_reply_to MEDIUMTEXT NULL;
