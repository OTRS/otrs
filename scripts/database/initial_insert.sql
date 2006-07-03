-- --
-- initial_insert.sql - provides initial system data
-- Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
-- --
-- $Id: initial_insert.sql,v 1.46 2006-07-03 13:40:04 martin Exp $
--
-- $Log: not supported by cvs2svn $
-- Revision 1.45  2006/03/28 05:50:02  martin
-- added responsible notes
--
-- Revision 1.44  2006/02/06 09:40:32  martin
-- moved to new tags
--
-- Revision 1.43  2006/02/05 20:20:56  martin
-- removed faq
--
-- Revision 1.42  2005/10/30 12:29:12  martin
-- removed not needed german default salutation and signature
--
-- Revision 1.41  2005/10/30 09:47:37  martin
-- added spaces for oracle init
--
-- Revision 1.40  2005/09/24 16:48:21  martin
-- moved to german "Sie" form in notifcations
--
-- Revision 1.39  2005/09/05 05:00:32  martin
-- moved to german "Ihr OTRS Benachrichtigungs-Master" wording
--
-- Revision 1.38  2005/04/22 08:00:38  martin
-- added ticket merge feature
--
-- Revision 1.37  2005/02/23 12:15:50  martin
-- added ticket_history_type SystemRequest for system creaetd tickets
--
-- Revision 1.36  2004/11/27 01:51:21  martin
-- changed default lines of shown message
--
-- Revision 1.35  2004/11/04 11:12:04  martin
-- removed not needed charset tabel, removed not existing queue_standard_response, added escalation_start_time to ticket insert, added queue_id to history recorde
--
-- Revision 1.34  2004/10/14 15:33:33  martin
-- fixed customer.pl in customer notifications
--
-- Revision 1.33  2004/10/13 12:46:21  martin
-- added number to faq_item table
--
-- Revision 1.32  2004/10/06 18:59:15  martin
-- updated notifications
--
-- Revision 1.31  2004/09/29 12:32:52  martin
-- fixed english "New ticket notification!", replaced OTRS_CURRENT_USERFIRSTNAME with OTRS_USERFIRSTNAME
--
-- Revision 1.30  2004/09/27 17:20:10  martin
-- fixed bug 548 - german spelling mistakes in agent notifications
--
-- Revision 1.29  2004/09/08 05:53:35  martin
-- fixed bug 516 - initial_insert.sql violates ticket_history "NOT NULL" contraints
--
-- Revision 1.28  2004/08/04 09:24:35  martin
-- moved customer notifications from Kernel/Config.pm to database
--
-- Revision 1.27  2004/08/01 10:49:24  martin
-- fixed bug 450 - Spelling mistake in default FAQ entry
--
-- Revision 1.26  2004/06/29 11:09:02  martin
-- fixed not existing queue_auto_response references
--
-- Revision 1.25  2004/05/04 15:12:10  martin
-- added ticket link history log
--
-- Revision 1.24  2004/04/15 08:43:14  martin
-- removed not needed ticket_history_types
--
-- Revision 1.23  2004/04/02 12:49:35  martin
-- added missing WebRequestCustomer ticket_history_type entry
--
-- Revision 1.22  2004/03/11 14:39:44  martin
-- added customer message quote
--
-- Revision 1.21  2004/02/26 23:34:55  martin
-- some agent notification typos
--
-- Revision 1.20  2004/02/12 08:18:02  martin
-- added customer email snip to escalation and reminder agent notifications
--
-- Revision 1.19  2004/02/08 22:22:51  martin
-- added escalation notification
--
-- Revision 1.18  2004/02/02 23:00:23  martin
-- removed not needed faq table, renamed comment to comments
--
-- Revision 1.17  2004/02/01 21:01:03  martin
-- added german notifications
--
-- Revision 1.16  2004/01/31 14:47:42  martin
-- replaced 8bit char with 7bit char for utf-8 compat.
--
-- Revision 1.15  2004/01/23 00:37:59  martin
-- moved agent notifications from config file to database
--
-- Revision 1.14  2004/01/22 19:26:42  martin
-- added faq inital inserts
--
-- Revision 1.12  2003/12/02 21:52:56  martin
-- fixed inital load of new user_group table
--
-- Revision 1.11  2003/11/19 01:32:04  martin
-- improved group sub system, added create, move, owner, priority and state permissions to groups
--
-- Revision 1.10  2003/04/30 12:47:42  martin
-- removed not needed stuff
--
-- Revision 1.9  2003/04/22 21:23:23  martin
-- added missing StateUpdate to ticket_history_type table
--
-- Revision 1.8  2003/04/12 21:34:12  martin
-- added log type for ticket free text update
--
-- Revision 1.7  2003/03/28 18:41:31  martin
-- fixed queue inital insert
--
-- Revision 1.6  2003/03/13 19:02:02  martin
-- changed docu.otrs.org to doc.otrs.org
--
-- Revision 1.5  2003/03/10 21:25:50  martin
-- added customer email notification on move, state update
--     or owner update (config option for each queue).
--     http://lists.otrs.org/pipermail/dev/2002-June/000005.html
--
-- Revision 1.4  2003/03/08 17:58:00  martin
-- changed reserved SQL words (read, write) to (permission_read, permission_write)
--
-- Revision 1.3  2003/03/03 23:41:45  martin
-- added ticket_state_type values and updated ticket_state values
--
-- Revision 1.2  2003/02/08 21:13:29  martin
-- added number prefix to priority for sort
--
-- Revision 1.1  2003/02/08 11:54:29  martin
-- moved from install/database to scripts/database
--
-- Revision 1.35  2003/01/06 21:40:51  martin
-- removed language table, not longer used
--
-- Revision 1.34  2002/12/25 09:31:39  martin
-- added pending states and removed waiting states
--
-- Revision 1.33  2002/12/15 00:58:21  martin
-- fixed "successful" typo - http://bugs.otrs.org/show_bug.cgi?id=53
--
-- Revision 1.32  2002/11/27 10:33:54  martin
-- removed old stuff and added Windows-1251 charset
--
-- Revision 1.31  2002/11/15 14:12:13  martin
-- added Dutch and Bulgarian translation!
--
-- Revision 1.30  2002/10/20 12:33:02  martin
-- removed personal_queues entry for root@localhost
--
-- Revision 1.29  2002/08/27 21:17:37  martin
-- changed OpenTRS to OTRS
--
-- Revision 1.28  2002/08/27 21:16:22  martin
-- added Cyrillic Charset (KOI8-R)
--
-- Revision 1.27  2002/07/31 23:17:23  martin
-- added time accounting feature
--
-- Revision 1.26  2002/07/25 20:21:28  martin
-- added iso-8859-7 - greek charset
--
-- Revision 1.25  2002/07/23 20:20:38  martin
-- removed test queues
--
-- Revision 1.24  2002/07/13 12:33:05  martin
-- added more articke types and more history types
--
-- Revision 1.23  2002/07/02 08:40:55  martin
-- added iso-8859-15
--
-- Revision 1.22  2002/06/15 20:01:28  martin
-- changed text of welcome ticket
--
-- Revision 1.21  2002/05/30 13:39:55  martin
-- fixed some stuff, added postgresql support.
--
-- Revision 1.20  2002/05/26 22:59:33  martin
-- added escalation_time and unlock_timeout to default queues,
--
-- Revision 1.19  2002/05/21 21:46:05  martin
-- changed default auto responses.
--
-- Revision 1.18  2002/05/14 00:18:19  martin
-- added ticket_history_type SendAgentNotification
--
-- Revision 1.17  2002/05/12 19:25:07  martin
-- added personal_queues for root user.
--
-- Revision 1.16  2002/05/09 23:39:20  martin
-- added French language and added queue_id to initial system address
--
-- Revision 1.15  2002/05/07 22:16:03  martin
-- added emty answer to each queue
--
-- Revision 1.14  2002/05/05 13:45:57  martin
-- added bavarian language.
--
-- Revision 1.13  2002/05/04 20:35:03  martin
-- renamed user table and removed comment row from user table.
--
-- Revision 1.12  2002/05/01 17:34:28  martin
-- added <OTRS_CUSTOMER_REALNAME> tags.
--
-- Revision 1.11  2002/04/30 00:14:48  martin
-- added stats group.
--
-- Revision 1.10  2002/04/14 18:25:17  martin
-- removed preferenvers from user table
--
-- Revision 1.9  2002/04/14 13:34:20  martin
-- replaced article type email with email-external
--
-- Revision 1.8  2002/04/08 14:17:40  martin
-- bin/PostMaster.pl
--
-- Revision 1.7  2002/02/03 22:48:20  martin
-- typo in welcome ticket.
--
-- Revision 1.6  2002/02/03 17:58:45  martin
-- added welcome ticket.
--
-- Revision 1.5  2002/01/30 16:45:09  martin
-- changed otrs@otrs.org to otrs@localhost
--
-- Revision 1.4  2002/01/20 22:23:55  martin
-- no note-normal anymore.
--
-- Revision 1.3  2002/01/10 20:14:00  martin
-- added cvs log.
--
--
-- --
-- This software comes with ABSOLUTELY NO WARRANTY. For details, see
-- the enclosed file COPYING for license information (GPL). If you
-- did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
-- --

