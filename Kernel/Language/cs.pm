# --
# Kernel/Language/cs.pm - provides Czech language translation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# Copyright (C) 2003 Lukas Vicanek alias networ <lulka at centrum dot cz>
# Copyright (C) 2004 BENETA.cz, s.r.o. (Marta Macalkova, Vadim Buzek, Petr Ocasek) <info at beneta dot cz>
# Copyright (C) 2010 O2BS.com, s r.o. Jakub Hanus
# Copyright (C) 2010 Pavel <pavel.vilim at kodys.cz>
# Copyleft (cc-by) 2013 Katerina Bubenickova <katerina.bubenickova at plbbohnice dot cz>
# Copyleft (cc-by) 2013 Peter Pruchnerovic <peter.pruchnerovic at mall dot cz>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::cs;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-08-20 14:43:42

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M/%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %Y %T';
    $Self->{DateFormatShort}     = '%D/%M/%Y';
    $Self->{DateInputFormat}     = '%D/%M/%Y';
    $Self->{DateInputFormatLong} = '%D/%M/%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

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
        'more than ... ago' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Today' => 'Dnes',
        'Tomorrow' => 'Zítra',
        'Next week' => 'Příští týden',
        'day' => 'den',
        'days' => 'dní(dny)',
        'day(s)' => 'den(dní)',
        'd' => '',
        'hour' => 'hodina',
        'hours' => 'hodin(y)',
        'hour(s)' => 'hodin(a)(y)',
        'Hours' => 'Hodin(y)',
        'h' => 'h',
        'minute' => 'minuta',
        'minutes' => 'minut(y)',
        'minute(s)' => 'minut(a)(y)',
        'Minutes' => '',
        'm' => '',
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
        's' => '',
        'Time unit' => '',
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
        'Valid' => 'Platnost',
        'invalid' => 'neplatný',
        'Invalid' => '',
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
        'Need Action' => '',
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
        'Hits' => 'Přístupů',
        'Text' => 'Text',
        'Standard' => 'Standard',
        'Lite' => 'Omezená',
        'User' => 'Uživatel',
        'Username' => 'Uživatelské jméno',
        'Language' => 'Jazyk',
        'Languages' => 'Jazyky',
        'Password' => 'Heslo',
        'Preferences' => 'Předvolby',
        'Salutation' => 'Oslovení',
        'Salutations' => 'Pozdrav',
        'Signature' => 'Podpis',
        'Signatures' => 'Podpisy',
        'Customer' => 'Klient',
        'CustomerID' => 'ID klienta',
        'CustomerIDs' => 'ID klienta',
        'customer' => 'klient',
        'agent' => 'řešitel',
        'system' => 'systém',
        'Customer Info' => 'Informace o klientovi',
        'Customer Information' => 'Informace o klientovi',
        'Customer Company' => 'Společnost klienta',
        'Customer Companies' => '',
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
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontakty',
        'Export' => 'Exportovat',
        'Up' => 'Nahoru',
        'Down' => 'Dolu',
        'Add' => 'Přidat',
        'Added!' => 'Přidáno!',
        'Category' => 'Kategorie',
        'Viewer' => 'Prohlížeč',
        'Expand' => 'Rozbalit',
        'Small' => 'Malý',
        'Medium' => 'Střední',
        'Large' => 'Velký',
        'Date picker' => '',
        'New message' => 'Nová zpráva',
        'New message!' => 'Nová zpráva!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Prosím, odpovězte na tento (tyto) tiket(y) pro návrat do normálního náhledu fronty!',
        'You have %s new message(s)!' => 'Máte %s novou zprávu (nových zpráv)!',
        'You have %s reminder ticket(s)!' => 'Máte %s upomínkový(ch) tiket(ů)',
        'The recommended charset for your language is %s!' => 'Doporučená znaková sada pro Váš jazyk je %s!',
        'Change your password.' => 'Změňte si heslo.',
        'Please activate %s first!' => '',
        'No suggestions' => 'Žádné návrhy',
        'Word' => 'Slovo',
        'Ignore' => 'Ignorovat',
        'replace with' => 'nahradit čím',
        'There is no account with that login name.' => 'Žádný účet s tímto přihlašovacím jménem neexistuje.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Přihlášení neúspěšné! Vaše uživatelské jméno či heslo bylo zadáno nesprávně.',
        'There is no acount with that user name.' => '',
        'Please contact your administrator' => '',
        'Logout' => 'Odhlásit',
        'Logout successful. Thank you for using %s!' => 'Odhlášení bylo úspěsné. Děkujeme Vám za používání %s!',
        'Feature not active!' => 'Funkce je neaktivní!',
        'Agent updated!' => '',
        'Database Selection' => '',
        'Create Database' => 'Vytvořit Databazi',
        'System Settings' => 'Nastavení systému',
        'Mail Configuration' => 'Nastavení pošty',
        'Finished' => 'Dokončeno',
        'Install OTRS' => 'Instalovat OTRS',
        'Intro' => 'Úvod',
        'License' => 'Licence',
        'Database' => 'Databáze',
        'Configure Mail' => 'Nastavit poštu',
        'Database deleted.' => 'Databáze smazána.',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database already contains data - it should be empty!' => '',
        'Login is needed!' => 'Vyžadováno přihlášení!',
        'Password is needed!' => 'Vyžadováno heslo!',
        'Take this Customer' => 'Vybrat tohoto Zákazníka',
        'Take this User' => 'Vybrat tohoto uživatele',
        'possible' => 'možný',
        'reject' => 'zamítnout',
        'reverse' => 'reverzní',
        'Facility' => 'Vybavení',
        'Time Zone' => 'Časové pásmo',
        'Pending till' => 'Čekání na vyřízení do',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'Přiřadit podle emailu - pole KOMU:.',
        'Dispatching by selected Queue.' => 'Přiřadit do vybrané fronty.',
        'No entry found!' => 'Nebyl nalezen žádný záznam!',
        'Session invalid. Please log in again.' => 'Neplatné ID relace. Prosím, přihlašte se znovu.',
        'Session has timed out. Please log in again.' => 'Relace vypršela. Prosím, přihlašte se znovu.',
        'Session limit reached! Please try again later.' => 'Dosažen limit relací. Zkuste to prosím později.',
        'No Permission!' => 'Nemáte oprávnění!',
        '(Click here to add)' => '(Pro přidání klikněte zde)',
        'Preview' => 'Zobrazit',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Balíček nebyl korektně nainstalován! Prosím, přeinstalujte balíček.',
        '%s is not writable!' => '%s není zapisovatelné!',
        'Cannot create %s!' => 'Nemohu vytvořit %s!',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Máte nastaveno "Mimo kancelář". Přejete si to vypnout?',
        'Customer %s added' => 'Zákazník %s přidán',
        'Role added!' => 'Role přidána!',
        'Role updated!' => 'Role aktualizována!',
        'Attachment added!' => 'Příloha připojena!',
        'Attachment updated!' => 'Příloha aktualizována!',
        'Response added!' => 'Odpověď přidána!',
        'Response updated!' => 'Odpověď aktualizována!',
        'Group updated!' => 'Skupina přidána!',
        'Queue added!' => 'Fronta přidána!',
        'Queue updated!' => 'Fronta aktualizována!',
        'State added!' => 'Stav přidán!',
        'State updated!' => 'Stav aktualizován!',
        'Type added!' => 'Typ přidán!',
        'Type updated!' => 'Typ aktualizován!',
        'Customer updated!' => 'Zákazník aktualizován!',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Note: Company is invalid!' => '',
        'Mail account added!' => 'Poštovní účet přidán!',
        'Mail account updated!' => 'Poštovní účet aktualizován!',
        'System e-mail address added!' => 'Systémová e-mailová adresa přidána!',
        'System e-mail address updated!' => 'Systémová e-mailová adresa aktualizována!',
        'Contract' => 'Kontrakt',
        'Online Customer: %s' => 'Online Zákazník: %s',
        'Online Agent: %s' => 'Online Řešitel: %s',
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
        'PGP' => 'PGP',
        'PGP Key' => 'PGP klíč',
        'PGP Keys' => 'PGP klíče',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME certifikát',
        'S/MIME Certificates' => 'S/MIME certifikáty',
        'Office' => 'Kancelář',
        'Phone' => 'Telefon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobilní telefon',
        'Zip' => 'PSČ',
        'City' => 'Město',
        'Street' => 'Ulice',
        'Country' => 'Země',
        'Location' => 'Lokalita',
        'installed' => 'instalováno',
        'uninstalled' => 'odinstalováno',
        'Security Note: You should activate %s because application is already running!' =>
            'Bezpečnostní poznámka: Aktivujte %s protože aplikace stále běží!',
        'Unable to parse repository index document.' => '',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            '',
        'No packages, or no new packages, found in selected repository.' =>
            '',
        'Edit the system configuration settings.' => '',
        'printed at' => 'vytištěno na',
        'Loading...' => 'Nahrávám...',
        'Dear Mr. %s,' => 'Vážený Pane %s,',
        'Dear Mrs. %s,' => 'Vážená Paní %s,',
        'Dear %s,' => 'Vážený(á) %s,',
        'Hello %s,' => 'Dobrý den %s,',
        'This email address already exists. Please log in or reset your password.' =>
            '',
        'New account created. Sent login information to %s. Please check your email.' =>
            '',
        'Please press Back and try again.' => 'Prosím klikněte na "Zpět" a opakujte pokus',
        'Sent password reset instructions. Please check your email.' => '',
        'Sent new password to %s. Please check your email.' => '',
        'Upcoming Events' => 'Aktuální události',
        'Event' => 'Událost',
        'Events' => 'Události',
        'Invalid Token!' => 'Neplatný Token',
        'more' => 'další',
        'Collapse' => 'Zhroucení',
        'Shown' => 'Zobrazeno',
        'Shown customer users' => '',
        'News' => 'Novinky',
        'Product News' => 'Novinky o Produktu',
        'OTRS News' => 'Novinky OTRS',
        '7 Day Stats' => 'Statistiky za 7 dnů',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Mark' => '',
        'Unmark' => '',
        'Bold' => 'Tučně',
        'Italic' => 'Kurzíva',
        'Underline' => 'Podtržení',
        'Font Color' => 'Barva Písma',
        'Background Color' => 'Barva Pozadí',
        'Remove Formatting' => 'Odstranit Formátování',
        'Show/Hide Hidden Elements' => 'Zobrazit/Skrýt schované prvky',
        'Align Left' => 'Zarovnání Vlevo',
        'Align Center' => 'Zarovnání na Střed',
        'Align Right' => 'Zarovnání Vpravo',
        'Justify' => 'Formátovat',
        'Header' => 'Hlavička',
        'Indent' => 'Odsazení',
        'Outdent' => 'Zrušit Odsazení',
        'Create an Unordered List' => 'Vytvořit nesetříděný seznam',
        'Create an Ordered List' => 'Vytvořit setříděný seznam',
        'HTML Link' => 'HTML odkaz',
        'Insert Image' => 'Vložit Obrázek',
        'CTRL' => 'Ctrl',
        'SHIFT' => 'Shift',
        'Undo' => 'Krok Zpět',
        'Redo' => 'Znovuobnovit',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => '',

        # Template: AAACalendar
        'New Year\'s Day' => '',
        'International Workers\' Day' => '',
        'Christmas Eve' => '',
        'First Christmas Day' => '',
        'Second Christmas Day' => '',
        'New Year\'s Eve' => '',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

        # Template: AAAMonth
        'Jan' => 'Led',
        'Feb' => 'Úno',
        'Mar' => 'Bře',
        'Apr' => 'Dub',
        'May' => 'Kvě',
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
        'May_long' => 'Květen',
        'June' => 'Červen',
        'July' => 'Červenec',
        'August' => 'Srpen',
        'September' => 'Září',
        'October' => 'Říjen',
        'November' => 'Listopad',
        'December' => 'Prosinec',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Nastavení úspěšně aktualizováno!',
        'User Profile' => 'Uživatelský profil',
        'Email Settings' => 'Nastavení emailu',
        'Other Settings' => 'Ostatní nastavení',
        'Change Password' => 'Změna hesla',
        'Current password' => 'Stávající heslo',
        'New password' => 'Nové Heslo',
        'Verify password' => '',
        'Spelling Dictionary' => 'Slovník pro kontrolu pravopisu',
        'Default spelling dictionary' => '',
        'Max. shown Tickets a page in Overview.' => 'Max. zobrazených tiketů v přehledu na stránku',
        'The current password is not correct. Please try again!' => 'Současné heslo nesouhlasí. Zkuste to prosím znovu!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Nelze zaktualizovat heslo, Vaše nová hesla si neodpovídají. Zkuste to prosím znovu!',
        'Can\'t update password, it contains invalid characters!' => 'Nelze zaktualizovat heslo, protože obsahuje neplatné znaky. Zkuste to prosím znovu!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Nelze zaktualizovat heslo, protože neobsahuje minimálně %s znaků. Zkuste to prosím znovu!',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Nelze zaktualizovat heslo, protože neobsahuje alespoň 1 číslici!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Nelze zaktualizovat heslo, protože neobsahuje alespoň 2 znaky!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Nelze zaktualizovat heslo, protože toto heslo bylo již jednou použito. Zvolte prosím nové!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            '',
        'CSV Separator' => '',

        # Template: AAAStats
        'Stat' => 'Statistika',
        'Sum' => '',
        'Please fill out the required fields!' => 'Prosím vyplňte povinná pole!',
        'Please select a file!' => 'Prosím vyberte soubor!',
        'Please select an object!' => 'Prosím zvolte objekt!',
        'Please select a graph size!' => 'Prosím zvolte velikost grafu!',
        'Please select one element for the X-axis!' => 'Prosím vyberte jeden prvek pro osu X!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            '',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Je-li použito zaškrtávací políčko, je nutno zvolit atribut zvoleného pole!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            '',
        'The selected end time is before the start time!' => 'Zvolené Konečné datum je před Počátečním datem!',
        'You have to select one or more attributes from the select field!' =>
            'Musí být zvolen jeden nebo více atributů z vybraného pole!',
        'The selected Date isn\'t valid!' => '',
        'Please select only one or two elements via the checkbox!' => 'Prosím vyberte jeden nebo dva prvky pomocí zaškrtávacího políčka!',
        'If you use a time scale element you can only select one element!' =>
            'Při použití časového měřítka je možné vybrat pouze jeden prvek!',
        'You have an error in your time selection!' => 'Chyba ve zvoleném čase!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Příliš malý časový interval pro report, prosím zvolte větší rozsah!',
        'The selected start time is before the allowed start time!' => 'Zvolený počátek je před povoleným počátkem!',
        'The selected end time is after the allowed end time!' => 'Zvolený konec je po povoleném konci!',
        'The selected time period is larger than the allowed time period!' =>
            'Zvolená perioda je delší, než povolená!',
        'Common Specification' => 'Všeobecné nastavení',
        'X-axis' => 'Osa X',
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
        'Status View' => '',
        'Bulk' => '',
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
        'Queues' => 'Řady',
        'Priority' => 'Priorita',
        'Priorities' => '',
        'Priority Update' => 'Oprava Priority',
        'Priority added!' => '',
        'Priority updated!' => '',
        'Signature added!' => '',
        'Signature updated!' => '',
        'SLA' => '',
        'Service Level Agreement' => '',
        'Service Level Agreements' => '',
        'Service' => 'Služba',
        'Services' => '',
        'State' => 'Stav',
        'States' => '',
        'Status' => 'Stav',
        'Statuses' => '',
        'Ticket Type' => '',
        'Ticket Types' => '',
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
        'This message was written in a character set other than your own.' =>
            'Tato zpráva byla napsána v jiné znakové sadě než Vaše.',
        'If it is not displayed correctly,' => 'Pokud není zobrazeno správně,',
        'This is a' => 'Toto je',
        'to open it in a new window.' => 'pro otevření v novém okně.',
        'This is a HTML email. Click here to show it.' => 'Toto je HTML email. Pro zobrazení klikněte zde.',
        'Free Fields' => 'Prázdná pole',
        'Merge' => 'Sloučit',
        'merged' => 'Sloučeno',
        'closed successful' => 'uzavřeno - vyřešeno',
        'closed unsuccessful' => 'uzavřeno - nevyřešeno',
        'Locked Tickets Total' => 'Zamčené Tikety - Všechny',
        'Locked Tickets Reminder Reached' => '',
        'Locked Tickets New' => 'Zamčené Tikety - Nové',
        'Responsible Tickets Total' => '',
        'Responsible Tickets New' => '',
        'Responsible Tickets Reminder Reached' => '',
        'Watched Tickets Total' => '',
        'Watched Tickets New' => '',
        'Watched Tickets Reminder Reached' => '',
        'All tickets' => 'Všechny tikety',
        'Available tickets' => 'Tiketů k dispozici',
        'Escalation' => 'Eskalace',
        'last-search' => '',
        'QueueView' => 'Náhled fronty',
        'Ticket Escalation View' => 'Zobrazit eskalaci tiketu',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => 'nová',
        'open' => 'otevřený',
        'Open' => 'Otevřít',
        'Open tickets' => 'Otevřené tikety',
        'closed' => 'uzavřeno',
        'Closed' => 'Uzavřeno',
        'Closed tickets' => 'Uzavřené tikety',
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
        'normal' => 'normální',
        'high' => 'vysoký',
        'very high' => 'velmi vysoká',
        '1 very low' => '1 velmi nízká',
        '2 low' => '2 nízká',
        '3 normal' => '3 normální',
        '4 high' => '4 vysoká',
        '5 very high' => '5 velmi vysoká',
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Create' => 'Vytvořit',
        'Answer' => '',
        'Phone call' => 'Telefoní hovor',
        'Ticket "%s" created!' => 'Tiket "%s" vytvořen!',
        'Ticket Number' => 'číslo tiketu',
        'Ticket Object' => 'Tiket Objekt',
        'No such Ticket Number "%s"! Can\'t link it!' => '',
        'You don\'t have write access to this ticket.' => '',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Please change the owner first.' => '',
        'Ticket selected.' => '',
        'Ticket is locked by another agent.' => '',
        'Ticket locked.' => '',
        'Don\'t show closed Tickets' => 'Nezobrazovat uzavřené tikety',
        'Show closed Tickets' => 'Zobrazit zavřené tikety',
        'New Article' => 'Nová položka',
        'Unread article(s) available' => '',
        'Remove from list of watched tickets' => '',
        'Add to list of watched tickets' => '',
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
        'Address %s replaced with registered customer address.' => '',
        'Customer automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Přehled všech otevřených tiketů',
        'Locked Tickets' => 'Uzamčené tikety',
        'My Locked Tickets' => 'Moje zamčené tikety',
        'My Watched Tickets' => '',
        'My Responsible Tickets' => '',
        'Watched Tickets' => 'Zobrazené tikety',
        'Watched' => 'Zobrazené',
        'Watch' => '',
        'Unwatch' => '',
        'Lock it to work on it' => 'Uzamknout pro práci',
        'Unlock to give it back to the queue' => 'Odemknout zpět do Fronty',
        'Show the ticket history' => 'Zobraz historii tiketu',
        'Print this ticket' => 'Vytisknout tiket',
        'Print this article' => 'Vytisknout tuto zprávu',
        'Split' => 'Rozdělit',
        'Split this article' => 'Rozdelit tuto zprávu',
        'Forward article via mail' => 'Přeposlat zprávu',
        'Change the ticket priority' => 'Změna Priority tiketu',
        'Change the ticket free fields!' => 'Změna volných polí tiketu',
        'Link this ticket to other objects' => 'Spárovat Tiket s jinými objekty',
        'Change the owner for this ticket' => 'Změna vlastníka tiketu',
        'Change the  customer for this ticket' => 'Změna Zákazníka Tiketu',
        'Add a note to this ticket' => 'Přidat poznámku do Tiketu',
        'Merge into a different ticket' => 'Sloučit do jiného tiketu',
        'Set this ticket to pending' => 'Nastavit jako čekající na vyřízení',
        'Close this ticket' => 'Uzavřít Tiket',
        'Look into a ticket!' => 'Náhled Tiketu',
        'Delete this ticket' => 'Smazat Tiket',
        'Mark as Spam!' => 'Označit jako SPAM',
        'My Queues' => 'Moje Fronty',
        'Shown Tickets' => 'Zobrazit Tikety',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Váš email s číslem Tiketu "<OTRS_TICKET>" je svázán s "<OTRS_MERGE_TO_TICKET>"',
        'Ticket %s: first response time is over (%s)!' => 'Tiket %s: Vypršel čas První Reakce (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Tiket %s: Čas První Reakce vyprší v %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiket %s: Vypršel čas Aktualizace (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiket %s: Čas Aktualizace vyprší v %s!',
        'Ticket %s: solution time is over (%s)!' => 'Tiket %s: Vypršel čas Řešení (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiket %s: Čas Řešení vyprší v %s!',
        'There are more escalated tickets!' => 'Je zde více Eskalovaných Tiketů',
        'Plain Format' => 'Zdrojový formát',
        'Reply All' => 'Odpovědět všem',
        'Direction' => '',
        'Agent (All with write permissions)' => '',
        'Agent (Owner)' => '',
        'Agent (Responsible)' => '',
        'New ticket notification' => 'Oznámení o novém Tiketu',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Pošli mi oznámení o novém Tiketu v mých frontách.',
        'Send new ticket notifications' => 'Poslat oznámení o novém tiketu',
        'Ticket follow up notification' => 'Oznámení o pokračování tiketu',
        'Ticket lock timeout notification' => 'Oznámení o vypršení času uzamčení tiketu',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Pošli mi oznámení, pokud je tiket odemknut systémem.',
        'Send ticket lock timeout notifications' => 'Poslat oznámení o odemčení tiketu systémem',
        'Ticket move notification' => 'Oznámení o přesunu tiketu',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Pošli mi oznámení pokud je Tiket přesunut do mých Front.',
        'Send ticket move notifications' => 'Poslat oznámení o přesunu tiketu',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => 'Vlastní fronta',
        'QueueView refresh time' => 'Doba obnovení náhledu fronty',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            '',
        'Refresh QueueView after' => 'Obnovit zobrazení front po',
        'Screen after new ticket' => 'Zobrazení po Novém Tiketu',
        'Show this screen after I created a new ticket' => 'Zobraz tento pohled, když vytvořím nový tiket',
        'Closed Tickets' => 'Uzavřené Tikety',
        'Show closed tickets.' => 'Ukázat uzavřené tikety.',
        'Max. shown Tickets a page in QueueView.' => 'Max. zobrazených tiketů v náhledu fronty na stránku',
        'Ticket Overview "Small" Limit' => '',
        'Ticket limit per page for Ticket Overview "Small"' => '',
        'Ticket Overview "Medium" Limit' => '',
        'Ticket limit per page for Ticket Overview "Medium"' => '',
        'Ticket Overview "Preview" Limit' => '',
        'Ticket limit per page for Ticket Overview "Preview"' => '',
        'Ticket watch notification' => '',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            '',
        'Send ticket watch notifications' => '',
        'Out Of Office Time' => '',
        'New Ticket' => 'Nový Tiket',
        'Create new Ticket' => 'Vytvořit nový Tiket',
        'Customer called' => 'Volal Zákazník',
        'phone call' => 'Telefonní volání',
        'Phone Call Outbound' => 'Odchozí telefonní hovor',
        'Phone Call Inbound' => 'Příchozí telefonní hovor',
        'Reminder Reached' => 'Dosažena Upomínka',
        'Reminder Tickets' => 'Upozornění na Tikety',
        'Escalated Tickets' => 'Eskalované Tikety',
        'New Tickets' => 'Nové Tikety',
        'Open Tickets / Need to be answered' => 'Otevřené Tikety / Nutno Odpovědět',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            '',
        'All new tickets, these tickets have not been worked on yet' => '',
        'All escalated tickets' => '',
        'All tickets with a reminder set where the reminder date has been reached' =>
            '',
        'Archived tickets' => 'Archivované tikety',
        'Unarchived tickets' => '',
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
        'History::Unlock' => 'Odemknutý Tiket.',
        'History::TimeAccounting' => '%s napočítaných časových jednotek. Součet všech je %s.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Aktualizováno: %s',
        'History::PriorityUpdate' => 'Priorita změněna z "%s" (%s) na "%s" (%s).',
        'History::OwnerUpdate' => 'Nový vlastník je "%s" (ID=%s).',
        'History::LoopProtection' => 'Přeposlání nepovoleno! Nebyla odeslána automatická odpověď na "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Aktualizováno: %s',
        'History::StateUpdate' => 'Starý: "%s" Nový: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Aktualizováno: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Webový požadavek Zákazníka.',
        'History::TicketLinkAdd' => 'Spárováno s Tiketem "%s".',
        'History::TicketLinkDelete' => 'Párování s tiketem "%s" zrušeno.',
        'History::Subscribe' => 'Přidána poznámka pro uživatele"%s".',
        'History::Unsubscribe' => 'Poznámka pro uživatele odebrána "%s".',
        'History::SystemRequest' => '',
        'History::ResponsibleUpdate' => '',
        'History::ArchiveFlagUpdate' => '',
        'History::TicketTitleUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'Ne',
        'Mon' => 'Po',
        'Tue' => 'Út',
        'Wed' => 'St',
        'Thu' => 'Čt',
        'Fri' => 'Pá',
        'Sat' => 'So',

        # Template: AdminACL
        'ACL Management' => '',
        'Filter for ACLs' => '',
        'Filter' => 'Filtr',
        'ACL Name' => '',
        'Actions' => 'Akce',
        'Create New ACL' => '',
        'Deploy ACLs' => '',
        'Export ACLs' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'Toto pole musí být vyplněno.',
        'Overwrite existing ACLs?' => '',
        'Upload ACL configuration' => '',
        'Import ACL configuration(s)' => '',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            '',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            '',
        'ACLs' => '',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            '',
        'ACL name' => '',
        'Validity' => 'Platnost',
        'Copy' => '',
        'No data found.' => 'Data nenalezena.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Go to overview' => 'Přejít na přehled',
        'Delete ACL' => '',
        'Delete Invalid ACL' => '',
        'Match settings' => '',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => '',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            '',
        'Check the official' => '',
        'documentation' => '',
        'Show or hide the content' => '',
        'Edit ACL information' => '',
        'Stop after match' => 'Stop po shodě',
        'Edit ACL structure' => '',
        'Save' => 'Uložit',
        'or' => 'nebo',
        'Save and finish' => '',
        'Do you really want to delete this ACL?' => '',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            '',
        'An item with this name is already present.' => '',
        'Add all' => '',
        'There was an error reading the ACL data.' => '',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAttachment
        'Attachment Management' => 'Správa příloh',
        'Add attachment' => 'Přidat přílohu',
        'List' => 'Pořadí',
        'Download file' => 'Stáhnout soubor',
        'Delete this attachment' => 'Smazat tuto přílohu',
        'Add Attachment' => 'Přidat přílohu',
        'Edit Attachment' => 'Upravit přílohu',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Správa automatických odpovědí',
        'Add auto response' => 'Přidat automatickou odpověď',
        'Add Auto Response' => 'Přidat Automatickou Odpověď',
        'Edit Auto Response' => 'Upravit automatickou odpověď',
        'Response' => 'Odpověď',
        'Auto response from' => 'Automatická odpověď od',
        'Reference' => '',
        'You can use the following tags' => '',
        'To get the first 20 character of the subject.' => 'pro získáni prvních 20ti znaků z předmětu',
        'To get the first 5 lines of the email.' => 'pro získáni prvních 5ti řádků z emailu',
        'To get the realname of the sender (if given).' => 'Pro získání Jména Odesílatele (je-li dáno)',
        'To get the article attribute' => 'Získat atributy článku',
        ' e. g.' => '',
        'Options of the current customer user data' => '',
        'Ticket owner options' => 'Nastavení vlastníka tiketu',
        'Ticket responsible options' => '',
        'Options of the current user who requested this action' => '',
        'Options of the ticket data' => '',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => '',
        'Example response' => 'Vzorová odpověď',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Správa Společnosti Zákazníka',
        'Wildcards like \'*\' are allowed.' => 'Pseudoznaky jako \'*\' jsou povolené',
        'Add customer company' => 'Přidat společnost zákazníka',
        'Select' => 'Vybrat',
        'Please enter a search term to look for customer companies.' => 'Prosím vlož hledaný výraz pro vyhledaní společnosti zákazníka',
        'Add Customer Company' => 'Přidat Společnost Zákazníka',

        # Template: AdminCustomerUser
        'Customer Management' => 'Správa zákazníků',
        'Back to search results' => '',
        'Add customer' => 'Přidat zákazníka',
        'Hint' => 'Nápověda',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            '',
        'Please enter a search term to look for customers.' => '',
        'Last Login' => 'Poslední přihlášení',
        'Login as' => 'Přihlásit jako',
        'Switch to customer' => '',
        'Add Customer' => 'Přidat zákazníka',
        'Edit Customer' => 'Upravit zákazníka',
        'This field is required and needs to be a valid email address.' =>
            '',
        'This email address is not allowed due to the system configuration.' =>
            '',
        'This email address failed MX check.' => '',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => '',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => '',
        'Notice' => 'Poznámka',
        'This feature is disabled!' => 'tato Funkce je Deaktivovaná!',
        'Just use this feature if you want to define group permissions for customers.' =>
            '',
        'Enable it here!' => 'Aktivujte ji Zde!',
        'Search for customers.' => 'Hledat zákazníka.',
        'Edit Customer Default Groups' => 'Upravit implicitní skupinu zákazníka',
        'These groups are automatically assigned to all customers.' => '',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            '',
        'Filter for Groups' => 'Filtr pro skupiny',
        'Select the customer:group permissions.' => 'Vybrat práva pro zákazníka:skupinu.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            '',
        'Search Results' => 'Výsledek vyhledávání',
        'Customers' => 'Zákazníci',
        'Groups' => 'Skupiny',
        'No matches found.' => 'Nenalezena žádná shoda.',
        'Change Group Relations for Customer' => '',
        'Change Customer Relations for Group' => '',
        'Toggle %s Permission for all' => '',
        'Toggle %s permission for %s' => '',
        'Customer Default Groups:' => '',
        'No changes can be made to these groups.' => '',
        'ro' => 'jen pro čtení',
        'Read only access to the ticket in this group/queue.' => 'Přístup pouze pro čtení tiketu v této skupině/frontě.',
        'rw' => 'čtení/psaní',
        'Full read and write access to the tickets in this group/queue.' =>
            'Plný přístup pro čtení a psaní do tiketů v této skupině/frontě.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => '',
        'Edit default services' => '',
        'Filter for Services' => '',
        'Allocate Services to Customer' => '',
        'Allocate Customers to Service' => '',
        'Toggle active state for all' => '',
        'Active' => 'Aktivní',
        'Toggle active state for %s' => '',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => 'Seřadit',
        'Object' => 'Objekt',
        'Delete this field' => '',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '',
        'Delete field' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => '',
        'Field' => '',
        'Go back to overview' => '',
        'General' => '',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            '',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            '',
        'Changing this value will require manual changes in the system.' =>
            '',
        'This is the name to be shown on the screens where the field is active.' =>
            '',
        'Field order' => '',
        'This field is required and must be numeric.' => '',
        'This is the order in which this field will be shown on the screens where is active.' =>
            '',
        'Field type' => '',
        'Object type' => '',
        'Internal field' => 'Interní pole',
        'This field is protected and can\'t be deleted.' => 'Toto pole je chráněno a nelze ho odstranit.',
        'Field Settings' => 'Nastavení pole',
        'Default value' => 'Výchozí hodnota',
        'This is the default value for this field.' => 'Toto je výchozí hodnota tohoto pole.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => '',
        'This field must be numeric.' => '',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => '',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '',
        'Years in the past to display (default: 5 years).' => '',
        'Years in the future' => '',
        'Years in the future to display (default: 5 years).' => '',
        'Show link' => '',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => 'Klíč',
        'Value' => 'Hodnota',
        'Remove value' => '',
        'Add value' => '',
        'Add Value' => '',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => 'Poznámka',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => '',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => '',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',

        # Template: AdminEmail
        'Admin Notification' => 'Admin Notifikace',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '',
        'Create Administrative Message' => '',
        'Your message was sent to' => '',
        'Send message to users' => '',
        'Send message to group members' => '',
        'Group members need to have permission' => '',
        'Send message to role members' => '',
        'Also send to customers in groups' => '',
        'Body' => 'Tělo',
        'Send' => 'Odeslat',

        # Template: AdminGenericAgent
        'Generic Agent' => '',
        'Add job' => '',
        'Last run' => 'Naposledy Spuštěno',
        'Run Now!' => 'Spustit Teď',
        'Delete this task' => '',
        'Run this task' => '',
        'Job Settings' => '',
        'Job name' => '',
        'Toggle this widget' => '',
        'Automatic execution (multiple tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => '',
        'Schedule hours' => '',
        'Schedule days' => '',
        'Currently this generic agent job will not run automatically.' =>
            'Aktuálně nebude Úloha Obecného Prostředu spouštěna automaticky',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Pro automatické spuštění vyberte alespoň jednu z hodnot: minuta, hodina a den!',
        'Event based execution (single ticket)' => '',
        'Event Triggers' => '',
        'List of all configured events' => '',
        'Delete this event' => '',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => '',
        'Ticket Filter' => '',
        '(e. g. 10*5155 or 105658*)' => '(např. 10*5155 or 105658*)',
        '(e. g. 234321)' => '(např. 234321)',
        'Customer login' => '',
        '(e. g. U5150)' => '(např. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => '',
        'Agent' => 'Řešitel',
        'Ticket lock' => '',
        'Create times' => '',
        'No create time settings.' => 'Žádná nastavení Času Vytvoření.',
        'Ticket created' => 'Tiket vytvořen',
        'Ticket created between' => 'Tiket vytvořen mezi',
        'Change times' => '',
        'No change time settings.' => 'Žádná nastavení změny Času',
        'Ticket changed' => 'Tiket změněn',
        'Ticket changed between' => 'Tiket změněn mezi',
        'Close times' => '',
        'No close time settings.' => 'Čas Uzavření - bez nastavení',
        'Ticket closed' => 'Uzavřené Tikety',
        'Ticket closed between' => 'Uzavřené Tikety mezi',
        'Pending times' => '',
        'No pending time settings.' => 'Nevyřešené Časy - bez nastavení',
        'Ticket pending time reached' => 'Dosažen Čas Řešení',
        'Ticket pending time reached between' => 'Dosažen Čas Řešení mezi',
        'Escalation times' => '',
        'No escalation time settings.' => 'Časy Eskalace - bez nastavení',
        'Ticket escalation time reached' => 'Dosažen Čas Eskalace',
        'Ticket escalation time reached between' => 'Dosažen Čas Eskalace mezi',
        'Escalation - first response time' => '',
        'Ticket first response time reached' => 'Dosažen Čas První Odpovědi',
        'Ticket first response time reached between' => 'Dosažen Čas První Odpovědi mezi',
        'Escalation - update time' => '',
        'Ticket update time reached' => 'Dosažen Čas Aktualizace',
        'Ticket update time reached between' => 'Dosažen Čas Aktualizace mezi',
        'Escalation - solution time' => '',
        'Ticket solution time reached' => 'Dosažen Čas Řešení',
        'Ticket solution time reached between' => 'Dosažen Čas Řešení mezi',
        'Archive search option' => '',
        'Ticket Action' => '',
        'Set new service' => '',
        'Set new Service Level Agreement' => '',
        'Set new priority' => '',
        'Set new queue' => '',
        'Set new state' => '',
        'Pending date' => 'Datum čekání na vyřízení',
        'Set new agent' => '',
        'new owner' => '',
        'new responsible' => '',
        'Set new ticket lock' => '',
        'New customer' => '',
        'New customer ID' => '',
        'New title' => '',
        'New type' => '',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => '',
        'Add Note' => 'Přidat poznámku',
        'Time units' => 'Jednotky času',
        '(work units)' => '(jednotky práce)',
        'Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'Odeslat upozornění Řešiteli/Zákazníkovi při změně',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Příkaz bude proveden. ARG[0] bude číslo Tiketu. ARG[1] ID Tiketu',
        'Delete tickets' => 'Vymazat Tikety',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            '',
        'Execute Custom Module' => '',
        'Param %s key' => '',
        'Param %s value' => '',
        'Save Changes' => '',
        'Results' => 'Výsledky',
        '%s Tickets affected! What do you want to do?' => '',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            '',
        'Edit job' => '',
        'Run job' => '',
        'Affected Tickets' => '',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Čas',
        'Remote IP' => '',
        'Loading' => '',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Obnovit',
        'Request Details' => '',
        'An error occurred during communication.' => '',
        'Clear debug log' => '',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => '',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Please provide a unique name for this web service invoker.' => '',
        'The name you entered already exists.' => '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => '',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Asynchronous' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => '',
        'Delete this Invoker' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => '',
        'Mapping Simple' => '',
        'Default rule for unmapped keys' => '',
        'This rule will apply for all keys with no mapping rule.' => '',
        'Default rule for unmapped values' => '',
        'This rule will apply for all values with no mapping rule.' => '',
        'New key map' => '',
        'Add key mapping' => '',
        'Mapping for Key ' => '',
        'Remove key mapping' => '',
        'Key mapping' => '',
        'Map key' => '',
        'matching the' => '',
        'to new key' => '',
        'Value mapping' => '',
        'Map value' => '',
        'to new value' => '',
        'Remove value mapping' => '',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => '',
        'Delete this Key Mapping' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => '',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => '',
        'Change operation %s' => '',
        'Do you really want to delete this operation?' => '',
        'Operation Details' => '',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => '',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => '',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => '',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => '',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'Certificate Password File' => '',
        'The password to open the SSL certificate.' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Proxy Server' => '',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => '',
        'The password for the proxy user.' => '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => '',
        'Clone web service' => '',
        'The name must be unique.' => '',
        'Clone' => '',
        'Export web service' => '',
        'Import web service' => '',
        'Configuration File' => '',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => '',
        'Configuration history' => '',
        'Delete web service' => '',
        'Do you really want to delete this web service?' => '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Details' => '',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => '',
        'Inbound mapping' => '',
        'Outbound mapping' => '',
        'Delete this action' => '',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',
        'Delete webservice' => '',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => '',
        'Import webservice' => '',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => '',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'Verze',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => '',
        'Restore' => '',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            '',
        'Group Management' => 'Správa skupiny',
        'Add group' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Skupina administrátora má přístup do administrační a statistické zóny.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            '',
        'It\'s useful for ASP solutions. ' => '',
        'Add Group' => 'Přidat Skupinu',
        'Edit Group' => '',

        # Template: AdminLog
        'System Log' => 'Log systému',
        'Here you will find log information about your system.' => '',
        'Hide this message' => '',
        'Recent Log Entries' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Správa Emailových Účtů',
        'Add mail account' => '',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Všechny příchozí emaily z daného účtu budou zařazeny do vybrané fronty!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            '',
        'Host' => 'Hostitel',
        'Delete account' => '',
        'Fetch mail' => '',
        'Add Mail Account' => '',
        'Example: mail.example.com' => '',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Ověřeno',
        'Dispatching' => 'Zařazení',
        'Edit Mail Account' => '',

        # Template: AdminNavigationBar
        'Admin' => '',
        'Agent Management' => '',
        'Queue Settings' => '',
        'Ticket Settings' => '',
        'System Administration' => '',

        # Template: AdminNotification
        'Notification Management' => 'Správa oznámení',
        'Select a different language' => '',
        'Filter for Notification' => '',
        'Notifications are sent to an agent or a customer.' => 'Oznámení jsou odeslána agentovi či klientovi',
        'Notification' => 'Upozornění',
        'Edit Notification' => '',
        'e. g.' => '',
        'Options of the current customer data' => '',

        # Template: AdminNotificationEvent
        'Add notification' => '',
        'Delete this notification' => '',
        'Add Notification' => 'Přidat oznámení',
        'Article Filter' => '',
        'Only for ArticleCreate event' => '',
        'Article type' => 'Typ položky',
        'Article sender type' => '',
        'Subject match' => 'Shoda Předmětu',
        'Body match' => 'Shoda Těla',
        'Include attachments to notification' => '',
        'Recipient' => 'Příjemce',
        'Recipient groups' => '',
        'Recipient agents' => '',
        'Recipient roles' => '',
        'Recipient email addresses' => '',
        'Notification article type' => '',
        'Only for notifications to specified email addresses' => '',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'pro získáni prvních 20ti znaků z předmětu (z nejnovějšího článku Řešitele)',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'pro získáni prvních 5ti řádků z těla (z nejnovějšího článku Řešitele)',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'pro získáni prvních 20ti znaků z předmětu (z nejnovějšího článku Zákazníka)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'pro získáni prvních 5ti řádků z těla (z nejnovějšího článku Zákazníka)',

        # Template: AdminPGP
        'PGP Management' => 'Správa PGP',
        'Use this feature if you want to work with PGP keys.' => '',
        'Add PGP key' => '',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'V tomto způsobu můžete Keyring, konfigurovaný v SysConfigu, editovat přímo',
        'Introduction to PGP' => '',
        'Result' => 'Výsledek',
        'Identifier' => 'Identifikátor',
        'Bit' => 'Kousek',
        'Fingerprint' => 'Otisk',
        'Expires' => 'Propadává',
        'Delete this key' => '',
        'Add PGP Key' => '',
        'PGP key' => '',

        # Template: AdminPackageManager
        'Package Manager' => 'Správa Balíčků',
        'Uninstall package' => '',
        'Do you really want to uninstall this package?' => 'Opravdu chcete odinstalovat tento Balíček?',
        'Reinstall package' => '',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            '',
        'Continue' => 'Pokračovat',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Instalovat',
        'Install Package' => '',
        'Update repository information' => '',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Online Schránka',
        'Vendor' => 'Prodavač',
        'Module documentation' => 'Dokumentace Modulu',
        'Upgrade' => 'Aktualizace',
        'Local Repository' => 'Lokální Schránka',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Odinstalovat',
        'Reinstall' => 'Reinstalovat',
        'Feature Add-Ons' => '',
        'Download package' => 'Stáhnout balíček',
        'Rebuild package' => 'Znovu vytvořit balíček',
        'Metadata' => '',
        'Change Log' => 'Seznam změn',
        'Date' => 'Datum',
        'List of Files' => 'Seznam souborů',
        'Permission' => 'Práva',
        'Download' => 'Stáhnout',
        'Download file from package!' => 'Stáhnout souboru z balíčku!',
        'Required' => 'Vyžadováno',
        'PrimaryKey' => 'Primární Klíč',
        'AutoIncrement' => 'Automatický Přírůstek',
        'SQL' => '',
        'File differences for file %s' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Log Výkonu',
        'This feature is enabled!' => 'Tato Funkce je Aktivována!',
        'Just use this feature if you want to log each request.' => 'Pro logování všech Požadavků stačí zapnout tuto Funkci',
        'Activating this feature might affect your system performance!' =>
            'Aktivace této Funkce může ovlivnit chod Systému!',
        'Disable it here!' => 'Deaktivujte ji Zde!',
        'Logfile too large!' => 'Příliš velký logfile',
        'The logfile is too large, you need to reset it' => '',
        'Overview' => 'Přehled',
        'Range' => 'Oblast',
        'last' => 'poslední',
        'Interface' => 'Rozhraní',
        'Requests' => 'Požadavky',
        'Min Response' => 'Minimální Odezva',
        'Max Response' => 'Maximální Odezva',
        'Average Response' => 'Průměrná Odezva',
        'Period' => 'Perioda',
        'Min' => '',
        'Max' => '',
        'Average' => 'Průměr',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Správa Filtru PostMaster',
        'Add filter' => '',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            '',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            '',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            '',
        'Delete this filter' => '',
        'Add PostMaster Filter' => '',
        'Edit PostMaster Filter' => '',
        'The name is required.' => '',
        'Filter Condition' => '',
        'AND Condition' => '',
        'Negate' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => '',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Správa priorit',
        'Add priority' => '',
        'Add Priority' => 'Přidat Prioritou',
        'Edit Priority' => '',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Process Name' => '',
        'Create New Process' => '',
        'Synchronize All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Print' => 'Tisknout',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Zruš & zavři okno',
        'Go Back' => '',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => '',
        'Activity Name' => '',
        'Activity Dialogs' => '',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            '',
        'Filter available Activity Dialogs' => '',
        'Available Activity Dialogs' => '',
        'Create New Activity Dialog' => '',
        'Assigned Activity Dialogs' => '',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Activity Dialog' => '',
        'Activity dialog Name' => '',
        'Available in' => '',
        'Description (short)' => '',
        'Description (long)' => '',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'Fields' => '',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => '',
        'Assigned Fields' => '',
        'Edit Details for Field' => '',
        'ArticleType' => '',
        'Display' => '',
        'Edit Field Details' => '',
        'Customer interface does not support internal article types.' => '',

        # Template: AdminProcessManagementPath
        'Path' => '',
        'Edit this transition' => '',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => '',
        'Filter Activities...' => '',
        'Create New Activity' => '',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => '',
        'Print process information' => '',
        'Delete Process' => '',
        'Delete Inactive Process' => '',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
        'Save settings' => '',
        'Save Activities, Activity Dialogs and Transitions' => '',
        'Do you really want to delete this Process?' => '',
        'Do you really want to delete this Activity?' => '',
        'Do you really want to delete this Activity Dialog?' => '',
        'Do you really want to delete this Transition?' => '',
        'Do you really want to delete this Transition Action?' => '',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            '',
        'Hide EntityIDs' => '',
        'Delete Entity' => '',
        'Remove Entity from canvas' => '',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            '',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            '',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            '',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            '',
        'Remove the Transition from this Process' => '',
        'No TransitionActions assigned.' => '',
        'The Start Event cannot loose the Start Transition!' => '',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            '',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            '',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            '',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => '',
        'Contains %s dialog(s)' => '',
        'Assigned dialogs' => '',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => '',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => '',
        'Conditions' => '',
        'Condition' => '',
        'Transitions are not being used in this process.' => '',
        'Module name' => '',
        'Configuration' => '',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => '',
        'Transition Name' => '',
        'Type of Linking between Conditions' => '',
        'Remove this Condition' => '',
        'Type of Linking' => '',
        'Remove this Field' => '',
        'Add a new Field' => '',
        'Add New Condition' => '',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Remove this Parameter' => '',
        'Add a new Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => '',
        'Add queue' => '',
        'Add Queue' => '',
        'Edit Queue' => '',
        'Sub-queue of' => '',
        'Unlock timeout' => 'Čas do odemknutí',
        '0 = no unlock' => '0 = žádné odemknutí',
        'Only business hours are counted.' => 'Počítají se pouze úřední hodiny',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '',
        'Notify by' => 'Upozorněno kým',
        '0 = no escalation' => '0 = žádné stupňování',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            '',
        'Follow up Option' => 'Následující volba',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            '',
        'Ticket lock after a follow up' => 'Zamknout tiket po následujícím',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            '',
        'System address' => '',
        'Will be the sender address of this queue for email answers.' => 'Bude adresou odesílatele z této fronty pro emailové odpovědi.',
        'Default sign key' => '',
        'The salutation for email answers.' => 'Oslovení pro emailové odpovědi.',
        'The signature for email answers.' => 'Podpis pro emailové odpovědi.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => '',
        'Filter for Queues' => '',
        'Filter for Auto Responses' => '',
        'Auto Responses' => 'Automatické Odpovědi',
        'Change Auto Response Relations for Queue' => '',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRole
        'Role Management' => 'Správa Rolí',
        'Add role' => '',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Vytvořit Roli a vložit do ní Skupiny. Následně přiřadit Roli Uživatelům.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            '',
        'Add Role' => 'Přidat Roli',
        'Edit Role' => '',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => '',
        'Filter for Roles' => '',
        'Roles' => 'Role',
        'Select the role:group permissions.' => '',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            '',
        'Change Role Relations for Group' => '',
        'Change Group Relations for Role' => '',
        'Toggle %s permission for all' => '',
        'move_into' => 'přesunout do',
        'Permissions to move tickets into this group/queue.' => 'Práva přesunout tikety do této skupiny/fronty',
        'create' => 'vytvořit',
        'Permissions to create tickets in this group/queue.' => 'Práva vytvořit tikety v této skupině/frontě',
        'priority' => 'priorita',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Práva změnit prioritu tiketu v této skupině/frontě',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => '',
        'Filter for Agents' => '',
        'Agents' => 'Řešitelé',
        'Manage Role-Agent Relations' => '',
        'Change Role Relations for Agent' => '',
        'Change Agent Relations for Role' => '',

        # Template: AdminSLA
        'SLA Management' => 'Správa SLA',
        'Add SLA' => 'Přidat SLA',
        'Edit SLA' => '',
        'Please write only numbers!' => '',

        # Template: AdminSMIME
        'S/MIME Management' => 'Správa S/MIME',
        'Add certificate' => '',
        'Add private key' => '',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Viz. také',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'V tomto způsobu můžete editovat Certifikáty a Privátní Klíče přímo v Souborovém Systému.',
        'Hash' => 'Kryptografický otisk',
        'Handle related certificates' => '',
        'Read certificate' => 'Prohlédnout certifikát',
        'Delete this certificate' => 'Smazat tento Certifikát',
        'Add Certificate' => 'Přidat Certifikát',
        'Add Private Key' => 'Přidat Privátní Klíč',
        'Secret' => 'Tajný',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => 'Dostupné Certifikáty',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => 'SMIME Certifikát',
        'Close window' => 'Zavřít okno',

        # Template: AdminSalutation
        'Salutation Management' => 'Správa oslovení',
        'Add salutation' => 'Přidat oslovení',
        'Add Salutation' => 'Přidat Oslovení',
        'Edit Salutation' => 'Upravit Oslovení',
        'Example salutation' => 'Příklad oslovení',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => '',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Bezpečnostní Mód bude (normálně) nastaven po dokončení iniciační instalace.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            '',

        # Template: AdminSelectBox
        'SQL Box' => '',
        'Here you can enter SQL to send it directly to the application database.' =>
            '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            '',
        'There is at least one parameter missing for the binding. Please check it.' =>
            '',
        'Result format' => '',
        'Run Query' => '',

        # Template: AdminService
        'Service Management' => 'Správa Služeb',
        'Add service' => '',
        'Add Service' => 'Přidat Službu',
        'Edit Service' => '',
        'Sub-service of' => '',

        # Template: AdminSession
        'Session Management' => 'Správa relace',
        'All sessions' => '',
        'Agent sessions' => '',
        'Customer sessions' => '',
        'Unique agents' => '',
        'Unique customers' => '',
        'Kill all sessions' => 'Ukončit všechny Relace',
        'Kill this session' => '',
        'Session' => 'Relace',
        'Kill' => '',
        'Detail View for SessionID' => '',

        # Template: AdminSignature
        'Signature Management' => 'Správa podpisů',
        'Add signature' => '',
        'Add Signature' => 'Přidat Podpis',
        'Edit Signature' => '',
        'Example signature' => '',

        # Template: AdminState
        'State Management' => 'Správa Stavu',
        'Add state' => '',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'Přidat Stav',
        'Edit State' => '',
        'State type' => '',

        # Template: AdminSysConfig
        'SysConfig' => '',
        'Navigate by searching in %s settings' => '',
        'Navigate by selecting config groups' => '',
        'Download all system config changes' => '',
        'Export settings' => '',
        'Load SysConfig settings from file' => '',
        'Import settings' => '',
        'Import Settings' => '',
        'Please enter a search term to look for settings.' => '',
        'Subgroup' => 'Podskupina',
        'Elements' => 'Prvky',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => '',
        'This config item is only available in a higher config level!' =>
            '',
        'Reset this setting' => '',
        'Error: this file could not be found.' => '',
        'Error: this directory could not be found.' => '',
        'Error: an invalid value was entered.' => '',
        'Content' => 'Obsah',
        'Remove this entry' => 'Odstranit tuto položku',
        'Add entry' => 'Přidat položku',
        'Remove entry' => 'Odstranit položku',
        'Add new entry' => 'Přidat novú položku',
        'Delete this entry' => '',
        'Create new entry' => 'Vytvořit novú položku',
        'New group' => '',
        'Group ro' => '',
        'Readonly group' => '',
        'New group ro' => '',
        'Loader' => '',
        'File to load for this frontend module' => '',
        'New Loader File' => '',
        'NavBarName' => 'Jméno Navigační Lišty',
        'NavBar' => 'Navigační Lišta',
        'LinkOption' => '',
        'Block' => 'Brzdová Destička',
        'AccessKey' => 'Přístupový Klíč',
        'Add NavBar entry' => '',
        'Year' => '',
        'Month' => '',
        'Day' => '',
        'Invalid year' => '',
        'Invalid month' => '',
        'Invalid day' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Správa emailových adres systému',
        'Add system address' => '',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            '',
        'Email address' => '',
        'Display name' => '',
        'Add System Email Address' => '',
        'Edit System Email Address' => '',
        'The display name and email address will be shown on mail you send.' =>
            '',

        # Template: AdminTemplate
        'Manage Templates' => '',
        'Add template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Add Template' => '',
        'Edit Template' => '',
        'Template' => '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'Aktuální stav tiketu je',
        'Your email address is' => '',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => '',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => '',
        'Link %s to selected %s' => '',

        # Template: AdminType
        'Type Management' => 'Správa Typů Tiketu',
        'Add ticket type' => '',
        'Add Type' => 'Přidat Typ Tiketu',
        'Edit Type' => '',

        # Template: AdminUser
        'Add agent' => 'Přidat řešitele',
        'Agents will be needed to handle tickets.' => '',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Nezapomeňte přidat nového řešitele do skupin a/nebo rolí!',
        'Please enter a search term to look for agents.' => 'Prosím vložte hledaný výraz pro hledání řešitelů.',
        'Last login' => 'Poslední přihlášení',
        'Switch to agent' => 'Přepnout na řešitele',
        'Add Agent' => 'Přidat řešitele',
        'Edit Agent' => 'Upravit řešitele',
        'Firstname' => 'Křestní Jméno',
        'Lastname' => 'Příjmenní',
        'Will be auto-generated if left empty.' => '',
        'Start' => '',
        'End' => 'Konec',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Spravovat vztahy mezi skupinami a řešiteli',
        'Change Group Relations for Agent' => '',
        'Change Agent Relations for Group' => '',
        'note' => 'poznámka',
        'Permissions to add notes to tickets in this group/queue.' => '',
        'owner' => 'vlastník',
        'Permissions to change the owner of tickets in this group/queue.' =>
            '',

        # Template: AgentBook
        'Address Book' => 'Adresář',
        'Search for a customer' => '',
        'Add email address %s to the To field' => '',
        'Add email address %s to the Cc field' => '',
        'Add email address %s to the Bcc field' => '',
        'Apply' => 'Použít',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => '',
        'Customer User' => 'Uživatelé Zákazníka',

        # Template: AgentCustomerSearch
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Nástěnka',

        # Template: AgentDashboardCalendarOverview
        'in' => 'v',

        # Template: AgentDashboardCommon
        'Available Columns' => '',
        'Visible Columns (order by drag & drop)' => '',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s je dostupný!',
        'Please update now.' => 'Aktualizujte prosím nyní',
        'Release Note' => 'Vypustit Poznámku',
        'Level' => 'Úroveň',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Odesláno před %s',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Moje uzamčené tikety',
        'My watched tickets' => 'Moje sledované tikety',
        'My responsibilities' => '',
        'Tickets in My Queues' => 'Tikety v mých frontách',
        'Service Time' => 'Servisní čas',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => 'mimo kancelář',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'do',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Tiket byl uzamčen',
        'Undo & close window' => 'Krok zpět & zavřít okno',

        # Template: AgentInfo
        'Info' => '',
        'To accept some news, a license or some changes.' => '',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Svázat Objekt: %s',
        'go to link delete screen' => '',
        'Select Target Object' => 'Vybrat cílový Objekt',
        'Link Object' => 'Svázat Objekt',
        'with' => 's',
        'Unlink Object: %s' => 'Zrušit Vazbu Objektu: %s',
        'go to link add screen' => '',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Upravit moje preference',

        # Template: AgentSpelling
        'Spell Checker' => 'Funkce na kontrolu pravopisu',
        'spelling error(s)' => 'chyba(y) v pravopisu',
        'Apply these changes' => 'Aplikovat tyto změny',

        # Template: AgentStatsDelete
        'Delete stat' => 'Smazat statistiky',
        'Stat#' => 'Číslo statistiky',
        'Do you really want to delete this stat?' => 'Opravdu chcete smazat tuto statistiku?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Krok %s',
        'General Specifications' => 'Obecné specifikace',
        'Select the element that will be used at the X-axis' => '',
        'Select the elements for the value series' => 'Vybrat prvky pro řadu hodnot',
        'Select the restrictions to characterize the stat' => '',
        'Here you can make restrictions to your stat.' => 'Zde je možné provést omezení Statistik',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            '',
        'Fixed' => 'pevně stanoveno',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            '',
        'Absolute Period' => '',
        'Between' => 'Mezi',
        'Relative Period' => 'Relativní Interval',
        'The last' => 'Poslední',
        'Finish' => 'Ukončit',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Oprávnění',
        'You can select one or more groups to define access for different agents.' =>
            '',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            '',
        'Please contact your administrator.' => '',
        'Graph size' => 'Velikost grafu',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Při použití grafu jako výstupního formátu, je nutno vybrat alespoň jednu velikost grafu.',
        'Sum rows' => 'Součet řádků',
        'Sum columns' => 'Součet Sloupců',
        'Use cache' => '',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Většina Reportů může být uložena do mezipaměti. Toto urychlí jejich následnou presentaci.',
        'If set to invalid end users can not generate the stat.' => '',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => '',
        'You have the possibility to select one or two elements.' => '',
        'Then you can select the attributes of elements.' => '',
        'Each attribute will be shown as single value series.' => '',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            '',
        'Scale' => 'Měřítko',
        'minimal' => 'minimální',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            '',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            '',
        'maximal period' => 'maximální interval',
        'minimal scale' => 'minimální měřítko',

        # Template: AgentStatsImport
        'Import Stat' => '',
        'File is not a Stats config' => 'Soubor není nastavením Reportu',
        'No File selected' => 'Nebyl vybrán soubor',

        # Template: AgentStatsOverview
        'Stats' => 'Reporty',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Nebyl vybrán prvek',

        # Template: AgentStatsView
        'Export config' => '',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            '',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            '',
        'Stat Details' => '',
        'Format' => '',
        'Graphsize' => 'Velikost Grafu',
        'Cache' => 'Vyrovnávací paměť',
        'Exchange Axis' => 'Exchange osy',
        'Configurable params of static stat' => 'Konfigurovatelné parametry Statického Reportu',
        'No element selected.' => 'Nebyl vybrán prvek',
        'maximal period from' => 'maximální perioda z',
        'to' => 'komu',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => '',
        'Change Owner of Ticket' => 'Změnit vlastníka Tiketu',
        'Close Ticket' => 'Uzavřít Tiket',
        'Add Note to Ticket' => 'Přidat poznámku k Tiketu',
        'Set Pending' => 'Nastavit - čeká na vyřízení',
        'Change Priority of Ticket' => 'Změnit prioritu Tiketu',
        'Change Responsible of Ticket' => '',
        'Service invalid.' => '',
        'New Owner' => 'Nový vlastník',
        'Please set a new owner!' => 'Prosím nastavte nového vlastníka!',
        'Previous Owner' => 'Předchozí vlastník',
        'Inform Agent' => 'Informovat řešitele',
        'Optional' => 'Volitelné',
        'Inform involved Agents' => '',
        'Spell check' => '',
        'Note type' => 'Typ poznámky',
        'Next state' => 'Nasledující stav',
        'Date invalid!' => '',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Odeslat zpět',
        'You need a email address.' => '',
        'Need a valid email address or don\'t use a local email address.' =>
            '',
        'Next ticket state' => 'Následující stav tiketu',
        'Inform sender' => 'Informovat odesílatele',
        'Send mail!' => 'Poslat mail!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Hromadná akce Tiketu',
        'Send Email' => '',
        'Merge to' => 'Spojit s',
        'Invalid ticket identifier!' => '',
        'Merge to oldest' => 'Spojit s nejstarším',
        'Link together' => 'spárovat dohlromady',
        'Link to parent' => 'Spojit z nadřazeným tiketem',
        'Unlock tickets' => 'Odemkni tikety',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Sestavit odpověď pro tiket',
        'Please include at least one recipient' => '',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Adresář',
        'Pending Date' => 'Očekávaný čas vyřízení',
        'for pending* states' => 'pro stavy očekávání*',
        'Date Invalid!' => '',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Změnit klienta tiketu',
        'Customer user' => '',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Vytvořit Nový Email Tiket',
        'From queue' => 'Z fronty',
        'To customer' => 'Zákazníkovi',
        'Please include at least one customer for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Get all' => '',
        'Text Template' => '',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Přeposlat tiket: %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Historie',
        'History Content' => '',
        'Zoom view' => '',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Sloučení Tiketu',
        'You need to use a ticket number!' => 'Notno použít číslo Tiketu',
        'A valid ticket number is required.' => '',
        'Need a valid email address.' => '',

        # Template: AgentTicketMove
        'Move Ticket' => 'Přesunout tiket',
        'New Queue' => 'Nová fronta',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => '',
        'No ticket data found.' => 'žádné',
        'First Response Time' => 'Čas první reakce',
        'Update Time' => 'Čas Aktualizace',
        'Solution Time' => 'Čas Řešení',
        'Move ticket to a different queue' => '',
        'Change queue' => 'Změnit frontu',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Změnit možnosti vyhledávání',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Tiketů na stránku',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Vytvořit nový telefonní tiket',
        'From customer' => 'Od zákazníka',
        'To queue' => 'Do fronty',

        # Template: AgentTicketPhoneCommon

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Zobrazení zdroje tiketu',
        'Plain' => 'Jednoduché',
        'Download this email' => 'Stáhnout tento email',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informace o Tiketu',
        'Accounted time' => 'Účtovaná doba',
        'Linked-Object' => '',
        'by' => 'přes',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Šablona vyhledávání',
        'Create Template' => 'Vytvořit šablonu',
        'Create New' => 'Vytvořit novou',
        'Profile link' => '',
        'Save changes in template' => 'Uložit změny v šabloně',
        'Add another attribute' => 'Přidat další atribut',
        'Output' => 'Forma výsledku',
        'Fulltext' => '',
        'Remove' => 'Odstranit',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Přihlášení klienta',
        'Created in Queue' => 'Vytvořeno ve Frontě',
        'Lock state' => 'Stav zámku',
        'Watcher' => '',
        'Article Create Time (before/after)' => 'Čas Vytvoření zprávy (poslední/před)',
        'Article Create Time (between)' => 'Čas Vytvoření zprávy (mezi)',
        'Ticket Create Time (before/after)' => 'Čas Vytvoření Tiketu (poslední/před)',
        'Ticket Create Time (between)' => 'Čas Vytvoření Tiketu (mezi)',
        'Ticket Change Time (before/after)' => 'Čas Změny Tiketu (poslední/před)',
        'Ticket Change Time (between)' => 'Čas Změny Tiketu (mezi)',
        'Ticket Close Time (before/after)' => 'Čas Uzatvoření Tiketu (poslední/před)',
        'Ticket Close Time (between)' => 'Čas Uzatvoření Tiketu (mezi)',
        'Ticket Escalation Time (before/after)' => 'Čas eskalace Tiketu (poslední/před)',
        'Ticket Escalation Time (between)' => 'Čas eskalace Tiketu (mezi)',
        'Archive Search' => 'Vyhledávat v archivu',
        'Run search' => 'Spustit hledání',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => '',
        'Article Type' => 'Typ Článku',
        'Sender Type' => '',
        'Save filter settings as default' => 'Uložit Filtr jako Implicitní',
        'Archive' => 'Informace o tiketu',
        'This ticket is archived.' => 'Tiket je archivován.',
        'Locked' => 'Uzamčeno',
        'Linked Objects' => 'Připojené objekty',
        'Article(s)' => 'Zpráva(y)',
        'Change Queue' => 'Změnit frontu',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Add Filter' => '',
        'Set' => 'Nastavit',
        'Reset Filter' => '',
        'Show one article' => 'Zobrazit jednu zprávu',
        'Show all articles' => 'Zobrazit všechny zprávy',
        'Unread articles' => '',
        'No.' => '',
        'Important' => '',
        'Unread Article!' => '',
        'Incoming message' => 'Příchozí zpráva',
        'Outgoing message' => 'Odchozí zpráva',
        'Internal message' => 'Interní zpráva',
        'Resize' => 'Změnit velikost',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => '',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Jít zpět',

        # Template: CustomerFooter
        'Powered by' => 'Vytvořeno',
        'One or more errors occurred!' => '',
        'Close this dialog' => 'Zavřít toto okno',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            '',
        'There are currently no elements available to select from.' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => '',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            '',
        'Browser Warning' => '',
        'The browser you are using is too old.' => '',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            '',
        'Please see the documentation or ask your admin for further information.' =>
            '',
        'Login' => 'Přihlášení',
        'User name' => '',
        'Your user name' => '',
        'Your password' => '',
        'Forgot password?' => '',
        'Log In' => '',
        'Not yet registered?' => '',
        'Sign up now' => '',
        'Request new password' => 'Požádat o nové heslo',
        'Your User Name' => '',
        'A new password will be sent to your email address.' => '',
        'Create Account' => 'Vytvořit účet',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => '',
        'Your First Name' => 'Vaše křestní jméno',
        'Your Last Name' => 'Vaše příjmení',
        'Your email address (this will become your username)' => 'Zadejte emailovou adresu (stane se vaším přihlašovacím jménem)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Nastavení účtu',
        'Logout %s' => 'Odhlásit %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => '',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Vítejte!',
        'Please click the button below to create your first ticket.' => 'Prosím stiskněte tlačítko pro vytvoření vašeho prvního tiketu.',
        'Create your first ticket' => 'Vytvořit váš první tiket',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Tisk Tiketu',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'např. 10*5155 or 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Fulltextové vyhledávání v tiketech (např. "John*n" or "Will*")',
        'Carbon Copy' => 'Skrytá kopie',
        'Types' => '',
        'Time restrictions' => 'Omezení času',
        'No time settings' => '',
        'Only tickets created' => 'Pouze tikety vytvořené',
        'Only tickets created between' => 'Pouze tikety vytvořené mezi',
        'Ticket archive system' => '',
        'Save search as template?' => 'Uložit vyhledávání jako šablonu?',
        'Save as Template?' => 'Uložit jako šablonu?',
        'Save as Template' => 'Uložit jako šablonu',
        'Template Name' => 'Název šablony',
        'Pick a profile name' => 'Zvolit název profilu',
        'Output to' => 'Výstup na',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'z',
        'Page' => 'Strana',
        'Search Results for' => '',

        # Template: CustomerTicketZoom
        'Expand article' => '',
        'Information' => 'Informace',
        'Next Steps' => 'Další kroky',
        'Reply' => 'Odpovědět',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
        'Sunday' => 'Neděle',
        'Monday' => 'Pondelí',
        'Tuesday' => 'Úterí',
        'Wednesday' => 'Středa',
        'Thursday' => 'Čtvrtek',
        'Friday' => 'Pátek',
        'Saturday' => 'Sobota',
        'Su' => 'Ne',
        'Mo' => 'Po',
        'Tu' => 'Ut',
        'We' => 'St',
        'Th' => 'Čt',
        'Fr' => 'Pá',
        'Sa' => 'So',
        'Event Information' => '',
        'Ticket fields' => '',
        'Dynamic fields' => '',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Nesprávne datum (musí být v budoucnosti)',
        'Previous' => 'Předchozí',
        'Open date selection' => 'Otevři kalendář',

        # Template: Error
        'Oops! An Error occurred.' => '',
        'Error Message' => '',
        'You can' => '',
        'Send a bugreport' => '',
        'go back to the previous page' => '',
        'Error Details' => '',

        # Template: Footer
        'Top of page' => 'Na začátek stránky',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            '',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            '',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => 'Fulltextové vyhledávání',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Jste přihlášen jako',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => '',
        'Database Settings' => '',
        'General Specifications and Mail Settings' => '',
        'Registration' => '',
        'Welcome to %s' => 'Vítejte v %s',
        'Web site' => '',
        'Mail check successful.' => '',
        'Error in the mail settings. Please correct and try again.' => '',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => '',
        'Outbound mail type' => '',
        'Select outbound mail type.' => '',
        'Outbound mail port' => '',
        'Select outbound mail port.' => '',
        'SMTP host' => '',
        'SMTP host.' => '',
        'SMTP authentication' => '',
        'Does your SMTP host need authentication?' => '',
        'SMTP auth user' => '',
        'Username for SMTP auth.' => '',
        'SMTP auth password' => '',
        'Password for SMTP auth.' => '',
        'Configure Inbound Mail' => '',
        'Inbound mail type' => '',
        'Select inbound mail type.' => '',
        'Inbound mail host' => '',
        'Inbound mail host.' => '',
        'Inbound mail user' => '',
        'User for inbound mail.' => '',
        'Inbound mail password' => '',
        'Password for inbound mail.' => '',
        'Result of mail configuration check' => '',
        'Check mail configuration' => '',
        'Skip this step' => '',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Databáze úspěšně nastavena!',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => '',
        'Result of database check' => '',
        'OK' => '',
        'Database check successful.' => '',
        'Database User' => '',
        'New' => 'Nové',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            '',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerDBpostgresql

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Abyste mohli používat OTRS, musíte zadat následující řádek do Vašeho příkazového řádku (Terminal/Shell) jako root.',
        'Restart your webserver' => 'Restartujte Váš webserver',
        'After doing so your OTRS is up and running.' => 'Po dokončení následujících operací je Váš OTRS spuštěn a poběží',
        'Start page' => 'Úvodní stránka',
        'Your OTRS Team' => 'Váš OTRS tým',

        # Template: InstallerLicense
        'Accept license' => 'Přijmout licenci',
        'Don\'t accept license' => '',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organizace',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'Systémové ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            '',
        'System FQDN' => 'Systém FQDN',
        'Fully qualified domain name of your system.' => '',
        'AdminEmail' => 'Email Administrátora',
        'Email address of the system administrator.' => '',
        'Log' => '',
        'LogModule' => 'Log Modul',
        'Log backend to use.' => '',
        'LogFile' => '',
        'Webfrontend' => 'Webove rozhraní',
        'Default language' => '',
        'Default language.' => '',
        'CheckMXRecord' => 'Kontrola MX záznamu',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            '',

        # Template: LinkObject
        'Object#' => '',
        'Add links' => '',
        'Delete links' => '',

        # Template: Login
        'Lost your password?' => 'Ztratil/a jste heslo?',
        'Request New Password' => '',
        'Back to login' => '',

        # Template: Motd
        'Message of the Day' => '',

        # Template: NoPermission
        'Insufficient Rights' => '',
        'Back to the previous page' => '',

        # Template: Notify

        # Template: Pagination
        'Show first page' => '',
        'Show previous pages' => '',
        'Show page %s' => '',
        'Show next pages' => '',
        'Show last page' => '',

        # Template: PictureUpload
        'Need FormID!' => '',
        'No file found!' => '',
        'The file is not an image that can be shown inline!' => '',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'tisknuto',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'Testovací OTRS stránka',
        'Welcome %s' => 'Vítejte %s',
        'Counter' => 'Počítadlo',

        # Template: Warning
        'Go back to the previous page' => '',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            '',
        'Activates lost password feature for agents, in the agent interface.' =>
            '',
        'Activates lost password feature for customers.' => '',
        'Activates support for customer groups.' => '',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            '',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            '',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Agent Notifications' => '',
        'Agent interface article notification module to check PGP.' => '',
        'Agent interface article notification module to check S/MIME.' =>
            '',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            '',
        'Agent interface module to access search profiles via nav bar.' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to check the used charset.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            '',
        'Agents <-> Groups' => '',
        'Agents <-> Roles' => '',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            '',
        'Allows agents to generate individual-related stats.' => '',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            '',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            '',
        'Allows customers to change the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            '',
        'Allows customers to set the ticket priority in the customer interface.' =>
            '',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            '',
        'Allows customers to set the ticket service in the customer interface.' =>
            '',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            '',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            '',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'ArticleTree' => '',
        'Attachments <-> Templates' => '',
        'Auto Responses <-> Queues' => '',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            '',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB ACL backend.' => '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the SSL certificate attributes.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => '',
        'Change queue!' => '',
        'Change the customer for this ticket' => 'Změna Zákazníka Tiketu',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled. Note: no more columns are allowed and will be discarded.' =>
            '',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => '',
        'Company Tickets' => 'Ostatní tikety',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => '',
        'Create and manage agents.' => '',
        'Create and manage attachments.' => '',
        'Create and manage companies.' => '',
        'Create and manage customers.' => '',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => '',
        'Create and manage groups.' => '',
        'Create and manage queues.' => '',
        'Create and manage responses that are automatically sent.' => '',
        'Create and manage roles.' => '',
        'Create and manage salutations.' => '',
        'Create and manage services.' => '',
        'Create and manage signatures.' => '',
        'Create and manage templates.' => '',
        'Create and manage ticket priorities.' => '',
        'Create and manage ticket states.' => '',
        'Create and manage ticket types.' => '',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => '',
        'Create new phone ticket (inbound)' => 'Vytvořit nový telefonní tiket (příchozí hovor)',
        'Create new process ticket' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Uživatelé Zákazníka',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => '',
        'Customers <-> Services' => '',
        'Data used to export the search result in CSV format.' => '',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => '',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set manually. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => '',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            '',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            '',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            '',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            '',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            '',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => '',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            '',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            '',
        'Defines the body text for rejected emails.' => '',
        'Defines the boldness of the line drawed by the graph.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of search results shown on the overview page.' =>
            '',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            '',
        'Defines the default priority of new tickets.' => '',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            '',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            '',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_NameXTimeSlotStartYear=1974; Search_DynamicField_NameXTimeSlotStartMonth=01; Search_DynamicField_NameXTimeSlotStartDay=26; Search_DynamicField_NameXTimeSlotStartHour=00; Search_DynamicField_NameXTimeSlotStartMinute=00; Search_DynamicField_NameXTimeSlotStartSecond=00; Search_DynamicField_NameXTimeSlotStopYear=2013; Search_DynamicField_NameXTimeSlotStopMonth=01; Search_DynamicField_NameXTimeSlotStopDay=26; Search_DynamicField_NameXTimeSlotStopHour=23; Search_DynamicField_NameXTimeSlotStopMinute=59; Search_DynamicField_NameXTimeSlotStopSecond=59;\' and or \'Search_DynamicField_NameXTimePointFormat=week; Search_DynamicField_NameXTimePointStart=Before; Search_DynamicField_NameXTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => '',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            '',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            '',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            '',
        'Defines the default type for article in the customer interface.' =>
            '',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            '',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            '',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            '',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            '',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height of the legend.' => '',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            '',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            '',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            '',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            '',
        'Defines the hours and week days to count the working time.' => '',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            '',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            '',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            '',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            '',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => '',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            '',
        'Defines the module to generate html refresh headers of html sites.' =>
            '',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            '',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            '',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            '',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            '',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            '',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            '',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            '',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the spacing of the legends.' => '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => '',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            '',
        'Defines the state of a ticket if it gets a follow-up.' => '',
        'Defines the state type of the reminder for pending tickets.' => '',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            '',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            '',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            '',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            '',
        'Defines the subject for rejected emails.' => '',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contain this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            '',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            '',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            '',
        'Defines the time in days to keep log backup files.' => '',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            '',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the type of protocol, used by ther web server, to serve the application. If https protocol will be used instead of plain http, it must be specified it here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => '',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => '',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            '',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            '',
        'Defines which items are available in first level of the ACL structure.' =>
            '',
        'Defines which items are available in second level of the ACL structure.' =>
            '',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => '',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => '',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            '',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            '',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            '',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'Emailové Adresy',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => '',
        'Enables customers to create their own accounts.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => '',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Zobrazit vyeskalované',
        'Event list to be displayed on GUI' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer Company.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Execute SQL statements.' => '',
        'Executes follow up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail attachments checks in  mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up mail body checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow up plain/raw mail checks in mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Standard/AgentInfo.dtl.' =>
            '',
        'Filter incoming emails.' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => 'Jazyk prostředí',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Motiv prostředí',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'General ticket data shown in the dashboard widgets. Possible settings: 0 = Disabled, 1 = Enabled. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => 'Obecný Prostředek',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPSOAP GUI' => '',
        'GenericInterface Web Service GUI' => '',
        'GenericInterface Webservice History GUI' => '',
        'GenericInterface Webservice Mapping GUI' => '',
        'GenericInterface module registration for the invoker layer.' => '',
        'GenericInterface module registration for the mapping layer.' => '',
        'GenericInterface module registration for the operation layer.' =>
            '',
        'GenericInterface module registration for the transport layer.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            '',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            '',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            '',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            '',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            '',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            '',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log facility can be specified.' =>
            '',
        'If "SysLog" was selected for LogModule, a special log sock can be specified (on solaris you may need to use \'stream\').' =>
            '',
        'If "SysLog" was selected for LogModule, the charset that should be used for logging can be specified.' =>
            '',
        'If "file" was selected for LogModule, a logfile must be specified. If the file doesn\'t exist, it will be created by the system.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'If a note is added by an agent, sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Když zapnuto, různe přehledy (Nástěnka, Zamčené Tikety, Náhled Fronty) budou automaticky znovunačteny.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Jazyk rozhraní',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Link agents to groups.' => '',
        'Link agents to roles.' => '',
        'Link attachments to templates.' => '',
        'Link customers to groups.' => '',
        'Link customers to services.' => '',
        'Link queues to auto responses.' => '',
        'Link roles to groups.' => '',
        'Link templates to queues.' => '',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => '',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => '',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => '',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => '',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => '',
        'Module to check the group permissions for the access to customer tickets.' =>
            '',
        'Module to check the owner of a ticket.' => '',
        'Module to check the watcher agents of a ticket.' => '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Tickets' => 'Moje tikety',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Nový emailový tiket',
        'New phone ticket' => 'Nový telefonní tiket',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => '',
        'Number of displayed tickets' => 'Počet zobrazených tiketů',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => 'Otevřené tikety zákazníka',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => '',
        'Overview Refresh Time' => 'Čas znovunačtení přehledu',
        'Overview of all open Tickets.' => '',
        'PGP Key Management' => '',
        'PGP Key Upload' => '',
        'Parameters for .' => '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the FollowUpNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the LockTimeoutNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the MoveNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the NewTicketNotify object in the preferences view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the WatcherNotify object in the preference view of the agent interface.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the pages (in which the dynamic fields are shown) of the dynamic fields overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the medium ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the small ticket overview.' =>
            '',
        'Parameters for the pages (in which the tickets are shown) of the ticket preview overview.' =>
            '',
        'Parameters of the example SLA attribute Comment2.' => '',
        'Parameters of the example queue attribute Comment2.' => '',
        'Parameters of the example service attribute Comment2.' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the QueueObject object for the customer interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the agent interface.' =>
            '',
        'Path of the file that stores all the settings for the TicketObject for the customer interface.' =>
            '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Picture-Upload' => '',
        'PostMaster Filters' => '',
        'PostMaster Mail Accounts' => '',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Zobrazit frontu',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => 'Načti prehled po',
        'Refresh interval' => 'Interval obnovy',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            '',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            '',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Role <-> Skupiny',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search Customer' => 'Vyhledat Zákazníka',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Výběr motivu rozhraní.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Pošli mi oznámení když zákazník pošle novou zprávu a já jsem vlastníkem tiketu nebo se jedná o tiket který je odemčený a je v mých frontách.',
        'Send notifications to users.' => '',
        'Send ticket follow up notifications' => 'Pošli oznámení o nové komunikaci v tiketu',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Set sender email addresses for this system.' => '',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent.' => '',
        'Sets if service must be selected by the agent.' => '',
        'Sets if service must be selected by the customer.' => '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
            '',
        'Sets the count of articles visible in preview mode of ticket overviews.' =>
            '',
        'Sets the default article type for new email tickets in the agent interface.' =>
            '',
        'Sets the default article type for new phone tickets in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default body text for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default next state for new phone tickets in the agent interface.' =>
            '',
        'Sets the default next ticket state, after the creation of an email ticket in the agent interface.' =>
            '',
        'Sets the default note text for new telephone tickets. E.g \'New ticket via call\' in the agent interface.' =>
            '',
        'Sets the default priority for new email tickets in the agent interface.' =>
            '',
        'Sets the default priority for new phone tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new email tickets in the agent interface.' =>
            '',
        'Sets the default sender type for new phone ticket in the agent interface.' =>
            '',
        'Sets the default subject for new email tickets (e.g. \'email Outbound\') in the agent interface.' =>
            '',
        'Sets the default subject for new phone tickets (e.g. \'Phone call\') in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the close ticket screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket move screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket note screen of the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the default subject for notes added in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the default text for new email tickets in the agent interface.' =>
            '',
        'Sets the display order of the different items in the preferences view.' =>
            '',
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is loged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the options for PGP binary.' => '',
        'Sets the order of the different items in the customer preferences view.' =>
            '',
        'Sets the password for private PGP key.' => '',
        'Sets the prefered time units (e.g. work units, hours, minutes).' =>
            '',
        'Sets the prefix to the scripts folder on the server, as configured on the web server. This setting is used as a variable, OTRS_CONFIG_ScriptAlias which is found in all forms of messaging used by the application, to build links to the tickets within the system.' =>
            '',
        'Sets the queue in the ticket close screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket free text screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket note screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the queue in the ticket responsible screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the responsible agent of the ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the service in the close ticket screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket free text screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket note screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the service in the ticket responsible screen of the agent interface (Ticket::Service needs to be activated).' =>
            '',
        'Sets the size of the statistic graph.' => '',
        'Sets the stats hook.' => '',
        'Sets the system time zone (required a system with UTC as system time). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the ticket owner in the close ticket screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket note screen of the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the ticket owner in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the ticket type in the close ticket screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the ticket type in the ticket free text screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket note screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket owner screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket pending screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket priority screen of a zoomed ticket in the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the ticket type in the ticket responsible screen of the agent interface (Ticket::Type needs to be activated).' =>
            '',
        'Sets the time (in seconds) a user is marked as active.' => '',
        'Sets the time type which should be shown.' => '',
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to set a ticket as spam in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set the priority of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to zoom a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link to access article attachments via a html online viewer in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to download article attachments in the zoom view of the article in the agent interface.' =>
            '',
        'Shows a link to see a zoomed email ticket in plain text.' => '',
        'Shows a link to set a ticket as spam in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the involved agents on this ticket, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the close ticket screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket free text screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket note screen of the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows a list of all the possible agents (all agents with note permissions on the queue/ticket) to determine who should be informed about this note, in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows a preview of the ticket overview (CustomerInfo => 1 - shows also Customer-Info, CustomerInfoMaxSize max. size in characters of Customer-Info).' =>
            '',
        'Shows a select of ticket attributes to order the queue view ticket list. The possible selections can be configured via \'TicketOverviewMenuSort###SortAttributes\'.' =>
            '',
        'Shows all both ro and rw queues in the queue view.' => '',
        'Shows all open tickets (even if they are locked) in the escalation view of the agent interface.' =>
            '',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            '',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            '',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            '',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            '',
        'Shows colors for different article types in the article table.' =>
            '',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            '',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            '',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            '',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            '',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            '',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            '',
        'Shows the customer user\'s info in the ticket zoom view.' => '',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            '',
        'Shows the message of the day on login screen of the agent interface.' =>
            '',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            '',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the ticket priority options in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket note screen of the agent interface.' =>
            '',
        'Shows the title fields in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            '',
        'Shows the title fields in the ticket responsible screen of the agent interface.' =>
            '',
        'Shows time in long format (days, hours, minutes), if set to "Yes"; or in short format (days, hours), if set to "No".' =>
            '',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => '',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => '',
        'Specifies the background color of the picture.' => '',
        'Specifies the border color of the chart.' => '',
        'Specifies the border color of the legend.' => '',
        'Specifies the bottom margin of the chart.' => '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            '',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            '',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            '',
        'Specifies the path of the file for the performance log.' => '',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            '',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            '',
        'Specifies the right margin of the chart.' => '',
        'Specifies the text color of the chart (e. g. caption).' => '',
        'Specifies the text color of the legend.' => '',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies the top margin of the chart.' => '',
        'Specifies user id of the postmaster data base.' => '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'Statistiky',
        'Status view' => 'Zobrazit status',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Templates <-> Queues' => '',
        'Textarea' => '',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            '',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            '',
        'This event module stores attributes from CustomerUser as DynamicFields tickets.' =>
            '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This option defines the dynamic field in which a Process Management activity entity id is stored.' =>
            '',
        'This option defines the dynamic field in which a Process Management process entity id is stored.' =>
            '',
        'This option defines the process tickets default lock.' => '',
        'This option defines the process tickets default priority.' => '',
        'This option defines the process tickets default queue.' => '',
        'This option defines the process tickets default state.' => '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket Queue Overview' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Přehled tiketů',
        'TicketNumber' => '',
        'Tickets' => 'Tikety',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Update and extend your system with software packages.' => '',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => '',
        'View system log messages.' => '',
        'Wear this frontend skin' => '',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Selekce Front z Oblíbených. Bude zasíláno oznámení, je-li zapnuto.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Attachments <-> Responses' => 'Přílohy <-> Odpovědi',
        'Bounce Article to a different mail address' => 'Odeslat na jinou adresu',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Nelze zaktualizovat heslo, protože neobsahuje alespoň 2 malá a 2 velká písmena!',
        'CreateTicket' => 'Vytvořit Tiket',
        'Customer Data' => 'Data Zákazníka',
        'Database-User' => 'Uživatel',
        'Due Date' => 'Datum splatnosti',
        'Escalation in' => 'Eskalace v',
        'For more info see:' => 'Pro další informace viz:',
        'Invalid SessionID!' => 'Neplatné ID relace!',
        'Logout successful. Thank you for using OTRS!' => 'Odhlášení bylo úspěsné. Děkujeme Vám za používání OTRS!',
        'Merge this ticket' => 'Sloučit Tiket',
        'Package verification failed!' => 'Ověření balíčku selhalo',
        'Password is required.' => 'Je požadováno heslo.',
        'Please supply a' => 'Prosím zadejte',
        'Please supply a first name' => 'Prosím zadejte křestní jméno',
        'Please supply a last name' => 'Prosím zadejte příjmení',
        'Responses' => 'Odpovědi',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Bezpečnostní Mód musí být deaktivován za účelem Reinstalu pomocí Web-Installeru.',
        'There are no further steps in this process' => 'V tomto procesu již nejsou žádné další kroky',
        'Ticket Information' => 'Informace o tiketu',
        'TicketFreeFields' => 'Volná pole Tiketu',
        'TicketZoom' => 'Zobrazení tiketu',
        'View the source for this Article' => 'Zobrazit zdroj zprávy',
        'before' => 'před',
        'default \'hot\'' => 'výchozí \'hot\'',
        'empty answer' => '0_Prázdná odpověd',
        'settings' => 'Nastavení',

    };
    # $$STOP$$
    return;
}

1;
