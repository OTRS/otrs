# --
# Kernel/Language/sv.pm - Swedish language translation
# Copyright (C) 2004 Mats Eric Olausson <mats@synergy.se>
# --
# $Id: sv.pm,v 1.47 2008-05-28 07:27:30 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Language::sv;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = q$Revision: 1.47 $;

sub Data {
    my ( $Self, %Param ) = @_;

    # $$START$$
    # Last translation file sync: Fri May 16 14:09:02 2008

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat}          = '%D/%M %Y %T';
    $Self->{DateFormatLong}      = '%A %D. %B %Y %T';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Ja',
        'No' => 'Nej',
        'yes' => 'ja',
        'no' => 'inga',
        'Off' => 'Av',
        'off' => 'av',
        'On' => 'På',
        'on' => 'på',
        'top' => 'topp',
        'end' => 'slut',
        'Done' => 'Klar',
        'Cancel' => 'Avbryt',
        'Reset' => 'Nollställ',
        'last' => 'sista',
        'before' => 'före',
        'day' => 'dag',
        'days' => 'dagar',
        'day(s)' => 'dag(ar)',
        'hour' => 'timme',
        'hours' => 'timmar',
        'hour(s)' => '',
        'minute' => 'minut',
        'minutes' => 'minuter',
        'minute(s)' => '',
        'month' => '',
        'months' => '',
        'month(s)' => 'månad(er)',
        'week' => '',
        'week(s)' => 'vecka(or)',
        'year' => '',
        'years' => '',
        'year(s)' => 'år',
        'second(s)' => '',
        'seconds' => '',
        'second' => '',
        'wrote' => 'skrev',
        'Message' => 'Meddelande',
        'Error' => 'Fel',
        'Bug Report' => 'Rapportera fel',
        'Attention' => 'OBS',
        'Warning' => 'Varning',
        'Module' => 'Modul',
        'Modulefile' => 'Modulfil',
        'Subfunction' => 'Underfunktion',
        'Line' => 'Rad',
        'Example' => 'Exempel',
        'Examples' => 'Exempel',
        'valid' => 'giltig',
        'invalid' => 'ogiltig',
        '* invalid' => '',
        'invalid-temporarily' => '',
        ' 2 minutes' => ' 2 minuter',
        ' 5 minutes' => ' 5 minuter',
        ' 7 minutes' => ' 7 minuter',
        '10 minutes' => '10 minuter',
        '15 minutes' => '15 minuter',
        'Mr.' => '',
        'Mrs.' => '',
        'Next' => '',
        'Back' => 'Tillbaka',
        'Next...' => '',
        '...Back' => '',
        '-none-' => '',
        'none' => 'inga',
        'none!' => 'inga!',
        'none - answered' => 'inga - besvarat',
        'please do not edit!' => 'Var vänlig och ändra inte detta!',
        'AddLink' => 'Lägg till länk',
        'Link' => 'Länk',
        'Unlink' => '',
        'Linked' => '',
        'Link (Normal)' => '',
        'Link (Parent)' => '',
        'Link (Child)' => '',
        'Normal' => '',
        'Parent' => '',
        'Child' => '',
        'Hit' => 'Träff',
        'Hits' => 'Träffar',
        'Text' => '',
        'Lite' => 'Enkel',
        'User' => 'Användare',
        'Username' => 'Användarnamn',
        'Language' => 'Språk',
        'Languages' => 'Språk',
        'Password' => 'Lösenord',
        'Salutation' => 'Hälsning',
        'Signature' => 'Signatur',
        'Customer' => 'Kund',
        'CustomerID' => 'Organisations-ID',
        'CustomerIDs' => '',
        'customer' => 'kund',
        'agent' => '',
        'system' => 'System',
        'Customer Info' => 'Kundinfo',
        'Customer Company' => '',
        'Company' => '',
        'go!' => 'Starta!',
        'go' => 'Starta',
        'All' => 'Alla',
        'all' => 'alla',
        'Sorry' => 'Beklagar',
        'update!' => 'Uppdatera!',
        'update' => 'uppdatera',
        'Update' => 'Uppdatera',
        'submit!' => 'Skicka!',
        'submit' => 'Skicka',
        'Submit' => '',
        'change!' => 'ändra!',
        'Change' => 'Ändra',
        'change' => 'ändra',
        'click here' => 'klicka här',
        'Comment' => 'Kommentar',
        'Valid' => 'Giltigt',
        'Invalid Option!' => '',
        'Invalid time!' => '',
        'Invalid date!' => '',
        'Name' => 'Namn',
        'Group' => 'Grupp',
        'Description' => 'Beskrivning',
        'description' => 'beskrivning',
        'Theme' => 'Tema',
        'Created' => 'Skapat',
        'Created by' => '',
        'Changed' => '',
        'Changed by' => '',
        'Search' => 'Sök',
        'and' => 'og',
        'between' => '',
        'Fulltext Search' => '',
        'Data' => '',
        'Options' => 'Tillval',
        'Title' => '',
        'Item' => '',
        'Delete' => 'Radera',
        'Edit' => 'Redigera',
        'View' => 'Bild',
        'Number' => '',
        'System' => '',
        'Contact' => 'Kontakt',
        'Contacts' => '',
        'Export' => '',
        'Up' => '',
        'Down' => '',
        'Add' => 'Lägg till',
        'Category' => 'Kategori',
        'Viewer' => '',
        'New message' => 'Nytt meddelande',
        'New message!' => 'Nytt meddelande!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Vänligen besvara denna/dessa ärenden för att komma tillbaka till den normala kö-visningsbilden!',
        'You got new message!' => 'Du har fått ett nytt meddelande!',
        'You have %s new message(s)!' => 'Du har %s nya meddelanden!',
        'You have %s reminder ticket(s)!' => 'Du har %s påminnelse-ärende(n)!',
        'The recommended charset for your language is %s!' => 'Den rekommenderade teckenuppsättningen för ditt språk är %s!',
        'Passwords doesn\'t match! Please try it again!' => '',
        'Password is already in use! Please use an other password!' => '',
        'Password is already used! Please use an other password!' => '',
        'You need to activate %s first to use it!' => '',
        'No suggestions' => 'Inga förslag',
        'Word' => 'Ord',
        'Ignore' => 'Ignorera',
        'replace with' => 'Ersätt med',
        'There is no account with that login name.' => 'Det finns inget konto med detta namn.',
        'Login failed! Your username or password was entered incorrectly.' => 'Inloggningen misslyckades! Angivet användarnamn och/eller lösenord är inte korrekt.',
        'Please contact your admin' => 'Vänligen kontakta administratören',
        'Logout successful. Thank you for using OTRS!' => 'Utloggningen lyckades.  Tack för att du använde OTRS!',
        'Invalid SessionID!' => 'Ogiltigt SessionID!',
        'Feature not active!' => 'Funktion inte aktiverad!',
        'Login is needed!' => '',
        'Password is needed!' => '',
        'License' => 'Licens',
        'Take this Customer' => '',
        'Take this User' => 'Välj denna användare',
        'possible' => 'möjlig',
        'reject' => 'Avvisas',
        'reverse' => '',
        'Facility' => 'Innrättning',
        'Timeover' => 'Tidsöverträdelse',
        'Pending till' => 'Väntande tills',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Det är inte rekommenderat att arbeta som userid 1 (systemkonto)! Skapa nya användare!',
        'Dispatching by email To: field.' => 'Skickar iväg enligt epostmeddelandets Till:-fält.',
        'Dispatching by selected Queue.' => '',
        'No entry found!' => 'Ingen inmatning funnen!',
        'Session has timed out. Please log in again.' => 'Sessionstiden har löpt ut.  Vänligen logga på igen.',
        'No Permission!' => '',
        'To: (%s) replaced with database email!' => 'Till: (%s) ersatt med epost från databas!',
        'Cc: (%s) added database email!' => '',
        '(Click here to add)' => '(Klicka här för att lägga till)',
        'Preview' => 'Forhandsvisning',
        'Package not correctly deployed! You should reinstall the Package again!' => '',
        'Added User "%s"' => '',
        'Contract' => '',
        'Online Customer: %s' => '',
        'Online Agent: %s' => '',
        'Calendar' => '',
        'File' => '',
        'Filename' => 'Filnamn',
        'Type' => 'Typ',
        'Size' => '',
        'Upload' => '',
        'Directory' => '',
        'Signed' => '',
        'Sign' => '',
        'Crypted' => '',
        'Crypt' => '',
        'Office' => '',
        'Phone' => '',
        'Fax' => '',
        'Mobile' => '',
        'Zip' => '',
        'City' => '',
        'Street' => '',
        'Country' => '',
        'installed' => '',
        'uninstalled' => '',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => '',
        'Dear Mr. %s,' => '',
        'Dear Mrs. %s,' => '',
        'Dear %s,' => '',
        'Hello %s,' => '',
        'This account exists.' => '',
        'New account created. Sent Login-Account to %s.' => '',
        'Please press Back and try again.' => '',
        'Sent password token to: %s' => '',
        'Sent new password to: %s' => '',
        'Invalid Token!' => '',

        # Template: AAAMonth
        'Jan' => 'jan',
        'Feb' => 'feb',
        'Mar' => 'mar',
        'Apr' => 'apr',
        'May' => 'maj',
        'Jun' => 'jun',
        'Jul' => 'jul',
        'Aug' => 'aug',
        'Sep' => 'sep',
        'Oct' => 'okt',
        'Nov' => 'nov',
        'Dec' => 'dec',
        'January' => '',
        'February' => '',
        'March' => '',
        'April' => '',
        'June' => '',
        'July' => '',
        'August' => '',
        'September' => '',
        'October' => '',
        'November' => '',
        'December' => '',

        # Template: AAANavBar
        'Admin-Area' => 'Admin-område',
        'Agent-Area' => 'Agent-område',
        'Ticket-Area' => '',
        'Logout' => 'Logga ut',
        'Agent Preferences' => '',
        'Preferences' => 'Inställningar',
        'Agent Mailbox' => '',
        'Stats' => 'Statistik',
        'Stats-Area' => '',
        'Admin' => '',
        'Customer Users' => '',
        'Customer Users <-> Groups' => '',
        'Users <-> Groups' => '',
        'Roles' => '',
        'Roles <-> Users' => '',
        'Roles <-> Groups' => '',
        'Salutations' => '',
        'Signatures' => '',
        'Email Addresses' => '',
        'Notifications' => '',
        'Category Tree' => '',
        'Admin Notification' => '',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Inställningar lagrade!',
        'Mail Management' => 'Eposthantering',
        'Frontend' => 'Gränssnitt',
        'Other Options' => 'Andra tillval',
        'Change Password' => '',
        'New password' => '',
        'New password again' => '',
        'Select your QueueView refresh time.' => 'Välj automatisk uppdateringsintervall för Kö-bild.',
        'Select your frontend language.' => 'Välj språk.',
        'Select your frontend Charset.' => 'Välj teckenuppsättning.',
        'Select your frontend Theme.' => 'Välj stil-tema.',
        'Select your frontend QueueView.' => 'Välj Kö-bild.',
        'Spelling Dictionary' => 'Stavningslexikon',
        'Select your default spelling dictionary.' => 'Välj standard ordbok for stavningskontroll.',
        'Max. shown Tickets a page in Overview.' => 'Max. visade ärenden per sida i Översikt.',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => '',
        'Can\'t update password, invalid characters!' => '',
        'Can\'t update password, need min. 8 characters!' => '',
        'Can\'t update password, need 2 lower and 2 upper characters!' => '',
        'Can\'t update password, need min. 1 digit!' => '',
        'Can\'t update password, need min. 2 characters!' => '',

        # Template: AAAStats
        'Stat' => '',
        'Please fill out the required fields!' => '',
        'Please select a file!' => '',
        'Please select an object!' => '',
        'Please select a graph size!' => '',
        'Please select one element for the X-axis!' => '',
        'You have to select two or more attributes from the select field!' => '',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => '',
        'If you use a checkbox you have to select some attributes of the select field!' => '',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
        'The selected end time is before the start time!' => '',
        'You have to select one or more attributes from the select field!' => '',
        'The selected Date isn\'t valid!' => '',
        'Please select only one or two elements via the checkbox!' => '',
        'If you use a time scale element you can only select one element!' => '',
        'You have an error in your time selection!' => '',
        'Your reporting time interval is too small, please use a larger time scale!' => '',
        'The selected start time is before the allowed start time!' => '',
        'The selected end time is after the allowed end time!' => '',
        'The selected time period is larger than the allowed time period!' => '',
        'Common Specification' => '',
        'Xaxis' => '',
        'Value Series' => '',
        'Restrictions' => '',
        'graph-lines' => '',
        'graph-bars' => '',
        'graph-hbars' => '',
        'graph-points' => '',
        'graph-lines-points' => '',
        'graph-area' => '',
        'graph-pie' => '',
        'extended' => '',
        'Agent/Owner' => '',
        'Created by Agent/Owner' => '',
        'Created Priority' => '',
        'Created State' => '',
        'Create Time' => '',
        'CustomerUserLogin' => '',
        'Close Time' => '',

        # Template: AAATicket
        'Lock' => 'Lås',
        'Unlock' => 'Lås upp',
        'History' => 'Historik',
        'Zoom' => '',
        'Age' => 'Ålder',
        'Bounce' => 'Studsa',
        'Forward' => 'Vidarebefordra',
        'From' => 'Från',
        'To' => 'Till',
        'Cc' => '',
        'Bcc' => '',
        'Subject' => 'Ämne',
        'Move' => 'Flytta',
        'Queue' => 'Kö',
        'Priority' => 'Prioritet',
        'Priority Update' => '',
        'State' => 'Status',
        'Compose' => 'Författa',
        'Pending' => 'Väntande',
        'Owner' => 'Ägare',
        'Owner Update' => '',
        'Responsible' => '',
        'Responsible Update' => '',
        'Sender' => 'Avsändare',
        'Article' => 'Artikel',
        'Ticket' => 'Ärende',
        'Createtime' => 'Tidpunkt för skapande',
        'plain' => 'rå',
        'Email' => '',
        'email' => '',
        'Close' => 'Stäng',
        'Action' => 'Åtgärd',
        'Attachment' => 'Bifogat dokument',
        'Attachments' => 'Bifogade dokument',
        'This message was written in a character set other than your own.' => 'Detta meddelande är skrivet med en annan teckenuppsättning än den du använder.',
        'If it is not displayed correctly,' => 'Ifall det inte visas korrekt,',
        'This is a' => 'Detta är en',
        'to open it in a new window.' => 'för att öppna i ett nytt fönster',
        'This is a HTML email. Click here to show it.' => 'Detta är ett HTML-email. Klicka här för att visa.',
        'Free Fields' => '',
        'Merge' => '',
        'merged' => '',
        'closed successful' => 'Löst och stängt',
        'closed unsuccessful' => 'Olöst men stängt',
        'new' => 'ny',
        'open' => 'öppen',
        'closed' => '',
        'removed' => 'borttagen',
        'pending reminder' => 'väntar på påminnelse',
        'pending auto' => '',
        'pending auto close+' => 'väntar på att stängas (löst)',
        'pending auto close-' => 'väntar på att stängas (olöst)',
        'email-external' => 'email externt',
        'email-internal' => 'email internt',
        'note-external' => 'notis externt',
        'note-internal' => 'notis internt',
        'note-report' => 'notis till rapport',
        'phone' => 'telefon',
        'sms' => '',
        'webrequest' => 'web-anmodan',
        'lock' => 'låst',
        'unlock' => 'upplåst',
        'very low' => 'planeras',
        'low' => 'låg',
        'normal' => '',
        'high' => 'hög',
        'very high' => 'kritisk',
        '1 very low' => '1 Planeras',
        '2 low' => '2 låg',
        '3 normal' => '3 medium',
        '4 high' => '4 hög',
        '5 very high' => '5 kritisk',
        'Ticket "%s" created!' => 'Ärende "%s" skapad!',
        'Ticket Number' => '',
        'Ticket Object' => '',
        'No such Ticket Number "%s"! Can\'t link it!' => '',
        'Don\'t show closed Tickets' => 'Visa inte låsta ärenden',
        'Show closed Tickets' => 'Visa låsta ärenden',
        'New Article' => 'Ny artikel',
        'Email-Ticket' => '',
        'Create new Email Ticket' => '',
        'Phone-Ticket' => '',
        'Search Tickets' => '',
        'Edit Customer Users' => '',
        'Edit Customer Company' => '',
        'Bulk-Action' => '',
        'Bulk Actions on Tickets' => '',
        'Send Email and create a new Ticket' => '',
        'Create new Email Ticket and send this out (Outbound)' => '',
        'Create new Phone Ticket (Inbound)' => '',
        'Overview of all open Tickets' => '',
        'Locked Tickets' => '',
        'Watched Tickets' => '',
        'Watched' => '',
        'Subscribe' => '',
        'Unsubscribe' => '',
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
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',
        'Ticket %s: first response time is over (%s)!' => '',
        'Ticket %s: first response time will be over in %s!' => '',
        'Ticket %s: update time is over (%s)!' => '',
        'Ticket %s: update time will be over in %s!' => '',
        'Ticket %s: solution time is over (%s)!' => '',
        'Ticket %s: solution time will be over in %s!' => '',
        'There are more escalated tickets!' => '',
        'New ticket notification' => 'Meddelande om nyskapat ärende',
        'Send me a notification if there is a new ticket in "My Queues".' => '',
        'Follow up notification' => 'Meddelande om uppföljning',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Skicka mig ett meddelande om kundkorrespondens för ärenden som jag är ägare till.',
        'Ticket lock timeout notification' => 'Meddela mig då tiden gått ut för ett ärende-lås',
        'Send me a notification if a ticket is unlocked by the system.' => 'Skicka mig ett meddelande ifall systemet tar bort låset på ett ärende.',
        'Move notification' => 'Meddelande om ändring av kö',
        'Send me a notification if a ticket is moved into one of "My Queues".' => '',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => '',
        'Custom Queue' => 'Utvald kö',
        'QueueView refresh time' => 'Automatisk uppdateringsintervall fö Kö-bild',
        'Screen after new ticket' => 'Skärm efter inmatning av nytt ärende',
        'Select your screen after creating a new ticket.' => 'Välj skärmbild som visas efter registrering av ny hänvisning/ärende.',
        'Closed Tickets' => 'Låsta ärenden',
        'Show closed tickets.' => 'Visa låsta ärenden.',
        'Max. shown Tickets a page in QueueView.' => 'Max. visade ärenden per sida i Kö-bild.',
        'CompanyTickets' => '',
        'MyTickets' => '',
        'New Ticket' => '',
        'Create new Ticket' => '',
        'Customer called' => '',
        'phone call' => '',
        'Responses' => 'Svar',
        'Responses <-> Queue' => '',
        'Auto Responses' => '',
        'Auto Responses <-> Queue' => '',
        'Attachments <-> Responses' => '',
        'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
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
        'History::TicketLinkAdd' => 'Added link to ticket "%s".',
        'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
        'History::Subscribe' => 'Added subscription for user "%s".',
        'History::Unsubscribe' => 'Removed subscription for user "%s".',

        # Template: AAAWeekDay
        'Sun' => 'sön',
        'Mon' => 'mån',
        'Tue' => 'tis',
        'Wed' => 'ons',
        'Thu' => 'tor',
        'Fri' => 'fre',
        'Sat' => 'lör',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Hantering av bifogade dokument',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Autosvar-hantering',
        'Response' => 'Svar',
        'Auto Response From' => 'autosvar-avsändare',
        'Note' => 'Notis',
        'Useable options' => 'Användbara tillägg',
        'To get the first 20 character of the subject.' => '',
        'To get the first 5 lines of the email.' => '',
        'To get the realname of the sender (if given).' => '',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => '',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => '',
        'Search for' => '',
        'Add Customer Company' => '',
        'Add a new Customer Company.' => '',
        'List' => '',
        'This values are required.' => '',
        'This values are read only.' => '',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Kundanvändare',
        'Add Customer User' => '',
        'Source' => 'Källa',
        'Create' => '',
        'Customer user will be needed to have a customer history and to login via customer panel.' => '',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => '',
        'Change %s settings' => 'Ändra %s-inställningar',
        'Select the user:group permissions.' => 'Välj användar:grupp-rettigheter.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Om ingenting är valt finns inga rättigheter i denna grupp (ärenden i denna grupp kommer inte att finnas tillgängliga för användaren).',
        'Permission' => 'Rättighet',
        'ro' => '',
        'Read only access to the ticket in this group/queue.' => 'Endast läsrättighet till ärenden i denna grupp/kö.',
        'rw' => '',
        'Full read and write access to the tickets in this group/queue.' => 'Fulla läs- och skrivrättigheter till ärenden i denna grupp/kö.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => '',
        'CustomerUser' => 'Kundanvändare',
        'Service' => '',
        'Edit default services.' => '',
        'Search Result' => 'Sökeresultat',
        'Allocate services to CustomerUser' => '',
        'Active' => '',
        'Allocate CustomerUser to service' => '',

        # Template: AdminEmail
        'Message sent to' => 'Meddelande skicakt till',
        'Recipents' => 'Mottagare',
        'Body' => 'Meddelandetext',
        'Send' => '',

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
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fritextsök i artiklar (t.ex. "Mar*in" eller "Baue*")',
        '(e. g. 10*5155 or 105658*)' => 't.ex. 10*5144 eller 105658*',
        '(e. g. 234321)' => 't.ex. 234321',
        'Customer User Login' => 'kundanvändare loginnamn',
        '(e. g. U5150)' => 't.ex. U5150',
        'SLA' => '',
        'Agent' => '',
        'Ticket Lock' => '',
        'TicketFreeFields' => '',
        'Create Times' => '',
        'No create time settings.' => '',
        'Ticket created' => 'Ärende skapat',
        'Ticket created between' => 'Ärendet skapat mellan',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Pending Times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'New Service' => '',
        'New SLA' => '',
        'New Priority' => '',
        'New Queue' => 'Ny Kö',
        'New State' => '',
        'New Agent' => '',
        'New Owner' => 'Ny ägare',
        'New Customer' => '',
        'New Ticket Lock' => '',
        'New Type' => '',
        'New Title' => '',
        'New Type' => '',
        'New TicketFreeFields' => '',
        'Add Note' => 'Lägg till anteckning',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
        'Delete tickets' => '',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
        'Send Notification' => '',
        'Param 1' => '',
        'Param 2' => '',
        'Param 3' => '',
        'Param 4' => '',
        'Param 5' => '',
        'Param 6' => '',
        'Send no notifications' => '',
        'Yes means, send no agent and customer notifications on changes.' => '',
        'No means, send agent and customer notifications on changes.' => '',
        'Save' => '',
        '%s Tickets affected! Do you really want to use this job?' => '',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'grupphantering',
        'Add Group' => '',
        'Add a new Group.' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' => '\'admin\'-gruppen ger tillgång till Admin-arean, \'stats\'-gruppen till Statistik-arean.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Skapa nya grupper för att kunna handtera olika rättigheter för skilda grupper av agenter (t.ex. inköpsavdelning, supportavdelning, försäljningsavdelning, ...).',
        'It\'s useful for ASP solutions.' => 'Nyttigt för ASP-lösningar.',

        # Template: AdminLog
        'System Log' => 'Systemlogg',
        'Time' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => '',
        'Trusted' => 'Betrodd',
        'Dispatching' => 'Fördelning',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Inkommande email från POP3-konton sorteras till vald kö!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

        # Template: AdminNavigationBar
        'Users' => '',
        'Groups' => 'grupper',
        'Misc' => 'Div',

        # Template: AdminNotificationForm
        'Notification Management' => 'Meddelandehantering',
        'Notification' => '',
        'Notifications are sent to an agent or a customer.' => 'Meddelanden skickats till agenter eller kunder.',

        # Template: AdminPackageManager
        'Package Manager' => '',
        'Uninstall' => '',
        'Version' => '',
        'Do you really want to uninstall this package?' => '',
        'Reinstall' => '',
        'Do you really want to reinstall this package (all manual changes get lost)?' => '',
        'Continue' => '',
        'Install' => '',
        'Package' => '',
        'Online Repository' => '',
        'Vendor' => '',
        'Upgrade' => '',
        'Local Repository' => '',
        'Status' => '',
        'Overview' => 'Översikt',
        'Download' => '',
        'Rebuild' => '',
        'ChangeLog' => '',
        'Date' => '',
        'Filelist' => '',
        'Download file from package!' => '',
        'Required' => '',
        'PrimaryKey' => '',
        'AutoIncrement' => '',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => '',
        'This feature is enabled!' => '',
        'Just use this feature if you want to log each request.' => '',
        'Of couse this feature will take some system performance it self!' => '',
        'Disable it here!' => '',
        'This feature is disabled!' => '',
        'Enable it here!' => '',
        'Logfile too large!' => '',
        'Logfile too large, you need to reset it!' => '',
        'Range' => '',
        'Interface' => '',
        'Requests' => '',
        'Min Response' => '',
        'Max Response' => '',
        'Average Response' => '',
        'Period' => '',
        'Min' => '',
        'Max' => '',
        'Average' => '',

        # Template: AdminPGPForm
        'PGP Management' => '',
        'Result' => '',
        'Identifier' => '',
        'Bit' => '',
        'Key' => 'Nyckel',
        'Fingerprint' => '',
        'Expires' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' => '',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '',
        'Filtername' => '',
        'Match' => 'Träff',
        'Header' => '',
        'Value' => 'Innehåll',
        'Set' => '',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => '',

        # Template: AdminQueueForm
        'Queue Management' => 'Köhantering',
        'Sub-Queue of' => 'Underkö till',
        'Unlock timeout' => 'Tidsintervall för borttagning av lås',
        '0 = no unlock' => '0 = ingen upplåsning',
        'Only business hours are counted.' => '',
        'Escalation - First Response Time' => '',
        '0 = no escalation' => '0 = ingen upptrappning',
        'Only business hours are counted.' => '',
        'Notify by' => '',
        'Escalation - Update Time' => '',
        'Notify by' => '',
        'Escalation - Solution Time' => '',
        'Follow up Option' => 'Korrespondens på låst ärende',
        'Ticket lock after a follow up' => 'Ärendet låses efter uppföljningsmail',
        'Systemaddress' => 'Systemadress',
        'Customer Move Notify' => 'Meddelande om flytt av kund',
        'Customer State Notify' => 'Meddelande om statusändring för Kund',
        'Customer Owner Notify' => 'Meddelande om byte av ägare av Kund',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ifall ett ärende som är låst av en agent men ändå inte blir besvarat inom denna tid, kommer låset automatiskt att tas bort.',
        'Escalation time' => 'Upptrappningstid',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Ifall ett ärende inte blir besvarat inom denna tid, visas enbart detta ärende.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ifall en kund skickar uppföljningsmail på ett låst ärende, blir ärendet låst till förra ägaren.',
        'Will be the sender address of this queue for email answers.' => 'Avsändaradress för email i denna Kö.',
        'The salutation for email answers.' => 'Hälsningsfras för email-svar.',
        'The signature for email answers.' => 'Signatur för email-svar.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS skickar ett meddelande till kunden ifall ärendet flyttas.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS skickar ett meddelande till kunden vid statusuppdatering.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS skickar ett meddelande till kunden vid ägarbyte.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => '',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Svar',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => '',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Hantera svar',
        'A response is default text to write faster answer (with default text) to customers.' => 'Ett svar är en standardtext för att underlätta besvarandet av vanliga kundfrågor.',
        'Don\'t forget to add a new response a queue!' => 'Kom ihåg att lägga till ett nytt svar till en kö!',
        'The current ticket state is' => 'Nuvarande ärende-status',
        'Your email address is new' => '',

        # Template: AdminRoleForm
        'Role Management' => '',
        'Add Role' => '',
        'Add a new Role.' => '',
        'Create a role and put groups in it. Then add the role to the users.' => '',
        'It\'s useful for a lot of users and groups.' => '',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => '',
        'move_into' => 'Flytta till',
        'Permissions to move tickets into this group/queue.' => 'Rätt att flytta ärenden i denna grupp/Kö.',
        'create' => 'Skapa',
        'Permissions to create tickets in this group/queue.' => 'Rätt att skapa ärenden i denna grupp/Kö.',
        'owner' => 'Ägare',
        'Permissions to change the ticket owner in this group/queue.' => 'Rätt att ändra ärende-ägare i denna grupp/Kö.',
        'priority' => 'prioritet',
        'Permissions to change the ticket priority in this group/queue.' => 'Rätt att ändra ärendeprioritet i denna grupp/Kö.',

        # Template: AdminRoleGroupForm
        'Role' => '',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => '',
        'Select the role:user relations.' => '',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Hantering av Hälsningsfraser',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Limit' => '',
        'Go' => '',
        'Select Box Result' => 'Select Box Resultat',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => '',
        'Add a new Service.' => '',
        'Sub-Service of' => '',

        # Template: AdminSession
        'Session Management' => 'Sessionshantering',
        'Sessions' => 'Sessioner',
        'Uniq' => '',
        'Kill all sessions' => '',
        'Session' => '',
        'Content' => '',
        'kill session' => 'Terminera session',

        # Template: AdminSignatureForm
        'Signature Management' => 'Signaturhantering',
        'Add Signature' => '',
        'Add a new Signature.' => '',

        # Template: AdminSLA
        'SLA Management' => '',
        'Add SLA' => '',
        'Add a new SLA.' => '',

        # Template: AdminSMIMEForm
        'S/MIME Management' => '',
        'Add Certificate' => '',
        'Add Private Key' => '',
        'Secret' => '',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => '',

        # Template: AdminStateForm
        'State Management' => '',
        'Add State' => '',
        'Add a new State.' => '',
        'State Type' => 'Statustyp',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Se till att du också uppdaterade standardutgångslägena i Kernel/Config.pm!',
        'See also' => 'Se också',

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
        'New' => 'Nytt',
        'New Group' => '',
        'Group Ro' => '',
        'New Group Ro' => '',
        'NavBarName' => '',
        'NavBar' => '',
        'Image' => '',
        'Prio' => '',
        'Block' => '',
        'AccessKey' => '',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Hantera System-emailadresser',
        'Add System Address' => '',
        'Add a new System Address.' => '',
        'Realname' => 'Fullständigt namn',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alla inkommande mail till denna adressat (To:) delas ut till vald kö.',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'Användarhantering',
        'Add User' => '',
        'Add a new Agent.' => '',
        'Login as' => '',
        'Firstname' => 'Förnamn',
        'Lastname' => 'Efternamn',
        'User will be needed to handle tickets.' => 'Användare krävs för att hantera ärenden.',
        'Don\'t forget to add a new user to groups and/or roles!' => '',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => '',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adressbok',
        'Return to the compose screen' => 'Stäng fönstret',
        'Discard all changes and return to the compose screen' => 'Bortse från ändringarna och stäng fönstret',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => '',

        # Template: AgentLinkObject
        'Link Object' => '',
        'Select' => 'Välj',
        'Results' => 'Resultat',
        'Total hits' => 'Totalt hittade',
        'Page' => 'Sida',
        'Detail' => '',

        # Template: AgentLookup
        'Lookup' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Stavningskontroll',
        'spelling error(s)' => 'Stavfel',
        'or' => 'eller',
        'Apply these changes' => 'Verkställ ändringar',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => '',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => '',
        'Fixed' => '',
        'Please select only one element or turn off the button \'Fixed\'.' => '',
        'Absolut Period' => '',
        'Between' => '',
        'Relative Period' => '',
        'The last' => '',
        'Finish' => '',
        'Here you can make restrictions to your stat.' => '',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => '',
        'Permissions' => '',
        'Format' => '',
        'Graphsize' => '',
        'Sum rows' => '',
        'Sum columns' => '',
        'Cache' => '',
        'Required Field' => '',
        'Selection needed' => '',
        'Explanation' => '',
        'In this form you can select the basic specifications.' => '',
        'Attribute' => '',
        'Title of the stat.' => '',
        'Here you can insert a description of the stat.' => '',
        'Dynamic-Object' => '',
        'Here you can select the dynamic object you want to use.' => '',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '',
        'Static-File' => '',
        'For very complex stats it is possible to include a hardcoded file.' => '',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => '',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => '',
        'Multiple selection of the output format.' => '',
        'If you use a graph as output format you have to select at least one graph size.' => '',
        'If you need the sum of every row select yes' => '',
        'If you need the sum of every column select yes.' => '',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => '',
        '(Note: Useful for big databases and low performance server)' => '',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => '',
        'Scale' => '',
        'minimal' => '',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => '',
        'maximal period' => '',
        'minimal scale' => '',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => '',
        'File is not a Stats config' => '',
        'No File selected' => '',

        # Template: AgentStatsOverview
        'Object' => '',

        # Template: AgentStatsPrint
        'Print' => 'Skriv ut',
        'No Element selected.' => '',

        # Template: AgentStatsView
        'Export Config' => '',
        'Information about the Stat' => '',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => '',
        'maximal period from' => '',
        'to' => '',
        'Start' => '',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Skicka över ärende',
        'Ticket locked!' => 'Ärendet låst',
        'Ticket unlock!' => 'Ärendet upplåst',
        'Bounce to' => 'Skicka över till',
        'Next ticket state' => 'Nästa ärendestatus',
        'Inform sender' => 'Informera avsändare',
        'Send mail!' => 'Skicka mail!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '',
        'Spell Check' => 'Stavningskontroll',
        'Note type' => 'Anteckningstyp',
        'Unlock Tickets' => '',

        # Template: AgentTicketClose
        'Close ticket' => 'Stäng ärende',
        'Previous Owner' => 'Tidigare ägare',
        'Inform Agent' => '',
        'Optional' => '',
        'Inform involved Agents' => '',
        'Attach' => 'Bifoga',
        'Next state' => 'Nästa tillstånd',
        'Pending date' => 'Väntande datum',
        'Time units' => 'Tidsenheter',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Författa svar till ärende',
        'Pending Date' => 'Väntar till',
        'for pending* states' => 'för väntetillstånd',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Ändra kund för ärende',
        'Set customer user and customer id of a ticket' => 'Ange kundanvändare och organisations-id för ett ärende',
        'Customer User' => 'Kundanvändare',
        'Search Customer' => 'Sök kund',
        'Customer Data' => 'Kunddata',
        'Customer history' => 'Kundhistorik',
        'All customer tickets.' => 'Alla kundärenden.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Uppföljning',

        # Template: AgentTicketEmail
        'Compose Email' => 'Skriv email',
        'new ticket' => 'Nytt ärende',
        'Refresh' => '',
        'Clear To' => '',

        # Template: AgentTicketEscalationView
        'Ticket Escalation View' => '',
        'Escalation' => '',
        'Today' => '',
        'Tomorrow' => '',
        'Next Week' => '',
        'up' => 'stigande',
        'down' => 'sjunkande',
        'Escalation' => '',
        'Locked' => '',

        # Template: AgentTicketForward
        'Article type' => 'Artikeltyp',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Ändra friatextfält i ärende',

        # Template: AgentTicketHistory
        'History of' => 'Historik för',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => '',
        'Tickets' => 'Ärenden',
        'of' => 'av',
        'Filter' => '',
        'New messages' => 'Nya meddelanden',
        'Reminder' => 'Påminnelse',
        'Sort by' => 'Sortera efter',
        'Order' => 'Sortering',

        # Template: AgentTicketMerge
        'Ticket Merge' => '',
        'Merge to' => '',

        # Template: AgentTicketMove
        'Move Ticket' => 'Flytta ärende',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Lägg till anteckning till ärende',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Ändra ett ärendes ägare',

        # Template: AgentTicketPending
        'Set Pending' => 'Markera som väntande',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefonsamtal',
        'Clear From' => 'Nollställ Från:',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Enkel',

        # Template: AgentTicketPrint
        'Ticket-Info' => '',
        'Accounted time' => 'Redovisad tid',
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',
        'Linked-Object' => '',
        'Parent-Object' => '',
        'Child-Object' => '',
        'by' => 'av',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Ändra ärendeprioritet',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Ärenden som visas',
        'Tickets available' => 'Tillgängliga ärenden',
        'All tickets' => 'Alla ärenden',
        'Queues' => 'Köer',
        'Ticket escalation!' => 'Ärende-upptrappning!',

        # Template: AgentTicketQueueTicketView
        'Service Time' => '',
        'Your own Ticket' => 'Ditt eget ärende',
        'Compose Follow up' => 'Skriv uppföljningssvar',
        'Compose Answer' => 'Skriv svar',
        'Contact customer' => 'Kontakta kund',
        'Change queue' => 'Ändra kö',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => '',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Ärende-sök',
        'Profile' => 'Profil',
        'Search-Template' => 'Sökmall',
        'TicketFreeText' => '',
        'Created in Queue' => '',
        'Close Times' => '',
        'No close time settings.' => '',
        'Ticket closed' => '',
        'Ticket closed between' => '',
        'Result Form' => 'Resultatbild',
        'Save Search-Profile as Template?' => 'Spara sökkriterier som mall?',
        'Yes, save it with name' => 'Ja, spara med namn',

        # Template: AgentTicketSearchOpenSearchDescription

        # Template: AgentTicketSearchResult
        'Change search options' => 'Ändra sökinställningar',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort

        # Template: AgentTicketStatusView
        'Ticket Status View' => '',
        'Open Tickets' => '',

        # Template: AgentTicketZoom
        'Expand View' => '',
        'Collapse View' => '',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => '',

        # Template: CustomerFooter
        'Powered by' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => '',
        'Lost your password?' => 'Glömt lösenordet?',
        'Request new password' => 'Be om nytt lösenord',
        'Create Account' => 'Skapa konto',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Välkommen %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Tider',
        'No time settings.' => 'Inga tidsinställningar.',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klicka här för att rapportera ett fel!',

        # Template: Footer
        'Top of Page' => 'Början av sidan',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-installation',
        'Welcome to %s' => 'Välkommen till %s',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Admin-användare',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => '',
        'Database-User' => '',
        'default \'hot\'' => '',
        'DB connect host' => '',
        'Database' => '',
        'Default Charset' => 'Standard teckenuppsättning',
        'utf8' => '',
        'false' => '',
        'SystemID' => '',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Unikt id för detta system.  Alla ärendenummer och http-sesssionsid börjar med denna id)',
        'System FQDN' => '',
        '(Full qualified domain name of your system)' => '(Fullt kvalificerat dns-namn för ditt system)',
        'AdminEmail' => 'Admin-email',
        '(Email of the system admin)' => '(Email till systemadmin)',
        'Organization' => 'Organisation',
        'Log' => '',
        'LogModule' => '',
        '(Used log backend)' => '(Valt logg-backend)',
        'Logfile' => 'Logfil',
        '(Logfile just needed for File-LogModule!)' => '(Logfil behövs enbart för File-LogModule!)',
        'Webfrontend' => 'Web-gränssnitt',
        'Use utf-8 it your database supports it!' => 'Använd utf-8 ifall din databas stödjer det!',
        'Default Language' => 'Standardspråk',
        '(Used default language)' => '(Valt standardspråk)',
        'CheckMXRecord' => '',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrollerar mx-uppslag för uppgivna emailadresser i meddelanden som skrivs.  Använd inte CheckMXRecord om din OTRS-maskin är bakom en uppringd lina!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'För att kunna använda OTRS, måste följende rad skrivas på kommandoraden som root.',
        'Restart your webserver' => 'Starta om din webserver',
        'After doing so your OTRS is up and running.' => 'Efter detta är OTRS igång.',
        'Start page' => 'Startsida',
        'Your OTRS Team' => 'Ditt OTRS-Team',

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ingen åtkomst',

        # Template: Notify
        'Important' => '',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'utskrivet av',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS Test-sida',
        'Counter' => '',

        # Template: Warning
        # Misc
        'Edit Article' => '',
        'Create Database' => 'Skapa databas',
        'DB Host' => 'DB host',
        'Ticket Number Generator' => 'Ärende-nummergenerator',
        'Symptom' => '',
        'U' => '',
        'A message should have a To: recipient!' => 'Ett meddelande måste ha en mottagare i Till:-fältet!',
        'Site' => 'plats',
        'Customer history search (e. g. "ID342425").' => 'Sök efter kundhistorik (t.ex. "ID342425").',
        'Close!' => 'Stäng!',
        'for agent firstname' => 'för agents förnamn',
        'Subgroup \'' => '',
        'The message being composed has been closed.  Exiting.' => 'Det tilhörande redigeringsfönstret har stängts. Avslutar.',
        'A web calendar' => '',
        'to get the realname of the sender (if given)' => 'för att få fram avsändarens fulla namn (om möjligt)',
        'OTRS DB Name' => 'OTRS DB namn',
        'Notification (Customer)' => '',
        'Select Source (for add)' => '',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Days' => '',
        'Queue ID' => 'Kö-id',
        'Home' => 'Hem',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Konfigurationsval (t.ex. <OTRS_CONFIG_HttpType>)',
        'System History' => '',
        'customer realname' => 'Fullt kundnamn',
        'Pending messages' => 'Väntande meddelanden',
        'Port' => '',
        'for agent login' => 'för agents login',
        'Keyword' => 'Nyckelord',
        'Close type' => 'Stängningstillstånd',
        'DB Admin User' => 'DB Adminanvändare',
        'for agent user id' => 'för agents användar-id',
        'sort upward' => 'Sortera stigande',
        'Change user <-> group settings' => 'Ändra användar- <-> grupp-inställningar',
        'Problem' => '',
        'for ' => '',
        'next step' => 'nästa steg',
        'Customer history search' => 'Kundhistorik',
        'Admin-Email' => 'Admin-email',
        'Stat#' => '',
        'Create new database' => 'Skapa ny databas',
        'A message must be spell checked!' => 'Stavningskontroll måste utföras på alla meddelanden!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Emailen med ärendenummer "<OTRS_TICKET>" har skickats över till "<OTRS_BOUNCE_TO>". Vänligen kontakta denna adress för vidare hänvisningar.',
        'A message should have a body!' => 'Ett meddelande måste innehålla en meddelandetext!',
        'All Agents' => 'Alla agenter',
        'Keywords' => 'Nyckelord',
        'No * possible!' => 'Wildcards * inte tillåtna!',
        'Options ' => '',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Message for new Owner' => 'Meddelande till ny ägare',
        'to get the first 5 lines of the email' => 'för att få fram de första 5 raderna av emailen',
        'OTRS DB Password' => 'OTRS DB lösenord',
        'Last update' => 'Senast ändrat',
        'to get the first 20 character of the subject' => 'för att få fram de förste 20 tecknen i ämnesbeskrivningen',
        'Select the customeruser:service relations.' => '',
        'DB Admin Password' => 'DB Adminlösenord',
        'Drop Database' => 'Radera databas',
        'FileManager' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'ger tillgång till data för gällande kund (t.ex. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Väntande typ',
        'Comment (internal)' => 'Kommentar (intern)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'This window must be called from compose window' => 'Denne funktion måste startas från redigeringsfönstret',
        'Minutes' => '',
        'You need min. one selected Ticket!' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        '(Used ticket number format)' => '(Valt format för ärendenummer)',
        'Fulltext' => 'Fritext',
        ' (work units)' => ' (arbetsenheter)',
        'Operation' => '',
        'accept license' => 'godkänn licens',
        'for agent lastname' => 'för agents efternamn',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'ger tillgång till data för agenten som utför handlingen (t.ex. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Påminnelsemeddelanden',
        'A message should have a subject!' => 'Ett meddelande måste ha en Ämnesrad!',
        'IMAPS' => '',
        'TicketZoom' => 'Ärende Zoom',
        'Don\'t forget to add a new user to groups!' => 'Glöm inte att lägga in en ny användare i en grupp!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'I Till-fältet måste anges en giltig emailadress (t.ex. kund@exempeldomain.se)!',
        'CreateTicket' => 'Skapa Ärende',
        'You need to account time!' => 'Du måste redovisa tiden!',
        'System Settings' => 'Systeminställningar',
        'WebWatcher' => '',
        'Hours' => '',
        'Finished' => 'Klar',
        'Account Type' => '',
        'Split' => 'Dela',
        'D' => 'N',
        'All messages' => 'Alla meddelanden',
        'System Status' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'A article should have a title!' => '',
        'Event' => '',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'don\'t accept license' => 'godkänn inte licens',
        'A web mail client' => '',
        'IMAP' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'Article time' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'ger tillgang till data för agenten som står som ägare till ärendet (t.ex. <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => '',
        'DB Type' => 'DB typ',
        'kill all sessions' => 'Terminera alla sessioner',
        'to get the from line of the email' => 'för att få fram avsändarraden i emailen',
        'Solution' => 'Lösning',
        'QueueView' => 'Köer',
        'Select Box' => 'SQL-access',
        'modified' => '',
        'Calculator' => '',
        'Escalation in' => 'Upptrappning om',
        'Delete old database' => 'Radera gammal databas',
        'sort downward' => 'Sortera sjunkande',
        'You need to use a ticket number!' => '',
        'A web file manager' => '',
        'Have a lot of fun!' => 'Ha det så roligt!',
        'send' => 'Skicka',
        'Note Text' => 'Anteckingstext',
        'POP3 Account Management' => 'Administration av POP3-Konto',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => 'Hantering av systemstatus',
        'OTRS DB User' => 'OTRS DB användare',
        'PhoneView' => 'Tel.samtal',
        'maximal period form' => '',
        'Verion' => '',
        'Management Summary' => '',
        'POP3' => '',
        'POP3S' => '',
        'Modified' => 'Ändrat',
        'Ticket selected for bulk action!' => '',
    };
    # $$STOP$$
    return;
}

1;
