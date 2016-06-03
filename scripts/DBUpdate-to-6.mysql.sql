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
