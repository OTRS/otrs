# --
# Kernel/Language/nb_NO.pm - Norwegian language translation (bokmål)
# Copyright (C) 2004 Arne Georg Gleditsch <argggh@linpro.no>
# --
# $Id: nb_NO.pm,v 1.14 2005-08-12 08:14:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::nb_NO;

use strict;

use vars qw($VERSION);
$VERSION = q$Revision: 1.14 $;
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # $$START$$
    # Last translation file sync: Thu Jul 28 22:14:31 2005

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M %Y %T';
    $Self->{DateFormatLong} = '%A %D. %B %Y %T';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    $Self->{Translation} = {
      # Template: AAABase
      'Yes' => 'Ja',
      'No' => 'Nei',
      'yes' => 'ja',
      'no' => 'ingen',
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
      'day' => 'dag',
      'days' => 'dager',
      'day(s)' => 'dag(er)',
      'hour' => 'time',
      'hours' => 'timer',
      'hour(s)' => 'time(r)',
      'minute' => 'minutt',
      'minutes' => 'minutter',
      'minute(s)' => 'minutt(er)',
      'month' => 'måned',
      'months' => 'måneder',
      'month(s)' => 'måned(er)',
      'week' => 'uke',
      'week(s)' => 'uke(r)',
      'year' => 'år',
      'years' => 'år',
      'year(s)' => 'år',
      'wrote' => 'skrev',
      'Message' => 'Melding',
      'Error' => 'Feil',
      'Bug Report' => 'Rapporter feil',
      'Attention' => 'OBS',
      'Warning' => 'Advarsel',
      'Module' => 'Modul',
      'Modulefile' => 'Modulfil',
      'Subfunction' => 'Underfunksjon',
      'Line' => 'Linje',
      'Example' => 'Eksempel',
      'Examples' => 'Eksempler',
      'valid' => 'gyldig',
      'invalid' => 'ugyldig',
      'invalid-temporarily' => '',
      ' 2 minutes' => ' 2 minutter',
      ' 5 minutes' => ' 5 minutter',
      ' 7 minutes' => ' 7 minutter',
      '10 minutes' => '10 minutter',
      '15 minutes' => '15 minutter',
      'Mr.' => '',
      'Mrs.' => '',
      'Next' => '',
      'Back' => 'Tilbake',
      'Next...' => '',
      '...Back' => '',
      '-none-' => '',
      'none' => 'ingen',
      'none!' => 'ingen!',
      'none - answered' => 'ingen - besvart',
      'please do not edit!' => 'Vennligst ikke endre!',
      'AddLink' => 'Legg til link',
      'Link' => '',
      'Linked' => '',
      'Link (Normal)' => '',
      'Link (Parent)' => '',
      'Link (Child)' => '',
      'Normal' => '',
      'Parent' => '',
      'Child' => '',
      'Hit' => 'Treff',
      'Hits' => 'Treff',
      'Text' => 'Tekst',
      'Lite' => 'Enkel',
      'User' => 'Bruker',
      'Username' => 'Brukernavn',
      'Language' => 'Språk',
      'Languages' => 'Språk',
      'Password' => 'Passord',
      'Salutation' => 'Hilsning',
      'Signature' => 'Signatur',
      'Customer' => 'Kunde',
      'CustomerID' => 'Organisasjons-ID',
      'CustomerIDs' => '',
      'customer' => 'kunde',
      'agent' => '',
      'system' => 'System',
      'Customer Info' => 'Kunde-info',
      'go!' => 'Start!',
      'go' => 'Start',
      'All' => 'Alle',
      'all' => 'alle',
      'Sorry' => 'Beklager',
      'update!' => 'Oppdater!',
      'update' => 'oppdater',
      'Update' => 'Oppdater',
      'submit!' => 'Send!',
      'submit' => 'Send',
      'Submit' => '',
      'change!' => 'endre!',
      'Change' => 'Endre',
      'change' => 'endre',
      'click here' => 'klikk her',
      'Comment' => 'Kommentar',
      'Valid' => 'Gyldig',
      'Invalid Option!' => '',
      'Invalid time!' => '',
      'Invalid date!' => '',
      'Name' => 'Navn',
      'Group' => 'Gruppe',
      'Description' => 'Beskrivelse',
      'description' => 'beskrivelse',
      'Theme' => 'Tema',
      'Created' => 'Opprettet',
      'Created by' => '',
      'Changed' => '',
      'Changed by' => '',
      'Search' => 'Søk',
      'and' => 'og',
      'between' => '',
      'Fulltext Search' => '',
      'Data' => '',
      'Options' => 'Opsjoner',
      'Title' => '',
      'Item' => '',
      'Delete' => 'Slett',
      'Edit' => 'Rediger',
      'View' => 'Bilde',
      'Number' => '',
      'System' => '',
      'Contact' => 'Kontakt',
      'Contacts' => '',
      'Export' => '',
      'Up' => '',
      'Down' => '',
      'Add' => 'Legg til',
      'Category' => 'Kategori',
      'Viewer' => '',
      'New message' => 'Ny melding',
      'New message!' => 'Ny melding!',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Vennligst besvar denne/disse ticketene for å komme tilbake til det normale kø-visningsbildet!',
      'You got new message!' => 'Du har en ny melding!',
      'You have %s new message(s)!' => 'Du har %s ny(e) melding(er)!',
      'You have %s reminder ticket(s)!' => 'Du har %s påminnelses-ticket(er)!',
      'The recommended charset for your language is %s!' => 'Anbefalt tegnsett for ditt språk er %s!',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Password is already in use! Please use an other password!' => '',
      'Password is already used! Please use an other password!' => '',
      'You need to activate %s first to use it!' => '',
      'No suggestions' => 'Ingen forslag',
      'Word' => 'Ord',
      'Ignore' => 'Ignorere',
      'replace with' => 'Erstatt med',
      'Welcome to OTRS' => 'Velkommen til OTRS',
      'There is no account with that login name.' => 'Finner ingen konto med det navnet.',
      'Login failed! Your username or password was entered incorrectly.' => 'Innlogging feilet! Oppgitt brukernavn og/eller passord er ikke korrekt.',
      'Please contact your admin' => 'Vennligst ta kontakt med administrator',
      'Logout successful. Thank you for using OTRS!' => 'Utlogging utført.  Takk for at du brukte OTRS!',
      'Invalid SessionID!' => 'Ugydlig SessionID!',
      'Feature not active!' => 'Funksjon ikke aktivert!',
      'Take this Customer' => '',
      'Take this User' => 'Velg denne brukeren',
      'possible' => 'Gjenåpner',
      'reject' => 'Avvises',
      'Facility' => 'Innretning',
      'Timeover' => 'Tidsoverskridelse',
      'Pending till' => 'Utsatt til',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Det er ikke anbefalt å arbeide som userid 1 (systemkonto)! Opprett heller nye brukere!',
      'Dispatching by email To: field.' => 'Utsending etter oppføringer i To:-felt.',
      'Dispatching by selected Queue.' => 'Utsending etter valgt kø.',
      'No entry found!' => 'Ingen innslag funnet!',
      'Session has timed out. Please log in again.' => 'Sesjonen har gått ut på tid.  Vennligst logg på igjen.',
      'No Permission!' => '',
      'To: (%s) replaced with database email!' => 'Til: (%s) erstattet med mail fra database!',
      'Cc: (%s) added database email!' => '',
      '(Click here to add)' => '(Klikk her for å legge til)',
      'Preview' => 'Forhåndsvisning',
      'Added User "%s"' => 'Lagt til bruker "%s"',
      'Contract' => '',
      'Online Customer: %s' => '',
      'Online Agent: %s' => '',
      'Calendar' => '',
      'File' => '',
      'Filename' => 'Filnavn',
      'Type' => '',
      'Size' => '',
      'Upload' => '',
      'Directory' => '',
      'Signed' => '',
      'Sign' => '',
      'Crypted' => '',
      'Crypt' => '',

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

      # Template: AAANavBar
      'Admin-Area' => 'Admin-område',
      'Agent-Area' => 'Agent-område',
      'Ticket-Area' => '',
      'Logout' => 'Logg ut',
      'Agent Preferences' => '',
      'Preferences' => 'Innstillinger',
      'Agent Mailbox' => '',
      'Stats' => 'Statistikk',
      'Stats-Area' => '',
      'FAQ-Area' => 'FAQ-område',
      'FAQ' => '',
      'FAQ-Search' => '',
      'FAQ-Article' => '',
      'New Article' => 'Ny artikkel',
      'FAQ-State' => '',
      'Admin' => '',
      'A web calendar' => '',
      'WebMail' => '',
      'A web mail client' => '',
      'FileManager' => '',
      'A web file manager' => '',
      'Artefact' => '',
      'Incident' => '',
      'Advisory' => '',
      'WebWatcher' => '',
      'Customer Users' => '',
      'Customer Users <-> Groups' => '',
      'Users <-> Groups' => '',
      'Roles' => '',
      'Roles <-> Users' => '',
      'Roles <-> Groups' => '',
      'Salutations' => '',
      'Signatures' => '',
      'Email Addresses' => '',
      'Notifications' => '',
      'Category Tree' => '',
      'Admin Notification' => '',

      # Template: AAAPreferences
      'Preferences updated successfully!' => 'Innstillinger lagret!',
      'Mail Management' => 'E-post-administrasjon',
      'Frontend' => 'Grensesnitt',
      'Other Options' => 'Andre valg',
      'Change Password' => 'Endre passord',
      'New password' => 'Nytt passord',
      'New password again' => 'Nytt passord igjen',
      'Select your QueueView refresh time.' => 'Velg automatisk oppdateringsfrekvens i mappebilde.',
      'Select your frontend language.' => 'Velg språk.',
      'Select your frontend Charset.' => 'Velg tegnsett.',
      'Select your frontend Theme.' => 'Velg stil-tema.',
      'Select your frontend QueueView.' => 'Velg mappebilde.',
      'Spelling Dictionary' => 'Ordbok for stavekontroll',
      'Select your default spelling dictionary.' => 'Velg standard ordbok for stavekontroll.',
      'Max. shown Tickets a page in Overview.' => 'Max. viste saker per side i oversikten.',
      'Can\'t update password, passwords dosn\'t match! Please try it again!' => '',
      'Can\'t update password, invalid characters!' => '',
      'Can\'t update password, need min. 8 characters!' => '',
      'Can\'t update password, need 2 lower and 2 upper characters!' => '',
      'Can\'t update password, need min. 1 digit!' => '',
      'Can\'t update password, need min. 2 characters!' => '',
      'Password is needed!' => '',

      # Template: AAATicket
      'Lock' => 'Ta sak',
      'Unlock' => 'Frigi sak',
      'History' => 'Historikk',
      'Zoom' => 'Detaljer',
      'Age' => 'Alder',
      'Bounce' => '',
      'Forward' => 'Videresende',
      'From' => 'Fra',
      'To' => 'Til',
      'Cc' => '',
      'Bcc' => '',
      'Subject' => 'Emne',
      'Move' => 'Flytt',
      'Queue' => 'Mappe',
      'Priority' => 'Prioritet',
      'State' => 'Status',
      'Compose' => 'Forfatt',
      'Pending' => 'Sett på vent',
      'Owner' => 'Saksbehandler',
      'Owner Update' => '',
      'Sender' => '',
      'Article' => 'Artikkel',
      'Ticket' => 'Sak',
      'Createtime' => 'Opprettet',
      'plain' => 'rå',
      'eMail' => 'E-post',
      'email' => 'e-post',
      'Close' => 'Avslutt sak',
      'Action' => 'Aksjon',
      'Attachment' => 'Vedlegg',
      'Attachments' => 'Vedlegg',
      'This message was written in a character set other than your own.' => 'Denne meldingen ble skrevet i et annet tegnsett enn det du bruker.',
      'If it is not displayed correctly,' => 'Dersom den ikke vises korrekt,',
      'This is a' => 'Dette er en',
      'to open it in a new window.' => 'for å åpne i nytt vindu',
      'This is a HTML email. Click here to show it.' => 'Dette er en HTML e-post. Klikk her for å vise den.',
      'Free Fields' => 'Stikkord',
      'Merge' => '',
      'closed successful' => 'løst og avsluttet',
      'closed unsuccessful' => 'uløst, men avsluttet',
      'new' => 'ny',
      'open' => 'åpen',
      'closed' => 'avsluttet',
      'removed' => 'fjernet',
      'pending reminder' => 'venter på påminnelse',
      'pending auto close+' => 'venter på avslutting (løst)',
      'pending auto close-' => 'venter på avslutting (uløst)',
      'email-external' => 'e-post eksternt',
      'email-internal' => 'e-post internt',
      'note-external' => 'notis eksternt',
      'note-internal' => 'notis internt',
      'note-report' => 'notis til rapport',
      'phone' => 'telefon',
      'sms' => '',
      'webrequest' => 'web-forespørsel',
      'lock' => 'privat',
      'unlock' => 'tilgjengelig',
      'very low' => 'svært lav',
      'low' => 'lav',
      'normal' => '',
      'high' => 'høy',
      'very high' => 'svært høy',
      '1 very low' => '1 svært lav',
      '2 low' => '2 lav',
      '3 normal' => '',
      '4 high' => '4 høy',
      '5 very high' => '5 svært høy',
      'Ticket "%s" created!' => 'Sak "%s" opprettet!',
      'Ticket Number' => 'Saksnr',
      'Ticket Object' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => 'Finner ikke saksnummer "%s"! Kan ikke linke til det!',
      'Don\'t show closed Tickets' => 'Ikke vis avsluttede saker',
      'Show closed Tickets' => 'Vis avsluttede saker',
      'Email-Ticket' => 'Send e-post',
      'Create new Email Ticket' => 'Opprett ny sak ved å sende e-post',
      'Phone-Ticket' => 'Henvendelser',
      'Create new Phone Ticket' => 'Opprett ny henvendelse',
      'Search Tickets' => 'Søk i saker',
      'Edit Customer Users' => '',
      'Bulk-Action' => '',
      'Bulk Actions on Tickets' => '',
      'Send Email and create a new Ticket' => 'Send e-post og opprett en ny sak',
      'Overview of all open Tickets' => 'Oversikt over alle tilgjengelige saker',
      'Locked Tickets' => 'Mine private saker',
      'Lock it to work on it!' => 'Sett sak som privat eller tilgjengelig!',
      'Unlock to give it back to the queue!' => 'Gjør saken tilgjengelig i mappen!',
      'Shows the ticket history!' => 'Se på historikken til saken!',
      'Print this ticket!' => 'Skriv ut denne saken!',
      'Change the ticket priority!' => 'Endre prioritet på saken!',
      'Change the ticket free fields!' => 'Endre stikkordene!',
      'Link this ticket to an other objects!' => 'Link denne saken til en annen sak!',
      'Change the ticket owner!' => 'Endre saksbehandler til saken!',
      'Change the ticket customer!' => 'Endre kunde til saken!',
      'Add a note to this ticket!' => 'Legg til notis til saken!',
      'Merge this ticket!' => '',
      'Set this ticket to pending!' => 'Sett saken på vent!',
      'Close this ticket!' => 'Avslutt denne saken!',
      'Look into a ticket!' => '',
      'Delete this ticket!' => '',
      'Mark as Spam!' => '',
      'My Queues' => '',
      'Shown Tickets' => 'Viste saker',
      'New ticket notification' => 'Merknad ved nyopprettet sak',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Send meg en melding dersom det kommer en ny sak i mine utvalgte mapper.',
      'Follow up notification' => 'Oppfølgingsmerknad',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Send meg en melding ved kundekorrespondanse på saker jeg står som saksbehandler av.',
      'Ticket lock timeout notification' => 'Melding ved overskridelse av tidsfrist for avslutting av sak',
      'Send me a notification if a ticket is unlocked by the system.' => 'Send meg en melding dersom systemet åpner en avsluttet sak.',
      'Move notification' => 'Merknad ved mappe-endring',
      'Send me a notification if a ticket is moved into one of "My Queues".' => 'Send meg en melding dersom en sak flyttes over i en av mine utvalgte mapper.',
      'Your queue selection of your favorite queues. You also get notified about this queues via email if enabled.' => 'Her velger du dine utvalgte mapper. Du vil også få påminnelser fra disse mappene, hvis du har valgt det.',
      'Custom Queue' => 'Utvalgte mapper',
      'QueueView refresh time' => 'Automatisk oppdateringsfrekvens av mappe',
      'Screen after new ticket' => 'Skjermbilde etter innlegging av ny sak',
      'Select your screen after creating a new ticket.' => 'Velg skjermbilde som vises etter registrering av ny sak.',
      'Closed Tickets' => 'Avsluttede saker',
      'Show closed tickets.' => 'Vis avsluttede saker.',
      'Max. shown Tickets a page in QueueView.' => 'Max. viste saker per side i mappevisningen.',
      'Responses' => 'Ferdigsvar',
      'Responses <-> Queue' => 'Ferdigsvar <-> Mapper',
      'Auto Responses' => 'Autosvar',
      'Auto Responses <-> Queue' => 'Autosvar <-> Mapper',
      'Attachments <-> Responses' => 'Vedlegg <-> Ferdigsvar',
      'History::Move' => 'Sak flyttet inn i mappe "%s" (%s) fra mappe "%s" (%s).',
      'History::NewTicket' => 'Ny sak [%s] opprettet (Q=%s;P=%s;S=%s).',
      'History::FollowUp' => 'Oppfølging til sak [%s]. %s',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoSvar sendt til "%s".',
      'History::SendAutoFollowUp' => 'AutoOppfølging sendt til "%s".',
      'History::Forward' => 'Videresendt til "%s".',
      'History::Bounce' => 'Bounced to "%s".',
      'History::SendAnswer' => 'E-post sendt til "%s".',
      'History::SendAgentNotification' => '"%s"-påminnelse sendt til "%s".',
      'History::SendCustomerNotification' => 'Påminnelse sendt til "%s".',
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
      'History::PriorityUpdate' => 'Endret prioritet fra "%s" (%s) til "%s" (%s).',
      'History::OwnerUpdate' => 'Ny saksbehandler er "%s" (ID=%s).',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::SetPendingTime' => 'Sett på vent til: %s',
      'History::StateUpdate' => 'Gammel: "%s" Ny: "%s"',
      'History::TicketFreeTextUpdate' => 'Stikkord oppdatert: %s=%s;%s=%s;',
      'History::WebRequestCustomer' => 'Kundeforespørsel via web.',
      'History::TicketLinkAdd' => 'La til link til sak "%s".',
      'History::TicketLinkDelete' => 'Slettet link til sak "%s".',

      # Template: AAAWeekDay
      'Sun' => 'søn',
      'Mon' => 'man',
      'Tue' => 'tir',
      'Wed' => 'ons',
      'Thu' => 'tor',
      'Fri' => 'fre',
      'Sat' => 'lør',

      # Template: AdminAttachmentForm
      'Attachment Management' => 'Vedleggsadministrering',

      # Template: AdminAutoResponseForm
      'Auto Response Management' => 'Autosvar-administrering',
      'Response' => 'Svar',
      'Auto Response From' => 'Autosvar-avsender',
      'Note' => 'Notis',
      'Useable options' => 'Gyldige valg',
      'to get the first 20 character of the subject' => 'gir de første 20 bokstavene av emnebeskrivelsen',
      'to get the first 5 lines of the email' => 'gir de første 5 linjene av e-posten',
      'to get the from line of the email' => 'gir avsenderlinjen i e-posten',
      'to get the realname of the sender (if given)' => 'gir avsenders fulle navn (hvis mulig)',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_Number&gt;, &lt;OTRS_TICKET_ID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',

      # Template: AdminCustomerUserForm
      'The message being composed has been closed.  Exiting.' => 'Det tilhørende redigeringsvinduet har blitt lukket.  Avslutter.',
      'This window must be called from compose window' => 'Denne funksjonen må kalles fra redigeringsvinduet',
      'Customer User Management' => 'Kunde-bruker',
      'Search for' => 'Søk etter',
      'Result' => 'Resultat',
      'Select Source (for add)' => 'Velg kilde (for å legge til)',
      'Source' => 'Kilde',
      'This values are read only.' => 'Disse verdiene kan ikke endres.',
      'This values are required.' => 'Disse verdiene må fylles ut.',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',

      # Template: AdminCustomerUserGroupChangeForm
      'Customer Users <-> Groups Management' => 'Kunde-bruker <-> Gruppe',
      'Change %s settings' => 'Endre %s-innstillinger',
      'Select the user:group permissions.' => 'Velg bruker:gruppe-rettigheter.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Hvis ingen punkter er valgt, er ingen rettigheter tildelt (saker i denne gruppen vil ikke være tilgjengelig for brukeren).',
      'Permission' => 'Rettigheter',
      'ro' => '',
      'Read only access to the ticket in this group/queue.' => 'Kun lese-tilgang til saker i denne gruppen/mappen.',
      'rw' => '',
      'Full read and write access to the tickets in this group/queue.' => 'Full lese- og skrive-tilgang til saker i denne gruppen/mappen.',

      # Template: AdminCustomerUserGroupForm

      # Template: AdminEmail
      'Message sent to' => 'Melding sendt til',
      'Recipents' => 'Mottager(e)',
      'Body' => 'Meldingstekst',
      'send' => 'Send',

      # Template: AdminGenericAgent
      'GenericAgent' => '',
      'Job-List' => '',
      'Last run' => '',
      'Run Now!' => '',
      'x' => '',
      'Save Job as?' => '',
      'Is Job Valid?' => '',
      'Is Job Valid' => '',
      'Schedule' => '',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fritekstsøk i artikler (f.eks. "Mar*in" eller "Baue*")',
      '(e. g. 10*5155 or 105658*)' => 'f.eks. 10*5144 eller 105658*',
      '(e. g. 234321)' => 'f.eks. 234321',
      'Customer User Login' => 'Kunde-bruker login-navn',
      '(e. g. U5150)' => 'f.eks. U5150',
      'Agent' => '',
      'TicketFreeText' => 'Stikkordssøk',
      'Ticket Lock' => '',
      'Times' => 'Tider',
      'No time settings.' => 'Ingen tidsinnstillinger.',
      'Ticket created' => 'Sak opprettet',
      'Ticket created between' => 'Sak opprettet mellom',
      'New Priority' => 'Ny prioritet',
      'New Queue' => 'Ny mappe',
      'New State' => '',
      'New Agent' => '',
      'New Owner' => 'Ny saksbehandler',
      'New Customer' => 'Ny kunde',
      'New Ticket Lock' => '',
      'CustomerUser' => 'Kunde-bruker',
      'Add Note' => 'Legg til notis',
      'CMD' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Delete tickets' => '',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',
      'Modules' => '',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',

      # Template: AdminGroupForm
      'Group Management' => 'Grupper',
      'The admin group is to get in the admin area and the stats group to get stats area.' => '\'admin\'-gruppen gir tilgang til Admin-området, \'stats\'-gruppen til Statistikk-området.',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Opprett nye grupper for å kunne håndtere forskjellige rettigheter for forskjellige grupper agenter (f.eks. innkjøpsavdeling, supportavdeling, salgsavdeling, ...).',
      'It\'s useful for ASP solutions.' => 'Nyttig for ASP-løsninger.',

      # Template: AdminLog
      'System Log' => 'Systemlogg',
      'Time' => '',

      # Template: AdminNavigationBar
      'Users' => '',
      'Groups' => 'Grupper',
      'Misc' => 'Diverse',

      # Template: AdminNotificationForm
      'Notification Management' => 'Meldingsadministrasjon',
      'Notification' => '',
      'Notifications are sent to an agent or a customer.' => 'Meldinger sendes til agenter eller kunder.',
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Konfigurasjonsvalg (f.eks. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'gir tilgang til data for agenten som står som eier av saken (f.eks. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'gir tilgang til data for agenten som utfører handlingen (f.eks. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'gir tilgang til data for gjeldende kunde (f.eks. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',

      # Template: AdminPackageManager
      'Package Manager' => '',
      'Uninstall' => '',
      'Verion' => '',
      'Do you really want to uninstall this package?' => '',
      'Install' => '',
      'Package' => '',
      'Online Repository' => '',
      'Version' => '',
      'Vendor' => '',
      'Upgrade' => '',
      'Local Repository' => '',
      'Status' => '',
      'Overview' => 'Oversikt',
      'Download' => '',
      'Rebuild' => '',
      'Reinstall' => '',

      # Template: AdminPGPForm
      'PGP Management' => '',
      'Identifier' => '',
      'Bit' => '',
      'Key' => 'Nøkkel',
      'Fingerprint' => '',
      'Expires' => '',
      'In this way you can directly edit the keyring configured in SysConfig.' => '',

      # Template: AdminPOP3Form
      'POP3 Account Management' => 'Administrasjon POP3-Konto',
      'Host' => 'Maskin',
      'Trusted' => 'Betrodd',
      'Dispatching' => 'Fordeling',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Innkommende e-poster fra POP3-kontoer blir sortert til valgt mappe!',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',

      # Template: AdminPostMasterFilter
      'PostMaster Filter Management' => '',
      'Filtername' => 'Filternavn',
      'Match' => 'Treff',
      'Header' => 'Overskrift',
      'Value' => 'Innhold',
      'Set' => 'Sett',
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',

      # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Responses Management' => 'Administrasjon Mappe <-> Autosvar',

      # Template: AdminQueueAutoResponseTable

      # Template: AdminQueueForm
      'Queue Management' => 'Administrasjon av mapper',
      'Sub-Queue of' => 'Undermappe av',
      'Unlock timeout' => 'Tidsintervall for å sette sak tilgjengelig for andre',
      '0 = no unlock' => '0 = ikke gjør saker tilgjengelig',
      'Escalation time' => 'Eskalasjonstid',
      '0 = no escalation' => '0 = ingen eskalering',
      'Follow up Option' => 'Korrespondanse på avsluttet sak',
      'Ticket lock after a follow up' => 'Saken settes som privat etter oppfølgnings e-post',
      'Systemaddress' => 'Systemadresse',
      'Customer Move Notify' => 'Kundenotifikasjon ved flytting',
      'Customer State Notify' => 'Kundenotifikasjon ved statusendring',
      'Customer Owner Notify' => 'Kundenotifikasjon ved skifte av saksbehandler',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Hvis en sak er satt som privat, men likevel ikke blir besvart innen denne tiden, vil saken bli gjort tilgjengelig for andre.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Hvis en sak ikke blir besvart innen denne tiden, blir kun denne saken vist.',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Hvis en kunde sender oppfølgings e-post på en avsluttet sak, blir saken låst til forrige saksbehandler.',
      'Will be the sender address of this queue for email answers.' => 'Avsenderadresse for e-post i denne mappen.',
      'The salutation for email answers.' => 'Hilsning for e-postsvar.',
      'The signature for email answers.' => 'Signatur for e-postsvar.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS sender en merknad til kunden dersom saken flyttes.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS sender en merknad til kunden ved statusoppdatering.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS sender en merknad til kunden ved skifte av saksbehandler.',

      # Template: AdminQueueResponsesChangeForm
      'Responses <-> Queue Management' => 'Administrasjon av Ferdigsvar <-> Mapper',

      # Template: AdminQueueResponsesForm
      'Answer' => 'Ferdigsvar',

      # Template: AdminResponseAttachmentChangeForm
      'Responses <-> Attachments Management' => 'Administrasjon av Ferdigsvar <-> Vedlegg',

      # Template: AdminResponseAttachmentForm

      # Template: AdminResponseForm
      'Response Management' => 'Administrer Ferdigsvar',
      'A response is default text to write faster answer (with default text) to customers.' => 'Et ferdigsvar er en forhåndsdefinert tekst for å lette skriving av svar på vanlige henvendelser.',
      'Don\'t forget to add a new response a queue!' => 'Husk å tilordne nye ferdigsvar til en mappe!',
      'Next state' => 'Neste status',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'The current ticket state is' => 'Nåværende statuspå sak',
      'Your email address is new' => '',

      # Template: AdminRoleForm
      'Role Management' => '',
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',

      # Template: AdminRoleGroupChangeForm
      'Roles <-> Groups Management' => '',
      'move_into' => 'Flytt til',
      'Permissions to move tickets into this group/queue.' => 'Rett til å flytte saker i denne gruppen/mappen.',
      'create' => 'Opprett',
      'Permissions to create tickets in this group/queue.' => 'Rett til å opprette saker i denne gruppen/mappen.',
      'owner' => 'Eier',
      'Permissions to change the ticket owner in this group/queue.' => 'Rett til å endre saksbehandler i denne gruppen/mappen.',
      'priority' => 'prioritet',
      'Permissions to change the ticket priority in this group/queue.' => 'Rett til å endre prioritet i denne gruppen/mappen.',

      # Template: AdminRoleGroupForm
      'Role' => '',

      # Template: AdminRoleUserChangeForm
      'Roles <-> Users Management' => '',
      'Active' => '',
      'Select the role:user relations.' => '',

      # Template: AdminRoleUserForm

      # Template: AdminSalutationForm
      'Salutation Management' => 'Administrer Hilsninger',
      'customer realname' => 'Fullt kundenavn',
      'for agent firstname' => 'gir agents fornavn',
      'for agent lastname' => 'gir agents etternavn',
      'for agent user id' => 'gir agents bruker-id',
      'for agent login' => 'gir agents login',

      # Template: AdminSelectBoxForm
      'Select Box' => 'SQL-tilgang',
      'SQL' => '',
      'Limit' => '',
      'Select Box Result' => 'Select Box Ergebnis',

      # Template: AdminSession
      'Session Management' => 'Sesjonshåndtering',
      'Sessions' => 'Sesjoner',
      'Uniq' => '',
      'kill all sessions' => 'Terminer alle sesjoner',
      'Session' => '',
      'kill session' => 'Terminer sesjon',

      # Template: AdminSignatureForm
      'Signature Management' => 'Administrasjon Signaturer',

      # Template: AdminSMIMEForm
      'SMIME Management' => '',
      'Add Certificate' => '',
      'Add Private Key' => '',
      'Secret' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',

      # Template: AdminStateForm
      'System State Management' => 'Administrer Status',
      'State Type' => 'Status-type',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Forsikre deg om at du også har oppdatert standard tilstander i Kernel/Config.pm!',
      'See also' => 'Se også',

      # Template: AdminSysConfig
      'SysConfig' => '',
      'Group selection' => '',
      'Show' => '',
      'Download Settings' => '',
      'Download all system config changes.' => '',
      'Load Settings' => '',
      'Subgroup' => '',
      'Elements' => '',

      # Template: AdminSysConfigEdit
      'Config Options' => '',
      'Default' => '',
      'Content' => '',
      'New' => 'Ny',
      'New Group' => '',
      'Group Ro' => '',
      'New Group Ro' => '',
      'NavBarName' => '',
      'Image' => '',
      'Prio' => '',
      'Block' => '',
      'NavBar' => '',
      'AccessKey' => '',

      # Template: AdminSystemAddressForm
      'System Email Addresses Management' => 'Administrer System e-postadresser',
      'Email' => 'E-post',
      'Realname' => 'Fullt navn',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle innkommende e-poster til denne addressen (To:) vil bli fordelt til valgt mappe.',

      # Template: AdminUserForm
      'User Management' => 'Administrasjon Brukere',
      'Firstname' => 'Fornavn',
      'Lastname' => 'Etternavn',
      'User will be needed to handle tickets.' => 'Brukere er nødvendig for å jobbe med saker.',
      'Don\'t forget to add a new user to groups and/or roles!' => '',

      # Template: AdminUserGroupChangeForm
      'Users <-> Groups Management' => 'Administrer Bruker <-> Gruppe',

      # Template: AdminUserGroupForm

      # Template: AgentBook
      'Address Book' => 'Adressebok',
      'Return to the compose screen' => 'Lukk vindu',
      'Discard all changes and return to the compose screen' => 'Forkast endringer og lukk vindu',

      # Template: AgentCalendarSmall

      # Template: AgentCalendarSmallIcon

      # Template: AgentCustomerTableView

      # Template: AgentInfo
      'Info' => '',

      # Template: AgentLinkObject
      'Link Object' => '',
      'Select' => 'Velg',
      'Results' => 'Resultat',
      'Total hits' => 'Totalt funnet',
      'Site' => 'side',
      'Detail' => '',

      # Template: AgentLookup
      'Lookup' => '',

      # Template: AgentNavigationBar
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

      # Template: AgentPreferencesForm

      # Template: AgentSpelling
      'Spell Checker' => 'Stavekontroll',
      'spelling error(s)' => 'Stavefeil',
      'or' => 'eller',
      'Apply these changes' => 'Iverksett endringer',

      # Template: AgentTicketBounce
      'A message should have a To: recipient!' => 'En melding må ha en mottager i Til:-feltet!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'I Til-feltet må det oppgis en gyldig email-adresse (f.eks. kunde@eksempeldomene.no)!',
      'Bounce ticket' => 'Oversend sak',
      'Bounce to' => 'Oversend til',
      'Next ticket state' => 'Neste status på sak',
      'Inform sender' => 'Informer avsender',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'E-posten med saksnummer "<OTRS_TICKET>" er oversendt "<OTRS_BOUNCE_TO>". Vennligst ta kontakt på denne adressen for videre henvendelser.',
      'Send mail!' => 'Send e-posten!',

      # Template: AgentTicketBulk
      'A message should have a subject!' => 'En melding må ha en emnebeskrivelse!',
      'Ticket Bulk Action' => '',
      'Spell Check' => 'Stavekontroll',
      'Note type' => 'Notistype',
      'Unlock Tickets' => '',

      # Template: AgentTicketClose
      'A message should have a body!' => 'En melding må inneholde en meldingstekst!',
      'You need to account time!' => 'Du har ikke ført tidsregnskap!',
      'Close ticket' => 'Avslutt sak',
      'Note Text' => 'Notistekst',
      'Close type' => 'Lukketilstand',
      'Time units' => 'Tidsenheter',
      ' (work units)' => ' (arbeidsenheter)',

      # Template: AgentTicketCompose
      'A message must be spell checked!' => 'Stavekontroll må utføres på alle meldinger!',
      'Compose answer for ticket' => 'Forfatt svar til sak',
      'Attach' => 'Legg ved',
      'Pending Date' => 'Utsatt til',
      'for pending* states' => 'for vente-tilstander',

      # Template: AgentTicketCustomer
      'Change customer of ticket' => 'Endre kunde for sak',
      'Set customer user and customer id of a ticket' => 'Sett kunde-bruker og kunde-id for sak',
      'Customer User' => 'Kunde-bruker',
      'Search Customer' => 'Kundesøk',
      'Customer Data' => 'Kundedata',
      'Customer history' => 'Kunde-historikk',
      'All customer tickets.' => 'Alle saker for kunde.',

      # Template: AgentTicketCustomerMessage
      'Follow up' => 'Oppfølging',

      # Template: AgentTicketEmail
      'Compose Email' => 'Skriv e-post',
      'new ticket' => 'Ny sak',
      'Clear To' => 'Visk ut "Til"',
      'All Agents' => 'Alle agenter',
      'Termin1' => '',

      # Template: AgentTicketForward
      'Article type' => 'Artikkeltype',

      # Template: AgentTicketFreeText
      'Change free text of ticket' => 'Endre stikkord til sak',

      # Template: AgentTicketHistory
      'History of' => 'Historikk for',

      # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket låst',
      'Ticket unlock!' => 'Ticket frigi',

      # Template: AgentTicketMailbox
      'Mailbox' => 'Mine private saker',
      'Tickets' => 'Saker',
      'All messages' => 'Alle meldinger',
      'New messages' => 'Ny melding',
      'Pending messages' => 'Ventende meldinger',
      'Reminder messages' => 'Påminnelses-meldinger',
      'Reminder' => 'Påminnelse',
      'Sort by' => 'Sorter etter',
      'Order' => 'Sortering',
      'up' => 'stigende',
      'down' => 'synkende',

      # Template: AgentTicketMerge
      'You need to use a ticket number!' => '',
      'Ticket Merge' => '',
      'Merge to' => '',
      'Your email with ticket number "<OTRS_TICKET>" is merged to "<OTRS_MERGE_TO_TICKET>".' => '',

      # Template: AgentTicketMove
      'Queue ID' => 'Mappe-ID',
      'Move Ticket' => 'Flytt sak',
      'Previous Owner' => 'Forrige saksbehandler',

      # Template: AgentTicketNote
      'Add note to ticket' => 'Legg til notis ved sak',
      'Inform Agent' => '',
      'Optional' => '',
      'Inform involved Agents' => '',

      # Template: AgentTicketOwner
      'Change owner of ticket' => 'Endre saksbehandler av sak',
      'Message for new Owner' => 'Melding for ny saksbehandler',

      # Template: AgentTicketPending
      'Set Pending' => 'Sett på vent',
      'Pending type' => 'Venter på',
      'Pending date' => 'Sett på vent til',

      # Template: AgentTicketPhone
      'Phone call' => 'Telefonanrop',

      # Template: AgentTicketPhoneNew
      'Clear From' => 'Blank ut "Fra":',

      # Template: AgentTicketPlain
      'Plain' => 'Enkel',
      'TicketID' => 'Sak-ID',
      'ArticleID' => '',

      # Template: AgentTicketPrint
      'Ticket-Info' => '',
      'Accounted time' => 'Benyttet tid',
      'Escalation in' => 'Eskalering om',
      'Linked-Object' => '',
      'Parent-Object' => '',
      'Child-Object' => '',
      'by' => 'av',

      # Template: AgentTicketPriority
      'Change priority of ticket' => 'Endre prioritet for sak',

      # Template: AgentTicketQueue
      'Tickets shown' => 'Saker vist',
      'Page' => 'Side',
      'Tickets available' => 'Tilgjengelige saker',
      'All tickets' => 'Alle saker',
      'Queues' => 'Mapper',
      'Ticket escalation!' => 'Sak-eskalering!',

      # Template: AgentTicketQueueTicketView
      'Your own Ticket' => 'Din egen sak',
      'Compose Follow up' => 'Skriv oppfølgingssvar',
      'Compose Answer' => 'Skriv svar',
      'Contact customer' => 'Kontakt kunde',
      'Change queue' => 'Endre mappe',

      # Template: AgentTicketQueueTicketViewLite

      # Template: AgentTicketSearch
      'Ticket Search' => 'Søk etter sak',
      'Profile' => 'Profil',
      'Search-Template' => 'Søkemal',
      'Created in Queue' => '',
      'Result Form' => 'Resultatbilde',
      'Save Search-Profile as Template?' => 'Lagre søkekriterier som mal?',
      'Yes, save it with name' => 'Ja, lagre med navn',
      'Customer history search' => 'Historikk for kunde',
      'Customer history search (e. g. "ID342425").' => 'Søk etter kunde for historikk (f.eks. "ID342425").',
      'No * possible!' => 'Jokertegn ikke tillatt!',

      # Template: AgentTicketSearchResult
      'Search Result' => 'Søkeresultat',
      'Change search options' => 'Endre søke-innstillinger',

      # Template: AgentTicketSearchResultPrint
      '"}' => '',

      # Template: AgentTicketSearchResultShort
      'sort upward' => 'Sorter stigende',
      'U' => 'O',
      'sort downward' => 'Sorter synkende',
      'D' => 'N',

      # Template: AgentTicketStatusView
      'Ticket Status View' => '',
      'Open Tickets' => 'Åpne saker',

      # Template: AgentTicketZoom
      'Split' => 'Splitt',

      # Template: AgentTicketZoomStatus
      'Locked' => 'Tilgjenglighet',

      # Template: AgentWindowTabStart

      # Template: AgentWindowTabStop

      # Template: Copyright

      # Template: css

      # Template: customer-css

      # Template: CustomerAccept

      # Template: CustomerCalendarSmallIcon

      # Template: CustomerError
      'Traceback' => '',

      # Template: CustomerFAQ
      'Print' => 'Skriv ut',
      'Keywords' => 'Nøkkelord',
      'Symptom' => '',
      'Problem' => '',
      'Solution' => 'Løsning',
      'Modified' => 'Endret',
      'Last update' => 'Sist endret',
      'FAQ System History' => 'FAQ System Historie',
      'modified' => 'endret',
      'FAQ Search' => 'FAQ Søk',
      'Fulltext' => 'Fritekst',
      'Keyword' => 'Nøkkelord',
      'FAQ Search Result' => 'FAQ Søkeresultat',
      'FAQ Overview' => 'FAQ Oversikt',

      # Template: CustomerFooter
      'Powered by' => '',

      # Template: CustomerFooterSmall

      # Template: CustomerHeader

      # Template: CustomerHeaderSmall

      # Template: CustomerLogin
      'Login' => '',
      'Lost your password?' => 'Mistet passord?',
      'Request new password' => 'Be om nytt passord',
      'Create Account' => 'Opprett konto',

      # Template: CustomerNavigationBar
      'Welcome %s' => 'Velkommen %s',

      # Template: CustomerPreferencesForm

      # Template: CustomerStatusView
      'of' => 'av',

      # Template: CustomerTicketMessage

      # Template: CustomerTicketMessageNew

      # Template: CustomerTicketSearch

      # Template: CustomerTicketSearchResultCSV

      # Template: CustomerTicketSearchResultPrint

      # Template: CustomerTicketSearchResultShort

      # Template: CustomerTicketZoom

      # Template: CustomerWarning

      # Template: Error
      'Click here to report a bug!' => 'Klikk her for å rapportere en feil!',

      # Template: FAQ
      'Comment (internal)' => 'Kommentar (intern)',
      'A article should have a title!' => '',
      'New FAQ Article' => '',
      'Do you really want to delete this Object?' => '',
      'System History' => '',

      # Template: FAQCategoryForm
      'Name is required!' => '',
      'FAQ Category' => 'FAQ Kategori',

      # Template: FAQLanguageForm
      'FAQ Language' => 'FAQ Språk',

      # Template: Footer
      'QueueView' => 'Mapper',
      'PhoneView' => 'Henvendelser',
      'Top of Page' => 'Toppen av siden',

      # Template: FooterSmall

      # Template: Header
      'Home' => 'Hjem',

      # Template: HeaderSmall

      # Template: Installer
      'Web-Installer' => 'Web-installasjon',
      'accept license' => 'aksepter lisens',
      'don\'t accept license' => 'ikke aksepter lisens',
      'Admin-User' => 'Admin-bruker',
      'Admin-Password' => '',
      'your MySQL DB should have a root password! Default is empty!' => 'Din MySQL-database bør ha et root-passord satt!  Default er intet passord!',
      'Database-User' => '',
      'default \'hot\'' => '',
      'DB connect host' => '',
      'Database' => '',
      'Create' => '',
      'false' => '',
      'SystemID' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Unik id for dette systemet.  Alle saksnummer og http-sesjonsid-er starter med denne id-en)',
      'System FQDN' => '',
      '(Full qualified domain name of your system)' => '(Fullkvalifisert dns-navn for ditt system)',
      'AdminEmail' => 'Admin e-post',
      '(Email of the system admin)' => '(E-post til systemadmin)',
      'Organization' => 'Organisasjon',
      'Log' => '',
      'LogModule' => '',
      '(Used log backend)' => '(Valgt logge-backend)',
      'Logfile' => 'Logfil',
      '(Logfile just needed for File-LogModule!)' => '(Logfile kun påkrevet for File-LogModule!)',
      'Webfrontend' => 'Web-grensesnitt',
      'Default Charset' => 'Standardtegnsett',
      'Use utf-8 it your database supports it!' => 'Bruk utf-8 dersom din database støtter det!',
      'Default Language' => 'Standardspråk',
      '(Used default language)' => '(Valgt standardspråk)',
      'CheckMXRecord' => '',
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Sjekker mx-innslag for oppgitte e-postadresser i meldinger som skrives.  Bruk ikke CheckMXRecord om din OTRS-maskin er bak en oppringt-linje!)',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'For å kunne bruke OTRS, må følgende linje utføres på kommandolinjen som root.',
      'Restart your webserver' => 'Restart webserveren din',
      'After doing so your OTRS is up and running.' => 'Etter dette vil OTRS være oppe og kjøre.',
      'Start page' => 'Startside',
      'Have a lot of fun!' => 'Ha det gøy!',
      'Your OTRS Team' => 'Ditt OTRS-Team',

      # Template: Login

      # Template: Motd

      # Template: NoPermission
      'No Permission' => 'Ingen tilgang',

      # Template: Notify
      'Important' => 'Viktig',

      # Template: PrintFooter
      'URL' => '',

      # Template: PrintHeader
      'printed by' => 'skrevet av',

      # Template: Redirect

      # Template: SystemStats
      'Format' => '',

      # Template: Test
      'OTRS Test Page' => 'OTRS Test-side',
      'Counter' => 'Teller',

      # Template: Warning
      # Misc
      'Create Database' => 'Opprett database',
      'DB Host' => 'DB maskin',
      'Ticket Number Generator' => 'Saksnummer-generator',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Sakskjennetegn, f.eks. \'Ticket#\', \'Call#\' eller \'MyTicket#\')',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Close!' => 'Lukk!',
      'Don\'t forget to add a new user to groups!' => 'Ikke glem å gi nye brukere en gruppe!',
      'License' => 'Lisens',
      'CreateTicket' => 'Opprettet sak',
      'OTRS DB Name' => 'OTRS DB navn',
      'System Settings' => 'Systeminnstillinger',
      'Finished' => 'Ferdig',
      'DB Admin User' => 'DB administratorbruker',
      'Options of the ticket data (e. g. &lt;OTRS_TICKET_TicketNumber&gt;, &lt;OTRS_TICKET_TicketID&gt;, &lt;OTRS_TICKET_Queue&gt;, &lt;OTRS_TICKET_State&gt;)' => '',
      'Change user <-> group settings' => 'Endre bruker <-> gruppe-instillinger',
      'DB Type' => 'DB type',
      'next step' => 'neste steg',
      'Admin-Email' => 'Admin e-post',
      'Create new database' => 'Opprett ny database',
      'Delete old database' => 'Slett gammel database',
      'OTRS DB User' => 'OTRS DB bruker',
      'OTRS DB Password' => 'OTRS DB passord',
      'DB Admin Password' => 'DB administratorpassord',
      'Drop Database' => 'Slett database',
      '(Used ticket number format)' => '(Valgt format for saksnummer)',
    };
    # $$STOP$$
}
# --
1;
