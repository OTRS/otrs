# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# Copyright (C) 2011 Damir Dzeko <damir punkt dzeko masterspace inet.hr>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

# to be edited in ISO-8859-2 codepage, with UNIX-style line endings (LF)
# based on Serbian translation (Croatian translation is still incomplete)

package Kernel::Language::hr;

use strict;
use warnings;
use utf8;

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
    $Self->{Completeness}        = 0.39025602783992;

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Da',
        'No' => 'Ne',
        'yes' => 'da',
        'no' => 'ne',
        'Off' => 'Isklj.',
        'off' => 'isklj.',
        'On' => 'Uklj.',
        'on' => 'uklj.',
        'top' => 'vrh',
        'end' => 'kraj',
        'Done' => 'Gotovo',
        'Cancel' => 'Odustani',
        'Reset' => 'Reset',
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
        'd' => '',
        'hour' => 'sat',
        'hours' => 'sati',
        'hour(s)' => 'sat(i)',
        'Hours' => 'Sati',
        'h' => '',
        'minute' => 'minuta',
        'minutes' => 'minute',
        'minute(s)' => 'minuta/e',
        'Minutes' => 'Minute',
        'm' => '',
        'month' => 'mjesec',
        'months' => 'mjeseci',
        'month(s)' => 'mjesec(i)',
        'week' => 'tjedan',
        'week(s)' => 'tjedan/tjedni',
        'quarter' => '',
        'quarter(s)' => '',
        'half-year' => '',
        'half-year(s)' => '',
        'year' => 'godina',
        'years' => 'godine',
        'year(s)' => 'godin(e)',
        'second(s)' => 'sekunda/e',
        'seconds' => 'sekundi',
        'second' => 'sekunda',
        's' => '',
        'Time unit' => '',
        'wrote' => 'napisao',
        'Message' => 'Poruka',
        'Error' => 'Pogreška',
        'Bug Report' => 'Prijava pogreške',
        'Attention' => 'Pozor',
        'Warning' => 'Upozorenje',
        'Module' => 'Modul',
        'Modulefile' => 'Datoteka modula',
        'Subfunction' => 'Podfunkcija',
        'Line' => 'Redak',
        'Setting' => 'Postavka',
        'Settings' => 'Postavka',
        'Example' => 'Primjer',
        'Examples' => 'Primjeri',
        'valid' => 'ispravno',
        'Valid' => 'Ispravno',
        'invalid' => 'neispravno',
        'Invalid' => '',
        '* invalid' => '* neispravno',
        'invalid-temporarily' => 'neispravno-privremeno',
        ' 2 minutes' => ' 2 minute',
        ' 5 minutes' => ' 5 minuta',
        ' 7 minutes' => ' 7 minuta',
        '10 minutes' => '10 minuta',
        '15 minutes' => '15 minuta',
        'Mr.' => 'G.',
        'Mrs.' => 'Gđa',
        'Next' => 'Sljedeće',
        'Back' => 'Prethodno',
        'Next...' => 'Dalje...',
        '...Back' => '...Natrag',
        '-none-' => '-nijedan-',
        'none' => 'nema',
        'none!' => 'nema unosa!',
        'none - answered' => 'nema - odgovoreno',
        'please do not edit!' => 'Molimo ne mijenjajte!',
        'Need Action' => 'Potrebna akcija',
        'AddLink' => 'Dodaj vezu',
        'Link' => 'Stvori vezu',
        'Unlink' => 'Prekini vezu',
        'Linked' => 'Povezano',
        'Link (Normal)' => 'Veza (Normalno)',
        'Link (Parent)' => 'Veza (Nadređeno)',
        'Link (Child)' => 'Veza (Podređeno)',
        'Normal' => 'Normalno',
        'Parent' => 'Nadređeno',
        'Child' => 'Podređeno',
        'Hit' => 'Pogodak',
        'Hits' => 'Pogotci',
        'Text' => 'Tekst',
        'Standard' => 'Uobičajen',
        'Lite' => 'Jednostavan',
        'User' => 'Korisnik',
        'Username' => 'Korisničko ime',
        'Language' => 'Jezik',
        'Languages' => 'Jezici',
        'Password' => 'Lozinka',
        'Preferences' => 'Postavke',
        'Salutation' => 'Pozdrav',
        'Salutations' => 'Pozdravi',
        'Signature' => 'Potpis',
        'Signatures' => 'Potpisi',
        'Customer' => 'Korisnik',
        'CustomerID' => 'ID korisnika',
        'CustomerIDs' => 'ID korisnika',
        'customer' => 'korisnik',
        'agent' => 'operater',
        'system' => 'sustav',
        'Customer Info' => 'Korisnički info.',
        'Customer Information' => 'Informacije o korisniku',
        'Customer Companies' => 'Korisnikove tvrtke',
        'Company' => 'Tvrtka',
        'go!' => 'Start!',
        'go' => 'Start',
        'All' => 'Sve',
        'all' => 'sve',
        'Sorry' => 'Oprostite',
        'update!' => 'ažuriranje!',
        'update' => 'ažuriranje',
        'Update' => 'Ažuriranje',
        'Updated!' => 'Ažurirano!',
        'submit!' => 'pošalji!',
        'submit' => 'pošalji',
        'Submit' => 'Pošalji',
        'change!' => 'promjena!',
        'Change' => 'Promjena',
        'change' => 'promjena',
        'click here' => 'kliknite ovdje',
        'Comment' => 'Komentar',
        'Invalid Option!' => 'Neispravna opcija!',
        'Invalid time!' => 'Neispravno vrijeme!',
        'Invalid date!' => 'Neispravan datum!',
        'Name' => 'Ime',
        'Group' => 'Grupa',
        'Description' => 'Opis',
        'description' => 'opis',
        'Theme' => 'Tema',
        'Created' => 'Kreirano',
        'Created by' => 'kreirao',
        'Changed' => 'Mijenjano',
        'Changed by' => 'mijenjao',
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
        'Edit' => 'Mijenjati',
        'View' => 'Pregled',
        'Number' => 'Broj',
        'System' => 'Sistem',
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontakti',
        'Export' => 'Izvoz',
        'Up' => 'Gore',
        'Down' => 'Dolje',
        'Add' => 'Dodati',
        'Added!' => 'Dodano!',
        'Category' => 'Kategorija',
        'Viewer' => 'Prikazivač',
        'Expand' => 'Proširi',
        'Small' => 'Sitno',
        'Medium' => 'Srednje',
        'Large' => 'Krupno',
        'Date picker' => 'Izbor datuma',
        'Show Tree Selection' => 'Prikaži stablo',
        'The field content is too long!' => 'Sadržaj polja je predugačak!',
        'Maximum size is %s characters.' => 'Najviše je moguće %s znakova.',
        'This field is required or' => 'Polje je obavezno ili ',
        'New message' => 'Nova poruka',
        'New message!' => 'Nova poruka!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Molimo, odgovorite na ovu karticu da bi ste se vratili na normalan pregled reda!',
        'You have %s new message(s)!' => 'Imate %s novih poruka!',
        'You have %s reminder ticket(s)!' => 'Imate %s kartica podsjetnika!',
        'The recommended charset for your language is %s!' => 'Preporučena kodna stranica za vaš jezik je %s!',
        'Change your password.' => 'Promijenite lozinku.',
        'Please activate %s first!' => 'Molimo, prvo aktivirajte %s.',
        'No suggestions' => 'Nema sugestija',
        'Word' => 'riječ',
        'Ignore' => 'Zanemari',
        'replace with' => 'zamijeni sa',
        'There is no account with that login name.' => 'Ne postoji račun s tim korisničkim imenom.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Neuspješna prijava! Korisničko ime i/ili lozinka nisu valjani.',
        'There is no acount with that user name.' => 'Ne postoji račun s tim korisničkim imenom.',
        'Please contact your administrator' => 'Molimo obratite se svom administratoru',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            '',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Ova e-mail adresa već postoji. Molimo prijavite se ili obnovite svoju lozinku.',
        'Logout' => 'Odjava',
        'Logout successful. Thank you for using %s!' => 'Uspješno ste se odjavili! Hvala što ste koristili %s!',
        'Feature not active!' => 'Funkcija nije aktivna!',
        'Agent updated!' => 'Ažuriran operater',
        'Database Selection' => 'Izbor baze podataka',
        'Create Database' => 'Kreiraj bazu podataka',
        'System Settings' => 'Postavke sustava',
        'Mail Configuration' => 'Podešavanje E-pošte',
        'Finished' => 'Zaršeno',
        'Install OTRS' => '',
        'Intro' => '',
        'License' => 'Licenca',
        'Database' => 'Baza podataka (DB)',
        'Configure Mail' => '',
        'Database deleted.' => '',
        'Enter the password for the administrative database user.' => '',
        'Enter the password for the database user.' => '',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            '',
        'Database already contains data - it should be empty!' => '',
        'Login is needed!' => 'Potrebna je prijava!',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            '',
        'Password is needed!' => 'Potrebna je lozinka!',
        'Take this Customer' => 'Preuzmi ovog korisnika',
        'Take this User' => 'Uzmi ovog korisnika',
        'possible' => 'moguće',
        'reject' => 'odbaci',
        'reverse' => 'obrnuto',
        'Facility' => 'Mogućnost',
        'Time Zone' => 'Vremenska zona',
        'Pending till' => 'Čeka do',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            '',
        'Dispatching by email To: field.' => 'Otprema E-pošte za: Polje.',
        'Dispatching by selected Queue.' => 'Otprema kroz izabrani red.',
        'No entry found!' => 'Unos nije pronađen!',
        'Session invalid. Please log in again.' => 'Sesija nije uspjela. Molimo prijavite se ponovo.',
        'Session has timed out. Please log in again.' => 'Vrijeme sesije je isteklo. Molimo prijavite se ponovno.',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Nemate dozvolu!',
        '(Click here to add)' => '(Klikni ovdje za dodavanje)',
        'Preview' => 'Pregled',
        'Package not correctly deployed! Please reinstall the package.' =>
            '',
        '%s is not writable!' => 'Ne može se upisivati na %s!',
        'Cannot create %s!' => 'Ne može se kreirati %s!',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            '',
        'News about OTRS releases!' => '',
        'Customer %s added' => 'Dodan korisnik %s.',
        'Role added!' => 'Dodana uloga!',
        'Role updated!' => 'Ažurirana uloga!',
        'Attachment added!' => 'Dodan prilog!',
        'Attachment updated!' => 'Ažuriran prilog!',
        'Response added!' => 'Dodan odgovor!',
        'Response updated!' => 'Ažuriran odgovor!',
        'Group updated!' => 'Ažurirana grupa!',
        'Queue added!' => 'Dodan red!',
        'Queue updated!' => 'Ažuriran red!',
        'State added!' => ' ',
        'State updated!' => 'Ažurirano stanje!',
        'Type added!' => 'Dodan tip!',
        'Type updated!' => 'Ažuriran tip!',
        'Customer updated!' => 'Ažuriran korisnik!',
        'Customer company added!' => '',
        'Customer company updated!' => '',
        'Note: Company is invalid!' => '',
        'Mail account added!' => '',
        'Mail account updated!' => '',
        'System e-mail address added!' => '',
        'System e-mail address updated!' => '',
        'Contract' => 'Ugovor',
        'Online Customer: %s' => 'Korisnik na vezi: %s',
        'Online Agent: %s' => 'Operater na vezi: %s',
        'Calendar' => 'Kalendar',
        'File' => 'Datoteka',
        'Filename' => 'Naziv datoteke',
        'Type' => 'Tip',
        'Size' => 'Veličina',
        'Upload' => 'Upload',
        'Directory' => 'Imenik',
        'Signed' => 'Potpisano',
        'Sign' => 'Potpis',
        'Crypted' => 'Šifrirano',
        'Crypt' => 'Šifra',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP Ključ',
        'PGP Keys' => 'PGP ključevi',
        'S/MIME' => '"S/MIME" ključ',
        'S/MIME Certificate' => 'S/MIME vjerodajnica',
        'S/MIME Certificates' => 'S/MIME vjerodajnice',
        'Office' => 'Ured',
        'Phone' => 'Telefon',
        'Fax' => 'Faks',
        'Mobile' => 'Mobilni',
        'Zip' => 'Broj pošte',
        'City' => 'Mjesto',
        'Street' => 'Ulica',
        'Country' => 'Država',
        'Location' => 'Lokacija',
        'installed' => 'instalirano',
        'uninstalled' => 'deinstalirano',
        'Security Note: You should activate %s because application is already running!' =>
            'Sigurnosna napomena: Trebalo bi omogućiti %s, jer je aplikacija već pokrenuta!',
        'Unable to parse repository index document.' => 'Nije moguće raščlaniti indeks dokumenta!',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Nema paketa za verziju vašeg sustava, u spremištu su samo paketi za druge verzije.',
        'No packages, or no new packages, found in selected repository.' =>
            'U izabranom spremištu nema paketa ili nema novih paketa',
        'Edit the system configuration settings.' => 'Uredi konfiguracijske postavke sustava.',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            '',
        'printed at' => 'otisnuto u',
        'Loading...' => 'Učitavanje...',
        'Dear Mr. %s,' => 'Poštovani gospodine %s,',
        'Dear Mrs. %s,' => 'Poštovana gospođo %s,',
        'Dear %s,' => 'Dragi %s,',
        'Hello %s,' => 'Zdravo %s,',
        'This email address is not allowed to register. Please contact support staff.' =>
            '',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Kreiran novi račun. Podaci za prijavu poslani %s. Molimo provjerite svoju E-poštu.',
        'Please press Back and try again.' => 'Molimo pritisnite Natrag i pokušajte ponovo.',
        'Sent password reset instructions. Please check your email.' => 'Upute za resetiranje lozinke su poslane. Molimo provjerite svoju E-poštu.',
        'Sent new password to %s. Please check your email.' => 'Poslana je nova lozinka za %s. Provjerite svoju E-poštu.',
        'Upcoming Events' => 'Predstojeći događaji',
        'Event' => 'Događaj',
        'Events' => 'Događaji',
        'Invalid Token!' => 'Neispravan Token!',
        'more' => 'još',
        'Collapse' => 'Smanji',
        'Shown' => 'Prikazan',
        'Shown customer users' => '',
        'News' => 'Novosti',
        'Product News' => 'Novosti o proizvodu',
        'OTRS News' => 'OTRS Novosti',
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
        'Show/Hide Hidden Elements' => 'Pokaži/Sakrij skrivene elemente',
        'Align Left' => 'Poravnaj nalijevo',
        'Align Center' => 'Centriraj',
        'Align Right' => 'Poravnaj nadesno',
        'Justify' => 'Poravnaj obostrano',
        'Header' => 'Naslov',
        'Indent' => 'Uvlačenje',
        'Outdent' => 'Izvlačenje',
        'Create an Unordered List' => 'Napravi nesortiranu listu',
        'Create an Ordered List' => 'Napravi sortiranu listu',
        'HTML Link' => 'HTML veza',
        'Insert Image' => 'Ubaci sliku',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SHIFT',
        'Undo' => 'Poništi',
        'Redo' => 'Ponovi',
        'OTRS Daemon is not running.' => '',
        'Can\'t contact registration server. Please try again later.' => '',
        'No content received from registration server. Please try again later.' =>
            '',
        'Problems processing server result. Please try again later.' => '',
        'Username and password do not match. Please try again.' => '',
        'The selected process is invalid!' => '',
        'Upgrade to %s now!' => '',
        '%s Go to the upgrade center %s' => '',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            '',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            '',
        'Your system was successfully upgraded to %s.' => '',
        'There was a problem during the upgrade to %s.' => '',
        '%s was correctly reinstalled.' => '',
        'There was a problem reinstalling %s.' => '',
        'Your %s was successfully updated.' => '',
        'There was a problem during the upgrade of %s.' => '',
        '%s was correctly uninstalled.' => '',
        'There was a problem uninstalling %s.' => '',

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
        'Jan' => 'Sje',
        'Feb' => 'Velj',
        'Mar' => 'Ožu',
        'Apr' => 'Tra',
        'May' => 'Svi',
        'Jun' => 'Lip',
        'Jul' => 'Srp',
        'Aug' => 'Kol',
        'Sep' => 'Ruj',
        'Oct' => 'Lis',
        'Nov' => 'Stu',
        'Dec' => 'Pro',
        'January' => 'siječanj',
        'February' => 'veljača',
        'March' => 'ožujak',
        'April' => 'travanj',
        'May_long' => 'svibanj',
        'June' => 'lipanj',
        'July' => 'srpanj',
        'August' => 'kolovoz',
        'September' => 'rujan',
        'October' => 'listopad',
        'November' => 'studeni',
        'December' => 'prosinac',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Postavke su uspješno ažurirane!',
        'User Profile' => 'Korisnički profil',
        'Email Settings' => 'Postavke E-pošte',
        'Other Settings' => 'Druge postavke',
        'Change Password' => 'Promjena lozinke',
        'Current password' => 'Sadašnja lozinka',
        'New password' => 'Nova lozinka',
        'Verify password' => 'Potvrdi lozinku',
        'Spelling Dictionary' => 'Pravopisni rječnik',
        'Default spelling dictionary' => 'Zadani pravopisni rječnik',
        'Max. shown Tickets a page in Overview.' => 'Maksimalni broj kartice po stranici pregleda.',
        'The current password is not correct. Please try again!' => 'Unijeli ste pogrešnu lozinku. Molimo pokušajte ponovno!',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Lozinka ne može biti ažurirana, novi unosi su različiti. Molimo pokušajte ponovno!',
        'Can\'t update password, it contains invalid characters!' => 'Lozinka ne može biti ažurirana, sadrži nedozvoljene znakove.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Lozinka ne može biti ažurirana. Minimalna dužina lozinke je %s znakova.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Lozinka ne može biti ažurirana. Mora sadržavati bar 2 mala i 2 velika slova.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Lozinka ne može biti ažurirana. Mora sadržavati bar jednu znamenku.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Lozinka ne može biti ažurirana. Mora sadržavati najmanje 2 znaka.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Lozinka ne može biti ažurirana. Unijeta lozinka je već u uporabi. Molimo izaberite neku drugu.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Izaberite rastavni znak koji će se koristi u "CSV" datotekama (statistika i pretrage). Ako ne izaberete rastavni znak ovdje, koristit će se zadani rastavni znak za vaš jezik',
        'CSV Separator' => 'CSV rastavni znak',

        # Template: AAATicket
        'Status View' => 'Pregled statusa',
        'Service View' => '',
        'Bulk' => ' ',
        'Lock' => 'Zaključano',
        'Unlock' => 'Otključano',
        'History' => 'Dnevnik',
        'Zoom' => ' ',
        'Age' => 'Starost',
        'Bounce' => 'Preusmjeri',
        'Forward' => 'Proslijedi',
        'From' => 'Od',
        'To' => 'Za',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Predmet',
        'Move' => 'Premjesti',
        'Queue' => 'Red',
        'Queues' => 'Redovi',
        'Priority' => 'Prioritet',
        'Priorities' => 'Prioriteti',
        'Priority Update' => 'Ažuriranje prioriteta',
        'Priority added!' => '',
        'Priority updated!' => '',
        'Signature added!' => '',
        'Signature updated!' => '',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Sporazum o razini usluge',
        'Service Level Agreements' => 'Sporazumi o razini usluge',
        'Service' => 'Usluga',
        'Services' => 'Usluge',
        'State' => 'Stanje',
        'States' => 'Stanja',
        'Status' => 'Status',
        'Statuses' => 'Statusi',
        'Ticket Type' => 'Tip kartice',
        'Ticket Types' => 'Tipovi kartice',
        'Compose' => 'Napiši',
        'Pending' => 'Na čekanju',
        'Owner' => 'Vlasnik',
        'Owner Update' => 'Ažuriranje vlasnika',
        'Responsible' => 'Odgovoran',
        'Responsible Update' => 'Ažuriranje odgovornog',
        'Sender' => 'Pošiljatelj',
        'Article' => 'Članak',
        'Ticket' => 'kartica',
        'Createtime' => 'Vrijme kreiranja',
        'plain' => 'neformatirano',
        'Email' => 'E-pošta',
        'email' => 'E-pošta',
        'Close' => 'Zatvori',
        'Action' => 'Akcija',
        'Attachment' => 'Privitak',
        'Attachments' => 'Privitci',
        'This message was written in a character set other than your own.' =>
            'Ova poruka je napisana skupom znakova različitim od onog koji Vi koristite.',
        'If it is not displayed correctly,' => 'Ako nije ispravno prikazano,',
        'This is a' => 'Ovo je',
        'to open it in a new window.' => 'za otvaranje u novom prozoru.',
        'This is a HTML email. Click here to show it.' => 'Ovo je HTML E-pošta. Klikni ovdje za prikaz.',
        'Free Fields' => 'Slobodna polja',
        'Merge' => 'Objedini',
        'merged' => 'objedinjeno',
        'closed successful' => 'zatvoreno kao riješeno (uspješno)',
        'closed unsuccessful' => 'zatvoreno kao neuspješno (neriješeno)',
        'Locked Tickets Total' => 'Ukupno blokiranih/zaključnih kartica',
        'Locked Tickets Reminder Reached' => 'Dostignut podsjetnik zaključanih kartica',
        'Locked Tickets New' => 'Nove zaključane kartice',
        'Responsible Tickets Total' => 'Ukupno kartica "..."',
        'Responsible Tickets New' => 'Nove kartice "..."',
        'Responsible Tickets Reminder Reached' => 'Dostignut podsjetnik kartice ".."',
        'Watched Tickets Total' => 'Ukupno praćenih kartica',
        'Watched Tickets New' => 'Nove praćene kartice',
        'Watched Tickets Reminder Reached' => 'Dostignut podsjetnik kartica na čekanju',
        'All tickets' => 'Sve kartice',
        'Available tickets' => '',
        'Escalation' => 'Eskalacija',
        'last-search' => '',
        'QueueView' => 'Pregled reda',
        'Ticket Escalation View' => 'Eskalacioni pregled kartice',
        'Message from' => '',
        'End message' => '',
        'Forwarded message from' => '',
        'End forwarded message' => '',
        'Bounce Article to a different mail address' => '',
        'Reply to note' => '',
        'new' => 'novo',
        'open' => 'otvoreni',
        'Open' => 'Otvoreni',
        'Open tickets' => '',
        'closed' => 'zatvoreni',
        'Closed' => 'Zatvoreni',
        'Closed tickets' => '',
        'removed' => 'uklonjeni',
        'pending reminder' => 'podsjetnik čekanja',
        'pending auto' => 'automatsko čekanje',
        'pending auto close+' => 'čekanje na automatsko zatvaranje+',
        'pending auto close-' => 'čekanje na automatsko zatvaranje-',
        'email-external' => 'E-pošta - vanjska',
        'email-internal' => 'E-pošta - interna',
        'note-external' => 'napomena-vanjska',
        'note-internal' => 'napomena-interna',
        'note-report' => 'napomena-izvještaj',
        'phone' => 'Telefon',
        'sms' => 'SMS',
        'webrequest' => 'web zahtjev',
        'lock' => 'zaklj.',
        'unlock' => 'otklj.',
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
        'auto follow up' => '',
        'auto reject' => '',
        'auto remove' => '',
        'auto reply' => '',
        'auto reply/new ticket' => '',
        'Create' => 'Napravi',
        'Answer' => '',
        'Phone call' => 'Telefonski poziv',
        'Ticket "%s" created!' => 'Kartica "%s" kreirana!',
        'Ticket Number' => 'Broj kartice',
        'Ticket Object' => 'Objekt kartice',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Ne postoji kartica s brojem "%s"! Ne može se povezati!',
        'You don\'t have write access to this ticket.' => 'Nemate prava pisanja u ovaj tiket.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Nažalost, morate biti vlasnik tiketa za ovu aktivnost.',
        'Please change the owner first.' => 'Molimo prvo promijenite vlasnika.',
        'Ticket selected.' => 'Tiket izabran.',
        'Ticket is locked by another agent.' => 'Tiket je zaključao drugi operater.',
        'Ticket locked.' => 'Tiket zaključan.',
        'Don\'t show closed Tickets' => 'Ne prikazuj zatvorene kartice',
        'Show closed Tickets' => 'Prikaži zatvorene kartice',
        'New Article' => 'Novi članak',
        'Unread article(s) available' => 'Raspoloživi nepročitani članci',
        'Remove from list of watched tickets' => 'Ukloni s liste pregledanih kartica',
        'Add to list of watched tickets' => 'Dodaj na listu praćenih kartica',
        'Email-Ticket' => 'Kartica E-pošte',
        'Create new Email Ticket' => 'Kreiraj novu karticu E-pošte',
        'Phone-Ticket' => 'Telefonska kartica',
        'Search Tickets' => 'Pretraživanje kartica',
        'Customer Realname' => '',
        'Customer History' => '',
        'Edit Customer Users' => 'Uredi korisnike',
        'Edit Customer' => 'Uredi korisnika',
        'Bulk Action' => 'Masovna akcija',
        'Bulk Actions on Tickets' => 'Masovne akcije na karticama',
        'Send Email and create a new Ticket' => 'Pošalji E-poštu i kreiraj novu karticu',
        'Create new Email Ticket and send this out (Outbound)' => 'Otvori novu karticu E-pošte i pošalji ovo (odlazni)',
        'Create new Phone Ticket (Inbound)' => 'Kreiraj novu telefonsku karticu (dolazni poziv)',
        'Address %s replaced with registered customer address.' => '',
        'Customer user automatically added in Cc.' => '',
        'Overview of all open Tickets' => 'Pregled svih otvorenih kartica',
        'Locked Tickets' => 'Zaključane kartice',
        'My Locked Tickets' => 'Moje zaključane kartice',
        'My Watched Tickets' => 'Moje pregledane kartice',
        'My Responsible Tickets' => 'Kartice za koje sam odgovoran',
        'Watched Tickets' => 'Pregledane kartice',
        'Watched' => 'Pregledano',
        'Watch' => 'Pregledaj',
        'Unwatch' => ' ',
        'Lock it to work on it' => '',
        'Unlock to give it back to the queue' => '',
        'Show the ticket history' => '',
        'Print this ticket' => '',
        'Print this article' => '',
        'Split' => '',
        'Split this article' => '',
        'Forward article via mail' => '',
        'Change the ticket priority' => '',
        'Change the ticket free fields!' => 'Promijeni slobodna polja kartice',
        'Link this ticket to other objects' => '',
        'Change the owner for this ticket' => '',
        'Change the  customer for this ticket' => '',
        'Add a note to this ticket' => '',
        'Merge into a different ticket' => '',
        'Set this ticket to pending' => '',
        'Close this ticket' => '',
        'Look into a ticket!' => 'Pogledaj sadržaj kartice!',
        'Delete this ticket' => '',
        'Mark as Spam!' => 'Označi kao Spam!',
        'My Queues' => 'Moji redovi',
        'Shown Tickets' => 'Prikazane kartice',
        'Shown Columns' => '',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Vaša poruka E-pošte sa brojem kartice "<OTRS_TICKET>" je objedinjena sa karticom "<OTRS_MERGE_TO_TICKET>"!',
        'Ticket %s: first response time is over (%s)!' => 'kartica %s: vrijeme reakcije je preko (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'kartica %s: vrijeme reakcije ističe za %s!',
        'Ticket %s: update time is over (%s)!' => 'kartica %s: vrijeme ažuriranja je isteklo (%s)!',
        'Ticket %s: update time will be over in %s!' => 'kartica %s: vrijeme ažuriranja ističe za %s!',
        'Ticket %s: solution time is over (%s)!' => 'kartica %s: vrijeme rješavanja je isteklo (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'kartica %s: vrijeme rješavanja ističe za %s!',
        'There are more escalated tickets!' => 'Ima još eskaliralih kartica!',
        'Plain Format' => 'Jednostavan format',
        'Reply All' => 'Odgovori svima',
        'Direction' => 'Smjer',
        'New ticket notification' => 'Obavijest o novoj kartici',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Pošalji mi obavijest za novu karticu u "Mojim redovima".',
        'Send new ticket notifications' => 'Pošalji obavijesti o novoj kartici',
        'Ticket follow up notification' => 'Obavijest o nastavku kartice',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Pošalji mi obavijest ako korisnik slijedi tiket a ja sam vlasnik tiketa ili ako je tiket otključan u nekom od mojih redova.',
        'Send ticket follow up notifications' => 'Pošalji obavijest o praćenju tiketa',
        'Ticket lock timeout notification' => 'Obavijest o istjecanju zaključane kartice',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Pošalji mi obavijest ako sustav otključa karticu.',
        'Send ticket lock timeout notifications' => 'Pošalji obavijest o isteku zaključavanja kartice',
        'Ticket move notification' => 'Obavijest o premještaju kartice',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Pošalji mi obavijest o premještaju kartice u "Moje redove".',
        'Send ticket move notifications' => 'Pošalji obavijest o premještaju kartice',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Custom Queue' => 'Prilagođeni red',
        'QueueView refresh time' => 'Vrijeme osvježavanja pregleda reda',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Ako je uključeno, pregled reda bit će osvježen poslije zadanog vremena.',
        'Refresh QueueView after' => 'Osvježi pregled reda poslije',
        'Screen after new ticket' => 'Ekran poslije otvaranja nove kartice',
        'Show this screen after I created a new ticket' => 'Prikaži ovaj ekran poslije otvaranja nove kartice',
        'Closed Tickets' => 'Zatvorene kartice',
        'Show closed tickets.' => 'Prikaži zatvorene kartice.',
        'Max. shown Tickets a page in QueueView.' => 'Maksimalni broj prikazanih kartica u pregledu reda.',
        'Ticket Overview "Small" Limit' => '',
        'Ticket limit per page for Ticket Overview "Small"' => '',
        'Ticket Overview "Medium" Limit' => '',
        'Ticket limit per page for Ticket Overview "Medium"' => '',
        'Ticket Overview "Preview" Limit' => '',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Limit kartica po stranici pregleda',
        'Ticket watch notification' => 'Obavijest o promatranju kartice',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Pošlji mi istu obavijest za moje promatrane kartice koju će dobiti i vlasnik.',
        'Send ticket watch notifications' => 'Pošalji obavijesti za promatranje kartice',
        'Out Of Office Time' => 'Izvan radnog vremena',
        'New Ticket' => 'Nova kartica',
        'Create new Ticket' => 'Napravi novu karticu',
        'Customer called' => 'Kartica na korisnikov poziv',
        'phone call' => 'telefonski poziv',
        'Phone Call Outbound' => 'Odlazni telefonski poziv',
        'Phone Call Inbound' => '',
        'Reminder Reached' => 'Dostignut podsjetnik',
        'Reminder Tickets' => 'Kartice podsjetnika',
        'Escalated Tickets' => 'Eskalirane kartice',
        'New Tickets' => 'Nove kartice',
        'Open Tickets / Need to be answered' => 'Otvorene kartice / Potrebno odgovoriti',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Sve otvorene kartice, na kojima je već rađeno, ali zahtijevaju odgovor',
        'All new tickets, these tickets have not been worked on yet' => 'Sve nove kartice, na njima još nije ništa rađeno',
        'All escalated tickets' => 'Sve eskalirani kartice',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Sve kartice sa postavljenim podsjetnikom, a datum podsjetnika je dostignut',
        'Archived tickets' => '',
        'Unarchived tickets' => '',
        'Ticket Information' => '',
        'including subqueues' => '',
        'excluding subqueues' => '',

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
        'Filter' => 'Filtar',
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
        'Validity' => '',
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
        'Show or hide the content' => 'Prikaži ili sakrij sadržaj',
        'Edit ACL information' => '',
        'Stop after match' => 'Zaustavi poslije uparivanja',
        'Edit ACL structure' => '',
        'Save' => 'Spremi',
        'or' => 'ili',
        'Save and finish' => 'Spremi i završi',
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
        'You can use the following tags' => 'Možete koristiti sljedeće oznake',
        'To get the first 20 character of the subject.' => 'Da vidite prvih 20 slova predmeta',
        'To get the first 5 lines of the email.' => 'Da vidite prvih 5 redaka poruke',
        'To get the realname of the sender (if given).' => 'Da vidite ime pošiljatelja (ako je dostupno)',
        'To get the article attribute' => 'Da vidite atribute članka',
        ' e. g.' => 'npr.',
        'Options of the current customer user data' => 'Opcije podataka o trenutnom korisniku',
        'Ticket owner options' => 'Opcije vlasnika kartice',
        'Ticket responsible options' => 'Opcije odgovornog za karticu',
        'Options of the current user who requested this action' => 'Opcije trenutnog korisnika koji je tražio ovu akciju',
        'Options of the ticket data' => 'Opcije podataka o kartici',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Konfiguracijske opcije',
        'Example response' => 'Primjer odgovora',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => '',
        'Support Data Collector' => '',
        'Support data collector' => '',
        'Hint' => 'Savjet',
        'Currently support data is only shown in this system.' => '',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            '',
        'Configuration' => '',
        'Send support data' => '',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            '',
        'System Registration' => '',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            '',
        'Register this System' => '',
        'System Registration is disabled for your system. Please check your configuration.' =>
            '',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            '',
        'Please note that you using OTRS cloud services requires the system to be registered.' =>
            '',
        'Register this system' => '',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            '',
        'Available Cloud Services' => '',
        'Upgrade to %s' => '',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Upravljanje korisnicima',
        'Wildcards like \'*\' are allowed.' => '',
        'Add customer' => 'Dodaj korisnika',
        'Select' => 'Izaberi',
        'Please enter a search term to look for customers.' => 'Molimo zadajte upit za pronalaženje korisnika.',
        'Add Customer' => 'Dodaj korisnika',

        # Template: AdminCustomerUser
        'Customer User Management' => '',
        'Back to search results' => '',
        'Add customer user' => '',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            '',
        'Last Login' => 'Zadnja prijava',
        'Login as' => 'Prijavi se kao',
        'Switch to customer' => '',
        'Add Customer User' => '',
        'Edit Customer User' => '',
        'This field is required and needs to be a valid email address.' =>
            'Ovo je obavezno polje i adresa E-pošte mora biti ispravna.',
        'This email address is not allowed due to the system configuration.' =>
            'Postavke sustava ne dopuštaju ovu adresu E-pošte.',
        'This email address failed MX check.' => 'Ova adresa E-pošte ne prolazi DNS/MX provjeru.',
        'DNS problem, please check your configuration and the error log.' =>
            '',
        'The syntax of this email address is incorrect.' => 'Sintaksa ove adrese E-pošta je neispravna.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Upravljanje članstvom korisnika u grupi',
        'Notice' => 'Napomena',
        'This feature is disabled!' => 'Ova funkcija je isključena!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Ovu funkciju koristite ako želite definirati grupne dozvole za korisnike.',
        'Enable it here!' => 'Aktivirajte je ovdje!',
        'Edit Customer Default Groups' => 'Uredi zadane korisničke grupe',
        'These groups are automatically assigned to all customers.' => 'Ove grupe su automatski dodijeljene svim korisnicima',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Možete upravljati ovim grupama preko konfiguracijskih postavki "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtar za grupe',
        'Just start typing to filter...' => '',
        'Select the customer:group permissions.' => 'Izaberi dozvole za korisnik:grupa',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Ako ništa nije izabrano, onda nema dozvola u ovoj grupi (kartice neće biti dostupne korisniku).',
        'Search Results' => 'Rezultat pretrage',
        'Customers' => 'Korisnici',
        'No matches found.' => 'Ništa nije pronađeno.',
        'Groups' => 'Grupe',
        'Change Group Relations for Customer' => 'Promijeni Grupne Veze za Korisnika',
        'Change Customer Relations for Group' => 'Promijeni Korisničke Veze za Grupu',
        'Toggle %s Permission for all' => 'Promijeni %s dozvole za sve',
        'Toggle %s permission for %s' => 'Promijeni %s dozvole za %s',
        'Customer Default Groups:' => 'Zadane Grupe za Korisnika:',
        'No changes can be made to these groups.' => 'Na ovim grupama promjene nisu moguće.',
        'ro' => '"ro"',
        'Read only access to the ticket in this group/queue.' => 'Pristup ograničen samo na čitanje za kartice u ovim grupama/redovima.',
        'rw' => '"rw"',
        'Full read and write access to the tickets in this group/queue.' =>
            'Pristup bez ograničenja za kartice u ovim grupama/redovima.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Upravljanje vezama Korisnik-Usluge',
        'Edit default services' => 'Uredi zadane usluge',
        'Filter for Services' => 'Filter za usluge',
        'Allocate Services to Customer' => 'Pridruži usluge korisniku',
        'Allocate Customers to Service' => 'Pridruži korisnike usluzi',
        'Toggle active state for all' => 'Promijeni aktivno stanje za sve',
        'Active' => 'Aktivno',
        'Toggle active state for %s' => 'Promijeni aktivno stanje za %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => '',
        'Add new field for object' => '',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
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
        'Default value' => 'Zadana vrijednost',
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
        'Restrict entering of dates' => '',
        'Here you can restrict the entering of dates of tickets.' => '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => '',
        'Key' => 'Ključ',
        'Value' => 'Vrijednost',
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
        'Note' => 'Napomena',
        'You need to add the translations manually into the language translation files.' =>
            '',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Broj redaka',
        'Specify the height (in lines) for this field in the edit mode.' =>
            '',
        'Number of cols' => 'Broj stupaca',
        'Specify the width (in characters) for this field in the edit mode.' =>
            '',
        'Check RegEx' => '',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => '',
        'Invalid RegEx' => '',
        'Error Message' => 'Poruka o pogrešci',
        'Add RegEx' => '',

        # Template: AdminEmail
        'Admin Notification' => 'Administrativne obavijesti',
        'With this module, administrators can send messages to agents, group or role members.' =>
            '',
        'Create Administrative Message' => 'Napravi administrativnu poruku',
        'Your message was sent to' => 'Vaša poruka je poslana',
        'Send message to users' => 'Pošalji poruku korisnicima',
        'Send message to group members' => 'Pošalji poruku članovima grupe',
        'Group members need to have permission' => 'Članovi grupe trebaju imati dozvolu',
        'Send message to role members' => 'Pošalji poruku za ulogu',
        'Also send to customers in groups' => 'Također pošalji korisnicima u grupi',
        'Body' => 'Tekst',
        'Send' => 'Šalji',

        # Template: AdminGenericAgent
        'Generic Agent' => '"Generički" operater',
        'Add job' => 'Dodaj posao',
        'Last run' => 'Posljednje pokretanje',
        'Run Now!' => 'Pokreni sad!',
        'Delete this task' => 'Obriši ovaj zadatak',
        'Run this task' => 'Pokreni ovaj zadatak',
        'Job Settings' => 'Podešavanje posla',
        'Job name' => 'Naziv posla',
        'The name you entered already exists.' => '',
        'Toggle this widget' => 'Promjeni ovaj widget',
        'Automatic execution (multiple tickets)' => '',
        'Execution Schedule' => '',
        'Schedule minutes' => 'Planirano minuta',
        'Schedule hours' => 'Planirano sati',
        'Schedule days' => 'Planirano dana',
        'Currently this generic agent job will not run automatically.' =>
            'Trenutno ovaj generički operaterski zadatak neće raditi automatski.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'Da bi ste omogućili automatsko izvršavanje izaberite bar jednu vrijednost: minute, sate ili dane!',
        'Event based execution (single ticket)' => '',
        'Event Triggers' => '',
        'List of all configured events' => '',
        'Delete this event' => 'Obrišite ovaj događaj',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'Add Event' => 'Dodaj događaj',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Duplicate event.' => '',
        'This event is already attached to the job, Please use a different one.' =>
            '',
        'Delete this Event Trigger' => '',
        'Remove selection' => '',
        'Select Tickets' => '',
        '(e. g. 10*5155 or 105658*)' => 'npr. 10*5144 ili 105658*',
        '(e. g. 234321)' => 'npr. 234321',
        'Customer login' => 'Prijava korisnika',
        '(e. g. U5150)' => 'npr. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Potpuna tekstualna pretraga u članku (npr. "Mar*n" ili "Hor*ić")',
        'Agent' => 'Operater',
        'Ticket lock' => 'Kartica zaključana',
        'Create times' => 'Vremena otvaranja',
        'No create time settings.' => 'Nema postavki vremena otvaranja.',
        'Ticket created' => 'Kartica stvorena',
        'Ticket created between' => 'karticu otvoren između',
        'Last changed times' => '',
        'No last changed time settings.' => '',
        'Ticket last changed' => '',
        'Ticket last changed between' => '',
        'Change times' => '',
        'No change time settings.' => 'Nema promjene vremena.',
        'Ticket changed' => 'Kartica mijenjana',
        'Ticket changed between' => 'Kartica mijenjana između',
        'Close times' => 'Vremena zatvaranja',
        'No close time settings.' => 'Nije postavljeno vrijeme zatvaranja.',
        'Ticket closed' => 'Kartica zatvorena',
        'Ticket closed between' => 'Kartica zatvorena između',
        'Pending times' => 'Vremena čekanja',
        'No pending time settings.' => 'Nema podešavanja vremena čekanja',
        'Ticket pending time reached' => 'Dostignuto vrijeme čekanja kartice',
        'Ticket pending time reached between' => 'Vrijeme čekanja kartice dostignuto između',
        'Escalation times' => 'Vremena eskalacije',
        'No escalation time settings.' => 'Nema postavki vremena eskalacije',
        'Ticket escalation time reached' => 'Dostignuto vrijeme eskalacije kartice',
        'Ticket escalation time reached between' => 'Vrijeme eskalacije kartice dostignuto između',
        'Escalation - first response time' => 'Eskalacija - vrijeme prve reakcije',
        'Ticket first response time reached' => 'Dostignuto vrijeme prve reakcije na karticu',
        'Ticket first response time reached between' => 'Vrijeme prve reakcije na karticu dostignuto između',
        'Escalation - update time' => 'Eskalacija - vrijeme ažuriranja',
        'Ticket update time reached' => 'Dostignuto vrijeme ažuriranja kartice',
        'Ticket update time reached between' => 'Vrijeme ažuriranja kartice dostignuto između',
        'Escalation - solution time' => 'Eskalacija - vrijeme rješavanja',
        'Ticket solution time reached' => 'Dostignuto vrijeme rješavanja kartice',
        'Ticket solution time reached between' => 'Vreme rješavanja kartice dostignuto između',
        'Archive search option' => 'Opcije pretrage arhive',
        'Update/Add Ticket Attributes' => '',
        'Set new service' => 'Postavi novi servis',
        'Set new Service Level Agreement' => 'Postavi novi SLA',
        'Set new priority' => 'Postavi novi prioritet',
        'Set new queue' => 'Postavi novi red',
        'Set new state' => 'Postavi novi status',
        'Pending date' => 'Datum čekanja',
        'Set new agent' => 'Postavi novog operatera',
        'new owner' => 'novi vlasnik',
        'new responsible' => '',
        'Set new ticket lock' => 'Postavi novo zaključavanje kartice',
        'New customer' => 'Novi korisnik',
        'New customer ID' => 'Novi ID korisnika',
        'New title' => 'Novi naslov',
        'New type' => 'Novi tip',
        'New Dynamic Field Values' => '',
        'Archive selected tickets' => 'Arhiviraj izabrane kartice',
        'Add Note' => 'Dodaj napomenu',
        'Time units' => 'Vremenske jedinice',
        'Execute Ticket Commands' => '',
        'Send agent/customer notifications on changes' => 'Pošalji obavijesti operateru/korisniku pri promjenama',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Ova naredba će biti izvršena. ARG[0] je broj kartice, a ARG[1] ID kartice.',
        'Delete tickets' => 'Obriši kartice',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'UPOZORENJE: Sve obuhvaćene kartice će biti nepovratno uklonjene iz baze!',
        'Execute Custom Module' => 'Pokreni izvršavanje posebnog modula',
        'Param %s key' => 'Ključ parametra %s',
        'Param %s value' => 'Vrijednost parametra %s',
        'Save Changes' => 'Spremi promjene',
        'Results' => 'Rezultati',
        '%s Tickets affected! What do you want to do?' => '%s obuhvaćenih kartica. Što želite napraviti?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Upozorenje: Upotrijebili ste opciju za BRISANJE. Sve obrisane kartice bit će izgubljene!',
        'Edit job' => 'Uredi posao',
        'Run job' => 'Pokreni posao',
        'Affected Tickets' => 'Obuhvaćene kartice',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'You are here' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => '',
        'Clear' => '',
        'Do you really want to clear the debug log of this web service?' =>
            '',
        'Request List' => '',
        'Time' => 'Vrijeme',
        'Remote IP' => '',
        'Loading' => 'Učitavam...',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Limit' => 'Ograničenje',
        'Refresh' => 'Osvježi',
        'Request Details' => 'Zahtjevi podrobnije',
        'An error occurred during communication.' => '',
        'Show or hide the content.' => 'Prikaži ili sakrij sadržaj.',
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
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => 'Spremi i nastavi',
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

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => '',
        'Mapping XML' => '',
        'Template' => '',
        'The entered data is not a valid XSLT stylesheet.' => '',
        'Insert XSLT stylesheet.' => '',

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

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => '',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => '',
        'This field should be an integer number.' => '',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            '',
        'Send Keep-Alive' => '',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Host' => 'Udomitelj (host)',
        'Remote host URL for the REST requests.' => '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            '',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => '',
        'The default HTTP command to use for the requests.' => '',
        'Authentication' => '',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => '',
        'The password for the privileged user.' => '',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => '',
        'The full path and name of the SSL certificate file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => '',
        'Certificate Password File' => '',
        'The full path and name of the SSL key file.' => '',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => '',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Endpoint' => '',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => '',
        'Namespace' => '',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Request name scheme' => '',
        'Select how SOAP request function wrapper should be constructed.' =>
            '',
        '\'FunctionName\' is used as example for actual invoker/operation name.' =>
            '',
        '\'FreeText\' is used as example for actual configured value.' =>
            '',
        'Response name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
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
        'Proxy Server' => '',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => '',
        'Proxy User' => '',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => '',
        'The password for the proxy user.' => '',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'The password to open the SSL certificate.' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => '',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Sort options' => '',
        'Add new first level element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

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
        'Version' => 'Verzija',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Restore' => '',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'UPOZORENJE: Ako promijenite ime grupe \'admin\' prije adekvatnog podešavanja u SysConfig-u, izgubit ćete pristup administratorskom sučelju! Ako se to dogodi, vratite ime grupe u "admin" SQL naredbom.',
        'Group Management' => 'Upravljanje grupama',
        'Add group' => 'Dodaj grupu',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '"admin" grupa služi za pristup administrativnom prostoru a "stats" grupa prostoru statistike.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Kreirajte nove grupe da bi ste lakše upravljali dozvolama za različite zaposlenike (npr. prema odjelima)',
        'It\'s useful for ASP solutions. ' => 'Korisno za ASP rješenja.',
        'Add Group' => 'Dodaj grupu',
        'Edit Group' => 'Uredi grupu',

        # Template: AdminLog
        'System Log' => 'Dnevnik/zapisnik sustava',
        'Here you will find log information about your system.' => 'Ovdje se nalaze informacije o zabilježenim događajima u sustavu.',
        'Hide this message' => '',
        'Recent Log Entries' => '',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Upravljanje računima E-pošte',
        'Add mail account' => 'Dodaj E-pošta nalog',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Sve dolazne poruke sa jednog naloga će biti usmerene u izabrani rep!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Ako je vaš nalog od poverenja, koristiće se postojeća "X-OTRS" zaglavlja! "PostMaster" filteri se koriste uvek.',
        'Delete account' => 'Obriši račun E-pošte',
        'Fetch mail' => 'Preuzmi E-poštu',
        'Add Mail Account' => 'Dodaj račun E-pošte',
        'Example: mail.example.com' => 'Primjer: mail.example.com',
        'IMAP Folder' => '',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            '',
        'Trusted' => 'Povjerljivo',
        'Dispatching' => 'Otprema',
        'Edit Mail Account' => 'Uredi račun E-pošte',

        # Template: AdminNavigationBar
        'Admin' => 'Admininstracija',
        'Agent Management' => 'Upravljanje operaterima',
        'Queue Settings' => 'Postavke redova',
        'Ticket Settings' => 'Postavke kartica',
        'System Administration' => 'Administracija sustava',
        'Online Admin Manual' => '',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => '',
        'Add notification' => 'Dodaj obavijest',
        'Export Notifications' => '',
        'Configuration Import' => '',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            '',
        'Overwrite existing notifications?' => '',
        'Upload Notification configuration' => '',
        'Import Notification configuration' => '',
        'Delete this notification' => 'Obriši ovu obavijest',
        'Do you really want to delete this notification?' => '',
        'Add Notification' => 'Dodaj obavijest',
        'Edit Notification' => 'Uredi Obavijest',
        'Show in agent preferences' => '',
        'Agent preferences tooltip' => '',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'Filtar kartice',
        'Article Filter' => 'Filtar članka',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => 'Tip članka',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => '',
        'Subject match' => 'Poklapanje predmeta',
        'Body match' => 'Poklapanje sadržaja',
        'Include attachments to notification' => 'Priključi privitke uz obavijest',
        'Recipients' => '',
        'Send to' => '',
        'Send to these agents' => '',
        'Send to all group members' => '',
        'Send to all role members' => '',
        'Send on out of office' => '',
        'Also send if the user is currently out of office.' => '',
        'Once per day' => '',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'Notification Methods' => '',
        'These are the possible methods that can be used to send this notification to each of the recipients. Note: Excluding Email, other methods might not reach all selected recipients, please take a look on the documentation of each merthod to get more information. Please select at least one method below.' =>
            '',
        'Transport' => '',
        'Enable this notification method' => '',
        'At least one method is needed per notification.' => '',
        'This feature is currently not available.' => '',
        'No data found' => '',
        'No notification method found.' => '',
        'Notification Text' => '',
        'Remove Notification Language' => '',
        'Message body' => '',
        'Add new notification language' => '',
        'Do you really want to delete this notification language?' => '',
        'Tag Reference' => '',
        'Notifications are sent to an agent or a customer.' => 'Obavijest poslana operateru ili korisniku.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'Vidjeti prvih 20 slova predmeta (posljednjeg članka operatera).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            '',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'Vidjeti prvih 20 slova predmeta (posljednjeg članka zaposlenika)',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'Vidjeti prvih 5 redaka poruke (posljednjeg članka zaposlenika).',
        'Options of the recipient user for the notification' => '',

        # Template: AdminNotificationEventTransportEmailSettings
        'Recipient email addresses' => 'Adrese E-pošte primatelja',
        'Notification article type' => 'Tip članka obavijesti',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => '',
        'Downgrade to OTRS Free' => '',
        'Read documentation' => '',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '',
        'Unauthorized Usage Detected' => '',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            '',
        '%s not Correctly Installed' => '',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            '',
        'Reinstall %s' => '',
        'Your %s is not correctly installed, and there is also an update available.' =>
            '',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            '',
        'Update %s' => '',
        '%s Not Yet Available' => '',
        '%s will be available soon.' => '',
        '%s Update Available' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            '',
        '%s Correctly Deployed' => '',
        'Congratulations, your %s is correctly installed and up to date!' =>
            '',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '',
        'Please have a look at %s for more information.' => '',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            '',
        'With your existing contract you can only use a small part of the %s.' =>
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => '',
        'Go to OTRS Package Manager' => '',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            '',
        'Vendor' => 'Isporučitelj',
        'Please uninstall the packages first using the package manager and try again.' =>
            '',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            '',
        'Chat' => '',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => 'Tema %s',

        # Template: AdminPGP
        'PGP Management' => 'Upravljanje PGP ključevima',
        'Use this feature if you want to work with PGP keys.' => 'Upotrijebi ovu mogućnost za rad sa PGP-ključevima.',
        'Add PGP key' => 'Dodaj PGP ključ',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Na ovaj način možete direktno uređivati komplet ključeva podešen u sistemskim opcijama.',
        'Introduction to PGP' => 'Uvod u PGP',
        'Result' => 'Rezultat',
        'Identifier' => 'Identifikator',
        'Bit' => 'Bit',
        'Fingerprint' => 'Sažetak',
        'Expires' => 'Ističe',
        'Delete this key' => 'Obriši ovaj ključ',
        'Add PGP Key' => 'Dodaj PGP ključ',
        'PGP key' => 'PGP ključ',

        # Template: AdminPackageManager
        'Package Manager' => 'Upravljanje paketima',
        'Uninstall package' => 'Deinstaliraj paket',
        'Do you really want to uninstall this package?' => 'Da li zaista želite deinstalirati ovaj paket?',
        'Reinstall package' => 'Instaliraj paket ponovo',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Da li uistinu želite ponovno instalirati ovaj paket? Sve eventualne ručne promjene bit će izgubljene.',
        'Continue' => 'Nastavi',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Install' => 'Instaliraj',
        'Install Package' => 'Instaliraj paket',
        'Update repository information' => 'Ažuriraj informacije o repozitoriju',
        'Online Repository' => 'Mrežni repozitorij',
        'Module documentation' => 'Dokumentacija modula',
        'Upgrade' => 'Ažuriranje',
        'Local Repository' => 'Lokalni repozitorij',
        'This package is verified by OTRSverify (tm)' => '',
        'Uninstall' => 'Deinstaliraj',
        'Reinstall' => 'Instaliraj ponovo',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Download package' => 'Preuzmi paket',
        'Rebuild package' => 'Obnovi paket (rebuild)',
        'Metadata' => 'Meta-podaci',
        'Change Log' => 'Promijeni dnevnik',
        'Date' => 'Datum',
        'List of Files' => 'Spisak datoteka',
        'Permission' => 'Dozvola',
        'Download' => 'Preuzimanje',
        'Download file from package!' => 'Preuzmi datoteku iz paketa!',
        'Required' => 'Obavezno',
        'PrimaryKey' => 'Primarni ključ',
        'AutoIncrement' => 'Samoprirast',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Razlike za datoteku %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Dnevnik preformansi',
        'This feature is enabled!' => 'Ova funkcija je aktivna!',
        'Just use this feature if you want to log each request.' => 'Koristite ovu mogućnost ako želite zabilježiti svaki zahtjev.',
        'Activating this feature might affect your system performance!' =>
            'Aktiviranje ove mogućnosti može narušiti performanse sustava!',
        'Disable it here!' => 'Isključite je ovde!',
        'Logfile too large!' => 'Dnevnik je prevelik!',
        'The logfile is too large, you need to reset it' => 'Datoteka dnevnika je prevelika, treba ju očistiti (reset)',
        'Overview' => 'Pregled',
        'Range' => 'Opseg',
        'last' => 'zadnje',
        'Interface' => 'Sučelje',
        'Requests' => 'Zahtjevi',
        'Min Response' => 'Min. vrijeme reakcije',
        'Max Response' => 'Maks. vrijeme reakcije',
        'Average Response' => 'Prosječno vrijeme reakcije',
        'Period' => 'Period',
        'Min' => 'Min',
        'Max' => 'Maks',
        'Average' => 'Prosjek',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Upravljanje "PostMaster" filtrima',
        'Add filter' => 'Dodaj filtar',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'Radi otpreme ili filtriranja dolaznih poruka na osnovu zaglavlja. Uporaba regularnih izraza je također moguća.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Ukoliko želite usklađivanje samo adresa e-pošte, koristite EMAILADDRESS:info@example.com u "Od", "Za" ili "Cc".',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Ukoliko koristite regularne izraze, možete također koristiti niz zahvaćen s () kao [***] u \'Set\' akciji.',
        'Delete this filter' => 'Obriši ovaj filtar',
        'Add PostMaster Filter' => 'Dodaj "PostMaster" filter',
        'Edit PostMaster Filter' => 'Uredi "PostMaster" filter',
        'The name is required.' => '',
        'Filter Condition' => 'Uvjet filtriranja',
        'AND Condition' => '',
        'Check email header' => '',
        'Negate' => '',
        'Look for value' => '',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'Postavi zaglavlja E-pošte',
        'Set email header' => '',
        'Set value' => '',
        'The field needs to be a literal word.' => '',

        # Template: AdminPriority
        'Priority Management' => 'Upravljanje prioritetima',
        'Add priority' => 'Dodaj prioritet',
        'Add Priority' => 'Dodaj prioritet',
        'Edit Priority' => 'Uredi prioritet',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Create New Process' => '',
        'Deploy All Processes' => '',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            '',
        'Overwrite existing entities' => '',
        'Upload process configuration' => '',
        'Import process configuration' => '',
        'Example processes' => '',
        'Here you can activate best practice example processes that are part of %s. Please note that some additional configuration may be required.' =>
            '',
        'Import example process' => '',
        'Do you want to benefit from processes created by experts? Upgrade to %s to be able to import some sophisticated example processes.' =>
            '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            '',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            '',
        'Processes' => '',
        'Process name' => '',
        'Print' => 'Ispiši',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => '',
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
        'The Queue field can only be used by customers when creating a new ticket.' =>
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
        'Process Name' => '',
        'The selected state does not exist.' => '',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => '',
        'Save settings' => 'Spremi postavke',
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
        'And can\'t be repeated on the same condition.' => '',
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
        'Add Queue' => 'Dodaj red',
        'Edit Queue' => 'Uredi red',
        'A queue with this name already exists!' => '',
        'Sub-queue of' => 'Pod-red od',
        'Unlock timeout' => 'Vrijeme do otključavanja',
        '0 = no unlock' => '0 = nema otključavanja',
        'Only business hours are counted.' => 'Mjeri se samo radno vrijeme.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            '',
        'Notify by' => 'Zabilježeno od',
        '0 = no escalation' => '0 = nema eskalacije',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            '',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Ako se karticu ne zatvori prije ovdje definiranog vremena, kartica eskalira.',
        'Follow up Option' => 'Opcije praćenja',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Nastavak na zatvorenu karticu ponovno otvara karticu ili otvara novi.',
        'Ticket lock after a follow up' => 'Zaključavanje kartice poslije nastavka',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Ako je kartica zatvorena, a korisnik pošalje nastavak, kartica će biti zaključana na starog vlasnika.',
        'System address' => 'Adresa sustava',
        'Will be the sender address of this queue for email answers.' => 'Adresa pošiljaoca E-pošte za odgovore iz ovog repa.',
        'Default sign key' => 'Zadani ključ potpisa',
        'The salutation for email answers.' => 'Zaglavlje/pozdrav za odgovore E-pošte.',
        'The signature for email answers.' => 'Podnožje/potpis za odgovore E-pošte.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Upravljanje vezama rep <-> automatski odgovor',
        'Filter for Queues' => 'Filtar za repove',
        'Filter for Auto Responses' => 'Filtar za automatske odgovore',
        'Auto Responses' => 'Automatski odgovori',
        'Change Auto Response Relations for Queue' => 'Promijeni veze sa automatskim odgovorima za rep',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => '',
        'Filter for Templates' => '',
        'Templates' => '',
        'Change Queue Relations for Template' => '',
        'Change Template Relations for Queue' => '',

        # Template: AdminRegistration
        'System Registration Management' => '',
        'Edit details' => '',
        'Show transmitted data' => '',
        'Deregister system' => '',
        'Overview of registered systems' => '',
        'This system is registered with OTRS Group.' => '',
        'System type' => '',
        'Unique ID' => '',
        'Last communication with registration server' => '',
        'System registration not possible' => '',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            '',
        'Instructions' => '',
        'System deregistration not possible' => '',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            '',
        'OTRS-ID Login' => '',
        'Read more' => '',
        'You need to log in with your OTRS-ID to register your system.' =>
            '',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            '',
        'Data Protection' => '',
        'What are the advantages of system registration?' => '',
        'You will receive updates about relevant security releases.' => '',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            '',
        'This is only the beginning!' => '',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTRS without being registered?' => '',
        'System registration is optional.' => '',
        'You can download and use OTRS without being registered.' => '',
        'Is it possible to deregister?' => '',
        'You can deregister at any time.' => '',
        'Which data is transfered when registering?' => '',
        'A registered system sends the following data to OTRS Group:' => '',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            '',
        'Why do I have to provide a description for my system?' => '',
        'The description of the system is optional.' => '',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            '',
        'How often does my OTRS system send updates?' => '',
        'Your system will send updates to the registration server at regular intervals.' =>
            '',
        'Typically this would be around once every three days.' => '',
        'In case you would have further questions we would be glad to answer them.' =>
            '',
        'Please visit our' => '',
        'portal' => '',
        'and file a request.' => '',
        'If you deregister your system, you will lose these benefits:' =>
            '',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            '',
        'OTRS-ID' => '',
        'You don\'t have an OTRS-ID yet?' => '',
        'Sign up now' => 'Registrirajte se sada',
        'Forgot your password?' => 'Zaboravili ste lozinku?',
        'Retrieve a new one' => '',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            '',
        'Attribute' => '',
        'FQDN' => 'Puno ime domene',
        'OTRS Version' => '',
        'Operating System' => 'Operacijski sustav',
        'Perl Version' => '',
        'Optional description of this system.' => '',
        'Register' => '',
        'Deregister System' => '',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            '',
        'Deregister' => '',
        'You can modify registration settings here.' => '',
        'Overview of transmitted data' => '',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

        # Template: AdminRole
        'Role Management' => 'Upravljanje ulogama',
        'Add role' => 'Dodaj ulogu',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Stvori ulogu i dodaj grupe u nju. Zatim dodaj ulogu zaposlenicima.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Nema definiranih uloga. Koristite tipku za dodavanje nove uloge.',
        'Add Role' => 'Dodaj ulogu',
        'Edit Role' => 'Uredi ulogu',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Upravljanje vezama uloga <-> grupa',
        'Filter for Roles' => 'Filtar uloga',
        'Roles' => 'Uloge',
        'Select the role:group permissions.' => 'Izaberi dozvole za ulogu:grupu',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Ukoliko ništa nije izabrano, onda nema dozvola u ovoj grupi (kartice neće biti dostupne za ovu ulogu).',
        'Change Role Relations for Group' => 'Promijeni veze sa ulogama za grupu',
        'Change Group Relations for Role' => 'Promijeni veze sa grupama za ulogu',
        'Toggle %s permission for all' => 'Promijeni %s dozvole za sve',
        'move_into' => 'premjesti u',
        'Permissions to move tickets into this group/queue.' => 'Pravo da se karticu premjesti u ovu grupu/rep.',
        'create' => 'napravi',
        'Permissions to create tickets in this group/queue.' => 'Pravo da se karticu kreira u ovoj grupi/redu.',
        'note' => 'napomena',
        'Permissions to add notes to tickets in this group/queue.' => 'Dozvola za dodavanje napomena karticama u ovoj grupi/redu.',
        'owner' => 'Vlasnik',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Dozvole za promjenu vlasnika kartice u ovoj grupi/redu.',
        'priority' => 'prioritet',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Pravo da se mijenja prioritet kartice u ovoj grupi/redu.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Upravljanje vezama Operater <-> Uloga',
        'Add agent' => 'Dodaj zaposlenika',
        'Filter for Agents' => 'Filtar operatera',
        'Agents' => 'Operateri',
        'Manage Role-Agent Relations' => 'Upravljanje vezama Uloga <-> Operater',
        'Change Role Relations for Agent' => 'Promijeni veze sa Ulogama za Operatera',
        'Change Agent Relations for Role' => 'Promijeni veze sa Operaterima za Ulogu',

        # Template: AdminSLA
        'SLA Management' => 'Upravljanje SLA',
        'Add SLA' => 'Dodaj SLA',
        'Edit SLA' => 'Uredi SLA',
        'Please write only numbers!' => 'Molimo pišite samo brojeve!',

        # Template: AdminSMIME
        'S/MIME Management' => '"S/MIME" upravljanje',
        'Add certificate' => 'Dodaj vjerodajnicu',
        'Add private key' => 'Dodaj privatni ključ',
        'Filter for certificates' => '',
        'Filter for S/MIME certs' => '',
        'To show certificate details click on a certificate icon.' => '',
        'To manage private certificate relations click on a private key icon.' =>
            '',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Pogledaj još',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Na ovaj način možete izravno urediti vjerodajnice i privatne ključeve u sustavu datoteka.',
        'Hash' => 'Hash',
        'Handle related certificates' => '',
        'Read certificate' => '',
        'Delete this certificate' => 'Obriši ovu vjerodajnicu',
        'Add Certificate' => 'Dodaj vjerodajnicu',
        'Add Private Key' => 'Dodaj privatni ključ',
        'Secret' => 'Tajna',
        'Related Certificates for' => '',
        'Delete this relation' => '',
        'Available Certificates' => '',
        'Relate this certificate' => '',

        # Template: AdminSMIMECertRead
        'Certificate details' => '',

        # Template: AdminSalutation
        'Salutation Management' => 'Upravljanje zaglavljima/pozdravima',
        'Add salutation' => 'Dodaj zaglavlje/pozdrav',
        'Add Salutation' => 'Dodaj zaglavlje/pozdrav',
        'Edit Salutation' => 'Uredi zaglavlje/pozdrav',
        'e. g.' => 'npr.',
        'Example salutation' => 'Primjer zaglavlja/pozdrava',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Potrebno je da siguran način bude uključen!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Siguran način će (uobučajeno) biti postavljen nakon inicijalne instalacije.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Ukoliko siguran način nije aktiviran, pokrenite ga kroz konfiguraciju sustava jer je vaša aplikacija već pokrenuta.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            'Ovde možete unijeti SQL naredbe i poslati ih izravno aplikacijskoj bazi podataka. Nije moguće mjenjati sadržaj tabela, dozvoljen je jedino select upit.',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Ovde možete unijeti SQL naredbe i poslati ih izravno aplikacijskoj bazi podataka.',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Postoji pogreška u sintaksi vašeg SQL upita. Molimo provjerite.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Najmanje jedan parametar nedostaje za povezivanje. Molimo provjerite.',
        'Result format' => 'Format rezultata',
        'Run Query' => 'Pokreni Upit',
        'Query is executed.' => '',

        # Template: AdminService
        'Service Management' => 'Upravljanje uslugama',
        'Add service' => 'Dodaj uslugu',
        'Add Service' => 'Dodaj Uslugu',
        'Edit Service' => 'Uredi Uslugu',
        'Sub-service of' => 'Pod-usluga od',

        # Template: AdminSession
        'Session Management' => 'Upravljanje sesijama',
        'All sessions' => 'Sve sesije',
        'Agent sessions' => 'Sesije Operatera',
        'Customer sessions' => 'Sesije korisnika',
        'Unique agents' => 'Jedinsveni operateri',
        'Unique customers' => 'Jedinstveni korisnici',
        'Kill all sessions' => 'Ugasi sve sesije',
        'Kill this session' => 'Ugasi ovu sesiju',
        'Session' => 'Sesija',
        'Kill' => 'Ugasi',
        'Detail View for SessionID' => 'Detaljni pregled za ID sesije',

        # Template: AdminSignature
        'Signature Management' => 'Upravljanje podnožjima/potpisima',
        'Add signature' => 'Dodaj podnožje/potpis',
        'Add Signature' => 'Dodaj podnožje/potpis',
        'Edit Signature' => 'Uredi podnožje/potpis',
        'Example signature' => 'Primjer podnožja/potpisa',

        # Template: AdminState
        'State Management' => 'Upravljanje statusima',
        'Add state' => 'Dodaj stanje',
        'Please also update the states in SysConfig where needed.' => '',
        'Add State' => 'Dodaj stanje',
        'Edit State' => 'Uredi stanje',
        'State type' => 'Tip stanja',

        # Template: AdminSupportDataCollector
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => '',
        'Sending Update...' => '',
        'Support Data information was successfully sent.' => '',
        'Was not possible to send Support Data information.' => '',
        'Update Result' => '',
        'Currently this data is only shown in this system.' => '',
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
        'Sending' => 'Slanje',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            '',
        'Download File' => '',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            '',
        'Error: Support data could not be collected (%s).' => '',
        'Details' => '',

        # Template: AdminSysConfig
        'SysConfig' => 'Postavke sustava',
        'Navigate by searching in %s settings' => 'Pretraživanje kroz %s postavki',
        'Navigate by selecting config groups' => '',
        'Download all system config changes' => 'Preuzmi sve promjene postavki sustava',
        'Export settings' => 'Izvoz postavki',
        'Load SysConfig settings from file' => 'Učitaj postavke sustava iz datoteke',
        'Import settings' => 'Uvoz postavki',
        'Import Settings' => 'Uvezi postavke sustava iz datoteke',
        'Please enter a search term to look for settings.' => 'Molimo unesite upit za traženje postavki.',
        'Subgroup' => 'Podgrupa',
        'Elements' => 'Elementi',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Uredi konfiguracijske postavke',
        'This setting is read only.' => '',
        'This config item is only available in a higher config level!' =>
            'Ova konfiguracijska stavka je dostupna samo na višoj razini konfiguriranja!',
        'Reset this setting' => 'Reset postavke',
        'Error: this file could not be found.' => 'Greška: datoteka nije pronađena.',
        'Error: this directory could not be found.' => 'Greška: mapa nije pronađena.',
        'Error: an invalid value was entered.' => 'Greška: unijeta je pogrešna vrijednost.',
        'Content' => 'Sadržaj',
        'Remove this entry' => 'Ukloni ovaj unos',
        'Add entry' => 'Dodaj unos',
        'Remove entry' => 'Ukloni unos',
        'Add new entry' => 'Dodaj novi unos',
        'Delete this entry' => 'Obriši ovaj unos',
        'Create new entry' => 'Napravi novi unos',
        'New group' => 'Nova grupa',
        'Group ro' => 'Grupa "RO"',
        'Readonly group' => 'Grupa samo za čitanje',
        'New group ro' => 'Nova "RO" grupa',
        'Loader' => '"Loader"',
        'File to load for this frontend module' => 'Datoteka koju treba učitati za ovaj modul',
        'New Loader File' => 'Nova "Loader" datoteka',
        'NavBarName' => 'Naziv navigacijske trake',
        'NavBar' => 'Navigacijska traka',
        'LinkOption' => 'Opcije veze',
        'Block' => 'Blok',
        'AccessKey' => 'Ključ za pristup',
        'Add NavBar entry' => 'Dodaj stavku u navigacijsku traku',
        'Year' => 'godina',
        'Month' => 'mjesec',
        'Day' => 'dan',
        'Invalid year' => 'Pogrešna godina',
        'Invalid month' => 'Pogrešan mjesec',
        'Invalid day' => 'Pogrešan dan',
        'Show more' => '',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Upravljanje E-poštom sustava',
        'Add system address' => 'Dodaj sistemsku adresu',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Sve dolazne poruke sa ovom adresom u polju "Za" ili "Cc" bit će otpremljene u odabrani rep.',
        'Email address' => 'Adresa E-pošte',
        'Display name' => 'Prikaži ime',
        'Add System Email Address' => 'Dodaj adresu E-pošte sustava',
        'Edit System Email Address' => 'Uredi adresu E-pošte sustava',
        'The display name and email address will be shown on mail you send.' =>
            'Ime i adresa E-pošte bit će prikazani na poruci koju ste poslali.',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => '',
        'Schedule New System Maintenance' => '',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Start date' => '',
        'Stop date' => '',
        'Delete System Maintenance' => '',
        'Do you really want to delete this scheduled system maintenance?' =>
            '',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => '',
        'Edit System Maintenance information' => '',
        'Date invalid!' => 'Neispravan datum',
        'Login message' => '',
        'Show login message' => '',
        'Notify message' => '',
        'Manage Sessions' => '',
        'All Sessions' => '',
        'Agent Sessions' => '',
        'Customer Sessions' => '',
        'Kill all Sessions, except for your own' => '',

        # Template: AdminTemplate
        'Manage Templates' => '',
        'Add template' => '',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            '',
        'Don\'t forget to add new templates to queues.' => '',
        'Add Template' => '',
        'Edit Template' => '',
        'A standard template with this name already exists!' => '',
        'Create type templates only supports this smart tags' => '',
        'Example template' => '',
        'The current ticket state is' => 'Trenutni status kartice je',
        'Your email address is' => 'Vaša adresa E-pošte je',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => '',
        'Filter for Attachments' => 'Filtar za privitke',
        'Change Template Relations for Attachment' => '',
        'Change Attachment Relations for Template' => '',
        'Toggle active for all' => 'Promijeni stanje aktivnosti za sve',
        'Link %s to selected %s' => 'Poveži %s sa izabranim %s',

        # Template: AdminType
        'Type Management' => 'Upravljanje tipovima',
        'Add ticket type' => 'Dodaj tip kartice',
        'Add Type' => 'Dodaj tip',
        'Edit Type' => 'Uredi tip',
        'A type with this name already exists!' => '',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'Za obradu kartice potrebni su zaposlenici.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Ne zaboravite dodati novog zaposlenika u grupe i/ili uloge!',
        'Please enter a search term to look for agents.' => 'Molimo unesite upit za pretragu radi nalaženja zaposlenika.',
        'Last login' => 'Prethodna prijava',
        'Switch to agent' => 'Prijeđi na operatera',
        'Add Agent' => 'Dodaj operatera',
        'Edit Agent' => 'Uredi operatera',
        'Firstname' => 'Ime',
        'Lastname' => 'Prezime',
        'A user with this username already exists!' => '',
        'Will be auto-generated if left empty.' => '',
        'Start' => 'Start',
        'End' => 'Kraj',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Upravljanje vezama Operater <-> Grupa',
        'Change Group Relations for Agent' => 'Promijeni veze s Grupama za Operatera',
        'Change Agent Relations for Group' => 'Promijeni veze s operaterima za grupu',

        # Template: AgentBook
        'Address Book' => 'Adresar',
        'Search for a customer' => 'Traži korisnika',
        'Add email address %s to the To field' => 'Dodaj adresu E-pošte %s u polje "Za:"',
        'Add email address %s to the Cc field' => 'Dodaj adresu E-pošte %s u polje "Cc:"',
        'Add email address %s to the Bcc field' => 'Dodaj adresu E-pošte %s u polje "Bcc:"',
        'Apply' => 'Primjeni',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Korisnik',

        # Template: AgentCustomerSearch
        'Duplicated entry' => '',
        'This address already exists on the address list.' => '',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => '',

        # Template: AgentDaemonInfo
        'General Information' => '',
        'OTRS Daemon is a separated process that perform asynchronous tasks' =>
            '',
        '(e.g. Generic Interface asynchronous invoker tasks, Ticket escalation triggering, Email sending, etc.)' =>
            '',
        'It is necessary to have the OTRS Daemon running to make the system work correctly!' =>
            '',
        'Starting OTRS Daemon' => '',
        'Make sure that %s exists (without .dist extension)' => '',
        'Check that cron deamon is running in the system' => '',
        'Confirm that OTRS cron jobs are running, execute %s start' => '',

        # Template: AgentDashboard
        'Dashboard' => 'Nadzorna ploča',

        # Template: AgentDashboardCalendarOverview
        'in' => 'u',

        # Template: AgentDashboardCommon
        'Available Columns' => '',
        'Visible Columns (order by drag & drop)' => '',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => '',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => '',
        'Phone ticket' => '',
        'Email ticket' => '',
        'Start Chat' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',
        'Start chat' => '',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s je dostupno!',
        'Please update now.' => 'Molimo ažurirajte sada.',
        'Release Note' => 'Obavijest o verziji',
        'Level' => 'Razina',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Poslano prije %s.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            '',
        'Download as SVG file' => '',
        'Download as PNG file' => '',
        'Download as CSV file' => '',
        'Download as Excel file' => '',
        'Download as PDF file' => '',
        'Grouped' => '',
        'Stacked' => '',
        'Expanded' => '',
        'Stream' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            '',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            '',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => '',
        'My watched tickets' => '',
        'My responsibilities' => '',
        'Tickets in My Queues' => '',
        'Tickets in My Services' => '',
        'Service Time' => 'Vrijeme usuživanja',
        'Remove active filters for this widget.' => '',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => '',

        # Template: AgentDashboardUserOnline
        'out of office' => '',
        'Selected agent is not available for chat' => '',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Kartica je zaključana.',
        'Undo & close' => '',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'Da bi prihvatili neke vijesti, licencu ili promjenu.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Poveži objekt: %s',
        'go to link delete screen' => 'idi na poveznicu za brisanje ekrana',
        'Select Target Object' => 'Izaberi ciljni objekt',
        'Link Object' => 'Poveži objekt',
        'with' => 'sa',
        'Unlink Object: %s' => 'Prekini vezu sa objektom: %s',
        'go to link add screen' => 'idi na prozor za dodavanje veze',

        # Template: AgentPreferences
        'Edit your preferences' => 'Uredi osobne postavke',
        'Did you know? You can help translating OTRS at %s.' => '',

        # Template: AgentSpelling
        'Spell Checker' => 'Provjera pravopisa',
        'spelling error(s)' => 'pravopisne pogreške',
        'Apply these changes' => 'Primjeni ove izmjene',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => '',
        'Add New Statistic' => '',
        'Dynamic Matrix' => '',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            '',
        'Dynamic List' => '',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            '',
        'Static' => '',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            '',
        'General Specification' => '',
        'Create Statistic' => '',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => '',
        'Run now' => '',
        'Statistics Preview' => '',
        'Save statistic' => '',

        # Template: AgentStatisticsImport
        'Statistics » Import' => '',
        'Import Statistic Configuration' => '',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => '',
        'Statistics' => 'Statistike',
        'Run' => '',
        'Edit statistic "%s".' => '',
        'Export statistic "%s"' => '',
        'Export statistic %s' => '',
        'Delete statistic "%s"' => '',
        'Delete statistic %s' => '',
        'Do you really want to delete this statistic?' => '',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => '',
        'This statistic contains configuration errors and can currently not be used.' =>
            '',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s' => '',
        'Change Owner of %s%s' => '',
        'Close %s%s' => '',
        'Add Note to %s%s' => '',
        'Set Pending Time for %s%s' => '',
        'Change Priority of %s%s' => '',
        'Change Responsible of %s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => '',
        'Service invalid.' => 'Neispravan servis',
        'New Owner' => 'Novi vlasnik',
        'Please set a new owner!' => 'Molimo odredite novog vlasnika',
        'New Responsible' => '',
        'Next state' => 'Sljedeći status',
        'For all pending* states.' => '',
        'Add Article' => '',
        'Create an Article' => '',
        'Spell check' => 'Provjera pravopisa',
        'Text Template' => '',
        'Setting a template will overwrite any text or attachment.' => '',
        'Note type' => 'Tip napomene',
        'Inform Agent' => 'Obavijesti operatera',
        'Optional' => 'Proizvoljno',
        'Inform involved Agents' => 'Obavijesti uključene operatere',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            '',
        'Note will be (also) received by:' => '',

        # Template: AgentTicketBounce
        'Bounce Ticket' => '',
        'Bounce to' => 'Preusmjeri na',
        'You need a email address.' => 'Potrebna vam je adresa E-pošte.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Ispravna adresa E-pošte je neophodna, ali ne koristite lokalnu adresu!',
        'Next ticket state' => 'Sljedeći status kartice',
        'Inform sender' => 'Obavijesti pošiljatelja',
        'Send mail' => 'Pošalji E-poštu!',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Grupne akcije na karticama',
        'Send Email' => 'Pošalji E-poštu!',
        'Merge to' => 'Objedini sa',
        'Invalid ticket identifier!' => 'Neispravan identifikator kartice!',
        'Merge to oldest' => 'Objedini sa najstarijom',
        'Link together' => 'Poveži zajedno',
        'Link to parent' => 'Poveži s nadređenim',
        'Unlock tickets' => 'Otključaj karticu',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s' => '',
        'Please include at least one recipient' => '',
        'Remove Ticket Customer' => '',
        'Please remove this entry and enter a new one with the correct value.' =>
            '',
        'Remove Cc' => '',
        'Remove Bcc' => '',
        'Address book' => 'Adresar',
        'Date Invalid!' => 'Neispravan datum!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s' => '',
        'Customer user' => 'Korisnik',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Otvori novu karticu E-pošte',
        'Example Template' => '',
        'From queue' => 'Iz reda',
        'To customer user' => '',
        'Please include at least one customer user for the ticket.' => '',
        'Select this customer as the main customer.' => '',
        'Remove Ticket Customer User' => '',
        'Get all' => 'Dohvati sve',
        'Do you really want to continue?' => '',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => '',
        'Ticket %s: first response time will be over in %s/%s!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => '',
        'Ticket %s: solution time will be over in %s/%s!' => '',

        # Template: AgentTicketForward
        'Forward %s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s' => '',
        'History Content' => 'Sadržaj dnevnika',
        'Zoom view' => 'Detaljni pregled',

        # Template: AgentTicketMerge
        'Merge %s%s' => '',
        'Merge Settings' => '',
        'You need to use a ticket number!' => 'Molimo vas da koristite broj kartice!',
        'A valid ticket number is required.' => 'Neophodan je ispravan broj kartice.',
        'Need a valid email address.' => 'Potrebna ispravna adresa E-pošte.',

        # Template: AgentTicketMove
        'Move %s%s' => '',
        'New Queue' => 'Novi red',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Izaberi sve',
        'No ticket data found.' => 'Nisu nađeni podaci o kartici',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => '',
        'First Response Time' => 'Vrijeme prvog odgovora',
        'Update Time' => 'Vrijeme ažuriranja',
        'Solution Time' => 'Vrijeme rješavanja',
        'Move ticket to a different queue' => 'Premjesti karticu u drugi red',
        'Change queue' => 'Promjeni rep',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Promjeni opcije pretrage',
        'Remove active filters for this screen.' => '',
        'Tickets per page' => '',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => '',
        'Column Filters Form' => '',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'Otvori novi telefonski karticu',
        'Please include at least one customer for the ticket.' => '',
        'To queue' => 'U red',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => '',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s' => '',
        'Plain' => 'Neformatirano',
        'Download this email' => 'Preuzmi ovu poruku',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Search template' => 'Predložak pretrage',
        'Create Template' => 'Napravi predložak',
        'Create New' => 'Napravi novi',
        'Profile link' => '',
        'Save changes in template' => 'Spremi promjene u predlošku',
        'Filters in use' => '',
        'Additional filters' => '',
        'Add another attribute' => 'Dodaj još jedan atribut',
        'Output' => 'Pregled rezultata',
        'Fulltext' => 'Tekst',
        'Remove' => 'Ukloni',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Prijava korisnika',
        'Attachment Name' => '',
        '(e. g. m*file or myfi*)' => '',
        'Created in Queue' => 'Otvoreno u redu',
        'Lock state' => 'Status zaključavanja',
        'Watcher' => 'Praćenje',
        'Article Create Time (before/after)' => 'Vrijeme kreiranja članka (prije/poslije)',
        'Article Create Time (between)' => 'Vrijeme kreiranja članka (između)',
        'Ticket Create Time (before/after)' => 'Vrijeme nastanka kartice (prije/poslije)',
        'Ticket Create Time (between)' => 'Vrijeme nastanka kartice (između)',
        'Ticket Change Time (before/after)' => 'Vrijeme promjene kartice (prije/poslije)',
        'Ticket Change Time (between)' => 'Vrijeme promjene kartice (između)',
        'Ticket Last Change Time (before/after)' => '',
        'Ticket Last Change Time (between)' => '',
        'Ticket Close Time (before/after)' => 'Vrijeme zatvaranja kartice (prije/poslije)',
        'Ticket Close Time (between)' => 'Vrijeme zatvaranja kartice (između)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Pretraga arhive',
        'Run search' => 'Pokreni pretragu',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtar za članke',
        'Article Type' => 'Tip članka',
        'Sender Type' => '',
        'Save filter settings as default' => 'Spremi postavke filtra kao zadane',
        'Event Type Filter' => '',
        'Event Type' => '',
        'Save as default' => 'Spremi kao zadano',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Locked' => 'Zaključano',
        'Accounted time' => 'Obračunato vrijeme',
        'Linked Objects' => 'Povezani objekti',
        'Change Queue' => 'Promijeni red',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Ticket Timeline View' => '',
        'Article Overview' => '',
        'Article(s)' => 'Članak/ci',
        'Page' => 'Strana',
        'Add Filter' => 'Dodaj filtar',
        'Set' => 'Postavi',
        'Reset Filter' => 'Reset filtra',
        'Show one article' => 'Prikaži jedan članak',
        'Show all articles' => 'Prikaži sve članke',
        'Show Ticket Timeline View' => '',
        'Unread articles' => 'Nepročitani članci',
        'No.' => 'Br.',
        'Important' => '',
        'Unread Article!' => 'Nepročitani članci!',
        'Incoming message' => 'Dolazna poruka',
        'Outgoing message' => 'Odlazna poruka',
        'Internal message' => 'Interna poruka',
        'Resize' => 'Promjena veličine',
        'Mark this article as read' => '',
        'Show Full Text' => '',
        'Full Article Text' => '',
        'No more events found. Please try changing the filter settings.' =>
            '',
        'by' => 'od',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => '',
        'Article could not be opened! Perhaps it is on another article page?' =>
            '',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Učitaj blokirani sadržaj.',

        # Template: ChatStartForm
        'First message' => '',

        # Template: CustomerError
        'Traceback' => 'Slijeđevina',

        # Template: CustomerFooter
        'Powered by' => 'Pokreće',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'Dogodila se jedna ili više grešaka!',
        'Close this dialog' => 'Zatvori ovaj dijalog',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Nije moguće otvoriti iskačući prozor. Molimo da isključite blokadu iskačućih prozora za ovu aplikaciju.',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Ako napustite ovu stranicu, svi otvoreni prozori bit će zatvoreni!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Prikaz ovog ekrana je već otvoren. Želite li zatvoriti i učitati ovaj umjesto njega?',
        'There are currently no elements available to select from.' => '',
        'Please turn off Compatibility Mode in Internet Explorer!' => '',
        'The browser you are using is too old.' => 'Preglednik koji koristite je previše star.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS funcionira na velikom broju preglednika, molimo da instalirate i koristite jedan od ovih.',
        'Please see the documentation or ask your admin for further information.' =>
            'Molimo da pregledate dokumentaciju ili pitate vašeg administratora za dodatne informacije.',
        'Switch to mobile mode' => '',
        'Switch to desktop mode' => '',
        'Not available' => '',
        'Clear all' => '',
        'Clear search' => '',
        '%s selection(s)...' => '',
        'and %s more...' => '',
        'Filters' => '',
        'Confirm' => '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript nije dostupan.',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'Kako bi ste koristili OTRS potrebno je aktivirati JavaScript u vašem web pregledniku.',
        'Browser Warning' => 'Upozorenje preglednika',
        'One moment please, you are being redirected...' => '',
        'Login' => 'Prijava',
        'User name' => 'Korisničko ime',
        'Your user name' => 'Vaše korisničko ime',
        'Your password' => 'Vaša lozinka',
        'Forgot password?' => 'Zaboravili ste lozinku?',
        '2 Factor Token' => '',
        'Your 2 Factor Token' => '',
        'Log In' => 'Prijavi se',
        'Not yet registered?' => 'Niste registrirani?',
        'Request new password' => 'Zahtjev za novu lozinku',
        'Your User Name' => 'Vaše korisničko ime',
        'A new password will be sent to your email address.' => 'Nova lozinka će Vam biti poslana na Vašu adresu E-pošte.',
        'Create Account' => 'Napravite korisnički račun',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Kako da Vas oslovljavamo',
        'Your First Name' => 'Vaše ime',
        'Your Last Name' => 'Vaše prezime',
        'Your email address (this will become your username)' => '',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '',
        'You have unanswered chat requests' => '',
        'Edit personal preferences' => 'Uredite osobne postavke',
        'Logout %s %s' => '',

        # Template: CustomerRichTextEditor
        'Split Quote' => '',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Sporazum o razini usluge',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Dobrodošli!',
        'Please click the button below to create your first ticket.' => 'Molimo kliknite tipku ispod kako bi ste napravili svoju prvu karticu.',
        'Create your first ticket' => 'Napravi prvu karticu',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'npr 10*5155 ili 105658*',
        'Customer ID' => 'ID korisnika',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Tekstualno pretraživanje u karticama (npr. "Kre*o" ili "Željk*")',
        'Recipient' => 'Primalac',
        'Carbon Copy' => 'Kopija',
        'e. g. m*file or myfi*' => '',
        'Types' => 'Tipovi',
        'Time restrictions' => 'Vremenska ograničenja',
        'No time settings' => '',
        'Only tickets created' => 'Samo otvorene kartice',
        'Only tickets created between' => 'Samo kartice otvorene između',
        'Ticket archive system' => '',
        'Save search as template?' => '',
        'Save as Template?' => 'Spremi kao predložak?',
        'Save as Template' => 'Spremi kao predložak',
        'Template Name' => 'Naziv predloška',
        'Pick a profile name' => '',
        'Output to' => 'Izlaz na',

        # Template: CustomerTicketSearchResultShort
        'of' => 'od',
        'Search Results for' => 'Rezultati pretraživanja za',
        'Remove this Search Term.' => '',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '',
        'Expand article' => '',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'Odgovori',
        'Chat Protocol' => '',

        # Template: DashboardEventsTicketCalendar
        'All-day' => '',
        'Sunday' => 'nedjelja',
        'Monday' => 'ponedjeljak',
        'Tuesday' => 'utorak',
        'Wednesday' => 'srijeda',
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
        'Invalid date (need a past date)!' => 'Neispravan datum (potreban već protekli datum)!',
        'Previous' => 'Prethodni',
        'Open date selection' => 'Otvori izbor datuma',

        # Template: Error
        'Oops! An Error occurred.' => 'Ups! Dogodila se pogreška.',
        'You can' => 'Vi možete',
        'Send a bugreport' => 'Pošalji izvještaj o pogrešci',
        'go back to the previous page' => 'idi na prethodnu stranicu',
        'Error Details' => 'Detalji pogreške',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            '',
        'Please remove the following words from your search as they cannot be searched for:' =>
            '',
        'Please check the fields marked as red for valid inputs.' => '',
        'Please perform a spell check on the the text first.' => '',
        'Slide the navigation bar' => '',
        'Unavailable for chat' => '',
        'Available for internal chats only' => '',
        'Available for chats' => '',
        'Please visit the chat manager' => '',
        'New personal chat request' => '',
        'New customer chat request' => '',
        'New public chat request' => '',
        'New activity' => '',
        'New activity on one of your monitored chats.' => '',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            '',
        'Find out more about the %s' => '',

        # Template: Header
        'You are logged in as' => 'Prijavljeni ste kao',

        # Template: Installer
        'JavaScript not available' => 'JavaScript nije dostupan.',
        'Step %s' => 'Korak %s',
        'Database Settings' => 'Postavke baze podataka',
        'General Specifications and Mail Settings' => 'Opće specifikacije i postavke E-pošte',
        'Finish' => 'Završi',
        'Welcome to %s' => '',
        'Web site' => 'Web stranica',
        'Mail check successful.' => 'Uspješna provjera postavki E-pošte.',
        'Error in the mail settings. Please correct and try again.' => 'Greška u postavkama E-pošte. Molimo ispravite i pokušajte ponovo.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Podešavanje odlazne E-pošte',
        'Outbound mail type' => 'Tip odlazne E-pošte',
        'Select outbound mail type.' => 'Izaberite tip odlazne E-pošte',
        'Outbound mail port' => 'Port za odlaznu E-poštu',
        'Select outbound mail port.' => 'Izaberite port za odlaznu E-poštu',
        'SMTP host' => 'SMTP host',
        'SMTP host.' => 'SMTP host.',
        'SMTP authentication' => 'SMTP autentikacija',
        'Does your SMTP host need authentication?' => 'Zahtijeva li vaš SMTP host autentikaciju?',
        'SMTP auth user' => 'SMTP korisnik',
        'Username for SMTP auth.' => 'korisničko ime za SMTP autentikaciju',
        'SMTP auth password' => 'SMTP lozinka',
        'Password for SMTP auth.' => 'Lozinka za SMTP autentikaciju',
        'Configure Inbound Mail' => 'Podestavljanje dolazne E-pošte',
        'Inbound mail type' => 'Tip dolazne E-pošte',
        'Select inbound mail type.' => 'Izaberi tip dolazne E-pošte',
        'Inbound mail host' => 'Server dolazne E-pošte',
        'Inbound mail host.' => 'Server dolazne E-pošte.',
        'Inbound mail user' => 'Korisnik dolazne E-pošte',
        'User for inbound mail.' => 'Korisnik dolazne E-pošte',
        'Inbound mail password' => 'Lozinka dolazne E-pošte',
        'Password for inbound mail.' => 'Lozinka dolazne E-pošte',
        'Result of mail configuration check' => 'Rezultat provjere postavki E-pošte',
        'Check mail configuration' => 'Provjeri konfiguracijske postavke E-pošte',
        'Skip this step' => 'Preskoči ovaj korak',

        # Template: InstallerDBResult
        'Database setup successful!' => '',

        # Template: InstallerDBStart
        'Install Type' => '',
        'Create a new database for OTRS' => '',
        'Use an existing database for OTRS' => '',

        # Template: InstallerDBmssql
        'Database name' => '',
        'Check database settings' => 'Provjerite postavke baze podataka',
        'Result of database check' => 'Rezultat provjere baze podataka',
        'Database check successful.' => 'Uspješna provjera baze podataka.',
        'Database User' => '',
        'New' => 'Novi',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'Novi korisnik baze sa ograničenim pravima bit će  kreiran za ovaj OTRS sustav',
        'Repeat Password' => '',
        'Generated password' => '',

        # Template: InstallerDBmysql
        'Passwords do not match' => '',

        # Template: InstallerDBoracle
        'SID' => '',
        'Port' => '',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'Da biste mogli koristiti OTRS morate unijeti slijedeću liniju u Vašu komandnu liniju (Terminal/Shell) kao "root".',
        'Restart your webserver' => 'Ponovo pokrenite Vaš WEB Server.',
        'After doing so your OTRS is up and running.' => 'Nakon ovoga Vaš OTRS je uključen i radi.',
        'Start page' => 'Početna stranica',
        'Your OTRS Team' => 'Vaš OTRS Tim',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Ne prihvaćaj licencu',
        'Accept license and continue' => 'Prihvati licencu i nastavi',

        # Template: InstallerSystem
        'SystemID' => ' ',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identifikator sustava. Svaki broj kartice i svaki ID HTTP sesije sadrži ovaj broj.',
        'System FQDN' => 'Puno ime domene sustava',
        'Fully qualified domain name of your system.' => 'FQDN - ime servera uključujući puno ime domena, npr. "otrs-server.example.org"',
        'AdminEmail' => 'E-mail administrator',
        'Email address of the system administrator.' => 'E-mail adresa administratora sustava.',
        'Organization' => 'Organizacija',
        'Log' => 'Dnevnik',
        'LogModule' => 'Modul dnevnika',
        'Log backend to use.' => 'Sustav koji se koristi za dnevnik.',
        'LogFile' => 'Datoteka dnevnika',
        'Webfrontend' => 'Mrežno sučelje',
        'Default language' => 'Zadani jezik',
        'Default language.' => 'Zadani jezik.',
        'CheckMXRecord' => 'Provjeri DNS/MX podatke',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Ručno unesena e-mail adresa se provjerava pomoću MX podatka pronađenog u DNS-u. Nemojte koristiti ovu opciju ako je vaš DNS spor ili ne može razriješiti javne adrese.',

        # Template: LinkObject
        'Object#' => 'Objekt#',
        'Add links' => 'Dodaj veze',
        'Delete links' => 'Obriši veze',

        # Template: Login
        'Lost your password?' => 'Izgubili ste lozinku?',
        'Request New Password' => 'Zahtjev za novu lozinku',
        'Back to login' => 'Natrag na prijavu',

        # Template: MobileNotAvailableWidget
        'Feature not available' => '',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            '',

        # Template: Motd
        'Message of the Day' => 'Poruka dana',

        # Template: NoPermission
        'Insufficient Rights' => 'Nedovoljna ovlaštenja',
        'Back to the previous page' => 'Vratite se na prethodnu stranicu',

        # Template: Pagination
        'Show first page' => 'Pokaži prvu stranicu',
        'Show previous pages' => 'Pokaži prethodne stranice',
        'Show page %s' => 'Pokaži stranicu %s',
        'Show next pages' => 'Pokaži slijedeće stranice',
        'Show last page' => 'Pokaži posljednju stranicu',

        # Template: PictureUpload
        'Need FormID!' => 'Potreban ID formulara!',
        'No file found!' => 'Datoteka nije pronađena!',
        'The file is not an image that can be shown inline!' => 'Datoteka nije slika koja se može neposredno prikazati!',

        # Template: PreferencesNotificationEvent
        'Notification' => 'Obavijest',
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',

        # Template: PublicDefault
        'Welcome' => '',

        # Template: Test
        'OTRS Test Page' => 'OTRS test stranica',
        'Welcome %s %s' => '',
        'Counter' => 'Brojač',

        # Template: Warning
        'Go back to the previous page' => 'Vratite se na prethodnu stranicu',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'Nova telefonska kartica',
        'New email ticket' => 'Nova kartica E-pošte',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Currently' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'Web service "%s" updated!' => '',
        'Web service "%s" created!' => '',
        'Web service "%s" deleted!' => '',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Agent who owns the ticket' => '',
        'Agent who is responsible for the ticket' => '',
        'All agents watching the ticket' => '',
        'All agents with write permission for the ticket' => '',
        'All agents subscribed to the ticket\'s queue' => '',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer of the ticket' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Package not verified due a communication issue with verification server!' =>
            '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'Statistic' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Can not delete link with %s!' => '',
        'Can not create link with %s!' => '',
        'Object already linked as %s.' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Statistic could not be imported.' => '',
        'Please upload a valid statistic file.' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No subject' => '',
        'Previous Owner' => 'Prethodni vlasnik',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Ticket is locked by another agent and will be ignored!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'printed by' => 'otisnuo',
        'Ticket Dynamic Fields' => '',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Pending Date' => 'Datum čekanja',
        'for pending* states' => 'za stanja čekanja',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Invalid Users' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. ' =>
            '',
        'Fields with no group' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            '',

        # Perl Module: Kernel/Modules/Installer.pm
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            '',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'This ticket has no title or subject' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/UserOnline.pm
        'This user is currently offline' => '',
        'This user is currently active' => '',
        'This user is currently away' => '',
        'This user is currently unavailable' => '',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            '',
        ' You can take one of the next actions:' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => '',

        # Perl Module: Kernel/Output/HTML/Notification/DaemonCheck.pm
        'Please contact your administrator!' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => '',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'X-axis' => 'X-os',
        'Y-axis' => '',
        'The selected start time is before the allowed start time.' => '',
        'The selected end time is later than the allowed end time.' => '',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'The selected time upcoming period is larger than the allowed time upcoming period.' =>
            '',
        'The selected time scale is smaller than the allowed time scale.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => '',
        'The selected end time is before the start time.' => '',
        'There is something wrong with your time selection.' => '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Poredaj po',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => '',
        'Created Priority' => 'Otvoreno s prioritetom',
        'Created State' => 'Otvoreno sa statusom',
        'CustomerUserLogin' => 'Prijava korisnika',
        'Create Time' => 'Vrijeme otvaranja',
        'Close Time' => 'Vrijeme zatvaranja',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Operater/Vlasnik',
        'Created by Agent/Owner' => 'Otvorio Operater/Vlasnik',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Procijenio',
        'Ticket/Article Accounted Time' => 'Obračunato vrijeme',
        'Ticket Create Time' => 'Vrijeme otvaranja kartice',
        'Ticket Close Time' => 'Vrijeme zatvaranja kartice',
        'Accounted time by Agent' => 'Obračunato vrijeme po operateru',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'Attributes to be printed' => 'Atributi za tiskanje',
        'Sort sequence' => 'Redoslijed sortiranja',
        'State Historic' => '',
        'State Type Historic' => '',
        'Historic Time Range' => '',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tablica prisutnosti',
        'Internal Error: Could not open file.' => '',
        'Table Check' => '',
        'Internal Error: Could not read file.' => '',
        'Tables found which are not present in the database.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Veličina baze podataka',
        'Could not determine database size.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => '',
        'Could not determine database version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => '',
        'Setting character_set_client needs to be utf8.' => '',
        'Server Database Charset' => '',
        'Setting character_set_database needs to be UNICODE or UTF8.' => '',
        'Table Charset' => '',
        'There were tables found which do not have utf8 as charset.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => '',
        'The setting innodb_log_file_size must be at least 256 MB.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => '',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => '',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => '',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => '',
        'Setting server_encoding needs to be UNICODE or UTF8.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => '',
        'Setting DateStyle needs to be ISO.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => '',
        'The partition where OTRS is located is almost full.' => '',
        'The partition where OTRS is located has no disk space problems.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Operating System/Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => '',
        'Could not determine distribution.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => '',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => '',
        'Not all required Perl modules are correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => '',
        'No swap enabled.' => '',
        'Used Swap Space (MB)' => '',
        'There should be more than 60% free swap space.' => '',
        'There should be no more than 200 MB swap space used.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS/Config Settings' => '',
        'Could not determine value.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'OTRS' => '',
        'Daemon' => '',
        'Daemon is not running.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'OTRS/Database Records' => '',
        'Tickets' => 'Kartice',
        'Ticket History Entries' => '',
        'Articles' => '',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => '',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Months Between First And Last Ticket' => '',
        'Tickets Per Month (avg)' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ErrorLog.pm
        'Error Log' => '',
        'There are error reports in your system log.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => '',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => '',
        'Your FQDN setting is invalid.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => '',
        'The file system on your OTRS partition is not writable.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages are not correctly installed.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'OTRS/Package List' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'Open Tickets' => '',
        'You should not have more than 8,000 open tickets in your system.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run otrs/bin/otrs.CleanTicketIndex.pl to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'OTRS/Time Settings' => '',
        'Server time zone' => '',
        'Computed server time offset' => '',
        'OTRS TimeZone setting (global time offset)' => '',
        'TimeZone may only be activated for systems running in UTC.' => '',
        'OTRS TimeZoneUser setting (per-user time zone support)' => '',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            '',
        'OTRS TimeZone setting for calendar ' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver/Loaded Apache Modules' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'Webserver' => '',
        'MPM model' => '',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => '',
        'mod_filter Usage' => '',
        'Please install mod_filter if mod_deflate is used.' => '',
        'mod_headers Usage' => '',
        'Please install mod_headers to improve GUI speed.' => '',
        'Apache::Reload Usage' => '',
        'Apache::Reload or Apache2::Reload should be used as PerlModule and PerlInitHandler to prevent web server restarts when installing and upgrading modules.' =>
            '',
        'Apache2::DBI Usage' => '',
        'Apache2::DBI should be used to get a better performance  with pre-established database connections.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/EnvironmentVariables.pm
        'Webserver/Environment Variables' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/IIS/Performance.pm
        'You should use PerlEx to increase your performance.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => '',
        'Could not determine webserver version.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => 'Nepoznato',
        'OK' => 'U redu',
        'Problem' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Reset password unsuccessful. Please contact your administrator' =>
            '',
        'Panic! Invalid Session!!!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => '',
        'All new state types (default: viewable).' => '',
        'All open state types (default: viewable).' => '',
        'All closed state types (default: not viewable).' => '',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'All \'removed\' state types (default: not viewable).' => '',
        'State type for merged tickets (default: not viewable).' => '',
        'New ticket created by customer.' => '',
        'Ticket is closed successful.' => '',
        'Ticket is closed unsuccessful.' => '',
        'Open tickets.' => '',
        'Customer removed ticket.' => '',
        'Ticket is pending for agent reminder.' => '',
        'Ticket is pending for automatic close.' => '',
        'State for merged tickets.' => '',
        'system standard salutation (en)' => '',
        'Standard Salutation.' => '',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created..' =>
            '',
        'Postmaster queue.' => '',
        'All default incoming tickets.' => '',
        'All junk tickets.' => '',
        'All misc tickets.' => '',
        'Automatic reply which will be sent out after a new ticket has been created.' =>
            '',
        'Automatic reject which will be sent out after a follow-up has been rejected (in case queue follow-up option is "reject").' =>
            '',
        'Automatic confirmation which is sent out after a follow-up has been received for a ticket (in case queue follow-up option is "possible").' =>
            '',
        'Automatic response which will be sent out after a follow-up has been rejected and a new ticket has been created (in case queue follow-up option is "new ticket").' =>
            '',
        'Auto remove will be sent out after a customer removed the request.' =>
            '',
        'default reply (after new ticket has been created)' => '',
        'default reject (after follow-up and rejected of a closed ticket)' =>
            '',
        'default follow-up (after a ticket follow-up has been added)' => '',
        'default reject/new ticket created (after closed follow-up with new ticket creation)' =>
            '',
        'Unclassified' => '',
        'tmp_lock' => '',
        'email-notification-ext' => '',
        'email-notification-int' => '',
        'fax' => '',

        # SysConfig
        '
