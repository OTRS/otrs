# phpMyAdmin MySQL-Dump
# version 2.3.3pl1
# http://www.phpmyadmin.net/ (download page)
#
# Host: localhost
# Erstellungszeit: 14. April 2003 um 15:45
# Server Version: 3.23.54
# PHP-Version: 4.2.1
# Datenbank: `otrs_test`
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `article`
#

DROP TABLE IF EXISTS article;
CREATE TABLE article (
  id bigint(20) NOT NULL auto_increment,
  ticket_id int(11) NOT NULL default '0',
  article_type_id smallint(6) NOT NULL default '0',
  article_sender_type_id smallint(6) NOT NULL default '0',
  a_from mediumtext,
  a_reply_to varchar(255) default NULL,
  a_to mediumtext,
  a_cc mediumtext,
  a_subject mediumtext,
  a_message_id varchar(250) default NULL,
  a_content_type varchar(100) default NULL,
  a_body mediumtext NOT NULL,
  incoming_time int(11) NOT NULL default '0',
  content_path varchar(250) default NULL,
  a_freekey1 varchar(250) default NULL,
  a_freetext1 varchar(250) default NULL,
  a_freekey2 varchar(250) default NULL,
  a_freetext2 varchar(250) default NULL,
  a_freekey3 varchar(250) default NULL,
  a_freetext3 varchar(250) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY article_ticket_id (ticket_id)
) TYPE=MyISAM;

#
# Daten für Tabelle `article`
#

