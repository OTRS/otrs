# --
# Kernel/Language/nb_NO.pm - Norwegian (bokmål) language translation
# Copyright (C) 2004 Arne Georg Gleditsch <argggh at linpro.no>
# Copyright (C) 2005 Espen Stefansen <libbe at stefansen dot net>
# Copyright (C) 2006 Knut Haugen <knuthaug at linpro.no>
# Copyright (C) 2007-2009 Fredrik Andersen <fredrik.andersen at husbanken.no>
# Copyright (C) 2010-2011 Eirik Wulff <eirik at epledoktor.no>
# Copyright (C) 2011 Lars Erik Utsi Gullerud <lerik at nolink.net>
# Copyright (C) 2011 Espen Stefansen <libbe at stefansen dot net>
# Copyright (C) 2012 Lars Magnus Herland <lars.magnus at herland.priv.no>
# Copyright (C) 2013 Espen Stefansen <libbe at stefansen dot net>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::nb_NO;

use strict;
use warnings;

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: 2013-06-14 08:49:40

    # possible charsets
    $Self->{Charset} = ['utf-8', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D/%M %Y %T';
    $Self->{DateFormatLong}      = '%A %D. %B %Y %T';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    # csv separator
    $Self->{Separator} = ';';

    $Self->{Translation} = {

        # Template: AAABase
        'Yes' => 'Ja',
        'No' => 'Nei',
        'yes' => 'ja',
        'no' => 'nei',
        'Off' => 'Av',
        'off' => 'av',
        'On' => 'På',
        'on' => 'på',
        'top' => 'topp',
        'end' => 'slutt',
        'Done' => 'Ferdig',
        'Cancel' => 'Avbryt',
        'Reset' => 'Nullstill',
        'last' => 'siste',
        'before' => 'før',
        'Today' => 'Idag',
        'Tomorrow' => 'I morgen',
        'Next week' => 'Neste uke',
        'day' => 'dag',
        'days' => 'dager',
        'day(s)' => 'dag(er)',
        'd' => 'd',
        'hour' => 'time',
        'hours' => 'timer',
        'hour(s)' => 'time(r)',
        'Hours' => 'Timer',
        'h' => 't',
        'minute' => 'minutt',
        'minutes' => 'minutter',
        'minute(s)' => 'minutt(er)',
        'Minutes' => 'Minutter',
        'm' => 'm',
        'month' => 'måned',
        'months' => 'måneder',
        'month(s)' => 'måned(er)',
        'week' => 'uke',
        'week(s)' => 'uke(r)',
        'year' => 'år',
        'years' => 'år',
        'year(s)' => 'år',
        'second(s)' => 'sekund(er)',
        'seconds' => 'sekunder',
        'second' => 'sekund',
        's' => 's',
        'wrote' => 'skrev',
        'Message' => 'Melding',
        'Error' => 'Feil',
        'Bug Report' => 'Feil-rapport',
        'Attention' => 'OBS',
        'Warning' => 'Advarsel',
        'Module' => 'Modul',
        'Modulefile' => 'Modulfil',
        'Subfunction' => 'Underfunksjon',
        'Line' => 'Linje',
        'Setting' => 'Innstilling',
        'Settings' => 'Innstillinger',
        'Example' => 'Eksempel',
        'Examples' => 'Eksempler',
        'valid' => 'gyldig',
        'Valid' => 'Gyldig',
        'invalid' => 'ugyldig',
        'Invalid' => 'Ugyldig',
        '* invalid' => '* ugyldig',
        'invalid-temporarily' => 'midlertidig ugyldig',
        ' 2 minutes' => ' 2 minutter',
        ' 5 minutes' => ' 5 minutter',
        ' 7 minutes' => ' 7 minutter',
        '10 minutes' => '10 minutter',
        '15 minutes' => '15 minutter',
        'Mr.' => 'Hr.',
        'Mrs.' => 'Fru',
        'Next' => 'Neste',
        'Back' => 'Tilbake',
        'Next...' => 'Neste...',
        '...Back' => '...Tilbake',
        '-none-' => '-ingen-',
        'none' => 'ingen',
        'none!' => 'ingen!',
        'none - answered' => 'ingen - besvart',
        'please do not edit!' => 'Vennligst ikke endre!',
        'Need Action' => 'Trenger handling',
        'AddLink' => 'Legg til link',
        'Link' => 'Koble',
        'Unlink' => 'Koble fra',
        'Linked' => 'Koblet',
        'Link (Normal)' => 'Koblet (Normal)',
        'Link (Parent)' => 'Koblet (Forelder))',
        'Link (Child)' => 'Koblet (Barn)',
        'Normal' => 'Normal',
        'Parent' => 'Forelder',
        'Child' => 'Barn',
        'Hit' => 'Treff',
        'Hits' => 'Treff',
        'Text' => 'Tekst',
        'Standard' => 'Standard',
        'Lite' => 'Enkel',
        'User' => 'Bruker',
        'Username' => 'Brukernavn',
        'Language' => 'Språk',
        'Languages' => 'Språk',
        'Password' => 'Passord',
        'Preferences' => 'Innstillinger',
        'Salutation' => 'Hilsning',
        'Salutations' => 'Hilsninger',
        'Signature' => 'Signatur',
        'Signatures' => 'Signaturer',
        'Customer' => 'Kunde',
        'CustomerID' => 'Kunde-ID',
        'CustomerIDs' => 'Kunde-IDer',
        'customer' => 'kunde',
        'agent' => 'saksbehandler',
        'system' => 'system',
        'Customer Info' => 'Kunde info',
        'Customer Information' => 'Kundeinformasjon',
        'Customer Company' => 'Kundebedrift',
        'Customer Companies' => 'Kundefirma',
        'Company' => 'Bedrift',
        'go!' => 'Start!',
        'go' => 'Start',
        'All' => 'Alle',
        'all' => 'alle',
        'Sorry' => 'Beklager',
        'update!' => 'oppdater!',
        'update' => 'oppdater',
        'Update' => 'Oppdater',
        'Updated!' => 'Oppdatert!',
        'submit!' => 'send!',
        'submit' => 'send',
        'Submit' => 'Send',
        'change!' => 'endre!',
        'Change' => 'Endre',
        'change' => 'endre',
        'click here' => 'klikk her',
        'Comment' => 'Kommentar',
        'Invalid Option!' => 'Ugyldig valg',
        'Invalid time!' => 'Ugyldig tid',
        'Invalid date!' => 'Ugyldig dato',
        'Name' => 'Navn',
        'Group' => 'Gruppe',
        'Description' => 'Beskrivelse',
        'description' => 'beskrivelse',
        'Theme' => 'Tema',
        'Created' => 'Opprettet',
        'Created by' => 'Opprettet av',
        'Changed' => 'Endret',
        'Changed by' => 'Endret av',
        'Search' => 'Søk',
        'and' => 'og',
        'between' => 'mellom',
        'Fulltext Search' => 'Fritekst-søk',
        'Data' => 'Data',
        'Options' => 'Valg',
        'Title' => 'Tittel',
        'Item' => 'Punkt',
        'Delete' => 'Slett',
        'Edit' => 'Rediger',
        'View' => 'Bilde',
        'Number' => 'Nummer',
        'System' => 'System',
        'Contact' => 'Kontakt',
        'Contacts' => 'Kontakter',
        'Export' => 'Eksporter',
        'Up' => 'Stigende',
        'Down' => 'Synkende',
        'Add' => 'Legg til',
        'Added!' => 'Lagt til!',
        'Category' => 'Kategori',
        'Viewer' => 'Fremviser',
        'Expand' => 'Utvid',
        'Small' => 'Liten',
        'Medium' => 'Medium',
        'Large' => 'Stor',
        'Date picker' => 'Datovelger',
        'New message' => 'Ny melding',
        'New message!' => 'Ny melding!',
        'Please answer this ticket(s) to get back to the normal queue view!' =>
            'Vennligst besvar denne/disse sakene for å komme tilbake til det normale køvisningsbildet!',
        'You have %s new message(s)!' => 'Du har %s ny(e) melding(er)!',
        'You have %s reminder ticket(s)!' => 'Du har %s påminnelses-sak(er)!',
        'The recommended charset for your language is %s!' => 'Anbefalt tegnsett for ditt språk er %s!',
        'Change your password.' => 'Endre passordet ditt.',
        'Please activate %s first!' => 'Vennligst aktiver %s først!',
        'No suggestions' => 'Ingen forslag',
        'Word' => 'Ord',
        'Ignore' => 'Ignorer',
        'replace with' => 'erstatt med',
        'There is no account with that login name.' => 'Finner ingen konto med det navnet.',
        'Login failed! Your user name or password was entered incorrectly.' =>
            'Innlogging feilet! Brukernavn eller passord ble skrevet inn feil.',
        'There is no acount with that user name.' => 'Det finnes ingen konto med det brukernavnet',
        'Please contact your administrator' => 'Vennligst kontakt administratoren',
        'Logout' => 'Logg ut',
        'Logout successful. Thank you for using %s!' => 'Utlogging utført.  Takk for at du brukte %s!',
        'Feature not active!' => 'Funksjon ikke aktivert!',
        'Agent updated!' => 'Saksbehandler oppdatert',
        'Create Database' => 'Opprett database',
        'System Settings' => 'Systeminnstillinger',
        'Mail Configuration' => 'E-postoppsett',
        'Finished' => 'Ferdig',
        'Install OTRS' => 'Installer OTRS',
        'Intro' => 'Introduksjon',
        'License' => 'Lisens',
        'Database' => 'Database',
        'Configure Mail' => 'Konfigurer e-post',
        'Database deleted.' => 'Databasen fjernet',
        'Database setup successful!' => 'Konfigurasjon av databasen var vellykket',
        'Generated password' => '',
        'Login is needed!' => 'Innlogging kreves',
        'Password is needed!' => 'Passord er påkrevd!',
        'Take this Customer' => 'Velg denne kunden',
        'Take this User' => 'Velg denne brukeren',
        'possible' => 'mulig',
        'reject' => 'Avvises',
        'reverse' => 'motsatt',
        'Facility' => 'Innretning',
        'Time Zone' => 'Tidssone',
        'Pending till' => 'Utsatt til',
        'Don\'t use the Superuser account to work with OTRS! Create new Agents and work with these accounts instead.' =>
            'Ikke bruk Superbruker kontoen til å jobbe med OTRS! Opprett nye Agenter og jobb heller med disse kontoene.',
        'Dispatching by email To: field.' => 'Utsending etter oppføringer i To:-felt.',
        'Dispatching by selected Queue.' => 'Utsending etter valgt kø.',
        'No entry found!' => 'Ingen oppføringer funnet!',
        'Session invalid. Please log in again.' => '',
        'Session has timed out. Please log in again.' => 'Sesjonen har gått ut på tid.  Vennligst logg inn igjen.',
        'Session limit reached! Please try again later.' => '',
        'No Permission!' => 'Ingen rettigheter!',
        '(Click here to add)' => '(Klikk her for å legge til)',
        'Preview' => 'Forhåndsvisning',
        'Package not correctly deployed! Please reinstall the package.' =>
            'Pakken er ikke riktig installert! Vennligst installer pakken på nytt.',
        '%s is not writable!' => '%s er ikke skrivbar!',
        'Cannot create %s!' => 'Kan ikke opprette %s!',
        'Check to activate this date' => 'Kryss av for å aktivere denne datoen',
        'You have Out of Office enabled, would you like to disable it?' =>
            'Du har fraværassistenten aktivert, vil du så den av?',
        'Customer %s added' => 'Kunde %s lagt til',
        'Role added!' => 'Rollen ble lagt til!',
        'Role updated!' => 'Rolle oppdatert!',
        'Attachment added!' => 'Vedlegg lagt til!',
        'Attachment updated!' => 'Vedlegg oppdatert!',
        'Response added!' => 'Svaret ble lagret!',
        'Response updated!' => 'Svaret ble lagret!',
        'Group updated!' => 'Gruppe oppdatert!',
        'Queue added!' => 'Kø lagt til!',
        'Queue updated!' => 'Kø oppdatert!',
        'State added!' => 'Status lagt til!',
        'State updated!' => 'Status oppdatert!',
        'Type added!' => 'Type lagt til!',
        'Type updated!' => 'Type oppdatert!',
        'Customer updated!' => 'Kunde oppdatert!',
        'Customer company added!' => 'Kundebedrift lagt til!',
        'Customer company updated!' => 'Kundebedrift oppdatert!',
        'Mail account added!' => 'E-postkonto lagt til!',
        'Mail account updated!' => 'E-postkonto oppdatert!',
        'System e-mail address added!' => 'System e-postadresse lagt til!',
        'System e-mail address updated!' => 'System e-postadresse oppdatert!',
        'Contract' => 'Kontrakt',
        'Online Customer: %s' => 'Pålogget kunde: %s',
        'Online Agent: %s' => 'Pålogget agent: %s',
        'Calendar' => 'Kalender',
        'File' => 'Fil',
        'Filename' => 'Filnavn',
        'Type' => 'Type',
        'Size' => 'Størrelse',
        'Upload' => 'Last opp',
        'Directory' => 'Katalog',
        'Signed' => 'Signert',
        'Sign' => 'Signer',
        'Crypted' => 'Kryptert',
        'Crypt' => 'Krypter',
        'PGP' => 'PGP',
        'PGP Key' => 'PGP-nøkkel',
        'PGP Keys' => 'PGP-nøkler',
        'S/MIME' => 'S/MIME',
        'S/MIME Certificate' => 'S/MIME-sertifikat',
        'S/MIME Certificates' => 'S/MIME-sertifikater',
        'Office' => 'Kontor',
        'Phone' => 'Telefon',
        'Fax' => 'Telefaks',
        'Mobile' => 'Mobil',
        'Zip' => 'Postnr',
        'City' => 'By',
        'Street' => 'Gate',
        'Country' => 'Land',
        'Location' => 'Kart',
        'installed' => 'installert',
        'uninstalled' => 'avinstallert',
        'Security Note: You should activate %s because application is already running!' =>
            'Sikkerhetsnotis: Du burde aktivere %s siden applikasjonen allerede kjører!',
        'Unable to parse repository index document.' => 'Kunne ikke lese fjernarkivets indeks',
        'No packages for your framework version found in this repository, it only contains packages for other framework versions.' =>
            'Ingen pakker ble funnet for din rammeverk-versjon, kun for andre versjoner',
        'No packages, or no new packages, found in selected repository.' =>
            'Ingen pakker, eller ingen nye pakker ble funnet i valgt fjernarkiv',
        'Edit the system configuration settings.' => 'Endre på systeminnstillingene',
        'printed at' => 'skrevet ut på',
        'Loading...' => 'Laster...',
        'Dear Mr. %s,' => 'Kjære %s',
        'Dear Mrs. %s,' => 'Kjære %s',
        'Dear %s,' => 'Kjære %s',
        'Hello %s,' => 'Hei %s',
        'This email address already exists. Please log in or reset your password.' =>
            'Denne e-postadressen finnes allerede. Vennligst logg inn eller nullstill passordet.',
        'New account created. Sent login information to %s. Please check your email.' =>
            'En ny konto har blitt opprettet. Brukernavn og passord er sendt til %s. Vennligst sjekk e-posten din.',
        'Please press Back and try again.' => 'Vennligst gå tilbake og prøv på nytt',
        'Sent password reset instructions. Please check your email.' => 'Instrukser for nullstilling av passord har blitt sendt til din e-postadresse.',
        'Sent new password to %s. Please check your email.' => 'Nytt passord ble sendt til %s. Sjekk e-posten din.',
        'Upcoming Events' => 'Kommende hendelser',
        'Event' => 'Hendelse',
        'Events' => 'Hendelser',
        'Invalid Token!' => 'Ugyldig bevis!',
        'more' => 'mer',
        'Collapse' => 'Minimer',
        'Shown' => 'Vist',
        'Shown customer users' => '',
        'News' => 'Nyheter',
        'Product News' => 'Produktnyheter',
        'OTRS News' => 'OTRS-nyheter',
        '7 Day Stats' => '7-dagers statistikk',
        'Process Management information from database is not in sync with the system configuration, please synchronize all processes.' =>
            '',
        'Package not verified by the OTRS Group! It is recommended not to use this package.' =>
            '',
        '<br>If you continue to install this package, the following issues may occur!<br><br>&nbsp;-Security problems<br>&nbsp;-Stability problems<br>&nbsp;-Performance problems<br><br>Please note that issues that are caused by working with this package are not covered by OTRS service contracts!<br><br>' =>
            '',
        'Bold' => 'Halvfet',
        'Italic' => 'Kursiv',
        'Underline' => 'Understrek',
        'Font Color' => 'Skriftfarge',
        'Background Color' => 'Bakgrunnsfarge',
        'Remove Formatting' => 'Fjern Formatering',
        'Show/Hide Hidden Elements' => 'Vis/Skjul Skjulte Elementer',
        'Align Left' => 'Venstrejuster',
        'Align Center' => 'Midtstill',
        'Align Right' => 'Høyrejuster',
        'Justify' => 'Juster',
        'Header' => 'Overskrift',
        'Indent' => 'Innrykk',
        'Outdent' => 'Utrykk',
        'Create an Unordered List' => 'Lag en unummerert liste',
        'Create an Ordered List' => 'Lag en nummerert liste',
        'HTML Link' => 'HTML-lenke',
        'Insert Image' => 'Sett Inn Bilde',
        'CTRL' => 'CTRL',
        'SHIFT' => 'SKIFT',
        'Undo' => 'Angre',
        'Redo' => 'Omgjør',
        'Scheduler process is registered but might not be running.' => 'Oppgaveplanlegger prosessen er registrert men kjører kanskje ikke.',
        'Scheduler is not running.' => 'Oppgaveplanleggeren kjører ikke.',

        # Template: AAACalendar
        'New Year\'s Day' => 'Nyttårsdagen',
        'International Workers\' Day' => 'Internasjonale arbeidernes dag',
        'Christmas Eve' => 'Julaften',
        'First Christmas Day' => 'Første juledag',
        'Second Christmas Day' => 'Andre juledag',
        'New Year\'s Eve' => 'Nyttårsaften',

        # Template: AAAGenericInterface
        'OTRS as requester' => 'OTRS som en etterspørrer',
        'OTRS as provider' => 'OTRS som en leverandør',
        'Webservice "%s" created!' => 'Webtjeneste "%s" lagt til!',
        'Webservice "%s" updated!' => 'Webtjeneste "%s" oppdatert!',

        # Template: AAAMonth
        'Jan' => 'jan',
        'Feb' => 'feb',
        'Mar' => 'mar',
        'Apr' => 'apr',
        'May' => 'mai',
        'Jun' => 'jun',
        'Jul' => 'jul',
        'Aug' => 'aug',
        'Sep' => 'sep',
        'Oct' => 'okt',
        'Nov' => 'nov',
        'Dec' => 'des',
        'January' => 'januar',
        'February' => 'februar',
        'March' => 'mars',
        'April' => 'april',
        'May_long' => 'mai',
        'June' => 'juni',
        'July' => 'juli',
        'August' => 'august',
        'September' => 'september',
        'October' => 'oktober',
        'November' => 'november',
        'December' => 'desember',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Innstillinger lagret!',
        'User Profile' => 'Brukerprofil',
        'Email Settings' => 'E-postinnstillinger',
        'Other Settings' => 'Andre innstillinger',
        'Change Password' => 'Endre passord',
        'Current password' => 'Nåværende passord',
        'New password' => 'Nytt passord',
        'Verify password' => 'Gjenta passord',
        'Spelling Dictionary' => 'Ordbok for stavekontroll',
        'Default spelling dictionary' => 'Standard ordliste for stavekontroll',
        'Max. shown Tickets a page in Overview.' => 'Maks. viste saker per side i oversikten.',
        'The current password is not correct. Please try again!' => 'Nåværende passord er ikke korrekt. Prøv igjen.',
        'Can\'t update password, your new passwords do not match. Please try again!' =>
            'Kan ikke oppdatere passordet fordi det nye passordet ikke er skrevet likt i begge felt. Prøv igjen!',
        'Can\'t update password, it contains invalid characters!' => 'Kan ikke oppdatere passordet fordi det inneholder ulovlige tegn!',
        'Can\'t update password, it must be at least %s characters long!' =>
            'Kan ikke oppdatere passordet, det må være minst %s tegn langt!',
        'Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!' =>
            'Kan ikke oppdatere passordet, det må inneholde minst to små og to store bokstaver!',
        'Can\'t update password, it must contain at least 1 digit!' => 'Kan ikke oppdatere passordet, det må inneholde minst ett tall!',
        'Can\'t update password, it must contain at least 2 characters!' =>
            'Kan ikke oppdatere passordet fordi det må inneholde minst to bokstaver!',
        'Can\'t update password, this password has already been used. Please choose a new one!' =>
            'Kan ikke oppdatere passordet fordi du har brukt det før. Vennligst velg et annet!',
        'Select the separator character used in CSV files (stats and searches). If you don\'t select a separator here, the default separator for your language will be used.' =>
            'Velg et separator-tegn for bruk i CSV-filer (statistikk og søk). Hvis du ikke velger en, vil standardtegnet for språket bli brukt.',
        'CSV Separator' => 'CSV-separator',

        # Template: AAAStats
        'Stat' => 'Statistikk',
        'Sum' => 'Sum',
        'Please fill out the required fields!' => 'Vennligst fyll ut alle påkrevde felter!',
        'Please select a file!' => 'Vennligst velg en fil!',
        'Please select an object!' => 'Vennligst velg et objekt!',
        'Please select a graph size!' => 'Vennligst velge en graf størrelse!',
        'Please select one element for the X-axis!' => 'Vennligst velg ett element for X-aksen!',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' =>
            'Vennligst velg kun ett element, eller deaktiver \'Fast\' knappen der det valgte feltet er markert!',
        'If you use a checkbox you have to select some attributes of the select field!' =>
            'Dersom du benytter en avkryssingsboks må du velge noen attributter i valg feltet!',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' =>
            'Vennligst skriv inn en verdi i det valgte input feltet, eller skru av \'Fast\' avkryssingsruten!',
        'The selected end time is before the start time!' => 'Det valgte slutt tidspunktet er før start tidspunktet!',
        'You have to select one or more attributes from the select field!' =>
            'Du må velge en eller flere attributter fra valg feltet!',
        'The selected Date isn\'t valid!' => 'Den valgte datoen er ikke gyldig!',
        'Please select only one or two elements via the checkbox!' => 'Vennligst velg kun en eller to elementer i avkryssingsruten!',
        'If you use a time scale element you can only select one element!' =>
            'Dersom du benytter et tidsskala element, må du kun velge ett element!',
        'You have an error in your time selection!' => 'Du har en feil i tidsvalget!',
        'Your reporting time interval is too small, please use a larger time scale!' =>
            'Rapporteringsintervallet er for lite, vennligst velg et større intervall!',
        'The selected start time is before the allowed start time!' => 'Det valgte start tidspunktet er før godkjent start tidspunkt!',
        'The selected end time is after the allowed end time!' => 'Det valgte slutt tidspunktet er etter godkjent slutt tidspunkt!',
        'The selected time period is larger than the allowed time period!' =>
            'Den valgte tidsperioden er større enn godkjent tidsperiode!',
        'Common Specification' => 'Felles spesifikasjon',
        'X-axis' => 'X-akse',
        'Value Series' => 'Verdiserier',
        'Restrictions' => 'Restriksjoner',
        'graph-lines' => 'graf-linjer',
        'graph-bars' => 'graf-stolper',
        'graph-hbars' => 'graf-hlinjer',
        'graph-points' => 'graf-punkter',
        'graph-lines-points' => 'graf-linjer-punkter',
        'graph-area' => 'graf-område',
        'graph-pie' => 'graf-kakediagram',
        'extended' => 'utvidet',
        'Agent/Owner' => 'Saksbehandler/Eier',
        'Created by Agent/Owner' => 'Opprettet av Saksbehandler/Eier',
        'Created Priority' => 'Opprettet Prioritet',
        'Created State' => 'Opprettet Status',
        'Create Time' => 'Tid',
        'CustomerUserLogin' => 'KundeBrukerInnlogging',
        'Close Time' => 'Avsluttet Tidspunkt',
        'TicketAccumulation' => 'SaksAkkumulering',
        'Attributes to be printed' => 'Attributter som skal printes',
        'Sort sequence' => 'Sorteringssekvens',
        'Order by' => 'Sorter etter',
        'Limit' => 'Grense',
        'Ticketlist' => 'Saksliste',
        'ascending' => 'stigende',
        'descending' => 'synkende',
        'First Lock' => 'Første Lås',
        'Evaluation by' => 'Evaluering av',
        'Total Time' => 'Total Tid',
        'Ticket Average' => 'Saksgjennomsnitt',
        'Ticket Min Time' => 'Sak Min Tid',
        'Ticket Max Time' => 'Sak Max Tid',
        'Number of Tickets' => 'Antall Saker',
        'Article Average' => 'Innlegg Gjennomsnitt',
        'Article Min Time' => 'Innlegg Min Tid',
        'Article Max Time' => 'Innlegg Max Tid',
        'Number of Articles' => 'Antall Innlegg',
        'Accounted time by Agent' => 'Utgjort tid av Saksbehandler',
        'Ticket/Article Accounted Time' => 'Sak/Innlegg Utgjort Tid',
        'TicketAccountedTime' => 'SakUtgjortTid',
        'Ticket Create Time' => 'Sak Opprettelsestidspunkt',
        'Ticket Close Time' => 'Sak Avsluttingstidspunkt',

        # Template: AAATicket
        'Status View' => 'Statusvisning',
        'Bulk' => 'Masseendring',
        'Lock' => 'Ta sak',
        'Unlock' => 'Frigi sak',
        'History' => 'Historikk',
        'Zoom' => 'Detaljer',
        'Age' => 'Alder',
        'Bounce' => 'Oversend',
        'Forward' => 'Videresend',
        'From' => 'Fra',
        'To' => 'Til',
        'Cc' => 'Kopi',
        'Bcc' => 'Blindkopi',
        'Subject' => 'Emne',
        'Move' => 'Flytt',
        'Queue' => 'Kø',
        'Queues' => 'Køer',
        'Priority' => 'Prioritet',
        'Priorities' => 'Prioriteter',
        'Priority Update' => 'Oppdatering av prioritet',
        'Priority added!' => 'Prioritet lagt til!',
        'Priority updated!' => 'Prioritet oppdatert!',
        'Signature added!' => 'Signatur lagt til!',
        'Signature updated!' => 'Signatur oppdatert!',
        'SLA' => 'SLA',
        'Service Level Agreement' => 'Tjenestenivåavtale',
        'Service Level Agreements' => 'Tjenestenivåavtaler',
        'Service' => 'Tjeneste',
        'Services' => 'Tjenester',
        'State' => 'Status',
        'States' => 'Statuser',
        'Status' => 'Status',
        'Statuses' => 'Statuser',
        'Ticket Type' => 'Sakstype',
        'Ticket Types' => 'Sakstyper',
        'Compose' => 'Forfatt',
        'Pending' => 'Satt på vent',
        'Owner' => 'Eier',
        'Owner Update' => 'Oppdatering av eier',
        'Responsible' => 'Ansvarlig',
        'Responsible Update' => 'Oppdatering av ansvarlig',
        'Sender' => 'Avsender',
        'Article' => 'Innlegg',
        'Ticket' => 'Sak',
        'Createtime' => 'Opprettet',
        'plain' => 'rå',
        'Email' => 'E-post',
        'email' => 'e-post',
        'Close' => 'Avslutt sak',
        'Action' => 'Handling',
        'Attachment' => 'Vedlegg',
        'Attachments' => 'Vedlegg',
        'This message was written in a character set other than your own.' =>
            'Denne meldingen ble skrevet i et annet tegnsett enn det du bruker.',
        'If it is not displayed correctly,' => 'Dersom den ikke vises korrekt,',
        'This is a' => 'Dette er en',
        'to open it in a new window.' => 'for å åpne i nytt vindu',
        'This is a HTML email. Click here to show it.' => 'Dette er en HTML e-post. Klikk her for å vise den.',
        'Free Fields' => 'Stikkord',
        'Merge' => 'Flett',
        'merged' => 'flettet',
        'closed successful' => 'løst og lukket',
        'closed unsuccessful' => 'lukket uløst',
        'Locked Tickets Total' => 'Totalt antall saker under behandling',
        'Locked Tickets Reminder Reached' => 'Antall saker med påminnelser',
        'Locked Tickets New' => 'Nye saker under behandling',
        'Responsible Tickets Total' => 'Totalt antall saker du er ansvarlig for',
        'Responsible Tickets New' => 'Nye saker du er ansvarlig for',
        'Responsible Tickets Reminder Reached' => 'Saker du er ansvarlig for med påminnelser',
        'Watched Tickets Total' => 'Totalt antall overvåkede saker',
        'Watched Tickets New' => 'Nye overvåkede saker',
        'Watched Tickets Reminder Reached' => 'Overvåkede saker med påminnelser',
        'All tickets' => 'Alle saker',
        'Available tickets' => 'Tilgjengelige saker',
        'Escalation' => 'Eskalering',
        'last-search' => 'siste søk',
        'QueueView' => 'Køer',
        'Ticket Escalation View' => 'Eskaleringsvisning',
        'Message from' => 'Melding fra',
        'End message' => 'Sluttmelding',
        'Forwarded message from' => 'Videresend meldingen fra',
        'End forwarded message' => 'Avslutt videresendt melding',
        'new' => 'ny',
        'open' => 'åpen',
        'Open' => 'Åpen',
        'Open tickets' => 'Åpne saker',
        'closed' => 'avsluttet',
        'Closed' => 'Avsluttet',
        'Closed tickets' => 'Lukkede saker',
        'removed' => 'fjernet',
        'pending reminder' => 'venter på påminnelse',
        'pending auto' => 'venter på automatisk endring',
        'pending auto close+' => 'auto-avslutning (løst)',
        'pending auto close-' => 'auto-avslutning (uløst)',
        'email-external' => 'e-post eksternt',
        'email-internal' => 'e-post internt',
        'note-external' => 'notis eksternt',
        'note-internal' => 'notis internt',
        'note-report' => 'notis til rapport',
        'phone' => 'telefon',
        'sms' => 'sms',
        'webrequest' => 'web-forespørsel',
        'lock' => 'privat',
        'unlock' => 'tilgjengelig',
        'very low' => 'svært lav',
        'low' => 'lav',
        'normal' => 'normal',
        'high' => 'høy',
        'very high' => 'svært høy',
        '1 very low' => '1 svært lav',
        '2 low' => '2 lav',
        '3 normal' => '3 normal',
        '4 high' => '4 høy',
        '5 very high' => '5 svært høy',
        'auto follow up' => 'Automatisk oppfølging',
        'auto reject' => 'Avslå automatisk',
        'auto remove' => 'Fjern automatisk ',
        'auto reply' => 'Svar automatisk',
        'auto reply/new ticket' => 'Svar/ny sak automatisk',
        'Ticket "%s" created!' => 'Sak «%s» opprettet!',
        'Ticket Number' => 'Saksnummer',
        'Ticket Object' => 'Saksobjekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Finner ikke saksnummer «%s»! Kan ikke linke til det!',
        'You don\'t have write access to this ticket.' => 'Du har ikke skrivetilgang til denne saken.',
        'Sorry, you need to be the ticket owner to perform this action.' =>
            'Beklager, du må være eier av saken for å utføre denne handlingen',
        'Please change the owner first.' => '',
        'Ticket selected.' => 'Sak valgt',
        'Ticket is locked by another agent.' => 'Saken er låst på en annen saksbehandler',
        'Ticket locked.' => 'Saken er låst',
        'Don\'t show closed Tickets' => 'Ikke vis avsluttede saker',
        'Show closed Tickets' => 'Vis avsluttede saker',
        'New Article' => 'Nytt innlegg',
        'Unread article(s) available' => 'Uleste artikler tilgjengelig',
        'Remove from list of watched tickets' => 'Fjern fra listen over overvåkede saker',
        'Add to list of watched tickets' => 'Legg til i listen over overvåkede saker',
        'Email-Ticket' => 'Send e-post',
        'Create new Email Ticket' => 'Opprett ny sak ved å sende e-post',
        'Phone-Ticket' => 'Henvendelser',
        'Search Tickets' => 'Søk i saker',
        'Edit Customer Users' => 'Rediger kundebrukere',
        'Edit Customer Company' => 'Rediger kundebedrift',
        'Bulk Action' => 'Masseredigering',
        'Bulk Actions on Tickets' => 'Masseredigering på saker',
        'Send Email and create a new Ticket' => 'Send e-post og opprett en ny sak',
        'Create new Email Ticket and send this out (Outbound)' => 'Opprett ny e-post sak, og send denne utgående',
        'Create new Phone Ticket (Inbound)' => 'Opprett ny telefonhenvendelse (inngående)',
        'Address %s replaced with registered customer address.' => 'Adressen %s er byttet ut med adressen som er registrert på kunde',
        'Customer automatically added in Cc.' => 'Kunde automatisk lagt til i Cc',
        'Overview of all open Tickets' => 'Oversikt over alle tilgjengelige saker',
        'Locked Tickets' => 'Mine private saker',
        'My Locked Tickets' => 'Mine låste saker',
        'My Watched Tickets' => 'Mine overvåkede saker',
        'My Responsible Tickets' => 'Saker jeg er ansvarlig for',
        'Watched Tickets' => 'Overvåkede saker',
        'Watched' => 'Overvåket',
        'Watch' => 'Overvåk',
        'Unwatch' => 'Ikke overvåk',
        'Lock it to work on it' => 'Lås sak for å arbeide med den',
        'Unlock to give it back to the queue' => 'Frigi sak til køen',
        'Show the ticket history' => 'Vis saks-historikk',
        'Print this ticket' => 'Skriv ut denne saken',
        'Print this article' => 'Skriv ut denne artikkelen',
        'Split' => '',
        'Split this article' => 'Skill ut denne artikkelen',
        'Forward article via mail' => 'Videresend artikkelen via e-post',
        'Change the ticket priority' => 'Bytt prioritet på saken',
        'Change the ticket free fields!' => 'Endre stikkordene!',
        'Link this ticket to other objects' => 'Koble denne saken til andre objekter',
        'Change the owner for this ticket' => 'Bytt eier av denne saken',
        'Change the  customer for this ticket' => 'Bytt kunde i denne saken',
        'Add a note to this ticket' => 'Legg til et notis på denne saken',
        'Merge into a different ticket' => 'Flett inn i en annen sak',
        'Set this ticket to pending' => 'Sett sak som venter tilbakemelding',
        'Close this ticket' => 'Lukk denne saken',
        'Look into a ticket!' => 'Se på sak!',
        'Delete this ticket' => 'Fjern denne saken',
        'Mark as Spam!' => 'Marker som søppel',
        'My Queues' => 'Mine køer',
        'Shown Tickets' => 'Viste saker',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' =>
            'Din e-postsak med nummer "<OTRS_TICKET>" er flettet med "<OTRS_MERGE_TO_TICKET>". ',
        'Ticket %s: first response time is over (%s)!' => 'Sak %s: første responstid tidsfristen er overskredet (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Sak %s: første responstid tidsfristen er over om %s!',
        'Ticket %s: update time is over (%s)!' => 'Sak %s: oppdateringtidsfristen er overskredet (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Sak %s: oppdateringtidsfristen er over om %s!',
        'Ticket %s: solution time is over (%s)!' => 'Sak %s: løsningtidsfristen er overskredet (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Sak %s: løsningtidsfristen er over om %s!',
        'There are more escalated tickets!' => 'Det er flere eskalerte saker!',
        'Plain Format' => 'Kildetekst',
        'Reply All' => 'Svar Alle',
        'Direction' => 'Retning',
        'Agent (All with write permissions)' => 'Saksbehandler (Alle med skriverettigheter)',
        'Agent (Owner)' => 'Saksbehandler (Eier)',
        'Agent (Responsible)' => 'Saksbehandler (Ansvarlig)',
        'New ticket notification' => 'Varsling ved ny sak',
        'Send me a notification if there is a new ticket in "My Queues".' =>
            'Send meg en varsling dersom det kommer en ny sak i mine utvalgte køer.',
        'Send new ticket notifications' => 'Send varsling om nye saker',
        'Ticket follow up notification' => 'Varsling ved saksoppfølging',
        'Ticket lock timeout notification' => 'Varsling ved overskridelse av tidsfrist for avslutting av sak',
        'Send me a notification if a ticket is unlocked by the system.' =>
            'Send meg en varsling dersom systemet åpner en avsluttet sak.',
        'Send ticket lock timeout notifications' => 'Send varsling om tidsoverskridelse på sakslås',
        'Ticket move notification' => 'Varsling om flytting av sak',
        'Send me a notification if a ticket is moved into one of "My Queues".' =>
            'Send meg en varsling dersom en sak flyttes over i en av mine utvalgte køer.',
        'Send ticket move notifications' => 'Send varsling om flytting av sak',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' =>
            'Dine kø-valg over favoritt-køer. Du kan også få notiser om disse køene via e-post om det er skrudd på',
        'Custom Queue' => 'Utvalgte køer',
        'QueueView refresh time' => 'Automatisk oppdateringfrekvens av kø-visningen',
        'If enabled, the QueueView will automatically refresh after the specified time.' =>
            'Hvis slått på vil kø-listen automatisk oppdatere seg etter spesifisert tid',
        'Refresh QueueView after' => 'Automatisk gjenoppfriskning av kø-visning etter',
        'Screen after new ticket' => 'Skjermbilde etter innlegging av ny sak',
        'Show this screen after I created a new ticket' => 'Vis denne skjermen etter at jeg oppretter en ny sak',
        'Closed Tickets' => 'Avsluttede saker',
        'Show closed tickets.' => 'Vis avsluttede saker.',
        'Max. shown Tickets a page in QueueView.' => 'Max. viste saker per side i kø-visningen.',
        'Ticket Overview "Small" Limit' => 'Begrensning for saksvisning "liten"',
        'Ticket limit per page for Ticket Overview "Small"' => 'Antall saker per side for Saksvisning "liten"',
        'Ticket Overview "Medium" Limit' => 'Begrensning for saksvisning "medium"',
        'Ticket limit per page for Ticket Overview "Medium"' => 'Antall saker per side for Saksvisning "medium"',
        'Ticket Overview "Preview" Limit' => 'Begrensning for saksvisning "forhåndsvisning"',
        'Ticket limit per page for Ticket Overview "Preview"' => 'Antall saker per side for Saksvisning "Forhåndsvisning"',
        'Ticket watch notification' => 'Varsling om overvåkede saker',
        'Send me the same notifications for my watched tickets that the ticket owners will get.' =>
            'Send meg samme varsling for overvåkede saker som sakens eier får',
        'Send ticket watch notifications' => 'Send varsling om overvåkede saker',
        'Out Of Office Time' => 'Tidspunkt man er ute fra kontoret',
        'New Ticket' => 'Ny sak',
        'Create new Ticket' => 'Opprett ny sak',
        'Customer called' => 'Kunde oppringt',
        'phone call' => 'telefonsamtale',
        'Phone Call Outbound' => 'Utgående telefonsamtale',
        'Phone Call Inbound' => 'Innkommende telefonsamtale',
        'Reminder Reached' => 'Påminnelse nådd',
        'Reminder Tickets' => 'Saker med påminnelse',
        'Escalated Tickets' => 'Eskalerte saker',
        'New Tickets' => 'Nye saker',
        'Open Tickets / Need to be answered' => 'Åpne saker / Må besvares',
        'All open tickets, these tickets have already been worked on, but need a response' =>
            'Alle åpne saker som trenger arbeid, men som også trenger et svar',
        'All new tickets, these tickets have not been worked on yet' => 'Alle nye saker som ikke har blitt sett på enda.',
        'All escalated tickets' => 'Alle eskalerte saker',
        'All tickets with a reminder set where the reminder date has been reached' =>
            'Alle saker med påminnelse satt der påminnelsen har slått til',
        'Archived tickets' => 'Arkiverte saker',
        'Unarchived tickets' => 'Aktive saker',
        'History::Move' => 'Sak flyttet inn i køen «%s» (%s) fra kø «%s» (%s).',
        'History::TypeUpdate' => 'Endret type til %s (ID=%s).',
        'History::ServiceUpdate' => 'Endret tjeneste til «%s» (ID=%s).',
        'History::SLAUpdate' => 'Endret SLA til «%s» (ID=%s).',
        'History::NewTicket' => 'Ny sak [%s] opprettet (Q=%s;P=%s;S=%s).',
        'History::FollowUp' => 'Oppfølging til sak [%s]. %s',
        'History::SendAutoReject' => 'AutoReject sent to «%s».',
        'History::SendAutoReply' => 'AutoSvar sendt til «%s».',
        'History::SendAutoFollowUp' => 'AutoOppfølging sendt til «%s».',
        'History::Forward' => 'Videresendt til «%s».',
        'History::Bounce' => 'Avslått til «%s».',
        'History::SendAnswer' => 'E-post sendt til «%s».',
        'History::SendAgentNotification' => '«%s»-varsling sendt til «%s».',
        'History::SendCustomerNotification' => 'Varsling sendt til «%s».',
        'History::EmailAgent' => 'E-post sendt til saksbehandler.',
        'History::EmailCustomer' => 'Lagt e-post til sak. %s',
        'History::PhoneCallAgent' => 'Saksbehandler ringte kunde.',
        'History::PhoneCallCustomer' => 'Kunden ringte oss.',
        'History::AddNote' => 'Lagt til notis (%s)',
        'History::Lock' => 'Sak satt som privat.',
        'History::Unlock' => 'Sak gjort tilgjengelig.',
        'History::TimeAccounting' => '%s minutt(er) lagt til. Total tid er %s minutt(er).',
        'History::Remove' => '%s',
        'History::CustomerUpdate' => 'Oppdatert: %s',
        'History::PriorityUpdate' => 'Endret prioritet fra «%s» (%s) til «%s» (%s).',
        'History::OwnerUpdate' => 'Ny saksbehandler er «%s» (ID=%s).',
        'History::LoopProtection' => 'Loop-Protection! No auto-response sent to «%s».',
        'History::Misc' => '%s',
        'History::SetPendingTime' => 'Sett på vent til: %s',
        'History::StateUpdate' => 'Gammel: «%s» Ny: «%s»',
        'History::TicketDynamicFieldUpdate' => 'Stikkord oppdatert: %s=%s;%s=%s;',
        'History::WebRequestCustomer' => 'Kundeforespørsel via web.',
        'History::TicketLinkAdd' => 'La til link til sak «%s».',
        'History::TicketLinkDelete' => 'Slettet link til sak «%s».',
        'History::Subscribe' => 'La til abonnement for brukeren «%s».',
        'History::Unsubscribe' => 'Fjernet abonnement for brukeren «%s».',
        'History::SystemRequest' => 'Systemspørring (%s).',
        'History::ResponsibleUpdate' => 'Ny ansvarlig er «%s» (ID=%s).',
        'History::ArchiveFlagUpdate' => 'Ny arkiv statuser: «%s»',

        # Template: AAAWeekDay
        'Sun' => 'søn',
        'Mon' => 'man',
        'Tue' => 'tir',
        'Wed' => 'ons',
        'Thu' => 'tor',
        'Fri' => 'fre',
        'Sat' => 'lør',

        # Template: AdminAttachment
        'Attachment Management' => 'Administrasjon: Vedlegg',
        'Actions' => 'Handlinger',
        'Go to overview' => 'Gå til oversikt',
        'Add attachment' => 'Legg til vedlegg',
        'List' => 'Liste',
        'Validity' => 'Gyldighet',
        'No data found.' => 'Ingen data funnet.',
        'Download file' => 'Last ned fil',
        'Delete this attachment' => 'Slett dette vedlegget',
        'Add Attachment' => 'Legg til vedlegg',
        'Edit Attachment' => 'Endre vedlegg',
        'This field is required.' => 'Dette feltet er obligatorisk.',
        'or' => 'eller',

        # Template: AdminAutoResponse
        'Auto Response Management' => 'Administrasjon: Autosvar',
        'Add auto response' => 'Legg til autosvar',
        'Add Auto Response' => 'Legg Til Autosvar',
        'Edit Auto Response' => 'Endre Autosvar',
        'Response' => 'Svar',
        'Auto response from' => 'Autosvar fra',
        'Reference' => 'Referanse',
        'You can use the following tags' => 'Du kan bruke de følgende "tags"',
        'To get the first 20 character of the subject.' => 'For å hente de første 20 tegnene i overskriften.',
        'To get the first 5 lines of the email.' => 'For å hente de første 5 linjene i e-posten.',
        'To get the realname of the sender (if given).' => 'For å hente senderens virkelige navn (hvis oppgitt).',
        'To get the article attribute' => 'For å hente innlegg-attributtet',
        ' e. g.' => 'f.eks.',
        'Options of the current customer user data' => 'Valg for den nåværende brukerens brukerdata',
        'Ticket owner options' => 'Valg for sakens eier',
        'Ticket responsible options' => 'Valg for saksansvarlige',
        'Options of the current user who requested this action' => 'Valg for den nåværende brukeren som ba om denne handlingen',
        'Options of the ticket data' => 'Valg for sakens data',
        'Options of ticket dynamic fields internal key values' => '',
        'Options of ticket dynamic fields display values, useful for Dropdown and Multiselect fields' =>
            '',
        'Config options' => 'Valg for oppsett',
        'Example response' => 'Eksempel på svar',

        # Template: AdminCustomerCompany
        'Customer Company Management' => 'Administrasjon: Kundebedrifter',
        'Wildcards like \'*\' are allowed.' => 'Jokertegn som \'*\ er tillatt',
        'Add customer company' => 'Legg til kundebedrift',
        'Please enter a search term to look for customer companies.' => 'Skriv inn et søk for å lete etter kundebedrifter',
        'Add Customer Company' => 'Legg til kundebedrift',

        # Template: AdminCustomerUser
        'Customer Management' => 'Administrasjon: Kunder',
        'Back to search results' => 'Tilbake til søkeresultatet',
        'Add customer' => 'Legg til kunde',
        'Select' => 'Velg',
        'Hint' => 'Hint',
        'Customer will be needed to have a customer history and to login via customer panel.' =>
            'En kunde trengs for å ha kunde-historikk og for å kunne logge inn fra kundepanelet.',
        'Please enter a search term to look for customers.' => 'Vennligst skriv et søkekriterie for å lete etter kunder',
        'Last Login' => 'Siste innlogging',
        'Login as' => 'Logg inn som',
        'Switch to customer' => 'Bytt til kunde',
        'Add Customer' => 'Legg til kunde',
        'Edit Customer' => 'Endre kunde',
        'This field is required and needs to be a valid email address.' =>
            'Dette feltet er påkrevd og trenger å være en gyldig e-postadresse',
        'This email address is not allowed due to the system configuration.' =>
            'Denne e-postadressen er ikke tillatt i systemkonfigurasjonen',
        'This email address failed MX check.' => 'Denne e-postadressen feilet i en DNS-test (ingen MX)',
        'DNS problem, please check your configuration and the error log.' =>
            'Navntjener (DNS) problem, vennligst se på konfigurasjonen og i error loggen.',
        'The syntax of this email address is incorrect.' => 'Syntaksen på denne e-postadressen er feil.',

        # Template: AdminCustomerUserGroup
        'Manage Customer-Group Relations' => 'Administrere forhold mellom Kunde og Gruppe',
        'Notice' => 'Notis',
        'This feature is disabled!' => 'Denne funksjonen er deaktivert!',
        'Just use this feature if you want to define group permissions for customers.' =>
            'Bruk denne funksjonen kun dersom du vil definere grupperettigheter for kunder.',
        'Enable it here!' => 'Aktiver denne her!',
        'Search for customers.' => 'Søk etter kunde',
        'Edit Customer Default Groups' => 'Endre standardgrupper for kunder',
        'These groups are automatically assigned to all customers.' => 'Disse gruppene blir automatisk tildelt alle nye kunder',
        'You can manage these groups via the configuration setting "CustomerGroupAlwaysGroups".' =>
            'Du kan styre disse gruppene gjennom innstillingen "CustomerGroupAlwaysGroups"',
        'Filter for Groups' => 'Filter for Grupper',
        'Select the customer:group permissions.' => 'Velg rettigheter for kunde:gruppe',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the customer).' =>
            'Hvis ingenting blir valgt vil det ikke være noen rettigheter for denne gruppen (saker vil ikke være synlige for brukeren).',
        'Search Results' => 'Søkeresultat',
        'Customers' => 'Kunder',
        'Groups' => 'Grupper',
        'No matches found.' => 'Ingen treff funnet',
        'Change Group Relations for Customer' => 'Endre grupperettigheter for Kunde',
        'Change Customer Relations for Group' => 'Endre kundekoplinger for gruppe',
        'Toggle %s Permission for all' => 'Slå av/på %s-tilgang for alle',
        'Toggle %s permission for %s' => 'Slå av/på %s-tilgang for %s',
        'Customer Default Groups:' => 'Standardgrupper for kunder',
        'No changes can be made to these groups.' => 'Kan ikke endre disse gruppene.',
        'ro' => 'lesetilgang',
        'Read only access to the ticket in this group/queue.' => 'Kun lese-tilgang til saker i denne gruppen/køen.',
        'rw' => 'skrivetilgang',
        'Full read and write access to the tickets in this group/queue.' =>
            'Full lese- og skrive-tilgang til saker i denne gruppen/køen.',

        # Template: AdminCustomerUserService
        'Manage Customer-Services Relations' => 'Administrere forhold mellom Kunde og Tjeneste',
        'Edit default services' => 'Endre standardtjenester',
        'Filter for Services' => 'Filter for tjenester',
        'Allocate Services to Customer' => 'Legg Tjeneste til Kunde',
        'Allocate Customers to Service' => 'Legg Kunder til Tjeneste',
        'Toggle active state for all' => 'Slå av/på aktivisering for alle',
        'Active' => 'Aktiv',
        'Toggle active state for %s' => 'Slå av/på aktivisering for %s',

        # Template: AdminDynamicField
        'Dynamic Fields Management' => 'Administrasjon: Dynamiske felt',
        'Add new field for object' => 'Legg til nytt felt for et objekt',
        'To add a new field, select the field type form one of the object\'s list, the object defines the boundary of the field and it can\'t be changed after the field creation.' =>
            '',
        'Dynamic Fields List' => 'Liste over dynamiske felt',
        'Dynamic fields per page' => 'Dynamiske felt per side',
        'Label' => 'Etikett',
        'Order' => 'Sortering',
        'Object' => 'Objekt',
        'Delete this field' => 'Fjern dette feltet',
        'Do you really want to delete this dynamic field? ALL associated data will be LOST!' =>
            'Vil du virkelig fjerne dette dynamiske feltet? ALLE tilknyttede data vil bli BORTE!',
        'Delete field' => 'Fjern felt',

        # Template: AdminDynamicFieldCheckbox
        'Dynamic Fields' => 'Dynamiske felter',
        'Field' => 'Felt',
        'Go back to overview' => 'Gå tilbake til oversikten',
        'General' => 'Generelt',
        'This field is required, and the value should be alphabetic and numeric characters only.' =>
            'Dette feltet er påkrevd, og innholdet må bare være bokstaver og tall',
        'Must be unique and only accept alphabetic and numeric characters.' =>
            'Må være unikt og bare inneholde bokstaver og tall',
        'Changing this value will require manual changes in the system.' =>
            'Endring av denne verdien vil kreve manuelle endringer i systemet.',
        'This is the name to be shown on the screens where the field is active.' =>
            'Dette er navnet som vil bli vist på skjermen hvor feltet er aktivert',
        'Field order' => 'Feltrekkefølge',
        'This field is required and must be numeric.' => 'Dette feltet er påkrevd og må inneholde tall',
        'This is the order in which this field will be shown on the screens where is active.' =>
            'Dette er rekkefølgen som vises på feltene på skjermen hvor de er aktive',
        'Field type' => 'Felt type',
        'Object type' => 'Objekt type',
        'Internal field' => '',
        'This field is protected and can\'t be deleted.' => '',
        'Field Settings' => 'Felt Innstillinger',
        'Default value' => 'Standardverdi',
        'This is the default value for this field.' => 'Dette er standardverdien for dette feltet',
        'Save' => 'Lagre',

        # Template: AdminDynamicFieldDateTime
        'Default date difference' => 'Standard dato forskjeller',
        'This field must be numeric.' => 'Dette feltet må inneholde tall',
        'The difference from NOW (in seconds) to calculate the field default value (e.g. 3600 or -60).' =>
            '',
        'Define years period' => '',
        'Activate this feature to define a fixed range of years (in the future and in the past) to be displayed on the year part of the field.' =>
            '',
        'Years in the past' => '',
        'Years in the past to display (default: 5 years).' => '',
        'Years in the future' => '',
        'Years in the future to display (default: 5 years).' => '',
        'Show link' => 'Vis lenke',
        'Here you can specify an optional HTTP link for the field value in Overviews and Zoom screens.' =>
            '',

        # Template: AdminDynamicFieldDropdown
        'Possible values' => 'Tilgjengelige verdier',
        'Key' => 'Nøkkel',
        'Value' => 'Innhold',
        'Remove value' => 'Fjern verdi',
        'Add value' => 'Legg til verdi',
        'Add Value' => 'Legg til verdi',
        'Add empty value' => 'Legg til tom verdi',
        'Activate this option to create an empty selectable value.' => 'Aktiver dette valget for å lage tomme valgbare verdier',
        'Translatable values' => 'Oversettbare verdier',
        'If you activate this option the values will be translated to the user defined language.' =>
            'Om du aktiverer dette valget vil verdiene bli oversatt til det bruker har definert som språk',
        'Note' => 'Notis',
        'You need to add the translations manually into the language translation files.' =>
            'Du må legge til oversettelsen manuelt i språk filen',

        # Template: AdminDynamicFieldMultiselect

        # Template: AdminDynamicFieldText
        'Number of rows' => 'Antall rader',
        'Specify the height (in lines) for this field in the edit mode.' =>
            'Spesifiser høyden (i antall linjer) for dette feltet i endrings-modus',
        'Number of cols' => 'Antall kolonner',
        'Specify the width (in characters) for this field in the edit mode.' =>
            'Spesifiser bredden (i antall tegn) for dette feltet i endrings-modus',

        # Template: AdminEmail
        'Admin Notification' => 'Administratorvarsling',
        'With this module, administrators can send messages to agents, group or role members.' =>
            'Med denne modulen kan administratorer sende meldinger til saksbehandlere, gruppe- eller rolle-medlemmer',
        'Create Administrative Message' => 'Lag Administrativ melding',
        'Your message was sent to' => 'Meldingen ble sendt til',
        'Send message to users' => 'Send melding til brukere',
        'Send message to group members' => 'Send melding til gruppemedlemmer',
        'Group members need to have permission' => 'Gruppemedlemmer må ha tilgang',
        'Send message to role members' => 'Send melding til medlemmer av rolle',
        'Also send to customers in groups' => 'Send også til kunder i grupper',
        'Body' => 'Meldingstekst',
        'Send' => 'Send',

        # Template: AdminGenericAgent
        'Generic Agent' => 'Generisk agent',
        'Add job' => 'Legg til jobb',
        'Last run' => 'Sist kjørt',
        'Run Now!' => 'Kjør nå!',
        'Delete this task' => 'Slett denne oppgaven',
        'Run this task' => 'Kjør denne oppgaven',
        'Job Settings' => 'Innstillinger for jobb',
        'Job name' => 'Navn',
        'Currently this generic agent job will not run automatically.' =>
            'Føreløpig vil ikke denne generiske agentjobben kjøres automatisk.',
        'To enable automatic execution select at least one value from minutes, hours and days!' =>
            'For å skru på automatisk utførelse velg minst en verdi i form av minutter, timer og dager!',
        'Schedule minutes' => 'Minutter',
        'Schedule hours' => 'Timer',
        'Schedule days' => 'Dager',
        'Toggle this widget' => 'Slå av/på denne modulen',
        'Ticket Filter' => 'Saksfilter',
        '(e. g. 10*5155 or 105658*)' => 'f.eks. 10*5144 eller 105658*',
        '(e. g. 234321)' => 'f.eks. 234321',
        'Customer login' => 'Kundeinnlogging',
        '(e. g. U5150)' => 'f.eks. U5150',
        'Fulltext-search in article (e. g. "Mar*in" or "Baue*").' => 'Fulltekst-søk i innlegg (f.eks. "Mar*in" eller "Baue*").',
        'Agent' => 'Saksbehandler',
        'Ticket lock' => 'Sakslås',
        'Create times' => 'Opprettelsestidspunkt',
        'No create time settings.' => 'Ingen opprettelsestidspunkt innstillinger.',
        'Ticket created' => 'Sak opprettet',
        'Ticket created between' => 'Sak opprettet mellom',
        'Change times' => 'Bytt tider',
        'No change time settings.' => 'Ingen endringstidspunkt innstillinger',
        'Ticket changed' => 'Sak endret',
        'Ticket changed between' => 'Sak endret mellom',
        'Close times' => 'Stengningstidspunkt',
        'No close time settings.' => 'Ingen stengetid-innstilling',
        'Ticket closed' => 'Sak låst',
        'Ticket closed between' => 'Sak låst mellom',
        'Pending times' => 'Ventetider',
        'No pending time settings.' => 'Ingen innstillinger for ventetid.',
        'Ticket pending time reached' => 'Ventetiden er nådd',
        'Ticket pending time reached between' => 'Ventetiden er nådd mellom',
        'Escalation times' => 'Eskaleringstid',
        'No escalation time settings.' => 'Ingen eskaleringsinnstillinger',
        'Ticket escalation time reached' => 'Sakens eskaleringstid nådd',
        'Ticket escalation time reached between' => 'Sakens eskaleringstid nådd mellom',
        'Escalation - first response time' => 'Eskalering - første responstid',
        'Ticket first response time reached' => 'Sakens første responstid nådd',
        'Ticket first response time reached between' => 'Sakens første responstid nådd mellom',
        'Escalation - update time' => 'Eskalering - oppdateringtidspunkt',
        'Ticket update time reached' => 'Sakens oppdateringtidspunkt nådd',
        'Ticket update time reached between' => 'Sakens oppdateringstid nådd mellom',
        'Escalation - solution time' => 'Eskalering - løsnings-tid',
        'Ticket solution time reached' => 'Sakens løsnings-tid nådd',
        'Ticket solution time reached between' => 'Sakens løsnings-tid nådd mellom',
        'Archive search option' => 'Valg for arkivert søk',
        'Ticket Action' => 'Handling for saken',
        'Set new service' => 'Sett ny tjeneste',
        'Set new Service Level Agreement' => 'Sett ny Tjenestenivåavtale',
        'Set new priority' => 'Sett ny prioritet',
        'Set new queue' => 'Sett ny kø',
        'Set new state' => 'Sett ny status',
        'Set new agent' => 'Sett ny saksbehandler',
        'new owner' => 'ny eier',
        'new responsible' => 'ny ansvarlig',
        'Set new ticket lock' => 'Sett ny sakslås',
        'New customer' => 'Ny kunde',
        'New customer ID' => 'Ny Kunde-ID',
        'New title' => 'Nytt emne',
        'New type' => 'Ny type',
        'New Dynamic Field Values' => 'Nye Dynamiske Felt verdier',
        'Archive selected tickets' => 'Arkiver valgte saker',
        'Add Note' => 'Legg til notis',
        'Time units' => 'Tidsenheter',
        '(work units)' => '(arbeidsenheter)',
        'Ticket Commands' => 'Sakskommandoer',
        'Send agent/customer notifications on changes' => 'Send en saksbehandler-/kunde-varsling ved endringer',
        'CMD' => 'Kommando',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' =>
            'Denne kommandoen vil bli kjørt. ARG[0] vil være saksnummer. ARG[1] saks-id.',
        'Delete tickets' => 'Slett saker',
        'Warning: All affected tickets will be removed from the database and cannot be restored!' =>
            'ADVARSEL: Alle saker som blir funnet av denne jobben vil bli slettet og kan ikke gjenopprettes!',
        'Execute Custom Module' => 'Kjør tilpasset modul',
        'Param %s key' => 'Nøkkel for Parameter %s',
        'Param %s value' => 'Verdi for Parameter %s',
        'Save Changes' => 'Lagre endringer',
        'Results' => 'Resultat',
        '%s Tickets affected! What do you want to do?' => '%s saker blir påvirket! Hva vil du gjøre?',
        'Warning: You used the DELETE option. All deleted tickets will be lost!' =>
            'ADVARSEL: Du brukte SLETTE-valget. Alle saker som slettes blir borte for godt!',
        'Edit job' => 'Endre jobb',
        'Run job' => 'Kjør jobb',
        'Affected Tickets' => 'Antall saker påvirket',

        # Template: AdminGenericInterfaceDebugger
        'GenericInterface Debugger for Web Service %s' => '',
        'Web Services' => 'Webtjenester',
        'Debugger' => 'Feilsøker',
        'Go back to web service' => 'Gå tilbake til web tjeneste',
        'Clear' => 'Tøm',
        'Do you really want to clear the debug log of this web service?' =>
            'Vil du virkelig tømme feilsøkerloggen for denne web tjenesten?',
        'Request List' => '',
        'Time' => 'Tid',
        'Remote IP' => 'Fjernstyrt IP',
        'Loading' => 'Laster',
        'Select a single request to see its details.' => '',
        'Filter by type' => '',
        'Filter from' => '',
        'Filter to' => '',
        'Filter by remote IP' => '',
        'Refresh' => 'Oppdater',
        'Request Details' => '',
        'An error occurred during communication.' => 'En feil oppstod under kommunikasjonen',
        'Show or hide the content' => 'Vis eller skjul innholdet',
        'Clear debug log' => 'Tøm feilsøker loggen',

        # Template: AdminGenericInterfaceInvokerDefault
        'Add new Invoker to Web Service %s' => 'Legg til ny Anroper til Web Tjenesten %s',
        'Change Invoker %s of Web Service %s' => 'Bytt Anroper %s for Web Tjeneste %s',
        'Add new invoker' => 'Legg til ny anroper',
        'Change invoker %s' => 'Bytt anroper %s',
        'Do you really want to delete this invoker?' => 'Vil du virkelig fjerne denne anroperen?',
        'All configuration data will be lost.' => 'Alle konfigurasjons-data vil gå tapt.',
        'Invoker Details' => 'Detaljerte Anrop',
        'The name is typically used to call up an operation of a remote web service.' =>
            'Navnet er typisk brukt for å kalle opp en handling på en fjernstyrt web tjeneste.',
        'Please provide a unique name for this web service invoker.' => 'Vennligst oppgi et unikt navn på denne web tjeneste anroperen.',
        'The name you entered already exists.' => 'Navnet du oppga finnes allerede',
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
        'Event Triggers' => 'Hendelse utløser',
        'Asynchronous' => 'Asynkron',
        'Delete this event' => 'Fjern denne hendelsen',
        'This invoker will be triggered by the configured events.' => '',
        'Do you really want to delete this event trigger?' => '',
        'Add Event Trigger' => 'Legg til hendelse utløser',
        'To add a new event select the event object and event name and click on the "+" button' =>
            '',
        'Asynchronous event triggers are handled by the OTRS Scheduler in background (recommended).' =>
            '',
        'Synchronous event triggers would be processed directly during the web request.' =>
            '',
        'Save and continue' => 'Lagre og fortsett',
        'Save and finish' => 'Lagre og fullfør',
        'Delete this Invoker' => 'Fjern denne Anroperen',
        'Delete this Event Trigger' => 'Fjern denne Hendelses Utløseren',

        # Template: AdminGenericInterfaceMappingSimple
        'GenericInterface Mapping Simple for Web Service %s' => '',
        'Go back to' => 'Gå tilbake til',
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
        'to new key' => 'til ny nøkkel',
        'Value mapping' => '',
        'Map value' => '',
        'to new value' => 'til ny verdi',
        'Remove value mapping' => '',
        'New value map' => '',
        'Add value mapping' => '',
        'Do you really want to delete this key mapping?' => '',
        'Delete this Key Mapping' => '',

        # Template: AdminGenericInterfaceOperationDefault
        'Add new Operation to Web Service %s' => 'Legg til ny handling til web tjenesten %s',
        'Change Operation %s of Web Service %s' => 'Endre handling %s på web tjeneste %s',
        'Add new operation' => 'Legg til ny handling',
        'Change operation %s' => 'Bytt handling %s',
        'Do you really want to delete this operation?' => 'Vil du virkelig slette denne handlingen?',
        'Operation Details' => 'Detaljerte handlinger',
        'The name is typically used to call up this web service operation from a remote system.' =>
            '',
        'Please provide a unique name for this web service.' => 'Vennligst velg et unikt navn for denne web tjenesten',
        'Mapping for incoming request data' => '',
        'The request data will be processed by this mapping, to transform it to the kind of data OTRS expects.' =>
            '',
        'Operation backend' => '',
        'This OTRS operation backend module will be called internally to process the request, generating data for the response.' =>
            '',
        'Mapping for outgoing response data' => '',
        'The response data will be processed by this mapping, to transform it to the kind of data the remote system expects.' =>
            '',
        'Delete this Operation' => 'Fjern denne handlingen',

        # Template: AdminGenericInterfaceTransportHTTPSOAP
        'GenericInterface Transport HTTP::SOAP for Web Service %s' => '',
        'Network transport' => 'Nettverkstransport',
        'Properties' => 'Egenskaper',
        'Endpoint' => 'Sluttpunkt',
        'URI to indicate a specific location for accessing a service.' =>
            '',
        'e.g. http://local.otrs.com:8000/Webservice/Example' => 'f.eks. http://local.otrs.com:8000/Webservice/Example',
        'Namespace' => 'Navneområde',
        'URI to give SOAP methods a context, reducing ambiguities.' => '',
        'e.g urn:otrs-com:soap:functions or http://www.otrs.com/GenericInterface/actions' =>
            '',
        'Maximum message length' => 'Maksimal lengde på melding',
        'This field should be an integer number.' => 'Dette feltet inneholde et heltall',
        'Here you can specify the maximum size (in bytes) of SOAP messages that OTRS will process.' =>
            '',
        'Encoding' => 'Kodifisering',
        'The character encoding for the SOAP message contents.' => '',
        'e.g utf-8, latin1, iso-8859-1, cp1250, Etc.' => 'f.eks. utf-8, latin1, iso-8859-1, cp1250, etc.',
        'SOAPAction' => '',
        'Set to "Yes" to send a filled SOAPAction header.' => '',
        'Set to "No" to send an empty SOAPAction header.' => '',
        'SOAPAction separator' => '',
        'Character to use as separator between name space and SOAP method.' =>
            '',
        'Usually .Net web services uses a "/" as separator.' => '',
        'Authentication' => 'Autentisering',
        'The authentication mechanism to access the remote system.' => '',
        'A "-" value means no authentication.' => '',
        'The user name to be used to access the remote system.' => 'Brukernavnet til bruk for å få tilgang til det fjernstyrte systemet.',
        'The password for the privileged user.' => 'Passordet for den priviligerte brukeren.',
        'Use SSL Options' => '',
        'Show or hide SSL options to connect to the remote system.' => '',
        'Certificate File' => 'Sertifikat fil',
        'The full path and name of the SSL certificate file (must be in .p12 format).' =>
            'Full adresse og navn på SSL sertifikat filen (må være i .p12 format).',
        'e.g. /opt/otrs/var/certificates/SOAP/certificate.p12' => '',
        'Certificate Password File' => '',
        'The password to open the SSL certificate.' => '',
        'Certification Authority (CA) File' => '',
        'The full path and name of the certification authority certificate file that validates SSL certificate.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA/ca.pem' => 'f.eks. /opt/otrs/var/certificates/SOAP/CA/ca.pem',
        'Certification Authority (CA) Directory' => '',
        'The full path of the certification authority directory where the CA certificates are stored in the file system.' =>
            '',
        'e.g. /opt/otrs/var/certificates/SOAP/CA' => '',
        'Proxy Server' => 'Proxy server',
        'URI of a proxy server to be used (if needed).' => '',
        'e.g. http://proxy_hostname:8080' => 'f.eks. http://proxy_hostname:8080',
        'Proxy User' => 'Proxy bruker',
        'The user name to be used to access the proxy server.' => '',
        'Proxy Password' => 'Proxy passord',
        'The password for the proxy user.' => 'Passordet for proxybrukeren.',

        # Template: AdminGenericInterfaceWebservice
        'GenericInterface Web Service Management' => 'Administrasjon: Generiske webtjenester',
        'Add web service' => 'Legg til webtjeneste',
        'Clone web service' => 'Dupliser webtjeneste',
        'The name must be unique.' => 'Dette navnet må være unikt',
        'Clone' => 'Duplisere',
        'Export web service' => 'Eksporter webtjenesten',
        'Import web service' => 'Importer webtjeneste',
        'Configuration File' => 'Konfigurasjons-fil',
        'The file must be a valid web service configuration YAML file.' =>
            'Filen må være en godkjent YAML web tjeneste konfigurasjons-fil',
        'Import' => 'Importer',
        'Configuration history' => 'Konfigurasjonshistorikk',
        'Delete web service' => 'Fjern webtjeneste',
        'Do you really want to delete this web service?' => 'Vil du virkelig fjerne denne webtjenesten?',
        'After you save the configuration you will be redirected again to the edit screen.' =>
            '',
        'If you want to return to overview please click the "Go to overview" button.' =>
            '',
        'Web Service List' => 'Liste over webtjenester',
        'Remote system' => '',
        'Provider transport' => '',
        'Requester transport' => '',
        'Details' => 'Detaljer',
        'Debug threshold' => 'Feilsøkergrense',
        'In provider mode, OTRS offers web services which are used by remote systems.' =>
            '',
        'In requester mode, OTRS uses web services of remote systems.' =>
            '',
        'Operations are individual system functions which remote systems can request.' =>
            '',
        'Invokers prepare data for a request to a remote web service, and process its response data.' =>
            '',
        'Controller' => 'Kontrollerer',
        'Inbound mapping' => '',
        'Outbound mapping' => '',
        'Delete this action' => 'Fjern denne handlingen',
        'At least one %s has a controller that is either not active or not present, please check the controller registration or delete the %s' =>
            '',
        'Delete webservice' => 'Fjern webtjenesten',
        'Delete operation' => 'Fjern handlingen',
        'Delete invoker' => '',
        'Clone webservice' => 'Dupliser webtjenesten',
        'Import webservice' => 'Importer webtjeneste',

        # Template: AdminGenericInterfaceWebserviceHistory
        'GenericInterface Configuration History for Web Service %s' => '',
        'Go back to Web Service' => 'Gå tilbake til Web Tjenester',
        'Here you can view older versions of the current web service\'s configuration, export or even restore them.' =>
            'Her kan du se eldre versjoner av gjeldende web tjeneste konfigurasjon, eksportere og gjenopprette dem',
        'Configuration History List' => 'Konfigurasjons-historikk',
        'Version' => 'Versjon',
        'Create time' => 'Opprettelses tid',
        'Select a single configuration version to see its details.' => 'Velg en konfigurasjons-versjon for å se dens detaljer',
        'Export web service configuration' => 'Eksporter konfigurasjonenn for web tjenesten',
        'Restore web service configuration' => 'Gjenopprett web tjeneste konfigurasjonen',
        'Do you really want to restore this version of the web service configuration?' =>
            '',
        'Your current web service configuration will be overwritten.' => '',
        'Show or hide the content.' => 'Vis eller skjul innhold.',
        'Restore' => 'Gjenopprette',

        # Template: AdminGroup
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' =>
            'ADVARSEL: Om du endrer navnet til gruppen \'admin\' før du gjør de nødvendige endringer i SysConfig, vil du bli utestengt fra administrator panelet! Om dette skjer, vennligst endre navnet på gruppen tilbake til admin via SQL statement.',
        'Group Management' => 'Administrasjon: Grupper',
        'Add group' => 'Legg til gruppe',
        'The admin group is to get in the admin area and the stats group to get stats area.' =>
            '\'admin\'-gruppen gir tilgang til Admin-området, \'stats\'-gruppen til Statistikk-området.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...). ' =>
            'Opprett grupper for å håndtere tilgangsrettigheter for forskjellige grupperinger av saksbehandlinger (f.eks. salgsavdelingen, service, innkjøp, osv.)',
        'It\'s useful for ASP solutions. ' => 'Det er nyttig for ASP-løsninger',
        'Add Group' => 'Legg til gruppe',
        'Edit Group' => 'Endre gruppe',

        # Template: AdminLog
        'System Log' => 'Systemlogg',
        'Here you will find log information about your system.' => 'Her finner du logg-informasjon fra systemet ditt',
        'Hide this message' => 'Skjul denne meldingen',
        'Recent Log Entries' => 'Siste Loggmeldinger',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Administrasjon: E-postkontoer',
        'Add mail account' => 'Legg til e-postkonto',
        'All incoming emails with one account will be dispatched in the selected queue!' =>
            'Innkommende e-poster fra POP3-kontoer blir sortert til valgt kø!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' =>
            'Dersom kontoen er betrodd vil de eksisterende X-OTRS hodene ved ankomst (for proritet...) bli brukt. PostMaster filtre vil bli brukt uansett.',
        'Host' => 'Tjener',
        'Delete account' => 'Slett konto',
        'Fetch mail' => 'Hent e-post',
        'Add Mail Account' => 'Legg til e-postkonto',
        'Example: mail.example.com' => 'F.eks.: mail.eksempel.com',
        'IMAP Folder' => 'IMAP mappe',
        'Only modify this if you need to fetch mail from a different folder than INBOX.' =>
            'Endre denne om du må hente e-post fra en annen mappe en INBOX',
        'Trusted' => 'Betrodd',
        'Dispatching' => 'Fordeling',
        'Edit Mail Account' => 'Rediger e-postkonto',

        # Template: AdminNavigationBar
        'Admin' => 'Administrator',
        'Agent Management' => 'Saksbehandlere',
        'Queue Settings' => 'Oppsett av køer',
        'Ticket Settings' => 'Oppsett av saker',
        'System Administration' => 'Systemadministrasjon',

        # Template: AdminNotification
        'Notification Management' => 'Administrasjon: Varslinger',
        'Select a different language' => 'Velg et annet språk',
        'Filter for Notification' => 'Filter for varsling',
        'Notifications are sent to an agent or a customer.' => 'Varslinger som sendes til saksbehandlere eller kunder.',
        'Notification' => 'Varsling',
        'Edit Notification' => 'Endre varsling',
        'e. g.' => 'f.eks.',
        'Options of the current customer data' => 'Valg for nåværende kundedata',

        # Template: AdminNotificationEvent
        'Add notification' => 'Legg til varsling',
        'Delete this notification' => 'Slett denne varslingen',
        'Add Notification' => 'Legg til varsling',
        'Recipient groups' => 'Mottakere - grupper',
        'Recipient agents' => 'Mottakere - saksbehandlere',
        'Recipient roles' => 'Mottakere - roller',
        'Recipient email addresses' => 'Mottakeres e-postadresser',
        'Article type' => 'Innleggstype',
        'Only for ArticleCreate event' => 'Kun for oppretting av innlegg',
        'Article sender type' => '',
        'Subject match' => 'Emnetreff',
        'Body match' => 'Meldingstreff',
        'Include attachments to notification' => 'Bruk vedlegg i varslingen',
        'Notification article type' => 'Artikkeltype for varsling',
        'Only for notifications to specified email addresses' => 'Kun for varsling til spesifiserte e-postadresser',
        'To get the first 20 character of the subject (of the latest agent article).' =>
            'For å få de første 20 tegn av emnefeltet (fra den siste agentsaken).',
        'To get the first 5 lines of the body (of the latest agent article).' =>
            'For å få de første 5 linjene av meldingen (fra den siste agentsaken).',
        'To get the first 20 character of the subject (of the latest customer article).' =>
            'For å få de første 20 tegn av emnefeltet (fra den siste kundesaken).',
        'To get the first 5 lines of the body (of the latest customer article).' =>
            'For å få de første 5 linjene av meldingen (fra den siste kundesaken).',

        # Template: AdminPGP
        'PGP Management' => 'Administrasjon: PGP',
        'Use this feature if you want to work with PGP keys.' => 'Bruk denne funksjonen hvis du vil jobbe med PGP-nøkler',
        'Add PGP key' => 'Legg til PGP-nøkkel',
        'In this way you can directly edit the keyring configured in SysConfig.' =>
            'På denne måten kan du direkte redigere nøkkelringen som er konfigurert i SysConfig',
        'Introduction to PGP' => 'Introduksjon til PGP',
        'Result' => 'Resultat',
        'Identifier' => 'Nøkkel',
        'Bit' => 'Bit',
        'Fingerprint' => 'Fingeravtrykk',
        'Expires' => 'Utgår',
        'Delete this key' => 'Slett denne nøkkelen',
        'Add PGP Key' => 'Legg Til PGP-nøkkel',
        'PGP key' => 'PGP-nøkkel',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakkehåndterer',
        'Uninstall package' => 'Avinstaller pakke',
        'Do you really want to uninstall this package?' => 'Vil du virkelig avinstallere denne pakken?',
        'Reinstall package' => 're-installer pakken',
        'Do you really want to reinstall this package? Any manual changes will be lost.' =>
            'Vil du virkelig re-installere pakken? Alle manuelle endringer vil bli borte.',
        'Continue' => 'Fortsett',
        'Install' => 'Installer',
        'Install Package' => 'Installer pakke',
        'Update repository information' => 'Oppdater pakkelager-informasjon',
        'Did not find a required feature? OTRS Group provides their service contract customers with exclusive Add-Ons:' =>
            '',
        'Online Repository' => 'Pakkelager på nettet',
        'Vendor' => 'Forhandler',
        'Module documentation' => 'Modul-dokumentasjon',
        'Upgrade' => 'Oppgrader',
        'Local Repository' => 'Lokalt pakkelager',
        'Uninstall' => 'Avinstaller',
        'Reinstall' => 're-installer',
        'Feature Add-Ons' => 'Tilleggstjenester',
        'Download package' => 'Last ned pakke',
        'Rebuild package' => 'Gjenoppbygg pakke',
        'Metadata' => 'Metadata',
        'Change Log' => 'Endrings-logg',
        'Date' => 'Dato',
        'List of Files' => 'Fil-liste',
        'Permission' => 'Rettigheter',
        'Download' => 'Last ned',
        'Download file from package!' => 'Last ned fil fra pakke!',
        'Required' => 'Påkrevd',
        'PrimaryKey' => 'Primærnøkkel',
        'AutoIncrement' => 'Auto-inkrementer',
        'SQL' => 'SQL',
        'File differences for file %s' => 'Forskjeller for filen %s',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Ytelseslogg',
        'This feature is enabled!' => 'Denne funksjonen er aktivert!',
        'Just use this feature if you want to log each request.' => 'Bruk denne funksjonen kun dersom du vil logge hver forespørsel.',
        'Activating this feature might affect your system performance!' =>
            'Aktivering av denne funksjonen kan påvirke system-ytelsen!',
        'Disable it here!' => 'Deaktiver denne her!',
        'Logfile too large!' => 'Loggfilen er for stor!',
        'The logfile is too large, you need to reset it' => 'Loggfilen er for stor, du må nullstille den',
        'Overview' => 'Oversikt',
        'Range' => 'Rekkevidde',
        'Interface' => 'Grensesnitt',
        'Requests' => 'Forespørsler',
        'Min Response' => 'Min Respons',
        'Max Response' => 'Max Respons',
        'Average Response' => 'Gjennomsnittlig Respons',
        'Period' => 'Periode',
        'Min' => 'Min',
        'Max' => 'Maks',
        'Average' => 'Gjennomsnitt',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'Administrasjon: E-postfilter',
        'Add filter' => 'Legg til filter',
        'To dispatch or filter incoming emails based on email headers. Matching using Regular Expressions is also possible.' =>
            'For å behandle eller filtrere innkommende e-poster basert på e-posthoder. Regulære uttrykk kan også brukes.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' =>
            'Dersom du ønsker å kun treffe e-postadresser, benytt EMAILADDRESS:info@example.com i Fra, Til eller Kopi.',
        'If you use Regular Expressions, you also can use the matched value in () as [***] in the \'Set\' action.' =>
            'Hvis du bruker "Regular Expressions" kan du også bruke verdien i () som [***] i "Sett"-verdier.',
        'Delete this filter' => 'Slett dette filteret',
        'Add PostMaster Filter' => 'Legg til Postmaster-filter',
        'Edit PostMaster Filter' => 'Endre Postmaster-filter',
        'Filter name' => 'Filterets navn',
        'The name is required.' => 'Navn er påkrevd',
        'Stop after match' => 'Stopp ved treff',
        'Filter Condition' => 'Filter-tilstand',
        'The field needs to be a valid regular expression or a literal word.' =>
            '',
        'Set Email Headers' => 'Sett meldingshoder',
        'The field needs to be a literal word.' => 'Feltet må inneholde et ord bestående av bokstaver',

        # Template: AdminPriority
        'Priority Management' => 'Administrasjon: Prioriteter',
        'Add priority' => 'Ny prioritering',
        'Add Priority' => 'Ny Prioritering',
        'Edit Priority' => 'Endre Prioritering',

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
        'Copy' => '',
        'Print' => 'Utskrift',
        'Export Process Configuration' => '',
        'Copy Process' => '',

        # Template: AdminProcessManagementActivity
        'Cancel & close window' => 'Avbryt og lukk vindu',
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
        'Activities' => 'Aktiviteter',
        'Filter Activities...' => 'Filtrer aktiviteter...',
        'Create New Activity' => 'Opprett ny aktivitet',
        'Filter Activity Dialogs...' => '',
        'Transitions' => '',
        'Filter Transitions...' => '',
        'Create New Transition' => '',
        'Filter Transition Actions...' => '',

        # Template: AdminProcessManagementProcessEdit
        'Edit Process' => 'Endre prosess',
        'Print process information' => '',
        'Delete Process' => 'Slett prosess',
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
        'Manage Queues' => 'Kø-administrasjon',
        'Add queue' => 'Ny kø',
        'Add Queue' => 'Legg til kø',
        'Edit Queue' => 'Endre kø',
        'Sub-queue of' => 'Under-kø av',
        'Unlock timeout' => 'Tidsintervall for å sette sak tilgjengelig for andre',
        '0 = no unlock' => '0 = ikke gjør saker tilgjengelig',
        'Only business hours are counted.' => 'Kun timene i åpningstiden telles',
        'If an agent locks a ticket and does not close it before the unlock timeout has passed, the ticket will unlock and will become available for other agents.' =>
            'Hvis en agent låser en sak og ikke stenger den før låsetiden har passert vil saken bli låst opp og komme tilgjengelig for andre saksbehandlere.',
        'Notify by' => 'Varsle ved',
        '0 = no escalation' => '0 = ingen eskalering',
        'If there is not added a customer contact, either email-external or phone, to a new ticket before the time defined here expires, the ticket is escalated.' =>
            'Hvis det ikke legges til en kundekontakt, enten e-post eller telefon, til en sak innen tiden definert her vil den bli eskalert.',
        'If there is an article added, such as a follow-up via email or the customer portal, the escalation update time is reset. If there is no customer contact, either email-external or phone, added to a ticket before the time defined here expires, the ticket is escalated.' =>
            'Hvis det kommer inn et objekt, f.eks. en oppfølging på e-post eller fra kundeportalen, vil eskaleringstiden bli nullstilt. Hvis ingen kundekontakt blir lagt til, enten som utgående e-post eller utgående telefon, innen tiden som er spesifisert her, vil saken bli eskalert.',
        'If the ticket is not set to closed before the time defined here expires, the ticket is escalated.' =>
            'Hvis saken ikke blir stengt innen tiden spesifisert her utløper vil den bli eskalert.',
        'Follow up Option' => 'Korrespondanse på avsluttet sak',
        'Specifies if follow up to closed tickets would re-open the ticket, be rejected or lead to a new ticket.' =>
            'Forteller om oppfølginger på stengte saker skal gjenåpne saken, avvises eller føre til en ny sak.',
        'Ticket lock after a follow up' => 'Saken settes som privat etter oppfølgnings e-post',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked to the old owner.' =>
            'Hvis en sak blir stengt og kunden sender en oppfølging vil saken bli låst til den forrige eieren.',
        'System address' => 'Systemadresse',
        'Will be the sender address of this queue for email answers.' => 'Avsenderadresse for e-post i denne køen.',
        'Default sign key' => 'Standard signeringsnøkkel',
        'The salutation for email answers.' => 'Hilsning for e-postsvar.',
        'The signature for email answers.' => 'Signatur for e-postsvar.',

        # Template: AdminQueueAutoResponse
        'Manage Queue-Auto Response Relations' => 'Administrasjon av Autosvar for Køer',
        'Filter for Queues' => 'Filter for køer',
        'Filter for Auto Responses' => 'Filter for Autosvar',
        'Auto Responses' => 'Autosvar',
        'Change Auto Response Relations for Queue' => 'Endre Autosvar-kopling for Kø',
        'settings' => 'innstillinger',

        # Template: AdminQueueResponses
        'Manage Response-Queue Relations' => 'Administrasjon av Ferdigsvar for Køer',
        'Filter for Responses' => 'Filter for Ferdigsvar',
        'Responses' => 'Ferdigsvar',
        'Change Queue Relations for Response' => 'Endre koplinger mellom ferdigsvaret og køer.',
        'Change Response Relations for Queue' => 'Endre koplinger mellom køen og ferdigsvar.',

        # Template: AdminResponse
        'Manage Responses' => 'Administrering av Ferdigsvar',
        'Add response' => 'Nytt ferdigsvar',
        'A response is a default text which helps your agents to write faster answers to customers.' =>
            'Et ferdigsvar er en standard tekst som hjelper saksbehandlere til å skrive raskere tilbakemeldinger til kunder',
        'Don\'t forget to add new responses to queues.' => 'Ikke glem å legg til nye ferdigsvar på køer',
        'Delete this entry' => 'Slett denne posten',
        'Add Response' => 'Legg til Ferdigsvar',
        'Edit Response' => 'Endre Ferdigsvar',
        'The current ticket state is' => 'Nåværende status på sak',
        'Your email address is' => 'Din e-postadresse er',

        # Template: AdminResponseAttachment
        'Manage Responses <-> Attachments Relations' => 'Administrasjon av vedlegg til Ferdigsvar',
        'Filter for Attachments' => 'Filter for vedlegg',
        'Change Response Relations for Attachment' => 'Endre koplinger mellom vedlegg og ferdigsvar',
        'Change Attachment Relations for Response' => 'Endre koplinger mellom ferdigsvaret og vedlegg',
        'Toggle active for all' => 'Aktiver/Deaktiver alle',
        'Link %s to selected %s' => 'Koble %s til valgt %s',

        # Template: AdminRole
        'Role Management' => 'Administrasjon: Roller',
        'Add role' => 'Ny rolle',
        'Create a role and put groups in it. Then add the role to the users.' =>
            'Opprett en rolle og legg grupper til rollen. Legg deretter til saksbehandlere til rollen.',
        'There are no roles defined. Please use the \'Add\' button to create a new role.' =>
            'Ingen roller er definerte. Vennligst bruk "Ny rolle" for å opprett en.',
        'Add Role' => 'Ny Rolle',
        'Edit Role' => 'Endre Rolle',

        # Template: AdminRoleGroup
        'Manage Role-Group Relations' => 'Koplinger mellom Rolle og Gruppe',
        'Filter for Roles' => 'Filter for Roller',
        'Roles' => 'Roller',
        'Select the role:group permissions.' => 'Velg rolle:gruppe-rettigheter',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the role).' =>
            'Hvis ingenting blir valgt vil det ikke være noen tilgang til gruppen (rollen vil ikke se saker for gruppen)',
        'Change Role Relations for Group' => 'Endre gruppens koplinger til roller',
        'Change Group Relations for Role' => 'Endre rollens koplinger til grupper',
        'Toggle %s permission for all' => 'Slå av/på tilgang for alle',
        'move_into' => 'Flytt til',
        'Permissions to move tickets into this group/queue.' => 'Rettighet til å flytte saker i denne gruppen/køen.',
        'create' => 'opprett',
        'Permissions to create tickets in this group/queue.' => 'Rettighet til å opprette saker i denne gruppen/køen.',
        'priority' => 'prioritet',
        'Permissions to change the ticket priority in this group/queue.' =>
            'Rettighet til å endre prioritet i denne gruppen/køen.',

        # Template: AdminRoleUser
        'Manage Agent-Role Relations' => 'Koplinger mellom Saksbehandlere og Roller',
        'Filter for Agents' => 'Filter for Saksbehandlere',
        'Agents' => 'Saksbehandlere',
        'Manage Role-Agent Relations' => 'Koplinger mellom Rolle og Saksbehandler',
        'Change Role Relations for Agent' => 'Endre saksbehandlerens kopling til roller',
        'Change Agent Relations for Role' => 'Endre rollens kopling til saksbehandlere',

        # Template: AdminSLA
        'SLA Management' => 'Administrasjon: SLA',
        'Add SLA' => 'Ny SLA',
        'Edit SLA' => 'Endre SLA',
        'Please write only numbers!' => 'Vennligst skriv kun siffer',

        # Template: AdminSMIME
        'S/MIME Management' => 'Administrasjon: S/MIME',
        'Add certificate' => 'Legg til sertifikat',
        'Add private key' => 'Legg til privat nøkkel',
        'Filter for certificates' => '',
        'Filter for SMIME certs' => '',
        'Here you can add relations to your private certificate, these will be embedded to the SMIME signature every time you use this certificate to sign an email.' =>
            '',
        'See also' => 'Se også',
        'In this way you can directly edit the certification and private keys in file system.' =>
            'På denne måten kan du direkte redigere sertifikatet og private nøkler i filsystemet. ',
        'Hash' => 'Hash',
        'Create' => 'Opprett',
        'Handle related certificates' => 'Behandle relaterte sertifikater',
        'Read certificate' => 'Les sertifikat',
        'Delete this certificate' => 'Slett dette sertifikatet',
        'Add Certificate' => 'Legg til sertifikat',
        'Add Private Key' => 'Legg til privat nøkkel',
        'Secret' => 'Hemmelighet',
        'Related Certificates for' => 'Relaterte sertifikater for',
        'Delete this relation' => 'Fjern denne relasjonen',
        'Available Certificates' => 'Tilgjengelige sertifikater',
        'Relate this certificate' => 'Relater dette sertifikatet',

        # Template: AdminSMIMECertRead
        'SMIME Certificate' => 'SMIME sertifikat',
        'Close window' => 'Lukk vindu',

        # Template: AdminSalutation
        'Salutation Management' => 'Administrasjon: Hilsninger',
        'Add salutation' => 'Legg til hilsning',
        'Add Salutation' => 'Legg til hilsning',
        'Edit Salutation' => 'Endre hilsning',
        'Example salutation' => 'Eksempel på hilsning',

        # Template: AdminScheduler
        'This option will force Scheduler to start even if the process is still registered in the database' =>
            'Denne innstillingen vil tvinge oppgaveplanleggeren til å starte selv om det er allerede en prosess registrert i databasen',
        'Start scheduler' => 'Start oppgaveplanleggeren',
        'Scheduler could not be started. Check if scheduler is not running and try it again with Force Start option' =>
            'Oppgaveplanleggeren kunne ikke starte. Se om oppgaveplanleggeren ikke kjører og prøv igjen ved slå på tvangsstyrings valget',

        # Template: AdminSecureMode
        'Secure mode needs to be enabled!' => 'Sikkermodus må slås på!',
        'Secure mode will (normally) be set after the initial installation is completed.' =>
            'Sikkermodus vil (normalt) være satt etter førstegangs-installasjon er ferdig.',
        'If secure mode is not activated, activate it via SysConfig because your application is already running.' =>
            'Hvis sikkermodus ikke er slått på, slå det på via Systemkonfigurasjon fordi applikasjonen er i drift',

        # Template: AdminSelectBox
        'SQL Box' => 'SQL-boks',
        'Here you can enter SQL to send it directly to the application database.' =>
            'Her kan du skrive SQL for å sende kommandoer rett til OTRS sin database',
        'The syntax of your SQL query has a mistake. Please check it.' =>
            'SQL-spørringen har en syntaks-feil. Vennligst sjekk den.',
        'There is at least one parameter missing for the binding. Please check it.' =>
            'Det mangler minst ett parameter i bindingen. Vennligst sjekk den.',
        'Result format' => 'Format for resultatet',
        'Run Query' => 'Kjør spørring',

        # Template: AdminService
        'Service Management' => 'Administrasjon: Tjenester',
        'Add service' => 'Ny tjeneste',
        'Add Service' => 'Legg til Tjeneste',
        'Edit Service' => 'Endre Tjeneste',
        'Sub-service of' => 'Under-tjeneste av',

        # Template: AdminSession
        'Session Management' => 'Administrasjon: Sesjoner',
        'All sessions' => 'Alle sesjoner',
        'Agent sessions' => 'Saksbehandler-sesjoner',
        'Customer sessions' => 'Kunde-sesjoner',
        'Unique agents' => 'Unike saksbehandlere',
        'Unique customers' => 'Unike kunder',
        'Kill all sessions' => 'Terminer alle sesjoner',
        'Kill this session' => 'Terminer denne sesjonen',
        'Session' => 'Sesjon',
        'Kill' => 'Terminer',
        'Detail View for SessionID' => 'Detaljert visning av SesjonsID',

        # Template: AdminSignature
        'Signature Management' => 'Administrasjon: Signaturer',
        'Add signature' => 'Ny signatur',
        'Add Signature' => 'Legg til signatur',
        'Edit Signature' => 'Endre Signatur',
        'Example signature' => 'Eksempel på signatur',

        # Template: AdminState
        'State Management' => 'Administrasjon: Statuser',
        'Add state' => 'Ny Status',
        'Please also update the states in SysConfig where needed.' => 'Vennligst også oppdatert nødvendige statuser i SysConfig',
        'Add State' => 'Legg til status',
        'Edit State' => 'Endre status',
        'State type' => 'Statustype',

        # Template: AdminSysConfig
        'SysConfig' => 'Systemkonfigurasjon',
        'Navigate by searching in %s settings' => 'Naviger ved å søke i %-oppsett',
        'Navigate by selecting config groups' => 'Naviger ved å velge oppsettsgrupperinger',
        'Download all system config changes' => 'Last ned alle konfigurasjons-endringer',
        'Export settings' => 'Eksport av oppsettet',
        'Load SysConfig settings from file' => 'Last inn konfigurasjon fra fil',
        'Import settings' => 'Importer oppsett',
        'Import Settings' => 'Importer oppsett',
        'Please enter a search term to look for settings.' => 'Vennligst skriv inn et søk for å finne oppsett',
        'Subgroup' => 'Undergruppe',
        'Elements' => 'Elementer',

        # Template: AdminSysConfigEdit
        'Edit Config Settings' => 'Endre konfigurasjon',
        'This config item is only available in a higher config level!' =>
            'Dette konfigurasjons-objektet er kun tilgjengelig på et høyere administrasjonsnivå',
        'Reset this setting' => 'Nullstill denne innstillingen',
        'Error: this file could not be found.' => 'Feil: denne filen ble ikke funnet.',
        'Error: this directory could not be found.' => 'Feil: denne mappen ble ikke funnet.',
        'Error: an invalid value was entered.' => 'Feil: en ugyldig verdi ble skrevet inn',
        'Content' => 'Innhold',
        'Remove this entry' => 'Slett denne posten',
        'Add entry' => 'Ny post',
        'Remove entry' => 'Slett post',
        'Add new entry' => 'Ny post',
        'Create new entry' => 'Opprett ny post',
        'New group' => 'Ny gruppe',
        'Group ro' => 'Gruppe kun-les',
        'Readonly group' => 'Gruppen kan kun leses',
        'New group ro' => 'Ny gruppe kun-les',
        'Loader' => 'Innlaster',
        'File to load for this frontend module' => 'Fil som skal lastes for denne frontsidemodulen',
        'New Loader File' => 'Ny Innlastingsfil',
        'NavBarName' => 'navBarName',
        'NavBar' => 'Navigasjons-meny',
        'LinkOption' => 'Lenkevalg',
        'Block' => 'Blokk',
        'AccessKey' => 'Tilgangstast',
        'Add NavBar entry' => 'Ny Navigasjons-meny-knapp',
        'Year' => 'År',
        'Month' => 'Måned',
        'Day' => 'Dag',
        'Invalid year' => 'Ugyldig år',
        'Invalid month' => 'Ugyldig måned',
        'Invalid day' => 'Ugyldig dag',

        # Template: AdminSystemAddress
        'System Email Addresses Management' => 'Administrasjon: Systemets E-postadresser',
        'Add system address' => 'Ny systemadresse',
        'All incoming email with this address in To or Cc will be dispatched to the selected queue.' =>
            'All innkommende e-post til denne adressen i To eller CC vil bli lagt i den valgte køen',
        'Email address' => 'E-postadresse',
        'Display name' => 'Vist navn',
        'Add System Email Address' => 'Legg til Systemadresse',
        'Edit System Email Address' => 'Endre Systemadresse',
        'The display name and email address will be shown on mail you send.' =>
            'Vist navn og e-postadresse vil vises på e-posten du sender ut',

        # Template: AdminType
        'Type Management' => 'Administrasjon: Typer',
        'Add ticket type' => 'Ny sakstype',
        'Add Type' => 'Legg til sakstype',
        'Edit Type' => 'Endre sakstype',

        # Template: AdminUser
        'Add agent' => 'Legg til saksbehandler',
        'Agents will be needed to handle tickets.' => 'Saksbehandlere trengs for å behandle saker',
        'Don\'t forget to add a new agent to groups and/or roles!' => 'Ikke glem å legge saksbehandlere i grupper og/eller roller',
        'Please enter a search term to look for agents.' => 'Skriv et søk for å finne saksbehandlere',
        'Last login' => 'Siste innlogging',
        'Switch to agent' => 'Bytt til saksbehandler',
        'Add Agent' => 'Legg til Saksbehandler',
        'Edit Agent' => 'Endre Saksbehandler',
        'Firstname' => 'Fornavn',
        'Lastname' => 'Etternavn',
        'Password is required.' => 'Passord er påkrevd.',
        'Start' => 'Start',
        'End' => 'Slutt',

        # Template: AdminUserGroup
        'Manage Agent-Group Relations' => 'Koplinger mellom Saksbehandler og Gruppe',
        'Change Group Relations for Agent' => 'Endre gruppekoplinger for saksbehandler',
        'Change Agent Relations for Group' => 'Endre saksbehandlerkoplinger for gruppe',
        'note' => 'notis',
        'Permissions to add notes to tickets in this group/queue.' => 'Rettigheter for å svare på saker i denne gruppen/køen',
        'owner' => 'Eier',
        'Permissions to change the owner of tickets in this group/queue.' =>
            'Rettigheter til å endre eier av saker i denne gruppen/køen',

        # Template: AgentBook
        'Address Book' => 'Adressebok',
        'Search for a customer' => 'Søk etter kunde',
        'Add email address %s to the To field' => 'Legg til adressen %s i To-feltet',
        'Add email address %s to the Cc field' => 'Legg til adressen %s i Cc-feltet',
        'Add email address %s to the Bcc field' => 'Legg til adressen %s i Bcc-feltet',
        'Apply' => 'Lagre',

        # Template: AgentCustomerInformationCenter
        'Customer Information Center' => '',

        # Template: AgentCustomerInformationCenterBlank

        # Template: AgentCustomerInformationCenterSearch
        'Customer ID' => 'Kunde-ID',
        'Customer User' => 'Kunde-bruker',

        # Template: AgentCustomerSearch
        'Search Customer' => 'Kunde-søk',
        'Duplicated entry' => 'Doble innlegg',
        'This address already exists on the address list.' => 'Denne adressen finnes allerede i adresseboken',
        'It is going to be deleted from the field, please try again.' => '',

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Kontrollpanel',

        # Template: AgentDashboardCalendarOverview
        'in' => 'om',

        # Template: AgentDashboardCustomerCompanyInformation

        # Template: AgentDashboardCustomerIDStatus
        'Escalated tickets' => 'Eskalerte saker',

        # Template: AgentDashboardCustomerUserList
        'Customer information' => 'Kundeinformasjon',
        'Phone ticket' => '',
        'Email ticket' => '',
        '%s open ticket(s) of %s' => '',
        '%s closed ticket(s) of %s' => '',
        'New phone ticket from %s' => '',
        'New email ticket to %s' => '',

        # Template: AgentDashboardIFrame

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s er tilgjengelig!',
        'Please update now.' => 'Vennligst oppdater nå.',
        'Release Note' => 'Versjons-notis',
        'Level' => 'Nivå',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Postet for %s siden',

        # Template: AgentDashboardTicketGeneric
        'My locked tickets' => 'Mine lukkede saker',
        'My watched tickets' => 'Mine overvåkede saker',
        'My responsibilities' => 'Mine ansvar',
        'Tickets in My Queues' => 'Saker i Min Kø',

        # Template: AgentDashboardTicketStats

        # Template: AgentDashboardUserOnline
        'out of office' => 'ikke på kontoret',

        # Template: AgentDashboardUserOutOfOffice
        'until' => '',

        # Template: AgentHTMLReferenceForms

        # Template: AgentHTMLReferenceOverview

        # Template: AgentHTMLReferencePageLayout
        'The ticket has been locked' => 'Saken har blitt låst',
        'Undo & close window' => 'Angre og lukk vindu',

        # Template: AgentInfo
        'Info' => 'Informasjon',
        'To accept some news, a license or some changes.' => 'For å akseptere nyheter, en lisens eller endringer',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Koble objekt: %s',
        'go to link delete screen' => 'gå til skjermen for å slette lenker',
        'Select Target Object' => 'Velg mål-objekt',
        'Link Object' => 'Koble objekt',
        'with' => 'med',
        'Unlink Object: %s' => 'Koble fra objekt: %s',
        'go to link add screen' => 'gå til skjermen for å legge til lenker',

        # Template: AgentNavigationBar

        # Template: AgentPreferences
        'Edit your preferences' => 'Endre dine innstillinger',

        # Template: AgentSpelling
        'Spell Checker' => 'Stavekontroll',
        'spelling error(s)' => 'Stavefeil',
        'Apply these changes' => 'Iverksett endringer',

        # Template: AgentStatsDelete
        'Delete stat' => 'Slett statistikk',
        'Stat#' => 'Stat#',
        'Do you really want to delete this stat?' => 'Vil du virkelig slette denne statistikken?',

        # Template: AgentStatsEditRestrictions
        'Step %s' => 'Steg %s',
        'General Specifications' => 'Generelle spesifikasjoner',
        'Select the element that will be used at the X-axis' => 'Velg element til bruk på X-aksen',
        'Select the elements for the value series' => 'Velg elementene for verdiserien.',
        'Select the restrictions to characterize the stat' => 'Velg begrensningene som karakteriserer statistikken',
        'Here you can make restrictions to your stat.' => 'Her kan du begrense statistikken.',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' =>
            'Dersom du fjerner haken i \'Fast\' avkryssingsboksen, vil saksbehandleren som genererer statistikken kunne endre attributtene til det korresponderende elementet.',
        'Fixed' => 'Fast',
        'Please select only one element or turn off the button \'Fixed\'.' =>
            'Vennligst velg kun ett element, eller deaktivere \'Fast\' knappen',
        'Absolute Period' => 'Absolutt periode',
        'Between' => 'Mellom',
        'Relative Period' => 'Relativ Periode',
        'The last' => 'Den siste',
        'Finish' => 'Ferdig',

        # Template: AgentStatsEditSpecification
        'Permissions' => 'Tilgang',
        'You can select one or more groups to define access for different agents.' =>
            'Du kan velge en eller flere grupper for å gi tilgang for forskjellige saksbehandlere',
        'Some result formats are disabled because at least one needed package is not installed.' =>
            'Noen resultatformater er deaktivert fordi minst en påkrevd pakke ikke er installert.',
        'Please contact your administrator.' => 'Vennligst kontakt din administrator',
        'Graph size' => 'Størrelse på grafen',
        'If you use a graph as output format you have to select at least one graph size.' =>
            'Dersom du benytter en graf for visning av statistikken, må du velge minst én graf-størrelse.',
        'Sum rows' => 'Summer rader',
        'Sum columns' => 'Summer kolonner',
        'Use cache' => 'Bruk mellomlagring',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' =>
            'De fleste statistikker kan lagres i mellomlageret. Dette vil medføre at grafen genereres raskere.',
        'If set to invalid end users can not generate the stat.' => 'Hvis satt til ugyldig kan ikke sluttbrukere generere statistikken',

        # Template: AgentStatsEditValueSeries
        'Here you can define the value series.' => 'Her kan du definere verdiserien',
        'You have the possibility to select one or two elements.' => 'Du kan velge et eller to elementer',
        'Then you can select the attributes of elements.' => 'Deretter kan du velge attributter fra elementer',
        'Each attribute will be shown as single value series.' => 'Hver attributt vil bli vist som en egen verdiserie',
        'If you don\'t select any attribute all attributes of the element will be used if you generate a stat, as well as new attributes which were added since the last configuration.' =>
            'Hvis du ikke velger noen attributter vil alle attributter vises hvis du lager en statistikk, i tillegg til nye attributter som har blitt lagt til siden sist.',
        'Scale' => 'Skala',
        'minimal' => 'minimal',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' =>
            'Bemerk at skalaen for verdiserien må være større enn skalaen til X-aksen (f.eks. X-akse => måned, verdiserie => år).',

        # Template: AgentStatsEditXaxis
        'Here you can define the x-axis. You can select one element via the radio button.' =>
            'Her kan du definere x-aksen. Velg ett element med trykk-knappene.',
        'maximal period' => 'Maksimal periode',
        'minimal scale' => 'Minimal skala',

        # Template: AgentStatsImport
        'Import Stat' => 'Importér Statistikk',
        'File is not a Stats config' => 'Filen er ikke en statistikk-konfigurasjon',
        'No File selected' => 'Ingen fil er valgt',

        # Template: AgentStatsOverview
        'Stats' => 'Statistikk',

        # Template: AgentStatsPrint
        'No Element selected.' => 'Ingen valgte elementer.',

        # Template: AgentStatsView
        'Export config' => 'Eksporter oppsett',
        'With the input and select fields you can influence the format and contents of the statistic.' =>
            'Du kan påvirke format og innhold i statistikken gjennom valgfeltene',
        'Exactly what fields and formats you can influence is defined by the statistic administrator.' =>
            'Nøyaktig hvilke felter du kan bruke er definert av statistikk-administratoren',
        'Stat Details' => 'Detaljer for statistikken',
        'Format' => 'Format',
        'Graphsize' => 'Graf-størrelse',
        'Cache' => 'Mellomlagring',
        'Exchange Axis' => 'Bytt akser',
        'Configurable params of static stat' => 'Konfigurer-bare parametre til statisk statistikk',
        'No element selected.' => 'Ingen valgte elementer.',
        'maximal period from' => 'Maksimal periode fra',
        'to' => 'til',

        # Template: AgentTicketActionCommon
        'Change Free Text of Ticket' => 'Endre fritekst for sak',
        'Change Owner of Ticket' => 'Endre eier på sak',
        'Close Ticket' => 'Avslutt sak',
        'Add Note to Ticket' => 'Legg til notis på sak',
        'Set Pending' => 'Sett på vent',
        'Change Priority of Ticket' => 'Endre prioritet',
        'Change Responsible of Ticket' => 'Endre ansvarlig for sak',
        'Service invalid.' => 'Tjenesten er ugyldig.',
        'New Owner' => 'Ny eier',
        'Please set a new owner!' => 'Vennligst sett en ny eier!',
        'Previous Owner' => 'Forrige eier',
        'Inform Agent' => 'Informer Saksbehandler',
        'Optional' => 'Valgfri',
        'Inform involved Agents' => 'Informer involverte saksbehandlere',
        'Spell check' => 'Stavekontroll',
        'Note type' => 'Notistype',
        'Next state' => 'Neste status',
        'Pending date' => 'Sett på vent til',
        'Date invalid!' => 'Ugyldig dato!',

        # Template: AgentTicketActionPopupClose

        # Template: AgentTicketBounce
        'Bounce Ticket' => 'Oversend sak',
        'Bounce to' => 'Oversend til',
        'You need a email address.' => 'Du trenger en e-postadresse.',
        'Need a valid email address or don\'t use a local email address.' =>
            'Må ha en gyldig e-postadresse, og ikke en lokal adresse',
        'Next ticket state' => 'Neste status på sak',
        'Inform sender' => 'Informer avsender',
        'Send mail!' => 'Send e-posten',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Masseredigering av saker',
        'Send Email' => 'Send e-post',
        'Merge to' => 'Flett med',
        'Invalid ticket identifier!' => 'Ugyldig Saksnummer',
        'Merge to oldest' => 'Flett med eldste',
        'Link together' => 'Koble sammen',
        'Link to parent' => 'Koble til forelder',
        'Unlock tickets' => 'Lås opp saker',

        # Template: AgentTicketClose

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Forfatt svar til sak',
        'Remove Ticket Customer' => 'Fjern kunde fra sak',
        'Please remove this entry and enter a new one with the correct value.' =>
            'Vennlist fjern innlegget og legg til en med riktige verdier',
        'Please include at least one recipient' => 'Vennligst oppgi minst en mottaker',
        'Remove Cc' => 'Fjern Cc',
        'Remove Bcc' => 'Fjern Bcc',
        'Address book' => 'Adressebok',
        'Pending Date' => 'Utsatt til',
        'for pending* states' => 'for vente-tilstander',
        'Date Invalid!' => 'Ugyldig dato',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Endre kunde på sak',
        'Customer user' => 'Kunde',

        # Template: AgentTicketEmail
        'Create New Email Ticket' => 'Opprett ny e-postsak',
        'From queue' => 'Fra kø',
        'To customer' => 'Til kunde',
        'Please include at least one customer for the ticket.' => 'Vennligst oppgi minst en kunde for denne saken',
        'Get all' => 'Hent alle',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Forward ticket: %s - %s' => 'Videresend sak: %s - %s',

        # Template: AgentTicketFreeText

        # Template: AgentTicketHistory
        'History of' => 'Historikk for',
        'History Content' => 'Historikk',
        'Zoom view' => 'Zoom visning',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Flett saker',
        'You need to use a ticket number!' => 'Du må bruke et saksnummer',
        'A valid ticket number is required.' => 'Et gyldig Saksnummer er påkrevd.',
        'Need a valid email address.' => 'Trenger en gyldig e-postadresse',

        # Template: AgentTicketMove
        'Move Ticket' => 'Flytt sak',
        'New Queue' => 'Ny kø',

        # Template: AgentTicketNote

        # Template: AgentTicketOverviewMedium
        'Select all' => 'Velg alle',
        'No ticket data found.' => 'Ingen saker ble funnet',
        'First Response Time' => 'Første responstid',
        'Service Time' => 'Tjenestetid',
        'Update Time' => 'Oppdateringstid',
        'Solution Time' => 'Løsningstid',
        'Move ticket to a different queue' => 'Flytt saker til annen kø',
        'Change queue' => 'Endre kø',

        # Template: AgentTicketOverviewNavBar
        'Change search options' => 'Endre søke-innstillinger',
        'Tickets per page' => 'Saker per side',

        # Template: AgentTicketOverviewPreview

        # Template: AgentTicketOverviewSmall
        'Escalation in' => 'Eskalering om',
        'Locked' => 'Tilgjengelighet',

        # Template: AgentTicketOwner

        # Template: AgentTicketPending

        # Template: AgentTicketPhone
        'Create New Phone Ticket' => 'Lag ny Telefon-sak',
        'From customer' => 'Fra kunde',
        'To queue' => 'Til kø',

        # Template: AgentTicketPhoneCommon
        'Phone call' => 'Telefon-anrop',

        # Template: AgentTicketPlain
        'Email Text Plain View' => 'e-post Enkel Tekstvisning',
        'Plain' => 'Enkel',
        'Download this email' => 'Last ned denne e-posten',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Saksinfo',
        'Accounted time' => 'Benyttet tid',
        'Linked-Object' => 'Koblet objekt',
        'by' => 'av',

        # Template: AgentTicketPriority

        # Template: AgentTicketProcess
        'Create New Process Ticket' => '',
        'Process' => '',

        # Template: AgentTicketProcessNavigationBar

        # Template: AgentTicketQueue

        # Template: AgentTicketResponsible

        # Template: AgentTicketSearch
        'Search template' => 'Bruk mal',
        'Create Template' => 'Ny mal',
        'Create New' => 'Ny',
        'Profile link' => 'Lenke til profil',
        'Save changes in template' => 'Lagre endringer i mal',
        'Add another attribute' => 'Legg til attributt',
        'Output' => 'Resultat',
        'Fulltext' => 'Fulltekst',
        'Remove' => 'Fjern',
        'Searches in the attributes From, To, Cc, Subject and the article body, overriding other attributes with the same name.' =>
            '',
        'Customer User Login' => 'Kundebrukers login-navn',
        'Created in Queue' => 'Opprettet i kø',
        'Lock state' => 'Låsestatus',
        'Watcher' => 'Overvåker',
        'Article Create Time (before/after)' => 'Opprettelsestidspunkt for artikkel (før/etter)',
        'Article Create Time (between)' => 'Opprettelsestidspunkt for artikkel (mellom)',
        'Ticket Create Time (before/after)' => 'Opprettelsestidspunkt for sak (før/etter)',
        'Ticket Create Time (between)' => 'Opprettelsestidspunkt for sak (mellom)',
        'Ticket Change Time (before/after)' => 'Endringstidspunkt for sak (før/etter)',
        'Ticket Change Time (between)' => 'Endringstidspunkt for sak (mellom)',
        'Ticket Close Time (before/after)' => 'Avslutningstidspunkt for sak (før/etter)',
        'Ticket Close Time (between)' => 'Avslutningstidspunkt for sak (mellom)',
        'Ticket Escalation Time (before/after)' => '',
        'Ticket Escalation Time (between)' => '',
        'Archive Search' => 'Arkivsøk',
        'Run search' => 'Start søk',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Article filter' => 'Innleggsfilter',
        'Article Type' => 'Sakstype',
        'Sender Type' => 'Sendertype',
        'Save filter settings as default' => 'Lagre filter som standard',
        'Archive' => '',
        'This ticket is archived.' => '',
        'Linked Objects' => 'Koblede objekter',
        'Article(s)' => 'Innlegg',
        'Change Queue' => 'Bytt kø',
        'There are no dialogs available at this point in the process.' =>
            '',
        'This item has no articles yet.' => '',
        'Article Filter' => 'Artikkelfilter',
        'Add Filter' => 'Legg til filter',
        'Set' => 'Sett',
        'Reset Filter' => 'Nullstill filter',
        'Show one article' => 'Vis ett innlegg',
        'Show all articles' => 'Vis alle innlegg',
        'Unread articles' => 'Uleste innlegg',
        'No.' => 'Nr.',
        'Unread Article!' => 'Ulest innlegg!',
        'Incoming message' => 'Innkommende melding',
        'Outgoing message' => 'Utgående melding',
        'Internal message' => 'Intern melding',
        'Resize' => 'Gjør om størrelse.',

        # Template: AttachmentBlocker
        'To protect your privacy, remote content was blocked.' => '',
        'Load blocked content.' => 'Last inn blokkert innhold',

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerError
        'Traceback' => 'Tilbakesporing',

        # Template: CustomerFooter
        'Powered by' => 'Drevet av',
        'One or more errors occurred!' => 'En eller flere feil har oppstått!',
        'Close this dialog' => 'Lukk denne dialogen',
        'Could not open popup window. Please disable any popup blockers for this application.' =>
            'Kunne ikke åpne sprettoppvindu. Vennligst slå av eventuelle blokkefunksjoner i nettleseren for dette nettstedet.',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'JavaScript Not Available' => 'JavaScript ikke tilgjengelig',
        'In order to experience OTRS, you\'ll need to enable JavaScript in your browser.' =>
            'For å bruke OTRS må JavaScript slås på i nettleseren.',
        'Browser Warning' => 'Advarsel om nettleseren',
        'The browser you are using is too old.' => 'Nettleseren du bruker er for gammel.',
        'OTRS runs with a huge lists of browsers, please upgrade to one of these.' =>
            'OTRS kjører på en lang rekke nettlesere, vennligst oppgrader til en av disse.',
        'Please see the documentation or ask your admin for further information.' =>
            'Vennligst se dokumentasjonen eller spør din IT-ansvarlige for mer informasjon.',
        'Login' => 'Innlogging',
        'User name' => 'Brukernavn',
        'Your user name' => 'Ditt brukernavn',
        'Your password' => 'Ditt passord',
        'Forgot password?' => 'Glemt passordet?',
        'Log In' => 'Logg inn',
        'Not yet registered?' => 'Ikke registrert enda?',
        'Sign up now' => 'Registrer deg her',
        'Request new password' => 'Be om nytt passord',
        'Your User Name' => 'Ditt brukernavn',
        'A new password will be sent to your email address.' => 'Nytt passord vil bli sendt til din e-postadresse',
        'Create Account' => 'Opprett konto',
        'Please fill out this form to receive login credentials.' => '',
        'How we should address you' => 'Hvordan skal vi tiltale deg',
        'Your First Name' => 'Ditt fornavn',
        'Your Last Name' => 'Ditt etternavn',
        'Your email address (this will become your username)' => 'Din e-postadresse (Dette vil bli ditt brukernavn)',

        # Template: CustomerNavigationBar
        'Edit personal preferences' => 'Endre personlige innstillinger',
        'Logout %s' => 'Logg ut %s',

        # Template: CustomerPreferences

        # Template: CustomerRichTextEditor

        # Template: CustomerTicketMessage
        'Service level agreement' => 'Tjenestenivåavtale',

        # Template: CustomerTicketOverview
        'Welcome!' => 'Velkommen!',
        'Please click the button below to create your first ticket.' => 'Vennligst klikk på knappen under for å opprette din første sak.',
        'Create your first ticket' => 'Opprett din første sak',

        # Template: CustomerTicketPrint
        'Ticket Print' => 'Saksutskrift',

        # Template: CustomerTicketSearch
        'Profile' => 'Profil',
        'e. g. 10*5155 or 105658*' => 'f.eks. 10*5155 eller 105658*',
        'Fulltext search in tickets (e. g. "John*n" or "Will*")' => 'Fulltekst-søk i saker (f.eks. "Hans*n eller "Will*")',
        'Recipient' => 'Mottaker',
        'Carbon Copy' => 'Kopi til',
        'Time restrictions' => 'Tidsbegrensning',
        'No time settings' => 'Ingen tidsinnstillinger',
        'Only tickets created' => 'Kun saker opprettet',
        'Only tickets created between' => 'Kun saker opprettet mellom',
        'Ticket archive system' => 'Saksarkiveringssystem',
        'Save search as template?' => 'Lagre søk som mal?',
        'Save as Template?' => 'Lagre som mal?',
        'Save as Template' => 'Lagre som mal',
        'Template Name' => 'Navn på mal',
        'Pick a profile name' => 'Velg et profil navn',
        'Output to' => 'Skriv ut til',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort
        'of' => 'av',
        'Page' => 'Side',
        'Search Results for' => 'Søkeresultater for',

        # Template: CustomerTicketZoom
        'Show  article' => '',
        'Expand article' => 'Utvid artikkel',
        'Information' => '',
        'Next Steps' => '',
        'Reply' => 'Svar',

        # Template: CustomerWarning

        # Template: Datepicker
        'Invalid date (need a future date)!' => 'Ugyldig dato (må være i fremtiden)',
        'Previous' => 'Forrige',
        'Sunday' => 'søndag',
        'Monday' => 'mandag',
        'Tuesday' => 'tirsdag',
        'Wednesday' => 'onsdag',
        'Thursday' => 'torsdag',
        'Friday' => 'fredag',
        'Saturday' => 'lørdag',
        'Su' => 'sø',
        'Mo' => 'ma',
        'Tu' => 'ti',
        'We' => 'on',
        'Th' => 'to',
        'Fr' => 'fr',
        'Sa' => 'lø',
        'Open date selection' => 'Åpne datovelger',

        # Template: Error
        'Oops! An Error occurred.' => 'Oops! En feil har oppstått!',
        'Error Message' => 'Feilmelding',
        'You can' => 'Du kan',
        'Send a bugreport' => 'Sende en feilrapport',
        'go back to the previous page' => 'gå tilbake til forrige side',
        'Error Details' => 'Feildetaljer',

        # Template: Footer
        'Top of page' => 'Toppen av siden',

        # Template: FooterJS
        'If you now leave this page, all open popup windows will be closed, too!' =>
            'Hvis du forlater denne siden vil også alle åpne sprettopp-vinduer bli lukket.',
        'A popup of this screen is already open. Do you want to close it and load this one instead?' =>
            'En sprettoppvindu med denne skjermen er allerede åpen. Vil du stenge vinduet og laste det inn her i stedet?',
        'Please enter at least one search value or * to find anything.' =>
            'Vennligst oppgi minst en søkeverdi eller * for å finne noe.',

        # Template: FooterSmall

        # Template: HTMLHead

        # Template: HTMLHeadBlockEvents

        # Template: Header
        'Fulltext search' => '',
        'CustomerID Search' => '',
        'CustomerUser Search' => '',
        'You are logged in as' => 'Du er innlogget som',

        # Template: HeaderSmall

        # Template: Installer
        'JavaScript not available' => 'JavaScript er ikke tilgjengelig',
        'Database Settings' => 'Databaseinnstillinger',
        'General Specifications and Mail Settings' => 'Generelle spesifikasjoner og e-post-innstillinger',
        'Registration' => 'Registrering',
        'Welcome to %s' => 'Velkommen til %s',
        'Web site' => 'Websted',
        'Database check successful.' => 'Databasesjekk fullført.',
        'Mail check successful.' => 'E-postsjekk fullført',
        'Error in the mail settings. Please correct and try again.' => 'Feil i e-postoppsettet. Korriger og prøv igjen.',

        # Template: InstallerConfigureMail
        'Configure Outbound Mail' => 'Sett opp utgående e-post',
        'Outbound mail type' => 'Type',
        'Select outbound mail type.' => 'Velg type utgående e-post',
        'Outbound mail port' => 'Utgående port for e-post',
        'Select outbound mail port.' => 'Velg port for utgående e-post',
        'SMTP host' => 'SMTP-tjener',
        'SMTP host.' => 'SMTP-tjener',
        'SMTP authentication' => 'SMTP-autentisering',
        'Does your SMTP host need authentication?' => 'Trenger SMTP-tjeneren din autentisering?',
        'SMTP auth user' => 'Bruker for autentisering',
        'Username for SMTP auth.' => 'Brukernavn for SMTP-autentisering',
        'SMTP auth password' => 'Passord for autentisering',
        'Password for SMTP auth.' => 'Passord for SMTP-autentisering',
        'Configure Inbound Mail' => 'Sett opp innkommende e-post',
        'Inbound mail type' => 'Type',
        'Select inbound mail type.' => 'Velg type for innkommende e-post',
        'Inbound mail host' => 'E-post-tjener',
        'Inbound mail host.' => 'E-post-tjener',
        'Inbound mail user' => 'Brukernavn',
        'User for inbound mail.' => 'Bruker for innkommende e-post',
        'Inbound mail password' => 'Passord',
        'Password for inbound mail.' => 'Passord for innkommende e-post',
        'Result of mail configuration check' => 'Resultat for e-postsjekk',
        'Check mail configuration' => 'Sjekk e-postkonfigurasjonen',
        'Skip this step' => 'Hopp over dette steget',
        'Skipping this step will automatically skip the registration of your OTRS. Are you sure you want to continue?' =>
            '',

        # Template: InstallerDBResult
        'False' => 'Fungerer ikke',

        # Template: InstallerDBStart
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' =>
            'Hvis du har satt et root-passord for databasetjeneren, må det skrives inn her. Hvis ikke kan du la dette feltet være åpent. For sikkerhetsskyld anbefaler vi å sette et root-passord. For mer informasjon, vennligst se i databasedokumentasjonen.',
        'Currently only MySQL is supported in the web installer.' => 'For øyeblikket er kun MySQL støttet i webinstallasjonen.',
        'If you want to install OTRS on another database type, please refer to the file README.database.' =>
            'Hvis du vil installere OTRS på en annen databasetype, vennligst se filen README.database',
        'Database-User' => 'Database-bruker',
        'New' => 'Ny',
        'A new database user with limited rights will be created for this OTRS system.' =>
            'En ny databasebruker med begrensede rettigheter vil bli opprettet for denne OTRS-installasjonen.',
        'default \'hot\'' => 'Standard \'hot\'',
        'DB host' => 'DB-tjener',
        'Check database settings' => 'Sjekk database-oppsett',
        'Result of database check' => 'Resultat for databasesjekken',

        # Template: InstallerFinish
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' =>
            'For å kunne bruke OTRS, må følgende linje utføres på kommandolinjen som root.',
        'Restart your webserver' => 'Restart webserveren din',
        'After doing so your OTRS is up and running.' => 'Etter dette vil OTRS være oppe og kjøre.',
        'Start page' => 'Startside',
        'Your OTRS Team' => 'OTRS-Teamet',

        # Template: InstallerLicense
        'Accept license' => 'Aksepter lisens',
        'Don\'t accept license' => 'Ikke aksepter lisens',

        # Template: InstallerLicenseText

        # Template: InstallerRegistration
        'Organization' => 'Organisasjon',
        'Position' => 'Posisjon',
        'Complete registration and continue' => 'Fullfør registreringen og fortsett',
        'Please fill in all fields marked as mandatory.' => 'Vennligst fyll ut alle feltene som er markert som obligatoriske',

        # Template: InstallerSystem
        'SystemID' => 'System-ID',
        'The identifier of the system. Each ticket number and each HTTP session ID contain this number.' =>
            'Identifikator for dette systemet. Saksnumre og HTTP-sesjoner bruker dette nummeret.',
        'System FQDN' => 'Systemets tjenernavn (FQDN)',
        'Fully qualified domain name of your system.' => 'Fullt kvalifisert domene-navn for din tjener.',
        'AdminEmail' => 'Admin e-post',
        'Email address of the system administrator.' => 'E-postadresse til systemadministratoren',
        'Log' => 'Logg',
        'LogModule' => 'Logg-modul',
        'Log backend to use.' => 'Loggmetode som skal brukes',
        'LogFile' => 'Logg-fil',
        'Log file location is only needed for File-LogModule!' => 'Logg-fil trengs kun for Fil-logging',
        'Webfrontend' => 'Web-grensesnitt',
        'Default language' => 'Standardspråk',
        'Default language.' => 'Standardspråk.',
        'CheckMXRecord' => 'Sjekk MX-informasjon',
        'Email addresses that are manually entered are checked against the MX records found in DNS. Don\'t use this option if your DNS is slow or does not resolve public addresses.' =>
            'E-postadresser som angis manuelt, sjekkes mot MX-oppføringer i DNS. Ikke bruk dette valget dersom din DNS er treg eller ikke gjør oppslag for offentlige adresser.',

        # Template: LinkObject
        'Object#' => 'Objekt#',
        'Add links' => 'Legg til lenker',
        'Delete links' => 'Slett lenker',

        # Template: Login
        'Lost your password?' => 'Mistet passord?',
        'Request New Password' => 'Be om nytt passord',
        'Back to login' => 'Tilbake til innlogging',

        # Template: Motd
        'Message of the Day' => 'Dagens melding',

        # Template: NoPermission
        'Insufficient Rights' => 'Utilstrekkelige rettigheter',
        'Back to the previous page' => 'Tilbake til forrige side',

        # Template: Notify

        # Template: Pagination
        'Show first page' => 'Vis første side',
        'Show previous pages' => 'Vis foregående sider',
        'Show page %s' => 'Vis side %s',
        'Show next pages' => 'Vis neste sider',
        'Show last page' => 'Vis siste side',

        # Template: PictureUpload
        'Need FormID!' => 'Trenger FormID!',
        'No file found!' => 'Ingen fil ble funnet',
        'The file is not an image that can be shown inline!' => 'Filen er ikke et bilde som kan vises i nettleseren!',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'skrevet ut av',

        # Template: PublicDefault

        # Template: Redirect

        # Template: RichTextEditor

        # Template: SpellingInline

        # Template: Test
        'OTRS Test Page' => 'OTRS Test-side',
        'Welcome %s' => 'Velkommen %s',
        'Counter' => 'Teller',

        # Template: Warning
        'Go back to the previous page' => 'Tilbake til forrige side',

        # SysConfig
        '"Slim" Skin which tries to save screen space for power users.' =>
            '',
        'ACL module that allows closing parent tickets only if all its children are already closed ("State" shows which states are not available for the parent ticket until all child tickets are closed).' =>
            'ACL-modul som lar en stenge overordnede saker kun hvis alle undersakene deres har blitt stengte ("Status" viser hvilke statuser som ikke er tilgjengelige inntil alle undersaker er stengte).',
        'AccountedTime' => '',
        'Activates a blinking mechanism of the queue that contains the oldest ticket.' =>
            'Slår på en blinke-mekanisme for den køen som har den eldste saken.',
        'Activates lost password feature for agents, in the agent interface.' =>
            'Slår på glemt-passord-funksjonalitet for saksbehandlere.',
        'Activates lost password feature for customers.' => 'Slår på glemt-passord-funksjonalitet for kundebrukere.',
        'Activates support for customer groups.' => 'Slår på støtte for kundegrupper.',
        'Activates the article filter in the zoom view to specify which articles should be shown.' =>
            'Slår på innleggsfilteret i zoom-visningen for å spesifisere hvilke innlegg som skal vises.',
        'Activates the available themes on the system. Value 1 means active, 0 means inactive.' =>
            'Slår på de tilgjengelige temaene i systemet. Verdien 1 betyr aktivert, mens 0 betyr inaktivert',
        'Activates the ticket archive system search in the customer interface.' =>
            'Slår på arkivsøk i kundegrensesnittet',
        'Activates the ticket archive system to have a faster system by moving some tickets out of the daily scope. To search for these tickets, the archive flag has to be enabled in the ticket search.' =>
            'Slår på arkiveringssystemet for saker. Dette øker hastigheten på systemet ved å fjerne noen av sakene ut av den daglige bruken. For å søke etter slike saker må man søke etter arkiverte saker.',
        'Activates time accounting.' => 'Slår på tids-kontering',
        'Adds a suffix with the actual year and month to the OTRS log file. A logfile for every month will be created.' =>
            'Legger til år og måned på loggfilens navn. Dette gjør at man får én logg-fil per måned.',
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface. The customers email address won\'t be added if the article type is email-internal.' =>
            '',
        'Adds the one time vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the one time vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Legger til ikke-gjentagende fridager for kalenderen. Vennligst bruk enkelttall mellom 1 og 9 (ikke 01 - 09).',
        'Adds the permanent vacation days for the indicated calendar. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            '',
        'Adds the permanent vacation days. Please use single digit pattern for numbers from 1 to 9 (instead of 01 - 09).' =>
            'Legger til årlige fridager for kalenderen. Vennligst bruk enkelttall mellom 1 og 9 (ikke 01 - 09).',
        'Agent Notifications' => 'Saksbehandler-varslinger',
        'Agent interface article notification module to check PGP.' => 'Varslingsmodul for å sjekke PGP.',
        'Agent interface article notification module to check S/MIME.' =>
            'Varslingsmodul for å sjekke S/MIME.',
        'Agent interface module to access CIC search via nav bar.' => '',
        'Agent interface module to access fulltext search via nav bar.' =>
            'Saksbehandlermodul som gir tilgang til fulltekst-søk via navigasjons-området.',
        'Agent interface module to access search profiles via nav bar.' =>
            'Saksbehandlermodul som gir tilgang til søkeprofiler via navigasjonsområdet.',
        'Agent interface module to check incoming emails in the Ticket-Zoom-View if the S/MIME-key is available and true.' =>
            'Saksbehandlermodul som sjekker innkommende e-post i Zoom-visning dersom S/MIME-nøkkelen er tilgjengelig og korrekt.',
        'Agent interface notification module to check the used charset.' =>
            'Saksbehandlermodul som sjekker tegnsettet som er brukt.',
        'Agent interface notification module to see the number of tickets an agent is responsible for.' =>
            'Saksbehandlermodul som viser antall saker en saksbehandler er ansvarlig for',
        'Agent interface notification module to see the number of watched tickets.' =>
            'Saksbehandlermodul som viser antall overvåkede saker.',
        'Agents <-> Groups' => 'Saksbehandlere <-> Grupper',
        'Agents <-> Roles' => 'Saksbehandlere <-> Roller',
        'All customer users of a CustomerID' => '',
        'Allows adding notes in the close ticket screen of the agent interface.' =>
            'Tillater å legge til notater når man stenger saker.',
        'Allows adding notes in the ticket free text screen of the agent interface.' =>
            'Tillater å legge til notater i fritekst-feltene.',
        'Allows adding notes in the ticket note screen of the agent interface.' =>
            'Tillater å legge til notater i notat-skjermen.',
        'Allows adding notes in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Tillater å legge til notater i sakseier-visningen for en vist sak',
        'Allows adding notes in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Tillater å legge til notater i "På Vent"-skjermen til en vist sak.',
        'Allows adding notes in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Tillater å legge til notater i prioriterings-skjermen til en vist sak.',
        'Allows adding notes in the ticket responsible screen of the agent interface.' =>
            'TIllater å legge til notater i skjermen for sakseier.',
        'Allows agents to exchange the axis of a stat if they generate one.' =>
            'Tillater saksbehandlere å bytte akse for statistikk de selv oppretter',
        'Allows agents to generate individual-related stats.' => 'Lar saksbehandlere opprette statistikk relatert til individer.',
        'Allows choosing between showing the attachments of a ticket in the browser (inline) or just make them downloadable (attachment).' =>
            'Tillater å velge mellom å vise vedlegg til saker i nettleseren (inline) eller gjøre dem nedlastbare (vedlegg).',
        'Allows choosing the next compose state for customer tickets in the customer interface.' =>
            'Tillater å velge status ved opprettelse av kundesaker i kundeportalen.',
        'Allows customers to change the ticket priority in the customer interface.' =>
            'Lar kunder endre sakens prioritet i kundeportalen.',
        'Allows customers to set the ticket SLA in the customer interface.' =>
            'Lar kunder sette sakens SLA i kundeportalen.',
        'Allows customers to set the ticket priority in the customer interface.' =>
            'Lar kunder sette sakens prioritet i kundeportalen.',
        'Allows customers to set the ticket queue in the customer interface. If this is set to \'No\', QueueDefault should be configured.' =>
            'Tillater kundene å sette saks-kø når en sak opprettes. Hvis denne settes til \'Nei\' må standardkø være satt.',
        'Allows customers to set the ticket service in the customer interface.' =>
            'Lar kunder velge sakens tjeneste i kundeportalen.',
        'Allows customers to set the ticket type in the customer interface. If this is set to \'No\', TicketTypeDefault should be configured.' =>
            '',
        'Allows default services to be selected also for non existing customers.' =>
            '',
        'Allows defining new types for ticket (if ticket type feature is enabled).' =>
            'Tillater å definere nye typer saker (dersom sakstype-funksjonaliteten er slått på).',
        'Allows defining services and SLAs for tickets (e. g. email, desktop, network, ...), and escalation attributes for SLAs (if ticket service/SLA feature is enabled).' =>
            'Tillater å opprette tjenester og SLAer for saker (f.eks. e-post, skrivebord, nettverk, ...) og eskaleringsattributter for SLAer (dersom tjenester/SLA er slått på).',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search e. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            '',
        'Allows extended search conditions in ticket search of the customer interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Tillater avanserte søkekriterier i søk etter saker i kundeportalen. Med denne funksjonaliteten kan man søke med kriterier som "(søk1&&søk2)" eller "(søk1||søk2)".',
        'Allows having a medium format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Tillater å bruke medium saksoversikt (KundeInfo => 1 - viser også kundeinformasjon).',
        'Allows having a small format ticket overview (CustomerInfo => 1 - shows also the customer information).' =>
            'Tillater å bruke liten saksoversikt (Kunde-info => 1 - vis også kundeinformasjon)',
        'Allows the administrators to login as other customers, via the customer user administration panel.' =>
            '',
        'Allows the administrators to login as other users, via the users administration panel.' =>
            'Tillater administratorer å logge seg inn som andre brukere, via brukeradministrasjonspanelet',
        'Allows to set a new ticket state in the move ticket screen of the agent interface.' =>
            'Tillater å endre sakens status når den skal flyttes',
        'ArticleTree' => '',
        'Attachments <-> Responses' => 'Vedlegg <-> Ferdigsvar',
        'Auto Responses <-> Queues' => 'Autosvar <-> Køer',
        'Automated line break in text messages after x number of chars.' =>
            'Automatisk linjeskift i tekstmeldinger etter # antall tegn.',
        'Automatically lock and set owner to current Agent after selecting for an Bulk Action.' =>
            'Automatisk lås og sett eier til nåværende agent etter å ha blitt valgt i en masseredigeringshandling',
        'Automatically sets the owner of a ticket as the responsible for it (if ticket responsible feature is enabled).' =>
            'Sett automatisk eieren av saken som ansvarlig for den (hvis saksansvar er slått på).',
        'Automatically sets the responsible of a ticket (if it is not set yet) after the first owner update.' =>
            'Sett automatisk ansvarlig for en sak (hvis ikke satt) etter første eieroppdatering',
        'Balanced white skin by Felix Niklas.' => 'Balansert hvitt tema av Felix Niklas',
        'Basic fulltext index settings. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            '',
        'Blocks all the incoming emails that do not have a valid ticket number in subject with From: @example.com address.' =>
            'Blokkerer all innkommende e-post som ikke har et gyldig saksnummer i emnefeltet som er sendt fra @example.com-adresser.',
        'Builds an article index right after the article\'s creation.' =>
            'Bygger en innleggsindeks rett etter at et innlegg er opprettet.',
        'CMD example setup. Ignores emails where external CMD returns some output on STDOUT (email will be piped into STDIN of some.bin).' =>
            'CMD - eksempel på oppsett. Ignorerer e-post hvor ekstern CMD returnerer noe som helst til STDOUT (e-posten vil bli "pipet" til kommandoen STDIN).',
        'Cache time in seconds for agent authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for customer authentication in the GenericInterface.' =>
            '',
        'Cache time in seconds for the DB process backend.' => '',
        'Cache time in seconds for the ticket process navigation bar output module.' =>
            '',
        'Cache time in seconds for the web service config backend.' => '',
        'Change password' => 'Endre passord',
        'Change queue!' => 'Endre kø!',
        'Change the customer for this ticket' => 'Bytt kunde for denne saken',
        'Change the free fields for this ticket' => '',
        'Change the priority for this ticket' => 'Bytt prioriteten på denne saken',
        'Change the responsible person for this ticket' => 'Bytt ansvarlig person på denne saken',
        'Changes the owner of tickets to everyone (useful for ASP). Normally only agent with rw permissions in the queue of the ticket will be shown.' =>
            'Endrer eier på saker til "alle" (brukbart for ASP). Normalt vil kun saksbehandlere med Les/skriv-tilgang til køen bli vist.',
        'Checkbox' => 'Avkryssingsfelt',
        'Checks the SystemID in ticket number detection for follow-ups (use "No" if SystemID has been changed after using the system).' =>
            'Sjekker SystemID i saksnummer-generatoren for oppfølginger (bruk "Nei" hvis SystemID har blitt endret etter å ha brukt systemet.',
        'Closed tickets of customer' => 'Kundes lukkede saker',
        'Comment for new history entries in the customer interface.' => 'Kommentar for nye historiske innlegg i kundeportalen.',
        'Company Status' => '',
        'Company Tickets' => 'Firmasaker',
        'Company name for the customer web interface. Will also be included in emails as an X-Header.' =>
            'Firmanavn for kundegrensesnittet. Vil også bli inkludert i e-posten som en X-Hode',
        'Configure Processes.' => '',
        'Configure your own log text for PGP.' => 'Sett opp din egen loggtekst for PGP.',
        'Configures a default TicketDynmicField setting. "Name" defines the dynamic field which should be used, "Value" is the data that will be set, and "Event" defines the trigger event. Please check the developer manual (http://doc.otrs.org/), chapter "Ticket Event Module".' =>
            '',
        'Controls if customers have the ability to sort their tickets.' =>
            'Gir kunder mulighet til å sortere sakene sine.',
        'Controls if more than one from entry can be set in the new phone ticket in the agent interface.' =>
            '',
        'Controls if the ticket and article seen flags are removed when a ticket is archived.' =>
            '',
        'Converts HTML mails into text messages.' => 'Konverter HTML e-poster til tekstmeldinger',
        'Create New process ticket' => '',
        'Create and manage Service Level Agreements (SLAs).' => 'Administrasjon av Tjenestenivåavtaler (SLAer)',
        'Create and manage agents.' => 'Administrasjon av saksbehandlere.',
        'Create and manage attachments.' => 'Administrasjon av vedlegg.',
        'Create and manage companies.' => 'Administrasjon av firma',
        'Create and manage customers.' => 'Administrasjon av kunder',
        'Create and manage dynamic fields.' => 'Administrasjon av dynamiske felter',
        'Create and manage event based notifications.' => 'Administrasjon av hendelsebaserte varslinger',
        'Create and manage groups.' => 'Administrasjon av grupper.',
        'Create and manage queues.' => 'Administrasjon av køer.',
        'Create and manage response templates.' => 'Administrasjon av responsmaler.',
        'Create and manage responses that are automatically sent.' => 'Administrasjon av autosvar.',
        'Create and manage roles.' => 'Administrasjon av roller.',
        'Create and manage salutations.' => 'Administrasjon av hilsener.',
        'Create and manage services.' => 'Administrasjon av tjenester.',
        'Create and manage signatures.' => 'Administrasjon av signaturer.',
        'Create and manage ticket priorities.' => 'Administrasjon av sakprioriteringer.',
        'Create and manage ticket states.' => 'Administrasjon av status på saker.',
        'Create and manage ticket types.' => 'Administrasjon av sakstyper.',
        'Create and manage web services.' => 'Administrasjon av web tjenester',
        'Create new email ticket and send this out (outbound)' => 'Opprett en ny e-post-sak og send (utgående)',
        'Create new phone ticket (inbound)' => 'Opprett en ny telefonhenvendelse (innkommende)',
        'Custom text for the page shown to customers that have no tickets yet.' =>
            'Tekst som vises for kunder som ikke har noen saker enda.',
        'Customer Company Administration' => '',
        'Customer Company Information' => '',
        'Customer User Administration' => '',
        'Customer Users' => 'Kunder',
        'Customer item (icon) which shows the closed tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'Customer item (icon) which shows the open tickets of this customer as info block. Setting CustomerUserLogin to 1 searches for tickets based on login name rather than CustomerID.' =>
            '',
        'CustomerName' => '',
        'Customers <-> Groups' => 'Kunder <-> Grupper',
        'Customers <-> Services' => 'Kunder <-> Tjenester',
        'Data used to export the search result in CSV format.' => 'Data brukt for å eksportere søkeresultatet i CSV-format.',
        'Date / Time' => '',
        'Debugs the translation set. If this is set to "Yes" all strings (text) without translations are written to STDERR. This can be helpful when you are creating a new translation file. Otherwise, this option should remain set to "No".' =>
            '',
        'Default ACL values for ticket actions.' => 'Standard ACL-verdier for sakshendelser',
        'Default ProcessManagement entity prefixes for entity IDs that are automatically generated.' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimePointFormat=year;TicketCreateTimePointStart=Last;TicketCreateTimePoint=2;".' =>
            '',
        'Default data to use on attribute for ticket search screen. Example: "TicketCreateTimeStartYear=2010;TicketCreateTimeStartMonth=10;TicketCreateTimeStartDay=4;TicketCreateTimeStopYear=2010;TicketCreateTimeStopMonth=11;TicketCreateTimeStopDay=3;".' =>
            '',
        'Default loop protection module.' => 'Standard loop-beskyttelsesmodul',
        'Default queue ID used by the system in the agent interface.' => 'Standard køID brukt av systemet for saksbehandlere.',
        'Default skin for OTRS 3.0 interface.' => 'Standard-utseende for OTRS 3.0',
        'Default skin for interface.' => 'Standard-utseende for grensesnittet.',
        'Default ticket ID used by the system in the agent interface.' =>
            'Standard Saksnr brukt av systemet i saksbehandler-delen',
        'Default ticket ID used by the system in the customer interface.' =>
            'Standard Saksnr brukt av systemet i kundeportalen.',
        'Default value for NameX' => '',
        'Define a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Sett et filter for HTML-visning som legger til lenker bak en gitt tekst. Bildeelementet tillater to typer inn-data. For det første navnet på et bilde (f.eks. bilde01.png). I det tilfellet vil OTRS sin bilde-sti brukes. Den andre muligheten er å skrive inn URL til bildet',
        'Define the max depth of queues.' => '',
        'Define the start day of the week for the date picker.' => 'Setter dag for ukestart i datovelgeren.',
        'Defines a customer item, which generates a LinkedIn icon at the end of a customer info block.' =>
            'Definerer et kundeelement som lager et LinkedIn-symbol på slutten av kundeinfo-blokken.',
        'Defines a customer item, which generates a XING icon at the end of a customer info block.' =>
            'Definerer et kundeelement som lager et XING-symbol på slutten av kundeinfo-blokken.',
        'Defines a customer item, which generates a google icon at the end of a customer info block.' =>
            'Definerer et kundeelement som lager et Google-symbol på slutten av kundeinfo-blokken.',
        'Defines a customer item, which generates a google maps icon at the end of a customer info block.' =>
            'Definferer et kundeelement som lager et Google Maps-symbol på slutten av kunde-info-blokken.',
        'Defines a default list of words, that are ignored by the spell checker.' =>
            'Definerer en liste med standard-ord som skal ignoreres av stavekontrollen.',
        'Defines a filter for html output to add links behind CVE numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definerer et filter for HTML-visning for å legge til lenker bak CVE-nummer. Bilde-elementet tillater to typer inn-data. Enten navnet på en bilde-fil (f.eks. bilde01.png), der OTRS vil gå utfra at bildet ligger i OTRS sin bildemappe. Eller man kan oppgi URL til et bilde.',
        'Defines a filter for html output to add links behind MSBulletin numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definerer et filter i HTML-visningen for å legge til lenker bak MSBulletin-nummer. Bildeelementet tillater to typer inn-data. Enten navnet på en bilde-fil (f.eks. bilde01.png), der OTRS vil gå utfra at bildet ligger i OTRS sin bildemappe. Eller man kan oppgi URL til et bilde.',
        'Defines a filter for html output to add links behind a defined string. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definerer et filter for HTML-visning som legger til lenker bak en definert tekst. Bilde-elementet tillater to typer inn-data. Enten navnet på en bilde-fil (f.eks. bilde01.png), der OTRS vil gå utfra at bildet ligger i OTRS sin bildemappe. Eller man kan oppgi URL til et bilde.',
        'Defines a filter for html output to add links behind bugtraq numbers. The element Image allows two input kinds. At once the name of an image (e.g. faq.png). In this case the OTRS image path will be used. The second possiblity is to insert the link to the image.' =>
            'Definerer et filter for HTML-visning som legger til lenker bak BugTraq-numre. Bilde-elementet tillater to typer inn-data. Enten navnet på en bildefil (f.eks. bilde01.png), der OTRS vil gå utfra at bildet ligger i OTRS sin bildemappe. Eller man kan oppgi URL til et bilde.',
        'Defines a filter to process the text in the articles, in order to highlight predefined keywords.' =>
            'Definerer et filter som prosesserer teksten i innlegg for å markere predefinerte nøkkelord.',
        'Defines a regular expression that excludes some addresses from the syntax check (if "CheckEmailAddresses" is set to "Yes"). Please enter a regex in this field for email addresses, that aren\'t syntactically valid, but are necessary for the system (i.e. "root@localhost").' =>
            'Definerer en Regulær-uttrykk-setning som ekskluderer adresser fra syntaks-sjekken (hvis "sjekk e-postadresser" er satt til Ja). Skriv inn en Regulær-uttrykk-setning for e-postadresser som ikke er syntaktisk korrekte, men som er viktige for systemet (f.eks. "root@localhost").',
        'Defines a regular expression that filters all email addresses that should not be used in the application.' =>
            'Definerer en Regulær-uttrykk -setning som filtrerer ut alle e-postadresser som ikke skal brukes i systemet.',
        'Defines a useful module to load specific user options or to display news.' =>
            'Definerer en modul for å laste spesifikke brukerinnstillinger eller for å vise nyheter.',
        'Defines all the X-headers that should be scanned.' => 'Definerer at alle X-hode-feltene som skal skannes.',
        'Defines all the languages that are available to the application. The Key/Content pair links the front-end display name to the appropriate language PM file. The "Key" value should be the base-name of the PM file (i.e. de.pm is the file, then de is the "Key" value). The "Content" value should be the display name for the front-end. Specify any own-defined language here (see the developer documentation http://doc.otrs.org/ for more infomation). Please remember to use the HTML equivalents for non-ASCII characters (i.e. for the German oe = o umlaut, it is necessary to use the &ouml; symbol).' =>
            'Definerer alle språkene som er tilgjengelige for OTRS. Nøkkel-/verdi-parene lenker visningsnavnet til den passende språkfilen (hvis no_NO.pm er filnavnet skal det stå "no_NO" i "Nøkkel"). "Verdi"-feltet skal inneholde visningsnavnet for språket i innloggingsvinduet. Spesifiser egendefinderte språk her (se utviklerdokumentasjonen på http://doc.otrs.org for mer info). Husk å bruke HTML-ekvivalenter for tegn som ikke er i ASCII (å/aa = &aring; osv)',
        'Defines all the parameters for the RefreshTime object in the customer preferences of the customer interface.' =>
            'Definerer alle parametre for gjenoppfriskning i kundeportalen.',
        'Defines all the parameters for the ShownTickets object in the customer preferences of the customer interface.' =>
            'Definerer alle parametre for viste saker i kundeportalen.',
        'Defines all the parameters for this item in the customer preferences.' =>
            'Definerer alle parametre for dette objektet i kunde-oppsettet.',
        'Defines all the possible stats output formats.' => 'Definerer alle mulige formater for statistikk',
        'Defines an alternate URL, where the login link refers to.' => 'Definerer en alternativ URL som Innloggingslenken skal peke til.',
        'Defines an alternate URL, where the logout link refers to.' => 'Definerer en alternativ URL som skal logge ut brukeren.',
        'Defines an alternate login URL for the customer panel..' => 'Alternativ innlogging-URL for kundeportalen.',
        'Defines an alternate logout URL for the customer panel.' => 'Alternativ URL for ut-logging av kunder.',
        'Defines an external link to the database of the customer (e.g. \'http://yourhost/customer.php?CID=$Data{"CustomerID"}\' or \'\').' =>
            'Definerer en ekstern lenke til kundens database (f.eks. \'http://tjener/kunde.php?CID=$Data{"CustomerID"}\' eller \'\').',
        'Defines how the From field from the emails (sent from answers and email tickets) should look like.' =>
            'Definerer hvordan Fra-feltet på e-poster (sendt som svar eller e-post-saker) skal se ut.',
        'Defines if a pre-sorting by priority should be done in the queue view.' =>
            '',
        'Defines if a ticket lock is required in the close ticket screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en saks-lås er nødvendig for å få stenge en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent vil bli satt som eier.',
        'Defines if a ticket lock is required in the ticket bounce screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en saks-lås er nødvendig for å oversende en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket compose screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig for å opprette en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket forward screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig for å videresende en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket free text screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i fritekstvinduet til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket merge screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig for saksfletting. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket note screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i notisvinduet til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket owner screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i sakseier-vinduet til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket pending screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i "På vent"-vinduet. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket phone inbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            '',
        'Defines if a ticket lock is required in the ticket phone outbound screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i "Utgående Telefon"-skjermen til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket priority screen of a zoomed ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i prioritetsvinduet til en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required in the ticket responsible screen of the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig i ansvarlig-vinduet. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if a ticket lock is required to change the customer of a ticket in the agent interface (if the ticket isn\'t locked yet, the ticket gets locked and the current agent will be set automatically as its owner).' =>
            'Spesifiserer om en sakslås er nødvendig for å endre kunden på en sak. Hvis saken ikke er låst vil den bli det, og nåværende agent blir satt som eier.',
        'Defines if composed messages have to be spell checked in the agent interface.' =>
            'Spesifiserer om nye meldinger som skrives må stavekontrolleres.',
        'Defines if the enhanced mode should be used (enables use of table, replace, subscript, superscript, paste from word, etc.).' =>
            '',
        'Defines if time accounting is mandatory in the agent interface.' =>
            'Spesifiserer om tidskontering er obligatorisk for saksbehandlere.',
        'Defines if time accounting must be set to all tickets in bulk action.' =>
            '',
        'Defines scheduler PID update time in seconds (floating point number).' =>
            '',
        'Defines scheduler sleep time in seconds after processing all available tasks (floating point number).' =>
            '',
        'Defines the IP regular expression for accessing the local repository. You need to enable this to have access to your local repository and the package::RepositoryList is required on the remote host.' =>
            'Spesifiserer Regulær-uttrykk for IPen til lokalt pakkelager. Du må slå dette på for å ha tilgang til ditt lokale pakkelager. I tillegg er package::RepositoryList påkrevd på andre tjenere.',
        'Defines the URL CSS path.' => 'Definerer URL til CSS',
        'Defines the URL base path of icons, CSS and Java Script.' => 'Definerer URL som basesti for icons, CSS og JavaScript',
        'Defines the URL image path of icons for navigation.' => 'Definerer URL for bildesti til navigasjons-icons',
        'Defines the URL java script path.' => 'Definerer URL til JavaScript-filer',
        'Defines the URL rich text editor path.' => 'Definerer URL til Rik Tekst-redigereren.',
        'Defines the address of a dedicated DNS server, if necessary, for the "CheckMXRecord" look-ups.' =>
            'Definerer en dedikert DNS-tjener å bruke, hvis nødvendig, for å gjøre MX-sjekk på e-postadresser.',
        'Defines the body text for notification mails sent to agents, about new password (after using this link the new password will be sent).' =>
            'Definerer meldingsteksten for nytt-passord-meldingen til saksbehandlere. Etter å ha brukt lenken vil det nye passordet bli sendt.',
        'Defines the body text for notification mails sent to agents, with token about new requested password (after using this link the new password will be sent).' =>
            'Definerer meldingsteksten for nytt-passord-meldingen til saksbehandlere. Etter å ha brukt lenken vil det nye passordet bli sendt.',
        'Defines the body text for notification mails sent to customers, about new account.' =>
            'Definerer meldingsteksten sent til nye kunder når kontoen blir opprettet.',
        'Defines the body text for notification mails sent to customers, about new password (after using this link the new password will be sent).' =>
            'Definerer meldingsteksten for glemt-passord-melding til kundebrukere. Etter å ha klikket på lenken vil det nye passordet bli sendt til kunden.',
        'Defines the body text for notification mails sent to customers, with token about new requested password (after using this link the new password will be sent).' =>
            'Definerer meldingsteksten for glemt-passord-melding til kundebrukere. Etter å ha klikket på lenken vil det nye passordet bli sendt til kunden.',
        'Defines the body text for rejected emails.' => 'Meldingstekst for avviste e-poster.',
        'Defines the boldness of the line drawed by the graph.' => 'Tykkheten på linjer tegnet i grafer.',
        'Defines the colors for the graphs.' => 'Fargene på grafene.',
        'Defines the column to store the keys for the preferences table.' =>
            'Definerer hvilken kolonne som skal brukes for å lagre nøkler til valgtabellen',
        'Defines the config parameters of this item, to be shown in the preferences view.' =>
            'Definerer parametrene som skal vises i Innstillinger for dette objektet',
        'Defines the config parameters of this item, to be shown in the preferences view. Take care to maintain the dictionaries installed in the system in the data section.' =>
            'Definerer parametrene som skal vises i Innstillinger for dette objektet. Pass på å beholde ordlistene som er installert i systemet, i dataseksjonen.',
        'Defines the connections for http/ftp, via a proxy.' => 'Spesifiserer proxy-oppsett for http/ftp',
        'Defines the date input format used in forms (option or input fields).' =>
            'Spesifiserer datoformat på skjema (valg- eller tekstfelter).',
        'Defines the default CSS used in rich text editors.' => 'Spesifiserer standard CSS til bruk i rik-tekst-redigering.',
        'Defines the default auto response type of the article for this operation.' =>
            '',
        'Defines the default body of a note in the ticket free text screen of the agent interface.' =>
            'Spesifiserer standardinnholdet for notiser i sakens fritekstdel for saksbehandlere.',
        'Defines the default front-end (HTML) theme to be used by the agents and customers. The default themes are Standard and Lite. If you like, you can add your own theme. Please refer the administrator manual located at http://doc.otrs.org/.' =>
            'Definerer standard webtema som skal brukes av saksbehandlere og kunder. De innebygde er Standard og Lite. Du kan legge til egne tema selv. Se i tilfelle manualen, på http://doc.otrs.org/',
        'Defines the default front-end language. All the possible values are determined by the available language files on the system (see the next setting).' =>
            'Spesifiserer standardspråk for webdelen. De mulige valgene er bestemt av språkene som er tilgjengelige i løsningen (se neste innstilling).',
        'Defines the default history type in the customer interface.' => 'Spesifiserer standard historikkvisning i kundeportalen.',
        'Defines the default maximum number of X-axis attributes for the time scale.' =>
            'Setter standardverdi for maks. antall atributter på X-aksen for tidsskalaen',
        'Defines the default maximum number of search results shown on the overview page.' =>
            'Setter standardverdi for maks. antall resultater vist på oversikt-siden.',
        'Defines the default next state for a ticket after customer follow up in the customer interface.' =>
            'Setter standardverdi for neste status etter oppfølging fra kunde i kundeportalen.',
        'Defines the default next state of a ticket after adding a note, in the close ticket screen of the agent interface.' =>
            'Setter standardverdi for neste status etter å ha lagt til en notis når man stenger en sak i agentdelen.',
        'Defines the default next state of a ticket after adding a note, in the ticket bulk screen of the agent interface.' =>
            'Setter standardverdi for neste status etter å ha lagt til en notis i masseredigering i agentdelen.',
        'Defines the default next state of a ticket after adding a note, in the ticket free text screen of the agent interface.' =>
            'Setter standardverdi for neste status etter å ha lagt til en notis i sakens fritekstside i agentdelen.',
        'Defines the default next state of a ticket after adding a note, in the ticket note screen of the agent interface.' =>
            'Setter standardverdi for neste status når agent legger til en notis under interne notater.',
        'Defines the default next state of a ticket after adding a note, in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard for neste saksstatus når agent legger til en notis i eier-delen',
        'Defines the default next state of a ticket after adding a note, in the ticket pending screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard for neste status for en sak etter å ha lagt til en notis i avventingsdelen av agents saksvisning',
        'Defines the default next state of a ticket after adding a note, in the ticket priority screen of a zoomed ticket in the agent interface.' =>
            'Definerer standard for neste saksstatus etter at agent har lagt til en notis og endret prioritet på en sak',
        'Defines the default next state of a ticket after adding a note, in the ticket responsible screen of the agent interface.' =>
            'Definerer standard for neste saksstatus etter at agent har lagt til en notis under saksansvar',
        'Defines the default next state of a ticket after being bounced, in the ticket bounce screen of the agent interface.' =>
            'Definerer standard for neste saksstatus etter at agent har lagt til en notis for en sak som blir avvist',
        'Defines the default next state of a ticket after being forwarded, in the ticket forward screen of the agent interface.' =>
            'Definerer standard for neste saksstatus når agent videresender en sak',
        'Defines the default next state of a ticket if it is composed / answered in the ticket compose screen of the agent interface.' =>
            'Setter standard for neste saksstatus når den blir opprettet/besvart av agent',
        'Defines the default note body text for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default note body text for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definerer standard notistekst for utgående telefon-saker i agentdelen',
        'Defines the default priority of follow up customer tickets in the ticket zoom screen in the customer interface.' =>
            'Setter standard prioritet på saksoppfølginger i kundeportalen',
        'Defines the default priority of new customer tickets in the customer interface.' =>
            'Setter standard prioritet på nye saker opprettet i kundeportalen',
        'Defines the default priority of new tickets.' => 'Setter standard prioritet på nye saker',
        'Defines the default queue for new customer tickets in the customer interface.' =>
            'Setter standardkø for nye saker opprettet i kundeportalen.',
        'Defines the default selection at the drop down menu for dynamic objects (Form: Common Specification).' =>
            'Definerer standard forvalg i menyen for dynamiske objekter (Form: Common Specification)',
        'Defines the default selection at the drop down menu for permissions (Form: Common Specification).' =>
            'Definerer standard forvalg i menyen for tilgangsrettigheter (Form: Common Specification)',
        'Defines the default selection at the drop down menu for stats format (Form: Common Specification). Please insert the format key (see Stats::Format).' =>
            'Definerer standard forvalg i menyen for statistikkformat (Form: Common Specification). Vennligst skriv inn formatnøkkelen (se Stats::Format)',
        'Defines the default sender type for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default sender type for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Setter standard sendertype for utgående telefonsaker i agentdelen',
        'Defines the default sender type for tickets in the ticket zoom screen of the customer interface.' =>
            'Setter standard sendertype for saker i saksvisningen i kundeportalen',
        'Defines the default shown ticket search attribute for ticket search screen.' =>
            '',
        'Defines the default shown ticket search attribute for ticket search screen. Example: a text, 1, Search_DynamicField_Field1StartYear=2002; Search_DynamicField_Field1StartMonth=12; Search_DynamicField_Field1StartDay=12; Search_DynamicField_Field1StartHour=00; Search_DynamicField_Field1StartMinute=00; Search_DynamicField_Field1StartSecond=00; Search_DynamicField_Field1StopYear=2009; Search_DynamicField_Field1StopMonth=02; Search_DynamicField_Field1StopDay=10; Search_DynamicField_Field1StopHour=23; Search_DynamicField_Field1StopMinute=59; Search_DynamicField_Field1StopSecond=59;.' =>
            '',
        'Defines the default sort criteria for all queues displayed in the queue view.' =>
            '',
        'Defines the default sort order for all queues in the queue view, after priority sort.' =>
            'Definerer standard sorteringsrekkefølge for alle køer i køvisningen, etter at de er blitt sortert etter prioritet.',
        'Defines the default spell checker dictionary.' => 'Definerer standard ordliste for stavekontroll.',
        'Defines the default state of new customer tickets in the customer interface.' =>
            'Definerer standard status for nye kundesaker opprettet i kundeportalen.',
        'Defines the default state of new tickets.' => 'Definerer standard status for nye saker',
        'Defines the default subject for phone tickets in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Defines the default subject for phone tickets in the ticket phone outbound screen of the agent interface.' =>
            'Definerer standardverdi for emnefeltet i skjermbildet for utgående telefonsak i agentbildet.',
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
            'Definerer standard saksrekkefølge (etter de er sortert etter prioritet) i eskaleringsvisningen. Opp: eldste først. Ned: nyeste først.',
        'Defines the default ticket order (after priority sort) in the status view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge (etter de er sortert etter prioritet) i statusvisningen. Opp: eldste først. Ned: nyeste først',
        'Defines the default ticket order in the responsible view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket locked view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order in the ticket search result of the agent interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge for søkeresultater i agentbildet. Opp: eldste først. Ned: nyeste først.',
        'Defines the default ticket order in the watch view of the agent interface. Up: oldest on top. Down: latest on top.' =>
            '',
        'Defines the default ticket order of a search result in the customer interface. Up: oldest on top. Down: latest on top.' =>
            'Definerer standard saksrekkefølge i et søkeresultat i kundebildet. Opp: eldste først. Ned: nyeste først.',
        'Defines the default ticket priority in the close ticket screen of the agent interface.' =>
            'Definerer standard saksprioritet i "avslutt sak"-skjermen i agentbildet.',
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
            'Definerer standard type for innlegg i kundebildet.',
        'Defines the default type of forwarded message in the ticket forward screen of the agent interface.' =>
            '',
        'Defines the default type of the article for this operation.' => '',
        'Defines the default type of the note in the close ticket screen of the agent interface.' =>
            'Definerer standard type notis i "Avslutt sak" bildet.',
        'Defines the default type of the note in the ticket bulk screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket free text screen of the agent interface.' =>
            '',
        'Defines the default type of the note in the ticket note screen of the agent interface.' =>
            'Definerer standard type notis i "Legg til notis" bildet.',
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
        'Defines the height of the legend.' => 'Definerer høyden på symbolforklaringen.',
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
        'Defines the hours and week days to count the working time.' => 'Definerer timer og ukedager som telles som arbeidstid.',
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
            'Definerer maksimal størrelse (i bytes) for filopplasting via nettleseren.',
        'Defines the maximal valid time (in seconds) for a session id.' =>
            'Definerer maksimal gyldig tid (i sekunder) for en sesjons-ID.',
        'Defines the maximum length (in characters) for a scheduler task data. WARNING: Do not modify this setting unless you are sure of the current Database length for \'task_data\' filed from \'scheduler_data_list\' table.' =>
            '',
        'Defines the maximum number of pages per PDF file.' => 'Definerer maksimalt antall sider per PDF-fil.',
        'Defines the maximum size (in MB) of the log file.' => 'Definerer maksimal størrelse (i MB) for loggfilen.',
        'Defines the module that shows a generic notification in the agent interface. Either "Text" - if configured - or the contents of "File" will be displayed.' =>
            '',
        'Defines the module that shows all the currently loged in customers in the agent interface.' =>
            '',
        'Defines the module that shows all the currently logged in agents in the agent interface.' =>
            'Definerer modulen som viser alle innloggede saksbehandlere i saksbehandlergrensesnittet.',
        'Defines the module that shows the currently loged in agents in the customer interface.' =>
            '',
        'Defines the module that shows the currently loged in customers in the customer interface.' =>
            '',
        'Defines the module to authenticate customers.' => 'Definerer modulen for å autentisere kunder.',
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
            'Definerer navnet på applikasjonen, som vises i webgrensesnittet, faner, og tittellinjen på nettleseren.',
        'Defines the name of the column to store the data in the preferences table.' =>
            '',
        'Defines the name of the column to store the user identifier in the preferences table.' =>
            '',
        'Defines the name of the indicated calendar.' => '',
        'Defines the name of the key for customer sessions.' => '',
        'Defines the name of the session key. E.g. Session, SessionID or OTRS.' =>
            '',
        'Defines the name of the table, where the customer preferences are stored.' =>
            'Definerer navnet på tabellen der kundens innstillinger lagres.',
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
            'Definerer plassering av symbolforklaringen. Dette skal være en nøkkel på to bokstaver på formen: \'B[LCR]|R[TCB]\'. Den første bokstaven angir plassering (B=Bunn, R=Høyre), og den andre bokstaven angir justering (L=Venstre,R=Høyre,T=Topp,C=Sentrert,B=Bunn).',
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
        'Defines the spacing of the legends.' => 'Definerer avstand mellom symbolforklaringer.',
        'Defines the standard permissions available for customers within the application. If more permissions are needed, you can enter them here. Permissions must be hard coded to be effective. Please ensure, when adding any of the afore mentioned permissions, that the "rw" permission remains the last entry.' =>
            '',
        'Defines the standard size of PDF pages.' => 'Definerer standardstørrelse på PDF-sider.',
        'Defines the state of a ticket if it gets a follow-up and the ticket was already closed.' =>
            'Definerer status på en sak hvis den får en oppfølging og saken allerede var avsluttet.',
        'Defines the state of a ticket if it gets a follow-up.' => 'Definerer status på en sak hvis den får en oppfølging.',
        'Defines the state type of the reminder for pending tickets.' => 'Definerer statustypen for påminnelser om saker på vent.',
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
        'Defines the width of the legend.' => 'Definerer bredden på symbolforklaringen.',
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
        'Email Addresses' => 'e-postadresser',
        'Enable keep-alive connection header for SOAP responses.' => '',
        'Enables PDF output. The CPAN module PDF::API2 is required, if not installed, PDF output will be disabled.' =>
            'Aktiverer utskrift til PDF. CPAN-modulen PDF::API2 er påkrevd, dersom denne ikke er installert vil PDF-utskrift deaktiveres.',
        'Enables PGP support. When PGP support is enabled for signing and securing mail, it is HIGHLY recommended that the web server be run as the OTRS user. Otherwise, there will be problems with the privileges when accessing .gnupg folder.' =>
            '',
        'Enables S/MIME support.' => 'Aktiverer støtte for S/MIME',
        'Enables customers to create their own accounts.' => 'Lar kunder opprette sine egne kontoer',
        'Enables file upload in the package manager frontend.' => '',
        'Enables or disable the debug mode over frontend interface.' => '',
        'Enables or disables the autocomplete feature for the customer search in the agent interface.' =>
            '',
        'Enables or disables the ticket watcher feature, to keep track of tickets without being the owner nor the responsible.' =>
            '',
        'Enables performance log (to log the page response time). It will affect the system performance. Frontend::Module###AdminPerformanceLog must be enabled.' =>
            '',
        'Enables spell checker support.' => 'Aktiverer støtte for stavekontroll.',
        'Enables ticket bulk action feature for the agent frontend to work on more than one ticket at a time.' =>
            '',
        'Enables ticket bulk action feature only for the listed groups.' =>
            '',
        'Enables ticket responsible feature, to keep track of a specific ticket.' =>
            '',
        'Enables ticket watcher feature only for the listed groups.' => '',
        'Escalation view' => 'Eskaleringsvisning',
        'Event list to be displayed on GUI to trigger generic interface invokers.' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate).' =>
            '',
        'Event module registration. For more performance you can define a trigger event (e. g. Event => TicketCreate). This is only possible if all Ticket dynamic fields need the same event.' =>
            '',
        'Execute SQL statements.' => 'Kjør SQL-spørringer',
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
        'Filter incoming emails.' => 'Filtrering av innkommende e-poster',
        'FirstLock' => '',
        'FirstResponse' => '',
        'FirstResponseDiffInMin' => '',
        'FirstResponseInMin' => '',
        'Forces encoding of outgoing emails (7bit|8bit|quoted-printable|base64).' =>
            '',
        'Forces to choose a different ticket state (from current) after lock action. Define the current state as key, and the next state after lock action as content.' =>
            '',
        'Forces to unlock tickets after being moved to another queue.' =>
            'Tvinger opp-låsing av saker ved flytting til ny kø',
        'Frontend language' => 'Språk på nettsiden',
        'Frontend module registration (disable company link if no company feature is used).' =>
            '',
        'Frontend module registration (disable ticket processes screen if no process available).' =>
            '',
        'Frontend module registration for the agent interface.' => 'Registrering av websidemodul i agentdelen.',
        'Frontend module registration for the customer interface.' => '',
        'Frontend theme' => 'Nettsidetema',
        'Fulltext index regex filters to remove parts of the text.' => '',
        'GenericAgent' => 'Administrasjon: Generisk Saksbehandler',
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
            'Gir sluttbrukerne muligheten til å overstyre separatortegnet til CSV-filer definert i oversettelsesfila.',
        'Grants access, if the customer ID of the ticket matches the customer user\'s ID and the customer user has group permissions on the queue the ticket is in.' =>
            'Gir tilgang dersom kunde-ID for saken er den samme som kundebrukerens ID, i tillegg til at kunden må ha tilgang til køen saken ligger i.',
        'Helps to extend your articles full-text search (From, To, Cc, Subject and Body search). Runtime will do full-text searches on live data (it works fine for up to 50.000 tickets). StaticDB will strip all articles and will build an index after article creation, increasing fulltext searches about 50%. To create an initial index use "bin/otrs.RebuildFulltextIndex.pl".' =>
            'Hjelper med å utvide fulltekstsøket (Fra, Til, Cc, Emne og Innhold). Runtime vil gjøre fulltekstsøk på levende data (noe som fungerer bra med opptil 50.000 saker). StaticDB vil ta vekk alle tillegg og bygge en indeks etter at saken er opprettet, noe som minsker søketiden med ca. 50%. For å opprette indeksen, kjør "bin/otrs.RebuildFulltextIndex.pl".',
        'If "DB" was selected for Customer::AuthModule, a database driver (normally autodetection is used) can be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule kan man velge databasedriver (normalt brukes et automatisk oppsett).',
        'If "DB" was selected for Customer::AuthModule, a password to connect to the customer table can be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule kan man sette et passord for å koble til kundetabellen.',
        'If "DB" was selected for Customer::AuthModule, a username to connect to the customer table can be specified.' =>
            'Hvis "DB" er valgt under som::AuthModule kan man sette et brukernavn for å koble til kundetabellen.',
        'If "DB" was selected for Customer::AuthModule, the DSN for the connection to the customer table must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må man spesifisere en DSN for tilkoplingen til kundetabellen.',
        'If "DB" was selected for Customer::AuthModule, the column name for the CustomerPassword in the customer table must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må man skrive inn feltnavnet som skal kobles til CustomerPassword i kundetabellen.',
        'If "DB" was selected for Customer::AuthModule, the crypt type of passwords must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må man spesifisere krypteringstype for passordfeltet i tabellen.',
        'If "DB" was selected for Customer::AuthModule, the name of the column for the CustomerKey in the customer table must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må feltnavnet som skal kobles til CustomerKey spesifiseres.',
        'If "DB" was selected for Customer::AuthModule, the name of the table where your customer data should be stored must be specified.' =>
            'Hvis "DB" er valgt som Customer::AuthModule må man skrive inn navnet på tabellen for lagring av kundedata.',
        'If "DB" was selected for SessionModule, a table in database where session data will be stored must be specified.' =>
            'Hvis "DB" er valgt for SessionModule må man spesifisere tabellnavnet for lagring av sesjonsdata.',
        'If "FS" was selected for SessionModule, a directory where the session data will be stored must be specified.' =>
            'Hvis "FS" er valgt for SessionModule må man spesifisere en mappe som kan brukes til lagring av sesjonsdata.',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify (by using a RegExp) to strip parts of REMOTE_USER (e. g. for to remove trailing domains). RegExp-Note, $1 will be the new Login.' =>
            '',
        'If "HTTPBasicAuth" was selected for Customer::AuthModule, you can specify to strip leading parts of user names (e. g. for domains like example_domain\user to user).' =>
            'Hvis "HTTPBasicAuth" er valgt som Customer::AuthModule kan du velge å ta vekk deler av brukernavnet (f.eks. gjøre "domene\bruker" om til "bruker").',
        'If "LDAP" was selected for Customer::AuthModule and if you want to add a suffix to every customer login name, specifiy it here, e. g. you just want to write the username user but in your LDAP directory exists user@domain.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule og du vil legge til en tekst til etter brukernavnet (f.eks. endre "brukernavn" til "brukernavn@domene") kan du spesifisere dette her.',
        'If "LDAP" was selected for Customer::AuthModule and special paramaters are needed for the Net::LDAP perl module, you can specify them here. See "perldoc Net::LDAP" for more information about the parameters.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule og du trenger spesielle parametre for LDAP-modulen Net::LDAP kan du spesifisere dem her. Se "perldoc Net::LDAP" for mer info om parametrene.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the password for this special user here.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule og brukerne kun har anonym tilgang til LDAP-treet kan du spesifisere en egen bruker for søking. Passordet til denne brukeren skrives inn her.',
        'If "LDAP" was selected for Customer::AuthModule and your users have only anonymous access to the LDAP tree, but you want to search through the data, you can do this with a user who has access to the LDAP directory. Specify the username for this special user here.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule og brukerne kun har anonym tilgang til LDAP-treet kan du spesifisere en egen bruker for søking. Brukernavnet til denne brukeren skrives inn her',
        'If "LDAP" was selected for Customer::AuthModule, the BaseDN must be specified.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule må Base DN skrives inn her.',
        'If "LDAP" was selected for Customer::AuthModule, the LDAP host can be specified.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan du skrive inn LDAP-tjeneren her',
        'If "LDAP" was selected for Customer::AuthModule, the user identifier must be specified.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule må brukernes id-felt spesifiseres her (f.eks. uid).',
        'If "LDAP" was selected for Customer::AuthModule, user attributes can be specified. For LDAP posixGroups use UID, for non LDAP posixGroups use full user DN.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan brukernes attributter settes opp. For LDAP posixGroups brukes UID, for andre må full bruker-DN brukes.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify access attributes here.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan du spesifisere tilgangsoppsett her.',
        'If "LDAP" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan du velge at systemet vil stoppe opp hvis f.eks. tilkoplingen til en tjener ikke kan gjøres pga. nettverksproblemer.',
        'If "LDAP" was selected for Customer::Authmodule, you can check if the user is allowed to authenticate because he is in a posixGroup, e.g. user needs to be in a group xyz to use OTRS. Specify the group, who may access the system.' =>
            '',
        'If "LDAP" was selected, you can add a filter to each LDAP query, e.g. (mail=*), (objectclass=user) or (!objectclass=computer).' =>
            'Hvis "LDAP" er valgt som Customer::AuthModule kan du sette et filter for alle LDAP-søk. F.eks. (mail=*), (objectclass=user) eller (!objectclass=computer)',
        'If "Radius" was selected for Customer::AuthModule, the password to authenticate to the radius host must be specified.' =>
            'Hvis "Radius" er valgt som Customer::AuthModule må du skrive inn passordet som autentiserer mot radius-tjeneren.',
        'If "Radius" was selected for Customer::AuthModule, the radius host must be specified.' =>
            'Hvis "Radius" er valgt som Customer::AuthModule må du skrive inn adressen til Radius-tjeneren her.',
        'If "Radius" was selected for Customer::AuthModule, you can specify if the applications will stop if e. g. a connection to a server can\'t be established due to network problems.' =>
            'Hvis "Radius" er valgt som Customer::AuthModule kan du velge at systemet vil stoppe opp om Radius-tjeneren ikke lenger er tilgjengelig pga. nettverksproblemer el.l.',
        'If "Sendmail" was selected as SendmailModule, the location of the sendmail binary and the needed options must be specified.' =>
            'Hvis "Sendmail" er valgt som SendmailModule må du sette opp stien til sendmail-programmet, samt evt. nødvendige tilleggsvalg.',
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
            'Hvis noen av "SMTP"-mekanismene er valgt som SendmailModule, og autentisering mot e-post-tjeneren er nødvendig, må et passord spesifiseres.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, and authentication to the mail server is needed, an username must be specified.' =>
            'Hvis noen av "SMTP"-mekanismene er valgt som SendmailModule, og autentisering mot e-post-tjeneren er nødvendig, må et brukernavn spesifiseres',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the mailhost that sends out the mails must be specified.' =>
            'Hvis noen av "SMTP"-mekanismene er valgt som SendmailModule, må e-post-tjeneren som sender ut e-post spesifiseres.',
        'If any of the "SMTP" mechanisms was selected as SendmailModule, the port where your mailserver is listening for incoming connections must be specified.' =>
            'Hvis noen av "SMTP"-mekanismene er valgt som SendmailModule, må porten der din e-post-tjener lytter på innkommende forbindelser spesifiseres. ',
        'If enabled, OTRS will deliver all CSS files in minified form. WARNING: If you turn this off, there will likely be problems in IE 7, because it cannot load more than 32 CSS files.' =>
            '',
        'If enabled, OTRS will deliver all JavaScript files in minified form.' =>
            'Hvis slått på vil OTRS levere alle JavaScript-filer i minimert form',
        'If enabled, TicketPhone and TicketEmail will be open in new windows.' =>
            'Hvis slått på vil telefonsak og e-postsak bli åpnet i nye vinduer.',
        'If enabled, the OTRS version tag will be removed from the HTTP headers.' =>
            'Hvis slått på vil OTRS-versjonen bli fjernet fra HTTP-headeren',
        'If enabled, the different overviews (Dashboard, LockedView, QueueView) will automatically refresh after the specified time.' =>
            'Hvis slått på vil de forskjellige oversiktene (Kontrollpanel, kø-oversikt, osv.) automatisk oppdateres etter angitt tid.',
        'If enabled, the first level of the main menu opens on mouse hover (instead of click only).' =>
            '',
        'If set, this address is used as envelope sender header in outgoing notifications. If no address is specified, the envelope sender header is empty.' =>
            '',
        'If this regex matches, no message will be send by the autoresponder.' =>
            'Hvis denne Regulær-uttrykk-setningen slår til vil ikke autosvar bli sendt.',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, specify the DSN to this database.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the password to authenticate to this database can be specified.' =>
            '',
        'If you want to use a mirror database for agent ticket fulltext search or to generate stats, the user to authenticate to this database can be specified.' =>
            '',
        'Ignore article with system sender type for new article feature (e. g. auto responses or email notifications).' =>
            '',
        'Includes article create times in the ticket search of the agent interface.' =>
            'Inkluder opprettelsestidspunkt i søkedelen av agentdelen.',
        'IndexAccelerator: to choose your backend TicketViewAccelerator module. "RuntimeDB" generates each queue view on the fly from ticket table (no performance problems up to approx. 60.000 tickets in total and 6.000 open tickets in the system). "StaticDB" is the most powerful module, it uses an extra ticket-index table that works like a view (recommended if more than 80.000 and 6.000 open tickets are stored in the system). Use the script "bin/otrs.RebuildTicketIndex.pl" for initial index update.' =>
            '',
        'Install ispell or aspell on the system, if you want to use a spell checker. Please specify the path to the aspell or ispell binary on your operating system.' =>
            '',
        'Interface language' => 'Språk for grensesnittet',
        'It is possible to configure different skins, for example to distinguish between diferent agents, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different skins, for example to distinguish between diferent customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid skin on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'It is possible to configure different themes, for example to distinguish between agents and customers, to be used on a per-domain basis within the application. Using a regular expression (regex), you can configure a Key/Content pair to match a domain. The value in "Key" should match the domain, and the value in "Content" should be a valid theme on your system. Please see the example entries for the proper form of the regex.' =>
            '',
        'Link agents to groups.' => 'Koble saksbehandlere til grupper',
        'Link agents to roles.' => 'Koble saksbehandlere til roller',
        'Link attachments to responses templates.' => 'Koble vedlegg til svarmaler',
        'Link customers to groups.' => 'Koble kunder til grupper',
        'Link customers to services.' => 'Koble kunder til tjenester',
        'Link queues to auto responses.' => 'Koble køer til autosvar',
        'Link responses to queues.' => 'Koble svar til køer',
        'Link roles to groups.' => 'Koble roller til grupper.',
        'Links 2 tickets with a "Normal" type link.' => 'Koble 2 saker med en "normal" lenke',
        'Links 2 tickets with a "ParentChild" type link.' => 'Koble 2 saker med en hierarkisk lenke',
        'List of CSS files to always be loaded for the agent interface.' =>
            'Liste med CSS-filer som alltid skal lastes for agentdelen',
        'List of CSS files to always be loaded for the customer interface.' =>
            'Liste med CSS-filer som alltid skal lastes for kundeportalen',
        'List of IE7-specific CSS files to always be loaded for the customer interface.' =>
            'Liste med IE7-spesifikke CSS-filer som alltid skal lastes for kundeportalen',
        'List of IE8-specific CSS files to always be loaded for the agent interface.' =>
            'Liste med IE8-CSS-filer som alltid skal lastes for agentdelen',
        'List of IE8-specific CSS files to always be loaded for the customer interface.' =>
            'Liste med IE8-spesifikke CSS-filer som alltid skal lastes for kundeportalen',
        'List of JS files to always be loaded for the agent interface.' =>
            'Liste over JS-filer som alltid skal lastes for agentdelen',
        'List of JS files to always be loaded for the customer interface.' =>
            'Liste over JS-filer som alltid skal lastes for kundeportalen',
        'List of default StandardResponses which are assigned automatically to new Queues upon creation.' =>
            '',
        'Log file for the ticket counter.' => 'Loggfil for sakstelleren',
        'Mail Accounts' => 'E-postkontoer',
        'Main menu registration.' => '',
        'Makes the application check the MX record of email addresses before sending an email or submitting a telephone or email ticket.' =>
            'Gjør at systemet sjekker MX-oppføringen for e-postadressen før det sender en e-post eller oppretter en telefonsak eller e-postsak.',
        'Makes the application check the syntax of email addresses.' => 'Gjør at systemet sjekker at en e-postadresse er skrevet på riktig måte.',
        'Makes the picture transparent.' => 'Gjør bildet gjennomsiktig.',
        'Makes the session management use html cookies. If html cookies are disabled or if the client browser disabled html cookies, then the system will work as usual and append the session id to the links.' =>
            'Gjør at sesjoner bruker informasjonskapsler (cookies). Dersom dette er slått av på klientens nettleser vil systemet legge til sesjons-ID i lenkene.',
        'Manage PGP keys for email encryption.' => 'Adminstrasjon av PGP-nøkler for kryptering og signering av e-poster',
        'Manage POP3 or IMAP accounts to fetch email from.' => 'Administrasjon av POP3- og IMAP-kontoer for innkommende e-post',
        'Manage S/MIME certificates for email encryption.' => 'Adminstrasjon av S/MIME-sertifikater for e-postkryptering',
        'Manage existing sessions.' => 'Administrasjon av aktive sesjoner',
        'Manage notifications that are sent to agents.' => 'Administrasjon av varslinger som sendes til saksbehandlerene.',
        'Manage periodic tasks.' => 'Administrasjon av periodiske oppgaver.',
        'Max size (in characters) of the customer information table (phone and email) in the compose screen.' =>
            'Maks. størrelse (antall tegn) for kundelisten (telefon og e-post) i opprett-skjermen.',
        'Max size (in rows) of the informed agents box in the agent interface.' =>
            '',
        'Max size (in rows) of the involved agents box in the agent interface.' =>
            '',
        'Max size of the subjects in an email reply.' => 'Maks. størrelse (antall tegn) for emner i e-post-svar.',
        'Maximal auto email responses to own email-address a day (Loop-Protection).' =>
            'Maksimum antall autosvar til egne e-postadresser per dag (beskyttelse mot e-post-looping)',
        'Maximal size in KBytes for mails that can be fetched via POP3/POP3S/IMAP/IMAPS (KBytes).' =>
            'Maks. størrelse (i kilobytes) på e-post som kan hentes via POP3/IMAP',
        'Maximum number of tickets to be displayed in the result of a search in the agent interface.' =>
            'Maks. antall viste saker i søkeresultater (agentdelen)',
        'Maximum number of tickets to be displayed in the result of a search in the customer interface.' =>
            'Maks. antall viste saker i søkeresultater (kundeportalen)',
        'Maximum size (in characters) of the customer information table in the ticket zoom view.' =>
            'Maks. størrelse (antall tegn) i kundeinfo-tabellen i saksdetaljer-visningen.',
        'Module for To-selection in new ticket screen in the customer interface.' =>
            'Modul for valg av mottaker når man oppretter ny sak i kundeportalen.',
        'Module to check customer permissions.' => 'Modul som sjekker kunders rettigheter.',
        'Module to check if a user is in a special group. Access is granted, if the user is in the specified group and has ro and rw permissions.' =>
            '',
        'Module to check if arrived emails should be marked as email-internal (because of original forwared internal email it college). ArticleType and SenderType define the values for the arrived email/article.' =>
            '',
        'Module to check the agent responsible of a ticket.' => 'Modul som sjekker ansvarlig agent for en sak.',
        'Module to check the group permissions for the access to customer tickets.' =>
            'Modul som sjekker grupperettigheter for tilgang til kundesaker',
        'Module to check the owner of a ticket.' => 'Modul som sjekker eieren for en sak.',
        'Module to check the watcher agents of a ticket.' => 'Modul som sjekker overvåking for en sak.',
        'Module to compose signed messages (PGP or S/MIME).' => 'Modul for å lage signerte meldinger (PGP eller S/MIME)',
        'Module to crypt composed messages (PGP or S/MIME).' => 'Modul for å kryptere meldinger (PGP eller S/MIME)',
        'Module to filter and manipulate incoming messages. Block/ignore all spam email with From: noreply@ address.' =>
            'Modul for å filtrere og manipulere innkommende meldinger Blokker/ignorer alle søppel-meldinger med "From: noreply@"-adresser',
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
        'Module to use database filter storage.' => 'Modul for å bruke databaselagring av filtre.',
        'Multiselect' => '',
        'My Tickets' => 'Mine saker',
        'Name of custom queue. The custom queue is a queue selection of your preferred queues and can be selected in the preferences settings.' =>
            '',
        'NameX' => '',
        'New email ticket' => 'Ny e-postsak',
        'New phone ticket' => 'Ny telefonsak',
        'New process ticket' => '',
        'Next possible ticket states after adding a phone note in the ticket phone inbound screen of the agent interface.' =>
            '',
        'Next possible ticket states after adding a phone note in the ticket phone outbound screen of the agent interface.' =>
            '',
        'Notifications (Event)' => 'Varslinger (Hendelse)',
        'Number of displayed tickets' => 'Antall viste saker',
        'Number of lines (per ticket) that are shown by the search utility in the agent interface.' =>
            'Antall linjer (per sak) som vises i søkeverktøyet.',
        'Number of tickets to be displayed in each page of a search result in the agent interface.' =>
            'Antall saker som vises per side i et søkeresultat.',
        'Number of tickets to be displayed in each page of a search result in the customer interface.' =>
            'Antall saker som vises per side i et søkeresultat i kundeportalen.',
        'Open tickets of customer' => 'Åpne saker for kunde',
        'Overloads (redefines) existing functions in Kernel::System::Ticket. Used to easily add customizations.' =>
            '',
        'Overview Escalated Tickets' => 'Oversikt over eskalerte saker',
        'Overview Refresh Time' => 'Oppdateringstid',
        'Overview of all open Tickets.' => 'Oversikt over alle åpne saker',
        'PGP Key Management' => 'Administrasjon: PGP Nøkkler',
        'PGP Key Upload' => 'Last opp PGP-nøkkel',
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
        'Permitted width for compose email windows.' => 'Tillatt bredde for "skriv e-post" vinduer.',
        'Permitted width for compose note windows.' => 'Tillatt bredde for "skriv notis" vinduer.',
        'Picture-Upload' => '',
        'PostMaster Filters' => 'Postmaster-filtre',
        'PostMaster Mail Accounts' => 'Postmaster e-postkontoer',
        'Process Information' => '',
        'Process Management Activity Dialog GUI' => '',
        'Process Management Activity GUI' => '',
        'Process Management Path GUI' => '',
        'Process Management Transition Action GUI' => '',
        'Process Management Transition GUI' => '',
        'Protection against CSRF (Cross Site Request Forgery) exploits (for more info see http://en.wikipedia.org/wiki/Cross-site_request_forgery).' =>
            '',
        'Queue view' => 'Køvisning',
        'Refresh Overviews after' => 'Oppdater oversikter etter',
        'Refresh interval' => 'Automatisk innlasting',
        'Removes the ticket watcher information when a ticket is archived.' =>
            '',
        'Replaces the original sender with current customer\'s email address on compose answer in the ticket compose screen of the agent interface.' =>
            '',
        'Required permissions to change the customer of a ticket in the agent interface.' =>
            'Nødvendige rettigheter for å endre kunde på en sak.',
        'Required permissions to use the close ticket screen in the agent interface.' =>
            'Nødvendige rettigheter for å bruke "Avslutt sak" bildet.',
        'Required permissions to use the ticket bounce screen in the agent interface.' =>
            '',
        'Required permissions to use the ticket compose screen in the agent interface.' =>
            'Nødvendige rettigheter for å bruke "Opprett sak" bildet.',
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
        'Responses <-> Queues' => 'Ferdigsvar <-> Køer',
        'Restores a ticket from the archive (only if the event is a state change, from closed to any open available state).' =>
            'Gjenoppretter en sak fra arkivet (kun hvis hendelsen er en statusendring, fra avsluttet til en vilkårlig åpen/tilgjengelig status).',
        'Roles <-> Groups' => 'Roller <-> Grupper',
        'Runs an initial wildcard search of the existing customer users when accessing the AdminCustomerUser module.' =>
            '',
        'Runs the system in "Demo" mode. If set to "Yes", agents can change preferences, such as selection of language and theme via the agent web interface. These changes are only valid for the current session. It will not be possible for agents to change their passwords.' =>
            '',
        'S/MIME Certificate Upload' => 'Opplasting av S/MIME-sertifikat',
        'Saves the attachments of articles. "DB" stores all data in the database (not recommended for storing big attachments). "FS" stores the data on the filesystem; this is faster but the webserver should run under the OTRS user. You can switch between the modules even on a system that is already in production without any loss of data.' =>
            '',
        'Search backend default router.' => '',
        'Search backend router.' => '',
        'Select your frontend Theme.' => 'Velg tema for webvisningen.',
        'Selects the cache backend to use.' => '',
        'Selects the module to handle uploads via the web interface. "DB" stores all uploads in the database, "FS" uses the file system.' =>
            '',
        'Selects the ticket number generator module. "AutoIncrement" increments the ticket number, the SystemID and the counter are used with SystemID.counter format (e.g. 1010138, 1010139). With "Date" the ticket numbers will be generated by the current date, the SystemID and the counter. The format looks like Year.Month.Day.SystemID.counter (e.g. 200206231010138, 200206231010139). With "DateChecksum"  the counter will be appended as checksum to the string of date and SystemID. The checksum will be rotated on a daily basis. The format looks like Year.Month.Day.SystemID.Counter.CheckSum (e.g. 2002070110101520, 2002070110101535). "Random" generates randomized ticket numbers in the format "SystemID.Random" (e.g. 100057866352, 103745394596).' =>
            '',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' =>
            'Send varsling hvis kunden sender en oppfølging og jeg eier saken, eller om saken er åpen og i en av mine abonnerte køer.',
        'Send notifications to users.' => 'Send varsling til brukerne',
        'Send ticket follow up notifications' => 'Send varsling om oppfølging på sak',
        'Sender type for new tickets from the customer inteface.' => 'Sendingstype for nye meldinger på kundeweben',
        'Sends agent follow-up notification only to the owner, if a ticket is unlocked (the default is to send the notification to all agents).' =>
            'Send varsling kun til sakens eier dersom en sak låses opp (normalt sendes meldingen til alle saksbehandlere).',
        'Sends all outgoing email via bcc to the specified address. Please use this only for backup reasons.' =>
            'Send all utgående e-post via Bcc til spesifisert adresse. Vennligst bruk dette kun for sikkerhetskopiering.',
        'Sends customer notifications just to the mapped customer. Normally, if no customer is mapped, the latest customer sender gets the notification.' =>
            'Send kundemeldinger kun til den oppsatte kundekontakten. Normalt vil kundens siste innsender få melding dersom ingen kundekontakt er spesifisert.',
        'Sends reminder notifications of unlocked ticket after reaching the reminder date (only sent to ticket owner).' =>
            'Sender en påminnelse om opplåsing av saker etter oppnådd tidsfrist (sendes kun til sakens eier).',
        'Sends the notifications which are configured in the admin interface under "Notfication (Event)".' =>
            'Sender varslingene som er spesifiserte i admin-delen under "Melding (Hendelse)"',
        'Set sender email addresses for this system.' => 'Sett opp avsenderadresse for denne installasjonen',
        'Set the default height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set the maximum height (in pixels) of inline HTML articles in AgentTicketZoom.' =>
            '',
        'Set this to yes if you trust in all your public and private pgp keys, even if they are not certified with a trusted signature.' =>
            '',
        'Sets if ticket owner must be selected by the agent.' => 'Angir om sakseier må velges av saksbehandleren.',
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
            'Viser alle åpne saker (også låste) i eskaleringsvinduet i agentdelen',
        'Shows all open tickets (even if they are locked) in the status view of the agent interface.' =>
            'Viser alle åpne saker (også låste) i statusvinduet i agentdelen',
        'Shows all the articles of the ticket (expanded) in the zoom view.' =>
            'Viser alle innlegg i saken (utvidet) i zoom-visning',
        'Shows all the customer identifiers in a multi-select field (not useful if you have a lot of customer identifiers).' =>
            'Viser alle kunde-identifikatorer i et multivalg-felt (ikke brukbart hvis du har mange identifikatorer)',
        'Shows an owner selection in phone and email tickets in the agent interface.' =>
            'Viser et eier-valg i telefon- og e-post-saker i agentdelen',
        'Shows colors for different article types in the article table.' =>
            'Viser farger for ulike artikkeltyper i artikkeltabellen',
        'Shows customer history tickets in AgentTicketPhone, AgentTicketEmail and AgentTicketCustomer.' =>
            'Viser kundehistorikk i agentdelen.',
        'Shows either the last customer article\'s subject or the ticket title in the small format overview.' =>
            'Viser enten emnet til siste kundeartikkel eller sakens emne i "liten" oversikt.',
        'Shows existing parent/child queue lists in the system in the form of a tree or a list.' =>
            'Viser eksisterende foredldre/barn kølister i systemet i form av et tre eller en liste',
        'Shows the activated ticket attributes in the customer interface (0 = Disabled and 1 = Enabled).' =>
            'Viser de aktiverte saksattributtene i kundeportalen (0 = Av og 1 = På)',
        'Shows the articles sorted normally or in reverse, under ticket zoom in the agent interface.' =>
            'Viser artiklene sortert normalt eller reversert i saksvisning i agentdelen.',
        'Shows the customer user information (phone and email) in the compose screen.' =>
            'Viser kundens brukerinformasjon (telefon og e-post) når man komponerer en sak',
        'Shows the customer user\'s info in the ticket zoom view.' => 'Viser kundebrukerens info i saksvisningen.',
        'Shows the message of the day (MOTD) in the agent dashboard. "Group" is used to restrict access to the plugin (e. g. Group: admin;group1;group2;). "Default" indicates if the plugin is enabled by default or if the user needs to enable it manually.' =>
            'Viser Dagens Melding (MOTD) i agent-kontrollpanelet. "Gruppe" brukes til å begrense tilgang til innstikket (f.eks. Gruppe: admin;gruppe1;gruppe2). "Standard" betyr at innstikket er slått på som standard, hvis ikke må saksbehandleren selv slå det på under Innstillinger',
        'Shows the message of the day on login screen of the agent interface.' =>
            'Viser Dagens Melding på innloggingsskjermen til agentdelen',
        'Shows the ticket history (reverse ordered) in the agent interface.' =>
            'Viser sakshistorikken (nyeste først) i agentdelen.',
        'Shows the ticket priority options in the close ticket screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for å avslutte saker',
        'Shows the ticket priority options in the move ticket screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for å flytte saker',
        'Shows the ticket priority options in the ticket bulk screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for å masseredigere saker.',
        'Shows the ticket priority options in the ticket free text screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for fritekst.',
        'Shows the ticket priority options in the ticket note screen of the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens skjerm for notiser',
        'Shows the ticket priority options in the ticket owner screen of a zoomed ticket in the agent interface.' =>
            'Viser sakens prioritetsvalg i agentdelens sakseier-skjerm i saksvisning',
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
            'Viser tiden i langt format (dager, timer, minutter) hvis satt til "ja", eller i kortformat (dager, timer) hvis satt til "nei"',
        'Shows time use complete description (days, hours, minutes), if set to "Yes"; or just first letter (d, h, m), if set to "No".' =>
            '',
        'Skin' => 'Webtema',
        'SolutionDiffInMin' => '',
        'SolutionInMin' => '',
        'Sorts the tickets (ascendingly or descendingly) when a single queue is selected in the queue view and after the tickets are sorted by priority. Values: 0 = ascending (oldest on top, default), 1 = descending (youngest on top). Use the QueueID for the key and 0 or 1 for value.' =>
            '',
        'Spam Assassin example setup. Ignores emails that are marked with SpamAssassin.' =>
            'Eksempeloppsett for SpamAssassin. Ignorerer e-poster som er merket av SpamAssassin.',
        'Spam Assassin example setup. Moves marked mails to spam queue.' =>
            'Eksempeloppsett for SpamAssassin. Flytter merkede e-poster til køen for søppelpost.',
        'Specifies if an agent should receive email notification of his own actions.' =>
            'Angir om en agent skal motta e-postvarsling om sine egne handlinger.',
        'Specifies the available note types for this ticket mask. If the option is deselected, ArticleTypeDefault is used and the option is removed from the mask.' =>
            '',
        'Specifies the background color of the chart.' => 'Setter bakgrunnsfarge for grafer.',
        'Specifies the background color of the picture.' => 'Setter bakgrunnsfarge for bildet.',
        'Specifies the border color of the chart.' => 'Setter farge på rammen til grafer.',
        'Specifies the border color of the legend.' => 'Setter farge på rammen til symbolforklaringen.',
        'Specifies the bottom margin of the chart.' => 'Spesifiserer bunnmarg på grafene.',
        'Specifies the different article types that will be used in the system.' =>
            'Spesifiserer de ulike artikkeltypene som skal brukes i systemet.',
        'Specifies the different note types that will be used in the system.' =>
            'Spesifiserer de forskjellige notis-typene som skal brukes i systemet.',
        'Specifies the directory to store the data in, if "FS" was selected for TicketStorageModule.' =>
            'Spesifiserer mappen der data skal lagres dersom "FS" er valgt for lagring av saker.',
        'Specifies the directory where SSL certificates are stored.' => 'Spesifiserer mappen der SSL-sertifikatene lagres',
        'Specifies the directory where private SSL certificates are stored.' =>
            'Spesifiserer mappen der private SSL-sertifikater lagres.',
        'Specifies the email address that should be used by the application when sending notifications. The email address is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). You can use the OTRS_CONFIG_FQDN variable as set in your configuation, or choose another email address. Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Spesifiserer e-postadressen som skal brukes av systemet når det sender varslinger. e-postadressen brukes til å bygge opp det komplette visningsnavnet for varslingsautomaten (dvs. "OTRS Varslingsautomat" otrs@din.server.no). Du kan bruke variabelen OTRS_CONFIG_FQDN satt i oppsettet, eller velge en annen e-postadresse. Varslinger er slike som nb_NO::Customer::QueueUpdate eller nb_NO::Agent::Move.',
        'Specifies the group where the user needs rw permissions so that he can access the "SwitchToCustomer" feature.' =>
            '',
        'Specifies the left margin of the chart.' => 'Spesifiserer venstre marg for grafer.',
        'Specifies the name that should be used by the application when sending notifications. The sender name is used to build the complete display name for the notification master (i.e. "OTRS Notification Master" otrs@your.example.com). Notifications are messages such as en::Customer::QueueUpdate or en::Agent::Move.' =>
            'Spesifiserer navnet som skal brukes av systemet når det sender varslinger. Navnet brukes til å bygge opp det komplette visningsnavnet for varslingsautomaten (dvs. "OTRS Meldingsautomat" otrs@din.server.no). Du kan bruke variabelen OTRS_CONFIG_FQDN satt i oppsettet, eller velge en annen e-postadresse. Varslinger er slike som nb_NO::Customer::QueueUpdate eller nb_NO::Agent::Move.',
        'Specifies the path of the file for the logo in the page header (gif|jpg|png, 700 x 100 pixel).' =>
            'Spesifiserer stien til logofilen i toppen av siden (gif|jpg|png, 700x100 piksler).',
        'Specifies the path of the file for the performance log.' => 'Spesifiserer stien til ytelseslogg-filen.',
        'Specifies the path to the converter that allows the view of Microsoft Excel files, in the web interface.' =>
            'Spesifiserer stien til konverteringsprogrammet som tillater visning av Microsoft Excel-filer i webvisningen',
        'Specifies the path to the converter that allows the view of Microsoft Word files, in the web interface.' =>
            'Spesifiserer stien til konverteringsprogrammet som tillater visning av Microsoft Word-filer i webvisningen',
        'Specifies the path to the converter that allows the view of PDF documents, in the web interface.' =>
            'Spesifiserer stien til konverteringsprogrammet som tillater visning av PDF-filer i webvisningen',
        'Specifies the path to the converter that allows the view of XML files, in the web interface.' =>
            'Spesifiserer stien til konverteringsprogrammet som tillater visning av XML-filer',
        'Specifies the right margin of the chart.' => 'Spesifiserer høyremarg for grafer',
        'Specifies the text color of the chart (e. g. caption).' => 'Spesifiserer tekstfarge for grafer (f.eks. overskrift).',
        'Specifies the text color of the legend.' => 'Spesifiserer tekstfarge for symbolforklaringen.',
        'Specifies the text that should appear in the log file to denote a CGI script entry.' =>
            'Spesifiserer teksten som skal skrives til loggfilen for å markere et innslag fra et CGI-script.',
        'Specifies the top margin of the chart.' => 'Spesifiserer toppmarg for grafer.',
        'Specifies user id of the postmaster data base.' => 'Spesifiserer bruker-id for postmaster-databasen',
        'Specify how many sub directory levels to use when creating cache files. This should prevent too many cache files being in one directory.' =>
            '',
        'Standard available permissions for agents within the application. If more permissions are needed, they can be entered here. Permissions must be defined to be effective. Some other good permissions have also been provided built-in: note, close, pending, customer, freetext, move, compose, responsible, forward, and bounce. Make sure that "rw" is always the last registered permission.' =>
            'Standard tilgjengelige rettigheter for saksbehandlere i systemet. Hvis flere rettigheter trengs kan de skrives inn her. Noen andre fine rettigheter finnes også innebygde: note, close, pending, customer, freetext, move, compose, responsible, forward og bounce. Pass på at "rw" alltid er den siste i listen.',
        'Start number for statistics counting. Every new stat increments this number.' =>
            'Starttall for statistikktelling. Nye statistikker legger til på dette tallet.',
        'Starts a wildcard search of the active object after the link object mask is started.' =>
            '',
        'Statistics' => 'Statistikk',
        'Status view' => 'Statusvisning',
        'Stop words for fulltext index. These words will be removed.' => '',
        'Stores cookies after the browser has been closed.' => 'Lagrer informasjonskapsler (cookies) etter at nettleseren har blitt stengt.',
        'Strips empty lines on the ticket preview in the queue view.' => 'Tar vekk tomme linjer i saksvisningen i kølisten',
        'Textarea' => 'Tekstareale',
        'The "bin/PostMasterMailAccount.pl" will reconnect to POP3/POP3S/IMAP/IMAPS host after the specified count of messages.' =>
            'Skriptet "bin/PostMasterMailAccount.pl" vil koble til e-posttjeneren (POP3/POP3S/IMAP/IMAPS) på nytt etter det spesifiserte antall meldinger.',
        'The agent skin\'s InternalName which should be used in the agent interface. Please check the available skins in Frontend::Agent::Skins.' =>
            '',
        'The customer skin\'s InternalName which should be used in the customer interface. Please check the available skins in Frontend::Customer::Skins.' =>
            '',
        'The divider between TicketHook and ticket number. E.g \': \'.' =>
            'Skilletegnet mellom TicketHook og saksnummeret, f.eks. ":"',
        'The duration in minutes after emitting an event, in which the new escalation notify and start events are suppressed.' =>
            '',
        'The format of the subject. \'Left\' means \'[TicketHook#:12345] Some Subject\', \'Right\' means \'Some Subject [TicketHook#:12345]\', \'None\' means \'Some Subject\' and no ticket number. In the last case you should enable PostmasterFollowupSearchInRaw or PostmasterFollowUpSearchInReferences to recognize followups based on email headers and/or body.' =>
            '',
        'The headline shown in the customer interface.' => 'Overskriften som vises i kundeportalen',
        'The identifier for a ticket, e.g. Ticket#, Call#, MyTicket#. The default is Ticket#.' =>
            'Identifikatoren for en sak, f.eks. Sak#, Ticket#, MinSak#. Standard er Ticket#',
        'The logo shown in the header of the agent interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown in the header of the customer interface. The URL to the image can be a relative URL to the skin image directory, or a full URL to a remote web server.' =>
            '',
        'The logo shown on top of the login box of the agent interface. The URL to the image must be relative URL to the skin image directory.' =>
            'Logoen som synes over innloggingsboksen i agentdelen. URLen må være relativ til image-mappen i den valgte temamappen.',
        'The text at the beginning of the subject in an email reply, e.g. RE, AW, or AS.' =>
            'Teksten i begynnelsen av emnet på et e-post-svar, f.eks. RE, SV',
        'The text at the beginning of the subject when an email is forwarded, e.g. FW, Fwd, or WG.' =>
            'Teksten i begynnelsen av emnet på en e-post som er videresendt, f.eks. VS, FW',
        'This module and its PreRun() function will be executed, if defined, for every request. This module is useful to check some user options or to display news about new applications.' =>
            'Denne modulen og dens PreRun()-funksjon vil, hvis satt, bli kjørt ved hver forespørsel. Denne modulen er nyttig for å sjekke brukerinnstillinger eller for å vise nyheter om nye programmer el.l.',
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
        'Ticket overview' => 'Saksoversikt',
        'TicketNumber' => '',
        'Tickets' => 'Saker',
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
        'Update and extend your system with software packages.' => 'Oppdater og utvid systemet med programvarepakker',
        'Updates the ticket escalation index after a ticket attribute got updated.' =>
            '',
        'Updates the ticket index accelerator.' => '',
        'UserFirstname' => '',
        'UserLastname' => '',
        'Uses Cc recipients in reply Cc list on compose an email answer in the ticket compose screen of the agent interface.' =>
            '',
        'Uses richtext for viewing and editing: articles, salutations, signatures, standard responses, auto responses and notifications.' =>
            'Bruker rikt tekstformat for visning og redigerer: innlegg, hilsninger, signaturer, standardsvar, autosvar og varslinger.',
        'View performance benchmark results.' => 'Vis resultater etter ytelsesmålinger',
        'View system log messages.' => 'Vis systemloggmeldinger',
        'Wear this frontend skin' => 'Bruk dette webtemaet (skin)',
        'Webservice path separator.' => '',
        'When tickets are merged, a note will be added automatically to the ticket which is no longer active. In this text area you can define this text (This text cannot be changed by the agent).' =>
            '',
        'When tickets are merged, the customer can be informed per email by setting the check box "Inform Sender". In this text area, you can define a pre-formatted text which can later be modified by the agents.' =>
            '',
        'Your queue selection of your favorite queues. You also get notified about those queues via email if enabled.' =>
            'Her velger du dine utvalgte køer. Du vil også få varslinger fra disse køene, hvis du har valgt det.',

        #
        # OBSOLETE ENTRIES FOR REFERENCE, DO NOT TRANSLATE!
        #
        'Adds customers email addresses to recipients in the ticket compose screen of the agent interface.' =>
            'Legger til kunders e-postadresser som mottakere under Opprett Sak for saksbehandlere.',
        'Allows extended search conditions in ticket search of the agent interface. With this feature you can search w. g. with this kind of conditions like "(key1&&key2)" or "(key1||key2)".' =>
            'Tillater avanserte søkekriterier i søk etter saker for saksbehandlere. Med denne funksjonaliteten kan du søke med kriterier som "(søk1&&søk2)" eller "(søk1||søk2)".',
        'Configures the full-text index. Execute "bin/otrs.RebuildFulltextIndex.pl" in order to generate a new index.' =>
            'Setter opp fulltekstindeksen. Kjør "bin/otrs.RebuildFulltextIndex.pl" for å opprette en ny indeks.',
        'Customer Data' => 'Kundeinformasjon',
        'Did not find a required feature? OTRS Group provides their subscription customers with exclusive Add-Ons:' =>
            'Fant du ikke et ønsket tillegg? OTRS gruppen tilbyr deres medlemmer eksklusive tillegg som:',
        'For more info see:' => 'For mer info se:',
        'Logout successful. Thank you for using OTRS!' => 'Utlogging utført.  Takk for at du brukte OTRS!',
        'Maximum size (in characters) of the customer info table in the queue view.' =>
            'Maks. størrelse (antall tegn) i kundeinfo-tabellen i kølisten.',
        'Package verification failed!' => 'Pakkevalidering feilet!',
        'Please supply a' => 'Vennligst oppgi en',
        'Please supply a first name' => 'Vennligst skriv inn et fornavn',
        'Please supply a last name' => 'Vennligst skriv inn et etternavn',
        'Secure mode must be disabled in order to reinstall using the web-installer.' =>
            'Sikkermodus må skrus av for å re-installere via web-installerer.',

    };
    # $$STOP$$
    return;
}

1;