Dear Customer,

Unfortunately we could not detect a valid ticket number
in your subject, so this email can\'t be processed.

Please create a new ticket via the customer panel.

Thanks for your help!

 Your Helpdesk Team
' => '',
        ' (work units)' => '',
        '"%s" notification was sent to "%s" by "%s".' => '',
        '%s' => '%s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s vremenskih jedinica prebrojano. Ukupno %s vremenskih jedinica.',
        '(UserLogin) Firstname Lastname' => '',
        '(UserLogin) Lastname, Firstname' => '',
        'A Website' => '',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            '"ACL" modul koji dozvoljava da nadređene kartice budu zatvorene samo ako su već zatvorene sve podređene kartice ("Status" pokazuje koji statusi nisu dostupni za karticu roditelj dok se ne zatvore sve kartice djeca).',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Aktivira mehanizam treptanja retka koji sadrži najstariju karticu.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Aktivira opciju izgubljene lozinke za operatere, na sučelju operatera.',
        'Activates lost password feature for customers.' => 'Aktivira opciju izgubljene lozinke za korisnike.',
        'Activates support for customer groups.' => 'Aktivira podršku za korisničke grupe.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Aktivira filter za članke u proširenom pregledu radi definiranja koji članci trebaju biti prikazani.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Aktivira raspoložive teme. Vrijednost 1 znači aktivno, 0 znači neaktivno.',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Aktivira arhivski sustav radi ubrzanja rada, uklanjanjem nekih kartica iz dnevnog praćenja. Za pronalazak kartica, označena arhiva mora biti omogućena za pretragu kartica.',
        'Activates time accounting.' => 'Aktivira mjerenje vremena.',
        'ActivityID' => '',
        'Add an inbound phone call to this ticket' => '',
        'Add an outbound phone call to this ticket' => '',
        'Added email. %s' => '"E-pošta poslana korisniku. %s"',
        'Added link to ticket "%s".' => 'Poveza na karticu "%s" postavljena.',
        'Added note (%s)' => 'Dodata napomena (%s)',
        'Added subscription for user "%s".' => 'Pretplata za korisnika "%s" uključena.',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            '',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Jednokratno dodaje neradne dane. Molimo Vas da koristite jednoznamenkasti broj od 1 do 9 (umjesto 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Trajno dodaje neradne dane. Molimo Vas da koristite jednoznamenkasti broj od 1 do 9 (umjesto 01 - 09).',
        'After' => '',
        'Agent called customer.' => '"Operaterov telefonski poziv."',
        'Agent interface article notification module to check PGP.' => 'Modul sučelja operatera za obavještavanja o članku, provjera PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Modul sučelja operatera za obavještavanja o članku, provjera S/MIME',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Modul sučelja operatera za pristup tekstualnom pretraživanju preko navigacijske trake.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Modul sučelja zaposlenih za pristup profilima pretraživanja preko navigacijske trake.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Modul sučelja operatera za provjeru dolaznih poruka u uvećanom pregledu kartice ako "S/MIME"-ključ postoji i dostupan je.',
        'Agent interface notification module to see the number of locked tickets.' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Modul sučelja operatera za obvještavanje, pregled broja kartice za koje je agent odgovoran.',
        'Agent interface notification module to see the number of tickets in My Services.' =>
            '',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Modul sučelja operatera za obvještavanje, pregled broja praćenih kartica.',
        'Agents <-> Groups' => 'Operateri <-> Grupe',
        'Agents <-> Roles' => 'Operateri <-> Uloge',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket free text screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket note screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows adding notes in the ticket responsible screen of the agent interface. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Dozvoljava operaterima da zamjene osi na pokrenutoj statistici.',
        'Allows agents to generate individual-related stats.' => 'Dozvoljava operaterima da pokrenu individualnu statistiku.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Dozvoljava izbor između prikaza priloga u pregledniku ili samo omogućava njihovo preuzimanje.',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Dozvoljava izbor slijedećeg stanja za korisničku karticu u korisničkom sučelju.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Dozvoljava korisnicima da promjene prioritet kartice u korisničkom sučelju.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Dozvoljava korisnicima da postave SLA za karticu u korisničkom sučelju.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Dozvoljava korisnicima da postave prioritet kartice u korisničkom sučelju.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Dozvoljava korisnicima da postave red kartice u korisničkom sučelju. Ako je postavljeno na "Ne", onda treba postaviti "QueueDefault".',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Dozvoljava korisnicima da postave servis za karticu u korisničkom sučelju.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Dozvoljava definiranje novog tipa kartice (ako je opcije tipa kartice aktivirana).',
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
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Archive state changed: "%s"' => '',
        'ArticleTree' => '',
        'Attachments <-> Templates' => '',
        'Auto Responses <-> Queues' => 'Automatski odgovori <-> Redovi',
        'AutoFollowUp sent to "%s".' => 'Automatski nastavak poslan za "%s".',
        'AutoReject sent to "%s".' => 'Automatski odbačeno poslano "%s".',
        'AutoReply sent to "%s".' => 'Poslat automatski odgovor za "%s".',
        'Automated line break in text messages after x number of chars.' =>
            'Automatski kraj retka u tekstualnim porukama nakon simbola "x".',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automatsko zaključavanje i postavljanje vlasnika na aktualnog operatera nakon izbora masovne akcije.',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => 'Balansirani bijeli izgled, Felix Niklas.',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'Odbijena poruka "%s".',
        'Builds an article index right after the article\'s creation.' =>
            'Generira indeks članaka odmah po kreiranju članka.',
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
        'Change password' => 'Promjena lozinke',
        'Change queue!' => 'Promjena reda!',
        'Change the customer for this ticket' => '',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => '',
        'Change the responsible for this ticket' => '',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Promjenjen prioritet sa "%s" (%s) na "%s" (%s).',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            '',
        'Closed tickets (customer user)' => '',
        'Closed tickets (customer)' => '',
        'Cloud Services' => '',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => '',
        'Columns that can be filtered in the escalation view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the locked view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the queue view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the responsible view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the service view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the status view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the ticket search result view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Columns that can be filtered in the watch view of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note: Only Ticket attributes, Dynamic Fields (DynamicField_NameX) and Customer attributes (e.g. CustomerUserPhone, CustomerCompanyName, ...) are allowed.' =>
            '',
        'Comment for new history entries in the customer interface.' => 'Komentar za nove povjesne unose u korisničkom sučelju.',
        'Comment2' => '',
        'Communication' => '',
        'Company Status' => '',
        'Company Tickets' => 'Kartice tvrtke',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => '',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            '',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Kontrolira da li korisnici imaju mogućnost sortiranja svojih kartica.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Pretvara HTML poruke u tekstualne poruke.',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Kreira i upravlja sa SLA.',
        'Create and manage agents.' => 'Kreiranje i upravljanje zaposlenima.',
        'Create and manage attachments.' => 'Kreiranje i upravljanje prilozima.',
        'Create and manage customer users.' => '',
        'Create and manage customers.' => 'Kreiranje i upravljanje korisnicima.',
        'Create and manage dynamic fields.' => '',
        'Create and manage groups.' => 'Kreiranje i upravljanje grupama.',
        'Create and manage queues.' => 'Kreiranje i upravljanje redovima.',
        'Create and manage responses that are automatically sent.' => 'Kreiranje i upravljanje automatskim odgovorima.',
        'Create and manage roles.' => 'Kreiranje i upravljanje ulogama.',
        'Create and manage salutations.' => 'Kreiranje i upravljanje pozdravima.',
        'Create and manage services.' => 'Kreiranje i upravljanje uslugama.',
        'Create and manage signatures.' => 'Kreiranje i upravljanje potpisima.',
        'Create and manage templates.' => '',
        'Create and manage ticket notifications.' => '',
        'Create and manage ticket priorities.' => 'Kreiranje i upravljanje prioritetima kartice.',
        'Create and manage ticket states.' => 'Kreiranje i upravljanje statusima kartice.',
        'Create and manage ticket types.' => 'Kreiranje i upravljanje tipovima kartice.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'Otvori novu e-mail karticu i pošalji ovo (odlazni)',
        'Create new phone ticket (inbound)' => 'Kreiraj novu telefonsku karticu (dolazni poziv)',
        'Create new process ticket' => '',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => '',
        'Customer User <-> Groups' => '',
        'Customer User <-> Services' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Korisnici',
        'Customer called us.' => 'Korisnički telefonski poziv.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer request via web.' => 'Korisnički Web zahtjev.',
        'Customer user search' => '',
        'CustomerID search' => '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Korisici <-> Grupe',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Data used to export the search result in CSV format.' => 'Podaci upotrebljeni za izvoz rezultata pretraživanja u "CSV" formatu.',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => 'Zadani ACL vrijednosti za akcije kartice.',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default display type for recipient (To,Cc) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default display type for sender (From) names in AgentTicketZoom and CustomerTicketZoom.' =>
            '',
        'Default loop protection module.' => 'Zadani modul zaštite od petlje',
        'Default queue ID used by the system in the agent interface.' => 'Zadani ID repa koji koristi sustav u sučelju zaposlenika.',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            'Zadani ID kartice koji koristi sustav u sučelju operatera.',
        'Default ticket ID used by the system in the customer interface.' =>
            'Zadani ID kartice koji koristi sustav u korisničkom sučelju.',
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
        'Define the queue comment 2.' => '',
        'Define the service comment 2.' => '',
        'Define the sla comment 2.' => '',
        'Define the start day of the week for the date picker for the indicated calendar.' =>
            '',
        'Define the start day of the week for the date picker.' => 'Odredi prvi dan u nedjelji za izbor datuma.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definira korisnikovu stavku, koja generira ikonu LinkedIn na kraju korisnikovog info bloka.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definira korisnikovu stavku, koja generira ikonu XING na kraju korisnikovog info bloka.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definira korisnikovu stavku, koja generira ikonu google na kraju korisnikovog info bloka.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definira korisnikovu stavku, koja generira ikonu google karti na kraju korisnikovog info bloka.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Definira zadani popis riječi, koje su zanemarene provjerom pravopisa.',
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
        'Defines a sleep time in microseconds between tickets while they are been processed by a job.' =>
            '',
        'Defines a useful module to load specific user options or to display news.' =>
            '',
        'Defines all the X-headers that should be scanned.' => 'Određuje sva X-zaglavlja koja treba skenirati.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://otrs.github.io/doc/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Određuje sve parametre za ovu stavku u korisničkim podešavanjima.',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => 'Određuje sve moguće izlazne formate statistike.',
        'Defines an alternate URL, where the login link refers to.' => 'Određuje alternativni URL, na koji veza za prijavu pokazuje.',
        'Defines an alternate URL, where the logout link refers to.' => 'Određuje alternativni URL, na koji veza za odjavu pokazuje.',
        'Defines an alternate login URL for the customer panel..' => 'Određuje alternativni URL prijave za korisnički panel.',
        'Defines an alternate logout URL for the customer panel.' => 'Određuje alternativni URL odjave za korisnički panel.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=[% Data.CustomerID %]\' or \'\').' =>
            '',
        'Defines from which ticket attributes the agent can select the result order.' =>
            '',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a pre-sorting by priority should be done in the service view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the email outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
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
        'Defines if agents should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Određuje da li porukama napisanim u interfejsu zaposlenih treba uraditi proveru pravopisa.',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the list for filters should be retrieve just from current tickets in system. Just for clarification, Customers list will always came from system\'s tickets.' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => 'Određuje "URL CSS" putanju.',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Određuje URL osnovnu stazu za statični web sadržaj (ikone, CSS, JS).',
        'Defines the URL image path of icons for navigation.' => 'Određuje URL putanju do slika za navigacione ikone.',
        'Defines the URL java script path.' => 'Određuje URL putanju java skriptova.',
        'Defines the URL rich text editor path.' => 'Određuje URL putanju do aplikacije za uređivanje "RTF" datoteka',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            '',
        'Defines the agent preferences key where the shared secret key is stored.' =>
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
        'Defines the body text for rejected emails.' => 'Određuje telo teksta za odbačene poruke.',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            '',
        'Defines the column to store the keys for the preferences table.' =>
            'Određuje kolonu za čuvanje ključeva tabele podešavanja.',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => 'Određuje konekcije za "http/ftp" preko posrednika.',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            'Određuje format unosa datuma u formulare (opcija za polja za unos).',
        'Defines the default CSS used in rich text editors.' => 'Određuje zadani CSS upotrebljen u "RTF" uređivanju.',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. If you like, you can add your own theme. Please refer the administrator manual located at http://otrs.github.io/doc/.' =>
            '',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            '',
        'Defines the default history type in the customer interface.' => '',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            '',
        'Defines the default maximum number of statistics per page on the overview screen.' =>
            '',
        'Defines the default next state for a ticket after customer follow-up in the customer interface.' =>
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
        'Defines the default next state of a ticket after the message has been sent, in the email outbound screen of the agent interface.' =>
            '',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default priority of follow-up customer tickets in the ticket zoom screen in the customer interface.' =>
            '',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Određuje zadani prioritet za nove korisničke karticue u korisničkom interfejsu.',
        'Defines the default priority of new tickets.' => 'Određuje zadani prioritet za nove karticue.',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Određuje zadani red za nove korisničke karticue u korisničkom interfejsu.',
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
        'Defines the default sort criteria for all services displayed in the service view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            '',
        'Defines the default sort order for all services in the service view, after priority sort.' =>
            '',
        'Defines the default spell checker dictionary.' => 'Određuje zadani rječnik za provjeru pravopisa.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => 'Određuje zadani status novih kartice.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
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
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
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
        'Defines the default ticket order in the ticket search result of the this operation. Up: oldest on top. Down: latest on top.' =>
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
        'Defines the default type of the message in the email outbound screen of the agent interface.' =>
            '',
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
        'Defines the fall-back path to open fetchmail binary. Note: The name of the binary needs to be \'fetchmail\', if it is different please use a symbolic link.' =>
            '',
        'Defines the filter that processes the text in the articles, in order to highlight URLs.' =>
            '',
        'Defines the format of responses in the ticket compose screen of the agent interface ([% Data.OrigFrom | html %] is From 1:1, [% Data.OrigFromName | html %] is only realname of From).' =>
            '',
        'Defines the fully qualified domain name of the system. This setting is used as a variable, OTRS_CONFIG_FQDN which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the groups every customer user will be in (if CustomerGroupSupport is enabled and you don\'t want to manage every user for these groups).' =>
            '',
        'Defines the height for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the height for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
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
        'Defines the hours and week days to count the working time.' => 'Određuje sate i dane u tjednu radi kalkulacija radnog vremena.',
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
        'Defines the list of possible next actions on an error screen.' =>
            '',
        'Defines the list of types for templates.' => '',
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser. Warning: Setting this option to a value which is too low could cause many masks in your OTRS instance to stop working (probably any mask which takes input from the user).' =>
            '',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Određuje maksimalno vrijeme važenja (u sekundama) za ID sesije.',
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => 'Određuje maksimalni broj strana po "PDF" datoteci.',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => 'Određuje maksimalnu veličinu datoteke dnevnika (u megabajtima).',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
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
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the system is used by the admin user (normally you shouldn\'t work as admin).' =>
            '',
        'Defines the module to generate code for periodic page reloads.' =>
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
        'Defines the name of the key for customer sessions.' => 'Određuje naziv ključa za korisničke sesije.',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            '',
        'Defines the next possible states after composing / answering a ticket in the ticket compose screen of the agent interface.' =>
            '',
        'Defines the next possible states after forwarding a ticket in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the next possible states after sending a message in the email outbound screen of the agent interface.' =>
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
        'Defines the number of character per line used in case an HTML article preview replacement on TemplateGenerator for EventNotifications.' =>
            '',
        'Defines the number of header fields in frontend modules for add and update postmaster filters. It can be up to 99 fields.' =>
            '',
        'Defines the parameters for the customer preferences table.' => '',
        'Defines the parameters for the dashboard backend. "Cmd" is used to specify command with parameters. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTL" indicates the cache expiration period in minutes for the plugin.' =>
            '',
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
        'Defines the path of the shown info file, that is located under Kernel/Output/HTML/Templates/Standard/CustomerAccept.tt.' =>
            '',
        'Defines the path to PGP binary.' => '',
        'Defines the path to open ssl binary. It may need a HOME env ($ENV{HOME} = \'/var/lib/wwwrun\';).' =>
            '',
        'Defines the postmaster default queue.' => '',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the receipent target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the receipent target of the tickets ("Queue" shows all queues, "SystemAddress" displays all system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
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
        'Defines the time zone of the indicated calendar, which can be assigned later to a specific queue.' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => 'Određuje identifikator korisnika za korisnički panel.',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => 'Određuje važeće tipove statusa za karticu.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. Default: unlock, tmp_lock.' =>
            '',
        'Defines the width for the rich text editor component for this screen. Enter number (pixels) or percent value (relative).' =>
            '',
        'Defines the width for the rich text editor component. Enter number (pixels) or percent value (relative).' =>
            '',
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
        'Defines, which tickets of which ticket state types should not be listed in linked ticket lists.' =>
            '',
        'Delete expired cache from core modules.' => '',
        'Delete expired loader cache weekly (Sunday mornings).' => '',
        'Delete expired sessions.' => '',
        'Deleted link to ticket "%s".' => 'Veza na "%s" uklonjena.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Deploy and manage OTRS Business Solution™.' => '',
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
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
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
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE8.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
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
        'Dynamic fields shown in the email outbound screen of the agent interface. Possible settings: 0 = Disabled, 1 = Enabled, 2 = Enabled and required.' =>
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
        'Dynamic fields shown in the ticket small format overview screen of the agent interface. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Dynamic fields shown in the ticket zoom screen of the customer interface. Possible settings: 0 = Disabled, 1 = Enabled.' =>
            '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'Edit customer company' => '',
        'Email Addresses' => 'Adrese E-pošte',
        'Email sent to "%s".' => 'Poruka E-pošte poslana "%s".',
        'Email sent to customer.' => '"E-pošta poslana zaposleniku."',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => '',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Omogućava "S/MIME" podršku.',
        'Enables customers to create their own accounts.' => 'Omogućava korisnicima da kreiraju sopstvene naloge.',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Omogućuje podršku za provjeru pravopisa.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Enroll process for this ticket' => '',
        'Enter your shared secret to enable two factor authentication.' =>
            '',
        'Escalation response time finished' => '',
        'Escalation response time forewarned' => '',
        'Escalation response time in effect' => '',
        'Escalation solution time finished' => '',
        'Escalation solution time forewarned' => '',
        'Escalation solution time in effect' => '',
        'Escalation update time finished' => '',
        'Escalation update time forewarned' => '',
        'Escalation update time in effect' => '',
        'Escalation view' => 'Pregled eskalacija',
        'EscalationTime' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer user service membership if login changes.' =>
            '',
        'Event module that updates customer users after an update of the Customer.' =>
            '',
        'Event module that updates tickets after an update of the Customer User.' =>
            '',
        'Event module that updates tickets after an update of the Customer.' =>
            '',
        'Events Ticket Calendar' => '',
        'Execute SQL statements.' => 'Izvrši SQL naredbe.',
        'Executes a custom command or module. Note: if module is used, function is required.' =>
            '',
        'Executes follow-up checks on In-Reply-To or References headers for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on attachment contents for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on email body for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Executes follow-up checks on the raw source email for mails that don\'t have a ticket number in the subject.' =>
            '',
        'Exports the whole article tree in search result (it can affect the system performance).' =>
            '',
        'Fetch emails via fetchmail (using SSL).' => '',
        'Fetch emails via fetchmail.' => '',
        'Fetch incoming emails from configured mail accounts.' => '',
        'Fetches packages via proxy. Overwrites "WebUserAgent::Proxy".' =>
            '',
        'File that is displayed in the Kernel::Modules::AgentInfo module, if located under Kernel/Output/HTML/Templates/Standard/AgentInfo.tt.' =>
            '',
        'Filter for debugging ACLs. Note: More ticket attributes can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter for debugging Transitions. Note: More filters can be added in the format <OTRS_TICKET_Attribute> e.g. <OTRS_TICKET_Priority>.' =>
            '',
        'Filter incoming emails.' => 'Filtriranje dolaznih poruka.',
        'First Queue' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => '',
        'Firstname Lastname (UserLogin)' => '',
        'FollowUp for [%s]. %s' => 'Slijedi za [%s]. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'Proslijeđena poruka "%s".',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend module registration (disable AgentTicketService link if Ticket Serivice feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => '',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => '',
        'GenericAgent' => '',
        'GenericInterface Debugger GUI' => '',
        'GenericInterface Invoker GUI' => '',
        'GenericInterface Operation GUI' => '',
        'GenericInterface TransportHTTPREST GUI' => '',
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
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Go back' => 'Vrati se natrag',
        'Google Authenticator' => '',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
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
        'If active, none of the regular expressions may match the user\'s email address to allow registration.' =>
            '',
        'If active, one of the regular expressions has to match the user\'s email address to allow registration.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, a password must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            '',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            '',
        'If enabled debugging information for ACLs is logged.' => '',
        'If enabled debugging information for transitions is logged.' => '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
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
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Jezik sučelja',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'JavaScript function for the search frontend.' => '',
        'Lastname, Firstname' => '',
        'Lastname, Firstname (UserLogin)' => '',
        'Left' => '',
        'Link agents to groups.' => 'Poveži operatere s gupama.',
        'Link agents to roles.' => 'Poveži operatere s ulogama.',
        'Link attachments to templates.' => '',
        'Link customer user to groups.' => '',
        'Link customer user to services.' => '',
        'Link queues to auto responses.' => 'Poveži redove s automatskim odgovorima.',
        'Link roles to groups.' => 'Poveži uloge sa grupama.',
        'Link templates to queues.' => '',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of all CustomerCompany events to be displayed in the GUI.' =>
            '',
        'List of all CustomerUser events to be displayed in the GUI.' => '',
        'List of all DynamicField events to be displayed in the GUI.' => '',
        'List of all Package events to be displayed in the GUI.' => '',
        'List of all article events to be displayed in the GUI.' => '',
        'List of all queue events to be displayed in the GUI.' => '',
        'List of all ticket events to be displayed in the GUI.' => '',
        'List of default Standard Templates which are assigned automatically to new Queues upon creation.' =>
            '',
        'List of responsive CSS files to always be loaded for the agent interface.' =>
            '',
        'List of responsive CSS files to always be loaded for the customer interface.' =>
            '',
        'List view' => '',
        'Lock / unlock this ticket' => '',
        'Locked ticket.' => 'Kartica zaključana.',
        'Log file for the ticket counter.' => 'Datoteka dnevnika za brojač kartice.',
        'Loop-Protection! No auto-response sent to "%s".' => 'Zaštita od petlje! Automatski odgovor nije poslan na "%s".',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => '',
        'Manage POP3 or IMAP accounts to fetch email from.' => '',
        'Manage S/MIME certificates for email encryption.' => '',
        'Manage existing sessions.' => 'Upravljanje postojećim sesijama.',
        'Manage support data.' => '',
        'Manage system registration.' => '',
        'Manage tasks triggered by event or time based execution.' => '',
        'Mark this ticket as junk!' => '',
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
        'Merge this ticket and all articles into a another ticket' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => '',
        'Miscellaneous' => '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => 'Modul za provjeru korisničkih dozvola.',
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
        'My Services' => '',
        'My Tickets' => 'Moje kartice',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Nova kartica [%s] otvorena (Q=%s;P=%s;S=%s).',
        'New Window' => '',
        'New owner is "%s" (ID=%s).' => 'Novi vlasnik je "%s" (ID=%s).',
        'New process ticket' => '',
        'New responsible is "%s" (ID=%s).' => 'Novi odgovorni je "%s" (ID=%s).',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'None' => '',
        'Notification sent to "%s".' => 'Obavijest poslana k "%s".',
        'Number of displayed tickets' => 'Broj prikazanih kartica',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'Staro: "%s" Novo: "%s"',
        'Online' => '',
        'Open tickets (customer user)' => '',
        'Open tickets (customer)' => '',
        'Out Of Office' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Pregled eskaliralih kartice',
        'Overview Refresh Time' => '',
        'Overview of all open Tickets.' => 'Pregled svih otvorenih kartica.',
        'PGP Key Management' => 'Upravljanje PGP ključevima',
        'PGP Key Upload' => 'Slanje "PGP" ključa',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for .' => 'Parametri za',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
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
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
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
        'People' => '',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => 'Dozvoljena širina prozora za pisanje poruke.',
        'Permitted width for compose note windows.' => 'Dozvoljena širina prozora za pisanje napomene.',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'PostMaster filtri',
        'PostMaster Mail Accounts' => 'PostMaster računi E-pošte',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process pending tickets.' => '',
        'ProcessID' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Pregled reda',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => 'Interval osvježavanja',
        'Removed subscription for user "%s".' => 'Pretplata za korisnika "%s" isključena.',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            'Zamjenjuje originalnog pošiljatelja adresom E-pošte trenutnog korisnika pri kreiranju odgovora u prozoru za pisanje odgovora sučelja operatera.',
        'Reports' => '',
        'Reports (OTRS Business Solution™)' => '',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Potrebne dozvole za promenu korisnika kartice u interfejsu operatera.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za zatvaranje kartice u interfejsu operatera.',
        'Required permissions to use the email outbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za odbijanje kartice u sučelju operatera.',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za otvaranje kartice u sučelju operatera.',
        'Required permissions to use the ticket forward screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za prosleđivanje kartice u sučelju zaposlenog.',
        'Required permissions to use the ticket free text screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora slobodnog teksta kartice u sučelju operatera.',
        'Required permissions to use the ticket merge screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za spajanje pri uvećanom prikazu kartice u interfejsu operatera.',
        'Required permissions to use the ticket note screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora za napomene kartice u sučelju operatera.',
        'Required permissions to use the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora vlasnika tuketa pri uvećanom prikazu kartice u interfejsu operatera.',
        'Required permissions to use the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora čekanja pri uvećanom prikazu kartice u interfejsu operatera.',
        'Required permissions to use the ticket phone inbound screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket phone outbound screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora telefonskog odlaznog kartice u sučelju operatera.',
        'Required permissions to use the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora prioriteta pri uvećanom prikazu kartice u sučelju operatera.',
        'Required permissions to use the ticket responsible screen in the agent interface.' =>
            'Potrebne dozvole za upotrebu prozora odgovornog za karticu u sučelju operatera.',
        'Resets and unlocks the owner of a ticket if it was moved to another queue.' =>
            'Resetuje i otključava vlasnika kartice ako je premešten u drugi red.',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Restaurira karticu iz arhive (samo ako je događaj promena statusa od zatvorenog na bilo koji dostupan otvoreni status).',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => '',
        'Roles <-> Groups' => 'Uloge <-> Grupe',
        'Run file based generic agent jobs (Note: module name need needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Slanje "S/MIME" certifikata',
        'SMS' => '',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => '',
        'Screen' => '',
        'Search Customer' => 'Traži korisnika',
        'Search User' => '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Second Queue' => '',
        'Select your frontend Theme.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send new outgoing mail from this ticket' => '',
        'Send notifications to users.' => 'Pošalji obavijesti korisnicima.',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            '',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Service view' => '',
        'Set minimum loglevel. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages.' =>
            '',
        'Set sender email addresses for this system.' => 'Sistemska adresa pošiljatelja.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if SLA must be selected by the agent.' => '',
        'Sets if SLA must be selected by the customer.' => '',
        'Sets if note must be filled in by the agent. Can be overwritten by Ticket::Frontend::NeedAccountedTime.' =>
            '',
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
        'Sets the default error message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default link type of splitted tickets in the agent interface.' =>
            '',
        'Sets the default message for the login screen on Agent and Customer interface, it\'s shown when a running system maintenance period is active.' =>
            '',
        'Sets the default message for the notification is shown on a running system maintenance period.' =>
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
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionActiveTime.' =>
            '',
        'Sets the minimal ticket counter size (if "AutoIncrement" was selected as TicketNumberGenerator). Default is 5, this means the counter starts from 10000.' =>
            '',
        'Sets the minutes a notification is shown for notice about upcoming system maintenance period.' =>
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Shared Secret' => '',
        'Should the cache data be help in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => '',
        'Shows a count of icons in the ticket zoom, if the article has attachments.' =>
            '',
        'Shows a link in the menu for subscribing / unsubscribing from a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows linking a ticket with another object in the ticket zoom view of the agent interface.  Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu that allows merging tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to access the history of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a free text field in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to add a note to a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to close a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to delete a ticket in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to delete a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to enroll a ticket into a process in the ticket zoom view of the agent interface.' =>
            '',
        'Shows a link in the menu to go back in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to lock / unlock a ticket in the ticket overviews of the agent interface.' =>
            '',
        'Shows a link in the menu to lock/unlock tickets in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to move a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to print a ticket or an article in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the customer who requested the ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the history of a ticket in every ticket overview of the agent interface.' =>
            '',
        'Shows a link in the menu to see the owner of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the priority of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to see the responsible agent of a ticket in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to send an outbound email in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows a link to set a ticket as junk in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows all both ro and rw tickets in the service view.' => '',
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
        'Shows information on how to start OTRS Daemon' => '',
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
        'Skin' => 'Tema',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Specifies if an agent should receive email notification of his own actions.' =>
            '',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the default article type for the ticket compose screen in the agent interface if the article type cannot be automatically detected.' =>
            '',
        'Specifies the different article types that will be used in the system.' =>
            '',
        'Specifies the different note types that will be used in the system.' =>
            '',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            '',
        'Specifies the directory where SSL certificates are stored.' => '',
        'Specifies the directory where private SSL certificates are stored.' =>
            '',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address.' =>
            '',
        'Specifies the email addresses to get notification messages from scheduler tasks.' =>
            '',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notifications" otrs@your.example.com).' =>
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
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            '',
        'Specifies user id of the postmaster data base.' => '',
        'Specifies whether all storage backends should be checked when looking for attachements. This is only required for installations where some attachements are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Statistika br.',
        'Status view' => 'Pregled statusa',
        'Stores cookies after the browser has been closed.' => 'Čuva kolačiće nakon zatvaranja pretraživača.',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'System Maintenance' => '',
        'System Request (%s).' => 'Zahtjev sustava',
        'Templates <-> Queues' => '',
        'Textarea' => '',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The daemon registration for the scheduler cron task manager.' =>
            '',
        'The daemon registration for the scheduler future task manager.' =>
            '',
        'The daemon registration for the scheduler generic agent task manager.' =>
            '',
        'The daemon registration for the scheduler task worker.' => '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            '',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the latter case you should verify that the setting PostMaster::CheckFollowUpModule###0200-References is activated to recognize followups based on email headers.' =>
            '',
        'The headline shown in the customer interface.' => '',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "default". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "ivory-slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface for the skin "slim". See "AgentLogo" for further description.' =>
            '',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            '',
        'The maximal number of articles expanded on a single page in AgentTicketZoom.' =>
            '',
        'The maximal number of articles shown on a single page in AgentTicketZoom.' =>
            '',
        'The maximum number of mails fetched at once before reconnecting to the server.' =>
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
        'This will allow the system to send SMS messages.' => '',
        'Ticket Notifications' => '',
        'Ticket Queue Overview' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'premještaj kartice u rep "%s" (%s) iz repa "%s" (%s).',
        'Ticket notifications' => '',
        'Ticket overview' => 'Pregled kartice',
        'TicketNumber' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Transport selection for ticket notifications.' => '',
        'Tree view' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'kartica otključana.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            'Ažuriraj o?naku viđenih kartice ako su svi pregledani ili je kreiran novi članak.',
        'Update and extend your system with software packages.' => 'Ažuriraj i nadogradi sistem softverskim paketima.',
        'Updated SLA to %s (ID=%s).' => 'Ažuriran SLA "%s" (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Ažuriran servis "%s" (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Ažuriran tip "%s" (ID=%s).',
        'Updated: %s' => 'Ažurirano: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Ažurirano: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            'Ažuriraj indeks eskalacije kartice posle ažuriranja atributa kartice.',
        'Updates the ticket index accelerator.' => 'Ažuriraj akcelerator indeksa kartice.',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing ticket notification.' => '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Pregled rezultata provere performansi.',
        'View system log messages.' => 'Pregled poruka sistemskog dnevnika.',
        'Watch this ticket' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            'Kada su kartice spojeni, korisnik može biti informiran E-poštom postavljanjem polje za potvrdu "Obavijesti pošiljaoca". U prostoru za tekst, možete definirati unaprijed formatirani tekst koji kasnije biti modificiran od strane zaposlenika.',
        'Yes, but hide archived tickets' => '',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Izabrani favorizirani repovi. Ako je aktivirana, dobit ćete i obavijest o ovim repovima.',
        'Your service selection of your favorite services. You also get notified about those services via email if enabled.' =>
            '',

    };
    # $$STOP$$
    return;
}

1;
