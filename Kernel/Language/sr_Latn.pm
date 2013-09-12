# --
# Kernel/Language/sr_Latn.pm - provides Serbian language Cyrillic translation
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# Copyright (C) 2010 Milorad Jovanovic <j.milorad at gmail.com>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::sr_Latn;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-09-05 16:52:08

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
        'Off' => 'Isključeno',
        'off' => 'isključeno',
        'On' => 'Uključeno',
        'on' => 'uključeno',
        'top' => 'vrh',
        'end' => 'kraj',
        'Done' => 'Gotovo',
        'Cancel' => 'Odustani',
        'Reset' => 'Poništi',
        'more than ... ago' => '',
        'in more than ...' => '',
        'within the last ...' => '',
        'within the next ...' => '',
        'Created within the last' => '',
        'Created more than ... ago' => '',
        'Today' => 'danas',
        'Tomorrow' => 'Sutra',
        'Next week' => '',
        'day' => 'dan',
        'days' => 'dani',
        'day(s)' => 'dan(i)',
        'd' => 'd',
        'hour' => 'sat',
        'hours' => 'sati',
        'hour(s)' => 'sat(i)',
        'Hours' => 'Sati',
        'h' => 's',
        'minute' => 'minut',
        'minutes' => 'minuti',
        'minute(s)' => 'minut(i)',
        'Minutes' => 'Minuti',
        'm' => 'm',
        'month' => 'mesec',
        'months' => 'meseci',
        'month(s)' => 'mesec(i)',
        'week' => 'sedmica',
        'week(s)' => 'sedmic(e)',
        'year' => 'godina',
        'years' => 'godine',
        'year(s)' => 'godin(e)',
        'second(s)' => 'sekund(e)',
        'seconds' => 'sekunde',
        'second' => 'sekunda',
        's' => 's',
        'Time unit' => '',
        'wrote' => 'napisao',
        'Message' => 'Poruka',
        'Error' => 'Greška',
        'Bug Report' => 'Prijava greške',
        'Attention' => 'Pažnja',
        'Warning' => 'Upozorenje',
        'Module' => 'Modul',
        'Modulefile' => 'Datoteka modula',
        'Subfunction' => 'Podfunkcija',
        'Line' => 'Linija',
        'Setting' => 'Podešavanje',
        'Settings' => 'Podešavanja',
        'Example' => 'Primer',
        'Examples' => 'Primeri',
        'valid' => 'važeći',
        'Valid' => 'Važeći',
        'invalid' => 'nevažeći',
        'Invalid' => 'Nevažeći',
        '* invalid' => '* nevažeći',
        'invalid-temporarily' => 'nevažeći-privremeno',
        ' 2 minutes' => ' 2 minuta',
        ' 5 minutes' => ' 5 minuta',
        ' 7 minutes' => ' 7 minuta',
        '10 minutes' => '10 minuta',
        '15 minutes' => '15 minuta',
        'Mr.' => 'Gospodin',
        'Mrs.' => 'Gospođa',
        'Next' => 'Sledeće',
        'Back' => 'Nazad',
        'Next...' => 'Sledeće...',
        '...Back' => '...Nazad',
        '-none-' => '-nijedan-',
        'none' => 'nema',
        'none!' => 'nema unosa!',
        'none - answered' => 'nema - odgovoreno',
        'please do not edit!' => 'Molimo, ne menjajte!',
        'Need Action' => 'Potrebna akcija',
        'AddLink' => 'Dodaj vezu',
        'Link' => 'Poveži',
        'Unlink' => 'Prekini vezu',
        'Linked' => 'Povezano',
        'Link (Normal)' => 'Veza (Normalno)',
        'Link (Parent)' => 'Veza (Roditelj)',
        'Link (Child)' => 'Veza (Dete)',
        'Normal' => 'Normalno',
        'Parent' => 'Roditelj',
        'Child' => 'Dete',
        'Hit' => 'Pogodak',
        'Hits' => 'Pogotci',
        'Text' => 'Tekst',
        'Standard' => 'Normalan',
        'Lite' => 'Jednostavan',
        'User' => 'Korisnik',
        'Username' => 'Korisničko ime',
        'Language' => 'Jezik',
        'Languages' => 'Jezici',
        'Password' => 'Lozinka',
        'Preferences' => 'Podešavanja',
        'Salutation' => 'Pozdrav',
        'Salutations' => 'Pozdravi',
        'Signature' => 'Potpis',
        'Signatures' => 'Potpisi',
        'Customer' => 'Korisnik',
        'CustomerID' => 'ID korisnika',
        'CustomerIDs' => 'ID korisnika',
        'customer' => 'korisnik',
        'agent' => 'Operater',
        'system' => 'Sistem',
        'Customer Info' => 'Korisnički info',
        'Customer Information' => 'Informacije o korisniku',
        'Customer Company' => 'Korisnikova firma',
        'Customer Companies' => 'Korisnikove firme',
        'Company' => 'Firma',
        'go!' => 'Start!',
        'go' => 'Start',
        'All' => 'Sve',
        'all' => 'sve',
        'Sorry' => 'Izvinite',
        'update!' => 'ažuriranje!',
        'update' => 'ažuriranje',
        'Update' => 'Ažuriranje',
        'Updated!' => 'Ažurirano!',
        'submit!' => 'pošalji!',
        'submit' => 'pošalji',
        'Submit' => 'Pošalji',
        'change!' => 'promena!',
        'Change' => 'Promena',
        'change' => 'promena',
        'click here' => 'kliknite ovde',
        'Comment' => 'Komentar',
        'Invalid Option!' => 'Nevažeća opcija!',
        'Invalid time!' => 'Nevažeće vreme!',
        'Invalid date!' => 'Nevažeći datum!',
        'Name' => 'Ime',
        'Group' => 'Grupa',
        'Description' => 'Opis',
        'description' => 'opis',
        'Theme' => 'Šema',
        'Created' => 'Kreirano',
        'Created by' => 'kreirao',
        'Changed' => 'Izmenjeno',
        'Changed by' => 'Menjao',
        'Search' => 'Traži',
        'and' => 'i',
        'between' => 'između',
        'before/after' => '',
        'Fulltext Search' => 'Tekst za pretragu',
        'Data' => 'Podaci',
        'Options' => 'Opcije',
        'Title' => 'Naslov',
        'Item' => 'Stavka',
        'Delete' => 'Izbrisati',
        'Edit' => 'Menjati',
        'View' => 'Pregled',
        'Number' => 'Broj',
        'System' => 'Sistem',
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontakti',
        'Export' => 'Izvoz',
        'Up' => 'Gore',
        'Down' => 'Dole',
        'Add' => 'Dodati',
        'Added!' => 'Dodano!',
        'Category' => 'Kategorija',
        'Viewer' => 'Prikazivač',
        'Expand' => 'Proširi',
        'Small' => 'Sitno',
        'Medium' => 'Srednje',
        'Large' => 'Krupno',
        'Date picker' => 'Izbor datuma',
        'New message' => 'Nova poruka',
        'New message!' => 'Nova poruka!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Molimo vas da odgovorite na ovaj tiket da bi ste se vratili na normalan pregled reda!',
        'You have %s new message(s)!' => 'Imate %s novih poruka!',
        'You have %s reminder ticket(s)!' => 'Imate %s Tiketa podsetnika!',
        'The recommended charset for your language is %s!' => 'Preporučeni karakterset za vaš jezik je %s!',
        'Change your password.' => 'Promenite lozinku.',
        'Please activate %s first!' => 'Molimo, prvo aktivirajte %s.',
        'No suggestions' => 'Nema sugestija',
        'Word' => 'reč',
        'Ignore' => 'Zanemari',
        'replace with' => 'zameni sa',
        'There is no account with that login name.' => 'Ne postoji nalog sa tim korisničkim imenom.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Neuspešna prijava! Netačno je uneto vaše korisničko ime ili lozinka.',
        'There is no acount with that user name.' => 'Nema naloga sa tim korisničkim imenom',
        'Please contact your administrator' => 'Molimo kontaktirajte vašeg administratora',
        'Logout' => 'Odjava',
        'Logout successful. Thank you for using %s!' => 'Uspešno ste se odjavili! Hvala što ste koristili "%s"!',
        'Feature not active!' => 'Funkcija nije aktivna!',
        'Agent updated!' => 'Ažuriran operater',
        'Database Selection' => '',
        'Create Database' => 'Kreiraj bazu podataka',
        'System Settings' => 'Sistemska podešavanja',
        'Mail Configuration' => 'Podešavanje mejla',
        'Finished' => 'Zaršeno',
        'Install OTRS' => 'Instaliraj "OTRS"',
        'Intro' => 'Uvod',
        'License' => 'Licenca',
        'Database' => 'Baza podataka',
        'Configure Mail' => 'Podešavanje mejla',
        'Database deleted.' => 'Obrisana baza',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database already contains data - it should be empty!' => '',
        'Login is needed!' => 'Potrebna je prijava!',
        'Password is needed!' => 'Potrebna je lozinka!',
        'Take this Customer' => 'Uzmi ovog korisnika',
        'Take this User' => 'Uzmi ovog korisnika sistema',
        'possible' => 'moguće',
        'reject' => 'odbaci',
        'reverse' => 'obrnuto',
        'Facility' => 'Instalacija',
        'Time Zone' => 'Vremenska zona',
        'Pending till' => 'Čeka do',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Ne koristite "Superuser" nalog za rad sa "OTRS"! Napravite nove naloge za azposlene i koristite njih.',
        'Dispatching by email To: field.' => 'Otprema imejlom za: Polje.',
        'Dispatching by selected Queue.' => 'Otprema kroz izabrani red.',
        'No entry found!' => 'Unos nije pronađen!',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Vreme sesije je isteklo. Molimo prijavite se ponovo.',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Nemate dozvolu!',
        '(Click here to add)' => '(Klikni ovde za dodavanje)',
        'Preview' => 'Pregled',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Paket nije korektno instaliran! Instalirajte ga ponovo.',
        '%s is not writable!' => 'Ne može se upisivati na %s!',
        'Cannot create %s!' => 'Ne može se kreirati %s!',
        'Check to activate this date' => 'Označi za aktiviralje ovog datuma',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Aktivirana je opcija "Van kancelarije", želite li da je isključite?',
        'Customer %s added' => 'Dodan korisnik %s.',
        'Role added!' => 'Dodana uloga!',
        'Role updated!' => 'Ažurirana uloga',
        'Attachment added!' => 'Dodan prilog',
        'Attachment updated!' => 'Ažuriran prilog',
        'Response added!' => 'Dodan odgovor',
        'Response updated!' => 'Ažuriran odgovor',
        'Group updated!' => 'Ažurirana grupa',
        'Queue added!' => 'Dodan red',
        'Queue updated!' => 'Ažuriran red',
        'State added!' => 'Dodan status',
        'State updated!' => 'Ažuriran status',
        'Type added!' => 'Dodan tip',
        'Type updated!' => 'Ažuriran tip',
        'Customer updated!' => 'Ažuriran korisnik',
        'Customer company added!' => 'Dodana firma korisnika!',
        'Customer company updated!' => 'Ažurirana firma korisnika!',
        'Note: Company is invalid!' => '',
        'Mail account added!' => 'Dodan mejl nalog!',
        'Mail account updated!' => 'Ažuriran mejl nalog!',
        'System e-mail address added!' => 'Dodana sistemska mejl adresa!',
        'System e-mail address updated!' => 'Ažurirana sistemska mejl adresa!',
        'Contract' => 'Ugovor',
        'Online Customer: %s' => 'Korisnik na vezi: %s',
        'Online Agent: %s' => 'Operater na vezi: %s',
        'Calendar' => 'Kalendar',
        'File' => 'Datoteka',
        'Filename' => 'Naziv datoteke',
        'Type' => 'Tip',
        'Size' => 'Veličina',
        'Upload' => 'Otpremanje',
        'Directory' => 'Imenik',
        'Signed' => 'Potpisano',
        'Sign' => 'Potpis',
        'Crypted' => 'Šifrovano',
        'Crypt' => 'Šifra',
        'PGP' => '"PGP"',
        'PGP Key' => '"PGP" Ključ',
        'PGP Keys' => '"PGP" ključevi',
        'S/MIME' => '"S/MIME" ključ',
        'S/MIME Certificate' => '"S/MIME" Sertifikat',
        'S/MIME Certificates' => '"S/MIME" Sertifikati',
        'Office' => 'Kancelarija',
        'Phone' => 'Telefon',
        'Fax' => 'Faks',
        'Mobile' => 'Mobilni',
        'Zip' => 'PB',
        'City' => 'Mesto',
        'Street' => 'Ulica',
        'Country' => 'Država',
        'Location' => 'Lokacija',
        'installed' => 'instalirano',
        'uninstalled' => 'deinstalirano',
        'Security Note: You should activate %s because application is already running!' =>
            'Bezbednosna napomena: Trebalo bi da omogućite %s, jer je aplikacija već pokrenuta!',
        'Unable to parse repository index document.' => 'Nije moguće raščlaniti indeks spremišta!',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Nema paketa za verziju vašeg sistema, u spremištu su samo paketi za druge verzije.',
        'No packages, or no new packages, found in selected repository.' =>
            'U izabranom spremištu nema paketa ili nema novih paketa',
        'Edit the system configuration settings.' => 'Uredi podešavanja sistemske konfiguracije.',
        'printed at' => 'štampano u',
        'Loading...' => 'Učitavanje...',
        'Dear Mr. %s,' => 'Poštovani gospodine %s,',
        'Dear Mrs. %s,' => 'Poštovana gospođo %s,',
        'Dear %s,' => 'Dragi %s,',
        'Hello %s,' => 'Zdravo %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Ova imejl adresa već postoji. Molimo, prijavite se ili resetujte vašu lozinku.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Kreiran novi nalog. Podaci za prijavu poslati %s. Molimo proverite vaš imejl',
        'Please press Back and try again.' => 'Molimo pritisnite Nazad i pokušajte ponovo.',
        'Sent password reset instructions. Please check your email.' => 'Uputstvo za reset lozinke je poslato. Molimo proverite vaš imejl.',
        'Sent new password to %s. Please check your email.' => 'Poslata nova lozinka za %s. Proverite vašu poštu',
        'Upcoming Events' => 'Predstojeći događaji',
        'Event' => 'Događaj',
        'Events' => 'Događaji',
        'Invalid Token!' => 'Neispravna oznaka!',
        'more' => 'još',
        'Collapse' => 'Smanji',
        'Shown' => 'Prikazan',
        'Shown customer users' => '',
        'News' => 'Novosti',
        'Product News' => 'Novosti o proizvodu',
        'OTRS News' => '"OTRS" Novosti',
        '7 Day Stats' => 'Sedmodnevna statistika',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Mark' => '',
        'Unmark' => '',
        'Bold' => 'Podebljano',
        'Italic' => 'Kurziv',
        'Underline' => 'Podvučeno',
        'Font Color' => 'Boja slova',
        'Background Color' => 'Boja pozadine',
        'Remove Formatting' => 'Ukloni formatiranje',
        'Show/Hide Hidden Elements' => 'Pokaži/Sakri skrivene elemente',
        'Align Left' => 'Poravnaj nalevo',
        'Align Center' => 'Centriraj',
        'Align Right' => 'Poravnaj nadesno',
        'Justify' => 'Poravnaj u blok',
        'Header' => 'Naslov',
        'Indent' => 'Uvlačenje',
        'Outdent' => 'Izvlačenje',
        'Create an Unordered List' => 'Napravi nesređenu listu',
        'Create an Ordered List' => 'Napravi sređenu listu',
        'HTML Link' => '"HTML" Veza',
        'Insert Image' => 'Ubaci sliku',
        'CTRL' => '"CTRL"',
        'SHIFT' => '"SHIFT"',
        'Undo' => 'Odustani',
        'Redo' => 'Ponovi',
        'Scheduler process is registered but might not be running.' => 'Planer proces je registrovan, ali možda nije pokrenut.',
        'Scheduler is not running.' => 'Planer ne radi.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Nova godina',
        'International Workers\' Day' => 'Međunarodni praznik rada',
        'Christmas Eve' => 'Badnje veče',
        'First Christmas Day' => 'Prvi dan Božića',
        'Second Christmas Day' => 'Drugi dan Božića',
        'New Year\'s Eve' => '',

        # Template: AAAGenericInterface
        'OTRS as requester' => '',
        'OTRS as provider' => '',
        'Webservice "%s" created!' => '',
        'Webservice "%s" updated!' => '',

        # Template: AAAMonth
        'Jan' => 'jan',
        'Feb' => 'feb',
        'Mar' => 'mar',
        'Apr' => 'apr',
        'May' => 'maj',
        'Jun' => 'jun',
        'Jul' => 'jul',
        'Aug' => 'avg',
        'Sep' => 'sep',
        'Oct' => 'okt',
        'Nov' => 'nov',
        'Dec' => 'dec',
        'January' => 'januar',
        'February' => 'februar',
        'March' => 'mart',
        'April' => 'april',
        'May_long' => 'maj',
        'June' => 'juni',
        'July' => 'juli',
        'August' => 'avgust',
        'September' => 'septembar',
        'October' => 'oktobar',
        'November' => 'novembar',
        'December' => 'decembar',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Podešavanja su uspešno ažurirana!',
        'User Profile' => 'Korisnički profil',
        'Email Settings' => 'Imejl podešavanja',
        'Other Settings' => 'Druga podešavanja',
        'Change Password' => 'Promena lozinke',
        'Current password' => 'Sadašnja lozinka',
        'New password' => 'Nova lozinka',
        'Verify password' => 'Potvrdi lozinku',
        'Spelling Dictionary' => 'Pravopisni rečnik',
        'Default spelling dictionary' => 'Podrazumevani pravopisni rečnik',
        'Max. shown Tickets a page in Overview.' => 'Maksimalni broj tiketa po srani u pregledu.',
        'The current password is not correct. Please try again!' => 'Uneta lozinka je netačna. Molimo pokušajte ponovo!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Lozinka ne može biti ažurirana, novi unosi su različiti. Molimo pokušajte ponovo!',
        'Can\'t update password, it contains invalid characters!' => 'Lozinka ne može biti ažurirana, sadrži nedozvoljene znakove.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Lozinka ne može biti ažurirana. Minimalna dužina lozinke je %s znakova.',
        'Can\'t update password, it must contain at least 2 lowercase  and 2 uppercase characters!' =>
            '',
        'Can\'t update password, it must contain at least 1 digit!' => 'Lozinka ne može biti ažurirana. Mora da sadrži bar jednu brojku.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Lozinka ne može biti ažurirana. Mora da sadrži najmanje 2 znaka.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Lozinka ne može biti ažurirana. Uneta lozinka je već u upotrebi. Molimo izaberite neku drugu.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Izaberite rastavni znak koji će se koristi u "CSV" datotekama (statistika i pretrage). Ako ne izaberete rastavni znak ovde, koristiće se podrazumevani rastavni znak za vaš jezik',
        'CSV Separator' => '"CSV" rastavni znak',

        # Template: AAAStats
        'Stat' => 'Statistika',
        'Sum' => 'Suma',
        'Please fill out the required fields!' => 'Molimo Vas, popunite obavezna polja!',
        'Please select a file!' => 'Molimo Vas da odaberete datoteku!',
        'Please select an object!' => 'Molimo Vas da odaberete objekat!',
        'Please select a graph size!' => 'Molimo Vas da odaberete veličinu grafikona!',
        'Please select one element for the X-axis!' => 'Molimo da izaberete jedan element za X-osu!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Izaberite samo jedan element ili opozovite izbor na oznaci polja "fiksirano"!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Ako koristite oznake selekcije, morate da izaberete neke atribute selektovanog polja!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Molimo da unesete vrednost u izabrano polje ili isključite oznaku "fiksirano"!',
        'The selected end time is before the start time!' => 'Izabrano vreme kraja je pre vremena početka!',
        'You have to select one or more attributes from the select field!' =>
            'Morate da izaberete jedan ili više atributa iz selektovanog polja!',
        'The selected Date isn\'t valid!' => 'Datum koji ste izabrali nije važeći!',
        'Please select only one or two elements via the checkbox!' => 'Molimo da izaberete samo jedan ili dva elementa!',
        'If you use a time scale element you can only select one element!' =>
            'Ukoliko koristite element vremenske skale, možete izabrati samo jedan element!',
        'You have an error in your time selection!' => 'Imate grešku u vašem izboru vremena!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Vaš interval izveštaja je prekratak, molimo upotrebite veći vremenski razmak!',
        'The selected start time is before the allowed start time!' => 'Izabrano vreme početka je pre dozvoljenog početnog vremena!',
        'The selected end time is after the allowed end time!' => 'Izabrano vreme kraja je posle dozvoljenog vremena kraja!',
        'The selected time period is larger than the allowed time period!' =>
            'Izabrani vremenski period je duži od dozvoljenog!',
        'Common Specification' => 'Opšte informacije',
        'X-axis' => 'X-Osa',
        'Value Series' => 'Opsezi',
        'Restrictions' => 'Ograničenja',
        'graph-lines' => 'Linijski grafikon',
        'graph-bars' => 'Stubičati grafikon',
        'graph-hbars' => 'Stubičati grafikon (horizontalno)',
        'graph-points' => 'Tačkasti grafikon',
        'graph-lines-points' => 'Linijsko-tačkasti grafikon',
        'graph-area' => 'Oblast grafikona',
        'graph-pie' => 'Grafikon pita',
        'extended' => 'proširen',
        'Agent/Owner' => 'Operater/Vlasnik',
        'Created by Agent/Owner' => 'Otvorio Operater/Vlasnik',
        'Created Priority' => 'Otvoreno sa prioritetom',
        'Created State' => 'Otvoreno sa statusom',
        'Create Time' => 'Vreme otvaranja',
        'CustomerUserLogin' => 'Prijava korisnika',
        'Close Time' => 'Vreme zatvaranja',
        'TicketAccumulation' => 'Akumulacija tiketa',
        'Attributes to be printed' => 'Atributi za štampu',
        'Sort sequence' => 'Redosled sortiranja',
        'Order by' => 'Sortiraj po',
        'Limit' => 'Ograničenje',
        'Ticketlist' => 'Lista tiketa',
        'ascending' => 'rastući',
        'descending' => 'opadajući',
        'First Lock' => 'Prvo zaključavanje',
        'Evaluation by' => 'Procenio',
        'Total Time' => 'Ukupno vreme',
        'Ticket Average' => 'Prosečno vreme po tiketu',
        'Ticket Min Time' => 'Minimalno vreme tiketa',
        'Ticket Max Time' => 'Maksimalno vreme tiketa',
        'Number of Tickets' => 'Broj tiketa',
        'Article Average' => 'Prosečno vreme po članku',
        'Article Min Time' => 'Minimalno vreme članka',
        'Article Max Time' => 'Maksimalno vreme članka',
        'Number of Articles' => 'Broj članaka',
        'Accounted time by Agent' => 'Obračunato vreme po operateru',
        'Ticket/Article Accounted Time' => 'Obračunato vreme',
        'TicketAccountedTime' => 'Obračunato vreme obrade tiketa',
        'Ticket Create Time' => 'Vreme otvaranja tiketa',
        'Ticket Close Time' => 'Vreme zatvaranja tiketa',

        # Template: AAATicket
        'Status View' => 'Pregled statusa',
        'Bulk' => 'Masovno',
        'Lock' => 'Zaključaj',
        'Unlock' => 'Otključaj',
        'History' => 'Istorijat',
        'Zoom' => 'Sadžaj',
        'Age' => 'Starost',
        'Bounce' => 'Preusmeri',
        'Forward' => 'Prosledi',
        'From' => 'Od',
        'To' => 'Za',
        'Cc' => 'Kk',
        'Bcc' => 'Skk',
        'Subject' => 'Predmet',
        'Move' => 'Premesti',
        'Queue' => 'Red',
        'Queues' => 'Redovi',
        'Priority' => 'Prioritet',
        'Priorities' => 'Prioriteti',
        'Priority Update' => 'Ažuriranje prioriteta',
        'Priority added!' => 'Dodan prioritet!',
        'Priority updated!' => 'Ažuriran prioritet!',
        'Signature added!' => 'Dodan potpis!',
        'Signature updated!' => 'Ažuriran potpis!',
        'SLA' => '"SLA"',
        'Service Level Agreement' => 'Dogovor o nivou usluge',
        'Service Level Agreements' => 'Dogovori o nivou usluge',
        'Service' => 'Usluga',
        'Services' => 'Usluge',
        'State' => 'Stanje',
        'States' => 'Stanja',
        'Status' => 'Status',
        'Statuses' => 'Statusi',
        'Ticket Type' => 'Tip Tiketa',
        'Ticket Types' => 'Tipovi Tiketa',
        'Compose' => 'Napiši',
        'Pending' => 'Na čekanju',
        'Owner' => 'Vlasnik',
        'Owner Update' => 'Ažuriranje vlasnika',
        'Responsible' => 'Odgovoran',
        'Responsible Update' => 'Ažuriranje odgovornog',
        'Sender' => 'Pošiljaoc',
        'Article' => 'Članak',
        'Ticket' => 'Tiket',
        'Createtime' => 'Vreme kreiranja',
        'plain' => 'neformatirano',
        'Email' => 'Imejl',
        'email' => 'imejl',
        'Close' => 'Zatvori',
        'Action' => 'Akcija',
        'Attachment' => 'Prilog',
        'Attachments' => 'Prilozi',
        'This message was written in a character set other than your own.' =>
            'Ova poruka je napisana skupom znakova različitim od onog koji Vi koristite.',
        'If it is not displayed correctly,' => 'Ako nije ispravno prikazano,',
        'This is a' => 'Ovo je',
        'to open it in a new window.' => 'za otvaranje u novom prozoru.',
        'This is a HTML email. Click here to show it.' => 'Ovo je "HTML" imejl. Klikni ovde za prikaz.',
        'Free Fields' => 'Slobodna polja',
        'Merge' => 'Spoji',
        'merged' => 'spojeno',
        'closed successful' => 'uspešno zatvaranje',
        'closed unsuccessful' => 'neuspešno zatvaranje',
        'Locked Tickets Total' => 'Ukupno zaključnih tiketa',
        'Locked Tickets Reminder Reached' => 'Dostignut podsetnik zaključanih tiketa',
        'Locked Tickets New' => 'Novi zaključani tiketi',
        'Responsible Tickets Total' => 'Ukupno tiketa "..."',
        'Responsible Tickets New' => 'Novi tiketi "..."',
        'Responsible Tickets Reminder Reached' => 'Dostignut podsetnik tiketa ".."',
        'Watched Tickets Total' => 'Ukupno praćenih tiketa',
        'Watched Tickets New' => 'Novi praćeni tiketi',
        'Watched Tickets Reminder Reached' => 'Dostignut podsetnik tiketa na čekanju',
        'All tickets' => 'Svi tiketi',
        'Available tickets' => '',
        'Escalation' => 'Eskalacija',
        'last-search' => 'poslednja pretraga',
        'QueueView' => 'Pregled reda',
        'Ticket Escalation View' => 'Eskalacioni pregled tiketa',
        'Message from' => 'Poruka od',
        'End message' => 'kraj poruke',
        'Forwarded message from' => 'Prosleđena poruka od',
        'End forwarded message' => 'Kraj prosleđene poruke',
        'new' => 'novo',
        'open' => 'otvoreni',
        'Open' => 'Otvoreni',
        'Open tickets' => 'Otvoreni tiketi',
        'closed' => 'zatvoreni',
        'Closed' => 'Zatvoreni',
        'Closed tickets' => 'Zatvoreni tiketi',
        'removed' => 'uklonjeni',
        'pending reminder' => 'podsetnik čekanja',
        'pending auto' => 'automatsko čekanje',
        'pending auto close+' => 'čekanje na automatsko zatvaranje+',
        'pending auto close-' => 'čekanje na automatsko zatvaranje-',
        'email-external' => 'Imejl eksterni',
        'email-internal' => 'imejl interni',
        'note-external' => 'Napomena - eksterna',
        'note-internal' => 'Napomena - interna',
        'note-report' => 'Napomena za izveštaj',
        'phone' => 'Telefon',
        'sms' => '"SMS"',
        'webrequest' => '"Web" zahtev',
        'lock' => 'zatvoren',
        'unlock' => 'otvoren',
        'very low' => 'vrlo nizak',
        'low' => 'nizak',
        'normal' => 'normalan',
        'high' => 'visok',
        'very high' => 'vrlo visok',
        '1 very low' => '1 vrlo nizak',
        '2 low' => '2 nizak',
        '3 normal' => '3 normalan',
        '4 high' => '4 visok',
        '5 very high' => '5 vrlo visok',
        'auto follow up' => 'automatsko praćenje',
        'auto reject' => 'autobatsko odbacivanje',
        'auto remove' => 'automatsko uklanjanje',
        'auto reply' => 'automatski odgovor',
        'auto reply/new ticket' => 'automatski odgovor/novi tiket',
        'Create' => 'Otvori',
        'Answer' => '',
        'Phone call' => 'Telefonski poziv',
        'Ticket "%s" created!' => 'Tiket "%s" kreiran!',
        'Ticket Number' => 'Broj tiketa',
        'Ticket Object' => 'Objekat tiketa',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ne postoji tiket broj "%s"! Ne može se povezati!',
        'You don\'t have write access to this ticket.' => 'Nemate pravo upisa u ovaj tiket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Nažalost, morate biti vlasnik tiketa za ovu akciju.',
        'Please change the owner first.' => '',
        'Ticket selected.' => 'Izabran tiket.',
        'Ticket is locked by another agent.' => 'Tiket je zaključan od strane drugog operatera.',
        'Ticket locked.' => 'Zaključan tiket.',
        'Don\'t show closed Tickets' => 'Ne prikazuj zatvorene tikete',
        'Show closed Tickets' => 'Prikaži zatvorene tikete',
        'New Article' => 'Novi članak',
        'Unread article(s) available' => 'raspoliživi nepročitani članci',
        'Remove from list of watched tickets' => 'Ukloni sa liste praćenih tiketa',
        'Add to list of watched tickets' => 'Dodaj na listu praćenih tiketa',
        'Email-Ticket' => 'Imejl tiket',
        'Create new Email Ticket' => 'Kreira novi Imejl tiket',
        'Phone-Ticket' => 'Telefonski tiket',
        'Search Tickets' => 'Traženje tiketa',
        'Edit Customer Users' => 'Uredi korisnike',
        'Edit Customer Company' => 'Uredi korisničku firmu',
        'Bulk Action' => 'Masovna akcija',
        'Bulk Actions on Tickets' => 'Masovne akcije na tiketima',
        'Send Email and create a new Ticket' => 'Pošanji imejl i kreiraj novi tiket',
        'Create new Email Ticket and send this out (Outbound)' => 'Otvori novi imejl tiket i pošalji ovo (odlazni)',
        'Create new Phone Ticket (Inbound)' => 'Kreiraj novi telefonski tiket (dolazni poziv)',
        'Address %s replaced with registered customer address.' => '',
        'Customer user automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Pregled svih otvorenih tiketa',
        'Locked Tickets' => 'Zaključani tiketi',
        'My Locked Tickets' => 'Moji zaključani tiketi',
        'My Watched Tickets' => 'Moji posmatrani tiketi',
        'My Responsible Tickets' => 'Tiketi za koje sam odgovoran',
        'Watched Tickets' => 'Posmatrani tiketi',
        'Watched' => 'Posmatrano',
        'Watch' => 'Posmatraj',
        'Unwatch' => 'Prekini posmatranje',
        'Lock it to work on it' => 'Zaključajte za rad na tiketu',
        'Unlock to give it back to the queue' => 'Otključajte za vraćanje u red',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => 'Promeni prioritet tiketa',
        'Change the ticket free fields!' => 'Promeni slobodna polja tiketa',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => 'Promeni vlasnika ovog tiketa',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => 'Dodaj napomenu ovom tiketu',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => 'Zatvori ovaj tiket',
        'Look into a ticket!' => 'Pogledaj sadržaj tiketa!',
        'Delete this ticket' => 'Obrišite ovaj tiket',
        'Mark as Spam!' => 'Označi kao "Spam"!',
        'My Queues' => 'Moji redovi',
        'Shown Tickets' => 'prikazani tiketi',
        'Shown Columns' => '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Vaš imejl sa brojem tiketa "<OTRS_TICKET>" je spojen sa tiketom "<OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' => 'Tiket %s: vreme reakcije je preko (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Tiket %s: vreme reakcije ističe za %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiket %s: vreme ažuriranja je preko (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiket %s: vreme ažuriranja ističe za %s!',
        'Ticket %s: solution time is over (%s)!' => 'Tiket %s: vreme rešavanja je preko (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiket %s: vreme rešavanja ističe za %s!',
        'There are more escalated tickets!' => 'Ima još eskaliralih tiketa!',
        'Plain Format' => 'Prost format',
        'Reply All' => 'Odgovori na sve',
        'Direction' => 'Smer',
        'Agent (All with write permissions)' => 'Operater (svi sa dozvolom za izmene)',
        'Agent (Owner)' => 'Operater (Vlasnik)',
        'Agent (Responsible)' => 'Operater (Odgovoran)',
        'New ticket notification' => 'Obaveštenje o novom tiketu',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Pošalji mi obaveštenje za novi tiket u "Mojim Redovima".',
        'Send new ticket notifications' => 'Pošalji obaveštenja o novim tiketima',
        'Ticket follow up notification' => 'Obaveštenje o nastavku tiketa',
        'Ticket lock timeout notification' => 'Obaveštenje o isticanju zaključavanja tiketa',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Pošalji mi obaveštenje ako sistem otključa tiket.)',
        'Send ticket lock timeout notifications' => 'Pošalji obaveštenje o isteku zaključavanja tiketa',
        'Ticket move notification' => 'Obaveštenje o pomeranju tiketa',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Pošalji mi obaveštenje kad se tiket premesti u "Moje Redove".',
        'Send ticket move notifications' => 'Pošalji obaveštenje o pomeranju tiketa',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Izabrani omiljeni redovi. Ako je aktivirano, dobiđete i obaveštenje o ovim redovima.',
        'Custom Queue' => 'Prilagođen red',
        'QueueView refresh time' => 'Vreme osvežavanja reda',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Ako je uključeno, pregled reda će biti osvežen posle zadatog vremena.',
        'Refresh QueueView after' => 'Osveži pregled reda posle',
        'Screen after new ticket' => 'Ekran posle otvaranja novog tiketa',
        'Show this screen after I created a new ticket' => 'Prikaži ovaj ekran posle otvaranja novog tiketa',
        'Closed Tickets' => 'Zatvoreni tiketi',
        'Show closed tickets.' => 'Prikaži zatvorene tikete.',
        'Max. shown Tickets a page in QueueView.' => 'Maksimalni broj prikazanih tiketa u pregledu reda.',
        'Ticket Overview "Small" Limit' => 'Pregled tiketa - limit malo',
        'Ticket limit per page for Ticket Overview "Small"' => 'Limit tiketa po strani za pregled - malo',
        'Ticket Overview "Medium" Limit' => 'Pregled tiketa - limit srednje',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Limit tiketa po strani za pregled - srednje',
        'Ticket Overview "Preview" Limit' => 'Pregled tiketa - limit pregleda',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limit tiketa po strani za pregled',
        'Ticket watch notification' => 'Obaveštenje o posmatranju tiketa',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Pošalji mi isto obaveštenje za praćene tikete koje će dobiti vlasnik.',
        'Send ticket watch notifications' => 'Pošalji obaveštenje o praćenju tiketa',
        'Out Of Office Time' => 'Van radnog vremena',
        'New Ticket' => 'Novi tiket',
        'Create new Ticket' => 'Napravi novi tiket',
        'Customer called' => 'Pozvani korisnik',
        'phone call' => 'telefonski poziv',
        'Phone Call Outbound' => 'Odlazni telefonski poziv',
        'Phone Call Inbound' => 'Dolazni telefonski poziv',
        'Reminder Reached' => 'Dostignut podsetnik',
        'Reminder Tickets' => 'Tiketi na podsetniku',
        'Escalated Tickets' => 'Eskalirani tiketi',
        'New Tickets' => 'Novi tiketi',
        'Open Tickets / Need to be answered' => 'Otvoreni tiketi / Potrebno odgovoriti',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Svi otvoreni tiketi, na ovima je već rađeno, ali na njih treba odgovoriti',
        'All new tickets, these tickets have not been worked on yet' => 'Svi novi tiketi, na njima još nije ništa rađeno',
        'All escalated tickets' => 'Svi eskalirani tiketi',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Svi tiketi sa podešenim podsetnikom, a datum podsetnika je dostignut',
        'Archived tickets' => 'Arhivirani tiketi',
        'Unarchived tickets' => 'Nearhivirani tiketi',
        'History::Move' => 'Tiket premešten u red "%s" (%s) iz reda "%s" (%s).',
        'History::TypeUpdate' => 'Ažuriran tip "%s" (ID=%s).',
        'History::ServiceUpdate' => 'Ažuriran servis "%s" (ID=%s).',
        'History::SLAUpdate' => 'Ažuriran "SLA" "%s" (ID=%s).',
        'History::NewTicket' => 'Novi tiket [%s] otvoren (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Nastavak za [%s]. %s',
        'History::SendAutoReject' => 'Automatski odbijeno "%s".',
        'History::SendAutoReply' => 'Poslat automatski odgovor za "%s".',
        'History::SendAutoFollowUp' => 'Automatski nastavak za "%s".',
        'History::Forward' => 'Prosleđeno "%s".',
        'History::Bounce' => 'Odbijeno "%s".',
        'History::SendAnswer' => 'Imejl poslat "%s".',
        'History::SendAgentNotification' => '"%s"-Obaveštenja poslata za "%s".',
        'History::SendCustomerNotification' => 'Obaveštenja poslata za "%s".',
        'History::EmailAgent' => '"E-Mail an Kunden versandt."',
        'History::EmailCustomer' => '"E-Mail hinzugefugt. %s"',
        'History::PhoneCallAgent' => '"Kunden angerufen."',
        'History::PhoneCallCustomer' => 'Korisnički telefonski poziv.',
        'History::AddNote' => 'Dodata napomena (%s)',
        'History::Lock' => 'Tiket zaključan.',
        'History::Unlock' => 'Tiket otključan.',
        'History::TimeAccounting' => '%s vremenskih jedinica prebrojano. Ukupno %s vremenskih jedinica.',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Ažurirano: %s',
        'History::PriorityUpdate' => 'Ažuriran prioritet sa "%s" (%s) na "%s" (%s).',
        'History::OwnerUpdate' => 'Novi vlasnik je "%s" (ID=%s).',
        'History::LoopProtection' => 'Zaštita od petlje! Automatski odgovor nije poslat na "%s".',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Ažurirano: %s',
        'History::StateUpdate' => 'Staro: "%s" Novo: "%s"',
        'History::TicketDynamicFieldUpdate' => 'Ažurirano: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Korisnički "Web" zahtev.',
        'History::TicketLinkAdd' => 'Veza na "%s" postavljena.',
        'History::TicketLinkDelete' => 'Veza na "%s" obrisana.',
        'History::Subscribe' => 'Pretplata za korisnika "%s" uključena.',
        'History::Unsubscribe' => 'Pretplata za korisnika "%s" isključena.',
        'History::SystemRequest' => 'Sistemski zahtev',
        'History::ResponsibleUpdate' => 'Novi odgovorni je "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => '',
        'History::TicketTitleUpdate' => '',

        # Template: AAAWeekDay
        'Sun' => 'ned',
        'Mon' => 'pon',
        'Tue' => 'uto',
        'Wed' => 'sre',
        'Thu' => 'čet',
        'Fri' => 'pet',
        'Sat' => 'sub',

        # Template: AdminACL
        'ACL Management' => '',
        'Filter for ACLs' => '',
        'Filter' => 'Filter',
        'ACL Name' => '',
        'Actions' => 'Akcije',
        'Create New ACL' => '',
        'Deploy ACLs' => '',
        'Export ACLs' => '',
        'Configuration import' => '',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            '',
        'This field is required.' => 'Ovo polje je obavezno.',
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
        'Validity' => 'Važnost',
        'Copy' => '',
        'No data found.' => 'Ništa nije pronađeno.',

        # Template: AdminACLEdit
        'Edit ACL %s' => '',
        'Go to overview' => 'Idi na pregled',
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
        'Show or hide the content' => 'Pokaži ili sakri sadržaj',
        'Edit ACL information' => '',
        'Stop after match' => 'Zaustavi posle poklapanja',
        'Edit ACL structure' => '',
        'Save' => 'Sačuvaj',
        'or' => 'ili',
        'Save and finish' => 'Sačuvaj i završi',
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
        'Attachment Management' => 'Upravljanje prilozima',
        'Add attachment' => 'Dodaj prilog',
        'List' => 'Lista',
        'Download file' => 'Preuzmi datoteku',
        'Delete this attachment' => 'Obriši ovaj prilog',
        'Add Attachment' => 'Dodaj prilog',
        'Edit Attachment' => 'Uredi prilog',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Upravljanje automatskim odgovorima',
        'Add auto response' => 'Dodaj automatski odgovor',
        'Add Auto Response' => 'Dodaj automatski odgovor',
        'Edit Auto Response' => 'Uredi automatski odgovor',
        'Response' => 'Odgovor',
        'Auto response from' => 'Automatski odgovor od',
        'Reference' => 'Reference',
        'You can use the following tags' => 'Možete koristiti sledeće oznake',
        'To get the first 20 character of the subject.' => 'Da vidite prvih 20 slova predmeta',
        'To get the first 5 lines of the email.' => 'Da vidite prvih 5 linija poruke',
        'To get the realname of the sender (if given).' => 'Da vidite ime pošiljaoca (ako je dostupno)',
        'To get the article attribute' => 'Da vidite atribute članka',
        ' e. g.' => 'npr.',
        'Options of the current customer user data' => 'Opcije podataka o aktuelnom korisniku',
        'Ticket owner options' => 'Opcije vlasnika tiketa',
        'Ticket responsible options' => 'Opcije odgovornog za tiket',
        'Options of the current user who requested this action' => 'Opcije aktuelnog korisnika koji je tražio ovu akciju',
        'Options of the ticket data' => 'Opcije podataka o tiketu',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Konfiguracione opcije',
        'Example response' => 'Primer odgovora',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Upravljanje korisnicima',
        'Wildcards like \'*\' are allowed.' => 'Džokerski znaci kao \'*\' su dozvoljeni',
        'Add customer' => 'Dodaj korisnika',
        'Select' => 'Izaberi',
        'Please enter a search term to look for customers.' => 'Molimo unesite frazu za pronalaženje korisnika.',
        'Add Customer' => 'Dodaj korisnika',
        'Edit Customer' => 'Uredi korisnika',

        # Template: AdminCustomerUser
        'Customer User Management' => '',
        'Back to search results' => '',
        'Add customer user' => '',
        'Hint' => 'Savet',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '',
        'Last Login' => 'Poslednja prijava',
        'Login as' => 'Prijavi se kao',
        'Switch to customer' => '',
        'Add Customer User' => '',
        'Edit Customer User' => '',
        'This field is required and needs to be a valid email address.' =>
            'Ovo je obavezno ponje i mora da bude ispravna mejl adresa.',
        'This email address is not allowed due to the system configuration.' =>
            'Ova imejl adresa nije dozvoljena zbog sistemske konfiguracije.',
        'This email address failed MX check.' => 'Ova imejl adresa ne zadovoljava "MX" proveru.',
        'DNS problem, please check your configuration and the error log.' =>
            '"DNS" problem, molimo proverite konfiguraciju i dnevnik grešaka.',
        'The syntax of this email address is incorrect.' => 'Sintaksa ove imejl adrese je neispravna.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Upravljanje relacijama Korisnik-Grupa',
        'Notice' => 'Napomena',
        'This feature is disabled!' => 'Ova funkcija je isključena!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Upotrebite ovu funkciju ako želite da definišete grupne dozvole za korisnike.',
        'Enable it here!' => 'Aktivirajte je ovde!',
        'Search for customers.' => 'Traži korisnike.',
        'Edit Customer Default Groups' => 'Uredi podrazumevane grupe za korisnika',
        'These groups are automatically assigned to all customers.' => 'Ove grupe su automatski dodeljene svim korisnicima',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Možete upravljati ovim grupama preko konfiguracionih podešavanlja "..."',
        'Filter for Groups' => 'Fileter za grupe',
        'Select the customer:group permissions.' => 'Izaberi dozvole za korisnik:grupa',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Ako ništa nije izabrano, onda nema dozvola u ovoj grupi (tiketi neće biti dostupni korisniku).',
        'Search Results' => 'Rezultat pretrage',
        'Customers' => 'Korisnici',
        'Groups' => 'Grupe',
        'No matches found.' => 'Ništa nije pronađeno.',
        'Change Group Relations for Customer' => 'Promeni veze sa grupama za korisnika',
        'Change Customer Relations for Group' => 'promeni veze sa korisnicima za grupu',
        'Toggle %s Permission for all' => 'Promeni %s dozvole za sve',
        'Toggle %s permission for %s' => 'Promeni %s dozvole za %s',
        'Customer Default Groups:' => 'Podrazumevane grupe za korisnika:',
        'No changes can be made to these groups.' => 'Na ovim grupama promene nisu moguće.',
        'ro' => '"ro"',
        'Read only access to the ticket in this group/queue.' => 'Pristup ograničen samo na čitanje za tikete u ovim Grupama/Redovima.',
        'rw' => '"rw"',
        'Full read and write access to the tickets in this group/queue.' =>
            'Pristup bez ograničenja za tikete u ovim Grupama/Redovima.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Upravljanje vezama Korisnik-Servisi',
        'Edit default services' => 'Uredi podrazumevane servise',
        'Filter for Services' => 'Filter za servise',
        'Allocate Services to Customer' => 'Pridruži servise korisniku',
        'Allocate Customers to Service' => 'Pridruži korisnike servisu',
        'Toggle active state for all' => 'Promeni aktivno stanje za sve',
        'Active' => 'Aktivno',
        'Toggle active state for %s' => 'Promeni aktivno stanje za %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Upravljanje dinamičkim poljima',
        'Add new field for object' => '',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Za dodavanje novog polja izaberite tip polja iz liste objekta, objekt definiše mogući opseg vrednosti i ne može se promeniti posle kreiranja polja.',
        'Dynamic Fields List' => 'Lista dinamičkih polja',
        'Dynamic fields per page' => 'Broj dinamičkih polja po strani',
        'Label' => 'Oznaka',
        'Order' => 'Sortiranje',
        'Object' => 'Objekat',
        'Delete this field' => '',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            '',
        'Delete field' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dinamička polja',
        'Field' => 'Polje',
        'Go back to overview' => 'Idi nazad na pregled',
        'General' => 'Opšte',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Ovo polje je obavezno i može sadržati samo od slova i brojeve.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Mora biti jedinstveno i prihvata samo slova i brojeve.',
        'Changing this value will require manual changes in the system.' =>
            'Izmena ovog polja će zahtevati ručne promene u sistemu.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Ovo je ime koje će se prikazivati na ekranima gde je ponje aktivno.',
        'Field order' => 'Redosled polja',
        'This field is required and must be numeric.' => 'Ovo polje je obavezno i mora biti numeričko.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Ovo je redosled po kom će polja biti prikazana na ekranima gde su aktivna.',
        'Field type' => 'Tip polja',
        'Object type' => 'Tip objekta',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => 'Podešavanje polja',
        'Default value' => 'Podrazumevana vrednost',
        'This is the default value for this field.' => 'Ovo je podrazumevana vrednost za ovo polje.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Podrazumevana razlika datuma',
        'This field must be numeric.' => 'Ovo polje mora biti numeričko.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Razlika (u sekundama) od sad za izračunavanje podrazumevane vrednosti polja (npr 3600 ili -60).',
        'Define years period' => 'Definisanje perioda u godinama',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Aktivirajte ovu opciju radi definisanja fiksnog opsega godina (u budućnost i prošlost) za prikaz pri izboru godina na polju.',
        'Years in the past' => 'Godina u prošlost',
        'Years in the past to display (default: 5 years).' => 'Godine u prošlost za prikaz (podrazumevano je 5).',
        'Years in the future' => 'Godina u budućnost',
        'Years in the future to display (default: 5 years).' => 'Godine u budućnost za prikaz (podrazumevano je 5).',
        'Show link' => 'Pokaži vezu',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Ovde možete da unesete opcionu "HTTP" vezu za vrednost polja u prozoru opšteg i uvećanog pregleda.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Moguće vrednosti',
        'Key' => 'Ključ',
        'Value' => 'Vrednost',
        'Remove value' => 'Ukloni vrednost',
        'Add value' => 'Dodaj vrednost',
        'Add Value' => 'Dodaj Vrednost',
        'Add empty value' => 'Dodaj bez vrednosti',
        'Activate this option to create an empty selectable value.' => 'Aktiviraj ovu opciju za kreiranje izbora bez vrednosti.',
        'Tree View' => '',
        'Activate this option to display values as a tree.' => '',
        'Translatable values' => 'Prevodljive vrednosti',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Ako aktivirate ovu opciju vrednosti će biti prevedene na izabrani jezik.',
        'Note' => 'Napomena:',
        'You need to add the translations manually into the language translation files.' =>
            'Ove prevode morate ručno dodati u datoteke prevoda.',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Broj redova',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Unesi visinu (u linijama) za ovo polje u modu obrade.',
        'Number of cols' => 'Broj kolona',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Unesi širinu (u znakovima) za ovo polje u modu uređivanja.',

        # Template: AdminEmail
        'Admin Notification' => 'Administrativna obaveštenja',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Sa ovim modulom, administratori mogu slati poruke operaterima, grupama ili pripadnicima uloge.',
        'Create Administrative Message' => 'Kreiraj administrativnu poruku',
        'Your message was sent to' => 'Vaša poruka je poslata',
        'Send message to users' => 'Pošalji poruku korisnicima',
        'Send message to group members' => 'Pošalji poruku članovima grupe',
        'Group members need to have permission' => 'Članovi grupe treba da imaju dozvolu',
        'Send message to role members' => 'Pošalji poruku pripadnicima uloge',
        'Also send to customers in groups' => 'Takođe pošalji korisnicima u grupama',
        'Body' => 'Tekst',
        'Send' => 'Šalji',

        # Template: AdminGenericAgent
        'Generic Agent' => '"Generički" operater',
        'Add job' => 'Dodaj posao',
        'Last run' => 'Poslednje pokretanje',
        'Run Now!' => 'Pokreni sad!',
        'Delete this task' => 'Obriši ovaj zadatak',
        'Run this task' => 'Pokreni ovaj zadatak',
        'Job Settings' => 'Podešavanje posla',
        'Job name' => 'Naziv posla',
        'Toggle this widget' => 'Preklopi ovaj "widget"',
        'Automatic execution (multiple tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Planirano minuta',
        'Schedule hours' => 'Planirano sati',
        'Schedule days' => 'Planirano dana',
        'Currently this generic agent job will not run automatically.' =>
            'Trenutno ovaj generički agentski zadatak neće raditi automatski.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Da biste omogućili automatsko izvršavanje izaberite bar jednu vrednost od minuta sati i dana!',
        'Event based execution (single ticket)' => '',
        'Event Triggers' => 'Okidači događaja',
        'List of all configured events' => '',
        'Delete this event' => 'Obriši ovaj događaj',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'Da li stvarno želite da obrišete ovaj okidač događaja?',
        'Add Event Trigger' => 'Dodaj okidač događaja',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Za dodavanje novog događaja izaberite objekt događaja i ime događaja pa kliknite na "+" dugme',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => 'Obriši ovaj okidač događaja',
        'Ticket Filter' => 'Filter tiketa',
        '(e. g. 10*5155 or 105658*)' => 'npr. 10*5144 ili 105658*',
        '(e. g. 234321)' => 'npr. 234321',
        'Customer login' => 'Prijava korisnika',
        '(e. g. U5150)' => 'npr. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Potpuna tekstualna pretraga u članku (npr )',
        'Agent' => 'Operater',
        'Ticket lock' => 'Tiket zaključan',
        'Create times' => 'Vremena otvaranja',
        'No create time settings.' => 'Nema podešavanja vremena otvaranja.',
        'Ticket created' => 'Tiket otvoren',
        'Ticket created between' => 'Tiket otvoren između',
        'Change times' => 'Promena vremena',
        'No change time settings.' => 'Nema promene vremena',
        'Ticket changed' => 'Promenjen tiket',
        'Ticket changed between' => 'Tiket promenjen između',
        'Close times' => 'Vremena zatvaranja',
        'No close time settings.' => 'Nije podešeno vreme zatvaranja.',
        'Ticket closed' => 'Tiket zatvoren',
        'Ticket closed between' => 'Tiket zatvoren između',
        'Pending times' => 'Vremena čekanja',
        'No pending time settings.' => 'Nema podešavanja vremena čekanja',
        'Ticket pending time reached' => 'Dostignuto vreme čekanja tiketa',
        'Ticket pending time reached between' => 'Vreme čekanja tiketa dostignuto između',
        'Escalation times' => 'Vremena eskalacije',
        'No escalation time settings.' => 'Nema podešavanja vremena eskalacije',
        'Ticket escalation time reached' => 'Dostignuto vreme eskalacije tiketa',
        'Ticket escalation time reached between' => 'Vreme eskalacije tiketa dostignuto između',
        'Escalation - first response time' => 'Eskalacija - vreme prve reakcije',
        'Ticket first response time reached' => 'Dostignuto vreme prve reakcije na tiket',
        'Ticket first response time reached between' => 'Vreme prve reakcije na tiket dostignuto između',
        'Escalation - update time' => 'Eskalacija - vreme ažuriranja',
        'Ticket update time reached' => 'Dostignuto vreme ažuriranja tiketa',
        'Ticket update time reached between' => 'Vreme ažuriranja tiketa dostignuto između',
        'Escalation - solution time' => 'Eskalacija - vreme rešavanja',
        'Ticket solution time reached' => 'Dostignuto vreme rešavanja tiketa',
        'Ticket solution time reached between' => 'Vreme rešavanja tiketa dostignuto između',
        'Archive search option' => 'Opcije pretrage arhiva',
        'Ticket Action' => 'Akcija na tiketu',
        'Set new service' => 'Podesi novi servis',
        'Set new Service Level Agreement' => 'Podesi novi "SLA"',
        'Set new priority' => 'Podesi novi prioritet',
        'Set new queue' => 'Podesi novi red',
        'Set new state' => 'Podesi novi status',
        'Pending date' => 'Čekanje do',
        'Set new agent' => 'Podesi novog operatera',
        'new owner' => 'novi vlasnik',
        'new responsible' => 'novi odgovorni',
        'Set new ticket lock' => 'Podesi novo zaključavanje tiketa',
        'New customer' => 'Novi korisnik',
        'New customer ID' => 'Novi ID korisnika',
        'New title' => 'Novi naslov',
        'New type' => 'Novi tip',
        'New Dynamic Field Values' => 'Nove vrednosti dinamičkih polja',
        'Archive selected tickets' => 'Arhiviraj izabrane tikete',
        'Add Note' => 'Dodaj napomenu',
        'Time units' => 'Vremenske jedinice',
        '(work units)' => '',
        'Ticket Commands' => 'Komande za tiket',
        'Send agent/customer notifications on changes' => 'Pošalji obaveštenja operateru/korisniku pri promenama',
        'CMD' => '"CMD"',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ova naredba će biti izvršena. ARG[0] je broj tiketa, a ARG[1] ID tiketa.',
        'Delete tickets' => 'Obriši tikete',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'UPOZORENjE: Svi obuhvaćeni tiketi će biti nepovratno uklonjeni iz baze!',
        'Execute Custom Module' => 'Pokreni izvršavanje posebnog modula',
        'Param %s key' => 'Ključ parametra %s',
        'Param %s value' => 'Vrednost parametra %s',
        'Save Changes' => 'Sačuvaj promene',
        'Results' => 'Rezultati',
        '%s Tickets affected! What do you want to do?' => '%s tiketa je obuhvaćeno. Šta želite da uradite?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'UPOZORENjE: Upotrebili ste opciju za brisanje. Svi obrisani tiketi že biti izgubljeni!',
        'Edit job' => 'Uredi posao',
        'Run job' => 'Pokreni posao',
        'Affected Tickets' => 'Obuhvaćeni tiketi',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Otklanjanje grešaka u opštem interfejsu veb servisa %s',
        'Web Services' => 'Veb servisi',
        'Debugger' => 'Program za otklanjanje grešaka',
        'Go back to web service' => 'Idi nazad na veb servis',
        'Clear' => 'Očisti',
        'Do you really want to clear the debug log of this web service?' =>
            'Da li stvarno želite da očistite dnevnik korekcija ovog mrežnog servisa?',
        'Request List' => 'Lista zahteva',
        'Time' => 'Vreme',
        'Remote IP' => 'Udaljena "IP" adresa',
        'Loading' => 'Učitavam...',
        'Select a single request to see its details.' => 'Izaberite jedan zahtev da bi videli njegove detalje.',
        'Filter by type' => 'Filter po tipu',
        'Filter from' => 'Filter od',
        'Filter to' => 'Filter do',
        'Filter by remote IP' => 'Filter po udaljenoj IP adresi',
        'Refresh' => 'Osvežavanje',
        'Request Details' => 'Detalji zahteva',
        'An error occurred during communication.' => 'Greška tokom komunikacije.',
        'Clear debug log' => 'Očisti dnevnik korekcija',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => 'Svi konfiguracioni podaci će biti izgubljeni.',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Ime se obično koristi za pokretanje operacije udaljenog veb servisa.',
        'Please provide a unique name for this web service invoker.' => '',
        'The name you entered already exists.' => 'Ime koje ste uneli već postoji.',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => 'Mapiranje za izlazne podatke zahteva',
        'Configure' => 'Podesi',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => 'Mapiranje za ulazne podatke odgovora',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Asynchronous' => 'Asinhrono',
        'This invoker will be triggered by the configured events.' => '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Asinhronim okidačima događaja upravlja "OTRS" dispečer u pozadini (preporučeno).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Sinhroni okidači događaja biće obrađeni direktno tokom veb zahteva.',
        'Save and continue' => 'Sačuvaj i nastavi',
        'Delete this Invoker' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Opšti interfejs jednostavnog mapiranja za veb servis %s',
        'Go back to' => 'Idi nazad na',
        'Mapping Simple' => 'Jednostavno mapiranje',
        'Default rule for unmapped keys' => 'Podrazumevano pravilo za nemapirane tastere',
        'This rule will apply for all keys with no mapping rule.' => 'Ovo pravilo će se primenjivati za sve tastere bez pravila mapiranja.',
        'Default rule for unmapped values' => 'Podrazumevano pravilo za nemapirane vrednosti',
        'This rule will apply for all values with no mapping rule.' => 'Ovo pravilo će se primenjivati za sve vrednosti bez pravila mapiranja.',
        'New key map' => '',
        'Add key mapping' => '',
        'Mapping for Key ' => '',
        'Remove key mapping' => 'Ukloni mapiranje tastera',
        'Key mapping' => '',
        'Map key' => 'Mapiraj taster',
        'matching the' => '',
        'to new key' => 'na novi taster',
        'Value mapping' => '',
        'Map value' => 'Mapiraj vrednost',
        'to new value' => 'na novu vrednost',
        'Remove value mapping' => 'Ukloni mapiranje vrednosti',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => '',
        'Delete this Key Mapping' => 'Obriši mapiranje za ovaj taster',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Dodaj novu operaciju veb servisu %s',
        'Change Operation %s of Web Service %s' => 'Promeni operaciju %s iz veb servisa %s',
        'Add new operation' => 'Dodaj novu operaciju',
        'Change operation %s' => 'Promeni operaciju %s',
        'Do you really want to delete this operation?' => 'Da li stvarno želite da obrišete ovu operaciju?',
        'Operation Details' => 'Detalji operacije',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Ime se obično koristi za pozivanje operacije veb servisa iz udaljenog sistema.',
        'Please provide a unique name for this web service.' => 'Molimo da obezbedite jedinstveno ime za ovaj veb servis.',
        'Mapping for incoming request data' => 'Mapiranje za dolazne podatke zahteva',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Podaci zahteva će biti obrađeni kroz mapiranje, radi transformacije u oblik koji "OTRS" očekuje.',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => 'Mapiranje za izlazne podatke odgovora',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Podaci odgovora će biti obrađeni kroz ovo mapiranje, radi transformacije u oblik koji udaljeni sistem očekuje.',
        'Delete this Operation' => 'Obriši ovu operaciju',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Opšti interfejs transporta "HTTP::SOAP" za veb servis %s',
        'Network transport' => 'Mrežni transport',
        'Properties' => 'Svojstva',
        'Endpoint' => 'Krajnja tačka',
        'URI to indicate a specific location for accessing a service.' =>
            '"URI" pokazivač specifične lokacije za pristup servisu.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'na primer "http://local.otrs.com:8000/Webservice/Example"',
        'Namespace' => 'Prostor imena',
        'URI to give SOAP methods a context, reducing ambiguities.' => '"URI" koji daje "SOAP" metodama kontekst, smanjuje dvosmislenosti.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'na primer "urn:otrs-com:soap:functions" ili "http://www.otrs.com/GenericInterface/actions"',
        'Maximum message length' => 'Najveća dužina poruke',
        'This field should be an integer number.' => 'Ovo polje treba da bude ceo broj.',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Ovde možete uneti maksimalnu veličinu (u bajtima) "SOAP" poruka koje će "OTRS" da obradi.',
        'Encoding' => 'Kodni raspored',
        'The character encoding for the SOAP message contents.' => 'Kodni raspored znakova za sadržaj "SOAP" poruke.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'na primer utf-8, latin1, iso-8859-1, cp1250, ...',
        'SOAPAction' => '"SOAP" akcija',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Izaberi "Da" za slanje popunjenog zaglavlja "SOAP" akcije.',
        'Set to "No" to send an empty SOAPAction header.' => 'Izaberi "Ne" za slanje praznog zaglavlja "SOAP" akcije.',
        'SOAPAction separator' => 'Separator "SOAP" akcije',
        'Character to use as separator between name space and SOAP method.' =>
            'Znak koji će se koristiti kao separator između prostora imena i "SOAP" metode.',
        'Usually .Net web services uses a "/" as separator.' => 'Obično ".Net" veb servisi koriste "/" kao separator.',
        'Authentication' => 'Autentifikacija',
        'The authentication mechanism to access the remote system.' => 'Mehanizam autentifikacije za pristum udaljenom sistemu.',
        'A "-" value means no authentication.' => 'Vrednost "-" znači nema autentifikacije.',
        'The user name to be used to access the remote system.' => 'Korisničko ime koje će biti korišćeno za pristup udaljenom sistemu.',
        'The password for the privileged user.' => 'Lozinka za privilegovanog korisnika',
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
        'GenericInterface Web Service Management' => 'Upravljanje oštim interfejsom veb servisa',
        'Add web service' => 'Dodaj veb servis',
        'Clone web service' => 'Kloniraj veb servis',
        'The name must be unique.' => 'Ime mora biti jedinstveno.',
        'Clone' => 'Kloniraj',
        'Export web service' => 'Izvezi veb servis',
        'Import web service' => 'Uvezi veb servis',
        'Configuration File' => 'Konfiguraciona datoteka',
        'The file must be a valid web service configuration YAML file.' =>
            'Datoteka mora da bude važeća "YAML" konfiguraciona datoteka veb servisa.',
        'Import' => 'Uvoz',
        'Configuration history' => 'Istorijat konfigurisanja',
        'Delete web service' => 'Obriši veb servis',
        'Do you really want to delete this web service?' => 'Da li stvarno želite da obrišete ovaj veb servis?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Nakon snimanja konfiguracije bićete ponovo preusmereni na ekran za uređivanje.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Ako želite da se vratite na pregled, molimo da kliknete na dugme "Idi na pregled".',
        'Web Service List' => 'Lista veb servisa',
        'Remote system' => 'Udaljeni sistem',
        'Provider transport' => 'Transport snabdevača',
        'Requester transport' => 'Transport potražioca',
        'Details' => 'Detalji',
        'Debug threshold' => '',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Operations are individual system functions which remote systems can request.' =>
            'Operacije su individualne sistemske funkcije koje udaljeni sistem može da zahteva.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => 'Kontroler',
        'Inbound mapping' => 'Ulazno mapiranje',
        'Outbound mapping' => 'Izlazno mapiranje',
        'Delete this action' => 'Obriši ovu akciju',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',
        'Delete webservice' => 'Obriši veb servis',
        'Delete operation' => 'Obriši operaciju',
        'Delete invoker' => '',
        'Clone webservice' => 'Kloniraj veb servis',
        'Import webservice' => 'Uvezi veb servis',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Istorijat konfiguracije opšteg interfejsa za veb servis %s',
        'Go back to Web Service' => 'Vratite se na veb servis',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Ovde možete videti starije verzije aktuelne konfiguracije veb servisa, napraviti izvoz ili je obnoviti.',
        'Configuration History List' => 'Lista - istorijat konfiguracije',
        'Version' => 'Verzija',
        'Create time' => 'Vreme kreiranja',
        'Select a single configuration version to see its details.' => 'Izaberi samo jednu konfiguracionu verziju za pregled njenih detalja.',
        'Export web service configuration' => 'Izvezi konfiguraciju veb servisa',
        'Restore web service configuration' => 'Obnovi konfiguraciju veb servisa',
        'Do you really want to restore this version of the web service configuration?' =>
            'Da li stvarno želite da vratite ovu verziju konfiguracije veb servisa?',
        'Your current web service configuration will be overwritten.' => 'Aktuelna konfiguracija veb servisa biće prepisana.',
        'Show or hide the content.' => 'Pokaži ili sakri sadržaj.',
        'Restore' => 'Obnovi',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'UPOZORENjE: Ako promenite ime grupe \'admin\' pre adekvatnog podešavanja u sistemskoj konfiguraciji, izgubićete pristup administrativnom panelu! Ukoliko se to desi, vratite ime grupi u "admin" pomoću "SQL" komande.',
        'Group Management' => 'Upravljanje grupama',
        'Add group' => 'Dodaj grupu',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '"admin" grupa služi za pristup administracionom prostoru a "stats" grupa prostoru statistike.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Napravi nove grupe za rukovanje pravima pristupa raznim grupama operatera (npr odeljenje nabavke, tehnička podrška, prodaja, ...).',
        'It\'s useful for ASP solutions. ' => 'Korisno za ASP rešenja.',
        'Add Group' => 'Dodaj grupu',
        'Edit Group' => 'Uredi grupu',

        # Template: AdminLog
        'System Log' => 'Sistemski dnevnik',
        'Here you will find log information about your system.' => 'Ovde ćete naći zabeležene informacije o događajima u sistemu.',
        'Hide this message' => 'Sakri ovu poruku',
        'Recent Log Entries' => 'Sveži unosi u dnevnik',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Upravljanje Imejl nalozima',
        'Add mail account' => 'Dodaj imejl nalog',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Sve dolazne poruke sa jednog naloga će biti usmerene u izabrani red!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Ako je vaš nalog od poverenja, koristiće se postojeća "X-OTRS" zaglavlja! "PostMaster" filteri se koriste uvek.',
        'Host' => 'Domaćin',
        'Delete account' => 'Obriši nalog',
        'Fetch mail' => 'Preuzmi poštu',
        'Add Mail Account' => 'Dodaj Imejl nalog',
        'Example: mail.example.com' => 'Primer: mail.example.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Od poverenja',
        'Dispatching' => 'Otprema',
        'Edit Mail Account' => 'Uredi Imejl nalog',

        # Template: AdminNavigationBar
        'Admin' => 'Admin',
        'Agent Management' => 'Upravljanje zaposlenima',
        'Queue Settings' => 'Podešavanje redova',
        'Ticket Settings' => 'Podešavanje tiketa',
        'System Administration' => 'Administracija sistema',

        # Template: AdminNotification
        'Notification Management' => 'Upravljanje obaveštenjima',
        'Select a different language' => 'Izaberi drugi jezik',
        'Filter for Notification' => 'Filter za obaveštenje',
        'Notifications are sent to an agent or a customer.' => 'Obaveštenje poslato zaposlenom ili korisniku.',
        'Notification' => 'Obaveštenje',
        'Edit Notification' => 'Uredi obaveštenje',
        'e. g.' => 'npr.',
        'Options of the current customer data' => 'Opcije podataka o aktuelnom korisniku',

        # Template: AdminNotificationEvent
        'Add notification' => 'Dodaj obaveštenje',
        'Delete this notification' => 'Obriši ovo obaveštenje',
        'Add Notification' => 'Dodaj Obaveštenje',
        'Article Filter' => 'Filter članka',
        'Only for ArticleCreate event' => 'Samo za događaj kreiranja članka',
        'Article type' => 'Tip članka',
        'Article sender type' => '',
        'Subject match' => 'Poklapanje predmeta',
        'Body match' => 'Poklapanje sadržaja',
        'Include attachments to notification' => 'Priključi priloge uz obavštenje',
        'Recipient' => 'Primalac',
        'Recipient groups' => 'Grupe primaoci',
        'Recipient agents' => 'Zaposleni primaoci',
        'Recipient roles' => 'Uloge primalaca',
        'Recipient email addresses' => 'Imejl adrese primalaca',
        'Notification article type' => 'Tip članka obaveštenja',
        'Only for notifications to specified email addresses' => 'Samo za obaveštenja za precizirane imejl adrese',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Da vidite prvih 20 slova predmeta (poslednjeg članka operatera).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Da vidite prvih 5 linija poruke (poslednjeg članka operatera).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Da vidite prvih 20 slova predmeta (poslednjeg članka operatera)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Da vidite prvih 5 linija poruke (poslednjeg članka operatera).',

        # Template: AdminPGP
        'PGP Management' => 'Upravljanje "PGP" ključevima',
        'Use this feature if you want to work with PGP keys.' => 'Upotrebi ovu mogućnost za rad sa "PGP"-ključevima.',
        'Add PGP key' => 'Dodaj "PGP"-ključ',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Na ovaj način možete direktno uređivati komplet knjučeva podešen u sistemskim opcijama.',
        'Introduction to PGP' => 'Upoznavanje sa "PGP"',
        'Result' => 'Rezultat',
        'Identifier' => 'Identifikator',
        'Bit' => 'Bit',
        'Fingerprint' => 'Otisak',
        'Expires' => 'Ističe',
        'Delete this key' => 'Obriši ovaj ključ',
        'Add PGP Key' => 'Dodaj "PGP"-ključ',
        'PGP key' => '"PGP"-ključ',

        # Template: AdminPackageManager
        'Package Manager' => 'Upravljanje paketima',
        'Uninstall package' => 'Deinstaliraj paket',
        'Do you really want to uninstall this package?' => 'Da li stvarno želite da deinstalirate ovaj paket?',
        'Reinstall package' => 'Instaliraj paket ponovo',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Da li stvarno želite da ponovo instalirate ovaj paket? Sve ručne promene će biti izgubljene.',
        'Continue' => 'Nastavi',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Instaliraj',
        'Install Package' => 'Instaliraj paket',
        'Update repository information' => 'Ažuriraj informacije o spremištu',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Mrežno spremište',
        'Vendor' => 'Prodavac',
        'Module documentation' => 'Dokumentacija kodula',
        'Upgrade' => 'Ažuriranje',
        'Local Repository' => 'Lokalno spremište',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Deinstaliraj',
        'Reinstall' => 'Instaliraj ponovo',
        'Feature Add-Ons' => '',
        'Download package' => 'Preuzmi paket',
        'Rebuild package' => 'Obnovi paket(rebuild)',
        'Metadata' => 'Meta-podaci',
        'Change Log' => 'Promeni dnevnik',
        'Date' => 'Datum',
        'List of Files' => 'Spisak datoteka',
        'Permission' => 'Dozvola',
        'Download' => 'Preuzimanje',
        'Download file from package!' => 'Preuzmi datoteku iz paketa!',
        'Required' => 'Obavezno',
        'PrimaryKey' => 'Primarni ključ',
        'AutoIncrement' => 'AutoUvećanje',
        'SQL' => '"SQL"',
        'File differences for file %s' => 'Razlike za datoteku %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Dnevnik preformansi',
        'This feature is enabled!' => 'Ova funkcija je aktivna!',
        'Just use this feature if you want to log each request.' => 'Aktivirati ovu mogućnost samo ako želite da zabeležite svaki zahtev..',
        'Activating this feature might affect your system performance!' =>
            'Aktiviranje ove funkcije može uticati na performanse sistema.',
        'Disable it here!' => 'Isključite je ovde!',
        'Logfile too large!' => 'Dnevnik je prevelik!',
        'The logfile is too large, you need to reset it' => 'Datoteka dnevnika je prevelika, treba da je resetujete',
        'Overview' => 'Pregled',
        'Range' => 'Opseg',
        'last' => 'poslednje',
        'Interface' => 'Interfejs',
        'Requests' => 'Zahtevi',
        'Min Response' => 'Min vreme reakcije',
        'Max Response' => 'Maks vreme reakcije',
        'Average Response' => 'Prosečno vreme reakcije',
        'Period' => 'Period',
        'Min' => 'Min',
        'Max' => 'Maks',
        'Average' => 'Prosek',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Upravljanje "PostMaster" Filterima',
        'Add filter' => 'Dodaj filter',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Radi otpreme ili filtriranja dolaznih mejlova na osnovu zaglavlja. Poklapanje pomoću Regularnih Izraza je takođe moguće.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Ukoliko želite poklapanje samo sa imejl adresom, koristite EMAILADDRESS:info@example.com u "Od", "Za" ili "Kk".',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Ukoliko koristite regularne izraze, takođe možete koristiti i upateru vrednost u () kao (***) u \'Set\' action.',
        'Delete this filter' => 'Obriši ovaj filter',
        'Add PostMaster Filter' => 'Dodaj "PostMaster" filter',
        'Edit PostMaster Filter' => 'Uredi "PostMaster" filter',
        'The name is required.' => 'Ime je obavezno.',
        'Filter Condition' => 'Uslov filtriranja',
        'AND Condition' => '',
        'Negate' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Ovo polje treba da bude važeći regularni izraz ili doslovno reč.',
        'Set Email Headers' => 'Podesi zaglavlja imejla',
        'The field needs to be a literal word.' => 'Ovo polje treba da bude doslovno reč.',

        # Template: AdminPriority
        'Priority Management' => 'Upravljanje prioritetima',
        'Add priority' => 'Dodaj prioritet',
        'Add Priority' => 'Dodaj prioritet',
        'Edit Priority' => 'Uredi prioritet',

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
        'Print' => 'Štampaj',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Poništi & zatvori prozor',
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
        'Manage Queues' => 'Upravljanje redovima',
        'Add queue' => 'Dodaj red',
        'Add Queue' => 'Dodaj Red',
        'Edit Queue' => 'Uredi Red',
        'Sub-queue of' => 'Pod-red od',
        'Unlock timeout' => 'Vreme do otključavanja',
        '0 = no unlock' => '0 = nema otključavanja',
        'Only business hours are counted.' => 'Meri se samo radno vreme.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Ako operater zaključa tiket i ne otključa ga pre isteka vremena otključavanja, tiket će se otključati i postati dostupan drugim zaposlenim.',
        'Notify by' => 'Obavešten od',
        '0 = no escalation' => '0 = nema eskalacije',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Ako kontakt sa korisnikom, bilo spoljašnji imejl ili telefon, nije dodat na novi tiket pre isticanja definisanog vremena, tiket će eskalirati.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Ako postoji dodat članak, kao npr nastavak putem imejla ili korisničkog portala, vreme ažuriranja eskalacije se resetuje. Ako ne ostoje kontakt podaci o korisniku, bilo imejl ili telefon dodati na tiket pre isticanja ovde definisanog vremena, tiket eskalira.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Ako se tiket ne zatvori pre ovde definisanog vremena, tiket eskalira.',
        'Follow up Option' => 'Opcije nastavka',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Definišite da li nastavak na zatvoreni tiket ponovo otvara tiket ili otvara novi.',
        'Ticket lock after a follow up' => 'Zaključavanje tiketa posle nastavka',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Ako je tiket zatvoren, a korisnik pošalje nastavak, tiket će biti zaključan na starog vlasnika.',
        'System address' => 'Sistemska adresa',
        'Will be the sender address of this queue for email answers.' => 'Biće adresa pošiljaoca za imejl odgovore iz ovog reda.',
        'Default sign key' => 'Podrazumevani ključ potpisa',
        'The salutation for email answers.' => 'Pozdrav za imejl odgovore.',
        'The signature for email answers.' => 'Potpis za imejl odgovore.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Upravljanje vezama Red-Automatski odgovor',
        'Filter for Queues' => 'Filter za redove',
        'Filter for Auto Responses' => 'Filter za Automatske odgovore',
        'Auto Responses' => 'Automatski odgovori',
        'Change Auto Response Relations for Queue' => 'Promeni veze sa Automatskim odgovorima za Red',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRole
        'Role Management' => 'Upravljanje ulogama',
        'Add role' => 'Dodaj ulogu',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Napravi ulogu i dodaj grupe u nju. Onda dodaj ulogu zaposlenima.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Nema definisanih uloga. upotrebite dugme za dodavanje za kreiranje nove uloge.',
        'Add Role' => 'Dodaj ulogu',
        'Edit Role' => 'Uredi ulogu',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Upravljanje vezama Uloga-Grupa',
        'Filter for Roles' => 'Filter za uloge',
        'Roles' => 'Uloge',
        'Select the role:group permissions.' => 'Izaberi dozvole za ulogu:grupu',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Ukoliko ništa nije izabrano, onda nema dozvola u ovoj grupi (tiketi neće biti dostupni za ovu ulogu).',
        'Change Role Relations for Group' => 'Promeni veze sa ulogama za grupu',
        'Change Group Relations for Role' => 'Promeni veze sa grupama za ulogu',
        'Toggle %s permission for all' => 'Promeni %s dozvole za sve',
        'move_into' => 'premesti u',
        'Permissions to move tickets into this group/queue.' => 'Pravo da se tiket premesti u ovu grupu/red.',
        'create' => 'kreiranje',
        'Permissions to create tickets in this group/queue.' => 'Pravo da se tiket kreira u ovoj grupi/redu.',
        'priority' => 'prioritet',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Pravo da se menja prioritet tiketa u ovoj grupi/redu.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Upravljanje vezama Zaposleni-Uloga',
        'Filter for Agents' => 'Filter za operatere',
        'Agents' => 'Zaposleni',
        'Manage Role-Agent Relations' => 'Upravljanje vezama Zaposleni-Uloga',
        'Change Role Relations for Agent' => 'Promeni veze sa ulogama za operatera',
        'Change Agent Relations for Role' => 'Promeni veze sa zaposlenima za ulogu',

        # Template: AdminSLA
        'SLA Management' => 'Upravljanje "SLA"',
        'Add SLA' => 'Dodaj "SLA"',
        'Edit SLA' => 'Uredi "SLA"',
        'Please write only numbers!' => 'Molimo pišite samo brojeve!',

        # Template: AdminSMIME
        'S/MIME Management' => '"S/MIME" upravljanje',
        'Add certificate' => 'Dodaj sertifikat',
        'Add private key' => 'Dodaj privatni ključ',
        'Filter for certificates' => 'Filter za sertifikate',
        'Filter for SMIME certs' => 'Filter za "SMIME" sertifikate',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Ovde možete dodati veze do vašek privatnog sertifikata, koji će biti uključeni u "SMIME" potpis kad god ga upotrebite za potpisvanje imejla.',
        'See also' => 'Pogledaj još',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Na ovaj način možete direktno da uređujete certifikate i privatne ključeve u sistemu datoteka.',
        'Hash' => 'Hash',
        'Handle related certificates' => 'Rukovanje povezanim sertifikatima',
        'Read certificate' => '',
        'Delete this certificate' => 'Obriši ovaj sertifikat',
        'Add Certificate' => 'Dodaj sertifikat',
        'Add Private Key' => 'Dodaj privatni ključ',
        'Secret' => 'Tajna',
        'Related Certificates for' => 'Povezani sertifikati za',
        'Delete this relation' => 'Obriši ovu vezu',
        'Available Certificates' => 'Raspoloživi sertifikati',
        'Relate this certificate' => 'Poveži ovaj sertifikat',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => '',
        'Close window' => 'Zatvori prozor',

        # Template: AdminSalutation
        'Salutation Management' => 'Upravljanje pozdravima',
        'Add salutation' => 'Dodaj pozdrav',
        'Add Salutation' => 'Dodaj pozdrav',
        'Edit Salutation' => 'Uredi pozdrav',
        'Example salutation' => 'Primer pozdrava',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            'Ova opcija će prinuditi dispečer da se pokrene čak i ako je proces još uvek registrovan u bazi',
        'Start scheduler' => 'Pokreni dispečer proces',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            'Dispečer ne može biti pokrenut. Proverite da li dispečer već radi i pokušajte ponovo pomoću opcije za prinudno pokretanje',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Potrebno je da siguran mod bude uključen!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Siguran mod će (uobučajeno) biti podešen nakon inicijalne instalacije.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Ukoliko siguran mod nije aktiviran, pokrenite ga kroz sistemsku konfiguraciju jer je vaša aplikacija već pokrenuta.',

        # Template: AdminSelectBox
        'SQL Box' => '"SQL" Box',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Ovde možete uneti "SQL" komande i poslati ih direktno aplikacionoj bazi podataka.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Postoji greška u sintaksi vašeg "SQL" upita. Molimo proverite.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Najmanje jedan parametar nedostaje za povezivanje. Molimo proverite.',
        'Result format' => 'Format rezultata',
        'Run Query' => 'Pokreni upit',

        # Template: AdminService
        'Service Management' => 'Upravljanje servisima',
        'Add service' => 'Dodaj servis',
        'Add Service' => 'Dodaj servis',
        'Edit Service' => 'Uredi servis',
        'Sub-service of' => 'Sub-servis od',

        # Template: AdminSession
        'Session Management' => 'Upravljanje sesijama',
        'All sessions' => 'Sve sesije',
        'Agent sessions' => 'Sesije operatera',
        'Customer sessions' => 'Sesije korisnika',
        'Unique agents' => 'Jedinsveni zapoleni',
        'Unique customers' => 'Jedinstveni korisnici',
        'Kill all sessions' => 'Ugasi sve sesije',
        'Kill this session' => 'Ugasi ovu sesiju',
        'Session' => 'Sesija',
        'Kill' => 'Ugasi',
        'Detail View for SessionID' => 'Detaljni pregled za ID sesije',

        # Template: AdminSignature
        'Signature Management' => 'Upravljanje potpisima',
        'Add signature' => 'Dodaj potpis',
        'Add Signature' => 'Dodaj potpis',
        'Edit Signature' => 'Uredi potpis',
        'Example signature' => 'Primer potpisa',

        # Template: AdminState
        'State Management' => 'Upravljanje statusima',
        'Add state' => 'Dodaj status',
        'Please also update the states in SysConfig where needed.' => 'Molimo da ažurirate stause i u "SysConfig" gde je to potrebno.',
        'Add State' => 'Dodaj status',
        'Edit State' => 'Uredi status',
        'State type' => 'Tip statusa',

        # Template: AdminSysConfig
        'SysConfig' => 'Sistemska konfiguracija',
        'Navigate by searching in %s settings' => 'Navigacija kroz pretraživanje u %s podešavanjima',
        'Navigate by selecting config groups' => 'Navigacija izborom konfiguracionih grupa',
        'Download all system config changes' => 'Preuzmi sve promene sistemskih podešavanja',
        'Export settings' => 'Izvezi podešavanja',
        'Load SysConfig settings from file' => 'Učitaj sistemska podešavanja iz datoteke',
        'Import settings' => 'Uvezi podešavanja',
        'Import Settings' => 'Uvezi Podešavanja',
        'Please enter a search term to look for settings.' => 'Molimo unesite ',
        'Subgroup' => 'Podgrupa',
        'Elements' => 'Elementi',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Uredi konfiguraciona podešavanja',
        'This config item is only available in a higher config level!' =>
            'Ova konfiguraciona opcija je dostupna samo na višem konfiguracionom nivou',
        'Reset this setting' => 'Poništi ovo podešavanje',
        'Error: this file could not be found.' => 'Greška: ne može se pronaći ova datoteka.',
        'Error: this directory could not be found.' => 'Greška: ne može se pronaći ovaj direktorijum.',
        'Error: an invalid value was entered.' => 'Greška: uneta je pogrešna vrednost.',
        'Content' => 'Sadržaj',
        'Remove this entry' => 'Ukloni ovaj unos',
        'Add entry' => 'Dodaj unos',
        'Remove entry' => 'Ukloni unos',
        'Add new entry' => 'Dodaj nov unos',
        'Delete this entry' => 'Obriši ovaj unos',
        'Create new entry' => 'Napravi nov unos',
        'New group' => 'Nova grupa',
        'Group ro' => 'Grupa "ro"',
        'Readonly group' => 'Grupa samo za čitanje',
        'New group ro' => 'Nova "ro" grupa',
        'Loader' => '"Loader"',
        'File to load for this frontend module' => 'Datoteka koju treba učitati za ovaj modul',
        'New Loader File' => 'Nova "Loader" datoteka',
        'NavBarName' => 'Naziv navigacione trake',
        'NavBar' => 'Navigaciona traka',
        'LinkOption' => 'Opcije veze',
        'Block' => 'Blok',
        'AccessKey' => 'Ključ za pristup',
        'Add NavBar entry' => 'Dodaj stavku u navigacionu traku',
        'Year' => 'godina',
        'Month' => 'mesec',
        'Day' => 'dan',
        'Invalid year' => 'Pogrešna godina',
        'Invalid month' => 'Pogrešan mesec',
        'Invalid day' => 'Pogrešan dan',
        'Show more' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Upravljanje sistemskim imejlom',
        'Add system address' => 'Dodaj sistemsku adresu',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Sve dolazne poruke sa ovom adresom u polju "Za" ili "Kk" biće otpremljeni u izabrani red.',
        'Email address' => 'imejl adresa',
        'Display name' => 'Prikaži ime',
        'Add System Email Address' => 'Dodaj sistemsku imejl adresu',
        'Edit System Email Address' => 'Uredi sistemsku imejl adresu',
        'The display name and email address will be shown on mail you send.' =>
            'Prikazano ime i imejl adresa će biti prikazani na poruci koju ste poslali.',

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
        'The current ticket state is' => 'Trenutni staus tiketa je',
        'Your email address is' => 'Vaša imejl adresa je',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => 'Filter za priloge',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Promeni stanje aktivnosti za sve',
        'Link %s to selected %s' => 'poveži %s sa izabranim %s',

        # Template: AdminType
        'Type Management' => 'Upravljanje tipovima',
        'Add ticket type' => 'Dodaj tip tiketa',
        'Add Type' => 'Dodaj tip',
        'Edit Type' => 'Uredi tip',

        # Template: AdminUser
        'Add agent' => 'Dodaj operatera',
        'Agents will be needed to handle tickets.' => 'Potrebni su operateri za obradu tiketa.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Ne zaboravite da dodate novog operatera u grupe i/ili uloge!',
        'Please enter a search term to look for agents.' => 'Molimo unesite frazu za pretragu radi nalaženja operatera.',
        'Last login' => 'Prethodna prijava',
        'Switch to agent' => 'Pređi na operatera',
        'Add Agent' => 'Dodaj Operatera',
        'Edit Agent' => 'uredi Operatera',
        'Firstname' => 'Ime',
        'Lastname' => 'Prezime',
        'Will be auto-generated if left empty.' => '',
        'Start' => 'Start',
        'End' => 'Kraj',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Upravljanje vezama Zaposleni-Grupa',
        'Change Group Relations for Agent' => 'Promeni veze sa grupama za operatera',
        'Change Agent Relations for Group' => 'Promeni veze sa zaposlnima za grupu',
        'note' => 'napomena',
        'Permissions to add notes to tickets in this group/queue.' => 'Dozvola za dodavanje napomena na tikete u ovoj grupi/redu.',
        'owner' => 'Vlasnik',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Dozvole za promenu vlasnika tiketa u ovoj grupi/redu.',

        # Template: AgentBook
        'Address Book' => 'Adresar',
        'Search for a customer' => 'Traži korisnika',
        'Add email address %s to the To field' => 'Dodaj imejl adresu %s u polje "Za:"',
        'Add email address %s to the Cc field' => 'Dodaj imejl adresu %s u polje "Kk:"',
        'Add email address %s to the Bcc field' => 'Dodaj imejl adresu %s u polje "SKk:"',
        'Apply' => 'Primeni',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ID korisnika',
        'Customer User' => 'Korisnik',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Dvostruki unos',
        'This address already exists on the address list.' => 'Ova adresa već postoji u listi',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '',

        # Template: AgentDashboard
        'Dashboard' => 'Komandna tabla',

        # Template: AgentDashboardCalendarOverview
        'in' => 'u',

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
        '%s %s is available!' => '%s %s je dostupno!',
        'Please update now.' => 'Molimo ažurirajte sada.',
        'Release Note' => 'Obaveštenje o verziji',
        'Level' => 'Nivo',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Poslano pre %s.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Moji zaključani tiketi',
        'My watched tickets' => 'Moji praćeni tiketi',
        'My responsibilities' => 'Odgovoran sam za',
        'Tickets in My Queues' => 'Tiketi u mojim redovima',
        'Service Time' => 'Servisno vreme',
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
        'The ticket has been locked' => 'Tiket je zaključan.',
        'Undo & close window' => 'Odustani & zatvori prozor',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'Da bi prihvatili neke vesti, "..."',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Poveži objekt: %s',
        'go to link delete screen' => 'idi na ekran za brisanje veze',
        'Select Target Object' => 'Izaberi ciljni objekat',
        'Link Object' => 'Poveži objekat',
        'with' => 'sa',
        'Unlink Object: %s' => 'Prekini vezu sa objektom: %s',
        'go to link add screen' => 'idi na prozor za dodavanje veze',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Uredi lične postavke',

        # Template: AgentSpelling
        'Spell Checker' => 'Provera pravopisa',
        'spelling error(s)' => 'Pravopisne greške',
        'Apply these changes' => 'Primeni ove izmene',

        # Template: AgentStatsDelete
        'Delete stat' => 'Obriši statistiku',
        'Stat#' => 'Statistika Br.',
        'Do you really want to delete this stat?' => 'Da li stvarno želite da obrišete ovu statistiku?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Korak %s',
        'General Specifications' => 'Opšte specifikacije',
        'Select the element that will be used at the X-axis' => 'Izaberite element koji će biti upotrebljen na X-osi',
        'Select the elements for the value series' => 'Izaberite elemente za opsege vrednosti',
        'Select the restrictions to characterize the stat' => 'Izaberite ograničenja koja karakterišu statistiku',
        'Here you can make restrictions to your stat.' => 'Ovde možete postaviti ograničenja na vašoj statistici.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Ako uklonite oznaku sa elementa "Fiksirano", operater koji pravi statistiku će moći da menja atribute konkretnog elementa.',
        'Fixed' => 'Fiksirano',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Molimo da izaberete samo jedan element ili isključite dugme "fiksirano"!',
        'Absolute Period' => 'Apsolutni period',
        'Between' => 'Između',
        'Relative Period' => 'Relativni period',
        'The last' => 'Poslednji',
        'Finish' => 'Završi',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Dozvole',
        'You can select one or more groups to define access for different agents.' =>
            'Radi definisanja pristupa za operatere možete izabrati jednu ili više grupa.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Neki formati rezultata su isključeni jer najmanje jedan neophodni paket nije instaliran.',
        'Please contact your administrator.' => 'Molimo, kontaktirajte vašeg administratora.',
        'Graph size' => 'Veličina grafikona',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Ako koristite grafikon kao izlazni format morate izabrati najmanje jednu veličinu grafikona.',
        'Sum rows' => 'Zbir redova',
        'Sum columns' => 'Zbir kolona',
        'Use cache' => 'Upotrebi keš',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'Većina stat. podataka se može keširati. Ovo će ubrzati prikaz statistike.',
        'If set to invalid end users can not generate the stat.' => 'Ako je pogrešno, krajnji korisnici ne mogu generisati statistiku.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Ovde možete definisati opsege vrednosti.',
        'You have the possibility to select one or two elements.' => 'Imate mogućnost da izaberete jedan ili dva elementa.',
        'Then you can select the attributes of elements.' => 'Onda možete izabrati atribute za elemente.',
        'Each attribute will be shown as single value series.' => 'Svaki atribut će biti prikazan kao pojedinačni opseg vrednosti.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Ako ne izaberete ni jedan atribut, prilikom generisanja statistike biće upotrebljeni svi atributi elementa kao i atributi dodani nakon poslednje konfiguracije.',
        'Scale' => 'Skaliranje',
        'minimal' => 'minimalno',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Molimo zapamtite, da skala za opsege vrednosti moda da bude veća od skale za X-Osu (npr X-Osa => mesec; Vrednost opsega => godina).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Ovde možete definisati x-osu. Možete izabrati jedan element od ponuđenih.',
        'maximal period' => 'maksimalni period',
        'minimal scale' => 'minimalna skala',

        # Template: AgentStatsImport
        'Import Stat' => 'Uvezi statistiku',
        'File is not a Stats config' => 'Ova datoteka nije konfiguracija statistike',
        'No File selected' => 'Nije izabrana nijedna datoteka',

        # Template: AgentStatsOverview
        'Stats' => 'Statistika',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Nema izabranih elemenata.',

        # Template: AgentStatsView
        'Export config' => 'Izvezi konfiguraciju',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Preko polja za unos i izbor možete uticati na oblik i sardžaj statistike.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Na koja polja i formate tačno možete da utičete je definisano od strane administratora statistike.',
        'Stat Details' => 'Detalji staistke',
        'Format' => 'Format',
        'Graphsize' => 'Veličina grafikona',
        'Cache' => 'Keš',
        'Exchange Axis' => 'Zameni ose',
        'Configurable params of static stat' => 'Podesivi parametri statičke statistike',
        'No element selected.' => 'Nije izabran ni jedan element.',
        'maximal period from' => 'maksimalni period od',
        'to' => 'do',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Promeni "slobodan" tekst tiketa',
        'Change Owner of Ticket' => 'Promeni vlasnika tiketa',
        'Close Ticket' => 'Zatvori tiket',
        'Add Note to Ticket' => 'Dodaj napomenu uz tiket',
        'Set Pending' => 'Stavi na čekanje',
        'Change Priority of Ticket' => 'Promeni prioritet tiketa',
        'Change Responsible of Ticket' => 'Promeni odgovornog za tiket',
        'Service invalid.' => 'Neispravan servis',
        'New Owner' => 'Novi vlasnik',
        'Please set a new owner!' => 'Molimo odredite novog vlasnika',
        'Previous Owner' => 'Prethodni vlasnik',
        'Inform Agent' => 'Obavesi operatera',
        'Optional' => 'Opcioni',
        'Inform involved Agents' => 'Obavesti relevantne operatere',
        'Spell check' => 'Provera pravopisa',
        'Note type' => 'Tip napomene',
        'Next state' => 'Sledeći status',
        'Date invalid!' => 'Neispravan datum',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Odbaci tiket',
        'Bounce to' => 'Preusmeri na',
        'You need a email address.' => 'Potrebna vam je imejl adresa.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Ispravna imejl adresa je neophodna, ali ne koristite lokalnu adresu!',
        'Next ticket state' => 'Naredni status tiketa',
        'Inform sender' => 'Obavesti pošiljaoca',
        'Send mail' => 'Pošalji imejl!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Masovne akcije na tiketima',
        'Send Email' => 'Pošalji imejl',
        'Merge to' => 'Objedini sa',
        'Invalid ticket identifier!' => 'Neispravan identifikator tiketa!',
        'Merge to oldest' => 'Objedini sa najstarijom',
        'Link together' => 'Poveži zajedno',
        'Link to parent' => 'Poveži sa roditeljem',
        'Unlock tickets' => 'Otključaj tikete',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Napiši odgovor na tiket',
        'Please include at least one recipient' => 'Molimo da uključite bar jednog primaoca',
        'Remove Ticket Customer' => 'Ukloni korisnika sa tiketa',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Molimo da uklonite ovaj unos i unesete nov sa ispravnom vrednošću.',
        'Remove Cc' => 'Ukloni kopiju',
        'Remove Bcc' => '',
        'Address book' => 'Adresar',
        'Pending Date' => 'Datum čekanja',
        'for pending* states' => 'za stanja čekanja',
        'Date Invalid!' => 'Neispravan datum!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Promena korisnika za tiket',
        'Customer user' => 'Korisnik',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Otvori novi imejl tiket',
        'From queue' => 'iz Reda',
        'To customer user' => '',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer user as the main customer user.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Uzmi sve',
        'Text Template' => '',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Prosledi tiket: %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Istorijat od',
        'History Content' => 'Sadržaj istorijata',
        'Zoom view' => 'Detaljni pregled',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Spajanje tiketa',
        'You need to use a ticket number!' => 'Molimo vas da koristite broj tiketa!',
        'A valid ticket number is required.' => 'Neophodan je ispravan broj tiketa.',
        'Need a valid email address.' => 'Potrebna je ispravna imejl adresa.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Premesti tiket',
        'New Queue' => 'Novi Red',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Izaberi sve',
        'No ticket data found.' => 'Nisu nađeni podaci o tiketu',
        'First Response Time' => 'Vreme prvog odgovora',
        'Update Time' => 'Vreme ažuriranja',
        'Solution Time' => 'Vreme rešenja',
        'Move ticket to a different queue' => 'Premesti tiket u drugi red',
        'Change queue' => 'Promeni red',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Promeni opcije pretrage',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => 'Tiketa po strani',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Otvori novi telefonski tiket',
        'Please include at least one customer for the ticket.' => 'Molimo da uključite bar jednog korisnika za tiket.',
        'Select this customer as the main customer.' => '',
        'To queue' => 'U red',

        # Template: AgentTicketPhoneCommon

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Pregled neformatirane poruke',
        'Plain' => 'Neformatirano',
        'Download this email' => 'Preuzmi ovu poruku',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Info o tiketu',
        'Accounted time' => 'Obračunato vreme',
        'Linked-Object' => 'Povezani objekt',
        'by' => 'od',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Šablon pretrage',
        'Create Template' => 'Napravi šablon',
        'Create New' => 'Napravi nov',
        'Profile link' => 'Veza profila',
        'Save changes in template' => 'Sačuvaj promene u šablonu',
        'Add another attribute' => 'Dodaj još jedan atribut',
        'Output' => 'Pregled rezultata',
        'Fulltext' => 'Tekst',
        'Remove' => 'Ukloni',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Prijava korisnika',
        'Created in Queue' => 'Otvoreno u redu',
        'Lock state' => 'Staus zaključavanja',
        'Watcher' => 'Praćenje',
        'Article Create Time (before/after)' => 'Vreme kreiranja članka (pre/posle)',
        'Article Create Time (between)' => 'Vreme kreiranja članka (između)',
        'Ticket Create Time (before/after)' => 'Vreme otvaranja tiketa (pre/posle)',
        'Ticket Create Time (between)' => 'Vreme otvaranja tiketa (između)',
        'Ticket Change Time (before/after)' => 'Vreme promene tiketa (pre/posle)',
        'Ticket Change Time (between)' => 'Vreme promene tiketa (između)',
        'Ticket Close Time (before/after)' => 'Vreme zatvaranja tiketa (pre/posle)',
        'Ticket Close Time (between)' => 'Vreme zatvaranja tiketa (između)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Pretraga arhiva',
        'Run search' => 'Pokreni pretragu',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filter za Članke',
        'Article Type' => 'Tip članka',
        'Sender Type' => 'Tip pošiljaoca',
        'Save filter settings as default' => 'Sačuvaj poešavanja filtera kao podrazumevana',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Locked' => 'Zaključano',
        'Linked Objects' => 'Povezani objekti',
        'Article(s)' => 'Članak/Članci',
        'Change Queue' => 'Promeni Red',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Add Filter' => 'Dodaj Filter',
        'Set' => 'Podesi',
        'Reset Filter' => 'Resetuj Filter',
        'Show one article' => 'Prikaži jedan članak',
        'Show all articles' => 'Prikaži sve članke',
        'Unread articles' => 'Nepročitani članci',
        'No.' => 'Br.',
        'Important' => '',
        'Unread Article!' => 'Nepročitani Članci!',
        'Incoming message' => 'Dolazna poruka',
        'Outgoing message' => 'Odlazna poruka',
        'Internal message' => 'Interna poruka',
        'Resize' => 'Promena veličine',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Učitaj blokirani sadržaj.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Isprati unazad',

        # Template: CustomerFooter
        'Powered by' => 'Pokreće',
        'One or more errors occurred!' => 'Dogodila se jedna ili više grešaka!',
        'Close this dialog' => 'Zatvori ovaj dijalog',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Nije moguće otvoriti iskačući prozor. Molimo da isključite blokadu iskačućih prozora za ovu aplikaciju.',
        'There are currently no elements available to select from.' => '',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'Java Skript nije dostupan.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Kako bi ste koristili "OTRS" neophodno je da aktivirate Java skript u vašem Web čitaču.',
        'Browser Warning' => 'Upozorenje Web čitača',
        'The browser you are using is too old.' => 'Web čitač koji koristite je previše star.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            '"OTRS" funcioniše na velikom broju Web čitača, molimo da instalirate i koristite jedan od ovih.',
        'Please see the documentation or ask your admin for further information.' =>
            'Molimo da pregledate dokumentaciju ili pitate vašeg administratora za dodatne informacije.',
        'Login' => 'Prijavljivanje',
        'User name' => 'Korisničko ime',
        'Your user name' => 'Vaše korisničko ime',
        'Your password' => 'Vaša lozinka',
        'Forgot password?' => 'Zaboravili ste lozinku?',
        'Log In' => 'Prijavljivanje',
        'Not yet registered?' => 'Niste registrovani?',
        'Sign up now' => 'Regisrujte se sada',
        'Request new password' => 'Zahtev za novu lozinku',
        'Your User Name' => 'Vaše korisničko ime',
        'A new password will be sent to your email address.' => 'Nova lozinka će biti poslata na vašu imejl adresu.',
        'Create Account' => 'Kreirajte nalog',
        'Please fill out this form to receive login credentials.' => 'Molimo da popunite ovaj obrazac da bi ste dobili podatke za prijavu.',
        'How we should address you' => 'Kako da vas oslovljavamo',
        'Your First Name' => 'Vaše ime',
        'Your Last Name' => 'Vaše prezime',
        'Your email address (this will become your username)' => 'Vaša imejl adresa (to će biti vaše korisničko ime)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Uredite lične postavke',
        'Logout %s' => '',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Sporazum o nivou usluge',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Dobrodošli!',
        'Please click the button below to create your first ticket.' => 'Molimo da pritisnete dugme ispod za kreiranje vašeg prvog tiketa.',
        'Create your first ticket' => 'Kreirajte vaš prvi tiket',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Štampa tiketa',
        'Ticket Dynamic Fields' => '',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'npr 10*5155 ili 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Tekstualno pretraživanje u tiketima (npr "Ba*a" or "Mil*")',
        'Carbon Copy' => 'Kopija',
        'Types' => 'Tipovi',
        'Time restrictions' => 'Vremenska ograničenja',
        'No time settings' => 'Nema podešavanja vremena',
        'Only tickets created' => 'Samo tiketi otvoreni',
        'Only tickets created between' => 'Samo tiketi otvoreni između',
        'Ticket archive system' => 'Sistem za arhiviranje tiketa',
        'Save search as template?' => 'Sačuvaj pretragu kao šablon?',
        'Save as Template?' => 'Sačuvati kao šablon?',
        'Save as Template' => 'Sačuvaj kao šablon',
        'Template Name' => 'Naziv šablona',
        'Pick a profile name' => 'Izaberi naziv profila',
        'Output to' => 'Izlaz na',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'od',
        'Page' => 'Strana',
        'Search Results for' => 'Rezultati pretraživanja za',

        # Template: CustomerTicketZoom
        'Expand article' => 'Raširi članak',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'Odgovori',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
        'Sunday' => 'nedelja',
        'Monday' => 'ponedeljak',
        'Tuesday' => 'utorak',
        'Wednesday' => 'sreda',
        'Thursday' => 'četvrtak',
        'Friday' => 'petak',
        'Saturday' => 'subota',
        'Su' => 'ne',
        'Mo' => 'po',
        'Tu' => 'ut',
        'We' => 'sr',
        'Th' => 'če',
        'Fr' => 'pe',
        'Sa' => 'su',
        'Event Information' => '',
        'Ticket fields' => '',
        'Dynamic fields' => '',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Neispravan datum (poteban budući datum)!',
        'Previous' => 'Nazad',
        'Open date selection' => 'Otvori izbor datuma',

        # Template: Error
        'Oops! An Error occurred.' => 'Ups. Dogodila se greška.',
        'Error Message' => 'Poruka o grešci',
        'You can' => 'Vi možete',
        'Send a bugreport' => 'Pošalji izveštaj o grešci',
        'go back to the previous page' => 'idi na prethodnu stranu',
        'Error Details' => 'Detalji greške',

        # Template: Footer
        'Top of page' => 'Na vrh strane',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Ako napustite ovu stranicu, svi otvoreni prozori će biti zatvoreni!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Prikaz ovog ekrana je već otvoren. Želite li da ga zatvorite i učitate ovaj umesto njega?',
        'Please enter at least one search value or * to find anything.' =>
            '',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Prijavljeni ste kao',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'Java skript nije dostupan.',
        'Database Settings' => 'Podešavanje baze podataka',
        'General Specifications and Mail Settings' => 'Opšte specifikacije i podešavanje pošte',
        'Registration' => 'Registracija',
        'Welcome to %s' => 'Dobrodošli na %s',
        'Web site' => '"Web" stranica',
        'Mail check successful.' => 'Uspešna provera imejl podešavanja.',
        'Error in the mail settings. Please correct and try again.' => 'Greška u podešavanju imejla. Molimo ispravite i pokušajte ponovo.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Podešavanje odlazne pošte',
        'Outbound mail type' => 'Tip odlazne pošte',
        'Select outbound mail type.' => 'Izaberite tip odlazne pošte',
        'Outbound mail port' => 'Port za odlaznu poštu',
        'Select outbound mail port.' => 'Izaberite port za odlaznu poštu',
        'SMTP host' => '"SMTP"-domaćin',
        'SMTP host.' => '"SMTP"-domaćin.',
        'SMTP authentication' => '"SMTP" autentikacija',
        'Does your SMTP host need authentication?' => 'Da li vaš "SMTP"-domaćin zahteva autentikaciju?',
        'SMTP auth user' => '"SMTP" korisnik',
        'Username for SMTP auth.' => 'korisničko ime za "SMTP" autentikaciju',
        'SMTP auth password' => '"SMTP" lozinka',
        'Password for SMTP auth.' => 'Lozinka za "SMTP" autentikaciju',
        'Configure Inbound Mail' => 'Podešavanje dolazne pošte',
        'Inbound mail type' => 'Tip dolaznog mejla',
        'Select inbound mail type.' => 'Izaberi tip dolaznog mejla',
        'Inbound mail host' => 'Server dolazne pošte',
        'Inbound mail host.' => 'Server dolazne pošte.',
        'Inbound mail user' => 'korisnik dolazne pošte',
        'User for inbound mail.' => 'Korisnik dolaznog mejla',
        'Inbound mail password' => 'Lozinka dolaznog mejla',
        'Password for inbound mail.' => 'Lozinka za dolazni mejl',
        'Result of mail configuration check' => 'Rezultat provere podešavanja pošte',
        'Check mail configuration' => 'Proveri konfiguraciju mejla',
        'Skip this step' => 'Preskoči ovaj korak',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            'Preskakanje ovog koraka automatski preskačete i registraciju vaše "OTRS" instalacije. jeste li sigurni da želite da nastavite?',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Uspešno instaliranje baze',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => 'Proverite podešavanja baze',
        'Result of database check' => 'Rezultat provere baze podataka',
        'OK' => '',
        'Database check successful.' => 'Uspešna provera baze podataka.',
        'Database User' => '',
        'New' => 'Nov',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Novi korisnika baze sa ograničenim pravima će biti kreiran za ovaj "OTRS" sistem',
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
            'Da bi ste koristili "OTRS" morate uneti sledeće u komandnu liniju (Terminal/Shell) kao "root".',
        'Restart your webserver' => 'Ponovo pokrenite vaš WEB Server.',
        'After doing so your OTRS is up and running.' => 'Posle ovoga vaš "OTRS" je uključen i radi.',
        'Start page' => 'Početna strana',
        'Your OTRS Team' => 'Vaš "OTRS" Tim',

        # Template: InstallerLicense
        'Accept license' => 'Prihvati licencu',
        'Don\'t accept license' => 'Ne prihvataj licencu',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organizacija',
        'Position' => 'Pozicija',
        'Complete registration and continue' => 'Kompletiraj registraciju i nastavi',
        'Please fill in all fields marked as mandatory.' => 'Molimo da popunite sva polja označena kao obavezna.',

        # Template: InstallerSystem
        'SystemID' => 'Sistemski ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Sistemski identifikator. Svaki broj tiketa i svaki ID "HTTP" sesije sadrži ovaj broj.',
        'System FQDN' => 'Sistemski "FQDN"',
        'Fully qualified domain name of your system.' => '"FQDN" - ime servera uključujući puno ime domena npr "otrs-server.example.org"',
        'AdminEmail' => 'imejl administrator',
        'Email address of the system administrator.' => 'imejl adresa sistemskog administratora.',
        'Log' => 'Dnevnik',
        'LogModule' => 'Modul dnevnika',
        'Log backend to use.' => 'Sistem koji se koristi za dnevnik.',
        'LogFile' => 'Datoteka dnevnika',
        'Webfrontend' => 'Mrežni interfejs',
        'Default language' => 'Podrazumevani jezik',
        'Default language.' => 'Podrazumevani jezik',
        'CheckMXRecord' => 'Proveri "MX"-podatke',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Ručno uneta imejl adresa se proverava pomoću "MX" podatka pronađenog u "DNS".Nemojte koristiti ovu opciju ako je vaš "DNS" spor ili ne može da razreši javne adrese',

        # Template: LinkObject
        'Object#' => 'Objekt#',
        'Add links' => 'Dodaj veze',
        'Delete links' => 'Obriši veze',

        # Template: Login
        'Lost your password?' => 'Izgubili ste lozinku?',
        'Request New Password' => 'Zahtev za novu lozinku',
        'Back to login' => 'Nazad na prijavljivanje',

        # Template: Motd
        'Message of the Day' => 'Današnja poruka',

        # Template: NoPermission
        'Insufficient Rights' => 'Nedovoljna ovlaštenja',
        'Back to the previous page' => 'Vratite se na prethodnu stranu',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Pokaži prvu stranu',
        'Show previous pages' => 'Pokaži prethodne strane',
        'Show page %s' => 'pokaži stranu %s',
        'Show next pages' => 'Pokaži sledeće strane',
        'Show last page' => 'Pokaži poslednju stranu',

        # Template: PictureUpload
        'Need FormID!' => 'Potreban ID formulara!',
        'No file found!' => 'Datoteka nije pronađena!',
        'The file is not an image that can be shown inline!' => 'Datoteka nije slika koja se može neposredno prikazati!',

        # Template: PrintFooter
        'URL' => '"URL"',

        # Template: PrintHeader
        'printed by' => 'štampao',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => '"OTRS" test strana',
        'Welcome %s' => 'Dobrodošli %s',
        'Counter' => 'Brojač',

        # Template: Warning
        'Go back to the previous page' => 'Vratite se na prethodnu stranu',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '"ACL" modul koji dozvoljava da tiketi roditelji budu zatvoreni samo ako su već zatvoreni svi tiketi deca ("Status" pokazuje koji statusi nisu dostupni za tiket roditelj dok se ne zatvore svi tiketi deca).',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Aktivira mehanizam treptanja reda koji sarži najstariji tiket.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Aktivira opciju izgubljene lozinke za operatere, na interfejsu za njih.',
        'Activates lost password feature for customers.' => 'Aktivira opciju izgubljene lozinke za korisnike.',
        'Activates support for customer groups.' => 'Aktivira podršku za korisničke grupe.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Aktivira filter za članke u proširenom pregledu radi definisanja koji članci treba da budu prikazani.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Aktivira raspoložive teme - šablone u sistemu. Vrednost 1 znači aktivno, 0 znači neaktivno.',
        'Activates the ticket archive system search in the customer interface.' =>
            'Aktivira mogućnost pretraživanja arhive tiketa u korisničkom interfejsu.',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Aktivira arhivski sistem radi ubrzanja rada, tako što ćete neke tiketeukloniti van dnevnog praćenja. Da biste pronašli ove tikete, marker arhive mora biti omogućen za pretragu tiketa.',
        'Activates time accounting.' => 'Aktivira merenje vremena.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Dodaje tekuću godinu i mesec kao sufiks u "OTRS" dnevniku. Biće kreirana datoteka dnevnika za svaki mesec.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Jednokratno dodaje neradne dane za izabrani kalendar. Molimo Vas da koristite jednu cifru za brojeve od 1 do 9 (umesto 01 - 09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Jednokratno dodaje neradne dane. Molimo Vas da koristite jednu cifru za brojeve od 1 do 9 (umesto 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Trajno dodaje neradne dane za izabrani kalendar. Molimo Vas da koristite jednu cifru za brojeve od 1 do 9 (umesto 01 - 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Trajno dodaje neradne dane. Molimo Vas da koristite jednu cifru za brojeve od 1 do 9 (umesto 01 - 09).',
        'Agent Notifications' => 'Obaveštenja zaposlenima',
        'Agent interface article notification module to check PGP.' => 'Modul interfejsa operatera za obaveštavanja o članku, provera "PGP".',
        'Agent interface article notification module to check S/MIME.' =>
            'Modul interfejsa operatera za obaveštavanja o članku, provera "S/MIME"',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Modul interfejsa operatera za pristup tekstualnom pretraživanju preko navigacione trake.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Modul interfejsa operatera za pristup profilima pretraživanja preko navigacione trake.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Modul interfejsa operatera za proveru dolaznih poruka u uvećanom pregledu tiketa ako "S/MIME"-ključ postoji i dostupan je.',
        'Agent interface notification module to check the used charset.' =>
            'Modul interfejsa operatera za proveru upotrebljenog karakterseta.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Modul interfejsa operatera za obaveštavanje, pregled broja tiketa za koje je agent odgovoran.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Modul interfejsa operatera za obaveštavanje, pregled broja praćenih tiketa.',
        'Agents <-> Groups' => 'Operateri <-> Grupe',
        'Agents <-> Roles' => 'Operateri <-> Uloge',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Dozvoljava dodavanje napomena u prozor zatvorenog tiketa interfejsa operatera.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Dozvoljava dodavanje napomena u prozor slobodnog teksta interfejsa operatera.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Dozvoljava dodavanje napomena u prozor napomene interfejsa operatera.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Dozvoljava dodavanje napomena u prozor vlasnika tiketa na uvećanom prikazu u interfejsu operatera.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Dozvoljava dodavanje napomena u prozor na čekanju uvećanog prikaza u interfejsu operatera.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Dozvoljava dodavanje napomena u prozor prioriteta na uvećanom prikazu u interfejsu operatera.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Dozvoljava dodavanje napomena u prozor odgovornog za tiket interfejsa operatera.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Dozvoljava operaterima da zamene ose na statistici ako je generišu.',
        'Allows agents to generate individual-related stats.' => 'Dozvoljava operaterima da generišu individualnu statistiku.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Dozvoljava izbor između prikaza priloga u pregledaču ili samo omogućavanja njegovog preuzimanja.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Dozvoljava izbor sledećeg stanja za korisnički tiket u korisničkom interfejsu.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Dozvoljava korisnicima da promene prioritet tiketa u korisničkom interfejsu.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Dozvoljava korisnicima da podese "SLA" za tiket u korisničkom interfejsu.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Dozvoljava korisnicima da podese prioritet tiketa u korisničkom interfejsu.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Dozvoljava korisnicima da podese red tiketa u korisničkom interfejsu. Ako je podešeno na "Ne", onda treba podesiti "QueueDefault".',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Dozvoljava korisnicima da podese servis za tiket u korisničkom interfejsu.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Dozvoljava definisanje novog tipa tiketa (ako je opcije tipa tiketa aktivirana).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Dozvoljava definisanje servisa i "SLA" za tikete (npr imejl, radna površina, mreža, ...), i eskalacione atribute za "SLA" (ako je aktiviran servis/"SLA" za tiket).',
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
        'Auto Responses <-> Queues' => 'Automatski odgovori <-> Redovi',
        'Automated line break in text messages after x number of chars.' =>
            'Automatski kraj reda u tekstualnim porukama posle "x" karaktera.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automatsko zaključavanje i podešavanje vlasnika na aktuelnog operatera posle izbora masovne akcije.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Balansirani beli izgled, Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Builds an article index right after the article\'s creation.' =>
            'Generiše indeks članaka odmah po kreiranju članka.',
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
        'Change password' => 'Promena lozinke',
        'Change queue!' => 'Promena reda!',
        'Change the customer for this ticket' => 'Promeni korisnika za ovaj tiket',
        'Change the free fields for this ticket' => 'Promeni slobodna polja ovog tiketa',
        'Change the priority for this ticket' => '',
        'Change the responsible person for this ticket' => 'Promeni odgovornu osobu za ovaj tiket',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => 'Polje za potvrdu',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled. Note: no more columns are allowed and will be discarded.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Komentar za nove stavke istorijata u korisničkom interfejsu.',
        'Company Status' => '',
        'Company Tickets' => 'Tiketi firmi',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Kontroliše da li korisnici imaju mogućnost da sortiraju svoje tikete.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Konvertuje "HTML" poruke u tekstualne poruke.',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Kreira i upravlja sa "SLA".',
        'Create and manage agents.' => 'Kreiranje i upravljanje operaterima.',
        'Create and manage attachments.' => 'Kreiranje i upravljanje prilozima.',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'Kreiranje i upravljanje korisnicima.',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => 'Kreiranje i upravljanje obaveštenjima na bazi događaja.',
        'Create and manage groups.' => 'Kreiranje i upravljanje grupama.',
        'Create and manage queues.' => 'Kreiranje i upravljanje redovima.',
        'Create and manage responses that are automatically sent.' => 'Kreiranje i upravljanje automatskim odgovorima.',
        'Create and manage roles.' => 'Kreiranje i upravljanje ulogama.',
        'Create and manage salutations.' => 'Kreiranje i upravljanje pozdravima.',
        'Create and manage services.' => 'Kreiranje i upravljanje servisima.',
        'Create and manage signatures.' => 'Kreiranje i upravljanje potpisima.',
        'Create and manage templates.' => '',
        'Create and manage ticket priorities.' => 'Kreiranje i upravljanje prioritetima tiketa.',
        'Create and manage ticket states.' => 'Kreiranje i upravljanje statusima tiketa.',
        'Create and manage ticket types.' => 'Kreiranje i upravljanje tipovima tiketa.',
        'Create and manage web services.' => 'Kreiranje i upravljanje veb servisima.',
        'Create new email ticket and send this out (outbound)' => 'Otvori novi imejl tiket i pošalji ovo (odlazni)',
        'Create new phone ticket (inbound)' => 'Kreiraj novi telefonski tiket (dolazni poziv)',
        'Create new process ticket' => '',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            '',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User <-> Groups' => '',
        'Customer User <-> Services' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Korisnici',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Korisnička stavka (ikona) koja pokazuje otvorene tikete ovog korisnika kao info blok.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Korisici <-> Grupe',
        'Data used to export the search result in CSV format.' => 'Podaci upotrebljeni za ivoz rezultata pretraživanja u "CSV" formatu.',
        'Date / Time' => 'Datum / Vreme',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => 'Podrazumevane "ACL" vrednosti za akcije tiketa.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'Podrazumevani modul zaštite od petlje',
        'Default queue ID used by the system in the agent interface.' => 'Podrazumevani ID reda koji koristi sistem u interfejsu operatera.',
        'Default skin for OTRS 3.0 interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'Podrazumevani ID tiketa koji koristi sistem u interfejsu operatera.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Podrazumevani ID tiketa koji koristi sistem u korisničkom interfejsu.',
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
        'Define the start day of the week for the date picker.' => 'Definišite prvi dan u nedelji za izbor datuma.',
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
        'Defines all the X-headers that should be scanned.' => 'Određuje sva X-zaglavlja koja treba skenirati.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Određuje sve parametre za ovu stavku u korisničkim podešavanjima.',
        'Defines all the possible stats output formats.' => 'Određuje sve moguće izlazne formate statistike.',
        'Defines an alternate URL, where the login link refers to.' => 'Određuje alternativni "URL", na koji veza za prijavljivanje pokazuje.',
        'Defines an alternate URL, where the logout link refers to.' => 'Određuje alternativni "URL", na koji veza za odjavljivanje pokazuje.',
        'Defines an alternate login URL for the customer panel..' => 'Određuje alternativni "URL" prijavljivanja za korisnički panel.',
        'Defines an alternate logout URL for the customer panel.' => 'Određuje alternativni "URL" odjavljivanja za korisnički panel.',
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
            'Određuje da li porukama napisanim u interfejsu operatera treba uraditi proveru pravopisa.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Određuje da li je obračun vremena obavezan u interfejsu operatera.',
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
        'Defines the URL CSS path.' => 'Određuje "URL CSS" putanju.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Određuje "URL" osnovnu putanju za ikone, "CSS" i Java skriptove.',
        'Defines the URL image path of icons for navigation.' => 'Određuje "URL" putanju do slika za navigacione ikone.',
        'Defines the URL java script path.' => 'Određuje "URL" putanju java skriptova.',
        'Defines the URL rich text editor path.' => 'Određuje "URL" putanju do aplikacije za uređivanje "RTF" datoteka',
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
        'Defines the body text for rejected emails.' => 'Određuje sadržaj teksta za odbačene poruke.',
        'Defines the boldness of the line drawed by the graph.' => 'Određuje debljinu linija za grfikone.',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the colors for the graphs.' => 'Određuje boje za grafikone.',
        'Defines the column to store the keys for the preferences table.' =>
            'Određuje kolonu za čuvanje ključeva tabele podešavanja.',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Određuje konekcije za "http/ftp" preko posrednika.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Određuje format unosa datuma u formulare (opcija za polja za unos).',
        'Defines the default CSS used in rich text editors.' => 'Određuje podrazumevani "CSS" upotrebljen u "RTF" uređivanju.',
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
            'Određuje podrazumevani prioritet za nove korisničke tikete u korisničkom interfejsu.',
        'Defines the default priority of new tickets.' => 'Određuje podrazumevani prioritet za nove tikete.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Određuje podrazumevani red za nove korisničke tikete u korisničkom interfejsu.',
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
        'Defines the default spell checker dictionary.' => 'Određuje podrazumevani rečnik za proveru pravopisa.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => 'Određuje podrazumevani status novih tiketa.',
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
        'Defines the height of the legend.' => 'Određuje visinu legende.',
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
        'Defines the hours and week days to count the working time.' => 'Određuje sate i dane u sedmici radi kalkulacija radnog vremena.',
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
            'Određuje maksimalno vreme važenja (u sekundama) za ID sesije.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Određuje maksimalni broj strana po "PDF" datoteci.',
        'Defines the maximum size (in MB) of the log file.' => 'Određuje maksimalnu veličinu datoteke dnevnika (u megabajtima).',
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
        'Defines the module to authenticate customers.' => 'Određuje modul za autentikaciju korisnika.',
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
        'Defines the name of the key for customer sessions.' => 'Određuje naziv ključa za korisničke secije.',
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
        'Defines the spacing of the legends.' => 'Određuje razmake u legendi.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => 'Određuje standardnu veličinu "PDF" stranica.',
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
        'Defines the subject for rejected emails.' => 'Određuje temu za odbačene poruke.',
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
        'Defines the user identifier for the customer panel.' => 'Određuje identifikator korisnika za korisnički panel.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => 'Određuje važeće tipove statusa za tiket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width of the legend.' => 'Određuje širinu legende.',
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
        'Dropdown' => 'Padajući',
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
        'Email Addresses' => 'Imejl adrese',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Omogućava "S/MIME" podršku.',
        'Enables customers to create their own accounts.' => 'Omogućava korisnicima da kreiraju sopstvene naloge.',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Omogućava podrđku za proveru pravopisa.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Pregled eskalacija',
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
        'Execute SQL statements.' => 'Izvrši "SQL" naredbe.',
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
        'Filter incoming emails.' => 'Filtriranje dolaznih poruka.',
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
        'Frontend language' => '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => '',
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
        'Interface language' => 'Jezik interfejsa',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Link agents to groups.' => 'Poveži operatere sa gupama.',
        'Link agents to roles.' => 'Poveži operatere sa ulogama.',
        'Link attachments to templates.' => '',
        'Link customer user to groups.' => '',
        'Link customer user to services.' => '',
        'Link queues to auto responses.' => 'Poveži redove sa automanskim odkovorima.',
        'Link roles to groups.' => 'Poveži uloge sa grupama.',
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
        'Log file for the ticket counter.' => 'Datoteka dnevnika za brojač tiketa.',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => 'Određuje prozirnost slike.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => 'Upravljanje postojećim sesijama.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Upravljanje povremenim zadacima.',
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
        'Module to check customer permissions.' => 'Modul za proveru korisničkih dozvola.',
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
        'My Tickets' => 'Moji tiketi',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Novi imejl tiket',
        'New phone ticket' => 'Novi telefonski tiket',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Obaveštenja (Događaj)',
        'Number of displayed tickets' => 'Broj prikazanih tiketa',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Pregled eskaliralih tiketa',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => 'pregled svih otvorenih tiketa.',
        'PGP Key Management' => '',
        'PGP Key Upload' => 'Slanje "PGP" ključa',
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
        'Permitted width for compose email windows.' => 'Dozvoljena širina prozora za pisanje poruke.',
        'Permitted width for compose note windows.' => 'Dozvoljena širina prozora za pisanje napomene.',
        'Picture-Upload' => '',
        'PostMaster Filters' => '"PostMaster" filteri',
        'PostMaster Mail Accounts' => '"PostMaster" mejl nalozi',
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
        'Queue view' => 'Pregled reda',
        'Recognize if a ticket is a follow up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh Overviews after' => '',
        'Refresh interval' => 'Interval osvežavanja',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Zamenjuje oginalnog pošiljaoca sa imejl adresom aktuelnog korisnika pri kreiranju odgovora u prozoru za pisanje odgovora interfejsa operatera.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Potrebne dozvole za promenu korisnika tiketa u interfejsu operatera.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za zatvaranje tiketa u interfejsu operatera.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za odbijanje tiketa u interfejsu operatera.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za otvaranje tiketa u interfejsu operatera.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za prosleđivanje tiketa u interfejsu operatera.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora slobodnog teksta tiketa u interfejsu operatera.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za spajanje pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za napomene tiketa u interfejsu operatera.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora vlasnika tuketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora čekanja pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora telefonskog odlaznog tiketa u interfejsu operatera.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora prioriteta pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora odgovornog za tiket u interfejsu operatera.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Resetuje i otključava vlasnika tiketa ako je premešten u drugi red.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Restaurira tiket iz arhive (samo ako je događaj promena statusa od zatvorenog na bilo koji dostupan otvoreni status).',
        'Roles <-> Groups' => 'Uloge <-> Grupe',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Slanje "S/MIME" sertifikata',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search Customer' => 'Traži korisnika',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '',
        'Send notifications to users.' => 'Pošalji obaveštenja korisnicima.',
        'Send ticket follow up notifications' => '',
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
        'Set sender email addresses for this system.' => 'Sistemska adresa pošiljaoca.',
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
        'Sets the size of the statistic graph.' => 'Podešava veličinu grafikona statistike.',
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
        'Statistics' => 'Statistike',
        'Status view' => 'Pregled statusa',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'Čuva kolačiće nakon zatvaranja pretraživača.',
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
        'Ticket overview' => 'Pregled tiketa',
        'TicketNumber' => '',
        'Tickets' => 'Tiketi',
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
            'Ažuriraj oѕnaku viđenih tiketa ako su svi pregledani ili je kreiran novi članak.',
        'Update and extend your system with software packages.' => 'Ažuriraj i nadogradi sistem softverskim paketima.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Ažuriraj indeks eskalacije tiketa posle ažuriranja atributa tiketa.',
        'Updates the ticket index accelerator.' => 'Ažuriraj akcelerator indeksa tiketa.',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Pregled rezultata provere performansi.',
        'View system log messages.' => 'Pregled poruka sistemskog dnevnika.',
        'Wear this frontend skin' => 'Primeni ovaj isgled interfejsa',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Kada su tiketi spojeni, korisnik može biti informisan imejlom postavljanjem polje za potvrdu "Obavesti pošiljaoca". U prostoru za tekst, možete definisati unapred formatirani tekst koji kasnije biti modifikovan od strane operatera.',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Izabrani omiljeni redovi. Ako je aktivirano, dobiđete i obaveštenje o ovim redovima.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        ' (work units)' => ' (elementi posla)',
        'Add Customer Company' => 'Dodaj korisničku firmu',
        'Add Response' => 'Dodaj odgovor',
        'Add customer company' => 'Dodaj korisničku firmu',
        'Add response' => 'Dodaj odgovor',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Dodaje korisničke imejl adrese primaocima u prozoru za otvaranje tiketa na interfejsu operatera.',
        'Attachments <-> Responses' => 'Prilozi <-> Odgovori',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Lozinka ne može biti ažurirana. Mora da sadrži bar 2 velika i 2 mala slova.',
        'Change Attachment Relations for Response' => 'Promeni veze sa prilozima za odgovor',
        'Change Queue Relations for Response' => 'Promeni veze sa redovima za odgovor',
        'Change Response Relations for Attachment' => 'Promeni veze sa odgovorima za prilog',
        'Change Response Relations for Queue' => 'Promeni veze sa odgovorima za red',
        'Create and manage companies.' => 'Kreiranje i upravljanje firmama.',
        'Create and manage response templates.' => 'Kreiranje i upravljanje šablonima odgovora.',
        'Currently only MySQL is supported in the web installer.' => 'Trenutno je samo "MySQL" podržan u Web Instalaciji.',
        'Customer Company Management' => 'Uređivanje korisničkih firmi',
        'Customer Data' => 'Podaci o korisniku',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Korisnici su potrebni da bi mogli da imate istorijat za korisnika i da bi mogli da se prijave na klijentski portal.',
        'Customers <-> Services' => 'Korisnici <-> Servisi',
        'DB host' => 'Naziv ili adresa DB-Servera',
        'Database-User' => 'Korisnik baze podataka',
        'Default skin for interface.' => 'Podrazumevani izgled interfejsa.',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            'Određuje maksimalnu veličinu datoteka (u bajtima) za slanje.',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            'Niste pronašli potrebnu funkciju? "OTRS Group" za svoje pretplaćene korisnike ima ekskluzivne dodatke:',
        'Edit Response' => 'Uredi odgovor',
        'Escalation in' => 'Eskalacija u',
        'False' => '"False"',
        'Filter for Responses' => 'Filter za odgovore',
        'Filter name' => 'Naziv filtera',
        'For more info see:' => 'Za dodatne informacije pogledaj:',
        'From customer' => 'Od Korisnika',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Ako ste podesili "root" lozinku za vašu bazu podataka, ona mora biti uneta ovde. Ako nema lozinke ostavite polje prazno. Iz bezbednosnih razloga preporučujemo da je podesite. Za više informacija konsultujte dokumentaciju o bazi podataka.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Ako želite da instalirate "OTRS" na neki drugi sistem baze podataka, informacije su u datoteci README.database.',
        'Link attachments to responses templates.' => 'Poveži priloge sa šablonima odgovora.',
        'Link customers to groups.' => 'Poveži korisnike sa grupama.',
        'Link customers to services.' => 'Poveži korisnike sa servisima.',
        'Link responses to queues.' => 'Poveži odgovore sa redovima.',
        'Log file location is only needed for File-LogModule!' => 'Lokacija datoteke dnevnika je jedno neophodno Modulu dnevnika!',
        'Logout successful. Thank you for using OTRS!' => 'Uspešno ste se odjavili! Hvala što ste koristili "OTRS"!',
        'Manage Response-Queue Relations' => 'Upravljanje vezama Odgovor-red',
        'Manage Responses' => 'Upravljanje odgovorima',
        'Manage Responses <-> Attachments Relations' => 'Upravljanje vezama Odgovori <-> Prilozi',
        'Package verification failed!' => 'Neuspela verifikacija paketa!',
        'Password is required.' => 'Lozinka je obavezna.',
        'Please enter a search term to look for customer companies.' => 'Molimo unesite frazu za pronalaženje korisničkih firmi.',
        'Please supply a' => 'Molimo, unesite',
        'Please supply a first name' => 'Molimo, unesite Ime',
        'Please supply a last name' => 'Molimo, unesite Prezime',
        'Responses' => 'Odgovori',
        'Responses <-> Queues' => 'Odgovori <-> Redovi',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Siguran mod mora biti isključen radi reinstalacije preko "web" procedure.',
        'To customer' => 'Za korisnika',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            'Kada su tiketi spojeni, tiketu koji nije aktivan će automatski biti dodana beleška. U prostoru za tekst možete da definišete ovaj tekst (Operateri ne mogu menjati ovaj tekst).',
        'before' => 'pre',
        'default \'hot\'' => 'podrazumevano \'hot\'',
        'settings' => 'podešavanja',

    };
    # $$STOP$$
    return;
}

1;
