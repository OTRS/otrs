# ----------------------------------------------------------
#  driver: mysql
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
INSERT INTO group_user (user_id, group_id, permission_key, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'rw', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table group_user
# ----------------------------------------------------------
INSERT INTO group_user (user_id, group_id, permission_key, create_by, create_time, change_by, change_time)
    VALUES
    (1, 2, 'rw', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table group_user
# ----------------------------------------------------------
INSERT INTO group_user (user_id, group_id, permission_key, create_by, create_time, change_by, change_time)
    VALUES
    (1, 3, 'rw', 1, current_timestamp, 1, current_timestamp);
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
    (1, 'system standard salutation (en)', 'Dear <OTRS_CUSTOMER_REALNAME>,

Thank you for your request.

', 'text/plain\; charset=utf-8', 'Standard Salutation.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table signature
# ----------------------------------------------------------
INSERT INTO signature (id, name, text, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'system standard signature (en)', '
Your Ticket-Team

 <OTRS_Agent_UserFirstname> <OTRS_Agent_UserLastname>

--
 Super Support - Waterford Business Park
 5201 Blue Lagoon Drive - 8th Floor & 9th Floor - Miami, 33126 USA
 Email: hot@example.com - Web: http://www.example.com/
--', 'text/plain\; charset=utf-8', 'Standard Signature.', 1, 1, current_timestamp, 1, current_timestamp);
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
    (1, 'possible', 'Follow-ups for closed tickets are possible. Ticket will be reopened.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table follow_up_possible
# ----------------------------------------------------------
INSERT INTO follow_up_possible (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'reject', 'Follow-ups for closed tickets are not possible. No new ticket will be created.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table follow_up_possible
# ----------------------------------------------------------
INSERT INTO follow_up_possible (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'new ticket', 'Follow-ups for closed tickets are not possible. A new ticket will be created.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue
# ----------------------------------------------------------
INSERT INTO queue (id, name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, unlock_timeout, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'Postmaster', 1, 1, 1, 1, 1, 0, 0, 'Postmaster queue.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue
# ----------------------------------------------------------
INSERT INTO queue (id, name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, unlock_timeout, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'Raw', 1, 1, 1, 1, 1, 0, 0, 'All default incoming tickets.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue
# ----------------------------------------------------------
INSERT INTO queue (id, name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, unlock_timeout, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'Junk', 1, 1, 1, 1, 1, 0, 0, 'All junk tickets.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue
# ----------------------------------------------------------
INSERT INTO queue (id, name, group_id, system_address_id, salutation_id, signature_id, follow_up_id, follow_up_lock, unlock_timeout, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'Misc', 1, 1, 1, 1, 1, 0, 0, 'All misc tickets.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table standard_template
# ----------------------------------------------------------
INSERT INTO standard_template (id, name, text, content_type, template_type, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'empty answer', '', 'text/plain\; charset=utf-8', 'Answer', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table standard_template
# ----------------------------------------------------------
INSERT INTO standard_template (id, name, text, content_type, template_type, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'test answer', 'Some test answer to show how a standard template can be used.', 'text/plain\; charset=utf-8', 'Answer', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue_standard_template
# ----------------------------------------------------------
INSERT INTO queue_standard_template (queue_id, standard_template_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue_standard_template
# ----------------------------------------------------------
INSERT INTO queue_standard_template (queue_id, standard_template_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue_standard_template
# ----------------------------------------------------------
INSERT INTO queue_standard_template (queue_id, standard_template_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table queue_standard_template
# ----------------------------------------------------------
INSERT INTO queue_standard_template (queue_id, standard_template_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'auto reply', 'Automatic reply which will be sent out after a new ticket has been created.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'auto reject', 'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'auto follow up', 'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'auto reply/new ticket', 'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response_type
# ----------------------------------------------------------
INSERT INTO auto_response_type (id, name, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (5, 'auto remove', 'Auto remove will be sent out after a customer removed the request.', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response
# ----------------------------------------------------------
INSERT INTO auto_response (id, type_id, system_address_id, name, text0, text1, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, 'default reply (after new ticket has been created)', 'This is a demo text which is send to every inquiry.
It could contain something like:

Thanks for your email. A new ticket has been created.

You wrote:
<OTRS_CUSTOMER_EMAIL[6]>

Your email will be answered by a human ASAP

Have fun with OTRS! :-)

Your OTRS Team
', 'RE: <OTRS_CUSTOMER_SUBJECT[24]>', 'text/plain', '', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response
# ----------------------------------------------------------
INSERT INTO auto_response (id, type_id, system_address_id, name, text0, text1, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 2, 1, 'default reject (after follow-up and rejected of a closed ticket)', 'Your previous ticket is closed.

-- Your follow-up has been rejected. --

Please create a new ticket.

Your OTRS Team
', 'Your email has been rejected! (RE: <OTRS_CUSTOMER_SUBJECT[24]>)', 'text/plain', '', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response
# ----------------------------------------------------------
INSERT INTO auto_response (id, type_id, system_address_id, name, text0, text1, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 3, 1, 'default follow-up (after a ticket follow-up has been added)', 'Thanks for your follow-up email

You wrote:
<OTRS_CUSTOMER_EMAIL[6]>

Your email will be answered by a human ASAP.

Have fun with OTRS!

Your OTRS Team
', 'RE: <OTRS_CUSTOMER_SUBJECT[24]>', 'text/plain', '', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table auto_response
# ----------------------------------------------------------
INSERT INTO auto_response (id, type_id, system_address_id, name, text0, text1, content_type, comments, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 4, 1, 'default reject/new ticket created (after closed follow-up with new ticket creation)', 'Your previous ticket is closed.

-- A new ticket has been created for you. --

You wrote:
<OTRS_CUSTOMER_EMAIL[6]>

Your email will be answered by a human ASAP.

Have fun with OTRS!

Your OTRS Team
', 'New ticket has been created! (RE: <OTRS_CUSTOMER_SUBJECT[24]>)', 'text/plain', '', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_type
# ----------------------------------------------------------
INSERT INTO ticket_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'Unclassified', 1, 1, current_timestamp, 1, current_timestamp);
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
#  insert into table ticket_history_type
# ----------------------------------------------------------
INSERT INTO ticket_history_type (id, name, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (51, 'EmailResend', 1, 1, current_timestamp, 1, current_timestamp);
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
INSERT INTO ticket (id, tn, queue_id, ticket_lock_id, user_id, responsible_user_id, ticket_priority_id, ticket_state_id, title, timeout, until_time, escalation_time, escalation_response_time, escalation_update_time, escalation_solution_time, create_by, create_time, change_by, change_time)
    VALUES
    (1, '2015071510123456', 2, 1, 1, 1, 3, 1, 'Welcome to OTRS!', 0, 0, 0, 0, 0, 0, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table communication_channel
# ----------------------------------------------------------
INSERT INTO communication_channel (id, name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'Email', 'Kernel::System::CommunicationChannel::Email', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
- article_data_mime_send_error
', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table communication_channel
# ----------------------------------------------------------
INSERT INTO communication_channel (id, name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'Phone', 'Kernel::System::CommunicationChannel::Phone', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
- article_data_mime_send_error
', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table communication_channel
# ----------------------------------------------------------
INSERT INTO communication_channel (id, name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'Internal', 'Kernel::System::CommunicationChannel::Internal', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataTables:
- article_data_mime
- article_data_mime_plain
- article_data_mime_attachment
- article_data_mime_send_error
', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table communication_channel
# ----------------------------------------------------------
INSERT INTO communication_channel (id, name, module, package_name, channel_data, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'Chat', 'Kernel::System::CommunicationChannel::Chat', 'Framework', '---
ArticleDataArticleIDField: article_id
ArticleDataTables:
- article_data_otrs_chat
', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article
# ----------------------------------------------------------
INSERT INTO article (id, ticket_id, communication_channel_id, article_sender_type_id, is_visible_for_customer, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 1, 3, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_data_mime
# ----------------------------------------------------------
INSERT INTO article_data_mime (id, article_id, a_from, a_to, a_subject, a_body, a_message_id, incoming_time, content_path, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'OTRS Feedback <marketing@otrs.com>', 'Your OTRS System <otrs@localhost>', 'Welcome to OTRS!', 'Welcome to OTRS!

Thank you for installing OTRS, the world’s most popular service management software available in more than 35 languages and used by 150,000 companies worldwide.

You can find updates and patches for OTRS Free at
https://www.otrs.com/download-open-source-help-desk-software-otrs-free/.

Please be aware that we do not offer official vendor support for OTRS Free. In case of questions, please use our:

- online documentation available at http://otrs.github.io/doc/
- mailing lists available at http://lists.otrs.org/
- E-Learning with OTRS at https://www.otrs.com/e-learning-otrs/

To meet higher business requirements, we recommend to use the OTRS Business Solution™, that offers

- exclusive business features like chat, integration of data from external databases etc.
- included professional updates & services
- implementation and configuration by our experts

Find more information about it at https://www.otrs.com/solutions/.

Best regards and ((enjoy)) OTRS,

Your OTRS Group
', '<007@localhost>', 1436949030, '2015/07/15', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table article_data_mime_plain
# ----------------------------------------------------------
INSERT INTO article_data_mime_plain (id, article_id, body, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'From: OTRS Feedback <marketing@otrs.com>
To: Your OTRS System <otrs@localhost>
Subject: Welcome to OTRS!
Content-Type: text/plain\; charset=utf-8
Content-Transfer-Encoding: 8bit

Welcome to OTRS!

Thank you for installing OTRS, the world’s most popular service management software available in more than 35 languages and used by 150,000 companies worldwide.

You can find updates and patches for OTRS Free at
https://www.otrs.com/download-open-source-help-desk-software-otrs-free/.

Please be aware that we do not offer official vendor support for OTRS Free. In case of questions, please use our:

- online documentation available at http://otrs.github.io/doc/
- mailing lists available at http://lists.otrs.org/
- E-Learning with OTRS at https://www.otrs.com/e-learning-otrs/

To meet higher business requirements, we recommend to use the OTRS Business Solution™, that offers

- exclusive business features like chat, integration of data from external databases etc.
- included professional updates & services
- implementation and configuration by our experts

Find more information about it at https://www.otrs.com/solutions/.

Best regards and ((enjoy)) OTRS,

Your OTRS Group
', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table ticket_history
# ----------------------------------------------------------
INSERT INTO ticket_history (id, name, history_type_id, ticket_id, type_id, article_id, priority_id, owner_id, state_id, queue_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'New Ticket [2015071510123456] created.', 1, 1, 1, 1, 3, 1, 1, 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (1, 'Ticket create notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (1, 'VisibleForAgent', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (1, 'VisibleForAgentTooltip', 'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (1, 'Events', 'NotificationNewTicket');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (1, 'Recipients', 'AgentMyQueues');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (1, 'Recipients', 'AgentMyServices');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (1, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (1, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (1, 'AgentEnabledByDefault', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (2, 'Ticket follow-up notification (unlocked)', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'VisibleForAgent', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'VisibleForAgentTooltip', 'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'Events', 'NotificationFollowUp');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'Recipients', 'AgentOwner');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'Recipients', 'AgentWatcher');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'Recipients', 'AgentMyQueues');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'Recipients', 'AgentMyServices');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'LockID', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (2, 'AgentEnabledByDefault', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (3, 'Ticket follow-up notification (locked)', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'VisibleForAgent', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'VisibleForAgentTooltip', 'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'Events', 'NotificationFollowUp');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'Recipients', 'AgentOwner');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'Recipients', 'AgentResponsible');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'Recipients', 'AgentWatcher');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'LockID', '2');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'LockID', '3');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (3, 'AgentEnabledByDefault', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (4, 'Ticket lock timeout notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (4, 'VisibleForAgent', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (4, 'VisibleForAgentTooltip', 'You will receive a notification as soon as a ticket owned by you is automatically unlocked.');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (4, 'Events', 'NotificationLockTimeout');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (4, 'Recipients', 'AgentOwner');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (4, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (4, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (4, 'AgentEnabledByDefault', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (5, 'Ticket owner update notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (5, 'Events', 'NotificationOwnerUpdate');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (5, 'Recipients', 'AgentOwner');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (5, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (5, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (6, 'Ticket responsible update notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (6, 'Events', 'NotificationResponsibleUpdate');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (6, 'Recipients', 'AgentResponsible');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (6, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (6, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (7, 'Ticket new note notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (7, 'Events', 'NotificationAddNote');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (7, 'Recipients', 'AgentOwner');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (7, 'Recipients', 'AgentResponsible');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (7, 'Recipients', 'AgentWatcher');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (7, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (7, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (8, 'Ticket queue update notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (8, 'VisibleForAgent', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (8, 'VisibleForAgentTooltip', 'You will receive a notification if a ticket is moved into one of your "My Queues".');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (8, 'Events', 'NotificationMove');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (8, 'Recipients', 'AgentMyQueues');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (8, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (8, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (8, 'AgentEnabledByDefault', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (9, 'Ticket pending reminder notification (locked)', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (9, 'Events', 'NotificationPendingReminder');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (9, 'Recipients', 'AgentOwner');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (9, 'Recipients', 'AgentResponsible');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (9, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (9, 'OncePerDay', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (9, 'LockID', '2');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (9, 'LockID', '3');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (9, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (10, 'Ticket pending reminder notification (unlocked)', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (10, 'Events', 'NotificationPendingReminder');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (10, 'Recipients', 'AgentOwner');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (10, 'Recipients', 'AgentResponsible');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (10, 'Recipients', 'AgentMyQueues');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (10, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (10, 'OncePerDay', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (10, 'LockID', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (10, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (11, 'Ticket escalation notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (11, 'Events', 'NotificationEscalation');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (11, 'Recipients', 'AgentMyQueues');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (11, 'Recipients', 'AgentWritePermissions');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (11, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (11, 'OncePerDay', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (11, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (12, 'Ticket escalation warning notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (12, 'Events', 'NotificationEscalationNotifyBefore');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (12, 'Recipients', 'AgentMyQueues');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (12, 'Recipients', 'AgentWritePermissions');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (12, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (12, 'OncePerDay', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (12, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (13, 'Ticket service update notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (13, 'VisibleForAgent', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (13, 'VisibleForAgentTooltip', 'You will receive a notification if a ticket\'s service is changed to one of your "My Services".');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (13, 'Events', 'NotificationServiceUpdate');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (13, 'Recipients', 'AgentMyServices');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (13, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (13, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (13, 'AgentEnabledByDefault', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (14, 'Appointment reminder notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (14, 'VisibleForAgent', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (14, 'VisibleForAgentTooltip', 'You will receive a notification each time a reminder time is reached for one of your appointments.');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (14, 'Events', 'AppointmentNotification');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (14, 'Recipients', 'AppointmentAgentReadPermissions');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (14, 'SendOnOutOfOffice', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (14, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (14, 'AgentEnabledByDefault', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (14, 'NotificationType', 'Appointment');
# ----------------------------------------------------------
#  insert into table notification_event
# ----------------------------------------------------------
INSERT INTO notification_event (id, name, valid_id, comments, create_by, create_time, change_by, change_time)
    VALUES
    (15, 'Ticket email delivery failure notification', 1, '', 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'AgentEnabledByDefault', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'ArticleAttachmentInclude', '0');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'ArticleCommunicationChannelID', '1');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'Events', 'ArticleEmailSendingError');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'LanguageID', 'en');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'RecipientGroups', '2');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'Recipients', 'AgentResponsible');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'Recipients', 'AgentOwner');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'TransportEmailTemplate', 'Default');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'Transports', 'Email');
# ----------------------------------------------------------
#  insert into table notification_event_item
# ----------------------------------------------------------
INSERT INTO notification_event_item (notification_id, event_key, event_value)
    VALUES
    (15, 'VisibleForAgent', '0');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (1, 1, 'text/plain', 'en', 'Ticket Created: <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has been created in queue <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> wrote:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (2, 2, 'text/plain', 'en', 'Unlocked Ticket Follow-Up: <OTRS_CUSTOMER_SUBJECT[24]>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the unlocked ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] received a follow-up.

<OTRS_CUSTOMER_REALNAME> wrote:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (3, 3, 'text/plain', 'en', 'Locked Ticket Follow-Up: <OTRS_CUSTOMER_SUBJECT[24]>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the locked ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] received a follow-up.

<OTRS_CUSTOMER_REALNAME> wrote:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (4, 4, 'text/plain', 'en', 'Ticket Lock Timeout: <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has reached its lock timeout period and is now unlocked.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (5, 5, 'text/plain', 'en', 'Ticket Owner Update to <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the owner of ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has been updated to <OTRS_TICKET_OWNER_UserFullname> by <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (6, 6, 'text/plain', 'en', 'Ticket Responsible Update to <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the responsible agent of ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has been updated to <OTRS_TICKET_RESPONSIBLE_UserFullname> by <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (7, 7, 'text/plain', 'en', 'Ticket Note: <OTRS_AGENT_SUBJECT[24]>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> wrote:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (8, 8, 'text/plain', 'en', 'Ticket Queue Update to <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has been updated to queue <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (9, 9, 'text/plain', 'en', 'Locked Ticket Pending Reminder Time Reached: <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the pending reminder time of the locked ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has been reached.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (10, 10, 'text/plain', 'en', 'Unlocked Ticket Pending Reminder Time Reached: <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the pending reminder time of the unlocked ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has been reached.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (11, 11, 'text/plain', 'en', 'Ticket Escalation! <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] is escalated!

Escalated at: <OTRS_TICKET_EscalationDestinationDate>
Escalated since: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (12, 12, 'text/plain', 'en', 'Ticket Escalation Warning! <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] will escalate!

Escalation at: <OTRS_TICKET_EscalationDestinationDate>
Escalation in: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (13, 13, 'text/plain', 'en', 'Ticket Service Update to <OTRS_TICKET_Service>: <OTRS_TICKET_Title>', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

the service of ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has been updated to <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (14, 14, 'text/html', 'en', 'Reminder: <OTRS_APPOINTMENT_TITLE>', 'Hi &lt\;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt\;,<br />
<br />
appointment &quot\;&lt\;OTRS_APPOINTMENT_TITLE&gt\;&quot\; has reached its notification time.<br />
<br />
Description: &lt\;OTRS_APPOINTMENT_DESCRIPTION&gt\;<br />
Location: &lt\;OTRS_APPOINTMENT_LOCATION&gt\;<br />
Calendar: <span style="color: &lt\;OTRS_CALENDAR_COLOR&gt\;\;">■</span> &lt\;OTRS_CALENDAR_CALENDARNAME&gt\;<br />
Start date: &lt\;OTRS_APPOINTMENT_STARTTIME&gt\;<br />
End date: &lt\;OTRS_APPOINTMENT_ENDTIME&gt\;<br />
All-day: &lt\;OTRS_APPOINTMENT_ALLDAY&gt\;<br />
Repeat: &lt\;OTRS_APPOINTMENT_RECURRING&gt\;<br />
<br />
<a href="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;" title="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;">&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;</a><br />
<br />
-- &lt\;OTRS_CONFIG_NotificationSenderName&gt\;');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (15, 1, 'text/plain', 'de', 'Ticket erstellt: <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

das Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] wurde in der Queue <OTRS_TICKET_Queue> erstellt.

<OTRS_CUSTOMER_REALNAME> schrieb:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (16, 2, 'text/plain', 'de', 'Nachfrage zum freigegebenen Ticket: <OTRS_CUSTOMER_SUBJECT[24]>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

zum freigegebenen Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] gibt es eine Nachfrage.

<OTRS_CUSTOMER_REALNAME> schrieb:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (17, 3, 'text/plain', 'de', 'Nachfrage zum gesperrten Ticket: <OTRS_CUSTOMER_SUBJECT[24]>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

zum gesperrten Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] gibt es eine Nachfrage.

<OTRS_CUSTOMER_REALNAME> schrieb:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (18, 4, 'text/plain', 'de', 'Ticketsperre aufgehoben: <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

die Sperrzeit des Tickets [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] ist abgelaufen. Es ist jetzt freigegeben.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (19, 5, 'text/plain', 'de', 'Änderung des Ticket-Besitzers auf <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

der Besitzer des Tickets [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] wurde von <OTRS_CURRENT_UserFullname> geändert auf <OTRS_TICKET_OWNER_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (20, 6, 'text/plain', 'de', 'Änderung des Ticket-Verantwortlichen auf <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

der Verantwortliche für das Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] wurde von <OTRS_CURRENT_UserFullname> geändert auf <OTRS_TICKET_RESPONSIBLE_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (21, 7, 'text/plain', 'de', 'Ticket-Notiz: <OTRS_AGENT_SUBJECT[24]>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

<OTRS_CURRENT_UserFullname> schrieb:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (22, 8, 'text/plain', 'de', 'Ticket-Queue geändert zu <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

das Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] wurde in die Queue <OTRS_TICKET_Queue> verschoben.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (23, 9, 'text/plain', 'de', 'Erinnerungszeit des gesperrten Tickets erreicht: <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

die Erinnerungszeit für das gesperrte Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] wurde erreicht.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (24, 10, 'text/plain', 'de', 'Erinnerungszeit des freigegebenen Tickets erreicht: <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

die Erinnerungszeit für das freigegebene Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] wurde erreicht.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (25, 11, 'text/plain', 'de', 'Ticket-Eskalation! <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

das Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] ist eskaliert!

Eskaliert am: <OTRS_TICKET_EscalationDestinationDate>
Eskaliert seit: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (26, 12, 'text/plain', 'de', 'Ticket-Eskalations-Warnung! <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

das Ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] wird bald eskalieren!

Eskalation um: <OTRS_TICKET_EscalationDestinationDate>
Eskalation in: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (27, 13, 'text/plain', 'de', 'Ticket-Service aktualisiert zu <OTRS_TICKET_Service>: <OTRS_TICKET_Title>', 'Hallo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname> <OTRS_NOTIFICATION_RECIPIENT_UserLastname>,

der Service des Tickets [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] wurde geändert zu <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (28, 14, 'text/html', 'de', 'Erinnerung: <OTRS_APPOINTMENT_TITLE>', 'Hallo &lt\;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt\;,<br />
<br />
Termin &quot\;&lt\;OTRS_APPOINTMENT_TITLE&gt\;&quot\; hat seine Benachrichtigungszeit erreicht.<br />
<br />
Beschreibung: &lt\;OTRS_APPOINTMENT_DESCRIPTION&gt\;<br />
Standort: &lt\;OTRS_APPOINTMENT_LOCATION&gt\;<br />
Kalender: <span style="color: &lt\;OTRS_CALENDAR_COLOR&gt\;\;">■</span> &lt\;OTRS_CALENDAR_CALENDARNAME&gt\;<br />
Startzeitpunkt: &lt\;OTRS_APPOINTMENT_STARTTIME&gt\;<br />
Endzeitpunkt: &lt\;OTRS_APPOINTMENT_ENDTIME&gt\;<br />
Ganztägig: &lt\;OTRS_APPOINTMENT_ALLDAY&gt\;<br />
Wiederholung: &lt\;OTRS_APPOINTMENT_RECURRING&gt\;<br />
<br />
<a href="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;" title="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;">&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;</a><br />
<br />
-- &lt\;OTRS_CONFIG_NotificationSenderName&gt\;');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (29, 1, 'text/plain', 'es_MX', 'Se ha creado un ticket: <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] se ha creado en la fila <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> escribió:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (30, 2, 'text/plain', 'es_MX', 'Seguimiento a ticket desbloqueado: <OTRS_CUSTOMER_SUBJECT[24]>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket desbloqueado [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] recibió un seguimiento.

<OTRS_CUSTOMER_REALNAME> escribió:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (31, 3, 'text/plain', 'es_MX', 'Seguimiento a ticket bloqueado: <OTRS_CUSTOMER_SUBJECT[24]>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket bloqueado [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] recibió un seguimiento.

<OTRS_CUSTOMER_REALNAME> escribió:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (32, 4, 'text/plain', 'es_MX', 'Terminó tiempo de bloqueo: <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>]  ha alcanzado su tiempo de espera como bloqueado y ahora se encuentra desbloqueado.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (33, 5, 'text/plain', 'es_MX', 'Actualización del propietario de ticket a <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el propietario del ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] se ha modificado  a <OTRS_TICKET_OWNER_UserFullname> por <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (34, 6, 'text/plain', 'es_MX', 'Actualización del responsable de ticket a <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el agente responsable del ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] se ha modificado a <OTRS_TICKET_RESPONSIBLE_UserFullname> por <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (35, 7, 'text/plain', 'es_MX', 'Nota de ticket: <OTRS_AGENT_SUBJECT[24]>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> escribió:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (36, 8, 'text/plain', 'es_MX', 'La fila del ticket ha cambiado a <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] ha cambiado de fila a <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (37, 9, 'text/plain', 'es_MX', 'Recordatorio pendiente en ticket bloqueado se ha alcanzado: <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el tiempo del recordatorio pendiente para el ticket bloqueado [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] se ha alcanzado.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (38, 10, 'text/plain', 'es_MX', 'Recordatorio pendiente en ticket desbloqueado se ha alcanzado: <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el tiempo del recordatorio pendiente para el ticket desbloqueado [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] se ha alcanzado.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (39, 11, 'text/plain', 'es_MX', '¡Escalación de ticket! <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] se ha escalado!

Escaló: <OTRS_TICKET_EscalationDestinationDate>
Escalado desde: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (40, 12, 'text/plain', 'es_MX', 'Aviso de escalación de ticket! <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] se encuentra proximo a escalar!

Escalará: <OTRS_TICKET_EscalationDestinationDate>
Escalará en: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (41, 13, 'text/plain', 'es_MX', 'El servicio del ticket ha cambiado a <OTRS_TICKET_Service>: <OTRS_TICKET_Title>', 'Hola <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

el servicio del ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] se ha cambiado a <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (42, 1, 'text/plain', 'zh_CN', '票据编制 工单已创建：<OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已在等待队列 已在队列<OTRS_TICKET_Queue> 中被编制完成。中被创建完成

<OTRS_CUSTOMER_REALNAME> 写道：
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (43, 2, 'text/plain', 'zh_CN', '解锁票据的后续作业解锁工单的后续： <OTRS_CUSTOMER_SUBJECT[24]>', '您好<OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

解锁票据解锁工单[<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已获得一项后续作业。

<OTRS_CUSTOMER_REALNAME> 写道:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (44, 3, 'text/plain', 'zh_CN', '加锁票据的后续作业 锁定工单后续：<OTRS_CUSTOMER_SUBJECT[24]>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

加锁票据锁定工单 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已获得一项后续作业。

<OTRS_CUSTOMER_REALNAME> 写道：
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (45, 4, 'text/plain', 'zh_CN', '票据加锁超时工单锁定超时：<OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已达到其锁定时限，现在解锁。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (46, 5, 'text/plain', 'zh_CN', '票据的拥有人升级为工单所有者更新为 <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据的所有人工单的所有者 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已被该信为 <OTRS_TICKET_OWNER_UserFullname> 的 <OTRS_CURRENT_UserFullname>。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (47, 6, 'text/plain', 'zh_CN', '票据的负责人 工单负责人更新为<OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

工单的负责人 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已被升级为 已被更新为 <OTRS_TICKET_RESPONSIBLE_UserFullname> 的 <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (48, 7, 'text/plain', 'zh_CN', '票据备注工单备注：<OTRS_AGENT_SUBJECT[24]>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> 写道：
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (49, 8, 'text/plain', 'zh_CN', '票据序列已升级为工单队列更新为<OTRS_TICKET_Queue>: <OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已被升级为序列已被更新为队列 <OTRS_TICKET_Queue>。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (50, 9, 'text/plain', 'zh_CN', '已达到锁定票据即将到期的提醒时间已到达锁定工单挂起提醒时间：<OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

锁定票据即将到期的提醒时间锁定工单挂起提醒时间 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已到达。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (51, 10, 'text/plain', 'zh_CN', '未锁定票据即将到期的提醒时间已到已到未锁定工单的挂起提醒时间：<OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

未锁定票据即将到期的提醒时间未锁定工单的挂起提醒时间 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已到已到达。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (52, 11, 'text/plain', 'zh_CN', '票据升级！工单升级！<OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已被升级！

升级地点升级开始时间：<OTRS_TICKET_EscalationDestinationDate>
升级开始时间升级在：<OTRS_TICKET_EscalationDestinationIn>内

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (53, 12, 'text/plain', 'zh_CN', '工单升级警告Ticket Escalation Warning! <OTRS_TICKET_Title>', '您好  <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据工单 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 将升级！

升级地点升级开始时间：<OTRS_TICKET_EscalationDestinationDate>
升级开始时间升级在：<OTRS_TICKET_EscalationDestinationIn>内

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (54, 13, 'text/plain', 'zh_CN', '票据服务升级为工单服务更新为<OTRS_TICKET_Service>: <OTRS_TICKET_Title>', '您好 <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

票据服务工单服务 [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] 已被升级为已被更新为 <OTRS_TICKET_Service>。

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (55, 1, 'text/plain', 'pt_BR', 'Ticket criado: <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] foi criado na fila <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> escreveu:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (56, 2, 'text/plain', 'pt_BR', 'Acompanhamento do ticket desbloqueado: <OTRS_CUSTOMER_SUBJECT[24]>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket desbloqueado [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] recebeu uma resposta.

<OTRS_CUSTOMER_REALNAME> escreveu:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (57, 3, 'text/plain', 'pt_BR', 'Acompanhamento do ticket bloqueado: <OTRS_CUSTOMER_SUBJECT[24]>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket bloqueado [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] recebeu uma resposta.

<OTRS_CUSTOMER_REALNAME> escreveu:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (58, 4, 'text/plain', 'pt_BR', 'Tempo limite de bloqueio do ticket: <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] atingiu o seu período de tempo limite de bloqueio e agora está desbloqueado.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (59, 5, 'text/plain', 'pt_BR', 'Atualização de proprietário de ticket para <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o proprietário do ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] foi atualizado para <OTRS_TICKET_OWNER_UserFullname> por <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (60, 6, 'text/plain', 'pt_BR', 'Atualização de responsável de ticket para <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o agente responsável do ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] foi atualizado para <OTRS_TICKET_RESPONSIBLE_UserFullname> por <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (61, 7, 'text/plain', 'pt_BR', 'Observação sobre o ticket: <OTRS_AGENT_SUBJECT[24]>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> escreveu:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (62, 8, 'text/plain', 'pt_BR', 'Atualização da fila do ticket para <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] foi atualizado na fila <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (63, 9, 'text/plain', 'pt_BR', 'Tempo de Lembrete de Pendência do Ticket Bloqueado Atingido: <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o tempo de lembrete pendente do ticket bloqueado [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] foi atingido.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (64, 10, 'text/plain', 'pt_BR', 'Tempo de Lembrete Pendente do Ticket Desbloqueado Atingido: <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o tempo de lembrete pendente do ticket desbloqueado [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] foi atingido.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (65, 11, 'text/plain', 'pt_BR', 'Escalonamento do ticket! <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] foi escalonado!

Escalonado em: <OTRS_TICKET_EscalationDestinationDate>
Escalonado desde: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (66, 12, 'text/plain', 'pt_BR', 'Aviso de escalonamento do ticket! <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] será escalonado!

Escalonamento em: <OTRS_TICKET_EscalationDestinationDate>
Escalonamento em: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (67, 13, 'text/plain', 'pt_BR', 'Atualização do serviço do ticket para <OTRS_TICKET_Service>: <OTRS_TICKET_Title>', 'Oi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

o serviço do ticket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] foi atualizado para <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (68, 1, 'text/plain', 'hu', 'Jegy létrehozva: <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy létrejött a következő várólistában: <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> ezt írta:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (69, 2, 'text/plain', 'hu', 'Feloldott jegy követése: <OTRS_CUSTOMER_SUBJECT[24]>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A feloldott [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy egy követő üzenetet kapott.

<OTRS_CUSTOMER_REALNAME> ezt írta:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (70, 3, 'text/plain', 'hu', 'Zárolt jegy követése: <OTRS_CUSTOMER_SUBJECT[24]>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A zárolt [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy egy követő üzenetet kapott.

<OTRS_CUSTOMER_REALNAME> ezt írta:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (71, 4, 'text/plain', 'hu', 'Jegyzár időkorlát: <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy elérte a zárolás időkorlátjának időtartamát, és most feloldásra került.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (72, 5, 'text/plain', 'hu', 'Jegytulajdonos frissítés <OTRS_OWNER_UserLastname> <OTRS_OWNER_UserFirstname> ügyintézőre: <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy tulajdonosát <OTRS_CURRENT_UserLastname> <OTRS_CURRENT_UserFirstname> frissítette <OTRS_OWNER_UserLastname> <OTRS_OWNER_UserFirstname> ügyintézőre.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (73, 6, 'text/plain', 'hu', 'Jegyfelelős frissítés <OTRS_RESPONSIBLE_UserLastname> <OTRS_RESPONSIBLE_UserFirstname> ügyintézőre: <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy felelős ügyintézőjét <OTRS_CURRENT_UserLastname> <OTRS_CURRENT_UserFirstname> frissítette <OTRS_RESPONSIBLE_UserLastname> <OTRS_RESPONSIBLE_UserFirstname> ügyintézőre.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (74, 7, 'text/plain', 'hu', 'Új jegyzet: <OTRS_AGENT_SUBJECT[24]>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

<OTRS_CURRENT_UserLastname> <OTRS_CURRENT_UserFirstname> ezt írta:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (75, 8, 'text/plain', 'hu', 'Jegy várólista frissítés <OTRS_TICKET_Queue> várólistára: <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegyet áthelyezték a következő várólistába: <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (76, 9, 'text/plain', 'hu', 'Zárolt jegy „emlékeztető függőben” ideje elérve: <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A zárolt [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy elérte az „emlékeztető függőben” idejét.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (77, 10, 'text/plain', 'hu', 'Feloldott jegy „emlékeztető függőben” ideje elérve: <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A feloldott [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy elérte az „emlékeztető függőben” idejét.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (78, 11, 'text/plain', 'hu', 'Jegyeszkaláció! <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy eszkalálódott!

Eszkaláció időpontja: <OTRS_TICKET_EscalationDestinationDate>
Eszkaláció óta eltelt idő: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (79, 12, 'text/plain', 'hu', 'Jegyeszkaláció figyelmeztetés! <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy eszkalálódni fog!

Eszkaláció időpontja: <OTRS_TICKET_EscalationDestinationDate>
Eszkalációig fennmaradó idő: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (80, 13, 'text/plain', 'hu', 'Jegyszolgáltatás frissítve <OTRS_TICKET_Service> szolgáltatásra: <OTRS_TICKET_Title>', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

A(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy szolgáltatása frissítve lett a következőre: <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (81, 14, 'text/html', 'hu', 'Emlékeztető: <OTRS_APPOINTMENT_TITLE>', 'Kedves &lt\;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt\;!<br />
<br />
A következő esemény elérte az értesítési idejét: &lt\;OTRS_APPOINTMENT_TITLE&gt\;<br />
<br />
Leírás: &lt\;OTRS_APPOINTMENT_DESCRIPTION&gt\;<br />
Hely: &lt\;OTRS_APPOINTMENT_LOCATION&gt\;<br />
Naptár: <span style="color: &lt\;OTRS_CALENDAR_COLOR&gt\;\;">■</span> &lt\;OTRS_CALENDAR_CALENDARNAME&gt\;<br />
Kezdési dátum: &lt\;OTRS_APPOINTMENT_STARTTIME&gt\;<br />
Befejezési dátum: &lt\;OTRS_APPOINTMENT_ENDTIME&gt\;<br />
Egész napos: &lt\;OTRS_APPOINTMENT_ALLDAY&gt\;<br />
Ismétlődés: &lt\;OTRS_APPOINTMENT_RECURRING&gt\;<br />
<br />
<a href="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;" title="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;">&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;</a><br />
<br />
-- &lt\;OTRS_CONFIG_NotificationSenderName&gt\;');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (82, 1, 'text/plain', 'sr_Cyrl', 'Oтворен тикет: <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

тикет [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је отворен у реду <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> је написао/ла:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (83, 2, 'text/plain', 'sr_Cyrl', 'Наставак откључаног тикета: <OTRS_CUSTOMER_SUBJECT[24]>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

откључани тикет [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је примио наставак.

<OTRS_CUSTOMER_REALNAME> је написао/ла:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (84, 3, 'text/plain', 'sr_Cyrl', 'Наставак закључаног тикета: <OTRS_CUSTOMER_SUBJECT[24]>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

закључани тикет [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је примио наставак.

<OTRS_CUSTOMER_REALNAME> је написао/ла:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (85, 4, 'text/plain', 'sr_Cyrl', 'Истек закључаног тикета: <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

тикет [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је достигао време откључавања.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (86, 5, 'text/plain', 'sr_Cyrl', 'Промена власника тикета на <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

власник тикета [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је промењен на <OTRS_TICKET_OWNER_UserFullname> од стране <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (87, 6, 'text/plain', 'sr_Cyrl', 'Промена одговорног за тикет на <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

одговорни оператер тикета [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је промењен на <OTRS_TICKET_RESPONSIBLE_UserFullname> од стране <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (88, 7, 'text/plain', 'sr_Cyrl', 'Напомена тикета: <OTRS_AGENT_SUBJECT[24]>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> је написао/ла:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (89, 8, 'text/plain', 'sr_Cyrl', 'Промена реда тикета у <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

тикету [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је промењен ред у <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (90, 9, 'text/plain', 'sr_Cyrl', 'Истек закључаног тикета на чекању: <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

време закључаног тикета на чекању [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је достигнуто.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (91, 10, 'text/plain', 'sr_Cyrl', 'Истек откључаног тикета на чекању: <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

време откључаног тикета на чекању [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је достигнуто.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (92, 11, 'text/plain', 'sr_Cyrl', 'Ескалација тикета! <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

тикет [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је ескалирао!

Време ескалације: <OTRS_TICKET_EscalationDestinationDate>
Ескалиран од: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (93, 12, 'text/plain', 'sr_Cyrl', 'Упозорење на ескалацију тикета! <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

тикет [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] ће ескалирати!

Време ескалације: <OTRS_TICKET_EscalationDestinationDate>
Ескалира за: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (94, 13, 'text/plain', 'sr_Cyrl', 'Промена сервиса тикета на <OTRS_TICKET_Service>: <OTRS_TICKET_Title>', 'Здраво <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

сервис тикета [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] је промењен на <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (95, 14, 'text/html', 'sr_Cyrl', 'Подсетник: <OTRS_APPOINTMENT_TITLE>', 'Здраво &lt\;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt\;,<br />
<br />
време је за обавештење у вези термина &quot\;&lt\;OTRS_APPOINTMENT_TITLE&gt\;&quot\;.<br />
<br />
Опис: &lt\;OTRS_APPOINTMENT_DESCRIPTION&gt\;<br />
Локација: &lt\;OTRS_APPOINTMENT_LOCATION&gt\;<br />
Календар: <span style="color: &lt\;OTRS_CALENDAR_COLOR&gt\;\;">■</span> &lt\;OTRS_CALENDAR_CALENDARNAME&gt\;<br />
Датум почетка: &lt\;OTRS_APPOINTMENT_STARTTIME&gt\;<br />
Датум краја: &lt\;OTRS_APPOINTMENT_ENDTIME&gt\;<br />
Целодневно: &lt\;OTRS_APPOINTMENT_ALLDAY&gt\;<br />
Понављање: &lt\;OTRS_APPOINTMENT_RECURRING&gt\;<br />
<br />
<a href="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;" title="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;">&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;</a><br />
<br />
-- &lt\;OTRS_CONFIG_NotificationSenderName&gt\;');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (96, 1, 'text/plain', 'sr_Latn', 'Otvoren tiket: <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

tiket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je otvoren u redu <OTRS_TICKET_Queue>.

<OTRS_CUSTOMER_REALNAME> je napisao/la:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (97, 2, 'text/plain', 'sr_Latn', 'Nastavak otključanog tiketa: <OTRS_CUSTOMER_SUBJECT[24]>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

otključani tiket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je primio nastavak.

<OTRS_CUSTOMER_REALNAME> je napisao/la:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (98, 3, 'text/plain', 'sr_Latn', 'Nastavak zaključanog tiketa: <OTRS_CUSTOMER_SUBJECT[24]>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

zaključani tiket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je primio nastavak.

<OTRS_CUSTOMER_REALNAME> je napisao/la:
<OTRS_CUSTOMER_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (99, 4, 'text/plain', 'sr_Latn', 'Istek zaključanog tiketa: <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

tiket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je dostigao vreme otključavanja.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (100, 5, 'text/plain', 'sr_Latn', 'Promena vlasnika tiketa na <OTRS_OWNER_UserFullname>: <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

vlasnik tiketa [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je promenjen na <OTRS_TICKET_OWNER_UserFullname> by <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (101, 6, 'text/plain', 'sr_Latn', 'Promena odgovornog za tiket na <OTRS_RESPONSIBLE_UserFullname>: <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

odgovorni operater tiketa [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je promenjen na <OTRS_TICKET_RESPONSIBLE_UserFullname> by <OTRS_CURRENT_UserFullname>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (102, 7, 'text/plain', 'sr_Latn', 'Napomena tiketa: <OTRS_AGENT_SUBJECT[24]>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

<OTRS_CURRENT_UserFullname> je napisao/la:
<OTRS_AGENT_BODY[30]>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (103, 8, 'text/plain', 'sr_Latn', 'Promena reda tiketa u <OTRS_TICKET_Queue>: <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

tiketu [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je promenjen red u <OTRS_TICKET_Queue>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (104, 9, 'text/plain', 'sr_Latn', 'Istek zaključanog tiketa na čekanju: <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

vreme zaključanog tiketa na čekanju [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je dostignuto.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (105, 10, 'text/plain', 'sr_Latn', 'Istek otključanog tiketa na čekanju: <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

vreme otključanog tiketa na čekanju [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je dostignuto.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (106, 11, 'text/plain', 'sr_Latn', 'Eskalacija tiketa! <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

tiket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je eskalirao!

Vreme eskalacije: <OTRS_TICKET_EscalationDestinationDate>
Eskaliran od: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (107, 12, 'text/plain', 'sr_Latn', 'Upozorenje na eskalaciju tiketa! <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

tiket [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] će eskalirati!

Vreme eskalacije: <OTRS_TICKET_EscalationDestinationDate>
Eskalira za: <OTRS_TICKET_EscalationDestinationIn>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>


-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (108, 13, 'text/plain', 'sr_Latn', 'Promena servisa tiketa na <OTRS_TICKET_Service>: <OTRS_TICKET_Title>', 'Zdravo <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

servis tiketa [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] je promenjen na <OTRS_TICKET_Service>.

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (109, 14, 'text/html', 'sr_Latn', 'Podsetnik: <OTRS_APPOINTMENT_TITLE>', 'Zdravo &lt\;OTRS_NOTIFICATION_RECIPIENT_UserFirstname&gt\;,<br />
<br />
vreme je za obaveštenje u vezi termina &quot\;&lt\;OTRS_APPOINTMENT_TITLE&gt\;&quot\;.<br />
<br />
Opis: &lt\;OTRS_APPOINTMENT_DESCRIPTION&gt\;<br />
Lokacije: &lt\;OTRS_APPOINTMENT_LOCATION&gt\;<br />
Kalendar: <span style="color: &lt\;OTRS_CALENDAR_COLOR&gt\;\;">■</span> &lt\;OTRS_CALENDAR_CALENDARNAME&gt\;<br />
Datum početka: &lt\;OTRS_APPOINTMENT_STARTTIME&gt\;<br />
Datum kraja: &lt\;OTRS_APPOINTMENT_ENDTIME&gt\;<br />
Celodnevno: &lt\;OTRS_APPOINTMENT_ALLDAY&gt\;<br />
Ponavljanje: &lt\;OTRS_APPOINTMENT_RECURRING&gt\;<br />
<br />
<a href="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;" title="&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;">&lt\;OTRS_CONFIG_HttpType&gt\;://&lt\;OTRS_CONFIG_FQDN&gt\;/&lt\;OTRS_CONFIG_ScriptAlias&gt\;index.pl?Action=AgentAppointmentCalendarOverview\;AppointmentID=&lt\;OTRS_APPOINTMENT_APPOINTMENTID&gt\;</a><br />
<br />
-- &lt\;OTRS_CONFIG_NotificationSenderName&gt\;');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (110, 15, 'text/plain', 'en', 'Email Delivery Failure', 'Hi <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>,

Please note, that the delivery of an email article of [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] has failed. Please check the email address of your recipient for mistakes and try again. You can manually resend the article from the ticket if required.

Error Message:
<OTRS_AGENT_TransmissionStatusMessage>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>\;ArticleID=<OTRS_AGENT_ArticleID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table notification_event_message
# ----------------------------------------------------------
INSERT INTO notification_event_message (id, notification_id, content_type, language, subject, text)
    VALUES
    (111, 15, 'text/plain', 'hu', 'E-mail kézbesítési hiba', 'Kedves <OTRS_NOTIFICATION_RECIPIENT_UserFirstname>!

Felhívjuk a figyelmét, hogy a(z) [<OTRS_CONFIG_Ticket::Hook><OTRS_CONFIG_Ticket::HookDivider><OTRS_TICKET_TicketNumber>] jegy e-mail bejegyzésének kézbesítése nem sikerült. Ellenőrizze, hogy nincs-e a címzett e-mail címében hiba, és próbálja meg újra. Kézileg is újraküldheti a bejegyzést a jegyből, ha szükséges.

Hibaüzenet:
<OTRS_AGENT_TransmissionStatusMessage>

<OTRS_CONFIG_HttpType>://<OTRS_CONFIG_FQDN>/<OTRS_CONFIG_ScriptAlias>index.pl?Action=AgentTicketZoom\;TicketID=<OTRS_TICKET_TicketID>\;ArticleID=<OTRS_AGENT_ArticleID>

-- <OTRS_CONFIG_NotificationSenderName>');
# ----------------------------------------------------------
#  insert into table dynamic_field
# ----------------------------------------------------------
INSERT INTO dynamic_field (id, internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (1, 1, 'ProcessManagementProcessID', 'Process', 1, 'ProcessID', 'Ticket', '---
DefaultValue: \'\'
', 1, 1, current_timestamp, 1, current_timestamp);
# ----------------------------------------------------------
#  insert into table dynamic_field
# ----------------------------------------------------------
INSERT INTO dynamic_field (id, internal_field, name, label, field_order, field_type, object_type, config, valid_id, create_by, create_time, change_by, change_time)
    VALUES
    (2, 1, 'ProcessManagementActivityID', 'Activity', 1, 'ActivityID', 'Ticket', '---
DefaultValue: \'\'
', 1, 1, current_timestamp, 1, current_timestamp);
