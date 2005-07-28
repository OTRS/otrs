# --
# Kernel/Language/nb_SW.pm - Swedish language translation
# Copyright (C) 2004 Mats Eric Olausson <mats@synergy.se>
# --
# $Id: sv.pm,v 1.10 2005-07-28 20:32:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::sv;

use strict;

use vars qw($VERSION);
$VERSION = q$Revision: 1.10 $;
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:14:53 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M %Y %T';
    $Self->{DateFormatLong} = '%A %D. %B %Y %T';
    $Self->{DateInputFormat} = '%D.%M.%Y';
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
      'Passwords dosn\'t match! Please try it again!' => '',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'Inga förslag',
      'Word' => 'Ord',
      'Ignore' => 'Ignorera',
      'replace with' => 'Ersätt med',
      'Welcome to OTRS' => 'Välkommen till OTRS',
      'There is no account with that login name.' => 'Det finns inget konto med detta namn.',
      'Login failed! Your username or password was entered incorrectly.' => 'Inloggningen misslyckades! Angivet användarnamn och/eller lösenord är inte korrekt.',
      'Please contact your admin' => 'Vänligen kontakta administratören',
      'Logout successful. Thank you for using OTRS!' => 'Utloggningen lyckades.  Tack för att du använde OTRS!',
      'Invalid SessionID!' => 'Ogiltigt SessionID!',
      'Feature not active!' => 'Funktion inte aktiverad!',
      'Take this Customer' => '',
      'Take this User' => 'Välj denna användare',
      'possible' => 'möjlig',
      'reject' => 'Avvisas',
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
      'FAQ-Area' => 'FAQ-område',
      'FAQ' => '',
      'FAQ-Search' => '',
      'FAQ-Article' => '',
      'New Article' => 'Ny artikel',
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
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

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
      'State' => 'Status',
      'Compose' => 'Författa',
      'Pending' => 'Väntande',
      'Owner' => 'Ägare',
      'Owner Update' => '',
      'Sender' => 'Avsändare',
      'Article' => 'Artikel',
      'Ticket' => 'Ärende',
      'Createtime' => 'Tidpunkt för skapande',
      'plain' => 'rå',
      'eMail' => '',
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
      'closed successful' => 'Löst och stängt',
      'closed unsuccessful' => 'Olöst men stängt',
      'new' => 'ny',
      'open' => 'öppen',
      'closed' => '',
      'removed' => 'borttagen',
      'pending reminder' => 'väntar på påminnelse',
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
      'Locked Tickets' => '',
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
      'New ticket notification' => 'Meddelande om nyskapat ärende',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Follow up notification' => 'Meddelande om uppföljning',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Skicka mig ett meddelande om kundkorrespondens för ärenden som jag är ägare till.',
      'Ticket lock timeout notification' => 'Meddela mig då tiden gått ut för ett ärende-lås',
      'Send me a notification if a ticket is unlocked by the system.' => 'Skicka mig ett meddelande ifall systemet tar bort låset på ett ärende.',
      'Move notification' => 'Meddelande om ändring av kö',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => '',
      'Custom Queue' => 'Utvald kö',
      'QueueView refresh time' => 'Automatisk uppdateringsintervall fö Kö-bild',
      'Screen after new ticket' => 'Skärm efter inmatning av nytt ärende',
      'Select your screen after creating a new ticket.' => 'Välj skärmbild som visas efter registrering av ny hänvisning/ärende.',
      'Closed Tickets' => 'Låsta ärenden',
      'Show closed tickets.' => 'Visa låsta ärenden.',
      'Max. shown Tickets a page in QueueView.' => 'Max. visade ärenden per sida i Kö-bild.',
      'Responses' => 'Svar',
      'Responses <-> Queue' => '',
      'Auto Responses' => '',
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
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',

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
      'to get the first 20 character of the subject' => 'för att få fram de förste 20 tecknen i ämnesbeskrivningen',
      'to get the first 5 lines of the email' => 'för att få fram de första 5 raderna av emailen',
      'to get the from line of the email' => 'för att få fram avsändarraden i emailen',
      'to get the realname of the sender (if given)' => 'för att få fram avsändarens fulla namn (om möjligt)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Det tilhörande redigeringsfönstret har stängts. Avslutar.',
      'This window must be called from compose window' => 'Denne funktion måste startas från redigeringsfönstret',
      'Customer User Management' => 'Kundanvändare',
      'Search for' => '',
      'Result' => '',
      'Select Source (for add)' => '',
      'Source' => 'Källa',
      'This values are read only.' => '',
      'This values are required.' => '',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',

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

      # Template: AdminEmail
      'Message sent to' => 'Meddelande skicakt till',
      'Recipents' => 'Mottagare',
      'Body' => 'Meddelandetext',
      'send' => 'Skicka',

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
      'Agent' => '',
      'TicketFreeText' => '',
      'Ticket Lock' => '',
      'Times' => 'Tider',
      'No time settings.' => 'Inga tidsinställningar.',
      'Ticket created' => 'Ärende skapat',
      'Ticket created between' => 'Ärendet skapat mellan',
      'New Priority' => '',
      'New Queue' => 'Ny Kö',
      'New State' => '',
      'New Agent' => '',
      'New Owner' => 'Ny ägare',
      'New Customer' => '',
      'New Ticket Lock' => '',
      'CustomerUser' => 'Kundanvändare',
      'Add Note' => 'Lägg till anteckning',
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
      'Group Management' => 'grupphantering',
      'The admin group is to get in the admin area and the stats group to get stats area.' => '\'admin\'-gruppen ger tillgång till Admin-arean, \'stats\'-gruppen till Statistik-arean.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Skapa nya grupper för att kunna handtera olika rättigheter för skilda grupper av agenter (t.ex. inköpsavdelning, supportavdelning, försäljningsavdelning, ...).',
      'It\'s useful for ASP solutions.' => 'Nyttigt för ASP-lösningar.',

      # Template: AdminLog
      'System Log' => 'Systemlogg',
      'Time' => '',

      # Template: AdminNavigationBar
      'Users' => '',
      'Groups' => 'grupper',
      'Misc' => 'Div',

      # Template: AdminNotificationForm
      'Notification Management' => 'Meddelandehantering',
      'Notification' => '',
      'Notifications are sent to an agent or a customer.' => 'Meddelanden skickats till agenter eller kunder.',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Konfigurationsval (t.ex. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'ger tillgang till data för agenten som står som ägare till ärendet (t.ex. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'ger tillgång till data för agenten som utför handlingen (t.ex. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'ger tillgång till data för gällande kund (t.ex. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',

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
      'Overview' => 'Översikt',
      'Download' => '',
      'Rebuild' => '',
      'Reinstall' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => 'Nyckel',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'Administration av POP3-Konto',
      'Host' => '',
      'Trusted' => 'Betrodd',
      'Dispatching' => 'Fördelning',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Inkommande email från POP3-konton sorteras till vald kö!',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => '',
      'Filtername' => '',
      'Match' => 'Träff',
      'Header' => '',
      'Value' => 'Innehåll',
      'Set' => '',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => '',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Köhantering',
      'Sub-Queue of' => 'Underkö till',
      'Unlock timeout' => 'Tidsintervall för borttagning av lås',
      '0 = no unlock' => '0 = ingen upplåsning',
      'Escalation time' => 'Upptrappningstid',
      '0 = no escalation' => '0 = ingen upptrappning',
      'Follow up Option' => 'Korrespondens på låst ärende',
      'Ticket lock after a follow up' => 'Ärendet låses efter uppföljningsmail',
      'Systemaddress' => 'Systemadress',
      'Customer Move Notify' => 'Meddelande om flytt av kund',
      'Customer State Notify' => 'Meddelande om statusändring för Kund',
      'Customer Owner Notify' => 'Meddelande om byte av ägare av Kund',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ifall ett ärende som är låst av en agent men ändå inte blir besvarat inom denna tid, kommer låset automatiskt att tas bort.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Ifall ett ärende inte blir besvarat inom denna tid, visas enbart detta ärende.',
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
      'Next state' => 'Nästa tillstånd',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => 'Nuvarande ärende-status',
      'Your email address is new' => '',

      # Template: AdminRoleForm
      'Role Management' => '',
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
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Hantering av Hälsningsfraser',
      'customer realname' => 'Fullt kundnamn',
      'for agent firstname' => 'för agents förnamn',
      'for agent lastname' => 'för agents efternamn',
      'for agent user id' => 'för agents användar-id',
      'for agent login' => 'för agents login',

      # Template: AdminSelectBoxForm
      'Select Box' => 'SQL-access',
      'SQL' => '',
      'Limit' => '',
      'Select Box Result' => 'Select Box Resultat',

      # Template: AdminSession
      'Session Management' => 'Sessionshantering',
      'Sessions' => 'Sessioner',
      'Uniq' => '',
      'kill all sessions' => 'Terminera alla sessioner',
      'Session' => '',
      'kill session' => 'Terminera session',

      # Template: AdminSignatureForm
      'Signature Management' => 'Signaturhantering',

      # Template: AdminSMIMEForm
      'SMIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Hantering av systemstatus',
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
      'Content' => '',
      'New' => 'Nytt',
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
      'System Email Addresses Management' => 'Hantera System-emailadresser',
      'Email' => '',
      'Realname' => 'Fullständigt namn',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alla inkommande mail till denna adressat (To:) delas ut till vald kö.',

      # Template: AdminUserForm
      'User Management' => 'Användarhantering',
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
      'Site' => 'plats',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Stavningskontroll',
      'spelling error(s)' => 'Stavfel',
      'or' => 'eller',
      'Apply these changes' => 'Verkställ ändringar',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'Ett meddelande måste ha en mottagare i Till:-fältet!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'I Till-fältet måste anges en giltig emailadress (t.ex. kund@exempeldomain.se)!',
      'Bounce ticket' => 'Skicka över ärende',
      'Bounce to' => 'Skicka över till',
      'Next ticket state' => 'Nästa ärendestatus',
      'Inform sender' => 'Informera avsändare',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Emailen med ärendenummer "<OTRS_TICKET>" har skickats över till "<OTRS_BOUNCE_TO>". Vänligen kontakta denna adress för vidare hänvisningar.',
      'Send mail!' => 'Skicka mail!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'Ett meddelande måste ha en Ämnesrad!',
      'Ticket Bulk Action' => '',
      'Spell Check' => 'Stavningskontroll',
      'Note type' => 'Anteckningstyp',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => 'Ett meddelande måste innehålla en meddelandetext!',
      'You need to account time!' => 'Du måste redovisa tiden!',
      'Close ticket' => 'Stäng ärende',
      'Note Text' => 'Anteckingstext',
      'Close type' => 'Stängningstillstånd',
      'Time units' => 'Tidsenheter',
      ' (work units)' => ' (arbetsenheter)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'Stavningskontroll måste utföras på alla meddelanden!',
      'Compose answer for ticket' => 'Författa svar till ärende',
      'Attach' => 'Bifoga',
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
      'Clear To' => '',
      'All Agents' => 'Alla agenter',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Artikeltyp',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Ändra friatextfält i ärende',

      # Template: AgentTicketHistory
      'History of' => 'Historik för',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Ärendet låst',
      'Ticket unlock!' => 'Ärendet upplåst',

      # Template: AgentTicketMailbox
      'Mailbox' => '',
      'Tickets' => 'Ärenden',
      'All messages' => 'Alla meddelanden',
      'New messages' => 'Nya meddelanden',
      'Pending messages' => 'Väntande meddelanden',
      'Reminder messages' => 'Påminnelsemeddelanden',
      'Reminder' => 'Påminnelse',
      'Sort by' => 'Sortera efter',
      'Order' => 'Sortering',
      'up' => 'stigande',
      'down' => 'sjunkande',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',

      # Template: AgentTicketMove
      'Queue ID' => 'Kö-id',
      'Move Ticket' => 'Flytta ärende',
      'Previous Owner' => 'Tidigare ägare',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Lägg till anteckning till ärende',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Ändra ett ärendes ägare',
      'Message for new Owner' => 'Meddelande till ny ägare',

      # Template: AgentTicketPending
      'Set Pending' => 'Markera som väntande',
      'Pending type' => 'Väntande typ',
      'Pending date' => 'Väntande datum',

      # Template: AgentTicketPhone
      'Phone call' => 'Telefonsamtal',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'Nollställ Från:',

      # Template: AgentTicketPlain
      'Plain' => 'Enkel',
      'TicketID' => '',
      'ArticleID' => '',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Redovisad tid',
      'Escalation in' => 'Upptrappning om',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => 'av',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Ändra ärendeprioritet',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Ärenden som visas',
      'Page' => 'Sida',
      'Tickets available' => 'Tillgängliga ärenden',
      'All tickets' => 'Alla ärenden',
      'Queues' => 'Köer',
      'Ticket escalation!' => 'Ärende-upptrappning!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Ditt eget ärende',
      'Compose Follow up' => 'Skriv uppföljningssvar',
      'Compose Answer' => 'Skriv svar',
      'Contact customer' => 'Kontakta kund',
      'Change queue' => 'Ändra kö',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'Ärende-sök',
      'Profile' => 'Profil',
      'Search-Template' => 'Sökmall',
      'Created in Queue' => '',
      'Result Form' => 'Resultatbild',
      'Save Search-Profile as Template?' => 'Spara sökkriterier som mall?',
      'Yes, save it with name' => 'Ja, spara med namn',
      'Customer history search' => 'Kundhistorik',
      'Customer history search (e. g. "ID342425").' => 'Sök efter kundhistorik (t.ex. "ID342425").',
      'No * possible!' => 'Wildcards * inte tillåtna!',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Sökeresultat',
      'Change search options' => 'Ändra sökinställningar',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'Sortera stigande',
      'U' => '',
      'sort downward' => 'Sortera sjunkande',
      'D' => 'N',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => '',

      # Template: AgentTicketZoom
      'Split' => 'Dela',

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
      'Print' => 'Skriv ut',
      'Keywords' => 'Nyckelord',
      'Symptom' => '',
      'Problem' => '',
      'Solution' => 'Lösning',
      'Modified' => 'Ändrat',
      'Last update' => 'Senast ändrat',
      'FAQ System History' => '',
      'modified' => '',
      'FAQ Search' => 'FAQ Sök',
      'Fulltext' => 'Fritext',
      'Keyword' => 'Nyckelord',
      'FAQ Search Result' => 'FAQ Sökresultat',
      'FAQ Overview' => 'FAQ Översikt',

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
      'of' => 'av',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Klicka här för att rapportera ett fel!',

      # Template: FAQ
      'Comment (internal)' => 'Kommentar (intern)',
      'A article should have a title!' => '',
      'New FAQ Article' => '',
      'Do you really want to delete this Object?' => '',
      'System History' => '',

      # Template: FAQCategoryForm
      'Name is required!' => '',
      'FAQ Category' => 'FAQ Kategori',

      # Template: FAQLanguageForm
      'FAQ Language' => 'FAQ Språk',

      # Template: Footer
      'QueueView' => 'Köer',
      'PhoneView' => 'Tel.samtal',
      'Top of Page' => 'Början av sidan',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Hem',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Web-installation',
      'accept license' => 'godkänn licens',
      'don\'t accept license' => 'godkänn inte licens',
      'Admin-User' => 'Admin-användare',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => 'Din MySQL-databas bör ha ett root-lösenord satt!  Default är inget lösenord!',
      'Database-User' => '',
      'default \'hot\'' => '',
      'DB connect host' => '',
      'Database' => '',
      'Create' => '',
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
      'Default Charset' => 'Standard teckenuppsättning',
      'Use utf-8 it your database supports it!' => 'Använd utf-8 ifall din databas stödjer det!',
      'Default Language' => 'Standardspråk',
      '(Used default language)' => '(Valt standardspråk)',
      'CheckMXRecord' => '',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrollerar mx-uppslag för uppgivna emailadresser i meddelanden som skrivs.  Använd inte CheckMXRecord om din OTRS-maskin är bakom en uppringd lina!)',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'För att kunna använda OTRS, måste följende rad skrivas på kommandoraden som root.',
      'Restart your webserver' => 'Starta om din webserver',
      'After doing so your OTRS is up and running.' => 'Efter detta är OTRS igång.',
      'Start page' => 'Startsida',
      'Have a lot of fun!' => 'Ha det så roligt!',
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

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => 'OTRS Test-sida',
      'Counter' => '',

      # Template: Warning
      # Misc
      'OTRS DB connect host' => '',
      'Create Database' => 'Skapa databas',
      'DB Host' => 'DB host',
      'Change roles <-> groups settings' => '',
      'Ticket Number Generator' => 'Ärende-nummergenerator',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Change users <-> roles settings' => '',
      'Ticket Hook' => '',
      'Close!' => 'Stäng!',
      'Subgroup \'' => '',
      'TicketZoom' => 'Ärende Zoom',
      'Don\'t forget to add a new user to groups!' => 'Glöm inte att lägga in en ny användare i en grupp!',
      'License' => 'Licens',
      'CreateTicket' => 'Skapa Ärende',
      'OTRS DB Name' => 'OTRS DB namn',
      'System Settings' => 'Systeminställningar',
      'Hours' => '',
      'Finished' => 'Klar',
      'Days' => '',
      'DB Admin User' => 'DB Adminanvändare',
      'Article time' => '',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
      'Change user <-> group settings' => 'Ändra användar- <-> grupp-inställningar',
      'for ' => '',
      'DB Type' => 'DB typ',
      'next step' => 'nästa steg',
      'FIXME: WHAT IS PGP?' => '',
      'Admin-Email' => 'Admin-email',
      'Create new database' => 'Skapa ny databas',
      '\' ' => '',
      'Delete old database' => 'Radera gammal databas',
      'Typ' => '',
      'OTRS DB User' => 'OTRS DB användare',
      'Options ' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'OTRS DB Password' => 'OTRS DB lösenord',
      'DB Admin Password' => 'DB Adminlösenord',
      'Drop Database' => 'Radera databas',
      'Minutes' => '',
      '(Used ticket number format)' => '(Valt format för ärendenummer)',
      'FAQ History' => '',
    };
    # $$STOP$$
}
# --
1;
