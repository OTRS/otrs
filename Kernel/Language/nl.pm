# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002 Fred van Dijk <fvandijk at marklin.nl>
# --
# $Id: nl.pm,v 1.10 2003-02-09 10:31:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::nl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Mon Feb  3 23:33:46 2003 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minuten',
      ' 5 minutes' => ' 5 minuten',
      ' 7 minutes' => ' 7 minuten',
      '10 minutes' => '10 minuten',
      '15 minutes' => '15 minuten',
      'AddLink' => 'Link toevoegen',
      'AdminArea' => 'Administratiegedeelte',
      'all' => 'alle',
      'All' => 'Alle',
      'Attention' => 'Let op',
      'Bug Report' => 'Foutrapport',
      'Cancel' => '',
      'Change' => 'Veranderen',
      'change' => 'veranderen',
      'change!' => 'veranderen!',
      'click here' => 'klik hier',
      'Comment' => 'Commentaar',
      'Customer' => 'Klant',
      'Customer Info' => 'Klanten info',
      'day' => 'dag',
      'days' => 'dagen',
      'description' => 'omschrijving',
      'Description' => 'Omschrijving',
      'Dispatching by email To: field.' => '',
      'Dispatching by selected Queue.' => '',
      'Don\'t work with UserID 1 (System account)! Create new users!' => '',
      'Done' => '',
      'end' => 'Onderkant',
      'Error' => 'Fout',
      'Example' => 'Voorbeeld',
      'Examples' => 'Voorbeelden',
      'Facility' => '',
      'Feature not acitv!' => '',
      'go' => 'start',
      'go!' => 'start!',
      'Group' => 'Groep',
      'Hit' => 'Gevonden',
      'Hits' => '',
      'hour' => 'uur',
      'hours' => 'uren',
      'Ignore' => '',
      'invalid' => '',
      'Invalid SessionID!' => '',
      'Language' => 'Taal',
      'Languages' => 'Talen',
      'Line' => 'Regel',
      'Lite' => '',
      'Login failed! Your username or password was entered incorrectly.' => '',
      'Logout successful. Thank you for using OTRS!' => 'Afgemeld! Wij danken u voor het gebruikeen van OTRS!',
      'Message' => 'Bericht',
      'minute' => 'minuut',
      'minutes' => 'minuten',
      'Module' => 'Module',
      'Modulefile' => 'Modulebestand',
      'Name' => 'Naam',
      'New message' => 'Nieuw bericht',
      'New message!' => 'Nieuw bericht!',
      'no' => 'nee',
      'No' => 'Nee',
      'No suggestions' => '',
      'none' => 'geen',
      'none - answered' => 'geen - beantwoord',
      'none!' => 'niet ingevoerd!',
      'off' => 'uit',
      'Off' => 'Uit',
      'on' => 'aan',
      'On' => 'Aan',
      'Password' => 'Wachtwoord',
      'Pending till' => '',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'A.u.b. geëscaleerde tickets beantwoorden om terug tekomen in de normale wachtwij',
      'Please contact your admin' => '',
      'please do not edit!' => 'A.u.b. niet wijzigen!',
      'possible' => '',
      'QueueView' => 'Wachtrij weergave',
      'reject' => '',
      'replace with' => '',
      'Reset' => '',
      'Salutation' => 'Aanhef',
      'Signature' => 'Handtekening',
      'Sorry' => 'Sorry',
      'Stats' => 'Statistiek',
      'Subfunction' => 'sub-functie',
      'submit' => 'versturen',
      'submit!' => 'versturen!',
      'Take this User' => '',
      'Text' => '',
      'The recommended charset for your language is %s!' => '',
      'Theme' => '',
      'There is no account with that login name.' => '',
      'Timeover' => '',
      'top' => 'Bovenkant',
      'update' => 'verversen',
      'update!' => 'verversen!',
      'User' => 'Gebruikers',
      'Username' => 'Gebruikersnaam',
      'Valid' => 'Geldig',
      'Warning' => '',
      'Welcome to OTRS' => '',
      'Word' => '',
      'wrote' => 'schreef',
      'Yes' => 'Ja',
      'yes' => 'ja',
      'You got new message!' => '',
      'You have %s new message(s)!' => '',
      'You have %s reminder ticket(s)!' => '',

    # Template: AAAMonth
      'Apr' => '',
      'Aug' => '',
      'Dec' => '',
      'Feb' => '',
      'Jan' => '',
      'Jul' => '',
      'Jun' => '',
      'Mar' => '',
      'May' => '',
      'Nov' => '',
      'Oct' => '',
      'Sep' => '',

    # Template: AAAPreferences
      'Custom Queue' => '',
      'Follow up notification' => 'Bericht bij vervolgvragen',
      'Frontend' => '',
      'Mail Management' => '',
      'Move notification' => 'Notitie verplaatsen',
      'New ticket notification' => 'Bericht bij een nieuw ticket',
      'Other Options' => '',
      'Preferences updated successfully!' => '',
      'QueueView refresh time' => '',
      'Select your frontend Charset.' => 'Karakterset voor weergave kiezen',
      'Select your frontend language.' => 'Kies een taal voor weergave',
      'Select your frontend QueueView.' => 'Wachtrij weergave kiezen',
      'Select your frontend Theme.' => 'weergave thema kiezen',
      'Select your QueueView refresh time.' => 'Verversingstijd van de wachtrijweergave kiezen',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Stuur een bericht als een klant een vervolgvraag stelt en ik de eigenaar van het ticket ben.',
      'Send me a notification if a ticket is moved into a custom queue.' => ' Stuur mij een bericht als een bericht wordt verplaatst in een aangepaste wachtrij',
      'Send me a notification if a ticket is unlocked by the system.' => 'Stuur  me een bericht als een ticket wordt ontgrendeld door het systeemk.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Stuur mij een bericht als er een nieuw ticket in mijn aangepaste wachtrij komt.',
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
      'Attachments' => '',
      'Bcc' => '',
      'Bounce' => 'Terugsturen',
      'Cc' => 'Cc',
      'Close' => 'Sluiten',
      'closed successful' => 'succesvol gesloten',
      'closed unsuccessful' => 'niet succesvol gesloten',
      'Compose' => 'Maken',
      'Created' => 'Gemaakt',
      'Createtime' => 'Gemaakt op',
      'email' => 'email',
      'eMail' => '',
      'email-external' => 'Email naar extern',
      'email-internal' => 'Email naar intern',
      'Forward' => 'Doorsturen',
      'From' => 'Van',
      'high' => 'hoog',
      'History' => 'Geschiedenis',
      'If it is not displayed correctly,' => 'Als dit niet juist wordt weergegeven,',
      'Lock' => 'Vergrendelen',
      'low' => 'laag',
      'Move' => 'Verplaatsen',
      'new' => 'nieuw',
      'normal' => 'normaal',
      'note-external' => 'Notitie voor extern',
      'note-internal' => 'Notitie voor intern',
      'note-report' => 'Notitie voor rapportage',
      'open' => 'open',
      'Owner' => 'Eigenaar',
      'Pending' => 'Wachtend',
      'pending auto close+' => '',
      'pending auto close-' => '',
      'pending reminder' => '',
      'phone' => 'telefoon',
      'plain' => 'zonder opmaak',
      'Priority' => 'Prioriteit',
      'Queue' => '',
      'removed' => 'verwijderd',
      'Sender' => 'Afzender',
      'sms' => '',
      'State' => 'Status',
      'Subject' => 'Betreft',
      'This is a' => 'Dit is een',
      'This is a HTML email. Click here to show it.' => 'Dit is een Email in HTML-formaat. Hier klikken om te bekijken.',
      'This message was written in a character set other than your own.' => 'Dit bericht is geschreven in een andere karakterset dan degene die u nu heeft ingesteld.',
      'Ticket' => 'Ticket',
      'To' => 'Aan',
      'to open it in a new window.' => 'om deze in een nieuw venster getoond te krijgen',
      'Unlock' => 'Vrijgeven',
      'very high' => 'zeer hoog',
      'very low' => 'zeer laag',
      'View' => 'Weergave',
      'webrequest' => '',
      'Zoom' => 'Inhoud',

    # Template: AAAWeekDay
      'Fri' => '',
      'Mon' => '',
      'Sat' => '',
      'Sun' => '',
      'Thu' => '',
      'Tue' => '',
      'Wed' => '',

    # Template: AdminAttachmentForm
      'Add attachment' => '',
      'Attachment Management' => '',
      'Change attachment settings' => '',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Automatisch antwoord toevoegen',
      'Auto Response From' => '',
      'Auto Response Management' => 'Automatisch-antwoorden beheer',
      'Change auto response settings' => 'Wijzigen van een automatisch-antwoord',
      'Charset' => '',
      'Note' => '',
      'Response' => 'Antwoord',
      'to get the first 20 character of the subject' => '',
      'to get the first 5 lines of the email' => '',
      'to get the from line of the email' => '',
      'to get the realname of the sender (if given)' => '',
      'to get the ticket id of the ticket' => '',
      'to get the ticket number of the ticket' => '',
      'Type' => '',
      'Useable options' => 'Te gebruiken opties',

    # Template: AdminCharsetForm
      'Add charset' => 'Karakterset toevoegen',
      'Change system charset setting' => 'Andere systeem karakterset',
      'System Charset Management' => 'Systeem karakterset beheer',

    # Template: AdminCustomerUserForm
      'Add customer user' => '',
      'Change customer user settings' => '',
      'Customer User Management' => '',
      'Customer user will be needed to to login via customer panels.' => '',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => '',
      'Body' => '',
      'OTRS-Admin Info!' => '',
      'Recipents' => '',

    # Template: AdminEmailSent
      'Message sent to' => '',

    # Template: AdminGroupForm
      'Add group' => 'Groep toevoegen',
      'Change group settings' => 'Wijzigen van een groep',
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Maak nieuwe groepen om toegangsrechten te regelen voor verschillende groepen van agenten (bijv. verkoopafdeling, supportafdeling, enz. enz.).',
      'Group Management' => 'Groepenbeheer',
      'It\'s useful for ASP solutions.' => 'Zeer bruikbaar voor ASP-oplossingen.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Leden van de admingroep mogen in het administratiegedeelte, leden van de Stats groep hebben toegang tot het statitsiekgedeelte.',

    # Template: AdminLanguageForm
      'Add language' => 'Taal toevoegen',
      'Change system language setting' => 'Andere Systeemtaal',
      'System Language Management' => 'Systeemtaal beheer',

    # Template: AdminLog
      'System Log' => '',

    # Template: AdminNavigationBar
      'AdminEmail' => '',
      'AgentFrontend' => 'Agent weergave',
      'Auto Response <-> Queue' => 'Automatische antwoorden <-> Wachtrijen',
      'Auto Responses' => 'Automatische antwoorden',
      'Charsets' => '',
      'Customer User' => '',
      'Email Addresses' => 'Email-adressen',
      'Groups' => 'Groepen',
      'Logout' => 'Afmelden',
      'Misc' => '',
      'POP3 Account' => '',
      'Responses' => 'Antwoorden',
      'Responses <-> Queue' => 'Antwoorden <-> Wachtrijen',
      'Select Box' => '',
      'Session Management' => 'Sessiebeheer',
      'Status defs' => '',
      'System' => '',
      'User <-> Groups' => 'Gebruikers <-> Groepen',

    # Template: AdminPOP3Form
      'Add POP3 Account' => '',
      'All incoming emails with one account will be dispatched in the selected queue!' => '',
      'Change POP3 Account setting' => '',
      'Dispatching' => '',
      'Host' => '',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => '',
      'Login' => '',
      'POP3 Account Management' => '',
      'Trusted' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Wachtrij<-> Automatisch antwoorden toekenning',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '',
      '0 = no unlock' => '',
      'Add queue' => 'Wachtrij toevoegen',
      'Change queue settings' => 'Wachtrij wijzigen',
      'Escalation time' => 'Escalatietijd',
      'Follow up Option' => '',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => '',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => '',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => '',
      'Key' => 'Sleutel',
      'Queue Management' => 'Wachtrijbeheer',
      'Systemaddress' => '',
      'The salutation for email answers.' => '',
      'The signature for email answers.' => '',
      'Ticket lock after a follow up' => '',
      'Unlock timeout' => 'Vrijgave tijdoverschrijding',
      'Will be the sender address of this queue for email answers.' => '',

    # Template: AdminQueueResponsesChangeForm
      'Change %s settings' => '',
      'Std. Responses <-> Queue Management' => 'Standaard antwoordenn <-> Wachtrij beheer',

    # Template: AdminQueueResponsesForm
      'Answer' => '',
      'Change answer <-> queue settings' => 'Wijzigen van antwoorden <-> wachtrij toekenning',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => '',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => '',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Een antworord is een standaard-tekst om sneller antwoorden te kunnen opstellen.',
      'Add response' => 'Antwoord toevoegen',
      'Change response settings' => 'Antwoord wijzigen',
      'Don\'t forget to add a new response a queue!' => 'Een antwoord moet ook een wachtrij toegekend krijgen!',
      'Response Management' => 'Antwoordenbeheer',

    # Template: AdminSalutationForm
      'Add salutation' => 'Aanhef toevoegen',
      'Change salutation settings' => 'Aanhef wijzigen',
      'customer realname' => 'werkelijke klantnaam',
      'Salutation Management' => 'Aanhef beheer',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max. rijen',

    # Template: AdminSelectBoxResult
      'Limit' => '',
      'Select Box Result' => '',
      'SQL' => '',

    # Template: AdminSession
      'kill all sessions' => 'Alle sessies wissen',

    # Template: AdminSessionTable
      'kill session' => 'Sessie wissen',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Add signature' => 'Handtekening toevoegen',
      'Change signature settings' => 'Handtekening wijzigen',
      'for agent firstname' => 'voor voornaam van agent',
      'for agent lastname' => 'voor achternaam van agent',
      'Signature Management' => 'handtekeningbeheer',

    # Template: AdminStateForm
      'Add state' => 'Status toevoegen',
      'Change system state setting' => 'Wijzig systeemstatus',
      'System State Management' => 'Systeem-status beheer',

    # Template: AdminSystemAddressForm
      'Add system address' => 'Systeem emailadres toevoegen',
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle binnenkomede emails met deze "To:" worden in de gekozen wachtrij geplaatst.',
      'Change system address setting' => 'Systeemadres wijzigen',
      'Email' => 'Email',
      'Realname' => '',
      'System Email Addresses Management' => 'Email systeemadressen beheer',

    # Template: AdminUserForm
      'Add user' => 'Gebruiker toevoegen',
      'Change user settings' => 'Wijzigen van gebruikersinstellingen',
      'Don\'t forget to add a new user to groups!' => 'Vergeet niet om groepen aan deze gebruiker toe te kennen!',
      'Firstname' => 'Voornaam',
      'Lastname' => 'Achternaam',
      'User Management' => 'Gebruikersbeheer',
      'User will be needed to handle tickets.' => 'Gebruikers zijn nodig om Tickets te behandelen.',

    # Template: AdminUserGroupChangeForm
      'Change  settings' => '',
      'User <-> Group Management' => 'Gebruiker <-> Groep beheer',

    # Template: AdminUserGroupForm
      'Change user <-> group settings' => 'Wijzigen van gebruiker <-> groep toekenning',

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Een bericht moet een Aan: ontvanger te hebben!',
      'Bounce ticket' => '',
      'Bounce to' => '',
      'Inform sender' => '',
      'Next ticket state' => 'Volgende status van het ticket',
      'Send mail!' => 'bericht versturen!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'In het Aan-veld hebben we een Email-adres nodig!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further inforamtions.' => '',

    # Template: AgentClose
      ' (work units)' => '',
      'Close ticket' => '',
      'Close type' => '',
      'Close!' => '',
      'Note Text' => '',
      'Note type' => 'Notitie-type',
      'store' => 'bewaren',
      'Time units' => '',

    # Template: AgentCompose
      'A message should have a subject!' => 'Een bericht moet een ondewerp hebben!',
      'Attach' => '',
      'Compose answer for ticket' => 'Bericht opstellen voor',
      'for pending* states' => '',
      'Is the ticket answered' => '',
      'Options' => '',
      'Pending Date' => '',
      'Spell Check' => '',

    # Template: AgentCustomer
      'Back' => 'Terug',
      'Change customer of ticket' => '',
      'Set customer id of a ticket' => 'Stel het klantnummer in van een ticket',

    # Template: AgentCustomerHistory
      'Customer history' => '',

    # Template: AgentCustomerHistoryTable

    # Template: AgentCustomerView
      'Customer Data' => '',

    # Template: AgentForward
      'Article type' => 'Artikel-type',
      'Date' => '',
      'End forwarded message' => '',
      'Forward article of ticket' => 'Artikel van ticket doorsturen',
      'Forwarded message from' => '',
      'Reply-To' => '',

    # Template: AgentHistoryForm
      'History of' => '',

    # Template: AgentMailboxNavBar
      'All messages' => '',
      'CustomerID' => 'Klant #',
      'down' => '',
      'Mailbox' => '',
      'New' => '',
      'New messages' => '',
      'Open' => '',
      'Open messages' => '',
      'Order' => '',
      'Pending messages' => '',
      'Reminder' => '',
      'Reminder messages' => '',
      'Sort by' => '',
      'Tickets' => '',
      'up' => '',

    # Template: AgentMailboxTicket
      'Add Note' => 'Notitie toevoegen',

    # Template: AgentNavigationBar
      'FAQ' => '',
      'Locked tickets' => 'Eigen tickets',
      'new message' => 'Nieuw bericht',
      'PhoneView' => 'Telefoon weergave',
      'Preferences' => 'Voorkeuren',
      'Utilities' => 'Tools',

    # Template: AgentNote
      'Add note to ticket' => 'Notitie toevoegen aan ticket',
      'Note!' => '',

    # Template: AgentOwner
      'Change owner of ticket' => '',
      'Message for new Owner' => '',
      'New user' => '',

    # Template: AgentPending
      'Pending date' => '',
      'Pending type' => '',
      'Set Pending' => '',

    # Template: AgentPhone
      'Customer called' => '',
      'Phone call' => 'Telefoongesprek',
      'Phone call at %s' => '',

    # Template: AgentPhoneNew
      'Search Customer' => 'Klanten zoeken',
      'new ticket' => 'nieuw ticket',

    # Template: AgentPlain
      'ArticleID' => '',
      'Plain' => 'zonder opmaak',
      'TicketID' => '',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Voorkeurs wachtrijen kiezen',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Wachtwoord wijzigen',
      'New password' => 'Nieuw wachtwoord',
      'New password again' => 'Nieuw wachtwoord herhalen',

    # Template: AgentPriority
      'Change priority of ticket' => 'Prioriteit wijzigen voor ticket',
      'New state' => '',

    # Template: AgentSpelling
      'Apply these changes' => '',
      'Discard all changes and return to the compose screen' => '',
      'Return to the compose screen' => '',
      'Spell Checker' => '',
      'spelling error(s)' => '',
      'The message being composed has been closed.  Exiting.' => '',
      'This window must be called from compose window' => '',

    # Template: AgentStatusView
      'D' => '',
      'sort downward' => '',
      'sort upward' => '',
      'Ticket limit:' => '',
      'Ticket Status' => '',
      'U' => '',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket vergrendeld!',
      'unlock' => 'vrijgeven',

    # Template: AgentTicketPrint
      'by' => '',

    # Template: AgentTicketPrintHeader
      'Accounted time' => '',
      'Escalation in' => '',
      'printed by' => '',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'zoeken in klantgeschiednis',
      'Customer history search (e. g. "ID342425").' => 'Klantgeschiedenis zoeken (bijv. "ID342425").',
      'No * possible!' => 'Geen * mogelijk!',

    # Template: AgentUtilSearchByText
      'Article free text' => '',
      'Fulltext search' => 'Zoeken in alle tekst',
      'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")' => 'Zoeken in tekst (bijv. "Mar*in" of "Boe*" of "Martin+hallo")',
      'Search in' => '',
      'Ticket free text' => '',
      'With State' => '',

    # Template: AgentUtilSearchByTicketNumber
      'search' => 'zoeken',
      'search (e. g. 10*5155 or 105658*)' => 'zoeken (bijv. 10*5155 of 105658*)',

    # Template: AgentUtilSearchNavBar
      'Results' => '',
      'Site' => '',
      'Total hits' => 'Totaal gevonden',

    # Template: AgentUtilSearchResult

    # Template: AgentUtilTicketStatus
      'All open tickets' => '',
      'open tickets' => '',
      'Provides an overview of all' => '',
      'So you see what is going on in your system.' => '',

    # Template: CustomerCreateAccount
      'Create' => '',
      'Create Account' => '',

    # Template: CustomerError
      'Backend' => '',
      'BackendMessage' => '',
      'Click here to report a bug!' => 'Klik hier om een fout te rapporteren',
      'Handle' => '',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => '',
      'Home' => '',
      'Online-Support' => '',
      'Products' => '',
      'Support' => '',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => '',
      'Request new password' => '',

    # Template: CustomerMessage
      'Follow up' => '',

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => '',
      'My Tickets' => 'Mijn tickets',
      'New Ticket' => 'Nieuw ticket',
      'Ticket-Overview' => '',
      'Welcome %s' => 'Welkom %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'of' => '',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error

    # Template: Footer

    # Template: Header

    # Template: InstallerStart
      'next step' => '',

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
      'Info' => '',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'Print' => '',

    # Template: QueueView
      'All tickets' => 'Alle tickets',
      'Queues' => 'Wachtrij',
      'Show all' => 'Alle getoond',
      'Ticket available' => 'Ticket beschikbaar',
      'tickets' => 'tickets',
      'Tickets shown' => 'Tickets getoond',

    # Template: SystemStats
      'Graphs' => 'Diagrammen',

    # Template: Test
      'OTRS Test Page' => '',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ticket escalatie!',

    # Template: TicketView
      'Change queue' => 'Wachtrij wisselen',
      'Compose Answer' => 'Antwoord opstellen',
      'Contact customer' => 'Klant contacteren',
      'phone call' => 'telefoongesprek',

    # Template: TicketViewLite

    # Template: TicketZoom

    # Template: TicketZoomNote

    # Template: TicketZoomSystem

    # Template: Warning

    # Misc
      '(Click here to add a group)' => '(Hier klikken - groep toevoegen)',
      '(Click here to add a queue)' => '(Hier klikken - Wachtrij toevoegen)',
      '(Click here to add a response)' => '(Hier klikken - Antwoord toevoegen)',
      '(Click here to add a salutation)' => '(Hier klikken - Aanhef toevoegen)',
      '(Click here to add a signature)' => '(Hier klikken - handtekening toevoegen)',
      '(Click here to add a system email address)' => '(Hier klikken - systeem-emailadres toevoegen)',
      '(Click here to add a user)' => '(Hier klikken - Gebruiker toevoegen)',
      '(Click here to add an auto response)' => '(Hier klikken - Automatisch antwoord toevoegen)',
      '(Click here to add charset)' => '(Hier klikken - karakterset toevoegen',
      '(Click here to add language)' => '(Hier klikken - taal toevoegen)',
      '(Click here to add state)' => '(Hier klikken - Status toevoegen)',
      'A message should have a From: recipient!' => 'Een bericht moet een Van: afzender hebben!',
      'New ticket via call.' => '',
      'Time till escalation' => 'Tijd tot escalatie',
      'Update auto response' => 'Automatisch antwoord aktualiseren',
      'Update charset' => 'Karakterset actualiseren',
      'Update group' => 'Groep aktualiseren',
      'Update language' => 'Taal actualiseren',
      'Update queue' => 'Wachtrij actualiseren',
      'Update response' => 'Antwoorden actualiseren',
      'Update salutation' => 'Aanhef actualiseren',
      'Update signature' => 'Handtekening akcualiseren',
      'Update state' => 'Status actualiseren',
      'Update system address' => 'Systeem emailadres actualiseren',
      'Update user' => 'Gebruiker actualiseren',
      'You have to be in the admin group!' => 'U moet hiervoor in de admin-groep staan!',
      'You have to be in the stats group!' => 'U moet hiervoor in de statisiek groep staan!',
      'You need a email address (e. g. customer@example.com) in From:!' => 'In het Van-veld hebben we een Email-adres nodig!',
      'auto responses set' => 'Automatische antwoorden ingesteld',
    );

    # $$STOP$$

    $Self->{Translation} = \%Hash;
}
# --
1;
