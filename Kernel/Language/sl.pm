# --
# Kernel/Language/sl.pm - provides Slovene language Latin translation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# Copyright (C) 2011 Andrej Cimerlajt, i-Rose d.o.o. <andrej.cimerlajt@i-rose.si>
# Copyright (C) 2011 Gorazd Žagar, i-Rose d.o.o. <gorazd.zagar@i-rose.si>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# This translation is only partially complete

package Kernel::Language::sl;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-09-05 16:52:06

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%T - %D.%M.%Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Da',
        'No' => 'Ne',
        'yes' => 'da',
        'no' => 'ne',
        'Off' => 'Izključeno',
        'off' => 'izključeno',
        'On' => 'Vključeno',
        'on' => 'Vključeno',
        'top' => 'na vrh',
        'end' => 'konec',
        'Done' => 'Končano',
        'Cancel' => 'Prekliči',
        'Reset' => 'Ponastavi',
        'more than ... ago' => '',
        'in more than ...' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Today' => 'danes',
        'Tomorrow' => 'jutri',
        'Next week' => 'naslednji teden',
        'day' => 'dan',
        'days' => 'dnevi',
        'day(s)' => 'dan/dnevi',
        'd' => 'd',
        'hour' => 'ura',
        'hours' => 'ure',
        'hour(s)' => 'ura/e',
        'Hours' => 'Ure',
        'h' => 'u',
        'minute' => 'minuta',
        'minutes' => 'minute',
        'minute(s)' => 'minuta/e',
        'Minutes' => 'Minute',
        'm' => '',
        'month' => 'mesec',
        'months' => 'meseci',
        'month(s)' => 'mesec/i',
        'week' => 'teden',
        'week(s)' => 'teden',
        'year' => 'leto',
        'years' => 'leta',
        'year(s)' => 'leto/a',
        'second(s)' => 'sekunda/e',
        'seconds' => 'sekunde',
        'second' => 'sekunda',
        's' => '',
        'Time unit' => '',
        'wrote' => 'napisal',
        'Message' => 'Sporočilo',
        'Error' => 'Napaka',
        'Bug Report' => 'Prijava napake',
        'Attention' => 'Pozor',
        'Warning' => 'Opozorilo',
        'Module' => 'Modul',
        'Modulefile' => 'Datoteka modula',
        'Subfunction' => 'Podfunkcija',
        'Line' => 'Vrstica',
        'Setting' => 'Nastavitev',
        'Settings' => 'Nastavitve',
        'Example' => 'Primer',
        'Examples' => 'Primeri',
        'valid' => 'veljavno',
        'Valid' => 'Veljavnost',
        'invalid' => 'neveljavno',
        'Invalid' => 'Neveljavno',
        '* invalid' => '* neveljavno',
        'invalid-temporarily' => 'trenutno neveljavno',
        ' 2 minutes' => ' 2 minuti',
        ' 5 minutes' => ' 5 minut',
        ' 7 minutes' => ' 7 minut',
        '10 minutes' => '10 minut',
        '15 minutes' => '15 minut',
        'Mr.' => 'G.',
        'Mrs.' => 'Ga.',
        'Next' => 'Naslednje',
        'Back' => 'Nazaj',
        'Next...' => 'Naprej...',
        '...Back' => '...Nazaj',
        '-none-' => '-brez-',
        'none' => 'prazno',
        'none!' => 'prazno!',
        'none - answered' => 'ni - odgovorjeno',
        'please do not edit!' => 'Prosim ne urejajte!',
        'Need Action' => 'Potrebna akcija',
        'AddLink' => 'Dodaj povezavo',
        'Link' => 'Povezava',
        'Unlink' => 'Odstrani povezavo',
        'Linked' => 'Povezano',
        'Link (Normal)' => 'Povezava (Normalno)',
        'Link (Parent)' => 'Povezava (Nadrejeno)',
        'Link (Child)' => 'Povezava (Podrejeno)',
        'Normal' => 'Normalno',
        'Parent' => 'Nadrejeno',
        'Child' => 'Podrejeno',
        'Hit' => 'Zadetek',
        'Hits' => 'Zadetki',
        'Text' => 'Besedilo',
        'Standard' => 'Standardni',
        'Lite' => 'Enostavno',
        'User' => 'Uporabnik',
        'Username' => 'Uporabniško ime',
        'Language' => 'Jezik',
        'Languages' => 'Jeziki',
        'Password' => 'Geslo',
        'Preferences' => 'Nastavitve',
        'Salutation' => 'Nagovor/pozdrav',
        'Salutations' => 'Nagovori/pozdravi',
        'Signature' => 'Podpis',
        'Signatures' => 'Podpisi',
        'Customer' => 'Stranka',
        'CustomerID' => 'ID stranke',
        'CustomerIDs' => 'ID-ji stranke',
        'customer' => 'stranka',
        'agent' => 'operater',
        'system' => 'sistem',
        'Customer Info' => 'Podatki o stranki',
        'Customer Information' => 'Podatki o stranki',
        'Customer Company' => 'Podjetje stranke',
        'Customer Companies' => 'Podjetja stranke',
        'Company' => 'Podjetje',
        'go!' => 'Izvedi!',
        'go' => 'izvedi',
        'All' => 'Vsi',
        'all' => 'vsi',
        'Sorry' => 'Oprostite',
        'update!' => 'posodobitev!',
        'update' => 'posodobitev',
        'Update' => 'Posodobi',
        'Updated!' => 'Posodobljeno!',
        'submit!' => 'potrdi!',
        'submit' => 'potrdi',
        'Submit' => 'Potrdi',
        'change!' => 'spremeni!',
        'Change' => 'Spremeni',
        'change' => 'spremeni',
        'click here' => 'kliknite tukaj',
        'Comment' => 'Komentar',
        'Invalid Option!' => 'Neveljavna možnost!',
        'Invalid time!' => 'Neveljaven čas!',
        'Invalid date!' => 'Neveljaven datum!',
        'Name' => 'Ime',
        'Group' => 'Skupina',
        'Description' => 'Opis',
        'description' => 'opis',
        'Theme' => 'Tema',
        'Created' => 'Ustvarjeno',
        'Created by' => 'Ustvaril',
        'Changed' => 'Spremenjeno',
        'Changed by' => 'Spremenjeno od',
        'Search' => 'Išči',
        'and' => 'in',
        'between' => 'med',
        'before/after' => '',
        'Fulltext Search' => 'Tekst za iskanje',
        'Data' => 'Podatki',
        'Options' => 'Možnosti',
        'Title' => 'Naslov',
        'Item' => 'postavka',
        'Delete' => 'Izbriši',
        'Edit' => 'Urejanje',
        'View' => 'Poglej',
        'Number' => 'Število',
        'System' => 'Sistem',
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontakti',
        'Export' => 'Izvoz',
        'Up' => 'Gor',
        'Down' => 'Dol',
        'Add' => 'Dodaj',
        'Added!' => 'Dodano!',
        'Category' => 'Kategorija',
        'Viewer' => 'Pregledovalnik',
        'Expand' => 'Razširi',
        'Small' => 'Majhno',
        'Medium' => 'Srednje',
        'Large' => 'Veliko',
        'Date picker' => 'Izbira datuma',
        'New message' => 'Novo sporočilo',
        'New message!' => 'Novo sporočilo!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Prosimo, da odgovorite na to zahtevek, da se vrnete na običajni prikaz čakalne vrste!',
        'You have %s new message(s)!' => 'Imate %s novih sporočil!',
        'You have %s reminder ticket(s)!' => 'Imate %s sporočil obiskovalcev!',
        'The recommended charset for your language is %s!' => 'Priporočen nabor znakov za vaš jezik je %s!',
        'Change your password.' => 'Spremenite geslo.',
        'Please activate %s first!' => 'Prosimo, prvo aktivirajte %s.',
        'No suggestions' => 'Ni predlogov',
        'Word' => 'Beseda',
        'Ignore' => 'Ignoriraj',
        'replace with' => 'zamenjati z',
        'There is no account with that login name.' => 'Račun s tem uporabniškem imenom ne obstaja.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Neuspešna prijava! Uporabniško ime ali geslo ni pravilno.',
        'There is no acount with that user name.' => 'Račun s tem uporabniškem imenom ne obstaja.',
        'Please contact your administrator' => 'Prosimo, obrnite se na vašega skrbnika',
        'Logout' => 'Odjava',
        'Logout successful. Thank you for using %s!' => '',
        'Feature not active!' => 'Funkcija ni aktivna!',
        'Agent updated!' => 'Posodobljen zaposlen',
        'Database Selection' => '',
        'Create Database' => 'Kreiraj bazo podatkov',
        'System Settings' => 'Sistemske nastavitve',
        'Mail Configuration' => 'Nastavitve E-pošte',
        'Finished' => 'zaključeno',
        'Install OTRS' => 'Namesti OTRS',
        'Intro' => 'Uvod',
        'License' => 'Licenca',
        'Database' => 'Baza podatkov (DB)',
        'Configure Mail' => 'Konfiguracija e-pošte',
        'Database deleted.' => 'Baza podatkov izbrisana',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database already contains data - it should be empty!' => '',
        'Login is needed!' => 'Potrebna je prijava!',
        'Password is needed!' => 'Potrebno je vpisati geslo!',
        'Take this Customer' => 'Vzemite tega uporabnika',
        'Take this User' => 'Vzemite tega uporabnika sistema',
        'possible' => 'mogoče',
        'reject' => 'zavrni',
        'reverse' => 'obratno',
        'Facility' => 'Instalacija',
        'Time Zone' => 'Časovni pas',
        'Pending till' => 'Čakati do',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'Razporejanje po elektronski pošti na: polje.',
        'Dispatching by selected Queue.' => 'Razporejanje po redu velikosti.',
        'No entry found!' => 'Vnos ni najden!',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Seja je potekla. Prijavite se še enkrat.',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Nimate dovolenja!',
        '(Click here to add)' => '(Kliknite tukaj, da dodate)',
        'Preview' => 'Predogled',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => '%s ni zapisljiv!',
        'Cannot create %s!' => 'Ni mogoče ustvariti %s!',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'Customer %s added' => 'Dodan uporabnik %s.',
        'Role added!' => 'Dodana vloga!',
        'Role updated!' => 'Posodobljena vloga',
        'Attachment added!' => 'Dodana priloga',
        'Attachment updated!' => 'Posodobljena priloga',
        'Response added!' => 'Dodan odgovor',
        'Response updated!' => 'Odgovor posodobljen',
        'Group updated!' => 'Posodobljena skupina',
        'Queue added!' => 'Izbira dodana',
        'Queue updated!' => 'Posodobljena izbira',
        'State added!' => 'Dodan status',
        'State updated!' => 'Posodobljen status',
        'Type added!' => 'Dodan tip',
        'Type updated!' => 'Posodobljen tip',
        'Customer updated!' => 'Posodobljen uporabnik',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Note: Company is invalid!' => '',
        'Mail account added!' => '',
        'Mail account updated!' => '',
        'System e-mail address added!' => 'Sistemski poštni naslov dodan!',
        'System e-mail address updated!' => 'Sistemski poštni naslov posodobljen!',
        'Contract' => 'Ugovor',
        'Online Customer: %s' => 'Uporabnik na vezi: %s',
        'Online Agent: %s' => 'Zaposleni na vezi: %s',
        'Calendar' => 'kolendar',
        'File' => 'Datoteka',
        'Filename' => 'Naziv datoteke',
        'Type' => 'Tip',
        'Size' => 'Velikost',
        'Upload' => 'Nalaganje',
        'Directory' => 'Imenik',
        'Signed' => 'Podpisano',
        'Sign' => 'Podpis',
        'Crypted' => 'Šifrirano',
        'Crypt' => 'Šifra',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP Ključ',
        'PGP Keys' => 'PGP ključi',
        'S/MIME' => '"S/MIME" ključ',
        'S/MIME Certificate' => 'S/MIME certifikat',
        'S/MIME Certificates' => 'S/MIME certifikat',
        'Office' => 'Pisarna',
        'Phone' => 'Telefon',
        'Fax' => 'Faks',
        'Mobile' => 'Mobilni telefon',
        'Zip' => 'Pošta',
        'City' => 'Mesto',
        'Street' => 'Ulica',
        'Country' => 'Država',
        'Location' => 'Lokacija',
        'installed' => 'nameščeno',
        'uninstalled' => 'odstranjeno',
        'Security Note: You should activate %s because application is already running!' =>
            'Varnostna opomba: Potrebno je omogočiti %s, ker aplikacija že teče!',
        'Unable to parse repository index document.' => 'Ni mogoče razčleniti dokumenta indeks!',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Ni paketa za verziju vašega sistema, na tem mestu so samo paketi za druge verzije.',
        'No packages, or no new packages, found in selected repository.' =>
            'Na izbranemmestu ni paketa ali ni novih paketov',
        'Edit the system configuration settings.' => 'Uredite nastavitve konfiguracije sistema.',
        'printed at' => 'natisjeno na',
        'Loading...' => 'nalaganje...',
        'Dear Mr. %s,' => 'Spoštovani gospod %s,',
        'Dear Mrs. %s,' => 'Spoštovana gospa %s,',
        'Dear %s,' => 'Dragi %s,',
        'Hello %s,' => 'Zdravo %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Ta e-poštni naslov že obstaja. Prijavite se ali ponastavite geslo.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'nov račun ustvarjen. Podatki za prijavo so poslani %s. Prosimo, preverite e-pošto.',
        'Please press Back and try again.' => 'Prosimo, pritisnite Nazaj in poskusite znova.',
        'Sent password reset instructions. Please check your email.' => 'Poslana navodila za ponastavitev gesla. Prosimo, preverite e-pošto.',
        'Sent new password to %s. Please check your email.' => 'Poslano vam je bilo novo geslo za %s. rosimo, preverite e-pošto.',
        'Upcoming Events' => 'Prihajajoči dogodki',
        'Event' => 'Dogodek',
        'Events' => 'Dogodki',
        'Invalid Token!' => 'Nepravilna oznaka!',
        'more' => 'več',
        'Collapse' => 'Zmanjšaj',
        'Shown' => 'Prikazano',
        'Shown customer users' => '',
        'News' => 'Novice',
        'Product News' => 'Novice o izdelku',
        'OTRS News' => 'OTRS novice',
        '7 Day Stats' => 'Tedenska statistika',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Mark' => '',
        'Unmark' => '',
        'Bold' => 'Krepko',
        'Italic' => 'Ležeče',
        'Underline' => 'Podčrtano',
        'Font Color' => 'Barva pisave',
        'Background Color' => 'Barva ozadja',
        'Remove Formatting' => 'Odstrani formatiranje',
        'Show/Hide Hidden Elements' => 'Prikaži/Skrij skrite elemente',
        'Align Left' => 'Poravnaj levo',
        'Align Center' => 'Poravnaj na sredino',
        'Align Right' => 'Poravnava desno',
        'Justify' => 'Obojestransko',
        'Header' => 'Naslov',
        'Indent' => 'Zamik',
        'Outdent' => 'Primik',
        'Create an Unordered List' => 'Ustvari neurejen seznam',
        'Create an Ordered List' => 'Ustvarjanje urejenega seznama',
        'HTML Link' => 'HTML povezava',
        'Insert Image' => 'Vstavi sliko',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Razveljavi',
        'Redo' => 'Uveljavi',
        'Scheduler process is registered but might not be running.' => '',
        'Scheduler is not running.' => 'Urnik se ne izvaja.',

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
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Apr',
        'May' => 'Maj',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Avg',
        'Sep' => 'sep',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Dec',
        'January' => 'januar',
        'February' => 'februar',
        'March' => 'marec',
        'April' => 'april',
        'May_long' => 'maj',
        'June' => 'junij',
        'July' => 'julij',
        'August' => 'avgust',
        'September' => 'september',
        'October' => 'oktober',
        'November' => 'november',
        'December' => 'december',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Nastavitve so uspešno posodobljene!',
        'User Profile' => 'Profil uporabnika',
        'Email Settings' => 'Nastavitve E-pošte',
        'Other Settings' => 'Druge nastavitve',
        'Change Password' => 'Spremeni geslo',
        'Current password' => 'Trenutno geslo',
        'New password' => 'Novo geslo',
        'Verify password' => 'Potrdi geslo',
        'Spelling Dictionary' => 'Pravopisni slovar',
        'Default spelling dictionary' => 'Privzeti pravopisni slovar',
        'Max. shown Tickets a page in Overview.' => 'Maksimalno število zahtevkov na strani pregleda.',
        'The current password is not correct. Please try again!' => 'Trenutno geslo ni pravilno. Prosimo, poskusite znova!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Gesla se ne da posodobiti, vaši gesli se ne ujemata. Prosimo, poskusite znova!',
        'Can\'t update password, it contains invalid characters!' => 'Geslo ne more biti posodobljeno, vsebuje neveljavne znake.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Geslo ne more biti posodobljeno. Minimalna dolžilna gesla je %s znakov.',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Geslo ne more biti posodobljeno. Vsebovati mora vsaj eno številko.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Geslo ne more biti posodobljeno. Vsebovati mora vsaj 2 znaka.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Geslo ne more biti posodobljeno. Vnešeno geslo je v uporabi. Prosimo izberite novo.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Izberite zank za ločevanje, ki se bo uporabljal v "CSV" datotekah (statistika in iskanje). Če ne izberete ločila tukaj,se bo uporabilo privzeto ločilo za vaš jezik',
        'CSV Separator' => 'CSV ločevalnik',

        # Template: AAAStats
        'Stat' => 'Statistika',
        'Sum' => 'Vsota',
        'Please fill out the required fields!' => 'Prosimo, da izpolnite vsa potrebna polja!',
        'Please select a file!' => 'Prosimo, izberite datoteko!',
        'Please select an object!' => 'Izberite datoteko!',
        'Please select a graph size!' => 'Izberite velikost grafa!',
        'Please select one element for the X-axis!' => 'Izberite en element za X-os!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            '"Prosimo, izberite le en element ali izklopite gumb \" Fixed \ ", kjer je označeno izbrano polje!"!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Če uporabljate potrditveno polje morate izbrati nekaj lastnosti izbranega polja!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Prosimo, vnesite vrednost v izbrano vnosno polje ali izklopite \'Fixed\' polje!',
        'The selected end time is before the start time!' => 'Izbrani končni čas je pred časom začetka!',
        'You have to select one or more attributes from the select field!' =>
            'Izbrati je potrebno eno ali več lastnosti iz izbranega polja.',
        'The selected Date isn\'t valid!' => 'Izbrani datum ni veljaven!',
        'Please select only one or two elements via the checkbox!' => 'Prosimo, izberite samo enega ali dva elementa iz polja!',
        'If you use a time scale element you can only select one element!' =>
            'Če koristite element časovne lestvice, lahko izberete samo en element!',
        'You have an error in your time selection!' => 'Imate napake v času izbora!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Vaš časovni interal za poročanje je premajhen, prosimo, uporabite večji časovni interval!',
        'The selected start time is before the allowed start time!' => 'Izbran čas začetka je pred dovoljenim začetkom!',
        'The selected end time is after the allowed end time!' => 'Izbrani čas konca je po dovoljenim časom za zaključek!',
        'The selected time period is larger than the allowed time period!' =>
            'Izbrano časovno obdobje, je večje od dovoljenega časovnega obdobja!',
        'Common Specification' => 'Splošne informacije',
        'X-axis' => 'X-os',
        'Value Series' => 'Obseg',
        'Restrictions' => 'Omejitve',
        'graph-lines' => 'Črtni graf',
        'graph-bars' => 'Stolpičasti graf',
        'graph-hbars' => 'Pasovni graf',
        'graph-points' => 'Točkovni graf',
        'graph-lines-points' => 'Točkovno-črtni graf',
        'graph-area' => 'Ploskovni graf',
        'graph-pie' => 'Tortast graf',
        'extended' => 'razširjen',
        'Agent/Owner' => 'Zaposleni/Lastnik',
        'Created by Agent/Owner' => 'Ustvarjeno od Zaposleni/Lastnik',
        'Created Priority' => 'Odprto s prioriteto',
        'Created State' => 'Odprto s statusom',
        'Create Time' => 'Čas odpiranja',
        'CustomerUserLogin' => 'Prijava uporabnika',
        'Close Time' => 'Čas zapiranja',
        'TicketAccumulation' => 'Kopičenje kartic',
        'Attributes to be printed' => 'Atributi za tiskanje',
        'Sort sequence' => 'Vrstni red sortiranja',
        'Order by' => 'Uredi po',
        'Limit' => 'Omejitev',
        'Ticketlist' => 'Lista kartice',
        'ascending' => 'naraščajoče',
        'descending' => 'padajoče',
        'First Lock' => 'Prvi prevzem',
        'Evaluation by' => 'Ocenjevanje s strani',
        'Total Time' => 'Skupni čas',
        'Ticket Average' => 'Povprečni čas za zahtevek',
        'Ticket Min Time' => 'Minimalni čas zahtevka',
        'Ticket Max Time' => 'Maksimalen čas zahtevka',
        'Number of Tickets' => 'Številka zahtevka',
        'Article Average' => 'Povprečen čas za članek',
        'Article Min Time' => 'Minimalen čas članka',
        'Article Max Time' => 'Maksimalni čas za članek',
        'Number of Articles' => 'Številka članka',
        'Accounted time by Agent' => 'Obračun časa po zaposlenem',
        'Ticket/Article Accounted Time' => 'Obračunan čas',
        'TicketAccountedTime' => 'Obračunan čas za zahtevek',
        'Ticket Create Time' => 'Čas odprtja zahtevka',
        'Ticket Close Time' => 'Čas zaprtja zahtevka',

        # Template: AAATicket
        'Status View' => 'Pregled stanja',
        'Bulk' => 'Količinsko',
        'Lock' => 'Prevzemi',
        'Unlock' => 'Sprosti',
        'History' => 'Zgodovina',
        'Zoom' => 'Povečava',
        'Age' => 'Starost',
        'Bounce' => 'Preusmeri',
        'Forward' => 'Posreduj',
        'From' => 'Od',
        'To' => 'Za',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Predmet',
        'Move' => 'Premakni',
        'Queue' => 'Vrsta',
        'Queues' => 'Vrste',
        'Priority' => 'Prioriteta',
        'Priorities' => 'Prioritete',
        'Priority Update' => 'Posodobitev prioritete',
        'Priority added!' => 'Prioriteta dodana!',
        'Priority updated!' => 'Prioriteta posodobljena!',
        'Signature added!' => 'Podpis dodan!',
        'Signature updated!' => 'Podpis posodobljen!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'SLA',
        'Service Level Agreements' => 'SLA',
        'Service' => 'Storitev',
        'Services' => 'Storitve',
        'State' => 'Stanje',
        'States' => 'Stanja',
        'Status' => 'Status',
        'Statuses' => 'Statusi',
        'Ticket Type' => 'Tip zahtevka',
        'Ticket Types' => 'Tipi zahtevka',
        'Compose' => 'Sestavi',
        'Pending' => 'V čakanju',
        'Owner' => 'Lastnik',
        'Owner Update' => 'Posodobitev lastnika',
        'Responsible' => 'Odgovornost',
        'Responsible Update' => 'Posodobitev odgovornosti',
        'Sender' => 'Pošiljatelj',
        'Article' => 'Članek',
        'Ticket' => 'Zahtevek',
        'Createtime' => 'Čas kreiranja',
        'plain' => 'neformatirano',
        'Email' => 'E-pošta',
        'email' => 'E-pošta',
        'Close' => 'Zapri',
        'Action' => 'Akcija',
        'Attachment' => 'Priloga',
        'Attachments' => 'Priloge',
        'This message was written in a character set other than your own.' =>
            'To sporočilo je bilo napisano v nabor znakov, različnimi od teh, ki jih uporabljate.',
        'If it is not displayed correctly,' => 'Če se ne prikaže pravilno,',
        'This is a' => 'To je',
        'to open it in a new window.' => 'da ga odprete v novem oknu.',
        'This is a HTML email. Click here to show it.' => 'To je HTML e-pošta. Kliknite tukaj za prikaz.',
        'Free Fields' => 'Dodatna polja',
        'Merge' => 'Spoji',
        'merged' => 'spajanje',
        'closed successful' => 'rešeno uspešno',
        'closed unsuccessful' => 'rešeno neuspešno',
        'Locked Tickets Total' => 'Skupno število prevzetih/blokiranih zahtevkov',
        'Locked Tickets Reminder Reached' => 'Dosežen opomnik prevzetih zahtevkov',
        'Locked Tickets New' => 'Novi prevzeti zahtevki',
        'Responsible Tickets Total' => 'Skupno zahtevkov za katere sem odgovoren',
        'Responsible Tickets New' => 'Novi zahtevki za katere sem odgovoren',
        'Responsible Tickets Reminder Reached' => 'Dosežen opomnik zahtevkov za katere sem odgovoren',
        'Watched Tickets Total' => 'Skupen pregled zahtevkov',
        'Watched Tickets New' => 'Nove sledljivi zahtevki',
        'Watched Tickets Reminder Reached' => 'Dosežen opomnik zahtevkov na čakanju',
        'All tickets' => 'Vsi zahtevki',
        'Available tickets' => 'Na voljo zahtevkov',
        'Escalation' => 'Eskalacija',
        'last-search' => 'zadnje iskanje',
        'QueueView' => 'Pregled vrst',
        'Ticket Escalation View' => 'Pregled eskaliranih zahtevkov',
        'Message from' => 'Sporočilo od',
        'End message' => 'konec sporočila',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'new' => 'novo',
        'open' => 'odprto',
        'Open' => 'Odprti',
        'Open tickets' => 'Odprti zahtevki',
        'closed' => 'zaprto',
        'Closed' => 'Zaprto',
        'Closed tickets' => 'Zaprti zahtevki',
        'removed' => 'odstranjeni',
        'pending reminder' => 'opomnik za čakanje',
        'pending auto' => 'avtomatsko čakanje',
        'pending auto close+' => 'čakanje na avtomatsko zapiranje+',
        'pending auto close-' => 'čakanje na avtomatsko zapiranje-',
        'email-external' => 'zunanje sporočilo',
        'email-internal' => 'notranje sporočilo',
        'note-external' => 'zunanji zaznamek',
        'note-internal' => 'notranji zaznamek',
        'note-report' => 'opomnik-poročilo',
        'phone' => 'Telefon',
        'sms' => 'SMS',
        'webrequest' => 'Web zahteva',
        'lock' => 'prevzeto',
        'unlock' => 'prosto',
        'very low' => 'zelo nizek',
        'low' => 'nizka',
        'normal' => 'normalen',
        'high' => 'visok',
        'very high' => 'zelo visoko',
        '1 very low' => '1 zelo nizko',
        '2 low' => '2 nizko',
        '3 normal' => '3 normalno',
        '4 high' => '4 visoko',
        '5 very high' => '5 zelo visoko',
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Create' => 'Ustvarite',
        'Answer' => '',
        'Phone call' => 'Telefonski klic',
        'Ticket "%s" created!' => 'zahtevek "%s" kreiran!',
        'Ticket Number' => 'Številka zahtevka',
        'Ticket Object' => 'objekt zahtevka',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Zahtevek s številko "%s ne obstaja"! Ne morem se povezati!',
        'You don\'t have write access to this ticket.' => 'Nimate dostopa do zahtevka.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            '',
        'Please change the owner first.' => '',
        'Ticket selected.' => 'Izbrani zahtevek',
        'Ticket is locked by another agent.' => 'Zahtevek je prevzet.',
        'Ticket locked.' => 'Zahtevek prevzet.',
        'Don\'t show closed Tickets' => 'Ne prikazuj prevzetih zahtevkov',
        'Show closed Tickets' => 'Prikaži zaprte zahtevke',
        'New Article' => 'Novi',
        'Unread article(s) available' => 'Neprebrani članki na voljo',
        'Remove from list of watched tickets' => 'Odstrani iz liste pregledanih zahtevkov',
        'Add to list of watched tickets' => 'Dodaj na listo pregledanih zahtevkov',
        'Email-Ticket' => 'Zahtevek po E-pošti',
        'Create new Email Ticket' => 'Kreiraj nov zahtevek E-pošte',
        'Phone-Ticket' => 'Telefonska kartica',
        'Search Tickets' => 'Iskanje zahtevkov',
        'Edit Customer Users' => 'Uredi uporabnike',
        'Edit Customer Company' => 'Uredi podjetje uporabnika',
        'Bulk Action' => 'Masovna akcija',
        'Bulk Actions on Tickets' => 'Masovne akcije na zahtevkih',
        'Send Email and create a new Ticket' => 'pošlji E-pošto in kreiraj nov zahtevek',
        'Create new Email Ticket and send this out (Outbound)' => 'Odpri nov zahtevek E-pošte in pošlji to (izhodni)',
        'Create new Phone Ticket (Inbound)' => 'Kreiraj nov telefonski zahtevek (vhodni klic)',
        'Address %s replaced with registered customer address.' => '',
        'Customer user automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Pregled vseh odprtih zahtevkov',
        'Locked Tickets' => 'Prevzeti/blokirani',
        'My Locked Tickets' => 'Moji prevzeti zahtevki',
        'My Watched Tickets' => 'Moji pregledani zahtevki',
        'My Responsible Tickets' => 'Zahtevki za katere sem odgovoren',
        'Watched Tickets' => 'Pregledani zahtevki',
        'Watched' => 'Pregledano',
        'Watch' => 'Preglej',
        'Unwatch' => 'Prekini pregled',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => '',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'Spremeni prosta polja zahtevka',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => 'Zapri ta zahtevek',
        'Look into a ticket!' => 'Preglej vsebino zahtevka!',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'Označi kot SPAM!',
        'My Queues' => 'Moje vrste',
        'Shown Tickets' => 'prikazani zahtevki',
        'Shown Columns' => '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Vaše sporočilo E-pošte s številko zahtevka "<OTRS_TICKET>" je združena z zahtevkom "<OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' => 'zahtevek %s: prvi odzivni čas je potekel (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'zahtevek %s: prvi odzivni čas bo potekel v %s!',
        'Ticket %s: update time is over (%s)!' => 'zahtevek %s: čas za posodobitev se je iztekel (%s)!',
        'Ticket %s: update time will be over in %s!' => 'zahtevek %s: čas za posodobitev se izteka za %s!',
        'Ticket %s: solution time is over (%s)!' => 'zahtevek %s: čas za rešitev zahtevka je potekel (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'zahtevek %s: čas za rešitev zahtevka poteče za %s!',
        'There are more escalated tickets!' => 'Še obstaja eskaliranih zahtevkov!',
        'Plain Format' => 'Enostaven format',
        'Reply All' => 'Odgovori na vse',
        'Direction' => 'Smer',
        'Agent (All with write permissions)' => 'Zaposlen (vsi z pravicami za spreminjanje)',
        'Agent (Owner)' => 'Zaposlen (Lastnik)',
        'Agent (Responsible)' => 'Zaposlen (Odgovoren)',
        'New ticket notification' => 'Obvestilo o novem zahtevku',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Pošlji mi obvestilo o novem zahtevku v " V mojih vrstah".',
        'Send new ticket notifications' => 'Pošlji obvestilo o novem zahtevku',
        'Ticket follow up notification' => 'Obvestilo o podaljšanju zahtevka',
        'Ticket lock timeout notification' => 'Obvestilo o poteku zaključka zahtevka',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Pošlji obvestilo če sistem odklene zahtevek.)',
        'Send ticket lock timeout notifications' => 'Pošlji obvestilo o poteku prevzema zahtevka',
        'Ticket move notification' => 'Obvestilo o premiku zahtevka',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Pošlji obvestilo o premiku zahtevka v "Moja vrsta".',
        'Send ticket move notifications' => 'Pošlji obvestilo o premiku zahtevka',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Izbor vaših najljubših čakalnih vrst med priljubljenimi vrstami. Pošljejo se tudi obvestila o teh čakalnih vrst prek e-pošte če je omogočeno.',
        'Custom Queue' => 'Vrsta po meri',
        'QueueView refresh time' => 'Čas osveževanja vrste',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Če je omogočeno, bodo QueueView samodejno osveženi po določenem času.',
        'Refresh QueueView after' => 'Osveži pregled vrste kasneje',
        'Screen after new ticket' => 'Zaslon po novem zahtevku',
        'Show this screen after I created a new ticket' => 'Pokaži ta zaslon po tem, ko sem ustvaril nov zahtevek',
        'Closed Tickets' => 'Zaprti zahtevki',
        'Show closed tickets.' => 'Prikaži zaprte zahtevke.',
        'Max. shown Tickets a page in QueueView.' => 'Maksimalno število prikazanih zahtevkov pri pregledu vrste.',
        'Ticket Overview "Small" Limit' => 'Pregled zahtevka "Small" omejitev',
        'Ticket limit per page for Ticket Overview "Small"' => 'Omejitev zahtevkov na stran pri pregledu zahtevkov za "Small"',
        'Ticket Overview "Medium" Limit' => 'Pregled zahtevka "Medium" omejitev',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Omejitev zahtevkov na stran pri pregledu zahtevkov za "Medium"',
        'Ticket Overview "Preview" Limit' => 'Pregled zahtevka "Preview" omejitev',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limit zahtevkom pri pregledu le teh',
        'Ticket watch notification' => 'Obvestilo o pregledu zahtevka',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Pošlji enako obvestilo za pregledane zahtevke katere bo dobil tudi lastnik.',
        'Send ticket watch notifications' => 'Pošlji obvestilo za pregled zahtevka',
        'Out Of Office Time' => 'Izven delovnega časa',
        'New Ticket' => 'Nov zahtevek',
        'Create new Ticket' => 'Ustvari nov zahtevek',
        'Customer called' => 'Zahtevek na klic uporabnika',
        'phone call' => 'telefonski klic',
        'Phone Call Outbound' => 'Izhodni telefonski klic',
        'Phone Call Inbound' => 'Dohodni telefonski klic',
        'Reminder Reached' => 'Opomnik dosežen',
        'Reminder Tickets' => 'Opomnik na zahtevek',
        'Escalated Tickets' => 'Eskalirani zahtevki',
        'New Tickets' => 'Novi zahtevki',
        'Open Tickets / Need to be answered' => 'Odprti zahtevki / Potrebno odgovoriti',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Vsi odprti zahtevki, na katerih se je že delalo in zahtevajo odgovor',
        'All new tickets, these tickets have not been worked on yet' => 'Vsi novi zahtevki, na katerih se še ni nič delalo',
        'All escalated tickets' => 'Vsi eskalirani zahtevki',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Vsi zahtevki z določenem opomnikom, in datum opomnika je dosežen',
        'Archived tickets' => 'Arhivirani zahtevki',
        'Unarchived tickets' => 'Nearhivirani zahtevki',
        'History::Move' => 'premik zahtevka v vrsto "%s" (%s) iz vrste "%s" (%s).',
        'History::TypeUpdate' => 'Posodobljen tip "%s" (ID=%s).',
        'History::ServiceUpdate' => 'Posodobljen servis "%s" (ID=%s).',
        'History::SLAUpdate' => 'Posodobljen SLA "%s" (ID=%s).',
        'History::NewTicket' => 'Nov zahtevek [%s] odprt (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Nadaljevanje zahtevka [%s]. %s',
        'History::SendAutoReject' => 'Avtomatsko zavrjeno "%s".',
        'History::SendAutoReply' => 'Poslan avtomatski odgovor za "%s".',
        'History::SendAutoFollowUp' => 'Avtomatsko nadaljevanje za "%s".',
        'History::Forward' => 'Posredovano sporočilo "%s".',
        'History::Bounce' => 'Zavrjeno sporočilo "%s".',
        'History::SendAnswer' => 'Sporočilo E-pošte poslano "%s".',
        'History::SendAgentNotification' => '"%s" - obvestilo poslano k "%s".',
        'History::SendCustomerNotification' => 'Obvestilo poslano k "%s".',
        'History::EmailAgent' => '"E-pošta poslana zaposlenemu."',
        'History::EmailCustomer' => '"E-pošta poslana uporabniku. %s"',
        'History::PhoneCallAgent' => '"Telefonski klic zaposlenega."',
        'History::PhoneCallCustomer' => 'Telefonski klic uporabnika',
        'History::AddNote' => 'Dodatno opozorilo (%s)',
        'History::Lock' => 'Zahtevek prevzet',
        'History::Unlock' => 'Zahtevek sproščen',
        'History::TimeAccounting' => 'Dodanih %s časovnih enot. Skupaj %s časovnih enot.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Posodobljeno: %s',
        'History::PriorityUpdate' => 'Posodobljena prioriteta z "%s" (%s) na "%s" (%s).',
        'History::OwnerUpdate' => 'Novi lastnik je "%s" (ID=%s).',
        'History::LoopProtection' => 'Zaščita od zanke/ciklanja! Avtomatski odgovor ni poslan na "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Posodobljeno: %s',
        'History::StateUpdate' => 'Staro: "%s" Novo: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Posodobljeno: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Web zahteva uporabnika.',
        'History::TicketLinkAdd' => 'Povezava na "%s" dodana.',
        'History::TicketLinkDelete' => 'Povezava na "%s" odstranjena.',
        'History::Subscribe' => 'Naročnina za uporabnika "%s" vključena.',
        'History::Unsubscribe' => 'Naročnina za uporabnika "%s" izključena.',
        'History::SystemRequest' => 'Zahteve sistema',
        'History::ResponsibleUpdate' => 'Novi odgovorni je "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => '',
        'History::TicketTitleUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'ned',
        'Mon' => 'pon',
        'Tue' => 'tor',
        'Wed' => 'sre',
        'Thu' => 'čet',
        'Fri' => 'pet',
        'Sat' => 'sob',

        # Template: AdminACL
        'ACL Management' => '',
        'Filter for ACLs' => '',
        'Filter' => 'Filter',
        'ACL Name' => '',
        'Actions' => 'Akcija',
        'Create New ACL' => '',
        'Deploy ACLs' => '',
        'Export ACLs' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'To polje je obvezno.',
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
        'Validity' => '',
        'Copy' => '',
        'No data found.' => 'Ne najde podatkov.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Go to overview' => 'Pojdi na pregled',
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
        'Show or hide the content' => 'Prikaži ali skrij vsebino',
        'Edit ACL information' => '',
        'Stop after match' => 'Ustavi po prikazu rezultatov',
        'Edit ACL structure' => '',
        'Save' => 'Shrani',
        'or' => 'ali',
        'Save and finish' => 'Shrani in končaj',
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
        'Attachment Management' => 'Upravljanje s prilogami',
        'Add attachment' => 'Dodaj prilogo',
        'List' => 'Lista',
        'Download file' => 'Prenesi datoteko',
        'Delete this attachment' => 'Zbriši prilogo',
        'Add Attachment' => 'Dodaj prilogo',
        'Edit Attachment' => 'Uredi prilogo',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Upravljanje z avtomatskimi odgovori',
        'Add auto response' => 'Dodaj avtomatski odgovor',
        'Add Auto Response' => 'Dodaj avtomatski odgovor',
        'Edit Auto Response' => 'Uredi avtomatski odgovor',
        'Response' => 'Odgovor',
        'Auto response from' => 'Avtomatski odgovor od',
        'Reference' => 'Reference',
        'You can use the following tags' => 'Lahko uporabite naslednje oznake',
        'To get the first 20 character of the subject.' => 'Da vidite prvih 20 črk subjekta',
        'To get the first 5 lines of the email.' => 'Da vidite prvih 5 vrst sporočila',
        'To get the realname of the sender (if given).' => 'Da vidite ime pošiljatelja (če je dostopno)',
        'To get the article attribute' => 'Da vidite atribute članka',
        ' e. g.' => 'npr.',
        'Options of the current customer user data' => 'Možnost pregleda podatkov o trenutnem uporabniku',
        'Ticket owner options' => 'Možnost lastnika zahtevka',
        'Ticket responsible options' => 'Možnost odgovornega za zahtevek',
        'Options of the current user who requested this action' => 'Možnosti trenutnega uporabnika, ki je zahteval to akcijo',
        'Options of the ticket data' => 'Možnost podatkov o zahtevku',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Konfiguracijske možnosti',
        'Example response' => 'Primer odgovora',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Upravljanje s strankami',
        'Wildcards like \'*\' are allowed.' => 'Nadomestni znaki kot "*" so dovoljeni.',
        'Add customer' => 'Dodaj stranko',
        'Select' => 'Izberi',
        'Please enter a search term to look for customers.' => 'Vnesite iskalne kriterije za iskanje stranke.',
        'Add Customer' => 'Dodaj uporabnika',
        'Edit Customer' => 'Uredi uporabnika',

        # Template: AdminCustomerUser
        'Customer User Management' => '',
        'Back to search results' => '',
        'Add customer user' => '',
        'Hint' => 'Nasvet',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '',
        'Last Login' => 'Zadnja prijava',
        'Login as' => 'Prijavi se kot',
        'Switch to customer' => '',
        'Add Customer User' => '',
        'Edit Customer User' => '',
        'This field is required and needs to be a valid email address.' =>
            'To polje je obvezno in mora biti veljaven elektronski naslov.',
        'This email address is not allowed due to the system configuration.' =>
            'Ta e-poštni naslov ni dovoljen zaradi konfiguracije sistema.',
        'This email address failed MX check.' => 'Tega naslov E-pošte ni uspelo preveriti DNS/MX.',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => 'Sintaksa tega e-poštnega naslova je napačna.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Upravljanje članstva strank v skupini',
        'Notice' => 'Opomba',
        'This feature is disabled!' => 'Ta funkcija je izključena!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'To funkcijo uporabljajte samo če želite definirati skupinske dostope za uporabnike.',
        'Enable it here!' => 'Omogočite tukaj!',
        'Search for customers.' => 'Iskanje strank',
        'Edit Customer Default Groups' => 'Urediti privzete skupine za uporabnika',
        'These groups are automatically assigned to all customers.' => 'Te skupine so avtomatsko dodeljene vsem uporabnikom',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Lahko upravljate s tem skupinam s pomočjo nastavitev "..."',
        'Filter for Groups' => 'Filter za skupine',
        'Select the customer:group permissions.' => 'Izberi dovoljenja za uporabnika:skupina',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Če ni nič izbrano, potem ni nobenih dovoljenj v tej skupini (zahtevki ne bodo na voljo za stranke).',
        'Search Results' => 'Rezultati iskanja',
        'Customers' => 'Stranke',
        'Groups' => 'Skupine',
        'No matches found.' => 'Ni zadetkov.',
        'Change Group Relations for Customer' => 'Spremeni povezave s skupinami za stranko',
        'Change Customer Relations for Group' => 'Spremeni povezave stank z skupinami',
        'Toggle %s Permission for all' => 'Spremeni %s dovolenja za vse',
        'Toggle %s permission for %s' => 'Spremeni %s dovolenje za %s',
        'Customer Default Groups:' => 'Privzete skupine za uporabnika:',
        'No changes can be made to these groups.' => 'V teh skupinah spremembe niso dovoljene.',
        'ro' => '"ro"',
        'Read only access to the ticket in this group/queue.' => 'Dostop je omogočen samo za branje zahtevkov v teh skupinah/vrstah.',
        'rw' => '"rw"',
        'Full read and write access to the tickets in this group/queue.' =>
            'Dostop brez omejitev za zahtevke v teh skupinah/vrstah.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Upravljanje z odnosi stranka-storitve',
        'Edit default services' => 'Uredi privzete storitve',
        'Filter for Services' => 'Filter za storitve',
        'Allocate Services to Customer' => 'Določi storitve',
        'Allocate Customers to Service' => 'Določi storitve za stranke',
        'Toggle active state for all' => 'Preklopi na aktivno stanje za vse',
        'Active' => 'Aktivno',
        'Toggle active state for %s' => 'Preklopi na aktivno stanje za %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => '',
        'Dynamic fields per page' => '',
        'Label' => '',
        'Order' => 'Sortiranje',
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
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => '',
        'Default value' => 'Privzeta vrednost',
        'This is the default value for this field.' => '',

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
        'Possible values' => 'Možne vrednosti',
        'Key' => 'Ključ',
        'Value' => 'Vrednost',
        'Remove value' => 'Odstrani vrednost',
        'Add value' => 'Dodajanje vrednosti',
        'Add Value' => 'Dodajanje vrednosti',
        'Add empty value' => '',
        'Activate this option to create an empty selectable value.' => '',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => '',
        'If you activate this option the values will be translated to the user defined language.' =>
            '',
        'Note' => 'Opomba',
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
        'Admin Notification' => 'Obvestilo administratorja',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'S tem modulom, lahko skrbniki pošiljajo sporočila operaterjem, skupinam ali vlogam.',
        'Create Administrative Message' => 'Ustvari administrativno sporočilo',
        'Your message was sent to' => 'Vaše sporočilo je bilo poslano',
        'Send message to users' => 'Pošlji sporočilo za uporabnike',
        'Send message to group members' => 'Pošlji sporočilo članom skupine',
        'Group members need to have permission' => 'Člani skupine morajo imeti dovoljenje',
        'Send message to role members' => 'Pošlji sporočilo role uporabnikom',
        'Also send to customers in groups' => 'Prav tako pošlji strankam v skupinah',
        'Body' => 'Tekst',
        'Send' => 'Pošlji',

        # Template: AdminGenericAgent
        'Generic Agent' => '"Generični" operaterji',
        'Add job' => 'Dodajanje opravila',
        'Last run' => 'Zadnji zagon',
        'Run Now!' => 'Zaženi zdaj!',
        'Delete this task' => 'Izbriši to nalogo',
        'Run this task' => 'Zaženi to nalogo',
        'Job Settings' => 'Nastavitve "opravila"',
        'Job name' => 'Ime "opravila"',
        'Toggle this widget' => 'Preklopi na ta "widget"',
        'Automatic execution (multiple tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Načrtovane minute',
        'Schedule hours' => 'Načrtovane ure',
        'Schedule days' => 'Načrtovano dnevov',
        'Currently this generic agent job will not run automatically.' =>
            'Trenutno se to generično delo posrednika ne bo samodejno zagnalo.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Če želite omogočiti samodejno izvajanje je potrebno izbrati vsaj eno vrednost iz minute, ure in dneva!',
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
        'Ticket Filter' => 'Filter zahtevka',
        '(e. g. 10*5155 or 105658*)' => 'npr. 10*5144 ili 105658*',
        '(e. g. 234321)' => 'npr. 234321',
        'Customer login' => 'Prijava uporabnika',
        '(e. g. U5150)' => 'npr. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Popolno tekstovno iskanje v članku (npr. "Mar*n" ili "Hor*i")',
        'Agent' => 'Zaposlen',
        'Ticket lock' => 'Zahtevek prevzet',
        'Create times' => 'Čas kreiranja',
        'No create time settings.' => 'Ni postavk za čas kreiranja.',
        'Ticket created' => 'Zahtevek ustvarjen',
        'Ticket created between' => 'Zahtevek ustvarjem med',
        'Change times' => 'Spremeni čas',
        'No change time settings.' => 'Ni spremembe časa',
        'Ticket changed' => 'Zahtevek spremenjen',
        'Ticket changed between' => 'Zahtevek spremenjem med',
        'Close times' => 'Čas zapiranja',
        'No close time settings.' => 'Ni spremembe časa za zapiranje.',
        'Ticket closed' => 'Zahtevek zaprt',
        'Ticket closed between' => 'Zahtevek zaprt med',
        'Pending times' => 'Čas čakanja',
        'No pending time settings.' => 'Ni določeno čas čakanja',
        'Ticket pending time reached' => 'Dosežen čas čakanja zahtevka',
        'Ticket pending time reached between' => 'Dosežen čas čakanja zahtevka med',
        'Escalation times' => 'Čas eskalacije',
        'No escalation time settings.' => 'Ni postavki časa eskalacije',
        'Ticket escalation time reached' => 'Dosežen čas eskalacije zahtevka',
        'Ticket escalation time reached between' => 'Čas eskalacije zahtevka dosežen med',
        'Escalation - first response time' => 'Eskalacija - prvi odzivni čas',
        'Ticket first response time reached' => 'Dosežen čas prvega odziva na zahtevek',
        'Ticket first response time reached between' => 'Čas prvega odziva za zahtevek dosežem med',
        'Escalation - update time' => 'Eskalacija - čas posodobitve',
        'Ticket update time reached' => 'Dosežen čas posodobitve zahtevka',
        'Ticket update time reached between' => 'Čas posodobitve zahtevka dosežen med',
        'Escalation - solution time' => 'Eskalacija - Čas reševanja',
        'Ticket solution time reached' => 'Dosežen čas rešitve zahtevka',
        'Ticket solution time reached between' => 'Čas rešitve zahtevka dosežen med',
        'Archive search option' => 'Možnosti iskanja v arhivu',
        'Ticket Action' => 'Akcija na zahtevku',
        'Set new service' => 'Nastavi novo storitev',
        'Set new Service Level Agreement' => 'Nastavi nov SLA',
        'Set new priority' => 'Nastavi novo prioriteto',
        'Set new queue' => 'Nastavi novo vrsto',
        'Set new state' => 'Nastavi nov status',
        'Pending date' => 'Čakati do',
        'Set new agent' => 'Nastavi novega zaposlenega',
        'new owner' => 'novi lastnik',
        'new responsible' => 'nov odgovorni',
        'Set new ticket lock' => 'Nastavi nove zahtevke za prevzem',
        'New customer' => 'Nov uporabnik',
        'New customer ID' => 'Novi ID uporabnika',
        'New title' => 'Novi naslov',
        'New type' => 'Novi tip',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => 'Arhiviraj izbrane zahtevke',
        'Add Note' => 'Dodaj opombo',
        'Time units' => 'Časovne enote',
        '(work units)' => '',
        'Ticket Commands' => 'Ukazi za zahtevek',
        'Send agent/customer notifications on changes' => 'Pošlji obvestilo zaposlenemu/uporabniku o spremembah',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ti ukazi se bodo izvršili. ARG[0] je številka zahtevka,  ARG[1] ID zahtevka.',
        'Delete tickets' => 'Brisanje zahtevkov',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'OPOZORILO: Vsi zahtevki bodo odstranjeni iz baze in jih ni mogoče obnoviti!',
        'Execute Custom Module' => 'Zaženi posebni modul',
        'Param %s key' => 'Ključ parametra %s',
        'Param %s value' => 'Vrednost parametra %s',
        'Save Changes' => 'Shrani spremembe',
        'Results' => 'Rezultati',
        '%s Tickets affected! What do you want to do?' => '%s okuženi zahtevki. Kaj želite narediti?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'OPOZORILO: Uporabili ste IZBRIŠI možnost. Vsi izbrisani zahtevki bodo izgubljeni!',
        'Edit job' => 'Uredi "opravilo"',
        'Run job' => 'Zaženi "opravilo"',
        'Affected Tickets' => 'Okuženi zahtevki',

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
        'Loading' => 'Nalaganje...',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Osveži',
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
        'Save and continue' => 'Shrani in nadaljuj',
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
        'Import' => 'Uvoz',
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
        'Version' => 'Različica',
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
            'OPOZORILO: Če spremenite ime skupine \'admin\' preden ustrezne spremembe urediš v sistemskih nastavitvah, izgubili boste dostop do administrativnega prostora! Če se to zgodi, spremenite ime skupine v "admin" s pomočjo SQL stavka.',
        'Group Management' => 'Skupina za upravljanje',
        'Add group' => 'Dodaj skupino',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '"admin" skupina se uporablja za dostop do administrativnega prostora in "stats" skupina za dostop do statistike.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Ustvarite nove skupine za lažje upravljanje z dovolenji za različne zaposlene (npr. po oddelkih)',
        'It\'s useful for ASP solutions. ' => 'Koristna rešitev za ASP.',
        'Add Group' => 'Dodaj skupino',
        'Edit Group' => 'Uredi skupino',

        # Template: AdminLog
        'System Log' => 'Dnevnik/zapisnik sistema',
        'Here you will find log information about your system.' => 'Tukaj se nahajajo informacije o zabeleženih dogajanjih v sistemu.',
        'Hide this message' => 'Skrij to sporočilo',
        'Recent Log Entries' => 'Zadnji vnosi v dnevnik',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Upravljanje z računi e-pošte',
        'Add mail account' => 'Dodaj E-poštni naslov',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Vsa vhodna sporočila iz enega računa bodo preusmerjene v izbrano vrsto!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Če je vaš račun zaupanja vreden bodo že obstajale glave za X-OTRS v času prihoda! "PostMaster" filtri se vedno uporabljajo.',
        'Host' => 'Gostitelj (host)',
        'Delete account' => 'Izbriši račun E-pošte',
        'Fetch mail' => 'Prevzemi E-pošto',
        'Add Mail Account' => 'Dodaj račun E-pošte',
        'Example: mail.example.com' => 'Primer: mail.example.com',
        'IMAP Folder' => 'IMAP mapa',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Zaupljivo',
        'Dispatching' => 'Odpošiljanje',
        'Edit Mail Account' => 'Uredi račun E-pošte',

        # Template: AdminNavigationBar
        'Admin' => 'Administracija',
        'Agent Management' => 'Upravljanje z operaterji',
        'Queue Settings' => 'Nastavitve vrst',
        'Ticket Settings' => 'Nastavitve zahtevkov',
        'System Administration' => 'Administracija sistema',

        # Template: AdminNotification
        'Notification Management' => 'Upravljanje z obvestili',
        'Select a different language' => 'Izberite drug jezik',
        'Filter for Notification' => 'Filtri za obvestila',
        'Notifications are sent to an agent or a customer.' => 'Obvestilo poslano zaposlenemu ali uporabniku.',
        'Notification' => 'Obvestilo',
        'Edit Notification' => 'Uredi obvestilo',
        'e. g.' => 'npr.',
        'Options of the current customer data' => 'Možnost podatkov o trenutnemu uporabniku',

        # Template: AdminNotificationEvent
        'Add notification' => 'Dodaj obvestilo',
        'Delete this notification' => 'Izbriši to obvestilo',
        'Add Notification' => 'Dodaj obvestilo',
        'Article Filter' => 'Filter za članke',
        'Only for ArticleCreate event' => 'Samo za dogodek kreiranja članka',
        'Article type' => 'Tip članka',
        'Article sender type' => '',
        'Subject match' => 'Ujemanje predmetov',
        'Body match' => 'Ujemanje vsebine',
        'Include attachments to notification' => 'Vključi priloge v obvestila',
        'Recipient' => 'Prejemnik',
        'Recipient groups' => 'Skupine prejemnikov',
        'Recipient agents' => 'Zaposleni prejemniki',
        'Recipient roles' => 'Vloge prejemnikov',
        'Recipient email addresses' => 'Naslovi E-pošte prejemnikov',
        'Notification article type' => 'Obvestilo o tipu članka',
        'Only for notifications to specified email addresses' => 'Samo za obvestila za določene naslove e-pošte',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Pregled prvih 20 znakov predmeta (zadnjega članka zaposlenega).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Pregled prvih 20 znakov predmeta (zadnji članke zaposlenega)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Pregled prvih 5 vrst sporočila (zadnji članek zaposlenega).',

        # Template: AdminPGP
        'PGP Management' => 'Upravljanje s PGP ključi',
        'Use this feature if you want to work with PGP keys.' => 'Uporabi to možnost za delo z PGP ključi.',
        'Add PGP key' => 'Dodaj PGP-ključ',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Na ta način lahko direktno upravljate z kompletnimi ključi vnesenimi v sistemskih nastavitvah.',
        'Introduction to PGP' => 'Uvod v PGP',
        'Result' => 'Rezultat',
        'Identifier' => 'Oznaka',
        'Bit' => 'Bit',
        'Fingerprint' => 'Povzetek',
        'Expires' => 'Poteče',
        'Delete this key' => 'Izbriši ta ključ',
        'Add PGP Key' => 'Dodaj PGP-ključ',
        'PGP key' => 'PGP-ključ',

        # Template: AdminPackageManager
        'Package Manager' => 'Delo z paketi',
        'Uninstall package' => 'Odstrani paket',
        'Do you really want to uninstall this package?' => 'Ali res želite odstraniti ta paket?',
        'Reinstall package' => 'Ponovno namestite paket',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Ali res želite ponovno namestiti ta paket? Vse ročne spremembe bodo izgubljene.',
        'Continue' => 'Nadaljuj',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Namestite',
        'Install Package' => 'Namesti paket',
        'Update repository information' => 'Posodobi informacije o skladišču',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Spletno skladišče',
        'Vendor' => 'Prodajalec',
        'Module documentation' => 'Dokumentacija modula',
        'Upgrade' => 'Posodobitev',
        'Local Repository' => 'Lokalno skladišče',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Odstrani',
        'Reinstall' => 'Ponovna namestitev',
        'Feature Add-Ons' => '',
        'Download package' => 'Prenesi paket',
        'Rebuild package' => 'Obnovi paket (rebuild)',
        'Metadata' => 'Meta-podatki',
        'Change Log' => 'Spremeni dnevnik',
        'Date' => 'Datum',
        'List of Files' => 'Spisek datotek',
        'Permission' => 'Dovolenje',
        'Download' => 'Prenesi',
        'Download file from package!' => 'Prenesi datoteko iz paketa!',
        'Required' => 'Obvezna',
        'PrimaryKey' => 'Primarni ključ',
        'AutoIncrement' => 'AutoIncrement',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Razlike za datoteko %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Dnevnik uspešnosti',
        'This feature is enabled!' => 'Ta funkcija je aktivna!',
        'Just use this feature if you want to log each request.' => 'Uporabite to možnost če želite zabeležiti vsako zahtevo.',
        'Activating this feature might affect your system performance!' =>
            'Aktiviranje te funkcije lahko vpliva na vaše delovanje sistema!',
        'Disable it here!' => 'Onemogoči je tu!',
        'Logfile too large!' => 'Log datoteka prevelika!',
        'The logfile is too large, you need to reset it' => 'Log datoteka je prevelika, morate jo ponastaviti',
        'Overview' => 'Pregled',
        'Range' => 'Doseg',
        'last' => 'zadnje',
        'Interface' => 'Vmesnik',
        'Requests' => 'Zahteve',
        'Min Response' => 'Min. odzivni čas',
        'Max Response' => 'Maks. odzivni čas',
        'Average Response' => 'Povprečen odzivni čas',
        'Period' => 'Obdobje',
        'Min' => 'Min',
        'Max' => 'Maks',
        'Average' => 'Povprečno',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Upravljanje s "PostMaster" filtri',
        'Add filter' => 'Dodaj filter',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Za pošiljanje ali filter dohodne e-pošte, ki temelji na email glave. Ujemanje z uporabo regularnih izrazov je tudi možno.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Če želite, da se ujemajo samo e-poštni naslov, uporabite EMAILADDRESS:info@example.com u "Od", "Za" ali "Cc".',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Če uporabljate regularne izraze, lahko uporabite tudi ustrezne vrednosti v () kot [***] v \'Set\' akciji.',
        'Delete this filter' => 'Izbriši ta filter',
        'Add PostMaster Filter' => 'Dodaj "PostMaster" filter',
        'Edit PostMaster Filter' => 'Uredi "PostMaster" filter',
        'The name is required.' => 'Ime je zahtevano',
        'Filter Condition' => 'Pogoji filtriranja',
        'AND Condition' => '',
        'Negate' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'Nastavi glavo e-pošte',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Upravljanje prioritet',
        'Add priority' => 'Dodaj prioriteto',
        'Add Priority' => 'Dodaj prioriteto',
        'Edit Priority' => 'Uredi prioriteto',

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
        'Print' => 'Natisni',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Prekliči in zapri okno',
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
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
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
        'Manage Queues' => 'Upravljanje vrst',
        'Add queue' => 'Dodaj vrsto',
        'Add Queue' => 'Dodaj vrsto',
        'Edit Queue' => 'Uredi vrsto',
        'Sub-queue of' => 'Pod-vrsta od',
        'Unlock timeout' => 'Čas do odklenitve',
        '0 = no unlock' => '0 = ne odkleniti',
        'Only business hours are counted.' => 'Šteje se samo čas dela.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '',
        'Notify by' => 'Obveščen od',
        '0 = no escalation' => '0 = ni eskalacije',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Če se zahtevka ne zapre pred definiranim časom, zahtevek eskalira.',
        'Follow up Option' => 'Nadaljevanje možnosti',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Nadaljevanje dela na zaprtem zahtevku ponovno odpre zahteve ali pa odpre novega.',
        'Ticket lock after a follow up' => 'Zahtevek se prevzame po spreminjanju',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Če je zahtevek zaprt in uporabnik pošlje nadaljevanje bo zahtevek prenešen na starega lastnika.',
        'System address' => 'Naslov sistema',
        'Will be the sender address of this queue for email answers.' => 'Naslov pošiljatelja E-pošte za odgovore iz te vrste.',
        'Default sign key' => 'Privzet ključ podpisa',
        'The salutation for email answers.' => 'Pozdrav za odgovore na e-pošto.',
        'The signature for email answers.' => 'Podpis za odgovore na e-pošto.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Upravljanje z vrstami <-> avtomatski odgovor',
        'Filter for Queues' => 'Filter za vrsto',
        'Filter for Auto Responses' => 'Filter za avtomatske odgovore',
        'Auto Responses' => 'Avtomatski odgovori',
        'Change Auto Response Relations for Queue' => 'Spremeni povezave z avtomatskim odgovorim za vrsto',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRole
        'Role Management' => 'Upravljanje z vlogami',
        'Add role' => 'Dodaj vlogo',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Ustvari vlogo in ji dodaj skupine. Nato dodaj vlogu zaposlenim.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Ni definiranih vlog. Uporabite tipko za dodajanje nove vloge.',
        'Add Role' => 'Dodaj vlogo',
        'Edit Role' => 'Uredi vlogo',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Upravljanje z vlogami <-> skupina',
        'Filter for Roles' => 'Filter vlog',
        'Roles' => 'Vloge',
        'Select the role:group permissions.' => 'Izberite vlogo: pravice skupine',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Če ni nič izbrano, potem ni nobenih dovoljenj v tej skupini (zahtevki ne bojo vidni za to vlogo).',
        'Change Role Relations for Group' => 'Spreminjanje povezave vloge za skupino',
        'Change Group Relations for Role' => 'Spreminjanje povezave skupine za vlogu',
        'Toggle %s permission for all' => 'Spremeni %s dovolenja za vse',
        'move_into' => 'premakni v',
        'Permissions to move tickets into this group/queue.' => 'Dovoljenje, da se premaknete zahtevek v to skupino/čakalno vrsto.',
        'create' => 'ustvarjanje',
        'Permissions to create tickets in this group/queue.' => 'Dovoljenje za ustvarjanje zahtevka v tej skupini/čakalni vrsti.',
        'priority' => 'prioritete',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Dovoljenje, da se spremeni prioriteta zahtevka v tej skupini/vrsti.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Upravljanje s povezavo zaposlen <-> vloga',
        'Filter for Agents' => 'Filter zaposlenega',
        'Agents' => 'Operaterji',
        'Manage Role-Agent Relations' => 'Upravljanje s povezavo zaposlen <-> vloga',
        'Change Role Relations for Agent' => 'Sprememba povezave z vlogami za zaposlene',
        'Change Agent Relations for Role' => 'Sprememba povezave za zaposlenim z vlogo',

        # Template: AdminSLA
        'SLA Management' => 'Upravljanje SLA',
        'Add SLA' => 'Dodaj SLA',
        'Edit SLA' => 'Uredi SLA',
        'Please write only numbers!' => 'Prosimo pišite samo številke!',

        # Template: AdminSMIME
        'S/MIME Management' => '"S/MIME" upravljanje',
        'Add certificate' => 'Dodaj certifikat',
        'Add private key' => 'Dodaj privatni ključ',
        'Filter for certificates' => 'Filter za certifikate',
        'Filter for SMIME certs' => 'Filter za SMIME certifikate',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Glej tudi',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Na ta način lahko neposredno urejate certifikate in zasebne ključe v datotečnem sistemu.',
        'Hash' => 'Hash',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => 'Izbriši ta certifikat',
        'Add Certificate' => 'Dodaj certifikat',
        'Add Private Key' => 'Dodaj privatni ključ',
        'Secret' => 'Tajno',
        'Related Certificates for' => 'Povezani certifikati za',
        'Delete this relation' => 'Izbriši to povezavo',
        'Available Certificates' => 'Certifikati na voljo',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'Zapri okno',

        # Template: AdminSalutation
        'Salutation Management' => 'Upravljanje s pozdravi',
        'Add salutation' => 'Dodaj pozdrav',
        'Add Salutation' => 'Dodaj pozdrav',
        'Edit Salutation' => 'Uredi pozdrav',
        'Example salutation' => 'Primer pozdrava',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Secure način mora biti omogočen!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Varni način se bo (ponavadi) določil po končani začetni namestitvi.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Če varen način ni aktiviran, ga lahko aktivirate preko SysConfig ker se vaša aplikacija že izvaja.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Tukaj lahko vnesete SQL poizvedbe, da jih lahko neposredno pošljete za uporabo na bazi podatkov.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Obstaja napaka v sintaksi vaše SQL poizvedbe. Prosim preverite.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Najmanj en parameter manjka za vezavo/povezavo. Prosim preverite.',
        'Result format' => 'Format rezultata',
        'Run Query' => 'Zaženi poizvedbo',

        # Template: AdminService
        'Service Management' => 'Upravljanje s storitvami',
        'Add service' => 'Dodaj storitev',
        'Add Service' => 'Dodaj storitev',
        'Edit Service' => 'Uredi storitev',
        'Sub-service of' => 'Pod-storitev od',

        # Template: AdminSession
        'Session Management' => 'Upravljanje s sejo',
        'All sessions' => 'Vse seje',
        'Agent sessions' => 'Seje zaposlenih',
        'Customer sessions' => 'Seje uporabnikov',
        'Unique agents' => 'Edinstveni zaposleni',
        'Unique customers' => 'Edinstveni uporabniki',
        'Kill all sessions' => 'Ugasni vse seje',
        'Kill this session' => 'Ugasni to sejo',
        'Session' => 'Seja',
        'Kill' => 'Ugasni',
        'Detail View for SessionID' => 'Poglej podrobnosti za ID seje',

        # Template: AdminSignature
        'Signature Management' => 'Upravljanje s podpisi',
        'Add signature' => 'Dodaj podpis',
        'Add Signature' => 'Dodaj podpis',
        'Edit Signature' => 'Uredi podpis',
        'Example signature' => 'Primer podpisa',

        # Template: AdminState
        'State Management' => 'Upravljanje statusov',
        'Add state' => 'Dodaj status',
        'Please also update the states in SysConfig where needed.' => 'Prosimo, prav tako posodobite statuse v SysConfig kjer je potrebno.',
        'Add State' => 'Dodaj status',
        'Edit State' => 'Uredi status',
        'State type' => 'Tip statusa',

        # Template: AdminSysConfig
        'SysConfig' => 'Sistemske nastavitve',
        'Navigate by searching in %s settings' => 'Iskanje skozi %s nastavitve',
        'Navigate by selecting config groups' => 'Navigacija z izbiro config skupin',
        'Download all system config changes' => 'Prenesi vse spremembe v nastavitvah sistema',
        'Export settings' => 'izvoz nastavitev',
        'Load SysConfig settings from file' => 'Naloži sysconfig nastavitve iz datoteke',
        'Import settings' => 'Uvoz nastavitev',
        'Import Settings' => 'Uvoz nastavitev sistema iz datoteke',
        'Please enter a search term to look for settings.' => 'Vnesite iskalni izraz za iskanje nastavitev',
        'Subgroup' => 'Podskupina',
        'Elements' => 'Elementi',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Uredi konfiguracijske nastavitve',
        'This config item is only available in a higher config level!' =>
            'To konfiguracijska postavka je na voljo le na višjih ravni konfiguriranja!',
        'Reset this setting' => 'Nastavi na privzeto vrednost',
        'Error: this file could not be found.' => 'Napaka: te datoteke ni bilo mogoče najti.',
        'Error: this directory could not be found.' => 'Napaka: te mapa ni bilo mogoče najti.',
        'Error: an invalid value was entered.' => 'Napaka: neveljavna vrednost je bila vpisana.',
        'Content' => 'Vsebina',
        'Remove this entry' => 'Odstrani ta vnos',
        'Add entry' => 'Dodaj vnos',
        'Remove entry' => 'Odstrani vnos',
        'Add new entry' => 'Dodaj novi vnos',
        'Delete this entry' => 'Izbriši ta vnos',
        'Create new entry' => 'Ustvari nov vnos',
        'New group' => 'Nova skupina',
        'Group ro' => 'Skupina "RO"',
        'Readonly group' => 'Skupina samo za branje',
        'New group ro' => 'Nova "RO" skupina',
        'Loader' => '"Loader"',
        'File to load for this frontend module' => 'Datoteka za nalaganje za ta Frontend modul',
        'New Loader File' => 'Nova "Loader" datoteka',
        'NavBarName' => 'Naziv navigacijskega bara',
        'NavBar' => 'Navigacijski bar',
        'LinkOption' => 'Možnosti povezave',
        'Block' => 'Blokiraj',
        'AccessKey' => 'Ključ za dostop',
        'Add NavBar entry' => 'Dodaj element v vrstico za krmarjenje',
        'Year' => 'leto',
        'Month' => 'mesec',
        'Day' => 'dan',
        'Invalid year' => 'Napačno leto',
        'Invalid month' => 'Napačen mesec',
        'Invalid day' => 'Napačen dan',
        'Show more' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Upravljanje z E-pošto sistema',
        'Add system address' => 'Dodaj sistemski naslov',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Vse dohodne e-pošte s tem naslovom v Za ali Kp se bodo poslale v izbrano vrsto.',
        'Email address' => 'E-poštni naslov',
        'Display name' => 'Prikaži ime',
        'Add System Email Address' => 'Dodaj E-poštni naslov sistema',
        'Edit System Email Address' => 'Uredi E-poštni naslov sistema',
        'The display name and email address will be shown on mail you send.' =>
            'Ime in naslov E-pošte bojo prikazani na sporočilu katerega ste poslali.',

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
        'The current ticket state is' => 'Trenutni status zahtevka je',
        'Your email address is' => 'Vaš naslov E-pošte je',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => 'Filter za priloge',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Spremeni stanje aktivnosti za vse',
        'Link %s to selected %s' => 'Poveži %s z izabranim %s',

        # Template: AdminType
        'Type Management' => 'Upravljanje tipov',
        'Add ticket type' => 'Dodaj tip zahtevka',
        'Add Type' => 'Dodaj tip',
        'Edit Type' => 'Uredi tip',

        # Template: AdminUser
        'Add agent' => 'Dodaj operaterja',
        'Agents will be needed to handle tickets.' => 'Za delo in ravnanje z zahtevki potrebujete zaposlene.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Ne pozabite dodati novega zaposlenega v skupine ali vloge!',
        'Please enter a search term to look for agents.' => 'Vnesite iskalni izraz za iskanje zaposlenih.',
        'Last login' => 'Zadnja prijava',
        'Switch to agent' => 'Preklopi na zaposlenega',
        'Add Agent' => 'Dodaj operaterja',
        'Edit Agent' => 'Uredi operaterja',
        'Firstname' => 'Ime',
        'Lastname' => 'Priimek',
        'Will be auto-generated if left empty.' => '',
        'Start' => 'Začetek',
        'End' => 'Konec',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Upravljanje s povezavami operater <-> skupina',
        'Change Group Relations for Agent' => 'Spremeni povezave z skupinami za zaposlene',
        'Change Agent Relations for Group' => 'Spremeni povezave z zaposlenimi za skupino',
        'note' => 'opomba',
        'Permissions to add notes to tickets in this group/queue.' => 'Dovolenje za dodajanje opomb na zahtevke v tej skupini/vrsti.',
        'owner' => 'Lastnik',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Dovolenje za spremembo lastnika zahtevka v tej skupini/vrsti.',

        # Template: AgentBook
        'Address Book' => 'Imenik',
        'Search for a customer' => 'Iskanje kupca',
        'Add email address %s to the To field' => 'Dodaj E-poštni naslov %s v polje "Za:"',
        'Add email address %s to the Cc field' => 'Dodaj E-poštni naslov %s v polje "Cc:"',
        'Add email address %s to the Bcc field' => 'Dodaj E-poštni naslov %s v polje "Bcc:"',
        'Apply' => 'Uporabi',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ID stranke',
        'Customer User' => 'Zahtevano od',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Podvojen vnos',
        'This address already exists on the address list.' => 'Ta naslov že obstaja na seznamu naslovov.',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '',

        # Template: AgentDashboard
        'Dashboard' => 'Nadzorna plošča',

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
        '%s %s is available!' => '%s %s je na voljo!',
        'Please update now.' => 'Prosimo, posodobite zdaj.',
        'Release Note' => 'Obvestilo o različici',
        'Level' => 'Stopnja',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Poslano pred %s.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Moji prevzeti zahtevki',
        'My watched tickets' => 'Moji opazovani zahtevki',
        'My responsibilities' => '',
        'Tickets in My Queues' => 'Zahtevki v mojih vrstah',
        'Service Time' => 'Čas storitve',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Zahtevek je prevzet',
        'Undo & close window' => 'Razveljavi in zapri okno',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'Če želite sprejeti nekaj novic, licenco ali nekaj sprememb.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Poveži objekt: %s',
        'go to link delete screen' => 'pojdi na zaslon za brisanje povezave',
        'Select Target Object' => 'Izberi ciljni objekt',
        'Link Object' => 'Poveži objekt',
        'with' => 'z',
        'Unlink Object: %s' => 'Prekini povezavo z objektom: %s',
        'go to link add screen' => 'pojdi na zaslon za dodajanje povezave',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Uredite vaše nastavitve',

        # Template: AgentSpelling
        'Spell Checker' => 'Preverjanje pravopisa',
        'spelling error(s)' => 'Pravopisne napake',
        'Apply these changes' => 'Uporabi te spremembe',

        # Template: AgentStatsDelete
        'Delete stat' => 'Izbriši statistiko',
        'Stat#' => 'Statistika št.',
        'Do you really want to delete this stat?' => 'Ali res želite izbrisati to statistiko?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Korak %s',
        'General Specifications' => 'Splošna specifikacija',
        'Select the element that will be used at the X-axis' => 'Izberite elemente, ki se bodo uporabljali na X-osi',
        'Select the elements for the value series' => 'Izberite elemente za vrednosti serije',
        'Select the restrictions to characterize the stat' => 'Izberite omejitve za označevanje statistike',
        'Here you can make restrictions to your stat.' => 'Tukaj si lahko postavite omejitve za vašo statistiko.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Če odstranite oznako iz elementa "Fiksirano", bo zaposleni, ki kreira to statistiko, lahko menjaval atribute tega elementa.',
        'Fixed' => 'Fiksirano',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Prosimo, izberite le en element ali izklopite gumb "fiksirano"!',
        'Absolute Period' => 'Absolutno obdobje',
        'Between' => 'Med',
        'Relative Period' => 'Relativno obdobje',
        'The last' => 'Zadnje',
        'Finish' => 'Končaj',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Dovoljenja',
        'You can select one or more groups to define access for different agents.' =>
            'Izberete lahko eno ali več skupin za opredelitev dostopa za različne uporabnike.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            '',
        'Please contact your administrator.' => 'Obrnite se na skrbnika.',
        'Graph size' => 'Velikost grafa',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Če uporabljate graf kot izhodni format je potrebno izbrati vsaj eno velikost grafa.',
        'Sum rows' => 'Vsota vrstic',
        'Sum columns' => 'Vsota stolpcev',
        'Use cache' => 'Uporabi predspomin',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Večino statističnih podatkov se lahko kešira. To bo pohitrilo prikaz statistike.',
        'If set to invalid end users can not generate the stat.' => 'Če je neveljavno, končni uporabniki ne morejo generirati statistike.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Tukaj se lahko definira vrednosti.',
        'You have the possibility to select one or two elements.' => 'Možnost izbire med enim ali dvema elementoma.',
        'Then you can select the attributes of elements.' => 'Nato lahko izberete atribute za elemente.',
        'Each attribute will be shown as single value series.' => 'Vsak atribut bo prikazan kot posamezna vrednost.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Če ne izberete nobenega atributa, bodo med generiranjem statistike uporabljeni vsi atributi elementa kot tudi atributi ki so bili dodani pri zadnji konfiguraciji.',
        'Scale' => 'Lestvica',
        'minimal' => 'minimum',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Prosimo, upoštevajte, da lestvica za serijo vrednosti, mora biti večji od obsega za X-os (npr X-os => mesec; Vrednost obsega => leto).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Tukaj lahko določite x-osi. Izberete lahko en element preko radio gumba.',
        'maximal period' => 'maksimalno obdobje',
        'minimal scale' => 'minimalna lestvica',

        # Template: AgentStatsImport
        'Import Stat' => 'Uvozi statistiko',
        'File is not a Stats config' => 'Ta datoteka ni konfiguracija statistike',
        'No File selected' => 'Ni izbrana nobena datoteka',

        # Template: AgentStatsOverview
        'Stats' => 'Statistika',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Izbran ni noben element.',

        # Template: AgentStatsView
        'Export config' => 'Izvozi nastavitve',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Preko polja za vnos in izbor lahko vplicate na obliko in vsebino statistike.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Na katera polja in formate lahko vplivate je definirano iz strani administratorja statistike.',
        'Stat Details' => 'Podrobnosti staistke',
        'Format' => 'Format',
        'Graphsize' => 'Velikost grafa',
        'Cache' => 'Predspomin',
        'Exchange Axis' => 'Zamenjaj osi',
        'Configurable params of static stat' => 'Nastavitve parametrov statične statistike',
        'No element selected.' => 'Noben element ni izbran.',
        'maximal period from' => 'maksimalno obdobje od',
        'to' => 'do',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Sprememba "prostega" besedila zahtevka',
        'Change Owner of Ticket' => 'Spremeni lastnika zahtevka',
        'Close Ticket' => 'Zapri zahtevek',
        'Add Note to Ticket' => 'Dodaj opombo zahtevku',
        'Set Pending' => 'Dodaj na čakanje',
        'Change Priority of Ticket' => 'Spremeni prioriteto zahtevka',
        'Change Responsible of Ticket' => 'Spremeni odgovornega za reševanje zahtevka',
        'Service invalid.' => 'Neveljavna storitev',
        'New Owner' => 'Nov lastnik',
        'Please set a new owner!' => 'Prosimo, da se določi nov lastnik!',
        'Previous Owner' => 'Prejšnji lastnik',
        'Inform Agent' => 'Obvestilo zaposlenemu',
        'Optional' => 'Opcijsko',
        'Inform involved Agents' => 'Obvestiti vključene zaposlene',
        'Spell check' => 'Preverjanje pravopisa',
        'Note type' => 'Tip opombe',
        'Next state' => 'Naslednje stanje',
        'Date invalid!' => 'Nepravilen datum',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Preusmeri na',
        'You need a email address.' => 'Potrebujete e-poštni naslov.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Potrebujete veljaven naslov e-pošte in ne uporabljajte lokalnega e-poštnega naslova!',
        'Next ticket state' => 'Naslednji status zahtevka',
        'Inform sender' => 'Obvesti pošiljatelja',
        'Send mail!' => 'Pošlji E-pošto!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Skupinske akcije na zahtevkih',
        'Send Email' => 'Pošlji e-pošto',
        'Merge to' => 'Spoji v',
        'Invalid ticket identifier!' => 'Nepravilen identifikator zahtevka!',
        'Merge to oldest' => 'Spoji z najstarejšim',
        'Link together' => 'Poveži skupaj',
        'Link to parent' => 'Poveži z nadrejenim',
        'Unlock tickets' => 'Odkleni zahtevek',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Napiši odgovor na zahtevek',
        'Please include at least one recipient' => '',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Imenik',
        'Pending Date' => 'Datum čakanja',
        'for pending* states' => 'za stanje čakanja',
        'Date Invalid!' => 'Nepravilen datum!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Sprememba stranke na zahtevku',
        'Customer user' => 'Stranka',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Odpri nov zahtevek E-pošte',
        'From queue' => 'Iz vrste',
        'To customer user' => '',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer user as the main customer user.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Dobi vse',
        'Text Template' => '',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => '',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Zgodovina za',
        'History Content' => 'Vsebina zgodovine',
        'Zoom view' => 'Povečan pogled',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Spajanje zahtevka',
        'You need to use a ticket number!' => 'Prosimo vas da uporabljate številko zahtevka!',
        'A valid ticket number is required.' => 'Potrebna je veljavna številka zahtevka.',
        'Need a valid email address.' => 'Potreben je veljavni naslov E-pošte.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Premakni zahtevek',
        'New Queue' => 'Nova vrsta',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Izberi vse',
        'No ticket data found.' => 'Ni podatkov o zahtevku.',
        'First Response Time' => 'Čas prvega odgovora',
        'Update Time' => 'Čas posodobitve',
        'Solution Time' => 'Čas rešitve',
        'Move ticket to a different queue' => 'Premakni zahtevek v drugo vrsto',
        'Change queue' => 'Spremeni vrsto',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Spremeni možnosti iskanja',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Zahtevkov na stran',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Odpri nov telefonski zahtevek',
        'Please include at least one customer for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'To queue' => 'V vrsto',

        # Template: AgentTicketPhoneCommon

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Pregled neformatiranega besedila',
        'Plain' => 'Neformatirano',
        'Download this email' => 'Prevzemi to sporočilo',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informacije o zahtevku',
        'Accounted time' => 'Obračunan čas',
        'Linked-Object' => 'Povezan objekt',
        'by' => 'od',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Iskanje predloge',
        'Create Template' => 'Ustvari predlogo',
        'Create New' => 'Ustvari novo',
        'Profile link' => '',
        'Save changes in template' => 'Shrani spremembe v predlogo',
        'Add another attribute' => 'Dodaj še eno lastnost',
        'Output' => 'Pregled rezultatov',
        'Fulltext' => 'Besedilo',
        'Remove' => 'Odstrani',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Prijava uporabnika',
        'Created in Queue' => 'Ustvarjeno v vrsti',
        'Lock state' => 'Stanje zapore',
        'Watcher' => 'Opazovanje',
        'Article Create Time (before/after)' => 'Čas kreiranje članka (pred/potem)',
        'Article Create Time (between)' => 'Čas kreiranja članka (med)',
        'Ticket Create Time (before/after)' => 'Čas kreiranja zahtevka (pred/potem)',
        'Ticket Create Time (between)' => 'Čas kreiranja zahtevka (med)',
        'Ticket Change Time (before/after)' => 'Čas spremembe zahtevka (pred/potem)',
        'Ticket Change Time (between)' => 'Čas spremembe zahtevka (med)',
        'Ticket Close Time (before/after)' => 'Čas zaprtja zahtevka (pred/potem)',
        'Ticket Close Time (between)' => 'Čas zaprtja zahtevka (med)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Iskanje po arhivu',
        'Run search' => 'Išči',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filter za članke',
        'Article Type' => 'Tip članka',
        'Sender Type' => '',
        'Save filter settings as default' => 'Shrani nastavitve iltra kot privzete',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Locked' => 'Status',
        'Linked Objects' => 'Povezani objekti',
        'Article(s)' => 'interakcij',
        'Change Queue' => 'Spremeni vrsto',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Add Filter' => 'Dodaj filter',
        'Set' => 'Nastavi',
        'Reset Filter' => 'Reset filtra',
        'Show one article' => 'Prikaži en članek',
        'Show all articles' => 'Prikaži vse članke',
        'Unread articles' => 'Neprebrani članki',
        'No.' => 'Št.',
        'Important' => '',
        'Unread Article!' => 'Neprebrani članki!',
        'Incoming message' => 'Dohodno sporočilo',
        'Outgoing message' => 'Odhodno sporočilo',
        'Internal message' => 'Notranje sporočilo',
        'Resize' => 'Sprememba velikosti',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Naloži blokirane vsebine.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Slijeđevina',

        # Template: CustomerFooter
        'Powered by' => 'Poganja',
        'One or more errors occurred!' => 'Ena ali več napak!',
        'Close this dialog' => 'Zapri to pogovorno okno',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Ni bilo mogoče odpreti okna. Prosimo izključite vse zaviralce popup-ov za to aplikacijo.',
        'There are currently no elements available to select from.' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript ni dostopen.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Kako bi ste koristili OTRS potrebno je aktivirati JavaScript u vašem web pregledniku.',
        'Browser Warning' => 'Opozorilo brskalnika',
        'The browser you are using is too old.' => 'Brskalnik katerega uporabljate je prestar.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS teče na veliko brskalnikih, prosimo nadgradite vaš brskalnik na enega od teh.',
        'Please see the documentation or ask your admin for further information.' =>
            'Prosimo, si oglejte dokumentacijo ali pa se posvetujte z vašim adminom za dodatne informacije.',
        'Login' => 'Prijava',
        'User name' => 'Uporabniško ime',
        'Your user name' => 'Vaše uporabniško ime',
        'Your password' => 'Vaše geslo',
        'Forgot password?' => 'Ste pozabili geslo?',
        'Log In' => 'Prijavi se',
        'Not yet registered?' => 'Niste registrirani?',
        'Sign up now' => 'Registrirajte se zdaj',
        'Request new password' => 'Zahtevaj novo geslo',
        'Your User Name' => 'Vaše uporabniško ime',
        'A new password will be sent to your email address.' => 'Novo geslo bo poslano na vašo e-pošto.',
        'Create Account' => 'Ustvari račun',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Kako vas naj nasljavljamo',
        'Your First Name' => 'Vaše ime',
        'Your Last Name' => 'Vaš priimek',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Uredite osebne podatke',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Sporazum o ravni storitev',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Dobrodošli!',
        'Please click the button below to create your first ticket.' => 'Kliknite spodnji gumb, da ustvarite svoj ​​prvi zahtevek.',
        'Create your first ticket' => 'Ustvarite svoj ​​prvi zahtevek',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Tiskanje zahtevka',
        'Ticket Dynamic Fields' => '',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'npr 10*5155 ali 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Iskanje teksta v zahtevkih (npr "Mar*a" ali "Hor*i")',
        'Carbon Copy' => 'Kopija',
        'Types' => 'Tipi',
        'Time restrictions' => 'Časovna omejitev',
        'No time settings' => '',
        'Only tickets created' => 'Samo odprti zahtevki',
        'Only tickets created between' => 'Samo zahtevki odprti med',
        'Ticket archive system' => '',
        'Save search as template?' => 'Shrani iskanje kot predlogo',
        'Save as Template?' => 'Shrani kot predlogo?',
        'Save as Template' => '',
        'Template Name' => 'Naziv predloga',
        'Pick a profile name' => '',
        'Output to' => 'Izhod na',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'od',
        'Page' => 'Stran',
        'Search Results for' => 'Rezultati iskanja za',

        # Template: CustomerTicketZoom
        'Expand article' => '',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'Odgovori',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
        'Sunday' => 'nedelja',
        'Monday' => 'ponedeljek',
        'Tuesday' => 'torek',
        'Wednesday' => 'sreda',
        'Thursday' => 'četrtek',
        'Friday' => 'petek',
        'Saturday' => 'sobota',
        'Su' => 'ned',
        'Mo' => 'pon',
        'Tu' => 'tor',
        'We' => 'sre',
        'Th' => 'čet',
        'Fr' => 'pet',
        'Sa' => 'sob',
        'Event Information' => '',
        'Ticket fields' => '',
        'Dynamic fields' => '',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Napravilen datum (potreben datum v prihodnosti)!',
        'Previous' => 'Nazaj',
        'Open date selection' => 'Odpri izbor datuma',

        # Template: Error
        'Oops! An Error occurred.' => 'Ups. Prišlo je do napake.',
        'Error Message' => 'Sporočilo o napaki',
        'You can' => 'Vi lahko',
        'Send a bugreport' => 'pošlji poročilo o napaki',
        'go back to the previous page' => 'Pojdi nazaj na prejšnjo stran',
        'Error Details' => 'Podrobnosti o napaki',

        # Template: Footer
        'Top of page' => 'Na vrh strani',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Če zapustite to stran, bodo tudi vsa odprta popup okna zaprta!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Popup tega zaslona je že odprt. Ali ga želite zapreti in odpreti tega namesto njega?',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Prijavljeni ste kot',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript ni dostopen.',
        'Database Settings' => 'Database nastavitve',
        'General Specifications and Mail Settings' => 'Splošne tehnične zahteve in nastavitve za e-pošto',
        'Registration' => '',
        'Welcome to %s' => 'Dobrodošli na %s',
        'Web site' => 'Web stran',
        'Mail check successful.' => 'Pregled E-pošte uspešen.',
        'Error in the mail settings. Please correct and try again.' => 'Napaka v poštnih nastavitvah. Prosimo, poskusite znova.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Nastavite izhodne E-pošte',
        'Outbound mail type' => 'Tipi izhodne E-pošte',
        'Select outbound mail type.' => 'Izberite tip izhodne E-pošte',
        'Outbound mail port' => 'Port za izhodno E-pošto',
        'Select outbound mail port.' => 'Izberi port za izhodno E-pošto',
        'SMTP host' => 'SMTP host',
        'SMTP host.' => 'SMTP host.',
        'SMTP authentication' => 'SMTP avtentikacija',
        'Does your SMTP host need authentication?' => 'Ali zahteva vaš SMTP host avtentikacijo?',
        'SMTP auth user' => 'SMTP uporabnik',
        'Username for SMTP auth.' => 'uporabniško ime za SMTP avtentikacijo',
        'SMTP auth password' => 'SMTP geslo',
        'Password for SMTP auth.' => 'Geslo za SMTP avtentikacijo',
        'Configure Inbound Mail' => 'Nastavitve vstopne E-pošte',
        'Inbound mail type' => 'Tip vstopne E-pošte',
        'Select inbound mail type.' => 'Izberi tip vstopne E-pošte',
        'Inbound mail host' => 'Server vstopne E-pošte',
        'Inbound mail host.' => 'Server vstopne E-pošte.',
        'Inbound mail user' => 'Uporabnik vstopne E-pošte',
        'User for inbound mail.' => 'Uporabnik vstopne E-pošte',
        'Inbound mail password' => 'Geslo vstopne E-pošte',
        'Password for inbound mail.' => 'Geslo vstopne E-pošte',
        'Result of mail configuration check' => 'Rezultat preverjanja nastavitev E-pošte',
        'Check mail configuration' => 'Preverite konfiguracijo E-pošte',
        'Skip this step' => 'Preskoči ta korak',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Baza podatkov uspešno nameščena',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => 'Preverite nastavitve baze podatkov',
        'Result of database check' => 'Rezultat preverjanja baze podatkov',
        'OK' => '',
        'Database check successful.' => 'Pregled baze podatkov uspešen.',
        'Database User' => '',
        'New' => 'Novo',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Novi uporabnik baze z omejenimi pravicami bo ustvarjen za ta OTRS sistem',
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
            'Da biste mogli koristiti OTRS morate unijeti slijedeću liniju u Vašu komandnu liniju (Terminal/Shell) kao "root".',
        'Restart your webserver' => 'Ponovno zaženite Vaš WEB Server.',
        'After doing so your OTRS is up and running.' => 'Po tem bo vaš OTRS pripravljen na delo.',
        'Start page' => 'ŽZačetna stran',
        'Your OTRS Team' => 'Vaš OTRS Tim',

        # Template: InstallerLicense
        'Accept license' => 'Sprejmi licenco',
        'Don\'t accept license' => 'Ne sprejmite licence',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organizacija',
        'Position' => '',
        'Complete registration and continue' => '',
        'Please fill in all fields marked as mandatory.' => '',

        # Template: InstallerSystem
        'SystemID' => 'Sistemski ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Sustavski identifikator. Svaki broj kartice i svaki ID HTTP sesije sadrži ovaj broj.',
        'System FQDN' => 'Sistemski FQDN',
        'Fully qualified domain name of your system.' => 'FQDN - ime servera uključujući puno ime domena, npr. "otrs-server.example.org"',
        'AdminEmail' => 'E-mail administrator',
        'Email address of the system administrator.' => 'E-poštni naslov administratorja sistema.',
        'Log' => 'Dnevnik',
        'LogModule' => 'Modul dnevnika',
        'Log backend to use.' => 'Sistem, ki se uporablja za dnevnik.',
        'LogFile' => 'Datoteka dnevnika',
        'Webfrontend' => 'Mrežno sučelje',
        'Default language' => 'Privzeti jezik',
        'Default language.' => 'Privzeti jezik.',
        'CheckMXRecord' => 'Preveri DNS/MX podatke',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Ručno unesena e-mail adresa se provjerava pomoću MX podatka pronađenog u DNS-u. Nemojte koristiti ovu opciju ako je vaš DNS spor ili ne može razriješiti javne adrese.',

        # Template: LinkObject
        'Object#' => 'Objekt#',
        'Add links' => 'Dodaj povezave',
        'Delete links' => 'Izbriši povezave',

        # Template: Login
        'Lost your password?' => 'Ste pozabili geslo?',
        'Request New Password' => 'Zahtevaj novo geslo',
        'Back to login' => 'Nazaj na prijavo',

        # Template: Motd
        'Message of the Day' => 'Sporočilo dneva',

        # Template: NoPermission
        'Insufficient Rights' => 'Nezadostne pravice',
        'Back to the previous page' => 'Nazaj na prejšnjo stran',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Prikaži prvo stran',
        'Show previous pages' => 'Prikaži prejšnje strani',
        'Show page %s' => 'Prikaži stran %s',
        'Show next pages' => 'Prikaži naslednjo stran',
        'Show last page' => 'Prikaži zadnje strani',

        # Template: PictureUpload
        'Need FormID!' => 'Potrebujete FormID!',
        'No file found!' => 'Datoteka ni najdena!',
        'The file is not an image that can be shown inline!' => 'Datoteka ni slika, ki se lahko neposredno prikaže!',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'Natisnil',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS testna stran',
        'Welcome %s' => 'Dobrodošli %s',
        'Counter' => 'Števec',

        # Template: Warning
        'Go back to the previous page' => 'Pojdi nazaj na prejšnjo stran',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '"ACL" modul, ki omogoča da se zaprejo matični zahtevki le če so že zaprti vsi pod-zahtevki (Status kaže kateri statusi niso na voljo za zahtevek dokler se ne zaprejo vsi podrejeni zahtevki.',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Aktivira mehanizem utripa vrste, ki vsebuje najstarejše zahtevek.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Aktivira možnost izgubljenega gesla za zaposlene na njihovem vmesniku.',
        'Activates lost password feature for customers.' => 'Aktivira možnost izgubljenega gesla za uporabnike',
        'Activates support for customer groups.' => 'Aktivira podporo za skupine uporabnikov.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Aktivira filter za razširjeni pregled člankov, da se opredeli kateri članki bi naj bil predstavljeni.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Aktivira razpoložljive teme v sistem. Vrednost 1 pomeni aktivne, 0 pomeni neaktivni.',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Aktiviranje arhiva sistema za pospešitev dela, odstranjevanje nekaterih zahtevkov iz dnevnega spremljanja. Če želite poiskati zahtevek, mora biti označen arhiv omogočen za iskanje zahtevkov.',
        'Activates time accounting.' => 'Aktiviranje časa.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Trajno dodaja počitnice. Prosimo, uporabite enomestno številko od 1 do 9 (namesto 01-09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Trajno dodaja počitnice. Prosimo, uporabite enomestno številko od 1 do 9 (namesto 01-09).',
        'Agent Notifications' => 'Obvestilo zaposlenim',
        'Agent interface article notification module to check PGP.' => 'Vmesnik modula za zaposlene za obveščanje o članku, preverite PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Vmesnik modula za zaposlene za obveščanje o članku, preverite S/MIME',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Vmesnik modula zaposleni za dostop do besedila iskanega po navigacijski vrstici.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Modul vmesnikov za dostop do profilov zaposlenih najdenih po navigacijski vrstici.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Vmesnik modula zaposleni za pregled dohodnih sporočil v povečanem pogledu zahtevka, če "S/MIME" ključ obstaja in je na voljo.',
        'Agent interface notification module to check the used charset.' =>
            'Vmesnik modula zaposleni za pregled uporabljenega nabora znakov.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Vmesnik modula za obveščanje zaposlenih, pogled na število zahtevkov, za katere je odgovoren posrednik.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Vmesnik modula za obveščanje zaposlenih, skupaj s pregledom zahtevka.',
        'Agents <-> Groups' => 'Operaterji <-> Skupine',
        'Agents <-> Roles' => 'Operaterji <-> Vloge',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'omogoča dodajanje opomb v zaprto okno zahtevka vmesnika zaposlenega.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Omogoča dodajanje opomb v okno za besedilo v vmesniku zaposlenega.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Omogoča dodajanje opomb v okna za opombe v vmesniku zaposlenega.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Omogoča dodajanje opomb v okno lastnika zahtevka na povečanem pogledu vmesnika zaposlenega.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Omogoča dodajanje opomb v okno na čakanju povečanega pogleda v vmesniku zaposlenega.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Omogoča dodajanje opombe v okno za prioritete na povečanem prikazu v vmesniku zaposlenega.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Omogoča dodajanje opomb v okno odgovornega za zahtevek v vmesniku zaposlenega.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Omogoča zaposlenim, da spremenijo osi statistike, če jo ustvarijo.',
        'Allows agents to generate individual-related stats.' => 'Omogoča zaposlenim, da ustvarjajo posamezne statistične podatke.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Omogoča izbiro med prikazovanjem prilog v brskalniku ali pa da jih prenesete.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Omogoča izbor naslednjega stanja za zahtevek v uporabniškem vmesniku.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Omogoča uporabnikom da spremenijo prioritete zahtevka v uporabniškem vmesniku.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Omogoča uporabnikom da nastavijo SLA za zahtevek v uporabniškem vmesniku.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Omogoča uporabnikom da nastavijo prioritete zahtevkom v uporabniškem vmesniku.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Omogoča uporabnikom da postavijo vrste za zahtevek v uporabniškem vmesniku. Če je postavljeno na "Ne", potem je potrebno nastaviti "QueueDefault".',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Omogoča uporabnikom, da postavijo servis za zahtevek v uporabniškem vmesniku.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Omogoča določitev novih vrst zahtevkov (če je omogočen tip funkcije zahtevka).',
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
        'Auto Responses <-> Queues' => 'Avtomatski odgovor <-> Vrste',
        'Automated line break in text messages after x number of chars.' =>
            'Avtomatizirani prelom vrstice v tekstovnih sporočil po x število znakov.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Avtomatsko prevzemanje in nastavitev lastnika za aktualnega zaposlenega po izboru masovne akcije.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Uravnotežen beli izgled, Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            'generiraj indeks članka takoj po kreiranju le tega.',
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
        'Change password' => 'Sprememba gesla',
        'Change queue!' => 'Sprememba vrste!',
        'Change the customer for this ticket' => '',
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
        'Comment for new history entries in the customer interface.' => 'Komentar za nove zgodovinske vnose v uporabniškem vmesniku.',
        'Company Status' => '',
        'Company Tickets' => 'Zahtevek podjetja',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Kontrole, če imajo uporabniki možnost, da razvrstijo svoje zahtevke.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Pretvori HTML sporočila v tekstovna sporočila.',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Upravljanje in ustvarjanje s SLA.',
        'Create and manage agents.' => 'Upravljanje in ustvarjanje z operaterji.',
        'Create and manage attachments.' => 'Upravljanje in ustvarjanje s priponkami.',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'Upravljanje in ustvarjanje strank.',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => 'Upravljanje in ustvarjanje z dogodki na bazi obvestil.',
        'Create and manage groups.' => 'Upravljanje in ustvarjanje skupin.',
        'Create and manage queues.' => 'Upravljanje in ustvarjanje z vrstami.',
        'Create and manage responses that are automatically sent.' => 'Upravljanje in ustvarjanje z avtomatskim odgovorom.',
        'Create and manage roles.' => 'Upravljanje in ustvarjanje z vlogami.',
        'Create and manage salutations.' => 'Upravljanje in ustvarjanje pozdravov.',
        'Create and manage services.' => 'Upravljanje in ustvarjanje servisov.',
        'Create and manage signatures.' => 'Upravljanje in ustvarjanje podpisov.',
        'Create and manage templates.' => '',
        'Create and manage ticket priorities.' => 'Upravljanje in ustvarjanje s prioritetami zahtevka.',
        'Create and manage ticket states.' => 'Upravljanje in ustvarjanje s statusi zahtevkov.',
        'Create and manage ticket types.' => 'Upravljanje in ustvarjanje tipov zahtevkov.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'Ustvari nov e-poštni zahtevek in pošlji to (izhodni)',
        'Create new phone ticket (inbound)' => 'Ustvari nov teleonski zahtevek (vhodni klic)',
        'Create new process ticket' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User <-> Groups' => '',
        'Customer User <-> Services' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Stranke',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Stranke <-> Skupine',
        'Data used to export the search result in CSV format.' => 'Podatki, ki se uporabljajo za izvoz rezultatov iskanja v formatu CSV.',
        'Date / Time' => 'Datum/Čas',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => 'Privzete ACL vrednosti za akcije zahtevka.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'Privzeti modul zazaščito od zanke',
        'Default queue ID used by the system in the agent interface.' => 'Privzeti ID vrste, ki ga uporablja sistem v vmesniku zaposlenega.',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'Privzet ID zahtevka, ki ga uporablja sistem v vmesniku zaposlenega.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Privzeto ID zahtevka, ki ga uporablja sistem v uporabniškem vmesniku.',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            '',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => 'Določi prvi dan v tednu za izbor datuma.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Določa uporabnikov element, ki ustvarja LinkedIn ikono na koncu info bloka uporabnika.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Določa uporabnikov element, ki ustvarja XING ikono na koncu info bloka uporabnika.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Določa uporabnikov element, ki ustvarja google ikono na koncu info bloka uporabnika.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Določa uporabnikov element, ki ustvarja google maps ikono na koncu info bloka uporabnika.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Določa privzeti seznam besed, ki jih ignorira črkovalnik.',
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
        'Defines all the X-headers that should be scanned.' => 'Določi vse X-glave, ki jih je potrebno pregledati.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Določa vse parametre za to postavko v uporabniških nastavitvah.',
        'Defines all the possible stats output formats.' => 'Določa vse mogoče izhodne formate statistike.',
        'Defines an alternate URL, where the login link refers to.' => 'Določa nadomestni URL, na povezavo za prijavo.',
        'Defines an alternate URL, where the logout link refers to.' => 'Določa nadomestni URL, na povezavo za odjavo.',
        'Defines an alternate login URL for the customer panel..' => 'Določa nadomestni URL prijave za uporabniško ploščo.',
        'Defines an alternate logout URL for the customer panel.' => 'Določa nadomestni URL odjave za uporabniško ploščo.',
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
            'Določa ali je potrebno sporočilom napisanim v vmesniku zaposlenega pregledati pravopis.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Določa če je obračun časa obvezen v vmesniku zaposlenega.',
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
        'Defines the URL CSS path.' => 'Določa "URL CSS" pot.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Določa URL osnovno pot za statično web vsebino (ikone, CSS, JS).',
        'Defines the URL image path of icons for navigation.' => 'Določa URL pot do slik za navigacijske ikone.',
        'Defines the URL java script path.' => 'Določi URL pot java script.',
        'Defines the URL rich text editor path.' => 'Določa URL pot do aplikacije za urejanje "RTF" datotek',
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
        'Defines the body text for rejected emails.' => 'Določa besedilo za zavrnjena sporočila.',
        'Defines the boldness of the line drawed by the graph.' => 'Določa debelino linij za grafe.',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => 'Določa barve za grafe.',
        'Defines the column to store the keys for the preferences table.' =>
            'Določa stolpec za shranjevanje ključev v nastavitveni tabeli.',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Privzete povezave za "http/ftp" preko proxy.',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => 'Določa privzet CSS uporabljen v "RTF" urejanju.',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
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
            'Določa privzeto prednostno nalogo novega zahtevka uporabnika v uporabniškem vmesniku.',
        'Defines the default priority of new tickets.' => 'Določa privzeto prednostno nalogo za nove zahtevke.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Določa privzeto čakalno vrsto za nove zahtevke uporabnika v uporabniškem vmesniku.',
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
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => 'Določa privzet slovar za preverjanje pravopisa.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => 'Določa privzeto stanje novih zahtevkov.',
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
        'Defines the height of the legend.' => 'Določa višino legende.',
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
        'Defines the hours and week days to count the working time.' => 'Določa ure in dni za štetje delovnega časa.',
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
            'Določa maksimalno veljaven čas (v sekundah) za id seje.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Določa največje število strani v PDF datoteki.',
        'Defines the maximum size (in MB) of the log file.' => 'Določa največjo velikost (v MB) za log datoteko.',
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
        'Defines the module to authenticate customers.' => 'Določa modul za avtentifikacijo uporabnika.',
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
        'Defines the name of the key for customer sessions.' => 'Določa ime ključa za uporabniške seje.',
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
        'Defines the spacing of the legends.' => 'Določa razmik v legendi.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => 'Določa standardne velikosti PDF strani.',
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
        'Defines the subject for rejected emails.' => 'Določa temo za zavrnjena sporočila.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            '',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
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
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for email quotes in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'Določa indetifikator uporabnika za uporabniško ploščo.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => 'Določa veljavno stanje tipov za zahtevek.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => 'Določa širino legende.',
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
        'Email Addresses' => 'Naslov E-pošte',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Omogoča "S/MIME" podporo.',
        'Enables customers to create their own accounts.' => 'Omogoča uporabnikom, da ustvarijo svoje račune.',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Omogoča podporo za preverjanje pravopisa.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Pregled eskalacij',
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
        'Execute SQL statements.' => 'Izvedi SQL ukaze.',
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
        'Filter incoming emails.' => 'Filter dohodne e-pošte.',
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
        'Frontend language' => 'Jezik vmesnika',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Tema vmesnika',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'General ticket data shown in the dashboard widgets. Possible settings: 0 = Disabled, 1 = Enabled. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'GenericAgent' => '',
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
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is enabled, then the decrypted data will be stored in the database if they are displayed in AgentTicketZoom.' =>
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
        'Interface language' => 'Jezik vmesnika',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Link agents to groups.' => 'Poveži operaterje s skupinami.',
        'Link agents to roles.' => 'Poveži operaterje z vlogami.',
        'Link attachments to templates.' => '',
        'Link customer user to groups.' => '',
        'Link customer user to services.' => '',
        'Link queues to auto responses.' => 'Poveži vrste z avtomatskim odgovorom.',
        'Link roles to groups.' => 'Poveži vloge s skupinama.',
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
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'Log datoteka za števec zahtevka.',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => 'Omogoča transparentnost slike',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => 'Upravljanje s PGP ključi za šifriranje e-pošte.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Upravljanje z računi POP3 in IMAP za sprejemanje pošte',
        'Manage S/MIME certificates for email encryption.' => 'Upravljanje z S/MIME certifikati za šifriranje e-pošte',
        'Manage existing sessions.' => 'Upravljanje z obstoječimi sejami.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Upravljanje rednih nalog.',
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
        'Module to check customer permissions.' => 'Moduli za pregled dovolenj uporabnikov.',
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
        'My Tickets' => 'Moji zahtevki',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Nov zahtevek E-pošte',
        'New phone ticket' => 'Nov telefonski zahtevek',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Obvestila (dogodki)',
        'Number of displayed tickets' => 'Število prikazanih zahtevkov',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Pregled eskaliranih zahtevkov',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => 'Pregled vseh odprtih zahtevkov.',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'Pošiljanje "PGP" ključa',
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
        'Permitted width for compose email windows.' => 'Dovoljena širina okna za pisanje sporočila.',
        'Permitted width for compose note windows.' => 'Dovoljena širina okna za pisanje opomb.',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'PostMaster filtri',
        'PostMaster Mail Accounts' => 'PostMaster računi E-pošte',
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
        'Queue view' => 'Pregled po vrstah',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => '',
        'Refresh interval' => 'Interval osveževanja',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Zamjenjuje originalnog pošiljaoca adresom E-pošte trenutnog korisnika pri kreiranju odgovora u prozoru za pisanje odgovora sučelja zaposlenika.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'potrebujete dovolenja za spremembo uporabnika zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Potrebujete dovolenja za uporabo okna za zapiranje zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Potrebujete dovolenja za uporabo okna za zavračanej zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'potrebujete dovolenja za uporabo okna za odpiranje zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Potrebujete dovolenja za uporabo okna posredovanje zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Potrebujete dovolenja za uporabo okna za besedilo zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Potrebna dovolenja za uporabo okna za združevanje pri povečanem prikazu zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Potrebna dovolenja za uporabo okna za opombe zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Potrebna dovolenja za uporabo okna lastnika zahtevka pri povečanem prikazu zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Potreban dovolenja za uporabo okna za čakanej pri povečanem prikazu zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Potreban dovolenja za uporabo okna za telefonski vnos zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Potrebna dovolenja za uporabo okna prioriteta pri povečanemu prikazu zahtevka v vmesniku zaposlenega.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Potrebujete dovolenja za uporabo okna odgovornega za zahtevek v vmesniku zaposlenega.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Ponastavi in odklene lastnika zahtevka če je bil zahtevek premakjen v drugo vrsto.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Obnovi zahtevek iz arhiva (samo če je status spremenjen iz zaprtega na katerikoli dostopen odprt status).',
        'Roles <-> Groups' => 'Vloge <-> Skupine',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Pošiljanje "S/MIME" certifikata',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search Customer' => 'Iskanje kupca',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Izberite temo vmesnika',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Pošljite mi obvestila, če stranka pošlje nadaljevanje zahtevka in sem lastnik zahtevka ali je zahtevek odklenjen in je v eni od mojih naročenih čakalnih vrst.',
        'Send notifications to users.' => 'pošlji obvestilo uporabnikom.',
        'Send ticket follow up notifications' => 'Pošlji obvestilo o nadaljevanju zahtevka',
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
        'Set sender email addresses for this system.' => 'Sistemski naslov pošiljatelja.',
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
        'Sets the size of the statistic graph.' => 'Nastavi velikost grafa statistike.',
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
        'Skin' => 'Izgled',
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
        'Statistics' => 'Statistika',
        'Status view' => 'Pregled glede na stanje',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'Shrani piškotke po zaprtju brskalnika.',
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
        'This event module stores attributes from CustomerUser as DynamicFields tickets. Please see the setting above for how to configure the mapping.' =>
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
        'Ticket overview' => 'Pregled zahtevka',
        'TicketNumber' => '',
        'Tickets' => 'Zahtevki',
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
            'Posodobi oznako pregledanih zahtevkov če so vsi pregledani ali pa je bil ustvarjen nov članek.',
        'Update and extend your system with software packages.' => 'Posodobi in nadgradi vaš sistem s programskimi paketi.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Posodobi indeks eskalacije zahtevka za posodobitvijo lastnosti zahtevka.',
        'Updates the ticket index accelerator.' => 'Posodobi indeks zahtevka.',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Pregled rezultatov za merilo uspešnosti.',
        'View system log messages.' => 'Pregled logiranih sporočil sistema.',
        'Wear this frontend skin' => 'Uporabi ta izgled vmesnika',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Ko se združijo zahtevki je lahko uporabnik obveščen na email z potrditvijo potrditvenega polja "Inform Sender". V polju za tekst lahko določite vnaprej oblikovano besedilo, ki ga bodo lahko kasneje spreminjali uporabniki.',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Vrsta je izbor vaših najljubših čakalnih vrst. Dobite lahko tudi obvestilo o teh čakalnih vrstah preko e-pošte če je le-to omogočeno.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Add Customer Company' => 'Dodaj uporabniško podjetje',
        'Add Response' => 'Dodaj odgovor',
        'Add customer company' => 'Dodaj uporabnikovo podjetje',
        'Add response' => 'Dodaj odgovor',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Doda po meri e-mail naslov prejemnika v oknu, da odprete zahtevek na vmesniku zaposlenega.',
        'Attachments <-> Responses' => 'Priloge <-> Odgovori',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Geslo ne more biti posodobljeno. Vsebovati mora vsaj 2 veliki in dve mali črki.',
        'Change Attachment Relations for Response' => 'Spremeni povezave z prilogami za odgovor',
        'Change Queue Relations for Response' => 'Spremeni povezave z vrstami z odgovorom',
        'Change Response Relations for Attachment' => 'Spremeni povezave z odgovori za priloge',
        'Change Response Relations for Queue' => 'Spremeni povezave odgovorov z vrsto',
        'Create and manage companies.' => 'Upravljanje in ustvarjanje s podjetji.',
        'Create and manage response templates.' => 'Upravljanje in ustvarjanje predlog odgovorov.',
        'Currently only MySQL is supported in the web installer.' => 'Trenutno je samo MySQL podržan u Web Instalaciji.',
        'Customer Company Management' => 'Urejevanje uporabniških podjetji',
        'Customer Data' => 'Podatki o stranki',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Potrebna je stranka, da je omogočena zgodovina stranke in da se prijavie preko plošče stranke.',
        'Customers <-> Services' => 'Stranke <-> Servisi',
        'DB host' => 'Naziv ali naslov DB serverja',
        'Database-User' => 'Uporabnik baze podatkov',
        'Default skin for interface.' => 'Privzeti izgled za vmesnik.',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            'Določa maksimalne velikosti (v bajtih) za datoteke dodane preko brskalnika.',
        'Edit Response' => 'Uredi odgovor',
        'Escalation in' => 'Eskalacija v',
        'False' => '"False"',
        'Filter for Responses' => 'Filter za odgovore',
        'Filter name' => 'Ime filtra',
        'For more info see:' => 'Za več informacij si oglejte:',
        'From customer' => 'Od stranke',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Ako ste podesili "root" lozinku za vašu bazu podataka, ona mora biti unesena ovdje. Ako nema lozinke, ostavite polje prazno. Iz sigurnosnih razloga preporučujemo da je podesite. Za više informacija proučite dokumentaciju o bazi podataka.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Ako želite instalirati OTRS na neki drugi sustav baze podataka, proučite informacije u datoteci README.database.',
        'Link attachments to responses templates.' => 'Poveži priloge s predlogami.',
        'Link customers to groups.' => 'Poveži stranke s skupinami.',
        'Link customers to services.' => 'Poveži stranke s servisi.',
        'Link responses to queues.' => 'Poveži odgovore z vrsto.',
        'Log file location is only needed for File-LogModule!' => 'Lokacija datoteke dnevnika je jedino neophodna za Modul dnevnika!',
        'Logout successful. Thank you for using OTRS!' => 'Odjava uspešna.',
        'Manage Response-Queue Relations' => 'Upravljanje z odgovori <-> vrstami',
        'Manage Responses' => 'Upravljanje z odgovori',
        'Manage Responses <-> Attachments Relations' => 'Upravljanje z odgovori <-> odnosi z priponkami',
        'Package verification failed!' => 'Preverjanje paketa ni uspelo!',
        'Password is required.' => 'Geslo je potrebno.',
        'Please enter a search term to look for customer companies.' => 'Prosimo vnesite iskalni izraz za iskanje podjetji stranke.',
        'Please supply a' => 'Prosimo, vnesite',
        'Please supply a first name' => 'Prosimo, vnesite ime',
        'Please supply a last name' => 'Prosimo, vnesite priimek',
        'Responses' => 'Odgovori',
        'Responses <-> Queues' => 'Odgovori <-> Vrste',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Varni način mora biti onemogočen zaradi ponovne instalacije preko weba.',
        'To customer' => 'Stranka',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            'Ko se združijo zahtevki, zahtevku ki ni aktiven se bo avtomatsko dodala opomba. V prostoru za tekst lahko definirate naslednji tekst (Uporabniki ne morejo spreminjati tega besedila).',
        'before' => 'pred',
        'default \'hot\'' => 'privzeto \'hot\'',
        'settings' => 'nastavitve',

    };
    # $$STOP$$
    return;
}

1;
