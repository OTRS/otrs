# --
# Kernel/Language/cz.pm - provides cz language translation
# Copyright (C) 2003 Lukas Vicanek alias networ <lulka at centrum dot cz>
# --
# $Id: cz.pm,v 1.7 2004-02-10 00:18:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::cz;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Feb  3 00:41:12 2004 by 

    # possible charsets
    $Self->{Charset} = ['windows-1250', ];
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
      '(Click here to add)' => '',
      '10 minutes' => '10 minut',
      '15 minutes' => '15 minut',
      'AddLink' => 'Pøidat odkaz',
      'Admin-Area' => 'Administraèní zóna',
      'agent' => 'operator',
      'Agent-Area' => '',
      'all' => 'vše',
      'All' => 'Vše',
      'Attention' => 'Upozornìní',
      'before' => '',
      'Bug Report' => 'Upozornìní na chybu',
      'Cancel' => 'Zrušit',
      'change' => 'zmìnit',
      'Change' => 'Zmìnit',
      'change!' => 'Zmìnit!',
      'click here' => 'kliknìte zde',
      'Comment' => 'Komentáø',
      'Customer' => 'Klient',
      'customer' => 'Klient',
      'Customer Info' => 'Informace o klientovi',
      'day' => 'den',
      'day(s)' => '',
      'days' => 'dní',
      'description' => 'popis',
      'Description' => 'Popis',
      'Dispatching by email To: field.' => 'Odbavení podle pole KOMU:.',
      'Dispatching by selected Queue.' => 'Odbavení podle vybrané fronty.',
      'Don\'t show closed Tickets' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nepracujte s uètem èíslo 1 (systémový úèet)! Vytvoøte prosím nový',
      'Done' => 'Hotovo',
      'end' => 'konec',
      'Error' => 'Chyba',
      'Example' => 'Pøíklad',
      'Examples' => 'Pøíklady',
      'Facility' => 'Funkce',
      'FAQ-Area' => '',
      'Feature not active!' => 'Funkce je neaktivní!',
      'go' => 'jít',
      'go!' => 'jdi!',
      'Group' => 'Skupina',
      'Hit' => 'Pøístup',
      'Hits' => 'Prístupù',
      'hour' => 'hodina',
      'hours' => 'hodin',
      'Ignore' => 'Ignorovat',
      'invalid' => 'chybný',
      'Invalid SessionID!' => 'Chybné ID!',
      'Language' => 'Jazyk',
      'Languages' => 'Jazyky',
      'last' => '',
      'Line' => 'Linka',
      'Lite' => 'Omezená',
      'Login failed! Your username or password was entered incorrectly.' => 'Chyba v pøíhlášení! Špatný uživatelský uèet nebo heslo.',
      'Logout successful. Thank you for using OTRS!' => 'Odlogování probìhlov poøádku. Dìkujeme za užívání OTRS!',
      'Message' => 'Zpráva',
      'minute' => 'minuta',
      'minutes' => 'minut',
      'Module' => 'Modul',
      'Modulefile' => 'Modulový soubor',
      'month(s)' => '',
      'Name' => 'Jméno',
      'New Article' => '',
      'New message' => 'Nová zpráva',
      'New message!' => 'Nová zpráva!',
      'No' => 'Ne',
      'no' => 'ne',
      'No entry found!' => 'Nic nebylo nalezeno!',
      'No suggestions' => 'Žádná nabídka nenalezena',
      'none' => 'žádné',
      'none - answered' => 'žádný - odpovìzeno',
      'none!' => 'žádný!',
      'Normal' => '',
      'Off' => 'Vypnuto',
      'off' => 'vypnuto',
      'On' => 'Zapnuto',
      'on' => 'zapnuto',
      'Password' => 'Heslo',
      'Pending till' => 'Nevyøízený do',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosíme odpovezte na tento tiket(y) pro návrat do pøehledu zpráv!',
      'Please contact your admin' => 'Kontaktujte prosím Vašeho administrátora',
      'please do not edit!' => 'prosíme neupravovat!',
      'Please go away!' => '',
      'possible' => 'možný',
      'Preview' => '',
      'QueueView' => 'Pøehled zpráv',
      'reject' => 'zrušen',
      'replace with' => 'nahradit',
      'Reset' => 'Reset',
      'Salutation' => 'Text',
      'Session has timed out. Please log in again.' => 'Session vypršelo. Pøihlaste se znova.',
      'Show closed Tickets' => '',
      'Signature' => 'Podpis',
      'Sorry' => 'Omluva',
      'Stats' => 'Statistiky',
      'Subfunction' => 'Podfunkce',
      'submit' => 'Odeslat',
      'submit!' => 'odelsat!',
      'system' => 'system',
      'Take this User' => 'Vzít tohoto uživatele',
      'Text' => 'Text',
      'The recommended charset for your language is %s!' => 'Doporuèená znaková sada pro Váš jazyk je  %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Neexistuje úèet s tímto jménem.',
      'Timeover' => 'Èas vypršel',
      'To: (%s) replaced with database email!' => '',
      'top' => 'nahoru',
      'update' => 'obnovit',
      'Update' => '',
      'update!' => 'obnovit!',
      'User' => 'Uživatelé',
      'Username' => 'Jméno uživatele',
      'Valid' => 'Platnost',
      'Warning' => 'Upozornìní',
      'week(s)' => '',
      'Welcome to OTRS' => 'Vítejte v OTRS',
      'Word' => 'slovo',
      'wrote' => 'napsal',
      'year(s)' => '',
      'yes' => 'ano ',
      'Yes' => 'Ano ',
      'You got new message!' => 'Máte novou zprávu!',
      'You have %s new message(s)!' => 'Máte %s novou zprávu (zprávy)!',
      'You have %s reminder ticket(s)!' => 'Máte %s zpravu (zprávy) k upozornìní',

    # Template: AAAMonth
      'Apr' => 'Dub',
      'Aug' => 'Srp',
      'Dec' => 'Pro',
      'Feb' => 'Uno',
      'Jan' => 'Led',
      'Jul' => 'Èer',
      'Jun' => 'Èrv',
      'Mar' => 'Bøe',
      'May' => 'Kvì',
      'Nov' => 'Lis',
      'Oct' => 'Øíj',
      'Sep' => 'Záø',

    # Template: AAAPreferences
      'Closed Tickets' => 'Uzavøené Tikety',
      'Custom Queue' => 'Vlastní pøehled',
      'Follow up notification' => 'Následující zpráva',
      'Frontend' => 'Rozhraní',
      'Mail Management' => 'Správa emailù',
      'Max. shown Tickets a page in Overview.' => '',
      'Max. shown Tickets a page in QueueView.' => '',
      'Move notification' => 'Pøesunout zprávu',
      'New ticket notification' => 'Nový Tiket',
      'Other Options' => 'Další nastavení',
      'PhoneView' => 'Vložit Tiket',
      'Preferences updated successfully!' => 'Nastavení probìhlo uspìšnì!',
      'QueueView refresh time' => 'Èas obnovení pøehledu zpráv',
      'Screen after new ticket' => '',
      'Select your default spelling dictionary.' => 'Vyberte si slovník',
      'Select your frontend Charset.' => 'Vyberte si znakovou sadu.',
      'Select your frontend language.' => 'Vyberte si jazyk.',
      'Select your frontend QueueView.' => 'Vyberte si typ pøehledu zpráv.',
      'Select your frontend Theme.' => 'Vyberte si vzhled.',
      'Select your QueueView refresh time.' => 'Vyberte si èas obnovy pøehledu zpráv.',
      'Select your screen after creating a new ticket.' => '',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Poslat zprávu, pokud klient pošle následující zprávu a já jsem správce jeho Ticketu.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Poslat zprávu, pokud je Ticket pøesunut do Vlastního pøehledu.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Poslat zprávu, pokud je Ticket odemknut systémem.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Poslat zprávu, pokud je nový Tiket v mém Vlastním pøehledu.',
      'Show closed tickets.' => 'Zobrazit uzavøené Tikety.',
      'Spelling Dictionary' => 'Slovník',
      'Ticket lock timeout notification' => 'Upozornìní na vypršení èasu u zamknutého Tiketu',
      'TicketZoom' => '',

    # Template: AAATicket
      '1 very low' => '1 velice nízká',
      '2 low' => '2 nízká',
      '3 normal' => '3 normální',
      '4 high' => '4 vysoká',
      '5 very high' => '5 velice vysoká',
      'Action' => 'Akce',
      'Age' => 'Doba',
      'Article' => 'Artikl',
      'Attachment' => 'Pøíloha',
      'Attachments' => 'Pøílohy',
      'Bcc' => 'Bcc',
      'Bounce' => 'Pøesun',
      'Cc' => 'Cc',
      'Close' => 'Zavøít',
      'closed successful' => 'zavøeno - vyrešeno',
      'closed unsuccessful' => 'zavøeno - nevyøešeno',
      'Compose' => 'Napsat',
      'Created' => 'Vytvoøeno',
      'Createtime' => 'Èas',
      'email' => 'eMail',
      'eMail' => '',
      'email-external' => 'email externí',
      'email-internal' => 'email interní',
      'Forward' => 'Pøeposlat',
      'From' => 'Od',
      'high' => 'vysoké',
      'History' => 'Historie',
      'If it is not displayed correctly,' => 'Pokud není zobrazení v poøádku,',
      'lock' => 'zamknuto',
      'Lock' => 'Zamknuto',
      'low' => 'nízký',
      'Move' => 'Pøesunout',
      'new' => 'nová',
      'normal' => 'normalní',
      'note-external' => 'Poznámka externí',
      'note-internal' => 'Poznámka Interní',
      'note-report' => 'Poznámka',
      'open' => 'otevøeno',
      'Owner' => 'Vlastník',
      'Pending' => 'Ve vyøizování',
      'pending auto close+' => 'vyøizovaní - auto close+',
      'pending auto close-' => 'vyøizování - auto close-',
      'pending reminder' => 'upomínka ve vyøizování',
      'phone' => 'Telefon',
      'plain' => '',
      'Priority' => 'Priorita ',
      'Queue' => 'Øada',
      'removed' => 'smazán',
      'Sender' => 'Odesílatel',
      'sms' => '',
      'State' => 'Status',
      'Subject' => 'Pøedmìt',
      'This is a' => 'To je',
      'This is a HTML email. Click here to show it.' => 'Toto je HTML email. Kliknìte zde pro zobrazení.',
      'This message was written in a character set other than your own.' => 'Tato zpráva byla napsána v jiné znakové sadì.',
      'Ticket' => '',
      'Ticket "%s" created!' => '',
      'To' => 'Komu',
      'to open it in a new window.' => 'pro otevøení v novém oknì.',
      'unlock' => 'odemknout',
      'Unlock' => 'Odemknout',
      'very high' => 'velmi vysoká',
      'very low' => 'velmi nízká',
      'View' => 'Náhled',
      'webrequest' => 'požadavek pøes web',
      'Zoom' => 'Detaily',

    # Template: AAAWeekDay
      'Fri' => 'Pá',
      'Mon' => 'Po',
      'Sat' => 'So',
      'Sun' => 'Ne',
      'Thu' => 'Èt',
      'Tue' => 'Út',
      'Wed' => 'St',

    # Template: AdminAttachmentForm
      'Add' => '',
      'Attachment Management' => 'Správa pøíloh',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Pøidat automatickou odpovìï',
      'Auto Response From' => 'Automatická odpovìï OD',
      'Auto Response Management' => 'Správa automatických odpovìdí',
      'Change auto response settings' => 'Zmìnit nastavení automatických odpovedí',
      'Note' => 'Poznámka',
      'Response' => 'Odpovìï',
      'to get the first 20 character of the subject' => 'pro získáni prvních 20 znaku v pøedmìtu',
      'to get the first 5 lines of the email' => 'pro získání prvních 5 rádkù z emailu',
      'to get the from line of the email' => 'pro získaní OD z emailu',
      'to get the realname of the sender (if given)' => 'pro získaní pravého jména odesílatele (pokud je urèen)',
      'to get the ticket id of the ticket' => 'pro získání ID Tiketu',
      'to get the ticket number of the ticket' => 'pro získání èísla Ticketu',
      'Type' => 'Typ',
      'Useable options' => 'Nastavení',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Správa klientù',
      'Customer user will be needed to to login via customer panels.' => 'Klient se musí pøihlasít pomocí klientského nastavení.',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Zmìnit nastavení %s',
      'Customer User <-> Group Management' => '',
      'Full read and write access to the tickets in this group/queue.' => '',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => '',
      'Permission' => 'Práva',
      'Read only access to the ticket in this group/queue.' => '',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => '',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Zmenit uživatele <-> nastavení skupin',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email Adminù',
      'Body' => 'Text',
      'OTRS-Admin Info!' => 'OTRS-Admin info',
      'Recipents' => '',
      'send' => '',

    # Template: AdminEmailSent
      'Message sent to' => 'Zpráva odeslána ',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Vytvoøit nové skupiny k lepšímu pøehledu a nastavení práv pro rozdílné skupiny operátorù (jako oddìlení fakturace, prodeje, podpory,...).',
      'Group Management' => 'Správa skupin',
      'It\'s useful for ASP solutions.' => 'Používané pro ASP øešení',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Skupina administrátorù má pøístup do statistik a administraèní zóny.',

    # Template: AdminLog
      'System Log' => 'System Log',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin Email',
      'Attachment <-> Response' => 'Pøíloha <-> Odpovìï',
      'Auto Response <-> Queue' => 'Automatická odpovìï <-> Øada',
      'Auto Responses' => 'Automatické odpovìdi',
      'Customer User' => 'Klienti',
      'Customer User <-> Groups' => '',
      'Email Addresses' => 'Emailové adresy',
      'Groups' => 'Skupiny',
      'Logout' => 'Odhlásit',
      'Misc' => 'Rùzné',
      'Notifications' => '',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => 'PostMaster POP3 úèet',
      'Responses' => 'Odpovìdi',
      'Responses <-> Queue' => 'Odpovìdi <-> Øada',
      'Select Box' => 'Výbìr funkcí',
      'Session Management' => 'Správa session',
      'Status' => 'Status',
      'System' => 'System',
      'User <-> Groups' => 'Uživatelé <-> Skupiny',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
      'Notification Management' => '',
      'Notifications are sent to an agent or a customer.' => '',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Všechny pøíchozí emaily s jedním úètem budou pøesmìrovány do vybrané øady!',
      'Dispatching' => 'Roztøídit',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Pokud je Váš uèet ovìøen, X-OTRS hlavièky (pro prioritu, ...) budou používány!',
      'Login' => '',
      'POP3 Account Management' => 'Správa POP3 úètù',
      'Trusted' => 'Ovìøit',

    # Template: AdminPostMasterFilterForm
      'Match' => '',
      'PostMasterFilter Management' => '',
      'Set' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Øada <-> automatické opovìdi',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = žádná eskalace (stupòování)',
      '0 = no unlock' => '0 = žádné odemknutí',
      'Customer Move Notify' => 'Zpráva pro klineta v pøípadì pøesunu',
      'Customer Owner Notify' => 'Zpráva pro klienta v pøípadì zmìny operátora',
      'Customer State Notify' => 'Zpráva pro klienta v prípadì zmìny statusu',
      'Escalation time' => 'Èas eskalace (stupòování)',
      'Follow up Option' => 'Následující - nastavení',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Pokud Ticket je uzavøen a klient pošle následující Ticket, bude pøesunut ke starému operátorovi.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Pokud Tiket nebude odpovezen v èase, pouze tento Tiket bude ukázán.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Pokud operátor uzamkne tiket a nebude na nìj odpovezeno bìhem tohoto èasu, Tiket bude odemknut automatocky. Tiket bude viditelná pro všechny operátory.',
      'Key' => 'Klíè',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS pošle zprávu klinetovi, pokud Tiket bude pøesunut.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS pošle zprávu klinetovi, pokud bude zmìnìn operátor..',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS pošle zprávu klientovi, pokud bude zmìnìn status.',
      'Queue Management' => 'Správa øad',
      'Sub-Queue of' => 'Podøada ',
      'Systemaddress' => 'Adresa systému',
      'The salutation for email answers.' => 'Oslovení pro emailové odpovìdi.',
      'The signature for email answers.' => 'Podpis pro emailové odpovìdi.',
      'Ticket lock after a follow up' => 'Zamknout Tiket po následující odpovìdi',
      'Unlock timeout' => 'Èas pro odemknutí',
      'Will be the sender address of this queue for email answers.' => 'Odesílatelova adresa bude pro odpovìdi via email.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Std. odpovìdi <-> Øada',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Odpovìï',
      'Change answer <-> queue settings' => 'Upravit odpovìï <-> nastavení øady',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Std. odpovìdi <-> Std. nastavení pøiloh',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Zmìnit odpovìdi <-> Nastavení pøíloh',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Odpovìïí je defaultní text, který píše rychlejší odpovìï (s pøeddefinovaným obsahem) klentùm.',
      'Don\'t forget to add a new response a queue!' => 'Nezapomeòte pøidat novou odpoveï do øady!',
      'Next state' => 'Dalsí status',
      'Response Management' => 'Správa odpovìdí',
      'The current ticket state is' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'pravé jméno klienta',
      'for agent firstname' => 'pro operátorovo køestní jméno',
      'for agent lastname' => 'pro operátoøovo pøíjmení',
      'for agent login' => 'pro operátorùv login',
      'for agent user id' => 'pro operátorùm ID',
      'Salutation Management' => 'Správa oslovení',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. poèet èádkù',

    # Template: AdminSelectBoxResult
      'Limit' => 'Limit',
      'Select Box Result' => 'Vyberte si výsledek',
      'SQL' => '',

    # Template: AdminSession
      'Agent' => '',
      'kill all sessions' => 'Zrušit všechny session',
      'Overview' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSessionTable
      'kill session' => 'Zrušit session',
      'SessionID' => 'ID session',

    # Template: AdminSignatureForm
      'Signature Management' => 'Správa podpisù',

    # Template: AdminStateForm
      'See also' => '',
      'State Type' => 'Typ statusu',
      'System State Management' => 'Správa statusù',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => '',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Všechny pøíchozí emaily s polem KOME budou zarazeby to vybrane øady!',
      'Email' => 'eMail',
      'Realname' => 'Pravé jméno',
      'System Email Addresses Management' => 'Správa adres',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Nezapomeòte pøidat operátora do skupin!',
      'Firstname' => 'Jméno',
      'Lastname' => 'Pøíjmení',
      'User Management' => 'Správa operátorù',
      'User will be needed to handle tickets.' => 'Operátor se bude zabývat Tikety.',

    # Template: AdminUserGroupChangeForm
      'create' => 'vytvoøit',
      'move_into' => '',
      'owner' => '',
      'Permissions to change the ticket owner in this group/queue.' => '',
      'Permissions to change the ticket priority in this group/queue.' => '',
      'Permissions to create tickets in this group/queue.' => '',
      'Permissions to move tickets into this group/queue.' => '',
      'priority' => '',
      'User <-> Group Management' => 'Uživatele <-> správa skupin',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => '',
      'Discard all changes and return to the compose screen' => 'Zrušit všechny zmìny a vrátit se k vytváøení',
      'Return to the compose screen' => 'Vrátit se k vytváøení',
      'Search' => '',
      'The message being composed has been closed.  Exiting.' => 'Zprávy musí být vytvoøeny, ještì pøed tím, než je zavøete.',
      'This window must be called from compose window' => 'Toto okno musí být voláno pouze z vytváøecího',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Zpráva by mìla obsahovat Komu: pøíjemce!',
      'Bounce ticket' => 'Pøedaný tiket',
      'Bounce to' => 'Pøedán',
      'Inform sender' => 'Informace o odesílateli',
      'Next ticket state' => 'Další status Tiketu',
      'Send mail!' => 'Poslat email!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'Je potøeba vložit emailovou adresu (napø. klient@email.cz) v poli Komu:!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Váš email s èíslem ticketu "<OTRS_TICKET>" byl pøedán "<OTRS_BOUNCE_TO>". Konktantujte se na této adrese pro další infromace.',

    # Template: AgentClose
      ' (work units)' => ' (jednotky práce)',
      'A message should have a body!' => '',
      'A message should have a subject!' => 'Zpráva by meìla mít pøedmìt!',
      'Close ticket' => 'Zavøene tikety',
      'Close type' => 'Typ uzavøený',
      'Close!' => 'Zavøený!',
      'Note Text' => 'Text poznámky',
      'Note type' => 'Typ poznámky',
      'Options' => 'Nastavení',
      'Spell Check' => 'Kontrola pravopisu',
      'Time units' => 'jednotky èasu',
      'You need to account time!' => 'Potøebujete úèet èasu!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Zpráva musí být skontrolovaná pravopisem!',
      'Attach' => 'Pøipojit',
      'Compose answer for ticket' => 'Vytvoøit odpovìï pro tento tiket',
      'for pending* states' => 'pro status nevyøízeno*',
      'Is the ticket answered' => 'Je na tiket odpovìzeno?',
      'Pending Date' => 'Èas v nevyøízení',

    # Template: AgentCustomer
      'Back' => 'Zpìt',
      'Change customer of ticket' => 'Zmìnit klienta tiketu',
      'CustomerID' => 'ID klienta',
      'Search Customer' => 'Vyhledat klienta',
      'Set customer user and customer id of a ticket' => 'Nastavit klienta k tomuto tiketu',

    # Template: AgentCustomerHistory
      'All customer tickets.' => '',
      'Customer history' => 'Historie klienta',

    # Template: AgentCustomerMessage
      'Follow up' => 'Následující',

    # Template: AgentCustomerView
      'Customer Data' => 'Data klienta',

    # Template: AgentForward
      'Article type' => 'Typ artiklu',
      'Date' => 'Datum',
      'End forwarded message' => 'Konec pøesmìrované zprávy',
      'Forward article of ticket' => 'Pøesmìrovaná artikl tiketu',
      'Forwarded message from' => 'Pøesmìrovat zprávu od',
      'Reply-To' => 'Odpovìdìt',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Zmìnit text tiketu',
      'Value' => 'Hodnota',

    # Template: AgentHistoryForm
      'History of' => 'Historie',

    # Template: AgentMailboxNavBar
      'All messages' => 'Všechny zprávy',
      'down' => 'dolù',
      'Mailbox' => '',
      'New' => 'Nové',
      'New messages' => 'Nové zprávy',
      'Open' => 'Otevøené',
      'Open messages' => 'Otevøené zprávy',
      'Order' => 'Seøadit',
      'Pending messages' => 'Zprávy ve vyøizování',
      'Reminder' => 'Upomínky',
      'Reminder messages' => 'Zprávy k upomínce',
      'Sort by' => 'Seøadit dle',
      'Tickets' => 'Tikety',
      'up' => 'nahoru',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'All Agents' => '',
      'Move Ticket' => 'Pøesunout Tiket',
      'New Owner' => '',
      'New Queue' => 'NOvá øada',
      'Previous Owner' => '',
      'Queue ID' => '',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Uzamèené tikety',
      'new message' => 'nové zprávy',
      'Preferences' => 'Vlastnosti',
      'Utilities' => 'Vyhledávání ',

    # Template: AgentNote
      'Add note to ticket' => 'Pøidat poznámku k tiketu',
      'Note!' => 'Poznámka!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Zmìnit majitele tiketu',
      'Message for new Owner' => 'Zpráva pro mového majitele',

    # Template: AgentPending
      'Pending date' => 'Èas k vyøízení',
      'Pending type' => 'Typ vyøizování',
      'Pending!' => 'Vyøizuje se!',
      'Set Pending' => 'Nastavení vyøizování',

    # Template: AgentPhone
      'Customer called' => 'Klient volal',
      'Phone call' => 'Telefoní hovor',
      'Phone call at %s' => 'Telefoní hovor v %s',

    # Template: AgentPhoneNew
      'Clear From' => 'Zrušit pole od',
      'Lock Ticket' => '',
      'new ticket' => 'Nový tiket',

    # Template: AgentPlain
      'ArticleID' => 'Kód artiklu',
      'Plain' => '',
      'TicketID' => 'Kód tiketu',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Vyberte si vlastní øadu',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Zmìnit heslo',
      'New password' => 'Nové heslo',
      'New password again' => 'Nové heslo (potvrzení)',

    # Template: AgentPriority
      'Change priority of ticket' => 'Zmìnit prioritu tiketu',

    # Template: AgentSpelling
      'Apply these changes' => 'Použít tyto zmìna',
      'Spell Checker' => 'Slovník',
      'spelling error(s)' => 'chyba(y) ve slovech',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'z',
      'Site' => 'Stránka',
      'sort downward' => 'seøadit dolu',
      'sort upward' => 'seøadit nahoru',
      'Ticket Status' => 'Status tiketu',
      'U' => 'U',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLink
      'Link' => '',
      'Link to' => '',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Tiket je zamknut!',
      'Ticket unlock!' => 'Tiket je odemknut!',

    # Template: AgentTicketPrint
      'by' => ' ',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Uètový èas',
      'Escalation in' => '',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '',
      '(e. g. 234321)' => '',
      '(e. g. U5150)' => '',
      'and' => '',
      'Customer User Login' => '',
      'Delete' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => '',
      'No time settings.' => '',
      'Profile' => '',
      'Result Form' => '',
      'Save Search-Profile as Template?' => '',
      'Search-Template' => '',
      'Select' => '',
      'Ticket created' => '',
      'Ticket created between' => '',
      'Ticket Search' => 'Hledání tiketu',
      'TicketFreeText' => '',
      'Times' => '',
      'Yes, save it with name' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Vyhledávání historie klienta',
      'Customer history search (e. g. "ID342425").' => 'Vyhledávání historie klienta (napø: "ID342425")',
      'No * possible!' => '* není povolena!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => '',
      'Results' => 'Výsledky',
      'Search Result' => '',
      'Total hits' => 'Celkem hitù',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Všechny uzavøené tikety',
      'All open tickets' => 'Všechny otevøené tikety',
      'closed tickets' => 'zavøených tiketù',
      'open tickets' => 'otevøených tiketù',
      'or' => 'nebo',
      'Provides an overview of all' => 'Vygenerovat náhled všech',
      'So you see what is going on in your system.' => 'Mùžete vidìt kdo je ve Vašem systému.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Vytvoøit následující',
      'Your own Ticket' => 'Vaše vlastní tikety',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Vytvoøit odpovšï',
      'Contact customer' => 'Kontaktovat klienta',
      'phone call' => 'telefoní hovor',

    # Template: AgentZoomArticle
      'Split' => 'Oøezat',

    # Template: AgentZoomBody
      'Change queue' => 'Zmìnit øadu',

    # Template: AgentZoomHead
      'Free Fields' => 'Volné pole',
      'Print' => 'TIsknout',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Vytvoøit úèet',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'Edit' => '',
      'FAQ History' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => '',
      'Keywords' => '',
      'Last update' => '',
      'Problem' => '',
      'Solution' => '',
      'Symptom' => '',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: CustomerFAQArticleView
      'FAQ Article' => '',
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
      'Powered by' => 'Vytvoøeno',

    # Template: CustomerHeader
      'Contact' => 'Konktatk',
      'Home' => '',
      'Online-Support' => 'Online Podpora',
      'Products' => 'Produkty',
      'Support' => 'Podpora',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Zapomìl/a jste heslo?',
      'Request new password' => 'Požádat o nové heslo',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Vytvoøit nový tiket',
      'FAQ' => 'FAQ',
      'New Ticket' => 'Nový tiket',
      'Ticket-Overview' => 'Pøehled tiketù',
      'Welcome %s' => 'Vítejte %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Moje tikety',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Kliknutím zde pošlete chybu!',

    # Template: FAQArticleDelete
      'FAQ Delete' => '',
      'You really want to delete this article?' => '',

    # Template: FAQArticleForm
      'Comment (internal)' => '',
      'Filename' => '',
      'Short Description' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => '',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => '',

    # Template: Footer
      'Top of Page' => 'Nahoru',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Vytvoøit Databazi ',
      'Drop Database' => 'Smazat databazi',
      'Finished' => 'Ukonèit',
      'System Settings' => 'Nastavení systému',
      'Web-Installer' => 'Web-Installer',

    # Template: InstallerFinish
      'Admin-User' => 'Administrace uživatelù',
      'After doing so your OTRS is up and running.' => 'Po tomto Váš OTRS je nainstalován a funguje',
      'Have a lot of fun!' => 'Hodnì štìstí s OTRS!',
      'Restart your webserver' => 'Restartovat server',
      'Start page' => 'Úvodní stránka',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Per poter usare OTRS devi inserire questa riga di comando in una shell come utente root.',
      'Your OTRS Team' => 'Váš OTR tým',

    # Template: InstallerLicense
      'accept license' => 'souhlasím',
      'don\'t accept license' => 'nesouhlasím',
      'License' => 'Licence',

    # Template: InstallerStart
      'Create new database' => 'Vytvoøit novou databázi',
      'DB Admin Password' => 'Heslo administrátora k databázi',
      'DB Admin User' => 'Administraèní username',
      'DB Host' => '',
      'DB Type' => 'Typ databáze',
      'default \'hot\'' => '',
      'Delete old database' => 'Smazat starou datab',
      'next step' => 'další krok',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => '',
      'OTRS DB Password' => '',
      'OTRS DB User' => '',
      'your MySQL DB should have a root password! Default is empty!' => 'Vaše databáze by mìla mít heslo!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrola MX záznamù použitého emalu pøi vytváøení odpovìdí Nepoužívejte pokus jste pøipojeni na OTR pomocí dial upu!)',
      '(Email of the system admin)' => '(Email administrátora)',
      '(Full qualified domain name of your system)' => '(Plnì kvalifikované doména systému)',
      '(Logfile just needed for File-LogModule!)' => '(LogFIle potøebujete pro modul Souborového logování)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Systémové ID. Každé èíslo tiketu a každá HTTP session bude startovat tímto èíslem)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identikátor tiketù. Nekteøí lidé chtejí používat napø. \'Tiket#\',  \'Hovor\' nebo \'MujTiket\')',
      '(Used default language)' => '(Použitý defaultní jazyk)',
      '(Used log backend)' => '(Užitý typ logù)',
      '(Used ticket number format)' => '(Èíselný typ tiketù)',
      'CheckMXRecord' => 'Zkontrolovat MX záznam',
      'Default Charset' => 'Defaultní znaková sada',
      'Default Language' => 'Defaultní jazyk',
      'Logfile' => 'LogFile',
      'LogModule' => 'Modul Log',
      'Organization' => 'Organizace',
      'System FQDN' => 'System FQDN',
      'SystemID' => 'System ID',
      'Ticket Hook' => 'Prefix riketù',
      'Ticket Number Generator' => 'Generator èísel tiketù',
      'Use utf-8 it your database supports it!' => '',
      'Webfrontend' => 'Webove rozhraní',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Nemáte práva',

    # Template: Notify
      'Info' => 'Informace',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'printed by' => 'tisknuto',

    # Template: QueueView
      'All tickets' => 'Celkem tiketù',
      'Page' => '',
      'Queues' => 'Øady',
      'Tickets available' => 'Tiketù k dispozici',
      'Tickets shown' => 'Zobrazené tikety',

    # Template: SystemStats
      'Graphs' => 'Grafy',

    # Template: Test
      'OTRS Test Page' => 'Test OTRS stránky',

    # Template: TicketEscalation
      'Ticket escalation!' => '',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Pøidat poznámku',

    # Template: Warning

    # Misc
      'A message should have a From: recipient!' => 'Vaše zpráva by mìla mít OD: odesílatel!',
      'AgentFrontend' => 'Zóna operátorù',
      'Article free text' => 'Text artiklu',
      'Charset' => 'Znaková sada',
      'Charsets' => 'Znakové sady',
      'Create' => 'Vytvoøit',
      'Customer info' => 'Informace o klientovi',
      'CustomerUser' => 'Klient',
      'Fulltext search' => 'Fulltextové vyhledávání',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Hledání fulltext (napø. "Mar*in" nebo "Nov*" èi "martin+chyba")',
      'Handle' => 'Ovládání',
      'In Queue' => 'V øadì',
      'New state' => 'Nový status',
      'New ticket via call.' => 'Nový tiket via telefon.',
      'New user' => 'Nový operátor',
      'Pøíjemci' => 'Destinatari',
      'Search in' => 'Hledat v',
      'Set customer id of a ticket' => 'Nastavení klient ID v tiketu',
      'Show all' => 'ZObrazit vše',
      'System Charset Management' => 'Správa znakovách sad',
      'System Language Management' => 'Správa jazykù',
      'Ticket free text' => 'Text tiketu',
      'With Priority' => 'S prioritou',
      'With State' => 'Se statusem',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'Váš email s èíslem tiketu "<OTRS_TICKET>"   byl pøedán "<OTRS_BOUNCE_TO>". Kontaktujte tuto adresu pro další informace.',
      'auto responses set' => 'nastavit automatické odpovìdi',
      'invalid-temporarily' => 'doèasnì neplatný',
      'odesláno' => 'Invia',
      'search' => 'Hledat',
      'search (e. g. 10*5155 or 105658*)' => 'hledat (napø: 10*5155 nebo 105658*)',
      'store' => 'sklad',
      'tickets' => 'tiket',
      'valid' => 'validní',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
