// ----------------------------------------------------------
//  driver: maxdb, generated: 2008-10-15 11:56:48
// ----------------------------------------------------------
// ----------------------------------------------------------
//  alter table article
// ----------------------------------------------------------
ALTER TABLE article ADD a_in_reply_to VARCHAR (3800)
//
// ----------------------------------------------------------
//  alter table article
// ----------------------------------------------------------
ALTER TABLE article ADD a_references VARCHAR (3800)
//
// ----------------------------------------------------------
//  create table service_preferences
// ----------------------------------------------------------
CREATE TABLE service_preferences
(
    service_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
)
//
CREATE INDEX service_preferences_26 ON service_preferences (service_id)
//
// ----------------------------------------------------------
//  create table sla_preferences
// ----------------------------------------------------------
CREATE TABLE sla_preferences
(
    sla_id INTEGER NOT NULL,
    preferences_key VARCHAR (150) NOT NULL,
    preferences_value VARCHAR (250)
)
//
CREATE INDEX sla_preferences_sla_51 ON sla_preferences (sla_id)
//
ALTER TABLE service_preferences ADD FOREIGN KEY (service_id) REFERENCES service(id)
//
ALTER TABLE sla_preferences ADD FOREIGN KEY (sla_id) REFERENCES sla(id)
//
