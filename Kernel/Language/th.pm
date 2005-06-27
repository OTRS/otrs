# --
# Kernel/Language/th.pm - provides th language translation
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# Copyright (C) 2005 Pornthep Nivatyakul <seal at cattelecom.com>
# --
# $Id: th.pm,v 1.1 2005-06-27 15:06:20 rk Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::th;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation file sync: Tue May 17 09:05:01 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-11', 'tis-620', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M/%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => '',
      'No' => '',
      'yes' => '',
      'no' => '',
      'Off' => '',
      'off' => '',
      'On' => '',
      'on' => '',
      'top' => '',
      'end' => '',
      'Done' => '',
      'Cancel' => '',
      'Reset' => '',
      'day' => '',
      'days' => '',
      'hour' => '',
      'hours' => '',
      'minute' => '',
      'minutes' => '',
      'wrote' => '',
      'Message' => '',
      'Error' => '',
      'Bug Report' => '',
      'Attention' => '',
      'Warning' => '',
      'Module' => '',
      'Modulefile' => '',
      'Subfunction' => '',
      'Line' => '',
      'Example' => '',
      'Examples' => '',
      'invalid' => '',
      ' 2 minutes' => '',
      ' 5 minutes' => '',
      ' 7 minutes' => '',
      '10 minutes' => '',
      '15 minutes' => '',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => '',
      'Back' => '',
      'Next...' => '',
      '...Back' => '',
      '-none-' => '',
      'none' => '',
      'none!' => '',
      'none - answered' => '',
      'please do not edit!' => '',
      'AddLink' => '',
      'Link' => '',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => '',
      'Parent' => '',
      'Child' => '',
      'Hit' => '',
      'Hits' => '',
      'Text' => '',
      'Lite' => '',
      'User' => '',
      'Username' => '',
      'Language' => '',
      'Languages' => '',
      'Password' => '',
      'Salutation' => '',
      'Signature' => '',
      'Customer' => '',
      'CustomerID' => '',
      'CustomerIDs' => '',
      'customer' => '',
      'agent' => '',
      'system' => '',
      'Customer Info' => '',
      'go!' => '',
      'go' => '',
      'All' => '',
      'all' => '',
      'Sorry' => '',
      'update!' => '',
      'update' => '',
      'Update' => '',
      'submit!' => '',
      'submit' => '',
      'Submit' => '',
      'change!' => '',
      'Change' => '',
      'change' => '',
      'click here' => '',
      'Comment' => '',
      'Valid' => '',
      'Name' => '',
      'Group' => '',
      'Description' => '',
      'description' => '',
      'Theme' => '',
      'Created' => '',
      'Created by' => '',
      'Changed' => '',
      'Changed by' => '',
      'Search' => '',
      'and' => '',
      'between' => '',
      'Fulltext Search' => '',
      'Data' => '',
      'Options' => '',
      'Title' => '',
      'Item' => '',
      'Delete' => '',
      'Edit' => '',
      'View' => '',
      'Number' => '',
      'System' => '',
      'Contact' => '',
      'Contacts' => '',
      'Export' => '',
      'Up' => '',
      'Down' => '',
      'Add' => '',
      'Category' => '',
      'New message' => '',
      'New message!' => '',
      'Please answer this ticket(s) to get back to the normal queue view!' => '',
      'You got new message!' => '',
      'You have %s new message(s)!' => '',
      'You have %s reminder ticket(s)!' => '',
      'The recommended charset for your language is %s!' => '',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'No suggestions' => '',
      'Word' => '',
      'Ignore' => '',
      'replace with' => '',
      'Welcome to OTRS' => '',
      'There is no account with that login name.' => '',
      'Login failed! Your username or password was entered incorrectly.' => '',
      'Please contact your admin' => '',
      'Logout successful. Thank you for using OTRS!' => '',
      'Invalid SessionID!' => '',
      'Feature not active!' => '',
      'Take this Customer' => '',
      'Take this User' => '',
      'possible' => '',
      'reject' => '',
      'Facility' => '',
      'Timeover' => '',
      'Pending till' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => '',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'No entry found!' => '',
      'Session has timed out. Please log in again.' => '',
      'No Permission!' => '',
      'To: (%s) replaced with database email!' => '',
      'Cc: (%s) added database email!' => '',
      '(Click here to add)' => '',
      'last' => '',
      'before' => '',
      'day(s)' => '',
      'month(s)' => '',
      'week(s)' => '',
      'year(s)' => '',
      'Preview' => '',
      'Added User "%s"' => '',
      'Contract' => '',
      'Online Customer: %s' => '',
      'Online Agent: %s' => '',
      'Calendar' => '',
      'File' => '',
      'Filename' => '',
      'Type' => '',
      'Size' => '',
      'Upload' => '',
      'Directory' => '',
      'Signed' => '',
      'Sign' => '',
      'Crypted' => '',
      'Crypt' => '',

      # Template: AAAMonth
      'Jan' => '',
      'Feb' => '',
      'Mar' => '',
      'Apr' => '',
      'May' => '',
      'Jun' => '',
      'Jul' => '',
      'Aug' => '',
      'Sep' => '',
      'Oct' => '',
      'Nov' => '',
      'Dec' => '',

      # Template: AAANavBar
      'Ticket-Area' => '',
      'Logout' => '',
      'Agent Preferences' => '',
      'Preferences' => '',
      'Agent Mailbox' => '',
      'Stats-Area' => '',
      'Stats' => '',
      'FAQ-Area' => '',
      'FAQ' => '',
      'FAQ-Search' => '',
      'FAQ-Article' => '',
      'New Article' => '',
      'FAQ-State' => '',
      'Admin-Area' => '',
      'Admin' => '',
      'A web calendar' => '',
      'WebMail' => '',
      'A web mail client' => '',
      'FileManager' => '',
      'A web file manager' => '',
      'Artefact' => '',
      'Incident' => '',
      'Advisory' => '',
      'WebWatcher' => '',

      # Template: AAAPreferences
      'Preferences updated successfully!' => '',
      'Mail Management' => '',
      'Frontend' => '',
      'Other Options' => '',
      'New ticket notification' => '',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Follow up notification' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => '',
      'Ticket lock timeout notification' => '',
      'Send me a notification if a ticket is unlocked by the system.' => '',
      'Move notification' => '',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Change Password' => '',
      'New password' => '',
      'New password again' => '',
      'My Queue' => '',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => '',
      'QueueView refresh time' => '',
      'Select your QueueView refresh time.' => '',
      'Select your frontend language.' => '',
      'Select your frontend Charset.' => '',
      'Select your frontend Theme.' => '',
      'Select your frontend QueueView.' => '',
      'Spelling Dictionary' => '',
      'Select your default spelling dictionary.' => '',
      'PhoneView' => '',
      'TicketZoom' => '',
      'CreateTicket' => '',
      'Screen after new ticket' => '',
      'Select your screen after creating a new ticket.' => '',
      'Closed Tickets' => '',
      'Show closed tickets.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Max. shown Tickets a page in Overview.' => '',
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',

      # Template: AAATicket
      'Lock' => '',
      'Unlock' => '',
      'History' => '',
      'Zoom' => '',
      'Age' => '',
      'Bounce' => '',
      'Forward' => '',
      'From' => '',
      'To' => '',
      'Cc' => '',
      'Bcc' => '',
      'Subject' => '',
      'Move' => '',
      'Queue' => '',
      'Priority' => '',
      'State' => '',
      'Compose' => '',
      'Pending' => '',
      'Owner' => '',
      'Sender' => '',
      'Article' => '',
      'Ticket' => '',
      'Createtime' => '',
      'plain' => '',
      'eMail' => '',
      'email' => '',
      'Close' => '',
      'Action' => '',
      'Attachment' => '',
      'Attachments' => '',
      'This message was written in a character set other than your own.' => '',
      'If it is not displayed correctly,' => '',
      'This is a' => '',
      'to open it in a new window.' => '',
      'This is a HTML email. Click here to show it.' => '',
      'closed successful' => '',
      'closed unsuccessful' => '',
      'new' => '',
      'open' => '',
      'closed' => '',
      'removed' => '',
      'pending reminder' => '',
      'pending auto close+' => '',
      'pending auto close-' => '',
      'email-external' => '',
      'email-internal' => '',
      'note-external' => '',
      'note-internal' => '',
      'note-report' => '',
      'phone' => '',
      'sms' => '',
      'webrequest' => '',
      'lock' => '',
      'unlock' => '',
      'very low' => '',
      'low' => '',
      'normal' => '',
      'high' => '',
      'very high' => '',
      '1 very low' => '',
      '2 low' => '',
      '3 normal' => '',
      '4 high' => '',
      '5 very high' => '',
      'Ticket "%s" created!' => '',
      'Ticket Number' => '',
      'Ticket Object' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'Don\'t show closed Tickets' => '',
      'Show closed Tickets' => '',
      'Email-Ticket' => '',
      'Create new Email Ticket' => '',
      'Phone-Ticket' => '',
      'Create new Phone Ticket' => '',
      'Search Tickets' => '',
      'Edit Customer Users' => '',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => '',
      'Overview of all open Tickets' => '',
      'Locked tickets' => '',
      'Lock it to work on it!' => '',
      'Unlock to give it back to the queue!' => '',
      'Shows the ticket history!' => '',
      'Print this ticket!' => '',
      'Change the ticket priority!' => '',
      'Change the ticket free fields!' => '',
      'Link this ticket to an other objects!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket customer!' => '',
      'Add a note to this ticket!' => '',
      'Merge this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Close this ticket!' => '',
      'Look into a ticket!' => '',
      'Delete this ticket!' => '',
      'Mark as Spam!' => '',
      'History::Move' => '',
      'History::NewTicket' => '',
      'History::FollowUp' => '',
      'History::SendAutoReject' => '',
      'History::SendAutoReply' => '',
      'History::SendAutoFollowUp' => '',
      'History::Forward' => '',
      'History::Bounce' => '',
      'History::SendAnswer' => '',
      'History::SendAgentNotification' => '',
      'History::SendCustomerNotification' => '',
      'History::EmailAgent' => '',
      'History::EmailCustomer' => '',
      'History::PhoneCallAgent' => '',
      'History::PhoneCallCustomer' => '',
      'History::AddNote' => '',
      'History::Lock' => '',
      'History::Unlock' => '',
      'History::TimeAccounting' => '',
      'History::Remove' => '',
      'History::CustomerUpdate' => '',
      'History::PriorityUpdate' => '',
      'History::OwnerUpdate' => '',
      'History::LoopProtection' => '',
      'History::Misc' => '',
      'History::SetPendingTime' => '',
      'History::StateUpdate' => '',
      'History::TicketFreeTextUpdate' => '',
      'History::WebRequestCustomer' => '',
      'History::TicketLinkAdd' => '',
      'History::TicketLinkDelete' => '',

      # Template: AAAWeekDay
      'Sun' => '',
      'Mon' => '',
      'Tue' => '',
      'Wed' => '',
      'Thu' => '',
      'Fri' => '',
      'Sat' => '',

      # Template: AdminAttachmentForm
      'Attachment Management' => '',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => '',
      '"} <a href="Action=">$Text{"' => '',
      'Response' => '',
      'Auto Response From' => '',
      'Note' => '',
      'Useable options' => '',
      'to get the first 20 character of the subject' => '',
      'to get the first 5 lines of the email' => '',
      'to get the from line of the email' => '',
      'to get the realname of the sender (if given)' => '',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => '',
      'This window must be called from compose window' => '',
      'Customer User Management' => '',
      'Search for' => '',
      'Result' => '',
      'Select Source (for add)' => '',
      'Source' => '',
      '"} <a href="Action=AdminCustomerUser&Nav=">$Text{"' => '',
      '"}: <font color="red" title="$Text{"This values are required.' => '',
      'This values are read only.' => '',
      '"} $Text{"' => '',
      '"}:<br><i class="small">($Text{"' => '',
      'This values are required.' => '',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => '',
      'Change %s settings' => '',
      'Select the user:group permissions.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => '',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => '',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => '',

      # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => '',

      # Template: AdminEmail
      'Admin-Email' => '',
      'Message sent to' => '',
      'Recipents' => '',
      'Body' => '',
      'send' => '',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => '',
      'Last run' => '',
      'valid' => '',
      'Run Now!' => '',
      'x' => '',
      'Save Job as?' => '',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
      'Schedule' => '',
      'Minutes' => '',
      'Hours' => '',
      'Days' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      'Customer User Login' => '',
      '(e. g. U5150)' => '',
      'Agent' => '',
      'TicketFreeText' => '',
      'Ticket Lock' => '',
      'Times' => '',
      'No time settings.' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'New Priority' => '',
      'New Queue' => '',
      'New State' => '',
      'New Agent' => '',
      'New Owner' => '',
      'New Customer' => '',
      'New Ticket Lock' => '',
      'CustomerUser' => '',
      'Add Note' => '',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Delete tickets' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
      'Modules' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',

      # Template: AdminGroupForm
      'Group Management' => '',
      '"} <a href="Action=AdminGroup">$Text{"' => '',
      'The admin group is to get in the admin area and the stats group to get stats area.' => '',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => '',
      'It\'s useful for ASP solutions.' => '',

      # Template: AdminLog
      'System Log' => '',
      'Time' => '',

      # Template: AdminNavigationBar
      'Users' => '',
      'Groups' => '',
      'Roles' => '',
      'Responses' => '',
      'Misc' => '',

      # Template: AdminNotificationForm
      'Notification Management' => '',
      'Notification' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',

      # Template: AdminPackageManager
      'Package Manager' => '',
      'Uninstall' => '',
      'Verion' => '',
      'Do you really want to uninstall this package?' => '',
      'Install' => '',
      'Package' => '',
      'Online Repository' => '',
      'Version' => '',
      'Vendor' => '',
      'Upgrade' => '',
      'Local Repository' => '',
      'Status' => '',
      'Overview' => '',
      'Download' => '',
      'Rebuild' => '',
      'Reinstall' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => '',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'FIXME: WHAT IS PGP?' => '',

      # Template: AdminPOP3Form
      'POP3 Account Management' => '',
      'Host' => '',
      'Trusted' => '',
      'Dispatching' => '',
      'All incoming emails with one account will be dispatched in the selected queue!' => '',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => '',
      'Filtername' => '',
      'Match' => '',
      'Header' => '',
      'Value' => '',
      'Set' => '',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => '',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => '',
      'Sub-Queue of' => '',
      'Unlock timeout' => '',
      '0 = no unlock' => '',
      'Escalation time' => '',
      '0 = no escalation' => '',
      'Follow up Option' => '',
      'Ticket lock after a follow up' => '',
      'Systemaddress' => '',
      'Customer Move Notify' => '',
      'Customer State Notify' => '',
      'Customer Owner Notify' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => '',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '',
      'Will be the sender address of this queue for email answers.' => '',
      'The salutation for email answers.' => '',
      'The signature for email answers.' => '',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => '',

      # Template: AdminQueueResponsesForm
      'Answer' => '',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => '',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => '',
      'A response is default text to write faster answer (with default text) to customers.' => '',
      'Don\'t forget to add a new response a queue!' => '',
      'Next state' => '',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => '',
      'Your email address is new' => '',

      # Template: AdminRoleForm
      'Role Management' => '',
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => '',
      'move_into' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'create' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'priority' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',

      # Template: AdminRoleGroupForm
      'Change roles <-> groups settings' => '',
      'Role' => '',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => '',
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm
      'Change users <-> roles settings' => '',

      # Template: AdminSalutationForm
      'Salutation Management' => '',
      '"} <a href="Action=AdminSalutation">$Text{"' => '',
      'customer realname' => '',
      'for agent firstname' => '',
      'for agent lastname' => '',
      'for agent user id' => '',
      'for agent login' => '',

      # Template: AdminSelectBoxForm
      'Select Box' => '',
      'SQL' => '',
      'Limit' => '',
      'Select Box Result' => '',

      # Template: AdminSession
      'Session Management' => '',
      'Sessions' => '',
      'Uniq' => '',
      'kill all sessions' => '',
      'Session' => '',
      'kill session' => '',

      # Template: AdminSignatureForm
      'Signature Management' => '',
      '"} <a href="Action=AdminSignature">$Text{"' => '',

      # Template: AdminSMIMEForm
      'SMIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',
      'FIXME: WHAT IS SMIME?' => '',

      # Template: AdminStateForm
      'System State Management' => '',
      'State Type' => '',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',
      'See also' => '',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => '',
      'Show' => '',
      'Subgroup' => '',

      # Template: AdminSysConfigEdit
      'Config Options' => '',
      'Content' => '',
      'New' => '',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'Image' => '',
      'Typ' => '',
      'Prio' => '',
      'Block' => '',
      'NavBar' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => '',
      'Email' => '',
      'Realname' => '',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => '',

      # Template: AdminUserForm
      'User Management' => '',
      '"} <a href="Action=AdminUser">$Text{"' => '',
      'Firstname' => '',
      'Lastname' => '',
      'User will be needed to handle tickets.' => '',
      'Don\'t forget to add a new user to groups!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => '',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => '',
      'Return to the compose screen' => '',
      'Discard all changes and return to the compose screen' => '',

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => '',

      # Template: AgentLinkObject
      'Link Object' => '',
      '"}" $Text{"with' => '',
      'Select' => '',
      'Results' => '',
      'Total hits' => '',
      'Site' => '',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      '"}"><a href="" accesskey="" onmouseover="window.status=\'$Text{"' => '',
      '"}"><br>$Text{"' => '',
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => '',
      'spelling error(s)' => '',
      'or' => '',
      'Apply these changes' => '',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => '',
      'You need a email address (e. g. customer@example.com) in To:!' => '',
      'Bounce ticket' => '',
      'Bounce to' => '',
      'Next ticket state' => '',
      'Inform sender' => '',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => '',
      'Send mail!' => '',

      # Template: AgentTicketBulk
      'A message should have a subject!' => '',
      'Ticket Bulk Action' => '',
      '$Text{"Note!' => '',
      'Spell Check' => '',
      'Note type' => '',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => '',
      'You need to account time!' => '',
      'Close ticket' => '',
      'Close!' => '',
      'Note Text' => '',
      'Close type' => '',
      'Time units' => '',
      ' (work units)' => '',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => '',
      'Compose answer for ticket' => '',
      'Attach' => '',
      'Pending Date' => '',
      'for pending* states' => '',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => '',
      'Set customer user and customer id of a ticket' => '',
      'Customer User' => '',
      'Search Customer' => '',
      'Customer Data' => '',
      'Customer history' => '',
      'All customer tickets.' => '',

      # Template: AgentTicketCustomerMessage
      'Follow up' => '',

      # Template: AgentTicketEmail
      'Compose Email' => '',
      'new ticket' => '',
      'Clear To' => '',
      'All Agents' => '',

      # Template: AgentTicketForward
      'Article type' => '',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => '',

      # Template: AgentTicketHistory
      'History of' => '',

      # Template: AgentTicketLocked
      'Ticket locked!' => '',
      'Ticket unlock!' => '',

      # Template: AgentTicketMailbox
      'Mailbox' => '',
      'Tickets' => '',
      'All messages' => '',
      'New messages' => '',
      'Pending messages' => '',
      'Reminder messages' => '',
      'Reminder' => '',
      'Sort by' => '',
      'Order' => '',
      'up' => '',
      'down' => '',
      '"}\'; return true;" onmouseout="window.status=\'\';" class="menuitem" title="$Text{"' => '',
      '"}"}">$Quote{"$Text{""}' => '',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',

      # Template: AgentTicketMove
      'Queue ID' => '',
      'Move Ticket' => '',
      'Previous Owner' => '',

      # Template: AgentTicketNote
      'Add note to ticket' => '',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

      # Template: AgentTicketOwner
      'Change owner of ticket' => '',
      'Message for new Owner' => '',

      # Template: AgentTicketPending
      'Set Pending' => '',
      'Pending type' => '',
      'Pending date' => '',

      # Template: AgentTicketPhone
      'Phone call' => '',

      # Template: AgentTicketPhoneNew
      'Clear From' => '',

      # Template: AgentTicketPlain
      'Plain' => '',
      'TicketID' => '',
      'ArticleID' => '',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => '',
      'Escalation in' => '',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => '',

      # Template: AgentTicketPriority
      'Change priority of ticket' => '',

      # Template: AgentTicketQueue
      'Tickets shown' => '',
      'Page' => '',
      'Tickets available' => '',
      'All tickets' => '',
      'Queues' => '',
      'Ticket escalation!' => '',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => '',
      'Compose Follow up' => '',
      'Compose Answer' => '',
      'Contact customer' => '',
      'Change queue' => '',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => '',
      'Profile' => '',
      'Search-Template' => '',
      'Created in Queue' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Yes, save it with name' => '',
      'Customer history search' => '',
      'Customer history search (e. g. "ID342425").' => '',
      'No * possible!' => '',

      # Template: AgentTicketSearchResult
      'Search Result' => '',
      'Change search options' => '',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => '',
      'U' => '',
      'sort downward' => '',
      'D' => '',
      'Customer history"}\'; return true;" onmouseout="window.status=\'\';"><div title="">$Quote{"' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => '',

      # Template: AgentTicketZoom
      '"}: \';return true;" onmouseout="window.status=\'\';"><img src="" border="0" alt="$Text{"' => '',
      '"}" title="$Text{"' => '',
      'Split' => '',

      # Template: AgentTicketZoomStatus
      'Locked' => '',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerError
      'Traceback' => '',

      # Template: CustomerFAQArticleHistory
      'FAQ History' => '',
      'Print' => '',

      # Template: CustomerFAQArticlePrint
      'Keywords' => '',
      'Last update' => '',
      'Symptom' => '',
      'Problem' => '',
      'Solution' => '',

      # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

      # Template: CustomerFAQArticleView
      'Modified' => '',

      # Template: CustomerFAQOverview
      'FAQ Overview' => '',

      # Template: CustomerFAQSearch
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',

      # Template: CustomerFAQSearchResult
      'FAQ Search Result' => '',

      # Template: CustomerFooter
      'Powered by' => '',

      # Template: CustomerHeader

      # Template: CustomerLogin
      'Login' => '',
      'Lost your password?' => '',
      'Request new password' => '',
      'Create Account' => '',

      # Template: CustomerNavigationBar
      '"}"><a href="" onmouseover="window.status=\'$Text{"' => '',
      'Welcome %s' => '',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => '',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => '',

      # Template: FAQ
      'Comment (internal)' => '',
      'A article should have a title!' => '',
      'New FAQ Article' => '',
      'Do you really want to delete this Object?' => '',
      'System History' => '',

      # Template: FAQCategoryForm
      'Name is required!' => '',
      'FAQ Category' => '',

      # Template: FAQLanguageForm
      'FAQ Language' => '',

      # Template: Footer
      'QueueView' => '',
      'Top of Page' => '',

      # Template: FooterSmall

      # Template: Header
      'Home' => '',

      # Template: HeaderSmall

      # Template: InstallerBody
      'Web-Installer' => '',
      'Create Database' => '',
      'Drop Database' => '',
      'System Settings' => '',
      'Finished' => '',

      # Template: InstallerFinish
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Restart your webserver' => '',
      'After doing so your OTRS is up and running.' => '',
      'Start page' => '',
      'Admin-User' => '',
      'Have a lot of fun!' => '',
      'Your OTRS Team' => '',

      # Template: InstallerLicense
      'License' => '',
      'accept license' => '',
      'don\'t accept license' => '',

      # Template: InstallerStart
      'DB Admin User' => '',
      'DB Admin Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',
      'DB Host' => '',
      'DB Type' => '',
      'OTRS DB Name' => '',
      'OTRS DB User' => '',
      'OTRS DB Password' => '',
      'default \'hot\'' => '',
      'OTRS DB connect host' => '',
      'Create new database' => '',
      'Delete old database' => '',
      'next step' => '',

      # Template: InstallerSystem
      'SystemID' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
      'System FQDN' => '',
      '(Full qualified domain name of your system)' => '',
      'AdminEmail' => '',
      '(Email of the system admin)' => '',
      'Organization' => '',
      'LogModule' => '',
      '(Used log backend)' => '',
      'Logfile' => '',
      '(Logfile just needed for File-LogModule!)' => '',
      'CheckMXRecord' => '',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      'Ticket Hook' => '',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      'Ticket Number Generator' => '',
      '(Used ticket number format)' => '',
      'Webfrontend' => '',
      'Default Charset' => '',
      'Use utf-8 it your database supports it!' => '',
      'Default Language' => '',
      '(Used default language)' => '',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => '',

      # Template: Notify

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => '',

      # Template: Redirect

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => '',
      'Counter' => '',

      # Template: Warning
    };
    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
