# --
# Kernel/Language/cz.pm - provides cz language translation
# Copyright (C) 2003 Lukas Vicanek alias networ <lulka at centrum dot cz>
# Copyright (C) 2004 BENETA.cz, s.r.o. <info at beneta dot cz>
#	Translators: Marta Macalkova
#		     Vadim Buzek 
#		     Petr Ocasek
# --
# $Id: cz.pm,v 1.14 2005-02-23 10:04:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::cz;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Aug 24 10:08:21 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M/%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %Y %T';
    $Self->{DateInputFormat} = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minuty',
      ' 5 minutes' => ' 5 minut',
      ' 7 minutes' => ' 7 minut',
      '(Click here to add)' => '(Pro pøidání kliknìte zde)',
      '...Back' => '',
      '10 minutes' => '10 minut',
      '15 minutes' => '15 minut',
      'Added User "%s"' => '',
      'AddLink' => 'Pøidat Odkaz',
      'Admin-Area' => 'Administraèní zóna',
      'agent' => 'agent',
      'Agent-Area' => 'Zóna agentù',
      'all' => 'v¹e',
      'All' => 'V¹e',
      'Attention' => 'Upozornìní',
      'Back' => 'Zpìt',
      'before' => 'pøed',
      'Bug Report' => 'Upozornìní na chybu',
      'Calendar' => '',
      'Cancel' => 'Stornovat',
      'change' => 'zmìnit',
      'Change' => 'Zmìnit',
      'change!' => 'zmìnit!',
      'click here' => 'kliknìte zde',
      'Comment' => 'Komentáø',
      'Contract' => '',
      'Crypt' => '',
      'Crypted' => '',
      'Customer' => 'Klient',
      'customer' => 'klient',
      'Customer Info' => 'Informace o klientovi',
      'day' => 'den',
      'day(s)' => 'den(dní)',
      'days' => 'dní(dny)',
      'description' => 'popis',
      'Description' => 'Popis',
      'Directory' => '',
      'Dispatching by email To: field.' => 'Pøiøadit podle e-mailu - pole KOMU:.',
      'Dispatching by selected Queue.' => 'Pøiøadit do vybrané fronty.',
      'Don\'t show closed Tickets' => 'Nezobrazovat uzavøené tikety',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Z bezpeènostních dùvodù nepracujte se superu¾ivatelským úètem - vytvoøte si nového u¾ivatele!',
      'Done' => 'Hotovo',
      'end' => 'konec',
      'Error' => 'Chyba',
      'Example' => 'Pøíklad',
      'Examples' => 'Pøíklady',
      'Facility' => 'Funkce',
      'FAQ-Area' => 'FAQ zóna',
      'Feature not active!' => 'Funkce je neaktivní!',
      'go' => 'jdi',
      'go!' => 'jdi!',
      'Group' => 'Skupina',
      'History::AddNote' => 'Added note (%s)',
      'History::Bounce' => 'Bounced to "%s".',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Lock' => 'Locked ticket.',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Unlock' => 'Unlocked ticket.',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::SystemRequest' => 'System Request (%s).',
      'Hit' => 'Pøístup',
      'Hits' => 'Prístupù',
      'hour' => 'hodina',
      'hours' => 'hodin',
      'Ignore' => 'Ignorovat',
      'invalid' => 'neplatný',
      'Invalid SessionID!' => 'Neplatné ID relace!',
      'Language' => 'Jazyk',
      'Languages' => 'Jazyky',
      'last' => 'poslední',
      'Line' => 'Linka',
      'Lite' => 'Omezená',
      'Login failed! Your username or password was entered incorrectly.' => 'Pøihlá¹ení neúspì¹né! Va¹e u¾ivatelské jméno èi heslo bylo zadáno nesprávnì.',
      'Logout successful. Thank you for using OTRS!' => 'Odhlá¹ení bylo úspìsné. Dìkujeme Vám za pou¾ívání OTRS!',
      'Message' => 'Zpráva',
      'minute' => 'minuta',
      'minutes' => 'minut',
      'Module' => 'Modul',
      'Modulefile' => 'Modulový soubor',
      'month(s)' => 'mìsíc(e)',
      'Name' => 'Jméno',
      'New Article' => 'Nová polo¾ka',
      'New message' => 'Nová zpráva',
      'New message!' => 'Nová zpráva!',
      'Next' => '',
      'Next...' => '',
      'No' => 'Ne',
      'no' => 'ne',
      'No entry found!' => 'Nebyl nalezen ¾ádný záznam!',
      'No Permission!' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'No suggestions' => '¾ádné návrhy',
      'none' => '¾ádné',
      'none - answered' => '¾ádný - odpovìzeno',
      'none!' => '¾ádný!',
      'Normal' => 'Normální',
      'off' => 'vypnuto',
      'Off' => 'Vypnuto',
      'On' => 'Zapnuto',
      'on' => 'zapnuto',
      'Online Agent: %s' => '',
      'Online Customer: %s' => '',
      'Password' => 'Heslo',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Pending till' => 'Èekání na vyøízení do',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosím, odpovìzte na tento (tyto) tiket(y) pro návrat do normálního náhledu fronty!',
      'Please contact your admin' => 'Kontaktujte, prosím, Va¹eho administrátora',
      'please do not edit!' => 'prosíme neupravujte!',
      'possible' => 'mo¾ný',
      'Preview' => 'Zobrazit',
      'QueueView' => 'Náhled fronty',
      'reject' => 'zamítnout',
      'replace with' => 'nahradit',
      'Reset' => 'Reset',
      'Salutation' => 'Oslovení',
      'Session has timed out. Please log in again.' => 'Relace vypr¹ela. Prosím, pøihla¹te se znovu.',
      'Show closed Tickets' => 'Zobrazit zavøené tikety',
      'Sign' => '',
      'Signature' => 'Podpis',
      'Signed' => '',
      'Size' => '',
      'Sorry' => 'Omluva',
      'Stats' => 'Statistiky',
      'Subfunction' => 'Podfunkce',
      'submit' => 'odeslat',
      'submit!' => 'Odeslat!',
      'system' => 'systém',
      'Take this Customer' => '',
      'Take this User' => 'Pou¾íj tohoto u¾ivatele',
      'Text' => 'Text',
      'The recommended charset for your language is %s!' => 'Doporuèená znaková sada pro Vá¹ jazyk je %s!',
      'Theme' => 'Design',
      'There is no account with that login name.' => '®ádný úèet s tímto pøihla¹ovacím jménem neexistuje.',
      'Ticket Number' => '',
      'Timeover' => 'Èas vypr¹el',
      'To: (%s) replaced with database email!' => 'To: (%s) nahrazeno emailem z databáze!',
      'top' => 'nahoru',
      'Type' => 'Typ',
      'update' => 'aktualizovat',
      'Update' => 'Aktualizovat',
      'update!' => 'aktualizovat!',
      'Upload' => '',
      'User' => 'U¾ivatel',
      'Username' => 'Jméno u¾ivatele',
      'Valid' => 'Platnost',
      'Warning' => 'Varování',
      'week(s)' => 'týden(týdny)',
      'Welcome to OTRS' => 'Vítejte v OTRS',
      'Word' => 'Slovo',
      'wrote' => 'napsal',
      'year(s)' => 'rok(y)',
      'Yes' => 'Ano',
      'yes' => 'ano',
      'You got new message!' => 'Máte novou zprávu!',
      'You have %s new message(s)!' => 'Máte %s novou zprávu (nových zpráv)!',
      'You have %s reminder ticket(s)!' => 'Máte %s upomínkový(ch) ticket(ù)',

    # Template: AAAMonth
      'Apr' => 'Dub',
      'Aug' => 'Srp',
      'Dec' => 'Pro',
      'Feb' => 'Úno',
      'Jan' => 'Led',
      'Jul' => 'Èer',
      'Jun' => 'Èvc',
      'Mar' => 'Bøe',
      'May' => 'Kvì',
      'Nov' => 'Lis',
      'Oct' => 'Øíj',
      'Sep' => 'Záø',

    # Template: AAAPreferences
      'Closed Tickets' => 'Uzavøené Tikety',
      'CreateTicket' => 'Vytvoøeno Tiketu',
      'Custom Queue' => 'Vlastní fronta',
      'Follow up notification' => 'Následující oznámení',
      'Frontend' => 'Rozhraní',
      'Mail Management' => 'Správa e-mailù',
      'Max. shown Tickets a page in Overview.' => 'Max. zobrazených tiketù v pøehledu na stránku',
      'Max. shown Tickets a page in QueueView.' => 'Max. zobrazených tiketù v náhledu fronty na stránku',
      'Move notification' => 'Pøesunout oznámení',
      'New ticket notification' => 'Nové oznámení tiketu',
      'Other Options' => 'Jiné mo¾nosti',
      'PhoneView' => 'Nový tiket / hovor',
      'Preferences updated successfully!' => 'Nastavení úspì¹nì aktualizováno!',
      'QueueView refresh time' => 'Doba obnovení náhledu fronty',
      'Screen after new ticket' => '',
      'Select your default spelling dictionary.' => 'Vyberte si Vá¹ výchozí pravopisný slovník',
      'Select your frontend Charset.' => 'Vyberte si znakovou sadu Va¹eho rozhraní.',
      'Select your frontend language.' => 'Vyberte si jazyk Va¹eho rozhraní.',
      'Select your frontend QueueView.' => 'Vyberte si náhled fronty Va¹eho rozhraní.',
      'Select your frontend Theme.' => 'Vyberte si design Va¹eho rozhraní.',
      'Select your QueueView refresh time.' => 'Vyberte si dobu obnovení náhledu fronty.',
      'Select your screen after creating a new ticket.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Po¹li mi oznámení, pokud klient po¹le následující a jsem vlastník tohoto tiketu.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Send me a notification if a ticket is unlocked by the system.' => 'Po¹li mi oznámení, pokud je tiket odemknut systémem.',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Show closed tickets.' => 'Ukázat uzavøené tikety.',
      'Spelling Dictionary' => 'Slovník kontroly pravopisu',
      'Ticket lock timeout notification' => 'Oznámení o vypr¹ení èasu uzamèení tiketu',
      'TicketZoom' => 'Zobrazení tiketu',

    # Template: AAATicket
      '1 very low' => '1 velmi nízká',
      '2 low' => '2 nízká',
      '3 normal' => '3 normální',
      '4 high' => '4 vysoká',
      '5 very high' => '5 velmi vysoká',
      'Action' => 'Akce',
      'Age' => 'Stáøí',
      'Article' => 'Polo¾ka',
      'Attachment' => 'Pøíloha',
      'Attachments' => 'Pøílohy',
      'Bcc' => 'Slepá kopie',
      'Bounce' => 'Odeslat zpìt',
      'Cc' => 'Kopie',
      'Close' => 'Zavøít',
      'closed' => 'uzavøeno',
      'closed successful' => 'uzavøeno - vyøe¹eno',
      'closed unsuccessful' => 'uzavøeno - nevyøe¹eno',
      'Compose' => 'Sestavit',
      'Created' => 'Vytvoøeno',
      'Createtime' => 'Doba vytvoøení',
      'email' => 'email',
      'eMail' => 'eMail',
      'email-external' => 'externí email',
      'email-internal' => 'interní email',
      'Forward' => 'Pøedat',
      'From' => 'Od',
      'high' => 'vysoký',
      'History' => 'Historie',
      'If it is not displayed correctly,' => 'Pokud není zobrazeno správnì,',
      'lock' => 'zamèeno',
      'Lock' => 'Zámek',
      'low' => 'nízký',
      'Move' => 'Pøesunout',
      'new' => 'nová',
      'normal' => 'normalní',
      'note-external' => 'poznámka-externí',
      'note-internal' => 'poznámka-interní',
      'note-report' => 'poznámka-report',
      'open' => 'otevøít',
      'Owner' => 'Vlastník',
      'Pending' => 'Èeká na vyøízení',
      'pending auto close+' => 'èeká na vyøízení - automaticky zavøít+',
      'pending auto close-' => 'èeká na vyøízení - automaticky zavøít-',
      'pending reminder' => 'upomínka pøi èekání na vyøízení',
      'phone' => 'telefon',
      'plain' => 'jednoduchý',
      'Priority' => 'Priorita',
      'Queue' => 'Fronta',
      'removed' => 'odstranìn',
      'Sender' => 'Odesílatel',
      'sms' => 'sms',
      'State' => 'Stav',
      'Subject' => 'Pøedmìt',
      'This is a' => 'Toto je',
      'This is a HTML email. Click here to show it.' => 'Toto je HTML email. Pro zobrazení kliknìte zde.',
      'This message was written in a character set other than your own.' => 'Tato zpráva byla napsána v jiné znakové sadì ne¾ Va¹e.',
      'Ticket' => 'Tiket',
      'Ticket "%s" created!' => 'Tiket "%s" vytvoøen!',
      'To' => 'Komu',
      'to open it in a new window.' => 'pro otevøení v novém oknì.',
      'Unlock' => 'Zámek',
      'unlock' => 'nezamèený',
      'very high' => 'velmi vysoká',
      'very low' => 'velmi nízká',
      'View' => 'Náhled',
      'webrequest' => 'po¾adavek pøes web',
      'Zoom' => 'Zobrazit',

    # Template: AAAWeekDay
      'Fri' => 'Pá',
      'Mon' => 'Po',
      'Sat' => 'So',
      'Sun' => 'Ne',
      'Thu' => 'Èt',
      'Tue' => 'Út',
      'Wed' => 'St',

    # Template: AdminAttachmentForm
      'Add' => 'Pøidat',
      'Attachment Management' => 'Správa pøíloh',

    # Template: AdminAutoResponseForm
      'Auto Response From' => 'Automatická odpovìï Od',
      'Auto Response Management' => 'Správa automatických odpovìdí',
      'Note' => 'Poznámka',
      'Response' => 'Odpovìï',
      'to get the first 20 character of the subject' => 'pro získáni prvních 20 znakù z pøedmìtu',
      'to get the first 5 lines of the email' => 'pro získání prvních 5 øádkù z emailu',
      'to get the from line of the email' => 'pro získaní øádku Od z emailu',
      'to get the realname of the sender (if given)' => 'pro získaní skuteèného jména odesílatele (pokud je zadáno)',
      'to get the ticket id of the ticket' => 'pro získání ID tiketu z tiketu',
      'to get the ticket number of the ticket' => 'pro získání èísla tiketu z tiketu',
      'Useable options' => 'Dostupné mo¾nosti',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Správa Klientù',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',
      'Result' => '',
      'Search' => 'Vyhledat',
      'Search for' => '',
      'Select Source (for add)' => '',
      'Source' => '',
      'The message being composed has been closed.  Exiting.' => 'Vytváøená zpráva byla uzavøena. Opou¹tím.',
      'This values are read only.' => '',
      'This values are required.' => '',
      'This window must be called from compose window' => 'Toto okno musí být vyvoláno z okna vytváøení',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Zmìnit nastavení %s',
      'Customer User <-> Group Management' => 'Klient <-> Správa skupiny',
      'Full read and write access to the tickets in this group/queue.' => 'Plný pøístup pro ètení a psaní do tiketù v této skupinì/frontì.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Pokud nebylo nic vybráno, nejsou v této skupinì ¾ádná práva (tikety nebudou pro u¾ivatele dostupné).',
      'Permission' => 'Práva',
      'Read only access to the ticket in this group/queue.' => 'Pøístup pouze pro ètení tiketu v této skupinì/øadì.',
      'ro' => 'jen ètení',
      'rw' => 'ètení/psaní',
      'Select the user:group permissions.' => 'Vybrat u¾ivatele:práva skupiny',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Zmìnit u¾ivatele <-> nastavení skupiny',

    # Template: AdminEmail
      'Admin-Email' => 'Email administrátora',
      'Body' => 'Tìlo',
      'OTRS-Admin Info!' => 'Informace o OTRS-Administrátorovi!',
      'Recipents' => 'Adresáti',
      'send' => 'poslat',

    # Template: AdminEmailSent
      'Message sent to' => 'Zpráva odeslána',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => '(napø. 10*5155 or 105658*)',
      '(e. g. 234321)' => '(napø. 234321)',
      '(e. g. U5150)' => '(napø. U5150)',
      '-' => '',
      'Add Note' => 'Pøidat poznámku',
      'Agent' => 'Agent',
      'and' => 'a',
      'CMD' => '',
      'Customer User Login' => 'Pøihlá¹ení klienta',
      'CustomerID' => 'ID klienta',
      'CustomerUser' => 'Klient',
      'Days' => '',
      'Delete' => 'Smazat',
      'Delete tickets' => '',
      'Edit' => 'Editovat',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fulltextové vyhledávání v polo¾ce (napø. "Mar*in" or "Baue*")',
      'GenericAgent' => '',
      'Hours' => '',
      'Job-List' => '',
      'Jobs' => '',
      'Last run' => '',
      'Minutes' => '',
      'Modules' => '',
      'New Agent' => '',
      'New Customer' => '',
      'New Owner' => 'Nový vlastník',
      'New Priority' => '',
      'New Queue' => 'Nová fronta',
      'New State' => '',
      'New Ticket Lock' => '',
      'No time settings.' => '®ádná nastavení doby',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',
      'Save Job as?' => '',
      'Schedule' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Ticket created' => 'Tiket vytvoøen',
      'Ticket created between' => 'Tiket vytvoøen mezi',
      'Ticket Lock' => '',
      'TicketFreeText' => 'Volný text tiketu',
      'Times' => 'Doba',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Vytvoøit nové skupiny pro pøiøazení práv pøístupù ruzným skupinám agentù (napø. oddìlení nákupu, oddìlení podpory, oddìlení prodeje...).',
      'Group Management' => 'Správa skupiny',
      'It\'s useful for ASP solutions.' => 'To je vhodné pro øe¹ení ASP',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Skupina administrátora má pøístup do administraèní a statistické zóny.',

    # Template: AdminLog
      'System Log' => 'Log systému',
      'Time' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Email Administrátora',
      'Attachment <-> Response' => 'Pøíloha <-> Odpovìï',
      'Auto Response <-> Queue' => 'Automatická odpovìï <-> Fronta',
      'Auto Responses' => 'Automatické odpovìdi',
      'Customer User' => 'Klient - U¾ivatelé',
      'Customer User <-> Groups' => 'Klient  - U¾ivatelé <-> Skupiny',
      'Email Addresses' => 'Emailové adresy',
      'Groups' => 'Skupiny',
      'Logout' => 'Odhlásit',
      'Misc' => 'Rùzné',
      'Notifications' => 'Oznámení',
      'PGP Keys' => '',
      'PostMaster Filter' => 'PostMaster filtr',
      'PostMaster POP3 Account' => 'PostMaster POP3 úèet',
      'Responses' => 'Odpovìdi',
      'Responses <-> Queue' => 'Odpovìdi <-> Fronta',
      'Role' => '',
      'Role <-> Group' => '',
      'Role <-> User' => '',
      'Roles' => '',
      'Select Box' => 'Po¾adavek na SQL databázi',
      'Session Management' => 'Správa relace',
      'SMIME Certificates' => '',
      'Status' => 'Stav',
      'System' => 'Systém',
      'User <-> Groups' => 'U¾ivatelé <-> Skupiny',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Notification Management' => 'Správa oznámení',
      'Notifications are sent to an agent or a customer.' => 'Oznámení jsou odeslána agentovi èi klientovi',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => '',
      'File' => '',
      'Fingerprint' => '',
      'FIXME: WHAT IS PGP?' => '',
      'Identifier' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Key' => 'Klíè',
      'PGP Key Management' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'V¹echny pøíchozí emaily z daného úètu budou zaøazeny do vybrané fronty!',
      'Dispatching' => 'Zaøazení',
      'Host' => 'Hostitel',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',
      'POP3 Account Management' => 'Správa POP3 úètù',
      'Trusted' => 'Ovìøeno',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'Filtername' => '',
      'Header' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',
      'Match' => 'Obsahuje',
      'PostMaster Filter Management' => '',
      'Set' => 'Nastavit',
      'Value' => 'Hodnota',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Fronta <-> Správa automatických opovìdí',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = ¾ádné stupòování',
      '0 = no unlock' => '0 = ¾ádné odemknutí',
      'Customer Move Notify' => 'Oznámení Klientovi o zmìnì fronty',
      'Customer Owner Notify' => 'Oznámení Klientovi o zmìnì vlastníka',
      'Customer State Notify' => 'Oznámení Klientovi o zmìnì stavu',
      'Escalation time' => 'Doba stupòování',
      'Follow up Option' => 'Následující volba',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Pokud je tiket uzavøen a klient ode¹le následující, tiket bude pro starého vlastníka uzamknut.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Nebude-li tiket odpovìzen v daném èase, bude zobrazen pouze tento Tiket.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Pokud agent uzamkne tiket a neode¹le v této dobì odpovìï, tiket bude automaticky odemknut. Tak se stane tiket viditelný pro v¹echny ostatní agenty.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS po¹le klientovi emailem oznámení, pokud bude tiket pøesunut.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS po¹le klientovi emailem oznámení, pokud se zmìní vlastník tiketu.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS po¹le klientovi emailem oznámení, pokud se zmìní stav tiketu.',
      'Queue Management' => 'Správa front',
      'Sub-Queue of' => 'Podfronta ',
      'Systemaddress' => 'Systémová adresa',
      'The salutation for email answers.' => 'Oslovení pro emailové odpovìdi.',
      'The signature for email answers.' => 'Podpis pro emailové odpovìdi.',
      'Ticket lock after a follow up' => 'Zamknout tiket po následujícím',
      'Unlock timeout' => 'Èas do odemknutí',
      'Will be the sender address of this queue for email answers.' => 'Bude adresou odesílatele z této fronty pro emailové odpovìdi.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Standartní odpovìdi <-> Správa front',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Odpovìï',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Standartní odpovìdi <-> Standartní správa pøíloh',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Odpovìï je obsahuje výchozí text slou¾ící k rychlej¹í reakci (spolu s výchozím textem) klientùm.',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'Don\'t forget to add a new response a queue!' => 'Nezapomeòte pøidat novou reakci odpoveï do fronty!',
      'Next state' => 'Nasledující stav',
      'Response Management' => 'Správa odpovìdí',
      'The current ticket state is' => 'Aktuální stav tiketu je',
      'Your email address is new' => '',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',
      'Role Management' => '',

    # Template: AdminRoleGroupChangeForm
      'create' => 'vytvoøit',
      'move_into' => 'pøesunout do',
      'owner' => 'vlastník',
      'Permissions to change the ticket owner in this group/queue.' => 'Práva zmìnit vlastník tiketu v této skupinì/frontì',
      'Permissions to change the ticket priority in this group/queue.' => 'Práva zmìnit prioritu tiketu v této skupinì/frontì',
      'Permissions to create tickets in this group/queue.' => 'Práva vytvoøit tikety v této skupinì/frontì',
      'Permissions to move tickets into this group/queue.' => 'Práva pøesunout tikety do této skupiny/fronty',
      'priority' => 'priorita',
      'Role <-> Group Management' => '',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => '',

    # Template: AdminRoleUserChangeForm
      'Active' => '',
      'Role <-> User Management' => '',
      'Select the role:user relations.' => '',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => '',

    # Template: AdminSMIMEForm
      'Add Certificate' => '',
      'Add Private Key' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',
      'Secret' => '',
      'SMIME Certificate Management' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'skuteèné jméno klienta',
      'for agent firstname' => 'pro køestní jméno agenta',
      'for agent lastname' => 'pro pøíjmení agenta',
      'for agent login' => 'pro pøihlá¹ení agenta',
      'for agent user id' => 'pro u¾ivatelské ID agenta',
      'Salutation Management' => 'Správa oslovení',

    # Template: AdminSelectBoxForm
      'Limit' => 'Limit',
      'SQL' => 'SQL',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'Výsledek SQL dotazu',

    # Template: AdminSession
      'kill all sessions' => 'Zru¹it v¹echny relace',
      'kill session' => 'zru¹it relaci',
      'Overview' => 'Pøehled',
      'Session' => '',
      'Sessions' => 'Relace',
      'Uniq' => 'Poèet',

    # Template: AdminSignatureForm
      'Signature Management' => 'Správa podpisù',

    # Template: AdminStateForm
      'See also' => 'Viz. také',
      'State Type' => 'Typ stavu',
      'System State Management' => 'Správa stavu systému',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Ujistìte se, ¾e jste aktualizovali také výchozí hodnoty ve Va¹em Kernel/Config.pm!',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'V¹echny pøíchozí emaily obsahující tohoto adresáta (v poli KOMU) budou zaøazeny to vybrané fronty!',
      'Email' => 'Email',
      'Realname' => 'Skuteèné jméno',
      'System Email Addresses Management' => 'Správa emailových adres systému',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Nezapomeòte pøidat nového u¾ivatele do skupin!',
      'Firstname' => 'Køestní jméno',
      'Lastname' => 'Pøíjmení',
      'User Management' => 'Správa u¾ivatelù',
      'User will be needed to handle tickets.' => 'U¾ivatel bude potøebovat práva pro ovládání tiketù.',

    # Template: AdminUserGroupChangeForm
      'User <-> Group Management' => 'Správa u¾ivatelù <-> skupin',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => 'Adresáø',
      'Discard all changes and return to the compose screen' => 'Zru¹it v¹echny zmìny a vrátit se zpìt do okna vytváøení',
      'Return to the compose screen' => 'Vrátit se zpìt do okna vytváøení',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Zpráva by mìla obsahovat Komu: pøíjemce!',
      'Bounce ticket' => 'Odeslat tiket zpìt',
      'Bounce to' => 'Odeslat zpìt',
      'Inform sender' => 'Informovat odesílatele',
      'Next ticket state' => 'Následující stav tiketu',
      'Send mail!' => 'Poslat mail!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Musíte mít  uvedenu emailovou adresu (napø. klient@priklad.cz) v poli Komu:!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Vá¹ email s èíslem ticketu "<OTRS_TICKET>" je odeslán zpìt na "<OTRS_BOUNCE_TO>". Kontaktujte tuto adresu pro dal¹í infromace.',

    # Template: AgentBulk
      '$Text{"Note!' => '',
      'A message should have a subject!' => 'Zpráva by mìla mít pøedmìt!',
      'Note type' => 'Typ poznámky',
      'Note!' => 'Poznámka!',
      'Options' => 'Mo¾nosti',
      'Spell Check' => 'Kontrola pravopisu',
      'Ticket Bulk Action' => '',

    # Template: AgentClose
      ' (work units)' => '(jednotky práce)',
      'A message should have a body!' => 'Zpráva by mìla mít tìlo!',
      'Close ticket' => 'Zavøít tiket',
      'Close type' => 'Zavøít typ',
      'Close!' => 'Zavøít!',
      'Note Text' => 'Text poznámky',
      'Time units' => 'Jednotky èasu',
      'You need to account time!' => 'Potøebujete úètovat dobu!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Zpráva musí být pravopisnì zkontrolovaná!',
      'Attach' => 'Pøipojit',
      'Compose answer for ticket' => 'Sestavit odpovìï pro tiket',
      'for pending* states' => 'pro stavy èekání na vyøízení*',
      'Is the ticket answered' => 'Je tiket zodpovìzen',
      'Pending Date' => 'Doba èekání na vyøízení',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'Zmìnit klienta tiketu',
      'Search Customer' => 'Vyhledat klienta',
      'Set customer user and customer id of a ticket' => 'Nastavit klienta a nastavit ID klienta tiketu',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'V¹echny tikety klienta',
      'Customer history' => 'Historie klienta',

    # Template: AgentCustomerMessage
      'Follow up' => 'Následující',

    # Template: AgentCustomerView
      'Customer Data' => 'Data klienta',

    # Template: AgentEmailNew
      'All Agents' => 'V¹ichni agenti',
      'Clear To' => '',
      'Compose Email' => '',
      'new ticket' => 'nový tiket',

    # Template: AgentForward
      'Article type' => 'Typ polo¾ky',
      'Date' => 'Datum',
      'End forwarded message' => 'Konec pøedané zprávy',
      'Forward article of ticket' => 'Pøedat polo¾ku tiketu',
      'Forwarded message from' => 'Pøedat zprávu od',
      'Reply-To' => 'Odpovìdìt-Komu',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Zmìnit úplný text tiketu',

    # Template: AgentHistoryForm
      'History of' => 'Historie',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => 'Info',

    # Template: AgentLookup
      'Lookup' => '',

    # Template: AgentMailboxNavBar
      'All messages' => 'V¹echny zprávy',
      'down' => 'dolù',
      'Mailbox' => 'Po¹tovní schránka',
      'New' => 'Nové',
      'New messages' => 'Nové zprávy',
      'Open' => 'Otevøít',
      'Open messages' => 'Otevøít zprávy',
      'Order' => 'Seøadit',
      'Pending messages' => 'Zprávy èekající na vyøízení',
      'Reminder' => 'Upomínka',
      'Reminder messages' => 'Upomínkové zprávy',
      'Sort by' => 'Setøídit dle',
      'Tickets' => 'Tikety',
      'up' => 'nahoru',

    # Template: AgentMailboxTicket
      '"}' => '"}',
      '"}","14' => '"}","14',
      'Add a note to this ticket!' => '',
      'Change the ticket customer!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket priority!' => '',
      'Close this ticket!' => '',
      'Shows the detail view of this ticket!' => '',
      'Unlock this ticket!' => '',

    # Template: AgentMove
      'Move Ticket' => 'Pøesunout tiket',
      'Previous Owner' => 'Pøedchozí vlastník',
      'Queue ID' => 'ID fronty',

    # Template: AgentNavigationBar
      'Agent Preferences' => '',
      'Bulk Action' => '',
      'Bulk Actions on Tickets' => '',
      'Create new Email Ticket' => '',
      'Create new Phone Ticket' => '',
      'Email-Ticket' => '',
      'Locked tickets' => 'Uzamèené tikety',
      'new message' => 'Po¹tovní schránka',
      'Overview of all open Tickets' => '',
      'Phone-Ticket' => '',
      'Preferences' => 'Nastavení',
      'Search Tickets' => '',
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

    # Template: AgentNote
      'Add note to ticket' => 'Pøidat poznámku k tiketu',

    # Template: AgentOwner
      'Change owner of ticket' => 'Zmìnit vlastníka tiketu',
      'Message for new Owner' => 'Zpráva pro nového vlastníka',

    # Template: AgentPending
      'Pending date' => 'Datum èekání na vyøízení',
      'Pending type' => 'Typ èekání na vyøízení',
      'Set Pending' => 'Nastavit - èeká na vyøízení',

    # Template: AgentPhone
      'Phone call' => 'Telefoní hovor',

    # Template: AgentPhoneNew
      'Clear From' => 'Vymazat pole Od',

    # Template: AgentPlain
      'ArticleID' => 'ID polo¾ky',
      'Download' => '',
      'Plain' => 'Jednoduché',
      'TicketID' => 'ID tiketu',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => '',
      'You also get notified about this queues via email if enabled.' => '',
      'Your queue selection of your favorite queues.' => '',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Zmìnit heslo',
      'New password' => 'Nové heslo',
      'New password again' => 'Nové heslo (znovu )',

    # Template: AgentPriority
      'Change priority of ticket' => 'Zmìnit dùle¾itost tiketu',

    # Template: AgentSpelling
      'Apply these changes' => 'Aplikovat tyto zmìny',
      'Spell Checker' => 'Funkce na kontrolu pravopisu',
      'spelling error(s)' => 'chyba(y) v pravopisu',

    # Template: AgentStatusView
      'D' => 'A-Z',
      'of' => 'z',
      'Site' => 'Umístìní',
      'sort downward' => 'setøídit dolù',
      'sort upward' => 'setøídit nahoru',
      'Ticket Status' => 'Stav tiketu',
      'U' => 'Z-A',

    # Template: AgentTicketLink
      'Delete Link' => '',
      'Link' => 'Odkaz',
      'Link to' => 'Odkaz na',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Tiket zamknut!',
      'Ticket unlock!' => 'Tiket odemknut!',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Úètovaná doba',
      'Escalation in' => 'Stupòování v',

    # Template: AgentUtilSearch
      'Profile' => 'Profil',
      'Result Form' => 'Forma výsledku',
      'Save Search-Profile as Template?' => 'Ulo¾it profil vyhledávání jako ¹ablonu?',
      'Search-Template' => 'Forma vyhledávání',
      'Select' => 'Vybrat',
      'Ticket Search' => 'Hledání tiketu',
      'Yes, save it with name' => 'Ano, ulo¾it pod názvem',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Vyhledávání historie klienta',
      'Customer history search (e. g. "ID342425").' => 'Vyhledávání historie klienta (napø. "ID342425")',
      'No * possible!' => '®ádná * mo¾ná!',

    # Template: AgentUtilSearchResult
      'Change search options' => 'Zmìnit mo¾nosti vyhledávání',
      'Results' => 'Výsledky',
      'Search Result' => 'Výsledky vyhledávání',
      'Total hits' => 'Celkový poèet záznamù',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'V¹echny uzavøené tikety',
      'All open tickets' => 'V¹echny otevøené tikety',
      'closed tickets' => 'uzavøené tikety',
      'open tickets' => 'otevøené tikety',
      'or' => 'nebo',
      'Provides an overview of all' => 'Poskytnou pøehled v¹ech',
      'So you see what is going on in your system.' => 'Tady vidíte, co se odehrává ve Va¹em systému.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Sestavit následující',
      'Your own Ticket' => 'Vá¹ vlastní tiket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Odpovìdìt',
      'Contact customer' => 'Kontaktovat klienta',
      'phone call' => 'telefoní hovor',

    # Template: AgentZoomArticle
      'Split' => 'Rozdìlit',

    # Template: AgentZoomBody
      'Change queue' => 'Zmìnit frontu',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => '',
      'Free Fields' => 'Volná pole',
      'Link this ticket to an other one!' => '',
      'Lock it to work on it!' => '',
      'Print' => 'Tisknout',
      'Print this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Shows the ticket history!' => '',

    # Template: AgentZoomStatus
      '"}","18' => '"}","18',
      'Locked' => '',
      'SLA Age' => '',

    # Template: Copyright
      'printed by' => 'tisknuto',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Vytvoøit úèet',
      'Login' => '',

    # Template: CustomerError
      'Traceback' => 'Jít zpìt',

    # Template: CustomerFAQArticleHistory
      'FAQ History' => 'Historie FAQ',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Kategorie',
      'Keywords' => 'Klíèová slova',
      'Last update' => 'Poslední aktualizace',
      'Problem' => 'Problém',
      'Solution' => 'Øe¹ení',
      'Symptom' => 'Pøíznak',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'Historie FAQ systému',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'FAQ èlánek',
      'Modified' => 'Zmìnìno',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'Pøehled FAQ',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'Vyhledat FAQ',
      'Fulltext' => 'Fulltext',
      'Keyword' => 'Klíèové slovo',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'Výsledky vyhledávání FAQ',

    # Template: CustomerFooter
      'Powered by' => 'Vytvoøeno',

    # Template: CustomerLostPassword
      'Lost your password?' => 'Ztratil/a jste heslo?',
      'Request new password' => 'Po¾ádat o nové heslo',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => '',
      'Create new Ticket' => 'Vytvoøit nový tiket',
      'FAQ' => 'FAQ',
      'MyTickets' => '',
      'New Ticket' => 'Nový tiket',
      'Welcome %s' => 'Vítejte %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerTicketSearch

    # Template: CustomerTicketSearchResultPrint

    # Template: CustomerTicketSearchResultShort

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Kliknìte zde pro nahlá¹ení chyby!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Mazání FAQ',
      'You really want to delete this article?' => 'Chcete opravdu smazat tento èlánek?',

    # Template: FAQArticleForm
      'A article should have a title!' => '',
      'Comment (internal)' => 'Komentáø (interní)',
      'Filename' => 'Název souboru',
      'Title' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => 'Kategorie FAQ',
      'Name is required!' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => 'Jazyk FAQ',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => 'Hlava stránky',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => 'Vytvoøit Databazi',
      'Drop Database' => 'Odstranit databazi',
      'Finished' => 'Dokonèeno',
      'System Settings' => 'Nastavení systému',
      'Web-Installer' => 'Web-instalátor',

    # Template: InstallerFinish
      'Admin-User' => 'Administrátor',
      'After doing so your OTRS is up and running.' => 'Po dokonèení následujících operací je Vá¹ OTRS spu¹tìn a pobì¾í',
      'Have a lot of fun!' => 'Pøejeme hodnì úspìchù s OTRS!',
      'Restart your webserver' => 'Restartujte Vá¹ webserver',
      'Start page' => 'Úvodní stránka',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Abyste mohli pou¾ívat OTRS, musíte zadat následující øádek do Va¹eho pøíkazového øádku (Terminal/Shell) jako root.',
      'Your OTRS Team' => 'Vá¹ OTRS tým',

    # Template: InstallerLicense
      'accept license' => 'souhlasím s licencí',
      'don\'t accept license' => 'nesouhlasím s licencí',
      'License' => 'Licence',

    # Template: InstallerStart
      'Create new database' => 'Vytvoøit novou databázi',
      'DB Admin Password' => 'Heslo administrátora databáze',
      'DB Admin User' => 'Administrátor databáze',
      'DB Host' => 'Hostitel (server) databáze',
      'DB Type' => 'Typ databáze',
      'default \'hot\'' => 'výchozí \'hot\'',
      'Delete old database' => 'Smazat starou databázi',
      'next step' => 'dal¹í krok',
      'OTRS DB connect host' => 'Hostitel OTRS databáze (server)',
      'OTRS DB Name' => 'Název OTRS databáze',
      'OTRS DB Password' => 'Heslo OTRS databáze',
      'OTRS DB User' => 'U¾ivatel OTRS databáze',
      'your MySQL DB should have a root password! Default is empty!' => 'Va¹e MySQL databáze by mìla mít root heslo! Výchozí je prázdné!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontroluj MX záznamy pou¾itých emailových adres pøi sestavování odpovìdi. Nepou¾ívejte pokud OTRS server pøipojen pomocí vytáèené linky!)',
      '(Email of the system admin)' => '(Email administrátora systému)',
      '(Full qualified domain name of your system)' => '(Platný název domény pro vá¹ systém (FQDN))',
      '(Logfile just needed for File-LogModule!)' => '(Pro logování do souboru je nutné zadat název souboru logu!)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Identita systému. Ka¾dé èíslo tiketu a ID ka¾dá HTTP relace zaèíná tímto èíslem)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identifikátor tiketù. Nekteøí lidé chtìjí nastavit napø. \'Tiket#\',  \'Hovor#\' nebo \'MujTiket#\')',
      '(Used default language)' => '(Pou¾itý výchozí jazyk)',
      '(Used log backend)' => '(Pou¾it výstup do logu)',
      '(Used ticket number format)' => '(Pou¾itý formát èísel tiketù)',
      'CheckMXRecord' => 'Kontrolovat MX záznam',
      'Default Charset' => 'Výchozí znaková sada',
      'Default Language' => 'Výchozí jazyk',
      'Logfile' => 'Log soubor',
      'LogModule' => 'Log Modul',
      'Organization' => 'Organizace',
      'System FQDN' => 'Systém FQDN',
      'SystemID' => 'Systémové ID',
      'Ticket Hook' => 'Oznaèení tiketu',
      'Ticket Number Generator' => 'Generátor èísel tiketù',
      'Use utf-8 it your database supports it!' => 'Pou¾ijte utf-8 pokud to Va¹e databáze podporuje',
      'Webfrontend' => 'Webove rozhraní',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => '®ádná práva',

    # Template: Notify

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: QueueView
      'All tickets' => 'V¹echny tikety',
      'Page' => 'Strana',
      'Queues' => 'Øady',
      'Tickets available' => 'Tiketù k dispozici',
      'Tickets shown' => 'Zobrazené tikety',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'Testovací OTRS stránka',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Eskalace tiketù',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => 'Domù',

    # Template: customer-css
      'Contact' => 'Konktakt',
      'Online-Support' => 'Online Podpora',
      'Products' => 'Produkty',
      'Support' => 'Podpora',

    # Misc
      '"}","15' => '"}","15',
      '"}","30' => '"}","30',
      'A message should have a From: recipient!' => 'Zpráva by mìla obsahovat pole Od: pøíjemce!',
      'Add auto response' => 'Pøidat automatickou odpovìï',
      'AgentFrontend' => 'Rozhraní agentù',
      'Article free text' => 'Úplný text polo¾ky',
      'Change Response <-> Attachment settings' => 'Zmìnit odpovìï <-> Nastavení pøíloh',
      'Change answer <-> queue settings' => 'Zmìnit odpovìï <-> nastavení fronty',
      'Change auto response settings' => 'Zmìnit nastavení automatických odpovìdí',
      'Change setting' => 'Zmìn nastavení',
      'Charset' => 'Znaková sada',
      'Charsets' => 'Znakové sady',
      'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Mo¾nosti konfigurace (napø. <OTRS_CONFIG_HttpType>)',
      'Create' => 'Vytvoøit',
      'Customer called' => 'Klient volal',
      'Customer info' => 'Informace o klientovi',
      'Customer user will be needed to to login via customer panels.' => 'Klient se musí pøihlasit pøes panely klientù.',
      'FAQ State' => 'Stav FAQ',
      'Fulltext search' => 'Fulltextové vyhledávání',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Fulltextové vyhledávání (napø. "Mar*in" or "Baue*" or "martin+ahoj")',
      'Graphs' => 'Grafy',
      'Handle' => 'Ovládání',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Pokud je Vá¹ úèet ovìøen, x-OTRS hlavièky (pro dùle¾itost, ...) budou pou¾ívány!',
      'In Queue' => 'Ve frontì',
      'Lock Ticket' => 'Zamknout tiket',
      'Max Rows' => 'Max. poèet øádkù',
      'My Tickets' => 'Moje tikety',
      'New state' => 'Nový stav',
      'New ticket via call.' => 'Nový tiket pøijatý telefonem.',
      'New user' => 'Nový u¾ivatel',
      'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_USERFIRSTNAME>)' => 'Volby dat aktuálního klienta (napø. <OTRS_CUSTOMER_DATA_USERFIRSTNAME>)',
      'Options of the current user who requested this action (e. g. <OTRS_CURRENT_USERFIRSTNAME>)' => 'Volby aktuálního klienta, který po¾adoval tuto akci (napø. <OTRS_CURRENT_USERFIRSTNAME>)',
      'POP3 Account' => 'POP3 úèty',
      'Pending!' => 'Èeká na vyøízení!',
      'Phone call at %s' => 'Telefoní hovor v %s',
      'Please go away!' => 'Prosíme odejdìte!',
      'PostMasterFilter Management' => 'Správa PostMaster filtru',
      'Screen after new phone ticket' => 'Zobrazit po novém telefonním tiketu',
      'Search in' => 'Hledat v',
      'Select source:' => '',
      'Select your custom queues' => 'Vyberte si Va¹e vlastní fronty',
      'Select your screen after creating a new ticket via PhoneView.' => 'Vyberte si Va¹e zobrazení po vytvoøení nového tiketu pøes telefonní náhled.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Po¹li mi oznámení, pokud je tiket pøesunut do Vlastní fronty.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Po¹li mi oznámení, pokud je nový tiket v mých vlastních frontách.',
      'SessionID' => 'ID relace',
      'Set customer id of a ticket' => 'Nastavení ID klienta na tiketu',
      'Short Description' => 'Krátký popis',
      'Show all' => 'Zobrazit v¹e',
      'System Charset Management' => 'Správa znakových sad v systému',
      'System Language Management' => 'Správa jazykù v systému',
      'Ticket free text' => 'Volný text tiketu',
      'Ticket owner options (e. g. <OTRS_OWNER_USERFIRSTNAME>)' => 'Volby vlastníka tiketu (napø. <OTRS_OWNER_USERFIRSTNAME>)',
      'Ticket-Overview' => 'Pøehled tiketù',
      'Utilities' => 'Pomùcky',
      'View Queue' => 'Zobraz frontu',
      'With Priority' => 'S dùle¾itostí',
      'With State' => 'Se stavem',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'Vá¹ email s èíslem tiketu "<OTRS_TICKET>" byl odeslán zpìt "<OTRS_BOUNCE_TO>". Kontaktujte tuto adresu pro dal¹í informace.',
      'auto responses set' => 'sada automatických odpovìdí',
      'by' => 'pøes',
      'invalid-temporarily' => 'doèasnì neplatný',
      'search' => 'hledat',
      'search (e. g. 10*5155 or 105658*)' => 'hledat (napø: 10*5155 nebo 105658*)',
      'store' => 'ulo¾it',
      'tickets' => 'tikety',
      'valid' => 'platný',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;

