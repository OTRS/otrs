# --
# Kernel/Language/cz.pm - provides cz language translation
# Copyright (C) 2003 Tomas Krmela <tomas.krmela at pvt.cz>
# --
# $Id: cz.pm,v 1.1 2003-08-28 16:57:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::cz;

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
    # Last translation Sun Apr 13 00:56:54 2003 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 Minut',
      ' 5 minutes' => ' 5 Minut',
      ' 7 minutes' => ' 7 Minut',
      '10 minutes' => '10 Minut',
      '15 minutes' => '15 Minut',
      'AddLink' => 'Pøidat odkaz',
      'AdminArea' => 'Administrace',
      'agent' => 'agent',
      'all' => 'v¹e',
      'All' => 'V¹e',
      'Attention' => 'Upozornìní',
      'Bug Report' => 'Chybová hlá¹ka',
      'Cancel' => 'Zru¹it',
      'change' => 'zmìnit',
      'Change' => 'Zmìnit',
      'change!' => 'zmìnit!',
      'click here' => 'tukni zde',
      'Comment' => 'Komentáø',
      'Customer' => 'Zákazník',
      'customer' => 'zákaznik',
      'Customer Info' => 'Informace o zákaznikovi',
      'day' => 'den',
      'days' => 'dny',
      'description' => 'popis',
      'Description' => 'Popis',
      'Dispatching by email To: field.' => 'odesilani prostrednictvim polo¾ky emailu Kam: .',
      'Dispatching by selected Queue.' => 'odesilani prostrednictvim vybrané fronty.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Prosím, nepracujte s UserID 1 (System ucet)! vytvoøte nové u¾ivatele!',
      'Done' => 'Hotovo',
      'end' => 'konec',
      'Error' => 'Chyba',
      'Example' => 'Pøíklad',
      'Examples' => 'Pøíklady',
      'Facility' => 'Mo¾nost',
      'Feature not active!' => 'Funkcionalita neni aktivována!',
      'go' => 'Start',
      'go!' => 'Start!',
      'Group' => 'Skupina',
      'Hit' => '',
      'Hits' => '',
      'hour' => 'hodina',
      'hours' => 'hodiny',
      'Ignore' => 'ignorovat',
      'invalid' => 'neplatny',
      'Invalid SessionID!' => 'neplatné session ID!',
      'Language' => 'Jazyk',
      'Languages' => 'Jazyky',
      'Line' => '',
      'Lite' => 'lehky',
      'Login failed! Your username or password was entered incorrectly.' => 'Pøihlá¹ení selhalo! Va¹e jmeno nebo heslo bylo zadáno nespravne.',
      'Logout successful. Thank you for using OTRS!' => 'Byl jste odhlá¹en.Dìkujeme Vám za pou¾ívání OTRS!',
      'Message' => 'Zpráva',
      'minute' => 'Minuta',
      'minutes' => 'Minuty',
      'Module' => 'Modul',
      'Modulefile' => 'soubor modulu',
      'Name' => 'Jmméno',
      'New message' => 'Nová zpráva',
      'New message!' => 'Nová zpráva!',
      'No' => 'Ne',
      'no' => 'ne',
      'No entry found!' => '¾adny zaznam nebyl nalezen!',
      'No suggestions' => '®ádné návrhy',
      'none' => '',
      'none - answered' => '',
      'none!' => '',
      'Off' => '',
      'off' => '',
      'On' => '',
      'on' => '',
      'Password' => 'Heslo',
      'Pending till' => 'Dosud nevyøe¹ený',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosím odpovezte tento listek k návratu normalniho zobrazeni front!',
      'Please contact your admin' => 'Pros¡m  kontaktujte administrátora',
      'please do not edit!' => 'Prosim neupravovat!',
      'possible' => 'mozné',
      'QueueView' => 'pohled na frontu',
      'reject' => 'odmitnuto',
      'replace with' => 'nahrazeno s ',
      'Reset' => 'Reset',
      'Salutation' => 'osloveni',
      'Session has timed out. Please log in again.' => 'Uplynul èas pro sezeni.Prosim o opìtovné pøihlá¹ení.',
      'Signature' => 'Podpis',
      'Sorry' => 'Lituji',
      'Stats' => 'Statistika',
      'Subfunction' => 'subfunkce',
      'submit' => 'potvrdit',
      'submit!' => 'Potvrdit!',
      'system' => 'System',
      'Take this User' => 'Vezmi tohoto u¾ivatele',
      'Text' => '',
      'The recommended charset for your language is %s!' => 'Doporucena znakova sada  pro Vas jazyk je %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Není uèet s timto pøihla¹ovacím jménem.',
      'Timeover' => 'Èas vypr¹el',
      'top' => 'nejvy¹¹í',
      'update' => 'ulo¾',
      'update!' => 'Ulo¾!',
      'User' => 'U¾ivatel',
      'Username' => 'Jmeno u¾ivatele',
      'Valid' => 'Platny',
      'Warning' => 'Varovani',
      'Welcome to OTRS' => 'Vitejte v OTRS',
      'Word' => 'Svet',
      'wrote' => 'napsal',
      'yes' => 'ano',
      'Yes' => 'Ano',
      'Please go away!' => 'Prosim be¾te pryè!',
      'You got new message!' => 'Máte novou zprávu!',
      'You have %s new message(s)!' => 'Máte %s nov²ch zpráv!',
      'You have %s reminder ticket(s)!' => 'Mate %s upozornìní na zprávy!',

    # Template: AAAMonth
      'Apr' => '',
      'Aug' => '',
      'Dec' => '',
      'Feb' => '',
      'Jan' => '',
      'Jul' => '',
      'Jun' => '',
      'Mar' => '',
      'May' => '',
      'Nov' => '',
      'Oct' => '',
      'Sep' => '',

    # Template: AAAPreferences
      'Closed Tickets' => 'uzavrene dotazy',
      'Custom Queue' => 'ctene fronty',
      'Follow up notification' => 'notifikace pri zmìne poøízení klientem',
      'Frontend' => 'vzhled',
      'Mail Management' => 'E-mail Management',
      'Move notification' => 'Notikace pri pøesunu do jiné fronty',
      'New ticket notification' => 'Notifikace pri novém listku',
      'Other Options' => 'Ostatni nastaveni',
      'Preferences updated successfully!' => 'Nastaven¡ bylo ulo¾eno!',
      'QueueView refresh time' => 'frekvence obnovení obsahu fronty',
      'Select your default spelling dictionary.' => 'vyber slovnik výslovnosti.',
      'Select your frontend Charset.' => 'vyber znakovou sadu.',
      'Select your frontend language.' => 'vyber jazyka rozhrani.',
      'Select your frontend QueueView.' => 'vyber zpùsob pohledu na frontu.',
      'Select your frontend Theme.' => 'vyber tematu.',
      'Select your QueueView refresh time.' => 'nastaveni obnoveni zobrazen¡ fronty.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Po¹li mi notifikaci, pokud zákazník pøipi¹e poznámku a jsem vlastnikem ticketu.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Po¹li notifikaci, pokud je ticket pøesunut do mnou  kontrolovaných front.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Po¹li notifikaci, pokud je ticket odemknut systémem',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Po¹li notifikaci, pokud je novy listek mnou kontrolovanych frontách.',
      'Show closed tickets.' => 'uka¾ uzavøené lístky ',
      'Spelling Dictionary' => 'Slovník výslovnosti',
      'Ticket lock timeout notification' => 'notifikace pøi vypr¹ení zámku',

    # Template: AAATicket
      '1 very low' => '1 velmi nízká',
      '2 low' => '2 nízká',
      '3 normal' => '3 normální',
      '4 high' => '4 vysoká',
      '5 very high' => '5 velmi vysoká',
      'Action' => 'Akce',
      'Age' => 'Vìk',
      'Article' => 'Artikl',
      'Attachment' => 'Pøíloha',
      'Attachments' => 'Pøílohy',
      'Bcc' => '',
      'Bounce' => '',
      'Cc' => '',
      'Close' => 'Zavøít',
      'closed successful' => 'Uplné uzavøení',
      'closed unsuccessful' => 'neuplné uzavøení',
      'Compose' => 'Navrhnout',
      'Created' => 'Vytvoøeno',
      'Createtime' => 'Vytvoøeno v',
      'email' => 'E-Mail',
      'eMail' => 'E-Mail',
      'email-external' => 'extrní email',
      'email-internal' => 'interní email',
      'Forward' => 'pøeposlat',
      'From' => 'Od',
      'high' => 'Vysoká',
      'History' => 'Historie',
      'If it is not displayed correctly,' => 'Pokud to není zobrazeno korektnì,',
      'lock' => 'Zamknout',
      'Lock' => 'Zámek',
      'low' => 'nízká',
      'Move' => 'Pøesunout',
      'new' => 'nové',
      'normal' => 'normální',
      'note-external' => 'Poznámka pro externí',
      'note-internal' => 'Poznámka pro interní',
      'note-report' => 'Poznámka pro report',
      'open' => 'otervøít',
      'Owner' => 'Vlastník',
      'Pending' => 'nevyøe¹en²',
      'pending auto close+' => 'oèekávané automatické uzavøení +',
      'pending auto close-' => 'oèekávané automatické uzavøení -',
      'pending reminder' => 'oèekavané pøipomínání',
      'phone' => 'Telefon',
      'plain' => 'prostý',
      'Priority' => 'Priorita',
      'Queue' => 'Fronta',
      'removed' => 'odstranìno',
      'Sender' => 'Odesilatel',
      'sms' => '',
      'State' => 'Status',
      'Subject' => 'pøedmìt',
      'This is a' => 'To je',
      'This is a HTML email. Click here to show it.' => 'To je  HTML email. zde tuknete pro zobrazení.',
      'This message was written in a character set other than your own.' => 'Tato zpráva byla napsána v znakové sadì odli¹né od va¹í.',
      'Ticket' => 'Listek',
      'To' => 'Komu',
      'to open it in a new window.' => 'otevøit v novém oknì',
      'unlock' => 'odemknuto',
      'Unlock' => 'Odemknout',
      'very high' => 'velmi vysoká',
      'very low' => 'velmi nízká',
      'View' => 'Zobrazit',
      'webrequest' => 'Pozadavek z webu',
      'Zoom' => 'Zvìt¹it',

    # Template: AAAWeekDay
      'Fri' => 'Fre',
      'Mon' => 'Mon',
      'Sat' => 'Sam',
      'Sun' => 'Son',
      'Thu' => 'Don',
      'Tue' => 'Die',
      'Wed' => 'Mit',

    # Template: AdminAttachmentForm
      'Add attachment' => 'Pøidat pøílohu',
      'Attachment Management' => 'Management pøíloh',
      'Change attachment settings' => 'Zmenit nastavení pøíloh',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Pøidat automatickou odpovìd',
      'Auto Response From' => 'Automatická odpovìd od',
      'Auto Response Management' => 'Management automatických odpovìdí',
      'Change auto response settings' => 'Zmenit nastaven¡ automatických odpovìdí',
      'Charset' => 'Znaková sada',
      'Note' => 'Poznámka',
      'Response' => 'Odpovìd',
      'to get the first 20 character of the subject' => 'K získání prvních 20 znaku z pøedmìtu zadejte',
      'to get the first 5 lines of the email' => 'K získání prvních 5 øádkù z emailu zadejte',
      'to get the from line of the email' => 'K získání øádku z emalu zadejte',
      'to get the realname of the sender (if given)' => 'K získání jména (pokud je zadáno)',
      'to get the ticket id of the ticket' => 'K získání id ticketu',
      'to get the ticket number of the ticket' => 'K získání èísla ticketu',
      'Type' => 'Typ',
      'Useable options' => 'Pou¾itelné volby',

    # Template: AdminCharsetForm
      'Add charset' => 'Pøidat znakovou sadu',
      'Change system charset setting' => 'Zmenit systemovou znakovou sadu',
      'System Charset Management' => 'Nastavení Systémové znakové sady',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Pøidat zákazníka',
      'Change customer user settings' => 'Zmìnit zakaznikovo nastavení',
      'Customer User Management' => 'Nastavení zákazn¡ka',
      'Update customer user' => 'Ulo¾it zákazn¡ka',
      'Customer user will be needed to to login via customer panels.' => 'zákazník by mìl pou¾ívat zákaznické  rozhrani',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Administrátorùv email',
      'Body' => 'Tìlo',
      'OTRS-Admin Info!' => 'Info o  administratorovi',
      'Permission' => 'Oprávnìní',
      'Recipents' => 'Adresáti',
      'send' => 'Odeslat',

    # Template: AdminEmailSent
      'Message sent to' => 'Zpráva byla poslána na',

    # Template: AdminGroupForm
      'Add group' => 'Pøidat skupinu',
      'Change group settings' => 'Zmìnit nastavení skupiny',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'vytvoøte nové skupiny k nastavení pøístupových práv rùzných skupin pracovníkù(pøíklad obchodní oddìlení, správa sítí,  správa firewallu , ...).',
      'Group Management' => 'Nastavení skupin',
      'It\'s useful for ASP solutions.' => 'Je to u¾iteèné pro asp and IPS øe¹ení.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => '\'admin\' skupina je pro pøístup k administraci a \'stats\'skupina je pro pøistup ke statistice.',

    # Template: AdminLog
      'System Log' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => '',
      'AgentFrontend' => 'Agent-plocha',
      'Attachment <-> Response' => 'pøíloha <-> Reakce',
      'Auto Response <-> Queue' => 'auto odpovìd <-> Fronty',
      'Auto Responses' => 'automatické odpovìdi',
      'Charsets' => 'Znakové sady',
      'Customer User' => 'Info o zákazníkovi',
      'Email Addresses' => 'E-Mail-Adresa',
      'Groups' => 'Skupiny',
      'Logout' => 'Odhlásit',
      'Misc' => 'Rùzné',
      'POP3 Account' => 'POP3-ùèet',
      'Responses' => 'Reakce',
      'Responses <-> Queue' => 'reakce <-> fronty',
      'Select Box' => 'SQL box',
      'Session Management' => 'nastavení sezení',
      'Status' => '',
      'System' => '',
      'User <-> Groups' => 'u¾ivatel <-> Skupina',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Pøidat POP3-ùèet',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'V¹echny pøíchozí emaily s jednoho uètu budou  odeslany do  vybrané fronty!',
      'Change POP3 Account setting' => 'Zmìnit POP3-Konto',
      'Dispatching' => 'Odesílání',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Pokud je Va¹e konto duvìryhodné, mù¾ete pou¾ívat specialni  hlavièky!',
      'Login' => 'Pøihlásit',
      'POP3 Account Management' => 'POP3-Konten-nastavení',
      'Trusted' => 'Dùvìryhodný',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Fronta <-> automatické odpovìdi',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = ¾ádná eskalace ',
      '0 = no unlock' => '0 = ¾ádný unlock',
      'Add queue' => 'Pøidat frontu',
      'Change queue settings' => 'Zmìnit nastavení fronty',
      'Customer Move Notify' => 'Notifikace zákazníka pøi pøesunu ',
      'Customer Owner Notify' => 'Notifikace zákazníka pøi zmìne vlastníka',
      'Customer State Notify' => 'Notifikace zákazníka pøi zmìne stavu',
      'Escalation time' => 'Eskalaèní èas',
      'Follow up Option' => '',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Pokud je listek uzavøen² a zákazník po¹le poznámku , listek bude uzamknut pro starého vlastníka.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Pokud listek nebude zodpovezen v daném èase , v fronte bude zobrazen pouze tento listek.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Pokud agent zamkne liste a on nebo  on neodpoví v daném èase , lístek bude automaticky odemèen a bude èitelný i jinými agenty.',
      'Key' => 'Klíè',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS po¹le Info-E-Maily zákazníkovi pokud je listek pøesunut.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS po¹le Info-E-Maily zákazníkovi pokud je vlastník lístku zmìnen.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS po¹le Info-E-Maily zákazníkovi pokud je status lístku zmìnen.',
      'Queue Management' => 'Nastavení fronty',
      'Sub-Queue of' => 'sub fronta z',
      'Systemaddress' => 'Systémová adresa',
      'The salutation for email answers.' => 'Oslovení pro odpovìdi.',
      'The signature for email answers.' => 'Podpis pro odpovìdi.',
      'Ticket lock after a follow up' => 'Lístek zamknout po odpovìdi zákazníka',
      'Unlock timeout' => 'èas odemknutí zámku',
      'Will be the sender address of this queue for email answers.' => '',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Zmìnit %s nastavení',
      'Std. Responses <-> Queue Management' => 'Stand. odpovìdi <-> Fronta Management',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Odpovìd',
      'Change answer <-> queue settings' => 'Zmìnit odpoved <-> Nastavení fronty',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Std. odpovìdi <-> Std. management pøíloh',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Zmìnit Odpovìd <-> Nastavení pøíloh',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'odpovìd je standartní text pro rychlej¹í psaní reakci s standartním textem zákazníkùm.',
      'Add response' => 'Pøidat odpovìd',
      'Change response settings' => 'Zmeni Odpovedi',
      'Don\'t forget to add a new response a queue!' => 'Nezapomente pøiøadit odpoved k fronte!',
      'Response Management' => 'Nastavení  standartních odpovìdí',

    # Template: AdminSalutationForm
      'Add salutation' => 'Pøidat pozdrav',
      'Change salutation settings' => 'Zmìnit pozdravy',
      'customer realname' => 'Zákazníkova jméno',
      'for agent firstname' => 'pro agentovo jméno',
      'for agent lastname' => 'pro agentovo pøíjmeni',
      'for agent login' => 'pro agentùv login',
      'for agent user id' => 'pro agentovo ID',
      'Salutation Management' => 'Nastavení pozdravù',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. øádkù',

    # Template: AdminSelectBoxResult
      'Limit' => '',
      'Select Box Result' => 'SQL Box výsledek',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'v¹echny sezení zabít',

    # Template: AdminSessionTable
      'kill session' => 'zabít sesion',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Add signature' => 'Pøidat Podpis',
      'Change signature settings' => 'Zmenit Podpis',
      'Signature Management' => 'Nastavení Podpisù',

    # Template: AdminStateForm
      'Add state' => 'Pøidat stav',
      'Change system state setting' => 'Zmìnit stav',
      'State Type' => 'Typ Stavu',
      'System State Management' => 'Nastavení Stavù',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Pøidat E-Mail-Adresu',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Ve¹keré  pøíchozí emaily z tohot emailu budou ulo¾eny v vybrané frontì.',
      'Change system address setting' => 'Zmenit E-Mail-Adresu',
      'Email' => 'E-Mail',
      'Realname' => '',
      'System Email Addresses Management' => 'Nastavení E-Mail-Adres',

    # Template: AdminUserForm
      'Add user' => 'Pøidat u¾ivatele',
      'Change user settings' => 'Zmìnit nastavení u¾ivatele',
      'Don\'t forget to add a new user to groups!' => 'Nezapomente nastavit u¾ivateli skupiny!',
      'Firstname' => 'Køestní jméno',
      'Lastname' => 'Pøíjmeni',
      'User Management' => 'Nastavení u¾ivatelù',
      'User will be needed to handle tickets.' => '',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => '',
      'User <-> Group Management' => '',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => '',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'zpráva by mìla mít adresáta!',
      'Bounce ticket' => '',
      'Bounce to' => '',
      'Inform sender' => '',
      'Next ticket state' => '',
      'Send mail!' => '',
      'You need a email address (e. g. customer@example.com) in To:!' => '',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => '',

    # Template: AgentClose
      ' (work units)' => 'cas',
      'A message should have a subject!' => 'Zpráva by mìla mít pøedmìt!',
      'Close ticket' => '',
      'Close type' => '',
      'Close!' => 'Zavøít!',
      'Note Text' => '',
      'Note type' => '',
      'Options' => '',
      'Spell Check' => '',
      'Time units' => '',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => '',
      'Attach' => '',
      'Compose answer for ticket' => '',
      'for pending* states' => '',
      'Is the ticket answered' => '',
      'Pending Date' => '',

    # Template: AgentCustomer
      'Back' => '',
      'Change customer of ticket' => '',
      'CustomerID' => '',
      'Search Customer' => '',
      'Set customer user and customer id of a ticket' => '',

    # Template: AgentCustomerHistory
      'Customer history' => '',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerMessage
      'Follow up' => '',
      'Next state' => '',

    # Template: AgentCustomerView
      'Customer Data' => '',

    # Template: AgentForward
      'Article type' => '',
      'Date' => 'Datum',
      'End forwarded message' => '',
      'Forward article of ticket' => '',
      'Forwarded message from' => '',
      'Reply-To' => '',

    # Template: AgentFreeText
      'Change free text of ticket' => '',
      'Value' => '',

    # Template: AgentHistoryForm
      'History of' => '',

    # Template: AgentMailboxNavBar
      'All messages' => '',
      'down' => '',
      'Mailbox' => '',
      'New' => '',
      'New messages' => 'Nové zprávy',
      'Open' => 'Otevøít',
      'Open messages' => '',
      'Order' => '',
      'Pending messages' => '',
      'Reminder' => '',
      'Reminder messages' => '',
      'Sort by' => '',
      'Tickets' => '',
      'up' => '',

    # Template: AgentMailboxTicket

    # Template: AgentMove
      'Move Ticket' => '',
      'New Queue' => '',
      'New user' => '',

    # Template: AgentNavigationBar
      'Locked tickets' => '',
      'new message' => '',
      'PhoneView' => '',
      'Preferences' => '',
      'Utilities' => '',

    # Template: AgentNote
      'Add note to ticket' => '',
      'Note!' => '',

    # Template: AgentOwner
      'Change owner of ticket' => '',
      'Message for new Owner' => '',

    # Template: AgentPending
      'Pending date' => '',
      'Pending type' => '',
      'Pending!' => '',
      'Set Pending' => '',

    # Template: AgentPhone
      'Customer called' => '',
      'Phone call' => '',
      'Phone call at %s' => '',

    # Template: AgentPhoneNew
      'Clear From' => '',
      'create' => '',
      'new ticket' => '',

    # Template: AgentPlain
      'ArticleID' => '',
      'Plain' => '',
      'TicketID' => '',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => '',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => '',
      'New password' => '',
      'New password again' => '',

    # Template: AgentPriority
      'Change priority of ticket' => '',
      'New state' => '',

    # Template: AgentSpelling
      'Apply these changes' => '',
      'Discard all changes and return to the compose screen' => '',
      'Return to the compose screen' => '',
      'Spell Checker' => '',
      'spelling error(s)' => '',
      'The message being composed has been closed.  Exiting.' => '',
      'This window must be called from compose window' => '',

    # Template: AgentStatusView
      'D' => '',
      'of' => '',
      'Site' => '',
      'sort downward' => '',
      'sort upward' => '',
      'Ticket Status' => '',
      'U' => '',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => '',
      'Ticket unlock!' => '',

    # Template: AgentTicketPrint
      'by' => '',

    # Template: AgentTicketPrintHeader
      'Accounted time' => '',
      'Escalation in' => '',
      'printed by' => '',

    # Template: AgentUtilSearch
      'Article free text' => '',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => '',
      'search' => '',
      'search (e. g. 10*5155 or 105658*)' => '',
      'Ticket free text' => '',
      'Ticket Search' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => '',
      'Customer history search (e. g. "ID342425").' => '',
      'No * possible!' => '',

    # Template: AgentUtilSearchNavBar
      'Results' => '',
      'Total hits' => '',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All closed tickets' => '',
      'All open tickets' => '',
      'closed tickets' => '',
      'open tickets' => '',
      'or' => '',
      'Provides an overview of all' => '',
      'So you see what is going on in your system.' => '',
      'Closed' => '',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => '',
      'Your own Ticket' => '',

    # Template: AgentZoomAnswer
      'Compose Answer' => '',
      'Contact customer' => '',
      'phone call' => '',

    # Template: AgentZoomArticle
      'Split' => '',

    # Template: AgentZoomBody
      'Change queue' => '',

    # Template: AgentZoomHead
      'Free Fields' => '',
      'Print' => '',

    # Template: AgentZoomStatus

    # Template: CustomerCreateAccount
      'Create Account' => '',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => 'Kontakt',
      'Home' => '',
      'Online-Support' => '',
      'Products' => 'Produkt',
      'Support' => '',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => '',
      'Request new password' => '',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => '',
      'My Tickets' => '',
      'New Ticket' => '',
      'Ticket-Overview' => '',
      'Welcome %s' => '',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => '',

    # Template: Footer
      'Top of Page' => '',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => '',
      'Drop Database' => '',
      'Finished' => '',
      'System Settings' => '',
      'Web-Installer' => '',

    # Template: InstallerFinish
      'Admin-User' => '',
      'After doing so your OTRS is up and running.' => '',
      'Have a lot of fun!' => '',
      'Restart your webserver' => '',
      'Start page' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Your OTRS Team' => '',

    # Template: InstallerLicense
      'accept license' => '',
      'don\'t accept license' => '',
      'License' => '',

    # Template: InstallerStart
      'Create new database' => '',
      'DB Admin Password' => '',
      'DB Admin User' => '',
      'DB Host' => '',
      'DB Type' => '',
      'default \'hot\'' => '',
      'Delete old database' => '',
      'next step' => '',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => '',
      'OTRS DB Password' => '',
      'OTRS DB User' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      '(Email of the system admin)' => '',
      '(Full qualified domain name of your system)' => '',
      '(Logfile just needed for File-LogModule!)' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => '',
      '(Used log backend)' => '',
      '(Used ticket number format)' => '',
      'CheckMXRecord' => '',
      'Default Charset' => '',
      'Default Language' => '',
      'Logfile' => '',
      'LogModule' => '',
      'Organization' => '',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => '',
      'Webfrontend' => '',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => '',

    # Template: Notify
      'Info' => '',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader

    # Template: QueueView
      'All tickets' => '',
      'Queues' => '',
      'Tickets available' => '',
      'Tickets shown' => '',

    # Template: SystemStats
      'Graphs' => '',

    # Template: Test
      'OTRS Test Page' => '',

    # Template: TicketEscalation
      'Ticket escalation!' => '',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => '',

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '',
      '(Click here to add a queue)' => '',
      '(Click here to add a response)' => '',
      '(Click here to add a salutation)' => '',
      '(Click here to add a signature)' => '',
      '(Click here to add a system email address)' => '',
      '(Click here to add a customer user)' => '',
      '(Click here to add a user)' => '',
      '(Click here to add an auto response)' => '',
      '(Click here to add charset)' => '',
      '(Click here to add language)' => '',
      '(Click here to add state)' => '',
      '(E-Mail of the system admin)' => '',
      'A message should have a From: recipient!' => '',
      'Add language' => '',
      'Backend' => '',
      'BackendMessage' => '',
      'Bottom of Page' => '',
      'Change system language setting' => '',
      'Create' => '',
      'CustomerUser' => '',
      'FAQ' => '',
      'Fulltext search' => '',
      'Handle' => '',
      'In Queue' => '',
      'New ticket via call.' => '',
      'Search in' => '',
      'Set customer id of a ticket' => '',
      'Show all' => '',
      'System Language Management' => '',
      'Ticket limit:' => '',
      'Time till escalation' => '',
      'Update auto response' => '',
      'Update charset' => '',
      'Update group' => '',
      'Update language' => '',
      'Update queue' => '',
      'Update response' => '',
      'Update salutation' => '',
      'Update signature' => '',
      'Update state' => '',
      'Update system address' => '',
      'Update user' => 'uzivatel aktualizovan',
      'With Priority' => 'S prioritou',
      'With State' => 'S Stavem',
      'You have to be in the admin group!' => 'Vy nejste v skupine s opravnenim na administraci!',
      'You have to be in the stats group!' => 'Vy nejste v skupine s opravnenim na statistiku!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'v poli od potrebujeme zakaznikuv email(priklad kunde@beispiel.de) !',
      'auto responses set' => 'Automaticka odpoved aktivovana',
      'invalid-temporarily' => 'docasne neplatny',
      'store' => 'Speichern',
      'tickets' => 'Listky',
      'valid' => 'platny',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
