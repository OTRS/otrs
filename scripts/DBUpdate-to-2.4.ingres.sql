-- ----------------------------------------------------------
--  driver: ingres, generated: 2008-10-15 11:56:48
-- ----------------------------------------------------------
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD COLUMN a_in_reply_to VARCHAR(3800);\g
-- ----------------------------------------------------------
--  alter table article
-- ----------------------------------------------------------
ALTER TABLE article ADD COLUMN a_references VARCHAR(3800);\g
CREATE TABLE service_preferences (
    service_id INTEGER NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY service_preferences TO btree;\g
CREATE INDEX service_preferences_service_id ON service_preferences (service_id);\g
CREATE TABLE sla_preferences (
    sla_id INTEGER NOT NULL,
    preferences_key VARCHAR(150) NOT NULL,
    preferences_value VARCHAR(250)
);\g
MODIFY sla_preferences TO btree;\g
CREATE INDEX sla_preferences_sla_id ON sla_preferences (sla_id);\g
ALTER TABLE service_preferences ADD FOREIGN KEY (service_id) REFERENCES service(id);\g
ALTER TABLE sla_preferences ADD FOREIGN KEY (sla_id) REFERENCES sla(id);\g
