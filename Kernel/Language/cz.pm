# --
# Kernel/Language/cz.pm - provides cz language translation
# Copyright (C) 2003 Lukas Vicanek alias networ <lulka at centrum dot cz>
# --
# $Id: cz.pm,v 1.3 2004-01-20 00:02:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::cz;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Wed May 14 01:01:35 2003 by 

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
      '10 minutes' => '10 minut',
      '15 minutes' => '15 minut',
      'AddLink' => 'Pøidat odkaz',
      'Admin-Area' => 'Administraèní zóna',
      'agent' => 'operator',
      'all' => 'vše',
      'All' => 'Vše',
      'Attention' => 'Upozornìní',
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
      'days' => 'dní',
      'description' => 'popis',
      'Description' => 'Popis',
      'Dispatching by email To: field.' => 'Odbavení podle pole KOMU:.',
      'Dispatching by selected Queue.' => 'Odbavení podle vybrané fronty.',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Nepracujte s uètem èíslo 1 (systémový úèet)! Vytvoøte prosím nový',
      'Done' => 'Hotovo',
      'end' => 'konec',
      'Error' => 'Chyba',
      'Example' => 'Pøíklad',
      'Examples' => 'Pøíklady',
      'Facility' => 'Funkce',
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
      'Line' => 'Linka',
      'Lite' => 'Omezená',
      'Login failed! Your username or password was entered incorrectly.' => 'Chyba v pøíhlášení! Špatný uživatelský uèet nebo heslo.',
      'Logout successful. Thank you for using OTRS!' => 'Odlogování probìhlov poøádku. Dìkujeme za užívání OTRS!',
      'Message' => 'Zpráva',
      'minute' => 'minuta',
      'minutes' => 'minut',
      'Module' => 'Modul',
      'Modulefile' => 'Modulový soubor',
      'Name' => 'Jméno',
      'New message' => 'Nová zpráva',
      'New message!' => 'Nová zpráva!',
      'No' => 'Ne',
      'no' => 'ne',
      'No entry found!' => 'Nic nebylo nalezeno!',
      'No suggestions' => 'Žádná nabídka nenalezena',
      'none' => 'žádné',
      'none - answered' => 'žádný - odpovìzeno',
      'none!' => 'žádný!',
      'Off' => 'Vypnuto',
      'off' => 'vypnuto',
      'On' => 'Zapnuto',
      'on' => 'zapnuto',
      'Password' => 'Heslo',
      'Pending till' => 'Nevyøízený do',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosíme odpovezte na tento tiket(y) pro návrat do pøehledu zpráv!',
      'Please contact your admin' => 'Kontaktujte prosím Vašeho administrátora',
      'please do not edit!' => 'prosíme neupravovat!',
      'possible' => 'možný',
      'QueueView' => 'Pøehled zpráv',
      'reject' => 'zrušen',
      'replace with' => 'nahradit',
      'Reset' => 'Reset',
      'Salutation' => 'Text',
      'Session has timed out. Please log in again.' => 'Session vypršelo. Pøihlaste se znova.',
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
      'top' => 'nahoru',
      'update' => 'obnovit',
      'update!' => 'obnovit!',
      'User' => 'Uživatelé',
      'Username' => 'Jméno uživatele',
      'Valid' => 'Platnost',
      'Warning' => 'Upozornìní',
      'Welcome to OTRS' => 'Vítejte v OTRS',
      'Word' => 'slovo',
      'wrote' => 'napsal',
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
      'Move notification' => 'Pøesunout zprávu',
      'New ticket notification' => 'Nový Tiket',
      'Other Options' => 'Další nastavení',
      'Preferences updated successfully!' => 'Nastavení probìhlo uspìšnì!',
      'QueueView refresh time' => 'Èas obnovení pøehledu zpráv',
      'Select your default spelling dictionary.' => 'Vyberte si slovník',
      'Select your frontend Charset.' => 'Vyberte si znakovou sadu.',
      'Select your frontend language.' => 'Vyberte si jazyk.',
      'Select your frontend QueueView.' => 'Vyberte si typ pøehledu zpráv.',
      'Select your frontend Theme.' => 'Vyberte si vzhled.',
      'Select your QueueView refresh time.' => 'Vyberte si èas obnovy pøehledu zpráv.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Poslat zprávu, pokud klient pošle následující zprávu a já jsem správce jeho Ticketu.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Poslat zprávu, pokud je Ticket pøesunut do Vlastního pøehledu.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Poslat zprávu, pokud je Ticket odemknut systémem.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Poslat zprávu, pokud je nový Tiket v mém Vlastním pøehledu.',
      'Show closed tickets.' => 'Zobrazit uzavøené Tikety.',
      'Spelling Dictionary' => 'Slovník',
      'Ticket lock timeout notification' => 'Upozornìní na vypršení èasu u zamknutého Tiketu',

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
      'Add attachment' => 'Vložit pøílohu',
      'Attachment Management' => 'Správa pøíloh',
      'Change attachment settings' => 'Zmìnit nastavení pøíloh',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Pøidat automatickou odpovìï',
      'Auto Response From' => 'Automatická odpovìï OD',
      'Auto Response Management' => 'Správa automatických odpovìdí',
      'Change auto response settings' => 'Zmìnit nastavení automatických odpovedí',
      'Charset' => 'Znaková sada',
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

    # Template: AdminCharsetForm
      'Add charset' => 'Pøidat znakovou sadu',
      'Change system charset setting' => 'Zmìnit systémovou znakovou sadu',
      'System Charset Management' => 'Správa znakovách sad',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Pøidat klineta',
      'Change customer user settings' => 'Upravit nastavení klienta',
      'Customer User Management' => 'Správa klientù',
      'Customer user will be needed to to login via customer panels.' => 'Klient se musí pøihlasít pomocí klientského nastavení.',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Email Adminù',
      'Body' => 'Text',
      'OTRS-Admin Info!' => 'OTRS-Admin info',
      'Permission' => 'Práva',
      'Pøíjemci' => 'Destinatari',
      'odesláno' => 'Invia',

    # Template: AdminEmailSent
      'Message sent to' => 'Zpráva odeslána ',

    # Template: AdminGroupForm
      'Add group' => 'Pøidat skupinu',
      'Change group settings' => 'Zmìnit nastavení skupin',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Vytvoøit nové skupiny k lepšímu pøehledu a nastavení práv pro rozdílné skupiny operátorù (jako oddìlení fakturace, prodeje, podpory,...).',
      'Group Management' => 'Správa skupin',
      'It\'s useful for ASP solutions.' => 'Používané pro ASP øešení',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Skupina administrátorù má pøístup do statistik a administraèní zóny.',

    # Template: AdminLog
      'System Log' => 'System Log',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin Email',
      'AgentFrontend' => 'Zóna operátorù',
      'Attachment <-> Response' => 'Pøíloha <-> Odpovìï',
      'Auto Response <-> Queue' => 'Automatická odpovìï <-> Øada',
      'Auto Responses' => 'Automatické odpovìdi',
      'Charsets' => 'Znakové sady',
      'Customer User' => 'Klienti',
      'Email Addresses' => 'Emailové adresy',
      'Groups' => 'Skupiny',
      'Logout' => 'Odhlásit',
      'Misc' => 'Rùzné',
      'POP3 Account' => 'POP3 úèet',
      'Responses' => 'Odpovìdi',
      'Responses <-> Queue' => 'Odpovìdi <-> Øada',
      'Select Box' => 'Výbìr funkcí',
      'Session Management' => 'Správa session',
      'Status' => 'Status',
      'System' => 'System',
      'User <-> Groups' => 'Uživatelé <-> Skupiny',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Pøidat POP3 úèet',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Všechny pøíchozí emaily s jedním úètem budou pøesmìrovány do vybrané øady!',
      'Change POP3 Account setting' => 'Zmìnit nastavení POP3 úètú',
      'Dispatching' => 'Roztøídit',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Pokud je Váš uèet ovìøen, X-OTRS hlavièky (pro prioritu, ...) budou používány!',
      'Login' => '',
      'POP3 Account Management' => 'Správa POP3 úètù',
      'Trusted' => 'Ovìøit',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Øada <-> automatické opovìdi',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = žádná eskalace (stupòování)',
      '0 = no unlock' => '0 = žádné odemknutí',
      'Add queue' => 'Pøidat øadu',
      'Change queue settings' => 'Zmìnit nastavení øady',
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
      'Change %s settings' => 'Zmìnit nastavení %s',
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
      'Add response' => 'Pøidat odpovìï',
      'Change response settings' => 'Zmìna nastavení odpovìdí',
      'Don\'t forget to add a new response a queue!' => 'Nezapomeòte pøidat novou odpoveï do øady!',
      'Response Management' => 'Správa odpovìdí',

    # Template: AdminSalutationForm
      'Add salutation' => 'Pøidat oslovení',
      'Change salutation settings' => 'Zmìnit nastavvení oslovení',
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
      'kill all sessions' => 'Zrušit všechny session',

    # Template: AdminSessionTable
      'kill session' => 'Zrušit session',
      'SessionID' => 'ID session',

    # Template: AdminSignatureForm
      'Add signature' => 'Pøidat podpis',
      'Change signature settings' => 'Zmìnit nastavení podpisù',
      'Signature Management' => 'Správa podpisù',

    # Template: AdminStateForm
      'Add state' => 'Pøidat status',
      'Change system state setting' => 'Zmìnit nastavení statusu',
      'State Type' => 'Typ statusu',
      'System State Management' => 'Správa statusù',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Pøidat adresu',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Všechny pøíchozí emaily s polem KOME budou zarazeby to vybrane øady!',
      'Change system address setting' => 'Upravit nastavení adres',
      'Email' => 'eMail',
      'Realname' => 'Pravé jméno',
      'System Email Addresses Management' => 'Správa adres',

    # Template: AdminUserForm
      'Add user' => 'Pøidat operátora',
      'Change user settings' => 'Upravit nastavení operátora',
      'Don\'t forget to add a new user to groups!' => 'Nezapomeòte pøidat operátora do skupin!',
      'Firstname' => 'Jméno',
      'Lastname' => 'Pøíjmení',
      'User Management' => 'Správa operátorù',
      'User will be needed to handle tickets.' => 'Operátor se bude zabývat Tikety.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => 'Zmìnit nastavení',
      'User <-> Group Management' => 'Uživatele <-> správa skupin',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Zmenit uživatele <-> nastavení skupin',

    # Template: AdminUserPreferencesGeneric

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
      'Customer history' => 'Historie klienta',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerMessage
      'Follow up' => 'Následující',
      'Next state' => 'Dalsí status',

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

    # Template: AgentMove
      'Move Ticket' => 'Pøesunout Tiket',
      'New Queue' => 'NOvá øada',
      'New user' => 'Nový operátor',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Uzamèené tikety',
      'new message' => 'nové zprávy',
      'PhoneView' => 'Vložit Tiket',
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
      'create' => 'vytvoøit',
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
      'Discard all changes and return to the compose screen' => 'Zrušit všechny zmìny a vrátit se k vytváøení',
      'Return to the compose screen' => 'Vrátit se k vytváøení',
      'Spell Checker' => 'Slovník',
      'spelling error(s)' => 'chyba(y) ve slovech',
      'The message being composed has been closed.  Exiting.' => 'Zprávy musí být vytvoøeny, ještì pøed tím, než je zavøete.',
      'This window must be called from compose window' => 'Toto okno musí být voláno pouze z vytváøecího',

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

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Tiket je zamknut!',
      'Ticket unlock!' => 'Tiket je odemknut!',

    # Template: AgentTicketPrint
      'by' => ' ',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Uètový èas',
      'Escalation in' => '',
      'printed by' => 'tisknuto',

    # Template: AgentUtilSearch
      'Article free text' => 'Text artiklu',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Hledání fulltext (napø. "Mar*in" nebo "Nov*" èi "martin+chyba")',
      'search' => 'Hledat',
      'search (e. g. 10*5155 or 105658*)' => 'hledat (napø: 10*5155 nebo 105658*)',
      'Ticket free text' => 'Text tiketu',
      'Ticket Search' => 'Hledání tiketu',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Vyhledávání historie klienta',
      'Customer history search (e. g. "ID342425").' => 'Vyhledávání historie klienta (napø: "ID342425")',
      'No * possible!' => '* není povolena!',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Výsledky',
      'Total hits' => 'Celkem hitù',

    # Template: AgentUtilSearchResult

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

    # Template: CustomerCreateAccount
      'Create Account' => 'Vytvoøit úèet',

    # Template: CustomerError
      'Traceback' => '',

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
      'My Tickets' => 'Moje tikety',
      'New Ticket' => 'Nový tiket',
      'Ticket-Overview' => 'Pøehled tiketù',
      'Welcome %s' => 'Vítejte %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Kliknutím zde pošlete chybu!',

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

    # Template: QueueView
      'All tickets' => 'Celkem tiketù',
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
      '(Click here to add a group)' => '(Kliknìte zde pro pøidání skupiny)',
      '(Click here to add a queue)' => '(Kliknìte zde pro pøidání øady)',
      '(Click here to add a response)' => '(Kliknìte zde pro pøidání odpovìdi)',
      '(Click here to add a salutation)' => '(Kliknìte zde pro pøidání oslovení)',
      '(Click here to add a signature)' => '(Kliknìte zde pro pøidání podpisu)',
      '(Click here to add a system email address)' => '(Kliknìte zde pro pøidání systémové emailové adresy)',
      '(Click here to add a user)' => '(Kliknìte zde pro pøidání operátora)',
      '(Click here to add an auto response)' => '(Kliknìte zde pro pøidání automatické odpovìdi)',
      '(Click here to add charset)' => '(Kliknìte zde pro pøidání znakové sady)',
      '(Click here to add language)' => '(Kliknìte zde pro pøidání jazyka)',
      '(Click here to add state)' => '(Kliknìte zde pro pøidání nového statusu)',
      '(E-Mail of the system admin)' => '(Email systémového admina)',
      'A message should have a From: recipient!' => 'Vaše zpráva by mìla mít OD: odesílatel!',
      'Create' => 'Vytvoøit',
      'Customer info' => 'Informace o klientovi',
      'CustomerUser' => 'Klient',
      'FAQ' => 'FAQ',
      'Fulltext search' => 'Fulltextové vyhledávání',
      'Handle' => 'Ovládání',
      'In Queue' => 'V øadì',
      'New state' => 'Nový status',
      'New ticket via call.' => 'Nový tiket via telefon.',
      'Search in' => 'Hledat v',
      'Set customer id of a ticket' => 'Nastavení klient ID v tiketu',
      'Show all' => 'ZObrazit vše',
      'System Language Management' => 'Správa jazykù',
      'Update auto response' => 'Aktualizovat automatické odpovìdi',
      'Update charset' => 'Aktualizovat znakovou sadu',
      'Update group' => 'Aktualizovat skupinu',
      'Update language' => 'Aktualizovat jazyk',
      'Update queue' => 'Aktualizovat øadu',
      'Update response' => 'Aktualizovat odpovìï',
      'Update salutation' => 'Aktualizovat oslovení',
      'Update signature' => 'Aktualizovat podpis',
      'Update state' => 'Aktualizovat status',
      'Update system address' => 'Aktualizovat adresu',
      'Update user' => 'Aktualizovat operátora',
      'With Priority' => 'S prioritou',
      'With State' => 'Se statusem',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => 'Váš email s èíslem tiketu "<OTRS_TICKET>"   byl pøedán "<OTRS_BOUNCE_TO>". Kontaktujte tuto adresu pro další informace.',
      'auto responses set' => 'nastavit automatické odpovìdi',
      'invalid-temporarily' => 'doèasnì neplatný',
      'store' => 'sklad',
      'tickets' => 'tiket',
      'valid' => 'validní',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
