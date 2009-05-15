// ----------------------------------------------------------
//  driver: maxdb, generated: 2009-03-24 12:54:31
// ----------------------------------------------------------
ALTER TABLE service_preferences ADD FOREIGN KEY (service_id) REFERENCES service(id)
//
ALTER TABLE sla_preferences ADD FOREIGN KEY (sla_id) REFERENCES sla(id)
//
