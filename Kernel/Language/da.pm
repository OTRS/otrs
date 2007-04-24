# --
# Kernel/Language/da.pm - provides da (Danish) language translation
# Last Update: 2006/10/12
# Copyright (C) 2006 Thorsten Rossner <thorsten.rossner[at]stepstone.de>
# Original created by Thorsten Rossner
# Maintained by Mads N. Vestergaard <mnv[at]timmy.dk>
# --
# $Id: da.pm,v 1.19 2007-04-24 09:45:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::da;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.19 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Mon Apr  2 17:25:20 2007

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateFormatShort} = '%D.%M.%Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
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
        'Example' => 'Eksempel',
        'Examples' => 'Eksempler',
        'valid' => 'gyldig',
        'invalid' => 'ugyldig',
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
        'Link' => '',
        'Linked' => 'Linket',
        'Link (Normal)' => 'Link (normal)',
        'Link (Parent)' => 'Link (forældre)',
        'Link (Child)' => 'Link (barn)',
        'Normal' => '',
        'Parent' => 'Forældre',
        'Child' => 'Barn',
        'Hit' => '',
        'Hits' => 'Antal hits',
        'Text' => 'Tekst',
        'Lite' => 'Let',
        'User' => 'Bruger',
        'Username' => 'Brugernavn',
        'Language' => 'Sprog',
        'Languages' => 'Sprog',
        'Password' => 'Adgangskode',
        'Salutation' => 'Hilsen',
        'Signature' => 'Underskrift',
        'Customer' => 'Kunde',
        'CustomerID' => 'Kunde-ID',
        'CustomerIDs' => 'Kunde-ID\'er',
        'customer' => 'kunde',
        'agent' => 'repræsentant',
        'system' => '',
        'Customer Info' => 'Kundeinfo',
        'Customer Company' => '',
        'go!' => 'gå!',
        'go' => 'gå',
        'All' => 'Alle',
        'all' => 'alle',
        'Sorry' => 'Beklager',
        'update!' => 'opdater!',
        'update' => 'opdater',
        'Update' => 'Opdater',
        'submit!' => 'indsend!',
        'submit' => 'indsend',
        'Submit' => 'Indsend',
        'change!' => 'skift!',
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
        'Data' => '',
        'Options' => 'Valgmuligheder',
        'Title' => 'Titel',
        'Item' => 'Punkt',
        'Delete' => 'Slet',
        'Edit' => 'Rediger',
        'View' => 'Vis',
        'Number' => 'Nummer',
        'System' => '',
        'Contact' => 'Kontaktperson',
        'Contacts' => 'Kontaktpersoner',
        'Export' => 'Eksporter',
        'Up' => 'Op',
        'Down' => 'Ned',
        'Add' => 'Tilføj',
        'Category' => 'Kategori',
        'Viewer' => 'Fremviser',
        'New message' => 'Ny meddelelse',
        'New message!' => 'Ny meddelelse!',
        'Please answer this ticket(s) to get back to the normal queue view!' => 'Vær venlig at besvare én eller flere sager for at komme tilbage til køens normale visning!',
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
        'Login failed! Your username or password was entered incorrectly.' => 'Login mislykkedes! Brugernavnet eller adgangskoden blev forkert indtastet.',
        'Please contact your admin' => 'Kontakt din administrator',
        'Logout successful. Thank you for using OTRS!' => 'Du er nu logget ud. Tak fordi du bruger OTRS.',
        'Invalid SessionID!' => 'Ugyldigt sessions-ID!',
        'Feature not active!' => 'Funktionen er ikke aktiv!',
        'Login is needed!' => '',
        'Password is needed!' => 'Adgangskode er påkrævet!',
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
        'No entry found!' => 'Ingen post fundet!',
        'Session has timed out. Please log in again.' => 'Sessionens tidsfrist er udløbet. Vær venlig at logge ind igen.',
        'No Permission!' => 'Ingen tilladelse!',
        'To: (%s) replaced with database email!' => 'Til: (%s) udskiftet med e-mail til database!',
        'Cc: (%s) added database email!' => 'Cc: (%s) tilføjet e-mail til database!',
        '(Click here to add)' => '(Klik her for at tilføje)',
        'Preview' => 'Vis udskrift',
        'Package not correctly deployed! You should reinstall the Package again!' => 'Pakke ikke korrekt indsat. Du bør installere pakken igen.',
        'Added User "%s"' => 'Tilføjet til bruger "%s"',
        'Contract' => 'Kontrakt',
        'Online Customer: %s' => 'Online kunde: %s ',
        'Online Agent: %s' => 'Online repræsentant: %s ',
        'Calendar' => 'Kalender',
        'File' => 'Fil',
        'Filename' => 'Filnavn',
        'Type' => '',
        'Size' => 'Størrelse',
        'Upload' => '',
        'Directory' => 'Katalog',
        'Signed' => 'Underskrevet',
        'Sign' => 'Underskriv',
        'Crypted' => 'Krypteret',
        'Crypt' => 'Krypter',
        'Office' => 'Kontor',
        'Phone' => 'Telefon',
        'Fax' => '',
        'Mobile' => 'Mobil',
        'Zip' => 'Post Nr.',
        'City' => 'By',
        'Country' => 'Land',
        'installed' => 'installeret',
        'uninstalled' => 'afinstalleret',
        'Security Note: You should activate %s because application is already running!' => '',
        'Unable to parse Online Repository index document!' => '',
        'No Packages for requested Framework in this Online Repository, but Packages for other Frameworks!' => '',
        'No Packages or no new Packages in selected Online Repository!' => '',
        'printed at' => 'printed den',

        # Template: AAAMonth
        'Jan' => '',
        'Feb' => '',
        'Mar' => '',
        'Apr' => '',
        'May' => 'Maj',
        'Jun' => '',
        'Jul' => '',
        'Aug' => '',
        'Sep' => '',
        'Oct' => 'Okt',
        'Nov' => '',
        'Dec' => '',
        'January' => 'Januar',
        'February' => 'Februar',
        'March' => 'Marts',
        'April' => '',
        'June' => 'Juni',
        'July' => 'Juli',
        'August' => '',
        'September' => '',
        'October' => 'Oktober',
        'November' => '',
        'December' => '',

        # Template: AAANavBar
        'Admin-Area' => 'Admin-område',
        'Agent-Area' => 'Repræsentant-område',
        'Ticket-Area' => 'Sag-Område',
        'Logout' => 'Log ud',
        'Agent Preferences' => 'Repræsentantindstillinger',
        'Preferences' => 'Indstillinger',
        'Agent Mailbox' => 'Repræsentantmailboks',
        'Stats' => 'Statistik',
        'Stats-Area' => 'Statistikområde',
        'Admin' => '',
        'Customer Users' => 'Kundebrugere',
        'Customer Users <-> Groups' => 'Kundebrugere <-> Grupper',
        'Users <-> Groups' => 'Brugere <-> Grupper',
        'Roles' => 'Roller',
        'Roles <-> Users' => 'Roller <-> Brugere',
        'Roles <-> Groups' => 'Roller <-> Grupper',
        'Salutations' => 'Hilsner',
        'Signatures' => 'Underskrifter',
        'Email Addresses' => 'E-mailadresser',
        'Notifications' => 'Beskeder',
        'Category Tree' => 'Kategoritræ',
        'Admin Notification' => 'Besked til admin',

        # Template: AAAPreferences
        'Preferences updated successfully!' => 'Indstillingerne er opdateret!',
        'Mail Management' => 'Mailstyring',
        'Frontend' => '',
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
        'Max. shown Tickets a page in Overview.' => 'Max. viste sagter pr. side i oversigten.',
        'Can\'t update password, passwords doesn\'t match! Please try it again!' => 'Kan ikke opdatere adgangskode, adgangskoderne er ikke ens! Prøv igen!',
        'Can\'t update password, invalid characters!' => 'Kan ikke opdatere adgangskode, ugyldige tegn!',
        'Can\'t update password, need min. 8 characters!' => 'Kan ikke opdatere adgangskode, der skal være mindst 8 tegn!',
        'Can\'t update password, need 2 lower and 2 upper characters!' => 'Kan ikke opdatere adgangskode, der skal være 2 små og 2 store bogstaver!',
        'Can\'t update password, need min. 1 digit!' => 'Kan ikke opdatere adgangskode, mindst 1 tal mangler!',
        'Can\'t update password, need min. 2 characters!' => 'Kan ikke opdatere adgangskode, mindst 2 tegn mangler!',

        # Template: AAAStats
        'Stat' => 'Statistik',
        'Please fill out the required fields!' => 'Udfyld venligst de påkrævede felter.',
        'Please select a file!' => 'Vælg venligst en fil',
        'Please select an object!' => 'Vælg venligst et objekt',
        'Please select a graph size!' => 'Vælg venligst graf størrelse',
        'Please select one element for the X-axis!' => 'Vælg venligst et element til X-aksen',
        'You have to select two or more attributes from the select field!' => 'Du skal vælge to eller flere attributter fra feltet!',
        'Please select only one element or turn of the button \'Fixed\' where the select field is marked!' => 'Vælg venligst kun et element, eller vend knappen \'Fixed\' hvor feltet er markeret',
        'If you use a checkbox you have to select some attributes of the select field!' => 'For at bruge en checkbox, skal du vælge nogle attributter fra feltet',
        'Please insert a value in the selected input field or turn off the \'Fixed\' checkbox!' => 'Indtast venligst en værdi, i det valghte input felt, eller fra vælg \'Fixed\' checkboxen.',
        'The selected end time is before the start time!' => 'Den valgte sluttid, er før starttiden.',
        'You have to select one or more attributes from the select field!' => 'Du skal vælge en eller flere attributter fra det valgte felt.',
        'The selected Date isn\'t valid!' => 'Den valgte dato er ugyldig.',
        'Please select only one or two elements via the checkbox!' => 'Vælg kun ene eller 2 elemeter fra checkboksene.',
        'If you use a time scale element you can only select one element!' => 'Hvis du bruger en tidsskale, kan du kun vælge et element!',
        'You have an error in your time selection!' => 'iDer er fejl i den valgte tid!',
        'Your reporting time interval is to small, please use a larger time scale!' => 'Rapport tids-intervallet er for kort, vælg en større tids horisont!',
        'The selected start time is before the allowed start time!' => 'Den valgte start tid, er før den tilladte starttid!',
        'The selected end time is after the allowed end time!' => 'Den valgte slut tid, el senere end den tilladte sluttid!',
        'The selected time period is larger than the allowed time period!' => 'Den valgte tidsperiode, er længere end den tilladte tidsperiode!',
        'Common Specification' => 'Fælles sspecifikationer',
        'Xaxis' => 'X-akse',
        'Value Series' => 'Værdi serier',
        'Restrictions' => 'Begrænsning',
        'graph-lines' => 'graf-linjer',
        'graph-bars' => 'graf-bar',
        'graph-hbars' => 'graf-hbar',
        'graph-points' => 'graf-punkter',
        'graph-lines-points' => 'graf-linje-punkter',
        'graph-area' => 'praf-område',
        'graph-pie' => 'graf-cirkel',
        'extended' => 'udvidet',
        'Agent/Owner' => 'Repræsentant/Ejer',
        'Created by Agent/Owner' => 'Oprettet af Repræsentant/Ejer',
        'Created Priority' => 'Oprettelses prioritet',
        'Created State' => 'Oprettelses Status',
        'Create Time' => 'Oprettelses tid',
        'CustomerUserLogin' => 'KundeBrugerLogin',
        'Close Time' => 'Slut tid',

        # Template: AAATicket
        'Lock' => 'Lås',
        'Unlock' => 'Ulåst',
        'History' => 'Historik',
        'Zoom' => 'Vis',
        'Age' => 'Alder',
        'Bounce' => 'Retur til afsender',
        'Forward' => 'Videresend',
        'From' => 'Fra',
        'To' => 'Til',
        'Cc' => '',
        'Bcc' => '',
        'Subject' => 'Emne',
        'Move' => 'Flyt',
        'Queue' => 'Kø',
        'Priority' => 'Prioritering',
        'State' => 'Status',
        'Compose' => 'Skrive',
        'Pending' => 'Afventer',
        'Owner' => 'Ejer',
        'Owner Update' => 'Ejer Opdatering',
        'Responsible' => 'Ansvarlig',
        'Responsible Update' => 'Ansvarlig Opdatering',
        'Sender' => 'Afsender',
        'Article' => 'Artikel',
        'Ticket' => 'Sag',
        'Createtime' => 'Oprettelses tid',
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
        'merged' => '',
        'closed successful' => 'lukning lykkedes',
        'closed unsuccessful' => 'lukning mislykkedes',
        'new' => 'ny',
        'open' => 'åben',
        'closed' => 'lukket',
        'removed' => 'fjernet',
        'pending reminder' => 'afventer påmindelse',
        'pending auto' => '',
        'pending auto close+' => 'afventer autolukning+',
        'pending auto close-' => 'afventer autolukning-',
        'email-external' => 'email-ekstern',
        'email-internal' => 'email-intern',
        'note-external' => 'bemærkning-ekstern',
        'note-internal' => 'bemærkning-intern',
        'note-report' => 'bemærkning-rapport',
        'phone' => 'telefon',
        'sms' => '',
        'webrequest' => 'webanmodning',
        'lock' => 'lås',
        'unlock' => 'ulåst',
        'very low' => 'meget lav',
        'low' => 'lav',
        'normal' => '',
        'high' => 'høj',
        'very high' => 'meget høj',
        '1 very low' => '1 meget lav',
        '2 low' => '2 lav',
        '3 normal' => '',
        '4 high' => '4 høj',
        '5 very high' => '5 meget høj',
        'Ticket "%s" created!' => 'Sag "%s" oprettet!',
        'Ticket Number' => 'Sagsnummer',
        'Ticket Object' => 'Sagsobjekt',
        'No such Ticket Number "%s"! Can\'t link it!' => 'Intet sådant sagsnummer "%s"! Kan ikke sammenkæde det!',
        'Don\'t show closed Tickets' => 'Vis ikke lukkede sag',
        'Show closed Tickets' => 'Vis lukkede sag',
        'New Article' => '',
        'Email-Ticket' => 'E-mail-sag',
        'Create new Email Ticket' => 'Opret ny e-mailsag',
        'Phone-Ticket' => 'Telefon-Sag',
        'Search Tickets' => 'Søg sager',
        'Edit Customer Users' => 'Rediger kundebrugere',
        'Bulk-Action' => 'Massehandling',
        'Bulk Actions on Tickets' => 'Massehandlinger vedrørende sager',
        'Send Email and create a new Ticket' => 'Send e-mail og opret en ny sag',
        'Create new Email Ticket and send this out (Outbound)' => '',
        'Create new Phone Ticket (Inbound)' => '',
        'Overview of all open Tickets' => 'Oversigt over alle åbne sager',
        'Locked Tickets' => 'Låste sager',
        'Watched Tickets' => '',
        'Watched' => '',
        'Subscribe' => '',
        'Unsubscribe' => '',
        'Lock it to work on it!' => 'Lås den for at arbejde på den!',
        'Unlock to give it back to the queue!' => 'Lås den op for at give den tilbage til køen!',
        'Shows the ticket history!' => 'Vis saghistorik!',
        'Print this ticket!' => 'Udskriv denne sag!',
        'Change the ticket priority!' => 'Skift sagsprioriteringen!',
        'Change the ticket free fields!' => 'Skift sagens frie felter!',
        'Link this ticket to an other objects!' => 'Sammenkæd denne sag til et andet objekt!',
        'Change the ticket owner!' => 'Skift sagsejern!',
        'Change the ticket customer!' => 'Skift sagskunden!',
        'Add a note to this ticket!' => 'Tilføj en bemærkning til denne sag!',
        'Merge this ticket!' => 'Saml denne sag!',
        'Set this ticket to pending!' => 'Marker denne sag som afventende!',
        'Close this ticket!' => 'Luk denne sag!',
        'Look into a ticket!' => 'Se nærmere på en sag!',
        'Delete this ticket!' => 'Slet denne sag!',
        'Mark as Spam!' => 'Markér som spam!',
        'My Queues' => 'Mine køer',
        'Shown Tickets' => 'Vis sager',
        'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => 'Din e-mail med sagnummer "<OTRS_TICKET>" er samlet til "<OTRS_MERGE_TO_TICKET>".',
        'New ticket notification' => 'Besked om ny sag',
        'Send me a notification if there is a new ticket in "My Queues".' => 'Send mig en besked, hvis der er en ny sag i "Mine køer".',
        'Follow up notification' => 'Besked om opfølgning',
        'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Send mig en besked, hvis en kunde sender en opfølgning, og jeg er denne sags indehaver.',
        'Ticket lock timeout notification' => 'Besked om saglås efter tidsfristens udløb',
        'Send me a notification if a ticket is unlocked by the system.' => 'Send mig en besked, hvis systemet låser en sag op.',
        'Move notification' => 'Besked om flytning',
        'Send me a notification if a ticket is moved into one of "My Queues".' => 'Send mig en besked, hvis en sag flyttes ind i en af "Mine køer".',
        'Your queue selection of your favourite queues. You also get notified about those queues via email if enabled.' => 'Dit køvalg af foretrukne køer. Du får også besked om disse køer via e-mail, hvis det er aktiveret.',
        'Custom Queue' => 'Brugertilpas kø',
        'QueueView refresh time' => 'KøVisnings genindlæsningstid',
        'Screen after new ticket' => 'Skærm efter ny sag',
        'Select your screen after creating a new ticket.' => 'Vælg din skærm, efter ioprettelse af ny sag.',
        'Closed Tickets' => 'Lukkede sagter',
        'Show closed tickets.' => 'Vis lukkede sagter.',
        'Max. shown Tickets a page in QueueView.' => 'Max. viste sager pr. side i kø-visning - QueueView.',
        'CompanyTickets' => 'Virksomhedssager',
        'MyTickets' => 'MineSager',
        'New Ticket' => 'Ny sag',
        'Create new Ticket' => 'Opret ny sag',
        'Customer called' => 'Opkald fra Kunde',
        'phone call' => 'opringning',
        'Responses' => 'Svar',
        'Responses <-> Queue' => 'Svar <-> Kø',
        'Auto Responses' => 'Autosvar',
        'Auto Responses <-> Queue' => 'Autosvar <-> Kø',
        'Attachments <-> Responses' => 'Vedhæftede filer <-> Responssvar',
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
        'History::Lock' => 'Historik::Lås',
        'History::Unlock' => 'Historik::Lås op',
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
        'To get the first 20 character of the subject.' => '',
        'To get the first 5 lines of the email.' => '',
        'To get the realname of the sender (if given).' => '',
        'To get the article attribut (e. g. (<OTRS_CUSTOMER_From>, <OTRS_CUSTOMER_To>, <OTRS_CUSTOMER_Cc>, <OTRS_CUSTOMER_Subject> and <OTRS_CUSTOMER_Body>).' => '',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>).' => '',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>).' => '',
        'Ticket responsible options (e. g. <OTRS_RESPONSIBLE_UserFirstname>).' => '',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>).' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>).' => '',
        'Config options (e. g. <OTRS_CONFIG_HttpType>).' => '',

        # Template: AdminCustomerCompanyForm
        'Customer Company Management' => '',
        'Add Customer Company' => '',
        'Add a new Customer Company.' => '',
        'List' => '',
        'This values are required.' => 'Disse værdier er påkrævede.',
        'This values are read only.' => 'Disse værdier kan kun læses.',

        # Template: AdminCustomerUserForm
        'Customer User Management' => 'Styring af kundebruger',
        'Search for' => 'Søg efter',
        'Add User' => '',
        'Source' => 'Kilde',
        'Create' => 'Opret',
        'Customer user will be needed to have a customer history and to login via customer panel.' => 'Kundebrugeren er nødvendig for at have en kundehistorik og for at logge ind via kundepanelerne.',

        # Template: AdminCustomerUserGroupChangeForm
        'Customer Users <-> Groups Management' => 'Kundebrugere <-> Gruppestyring',
        'Change %s settings' => 'Skift %s indstillinger',
        'Select the user:group permissions.' => 'Vælg rettigheder til brugeren:gruppen.',
        'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Er intet valgt, er der ingen rettigheder i denne gruppe (der er ingen tilgængelige sag til brugeren).',
        'Permission' => 'Tilladdelse',
        'ro' => '',
        'Read only access to the ticket in this group/queue.' => 'Kun læseadgang til sager i denne gruppe/kø.',
        'rw' => '',
        'Full read and write access to the tickets in this group/queue.' => 'Komplet læse- og skriveadgang til sagerne i denne gruppe/kø.',

        # Template: AdminCustomerUserGroupForm

        # Template: AdminEmail
        'Message sent to' => 'Meddelelse sendt til',
        'Recipents' => 'Modtagere',
        'Body' => 'Hovedtekst',
        'Send' => '',

        # Template: AdminGenericAgent
        'GenericAgent' => 'GeneralRepræsentant',
        'Job-List' => 'Job-Liste',
        'Last run' => 'Sidste kørsel',
        'Run Now!' => 'Kør nu!',
        'x' => '',
        'Save Job as?' => 'Gem et job som?',
        'Is Job Valid?' => 'Er jobbet gyldigt?',
        'Is Job Valid' => 'Er jobbet gyldigt',
        'Schedule' => 'Tidsplan',
        'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fritekstsøgning i artikel (f.eks. "Mar*in" eller "Baue*")',
        '(e. g. 10*5155 or 105658*)' => '(f.eks. 10*5155 eller 105658*)',
        '(e. g. 234321)' => '(f.eks. 234321)',
        'Customer User Login' => 'Kundebrugers login',
        '(e. g. U5150)' => '(f.eks. U5150)',
        'Agent' => 'Repræsentant',
        'Ticket Lock' => 'Sagslås',
        'TicketFreeFields' => 'SagsFriFelter',
        'Create Times' => '',
        'No create time settings.' => '',
        'Ticket created' => 'Sag oprettet',
        'Ticket created between' => 'Sag oprettet mellem',
        'Pending Times' => '',
        'No pending time settings.' => '',
        'Ticket pending time reached' => '',
        'Ticket pending time reached between' => '',
        'New Priority' => 'Ny prioritering',
        'New Queue' => 'Ny kø',
        'New State' => 'Ny status',
        'New Agent' => 'Ny repræsentant',
        'New Owner' => 'Ny ejer',
        'New Customer' => 'Ny kunde',
        'New Ticket Lock' => 'Ny saglås',
        'CustomerUser' => 'KundeBruger',
        'New TicketFreeFields' => 'iNy SagsFriFelter',
        'Add Note' => 'Tilføj bemærkning',
        'CMD' => '',
        'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => 'Denne kommando vil blive udført. ARG[0] bliver sagens nummer. ARG[1] sagens ID. ',
        'Delete tickets' => 'Slet sager',
        'Warning! This tickets will be removed from the database! This tickets are lost!' => 'Advarsel! Denne sag fjernes fra databasen! Denne sag er gået tabt!',
        'Send Notification' => 'Send Meddelse',
        'Param 1' => '',
        'Param 2' => '',
        'Param 3' => '',
        'Param 4' => '',
        'Param 5' => '',
        'Param 6' => '',
        'Send no notifications' => 'Send ingen meddelser',
        'Yes means, send no agent and customer notifications on changes.' => 'Ja betyder, send ingen meddelser til Repræsentant eller Kunde ved ændringer.',
        'No means, send agent and customer notifications on changes.' => 'Nej betyder, send meddelser til Repræsentant eller Kunde ved ændringer.',
        'Save' => 'Gem',
        '%s Tickets affected! Do you really want to use this job?' => '%s sager bliver berørt! Ønsker du stadig at køre dette job.',
        '"}' => '',

        # Template: AdminGroupForm
        'Group Management' => 'Gruppestyring',
        'Add Group' => '',
        'Add a new Group.' => '',
        'The admin group is to get in the admin area and the stats group to get stats area.' => 'Admin-gruppen skal ind i administratorområdet og statistikgruppen i statistikområdet.',
        'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Opret nye grupper til at håndtere adgangstilladelser for repræsentantens forskellige grupper (f.eks. indkøbs-, support- og salgsafdeling ...).',
        'It\'s useful for ASP solutions.' => 'Det er nyttigt for ASP-løsninger.',

        # Template: AdminLog
        'System Log' => 'Systemlog',
        'Time' => 'Tid',

        # Template: AdminMailAccount
        'Mail Account Management' => '',
        'Host' => 'Vært',
        'Account Type' => '',
        'POP3' => '',
        'POP3S' => '',
        'IMAP' => '',
        'IMAPS' => '',
        'Mailbox' => 'Mailboks',
        'Port' => '',
        'Trusted' => 'Pålidelig',
        'Dispatching' => 'Sender',
        'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle indkommende e-mails med 1 konto sendes til den valgte kø!',
        'If your account is trusted, the already existing X-OTRS header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => 'Er der tillid til din konto, bliver den allerede eksisterende X-OTRS-header ved ankomsttidspunktet (for prioritering, ...) anvendt! Der anvendes PostMaster-filter under alle omstændigheder.',

        # Template: AdminNavigationBar
        'Users' => 'Brugere',
        'Groups' => 'Grupper',
        'Misc' => 'Diverse',

        # Template: AdminNotificationForm
        'Notification Management' => 'Beskedstyring',
        'Notification' => 'Besked',
        'Notifications are sent to an agent or a customer.' => 'Beskeder sendes til en repræsentant eller kunde.',

        # Template: AdminPackageManager
        'Package Manager' => 'Pakke Styring',
        'Uninstall' => 'Afinstaller',
        'Version' => '',
        'Do you really want to uninstall this package?' => 'Er du sikker på, du ønsker at afinstallere denne pakke?',
        'Reinstall' => 'Geninstaller',
        'Do you really want to reinstall this package (all manual changes get lost)?' => 'Ønsker du virkeleg at geninstallere denne pakke (Alle manuelle ændringer vil blive slettet)?',
        'Cancle' => '',
        'Continue' => '',
        'Install' => 'Installation',
        'Package' => 'Pakke',
        'Online Repository' => 'Online lagerdepot',
        'Vendor' => 'Sælger',
        'Upgrade' => 'Opgrader',
        'Local Repository' => 'Lokalt lagerdepot',
        'Status' => '',
        'Overview' => 'Oversigt',
        'Download' => '',
        'Rebuild' => 'Genopbyg',
        'ChangeLog' => '',
        'Date' => '',
        'Filelist' => '',
        'Download file from package!' => 'Download fil fra pakke!',
        'Required' => 'Påkrævet',
        'PrimaryKey' => 'PrimærNøgle',
        'AutoIncrement' => 'AutoForhøjelse',
        'SQL' => '',
        'Diff' => '',

        # Template: AdminPerformanceLog
        'Performance Log' => 'Ydelses log',
        'This feature is enabled!' => '',
        'Just use this feature if you want to log each request.' => '',
        'Of couse this feature will take some system performance it self!' => '',
        'Disable it here!' => '',
        'This feature is disabled!' => '',
        'Enable it here!' => '',
        'Logfile too large!' => 'Logfil er for stor',
        'Logfile too large, you need to reset it!' => 'Log fil er fort stor, du skal nulstille den',
        'Range' => 'Område',
        'Interface' => '',
        'Requests' => 'Forespørgsel',
        'Min Response' => 'Min Svar',
        'Max Response' => 'Max Svar',
        'Average Response' => 'Gennemsnitligt Svar',

        # Template: AdminPGPForm
        'PGP Management' => 'PGP-styring',
        'Result' => 'Resultat',
        'Identifier' => 'Identifikator',
        'Bit' => '',
        'Key' => 'Nøgle',
        'Fingerprint' => 'Fingeraftryk',
        'Expires' => 'Udløber',
        'In this way you can directly edit the keyring configured in SysConfig.' => 'Du kan på denne måde direkte redigere den nøglering, der er konfigureret i SysConfig.',

        # Template: AdminPOP3
        'POP3 Account Management' => 'POP3 kontostyring',

        # Template: AdminPostMasterFilter
        'PostMaster Filter Management' => 'PostMasters filterstyring',
        'Filtername' => 'Filternavn',
        'Match' => '',
        'Header' => 'Overskrift',
        'Value' => 'Værdi',
        'Set' => 'Indstil',
        'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => 'Send eller filtrer indkommende e-mail baseret på hver e-mails X-header! RegExp er også mulig.',
        'If you want to match only the email address, use EMAILADDRESS:info@example.com in From, To or Cc.' => '',
        'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => 'Anvender du RegExp, kan du også bruge den matchede værdi i () som [***] i \'Set\'.',

        # Template: AdminQueueAutoResponseForm
        'Queue <-> Auto Responses Management' => 'Kø <-> Styring af autosvar',

        # Template: AdminQueueForm
        'Queue Management' => 'Køstyring',
        'Sub-Queue of' => 'Underkø af',
        'Unlock timeout' => 'Lås tisfristen op',
        '0 = no unlock' => '0 = ingen oplåsning',
        'Escalation - First Response Time' => '',
        '0 = no escalation' => '0 = ingen eskalering',
        'Escalation - Update Time' => '',
        'Escalation - Solution Time' => '',
        'Follow up Option' => 'Opfølgningsmulighed',
        'Ticket lock after a follow up' => 'Sag oplåst efter en opfølgning',
        'Systemaddress' => 'Systemadresse',
        'Customer Move Notify' => 'Kundebesked ved flytning',
        'Customer State Notify' => 'Besked om kunde status',
        'Customer Owner Notify' => 'Besked til kundeejer',
        'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Hvis en repræsentant låser en sag, og vedkommende ikke sender et svar inden for dette tidsrum, låses sagen automatisk op. Derved kan alle andre repræsentanter se sagen.',
        'Escalation time' => 'Eskaleringstid',
        'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Besvares en sag ikke inden for dette tidsrum, vil kun denne sag blive vist.',
        'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Er en sag lukket, og kunden sender en opfølgning, låses sagen for den gamle ejer.',
        'Will be the sender address of this queue for email answers.' => 'Bliver til denne køs afsenderadresse for e-mailsvar.',
        'The salutation for email answers.' => 'Den hilsen, der bruges til e-mailsvar.',
        'The signature for email answers.' => 'Den underskrift, der bruges til e-mailsvar.',
        'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS sender en e-mail med besked til kunden, hvis sagen er flyttet.',
        'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS sender en e-mail med besked til kunden, hvis sagens tilstand er ændret.',
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
        'Add Role' => '',
        'Add a new Role.' => '',
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
        'Active' => 'Aktiv',
        'Select the role:user relations.' => 'Vælg relationer mellem rollen:brugeren.',

        # Template: AdminRoleUserForm

        # Template: AdminSalutationForm
        'Salutation Management' => 'Styring af hilsner',
        'Add Salutation' => '',
        'Add a new Salutation.' => '',

        # Template: AdminSelectBoxForm
        'Select Box' => 'Vælg felt',
        'Limit' => 'Grænse',
        'Go' => '',
        'Select Box Result' => 'Vælg feltresultat',

        # Template: AdminService
        'Service Management' => '',
        'Service' => '',
        'Sub-Service of' => '',

        # Template: AdminSession
        'Session Management' => 'Sessionsstyring',
        'Sessions' => 'Sessioner',
        'Uniq' => 'Unik',
        'Kill all sessions' => '',
        'Session' => '',
        'Content' => 'Indhold',
        'kill session' => 'afbryd session',

        # Template: AdminSignatureForm
        'Signature Management' => 'Underskriftstyring',
        'Add Signature' => '',
        'Add a new Signature.' => '',

        # Template: AdminSLA
        'SLA Management' => '',
        'SLA' => '',
        'First Response Time' => '',
        'Update Time' => '',
        'Solution Time' => '',

        # Template: AdminSMIMEForm
        'S/MIME Management' => 'S/MIME Styring',
        'Add Certificate' => 'Tilføj certifikat',
        'Add Private Key' => 'Tilføj privat nøgle',
        'Secret' => 'Hemmelig',
        'Hash' => '',
        'In this way you can directly edit the certification and private keys in file system.' => 'Du kan på denne måde direkte redigere certificeringsnøgler og private nøgler i filsystemet.',

        # Template: AdminStateForm
        'State Management' => '',
        'Add State' => '',
        'Add a new State.' => '',
        'State Type' => 'Tilstandstype',
        'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Sørg for, at du også opdatede standardtilstandene i Kernel/Config.pm!',
        'See also' => 'Se også',

        # Template: AdminSysConfig
        'SysConfig' => '',
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
        'NavBar' => '',
        'Image' => 'Billede',
        'Prio' => '',
        'Block' => 'Blok',
        'AccessKey' => 'AdgangsNøgle',

        # Template: AdminSystemAddressForm
        'System Email Addresses Management' => 'Systems e-mailadressestyring',
        'Add System Address' => '',
        'Add a new System Address.' => '',
        'Realname' => 'RigtigtNavn',
        'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle indkommende e-mail med denne "E-mail" (Til:) sendes til den valgte kø!',

        # Template: AdminSystemStatus
        'System Status' => '',

        # Template: AdminTicketCustomerNotification
        'Notification (Customer)' => '',
        'Event' => '',
        'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => '',
        'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => '',
        'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => '',
        'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => '',
        'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

        # Template: AdminTypeForm
        'Type Management' => '',
        'Add Type' => '',
        'Add a new Type.' => '',

        # Template: AdminUserForm
        'User Management' => 'Brugerstyring',
        'Add a new Agent.' => '',
        'Login as' => 'Login som',
        'Firstname' => 'Fornavn',
        'Lastname' => 'Efternavn',
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

        # Template: AgentCustomerTableView

        # Template: AgentInfo
        'Info' => '',

        # Template: AgentLinkObject
        'Link Object' => 'Kæd til objekt',
        'Select' => 'Vælg',
        'Results' => 'Resultater',
        'Total hits' => 'Samlede antal hit',
        'Page' => 'Side',
        'Detail' => 'Oplysning',

        # Template: AgentLookup
        'Lookup' => 'Find',

        # Template: AgentNavigationBar

        # Template: AgentPreferencesForm

        # Template: AgentSpelling
        'Spell Checker' => 'Stavekontrolprogram',
        'spelling error(s)' => 'stavefejl',
        'or' => 'eller',
        'Apply these changes' => 'Anvend disse ændringer',

        # Template: AgentStatsDelete
        'Stat#' => '',
        'Do you really want to delete this Object?' => 'Er du sikker på, du ønsker at slette dette objekt?',

        # Template: AgentStatsEditRestrictions
        'Select the restrictions to characterise the stat' => 'Vælg begrænsningerne til at karakterisere stat',
        'Fixed' => 'Fast',
        'Please select only one Element or turn of the button \'Fixed\'.' => 'Vælg venligst kun et Element, eller fravælg knappen \'Fast\'',
        'Absolut Period' => 'Absolut periode',
        'Between' => 'Mellem',
        'Relative Period' => 'Relativ periode',
        'The last' => 'Den sidste',
        'Finish' => 'Færdig',
        'Here you can make restrictions to your stat.' => 'Her kan du begrænse din stat',
        'If you remove the hook in the "Fixed" checkbox, the agent generating the stat can change the attributs of the corresponding element.' => 'Vis du fjerner markeringen i boksen "Fast", kan agenten ændrer attributterne ved det valgte element.',

        # Template: AgentStatsEditSpecification
        'Insert of the common specifications' => 'Indsæt fælles specifikationer',
        'Permissions' => 'Rettigeheder',
        'Format' => '',
        'Graphsize' => 'Graf størrelse',
        'Sum rows' => 'Antal rækker',
        'Sum columns' => 'Antal Kollonner',
        'Cache' => '',
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
        'If a new hardcoded file is available this attribute will be shown and you can select one.' => 'Hvis en hardcoded fil er tilgængelig, vil denne attribut være vist, og du kan vælge den.',
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
        'Here you can the value series. You have the possibility to select one or two elements. Then you can select the attributes of elements. Each attribute will be shown as single value series. If you don\'t select any attribute all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Her kan du vælge værdi serierne. Du har muligheden for at vælge en eller to elementer. Derefter kan du vælge attributter for elementerne. Hvert element vil blive vist som en enkelt værdi sere. Hvis du ikke har valgt nogle attributter, vil alle attributter for elementet blive brugt til at generere stat. Ligesom en ny attribut vil blive tilføjet siden sidste konfiguration.',

        # Template: AgentStatsEditXaxis
        'Select the element, which will be used at the X-axis' => 'Vælg det element der skal bruges ved X-aksen',
        'maximal period' => 'maksimal periode',
        'minimal scale' => 'minimal skala',
        'Here you can define the x-axis. You can select one element via the radio button. Than you you have to select two or more attributes of the element. If you make no selection all attributes of the element will be used if you generate a stat. As well a new attribute is added since the last configuration.' => 'Her kan du definere X-aksen. Du kan vælge et element med radio button. Derefter skal du vælge et eller flere attributter til elementet. Hvis du ikke vælger nogle attributter, vil alle attributter blive brugt, ligesom et nyt attribut vil blive gemt, siden sidste konfiguration.',

        # Template: AgentStatsImport
        'Import' => 'Importer',
        'File is not a Stats config' => 'Filen er ikke en Stats konfiguration',
        'No File selected' => 'Ingen fil valgt',

        # Template: AgentStatsOverview
        'Object' => '',

        # Template: AgentStatsPrint
        'Print' => 'Udskriv',
        'No Element selected.' => 'Intet element er valgt',

        # Template: AgentStatsView
        'Export Config' => 'Eksporter konfiguration',
        'Informations about the Stat' => 'Information om Stat',
        'Exchange Axis' => 'Udskiftning af akser',
        'Configurable params of static stat' => 'Konfigurer bare parametre af en statitisk stat',
        'No element selected.' => 'Intet element er valgt',
        'maximal period from' => '',
        'to' => 'til',
        'Start' => '',
        'With the input and select fields you can configurate the stat at your needs. Which elements of a stat you can edit depends on your stats administrator who configurated the stat.' => 'Med input og select felterne kan du konfigurere en stat til dine behov. Hvilket element af en stat du kan rette afhænger af administratoren der har konfigureret denne stat.',

        # Template: AgentTicketArticleUpdate
        'A message should have a subject!' => 'En meddelelse skal have et emne!',
        'A message should have a body!' => 'En meddelelse skal have en tekst!',
        'You need to account time!' => 'Du skal beregne tiden!',
        'Edit Article' => '',

        # Template: AgentTicketBounce
        'Bounce ticket' => 'Sag retur til afsender',
        'Ticket locked!' => 'Sag låst!',
        'Ticket unlock!' => 'Sag låst op!',
        'Bounce to' => 'Retur til',
        'Next ticket state' => 'Næste sags status',
        'Inform sender' => 'Informer afsender',
        'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Din e-mail med sagnummer "<OTRS_TICKET>" er sendt retur til afsender til "<OTRS_BOUNCE_TO>". Kontakt denne adresse for at få flere oplysninger.',
        'Send mail!' => '',

        # Template: AgentTicketBulk
        'Ticket Bulk Action' => 'Sagsmassehandling',
        'Spell Check' => 'Stavekontrol',
        'Note type' => 'Bemærkningstype',
        'Unlock Tickets' => 'Lås sager op',

        # Template: AgentTicketClose
        'Close ticket' => 'Luk sag',
        'Previous Owner' => 'Tidligere ejer',
        'Inform Agent' => 'Informer Repræsentant',
        'Optional' => 'Valgfri',
        'Inform involved Agents' => 'Informer involverede Repræsentanter',
        'Attach' => 'Vedhæft',
        'Next state' => 'Næste status',
        'Pending date' => 'Afventer dato',
        'Time units' => 'Tidsenheder',
        ' (work units)' => '(arbejdsenheder)',

        # Template: AgentTicketCompose
        'Compose answer for ticket' => 'Formuler svar til sag',
        'Pending Date' => 'Afventer dato',
        'for pending* states' => 'for afventende* tilstande',

        # Template: AgentTicketCustomer
        'Change customer of ticket' => 'Skift sagskunde',
        'Set customer user and customer id of a ticket' => 'Indstil en sags kundebruger og kunde-ID',
        'Customer User' => 'Kundebruger',
        'Search Customer' => 'Søg kunde',
        'Customer Data' => 'Kundedata',
        'Customer history' => 'Kundehistorik',
        'All customer tickets.' => 'Alle kundesager.',

        # Template: AgentTicketCustomerMessage
        'Follow up' => 'Opfølgning',

        # Template: AgentTicketEmail
        'Compose Email' => 'Formuler e-mail',
        'new ticket' => 'ny sag',
        'Refresh' => 'Opdater',
        'Clear To' => 'Ryd til',

        # Template: AgentTicketForward
        'Article type' => 'Artikeltype',

        # Template: AgentTicketFreeText
        'Change free text of ticket' => 'Skift sagens fritekst',

        # Template: AgentTicketHistory
        'History of' => 'Historik af',

        # Template: AgentTicketLocked

        # Template: AgentTicketMailbox
        'Tickets' => 'Sager',
        'of' => 'af',
        'Filter' => '',
        'New messages' => 'Nye meddelelser',
        'Reminder' => 'Påmindelse',
        'Sort by' => 'Sorter efter',
        'Order' => 'Ordre',
        'up' => 'op',
        'down' => 'ned',

        # Template: AgentTicketMerge
        'Ticket Merge' => 'Sagfletning',
        'Merge to' => 'Saml til',

        # Template: AgentTicketMove
        'Move Ticket' => 'Flyt sag',

        # Template: AgentTicketNote
        'Add note to ticket' => 'Tilføj bemærkning til sag',

        # Template: AgentTicketOwner
        'Change owner of ticket' => 'Skift sagejer',

        # Template: AgentTicketPending
        'Set Pending' => 'Indstil afventer',

        # Template: AgentTicketPhone
        'Phone call' => 'Telefonopkald',
        'Clear From' => 'Ryd fra',

        # Template: AgentTicketPhoneOutbound

        # Template: AgentTicketPlain
        'Plain' => 'Almindelig',
        'TicketID' => 'Sag-ID',
        'ArticleID' => 'Artikel-ID',

        # Template: AgentTicketPrint
        'Ticket-Info' => 'Sag-Info',
        'Accounted time' => 'Benyttet tid',
        'Escalation in' => 'Eskalering ind',
        'Linked-Object' => 'Linket-Objekt',
        'Parent-Object' => 'Forældre-Objekt',
        'Child-Object' => 'Barn-Objekt',
        'by' => 'af',

        # Template: AgentTicketPriority
        'Change priority of ticket' => 'Skift sagsprioritering',

        # Template: AgentTicketQueue
        'Tickets shown' => 'Viste sager',
        'Tickets available' => 'Ledige sager',
        'All tickets' => 'Alle sager',
        'Queues' => 'Køer',
        'Ticket escalation!' => 'Sagskalering!',

        # Template: AgentTicketQueueTicketView
        'First Response' => '',
        'Service Time' => '',
        'Your own Ticket' => 'Din egen sag',
        'Compose Follow up' => 'Formuler opfølgning',
        'Compose Answer' => 'Formuler svar',
        'Contact customer' => 'Kontakt kunde',
        'Change queue' => 'Skift kø',

        # Template: AgentTicketQueueTicketViewLite

        # Template: AgentTicketResponsible
        'Change responsible of ticket' => 'Skift Ansvarlig for sag',

        # Template: AgentTicketSearch
        'Ticket Search' => 'Sagssøgning',
        'Profile' => 'Profil',
        'Search-Template' => 'Søge-skabelon',
        'TicketFreeText' => 'SagFriTekst',
        'Created in Queue' => 'Oprettet i kø',
        'Result Form' => 'Resultatformular',
        'Save Search-Profile as Template?' => 'Gem søgeprofil som skabelon?',
        'Yes, save it with name' => 'Ja, gem den med navn',

        # Template: AgentTicketSearchResult
        'Search Result' => 'Søgeresultat',
        'Change search options' => 'Skift søgemuligheder',

        # Template: AgentTicketSearchResultPrint

        # Template: AgentTicketSearchResultShort
        'U' => 'O',
        'D' => 'N',

        # Template: AgentTicketStatusView
        'Ticket Status View' => 'Sagsstatusvisning',
        'Open Tickets' => 'Åbne sager',
        'Locked' => 'Låst',

        # Template: AgentTicketZoom

        # Template: AgentWindowTab

        # Template: Copyright

        # Template: css

        # Template: customer-css

        # Template: CustomerAccept

        # Template: CustomerCalendarSmallIcon

        # Template: CustomerError
        'Traceback' => 'Tilbagesporing',

        # Template: CustomerFAQ

        # Template: CustomerFooter
        'Powered by' => 'Drevet af',

        # Template: CustomerFooterSmall

        # Template: CustomerHeader

        # Template: CustomerHeaderSmall

        # Template: CustomerLogin
        'Login' => '',
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

        # Template: CustomerTicketSearchResultCSV

        # Template: CustomerTicketSearchResultPrint

        # Template: CustomerTicketSearchResultShort

        # Template: CustomerTicketZoom

        # Template: CustomerWarning

        # Template: Error
        'Click here to report a bug!' => 'Klik her for at rapportere en fejl!',

        # Template: Footer
        'Top of Page' => 'Øverst på siden',

        # Template: FooterSmall

        # Template: Header

        # Template: HeaderSmall

        # Template: Installer
        'Web-Installer' => 'Web-Installation',
        'Accept license' => '',
        'Don\'t accept license' => '',
        'Admin-User' => 'Admin-bruger',
        'Admin-Password' => 'Admin-adgangskode',
        'your MySQL DB should have a root password! Default is empty!' => 'din MySQL DB skat have en rod-adgangskode! Standarden er tom!',
        'Database-User' => 'Database-bruger',
        'default \'hot\'' => 'standard \'hot\'',
        'DB connect host' => 'DB tilsluttes værtscomputer',
        'Database' => '',
        'false' => 'negativ',
        'SystemID' => 'System-ID',
        '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Systemets identificering. Hvert sagnummer og hver http-sessions ID starter med dette tal) ',
        'System FQDN' => 'Systemets FQDN',
        '(Full qualified domain name of your system)' => '(Dit systems FQDN(Fully qualified domain name)) ',
        'AdminEmail' => 'AdminE-mail',
        '(Email of the system admin)' => '(Systemadministrators e-mail)',
        'Organization' => 'Organisation',
        'Log' => '',
        'LogModule' => 'LogModul',
        '(Used log backend)' => '(Anvendt log til backend)',
        'Logfile' => 'Logfil',
        '(Logfile just needed for File-LogModule!)' => '(Logfilen behøves kun til Fil-LogModul!)',
        'Webfrontend' => '',
        'Default Charset' => 'Standardtegnsæt',
        'Use utf-8 it your database supports it!' => 'Anvend utf-8, hvis din database understøtter det!',
        'Default Language' => 'Standardsprog',
        '(Used default language)' => '(Anvendt standardsprog)',
        'CheckMXRecord' => 'KontrollerMXRecord',
        '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrollerer MX-records af anvendte e-mailadresser ved at udforme et svar. Anvend ikke KontrollerMXRecord, hvis OTRS-maskinen befinder sig bag en opkaldslinje $!)',
        'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'For at kunne anvende OTRS, er du nødt til at indtaste følgende linje i din kommandolinje (Terminal/Shell) som root.',
        'Restart your webserver' => 'Genstart webserveren',
        'After doing so your OTRS is up and running.' => 'Når det er gjort, er din OTRS sat i gang og fungerer.',
        'Start page' => 'Startside',
        'Have a lot of fun!' => 'Hav det rigtig sjovt!',
        'Your OTRS Team' => 'Dit OTRS Team',

        # Template: Login
        'Welcome to %s' => 'Velkommen til %s',

        # Template: Motd

        # Template: NoPermission
        'No Permission' => 'Ingen Rettighed',

        # Template: Notify
        'Important' => 'Vigtigt',

        # Template: PrintFooter
        'URL' => '',

        # Template: PrintHeader
        'printed by' => 'udskrevet af',

        # Template: PublicFAQ

        # Template: PublicView
        'Management Summary' => '',

        # Template: Redirect

        # Template: Test
        'OTRS Test Page' => 'OTRS prøveside',
        'Counter' => 'Tæller',

        # Template: Warning
        # Misc
        'Create Database' => 'Opret database',
        'DB Host' => 'DB værtscomputer',
        'Ticket Number Generator' => 'Sagsnummergenerator',
        '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Sagidentifikator. Nogle personer ønsker at indstille dette til f.eks. \Ticket#\, \Call#\ eller \MyTicket#\)',
        'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => 'Du kan på denne måde direkte redigere den nøglering, der er konfigureret i Kernel/Config.pm.',
        'Create new Phone Ticket' => 'Opret ny telefonsag',
        'Symptom' => 'Symptom',
        'A message should have a To: recipient!' => 'En meddelelse skal have en Til: modtager!',
        'Site' => 'Websted',
        'Customer history search (e. g. "ID342425").' => 'Kundehistoriksøgning (f.eks. "ID342425").',
        'Close!' => 'Luk!',
        'for agent firstname' => 'til repræsentantens fornavn',
        'The message being composed has been closed.  Exiting.' => 'Den meddelelse, der er ved at blive formuleret, er blevet lukket.  Afslutter.',
        'A web calendar' => 'En webkalender',
        'to get the realname of the sender (if given)' => 'for at få afsenderens virkelige navn (hvis det er oplyst)',
        'OTRS DB Name' => 'OTRS DB-navn',
        'Select Source (for add)' => 'Vælg kilde (til tilføjelse)',
        'Queue ID' => 'Kø-ID',
        'Home' => 'Hjem',
        'Config options (e. g. <OTRS_CONFIG_HttpType>)' => 'Konfigurationsmuligheder (f.eks. <OTRS_CONFIG_HttpType>)',
        'System History' => 'Systemhistorik',
        'customer realname' => 'kundens virkelige navn',
        'Pending messages' => 'Afventer meddelelser',
        'Modules' => 'Moduler',
        'for agent login' => 'til repræsentantens login',
        'Keyword' => 'Søgeord',
        'Close type' => 'Luk type',
        'DB Admin User' => 'DB-admin-bruger',
        'for agent user id' => 'til repræsentantens bruger-ID',
        'sort upward' => 'sorter stigende',
        'Change user <-> group settings' => 'Skift bruger <-> gruppeindstillinger',
        'Problem' => 'Problem',
        'next step' => 'næste trin',
        'Customer history search' => 'Kunde historik søgning',
        'Admin-Email' => 'Admin-E-mail',
        'Create new database' => 'Opret ny database',
        'A message must be spell checked!' => 'En meddelelse skal stavekontrolleres!',
        'All Agents' => 'Alle Repræsentanter',
        'Keywords' => 'Søgeord',
        'No * possible!' => 'Ingen * er mulig!',
        'Message for new Owner' => 'Meddelelse til ny ejer',
        'to get the first 5 lines of the email' => 'for at få e-mailens første 5 linjer',
        '}' => '}',
        'OTRS DB Password' => 'OTRS DB-adgangskode',
        'Last update' => 'Sidste opdatering',
        'to get the first 20 character of the subject' => 'for at få emnets første 20 tegn',
        'DB Admin Password' => 'DB-admins adgangskode',
        'Advisory' => 'Bekendtgørelse',
        'Drop Database' => 'Udelad database',
        'FileManager' => 'FilManager',
        'Options of the current customer user data (e. g. <OTRS_CUSTOMER_DATA_UserFirstname>)' => 'Valgmuligheder for de aktuelle kundebrugerdata (f.eks. <OTRS_CUSTOMER_DATA_UserFirstname>)',
        'Pending type' => 'Afventer type',
        'Comment (internal)' => 'Kommentar (intern)',
        'This window must be called from compose window' => 'Dette vindue skal åbnes via Skriv-vinduet.',
        'You need min. one selected Ticket!' => 'Du skal vælge mindst 1 dag!',
        'Options of the ticket data (e. g. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for sagens data (f.eks. <OTRS_TICKET_Number>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        '(Used ticket number format)' => '(Anvendt sagsnummerformat)',
        'Fulltext' => 'Fritekst',
        'Incident' => 'Hændelse',
        'All Agent variables.' => 'Alle repræsentant variabler',
        'All Customer variables like defined in config option CustomerUser.' => 'Alle kundevariabler som definerede i konfigurationsmuligheden KundeBruger.',
        'accept license' => 'accepter licens',
        '0' => '0',
        'for agent lastname' => 'til agents efternavn',
        'Options of the current user who requested this action (e. g. <OTRS_CURRENT_UserFirstname>)' => 'Valgmuligheder for den aktuelle bruger, som anmodede om denne handling (f.eks. <OTRS_CURRENT_UserFirstname>)',
        'Reminder messages' => 'Påmindelsesmeddelelser',
        'Don\'t forget to add a new user to groups!' => 'Glem ikke at tilføje en ny bruger til grupper!',
        'You need a email address (e. g. customer@example.com) in To:!' => 'Der skal være en e-mailadresse (f.eks. customer@eksempel.com) i feltet Til:!',
        'CreateTicket' => 'Opret sag',
        'System Settings' => 'Systemindstillinger',
        'WebWatcher' => '',
        'Finished' => 'Færdig',
        'Split' => 'Del',
        'All messages' => 'Alle meddelelser',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for de aktuelle sagsdata (f.eks. lt;OTRS_TICKET_TicketNumber>, <OTRS_TICKET_ID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Artefact' => 'Artefakt',
        'A article should have a title!' => 'En artikel skal have en titel!',
        'don\'t accept license' => 'accepter ikke licens',
        'A web mail client' => 'En webmailklient',
        'WebMail' => '',
        'Options of the ticket data (e. g. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)' => 'Valgmuligheder for sagens data (f.eks. <OTRS_TICKET_TicketNumber>, <OTRS_TICKET_TicketID>, <OTRS_TICKET_Queue>, <OTRS_TICKET_State>)',
        'Ticket owner options (e. g. <OTRS_OWNER_UserFirstname>)' => 'Sagsejers valgmuligheder (f.eks. <OTRS_OWNER_UserFirstname>)',
        'Name is required!' => 'Navn er påkrævet!',
        'DB Type' => 'DB type',
        'Termin1' => 'Termin1',
        'kill all sessions' => 'afbryd alle sessioner',
        'to get the from line of the email' => 'for at få e-mailens "fra"-linje',
        'Solution' => 'Løsning',
        'Package not correctly deployed, you need to deploy it again!' => 'Pakken blev ikke korrekt installeret, den skal installeres igen!',
        'QueueView' => 'KøVisning',
        'Welcome to OTRS' => 'Velkommen til OTRS',
        'modified' => 'modificeret',
        'Delete old database' => 'Slet gammel database',
        'sort downward' => 'sorter faldende',
        'You need to use a ticket number!' => 'Du skal have et sagsnummer!',
        'A web file manager' => 'En webfilmanager',
        'send' => '',
        'Note Text' => 'Bemærkningstekst',
        'System State Management' => 'Systemtilstandsstyring',
        'OTRS DB User' => 'OTRS DB-bruger',
        'PhoneView' => 'TelefonVisning',
        'maximal period form' => 'maksimal periode form',
        'Verion' => 'Version',
        'SMIME Management' => 'SMIME-styring',
        'Modified' => 'Modificeret',
        'Ticket selected for bulk action!' => 'Sag valgt til massehandling!',
        'Company' => '',
    };
    # $$STOP$$
}
1;
