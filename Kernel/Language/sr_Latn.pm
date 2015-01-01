# --
# Kernel/Language/sr_Latn.pm - provides Serbian language Cyrillic translation
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
        'Done' => 'Urađeno',
        'Cancel' => 'Odustani',
        'Reset' => 'Poništi',
        'more than ... ago' => 'pre više od ...',
        'in more than ...' => 'u više od ...',
        'within the last ...' => 'poslednji',
        'within the next ...' => 'sledeći',
        'Created within the last' => 'Kreirano poslednje',
        'Created more than ... ago' => 'kreirano pre više od ...',
        'Today' => 'Danas',
        'Tomorrow' => 'Sutra',
        'Next week' => 'Sledeće nedelje',
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
        'Time unit' => 'Jedinica vremena',
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
        'Mr.' => 'G-din',
        'Mrs.' => 'G-đa',
        'Next' => 'Sledeće',
        'Back' => 'Nazad',
        'Next...' => 'Sledeće...',
        '...Back' => '...Nazad',
        '-none-' => '-ni jedan-',
        'none' => 'ni jedan',
        'none!' => 'ni jedan!',
        'none - answered' => 'ni jedan - odgovoren',
        'please do not edit!' => 'molimo, ne menjajte!',
        'Need Action' => 'Potrebna akcija',
        'AddLink' => 'Dodaj vezu',
        'Link' => 'Poveži',
        'Unlink' => 'Prekini vezu',
        'Linked' => 'Povezano',
        'Link (Normal)' => 'Veza (Normalna)',
        'Link (Parent)' => 'Veza (Roditelj)',
        'Link (Child)' => 'Veza (Dete)',
        'Normal' => 'Normalna',
        'Parent' => 'Roditelj',
        'Child' => 'Dete',
        'Hit' => 'Pogodak',
        'Hits' => 'Pogoci',
        'Text' => 'Tekst',
        'Standard' => 'Standardan',
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
        'CustomerIDs' => 'ID-evi korisnika',
        'customer' => 'korisnik',
        'agent' => 'operater',
        'system' => 'sistem',
        'Customer Info' => 'Korisnički info',
        'Customer Information' => 'Informacije o korisniku',
        'Customer Company' => 'Firma korisnika',
        'Customer Companies' => 'Firme korisnika',
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
        'change!' => 'promeni!',
        'Change' => 'Promeni',
        'change' => 'promeni',
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
        'Created by' => 'Kreirao',
        'Changed' => 'Izmenjeno',
        'Changed by' => 'Izmenio',
        'Search' => 'Traži',
        'and' => 'i',
        'between' => 'između',
        'before/after' => 'pre/posle',
        'Fulltext Search' => 'Tekst za pretragu',
        'Data' => 'Podaci',
        'Options' => 'Opcije',
        'Title' => 'Naslov',
        'Item' => 'Stavka',
        'Delete' => 'Izbrisati',
        'Edit' => 'Urediti',
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
        'Small' => 'Malo',
        'Medium' => 'Srednje',
        'Large' => 'Veliko',
        'Date picker' => 'Izbor datuma',
        'Show Tree Selection' => 'Prikaži drvo selekcije',
        'The field content is too long!' => 'Sadržaj polja je predugačak',
        'Maximum size is %s characters.' => 'Maksimalna veličina je %s karaktera',
        'This field is required or' => 'Ovo polje je obavezno ili',
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
        'Word' => 'Reč',
        'Ignore' => 'Zanemari',
        'replace with' => 'zameni sa',
        'There is no account with that login name.' => 'Ne postoji nalog sa tim imenom za prijavu.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Neuspešna prijava! Netačno je uneto vaše korisničko ime ili lozinka.',
        'There is no acount with that user name.' => 'Nema naloga sa tim korisničkim imenom',
        'Please contact your administrator' => 'Molimo kontaktirajte vašeg administratora',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            '',
        'Logout' => 'Odjava',
        'Logout successful. Thank you for using %s!' => 'Uspešno ste se odjavili! Hvala što ste koristili %s!',
        'Feature not active!' => 'Funkcija nije aktivna!',
        'Agent updated!' => 'Ažuriran operater',
        'Database Selection' => 'Selekcija baze podataka',
        'Create Database' => 'Kreiraj bazu podataka',
        'System Settings' => 'Sistemska podešavanja',
        'Mail Configuration' => 'Podešavanje mail',
        'Finished' => 'Završeno',
        'Install OTRS' => 'Instaliraj OTRS',
        'Intro' => 'Uvod',
        'License' => 'Licenca',
        'Database' => 'Baza podataka',
        'Configure Mail' => 'Podesi mail',
        'Database deleted.' => 'Obrisana baza podataka.',
        'Enter the password for the administrative database user.' => 'Unesi lozinku za korisnika administrativne baze podataka.',
        'Enter the password for the database user.' => 'Unesi lozinku za korisnika baze podataka.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Ako ste postavili root lozinku za vašu bazu podataka, ona mora biti uneta ovde. Ako niste, ovo polje ostavite prazno.',
        'Database already contains data - it should be empty!' => 'Baza podataka već sadrži podatke - trebalo bi da bude prazna.',
        'Login is needed!' => 'Potrebna je prijava!',
        'Password is needed!' => 'Potrebna je lozinka!',
        'Take this Customer' => 'Uzmi ovog korisnika',
        'Take this User' => 'Uzmi ovog korisnika sistema',
        'possible' => 'moguće',
        'reject' => 'odbaci',
        'reverse' => 'obrnuto',
        'Facility' => 'Instalacija',
        'Time Zone' => 'Vremenska zona',
        'Pending till' => 'Na čekanju do',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Ne koristite "Superuser" nalog za rad sa OTRS! Napravite nove naloge za zaposlene i koristite njih.',
        'Dispatching by email To: field.' => 'Otpremanje putem polja Za: e-mail-a.',
        'Dispatching by selected Queue.' => 'Otpremanje putem izabranog reda.',
        'No entry found!' => 'Unos nije pronađen!',
        'Session invalid. Please log in again.' => 'Sesija je nevažeća. Molimo prijavite se ponovo.',
        'Session has timed out. Please log in again.' => 'Vreme sesije je isteklo. Molimo prijavite se ponovo.',
        'Session limit reached! Please try again later.' => 'Sesija je istekla! Molimo pokušajte kasnije!',
        'No Permission!' => 'Nemate dozvolu!',
        '(Click here to add)' => '(Klikni ovde za dodavanje)',
        'Preview' => 'Pregled',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Paket nije korektno instaliran! Instalirajte ga ponovo.',
        '%s is not writable!' => 'Ne može se upisivati na %s!',
        'Cannot create %s!' => 'Ne može se kreirati %s!',
        'Check to activate this date' => 'Proverite za aktiviranje ovog datuma',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Aktivirana je opcija "Van kancelarije", želite li da je isključite?',
        'News about OTRS releases!' => 'Vesti o OTRS izdanjima!',
        'Customer %s added' => 'Dodat korisnik %s.',
        'Role added!' => 'Dodata uloga!',
        'Role updated!' => 'Ažurirana uloga!',
        'Attachment added!' => 'Dodat prilog!',
        'Attachment updated!' => 'Ažuriran prilog!',
        'Response added!' => 'Dodat odgovor!',
        'Response updated!' => 'Ažuriran odgovor!',
        'Group updated!' => 'Ažurirana grupa!',
        'Queue added!' => 'Dodat red!',
        'Queue updated!' => 'Ažuriran red!',
        'State added!' => 'Dodat status!',
        'State updated!' => 'Ažuriran status!',
        'Type added!' => 'Dodat tip!',
        'Type updated!' => 'Ažuriran tip!',
        'Customer updated!' => 'Ažuriran korisnik!',
        'Customer company added!' => 'Dodata firma korisnika!',
        'Customer company updated!' => 'Ažurirana firma korisnika!',
        'Note: Company is invalid!' => 'Napomena: kompanija je neveažeća!',
        'Mail account added!' => 'Dodat mail nalog!',
        'Mail account updated!' => 'Ažuriran mail nalog!',
        'System e-mail address added!' => 'Dodata sistemska e-mail adresa!',
        'System e-mail address updated!' => 'Ažurirana sistemska e-mail adresa!',
        'Contract' => 'Ugovor',
        'Online Customer: %s' => 'Korisnik na vezi: %s',
        'Online Agent: %s' => 'Operater na vezi: %s',
        'Calendar' => 'Kalendar',
        'File' => 'Datoteka',
        'Filename' => 'Naziv datoteke',
        'Type' => 'Tip',
        'Size' => 'Veličina',
        'Upload' => 'Otpremanje',
        'Directory' => 'Direktorijum',
        'Signed' => 'Potpisano',
        'Sign' => 'Potpis',
        'Crypted' => 'Šifrovano',
        'Crypt' => 'Šifra',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP Ključ',
        'PGP Keys' => 'PGP ključevi',
        'S/MIME' => 'S/MIME ključ',
        'S/MIME Certificate' => 'S/MIME Sertifikat',
        'S/MIME Certificates' => 'S/MIME Sertifikati',
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
        'Unable to parse repository index document.' => 'Nije moguće raščlaniti spremište indeksa dokumenta.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Nema paketa za verziju vašeg sistema, u spremištu su samo paketi za druge verzije.',
        'No packages, or no new packages, found in selected repository.' =>
            'U izabranom spremištu nema paketa ili nema novih paketa.',
        'Edit the system configuration settings.' => 'Uredi podešavanja sistemske konfiguracije.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL informacije iz baze podataka nisu sinhronizovane sa sistemskom konfiguracijom, molimo vas da upotrebite sve ACL liste.',
        'printed at' => 'štampano u',
        'Loading...' => 'Učitavanje...',
        'Dear Mr. %s,' => 'Poštovani g-dine %s,',
        'Dear Mrs. %s,' => 'Poštovana g-đo %s,',
        'Dear %s,' => 'Dragi %s,',
        'Hello %s,' => 'Zdravo %s,',
        'This email address already exists. Please log in or reset your password.' =>
            'Ova e-mail adresa već postoji. Molimo, prijavite se ili resetujte vašu lozinku.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Kreiran novi nalog. Podaci za prijavu poslati %s. Molimo proverite vaš e-mail.',
        'Please press Back and try again.' => 'Molimo pritisnite Nazad i pokušajte ponovo.',
        'Sent password reset instructions. Please check your email.' => 'Uputstvo za reset lozinke je poslato. Molimo proverite vaš e-mail.',
        'Sent new password to %s. Please check your email.' => 'Poslata nova lozinka za %s. Proverite vaš e-mail',
        'Upcoming Events' => 'Predstojeći događaji',
        'Event' => 'Događaj',
        'Events' => 'Događaji',
        'Invalid Token!' => 'Neispravan token!',
        'more' => 'još',
        'Collapse' => 'Smanji',
        'Shown' => 'Prikazan',
        'Shown customer users' => 'Prikazani korisnici korisnika',
        'News' => 'Novosti',
        'Product News' => 'Novosti o proizvodu',
        'OTRS News' => 'OTRS novosti',
        '7 Day Stats' => 'Sedmodnevna statistika',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Obrađene informacije iz baze bodataka nisu sinhronizovane sa sistemskom konfiguracijom, molimo vas da sinhronizujete sve procese.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Paket nije verifikovan od strane OTRS Group! Preporučuje se da ne koristite ovaj paket.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '<br>Ako nastavite da instalirate ovaj paket, mogu se javiti sledeći problemi!<br><br>&nbsp;-Bezbednosni problemi<br>&nbsp;-Problemi stabilnosti<br>&nbsp;-Problemi u performansama<br><br>Napominjemo da problemi nastali usled rada sa ovim paketom nisu pokriveni OTRS servisnim ugovorom!<br><br>',
        'Mark' => 'Označeno',
        'Unmark' => 'Neoznačeno',
        'Bold' => 'Podebljano',
        'Italic' => 'Kurziv',
        'Underline' => 'Podvučeno',
        'Font Color' => 'Boja slova',
        'Background Color' => 'Boja pozadine',
        'Remove Formatting' => 'Ukloni formatiranje',
        'Show/Hide Hidden Elements' => 'Pokaži/Sakrij skrivene elemente',
        'Align Left' => 'Poravnaj na levo',
        'Align Center' => 'Centriraj',
        'Align Right' => 'Poravnaj na desno',
        'Justify' => 'Poravnaj u blok',
        'Header' => 'Naslov',
        'Indent' => 'Uvlačenje',
        'Outdent' => 'Izvlačenje',
        'Create an Unordered List' => 'Napravi nesređenu listu',
        'Create an Ordered List' => 'Napravi sređenu listu',
        'HTML Link' => 'HTML Veza',
        'Insert Image' => 'Ubaci sliku',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Poništi',
        'Redo' => 'Ponovi',
        'Scheduler process is registered but might not be running.' => 'Planer proces je registrovan, ali možda nije pokrenut.',
        'Scheduler is not running.' => 'Planer ne radi.',
        'Can\'t contact registration server. Please try again later.' => 'Ne možete da kontaktirate server za registraciju. Molimo pokušajte ponovo kasnije.',
        'No content received from registration server. Please try again later.' =>
            'Sadržaj nije primljen od servera za registraciju. Molimo pokušajte ponovo kasnije.',
        'Problems processing server result. Please try again later.' => 'Problemi u obradi rezultata servera. Molimo pokušajte ponovo kasnije.',
        'Username and password do not match. Please try again.' => 'Korisničko ime i lozinka se ne poklapaju. Molimo pokušajte ponovo.',
        'The selected process is invalid!' => 'Označeni proces je nevažeći!',

        # Template: AAACalendar
        'New Year\'s Day' => 'Nova godina',
        'International Workers\' Day' => 'Međunarodni praznik rada',
        'Christmas Eve' => 'Badnje veče',
        'First Christmas Day' => 'Prvi dan Božića',
        'Second Christmas Day' => 'Drugi dan Božića',
        'New Year\'s Eve' => 'Doček nove godine',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS kao naručioc',
        'OTRS as provider' => 'OTRS kao pružaoc usluga',
        'Webservice "%s" created!' => 'Web servis "%s" kreiran',
        'Webservice "%s" updated!' => 'Web servis "%s" ažuriran',

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
        'June' => 'jun',
        'July' => 'jul',
        'August' => 'avgust',
        'September' => 'septembar',
        'October' => 'oktobar',
        'November' => 'novembar',
        'December' => 'decembar',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Podešavanja su uspešno ažurirana!',
        'User Profile' => 'Korisnički profil',
        'Email Settings' => 'E-mail podešavanja',
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
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Lozinka ne može biti ažurirana. Mora da sadrži minimalno 2 velika i 2 mala slova.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Lozinka ne može biti ažurirana. Mora da sadrži najnmanje jednu brojku.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Lozinka ne može biti ažurirana. Mora da sadrži najmanje 2 znaka.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Lozinka ne može biti ažurirana. Uneta lozinka je već u upotrebi. Molimo izaberite neku drugu.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Izaberite separator koji će se koristi u CSV datotekama (statistika i pretrage). Ako ovde ne izaberete separator, koristiće se podrazumevani separator za vaš jezik',
        'CSV Separator' => 'CSV separator',

        # Template: AAAStats
        'Stat' => 'Statistika',
        'Sum' => 'Suma',
        'Days' => 'Dani',
        'No (not supported)' => 'Ne (nije podržano)',
        'Please fill out the required fields!' => 'Molimo da popunite obavezna polja!',
        'Please select a file!' => 'Molimo da odaberete datoteku!',
        'Please select an object!' => 'Molimo da odaberete objekat!',
        'Please select a graph size!' => 'Molimo da odaberete veličinu grafikona!',
        'Please select one element for the X-axis!' => 'Molimo da izaberete jedan element za X-osu!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Izaberite samo jedan element ili isključite dugme \'Fixed\' gde je izabrano polje označeno!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Ako koristite oznake selekcije, morate da izaberete neke atribute selektovanog polja!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Molimo da unesete vrednost u izabrano polje ili isključite polje \'Fixed\'!',
        'The selected end time is before the start time!' => 'Izabrano vreme kraja je pre vremena početka!',
        'You have to select one or more attributes from the select field!' =>
            'Morate da izaberete jedan ili više atributa iz selektovanog polja!',
        'The selected Date isn\'t valid!' => 'Datum koji ste izabrali nije važeći!',
        'Please select only one or two elements via the checkbox!' => 'Molimo da izaberete samo jedan ili dva elementa preko polja za potvrdu!',
        'If you use a time scale element you can only select one element!' =>
            'Ukoliko koristite element vremenske skale, možete izabrati samo jedan element!',
        'You have an error in your time selection!' => 'Imate grešku u vašem izboru vremena!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Vaš interval izveštavanja je prekratak, molimo upotrebite veći raspon vremena!',
        'The selected start time is before the allowed start time!' => 'Izabrano vreme početka je pre dozvoljenog početnog vremena!',
        'The selected end time is after the allowed end time!' => 'Izabrano vreme kraja je posle dozvoljenog vremena kraja!',
        'The selected time period is larger than the allowed time period!' =>
            'Izabrani vremenski period je duži od dozvoljenog!',
        'Common Specification' => 'Opšte informacije',
        'X-axis' => 'X-Osa',
        'Value Series' => 'Opsezi',
        'Restrictions' => 'Ograničenja',
        'graph-lines' => 'Linijski grafikon',
        'graph-bars' => 'Stubičasi grafikon',
        'graph-hbars' => 'Horizontalni stubičasti grafikon',
        'graph-points' => 'Tačkasti grafikon',
        'graph-lines-points' => 'Linijsko-tačkasti grafikon',
        'graph-area' => 'Oblast grafikona',
        'graph-pie' => 'Grafikon pita',
        'extended' => 'proširen',
        'Agent/Owner' => 'Operater/Vlasnik',
        'Created by Agent/Owner' => 'Kreirao Operater/Vlasnik',
        'Created Priority' => 'Napravljeni prioritet',
        'Created State' => 'Kreiran status',
        'Create Time' => 'Vreme kreiranja',
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

        # Template: AAASupportDataCollector
        'Unknown' => 'Nepoznato',
        'Information' => 'Informacija',
        'OK' => 'U redu',
        'Problem' => 'Problem',
        'Webserver' => 'Webserver',
        'Operating System' => 'Operativni sistem',
        'OTRS' => 'OTRS',
        'Table Presence' => 'Prisustvo tabele',
        'Internal Error: Could not open file.' => 'Interna greška: Nije moguće otvoriti datoteku.',
        'Table Check' => 'Provera tabele',
        'Internal Error: Could not read file.' => 'Interna greška: Nije moguće pročitati datoteku.',
        'Tables found which are not present in the database.' => 'Pronađene tabele koje nisu prisutne u bazi podataka.',
        'Database Size' => 'Veličina baze podataka',
        'Could not determine database size.' => 'Nije moguće utvrditi veličinu baze podataka.',
        'Database Version' => 'Verzija baze podataka',
        'Could not determine database version.' => 'Nije moguće utvrditi verziju baze podataka',
        'Client Connection Charset' => 'Karakterset za povezivanje klijenta',
        'Setting character_set_client needs to be utf8.' => 'Podešavanje character_set_client mora biti utf8.',
        'Server Database Charset' => 'Karakterset serverske baze podataka',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'Podešavanje character_set_database mora biti UNICODE ili UTF8.',
        'Table Charset' => 'Tabela karakterseta',
        'There were tables found which do not have utf8 as charset.' => '',
        'Maximum Query Size' => 'Maksimalna veličina upita',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'Podešavanje \'max_allowed_packet\' mora biti veće od 20 MB.',
        'Query Cache Size' => 'Veličina keš upita',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Podešavanje \'query_cache_size\' mora biti korišćeno (veće od 10 MB, ali ne više od 512 MB)',
        'Default Storage Engine' => 'Osnovni mehanizam za skladištenje',
        'Tables with a different storage engine than the default engine were found.' =>
            'Pronađene su tabele sa različitim mehanizmom za skladištenje nego što je predefinisani mehanizam.',
        'Table Status' => 'Status tabele',
        'Tables found which do not have a regular status.' => 'Pronađene su tabele koje nemaju regularni status.',
        'MySQL 5.x or higher is required.' => 'Preporučeno je MySQL 5.x ili više.',
        'NLS_LANG Setting' => 'NLS_LANG podešavanje',
        'NLS_LANG must be set to utf8 (e.g. german_germany.utf8).' => 'NLS_LANG mora biti podešeno na utf8 (npr. german_germany.utf8)',
        'NLS_DATE_FORMAT Setting' => 'NLS_DATE_FORMAT podešavanje',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => 'NLS_DATE_FORMAT mora biti podešen na \'YYYY-MM-DD HH24:MI:SS\'.',
        'NLS_DATE_FORMAT Setting SQL Check' => 'SQL provera NLS_DATE_FORMAT podešavanja',
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Podešavanje client_encoding mora biti UNICODE ili UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Podešavanje server_encoding mora biti UNICODE ili UTF8.',
        'Date Format' => 'Format datuma',
        'Setting DateStyle needs to be ISO.' => 'Podešavanje DateStyle mora biti ISO',
        'PostgreSQL 8.x or higher is required.' => 'Preporučeno je PostgreSQL 8.x ili više.',
        'OTRS Disk Partition' => 'OTRS particija na disku',
        'Disk Partitions Usage' => 'Korišćenje particije na disku',
        'Distribution' => 'Raspodela',
        'Could not determine distribution.' => 'Nije moguće utvrditi raspodelu.',
        'Kernel Version' => 'Kernel verzija',
        'Could not determine kernel version.' => 'Nije moguće utvrditi kernel verziju',
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',
        'Perl Modules' => 'Perl moduli',
        'Not all required Perl modules are correctly installed.' => 'Svi zahtevani Perl moduli nisu korektno instalirani.',
        'Perl Version' => 'Perl verzija',
        'Free Swap Space (%)' => 'Slobodni Swap prostor (%)',
        'No Swap Enabled.' => 'Swap nije dostupan.',
        'Used Swap Space (MB)' => 'Upotrebljen Swap prostor(MB)',
        'There should be more than 60% free swap space.' => 'Mora postojati više od 60 % slobodnog swap prostora',
        'There should be no more than 200 MB swap space used.' => 'Ne treba da bude više od 200 MB upotrebljenog swap prostora.',
        'Config Settings' => 'Podešavanja konfiguracije',
        'Could not determine value.' => 'Nije moguće utvrditi vrednost.',
        'Database Records' => 'Zapisi u bazi podataka',
        'Tickets' => 'Tiketi',
        'Ticket History Entries' => 'Istorija unosa tiketa',
        'Articles' => 'Članci',
        'Attachments (DB, Without HTML)' => 'Prilozi (baza podataka, bez HTML)',
        'Customers With At Least One Ticket' => 'Korisnici sa najmanje jednim tiketom',
        'Queues' => 'Redovi',
        'Agents' => 'Operateri',
        'Roles' => 'Uloge',
        'Groups' => 'Grupe',
        'Dynamic Fields' => 'Dinamička polja',
        'Dynamic Field Values' => 'Vrednosti dinamičkog polja',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => 'GenericInterface web servis',
        'Processes' => 'Procesi',
        'Months Between First And Last Ticket' => 'Meseci između prvog i poslednjeg tiketa',
        'Tickets Per Month (avg)' => 'Tiketi mesečno (prosečno)',
        'Default SOAP Username and Password' => 'Predefinisano SOAP korisničko ime i lozinka',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            'Sigurnosni rizik: koristite podrazumevana podešavanja za SOAP::User i SOAP::Password. Molimo promenite ga.',
        'Default Admin Password' => 'Predefinisana lozinka administratora',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            'Sigurnosni rizik: agent nalog root@localhost još uvek ima predefinisanu lozinku. Molimo promenite je ili poništite nalog.',
        'Error Log' => 'Greška u prijavi',
        'There are error reports in your system log.' => 'Postoje izveštaji o greškama u vašem pristupnom sistemu.',
        'File System Writable' => 'Omogućeno pisanje u sistem datoteka.',
        'The file system on your OTRS partition is not writable.' => 'Nije moguće pisanje u sistem datoteka na vašoj OTRS particiji.',
        'Domain Name' => 'Naziv domena',
        'Your FQDN setting is invalid.' => 'Vaša FQDN podešavanja su nevažeća.',
        'Package installation status' => 'Status instaliranja paketa',
        'Some packages are not correctly installed.' => 'Neki paketi nisu ispravno instalirani.',
        'Package List' => 'Lista paketa',
        'SystemID' => 'Sistemski ID',
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Vaša SystemID podešavanja su nevažeća, treba da sadrže samo cifre.',
        'OTRS Version' => 'OTRS verzija',
        'Ticket Index Module' => 'Tiket indeks modul',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Imate više od 60.000 tiketa i treba da koristite StaticDB. Pogledajte administratorsko uputstvo (Podešavanje performansi) za više informacija.',
        'Open Tickets' => 'Otvoreni tiketi',
        'You should not have more than 8,000 open tickets in your system.' =>
            'Ne treba da imate više od 8.000 otvorenih tiketa u sistemu.',
        'Ticket Search Index module' => 'Modul za indeksnu pretragu tiketa',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Imate više od 50.000 članaka i treba da koristite StaticDB. Pogledajte administratorsko uputstvo (Podešavanje performansi) za više informacija.',
        'Orphaned Records In ticket_lock_index Table' => 'Napušteni zapisi u ticket_lock_index tabeli',
        'Table ticket_lock_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'Tabela ticket_lock_index sadrži napuštene zapise. Molimo pokrenite otrs/bin/otrs.CleanTicketIndex.pl da obrišete StaticDB indeks.',
        'Orphaned Records In ticket_index Table' => 'Napušteni zapisi u ticket_index tabeli',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            'Tabela ticket_index sadrži napuštene zapise. Molimo pokrenite otrs/bin/otrs.CleanTicketIndex.pl da obrišete StaticDB indeks.',
        'Environment Variables' => 'Promenljive iz okruženja',
        'Webserver Version' => 'Webserver verzija',
        'Could not determine webserver version.' => 'Ne može da prepozna webserver verziju.',
        'Loaded Apache Modules' => '',
        'CGI Accelerator Usage' => 'Upotreba CGI Accelerator',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            'Za povećanje performansi treba da koristite FastCGI ili mod_perl.',
        'mod_deflate Usage' => 'Upotreba mod_deflate',
        'Please install mod_deflate to improve GUI speed.' => 'Molimo instalirajte mod_deflate da povećate brzinu GUI.',
        'mod_headers Usage' => 'Upotreba mod_headers',
        'Please install mod_headers to improve GUI speed.' => 'Molimo instalirajte mod_headers da povećate brzinu GUI',
        'Apache::Reload Usage' => 'Upotreba Apache::Reload',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            'Apache::Reload ili Apache2::Reload se koriste kao Perl modul i PerlInitHandler radi zaštite od restartovanja web servera tokom instaliranja ili nadogradnje modula.',
        'Apache::DBI Usage' => 'Upotreba Apache::DBI',
        'Apache::DBI should be used to get a better performance  with pre-established database connections.' =>
            'Apache::DBI se koristi za postizanje boljih performansi sa unapred ustanovljenim konekcjama baze podataka.',
        'You should use PerlEx to increase your performance.' => 'Za povećanje performansi treba da koristite PerlEx.',

        # Template: AAATicket
        'Status View' => 'Pregled statusa',
        'Bulk' => 'Masovno',
        'Lock' => 'Zaključaj',
        'Unlock' => 'Otključaj',
        'History' => 'Istorija',
        'Zoom' => 'Uvećaj',
        'Age' => 'Starost',
        'Bounce' => 'Preusmeri',
        'Forward' => 'Prosledi',
        'From' => 'Od',
        'To' => 'Za',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Predmet',
        'Move' => 'Premesti',
        'Queue' => 'Red',
        'Priority' => 'Prioritet',
        'Priorities' => 'Prioriteti',
        'Priority Update' => 'Ažuriranje prioriteta',
        'Priority added!' => 'Dodat prioritet!',
        'Priority updated!' => 'Ažuriran prioritet!',
        'Signature added!' => 'Dodat potpis!',
        'Signature updated!' => 'Ažuriran potpis!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Sporazum o nivou usluge',
        'Service Level Agreements' => 'Sporazumi o nivou usluge',
        'Service' => 'Usluga',
        'Services' => 'Usluge',
        'State' => 'Stanje',
        'States' => 'Stanja',
        'Status' => 'Status',
        'Statuses' => 'Statusi',
        'Ticket Type' => 'Tip tiketa',
        'Ticket Types' => 'Tipovi tiketa',
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
        'Email' => 'Email',
        'email' => 'email',
        'Close' => 'Zatvori',
        'Action' => 'Akcija',
        'Attachment' => 'Prilog',
        'Attachments' => 'Prilozi',
        'This message was written in a character set other than your own.' =>
            'Ova poruka je napisana skupom znakova različitim od onog koji vi koristite.',
        'If it is not displayed correctly,' => 'Ako nije ispravno prikazano,',
        'This is a' => 'Ovo je',
        'to open it in a new window.' => 'za otvaranje u novom prozoru.',
        'This is a HTML email. Click here to show it.' => 'Ovo je HTML email. Klikni ovde za prikaz.',
        'Free Fields' => 'Slobodna polja',
        'Merge' => 'Spoji',
        'merged' => 'spojeno',
        'closed successful' => 'uspešno zatvaranje',
        'closed unsuccessful' => 'neuspešno zatvaranje',
        'Locked Tickets Total' => 'Ukupno zaključnih tiketa',
        'Locked Tickets Reminder Reached' => 'Dostignut podsetnik zaključanih tiketa',
        'Locked Tickets New' => 'Novi zaključani tiketi',
        'Responsible Tickets Total' => 'Ukupno odgovornih tiketa',
        'Responsible Tickets New' => 'Novi odgovorni tiketi',
        'Responsible Tickets Reminder Reached' => 'Dostignut podsetnik odgovornih tiketa',
        'Watched Tickets Total' => 'Ukupno praćenih tiketa',
        'Watched Tickets New' => 'Novi praćeni tiketi',
        'Watched Tickets Reminder Reached' => 'Dostignut podsetnik praćenih tiketa',
        'All tickets' => 'Svi tiketi',
        'Available tickets' => 'Slobodni tiketi',
        'Escalation' => 'Eskalacija',
        'last-search' => 'poslednja pretraga',
        'QueueView' => 'Pregled reda',
        'Ticket Escalation View' => 'Eskalacioni pregled tiketa',
        'Message from' => 'Poruka od',
        'End message' => 'Kraj poruke',
        'Forwarded message from' => 'Prosleđena poruka od',
        'End forwarded message' => 'Kraj prosleđene poruke',
        'Bounce Article to a different mail address' => 'Preusmeravanje članka na drugu email adresu',
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
        'email-external' => 'email-eksterni',
        'email-internal' => 'email-interni',
        'note-external' => 'napomena-eksterna',
        'note-internal' => 'napomena-interna',
        'note-report' => 'napomena-izveštaj',
        'phone' => 'telefon',
        'sms' => 'SMS',
        'webrequest' => 'web zahtev',
        'lock' => 'zaključan',
        'unlock' => 'otključan',
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
        'auto reject' => 'automatsko odbacivanje',
        'auto remove' => 'automatsko uklanjanje',
        'auto reply' => 'automatski odgovor',
        'auto reply/new ticket' => 'automatski odgovor/novi tiket',
        'Create' => 'Kreiraj',
        'Answer' => 'Odgovor',
        'Phone call' => 'Telefonski poziv',
        'Ticket "%s" created!' => 'Tiket "%s" kreiran!',
        'Ticket Number' => 'Broj tiketa',
        'Ticket Object' => 'Objekat tiketa',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ne postoji tiket broj "%s"! Ne može se povezati!',
        'You don\'t have write access to this ticket.' => 'Nemate pravo upisa u ovaj tiket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Na žalost, morate biti vlasnik tiketa za ovu akciju.',
        'Please change the owner first.' => 'Molimo prvo promenite vlasnika.',
        'Ticket selected.' => 'Izabran tiket.',
        'Ticket is locked by another agent.' => 'Tiket je zaključan od strane drugog operatera.',
        'Ticket locked.' => 'Zaključan tiket.',
        'Don\'t show closed Tickets' => 'Ne prikazuj zatvorene tikete',
        'Show closed Tickets' => 'Prikaži zatvorene tikete',
        'New Article' => 'Novi članak',
        'Unread article(s) available' => 'Raspoliživi nepročitani članci',
        'Remove from list of watched tickets' => 'Ukloni sa liste praćenih tiketa',
        'Add to list of watched tickets' => 'Dodaj na listu praćenih tiketa',
        'Email-Ticket' => 'Email-Tiket',
        'Create new Email Ticket' => 'Kreira novi Email tiket',
        'Phone-Ticket' => 'Telefonski tiket',
        'Search Tickets' => 'Traženje tiketa',
        'Edit Customer Users' => 'Uredi korisnike korisnika',
        'Edit Customer Company' => 'Uredi firmu korisnika',
        'Bulk Action' => 'Masovna akcija',
        'Bulk Actions on Tickets' => 'Masovne akcije na tiketima',
        'Send Email and create a new Ticket' => 'Pošanji Email i kreiraj novi tiket',
        'Create new Email Ticket and send this out (Outbound)' => 'Otvori novi Email tiket i pošalji ovo (odlazni)',
        'Create new Phone Ticket (Inbound)' => 'Kreiraj novi telefonski tiket (dolazni poziv)',
        'Address %s replaced with registered customer address.' => 'Adresa %s je zamenjena registrovnom adresom korisnika.',
        'Customer user automatically added in Cc.' => 'Korisnik se automatski dodaje u Cc.',
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
        'Show the ticket history' => 'Prikaži istoriju tiketa',
        'Print this ticket' => 'Odštampaj ovaj tiket',
        'Print this article' => 'Odštampaj ovaj članak',
        'Split' => 'Podeli',
        'Split this article' => 'Podeli ovaj članak',
        'Forward article via mail' => 'Prosledi članak putem mail-a',
        'Change the ticket priority' => 'Promeni prioritet tiketa',
        'Change the ticket free fields!' => 'Promeni slobodna polja tiketa',
        'Link this ticket to other objects' => 'Uveži ovaj tiket sa drugim objektom',
        'Change the owner for this ticket' => 'Promeni vlasnika ovog tiketa',
        'Change the  customer for this ticket' => 'Promeni korisnika ovog tiketa',
        'Add a note to this ticket' => 'Dodaj napomenu ovom tiketu',
        'Merge into a different ticket' => 'Pripoji različitom tiketu',
        'Set this ticket to pending' => 'Postavi ovaj tiket u status čekanja',
        'Close this ticket' => 'Zatvori ovaj tiket',
        'Look into a ticket!' => 'Pogledaj sadržaj tiketa!',
        'Delete this ticket' => 'Obrišite ovaj tiket',
        'Mark as Spam!' => 'Označi kao Spam!',
        'My Queues' => 'Moji redovi',
        'Shown Tickets' => 'Prikazani tiketi',
        'Shown Columns' => 'Prikazane kolone',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Vaš email sa brojem tiketa "<OTRS_TICKET>" je spojen sa tiketom "<OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' => 'Tiket %s: vreme odziva je preko (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Tiket %s: vreme odziva ističe za %s!',
        'Ticket %s: update time is over (%s)!' => 'Tiket %s: vreme ažuriranja je preko (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Tiket %s: vreme ažuriranja ističe za %s!',
        'Ticket %s: solution time is over (%s)!' => 'Tiket %s: vreme rešavanja je preko (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Tiket %s: vreme rešavanja ističe za %s!',
        'There are more escalated tickets!' => 'Ima još eskaliralih tiketa!',
        'Plain Format' => 'Neformatiran format',
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
            'Pošalji mi obaveštenje ako sistem otključa tiket.',
        'Send ticket lock timeout notifications' => 'Pošalji obaveštenje o isteku zaključavanja tiketa',
        'Ticket move notification' => 'Obaveštenje o pomeranju tiketa',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Pošalji mi obaveštenje kad se tiket premesti u "Moje Redove".',
        'Send ticket move notifications' => 'Pošalji obaveštenje o pomeranju tiketa',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Izabrani omiljeni redovi. Ako je aktivirano, dobićete i obaveštenje o ovim redovima.',
        'Custom Queue' => 'Prilagođen red',
        'QueueView refresh time' => 'Vreme osvežavanja reda',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Ako je uključeno, pregled reda će biti osvežen posle zadatog vremena.',
        'Refresh QueueView after' => 'Osveži pregled reda posle',
        'Screen after new ticket' => 'Prikaz ekrana posle otvaranja novog tiketa',
        'Show this screen after I created a new ticket' => 'Prikaži ovaj ekran posle otvaranja novog tiketa',
        'Closed Tickets' => 'Zatvoreni tiketi',
        'Show closed tickets.' => 'Prikaži zatvorene tikete.',
        'Max. shown Tickets a page in QueueView.' => 'Maksimalni broj prikazanih tiketa u pregledu reda.',
        'Ticket Overview "Small" Limit' => 'Ograničenje pregleda tiketa - "malo"',
        'Ticket limit per page for Ticket Overview "Small"' => 'Ograničenje tiketa po strani za pregled - "malo"',
        'Ticket Overview "Medium" Limit' => 'Ograničenje pregleda tiketa - "srednje"',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Ograničenje tiketa po strani za pregled - "srednje"',
        'Ticket Overview "Preview" Limit' => 'Ograničenje pregleda tiketa - "Preview"',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Ograničenje tiketa po strani za pregled - "Preview"',
        'Ticket watch notification' => 'Obaveštenje o praćenju tiketa',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Pošalji mi isto obaveštenje za praćene tikete koje će dobiti vlasnik.',
        'Send ticket watch notifications' => 'Pošalji obaveštenje o praćenju tiketa',
        'Out Of Office Time' => 'Vreme van kancelarije',
        'New Ticket' => 'Novi tiket',
        'Create new Ticket' => 'Napravi novi tiket',
        'Customer called' => 'Pozvani korisnik',
        'phone call' => 'telefonski poziv',
        'Phone Call Outbound' => 'Odlazni telefonski poziv',
        'Phone Call Inbound' => 'Dolazni telefonski poziv',
        'Reminder Reached' => 'Dostignut podsetnik',
        'Reminder Tickets' => 'Tiketi podsetnika',
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
        'Ticket Information' => 'Informacije o tiketu',
        'History::Move' => 'Tiket premešten u red "%s" (%s) iz reda "%s" (%s).',
        'History::TypeUpdate' => 'Ažuriran tip "%s" (ID=%s).',
        'History::ServiceUpdate' => 'Ažuriran servis "%s" (ID=%s).',
        'History::SLAUpdate' => 'Ažuriran SLA "%s" (ID=%s).',
        'History::NewTicket' => 'Novi tiket [%s] otvoren (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Nastavak za [%s]. %s',
        'History::SendAutoReject' => 'Automatski odbijeno "%s".',
        'History::SendAutoReply' => 'Poslat automatski odgovor za "%s".',
        'History::SendAutoFollowUp' => 'Automatski nastavak za "%s".',
        'History::Forward' => 'Prosleđeno "%s".',
        'History::Bounce' => 'Odbijeno "%s".',
        'History::SendAnswer' => 'Poslat odgovor "%s".',
        'History::SendAgentNotification' => '"%s"-Poslato obaveštenja operateru"%s".',
        'History::SendCustomerNotification' => 'Poslato obaveštenje korisniku"%s".',
        'History::EmailAgent' => 'E-mail operatera',
        'History::EmailCustomer' => 'E-Mail poslat korisniku',
        'History::PhoneCallAgent' => 'Telefonski poziv operatera',
        'History::PhoneCallCustomer' => 'Telefonski poziv korisnika',
        'History::AddNote' => 'Dodata napomena (%s)',
        'History::Lock' => 'Zaključano',
        'History::Unlock' => 'Otključano',
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
        'History::WebRequestCustomer' => 'Korisnički Web zahtev.',
        'History::TicketLinkAdd' => 'Veza na "%s" postavljena.',
        'History::TicketLinkDelete' => 'Veza na "%s" obrisana.',
        'History::Subscribe' => 'Pretplata za korisnika "%s" uključena.',
        'History::Unsubscribe' => 'Pretplata za korisnika "%s" isključena.',
        'History::SystemRequest' => 'Sistemski zahtev',
        'History::ResponsibleUpdate' => 'Novi odgovorni je "%s" (ID=%s).',
        'History::ArchiveFlagUpdate' => 'Arhiviranje označenih ažuriranja',
        'History::TicketTitleUpdate' => 'Ažuriranje naslova tiketa',

        # Template: AAAWeekDay
        'Sun' => 'ned',
        'Mon' => 'pon',
        'Tue' => 'uto',
        'Wed' => 'sre',
        'Thu' => 'čet',
        'Fri' => 'pet',
        'Sat' => 'sub',

        # Template: AdminACL
        'ACL Management' => 'ACL menadžment',
        'Filter for ACLs' => 'Filter za ACL',
        'Filter' => 'Filter',
        'ACL Name' => 'Ime ACL',
        'Actions' => 'Akcije',
        'Create New ACL' => 'Kreiraj novu ACL',
        'Deploy ACLs' => 'Upotrebi ACL liste',
        'Export ACLs' => 'Izvezi ACL liste',
        'Configuration import' => 'Učitavanje konfiguracije',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Ovde možete poslati konfiguracionu datoteku za uvoz ACL lista u vaš sistem. Datoteka mora biti u .yml formatu ako se izvozi od strane ACL editor modula.',
        'This field is required.' => 'Ovo polje je obavezno.',
        'Overwrite existing ACLs?' => 'Napiši preko postojećih ACL lista',
        'Upload ACL configuration' => 'Otpremi ACL konfiguraciju',
        'Import ACL configuration(s)' => 'Uvezi ACL konfiguraciju (e)',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'Da biste kreirali novu ACL možete ili uvesti ACL liste koje su izvezene iz drugog sistema ili napraviti kompletno novu.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Promene na ACL listama ovde samo utiču na ponašanje sistema, ukoliko naknadno upotrebite sve ACL podatke.',
        'ACLs' => 'ACL liste',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Napomena: Ova tabela predstavlja redosled izvršavanja u ACL listama. Ako je potrebno da promenite redosled kojim se izvršavaju ACL liste, molimo promenite imena tih ACL lista.',
        'ACL name' => 'Naziv ACL',
        'Validity' => 'Važnost',
        'Copy' => 'Kopija',
        'No data found.' => 'Ništa nije pronađeno.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Uredi ACL %s',
        'Go to overview' => 'Idi na pregled',
        'Delete ACL' => 'Obriši ACL',
        'Delete Invalid ACL' => 'Obriši nevažeću ACL',
        'Match settings' => 'Uskladi podešavanja',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            'Podesite usklađene kriterijume za ovu ACL listu. Koristite \'Properties\' tako da odgovara postojećem prikazu ekrana ili \'PropertiesDatabase\' da bi odgovarao atributima postojećeg tiketa koji su u bazi podataka.',
        'Change settings' => 'Promeni podešavanja',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Podesite ono što želite da menjate ako se kriterijumi slažu. Imajte na umu da je \'Possible\' bela lista, \'PossibleNot\' crna lista.',
        'Check the official' => 'Proverite zvanično',
        'documentation' => 'dokumentacija',
        'Show or hide the content' => 'Pokaži ili sakrij sadržaj',
        'Edit ACL information' => 'Uredi ACL informacije',
        'Stop after match' => 'Zaustavi posle poklapanja',
        'Edit ACL structure' => 'Uredi ACL strukturu',
        'Save' => 'Sačuvaj',
        'or' => 'ili',
        'Save and finish' => 'Sačuvaj i završi',
        'Do you really want to delete this ACL?' => 'Da li zaista želite da obrišete ovu ACL listu?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Ova stavka i dalje sadrži podstavke. Da li ste sigurni da želite da uklonite ovu stavku uključujući i njene podstavke?',
        'An item with this name is already present.' => 'Već je prisutna tavka pod ovim imenom.',
        'Add all' => 'Dodaj sve',
        'There was an error reading the ACL data.' => 'Došlo je do greške prilikom čitanja ACL podataka.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            'Kreirajte novu ACL listu podnošenjem obrasca sa podacima. Nakon kreiranja ACL liste, bićete u mogućnosti da dodate konfiguracione stavke u edit modu.',

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
        'To get the first 5 lines of the email.' => 'Da vidite prvih 5 linija email poruke',
        'To get the realname of the sender (if given).' => 'Da vidite ime pošiljaoca (ako je dostupno)',
        'To get the article attribute' => 'Da vidite atribute članka',
        ' e. g.' => 'npr.',
        'Options of the current customer user data' => 'Opcije podataka o aktuelnom korisniku',
        'Ticket owner options' => 'Opcije vlasnika tiketa',
        'Ticket responsible options' => 'Opcije odgovornog za tiket',
        'Options of the current user who requested this action' => 'Opcije aktuelnog korisnika koji je tražio ovu akciju',
        'Options of the ticket data' => 'Opcije podataka o tiketu',
        'Options of ticket dynamic fields internal key values' => 'Opcije za vrednosti internih ključeva dinamičkih polja tiketa.',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Opcije za prikazane vrednosti dinamičkih polja tiketa, korisno za polja Dropdown i Multiselect',
        'Config options' => 'Konfiguracione opcije',
        'Example response' => 'Primer odgovora',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Upravljanje korisnicima',
        'Wildcards like \'*\' are allowed.' => 'Džokerski znaci kao \'*\' su dozvoljeni',
        'Add customer' => 'Dodaj korisnika',
        'Select' => 'Izaberi',
        'Please enter a search term to look for customers.' => 'Molimo unesite pojam pretrage za pronalaženje korisnika.',
        'Add Customer' => 'Dodaj korisnika',
        'Edit Customer' => 'Uredi korisnika',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Upravljanje korisnicima',
        'Back to search results' => 'Vrati se na rezultate pretrage',
        'Add customer user' => 'Dodaj korisnika ',
        'Hint' => 'Savet',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Korisnik  korisnika treba da ima istoriju korisnika i da se prijavi preko korisničkog panela.',
        'Last Login' => 'Poslednja prijava',
        'Login as' => 'Prijavi se kao',
        'Switch to customer' => 'Pređi na  korisnika',
        'Add Customer User' => 'Dodaj korisnika',
        'Edit Customer User' => 'Uredi korisnika',
        'This field is required and needs to be a valid email address.' =>
            'Ovo je obavezno polje i mora da bude ispravna email adresa.',
        'This email address is not allowed due to the system configuration.' =>
            'Ova email adresa nije dozvoljena zbog sistemske konfiguracije.',
        'This email address failed MX check.' => 'Ova email adresa ne zadovoljava MX proveru.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS problem, molimo proverite konfiguraciju i grešake u logu.',
        'The syntax of this email address is incorrect.' => 'Sintaksa ove email adrese je neispravna.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Upravljanje relacijama Korisnik-Grupa',
        'Notice' => 'Napomena',
        'This feature is disabled!' => 'Ova funkcija je isključena!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Upotrebite ovu funkciju ako želite da definišete grupne dozvole za korisnike.',
        'Enable it here!' => 'Aktivirajte je ovde!',
        'Search for customers.' => 'Traži korisnike.',
        'Edit Customer Default Groups' => 'Uredi podrazumevane grupe za korisnika',
        'These groups are automatically assigned to all customers.' => 'Ove grupe su automatski dodeljene svim korisnicima.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Možete upravljati ovim grupama preko konfiguracionih podešavanja "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Fileter za grupe',
        'Select the customer:group permissions.' => 'Izaberi dozvole za customer:group.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Ako ništa nije izabrano, onda nema dozvola u ovoj grupi (tiketi neće biti dostupni korisniku).',
        'Search Results' => 'Rezultat pretrage',
        'Customers' => 'Korisnici',
        'No matches found.' => 'Ništa nije pronađeno.',
        'Change Group Relations for Customer' => 'Promeni veze sa grupama za korisnika',
        'Change Customer Relations for Group' => 'Promeni veze sa korisnicima za grupu',
        'Toggle %s Permission for all' => 'Promeni %s dozvole za sve',
        'Toggle %s permission for %s' => 'Promeni %s dozvole za %s',
        'Customer Default Groups:' => 'Podrazumevane grupe za korisnika:',
        'No changes can be made to these groups.' => 'Na ovim grupama promene nisu moguće.',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Pristup ograničen samo na čitanje za tikete u ovim grupama/redovima.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Pristup bez ograničenja za tikete u ovim grupama/redovima.',

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
        'Add new field for object' => 'Dodaj novo polje objektu',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Lista dinamičkih polja',
        'Dynamic fields per page' => 'Broj dinamičkih polja po strani',
        'Label' => 'Oznaka',
        'Order' => 'Sortiranje',
        'Object' => 'Objekat',
        'Delete this field' => 'Obriši ovo polje',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Da li zaista želite da obrišete ovo dinamičko polje? Svi povezani podaci će biti IZGUBLJENI!',
        'Delete field' => 'Obriši polje',

        # Template: AdminDynamicFieldCheckbox
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
            'Ovo je naziv koji će se prikazivati na ekranima gde je polje aktivno.',
        'Field order' => 'Redosled polja',
        'This field is required and must be numeric.' => 'Ovo polje je obavezno i mora biti numeričko.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Ovo je redosled po kom će polja biti prikazana na ekranima gde su aktivna.',
        'Field type' => 'Tip polja',
        'Object type' => 'Tip objekta',
        'Internal field' => 'Interno polje',
        'This field is protected and can\'t be deleted.' => 'Ovo polje je zaštićeno i ne može biti obrisano.',
        'Field Settings' => 'Podešavanje polja',
        'Default value' => 'Podrazumevana vrednost',
        'This is the default value for this field.' => 'Ovo je podrazumevana vrednost za ovo polje.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Podrazumevana razlika datuma',
        'This field must be numeric.' => 'Ovo polje mora biti numeričko.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Razlika (u sekundama) od SADA, za izračunavanje podrazumevane vrednosti polja (npr. 3600 ili -60).',
        'Define years period' => 'Definiši peroiod  u godinama',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Aktivirajte ovu opciju radi definisanja fiksnog opsega godina (u budućnost i prošlost) za prikaz pri izboru godina u polju.',
        'Years in the past' => 'Godine u prošlosti',
        'Years in the past to display (default: 5 years).' => 'Godine u prošlosti za prikaz (podrazumevano je 5 godina).',
        'Years in the future' => 'Godine u budućnosti',
        'Years in the future to display (default: 5 years).' => 'Godine u budućnosti za prikaz (podrazumevano je 5 godina).',
        'Show link' => 'Pokaži vezu',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Ovde možete da unesete opcionu HTTP vezu za vrednost polja u prozoru opšteg i uvećanog prikaza ekrana.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Moguće vrednosti',
        'Key' => 'Ključ',
        'Value' => 'Vrednost',
        'Remove value' => 'Ukloni vrednost',
        'Add value' => 'Dodaj vrednost',
        'Add Value' => 'Dodaj Vrednost',
        'Add empty value' => 'Dodaj bez vrednosti',
        'Activate this option to create an empty selectable value.' => 'Aktiviraj ovu opciju za kreiranje izbora bez vrednosti.',
        'Tree View' => 'Prikaz u obliku stabla',
        'Activate this option to display values as a tree.' => 'Aktiviraj ovu opciju za prikaz vrednosti u obliku stabla.',
        'Translatable values' => 'Prevodljive vrednosti',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Ako aktivirate ovu opciju vrednosti će biti prevedene na izabrani jezik.',
        'Note' => 'Napomena',
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
        'Admin Notification' => 'Administratorska obaveštenja',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Sa ovim modulom, administratori mogu slati poruke operaterima, grupama ili pripadnicima uloge.',
        'Create Administrative Message' => 'Kreiraj administrativnu poruku',
        'Your message was sent to' => 'Vaša poruka je poslata',
        'Send message to users' => 'Pošalji poruku korisnicima',
        'Send message to group members' => 'Pošalji poruku članovima grupe',
        'Group members need to have permission' => 'Članovi grupe treba da imaju dozvolu',
        'Send message to role members' => 'Pošalji poruku pripadnicima uloge',
        'Also send to customers in groups' => 'Takođe pošalji korisnicima u grupama',
        'Body' => 'Telo',
        'Send' => 'Šalji',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Generički operater',
        'Add job' => 'Dodaj posao',
        'Last run' => 'Poslednje pokretanje',
        'Run Now!' => 'Pokreni sad!',
        'Delete this task' => 'Obriši ovaj zadatak',
        'Run this task' => 'Pokreni ovaj zadatak',
        'Job Settings' => 'Podešavanje posla',
        'Job name' => 'Naziv posla',
        'The name you entered already exists.' => 'Ime koje ste uneli već postoji.',
        'Toggle this widget' => 'Preklopi ovaj aplikativni dodatak (widget)',
        'Automatic execution (multiple tickets)' => 'Automatsko izvršenje (višestruki tiketi)',
        'Execution Schedule' => 'Raspored izvršenja',
        'Schedule minutes' => 'Planirano minuta',
        'Schedule hours' => 'Planirano sati',
        'Schedule days' => 'Planirano dana',
        'Currently this generic agent job will not run automatically.' =>
            'Trenutno ovaj generički agentski zadatak neće raditi automatski.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Da biste omogućili automatsko izvršavanje izaberite bar jednu vrednost od minuta, sati i dana!',
        'Event based execution (single ticket)' => 'Izvršenje zasnovano na događaju (pojedinačni tiket)',
        'Event Triggers' => 'Okidači događaja',
        'List of all configured events' => 'Lista svih konfigurisanih događaja',
        'Delete this event' => 'Obriši ovaj događaj',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            'Dodatno ili alternativno za periodično izvršenje, možete definisati događaje tiketa koji će pokrenuti ovaj posao.',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            'Ukoliko je događaj tiketa otkazao, biće primenjen tiket filter da potvrdi da li tiket odgovara. Samo tada će se posao na tiketu pokrenuti.',
        'Do you really want to delete this event trigger?' => 'Da li stvarno želite da obrišete ovaj okidač događaja?',
        'Add Event Trigger' => 'Dodaj okidač događaja',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'Za dodavanje novog događaja izaberite objekt događaja i ime događaja pa kliknite na "+" dugme',
        'Duplicate event.' => 'Napravi duplikat događaja.',
        'This event is already attached to the job, Please use a different one.' =>
            'Ovaj događaj je priložen poslu. Molimo koristite neki drugi.',
        'Delete this Event Trigger' => 'Obriši ovaj okidač događaja',
        'Ticket Filter' => 'Filter tiketa',
        '(e. g. 10*5155 or 105658*)' => 'npr. 10*5144 ili 105658*',
        '(e. g. 234321)' => 'npr. 234321',
        'Customer login' => 'Prijava korisnika',
        '(e. g. U5150)' => 'npr. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Potpuna tekstualna pretraga u članku (npr. "Mar*in" ili "Baue*")',
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
        'Escalation - first response time' => 'Eskalacija - vreme prvog odziva',
        'Ticket first response time reached' => 'Dostignuto vreme prvog odziva na tiket',
        'Ticket first response time reached between' => 'Vreme prvog odziva na tiket dostignuto između',
        'Escalation - update time' => 'Eskalacija - vreme ažuriranja',
        'Ticket update time reached' => 'Dostignuto vreme ažuriranja tiketa',
        'Ticket update time reached between' => 'Vreme ažuriranja tiketa dostignuto između',
        'Escalation - solution time' => 'Eskalacija - vreme rešavanja',
        'Ticket solution time reached' => 'Dostignuto vreme rešavanja tiketa',
        'Ticket solution time reached between' => 'Vreme rešavanja tiketa dostignuto između',
        'Archive search option' => 'Opcije pretrage arhiva',
        'Ticket Action' => 'Akcija na tiketu',
        'Set new service' => 'Podesi novi servis',
        'Set new Service Level Agreement' => 'Podesi novi Sporazum o nivou usluga',
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
        '(work units)' => '(radne jedinice)',
        'Ticket Commands' => 'Komande za tiket',
        'Send agent/customer notifications on changes' => 'Pošalji obaveštenja operateru/korisniku pri promenama',
        'CMD' => 'CMD',
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
            'UPOZORENjE: Upotrebili ste opciju za brisanje. Svi obrisani tiketi će biti izgubljeni!',
        'Edit job' => 'Uredi posao',
        'Run job' => 'Pokreni posao',
        'Affected Tickets' => 'Obuhvaćeni tiketi',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => 'Otklanjanje grešaka u opštem interfejsu web servisa %s',
        'Web Services' => 'Web servisi',
        'Debugger' => 'Program za otklanjanje grešaka',
        'Go back to web service' => 'Idi nazad na web servis',
        'Clear' => 'Očisti',
        'Do you really want to clear the debug log of this web service?' =>
            'Da li stvarno želite da očistite otklanjanje grešaka u logu ovog web servisa?',
        'Request List' => 'Lista zahteva',
        'Time' => 'Vreme',
        'Remote IP' => 'Udaljena IP adresa',
        'Loading' => 'Učitavam...',
        'Select a single request to see its details.' => 'Izaberite jedan zahtev da bi videli njegove detalje.',
        'Filter by type' => 'Filter po tipu',
        'Filter from' => 'Filter od',
        'Filter to' => 'Filter do',
        'Filter by remote IP' => 'Filter po udaljenoj IP adresi',
        'Refresh' => 'Osvežavanje',
        'Request Details' => 'Detalji zahteva',
        'An error occurred during communication.' => 'Došlo je do greške prilikom komunikacije.',
        'Clear debug log' => 'Očisti otklanjanje grešaka u logu',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Dodaj novi Invoker u web servis %s',
        'Change Invoker %s of Web Service %s' => 'Promeni Invoker u web servisu %s',
        'Add new invoker' => 'Dodaj novi Invoker',
        'Change invoker %s' => 'Promeni Invoker %s',
        'Do you really want to delete this invoker?' => 'Da li zaista želite da izbrišete ovaj Invoker?',
        'All configuration data will be lost.' => 'Svi konfiguracioni podaci će biti izgubljeni.',
        'Invoker Details' => 'Detalji Invokera',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Ime se obično koristi za pokretanje operacije udaljenog web servisa.',
        'Please provide a unique name for this web service invoker.' => 'Molimo upotrebite jedinstveno ime za ovaj Invoker web servisa.',
        'Invoker backend' => 'Pozadinski prikaz Invokera',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            'Ovaj modul pozadinskog prikaza OTRS Invokera biće pozvan da pripremi podatke za slanje na udaljeni sistem i da obradi njegove odgovorne podatke.',
        'Mapping for outgoing request data' => 'Mapiranje za izlazne podatke zahteva',
        'Configure' => 'Podesi',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Podaci iz OTRS Invokera biće obrađeni ovim mapiranjem, da bi ih transformisali u tipove podataka koje udaljeni sistem očekuje.',
        'Mapping for incoming response data' => 'Mapiranje za ulazne podatke odgovora',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            'Odgovorni podaci iz OTRS Invokera biće obrađeni ovim mapiranjem, da bi ih transformisali u tipove podataka koje udaljeni sistem očekuje.',
        'Asynchronous' => 'Asinhroni',
        'This invoker will be triggered by the configured events.' => 'Ovaj Invoker će biti aktiviran preko podešenih događaja.',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            'Asinhronim okidačima događaja upravlja OTRS Planer u pozadini (preporučeno).',
        'Synchronous event triggers would be processed directly during the web request.' =>
            'Sinhroni okidači događaja biće obrađeni direktno tokom web zahteva.',
        'Save and continue' => 'Sačuvaj i nastavi',
        'Delete this Invoker' => 'Obriši ovaj Invoker',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => 'Opšti interfejs jednostavnog mapiranja za web servis %s',
        'Go back to' => 'Idi nazad na',
        'Mapping Simple' => 'Jednostavno mapiranje',
        'Default rule for unmapped keys' => 'Podrazumevano pravilo za nemapirane ključeve',
        'This rule will apply for all keys with no mapping rule.' => 'Ovo pravilo će se primenjivati za sve ključeve bez pravila mapiranja.',
        'Default rule for unmapped values' => 'Podrazumevano pravilo za nemapirane vrednosti',
        'This rule will apply for all values with no mapping rule.' => 'Ovo pravilo će se primenjivati za sve vrednosti bez pravila mapiranja.',
        'New key map' => 'Novo mapiranje ključa',
        'Add key mapping' => 'Dodaj mapiranje ključa',
        'Mapping for Key ' => 'Mapiranje za ključ',
        'Remove key mapping' => 'Ukloni mapiranje ključa',
        'Key mapping' => 'Mapiranje ključa',
        'Map key' => 'Mapiraj ključ',
        'matching the' => 'Podudaranje sa',
        'to new key' => 'na novi ključ',
        'Value mapping' => 'Vrednosno mapiranje',
        'Map value' => 'Mapiraj vrednost',
        'to new value' => 'na novu vrednost',
        'Remove value mapping' => 'Ukloni mapiranje vrednosti',
        'New value map' => 'Novo mapiranje vrednosti',
        'Add value mapping' => 'Dodaj mapiranu vrednost',
        'Do you really want to delete this key mapping?' => 'Da li stvarno želite da obrišete ovo mapiranje ključa?',
        'Delete this Key Mapping' => 'Obriši mapiranje za ovaj ključ',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Dodaj novu operaciju web servisu %s',
        'Change Operation %s of Web Service %s' => 'Promeni operaciju %s iz web servisa %s',
        'Add new operation' => 'Dodaj novu operaciju',
        'Change operation %s' => 'Promeni operaciju %s',
        'Do you really want to delete this operation?' => 'Da li stvarno želite da obrišete ovu operaciju?',
        'Operation Details' => 'Detalji operacije',
        'The name is typically used to call up this web service operation from a remote system.' =>
            'Naziv se obično koristi za pozivanje operacije web servisa iz udaljenog sistema.',
        'Please provide a unique name for this web service.' => 'Molimo da obezbedite jedinstveni naziv za ovaj web servis.',
        'Mapping for incoming request data' => 'Mapiranje za dolazne podatke zahteva',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            'Podaci zahteva će biti obrađeni kroz mapiranje, radi transformacije u oblik koji OTRS očekuje.',
        'Operation backend' => 'Operativni pozadinski prikaz',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            'Ovaj modul OTRS operativnog pozadinskog prikaza će biti interno pozvan da obradi zahtev, generisanjem podataka za odgovor.',
        'Mapping for outgoing response data' => 'Mapiranje za izlazne podatke odgovora',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            'Podaci odgovora će biti obrađeni kroz ovo mapiranje, radi transformacije u oblik koji udaljeni sistem očekuje.',
        'Delete this Operation' => 'Obriši ovu operaciju',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => 'Opšti interfejs transporta HTTP::SOAP za web servis %s',
        'Network transport' => 'Mrežni transport',
        'Properties' => 'Svojstva',
        'Endpoint' => 'Krajnja tačka',
        'URI to indicate a specific location for accessing a service.' =>
            'URI za identifikaciju specifične lokacije za pristup servisu.',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'na primer http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Prostor imena',
        'URI to give SOAP methods a context, reducing ambiguities.' => 'URI koji daje kontekst SOAP metodama, smanjuje dvosmislenosti.',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            'na primer urn:otrs-com:soap:functions ili http://www.otrs.com/GenericInterface/actions',
        'Maximum message length' => 'Najveća dužina poruke',
        'This field should be an integer number.' => 'Ovo polje treba da bude ceo broj.',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            'Ovde možete uneti maksimalnu veličinu (u bajtima) SOAP poruka koje će OTRS da obradi.',
        'Encoding' => 'Kodni raspored',
        'The character encoding for the SOAP message contents.' => 'Kodni raspored znakova za sadržaj SOAP poruke.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'na primer utf-8, latin1, iso-8859-1, cp1250, ...',
        'SOAPAction' => 'SOAP akcija',
        'Set to "Yes" to send a filled SOAPAction header.' => 'Izaberi "Da" za slanje popunjenog zaglavlja SOAP akcije.',
        'Set to "No" to send an empty SOAPAction header.' => 'Izaberi "Ne" za slanje praznog zaglavlja SOAP akcije.',
        'SOAPAction separator' => 'Separator SOAP akcije',
        'Character to use as separator between name space and SOAP method.' =>
            'Znak koji će se koristiti kao separator između prostora imena i SOAP metode.',
        'Usually .Net web services uses a "/" as separator.' => 'Obično .Net web servisi koriste "/" kao separator.',
        'Authentication' => 'Autentifikacija',
        'The authentication mechanism to access the remote system.' => 'Mehanizam autentifikacije za pristum udaljenom sistemu.',
        'A "-" value means no authentication.' => 'Vrednost "-" znači nema autentifikacije.',
        'The user name to be used to access the remote system.' => 'Korisničko ime koje će biti korišćeno za pristup udaljenom sistemu.',
        'The password for the privileged user.' => 'Lozinka za privilegovanog korisnika.',
        'Use SSL Options' => 'Koristi SSL opcije',
        'Show or hide SSL options to connect to the remote system.' => 'Prikaži ili sakrij SSL opcije za povezivanje sa udaljenim sistemom.',
        'Certificate File' => 'Sertifikat datoteke',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Cela putanja i naziv za datoteku SSL  sertifikata (mora biti u .p12 formatu).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'npr. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'Certificate Password File' => 'Sertifikat lozinke datoteke',
        'The password to open the SSL certificate.' => 'Lozinka za otvaranje SSL sertifikata',
        'Certification Authority (CA) File' => 'Datoteka sertifikacionog tela (CA)',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Cela putanja i naziv sertifikacionog tela koje provera ispravnost SSL sertifikata.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'npr. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Direktorijum sertifikacionog tela (CA)',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Cela putanja direktorijuma sertifikacionog tela gde se skladište CA sertifikati u sistemu datoteka.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'npr. /opt/otrs/var/certificates/SOAP/CA',
        'Proxy Server' => 'Proxy server',
        'URI of a proxy server to be used (if needed).' => 'URI od proxy servera da bude korišćen (ako je potrebno).',
        'e.g. http://proxy_hostname:8080' => 'npr. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy korisnik',
        'The user name to be used to access the proxy server.' => 'Korisničko ime koje će se koristiti za pristup proxy serveru.',
        'Proxy Password' => 'Proxy lozinka',
        'The password for the proxy user.' => 'Lozinka za proxy korisnika',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Upravljanje oštim interfejsom web servisa',
        'Add web service' => 'Dodaj web servis',
        'Clone web service' => 'Kloniraj web servis',
        'The name must be unique.' => 'Ime mora biti jedinstveno.',
        'Clone' => 'Kloniraj',
        'Export web service' => 'Izvezi web servis',
        'Import web service' => 'Uvezi web servis',
        'Configuration File' => 'Konfiguraciona datoteka',
        'The file must be a valid web service configuration YAML file.' =>
            'Datoteka mora da bude važeća YAML konfiguraciona datoteka web servisa.',
        'Import' => 'Uvezi',
        'Configuration history' => 'Istorijat konfigurisanja',
        'Delete web service' => 'Obriši web servis',
        'Do you really want to delete this web service?' => 'Da li stvarno želite da obrišete ovaj web servis?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            'Nakon snimanja konfiguracije bićete ponovo preusmereni na prikaz ekrana za uređivanje.',
        'If you want to return to overview please click the "Go to overview" button.' =>
            'Ako želite da se vratite na pregled, molimo da kliknete na dugme "Idi na pregled".',
        'Web Service List' => 'Lista web servisa',
        'Remote system' => 'Udaljeni sistem',
        'Provider transport' => 'Transport provajdera',
        'Requester transport' => 'Transport potražioca',
        'Details' => 'Detalji',
        'Debug threshold' => 'Prag uklanjanja grešaka',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            'U režimu provajdera, OTRS nudi web servise koji se koriste od strane udaljenih sistema.',
        'In requester mode, OTRS uses web services of remote systems.' =>
            'U režimu naručioca, OTRS koristi web servis udaljenih sistema.',
        'Operations are individual system functions which remote systems can request.' =>
            'Operacije su individualne sistemske funkcije koje udaljeni sistemi mogu da zahtevaju.',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            'Invokeri pripremaju podatke za zahtev na udaljenom web servisu i obrađuje svoje odgovorne podatke.',
        'Controller' => 'Kontroler',
        'Inbound mapping' => 'Ulazno mapiranje',
        'Outbound mapping' => 'Izlazno mapiranje',
        'Delete this action' => 'Obriši ovu akciju',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            'Najmanje jedan %s ima kontroler koji ili nije aktivan ili nije prisutan, molimo proverite registraciju kontrolera ili izbrišite %s',
        'Delete webservice' => 'Obriši web servis',
        'Delete operation' => 'Obriši operaciju',
        'Delete invoker' => 'Obriši Invoker',
        'Clone webservice' => 'Kloniraj web servis',
        'Import webservice' => 'Uvezi web servis',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => 'Istorijat konfiguracije opšteg interfejsa za web servis %s',
        'Go back to Web Service' => 'Vratite se na web servis',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Ovde možete videti starije verzije aktuelne konfiguracije web servisa, napraviti izvoz ili je obnoviti.',
        'Configuration History List' => 'Lista - istorijat konfiguracije',
        'Version' => 'Verzija',
        'Create time' => 'Vreme kreiranja',
        'Select a single configuration version to see its details.' => 'Izaberi samo jednu konfiguracionu verziju za pregled njenih detalja.',
        'Export web service configuration' => 'Izvezi konfiguraciju web servisa',
        'Restore web service configuration' => 'Obnovi konfiguraciju web servisa',
        'Do you really want to restore this version of the web service configuration?' =>
            'Da li stvarno želite da vratite ovu verziju konfiguracije web servisa?',
        'Your current web service configuration will be overwritten.' => 'Aktuelna konfiguracija web servisa biće prepisana.',
        'Show or hide the content.' => 'Pokaži ili sakrij sadržaj.',
        'Restore' => 'Obnovi',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'UPOZORENjE: Ako promenite ime grupe \'admin\' pre adekvatnog podešavanja u sistemskoj konfiguraciji, izgubićete pristup administrativnom panelu! Ukoliko se to desi, vratite ime grupi u "admin" pomoću SQL komande.',
        'Group Management' => 'Upravljanje grupama',
        'Add group' => 'Dodaj grupu',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '"admin" grupa služi za pristup administracionom prostoru, a "stats" grupa prostoru statistike.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Napravi nove grupe za rukovanje pravima pristupa raznim grupama operatera (npr. odeljenje nabavke, tehnička podrška, prodaja, ...).',
        'It\'s useful for ASP solutions. ' => 'Korisno za ASP rešenja.',
        'Add Group' => 'Dodaj grupu',
        'Edit Group' => 'Uredi grupu',

        # Template: AdminLog
        'System Log' => 'Sistemski log',
        'Here you will find log information about your system.' => 'Ovde ćete naći log informacije o vašem sistemu.',
        'Hide this message' => 'Sakrij ovu poruku',
        'Recent Log Entries' => 'Poslednji log unosi',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Upravljanje email nalozima',
        'Add mail account' => 'Dodaj email nalog',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Sve dolazne poruke sa jednog email naloga će biti usmerene u izabrani red!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Ako je vaš nalog od poverenja, koristiće se postojeća X-OTRS zaglavlja! PostMaster filteri se koriste uvek.',
        'Host' => 'Domaćin',
        'Delete account' => 'Obriši nalog',
        'Fetch mail' => 'Preuzmi poštu',
        'Add Mail Account' => 'Dodaj email nalog',
        'Example: mail.example.com' => 'Primer: mail.example.com',
        'IMAP Folder' => 'IMAP folder',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Ovo izmenite samo ako je potrebno primiti mail iz drugog foldera, a ne iz INBOX-a.',
        'Trusted' => 'Od poverenja',
        'Dispatching' => 'Otprema',
        'Edit Mail Account' => 'Uredi mail nalog',

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
        'Only for ArticleCreate and ArticleSend event' => 'Samo za događaj kreiranje članka i slanje članka',
        'Article type' => 'Tip članka',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            'Ako se koriste događaji kreiranje članka i slanje članka, neophodno je definisati filter članka. Molim vas selektujte bar jedno polje za filter članka.',
        'Article sender type' => 'Tip pošiljaoca članka',
        'Subject match' => 'Poklapanje predmeta',
        'Body match' => 'Poklapanje sadržaja',
        'Include attachments to notification' => 'Uključi priloge uz obavštenje',
        'Recipient' => 'Primalac',
        'Recipient groups' => 'Grupe primaoci',
        'Recipient agents' => 'Zaposleni primaoci',
        'Recipient roles' => 'Uloge primaoca',
        'Recipient email addresses' => 'Email adrese primaoca',
        'Notification article type' => 'Tip članka obaveštenja',
        'Only for notifications to specified email addresses' => 'Samo za obaveštenja za precizirane email adrese',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Da vidite prvih 20 slova predmeta (poslednjeg članka operatera).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'Da vidite prvih 5 linija poruke (poslednjeg članka operatera).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Da vidite prvih 20 slova predmeta (poslednjeg članka operatera).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Da vidite prvih 5 linija poruke (poslednjeg članka operatera).',

        # Template: AdminPGP
        'PGP Management' => 'Upravljanje PGP ključevima',
        'Use this feature if you want to work with PGP keys.' => 'Upotrebi ovu mogućnost za rad sa PGP ključevima.',
        'Add PGP key' => 'Dodaj PGP ključ',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Na ovaj način možete direktno uređivati komplet ključeva podešen u SysConfig (sistemskim konfiguracijama).',
        'Introduction to PGP' => 'Uvod u PGP',
        'Result' => 'Rezultat',
        'Identifier' => 'Identifikator',
        'Bit' => 'Bit',
        'Fingerprint' => 'Otisak',
        'Expires' => 'Ističe',
        'Delete this key' => 'Obriši ovaj ključ',
        'Add PGP Key' => 'Dodaj PGP ključ',
        'PGP key' => 'PGP ključ',

        # Template: AdminPackageManager
        'Package Manager' => 'Upravljanje paketima',
        'Uninstall package' => 'Deinstaliraj paket',
        'Do you really want to uninstall this package?' => 'Da li stvarno želite da deinstalirate ovaj paket?',
        'Reinstall package' => 'Instaliraj paket ponovo',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Da li stvarno želite da ponovo instalirate ovaj paket? Sve ručne promene će biti izgubljene.',
        'Continue' => 'Nastavi',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Molimo vas da budete sigurni da vaša baza podataka prihvata pakete veličine preko %s MB (trenutno prihvata samo pakete do %s MB). Molimo prilagodite podešavanja "max_allowed_packet" na vašoj bazi podataka, da bi ste izbegli greške.',
        'Install' => 'Instaliraj',
        'Install Package' => 'Instaliraj paket',
        'Update repository information' => 'Ažuriraj informacije o spremištu',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            'Niste pronašli potrebnu funkcionalnost? OTRS Grupa obezbeđuje svojim klijentima servisni ugovor sa ekskluzivnim dodatnim modulima.',
        'Online Repository' => 'Mrežno spremište',
        'Vendor' => 'Prodavac',
        'Module documentation' => 'Dokumentacija modula',
        'Upgrade' => 'Ažuriranje',
        'Local Repository' => 'Lokalno spremište',
        'This package is verified by OTRSverify (tm)' => 'Ovaj paket je verifikovan od strane OTRSverify (tm)',
        'Uninstall' => 'Deinstaliraj',
        'Reinstall' => 'Instaliraj ponovo',
        'Feature Add-Ons' => 'Funkcionalnost dodatnih modula',
        'Download package' => 'Preuzmi paket',
        'Rebuild package' => 'Obnovi paket(rebuild)',
        'Metadata' => 'Meta-podaci',
        'Change Log' => 'Promeni log',
        'Date' => 'Datum',
        'List of Files' => 'Spisak datoteka',
        'Permission' => 'Dozvola',
        'Download' => 'Preuzimanje',
        'Download file from package!' => 'Preuzmi datoteku iz paketa!',
        'Required' => 'Obavezno',
        'PrimaryKey' => 'Primarni ključ',
        'AutoIncrement' => 'AutoUvećanje',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Razlike za datoteku %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Performansa log-a',
        'This feature is enabled!' => 'Ova funkcija je aktivna!',
        'Just use this feature if you want to log each request.' => 'Aktivirati ovu mogućnost samo ako želite da zabeležite svaki zahtev.',
        'Activating this feature might affect your system performance!' =>
            'Aktiviranje ove funkcije može uticati na performanse sistema.',
        'Disable it here!' => 'Isključite je ovde!',
        'Logfile too large!' => 'Log datoteka je prevelik!',
        'The logfile is too large, you need to reset it' => 'Log datoteka je prevelika, treba da je resetujete',
        'Overview' => 'Pregled',
        'Range' => 'Opseg',
        'last' => 'poslednje',
        'Interface' => 'Interfejs',
        'Requests' => 'Zahtevi',
        'Min Response' => 'Min odziv',
        'Max Response' => 'Maks odziv',
        'Average Response' => 'Prosečan odziv',
        'Period' => 'Period',
        'Min' => 'Min',
        'Max' => 'Maks',
        'Average' => 'Prosek',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Upravljanje PostMaster filterima',
        'Add filter' => 'Dodaj filter',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Radi otpreme ili filtriranja dolaznih email-ova na osnovu zaglavlja. Poklapanje pomoću regularnih izraza je takođe moguće.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Ukoliko želite poklapanje samo sa email adresom, koristite EMAILADDRESS:info@example.com u "Od", "Za" ili "Cc".',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Ukoliko koristite regularne izraze, takođe možete koristiti i upateru vrednost u () kao (***) u \'Set\' action.',
        'Delete this filter' => 'Obriši ovaj filter',
        'Add PostMaster Filter' => 'Dodaj PostMaster filter',
        'Edit PostMaster Filter' => 'Uredi PostMaster filter',
        'The name is required.' => 'Ime je obavezno.',
        'Filter Condition' => 'Uslov filtriranja',
        'AND Condition' => 'AND uslov',
        'Negate' => 'Negirati',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Ovo polje treba da bude važeći regularni izraz ili doslovno reč.',
        'Set Email Headers' => 'Podesi zaglavlja Email-a',
        'The field needs to be a literal word.' => 'Ovo polje treba da bude doslovno reč.',

        # Template: AdminPriority
        'Priority Management' => 'Upravljanje prioritetima',
        'Add priority' => 'Dodaj prioritet',
        'Add Priority' => 'Dodaj Prioritet',
        'Edit Priority' => 'Uredi Prioritet',

        # Template: AdminProcessManagement
        'Process Management' => 'Upravljanje procesom',
        'Filter for Processes' => 'Filter procesa',
        'Process Name' => 'Naziv procesa',
        'Create New Process' => 'Kreiraj novi proces',
        'Synchronize All Processes' => 'Sinhronizuj sve procese',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Ovde možete učitati konfiguracionu datoteku za uvoz procesa u vaš sistem. Datoteka mora biti u .yml formatu izvezena od strane modula za upravljanje procesom.',
        'Upload process configuration' => 'Učitaj konfiguraciju procesa',
        'Import process configuration' => 'Uvezi konfiguraciju procesa',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'Za kreiranje novog procesa možete ili uvesti proces koji je izvezen iz drugog sistema ili kreirati kompletno nov.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Promene u procesima jedino utiču na ponašanje sistema, ako sinhronizujete podatke procesa. Sinhronizovanjem procesa, novonapravljene promene će biti upisane u konfiguraciju.',
        'Process name' => 'Naziv procesa',
        'Print' => 'Štampaj',
        'Export Process Configuration' => 'Izvezi konfiguraciju procesa',
        'Copy Process' => 'Kopiraj proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Poništi & zatvori prozor',
        'Go Back' => 'Vrati se nazad',
        'Please note, that changing this activity will affect the following processes' =>
            'Napominjemo da će izmene ove aktivnosti uticati na prateće procese.',
        'Activity' => 'Aktivnost',
        'Activity Name' => 'Naziv aktivnosti',
        'Activity Dialogs' => 'Dijalozi aktivnosti',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Dijaloge aktivnosti možete dodeliti ovoj aktivnosti prevlačenjem elemenata mišem od leve liste do desne liste.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Menjanje redosleda elemenata unutar liste je, takođe, moguće prevračenjem elemenata i puštanjem.',
        'Filter available Activity Dialogs' => 'Filtriraj slobodne dijaloge aktivnosti',
        'Available Activity Dialogs' => 'Slobodni dijalozi aktivnosti',
        'Create New Activity Dialog' => 'Kreiraj nov dijalog aktivnosti',
        'Assigned Activity Dialogs' => 'Dodeljeni dijalozi aktivnosti',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            'Ukoliko koristite ovo dugme ili vezu, napustićete ekran i njegov trenutni sadržaj će biti automatski sačuvan. Želite li da nastavite?',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            'Napominjemo da će promena ovog dijaloga aktivnosti uticati na prateće aktivnosti.',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            'Napominjemo da korisnici korisnika nisu u mogućnosti da vide ili koriste sledeća polja: Vlasnik, Odgovorno, Zaključano, Vreme na čekanju i ID korisnika',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            'Polje u redu jedino može biti korišćeno od strane korisnika kada kreiraju novi tiket.',
        'Activity Dialog' => 'Dijalog aktivnosti',
        'Activity dialog Name' => 'Naziv dijaloga aktivnosti',
        'Available in' => 'Raspoloživo u',
        'Description (short)' => 'Opis (kratak)',
        'Description (long)' => 'Opis (dugačak)',
        'The selected permission does not exist.' => 'Izabrana ovlašćenja ne postoje.',
        'Required Lock' => 'Obavezno zaključaj',
        'The selected required lock does not exist.' => 'Odabrano zahtevano zaključavanje ne postoji.',
        'Submit Advice Text' => 'Podnesi "Advice Text"',
        'Submit Button Text' => 'Podnesi "Button Text"',
        'Fields' => 'Polja',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            'Polja možete dodeliti u ovom dijalogu aktivnosti prevlačenjem elemenata mišem iz leve liste u desnu listu.',
        'Filter available fields' => 'Filtriraj raspoloživa polja',
        'Available Fields' => 'Raspoloživa polja',
        'Assigned Fields' => 'Dodeljena polja',
        'Edit Details for Field' => 'Uredi detalje za polje',
        'ArticleType' => 'TipČlanka',
        'Display' => 'Prikaži',
        'Edit Field Details' => 'Uredi detalje polja',
        'Customer interface does not support internal article types.' => 'Korisnički interfejs ne podržava unutrašnje tipove članka.',

        # Template: AdminProcessManagementPath
        'Path' => 'Putanja',
        'Edit this transition' => 'Uredite ovu tranziciju',
        'Transition Actions' => 'Tranzicione aktivnosti',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            'Možete dodeliti tranzicione aktivnosti u ovoj tranziciji prevlačenjem elemenata mišem iz leve liste u desnu listu.',
        'Filter available Transition Actions' => 'Filtriraj raspoložive tranzicione aktivnosti',
        'Available Transition Actions' => 'Raspoložive tranzicione aktivnosti',
        'Create New Transition Action' => 'Kreiraj novu tranzicionu aktivnost',
        'Assigned Transition Actions' => 'Dodeljene tranzicione aktivnosti',

        # Template: AdminProcessManagementPopupResponse

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Aktivnosti',
        'Filter Activities...' => 'Filtriraj aktivnosti ...',
        'Create New Activity' => 'Kreiraj novu aktivnost',
        'Filter Activity Dialogs...' => 'Filtriraj dijaloge aktivnosti ...',
        'Transitions' => 'Tranzicije',
        'Filter Transitions...' => 'Filtriraj tranzicije ...',
        'Create New Transition' => 'Kreiraj novu tranziciju',
        'Filter Transition Actions...' => 'Filtriraj tranzicione aktivnosti ...',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Uredi proces',
        'Print process information' => 'Štampaj informacije procesa',
        'Delete Process' => 'Izbriši proces',
        'Delete Inactive Process' => 'Izbriši neaktivan proces',
        'Available Process Elements' => 'Raspoloživi elementi procesa',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            'Elementi, navedeni gore u izdvojenom odeljku, mogu da se pomeraju po površini na desnu stranu korišćenjem prevuci i pusti tehnike.',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            'Možete postaviti aktivnosti na povrsinu kako bi dodeliti ovu aktivnost procesu.',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            'Za dodeljivanje Dijaloga Aktivnosti nekoj aktivnosti, prevucite element dijaloga aktivnosti iz izdvojenog dela, preko aktivnosti smeštene na površini.',
        'You can start a connection between to Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            'Vezu između aktivnosti možete započeti prevlačenjem elementa tranzicije preko početka aktivnosti veze. Nakon toga možete da premestite slobodan kraj strelice do kraja aktivnosti',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            'Aktivnost može biti dodeljena tranziciji prevlačenjem elementa aktivnosti na oznaku tranzicije.',
        'Edit Process Information' => 'Uredi informacije procesa',
        'The selected state does not exist.' => 'Odabrani status ne postoji.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => 'Dodaj i uredi aktivosti, dijaloge aktivnosti i tranzicije',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => 'Proširi širinu prostora',
        'Extend the height of the Canvas' => 'Produži visinu prostora',
        'Remove the Activity from this Process' => 'Ukloni aktivnost iz ovog procesa',
        'Edit this Activity' => 'Uredi ovu aktivnost',
        'Save settings' => 'Sačuvaj podešavanja',
        'Save Activities, Activity Dialogs and Transitions' => 'Sačuvaj aktivosti, dijaloge aktivnosti i tranzicije',
        'Do you really want to delete this Process?' => 'Da li zaista želite da obrišete ovaj proces?',
        'Do you really want to delete this Activity?' => 'Da li zaista želite da obrišete ovu aktivnost?',
        'Do you really want to delete this Activity Dialog?' => 'Da li zaista želite da obrišete ovaj dijalog aktivnosti?',
        'Do you really want to delete this Transition?' => 'Da li zaista želite da obrišete ovu tranziciju?',
        'Do you really want to delete this Transition Action?' => 'Da li zaista želite da obrišete ovu tranzicionu aktivnost?',
        'Do you really want to remove this activity from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Da li zaista želite da uklonite ovu aktivnost sa površine? Ovo jedino može da se opozove ukoliko napustite ekran, a da prethodno ne sačuvate izmene.',
        'Do you really want to remove this transition from the canvas? This can only be undone by leaving this screen without saving.' =>
            'Da li zaista želite da uklonite ovu tranziciju sa površine? Ovo jedino može da se opozove ukoliko napustite ekran, a da prethodno ne sačuvate izmene.',
        'Hide EntityIDs' => 'Sakrij ID-ove objekta',
        'Delete Entity' => 'Izbriši objekat',
        'Remove Entity from canvas' => 'Ukloni objekat sa površine',
        'This Activity is already used in the Process. You cannot add it twice!' =>
            'Ova aktivnost je već korišćena u procesu. Ne možete je dodavati dva puta.',
        'This Activity cannot be deleted because it is the Start Activity.' =>
            'Ova aktivnost se ne može brisati, zato što je to početak aktivnosti.',
        'This Transition is already used for this Activity. You cannot use it twice!' =>
            'Ova tranzicija je već korišćena za ovu aktivnost. Ne možete je koristiti dva puta.',
        'This TransitionAction is already used in this Path. You cannot use it twice!' =>
            'Ova tranziciona tktivnost je već korišćena u ovoj putanji. Ne možete je koristiti dva puta.',
        'Remove the Transition from this Process' => 'Ukloni tranziciju iz ovog procesa',
        'No TransitionActions assigned.' => 'Nema dodeljenih tranzicionih aktivnosti.',
        'The Start Event cannot loose the Start Transition!' => 'Početak događaja ne može izgubiti početak tranzicije.',
        'No dialogs assigned yet. Just pick an activity dialog from the list on the left and drag it here.' =>
            'Još uvek nema dodeljenih dijaloga. Samo izaberite jedan dijalog aktivnosti iz liste sa leve strane i prevucite ga ovde.',
        'An unconnected transition is already placed on the canvas. Please connect this transition first before placing another transition.' =>
            'Nepovezana tranzicija je već postavljena na površinu. Molimo povežite prvu tranziciju pre nego što postavite drugu tranziciju.',

        # Template: AdminProcessManagementProcessNew
        'In this screen, you can create a new process. In order to make the new process available to users, please make sure to set its state to \'Active\' and synchronize after completing your work.' =>
            'U ovom ekranu možete kreirati novi proces. Da bi novi proces bio dostupan korisnicima, molimo vas da postavite status na \'Active\' i uradite sinhronizaciju nakon završetka vašeg rada.',

        # Template: AdminProcessManagementProcessPrint
        'Start Activity' => 'Početak aktivnosti',
        'Contains %s dialog(s)' => 'Sadrži %s dijaloga',
        'Assigned dialogs' => 'Dodeljeni dijalozi',
        'Activities are not being used in this process.' => 'Aktivnosti se ne koriste u ovom procesu.',
        'Assigned fields' => 'Dodeljena polja',
        'Activity dialogs are not being used in this process.' => 'Dijalozi aktivnosti se ne koriste u ovom procesu.',
        'Condition linking' => 'Uslov povezivanja',
        'Conditions' => 'Uslovi',
        'Condition' => 'Uslov',
        'Transitions are not being used in this process.' => 'Tranzicije se ne koriste u ovom procesu.',
        'Module name' => 'Naziv modula',
        'Configuration' => 'Konfiguracija',
        'Transition actions are not being used in this process.' => 'Tranzicione aktivnosti se ne koriste u ovom procesu.',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            'Napominjemo da bi menjenje ove tranzicije uticalo na prateće procese',
        'Transition' => 'Tranzicija',
        'Transition Name' => 'Naziv tranzicije',
        'Type of Linking between Conditions' => 'Tip veze između uslova',
        'Remove this Condition' => 'Ukloni ovaj uslov',
        'Type of Linking' => 'Tip veze',
        'Remove this Field' => 'Ukloni ovo polje',
        'Add a new Field' => 'Dodaj novo polje',
        'Add New Condition' => 'Dodaj novi Uslov',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            'Napominjemo da bi menjenje ove tranzicione aktivnosti uticalo na prateće procese',
        'Transition Action' => 'Tranziciona aktivnost',
        'Transition Action Name' => 'Naziv tranzicione aktivnosti',
        'Transition Action Module' => 'Modul tranzicione aktivnosti',
        'Config Parameters' => 'Konfiguracioni parametri',
        'Remove this Parameter' => 'Ukloni ovaj parametar',
        'Add a new Parameter' => 'Dodaj novi parametar',

        # Template: AdminQueue
        'Manage Queues' => 'Upravljanje redovima',
        'Add queue' => 'Dodaj red',
        'Add Queue' => 'Dodaj Red',
        'Edit Queue' => 'Uredi Red',
        'Sub-queue of' => 'Pod-red od',
        'Unlock timeout' => 'Vreme do otključavanja',
        '0 = no unlock' => '0 = nema otključavanja',
        'Only business hours are counted.' => 'Računa se samo radno vreme.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Ako operater zaključa tiket i ne otključa ga pre isteka vremena otključavanja, tiket će se otključati i postati dostupan drugim zaposlenima.',
        'Notify by' => 'Obavešten od',
        '0 = no escalation' => '0 = nema eskalacije',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Ako kontakt sa korisnikom, bilo spoljašnji email ili telefon, nije dodat na novi tiket pre isticanja definisanog vremena, tiket će eskalirati.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Ako postoji dodat članak, kao npr. follow-up preko email poruke ili korisničkog portala, vreme ažuriranja eskalacije se resetuje. Ako ne postoje kontakt podaci o korisniku, bilo email ili telefon dodati na tiket pre isticanja ovde definisanog vremena, tiket eskalira.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Ako se tiket ne zatvori pre ovde definisanog vremena, tiket eskalira.',
        'Follow up Option' => 'Opcije nastavka',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Definišite da li nastavak na zatvoreni tiket ponovo otvara tiket ili otvara novi.',
        'Ticket lock after a follow up' => 'Zaključavanje tiketa posle nastavka',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Ako je tiket zatvoren, a korisnik pošalje nastavak, tiket će biti zaključan na starog vlasnika.',
        'System address' => 'Sistemska adresa',
        'Will be the sender address of this queue for email answers.' => 'Biće adresa pošiljaoca za email odgovore iz ovog reda.',
        'Default sign key' => 'Podrazumevani ključ potpisa',
        'The salutation for email answers.' => 'Pozdrav za email odgovore.',
        'The signature for email answers.' => 'Potpis za email odgovore.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Upravljanje odnosima Red-Automatski odgovor',
        'Filter for Queues' => 'Filter za redove',
        'Filter for Auto Responses' => 'Filter za Automatske odgovore',
        'Auto Responses' => 'Automatski odgovori',
        'Change Auto Response Relations for Queue' => 'Promeni veze sa Automatskim odgovorima za Red',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Upravljanje odnosom Šablon-Red',
        'Filter for Templates' => 'Filter za Šablone',
        'Templates' => 'Šabloni',
        'Change Queue Relations for Template' => 'Promena odnosa Reda za Šablon',
        'Change Template Relations for Queue' => 'Promena odnosa Šablona za Red',

        # Template: AdminRegistration
        'System Registration Management' => 'Upravljanje sistemom registracije',
        'Edit details' => 'Uredi detalje',
        'Overview of registered systems' => 'Pregled registrovanih sistema',
        'Deregister system' => 'Odjavi sistem',
        'System Registration' => 'Registracija sistema',
        'This system is registered with OTRS Group.' => 'Ovaj sistem je registrovan u OTRS Grupi.',
        'System type' => 'Tip sistema',
        'Unique ID' => 'Jedinstveni ID',
        'Last communication with registration server' => 'Poslednja komunikacija sa registracionim serverom',
        'Send support data' => 'Pošalji podatke za podršku',
        'System registration not possible' => '',
        'Please note that you can\'t register your system if your scheduler is not running correctly!' =>
            '',
        'OTRS-ID Login' => 'OTRS-ID prijava',
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'Registracija sistema je usluga OTRS Grupe, koja obezbeđuje mnoge prednosti.',
        'Read more' => 'Pročitaj više',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Potrebno je da se prijavite sa vašim OTRS-ID da registrujete vaš sistem.',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Vaš OTRS-ID je email adresa koju koristite za prijavu na web stranu OTRS.com.',
        'Data Protection' => 'Zaštita podataka',
        'What are the advantages of system registration?' => 'Koje su prednosti registracije sistema?',
        'You will receive updates about relevant security releases.' => 'Dobićete ažuriranja odgovarajućih bezbednosnih izdanja.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Sa registracijom sistema možemo poboljšati naše usluge za vas, jer mi imamo dostupne sve relevantne informacije.',
        'This is only the beginning!' => 'Ovo je samo početak!',
        'We will inform you about our new services and offerings soon.' =>
            'Informisaćemo vas o našim novim uslugama i ponudama uskoro!',
        'Can I use OTRS without being registered?' => 'Da li mogu da koristim OTRS ukoliko nisam registrovan?',
        'System registration is optional.' => 'Registracija sistema je opcionalna.',
        'You can download and use OTRS without being registered.' => 'Možete preuzeti OTRS i ukoliko niste registrovani.',
        'Is it possible to deregister?' => 'Da li je moguća odjava?',
        'You can deregister at any time.' => 'Možete se odjaviti u bilo koje doba.',
        'Which data is transfered when registering?' => 'Koji podaci se prenose prilikom registracije?',
        'A registered system sends the following data to OTRS Group:' => 'Registrovani sistem šalje sledeće podatke OTRS Grupi:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Potpuno kvalifikovano domensko ime (FQDN), OTRS verziju, Bazu podataka, Operativni sistem i Perl verziju.',
        'Why do I have to provide a description for my system?' => 'Zašto moram da prosledim opis mog sistema?',
        'The description of the system is optional.' => 'Opis sistema je opcioni',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Navedeni opis i tip sistema pomažu vam da identifikujete i upravljate detaljima registrovanog sistema.',
        'How often does my OTRS system send updates?' => 'Koliko često će moj OTRS sistem slati ažuriranja?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Vaš sistem će u redovnim vremenskim intervalima slati ažuriranja registracionom serveru.',
        'Typically this would be around once every three days.' => 'Obično je to jednom u svaka tri dana.',
        'In case you would have further questions we would be glad to answer them.' =>
            'U slučaju da imate dodtana pitanja, biće nam zadovoljstvo da odgovorimo na njih.',
        'Please visit our' => 'Molimo posetite naš',
        'portal' => 'portal',
        'and file a request.' => 'i podnesite zahtev',
        'Here at OTRS Group we take the protection of your personal details very seriously and strictly adhere to data protection laws.' =>
            'Ovde u OTRS Grupi mi uzimamo u zaštitu vaše lične podatke, veoma ozbiljno i strogo se pridržavamo zakona o zaštiti podataka.',
        'All passwords are automatically made unrecognizable before the information is sent.' =>
            'Sve lozinke automatski postaju nevidljive pre slanja informacija. ',
        'Under no circumstances will any data we obtain be sold or passed on to unauthorized third parties.' =>
            'Podaci koje dobijamo, ni pod kakvim okolnostima, neće biti prodati, niti prosleđeni trećim stranama.',
        'The following explanation provides you with an overview of how we guarantee this protection and which type of data is collected for which purpose.' =>
            'Sledeće objašnjenje vam pruža prikaz toga kako mi garantujemo ovu zaštitu i koja vrsta podataka se prikuplja u kakve svrhe.',
        'Data Handling with \'System Registration\'' => 'Rukovanje podacima sa \'System Registration\'',
        'Information received through the \'Service Center\' is saved by OTRS Group.' =>
            'OTRS Grupa čuva informacije primljene preko \'Service Center\'',
        'This only applies to data that OTRS Group requires to analyze the performance and function of the OTRS server or to establish contact.' =>
            'Ovo se odnosi samo na podatke koje "OTRS Group" zahteva za analizu performansi i funkcije OTRS servera ili da bi se uspostavio kontakt.',
        'Safety of Personal Details' => 'Sigurnosni ili lični detalji',
        'OTRS Group protects your personal data from unauthorized access, use or publication.' =>
            '"OTRS Group" štiti vaše lične podatke od neautorizovanog pristupa, korišćenja ili objavljivanja.',
        'OTRS Group ensures that the personal information you store on the server is protected from unauthorized access and publication.' =>
            'OTRS Grupa obezbeđuje da vaši lični podaci sačuvani na serveru budu zaštićeni od neautorizovanog pristupa i objavljivanja.',
        'Disclosure of Details' => 'Otkrivanje detalja',
        'OTRS Group will not pass on your details to third parties unless required for business transactions.' =>
            'OTRS Grupa neće preneti vaše detalje trećim stranama, osim ako je potrebno za poslovne transakcije.',
        'OTRS Group will only pass on your details to entitled public institutions and authorities if required by law or court order.' =>
            'OTRS Grupa će preneti vaše detalje samo javnim institucijama i organima koji imaju pravo da ih traže, ukoliko je zahtevano zakonodavnim ili sudskim nalogom. ',
        'Amendment of Data Protection Policy' => 'Izmena politike zaštite podataka',
        'OTRS Group reserves the right to amend this security and data protection policy if required by technical developments.' =>
            'OTRS Grupa zadržava pravo da izmeni ovu bezbednosnu politiku i politiku zaštite podataka, u slučaju zahteva tehničkog razvoja.',
        'In this case we will also adapt our information regarding data protection accordingly.' =>
            'U tom slučaju takođe ćemo i prilagoditi naše informacije u vezi zaštite podataka.',
        'Please regularly refer to the latest version of our Data Protection Policy.' =>
            'Molimo vas da se redovno vraćate na poslednju verziju naše Politike zaštite podataka. ',
        'Right to Information' => 'Pravo na informisanje',
        'You have the right to demand information concerning the data saved about you, its origin and recipients, as well as the purpose of the data processing at any time.' =>
            'Vi imate prava da u bilo koje vreme zahtevate informacije o sačuvanim podacima o vama, njihovo poreklo i primaoce, kao i svrhu obrade podataka.',
        'You can request information about the saved data by sending an e-mail to info@otrs.com.' =>
            'Informacije o sačuvanim podacima možete zahtevati slanjem e-mail-a na adresu info@otrs.com.',
        'Further Information' => 'Dodatne informacije',
        'Your trust is very important to us. We are willing to inform you about the processing of your personal details at any time.' =>
            'Vaše poverenje nama je veoma važno. Mi smo spremni da vas obavestimo o obradi vaših ličnih podataka u bilo kom trenutku.',
        'If you have any questions that have not been answered by this Data Protection Policy or if you require more detailed information about a specific topic, please contact info@otrs.com.' =>
            'Ukoliko imate bilo kakva pitanja na koja nisu odgovorili u Politici o zaštiti podataka ili ako su vam potrebne detaljnije informacije o određenoj temi, kontaktirajte info@otrs.com',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Da bi ste odjavili vaš sistem, morate da se prijavite sa vašim OTRS-ID',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Još uvek nemate OTRS-ID?',
        'Sign up now' => 'Regisrujte se sada',
        'Forgot your password?' => 'Zaboravili ste lozinku?',
        'Retrieve a new one' => 'Preuzmi novu',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Ovi podaci će biti preneti u "OTRS Group" kada registrujete ovaj sistem.',
        'Attribute' => 'Atribut',
        'FQDN' => 'FQDN',
        'Optional description of this system.' => 'Opcioni opis ovog sistema',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Ovo će omogućiti sistemu da pošalje dodatne informacije o podršci podataka u OTRS Grupa.',
        'Service Center' => 'Servisni centar',
        'Support Data Management' => 'Podrška za upravljanje podacima',
        'Register' => 'Registruj',
        'Deregister System' => 'Odjavi sistem',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Nastavljanje ovog koraka će odjaviti sistem iz OTRS Grupa.',
        'Deregister' => 'Odjavi',
        'You can modify registration settings here.' => 'Ovde možete modifikovati registraciona podešavanja.',

        # Template: AdminRole
        'Role Management' => 'Upravljanje ulogama',
        'Add role' => 'Dodaj ulogu',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Napravi ulogu i dodaj grupe u nju. Onda dodaj ulogu korisnicima.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Nema definisanih uloga. upotrebite dugme \'Add\' za kreiranje nove uloge.',
        'Add Role' => 'Dodaj Ulogu',
        'Edit Role' => 'Uredi Ulogu',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Upravljanje vezama Uloga-Grupa',
        'Filter for Roles' => 'Filter za uloge',
        'Select the role:group permissions.' => 'Izaberi dozvole za ulogu:grupu',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Ukoliko ništa nije izabrano, onda nema dozvola u ovoj grupi (tiketi neće biti dostupni za ovu ulogu).',
        'Change Role Relations for Group' => 'Promeni veze sa ulogama za grupu',
        'Change Group Relations for Role' => 'Promeni veze sa grupama za ulogu',
        'Toggle %s permission for all' => 'Promeni %s dozvole za sve',
        'move_into' => 'premesti u',
        'Permissions to move tickets into this group/queue.' => 'Dozvola da se tiket premesti u ovu grupu/red.',
        'create' => 'kreiranje',
        'Permissions to create tickets in this group/queue.' => 'Dozvola da se tiket kreira u ovoj grupi/redu.',
        'priority' => 'prioritet',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Dozvola da se menja prioritet tiketa u ovoj grupi/redu.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Upravljanje vezama Operater-Uloga',
        'Filter for Agents' => 'Filter za operatere',
        'Manage Role-Agent Relations' => 'Upravljanje vezama Operater-Uloga',
        'Change Role Relations for Agent' => 'Promeni veze sa ulogom za operatera',
        'Change Agent Relations for Role' => 'Promeni veze sa operaterom za ulogu',

        # Template: AdminSLA
        'SLA Management' => 'Upravljanje SLA',
        'Add SLA' => 'Dodaj SLA',
        'Edit SLA' => 'Uredi SLA',
        'Please write only numbers!' => 'Molimo pišite samo brojeve!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME upravljanje',
        'Add certificate' => 'Dodaj sertifikat',
        'Add private key' => 'Dodaj privatni ključ',
        'Filter for certificates' => 'Filter za sertifikate',
        'Filter for S/MIME certs' => '',
        'To show certificate details click on a certificate icon.' => 'Za prikazivanje detalja sertifikata klikni na ikonicu sertifikat.',
        'To manage private certificate relations click on a private key icon.' =>
            'Za upravljanje vezama privatnog sertifikata kliknite na ikonicu privatni ključ.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Pogledaj još',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Na ovaj način možete direktno da uređujete sertifikate i privatne ključeve u sistemu datoteka.',
        'Hash' => 'Hash',
        'Handle related certificates' => 'Rukovanje povezanim sertifikatima',
        'Read certificate' => 'Čitaj sertifikat',
        'Delete this certificate' => 'Obriši ovaj sertifikat',
        'Add Certificate' => 'Dodaj sertifikat',
        'Add Private Key' => 'Dodaj privatni ključ',
        'Secret' => 'Tajna',
        'Related Certificates for' => 'Povezani sertifikati za',
        'Delete this relation' => 'Obriši ovu vezu',
        'Available Certificates' => 'Raspoloživi sertifikati',
        'Filter for SMIME certs' => 'Filter za SMIME sertifikate',
        'Relate this certificate' => 'Poveži ovaj sertifikat',

        # Template: AdminSMIMECertRead
        'Close window' => 'Zatvori prozor',
        'Certificate details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Upravljanje pozdravima',
        'Add salutation' => 'Dodaj pozdrav',
        'Add Salutation' => 'Dodaj Pozdrav',
        'Edit Salutation' => 'Uredi Pozdrav',
        'Example salutation' => 'Primer pozdrava',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            'Ova opcija će prinuditi Planer da se pokrene čak i ako je proces još uvek registrovan u bazi',
        'Start scheduler' => 'Pokreni planer proces',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            'Planer ne može biti pokrenut. Proverite da li planer već radi i pokušajte ponovo pomoću opcije za prinudno pokretanje',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Potrebno je da siguran mod bude uključen!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Siguran mod će (uobičajeno) biti podešen nakon inicijalne instalacije.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Ukoliko siguran mod nije aktiviran, pokrenite ga kroz sistemsku konfiguraciju jer je vaša aplikacija već pokrenuta.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Ovde možete uneti SQL komande i poslati ih direktno aplikacionoj bazi podataka. Nije moguće menjati sadržaj tabela, dozvoljen je jedino select upit.',
        'Here you can enter SQL to send it directly to the application database.' =>
            '',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Postoji greška u sintaksi vašeg SQL upita. Molimo proverite.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Najmanje jedan parametar nedostaje za povezivanje. Molimo proverite.',
        'Result format' => 'Format rezultata',
        'Run Query' => 'Pokreni upit',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => 'Upravljanje servisima',
        'Add service' => 'Dodaj servis',
        'Add Service' => 'Dodaj Servis',
        'Edit Service' => 'Uredi Servis',
        'Sub-service of' => 'Pod-servis od',

        # Template: AdminServiceCenterSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            'Ovi podaci se šalju OTRS Grupi po regularnoj osnovi. Da zaustavite slanje ovih podataka molimo vas da ažurirate registraciju.',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            'Možete manuelno aktivirati slanje podržanih podataka pritiskanjem ovog dugmeta:',
        'Send Update' => 'Pošalji ažuriranje',
        'Sending Update...' => 'Slanje ažuriranja...',
        'Support Data information was successfully sent.' => 'Informacije podržanih podataka su uspešno poslate.',
        'Was not possible to send Support Data information.' => 'Nije moguće poslati informacije podržanih podataka.',
        'Update Result' => 'Rezultat ažuriranja',
        'Currently this data is only shown in this system.' => 'Trenutno su ovi podaci prikazani samo u ovom sistemu.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Preporučuje se da ove podatke pošaljete OTRS Grupi da bi ste dobili bolju podršku.',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'Da bi ste onemogućili slanje podataka, molimo vas da registrujete vaš sistem u OTRS Grupi ili da ažurirate informacije sistemske registracije (budite sigurni da ste aktivirali opciju \'send support data\'.).',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => '',
        'Generating...' => '',
        'It was not possible to generate the Support Bundle.' => '',
        'Generate Result' => '',
        'Support Bundle' => '',
        'The mail could not be sent' => '',
        'The support bundle has been generated.' => '',
        'Please choose one of the following options.' => '',
        'Send by Email' => '',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            '',
        'The email address for this user is invalid, this option has been disabled.' =>
            '',
        'Sending' => '',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Support Data' => 'Podržani podaci',
        'Error: Support data could not be collected (%s).' => 'Podržani podaci ne mogu biti prikupljeni (%s).',

        # Template: AdminSession
        'Session Management' => 'Upravljanje sesijama',
        'All sessions' => 'Sve sesije',
        'Agent sessions' => 'Sesije operatera',
        'Customer sessions' => 'Sesije korisnika',
        'Unique agents' => 'Jedinsveni operater',
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
        'Please also update the states in SysConfig where needed.' => 'Molimo da ažurirate stause i u "SysConfig" (Sistemskim konfiguracijama) gde je to potrebno.',
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
        'Please enter a search term to look for settings.' => 'Molimo unesite pojam pretrage za traženje podešavanja.',
        'Subgroup' => 'Podgrupa',
        'Elements' => 'Elementi',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Uredi konfiguraciona podešavanja',
        'This config item is only available in a higher config level!' =>
            'Ova konfiguraciona stavka je dostupna samo na višem konfiguracionom nivou',
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
        'Loader' => 'Program za učitavanje',
        'File to load for this frontend module' => 'Datoteka koju treba učitati za ovaj korisnički modul',
        'New Loader File' => 'Nova datoteka programa za učitavanje',
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
        'Show more' => 'Prikaži više',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Upravljanje sistemskom email adresom',
        'Add system address' => 'Dodaj sistemsku adresu',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Sve dolazne poruke sa ovom adresom u polju "Za" ili "Cc" biće otpremljene u izabrani red.',
        'Email address' => 'Email adresa',
        'Display name' => 'Prikaži ime',
        'Add System Email Address' => 'Dodaj sistemsku email adresu',
        'Edit System Email Address' => 'Uredi sistemsku email adresu',
        'The display name and email address will be shown on mail you send.' =>
            'Prikazano ime i email adresa će biti prikazani na poruci koju ste poslali.',

        # Template: AdminTemplate
        'Manage Templates' => 'Upravljanje šablonima',
        'Add template' => 'Dodaj šablon',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'Šablon je podrazumevani tekst koji pomaže vašim agentima da brže ispišu tikete, odgovore ili prosleđene poruke.',
        'Don\'t forget to add new templates to queues.' => 'Ne zaboravite da dodate novi šablon u redu.',
        'Add Template' => 'Dodaj Šablon',
        'Edit Template' => 'Uredi Šablon',
        'A standard template with this name already exists!' => '',
        'Template' => 'Šablon',
        'Create type templates only supports this smart tags' => 'Kreiraj tip šablona koji podržavaju samo ove pametne oznake.',
        'Example template' => 'Primer šablona',
        'The current ticket state is' => 'Trenutni staus tiketa je',
        'Your email address is' => 'Vaša email adresa je',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Upravljanje šablonima',
        'Filter for Attachments' => 'Filter za priloge',
        'Change Template Relations for Attachment' => 'Promeni veze šablona za prilog',
        'Change Attachment Relations for Template' => 'Promeni veze priloga za šablon',
        'Toggle active for all' => 'Promeni stanje u aktivan za sve',
        'Link %s to selected %s' => 'Poveži %s sa izabranim %s',

        # Template: AdminType
        'Type Management' => 'Upravljanje tipovima',
        'Add ticket type' => 'Dodaj tip tiketa',
        'Add Type' => 'Dodaj Tip',
        'Edit Type' => 'Uredi Tip',

        # Template: AdminUser
        'Add agent' => 'Dodaj operatera',
        'Agents will be needed to handle tickets.' => 'Potrebni su operateri za obradu tiketa.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Ne zaboravite da dodate novog operatera u grupe i/ili uloge!',
        'Please enter a search term to look for agents.' => 'Molimo unesite pojam za pretragu radi nalaženja operatera.',
        'Last login' => 'Prethodna prijava',
        'Switch to agent' => 'Pređi na operatera',
        'Add Agent' => 'Dodaj Operatera',
        'Edit Agent' => 'Uredi Operatera',
        'Firstname' => 'Ime',
        'Lastname' => 'Prezime',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => 'Biće automatski generisano ako se ostavi prazno.',
        'Start' => 'Početak',
        'End' => 'Kraj',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Upravljanje vezama Operater-Grupa',
        'Change Group Relations for Agent' => 'Promeni veze sa grupom za operatera',
        'Change Agent Relations for Group' => 'Promeni veze sa operaterom za grupu',
        'note' => 'napomena',
        'Permissions to add notes to tickets in this group/queue.' => 'Dozvole za dodavanje napomena na tikete u ovoj grupi/redu.',
        'owner' => 'vlasnik',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Dozvole za promenu vlasnika tiketa u ovoj grupi/redu.',

        # Template: AgentBook
        'Address Book' => 'Adresar',
        'Search for a customer' => 'Traži korisnika',
        'Add email address %s to the To field' => 'Dodaj email adresu %s u polje "Za:"',
        'Add email address %s to the Cc field' => 'Dodaj email adresu %s u polje "Cc:"',
        'Add email address %s to the Bcc field' => 'Dodaj email adresu %s u polje "Bcc:"',
        'Apply' => 'Primeni',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Korisnički informativni centar',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'ID korisnika',
        'Customer User' => 'Korisnik',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Dvostruki unos',
        'This address already exists on the address list.' => 'Ova adresa već postoji u listi',
        'It is going to be deleted from the field, please try again.' => 'Biće obrisano iz polja, molimo pokušajte ponovo.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Napomena: Korisnik je nevažeći',

        # Template: AgentDashboard
        'Dashboard' => 'Komandna tabla',

        # Template: AgentDashboardCalendarOverview
        'in' => 'u',

        # Template: AgentDashboardCommon
        'Available Columns' => 'Raspoložive kolone',
        'Visible Columns (order by drag & drop)' => 'Vidljive kolone (redosled prema prevuci i pusti)',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eskalirani tiketi',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Informacije o korisniku',
        'Phone ticket' => 'Telefonski tiket',
        'Email ticket' => 'E-mail tiket',
        '%s open ticket(s) of %s' => '%s otvorenih tiketa od %s',
        '%s closed ticket(s) of %s' => '%s zatvorenih tiketa od %s',
        'New phone ticket from %s' => 'Novi telefonski tiket od %s',
        'New email ticket to %s' => 'Novi e-mail tiket od %s',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s je dostupno!',
        'Please update now.' => 'Molimo ažurirajte sada.',
        'Release Note' => 'Napomena uz izdanje',
        'Level' => 'Nivo',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Poslato pre %s.',

        # Template: AgentDashboardStats
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Sadržaj ove statistike se priprema za vas, molimo budite strpljivi.',
        'Grouped' => 'Grupisano',
        'Stacked' => 'Naslagano',
        'Expanded' => 'Prošireno',
        'Stream' => 'Protok',
        'CSV' => 'CSV',
        'PDF' => 'PDF',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Moji zaključani tiketi',
        'My watched tickets' => 'Moji praćeni tiketi',
        'My responsibilities' => 'Odgovoran sam za',
        'Tickets in My Queues' => 'Tiketi u mojim redovima',
        'Service Time' => 'Servisno vreme',
        'Remove active filters for this widget.' => 'Ukloni aktivne filtere za ovaj aplikativni dodatak (widget).',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Ukupne vrednosti',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => 'Van kancelarije',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'dok',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Tiket je zaključan.',
        'Undo & close window' => 'Odustani & zatvori prozor',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'Da bi prihvatili neke vesti, dozvole ili neke promene.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Poveži objekt: %s',
        'go to link delete screen' => 'idi na ekran za brisanje veze',
        'Select Target Object' => 'Izaberi ciljni objekat',
        'Link Object' => 'Poveži objekat',
        'with' => 'sa',
        'Unlink Object: %s' => 'Prekini vezu sa objektom: %s',
        'go to link add screen' => 'idi na ekran za dodavanje veze',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Uredi lične postavke',

        # Template: AgentSpelling
        'Spell Checker' => 'Provera pravopisa',
        'spelling error(s)' => 'Pravopisne greške',
        'Apply these changes' => 'Primeni ove izmene',

        # Template: AgentStatsDelete
        'Delete stat' => 'Obriši statistiku',
        'Stat#' => 'Statistika#',
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
            'Možete izabrati jednu ili više grupa za definisanje pristupa za različite operatere.',
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
            'Većina statističkih podataka se može keširati. Ovo će ubrzati prikaz statistike.',
        'Show as dashboard widget' => 'Prikaži kontrolnu tablu aplikativnog dodatka (Widget-a)',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Obezbedi statistiku kao aplikativni dodatak (widget), koji operateri mogu aktivirati putem svoje kontrolne table.',
        'Please note' => 'Napominjemo',
        'Enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Omogućavanje kontrolnoj tabli aplikativnog dodatka (widget-a) da aktivira keširanje za ovu statistiku u kontrolnoj tabli.',
        'Agents will not be able to change absolute time settings for statistics dashboard widgets.' =>
            'Operateri neće moći da promene podešavanja apsolutnog vremena za statistike kontrolne table aplikativnih dodataka (widget-a).',
        'IE8 doesn\'t support statistics dashboard widgets.' => 'IE8 ne podržava statistike kontrolne table aplikativnih dodataka (widget-a).',
        'If set to invalid end users can not generate the stat.' => 'Ako je podešeno na nevažeće, krajnji korisnici ne mogu generisati statistiku.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Ovde možete definisati opsege vrednosti.',
        'You have the possibility to select one or two elements.' => 'Imate mogućnost da izaberete jedan ili dva elementa.',
        'Then you can select the attributes of elements.' => 'Onda možete izabrati atribute za elemente.',
        'Each attribute will be shown as single value series.' => 'Svaki atribut će biti prikazan kao pojedinačni opseg vrednosti.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Ako ne izaberete ni jedan atribut, prilikom generisanja statistike biće upotrebljeni svi atributi elementa kao i atributi dodani nakon poslednje konfiguracije.',
        'Scale' => 'Skala',
        'minimal' => 'minimalno',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Molimo zapamtite, da skala za opsege vrednosti moda da bude veća od skale za X-Osu (npr. X-Osa => mesec; Vrednost opsega => godina).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Ovde možete definisati x-osu. Možete izabrati jedan element od ponuđenih.',
        'maximal period' => 'maksimalni period',
        'minimal scale' => 'minimalna skala',

        # Template: AgentStatsImport
        'Import Stat' => 'Uvezi statistiku',
        'File is not a Stats config' => 'Ova datoteka nije konfiguracija statistike',
        'No File selected' => 'Nije izabrana ni jedna datoteka',

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

        # Template: AgentStatsViewSettings
        'Configurable params of static stat' => 'Podesivi parametri statičke statistike',
        'No element selected.' => 'Nije izabran ni jedan element.',
        'maximal period from' => 'maksimalni period od',
        'to' => 'do',
        'not changable for dashboard statistics' => 'nepromenjivo za statistike kontrolne table.',
        'Select Chart Type' => 'Izaberite tip grafikona',
        'Chart Type' => 'Tip grafikona',
        'Multi Bar Chart' => 'Trakasti grafikon',
        'Multi Line Chart' => 'Linijski grafikon',
        'Stacked Area Chart' => 'Naslagani prostorni grafikon',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Promeni "slobodan" tekst tiketa',
        'Change Owner of Ticket' => 'Promeni vlasnika tiketa',
        'Close Ticket' => 'Zatvori tiket',
        'Add Note to Ticket' => 'Dodaj napomenu uz tiket',
        'Set Pending' => 'Stavi na čekanje',
        'Change Priority of Ticket' => 'Promeni prioritet tiketa',
        'Change Responsible of Ticket' => 'Promeni odgovornog za tiket',
        'All fields marked with an asterisk (*) are mandatory.' => 'Sva polja označena zvezdicom (*) su obavezna.',
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
        'For all pending* states.' => '',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Odbaci tiket',
        'Bounce to' => 'Preusmeri na',
        'You need a email address.' => 'Potrebna vam je email adresa.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Ispravna email adresa je neophodna, ali ne koristite lokalnu adresu!',
        'Next ticket state' => 'Naredni status tiketa',
        'Inform sender' => 'Obavesti pošiljaoca',
        'Send mail' => 'Pošalji email!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Masovne akcije na tiketima',
        'Send Email' => 'Pošalji email',
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
        'Remove Cc' => 'Ukloni Cc',
        'Remove Bcc' => 'Ukloni Bcc',
        'Address book' => 'Adresar',
        'Date Invalid!' => 'Neispravan datum!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Promena korisnika za tiket',
        'Customer user' => 'Korisnik',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Otvori novi email tiket',
        'From queue' => 'iz reda',
        'To customer user' => 'Za korisnika',
        'Please include at least one customer user for the ticket.' => 'Molimo vas uključite barem jednog korisnika za tiket.',
        'Select this customer as the main customer.' => 'Označi ovog korisnika kao glavnog korisnika.',
        'Remove Ticket Customer User' => 'Ukloni tiket korisnik',
        'Get all' => 'Uzmi sve',
        'Text Template' => 'Šablon teksta',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Prosledi tiket: %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Istorija od',
        'History Content' => 'Sadržaj istorije',
        'Zoom view' => 'Uvećani pregled',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Spajanje tiketa',
        'You need to use a ticket number!' => 'Molimo vas da koristite broj tiketa!',
        'A valid ticket number is required.' => 'Neophodan je ispravan broj tiketa.',
        'Need a valid email address.' => 'Potrebna je ispravna email adresa.',

        # Template: AgentTicketMove
        'Move Ticket' => 'Premesti tiket',
        'New Queue' => 'Novi Red',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Izaberi sve',
        'No ticket data found.' => 'Nisu nađeni podaci o tiketu',
        'First Response Time' => 'Vreme prvog odgovora',
        'Update Time' => 'Vreme ažuriranja',
        'Solution Time' => 'Vreme rešavanja',
        'Move ticket to a different queue' => 'Premesti tiket u drugi red',
        'Change queue' => 'Promeni red',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Promeni opcije pretrage',
        'Remove active filters for this screen.' => 'Ukloni aktivne filtere za ovaj ekran.',
        'Tickets per page' => 'Tiketa po strani',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Resetuj pregled',
        'Column Filters Form' => 'Forma filtera kolona',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Otvori novi telefonski tiket',
        'Please include at least one customer for the ticket.' => 'Molimo da uključite bar jednog korisnika za tiket.',
        'To queue' => 'U red',

        # Template: AgentTicketPhoneCommon

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Pregled neformatirane poruke',
        'Plain' => 'Neformatirano',
        'Download this email' => 'Preuzmi ovu poruku',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Informacije o tiketu',
        'Accounted time' => 'Obračunato vreme',
        'Linked-Object' => 'Povezani objekat',
        'by' => 'od',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => 'Kreiraj novi proces tiketa',
        'Process' => 'Proces',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Šablon pretrage',
        'Create Template' => 'Napravi šablon',
        'Create New' => 'Napravi nov',
        'Profile link' => 'Veza profila',
        'Save changes in template' => 'Sačuvaj promene u šablonu',
        'Filters in use' => 'Filteri u upotrebi',
        'Additional filters' => 'Dodatni filteri',
        'Add another attribute' => 'Dodaj još jedan atribut',
        'Output' => 'Pregled rezultata',
        'Fulltext' => 'Tekst',
        'Remove' => 'Ukloni',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            'Pretrage u atributima Od, Do, Cc, Predmet i telu članka, redefinišu druge atribute sa istim imenom.',
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
        'Ticket Escalation Time (before/after)' => 'Vreme eskalacije tiketa (pre/posle)',
        'Ticket Escalation Time (between)' => 'Vreme eskalacije tiketa (između)',
        'Archive Search' => 'Pretraga arhiva',
        'Run search' => 'Pokreni pretragu',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filter za članke',
        'Article Type' => 'Tip članka',
        'Sender Type' => 'Tip pošiljaoca',
        'Save filter settings as default' => 'Sačuvaj podešavanja filtera kao podrazumevana',
        'Archive' => 'Arhiviraj',
        'This ticket is archived.' => 'Ovaj tiket je arhiviran',
        'Locked' => 'Zaključano',
        'Linked Objects' => 'Povezani objekti',
        'Article(s)' => 'Članak/Članci',
        'Change Queue' => 'Promeni Red',
        'There are no dialogs available at this point in the process.' =>
            'U ovom trenutku nema slobodnih dijaloga u procesu.',
        'This item has no articles yet.' => 'Ova stavka još uvek nema člkanke.',
        'Add Filter' => 'Dodaj Filter',
        'Set' => 'Podesi',
        'Reset Filter' => 'Resetuj Filter',
        'Show one article' => 'Prikaži jedan članak',
        'Show all articles' => 'Prikaži sve članke',
        'Unread articles' => 'Nepročitani članci',
        'No.' => 'Br.',
        'Important' => 'Važno',
        'Unread Article!' => 'Nepročitani Članci!',
        'Incoming message' => 'Dolazna poruka',
        'Outgoing message' => 'Odlazna poruka',
        'Internal message' => 'Interna poruka',
        'Resize' => 'Promena veličine',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'Da biste zaštitili svoju privatnost, udaljeni sadržaj je blokiran.',
        'Load blocked content.' => 'Učitaj blokirani sadržaj.',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Isprati unazad',

        # Template: CustomerFooter
        'Powered by' => 'Pokreće',
        'One or more errors occurred!' => 'Došlo je do jedne ili više grešaka!',
        'Close this dialog' => 'Zatvori ovaj dijalog',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Nije moguće otvoriti iskačući prozor. Molimo da isključite blokadu iskačućih prozora za ovu aplikaciju.',
        'There are currently no elements available to select from.' => 'Trenutno nema slobodnih elemenata za odabir.',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nije dostupan.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Kako bi ste koristili OTRS neophodno je da aktivirate JavaScript u vašem Web pretraživaču.',
        'Browser Warning' => 'Upozorenje Web pretraživača',
        'The browser you are using is too old.' => 'Web pretraživač koji koristite je previše star.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS funcioniše na velikom broju Web pretraživača, molimo da instalirate i koristite jedan od ovih.',
        'Please see the documentation or ask your admin for further information.' =>
            'Molimo da pregledate dokumentaciju ili pitate vašeg administratora za dodatne informacije.',
        'Login' => 'Prijavljivanje',
        'User name' => 'Korisničko ime',
        'Your user name' => 'Vaše korisničko ime',
        'Your password' => 'Vaša lozinka',
        'Forgot password?' => 'Zaboravili ste lozinku?',
        'Log In' => 'Prijavljivanje',
        'Not yet registered?' => 'Niste registrovani?',
        'Request new password' => 'Zahtev za novu lozinku',
        'Your User Name' => 'Vaše korisničko ime',
        'A new password will be sent to your email address.' => 'Nova lozinka će biti poslata na vašu email adresu.',
        'Create Account' => 'Kreirajte nalog',
        'Please fill out this form to receive login credentials.' => 'Molimo da popunite ovaj obrazac da bi ste dobili podatke za prijavu.',
        'How we should address you' => 'Kako da vas oslovljavamo',
        'Your First Name' => 'Vaše ime',
        'Your Last Name' => 'Vaše prezime',
        'Your email address (this will become your username)' => 'Vaša email adresa (to će biti vaše korisničko ime)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Uredi lične postavke',
        'Logout %s' => 'Odjava %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor
        'Split Quote' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Sporazum o nivou usluge',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Dobrodošli!',
        'Please click the button below to create your first ticket.' => 'Molimo da pritisnete dugme ispod za kreiranje vašeg prvog tiketa.',
        'Create your first ticket' => 'Kreirajte vaš prvi tiket',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Štampa tiketa',
        'Ticket Dynamic Fields' => 'Dinamička polja tiketa',

        # Template: CustomerTicketProcess

        # Template: CustomerTicketProcessNavigationBar

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'npr. 10*5155 ili 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Tekstualno pretraživanje u tiketima (npr. "Ba*a" ili "Mil*")',
        'Carbon Copy' => 'Kopija',
        'Types' => 'Tipovi',
        'Time restrictions' => 'Vremenska ograničenja',
        'No time settings' => 'Nema podešavanja vremena',
        'Only tickets created' => 'Samo kreirani tiketi',
        'Only tickets created between' => 'Samo tiketi kreirani između',
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
        'Next Steps' => 'Sledeći koraci',
        'Reply' => 'Odgovori',

        # Template: CustomerWarning

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'Celodnevno',
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
        'Event Information' => 'Informacije o događaju',
        'Ticket fields' => 'Polja tiketa',
        'Dynamic fields' => 'Dinamička polja',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Neispravan datum (poteban budući datum)!',
        'Previous' => 'Nazad',
        'Open date selection' => 'Otvori izbor datuma',

        # Template: Error
        'Oops! An Error occurred.' => 'Ups! Dogodila se greška!',
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
            'Molimo unesite barem jednu vrednost pretrage ili * da bi ste nešto pronašli.',
        'Please check the fields marked as red for valid inputs.' => 'Molimo proverite polja označena crvenim za važeće unose.',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'You are logged in as' => 'Prijavljeni ste kao',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript nije dostupan.',
        'Database Settings' => 'Podešavanje baze podataka',
        'General Specifications and Mail Settings' => 'Opšte specifikacije i podešavanje pošte',
        'Welcome to %s' => 'Dobrodošli na %s',
        'Web site' => 'Web sajt',
        'Mail check successful.' => 'Uspešna provera email podešavanja.',
        'Error in the mail settings. Please correct and try again.' => 'Greška u podešavanju email-a. Molimo ispravite i pokušajte ponovo.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Podešavanje odlazne pošte',
        'Outbound mail type' => 'Tip odlazne pošte',
        'Select outbound mail type.' => 'Izaberite tip odlazne pošte',
        'Outbound mail port' => 'Port za odlaznu poštu',
        'Select outbound mail port.' => 'Izaberite port za odlaznu poštu',
        'SMTP host' => 'SMTP host',
        'SMTP host.' => 'SMTP host.',
        'SMTP authentication' => 'SMTP autentifikacija',
        'Does your SMTP host need authentication?' => 'Da li vaš SMTP host zahteva autentifikaciju?',
        'SMTP auth user' => 'SMTP korisnik',
        'Username for SMTP auth.' => 'Korisničko ime za SMTP autentifikaciju',
        'SMTP auth password' => 'Lozinka SMTP autentifikacije',
        'Password for SMTP auth.' => 'Lozinka za SMTP autentifikaciju',
        'Configure Inbound Mail' => 'Podešavanje dolazne pošte',
        'Inbound mail type' => 'Tip dolazne pošte',
        'Select inbound mail type.' => 'Izaberi tip dolazne pošte',
        'Inbound mail host' => 'Server dolazne pošte',
        'Inbound mail host.' => 'Server dolazne pošte.',
        'Inbound mail user' => 'Korisnik dolazne pošte',
        'User for inbound mail.' => 'Korisnik za dolaznu poštu.',
        'Inbound mail password' => 'Lozinka dolazne pošte',
        'Password for inbound mail.' => 'Lozinka za dolaznu poštu.',
        'Result of mail configuration check' => 'Rezultat provere podešavanja pošte',
        'Check mail configuration' => 'Proveri konfiguraciju mail-a',
        'Skip this step' => 'Preskoči ovaj korak',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Uspešno instaliranje baze',

        # Template: InstallerDBStart
        'Install Type' => 'Instaliraj tip',
        'Create a new database for OTRS' => 'Kreiraj novu bazu podataka za OTRS',
        'Use an existing database for OTRS' => 'Koristi postojeću bazu podataka za OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Naziv baze podataka',
        'Check database settings' => 'Proverite podešavanja baze',
        'Result of database check' => 'Rezultat provere baze podataka',
        'Database check successful.' => 'Uspešna provera baze podataka.',
        'Database User' => 'Korisnik baze podataka',
        'New' => 'Nov',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Novi korisnik baze sa ograničenim pravima će biti kreiran za ovaj OTRS sistem.',
        'Repeat Password' => 'Ponovi lozinku',
        'Generated password' => 'Generisana lozinka',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Lozinke se ne poklapaju',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Port',

        # Template: InstallerDBpostgresql

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Da bi ste koristili OTRS morate uneti sledeće u komandnu liniju (Terminal/Shell) kao "root".',
        'Restart your webserver' => 'Ponovo pokrenite vaš web server.',
        'After doing so your OTRS is up and running.' => 'Posle ovoga vaš OTRS je uključen i radi.',
        'Start page' => 'Početna strana',
        'Your OTRS Team' => 'Vaš OTRS Tim',

        # Template: InstallerLicense
        'Accept license' => 'Prihvati licencu',
        'Don\'t accept license' => 'Ne prihvataj licencu',

        # Template: InstallerLicenseText

        # Template: InstallerSystem
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Sistemski identifikator. Svaki broj tiketa i svaki ID HTTP sesije sadrži ovaj broj.',
        'System FQDN' => 'Sistemski FQDN',
        'Fully qualified domain name of your system.' => 'Puno ime domena vašeg sistema',
        'AdminEmail' => 'Email administrator',
        'Email address of the system administrator.' => 'Email adresa sistem administratora.',
        'Organization' => 'Organizacija',
        'Log' => 'Log',
        'LogModule' => 'Log modul',
        'Log backend to use.' => 'Pozadinski prikaz log-a.',
        'LogFile' => 'Log datoteka',
        'Webfrontend' => 'Mrežni interfejs',
        'Default language' => 'Podrazumevani jezik',
        'Default language.' => 'Podrazumevani jezik',
        'CheckMXRecord' => 'Proveri MX-podatke',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Ručno uneta email adresa se proverava pomoću MX podatka pronađenog u DNS. Nemojte koristiti ovu opciju ako je vaš DNS spor ili ne može da razreši javne adrese.',

        # Template: LinkObject
        'Object#' => 'Objekat#',
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
        'Show page %s' => 'Pokaži stranu %s',
        'Show next pages' => 'Pokaži sledeće strane',
        'Show last page' => 'Pokaži poslednju stranu',

        # Template: PictureUpload
        'Need FormID!' => 'Potreban ID formulara!',
        'No file found!' => 'Datoteka nije pronađena!',
        'The file is not an image that can be shown inline!' => 'Datoteka nije slika koja se može neposredno prikazati!',

        # Template: PrintFooter

        # Template: PrintHeader
        'printed by' => 'štampao',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS test strana',
        'Welcome %s' => 'Dobrodošli %s',
        'Counter' => 'Brojač',

        # Template: Warning
        'Go back to the previous page' => 'Vratite se na prethodnu stranu',

        # SysConfig
        '(UserLogin) Firstname Lastname' => '(Prijava korisnika) Ime Prezime',
        '(UserLogin) Lastname, Firstname' => '(Prijava korisnika) Prezime, Ime',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL modul koji dozvoljava da tiketi roditelji budu zatvoreni samo ako su već zatvoreni svi tiketi deca ("Status" pokazuje koji statusi nisu dostupni za tiket roditelj dok se ne zatvore svi tiketi deca).',
        'Access Control Lists (ACL)' => 'Liste za kontrolu pristupa (ACL)',
        'AccountedTime' => 'Obračunato vreme',
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
            'Aktivira arhivski sistem radi ubrzanja rada, tako što ćete neke tikete ukloniti van dnevnog praćenja. Da biste pronašli ove tikete, marker arhive mora biti omogućen za pretragu tiketa.',
        'Activates time accounting.' => 'Aktivira merenje vremena.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Dodaje tekuću godinu i mesec kao sufiks u OTRS log datoteku. Biće kreirana log datoteka za svaki mesec.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            'Dodavanje email adresa korisnika, primaocima u tiketu na prikazu ekrana za otvaranje tiketa u interfejsu operatera. Email adrese korisnika neće biti dodate, ukoliko je tip artikla email-interni.',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Jednokratno dodaje neradne dane za izabrani kalendar. Molimo Vas da koristite jednu cifru za brojeve od 1 do 9 (umesto 01 - 09).',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Jednokratno dodaje neradne dane. Molimo Vas da koristite jednu cifru za brojeve od 1 do 9 (umesto 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Trajno dodaje neradne dane za izabrani kalendar. Molimo Vas da koristite jednu cifru za brojeve od 1 do 9 (umesto 01 - 09).',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Trajno dodaje neradne dane. Molimo Vas da koristite jednu cifru za brojeve od 1 do 9 (umesto 01 - 09).',
        'Agent Notifications' => 'Obaveštenja operaterima',
        'Agent interface article notification module to check PGP.' => 'Modul interfejsa operatera za obaveštavanja o članku, provera PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Modul interfejsa operatera za obaveštavanja o članku, provera S/MIME',
        'Agent interface module to access CIC search via nav bar.' => 'Modul interfejsa operatera za pristup CIC pretrazi preko linije za navigaciju.',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Modul interfejsa operatera za pristup tekstualnom pretraživanju preko navigacione trake.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Modul interfejsa operatera za pristup profilima pretraživanja preko navigacione trake.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Modul interfejsa operatera za proveru dolaznih poruka u uvećanom pregledu tiketa ako S/MIME-ključ postoji i dostupan je.',
        'Agent interface notification module to check the used charset.' =>
            'Modul interfejsa operatera za proveru upotrebljenog karakterseta.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Modul interfejsa operatera za obaveštavanje, pregled broja tiketa za koje je operater odgovoran.',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Modul interfejsa operatera za obaveštavanje, pregled broja praćenih tiketa.',
        'Agents <-> Groups' => 'Operateri <-> Grupe',
        'Agents <-> Roles' => 'Operateri <-> Uloge',
        'All customer users of a CustomerID' => 'Svi korisnici za CustomerID',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Dozvoljava dodavanje napomena na prikazu ekrana zatvorenog tiketa interfejsa operatera.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Dozvoljava dodavanje napomena na prikazu ekrana slobodnog teksta tiketa interfejsa operatera.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Dozvoljava dodavanje napomena na prikazu ekrana napomena tiketa interfejsa operatera.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Dozvoljava dodavanje napomena na prikazu ekrana vlasnika tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Dozvoljava dodavanje napomena na prikazu ekrana tiketa na čekanju pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Dozvoljava dodavanje napomena na prikazu ekrana prioritetnog tiketa na uvećanom prikazu u interfejsu operatera.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'Dozvoljava dodavanje napomena na prikazu ekrana odgovornog tiketa interfejsa operatera.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Dozvoljava operaterima da zamene ose na statistici ako je generišu.',
        'Allows agents to generate individual-related stats.' => 'Dozvoljava operaterima da generišu individualnu statistiku.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Dozvoljava izbor između prikaza priloga u pretraživaču ili samo omogućavanja njegovog preuzimanja.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Dozvoljava izbor sledećeg stanja za korisnički tiket u korisničkom interfejsu.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Dozvoljava korisnicima da promene prioritet tiketa u korisničkom interfejsu.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Dozvoljava korisnicima da podese SLA za tiket u korisničkom interfejsu.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Dozvoljava korisnicima da podese prioritet tiketa u korisničkom interfejsu.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Dozvoljava korisnicima da podese red tiketa u korisničkom interfejsu. Ako je podešeno na "Ne", onda treba podesiti QueueDefault.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Dozvoljava korisnicima da podese servis za tiket u korisničkom interfejsu.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            'Dozvoljava korisnicima da podese tip tiketa u interfejsu  korisnika. Ukoliko je ovo podešeno na  \'No\', treba konfigurisati TicketTypeDefault.',
        'Allows default services to be selected also for non existing customers.' =>
            'Dozvoljava da podrazumevane usluge budu izabrane i za nepostojeće korisnike.',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Dozvoljava definisanje novog tipa tiketa (ako je opcija tipa tiketa aktivirana).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Dozvoljava definisanje servisa i SLA za tikete (npr. email, radna površina, mreža, ...), i eskalacione atribute za SLA (ako je aktivirana funkcija servis/SLA za tiket).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Dozvoljava proširene uslove pretrage u tiketu na interfejsu operatera. Pomoću ove funkcije možete vršiti pretrage npr. sa vrstom uslova kao što su: "(key1&&key2)" ili "(key1||key2)".',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Dozvoljava proširene uslove pretrage u tiketu na interfejsu  korisnika. Pomoću ove funkcije možete vršiti pretrage npr. sa vrstom uslova kao što su: "(key1&&key2)" ili "(key1||key2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Dozvoljava posedovanje srednjeg formata pregleda tiketa ( CustomerInfo => 1 - takođe prikazuje informacije o korisniku).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Dozvoljava posedovanje malog formata pregleda tiketa ( CustomerInfo => 1 - takođe prikazuje informacije o korisniku).',
        'Allows invalid agents to generate individual-related stats.' => 'Dozvoljava nevažećim operaterima da generišu pojedinačno vezane statistike.',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Dozvoljava administratorima da pristupe kao drugi korisnici, kroz administrativni panel korisnika.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Dozvoljava administratorima da pristupe kao drugi korisnici, kroz administrativni panel.',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Dozvoljava podešavanje statusa novog tiketa na prikazanom ekranu pomerenog tiketa u interfejsu operatera.',
        'ArticleTree' => 'Članak u obliku drveta',
        'Attachments <-> Templates' => 'Prilozi <-> Šeme',
        'Auto Responses <-> Queues' => 'Automatski odgovori <-> Redovi',
        'Automated line break in text messages after x number of chars.' =>
            'Automatski kraj reda u tekstualnim porukama posle x karaktera.',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automatsko zaključavanje i podešavanje vlasnika na aktuelnog operatera posle izbora masovne akcije.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Automatski podešava da je vlasnik tiketa odgovoran za njega (ako je odgovorna funkcija tiketa aktivirana).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Automatsko podešavanje odgovornog za tiket (ako nije do sada podešeno) posle prvog ažuriranja.',
        'Balanced white skin by Felix Niklas (slim version).' => 'Izbalansirani beli izgled, Felix Niklas (tanka verzija).',
        'Balanced white skin by Felix Niklas.' => 'Izbalansirani beli izgled, Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Osnovni ceo tekst podešavanja indeksa. Izvrši "bin/otrs.RebuildFulltextIndex.pl" kako bi generisao novi izgled.',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blokira sve dolazne email-ove koji nemaju ispravan broj tiketa u predmetu sa Od: @example.com adrese.',
        'Builds an article index right after the article\'s creation.' =>
            'Generiše indeks članaka odmah po kreiranju članka.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'Primer podešavanja CMD. Ignoriše email-ove kada eksterni CMD vrati neke izlaze na STDOUT (email će biti kanalisan u STDIN od some.bin).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            'Vreme keširanja u sekundama za autentifikacije operatera u generičkom interfejsu.',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            'Vreme keširanja u sekundama za autentifikaciju korisnika u generičkom interfejsu.',
        'Cache time in seconds for the DB ACL backend.' => 'Vreme keširanja u sekundama za pozadinu ACL baze podataka.',
        'Cache time in seconds for the DB process backend.' => 'Vreme keširanja u sekundama za pozadinski proces baze podataka.',
        'Cache time in seconds for the SSL certificate attributes.' => 'Vreme keširanja u sekundama za SSL sertifikovane atribute.',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            'Vreme keširanja u sekundama za izlazni modul navigacione trake procesa tiketa',
        'Cache time in seconds for the web service config backend.' => 'Vreme keširanja u sekundama za web servis konfiguracije pozadine.',
        'Change password' => 'Promena lozinke',
        'Change queue!' => 'Promena reda!',
        'Change the customer for this ticket' => 'Promeni korisnika za ovaj tiket',
        'Change the free fields for this ticket' => 'Promeni slobodna polja ovog tiketa',
        'Change the priority for this ticket' => 'Promeni prioritete za ovaj tiket.',
        'Change the responsible person for this ticket' => 'Promeni odgovornu osobu za ovaj tiket',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Promeni vlasnika tiketa za sve (korisno za ASP). Obično se pokazuje samo agent sa dozvlama za čitanje/pisanje u redu tiketa.',
        'Checkbox' => 'Polje za potvrdu',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Proveravanje SystemID u detekciji broja tiketa za praćenja (koristiti "Ne" ukoliko je SystemID promenjen nakon korišćenja sistema).',
        'Closed tickets of customer' => 'Zatvoreni tiketi za korisnike',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Filteri kolona tiketa za preglede tiketa tipa "Malo".',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Komentar za nove stavke istorije u korisničkom interfejsu.',
        'Company Status' => 'Status firme',
        'Company Tickets' => 'Tiketi firmi',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Naziv firme koji će biti uključen u odlazne email-ove kao X-Zaglavlje.',
        'Configure Processes.' => 'Konfiguriši procese.',
        'Configure and manage ACLs.' => 'Konfiguriši i upravljaj ACL listama.',
        'Configure your own log text for PGP.' => 'Konfiguriši sopstveni log tekst za PGP.',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            'Konfiguriši podrazumevana podešavanja dinamičkog polja tiketa. "Ime" definiše dinamičko polje koje bi se trebalo koristiti, "Vrednost" je podatak koji treba podesiti i "Događaj" definiše pokretača događaja. Molimo proverite uputstvo za programere (http://doc.otrs.org/), poglavlje "Ticket Event Module".',
        'Controls if customers have the ability to sort their tickets.' =>
            'Kontroliše da li korisnici imaju mogućnost da sortiraju svoje tikete.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            'Kontroliše da li više od jednog ulaza može biti podešeno u novom telefonskom tiketu u interfejsu operatera.',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            'Kontroliše da li su zastavicom obeleženi tiket i članak uklonjeni kada je tiket arhiviran.',
        'Converts HTML mails into text messages.' => 'Konvertuje HTML poruke u tekstualne poruke.',
        'Create New process ticket' => 'Kreiraj novi proces za tiket',
        'Create and manage Service Level Agreements (SLAs).' => 'Kreira i upravlja sa SLA.',
        'Create and manage agents.' => 'Kreiranje i upravljanje operaterima.',
        'Create and manage attachments.' => 'Kreiranje i upravljanje prilozima.',
        'Create and manage customer users.' => 'Kreiranje i upravljanje korisnicima korisnika.',
        'Create and manage customers.' => 'Kreiranje i upravljanje korisnicima.',
        'Create and manage dynamic fields.' => 'Kreiranje i upravljanje dinamičkim poljima.',
        'Create and manage event based notifications.' => 'Kreiranje i upravljanje obaveštenjima na bazi događaja.',
        'Create and manage groups.' => 'Kreiranje i upravljanje grupama.',
        'Create and manage queues.' => 'Kreiranje i upravljanje redovima.',
        'Create and manage responses that are automatically sent.' => 'Kreiranje i upravljanje automatskim odgovorima.',
        'Create and manage roles.' => 'Kreiranje i upravljanje ulogama.',
        'Create and manage salutations.' => 'Kreiranje i upravljanje pozdravima.',
        'Create and manage services.' => 'Kreiranje i upravljanje servisima.',
        'Create and manage signatures.' => 'Kreiranje i upravljanje potpisima.',
        'Create and manage templates.' => 'Kreiranje i upravljanje šablonima.',
        'Create and manage ticket priorities.' => 'Kreiranje i upravljanje prioritetima tiketa.',
        'Create and manage ticket states.' => 'Kreiranje i upravljanje statusima tiketa.',
        'Create and manage ticket types.' => 'Kreiranje i upravljanje tipovima tiketa.',
        'Create and manage web services.' => 'Kreiranje i upravljanje web servisima.',
        'Create new email ticket and send this out (outbound)' => 'Otvori novi email tiket i pošalji ovo (odlazni)',
        'Create new phone ticket (inbound)' => 'Kreiraj novi telefonski tiket (dolazni poziv)',
        'Create new process ticket' => 'Kreiraj novi proces za tiket',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            'Namenski tekst za stranu koja se prikazuje korisnicima da još uvek nemaju tikete.',
        'Customer Company Administration' => 'Administracija firme korisnika',
        'Customer Company Administration.' => '',
        'Customer Company Information' => 'Informacija firme korisnika',
        'Customer Information Center.' => '',
        'Customer User <-> Groups' => 'Korisnik <-> Grupe',
        'Customer User <-> Services' => 'Korisnik <-> Usluge',
        'Customer User Administration' => 'Administracija korisnika',
        'Customer User Administration.' => '',
        'Customer Users' => 'Korisnici',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Korisnička stavka (ikona) koja pokazuje otvorene tikete ovog korisnika kao info blok. Podešavanje Prijave korisnika korisnika (CustomerUserLogin) za pretragu za tikete zasniva se pre na prijavi imena nego na ID korisnika.',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            'Korisnička stavka (ikona) koja pokazuje otvorene tikete ovog korisnika kao info blok. Podešavanje Prijave korisnika korisnika (CustomerUserLogin) za pretragu za tikete zasniva se pre na prijavi imena nego na ID korisnika',
        'CustomerName' => 'Naziv korisnika',
        'Customers <-> Groups' => 'Korisici <-> Grupe',
        'Data used to export the search result in CSV format.' => 'Podaci upotrebljeni za ivoz rezultata pretraživanja u CSV formatu.',
        'Date / Time' => 'Datum / Vreme',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Uklanjanje grešaka kompleta prevoda. Ako je ovo podešeno na "Da" celokupan niz znakova (tekst) će bez prevoda biti upisan u STDERR. Ovo može biti od pomoći prilikom kreiranja nove datoteke prevoda. U suprotnom, ova opcija bi trebala da ostane podešena na "ne".',
        'Default ACL values for ticket actions.' => 'Podrazumevane ACL vrednosti za akcije tiketa.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            'Podrazumevani prefiksi objekta za upravljanje procesom za ID-eve objekta koji su automatski generisani.',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            'Podrazumevani podaci za korišćenje na atributima za prikaz pretrage tiketa. Primer: TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            'Podrazumevani podaci za korišćenje na atributima za prikaz pretrage tiketa. Primer: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".',
        'Default loop protection module.' => 'Podrazumevani modul zaštite od petlje.',
        'Default queue ID used by the system in the agent interface.' => 'Podrazumevani ID reda koji koristi sistem u interfejsu operatera.',
        'Default skin for OTRS 3.0 interface.' => 'Podrazumevani izgled okruženja za OTRS 3.0 interfejs.',
        'Default skin for the agent interface (slim version).' => 'Podrazumevani izgled okruženja za interfejs operatera (slaba verzija).',
        'Default skin for the agent interface.' => 'Podrazumevani izgled okruženja za interfejs operatera.',
        'Default ticket ID used by the system in the agent interface.' =>
            'Podrazumevani ID tiketa koji koristi sistem u interfejsu operatera.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Podrazumevani ID tiketa koji koristi sistem u korisničkom interfejsu.',
        'Default value for NameX' => 'Podrazumevana vrednost za ImeX',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiši filter za html izlaz da bi dodali veze iza definisanog niza znakova. Element Slika dozvoljava dva načina ulaza. U jednom naziv slike (npr. faq.png). U tom slučaju biće korišćena OTRS putanja slike. Drugi način je unošenje veze do slike.',
        'Define a mapping between variables of the customer user data (keys) and dynamic fields of a ticket (values). The purpose is to store customer user data in ticket dynamic fields. The dynamic fields must be present in the system and should be enabled for AgentTicketFreeText, so that they can be set/updated manually by the agent. They mustn\'t be enabled for AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer. If they were, they would have precedence over the automatically set values. To use this mapping, you have to also activate the next setting below.' =>
            'Definisanje mapiranja između promenljivih: podaci korisnika (ključevi) i dinamičkih polja tiketa (vrednosti). Cilj je da se sačuvaju podaci korisnika  korisnika u dinamičkom polju tiketa. Dinamička polja moraju biti prisutna u sistemu i treba da budu omogućena za  AgentTicketFreeText, tako da mogu da budu manuelno podešena/ažurirana od strane operatera. Ona ne smeju biti omogućena za AgentTicketPhone, AgentTicketEmail i AgentTicketCustomer. Da su bila, ona bi imala prednost nad automatski postavljenim vrednostima. Za korišćenje ovog mapiranja treba, takođe, da aktivirate sledeća podešavanja.',
        'Define dynamic field name for end time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definiši naziv dinamičkog polja za krajnje vreme. Ovo polje mora biti manuelno dodato sistemu kao tiket: "Datum / Vreme" i moraju biti aktivirani u ekranima za kreiranje tiketa i/ili u bilo kom drugom ekranu sa događajima.',
        'Define dynamic field name for start time. This field has to be manually added to the system as Ticket: "Date / Time" and must be activated in ticket creation screens and/or in any other ticket action screens.' =>
            'Definiši naziv dinamičkog polja za početno vreme. Ovo polje mora biti manuelno dodato sistemu kao tiket: "Datum / Vreme" i moraju biti aktivirani u ekranima za kreiranje tiketa i/ili u bilo kom drugom ekranu sa događajima.',
        'Define the max depth of queues.' => 'Definiši maksimalnu dubinu za redove.',
        'Define the start day of the week for the date picker.' => 'Definiši prvi dan u nedelji za izbor datuma.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definiše stavku  korisnika, koja generiše LinkedIn ikonu na kraju info bloka  korisnika.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definiše stavku  korisnika, koja generisše XING ikonu na kraju info bloka  korisnika.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definiše stavku  korisnika, koja generisše Google ikonu na kraju info bloka  korisnika.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definiše stavku  korisnika, koja generisše Google mape ikonu na kraju info bloka  korisnika.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Definiše podrazumevanu listu reči, koje su ignorisane od strane provere pravopisa.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiše filter za html izlaz da bi ste dodali veze iza CVE brojeva. Element Slika dozvoljava dva načina ulaza. U jednom naziv slike (npr. faq.png). I tom slučaju biće korišćena OTRS putanja slike. Drugi način je unošenje veze do slike.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiše filter za html izlaz da bi ste dodali veze iza Microsoft znakova za nabrajanje ili brojeva. Element Slika dozvoljava dva načina ulaza. U jednom naziv slike (npr. faq.png). I tom slučaju biće korišćena OTRS putanja slike. Drugi način je unošenje veze do slike.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiše filter za html izlaz da bi ste dodali veze iza definisanog niza znakova. Element Slika dozvoljava dva načina ulaza. U jednom naziv slike (npr. faq.png). I tom slučaju biće korišćena OTRS putanja slike. Drugi način je unošenje veze do slike.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definiše filter za html izlaz da bi ste dodali veze iza "bugtraq" brojeva. Element Slika dozvoljava dva načina ulaza. U jednom naziv slike (npr. faq.png). I tom slučaju biće korišćena OTRS putanja slike. Drugi način je unošenje veze do slike.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Definiše filter za obradu teksta u člancima, da bi se istakle unapred definisane ključne reči.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Definiše regularni izraz koji isključuje neke adrese iz provere sintakse (ako je "ProveraEmailAdresa" postavljena na "Da"). Molimo vas unesite regularni izraz u ovo polje za email adrese, koji nije sintaksno ispravan, sli je neophodan za sistem (npr. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Definiše regularni izraz koji kiltrira sve email adrese koje ne bi smele da se koriste u aplikaciji.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Definiše koristan modul za učitavanje određenih korisničkih opcija ili za prikazivanje novosti.',
        'Defines all the X-headers that should be scanned.' => 'Određuje sva X-zaglavlja koja treba skenirati.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Definiše sve jezike dostupne u aplikaciji. Par Ključ/Sadržaj povezuje glavni prikaz imena u korisničkom delu sa odgovarajućim jezičkim PM direktorijumom. Vrednost "Ključa" mora biti osnovni naziv PM direktorijuma (npr. de.pm je direktorijum, onda je de vrednost "Ključa"). Vrednost "Sadržaja" mora biti prikazano ime za korisnički deo. Ovde navedite bilo koji od jezika koje ste sami definisali (za više informacija pogledajte programersku dokumentaciju na http://doc.otrs.org/). Molimo vas zapamtite da koristite HTML ekvivalente za ne-ASCII karaktere (npr. za Nemački oe = o sa dvotačkom, neophodno je da koristite simbol &ouml;).',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Određuje sve parametre za objekat Vreme Osvežavanja u postavkama korisnika u interfejsu korisnika.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Određuje sve parametre za objekat Prikazani Tiketi u postavkama korisnika u interfejsu korisnika.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Određuje sve parametre za ovu stavku u korisničkim podešavanjima.',
        'Defines all the possible stats output formats.' => 'Određuje sve moguće izlazne formate statistike.',
        'Defines an alternate URL, where the login link refers to.' => 'Određuje alternativnu URL adresu, na koju ukazuje veza za prijavljivanje.',
        'Defines an alternate URL, where the logout link refers to.' => 'Određuje alternativnu URL adresu, na koju ukazuje veza za odjavljivanje.',
        'Defines an alternate login URL for the customer panel..' => 'Određuje alternativnu URL adresu prijavljivanja za korisnički panel.',
        'Defines an alternate logout URL for the customer panel.' => 'Određuje alternativnu URL adresu odjavljivanja za korisnički panel.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            'Definiše spoljnu vezu sa bazom podataka  korisnika (npr.\'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' ili \'\').',
        'Defines from which ticket attributes the agent can select the result order.' =>
            'Definiše iz kog atributa tiketa operater može da izabere redosled rezultata.',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Definiše kako polje Od u email porukama (poslato iz odgovora i email tiketa) treba da izgleda.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            'Određuje ako prethodno sortiranje po prioritetu treba da se uradi u prikazu reda.',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket u zatvorenom prikazu ekrana tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana za povraćaj tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana za otvaranje tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana za prosleđivanje tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana slobodnog teksta tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana za spajanje tiketa pri uvećanom prikazu tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana za napomenu tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana vlasnika tiketa pri uvećanom prikazu tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana tiketa na čekanju pri uvećanom prikazu tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana za tiket dolaznih telefonskih poziva u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana za tiket odlaznih telefonskih poziva u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana prioritetnog tiketa pri uvećanom prikazu tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket na prikazu ekrana odgovornog tiketa u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Određuje ako je potrebno zaključati tiket da bi promenili korisnika na tiketu u interfejsu operatera (ako tiket još uvek nije zaključan, tiket će dobiti status zaključan i trenutni operater će biti automatski postavljen kao vlasnik).',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Određuje da li porukama napisanim u interfejsu operatera treba uraditi proveru pravopisa.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            'Određuje da li treba da se koristi poboljšani režim (omogućava korišćenje tabele, zamene, indeksiranja, eksponiranja, umetanja iz Word-a, itd.).',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            'Određuje da li lista za filtere treba vršiti preuzimanje samo iz trenutnih tiketa u sistemu. Da razjasnimo, lista korisnika će uvek dolaziti iz sistemskih tiketa.',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Određuje da li je obračun vremena obavezan u interfejsu operatera.',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            'Određuje da li obračun vremena mora biti podešen na svim tiketima u masovnim akcijama.',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            'Definiše redove koje koriste tiketi za prikazivanje u vidu kalendarskih događaja.',
        'Defines scheduler PID update time in seconds.' => 'Definiše raspored vremena ažuriranja PID-a (identifikatora procesa) u sekundama.',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            'Definiše raspored vremena provedenog u režimu spavanja u sekundama posle obrađivanja svih raspoloživih zadataka (broj sa pokretnim zarezom).',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Definiše regularni izraz za IP adresu za pristup lokalnom spremištu. Potrebno je da im omogućite pristup vašem lokalnom spremištu i pakovanju: :RepositoryList se zahteva na udaljenom host-u.',
        'Defines the URL CSS path.' => 'Definiše URL CSS putanju.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Definiše URL osnovnu putanju za ikone, CSS i Java Script.',
        'Defines the URL image path of icons for navigation.' => 'Definiše URL putanju do slika za navigacione ikone.',
        'Defines the URL java script path.' => 'Definiše URL putanju java skriptova.',
        'Defines the URL rich text editor path.' => 'Definiše URL Reach Text Editor putanju.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Definiše adrese namenskog DNS servera, ukoliko je potrebno, za "CheckMXRecord" pretrage.',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Definiše telo teksta za obaveštenja o novoj lozinki, poslata operaterima putem email-ova (nova lozinka će biti poslata posle korišćenja ove veze).',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Definiše telo teksta za obaveštenja poslata operaterima putem email-ova, sa tokenom u vezi nove zahtevane lozinke (nova lozinka će biti poslata posle korišćenja ove veze).',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Definiše telo teksta za obaveštenja poslata korisnicima putem email-ova, o novom nalogu.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Definiše telo teksta za obaveštenja poslata korisnicima putem email-ova, o novoj lozinki (nova lozinka će biti poslata posle korišćenja ove veze).',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Definiše telo teksta za obaveštenja poslata korisnicima putem email-ova, sa tokenom u vezi nove zahtevane lozinke (nova lozinka će biti poslata posle korišćenja ove veze).',
        'Defines the body text for rejected emails.' => 'Definiše sadržaj teksta za odbačene poruke.',
        'Defines the boldness of the line drawed by the graph.' => 'Definiše debljinu linija za grfikone.',
        'Defines the calendar width in percent. Default is 95%.' => 'Definiše širinu kalendara u procentima. Podrazumevano je 95%.',
        'Defines the colors for the graphs.' => 'Definiše boje za grafikone.',
        'Defines the column to store the keys for the preferences table.' =>
            'Definiše kolonu za čuvanje ključeva tabele podešavanja.',
        'Defines the config options for the autocompletion feature.' => 'Definiše konfiguracione opcije za funkciju automatskog dovršavanja.',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Definiše konfiguracione parametre za ovu stavku, da budu prikazani u prikazu podešavanja.',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Definiše konfiguracione parametre za ovu stavku, da budu prikazani u prikazu podešavanja. Voditi računa o održavanju rečnika instaliranih u sistemu u sekciji podataka.',
        'Defines the connections for http/ftp, via a proxy.' => 'Definiše konekcije za http/ftp preko posrednika.',
        'Defines the date input format used in forms (option or input fields).' =>
            'Definiše format unosa datuma u formulare (opciono ili polja za unos).',
        'Defines the default CSS used in rich text editors.' => 'Definiše podrazumevani CSS upotrebljen u RTF uređivanju.',
        'Defines the default auto response type of the article for this operation.' =>
            'Definiše podrazumevani tip automatskog odgovora članka za ovu operaciju.',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Definiše telo napomene na prikazu ekrana slobodnog teksta tiketa u interfejsu operatera.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Definiše podrazumevanu temu glavnog korisničkog dela (HTML) koja će biti korišćena od strane operatera ili korisnika. Ukoliko želite možete dodati vašu ličnu temu. Molimo Vas da pogledate uputstvo za administratora, koje se nalazi na http://doc.otrs.org/.',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Definiše podrazumevani jezik glavnog korisničkog dela. Sve moguće vrednosti su određene u raspoloživim jezičkim datotekama u sistemu (pogledajte sledeća podešavanja).',
        'Defines the default history type in the customer interface.' => 'Definiše podrazumevani tip istorije u interfejsu  korisnika.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Definiše podrazumevani maksimalni broj atributa na X-osi vremenske skale.',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Definiše podrazumevani maksimalni broj rezultata pretrage prikazanih na strani pregleda.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Definiše podrazumevani sledeći status tiketa nakon što korisnik nastavi rad u interfejsu korisnika.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana zatvorenog tiketa u interfejsu operatera.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana masovnih tiketa u interfejsu operatera.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana tiketa slobodnog teksta u interfejsu operatera.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana napomene tiketa u interfejsu operatera.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana vlasnika tiketa, pri uvećanom prikazu tiketa, u interfejsu operatera.',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana tiketa na čekanju, pri uvećanom prikazu tiketa, u interfejsu operatera.',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana prioritnog tiketa, pri uvećanom prikazu tiketa, u interfejsu operatera.',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana odgovornog tiketa u interfejsu operatera.',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana za povraćaj tiketa u interfejsu operatera.',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja napomene u prikazu ekrana za prosleđivanje tiketa u interfejsu operatera.',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa ukoliko je sastavljeno / odgovoreno u prikazu ekrana za otvaranje tiketa u interfejsu operatera.',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status telefonskih tiketa u prikazu ekrana tiketa za dolazne telefonske pozive u interfejsu operatera.',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status telefonskih tiketa u prikazu ekrana tiketa za odlazne telefonske pozive u interfejsu operatera.',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Definiše podrazumevani prioritet tiketa korisnika za nastavak pri uvećanom prikazu ekrana tiketa u interfejsu  korisnika.',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Određuje podrazumevani prioritet za nove korisničke tikete u interfejsu  korisnika.',
        'Defines the default priority of new tickets.' => 'Određuje podrazumevani prioritet za nove tikete.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Određuje podrazumevani red za nove korisničke tikete u interfejsu korisnika.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Definiše podrazumevani izbor iz padajućeg menija za dinamičke objekte (Od: Zajednička specifikacija).',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Definiše podrazumevani izbor iz padajućeg menija za dozvole (Od: Zajednička specifikacija).',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Definiše podrazumevani izbor iz padajućeg menija za status formata (Od: Zajednička specifikacija). Molimo vas da ubacite ključ formata (vidi statistika :: Format).',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definiše podrazumevani tip pošiljaoca za telefonske tikete na prikazu ekrana za tiket dolaznih telefonskih poziva u interfejsu operatera.',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definiše podrazumevani tip pošiljaoca za telefonske tikete na prikazu ekrana za tiket odlaznih telefonskih poziva u interfejsu operatera.',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Definiše podrazumevani tip pošiljaoca za tikete na uvećanom prikazu ekrana tiketa u interfejsu korisnika.',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            'Definiše podrazumevani prikaz pretrage atributa tiketa za prikaz ekrana pretrage tiketa.',
        'Defines the default shown ticket search attribute for ticket search screen. Example: "Key" must have the name of the Dynamic Field in this case \'X\', "Content" must have the value of the Dynamic Field depending on the Dynamic Field type,  Text: \'a text\', Dropdown: \'1\', Date/Time: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' and or \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.' =>
            'Definiše podrazumevani prikaz pretrage atributa tiketa za prikaz ekrana pretrage tiketa. Primer: "Ključ" mora imati naziv dinamičkog polja, u ovom slučaju \'X\', "Sadržaj" mora imati vrednost dinamičkog polja u zavisnosti od tipa dinamičkog polja, Tekst \'a text\', Padajući: \'1\', Datum/Vreme: \'Search_DynamicField_XTimeSlotStartYear=1974; Search_DynamicField_XTimeSlotStartMonth=01; Search_DynamicField_XTimeSlotStartDay=26; Search_DynamicField_XTimeSlotStartHour=00; Search_DynamicField_XTimeSlotStartMinute=00; Search_DynamicField_XTimeSlotStartSecond=00; Search_DynamicField_XTimeSlotStopYear=2013; Search_DynamicField_XTimeSlotStopMonth=01; Search_DynamicField_XTimeSlotStopDay=26; Search_DynamicField_XTimeSlotStopHour=23; Search_DynamicField_XTimeSlotStopMinute=59; Search_DynamicField_XTimeSlotStopSecond=59;\' i ili \'Search_DynamicField_XTimePointFormat=week; Search_DynamicField_XTimePointStart=Before; Search_DynamicField_XTimePointValue=7\';.',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            'Određuje podrazumevani kriterijum sortiranja za sve redove prikazane u pregledu reda.',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Određuje podrazumevani redosled sortiranja za sve redove prikazane u prikazu reda, nakon sortiranja po prioritetu.',
        'Defines the default spell checker dictionary.' => 'Određuje podrazumevani rečnik za proveru pravopisa.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Određuje podrazumevani status tiketa novog  korisnika u interfejsu korisnika.',
        'Defines the default state of new tickets.' => 'Određuje podrazumevani status novih tiketa.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            'Definiše podrazumevani predmet za telefonske tikete na prikazu ekrana za tiket dolaznih telefonskih poziva u interfejsu operatera.',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definiše podrazumevani predmet za telefonske tikete na prikazu ekrana za tiket odlaznih telefonskih poziva u interfejsu operatera.',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            'Definiše podrazumevani predmet napomene za prikaz ekrana tiketa slobodnog teksta u interfejsu operatera.',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Definiše podrazumevani atribut tikata za sortiranje tiketa u pretrazi tiketa interfejsa korisnika',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Definiše podrazumevani atribut tiketa za sortiranje tiketa u eskalacionom pregledu interfejsa operatera.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Definiše podrazumevani atribut tiketa za sortiranje tiketa u pregledu zaključanog tiketa interfejsa operatera.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Definiše podrazumevani atribut tiketa za sortiranje tiketa u odgovornom pregledu interfejsa operatera.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Definiše podrazumevani atribut tiketa za sortiranje tiketa u pregledu statusa interfejsa operatera.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Definiše podrazumevani atribut tiketa za sortiranje tiketa u posmatranom pregledu interfejsa operatera.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Definiše podrazumevani atribut tiketa za sortiranje tiketa u rezultatu pretrage tiketa interfejsa operatera.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Definiše podrazumevani atribut tiketa za sortiranje tiketa u rezultatu pretrage tiketa u ovoj operaciji.',
        'Defines the default ticket bounced notification for customer/sender in the ticket bounce screen of the agent interface.' =>
            'Definiše napomene povratnog tiketa za  korisnika/pošiljaoca na prikazu ekrana za povraćaj tiketa u interfejsu operatera.',
        'Defines the default ticket next state after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja telefonske napomene na prikazu ekrana za tiket dolaznih telefonskih poziva u interfejsu operatera.',
        'Defines the default ticket next state after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Definiše podrazumevani sledeći status tiketa posle dodavanja telefonske napomene na prikazu ekrana za tiket odlaznih telefonskih poziva u interfejsu operatera.',
        'Defines the default ticket order (after priority sort) in the escalation view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiše podrazumevani redosled tiketa (posle sortiranja po prioritetu) u eskalacionom pregledu u interfejsu opreratera. Gore: Najstariji na vrhu. Dole: Najnovije na vrhu.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiše podrazumevani redosled tiketa (posle sortiranja po prioritetu) u pregledu statusa u interfejsu opreratera. Gore: Najstariji na vrhu. Dole: Najnovije na vrhu.',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiše podrazumevani redosled tiketa (posle sortiranja po prioritetu) u odgovornom pregledu u interfejsu opreratera. Gore: Najstariji na vrhu. Dole: Najnovije na vrhu.',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiše podrazumevani redosled tiketa (posle sortiranja po prioritetu) u pregledu zaključanih tiketa u interfejsu opreratera. Gore: Najstariji na vrhu. Dole: Najnovije na vrhu.',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiše podrazumevani redosled tiketa (posle sortiranja po prioritetu) u pregledu pretrage tiketa u interfejsu opreratera. Gore: Najstariji na vrhu. Dole: Najnovije na vrhu.',
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
            'Definiše podrazumevani redosled tiketa u pregledu pretrage tiketa u ovoj operaciji. Gore: Najstariji na vrhu. Dole: Najnovije na vrhu.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definiše podrazumevani redosled tiketa u posmatranom pregledu interfejsa operatera. Gore: Najstariji na vrhu. Dole: Najnovije na vrhu.',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Definiše podrazumevani redosled tiketa u pregledu pretrage rezultata u interfejsu korisnika. Gore: Najstariji na vrhu. Dole: Najnovije na vrhu.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Određuje podrazumevani prioritet tiketa na prikazu ekrana zatvorenog tiketa u interfejsu operatera.',
        'Defines the default ticket priority in the ticket bulk screen of the agent interface.' =>
            'Određuje podrazumevani prioritet tiketa na prikazu ekrana masovnih tiketa u interfejsu operatera.',
        'Defines the default ticket priority in the ticket free text screen of the agent interface.' =>
            'Određuje podrazumevani prioritet tiketa na prikazu ekrana tiketa slobodnog teksta u interfejsu operatera.',
        'Defines the default ticket priority in the ticket note screen of the agent interface.' =>
            'Određuje podrazumevani prioritet tiketa na prikazu ekrana napomene tiketa u interfejsu operatera.',
        'Defines the default ticket priority in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Određuje podrazumevani prioritet tiketa na prikazu ekrana vlasnika tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Defines the default ticket priority in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Određuje podrazumevani prioritet tiketa na prikazu ekrana tiketa na čekanju pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Defines the default ticket priority in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Određuje podrazumevani prioritet tiketa na prikazu ekrana prioritetnog tiketa pri uvećanom prikazu tiketa u interfejsu operatera',
        'Defines the default ticket priority in the ticket responsible screen of the agent interface.' =>
            'Određuje podrazumevani prioritet tiketa na prikazu ekrana odgovornog tiketa interfejsa operatera.',
        'Defines the default ticket type for new customer tickets in the customer interface.' =>
            'Određuje podrazumevani tip tiketa za tikete novog korisnika u interfejsu korisnika.',
        'Defines the default type for article in the customer interface.' =>
            'Određuje podrazumevani tip članka u interfejsu korisnika.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            'Određuje podrazumevani tip prosleđene poruke na prikaz ekrana prosleđenih tiketa interfejsa operatera.',
        'Defines the default type of the article for this operation.' => 'Određuje podrazumevani tip članka za ovu operaciju.',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana zatvorenog tiketa interfejsa operatera.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana masovnih tiketa interfejsa operatera.',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana tiketa slobodnog teksta interfejsa operatera.',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana napomene tiketa interfejsa operatera.',
        'Defines the default type of the note in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana vlasnika tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Defines the default type of the note in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana tiketa na čekanju pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Defines the default type of the note in the ticket phone inbound screen of the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana za tiket dolaznih telefonskih poziva interfejsa operatera.',
        'Defines the default type of the note in the ticket phone outbound screen of the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana za tiket odlaznih telefonskih poziva interfejsa operatera.',
        'Defines the default type of the note in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana prioritetnog tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Defines the default type of the note in the ticket responsible screen of the agent interface.' =>
            'Određuje podrazumevani tip napomene na prikazu ekrana odgovornog tiketa interfejsa operatera.',
        'Defines the default type of the note in the ticket zoom screen of the customer interface.' =>
            'Određuje podrazumevani tip napomene na ekranu uvećanog prikaza tiketa interfejsa korisnika.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the agent interface.' =>
            'Definiše podrazumevani upotrebljeni modul korisničkog dela, ako akcioni parametar nije dat u url na inerfejsu operatera.',
        'Defines the default used Frontend-Module if no Action parameter given in the url on the customer interface.' =>
            'Definiše podrazumevani upotrebljeni modul korisničkog dela, ako akcioni parametar nije dat u url na inerfejsu korisnika.',
        'Defines the default value for the action parameter for the public frontend. The action parameter is used in the scripts of the system.' =>
            'Definiše podrezumevanu vrednost za akcioni parametar za javni korisnički deo. Akcioni parametar je korišćen u skriptama sistema.',
        'Defines the default viewable sender types of a ticket (default: customer).' =>
            'Definiše podrazumevani tip vidljivog pošiljaoca tiketa (podrazmevano: korisnik).',
        'Defines the dynamic fields that are used for displaying on calendar events.' =>
            'Definiše dinamička polja koja se koriste za prikazivanje na kalendaru događaja.',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            'Definiše filter koji obrađuje tekst u člancima, da bi se istakle URL adrese.',
        'Defines the format of responses in the ticket compose screen of the agent interface ($QData{"OrigFrom"} is From 1:1, $QData{"OrigFromName"} is only realname of From).' =>
            'Definiše format odgovara na prikazu ekrana za otvaranje tiketa interfejsa operatera ($QData{"OrigFrom"} je Od 1:1, $QData{"OrigFromName"} je jedino pravo ime od Od (From).',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Definiše potpuno kvalifikovano ime domena sistema. Ovo podešavanje se koristi kao promenljiva OTRS_CONFIG_FQDN, koja se nalazi u svim formama poruka i koristi od strane aplikacije, za građenje veza do tiketa unutar vašeg sistema.',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            'Definiše grupe u kojima će se nalaziti svaki korisnik (ako je CustomerGroupSupport (Podrška grupi korisnika) aktivirana i ne želite da upravljate svakim korisnikom iz ovih grupa).',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Određuje visinu za komponentu Rich Text Editor za ovaj prikaz ekrana. Unesi broj (pikseli) ili procentualnu vrednost (relativnu).',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Određuje visinu za komponentu Rich Text Editor. Unesi broj (pikseli) ili procentualnu vrednost (relativnu).',
        'Defines the height of the legend.' => 'Određuje visinu legende.',
        'Defines the history comment for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti zatvorenog tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti email tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti telefonskog tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket free text screen action, which gets used for ticket history.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti tiketa slebodnog teksta, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti napomene tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti vlasnika tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti tiketa na čekanju, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti dolaznh telefonskih poziva tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti odlaznh telefonskih poziva tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti prioritetnih tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti odgovornih tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history comment for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Definiše komentar istorije za prikaz ekrana aktivnosti tiketa uvećanog prikaza, koji se koristi za istoriju tiketa u interfejsu  korisnika.',
        'Defines the history comment for this operation, which gets used for ticket history in the agent interface.' =>
            'Definiše komentar istorije za ovu operaciju, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the close ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti zatvorenog tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the email ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti email tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the phone ticket screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti telefonskog tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket free text screen action, which gets used for ticket history.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti tiketa slobodnog teksta, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket note screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti napomene tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket owner screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti vlasnika tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket pending screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti tiketa na čekanju, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket phone inbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti tiketa dolaznih telefonskih poziva, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket phone outbound screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti tiketa odlaznih telefonskih poziva, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket priority screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti prioritetnog tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket responsible screen action, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti odgovornog tiketa, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the history type for the ticket zoom action, which gets used for ticket history in the customer interface.' =>
            'Definiše tip istorije za prikaz ekrana aktivnosti uvećanog prikaza tiketa, koji se koristi za istoriju tiketa u interfejsu  korisnika.',
        'Defines the history type for this operation, which gets used for ticket history in the agent interface.' =>
            'Definiše tip istorije za ovu operaciju, koji se koristi za istoriju tiketa u interfejsu operatera.',
        'Defines the hours and week days of the indicated calendar, to count the working time.' =>
            'Određuje sate i dane u nedelji u naznačenom kalendaru, radi računanja radnog vremena.',
        'Defines the hours and week days to count the working time.' => 'Određuje sate i dane u nedelji radi računanja radnog vremena.',
        'Defines the key to be checked with Kernel::Modules::AgentInfo module. If this user preferences key is true, the message is accepted by the system.' =>
            'Definiše ključ koji treba proveriti sa "Kernel::Modules::AgentInfo" modulom. Ako je ovaj korisnički parametar ključa tačan, poruka će biti prihvaćena od strane sistema.',
        'Defines the key to check with CustomerAccept. If this user preferences key is true, then the message is accepted by the system.' =>
            'Definiše ključ koji treba proveriti sa "CustomerAccept" (Prihvatanje  korisnika). Ako je ovaj korisnički parametar ključa tačan, poruka će biti prihvaćena od strane sistema.',
        'Defines the legend font in graphs (place custom fonts in var/fonts).' =>
            '',
        'Defines the link type \'Normal\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Definiše tip veze \'Normal\'. Ako naziv izvora i naziv cilja sadrže iste vrednosti, dobijena veza se smatra neusmerenom; u suprotnom se kao rezultat dobija usmerena veza. ',
        'Defines the link type \'ParentChild\'. If the source name and the target name contain the same value, the resulting link is a non-directional one; otherwise, the result is a directional link.' =>
            'Definiše tip veze \'ParentChild\'. Ako naziv izvora i naziv cilja sadrže iste vrednosti, dobijena veza se smatra neusmerenom; u suprotnom se kao rezultat dobija usmerena veza.',
        'Defines the link type groups. The link types of the same group cancel one another. Example: If ticket A is linked per a \'Normal\' link with ticket B, then these tickets could not be additionally linked with link of a \'ParentChild\' relationship.' =>
            'Definiše tip veze grupa. Tipovi veze iste grupe poništavaju jedni druge. Primer: Ako je tiket A vezan preko \'Normal\' veze sa tiketom B, onda ovi tiketi ne mogu biti dodatno vezani vezom \'ParentChild\' odnosa.',
        'Defines the list of online repositories. Another installations can be used as repository, for example: Key="http://example.com/otrs/public.pl?Action=PublicRepository;File=" and Content="Some Name".' =>
            'Definiše listu online spremišta. Još instalacija može da se koristi kao spremište, na primer: Ključ="http://example.com/otrs/public.pl?Action=PublicRepository;File=" i Sadržaj="Some Name".',
        'Defines the list of possible next actions on an error screen.' =>
            'Definiše listu mogućih sledećih akcija na prikazu ekrana sa greškom.',
        'Defines the list of types for templates.' => 'Definiše listu tipova šablona.',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            'Definiše lokaciju za dobijanje spiska online spremišta za dodatne pakete. Prvi raspoloživi rezultat će biti korišćen.',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            'Definiše log modul za sistem. "File" piše sve poruke u datoj log datoteci, "Syslog" koristi sistemski log "daemon" sistema, npr. syslogd.',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            'Definiše maksimalnu veličinu (u bajtovima) za slanje datoteke preko pretraživača. Upozorenje: Podešavanje ove opcije na suviše malu vrednost može uzrokovati mnoge maske u vašem OTRS-u da prestane da radi (verovatno svaka maska koja ima ulaz od korisnika).',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Definiše maksimalno vreme važenja (u sekundama) za ID sesije.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            'Definiše maksimalnu dužinu (u karakterima) podatka zadatka planera. UPOZORENJE: Ne menjajte ova podešavanja sve dok ne budete sigurni u dužinu trenutne baze podataka za \'task_data\' popunjenu iz \'scheduler_data_list\' tabele.',
        'Defines the maximum number of pages per PDF file.' => 'Definiše maksimalni broj strana po PDF datoteci.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Definiše maksimalnu veličinu log datoteke (u megabajtima).',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            'Definiše modul koji prikazuje generičku napomenu u interfejsu operatera. Biće prikazan ili "Text" (ako je konfigursan) ili sadržaj "File".',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            'Definiše modul koji prikazuje sve trenutno prijavljene korisnike u interfejsu operatera.',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Definiše modul koji prikazuje sve trenutno prijavljene operatere u interfejsu operatera.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            'Definiše modul koji prikazuje sve trenutno prijavljene operatere u interfejsu korisnika.',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            'Definiše modul koji prikazuje sve trenutno prijavljene korisnike u interfejsu korisnika.',
        'Defines the module to authenticate customers.' => 'Definiše modul za autentifikaciju korisnika.',
        'Defines the module to display a notification in the agent interface if the scheduler is not running.' =>
            'Definiše modul za prikazivanje obaveštenja u interfejsu operatera ako planer ne radi.',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            'Definiše modul za prikazivanje obaveštenja u interfejsu operatera ako je operater prijavljen na sistem dok je opcija "van kancelarije" aktivna.',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            'Definiše modul za prikazivanje obaveštenja u interfejsu operatera ako se sistem koristi od strane admin korisnika (normalno ne treba da rade kao administrator).',
        'Defines the module to generate html refresh headers of html sites, in the customer interface.' =>
            'Definiše modul za generisanje html osvežavanja zaglavlja html sajtova u interfejsu korisnika.',
        'Defines the module to generate html refresh headers of html sites.' =>
            'Definiše modul za generisanje html osvežavanja zaglavlja html sajtova.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the "SMTP" mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            '',
        'Defines the module used to store the session data. With "DB" the frontend server can be splitted from the db server. "FS" is faster.' =>
            'Definiše modul koji se koristi za skladištenje podataka sesije. Sa "DB" pristupni server može biti odvojen od servera baze podataka. "FS" je brže.',
        'Defines the name of the application, shown in the web interface, tabs and title bar of the web browser.' =>
            'Definiše naziv aplikacije, koji se prikazuje u web interfejsu, karticama i naslovnoj traci web pretraživača.',
        'Defines the name of the column to store the data in the preferences table.' =>
            'Definiše naziv kolone za skladištenje podataka u tabeli parametara.',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            'Definiše naziv kolone za skladištenje identifikacije korisnika u tabeli parametara.',
        'Defines the name of the indicated calendar.' => 'Definiše naziv naznačenog kalendara.',
        'Defines the name of the key for customer sessions.' => 'Definiše naziv ključa za korisničke sesije.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            'Definiše naziv ključa sesije. Npr. Sesija, Sesija ID ili OTRS.',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Definiše naziv tabele, gde se skladište podešavanja korisnika.',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            'Definiše sledeće moguće statuse nakon otvaranja / odgovaranja tiketa u prikazu ekrana za otvaranje tiketa interfejsa operatera.',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            'Definiše sledeće moguće statuse nakon prosleđivanja tiketa u prikazu ekrana za prosleđivanje tiketa interfejsa operatera.',
        'Defines the next possible states for customer tickets in the customer interface.' =>
            'Definiše sledeće moguće statuse za tikete korisnika u interfejsu korisnika.',
        'Defines the next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Definiše sledeći status tiketa nakon dodavanja napomene u prikazu ekrana zatvorenog tiketa interfejsa operatera.',
        'Defines the next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Definiše sledeći status tiketa nakon dodavanja napomene u prikazu ekrana masovnih tiketa interfejsa operatera.',
        'Defines the next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Definiše sledeći status tiketa nakon dodavanja napomene u prikazu ekrana tiketa slobodnog teksta interfejsa operatera.',
        'Defines the next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Definiše sledeći status tiketa nakon dodavanja napomene u prikazu ekrana napomene tiketa interfejsa operatera.',
        'Defines the next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definiše sledeći status tiketa nakon dodavanja napomene u prikazu ekrana vlasnika tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Defines the next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definiše sledeći status tiketa nakon dodavanja napomene u prikazu ekrana tiketa na čekanju pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Defines the next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definiše sledeći status tiketa nakon dodavanja napomene u prikazu ekrana prioritetnog tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Defines the next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definiše sledeći status tiketa nakon dodavanja napomene u prikazu ekrana odgovornog tiketa u interfejsu operatera.',
        'Defines the next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Definiše sledeći status tiketa nakon vraćanja, u prikazu ekrana za povraćaj tiketa interfejsa operatera.',
        'Defines the next state of a ticket after being moved to another queue, in the move ticket screen of the agent interface.' =>
            'Definiše sledeći status tiketa nakon što je pomeren u drugi red u prikazu ekrana pomerenog tiketa interfejsa operatera.',
        'Defines the parameters for the customer preferences table.' => 'Definiše parametre za tabelu podešavanja korisnika.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Definiše parametre za pozadinski prikaz kontrolne table. "Grupa" se koristi da ograniči pristup plugin-u (npr. Grupa: admin;group1;group2;). "Podrazumevano" ukazuje na to da je plugin podrazumevano aktiviran ili da je potrebno da ga korisnik manuelno aktivira. "CacheTTL" ukazje na istek perioda u minutama tokom kog se plugin čuva u kešu.',
        'Defines the parameters for the dashboard backend. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Definiše parametre za pozadinski prikaz kontrolne table. "Grupa" se koristi da ograniči pristup plugin-u (npr. Grupa: admin;group1;group2;). "Podrazumevano" ukazuje na to da je plugin podrazumevano aktiviran ili da je potrebno da ga korisnik manuelno aktivira. "CacheTTLLocal" ukazje na istek perioda u minutama tokom kog se plugin čuva u kešu.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            'Definiše parametre za pozadinski prikaz kontrolne table. "Limit" definiše broj unosa podrezumevano prikazanih. "Grupa" se koristi da ograniči pristup plugin-u (npr. Grupa: admin;group1;group2;). "Podrazumevano" ukazuje na to da je plugin podrazumevano aktiviran ili da je potrebno da ga korisnik manuelno aktivira. "CacheTTL" ukazje na istek perioda u minutama tokom kog se plugin čuva u kešu.',
        'Defines the parameters for the dashboard backend. "Limit" defines the number of entries displayed by default. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" defines the cache expiration period in minutes for the plugin.' =>
            'Definiše parametre za pozadinski prikaz kontrolne table. "Limit" definiše broj unosa podrezumevano prikazanih. "Grupa" se koristi da ograniči pristup plugin-u (npr. Grupa: admin;group1;group2;). "Podrazumevano" ukazuje na to da je plugin podrazumevano aktiviran ili da je potrebno da ga korisnik manuelno aktivira. "CacheTTLLocal" ukazje na istek perioda u minutama tokom kog se plugin čuva u kešu.',
        'Defines the password to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Definiše lozinku za pristup SOAP rukovanju (bin/cgi-bin/rpc.pl).',
        'Defines the path and TTF-File to handle bold italic monospaced font in PDF documents.' =>
            'Definiše putanju i TTF-Direktorijum za rukovanje podebljanim kurzivnim neproporcionalnim fontom ("bold italic monospaced font") u PDF dokumentima.',
        'Defines the path and TTF-File to handle bold italic proportional font in PDF documents.' =>
            'Definiše putanju i TTF-Direktorijum za rukovanje podebljanim kurzivnim proporcionalnim fontom ("bold italic proportional font") u PDF dokumentima.',
        'Defines the path and TTF-File to handle bold monospaced font in PDF documents.' =>
            'Definiše putanju i TTF-Direktorijum za rukovanje podebljanim neproporcionalnim fontom ("bold monospaced font") u PDF dokumentima.',
        'Defines the path and TTF-File to handle bold proportional font in PDF documents.' =>
            'Definiše putanju i TTF-Direktorijum za rukovanje podebljanim proporcionalnim fontom ("bold proportional font") u PDF dokumentima.',
        'Defines the path and TTF-File to handle italic monospaced font in PDF documents.' =>
            'Definiše putanju i TTF-Direktorijum za rukovanje kurzivnim neproporcionalnim fontom ("italic monospaced font") u PDF dokumentima.',
        'Defines the path and TTF-File to handle italic proportional font in PDF documents.' =>
            'Definiše putanju i TTF-Direktorijum za rukovanje kurzivnim proporcionalnim fontom ("italic proportional font") u PDF dokumentima.',
        'Defines the path and TTF-File to handle monospaced font in PDF documents.' =>
            'Definiše putanju i TTF-Direktorijum za rukovanje neproporcionalnim fontom ("monospaced font") u PDF dokumentima.',
        'Defines the path and TTF-File to handle proportional font in PDF documents.' =>
            'Definiše putanju i TTF-Direktorijum za rukovanje proporcionalnim fontom ("proportional font") u PDF dokumentima.',
        'Defines the path for scheduler to store its console output (SchedulerOUT.log and SchedulerERR.log).' =>
            'Određuje putanju za planera za skladištenje izlaza njegove konzole (SchedulerOUT.log i SchedulerERR.log). ',
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Standard/CustomerAccept.dtl.' =>
            'Određuje putanju prikazanog info direktorijuma koji je lociran pod Kernel/Output/HTML/Standard/CustomerAccept.dtl.',
        'Defines the path to PGP binary.' => 'Određuje putanju do PGP binary.',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            'Određuje putanju do open ssl binary. Može biti potrebno HOME Env ($ENV{HOME} = \'/var/lib/wwwrun\';).',
        'Defines the placement of the legend. This should be a two letter key of the form: \'B[LCR]|R[TCB]\'. The first letter indicates the placement (Bottom or Right), and the second letter the alignment (Left, Right, Center, Top, or Bottom).' =>
            'Određuje mesto za legendu. Trebalo bi da budu dva slova ključa u formi: \'B[LCR]|R[TCB]\'. Prvo slovo označava mesto (Dole ili Desno), a drugo slovo poziciju (Levo, Desno, Centrirano, Gore ili Dole).',
        'Defines the postmaster default queue.' => 'Definiše podrazumevani red postmastera.',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the agent interface.' =>
            'Definiše ciljnog primaoca telefonskog tiketa i pošiljaoca e-mail tiketa ("Red" prikaži sve redove, "Sistemska Adresa" prikaži sve sistemske adrese) u interfejsu operatera.',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            'Definiše ciljnog primaoca tiketa ("Red" prikaži sve redove, "Sistemska Adresa" prikaži sve sistemske adrese) u interfejsu korisnika.',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            'Definiše zahtevanu dozvolu za prikaz tiketa u eskalacionom pregledu interfejsa operatera.',
        'Defines the search limit for the stats.' => 'Definiše granicu pretrage za statistike.',
        'Defines the sender for rejected emails.' => 'Definiše pošiljaoca odbijenih email poruka.',
        'Defines the separator between the agents real name and the given queue email address.' =>
            'Određuje separator između pravog imena operatera i email adrese dodeljene redu.',
        'Defines the spacing of the legends.' => 'Određuje razmake u legendi.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            'Definiše standardne dozvole raspoložive za korisnike u aplikaciji. Ukoliko je potrebno više dozvola, možete ih uneti ovde. Da bi bile efektivne, dozvole moraju biti nepromenljive. Molimo proverite kada dodajete bilo koju od gore navedenih dozvola, da "rw" dozvola podseća na poslednji unos.',
        'Defines the standard size of PDF pages.' => 'Definiše standardnu veličinu PDF stranica.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Definiše stanje tiketa ukoliko dobije nastavak, a tiket je već zatvoen.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Definiše stanje tiketa ukoliko dobije nastavak.',
        'Defines the state type of the reminder for pending tickets.' => 'Definiše dip statusa podsetnika za tikete na čekanju.',
        'Defines the subject for notification mails sent to agents, about new password.' =>
            'Definiše predmet za email poruke obaveštenja poslata operaterima, o novoj lozinki.',
        'Defines the subject for notification mails sent to agents, with token about new requested password.' =>
            'Definiše predmet za email poruke obaveštenja poslata operaterima, sa tokenom o novoj zahtevanoj lozinki.',
        'Defines the subject for notification mails sent to customers, about new account.' =>
            'Definiše predmet za email poruke obaveštenja poslata korisnicima, o novom nalogu.',
        'Defines the subject for notification mails sent to customers, about new password.' =>
            'Definiše predmet za email poruke obaveštenja poslata korisnicima, o novoj lozinki.',
        'Defines the subject for notification mails sent to customers, with token about new requested password.' =>
            'Definiše predmet za email poruke obaveštenja poslata korisnicima, sa tokenom o novoj zahtevanoj lozinki.',
        'Defines the subject for rejected emails.' => 'Definiše predmet za odbačene poruke.',
        'Defines the system administrator\'s email address. It will be displayed in the error screens of the application.' =>
            'Definiše email adresu sistem administratora. Ona će biti prikazana na ekranima sa greškom u aplikaciji.',
        'Defines the system identifier. Every ticket number and http session string contains this ID. This ensures that only tickets which belong to your system will be processed as follow-ups (useful when communicating between two instances of OTRS).' =>
            'Definiše identifikator sistema. Svaki broj tiketa i niz znakova http sesije sadrši ovaj ID. Ovo osigurava da će samo tiketi koji pripadaju sistemu biti obrađeni kao operacije praćenja (korisno kada se odvija komunikacija između dve instance OTRS-a.',
        'Defines the target attribute in the link to external customer database. E.g. \'AsPopup PopupType_TicketAction\'.' =>
            'Definiše ciljni atribut u vezi sa eksternom bazom podataka korisnika. Npr. \'AsPopup PopupType_TicketAction\'.',
        'Defines the target attribute in the link to external customer database. E.g. \'target="cdb"\'.' =>
            'Definiše ciljni atribut u vezi sa eksternom bazom podataka korisnika. Npr. \'target="cdb"\'.',
        'Defines the ticket fields that are going to be displayed calendar events. The "Key" defines the field or ticket attribute and the "Content" defines the display name.' =>
            'Definiše polja tiketa koja će biti prikazana u kalendaru događaja. "Ključ" definiše polje ili atribut tiketa, a "Sadržaj" definiše prikazano ime.',
        'Defines the time in days to keep log backup files.' => 'Definiše vreme u danima za čuvanje evidencije bekapovanih datoteka.',
        'Defines the time in seconds after which the Scheduler performs an automatic self-restart.' =>
            'Definiše vreme u sekundama nakon kojeg Planer automatski izvršava samo-restartovanje.',
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            'Definiše vremensku zonu naznačenog kalendara, koja kasnije može biti dodeljena određenom redu.',
        'Defines the title font in graphs (place custom fonts in var/fonts).' =>
            'Definiše font za naslov u graficima (snimite željeni font u var/fons).',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            'Definiše tip protokola korišćenog od strane veb servera, za potrebe aplikacije. Ako se koristi https protokol umesto plain http, mora biti ovde naznačeno. Pošto ovo nema uticaja na podešavanja ili ponašanje veb servera, neće promeniti način pristupa aplikaciji i, ako je to pogrešno, neće vas sprečiti da se prijavite u aplikaciju. Ovo podešavanje se koristi samo kao promenljiva, OTRS_CONFIG_HttpType koja se nalazi u svim oblicima poruka korišćenih od strane aplikacije, da izgrade veze sa tiketima u vašem sistemu.',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            'Definiše korišćene karaktere za plaintext email navode u prikazu ekrana otvorenog tiketa interfejsa operatera. Ukoliko je ovo prazno ili neaktivno, originalni email-ovi neće biti navedeni, nego dodati odgovoru.',
        'Defines the user identifier for the customer panel.' => 'Određuje identifikator korisnika za korisnički panel.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            'Definiše korisničko ime za pristup SOAP rukovanju (bin/cgi-bin/rpc.pl).',
        'Defines the valid state types for a ticket.' => 'Određuje važeće tipove statusa za tiket.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.UnlockTickets.pl" can be used.' =>
            'Definiše važeće tipove statusa za otključane tikete. Za otključane tikete može se koristiti skripta "bin/otrs.UnlockTickets.pl"',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            'Definiše vidljivo zaključavanje tiketa. Podrazumevano: otključano, tmp_lock.',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            'Određuje širinu za komponentu rich text editor za ovaj prikaz ekrana. Unesi broj (pikseli) ili procentualnu vrednost (relativnu).',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            'Određuje širinu za komponentu rich text editor. Unesi broj (pikseli) ili procentualnu vrednost (relativnu).',
        'Defines the width of the legend.' => 'Određuje širinu legende.',
        'Defines which article sender types should be shown in the preview of a ticket.' =>
            'Definiše koji tipovi pošiljaoca artikla treba da budu prikazani u prgledu tiketa.',
        'Defines which items are available for \'Action\' in third level of the ACL structure.' =>
            'Definiše koje su stavke slobodne za \'Action\' u trećem nivou ACL strukture.',
        'Defines which items are available in first level of the ACL structure.' =>
            'Definiše koje su stavke slobodne za u prvom nivou ACL strukture.',
        'Defines which items are available in second level of the ACL structure.' =>
            'Definiše koje su stavke slobodne za u drugom nivou ACL strukture.',
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            'Definiše koji statusi treba da budu automatski podešeni (Sadržaj), nakon dostizanja vremena čekanja statusa (Ključ).',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            'Дефинише који тип чланка треба да буде проширен приликом уласка у преглед. Ако ништа није дефинисано, последњи чланак ће бити проширен.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            'Briše sesiju ukoliko je ID sesije korišćen preko nevažeće udaljene IP adrese.',
        'Deletes requested sessions if they have timed out.' => 'Briše zahtevanu sesiju ako je isteklo vreme.',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            'Određuje da li lista mogućih redova za premeštanje u tiket treba da bude prikazana u padajućoj listi ili u novom prozoru u interfejsu operatera. Ako je podešen "Novi prozor" možete dodavati napomene o premeštanju u tiket.',
        'Determines if the statistics module may generate ticket lists.' =>
            'Određuje da li statistički modul može generisati liste tiketa.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            'Određuje sledeći mogući status tiketa, nakon kreiranja novog email tiketa u interfejsu operatera.',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            'Određuje sledeći mogući status tiketa, nakon kreiranja novog telefonskog tiketa u interfejsu operatera.',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            'Određuje sledeći mogući status tiketa, za tikete procesa u interfejsu operatera.',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            'Određuje sledeći prikaz ekrana, nakon tiketa novog korisnika u interfejsu korisnika.',
        'Determines the next screen after the follow up screen of a zoomed ticket in the customer interface.' =>
            'Određuje sledeći prikaz ekrana, nakon narednog prikaza ekrana pri uvećanju tiketa u interfejsu korisnika.',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            'Određuje sledeći prikaz ekrana, nakon premeštanja tiketa. LastScreenOverview će vratiti poslednji pregled ekrana (npr. rezultati pretrage, pregled redova, kontrolna tabla). TicketZoom će vratiti na uvećanje tiketa.',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            'Određuje mogući status za tikete na čekanju koji menjaju status nakon dostizanja vremenskog limita.',
        'Determines the strings that will be shown as receipent (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Određuje niz znakova koji će biti prikazani kao primaoc (Za:) u telefonskom tiketu i kao pošiljaoc (Od) u email tiketu interfejsa operatera. Za red kao NewQueueSelectionType "<Queue>" prikazuje imena redova i za sistemsku adresu "<Realname> <<Email>>" prikazuje ime i email primaoca.',
        'Determines the strings that will be shown as receipent (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the receipent.' =>
            'Određuje niz znakova koji će biti prikazani kao primaoc (Za:) u tiketu u interfejsu korisnika. Za red kao CustomerPanelSelectionType "<Queue>" prikazuje imena redova i za sistemsku adresu "<Realname> <<Email>>" prikazuje ime i email primaoca.',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            'Određuje način na koji se povezani objekti prikazuju u svakoj uvećanoj maski.',
        'Determines which options will be valid of the recepient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            'Određuje koje će opcije biti ispravne za primaoca (telefonski tiket) i pošiljaoca (email tiket) u interfejsu operatera.',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            'Određuje koji će redovi biti ispravni za tikete primaoca u interfejsu korisnika.',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            'Onemogući ograničenu sigurnost IFrame-ova u IE. Može biti zahtevano za SSO da radi u IE8.',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            'Онемогућује слање обавештења подсетника одговорном оператеру тикета (Ticket::Responsible мора бити активиран).',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            'Onemogućuje veb instalacionom programu (http://yourhost.example.com/otrs/installer.pl) da zaštiti sistem od nedozvoljenog preuzimanja. Ako podesite na "Ne", sistem može biti ponovo instaliran i trenutna osnovna konfiguracija će biti korišćena da unapred popuni pitanja unutar instalacione skripte. Ukoliko nije aktivno, takođe se onemogućuju GenericAgent, PackageManager i SQL Box.',
        'Display settings to override defaults for Process Tickets.' => 'Prikaži podešavanja da bi ste zamenili podrazumevana za tikete procesa.',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            'Prikazuje obračunato vreme za jedan članak u prikazu uvećanog tiketa.',
        'Dropdown' => 'Padajući',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => 'Dinamička polja GUI',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => 'Ograničen pregled dinamičkih polja',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            'Dinamička polja korišćena za izvoz rezultata pretrage u CSV format.',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            'Grupe dinamičkih polja za obradu aplikativnog dodatka (widget). Ključ je naziv grupe, vrednost sadrži polje koje će biti prikazano. Primer: \'Key => My Group\', \'Content: Name_X, NameY\'.',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Ograničenje dinamičkih polja po strani za prikaz dinamičkih polja.',
        'Dynamic fields options shown in the ticket message screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required. NOTE. If you want to display these fields also in the ticket zoom of the customer interface, you have to enable them in CustomerTicketZoom###DynamicField.' =>
            'Opcije dinamičkih polja prikazane na ekranu poruke tiketa interfejsa kupca. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano. NAPOMENA: Ako želite da prikažete ova polja takođe i pri uvećanom prikazu tiketa interfejsa korisnika, treba da ih omogućite u CustomerTicketZoom###DynamicField.',
        'Dynamic fields options shown in the ticket reply section in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Opcije dinamičkih polja prikazane u odeljku odgovora tiketa pri uvećanom prikazu ekrana tiketa interfejsa kupca. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the process widget in ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana u procesu aplikativnog dodatka (widget-a) pri uvećanom prikazu ekrana tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'Dynamic fields shown in the sidebar of the ticket zoom screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana u izvojenom delu uvećanog prikaza ekrana tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'Dynamic fields shown in the ticket close screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu zatvorenog tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket compose screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu otvorenog tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket email screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu email tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket forward screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu prosleđenog tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket free text screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu tiketa slobodnog teksta interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket medium format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana na ekranu pregleda srednjeg formata tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'Dynamic fields shown in the ticket move screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu premeštenog tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket note screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu napomene tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket overview screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu pregleda tiketa interfejsa korisnika. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket owner screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu vlasnika tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket pending screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu tiketa na čekanju interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket phone inbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu tiketa dolaznih telefonskih poziva interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket phone outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu tiketa odlaznih telefonskih poziva interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket phone screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu tekefonskog tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket preview format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana na ekranu pregleda u preview formatu tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'Dynamic fields shown in the ticket print screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana na ekranu štampe tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'Dynamic fields shown in the ticket print screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana na ekranu štampe tiketa interfejsa korisnika. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'Dynamic fields shown in the ticket priority screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu prioritetnog tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket responsible screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
            'Dinamička polja prikazana na ekranu odgovornog za tiket interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket search overview results screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana na ekranu pregleda rezultata pretrage tiketa interfejsa korisnika. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'Dynamic fields shown in the ticket search screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and shown by default.' =>
            'Dinamička polja prikazana na ekranu pretrage tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket search screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana na ekranu pretrage tiketa interfejsa korisnika. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            'Dinamička polja prikazana na ekranu pregleda malog formata tiketa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno, 2 = Omogućeno i zahtevano.',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            'Dinamička polja prikazana na ekranu uvećanog tiketa interfejsa korisnika. Moguća podešavanja: 0 = Onemogućeno, 1 = Omogućeno.',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => 'Uredi firmu korisnika',
        'Email Addresses' => 'Email adrese',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => 'Omogućeni filteri',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Omogućava PDF izlaz. CPAN modul PDF::API2 je zahtevan, ako nije instaliran, PDF izlaz će biti onemogućen.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            'Obezbeđuje PGP podršku. Kada je PGP podrška omogućena za potpisivanje i enkriprovanje mail.a, strogo se preporučuje da web server radi kao OTRS korisnik. U suprotnom, biće problema sa privilegijama prilikom pristupa .gnupg folderu.',
        'Enables S/MIME support.' => 'Omogućava S/MIME podršku.',
        'Enables customers to create their own accounts.' => 'Omogućava korisnicima da kreiraju sopstvene naloge.',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Omogućava podršku za proveru pravopisa.',
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
        'Firstname Lastname' => 'Ime Prezime',
        'Firstname Lastname (UserLogin)' => 'Ime Prezime (Prijava korisnika)',
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
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
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
        'Lastname, Firstname' => 'Prezime, Ime',
        'Lastname, Firstname (UserLogin)' => 'Prezime, Ime (Prijava korisnika)',
        'Link agents to groups.' => 'Poveži operatere sa gupama.',
        'Link agents to roles.' => 'Poveži operatere sa ulogama.',
        'Link attachments to templates.' => 'Poveži priloge sa šablonima.',
        'Link customer user to groups.' => 'Poveži korisnike korisnika sa grupama.',
        'Link customer user to services.' => 'Poveži korisnike korisnika sa servisima.',
        'Link queues to auto responses.' => 'Poveži redove sa automatskim odgovorima.',
        'Link roles to groups.' => 'Poveži uloge sa grupama.',
        'Link templates to queues.' => 'Poveži šablone sa redovima.',
        'Links 2 tickets with a "Normal" type link.' => 'Poveži 2 tiketa tipom veze "Normal".',
        'Links 2 tickets with a "ParentChild" type link.' => 'Poveži 2 tiketa tipom veze "ParentChild"',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Lista CSS direktorijuma uvek učitanih za interfejs operatera.',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Lista CSS direktorijuma uvek učitanih za interfejs korisnika.',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Lista posebnih IE8 CSS direktorijuma uvek učitanih za interfejs operatera.',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Lista posebnih IE8 CSS direktorijuma uvek učitanih za interfejs korisnika.',
        'List of JS files to always be loaded for the agent interface.' =>
            'Lista JS direktorijuma uvek učitanih za interfejs operatera.',
        'List of JS files to always be loaded for the customer interface.' =>
            'Lista JS direktorijuma uvek učitanih za interfejs korisnika.',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
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
        'Manage OTRS Group services.' => 'Upravljanje servisima OTRS Grupe.',
        'Manage PGP keys for email encryption.' => 'Upravljanje PGP ključevima za email enkripciju.',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Upravljanje POP3 ili IMAP nalozima za preuzimanje email-a od.',
        'Manage S/MIME certificates for email encryption.' => 'Upravljanje S/MIME sertifikatima za email enkripciju.',
        'Manage existing sessions.' => 'Upravljanje postojećim sesijama.',
        'Manage notifications that are sent to agents.' => 'Upravljanje obaveštenjima poslatim operaterima.',
        'Manage system registration.' => 'Upravljanje sistem registracijom.',
        'Manage tasks triggered by event or time based execution.' => '',
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
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => 'Modul za proveru korisničkih dozvola.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
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
        'New email ticket' => 'Novi email tiket',
        'New phone ticket' => 'Novi telefonski tiket',
        'New process ticket' => 'Novi tiket procesa',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            'Sledeći mogući status tiketa nakon dodavanja telefonske napomene u prikazu ekrana dolaznih poziva interfejsa operatera.',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            'Sledeći mogući status tiketa nakon dodavanja telefonske napomene u prikazu ekrana odlaznih poziva interfejsa operatera.',
        'Notifications (Event)' => 'Obaveštenja (Događaj)',
        'Number of displayed tickets' => 'Broj prikazanih tiketa',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Broj linija (po tiketu) prikazanih prema uslužnoj pretrazi u interfejsu operatera.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Broj tiketa koji će biti prikazani na svakoj strani rezultata pretrage u interfejsu operatera.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Broj tiketa koji će biti prikazani na svakoj strani rezultata pretrage u interfejsu korisnika.',
        'Open tickets of customer' => 'Otvoreni tiketi od korisnika',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            'Preopterećuje (redefinisano) postojeće fuckcije u Kernel::System::Ticket. Koristi se za lako dodavanje prilagođavanja.',
        'Overview Escalated Tickets' => 'Pregled eskaliralih tiketa',
        'Overview Refresh Time' => 'Pregled vremena osvežavanja',
        'Overview of all open Tickets.' => 'Pregled svih otvorenih tiketa.',
        'PGP Key Management' => 'Upravljanje PGP ključem',
        'PGP Key Upload' => 'Slanje PGP ključa',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => 'Parametri za .',
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
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
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
        'Picture-Upload' => 'Otpremanje slike',
        'PostMaster Filters' => '"PostMaster" filteri',
        'PostMaster Mail Accounts' => '"PostMaster" mail nalozi',
        'Process Information' => 'Informacije o procesu',
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
            'Prepoznaj ako se tiket prati do postojećeg tiketa korišćenjem eksternog broja tiketa.',
        'Refresh Overviews after' => 'Osveži pregled posle',
        'Refresh interval' => 'Interval osvežavanja',
        'Removes the ticket watcher information when a ticket is archived.' =>
            'Uklanja informacije posmatrača tiketa kada se tiket arhivira.',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Zamenjuje originalnog pošiljaoca sa email adresom aktuelnog korisnika pri kreiranju odgovora u prozoru za pisanje odgovora interfejsa operatera.',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Potrebne dozvole za promenu korisnika tiketa u interfejsu operatera.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana za zatvaranje tiketa u interfejsu operatera.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekranaza odbijanje tiketa u interfejsu operatera.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana za otvaranje tiketa u interfejsu operatera.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana za prosleđivanje tiketa u interfejsu operatera.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana slobodnog teksta tiketa u interfejsu operatera.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana za spajanje tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana za napomene tiketa u interfejsu operatera.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana vlasnika tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana tiketa na čekanju pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana tiketa dolaznih poziva u interfejsu operatera.',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana tiketa odlaznih poziva u interfejsu operatera.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana prioritetnog tiketa pri uvećanom prikazu tiketa u interfejsu operatera.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prikaza ekrana odgovornog za tiket u interfejsu operatera.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Resetuje i otključava vlasnika tiketa ako je premešten u drugi red.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Vraća tiket iz arhive (samo ako je događaj promena statusa od zatvorenog na bilo koji dostupan otvoreni status).',
        'Roles <-> Groups' => 'Uloge <-> Grupe',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Slanje S/MIME sertifikata',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search Customer' => 'Traži korisnika',
        'Search User' => 'Traži korisnika',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            'Bira modul za rukovanje prenešenim datotekama preko veb interfejsa. "DB" skladišti sve prenešene datoteke u bazu podataka, "FS" koristi sistem datoteka.',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            'Bira modul za generisanje broja tiketa. "AutoIncrement" uvećava broj tiketa, ID sistema i brojač se koriste u SistemID.brojač formatu (npr. 1010138, 1010139). Sa "Date" brojevi tiketa će biti generisani preko trenutnog datuma, ID-a sistema i brojača. Format će izgledati kao Godina.Mesec.Dan.SistemID.brojač (npr. 2002070110101520, 2002070110101535). Sa "DateChecksum" brojač će biti dodat kao kontrolni zbir nizu sačinjenom od datuma i ID-a sistema. Kontrolni zbir će se smenjivati na dnevnom nivou. Format izgleda ovako: Godina.Mesec.Dan.SistemID.Brojač.KontrolniZbir (npr. 2002070110101520, 2002070110101535). "Slučajno" generiše brojeve tiketa po slobodnom izboru u formatu "SistemID.Slučajno" (npr. 1010138, 1010139).',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            '',
        'Send notifications to users.' => 'Pošalji obaveštenja korisnicima.',
        'Send ticket follow up notifications' => 'Pošalji obaveštenja o nastavku tiketa',
        'Sender type for new tickets from the customer inteface.' => 'Tip pošiljaoca za nove tikete iz interfejsa korisnika.',
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
        'Sets if SLA must be selected by the agent.' => 'Podešava ako SLA mora biti izabran od strane operatera.',
        'Sets if SLA must be selected by the customer.' => 'Podešava ako SLA mora biti izabran od strane korisnika.',
        'Sets if note must be filled in by the agent.' => 'Podešava ako napomena mora biti uneta od strane operatera.',
        'Sets if service must be selected by the agent.' => 'Podešava ako usluga mora biti izabrana od strane operatera.',
        'Sets if service must be selected by the customer.' => 'Podešava ako usluga mora biti izabrana od strane korisnika.',
        'Sets if ticket owner must be selected by the agent.' => 'Podešava ako vlasnik tiketa mora biti izabran od strane operatera.',
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
        'Specifies the background color of the chart.' => 'Određuje boju pozadine grafikona.',
        'Specifies the background color of the picture.' => 'Određuje boju pozadine slike.',
        'Specifies the border color of the chart.' => 'Određuje boju okvira grafikona.',
        'Specifies the border color of the legend.' => 'Određuje boju okvira legende.',
        'Specifies the bottom margin of the chart.' => 'Određuje donju marginu grafikona.',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            'Određuje različite tipove artikala koji će se koristiti u sistemu.',
        'Specifies the different note types that will be used in the system.' =>
            'Određuje različite tipove napomena koji će se koristiti u sistemu.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Određuje direktorijum za skladištenje podataka ako je "FS" izabran za TicketStorageModule.',
        'Specifies the directory where SSL certificates are stored.' => 'Određuje direktorijum gde se SSL sertifikati skladište.',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Određuje direktorijum gde se privatni SSL sertifikati skladište.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Određuje email adresu koju bi trebala da koristi aplikacija kada šalje obaveštenja. Email adresa se koristi za građenje komplatnog prikazanog naziva glavnog obaveštenja (npr. "OTRS Notification Master" otrs@your.example.com). Možete koristiti OTRS_CONFIG_FQDN varijablu kao podešavanje u vašoj konfiguraciji ili izaberite drugu email adresu. Obaveštenja su poruke kao en::Customer::QueueUpdate ili en::Agent::Move.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            'Određuje grupu gde su korisnicima potrebne rw dozvole kako bi mogli pristupiti funkciji "SwitchToCustomer".',
        'Specifies the left margin of the chart.' => 'Određuje levu marginu grafikona.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Određuje ime koje bi trebala da koristi aplikacija kada šalje obaveštenja. Ime pošiljaoca se koristi za građenje komplatnog prikazanog naziva glavnog obaveštenja (npr. "OTRS Notification Master" otrs@your.example.com). Obaveštenja su poruke kao en::Customer::QueueUpdate ili en::Agent::Move.',
        'Specifies the order in which the firstname and the lastname of agents will be displayed.' =>
            'Određuje redosled kojim će biti prikazano ime i prezime operatera.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Određuje putanju datoteke logoa u zaglavlju strane (gif|jpg|png, 700 x 100 pixel',
        'Specifies the path of the file for the performance log.' => 'Određuje putanju datoteke za performansu log-a.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Određuje putanju konvertora koji dozvoljava pregled Microsoft Excel datoteka u web interfejsu.',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Određuje putanju konvertora koji dozvoljava pregled Microsoft Word datoteka u web interfejsu.',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Određuje putanju konvertora koji dozvoljava pregled PDF dokumenata u web interfejsu.',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Određuje putanju konvertora koji dozvoljava pregled XML datoteka u web interfejsu.',
        'Specifies the right margin of the chart.' => 'Određuje desnu marginu grafikona.',
        'Specifies the text color of the chart (e. g. caption).' => 'Određuje boju teksta grafikona.',
        'Specifies the text color of the legend.' => 'Određuje boju teksta legende.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Određuje tekst koji treba da se pojavi u log datoteci da označi ulazak CGI skripte.',
        'Specifies the top margin of the chart.' => 'Određuje gornju marginu grafikona.',
        'Specifies user id of the postmaster data base.' => 'Određuje ID korisnika postmaster baze podataka.',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            'Navođenje koliko nivoa poddirektorijuma da koristi prilikom kreiranja keš fajlova. To bi trebalo da spreči previše keš fajlova u jednom direktorijumu.',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Standardne raspoložive dozvole za operatere unutar aplikacije. Ukoliko je potrebno više dozvola oni mogu uneti ovde. Dozvole moraju biti definisane da budu efektivne. Neke druge dozvole su takođe obezbeđene ugrađivanjem u: napomenu, zatvori, na čekanju, klijent, slobodan tekst, pomeri, otvori, odgovoran, prosledi i povrati. Obezbedi da "rw" uvek bude poslednja registrovana dozvo',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Početni broj za brojanje statistika. Svaka nova statistika povećava ovaj broj.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            'Počinje džoker pretragu aktivnog objekta nakon pokretanja veze maske objekta.',
        'Statistics' => 'Statistike',
        'Status view' => 'Pregled statusa',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'Čuva kolačiće nakon zatvaranja pretraživača.',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Templates <-> Queues' => 'Šabloni <-> Redovi',
        'Textarea' => 'Oblast teksta',
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
        'This option will deny the access to customer company tickets, which are not created by the customer user.' =>
            '',
        'This setting allows you to override the built-in country list with your own list of countries. This is particularly handy if you just want to use a small select group of countries.' =>
            '',
        'Ticket Queue Overview' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Pregled tiketa',
        'TicketNumber' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            'Uključivanje provere udaljene IP adrese. Treba biti podešeno na "Ne" ako se aplikacija koristi, na primer preko proxy farme ili dialup konekcije, zato što je udaljena IP adresa uglavnom drugačija za zahteve.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Ažuriraj oznaku viđenih tiketa ako su svi pregledani ili je kreiran novi članak.',
        'Update and extend your system with software packages.' => 'Ažuriraj i nadogradi sistem softverskim paketima.',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Ažuriraj indeks eskalacije tiketa posle ažuriranja atributa tiketa.',
        'Updates the ticket index accelerator.' => 'Ažuriraj akcelerator indeksa tiketa.',
        'UserFirstname' => 'Ime korisnika',
        'UserLastname' => 'Prezime korisnika',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            'Koristi Cc primaoce u uzvraćenoj Cc listi na sastavljenom email odgovoru na prikazu ekrana otvorenog tiketa u interfejsu operatera.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            'Koristi richtekt format za pregled i uređivanje: članaka, pozdrava, potpisa, standardnih šablona, automatskih odgovora i obaveštenja.',
        'View performance benchmark results.' => 'Pregled rezultata provere performansi.',
        'View system log messages.' => 'Pregled poruka sistemskog dnevnika.',
        'Wear this frontend skin' => 'Primeni ovaj izgled interfejsa',
        'Webservice path separator.' => 'Razdelnik putanje web servisa.',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            'Kada su tiketi spojeni, napomena će biti automatski dodata tiketu koji nije više aktivan. Ovde možete definisati telo ove napomene (ovaj tekst se ne može promeniti od strane operatera).',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            'Kada su tiketi spojeni, napomena će biti automatski dodata tiketu koji nije više aktivan. Ovde možete definisati predmet ove napomene (ovaj predmet se ne može promeniti od strane operatera).',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Kada su tiketi spojeni, korisnik može biti informisan emailom postavljanjem polje za potvrdu "Obavesti pošiljaoca". U prostoru za tekst, možete definisati unapred formatirani tekst koji kasnije biti modifikovan od strane operatera.',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Izabrani omiljeni redovi. Ako je aktivirano, dobiđete i obaveštenje o ovim redovima.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        ' (work units)' => ' (elementi posla)',
        'Add Customer Company' => 'Dodaj Korisničku Firmu',
        'Add Response' => 'Dodaj Odgovor',
        'Add customer company' => 'Dodaj korisničku firmu',
        'Add response' => 'Dodaj odgovor',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Dodaje korisničke email adrese primaocima u prozoru za otvaranje tiketa na interfejsu operatera.',
        'Attachments <-> Responses' => 'Prilozi <-> Odgovori',
        'Change Attachment Relations for Response' => 'Promeni veze sa prilozima za odgovor',
        'Change Queue Relations for Response' => 'Promeni veze sa redovima za odgovor',
        'Change Response Relations for Attachment' => 'Promeni veze sa odgovorima za prilog',
        'Change Response Relations for Queue' => 'Promeni veze sa odgovorima za red',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            'Kolone koje se mogu filtrirati u eskalacionom pregledu interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno , 1 = Dostupno , 2 = Omogućeno, po podrazumevanom podešavanju. Napomena: Nema više dozvoljenih kolona, kolone će biti odbačene.',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            'Kolone koje se mogu filtrirati u zaključanom pregledu interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno , 1 = Dostupno , 2 = Omogućeno, po podrazumevanom podešavanju. Napomena: Nema više dozvoljenih kolona, kolone će biti odbačene.',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            'Kolone koje se mogu filtrirati u pregledu reda interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno , 1 = Dostupno , 2 = Omogućeno, po podrazumevanom podešavanju. Napomena: Nema više dozvoljenih kolona, kolone će biti odbačene.',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            'Kolone koje se mogu filtrirati u odgovornom pregledu interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno , 1 = Dostupno , 2 = Omogućeno, po podrazumevanom podešavanju. Napomena: Nema više dozvoljenih kolona, kolone će biti odbačene.',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            'Kolone koje se mogu filtrirati u pregledu statusa interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno , 1 = Dostupno , 2 = Omogućeno, po podrazumevanom podešavanju. Napomena: Nema više dozvoljenih kolona, kolone će biti odbačene.',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            'Kolone koje se mogu filtrirati u pregledu rezultata pretrage tiketa na interfejsu operatera. Moguća podešavanja: 0 = Onemogućeno , 1 = Dostupno , 2 = Omogućeno, po podrazumevanom podešavanju. Napomena: Nema više dozvoljenih kolona, kolone će biti odbačene.',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: no more columns are allowed and will be discarded.' =>
            'Kolone koje se mogu filtrirati u posmatranom pregledu interfejsa operatera. Moguća podešavanja: 0 = Onemogućeno , 1 = Dostupno , 2 = Omogućeno, po podrazumevanom podešavanju. Napomena: Nema više dozvoljenih kolona, kolone će biti odbačene.',
        'Complete registration and continue' => 'Kompletiraj registraciju i nastavi',
        'Could not determine system load.' => 'Nije moguće utvrditi opterećenje sistema.',
        'Create and manage companies.' => 'Kreiranje i upravljanje firmama.',
        'Create and manage response templates.' => 'Kreiranje i upravljanje šablonima odgovora.',
        'Currently only MySQL is supported in the web installer.' => 'Trenutno je samo MySQL podržan u web instalaciji.',
        'Customer Company Management' => 'Uređivanje korisničkih firmi',
        'Customer Data' => 'Podaci o korisniku',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Korisnici su potrebni da bi mogli da imate istorijat za korisnika i da bi mogli da se prijave na klijentski portal.',
        'Customers <-> Services' => 'Korisnici <-> Servisi',
        'DB host' => 'Naziv ili adresa servera baze podataka',
        'Database-User' => 'Korisnik baze podataka',
        'Default skin for interface.' => 'Podrazumevani izgled interfejsa.',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
            'Određuje maksimalnu veličinu datoteka (u bajtima) za slanje.',
        'Defines the module to send emails. "Sendmail" directly uses the sendmail binary of your operating system. Any of the SMTP mechanisms use a specified (external) mailserver. "DoNotSendEmail" doesn\'t send emails and it is useful for test systems.' =>
            'Definiše module za slanje email-ova. "Sendmail" (pošalji mail) direktno koristi pošalji mail binarni kod vašeg operativnog sistema. Svaki od SMTP mehanizama koristi specifični (eksterni) mail server. "DoNotSendEmail" ne šalje email-ove i to je korisno pri testiranju sistema.',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            'Niste pronašli potrebnu funkciju? OTRS Grupa za svoje pretplaćene korisnike ima ekskluzivne dodatke:',
        'Edit Response' => 'Uredi odgovor',
        'Escalation in' => 'Eskalacija u',
        'False' => 'Lažno',
        'Filter for Responses' => 'Filter za odgovore',
        'Filter name' => 'Naziv filtera',
        'For more info see:' => 'Za dodatne informacije pogledaj:',
        'From customer' => 'Od korisnika',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Ovde možete dodati veze do vašeg privatnog sertifikata, koji će biti uključeni u SMIME potpis kad god ga upotrebite za potpisvanje email-a.',
        'If you deregister your system, you will loose these benefits:' =>
            'Ukoliko odjavite vaš sistem, izgubićete ove benefite:',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Ako ste podesili root lozinku za vašu bazu podataka, ona mora biti uneta ovde. Ako nema lozinke ostavite polje prazno. Iz bezbednosnih razloga preporučujemo da je podesite. Za više informacija konsultujte dokumentaciju o bazi podataka.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Ako želite da instalirate OTRS na neki drugi sistem baze podataka, informacije su u datoteci README.database.',
        'Link attachments to responses templates.' => 'Poveži priloge sa šablonima odgovora.',
        'Link customers to groups.' => 'Poveži korisnike sa grupama.',
        'Link customers to services.' => 'Poveži korisnike sa servisima.',
        'Link responses to queues.' => 'Poveži odgovore sa redovima.',
        'Load' => 'Opterećenje',
        'Log file location is only needed for File-LogModule!' => 'Lokacija datoteke dnevnika je jedino neophodna za File-LogModule!',
        'Logout successful. Thank you for using OTRS!' => 'Uspešno ste se odjavili! Hvala što ste koristili OTRS!',
        'Manage Response-Queue Relations' => 'Upravljanje vezama Odgovor-Red',
        'Manage Responses' => 'Upravljanje odgovorima',
        'Manage Responses <-> Attachments Relations' => 'Upravljanje vezama Odgovori <-> Prilozi',
        'Manage periodic tasks.' => 'Upravljanje povremenim zadacima.',
        'Only for ArticleCreate event' => 'Samo za događaj kreiranja članka',
        'Package verification failed!' => 'Neuspela verifikacija paketa!',
        'Password is required.' => 'Lozinka je obavezna.',
        'Pending Date' => 'Datum čekanja',
        'Please enter a search term to look for customer companies.' => 'Molimo unesite pojam pretrage za pronalaženje korisničkih firmi.',
        'Please fill in all fields marked as mandatory.' => 'Molimo da popunite sva polja označena kao obavezna.',
        'Please supply a' => 'Molimo, unesite',
        'Please supply a first name' => 'Molimo, unesite ime',
        'Please supply a last name' => 'Molimo, unesite prezime',
        'Position' => 'Pozicija',
        'Registration' => 'Registracija',
        'Responses' => 'Odgovori',
        'Responses <-> Queues' => 'Odgovori <-> Redovi',
        'SMIME Certificate' => 'SMIME sertifikat',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Siguran mod mora biti isključen radi reinstalacije preko web programa za instaliranje.',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            'Preskakanjem ovog koraka automatski preskačete i registraciju vaše OTRS instalacije. Jeste li sigurni da želite da nastavite?',
        'The load should be at maximum, the number of procesors the system have (e.g. a load of 8 or less on a 8 CPUs system is OK.' =>
            'Opterećenje treba da bude na maksimumu, broj procesora koje ima sistem (npr. opterećenje od 8 ili manje na 8-procesorskom sistemu je u redu.)',
        'There were tables found which no not have utf8 as charset.' => 'Pronađene su tabele koje nemaju utf8 kao karakterset.',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'Za dodavanje novog polja izaberite tip polja iz liste objekata, objekat definiše mogući opseg vrednosti i ne može se promeniti posle kreiranja polja.',
        'To customer' => 'Za korisnika',
        'URL' => 'URL',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            'Kada su tiketi spojeni, tiketu koji nije aktivan će automatski biti dodana beleška. U prostoru za tekst možete da definišete ovaj tekst (Operateri ne mogu menjati ovaj tekst).',
        'before' => 'pre',
        'default \'hot\'' => 'podrazumevano \'hot\'',
        'for pending* states' => 'za stanja čekanja',
        'settings' => 'podešavanja',

    };
    # $$STOP$$
    return;
}

1;