INSERT INTO article VALUES (1, 1, 1, 3, 'OTRS Feedback <feedback@otrs.org>', NULL, 'Your OTRS System <otrs@localhost>', NULL, 'Welcome to OTRS!', '<007@localhost>', NULL, 'Welcome to OTRS!\r\n\r\nthank you for installing OTRS.\r\n\r\nYou will find updates and patches at http://otrs.org/. Online\r\ndocumentation is available at http://docu.otrs.org/. You can also\r\ntake advantage of our mailing lists http://lists.otrs.org/.\r\n\r\n\r\nYour OTRS Team\r\n\r\n    Manage your communication!', 1012757943, '2002/02/3', NULL, NULL, NULL, NULL, NULL, NULL, 1, '2003-01-07 23:02:16', 1, '2003-01-07 23:02:16', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `article_attachment`
#

DROP TABLE IF EXISTS article_attachment;
CREATE TABLE article_attachment (
  id bigint(20) NOT NULL auto_increment,
  article_id bigint(20) NOT NULL default '0',
  filename varchar(250) default NULL,
  content_type varchar(250) default NULL,
  content longblob,
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY article_id (article_id)
) TYPE=MyISAM;

#
# Daten für Tabelle `article_attachment`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `article_plain`
#

DROP TABLE IF EXISTS article_plain;
CREATE TABLE article_plain (
  id bigint(20) NOT NULL auto_increment,
  article_id bigint(20) NOT NULL default '0',
  body mediumtext,
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY article_id (article_id)
) TYPE=MyISAM;

#
# Daten für Tabelle `article_plain`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `article_sender_type`
#

DROP TABLE IF EXISTS article_sender_type;
CREATE TABLE article_sender_type (
  id smallint(6) NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `article_sender_type`
#

INSERT INTO article_sender_type VALUES (1, 'agent', NULL, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO article_sender_type VALUES (2, 'system', NULL, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO article_sender_type VALUES (3, 'customer', NULL, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `article_type`
#

DROP TABLE IF EXISTS article_type;
CREATE TABLE article_type (
  id smallint(6) NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `article_type`
#

INSERT INTO article_type VALUES (1, 'email-external', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO article_type VALUES (2, 'email-internal', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO article_type VALUES (3, 'email-notification-ext', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO article_type VALUES (4, 'email-notification-int', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO article_type VALUES (5, 'phone', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO article_type VALUES (6, 'fax', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO article_type VALUES (7, 'sms', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO article_type VALUES (8, 'webrequest', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO article_type VALUES (9, 'note-internal', NULL, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO article_type VALUES (10, 'note-external', NULL, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO article_type VALUES (11, 'note-report', NULL, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `auto_response`
#

DROP TABLE IF EXISTS auto_response;
CREATE TABLE auto_response (
  id smallint(6) NOT NULL auto_increment,
  name varchar(80) NOT NULL default '',
  text0 mediumtext,
  text1 mediumtext,
  text2 mediumtext,
  type_id smallint(6) NOT NULL default '0',
  system_address_id smallint(6) NOT NULL default '0',
  charset_id smallint(6) NOT NULL default '0',
  comment varchar(100) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `auto_response`
#

INSERT INTO auto_response VALUES (1, 'default reply', 'This is a demo text which is send to every inquery.\r\nIt could contain something like:\r\n\r\nThanks for your e-mail. A new ticket has been created.\r\n\r\nYou wrote:\r\n<OTRS_CUSTOMER_EMAIL[6]>\r\n\r\nYour e-mail will be answered by a human asap\r\n\r\nHave fun with OTRS! :-)\r\n\r\n  Your OTRS Team\r\n', 'RE: <OTRS_CUSTOMER_SUBJECT[20]>', NULL, 1, 1, 1, 'default', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO auto_response VALUES (2, 'default reject', 'Reject.', 'thank you for your e-mail. But you forgot importand infos. Pleace write again with all informations. Thanks', NULL, 2, 1, 1, 'default', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO auto_response VALUES (3, 'default follow up', 'Thanks for your follow up e-mail\r\n\r\nYou wrote:\r\n<OTRS_CUSTOMER_EMAIL[6]>\r\n\r\nYour e-mail will be answered by a human asap.\r\n\r\nHave fun with OTRS!\r\n\r\nYour OTRS Team\r\n', 'RE: <OTRS_CUSTOMER_SUBJECT[20]>', NULL, 3, 1, 1, 'default', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO auto_response VALUES (4, 'default closed -> new ticket', 'New ticket after follow up.', 'thank you for your e-mail. The old ticket is closed. You have a new ticket now.', NULL, 4, 1, 1, 'default', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO auto_response VALUES (5, 'default remove', 'Ticket removed.', 'thank you for your remove e-mail. The ticket is closed.', NULL, 5, 1, 1, 'default', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `auto_response_type`
#

DROP TABLE IF EXISTS auto_response_type;
CREATE TABLE auto_response_type (
  id smallint(6) NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `auto_response_type`
#

INSERT INTO auto_response_type VALUES (1, 'auto reply', 'auto replay after a new ticket.', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO auto_response_type VALUES (2, 'auto reject', 'auto reject.', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO auto_response_type VALUES (3, 'auto follow up', 'auto follow up after a follow up.', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO auto_response_type VALUES (4, 'auto reply/new ticket', 'auto reply after a follow up. Because the ticket is closed.', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO auto_response_type VALUES (5, 'auto remove', 'auto remove after a remove e-mail.', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `charset`
#

DROP TABLE IF EXISTS charset;
CREATE TABLE charset (
  id smallint(6) NOT NULL auto_increment,
  name varchar(200) NOT NULL default '',
  charset varchar(50) NOT NULL default '',
  comment varchar(250) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `charset`
#

INSERT INTO charset VALUES (1, 'Latin-1 (iso-8859-1)', 'iso-8859-1', 'Western European languages.', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (2, 'Latin-2 (iso-8859-2)', 'iso-8859-2', 'Slavic and Central  European  languages.', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (3, 'Latin-3 (iso-8859-3)', 'iso-8859-3', 'Esperanto, Galician, Maltese, and Turkish.', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (4, 'Latin-4 (iso-8859-4)', 'iso-8859-4', 'Estonian, Latvian, and Lithuanian.', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (5, 'Cyrillic (iso-8859-5)', 'iso-8859-5', 'Bulgarian, Byelorussian, Macedonian, Russian, Serbian  and  Ukrainian.', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (6, 'Greek (iso-8859-7)', 'iso-8859-7', 'Modern monotonic Greek.', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (7, 'Unicode (UTF-8)', 'UTF-8', 'Unicode UTF-8', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (8, 'Cyrillic Charset (KOI8-R)', 'KOI8-R', 'Unicode UTF-8', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (9, 'Cyrillic Charset (Windows-1251)', 'Windows-1251', 'Windows-1251 - cp1251', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (10, 'Turkish (iso-8859-9)', 'iso-8859-9', 'Turkish.', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO charset VALUES (11, 'Latin-15 (iso-8859-15)', 'iso-8859-15', 'Western European languages with euro.', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `customer_preferences`
#

DROP TABLE IF EXISTS customer_preferences;
CREATE TABLE customer_preferences (
  user_id varchar(250) NOT NULL default '',
  preferences_key varchar(150) NOT NULL default '',
  preferences_value varchar(250) default NULL,
  KEY index_customer_preferences_user_id (user_id)
) TYPE=MyISAM;

#
# Daten für Tabelle `customer_preferences`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `customer_user`
#

DROP TABLE IF EXISTS customer_user;
CREATE TABLE customer_user (
  id smallint(6) NOT NULL auto_increment,
  login varchar(80) NOT NULL default '',
  email varchar(120) NOT NULL default '',
  customer_id varchar(120) NOT NULL default '',
  pw varchar(20) NOT NULL default '',
  salutation varchar(20) default NULL,
  first_name varchar(40) NOT NULL default '',
  last_name varchar(40) NOT NULL default '',
  valid_id smallint(6) NOT NULL default '0',
  comment varchar(120) NOT NULL default '',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY login (login)
) TYPE=MyISAM;

#
# Daten für Tabelle `customer_user`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `faq`
#

DROP TABLE IF EXISTS faq;
CREATE TABLE faq (
  id smallint(6) NOT NULL auto_increment,
  name varchar(200) NOT NULL default '',
  text varchar(255) NOT NULL default '',
  language_id smallint(6) NOT NULL default '0',
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `faq`
#

INSERT INTO faq VALUES (1, 'What is OTRS?', 'Open Ticket Request System ...', 1, 'test fax', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO faq VALUES (2, 'Was ist OTRS?', 'Open Ticket Request System ...', 2, 'test faq', 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `follow_up_possible`
#

DROP TABLE IF EXISTS follow_up_possible;
CREATE TABLE follow_up_possible (
  id smallint(6) NOT NULL auto_increment,
  name varchar(200) NOT NULL default '',
  comment varchar(200) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `follow_up_possible`
#

INSERT INTO follow_up_possible VALUES (1, 'possible', 'Follow ups after closed(+|-) possible. Ticket will be reopen.', 1, '2003-01-07 23:01:49', 1, '2003-01-07 23:01:49', 1);
INSERT INTO follow_up_possible VALUES (2, 'reject', 'Follow ups after closed(+|-) not possible. No new ticket will be created.', 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO follow_up_possible VALUES (3, 'new ticket', 'Follow ups after closed(+|-) not possible. A new ticket will be created.', 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `group_user`
#

DROP TABLE IF EXISTS group_user;
CREATE TABLE group_user (
  id int(11) NOT NULL auto_increment,
  user_id int(11) NOT NULL default '0',
  group_id int(11) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  permission_read smallint(6) NOT NULL default '0',
  permission_write smallint(6) NOT NULL default '0',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

#
# Daten für Tabelle `group_user`
#

INSERT INTO group_user VALUES (1, 1, 1, '2003-01-07 23:01:01', 1, '2003-01-07 23:01:01', 1, 1, 1);
INSERT INTO group_user VALUES (2, 1, 2, '2003-01-07 23:01:01', 1, '2003-01-07 23:01:01', 1, 1, 1);
INSERT INTO group_user VALUES (3, 1, 3, '2003-01-07 23:01:01', 1, '2003-01-07 23:01:01', 1, 1, 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `groups`
#

DROP TABLE IF EXISTS groups;
CREATE TABLE groups (
  id smallint(6) NOT NULL auto_increment,
  name varchar(25) NOT NULL default '',
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `groups`
#

INSERT INTO groups VALUES (1, 'users', NULL, 1, '2003-01-07 23:01:01', 1, '2003-01-07 23:01:01', 1);
INSERT INTO groups VALUES (2, 'admin', NULL, 1, '2003-01-07 23:01:01', 1, '2003-01-07 23:01:01', 1);
INSERT INTO groups VALUES (3, 'stats', NULL, 1, '2003-01-07 23:01:01', 1, '2003-01-07 23:01:01', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `personal_queues`
#

DROP TABLE IF EXISTS personal_queues;
CREATE TABLE personal_queues (
  id int(11) NOT NULL auto_increment,
  user_id int(11) NOT NULL default '0',
  queue_id int(11) NOT NULL default '0',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

#
# Daten für Tabelle `personal_queues`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `pop3_account`
#

DROP TABLE IF EXISTS pop3_account;
CREATE TABLE pop3_account (
  id int(11) NOT NULL auto_increment,
  login varchar(200) NOT NULL default '',
  pw varchar(200) NOT NULL default '',
  host varchar(200) NOT NULL default '',
  queue_id int(11) NOT NULL default '0',
  trusted smallint(6) NOT NULL default '0',
  comment varchar(250) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time timestamp(14) NOT NULL,
  create_by int(11) NOT NULL default '0',
  change_time timestamp(14) NOT NULL,
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY login (login)
) TYPE=MyISAM;

#
# Daten für Tabelle `pop3_account`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `queue`
#

DROP TABLE IF EXISTS queue;
CREATE TABLE queue (
  id smallint(6) NOT NULL auto_increment,
  name varchar(200) NOT NULL default '',
  group_id smallint(6) NOT NULL default '0',
  unlock_timeout int(11) default NULL,
  escalation_time int(11) default NULL,
  system_address_id smallint(6) NOT NULL default '0',
  salutation_id smallint(6) NOT NULL default '0',
  signature_id smallint(6) NOT NULL default '0',
  follow_up_id smallint(6) NOT NULL default '0',
  follow_up_lock smallint(6) NOT NULL default '0',
  comment varchar(200) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  move_notify smallint(6) NOT NULL default '0',
  lock_notify smallint(6) NOT NULL default '0',
  state_notify smallint(6) NOT NULL default '0',
  owner_notify smallint(6) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `queue`
#

INSERT INTO queue VALUES (1, 'Postmaster', 1, 0, 0, 1, 1, 1, 1, 1, 'master queue', 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1, 0, 0, 0, 0);
INSERT INTO queue VALUES (2, 'Raw', 1, 0, 0, 1, 1, 1, 1, 1, 'all incoming tickets', 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1, 0, 0, 0, 0);
INSERT INTO queue VALUES (3, 'Junk', 1, 0, 0, 1, 1, 1, 1, 1, 'all junk tickets', 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1, 0, 0, 0, 0);
INSERT INTO queue VALUES (4, 'Misc', 1, 0, 0, 1, 1, 1, 1, 1, 'all misk tickets', 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1, 0, 0, 0, 0);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `queue_auto_response`
#

DROP TABLE IF EXISTS queue_auto_response;
CREATE TABLE queue_auto_response (
  id int(11) NOT NULL auto_increment,
  queue_id int(11) NOT NULL default '0',
  auto_response_id int(11) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

#
# Daten für Tabelle `queue_auto_response`
#

INSERT INTO queue_auto_response VALUES (1, 11, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_auto_response VALUES (2, 11, 2, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `queue_standard_response`
#

DROP TABLE IF EXISTS queue_standard_response;
CREATE TABLE queue_standard_response (
  id int(11) NOT NULL auto_increment,
  queue_id int(11) NOT NULL default '0',
  standard_response_id int(11) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

#
# Daten für Tabelle `queue_standard_response`
#

INSERT INTO queue_standard_response VALUES (1, 1, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_standard_response VALUES (2, 2, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_standard_response VALUES (3, 3, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_standard_response VALUES (4, 4, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_standard_response VALUES (5, 5, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_standard_response VALUES (6, 6, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_standard_response VALUES (7, 7, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_standard_response VALUES (8, 8, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO queue_standard_response VALUES (9, 9, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `salutation`
#

DROP TABLE IF EXISTS salutation;
CREATE TABLE salutation (
  id smallint(6) NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  text mediumtext NOT NULL,
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `salutation`
#

INSERT INTO salutation VALUES (1, 'system standard salutation (en)', 'Dear <OTRS_CUSTOMER_REALNAME>,\r\n\r\nThank you for your request.\r\n', 'std. salutation', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO salutation VALUES (2, 'system standard salutation (de/buiss)', 'Sehr geehrter <OTRS_CUSTOMER_REALNAME>,\r\n\r\nDanke für Ihre Anfrage.\r\n', 'std. salutation', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `session`
#

DROP TABLE IF EXISTS session;
CREATE TABLE session (
  id bigint(20) NOT NULL auto_increment,
  session_id varchar(120) NOT NULL default '',
  value mediumtext NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY session_id (session_id),
  KEY index_session_id (session_id)
) TYPE=MyISAM;

#
# Daten für Tabelle `session`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `signature`
#

DROP TABLE IF EXISTS signature;
CREATE TABLE signature (
  id smallint(6) NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  text mediumtext NOT NULL,
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `signature`
#

INSERT INTO signature VALUES (1, 'system standard signature (en)', '\r\nYour OTRS-Team\r\n\r\n -\r\n <OTRS_FIRST_NAME> <OTRS_LAST_NAME> \r\n--\r\n', 'std signature', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO signature VALUES (2, 'system standard signature (de/buiss)', '\r\nIhr OTRS Team\r\n\r\n-- \r\n  <OTRS_FIRST_NAME> <OTRS_LAST_NAME> \r\n--\r\n', 'std. signature', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `standard_attachment`
#

DROP TABLE IF EXISTS standard_attachment;
CREATE TABLE standard_attachment (
  id int(11) NOT NULL auto_increment,
  name varchar(150) NOT NULL default '',
  content_type varchar(150) NOT NULL default '',
  content mediumtext NOT NULL,
  filename varchar(250) NOT NULL default '',
  comment varchar(150) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time timestamp(14) NOT NULL,
  create_by int(11) NOT NULL default '0',
  change_time timestamp(14) NOT NULL,
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `standard_attachment`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `standard_response`
#

DROP TABLE IF EXISTS standard_response;
CREATE TABLE standard_response (
  id smallint(6) NOT NULL auto_increment,
  name varchar(80) NOT NULL default '',
  text mediumtext NOT NULL,
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `standard_response`
#

INSERT INTO standard_response VALUES (1, 'empty answer', '', NULL, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
INSERT INTO standard_response VALUES (2, 'test answer', 'test answer ...', NULL, 1, '2003-01-07 23:02:07', 1, '2003-01-07 23:02:07', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `standard_response_attachment`
#

DROP TABLE IF EXISTS standard_response_attachment;
CREATE TABLE standard_response_attachment (
  id int(11) NOT NULL auto_increment,
  standard_attachment_id int(11) NOT NULL default '0',
  standard_response_id int(11) NOT NULL default '0',
  create_time timestamp(14) NOT NULL,
  create_by int(11) NOT NULL default '0',
  change_time timestamp(14) NOT NULL,
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

#
# Daten für Tabelle `standard_response_attachment`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `system_address`
#

DROP TABLE IF EXISTS system_address;
CREATE TABLE system_address (
  id smallint(6) NOT NULL auto_increment,
  value0 varchar(200) NOT NULL default '',
  value1 varchar(200) NOT NULL default '',
  value2 varchar(200) default NULL,
  value3 varchar(200) default NULL,
  queue_id smallint(6) NOT NULL default '0',
  comment varchar(200) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

#
# Daten für Tabelle `system_address`
#

INSERT INTO system_address VALUES (1, 'otrs@localhost', 'OTRS System', NULL, NULL, 1, 'Std. Address', 1, '2003-01-07 23:01:29', 1, '2003-01-07 23:01:29', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `system_user`
#

DROP TABLE IF EXISTS system_user;
CREATE TABLE system_user (
  id smallint(6) NOT NULL auto_increment,
  login varchar(80) NOT NULL default '',
  pw varchar(20) NOT NULL default '',
  salutation varchar(20) default NULL,
  first_name varchar(40) NOT NULL default '',
  last_name varchar(40) NOT NULL default '',
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY login (login)
) TYPE=MyISAM;

#
# Daten für Tabelle `system_user`
#

INSERT INTO system_user VALUES (1, 'root@localhost', 'roK20XGbWEsSM', NULL, 'Admin', 'OTRS', 1, '2003-01-07 23:00:42', 1, '2003-01-07 23:00:42', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `theme`
#

DROP TABLE IF EXISTS theme;
CREATE TABLE theme (
  id smallint(6) NOT NULL auto_increment,
  theme varchar(30) NOT NULL default '',
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY theme (theme)
) TYPE=MyISAM;

#
# Daten für Tabelle `theme`
#

INSERT INTO theme VALUES (1, 'Standard', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
INSERT INTO theme VALUES (2, 'Lite', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket`
#

DROP TABLE IF EXISTS ticket;
CREATE TABLE ticket (
  id bigint(20) NOT NULL auto_increment,
  tn varchar(50) NOT NULL default '',
  queue_id smallint(6) NOT NULL default '0',
  ticket_lock_id smallint(6) NOT NULL default '0',
  ticket_answered smallint(6) NOT NULL default '0',
  user_id smallint(6) NOT NULL default '0',
  group_id smallint(6) NOT NULL default '0',
  ticket_priority_id smallint(6) NOT NULL default '0',
  ticket_state_id smallint(6) NOT NULL default '0',
  group_read smallint(6) default NULL,
  group_write smallint(6) default NULL,
  other_read smallint(6) default NULL,
  other_write smallint(6) default NULL,
  customer_id varchar(150) default NULL,
  timeout int(11) default NULL,
  until_time int(11) default NULL,
  freekey1 varchar(150) default NULL,
  freetext1 varchar(150) default NULL,
  freekey2 varchar(150) default NULL,
  freetext2 varchar(150) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time_unix int(11) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  customer_user_id varchar(250) default NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY tn (tn),
  KEY index_ticket_queue_view (ticket_state_id,group_id,ticket_lock_id,group_id),
  KEY index_ticket_user (user_id),
  KEY index_ticket_answered (ticket_answered)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket`
#

INSERT INTO ticket VALUES (1, '1010001', 2, 1, 0, 1, 1, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1012757943, '2003-01-07 23:02:16', 1, '2003-01-07 23:02:16', 1, NULL);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket_history`
#

DROP TABLE IF EXISTS ticket_history;
CREATE TABLE ticket_history (
  id bigint(20) NOT NULL auto_increment,
  name varchar(200) NOT NULL default '',
  history_type_id smallint(6) NOT NULL default '0',
  ticket_id bigint(20) NOT NULL default '0',
  article_id bigint(20) default NULL,
  system_queue_id smallint(6) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY ticket_history_ticket_id (ticket_id),
  KEY ticket_history_create_time (create_time)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket_history`
#

INSERT INTO ticket_history VALUES (1, 'New Ticket [1010001] created.', 1, 1, 1, NULL, 1, '2003-01-07 23:02:16', 1, '2003-01-07 23:02:16', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket_history_type`
#

DROP TABLE IF EXISTS ticket_history_type;
CREATE TABLE ticket_history_type (
  id smallint(6) NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket_history_type`
#

INSERT INTO ticket_history_type VALUES (1, 'NewTicket', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (2, 'FollowUp', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (3, 'SendAutoReject', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (4, 'SendAutoReply', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (5, 'SendAutoFollowUp', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (6, 'Forward', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (7, 'Bounce', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (8, 'SendAnswer', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (9, 'SendAgentNotification', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (10, 'PhoneCallAgent', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (11, 'PhoneCallCustomer', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (12, 'Close successful', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (13, 'Close unsuccessful', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (14, 'AddNote', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (15, 'Open', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (16, 'Reopen', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (17, 'Move', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (18, 'Lock', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (19, 'Unlock', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (20, 'WatingForReminder', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (21, 'WatingForClose+', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (22, 'WatingForClose-', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (23, 'Remove', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (24, 'TimeAccounting', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (25, 'CustomerUpdate', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (26, 'PriorityUpdate', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (27, 'OwnerUpdate', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (28, 'LoopProtection', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (29, 'Misc', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (30, 'SetPendingTime', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (31, 'SetPending', NULL, 1, '2003-01-07 23:01:50', 1, '2003-01-07 23:01:50', 1);
INSERT INTO ticket_history_type VALUES (32, 'SendCustomerNotification', NULL, 1, '2003-04-14 15:44:48', 1, '2003-04-14 15:44:48', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket_index`
#

DROP TABLE IF EXISTS ticket_index;
CREATE TABLE ticket_index (
  ticket_id bigint(20) NOT NULL default '0',
  queue_id int(11) NOT NULL default '0',
  queue varchar(70) NOT NULL default '',
  group_id int(11) NOT NULL default '0',
  s_lock varchar(70) NOT NULL default '',
  s_state varchar(70) NOT NULL default '',
  create_time_unix bigint(20) NOT NULL default '0',
  KEY index_ticket_id (ticket_id)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket_index`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket_lock_type`
#

DROP TABLE IF EXISTS ticket_lock_type;
CREATE TABLE ticket_lock_type (
  id smallint(6) NOT NULL auto_increment,
  name varchar(25) NOT NULL default '',
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket_lock_type`
#

INSERT INTO ticket_lock_type VALUES (1, 'unlock', 1, '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
INSERT INTO ticket_lock_type VALUES (2, 'lock', 1, '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
INSERT INTO ticket_lock_type VALUES (3, 'tmp_lock', 1, '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket_loop_protection`
#

DROP TABLE IF EXISTS ticket_loop_protection;
CREATE TABLE ticket_loop_protection (
  sent_to varchar(250) NOT NULL default '',
  sent_date varchar(150) NOT NULL default '',
  KEY index_ticket_loop_protection_sent_to (sent_to),
  KEY index_ticket_loop_protection_sent_date (sent_date)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket_loop_protection`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket_priority`
#

DROP TABLE IF EXISTS ticket_priority;
CREATE TABLE ticket_priority (
  id smallint(6) NOT NULL auto_increment,
  name varchar(25) NOT NULL default '',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket_priority`
#

INSERT INTO ticket_priority VALUES (1, '1 very low', '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
INSERT INTO ticket_priority VALUES (2, '2 low', '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
INSERT INTO ticket_priority VALUES (3, '3 normal', '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
INSERT INTO ticket_priority VALUES (4, '4 high', '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
INSERT INTO ticket_priority VALUES (5, '5 very high', '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket_state`
#

DROP TABLE IF EXISTS ticket_state;
CREATE TABLE ticket_state (
  id smallint(6) NOT NULL auto_increment,
  name varchar(30) NOT NULL default '',
  comment varchar(80) default NULL,
  valid_id smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  type_id smallint(6) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket_state`
#

INSERT INTO ticket_state VALUES (1, 'new', 'ticket is new', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1, 1);
INSERT INTO ticket_state VALUES (2, 'closed successful', 'ticket is closed successful', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1, 3);
INSERT INTO ticket_state VALUES (3, 'closed unsuccessful', 'ticket is closed unsuccessful', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1, 3);
INSERT INTO ticket_state VALUES (4, 'open', 'ticket is open', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1, 2);
INSERT INTO ticket_state VALUES (5, 'removed', 'customer removed ticket (can reactivate)', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1, 6);
INSERT INTO ticket_state VALUES (6, 'pending reminder', 'ticket is pending for agent reminder', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1, 4);
INSERT INTO ticket_state VALUES (7, 'pending auto close+', 'ticket is pending for automatic close', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1, 5);
INSERT INTO ticket_state VALUES (8, 'pending auto close-', 'ticket is pending for automatic close', 1, '2003-01-07 23:01:22', 1, '2003-01-07 23:01:22', 1, 5);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `ticket_state_type`
#

DROP TABLE IF EXISTS ticket_state_type;
CREATE TABLE ticket_state_type (
  id smallint(6) NOT NULL auto_increment,
  name varchar(120) NOT NULL default '',
  comment varchar(250) default NULL,
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `ticket_state_type`
#

INSERT INTO ticket_state_type VALUES (1, 'new', 'all new state types (default: viewable)', '2003-04-14 15:44:48', 1, '2003-04-14 15:44:48', 1);
INSERT INTO ticket_state_type VALUES (2, 'open', 'all open state types (default: viewable)', '2003-04-14 15:44:48', 1, '2003-04-14 15:44:48', 1);
INSERT INTO ticket_state_type VALUES (3, 'closed', 'all closed state types (default: not viewable)', '2003-04-14 15:44:48', 1, '2003-04-14 15:44:48', 1);
INSERT INTO ticket_state_type VALUES (4, 'pending reminder', 'all "pending reminder" state types (default: viewable)', '2003-04-14 15:44:48', 1, '2003-04-14 15:44:48', 1);
INSERT INTO ticket_state_type VALUES (5, 'pending auto', 'all "pending auto *" state types (default: viewable)', '2003-04-14 15:44:48', 1, '2003-04-14 15:44:48', 1);
INSERT INTO ticket_state_type VALUES (6, 'removed', 'all "removed" state types (default: not viewable)', '2003-04-14 15:44:48', 1, '2003-04-14 15:44:48', 1);
# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `time_accounting`
#

DROP TABLE IF EXISTS time_accounting;
CREATE TABLE time_accounting (
  id bigint(20) NOT NULL auto_increment,
  ticket_id bigint(20) NOT NULL default '0',
  article_id bigint(20) default NULL,
  time_unit smallint(6) NOT NULL default '0',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY time_accouning_ticket_id (ticket_id)
) TYPE=MyISAM;

#
# Daten für Tabelle `time_accounting`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `user_preferences`
#

DROP TABLE IF EXISTS user_preferences;
CREATE TABLE user_preferences (
  user_id int(11) NOT NULL default '0',
  preferences_key varchar(100) NOT NULL default '',
  preferences_value varchar(250) default NULL,
  KEY index_user_preferences_user_id (user_id)
) TYPE=MyISAM;

#
# Daten für Tabelle `user_preferences`
#

# --------------------------------------------------------

#
# Tabellenstruktur für Tabelle `valid`
#

DROP TABLE IF EXISTS valid;
CREATE TABLE valid (
  id smallint(6) NOT NULL auto_increment,
  name varchar(25) NOT NULL default '',
  create_time datetime NOT NULL default '0000-00-00 00:00:00',
  create_by int(11) NOT NULL default '0',
  change_time datetime NOT NULL default '0000-00-00 00:00:00',
  change_by int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  UNIQUE KEY name (name)
) TYPE=MyISAM;

#
# Daten für Tabelle `valid`
#

INSERT INTO valid VALUES (1, 'valid', '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
INSERT INTO valid VALUES (2, 'invalid', '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);
INSERT INTO valid VALUES (3, 'invalid-temporarily', '2003-01-07 22:58:57', 1, '2003-01-07 22:58:57', 1);

