# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Maintenance responsibility taken over by Hans Bakker (h.bakker@a-net.nl)
# Copyright (C) 2003 A-NeT Internet Services bv
# --
# $Id: nl.pm,v 1.15 2004-01-20 00:02:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::nl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Mon Apr 14 16:53:55 2003 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minuten',
      ' 5 minutes' => ' 5 minuten',
      ' 7 minutes' => ' 7 minuten',
      '10 minutes' => '10 minuten',
      '15 minutes' => '15 minuten',
      'AddLink' => 'Link toevoegen',
      'Admin-Area' => 'Admin',
      'agent' => 'agent',
      'all' => 'alle',
      'All' => 'Alle',
      'Attention' => 'Let op',
      'Bug Report' => 'Foutrapport',
      'Cancel' => 'Afbreken',
      'change' => 'wijzigen',
      'Change' => 'Wijzigen',
      'change!' => 'wijzigen!',
      'click here' => 'klik hier',
      'Comment' => 'Commentaar',
      'Customer' => 'Klant',
      'customer' => 'klant',
      'Customer Info' => 'Klant informatie',
      'day' => 'dag',
      'days' => 'dagen',
      'description' => 'omschrijving',
      'Description' => 'Omschrijving',
      'Dispatching by email To: field.' => 'Versturen per email Aan: veld.',
      'Dispatching by selected Queue.' => 'Versturen per gestelecteerde wachtrij',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Werk niet met User# 1 (systeem account)! maak nieuwe gebruikers aan',
      'Done' => 'Klaar',
      'end' => 'Onderkant',
      'Error' => 'Fout',
      'Example' => 'Voorbeeld',
      'Examples' => 'Voorbeelden',
      'Facility' => 'Facility',
      'Feature not active!' => 'Functie niet actief!',
      'go' => 'start',
      'go!' => 'start!',
      'Group' => 'Groep',
      'Hit' => 'Gevonden',
      'Hits' => 'Hits',
      'hour' => 'uur',
      'hours' => 'uur',
      'Ignore' => 'Negeren',
      'invalid' => 'ongeldig',
      'Invalid SessionID!' => 'Ongeldige Sessie #',
      'Language' => 'Taal',
      'Languages' => 'Talen',
      'Line' => 'Regel',
      'Lite' => 'Licht',
      'Login failed! Your username or password was entered incorrectly.' => 'Aanmelden mislukt. Uw gebruikersnaam of wachtwoord is onjuist.',
      'Logout successful. Thank you for using OTRS!' => 'Afgemeld! Wij danken u voor het gebruiken van OTRS!',
      'Message' => 'Bericht',
      'minute' => 'minuut',
      'minutes' => 'minuten',
      'Module' => 'Module',
      'Modulefile' => 'Modulebestand',
      'Name' => 'Naam',
      'New message' => 'Nieuw bericht',
      'New message!' => 'Nieuw bericht!',
      'No' => 'Geen',
      'no' => 'geen',
      'No entry found!' => 'Niets gevonden!',
      'No suggestions' => 'Geen suggesties',
      'none' => 'geen',
      'none - answered' => 'geen - beantwoord',
      'none!' => 'niet ingevoerd!',
      'Off' => 'Uit',
      'off' => 'uit',
      'On' => 'Aan',
      'on' => 'aan',
      'Password' => 'Wachtwoord',
      'Pending till' => 'In wachtstand tot',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'A.u.b. geëscaleerde tickets beantwoorden om terug te komen in de normale wachtwij',
      'Please contact your admin' => 'Vraag uw systeembeheerder',
      'please do not edit!' => 'A.u.b. niet wijzigen!',
      'possible' => 'mogelijk',
      'QueueView' => 'Wachtrijen',
      'reject' => 'afwijzen',
      'replace with' => 'vervangen met',
      'Reset' => 'leegmaken',
      'Salutation' => 'Aanhef',
      'Session has timed out. Please log in again.' => 'Sessie is verlopen. Opnieuw inloggen AUB.',
      'Signature' => 'Handtekening',
      'Sorry' => 'Sorry',
      'Stats' => 'Statistiek',
      'Subfunction' => 'sub-functie',
      'submit' => 'versturen',
      'submit!' => 'versturen!',
      'system' => 'systeem',
      'Take this User' => 'Selecteer deze gebruiker',
      'Text' => 'Tekst',
      'The recommended charset for your language is %s!' => 'De aanbvoelen karakterset voor uw taal is %s!',
      'Theme' => 'Thema',
      'There is no account with that login name.' => 'Er is geen account met deze gebruikersnaam',
      'Timeover' => 'Timeover',
      'top' => 'Bovenkant',
      'update' => 'wijzigen',
      'update!' => 'wijzigen!',
      'User' => 'Gebruiker',
      'Username' => 'Gebruikersnaam',
      'Valid' => 'Geldig',
      'Warning' => 'Waarschuwing',
      'Welcome to OTRS' => 'Welkom bij OTRS',
      'Word' => 'Woord',
      'wrote' => 'schreef',
      'yes' => 'ja',
      'Yes' => 'Ja',
      'You got new message!' => 'U heeft een nieuwe bericht!',
      'You have %s new message(s)!' => 'U heeft %s nieuwe bericht(en)!',
      'You have %s reminder ticket(s)!' => 'U heeft %s herinneringsticket(s)!',

    # Template: AAAMonth
      'Apr' => 'Apr',
      'Aug' => 'Aug',
      'Dec' => 'Dec',
      'Feb' => 'Feb',
      'Jan' => 'Jan',
      'Jul' => 'Jul',
      'Jun' => 'Jun',
      'Mar' => 'Mrt',
      'May' => 'Mei',
      'Nov' => 'Nov',
      'Oct' => 'Okt',
      'Sep' => 'Sep',

    # Template: AAAPreferences
      'Closed Tickets' => 'Afgesloten tickets',
      'Custom Queue' => 'Aangepaste wachtrij',
      'Follow up notification' => 'Bericht bij vervolgvragen',
      'Frontend' => 'Voorkant',
      'Mail Management' => 'Mail beheer',
      'Move notification' => 'Bericht bij het verplaatsen',
      'New ticket notification' => 'Bericht bij een nieuw ticket',
      'Other Options' => 'Andere opties',
      'Preferences updated successfully!' => 'Voorkeuren zijn gewijzigd!',
      'QueueView refresh time' => 'Verversingstijd wachtrij',
      'Select your default spelling dictionary.' => 'Selekteer uw standaard spelling bibliotheek.',
      'Select your frontend Charset.' => 'Karakterset kiezen',
      'Select your frontend language.' => 'Kies een taal',
      'Select your frontend QueueView.' => 'Wachtrij weergave kiezen',
      'Select your frontend Theme.' => 'thema kiezen',
      'Select your QueueView refresh time.' => 'Verversingstijd kiezen',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Stuur een bericht als een klant een vervolgvraag stelt en ik de eigenaar van het ticket ben.',
      'Send me a notification if a ticket is moved into a custom queue.' => ' Stuur mij een bericht als een bericht wordt verplaatst in een aangepaste wachtrij',
      'Send me a notification if a ticket is unlocked by the system.' => 'Stuur  me een bericht als een ticket wordt ontgrendeld door het systeem.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Stuur mij een bericht als er een nieuw ticket in mijn aangepaste wachtrij komt.',
      'Show closed tickets.' => 'Laat gesloten berichten zien',
      'Spelling Dictionary' => 'Spelling bibliotheek',
      'Ticket lock timeout notification' => 'Bericht van tijdsoverschreiding van een vergrendeling',

    # Template: AAATicket
      '1 very low' => '1 zeer laag',
      '2 low' => '2 laag',
      '3 normal' => '3 normaal',
      '4 high' => '4 hoog',
      '5 very high' => '5 zeer hoog',
      'Action' => 'Actie',
      'Age' => 'Leeftijd',
      'Article' => 'Artikel',
      'Attachment' => 'Bijlage',
      'Attachments' => 'Bijlagen',
      'Bcc' => 'Bcc',
      'Bounce' => 'Terugsturen',
      'Cc' => 'Cc',
      'Close' => 'Sluiten',
      'closed successful' => 'succesvol gesloten',
      'closed unsuccessful' => 'niet succesvol gesloten',
      'Compose' => 'Maken',
      'Created' => 'Gemaakt',
      'Createtime' => 'Gemaakt op',
      'email' => 'email',
      'eMail' => 'eMail',
      'email-external' => 'Email naar extern',
      'email-internal' => 'Email naar intern',
      'Forward' => 'Doorsturen',
      'From' => 'Van',
      'high' => 'hoog',
      'History' => 'Geschiedenis',
      'If it is not displayed correctly,' => 'Als dit niet juist wordt weergegeven,',
      'lock' => 'vergrendelen',
      'Lock' => 'Vergrendelen',
      'low' => 'laag',
      'Move' => 'Verplaatsen',
      'new' => 'nieuw',
      'normal' => 'normaal',
      'note-external' => 'externe notitie',
      'note-internal' => 'interne notitie',
      'note-report' => 'Notitie rapportage',
      'open' => 'open',
      'Owner' => 'Eigenaar',
      'Pending' => 'Wachtend',
      'pending auto close+' => 'Wachtend op automatisch sluiten+',
      'pending auto close-' => 'Wachtend op automatisch sluiten-',
      'pending reminder' => 'Herinnering voor wachtend',
      'phone' => 'telefoon',
      'plain' => 'zonder opmaak',
      'Priority' => 'Prioriteit',
      'Queue' => 'Wachtrij',
      'removed' => 'verwijderd',
      'Sender' => 'Afzender',
      'sms' => 'sms',
      'State' => 'Status',
      'Subject' => 'Betreft',
      'This is a' => 'Dit is een',
      'This is a HTML email. Click here to show it.' => 'Dit is een Email in HTML-formaat. Hier klikken om te bekijken.',
      'This message was written in a character set other than your own.' => 'Dit bericht is geschreven in een andere karakterset dan degene die u nu heeft ingesteld.',
      'Ticket' => 'Ticket',
      'To' => 'Aan',
      'to open it in a new window.' => 'om deze in een nieuw venster getoond te krijgen',
      'unlock' => 'vrijgeven',
      'Unlock' => 'Vrijgeven',
      'very high' => 'zeer hoog',
      'very low' => 'zeer laag',
      'View' => 'Weergave',
      'webrequest' => 'Verzoek via www',
      'Zoom' => 'Inhoud',

    # Template: AAAWeekDay
      'Fri' => 'vrij',
      'Mon' => 'maa',
      'Sat' => 'zat',
      'Sun' => 'zon',
      'Thu' => 'don',
      'Tue' => 'din',
      'Wed' => 'woe',

    # Template: AdminAttachmentForm
      'Add attachment' => 'Voeg bijlage toe',
      'Attachment Management' => 'Bijlage beheer',
      'Change attachment settings' => 'Wijzig bijlage instellingen',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Automatisch antwoord toevoegen',
      'Auto Response From' => 'Automatisch Antwoord Van',
      'Auto Response Management' => 'Automatisch-antwoorden beheer',
      'Change auto response settings' => 'Wijzigen van een automatisch-antwoord',
      'Charset' => 'karakterset',
      'Note' => 'Notitie',
      'Response' => 'Antwoord',
      'to get the first 20 character of the subject' => 'voor de eerste 20 tekens van het onderwerp',
      'to get the first 5 lines of the email' => 'voor de eerste 5 regels van het bericht',
      'to get the from line of the email' => 'voor de Van: kop',
      'to get the realname of the sender (if given)' => 'voor de echte naam van de afzender (indien beschikbaar)',
      'to get the ticket id of the ticket' => 'voor het ticket #',
      'to get the ticket number of the ticket' => 'voor het ticket-nummer',
      'Type' => 'Type',
      'Useable options' => 'Te gebruiken opties',

    # Template: AdminCharsetForm
      'Add charset' => 'Karakterset toevoegen',
      'Change system charset setting' => 'Andere systeem karakterset',
      'System Charset Management' => 'Systeem karakterset beheer',

    # Template: AdminCustomerUserForm
      'Add customer user' => 'Voeg klantgebruiker toe',
      'Change customer user settings' => 'Wijzig klantgebruiker voorkeuren',
      'Customer User Management' => 'klantgebruiker beheer',
      'Customer user will be needed to to login via customer panels.' => 'klantgebruiker moet inloggen via klant-menus.',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Admin-Email',
      'Body' => 'berichttekst',
      'OTRS-Admin Info!' => 'OTRS-Admin informatie!',
      'Permission' => 'Toestemmimg',
      'Recipents' => 'Ontvangers',
      'send' => 'verstuur',

    # Template: AdminEmailSent
      'Message sent to' => 'Bericht verstuurd naar',

    # Template: AdminGroupForm
      'Add group' => 'Groep toevoegen',
      'Change group settings' => 'Wijzigen van een groep',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Maak nieuwe groepen om toegangsrechten te regelen voor verschillende groepen van agenten (bijv. verkoopafdeling, supportafdeling, enz. enz.).',
      'Group Management' => 'Groepenbeheer',
      'It\'s useful for ASP solutions.' => 'Zeer bruikbaar voor ASP-oplossingen.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Leden van de admingroep mogen in het administratiegedeelte, leden van de Stats groep hebben toegang tot het statistiekgedeelte.',

    # Template: AdminLog
      'System Log' => 'Systeem logboek',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin Email',
      'AgentFrontend' => 'Agent weergave',
      'Attachment <-> Response' => 'Bijlage <-> Antwoord',
      'Auto Response <-> Queue' => 'Automatische antwoord <-> Wachtrij',
      'Auto Responses' => 'Automatische antwoorden',
      'Charsets' => 'Karaktersets',
      'Customer User' => 'Klantgebruiker',
      'Email Addresses' => 'Email Adressen',
      'Groups' => 'Groepen',
      'Logout' => 'Afmelden',
      'Misc' => 'Overige',
      'POP3 Account' => 'POP3 Account',
      'Responses' => 'Antwoorden',
      'Responses <-> Queue' => 'Antwoorden <-> Wachtrij',
      'Select Box' => 'SQL select query',
      'Session Management' => 'Sessiebeheer',
      'Status' => 'Status',
      'System' => 'Systeem',
      'User <-> Groups' => 'Gebruikers <-> Groepen',

    # Template: AdminPOP3Form
      'Add POP3 Account' => 'Voeg een POP3-account toe',
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle binnenkomende email\'s in een account zullen worden geplaatst in de geselecteerde wachtrij',
      'Change POP3 Account setting' => 'Wijzig POP3-account instellingen',
      'Dispatching' => 'Versturen',
      'Host' => 'Server',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Wanneer uw account te vertrouwen is, zal de x/otrs header (voor prioriteit, ...) worden gebruikt',
      'Login' => 'Login',
      'POP3 Account Management' => 'POP3 account-beheer',
      'Trusted' => 'Te vertrouwen',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Wachtrij<-> Automatisch antwoorden toekenning',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = geen escalatie',
      '0 = no unlock' => '0 = geen ontgrendeling',
      'Add queue' => 'Wachtrij toevoegen',
      'Change queue settings' => 'Wachtrij info wijzigen',
      'Customer Move Notify' => 'Klant notificatie bij verplaatsen',
      'Customer Owner Notify' => 'Klant notificatie andere eigenaar',
      'Customer State Notify' => 'Klant notificatie andere status',
      'Escalation time' => 'Escalatietijd',
      'Follow up Option' => 'Follow up optie',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wanneer een ticket wordt gesloten and de klant stuurt een follow-up het ticket wordt vergrendeld door de oude eigenaar',
      'If a ticket will not be answered in this time, just only this ticket will be shown.' => 'Wanneer een ticket niet wordt beantwoord binnen deze tijd, dan wordt alleen dit ticket getoond',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wanneer een agent een ticket vergrendeld en hij/zij stuurt geen antwoord binnen deze tijd dan zal het ticket automatisch ontgrendeld worden. Het ticket kan dan door andere agenten worden ingezien.',
      'Key' => 'Sleutel',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS stuurt een notificatie e-mail naar de klant wanneer het ticket wordt verplaatst.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS stuurt een notificatie e-mail naar de klant wanneer de eigenaar is veranderd',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS stuurt een notificatie e-mail naar de klant wanneer de status is veranderd',
      'Queue Management' => 'Wachtrijbeheer',
      'Sub-Queue of' => 'onder-wachtrij van',
      'Systemaddress' => 'Systeem-adres',
      'The salutation for email answers.' => 'De aanhef voor antwoorden per e-mail.',
      'The signature for email answers.' => 'De handtekening voor antwoorden per e-mail.',
      'Ticket lock after a follow up' => 'Ticket-vergrendeling na een follow up',
      'Unlock timeout' => 'Vrijgave tijdoverschrijding',
      'Will be the sender address of this queue for email answers.' => 'is het afzenderadres van deze wachtrij voor antwoorden per e-mail',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => 'Wijzig instellingen voor %s',
      'Std. Responses <-> Queue Management' => 'Antwoorden <-> Wachtrij beheer',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Antwoord',
      'Change answer <-> queue settings' => 'Wijzigen van antwoorden <-> wachtrij toekenning',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Std. antwoorden <-> Std. bijlagen beheer',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Wijzig antwoord <-> bijlagen voorkeuren',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Een antworord is een standaard-tekst om sneller antwoorden te kunnen opstellen.',
      'Add response' => 'Antwoord toevoegen',
      'Change response settings' => 'Antwoord wijzigen',
      'Don\'t forget to add a new response a queue!' => 'Vergeet niet om een antwoord aan de wachtrij toe te kennen!',
      'Response Management' => 'Antwoordbeheer',

    # Template: AdminSalutationForm
      'Add salutation' => 'Aanhef toevoegen',
      'Change salutation settings' => 'Aanhef wijzigen',
      'customer realname' => 'echte klantnaam',
      'for agent firstname' => 'voornaam van agent',
      'for agent lastname' => 'achternaam van agent',
      'for agent login' => 'de login van de agent',
      'for agent user id' => 'de loginnaam van de agent ',
      'Salutation Management' => 'Aanhef beheer',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. rijen',

    # Template: AdminSelectBoxResult
      'Limit' => 'Beperk',
      'Select Box Result' => 'keuzekader resultaat',
      'SQL' => 'SQL',

    # Template: AdminSession
      'kill all sessions' => 'Alle sessies afsluiten',

    # Template: AdminSessionTable
      'kill session' => 'Sessie afsluiten',
      'SessionID' => 'Sessie #',

    # Template: AdminSignatureForm
      'Add signature' => 'Handtekening toevoegen',
      'Change signature settings' => 'Handtekening wijzigen',
      'Signature Management' => 'handtekeningbeheer',

    # Template: AdminStateForm
      'Add state' => 'Status toevoegen',
      'Change system state setting' => 'Wijzig systeemstatus',
      'State Type' => 'Status Type',
      'System State Management' => 'Systeem-status beheer',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Systeem emailadres toevoegen',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle binnenkomende emails met deze "To:" worden in de gekozen wachtrij geplaatst.',
      'Change system address setting' => 'Systeemadres wijzigen',
      'Email' => 'Email',
      'Realname' => 'Echte naam',
      'System Email Addresses Management' => 'Email systeemadressen beheer',

    # Template: AdminUserForm
      'Add user' => 'Gebruiker toevoegen',
      'Change user settings' => 'Wijzigen van gebruikersinstellingen',
      'Don\'t forget to add a new user to groups!' => 'Vergeet niet om groepen aan deze gebruiker toe te kennen!',
      'Firstname' => 'Voornaam',
      'Lastname' => 'Achternaam',
      'User Management' => 'Gebruikersbeheer',
      'User will be needed to handle tickets.' => 'Gebruikers zijn nodig om tickets te behandelen.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => 'Wijzig voorkeuren',
      'User <-> Group Management' => 'Gebruiker <-> Groep beheer',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Wijzigen van gebruiker <-> groep toekenning',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Een bericht moet een ontvanger (aan:) hebben!',
      'Bounce ticket' => 'Bounce ticket',
      'Bounce to' => 'Bounce naar',
      'Inform sender' => 'Informeer afzender',
      'Next ticket state' => 'Volgende status van het ticket',
      'Send mail!' => 'bericht versturen!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'In het Aan-veld hebben we een Email-adres nodig!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Je email met ticket nummer "<OTRS_TICKET>" is gebounced naar "<OTRS_BOUNCE_TO>". Contacteer dit adres voor meer informatie.',

    # Template: AgentClose
      ' (work units)' => '(werk eenheden)',
      'A message should have a subject!' => 'Een bericht moet een ondewerp hebben!',
      'Close ticket' => 'Sluit ticket',
      'Close type' => 'Sluit-type',
      'Close!' => 'Sluit!',
      'Note Text' => 'Notitietekst',
      'Note type' => 'Notitie-type',
      'Options' => 'Optie',
      'Spell Check' => 'Spellingscontrole',
      'Time units' => 'Tijds-eenheden',
      'You need to account time!' => '',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Van een bericht moet de spelling gecontroleerd worden',
      'Attach' => 'Voeg toe',
      'Compose answer for ticket' => 'Bericht opstellen voor',
      'for pending* states' => 'voor nog hangende* statussen',
      'Is the ticket answered' => 'Is het ticket beantwoord?',
      'Pending Date' => 'Nog hangende datum',

    # Template: AgentCustomer
      'Back' => 'Terug',
      'Change customer of ticket' => 'Wijzig klant van een ticket',
      'CustomerID' => 'Klant #',
      'Search Customer' => 'Klanten zoeken',
      'Set customer user and customer id of a ticket' => 'Wijs de klantgebruiker en klant # van een ticket toe',

    # Template: AgentCustomerHistory
      'Customer history' => 'Klantgeschiedenis',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerMessage
      'Follow up' => 'Follow up',
      'Next state' => 'Volgende status',

    # Template: AgentCustomerView
      'Customer Data' => 'Klantgegevens',

    # Template: AgentForward
      'Article type' => 'Artikel-type',
      'Date' => 'Datum',
      'End forwarded message' => 'Be-eindig doorgestuurd bericht',
      'Forward article of ticket' => 'Artikel van ticket doorsturen',
      'Forwarded message from' => 'Doorgestuurd bericht van',
      'Reply-To' => 'Antwoord aan',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Verander de tekst van een bericht',
      'Value' => 'Waarde',

    # Template: AgentHistoryForm
      'History of' => 'Geschiedenis van',

    # Template: AgentMailboxNavBar
      'All messages' => 'Alle berichten',
      'down' => 'naar beneden',
      'Mailbox' => 'Postbus',
      'New' => 'Nieuw',
      'New messages' => 'Nieuwe berichten',
      'Open' => 'Open',
      'Open messages' => 'Open berichten',
      'Order' => 'Volgorde',
      'Pending messages' => 'wachtende berichten',
      'Reminder' => 'Herinnering',
      'Reminder messages' => 'Herinneringsberichten',
      'Sort by' => 'Sorteer volgens',
      'Tickets' => 'Tickets',
      'up' => 'naar boven',

    # Template: AgentMailboxTicket

    # Template: AgentMove
      'Move Ticket' => 'Verplaats Bericht',
      'New Queue' => 'Nieuwe Wachtrij',
      'New user' => 'Nieuwe gebruiker',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Eigen tickets',
      'new message' => 'Nieuw bericht',
      'PhoneView' => 'Telefoon weergave',
      'Preferences' => 'Voorkeuren',
      'Utilities' => 'Zoeken',

    # Template: AgentNote
      'Add note to ticket' => 'Notitie toevoegen aan ticket',
      'Note!' => 'Let op!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Wijzig eigenaar van ticket',
      'Message for new Owner' => 'Bericht voor nieuwe eigenaar',

    # Template: AgentPending
      'Pending date' => 'Wachtend: datum',
      'Pending type' => 'Wachtend: type',
      'Pending!' => 'Wachtend',
      'Set Pending' => 'Zet wachtend',

    # Template: AgentPhone
      'Customer called' => 'Klant heeft gebeld',
      'Phone call' => 'Telefoongesprek',
      'Phone call at %s' => 'Gebeld om %s',

    # Template: AgentPhoneNew
      'Clear From' => 'Wis Van',
      'create' => 'Aanmaken',
      'new ticket' => 'nieuw ticket',

    # Template: AgentPlain
      'ArticleID' => 'Artikel #',
      'Plain' => 'Zonder opmaak',
      'TicketID' => 'Ticket #',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Voorkeurswachtrijen kiezen',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Wachtwoord wijzigen',
      'New password' => 'Nieuw wachtwoord',
      'New password again' => 'Nieuw wachtwoord herhalen',

    # Template: AgentPriority
      'Change priority of ticket' => 'Prioriteit wijzigen voor ticket',

    # Template: AgentSpelling
      'Apply these changes' => 'Pas deze wijzigingen toe',
      'Discard all changes and return to the compose screen' => 'Veranderingen niet toepassen en ga terug naar het berichtscherm',
      'Return to the compose screen' => 'Terug naar berichtscherm',
      'Spell Checker' => 'Spellingscontrole',
      'spelling error(s)' => 'Spelfout(en)',
      'The message being composed has been closed.  Exiting.' => 'Het opgestelde bericht is gesloten. Afbreken.',
      'This window must be called from compose window' => 'Dit venster moet opgeroepen worden vanuit het berichtscherm',

    # Template: AgentStatusView
      'D' => 'D',
      'of' => 'van',
      'Site' => 'Site',
      'sort downward' => 'sorteer aflopend',
      'sort upward' => 'sorteer oplopend',
      'Ticket Status' => 'Ticketstatus',
      'U' => 'U',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket vergrendeld!',
      'Ticket unlock!' => 'Ticket ontgrendeld!',

    # Template: AgentTicketPrint
      'by' => 'door',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Geregistreerde tijd',
      'Escalation in' => 'Escalatie om',
      'printed by' => 'afgedrukt door',

    # Template: AgentUtilSearch
      'Article free text' => 'Artikel tekst',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Zoeken in tekst (bijv. "Mar*in" of "Boe*" of "Martin+hallo")',
      'search' => 'zoeken',
      'search (e. g. 10*5155 or 105658*)' => 'zoeken (bijv. 10*5155 of 105658*)',
      'Ticket free text' => 'Ticket tekst',
      'Ticket Search' => 'Zoek ticket',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'zoeken in klantgeschiednis',
      'Customer history search (e. g. "ID342425").' => 'Klantgeschiedenis zoeken (bijv. "ID342425").',
      'No * possible!' => 'Geen * mogelijk!',

    # Template: AgentUtilSearchNavBar
      'Results' => 'Resultaten',
      'Total hits' => 'Totaal gevonden',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Alle gesloten tickets',
      'All open tickets' => 'Alle open tickets',
      'closed tickets' => 'gesloten tickets',
      'open tickets' => 'Open tickets',
      'or' => 'of',
      'Provides an overview of all' => 'Geeft een overzicht van alle',
      'So you see what is going on in your system.' => 'Zodat u ziet wat er in het systeem gebeurt.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Follow up aanmaken',
      'Your own Ticket' => 'Je eigen ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Antwoord opstellen',
      'Contact customer' => 'Klant contacteren',
      'phone call' => 'telefoongesprek',

    # Template: AgentZoomArticle
      'Split' => 'splitsing',

    # Template: AgentZoomBody
      'Change queue' => 'Wachtrij wisselen',

    # Template: AgentZoomHead
      'Free Fields' => 'Vrije velden',
      'Print' => 'Afdrukken',

    # Template: AgentZoomStatus

    # Template: CustomerCreateAccount
      'Create Account' => 'Maak account',

    # Template: CustomerError
      'Traceback' => 'Terug traceren',

    # Template: CustomerFooter
      'Powered by' => 'Powered by',

    # Template: CustomerHeader
      'Contact' => 'Contact',
      'Home' => 'Home',
      'Online-Support' => 'Online ondersteuning',
      'Products' => 'Producten',
      'Support' => 'Ondersteuning',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Wachtwoord vergeten?',
      'Request new password' => 'Vraag een nieuw wachtwoord aan',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Maak een nieuw Ticket',
      'My Tickets' => 'Mijn tickets',
      'New Ticket' => 'Nieuw ticket',
      'Ticket-Overview' => 'Ticket-overzicht',
      'Welcome %s' => 'Welkom %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Klik hier om een fout te rapporteren',

    # Template: Footer
      'Top of Page' => 'Bovenkant pagina',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => '',
      'Drop Database' => '',
      'Finished' => '',
      'System Settings' => '',
      'Web-Installer' => '',

    # Template: InstallerFinish
      'Admin-User' => '',
      'After doing so your OTRS is up and running.' => '',
      'Have a lot of fun!' => '',
      'Restart your webserver' => '',
      'Start page' => '',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => '',
      'Your OTRS Team' => '',

    # Template: InstallerLicense
      'accept license' => '',
      'don\'t accept license' => '',
      'License' => '',

    # Template: InstallerStart
      'Create new database' => '',
      'DB Admin Password' => '',
      'DB Admin User' => '',
      'DB Host' => '',
      'DB Type' => '',
      'default \'hot\'' => '',
      'Delete old database' => '',
      'next step' => 'volgende stap',
      'OTRS DB connect host' => '',
      'OTRS DB Name' => '',
      'OTRS DB Password' => '',
      'OTRS DB User' => '',
      'your MySQL DB should have a root password! Default is empty!' => '',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '',
      '(Email of the system admin)' => '',
      '(Full qualified domain name of your system)' => '',
      '(Logfile just needed for File-LogModule!)' => '',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '',
      '(Used default language)' => '',
      '(Used log backend)' => '',
      '(Used ticket number format)' => '',
      'CheckMXRecord' => '',
      'Default Charset' => '',
      'Default Language' => '',
      'Logfile' => '',
      'LogModule' => '',
      'Organization' => '',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => '',
      'Webfrontend' => '',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Geen rechten',

    # Template: Notify
      'Info' => 'Informatie',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader

    # Template: QueueView
      'All tickets' => 'Alle tickets',
      'Queues' => 'Wachtrij',
      'Tickets available' => 'Tickets beschikbaar',
      'Tickets shown' => 'Tickets getoond',

    # Template: SystemStats
      'Graphs' => 'Diagrammen',

    # Template: Test
      'OTRS Test Page' => 'OTRS Testpagina',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ticket escalatie!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Notitie toevoegen',

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Groep toevoegen)',
      '(Click here to add a queue)' => '(Wachtrij toevoegen)',
      '(Click here to add a response)' => '(Antwoord toevoegen)',
      '(Click here to add a salutation)' => '(Aanhef toevoegen)',
      '(Click here to add a signature)' => '(Handtekening toevoegen)',
      '(Click here to add a system email address)' => '(Systeem-emailadres toevoegen)',
      '(Click here to add a user)' => '(Gebruiker toevoegen)',
      '(Click here to add an auto response)' => '(Automatisch antwoord toevoegen)',
      '(Click here to add charset)' => '(Karakterset toevoegen)',
      '(Click here to add language)' => '(Taal toevoegen)',
      '(Click here to add state)' => '(Status toevoegen)',
      '(Click here to add a customer user)' => '',
      'A message should have a From: recipient!' => 'Een bericht moet een Van: afzender hebben!',
      'Add language' => 'Taal toevoegen',
      'Backend' => 'Systeemkant',
      'BackendMessage' => 'Bericht van Systeemkant',
      'Change system language setting' => 'Andere Systeemtaal',
      'Create' => 'Maken',
      'Customer info' => 'Klanten info',
      'FAQ' => 'FAQ',
      'Feature not acitv!' => 'Functie niet actief',
      'Fulltext search' => 'Zoeken in alle tekst',
      'Handle' => 'Handle',
      'New state' => 'Nieuwe status',
      'New ticket via call.' => 'Nieuw ticket vanaf een telefoongeprek',
      'Search in' => 'Zoeken in',
      'Set customer id of a ticket' => 'Stel het klantnummer in van een ticket',
      'Show all' => 'Alle getoond',
      'Status defs' => 'Status definities',
      'System Language Management' => 'Systeemtaal beheer',
      'Ticket available' => 'Ticket beschikbaar',
      'Ticket limit:' => 'Ticketlimiet',
      'Time till escalation' => 'Tijd tot escalatie',
      'Update auto response' => 'Automatisch antwoord wijzigen',
      'Update charset' => 'Karakterset wijzigen',
      'Update group' => 'Groep wijzigen',
      'Update language' => 'Taal wijzigen',
      'Update queue' => 'Wachtrij wijzigen',
      'Update response' => 'Antwoorden wijzigen',
      'Update salutation' => 'Aanhef wijzigen',
      'Update signature' => 'Handtekening wijzigen',
      'Update state' => 'Status wijzigen',
      'Update system address' => 'Systeem emailadres wijzigen',
      'Update user' => 'Gebruiker wijzigen',
      'Update customer user' => '',
      'With State' => 'Met status',
      'You have to be in the admin group!' => 'U moet hiervoor in de admin-groep staan!',
      'You have to be in the stats group!' => 'U moet hiervoor in de statisiek groep staan!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'In het Van-veld hebben we een Email-adres nodig!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => '',
      'auto responses set' => 'Automatische antwoorden ingesteld',
      'store' => 'opslaan',
      'tickets' => 'tickets',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
