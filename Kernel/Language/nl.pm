# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002 Fred van Dijk <fvandijk at marklin.nl>
# --
# $Id: nl.pm,v 1.1 2002-11-24 23:54:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::nl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/\$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];

    # Template: AAABasics
    $Hash{' 2 minutes'} = ' 2 minuten';
    $Hash{' 5 minutes'} = ' 5 minuten';
    $Hash{' 7 minutes'} = ' 7 minuten';
    $Hash{'10 minutes'} = '10 minuten';
    $Hash{'15 minutes'} = '15 minuten';
    $Hash{'AddLink'} = 'Link toevoegen';
    $Hash{'AdminArea'} = 'Administratiegedeelte';
    $Hash{'all'} = 'alle';
    $Hash{'All'} = 'Alle';
    $Hash{'Attention'} = 'Let op';
    $Hash{'Bug Report'} = 'Foutrapport';
    $Hash{'Cancel'} = '';
    $Hash{'change'} = 'veranderen';
    $Hash{'Change'} = 'Veranderen';
    $Hash{'change!'} = 'veranderen!';
    $Hash{'click here'} = 'klik hier';
    $Hash{'Comment'} = 'Commentaar';
    $Hash{'Customer'} = 'Klant';
    $Hash{'Customer info'} = 'Klanten info';
    $Hash{'day'} = 'dag';
    $Hash{'days'} = 'dagen';
    $Hash{'Description'} = 'Omschrijving';
    $Hash{'description'} = 'omschrijving';
    $Hash{'Done'} = '';
    $Hash{'end'} = 'Onderkant';
    $Hash{'Error'} = 'Fout';
    $Hash{'Example'} = 'Voorbeeld';
    $Hash{'Examples'} = 'Voorbeelden';
    $Hash{'go'} = 'start';
    $Hash{'go!'} = 'start!';
    $Hash{'Group'} = 'Groep';
    $Hash{'Hit'} = 'Gevonden';
    $Hash{'Hits'} = '';
    $Hash{'hour'} = 'uur';
    $Hash{'hours'} = 'uren';
    $Hash{'Ignore'} = '';
    $Hash{'Language'} = 'Taal';
    $Hash{'Languages'} = 'Talen';
    $Hash{'Line'} = 'Regel';
    $Hash{'Logout successful. Thank you for using OTRS!'} = 'Afgemeld! Wij danken u voor het gebruikeen van OTRS!';
    $Hash{'Message'} = 'Bericht';
    $Hash{'minute'} = 'minuut';
    $Hash{'minutes'} = 'minuten';
    $Hash{'Module'} = 'Module';
    $Hash{'Modulefile'} = 'Modulebestand';
    $Hash{'Name'} = 'Naam';
    $Hash{'New message'} = 'Nieuw bericht';
    $Hash{'New message!'} = 'Nieuw bericht!';
    $Hash{'no'} = 'nee';
    $Hash{'No'} = 'Nee';
    $Hash{'No suggestions'} = '';
    $Hash{'none'} = 'geen';
    $Hash{'none - answered'} = 'geen - beantwoord';
    $Hash{'none!'} = 'niet ingevoerd!';
    $Hash{'off'} = 'uit';
    $Hash{'Off'} = 'Uit';
    $Hash{'On'} = 'Aan';
    $Hash{'on'} = 'aan';
    $Hash{'Password'} = 'Wachtwoord';
    $Hash{'Please answer this ticket(s) to get back to the normal queue view!'} = 'A.u.b. geëscaleerde tickets beantwoorden om terug tekomen in de normale wachtwij';
    $Hash{'please do not edit!'} = 'A.u.b. niet wijzigen!';
    $Hash{'QueueView'} = 'Wachtrij weergave';
    $Hash{'replace with'} = '';
    $Hash{'Reset'} = '';
    $Hash{'Salutation'} = 'Aanhef';
    $Hash{'Signature'} = 'Handtekening';
    $Hash{'Sorry'} = 'Sorry';
    $Hash{'Stats'} = 'Statistiek';
    $Hash{'Subfunction'} = 'sub-functie';
    $Hash{'submit'} = 'versturen';
    $Hash{'submit!'} = 'versturen!';
    $Hash{'Text'} = '';
    $Hash{'The recommended charset for your language is %s!'} = '';
    $Hash{'Theme'} = '';
    $Hash{'top'} = 'Bovenkant';
    $Hash{'update'} = 'verversen';
    $Hash{'update!'} = 'verversen!';
    $Hash{'User'} = 'Gebruikers';
    $Hash{'Username'} = 'Gebruikersnaam';
    $Hash{'Valid'} = 'Geldig';
    $Hash{'Warning'} = '';
    $Hash{'Welcome to OTRS'} = '';
    $Hash{'Word'} = '';
    $Hash{'wrote'} = 'schreef';
    $Hash{'yes'} = 'ja';
    $Hash{'Yes'} = 'Ja';
    $Hash{'You got new message!'} = 'Nieuw bericht binnen!';

    # Template: AAAPreferences
    $Hash{'Custom Queue'} = '';
    $Hash{'Follow up notification'} = 'Bericht bij vervolgvragen';
    $Hash{'Frontend'} = '';
    $Hash{'Mail Management'} = '';
    $Hash{'Move notification'} = 'Notitie verplaatsen';
    $Hash{'New ticket notification'} = 'Bericht bij een nieuw ticket';
    $Hash{'Other Options'} = '';
    $Hash{'Preferences updated successfully!'} = '';
    $Hash{'QueueView refresh time'} = '';
    $Hash{'Select your frontend Charset.'} = 'Karakterset voor weergave kiezen';
    $Hash{'Select your frontend language.'} = 'Kies een taal voor weergave';
    $Hash{'Select your frontend QueueView.'} = 'Wachtrij weergave kiezen';
    $Hash{'Select your frontend Theme.'} = 'weergave thema kiezen';
    $Hash{'Select your QueueView refresh time.'} = 'Verversingstijd van de wachtrijweergave kiezen';
    $Hash{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Stuur een bericht als een klant een vervolgvraag stelt en ik de eigenaar van het ticket ben.';
    $Hash{'Send me a notification if a ticket is moved into a custom queue.'} = ' Stuur mij een bericht als een bericht wordt verplaatst in een aangepaste wachtrij';
    $Hash{'Send me a notification if a ticket is unlocked by the system.'} = 'Stuur  me een bericht als een ticket wordt ontgrendeld door het systeemk.';
    $Hash{'Send me a notification if there is a new ticket in my custom queues.'} = 'Stuur mij een bericht als er een nieuw ticket in mijn aangepaste wachtrij komt.';
    $Hash{'Ticket lock timeout notification'} = 'Bericht van tijdsoverschreiding van een vergrendeling';

    # Template: AAATicket
    $Hash{'Action'} = 'Actie';
    $Hash{'Age'} = 'Leeftijd';
    $Hash{'Article'} = 'Artikel';
    $Hash{'Attachment'} = 'Bijlage';
    $Hash{'Attachments'} = '';
    $Hash{'Bcc'} = '';
    $Hash{'Bounce'} = 'Terugsturen';
    $Hash{'Cc'} = 'Cc';
    $Hash{'Close'} = 'Sluiten';
    $Hash{'closed succsessful'} = 'succesvol gesloten';
    $Hash{'closed unsuccsessful'} = 'niet succesvol gesloten';
    $Hash{'Compose'} = 'Maken';
    $Hash{'Created'} = 'Gemaakt';
    $Hash{'Createtime'} = 'Gemaakt op';
    $Hash{'eMail'} = '';
    $Hash{'email'} = 'email';
    $Hash{'email-external'} = 'Email naar extern';
    $Hash{'email-internal'} = 'Email naar intern';
    $Hash{'Forward'} = 'Doorsturen';
    $Hash{'From'} = 'Van';
    $Hash{'high'} = 'hoog';
    $Hash{'History'} = 'Geschiedenis';
    $Hash{'If it is not displayed correctly,'} = 'Als dit niet juist wordt weergegeven,';
    $Hash{'Lock'} = 'Vergrendelen';
    $Hash{'low'} = 'laag';
    $Hash{'Move'} = 'Verplaatsen';
    $Hash{'new'} = 'nieuw';
    $Hash{'normal'} = 'normaal';
    $Hash{'note-external'} = 'Notitie voor extern';
    $Hash{'note-internal'} = 'Notitie voor intern';
    $Hash{'note-report'} = 'Notitie voor rapportage';
    $Hash{'open'} = 'open';
    $Hash{'Owner'} = 'Eigenaar';
    $Hash{'Pending'} = 'Wachtend';
    $Hash{'phone'} = 'telefoon';
    $Hash{'plain'} = 'zonder opmaak';
    $Hash{'Priority'} = 'Prioriteit';
    $Hash{'Queue'} = '';
    $Hash{'removed'} = 'verwijderd';
    $Hash{'Sender'} = 'Afzender';
    $Hash{'sms'} = '';
    $Hash{'State'} = 'Status';
    $Hash{'Subject'} = 'Betreft';
    $Hash{'This is a'} = 'Dit is een';
    $Hash{'This is a HTML email. Click here to show it.'} = 'Dit is een Email in HTML-formaat. Hier klikken om te bekijken.';
    $Hash{'This message was written in a character set other than your own.'} = 'Dit bericht is geschreven in een andere karakterset dan degene die u nu heeft ingesteld.';
    $Hash{'Ticket'} = 'Ticket';
    $Hash{'To'} = 'Aan';
    $Hash{'to open it in a new window.'} = 'om deze in een nieuw venster getoond te krijgen';
    $Hash{'Unlock'} = 'Vrijgeven';
    $Hash{'very high'} = 'zeer hoog';
    $Hash{'very low'} = 'zeer laag';
    $Hash{'View'} = 'Weergave';
    $Hash{'webrequest'} = '';
    $Hash{'Zoom'} = 'Inhoud';

    # Template: AdminAutoResponseForm
    $Hash{'Add auto response'} = 'Automatisch antwoord toevoegen';
    $Hash{'Auto Response From'} = '';
    $Hash{'Auto Response Management'} = 'Automatisch-antwoorden beheer';
    $Hash{'Change auto response settings'} = 'Wijzigen van een automatisch-antwoord';
    $Hash{'Charset'} = '';
    $Hash{'Note'} = '';
    $Hash{'Response'} = 'Antwoord';
    $Hash{'to get the first 20 character of the subject'} = '';
    $Hash{'to get the first 5 lines of the email'} = '';
    $Hash{'Type'} = '';
    $Hash{'Useable options'} = 'Te gebruiken opties';

    # Template: AdminCharsetForm
    $Hash{'Add charset'} = 'Karakterset toevoegen';
    $Hash{'Change system charset setting'} = 'Andere systeem karakterset';
    $Hash{'System Charset Management'} = 'Systeem karakterset beheer';

    # Template: AdminCustomerUserForm
    $Hash{'Add customer user'} = '';
    $Hash{'Change customer user settings'} = '';
    $Hash{'Customer User Management'} = '';
    $Hash{'Customer user will be needed to to login via customer panels.'} = '';
    $Hash{'CustomerID'} = 'Klant #';
    $Hash{'Email'} = 'Email';
    $Hash{'Firstname'} = 'Voornaam';
    $Hash{'Lastname'} = 'Achternaam';
    $Hash{'Login'} = '';

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
    $Hash{'Admin-Email'} = '';
    $Hash{'Body'} = '';
    $Hash{'OTRS-Admin Info!'} = '';
    $Hash{'Recipents'} = '';

    # Template: AdminEmailSent
    $Hash{'Message sent to'} = '';

    # Template: AdminGroupForm
    $Hash{'Add group'} = 'Groep toevoegen';
    $Hash{'Change group settings'} = 'Wijzigen van een groep';
    $Hash{'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'} = 'Maak nieuwe groepen om toegangsrechten te regelen voor verschillende groepen van agenten (bijv. verkoopafdeling, supportafdeling, enz. enz.).';
    $Hash{'Group Management'} = 'Groepenbeheer';
    $Hash{'It\'s useful for ASP solutions.'} = 'Zeer bruikbaar voor ASP-oplossingen.';
    $Hash{'The admin group is to get in the admin area and the stats group to get stats area.'} = 'Leden van de admingroep mogen in het administratiegedeelte, leden van de Stats groep hebben toegang tot het statitsiekgedeelte.';

    # Template: AdminLanguageForm
    $Hash{'Add language'} = 'Taal toevoegen';
    $Hash{'Change system language setting'} = 'Andere Systeemtaal';
    $Hash{'System Language Management'} = 'Systeemtaal beheer';

    # Template: AdminNavigationBar
    $Hash{'AdminEmail'} = '';
    $Hash{'AgentFrontend'} = 'Agent weergave';
    $Hash{'Auto Response <-> Queue'} = 'Automatische antwoorden <-> Wachtrijen';
    $Hash{'Auto Responses'} = 'Automatische antwoorden';
    $Hash{'Charsets'} = '';
    $Hash{'CustomerUser'} = '';
    $Hash{'Email Addresses'} = 'Email-adressen';
    $Hash{'Groups'} = 'Groepen';
    $Hash{'Logout'} = 'Afmelden';
    $Hash{'Responses'} = 'Antwoorden';
    $Hash{'Responses <-> Queue'} = 'Antwoorden <-> Wachtrijen';
    $Hash{'Select Box'} = '';
    $Hash{'Session Management'} = 'Sessiebeheer';
    $Hash{'Status defs'} = '';
    $Hash{'User <-> Groups'} = 'Gebruikers <-> Groepen';

    # Template: AdminQueueAutoResponseForm
    $Hash{'Queue <-> Auto Response Management'} = 'Wachtrij<-> Automatisch antwoorden toekenning';

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
    $Hash{'0 = no escalation'} = '';
    $Hash{'0 = no unlock'} = '';
    $Hash{'Add queue'} = 'Wachtrij toevoegen';
    $Hash{'Change queue settings'} = 'Wachtrij wijzigen';
    $Hash{'Escalation time'} = 'Escalatietijd';
    $Hash{'Follow up Option'} = '';
    $Hash{'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.'} = '';
    $Hash{'If a ticket will not be answered in thos time, just only this ticket will be shown.'} = '';
    $Hash{'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.'} = '';
    $Hash{'Key'} = 'Sleutel';
    $Hash{'Queue Management'} = 'Wachtrijbeheer';
    $Hash{'Systemaddress'} = '';
    $Hash{'The salutation for email answers.'} = '';
    $Hash{'The signature for email answers.'} = '';
    $Hash{'Ticket lock after a follow up'} = '';
    $Hash{'Unlock timeout'} = 'Vrijgave tijdoverschrijding';
    $Hash{'Will be the sender address of this queue for email answers.'} = '';

    # Template: AdminQueueResponsesChangeForm
    $Hash{'Change %s settings'} = '';
    $Hash{'Std. Responses <-> Queue Management'} = 'Standaard antwoordenn <-> Wachtrij beheer';

    # Template: AdminQueueResponsesForm
    $Hash{'Answer'} = '';
    $Hash{'Change answer <-> queue settings'} = 'Wijzigen van antwoorden <-> wachtrij toekenning';

    # Template: AdminResponseForm
    $Hash{'A response is default text to write faster answer (with default text) to customers.'} = 'Een antworord is een standaard-tekst om sneller antwoorden te kunnen opstellen.';
    $Hash{'Add response'} = 'Antwoord toevoegen';
    $Hash{'Change response settings'} = 'Antwoord wijzigen';
    $Hash{'Don\'t forget to add a new response a queue!'} = 'Een antwoord moet ook een wachtrij toegekend krijgen!';
    $Hash{'Response Management'} = 'Antwoordenbeheer';

    # Template: AdminSalutationForm
    $Hash{'Add salutation'} = 'Aanhef toevoegen';
    $Hash{'Change salutation settings'} = 'Aanhef wijzigen';
    $Hash{'customer realname'} = 'werkelijke klantnaam';
    $Hash{'Salutation Management'} = 'Aanhef beheer';

    # Template: AdminSelectBoxForm
    $Hash{'Max Rows'} = 'Max. rijen';

    # Template: AdminSelectBoxResult
    $Hash{'Limit'} = '';
    $Hash{'Select Box Result'} = '';
    $Hash{'SQL'} = '';

    # Template: AdminSession
    $Hash{'kill all sessions'} = 'Alle sessies wissen';

    # Template: AdminSessionTable
    $Hash{'kill session'} = 'Sessie wissen';
    $Hash{'SessionID'} = '';

    # Template: AdminSignatureForm
    $Hash{'Add signature'} = 'Handtekening toevoegen';
    $Hash{'Change signature settings'} = 'Handtekening wijzigen';
    $Hash{'for agent firstname'} = 'voor voornaam van agent';
    $Hash{'for agent lastname'} = 'voor achternaam van agent';
    $Hash{'Signature Management'} = 'handtekeningbeheer';

    # Template: AdminStateForm
    $Hash{'Add state'} = 'Status toevoegen';
    $Hash{'Change system state setting'} = 'Wijzig systeemstatus';
    $Hash{'System State Management'} = 'Systeem-status beheer';

    # Template: AdminSystemAddressForm
    $Hash{'Add system address'} = 'Systeem emailadres toevoegen';
    $Hash{'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!'} = 'Alle binnenkomede emails met deze "To:" worden in de gekozen wachtrij geplaatst.';
    $Hash{'Change system address setting'} = 'Systeemadres wijzigen';
    $Hash{'Realname'} = '';
    $Hash{'System Email Addresses Management'} = 'Email systeemadressen beheer';

    # Template: AdminUserForm
    $Hash{'Add user'} = 'Gebruiker toevoegen';
    $Hash{'Change user settings'} = 'Wijzigen van gebruikersinstellingen';
    $Hash{'Don\'t forget to add a new user to groups!'} = 'Vergeet niet om groepen aan deze gebruiker toe te kennen!';
    $Hash{'User Management'} = 'Gebruikersbeheer';
    $Hash{'User will be needed to handle tickets.'} = 'Gebruikers zijn nodig om Tickets te behandelen.';

    # Template: AdminUserGroupChangeForm
    $Hash{'Change  settings'} = '';
    $Hash{'User <-> Group Management'} = 'Gebruiker <-> Groep beheer';

    # Template: AdminUserGroupForm
    $Hash{'Change user <-> group settings'} = 'Wijzigen van gebruiker <-> groep toekenning';

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
    $Hash{'A message should have a To: recipient!'} = 'Een bericht moet een Aan: ontvanger te hebben!';
    $Hash{'Bounce ticket'} = '';
    $Hash{'Bounce to'} = '';
    $Hash{'Inform sender'} = '';
    $Hash{'Next ticket state'} = 'Volgende status van het ticket';
    $Hash{'Send mail!'} = 'bericht versturen!';
    $Hash{'You need a email address (e. g. customer@example.com) in To:!'} = 'In het Aan-veld hebben we een Email-adres nodig!';
    $Hash{'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.'} = '';

    # Template: AgentClose
    $Hash{' (work units)'} = '';
    $Hash{'Close ticket'} = '';
    $Hash{'Close type'} = '';
    $Hash{'Close!'} = '';
    $Hash{'Note Text'} = '';
    $Hash{'Note type'} = 'Notitie-type';
    $Hash{'store'} = 'bewaren';
    $Hash{'Time units'} = '';

    # Template: AgentCompose
    $Hash{'A message should have a subject!'} = 'Een bericht moet een ondewerp hebben!';
    $Hash{'Attach'} = '';
    $Hash{'Compose answer for ticket'} = 'Bericht opstellen voor';
    $Hash{'Is the ticket answered'} = '';
    $Hash{'Options'} = '';
    $Hash{'Spell Check'} = '';

    # Template: AgentCustomer
    $Hash{'Back'} = 'Terug';
    $Hash{'Change customer of ticket'} = '';
    $Hash{'Set customer id of a ticket'} = 'Stel het klantnummer in van een ticket';

    # Template: AgentCustomerHistory
    $Hash{'Customer history'} = '';

    # Template: AgentCustomerHistoryTable

    # Template: AgentForward
    $Hash{'Article type'} = 'Artikel-type';
    $Hash{'Date'} = '';
    $Hash{'End forwarded message'} = '';
    $Hash{'Forward article of ticket'} = 'Artikel van ticket doorsturen';
    $Hash{'Forwarded message from'} = '';
    $Hash{'Reply-To'} = '';

    # Template: AgentHistoryForm
    $Hash{'History of'} = '';

    # Template: AgentMailboxTicket
    $Hash{'Add Note'} = 'Notitie toevoegen';

    # Template: AgentNavigationBar
    $Hash{'FAQ'} = '';
    $Hash{'Locked tickets'} = 'Eigen tickets';
    $Hash{'new message'} = 'Nieuw bericht';
    $Hash{'PhoneView'} = 'Telefoon weergave';
    $Hash{'Preferences'} = 'Voorkeuren';
    $Hash{'Utilities'} = 'Tools';

    # Template: AgentNote
    $Hash{'Add note to ticket'} = 'Notitie toevoegen aan ticket';
    $Hash{'Note!'} = '';

    # Template: AgentOwner
    $Hash{'Change owner of ticket'} = '';
    $Hash{'Message for new Owner'} = '';
    $Hash{'New user'} = '';

    # Template: AgentPhone
    $Hash{'Customer called'} = '';
    $Hash{'Phone call'} = 'Telefoongesprek';
    $Hash{'Phone call at %s'} = '';

    # Template: AgentPhoneNew
    $Hash{'A message should have a From: recipient!'} = 'Een bericht moet een Van: afzender hebben!';
    $Hash{'new ticket'} = 'nieuw ticket';
    $Hash{'New ticket via call.'} = '';
    $Hash{'You need a email address (e. g. customer@example.com) in From:!'} = 'In het Van-veld hebben we een Email-adres nodig!';

    # Template: AgentPlain
    $Hash{'ArticleID'} = '';
    $Hash{'Plain'} = 'zonder opmaak';
    $Hash{'TicketID'} = '';

    # Template: AgentPreferencesCustomQueue
    $Hash{'Select your custom queues'} = 'Voorkeurs wachtrijen kiezen';

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
    $Hash{'Change Password'} = 'Wachtwoord wijzigen';
    $Hash{'New password'} = 'Nieuw wachtwoord';
    $Hash{'New password again'} = 'Nieuw wachtwoord herhalen';

    # Template: AgentPriority
    $Hash{'Change priority of ticket'} = 'Prioriteit wijzigen voor ticket';
    $Hash{'New state'} = '';

    # Template: AgentSpelling
    $Hash{'Apply these changes'} = '';
    $Hash{'Discard all changes and return to the compose screen'} = '';
    $Hash{'Return to the compose screen'} = '';
    $Hash{'Spell Checker'} = '';
    $Hash{'spelling error(s)'} = '';
    $Hash{'The message being composed has been closed.  Exiting.'} = '';
    $Hash{'This window must be called from compose window'} = '';

    # Template: AgentStatusView
    $Hash{'D'} = '';
    $Hash{'sort downward'} = '';
    $Hash{'sort upward'} = '';
    $Hash{'Ticket limit:'} = '';
    $Hash{'Ticket Status'} = '';
    $Hash{'U'} = '';

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
    $Hash{'Ticket locked!'} = 'Ticket vergrendeld!';
    $Hash{'unlock'} = 'vrijgeven';

    # Template: AgentUtilSearchByCustomerID
    $Hash{'Customer history search'} = 'zoeken in klantgeschiednis';
    $Hash{'Customer history search (e. g. "ID342425").'} = 'Klantgeschiedenis zoeken (bijv. "ID342425").';
    $Hash{'No * possible!'} = 'Geen * mogelijk!';

    # Template: AgentUtilSearchByText
    $Hash{'Article free text'} = '';
    $Hash{'Fulltext search'} = 'Zoeken in alle tekst';
    $Hash{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Zoeken in tekst (bijv. "Mar*in" of "Boe*" of "Martin+hallo")';
    $Hash{'Search in'} = '';
    $Hash{'Ticket free text'} = '';

    # Template: AgentUtilSearchByTicketNumber
    $Hash{'search'} = 'zoeken';
    $Hash{'search (e. g. 10*5155 or 105658*)'} = 'zoeken (bijv. 10*5155 of 105658*)';

    # Template: AgentUtilSearchNavBar
    $Hash{'Results'} = '';
    $Hash{'Site'} = '';
    $Hash{'Total hits'} = 'Totaal gevonden';

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
    $Hash{'All open tickets'} = '';
    $Hash{'open tickets'} = '';
    $Hash{'Provides an overview of all'} = '';
    $Hash{'So you see what is going on in your system.'} = '';

    # Template: CustomerCreateAccount
    $Hash{'Create'} = '';
    $Hash{'Create Account'} = '';

    # Template: CustomerError
    $Hash{'Backend'} = '';
    $Hash{'BackendMessage'} = '';
    $Hash{'Click here to report a bug!'} = 'Klik hier om een fout te rapporteren';
    $Hash{'Handle'} = '';

    # Template: CustomerFooter
    $Hash{'Powered by'} = '';

    # Template: CustomerHeader

    # Template: CustomerLogin

    # Template: CustomerLostPassword
    $Hash{'Lost your password?'} = '';
    $Hash{'Request new password'} = '';

    # Template: CustomerMessage
    $Hash{'Follow up'} = '';

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
    $Hash{'Create new Ticket'} = '';
    $Hash{'My Tickets'} = 'Mijn tickets';
    $Hash{'New Ticket'} = 'Nieuw ticket';
    $Hash{'Ticket-Overview'} = '';
    $Hash{'Welcome %s'} = 'Welkom %s';

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom
    $Hash{'Accounted time'} = '';

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header
    $Hash{'Home'} = '';

    # Template: InstallerStart
    $Hash{'next step'} = '';

    # Template: InstallerSystem

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
    $Hash{'No Permission'} = 'Geen rechten';

    # Template: Notify
    $Hash{'Info'} = '';

    # Template: QueueView
    $Hash{'All tickets'} = 'Alle tickets';
    $Hash{'Queues'} = 'Wachtrij';
    $Hash{'Show all'} = 'Alle getoond';
    $Hash{'Ticket available'} = 'Ticket beschikbaar';
    $Hash{'tickets'} = 'tickets';
    $Hash{'Tickets shown'} = 'Tickets getoond';

    # Template: SystemStats
    $Hash{'Graphs'} = 'Diagrammen';
    $Hash{'Tickets'} = '';

    # Template: Test
    $Hash{'OTRS Test Page'} = '';

    # Template: TicketEscalation
    $Hash{'Ticket escalation!'} = 'Ticket escalatie!';

    # Template: TicketView
    $Hash{'Change queue'} = 'Wachtrij wisselen';
    $Hash{'Compose Answer'} = 'Antwoord opstellen';
    $Hash{'Contact customer'} = 'Klant contacteren';
    $Hash{'phone call'} = 'telefoongesprek';
    $Hash{'Time till escalation'} = 'Tijd tot escalatie';

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
    $Hash{'(Click here to add a group)'} = '(Hier klikken - groep toevoegen)';
    $Hash{'(Click here to add a queue)'} = '(Hier klikken - Wachtrij toevoegen)';
    $Hash{'(Click here to add a response)'} = '(Hier klikken - Antwoord toevoegen)';
    $Hash{'(Click here to add a salutation)'} = '(Hier klikken - Aanhef toevoegen)';
    $Hash{'(Click here to add a signature)'} = '(Hier klikken - handtekening toevoegen)';
    $Hash{'(Click here to add a system email address)'} = '(Hier klikken - systeem-emailadres toevoegen)';
    $Hash{'(Click here to add a user)'} = '(Hier klikken - Gebruiker toevoegen)';
    $Hash{'(Click here to add an auto response)'} = '(Hier klikken - Automatisch antwoord toevoegen)';
    $Hash{'(Click here to add charset)'} = '(Hier klikken - karakterset toevoegen';
    $Hash{'(Click here to add language)'} = '(Hier klikken - taal toevoegen)';
    $Hash{'(Click here to add state)'} = '(Hier klikken - Status toevoegen)';
    $Hash{'Update auto response'} = 'Automatisch antwoord aktualiseren';
    $Hash{'Update charset'} = 'Karakterset actualiseren';
    $Hash{'Update group'} = 'Groep aktualiseren';
    $Hash{'Update language'} = 'Taal actualiseren';
    $Hash{'Update queue'} = 'Wachtrij actualiseren';
    $Hash{'Update response'} = 'Antwoorden actualiseren';
    $Hash{'Update salutation'} = 'Aanhef actualiseren';
    $Hash{'Update signature'} = 'Handtekening akcualiseren';
    $Hash{'Update state'} = 'Status actualiseren';
    $Hash{'Update system address'} = 'Systeem emailadres actualiseren';
    $Hash{'Update user'} = 'Gebruiker actualiseren';
    $Hash{'You have to be in the admin group!'} = 'U moet hiervoor in de admin-groep staan!';
    $Hash{'You have to be in the stats group!'} = 'U moet hiervoor in de statisiek groep staan!';
    $Hash{'auto responses set'} = 'Automatische antwoorden ingesteld';

    $Self->{Translation} = \%Hash;

}
# --
1;
