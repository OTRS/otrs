# --
# Kernel/Language/cz.pm - provides cz language translation
# Copyright (C) 2003 Lukas Vicanek alias networ <lulka at centrum dot cz>
# Copyright (C) 2004 BENETA.cz, s.r.o. <info at beneta dot cz>
# Translators: Marta Macalkova
#              Vadim Buzek
#              Petr Ocasek
# --
# $Id: cz.pm,v 1.47.2.1 2007-12-10 08:44:44 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Language::cz;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.47.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Tue May 29 15:08:03 2007

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M/%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %Y %T';
    $Self->{DateFormatShort} = '%D/%M/%Y';
    $Self->{DateInputFormat} = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

    $Self->{Translation} = {
        # Template: AAABase
        'Yes' => 'Ano',
        'No' => 'Ne',
        'yes' => 'ano',
        'no' => 'ne',
        'Off' => 'Vypnuto',
        'off' => 'vypnuto',
        'On' => 'Zapnuto',
        'on' => 'zapnuto',
        'top' => 'nahoru',
        'end' => 'konec',
        'Done' => 'Hotovo',
        'Cancel' => 'Stornovat',
        'Reset' => '',
        'last' => 'poslední',
        'before' => 'pøed',
        'day' => 'den',
        'days' => 'dní(dny)',
        'day(s)' => 'den(dní)',
        'hour' => 'hodina',
        'hours' => 'hodin',
        'hour(s)' => '',
        'minute' => 'minuta',
        'minutes' => 'minut',
        'minute(s)' => '',
        'month' => '',
        'months' => '',
        'month(s)' => 'mìsíc(e)',
        'week' => '',
        'week(s)' => 'týden(týdny)',
        'year' => '',
        'years' => '',
        'year(s)' => 'rok(y)',
        'second(s)' => '',
        'seconds' => '',
        'second' => '',
        'wrote' => 'napsal',
        'Message' => 'Zpráva',
        'Error' => 'Chyba',
        'Bug Report' => 'Upozornìní na chybu',
        'Attention' => 'Upozornìní',
        'Warning' => 'Varování',
        'Module' => 'Modul',
        'Modulefile' => 'Modulový soubor',
        'Subfunction' => 'Podfunkce',
        'Line' => 'Linka',
        'Example' => 'Pøíklad',
        'Examples' => 'Pøíklady',
        'valid' => 'platný',
        'invalid' => 'neplatný',
        '* invalid' => '',
        'invalid-temporarily' => '',
        ' 2 minutes' => ' 2 minuty',
        ' 5 minutes' => ' 5 minut',
        ' 7 minutes' => ' 7 minut',
        '10 minutes' => '10 minut',
        '15 minutes' => '15 minut',
        'Mr.' => '',
        'Mrs.' => '',
        'Next' => '',
        'Back' => 'Zpìt',
        'Next...' => '',
        '...Back' => '',
        '-none-' => '',
        'none' => '¾ádné',
        'none!' => '¾ádný!',
        'none - answered' => '¾ádný - odpovìzeno',
        'please do not edit!' => 'prosíme neupravujte!',
        'AddLink' => 'Pøidat Odkaz',
        'Link' => 'Odkaz',
        'Linked' => '',
        'Link (Normal)' => '',
        'Link (Parent)' => '',
        'Link (Child)' => '',
        'Normal' => 'Normální',
        'Parent' => '',
        'Child' => '',
        'Hit' => 'Pøístup',
        'Hits' => 'Prístupù',
        'Text' => '',
        'Lite' => 'Omezená',
        'User' => 'U¾ivatel',
        'Username' => 'Jméno u¾ivatele',
        'Language' => 'Jazyk',
        'Languages' => 'Jazyky',
        'Password' => 'Heslo',
        'Salutation' => 'Oslovení',
        'Signature' => 'Podpis',
        'Customer' => 'Klient',
        'CustomerID' => 'ID klienta',
        'CustomerIDs' => '',
        'customer' => 'klient',
        'agent' => '',
        'system' => 'systém',
        'Customer Info' => 'Informace o klientovi',
        'Customer Company' => '',
        'Company' => '',
        'go!' => 'jdi!',
        'go' => 'jdi',
        'All' => 'V¹e',
        'all' => 'v¹e',
        'Sorry' => 'Omluva',
        'update!' => 'aktualizovat!',
        'update' => 'aktualizovat',
        'Update' => 'Aktualizovat',
        'submit!' => 'Odeslat!',
        'submit' => 'odeslat',
        'Submit' => '',
        'change!' => 'zmìnit!',
        'Change' => 'Zmìnit',
        'change' => 'zmìnit',
        'click here' => 'kliknìte zde',
        'Comment' => 'Komentáø',
        'Valid' => 'Platnost',
        'Invalid Option!' => '',
        'Invalid time!' => '',
        'Invalid date!' => '',
        'Name' => 'Jméno',
        'Group' => 'Skupina',
        'Description' => 'Popis',
        'description' => 'popis',
        'Theme' => 'Design',
        'Created' => 'Vytvoøeno',
        'Created by' => '',
        'Changed' => '',
        'Changed by' => '',
        'Search' => 'Vyhledat',
        'and' => 'a',
        'between' => '',
        'Fulltext Search' => '',
        'Data' => '',
        'Options' => 'Mo¾nosti',
        'Title' => '',
        'Item' => '',
        'Delete' => 'Smazat',
        'Edit' => 'Editovat',
        'View' => 'Náhled',
        'Number' => '',
        'System' => 'Systém',
        'Contact' => 'Konktakt',
        'Contacts' => '',
        'Export' => '',
        'Up' => '',
        'Down' => '',
        'Add' => 'Pøidat',
        'Category' => 'Kategorie',
        'Viewer' => '',
        'New message' => 'Nová zpráva',
        'New message!' => 'Nová zpráva!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosím, odpovìzte na tento (tyto) tiket(y) pro návrat do normálního náhledu fronty!',
        'You got new message!' => 'Máte novou zprávu!',
        'You have %s new message(s)!' => 'Máte %s novou zprávu (nových zpráv)!',
        'You have %s reminder ticket(s)!' => 'Máte %s upomínkový(ch) ticket(ù)',
        'The recommended charset for your language is %s!' => 'Doporuèená znaková sada pro Vá¹ jazyk je %s!',
        'Passwords doesn\'t match! Please try it again!' => '',
        'Password is already in use! Please use an other password!' => '',
        'Password is already used! Please use an other password!' => '',
        'You need to activate %s first to use it!' => '',
        'No suggestions' => '¾ádné návrhy',
        'Word' => 'Slovo',
        'Ignore' => 'Ignorovat',
        'replace with' => 'nahradit',
        'There is no account with that login name.' => '®ádný úèet s tímto pøihla¹ovacím jménem neexistuje.',
        'Login failed! Your username or password was entered incorrectly.' => 'Pøihlá¹ení neúspì¹né! Va¹e u¾ivatelské jméno èi heslo bylo zadáno nesprávnì.',
        'Please contact your admin' => 'Kontaktujte, prosím, Va¹eho administrátora',
        'Logout successful. Thank you for using OTRS!' => 'Odhlá¹ení bylo úspìsné. Dìkujeme Vám za pou¾ívání OTRS!',
        'Invalid SessionID!' => 'Neplatné ID relace!',
        'Feature not active!' => 'Funkce je neaktivní!',
        'Login is needed!' => '',
        'Password is needed!' => '',
        'License' => 'Licence',
        'Take this Customer' => '',
        'Take this User' => 'Pou¾íj tohoto u¾ivatele',
        'possible' => 'mo¾ný',
        'reject' => 'zamítnout',
        'reverse' => '',
        'Facility' => 'Funkce',
        'Timeover' => 'Èas vypr¹el',
        'Pending till' => 'Èekání na vyøízení do',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Z bezpeènostních dùvodù nepracujte se superu¾ivatelským úètem - vytvoøte si nového u¾ivatele!',
        'Dispatching by email To: field.' => 'Pøiøadit podle e-mailu - pole KOMU:.',
        'Dispatching by selected Queue.' => 'Pøiøadit do vybrané fronty.',
        'No entry found!' => 'Nebyl nalezen ¾ádný záznam!',
        'Session has timed out. Please log in again.' => 'Relace vypr¹ela. Prosím, pøihla¹te se znovu.',
        'No Permission!' => '',
        'To: (%s) replaced with database email!' => 'To: (%s) nahrazeno emailem z databáze!',
        'Cc: (%s) added database email!' => '',
        '(Click here to add)' => '(Pro pøidání kliknìte zde)',
        'Preview' => 'Zobrazit',
        'Package not correctly deployed! You should reinstall the Package again!' => '',
        'Added User "%s"' => '',
        'Contract' => '',
        'Online Customer: %s' => '',
        'Online Agent: %s' => '',
        'Calendar' => '',
        'File' => '',
        'Filename' => 'Název souboru',
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
        'Country' => '',
        'installed' => '',
        'uninstalled' => '',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => '',

        # Template: AAAMonth
        'Jan' => 'Led',
        'Feb' => 'Úno',
        'Mar' => 'Bøe',
        'Apr' => 'Dub',
        'May' => 'Kvì',
        'Jun' => 'Èvc',
        'Jul' => 'Èer',
        'Aug' => 'Srp',
        'Sep' => 'Záø',
        'Oct' => 'Øíj',
        'Nov' => 'Lis',
        'Dec' => 'Pro',
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
        'Admin-Area' => 'Administraèní zóna',
        'Agent-Area' => 'Zóna agentù',
        'Ticket-Area' => '',
        'Logout' => 'Odhlásit',
        'Agent Preferences' => '',
        'Preferences' => 'Nastavení',
        'Agent Mailbox' => '',
        'Stats' => 'Statistiky',
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
        'Preferences updated successfully!' => 'Nastavení úspì¹nì aktualizováno!',
        'Mail Management' => 'Správa e-mailù',
        'Frontend' => 'Rozhraní',
        'Other Options' => 'Jiné mo¾nosti',
        'Change Password' => '',
        'New password' => '',
        'New password again' => '',
        'Select your QueueView refresh time.' => 'Vyberte si dobu obnovení náhledu fronty.',
        'Select your frontend language.' => 'Vyberte si jazyk Va¹eho rozhraní.',
        'Select your frontend Charset.' => 'Vyberte si znakovou sadu Va¹eho rozhraní.',
        'Select your frontend Theme.' => 'Vyberte si design Va¹eho rozhraní.',
        'Select your frontend QueueView.' => 'Vyberte si náhled fronty Va¹eho rozhraní.',
        'Spelling Dictionary' => 'Slovník kontroly pravopisu',
        'Select your default spelling dictionary.' => 'Vyberte si Vá¹ výchozí pravopisný slovník',
        'Max. shown Tickets a page in Overview.' => 'Max. zobrazených tiketù v pøehledu na stránku',
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
        'Lock' => 'Zámek',
        'Unlock' => 'Zámek',
        'History' => 'Historie',
        'Zoom' => 'Zobrazit',
        'Age' => 'Stáøí',
        'Bounce' => 'Odeslat zpìt',
        'Forward' => 'Pøedat',
        'From' => 'Od',
        'To' => 'Komu',
        'Cc' => 'Kopie',
        'Bcc' => 'Slepá kopie',
        'Subject' => 'Pøedmìt',
        'Move' => 'Pøesunout',
        'Queue' => 'Fronta',
        'Priority' => 'Priorita',
        'State' => 'Stav',
        'Compose' => 'Sestavit',
        'Pending' => 'Èeká na vyøízení',
        'Owner' => 'Vlastník',
        'Owner Update' => '',
        'Responsible' => '',
        'Responsible Update' => '',
        'Sender' => 'Odesílatel',
        'Article' => 'Polo¾ka',
        'Ticket' => 'Tiket',
        'Createtime' => 'Doba vytvoøení',
        'plain' => 'jednoduchý',
        'Email' => '',
        'email' => '',
        'Close' => 'Zavøít',
        'Action' => 'Akce',
        'Attachment' => 'Pøíloha',
        'Attachments' => 'Pøílohy',
        'This message was written in a character set other than your own.' => 'Tato zpráva byla napsána v jiné znakové sadì ne¾ Va¹e.',
        'If it is not displayed correctly,' => 'Pokud není zobrazeno správnì,',
        'This is a' => 'Toto je',
        'to open it in a new window.' => 'pro otevøení v novém oknì.',
        'This is a HTML email. Click here to show it.' => 'Toto je HTML email. Pro zobrazení kliknìte zde.',
        'Free Fields' => '',
        'Merge' => '',
        'merged' => '',
        'closed successful' => 'uzavøeno - vyøe¹eno',
        'closed unsuccessful' => 'uzavøeno - nevyøe¹eno',
        'new' => 'nová',
        'open' => 'otevøít',
        'closed' => 'uzavøeno',
        'removed' => 'odstranìn',
        'pending reminder' => 'upomínka pøi èekání na vyøízení',
        'pending auto' => '',
        'pending auto close+' => 'èeká na vyøízení - automaticky zavøít+',
        'pending auto close-' => 'èeká na vyøízení - automaticky zavøít-',
        'email-external' => 'externí email',
        'email-internal' => 'interní email',
        'note-external' => 'poznámka-externí',
        'note-internal' => 'poznámka-interní',
        'note-report' => 'poznámka-report',
        'phone' => 'telefon',
        'sms' => '',
        'webrequest' => 'po¾adavek pøes web',
        'lock' => 'zamèeno',
        'unlock' => 'nezamèený',
        'very low' => 'velmi nízká',
        'low' => 'nízký',
        'normal' => 'normalní',
        'high' => 'vysoký',
        'very high' => 'velmi vysoká',
        '1 very low' => '1 velmi nízká',
        '2 low' => '2 nízká',
        '3 normal' => '3 normální',
        '4 high' => '4 vysoká',
        '5 very high' => '5 velmi vysoká',
        'Ticket "%s" created!' => 'Tiket "%s" vytvoøen!',
        'Ticket Number' => '',
        'Ticket Object' => '',
        'No such Ticket Number "%s"! Can\'t link it!' => '',
        'Don\'t show closed Tickets' => 'Nezobrazovat uzavøené tikety',
        'Show closed Tickets' => 'Zobrazit zavøené tikety',
        'New Article' => 'Nová polo¾ka',
        'Email-Ticket' => '',
        'Create new Email Ticket' => '',
        'Phone-Ticket' => '',
        'Search Tickets' => '',
        'Edit Customer Users' => '',
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
        'New ticket notification' => 'Nové oznámení tiketu',
        'Send me a notification if there is a new ticket in "My Queues".' => '',
        'Follow up notification' => 'Následující oznámení',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Po¹li mi oznámení, pokud klient po¹le následující a jsem vlastník tohoto tiketu.',
        'Ticket lock timeout notification' => 'Oznámení o vypr¹ení èasu uzamèení tiketu',
        'Send me a notification if a ticket is unlocked by the system.' => 'Po¹li mi oznámení, pokud je tiket odemknut systémem.',
        'Move notification' => 'Pøesunout oznámení',
        'Send me a notification if a ticket is moved into one of "My Queues".' => '',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => '',
        'Custom Queue' => 'Vlastní fronta',
        'QueueView refresh time' => 'Doba obnovení náhledu fronty',
        'Screen after new ticket' => '',
        'Select your screen after creating a new ticket.' => '',
        'Closed Tickets' => 'Uzavøené Tikety',
        'Show closed tickets.' => 'Ukázat uzavøené tikety.',
        'Max. shown Tickets a page in QueueView.' => 'Max. zobrazených tiketù v náhledu fronty na stránku',
        'CompanyTickets' => '',
        'MyTickets' => '',
        'New Ticket' => '',
        'Create new Ticket' => '',
        'Customer called' => '',
        'phone call' => '',
        'Responses' => 'Odpovìdi',
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

        # Template: AAAWeekDay
        'Sun' => 'Ne',
        'Mon' => 'Po',
        'Tue' => 'Út',
        'Wed' => 'St',
        'Thu' => 'Èt',
        'Fri' => 'Pá',
        'Sat' => 'So',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Správa pøíloh',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Správa automatických odpovìdí',
        'Response' => 'Odpovìï',
        'Auto Response From' => 'Automatická odpovìï Od',
        'Note' => 'Poznámka',
        'Useable options' => 'Dostupné mo¾nosti',
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
        'Add Customer Company' => '',
        'Add a new Customer Company.' => '',
        'List' => '',
        'This values are required.' => '',
        'This values are read only.' => '',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Správa Klientù',
        'Search for' => '',
        'Add Customer User' => '',
        'Source' => '',
        'Create' => '',
        'Customer user will be needed to have a customer history and to login via customer panel.' => '',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => '',
        'Change %s settings' => 'Zmìnit nastavení %s',
        'Select the user:group permissions.' => 'Vybrat u¾ivatele:práva skupiny',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Pokud nebylo nic vybráno, nejsou v této skupinì ¾ádná práva (tikety nebudou pro u¾ivatele dostupné).',
        'Permission' => 'Práva',
        'ro' => 'jen ètení',
        'Read only access to the ticket in this group/queue.' => 'Pøístup pouze pro ètení tiketu v této skupinì/øadì.',
        'rw' => 'ètení/psaní',
        'Full read and write access to the tickets in this group/queue.' => 'Plný pøístup pro ètení a psaní do tiketù v této skupinì/frontì.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserServiceChangeForm
        'Customer Users <-> Services Management' => '',
        'Select the customeruser:service relations.' => '',
        'Allocate services to CustomerUser' => '',
        'Allocate CustomerUser to service' => '',

        # Template: AdminCustomerUserServiceForm
        'Edit default services.' => '',

        # Template: AdminEmail
        'Message sent to' => 'Zpráva odeslána',
        'Recipents' => 'Adresáti',
        'Body' => 'Tìlo',
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
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fulltextové vyhledávání v polo¾ce (napø. "Mar*in" or "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(napø. 10*5155 or 105658*)',
        '(e. g. 234321)' => '(napø. 234321)',
        'Customer User Login' => 'Pøihlá¹ení klienta',
        '(e. g. U5150)' => '(napø. U5150)',
        'Agent' => '',
        'Ticket Lock' => '',
        'TicketFreeFields' => '',
        'Create Times' => '',
        'No create time settings.' => '',
        'Ticket created' => 'Tiket vytvoøen',
        'Ticket created between' => 'Tiket vytvoøen mezi',
        'Pending Times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'New Priority' => '',
        'New Queue' => 'Nová fronta',
        'New State' => '',
        'New Agent' => '',
        'New Owner' => 'Nový vlastník',
        'New Customer' => '',
        'New Ticket Lock' => '',
        'CustomerUser' => 'Klient',
        'New TicketFreeFields' => '',
        'Add Note' => 'Pøidat poznámku',
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
        'Group Management' => 'Správa skupiny',
        'Add Group' => '',
        'Add a new Group.' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Skupina administrátora má pøístup do administraèní a statistické zóny.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Vytvoøit nové skupiny pro pøiøazení práv pøístupù ruzným skupinám agentù (napø. oddìlení nákupu, oddìlení podpory, oddìlení prodeje...).',
        'It\'s useful for ASP solutions.' => 'To je vhodné pro øe¹ení ASP',

        # Template: AdminLog
        'System Log' => 'Log systému',
        'Time' => '',

        # Template: AdminNavigationBar
        'Users' => '',
        'Groups' => 'Skupiny',
        'Misc' => 'Rùzné',

        # Template: AdminNotificationForm
        'Notification Management' => 'Správa oznámení',
        'Notification' => '',
        'Notifications are sent to an agent or a customer.' => 'Oznámení jsou odeslána agentovi èi klientovi',

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
        'Status' => 'Stav',
        'Overview' => 'Pøehled',
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

        # Template: AdminPGPForm
        'PGP Management' => '',
        'Result' => '',
        'Identifier' => '',
        'Bit' => '',
        'Key' => 'Klíè',
        'Fingerprint' => '',
        'Expires' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' => '',

        # Template: AdminPOP3
        'POP3 Account Management' => 'Správa POP3 úètù',
        'Host' => 'Hostitel',
        'Trusted' => 'Ovìøeno',
        'Dispatching' => 'Zaøazení',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'V¹echny pøíchozí emaily z daného úètu budou zaøazeny do vybrané fronty!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => '',
        'Filtername' => '',
        'Match' => 'Obsahuje',
        'Header' => '',
        'Value' => 'Hodnota',
        'Set' => 'Nastavit',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => '',

        # Template: AdminQueueForm
        'Queue Management' => 'Správa front',
        'Sub-Queue of' => 'Podfronta ',
        'Unlock timeout' => 'Èas do odemknutí',
        '0 = no unlock' => '0 = ¾ádné odemknutí',
        'Escalation - First Response Time' => '',
        '0 = no escalation' => '0 = ¾ádné stupòování',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Follow up Option' => 'Následující volba',
        'Ticket lock after a follow up' => 'Zamknout tiket po následujícím',
        'Systemaddress' => 'Systémová adresa',
        'Customer Move Notify' => 'Oznámení Klientovi o zmìnì fronty',
        'Customer State Notify' => 'Oznámení Klientovi o zmìnì stavu',
        'Customer Owner Notify' => 'Oznámení Klientovi o zmìnì vlastníka',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Pokud agent uzamkne tiket a neode¹le v této dobì odpovìï, tiket bude automaticky odemknut. Tak se stane tiket viditelný pro v¹echny ostatní agenty.',
        'Escalation time' => 'Doba stupòování',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => '',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Pokud je tiket uzavøen a klient ode¹le následující, tiket bude pro starého vlastníka uzamknut.',
        'Will be the sender address of this queue for email answers.' => 'Bude adresou odesílatele z této fronty pro emailové odpovìdi.',
        'The salutation for email answers.' => 'Oslovení pro emailové odpovìdi.',
        'The signature for email answers.' => 'Podpis pro emailové odpovìdi.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS po¹le klientovi emailem oznámení, pokud bude tiket pøesunut.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS po¹le klientovi emailem oznámení, pokud se zmìní stav tiketu.',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS po¹le klientovi emailem oznámení, pokud se zmìní vlastník tiketu.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => '',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Odpovìï',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => '',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Správa odpovìdí',
        'A response is default text to write faster answer (with default text) to customers.' => 'Odpovìï je obsahuje výchozí text slou¾ící k rychlej¹í reakci (spolu s výchozím textem) klientùm.',
        'Don\'t forget to add a new response a queue!' => 'Nezapomeòte pøidat novou reakci odpoveï do fronty!',
        'The current ticket state is' => 'Aktuální stav tiketu je',
        'Your email address is new' => '',

        # Template: AdminRoleForm
        'Role Management' => '',
        'Add Role' => '',
        'Add a new Role.' => '',
        'Create a role and put groups in it. Then add the role to the users.' => '',
        'It\'s useful for a lot of users and groups.' => '',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => '',
        'move_into' => 'pøesunout do',
        'Permissions to move tickets into this group/queue.' => 'Práva pøesunout tikety do této skupiny/fronty',
        'create' => 'vytvoøit',
        'Permissions to create tickets in this group/queue.' => 'Práva vytvoøit tikety v této skupinì/frontì',
        'owner' => 'vlastník',
        'Permissions to change the ticket owner in this group/queue.' => 'Práva zmìnit vlastník tiketu v této skupinì/frontì',
        'priority' => 'priorita',
        'Permissions to change the ticket priority in this group/queue.' => 'Práva zmìnit prioritu tiketu v této skupinì/frontì',

        # Template: AdminRoleGroupForm
        'Role' => '',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => '',
        'Active' => '',
        'Select the role:user relations.' => '',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Správa oslovení',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'Select Box' => 'Po¾adavek na SQL databázi',
        'Limit' => '',
        'Go' => '',
        'Select Box Result' => 'Výsledek SQL dotazu',

        # Template: AdminService
        'Service Management' => '',
        'Add Service' => '',
        'Add a new Service.' => '',
        'Service' => '',
        'Sub-Service of' => '',

        # Template: AdminSession
        'Session Management' => 'Správa relace',
        'Sessions' => 'Relace',
        'Uniq' => 'Poèet',
        'Kill all sessions' => '',
        'Session' => '',
        'Content' => '',
        'kill session' => 'zru¹it relaci',

        # Template: AdminSignatureForm
        'Signature Management' => 'Správa podpisù',
        'Add Signature' => '',
        'Add a new Signature.' => '',

        # Template: AdminSLA
        'SLA Management' => '',
        'Add SLA' => '',
        'Add a new SLA.' => '',
        'SLA' => '',
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',

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
        'State Type' => 'Typ stavu',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Ujistìte se, ¾e jste aktualizovali také výchozí hodnoty ve Va¹em Kernel/Config.pm!',
        'See also' => 'Viz. také',

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
        'New' => 'Nové',
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
        'System Email Addresses Management' => 'Správa emailových adres systému',
        'Add System Address' => '',
        'Add a new System Address.' => '',
        'Realname' => 'Skuteèné jméno',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'V¹echny pøíchozí emaily obsahující tohoto adresáta (v poli KOMU) budou zaøazeny to vybrané fronty!',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'Správa u¾ivatelù',
        'Add User' => '',
        'Add a new Agent.' => '',
        'Login as' => '',
        'Firstname' => 'Køestní jméno',
        'Lastname' => 'Pøíjmení',
        'User will be needed to handle tickets.' => 'U¾ivatel bude potøebovat práva pro ovládání tiketù.',
        'Don\'t forget to add a new user to groups and/or roles!' => '',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => '',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adresáø',
        'Return to the compose screen' => 'Vrátit se zpìt do okna vytváøení',
        'Discard all changes and return to the compose screen' => 'Zru¹it v¹echny zmìny a vrátit se zpìt do okna vytváøení',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => '',

        # Template: AgentLinkObject
        'Link Object' => '',
        'Select' => 'Vybrat',
        'Results' => 'Výsledky',
        'Total hits' => 'Celkový poèet záznamù',
        'Page' => 'Strana',
        'Detail' => '',

        # Template: AgentLookup
        'Lookup' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Funkce na kontrolu pravopisu',
        'spelling error(s)' => 'chyba(y) v pravopisu',
        'or' => 'nebo',
        'Apply these changes' => 'Aplikovat tyto zmìny',

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
        'Print' => 'Tisknout',
        'No Element selected.' => '',

        # Template: AgentStatsView
        'Export Config' => '',
        'Informations about the Stat' => '',
        'Exchange Axis' => '',
        'Configurable params of static stat' => '',
        'No element selected.' => '',
        'maximal period from' => '',
        'to' => '',
        'Start' => '',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Odeslat tiket zpìt',
        'Ticket locked!' => 'Tiket zamknut!',
        'Ticket unlock!' => 'Tiket odemknut!',
        'Bounce to' => 'Odeslat zpìt',
        'Next ticket state' => 'Následující stav tiketu',
        'Inform sender' => 'Informovat odesílatele',
        'Send mail!' => 'Poslat mail!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => '',
        'Spell Check' => 'Kontrola pravopisu',
        'Note type' => 'Typ poznámky',
        'Unlock Tickets' => '',

        # Template: AgentTicketClose
        'Close ticket' => 'Zavøít tiket',
        'Previous Owner' => 'Pøedchozí vlastník',
        'Inform Agent' => '',
        'Optional' => '',
        'Inform involved Agents' => '',
        'Attach' => 'Pøipojit',
        'Next state' => 'Nasledující stav',
        'Pending date' => 'Datum èekání na vyøízení',
        'Time units' => 'Jednotky èasu',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Sestavit odpovìï pro tiket',
        'Pending Date' => 'Doba èekání na vyøízení',
        'for pending* states' => 'pro stavy èekání na vyøízení*',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Zmìnit klienta tiketu',
        'Set customer user and customer id of a ticket' => 'Nastavit klienta a nastavit ID klienta tiketu',
        'Customer User' => 'Klient - U¾ivatelé',
        'Search Customer' => 'Vyhledat klienta',
        'Customer Data' => 'Data klienta',
        'Customer history' => 'Historie klienta',
        'All customer tickets.' => 'V¹echny tikety klienta',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Následující',

        # Template: AgentTicketEmail
        'Compose Email' => '',
        'new ticket' => 'nový tiket',
        'Refresh' => '',
        'Clear To' => '',

        # Template: AgentTicketForward
        'Article type' => 'Typ polo¾ky',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Zmìnit úplný text tiketu',

        # Template: AgentTicketHistory
        'History of' => 'Historie',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Mailbox' => 'Po¹tovní schránka',
        'Tickets' => 'Tikety',
        'of' => 'z',
        'Filter' => '',
        'New messages' => 'Nové zprávy',
        'Reminder' => 'Upomínka',
        'Sort by' => 'Setøídit dle',
        'Order' => 'Seøadit',
        'up' => 'nahoru',
        'down' => 'dolù',

        # Template: AgentTicketMerge
        'Ticket Merge' => '',
        'Merge to' => '',

        # Template: AgentTicketMove
        'Move Ticket' => 'Pøesunout tiket',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Pøidat poznámku k tiketu',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Zmìnit vlastníka tiketu',

        # Template: AgentTicketPending
        'Set Pending' => 'Nastavit - èeká na vyøízení',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefoní hovor',
        'Clear From' => 'Vymazat pole Od',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Jednoduché',

        # Template: AgentTicketPrint
        'Ticket-Info' => '',
        'Accounted time' => 'Úètovaná doba',
        'Escalation in' => 'Stupòování v',
        'Linked-Object' => '',
        'Parent-Object' => '',
        'Child-Object' => '',
        'by' => 'pøes',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Zmìnit dùle¾itost tiketu',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Zobrazené tikety',
        'Tickets available' => 'Tiketù k dispozici',
        'All tickets' => 'V¹echny tikety',
        'Queues' => 'Øady',
        'Ticket escalation!' => 'Eskalace tiketù',

        # Template: AgentTicketQueueTicketView
        'Service Time' => '',
        'Your own Ticket' => 'Vá¹ vlastní tiket',
        'Compose Follow up' => 'Sestavit následující',
        'Compose Answer' => 'Odpovìdìt',
        'Contact customer' => 'Kontaktovat klienta',
        'Change queue' => 'Zmìnit frontu',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => '',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Hledání tiketu',
        'Profile' => 'Profil',
        'Search-Template' => 'Forma vyhledávání',
        'TicketFreeText' => 'Volný text tiketu',
        'Created in Queue' => '',
        'Result Form' => 'Forma výsledku',
        'Save Search-Profile as Template?' => 'Ulo¾it profil vyhledávání jako ¹ablonu?',
        'Yes, save it with name' => 'Ano, ulo¾it pod názvem',

        # Template: AgentTicketSearchResult
        'Search Result' => 'Výsledky vyhledávání',
        'Change search options' => 'Zmìnit mo¾nosti vyhledávání',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort
        'U' => 'Z-A',
        'D' => 'A-Z',

        # Template: AgentTicketStatusView
        'Ticket Status View' => '',
        'Open Tickets' => '',
        'Locked' => '',

        # Template: AgentTicketZoom

        # Template: AgentWindowTab

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Jít zpìt',

        # Template: CustomerFooter
        'Powered by' => 'Vytvoøeno',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => '',
        'Lost your password?' => 'Ztratil/a jste heslo?',
        'Request new password' => 'Po¾ádat o nové heslo',
        'Create Account' => 'Vytvoøit úèet',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Vítejte %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Doba',
        'No time settings.' => '®ádná nastavení doby',

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Kliknìte zde pro nahlá¹ení chyby!',

        # Template: Footer
        'Top of Page' => 'Hlava stránky',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-instalátor',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Administrátor',
        'Admin-Password' => '',
        'your MySQL DB should have a root password! Default is empty!' => 'Va¹e MySQL databáze by mìla mít root heslo! Výchozí je prázdné!',
        'Database-User' => '',
        'default \'hot\'' => 'výchozí \'hot\'',
        'DB connect host' => '',
        'Database' => '',
        'false' => '',
        'SystemID' => 'Systémové ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Identita systému. Ka¾dé èíslo tiketu a ID ka¾dá HTTP relace zaèíná tímto èíslem)',
        'System FQDN' => 'Systém FQDN',
        '(Full qualified domain name of your system)' => '(Platný název domény pro vá¹ systém (FQDN))',
        'AdminEmail' => 'Email Administrátora',
        '(Email of the system admin)' => '(Email administrátora systému)',
        'Organization' => 'Organizace',
        'Log' => '',
        'LogModule' => 'Log Modul',
        '(Used log backend)' => '(Pou¾it výstup do logu)',
        'Logfile' => 'Log soubor',
        '(Logfile just needed for File-LogModule!)' => '(Pro logování do souboru je nutné zadat název souboru logu!)',
        'Webfrontend' => 'Webove rozhraní',
        'Default Charset' => 'Výchozí znaková sada',
        'Use utf-8 it your database supports it!' => 'Pou¾ijte utf-8 pokud to Va¹e databáze podporuje',
        'Default Language' => 'Výchozí jazyk',
        '(Used default language)' => '(Pou¾itý výchozí jazyk)',
        'CheckMXRecord' => 'Kontrolovat MX záznam',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontroluj MX záznamy pou¾itých emailových adres pøi sestavování odpovìdi. Nepou¾ívejte pokud OTRS server pøipojen pomocí vytáèené linky!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Abyste mohli pou¾ívat OTRS, musíte zadat následující øádek do Va¹eho pøíkazového øádku (Terminal/Shell) jako root.',
        'Restart your webserver' => 'Restartujte Vá¹ webserver',
        'After doing so your OTRS is up and running.' => 'Po dokonèení následujících operací je Vá¹ OTRS spu¹tìn a pobì¾í',
        'Start page' => 'Úvodní stránka',
        'Have a lot of fun!' => 'Pøejeme hodnì úspìchù s OTRS!',
        'Your OTRS Team' => 'Vá¹ OTRS tým',

        # Template: Login
        'Welcome to %s' => 'Vítejte v %s',

        # Template: Motd

        # Template: NoPermission
        'No Permission' => '®ádná práva',

        # Template: Notify
        'Important' => '',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'tisknuto',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Testovací OTRS stránka',
        'Counter' => '',

        # Template: Warning
        # Misc
        'Create Database' => 'Vytvoøit Databazi',
        'DB Host' => 'Hostitel (server) databáze',
        'Change roles <-> groups settings' => '',
        'Ticket Number Generator' => 'Generátor èísel tiketù',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identifikátor tiketù. Nekteøí lidé chtìjí nastavit napø. \'Tiket#\',  \'Hovor#\' nebo \'MujTiket#\')',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
        'Create new Phone Ticket' => '',
        'Symptom' => 'Pøíznak',
        'A message should have a To: recipient!' => 'Zpráva by mìla obsahovat Komu: pøíjemce!',
        'Site' => 'Umístìní',
        'Customer history search (e. g. "ID342425").' => 'Vyhledávání historie klienta (napø. "ID342425")',
        'Close!' => 'Zavøít!',
        'for agent firstname' => 'pro køestní jméno agenta',
        'The message being composed has been closed.  Exiting.' => 'Vytváøená zpráva byla uzavøena. Opou¹tím.',
        'A web calendar' => '',
        'to get the realname of the sender (if given)' => 'pro získaní skuteèného jména odesílatele (pokud je zadáno)',
        'OTRS DB Name' => 'Název OTRS databáze',
        'Notification (Customer)' => '',
        'Select Source (for add)' => '',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Queue ID' => 'ID fronty',
        'Home' => 'Domù',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => '',
        'System History' => '',
        'customer realname' => 'skuteèné jméno klienta',
        'Pending messages' => 'Zprávy èekající na vyøízení',
        'Port' => '',
        'Modules' => '',
        'for agent login' => 'pro pøihlá¹ení agenta',
        'Keyword' => 'Klíèové slovo',
        'Close type' => 'Zavøít typ',
        'DB Admin User' => 'Administrátor databáze',
        'for agent user id' => 'pro u¾ivatelské ID agenta',
        'sort upward' => 'setøídit nahoru',
        'Change user <-> group settings' => 'Zmìnit u¾ivatele <-> nastavení skupiny',
        'Problem' => 'Problém',
        'next step' => 'dal¹í krok',
        'Customer history search' => 'Vyhledávání historie klienta',
        'Admin-Email' => 'Email administrátora',
        'Stat#' => '',
        'A message must be spell checked!' => 'Zpráva musí být pravopisnì zkontrolovaná!',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Vá¹ email s èíslem ticketu "<OTRS_TICKET>" je odeslán zpìt na "<OTRS_BOUNCE_TO>". Kontaktujte tuto adresu pro dal¹í infromace.',
        'Mail Account Management' => '',
        'ArticleID' => 'ID polo¾ky',
        'A message should have a body!' => 'Zpráva by mìla mít tìlo!',
        'All Agents' => 'V¹ichni agenti',
        'Keywords' => 'Klíèová slova',
        'No * possible!' => '®ádná * mo¾ná!',
        'Options ' => '',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Message for new Owner' => 'Zpráva pro nového vlastníka',
        'to get the first 5 lines of the email' => 'pro získání prvních 5 øádkù z emailu',
        'OTRS DB Password' => 'Heslo OTRS databáze',
        'Last update' => 'Poslední aktualizace',
        'to get the first 20 character of the subject' => 'pro získáni prvních 20 znakù z pøedmìtu',
        'DB Admin Password' => 'Heslo administrátora databáze',
        'Drop Database' => 'Odstranit databazi',
        'Advisory' => '',
        'FileManager' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => '',
        'Pending type' => 'Typ èekání na vyøízení',
        'Comment (internal)' => 'Komentáø (interní)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'This window must be called from compose window' => 'Toto okno musí být vyvoláno z okna vytváøení',
        'You need min. one selected Ticket!' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        '(Used ticket number format)' => '(Pou¾itý formát èísel tiketù)',
        'Fulltext' => '',
        'OTRS DB connect host' => 'Hostitel OTRS databáze (server)',
        'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Nebude-li tiket odpovìzen v daném èase, bude zobrazen pouze tento Tiket.',
        'All Agent variables.' => '',
        ' (work units)' => '(jednotky práce)',
        'All Customer variables like defined in config option CustomerUser.' => '',
        'accept license' => 'souhlasím s licencí',
        'for agent lastname' => 'pro pøíjmení agenta',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => '',
        'Reminder messages' => 'Upomínkové zprávy',
        'A message should have a subject!' => 'Zpráva by mìla mít pøedmìt!',
        'Ticket Hook' => 'Oznaèení tiketu',
        'TicketZoom' => 'Zobrazení tiketu',
        'Don\'t forget to add a new user to groups!' => 'Nezapomeòte pøidat nového u¾ivatele do skupin!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Musíte mít  uvedenu emailovou adresu (napø. klient@priklad.cz) v poli Komu:!',
        'CreateTicket' => 'Vytvoøeno Tiketu',
        'You need to account time!' => 'Potøebujete úètovat dobu!',
        'System Settings' => 'Nastavení systému',
        'WebWatcher' => '',
        'Finished' => 'Dokonèeno',
        'Account Type' => '',
        'Split' => 'Rozdìlit',
        'All messages' => 'V¹echny zprávy',
        'System Status' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => '',
        'A article should have a title!' => '',
        'Event' => '',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'don\'t accept license' => 'nesouhlasím s licencí',
        'A web mail client' => '',
        'WebMail' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => '',
        'Name is required!' => '',
        'DB Type' => 'Typ databáze',
        'kill all sessions' => 'Zru¹it v¹echny relace',
        'to get the from line of the email' => 'pro získaní øádku Od z emailu',
        'Solution' => 'Øe¹ení',
        'QueueView' => 'Náhled fronty',
        'Welcome to OTRS' => '',
        'modified' => '',
        'Delete old database' => 'Smazat starou databázi',
        'sort downward' => 'setøídit dolù',
        'You need to use a ticket number!' => '',
        'A web file manager' => '',
        'send' => 'poslat',
        'Note Text' => 'Text poznámky',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => 'Správa stavu systému',
        'OTRS DB User' => 'U¾ivatel OTRS databáze',
        'PhoneView' => 'Nový tiket / hovor',
        'maximal period form' => '',
        'Verion' => '',
        'TicketID' => 'ID tiketu',
        'Modified' => 'Zmìnìno',
        'Ticket selected for bulk action!' => '',
    };
    # $$STOP$$
    return;
}

1;
