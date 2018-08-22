# --
# Copyright (C) 2006 Thorsten Rossner <thorsten.rossner[at]stepstone.de>
# Copyright (C) 2007-2008 Mads N. Vestergaard <mnv[at]timmy.dk>
# Copyright (C) 2010 Lars Jørgensen <lajo[at]kb.dk>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
package Kernel::Language::da;

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
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';
    $Self->{Completeness}        = 0.538786173633441;

    # csv separator
    $Self->{Separator} = '';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Ja',
        'No' => 'Nej',
        'yes' => 'ja',
        'no' => 'nej',
        'Off' => 'Fra',
        'off' => 'fra',
        'On' => 'Til',
        'on' => 'til',
        'top' => 'start',
        'end' => 'slut',
        'Done' => 'Færdig',
        'Cancel' => 'Annuller',
        'Reset' => 'Nulstil',
        'more than ... ago' => 'mere end ... siden',
        'in more than ...' => 'mere end ...',
        'within the last ...' => 'indenfor de sidste ...',
        'within the next ...' => 'indenfor den næste ...',
        'Created within the last' => 'Oprettet indenfor de sidste',
        'Created more than ... ago' => 'Oprettet mere end ... siden',
        'Today' => 'I dag',
        'Tomorrow' => 'I morgen',
        'Next week' => 'Næste uge',
        'day' => 'dag',
        'days' => 'dage',
        'day(s)' => 'dag(e)',
        'd' => 'd',
        'hour' => 'time',
        'hours' => 'timer',
        'hour(s)' => 'time(r)',
        'Hours' => 'Timer',
        'h' => 't',
        'minute' => 'minut',
        'minutes' => 'minutter',
        'minute(s)' => 'minut(ter)',
        'Minutes' => 'Minutter',
        'm' => 'm',
        'month' => 'måned',
        'months' => 'måneder',
        'month(s)' => 'måned(er)',
        'week' => 'uge',
        'week(s)' => 'uge(r)',
        'quarter' => 'kvartal',
        'quarter(s)' => 'kvartal(er)',
        'half-year' => 'halvår',
        'half-year(s)' => 'halvår',
        'year' => 'år',
        'years' => 'år',
        'year(s)' => 'år',
        'second(s)' => 'sekund(er)',
        'seconds' => 'sekunder',
        'second' => 'sekund',
        's' => 's',
        'Time unit' => 'Tidsenhed',
        'wrote' => 'skrev',
        'Message' => 'Meddelelse',
        'Error' => 'Fejl',
        'Bug Report' => 'Fejlrapport',
        'Attention' => 'Bemærk',
        'Warning' => 'Advarsel',
        'Module' => 'Modul',
        'Modulefile' => 'Modulfil',
        'Subfunction' => 'Underfunktion',
        'Line' => 'Linje',
        'Setting' => 'Indstilling',
        'Settings' => 'Indstillinger',
        'Example' => 'Eksempel',
        'Examples' => 'Eksempler',
        'valid' => 'gyldig',
        'Valid' => 'Gyldig',
        'invalid' => 'ugyldig',
        'Invalid' => 'Ugyldig',
        '* invalid' => '* ugyldig',
        'invalid-temporarily' => 'ugyldig-midlertidigt',
        ' 2 minutes' => ' 2 minutter',
        ' 5 minutes' => ' 5 minutter',
        ' 7 minutes' => ' 7 minutter',
        '10 minutes' => '10 minutter',
        '15 minutes' => '15 minutter',
        'Mr.' => 'Hr.',
        'Mrs.' => 'Fru',
        'Next' => 'Næste',
        'Back' => 'Tilbage',
        'Next...' => 'Næste...',
        '...Back' => '...Tilbage',
        '-none-' => '-ingen-',
        'none' => 'ingen',
        'none!' => 'ingen!',
        'none - answered' => 'ingen - besvarede',
        'please do not edit!' => 'vær venlig ikke at redigere!',
        'Need Action' => 'Behøver handling',
        'AddLink' => 'TilføjLink',
        'Link' => 'Link',
        'Unlink' => 'Fjern link',
        'Linked' => 'Linket',
        'Link (Normal)' => 'Link (normal)',
        'Link (Parent)' => 'Link (forælder)',
        'Link (Child)' => 'Link (barn)',
        'Normal' => 'Normal',
        'Parent' => 'Forælder',
        'Child' => 'Barn',
        'Hit' => 'Resultat',
        'Hits' => 'Antal resultater',
        'Text' => 'Tekst',
        'Standard' => 'Standard',
        'Lite' => 'Let',
        'User' => 'Bruger',
        'Username' => 'Brugernavn',
        'Language' => 'Sprog',
        'Languages' => 'Sprog',
        'Password' => 'Adgangskode',
        'Preferences' => 'Indstillinger',
        'Salutation' => 'Indledning',
        'Salutations' => 'Indledninger',
        'Signature' => 'Signatur',
        'Signatures' => 'Signaturer',
        'Customer' => 'Kunde',
        'CustomerID' => 'Kunde-ID',
        'CustomerIDs' => 'Kunde-ID\'er',
        'customer' => 'kunde',
        'agent' => 'agent',
        'system' => 'system',
        'Customer Info' => 'Kundeinfo',
        'Customer Information' => 'Kundeoplysninger',
        'Customer Companies' => 'Kunde/Firmaer',
        'Company' => 'Firma',
        'go!' => 'kør',
        'go' => 'kør',
        'All' => 'Alle',
        'all' => 'alle',
        'Sorry' => 'Beklager',
        'update!' => 'opdater',
        'update' => 'opdater',
        'Update' => 'Opdater',
        'Updated!' => 'Opdateret',
        'submit!' => 'send',
        'submit' => 'send',
        'Submit' => 'Send',
        'change!' => 'skift',
        'Change' => 'Skift',
        'change' => 'skift',
        'click here' => 'klik her',
        'Comment' => 'Kommentar',
        'Invalid Option!' => 'Ugyldig valgmulighed!',
        'Invalid time!' => 'Ugyldigt tidsrum!',
        'Invalid date!' => 'Ugyldig dato!',
        'Name' => 'Navn',
        'Group' => 'Gruppe',
        'Description' => 'Beskrivelse',
        'description' => 'beskrivelse',
        'Theme' => 'Tema',
        'Created' => 'Oprettet',
        'Created by' => 'Oprettet af',
        'Changed' => 'ændret',
        'Changed by' => 'ændret af',
        'Search' => 'Søg',
        'and' => 'og',
        'between' => 'mellem',
        'before/after' => 'før/efter',
        'Fulltext Search' => 'Fritekstsøgning',
        'Data' => 'Data',
        'Options' => 'Valgmuligheder',
        'Title' => 'Titel',
        'Item' => 'Punkt',
        'Delete' => 'Slet',
        'Edit' => 'Rediger',
        'View' => 'Vis',
        'Number' => 'Nummer',
        'System' => 'System',
        'Contact' => 'Kontaktperson',
        'Contacts' => 'Kontaktpersoner',
        'Export' => 'Eksporter',
        'Up' => 'Op',
        'Down' => 'Ned',
        'Add' => 'Tilføj',
        'Added!' => 'Tilføjet',
        'Category' => 'Kategori',
        'Viewer' => 'Fremviser',
        'Expand' => 'Udvid',
        'Small' => 'Lille',
        'Medium' => 'Medium',
        'Large' => 'Stor',
        'Date picker' => 'Datovælger',
        'Show Tree Selection' => 'Vis træ',
        'The field content is too long!' => 'Indholdet af feltet er for langt.',
        'Maximum size is %s characters.' => 'Maksimal længde er %s tegn.',
        'This field is required or' => 'Dette felt er påkrævet eller',
        'New message' => 'Ny meddelelse',
        'New message!' => 'Ny meddelelse!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Vær venlig at besvare én eller flere sager for at komme tilbage til køens normale visning',
        'You have %s new message(s)!' => 'Du har %s ny(e) meddelelser.',
        'You have %s reminder ticket(s)!' => 'Du har %s sag(er) med påmindelser.',
        'The recommended charset for your language is %s!' => 'Det anbefalede tegnsæt til dit sprog er %s.',
        'Change your password.' => 'Ændr dit password',
        'Please activate %s first!' => 'Aktiver venligst %s først',
        'No suggestions' => 'Ingen forslag',
        'Word' => 'Ord',
        'Ignore' => 'Ignorer',
        'replace with' => 'udskift med',
        'There is no account with that login name.' => 'Der er ingen konto med det login-navn.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Login fejlede. Dit brugernavn eller password blev indtastet forkert.',
        'There is no acount with that user name.' => 'Der er ingen konto med det brugernavn.',
        'Please contact your administrator' => 'Kontakt venligst din administrator',
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact your administrator.' =>
            'Login lykkedes, men ingen kundeoplysninger er fundet i systemet. Kontakt venligst din administrator.',
        'This e-mail address already exists. Please log in or reset your password.' =>
            'Denne mail-adresse eksisterer allerede. Log ind eller nulstil dit password.',
        'Logout' => 'Log ud',
        'Logout successful. Thank you for using %s!' => 'Du er nu logget ud. Tak fordi du bruger %s.',
        'Feature not active!' => 'Funktionen er ikke aktiv',
        'Agent updated!' => 'Agent opdateret',
        'Database Selection' => 'Databasevalg',
        'Create Database' => 'Opret database',
        'System Settings' => 'Systemindstillinger',
        'Mail Configuration' => 'Mail-konfiguration',
        'Finished' => 'Færdig',
        'Install OTRS' => 'Installer OTRS',
        'Intro' => 'Indledning',
        'License' => 'Licens',
        'Database' => 'Database',
        'Configure Mail' => 'Konfigurer Mail',
        'Database deleted.' => 'Database slettet.',
        'Enter the password for the administrative database user.' => 'Indtast passwordet for den administrative bruger i databasen.',
        'Enter the password for the database user.' => 'Indtast oasswirdet for databasens bruger.',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty.' =>
            'Hvis du har sat et root-password på din database, skal det indtastes her. Ellers lad feltet være tomt.',
        'Database already contains data - it should be empty!' => 'Databasen indeholder allerede data - den burde være tom!',
        'Login is needed!' => 'Login er påkrævet',
        'It is currently not possible to login due to a scheduled system maintenance.' =>
            'Det er i øjeblikket ikke muligt at logge ind grundet planlagt system-vedligeholdelde.',
        'Password is needed!' => 'Adgangskode er påkrævet',
        'Take this Customer' => 'Tag denne kunde',
        'Take this User' => 'Tag denne bruger',
        'possible' => 'mulig',
        'reject' => 'afvis',
        'reverse' => 'omvendt',
        'Facility' => 'Facilitet',
        'Time Zone' => 'Tidszone',
        'Pending till' => 'Afventer til',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Brug ikke Superuser-kontoen til at arbejde med OTRS! Opret nye agenter og arbejd med disse konti i stedet.',
        'Dispatching by email To: field.' => 'Sendes via mail til: felt.',
        'Dispatching by selected Queue.' => 'Sendes via den valgte kø.',
        'No entry found!' => 'Ingen post fundet',
        'Session invalid. Please log in again.' => 'Ugyldig session. Log venligst ind igen.',
        'Session has timed out. Please log in again.' => 'Sessionens tidsfrist er udløbet. Vær venlig at logge ind igen.',
        'Session limit reached! Please try again later.' => 'Systemet kan ikke håndtere flere brugere nu. Prøv venligst igen senere.',
        'No Permission!' => 'Ingen tilladelse.',
        '(Click here to add)' => '(Klik her for at tilføje)',
        'Preview' => 'Forhåndsvisning',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakken er ikke installeret korrekt! Installer den igen.',
        '%s is not writable!' => 'Der kan ikke skrives til %s!',
        'Cannot create %s!' => 'Kan ikke oprette %s!',
        'Check to activate this date' => 'Marker for at aktivere denne dato',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Du har Out of Office aktiveret. Vil du deaktivere det?',
        'News about OTRS releases!' => 'Nyheder om OTRS-udgivelser.',
        'Go to dashboard!' => 'Gå til dashboard!',
        'Customer %s added' => 'Kunde %s er tilføjet',
        'Role added!' => 'Rolle tilføjet.',
        'Role updated!' => 'Rolle opdateret.',
        'Attachment added!' => 'Vedhæftet fil tilføjet.',
        'Attachment updated!' => 'Vedhæftet fil opdateret.',
        'Response added!' => 'Svar tilføjet.',
        'Response updated!' => 'Svar opdateret.',
        'Group updated!' => 'Gruppe opdateret.',
        'Queue added!' => 'Kø tilføjet.',
        'Queue updated!' => 'Kø opdateret.',
        'State added!' => 'Tilstand tilføjet.',
        'State updated!' => 'Tilstand opdateret.',
        'Type added!' => 'Type tilføjet.',
        'Type updated!' => 'Type opdateret.',
        'Customer updated!' => 'Kunde opdateret.',
        'Customer company added!' => 'Kunde-firma tilføjet.',
        'Customer company updated!' => 'Kunde-firma opdateret.',
        'Note: Company is invalid!' => 'Note: Firma er ugyldigt',
        'Mail account added!' => 'Mail-konto tilføjet.',
        'Mail account updated!' => 'Mail-konto opdateret.',
        'System e-mail address added!' => 'System-mail-adresse tilføjet.',
        'System e-mail address updated!' => 'System-mail-adresse opdateret.',
        'Contract' => 'Kontrakt',
        'Online Customer: %s' => 'Online kunde: %s ',
        'Online Agent: %s' => 'Online Agent: %s ',
        'Calendar' => 'Kalender',
        'File' => 'Fil',
        'Filename' => 'Filnavn',
        'Type' => 'Type',
        'Size' => 'Størrelse',
        'Upload' => 'Upload',
        'Directory' => 'Katalog',
        'Signed' => 'Underskrevet',
        'Sign' => 'Underskriv',
        'Crypted' => 'Krypteret',
        'Crypt' => 'Krypter',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP-nøgle',
        'PGP Keys' => 'PGP-nøgler',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME-certifikat',
        'S/MIME Certificates' => 'S/MIME-certifikater',
        'Office' => 'Kontor',
        'Phone' => 'Telefon',
        'Fax' => 'Fax',
        'Mobile' => 'Mobil',
        'Zip' => 'Post Nr.',
        'City' => 'By',
        'Street' => 'Gade',
        'Country' => 'Land',
        'Location' => 'Lokation',
        'installed' => 'installeret',
        'uninstalled' => 'afinstalleret',
        'Security Note: You should activate %s because application is already running!' =>
            'Sikkerhedsadvarsel: Du burde aktivere %s, da applikationen allerede kører.',
        'Unable to parse repository index document.' => 'Ikke i stand til at fortolke repositoriets index-dokument.',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Ingen pakker for din version af frameworket fundet i dette repositorie, det indeholder kun pakker for andre versioner af frameworket.',
        'No packages, or no new packages, found in selected repository.' =>
            'Ingen pakker, eller ingen nye pakker, fundet i det valgte repositorie.',
        'Edit the system configuration settings.' => 'Rediger systemets konfiguration',
        'ACL information from database is not in sync with the system configuration, please deploy all ACLs.' =>
            'ACL-oplysningerne i databasen stemmer ikke med systemets konfiguration. Iværksæt alle ACL\'er.',
        'printed at' => 'udskrevet den',
        'Loading...' => 'Indlæser...',
        'Dear Mr. %s,' => 'Kære Hr. %s',
        'Dear Mrs. %s,' => 'Kære Fru. %s',
        'Dear %s,' => 'Kære %s',
        'Hello %s,' => 'Hej %s',
        'This email address is not allowed to register. Please contact support staff.' =>
            'Denne mail-adresse har ikke tilladelse til at registrere. Kontakt venligst supporten.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'Ny konto oprettet. Login-information sendt til %s. Tjek venligst din mail.',
        'Please press Back and try again.' => 'Tryk venligst tilbage og prøv igen.',
        'Sent password reset instructions. Please check your email.' => 'Instruktioner til nulstilling af password sendt. Tjek venligst din mail.',
        'Sent new password to %s. Please check your email.' => 'Nyt password sendt til %s. Tjek venligst din mail.',
        'Upcoming Events' => 'Forestående Hændelser',
        'Event' => 'Hændelse',
        'Events' => 'Hændelser',
        'Invalid Token!' => 'Ugyldigt Token!',
        'more' => 'mere',
        'Collapse' => 'Sammenfold',
        'Shown' => 'Viste',
        'Shown customer users' => 'Viste kundebrugere',
        'News' => 'Nyheder',
        'Product News' => 'Produktnyheder',
        'OTRS News' => 'OTRS-nyheder',
        '7 Day Stats' => 'Sidste 7 dage',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            'Process Management-informationen i databasen stemmer ikke overens med systemkonfigurationen. Synkroniser alle processer.',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Pakken er ikke godtkendt af OTRS-gruppen! Det anbefales ikke af bruge denne pakke.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            'Hvis du fortsætter installationen af denne pakke, kan følgende opstå:<br><br>&nbsp;-Sikkerhedsproblemer<br>&nbsp;-Stabilitetsproblemer<br>&nbsp;-Performance-problemer<br><br>Vær opmærksom på at problemer opstået ved brug af denne pakke ikke af dækket af OTRS-servicekontrakter!<br>br>',
        'Mark' => 'Marker',
        'Unmark' => 'Fjern markering',
        'Bold' => 'Fed',
        'Italic' => 'Kursiv',
        'Underline' => 'Understreget',
        'Font Color' => 'Skriftfarve',
        'Background Color' => 'Baggrundsfarve',
        'Remove Formatting' => 'Fjern formattering',
        'Show/Hide Hidden Elements' => 'Vis/Skjul Skjulte Elementer',
        'Align Left' => 'Venstrestil',
        'Align Center' => 'Centrer',
        'Align Right' => 'Højrestil',
        'Justify' => 'Lige margener',
        'Header' => 'Overskrift',
        'Indent' => 'Ryk ind',
        'Outdent' => 'Ryk ud',
        'Create an Unordered List' => 'Lav punktliste',
        'Create an Ordered List' => 'Lav talliste',
        'HTML Link' => 'HTML-link',
        'Insert Image' => 'Indsæt billede',
        'CTRL' => 'Ctrl',
        'SHIFT' => 'Shift',
        'Undo' => 'Fortryd',
        'Redo' => 'Gendan',
        'OTRS Daemon is not running.' => 'OTRS-dæmonen kører ikke.',
        'Can\'t contact registration server. Please try again later.' => 'Kan ikke kontakte registrations-serveren. Prøv venligst igen senere.',
        'No content received from registration server. Please try again later.' =>
            'Modtog ikke noget fra registrations-serveren. Prøv venligst igen senere.',
        'Problems processing server result. Please try again later.' => 'Problemer med at behandle svaret fra serveren. Prøv venligst igen senere.',
        'Username and password do not match. Please try again.' => 'Brugernavn og password passer ikke. Prøv venligst igen.',
        'The selected process is invalid!' => 'Den valgte proces er ugyldig.',
        'Upgrade to %s now!' => 'Opgrader til %s nu!',
        '%s Go to the upgrade center %s' => '%s Gå til opgraderings center %s',
        'The license for your %s is about to expire. Please make contact with %s to renew your contract!' =>
            'Licensen for %s er ved at udløbe. Kontakt venligst %s for at forny din kontrakt.',
        'An update for your %s is available, but there is a conflict with your framework version! Please update your framework first!' =>
            'En opdatering til %s er tilgængelig, men der er en konflikt med din framework version!
