# --
# Kernel/Language/da.pm - provides da (Danish) language translation
# Copyright (C) 2006 Thorsten Rossner <thorsten.rossner[at]stepstone.de>
# Copyright (C) 2007-2008 Mads N. Vestergaard <mnv[at]timmy.dk>
# Copyright (C) 2010 Jesper Ulrik Rønnov <jeron[at]faaborgmidtfyn.dk>
# Copyright (C) 2010 Lars Jorgensen <itlj[at]gyldendal.dk>
# --
# $Id: da.pm,v 1.78 2010-12-01 15:22:14 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --
package Kernel::Language::da;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = qw($Revision: 1.78 $) [1];

sub Data {
    my $Self = shift;

    # $$START$$
    # Last translation file sync: Sat Jun 27 13:54:57 2009

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Year;)
    $Self->{DateFormat}          = '%D.%M.%Y %T';
    $Self->{DateFormatLong}      = '%A %D %B %T %Y';
    $Self->{DateFormatShort}     = '%D.%M.%Y';
    $Self->{DateInputFormat}     = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

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
        'day' => 'dag',
        'days' => 'dage',
        'day(s)' => 'dag(e)',
        'hour' => 'time',
        'hours' => 'timer',
        'hour(s)' => 'time(r)',
        'minute' => 'minut',
        'minutes' => 'minutter',
        'minute(s)' => 'minut(ter)',
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
        'wrote' => 'skrev',
        'Message' => 'Meddelelse',
        'Error' => 'Fejl',
        'Bug Report' => 'Fejlrapport',
        'Attention' => 'OBS',
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
        'invalid' => 'ugyldig',
        '* invalid' => '* ugyldig',
        'invalid-temporarily' => 'ugyldig-midlertidigt',
        ' 2 minutes' => '2 minutter',
        ' 5 minutes' => '5 minutter',
        ' 7 minutes' => '7 minutter',
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
        'Lite' => 'Let',
        'User' => 'Bruger',
        'Username' => 'Brugernavn',
        'Language' => 'Sprog',
        'Languages' => 'Sprog',
        'Password' => 'Adgangskode',
        'Salutation' => 'Indledning',
        'Signature' => 'Signatur',
        'Customer' => 'Kunde',
        'CustomerID' => 'Kunde-ID',
        'CustomerIDs' => 'Kunde-ID\'er',
        'customer' => 'kunde',
        'agent' => 'agent',
        'system' => 'system',
        'Customer Info' => 'Kundeinfo',
        'Customer Company' => 'Kunde Firma',
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
        'Valid' => 'Gyldig',
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
        'Changed' => 'Udskiftet',
        'Changed by' => 'Udskiftet af',
        'Search' => 'Søg',
        'and' => 'og',
        'between' => 'mellem',
        'Fulltext Search' => 'Fritekstsøgning',
        'Fulltext-Search' => 'Fritekstsøgning',
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
        'New message' => 'Ny meddelelse',
        'New message!' => 'Ny meddelelse!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Vær venlig at besvare én eller flere sager for at komme tilbage til køens normale visning',
        'You got new message!' => 'Du har fået en ny meddelelse!',
        'You have %s new message(s)!' => 'Du har %s ny(e) meddelelse(r)!',
        'You have %s reminder ticket(s)!' => 'Du har %s påmindelses sag(er)!',
        'The recommended charset for your language is %s!' => 'Det anbefalede tegnsæt til dit sprog er %s!',
        'Passwords doesn\'t match! Please try it again!' => 'Adgangskoderne er ikke ens! Prøv igen!',
        'Password is already in use! Please use an other password!' => 'Adgangskoden er allerede i brug! Brug venligst en anden adgangskode!',
        'Password is already used! Please use an other password!' => 'Adgangskoden er allerede brugt! Brug venligst en anden adgangskode!',
        'You need to activate %s first to use it!' => 'Du skal først aktivere %s for at bruge den!',
        'No suggestions' => 'Ingen forslag',
        'Word' => 'Ord',
        'Ignore' => 'Ignorer',
        'replace with' => 'udskift med',
        'There is no account with that login name.' => 'Der er ingen konto med det login-navn.',
        'Login failed! Your username or password was entered incorrectly.' => 'Login mislykkedes. Brugernavnet eller adgangskoden blev forkert indtastet.',
        'Please contact your admin' => 'Kontakt din administrator',
        'Logout successful. Thank you for using OTRS!' => 'Du er nu logget ud. Tak fordi du bruger OTRS.',
        'Invalid SessionID!' => 'Ugyldigt sessions-ID',
        'Feature not active!' => 'Funktionen er ikke aktiv',
        'Notification (Event)' => 'Beskeder (Event)',
        'Login is needed!' => 'Login er påkrævet',
        'Password is needed!' => 'Adgangskode er påkrævet',
        'License' => 'Licens',
        'Take this Customer' => 'Tag denne kunde',
        'Take this User' => 'Tag denne bruger',
        'possible' => 'mulig',
        'reject' => 'afvis',
        'reverse' => 'omvendt',
        'Facility' => 'Facilitet',
        'Timeover' => 'Tidsoverskridelse',
        'Pending till' => 'Afventer til',
        'Don\'t work with UserID 1 (System account)! Create new users!' => 'Arbejd ikke med bruger-ID 1 (systemkonto)! Opret nye brugere!',
        'Dispatching by email To: field.' => 'Sendes via e-mail til: felt.',
        'Dispatching by selected Queue.' => 'Sendes via den valgte kø.',
        'No entry found!' => 'Ingen post fundet',
        'Session has timed out. Please log in again.' => 'Sessionens tidsfrist er udløbet. Vær venlig at logge ind igen.',
        'No Permission!' => 'Ingen tilladelse.',
        'To: (%s) replaced with database email!' => 'Til: (%s) udskiftet med e-mail fra database.',
        'Cc: (%s) added database email!' => 'Cc: (%s) tilføjet e-mail fra database.',
        '(Click here to add)' => '(Klik her for at tilføje)',
        'Preview' => 'Vis udskrift',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Pakke ikke korrekt installeret. Du bør installere pakken igen.',
        'Added User "%s"' => 'Tilføjet bruger "%s"',
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
        'Security Note: You should activate %s because application is already running!' => 'Sikkerheds advarsel: Du skal aktivere %s fordi applikationen allerede kører!',
        'Unable to parse Online Repository index document!' => 'Det var ikke muligt at læse Online Repositoryets index dokument',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => 'Der var ingen pakker for the valgte Framework i Online Repositoryet, der var dog pakker til andre Frameworks!',
        'No Packages or no new Packages in selected Online Repository!' => 'Der var ingen pakker, eller ingen nye pakker i det valgte Online Repository.',
        'printed at' => 'printet den',
        'Dear Mr. %s,' => 'Kære Hr. %s',
        'Dear Mrs. %s,' => 'Kære Fru. %s',
        'Dear %s,' => 'Kære %s',
        'Hello %s,' => 'Hej %s',
        'This account exists.' => 'Denne konto eksisterer allerede.',
        'New account created. Sent Login-Account to %s.' => 'Ny konto er oprettet. Login informationer er sendt til %s.',
        'Please press Back and try again.' => 'Tryk venligst tilbage og prøv igen.',
        'Sent password token to: %s' => 'Kodeords kendetegn er sendt til: %s',
        'Sent new password to: %s' => 'Nyt kodeord er sendt til: %s',
        'Upcoming Events' => 'Forestående Events',
        'Event' => 'Event',
        'Events' => 'Events',
        'Invalid Token!' => 'Ugyldigt Token!',
        'more' => 'mere',
        'For more info see:' => 'For mere information se:',
        'Package verification failed!' => 'Pakkeverifikation fejlede!',
        'Collapse' => 'Sammenfold',
        'News' => 'Nyheder',
        'Product News' => 'Produktnyheder',
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
        'CTRL' => '',
        'SHIFT' => '',
        'Undo' => 'Fortryd',
        'Redo' => 'Gendan',

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

        # Template: AAANavBar
        'Admin-Area' => 'Admin-område',
        'Agent-Area' => 'Agent-område',
        'Ticket-Area' => 'Sags-Område',
        'Logout' => 'Log ud',
        'Agent Preferences' => 'Agent-indstillinger',
        'Preferences' => 'Indstillinger',
        'Agent Mailbox' => 'Agent-mailboks',
        'Stats' => 'Statistik',
        'Stats-Area' => 'Statistikområde',
        'Admin' => 'Administrator',
        'Customer Users' => 'Kundebrugere',
        'Customer Users <-> Groups' => 'Kundebrugere <-> Grupper',
        'Users <-> Groups' => 'Agenter <-> Grupper',
        'Roles' => 'Roller',
        'Roles <-> Users' => 'Roller <-> Agenter',
        'Roles <-> Groups' => 'Roller <-> Grupper',
        'Salutations' => 'Hilsner',
        'Signatures' => 'Underskrifter',
        'Email Addresses' => 'E-mailadresser',
        'Notifications' => 'Beskeder',
        'Category Tree' => 'Kategoritræ',
        'Admin Notification' => 'Besked til admin',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Indstillingerne er opdateret',
        'Mail Management' => 'Mailstyring',
        'Frontend' => 'Frontend',
        'Other Options' => 'Andre valgmuligheder',
        'Change Password' => 'Skift adgangskode',
        'New password' => 'Ny adgangskode',
        'New password again' => 'Ny adgangskode igen',
        'Select your QueueView refresh time.' => 'Vælg genindlæsningstid til køvisningen.',
        'Select your frontend language.' => 'Vælg dit sprog til frontend.',
        'Select your frontend Charset.' => 'Vælg dit tegnsæt til frontend.',
        'Select your frontend Theme.' => 'Vælg dit tema til frontend.',
        'Select your frontend QueueView.' => 'Vælg din køvisning til frontend.',
        'Spelling Dictionary' => 'Ordbog til stavekontrol',
        'Select your default spelling dictionary.' => 'Vælg din standardordbog til stavekontrol.',
        'Max. shown Tickets a page in Overview.' => 'Max. viste sager pr. side i oversigten.',
        'Can\'t update password, your new passwords do not match! Please try again!' => 'Kan ikke opdatere adgangskode, adgangskoderne er ikke ens! Prøv igen!',
        'Can\'t update password, invalid characters!' => 'Kan ikke opdatere adgangskode, ugyldige tegn!',
        'Can\'t update password, must be at least %s characters!' => 'Kan ikke opdatere adgangskode, der skal være mindst %s tegn!',
        'Can\'t update password, must contain 2 lower and 2 upper characters!' => 'Kan ikke opdatere adgangskode, der skal være 2 små og 2 store bogstaver!',
        'Can\'t update password, needs at least 1 digit!' => 'Kan ikke opdatere adgangskode, mindst 1 tal mangler!',
        'Can\'t update password, needs at least 2 characters!' => 'Kan ikke opdatere adgangskode, mindst 2 tegn mangler!',

        # Template: AAAStats
        'Stat' => 'Statistik',
        'Please fill out the required fields!' => 'Udfyld venligst de påkrævede felter.',
        'Please select a file!' => 'Vælg venligst en fil',
        'Please select an object!' => 'Vælg venligst et objekt',
        'Please select a graph size!' => 'Vælg venligst graf størrelse',
        'Please select one element for the X-axis!' => 'Vælg venligst et element til X-aksen',
        'Please select only one element or turn off the button \'Fixed\' where the select field is marked!' => 'Vælg venligst kun et element, eller vend knappen \'Fixed\' hvor feltet er markeret',
        'If you use a checkbox you have to select some attributes of the select field!' => 'For at bruge en checkbox, skal du vælge nogle attributter fra feltet',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Indtast venligst en værdi, i det valghte input felt, eller fra vælg \'Fixed\' checkboxen.',
        'The selected end time is before the start time!' => 'Den valgte sluttid, er før starttiden.',
        'You have to select one or more attributes from the select field!' => 'Du skal vælge en eller flere attributter fra det valgte felt.',
        'The selected Date isn\'t valid!' => 'Den valgte dato er ugyldig.',
        'Please select only one or two elements via the checkbox!' => 'Vælg kun ene eller 2 elemeter fra checkboksene.',
        'If you use a time scale element you can only select one element!' => 'Hvis du bruger en tidsskale, kan du kun vælge et element!',
        'You have an error in your time selection!' => 'Der er fejl i den valgte tid',
        'Your reporting time interval is too small, please use a larger time scale!' => 'Rapportens tidsinterval er for kort, vælg en større tidsskala.',
        'The selected start time is before the allowed start time!' => 'Den valgte starttid er før den tilladte starttid.',
        'The selected end time is after the allowed end time!' => 'Den valgte sluttid er senere end den tilladte sluttid.',
        'The selected time period is larger than the allowed time period!' => 'Den valgte tidsperiode er længere end den tilladte tidsperiode.',
        'Common Specification' => 'Fælles sspecifikationer',
        'Xaxis' => 'X-akse',
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
        'Created Priority' => 'Oprettet prioritet',
        'Created State' => 'Oprettet status',
        'Create Time' => 'Oprettet tid',
        'CustomerUserLogin' => 'KundeBrugerLogin',
        'Close Time' => 'Sluttid',
        'TicketAccumulation' => 'Sagsakkumulering',
        'Attributes to be printed' => 'Attributter til udskrift',
        'Sort sequence' => 'Sorteringsrækkefølge',
        'Order by' => 'Sorter efter',
        'Limit' => 'Grænse',
        'Ticketlist' => 'Sagsliste',
        'ascending' => 'stigende',
        'descending' => 'faldende',
        'First Lock' => 'Første lås',
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
        'Lock' => 'Træk',
        'Unlock' => 'Frigiv',
        'History' => 'Historik',
        'Zoom' => 'Vis',
        'Age' => 'Alder',
        'Bounce' => 'Retur til afsender',
        'Forward' => 'Videresend',
        'From' => 'Fra',
        'To' => 'Til',
        'Cc' => 'Cc',
        'Bcc' => 'Bcc',
        'Subject' => 'Emne',
        'Move' => 'Flyt',
        'Queue' => 'Kø',
        'Priority' => 'Prioritet',
        'Priority Update' => 'Opdatering af Prioritet',
        'State' => 'Status',
        'Compose' => 'Skrive',
        'Pending' => 'Afventer',
        'Owner' => 'Ejer',
        'Owner Update' => 'Ejer Opdatering',
        'Responsible' => 'Ansvarlig',
        'Responsible Update' => 'Opdatering af Ansvarlig',
        'Sender' => 'Afsender',
        'Article' => 'Indlæg',
        'Ticket' => 'Sager',
        'Createtime' => 'Oprettelsestid',
        'plain' => 'almindelig',
        'Email' => 'E-mail',
        'email' => 'e-mail',
        'Close' => 'Luk',
        'Action' => 'Handling',
        'Attachment' => 'Vedhæftet fil',
        'Attachments' => 'Vedhæftede filer',
        'This message was written in a character set other than your own.' => 'Denne meddelelse blev skrevet i et andet tegnsæt end dit eget.',
        'If it is not displayed correctly,' => 'Vises den ikke korrekt,',
        'This is a' => 'Dette er en',
        'to open it in a new window.' => 'for at åbne i et nyt vindue.',
        'This is a HTML email. Click here to show it.' => 'Dette er en e-mail i HTML. Klik her for at vise den.',
        'Free Fields' => 'Frie felter',
        'Merge' => 'Saml',
        'merged' => 'samlet',
        'closed successful' => 'Afsluttet og løst',
        'closed unsuccessful' => 'Afsluttet uden løsning',
        'new' => 'ny',
        'open' => 'åben',
        'Open' => 'Åben',
        'closed' => 'lukket',
        'Closed' => 'Lukket',
        'removed' => 'fjernet',
        'pending reminder' => 'afventer påmindelse',
        'pending auto' => 'afventer auto',
        'pending auto close+' => 'afventer autolukning+',
        'pending auto close-' => 'afventer autolukning-',
        'email-external' => 'email-ekstern',
        'email-internal' => 'email-intern',
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
        'Ticket "%s" created!' => 'Sag "%s" oprettet.',
        'Ticket Number' => 'Sagsnummer',
        'Ticket Object' => 'Sagsobjekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Sag nummer "%s" eksisterer ikke! Kan ikke sammenkæde den.',
        'Don\'t show closed Tickets' => 'Vis åbne sager',
        'Show closed Tickets' => 'Vis lukkede sager',
        'New Article' => 'Nyt indlæg',
        'Email-Ticket' => 'Mail-sag',
        'Create new Email Ticket' => 'Opret ny mail-sag',
        'Phone-Ticket' => 'Ny Sag',
        'StatusView' => 'Statusoversigt',
        'Search Tickets' => 'Søg sager',
        'Edit Customer Users' => 'Rediger kundebrugere',
        'Edit Customer Company' => 'Rediger kunde-firma',
        'Bulk Action' => 'Massehandling',
        'Bulk Actions on Tickets' => 'Massehandlinger på sager',
        'Send Email and create a new Ticket' => 'Send mail og opret en ny sag',
        'Create new Email Ticket and send this out (Outbound)' => 'Opret ny mail-sag, og send den (Outbound)',
        'Create new Phone Ticket (Inbound)' => 'Opret ny telefon-sag (Inbound)',
        'Overview of all open Tickets' => 'Oversigt over alle åbne sager',
        'Locked Tickets' => 'Mine sager',
        'My Locked Tickets' => 'Mine sager',
        'Watched Tickets' => 'Overvågede sager',
        'Watched' => 'Overvåget',
        'Subscribe' => 'Overvåg',
        'Unsubscribe' => 'Stop overvågning',
        'Lock it to work on it!' => 'Træk den for at arbejde på den.',
        'Unlock to give it back to the queue!' => 'Frigiv den for at give den tilbage til køen.',
        'Shows the ticket history!' => 'Vis saghistorik.',
        'Print this ticket!' => 'Udskriv denne sag.',
        'Change the ticket priority!' => 'Skift sagens prioritet.',
        'Change the ticket free fields!' => 'Skift sagens frie felter.',
        'Link this ticket to an other objects!' => 'Sammenkæd denne sag til et andet objekt.',
        'Change the ticket owner!' => 'Skift sagens ejer.',
        'Change the ticket customer!' => 'Skift sagens kunde.',
        'Add a note to this ticket!' => 'Tilføj en bemærkning til denne sag.',
        'Merge this ticket!' => 'Saml denne sag.',
        'Set this ticket to pending!' => 'Marker denne sag som afventende.',
        'Close this ticket!' => 'Luk denne sag.',
        'Look into a ticket!' => 'Se nærmere på en sag.',
        'Delete this ticket!' => 'Slet denne sag.',
        'Mark as Spam!' => 'Marker som spam.',
        'My Queues' => 'Mine køer',
        'Shown Tickets' => 'Viste Sager',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Din sag nummer "<OTRS_TICKET>" er blevet samlet med sag nummer "<OTRS_MERGE_TO_TICKET>".',
        'Ticket %s: first response time is over (%s)!' => 'Sag %s: Tidsgrænsen for første svar er overskredet (%s)!',
        'Ticket %s: first response time will be over in %s!' => 'Sag %s: Tidsgrænsen for første svar overskrides om %s!',
        'Ticket %s: update time is over (%s)!' => 'Sag %s: Opdateringstid er overskredet (%s)!',
        'Ticket %s: update time will be over in %s!' => 'Sag %s: Opdateringstid overskrides om %s!',
        'Ticket %s: solution time is over (%s)!' => 'Sag %s: Løsningstid er overskredet (%s)!',
        'Ticket %s: solution time will be over in %s!' => 'Sag %s: løsningstid overskrides om %s!',
        'There are more escalated tickets!' => 'Der er ikke flere eskalerede sager.',
        'New ticket notification' => 'Besked om ny sag',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Send mig en besked, hvis der er en ny sag i "Mine køer".',
        'Follow up notification' => 'Besked om opfølgning',
        'Send me a notification if a customer sends a follow up and I\'m the owner of the ticket or the ticket is unlocked and is in one of my subscribed queues.' => 'Send mig en besked, hvis en kunde sender en opfølgning, og jeg er denne sags indehaver.',
        'Ticket lock timeout notification' => 'Besked om sagsfrigivelse efter tidsfristens udløb',
        'Send me a notification if a ticket is unlocked by the system.' => 'Send mig en besked, hvis systemet frigiver en sag.',
        'Move notification' => 'Besked om flytning',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Send mig en besked, hvis en sag flyttes ind i en af "Mine køer".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Dit valg af foretrukne køer. Du får besked om handlinger i disse køer via e-mail, hvis det er aktiveret.',
        'Custom Queue' => 'Tilpasset kø',
        'QueueView refresh time' => 'Genindlæsningstid af kø-visningen',
        'Screen after new ticket' => 'Skærm efter oprettelse af ny sag',
        'Select your screen after creating a new ticket.' => 'Vælg din skærm, efter ioprettelse af ny sag.',
        'Closed Tickets' => 'Lukkede sager',
        'Show closed tickets.' => 'Vis lukkede sager.',
        'Max. shown Tickets a page in QueueView.' => 'Max. viste sager pr. side i kø-visning - QueueView.',
        'Watch notification' => 'Besked om overvågede sager',
        'Send me a notification of an watched ticket like an owner of an ticket.' => 'Send mig beskeder om en overvåget sag, som var jeg ejeren af sagen.',
        'Out Of Office' => 'Ude af kontoret',
        'Select your out of office time.' => 'Vælg din Ude-af-kontoret-tid',
        'CompanyTickets' => 'Virksomhedssager',
        'MyTickets' => 'Mine Sager',
        'New Ticket' => 'Ny sag',
        'Create new Ticket' => 'Opret ny sag',
        'Customer called' => 'Opkald fra Kunde',
        'phone call' => 'opringning',
        'Reminder Reached' => 'Påmindelsesdato nået',
        'Reminder Tickets' => 'Sager med påmindelser',
        'Escalated Tickets' => 'Eskalerede Sager',
        'New Tickets' => 'Nye Sager',
        'Open Tickets / Need to be answered' => 'Åbne Sager',
        'Tickets which need to be answered!' => 'Sager, der skal besvares!',
        'All new tickets!' => 'Alle nye sager.',
        'All tickets which are escalated!' => 'Alle eskalerede sager.',
        'All tickets where the reminder date has reached!' => 'Alle sager, hvor påmindelsesdatoen er nået',
        'Responses' => 'Svar',
        'Responses <-> Queue' => 'Svar <-> Kø',
        'Auto Responses' => 'Autosvar',
        'Auto Responses <-> Queue' => 'Autosvar <-> Kø',
        'Attachments <-> Responses' => 'Vedhæftede filer <-> Svar',
        'History::Move' => 'Historik::Flytning',
        'History::TypeUpdate' => 'Updated Type to %s (ID=%s).',
        'History::ServiceUpdate' => 'Updated Service to %s (ID=%s).',
        'History::SLAUpdate' => 'Updated SLA to %s (ID=%s).',
        'History::NewTicket' => 'Historik::NySag',
        'History::FollowUp' => 'Historik::Opfølgning',
        'History::SendAutoReject' => 'Historik::SendAutoAfslag',
        'History::SendAutoReply' => 'Historik::SendAutoSvar',
        'History::SendAutoFollowUp' => 'Historik::SendAutoOpfølgning',
        'History::Forward' => 'Historik::Videresend',
        'History::Bounce' => 'Historik::Retur til afsender',
        'History::SendAnswer' => 'Historik::SendSvar',
        'History::SendAgentNotification' => 'Historik::SendAgentBesked',
        'History::SendCustomerNotification' => 'Historik::SendKundeBesked',
        'History::EmailAgent' => 'Historik::E-mailAgent',
        'History::EmailCustomer' => 'Historik::E-mailKunde',
        'History::PhoneCallAgent' => 'Historik::TelefonOpkaldAgent',
        'History::PhoneCallCustomer' => 'Historik::TelefonOpkaldKunde',
        'History::AddNote' => 'Historik::TilføjBemærkning',
        'History::Lock' => 'Historik::Træk',
        'History::Unlock' => 'Historik::Frigiv',
        'History::TimeAccounting' => 'Historik::TidRegnskab',
        'History::Remove' => 'Historik::Fjern',
        'History::CustomerUpdate' => 'Historik::KundeOpdatering',
        'History::PriorityUpdate' => 'Historik::Prioritetsopdatering',
        'History::OwnerUpdate' => 'Historik::IndehaverOpdatering',
        'History::LoopProtection' => 'Historik::LoopBeskyttelse',
        'History::Misc' => 'Historik::Diverse',
        'History::SetPendingTime' => 'Historik::IndstilVentetid',
        'History::StateUpdate' => 'Historik::TilstandOpdatering',
        'History::TicketFreeTextUpdate' => 'Historik::SagFriTekstOpdatering',
        'History::WebRequestCustomer' => 'Historik::WebAnmodningKunde',
        'History::TicketLinkAdd' => 'Historik::SagLinkTilføj',
        'History::TicketLinkDelete' => 'Historik::SagLinkSlet',
        'History::Subscribe' => 'Historik::Tilmeld',
        'History::Unsubscribe' => 'Historik::Afmeld',

        # Template: AAAWeekDay
        'Sun' => 'Søn',
        'Mon' => 'Man',
        'Tue' => 'Tir',
        'Wed' => 'Ons',
        'Thu' => 'Tor',
        'Fri' => 'Fre',
        'Sat' => 'Lør',

        # Template: AdminAttachmentForm
        'Attachment Management' => 'Styring af vedhæftede filer',

        # Template: AdminAutoResponseForm
        'Auto Response Management' => 'Styring af autosvar',
        'Response' => 'Svar',
        'Auto Response From' => 'Autosvar fra',
        'Note' => 'Bemærkning',
        'Useable options' => 'Brugbare valgmuligheder',
        'To get the first 20 character of the subject.' => 'For at få de første 20 tegn af emnet.',
        'To get the first 5 lines of the email.' => 'For at få de første 5 linjer af emailen.',
        'To get the realname of the sender (if given).' => 'For at få afsenderes navn, hvis angivet.',
        'To get the article attribute (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => 'For at få indlæggets attributter (f.eks. <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> og <OTRS_CUSTOMER_Body>).',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => 'Muligheder for den nuværendes kundes data (f.eks. <OTRS_CUSTOMER_DATA_UserFirstname>).',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => 'Data om sagens ejer (f.eks. <OTRS_OWNER_UserFirstname>)',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => 'Data om sagens ansvarlige (f.eks. <OTRS_RESPONSIBLE_UserFirstname>).',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => 'data om bruger, der har udført denne handling (f.eks. <OTRS_CURRENT_UserFirstname>).',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => 'Data om sagen (f.eks. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => 'Data om konfigurationen (f.eks. <OTRS_CONFIG_HttpType>).',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => 'Kunde/Firma Administration',
        'Search for' => 'Søg efter',
        'Add Customer Company' => 'Tilføj kunde/firma',
        'Add a new Customer Company.' => 'Tilføj nyt Kunde/firma',
        'List' => 'Liste',
        'This values are required.' => 'Disse værdier er påkrævede.',
        'This values are read only.' => 'Disse værdier kan ikke ændres.',

        # Template: AdminCustomerUserForm
        'The message being composed has been closed.  Exiting.' => 'Den meddelelse, der er ved at blive skrevet, er blevet lukket. Afslutter.',
        'This window must be called from compose window' => 'Dette vindue skal åbnes via Skriv-vinduet.',
        'Customer User Management' => 'Styring af kundebruger',
        'Add Customer User' => 'Tilføj Kunde Bruger',
        'Source' => 'Kilde',
        'Create' => 'Opret',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Kundebrugeren er nødvendig for at have en kundehistorik og for at logge ind via kundepanelerne.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Kundebrugere <-> Gruppestyring',
        'Change %s settings' => 'Skift %s indstillinger',
        'Select the user:group permissions.' => 'Vælg rettigheder til brugeren:gruppen.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Er intet valgt, er der ingen rettigheder i denne gruppe (der er ingen tilgængelige sag til brugeren).',
        'Permission' => 'Tilladdelse',
        'ro' => 'ro',
        'Read only access to the ticket in this group/queue.' => 'Kun læseadgang til sager i denne gruppe/kø.',
        'rw' => 'rw',
        'Full read and write access to the tickets in this group/queue.' => 'Komplet læse- og skriveadgang til sagerne i denne gruppe/kø.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminCustomerUserService
        'Customer Users <-> Services Management' => 'Kunde Bruger <-> Service Administration',
        'CustomerUser' => 'KundeBruger',
        'Service' => 'Service',
        'Edit default services.' => 'Ret standard services.',
        'Search Result' => 'Søgeresultat',
        'Allocate services to CustomerUser' => 'Vælg services til kunde bruger',
        'Active' => 'Aktiv',
        'Allocate CustomerUser to service' => 'Vælg kunde bruger til service',

        # Template: AdminEmail
        'Message sent to' => 'Meddelelse sendt til',
        'A message should have a subject!' => 'En meddelelse skal have et emne!',
        'Recipients' => 'Modtagere',
        'Body' => 'Hovedtekst',
        'Send' => 'Afsend',

        # Template: AdminGenericAgent
        'GenericAgent' => 'Automatisk Agent',
        'Job-List' => 'Job-Liste',
        'Last run' => 'Sidste kørsel',
        'Run Now!' => 'Kør nu',
        'x' => 'x',
        'Save Job as?' => 'Gem et job som?',
        'Is Job Valid?' => 'Er jobbet gyldigt?',
        'Is Job Valid' => 'Er jobbet gyldigt',
        'Schedule' => 'Tidsplan',
        'Currently this generic agent job will not run automatically.' => 'Denne automatisk agent vil i øjeblikket ikke køre.',
        'To enable automatic execution select at least one value from minutes, hours and days!' => 'For at aktivere automatisk kørsel, vælg mindst en værdi fra minutter, timer og dage.',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fritekstsøgning i indlæg (f.eks. "Mar*in" eller "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(f.eks. 10*5155 eller 105658*)',
        '(e. g. 234321)' => '(f.eks. 234321)',
        'Customer User Login' => 'Kundebrugers login',
        '(e. g. U5150)' => '(f.eks. U5150)',
        'SLA' => 'SLA',
        'Agent' => 'Agent',
        'Ticket Lock' => 'Sagslås',
        'TicketFreeFields' => 'SagsFriFelter',
        'Create Times' => 'Tid for Oprettelse',
        'No create time settings.' => 'Angiv ikke oprettelsestid.',
        'Ticket created' => 'Sag oprettet',
        'Ticket created between' => 'Sag oprettet mellem',
        'Close Times' => 'Tid for Afslutning',
        'No close time settings.' => 'Angiv ikke Afslutningstid',
        'Ticket closed' => 'Sag lukket',
        'Ticket closed between' => 'Sag lukket mellem',
        'Pending Times' => 'Afventende tider',
        'No pending time settings.' => 'Ingen afventende tider',
        'Ticket pending time reached' => 'Sagens afventningstid er nået',
        'Ticket pending time reached between' => 'Sagens afventningstid er opnået mellem',
        'Escalation Times' => 'Eskalationsfrister',
        'No escalation time settings.' => 'Ingen eskaleringsfrister',
        'Ticket escalation time reached' => 'Sagens eskaleringsfrist er nået',
        'Ticket escalation time reached between' => 'Sagens eskaleringsfrist er nået mellem',
        'Escalation - First Response Time' => 'Eskalation - Frist til første svar',
        'Ticket first response time reached' => 'Sagens frist for første svar er nået',
        'Ticket first response time reached between' => 'Sagens frist for første svar er nået mellem',
        'Escalation - Update Time' => 'Eskalation - Opdateringsfrist',
        'Ticket update time reached' => 'Sagens opdateringsfrist er nået',
        'Ticket update time reached between' => 'Sagens opdateringsfrist er nået mellem',
        'Escalation - Solution Time' => 'Eskalation - Løsningstid',
        'Ticket solution time reached' => 'Sagens løsningsfrist er nået',
        'Ticket solution time reached between' => 'Sagens løsningsfrist er nået mellem',
        'New Service' => 'Ny service',
        'New SLA' => 'Ny SLA',
        'New Priority' => 'Ny Prioritet',
        'New Queue' => 'Ny Kø',
        'New State' => 'Ny Status',
        'New Agent' => 'Ny Agent',
        'New Owner' => 'Ny Ejer',
        'New Customer' => 'Ny kunde',
        'New Ticket Lock' => 'Ny Saglås',
        'New Type' => 'Ny Type',
        'New Title' => 'Ny Titel',
        'New TicketFreeFields' => 'Nye SagsFriFelter',
        'Add Note' => 'Tilføj Bemærkning',
        'Time units' => 'Tidsenheder',
        'CMD' => 'CMD',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Denne kommando vil blive udført. ARG[0] bliver sagens nummer. ARG[1] sagens ID. ',
        'Delete tickets' => 'Slet sager',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Advarsel! Denne sag fjernes fra databasen! Denne sag er gået tabt!',
        'Send Notification' => 'Send Meddelse',
        'Param 1' => 'Param 1',
        'Param 2' => 'Param 2',
        'Param 3' => 'Param 3',
        'Param 4' => 'Param 4',
        'Param 5' => 'Param 5',
        'Param 6' => 'Param 6',
        'Send agent/customer notifications on changes' => 'Send besked til agent/kunde ved ændringer',
        'Save' => 'Gem',
        '%s Tickets affected! Do you really want to use this job?' => '%s sager bliver berørt! Ønsker du stadig at køre dette job?',

        # Template: AdminGroupForm
        'WARNING: When you change the name of the group \'admin\', before making the appropriate changes in the SysConfig, you will be locked out of the administrations panel! If this happens, please rename the group back to admin per SQL statement.' => '',
        'Group Management' => 'Gruppestyring',
        'Add Group' => 'Tilføj Gruppe',
        'Add a new Group.' => 'Tilføj en ny Gruppe',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin-gruppen skal ind i administratorområdet og statistikgruppen i statistikområdet.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Opret nye grupper til at håndtere adgangstilladelser for agentens forskellige grupper (f.eks. indkøbs-, support- og salgsafdeling ...).',
        'It\'s useful for ASP solutions.' => 'Det er nyttigt for ASP-løsninger.',

        # Template: AdminLog
        'System Log' => 'Systemlog',
        'Time' => 'Tid',

        # Template: AdminMailAccount
        'Mail Account Management' => 'Administration af mail-konti',
        'Host' => 'Vært',
        'Trusted' => 'Pålidelig',
        'Dispatching' => 'Tildeler',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle indkommende mails med 1 konto tildeles til den valgte kø.',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Er kontoen pålidelig, bliver X-OTRS-header-felter ved ankomsttidspunktet (for prioritering, osv.) anvendt. Der anvendes PostMaster-filter under alle omstændigheder.',

        # Template: AdminNavigationBar
        'Users' => 'Agenter',
        'Groups' => 'Grupper',
        'Misc' => 'Diverse',

        # Template: AdminNotificationEventForm
        'Notification Management' => 'Beskedstyring',
        'Add Notification' => 'Tilføj besked',
        'Add a new Notification.' => 'Tilføj ny besked',
        'Name is required!' => 'Navn er påkrævet!',
        'Event is required!' => 'Handling er påkrævet!',
        'A message should have a body!' => 'En meddelelse skal have en tekst!',
        'Recipient' => 'Modtager',
        'Group based' => 'Gruppebaseret',
        'Agent based' => 'Agentbaseret',
        'Email based' => 'Emailbaseret',
        'Article Type' => 'Indlægstype',
        'Only for ArticleCreate Event.' => 'Kun for hændelsen NytIndlæg',
        'Subject match' => 'Match emne',
        'Body match' => 'Match brødtekst',
        'Notifications are sent to an agent or a customer.' => 'Beskeder sendes til en agent eller kunde.',
        'To get the first 20 character of the subject (of the latest agent article).' => 'For at få de første 20 tegn af emnet (af den seneste agent-indlæg).',
        'To get the first 5 lines of the body (of the latest agent article).' => 'For at få de første 5 linier af beskeden (af den seneste agent-indlæg).',
        'To get the article attribute (e. g. (<OTRS_AGENT_From>, <OTRS_AGENT_To>, <OTRS_AGENT_Cc>, <OTRS_AGENT_Subject> and <OTRS_AGENT_Body>).' => 'For at få indlæggets attributter (f.eks. <OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> og <OTRS_CUSTOMER_Body>).',
        'To get the first 20 character of the subject (of the latest customer article).' => 'For at få de første 20 tegn af emnet (af det seneste kunde-indlæg).',
        'To get the first 5 lines of the body (of the latest customer article).' => 'For at få de første 5 linier af beskeden (af den seneste agent-indlæg).',

        # Template: AdminNotificationForm
        'Notification' => 'Besked',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakkestyring',
        'Uninstall' => 'Afinstaller',
        'Version' => 'Version',
        'Do you really want to uninstall this package?' => 'Er du sikker på, du ønsker at afinstallere denne pakke?',
        'Reinstall' => 'Geninstaller',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Ønsker du virkeleg at geninstallere denne pakke (Alle manuelle ændringer vil blive slettet)?',
        'Continue' => 'Fortsæt',
        'Install' => 'Installation',
        'Package' => 'Pakke',
        'Online Repository' => 'Online lagerdepot',
        'Vendor' => 'Sælger',
        'Module documentation' => 'Modul-dokumentation',
        'Upgrade' => 'Opgrader',
        'Local Repository' => 'Lokalt lagerdepot',
        'Status' => 'Status',
        'Overview' => 'Oversigt',
        'Download' => 'Download',
        'Rebuild' => 'Genopbyg',
        'ChangeLog' => 'ChangeLog',
        'Date' => 'Dato',
        'Filelist' => 'Filliste',
        'Download file from package!' => 'Download fil fra pakke!',
        'Required' => 'Påkrævet',
        'PrimaryKey' => 'PrimærNøgle',
        'AutoIncrement' => 'AutoForhøjelse',
        'SQL' => 'SQL',
        'Diff' => 'Diff',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Ydelseslog',
        'This feature is enabled!' => 'Denne funktion er aktiveret',
        'Just use this feature if you want to log each request.' => 'Benyt denne funktion hvis du ønsker at alle forespørgsler skal logges.',
        'Activating this feature might affect your system performance!' => 'Aktivering af denne funktion kan have indflydelse på systemets ydeevne',
        'Disable it here!' => 'Deaktiver det her!',
        'This feature is disabled!' => 'Denne mulighed er deaktiveret!',
        'Enable it here!' => 'Aktiver det her!',
        'Logfile too large!' => 'Logfil er for stor',
        'Logfile too large, you need to reset it!' => 'Log fil er fort stor, du skal nulstille den',
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

        # Template: AdminPGPForm
        'PGP Management' => 'PGP-styring',
        'Result' => 'Resultat',
        'Identifier' => 'Identifikator',
        'Bit' => 'Bit',
        'Key' => 'Nøgle',
        'Fingerprint' => 'Fingeraftryk',
        'Expires' => 'Udløber',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Du kan på denne måde direkte redigere den nøglering, der er konfigureret i SysConfig.',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMasters filterstyring',
        'Filtername' => 'Filternavn',
        'Stop after match' => 'Stop, hvis matcher',
        'Match' => 'Match',
        'Value' => 'Værdi',
        'Set' => 'Indstil',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Send eller filtrer indkommende e-mail baseret på hver e-mails X-header! RegExp er også mulig.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => 'Hvis du kun ønsker at matche email adressen, så brug EMAILADDRESS:info@example.com i Fra, Til eller Cc.',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Anvender du RegExp, kan du også bruge den matchede værdi i () som [***] i \'Set\'.',

        # Template: AdminPriority
        'Priority Management' => 'Prioritets administration',
        'Add Priority' => 'Tilføj prioritet',
        'Add a new Priority.' => 'Tilføj ny prioritet',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Kø <-> Styring af autosvar',
        'settings' => 'indstillinger',

        # Template: AdminQueueForm
        'Queue Management' => 'Køstyring',
        'Sub-Queue of' => 'Underkø af',
        'Unlock timeout' => 'Tidsfrist for frigivelse',
        '0 = no unlock' => '0 = ingen frigivelse',
        'Only business hours are counted.' => 'Kun normal kontor tid er beregnet.',
        '0 = no escalation' => '0 = ingen eskalering',
        'Notify by' => 'Adviser via',
        'Follow up Option' => 'Opfølgningsmulighed',
        'Ticket lock after a follow up' => 'Sag tildelt efter opfølgning på lukket sag',
        'Systemaddress' => 'Systemadresse',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Hvis en agent trækker en sag, og vedkommende ikke sender et svar inden for dette tidsrum, frigives sagen automatisk. Derved kan alle andre agenter se sagen.',
        'Escalation time' => 'Eskaleringstid',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Besvares en sag ikke inden for dette tidsrum, vil kun denne sag blive vist.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Er en sag lukket, og kunden sender en opfølgning, tildeles sagen til den gamle ejer.',
        'Will be the sender address of this queue for email answers.' => 'Bliver til denne køs afsenderadresse for e-mailsvar.',
        'The salutation for email answers.' => 'Den hilsen, der bruges til e-mailsvar.',
        'The signature for email answers.' => 'Den underskrift, der bruges til e-mailsvar.',
        'Customer Move Notify' => 'Kundebesked ved flytning',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS sender en e-mail med besked til kunden, hvis sagen er flyttet.',
        'Customer State Notify' => 'Besked om kunde status',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS sender en e-mail med besked til kunden, hvis sagens tilstand er ændret.',
        'Customer Owner Notify' => 'Besked til kundeejer',
        'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS sender en e-mail med besked til kunden, hvis sagen har fået en anden indehaver.',

        # Template: AdminQueueResponsesChangeForm
        'Responses <-> Queue Management' => 'Svar <-> Køstyring',

        # Template: AdminQueueResponsesForm
        'Answer' => 'Svar',

        # Template: AdminResponseAttachmentChangeForm
        'Responses <-> Attachments Management' => 'Svar <-> Styring af vedhæftede filer',

        # Template: AdminResponseAttachmentForm

        # Template: AdminResponseForm
        'Response Management' => 'Svar Styring',
        'A response is default text to write faster answer (with default text) to customers.' => 'Et Svar er en standardtekst, der bruges til at skrive et hurtigere svar (med standardtekst) til kunderne.',
        'Don\'t forget to add a new response a queue!' => 'Glem ikke at tilføje et nyt svar pr. kø!',
        'The current ticket state is' => 'Den aktuelle sags status er',
        'Your email address is new' => 'Din e-mailadresse er ny',

        # Template: AdminRoleForm
        'Role Management' => 'Rollestyring',
        'Add Role' => 'Tilføj rolle',
        'Add a new Role.' => 'Tilføj en ny rolle',
        'Create a role and put groups in it. Then add the role to the users.' => 'Opret en rolle og indsæt grupper i den. Tilføj dernæst brugernes rolle.',
        'It\'s useful for a lot of users and groups.' => 'Det er nyttigt for mange brugere og grupper.',

        # Template: AdminRoleGroupChangeForm
        'Roles <-> Groups Management' => 'Roller <-> Gruppestyring',
        'move_into' => 'flyt_til',
        'Permissions to move tickets into this group/queue.' => 'Tilladelser til at flytte sager ind i denne gruppe/kø.',
        'create' => 'opret',
        'Permissions to create tickets in this group/queue.' => 'Tilladelser til at oprette sager i denne gruppe/kø.',
        'owner' => 'ejer',
        'Permissions to change the ticket owner in this group/queue.' => 'Tilladelser til at ændre sagsejer i denne gruppe/kø.',
        'priority' => 'prioritering',
        'Permissions to change the ticket priority in this group/queue.' => 'Tilladelser til at ændre sagprioriteringen i denne gruppe/kø.',

        # Template: AdminRoleGroupForm
        'Role' => 'Rolle',

        # Template: AdminRoleUserChangeForm
        'Roles <-> Users Management' => 'Roller <-> Brugerstyring',
        'Select the role:user relations.' => 'Vælg relationer mellem rollen:brugeren.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Styring af hilsner',
        'Add Salutation' => 'Tilføj hilsen',
        'Add a new Salutation.' => 'Tilføj en ny hilsen',

        # Template: AdminSecureMode
        'Secure Mode need to be enabled!' => 'Secure Mode skal aktiveres!',
        'Secure mode will (normally) be set after the initial installation is completed.' => 'Secure Mode vil (normalt) blive aktiveret efter den indledende installation er fuldført.',
        'Secure mode must be disabled in order to reinstall using the web-installer.' => 'Secure Mode skal deaktiveres, hvis OTRS skal geninstalleres med web-installeren.',
        'If Secure Mode is not activated, activate it via SysConfig because your application is already running.' => 'Hvis Secure Mode ikke er aktiveret, så aktiver det via SysConfig, fordi OTRS allerede kører.',

        # Template: AdminSelectBoxForm
        'SQL Box' => 'SQL Box',
        'Go' => 'Gå',
        'Select Box Result' => 'Vælg feltresultat',

        # Template: AdminService
        'Service Management' => 'Service administration',
        'Add Service' => 'Tilføj service',
        'Add a new Service.' => 'Tilføj en ny service',
        'Sub-Service of' => 'Under service af',

        # Template: AdminSession
        'Session Management' => 'Sessionsstyring',
        'Sessions' => 'Sessioner',
        'Uniq' => 'Unik',
        'Kill all sessions' => 'Dræb alle sessions',
        'Session' => 'Session',
        'Content' => 'Indhold',
        'kill session' => 'afbryd session',

        # Template: AdminSignatureForm
        'Signature Management' => 'Underskriftstyring',
        'Add Signature' => 'Tilføj underskrift',
        'Add a new Signature.' => 'Tilføj ny underskrift',

        # Template: AdminSLA
        'SLA Management' => 'SLA Administration',
        'Add SLA' => 'Tilføj SLA',
        'Add a new SLA.' => 'Tilføj en ny SLA',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME Styring',
        'Add Certificate' => 'Tilføj certifikat',
        'Add Private Key' => 'Tilføj privat nøgle',
        'Secret' => 'Hemmelig',
        'Hash' => 'Hash',
        'In this way you can directly edit the certification and private keys in file system.' => 'Du kan på denne måde direkte redigere certificeringsnøgler og private nøgler i filsystemet.',

        # Template: AdminStateForm
        'State Management' => 'Tilstands administration',
        'Add State' => 'Tilføj tilstand',
        'Add a new State.' => 'Tilføj en ny tilstand',
        'State Type' => 'Tilstandstype',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Sørg for, at du også opdatede standardtilstandene i Kernel/Config.pm!',
        'See also' => 'Se også',

        # Template: AdminSysConfig
        'SysConfig' => 'SysConfig',
        'Group selection' => 'Gruppevalg',
        'Show' => 'Vis',
        'Download Settings' => 'Download indstillinger',
        'Download all system config changes.' => 'Download alle systemkonfigurations ændringer.',
        'Load Settings' => 'Indlæs indstillinger',
        'Subgroup' => 'Undergruppe',
        'Elements' => 'Elementer',

        # Template: AdminSysConfigEdit
        'Config Options' => 'Konfiguationsmuligheder',
        'Default' => 'Standard',
        'New' => 'Ny',
        'New Group' => 'Ny gruppe',
        'Group Ro' => 'Gruppe Ro',
        'New Group Ro' => 'Ny grupperolle',
        'NavBarName' => 'NavBarNavn',
        'NavBar' => 'NavBar',
        'Image' => 'Billede',
        'Prio' => 'Prio',
        'Block' => 'Blok',
        'AccessKey' => 'AdgangsNøgle',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Systems e-mailadressestyring',
        'Add System Address' => 'Tilføj system adresse',
        'Add a new System Address.' => 'Tilføj en ny system adresse',
        'Realname' => 'RigtigtNavn',
        'All email addresses get excluded on replaying on composing an email.' => 'Alle mail-adresser ekskluderes ved svar eller nyoprettelse af mail.',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle indkommende mails med denne "E-mail" (Til:) sendes til den valgte kø.',

        # Template: AdminTypeForm
        'Type Management' => 'Type administration',
        'Add Type' => 'Tilføj type',
        'Add a new Type.' => 'Tilføj en ny type',

        # Template: AdminUserForm
        'User Management' => 'Brugerstyring',
        'Add User' => 'Tilføj bruger',
        'Add a new Agent.' => 'Tilføj en ny Agent',
        'Login as' => 'Login som',
        'Firstname' => 'Fornavn',
        'Lastname' => 'Efternavn',
        'Start' => 'Start',
        'End' => 'Slut',
        'User will be needed to handle tickets.' => 'Brugeren behøves til at håndtere sagerne.',
        'Don\'t forget to add a new user to groups and/or roles!' => 'Glem ikke at tilføje en ny bruger til grupper og/eller roller!',

        # Template: AdminUserGroupChangeForm
        'Users <-> Groups Management' => 'Brugere <-> Gruppestyring',

        # Template: AdminUserGroupForm

        # Template: AgentBook
        'Address Book' => 'Adressebog',
        'Return to the compose screen' => 'Vend tilbage til skriveskærmen',
        'Discard all changes and return to the compose screen' => 'Kassér alle ændringer og vend tilbage til skriveskærmen',

        # Template: AgentCalendarSmall

        # Template: AgentCalendarSmallIcon

        # Template: AgentCustomerSearch

        # Template: AgentCustomerTableView

        # Template: AgentDashboard
        'Dashboard' => 'Dashboard',

        # Template: AgentDashboardCalendarOverview
        'in' => 'i',

        # Template: AgentDashboardImage

        # Template: AgentDashboardProductNotify
        '%s %s is available!' => '%s %s er tilgængelig',
        'Please update now.' => 'Opdater venligst.',
        'Release Note' => 'Udgivelsesnote',
        'Level' => 'Niveau',

        # Template: AgentDashboardRSSOverview
        'Posted %s ago.' => 'Offentliggjort %s siden.',

        # Template: AgentDashboardTicketOverview

        # Template: AgentDashboardTicketStats

        # Template: AgentInfo
        'Info' => 'Info',

        # Template: AgentLinkObject
        'Link Object: %s' => 'Kæd objekt: %s',
        'Object' => 'Objekt',
        'Link Object' => 'Kæd',
        'with' => 'med',
        'Select' => 'Vælg',
        'Unlink Object: %s' => 'Fjern kædning af objekt: %s',

        # Template: AgentLookup
        'Lookup' => 'Find',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Stavekontrol',
        'spelling error(s)' => 'stavefejl',
        'or' => 'eller',
        'Apply these changes' => 'Anvend disse ændringer',

        # Template: AgentStatsDelete
        'Do you really want to delete this Object?' => 'Er du sikker på, du ønsker at slette dette objekt?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Vælg begrænsningerne til at karakterisere stat',
        'Fixed' => 'Fast',
        'Please select only one element or turn off the button \'Fixed\'.' => 'Vælg venligst kun et Element, eller fravælg knappen \'Fast\'',
        'Absolut Period' => 'Absolut periode',
        'Between' => 'Mellem',
        'Relative Period' => 'Relativ periode',
        'The last' => 'Den sidste',
        'Finish' => 'Færdig',
        'Here you can make restrictions to your stat.' => 'Her kan du begrænse din stat',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributes of the corresponding element.' => 'Vis du fjerner markeringen i boksen "Fast", kan agenten ændrer attributterne ved det valgte element.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Indsæt fælles specifikationer',
        'Permissions' => 'Rettigeheder',
        'Format' => 'Format',
        'Graphsize' => 'Graf størrelse',
        'Sum rows' => 'Antal rækker',
        'Sum columns' => 'Antal Kollonner',
        'Cache' => 'Cache',
        'Required Field' => 'Påkærvede felter',
        'Selection needed' => 'Valg påkrævet',
        'Explanation' => 'Forklaring',
        'In this form you can select the basic specifications.' => 'I denne formular kan du vælge de grundlæggende specifikationer.',
        'Attribute' => 'Atribut',
        'Title of the stat.' => 'Title på stat.',
        'Here you can insert a description of the stat.' => 'Her kan du indtaste en beskrivelse af stat.',
        'Dynamic-Object' => 'Dynamisk-Objekt',
        'Here you can select the dynamic object you want to use.' => 'Her kan du vælge det dynamiske objekt du vil bruge',
        '(Note: It depends on your installation how many dynamic objects you can use)' => '(Bemlrk: Det afhænger af din installation hvor mange dynamiske objekter du kan bruge)',
        'Static-File' => 'Statisk-Fil',
        'For very complex stats it is possible to include a hardcoded file.' => 'For meget komplekse statistiker er det muligt at inkludere en hardcoded fil.',
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Hvis en hardcoded fil er tilgængelig, vil denne attribute være vist, og du kan vælge den.',
        'Permission settings. You can select one or more groups to make the configurated stat visible for different agents.' => 'Rettigheds indstillinger, Du kan vælge en eller flere grupper, for at gøre den konfigurerede stat synlig for forskellige agenter.',
        'Multiple selection of the output format.' => 'Flere valg af output format',
        'If you use a graph as output format you have to select at least one graph size.' => 'iHvis du bruger en graf som output format skal du vælge mindst en graf størrelse',
        'If you need the sum of every row select yes' => 'Hvis du skal bruge summen af hver række, vælg da ja',
        'If you need the sum of every column select yes.' => 'Hvis du skal bruge summe af hver kolonne vælg da ja',
        'Most of the stats can be cached. This will speed up the presentation of this stat.' => 'De fleste statistikker kan blive cachet, det vil gøre præsentationen hurtigere',
        '(Note: Useful for big databases and low performance server)' => '(Bemærk: Brugbart for store databse og lavydelse servere)',
        'With an invalid stat it isn\'t feasible to generate a stat.' => 'Med en ugyldig stat er det ikke muligt at generere en stat',
        'This is useful if you want that no one can get the result of the stat or the stat isn\'t ready configurated.' => 'Dette er brugbart hvis du ikke ønsker at nogen kan se resultatet afen stat der ikke er konfigureret.',

        # Template: AgentStatsEditValueSeries
        'Select the elements for the value series' => 'Vælg elementerne for værdi serien',
        'Scale' => 'Skala',
        'minimal' => 'minimum',
        'Please remember, that the scale for value series has to be larger than the scale for the X-axis (e.g. X-Axis => Month, ValueSeries => Year).' => 'Husk venligst at skalen for værdi serien, skal være større end den skala for X-Aksen (f.eks. X-Akse => Month, VærdiSerie => År).',
        'Here you can define the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Her kan du vælge værdi serierne. Du har muligheden for at vælge en eller to elementer. Derefter kan du vælge attributter for elementerne. Hvert element vil blive vist som en enkelt værdi sere. Hvis du ikke har valgt nogle attributter, vil alle attributter for elementet blive brugt til at generere stat. Ligesom en ny attribut vil blive tilføjet siden sidste konfiguration.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Vælg det element der skal bruges ved X-aksen',
        'maximal period' => 'maksimal periode',
        'minimal scale' => 'minimal skala',
        'Here you can define the x-axis. You can select one element via the radio button. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Her kan du definere X-aksen. Du kan vælge et element via knapperne. Hvis du ikke       vælger så vil alle egenskaberne ved elementet blive benyttet når du laver statistik. Såvel som nye egenskaber der er tilføjet siden sidste konfiguration.',

        # Template: AgentStatsImport
        'Import' => 'Importer',
        'File is not a Stats config' => 'Filen er ikke en Stats konfiguration',
        'No File selected' => 'Ingen fil valgt',

        # Template: AgentStatsOverview
        'Results' => 'Resultater',
        'Total hits' => 'Samlede antal hit',
        'Page' => 'Side',

        # Template: AgentStatsPrint
        'Print' => 'Generer PDF',
        'No Element selected.' => 'Intet element er valgt.',

        # Template: AgentStatsView
        'Export Config' => 'Eksporter konfiguration',
        'Information about the Stat' => 'Information om Stat',
        'Exchange Axis' => 'Udskiftning af akser',
        'Configurable params of static stat' => 'Konfigurer bare parametre af en statitisk stat',
        'No element selected.' => 'Intet element er valgt',
        'maximal period from' => 'maksimal periode fra',
        'to' => 'til',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Med input og select felterne kan du konfigurere en stat til dine behov. Hvilket element af en stat du kan rette afhænger af administratoren der har konfigureret denne stat.',

        # Template: AgentTicketBounce
        'A message should have a To: recipient!' => 'En meddelelse skal have en Til: modtager!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Der skal være en e-mailadresse (f.eks. customer@eksempel.com) i feltet Til:!',
        'Bounce ticket' => 'Sag retur til afsender',
        'Ticket locked!' => 'Sag trukket',
        'Ticket unlock!' => 'Frigiv sag',
        'Bounce to' => 'Retur til',
        'Next ticket state' => 'Næste sags status',
        'Inform sender' => 'Informer afsender',
        'Send mail!' => 'Send mail',

        # Template: AgentTicketBulk
        'You need to account time!' => 'Du skal angive tidsforbrug!',
        'Ticket Bulk Action' => 'Sagsmassehandling',
        'Spell Check' => 'Stavekontrol',
        'Note type' => 'Bemærkningstype',
        'Next state' => 'Næste status',
        'Pending date' => 'Afventer dato',
        'Merge to' => 'Saml til',
        'Merge to oldest' => 'Saml til ældste',
        'Link together' => 'Kæd sammen',
        'Link to Parent' => 'Kæd til Forælder',
        'Unlock Tickets' => 'Frigiv sager',

        # Template: AgentTicketClose
        'Ticket Type is required!' => 'Sagstype er påkrævet.',
        'A required field is:' => 'Følgende felt er påkrævet:',
        'Close ticket' => 'Luk sag',
        'Previous Owner' => 'Tidligere ejer',
        'Inform Agent' => 'Informer Repræsentant',
        'Optional' => 'Valgfri',
        'Inform involved Agents' => 'Informer involverede Repræsentanter',
        'Attach' => 'Vedhæft',

        # Template: AgentTicketCompose
        'A message must be spell checked!' => 'Meddelelse skal stavekontrolleres.',
        'Compose answer for ticket' => 'Skriv svar til sag',
        'Pending Date' => 'Afventer dato',
        'for pending* states' => 'for afventende tilstande',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Skift sagskunde',
        'Set customer user and customer id of a ticket' => 'Indstil en sags kundebruger og kunde-ID',
        'Customer User' => 'Kundebruger',
        'Search Customer' => 'Søg kunde',
        'Customer Data' => 'Kundedata',
        'Customer history' => 'Kundehistorik',
        'All customer tickets.' => 'Alle kundesager.',

        # Template: AgentTicketEmail
        'Compose Email' => 'Skriv e-mail',
        'new ticket' => 'ny sag',
        'Refresh' => 'Opdater',
        'Clear To' => 'Ryd til',
        'All Agents' => 'Alle Agenter',

        # Template: AgentTicketEscalation

        # Template: AgentTicketForward
        'Article type' => 'Indlægstype',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Skift sagens fritekst',

        # Template: AgentTicketHistory
        'History of' => 'Historik af',

        # Template: AgentTicketLocked

        # Template: AgentTicketMerge
        'You need to use a ticket number!' => 'Du skal bruge et sagsnummer.',
        'Ticket Merge' => 'Sagssamling',

        # Template: AgentTicketMove
        'If you want to account time, please provide Subject and Text!' => 'Hvis du vil registrere tid, så udfyld emne og tekst.',
        'Move Ticket' => 'Flyt Sag',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Tilføj bemærkning til sag',

        # Template: AgentTicketOverviewMedium
        'First Response Time' => 'Tid til første svar',
        'Service Time' => 'Servicetid',
        'Update Time' => 'Opdateringstid',
        'Solution Time' => 'Løsningstid',

        # Template: AgentTicketOverviewMediumMeta
        'You need min. one selected Ticket!' => 'Du skal vælge mindst en sag.',

        # Template: AgentTicketOverviewNavBar
        'Filter' => 'Filter',
        'Change search options' => 'Skift søgemuligheder',
        'Tickets' => 'Sager',
        'of' => 'af',

        # Template: AgentTicketOverviewNavBarSmall

        # Template: AgentTicketOverviewPreview
        'Compose Answer' => 'Skriv svar',
        'Contact customer' => 'Kontakt kunde',
        'Change queue' => 'Skift kø',

        # Template: AgentTicketOverviewPreviewMeta

        # Template: AgentTicketOverviewSmall
        'sort upward' => 'sorter stigende',
        'up' => 'stigende',
        'sort downward' => 'sorter faldende',
        'down' => 'faldende',
        'Escalation in' => 'Eskalerer om',
        'Locked' => 'Tildelt',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Skift sagens ejer',

        # Template: AgentTicketPending
        'Set Pending' => 'Indstil afventer',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefonopkald',
        'Clear From' => 'Ryd fra',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Almindelig',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Sag-Info',
        'Accounted time' => 'Benyttet tid',
        'Linked-Object' => 'Linket-Objekt',
        'by' => 'af',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Skift sagens prioritet',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Viste sager',
        'Tickets available' => 'Sager til rådighed',
        'All tickets' => 'Alle sager',
        'Queues' => 'Køer',
        'Ticket escalation!' => 'Eskalering af sag!',

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Skift ansvarlig for sag',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Sagssøgning',
        'Profile' => 'Profil',
        'Search-Template' => 'Skabelon-søgning',
        'TicketFreeText' => 'SagFriTekst',
        'Created in Queue' => 'Oprettet i kø',
        'Article Create Times' => 'Oprettelsestidspunkt for indlæg',
        'Article created' => 'Indlæg oprettet',
        'Article created between' => 'Indlæg oprettet mellem',
        'Change Times' => 'Tid for Ændring',
        'No change time settings.' => 'Angiv ikke ændringstidspunkt',
        'Ticket changed' => 'Sag ændret',
        'Ticket changed between' => 'Sag ændret mellem',
        'Result Form' => 'Resultatformular',
        'Save Search-Profile as Template?' => 'Gem søgeprofil som skabelon?',
        'Yes, save it with name' => 'Ja, gem den med navn',

        # Template: AgentTicketSearchOpenSearchDescriptionFulltext
        'Fulltext' => 'Fritekst',

        # Template: AgentTicketSearchOpenSearchDescriptionTicketNumber

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketZoom
        'Expand View' => 'Udvid visning',
        'Collapse View' => 'Indskrænk visning',
        'Split' => 'Del',

        # Template: AgentTicketZoomArticleFilterDialog
        'Article filter settings' => 'Filterindstillinger på indlæg',
        'Save filter settings as default' => 'Gem disse filterinstillinger som standard',

        # Template: AgentWindowTab

        # Template: AJAX

        # Template: Copyright

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Tilbagesporing',

        # Template: CustomerFooter
        'Powered by' => ' ',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => 'Login',
        'Lost your password?' => 'Mistet din adgangskode?',
        'Request new password' => 'Anmod om ny adgangskode',
        'Create Account' => 'Opret konto',

        # Template: CustomerNavigationBar
        'Welcome %s' => 'Velkommen %s',

        # Template: CustomerPreferencesForm

        # Template: CustomerStatusView

        # Template: CustomerTicketMessage

        # Template: CustomerTicketPrint

        # Template: CustomerTicketSearch
        'Times' => 'Tider',
        'No time settings.' => 'Ingen tidsindstillinger.',

        # Template: CustomerTicketSearchOpenSearchDescription

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klik her for at rapportere en fejl',

        # Template: Footer
        'Top of Page' => 'Øverst på siden',

        # Template: FooterSmall

        # Template: Header
        'Home' => 'Hjem',

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-Installation',
        'Welcome to %s' => 'Velkommen til %s',
        'Accept license' => 'Accepter licens',
        'Don\'t accept license' => 'Accepter ikke icensen',
        'Admin-User' => 'Admin-bruger',
        'If you have set a root password for your database, it must be entered here. If not, leave this field empty. For security reasons we do recommend setting a root password. For more information please refer to your database documentation.' => 'Hvis du har sat et root kodeord til din database skal du taste det her. Hvis ikke, lad feltet være tomt. Af sikkerheds årsager anbefaler vi at sætte et root kodeord. For mere information henviser vi til documentationen for din database.',
        'Admin-Password' => 'Admin-adgangskode',
        'Database-User' => 'Database-bruger',
        'default \'hot\'' => 'standard \'hot\'',
        'DB connect host' => 'DB tilsluttes værtscomputer',
        'Database' => 'Database',
        'Default Charset' => 'Standardtegnsæt',
        'utf8' => 'utf8',
        'false' => 'negativ',
        'SystemID' => 'System-ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Systemets identificering. Hvert sagnummer og hver http-sessions ID starter med dette tal) ',
        'System FQDN' => 'Systemets FQDN',
        '(Full qualified domain name of your system)' => '(Dit systems FQDN(Fully qualified domain name)) ',
        'AdminEmail' => 'AdminE-mail',
        '(Email of the system admin)' => '(Systemadministrators e-mail)',
        'Organization' => 'Organisation',
        'Log' => 'Log',
        'LogModule' => 'LogModul',
        '(Used log backend)' => '(Anvendt log til backend)',
        'Logfile' => 'Logfil',
        '(Logfile just needed for File-LogModule!)' => '(Logfilen behøves kun til Fil-LogModul!)',
        'Webfrontend' => 'Webfrontend',
        'Use utf-8 it your database supports it!' => 'Anvend utf-8, hvis din database understøtter det!',
        'Default Language' => 'Standardsprog',
        '(Used default language)' => '(Anvendt standardsprog)',
        'CheckMXRecord' => 'KontrollerMXRecord',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrollerer MX-records af anvendte e-mailadresser ved at udforme et svar. Anvend ikke KontrollerMXRecord, hvis OTRS-maskinen befinder sig bag en opkaldslinje $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'For at kunne anvende OTRS, er du nødt til at indtaste følgende linje i din kommandolinje (Terminal/Shell) som root.',
        'Restart your webserver' => 'Genstart webserveren',
        'After doing so your OTRS is up and running.' => 'Når det er gjort, er din OTRS sat i gang og fungerer.',
        'Start page' => 'Startside',
        'Your OTRS Team' => 'Dit OTRS Team',

        # Template: LinkObject

        # Template: Login

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ingen Rettighed',

        # Template: Notify
        'Important' => 'Vigtigt',

        # Template: PrintFooter
        'URL' => 'URL',

        # Template: PrintHeader
        'printed by' => 'udskrevet af',

        # Template: PublicDefault

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS prøveside',
        'Counter' => 'Tæller',

        # Template: Warning

        # Template: YUI

        # Misc
        'last-search' => 'sidste søgning',
        'Edit Article' => 'Ret indlæg',
        'Create Database' => 'Opret database',
        'DB Host' => 'DB værtscomputer',
        'Ticket Number Generator' => 'Sagsnummergenerator',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Sagidentifikator. Nogle personer ønsker at indstille dette til f.eks. \Ticket#\, \Call#\ eller \MyTicket#\)',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Du kan på denne måde direkte redigere den nøglering, der er konfigureret i Kernel/Config.pm.',
        'Create new Phone Ticket' => 'Opret ny telefonsag',
        'Symptom' => 'Symptom',
        'U' => 'O',
        'Site' => 'Websted',
        'Customer history search (e. g. "ID342425").' => 'Kundehistoriksøgning (f.eks. "ID342425").',
        'your MySQL DB should have a root password! Default is empty!' => 'din MySQL DB skat have en rod-adgangskode! Standarden er tom!',
        'Close!' => 'Luk',
        'for agent firstname' => 'til repræsentantens fornavn',
        ' (minutes)' => ' (minutter)',
        'No means, send agent and customer notifications on changes.' => 'Nej betyder, send meddelser til Repræsentant eller Kunde ved ændringer.',
        'A web calendar' => 'En webkalender',
        'to get the realname of the sender (if given)' => 'for at få afsenderens virkelige navn (hvis det er oplyst)',
        'OTRS DB Name' => 'OTRS DB-navn',
        'Notification (Customer)' => 'Meddelse (Kunde)',
        'Select Source (for add)' => 'Vælg kilde (til tilføjelse)',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => 'Muligheder for sags data (f.eks. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)',
        'Child-Object' => 'Barn-Objekt',
        'Queue ID' => 'Kø-ID',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Konfigurationsmuligheder (f.eks. <OTRS_CONFIG_HttpType>)',
        'System History' => 'Systemhistorik',
        'customer realname' => 'kundens virkelige navn',
        'Pending messages' => 'Afventer meddelelser',
        'Port' => 'Port',
        'Modules' => 'Moduler',
        'for agent login' => 'til repræsentantens login',
        'Keyword' => 'Søgeord',
        'Close type' => 'Luk type',
        'DB Admin User' => 'DB-admin-bruger',
        'for agent user id' => 'til repræsentantens bruger-ID',
        'Change user <-> group settings' => 'Skift bruger <-> gruppeindstillinger',
        'Problem' => 'Problem',
        'Escalation' => 'Eskalering',
        '"}' => '',
        'Order' => 'Ordre',
        'next step' => 'næste trin',
        'Follow up' => 'Opfølgning',
        'Customer history search' => 'Kunde historik søgning',
        'Admin-Email' => 'Admin-E-mail',
        'Stat#' => '',
        'Create new database' => 'Opret ny database',
        'ArticleID' => 'Indlægs-ID',
        'Keywords' => 'Søgeord',
        'Ticket Escalation View' => 'Sags eskalerings visning',
        'Today' => 'Idag',
        'No * possible!' => 'Ingen * er mulig!',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Muligheder for den nuværende bruger der har udført denne handling (f.eks. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
        'Message for new Owner' => 'Meddelelse til ny ejer',
        'to get the first 5 lines of the email' => 'for at få e-mailens første 5 linjer',
        '}' => '}',
        'Sort by' => 'Sorter efter',
        'OTRS DB Password' => 'OTRS DB-adgangskode',
        'Last update' => 'Sidste opdatering',
        'Tomorrow' => 'Imorgen',
        'to get the first 20 character of the subject' => 'for at få emnets første 20 tegn',
        'Select the customeruser:service relations.' => 'Udvælg Kundebruger service relationer.',
        'DB Admin Password' => 'DB-admins adgangskode',
        'Advisory' => 'Bekendtgørelse',
        'Drop Database' => 'Udelad database',
        'Here you can define the x-axis. You can select one element via the radio button. Then you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Her kan du definere X-aksen. Du kan vælge et element med radio button. Derefter skal du vælge et eller flere attributter til elementet. Hvis du ikke vælger nogle attributter, vil alle attributter blive brugt, ligesom et nyt attribut vil blive gemt, siden sidste konfiguration.',
        'FileManager' => 'FilManager',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Valgmuligheder for de aktuelle kundebrugerdata (f.eks. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Afventer type',
        'Comment (internal)' => 'Kommentar (intern)',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Sags ejer muligheder (f.eks. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for sagens data (f.eks. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Anvendt sagsnummerformat)',
        'Reminder' => 'Påmindelse',
        'Incident' => 'Hændelse',
        'All Agent variables.' => 'Alle repræsentant variabler',
        ' (work units)' => '(arbejdsenheder)',
        'Next Week' => 'Næste uge',
        'All Customer variables like defined in config option CustomerUser.' => 'Alle kundevariabler som definerede i konfigurationsmuligheden KundeBruger.',
        'accept license' => 'accepter licens',
        '0' => '0',
        'for agent lastname' => 'til agents efternavn',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Valgmuligheder for den aktuelle bruger, som anmodede om denne handling (f.eks. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Påmindelsesmeddelelser',
        'Parent-Object' => 'Forældre-Objekt',
        'Of couse this feature will take some system performance it self!' => 'Selvfølgelig vil denne mulighed tage noget af system kræften.',
        'Detail' => 'Oplysning',
        'Your own Ticket' => 'Din egen sag',
        'Don\'t forget to add a new user to groups!' => 'Glem ikke at tilføje en ny bruger til grupper!',
        'Open Tickets' => 'Åbne sager',
        'CreateTicket' => 'Opret sag',
        'You have to select two or more attributes from the select field!' => 'Du skal vælge to eller flere attributter fra feltet!',
        'System Settings' => 'Systemindstillinger',
        'WebWatcher' => 'WebWatcher',
        'Finished' => 'Færdig',
        'Account Type' => 'Konto type',
        'D' => 'N',
        'All messages' => 'Alle meddelelser',
        'System Status' => 'System status',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for de aktuelle sagsdata (f.eks. lt;OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Artefact' => 'Artefakt',
        'A article should have a title!' => 'Et indlæg skal have en titel',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Konfigurations muligheder (f.eks. &lt;OTRS_CONFIG_HttpType&gt;)',
        'All email addresses get excluded on replaying on composing and email.' => 'Alle email adresser er ekskluderet når du besvarer eller laver en ny email.',
        'don\'t accept license' => 'accepter ikke licens',
        'A web mail client' => 'En webmailklient',
        'Compose Follow up' => 'Skriv opfølgning',
        'WebMail' => 'WebMail',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for sagens data (f.eks. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Sagsejers valgmuligheder (f.eks. <OTRS_OWNER_UserFirstname>)',
        'DB Type' => 'DB type',
        'Termin1' => 'Termin1',
        'kill all sessions' => 'afbryd alle sessioner',
        'to get the from line of the email' => 'for at få e-mailens "fra"-linje',
        'Solution' => 'Løsning',
        'Package not correctly deployed, you need to deploy it again!' => 'Pakken blev ikke korrekt installeret, den skal installeres igen!',
        'QueueView' => 'Køer',
        'Select Box' => 'Vælg felt',
        'New messages' => 'Nye meddelelser',
        'Welcome to OTRS' => 'Velkommen til OTRS',
        'modified' => 'modificeret',
        'Delete old database' => 'Slet gammel database',
        'A web file manager' => 'En webfilmanager',
        'Have a lot of fun!' => 'Hav det rigtig sjovt!',
        'send' => '',
        'Send no notifications' => 'Send ingen meddelser',
        'Note Text' => 'Bemærkningstekst',
        'POP3 Account Management' => 'POP3 kontostyring',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Muligheder for den nuværende kundes data (f.eks. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
        'System State Management' => 'Systemtilstandsstyring',
        'OTRS DB User' => 'OTRS DB-bruger',
        'Mailbox' => 'Mailboks',
        'PhoneView' => 'TelefonVisning',
        'maximal period form' => 'maksimal periode form',
        'TicketID' => 'Sag-ID',
        'Escaladed Tickets' => 'Eskalerede sager',
        'Yes means, send no agent and customer notifications on changes.' => 'Ja betyder, send ingen meddelser til Repræsentant eller Kunde ved ændringer.',
        'SMIME Management' => 'SMIME-styring',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further information.' => 'Din e-mail med sagnummer "<OTRS_TICKET>" er sendt retur til afsender til "<OTRS_BOUNCE_TO>". Kontakt denne adresse for at få flere oplysninger.',
        'Ticket Status View' => 'Sagsstatusvisning',
        'Modified' => 'Modificeret',
        'Ticket selected for bulk action!' => 'Sag valgt til massehandling',
        '%s is not writable!' => '',
        'Cannot create %s!' => '',
        'EscalationView' => 'Eskalerede sager',
    };
    # $$STOP$$
    return;
}
1;
