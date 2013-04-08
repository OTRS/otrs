# ----------------------------------------------------------
#  driver: mysql, generated: 2013-03-27 16:42:56
# ----------------------------------------------------------
# ----------------------------------------------------------
#  insert into table valid
# ----------------------------------------------------------
INSERT INTO valid (id, name, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'valid', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table valid
# ----------------------------------------------------------
INSERT INTO valid (id, name, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'invalid', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table valid
# ----------------------------------------------------------
INSERT INTO valid (id, name, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'invalid-temporarily', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table users
# ----------------------------------------------------------
INSERT INTO users (id, first_name, last_name, login, pw, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'Admin', 'OTRS', 'root@localhost', 'roK20XGbWEsSM', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table groups
# ----------------------------------------------------------
INSERT INTO groups (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'users', 'Group for default access.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table groups
# ----------------------------------------------------------
INSERT INTO groups (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'admin', 'Group of all administrators.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table groups
# ----------------------------------------------------------
INSERT INTO groups (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'stats', 'Group for statistics access.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table group_user
# ----------------------------------------------------------
INSERT INTO group_user (user_id, group_id, permission_key, permission_value, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'rw', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table group_user
# ----------------------------------------------------------
INSERT INTO group_user (user_id, group_id, permission_key, permission_value, create_by, create_time, change_by, change_time)
    VALUES
    (1, 2, 'rw', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table group_user
# ----------------------------------------------------------
INSERT INTO group_user (user_id, group_id, permission_key, permission_value, create_by, create_time, change_by, change_time)
    VALUES
    (1, 3, 'rw', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table link_type
# ----------------------------------------------------------
INSERT INTO link_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Normal', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table link_type
# ----------------------------------------------------------
INSERT INTO link_type (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('ParentChild', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table link_state
# ----------------------------------------------------------
INSERT INTO link_state (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Valid', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table link_state
# ----------------------------------------------------------
INSERT INTO link_state (name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    ('Temporary', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state_type
# ----------------------------------------------------------
INSERT INTO ticket_state_type (id, name, comments, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'new', 'All new state types (default: viewable).', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state_type
# ----------------------------------------------------------
INSERT INTO ticket_state_type (id, name, comments, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'open', 'All open state types (default: viewable).', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state_type
# ----------------------------------------------------------
INSERT INTO ticket_state_type (id, name, comments, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'closed', 'All closed state types (default: not viewable).', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state_type
# ----------------------------------------------------------
INSERT INTO ticket_state_type (id, name, comments, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'pending reminder', 'All \'pending reminder\' state types (default: viewable).', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state_type
# ----------------------------------------------------------
INSERT INTO ticket_state_type (id, name, comments, create_by, create_time, change_by, change_time)
    VALUES
    (5, 'pending auto', 'All \'pending auto *\' state types (default: viewable).', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state_type
# ----------------------------------------------------------
INSERT INTO ticket_state_type (id, name, comments, create_by, create_time, change_by, change_time)
    VALUES
    (6, 'removed', 'All \'removed\' state types (default: not viewable).', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state_type
# ----------------------------------------------------------
INSERT INTO ticket_state_type (id, name, comments, create_by, create_time, change_by, change_time)
    VALUES
    (7, 'merged', 'State type for merged tickets (default: not viewable).', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'new', 'New ticket created by customer.', 1, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'closed successful', 'Ticket is closed successful.', 3, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'closed unsuccessful', 'Ticket is closed unsuccessful.', 3, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'open', 'Open tickets.', 2, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (5, 'removed', 'Customer removed ticket.', 6, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (6, 'pending reminder', 'Ticket is pending for agent reminder.', 4, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (7, 'pending auto close+', 'Ticket is pending for automatic close.', 5, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (8, 'pending auto close-', 'Ticket is pending for automatic close.', 5, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_state
# ----------------------------------------------------------
INSERT INTO ticket_state (id, name, comments, type_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (9, 'merged', 'State for merged tickets.', 7, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table salutation
# ----------------------------------------------------------
INSERT INTO salutation (id, name, text, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'system standard salutation (en)', 'Dear <OTRS_CUSTOMER_REALNAME>,Thank you for your request.', 'text/plain\; charset=utf-8', 'Standard Salutation.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table signature
# ----------------------------------------------------------
INSERT INTO signature (id, name, text, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'system standard signature (en)', 'Your Ticket-Team <OTRS_Agent_UserFirstname> <OTRS_Agent_UserLastname>-- Super Support - Waterford Business Park 5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA Email: hot@example.com - Web: http://www.example.com/--', 'text/plain\; charset=utf-8', 'Standard Signature.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table system_address
# ----------------------------------------------------------
INSERT INTO system_address (id, value0, value1, comments, valid_id, queue_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'otrs@localhost', 'OTRS System', 'Standard Address.', 1, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table follow_up_possible
# ----------------------------------------------------------
INSERT INTO follow_up_possible (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'possible', 'Follow ups after closed(+|-) possible. Ticket will be reopen.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table follow_up_possible
# ----------------------------------------------------------
INSERT INTO follow_up_possible (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'reject', 'Follow ups after closed(+|-) not possible. No new ticket will be created.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table follow_up_possible
# ----------------------------------------------------------
INSERT INTO follow_up_possible (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'new ticket', 'Follow ups after closed(+|-) not possible. A new ticket will be created..', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue
# ----------------------------------------------------------
INSERT INTO queue (id, name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, unlock_timeout, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'Postmaster', 1, 1, 1, 1, 1, 1, 0, 'Postmaster queue.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue
# ----------------------------------------------------------
INSERT INTO queue (id, name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, unlock_timeout, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'Raw', 1, 1, 1, 1, 1, 1, 0, 'All default incoming tickets.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue
# ----------------------------------------------------------
INSERT INTO queue (id, name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, unlock_timeout, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'Junk', 1, 1, 1, 1, 1, 1, 0, 'All junk tickets.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue
# ----------------------------------------------------------
INSERT INTO queue (id, name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, unlock_timeout, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'Misc', 1, 1, 1, 1, 1, 1, 0, 'All misc tickets.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table standard_response
# ----------------------------------------------------------
INSERT INTO standard_response (id, name, text, content_type, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'empty answer', '', 'text/plain\; charset=utf-8', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table standard_response
# ----------------------------------------------------------
INSERT INTO standard_response (id, name, text, content_type, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'test answer', 'Some test answer to show how a standard response can be used.', 'text/plain\; charset=utf-8', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue_standard_response
# ----------------------------------------------------------
INSERT INTO queue_standard_response (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue_standard_response
# ----------------------------------------------------------
INSERT INTO queue_standard_response (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue_standard_response
# ----------------------------------------------------------
INSERT INTO queue_standard_response (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue_standard_response
# ----------------------------------------------------------
INSERT INTO queue_standard_response (queue_id, standard_response_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'auto reply', 'Auto reply which will be sent out after a new ticket has been created.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'auto reject', 'Auto reject which will be sent out after a follow up has been rejected (in case queue follow up option is "reject").', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'auto follow up', 'Auto follow up is sent out after a follow up has been received for a ticket (in case queue follow up option is "possible").', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'auto reply/new ticket', 'Auto reply/new ticket which will be sent out after a follow up has been rejected and a new ticket has been created (in case queue follow up option is "new ticket").', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (5, 'auto remove', 'Auto remove will be sent out after a customer removed the request.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response
# ----------------------------------------------------------
INSERT INTO auto_response (id, type_id, system_address_id, name, text0, text1, charset, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, 'default reply (after new ticket has been created)', 'This is a demo text which is send to every inquiry.It could contain something like:Thanks for your email. A new ticket has been created.You wrote:<OTRS_CUSTOMER_EMAIL[6]>Your email will be answered by a human ASAPHave fun with OTRS! :-)Your OTRS Team', 'RE: <OTRS_CUSTOMER_SUBJECT[24]>', 'utf-8', 'text/plain', '', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response
# ----------------------------------------------------------
INSERT INTO auto_response (id, type_id, system_address_id, name, text0, text1, charset, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 2, 1, 'default reject (after follow up and rejected of a closed ticket)', 'Your previous ticket is closed.-- Your follow up has been rejected. --Please create a new ticket.Your OTRS Team', 'Your email has been rejected! (RE: <OTRS_CUSTOMER_SUBJECT[24]>)', 'utf-8', 'text/plain', '', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response
# ----------------------------------------------------------
INSERT INTO auto_response (id, type_id, system_address_id, name, text0, text1, charset, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 3, 1, 'default follow up (after a ticket follow up has been added)', 'Thanks for your follow up emailYou wrote:<OTRS_CUSTOMER_EMAIL[6]>Your email will be answered by a human ASAP.Have fun with OTRS!Your OTRS Team', 'RE: <OTRS_CUSTOMER_SUBJECT[24]>', 'utf-8', 'text/plain', '', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response
# ----------------------------------------------------------
INSERT INTO auto_response (id, type_id, system_address_id, name, text0, text1, charset, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 4, 1, 'default reject/new ticket created (after closed follow up with new ticket creation)', 'Your previous ticket is closed.-- A new ticket has been created for you. --You wrote:<OTRS_CUSTOMER_EMAIL[6]>Your email will be answered by a human ASAP.Have fun with OTRS!Your OTRS Team', 'New ticket has been created! (RE: <OTRS_CUSTOMER_SUBJECT[24]>)', 'utf-8', 'text/plain', '', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_type
# ----------------------------------------------------------
INSERT INTO ticket_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'default', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_priority
# ----------------------------------------------------------
INSERT INTO ticket_priority (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, '1 very low', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_priority
# ----------------------------------------------------------
INSERT INTO ticket_priority (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, '2 low', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_priority
# ----------------------------------------------------------
INSERT INTO ticket_priority (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, '3 normal', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_priority
# ----------------------------------------------------------
INSERT INTO ticket_priority (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, '4 high', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_priority
# ----------------------------------------------------------
INSERT INTO ticket_priority (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (5, '5 very high', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_lock_type
# ----------------------------------------------------------
INSERT INTO ticket_lock_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'unlock', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_lock_type
# ----------------------------------------------------------
INSERT INTO ticket_lock_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'lock', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_lock_type
# ----------------------------------------------------------
INSERT INTO ticket_lock_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'tmp_lock', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'NewTicket', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'FollowUp', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'SendAutoReject', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'SendAutoReply', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (5, 'SendAutoFollowUp', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (6, 'Forward', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (7, 'Bounce', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (8, 'SendAnswer', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (9, 'SendAgentNotification', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (10, 'SendCustomerNotification', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (11, 'EmailAgent', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (12, 'EmailCustomer', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (13, 'PhoneCallAgent', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (14, 'PhoneCallCustomer', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (15, 'AddNote', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (16, 'Move', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (17, 'Lock', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (18, 'Unlock', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (19, 'Remove', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (20, 'TimeAccounting', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (21, 'CustomerUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (22, 'PriorityUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (23, 'OwnerUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (24, 'LoopProtection', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (25, 'Misc', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (26, 'SetPendingTime', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (27, 'StateUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (28, 'TicketDynamicFieldUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (29, 'WebRequestCustomer', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (30, 'TicketLinkAdd', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (31, 'TicketLinkDelete', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (32, 'SystemRequest', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (33, 'Merged', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (34, 'ResponsibleUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (35, 'Subscribe', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (36, 'Unsubscribe', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (37, 'TypeUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (38, 'ServiceUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (39, 'SLAUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (40, 'ArchiveFlagUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (41, 'EscalationSolutionTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (42, 'EscalationResponseTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (43, 'EscalationUpdateTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (44, 'EscalationSolutionTimeStart', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (45, 'EscalationResponseTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (46, 'EscalationUpdateTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (47, 'EscalationSolutionTimeNotifyBefore', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (48, 'EscalationResponseTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (49, 'EscalationUpdateTimeStop', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (50, 'TitleUpdate', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'email-external', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'email-internal', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'email-notification-ext', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'email-notification-int', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (5, 'phone', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (6, 'fax', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (7, 'sms', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (8, 'webrequest', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (9, 'note-internal', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (10, 'note-external', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_type
# ----------------------------------------------------------
INSERT INTO article_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (11, 'note-report', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_sender_type
# ----------------------------------------------------------
INSERT INTO article_sender_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'agent', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_sender_type
# ----------------------------------------------------------
INSERT INTO article_sender_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'system', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_sender_type
# ----------------------------------------------------------
INSERT INTO article_sender_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'customer', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket
# ----------------------------------------------------------
INSERT INTO ticket (id, tn, queue_id, ticket_lock_id, user_id, responsible_user_id, ticket_priority_id, ticket_state_id, title, create_time_unix, timeout, until_time, escalation_time, escalation_response_time, escalation_update_time, escalation_solution_time, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, '2010080210123456', 2, 1, 1, 1, 3, 1, 'Welcome to OTRS!', 1280750400, 0, 0, 0, 0, 0, 0, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article
# ----------------------------------------------------------
INSERT INTO article (id, ticket_id, article_type_id, article_sender_type_id, a_from, a_to, a_subject, a_body, a_message_id, incoming_time, content_path, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, 3, 'OTRS Feedback <feedback@otrs.org>', 'Your OTRS System <otrs@localhost>', 'Welcome to OTRS!', 'Welcome!Thank you for installing OTRS.You will find updates and patches at http://www.otrs.com/open-source/.Online documentation is available at http://doc.otrs.org/.You can also use our mailing lists http://lists.otrs.org/or our forums at http://forums.otrs.org/Regards,The OTRS Project', '<007@localhost>', 1280750400, '2010/08/02', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_plain
# ----------------------------------------------------------
INSERT INTO article_plain (id, article_id, body, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'From: OTRS Feedback <feedback@otrs.org>To: Your OTRS System <otrs@localhost>Subject: Welcome to OTRS!Welcome!Thank you for installing OTRS.You will find updates and patches at http://www.otrs.com/open-source/.Online documentation is available at http://doc.otrs.org/.You can also use our mailing lists http://lists.otrs.org/or our forums at http://forums.otrs.org/Regards,The OTRS Project', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history
# ----------------------------------------------------------
INSERT INTO ticket_history (id, name, history_type_id, ticket_id, type_id, article_id, priority_id, owner_id, state_id, queue_id, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'New Ticket [2010080210123456] created.', 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::NewTicket', 'utf-8', 'en', 'New ticket notification! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,There is a new ticket in <OTRS_TICKET_Queue>!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::FollowUp', 'utf-8', 'en', 'You\'ve got a follow up! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,You\'ve got a follow up!<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::LockTimeout', 'utf-8', 'en', 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,The lock timeout period on [<OTRS_TICKET_TicketNumber>] has been reached, it is now unlocked.<OTRS_CUSTOMER_FROM> wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::OwnerUpdate', 'utf-8', 'en', 'Ticket owner assigned to you! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,Ticket [<OTRS_TICKET_TicketNumber>] is assigned to you by <OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>.Comment:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::ResponsibleUpdate', 'utf-8', 'en', 'Ticket assigned to you! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_RESPONSIBLE_UserFirstname>,Ticket [<OTRS_TICKET_TicketNumber>] is assigned to you by <OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>.Comment:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::AddNote', 'utf-8', 'en', 'New note! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> added a new note to ticket [<OTRS_TICKET_TicketNumber>].Note:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::Move', 'utf-8', 'en', 'Moved ticket in <OTRS_CUSTOMER_QUEUE> queue! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> moved a ticket [<OTRS_TICKET_TicketNumber>] into <OTRS_CUSTOMER_QUEUE>.<snip><OTRS_CUSTOMER_EMAIL[30]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::PendingReminder', 'utf-8', 'en', 'Ticket reminder has reached! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,The ticket [<OTRS_TICKET_TicketNumber>] has reached its reminder time!<OTRS_CUSTOMER_FROM>wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::Escalation', 'utf-8', 'en', 'Ticket Escalation! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,The ticket [<OTRS_TICKET_TicketNumber>] is escalated!Escalated at:    <OTRS_TICKET_EscalationDestinationDate>Escalated since: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'utf-8', 'en', 'Ticket Escalation Warning! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hi <OTRS_UserFirstname>,The ticket [<OTRS_TICKET_TicketNumber>] will escalate!Escalation at: <OTRS_TICKET_EscalationDestinationDate>Escalation in: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>wrote:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Please have a look at:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Your OTRS Notification Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::NewTicket', 'utf-8', 'de', 'Neues Ticket! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,es ist ein neues Ticket in <OTRS_TICKET_Queue>!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::FollowUp', 'utf-8', 'de', 'Nachfrage! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,Sie haben eine Nachfrage bekommen!<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::LockTimeout', 'utf-8', 'de', 'Lock Timeout! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,Aufhebung der Sperre auf Dein gesperrtes Ticket [<OTRS_TICKET_TicketNumber>].<OTRS_CUSTOMER_FROM> schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::OwnerUpdate', 'utf-8', 'de', 'Ticket Besitz uebertragen an Sie! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,Der Besitz des Tickets [<OTRS_TICKET_TicketNumber>] wurde an Sie von <OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> uebertragen.Kommentar:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::ResponsibleUpdate', 'utf-8', 'de', 'Ticket Verantwortung uebertragen an Sie! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_RESPONSIBLE_UserFirstname> <OTRS_RESPONSIBLE_UserLastname>,Die Verantwortung des Tickets [<OTRS_TICKET_TicketNumber>] wurde an Sie von <OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> uebertragen.Kommentar:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::AddNote', 'utf-8', 'de', 'Neue Notiz! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> fuegte eine Notiz an Ticket [<OTRS_TICKET_TicketNumber>].Notiz:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::Move', 'utf-8', 'de', 'Ticket verschoben in "<OTRS_CUSTOMER_QUEUE>" Queue! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> verschob Ticket [<OTRS_TICKET_TicketNumber>] nach "<OTRS_CUSTOMER_QUEUE>".<snip><OTRS_CUSTOMER_EMAIL[30]><snip><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::PendingReminder', 'utf-8', 'de', 'Ticket Erinnerung erreicht! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,das Ticket [<OTRS_TICKET_TicketNumber>] hat die Erinnerungszeit erreicht!<OTRS_CUSTOMER_FROM>schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Bitte um weitere Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::Escalation', 'utf-8', 'de', 'Ticket Eskalation! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,das Ticket [<OTRS_TICKET_TicketNumber>] ist eskaliert!Eskaliert am:   <OTRS_TICKET_EscalationDestinationDate>Eskaliert seit: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Bitte um Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'utf-8', 'de', 'Ticket Eskalations-Warnung! (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Hallo <OTRS_UserFirstname> <OTRS_UserLastname>,das Ticket [<OTRS_TICKET_TicketNumber>] wird bald eskalieren!Eskalation um: <OTRS_TICKET_EscalationDestinationDate>Eskalation in: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM>schrieb:<snip><OTRS_CUSTOMER_EMAIL[30]><snip>Bitte um Bearbeitung:<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>Ihr OTRS Benachrichtigungs-Master', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::NewTicket', 'utf-8', 'nl', 'Nieuw ticket (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,Er is een nieuw ticket aangemaakt in <OTRS_TICKET_Queue>!<OTRS_CUSTOMER_FROM> schreef:<OTRS_CUSTOMER_EMAIL[30]>(eerste 30 regels zijn weergegeven)<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::FollowUp', 'utf-8', 'nl', 'Reactie ontvangen (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,Er is een reactie ontvangen op onderstaand ticket.<OTRS_CUSTOMER_FROM> schreef:<OTRS_CUSTOMER_EMAIL[30]>(eerste 30 regels zijn weergegeven)<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::LockTimeout', 'utf-8', 'nl', 'Ticket ontgrendeld (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,De bewerkingstijd van ticket [<OTRS_TICKET_TicketNumber>] is overschreden, het ticket is nu ontgrendeld.<OTRS_CUSTOMER_FROM> schreef:<OTRS_CUSTOMER_EMAIL[30]>(eerste 30 regels zijn weergegeven)<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::OwnerUpdate', 'utf-8', 'nl', 'Ticket toegewezen (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,Ticket [<OTRS_TICKET_TicketNumber>] is aan jou toegewezen door <OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname>.Opmerking:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::ResponsibleUpdate', 'utf-8', 'nl', 'Verantwoordelijkheid bijgewerkt (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_RESPONSIBLE_UserFirstname>,<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> heeft je geregistreerd als verantwoordelijke voor ticket [<OTRS_TICKET_TicketNumber>].Opmerking:<OTRS_COMMENT><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::AddNote', 'utf-8', 'nl', 'Nieuwe notitie (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> heeft een nieuwe notitie toegevoegd aan [<OTRS_TICKET_TicketNumber>].Notitie:<OTRS_CUSTOMER_BODY><OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::Move', 'utf-8', 'nl', 'Ticket verplaatst naar <OTRS_CUSTOMER_QUEUE> (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,<OTRS_CURRENT_UserFirstname> <OTRS_CURRENT_UserLastname> heeft [<OTRS_TICKET_TicketNumber>] verplaatst naar <OTRS_CUSTOMER_QUEUE>.<OTRS_CUSTOMER_EMAIL[30]>(eerste 30 regels zijn weergegeven)<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::PendingReminder', 'utf-8', 'nl', 'Herinnering (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,Het herinnermoment voor ticket [<OTRS_TICKET_TicketNumber>] is bereikt.<OTRS_CUSTOMER_FROM> schreef:<OTRS_CUSTOMER_EMAIL[30]>(eerste 30 regels zijn weergegeven)<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::Escalation', 'utf-8', 'nl', 'Escalatie (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,Het ticket [<OTRS_TICKET_TicketNumber>] is geëscaleerd!Geëscaleerd op:    <OTRS_TICKET_EscalationDestinationDate>Geëscaleerd sinds: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM> schreef:<OTRS_CUSTOMER_EMAIL[30]>(eerste 30 regels zijn weergegeven)<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notifications
# ----------------------------------------------------------
INSERT INTO notifications (notification_type, notification_charset, notification_language, subject, text, content_type, create_by, create_time, change_by, change_time)
    VALUES
    ('Agent::EscalationNotifyBefore', 'utf-8', 'nl', 'Ticket gaat escaleren (<OTRS_CUSTOMER_SUBJECT[24]>)', 'Beste <OTRS_UserFirstname>,Het ticket [<OTRS_TICKET_TicketNumber>] gaat escaleren!Escalatie op:   <OTRS_TICKET_EscalationDestinationDate>Escalatie over: <OTRS_TICKET_EscalationDestinationIn><OTRS_CUSTOMER_FROM> schreef:<OTRS_CUSTOMER_EMAIL[30]>(eerste 30 regels zijn weergegeven)<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>', 'text/plain', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table dynamic_field
# ----------------------------------------------------------
INSERT INTO dynamic_field (id, internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'ProcessManagementProcessID', 'ProcessManagementProcessID', 1, 'Text', 'Ticket', '---DefaultValue: \'\'', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table dynamic_field
# ----------------------------------------------------------
INSERT INTO dynamic_field (id, internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 1, 'ProcessManagementActivityID', 'ProcessManagementActivityID', 1, 'Text', 'Ticket', '---DefaultValue: \'\'', 1, 1, current_timestamp, 1, current_timestamp);