-- table valid
INSERT INTO valid
    (name, create_by, create_time, change_by, change_time)
    VALUES
    ('valid', 1, current_timestamp, 1, current_timestamp);
INSERT INTO valid
    (name, create_by, create_time, change_by, change_time)
    VALUES
    ('invalid', 1, current_timestamp, 1, current_timestamp);
INSERT INTO valid
    (name, create_by, create_time, change_by, change_time)
    VALUES
    ('invalid-temporarily', 1, current_timestamp, 1, current_timestamp);

-- ticket_priority
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('1 very low', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('2 low', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('3 normal', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('4 high', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_priority
        (name, create_by, create_time, change_by, change_time)
        VALUES
        ('5 very high', 1, current_timestamp, 1, current_timestamp);

-- ticket_lock_type
INSERT INTO ticket_lock_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('unlock', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_lock_type
    (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('lock', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_lock_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('tmp_lock', 1, 1, current_timestamp, 1, current_timestamp);

-- user
INSERT INTO system_user
    (first_name, last_name, login, pw, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Admin', 'OTRS', 'root@localhost', 'roK20XGbWEsSM', 1, 1, current_timestamp, 1, current_timestamp);

-- groups
INSERT INTO groups
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('users',  1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO groups
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('admin',  1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO groups
    (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('stats',  1, 1, current_timestamp, 1, current_timestamp);

-- group_user (add admin to groups)
INSERT INTO group_user
    (user_id, group_id, permission_key, permission_value, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'rw', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO group_user
    (user_id, group_id, permission_key, permission_value, create_by, create_time, change_by, change_time)
    VALUES
    (1, 2, 'rw', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO group_user
    (user_id, group_id, permission_key, permission_value, create_by, create_time, change_by, change_time)
    VALUES
    (1, 3, 'rw', 1, 1, current_timestamp, 1, current_timestamp);

-- theme
INSERT INTO theme
    (theme, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Standard', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO theme
    (theme, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Lite', 1, 1, current_timestamp, 1, current_timestamp);

-- ticket_state
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('new', 'ticket is new', 1, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('closed successful', 'ticket is closed successful', 3, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('closed unsuccessful', 'ticket is closed unsuccessful', 3, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('open', 'ticket is open', 2, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('removed', 'customer removed ticket (can reactivate)', 6, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('pending reminder', 'ticket is pending for agent reminder', 4, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('pending auto close+', 'ticket is pending for automatic close', 5, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('pending auto close-', 'ticket is pending for automatic close', 5, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state (name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES ('merged', 'state for merged tickets', 7, 1, 1, current_timestamp, 1, current_timestamp);
-- ticket_state_type
INSERT INTO ticket_state_type (name, comments, create_by, create_time, change_by, change_time)
    VALUES
    ('new', 'all new state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comments, create_by, create_time, change_by, change_time)
    VALUES
    ('open', 'all open state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comments, create_by, create_time, change_by, change_time)
    VALUES
    ('closed', 'all closed state types (default: not viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comments, create_by, create_time, change_by, change_time)
    VALUES
    ('pending reminder', 'all "pending reminder" state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comments, create_by, create_time, change_by, change_time)
    VALUES
    ('pending auto', 'all "pending auto *" state types (default: viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comments, create_by, create_time, change_by, change_time)
    VALUES
    ('removed', 'all "removed" state types (default: not viewable)', 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_state_type (name, comments, create_by, create_time, change_by, change_time)
    VALUES
    ('merged', 'state type for merged tickets (default: not viewable)', 1, current_timestamp, 1, current_timestamp);

-- salutation
INSERT INTO salutation
    (name, text, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('system standard salutation (en)', 'Dear <OTRS_CUSTOMER_REALNAME>,Thank you for your request.', 'std. salutation', 1, 1, current_timestamp, 1, current_timestamp);

-- signature
INSERT INTO signature
    (name, text, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('system standard signature (en)', 'Your Ticket-Team - <OTRS_Agent_UserFirstname> <OTRS_Agent_UserLastname> -- Super Support - Waterford Business Park 5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA Email: hot@example.com - Web: http://www.example.com/--', 'std signature', 1, 1, current_timestamp, 1, current_timestamp);

-- system_address
INSERT INTO system_address
    (value0, value1, comments, valid_id, queue_id, create_by, create_time, change_by, change_time)
    VALUES
    ('otrs@localhost', 'OTRS System', 'Std. Address', 1, 1, 1, current_timestamp, 1, current_timestamp);

-- follow_up_possible
INSERT INTO follow_up_possible
    (name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('possible', 'Follow ups after closed(+|-) possible. Ticket will be reopen.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO follow_up_possible
    (name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('reject', 'Follow ups after closed(+|-) not possible. No new ticket will be created.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO follow_up_possible
    (name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('new ticket', 'Follow ups after closed(+|-) not possible. A new ticket will be created.', 1, 1, current_timestamp, 1, current_timestamp);

-- queue
INSERT INTO queue
    (name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, escalation_time, unlock_timeout, move_notify, lock_notify, state_notify, owner_notify, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Postmaster', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'master queue', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue
    (name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, escalation_time, unlock_timeout, move_notify, lock_notify, state_notify, owner_notify, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Raw', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'all incoming tickets', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue
    (name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, escalation_time, unlock_timeout, move_notify, lock_notify, state_notify, owner_notify, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Junk', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'all junk tickets', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue
    (name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, escalation_time, unlock_timeout, move_notify, lock_notify, state_notify, owner_notify, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Misc', 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 'all misk tickets', 1, 1, current_timestamp, 1, current_timestamp);

-- ticket_history_type
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('NewTicket', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('FollowUp', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAutoReject', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAutoReply', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAutoFollowUp', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Forward', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Bounce', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAnswer', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendAgentNotification', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SendCustomerNotification', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('EmailAgent', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('EmailCustomer', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('PhoneCallAgent', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('PhoneCallCustomer', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('AddNote', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Move', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Lock', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Unlock', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Remove', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TimeAccounting', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('CustomerUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('PriorityUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('OwnerUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('LoopProtection', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Misc', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SetPendingTime', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('StateUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TicketFreeTextUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('WebRequestCustomer', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TicketLinkAdd', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('TicketLinkDelete', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('SystemRequest', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Merged', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('ResponsibleUpdate', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Subscribe', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO ticket_history_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('Unsubscribe', 1, 1, current_timestamp, 1, current_timestamp);

-- article_type
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-external', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-internal', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-notification-ext', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('email-notification-int', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('phone', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('fax', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('sms', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('webrequest', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('note-internal', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('note-external', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('note-report', 1, 1, current_timestamp, 1, current_timestamp);

-- article_article_sender_type
INSERT INTO article_sender_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('agent', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_sender_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('system', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO article_sender_type
        (name, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('customer', 1, 1, current_timestamp, 1, current_timestamp);

-- standard_response
INSERT INTO standard_response
        (name, text, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('empty answer', '', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO standard_response
        (name, text, valid_id, create_by, create_time, change_by, change_time)
        VALUES
        ('test answer', 'test answer ...', 1, 1, current_timestamp, 1, current_timestamp);

-- queue_standard_response
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO queue_standard_response
    (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 1, 1, current_timestamp, 1, current_timestamp);

-- auto_response_type
INSERT INTO auto_response_type
    (name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto reply', 'auto replay after a new ticket.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO auto_response_type
    (name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto reject', 'auto reject.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO auto_response_type
    (name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto follow up', 'auto follow up after a follow up.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO auto_response_type
    (name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto reply/new ticket', 'auto reply after a follow up. Because the ticket is closed.', 1, 1, current_timestamp, 1, current_timestamp);
INSERT INTO auto_response_type
    (name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('auto remove', 'auto remove after a remove e-mail.', 1, 1, current_timestamp, 1, current_timestamp);

-- auto_response
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset, comments, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (1, 1, 'default reply (after new ticket)', 'This is a demo text which is send to every inquery.It could contain something like:Thanks for your e-mail. A new ticket has been created.You wrote:<OTRS_CUSTOMER_EMAIL[6]>Your e-mail will be answered by a human asapHave fun with OTRS! :-)  Your OTRS Team', 'RE: <OTRS_CUSTOMER_SUBJECT[20]>', 'iso-8859-1', 'default', 1, current_timestamp, 1, current_timestamp, 1);
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset, comments, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (2, 1, 'default close (after rejected a closed ticket)', 'Reject.', 'thank you for your e-mail. But you forgot importand infos. Pleace write again with all informations. Thanks', 'iso-8859-1', 'default', 1, current_timestamp, 1, current_timestamp, 1);
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset, comments, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (3, 1, 'default follow up (after a ticket follow up)', 'Thanks for your follow up e-mailYou wrote:<OTRS_CUSTOMER_EMAIL[6]>Your e-mail will be answered by a human asap.Have fun with OTRS!Your OTRS Team', 'RE: <OTRS_CUSTOMER_SUBJECT[20]>', 'iso-8859-1', 'default', 1, current_timestamp, 1, current_timestamp, 1);
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset, comments, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (4, 1, 'default close/new ticket (after closed follow up with new ticket creation)', 'New ticket after follow up.', 'thank you for your e-mail. The old ticket is closed. You have a new ticket now.', 'iso-8859-1', 'default', 1, current_timestamp, 1, current_timestamp, 1);
INSERT INTO auto_response
    (type_id, system_address_id, name, text0, text1, charset, comments, valid_id, create_time, create_by, change_time, change_by)
    VALUES
    (5, 1, 'default remove (after a ticket got removed)', 'Ticket removed.', 'thank you for your remove e-mail. The ticket is closed.', 'iso-8859-1', 'default', 1, current_timestamp, 1, current_timestamp, 1);

-- --
-- welcome ticket
-- 2002-02-03 added by martin+code at otrs.org
-- --
INSERT INTO article
  (ticket_id, article_type_id, article_sender_type_id, a_from, a_to, a_subject, a_message_id, a_body, incoming_time, content_path, valid_id, create_time, create_by, change_time, change_by)
  VALUES
  (1,1,3, 'OTRS Feedback <feedback@otrs.org>', 'Your OTRS System <otrs@localhost>',
  'Welcome to OTRS!', '<007@localhost>',
  'Welcome to OTRS!thank you for installing OTRS.You will find updates and patches at http://otrs.org/. Onlinedocumentation is available at http://doc.otrs.org/. You can alsotake advantage of our mailing lists http://lists.otrs.org/.Your OTRS Team    Manage your communication!',
  1012757943, '2002/02/3', 1, current_timestamp,1,current_timestamp,1);

INSERT INTO ticket
  (tn, queue_id, ticket_lock_id, ticket_answered, user_id, group_id, ticket_priority_id, ticket_state_id, valid_id, create_time_unix, escalation_start_time, create_time, create_by, change_time, change_by)
  VALUES
  ('1010001', 2, 1, 0, 1, 1, 3, 1, 1, 1012757943, 0, current_timestamp, 1, current_timestamp, 1);

INSERT INTO ticket_history
  (name, history_type_id, ticket_id, article_id, priority_id, owner_id, state_id, queue_id, valid_id, create_time, create_by, change_time, change_by)
  VALUES
  ('New Ticket [1010001] created.',1,1,1,3,1,1,1,1, current_timestamp,1,current_timestamp,1);

--
-- insert agent notifications
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::NewTicket', 'iso-8859-1', 'en', 'New ticket notification! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,there is a new ticket in "<OTRS_TICKET_QUEUE>"!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::FollowUp', 'iso-8859-1', 'en', 'You got follow up! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,you got a follow up!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::LockTimeout', 'iso-8859-1', 'en', 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,unlocked (lock timeout) your locked ticket [<OTRS_TICKET_TicketNumber>].<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip> <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::OwnerUpdate', 'iso-8859-1', 'en', 'Ticket owner assigned to you! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,a ticket [<OTRS_TICKET_TicketNumber>] is assigned to you by "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>".Comment:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::ResponsibleUpdate', 'iso-8859-1', 'en', 'Ticket responsible assigned to you! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_RESPONSIBLE_USERFIRSTNAME>,a ticket [<OTRS_TICKET_TicketNumber>] is assigned to you by "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>".Comment:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::AddNote', 'iso-8859-1', 'en', 'New note! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" added a new note to ticket [<OTRS_TICKET_TicketNumber>].Note:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Move', 'iso-8859-1', 'en', 'Moved ticket in "<OTRS_CUSTOMER_QUEUE>" queue! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" moved a ticket [<OTRS_TICKET_TicketNumber>] into "<OTRS_CUSTOMER_QUEUE>".<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::PendingReminder', 'iso-8859-1', 'en', 'Ticket Reminder!', 'Hi <OTRS_OWNER_USERFIRSTNAME>,the ticket "<OTRS_TICKET_TicketNumber>" has reached the reminder time!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Escalation', 'iso-8859-1', 'en', 'Ticket Escalation!', 'Hi <OTRS_USERFIRSTNAME>,the ticket "<OTRS_TICKET_TicketNumber>" is escaleted!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[16]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', current_timestamp, 1, current_timestamp, 1);


INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::NewTicket', 'iso-8859-1', 'de', 'Neues Ticket! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,es ist ein neues Ticket in "<OTRS_TICKET_QUEUE>"!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::FollowUp', 'iso-8859-1', 'de', 'Nachfrage! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,Sie haben eine Nachfrage bekommen!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::LockTimeout', 'iso-8859-1', 'de', 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,Aufhebung der Sperre auf Dein gesperrtes Ticket [<OTRS_TICKET_TicketNumber>].<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip> <OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::OwnerUpdate', 'iso-8859-1', 'de', 'Ticket Besitz uebertragen an Sie! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,der Besitz des Tickets [<OTRS_TICKET_TicketNumber>] wurde an Sie von "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" uebertragen.Kommentar:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::ResponsibleUpdate', 'iso-8859-1', 'de', 'Ticket Verantwortung uebertragen an Sie! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_RESPONSIBLE_USERFIRSTNAME>,die Verantwortung des Tickets [<OTRS_TICKET_TicketNumber>] wurde an Sie von "<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" uebertragen.Kommentar:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::AddNote', 'iso-8859-1', 'de', 'Neue Notiz! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_OWNER_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" fuegte eine Notiz an Ticket [<OTRS_TICKET_TicketNumber>].Notiz:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Move', 'iso-8859-1', 'de', 'Ticket verschoben in "<OTRS_CUSTOMER_QUEUE>" Queue! (<OTRS_CUSTOMER_SUBJECT[18]>)', 'Hi <OTRS_USERFIRSTNAME>,"<OTRS_CURRENT_USERFIRSTNAME> <OTRS_CURRENT_USERLASTNAME>" verschob Ticket [<OTRS_TICKET_TicketNumber>] nach "<OTRS_CUSTOMER_QUEUE>".<snip><OTRS_CUSTOMER_EMAIL[16]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::PendingReminder', 'iso-8859-1', 'de', 'Ticket Erinnerung!', 'Hi <OTRS_OWNER_USERFIRSTNAME>,das Ticket "<OTRS_TICKET_TicketNumber>" hat die Erinnerungszeit erreicht!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip>Bitte um weitere Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Agent::Escalation', 'iso-8859-1', 'de', 'Ticket Eskalation!', 'Hi <OTRS_USERFIRSTNAME>,das Ticket "<OTRS_TICKET_TicketNumber>" ist eskaliert!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[16]><snip>MBitte um Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', current_timestamp, 1, current_timestamp, 1);

--
-- customer notifications (en)
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::QueueUpdate', 'iso-8859-1', 'en', 'New Queue "<OTRS_TICKET_Queue>"!', '*** THIS IS JUST A NOTE ***The queue of your ticket "<OTRS_TICKET_TicketNumber>" has been changed by"<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>" to "<OTRS_TICKET_Queue>".<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master*** THIS IS JUST A NOTE ***', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::OwnerUpdate', 'iso-8859-1', 'en', 'New Owner "<OTRS_OWNER_UserFirstname>"!', '*** THIS IS JUST A NOTE ***The owner of your ticket "<OTRS_TICKET_TicketNumber>" has been changed to"<OTRS_OWNER_UserFirstname> <OTRS_OWNER_UserLastname>.<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master*** THIS IS JUST A NOTE ***', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::StateUpdate', 'iso-8859-1', 'en', 'New State "<OTRS_TICKET_State>"!', '*** THIS IS JUST A NOTE ***The state of your ticket "<OTRS_TICKET_TicketNumber>" has been changed by"<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>" to "<OTRS_TICKET_State>".<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master*** THIS IS JUST A NOTE ***', current_timestamp, 1, current_timestamp, 1);

--
-- customer notifications (de)
--
INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::QueueUpdate', 'iso-8859-1', 'de', 'Neue Queue "<OTRS_TICKET_Queue>"!', '*** NUR EINE INFO ***Die Queue Ihres Tickets "<OTRS_TICKET_TicketNumber>" hat "<OTRS_CUSTOMER_UserFirstname> <OTRS_CUSTOMER_UserLastname>" auf "<OTRS_TICKET_Queue>" geaendert.<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master*** NUR EINE INFO ***', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::OwnerUpdate', 'iso-8859-1', 'de', 'Neuer Besitzer "<OTRS_OWNER_UserFirstname>"!', '*** NUR EINE INFO ***Der Besitzer des Tickets "<OTRS_TICKET_TicketNumber>" hat sich auf "<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> geaendert.<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master*** NUR EINE INFO ***', current_timestamp, 1, current_timestamp, 1);

INSERT INTO notifications
  (notification_type, notification_charset, notification_language, subject, text, create_time, create_by, change_time, change_by)
  VALUES
  ('Customer::StateUpdate', 'iso-8859-1', 'de', 'Neuer Status "<OTRS_TICKET_State>"!', '*** NUR EINE INFO ***Der Status des Tickets "<OTRS_TICKET_TicketNumber>" hat sich durch "<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>" auf "<OTRS_TICKET_State>" veraendert.<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>customer.pl?Action=CustomerZoom&TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master*** NUR EINE INFO ***', current_timestamp, 1, current_timestamp, 1);

