# -- 
# Kernel/Language/nb_NO.pm - Norwegian language translation (bokmål)
# Copyright (C) 2004 Arne Georg Gleditsch <argggh@linpro.no>
# --
# $Id: nb_NO.pm,v 1.7 2005-02-23 10:04:21 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::nb_NO;

use strict;

use vars qw($VERSION);
$VERSION = q$Revision: 1.7 $;
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Aug 24 10:09:45 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M %Y %T';
    $Self->{DateFormatLong} = '%A %D. %B %Y %T';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minutter',
      ' 5 minutes' => ' 5 minutter',
      ' 7 minutes' => ' 7 minutter',
      '(Click here to add)' => '(Klikk her for å legge til)',
      '...Back' => '',
      '10 minutes' => '10 minutter',
      '15 minutes' => '15 minutter',
      'Added User "%s"' => '',
      'AddLink' => 'Legg til link',
      'Admin-Area' => 'Admin-område',
      'agent' => 'agent',
      'Agent-Area' => 'Agent-område',
      'all' => 'alle',
      'All' => 'Alle',
      'Attention' => 'OBS',
      'Back' => 'Tilbake',
      'before' => 'før',
      'Bug Report' => 'Rapporter feil',
      'Calendar' => '',
      'Cancel' => 'Avbryt',
      'change' => 'endre',
      'Change' => 'Endre',
      'change!' => 'endre!',
      'click here' => 'klikk her',
      'Comment' => 'Kommentar',
      'Contract' => '',
      'Crypt' => '',
      'Crypted' => '',
      'Customer' => 'Kunde',
      'customer' => 'kunde',
      'Customer Info' => 'Kunde-info',
      'day' => 'dag',
      'day(s)' => 'dag(er)',
      'days' => 'dager',
      'description' => 'beskrivelse',
      'Description' => 'Beskrivelse',
      'Directory' => '',
      'Dispatching by email To: field.' => 'Utsending etter oppføringer i To:-felt.',
      'Dispatching by selected Queue.' => 'Utsending etter valgt kø.',
      'Don\'t show closed Tickets' => 'Ikke vis lukkede ticketer',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Det er ikke anbefalt å arbeide som userid 1 (systemkonto)! Opprett heller nye brukere!',
      'Done' => 'Ferdig',
      'end' => 'slutt',
      'Error' => 'Feil',
      'Example' => 'Eksempel',
      'Examples' => 'Eksempler',
      'Facility' => 'Innretning',
      'FAQ-Area' => 'FAQ-område',
      'Feature not active!' => 'Funksjon ikke aktivert!',
      'go' => 'Start',
      'go!' => 'Start!',
      'Group' => 'Gruppe',
      'History::AddNote' => 'Added note (%s)',
      'History::Bounce' => 'Bounced to "%s".',
      'History::CustomerUpdate' => 'Updated: %s',
      'History::EmailAgent' => 'Email sent to customer.',
      'History::EmailCustomer' => 'Added email. %s',
      'History::FollowUp' => 'FollowUp for [%s]. %s',
      'History::Forward' => 'Forwarded to "%s".',
      'History::Lock' => 'Locked ticket.',
      'History::LoopProtection' => 'Loop-Protection! No auto-response sent to "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Ticket moved into Queue "%s" (%s) from Queue "%s" (%s).',
      'History::NewTicket' => 'New Ticket [%s] created (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'New owner is "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'Agent called customer.',
      'History::PhoneCallCustomer' => 'Customer called us.',
      'History::PriorityUpdate' => 'Changed priority from "%s" (%s) to "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notification sent to "%s".',
      'History::SendAnswer' => 'Email sent to "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp sent to "%s".',
      'History::SendAutoReject' => 'AutoReject sent to "%s".',
      'History::SendAutoReply' => 'AutoReply sent to "%s".',
      'History::SendCustomerNotification' => 'Notification sent to "%s".',
      'History::SetPendingTime' => 'Updated: %s',
      'History::StateUpdate' => 'Old: "%s" New: "%s"',
      'History::TicketFreeTextUpdate' => 'Updated: %s=%s;%s=%s;',
      'History::TicketLinkAdd' => 'Added link to ticket "%s".',
      'History::TicketLinkDelete' => 'Deleted link to ticket "%s".',
      'History::TimeAccounting' => '%s time unit(s) accounted. Now total %s time unit(s).',
      'History::Unlock' => 'Unlocked ticket.',
      'History::WebRequestCustomer' => 'Customer request via web.',
      'History::SystemRequest' => 'System Request (%s).',
      'Hit' => 'Treff',
      'Hits' => 'Treff',
      'hour' => 'time',
      'hours' => 'timer',
      'Ignore' => 'Ignorere',
      'invalid' => 'ugyldig',
      'Invalid SessionID!' => 'Ugydlig SessionID!',
      'Language' => 'Språk',
      'Languages' => 'Språk',
      'last' => 'siste',
      'Line' => 'Linje',
      'Lite' => 'Enkel',
      'Login failed! Your username or password was entered incorrectly.' => 'Innlogging feilet! Oppgitt brukernavn og/eller passord er ikke korrekt.',
      'Logout successful. Thank you for using OTRS!' => 'Utlogging utført.  Takk for at du brukte OTRS!',
      'Message' => 'Melding',
      'minute' => 'minutt',
      'minutes' => 'minutter',
      'Module' => 'Modul',
      'Modulefile' => 'Modulfil',
      'month(s)' => 'måned(er)',
      'Name' => 'Navn',
      'New Article' => 'Ny artikkel',
      'New message' => 'Ny melding',
      'New message!' => 'Ny melding!',
      'Next' => '',
      'Next...' => '',
      'No' => 'Nei',
      'no' => 'ingen',
      'No entry found!' => 'Ingen innslag funnet!',
      'No Permission!' => '',
      'No such Ticket Number "%s"! Can\'t link it!' => '',
      'No suggestions' => 'Ingen forslag',
      'none' => 'ingen',
      'none - answered' => 'ingen - besvart',
      'none!' => 'ingen!',
      'Normal' => 'Normal',
      'off' => 'av',
      'Off' => 'Av',
      'On' => 'På',
      'on' => 'på',
      'Online Agent: %s' => '',
      'Online Customer: %s' => '',
      'Password' => 'Passord',
      'Passwords dosn\'t match! Please try it again!' => '',
      'Pending till' => 'Utsatt til',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Vennligst besvar denne/disse ticketene for å komme tilbake til det normale kø-visningsbildet!',
      'Please contact your admin' => 'Vennligst ta kontakt med administrator',
      'please do not edit!' => 'Vennligst ikke endre!',
      'possible' => 'Gjenåpner',
      'Preview' => 'Forhåndsvisning',
      'QueueView' => 'Køer',
      'reject' => 'Avvises',
      'replace with' => 'Erstatt med',
      'Reset' => 'Nullstill',
      'Salutation' => 'Hilsning',
      'Session has timed out. Please log in again.' => 'Sesjonen har gått ut på tid.  Vennligst logg på igjen.',
      'Show closed Tickets' => 'Vis lukkede ticketer',
      'Sign' => '',
      'Signature' => 'Signatur',
      'Signed' => '',
      'Size' => '',
      'Sorry' => 'Beklager',
      'Stats' => 'Statistikk',
      'Subfunction' => 'Underfunksjon',
      'submit' => 'Send',
      'submit!' => 'Send!',
      'system' => 'System',
      'Take this Customer' => '',
      'Take this User' => 'Velg denne brukeren',
      'Text' => 'Tekst',
      'The recommended charset for your language is %s!' => 'Anbefalt tegnsett for ditt språk er %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Finner ingen konto med det navnet.',
      'Ticket Number' => '',
      'Timeover' => 'Tidsoverskridelse',
      'To: (%s) replaced with database email!' => 'Til: (%s) erstattet med mail fra database!',
      'top' => 'topp',
      'Type' => 'Type',
      'update' => 'oppdater',
      'Update' => 'Oppdater',
      'update!' => 'Oppdater!',
      'Upload' => '',
      'User' => 'Bruker',
      'Username' => 'Brukernavn',
      'Valid' => 'Gyldig',
      'Warning' => 'Advarsel',
      'week(s)' => 'uke(r)',
      'Welcome to OTRS' => 'Velkommen til OTRS',
      'Word' => 'Ord',
      'wrote' => 'skrev',
      'year(s)' => 'år',
      'Yes' => 'Ja',
      'yes' => 'ja',
      'You got new message!' => 'Du har en ny melding!',
      'You have %s new message(s)!' => 'Du har %s ny(e) melding(er)!',
      'You have %s reminder ticket(s)!' => 'Du har %s påminnelses-ticket(er)!',

    # Template: AAAMonth
      'Apr' => 'apr',
      'Aug' => 'aug',
      'Dec' => 'des',
      'Feb' => 'feb',
      'Jan' => 'jan',
      'Jul' => 'jul',
      'Jun' => 'jun',
      'Mar' => 'mar',
      'May' => 'mai',
      'Nov' => 'nov',
      'Oct' => 'okt',
      'Sep' => 'sep',

    # Template: AAAPreferences
      'Closed Tickets' => 'Lukkede ticketer',
      'CreateTicket' => 'Opprettet Ticket',
      'Custom Queue' => 'Utvalgte køer',
      'Follow up notification' => 'Oppfølgingsmerknad',
      'Frontend' => 'Grensesnitt',
      'Mail Management' => 'Mail-administrasjon',
      'Max. shown Tickets a page in Overview.' => 'Max. viste ticketer per side i Overview.',
      'Max. shown Tickets a page in QueueView.' => 'Max. viste ticketer per side i Kø-bilde.',
      'Move notification' => 'Merknad ved kø-endring',
      'New ticket notification' => 'Merknad ved nyopprettet ticket',
      'Other Options' => 'Andre opsjoner',
      'PhoneView' => 'Henvendelser',
      'Preferences updated successfully!' => 'Innstillinger lagret!',
      'QueueView refresh time' => 'Automatisk oppdateringsfrekvens i kø-bilde',
      'Screen after new ticket' => 'Skjermbilde etter innlegging av ny ticket',
      'Select your default spelling dictionary.' => 'Velg standard ordbok for stavekontroll.',
      'Select your frontend Charset.' => 'Velg tegnsett.',
      'Select your frontend language.' => 'Velg språk.',
      'Select your frontend QueueView.' => 'Velg kø-bilde.',
      'Select your frontend Theme.' => 'Velg stil-tema.',
      'Select your QueueView refresh time.' => 'Velg automatisk oppdateringsfrekvens i kø-bilde.',
      'Select your screen after creating a new ticket.' => 'Velg skjermbilde som vises etter registrering av ny henvendelse/ticket.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Send meg en melding ved kundekorrespondanse på ticketer jeg står som eier av.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => '',
      'Send me a notification if a ticket is unlocked by the system.' => 'Send meg en melding dersom systemet fjerner en ticket-lås.',
      'Send me a notification if there is a new ticket in "My Queues".' => '',
      'Show closed tickets.' => 'Vis lukkede ticketer.',
      'Spelling Dictionary' => 'Ordbok for stavekontroll',
      'Ticket lock timeout notification' => 'Melding ved overskridelse av tidsfrist for ticket-lås',
      'TicketZoom' => 'Ticket Zoom',

    # Template: AAATicket
      '1 very low' => '1 svært lav',
      '2 low' => '2 lav',
      '3 normal' => '3 normal',
      '4 high' => '4 høy',
      '5 very high' => '5 svært høy',
      'Action' => 'Aksjon',
      'Age' => 'Alder',
      'Article' => 'Artikkel',
      'Attachment' => 'Vedlegg',
      'Attachments' => 'Vedlegg',
      'Bcc' => '',
      'Bounce' => '',
      'Cc' => '',
      'Close' => 'Lukk',
      'closed' => '',
      'closed successful' => 'løst og lukket',
      'closed unsuccessful' => 'uløst men lukket',
      'Compose' => 'Forfatt',
      'Created' => 'Opprettet',
      'Createtime' => 'Oprettet',
      'email' => 'email',
      'eMail' => 'email',
      'email-external' => 'email eksternt',
      'email-internal' => 'email internt',
      'Forward' => 'Videresende',
      'From' => 'Fra',
      'high' => 'høy',
      'History' => 'Historikk',
      'If it is not displayed correctly,' => 'Dersom den ikke vises korrekt,',
      'lock' => 'låst',
      'Lock' => 'Lås',
      'low' => 'lav',
      'Move' => 'Flytt',
      'new' => 'ny',
      'normal' => 'normal',
      'note-external' => 'notis eksternt',
      'note-internal' => 'notis internt',
      'note-report' => 'notis til rapport',
      'open' => 'åpen',
      'Owner' => 'Eier',
      'Pending' => 'Utsett',
      'pending auto close+' => 'venter på lukking (løst)',
      'pending auto close-' => 'venter på lukking (uløst)',
      'pending reminder' => 'venter på påminnelse',
      'phone' => 'telefon',
      'plain' => 'rå',
      'Priority' => 'Prioritet',
      'Queue' => 'Kø',
      'removed' => 'fjernet',
      'Sender' => 'Sender',
      'sms' => 'sms',
      'State' => 'Status',
      'Subject' => 'Emne',
      'This is a' => 'Dette er en',
      'This is a HTML email. Click here to show it.' => 'Dette er en HTML-email. Klikk her for å vise.',
      'This message was written in a character set other than your own.' => 'Denne meldinger er skrevet i et annet tegnsett enn du bruker.',
      'Ticket' => 'Ticket',
      'Ticket "%s" created!' => 'Ticket "%s" opprettet!',
      'To' => 'Til',
      'to open it in a new window.' => 'for å åpne i nytt vindu',
      'Unlock' => 'Frigi',
      'unlock' => 'ulåst',
      'very high' => 'svært høy',
      'very low' => 'svært lav',
      'View' => 'Bilde',
      'webrequest' => 'web-forespørsel',
      'Zoom' => 'Zoom',

    # Template: AAAWeekDay
      'Fri' => 'fre',
      'Mon' => 'man',
      'Sat' => 'lør',
      'Sun' => 'søn',
      'Thu' => 'tor',
      'Tue' => 'tir',
      'Wed' => 'ons',

    # Template: AdminAttachmentForm
      'Add' => 'Legg til',
      'Attachment Management' => 'Vedleggsadministrering',

    # Template: AdminAutoResponseForm
      'Auto Response From' => 'autosvar-avsender',
      'Auto Response Management' => 'Autosvar-administrering',
      'Note' => 'Notis',
      'Response' => 'Svar',
      'to get the first 20 character of the subject' => 'gir de første 20 bokstavene av emnebeskrivelsen',
      'to get the first 5 lines of the email' => 'gir de første 5 linjene av emailen',
      'to get the from line of the email' => 'gir avsenderlinjen i emailen',
      'to get the realname of the sender (if given)' => 'gir avsenders fulle navn (hvis mulig)',
      'to get the ticket id of the ticket' => 'gir intern ticket-id',
      'to get the ticket number of the ticket' => 'gir ticket-nummer',
      'Useable options' => 'Gyldige opsjoner',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Kunde-bruker',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => '',
      'Result' => '',
      'Search' => 'Søk',
      'Search for' => '',
      'Select Source (for add)' => '',
      'Source' => 'Kilde',
      'The message being composed has been closed.  Exiting.' => 'Det tilhørende redigeringsvinduet har blitt lukket.  Avslutter.',
      'This values are read only.' => '',
      'This values are required.' => '',
      'This window must be called from compose window' => 'Denne funksjonen må kalles fra redigeringsvinduet',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Endre %s-innstillinger',
      'Customer User <-> Group Management' => 'Kunde-bruker <-> Gruppe',
      'Full read and write access to the tickets in this group/queue.' => 'Full lese- og skrive-tilgang til ticketer i denne gruppen/køen.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Hvis ingen punkter er valgt, er ingen rettigheter tildelt (ticketer i denne gruppen vil ikke være tilgjengelig for brukeren).',
      'Permission' => 'Rettigheter',
      'Read only access to the ticket in this group/queue.' => 'Kun lese-tilgang til ticketer i denne gruppen/køen.',
      'ro' => 'ro',
      'rw' => 'rw',
      'Select the user:group permissions.' => 'Velg bruker:gruppe-rettigheter.',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Endre bruker <-> gruppe-instillinger',

    # Template: AdminEmail
      'Admin-Email' => 'Admin-email',
      'Body' => 'Meldingstekst',
      'OTRS-Admin Info!' => '',
      'Recipents' => 'Mottager',
      'send' => 'Send',

    # Template: AdminEmailSent
      'Message sent to' => 'Melding sendt til',

    # Template: AdminGenericAgent
      '(e. g. 10*5155 or 105658*)' => 'f.eks. 10*5144 eller 105658*',
      '(e. g. 234321)' => 'f.eks. 234321',
      '(e. g. U5150)' => 'f.eks. U5150',
      '-' => '',
      'Add Note' => 'Legg til notis',
      'Agent' => '',
      'and' => 'og',
      'CMD' => '',
      'Customer User Login' => 'Kunde-bruker login-navn',
      'CustomerID' => 'Organisasjons-ID',
      'CustomerUser' => 'Kunde-bruker',
      'Days' => '',
      'Delete' => 'Slett',
      'Delete tickets' => '',
      'Edit' => 'Rediger',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fritekstsøk i artikler (f.eks. "Mar*in" eller "Baue*")',
      'GenericAgent' => '',
      'Hours' => '',
      'Job-List' => '',
      'Jobs' => '',
      'Last run' => '',
      'Minutes' => '',
      'Modules' => '',
      'New Agent' => '',
      'New Customer' => '',
      'New Owner' => 'Ny eier',
      'New Priority' => '',
      'New Queue' => 'Ny kø',
      'New State' => '',
      'New Ticket Lock' => '',
      'No time settings.' => 'Ingen tidsinnstillinger.',
      'Param 1' => '',
      'Param 2' => '',
      'Param 3' => '',
      'Param 4' => '',
      'Param 5' => '',
      'Param 6' => '',
      'Save' => '',
      'Save Job as?' => '',
      'Schedule' => '',
      'This command will be executed. ARG[0] will be the ticket number. ARG[1] the ticket id.' => '',
      'Ticket created' => 'Ticket opprettet',
      'Ticket created between' => 'Ticket opprettet mellom',
      'Ticket Lock' => '',
      'TicketFreeText' => '',
      'Times' => 'Tider',
      'Warning! This tickets will be removed from the database! This tickets are lost!' => '',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Opprett nye grupper for å kunne håndtere forskjellige rettigheter for forskjellige grupper agenter (f.eks. innkjøpsavdeling, supportavdeling, salgsavdeling, ...).',
      'Group Management' => 'Grupper',
      'It\'s useful for ASP solutions.' => 'Nyttig for ASP-løsninger.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => '\'admin\'-gruppen gir tilgang til Admin-området, \'stats\'-gruppen til Statistikk-området.',

    # Template: AdminLog
      'System Log' => 'Systemlogg',
      'Time' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin-email',
      'Attachment <-> Response' => 'Vedlegg <-> Ferdigsvar',
      'Auto Response <-> Queue' => 'Autosvar <-> Køer',
      'Auto Responses' => 'Autosvar',
      'Customer User' => 'Kunde-bruker',
      'Customer User <-> Groups' => 'Kunde-bruker <-> Grupper',
      'Email Addresses' => 'Email-adresser',
      'Groups' => 'Grupper',
      'Logout' => 'Logg ut',
      'Misc' => 'Ymse',
      'Notifications' => 'Meldinger',
      'PGP Keys' => '',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => 'Postmaster POP3-konto',
      'Responses' => 'Ferdigsvar',
      'Responses <-> Queue' => 'Ferdigsvar <-> Køer',
      'Role' => '',
      'Role <-> Group' => '',
      'Role <-> User' => '',
      'Roles' => '',
      'Select Box' => 'SQL-tilgang',
      'Session Management' => 'Sesjonshåndtering',
      'SMIME Certificates' => '',
      'Status' => '',
      'System' => '',
      'User <-> Groups' => 'Bruker <-> Grupper',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Konfigurasjonsopsjoner (f.eks. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Meldingsadministrasjon',
      'Notifications are sent to an agent or a customer.' => 'Meldinger sendes til agenter eller kunder.',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'gir tilgang til data for gjeldende kunde (f.eks. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'gir tilgang til data for agenten som utfører handlingen (f.eks. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'gir tilgang til data for agenten som står som eier av ticketen (f.eks. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPGPForm
      'Bit' => '',
      'Expires' => '',
      'File' => '',
      'Fingerprint' => '',
      'FIXME: WHAT IS PGP?' => '',
      'Identifier' => '',
      'In this way you can directly edit the keyring configured in Kernel/Config.pm.' => '',
      'Key' => 'Nøkkel',
      'PGP Key Management' => '',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Innkommende email fra POP3-konter blir sortert til valgt kø!',
      'Dispatching' => 'Fordeling',
      'Host' => 'Maskin',
      'If your account is trusted, the already existing x-otrs header at arrival time (for priority, ...) will be used! PostMaster filter will be used anyway.' => '',
      'POP3 Account Management' => 'Administrasjon POP3-Konto',
      'Trusted' => 'Betrodd',

    # Template: AdminPostMasterFilter
      'Do dispatch or filter incoming emails based on email X-Headers! RegExp is also possible.' => '',
      'Filtername' => '',
      'Header' => '',
      'If you use RegExp, you also can use the matched value in () as [***] in \'Set\'.' => '',
      'Match' => 'Treff',
      'PostMaster Filter Management' => '',
      'Set' => 'Sett',
      'Value' => 'Innhold',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Administrasjon Kø <-> Autosvar',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = ingen eskalering',
      '0 = no unlock' => '0 = ikke fjern lås',
      'Customer Move Notify' => 'Kundenotifikasjon ved flytting',
      'Customer Owner Notify' => 'Kundenotifikasjon ved eierskifte',
      'Customer State Notify' => 'Kundenotifikasjon ved statusendring',
      'Escalation time' => 'Eskalasjonstid',
      'Follow up Option' => 'Korrespondanse på lukket ticket',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Hvis en kunde sender oppfølgingsmail på en lukket ticket, blir ticketen låst til forrige eier.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Hvis en ticket ikke blir besvart innen denne tiden, blir kun denne ticketen vist.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Hvis en ticket som er låst av en agent men likevel ikke blir besvart innen denne tiden, vil låsen automatisk fjernes.',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS sender en merknad til kunden dersom ticketen flyttes.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS sender en merknad til kunden ved eierskifte.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS sender en merknad til kuden ved statusoppdatering.',
      'Queue Management' => 'Administrasjon av køer',
      'Sub-Queue of' => 'Underkø av',
      'Systemaddress' => 'Systemadresse',
      'The salutation for email answers.' => 'Hilsning for email-svar.',
      'The signature for email answers.' => 'Signatur for email-svar.',
      'Ticket lock after a follow up' => 'Ticket låses etter oppfølgningsmail',
      'Unlock timeout' => 'Tidsintervall før fjerning av lås',
      'Will be the sender address of this queue for email answers.' => 'Avsenderadresse for email i denne køen.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Administrasjon av Ferdigsvar <-> Køer',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Ferdigsvar',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Administrasjon av Ferdigsvar <-> Vedlegg',

    # Template: AdminResponseAttachmentForm

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Et ferdigsvar er en forhåndsdefinert tekst for å lette skriving av svar på vanlige henvendelser.',
      'All Customer variables like defined in config option CustomerUser.' => '',
      'Don\'t forget to add a new response a queue!' => 'Husk å tilordne nye ferdigsvar til en kø!',
      'Next state' => 'Neste tilstand',
      'Response Management' => 'Administrer Ferdigsvar',
      'The current ticket state is' => 'Nåværende ticket-status',
      'Your email address is new' => '',

    # Template: AdminRoleForm
      'Create a role and put groups in it. Then add the role to the users.' => '',
      'It\'s useful for a lot of users and groups.' => '',
      'Role Management' => '',

    # Template: AdminRoleGroupChangeForm
      'create' => 'Opprett',
      'move_into' => 'Flytt til',
      'owner' => 'Eier',
      'Permissions to change the ticket owner in this group/queue.' => 'Rett til å endre eierskap i denne gruppen/køen.',
      'Permissions to change the ticket priority in this group/queue.' => 'Rett til å endre prioritet i denne gruppen/køen.',
      'Permissions to create tickets in this group/queue.' => 'Rett til å opprette ticketer i denne gruppen/køen.',
      'Permissions to move tickets into this group/queue.' => 'Rett til å flytte ticketer i denne gruppen/køen.',
      'priority' => 'prioritet',
      'Role <-> Group Management' => '',

    # Template: AdminRoleGroupForm
      'Change role <-> group settings' => '',

    # Template: AdminRoleUserChangeForm
      'Active' => '',
      'Role <-> User Management' => '',
      'Select the role:user relations.' => '',

    # Template: AdminRoleUserForm
      'Change user <-> role settings' => '',

    # Template: AdminSMIMEForm
      'Add Certificate' => '',
      'Add Private Key' => '',
      'FIXME: WHAT IS SMIME?' => '',
      'Hash' => '',
      'In this way you can directly edit the certification and private keys in file system.' => '',
      'Secret' => '',
      'SMIME Certificate Management' => '',

    # Template: AdminSalutationForm
      'customer realname' => 'Fullt kundenavn',
      'for agent firstname' => 'gir agents fornavn',
      'for agent lastname' => 'gir agents etternavn',
      'for agent login' => 'gir agents login',
      'for agent user id' => 'gir agents bruker-id',
      'Salutation Management' => 'Administrer Hilsninger',

    # Template: AdminSelectBoxForm
      'Limit' => '',
      'SQL' => '',

    # Template: AdminSelectBoxResult
      'Select Box Result' => 'Select Box Ergebnis',

    # Template: AdminSession
      'kill all sessions' => 'Terminer alle sesjoner',
      'kill session' => 'Terminer sesjon',
      'Overview' => 'Oversikt',
      'Session' => '',
      'Sessions' => 'Sesjoner',
      'Uniq' => '',

    # Template: AdminSignatureForm
      'Signature Management' => 'Administrasjon Signaturer',

    # Template: AdminStateForm
      'See also' => 'Se også',
      'State Type' => 'Status-type',
      'System State Management' => 'Administrer Status',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Forsikre deg om at du også har oppdatert standard tilstander i Kernel/Config.pm!',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle innkommende mail til denne addressat (To:) blir fordelt til valgt kø.',
      'Email' => 'Email',
      'Realname' => 'Fullt navn',
      'System Email Addresses Management' => 'Administrer System-email-adresser',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Ikke glem å gi nye brukere en gruppe!',
      'Firstname' => 'Fornavn',
      'Lastname' => 'Etternavn',
      'User Management' => 'Administrasjon Brukere',
      'User will be needed to handle tickets.' => 'Brukere er nødvendig for å jobbe med tickets.',

    # Template: AdminUserGroupChangeForm
      'User <-> Group Management' => 'Administrer Bruker <-> Gruppe',

    # Template: AdminUserGroupForm

    # Template: AgentBook
      'Address Book' => 'Adressebok',
      'Discard all changes and return to the compose screen' => 'Forkast endringer og lukk vindu',
      'Return to the compose screen' => 'Lukk vindu',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'En melding må ha en mottager i Til:-feltet!',
      'Bounce ticket' => 'Oversend ticket',
      'Bounce to' => 'Oversend til',
      'Inform sender' => 'Informer avsender',
      'Next ticket state' => 'Neste ticket-status',
      'Send mail!' => 'Send mail!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'I Til-feltet må det oppgis en gyldig email-adresse (f.eks. kunde@eksempeldomene.no)!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Emailen med ticketnummer "<OTRS_TICKET>" er oversendt "<OTRS_BOUNCE_TO>". Vennligst ta kontakt på denne adressen for videre henvendelser.',

    # Template: AgentBulk
      '$Text{"Note!' => '',
      'A message should have a subject!' => 'En melding må ha en emnebeskrivelse!',
      'Note type' => 'Notistype',
      'Note!' => 'Notis!',
      'Options' => 'Opsjoner',
      'Spell Check' => 'Stavekontroll',
      'Ticket Bulk Action' => '',

    # Template: AgentClose
      ' (work units)' => ' (arbeidsenheter)',
      'A message should have a body!' => 'En melding må inneholde en meldingstekst!',
      'Close ticket' => 'Lukk ticket',
      'Close type' => 'Lukketilstand',
      'Close!' => 'Lukk!',
      'Note Text' => 'Notistekst',
      'Time units' => 'Tidsenheter',
      'You need to account time!' => 'Du har ikke ført tidsregnskap!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Stavekontroll må utføres på alle meldinger!',
      'Attach' => 'Legg ved',
      'Compose answer for ticket' => 'Forfatt svar til ticket',
      'for pending* states' => 'for vente-tilstander',
      'Is the ticket answered' => 'Er ticketen besvart',
      'Pending Date' => 'Utsatt til',

    # Template: AgentCrypt

    # Template: AgentCustomer
      'Change customer of ticket' => 'Endre kunde for ticket',
      'Search Customer' => 'Kundesøk',
      'Set customer user and customer id of a ticket' => 'Sett kunde-bruker og organisasjons-id for ticket',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Alle ticketer for kunde.',
      'Customer history' => 'Kunde-historikk',

    # Template: AgentCustomerMessage
      'Follow up' => 'Oppfølging',

    # Template: AgentCustomerView
      'Customer Data' => 'Kundedata',

    # Template: AgentEmailNew
      'All Agents' => 'Alle agenter',
      'Clear To' => '',
      'Compose Email' => 'Skriv email',
      'new ticket' => 'Ny ticket',

    # Template: AgentForward
      'Article type' => 'Artikkeltype',
      'Date' => 'Dato',
      'End forwarded message' => 'Slutt videresendt melding',
      'Forward article of ticket' => 'Videresend artikkel under ticket',
      'Forwarded message from' => 'Videresendt melding fra',
      'Reply-To' => '',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Endre frie ticket-felter',

    # Template: AgentHistoryForm
      'History of' => 'Historikk for',

    # Template: AgentHistoryRow

    # Template: AgentInfo
      'Info' => '',

    # Template: AgentLookup
      'Lookup' => '',

    # Template: AgentMailboxNavBar
      'All messages' => 'Alle meldinger',
      'down' => 'synkende',
      'Mailbox' => 'Mailbox',
      'New' => 'Ny',
      'New messages' => 'Ny melding',
      'Open' => 'Åpne',
      'Open messages' => 'Åpne meldinger',
      'Order' => 'Sortering',
      'Pending messages' => 'Ventende meldinger',
      'Reminder' => 'Påminnelse',
      'Reminder messages' => 'Påminnelses-meldinger',
      'Sort by' => 'Sorter etter',
      'Tickets' => 'Ticketer',
      'up' => 'stigende',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',
      'Add a note to this ticket!' => '',
      'Change the ticket customer!' => '',
      'Change the ticket owner!' => '',
      'Change the ticket priority!' => '',
      'Close this ticket!' => '',
      'Shows the detail view of this ticket!' => '',
      'Unlock this ticket!' => '',

    # Template: AgentMove
      'Move Ticket' => 'Flytt ticket',
      'Previous Owner' => 'Forrige eier',
      'Queue ID' => 'Kø-id',

    # Template: AgentNavigationBar
      'Agent Preferences' => '',
      'Bulk Action' => '',
      'Bulk Actions on Tickets' => '',
      'Create new Email Ticket' => '',
      'Create new Phone Ticket' => '',
      'Email-Ticket' => '',
      'Locked tickets' => 'Låste ticketer',
      'new message' => 'Nye meldinger',
      'Overview of all open Tickets' => '',
      'Phone-Ticket' => '',
      'Preferences' => 'Innstillinger',
      'Search Tickets' => '',
      'Ticket selected for bulk action!' => '',
      'You need min. one selected Ticket!' => '',

    # Template: AgentNote
      'Add note to ticket' => 'Legg til notis ved ticket',

    # Template: AgentOwner
      'Change owner of ticket' => 'Endre eier av ticket',
      'Message for new Owner' => 'Melding for ny eier',

    # Template: AgentPending
      'Pending date' => 'Utsatt til',
      'Pending type' => 'Venter på',
      'Set Pending' => 'Sett utsettelse',

    # Template: AgentPhone
      'Phone call' => 'Telefonanrop',

    # Template: AgentPhoneNew
      'Clear From' => 'Blank ut Fra:',

    # Template: AgentPlain
      'ArticleID' => '',
      'Download' => '',
      'Plain' => 'Enkel',
      'TicketID' => '',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => '',
      'You also get notified about this queues via email if enabled.' => '',
      'Your queue selection of your favorite queues.' => '',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Endre passord',
      'New password' => 'Nytt passord',
      'New password again' => 'Gjenta nytt passord',

    # Template: AgentPriority
      'Change priority of ticket' => 'Endre prioritet for ticket',

    # Template: AgentSpelling
      'Apply these changes' => 'Iverksett endringer',
      'Spell Checker' => 'Stavekontroll',
      'spelling error(s)' => 'Stavefeil',

    # Template: AgentStatusView
      'D' => 'N',
      'of' => 'av',
      'Site' => 'side',
      'sort downward' => 'Sorter synkende',
      'sort upward' => 'Sorter stigende',
      'Ticket Status' => 'Ticketstatus',
      'U' => 'O',

    # Template: AgentTicketLink
      'Delete Link' => '',
      'Link' => 'Link',
      'Link to' => 'Link til',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket låst',
      'Ticket unlock!' => 'Ticket frigi',

    # Template: AgentTicketPrint

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Benyttet tid',
      'Escalation in' => 'Eskalering om',

    # Template: AgentUtilSearch
      'Profile' => 'Profil',
      'Result Form' => 'Resultatbilde',
      'Save Search-Profile as Template?' => 'Lagre søkekriterier som mal?',
      'Search-Template' => 'Søkemal',
      'Select' => 'Velg',
      'Ticket Search' => 'Ticket-søk',
      'Yes, save it with name' => 'Ja, lagre med navn',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Historikk for kunde',
      'Customer history search (e. g. "ID342425").' => 'Søk etter kunde for historikk (f.eks. "ID342425").',
      'No * possible!' => 'Jokertegn ikke tillatt!',

    # Template: AgentUtilSearchResult
      'Change search options' => 'Endre søke-innstillinger',
      'Results' => 'Resultat',
      'Search Result' => 'Søkeresultat',
      'Total hits' => 'Totalt funnet',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Alle lukkede ticketer',
      'All open tickets' => 'Alle åpne ticketer',
      'closed tickets' => 'lukkede ticketer',
      'open tickets' => 'åpne ticketer',
      'or' => 'eller',
      'Provides an overview of all' => 'Gir en oversikt over alle',
      'So you see what is going on in your system.' => 'Slik at du kan se hva som skjer i systemet.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Skriv oppfølgingssvar',
      'Your own Ticket' => 'Din egen ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Skriv svar',
      'Contact customer' => 'Kontakt kunde',
      'phone call' => 'Telefonanrop',

    # Template: AgentZoomArticle
      'Split' => 'Splitt',

    # Template: AgentZoomBody
      'Change queue' => 'Endre kø',

    # Template: AgentZoomHead
      'Change the ticket free fields!' => '',
      'Free Fields' => 'Frie felt',
      'Link this ticket to an other one!' => '',
      'Lock it to work on it!' => '',
      'Print' => 'Skriv ut',
      'Print this ticket!' => '',
      'Set this ticket to pending!' => '',
      'Shows the ticket history!' => '',

    # Template: AgentZoomStatus
      '"}","18' => '',
      'Locked' => '',
      'SLA Age' => '',

    # Template: Copyright
      'printed by' => 'skrevet av',

    # Template: CustomerAccept

    # Template: CustomerCreateAccount
      'Create Account' => 'Opprekt konto',
      'Login' => '',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'FAQ History' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Kategori',
      'Keywords' => 'Nøkkelord',
      'Last update' => 'Sist endret',
      'Problem' => 'Problem',
      'Solution' => 'Løsning',
      'Symptom' => 'Symptom',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: CustomerFAQArticleView
      'FAQ Article' => '',
      'Modified' => 'Endret',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'FAQ Oversikt',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'FAQ Søk',
      'Fulltext' => 'Fritekst',
      'Keyword' => 'Nøkkelord',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'FAQ Søkeresultat',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerLostPassword
      'Lost your password?' => 'Mistet passord?',
      'Request new password' => 'Be om nytt passord',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => '',
      'Create new Ticket' => 'Opprett ny ticket',
      'FAQ' => 'FAQ',
      'MyTickets' => '',
      'New Ticket' => 'Ny ticket',
      'Welcome %s' => 'Velkommen %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerTicketSearch

    # Template: CustomerTicketSearchResultPrint

    # Template: CustomerTicketSearchResultShort

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Klikk her for å rapportere en feil!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Slett FAQ',
      'You really want to delete this article?' => 'Virkelig slette denne artikkelen?',

    # Template: FAQArticleForm
      'A article should have a title!' => '',
      'Comment (internal)' => 'Kommentar (intern)',
      'Filename' => 'Filnavn',
      'Title' => '',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQArticleViewSmall

    # Template: FAQCategoryForm
      'FAQ Category' => 'FAQ Kategori',
      'Name is required!' => '',

    # Template: FAQLanguageForm
      'FAQ Language' => 'FAQ Språk',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: Footer
      'Top of Page' => 'Toppen av siden',

    # Template: FooterSmall

    # Template: InstallerBody
      'Create Database' => 'Opprett database',
      'Drop Database' => 'Slett database',
      'Finished' => 'Ferdig',
      'System Settings' => 'Systeminnstillinger',
      'Web-Installer' => 'Web-installasjon',

    # Template: InstallerFinish
      'Admin-User' => 'Admin-bruker',
      'After doing so your OTRS is up and running.' => 'Etter dette vil OTRS være oppe å kjøre.',
      'Have a lot of fun!' => 'Ha det gøy!',
      'Restart your webserver' => 'Restart webserveren din',
      'Start page' => 'Startside',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'For å kunne bruke OTRS, må følgende linje utføres på kommandolinjen som root.',
      'Your OTRS Team' => 'Ditt OTRS-Team',

    # Template: InstallerLicense
      'accept license' => 'aksepter lisens',
      'don\'t accept license' => 'ikke aksepter lisens',
      'License' => 'Lisens',

    # Template: InstallerStart
      'Create new database' => 'Opprett ny database',
      'DB Admin Password' => 'DB administratorpassord',
      'DB Admin User' => 'DB administratorbruker',
      'DB Host' => 'DB maskin',
      'DB Type' => 'DB type',
      'default \'hot\'' => 'default \'hot\'',
      'Delete old database' => 'Slett gammel database',
      'next step' => 'neste steg',
      'OTRS DB connect host' => 'OTRS DB connect host',
      'OTRS DB Name' => 'OTRS DB navn',
      'OTRS DB Password' => 'OTRS DB passord',
      'OTRS DB User' => 'OTRS DB bruker',
      'your MySQL DB should have a root password! Default is empty!' => 'Din MySQL-database bør ha et root-passord satt!  Default er intet passord!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Sjekker mx-innslag for oppgitte email-adresser i meldiger som skrives.  Bruk ikke CheckMXRecord om din OTRS-maskin er bak en oppringt-linje!)',
      '(Email of the system admin)' => '(Email til systemadmin)',
      '(Full qualified domain name of your system)' => '(Fullkvalifisert dns-navn for ditt system)',
      '(Logfile just needed for File-LogModule!)' => '(Logfile kun påkrevet for File-LogModule!)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Unik id for dette systemet.  Alle ticketnummer og http-sesjonsid-er starter med denne id-en)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Ticket-kjennetegn, f.eks. \'Ticket#\', \'Call#\' eller \'MyTicket#\')',
      '(Used default language)' => '(Valgt standardspråk)',
      '(Used log backend)' => '(Valgt logge-backend)',
      '(Used ticket number format)' => '(Valgt format for ticketnummer)',
      'CheckMXRecord' => '',
      'Default Charset' => 'Standardtegnsett',
      'Default Language' => 'Standardspråk',
      'Logfile' => 'Logfil',
      'LogModule' => '',
      'Organization' => 'Organisasjon',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Ticket-nummergenerator',
      'Use utf-8 it your database supports it!' => 'Bruk utf-8 dersom din database støtter det!',
      'Webfrontend' => 'Web-grensesnitt',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Ingen tilgang',

    # Template: Notify

    # Template: PrintFooter
      'URL' => '',

    # Template: QueueView
      'All tickets' => 'Alle ticketer',
      'Page' => 'Side',
      'Queues' => 'Køer',
      'Tickets available' => 'Tilgjengelige ticketer',
      'Tickets shown' => 'Ticketer vist',

    # Template: SystemStats

    # Template: Test
      'OTRS Test Page' => 'OTRS Test-side',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ticket-eskalering!',

    # Template: TicketView

    # Template: TicketViewLite

    # Template: Warning

    # Template: css
      'Home' => 'Hjem',

    # Template: customer-css
      'Contact' => 'Kontakt',
      'Online-Support' => 'Online-support',
      'Products' => 'Produkter',
      'Support' => 'Support',

    # Misc
      '"}","15' => '',
      '"}","30' => '',
      'Add auto response' => 'Legg til autosvar',
      'Addressbook' => 'Adressebok',
      'AgentFrontend' => 'Agent-grensesnitt',
      'Article free text' => 'Artikel-fritekst',
      'BackendMessage' => 'Backend-melding',
      'Bottom of Page' => 'Bunn av siden',
      'Change Response <-> Attachment settings' => 'Endre Ferdigsvar <-> Vedleggs-innstillinger',
      'Change answer <-> queue settings' => 'Endre Ferdigsvar <-> Kø-innstillinger',
      'Change auto response settings' => 'Endre autosvar-innstillinger',
      'Charset' => 'Tegnsett',
      'Charsets' => 'Tegnsett',
      'Closed' => 'Lukket',
      'Create' => 'Opprett',
      'Customer called' => 'Kundeoppringning',
      'Customer user will be needed to to login via customer panels.' => 'Kunde-bruker er påkrevet for at kunden skal kunne logge inn på kunde-sidene.',
      'FAQ State' => 'FAQ Status',
      'Graphs' => 'Grafer',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Hvis dette er en betrodd konto blir X-OTRS Header benyttet!',
      'Lock Ticket' => 'Lås ticket',
      'Max Rows' => 'Maks linjer',
      'My Tickets' => 'Mine ticketer',
      'New ticket via call.' => 'Ny ticket etter anrop.',
      'New user' => 'Ny bruker',
      'Pending!' => 'Venter!',
      'Phone call at %s' => 'Telefonanrop %s',
      'Please go away!' => 'Systemet kan ikke se at du er autorisert for handlingen du forsøker å utføre.  Ta kontakt med administrator om du mener dette ikke stemmer.',
      'PostMasterFilter Management' => '',
      'Search in' => 'Søk i',
      'Select source:' => 'Velg kilde',
      'Select your custom queues' => 'Mine utvalgte køer ("PersonalQueue")',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Send meg en melding dersom en ticket flyttes over i en av mine utvalgte køer.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Send meg en melding dersom det kommer en ny melding i mine utvalgte køer.',
      'SessionID' => '',
      'Short Description' => 'Kort beskrivelse',
      'Show all' => 'Vis alle',
      'Shown Tickets' => 'Viste ticketer',
      'System Charset Management' => 'Tegnsett-innstillinger',
      'Ticket-Overview' => 'Ticket-oversikt',
      'Time till escalation' => 'Tid til eskalering',
      'Utilities' => 'Søk',
      'With Priority' => 'Med prioritet',
      'With State' => 'Med status',
      'by' => 'av',
      'invalid-temporarily' => 'midlertidig ugyldig',
      'search' => 'søk',
      'store' => 'lagre',
      'tickets' => 'ticketer',
      'valid' => 'gyldig',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