Opdater venligst dit framework først!',
        'Your system was successfully upgraded to %s.' => 'Dit system blev opgraderet til %s.',
        'There was a problem during the upgrade to %s.' => 'Der var et problem under opgraderingen til %s.',
        '%s was correctly reinstalled.' => '%s blev geninstalleret korrekt.',
        'There was a problem reinstalling %s.' => 'Der var et problem med at geninstallere %s.',
        'Your %s was successfully updated.' => '%s blev opdateret.',
        'There was a problem during the upgrade of %s.' => 'Der var et problem under opgraderingen af %s.',
        '%s was correctly uninstalled.' => '%s blev afinstalleret.',
        'There was a problem uninstalling %s.' => 'Der var et problem med at afinstallere %s.',
        'Enable cloud services to unleash all OTRS features!' => 'Aktiver cloud service for at få adgang til alle OTRS muligheder!',

        # Template: AAACalendar
        'New Year\'s Day' => 'Nytårsdag',
        'International Workers\' Day' => 'Arbejdernes internationale kampdag',
        'Christmas Eve' => 'Juleaften',
        'First Christmas Day' => 'Første juledag',
        'Second Christmas Day' => 'Anden juledag',
        'New Year\'s Eve' => 'Nytårs aften',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS som requester',
        'OTRS as provider' => 'OTRS som provider',
        'Webservice "%s" created!' => 'Webservice "%s" oprettet.',
        'Webservice "%s" updated!' => 'Webservice "%s" opdateret.',

        # Template: AAAMonth
        'Jan' => 'Jan',
        'Feb' => 'Feb',
        'Mar' => 'Mar',
        'Apr' => 'Apr',
        'May' => 'Maj',
        'Jun' => 'Jun',
        'Jul' => 'Jul',
        'Aug' => 'Aug',
        'Sep' => 'Sep',
        'Oct' => 'Okt',
        'Nov' => 'Nov',
        'Dec' => 'Dec',
        'January' => 'Januar',
        'February' => 'Februar',
        'March' => 'Marts',
        'April' => 'April',
        'May_long' => 'Maj',
        'June' => 'Juni',
        'July' => 'Juli',
        'August' => 'August',
        'September' => 'September',
        'October' => 'Oktober',
        'November' => 'November',
        'December' => 'December',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Indstillingerne er opdateret',
        'User Profile' => 'Brugerprofil',
        'Email Settings' => 'Email-indstillinger',
        'Other Settings' => 'Andre Indstillinger',
        'Notification Settings' => 'Besked-indstillinger',
        'Change Password' => 'Skift adgangskode',
        'Current password' => 'Nuværende adgangskode',
        'New password' => 'Ny adgangskode',
        'Verify password' => 'Gentag adgangskode',
        'Spelling Dictionary' => 'Ordbog til stavekontrol',
        'Default spelling dictionary' => 'Standard-stavekontrol',
        'Max. shown Tickets a page in Overview.' => 'Max. viste sager pr. side i oversigten.',
        'The current password is not correct. Please try again!' => 'Det nuværende password er ikke korrekt. Prøv venligst igen.',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Kan ikke opdatere password, dine nye passwords er ikke ens. Prøv venligst igen.',
        'Can\'t update password, it contains invalid characters!' => 'Kan ikke opdatere password, det indeholde ugyldige tegn.',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Kan ikke opdatere password, det skal være mindst %s tegn langt.',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Kan ikke opdatere password, det skal indeholde mindst 2 små og 2 store bogstaver.',
        'Can\'t update password, it must contain at least 1 digit!' => 'Kan ikke opdatere password, det skal indeholde mindst 1 tal.',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Kan ikke opdatere password, det skal indeholde mindst 2 tegn.',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Kan ikke opdatere password, da dette password allerede har været brugt. Vælg venligst et nyt.',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Vælg det tegn, der skal bruges som separator i CSV-filer (rapporter og søgninger). Hvis du ikke vælger en separator her, vil standard-separatoren for dit sprog blive brugt.',
        'CSV Separator' => 'CSV-skilletegn',

        # Template: AAATicket
        'Status View' => 'Statusoversigt',
        'Service View' => 'Serviceoversigt',
        'Bulk' => 'Massehandling',
        'Lock' => 'Træk',
        'Unlock' => 'Frigiv',
        'History' => 'Historik',
        'Zoom' => 'Vis',
        'Age' => 'Alder',
        'Bounce' => 'Overgiv',
        'Forward' => 'Videresend',
        'From' => 'Fra',
        'To' => 'Til',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Emne',
        'Move' => 'Flyt',
        'Queue' => 'Kø',
        'Queues' => 'Køer',
        'Priority' => 'Prioritet',
        'Priorities' => 'Prioriteter',
        'Priority Update' => 'Opdatering af Prioritet',
        'Priority added!' => 'Prioritet tilføjet.',
        'Priority updated!' => 'Prioritet opdateret.',
        'Signature added!' => 'Signatur tilføjet.',
        'Signature updated!' => 'Signatur opdateret.',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Service Level Agreement',
        'Service Level Agreements' => 'Service Level Agreements',
        'Service' => 'Service',
        'Services' => 'Services',
        'State' => 'Tilstand',
        'States' => 'Tilstande',
        'Status' => 'Status',
        'Statuses' => 'Status',
        'Ticket Type' => 'Sagstype',
        'Ticket Types' => 'Sagstyper',
        'Compose' => 'Skrive',
        'Pending' => 'Afventer',
        'Owner' => 'Ejer',
        'Owner Update' => 'Ændring af ejer',
        'Responsible' => 'Ansvarlig',
        'Responsible Update' => 'Opdatering af Ansvarlig',
        'Sender' => 'Afsender',
        'Article' => 'Indlæg',
        'Ticket' => 'Sager',
        'Createtime' => 'Oprettelsestid',
        'plain' => 'almindelig',
        'Email' => 'Mail',
        'email' => 'mail',
        'Close' => 'Luk',
        'Action' => 'Handling',
        'Attachment' => 'Vedhæftet fil',
        'Attachments' => 'Vedhæftede filer',
        'This message was written in a character set other than your own.' =>
            'Denne meddelelse blev skrevet i et andet tegnsæt end dit eget.',
        'If it is not displayed correctly,' => 'Vises den ikke korrekt,',
        'This is a' => 'Dette er en',
        'to open it in a new window.' => 'for at åbne i et nyt vindue.',
        'This is a HTML email. Click here to show it.' => 'Dette er en mail i HTML. Klik her for at vise den.',
        'Free Fields' => 'Frie felter',
        'Merge' => 'Saml',
        'merged' => 'samlet',
        'closed successful' => 'Afsluttet',
        'closed unsuccessful' => 'Afsluttet uden løsning',
        'Locked Tickets Total' => 'Mine sager i alt',
        'Locked Tickets Reminder Reached' => 'Mine sager, hvor påmindelsesfristen er nået',
        'Locked Tickets New' => 'Mine nye sager',
        'Responsible Tickets Total' => 'Sager, jeg er ansvarlig for i alt',
        'Responsible Tickets New' => 'Nye sager, jeg er ansvarlig for',
        'Responsible Tickets Reminder Reached' => 'Sager, jeg er ansvarlig for, hvor påmindelsesfristen er nået',
        'Watched Tickets Total' => 'Fulgte sager i alt',
        'Watched Tickets New' => 'Nye fulgte sager',
        'Watched Tickets Reminder Reached' => 'Fulgte sager, hvor påmindelsesfristen er nået',
        'All tickets' => 'Alle sager',
        'Available tickets' => 'Frie sager',
        'Escalation' => 'Eskalation',
        'last-search' => 'sidste søgning',
        'QueueView' => 'Køer',
        'Ticket Escalation View' => 'Oversigt over eskalerede sager',
        'Message from' => 'Besked fra',
        'End message' => 'Slut på besked',
        'Forwarded message from' => 'Videresendt besked fra',
        'End forwarded message' => 'Slut på videresendt besked',
        'Bounce Article to a different mail address' => 'Bounce Indlæg til en anden mail-adresse',
        'Reply to note' => 'Svar på note',
        'new' => 'ny',
        'open' => 'åben',
        'Open' => 'Åben',
        'Open tickets' => 'Åbne sager',
        'closed' => 'lukket',
        'Closed' => 'Lukket',
        'Closed tickets' => 'Lukkede sager',
        'removed' => 'fjernet',
        'pending reminder' => 'afventer påmindelse',
        'pending auto' => 'afventer auto',
        'pending auto close+' => 'afventer autolukning+',
        'pending auto close-' => 'afventer autolukning-',
        'email-external' => 'mail-ekstern',
        'email-internal' => 'mail-intern',
        'note-external' => 'bemærkning-ekstern',
        'note-internal' => 'bemærkning-intern',
        'note-report' => 'bemærkning-rapport',
        'phone' => 'telefon',
        'sms' => 'sms',
        'webrequest' => 'webanmodning',
        'lock' => 'tildelt',
        'unlock' => 'fri',
        'very low' => 'meget lav',
        'low' => 'lav',
        'normal' => 'normal',
        'high' => 'høj',
        'very high' => 'meget høj',
        '1 very low' => '1 meget lav',
        '2 low' => '2 lav',
        '3 normal' => '3 normal',
        '4 high' => '4 høj',
        '5 very high' => '5 meget høj',
        'auto follow up' => 'automatisk opfølgning',
        'auto reject' => 'automatisk afvisning',
        'auto remove' => 'Auto fjern',
        'auto reply' => 'autosvar',
        'auto reply/new ticket' => 'autosvar/ny sag',
        'Create' => 'Opret',
        'Answer' => 'Svar',
        'Phone call' => 'Telefonopkald',
        'Ticket "%s" created!' => 'Sag "%s" oprettet.',
        'Ticket Number' => 'Sagsnummer',
        'Ticket Object' => 'Sagsobjekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Sag nummer "%s" eksisterer ikke! Kan ikke sammenkæde den.',
        'You don\'t have write access to this ticket.' => 'Du har ikke rettigheder til at ændre denne sag.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Du skal eje denne sag for at udføre handlingen.',
        'Please change the owner first.' => 'Skift venligst ejeren først.',
        'Ticket selected.' => 'Sag valgt.',
        'Ticket is locked by another agent.' => 'Sagen ejes af en anden agent.',
        'Ticket locked.' => 'Sag trukker.',
        'Don\'t show closed Tickets' => 'Vis åbne sager',
        'Show closed Tickets' => 'Vis lukkede sager',
        'New Article' => 'Nyt indlæg',
        'Unread article(s) available' => 'Der er ulæste indlæg',
        'Remove from list of watched tickets' => 'Fjern fra listen over fulgte sager',
        'Add to list of watched tickets' => 'Føj til listen over fulgte sager',
        'Email-Ticket' => 'Email-sag',
        'Create new Email Ticket' => 'Opret ny mail-sag',
        'Phone-Ticket' => 'Ny Sag',
        'Search Tickets' => 'Søg sager',
        'Customer Realname' => 'Kundens rigtige navn',
        'Customer History' => 'Kunde-historik',
        'Edit Customer Users' => 'Rediger kundebrugere',
        'Edit Customer' => 'Rediger kunde',
        'Bulk Action' => 'Massehandling',
        'Bulk Actions on Tickets' => 'Massehandlinger på sager',
        'Send Email and create a new Ticket' => 'Send mail og opret en ny sag',
        'Create new Email Ticket and send this out (Outbound)' => 'Opret ny mail-sag, og send den (Outbound)',
        'Create new Phone Ticket (Inbound)' => 'Opret ny telefon-sag (Inbound)',
        'Address %s replaced with registered customer address.' => 'Adresse %s erstattet med kundens registrerede adresse.',
        'Customer user automatically added in Cc.' => 'Kundebruger automatisk tilføjet til Cc.',
        'Overview of all open Tickets' => 'Oversigt over alle frie sager',
        'Locked Tickets' => 'Mine sager',
        'My Locked Tickets' => 'Mine sager',
        'My Watched Tickets' => 'Fulgte sager',
        'My Responsible Tickets' => 'Sager, jeg er ansvarlig for',
        'Watched Tickets' => 'Fulgte sager',
        'Watched' => 'Fulgte',
        'Watch' => 'Følg',
        'Unwatch' => 'Følg ikke',
        'Lock it to work on it' => 'Træk sagen for at arbejde på den',
        'Unlock to give it back to the queue' => 'Frigiv sagen og gør den ledig i køen',
        'Show the ticket history' => 'Vis sagens historik',
        'Print this ticket' => 'Udskriv denne sag',
        'Print this article' => 'Udskriv dette indlæg',
        'Split' => 'Opdel',
        'Split this article' => 'Opdel dette indlæg',
        'Forward article via mail' => 'Videresend indlæg via mail',
        'Change the ticket priority' => 'Ændr sagens prioritet',
        'Change the ticket free fields!' => 'Skift sagens frie felter.',
        'Link this ticket to other objects' => 'Kæd denne sag til andre objekter',
        'Change the owner for this ticket' => 'Ændr denne sags ejer',
        'Change the  customer for this ticket' => 'Ændr denne sags kunde',
        'Add a note to this ticket' => 'Tilføj en note til denne sag',
        'Merge into a different ticket' => 'Saml til en anden sag',
        'Set this ticket to pending' => 'Sæt denne sag til at afvente',
        'Close this ticket' => 'Luk denne sag',
        'Look into a ticket!' => 'Se nærmere på en sag.',
        'Delete this ticket' => 'Slet denne sag',
        'Mark as Spam!' => 'Marker som spam.',
        'My Queues' => 'Mine køer',
        'Shown Tickets' => 'Viste Sager',
        'Shown Columns' => 'Viste Kolonner',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Din sag nummer "<OTRS_TICKET>" er blevet samlet med sag nummer "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Sag %s: Tidsgrænsen for første svar er overskredet (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Sag %s: Tidsgrænsen for første svar overskrides om %s!',
        'Ticket %s: update time is over (%s)!' => 'Sag %s: Opdateringstid er overskredet (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Sag %s: Opdateringstid overskrides om %s!',
        'Ticket %s: solution time is over (%s)!' => 'Sag %s: Løsningstid er overskredet (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Sag %s: løsningstid overskrides om %s!',
        'There are more escalated tickets!' => 'Der er ikke flere eskalerede sager.',
        'Plain Format' => 'Kildetekst',
        'Reply All' => 'Svar alle',
        'Direction' => 'Retning',
        'New ticket notification' => 'Besked om ny sag',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Send mig en besked, hvis der er en ny sag i "Mine køer".',
        'Send new ticket notifications' => 'Send besked om nye sager',
        'Ticket follow up notification' => 'Besked om opfølgning på sager',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Send mig en besked, hvis en kunde sender en opfølgning, og jeg er denne sags indehaver.',
        'Send ticket follow up notifications' => 'Send besked om opfølgning til brugere',
        'Ticket lock timeout notification' => 'Besked om sagsfrigivelse efter tidsfristens udløb',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Send mig en besked, hvis systemet frigiver en sag.',
        'Send ticket lock timeout notifications' => 'Send besked om udløb af tidsfrister',
        'Ticket move notification' => 'Besked om flyttet sag',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Send mig en besked, hvis en sag flyttes ind i en af "Mine køer".',
        'Send ticket move notifications' => 'Send besked om flyttede sager',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Dit valg af favirot-køer. Du får også beskeder om hændelser i de køer, hvis det er aktiveret.',
        'Custom Queue' => 'Tilpasset kø',
        'QueueView refresh time' => 'Genindlæsningstid af kø-visningen',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Hvis aktiveret vil Kø-visningen automatisk genindlæses efter den specificerede tid.',
        'Refresh QueueView after' => 'Opdater kø-billedet efter',
        'Screen after new ticket' => 'Skærm efter oprettelse af ny sag',
        'Show this screen after I created a new ticket' => 'Vis dette billede efter jeg har oprettet en ny sag',
        'Closed Tickets' => 'Lukkede sager',
        'Show closed tickets.' => 'Vis lukkede sager.',
        'Max. shown Tickets a page in QueueView.' => 'Max. viste sager pr. side i kø-visning.',
        'Ticket Overview "Small" Limit' => 'Sagsoversigt "Lille" grænse',
        'Ticket limit per page for Ticket Overview "Small"' => 'Antal sager pr side for Sagsoversigt "Lille"',
        'Ticket Overview "Medium" Limit' => 'Sagsoversigt "Mellem" grænse',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Antal sager pr side for Sagsoversigt "Mellem"',
        'Ticket Overview "Preview" Limit' => 'Sagsoversigt "Forhåndsvisnings" grænse',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Antal sager pr side for Sagsoversigt "Forhåndsvisning"',
        'Ticket watch notification' => 'Besked om fulgte sager',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'For mine fulgte sager, send mig samme beskeder som sagernes ejere får.',
        'Send ticket watch notifications' => 'Send besked om fulgte sager',
        'Out Of Office Time' => 'Ude af Kontoret',
        'New Ticket' => 'Ny sag',
        'Create new Ticket' => 'Opret ny sag',
        'Customer called' => 'Opkald fra Kunde',
        'phone call' => 'opringning',
        'Phone Call Outbound' => 'Ring til kunden',
        'Phone Call Inbound' => 'Kunden ringer',
        'Reminder Reached' => 'Påmindelsesdato nået',
        'Reminder Tickets' => 'Sager med påmindelser',
        'Escalated Tickets' => 'Eskalerede Sager',
        'New Tickets' => 'Nye Sager',
        'Open Tickets / Need to be answered' => 'Åbne Sager',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Alle åbne sager, der er i gang med at blive arbejdet på',
        'All new tickets, these tickets have not been worked on yet' => 'Alle nye sager, der ikke er blevet arbejdet på endnu',
        'All escalated tickets' => 'Alle eskalerede sager',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Alle sager med påmindelser, hvor påmindelsesfristen er nået',
        'Archived tickets' => 'Arkiverede sager',
        'Unarchived tickets' => 'Uarkiverede sager',
        'Ticket Information' => 'Sagsinformation',
        'including subqueues' => 'Inkluder underkøer',
        'excluding subqueues' => 'Ekskluder underkøer',

        # Template: AAAWeekDay
        'Sun' => 'Søn',
        'Mon' => 'Man',
        'Tue' => 'Tir',
        'Wed' => 'Ons',
        'Thu' => 'Tor',
        'Fri' => 'Fre',
        'Sat' => 'Lør',

        # Template: AdminACL
        'ACL Management' => 'ACL-administration',
        'Filter for ACLs' => 'Filtrer ACLs',
        'Filter' => 'Filter',
        'ACL Name' => 'ACL-navn',
        'Actions' => 'Handlinger',
        'Create New ACL' => 'Opret ny ACL',
        'Deploy ACLs' => 'Aktiver ACL\'er',
        'Export ACLs' => 'Eksporter ACL\'er',
        'Configuration import' => 'Konfigurations-import',
        'Here you can upload a configuration file to import ACLs to your system. The file needs to be in .yml format as exported by the ACL editor module.' =>
            'Her kan du indlæse en konfigurationsfil for at importere ACLs til dit system. Filen skal være eksporteret i .yml format af ACL redigerings modulet.',
        'This field is required.' => 'Dette felt skal udfyldes',
        'Overwrite existing ACLs?' => 'Overskriv eksisterende ACL\'er?',
        'Upload ACL configuration' => 'Upload ACL-konfiguration',
        'Import ACL configuration(s)' => 'Importer ACL-konfiguration(er)',
        'To create a new ACL you can either import ACLs which were exported from another system or create a complete new one.' =>
            'For at oprette en ACL kan du enten importere ACLs der er eksporteret fra et andet system eller kreere en helt ny.',
        'Changes to the ACLs here only affect the behavior of the system, if you deploy the ACL data afterwards. By deploying the ACL data, the newly made changes will be written to the configuration.' =>
            'Ændringer i disse ACL\'er får først indflydelse på systemet hvis du efterfølgende udgiver ACL data. Ved at udgive ACL data skrives ændringerne til konfigurationen.',
        'ACLs' => 'ACL\'er',
        'Please note: This table represents the execution order of the ACLs. If you need to change the order in which ACLs are executed, please change the names of the affected ACLs.' =>
            'Bemærk: Denne tabel repræsenterer i hvilken rækkefølge ACL\'er udføres. Hvis du har brug for at ændre rækkefølgen skal du omdøbe dem.',
        'ACL name' => 'ACL-navn',
        'Validity' => 'Gyldighed',
        'Copy' => 'Kopier',
        'No data found.' => 'Ingen data fundet.',

        # Template: AdminACLEdit
        'Edit ACL %s' => 'Rediger ACL %s',
        'Go to overview' => 'Gå til oversigt',
        'Delete ACL' => 'Slet ACL',
        'Delete Invalid ACL' => 'Slet ugyldig ACL',
        'Match settings' => 'Match indstilliger',
        'Set up matching criteria for this ACL. Use \'Properties\' to match the current screen or \'PropertiesDatabase\' to match attributes of the current ticket that are in the database.' =>
            '',
        'Change settings' => 'Skift indstillinger',
        'Set up what you want to change if the criteria match. Keep in mind that \'Possible\' is a white list, \'PossibleNot\' a black list.' =>
            'Indstil hvad du vil ændre hvis kriterierne passer. Husk på at \'Possible\' er en hvidlistning og \'PossibleNot\' er en sortlistning',
        'Check the official' => 'Tjek den officielle',
        'documentation' => 'dokumentation',
        'Show or hide the content' => 'Vis eller skjul indhold',
        'Edit ACL information' => 'Rediger ACL-information',
        'Stop after match' => 'Stop, hvis matcher',
        'Edit ACL structure' => 'Rediger ACL-struktur',
        'Save settings' => 'Gem ændringer',
        'Save ACL' => '',
        'Save' => 'Gem',
        'or' => 'eller',
        'Save and finish' => 'Gem og afslut',
        'Do you really want to delete this ACL?' => 'Vil du virkelig slette denne ACL?',
        'This item still contains sub items. Are you sure you want to remove this item including its sub items?' =>
            'Denne enhed indeholder under-enheder. Er du sikker på, at du vil fjerne denne enhed, inklusive dens underenheder?',
        'An item with this name is already present.' => 'En enhed med dette navn eksisterer allerede.',
        'Add all' => 'Tilføj alle',
        'There was an error reading the ACL data.' => 'Fejl under læsning af ACL data.',

        # Template: AdminACLNew
        'Create a new ACL by submitting the form data. After creating the ACL, you will be able to add configuration items in edit mode.' =>
            '',

        # Template: AdminAttachment
        'Attachment Management' => 'Styring af vedhæftede filer',
        'Add attachment' => 'Vedhæft fil',
        'List' => 'Liste',
        'Download file' => 'Download fil',
        'Delete this attachment' => 'Slet denne vedhæftede fil',
        'Do you really want to delete this attachment?' => 'Er du sikker på at du vil slette denne vedhæftning?',
        'Add Attachment' => 'Tilføj vedhæftet fil',
        'Edit Attachment' => 'Rediger vedhæftet fil',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Styring af autosvar',
        'Add auto response' => 'Tilføj autosvar',
        'Add Auto Response' => 'Tilføj autosvar',
        'Edit Auto Response' => 'Rediger autosvar',
        'Response' => 'Svar',
        'Auto response from' => 'Autosvar fra',
        'Reference' => 'Reference',
        'You can use the following tags' => 'Du kan bruge følgende tags',
        'To get the first 20 character of the subject.' => 'For at få de første 20 tegn af emnet.',
        'To get the first 5 lines of the email.' => 'For at få de første 5 linjer af mailen.',
        'To get the name of the ticket\'s customer user (if given).' => '',
        'To get the article attribute' => 'For at få indlægges attributter',
        ' e. g.' => 'f.eks.',
        'Options of the current customer user data' => 'Valgmuligheder for den nuværende kundebruger',
        'Ticket owner options' => 'Valgmuligheder for sagens ejer',
        'Ticket responsible options' => 'Valgmuligheder for sagens ansvarlige',
        'Options of the current user who requested this action' => 'Valgmuligheder for den bruger, der udfører denne handling',
        'Options of the ticket data' => 'Valgmuligheder for sagens oplysninger',
        'Options of ticket dynamic fields internal key values' => 'Valgmuligheder for sagens dynamiske felters interne nøgleværdier',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Valgmuligheder for sagens dynamiske felters visningsværdier, brugbart for Dropdown- og Multiselect-felter',
        'Config options' => 'Konfigrationsvalgmuligheder',
        'Example response' => 'Eksempel på svar',

        # Template: AdminCloudServiceSupportDataCollector
        'Cloud Service Management' => 'Cloud Service Management',
        'Support Data Collector' => 'Indsamling af support-data',
        'Support data collector' => 'Indsamling af support-data',
        'Hint' => 'Tip',
        'Currently support data is only shown in this system.' => 'I øjeblikket vises support-data kun i dette system.',
        'It is highly recommended to send this data to OTRS Group in order to get better support.' =>
            'Det anbefales at sende disse data til OTRS koncernen for bedre support.',
        'Configuration' => 'Konfiguration',
        'Send support data' => 'Send support-data',
        'This will allow the system to send additional support data information to OTRS Group.' =>
            'Dette tillader systemet at sende udvidet support-data information til OTRS koncernen.',
        'System Registration' => 'System-registrering',
        'To enable data sending, please register your system with OTRS Group or update your system registration information (make sure to activate the \'send support data\' option.)' =>
            'For at aktivere data afsendelse, bedes du registrere dit system hos OTRS koncernen eller opdatere dit systems registreringsoplysninger (sørg for at aktivere "send support data".)',
        'Register this System' => 'Registrer dette system',
        'System Registration is disabled for your system. Please check your configuration.' =>
            'System registrering er deaktiveret for dit system, kontroller din konfiguration.',

        # Template: AdminCloudServices
        'System registration is a service of OTRS Group, which provides a lot of advantages!' =>
            'System-registrering er en OTRS Group-service, der giver en masse fordele!',
        'Please note that the use of OTRS cloud services requires the system to be registered.' =>
            'Bemærk: for at benytte OTRS sky-tjenester skal systemet være registreret.',
        'Register this system' => 'Registrer dette system',
        'Here you can configure available cloud services that communicate securely with %s.' =>
            'Her kan du konfigurere tilgængelige sky-tjenester der kommunikerer sikkert med %s.',
        'Available Cloud Services' => 'Tilgængelige sky-tjenester',
        'Upgrade to %s' => 'Opgrader til %s',

        # Template: AdminCustomerCompany
        'Customer Management' => 'Administrer Kunder',
        'Wildcards like \'*\' are allowed.' => 'Jokertegn som \'*\' er tilladt.',
        'Add customer' => 'Tilføj kunde',
        'Select' => 'Vælg',
        'List (only %s shown - more available)' => '',
        'List (%s total)' => '',
        'Please enter a search term to look for customers.' => 'Angiv søgeord for at lede efter kunder',
        'Add Customer' => 'Tilføj kunde',

        # Template: AdminCustomerUser
        'Customer User Management' => 'Kunde-bruger-administration',
        'Back to search results' => 'Tilbage til søgeresultater',
        'Add customer user' => 'Tilføj kundebruger',
        'Customer user are needed to have a customer history and to login via customer panel.' =>
            'Kundebrugere skal oprettes for at få vist kundehistorik og for at kunne logge på i kundepanelet.',
        'Last Login' => 'Seneste login',
        'Login as' => 'Login som',
        'Switch to customer' => 'Skift til kunde',
        'Add Customer User' => 'Tilføj Kundebruger',
        'Edit Customer User' => 'Rediger Kundebruger',
        'This field is required and needs to be a valid email address.' =>
            'Dette felt er kævet og skal være en gyldig mail-adresse.',
        'This email address is not allowed due to the system configuration.' =>
            'Denne mailadresse er ikke tilladt ifølge systemkonfigurationen.',
        'This email address failed MX check.' => 'Denne mail-adresse fejler MX-tjek.',
        'DNS problem, please check your configuration and the error log.' =>
            'DNS-problem. Tjek din konfiguration og fejl-loggen.',
        'The syntax of this email address is incorrect.' => 'Syntaksen på denne mail-adresse er forkert.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Administrer Kunde/Gruppe-relationer',
        'Notice' => 'Notits',
        'This feature is disabled!' => 'Denne mulighed er deaktiveret!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Brug denne funktion, hvis du vil definere gruppetilladelser for kunder.',
        'Enable it here!' => 'Aktiver det her!',
        'Edit Customer Default Groups' => 'Rediger standardgrupper for kunder',
        'These groups are automatically assigned to all customers.' => 'Disse grupper tildeles automatisk til alle kunder.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Du kan administrere disse grupper via konfigurationsindstillingen "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtrer grupper',
        'Just start typing to filter...' => 'Begynd at skrive for at filtrere...',
        'Select the customer:group permissions.' => 'Vælg kunde:gruppe-tilladelser.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Hvis intet er velgt, er der ingen tilladelser i denne gruppe (sager vil ikke være tilgængelige for kunden).',
        'Search Results' => 'Søgeresultat',
        'Customers' => 'Kunder',
        'No matches found.' => 'Intet fundet',
        'Groups' => 'Grupper',
        'Change Group Relations for Customer' => 'Administrer Gruppe-relationer for Kunde',
        'Change Customer Relations for Group' => 'Administrer Kunde-relationer for Gruppe',
        'Toggle %s Permission for all' => 'Skift %s-tilladelse for alle',
        'Toggle %s permission for %s' => 'Skift %s-tilladelse for %s',
        'Customer Default Groups:' => 'Kundestandardgrupper:',
        'No changes can be made to these groups.' => 'Ingen ændringer kan laves på disse grupper',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Kun læseadgang til sager i denne gruppe/kø.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' =>
            'Komplet læse- og skriveadgang til sagerne i denne gruppe/kø.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Administrer Kunde/Service-relationer',
        'Edit default services' => 'Rediger standardservices',
        'Filter for Services' => 'Filter for services',
        'Allocate Services to Customer' => 'Tildel Services til Kunde',
        'Allocate Customers to Service' => 'Tildel Kunder til Service',
        'Toggle active state for all' => 'Skift aktiv tilstand for alle',
        'Active' => 'Aktiv',
        'Toggle active state for %s' => 'Skift aktiv tilstand for %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Administrer Dynamiske Felter',
        'Add new field for object' => 'Tilføj nyt felt for objekt',
        'To add a new field, select the field type from one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Liste over Dynamiske Felter',
        'Dynamic fields per page' => 'Dynamiske felter pr. side',
        'Label' => 'Label',
        'Order' => 'Rækkefølge',
        'Object' => 'Objekt',
        'Delete this field' => 'Slet dette felt',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Vil du virkelig slette dette dynamiske felt? ALT tilhørende data vil GÅ TABT!',
        'Delete field' => 'Slet felt',
        'Deleting the field and its data. This may take a while...' => '',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamiske Felter',
        'Field' => 'Felt',
        'Go back to overview' => 'Gå tilbage til oversigt',
        'General' => 'Generelt',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Dette felt er påkrævet og værdien skal kun bestå af bogstaver og tal.',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Skal være unik og kun bogstaver og tal.',
        'Changing this value will require manual changes in the system.' =>
            'At ændre denne værdi vil kræve manuelle ændringer i systemet.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Dette er navnet, der bliver vist på de skærmbilleder, hvor feltet er aktivt.',
        'Field order' => 'Feltrækkefølge',
        'This field is required and must be numeric.' => 'Dette felt er påkrævet og skal være numerisk.',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Dette er rækkefølgen som dette felt vil blive vist på skærmbilleder, hvor det er aktivt.',
        'Field type' => 'Felttype',
        'Object type' => 'Objekttype',
        'Internal field' => 'Internt felt',
        'This field is protected and can\'t be deleted.' => 'Dette felt er beskyttet og kan ikke slettes.',
        'Field Settings' => 'Feltindstillinger',
        'Default value' => 'Standardværdi',
        'This is the default value for this field.' => 'Dette er standardværdien for dette felt.',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Standard dato-forskel',
        'This field must be numeric.' => 'Dette felt skal være numerisk.',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            'Forskellen fra NU (i sekunder) for at beregne feltets standardværdi (f.eks. 3600 eller -60).',
        'Define years period' => 'Definer årsperiode',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            'Aktiver denne funktion for at definere en fast række af år (i fremtiden og i fortiden), der vises i års-delen af feltet.',
        'Years in the past' => 'År tilbage',
        'Years in the past to display (default: 5 years).' => 'År tilbage, der skal vises (standard: 5 år).',
        'Years in the future' => 'År frem',
        'Years in the future to display (default: 5 years).' => 'År frem, der skal vises (standard: 5 år).',
        'Show link' => 'Vis link',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            'Her kan du angive et valgfrit HTTP-link for felt-værdien i oversigter og Zoom-skærmbilleder.',
        'Link for preview' => '',
        'If filled in, this URL will be used for a preview which is shown when this link is hovered in ticket zoom. Please note that for this to work, the regular URL field above needs to be filled in, too.' =>
            '',
        'Restrict entering of dates' => 'Begræns dato-indtastninger',
        'Here you can restrict the entering of dates of tickets.' => 'Her kan du begrænse dato-indtastningen på sager.',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Mulige værdier',
        'Key' => 'Nøgle',
        'Value' => 'Værdi',
        'Remove value' => 'Fjern værdi',
        'Add value' => 'Tilføj værdi',
        'Add Value' => 'Tilføj Værdi',
        'Add empty value' => 'Tilføj tom værdi',
        'Activate this option to create an empty selectable value.' => 'Aktiver denne valgmulighed for at oprette en tom, valgbar værdi.',
        'Tree View' => 'Træ-visning',
        'Activate this option to display values as a tree.' => 'Aktiver dette punkt for at vise værdier som et træ.',
        'Translatable values' => 'Oversættelige værdier',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Hvis du aktiverer denne valgmulighed, vil værdierne blive oversat til brugerens sprog.',
        'Note' => 'Note',
        'You need to add the translations manually into the language translation files.' =>
            'Du skal manuelt tilføje oversættelserne til oversættelses-filen.',

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Antal rækker',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Angiv højden (i linier) for dette felt, når det redigeres.',
        'Number of cols' => 'Antal kolonner',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Angiv bredden (i tegn) for dette felt, når det redigeres.',
        'Check RegEx' => 'Tjek RegEx',
        'Here you can specify a regular expression to check the value. The regex will be executed with the modifiers xms.' =>
            '',
        'RegEx' => 'RegEx',
        'Invalid RegEx' => 'Ugyldigt RegEx',
        'Error Message' => 'Fejlbesked',
        'Add RegEx' => 'Tilføj RegEx',

        # Template: AdminEmail
        'Admin Notification' => 'Besked til Admin',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Med dette modul kan administratorer sende beskeder til agenter, grupper eller rollemedlemmer.',
        'Create Administrative Message' => 'Opret administrativ besked',
        'Your message was sent to' => 'Din besked blev sendt til',
        'Send message to users' => 'Send besked til brugere',
        'Send message to group members' => 'Send besked til gruppemedlemmer',
        'Group members need to have permission' => 'Gruppemedlemmer skal have tilladelse',
        'Send message to role members' => 'Send besked til rollemedlemmer',
        'Also send to customers in groups' => 'Send også til kunder i grupper',
        'Body' => 'Hovedtekst',
        'Send' => 'Afsend',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Automatisk Agent',
        'Add job' => 'Tilføj job',
        'Last run' => 'Sidste kørsel',
        'Run Now!' => 'Kør nu',
        'Delete this task' => 'Slet dette job',
        'Run this task' => 'Kør job',
        'Do you really want to delete this task?' => 'Vil du virkelig slette denne opgave?',
        'Job Settings' => 'Job-indstillinger',
        'Job name' => 'Job-navn',
        'The name you entered already exists.' => 'Det indtastede navn eksisterer allerede.',
        'Toggle this widget' => 'Slå denne widget til eller fra',
        'Automatic execution (multiple tickets)' => 'Automatisk udførelse (flere sager)',
        'Execution Schedule' => 'Udførelses tidsplan',
        'Schedule minutes' => 'Planlæg minutter',
        'Schedule hours' => 'Planlæg timer',
        'Schedule days' => 'Planlæg dage',
        'Currently this generic agent job will not run automatically.' =>
            'Denne automatisk agent vil i øjeblikket ikke køre.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'For at aktivere automatisk kørsel, vælg mindst en værdi fra minutter, timer og dage.',
        'Event based execution (single ticket)' => 'Hændelsesbaseret tidsplan (enkelt sag)',
        'Event Triggers' => 'Hændelsens udløsere',
        'List of all configured events' => 'Liste med alle konfigurerede hændelser',
        'Delete this event' => 'Slet denne hændelse',
        'Additionally or alternatively to a periodic execution, you can define ticket events that will trigger this job.' =>
            '',
        'If a ticket event is fired, the ticket filter will be applied to check if the ticket matches. Only then the job is run on that ticket.' =>
            '',
        'Do you really want to delete this event trigger?' => 'Ønsker du at slette denne hændelses udløser',
        'Add Event Trigger' => 'Tilføj hændelses-udløser',
        'Add Event' => 'Tilføj hændelse',
        'To add a new event select the event object and event name and click on the "+" button' =>
            'For at tilføje en ny hændelse skal du vælge hændelses-objekt og navn og klikke på "+" knappen',
        'Duplicate event.' => 'Dubliker hændelse',
        'This event is already attached to the job, Please use a different one.' =>
            'Denne hændelse er allerede tilknyttet jobbet, brug venligst en anden.',
        'Delete this Event Trigger' => 'Slet denne hændelses udløser',
        'Remove selection' => 'Fjern markering',
        'Select Tickets' => 'Vælg sager',
        '(e. g. 10*5155 or 105658*)' => '(f.eks. 10*5155 eller 105658*)',
        '(e. g. 234321)' => '(f.eks. 234321)',
        'Customer user' => 'Kundebruger',
        '(e. g. U5150)' => '(f.eks. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Fuldtekst-søgning i indlæg (f.eks. "Mar*in" eller "Niels*").',
        'Agent' => 'Agent',
        'Ticket lock' => 'Tildelt',
        'Create times' => 'Oprettelsestider',
        'No create time settings.' => 'Angiv ikke oprettelsestid.',
        'Ticket created' => 'Sag oprettet',
        'Ticket created between' => 'Sag oprettet mellem',
        'Last changed times' => 'Sidst ændret tidspunkt',
        'No last changed time settings.' => 'Ingen sidst ændret tids indstilling',
        'Ticket last changed' => 'Sag sidst ændret',
        'Ticket last changed between' => 'Sag sidst ændret mellem',
        'Change times' => 'Ændringstider',
        'No change time settings.' => 'Angiv ikke ændringstider',
        'Ticket changed' => 'Sag ændret',
        'Ticket changed between' => 'Sag ændret mellem',
        'Close times' => 'Afslutningstider',
        'No close time settings.' => 'Angiv ikke Afslutningstid',
        'Ticket closed' => 'Sag lukket',
        'Ticket closed between' => 'Sag lukket mellem',
        'Pending times' => 'Afventer-tider',
        'No pending time settings.' => 'Ingen afventningsfrist.',
        'Ticket pending time reached' => 'Sagens afventningsfrist er nået',
        'Ticket pending time reached between' => 'Sagens afventningsfrist er nået mellem',
        'Escalation times' => 'Eskalationsfrister',
        'No escalation time settings.' => 'Ingen eskaleringsfrister',
        'Ticket escalation time reached' => 'Sagens eskaleringsfrist er nået',
        'Ticket escalation time reached between' => 'Sagens eskaleringsfrist er nået mellem',
        'Escalation - first response time' => 'Eskalation - frist for første svar',
        'Ticket first response time reached' => 'Sagens frist for første svar er nået',
        'Ticket first response time reached between' => 'Sagens frist for første svar er nået mellem',
        'Escalation - update time' => 'Eskalation - frist for opdatering',
        'Ticket update time reached' => 'Sagens opdateringsfrist er nået',
        'Ticket update time reached between' => 'Sagens opdateringsfrist er nået mellem',
        'Escalation - solution time' => 'Eskalation - frist for løsning',
        'Ticket solution time reached' => 'Sagens løsningsfrist er nået',
        'Ticket solution time reached between' => 'Sagens løsningsfrist er nået mellem',
        'Archive search option' => 'Arkivsøgevalg',
        'Update/Add Ticket Attributes' => 'Opdater/Tilføj Sags-attributter',
        'Set new service' => 'Vælg ny service',
        'Set new Service Level Agreement' => 'Vælg ny Service Level Agreement',
        'Set new priority' => 'Vælg ny prioritet',
        'Set new queue' => 'Vælg ny kø',
        'Set new state' => 'Vælg ny tilstand',
        'Pending date' => 'Afventer dato',
        'Set new agent' => 'Vælg ny agent',
        'new owner' => 'Ny ejer',
        'new responsible' => 'Ny ansvarlig',
        'Set new ticket lock' => 'Tildel ny sagsejer',
        'New customer user' => 'Ny kunde bruger',
        'New customer ID' => 'Nyt kunde-ID',
        'New title' => 'Ny titel',
        'New type' => 'Ny type',
        'New Dynamic Field Values' => 'Ny Dynamisk Felt-værdi',
        'Archive selected tickets' => 'Arkiver valgte sager',
        'Add Note' => 'Tilføj Bemærkning',
        'Time units' => 'Tidsenheder',
        'Execute Ticket Commands' => 'Udfør Sags-kommandoer',
        'Send agent/customer notifications on changes' => 'Send besked til agent/kunde ved ændringer',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Denne kommando vil blive udført. ARG[0] bliver sagens nummer. ARG[1] sagens ID. ',
        'Delete tickets' => 'Slet sager',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'Advarsel: Alle berørte sager vil blive fjernet fra databasen og kan ikke gendannes!',
        'Execute Custom Module' => 'Udfør speciel-modul',
        'Param %s key' => 'Param %s nøgle',
        'Param %s value' => 'Param %s værdi',
        'Save Changes' => 'Gem ændringer',
        'Results' => 'Resultater',
        '%s Tickets affected! What do you want to do?' => '%s sager vil blive berørt. Hvad vil du gøre?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'Advarsel: Du bruger SLET-muligheden. Alle slettede sager vil gå tabt!',
        'Warning: There are %s tickets affected but only %s may be modified during one job execution!' =>
            '',
        'Edit job' => 'Rediger job',
        'Run job' => 'Kør job',
        'Affected Tickets' => 'Berørte sager',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'You are here' => 'Du er her',
        'Web Services' => 'Web Tjenester',
        'Debugger' => 'Debugger',
        'Go back to web service' => 'Gå tilbage til web-service',
        'Clear' => 'Tøm',
        'Do you really want to clear the debug log of this web service?' =>
            'Vil du virkelig tømme debug-loggen for denne web-service?',
        'Request List' => '',
        'Time' => 'Tid',
        'Remote IP' => 'Fjern-IP',
        'Loading' => 'Indlæser',
        'Select a single request to see its details.' => '',
        'Filter by type' => 'Filtrer på type',
        'Filter from' => 'Filtrer fra',
        'Filter to' => 'Filtrer til',
        'Filter by remote IP' => 'Filtrer remote IP',
        'Limit' => 'Grænse',
        'Refresh' => 'Opfrisk',
        'Request Details' => '',
        'An error occurred during communication.' => 'En fejl skete under kommunikation.',
        'Show or hide the content.' => 'Vis eller skjul indholdet.',
        'Clear debug log' => 'Tøm debug-log',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => '',
        'Change Invoker %s of Web Service %s' => '',
        'Add new invoker' => '',
        'Change invoker %s' => '',
        'Do you really want to delete this invoker?' => '',
        'All configuration data will be lost.' => 'Alle konfigurationsindstillinger vil gå tabt.',
        'Invoker Details' => '',
        'The name is typically used to call up an operation of a remote web service.' =>
            '',
        'Please provide a unique name for this web service invoker.' => '',
        'Invoker backend' => '',
        'This OTRS invoker backend module will be called to prepare the data to be sent to the remote system, and to process its response data.' =>
            '',
        'Mapping for outgoing request data' => '',
        'Configure' => 'Konfigurer',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Asynchronous' => 'Asynkron',
        'This invoker will be triggered by the configured events.' => '',
        'Asynchronous event triggers are handled by the OTRS Scheduler Daemon in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => 'Gem og fortsæt',
        'Delete this Invoker' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => 'Gå tilbage til',
        'Mapping Simple' => '',
        'Default rule for unmapped keys' => '',
        'This rule will apply for all keys with no mapping rule.' => '',
        'Default rule for unmapped values' => '',
        'This rule will apply for all values with no mapping rule.' => '',
        'New key map' => 'Ny taste-binding',
        'Add key mapping' => 'Tilføj taste-binding',
        'Mapping for Key ' => 'Binding for tast',
        'Remove key mapping' => 'Fjern taste-binding',
        'Key mapping' => 'Taste-binding',
        'Map key' => 'Bind tast',
        'matching the' => 'matcher',
        'to new key' => 'til ny tast',
        'Value mapping' => '',
        'Map value' => '',
        'to new value' => '',
        'Remove value mapping' => '',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => 'Vil du virkelig fjerne denne taste-binding?',
        'Delete this Key Mapping' => 'Fjern denne taste-binding',

        # Template: AdminGenericInterfaceMappingXSLT
        'GenericInterface Mapping XSLT for Web Service %s' => '',
        'Mapping XML' => '',
        'Template' => 'Skabelon',
        'The entered data is not a valid XSLT stylesheet.' => 'De indtastede data er ikke et gyldigt XSLT stylesheet.',
        'Insert XSLT stylesheet.' => 'Indsæt XSLT stylesheet.',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Tilføj ny operation til web tjeneste %s',
        'Change Operation %s of Web Service %s' => '',
        'Add new operation' => 'Tilføj ny operation',
        'Change operation %s' => 'Ændr operation %s',
        'Do you really want to delete this operation?' => 'Vil du virkelig slette denne operation?',
        'Operation Details' => 'Operationsdetaljer',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => 'Angiv venligst et unikt navn til denne webtjeneste.',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => 'Slet denne operation',

        # Template: AdminGenericInterfaceTransportHTTPREST
        'GenericInterface Transport HTTP::REST for Web Service %s' => '',
        'Network transport' => '',
        'Properties' => 'Egenskaber',
        'Route mapping for Operation' => '',
        'Define the route that should get mapped to this operation. Variables marked by a \':\' will get mapped to the entered name and passed along with the others to the mapping. (e.g. /Ticket/:TicketID).' =>
            '',
        'Valid request methods for Operation' => '',
        'Limit this Operation to specific request methods. If no method is selected all requests will be accepted.' =>
            '',
        'Maximum message length' => 'Maksimal beskedlængde',
        'This field should be an integer number.' => 'Dette felt skal indeholde et heltal.',
        'Here you can specify the maximum size (in bytes) of REST messages that OTRS will process.' =>
            'Her kan du angive den maksimale længde (i bytes) af REST-beskeder, som OTRS vil behandle.',
        'Send Keep-Alive' => 'Send Keep-Alive',
        'This configuration defines if incoming connections should get closed or kept alive.' =>
            '',
        'Host' => 'Vært',
        'Remote host URL for the REST requests.' => '',
        'e.g https://www.otrs.com:10745/api/v1.0 (without trailing backslash)' =>
            'f.eks. https://www.otrs.com:10745/api/v1.0 (uden efterfølgende backslash)',
        'Controller mapping for Invoker' => '',
        'The controller that the invoker should send requests to. Variables marked by a \':\' will get replaced by the data value and passed along with the request. (e.g. /Ticket/:TicketID?UserLogin=:UserLogin&Password=:Password).' =>
            '',
        'Valid request command for Invoker' => '',
        'A specific HTTP command to use for the requests with this Invoker (optional).' =>
            '',
        'Default command' => 'Standard kommando',
        'The default HTTP command to use for the requests.' => '',
        'Authentication' => 'Godkendelse',
        'The authentication mechanism to access the remote system.' => 'Godkendelses-mekanisme for at tilgå fjernsystemet.',
        'A "-" value means no authentication.' => 'Et "-" betyder ingen godkendelse.',
        'The user name to be used to access the remote system.' => 'Brugernavnet, der skal anvendes for at tilgå fjernsystemet.',
        'The password for the privileged user.' => 'Passwordet for den priviligerede bruger.',
        'Use SSL Options' => 'Brug SSL',
        'Show or hide SSL options to connect to the remote system.' => 'Vis eller skjul SSL-muligheder for at forbinde til fjernsystemet.',
        'Certificate File' => 'Certifikat-fil',
        'The full path and name of the SSL certificate file.' => 'Den fulde sti og navn til SSL-certifikatfilen.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.crt' => 'f.eks. /opt/otrs/var/certificates/REST/ssl.crt',
        'Certificate Password File' => 'Certifikat adgangskode Fil',
        'The full path and name of the SSL key file.' => 'Fuld sti og navn på filen med SSL-nøglen.',
        'e.g. /opt/otrs/var/certificates/REST/ssl.key' => 'f.eks. /opt/otrs/var/certificates/REST/ssl.key',
        'Certification Authority (CA) File' => 'Certification Authority (CA) Fil',
        'The full path and name of the certification authority certificate file that validates the SSL certificate.' =>
            'Fuld sti og navn på CA certifikatfilen der validerer SSL certifikatet.',
        'e.g. /opt/otrs/var/certificates/REST/CA/ca.file' => 'f.eks. /opt/otrs/var/certificates/REST/CA/ca.file',

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
        'Request name free text' => '',
        'Text to be used to as function wrapper name suffix or replacement.' =>
            '',
        'Please consider XML element naming restrictions (e.g. don\'t use \'<\' and \'&\').' =>
            '',
        'Response name scheme' => '',
        'Select how SOAP response function wrapper should be constructed.' =>
            '',
        'Response name free text' => '',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => 'Kodning',
        'The character encoding for the SOAP message contents.' => 'Tekstkodning for SOAP indhold.',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'f.eks. utf-8, latin1, iso-8859-1, cp1250, osv.',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Proxy Server' => 'Proxy server',
        'URI of a proxy server to be used (if needed).' => 'URI af en proxy-server, der skal bruges (om nødvendigt).',
        'e.g. http://proxy_hostname:8080' => 'f.eks. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy brugernavn',
        'The user name to be used to access the proxy server.' => 'Brugernavnet der skal benyttes for adgang til proxy-serveren.',
        'Proxy Password' => 'Proxy adgangskode',
        'The password for the proxy user.' => 'Adgangskoden til proxy-brugeren.',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Den fulde sti og navn på SSL certifikat filen (skal være i .p12 format)',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => 'f.eks. /opt/otrs/var/certificates/SOAP/certificate.p12',
        'The password to open the SSL certificate.' => 'Koden til at åbne SSL certifikatet.',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            'Den fulde sti og navn på CA certifikat filen der validerer SSL certifikatet.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'f.eks. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => 'Certification Authority (CA) bibliotek',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            'Den fulde sti til biblioteket hvor CA certifikater gemmes i systemet.',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => 'f.eks. /opt/otrs/var/certificates/SOAP/CA',
        'Sort options' => 'Sorterings indstillinger',
        'Add new first level element' => '',
        'Element' => '',
        'Outbound sort order for xml fields (structure starting below function name wrapper) - see documentation for SOAP transport.' =>
            '',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => '',
        'Add web service' => 'Tilføj web-service',
        'Clone web service' => 'Klon web-service',
        'The name must be unique.' => 'Navnet skal være unikt.',
        'Clone' => 'Klon',
        'Export web service' => 'Eksporter web-service',
        'Import web service' => 'Importer web-service',
        'Configuration File' => 'Konfigurationsfil',
        'The file must be a valid web service configuration YAML file.' =>
            '',
        'Import' => 'Importer',
        'Configuration history' => 'Konfigurationshistorie',
        'Delete web service' => 'Slet web-service',
        'Do you really want to delete this web service?' => 'Vil du virkelig slette denne web-service?',
        'Ready-to-run Web Services' => '',
        'Here you can activate ready-to-run web services showcasing our best practices that are a part of %s.' =>
            '',
        'Please note that these web services may depend on other modules only available with certain %s contract levels (there will be a notification with further details when importing).' =>
            '',
        'Import ready-to-run web service' => '',
        'Would you like to benefit from web services created by experts? Upgrade to %s to import some sophisticated ready-to-run web services.' =>
            '',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => 'Web Tjeneste oversigt',
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
        'Delete webservice' => 'Slet webtjeneste',
        'Delete operation' => '',
        'Delete invoker' => '',
        'Clone webservice' => 'kopier webtjeneste',
        'Import webservice' => 'Importer webtjeneste',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => 'Gå tilbage til web-service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Her kan du se, eksportere eller gendanne ældre versioner af den aktive webtjenestes konfiguration.',
        'Configuration History List' => 'Historik over Konfigurationen',
        'Version' => 'Version',
        'Create time' => 'Oprettelsestidspunkt',
        'Select a single configuration version to see its details.' => 'Vælg en konfigurations version for at se detaljer.',
        'Export web service configuration' => 'Eksporter webtjeneste konfiguration',
        'Restore web service configuration' => 'Gendan webtjeneste konfiguration',
        'Do you really want to restore this version of the web service configuration?' =>
            'Ønsker du at gendanne denne version af webtjenestens konfiguration?',
        'Your current web service configuration will be overwritten.' => 'Din nuværende webtjeneste konfiguration bliver overskrevet.',
        'Restore' => 'Gendan',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ADVARSEL: Når du skifter navnet på gruppen \'admin\', før du laver de passende ændringer i SysConfig, vil du blive låst ude af administrationspanelet! Hvis det sker, skal du omdøbe gruppen tilbage til admin via SQL-statements.',
        'Group Management' => 'Gruppestyring',
        'Add group' => 'Tilføj gruppe',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            'Admin-gruppen giver adgang til administratorområdet og statgruppen giver adgang til rapportområdet.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Opret grupper for at give adgang til forskellige grupper af agenter (f.eks. indkøb, support, salg).',
        'It\'s useful for ASP solutions. ' => 'Det er nyttigt for ASP-løsninger.',
        'total' => 'i alt',
        'Add Group' => 'Tilføj Gruppe',
        'Edit Group' => 'Rediger Gruppe',

        # Template: AdminLog
        'System Log' => 'Systemlog',
        'Here you will find log information about your system.' => 'Her finder du log-information om dit system',
        'Hide this message' => 'Skjul denne besked',
        'Recent Log Entries' => 'Nylige log-føringer',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Administrer mail-konti',
        'Add mail account' => 'Tilføj mailkonto',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Alle indkommende mails med denne konto tildeles til den valgte kø.',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Er kontoen pålidelig, bliver X-OTRS-header-felter ved ankomsttidspunktet (for prioritering, osv.) anvendt. Der anvendes PostMaster-filter under alle omstændigheder.',
        'Delete account' => 'Slet konto',
        'Fetch mail' => 'Hent mail',
        'Add Mail Account' => 'Tilføj mailkonto',
        'Example: mail.example.com' => 'F.eks. post.firma.dk',
        'IMAP Folder' => 'IMAP-mappe',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Skal kun ændres, hvis du har behov for at hente mail fra en anden mappe end INBOX.',
        'Trusted' => 'Pålidelig',
        'Dispatching' => 'Tildeler',
        'Edit Mail Account' => 'Rediger mailkonto',

        # Template: AdminNavigationBar
        'Admin' => 'Admin',
        'Agent Management' => 'Administrer Agenter',
        'Queue Settings' => 'Administrer Køer',
        'Ticket Settings' => 'Administrer Sager',
        'System Administration' => 'Administrer System',
        'Online Admin Manual' => 'Online Admin Manual',

        # Template: AdminNotificationEvent
        'Ticket Notification Management' => 'Håndter sagsbeskeder',
        'Add notification' => 'Tilføj besked',
        'Export Notifications' => 'Eksporter beskeder',
        'Configuration Import' => 'Importer konfiguration',
        'Here you can upload a configuration file to import Ticket Notifications to your system. The file needs to be in .yml format as exported by the Ticket Notification module.' =>
            'Her kan du indlæse en konfigurationsfil for at importere sagsbeskeder til dit system. Filen skal være eksporteret i .yml format af sagsbesked-modulet.',
        'Overwrite existing notifications?' => 'Overskriv eksisterende beskeder?',
        'Upload Notification configuration' => 'Upload besked-konfiguration',
        'Import Notification configuration' => 'Importer besked-konfiguration',
        'Delete this notification' => 'Slet denne besked',
        'Do you really want to delete this notification?' => 'Ønsker du at slette denne besked?',
        'Add Notification' => 'Tilføj besked',
        'Edit Notification' => 'Rediger besked',
        'Show in agent preferences' => 'Vis i agent præferencer',
        'Agent preferences tooltip' => 'Agent præference værktøjstip',
        'This message will be shown on the agent preferences screen as a tooltip for this notification.' =>
            '',
        'Here you can choose which events will trigger this notification. An additional ticket filter can be applied below to only send for ticket with certain criteria.' =>
            '',
        'Ticket Filter' => 'Sagsfilter',
        'Article Filter' => 'Filtrer indlæg',
        'Only for ArticleCreate and ArticleSend event' => '',
        'Article type' => 'Indlægstype',
        'If ArticleCreate or ArticleSend is used as a trigger event, you need to specify an article filter as well. Please select at least one of the article filter fields.' =>
            '',
        'Article sender type' => 'Indlægs-afsendertype',
        'Subject match' => 'Match emne',
        'Body match' => 'Match brødtekst',
        'Include attachments to notification' => 'Inkluder vedhæftninger til beskeden',
        'Recipients' => 'Modtagere',
        'Send to' => 'Send til',
        'Send to these agents' => 'Send til disse agenter',
        'Send to all group members' => 'Send til alle gruppe medlemmer',
        'Send to all role members' => 'Send til alle rollemedlemmer',
        'Send on out of office' => 'Send ved ude af kontoret',
        'Also send if the user is currently out of office.' => 'Send også hvis brugeren er ude af kontoret.',
        'Once per day' => 'Dagligt',
        'Notify user just once per day about a single ticket using a selected transport.' =>
            '',
        'Notification Methods' => 'Beskedafgivelsesmetoder',
        'These are the possible methods that can be used to send this notification to each of the recipients. Please select at least one method below.' =>
            '',
        'Enable this notification method' => 'Aktiver denne beskedafgivelsesmetode',
        'Transport' => '',
        'At least one method is needed per notification.' => 'Mindst en metode er krævet pr. besked',
        'Active by default in agent preferences' => '',
        'This is the default value for assigned recipient agents who didn\'t make a choice for this notification in their preferences yet. If the box is enabled, the notification will be sent to such agents.' =>
            '',
        'This feature is currently not available.' => '',
        'No data found' => 'Ingen data fundet',
        'No notification method found.' => 'Ingen beskedafgivelsesmetode fundet.',
        'Notification Text' => 'Beskedtekst',
        'This language is not present or enabled on the system. This notification text could be deleted if it is not needed anymore.' =>
            'Dette sprog er deaktiveret eller ikke tilstede på dette system.  Denne besked-tekst  kan slettes hvis den ikke skal bruges mere.',
        'Remove Notification Language' => 'Fjern beskedsprog',
        'Message body' => '',
        'This field is required and must have less than 4000 characters.' =>
            '',
        'Add new notification language' => 'Tilføj beskedsprog',
        'Do you really want to delete this notification language?' => 'Er du sikker på at du vil slette dette beskedsprog',
        'Tag Reference' => '',
        'Notifications are sent to an agent or a customer.' => 'Beskeder sendes til en agent eller kunde.',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'For at få de første 20 tegn af emnet (af den seneste agent-indlæg).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'For at få de første 5 linier af indholdet (af den seneste agent-indlæg).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'For at få de første 20 tegn af emnet (af det seneste kunde-indlæg).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'For at få de første 5 linier af indholdet (af det seneste agent-indlæg).',
        'Attributes of the current customer user data' => '',
        'Attributes of the current ticket owner user data' => '',
        'Attributes of the current ticket responsible user data' => '',
        'Attributes of the current agent user who requested this action' =>
            '',
        'Attributes of the recipient user for the notification' => '',
        'Attributes of the ticket data' => '',
        'Ticket dynamic fields internal key values' => '',
        'Ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Example notification' => 'Eksempel på besked',

        # Template: AdminNotificationEventTransportEmailSettings
        'Additional recipient email addresses' => 'Yderligere modtageres email adresser',
        'You can use OTRS-tags like <OTRS_TICKET_DynamicField_...> to insert values from the current ticket.' =>
            '',
        'Notification article type' => 'Beskedens indlægstype',
        'An article will be created if the notification is sent to the customer or an additional email address.' =>
            '',
        'Email template' => 'Email skabelon',
        'Use this template to generate the complete email (only for HTML emails).' =>
            '',
        'Enable email security' => '',
        'Email security level' => '',
        'If signing key/certificate is missing' => '',
        'If encryption key/certificate is missing' => '',

        # Template: AdminOTRSBusinessInstalled
        'Manage %s' => 'Administrer %s',
        'Go to the OTRS customer portal' => '',
        'Downgrade to OTRS Free' => 'Nedgrader til OTRS Free',
        'Read documentation' => 'Læs dokumentation',
        '%s makes contact regularly with cloud.otrs.com to check on available updates and the validity of the underlying contract.' =>
            '%s kontakter cloud.otrs.com med jævne mellemrum for at søge efter opdateringer og tjekke validiteten af din kontrakt.',
        'Unauthorized Usage Detected' => 'Uautoriseret brug detekteret',
        'This system uses the %s without a proper license! Please make contact with %s to renew or activate your contract!' =>
            'Dette system bruger %s uden en gyldig licens! Kontakt venligst %s for at forny eller aktivere din kontrakt.',
        '%s not Correctly Installed' => '%s er ikke installeret korrekt.',
        'Your %s is not correctly installed. Please reinstall it with the button below.' =>
            'Din %s er ikke installeret korrekt. Geninstaller den med knappen nedenfor.',
        'Reinstall %s' => 'Geninstaller %s',
        'Your %s is not correctly installed, and there is also an update available.' =>
            'Din %s er ikke installeret korrekt, og der er også en opdatering tilgængelig.',
        'You can either reinstall your current version or perform an update with the buttons below (update recommended).' =>
            'Du kan enten geninstallere din nuværende version eller udføre en opdatering med knapperne nedenfor. Opdatering er anbefalet.',
        'Update %s' => 'Opdater %s',
        '%s Not Yet Available' => '%s er endnu ikke tilgængelig.',
        '%s will be available soon.' => '%s vil snart være tilgængelig.',
        '%s Update Available' => '%s opdatering tilgængelig.',
        'Package installation requires patch level update of OTRS.' => '',
        'Please visit our customer portal and file a request.' => '',
        'Everything else will be done as part of your contract.' => '',
        'Your installed OTRS version is %s.' => '',
        'To install the current version of OTRS Business Solution™, you need to update to OTRS %s or higher.' =>
            '',
        'To install the current version of OTRS Business Solution™, the Maximum OTRS Version is %s.' =>
            '',
        'To install this package, the required Framework version is %s.' =>
            '',
        'Why should I keep OTRS up to date?' => '',
        'You will receive updates about relevant security issues.' => '',
        'You will receive updates for all other relevant OTRS issues' => '',
        'An update for your %s is available! Please update at your earliest!' =>
            'En opdatering til din %s er tilgængelig. Opdater venligst hurtigst muligt.',
        '%s Correctly Deployed' => '%s korrekt installeret.',
        'Congratulations, your %s is correctly installed and up to date!' =>
            'Tillykke, din %s er korrekt installeret og up to date.',

        # Template: AdminOTRSBusinessNotInstalled
        '%s will be available soon. Please check again in a few days.' =>
            '%s vil være tilgængelig snart. Tjek igen om nogle dage.',
        'Please have a look at %s for more information.' => 'Kig på %s for yderligere information.',
        'Your OTRS Free is the base for all future actions. Please register first before you continue with the upgrade process of %s!' =>
            '',
        'Before you can benefit from %s, please contact %s to get your %s contract.' =>
            '',
        'Connection to cloud.otrs.com via HTTPS couldn\'t be established. Please make sure that your OTRS can connect to cloud.otrs.com via port 443.' =>
            'Forbindelse til cloud.otrs.com via HTTPS kunne ikke etableres. Sørg venligst for, at din OTRS kan forbinde sig til cloud.otrs.com via port 443.',
        'To install this package, you need to update to OTRS %s or higher.' =>
            '',
        'To install this package, the Maximum OTRS Version is %s.' => '',
        'With your existing contract you can only use a small part of the %s.' =>
            '',
        'If you would like to take full advantage of the %s get your contract upgraded now! Contact %s.' =>
            '',

        # Template: AdminOTRSBusinessUninstall
        'Cancel downgrade and go back' => 'Annuller nedgradering og gå tilbage',
        'Go to OTRS Package Manager' => 'Gå til OTRS Pakkestyring',
        'Sorry, but currently you can\'t downgrade due to the following packages which depend on %s:' =>
            'Beklager, men du kan ikke nedgradere nu, fordi følgende pakker er afhængige af %s:',
        'Vendor' => 'Leverandør',
        'Please uninstall the packages first using the package manager and try again.' =>
            'Afinstaller pakkerne først via pakke-styring og prøv igen.',
        'You are about to downgrade to OTRS Free and will lose the following features and all data related to these:' =>
            'Du er ved at nedgradere til OTRS Free og vil miste følgende funktioner og deres relaterede data:',
        'Chat' => 'Chat',
        'Report Generator' => 'Rapportgenerator',
        'Timeline view in ticket zoom' => '',
        'DynamicField ContactWithData' => '',
        'DynamicField Database' => '',
        'SLA Selection Dialog' => '',
        'Ticket Attachment View' => '',
        'The %s skin' => '%s-skin\'et',

        # Template: AdminPGP
        'PGP Management' => 'PGP-styring',
        'PGP support is disabled' => '',
        'To be able to use PGP in OTRS, you have to enable it first.' => '',
        'Enable PGP support' => '',
        'Faulty PGP configuration' => '',
        'PGP support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Configure it here!' => '',
        'Check PGP configuration' => '',
        'Add PGP key' => 'Tilføj PGP-nøgle',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'Du kan på denne måde direkte redigere den nøglering, der er konfigureret i SysConfig.',
        'Introduction to PGP' => 'Introduktion til PGP',
        'Result' => 'Resultat',
        'Identifier' => 'Identifikator',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingeraftryk',
        'Expires' => 'Udløber',
        'Delete this key' => 'Slet denne nøgle',
        'Add PGP Key' => 'Tilføj PGP-nøgle',
        'PGP key' => 'PGP-nøgle',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakkestyring',
        'Uninstall package' => 'Afinstaller pakke',
        'Do you really want to uninstall this package?' => 'Er du sikker på, du ønsker at afinstallere denne pakke?',
        'Reinstall package' => 'Geninstaller pakke',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Vil du virkelig geninstallere denne pakke? Alle manuelle ændringer vil gå tabt.',
        'Go to upgrading instructions' => '',
        'package information' => '',
        'Package installation requires a patch level update of OTRS.' => '',
        'Package update requires a patch level update of OTRS.' => '',
        'If you are a OTRS Business Solution™ customer, please visit our customer portal and file a request.' =>
            '',
        'Please note that your installed OTRS version is %s.' => '',
        'To install this package, you need to update OTRS to version %s or newer.' =>
            '',
        'This package can only be installed on OTRS version %s or older.' =>
            '',
        'This package can only be installed on OTRS version %s or newer.' =>
            '',
        'You will receive updates for all other relevant OTRS issues.' =>
            '',
        'How can I do a patch level update if I don’t have a contract?' =>
            '',
        'Please find all relevant information within the upgrading instructions at %s.' =>
            '',
        'In case you would have further questions we would be glad to answer them.' =>
            'Hvis du har yderligere spørgsmål, vil vi glædeligt besvare dem.',
        'Continue' => 'Fortsæt',
        'Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Sørg for at din database accepterer pakker over %s MB i størrelse. I øjeblikket accepterer den kun pakker op til %s MB. Tilpas max_allowed_packet-indstillingen i din database for at undgå fejl.',
        'Install' => 'Installation',
        'Install Package' => 'Installer pakke',
        'Update repository information' => 'Opdater information i repositoriet',
        'Cloud services are currently disabled.' => '',
        'OTRS Verify™ can not continue!' => '',
        'Enable cloud services' => '',
        'Online Repository' => 'Online lagerdepot',
        'Module documentation' => 'Modul-dokumentation',
        'Upgrade' => 'Opgrader',
        'Local Repository' => 'Lokalt lagerdepot',
        'This package is verified by OTRSverify (tm)' => 'Denne pakke er verificeret af OTRSverify (tm)',
        'Uninstall' => 'Afinstaller',
        'Reinstall' => 'Geninstaller',
        'Features for %s customers only' => '',
        'With %s, you can benefit from the following optional features. Please make contact with %s if you need more information.' =>
            '',
        'Download package' => 'Download pakke',
        'Rebuild package' => 'Genopbyg pakke',
        'Metadata' => 'Metadata',
        'Change Log' => 'Ændringslog',
        'Date' => 'Dato',
        'List of Files' => 'Liste af filer',
        'Permission' => 'Tilladdelse',
        'Download' => 'Download',
        'Download file from package!' => 'Download fil fra pakke!',
        'Required' => 'Påkrævet',
        'Primary Key' => '',
        'Auto Increment' => '',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Fil-difference for fil %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Ydelseslog',
        'This feature is enabled!' => 'Denne funktion er aktiveret',
        'Just use this feature if you want to log each request.' => 'Benyt denne funktion hvis du ønsker at alle forespørgsler skal logges.',
        'Activating this feature might affect your system performance!' =>
            'Aktivering af denne funktion kan have indflydelse på systemets ydeevne',
        'Disable it here!' => 'Deaktiver det her!',
        'Logfile too large!' => 'Logfil er for stor',
        'The logfile is too large, you need to reset it' => 'Logfilen er for stor, du bør nulstille den',
        'Overview' => 'Oversigt',
        'Range' => 'Område',
        'last' => 'sidste',
        'Interface' => 'Interface',
        'Requests' => 'Forespørgsel',
        'Min Response' => 'Min Svar',
        'Max Response' => 'Max Svar',
        'Average Response' => 'Gennemsnitligt Svar',
        'Period' => 'Periode',
        'Min' => 'Min',
        'Max' => 'Max',
        'Average' => 'Gennemsnitlig',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMasters filterstyring',
        'Add filter' => 'Tilføj filter',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'For at fordele eller filtrere indgående mail baseret på mail-headere. Det er også muligt at macthe på regulære udtryk.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Hvis du kun ønsker at matche mail adressen, så brug EMAILADDRESS:info@example.com i Fra, Til eller Cc.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Hvis du bruger regulære udtryk, kan du også bruge den matchede værdi i (), som [***] i \'Set\'-handlingen.',
        'Delete this filter' => 'Slet dette filter',
        'Do you really want to delete this filter?' => '',
        'Add PostMaster Filter' => 'Tilføj Postmaster-filter',
        'Edit PostMaster Filter' => 'Rediger Postmaster-filter',
        'A postmaster filter with this name already exists!' => '',
        'Filter Condition' => 'Filter-betingelse',
        'AND Condition' => 'AND-betingelse',
        'Check email header' => 'Tjek mail-header',
        'Negate' => 'Ophæv',
        'Look for value' => 'Søg efter værdi',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Feltet skal indeholde et gyldigt regulært udtryk eller et ord.',
        'Set Email Headers' => 'Sæt mail-headers',
        'Set email header' => 'Sæt mail-header',
        'Set value' => 'Sæt værdi',
        'The field needs to be a literal word.' => 'Feltet skal være et ord.',

        # Template: AdminPriority
        'Priority Management' => 'Administrer Prioriteter',
        'Add priority' => 'Tilføj prioritet',
        'Add Priority' => 'Tilføj prioritet',
        'Edit Priority' => 'Rediger prioritet',

        # Template: AdminProcessManagement
        'Process Management' => 'Proces styring',
        'Filter for Processes' => 'Filter for processer',
        'Create New Process' => 'Opret ny proces',
        'Deploy All Processes' => 'Aktiver alle processer',
        'Here you can upload a configuration file to import a process to your system. The file needs to be in .yml format as exported by process management module.' =>
            'Her kan du indlæse en konfigurationsfil for at importere en proces til dit system. Filen skal være eksporteret i .yml format af proces modulet.',
        'Overwrite existing entities' => 'Overskriv eksisterende enheder',
        'Upload process configuration' => 'Upload proces-konfiguration',
        'Import process configuration' => 'Importer proces-konfiguration',
        'Ready-to-run Processes' => '',
        'Here you can activate ready-to-run processes showcasing our best practices. Please note that some additional configuration may be required.' =>
            '',
        'Would you like to benefit from processes created by experts? Upgrade to %s to import some sophisticated ready-to-run processes.' =>
            '',
        'Import ready-to-run process' => '',
        'To create a new Process you can either import a Process that was exported from another system or create a complete new one.' =>
            'For at lave en ny proces kan du enten importere en proces fra et andet system eller kreere en helt ny.',
        'Changes to the Processes here only affect the behavior of the system, if you synchronize the Process data. By synchronizing the Processes, the newly made changes will be written to the Configuration.' =>
            'Ændringer af disse processer får kun indflydelse på systemet hvis du synkroniserer procesdata. Ved synkronisering skrives ændringerne i konfigurationen.',
        'Processes' => 'Processer',
        'Process name' => 'Proces-navn',
        'Print' => 'Udskrift',
        'Export Process Configuration' => 'Eksporter proces-konfiguration',
        'Copy Process' => 'Kopier proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close' => 'Annuller & Luk',
        'Go Back' => 'Gå tilbage',
        'Please note, that changing this activity will affect the following processes' =>
            'Bemærk, ændring af denne aktivitet påvirker følgende processer',
        'Activity' => 'Aktivitet',
        'Activity Name' => 'Aktivitetsnavn',
        'Activity Dialogs' => 'Aktivitetsdialoger',
        'You can assign Activity Dialogs to this Activity by dragging the elements with the mouse from the left list to the right list.' =>
            'Du kan tilføje dialoger til denne aktivitet, ved at trække dem med musen fra venstre liste og over i højre.',
        'Ordering the elements within the list is also possible by drag \'n\' drop.' =>
            'Det er også muligt at arrangere elementerne i listen v.h.a. træk og slip.',
        'Filter available Activity Dialogs' => 'Filtrer tilgængelige aktivitets dialoger',
        'Available Activity Dialogs' => 'Tilgængelige aktivitets dialoger',
        'Name: %s, EntityID: %s' => '',
        'Create New Activity Dialog' => 'Opret ny aktivitets dialog',
        'Assigned Activity Dialogs' => 'Tildelte aktivitets dialoger',
        'As soon as you use this button or link, you will leave this screen and its current state will be saved automatically. Do you want to continue?' =>
            '',

        # Template: AdminProcessManagementActivityDialog
        'Please note that changing this activity dialog will affect the following activities' =>
            '',
        'Please note that customer users will not be able to see or use the following fields: Owner, Responsible, Lock, PendingTime and CustomerID.' =>
            '',
        'The Queue field can only be used by customers when creating a new ticket.' =>
            '',
        'Activity Dialog' => 'Aktivitets dialog',
        'Activity dialog Name' => 'Aktivitets dialog navn',
        'Available in' => '',
        'Description (short)' => '',
        'Description (long)' => '',
        'The selected permission does not exist.' => '',
        'Required Lock' => '',
        'The selected required lock does not exist.' => '',
        'Submit Advice Text' => '',
        'Submit Button Text' => '',
        'Fields' => 'Felter',
        'You can assign Fields to this Activity Dialog by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available fields' => '',
        'Available Fields' => 'Tilgængelige felter',
        'Name: %s' => '',
        'Assigned Fields' => 'Tildelte felter',
        'ArticleType' => 'IndlægsType',
        'Display' => 'Vis',
        'Edit Field Details' => '',
        'Customer interface does not support internal article types.' => 'Kundeinterfacet understøtter ikke interne indlægs-typer.',

        # Template: AdminProcessManagementPath
        'Path' => 'Sti',
        'Edit this transition' => 'Rediger denne overgang',
        'Transition Actions' => '',
        'You can assign Transition Actions to this Transition by dragging the elements with the mouse from the left list to the right list.' =>
            '',
        'Filter available Transition Actions' => '',
        'Available Transition Actions' => '',
        'Create New Transition Action' => '',
        'Assigned Transition Actions' => '',

        # Template: AdminProcessManagementProcessAccordion
        'Activities' => 'Aktiviteter',
        'Filter Activities...' => '',
        'Create New Activity' => 'Opret ny aktivitet',
        'Filter Activity Dialogs...' => '',
        'Transitions' => 'Overgange',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Rediger proces',
        'Print process information' => '',
        'Delete Process' => 'Slet proces',
        'Delete Inactive Process' => 'Slet inaktiv proces',
        'Available Process Elements' => '',
        'The Elements listed above in this sidebar can be moved to the canvas area on the right by using drag\'n\'drop.' =>
            '',
        'You can place Activities on the canvas area to assign this Activity to the Process.' =>
            '',
        'To assign an Activity Dialog to an Activity drop the Activity Dialog element from this sidebar over the Activity placed in the canvas area.' =>
            '',
        'You can start a connection between two Activities by dropping the Transition element over the Start Activity of the connection. After that you can move the loose end of the arrow to the End Activity.' =>
            '',
        'Actions can be assigned to a Transition by dropping the Action Element onto the label of a Transition.' =>
            '',
        'Edit Process Information' => 'Rediger proces-information',
        'Process Name' => 'Proces-navn',
        'The selected state does not exist.' => 'Den valgte tilstand findes ikke.',
        'Add and Edit Activities, Activity Dialogs and Transitions' => '',
        'Show EntityIDs' => '',
        'Extend the width of the Canvas' => '',
        'Extend the height of the Canvas' => '',
        'Remove the Activity from this Process' => '',
        'Edit this Activity' => 'Rediger denne aktivitet',
        'Save Activities, Activity Dialogs and Transitions' => '',
        'Do you really want to delete this Process?' => 'Vil du virkelig slette denne proces?',
        'Do you really want to delete this Activity?' => 'Vil du virkelig slette denne aktivitet?',
        'Do you really want to delete this Activity Dialog?' => 'Vil du virkelig slette denne aktivitets-dialog?',
        'Do you really want to delete this Transition?' => 'Vil du virkelig slette denne overgang?',
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
        'cancel & close' => '',
        'Start Activity' => 'Start aktivitet',
        'Contains %s dialog(s)' => 'Indeholder %s dialoger',
        'Assigned dialogs' => 'Tildelte dialoger',
        'Activities are not being used in this process.' => '',
        'Assigned fields' => 'Tildelte delter',
        'Activity dialogs are not being used in this process.' => '',
        'Condition linking' => 'Link betingelser',
        'Conditions' => 'Betingelser',
        'Condition' => 'Betingelse',
        'Transitions are not being used in this process.' => '',
        'Module name' => 'Modul navn',
        'Transition actions are not being used in this process.' => '',

        # Template: AdminProcessManagementTransition
        'Please note that changing this transition will affect the following processes' =>
            '',
        'Transition' => 'Overgang',
        'Transition Name' => '',
        'Conditions can only operate on non-empty fields.' => '',
        'Type of Linking between Conditions' => 'Linktype mellem betingelser',
        'Remove this Condition' => 'Fjern denne betingelse',
        'Type of Linking' => '',
        'Add a new Field' => 'Tilføj et nyt felt',
        'Remove this Field' => 'Fjern dette felt',
        'And can\'t be repeated on the same condition.' => 'Og kan ikke gentages for den samme betingelse',
        'Add New Condition' => 'Tilføj ny betingelse',

        # Template: AdminProcessManagementTransitionAction
        'Please note that changing this transition action will affect the following processes' =>
            '',
        'Transition Action' => '',
        'Transition Action Name' => '',
        'Transition Action Module' => '',
        'Config Parameters' => '',
        'Add a new Parameter' => '',
        'Remove this Parameter' => '',

        # Template: AdminQueue
        'Manage Queues' => 'Administrer Køer',
        'Add queue' => 'Tilføj kø',
        'Add Queue' => 'Tilføj kø',
        'Edit Queue' => 'Rediger kø',
        'A queue with this name already exists!' => 'En kø med dette navn findes allerede.',
        'Sub-queue of' => 'Underkø af',
        'Unlock timeout' => 'Tidsfrist for frigivelse',
        '0 = no unlock' => '0 = ingen frigivelse',
        'Only business hours are counted.' => 'Kun normal kontor tid er beregnet.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Hvis en agent trækker sagen og ikke lukker den før frigivelses-timeout, vil sagen blive frigivet og gjort tilgængelig for andre agenter.',
        'Notify by' => 'Adviser ved',
        '0 = no escalation' => '0 = ingen eskalering',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Hvis der ikke har været kontakt fra kunden, enten via mail eller telefon, vedr. en ny sag inden den specificerede tid udløber, bliver sagen eskaleret.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Hvis et indlæg tilføjes, som f.eks. en opfølging via mail eller kunde-portalen, nulstilles eskalerings-tiden. Hvis der ikke har været kontakt fra kunden, enten via mail eller telefon, tilføjet sagen inden den specificerede tid udløber, bliver sagen eskaleret.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Hvis sagen ikke er lukket inden den specificerede tid, bliver sagen eskaleret.',
        'Follow up Option' => 'Opfølgningsmulighed',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Angiver, om opfølginger på lukkede sager vil resultere i en genåbning af sagen, en afvisning af opfølgningen eller en ny sag.',
        'Ticket lock after a follow up' => 'Sag tildelt efter opfølgning på lukket sag',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Hvis en kunde sender en opfølging på en lukket sag, vil sagen blive tildelt dens sidste ejer.',
        'System address' => 'Systemadresse',
        'Will be the sender address of this queue for email answers.' => 'Bliver til denne køs afsenderadresse for mail-svar.',
        'Default sign key' => 'Standard signeringsnøgle',
        'The salutation for email answers.' => 'Den hilsen, der bruges til mail-svar.',
        'The signature for email answers.' => 'Den signatur, der bruges til mail-svar.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Administrer Kø/Autosvar-relationer',
        'This filter allow you to show queues without auto responses' => '',
        'Queues without auto responses' => '',
        'This filter allow you to show all queues' => 'Dette filter tillader dig at vise alle køer',
        'Show all queues' => 'Vis alle køer',
        'Filter for Queues' => 'Filtrer køer',
        'Filter for Auto Responses' => 'Filtrer autosvar',
        'Auto Responses' => 'Autosvar',
        'Change Auto Response Relations for Queue' => 'Administrer autosvar-relationer for kø',

        # Template: AdminQueueTemplates
        'Manage Template-Queue Relations' => 'Administrer Skabelon/Kø-relationer',
        'Filter for Templates' => 'Filter for skabeloner',
        'Templates' => 'Skabeloner',
        'Change Queue Relations for Template' => 'Ændr Kø-relationer for Skabelon',
        'Change Template Relations for Queue' => 'Ændr Skabelon-relationer for Kø',

        # Template: AdminRegistration
        'System Registration Management' => '',
        'Edit details' => 'Rediger detaljer',
        'Show transmitted data' => 'Vis overførte data',
        'Deregister system' => 'Afregistrer system',
        'Overview of registered systems' => 'Oversigt over registrerede systemer',
        'This system is registered with OTRS Group.' => 'Dette system er registreret hos OTRS Group.',
        'System type' => 'System-type',
        'Unique ID' => 'Unikt ID',
        'Last communication with registration server' => 'Seneste kommunikation med registrerings-server',
        'System registration not possible' => 'Det er ikke muligt at registrere systemet.',
        'Please note that you can\'t register your system if OTRS Daemon is not running correctly!' =>
            'Bemærk at du ikke kan registrere dit system hvis ikke OTRS tjenesten fungerer korrekt!',
        'Instructions' => 'Instruktioner',
        'System deregistration not possible' => 'Det er ikke muligt at afregistrere systemet.',
        'Please note that you can\'t deregister your system if you\'re using the %s or having a valid service contract.' =>
            'Bemærk at du ikke kan afregistrere systemet hvis du benytter %s eller hvis du har en gyldig service kontrakt.',
        'OTRS-ID Login' => 'OTRS-ID Login',
        'Read more' => 'Læs mere',
        'You need to log in with your OTRS-ID to register your system.' =>
            'Du skal logge ind med dit OTRS-ID for at registrere dit system',
        'Your OTRS-ID is the email address you used to sign up on the OTRS.com webpage.' =>
            'Dit OTRS-ID er den mail-adresse, du tilmeldte dig med op OTRS.com-hjemmesiden.',
        'Data Protection' => 'Data-beskyttelse',
        'What are the advantages of system registration?' => 'Hvad er fordelene ved at registrere systemet?',
        'You will receive updates about relevant security releases.' => 'Du vil modtage opdateringer om relevante sikkerheds-udgivelser.',
        'With your system registration we can improve our services for you, because we have all relevant information available.' =>
            'Vi kan levere en bedre service til dig ved hjælp af din system registrering, fordi vi har alle relevante oplysninger tilgængelig.',
        'This is only the beginning!' => 'Dette er kun begyndelsen!',
        'We will inform you about our new services and offerings soon.' =>
            '',
        'Can I use OTRS without being registered?' => 'Kan jeg bruge OTRS uden at registrere?',
        'System registration is optional.' => 'Registrering er valgfrit.',
        'You can download and use OTRS without being registered.' => 'Du kan downloade og bruge OTRS uden at registrere.',
        'Is it possible to deregister?' => 'Er det muligt at afregistrere?',
        'You can deregister at any time.' => 'Du kan afregistrere til enhver tid.',
        'Which data is transfered when registering?' => 'Hvilke data bliver sendt ved registrering?',
        'A registered system sends the following data to OTRS Group:' => 'Et registreret system sender følgende data til OTRS Group:',
        'Fully Qualified Domain Name (FQDN), OTRS version, Database, Operating System and Perl version.' =>
            'Fully Qualified Domain Name (FQDN), OTRS-version, Database, Operativsystem og Perl-version.',
        'Why do I have to provide a description for my system?' => 'Hvorfor skal jeg give en beskrivelse for mit system?',
        'The description of the system is optional.' => 'Beskrivelsen af dit system er valgfri.',
        'The description and system type you specify help you to identify and manage the details of your registered systems.' =>
            'Beskrivelsen og typen, som du angiver, hjælper dig med at identificere og administrere dine registrerede systemer.',
        'How often does my OTRS system send updates?' => 'Hvor ofte sender mit OTRS-system opdateringer?',
        'Your system will send updates to the registration server at regular intervals.' =>
            'Dit system vil sende opdateringer til registrerings-serveren med jævne mellemrum',
        'Typically this would be around once every three days.' => 'Normalt er det omkring én gang hver tredie dag.',
        'Please visit our' => 'Besøg vores',
        'portal' => 'portal',
        'and file a request.' => 'og opret en sag.',
        'If you deregister your system, you will lose these benefits:' =>
            'Hvis du afregistrerer dit system mister du disse fordele:',
        'You need to log in with your OTRS-ID to deregister your system.' =>
            'Du skal logge ind med dit OTRS-ID for at afregistrere dit system.',
        'OTRS-ID' => 'OTRS-ID',
        'You don\'t have an OTRS-ID yet?' => 'Har du ikke et OTRS-ID endnu?',
        'Sign up now' => 'Registrer dig nu',
        'Forgot your password?' => 'Glemt dit password?',
        'Retrieve a new one' => 'Få et nyt',
        'This data will be frequently transferred to OTRS Group when you register this system.' =>
            'Disse data bliver jævnligt overført til OTRS koncernen når du registrerer dit system',
        'Attribute' => 'Attribut',
        'FQDN' => 'FQDN',
        'OTRS Version' => 'OTRS-version',
        'Operating System' => 'Operativ-system',
        'Perl Version' => 'Perl-version',
        'Optional description of this system.' => 'Valgfri beskrivelse af dette system.',
        'Register' => 'Registrer',
        'Deregister System' => 'Afregistrer system',
        'Continuing with this step will deregister the system from OTRS Group.' =>
            'Hvis du fortsætter afregistreres dit system hos OTRS koncernen.',
        'Deregister' => 'Afregistrer',
        'You can modify registration settings here.' => 'Du kan ændre registrerings indstillingerne her.',
        'Overview of transmitted data' => 'Oversigt over sendte data',
        'There is no data regularly sent from your system to %s.' => '',
        'The following data is sent at minimum every 3 days from your system to %s.' =>
            '',
        'The data will be transferred in JSON format via a secure https connection.' =>
            '',
        'System Registration Data' => '',
        'Support Data' => '',

        # Template: AdminRole
        'Role Management' => 'Rollestyring',
        'Add role' => 'Tilføj rolle',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Opret en rolle og indsæt grupper i den. Tilføj dernæst brugernes rolle.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Der er ikke defineret nogen roller. Brug \'Tilføj rolle\'-knappen for at oprette en ny rolle.',
        'Add Role' => 'Tilføj rolle',
        'Edit Role' => 'Rediger rolle',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Administrer Rolle/Gruppe-relationer',
        'Filter for Roles' => 'Filtrer roller',
        'Roles' => 'Roller',
        'Select the role:group permissions.' => 'Vælg rolle:gruppe-rettigheder',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Hvis intet er valgt, er der ingen tilladelser i denne gruppe (sager vil ikke være tilgængelige for rollen).',
        'Change Role Relations for Group' => 'Administrer Rolle-relationer for Gruppe',
        'Change Group Relations for Role' => 'Administrer Gruppe-relationer for Rolle',
        'Toggle %s permission for all' => 'Skift %s-tilladelse for alle',
        'move_into' => 'flyt_til',
        'Permissions to move tickets into this group/queue.' => 'Tilladelser til at flytte sager ind i denne gruppe/kø.',
        'create' => 'opret',
        'Permissions to create tickets in this group/queue.' => 'Tilladelser til at oprette sager i denne gruppe/kø.',
        'note' => 'note',
        'Permissions to add notes to tickets in this group/queue.' => 'Rettigheder til at tilføje noter til sager i denne gruppe/kø.',
        'owner' => 'ejer',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Rettigheder til at ændre ejer på sager i denne gruppe/kø',
        'priority' => 'prioritering',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Tilladelser til at ændre sagprioriteringen i denne gruppe/kø.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Administrer agent/rolle-relationer',
        'Add agent' => 'Tilføj agent',
        'Filter for Agents' => 'Filtrer agenter',
        'Agents' => 'Agenter',
        'Manage Role-Agent Relations' => 'Administrer rolle/agent-relationer',
        'Change Role Relations for Agent' => 'Skift rolle-relationer for agent',
        'Change Agent Relations for Role' => 'Skift agent-relationer for rolle',

        # Template: AdminSLA
        'SLA Management' => 'SLA Administration',
        'Add SLA' => 'Tilføj SLA',
        'Edit SLA' => 'Rediger SLA',
        'Please write only numbers!' => 'Angiv venligst kun tal!',

        # Template: AdminSMIME
        'S/MIME Management' => 'S/MIME Styring',
        'SMIME support is disabled' => '',
        'To be able to use SMIME in OTRS, you have to enable it first.' =>
            '',
        'Enable SMIME support' => '',
        'Faulty SMIME configuration' => '',
        'SMIME support is enabled, but the relevant configuration contains errors. Please check the configuration using the button below.' =>
            '',
        'Check SMIME configuration' => '',
        'Add certificate' => 'Tilføj certifikat',
        'Add private key' => 'Tilføj private nøgle',
        'Filter for certificates' => 'Filter for certifikater',
        'Filter for S/MIME certs' => 'Filter for S/MIME-certifikater',
        'To show certificate details click on a certificate icon.' => 'Klik på et certifikat-ikon for at se certifikatets detaljer',
        'To manage private certificate relations click on a private key icon.' =>
            'Klik på Privatnøgle-ikonet for at administrere private certifikater.',
        'Here you can add relations to your private certificate, these will be embedded to the S/MIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Se også',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Du kan på denne måde direkte redigere certificeringsnøgler og private nøgler i filsystemet.',
        'Hash' => 'Hash',
        'Handle related certificates' => 'Håndter relaterede certifikater',
        'Read certificate' => 'Læs certifikat',
        'Delete this certificate' => 'Slet dette certifikat',
        'Add Certificate' => 'Tilføj certifikat',
        'Add Private Key' => 'Tilføj privat nøgle',
        'Secret' => 'Hemmelig',
        'Related Certificates for' => 'Relaterede certifikater for',
        'Delete this relation' => 'Slet denne relation',
        'Available Certificates' => 'Tilgængelige Certifikater',
        'Relate this certificate' => 'Relater dette certifikat',

        # Template: AdminSMIMECertRead
        'Close dialog' => '',
        'Certificate details' => 'Certifikat-detaljer',

        # Template: AdminSalutation
        'Salutation Management' => 'Administrer Indledninger',
        'Add salutation' => 'Tilføj indledning',
        'Add Salutation' => 'Tilføj Indledning',
        'Edit Salutation' => 'Rediger Indledning',
        'e. g.' => 'f.eks.',
        'Example salutation' => 'Eksempel på indledning',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Secure mode skal aktiveres!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Secure Mode vil (normalt) blive aktiveret efter den indledende installation er fuldført.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Hvis Secure Mode ikke er aktiveret, så aktiver det via SysConfig, da din applikation allerede kører.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database. It is not possible to change the content of the tables, only select queries are allowed.' =>
            '',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Her kan du indtaste SQL og sende de direkte til applikations-databasen.',
        'Only select queries are allowed.' => '',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Din SQL-syntax indeholder fejl. Tjek den venligst.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Der mangler mindst et parameter for bindingen. Tjek det venligst.',
        'Result format' => 'Resultatformat',
        'Run Query' => 'Kør forespørgsel',
        'Query is executed.' => 'Forespørgslen er udført',

        # Template: AdminService
        'Service Management' => 'Administrer Services',
        'Add service' => 'Tilføj service',
        'Add Service' => 'Tilføj service',
        'Edit Service' => 'Rediger service',
        'Service name maximum length is 200 characters (with Sub-service).' =>
            '',
        'Sub-service of' => 'Under-service af',

        # Template: AdminSession
        'Session Management' => 'Sessionsstyring',
        'All sessions' => 'Alle sessioner',
        'Agent sessions' => 'Agent-sessioner',
        'Customer sessions' => 'Kunde-sessioner',
        'Unique agents' => 'Ukikke agenter',
        'Unique customers' => 'Unikke kunder',
        'Kill all sessions' => 'Dræb alle sessioner',
        'Kill this session' => 'Dræb denne session',
        'Session' => 'Session',
        'Kill' => 'Dræb',
        'Detail View for SessionID' => 'Detaljer for SessionID',

        # Template: AdminSignature
        'Signature Management' => 'Administrer signaturer',
        'Add signature' => 'Tilføj signatur',
        'Add Signature' => 'Tilføj Signatur',
        'Edit Signature' => 'Rediger signatur',
        'Example signature' => 'Eksempel på signatur',

        # Template: AdminState
        'State Management' => 'Administrer Tilstande',
        'Add state' => 'Tilføj tilstand',
        'Please also update the states in SysConfig where needed.' => 'Husk også at opdatere tilstandene i SysConfig, hvor der er behov for det.',
        'Add State' => 'Tilføj tilstand',
        'Edit State' => 'Rediger tilstand',
        'State type' => 'Tilstandstype',

        # Template: AdminSupportDataCollector
        'Sending support data to OTRS Group is not possible!' => '',
        'Enable Cloud Services' => '',
        'This data is sent to OTRS Group on a regular basis. To stop sending this data please update your system registration.' =>
            '',
        'You can manually trigger the Support Data sending by pressing this button:' =>
            '',
        'Send Update' => 'Send Opdatering',
        'Sending Update...' => 'Sender Opdatering...',
        'Support Data information was successfully sent.' => 'Support Data afsendt med succes.',
        'Was not possible to send Support Data information.' => 'Det var ikke muligt at sende Support Data.',
        'Update Result' => 'Opdater resultat',
        'Currently this data is only shown in this system.' => '',
        'A support bundle (including: system registration information, support data, a list of installed packages and all locally modified source code files) can be generated by pressing this button:' =>
            '',
        'Generate Support Bundle' => 'Generer Support Pakke',
        'Generating...' => 'Genererer...',
        'It was not possible to generate the Support Bundle.' => 'Det var ikke muligt at generere Support Pakken.',
        'Generate Result' => 'Generer resultat',
        'Support Bundle' => 'Support Pakke',
        'The mail could not be sent' => 'Mailen kunne ikke sendes',
        'The support bundle has been generated.' => 'Support Pakken er genereret.',
        'Please choose one of the following options.' => 'Vælg venligst en af følgende muligheder.',
        'Send by Email' => 'Send via mail',
        'The support bundle is too large to send it by email, this option has been disabled.' =>
            'Support Pakken er for stor til at kunne sendes via email, denne mulighed er deaktiveret.',
        'The email address for this user is invalid, this option has been disabled.' =>
            'Email adressen til denne bruger er ugyldig, denne mulighed er deaktiveret.',
        'Sending' => 'Sender',
        'The support bundle will be sent to OTRS Group via email automatically.' =>
            'Support Pakken sendes automatisk via email til OTRS Group',
        'Download File' => 'Hent fil',
        'A file containing the support bundle will be downloaded to the local system. Please save the file and send it to the OTRS Group, using an alternate method.' =>
            'Supportpakken downloades på det lokale system. Gem venligst filen og send den til OTRS Group.',
        'Error: Support data could not be collected (%s).' => 'Fejl: Supportdata kunne ikke indsamles (%s).',
        'Details' => 'Detaljer',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => 'Søg i alle %s konfigurationsindstillinger.',
        'Navigate by selecting config groups' => 'Vælg konfigurationsgrupper',
        'Download all system config changes' => 'Download alle ændringer i systemkonfigurationen',
        'Export settings' => 'Eksporter konfiguration',
        'Load SysConfig settings from file' => 'Indlæs SysConfig-konfiguration fra fil',
        'Import settings' => 'Importer konfiguration',
        'Import Settings' => 'Importer Konfiguration',
        'Please enter a search term to look for settings.' => 'Indtast søgeord for at lede i konfigurationen.',
        'Subgroup' => 'Undergruppe',
        'Elements' => 'Elementer',

        # Template: AdminSysConfigEdit
        'Edit Config Settings in %s → %s' => 'Rediger indstillinger for %s → %s',
        'This setting is read only.' => 'Denne indstilling kan ikke ændres.',
        'This config item is only available in a higher config level!' =>
            'Dette konfigurationsparameter er kun tilgængeligt på et højere konfigurationsniveau!',
        'Reset this setting' => 'Nulstil denne indstilling',
        'Error: this file could not be found.' => 'Fejl: Denne fil kan ikke findes.',
        'Error: this directory could not be found.' => 'Fejl: Dette biblotek kan ikke findes.',
        'Error: an invalid value was entered.' => 'Fejl: En ugyldig værdi er indtastet.',
        'Content' => 'Indhold',
        'Remove this entry' => 'Fjern denne parameter',
        'Add entry' => 'Tilføj parameter',
        'Remove entry' => 'Fjern parameter',
        'Add new entry' => 'Tilføj nyt parameter',
        'Delete this entry' => 'Slet dette svar',
        'Create new entry' => 'Opret nyt parameter',
        'New group' => 'Ny gruppe',
        'Group ro' => 'Gruppe read-only',
        'Readonly group' => 'Readonly-gruppe',
        'New group ro' => 'Ny gruppe read-only',
        'Loader' => 'Indlæser',
        'File to load for this frontend module' => 'Fil, der skal indlæses til dette frontend-modul',
        'New Loader File' => 'Ny indlæsningsfil',
        'NavBarName' => 'NavBarNavn',
        'NavBar' => 'NavBar',
        'LinkOption' => 'LinkMulighed',
        'Block' => 'Blok',
        'AccessKey' => 'AdgangsNøgle',
        'Add NavBar entry' => 'Tilføj punkt til NavBar',
        'NavBar module' => '',
        'Year' => 'År',
        'Month' => 'Måned',
        'Day' => 'Dag',
        'Invalid year' => 'Ugyldigt år',
        'Invalid month' => 'Ugyldig måned',
        'Invalid day' => 'Ugyldig dag',
        'Show more' => 'Vis mere',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Administrer systemets mail-adresser',
        'Add system address' => 'Tilføj systemadresse',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Alt indgående mail med denne adresse i Til eller Cc, vil blive sendt til den valgte kø.',
        'Email address' => 'Mail-adresse',
        'Display name' => 'Vist navn',
        'Add System Email Address' => 'Tilføj system-mail-adresse',
        'Edit System Email Address' => 'Rediger system-mail-adresse',
        'This email address is already used as system email address.' => '',
        'The display name and email address will be shown on mail you send.' =>
            'Vist navn og mail-adresse vil blive vist på mail, du sender.',
        'This system address cannot be set to invalid, because it is used in one or more queue(s).' =>
            '',

        # Template: AdminSystemMaintenance
        'System Maintenance Management' => 'System vedligeholdelse',
        'Schedule New System Maintenance' => 'Planlæg ny system vedligeholdelse',
        'Schedule a system maintenance period for announcing the Agents and Customers the system is down for a time period.' =>
            '',
        'Some time before this system maintenance starts the users will receive a notification on each screen announcing about this fact.' =>
            '',
        'Start date' => 'Start dato',
        'Stop date' => 'Slut dato',
        'Delete System Maintenance' => 'Slet Systemvedligehold',
        'Do you really want to delete this scheduled system maintenance?' =>
            'Vil du virkelig fjerne denne planlagte systemvedligeholdelse?',

        # Template: AdminSystemMaintenanceEdit
        'Edit System Maintenance %s' => 'Rediger systemvedligeholdelse %s',
        'Edit System Maintenance Information' => '',
        'Date invalid!' => 'Ugyldig dato',
        'Login message' => 'Login besked',
        'Show login message' => 'Vis login besked',
        'Notify message' => '',
        'Manage Sessions' => 'Administrer sessioner',
        'All Sessions' => 'Alle sessioner',
        'Agent Sessions' => 'Agent-sessioner',
        'Customer Sessions' => 'Kunde-sessioner',
        'Kill all Sessions, except for your own' => 'Afbryd alle sessioner, undtagen din egen',

        # Template: AdminTemplate
        'Manage Templates' => 'Administrer skabeloner',
        'Add template' => 'Tilføj skabelon',
        'A template is a default text which helps your agents to write faster tickets, answers or forwards.' =>
            'En skabelon er en standard-tekst, der hjælper dine agenter til at skrive hurtigere sager, svar og videresendelser.',
        'Don\'t forget to add new templates to queues.' => 'Husk at tilføje nye skabeloner til køer.',
        'Do you really want to delete this template?' => '',
        'Add Template' => 'Tilføj skabelon',
        'Edit Template' => 'Rediger skabelon',
        'A standard template with this name already exists!' => 'En standard-skabelon med dette navn eksisterer allerede!',
        'Create type templates only supports this smart tags' => 'Skabeloner af typen \'Opret\' understøtter kun disse smart tags',
        'Example template' => 'Eksempel-skabelon',
        'The current ticket state is' => 'Den aktuelle sags status er',
        'Your email address is' => 'Din mail-adresse er',

        # Template: AdminTemplateAttachment
        'Manage Templates <-> Attachments Relations' => 'Administrer relationer mellem skabeloner og vedhæftede filer',
        'Filter for Attachments' => 'Filter for vedhæftede filer',
        'Change Template Relations for Attachment' => 'Ændr Skabelonens relation til vedhæftede filer',
        'Change Attachment Relations for Template' => 'Ændr den vedhæftede fils relation til skabeloner',
        'Toggle active for all' => 'Skift aktiv for alle',
        'Link %s to selected %s' => 'Kæd %s til valgte %s',

        # Template: AdminType
        'Type Management' => 'Administrer Typer',
        'Add ticket type' => 'Tilføj sagstype',
        'Add Type' => 'Tilføj type',
        'Edit Type' => 'Rediger type',
        'A type with this name already exists!' => 'En type med dette navn eksisterer allerede!',

        # Template: AdminUser
        'Agents will be needed to handle tickets.' => 'Agenter skal oprettes for at kunne håndtere sager.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Glem ikke at tilføje nye agenter til grupper og/eller roller!',
        'Please enter a search term to look for agents.' => 'Angiv en søgestreng for at lede efter agenter.',
        'Last login' => 'Seneste Login',
        'Switch to agent' => 'Skift til agent',
        'Add Agent' => 'Tilføj agent',
        'Edit Agent' => 'Rediger agent',
        'Title or salutation' => 'Titel eller titulering',
        'Firstname' => 'Fornavn',
        'Lastname' => 'Efternavn',
        'A user with this username already exists!' => 'En bruger med dette brugernavn eksisterer allerede!',
        'Will be auto-generated if left empty.' => 'Bliver autogenereret, hvis ikke udfyldt.',
        'Start' => 'Start',
        'End' => 'Slut',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Administrer Agent/Gruppe-relationer',
        'Change Group Relations for Agent' => 'Skift gruppe-relationer for agent',
        'Change Agent Relations for Group' => 'Skift agent-relationer for gruppe',

        # Template: AgentBook
        'Address Book' => 'Adressebog',
        'Search for a customer' => 'Søg efter en kunde',
        'Add email address %s to the To field' => 'Tilføj mail-adresse %s til Til-feltet',
        'Add email address %s to the Cc field' => 'Tilføj mail-adresse %s til Cc-feltet',
        'Add email address %s to the Bcc field' => 'Tilføj mail-adresse %s til Bcc-feltet',
        'Apply' => 'Opdater',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Kundeinformations-center',

        # Template: AgentCustomerInformationCenterSearch
        'Customer User' => 'Kundebruger',

        # Template: AgentCustomerSearch
        'Duplicated entry' => 'Dublet',
        'This address already exists on the address list.' => 'Denne adresse eksisterer allerede i adresselisten.',
        'It is going to be deleted from the field, please try again.' => 'Det vil blive slettet fra feltet. Prøv venligst igen.',

        # Template: AgentCustomerTableView
        'Note: Customer is invalid!' => 'Bemærk: Kunden er ugyldig',
        'Start chat' => 'Start chat',
        'Video call' => '',
        'Audio call' => '',

        # Template: AgentDaemonInfo
        'The OTRS Daemon is a daemon process that performs asynchronous tasks, e.g. ticket escalation triggering, email sending, etc.' =>
            'OTRS tjenesten er en tjeneste der udfører asynkrone opgaver, f.eks. sags eskalering, afsendelse af email, osv.',
        'A running OTRS Daemon is mandatory for correct system operation.' =>
            'En kørende OTRS tjeneste er påkrævet for korrekt system operation.',
        'Starting the OTRS Daemon' => 'Starter OTRS tjeneste',
        'Make sure that the file \'%s\' exists (without .dist extension). This cron job will check every 5 minutes if the OTRS Daemon is running and start it if needed.' =>
            'Kontroller at filen \'%s\' eksisterer (uden .dist filendelsen). Dette cron job  checker hvert 5. minut om OTRS tjenesten kører og starter den om nødvendigt.',
        'Execute \'%s start\' to make sure the cron jobs of the \'otrs\' user are active.' =>
            'Kør \'%s start\' for at sikre at \'otrs\' brugerens cron job er aktive.',
        'After 5 minutes, check that the OTRS Daemon is running in the system (\'bin/otrs.Daemon.pl status\').' =>
            'Check at OTRS tjenesten kører efter 5 minutter (\'bin/otrs.Daemon.pl status\').',

        # Template: AgentDashboard
        'Dashboard' => 'Oversigt',

        # Template: AgentDashboardCalendarOverview
        'in' => 'om',

        # Template: AgentDashboardCommon
        'Close this widget' => 'Luk widget',
        'Available Columns' => 'Tilgængelige kolonner',
        'Visible Columns (order by drag & drop)' => 'Synlige kolonner (flyt dem med musen)',

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eskalerede sager',

        # Template: AgentDashboardCustomerUserList
        'Customer login' => 'Kunde-login',
        'Customer information' => 'Kundeinformation',
        'Phone ticket' => 'Sager',
        'Email ticket' => 'Mail-sager',
        '%s open ticket(s) of %s' => '%s åbne sager af %s',
        '%s closed ticket(s) of %s' => '%s lukkede sager af %s',
        'New phone ticket from %s' => 'Nye sager fra %s',
        'New email ticket to %s' => 'Nye mail-sager til %s',

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s er tilgængelig',
        'Please update now.' => 'Opdater venligst.',
        'Release Note' => 'Udgivelsesnote',
        'Level' => 'Niveau',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Offentliggjort %s siden.',

        # Template: AgentDashboardStats
        'The configuration for this statistic widget contains errors, please review your settings.' =>
            'Konfigurationen for denne rapport-widget har fejl. Tjek venligst dine indstillinger.',
        'Download as SVG file' => 'Hent som SVG fil',
        'Download as PNG file' => 'Hent som PNG fil',
        'Download as CSV file' => 'Hent som CSV fil',
        'Download as Excel file' => 'Hent som Excel fil',
        'Download as PDF file' => 'Hent som PDF fil',
        'Grouped' => 'Grupperet',
        'Stacked' => 'Stakket',
        'Expanded' => 'Udvidet',
        'Stream' => 'Strøm',
        'No Data Available.' => '',
        'Please select a valid graph output format in the configuration of this widget.' =>
            '',
        'The content of this statistic is being prepared for you, please be patient.' =>
            'Indholdet af rapporten forberedes, vær tålmodig.',
        'This statistic can currently not be used because its configuration needs to be corrected by the statistics administrator.' =>
            'Rapporten kan ikke bruges i øjeblikket, da den afventer at konfigurationen bliver korrigeret af rapport-administratoren.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mine sager',
        'My watched tickets' => 'Sager, jeg følger',
        'My responsibilities' => 'Sager, jeg er ansvarlig for',
        'Tickets in My Queues' => 'Sager i Mine Køer',
        'Tickets in My Services' => 'Sager i mine services',
        'Service Time' => 'Servicetid',
        'Remove active filters for this widget.' => 'Fjern aktive filtre for denne widget.',

        # Template: AgentDashboardTicketQueueOverview
        'Totals' => 'Totaler',

        # Template: AgentDashboardUserOnline
        'out of office' => 'ude af kontoret',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'til',

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Sagen er blevet trukket',
        'Undo & close' => 'Afbryd og luk',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'For at acceptere nogle nyheder, en lices eller nogle ændringer.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Kæd objekt: %s',
        'go to link delete screen' => 'gå til skærmen, hvor links kan slettes',
        'Select Target Object' => 'Vælg destinations-objekt',
        'Link object %s with' => '',
        'Unlink Object: %s' => 'Fjern k?dning af objekt: %s',
        'go to link add screen' => 'gå til skærmen, hvor links kan tilføjes',

        # Template: AgentOTRSBusinessBlockScreen
        'Unauthorized usage of %s detected' => '',
        'If you decide to downgrade to OTRS Free, you will lose all database tables and data related to %s.' =>
            '',

        # Template: AgentPreferences
        'Edit your preferences' => 'Opdater dine indstillinger',
        'Did you know? You can help translating OTRS at %s.' => 'Vidste du det? Du kan hjælpe med at oversætte OTRS på %s.',

        # Template: AgentSpelling
        'Spell Checker' => 'Stavekontrol',
        'spelling error(s)' => 'stavefejl',
        'Apply these changes' => 'Anvend disse ændringer',

        # Template: AgentStatisticsAdd
        'Statistics » Add' => 'Rapporter » Tilføj',
        'Add New Statistic' => 'Tilføj ny rapport',
        'Dynamic Matrix' => 'Dynamisk matrix',
        'Tabular reporting data where each cell contains a singular data point (e. g. the number of tickets).' =>
            '',
        'Dynamic List' => 'Dynamisk liste',
        'Tabular reporting data where each row contains data of one entity (e. g. a ticket).' =>
            '',
        'Static' => 'Statisk',
        'Complex statistics that cannot be configured and may return non-tabular data.' =>
            'Komplekse rapporter, der ikke kan konfigureres i web-interfacet.',
        'General Specification' => 'Generel Specifikation',
        'Create Statistic' => 'Opret Rapport',

        # Template: AgentStatisticsEdit
        'Statistics » Edit %s%s — %s' => 'Rapporter » Rediger %s%s — %s',
        'Run now' => 'Kør nu',
        'Statistics Preview' => 'Forhåndsvisning af Rapport',
        'Save statistic' => 'Gem rapport',

        # Template: AgentStatisticsImport
        'Statistics » Import' => 'Rapport » Import',
        'Import Statistic Configuration' => 'Importer Rapport-konfiguration',

        # Template: AgentStatisticsOverview
        'Statistics » Overview' => 'Rapporter » Oversigt',
        'Statistics' => 'Rapporter',
        'Run' => 'Kør',
        'Edit statistic "%s".' => 'Rediger rapport "%s".',
        'Export statistic "%s"' => 'Eksporter rapport "%s"',
        'Export statistic %s' => 'Eksporter rapport %s',
        'Delete statistic "%s"' => 'Slet rapport "%s"',
        'Delete statistic %s' => 'Slet rapport %s',
        'Do you really want to delete this statistic?' => 'Vil du virkelig slette denne rapport?',

        # Template: AgentStatisticsView
        'Statistics » View %s%s — %s' => 'Rapporter » Vis %s%s — %s',
        'Statistic Information' => 'Rapport-information',
        'Sum rows' => 'Summer rækker',
        'Sum columns' => 'Summer Kolonner',
        'Show as dashboard widget' => 'Vis på dashboardet som widget',
        'Cache' => 'Cache',
        'This statistic contains configuration errors and can currently not be used.' =>
            'Denne rapport er fejlkonfigureret og kan ikke benyttes i øjeblikket.',

        # Template: AgentTicketActionCommon
        'Change Free Text of %s%s%s' => '',
        'Change Owner of %s%s%s' => '',
        'Close %s%s%s' => '',
        'Add Note to %s%s%s' => '',
        'Set Pending Time for %s%s%s' => '',
        'Change Priority of %s%s%s' => '',
        'Change Responsible of %s%s%s' => '',
        'All fields marked with an asterisk (*) are mandatory.' => 'Alle felter markeret med en stjerne er obligatoriske.',
        'Service invalid.' => 'Ugyldig service.',
        'New Owner' => 'Ny Ejer',
        'Please set a new owner!' => 'Vælg venligst en ny ejer!',
        'New Responsible' => 'Ny Ansvarlig',
        'Next state' => 'Næste status',
        'For all pending* states.' => 'For alle afventende* tilstande.',
        'Add Article' => 'Tilføj Indlæg',
        'Create an Article' => 'Opret et Indlæg',
        'Inform agents' => 'Informer agenter',
        'Inform involved agents' => 'Informer involverede agenter',
        'Here you can select additional agents which should receive a notification regarding the new article.' =>
            'Her kan du vælge yderligere agenter der skal have besked om den nye artikel.',
        'Text will also be received by' => '',
        'Spell check' => 'Stavekontrol',
        'Text Template' => 'Tekst-skabelon',
        'Setting a template will overwrite any text or attachment.' => 'Angivelse af skabelon vil overskrive enhver tekst eller vedhæftning.',
        'Note type' => 'Bemærkningstype',

        # Template: AgentTicketBounce
        'Bounce %s%s%s' => '',
        'Bounce to' => 'Overgiv til',
        'You need a email address.' => 'Du mangler en mail-adresse',
        'Need a valid email address or don\'t use a local email address.' =>
            'Der mangler en gyldig mail-adresse. Brug ikke en lokal mail-adresse.',
        'Next ticket state' => 'Sagens næste status',
        'Inform sender' => 'Informer afsender',
        'Send mail' => 'Send mail',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Massehandling',
        'Send Email' => 'Send mail',
        'Merge to' => 'Saml til',
        'Invalid ticket identifier!' => 'Ugyldig sagsidentifikation!',
        'Merge to oldest' => 'Saml til ældste',
        'Link together' => 'Kæd sammen',
        'Link to parent' => 'Kæd til forælder',
        'Unlock tickets' => 'Frigiv sager',
        'Execute Bulk Action' => 'Udfør massehandling',

        # Template: AgentTicketCompose
        'Compose Answer for %s%s%s' => '',
        'This address is registered as system address and cannot be used: %s' =>
            'Denne adresse er registreret som systemadresse og kan ikke benyttes: %s',
        'Please include at least one recipient' => 'Der skal være mindst én modtager.',
        'Remove Ticket Customer' => 'Fjern Sagens Kunde',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Fjern venligst denne indtastning og skriv en ny med den korrekte værdi.',
        'Remove Cc' => 'Fjern Cc',
        'Remove Bcc' => 'Fjern Bcc',
        'Address book' => 'Adressebog',
        'Date Invalid!' => 'Ugyldig dato!',

        # Template: AgentTicketCustomer
        'Change Customer of %s%s%s' => '',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Opret ny mail-sag',
        'Example Template' => 'Eksempel-skabelon',
        'From queue' => 'Fra kø',
        'To customer user' => 'Til kundebruger',
        'Please include at least one customer user for the ticket.' => 'Inkluder venligst mindst en kundebruger til sagen',
        'Select this customer as the main customer.' => 'Vælg denne kunde som sagens hovedkunde',
        'Remove Ticket Customer User' => 'Fjern kundebruger fra sagen',
        'Get all' => 'Hent alle',

        # Template: AgentTicketEmailOutbound
        'Outbound Email for %s%s%s' => '',

        # Template: AgentTicketEscalation
        'Ticket %s: first response time is over (%s/%s)!' => 'Sag %s: Tid til første svar er overskredet (%s/%s)!',
        'Ticket %s: first response time will be over in %s/%s!' => 'Sag %s: Tid til første svar overskrides om %s/%s!',
        'Ticket %s: update time is over (%s/%s)!' => '',
        'Ticket %s: update time will be over in %s/%s!' => '',
        'Ticket %s: solution time is over (%s/%s)!' => 'Sag %s: Tid til løsning er overskredet (%s/%s)!',
        'Ticket %s: solution time will be over in %s/%s!' => 'Sag %s: Tid til løsning overskrides om %s/%s!',

        # Template: AgentTicketForward
        'Forward %s%s%s' => '',

        # Template: AgentTicketHistory
        'History of %s%s%s' => '',
        'History Content' => 'Historik',
        'Zoom view' => 'Zoom-visning',

        # Template: AgentTicketMerge
        'Merge %s%s%s' => '',
        'Merge Settings' => 'Saml indstillinger',
        'You need to use a ticket number!' => 'Du skal bruge et sagsnummer.',
        'A valid ticket number is required.' => 'Angiv et gyldigt sagsnummer',
        'Need a valid email address.' => 'Angiv en gyldig mail-adresse',

        # Template: AgentTicketMove
        'Move %s%s%s' => '',
        'New Queue' => 'Ny Kø',

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Vælg alle',
        'No ticket data found.' => 'Ingen sager fundet.',
        'Open / Close ticket action menu' => '',
        'Select this ticket' => 'Vælg denne sag',
        'First Response Time' => 'Frist til første svar',
        'Update Time' => 'Opdateringstid',
        'Solution Time' => 'Løsningstid',
        'Move ticket to a different queue' => 'Flyt sag til anden kø',
        'Change queue' => 'Skift kø',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Skift søgemuligheder',
        'Remove active filters for this screen.' => 'Fjern aktive filtre for dette billede.',
        'Tickets per page' => 'Sager pr. side',

        # Template: AgentTicketOverviewSmall
        'Reset overview' => 'Nulstil oversigt',
        'Column Filters Form' => 'Kolonnefiltre',

        # Template: AgentTicketPhone
        'Split Into New Phone Ticket' => '',
        'Save Chat Into New Phone Ticket' => '',
        'Create New Phone Ticket' => 'Opret ny sag',
        'Please include at least one customer for the ticket.' => 'Der skal være mindst én kunde til sagen.',
        'To queue' => 'Til kø',
        'Chat protocol' => '',
        'The chat will be appended as a separate article.' => 'Chatten vil blive tilføjet som et separat indlæg.',

        # Template: AgentTicketPhoneCommon
        'Phone Call for %s%s%s' => '',

        # Template: AgentTicketPlain
        'View Email Plain Text for %s%s%s' => '',
        'Plain' => 'Kildetekst',
        'Download this email' => 'Download denne mail',

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => 'Proces',

        # Template: AgentTicketProcessSmall
        'Enroll Ticket into a Process' => '',

        # Template: AgentTicketSearch
        'Search template' => 'Søgeskabelon',
        'Create Template' => 'Opret skabelon',
        'Create New' => 'Opret ny',
        'Profile link' => 'Link til profil',
        'Save changes in template' => 'Gem ændringer i skabelon',
        'Filters in use' => 'Aktive filtre',
        'Additional filters' => 'Yderligere filtre',
        'Add another attribute' => 'Tilføj endnu en attribut',
        'Output' => 'Output',
        'Fulltext' => 'Fritekst',
        'Remove' => 'Fjern',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'CustomerID (complex search)' => '',
        '(e. g. 234*)' => '',
        'CustomerID (exact match)' => '',
        'Customer User Login (complex search)' => '',
        '(e. g. U51*)' => '',
        'Customer User Login (exact match)' => '',
        'Attachment Name' => 'Vedhæftningsnavn',
        '(e. g. m*file or myfi*)' => '(f.eks. m*fil eller minfi*)',
        'Created in Queue' => 'Oprettet i kø',
        'Lock state' => 'Tildelt/fri',
        'Watcher' => 'Fulgte af',
        'Article Create Time (before/after)' => 'Indlæg skrevet (før/efter)',
        'Article Create Time (between)' => 'Indlæg skrevet (mellem)',
        'Invalid date' => '',
        'Ticket Create Time (before/after)' => 'Sag oprettet (før/efter)',
        'Ticket Create Time (between)' => 'Sag oprettet (mellem)',
        'Ticket Change Time (before/after)' => 'Sag ændret (før/efter)',
        'Ticket Change Time (between)' => 'Sag ændret (mellem)',
        'Ticket Last Change Time (before/after)' => 'Sag sidst ændret (før/efter)',
        'Ticket Last Change Time (between)' => 'Sag sidst ændret (mellem)',
        'Ticket Close Time (before/after)' => 'Sag lukket (før/efter)',
        'Ticket Close Time (between)' => 'Sag lukket (mellem)',
        'Ticket Escalation Time (before/after)' => 'Sag eskaleret (før/efter)',
        'Ticket Escalation Time (between)' => 'Sag eskaleret (mellem)',
        'Archive Search' => 'Arkivsøgning',
        'Run search' => 'Søg',

        # Template: AgentTicketZoom
        'Article filter' => 'Filtrer indlæg',
        'Article Type' => 'Indlægstype',
        'Sender Type' => 'Afsendertype',
        'Save filter settings as default' => 'Gem disse filterinstillinger som standard',
        'Event Type Filter' => 'Hændelsestype-filter',
        'Event Type' => 'Hændelsestype',
        'Save as default' => 'Gem som standard',
        'Archive' => 'Arkiver',
        'This ticket is archived.' => 'Denne sag er arkiveret',
        'Note: Type is invalid!' => 'Obs: Ugyldig type!',
        'Locked' => 'Tildelt',
        'Accounted time' => 'Benyttet tid',
        'Linked Objects' => 'Sammenkædede objekter',
        'Change Queue' => 'Skift kø',
        'There are no dialogs available at this point in the process.' =>
            'Der er ingen dialoger tilgængelige på dette sted i processen.',
        'This item has no articles yet.' => '',
        'Ticket Timeline View' => '',
        'Article Overview' => 'Indlægsoversigt',
        'Article(s)' => 'Indlæg',
        'Page' => 'Side',
        'Add Filter' => 'Tilføj filter',
        'Set' => 'Indstil',
        'Reset Filter' => 'Nulstil filter',
        'Show one article' => 'Vis indlæg enkeltvis',
        'Show all articles' => 'Vis alle indlæg',
        'Show Ticket Timeline View' => '',
        'Unread articles' => 'Ulæste indlæg',
        'No.' => 'Nr.',
        'Important' => 'Vigtigt',
        'Unread Article!' => 'Ulæst indlæg',
        'Incoming message' => 'Indgående besked',
        'Outgoing message' => 'Udgående besked',
        'Internal message' => 'Intern besked',
        'Resize' => 'Ændr størrelse',
        'Mark this article as read' => 'Marker dette indlæg som læst',
        'Show Full Text' => 'Vis hele teksten',
        'Full Article Text' => 'Indlæggets fulde tekst',
        'No more events found. Please try changing the filter settings.' =>
            '',
        'by' => 'af',
        'To open links in the following article, you might need to press Ctrl or Cmd or Shift key while clicking the link (depending on your browser and OS).' =>
            '',
        'Close this message' => 'Luk denne besked',
        'Article could not be opened! Perhaps it is on another article page?' =>
            'Et indlæg kunne ikke åbnes! Måske er det på en anden indlægs side?',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'For at beskytte dit privatliv blev fjernindhold blokeret.',
        'Load blocked content.' => 'Vis blokeret indhold',

        # Template: ChatStartForm
        'First message' => '',

        # Template: CloudServicesDisabled
        'This feature requires cloud services.' => '',
        'You can' => 'Du kan',
        'go back to the previous page' => 'gå tilbage til den forrige side',

        # Template: CustomerAccept
        'Information' => 'Information',
        'Dear Customer,' => '',
        'thank you for using our services.' => '',
        'Yes, I accepted your license.' => '',

        # Template: CustomerError
        'An Error Occurred' => '',
        'Error Details' => 'Fejldetaljer',
        'Traceback' => 'Tilbagesporing',

        # Template: CustomerFooter
        'Powered by' => ' ',

        # Template: CustomerFooterJS
        'One or more errors occurred!' => 'En eller flere fejl opstod!',
        'Close this dialog' => 'Luk dette vindue',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Kan ikke åbne nyt vindue. Deaktiver din browsers popup-blokering for denne applikation.',
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Hvis du forlader denne side, vil alle pop-up vinduer også blive lukket!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Et pop-up vindue med dette billede er allerede åbent. Vil du lukke det og åbne denne i stedet?',
        'There are currently no elements available to select from.' => 'Der er i øjeblikket ingen elementer at vælge fra.',
        'Please turn off Compatibility Mode in Internet Explorer!' => 'Slå venligst kompatibilitet fra i Internet Explorer!',
        'The browser you are using is too old.' => 'Din browser er for gammel.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS virker med en masse browsere, opgrader venligst til en af disse.',
        'Please see the documentation or ask your admin for further information.' =>
            'Se venligst dokumentationen eller kontakt din administrator for yderligere information.',
        'Switch to mobile mode' => 'Skift til mobil-tilstand',
        'Switch to desktop mode' => 'Skift til desktop-tilstand',
        'Not available' => 'Ikke tilgængelig',
        'Clear all' => 'Slet alt',
        'Clear search' => 'Slet søgning',
        '%s selection(s)...' => '%s udvalgt(e)...',
        'and %s more...' => 'og %s flere...',
        'Filters' => 'Filtre',
        'Confirm' => 'Bekræft',
        'You have unanswered chat requests' => '',
        'Accept' => '',
        'Decline' => '',
        'An internal error occurred.' => '',
        'Connection error' => '',
        'Reload page' => '',
        'Your browser was not able to communicate with OTRS properly, there seems to be something wrong with your network connection. You could either try reloading this page manually or wait until your browser has re-established the connection on its own.' =>
            '',
        'There was an error in communication with the server. Server might be experiencing some temporary problems, please reload this page to check if they have been resolved.' =>
            '',
        'The connection has been re-established after a temporary connection loss. Due to this, elements on this page could have stopped to work correctly. In order to be able to use all elements correctly again, it is strongly recommended to reload this page.' =>
            '',

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript ikke tilgængeligt',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'For at opleve OTRS, skal du aktivere JavaScript i din browser.',
        'Browser Warning' => 'Browser-advarsel',
        'One moment please, you are being redirected...' => 'Et øjeblik, du stilles videre...',
        'Login' => 'Login',
        'User name' => 'Brugernavn',
        'Your user name' => 'Dit brugernavn',
        'Your password' => 'Dit password',
        'Forgot password?' => 'Glemt dit password?',
        '2 Factor Token' => '2 Faktor Token',
        'Your 2 Factor Token' => 'Dit 2 Faktor Token',
        'Log In' => 'Login',
        'Not yet registered?' => 'Endnu ikke registreret?',
        'Request new password' => 'Anmod om ny adgangskode',
        'Your User Name' => 'Dit brugernavn',
        'A new password will be sent to your email address.' => 'Et nyt password bliver sendt til din mail-adresse.',
        'Create Account' => 'Opret konto',
        'Please fill out this form to receive login credentials.' => 'Udfyld venligst denne formular for at modtage login-oplysninger',
        'How we should address you' => 'Hvordan skal vi tiltale dig',
        'Your First Name' => 'Dit fornavn',
        'Your Last Name' => 'Dit efternavn',
        'Your email address (this will become your username)' => 'Din mail-adresse (den bliver dit brugernavn)',

        # Template: CustomerNavigationBar
        'Incoming Chat Requests' => '',
        'Edit personal preferences' => 'Rediger dine personlige indstillinger',
        'Logout %s %s' => 'Logaf %s %s',

        # Template: CustomerRichTextEditor
        'Split Quote' => '',
        'Open link' => 'Åbn link',

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Service level agreement',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Velkommen!',
        'Please click the button below to create your first ticket.' => 'Klik på knappen herunder for at oprette din første sag.',
        'Create your first ticket' => 'Opret din første sag',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'f.eks. 10*55 eller 105658*',
        'Customer ID' => 'Kunde-ID',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Fritekstsøgning i sager (f.eks. "Ni*olai eller Hans*")',
        'Recipient' => 'Modtager',
        'Carbon Copy' => 'Cc',
        'e. g. m*file or myfi*' => 'f.eks. m*fil eller minfi*',
        'Types' => 'Typer',
        'Time restrictions' => 'Tidsbegrænsninger',
        'No time settings' => 'Ingen tidsindstillinger',
        'Specific date' => 'Specifik dato',
        'Only tickets created' => 'Kun oprettede sager',
        'Date range' => 'Datointerval',
        'Only tickets created between' => 'Kun sager oprettet mellem',
        'Ticket archive system' => 'Sagsarkivet',
        'Save search as template?' => 'Gem søgning som skabelon?',
        'Save as Template?' => 'Gem som skabelon?',
        'Save as Template' => 'Gem som skabelon',
        'Template Name' => 'Navn på skabelon',
        'Pick a profile name' => 'Vælg et profilnavn',
        'Output to' => 'Output til',

        # Template: CustomerTicketSearchResultShort
        'of' => 'af',
        'Search Results for' => 'Søgeresultater for',
        'Remove this Search Term.' => 'Fjern dette søgekriterie.',

        # Template: CustomerTicketZoom
        'Start a chat from this ticket' => '',
        'Expand article' => 'Fold indlæg ud',
        'Next Steps' => 'Næste skridt',
        'Reply' => 'Svar',
        'Chat Protocol' => '',

        # Template: DashboardEventsTicketCalendar
        'All-day' => 'Alle dage',
        'Sunday' => 'Søndag',
        'Monday' => 'Mandag',
        'Tuesday' => 'Tirsdag',
        'Wednesday' => 'Onsdag',
        'Thursday' => 'Torsdag',
        'Friday' => 'Fredag',
        'Saturday' => 'Lørdag',
        'Su' => 'Sø',
        'Mo' => 'Ma',
        'Tu' => 'Ti',
        'We' => 'On',
        'Th' => 'To',
        'Fr' => 'Fr',
        'Sa' => 'Lø',
        'Event Information' => 'Begivenheds oplysninger',
        'Ticket fields' => 'Sagsfelter',
        'Dynamic fields' => 'Dynamiske felter',

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Ugyldig dato (angiv dato i fremtiden)',
        'Invalid date (need a past date)!' => 'Ugyldig dato (angiv en dato i fortiden)',
        'Previous' => 'Forrige',
        'Open date selection' => 'Åbn datovælger',

        # Template: Error
        'An error occurred.' => 'Der er sket en fejl.',
        'Really a bug? 5 out of 10 bug reports result from a wrong or incomplete installation of OTRS.' =>
            '',
        'With %s, our experts take care of correct installation and cover your back with support and periodic security updates.' =>
            '',
        'Contact our service team now.' => 'Kontakt vores service-team nu.',
        'Send a bugreport' => 'Sende en fejlrapport',

        # Template: FooterJS
        'Please enter at least one search value or * to find anything.' =>
            'Angiv venligst mindst ét søgeord eller * for at finde alt.',
        'Please remove the following words from your search as they cannot be searched for:' =>
            'Fjern venligst følgende ord fra søgningen da der ikke kan søges efter dem:',
        'Please check the fields marked as red for valid inputs.' => 'Tjek de røde felter og udfyld dem med gyldigt indhold.',
        'Please perform a spell check on the the text first.' => 'Kontroller venligst stavningen i teksten først.',
        'Slide the navigation bar' => '',
        'Unavailable for chat' => '',
        'Available for internal chats only' => '',
        'Available for chats' => '',
        'Please visit the chat manager' => '',
        'New personal chat request' => '',
        'New customer chat request' => '',
        'New public chat request' => '',
        'Selected user is not available for chat.' => '',
        'New activity' => 'Ny aktivitet',
        'New activity on one of your monitored chats.' => 'Ny aktivitet i en af dine monitorerede chats.',
        'Your browser does not support video and audio calling.' => '',
        'Selected user is not available for video and audio call.' => '',
        'Target user\'s browser does not support video and audio calling.' =>
            '',
        'Do you really want to continue?' => 'Ønsker du at fortsætte?',
        'Information about the OTRS Daemon' => 'Information om OTRS tjenesten',
        'Communication error' => '',
        'This feature is part of the %s.  Please contact us at %s for an upgrade.' =>
            '',
        'Find out more about the %s' => '',

        # Template: Header
        'You are logged in as' => 'Du er logget ind som',

        # Template: Installer
        'JavaScript not available' => 'JavaScript ikke tilgængeligt',
        'Step %s' => 'Skridt %s',
        'Database Settings' => 'Database-indstillinger',
        'General Specifications and Mail Settings' => 'Generelle specifikationer og mail-indstillinger',
        'Finish' => 'Færdig',
        'Welcome to %s' => 'Velkommen til %s',
        'Web site' => 'Webside',
        'Mail check successful.' => 'Mail er tjekket ok.',
        'Error in the mail settings. Please correct and try again.' => 'Fejl i mail-indstillingerne. Ret dem venligst og prøv igen.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Konfigurer udgående mail',
        'Outbound mail type' => 'Udgående mail-type',
        'Select outbound mail type.' => 'Vælg udgående mail-type',
        'Outbound mail port' => 'Udgående mail-port',
        'Select outbound mail port.' => 'Vælg udgående mail-port.',
        'SMTP host' => 'SMTP-server',
        'SMTP host.' => 'SMTP-server.',
        'SMTP authentication' => 'SMTP-godkendelse',
        'Does your SMTP host need authentication?' => 'Har din SMTP-server brug for godkendelse?',
        'SMTP auth user' => 'SMTP autentifikations-bruger',
        'Username for SMTP auth.' => 'Brugernavn for SMTP-autentifikation',
        'SMTP auth password' => 'SMTP autentifikations-password',
        'Password for SMTP auth.' => 'Password for SMTP-autentifikation',
        'Configure Inbound Mail' => 'Konfigurer indgående mail',
        'Inbound mail type' => 'Indgående mail-type',
        'Select inbound mail type.' => 'Vælg indgående mail-type',
        'Inbound mail host' => 'Indågende mail-server',
        'Inbound mail host.' => 'Indgående mail-server.',
        'Inbound mail user' => 'Indgående mail-bruger',
        'User for inbound mail.' => 'Bruger for indgående mail',
        'Inbound mail password' => 'Indgående mail-password',
        'Password for inbound mail.' => 'Password for indgående mail.',
        'Result of mail configuration check' => 'Resultat af konfigurationstjek af indgående mail',
        'Check mail configuration' => 'Tjek mail-konfiguration',
        'Skip this step' => 'Spring dette trin over',

        # Template: InstallerDBResult
        'Database setup successful!' => 'Database konfigureret!',

        # Template: InstallerDBStart
        'Install Type' => 'Installationstype',
        'Create a new database for OTRS' => 'Opret ny database til OTRS',
        'Use an existing database for OTRS' => 'Brug en eksisterende database til OTRS',

        # Template: InstallerDBmssql
        'Database name' => 'Database-navn',
        'Check database settings' => 'Tjek database-konfiguration',
        'Result of database check' => 'Resultat af database-konfigurationstjek',
        'Database check successful.' => 'Databasen er tjekket ok.',
        'Database User' => 'Database-bruger',
        'New' => 'Ny',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'En ny database-bruger med begrænsede rettigheder vil blive oprettet til dette OTRS-system.',
        'Repeat Password' => 'Gentag password',
        'Generated password' => 'Genereret password',

        # Template: InstallerDBmysql
        'Passwords do not match' => 'Passwords matcher ikke',

        # Template: InstallerDBoracle
        'SID' => 'SID',
        'Port' => 'Port',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'For at kunne anvende OTRS, er du nødt til at indtaste følgende linje i din kommandolinje (Terminal/Shell) som root.',
        'Restart your webserver' => 'Genstart webserveren',
        'After doing so your OTRS is up and running.' => 'Når det er gjort, er din OTRS sat i gang og fungerer.',
        'Start page' => 'Startside',
        'Your OTRS Team' => 'Dit OTRS Team',

        # Template: InstallerLicense
        'Don\'t accept license' => 'Accepter ikke licensen',
        'Accept license and continue' => 'Accepter licens og fortsæt',

        # Template: InstallerSystem
        'SystemID' => 'System-ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Systemets ID. Hver sagsnummer og hver HTTP-session-id indeholder dette nummer.',
        'System FQDN' => 'Systemets FQDN',
        'Fully qualified domain name of your system.' => 'Dit systems Fully Qualified Domain Name',
        'AdminEmail' => 'Admin-Email',
        'Email address of the system administrator.' => 'System-administrators mail-adresse.',
        'Organization' => 'Organisation',
        'Log' => 'Log',
        'LogModule' => 'LogModul',
        'Log backend to use.' => 'Brug denne log-backend.',
        'LogFile' => 'Logfil',
        'Webfrontend' => 'Webfrontend',
        'Default language' => 'Standardsprog',
        'Default language.' => 'Standardsprog.',
        'CheckMXRecord' => 'KontrollerMXRecord',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'Mail-adresser, der indtastes manuelt, tjekkes mod MX-records fundet i DNS. Brug ikke denne valgmulighed, hvis din DNS er langsom eller ikke kan opløse offentlige adresser.',

        # Template: LinkObject
        'Object#' => 'Objekt#',
        'Add links' => 'Tilføj links',
        'Delete links' => 'Slet links',

        # Template: Login
        'Lost your password?' => 'Mistet din adgangskode?',
        'Request New Password' => 'Bed om nyt password',
        'Back to login' => 'Tilbage til login',

        # Template: MetaFloater
        'Scale preview content' => '',
        'Open URL in new tab' => '',
        'Close preview' => 'Luk forhåndsvisning',
        'A preview of this website can\'t be provided because it didn\'t allow to be embedded.' =>
            '',

        # Template: MobileNotAvailableWidget
        'Feature not available' => 'Denne funktion er ikke tilgængelig',
        'Sorry, but this feature of OTRS is currently not available for mobile devices. If you\'d like to use it, you can either switch to desktop mode or use your regular desktop device.' =>
            'Beklager, men denne funktion i OTRS er ikke tilgængelig for mobile enheder. Hvis du gerne vil bruge den, kan du enten skifte til desktop-visning eller bruge din almindelige desktop-pc.',

        # Template: Motd
        'Message of the Day' => 'Dagens Besked',
        'This is the message of the day. You can edit this in %s.' => '',

        # Template: NoPermission
        'Insufficient Rights' => 'Utilstrækkelige rettigheder',
        'Back to the previous page' => 'Tilbage til forrige side',

        # Template: Pagination
        'Show first page' => 'Vis frøste side',
        'Show previous pages' => 'Vis forrige side',
        'Show page %s' => 'Vis side %s',
        'Show next pages' => 'Vis næste side',
        'Show last page' => 'Vis sidste side',

        # Template: PictureUpload
        'Need FormID!' => 'Mangler FormID!',
        'No file found!' => 'Ingen fil fundet!',
        'The file is not an image that can be shown inline!' => 'Dette billede kan ikke vises!',

        # Template: PreferencesNotificationEvent
        'Notification' => 'Besked',
        'No user configurable notifications found.' => '',
        'Receive messages for notification \'%s\' by transport method \'%s\'.' =>
            '',
        'Please note that you can\'t completely disable notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for notifications marked as mandatory.' =>
            '',
        'Sorry, but you can\'t disable all methods for this notification.' =>
            '',

        # Template: ActivityDialogHeader
        'Process Information' => '',
        'Dialog' => 'Dialog',

        # Template: Article
        'Inform Agent' => 'Informer Agent',

        # Template: PublicDefault
        'Welcome' => 'Velkommen',
        'This is the default public interface of OTRS! There was no action parameter given.' =>
            '',
        'You could install a custom public module (via the package manager), for example the FAQ module, which has a public interface.' =>
            '',

        # Template: RichTextEditor
        'Remove Quote' => '',

        # Template: GeneralSpecificationsWidget
        'Permissions' => 'Rettigheder',
        'You can select one or more groups to define access for different agents.' =>
            'Du kan vælge en eller flere grupper for at give adgang for forskellige agenter.',
        'Result formats' => 'Formater resultat som',
        'The selected time periods in the statistic are time zone neutral.' =>
            'De valgte tidsperioder i rapportern tager ikke højde for tidszoner.',
        'Create summation row' => 'Summer rækker',
        'Generate an additional row containing sums for all data rows.' =>
            '',
        'Create summation column' => 'Summer kolonner',
        'Generate an additional column containing sums for all data columns.' =>
            '',
        'Cache results' => 'Gem resultater i cache',
        'Stores statistics result data in a cache to be used in subsequent views with the same configuration (requires at least one selected time field).' =>
            '',
        'Provide the statistic as a widget that agents can activate in their dashboard.' =>
            'Tilbyd rapporten som en widget, agenter kan aktivere på deres dashboard.',
        'Please note that enabling the dashboard widget will activate caching for this statistic in the dashboard.' =>
            'Bemærk, at ved at aktivere dashboard-widget, vil caching også blive aktiveret.',
        'If set to invalid end users can not generate the stat.' => 'Hvis sat til ugyldig, kan brugere ikke køre rapporten.',

        # Template: PreviewWidget
        'There are problems in the configuration of this statistic:' => 'Der er problemer i konfigurationen af denne rapport:',
        'You may now configure the X-axis of your statistic.' => 'Du kan nu konfigurere X-aksen i din rapport.',
        'This statistic does not provide preview data.' => 'Denne rapport har ikke mulighed for forhåndsvisning.',
        'Preview format:' => 'Format for forhåndsvisning:',
        'Please note that the preview uses random data and does not consider data filters.' =>
            'Bemærk at forhåndsvisningen bruger tilfældigt data og ikke tager filtre i betragtning.',
        'Configure X-Axis' => 'Konfigurer X-aksen',
        'X-axis' => 'X-akse',
        'Configure Y-Axis' => 'Konfigirer Y-aksen',
        'Y-axis' => 'Y-akse',
        'Configure Filter' => 'Konfigurer filter',

        # Template: RestrictionsWidget
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Vælg venligst kun et Element, eller fravælg knappen \'Fast\'',
        'Absolute period' => 'Absolut periode',
        'Between' => 'Mellem',
        'Relative period' => 'Relativ periode',
        'The past complete %s and the current+upcoming complete %s %s' =>
            '',
        'Do not allow changes to this element when the statistic is generated.' =>
            'Tillad ikke ændringer i dette element, når rapporten genereres.',

        # Template: StatsParamsWidget
        'Format' => 'Format',
        'Exchange Axis' => 'Ombyt akser',
        'Configurable params of static stat' => 'Konfigurerbare parametre af en statisk rapport',
        'No element selected.' => 'Intet element er valgt',
        'Scale' => 'Skala',
        'show more' => '',
        'show less' => '',

        # Template: D3
        'Download SVG' => 'Hent SVG',
        'Download PNG' => 'Hent PNG',

        # Template: XAxisWidget
        'The selected time period defines the default time frame for this statistic to collect data from.' =>
            'Den valgte tidsperiode definerer tidsrammen, som denne rapport samler data i.',
        'Defines the time unit that will be used to split the selected time period into reporting data points.' =>
            '',

        # Template: YAxisWidget
        'Please remember that the scale for the Y-axis has to be larger than the scale for the X-axis (e.g. X-axis => Month, Y-Axis => Year).' =>
            '',

        # Template: Test
        'OTRS Test Page' => 'OTRS prøveside',
        'Welcome %s %s' => 'Velkommen %s %s',
        'Counter' => 'Tæller',

        # Template: Warning
        'Go back to the previous page' => 'Gå tilbage til forrige side',

        # Perl Module: Kernel/Config/Defaults.pm
        'Database Backend' => '',
        'View system log messages.' => 'Se systemets log',
        'Update and extend your system with software packages.' => 'Opdater ',

        # Perl Module: Kernel/Modules/AdminACL.pm
        'ACLs could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            '',
        'The following ACLs have been added successfully: %s' => '',
        'The following ACLs have been updated successfully: %s' => '',
        'There where errors adding/updating the following ACLs: %s. Please check the log file for more information.' =>
            '',
        'This field is required' => 'Obligatorisk felt',
        'There was an error creating the ACL' => '',
        'Need ACLID!' => '',
        'Could not get data for ACLID %s' => '',
        'There was an error updating the ACL' => '',
        'There was an error setting the entity sync status.' => '',
        'There was an error synchronizing the ACLs.' => '',
        'ACL %s could not be deleted' => '',
        'There was an error getting data for ACL with ID %s' => '',
        'Exact match' => '',
        'Negated exact match' => '',
        'Regular expression' => '',
        'Regular expression (ignore case)' => '',
        'Negated regular expression' => '',
        'Negated regular expression (ignore case)' => '',

        # Perl Module: Kernel/Modules/AdminCustomerCompany.pm
        'Customer Company %s already exists!' => '',

        # Perl Module: Kernel/Modules/AdminCustomerUser.pm
        'New phone ticket' => 'Opret ny sag',
        'New email ticket' => 'Opret ny sag ved at sende mail',

        # Perl Module: Kernel/Modules/AdminDynamicField.pm
        'Fields configuration is not valid' => '',
        'Objects configuration is not valid' => '',
        'Could not reset Dynamic Field order properly, please check the error log for more details.' =>
            '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldCheckbox.pm
        'Undefined subaction.' => '',
        'Need %s' => '',
        'The field does not contain only ASCII letters and numbers.' => '',
        'There is another field with the same name.' => '',
        'The field must be numeric.' => '',
        'Need ValidID' => '',
        'Could not create the new field' => '',
        'Need ID' => '',
        'Could not get data for dynamic field %s' => '',
        'The name for this field should not change.' => '',
        'Could not update the field %s' => '',
        'Currently' => '',
        'Unchecked' => 'Fravalgt',
        'Checked' => 'Valgt',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDateTime.pm
        'Prevent entry of dates in the future' => '',
        'Prevent entry of dates in the past' => '',

        # Perl Module: Kernel/Modules/AdminDynamicFieldDropdown.pm
        'This field value is duplicated.' => '',

        # Perl Module: Kernel/Modules/AdminEmail.pm
        'Select at least one recipient.' => '',

        # Perl Module: Kernel/Modules/AdminGenericAgent.pm
        'archive tickets' => '',
        'restore tickets from archive' => 'gendan sager fra arkivet',
        'Need Profile!' => '',
        'Got no values to check.' => '',
        'Please remove the following words because they cannot be used for the ticket selection:' =>
            '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceDebugger.pm
        'Need WebserviceID!' => '',
        'Could not get data for WebserviceID %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceInvokerDefault.pm
        'Need InvokerType' => '',
        'Invoker %s is not registered' => '',
        'InvokerType %s is not registered' => '',
        'Need Invoker' => '',
        'Could not determine config for invoker %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingSimple.pm
        'Could not get registered configuration for action type %s' => '',
        'Could not get backend for %s %s' => '',
        'Could not update configuration data for WebserviceID %s' => '',
        'Keep (leave unchanged)' => 'Behold (ignorer ændringer)',
        'Ignore (drop key/value pair)' => '',
        'Map to (use provided value as default)' => '',
        'Exact value(s)' => '',
        'Ignore (drop Value/value pair)' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceMappingXSLT.pm
        'Could not find required library %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceOperationDefault.pm
        'Need OperationType' => '',
        'Operation %s is not registered' => '',
        'OperationType %s is not registered' => '',
        'Need Operation' => '',
        'Could not determine config for operation %s' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceTransportHTTPREST.pm
        'Need Subaction!' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebservice.pm
        'There is another web service with the same name.' => '',
        'There was an error updating the web service.' => '',
        'Web service "%s" updated!' => 'Web tjeneste "%s" er opdateret!',
        'There was an error creating the web service.' => '',
        'Web service "%s" created!' => 'Web tjeneste "%s" er oprettet!',
        'Need Name!' => '',
        'Need ExampleWebService!' => '',
        'Could not read %s!' => '',
        'Need a file to import!' => '',
        'The imported file has not valid YAML content! Please check OTRS log for details' =>
            '',
        'Web service "%s" deleted!' => 'Web tjeneste "%s" er slettet!',
        'New Web service' => '',
        'Operations' => '',
        'Invokers' => '',

        # Perl Module: Kernel/Modules/AdminGenericInterfaceWebserviceHistory.pm
        'Got no WebserviceHistoryID!' => '',
        'Could not get history data for WebserviceHistoryID %s' => '',

        # Perl Module: Kernel/Modules/AdminNotificationEvent.pm
        'Notification updated!' => '',
        'Notification added!' => 'Besked tilføjet.',
        'There was an error getting data for Notification with ID:%s!' =>
            'Der var en fejl med at hente data for beskeden med ID:%s!',
        'Unknown Notification %s!' => 'Ukendt besked %s!',
        'There was an error creating the Notification' => 'Der opstod en fejl ved oprettelse af beskeden',
        'Notifications could not be Imported due to a unknown error, please check OTRS logs for more information' =>
            'Beskeder kunne ikke importeres grundet en ukendt fejl. Tjek OTRS-loggen for mere information.',
        'The following Notifications have been added successfully: %s' =>
            '',
        'The following Notifications have been updated successfully: %s' =>
            '',
        'There where errors adding/updating the following Notifications: %s. Please check the log file for more information.' =>
            '',
        'Agent who owns the ticket' => 'Agent der ejer sagen',
        'Agent who is responsible for the ticket' => 'Ansvarlig agent for sagen',
        'All agents watching the ticket' => 'Alle agenter der monitorerer sagen',
        'All agents with write permission for the ticket' => 'Alle agenter med skrivetilladelse i sagen',
        'All agents subscribed to the ticket\'s queue' => 'Alle agenter der abonnerer på sagens kø',
        'All agents subscribed to the ticket\'s service' => '',
        'All agents subscribed to both the ticket\'s queue and service' =>
            '',
        'Customer of the ticket' => 'Sagens kunde',
        'Yes, but require at least one active notification method.' => '',

        # Perl Module: Kernel/Modules/AdminPGP.pm
        'PGP environment is not working. Please check log for more info!' =>
            '',
        'Need param Key to delete!' => '',
        'Key %s deleted!' => 'Nøgle %s slettet.',
        'Need param Key to download!' => '',

        # Perl Module: Kernel/Modules/AdminPackageManager.pm
        'Sorry, Apache::Reload is needed as PerlModule and PerlInitHandler in Apache config file. See also scripts/apache2-httpd.include.conf. Alternatively, you can use the command line tool bin/otrs.Console.pl to install packages!' =>
            '',
        'No such package!' => 'Den pakke findes ikke!',
        'No such file %s in package!' => '',
        'No such file %s in local file system!' => '',
        'Can\'t read %s!' => 'Kan ikke læse %s!',
        'File is OK' => '',
        'Package has locally modified files.' => '',
        'No packages or no new packages found in selected repository.' =>
            '',
        'Package not verified due a communication issue with verification server!' =>
            'Pakke ikke verificeret pga. kommunikationsfejl med server!',
        'Can\'t connect to OTRS Feature Add-on list server!' => '',
        'Can\'t get OTRS Feature Add-on list from server!' => '',
        'Can\'t get OTRS Feature Add-on from server!' => '',

        # Perl Module: Kernel/Modules/AdminPostMasterFilter.pm
        'No such filter: %s' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagement.pm
        'Need ExampleProcesses!' => '',
        'Need ProcessID!' => '',
        'Yes (mandatory)' => '',
        'Unknown Process %s!' => '',
        'There was an error generating a new EntityID for this Process' =>
            '',
        'The StateEntityID for state Inactive does not exists' => '',
        'There was an error creating the Process' => '',
        'There was an error setting the entity sync status for Process entity: %s' =>
            '',
        'Could not get data for ProcessID %s' => '',
        'There was an error updating the Process' => '',
        'Process: %s could not be deleted' => '',
        'There was an error synchronizing the processes.' => '',
        'The %s:%s is still in use' => '',
        'The %s:%s has a different EntityID' => '',
        'Could not delete %s:%s' => '',
        'There was an error setting the entity sync status for %s entity: %s' =>
            '',
        'Could not get %s' => '',
        'Need %s!' => '',
        'Process: %s is not Inactive' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivity.pm
        'There was an error generating a new EntityID for this Activity' =>
            '',
        'There was an error creating the Activity' => '',
        'There was an error setting the entity sync status for Activity entity: %s' =>
            '',
        'Need ActivityID!' => '',
        'Could not get data for ActivityID %s' => '',
        'There was an error updating the Activity' => '',
        'Missing Parameter: Need Activity and ActivityDialog!' => '',
        'Activity not found!' => '',
        'ActivityDialog not found!' => '',
        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!' =>
            '',
        'Error while saving the Activity to the database!' => '',
        'This subaction is not valid' => '',
        'Edit Activity "%s"' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementActivityDialog.pm
        'There was an error generating a new EntityID for this ActivityDialog' =>
            '',
        'There was an error creating the ActivityDialog' => '',
        'There was an error setting the entity sync status for ActivityDialog entity: %s' =>
            '',
        'Need ActivityDialogID!' => '',
        'Could not get data for ActivityDialogID %s' => '',
        'There was an error updating the ActivityDialog' => '',
        'Edit Activity Dialog "%s"' => '',
        'Agent Interface' => '',
        'Customer Interface' => '',
        'Agent and Customer Interface' => '',
        'Do not show Field' => '',
        'Show Field' => '',
        'Show Field As Mandatory' => '',
        'fax' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementPath.pm
        'Edit Path' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransition.pm
        'There was an error generating a new EntityID for this Transition' =>
            '',
        'There was an error creating the Transition' => '',
        'There was an error setting the entity sync status for Transition entity: %s' =>
            '',
        'Need TransitionID!' => '',
        'Could not get data for TransitionID %s' => '',
        'There was an error updating the Transition' => '',
        'Edit Transition "%s"' => '',
        'xor' => '',
        'String' => '',
        'Transition validation module' => '',

        # Perl Module: Kernel/Modules/AdminProcessManagementTransitionAction.pm
        'At least one valid config parameter is required.' => '',
        'There was an error generating a new EntityID for this TransitionAction' =>
            '',
        'There was an error creating the TransitionAction' => '',
        'There was an error setting the entity sync status for TransitionAction entity: %s' =>
            '',
        'Need TransitionActionID!' => '',
        'Could not get data for TransitionActionID %s' => '',
        'There was an error updating the TransitionAction' => '',
        'Edit Transition Action "%s"' => '',
        'Error: Not all keys seem to have values or vice versa.' => '',

        # Perl Module: Kernel/Modules/AdminQueue.pm
        'Don\'t use :: in queue name!' => '',
        'Click back and change it!' => '',

        # Perl Module: Kernel/Modules/AdminQueueAutoResponse.pm
        'Queues ( without auto responses )' => '',

        # Perl Module: Kernel/Modules/AdminRegistration.pm
        'Production' => 'Produktion',
        'Test' => '',
        'Training' => 'Træning',
        'Development' => '',

        # Perl Module: Kernel/Modules/AdminRoleUser.pm
        'Role' => '',

        # Perl Module: Kernel/Modules/AdminSMIME.pm
        'S/MIME environment is not working. Please check log for more info!' =>
            '',
        'Need param Filename to delete!' => '',
        'Need param Filename to download!' => '',
        'Needed CertFingerprint and CAFingerprint!' => '',
        'CAFingerprint must be different than CertFingerprint' => '',
        'Relation exists!' => '',
        'Relation added!' => '',
        'Impossible to add relation!' => '',
        'Relation doesn\'t exists' => '',
        'Relation deleted!' => '',
        'Impossible to delete relation!' => '',
        'Certificate %s could not be read!' => '',
        'Needed Fingerprint' => '',

        # Perl Module: Kernel/Modules/AdminSalutation.pm
        'Salutation updated!' => '',
        'Salutation added!' => '',

        # Perl Module: Kernel/Modules/AdminSupportDataCollector.pm
        'File %s could not be read!' => '',

        # Perl Module: Kernel/Modules/AdminSysConfig.pm
        'Import not allowed!' => '',
        'Need File!' => '',
        'Can\'t write ConfigItem!' => '',

        # Perl Module: Kernel/Modules/AdminSystemMaintenance.pm
        'Start date shouldn\'t be defined after Stop date!' => '',
        'There was an error creating the System Maintenance' => '',
        'Need SystemMaintenanceID!' => '',
        'Could not get data for SystemMaintenanceID %s' => '',
        'System Maintenance was saved successfully!' => '',
        'Session has been killed!' => '',
        'All sessions have been killed, except for your own.' => 'Alle sessioner er lukket, undtagen din egen',
        'There was an error updating the System Maintenance' => '',
        'Was not possible to delete the SystemMaintenance entry: %s!' => '',

        # Perl Module: Kernel/Modules/AdminTemplate.pm
        'Template updated!' => '',
        'Template added!' => '',

        # Perl Module: Kernel/Modules/AdminType.pm
        'Need Type!' => '',

        # Perl Module: Kernel/Modules/AgentDashboardCommon.pm
        'No such config for %s' => '',
        'Statistic' => 'Rapport',
        'No preferences for %s!' => '',
        'Can\'t get element data of %s!' => '',
        'Can\'t get filter content data of %s!' => '',
        'Customer Company Name' => '',
        'Customer User ID' => '',

        # Perl Module: Kernel/Modules/AgentLinkObject.pm
        'Need SourceObject and SourceKey!' => '',
        'Please contact the administrator.' => '',
        'You need ro permission!' => '',
        'Can not delete link with %s!' => 'Kan ikke slette link med %s!',
        'Can not create link with %s! Object already linked as %s.' => '',
        'Can not create link with %s!' => 'Kan ikke oprette link med %s!',
        'The object %s cannot link with other object!' => '',

        # Perl Module: Kernel/Modules/AgentPreferences.pm
        'Param Group is required!' => '',

        # Perl Module: Kernel/Modules/AgentStatistics.pm
        'Parameter %s is missing.' => '',
        'Invalid Subaction.' => '',
        'Statistic could not be imported.' => 'Rapport kunne ikke importeres',
        'Please upload a valid statistic file.' => 'Upload venligst en gyldig rapport-fil.',
        'Export: Need StatID!' => '',
        'Delete: Get no StatID!' => '',
        'Need StatID!' => '',
        'Could not load stat.' => '',
        'Could not create statistic.' => 'Kunne ikke oprette rapport.',
        'Run: Get no %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketActionCommon.pm
        'No TicketID is given!' => '',
        'You need %s permissions!' => '',
        'Could not perform validation on field %s!' => '',
        'No subject' => 'Intet emne',
        'Previous Owner' => 'Tidligere ejer',

        # Perl Module: Kernel/Modules/AgentTicketBounce.pm
        '%s is needed!' => '',
        'Plain article not found for article %s!' => '',
        'Article does not belong to ticket %s!' => '',
        'Can\'t bounce email!' => '',
        'Can\'t send email!' => '',
        'Wrong Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketBulk.pm
        'Can\'t lock Tickets, no TicketIDs are given!' => '',
        'Ticket (%s) is not unlocked!' => '',
        'Bulk feature is not enabled!' => '',
        'No selectable TicketID is given!' => '',
        'You either selected no ticket or only tickets which are locked by other agents.' =>
            '',
        'You need to select at least one ticket.' => '',
        'The following tickets were ignored because they are locked by another agent or you don\'t have write access to these tickets: %s.' =>
            '',
        'The following tickets were locked: %s.' => '',

        # Perl Module: Kernel/Modules/AgentTicketCompose.pm
        'Can not determine the ArticleType!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmail.pm
        'No Subaction!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEmailOutbound.pm
        'Got no TicketID!' => '',
        'System Error!' => '',

        # Perl Module: Kernel/Modules/AgentTicketEscalationView.pm
        'Invalid Filter: %s!' => '',

        # Perl Module: Kernel/Modules/AgentTicketHistory.pm
        'Can\'t show history, no TicketID is given!' => '',

        # Perl Module: Kernel/Modules/AgentTicketLock.pm
        'Can\'t lock Ticket, no TicketID is given!' => '',
        'Sorry, the current owner is %s!' => '',
        'Please become the owner first.' => '',
        'Ticket (ID=%s) is locked by %s!' => '',
        'Change the owner!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMerge.pm
        'Can\'t merge ticket with itself!' => '',

        # Perl Module: Kernel/Modules/AgentTicketMove.pm
        'You need move permissions!' => '',

        # Perl Module: Kernel/Modules/AgentTicketPhone.pm
        'Chat is not active.' => '',
        'No permission.' => '',
        '%s has left the chat.' => '',
        'This chat has been closed and will be removed in %s hours.' => '',

        # Perl Module: Kernel/Modules/AgentTicketPlain.pm
        'No ArticleID!' => '',
        'Can\'t read plain article! Maybe there is no plain email in backend! Read backend message.' =>
            '',

        # Perl Module: Kernel/Modules/AgentTicketPrint.pm
        'Need TicketID!' => '',
        'printed by' => 'udskrevet af',
        'Ticket Dynamic Fields' => 'Sagens dynamiske felter',

        # Perl Module: Kernel/Modules/AgentTicketProcess.pm
        'Couldn\'t get ActivityDialogEntityID "%s"!' => '',
        'No Process configured!' => '',
        'Process %s is invalid!' => '',
        'Subaction is invalid!' => '',
        'Parameter %s is missing in %s.' => '',
        'No ActivityDialog configured for %s in _RenderAjax!' => '',
        'Got no Start ActivityEntityID or Start ActivityDialogEntityID for Process: %s in _GetParam!' =>
            '',
        'Couldn\'t get Ticket for TicketID: %s in _GetParam!' => '',
        'Couldn\'t determine ActivityEntityID. DynamicField or Config isn\'t set properly!' =>
            '',
        'Process::Default%s Config Value missing!' => '',
        'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!' =>
            '',
        'Can\'t get StartActivityDialog and StartActivityDialog for the ProcessEntityID "%s"!' =>
            '',
        'Can\'t get Ticket "%s"!' => '',
        'Can\'t get ProcessEntityID or ActivityEntityID for Ticket "%s"!' =>
            '',
        'Can\'t get Activity configuration for ActivityEntityID "%s"!' =>
            '',
        'Can\'t get ActivityDialog configuration for ActivityDialogEntityID "%s"!' =>
            '',
        'Can\'t get data for Field "%s" of ActivityDialog "%s"!' => '',
        'PendingTime can just be used if State or StateID is configured for the same ActivityDialog. ActivityDialog: %s!' =>
            '',
        'Pending Date' => 'Afventer til dato',
        'for pending* states' => 'for afventende tilstande',
        'ActivityDialogEntityID missing!' => '',
        'Couldn\'t get Config for ActivityDialogEntityID "%s"!' => '',
        'Couldn\'t use CustomerID as an invisible field.' => '',
        'Missing ProcessEntityID, check your ActivityDialogHeader.tt!' =>
            '',
        'No StartActivityDialog or StartActivityDialog for Process "%s" configured!' =>
            '',
        'Couldn\'t create ticket for Process with ProcessEntityID "%s"!' =>
            '',
        'Couldn\'t set ProcessEntityID "%s" on TicketID "%s"!' => '',
        'Couldn\'t set ActivityEntityID "%s" on TicketID "%s"!' => '',
        'Could not store ActivityDialog, invalid TicketID: %s!' => '',
        'Invalid TicketID: %s!' => '',
        'Missing ActivityEntityID in Ticket %s!' => '',
        'This step does not belong anymore to the current activity in process for ticket \'%s%s%s\'! Another user changed this ticket in the meantime. Please close this window and reload the ticket.' =>
            '',
        'Missing ProcessEntityID in Ticket %s!' => '',
        'Could not set DynamicField value for %s of Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Could not set PendingTime for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Wrong ActivityDialog Field config: %s can\'t be Display => 1 / Show field (Please change its configuration to be Display => 0 / Do not show field or Display => 2 / Show field as mandatory)!' =>
            '',
        'Could not set %s for Ticket with ID "%s" in ActivityDialog "%s"!' =>
            '',
        'Default Config for Process::Default%s missing!' => '',
        'Default Config for Process::Default%s invalid!' => '',

        # Perl Module: Kernel/Modules/AgentTicketSearch.pm
        'Untitled' => '',
        'Customer Name' => '',
        'Invalid Users' => '',
        'CSV' => 'CSV',
        'Excel' => '',

        # Perl Module: Kernel/Modules/AgentTicketService.pm
        'Feature not enabled!' => '',

        # Perl Module: Kernel/Modules/AgentTicketWatcher.pm
        'Feature is not active' => '',

        # Perl Module: Kernel/Modules/AgentTicketZoom.pm
        'Link Deleted' => 'Link Slettet',
        'Ticket Locked' => 'Sag Trukket',
        'Pending Time Set' => '',
        'Dynamic Field Updated' => 'Dynamisk Felt Opdateret',
        'Outgoing Email (internal)' => '',
        'Ticket Created' => 'Sag Oprettet',
        'Type Updated' => 'Type Opdateret',
        'Escalation Update Time In Effect' => '',
        'Escalation Update Time Stopped' => '',
        'Escalation First Response Time Stopped' => '',
        'Customer Updated' => 'Kunde Opdateret',
        'Internal Chat' => 'Intern Chat',
        'Automatic Follow-Up Sent' => 'Automatisk Opfølgning Sendt',
        'Note Added' => 'Note Tilføjet',
        'Note Added (Customer)' => 'Note Tilføjet (Kunde)',
        'State Updated' => 'Tilstand Opdateret',
        'Outgoing Answer' => 'Udgående Svar',
        'Service Updated' => 'Service Opdateret',
        'Link Added' => 'Link Tilføjet',
        'Incoming Customer Email' => 'Indgående Kunde Email',
        'Incoming Web Request' => 'Indgående Web Forespørgsel',
        'Priority Updated' => 'Prioritet Opdateret',
        'Ticket Unlocked' => 'Sag Frigjort',
        'Outgoing Email' => 'Udgående Email',
        'Title Updated' => 'Titel Opdateret',
        'Ticket Merged' => 'Sag Samlet',
        'Outgoing Phone Call' => 'Udgående Telefonopkald',
        'Forwarded Message' => '',
        'Removed User Subscription' => '',
        'Time Accounted' => '',
        'Incoming Phone Call' => 'Indgående Telefonopkald',
        'System Request.' => '',
        'Incoming Follow-Up' => 'Indgående Opfølgning',
        'Automatic Reply Sent' => 'Automatisk Svar Sendt',
        'Automatic Reject Sent' => '',
        'Escalation Solution Time In Effect' => '',
        'Escalation Solution Time Stopped' => '',
        'Escalation Response Time In Effect' => '',
        'Escalation Response Time Stopped' => '',
        'SLA Updated' => 'SLA Opdateret',
        'Queue Updated' => 'Kø Opdateret',
        'External Chat' => 'Ekstern Chat',
        'Queue Changed' => '',
        'Notification Was Sent' => '',
        'We are sorry, you do not have permissions anymore to access this ticket in its current state.' =>
            '',
        'Can\'t get for ArticleID %s!' => '',
        'Article filter settings were saved.' => '',
        'Event type filter settings were saved.' => '',
        'Need ArticleID!' => '',
        'Invalid ArticleID!' => '',
        'Offline' => '',
        'User is currently offline.' => '',
        'User is currently active.' => '',
        'Away' => '',
        'User was inactive for a while.' => '',
        'Unavailable' => '',
        'User set their status to unavailable.' => '',
        'Fields with no group' => '',
        'View the source for this Article' => '',

        # Perl Module: Kernel/Modules/CustomerTicketAttachment.pm
        'FileID and ArticleID are needed!' => '',
        'No TicketID for ArticleID (%s)!' => '',
        'No such attachment (%s)!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketMessage.pm
        'Check SysConfig setting for %s::QueueDefault.' => '',
        'Check SysConfig setting for %s::TicketTypeDefault.' => '',

        # Perl Module: Kernel/Modules/CustomerTicketOverview.pm
        'Need CustomerID!' => '',
        'My Tickets' => 'Mine Sager',
        'Company Tickets' => 'Firma Sager',
        'Untitled!' => '',

        # Perl Module: Kernel/Modules/CustomerTicketSearch.pm
        'Please remove the following words because they cannot be used for the search:' =>
            'Fjern venligst følgende ord da de ikke kan bruges i søgningen:',

        # Perl Module: Kernel/Modules/CustomerTicketZoom.pm
        'Can\'t reopen ticket, not possible in this queue!' => '',
        'Create a new ticket!' => '',

        # Perl Module: Kernel/Modules/Installer.pm
        'SecureMode active!' => '',
        'If you want to re-run the Installer, disable the SecureMode in the SysConfig.' =>
            '',
        'Directory "%s" doesn\'t exist!' => '',
        'Configure "Home" in Kernel/Config.pm first!' => '',
        'File "%s/Kernel/Config.pm" not found!' => '',
        'Directory "%s" not found!' => '',
        'Kernel/Config.pm isn\'t writable!' => '',
        'If you want to use the installer, set the Kernel/Config.pm writable for the webserver user!' =>
            '',
        'Unknown Check!' => '',
        'The check "%s" doesn\'t exist!' => '',
        'Database %s' => '',
        'Configure MySQL' => '',
        'Configure PostgreSQL' => '',
        'Configure Oracle' => '',
        'Unknown database type "%s".' => '',
        'Please go back.' => '',
        'Install OTRS - Error' => '',
        'File "%s/%s.xml" not found!' => '',
        'Contact your Admin!' => '',
        'Syslog' => '',
        'Can\'t write Config file!' => '',
        'Unknown Subaction %s!' => '',
        'Can\'t connect to database, Perl module DBD::%s not installed!' =>
            '',
        'Can\'t connect to database, read comment!' => '',
        'Error: Please make sure your database accepts packages over %s MB in size (it currently only accepts packages up to %s MB). Please adapt the max_allowed_packet setting of your database in order to avoid errors.' =>
            'Fejl: Sørg for at din database accepterer pakker over %s MB i størrelse (I øjeblikket accepterer den kun pakker op til %s MB). Tilpas max_allowed_packet indstillingen i din database for at undgå fejl.',
        'Error: Please set the value for innodb_log_file_size on your database to at least %s MB (current: %s MB, recommended: %s MB). For more information, please have a look at %s.' =>
            'Fejl: Sæt venligst værdien for innodb_log_file_size i din database til mindst %s MB (nuværende: %s MB, anbefalet: %s MB). For mere info, se %s.',

        # Perl Module: Kernel/Modules/PublicRepository.pm
        'Need config Package::RepositoryAccessRegExp' => '',
        'Authentication failed from %s!' => 'Godkendelse fejlede fra %s!',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/PGP.pm
        'Sent message crypted to recipient!' => '',
        '"PGP SIGNED MESSAGE" header found, but invalid!' => '',

        # Perl Module: Kernel/Output/HTML/ArticleCheck/SMIME.pm
        '"S/MIME SIGNED MESSAGE" header found, but invalid!' => '',
        'Ticket decrypted before' => '',
        'Impossible to decrypt: private key for email was not found!' => '',
        'Successful decryption' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/EventsTicketCalendar.pm
        'The start time of a ticket has been set after the end time!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/News.pm
        'Can\'t connect to OTRS News server!' => '',
        'Can\'t get OTRS News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/ProductNotify.pm
        'Can\'t connect to Product News server!' => '',
        'Can\'t get Product News from server!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/RSS.pm
        'Can\'t connect to %s!' => '',

        # Perl Module: Kernel/Output/HTML/Dashboard/TicketGeneric.pm
        'sorted ascending' => '',
        'sorted descending' => '',
        'filter not active' => '',
        'filter active' => '',
        'This ticket has no title or subject' => 'Denne sag mangler overskrift eller emne',

        # Perl Module: Kernel/Output/HTML/Layout.pm
        'We are sorry, you do not have permissions anymore to access this ticket in its current state. You can take one of the following actions:' =>
            '',
        'No Permission' => '',

        # Perl Module: Kernel/Output/HTML/Layout/LinkObject.pm
        'Linked as' => '',
        'Search Result' => '',

        # Perl Module: Kernel/Output/HTML/LinkObject/Ticket.pm
        'Archive search' => '',

        # Perl Module: Kernel/Output/HTML/Notification/AgentOTRSBusiness.pm
        '%s Upgrade to %s now! %s' => '%s Opgrader til %s nu! %s',

        # Perl Module: Kernel/Output/HTML/Notification/CustomerSystemMaintenanceCheck.pm
        'A system maintenance period will start at: ' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/Language.pm
        '(in process)' => '',

        # Perl Module: Kernel/Output/HTML/Preferences/NotificationEvent.pm
        'Please make sure you\'ve chosen at least one transport method for mandatory notifications.' =>
            '',

        # Perl Module: Kernel/Output/HTML/Preferences/OutOfOffice.pm
        'Please specify an end date that is after the start date.' => 'Angiv en slutdato der ligger efter startdatoen.',

        # Perl Module: Kernel/Output/HTML/Preferences/Password.pm
        'Please supply your new password!' => 'Skriv venligst din nye adgangskode!',

        # Perl Module: Kernel/Output/HTML/Statistics/View.pm
        'No (not supported)' => 'Nej (ikke understøttet)',
        'No past complete or the current+upcoming complete relative time value selected.' =>
            '',
        'The selected time period is larger than the allowed time period.' =>
            '',
        'No time scale value available for the current selected time scale value on the X axis.' =>
            '',
        'The selected date is not valid.' => 'Den valgte dato er ikke gyldig.',
        'The selected end time is before the start time.' => 'Den valgte sluttid ligger før starttiden.',
        'There is something wrong with your time selection.' => 'Der er noget galt med den valgte tid.',
        'Please select only one element or allow modification at stat generation time.' =>
            '',
        'Please select at least one value of this field or allow modification at stat generation time.' =>
            '',
        'Please select one element for the X-axis.' => '',
        'You can only use one time element for the Y axis.' => '',
        'You can only use one or two elements for the Y axis.' => '',
        'Please select at least one value of this field.' => '',
        'Please provide a value or allow modification at stat generation time.' =>
            '',
        'Please select a time scale.' => '',
        'Your reporting time interval is too small, please use a larger time scale.' =>
            '',
        'Please remove the following words because they cannot be used for the ticket restrictions: %s.' =>
            '',

        # Perl Module: Kernel/Output/HTML/TicketOverviewMenu/Sort.pm
        'Order by' => 'Sorter efter',

        # Perl Module: Kernel/System/ACL/DB/ACL.pm
        'Couldn\'t read ACL configuration file. Please make sure the file is valid.' =>
            '',

        # Perl Module: Kernel/System/AuthSession.pm
        'You have exceeded the number of concurrent agents - contact sales@otrs.com.' =>
            '',
        'Please note that the session limit is almost reached.' => '',
        'Login rejected! You have exceeded the maximum number of concurrent Agents! Contact sales@otrs.com immediately!' =>
            '',
        'Session per user limit reached!' => '',

        # Perl Module: Kernel/System/Console/Command/Dev/Tools/Config2Docbook.pm
        'Configuration Options Reference' => '',
        'This setting can not be changed.' => '',
        'This setting is not active by default.' => '',
        'This setting can not be deactivated.' => '',

        # Perl Module: Kernel/System/CustomerUser.pm
        'Customer user "%s" already exists.' => '',

        # Perl Module: Kernel/System/CustomerUser/DB.pm
        'This email address is already in use for another customer user.' =>
            '',

        # Perl Module: Kernel/System/DynamicField/Driver/BaseText.pm
        'e.g. Text or Te*t' => '',

        # Perl Module: Kernel/System/DynamicField/Driver/Checkbox.pm
        'Ignore this field.' => '',

        # Perl Module: Kernel/System/NotificationEvent.pm
        'Couldn\'t read Notification configuration file. Please make sure the file is valid.' =>
            '',
        'Imported notification has body text with more than 4000 characters.' =>
            '',

        # Perl Module: Kernel/System/Package.pm
        'not installed' => '',
        'File is not installed!' => '',
        'File is different!' => '',
        'Can\'t read file!' => '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process.pm
        'The process "%s" and all of its data has been imported successfully.' =>
            '',

        # Perl Module: Kernel/System/ProcessManagement/DB/Process/State.pm
        'Inactive' => 'Inaktiv',
        'FadeAway' => '',

        # Perl Module: Kernel/System/Registration.pm
        'Can\'t get Token from sever' => '',

        # Perl Module: Kernel/System/Stats.pm
        'Sum' => 'Sum',

        # Perl Module: Kernel/System/Stats/Dynamic/Ticket.pm
        'State Type' => 'Tilstandstype',
        'Created Priority' => 'Oprettet med prioritet',
        'Created State' => 'Oprettet med status',
        'Create Time' => 'Oprettet tidspunkt',
        'Close Time' => 'Lukket tidspunkt',
        'Escalation - First Response Time' => '',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Agent/Owner' => 'Agent/Ejer',
        'Created by Agent/Owner' => 'Oprettet af Agent/Ejer',
        'CustomerUserLogin' => 'KundeBrugerLogin',
        'CustomerUserLogin (complex search)' => '',
        'CustomerUserLogin (exact match)' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketAccountedTime.pm
        'Evaluation by' => 'Evalueret af',
        'Ticket/Article Accounted Time' => 'Registreret tid på sagen/indlægget',
        'Ticket Create Time' => 'Sagens oprettelsestidspunkt',
        'Ticket Close Time' => 'Sagens lukningstidspunkt',
        'Accounted time by Agent' => 'Bogført tid af agent',
        'Total Time' => 'Total tid',
        'Ticket Average' => 'Sagsgennemsnit',
        'Ticket Min Time' => 'Sag min. tid',
        'Ticket Max Time' => 'Sag max. tid',
        'Number of Tickets' => 'Antal sager',
        'Article Average' => 'Indlæg-gennemsnit',
        'Article Min Time' => 'Indlæg min. tid',
        'Article Max Time' => 'Indlæg max. tid',
        'Number of Articles' => 'Antal indlæg',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketList.pm
        'unlimited' => '',
        'ascending' => 'stigende',
        'descending' => 'faldende',
        'Attributes to be printed' => 'Attributter til udskrift',
        'Sort sequence' => 'Sorteringsrækkefølge',
        'State Historic' => 'Historik over tilstande',
        'State Type Historic' => 'Historik over Tilstandstyper',
        'Historic Time Range' => '',

        # Perl Module: Kernel/System/Stats/Dynamic/TicketSolutionResponseTime.pm
        'Solution Average' => '',
        'Solution Min Time' => '',
        'Solution Max Time' => '',
        'Solution Average (affected by escalation configuration)' => '',
        'Solution Min Time (affected by escalation configuration)' => '',
        'Solution Max Time (affected by escalation configuration)' => '',
        'Solution Working Time Average (affected by escalation configuration)' =>
            '',
        'Solution Min Working Time (affected by escalation configuration)' =>
            '',
        'Solution Max Working Time (affected by escalation configuration)' =>
            '',
        'First Response Average (affected by escalation configuration)' =>
            '',
        'First Response Min Time (affected by escalation configuration)' =>
            '',
        'First Response Max Time (affected by escalation configuration)' =>
            '',
        'First Response Working Time Average (affected by escalation configuration)' =>
            '',
        'First Response Min Working Time (affected by escalation configuration)' =>
            '',
        'First Response Max Working Time (affected by escalation configuration)' =>
            '',
        'Number of Tickets (affected by escalation configuration)' => '',

        # Perl Module: Kernel/System/Stats/Static/StateAction.pm
        'Days' => 'Dage',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/TablePresence.pm
        'Table Presence' => 'Tabel-tilstedeværelse',
        'Internal Error: Could not open file.' => 'Intern fejl: Kunne ikke åbne fil.',
        'Table Check' => 'Tabel-tjek',
        'Internal Error: Could not read file.' => 'Intern fejl: Kunne ikke læse fil.',
        'Tables found which are not present in the database.' => 'Tabeller fundet, som ikke er i databasen.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Size.pm
        'Database Size' => 'Database-størrelse',
        'Could not determine database size.' => 'Kunne ikke fastslå databasens størrelse.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mssql/Version.pm
        'Database Version' => 'Database-version',
        'Could not determine database version.' => 'Kunne ikke fastslå databasens version.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Charset.pm
        'Client Connection Charset' => 'Karaktersæt til klient-forbindelser',
        'Setting character_set_client needs to be utf8.' => 'Indstillingen character_set_client skal være utf8.',
        'Server Database Charset' => 'Karaktersæt i databasen.',
        'Setting character_set_database needs to be UNICODE or UTF8.' => 'Indstillingen character_set_database_ skal være UNICODE eller UTF8.',
        'Table Charset' => 'Karakterset i tabeller',
        'There were tables found which do not have utf8 as charset.' => 'Der blev fundet tabeller, som ikke bruger utf8-karaktersættet.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/InnoDBLogFileSize.pm
        'InnoDB Log File Size' => 'InnoDB Logfil størrelse',
        'The setting innodb_log_file_size must be at least 256 MB.' => 'Indstillingen innodb_log_file_size skal være mindst 256 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/MaxAllowedPacket.pm
        'Maximum Query Size' => 'Maksimal størrelse på forespørgsler',
        'The setting \'max_allowed_packet\' must be higher than 20 MB.' =>
            'Indstillingen \'max_allowed_packet\' skal være højere end 20 MB.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Performance.pm
        'Query Cache Size' => 'Størrelse på Query Cache',
        'The setting \'query_cache_size\' should be used (higher than 10 MB but not more than 512 MB).' =>
            'Indstillingen \'query_cache_size\' bør anvendes (og sættes højere end 10 MB, men ikke højere end 512 MB).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/StorageEngine.pm
        'Default Storage Engine' => 'Default Storage Engine',
        'Table Storage Engine' => '',
        'Tables with a different storage engine than the default engine were found.' =>
            'Der er fundet tabeller lagret med anden storage enginge end default.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/mysql/Version.pm
        'MySQL 5.x or higher is required.' => 'MySQL 5.x eller nyere er påkrævet.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/oracle/NLS.pm
        'NLS_LANG Setting' => '',
        'NLS_LANG must be set to al32utf8 (e.g. GERMAN_GERMANY.AL32UTF8).' =>
            '',
        'NLS_DATE_FORMAT Setting' => '',
        'NLS_DATE_FORMAT must be set to \'YYYY-MM-DD HH24:MI:SS\'.' => '',
        'NLS_DATE_FORMAT Setting SQL Check' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Charset.pm
        'Setting client_encoding needs to be UNICODE or UTF8.' => 'Indstillingen client_encoding skal være UNICODE eller UTF8.',
        'Setting server_encoding needs to be UNICODE or UTF8.' => 'Indstillingen server_encoding skal være UNICODE eller UTF8.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/DateStyle.pm
        'Date Format' => 'Datoformat',
        'Setting DateStyle needs to be ISO.' => 'Indstillingen DateStyle skal være ISO.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Database/postgresql/Version.pm
        'PostgreSQL 8.x or higher is required.' => 'PostgreSQL 8.x eller nyere er påkrævet.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskPartitionOTRS.pm
        'OTRS Disk Partition' => 'OTRS Disk Partition',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpace.pm
        'Disk Usage' => 'Diskforbrug',
        'The partition where OTRS is located is almost full.' => 'Den partition OTRS befinder sig på er næsten fuld.',
        'The partition where OTRS is located has no disk space problems.' =>
            'Den partition OTRS befinder sig på har ingen pladsproblemer.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/DiskSpacePartitions.pm
        'Disk Partitions Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Distribution.pm
        'Distribution' => 'Distribution',
        'Could not determine distribution.' => 'Kunne ikke bestemme distribution.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/KernelVersion.pm
        'Kernel Version' => 'Kerne-version',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Load.pm
        'System Load' => 'System belastning',
        'The system load should be at maximum the number of CPUs the system has (e.g. a load of 8 or less on a system with 8 CPUs is OK).' =>
            'System Load skal være højst antallet af CPU\'er i serveren. (en load på 8 eller mindre i et system med 8 CPU\'er ok).',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/PerlModules.pm
        'Perl Modules' => 'Perl-moduler',
        'Not all required Perl modules are correctly installed.' => 'Ikke alle krævede Perl Moduler er installeret korrekt.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OS/Swap.pm
        'Free Swap Space (%)' => 'Fri Swap plads (%)',
        'No swap enabled.' => 'Ingen swap aktiveret.',
        'Used Swap Space (MB)' => 'Brugt Swap (MB)',
        'There should be more than 60% free swap space.' => 'Der bør være mere end 60% ledigt swap.',
        'There should be no more than 200 MB swap space used.' => 'Der bør ikke være mere end 200 MB brugt swap.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ConfigSettings.pm
        'OTRS' => 'OTRS',
        'Config Settings' => 'Konfigurationsindstillinger',
        'Could not determine value.' => 'Kunne ikke fastslå værdi.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DaemonRunning.pm
        'Daemon' => 'Tjeneste',
        'Daemon is running.' => '',
        'Daemon is not running.' => 'Tjeneste kører ikke.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DatabaseRecords.pm
        'Database Records' => '',
        'Tickets' => 'Sager',
        'Ticket History Entries' => 'Sagens Historik',
        'Articles' => 'Indlæg',
        'Attachments (DB, Without HTML)' => '',
        'Customers With At Least One Ticket' => 'Kunder med mindst én sag',
        'Dynamic Field Values' => '',
        'Invalid Dynamic Fields' => '',
        'Invalid Dynamic Field Values' => '',
        'GenericInterface Webservices' => '',
        'Process Tickets' => '',
        'Months Between First And Last Ticket' => 'Måneder mellem første og sidste sag',
        'Tickets Per Month (avg)' => 'Sager pr. måned (gennemsnit)',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultSOAPUser.pm
        'Default SOAP Username And Password' => '',
        'Security risk: you use the default setting for SOAP::User and SOAP::Password. Please change it.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/DefaultUser.pm
        'Default Admin Password' => '',
        'Security risk: the agent account root@localhost still has the default password. Please change it or invalidate the account.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/ErrorLog.pm
        'Error Log' => 'Fejl-log',
        'There are error reports in your system log.' => 'Der er fejl-rapporteringer i din systemlog.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FQDN.pm
        'FQDN (domain name)' => 'FQDN (domæne navn)',
        'Please configure your FQDN setting.' => '',
        'Domain Name' => 'Domæne-navn',
        'Your FQDN setting is invalid.' => 'Din FQDN-indstilling er ugyldig.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/FileSystemWritable.pm
        'File System Writable' => 'Filsystem skrivbart',
        'The file system on your OTRS partition is not writable.' => 'Filsystemet på din OTRS-partition er ikke skrivbart.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageDeployment.pm
        'Package Installation Status' => '',
        'Some packages have locally modified files.' => '',
        'Some packages are not correctly installed.' => 'Nogle pakker er ikke korrekt installeret.',
        'Package Verification Status' => '',
        'Some packages are not verified by the OTRS Group! It is recommended not to use this packages.' =>
            '',
        'Package Framework Version Status' => '',
        'Some packages are not allowed for the current framework version.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/PackageList.pm
        'Package List' => 'Pakkeliste',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SessionConfigSettings.pm
        'Session Config Settings' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SpoolMails.pm
        'Spooled Emails' => '',
        'There are emails in var/spool that OTRS could not process.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/SystemID.pm
        'Your SystemID setting is invalid, it should only contain digits.' =>
            'Din System-ID-instilling er ugyldig; den må kun indeholde tal.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/DefaultType.pm
        'Default Ticket Type' => '',
        'The configured default ticket type is invalid or missing. Please change the setting Ticket::Type::Default and select a valid ticket type.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/IndexModule.pm
        'Ticket Index Module' => '',
        'You have more than 60,000 tickets and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Du har mere end 60.000 sager og bør bruge StaticDB-backend. Se admin-manualen (performance tuning) for mere information.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/InvalidUsersWithLockedTickets.pm
        'Invalid Users with Locked Tickets' => '',
        'There are invalid users with locked tickets.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/OpenTickets.pm
        'Open Tickets' => 'Åbne Sager',
        'You should not have more than 8,000 open tickets in your system.' =>
            'Du bør ikke have mere end 8.000 åbne sager i dit system.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/SearchIndexModule.pm
        'Ticket Search Index Module' => '',
        'You have more than 50,000 articles and should use the StaticDB backend. See admin manual (Performance Tuning) for more information.' =>
            'Du har mere end 50.000 indlæg og bør bruge StaticDB-backend. Se admin-manualen (Performance Tuning) for yderligere information.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/Ticket/StaticDBOrphanedRecords.pm
        'Orphaned Records In ticket_lock_index Table' => '',
        'Table ticket_lock_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',
        'Orphaned Records In ticket_index Table' => '',
        'Table ticket_index contains orphaned records. Please run bin/otrs.Console.pl "Maint::Ticket::QueueIndexCleanup" to clean the StaticDB index.' =>
            '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/TimeSettings.pm
        'Time Settings' => '',
        'Server time zone' => 'Server tidszone',
        'Computed server time offset' => 'Beregnet server tidsforskydning',
        'OTRS TimeZone setting (global time offset)' => 'OTRS tidszone indstilling (Global tidsforskydning)',
        'TimeZone may only be activated for systems running in UTC.' => 'Tidszone kan kun aktiveres for systemer der kører UTC.',
        'OTRS TimeZoneUser setting (per-user time zone support)' => '',
        'TimeZoneUser may only be activated for systems running in UTC that don\'t have an OTRS TimeZone set.' =>
            '',
        'OTRS TimeZone setting for calendar ' => 'OTRS tidszone indstilling for kalender',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentSkinUsage.pm
        'UI - Agent Skin Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/OTRS/UI/AgentThemeUsage.pm
        'UI - Agent Theme Usage' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/LoadedModules.pm
        'Webserver' => 'Web-server',
        'Loaded Apache Modules' => 'Indlæste Apache-moduler',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/MPMModel.pm
        'MPM model' => '',
        'OTRS requires apache to be run with the \'prefork\' MPM model.' =>
            'OTRS kræver, at apache kører med MPM-modellen \'prefork\'.',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Apache/Performance.pm
        'CGI Accelerator Usage' => '',
        'You should use FastCGI or mod_perl to increase your performance.' =>
            '',
        'mod_deflate Usage' => '',
        'Please install mod_deflate to improve GUI speed.' => 'Installer mod_deflate for at forøge hastigheden på brugerinterfacet.',
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
        'Environment Variables' => 'Miljøvariable',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/InternalWebRequest.pm
        'Support Data Collection' => '',
        'Support data could not be collected from the web server.' => '',

        # Perl Module: Kernel/System/SupportDataCollector/Plugin/Webserver/Version.pm
        'Webserver Version' => 'Webserver-version',
        'Could not determine webserver version.' => 'Kunne ikke fastslå webserver-version.',

        # Perl Module: Kernel/System/SupportDataCollector/PluginAsynchronous/OTRS/ConcurrentUsers.pm
        'Concurrent Users Details' => '',
        'Concurrent Users' => 'Samtidige brugere',

        # Perl Module: Kernel/System/SupportDataCollector/PluginBase.pm
        'Unknown' => 'Ukendt',
        'OK' => 'OK',
        'Problem' => 'Problem',

        # Perl Module: Kernel/System/Ticket.pm
        'Reset of unlock time.' => 'Tid til automatisk frigivelse nulstillet.',

        # Perl Module: Kernel/System/Ticket/Event/NotificationEvent/Transport/Email.pm
        'PGP sign only' => '',
        'PGP encrypt only' => '',
        'PGP sign and encrypt' => '',
        'SMIME sign only' => '',
        'SMIME encrypt only' => '',
        'SMIME sign and encrypt' => '',
        'PGP and SMIME not enabled.' => '',
        'Skip notification delivery' => '',
        'Send unsigned notification' => '',
        'Send unencrypted notification' => '',

        # Perl Module: Kernel/System/Web/InterfaceAgent.pm
        'Authentication succeeded, but no user data record is found in the database. Please contact the administrator.' =>
            '',
        'Can`t remove SessionID.' => 'Kan ikke fjerne SessionsID.',
        'Logout successful.' => 'Succesfuldt logget ud.',
        'Error: invalid session.' => '',
        'No Permission to use this frontend module!' => '',

        # Perl Module: Kernel/System/Web/InterfaceCustomer.pm
        'Authentication succeeded, but no customer record is found in the customer backend. Please contact the administrator.' =>
            'Login lykkedes, men ingen kundeoplysninger er fundet i systemet. Kontakt venligst din administrator.',
        'Reset password unsuccessful. Please contact the administrator.' =>
            '',
        'Added via Customer Panel (%s)' => '',
        'Customer user can\'t be added!' => '',
        'Can\'t send account info!' => '',

        # Perl Module: Kernel/System/Web/InterfaceInstaller.pm
        'Action "%s" not found!' => '',

        # Database XML Definition: scripts/database/otrs-initial_insert.xml
        'Group for default access.' => '',
        'Group of all administrators.' => '',
        'Group for statistics access.' => 'Gruppe for adgang til rapporter.',
        'All new state types (default: viewable).' => 'Alle nye tilstandstyper (standard: synlig)',
        'All open state types (default: viewable).' => '',
        'All closed state types (default: not viewable).' => '',
        'All \'pending reminder\' state types (default: viewable).' => '',
        'All \'pending auto *\' state types (default: viewable).' => '',
        'All \'removed\' state types (default: not viewable).' => '',
        'State type for merged tickets (default: not viewable).' => 'Tilstandstype for samlede sager (standard: ikke synlig).',
        'New ticket created by customer.' => 'Ny sag oprettet af kunde.',
        'Ticket is closed successful.' => 'sagen er afsluttet succesfuldt',
        'Ticket is closed unsuccessful.' => 'Sag lukket uden løsning',
        'Open tickets.' => 'Åbne sager.',
        'Customer removed ticket.' => 'Kunden slettede sagen.',
        'Ticket is pending for agent reminder.' => '',
        'Ticket is pending for automatic close.' => '',
        'State for merged tickets.' => 'Tilstand for samlede sager.',
        'system standard salutation (en)' => 'Standard system indledning (en)',
        'Standard Salutation.' => 'Standard indledning.',
        'system standard signature (en)' => '',
        'Standard Signature.' => '',
        'Standard Address.' => '',
        'Follow-ups for closed tickets are possible. Ticket will be reopened.' =>
            '',
        'Follow-ups for closed tickets are not possible. No new ticket will be created.' =>
            '',
        'new ticket' => '',
        'Follow-ups for closed tickets are not possible. A new ticket will be created.' =>
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
        'Unclassified' => 'Uklassificeret',
        'tmp_lock' => '',
        'email-notification-ext' => '',
        'email-notification-int' => '',
        'Ticket create notification' => 'Besked om oprettelse af ny sag',
        'You will receive a notification each time a new ticket is created in one of your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (unlocked)' => 'Besked om opfølgning på sag (fri)',
        'You will receive a notification if a customer sends a follow-up to an unlocked ticket which is in your "My Queues" or "My Services".' =>
            '',
        'Ticket follow-up notification (locked)' => 'Besked om opfølgning på sag (trukket)',
        'You will receive a notification if a customer sends a follow-up to a locked ticket of which you are the ticket owner or responsible.' =>
            '',
        'You will receive a notification as soon as a ticket owned by you is automatically unlocked.' =>
            '',
        'Ticket owner update notification' => '',
        'Ticket responsible update notification' => '',
        'Ticket new note notification' => '',
        'Ticket queue update notification' => 'Besked om ændring af sagens kø',
        'You will receive a notification if a ticket is moved into one of your "My Queues".' =>
            '',
        'Ticket pending reminder notification (locked)' => '',
        'Ticket pending reminder notification (unlocked)' => '',
        'Ticket escalation notification' => '',
        'Ticket escalation warning notification' => '',
        'Ticket service update notification' => 'Besked om ændring af service på sag',
        'You will receive a notification if a ticket\'s service is changed to one of your "My Services".' =>
            '',

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
        '"%s" notification was sent to "%s" by "%s".' => '"%s" besked blev sendt til "%s" via "%s".',
        '"Slim" skin which tries to save screen space for power users.' =>
            '',
        '%s' => 'Diverse %s',
        '%s time unit(s) accounted. Now total %s time unit(s).' => '%s tidsenheder registreret. Nu i alt %s tidsenheder brugt.',
        '(UserLogin) Firstname Lastname' => '(BrugerLogin) Fornavn Efternavn',
        '(UserLogin) Lastname Firstname' => '(BrugerLogin) Efternavn Fornavn',
        '(UserLogin) Lastname, Firstname' => '(BrugerLogin) Efternavn Fornavn',
        '*** out of office until %s (%s d left) ***' => '',
        '100 (Expert)' => '',
        '200 (Advanced)' => '',
        '300 (Beginner)' => '',
        'A TicketWatcher Module.' => '',
        'A Website' => 'En hjemmeside',
        'A list of dynamic fields that are merged into the main ticket during a merge operation. Only dynamic fields that are empty in the main ticket will be set.' =>
            '',
        'A picture' => 'Et billede',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL-modul, der kun tillader lukning af hovedsager, hvis alle undersager allerede er lukkede ("Tilstand" viser hvilke tilstande, der ikke kan vælges for hovedsagen indtal alle undersager er lukkede).',
        'Access Control Lists (ACL)' => '',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Aktiverer en blinkemekanisme for den kø, der indeholder den ældste sag.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Aktiverer muligheden for at agenter kan nulstille deres passwords i agent-interfacet.',
        'Activates lost password feature for customers.' => 'Aktiverer muligheden for at kunder kan nulstille deres passwords i kunde-interfacet',
        'Activates support for customer groups.' => 'Aktiverer understøttelse af kundegrupper.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Aktiverer indlægsfilteret i ZoomView for at specificere hvilke indlæg, der skal vises.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Aktiverer de tilgængelige temaer på dit system. 1 betyder aktiv, 0 betyder inaktiv.',
        'Activates the ticket archive system search in the customer interface.' =>
            '',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            '',
        'Activates time accounting.' => '',
        'ActivityID' => '',
        'Add a comment.' => '',
        'Add a default name for Dynamic Field.' => '',
        'Add an inbound phone call to this ticket' => 'Tilføj indgående telefonopkald til denne sag',
        'Add an outbound phone call to this ticket' => 'Tilføj udgående telefonopkald til denne sag',
        'Added email. %s' => 'Tilføjet email. %s',
        'Added link to ticket "%s".' => 'Tilføjet link til sag %s.',
        'Added note (%s)' => 'Tilføjede bemærkning (%s).',
        'Added subscription for user "%s".' => 'Bruger "%s" følger nu sagen.',
        'Address book of CustomerUser sources.' => '',
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
        'Admin Area.' => '',
        'After' => 'Efter',
        'Agent Name' => '',
        'Agent Name + FromSeparator + System Address Display Name' => '',
        'Agent Preferences.' => '',
        'Agent called customer.' => 'Agent ringede kunden op.',
        'Agent interface article notification module to check PGP.' => '',
        'Agent interface article notification module to check S/MIME.' =>
            '',
        'Agent interface module to access CIC search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access fulltext search via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to access search profiles via nav bar. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            '',
        'Agent interface notification module to see the number of locked tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets an agent is responsible for. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of tickets in My Services. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Agent interface notification module to see the number of watched tickets. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'AgentCustomerSearch' => '',
        'AgentCustomerSearch.' => '',
        'AgentUserSearch' => '',
        'AgentUserSearch.' => '',
        'Agents <-> Groups' => 'Agenter <-> Grupper',
        'Agents <-> Roles' => 'Agenter <-> Roller',
        'All customer users of a CustomerID' => 'Alle kundebrugere af et CustomerID',
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
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            '',
        'Allows extended search conditions in ticket search of the generic agent interface. With this feature you can search e. g. ticket title with this kind of conditions like "(*key1*&&*key2*)" or "(*key1*||*key2*)".' =>
            'Tillader udvidede søgetermer i sagssøgningen i automatisk agent-interfacet. Med denne funktionalitet kan du søge f.eks. "(nøgle1&&nøgle2)" eller "(nøgle1||nøgle2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            '',
        'Allows invalid agents to generate individual-related stats.' => '',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            'Tillad administratorer at logge ind som andre kunder via kundebruger-administrationspanelet.',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            '',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            '',
        'Always show RichText if available' => '',
        'Arabic (Saudi Arabia)' => 'Arabisk (Saudi Arabien)',
        'Archive state changed: "%s"' => 'Arkivflag opdateret',
        'ArticleTree' => 'Indlægstræ',
        'Attachments <-> Templates' => 'Vedhæftede filer <-> Skabeloner',
        'Auto Responses <-> Queues' => 'Autosvar <-> Køer',
        'AutoFollowUp sent to "%s".' => 'Automatisk opfølgning send til "%s".',
        'AutoReject sent to "%s".' => 'Automatisk afvisning sendt til "%s".',
        'AutoReply sent to "%s".' => 'Automatisk svar sendt til "%s".',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after opening the move ticket screen of the agent interface.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled). This will only work by manually actions of the logged in user. It does not work for automated actions e.g. GenericAgent, Postmaster and GenericInterface.' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
        'Balanced white skin by Felix Niklas (slim version).' => '',
        'Balanced white skin by Felix Niklas.' => '',
        'Based on global RichText setting' => '',
        'Basic fulltext index settings. Execute "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            '',
        'Bounced to "%s".' => 'Overgivet til "%s".',
        'Builds an article index right after the article\'s creation.' =>
            '',
        'Bulgarian' => '',
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
        'Catalan' => '',
        'Change password' => 'Skift password',
        'Change queue!' => 'Skift kø',
        'Change the customer for this ticket' => 'Ændr denne sags kunde',
        'Change the free fields for this ticket' => 'Ændr denne sags frie felter',
        'Change the priority for this ticket' => 'Ændr denne sags prioritet',
        'Change the responsible for this ticket' => 'Skift sagens ansvarlige',
        'Changed priority from "%s" (%s) to "%s" (%s).' => 'Ændrede prioritet fra "%s" (%s) til "%s" (%s)',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => 'Checkboks',
        'Checks if an E-Mail is a followup to an existing ticket by searching the subject for a valid ticket number.' =>
            '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Checks the availability of OTRS Business Solution™ for this system.' =>
            '',
        'Checks the entitlement status of OTRS Business Solution™.' => '',
        'Chinese (Simplified)' => '',
        'Chinese (Traditional)' => '',
        'Choose for which kind of ticket changes you want to receive notifications.' =>
            '',
        'Closed tickets (customer user)' => 'Lukkede sager (kundebruger)',
        'Closed tickets (customer)' => 'Afsluttede sager (kunde)',
        'Cloud Services' => 'Sky-tjenester',
        'Cloud service admin module registration for the transport layer.' =>
            '',
        'Collect support data for asynchronous plug-in modules.' => '',
        'Column ticket filters for Ticket Overviews type "Small".' => 'Kolonnefiltre for sagsoversigter af typen "Small".',
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
        'Comment for new history entries in the customer interface.' => '',
        'Comment2' => '',
        'Communication' => 'Kommunikation',
        'Company Status' => 'Firma Status',
        'Company Tickets.' => '',
        'Company name which will be included in outgoing emails as an X-Header.' =>
            'Firmanavn der inkluderes som en X-Header i udgående email.',
        'Compat module for AgentZoom to AgentTicketZoom.' => '',
        'Complex' => '',
        'Configure Processes.' => '',
        'Configure and manage ACLs.' => 'Konfigurer og håndter ACL\'er.',
        'Configure any additional readonly mirror databases that you want to use.' =>
            '',
        'Configure sending of support data to OTRS Group for improved support.' =>
            '',
        'Configure which screen should be shown after a new ticket has been created.' =>
            'Konfigurer hvilken side der skal vises efter en ny sag er oprettet.',
        'Configure your own log text for PGP.' => '',
        'Configures a default TicketDynamicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://otrs.github.io/doc/), chapter "Ticket Event Module".' =>
            '',
        'Controls how to display the ticket history entries as readable values.' =>
            '',
        'Controls if CustomerID is automatically copied from the sender address for unknown customers.' =>
            '',
        'Controls if CustomerID is read-only in the agent interface.' => '',
        'Controls if customers have the ability to sort their tickets.' =>
            '',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the admin is allowed to import a saved system configuration in SysConfig.' =>
            '',
        'Controls if the admin is allowed to make changes to the database via AdminSelectBox.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => '',
        'Create New process ticket.' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Administrer Service Level Agreements (SLA\'er).',
        'Create and manage agents.' => 'Administrer agenter.',
        'Create and manage attachments.' => 'Administrer vedhæftede filer.',
        'Create and manage customer users.' => 'Opret og administrer kundebrugere.',
        'Create and manage customers.' => 'Administrer kunder.',
        'Create and manage dynamic fields.' => 'Opret og administrer dynamiske felter.',
        'Create and manage groups.' => 'Administrer grupper.',
        'Create and manage queues.' => 'Administrer køer.',
        'Create and manage responses that are automatically sent.' => 'Administrer svar, der sendes automatisk.',
        'Create and manage roles.' => 'Administrer roller',
        'Create and manage salutations.' => 'Administrer indledninger.',
        'Create and manage services.' => 'Administrer services.',
        'Create and manage signatures.' => 'Administrer signaturer.',
        'Create and manage templates.' => 'Opret og administrer skabeloner',
        'Create and manage ticket notifications.' => 'Opret og håndter beskeder om sager',
        'Create and manage ticket priorities.' => 'Administrer sagsprioriteter.',
        'Create and manage ticket states.' => 'Administrer sagstilstande.',
        'Create and manage ticket types.' => 'Administrer sagstyper.',
        'Create and manage web services.' => 'Opret og administrer web-services.',
        'Create new Ticket.' => '',
        'Create new email ticket and send this out (outbound).' => '',
        'Create new email ticket.' => '',
        'Create new phone ticket (inbound).' => '',
        'Create new phone ticket.' => '',
        'Create new process ticket.' => '',
        'Create tickets.' => '',
        'Croatian' => '',
        'Custom RSS Feed' => '',
        'Custom text for the page shown to customers that have no tickets yet (if you need those text translated add them to a custom translation module).' =>
            '',
        'Customer Administration' => 'Kunde Administration',
        'Customer Information Center Search.' => '',
        'Customer Information Center.' => '',
        'Customer Ticket Print Module.' => '',
        'Customer User <-> Groups' => 'Kundebruger <-> Grupper',
        'Customer User <-> Services' => 'Kundebruger <-> Services',
        'Customer User Administration' => 'Kundebruger-administration',
        'Customer Users' => 'Kundebrugere',
        'Customer called us.' => 'Kundende ringede os op.',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer preferences.' => '',
        'Customer request via web.' => 'Kundeanmodning via web.',
        'Customer ticket overview' => '',
        'Customer ticket search.' => '',
        'Customer ticket zoom' => '',
        'Customer user search' => 'Søg efter kundebruger',
        'CustomerID search' => 'KundeID søgning',
        'CustomerName' => 'KundeNavn',
        'CustomerUser' => '',
        'Customers <-> Groups' => 'Kunder <-> Grupper',
        'Customizable stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Czech' => '',
        'DEPRECATED: This config setting will be removed in further versions of OTRS. Sets the time (in seconds) a user is marked as active (minimum active time is 300 seconds).' =>
            '',
        'Danish' => 'Dansk',
        'Data used to export the search result in CSV format.' => 'Data brugt til at eksportere søgeresultatet i CSV-format.',
        'Date / Time' => 'Dato / Tid',
        'Debug' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Debugger oversættelsen. Er denne sat til "Ja", vil alle strenge (tekst) uden oversættelser blive skrevet til STDERR. Det kan hjælpe, hvis du er ved at lave en oversættelse af OTRS. Ellers bør denne valgmulighed sættes til "Nej".',
        'Default' => '',
        'Default (Slim)' => '',
        'Default ACL values for ticket actions.' => '',
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
        'Default loop protection module.' => '',
        'Default queue ID used by the system in the agent interface.' => '',
        'Default skin for the agent interface (slim version).' => '',
        'Default skin for the agent interface.' => '',
        'Default skin for the customer interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define Actions where a settings button is available in the linked objects widget (LinkObject::ViewMode = "complex"). Please note that these Actions must have registered the following JS and CSS files: Core.AllocationList.css, Core.UI.AllocationList.js, Core.UI.Table.Sort.js, Core.Agent.TableFilters.js.' =>
            '',
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
        'Define the start day of the week for the date picker.' => 'Definer ugens første dag for datovælgeren.',
        'Define which columns are shown in the linked tickets widget (LinkObject::ViewMode = "complex"). Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
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
        'Defines a filter to collect CVE numbers from article texts in AgentTicketZoom. The results will be displayed in a meta box next to the article. Fill in URLPreview if you would like to see a preview when moving your mouse cursor above the link element. This could be the same URL as in URL, but also an alternate one. Please note that some websites deny being displayed within an iframe (e.g. Google) and thus won\'t work with the preview mode.' =>
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
        'Defines all the X-headers that should be scanned.' => '',
        'Defines all the languages that are available to the application. Specify only English names of languages here.' =>
            '',
        'Defines all the languages that are available to the application. Specify only native names of languages here.' =>
            '',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            '',
        'Defines all the parameters for this item in the customer preferences.' =>
            '',
        'Defines all the parameters for this item in the customer preferences. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control).' =>
            '',
        'Defines all the parameters for this notification transport.' => '',
        'Defines all the possible stats output formats.' => '',
        'Defines an alternate URL, where the login link refers to.' => '',
        'Defines an alternate URL, where the logout link refers to.' => '',
        'Defines an alternate login URL for the customer panel..' => '',
        'Defines an alternate logout URL for the customer panel.' => '',
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
            '',
        'Defines if customers should be allowed to login if they have no shared secret stored in their preferences and therefore are not using two-factor authentication.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.) in customer interface.' =>
            '',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if the previously valid token should be accepted for authentication. This is slightly less secure but gives users 30 seconds more time to enter their one-time password.' =>
            '',
        'Defines if the values for filters should be retrieved from all available tickets. If set to "Yes", only values which are actually used in any ticket will be available for filtering. Please note: The list of customers will always be retrieved like this.' =>
            '',
        'Defines if time accounting is mandatory in the agent interface. If activated, a note must be entered for all ticket actions (no matter if the note itself is configured as active or is originally mandatory for the individual ticket action screen).' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines out of office message template. Two string parameters (%s) available: end date and number of days left.' =>
            '',
        'Defines queues that\'s tickets are used for displaying as calendar events.' =>
            '',
        'Defines the HTTP hostname for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            '',
        'Defines the URL CSS path.' => 'Definer URL sti til CSS.',
        'Defines the URL base path of icons, CSS and Java Script.' => '',
        'Defines the URL image path of icons for navigation.' => '',
        'Defines the URL java script path.' => '',
        'Defines the URL rich text editor path.' => '',
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
        'Defines the body text for rejected emails.' => '',
        'Defines the calendar width in percent. Default is 95%.' => '',
        'Defines the cluster node identifier. This is only used in cluster configurations where there is more than one OTRS frontend system. Note: only values from 1 to 99 are allowed.' =>
            '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
        'Defines the config options for the autocompletion feature.' => '',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. \'PasswordRegExp\' allows to match passwords against a regular expression. Define the minimum number of characters using \'PasswordMinSize\'. Define if at least 2 lowercase and 2 uppercase letter characters are needed by setting the appropriate option to \'1\'. \'PasswordMin2Characters\' defines if the password needs to contain at least 2 letter characters (set to 0 or 1). \'PasswordNeedDigit\' controls the need of at least 1 digit (set to 0 or 1 to control). \'PasswordMaxLoginFailed\' allows to set an agent to invalid-temporarily if max failed logins reached.' =>
            '',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            '',
        'Defines the connections for http/ftp, via a proxy.' => '',
        'Defines the customer preferences key where the shared secret key is stored.' =>
            '',
        'Defines the date input format used in forms (option or input fields).' =>
            '',
        'Defines the default CSS used in rich text editors.' => '',
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
            'Definerer det maksimale antal rapporter pr. side på oversigtsskærmen.',
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
        'Defines the default shown ticket search attribute for ticket search screen (AllTickets/ArchivedTickets/NotArchivedTickets).' =>
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
        'Defines the default spell checker dictionary.' => '',
        'Defines the default state of new customer tickets in the customer interface.' =>
            '',
        'Defines the default state of new tickets.' => 'Definerer standardtilstand for nye sager.',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Defines the default subject of a note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default the number of seconds (from current time) to re-schedule a generic interface failed task.' =>
            '',
        'Defines the default ticket attribute for ticket sorting in a ticket search of the customer interface.' =>
            'Vælg standard-feltet for sortering af sager i en søgning foretaget i kunde-interfacet.',
        'Defines the default ticket attribute for ticket sorting in the escalation view of the agent interface.' =>
            'Vælg standard-feltet for sortering af sager i oversigten over eskalerede sager i agent-interfacet.',
        'Defines the default ticket attribute for ticket sorting in the locked ticket view of the agent interface.' =>
            'Vælg standard-feltet for sortering af sager i oversigten over trukkede sager i agent-interfacet.',
        'Defines the default ticket attribute for ticket sorting in the responsible view of the agent interface.' =>
            'Vælg standard-feltet for sortering af sager i oversigten over ansvarlige i agent-interfacet.',
        'Defines the default ticket attribute for ticket sorting in the status view of the agent interface.' =>
            'Vælg standard-feltet for sortering af sager i status-oversigten i agent-interfacet.',
        'Defines the default ticket attribute for ticket sorting in the watch view of the agent interface.' =>
            'Vælg standard-feltet for sortering af sager i oversigten over fulgte sager i agent-interfacet.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of the agent interface.' =>
            'Vælg standard-feltet for sortering af sager i en søgning foretaget i agent-interfacet.',
        'Defines the default ticket attribute for ticket sorting of the ticket search result of this operation.' =>
            'Vælg standard-feltet for sortering af sager i en søgning foretaget af denne handling.',
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
        'Defines the default ticket type.' => '',
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
        'Defines the list of possible next actions on an error screen, a full path is required, then is possible to add external links if needed.' =>
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
        'Defines the maximum number of affected tickets per job.' => '',
        'Defines the maximum number of pages per PDF file.' => '',
        'Defines the maximum number of quoted lines to be added to responses.' =>
            '',
        'Defines the maximum number of tasks to be executed as the same time.' =>
            '',
        'Defines the maximum size (in MB) of the log file.' => '',
        'Defines the maximum size in KiloByte of GenericInterface responses that get logged to the gi_debugger_entry_content table.' =>
            '',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in customers in the agent interface.' =>
            '',
        'Defines the module that shows the currently logged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently logged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'Definerer modul til godkendelse af kunder.',
        'Defines the module to display a notification if cloud services are disabled.' =>
            '',
        'Defines the module to display a notification in different interfaces on different occasions for OTRS Business Solution™.' =>
            '',
        'Defines the module to display a notification in the agent interface if the OTRS Daemon is not running.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having out-of-office active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent is logged in while having system maintenance active.' =>
            '',
        'Defines the module to display a notification in the agent interface, if the agent session limit prior warning is reached.' =>
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
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table where the user preferences are stored.' =>
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
        'Defines the number of days to keep the daemon log files.' => '',
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
        'Defines the postmaster default queue.' => 'Definerer postmasters standard kø.',
        'Defines the priority in which the information is logged and presented.' =>
            '',
        'Defines the recipient target of the phone ticket and the sender of the email ticket ("Queue" shows all queues, "System address" displays all system addresses) in the agent interface.' =>
            '',
        'Defines the recipient target of the tickets ("Queue" shows all queues, "SystemAddress" shows only the queues which are assigned to system addresses) in the customer interface.' =>
            '',
        'Defines the required permission to show a ticket in the escalation view of the agent interface.' =>
            '',
        'Defines the search limit for the stats.' => '',
        'Defines the sender for rejected emails.' => '',
        'Defines the separator between the agents real name and the given queue email address.' =>
            '',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => 'Definerer standard størrelsen på PDF sider',
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
        'Defines the timeout (in seconds, minimum is 20 seconds) for the support data collection with the public module \'PublicSupportDataCollector\' (e.g. used from the OTRS Daemon).' =>
            '',
        'Defines the two-factor module to authenticate agents.' => '',
        'Defines the two-factor module to authenticate customers.' => '',
        'Defines the type of protocol, used by the web server, to serve the application. If https protocol will be used instead of plain http, it must be specified here. Since this has no affect on the web server\'s settings or behavior, it will not change the method of access to the application and, if it is wrong, it will not prevent you from logging into the application. This setting is only used as a variable, OTRS_CONFIG_HttpType which is found in all forms of messaging used by the application, to build links to the tickets within your system.' =>
            '',
        'Defines the used character for plaintext email quotes in the ticket compose screen of the agent interface. If this is empty or inactive, original emails will not be quoted but appended to the response.' =>
            '',
        'Defines the user identifier for the customer panel.' => '',
        'Defines the username to access the SOAP handle (bin/cgi-bin/rpc.pl).' =>
            '',
        'Defines the valid state types for a ticket.' => 'Definerer de gyldige tilstandstyper for en sag.',
        'Defines the valid states for unlocked tickets. To unlock tickets the script "bin/otrs.Console.pl Maint::Ticket::UnlockTimeout" can be used.' =>
            '',
        'Defines the viewable locks of a ticket. NOTE: When you change this setting, make sure to delete the cache in order to use the new value. Default: unlock, tmp_lock.' =>
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
        'Deleted link to ticket "%s".' => 'Slettet link til sag %s.',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Delivers extended debugging information in the frontend in case any AJAX errors occur, if enabled.' =>
            '',
        'Deploy and manage OTRS Business Solution™.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the statistics module may generate ticket lists.' =>
            'Angiver om rapport-modulet må generere sagslister.',
        'Determines the next possible ticket states, after the creation of a new email ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, after the creation of a new phone ticket in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the agent interface.' =>
            '',
        'Determines the next possible ticket states, for process tickets in the customer interface.' =>
            '',
        'Determines the next screen after new customer ticket in the customer interface.' =>
            '',
        'Determines the next screen after the follow-up screen of a zoomed ticket in the customer interface.' =>
            '',
        'Determines the next screen after the ticket is moved. LastScreenOverview will return the last overview screen (e.g. search results, queueview, dashboard). TicketZoom will return to the TicketZoom.' =>
            '',
        'Determines the possible states for pending tickets that changed state after reaching time limit.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the phone ticket and as sender (From:) of the email ticket in the agent interface. For Queue as NewQueueSelectionType "<Queue>" shows the names of the queues and for SystemAddress "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the strings that will be shown as recipient (To:) of the ticket in the customer interface. For Queue as CustomerPanelSelectionType, "<Queue>" shows the names of the queues, and for SystemAddress, "<Realname> <<Email>>" shows the name and email of the recipient.' =>
            '',
        'Determines the way the linked objects are displayed in each zoom mask.' =>
            '',
        'Determines which options will be valid of the recipient (phone ticket) and the sender (email ticket) in the agent interface.' =>
            '',
        'Determines which queues will be valid for ticket\'s recepients in the customer interface.' =>
            '',
        'Disable HTTP header "Content-Security-Policy" to allow loading of external script contents. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable HTTP header "X-Frame-Options: SAMEORIGIN" to allow OTRS to be included as an IFrame in other websites. Disabling this HTTP header can be a security issue! Only disable it, if you know what you are doing!' =>
            '',
        'Disable restricted security for IFrames in IE. May be required for SSO to work in IE.' =>
            '',
        'Disables sending reminder notifications to the responsible agent of a ticket (Ticket::Responsible needs to be activated).' =>
            '',
        'Disables the communication between this system and OTRS Group servers that provides cloud services. If active, some functionality will be lost such as system registration, support data sending, upgrading to and use of OTRS Business Solution™, OTRS Verify™, OTRS News and product News dashboard widgets, among others.' =>
            '',
        'Disables the web installer (http://yourhost.example.com/otrs/installer.pl), to prevent the system from being hijacked. If set to "No", the system can be reinstalled and the current basic configuration will be used to pre-populate the questions within the installer script. If not active, it also disables the GenericAgent, PackageManager and SQL Box.' =>
            '',
        'Display a warning and prevent search when using stop words within fulltext search.' =>
            '',
        'Display settings to override defaults for Process Tickets.' => '',
        'Displays the accounted time for an article in the ticket zoom view.' =>
            '',
        'Dropdown' => '',
        'Dutch stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Dynamic Fields Checkbox Backend GUI' => '',
        'Dynamic Fields Date Time Backend GUI' => '',
        'Dynamic Fields Drop-down Backend GUI' => '',
        'Dynamic Fields GUI' => '',
        'Dynamic Fields Multiselect Backend GUI' => '',
        'Dynamic Fields Overview Limit' => 'Dynamiske Felter oversigtsgrænse',
        'Dynamic Fields Text Backend GUI' => '',
        'Dynamic Fields used to export the search result in CSV format.' =>
            '',
        'Dynamic fields groups for process widget. The key is the name of the group, the value contains the fields to be shown. Example: \'Key => My Group\', \'Content: Name_X, NameY\'.' =>
            '',
        'Dynamic fields limit per page for Dynamic Fields Overview' => 'Antal dynamiske felter pr side for oversigter med dynamiske felter',
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
        'DynamicField' => '',
        'DynamicField backend registration.' => '',
        'DynamicField object registration.' => '',
        'E-Mail Outbound' => 'Udgående E-Mail',
        'Edit Customer Companies.' => '',
        'Edit Customer Users.' => '',
        'Edit customer company' => 'Rediger kunde firma',
        'Email Addresses' => 'Email-adresser',
        'Email Outbound' => '',
        'Email sent to "%s".' => 'Email sendt til "%s".',
        'Email sent to customer.' => 'Email sendt til agent.',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enabled filters.' => 'Aktive filtre.',
        'Enables PGP support. When PGP support is enabled for signing and encrypting mail, it is HIGHLY recommended that the web server runs as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Aktiverer S/MIME-understøttelse',
        'Enables customers to create their own accounts.' => 'Lader kunder oprette deres egne konti.',
        'Enables fetch S/MIME from CustomerUser backend support.' => '',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disables the caching for templates. WARNING: Do NOT disable template caching for production environments for it will cause a massive performance drop! This setting should only be disabled for debugging reasons!' =>
            '',
        'Enables or disables the debug mode over frontend interface.' => '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Aktiverer understøttelse for stavekontrol.',
        'Enables the minimal ticket counter size (if "Date" was selected as TicketNumberGenerator).' =>
            '',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'English (Canada)' => '',
        'English (United Kingdom)' => '',
        'English (United States)' => '',
        'English stop words for fulltext index. These words will be removed from the search index.' =>
            '',
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
        'Escalation view' => 'Eskalerede sager',
        'EscalationTime' => '',
        'Estonian' => '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Event module that performs an update statement on TicketIndex to rename the queue name there if needed and if StaticDB is actually used.' =>
            '',
        'Event module that updates customer user search profiles if login changes.' =>
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
        'Execute SQL statements.' => 'Udfør SQL-kommandoer.',
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
        'Filter incoming emails.' => 'Filtrer indgående mail.',
        'Finnish' => '',
        'First Queue' => '',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Firstname Lastname' => 'Fornavn Efternavn',
        'Firstname Lastname (UserLogin)' => 'Fornavn Efternavn (BrugerLogin)',
        'FollowUp for [%s]. %s' => 'Opfølgning til sag %s. %s',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Forwarded to "%s".' => 'Videresendt til "%s".',
        'French' => '',
        'French (Canada)' => '',
        'French stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Frontend' => '',
        'Frontend module registration (disable AgentTicketService link if Ticket Service feature is not used).' =>
            '',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available) for Customer.' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Tema til frontend',
        'Frontend theme.' => '',
        'Full value' => '',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'Fulltext search' => '',
        'Galician' => '',
        'General ticket data shown in the ticket overviews (fall-back). Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default. Note that TicketNumber can not be disabled, because it is necessary.' =>
            '',
        'Generate dashboard statistics.' => 'Generer dashboard-rapporter.',
        'Generic Info module.' => '',
        'GenericAgent' => 'Automatisk Agent',
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
        'German' => '',
        'German stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Gives end users the possibility to override the separator character for CSV files, defined in the translation files.' =>
            '',
        'Global Search Module.' => '',
        'Go back' => 'Tilbage',
        'Google Authenticator' => 'Google Authenticator',
        'Graph: Bar Chart' => '',
        'Graph: Line Chart' => '',
        'Graph: Stacked Area Chart' => '',
        'Greek' => '',
        'HTML Reference' => '',
        'HTML Reference.' => '',
        'Hebrew' => '',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.Console.pl Maint::Ticket::FulltextIndexRebuild".' =>
            '',
        'Hindi' => '',
        'Hungarian' => '',
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
            'Hvis "LDAP" er valgt for Customer::Authmodule kan du bestemme om en bruger må logge ind ved at gøre dem til medlem af en possixGroup, f.eks. brugeren skal være medlem af gruppe xyz for at benytte OTRS. Angiv gruppen der skal have adgang til systemet.',
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
        'If enabled the daemon will redirect the standard error stream to a log file.' =>
            '',
        'If enabled the daemon will redirect the standard output stream to a log file.' =>
            '',
        'If enabled the daemon will use this directory to create its PID files. Note: Please stop the daemon before any change and use this setting only if <$OTRSHome>/var/run/ can not be used.' =>
            '',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            '',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            '',
        'If enabled, the OTRS version tag will be removed from the Webinterface, the HTTP headers and the X-Headers of outgoing mails. NOTE: If you change this option, please make sure to delete the cache.' =>
            '',
        'If enabled, the customer can search for tickets in all services (regardless what services are assigned to the customer).' =>
            '',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Hvis aktiveret, vil de forskellige oversigter (Dashboard, Sagsoversigt, Køoversigt) automatisk opdateres efter den angivne periode.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If no SendmailNotificationEnvelopeFrom is specified, this setting makes it possible to use the email\'s from address instead of an empty envelope sender (required in certain mail server configurations).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty (unless SendmailNotificationEnvelopeFrom::FallbackToEmailFrom is set).' =>
            '',
        'If set, this address is used as envelope sender in outgoing messages (not notifications - see below). If no address is specified, the envelope sender is equal to queue e-mail address.' =>
            '',
        'If this option is disabled, articles will not automatically be decrypted and stored in the database. Please note that this also means no decryption will take place and the articles will be shown in ticket zoom in their original (encrypted) form.' =>
            '',
        'If this option is set to \'Yes\', tickets created via the web interface, via Customers or Agents, will receive an autoresponse if configured. If this option is set to \'No\', no autoresponses will be sent.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Hvis denne regex passer, sendes der ikke autosvar.',
        'If this setting is active, local modifications will not be highlighted as errors in the package manager and support data collector.' =>
            '',
        'If you\'re going to be out of office, you may wish to let other users know by setting the exact dates of your absence.' =>
            '',
        'Ignore system sender article types (e. g. auto responses or email notifications) to be flagged as \'Unread Article\' in AgentTicketZoom or expanded automatically in Large view screens.' =>
            '',
        'Include tickets of subqueues per default when selecting a queue.' =>
            '',
        'Include unknown customers in ticket filter.' => '',
        'Includes article create times in the ticket search of the agent interface.' =>
            '',
        'Incoming Phone Call.' => '',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the command "bin/otrs.Console.pl Maint::Ticket::QueueIndexRebuild" for initial index creation.' =>
            '',
        'Indonesian' => '',
        'Input' => '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Sprog',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Italian' => '',
        'Italian stop words for fulltext index. These words will be removed from the search index.' =>
            '',
        'Ivory' => '',
        'Ivory (Slim)' => '',
        'Japanese' => '',
        'JavaScript function for the search frontend.' => '',
        'Last customer subject' => '',
        'Lastname Firstname' => 'Efternavn Fornavn',
        'Lastname Firstname (UserLogin)' => 'Efternavn Fornavn (BrugerLogin)',
        'Lastname, Firstname' => 'Efternavn, Fornavn',
        'Lastname, Firstname (UserLogin)' => 'Efternavn, Fornavn (BrugerLogin)',
        'Latvian' => '',
        'Left' => 'Venstre',
        'Link Object' => 'Kæd',
        'Link Object.' => '',
        'Link agents to groups.' => 'Kæd agenter til grupper.',
        'Link agents to roles.' => 'Kæd agenter til roller.',
        'Link attachments to templates.' => 'Kæd vedhæftede filer til skabeloner',
        'Link customer user to groups.' => 'Kæd kundebrugere til grupper.',
        'Link customer user to services.' => 'Kæd kundebrugere til services.',
        'Link queues to auto responses.' => 'Kæd autosvar til køer',
        'Link roles to groups.' => 'Kæd roller til grupper.',
        'Link templates to queues.' => 'Kæd skabeloner til køer',
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
        'Lithuanian' => '',
        'Lock / unlock this ticket' => 'Træk/Frigør denne sag',
        'Locked Tickets.' => '',
        'Locked ticket.' => 'Sag trukket.',
        'Log file for the ticket counter.' => 'Log-fil for sagsnummer-tælleren.',
        'Logged-In Users' => '',
        'Logout of customer panel.' => '',
        'Loop-Protection! No auto-response sent to "%s".' => 'Loop-beskyttelse! Intet autosvar sendt til "%s".',
        'Mail Accounts' => 'Mail Kontoer',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Malay' => '',
        'Manage OTRS Group cloud services.' => '',
        'Manage PGP keys for email encryption.' => 'Administrer PGP-nøgler for mail-kryptering',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Administrer POP3- eller IMAP-konto, der skal hentes mail fra.',
        'Manage S/MIME certificates for email encryption.' => 'Administrer S/MIME-certifikater for mail-kryptering.',
        'Manage existing sessions.' => 'Administrer eksisterende sessioner.',
        'Manage support data.' => 'Håndter support-data.',
        'Manage system registration.' => 'Håndter systemregistrering.',
        'Manage tasks triggered by event or time based execution.' => 'Administrer opgaver, der bliver udført på baggrund af hændelser eller tid.',
        'Mark this ticket as junk!' => 'Marker denne sag som junk!',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply and in some overview screens.' =>
            '',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum Number of a calendar shown in a dropdown.' => '',
        'Maximum length (in characters) of the dynamic field in the article of the ticket zoom view.' =>
            '',
        'Maximum length (in characters) of the dynamic field in the sidebar of the ticket zoom view.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Det højeste antal sager, der kan vises som resultat af en søgning i agent-interfacet.',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Det højeste antal sager, der kan vises som resultat af en søgning i kunde-interfacet.',
        'Maximum number of tickets to be displayed in the result of this operation.' =>
            'Det højeste antal sager, der kan vises som resultat af denne handling.',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Merge this ticket and all articles into another ticket' => '',
        'Merged Ticket <OTRS_TICKET> to <OTRS_MERGE_TO_TICKET>.' => 'Samlet sag <OTRS_TICKET> med <OTRS_MERGE_TO_TICKET>.',
        'Miscellaneous' => 'Diverse',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwarded internal email). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the group permissions for customer access to tickets.' =>
            '',
        'Module to check the group permissions for the access to tickets.' =>
            '',
        'Module to compose signed messages (PGP or S/MIME).' => '',
        'Module to crypt composed messages (PGP or S/MIME).' => '',
        'Module to fetch customer users SMIME certificates of incoming messages.' =>
            '',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            '',
        'Module to filter and manipulate incoming messages. Get a 4 digit number to ticket free text, use regex in Match e. g. From => \'(.+?)@.+?\', and use () as [***] in Set =>.' =>
            '',
        'Module to filter encrypted bodies of incoming messages.' => '',
        'Module to generate accounted time ticket statistics.' => '',
        'Module to generate html OpenSearch profile for short ticket search in the agent interface.' =>
            '',
        'Module to generate html OpenSearch profile for short ticket search in the customer interface.' =>
            '',
        'Module to generate ticket solution and response time statistics.' =>
            '',
        'Module to generate ticket statistics.' => '',
        'Module to grant access if the CustomerID of the ticket matches the CustomerID of the customer.' =>
            '',
        'Module to grant access if the CustomerUserID of the ticket matches the CustomerUserID of the customer.' =>
            '',
        'Module to grant access to any agent that has been involved in a ticket in the past (based on ticket history entries).' =>
            '',
        'Module to grant access to the agent responsible of a ticket.' =>
            '',
        'Module to grant access to the creator of a ticket.' => '',
        'Module to grant access to the owner of a ticket.' => '',
        'Module to grant access to the watcher agents of a ticket.' => '',
        'Module to show notifications and escalations (ShownMax: max. shown escalations, EscalationInMinutes: Show ticket which will escalation in, CacheTime: Cache of calculated escalations in seconds).' =>
            '',
        'Module to use database filter storage.' => '',
        'Multiselect' => '',
        'My Services' => 'Mine Services',
        'My Tickets.' => 'Mine Sager.',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'Name of custom service. The custom service is a service selection of your preferred services and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'Nederlands' => '',
        'New Ticket [%s] created (Q=%s;P=%s;S=%s).' => 'Ny sag [%s] oprettet (Kø=%s;P=%s;S=%s).',
        'New Window' => 'Nyt vindue',
        'New owner is "%s" (ID=%s).' => 'Ny ejer er "%s" (ID=%s)',
        'New process ticket' => '',
        'New responsible is "%s" (ID=%s).' => 'Ny ansvarlig er "%s" (ID=%s)',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'None' => 'Ingen',
        'Norwegian' => '',
        'Notification sent to "%s".' => 'Besked sendt til "%s".',
        'Number of displayed tickets' => 'Antal viste sager',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Antal linier (per sag), der vises af søgeprogrammet i agent-interfacet.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Antallet af sager i søgeresultatet, der vises på hver side i agent-interfacet.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Antallet af sager i søgeresultatet, der vises på hver side i kunde-interfacet.',
        'OTRS can use one or more readonly mirror databases for expensive operations like fulltext search or statistics generation. Here you can specify the DSN for the first mirror database.' =>
            '',
        'Old: "%s" New: "%s"' => 'Gammel status var "%s", ny status er "%s".',
        'Open tickets (customer user)' => 'Åbne sager (kundebruger)',
        'Open tickets (customer)' => 'Åbne sager (kunde)',
        'Option' => '',
        'Optional queue limitation for the CreatorCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the InvolvedCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the OwnerCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Optional queue limitation for the ResponsibleCheck permission module. If set, permission is only granted for tickets in the specified queues.' =>
            '',
        'Out Of Office' => 'Out Of Office',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets.' => '',
        'Overview Refresh Time' => 'Genopfrisk oversigt',
        'Overview of all escalated tickets.' => '',
        'Overview of all open Tickets.' => 'Oversigt over alle åbne sager.',
        'Overview of all open tickets.' => '',
        'Overview of customer tickets.' => '',
        'PGP Key Management' => '',
        'Package event module file a scheduler task for update registration.' =>
            '',
        'Parameters for the CreateNextMask object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomQueue object in the preference view of the agent interface.' =>
            '',
        'Parameters for the CustomService object in the preference view of the agent interface.' =>
            '',
        'Parameters for the RefreshTime object in the preference view of the agent interface.' =>
            '',
        'Parameters for the column filters of the small ticket overview.' =>
            '',
        'Parameters for the dashboard backend of the customer company information of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer id status widget of the agent interface . "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the customer user list overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the new tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the open tickets overview of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the queue overview widget of the agent interface. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "QueuePermissionGroup" is not mandatory, queues are only listed if they belong to this permission group if you enable it. "States" is a list of states, the key is the sort order of the state in the widget. "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the running process tickets overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket escalation overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket events calendar of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the ticket pending reminder overview of the agent interface . "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin. Note: Only Ticket attributes and Dynamic Fields (DynamicField_NameX) are allowed for DefaultColumns. Possible settings: 0 = Disabled, 1 = Available, 2 = Enabled by default.' =>
            '',
        'Parameters for the dashboard backend of the ticket stats of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
            '',
        'Parameters for the dashboard backend of the upcoming events widget of the agent interface. "Limit" is the number of entries shown by default. "Group" is used to restrict the access to the plugin (e. g. Group: admin;group1;group2;). "Default" determines if the plugin is enabled by default or if the user needs to enable it manually. "CacheTTLLocal" is the cache time in minutes for the plugin.' =>
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
        'ParentChild' => '',
        'Path for the log file (it only applies if "FS" was selected for LoopProtectionModule and it is mandatory).' =>
            '',
        'People' => 'Personer',
        'Performs the configured action for each event (as an Invoker) for each configured Webservice.' =>
            '',
        'Permitted width for compose email windows.' => '',
        'Permitted width for compose note windows.' => '',
        'Persian' => '',
        'Phone Call.' => '',
        'Picture Upload' => '',
        'Picture upload module.' => '',
        'Picture-Upload' => 'Billede Upload',
        'Polish' => '',
        'Portuguese' => '',
        'Portuguese (Brasil)' => '',
        'PostMaster Filters' => 'Postmaster-filtre',
        'PostMaster Mail Accounts' => 'Postmaster mail-konti',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Process Ticket.' => '',
        'Process pending tickets.' => '',
        'Process ticket' => '',
        'ProcessID' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Provides a matrix overview of the tickets per state per queue.' =>
            '',
        'Queue view' => 'Køer',
        'Rebuild the ticket index for AgentTicketQueue.' => '',
        'Recognize if a ticket is a follow-up to an existing ticket using an external ticket number.' =>
            '',
        'Refresh interval' => 'Opdateringsfrekvens',
        'Removed subscription for user "%s".' => 'Bruger "%s" følger ikke længere sagen.',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Renew existing SMIME certificates from customer backend. Note: SMIME and SMIME::FetchFromCustomer needs to be active in SysConfig and customer backend needs to be configured to fetch UserSMIMECertificate attribute.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Reports' => 'Rapporter',
        'Reports (OTRS Business Solution™)' => 'Rapporter (OTRS Business Solution™)',
        'Reprocess mails from spool directory that could not be imported in the first place.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            '',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            '',
        'Required permissions to use the email outbound screen in the agent interface.' =>
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
        'Responsible Tickets' => '',
        'Responsible Tickets.' => '',
        'Restores a ticket from the archive (only if the event is a state change to any open available state).' =>
            '',
        'Retains all services in listings even if they are children of invalid elements.' =>
            '',
        'Right' => 'Højre',
        'Roles <-> Groups' => 'Roller <-> Grupper',
        'Run file based generic agent jobs (Note: module name needs to be specified in -configuration-module param e.g. "Kernel::System::GenericAgent").' =>
            '',
        'Running Process Tickets' => '',
        'Runs an initial wildcard search of the existing customer company when accessing the AdminCustomerCompany module.' =>
            '',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'Russian' => '',
        'SMS' => 'SMS',
        'SMS (Short Message Service)' => 'SMS (Short Message Service)',
        'Sample command output' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data. Note: Searching for attachment names is not supported when "FS" is used.' =>
            '',
        'Schedule a maintenance period.' => 'Planlæg et vedligeholdelses tidspunkt.',
        'Screen' => '',
        'Search Customer' => 'Søg kunde',
        'Search Ticket.' => 'Søg sag.',
        'Search Tickets.' => 'Søg sager.',
        'Search User' => 'Søg Bruger',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Search.' => 'Søg.',
        'Second Queue' => '',
        'Select after which period ticket overviews should refresh automatically.' =>
            '',
        'Select how many tickets should be shown in overviews by default.' =>
            '',
        'Select the main interface language.' => '',
        'Select your default spelling dictionary.' => '',
        'Select your preferred layout for OTRS.' => '',
        'Select your preferred theme for OTRS.' => '',
        'Select your time zone.' => '',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send new outgoing mail from this ticket' => 'Send ny udgående mail fra denne sag',
        'Send notifications to users.' => 'Send beskeder til brugere.',
        'Sender type for new tickets from the customer inteface.' => '',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            '',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Sender kopi af alle udgående emails til denne adresse via bcc. Benyt kun funktionen til backup.',
        'Sends customer notifications just to the mapped customer.' => '',
        'Sends registration information to OTRS group.' => '',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            '',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            '',
        'Serbian Cyrillic' => '',
        'Serbian Latin' => '',
        'Service view' => '',
        'ServiceView' => '',
        'Set a new password by filling in your current password and a new one.' =>
            '',
        'Set sender email addresses for this system.' => 'Administrer afsenderadresser for dette system.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the limit of tickets that will be executed on a single genericagent job execution.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the minimum log level. If you select \'error\', just errors are logged. With \'debug\' you get all logging messages. The order of log levels is: \'debug\', \'info\', \'notice\' and \'error\'.' =>
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
        'Sets the inactivity time (in seconds) to pass before a session is killed and a user is logged out.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime before a prior warning will be visible for the logged in agents.' =>
            '',
        'Sets the maximum number of active agents within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per agent within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the maximum number of active sessions per customers within the timespan defined in SessionMaxIdleTime.' =>
            '',
        'Sets the minimal ticket counter size if "AutoIncrement" was selected as TicketNumberGenerator. Default is 5, this means the counter starts from 10000.' =>
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
        'Sets the state of a ticket in the close ticket screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket bulk screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket free text screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket note screen of the agent interface.' =>
            '',
        'Sets the state of a ticket in the ticket responsible screen of the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            '',
        'Sets the state of the ticket in the ticket priority screen of a zoomed ticket in the agent interface.' =>
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
        'Sets the timeout (in seconds) for http/ftp downloads.' => '',
        'Sets the timeout (in seconds) for package downloads. Overwrites "WebUserAgent::Timeout".' =>
            '',
        'Sets the user time zone per user (required a system with UTC as system time and UTC under TimeZone). Otherwise this is a diff time to the local time.' =>
            '',
        'Sets the user time zone per user based on java script / browser time zone offset feature at login time.' =>
            '',
        'Shared Secret' => '',
        'Should the cache data be held in memory?' => '',
        'Should the cache data be stored in the selected cache backend?' =>
            '',
        'Show a responsible selection in phone and email tickets in the agent interface.' =>
            '',
        'Show article as rich text even if rich text writing is disabled.' =>
            '',
        'Show queues even when only locked tickets are in.' => 'Skjul køer uden frie sager',
        'Show the current owner in the customer interface.' => '',
        'Show the current queue in the customer interface.' => '',
        'Show the history for this ticket' => 'Vis historik for sagen',
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
        'Shows a link in the menu to set a ticket as junk in every ticket overview of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Shows a link in the menu to set a ticket as pending in the ticket zoom view of the agent interface. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2". To cluster menu items use for Key "ClusterName" and for the Content any name you want to see in the UI. Use "ClusterPriority" to configure the order of a certain cluster within the toolbar.' =>
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
        'Shows all the customer user identifiers in a multi-select field (not useful if you have a lot of customer user identifiers).' =>
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
            'Viser Dagens Besked på login-skærmen i agent-interfacet.',
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
        'Shows the title field in the ticket free text screen of the agent interface.' =>
            '',
        'Shows the title fields in the close ticket screen of the agent interface.' =>
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
        'Simple' => '',
        'Skin' => '',
        'Slovak' => '',
        'Slovenian' => '',
        'Software Package Manager.' => '',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Some description!' => '',
        'Some picture description!' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            'Sorterer sagerne (stigende eller faldende) når en enkelt kø er valgt i kø oversigten og efter sagerne er sorteret efter prioritet. Værdier: 0 = stigende (ældste øverst, standard), 1 = faldende (nyeste øverst). Brug QueueID som nøgle og 0 eller 1 som værdi.',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the service view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the ServiceID for the key and 0 or 1 for value.' =>
            '',
        'Spam' => '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            '',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            '',
        'Spanish' => '',
        'Spanish (Colombia)' => '',
        'Spanish (Mexico)' => '',
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
            'Definerer hvilken rækkefølge agenters for og efternavn vises.',
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
        'Specifies whether all storage backends should be checked when looking for attachments. This is only required for installations where some attachments are in the file system, and others in the database.' =>
            '',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Specify the channel to be used to fetch OTRS Business Solution™ updates. Warning: Development releases might not be complete, your system might experience unrecoverable errors and on extreme cases could become unresponsive!' =>
            '',
        'Specify the password to authenticate for the first mirror database.' =>
            '',
        'Specify the username to authenticate for the first mirror database.' =>
            '',
        'Spell checker.' => '',
        'Stable' => '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            '',
        'Start number for statistics counting. Every new stat increments this number.' =>
            '',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Stat#' => 'Rapport',
        'Status view' => 'Statusoversigt',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
        'Strips empty lines on the ticket preview in the service view.' =>
            '',
        'Swahili' => '',
        'Swedish' => 'Svensk',
        'System Address Display Name' => '',
        'System Maintenance' => 'System vedligeholdelse',
        'System Request (%s).' => 'System Request (%s)',
        'Target' => '',
        'Templates <-> Queues' => 'Skabeloner <-> Køer',
        'Textarea' => '',
        'Thai' => '',
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
        'This is a description for TimeZone on Customer side.' => '',
        'This is the default orange - black skin for the customer interface.' =>
            '',
        'This is the default orange - black skin.' => '',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            '',
        'This module is part of the admin area of OTRS.' => '',
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
        'This will allow the system to send text messages via SMS.' => 'Dette tillader systemet at sende tekstbeskeder via SMS.',
        'Ticket Close.' => '',
        'Ticket Compose Bounce Email.' => '',
        'Ticket Compose email Answer.' => '',
        'Ticket Customer.' => '',
        'Ticket Forward Email.' => '',
        'Ticket FreeText.' => '',
        'Ticket History.' => '',
        'Ticket Lock.' => '',
        'Ticket Merge.' => '',
        'Ticket Move.' => '',
        'Ticket Note.' => '',
        'Ticket Notifications' => 'Sagsbeskeder',
        'Ticket Outbound Email.' => '',
        'Ticket Owner.' => '',
        'Ticket Pending.' => '',
        'Ticket Print.' => '',
        'Ticket Priority.' => '',
        'Ticket Queue Overview' => 'Sagskø oversigt',
        'Ticket Responsible.' => '',
        'Ticket Watcher' => '',
        'Ticket Zoom.' => '',
        'Ticket bulk module.' => '',
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).' => 'Sag flyttet til kø "%s" (%s) fra kø "%s".',
        'Ticket notifications' => 'Sagsbeskeder',
        'Ticket overview' => 'Sagsoversigt',
        'Ticket plain view of an email.' => '',
        'Ticket title' => '',
        'Ticket zoom view.' => '',
        'TicketNumber' => 'Sagsnummer',
        'Tickets.' => '',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Title updated: Old: "%s", New: "%s"' => 'Titel opdateret',
        'To accept login information, such as an EULA or license.' => '',
        'To download attachments.' => '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut. Additional access control to show or not show this link can be done by using Key "Group" and Content like "rw:group1;move_into:group2".' =>
            '',
        'Transport selection for ticket notifications.' => '',
        'Tree view' => '',
        'Triggers ticket escalation events and notification events for escalation.' =>
            '',
        'Turkish' => '',
        'Turns off SSL certificate validation, for example if you use a transparent HTTPS proxy. Use at your own risk!' =>
            '',
        'Turns on drag and drop for the main navigation.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Ukrainian' => 'Ukrainsk',
        'Unlock tickets that are past their unlock timeout.' => '',
        'Unlock tickets whenever a note is added and the owner is out of office.' =>
            '',
        'Unlocked ticket.' => 'Sag frigivet.',
        'Update Ticket "Seen" flag if every article got seen or a new Article got created.' =>
            '',
        'Updated SLA to %s (ID=%s).' => 'Opdateret SLA til %s (ID=%s).',
        'Updated Service to %s (ID=%s).' => 'Opdaterede Service til %s (ID=%s).',
        'Updated Type to %s (ID=%s).' => 'Opdaterede Type til %s (ID=%s).',
        'Updated: %s' => 'Opdateret: %s',
        'Updated: %s=%s;%s=%s;%s=%s;' => 'Opdateret: %s=%s;%s=%s;%s=%s;',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'Upload your PGP key.' => '',
        'Upload your S/MIME certificate.' => '',
        'Use new type of select and autocomplete fields in agent interface, where applicable (InputFields).' =>
            '',
        'Use new type of select and autocomplete fields in customer interface, where applicable (InputFields).' =>
            '',
        'UserFirstname' => 'BrugerFornavn',
        'UserLastname' => 'BrugerEfternavn',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing ticket notification.' => 'Bruger richtext til til visning og redigering af sagsbeskeder.',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard templates, auto responses and notifications.' =>
            '',
        'Vietnam' => 'Vietnam',
        'View performance benchmark results.' => 'Se resultat af performance test.',
        'Watch this ticket' => 'Følg denne sag',
        'Watched Tickets.' => '',
        'We are performing scheduled maintenance.' => 'Vi udfører planlagt vedligeholdelse.',
        'We are performing scheduled maintenance. Login is temporarily not available.' =>
            'Vi udfører planlagt vedligeholdelse. Det er ikke muligt at logge ind i øjeblikket.',
        'We are performing scheduled maintenance. We should be back online shortly.' =>
            'Vi udfører planlagt vedligeholdelse. Vi er snart tilbage.',
        'Web View' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the body of this note (this text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. Here you can define the subject of this note (this subject cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Whether or not to collect meta information from articles using filters configured in Ticket::Frontend::ZoomCollectMetaFilters.' =>
            '',
        'Yes, but hide archived tickets' => 'Ja, men skjul arkiverede sager',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' =>
            'Din e-mail med sagsnummer "<OTRS_TICKET>" er overgivet til "<OTRS_BOUNCE_TO>". Kontakt denne adresse for yderligere information.',
        'Your queue selection of your preferred queues. You also get notified about those queues via email if enabled.' =>
            '',
        'Your service selection of your preferred services. You also get notified about those services via email if enabled.' =>
            '',
        'attachment' => '',
        'bounce' => '',
        'compose' => '',
        'debug' => '',
        'error' => '',
        'forward' => '',
        'info' => '',
        'inline' => '',
        'notice' => '',
        'pending' => '',
        'responsible' => '',
        'stats' => '',

    };
    # $$STOP$$
    return;
}
1;
