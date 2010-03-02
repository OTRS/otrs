# --
# Kernel/Language/cz.pm - provides cz language translation
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# Copyright (C) 2003 Lukas Vicanek alias networ <lulka at centrum dot cz>
# Copyright (C) 2004 BENETA.cz, s.r.o. (Marta Macalkova, Vadim Buzek, Petr Ocasek) <info at beneta dot cz>
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# --
# $Id: cz.pm,v 1.78.2.5 2010-03-02 15:49:50 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cz;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.78.2.5 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat Jun 27 13:54:56 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-2', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %Y %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
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
        'Cancel' => 'Storno',
        'Reset' => '',
        'last' => 'poslední',
        'before' => 'před',
        'day' => 'den',
        'days' => 'dní(dny)',
        'day(s)' => 'den(dní)',
        'hour' => 'hodina',
        'hours' => 'hodin',
        'hour(s)' => 'hodina(y)',
        'minute' => 'minuta',
        'minutes' => 'minut',
        'minute(s)' => 'minuta(y)',
        'month' => 'měsíc',
        'months' => 'měsíců',
        'month(s)' => 'měsíc(e)',
        'week' => 'týden',
        'week(s)' => 'týden(týdny)',
        'year' => 'rok',
        'years' => 'roků',
        'year(s)' => 'rok(y)',
        'second(s)' => 'vteřina(y)',
        'seconds' => 'vteřin',
        'second' => 'vteřina',
        'wrote' => 'napsal',
        'Message' => 'Zpráva',
        'Error' => 'Chyba',
        'Bug Report' => 'Upozornění na chybu',
        'Attention' => 'Upozornění',
        'Warning' => 'Varování',
        'Module' => 'Modul',
        'Modulefile' => 'Modulový soubor',
        'Subfunction' => 'Podfunkce',
        'Line' => 'Řádek',
        'Setting' => 'Nastavení',
        'Settings' => 'Nastavení',
        'Example' => 'Příklad',
        'Examples' => 'Příklady',
        'valid' => 'platný',
        'invalid' => 'neplatný',
        '* invalid' => '* neplatný',
        'invalid-temporarily' => 'neplatný-dočasně',
        ' 2 minutes' => ' 2 minuty',
        ' 5 minutes' => ' 5 minut',
        ' 7 minutes' => ' 7 minut',
        '10 minutes' => '10 minut',
        '15 minutes' => '15 minut',
        'Mr.' => 'pan',
        'Mrs.' => 'paní',
        'Next' => 'Další',
        'Back' => 'Zpět',
        'Next...' => 'Další...',
        '...Back' => '...Zpět',
        '-none-' => '-žádný-',
        'none' => 'žádné',
        'none!' => 'žádný!',
        'none - answered' => 'žádný - odpovězeno',
        'please do not edit!' => 'prosíme neupravovat!',
        'AddLink' => 'Přidat Párování',
        'Link' => 'Spárovat',
        'Unlink' => 'Zrušit Párování',
        'Linked' => 'Spárováno',
        'Link (Normal)' => 'Párovat (Normálně)',
        'Link (Parent)' => 'Párovat (Nadřazený)',
        'Link (Child)' => 'Párovat (Podřízený)',
        'Normal' => 'Normální',
        'Parent' => 'Nadřazený',
        'Child' => 'Podřízený',
        'Hit' => 'Přístup',
        'Hits' => 'Prístupů',
        'Text' => '',
        'Lite' => 'Omezená',
        'User' => 'Uživatel',
        'Username' => 'Uživatelské Jméno',
        'Language' => 'Jazyk',
        'Languages' => 'Jazyky',
        'Password' => 'Heslo',
        'Salutation' => 'Oslovení',
        'Signature' => 'Podpis',
        'Customer' => 'Klient',
        'CustomerID' => 'ID klienta',
        'CustomerIDs' => 'ID klienta',
        'customer' => 'klient',
        'agent' => 'řešitel',
        'system' => 'systém',
        'Customer Info' => 'Informace o klientovi',
        'Customer Company' => 'Společnost zákazníka',
        'Company' => 'Společnost',
        'go!' => 'jdi!',
        'go' => 'jdi',
        'All' => 'Vše',
        'all' => 'vše',
        'Sorry' => 'Omluva',
        'update!' => 'aktualizovat!',
        'update' => 'aktualizovat',
        'Update' => 'Aktualizovat',
        'Updated!' => 'Aktualizováno',
        'submit!' => 'Odeslat!',
        'submit' => 'odeslat',
        'Submit' => 'Odeslat',
        'change!' => 'změnit!',
        'Change' => 'Změnit',
        'change' => 'změnit',
        'click here' => 'klikněte zde',
        'Comment' => 'Komentář',
        'Valid' => 'Platnost',
        'Invalid Option!' => 'Neplatná volba',
        'Invalid time!' => 'Neplatný čas',
        'Invalid date!' => 'Neplatné datum',
        'Name' => 'Jméno',
        'Group' => 'Skupina',
        'Description' => 'Popis',
        'description' => 'popis',
        'Theme' => 'Motiv',
        'Created' => 'Vytvořeno',
        'Created by' => 'Vytvořeno kým',
        'Changed' => 'Změněno',
        'Changed by' => 'Změněno kým',
        'Search' => 'Vyhledat',
        'and' => 'a',
        'between' => 'mezi',
        'Fulltext Search' => 'Fulltextové vyhledávání',
        'Data' => '',
        'Options' => 'Možnosti',
        'Title' => 'Nadpis',
        'Item' => 'Položka',
        'Delete' => 'Vymazat',
        'Edit' => 'Editovat',
        'View' => 'Náhled',
        'Number' => 'Číslo',
        'System' => 'Systém',
        'Contact' => 'Konktakt',
        'Contacts' => 'Kontakty',
        'Export' => '',
        'Up' => 'Nahoru',
        'Down' => 'Dolu',
        'Add' => 'Přidat',
        'Added!' => 'Přidáno!',
        'Category' => 'Kategorie',
        'Viewer' => 'Prohlížeč',
        'Expand' => 'Rozbalit',
        'New message' => 'Nová zpráva',
        'New message!' => 'Nová zpráva!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Prosím, odpovězte na tento (tyto) tiket(y) pro návrat do normálního náhledu fronty!',
        'You got new message!' => 'Máte novou zprávu!',
        'You have %s new message(s)!' => 'Máte %s novou zprávu (nových zpráv)!',
        'You have %s reminder ticket(s)!' => 'Máte %s upomínkový(ch) ticket(ů)',
        'The recommended charset for your language is %s!' => 'Doporučená znaková sada pro Váš jazyk je %s!',
        'Passwords doesn\'t match! Please try it again!' => '',
        'Password is already in use! Please use an other password!' => 'Heslo je používáno! Použijte prosím jiné heslo!',
        'Password is already used! Please use an other password!' => 'Heslo je již použito! Použijte prosím jiné heslo!',
        'You need to activate %s first to use it!' => '%s musí být aktivováno!',
        'No suggestions' => 'žádné návrhy',
        'Word' => 'Slovo',
        'Ignore' => 'Ignorovat',
        'replace with' => 'nahradit čím',
        'There is no account with that login name.' => 'Žádný účet s tímto přihlašovacím jménem neexistuje.',
        'Login failed! Your username or password was entered incorrectly.' => 'Přihlášení neúspěšné! Vaše uživatelské jméno či heslo bylo zadáno nesprávně.',
        'Please contact your admin' => 'Kontaktujte, prosím, Vašeho administrátora',
        'Logout successful. Thank you for using OTRS!' => 'Odhlášení bylo úspěsné. Děkujeme Vám za používání OTRS!',
        'Invalid SessionID!' => 'Neplatné ID relace!',
        'Feature not active!' => 'Funkce je neaktivní!',
        'Notification (Event)' => 'Upozornění (Událost)',
        'Login is needed!' => 'Vyžadováno přihlášení',
        'Password is needed!' => 'Vyžadováno heslo',
        'License' => 'Licence',
        'Take this Customer' => 'Vybrat tohoto Zákazníka',
        'Take this User' => 'Vybrat tohoto uživatele',
        'possible' => 'možný',
        'reject' => 'zamítnout',
        'reverse' => 'reverzní',
        'Facility' => 'Vybavení',
        'Pending till' => 'Čekání na vyřízení do',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Z bezpečnostních důvodů nepracujte se superuživatelským účtem - vytvořte si nového uživatele!',
        'Dispatching by email To: field.' => 'Přiřadit podle e-mailu - pole KOMU:.',
        'Dispatching by selected Queue.' => 'Přiřadit do vybrané fronty.',
        'No entry found!' => 'Nebyl nalezen žádný záznam!',
        'Session has timed out. Please log in again.' => 'Relace vypršela. Prosím, přihlašte se znovu.',
        'No Permission!' => 'Nemáte oprávnění',
        'To: (%s) replaced with database email!' => 'Komu: (%s) nahrazeno emailem z databáze!',
        'Cc: (%s) added database email!' => 'Kopie: (%s) doplněno emailem z databáze',
        '(Click here to add)' => '(Pro přidání klikněte zde)',
        'Preview' => 'Zobrazit',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Rozbalení balíčku neúspěšné! Reinstalujte balíček znovu!',
        'Added User "%s"' => 'Přidaní Uživatelé "%s"',
        'Contract' => 'Kontrakt',
        'Online Customer: %s' => 'Online Zákazníci',
        'Online Agent: %s' => 'Online Řešitelé',
        'Calendar' => 'Kalendář',
        'File' => 'Soubor',
        'Filename' => 'Název souboru',
        'Type' => 'Typ Tiketu',
        'Size' => 'Velikost',
        'Upload' => '',
        'Directory' => 'Adresář',
        'Signed' => 'Podepsáno',
        'Sign' => 'Podepsat',
        'Crypted' => 'Šifrováno',
        'Crypt' => 'Šifrovat',
        'Office' => 'Kancelář',
        'Phone' => 'Telefon',
        'Fax' => '',
        'Mobile' => 'Mobilní telefon',
        'Zip' => '',
        'City' => 'Město',
        'Street' => 'Ulice',
        'Country' => 'Země',
        'Location' => 'Lokalita',
        'installed' => 'instalováno',
        'uninstalled' => 'odinstalováno',
        'Security Note: You should activate %s because application is already running!' => 'Bezpečnostní poznámka: Aktivujte %s protože aplikace stále běží!',
        'Unable to parse Online Repository index document!' => 'Nemožné analyzovat online Repository Index dokument',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Žádné balíčky pro požadovaný rámec v tomto online úložišti, než pro jiné rámce!',
        'No Packages or no new Packages in selected Online Repository!' => 'Žádné (nové) balíčky ve vybraném online úložišti',
        'printed at' => 'vytištěno na',
        'Dear Mr. %s,' => 'Vážený Pane %s,',
        'Dear Mrs. %s,' => 'Vážená Paní %s,',
        'Dear %s,' => 'Vážený(á) %s,',
        'Hello %s,' => 'Dobrý den %s,',
        'This account exists.' => 'Tento účet existuje',
        'New account created. Sent Login-Account to %s.' => 'Nový účet vytvořen. Přihlašovací údaje odeslány na %s.',
        'Please press Back and try again.' => 'Prosím klikněte na "Zpět" a opakujte pokus',
        'Sent password token to: %s' => 'Heslo Tokenu odesláno na: %s',
        'Sent new password to: %s' => 'Nové heslo odesláno na: %s',
        'Upcoming Events' => 'Aktuální události',
        'Event' => 'Událost',
        'Events' => 'Události',
        'Invalid Token!' => 'Neplatný Token',
        'more' => 'další',
        'For more info see:' => 'Pro další onformace viz:',
        'Package verification failed!' => 'Ověření balíčku selhalo',
        'Collapse' => 'Zhroucení',
        'News' => 'Novinky',
        'Product News' => 'Novinky o Produktu',
        'Bold' => 'Tučně',
        'Italic' => 'Kurzíva',
        'Underline' => 'Podtržení',
        'Font Color' => 'Barva Písma',
        'Background Color' => 'Barva Pozadí',
        'Remove Formatting' => 'Odstranit Formátování',
        'Show/Hide Hidden Elements' => 'Zobrazit/Skrýt schované prvky',
        'Align Left' => 'Zarovnání Vlevo',
        'Align Center' => 'Zarovníní na Střed',
        'Align Right' => 'Zarovnání Vpravo',
        'Justify' => 'Formátovat',
        'Header' => 'Hlavička',
        'Indent' => 'Odsazení',
        'Outdent' => 'Zrušit Odsazení',
        'Create an Unordered List' => 'Vytvořit NePřikázanou sestavu',
        'Create an Ordered List' => 'Vytvořit Přikázanou sestavu',
        'HTML Link' => 'HTML odkaz',
        'Insert Image' => 'Vložit Obrázek',
        'CTRL' => '',
        'SHIFT' => 'Shift',
        'Undo' => 'Krok Zpět',
        'Redo' => 'Znovuobnovit',

        # Template: AAAMonth
        'Jan' => 'Led',
        'Feb' => 'Úno',
        'Mar' => 'Bře',
        'Apr' => 'Dub',
        'May' => 'Květen',
        'Jun' => 'Čer',
        'Jul' => 'Čvc',
        'Aug' => 'Srp',
        'Sep' => 'Zář',
        'Oct' => 'Říj',
        'Nov' => 'Lis',
        'Dec' => 'Pro',
        'January' => 'Leden',
        'February' => 'Únor',
        'March' => 'Březen',
        'April' => 'Duben',
        'May_long' => 'kvřten',
        'June' => 'Červen',
        'July' => 'Červenec',
        'August' => 'Srpen',
        'September' => 'Září',
        'October' => 'Říjen',
        'November' => 'Listopad',
        'December' => 'Prosinec',

        # Template: AAANavBar
        'Admin-Area' => 'Oblast Admina',
        'Agent-Area' => 'Oblast Řešitele',
        'Ticket-Area' => 'Oblast Tiketu',
        'Logout' => 'Odhlásit',
        'Agent Preferences' => 'Předvolby Řešitele',
        'Preferences' => 'Předvolby',
        'Agent Mailbox' => 'Mailbox Řešitele',
        'Stats' => 'Reporty',
        'Stats-Area' => 'Oblast Reportů',
        'Admin' => '',
        'Customer Users' => 'Uživatelé Zákazníka',
        'Customer Users <-> Groups' => 'Uživatelé Zákazníka <-> Skupiny',
        'Users <-> Groups' => 'Uživatelé <-> Skupiny',
        'Roles' => 'Role',
        'Roles <-> Users' => 'Role <-> Uživatelé',
        'Roles <-> Groups' => 'Role <-> Skupiny',
        'Salutations' => 'Pozdrav',
        'Signatures' => 'Podpisy',
        'Email Addresses' => 'Emailové Adresy',
        'Notifications' => 'Notifikace',
        'Category Tree' => 'Strom Kategorií',
        'Admin Notification' => 'Admin Notifikace',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Nastavení úspěšně aktualizováno!',
        'Mail Management' => 'Správa e-mailů',
        'Frontend' => 'Rozhraní',
        'Other Options' => 'Další možnosti',
        'Change Password' => 'Změna Hesla',
        'New password' => 'Nové Heslo',
        'New password again' => 'Potvrdit Nové Heslo',
        'Select your QueueView refresh time.' => 'Vyberte si dobu obnovení náhledu fronty.',
        'Select your frontend language.' => 'Výběr jazyka rozhraní.',
        'Select your frontend Charset.' => 'Výběr znakové sady rozhraní.',
        'Select your frontend Theme.' => 'Výběr motivu rozhraní.',
        'Select your frontend QueueView.' => 'Výběr náhledu fronty rozhraní.',
        'Spelling Dictionary' => 'Slovník kontroly pravopisu',
        'Select your default spelling dictionary.' => 'Výběr výchozího pravopisného slovníku',
        'Max. shown Tickets a page in Overview.' => 'Max. zobrazených tiketů v přehledu na stránku',
        'Can\'t update password, your new passwords do not match! Please try again!' => '',
        'Can\'t update password, invalid characters!' => '',
        'Can\'t update password, must be at least %s characters!' => '',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => '',
        'Can\'t update password, needs at least 1 digit!' => '',
        'Can\'t update password, needs at least 2 characters!' => '',

        # Template: AAAStats
        'Stat' => 'Report',
        'Please fill out the required fields!' => 'Prosím vyplňte povinná pole!',
        'Please select a file!' => 'Prosím vyberte soubor!',
        'Please select an object!' => 'Prosím zvolte objekt!',
        'Please select a graph size!' => 'Prosím zvolte velikost grafu!',
        'Please select one element for the X-axis!' => 'Prosím vyberte jeden prvek pro osu X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => '',
        'If you use a checkbox you have to select some attributes of the select field!' => 'Je-li použito zaškrtávací políčko, je nutno zvolit atribut zvoleného pole!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => '',
        'The selected end time is before the start time!' => 'Zvolené Konečné datum je před Počátečním datem!',
        'You have to select one or more attributes from the select field!' => 'Musí být zvolen jeden nebo více atributů z vybraného pole!',
        'The selected Date isn\'t valid!' => '',
        'Please select only one or two elements via the checkbox!' => 'Prosím vyberte jeden nebo dva prvky pomocí zaškrtávacího políčka!',
        'If you use a time scale element you can only select one element!' => 'Při použití časového měřítka je možné vybrat pouze jeden prvek!',
        'You have an error in your time selection!' => 'Chyba ve zvoleném čase!',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Příliš malý časový interval pro report, prosím zvolte větší rozsah!',
        'The selected start time is before the allowed start time!' => 'Zvolený počátek je před povoleným počátkem!',
        'The selected end time is after the allowed end time!' => 'Zvolený konec je po povoleném konci!',
        'The selected time period is larger than the allowed time period!' => 'Zvolená perioda je delší, než povolená!',
        'Common Specification' => 'Všeobecné nastavení',
        'Xaxis' => 'Osa X',
        'Value Series' => 'Řada Hodnot',
        'Restrictions' => 'Omezení',
        'graph-lines' => 'graf-čáry',
        'graph-bars' => 'graf-sloupec',
        'graph-hbars' => 'graf-hsloupec',
        'graph-points' => 'graf-body',
        'graph-lines-points' => 'graf-čáry-body',
        'graph-area' => 'oblast grafu',
        'graph-pie' => 'výsečový graf',
        'extended' => 'podrobný',
        'Agent/Owner' => 'Řešitel/Vlastník',
        'Created by Agent/Owner' => 'Vytvořeno Řešitelem/Vlastníkem',
        'Created Priority' => 'Nastavená Priorita',
        'Created State' => 'Nastavený Stav',
        'Create Time' => 'Nastavený Čas',
        'CustomerUserLogin' => 'Přihlášení Zákazník/Uživatel',
        'Close Time' => 'Čas uzavření',
        'TicketAccumulation' => 'Sumarizace Tiketu',
        'Attributes to be printed' => 'Atributy k vytištění',
        'Sort sequence' => 'Řazení pořadí',
        'Order by' => 'Řadit dle',
        'Limit' => '',
        'Ticketlist' => 'seznam Tiketů',
        'ascending' => 'vzestupně',
        'descending' => 'sestupně',
        'First Lock' => 'První Zámek',
        'Evaluation by' => 'Vyhodnoceno dle',
        'Total Time' => 'Celkový čas',
        'Ticket Average' => 'Průměr tiketu',
        'Ticket Min Time' => 'Min. čas tiketu',
        'Ticket Max Time' => 'Max. čas tiketu',
        'Number of Tickets' => 'Počet tiketů',
        'Article Average' => 'průměr položek',
        'Article Min Time' => 'Min. čas položky',
        'Article Max Time' => 'Max. čas položky',
        'Number of Articles' => 'Počet položek',
        'Accounted time by Agent' => 'Řešitelem počítaný čas',
        'Ticket/Article Accounted Time' => '',
        'TicketAccountedTime' => '',
        'Ticket Create Time' => 'čas vytvoření tiketu',
        'Ticket Close Time' => 'čas uzavření tiketu',

        # Template: AAATicket
        'Lock' => 'Zamknout',
        'Unlock' => 'Odemknout',
        'History' => 'Historie',
        'Zoom' => 'Zobrazit',
        'Age' => 'Stáří',
        'Bounce' => 'Odeslat zpět',
        'Forward' => 'Předat',
        'From' => 'Od',
        'To' => 'Komu',
        'Cc' => 'Kopie',
        'Bcc' => 'Slepá kopie',
        'Subject' => 'Předmět',
        'Move' => 'Přesunout',
        'Queue' => 'Fronta',
        'Priority' => 'Priorita',
        'Priority Update' => 'Oprava Priority',
        'State' => 'Stav',
        'Compose' => 'Sestavit',
        'Pending' => 'Čeká na vyřízení',
        'Owner' => 'Vlastník',
        'Owner Update' => 'Oprava Vlastníka',
        'Responsible' => 'Odpovědný',
        'Responsible Update' => 'Oprava Odpovědnosti',
        'Sender' => 'Odesílatel',
        'Article' => 'Položka',
        'Ticket' => 'Tiket',
        'Createtime' => 'Doba vytvoření',
        'plain' => 'jednoduchý',
        'Email' => '',
        'email' => '',
        'Close' => 'Zavřít',
        'Action' => 'Akce',
        'Attachment' => 'Příloha',
        'Attachments' => 'Přílohy',
        'This message was written in a character set other than your own.' => 'Tato zpráva byla napsána v jiné znakové sadě než Vaše.',
        'If it is not displayed correctly,' => 'Pokud není zobrazeno správně,',
        'This is a' => 'Toto je',
        'to open it in a new window.' => 'pro otevření v novém okně.',
        'This is a HTML email. Click here to show it.' => 'Toto je HTML email. Pro zobrazení klikněte zde.',
        'Free Fields' => 'Prázdná pole',
        'Merge' => 'Sloučit',
        'merged' => 'Sloučeno',
        'closed successful' => 'uzavřeno - vyřešeno',
        'closed unsuccessful' => 'uzavřeno - nevyřešeno',
        'new' => 'nová',
        'open' => 'otevřít',
        'Open' => 'Otevřít',
        'closed' => 'uzavřeno',
        'Closed' => 'Uzavřeno',
        'removed' => 'odstraněno',
        'pending reminder' => 'upomínka při čekání na vyřízení',
        'pending auto' => 'auto čekání na vyřízení',
        'pending auto close+' => 'čeká na vyřízení - automaticky zavřít+',
        'pending auto close-' => 'čeká na vyřízení - automaticky zavřít-',
        'email-external' => 'externí email',
        'email-internal' => 'interní email',
        'note-external' => 'poznámka-externí',
        'note-internal' => 'poznámka-interní',
        'note-report' => 'poznámka-report',
        'phone' => 'telefon',
        'sms' => '',
        'webrequest' => 'požadavek přes web',
        'lock' => 'zamčeno',
        'unlock' => 'nezamčený',
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
        'Ticket "%s" created!' => 'Tiket "%s" vytvořen!',
        'Ticket Number' => 'číslo tiketu',
        'Ticket Object' => 'Tiket Objekt',
        'No such Ticket Number "%s"! Can\'t link it!' => '',
        'Don\'t show closed Tickets' => 'Nezobrazovat uzavřené tikety',
        'Show closed Tickets' => 'Zobrazit zavřené tikety',
        'New Article' => 'Nová položka',
        'Email-Ticket' => 'Email Tiket',
        'Create new Email Ticket' => 'Vytvořit nový Email Tiket',
        'Phone-Ticket' => 'Telefonní Tiket',
        'Search Tickets' => 'Vyhledávání Tiketů',
        'Edit Customer Users' => 'Editace uživatelů zákazníka',
        'Edit Customer Company' => 'Editace společnosti zákazníka',
        'Bulk Action' => 'Hromadná akce',
        'Bulk Actions on Tickets' => 'Hromadná akce na tiketech',
        'Send Email and create a new Ticket' => 'Zaslat Email a vytvořit nový tiket',
        'Create new Email Ticket and send this out (Outbound)' => 'Vytvořit nový Email Tiket a odeslat jej (Odchozí)',
        'Create new Phone Ticket (Inbound)' => 'Vytvořit nový Telefonní Tiket (Příchozí)',
        'Overview of all open Tickets' => 'Přehled všech otevřených tiketů',
        'Locked Tickets' => 'Uzamčené tikety',
        'Watched Tickets' => 'Zobrazené tikety',
        'Watched' => 'Zobrazené',
        'Subscribe' => 'Podepsat',
        'Unsubscribe' => 'Nepodepsat',
        'Lock it to work on it!' => 'Uzamknout pro práci',
        'Unlock to give it back to the queue!' => 'Odemknout zpět do Fronty',
        'Shows the ticket history!' => 'Ukáže historii tiketu!',
        'Print this ticket!' => 'Vytisknout tiket!',
        'Change the ticket priority!' => 'Změna Priority tiketu',
        'Change the ticket free fields!' => 'Změna volných polí tiketu',
        'Link this ticket to an other objects!' => 'Spárovat Tiket s jinými objekty!',
        'Change the ticket owner!' => 'Změna vlastníka tiketu!',
        'Change the ticket customer!' => 'Změna Zákazníka Tiketu',
        'Add a note to this ticket!' => 'Přidat poznámku do Tiketu',
        'Merge this ticket!' => 'Sloučit Tiket',
        'Set this ticket to pending!' => 'Nastavit jako Nevyřešený',
        'Close this ticket!' => 'Uzavřít Tiket',
        'Look into a ticket!' => 'Náhled Tiketu',
        'Delete this ticket!' => 'Výmaz Tiketu',
        'Mark as Spam!' => 'Označit jako SPAM',
        'My Queues' => 'Moje Fronty',
        'Shown Tickets' => 'Zobrazit Tikety',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Váš email s číslem Tiketu "<OTRS_TICKET>" je svázán s "<OTRS_MERGE_TO_TICKET>"',
        'Ticket %s: first response time is over (%s)!' => 'Tiket %s: Vypršel čas První Reakce (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Tiket %s: Čas První Reakce vyprší v %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiket %s: Vypršel čas Aktualizace (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiket %s: Čas Aktualizace vyprší v %s!',
        'Ticket %s: solution time is over (%s)!' => 'Tiket %s: Vypršel čas Řešení (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiket %s: Čas Řešení vyprší v %s!',
        'There are more escalated tickets!' => 'Je zde více Eskalovaných Tiketů',
        'New ticket notification' => 'Oznámení o Novém Tiketu',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Pošli mi oznámení o novém Tiketu v mých Frontách.',
        'Follow up notification' => 'Následuj Oznámení',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' => 'Pošli mi oznámení, pokud klient pošle následující a jsem vlastník tohoto tiketu.',
        'Ticket lock timeout notification' => 'Oznámení o vypršení času uzamčení tiketu',
        'Send me a notification if a ticket is unlocked by the system.' => 'Pošli mi oznámení, pokud je tiket odemknut systémem.',
        'Move notification' => 'Přesunout oznámení',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Pošli mi oznámení pokud je Tiket přesunut do mých Front.',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Selekce Front z Oblíbených. Bude zasíláno oznámení, je-li zapnuto.',
        'Custom Queue' => 'Vlastní fronta',
        'QueueView refresh time' => 'Doba obnovení náhledu fronty',
        'Screen after new ticket' => 'Zobrazení po Novém Tiketu',
        'Select your screen after creating a new ticket.' => 'Vyberte Zobrazení po vytvoření nového Tiketu.',
        'Closed Tickets' => 'Uzavřené Tikety',
        'Show closed tickets.' => 'Ukázat uzavřené tikety.',
        'Max. shown Tickets a page in QueueView.' => 'Max. zobrazených tiketů v náhledu fronty na stránku',
        'Watch notification' => 'Zobrazit Oznámení',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Pošli mi oznámení o prohlédnutých Tiketech, jako Vlastníkovi Tiketů',
        'Out Of Office' => 'Mimo Kancelář',
        'Select your out of office time.' => 'Nastavení času Mimo Kancelář',
        'CompanyTickets' => 'Firemní Tikety',
        'MyTickets' => 'moje Tikety',
        'New Ticket' => 'nový Tiket',
        'Create new Ticket' => 'Vytvořit Nový Tiket',
        'Customer called' => 'Volal Zákazník',
        'phone call' => 'Telefonní volání',
        'Reminder Reached' => 'Dosažena Upomínka',
        'Reminder Tickets' => 'Upozornění na Tikety',
        'Escalated Tickets' => 'Eskalované Tikety',
        'New Tickets' => 'Nové Tikety',
        'Open Tickets / Need to be answered' => 'Otevřené Tikety / Nutno Odpovědět',
        'Tickets which need to be answered!' => 'Tikety na které je třeba odpovědět!',
        'All new tickets!' => 'Všechny nové Tikety!',
        'All tickets which are escalated!' => 'Všechny Tikety které jsou Eskalovány!',
        'All tickets where the reminder date has reached!' => 'Všechny Tikety u kterých byla dosažena upomínka!',
        'Responses' => 'Odpovědi',
        'Responses <-> Queue' => 'Odpovědi <-> Fronta',
        'Auto Responses' => 'Automatické Odpovědi',
        'Auto Responses <-> Queue' => 'Automatické Odpovědi <-> Fronta',
        'Attachments <-> Responses' => 'Přílohy <-> Odpovědi',
        'History::Move' => 'Tiket přesunut do Fronty "%s" (%s) z Fronty "%s" (%s).',
        'History::TypeUpdate' => 'Typ Tiketu aktualizován na %s (ID=%s).',
        'History::ServiceUpdate' => 'Služba aktualizována na %s (ID=%s).',
        'History::SLAUpdate' => 'SLA aktualizováno na %s (ID=%s).',
        'History::NewTicket' => 'Nový Tiket [%s] vytvořen (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Následovat pro [%s]. %s',
        'History::SendAutoReject' => 'Automatické odmítnutí zasláno na "%s".',
        'History::SendAutoReply' => 'Automatická odpověď zaslána na "%s".',
        'History::SendAutoFollowUp' => 'Automatické následování zasláno na "%s".',
        'History::Forward' => 'Předáno dál "%s".',
        'History::Bounce' => 'Odraženo na "%s".',
        'History::SendAnswer' => 'Email odeslán na "%s".',
        'History::SendAgentNotification' => '"%s"- upozornění odesláno na "%s".',
        'History::SendCustomerNotification' => 'Upozornění odesláno na "%s".',
        'History::EmailAgent' => 'Email odeslán zákazníkovi.',
        'History::EmailCustomer' => 'Email přidán. %s',
        'History::PhoneCallAgent' => 'Řešitel kontaktoval Zákazníka.',
        'History::PhoneCallCustomer' => 'Zákazník kontaktoval nás.',
        'History::AddNote' => 'Přidaná poznámka (%s)',
        'History::Lock' => 'Zamknutý Tiket.',
        'History::Unlock' => 'Odemknutý Ticket.',
        'History::TimeAccounting' => '%s napočítaných časových jednotek. Součet všech je %s.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Aktualizováno: %s',
        'History::PriorityUpdate' => 'Priorita změněna z "%s" (%s) na "%s" (%s).',
        'History::OwnerUpdate' => 'Nový vlastník je "%s" (ID=%s).',
        'History::LoopProtection' => 'Přeposlání nepovoleno! Nebyla odeslána automatická odpověď na "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Aktualizováno: %s',
        'History::StateUpdate' => 'Starý: "%s" Nový: "%s"',
        'History::TicketFreeTextUpdate' => 'Aktualizováno: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Webový požadavek Zákazníka.',
        'History::TicketLinkAdd' => 'Spárováno s Tiketem "%s".',
        'History::TicketLinkDelete' => 'Párování s tiketem "%s" zrušeno.',
        'History::Subscribe' => 'Přidána poznámka pro uživatele"%s".',
        'History::Unsubscribe' => 'Poznámka pro uživatele odebrána "%s".',

        # Template: AAAWeekDay
        'Sun' => 'Ne',
        'Mon' => 'Po',
        'Tue' => 'Út',
        'Wed' => 'St',
        'Thu' => 'Čt',
        'Fri' => 'Pá',
        'Sat' => 'So',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Správa příloh',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Správa automatických odpovědí',
        'Response' => 'Odpověď',
        'Auto Response From' => 'Automatická odpověď Od',
        'Note' => 'Poznámka',
        'Useable options' => 'Použitelné možnosti',
        'To get the first 20 character of the subject.' => 'pro získáni prvních 20ti znaků z předmětu',
        'To get the first 5 lines of the email.' => 'pro získáni prvních 5ti řádků z emailu',
        'To get the realname of the sender (if given).' => 'Pro získání Jména Odesílatele (je-li dáno)',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'Pro získání atributu článku (příklad (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Možnosti informací o tomto Uživateli Zákazníka (příklad <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Možnosti Vlastníka Tiketu (příklad <OTRS_OWNER_UserFirstname>).',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'Možnosti tohoto Uživatele, který požadoval tuto akci (příklad <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Možnosti dat Tiketu (příklad <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Možnosti Upřesnění (příklad <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Správa Společnosti Zákazníka',
        'Search for' => 'Vyhledávání',
        'Add Customer Company' => 'Přidat Společnost Zákazníka',
        'Add a new Customer Company.' => 'Přidat novou Společnost Zákazníka',
        'List' => 'Pořadí',
        'This values are required.' => 'Vyžadované hodnoty',
        'This values are read only.' => 'Hodnoty pouze pro čtení',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => 'Vytvářená zpráva byla uzavřena. Opouštím.',
        'This window must be called from compose window' => 'Toto okno musí být vyvoláno z okna vytváření',
        'Customer User Management' => 'Správa Zákaznických Uživatelů',
        'Add Customer User' => 'Přidat Uživatele Zákazníka',
        'Source' => 'Zdroj',
        'Create' => 'Vytvořit',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Uživatel Zákazníka bude potřebovat zákaznickou historii a logovat se ze Zákaznického Modulu',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Uživatelé Zákazníka <-> Správa Skupin',
        'Change %s settings' => 'Změnit nastavení %s',
        'Select the user:group permissions.' => 'Vybrat uživatele:práva skupiny',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Pokud nebylo nic vybráno, nejsou v této skupině žádná práva (tikety nebudou pro uživatele dostupné).',
        'Permission' => 'Práva',
        'ro' => 'jen pro čtení',
        'Read only access to the ticket in this group/queue.' => 'Přístup pouze pro čtení tiketu v této skupině/frontě.',
        'rw' => 'čtení/psaní',
        'Full read and write access to the tickets in this group/queue.' => 'Plný přístup pro čtení a psaní do tiketů v této skupině/frontě.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Uživatelé Zákazníka <-> Správa Služeb',
        'CustomerUser' => 'Klient',
        'Service' => 'Služba',
        'Edit default services.' => 'Upravit Výchozí Službu',
        'Search Result' => 'Výsledky vyhledávání',
        'Allocate services to CustomerUser' => 'Přidělit Službu Zákazníkovi/Uživateli',
        'Active' => 'Aktivní',
        'Allocate CustomerUser to service' => 'Přidělit Zákazníka/Uživatele ke Službě',

        # Template: AdminEmail
        'Message sent to' => 'Zpráva odeslána',
        'A message should have a subject!' => 'Zpráva by měla mít předmět!',
        'Recipients' => 'Adresáti',
        'Body' => 'Tělo',
        'Send' => 'Odeslat',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Obecný Prostředek',
        'Job-List' => 'Seznam Úloh',
        'Last run' => 'Naposledy Spuštěno',
        'Run Now!' => 'Spustit Teď',
        'x' => 'Spustit',
        'Save Job as?' => 'Uložit Úlohu jako?',
        'Is Job Valid?' => 'Je Úloha platná?',
        'Is Job Valid' => 'Je Úloha platná',
        'Schedule' => 'Plánování',
        'Currently this generic agent job will not run automatically.' => 'Aktuálně nebude Úloha Obecného Prostředu spouštěna automaticky',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'Pro automatické spuštění vyberte alespoň jednu z hodnot: minuta, hodina a den!',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fulltextové vyhledávání v položce (např. "Mar*in" or "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(např. 10*5155 or 105658*)',
        '(e. g. 234321)' => '(např. 234321)',
        'Customer User Login' => 'Přihlášení klienta',
        '(e. g. U5150)' => '(např. U5150)',
        'SLA' => '',
        'Agent' => 'Řešitel',
        'Ticket Lock' => 'Zámek Tiketu',
        'TicketFreeFields' => 'Volná pole Tiketu',
        'Create Times' => 'Časy Vytvoření',
        'No create time settings.' => 'Žádná nastavení Času Vytvoření.',
        'Ticket created' => 'Tiket vytvořen',
        'Ticket created between' => 'Tiket vytvořen mezi',
        'Close Times' => 'Časy Uzavření',
        'No close time settings.' => 'Čas Uzavření - bez nastavení',
        'Ticket closed' => 'Uzavřené Tikety',
        'Ticket closed between' => 'Uzavřené Tikety mezi',
        'Pending Times' => 'Nevyřešené Časy',
        'No pending time settings.' => 'Nevyřešené Časy - bez nastavení',
        'Ticket pending time reached' => 'Dosažen Čas Řešení',
        'Ticket pending time reached between' => 'Dosažen Čas Řešení mezi',
        'Escalation Times' => 'Časy Eskalace',
        'No escalation time settings.' => 'Časy Eskalace - bez nastavení',
        'Ticket escalation time reached' => 'Dosažen Čas Eskalace',
        'Ticket escalation time reached between' => 'Dosažen Čas Eskalace mezi',
        'Escalation - First Response Time' => 'Eskalace - Čas První Odpovědi!',
        'Ticket first response time reached' => 'Dosažen Čas První Odpovědi',
        'Ticket first response time reached between' => 'Dosažen Čas První Odpovědi mezi',
        'Escalation - Update Time' => 'Eskalace - Čas Aktualizace',
        'Ticket update time reached' => 'Dosažen Čas Aktualizace',
        'Ticket update time reached between' => 'Dosažen Čas Aktualizace mezi',
        'Escalation - Solution Time' => 'Eskalace - Čas Řešení',
        'Ticket solution time reached' => 'Dosažen Čas Řešení',
        'Ticket solution time reached between' => 'Dosažen Čas Řešení mezi',
        'New Service' => 'Nová Služba',
        'New SLA' => 'Nové SLA',
        'New Priority' => 'Nová Priorita',
        'New Queue' => 'Nová fronta',
        'New State' => 'Nový Stav',
        'New Agent' => 'Nový Řešitel',
        'New Owner' => 'Nový vlastník',
        'New Customer' => 'Nový Zákazník',
        'New Ticket Lock' => 'Nový Zámek Tiketu',
        'New Type' => 'Nový Typ Tiketu',
        'New Title' => 'Nový Nadpis',
        'New TicketFreeFields' => 'Nová Volná Pole Tiketu',
        'Add Note' => 'Přidat poznámku',
        'Time units' => 'Jednotky času',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Příkaz bude proveden. ARG[0] bude číslo Tiketu. ARG[1] ID Tiketu',
        'Delete tickets' => 'Vymazat Tikety',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Výstraha! Tyto Tikety budou vymazány z Databáze a budou ztraceny!',
        'Send Notification' => 'Odeslat Upozornění',
        'Param 1' => 'Parametr 1',
        'Param 2' => 'Parametr 2',
        'Param 3' => 'Parametr 3',
        'Param 4' => 'Parametr 4',
        'Param 5' => 'Parametr 5',
        'Param 6' => 'Parametr 6',
        'Send agent/customer notifications on changes' => 'Odeslat upozornění Řešiteli/Zákazníkovi při změně',
        'Save' => 'Uložit',
        '%s Tickets affected! Do you really want to use this job?' => 'Ovlivněno %s Tiketů! Opravdu spustit Úlohu?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => '',
        'Group Management' => 'Správa skupiny',
        'Add Group' => 'Přidat Skupinu',
        'Add a new Group.' => 'Přidat Novou Skupinu',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Skupina administrátora má přístup do administrační a statistické zóny.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Vytvořit nové skupiny pro přiřazení práv přístupů ruzným skupinám agentů (např. oddělení nákupu, oddělení podpory, oddělení prodeje...).',
        'It\'s useful for ASP solutions.' => 'To je vhodné pro řešení ASP',

        # Template: AdminLog
        'System Log' => 'Log systému',
        'Time' => 'Čas',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Správa Emailových Účtů',
        'Host' => 'Hostitel',
        'Trusted' => 'Ověřeno',
        'Dispatching' => 'Zařazení',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Všechny příchozí emaily z daného účtu budou zařazeny do vybrané fronty!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

        # Template: AdminNavigationBar
        'Users' => 'Uživatelé',
        'Groups' => 'Skupiny',
        'Misc' => 'Různé',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Správa oznámení',
        'Add Notification' => 'Přidat oznámení',
        'Add a new Notification.' => 'Přidat Nové Oznámení',
        'Name is required!' => 'Vyžadováno Jméno!',
        'Event is required!' => 'Vyžadována Událost!',
        'A message should have a body!' => 'Zpráva by měla mít tělo!',
        'Recipient' => 'Příjemci',
        'Group based' => 'na základě Skupiny',
        'Agent based' => 'na základě Řešitele',
        'Email based' => 'na základě Emailu',
        'Article Type' => 'Typ Článku',
        'Only for ArticleCreate Event.' => 'Pouze pro událost vytvoření Článku',
        'Subject match' => 'Shoda Předmětu',
        'Body match' => 'Shoda Těla',
        'Notifications are sent to an agent or a customer.' => 'Oznámení jsou odeslána agentovi či klientovi',
        'To get the first 20 character of the subject (of the latest agent article).' => 'pro získáni prvních 20ti znaků z předmětu (z nejnovějšího článku Řešitele)',
        'To get the first 5 lines of the body (of the latest agent article).' => 'pro získáni prvních 5ti řádků z těla (z nejnovějšího článku Řešitele)',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'Pro získání atributů článku (příklad (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => 'pro získáni prvních 20ti znaků z předmětu (z nejnovějšího článku Zákazníka)',
        'To get the first 5 lines of the body (of the latest customer article).' => 'pro získáni prvních 5ti řádků z těla (z nejnovějšího článku Zákazníka)',

        # Template: AdminNotificationForm
        'Notification' => 'Upozornění',

        # Template: AdminPackageManager
        'Package Manager' => 'Správa Balíčků',
        'Uninstall' => 'Odinstalovat',
        'Version' => 'Verze',
        'Do you really want to uninstall this package?' => 'Opravdu chcete odinstalovat tento Balíček?',
        'Reinstall' => 'Reinstalovat',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Opravdu chcete reinstalovat tento Balíček (všechna manuální nastavení budou ztracena)?',
        'Continue' => 'Pokračovat',
        'Install' => 'Instalovat',
        'Package' => 'Balíček',
        'Online Repository' => 'Online Schránka',
        'Vendor' => 'Prodavač',
        'Module documentation' => 'Dokumentace Modulu',
        'Upgrade' => 'Aktualizace',
        'Local Repository' => 'Lokální Schránka',
        'Status' => 'Stav',
        'Overview' => 'Přehled',
        'Download' => '',
        'Rebuild' => 'Obnovit',
        'ChangeLog' => 'Log Změn',
        'Date' => 'Datum',
        'Filelist' => 'Seznam Souborů',
        'Download file from package!' => 'Download Souboru z Balíčku!',
        'Required' => 'Vyžadováno',
        'PrimaryKey' => 'Primární Klíč',
        'AutoIncrement' => 'Automatický Přírůstek',
        'SQL' => '',
        'Diff' => 'Rozdíl',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log Výkonu',
        'This feature is enabled!' => 'Tato Funkce je Aktivována!',
        'Just use this feature if you want to log each request.' => 'Pro logování všech Požadavků stačí zapnout tuto Funkci',
        'Activating this feature might affect your system performance!' => 'Aktivace této Funkce může ovlivnit chod Systému!',
        'Disable it here!' => 'Deaktivujte ji Zde!',
        'This feature is disabled!' => 'tato Funkce je Deaktivovaná!',
        'Enable it here!' => 'Aktivujte ji Zde!',
        'Logfile too large!' => 'Příliš velký logfile',
        'Logfile too large, you need to reset it!' => 'Příliš velký logfile, proveťe jeho reset!',
        'Range' => 'Oblast',
        'Interface' => 'Rozhraní',
        'Requests' => 'Požadavky',
        'Min Response' => 'Minimální Odezva',
        'Max Response' => 'Maximální Odezva',
        'Average Response' => 'Průměrná Odezva',
        'Period' => 'Perioda',
        'Min' => '',
        'Max' => '',
        'Average' => 'Průměr',

        # Template: AdminPGPForm
        'PGP Management' => 'Správa PGP',
        'Result' => 'Výsledek',
        'Identifier' => 'Identifikátor',
        'Bit' => 'Kousek',
        'Key' => 'Klíč',
        'Fingerprint' => 'Otisk',
        'Expires' => 'Propadává',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'V tomto způsobu můžete Keyring, konfigurovaný v SysConfigu, editovat přímo',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Správa Filtru PostMaster',
        'Filtername' => 'Jméno Filtru',
        'Stop after match' => 'Stop po shodě',
        'Match' => 'Obsahuje',
        'Value' => 'Hodnota',
        'Set' => 'Nastavit',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Odešli nebo Filtruj příchozí meaily založené na X-Headers! Možný je také RegExp.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Správa priorit',
        'Add Priority' => 'Přidat Prioritou',
        'Add a new Priority.' => 'Přidat novou Prioritou',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Fronta <-> Správa Automatických Odpovědí',
        'settings' => 'Nastavení',

        # Template: AdminQueueForm
        'Queue Management' => 'Správa front',
        'Sub-Queue of' => 'Podfronta ',
        'Unlock timeout' => 'Čas do odemknutí',
        '0 = no unlock' => '0 = žádné odemknutí',
        'Only business hours are counted.' => 'Počítají se pouze úřední hodiny',
        '0 = no escalation' => '0 = žádné stupňování',
        'Notify by' => 'Upozorněno kým',
        'Follow up Option' => 'Následující volba',
        'Ticket lock after a follow up' => 'Zamknout tiket po následujícím',
        'Systemaddress' => 'Systémová adresa',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Pokud Řešitel uzamkne tiket a neodešle v této době odpověď, tiket bude automaticky odemknut. Tak se stane tiket viditelný pro všechny ostatní Řešitele.',
        'Escalation time' => 'Doba Eskalace',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Pokud na Tiket nebude reagováno v tomto čase, bude zobrazen poze tento.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Pokud je tiket uzavřen a klient odešle následující, tiket bude pro starého vlastníka uzamknut.',
        'Will be the sender address of this queue for email answers.' => 'Bude adresou odesílatele z této fronty pro emailové odpovědi.',
        'The salutation for email answers.' => 'Oslovení pro emailové odpovědi.',
        'The signature for email answers.' => 'Podpis pro emailové odpovědi.',
        'Customer Move Notify' => 'Oznámení Klientovi o změně fronty',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS pošle klientovi emailem oznámení, pokud bude tiket přesunut.',
        'Customer State Notify' => 'Oznámení Klientovi o změně stavu',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS pošle klientovi emailem oznámení, pokud se změní stav tiketu.',
        'Customer Owner Notify' => 'Oznámení Klientovi o změně vlastníka',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS pošle klientovi emailem oznámení, pokud se změní vlastník tiketu.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Reakce <-> Správa Front',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Odpověď',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Reakce <-> Správa Příloh',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Správa Reakcí',
        'A response is default text to write faster answer (with default text) to customers.' => 'Odpověď je obsahuje výchozí text sloužící k rychlejší reakci (spolu s výchozím textem) klientům.',
        'Don\'t forget to add a new response a queue!' => 'Nezapomeňte přidat novou reakci odpoveď do fronty!',
        'The current ticket state is' => 'Aktuální stav tiketu je',
        'Your email address is new' => 'Vaše Email adresa je nová',

        # Template: AdminRoleForm
        'Role Management' => 'Správa Rolí',
        'Add Role' => 'Přidat Roli',
        'Add a new Role.' => 'Přidat Novou Roli',
        'Create a role and put groups in it. Then add the role to the users.' => 'Vytvořit Roli a vložit do ní Skupiny. Následně přiřadit Roli Uživatelům.',
        'It\'s useful for a lot of users and groups.' => '',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Role <-> Správa Skupin',
        'move_into' => 'přesunout do',
        'Permissions to move tickets into this group/queue.' => 'Práva přesunout tikety do této skupiny/fronty',
        'create' => 'vytvořit',
        'Permissions to create tickets in this group/queue.' => 'Práva vytvořit tikety v této skupině/frontě',
        'owner' => 'vlastník',
        'Permissions to change the ticket owner in this group/queue.' => 'Práva změnit vlastníka tiketu v této skupině/frontě',
        'priority' => 'priorita',
        'Permissions to change the ticket priority in this group/queue.' => 'Práva změnit prioritu tiketu v této skupině/frontě',

        # Template: AdminRoleGroupForm
        'Role' => '',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Role <-> Správa Uživatelů',
        'Select the role:user relations.' => 'Vybrat Roli: vztahy Uživatele.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Správa oslovení',
        'Add Salutation' => 'Přidat Oslovení',
        'Add a new Salutation.' => 'Přidat nové Oslovení',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Bezpečnostní Mód musí být aktivován!',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Bezpečnostní Mód bude (normálně) nastaven po dokončení iniciační instalace.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Bezpečnostní Mód musí být deaktivován za účelem Reinstalu pomocí Web-Installeru.',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Pokud není Bezpečnostní Mód aktivní, proveďte tak pomocí SysConfigu, protože aplikace stále běží.',

        # Template: AdminSelectBoxForm
        'SQL Box' => '',
        'Go' => '',
        'Select Box Result' => 'Výsledek SQL dotazu',

        # Template: AdminService
        'Service Management' => 'Správa Služeb',
        'Add Service' => 'Přidat Službu',
        'Add a new Service.' => 'Přidat novou Službu',
        'Sub-Service of' => 'Podslužba',

        # Template: AdminSession
        'Session Management' => 'Správa relace',
        'Sessions' => 'Relace',
        'Uniq' => 'Počet',
        'Kill all sessions' => 'Ukončit všechny Relace',
        'Session' => 'Relace',
        'Content' => 'Obsah',
        'kill session' => 'Ukončit Relaci',

        # Template: AdminSignatureForm
        'Signature Management' => 'Správa podpisů',
        'Add Signature' => 'Přidat Podpis',
        'Add a new Signature.' => 'Přidat nový Podpis',

        # Template: AdminSLA
        'SLA Management' => 'Správa SLA',
        'Add SLA' => 'Přidat SLA',
        'Add a new SLA.' => 'Přidat nové SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'Správa S/MIME',
        'Add Certificate' => 'Přidat Certifikát',
        'Add Private Key' => 'Přidat Privátní Klíč',
        'Secret' => 'Tajný',
        'Hash' => 'Hash #',
        'In this way you can directly edit the certification and private keys in file system.' => 'V tomto způsobu můžete editovat Certifikáty a Privátní Klíče přímo v Souborovém Systému.',

        # Template: AdminStateForm
        'State Management' => 'Správa Stavu',
        'Add State' => 'Přidat Stav',
        'Add a new State.' => 'Přidat nový Stav',
        'State Type' => 'Typ stavu',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Ujistěte se, že jste aktualizovali také výchozí hodnoty ve Vašem Kernel/Config.pm!',
        'See also' => 'Viz. také',

        # Template: AdminSysConfig
        'SysConfig' => '',
        'Group selection' => 'Výběr Skupiny',
        'Show' => 'Ukaž',
        'Download Settings' => 'Stáhnout Nastavení',
        'Download all system config changes.' => 'Stáhnout všechny Systémové Konfigurační změny.',
        'Load Settings' => 'Nahrát Nastavení',
        'Subgroup' => 'Podskupina',
        'Elements' => 'Prvky',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Sparáva Nastavení',
        'Default' => 'Defaultní',
        'New' => 'Nové',
        'New Group' => 'Nová Skupina',
        'Group Ro' => 'Skupina pouze pro čtení',
        'New Group Ro' => 'Nová Skupina pouze pro čtení',
        'NavBarName' => 'Jméno Navigační Lišty',
        'NavBar' => 'Navigační Lišta',
        'Image' => 'Obrázek',
        'Prio' => 'Priorita',
        'Block' => 'Brzdová Destička',
        'AccessKey' => 'Přístupový Klíč',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Správa emailových adres systému',
        'Add System Address' => 'Přidat Systémovou Adresu',
        'Add a new System Address.' => 'Přidat novou Systémovou Adresu',
        'Realname' => 'Skutečné jméno',
        'All email addresses get excluded on replaying on composing an email.' => 'Vyloučit všechny Emailové adresy v odpovědi nového mailu.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Všechny příchozí emaily obsahující tohoto adresáta (v poli KOMU) budou zařazeny to vybrané fronty!',

        # Template: AdminTypeForm
        'Type Management' => 'Správa Typů Tiketu',
        'Add Type' => 'Přidat Typ Tiketu',
        'Add a new Type.' => 'Přidat nový Typ Tiketu',

        # Template: AdminUserForm
        'User Management' => 'Správa uživatelů',
        'Add User' => 'Přidat Uživatele',
        'Add a new Agent.' => 'Přidat Řešitele',
        'Login as' => 'Přihlásit jako',
        'Firstname' => 'Křestní Jméno',
        'Lastname' => 'Příjmenní',
        'Start' => '',
        'End' => 'Konec',
        'User will be needed to handle tickets.' => 'Uživatel bude potřebovat práva pro správu tiketů.',
        'Don\'t forget to add a new user to groups and/or roles!' => '',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Uživatelé <-> Správa Skupin',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adresář',
        'Return to the compose screen' => 'Zpět do okna vytváření',
        'Discard all changes and return to the compose screen' => 'Zrušit všechny změny a vrátit se zpět do okna vytváření',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Nástěnka',

        # Template: AgentDashboardCalendarOverview
        'in' => 'v',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s je dostupný!',
        'Please update now.' => 'Aktualizujte prosím nyní',
        'Release Note' => 'Vypustit Poznámku',
        'Level' => 'Úroveň',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Odesláno před %s',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => '',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Svázat Objekt: %s',
        'Object' => 'Objekt',
        'Link Object' => 'Svázat Objekt',
        'with' => 's',
        'Select' => 'Vybrat',
        'Unlink Object: %s' => 'Zrušit Vazbu Objektu: %s',

        # Template: AgentLookup
        'Lookup' => 'Vyhledávání',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Funkce na kontrolu pravopisu',
        'spelling error(s)' => 'chyba(y) v pravopisu',
        'or' => 'nebo',
        'Apply these changes' => 'Aplikovat tyto změny',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Opravdu smazat tento Objekt?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Vyberte omezení pro charakteristiku Reportu',
        'Fixed' => 'pevně stanoveno',
        'Please select only one element or turn off the button \'Fixed\'.' => '',
        'Absolut Period' => 'Absolutní Interval',
        'Between' => 'Mezi',
        'Relative Period' => 'Relativní Interval',
        'The last' => 'Poslední',
        'Finish' => 'Ukončit',
        'Here you can make restrictions to your stat.' => 'Zde je možné provést omezení Statistik',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => '',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Vložení společných upřesnění',
        'Permissions' => 'Oprávnění',
        'Format' => '',
        'Graphsize' => 'Velikost Grafu',
        'Sum rows' => 'Součet řádků',
        'Sum columns' => 'Součet Sloupců',
        'Cache' => 'Vyrovnávací paměť',
        'Required Field' => 'Povinné Pole',
        'Selection needed' => 'Nutný Výběr',
        'Explanation' => 'Legenda',
        'In this form you can select the basic specifications.' => 'V tomto Formuláři můžete vybrat základní specifikace.',
        'Attribute' => 'Atribut',
        'Title of the stat.' => 'Jméno Statistiky',
        'Here you can insert a description of the stat.' => 'Zde můžete vložit popis Statistiky',
        'Dynamic-Object' => 'Dynamický Objekt',
        'Here you can select the dynamic object you want to use.' => 'Zde můžete vybrat Dinamický Objekt, který chcete použít.',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Poznámka: počet možných použitých Dynamických Objektů je závislý na typu Instalace)',
        'Static-File' => 'Statický Soubor',
        'For very complex stats it is possible to include a hardcoded file.' => 'Do hodně komplexních Reportů je možné zahrnout zakódované soubory.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'V případě nového dostupného Zakódovaného Souboru bude zobrazen příznak a bude možné jej vybrat.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Nastavení Oprávnění. Na základě selekce Skupin můžete report zviditelnit různým Řešitelům.',
        'Multiple selection of the output format.' => 'Výběr ze Selekce výstupního formátu.',
        'If you use a graph as output format you have to select at least one graph size.' => 'Při použití grafu jako výstupního formátu, je nutno vybrat alespoň jednu velikost grafu.',
        'If you need the sum of every row select yes' => 'Je-li vyžadován součet všech řádků, vyberte ANO',
        'If you need the sum of every column select yes.' => 'Je-li vyžadován součet všech sloupců, vyberte ANO',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'Většina Reportů může být uložena do mezipaměti. Toto urychlí jejich následnou presentaci.',
        '(Note: Useful for big databases and low performance server)' => '(Poznámka: vhodné pro obsáhlé databáze a méně výkoné servery)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => '',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => '',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Vybrat prvky pro řadu hodnot',
        'Scale' => 'Měřítko',
        'minimal' => 'minimální',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => '',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Vybrat prvek pro osu X',
        'maximal period' => 'maximální interval',
        'minimal scale' => 'minimální měřítko',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',

        # Template: AgentStatsImport
        'Import' => '',
        'File is not a Stats config' => 'Soubor není nastavením Reportu',
        'No File selected' => 'Nebyl vybrán soubor',

        # Template: AgentStatsOverview
        'Results' => 'Výsledky',
        'Total hits' => 'Celkový počet záznamů',
        'Page' => 'Strana',

        # Template: AgentStatsPrint
        'Print' => 'Tisknout',
        'No Element selected.' => 'Nebyl vybrán prvek',

        # Template: AgentStatsView
        'Export Config' => 'Exportovat nastavení',
        'Information about the Stat' => 'Informace o Reportu',
        'Exchange Axis' => 'Exchange osy',
        'Configurable params of static stat' => 'Konfigurovatelné parametry Statického Reportu',
        'No element selected.' => 'Nebyl vybrán prvek',
        'maximal period from' => 'maximální perioda z',
        'to' => 'komu',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => '',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'Zpráva by měla obsahovat Komu: příjemce!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Musíte mít  uvedenu emailovou adresu (např. klient@priklad.cz) v poli Komu:!',
        'Bounce ticket' => 'Odeslat tiket zpět',
        'Ticket locked!' => 'Tiket zamknut!',
        'Ticket unlock!' => 'Tiket odemknut!',
        'Bounce to' => 'Odeslat zpět',
        'Next ticket state' => 'Následující stav tiketu',
        'Inform sender' => 'Informovat odesílatele',
        'Send mail!' => 'Poslat mail!',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Potøebujete úètovat dobu!',
        'Ticket Bulk Action' => 'Hromadná akce Tiketu',
        'Spell Check' => 'Kontrola pravopisu',
        'Note type' => 'Typ poznámky',
        'Next state' => 'Nasledující stav',
        'Pending date' => 'Datum èekání na vyøízení',
        'Merge to' => 'Spojit s',
        'Merge to oldest' => 'Spojit s nejstarším',
        'Link together' => 'spárovat dohlromady',
        'Link to Parent' => 'Spárovat s mateřským',
        'Unlock Tickets' => 'Odemknout Tikety',

        # Template: AgentTicketClose
        'Ticket Type is required!' => '',
        'A required field is:' => '',
        'Close ticket' => 'Zavřít tiket',
        'Previous Owner' => 'Předchozí vlastník',
        'Inform Agent' => '',
        'Optional' => '',
        'Inform involved Agents' => '',
        'Attach' => 'Připojit',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Zpráva musí být pravopisně zkontrolovaná!',
        'Compose answer for ticket' => 'Sestavit odpověď pro tiket',
        'Pending Date' => 'Očekávaný čas vyřízení',
        'for pending* states' => 'pro stavy očekávání*',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Změnit klienta tiketu',
        'Set customer user and customer id of a ticket' => 'Nastavit klienta a nastavit ID klienta tiketu',
        'Customer User' => 'Uživatelé Zákazníka',
        'Search Customer' => 'Vyhledat Zákazníka',
        'Customer Data' => 'Data Zákazníka',
        'Customer history' => 'Historie Zákazníka',
        'All customer tickets.' => 'Všechny tikety Zákazníka',

        # Template: AgentTicketEmail
        'Compose Email' => 'Napsat Email',
        'new ticket' => 'nový tiket',
        'Refresh' => 'Obnovit',
        'Clear To' => 'Vyčistit',
        'All Agents' => 'Všichni Řešitelé',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Typ položky',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Změnit úplný text tiketu',

        # Template: AgentTicketHistory
        'History of' => 'Historie',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Notno použít číslo Tiketu',
        'Ticket Merge' => 'Sloučení Tiketu',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => 'Jestli chcete počítat čas, poskytněte Předmět a Text!',
        'Move Ticket' => 'Přesunout tiket',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Přidat poznámku k tiketu',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Čas první reakce',
        'Service Time' => 'Servisní čas',
        'Update Time' => 'Čas Aktualizace',
        'Solution Time' => 'Čas Řešení',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Nutno vybrat alespoň jeden Tiket!',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filtr',
        'Change search options' => 'Změnit možnosti vyhledávání',
        'Tickets' => 'Tikety',
        'of' => 'z',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Odpovědět',
        'Contact customer' => 'Kontaktovat klienta',
        'Change queue' => 'Změnit frontu',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'Třídit vzestupně',
        'up' => 'nahoru',
        'sort downward' => 'Třídit sestupně',
        'down' => 'dolů',
        'Escalation in' => 'Eskalace v',
        'Locked' => 'Uzamčeno',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Změnit vlastníka tiketu',

        # Template: AgentTicketPending
        'Set Pending' => 'Nastavit - čeká na vyřízení',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefoní hovor',
        'Clear From' => 'Vymazat pole Od',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Jednoduché',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informace o Tiketu',
        'Accounted time' => 'Účtovaná doba',
        'Linked-Object' => '',
        'by' => 'přes',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Změnit důležitost tiketu',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Zobrazené tikety',
        'Tickets available' => 'Tiketů k dispozici',
        'All tickets' => 'Všechny tikety',
        'Queues' => 'Řady',
        'Ticket escalation!' => 'Eskalace tiketů',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Změna Odpovědnosti Tiketu',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Hledání tiketu',
        'Profile' => 'Profil',
        'Search-Template' => 'Forma vyhledávání',
        'TicketFreeText' => 'Volný text tiketu',
        'Created in Queue' => 'Vytvořeno ve Frontě',
        'Article Create Times' => 'Čas vytvoření Článku',
        'Article created' => 'Článek vytvořen',
        'Article created between' => 'Článek vytvořen mezi',
        'Change Times' => 'Změna časů',
        'No change time settings.' => 'Žádná nastavení změny Času',
        'Ticket changed' => 'Tiket změněn',
        'Ticket changed between' => 'Tiket změněn mezi',
        'Result Form' => 'Forma výsledku',
        'Save Search-Profile as Template?' => 'Uložit profil vyhledávání jako šablonu?',
        'Yes, save it with name' => 'Ano, uložit pod názvem',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => '',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Rozšířený pohled',
        'Collapse View' => 'Zkrácený pohled',
        'Split' => 'Rozdělit',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Nastavení Filtru Článku',
        'Save filter settings as default' => 'Uložit Filtr jako Implicitní',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Jít zpět',

        # Template: CustomerFooter
        'Powered by' => 'Vytvořeno',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Přihlášení',
        'Lost your password?' => 'Ztratil/a jste heslo?',
        'Request new password' => 'Požádat o nové heslo',
        'Create Account' => 'Vytvořit účet',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Vítejte %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Doba',
        'No time settings.' => 'Žádná nastavení času',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klikněte zde pro nahlášení chyby!',

        # Template: Footer
        'Top of Page' => 'Nahoru',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Domů',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-instalátor',
        'Welcome to %s' => 'Vítejte v %s',
        'Accept license' => 'Přijmout licenci',
        'Don\'t accept license' => '',
        'Admin-User' => 'Administrátor',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => '',
        'Admin-Password' => 'Heslo Administrátora',
        'Database-User' => 'Uživatel',
        'default \'hot\'' => 'výchozí \'hot\'',
        'DB connect host' => 'Spojení s DB ztraceno',
        'Database' => 'Databáze',
        'Default Charset' => 'Výchozí znaková sada',
        'utf8' => '',
        'false' => 'Nepravda',
        'SystemID' => 'Systémové ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Identita systému. Každé číslo tiketu a ID každá HTTP relace začíná tímto číslem)',
        'System FQDN' => 'Systém FQDN',
        '(Full qualified domain name of your system)' => '(Platný název domény pro váš systém (FQDN))',
        'AdminEmail' => 'Email Administrátora',
        '(Email of the system admin)' => '(Email administrátora systému)',
        'Organization' => 'Organizace',
        'Log' => '',
        'LogModule' => 'Log Modul',
        '(Used log backend)' => '(Použit výstup do logu)',
        'Logfile' => 'Log soubor',
        '(Logfile just needed for File-LogModule!)' => '(Pro logování do souboru je nutné zadat název souboru logu!)',
        'Webfrontend' => 'Webove rozhraní',
        'Use utf-8 it your database supports it!' => 'Použijte utf-8 pokud to Vaše databáze podporuje',
        'Default Language' => 'Výchozí jazyk',
        '(Used default language)' => '(Použitý výchozí jazyk)',
        'CheckMXRecord' => 'Kontrola MX záznamu',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontroluj MX záznamy použitých emailových adres při sestavování odpovědi. Nepoužívejte pokud OTRS server připojen pomocí vytáčené linky!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'Abyste mohli používat OTRS, musíte zadat následující řádek do Vašeho příkazového řádku (Terminal/Shell) jako root.',
        'Restart your webserver' => 'Restartujte Váš webserver',
        'After doing so your OTRS is up and running.' => 'Po dokončení následujících operací je Váš OTRS spuštěn a poběží',
        'Start page' => 'Úvodní stránka',
        'Your OTRS Team' => 'Váš OTRS tým',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Nedostatečná práva',

        # Template: Notify
        'Important' => 'Důležité',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'tisknuto',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'Testovací OTRS stránka',
        'Counter' => 'Počítadlo',

        # Template: Warning

        # Template: YUI

        # Misc
        'Create Database' => 'Vytvořit Databazi',
        'DB Host' => 'Hostitel (server) databáze',
        'Change roles <-> groups settings' => 'Změna Rolí <-> Nastavení Skupin',
        'Ticket Number Generator' => 'Generátor čísel tiketů',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Identifikátor tiketů. Nekteří lidé chtějí nastavit např. \'Tiket#\',  \'Hovor#\' nebo \'MujTiket#\')',
        'Create new Phone Ticket' => 'Vytvořit nový Telefonní Tiket',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'V tomto zúůsobu můžete přímo editovat Keyring konfigurovaný v Kernelu pm.',
        'Symptom' => 'Příznak',
        'U' => 'Z-A',
        'Site' => 'Umístění',
        'Customer history search (e. g. "ID342425").' => 'Vyhledávání historie klienta (např. "ID342425")',
        'Can not delete link with %s!' => 'Nemožné smazat spárování s %s',
        'for agent firstname' => 'pro křestní jméno agenta',
        'Close!' => 'Zavřít!',
        'No means, send agent and customer notifications on changes.' => 'Ne znamená: poslat Řešiteli i Zákazníkovi oznámení při změně',
        'A web calendar' => 'WEB Kalendář',
        'to get the realname of the sender (if given)' => 'pro získaní skutečného jména odesílatele (pokud je zadáno)',
        'OTRS DB Name' => 'Název OTRS databáze',
        'Notification (Customer)' => 'Oznámení (Zákazníkovi)',
        'Select Source (for add)' => 'Vybrat zdroj (pro přidání)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
        'Child-Object' => 'Podřízený Objekt',
        'Queue ID' => 'ID fronty',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Možnosti Nastavení (příklad: <OTRS?CONFIG?HttpType>)',
        'System History' => 'Historie Systému',
        'customer realname' => 'skutečné jméno klienta',
        'Pending messages' => 'Zprávy čekající na vyřízení',
        'Port' => '',
        'Modules' => 'Moduly',
        'for agent login' => 'pro přihlášení Řešitele',
        'Keyword' => 'Klíčové slovo',
        'Close type' => 'Zavřít typ',
        'DB Admin User' => 'Administrátor databáze',
        'for agent user id' => 'pro uživatelské ID agenta',
        'Change user <-> group settings' => 'Změnit uživatele <-> nastavení skupiny',
        'Problem' => 'Problém',
        'Escalation' => 'Eskalace',
        '"}' => '',
        'Order' => 'Seřadit',
        'next step' => 'další krok',
        'Follow up' => 'Následující',
        'Customer history search' => 'Vyhledávání historie klienta',
        'Admin-Email' => 'Email administrátora',
        'Stat#' => '',
        'ArticleID' => 'ID polo¾ky',
        'Keywords' => 'Klíèová slova',
        'Ticket Escalation View' => '',
        'Today' => '',
        'No * possible!' => '®ádná * mo¾ná!',
        'Options ' => '',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Message for new Owner' => 'Zpráva pro nového vlastníka',
        'to get the first 5 lines of the email' => 'pro získání prvních 5 řádků z emailu',
        'Sort by' => 'Třídit dle',
        'OTRS DB Password' => 'Heslo OTRS databáze',
        'Last update' => 'Poslední aktualizace',
        'Tomorrow' => 'Zítra',
        'to get the first 20 character of the subject' => 'pro získáni prvních 20 znaků z předmětu',
        'Select the customeruser:service relations.' => 'Vybrat Uživatele Zákazníka: vazba ke službě',
        'DB Admin Password' => 'Heslo administrátora databáze',
        'Advisory' => 'Poradenství',
        'Drop Database' => 'Odstranit databazi',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => '',
        'FileManager' => 'Správce Souborů',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => '',
        'Pending type' => 'Typ čekání na vyřízení',
        'Comment (internal)' => 'Komentář (interní)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Možnosti Vlastníka Tiketu (příklad: &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Možnosti dat Tiketu (příklad: <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Použitý formát čísel tiketů)',
        'Reminder' => 'Upomínka',
        'OTRS DB connect host' => 'Hostitel OTRS databáze (server)',
        'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Nebude-li tiket odpovězen v daném čase, bude zobrazen pouze tento Tiket.',
        'All Agent variables.' => 'Všechny Proměnné Řešitele',
        ' (work units)' => '(jednotky práce)',
        'Next Week' => 'Další Týden',
        'All Customer variables like defined in config option CustomerUser.' => '',
        'accept license' => 'souhlasím s licencí',
        'for agent lastname' => 'pro příjmení agenta',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Možnosti stávajícího Uživatele požadujícího tuto akci (příklad: <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Upomínkové zprávy',
        'Parent-Object' => 'Nadřazený Objekt',
        'Of couse this feature will take some system performance it self!' => 'Při nastání tohoto jevu dojde k poklesu výkonu',
        'Ticket Hook' => 'Označení tiketu',
        'Your own Ticket' => 'Váš vlastní tiket',
        'Detail' => '',
        'TicketZoom' => 'Zobrazení tiketu',
        'Open Tickets' => 'Otevřít Tikety',
        'Don\'t forget to add a new user to groups!' => 'Nezapomeňte přidat nového uživatele do skupin!',
        'CreateTicket' => 'Vytvořeno Tiketu',
        'You have to select two or more attributes from the select field!' => 'Nutno zvolit dva a více atributů z výběrového pole!',
        'System Settings' => 'Nastavení systému',
        'WebWatcher' => 'Webový Prohlížeč',
        'Finished' => 'Dokončeno',
        'Account Type' => 'Typ Účtu',
        'D' => 'A-Z',
        'System Status' => 'Status Systému',
        'All messages' => 'Všechny zprávy',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Možnosti dat Tiketu (příklad: <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Object already linked as %s.' => 'Objekt je již spárován jako %s',
        'A article should have a title!' => 'Článek by měl mít nadpis!',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Možnosti Nastavení (příklad: &lt;OTRS_CONFIG_HttpType&gt;)',
        'don\'t accept license' => 'nesouhlasím s licencí',
        'All email addresses get excluded on replaying on composing and email.' => '',
        'A web mail client' => 'Web Email Klient',
        'Compose Follow up' => 'Sestavit následující',
        'WebMail' => 'Web Mail',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Možnosti Vlastníka Tiketu (příklad: <OTRS_OWNER_UserFirstname>)',
        'DB Type' => 'Typ databáze',
        'kill all sessions' => 'Zrušit všechny relace',
        'to get the from line of the email' => 'pro získaní řádku Od z emailu',
        'Solution' => 'Řešení',
        'QueueView' => 'Náhled fronty',
        'Select Box' => 'Požadavek na SQL databázi',
        'New messages' => 'Nové zprávy',
        'Can not create link with %s!' => 'Není možné vytvořit vazbu s %s',
        'Linked as' => 'Spárováno jako',
        'Welcome to OTRS' => 'Vítejte v OTRS',
        'modified' => 'Upraveno',
        'Delete old database' => 'Smazat starou databázi',
        'A web file manager' => 'Webový Správce Souborů',
        'Have a lot of fun!' => 'Přejeme hodně úspěchů s OTRS!',
        'send' => 'poslat',
        'Send no notifications' => 'Neodesílat Notifikace',
        'Note Text' => 'Text poznámky',
        'POP3 Account Management' => 'Správa POP3 účtů',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'System State Management' => 'Správa stavu systému',
        'OTRS DB User' => 'Uživatel OTRS databáze',
        'Mailbox' => 'Po¹tovní schránka',
        'PhoneView' => 'Nový tiket / hovor',
        'maximal period form' => '',
        'TicketID' => 'ID tiketu',
        'Escaladed Tickets' => 'Eskalované Tikety',
        'Yes means, send no agent and customer notifications on changes.' => 'Ne znamená: Neposlat Řešiteli a Zákazníkovi oznámení při změně',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Váš email s číslem ticketu "<OTRS_TICKET>" je odeslán zpět na "<OTRS_BOUNCE_TO>". Kontaktujte tuto adresu pro další infromace.',
        'Ticket Status View' => 'Zobrazení Statutu Tiketu',
        'Modified' => 'Změněno',
        'Ticket selected for bulk action!' => 'Tiket vybrán pro Hromadnou Akci!',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
    };
    # $$STOP$$
    return;
}

1;
