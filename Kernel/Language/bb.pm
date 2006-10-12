# --
# Kernel/Language/bb.pm - provides bavarian language translation
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: bb.pm,v 1.17 2006-10-12 09:23:31 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::bb;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.17 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:31:25 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'Ja',
      'No' => 'Nein',
      'yes' => 'ja',
      'no' => 'kein',
      'Off' => 'Aus',
      'off' => 'aus',
      'On' => 'Ein',
      'on' => 'ein',
      'top' => 'hoch',
      'end' => 'runter',
      'Done' => 'Fertig',
      'Cancel' => 'Abbrechen',
      'Reset' => 'Rücksetzen',
      'last' => '',
      'before' => '',
      'day' => 'Tag',
      'days' => 'Tage',
      'day(s)' => '',
      'hour' => 'Stunde',
      'hours' => 'Stunden',
      'hour(s)' => '',
      'minute' => 'Minute',
      'minutes' => 'Minutn',
      'minute(s)' => '',
      'month' => '',
      'months' => '',
      'month(s)' => '',
      'week' => '',
      'week(s)' => '',
      'year' => '',
      'years' => '',
      'year(s)' => '',
      'wrote' => 'schrieb',
      'Message' => 'Nachricht',
      'Error' => 'Fehler',
      'Bug Report' => 'Fehla berichten',
      'Attention' => 'Achtung',
      'Warning' => 'Warnung',
      'Module' => 'Modul',
      'Modulefile' => 'Moduldatei',
      'Subfunction' => 'Unterfunktion',
      'Line' => 'Zeile',
      'Example' => 'Beispiel',
      'Examples' => 'Beispiele',
      'valid' => '',
      'invalid' => '',
      'invalid-temporarily' => '',
      ' 2 minutes' => ' 2 Minutn',
      ' 5 minutes' => ' 5 Minutn',
      ' 7 minutes' => ' 7 Minutn',
      '10 minutes' => '10 Minutn',
      '15 minutes' => '15 Minutn',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => '',
      'Back' => 'zurück',
      'Next...' => '',
      '...Back' => '',
      '-none-' => '',
      'none' => 'koane',
      'none!' => 'koane Angabe!',
      'none - answered' => 'koane - beantwortet',
      'please do not edit!' => 'Bitte nicht verändern!',
      'AddLink' => 'Link hinzufügen',
      'Link' => '',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => '',
      'Parent' => '',
      'Child' => '',
      'Hit' => 'Treffa',
      'Hits' => 'Treffa',
      'Text' => '',
      'Lite' => 'Einfach',
      'User' => 'Benutzer',
      'Username' => 'Benutzername',
      'Language' => 'Sprache',
      'Languages' => 'Sprachen',
      'Password' => 'Passwort',
      'Salutation' => 'Anrede',
      'Signature' => 'Signatur',
      'Customer' => 'Kunde',
      'CustomerID' => 'Kunden#',
      'CustomerIDs' => '',
      'customer' => '',
      'agent' => '',
      'system' => '',
      'Customer Info' => 'Kunden Info',
      'go!' => 'start!',
      'go' => 'start',
      'All' => '',
      'all' => 'alle',
      'Sorry' => 'Bedauere',
      'update!' => 'aktualisieren!',
      'update' => 'aktualisieren',
      'Update' => '',
      'submit!' => 'übermitteln!',
      'submit' => 'übermitteln',
      'Submit' => '',
      'change!' => 'ändern!',
      'Change' => 'Ändern',
      'change' => 'ändern',
      'click here' => 'klick hier',
      'Comment' => 'Kommentar',
      'Valid' => 'Gültig',
      'Invalid Option!' => '',
      'Invalid time!' => '',
      'Invalid date!' => '',
      'Name' => '',
      'Group' => 'Gruppe',
      'Description' => 'Beschreibung',
      'description' => 'Beschreibung',
      'Theme' => '',
      'Created' => 'Erstellt',
      'Created by' => '',
      'Changed' => '',
      'Changed by' => '',
      'Search' => '',
      'and' => '',
      'between' => '',
      'Fulltext Search' => '',
      'Data' => '',
      'Options' => 'Optionen',
      'Title' => '',
      'Item' => '',
      'Delete' => '',
      'Edit' => '',
      'View' => 'Ansicht',
      'Number' => '',
      'System' => '',
      'Contact' => 'Kontakt',
      'Contacts' => '',
      'Export' => '',
      'Up' => '',
      'Down' => '',
      'Add' => '',
      'Category' => '',
      'Viewer' => '',
      'New message' => 'Neue Nachricht',
      'New message!' => 'Neue Nachricht!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Bitte beantworten Sie dieses Ticket um in die normale queue view zurück zu kommen!',
      'You got new message!' => '',
      'You have %s new message(s)!' => '%s neue Nachricht(en) bekommen!',
      'You have %s reminder ticket(s)!' => '%s Erinnerungs-Ticket(s)!',
      'The recommended charset for your language is %s!' => 'Der empfohlene Charset für Ihre Sprache ist %s!',
      'Passwords doesn\'t match! Please try it again!' => '',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'koane Vorschläge',
      'Word' => 'Wort',
      'Ignore' => 'Ignorieren',
      'replace with' => 'ersetzen mit',
      'Welcome to OTRS' => 'Willkommen zu OTRS',
      'There is no account with that login name.' => 'Es existiert kein Login mit diesen Namen.',
      'Login failed! Your username or password was entered incorrectly.' => 'Login fehlgeschlagen! Benutzername oder Passwort falsch.',
      'Please contact your admin' => 'Bitte kontaktieren Sie Ihren Admin',
      'Logout successful. Thank you for using OTRS!' => 'Abmelden erfolgreich! Danke für die Benutzung von OTRS!',
      'Invalid SessionID!' => '',
      'Feature not active!' => '',
      'License' => '',
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
      'Mar' => 'Mär',
      'Apr' => '',
      'May' => 'Mai',
      'Jun' => '',
      'Jul' => '',
      'Aug' => '',
      'Sep' => '',
      'Oct' => 'Okt',
      'Nov' => '',
      'Dec' => 'Dez',

      # Template: AAANavBar
      'Admin-Area' => 'Admin-Bereich',
      'Agent-Area' => '',
      'Ticket-Area' => '',
      'Logout' => 'Abmelden',
      'Agent Preferences' => '',
      'Preferences' => 'Einstellungen',
      'Agent Mailbox' => '',
      'Stats' => 'Statistik',
      'Stats-Area' => '',
      'FAQ-Area' => '',
      'FAQ' => '',
      'FAQ-Search' => '',
      'FAQ-Article' => '',
      'New Article' => '',
      'FAQ-State' => '',
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
      'Customer Users' => '',
      'Customer Users <-> Groups' => '',
      'Users <-> Groups' => '',
      'Roles' => '',
      'Roles <-> Users' => '',
      'Roles <-> Groups' => '',
      'Salutations' => '',
      'Signatures' => '',
      'Email Addresses' => 'Email-Adressen',
      'Notifications' => '',
      'Category Tree' => '',
      'Admin Notification' => '',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Update der Benutzereinstellungen erfolgreich!',
      'Mail Management' => '',
      'Frontend' => '',
      'Other Options' => 'Andere Optionen',
      'Change Password' => 'Passwort ändern',
      'New password' => 'Neis Passwort',
      'New password again' => 'Neis Passwort wiederholen',
      'Select your QueueView refresh time.' => 'Queue-Ansicht Aktualisierungszeit auswählen',
      'Select your frontend language.' => 'Oberflächen-Sprache auswählen.',
      'Select your frontend Charset.' => 'Zeichensatz für Darstellung auswählen.',
      'Select your frontend Theme.' => 'Anzeigeschema auswählen.',
      'Select your frontend QueueView.' => 'Queue-Ansicht auswählen.',
      'Spelling Dictionary' => '',
      'Select your default spelling dictionary.' => '',
      'Max. shown Tickets a page in Overview.' => '',
      'Can\'t update password, passwords doesn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

      # Template: AAATicket
      'Lock' => 'Ziehen',
      'Unlock' => 'Freigeben',
      'History' => '',
      'Zoom' => 'Inhalt',
      'Age' => 'Alter',
      'Bounce' => '',
      'Forward' => 'Weiterleiten',
      'From' => 'Von',
      'To' => 'An',
      'Cc' => '',
      'Bcc' => '',
      'Subject' => 'Betreff',
      'Move' => 'Verschieben',
      'Queue' => '',
      'Priority' => 'Priorität',
      'State' => 'Status',
      'Compose' => 'Verfassen',
      'Pending' => 'Warten',
      'Owner' => 'Besitzer',
      'Owner Update' => '',
      'Sender' => '',
      'Article' => 'Artikel',
      'Ticket' => '',
      'Createtime' => 'Erstellt am',
      'plain' => 'klar',
      'Email' => '',
      'email' => 'Email',
      'Close' => 'Schließen',
      'Action' => 'Aktion',
      'Attachment' => 'Anlage',
      'Attachments' => 'Anlagen',
      'This message was written in a character set other than your own.' => 'Diese Nachricht wurde in einem Zeichensatz erstellt, der nicht Ihrem eigenen entspricht.',
      'If it is not displayed correctly,' => 'Wenn sie nicht korrekt angezeigt wird,',
      'This is a' => 'Dies ist eine',
      'to open it in a new window.' => 'um sie in einem neuen Fenster angezeigt zu bekommen',
      'This is a HTML email. Click here to show it.' => 'Dies ist eine HTML Email. Do klicken um sie anzusehen.',
      'Free Fields' => '',
      'Merge' => '',
      'closed successful' => 'erfolgreich geschlossen',
      'closed unsuccessful' => 'erfolglos geschlossen',
      'new' => 'neu',
      'open' => 'offen',
      'closed' => '',
      'removed' => 'entfernt',
      'pending reminder' => '',
      'pending auto close+' => '',
      'pending auto close-' => '',
      'email-external' => 'Email an extern',
      'email-internal' => 'Email an intern',
      'note-external' => 'Notiz für extern',
      'note-internal' => 'Notiz für intern',
      'note-report' => 'Notiz für reporting',
      'phone' => 'Telefon',
      'sms' => '',
      'webrequest' => 'Webanfrage',
      'lock' => '',
      'unlock' => 'freigeben',
      'very low' => 'sehr niedrig',
      'low' => 'niedrig',
      'normal' => '',
      'high' => 'hoch',
      'very high' => 'sehr hoch',
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
      'Locked Tickets' => 'Eigene Tickets',
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
      'My Queues' => '',
      'Shown Tickets' => '',
      'New ticket notification' => 'Mitteilung bei neuem Ticket',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Follow up notification' => 'Mitteilung bei Nachfragen',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Zusenden einer Mitteilung wenn ein Kunden eine Nachfrage stellt uns ich der Eigner bin.',
      'Ticket lock timeout notification' => 'Mitteilung bei lock Zeitüberschreitung',
      'Send me a notification if a ticket is unlocked by the system.' => 'Zusenden einer Mitteilung wenn ein Ticket vom System freigegeben (unlocked) wird.',
      'Move notification' => 'Move Mitteilung',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => '',
      'QueueView refresh time' => 'Queue-Ansicht refresh Zeit',
      'Screen after new ticket' => '',
      'Select your screen after creating a new ticket.' => '',
      'Closed Tickets' => '',
      'Show closed tickets.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Responses' => 'Antworten',
      'Responses <-> Queue' => 'Antworten <-> Queues',
      'Auto Responses' => 'Auto-Antworten',
      'Auto Responses <-> Queue' => '',
      'Attachments <-> Responses' => '',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Bounce' => 'Bounced to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::AddNote' => 'Added note (%s)',
      'History::Lock' => 'Locked ticket.',
      'History::Unlock' => 'Unlocked ticket.',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Remove' => '%s',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::TicketLinkAdd' => '',
      'History::TicketLinkDelete' => '',

      # Template: AAAWeekDay
      'Sun' => 'Son',
      'Mon' => '',
      'Tue' => 'Die',
      'Wed' => 'Mit',
      'Thu' => 'Don',
      'Fri' => 'Fre',
      'Sat' => 'Sam',

      # Template: AdminAttachmentForm
      'Attachment Management' => '',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Auto-Antworten Verwaltung',
      'Response' => 'Antwort',
      'Auto Response From' => 'Auto-Antwort Form',
      'Note' => 'Notiz',
      'Useable options' => 'Benutzbare Optionen',
      'to get the first 20 character of the subject' => 'Um die ersten 20 Zeichen des Betreffs zu bekommen',
      'to get the first 5 lines of the email' => 'Um die ersten 5 Zeilen der Email zu bekommen',
      'to get the from line of the email' => '',
      'to get the realname of the sender (if given)' => '',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Die erstellte Nachricht wurde geschlossen.',
      'This window must be called from compose window' => 'Dieses Fenster muss über das Verfassen-Fenster aufgerufen werden',
      'Customer User Management' => 'Kunden-Benutzer Management',
      'Search for' => '',
      'Result' => '',
      'Select Source (for add)' => '',
      'Source' => '',
      'This values are read only.' => '',
      'This values are required.' => '',
      'Customer user will be needed to have a customer history and to login via customer panel.' => '',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => '',
      'Change %s settings' => 'Ändern der %s Einstellungen',
      'Select the user:group permissions.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => '',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => '',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => '',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Nachricht gesendet an',
      'Recipents' => 'Empfänger',
      'Body' => '',
      'send' => '',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => '',
      'Last run' => '',
      'Run Now!' => '',
      'x' => '',
      'Save Job as?' => '',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
      'Schedule' => '',
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
      'CustomerUser' => 'Kunden-Benutzer',
      'Add Note' => 'Notiz anheften',
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
      'Group Management' => 'Gruppen Verwaltung',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Die admin Gruppe wird für den Admin-Bereich benötigt, die stats Gruppe für den Statistik-Bereich.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Erstelle neue Gruppen um die Zugriffe für verschieden Agent-Gruppen zu definieren (z. B. Einkaufs-Abteilung, Support-Abteilung, Verkaufs-Abteilung, ...).',
      'It\'s useful for ASP solutions.' => 'Sehr nützlich für ASP-Lösungen.',

      # Template: AdminLog
      'System Log' => '',
      'Time' => '',

      # Template: AdminNavigationBar
      'Users' => '',
      'Groups' => 'Gruppen',
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
      'Key' => 'Schlüssel',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3Form
      'POP3 Account Management' => '',
      'Host' => 'Rechner',
      'Trusted' => '',
      'Dispatching' => '',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Einkommende emails von POP3 Accounts werden in die ausgewählte Queue einsortiert!',
      'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

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
      'Queue Management' => 'Queue Verwaltung',
      'Sub-Queue of' => '',
      'Unlock timeout' => 'Freigabe Zeitüberschreitung',
      '0 = no unlock' => '0 = kein Unlock',
      'Escalation time' => 'Eskalationszeit',
      '0 = no escalation' => '0 = koane Eskalation',
      'Follow up Option' => '',
      'Ticket lock after a follow up' => 'Ticket locken nache einem follow up',
      'Systemaddress' => 'System-Adresse',
      'Customer Move Notify' => '',
      'Customer State Notify' => '',
      'Customer Owner Notify' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wird ein Ticket durch einen Agent gelocked jedoch nicht in dieser Zeit beantwortet, wird das Ticket automatisch unlocked.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Wird ein Ticket nicht in jener Zeit beantortet, wird nur noch dieses Ticket gezeigt.',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wenn ein Ticket geschlossen ist und der Kunde jedoch ein follow up sendet, wird das ticket für den alten Eigner gelocked.',
      'Will be the sender address of this queue for email answers.' => 'Absende Adresse für Emails aus dieser Queue.',
      'The salutation for email answers.' => 'Die Anrede für Email Antworten.',
      'The signature for email answers.' => 'Die Signatur für Email Antworten.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => '',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => '',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => '',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => '',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Antwort',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => '',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Antworten Verwaltung',
      'A response is default text to write faster answer (with default text) to customers.' => 'Eine Antwort ist ein vorgegebener Text um schneller Antworten an Kundern schreiben zu können.',
      'Don\'t forget to add a new response a queue!' => 'Eine neue Antwort muss auch einer Queue zugewiesen werden!',
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
      'Role' => '',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => '',
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Anreden Verwaltung',
      'customer realname' => 'echter Kundenname',
      'for agent firstname' => 'für Vorname des Agents',
      'for agent lastname' => 'für Nachname des Agents',
      'for agent user id' => '',
      'for agent login' => '',

      # Template: AdminSelectBoxForm
      'Select Box' => '',
      'SQL' => '',
      'Limit' => '',
      'Select Box Result' => 'Select Box Ergebnis',

      # Template: AdminSession
      'Session Management' => 'Sitzungs Verwaltung',
      'Sessions' => '',
      'Uniq' => '',
      'kill all sessions' => 'Löschen alles Sitzungen',
      'Session' => '',
      'kill session' => 'Sitzung löschen',

      # Template: AdminSignatureForm
      'Signature Management' => 'Signatur Verwaltung',

      # Template: AdminSMIMEForm
      'S/MIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'System-State Verwaltung',
      'State Type' => '',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',
      'See also' => '',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => '',
      'Show' => '',
      'Download Settings' => '',
      'Download all system config changes.' => '',
      'Load Settings' => '',
      'Subgroup' => '',
      'Elements' => '',

      # Template: AdminSysConfigEdit
      'Config Options' => '',
      'Default' => '',
      'Content' => '',
      'New' => '',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'Image' => '',
      'Prio' => '',
      'Block' => '',
      'NavBar' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'System-Email-Adressen Verwaltung',
      'Email' => 'Email',
      'Realname' => '',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle eingehenden Emails mit dem "To:" werden in die ausgewählte Queue einsortiert.',

      # Template: AdminUserForm
      'User Management' => 'Benutzer Verwaltung',
      'Firstname' => 'Vorname',
      'Lastname' => 'Nachname',
      'User will be needed to handle tickets.' => 'Benutzer werden benötigt um Tickets zu bearbeietn.',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => '',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => '',
      'Return to the compose screen' => 'Zurück zum Verfassen-Fenster',
      'Discard all changes and return to the compose screen' => 'Verwerfen aller Änderungen und zurück zum Verfassen-Fenster',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => '',

      # Template: AgentLinkObject
      'Link Object' => '',
      'Select' => '',
      'Results' => 'Ergebnis',
      'Total hits' => 'Treffa gesamt',
      'Site' => 'Seite',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Rechtschreibkontrolle',
      'spelling error(s)' => 'Rechtschreibfehler',
      'or' => '',
      'Apply these changes' => 'Änderungen übernehmen',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Eine Nachricht sollte einen Empfänger im An: haben!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Im An-Feld wird eine Email-Adresse (z. B. kunde@beispiel.de) benötigt!',
      'Bounce ticket' => '',
      'Bounce to' => 'Bounce an',
      'Next ticket state' => 'Nächster Status des Tickets',
      'Inform sender' => 'Sender informieren',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => '',
      'Send mail!' => 'Mail senden!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Eine Nachricht sollte ein Betreff haben!',
      'Ticket Bulk Action' => '',
      'Spell Check' => 'Rechtschreibkontrolle',
      'Note type' => 'Notiz-Typ',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => '',
      'You need to account time!' => '',
      'Close ticket' => 'Ticket schließen',
      'Note Text' => 'Notiz Text',
      'Close type' => 'Schließen Type',
      'Time units' => 'Zeit-Einheiten',
      ' (work units)' => ' (arbeits Einheiten)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => '',
      'Compose answer for ticket' => 'Antwort erstellen für',
      'Attach' => 'Anhängen',
      'Pending Date' => '',
      'for pending* states' => '',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Ändern des Kunden von Ticket',
      'Set customer user and customer id of a ticket' => '',
      'Customer User' => 'Kunden Benutzer',
      'Search Customer' => '',
      'Customer Data' => 'Kunden Daten',
      'Customer history' => 'Kunden History',
      'All customer tickets.' => '',

      # Template: AgentTicketCustomerMessage
      'Follow up' => '',

      # Template: AgentTicketEmail
      'Compose Email' => '',
      'new ticket' => 'Neis Ticket',
      'Clear To' => '',
      'All Agents' => '',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Artikel-Typ',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => '',

      # Template: AgentTicketHistory
      'History of' => 'History von',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket gesperrt!',
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
      'Add note to ticket' => 'Anheften einer Notiz an Ticket',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Ändern Eigners von Ticket',
      'Message for new Owner' => 'Nachricht an neuen Eigner',

      # Template: AgentTicketPending
      'Set Pending' => '',
      'Pending type' => '',
      'Pending date' => '',

      # Template: AgentTicketPhone
      'Phone call' => 'Angrufa',

      # Template: AgentTicketPhoneNew
      'Clear From' => '',

      # Template: AgentTicketPlain
      'Plain' => '',
      'TicketID' => '',
      'ArticleID' => '',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Zugewiesene Zeit',
      'Escalation in' => '',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => '',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Priorität ändern für Ticket',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Tickets gezeigt',
      'Page' => '',
      'Tickets available' => 'Ticket verfügbar',
      'All tickets' => 'Alle Tickets',
      'Queues' => '',
      'Ticket escalation!' => 'Ticket Eskalation!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => '',
      'Compose Follow up' => '',
      'Compose Answer' => 'Antwort erstellen',
      'Contact customer' => 'Kunden kontaktieren',
      'Change queue' => 'Wechsle Queue',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => '',
      'Profile' => '',
      'Search-Template' => '',
      'Created in Queue' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Yes, save it with name' => '',
      'Customer history search' => 'Kunden-History-Suche',
      'Customer history search (e. g. "ID342425").' => 'Kunden History Suche (z. B. "ID342425").',
      'No * possible!' => 'Kein * möglich!',

      # Template: AgentTicketSearchResult
      'Search Result' => '',
      'Change search options' => '',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'Sortierung aufwärts',
      'U' => '',
      'sort downward' => 'Sortierung abwärts',
      'D' => '',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => '',

      # Template: AgentTicketZoom
      'Split' => '',

      # Template: AgentTicketZoomStatus
      'Locked' => '',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => '',

      # Template: CustomerFAQ
      'Print' => '',
      'Keywords' => '',
      'Symptom' => '',
      'Problem' => '',
      'Solution' => '',
      'Modified' => '',
      'Last update' => '',
      'FAQ System History' => '',
      'modified' => '',
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',
      'FAQ Search Result' => '',
      'FAQ Overview' => '',

      # Template: CustomerFooter
      'Powered by' => '',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => '',
      'Lost your password?' => 'Passwort verschmissn?',
      'Request new password' => 'Neis Passwort beantragen',
      'Create Account' => 'Account erstellen',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Willkommen %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => 'von',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Klicken Sie Do um einen Fehla zu berichten!',

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
      'QueueView' => 'Queue-Ansicht',
      'PhoneView' => 'Telefon-Ansicht',
      'Top of Page' => '',

      # Template: FooterSmall

      # Template: Header
      'Home' => '',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => '',
      'accept license' => '',
      'don\'t accept license' => '',
      'Admin-User' => '',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',
      'Database-User' => '',
      'default \'hot\'' => '',
      'DB connect host' => '',
      'Database' => '',
      'Create' => 'Erstellen',
      'false' => '',
      'SystemID' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
      'System FQDN' => '',
      '(Full qualified domain name of your system)' => '',
      'AdminEmail' => '',
      '(Email of the system admin)' => '',
      'Organization' => '',
      'Log' => '',
      'LogModule' => '',
      '(Used log backend)' => '',
      'Logfile' => '',
      '(Logfile just needed for File-LogModule!)' => '',
      'Webfrontend' => '',
      'Default Charset' => '',
      'Use utf-8 it your database supports it!' => '',
      'Default Language' => '',
      '(Used default language)' => '',
      'CheckMXRecord' => '',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Restart your webserver' => '',
      'After doing so your OTRS is up and running.' => '',
      'Start page' => '',
      'Have a lot of fun!' => '',
      'Your OTRS Team' => '',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'koane Erlaubnis',

      # Template: Notify
      'Important' => '',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => '',

      # Template: Redirect

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => 'OTRS Test Seite',
      'Counter' => '',

      # Template: Warning
      # Misc
      'Change signature settings' => 'Ändern einer Signatur',
      'Change system address setting' => 'Ändere System-Adresse',
      'Products' => 'Produkt',
      'Change group settings' => 'Ändern einer Gruppe',
      'search (e. g. 10*5155 or 105658*)' => 'Suche (z. B. 10*5155 or 105658*)',
      'User <-> Group Management' => 'Benutzer <-> Gruppe Verwaltung',
      'tickets' => 'Tickets',
      'Forwarded message from' => '',
      'User <-> Groups' => 'Benutzer <-> Gruppen',
      'Charsets' => '',
      'Ticket Number Generator' => '',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      'Time till escalation' => 'Zeit bis zur Escalation',
      'Update queue' => 'Queue aktualisieren',
      'Create new Ticket' => 'Neis Ticket erstellen',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Zusenden einer Mitteilung bei neuem Ticket in der/den individuellen Queue(s).',
      '(Click here to add charset)' => '(Hier klicken - Charset hinzufügen',
      'Update signature' => 'Signatur aktualisieren',
      'POP3 Account' => '',
      '(Click here to add a system email address)' => '(Hier klicken - System-Email-Adresse hinzufügen)',
      'Add user' => 'Benutzer hinzufügen',
      'Add signature' => 'Signatur hinzufügen',
      'Article free text' => 'Artikel frei Text',
      'Ticket Hook' => '',
      'Close!' => 'Schließen!',
      'Change queue settings' => 'Ändern einer Queue',
      'Add language' => 'Sprache hinzufügen',
      'Add queue' => 'Queue hinzufügen',
      'Add group' => 'Gruppe hinzufügen',
      'Don\'t forget to add a new user to groups!' => 'Eine neuer Benutzer muss auch einer Gruppe zugewiesen werden!',
      '(Click here to add a signature)' => '(Hier klicken - Signatur hinzufügen)',
      'phone call' => 'Angrufaen',
      'Update charset' => 'Charset aktualisieren',
      'Change customer user settings' => 'Ämdern der Kunden-Benutzers einstellungen',
      'Status defs' => '',
      'Update state' => 'State aktualisieren',
      'BackendMessage' => 'Backend-Nachricht',
      'Add salutation' => 'Anrede hinzufügen',
      'open tickets' => 'offene Tickets',
      'Fulltext search' => 'Volltext-Suche',
      'New ticket via call.' => 'Neis Ticket durch Angrufa.',
      'Change attachment settings' => '',
      'Ticket-Overview' => 'Ticket-Übersicht',
      'Is the ticket answered' => 'Ist das Ticket beantwortet',
      '(Click here to add a queue)' => '(Hier klicken - Queue hinzufügen)',
      'New Ticket' => 'Neis Ticket',
      'Update language' => 'Sprache aktualisieren',
      'Forward article of ticket' => 'Weiterleitung des Artikels vom Ticket',
      'Add charset' => 'Charset hinzufügen',
      'SessionID' => '',
      '(Click here to add a user)' => '(Hier klicken - Benutzer hinzufügen)',
      'A message should have a From: recipient!' => 'Eine Nachricht sollte einen Absender im Von: haben!',
      'System Language Management' => 'System-Sprache Verwaltung',
      'Add system address' => 'System-Email-Adresse hinzufügen',
      'Add response' => 'Antwort hinzufügen',
      'Update user' => 'Benutzer aktualisieren',
      'Update system address' => 'System-Email-Adresse aktualisieren',
      'Send me a notification if a ticket is moved into a custom queue.' => ' Zusenden einer Mitteilung beim verschieben eines Ticket in meine individuellen Queue(s).',
      'Std. Responses <-> Queue Management' => 'Std. Antworten <-> Queue Verwaltung',
      'to get the ticket number of the ticket' => '',
      'Add customer user' => 'Hinzufügen eines Kunden-Benutzers',
      '(Click here to add state)' => '(Hier klicken - state hinzufügen)',
      '(Click here to add a salutation)' => '(Hier klicken - Anrede hinzufügen)',
      'Reply-To' => '',
      'My Tickets' => 'Meine Tickets',
      'Online-Support' => '',
      'Change system state setting' => 'Ändere System-State',
      'Change user <-> group settings' => 'Ändern der Benutzer <-> Gruppe Beziehung',
      'Update group' => 'Gruppe aktualisieren',
      'You need a email address (e. g. customer@example.com) in From:!' => 'Im From-Feld wird eine Email-Adresse (z. B. kunde@beispiel.de) benötigt!',
      'Backend' => '',
      'next step' => 'Nächster Schritt',
      'Change system language setting' => 'Ändere System-Sprache',
      'If your account is trusted, the X-OTRS header (for priority, ...) will be used!' => 'Ist der Account trusted, werden die X-OTRS Header benutzt!',
      'Admin-Email' => '',
      '(Click here to add an auto response)' => '(Hier klicken - Auto-Antwort hinzufügen)',
      'Search in' => 'Suche in',
      'OTRS-Admin Info!' => '',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Volltextsuche (z. B. "Mar*in" oder "Baue*" oder "martin+hallo")',
      'System Charset Management' => 'System-Charset Verwaltung',
      'New user' => 'Neuer Eigner',
      'Add attachment' => '',
      'Set customer id of a ticket' => 'Setze eine Kunden# zu einem Ticket',
      'Show all' => 'Alle gezeigt',
      'Change response settings' => 'Ändern einer Antwort',
      'Open' => '',
      'You have to be in the stats group!' => 'Sie müssen hierfür in der Statistik-Gruppe sein!',
      'Change answer <-> queue settings' => 'Ändern der Antworten <-> Queue Beziehung',
      'New state' => 'Neue Priorität',
      'Phone call at %s' => 'Angrufa um %s',
      'Date' => 'Datum',
      'Add auto response' => 'Auto-Antwort hinzufügen',
      'All open tickets' => 'Alle offenen Tickets',
      'Std. Responses <-> Std. Attachment Management' => '',
      'You have to be in the admin group!' => 'Sie müssen hierfür in der Admin-Gruppe sein!',
      'Change  settings' => '',
      '(Click here to add language)' => '(Hier klicken - Sprache hinzufügen)',
      'Auto Response <-> Queue' => 'Auto-Antworten <-> Queues',
      'Change user settings' => 'Ändern der Benutzereinstellung',
      'Add state' => 'State hinzufügen',
      'Select your custom queues' => 'Bevorzugte Queues auswählen',
      'Update auto response' => 'Auto-Antwort aktualisieren',
      'Ticket limit:' => '',
      'Update salutation' => 'Anrede aktualisieren',
      'Graphs' => 'Diagramme',
      'Add POP3 Account' => 'POP3 Account hinzufügen',
      '(Click here to add a group)' => '(Hier klicken - Gruppe hinzufügen)',
      'Queue <-> Auto Response Management' => 'Queue <-> Auto-Antworten Verwaltung',
      'So you see what is going on in your system.' => 'Somit können Sie sehen, was in Ihrem System vorgeht.',
      'Ticket free text' => 'Ticket frei Text',
      '(Click here to add a response)' => '(Hier klicken - Antwort hinzufügen)',
      'Change salutation settings' => 'Ändern einer Anrede',
      'AgentFrontend' => 'AgentOberfläche',
      'store' => 'speichern',
      'Change Response <-> Attachment settings' => '',
      'auto responses set' => 'Auto-Antworten gesetzt',
      'Change system charset setting' => 'Ändere System-Charset',
      'Change auto response settings' => 'Ändern einer Auto-Antworten',
      'Ticket Status' => '',
      'Customer user will be needed to login via customer panels.' => 'Kunden-Benutzer werden für das Kunden-Webfrontend benötigt',
      'Support' => '',
      'Open messages' => '',
      'Customer called' => 'Kunden angerufen',
      'Provides an overview of all' => 'Bietet eine Übersicht von allen',
      'Note!' => 'Notiz!',
      'Charset' => '',
      'Utilities' => 'Werkzeuge',
      'search' => 'Sucha',
      'new message' => 'neue Nachricht',
      'Max Rows' => 'Max. Zeile',
      'Change POP3 Account setting' => 'POP3 Account ändern',
      '(Used ticket number format)' => '',
      'End forwarded message' => '',
      'Update response' => 'Antworten aktualisieren',
      'Handle' => '',
      'Watched Tickets' => '',
      'Watched' => '',
    };
    # $$STOP$$

    $Self->{Translation} = \%Hash;
}

1;
