# --
# Kernel/Language/da.pm - provides da (Danish) language translation
# Copyright (C) 2006 Thorsten Rossner <thorsten.rossner[at]stepstone.de>
# Copyright (C) 2007-2008 Mads N. Vestergaard <mnv[at]timmy.dk>
# Copyright (C) 2010 Lars Jørgensen <lajo[at]kb.dk>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::da;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-06-14 08:49:21

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

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
        'last' => 'sidste',
        'before' => 'før',
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
        'year' => 'år',
        'years' => 'år',
        'year(s)' => 'år',
        'second(s)' => 'sekund(er)',
        'seconds' => 'sekunder',
        'second' => 'sekund',
        's' => 's',
        'wrote' => 'skrev',
        'Message' => 'Meddelelse',
        'Error' => 'Fejl',
        'Bug Report' => 'Fejlrapport',
        'Attention' => 'OBS',
        'Warning' => 'Advarsel',
        'Module' => 'Modul',
        'Modulefile' => 'Modulfil',
        'Subfunction' => 'Underfunktion',
        'Line' => 'Linie',
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
        'none - answered' => 'ingen - svarede',
        'please do not edit!' => 'vær venlig ikke at redigere!',
        'Need Action' => 'Behøver handling',
        'AddLink' => 'TilføjLink',
        'Link' => 'Link',
        'Unlink' => 'Fjern link',
        'Linked' => 'Linket',
        'Link (Normal)' => 'Link (normal)',
        'Link (Parent)' => 'Link (forældre)',
        'Link (Child)' => 'Link (barn)',
        'Normal' => 'Normal',
        'Parent' => 'Forældre',
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
        'Customer Company' => 'Kunde/Firma',
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
        'New message' => 'Ny meddelelse',
        'New message!' => 'Ny meddelelse!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Vær venlig at besvare én eller flere sager for at komme tilbage til køens normale visning',
        'You have %s new message(s)!' => 'Du har %s ny(e) meddelelse(r)!',
        'You have %s reminder ticket(s)!' => 'Du har %s sag(er) med påmindelser!',
        'The recommended charset for your language is %s!' => 'Det anbefalede tegnsæt til dit sprog er %s!',
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
        'Logout' => 'Log ud',
        'Logout successful. Thank you for using %s!' => 'Du er nu logget ud. Tak fordi du bruger %s.',
        'Feature not active!' => 'Funktionen er ikke aktiv',
        'Agent updated!' => 'Agent opdateret',
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
        'Database setup successful!' => 'Database konfigureret!',
        'Generated password' => 'Genereret password',
        'Login is needed!' => 'Login er påkrævet',
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
        'Preview' => 'Vis udskrift',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakken er ikke installeret korrekt! Installer den igen.',
        '%s is not writable!' => 'Der kan ikke skrives til %s!',
        'Cannot create %s!' => 'Kan ikke oprette %s!',
        'Check to activate this date' => '',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Du har Out of Office aktiveret. Vil du deaktivere det?',
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
        'printed at' => 'udskrevet den',
        'Loading...' => 'Indlæser...',
        'Dear Mr. %s,' => 'Kære Hr. %s',
        'Dear Mrs. %s,' => 'Kære Fru. %s',
        'Dear %s,' => 'Kære %s',
        'Hello %s,' => 'Hej %s',
        'This email address already exists. Please log in or reset your password.' =>
            'Denne mail-adresse eksisterer allerede. Log venligst ind, eller nulstil dit password.',
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
        'Shown customer users' => 'Viste kunder',
        'News' => 'Nyheder',
        'Product News' => 'Produktnyheder',
        'OTRS News' => 'OTRS-nyheder',
        '7 Day Stats' => 'Sidste 7 dage',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            'Pakken er ikke godtkendt af OTRS-gruppen! Det anbefales ikke af bruge denne pakke.',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            'Hvis du fortsætter installationen af denne pakke, kan følgende opstå:<br><br>&nbsp;-Sikkerhedsproblemer<br>&nbsp;-Stabilitetsproblemer<br>&nbsp;-Performance-problemer<br><br>Vær opmærksom på at problemer opstået ved brug af denne pakke ikke af dækket af OTRS-servicekontrakter!<br>br>',
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
        'Scheduler process is registered but might not be running.' => 'Scheduler-processen er registreret, men kører måske ikke.',
        'Scheduler is not running.' => 'Scheduleren kører ikke.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Nytårsdag',
        'International Workers\' Day' => '',
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

        # Template: AAAStats
        'Stat' => 'Rapport',
        'Sum' => 'Sum',
        'Please fill out the required fields!' => 'Udfyld venligst de påkrævede felter.',
        'Please select a file!' => 'Vælg venligst en fil',
        'Please select an object!' => 'Vælg venligst et objekt',
        'Please select a graph size!' => 'Vælg venligst graf-størrelse',
        'Please select one element for the X-axis!' => 'Vælg venligst et element til X-aksen',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Vælg venligst kun et element, eller vend knappen \'Fixed\' hvor feltet er markeret',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'For at bruge en checkbox, skal du vælge nogle attributter fra feltet',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Indtast venligst en værdi, i det valghte input felt, eller fra vælg \'Fixed\' checkboxen.',
        'The selected end time is before the start time!' => 'Den valgte sluttid, er før starttiden.',
        'You have to select one or more attributes from the select field!' =>
            'Du skal vælge en eller flere attributter fra det valgte felt.',
        'The selected Date isn\'t valid!' => 'Den valgte dato er ugyldig.',
        'Please select only one or two elements via the checkbox!' => 'Vælg kun ene eller 2 elemeter fra checkboksene.',
        'If you use a time scale element you can only select one element!' =>
            'Hvis du bruger en tidsskale, kan du kun vælge et element!',
        'You have an error in your time selection!' => 'Der er fejl i den valgte tid',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Rapportens tidsinterval er for kort, vælg en større tidsskala.',
        'The selected start time is before the allowed start time!' => 'Den valgte starttid er før den tilladte starttid.',
        'The selected end time is after the allowed end time!' => 'Den valgte sluttid er senere end den tilladte sluttid.',
        'The selected time period is larger than the allowed time period!' =>
            'Den valgte tidsperiode er længere end den tilladte tidsperiode.',
        'Common Specification' => 'Generelle specifikationer',
        'X-axis' => 'X-akse',
        'Value Series' => 'Værdi-serier',
        'Restrictions' => 'Begrænsninger',
        'graph-lines' => 'graf-linjer',
        'graph-bars' => 'graf-søjler',
        'graph-hbars' => 'graf-hsøjler',
        'graph-points' => 'graf-punkter',
        'graph-lines-points' => 'graf-linje-punkter',
        'graph-area' => 'graf-område',
        'graph-pie' => 'graf-cirkel',
        'extended' => 'udvidet',
        'Agent/Owner' => 'Agent/Ejer',
        'Created by Agent/Owner' => 'Oprettet af Agent/Ejer',
        'Created Priority' => 'Oprettet med prioritet',
        'Created State' => 'Oprettet med status',
        'Create Time' => 'Oprettet tidspunkt',
        'CustomerUserLogin' => 'KundeBrugerLogin',
        'Close Time' => 'Lukket tidspunkt',
        'TicketAccumulation' => 'Sagsakkumulering',
        'Attributes to be printed' => 'Attributter til udskrift',
        'Sort sequence' => 'Sorteringsrækkefølge',
        'Order by' => 'Sorter efter',
        'Limit' => 'Grænse',
        'Ticketlist' => 'Sagsliste',
        'ascending' => 'stigende',
        'descending' => 'faldende',
        'First Lock' => 'Første Sagstrækning',
        'Evaluation by' => 'Evalueret af',
        'Total Time' => 'Total tid',
        'Ticket Average' => 'Sagsgennemsnit',
        'Ticket Min Time' => 'Sag min. tid',
        'Ticket Max Time' => 'Sag max. tid',
        'Number of Tickets' => 'Antal sager',
        'Article Average' => 'Indlæg-gennemsnit',
        'Article Min Time' => 'Indlæg min. tid',
        'Article Max Time' => 'Indlæg max. tid',
        'Number of Articles' => 'Antal indlæg',
        'Accounted time by Agent' => 'Bogført tid af agent',
        'Ticket/Article Accounted Time' => 'Registreret tid på sagen/indlægget',
        'TicketAccountedTime' => 'Registreret tid på sagen',
        'Ticket Create Time' => 'Sagens oprettelsestidspunkt',
        'Ticket Close Time' => 'Sagens lukningstidspunkt',

        # Template: AAATicket
        'Status View' => 'Statusoversigt',
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
        'auto remove' => '',
        'auto reply' => 'autosvar',
        'auto reply/new ticket' => 'autosvar/ny sag',
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
        'Edit Customer Users' => 'Rediger kundebrugere',
        'Edit Customer Company' => 'Rediger kunde-firma',
        'Bulk Action' => 'Massehandling',
        'Bulk Actions on Tickets' => 'Massehandlinger på sager',
        'Send Email and create a new Ticket' => 'Send mail og opret en ny sag',
        'Create new Email Ticket and send this out (Outbound)' => 'Opret ny mail-sag, og send den (Outbound)',
        'Create new Phone Ticket (Inbound)' => 'Opret ny telefon-sag (Inbound)',
        'Address %s replaced with registered customer address.' => 'Adresse %s erstattet med kundens registrerede adresse.',
        'Customer automatically added in Cc.' => 'Kunde automatisk tilføjet i Cc.',
        'Overview of all open Tickets' => 'Oversigt over alle åbne sager',
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
        'Agent (All with write permissions)' => 'Agent (Alle med skrivetilladelser)',
        'Agent (Owner)' => 'Agent (Ejer)',
        'Agent (Responsible)' => 'Agent (Ansvarlig)',
        'New ticket notification' => 'Besked om ny sag',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Send mig en besked, hvis der er en ny sag i "Mine køer".',
        'Send new ticket notifications' => 'Send besked om nye sager',
        'Ticket follow up notification' => 'Besked om opfølgning på sager',
        'Ticket lock timeout notification' => 'Besked om sagsfrigivelse efter tidsfristens udløb',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Send mig en besked, hvis systemet frigiver en sag.',
        'Send ticket lock timeout notifications' => 'Send besked om udløb af tidsfrister',
        'Ticket move notification' => 'Besked om flyttede sager',
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
            'For mine fulgte sager, send mig samme notifikationer som sagernes ejere får.',
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
        'History::Move' => 'Sag flyttet til kø "%s" (%s) fra kø "%s".',
        'History::TypeUpdate' => 'Opdaterede Type til %s (ID=%s).',
        'History::ServiceUpdate' => 'Opdaterede Service til %s (ID=%s).',
        'History::SLAUpdate' => 'Opdateret SLA til %s (ID=%s).',
        'History::NewTicket' => 'Ny sag [%s] oprettet (Kø=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Opfølgning til sag %s. %s',
        'History::SendAutoReject' => 'Automatisk afvisning sendt til "%s".',
        'History::SendAutoReply' => 'Automatisk svar sendt til "%s".',
        'History::SendAutoFollowUp' => 'Automatisk opfølgning send til "%s".',
        'History::Forward' => 'Videresendt til "%s".',
        'History::Bounce' => 'Overgivet til "%s".',
        'History::SendAnswer' => 'Email sendt til "%s".',
        'History::SendAgentNotification' => '"%s"-besked sendt til "%s".',
        'History::SendCustomerNotification' => 'Besked sendt til "%s".',
        'History::EmailAgent' => 'Email sendt til agent.',
        'History::EmailCustomer' => 'Email sendt til kunde.',
        'History::PhoneCallAgent' => 'Agent ringede kunden op.',
        'History::PhoneCallCustomer' => 'Kundende ringede os op.',
        'History::AddNote' => 'Tilføjede bemærkning (%s).',
        'History::Lock' => 'Sag trukket.',
        'History::Unlock' => 'Sag frigivet.',
        'History::TimeAccounting' => '%s tidsenheder registreret. Nu totalt %s tidsenheder brugt.',
        'History::Remove' => 'Fjern %s',
        'History::CustomerUpdate' => 'Opdateret: %s',
        'History::PriorityUpdate' => 'Ændrede prioritet fra "%s" (%s) til "%s" (%s)',
        'History::OwnerUpdate' => 'Ny ejer er "%s" (ID=%s)',
        'History::LoopProtection' => 'Loop-beskyttelse! Intet autosvar sendt til "%s".',
        'History::Misc' => 'Diverse %s',
        'History::SetPendingTime' => 'Sag afventer til %s',
        'History::StateUpdate' => 'Gammel status var "%s", ny status er "%s".',
        'History::TicketDynamicFieldUpdate' => 'Opdateret: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Kundeanmodning via web.',
        'History::TicketLinkAdd' => 'Tilføjet link til sag %s.',
        'History::TicketLinkDelete' => 'Slettet link til sag %s.',
        'History::Subscribe' => 'Bruger "%s" følger nu sagen.',
        'History::Unsubscribe' => 'Bruger "%s" følger ikke længere sagen.',
        'History::SystemRequest' => 'System Request (%s)',
        'History::ResponsibleUpdate' => 'Ny ansvarlig er "%s" (ID=%s)',
        'History::ArchiveFlagUpdate' => 'Arkivflag opdateret',

        # Template: AAAWeekDay
        'Sun' => 'Søn',
        'Mon' => 'Man',
        'Tue' => 'Tir',
        'Wed' => 'Ons',
        'Thu' => 'Tor',
        'Fri' => 'Fre',
        'Sat' => 'Lør',

        # Template: AdminAttachment
        'Attachment Management' => 'Styring af vedhæftede filer',
        'Actions' => 'Handlinger',
        'Go to overview' => 'Gå til oversigt',
        'Add attachment' => 'Vedhæft fil',
        'List' => 'Liste',
        'Validity' => 'Gyldighed',
        'No data found.' => 'Ingen data fundet.',
        'Download file' => 'Download fil',
        'Delete this attachment' => 'Slet denne vedhæftede fil',
        'Add Attachment' => 'Tilføj vedhæftet fil',
        'Edit Attachment' => 'Rediger vedhæftet fil',
        'This field is required.' => 'Dette felt skal udfyldes',
        'or' => 'eller',

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
        'To get the realname of the sender (if given).' => 'For at få afsenderes navn, hvis angivet.',
        'To get the article attribute' => 'For at få indlægges attributter',
        ' e. g.' => 'f.eks.',
        'Options of the current customer user data' => 'Valgmuligheder for den nuværende bruger',
        'Ticket owner options' => 'Valgmuligheder for sagens ejer',
        'Ticket responsible options' => 'Valgmuligheder for sagens ansvarlige',
        'Options of the current user who requested this action' => 'Valgmuligheder for den bruger, der udfører denne handling',
        'Options of the ticket data' => 'Valgmuligheder for sagens oplysninger',
        'Options of ticket dynamic fields internal key values' => 'Valgmuligheder for sagens dynamiske felters interne nøgleværdier',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            'Valgmuligheder for sagens dynamiske felters visningsværdier, brugbart for Dropdown- og Multiselect-felter',
        'Config options' => 'Konfigrationsvalgmuligheder',
        'Example response' => 'Eksempel på svar',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Administrer Kunde/Firma',
        'Wildcards like \'*\' are allowed.' => 'Jokertegn som \'*\' er tilladt.',
        'Add customer company' => 'Tilføj kunde/firma',
        'Please enter a search term to look for customer companies.' => 'Indtast en søgestreng for at lede efter Kunde/Firmaer',
        'Add Customer Company' => 'Tilføj kunde/firma',

        # Template: AdminCustomerUser
        'Customer Management' => 'Administrer Kunde',
        'Back to search results' => 'Tilbage til søgeresultater',
        'Add customer' => 'Tilføj kunde',
        'Select' => 'Vælg',
        'Hint' => 'Tip',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'Kunder skal oprettes for at man kan følge historik på deres sager og de kan logge ind i kunde-delen af OTRS.',
        'Please enter a search term to look for customers.' => 'Angiv søgeord for at lede efter kunder',
        'Last Login' => 'Sidste login',
        'Login as' => 'Login som',
        'Switch to customer' => 'Skift til kunde',
        'Add Customer' => 'Tilføj kunde',
        'Edit Customer' => 'Rediger kunde',
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
        'Search for customers.' => 'Søg efter kunder.',
        'Edit Customer Default Groups' => 'Rediger standardgrupper for kunder',
        'These groups are automatically assigned to all customers.' => 'Disse grupper tildeles automatisk til alle kunder.',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Du kan administrere disse grupper via konfigurationsindstillingen "CustomerGroupAlwaysGroups".',
        'Filter for Groups' => 'Filtrer grupper',
        'Select the customer:group permissions.' => 'Vælg kunde:gruppe-tilladelser.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Hvis intet er velgt, er der ingen tilladelser i denne gruppe (sager vil ikke være tilgængelige for kunden).',
        'Search Results' => 'Søgeresultat',
        'Customers' => 'Kunder',
        'Groups' => 'Grupper',
        'No matches found.' => 'Intet fundet',
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
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            'For at tilføje et nyt felt, vælg felttype fra objektets liste. Objektet definerer afgrænsningen af feltet og det kan ikke ændres efter feltet er oprettet.',
        'Dynamic Fields List' => 'Liste over Dynamiske Felter',
        'Dynamic fields per page' => 'Dynamiske felter pr. side',
        'Label' => 'Label',
        'Order' => 'Rækkefølge',
        'Object' => 'Objekt',
        'Delete this field' => 'Slet dette felt',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Vil du virkelig slette dette dynamiske felt? ALT tilhørende data vil GÅ TABT!',
        'Delete field' => 'Slet felt',

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
        'Save' => 'Gem',

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

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Mulige værdier',
        'Key' => 'Nøgle',
        'Value' => 'Værdi',
        'Remove value' => 'Fjern værdi',
        'Add value' => 'Tilføj værdi',
        'Add Value' => 'Tilføj Værdi',
        'Add empty value' => 'Tilføj tom værdi',
        'Activate this option to create an empty selectable value.' => 'Aktiver denne valgmulighed for at oprette en tom, valgbar værdi.',
        'Translatable values' => 'Oversættelige værdier',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Hvis du aktiverer denne valgmulighed, vil værdierne blive oversat til brugerens sprog.',
        'Note' => 'Note',
        'You need to add the translations manually into the language translation files.' =>
            'Du skal manuelt tilføje oversættelserne til oversættelses-filen.',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Antal rækker',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Angiv højden (i linier) for dette felt, når det redigeres.',
        'Number of cols' => 'Antal kolonner',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Angiv bredden (i tegn) for dette felt, når det redigeres.',

        # Template: AdminEmail
        'Admin Notification' => 'Besked til admin',
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
        'Job Settings' => 'Job-indstillinger',
        'Job name' => 'Job-navn',
        'Currently this generic agent job will not run automatically.' =>
            'Denne automatisk agent vil i øjeblikket ikke køre.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'For at aktivere automatisk kørsel, vælg mindst en værdi fra minutter, timer og dage.',
        'Schedule minutes' => 'Planlæg minutter',
        'Schedule hours' => 'Planlæg timer',
        'Schedule days' => 'Planlæg dage',
        'Toggle this widget' => 'Slå denne widget til eller fra',
        'Ticket Filter' => 'Sagsfilter',
        '(e. g. 10*5155 or 105658*)' => '(f.eks. 10*5155 eller 105658*)',
        '(e. g. 234321)' => '(f.eks. 234321)',
        'Customer login' => 'Kunde-login',
        '(e. g. U5150)' => '(f.eks. U5150)',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Fuldtekst-søgning i indlæg (f.eks. "Mar*in" eller "Niels*").',
        'Agent' => 'Agent',
        'Ticket lock' => 'Tildelt',
        'Create times' => 'Oprettelsestider',
        'No create time settings.' => 'Angiv ikke oprettelsestid.',
        'Ticket created' => 'Sag oprettet',
        'Ticket created between' => 'Sag oprettet mellem',
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
        'Archive search option' => 'Aktivt søgevalg',
        'Ticket Action' => 'Sags-handling',
        'Set new service' => 'Vælg ny service',
        'Set new Service Level Agreement' => 'Vælg ny Service Level Agreement',
        'Set new priority' => 'Vælg ny prioritet',
        'Set new queue' => 'Vælg ny kø',
        'Set new state' => 'Vælg ny tilstand',
        'Set new agent' => 'Vælg ny agent',
        'new owner' => 'Ny ejer',
        'new responsible' => 'Ny ansvarlig',
        'Set new ticket lock' => 'Tildel ny sagsejer',
        'New customer' => 'Ny kunde',
        'New customer ID' => 'Nyt kunde-ID',
        'New title' => 'Ny titel',
        'New type' => 'Ny type',
        'New Dynamic Field Values' => 'Ny Dynamisk Felt-værdi',
        'Archive selected tickets' => 'Arkiver valgte sager',
        'Add Note' => 'Tilføj Bemærkning',
        'Time units' => 'Tidsenheder',
        '(work units)' => '(arbejdsenheder)',
        'Ticket Commands' => 'Sagskommandoer',
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
        'Edit job' => 'Rediger job',
        'Run job' => 'Kør job',
        'Affected Tickets' => 'Berørte sager',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => '',
        'Debugger' => '',
        'Go back to web service' => 'Gå tilbage til web-service',
        'Clear' => 'Tøm',
        'Do you really want to clear the debug log of this web service?' =>
            'Vil du virkelig tømme debug-loggen for denne web-service?',
        'Request List' => '',
        'Time' => 'Tid',
        'Remote IP' => 'Fjern-IP',
        'Loading' => 'Indlæser',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Opfrisk',
        'Request Details' => '',
        'An error occurred during communication.' => 'En fejl skete under kommunikation.',
        'Show or hide the content' => 'Vis eller skjul indhold',
        'Clear debug log' => 'Tøm debug-log',

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
        'Configure' => 'Konfigurer',
        'The data from the invoker of OTRS will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Mapping for incoming response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the invoker of OTRS expects.' =>
            '',
        'Event Triggers' => '',
        'Asynchronous' => 'Asynkron',
        'Delete this event' => '',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => '',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => 'Gem og fortsæt',
        'Save and finish' => 'Gem og afslut',
        'Delete this Invoker' => '',
        'Delete this Event Trigger' => '',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => 'Gå tilbage til',
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
        'Properties' => 'Egenskaber',
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
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => '',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Details' => 'Detaljer',
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
        'Go back to Web Service' => 'Gå tilbage til web-service',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            '',
        'Configuration History List' => '',
        'Version' => 'Version',
        'Create time' => '',
        'Select a single configuration version to see its details.' => '',
        'Export web service configuration' => '',
        'Restore web service configuration' => '',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => '',
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
        'Host' => 'Vært',
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

        # Template: AdminNotification
        'Notification Management' => 'Beskedstyring',
        'Select a different language' => 'Vælg et andet sprog',
        'Filter for Notification' => 'Filter for beskeder',
        'Notifications are sent to an agent or a customer.' => 'Beskeder sendes til en agent eller kunde.',
        'Notification' => 'Besked',
        'Edit Notification' => 'Rediger besked',
        'e. g.' => 'f.eks.',
        'Options of the current customer data' => 'Valgmuligheder med den aktuelle kundes data',

        # Template: AdminNotificationEvent
        'Add notification' => 'Tilføj besked',
        'Delete this notification' => 'Slet denne besked',
        'Add Notification' => 'Tilføj besked',
        'Recipient groups' => 'Modtagergrupper',
        'Recipient agents' => 'Modtageragenter',
        'Recipient roles' => 'Modtagerroller',
        'Recipient email addresses' => 'Modtageres mail-adresser',
        'Article type' => 'Indlægstype',
        'Only for ArticleCreate event' => 'Kun ved ArticleCreate-hændelse (oprettelse af indlæg)',
        'Article sender type' => 'Indlægs-afsendertype',
        'Subject match' => 'Match emne',
        'Body match' => 'Match brødtekst',
        'Include attachments to notification' => 'Inkluder vedhæftninger til beskeden',
        'Notification article type' => 'Beskedens indlægstype',
        'Only for notifications to specified email addresses' => 'Kun for beskeder til de specificerede mail-adresser',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'For at få de første 20 tegn af emnet (af den seneste agent-indlæg).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'For at få de første 5 linier af beskeden (af den seneste agent-indlæg).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'For at få de første 20 tegn af emnet (af det seneste kunde-indlæg).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'For at få de første 5 linier af beskeden (af den seneste agent-indlæg).',

        # Template: AdminPGP
        'PGP Management' => 'PGP-styring',
        'Use this feature if you want to work with PGP keys.' => 'Brug denne funktion, hvis du vil arbejde med PGP-nøgler.',
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
        'Continue' => 'Fortsæt',
        'Install' => 'Installation',
        'Install Package' => 'Installer pakke',
        'Update repository information' => 'Opdater information i repositoriet',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            'Fandt du ikke den ønskede funktionalitet? OTRS Group tilbyder deres servicekontrakt-kunder eksklusive tilføjelser:',
        'Online Repository' => 'Online lagerdepot',
        'Vendor' => 'Leverandør',
        'Module documentation' => 'Modul-dokumentation',
        'Upgrade' => 'Opgrader',
        'Local Repository' => 'Lokalt lagerdepot',
        'Uninstall' => 'Afinstaller',
        'Reinstall' => 'Geninstaller',
        'Feature Add-Ons' => 'Funktionstilføjelser',
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
        'PrimaryKey' => 'PrimærNøgle',
        'AutoIncrement' => 'AutoForhøjelse',
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
        'Add PostMaster Filter' => 'Tilføj Postmaster-filter',
        'Edit PostMaster Filter' => 'Rediger Postmaster-filter',
        'Filter name' => 'Filternavn',
        'The name is required.' => 'Navnet er påkrævet.',
        'Stop after match' => 'Stop, hvis matcher',
        'Filter Condition' => 'Filter-betingelse',
        'The field needs to be a valid regular expression or a literal word.' =>
            'Feltet skal indeholde et gyldigt regulært udtryk eller et ord.',
        'Set Email Headers' => 'Sæt mail-headers',
        'The field needs to be a literal word.' => 'Feltet skal være et ord.',

        # Template: AdminPriority
        'Priority Management' => 'Administrer Prioriteter',
        'Add priority' => 'Tilføj prioritet',
        'Add Priority' => 'Tilføj prioritet',
        'Edit Priority' => 'Rediger prioritet',

        # Template: AdminProcessManagement
        'Process Management' => '',
        'Filter for Processes' => '',
        'Filter' => 'Filter',
        'Process Name' => '',
        'Create New Process' => '',
        'Synchronize All Processes' => '',
        'Configuration import' => '',
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
        'Copy' => 'Kopier',
        'Print' => 'Udskriv',
        'Export Process Configuration' => '',
        'Copy Process' => 'Kopier proces',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Afbryd og luk vindue',
        'Go Back' => 'Gå tilbage',
        'Please note, that changing this activity will affect the following processes' =>
            '',
        'Activity' => 'Aktivitet',
        'Activity Name' => 'Aktivitetsnavn',
        'Activity Dialogs' => 'Aktivitetsdialoger',
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
        'Path' => 'Sti',
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
        'Manage Queues' => 'Administrer Køer',
        'Add queue' => 'Tilføj kø',
        'Add Queue' => 'Tilføj kø',
        'Edit Queue' => 'Rediger kø',
        'Sub-queue of' => 'Underkø af',
        'Unlock timeout' => 'Tidsfrist for frigivelse',
        '0 = no unlock' => '0 = ingen frigivelse',
        'Only business hours are counted.' => 'Kun normal kontor tid er beregnet.',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Hvis en agent trækker sagen og ikke lukker den før frigivelses-timeout, vil sagen blive frigivet og gjort tilgængelig for andre agenter.',
        'Notify by' => 'Adviser via',
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
        'Filter for Queues' => 'Filtrer køer',
        'Filter for Auto Responses' => 'Filtrer autosvar',
        'Auto Responses' => 'Autosvar',
        'Change Auto Response Relations for Queue' => 'Administrer autosvar-relationer for kø',
        'settings' => 'indstillinger',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Administrer Svar/Kø-relationer',
        'Filter for Responses' => 'Filtrer svar',
        'Responses' => 'Svar',
        'Change Queue Relations for Response' => 'Administrer kø-relationer for svar',
        'Change Response Relations for Queue' => 'Administrer svar-relationer for kø',

        # Template: AdminResponse
        'Manage Responses' => 'Administrer svar',
        'Add response' => 'Tilføj svar',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            'Et svar er en skabelon, der hjælper dine agenter med at skrive hurtige og ensartede svar til kunderne.',
        'Don\'t forget to add new responses to queues.' => 'Glem ikke at føje svar til køer.',
        'Delete this entry' => 'Slet dette svar',
        'Add Response' => 'Tilføj svar',
        'Edit Response' => 'Rediger svar',
        'The current ticket state is' => 'Den aktuelle sags status er',
        'Your email address is' => 'Din mail-adresse er',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Administrer svar/vedhæftede filer',
        'Filter for Attachments' => 'Filter for vedhæftede filer',
        'Change Response Relations for Attachment' => 'Administrer svar-relationer for vedhæftet fil',
        'Change Attachment Relations for Response' => 'Administrer vedhæftet fil-relationer for svar',
        'Toggle active for all' => 'Skift aktiv for alle',
        'Link %s to selected %s' => 'Kæd %s til valgte %s',

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
        'priority' => 'prioritering',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Tilladelser til at ændre sagprioriteringen i denne gruppe/kø.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Administrer agent/rolle-relationer',
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
        'Add certificate' => 'Tilføj certifikat',
        'Add private key' => 'Tilføj private nøgle',
        'Filter for certificates' => 'Filter for certifikater',
        'Filter for SMIME certs' => 'Filter for SMIME-certifikater',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            'Her kan du tilføje relationer til dit private certifikat. Disse vil blive lagt ind i SMIME-signaturen hver gang du bruger dette certifikat til at signere en mail.',
        'See also' => 'Se også',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'Du kan på denne måde direkte redigere certificeringsnøgler og private nøgler i filsystemet.',
        'Hash' => 'Hash',
        'Create' => 'Opret',
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
        'SMIME Certificate' => 'SMIME-certifikat',
        'Close window' => 'Luk vindue',

        # Template: AdminSalutation
        'Salutation Management' => 'Administrer Indledninger',
        'Add salutation' => 'Tilføj indledning',
        'Add Salutation' => 'Tilføj Indledning',
        'Edit Salutation' => 'Rediger Indledning',
        'Example salutation' => 'Eksempel på indledning',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            '',
        'Start scheduler' => '',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            '',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Secure mode skal aktiveres!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Secure Mode vil (normalt) blive aktiveret efter den indledende installation er fuldført.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Hvis Secure Mode ikke er aktiveret, så aktiver det via SysConfig, da din applikation allerede kører.',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL Box',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Her kan du indtaste SQL og sende de direkte til applikations-databasen.',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'Din SQL-syntax indeholder fejl. Tjek den venligst.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Der mangler mindst et parameter for bindingen. Tjek det venligst.',
        'Result format' => 'Resultatformat',
        'Run Query' => 'Kør forespørgsel',

        # Template: AdminService
        'Service Management' => 'Administrer Services',
        'Add service' => 'Tilføj service',
        'Add Service' => 'Tilføj service',
        'Edit Service' => 'Rediger service',
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

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Navigate by searching in %s settings' => 'Naviger ved at søge i %s-konfguration',
        'Navigate by selecting config groups' => 'Naviger ved at vælge konfigurationsgrupper',
        'Download all system config changes' => 'Download alle ændringer i systemkonfigurationen',
        'Export settings' => 'Eksporter konfiguration',
        'Load SysConfig settings from file' => 'Indlæs SysConfig-konfiguration fra fil',
        'Import settings' => 'Importer konfiguration',
        'Import Settings' => 'Importer Konfiguration',
        'Please enter a search term to look for settings.' => 'Indtaste søgeord for at lede i konfigurationen.',
        'Subgroup' => 'Undergruppe',
        'Elements' => 'Elementer',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Rediger konfigurationsindstillinger',
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
        'Year' => 'År',
        'Month' => 'Måned',
        'Day' => 'Dag',
        'Invalid year' => 'Ugyldigt år',
        'Invalid month' => 'Ugyldig måned',
        'Invalid day' => 'Ugyldig dag',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Administrer systemets mail-adresser',
        'Add system address' => 'Tilføj systemadresse',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'Alt indgående mail med denne adresse i Til eller Cc, vil blive sendt til den valgte kø.',
        'Email address' => 'Mail-adresse',
        'Display name' => 'Vist navn',
        'Add System Email Address' => 'Tilføj system-mail-adresse',
        'Edit System Email Address' => 'Rediger system-mail-adresse',
        'The display name and email address will be shown on mail you send.' =>
            'Vist navn og mail-adresse vil blive vist på mail, du sender.',

        # Template: AdminType
        'Type Management' => 'Administrer Typer',
        'Add ticket type' => 'Tilføj sagstype',
        'Add Type' => 'Tilføj type',
        'Edit Type' => 'Rediger type',

        # Template: AdminUser
        'Add agent' => 'Tilføj agent',
        'Agents will be needed to handle tickets.' => 'Agenter skal oprettes for at kunne håndtere sager.',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Glem ikke at tilføje nye agenter til grupper og/eller roller!',
        'Please enter a search term to look for agents.' => 'Angiv en søgestreng for at lede efter agenter.',
        'Last login' => 'Sidste Login',
        'Switch to agent' => 'Skift til agent',
        'Add Agent' => 'Tilføj agent',
        'Edit Agent' => 'Rediger agent',
        'Firstname' => 'Fornavn',
        'Lastname' => 'Efternavn',
        'Password is required.' => 'Password er krævet.',
        'Start' => 'Start',
        'End' => 'Slut',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Administrer Agent/Gruppe-relationer',
        'Change Group Relations for Agent' => 'Skift gruppe-relationer for agent',
        'Change Agent Relations for Group' => 'Skift agent-relationer for gruppe',
        'note' => 'note',
        'Permissions to add notes to tickets in this group/queue.' => 'Rettigheder til at tilføje noter til sager i denne gruppe/kø.',
        'owner' => 'ejer',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Rettigheder til at ændre ejer på sager i denne gruppe/kø',

        # Template: AgentBook
        'Address Book' => 'Adressebog',
        'Search for a customer' => 'Søg efter en kunde',
        'Add email address %s to the To field' => 'Tilføj mail-adresse %s til Til-feltet',
        'Add email address %s to the Cc field' => 'Tilføj mail-adresse %s til Cc-feltet',
        'Add email address %s to the Bcc field' => 'Tilføj mail-adresse %s til Bcc-feltet',
        'Apply' => 'Opdater',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => 'Kundeinformations-center',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'Kunde-ID',
        'Customer User' => 'Kunde',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Søg kunde',
        'Duplicated entry' => 'Dublet',
        'This address already exists on the address list.' => 'Denne adresse eksisterer allerede i adresselisten.',
        'It is going to be deleted from the field, please try again.' => 'Det vil blive slettet fra feltet. Prøv venligst igen.',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Oversigt',

        # Template: AgentDashboardCalendarOverview
        'in' => 'om',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eskalerede sager',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Kundeinformation',
        'Phone ticket' => 'Sager',
        'Email ticket' => 'Mail-sager',
        '%s open ticket(s) of %s' => '%s åbne sager af %s',
        '%s closed ticket(s) of %s' => '%s lukkede sager af %s',
        'New phone ticket from %s' => 'Nye sager fra %s',
        'New email ticket to %s' => 'Nye mail-sager til %s',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s er tilgængelig',
        'Please update now.' => 'Opdater venligst.',
        'Release Note' => 'Udgivelsesnote',
        'Level' => 'Niveau',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Offentliggjort %s siden.',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mine sager',
        'My watched tickets' => 'Sager, jeg følger',
        'My responsibilities' => 'Sager, jeg er ansvarlig for',
        'Tickets in My Queues' => 'Sager i Mine Køer',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => 'ude af kontoret',

        # Template: AgentDashboardUserOutOfOffice
        'until' => 'til',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Sagen er blevet trukket',
        'Undo & close window' => 'Afbryd og luk vindue',

        # Template: AgentInfo
        'Info' => 'Info',
        'To accept some news, a license or some changes.' => 'For at acceptere nogle nyheder, en lices eller nogle ændringer.',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Kæd objekt: %s',
        'go to link delete screen' => 'gå til skærmen, hvor links kan slettes',
        'Select Target Object' => 'Vælg destinations-objekt',
        'Link Object' => 'Kæd',
        'with' => 'med',
        'Unlink Object: %s' => 'Fjern k?dning af objekt: %s',
        'go to link add screen' => 'gå til skærmen, hvor links kan tilføjes',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Opdater dine indstillinger',

        # Template: AgentSpelling
        'Spell Checker' => 'Stavekontrol',
        'spelling error(s)' => 'stavefejl',
        'Apply these changes' => 'Anvend disse ændringer',

        # Template: AgentStatsDelete
        'Delete stat' => 'Slet rapport',
        'Stat#' => 'Rapport',
        'Do you really want to delete this stat?' => 'Vil du virkelig slette denne rapport?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Skridt %s',
        'General Specifications' => 'Generelle specifikationer',
        'Select the element that will be used at the X-axis' => 'Vælg det element, der skal bruges på X-aksen',
        'Select the elements for the value series' => 'Vælg elementerne for værdiserien',
        'Select the restrictions to characterize the stat' => 'Vælg de restriktioner, der karakteriserer rapporten',
        'Here you can make restrictions to your stat.' => 'Her kan du begrænse din rapport',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Vis du fjerner markeringen i boksen "Fast", kan agenten ændrer attributterne ved det valgte element.',
        'Fixed' => 'Fast',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Vælg venligst kun et Element, eller fravælg knappen \'Fast\'',
        'Absolute Period' => 'Absolut Periode',
        'Between' => 'Mellem',
        'Relative Period' => 'Relativ periode',
        'The last' => 'Den sidste',
        'Finish' => 'Færdig',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Rettigheder',
        'You can select one or more groups to define access for different agents.' =>
            'Du kan vælge en eller flere grupper for at give adgang for forskellige agenter.',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Nogle resultatformater er deaktiverede, fordi mindst en påkrævet pakke ikke er installeret.',
        'Please contact your administrator.' => 'Kontakt din administrator.',
        'Graph size' => 'Grafstørrelse',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Hvis du bruger en graf som output format skal du vælge mindst en graf størrelse',
        'Sum rows' => 'Summér rækker',
        'Sum columns' => 'Summér Kolonner',
        'Use cache' => 'Brug cache',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'De fleste statistikker kan blive cachet, det vil gøre præsentationen hurtigere',
        'If set to invalid end users can not generate the stat.' => 'Hvis sat til ugyldig, kan brugere ikke køre rapporten.',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Her kan du definere værdiserien',
        'You have the possibility to select one or two elements.' => 'Du har mulighed for at vælge et eller to elementer.',
        'Then you can select the attributes of elements.' => 'Så vælger du elementernes attributter.',
        'Each attribute will be shown as single value series.' => 'Hver attribut vil blive vist som en enkelt værdieserie.',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Hvis du ikke vælger nogen attributter, vil alle elementets attributter blive brug, når du genererer rapporten, så vel som attributter, der er tilføjet siden sidste konfiguration.',
        'Scale' => 'Skala',
        'minimal' => 'minimum',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Husk venligst at skalen for værdiserien, skal være større end den skala for X-Aksen (f.eks. X-Akse => Måned, VærdiSerie => år).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Her kan du definere x-aksen. Du kan vælge ét element.',
        'maximal period' => 'maksimal periode',
        'minimal scale' => 'minimal skala',

        # Template: AgentStatsImport
        'Import Stat' => 'Importer Rapport',
        'File is not a Stats config' => 'Filen er ikke en rapport-konfiguration',
        'No File selected' => 'Ingen fil valgt',

        # Template: AgentStatsOverview
        'Stats' => 'Rapporter',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Intet element er valgt.',

        # Template: AgentStatsView
        'Export config' => 'Eksporter konfiguration',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Ved at udfylde felterne, kan du styre format og indhold i rapporten. Hvilke felter og formater, du kan arbejde med, er defineret af rapportadministratoren.',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Præcis hvilke felter og formater, du kan arbejde med, er defineret af rapportadministratoren.',
        'Stat Details' => 'Rapportdetaljer',
        'Format' => 'Format',
        'Graphsize' => 'Graf-størrelse',
        'Cache' => 'Cache',
        'Exchange Axis' => 'Ombyt akser',
        'Configurable params of static stat' => 'Konfigurerbare parametre af en statisk rapport',
        'No element selected.' => 'Intet element er valgt',
        'maximal period from' => 'maksimal periode fra',
        'to' => 'til',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Rediger sagens fritekst',
        'Change Owner of Ticket' => 'Skift sagens ejer',
        'Close Ticket' => 'Luk sag',
        'Add Note to Ticket' => 'Tilføj bemærkning til sag',
        'Set Pending' => 'Indstil afventningsfrist',
        'Change Priority of Ticket' => 'Skift sagens prioritet',
        'Change Responsible of Ticket' => 'Skift sagens ansvarlige',
        'Service invalid.' => 'Ugyldig service.',
        'New Owner' => 'Ny Ejer',
        'Please set a new owner!' => 'Vælg venligst en ny ejer!',
        'Previous Owner' => 'Tidligere ejer',
        'Inform Agent' => 'Informer Agent',
        'Optional' => 'Valgfri',
        'Inform involved Agents' => 'Informer involverede Agenter',
        'Spell check' => 'Stavekontrol',
        'Note type' => 'Bemærkningstype',
        'Next state' => 'Næste status',
        'Pending date' => 'Afventer dato',
        'Date invalid!' => 'Ugyldig dato',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Overgiv sag',
        'Bounce to' => 'Overgiv til',
        'You need a email address.' => 'Du mangler en mail-adresse',
        'Need a valid email address or don\'t use a local email address.' =>
            'Der mangler en gyldig mail-adresse. Brug ikke en lokal mail-adresse.',
        'Next ticket state' => 'Sagens næste status',
        'Inform sender' => 'Informer afsender',
        'Send mail!' => 'Send mail',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Massehandling',
        'Send Email' => 'Send mail',
        'Merge to' => 'Saml til',
        'Invalid ticket identifier!' => 'Ugyldig sagsidentifikation!',
        'Merge to oldest' => 'Saml til ældste',
        'Link together' => 'Kæd sammen',
        'Link to parent' => 'Kæd til forælder',
        'Unlock tickets' => 'Frigiv sager',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Skriv svar til sag',
        'Remove Ticket Customer' => 'Fjern Sagens Kunde',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Fjern venligst denne indtastning og skriv en ny med den korrekte værdi.',
        'Please include at least one recipient' => 'Der skal være mindst én modtager.',
        'Remove Cc' => 'Fjern Cc',
        'Remove Bcc' => 'Fjern Bcc',
        'Address book' => 'Adressebog',
        'Pending Date' => 'Afventer til dato',
        'for pending* states' => 'for afventende tilstande',
        'Date Invalid!' => 'Ugyldig dato!',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Skift sagens kunde',
        'Customer user' => 'Kundebruger',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Opret ny mail-sag',
        'From queue' => 'Fra kø',
        'To customer' => 'Til kunde',
        'Please include at least one customer for the ticket.' => 'Der skal være mindst én kunde til sagen.',
        'Get all' => 'Hent alle',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Videresend sag: %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Historik af',
        'History Content' => 'Historikindhold',
        'Zoom view' => 'Zoom-visning',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Sagssamling',
        'You need to use a ticket number!' => 'Du skal bruge et sagsnummer.',
        'A valid ticket number is required.' => 'Angiv et gyldigt sagsnummer',
        'Need a valid email address.' => 'Angiv en gyldig mail-adresse',

        # Template: AgentTicketMove
        'Move Ticket' => 'Flyt Sag',
        'New Queue' => 'Ny Kø',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Vælg alle',
        'No ticket data found.' => 'Ingen sager fundet.',
        'First Response Time' => 'Frist til første svar',
        'Service Time' => 'Servicetid',
        'Update Time' => 'Opdateringstid',
        'Solution Time' => 'Løsningstid',
        'Move ticket to a different queue' => 'Flyt sag til anden kø',
        'Change queue' => 'Skift kø',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Skift søgemuligheder',
        'Tickets per page' => 'Sager pr. side',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Eskalerer om',
        'Locked' => 'Tildelt',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Opret ny sag',
        'From customer' => 'Fra kunde',
        'To queue' => 'Til kø',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Telefonopkald',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'Vis mailens kildetekst',
        'Plain' => 'Kildetekst',
        'Download this email' => 'Download denne mail',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Sag-Info',
        'Accounted time' => 'Benyttet tid',
        'Linked-Object' => 'Linket-Objekt',
        'by' => 'af',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Søgeskabelon',
        'Create Template' => 'Opret skabelon',
        'Create New' => 'Opret ny',
        'Profile link' => 'Link til profil',
        'Save changes in template' => 'Gem ændringer i skabelon',
        'Add another attribute' => 'Tilføj endnu en attribut',
        'Output' => 'Output',
        'Fulltext' => 'Fritekst',
        'Remove' => 'Fjern',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Kundebrugers login',
        'Created in Queue' => 'Oprettet i kø',
        'Lock state' => 'Tildelt/fri',
        'Watcher' => 'Fulgte af',
        'Article Create Time (before/after)' => 'Indlæg skrevet (før/efter)',
        'Article Create Time (between)' => 'Indlæg skrevet (mellem)',
        'Ticket Create Time (before/after)' => 'Sag oprettet (før/efter)',
        'Ticket Create Time (between)' => 'Sag oprettet (mellem)',
        'Ticket Change Time (before/after)' => 'Sag ændret (før/efter)',
        'Ticket Change Time (between)' => 'Sag ændret (mellem)',
        'Ticket Close Time (before/after)' => 'Sag lukket (før/efter)',
        'Ticket Close Time (between)' => 'Sag lukket (mellem)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Arkiver søgning',
        'Run search' => 'Søg',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Filtrer indlæg',
        'Article Type' => 'Indlægstype',
        'Sender Type' => 'Afsendertype',
        'Save filter settings as default' => 'Gem disse filterinstillinger som standard',
        'Archive' => 'Arkiver',
        'This ticket is archived.' => 'Denne sag er arkiveret',
        'Linked Objects' => 'Sammenkædede objekter',
        'Article(s)' => 'Indlæg',
        'Change Queue' => 'Skift kø',
        'There are no dialogs available at this point in the process.' =>
            'Der er ingen dialoger tilgængelige på dette sted i processen.',
        'This item has no articles yet.' => '',
        'Article Filter' => 'Filtrer indlæg',
        'Add Filter' => 'Tilføj filter',
        'Set' => 'Indstil',
        'Reset Filter' => 'Nulstil filter',
        'Show one article' => 'Vis indlæg enkeltvis',
        'Show all articles' => 'Vis alle indlæg',
        'Unread articles' => 'Ulæste indlæg',
        'No.' => 'Nr.',
        'Unread Article!' => 'Ulæst indlæg',
        'Incoming message' => 'Indgående besked',
        'Outgoing message' => 'Udgående besked',
        'Internal message' => 'Intern besked',
        'Resize' => 'Ændr størrelse',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => 'For at beskytte dit privatliv blev fjernindhold blokeret.',
        'Load blocked content.' => 'Vis blokeret indhold',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Tilbagesporing',

        # Template: CustomerFooter
        'Powered by' => ' ',
        'One or more errors occurred!' => 'En eller flere fejl opstod!',
        'Close this dialog' => 'Luk dette vindue',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Kan ikke åbne nyt vindue. Deaktiver din browsers popup-blokering for denne applikation.',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript ikke tilgængeligt',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'For at opleve OTRS, skal du aktivere JavaScript i din browser.',
        'Browser Warning' => 'Browser-advarsel',
        'The browser you are using is too old.' => 'Din browser er for gammel.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS virker med en masse browsere, opgrader venligst til en af disse.',
        'Please see the documentation or ask your admin for further information.' =>
            'Se venligst dokumentationen eller kontakt din administrator for yderligere information.',
        'Login' => 'Login',
        'User name' => 'Brugernavn',
        'Your user name' => 'Dit brugernavn',
        'Your password' => 'Dit password',
        'Forgot password?' => 'Glemt dit password?',
        'Log In' => 'Login',
        'Not yet registered?' => 'Endnu ikke registreret?',
        'Sign up now' => 'Registrer dig nu',
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
        'Edit personal preferences' => 'Rediger dine personlige indstillinger',
        'Logout %s' => 'Log %s ud',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Service level agreement',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Velkommen!',
        'Please click the button below to create your first ticket.' => 'Klik på knappen herunder for at oprette din første sag.',
        'Create your first ticket' => 'Opret din første sag',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Udskriv sag',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'f.eks. 10*55 eller 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Fritekstsøgning i sager (f.eks. "Ni*olai eller Hans*")',
        'Recipient' => 'Modtager',
        'Carbon Copy' => 'Cc',
        'Time restrictions' => 'Tidsbegrænsninger',
        'No time settings' => 'Ingen tidsindstillinger',
        'Only tickets created' => 'Kun sager oprettet',
        'Only tickets created between' => 'Kun sager oprettet mellem',
        'Ticket archive system' => 'Sagsarkivet',
        'Save search as template?' => 'Gem søgning som skabelon?',
        'Save as Template?' => 'Gem som skabelon?',
        'Save as Template' => 'Gem som skabelon',
        'Template Name' => 'Navn på skabelon',
        'Pick a profile name' => 'Vælg et profilnavn',
        'Output to' => 'Output til',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'af',
        'Page' => 'Side',
        'Search Results for' => 'Søgeresultater for',

        # Template: CustomerTicketZoom
        'Show article' => 'Vis indlæg',
        'Expand article' => 'Fold indlæg ud',
        'Information' => 'Information',
        'Next Steps' => 'Næste skridt',
        'Reply' => 'Svar',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Ugyldig dato (angiv dato i fremtiden)',
        'Previous' => 'Forrige',
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
        'Open date selection' => 'Åbn datovælger',

        # Template: Error
        'Oops! An Error occurred.' => 'Ups! Der skete en fejl.',
        'Error Message' => 'Fejlbesked',
        'You can' => 'Du kan',
        'Send a bugreport' => 'Sende en fejlrapport',
        'go back to the previous page' => 'gå tilbage til den forrige side',
        'Error Details' => 'Fejldetaljer',

        # Template: Footer
        'Top of page' => 'Til toppen af siden',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Hvis du forlader denne side, vil alle pop-up vinduer også blive lukket!',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'Et pop-up vindue med dette billede er allerede åbent. Vil du lukke det og åbne denne i stedet?',
        'Please enter at least one search value or * to find anything.' =>
            'Angiv venligst mindst ét søgeord eller * for at finde alt.',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => 'Fuldtekst-søgning',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Du er logget ind som',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript ikke tilgængeligt',
        'Database Settings' => 'Database-indstillinger',
        'General Specifications and Mail Settings' => 'Generelle specifikationer og mail-indstillinger',
        'Registration' => 'Registrering',
        'Welcome to %s' => 'Velkommen til %s',
        'Web site' => 'Webside',
        'Database check successful.' => 'Databasen er tjekket ok.',
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
        'SMTP authentication' => 'SMTP-autentifikation',
        'Does your SMTP host need authentication?' => 'Har din SMTP-server brug for autentifikation?',
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
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            'Hvis du springer dette trin over, bliver OTRS ikke registreret. Er du sikker på, du vil fortsætte?',

        # Template: InstallerDBResult
        'False' => 'Falsk',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Hvis du har sat et root kodeord til din database skal du taste det her. Hvis ikke, lad feltet være tomt. Af sikkerhedsmæssige årsager anbefaler vi at sætte et root kodeord. For mere information henviser vi til documentationen for din database.',
        'Currently only MySQL is supported in the web installer.' => 'Pt. understøttes kun MySQL af web-installeren.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Hvis du vil installere OTRS på en anden database-type, tjek venligst filen README.database.',
        'Database-User' => 'Database-bruger',
        'New' => 'Ny',
        'A new database user with limited permissions will be created for this OTRS system.' =>
            'En ny database-bruger med begrænsede rettigheder vil blive oprettet til dette OTRS-system.',
        'default \'hot\'' => 'standard \'hot\'',
        'DB host' => 'DB--- server',
        'Check database settings' => 'Tjek database-konfiguration',
        'Result of database check' => 'Resultat af database-konfigurationstjek',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'For at kunne anvende OTRS, er du nødt til at indtaste følgende linje i din kommandolinje (Terminal/Shell) som root.',
        'Restart your webserver' => 'Genstart webserveren',
        'After doing so your OTRS is up and running.' => 'Når det er gjort, er din OTRS sat i gang og fungerer.',
        'Start page' => 'Startside',
        'Your OTRS Team' => 'Dit OTRS Team',

        # Template: InstallerLicense
        'Accept license' => 'Accepter licens',
        'Don\'t accept license' => 'Accepter ikke icensen',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organisation',
        'Position' => '',
        'Complete registration and continue' => 'Gennemfør registrering og fortsæt',
        'Please fill in all fields marked as mandatory.' => 'Udfyld venligst de obligatoriske felter.',

        # Template: InstallerSystem
        'SystemID' => 'System-ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Systemets ID. Hver sagsnummer og hver HTTP-session-id indeholder dette nummer.',
        'System FQDN' => 'Systemets FQDN',
        'Fully qualified domain name of your system.' => 'Dit systems Fully Qualified Domain Name',
        'AdminEmail' => 'Admin-Email',
        'Email address of the system administrator.' => 'System-administrators mail-adresse.',
        'Log' => 'Log',
        'LogModule' => 'LogModul',
        'Log backend to use.' => 'Brug denne log-backend.',
        'LogFile' => 'Logfil',
        'Log file location is only needed for File-LogModule!' => 'Logfilens lokation skal kun bruges i forbindelse med File-LogModule!',
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

        # Template: Motd
        'Message of the Day' => 'Dagens Besked',

        # Template: NoPermission
        'Insufficient Rights' => 'Utilstrækkelige rettigheder',
        'Back to the previous page' => 'Tilbage til forrige side',

        # Template: Notify

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

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'udskrevet af',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS prøveside',
        'Welcome %s' => 'Velkommen %s',
        'Counter' => 'Tæller',

        # Template: Warning
        'Go back to the previous page' => 'Gå tilbage til forrige side',

        # SysConfig
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL-modul, der kun tillader lukning af hovedsager, hvis alle undersager allerede er lukkede ("Tilstand" viser hvilke tilstande, der ikke kan vælges for hovedsagen indtal alle undersager er lukkede).',
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
        'Agent Notifications' => 'Beskeder til Agenter',
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
        'Agents <-> Groups' => 'Agenter <-> Grupper',
        'Agents <-> Roles' => 'Agenter <-> Roller',
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
        'Attachments <-> Responses' => 'Vedhæftede filer <-> Svar',
        'Auto Responses <-> Queues' => '',
        'Automated line break in text messages after x number of chars.' =>
            '',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            '',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            '',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            '',
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
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'Skift password',
        'Change queue!' => 'Skift kø',
        'Change the customer for this ticket' => 'Ændr denne sags kunde',
        'Change the free fields for this ticket' => 'Ændr denne sags frie felter',
        'Change the priority for this ticket' => 'Ændr denne sags prioritet',
        'Change the responsible person for this ticket' => '',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            '',
        'Checkbox' => '',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            '',
        'Closed tickets of customer' => '',
        'Comment for new history entries in the customer interface.' => '',
        'Company Status' => '',
        'Company Tickets' => '',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            '',
        'Configure Processes.' => '',
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
        'Create and manage Service Level Agreements (SLAs).' => 'Administrer Service Level Agreements (SLA\'er).',
        'Create and manage agents.' => 'Administrer agenter.',
        'Create and manage attachments.' => 'Administrer vedhæftede filer.',
        'Create and manage companies.' => 'Administrer firmaer.',
        'Create and manage customers.' => 'Administrer kunder.',
        'Create and manage dynamic fields.' => '',
        'Create and manage event based notifications.' => 'Administrer hændelsesbaserede beskeder.',
        'Create and manage groups.' => 'Administrer grupper.',
        'Create and manage queues.' => 'Administrer køer.',
        'Create and manage response templates.' => 'Administrer svar-skabeloner.',
        'Create and manage responses that are automatically sent.' => 'Administrer svar, der sendes automatisk.',
        'Create and manage roles.' => 'Administrer roller',
        'Create and manage salutations.' => 'Administrer tituleringer.',
        'Create and manage services.' => 'Administrer services.',
        'Create and manage signatures.' => 'Administrer signaturer.',
        'Create and manage ticket priorities.' => 'Administrer sagsprioriteter.',
        'Create and manage ticket states.' => 'Administrer sagstilstande.',
        'Create and manage ticket types.' => 'Administrer sagstyper.',
        'Create and manage web services.' => '',
        'Create new email ticket and send this out (outbound)' => 'Opret ny mail-sag og send den ud (udgående)',
        'Create new phone ticket (inbound)' => 'Opret ny sag',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            'Tekst til den side, der vises til kunder, der endnu ikke har nogen sager.',
        'Customer Company Administration' => 'Kunde-Firma-administration',
        'Customer Company Information' => 'Kunde-Firma-information',
        'Customer User Administration' => 'Kunde-administration',
        'Customer Users' => 'Kunder',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Kunder <-> Grupper',
        'Customers <-> Services' => 'Kunder <-> Services',
        'Data used to export the search result in CSV format.' => 'Data brugt til at eksportere søgeresultatet i CSV-format.',
        'Date / Time' => 'Dato / Tid',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            'Debugger oversættelsen. Er denne sat til "Ja", vil alle strenge (tekst) uden oversættelser blive skrevet til STDERR. Det kan hjælpe, hvis du er ved at lave en oversættelse af OTRS. Ellers bør denne valgmulighed sættes til "Nej".',
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
        'Default skin for interface.' => '',
        'Default ticket ID used by the system in the agent interface.' =>
            '',
        'Default ticket ID used by the system in the customer interface.' =>
            '',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            '',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => 'Definer ugens første dag for datovælgeren.',
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
        'Defines if time accounting is mandatory in the agent interface.' =>
            '',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
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
        'Defines the colors for the graphs.' => '',
        'Defines the column to store the keys for the preferences table.' =>
            '',
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
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
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
        'Defines the location to get online repository list for additional packages. The first available result will be used.' =>
            '',
        'Defines the log module for the system. "File" writes all messages in a given logfile, "SysLog" uses the syslog daemon of the system, e.g. syslogd.' =>
            '',
        'Defines the maximal size (in bytes) for file uploads via the browser.' =>
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
        'Defines the module to display a notification in the agent interface, (only for agents on the admin group) if the scheduler is not running.' =>
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
        'Defines which states should be set automatically (Content), after the pending time of state (Key) has been reached.' =>
            '',
        'Defines wich article type should be expanded when entering the overview. If nothing defined, latest article will be expanded.' =>
            '',
        'Delay time between autocomplete queries in milliseconds.' => '',
        'Deletes a session if the session id is used with an invalid remote IP address.' =>
            '',
        'Deletes requested sessions if they have timed out.' => '',
        'Determines if the list of possible queues to move to ticket into should be displayed in a dropdown list or in a new window in the agent interface. If "New Window" is set you can add a move note to the ticket.' =>
            '',
        'Determines if the search results container for the autocomplete feature should adjust its width dynamically.' =>
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
        'Determines the next screen after the ticket is moved. LastScreenOverview will return to search results, queueview, dashboard or the like, LastScreenView will return to TicketZoom.' =>
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
        'Email Addresses' => 'Email-adresser',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            '',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Aktiverer S/MIME-understøttelse',
        'Enables customers to create their own accounts.' => 'Lader kunder oprette deres egne konti.',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Aktiverer understøttelse for stavekontrol.',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Eskalerede sager',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => 'Udfør SQL-kommandoer.',
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
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            '',
        'Frontend language' => 'Sprog til frontend',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => '',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Tema til frontend',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => 'Automatisk Agent',
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
            '',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
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
        'Interface language' => '',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => 'Kæd agenter til grupper.',
        'Link agents to roles.' => 'Kæd agenter til roller.',
        'Link attachments to responses templates.' => 'Kæd vedhæftede filer til svarskabeloner.',
        'Link customers to groups.' => 'Kæd kunder til grupper.',
        'Link customers to services.' => 'Kæd kunder til services.',
        'Link queues to auto responses.' => 'Kæd køer til autosvar',
        'Link responses to queues.' => 'Kæd svar til køer.',
        'Link roles to groups.' => 'Kæd roller til grupper.',
        'Links 2 tickets with a "Normal" type link.' => '',
        'Links 2 tickets with a "ParentChild" type link.' => '',
        'List of CSS files to always be loaded for the agent interface.' =>
            '',
        'List of CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            '',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            '',
        'List of JS files to always be loaded for the agent interface.' =>
            '',
        'List of JS files to always be loaded for the customer interface.' =>
            '',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'Log-fil for sagsnummer-tælleren.',
        'Mail Accounts' => '',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            '',
        'Makes the application check the syntax of email addresses.' => '',
        'Makes the picture transparent.' => 'Gør billedet transparant.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            '',
        'Manage PGP keys for email encryption.' => 'Administrer PGP-nøgler for mail-kryptering',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Administrer POP3- eller IMAP-konto, der skal hentes mail fra.',
        'Manage S/MIME certificates for email encryption.' => 'Administrer S/MIME-certifikater for mail-kryptering.',
        'Manage existing sessions.' => 'Administrer eksisterende sessioner.',
        'Manage notifications that are sent to agents.' => '',
        'Manage periodic tasks.' => 'Administrer periodiske opgaver.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            '',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => 'Max. størrelse på emnet i et mail-svar.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            '',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            '',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            '',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            '',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            '',
        'Module to check customer permissions.' => 'Modul til at tjekke kunde-rettigheder.',
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
        'My Tickets' => 'Mine Sager',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Opret ny sag ved at sende mail',
        'New phone ticket' => 'Opret ny sag',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => '',
        'Number of displayed tickets' => '',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            '',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            '',
        'Open tickets of customer' => '',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => '',
        'Overview Refresh Time' => 'Genopfrisk oversigt',
        'Overview of all open Tickets.' => 'Oversigt over alle åbne sager.',
        'PGP Key Management' => '',
        'PGP Key Upload' => '',
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
        'PostMaster Filters' => 'Postmaster-filtre',
        'PostMaster Mail Accounts' => 'Postmaster mail-konti',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => 'Køer',
        'Refresh Overviews after' => 'Genopfrisk oversigter efter x minutter',
        'Refresh interval' => 'Opdateringsfrekvens',
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
        'Responses <-> Queues' => 'Svar <-> Kø',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            '',
        'Roles <-> Groups' => 'Roller <-> Grupper',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => '',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Vælg dit tema til frontend.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Send mig en besked, hvis en kunde sender en opfølgning, og jeg er denne sags indehaver.',
        'Send notifications to users.' => 'Send beskeder til brugere.',
        'Send ticket follow up notifications' => 'Send besked om opfølgning til brugere',
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
        'Set sender email addresses for this system.' => 'Administrer afsenderadresser for dette system.',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => '',
        'Sets the PendingTime of a ticket to 0 if the state is changed to a non-pending state.' =>
            '',
        'Sets the age in minutes (first level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the age in minutes (second level) for highlighting queues that contain untouched tickets.' =>
            '',
        'Sets the configuration level of the administrator. Depending on the config level, some sysconfig options will be not shown. The config levels are in in ascending order: Expert, Advanced, Beginner. The higher the config level is (e.g. Beginner is the highest), the less likely is it that the user can accidentally configure the system in a way that it is not usable any more.' =>
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
        'Sets the minimum number of characters before autocomplete query is sent.' =>
            '',
        'Sets the number of lines that are displayed in text messages (e.g. ticket lines in the QueueZoom).' =>
            '',
        'Sets the number of search results to be displayed for the autocomplete feature.' =>
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
        'Statistics' => 'Rapporter',
        'Status view' => 'Statusoversigt',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => '',
        'Strips empty lines on the ticket preview in the queue view.' => '',
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
        'Ticket event module that triggers the escalation stop events.' =>
            '',
        'Ticket overview' => 'Sagsoversigt',
        'TicketNumber' => '',
        'Tickets' => 'Sager',
        'Time in seconds that gets added to the actual time if setting a pending-state (default: 86400 = 1 day).' =>
            '',
        'Toggles display of OTRS FeatureAddons list in PackageManager.' =>
            '',
        'Toolbar Item for a shortcut.' => '',
        'Turns on the animations used in the GUI. If you have problems with these animations (e.g. performance issues), you can turn them off here.' =>
            '',
        'Turns on the remote ip address check. It should be set to "No" if the application is used, for example, via a proxy farm or a dialup connection, because the remote ip address is mostly different for the requests.' =>
            '',
        'Types' => 'Typer',
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
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            '',
        'View performance benchmark results.' => 'Se resultat af performance test.',
        'View system log messages.' => 'Se systemets log',
        'Wear this frontend skin' => 'Brug dette skin',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Dit valg af foretrukne køer. Du får besked om handlinger i disse køer via mail, hvis det er aktiveret.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Customer Data' => 'Kundedata',
        'For more info see:' => 'For mere information se:',
        'Logout successful. Thank you for using OTRS!' => 'Du er nu logget ud. Tak fordi du bruger OTRS.',
        'Package verification failed!' => 'Pakkeverifikation fejlede!',
        'Please supply a' => 'Indtast venligst',
        'Please supply a first name' => 'Indtast venligst dit fornavn',
        'Please supply a last name' => 'Indtast venligst dit efternavn',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Secure Mode skal deaktiveres, hvis OTRS skal geninstalleres med web-installeren.',
            
        #
        # VARIOUS BITS NOT FOUND ELSEWHERE
        #
        'Room' => 'Kontor',
        'Department' => 'Afdeling',
        'Manager' => 'Leder',
        'Out Of Office' => 'Ude af Kontoret',
        'Online' => 'Logget ind',

    };
    # $$STOP$$
    return;
}
1;
