# --
# Kernel/Language/nl.pm - provides nl language translation
# Copyright (C) 2002-2003 Fred van Dijk <fvandijk at marklin.nl>
# Maintenance responsibility taken over by Hans Bakker (h.bakker@a-net.nl)
# Copyright (C) 2003 A-NeT Internet Services bv
# Copyright (C) 2004 Martijn Lohmeijer (martijn.lohmeijer 'at' sogeti.nl)
# --
# $Id: nl.pm,v 1.25 2005-02-15 10:35:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

###########################################################################
#                                                                         #
# 14-05-2004                                                              #
#                                                                         #
# This update is by: Martijn Lohmeijer (martijn.lohmeijer 'at' sogeti.nl) #
# Based on the CVS de.pm and nl.pm from 14-05-2004                        #
#                                                                         #
# Below you will find a list of specifically not translated words.        #
# Reason for not translating them is the frequent use of these terms in   #
# either a. our daily practice at the department 'Interne Automatisering' #
# of Sogeti Nederland B.V. or b. common Dutch speak in which a lot of     #
# modern English terms are not translated.                                #
#                                                                         #
###########################################################################

# Not translated terms / words:

# Agent Area --> it's clear what that does
# Bounce
# Contract
# Directory
# History::Lock --> "Ticket locked" works for me
# History::Unlock --> see above
# lock / unlock --> see above
# Online Agent
# Type
# Upload

package Kernel::Language::nl;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.25 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*\$/$1/;
# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Tue Feb 10 01:08:01 2004 by 

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D.%M.%Y %T';
    $Self->{DateFormatShort} = '%D.%M.%Y';
    $Self->{DateFormatLong} = '%A %D %B %T %Y';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minuten',
      ' 5 minutes' => ' 5 minuten',
      ' 7 minutes' => ' 7 minuten',
      '(Click here to add)' => '(Klik hier om toe te voegen)',
      '10 minutes' => '10 minuten',
      '15 minutes' => '15 minuten',
      'Added User "%s"' => 'Gebruiker "%s" toegevoegd.',
      'AddLink' => 'Link toevoegen',
      'Admin-Area' => 'Admin',
      'agent' => 'agent',
      'Agent-Area' => '',
      'all' => 'alle',
      'All' => 'Alle',
      'Attention' => 'Let op',
      'before' => 'voor',
      'Bug Report' => 'Foutrapport',
      'Calendar' => 'Kalender',
      'Cancel' => 'Annuleren',
      'change' => 'wijzigen',
      'Change' => 'Wijzigen',
      'change!' => 'wijzigen!',
      'click here' => 'klik hier',
      'Comment' => 'Commentaar',
      'Contract' => '',
      'Customer' => 'Klant',
      'customer' => 'klant',
      'Customer Info' => 'Klant informatie',
      'day' => 'dag',
      'day(s)' => 'dag(en)',
      'days' => 'dagen',
      'description' => 'omschrijving',
      'Description' => 'Omschrijving',
      'Directory' => '',
      'Dispatching by email To: field.' => 'Versturen per email Aan: veld.',
      'Dispatching by selected Queue.' => 'Versturen per geselecteerde wachtrij',
      'Don\'t show closed Tickets' => 'Gesloten tickets niet tonen',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Werk niet met User# 1 (systeem account)! Maak nieuwe gebruikers aan',
      'Done' => 'Klaar',
      'end' => 'Onderkant',
      'Error' => 'Fout',
      'Example' => 'Voorbeeld',
      'Examples' => 'Voorbeelden',
      'Facility' => 'Facility',
      'FAQ-Area' => '',
      'Feature not active!' => 'Functie niet actief!',
      'go' => 'start',
      'go!' => 'start!',
      'Group' => 'Groep',
      'History::AddNote' => 'Notitie toegevoegd (%s)',
      'History::Bounce' => 'Bounced naar "%s".',
      'History::CustomerUpdate' => 'Bijgewerkt: %s',
      'History::EmailAgent' => 'Mail verzonden aan klant.',
      'History::EmailCustomer' => 'Email toegevoegd. %s',
      'History::FollowUp' => 'FollowUp voor [%s]. %s',
      'History::Forward' => 'Doorgestuurd aan "%s".',
      'History::Lock' => '',
      'History::LoopProtection' => 'Loop-Protection! Geen auto-reply verstuurd aan "%s".',
      'History::Misc' => '%s',
      'History::Move' => 'Ticket verplaatst naar wachtrij "%s" (%s) van wachtrij "%s" (%s).',
      'History::NewTicket' => 'Nieuw ticket [%s] aangemaakt (Q=%s;P=%s;S=%s).',
      'History::OwnerUpdate' => 'Nieuwe eigenaar is "%s" (ID=%s).',
      'History::PhoneCallAgent' => 'Klant gebeld.',
      'History::PhoneCallCustomer' => 'Klant heeft gebeld.',
      'History::PriorityUpdate' => 'Prioriteit gewijzigd van "%s" (%s) naar "%s" (%s).',
      'History::Remove' => '%s',
      'History::SendAgentNotification' => '"%s"-notificatie verstuurd aan "%s".',
      'History::SendAnswer' => 'Email verstuurd aan "%s".',
      'History::SendAutoFollowUp' => 'AutoFollowUp verstuurd aan "%s".',
      'History::SendAutoReject' => 'AutoReject verstuurd aan "%s".',
      'History::SendAutoReply' => 'AutoReply verstuurd aan "%s".',
      'History::SendCustomerNotification' => 'Notificatie verstuurd aan "%s".',
      'History::SetPendingTime' => 'Bijgewerkt: %s',
      'History::StateUpdate' => 'Oud: "%s" Nieuw: "%s"',
      'History::TicketFreeTextUpdate' => 'Bijgewerkt: %s=%s;%s=%s;',
      'History::TimeAccounting' => '%s tijdseenheden verantwoord. Nu %s tijdseenheden totaal.',
      'History::Unlock' => '',
      'History::WebRequestCustomer' => 'Klant stelt vraag via web.',
      'History::TicketLinkAdd' => 'Link naar "%s" toegevoegd.',
      'History::TicketLinkDelete' => 'Link naar "%s" toegevoegd.',
      'Hit' => 'Gevonden',
      'Hits' => 'Hits',
      'hour' => 'uur',
      'hours' => 'uren',
      'Ignore' => 'Negeren',
      'invalid' => 'ongeldig',
      'Invalid SessionID!' => 'Ongeldige SessieID',
      'Language' => 'Taal',
      'Languages' => 'Talen',
      'last' => 'laatste',
      'Line' => 'Regel',
      'Lite' => 'Licht',
      'Login failed! Your username or password was entered incorrectly.' => 'Aanmelden mislukt. Uw gebruikersnaam of wachtwoord is onjuist.',
      'Logout successful. Thank you for using OTRS!' => 'Afgemeld! Wij danken u voor het gebruiken van OTRS!',
      'Message' => 'Bericht',
      'minute' => 'minuut',
      'minutes' => 'minuten',
      'Module' => 'Module',
      'Modulefile' => 'Modulebestand',
      'month(s)' => 'maand(en)',
      'Name' => 'Naam',
      'New Article' => 'Nieuw artikel',
      'New message' => 'Nieuw bericht',
      'New message!' => 'Nieuw bericht!',
      'No' => 'Geen',
      'no' => 'geen',
      'No entry found!' => 'Niets gevonden!',
      'No Permission!' => 'Geen toegang! Onvoldoende rechten.',
      'No suggestions' => 'Geen suggesties',
      'none' => 'geen',
      'none - answered' => 'geen - beantwoord',
      'none!' => 'niet ingevoerd!',
      'Normal' => 'Normaal',
      'Off' => 'Uit',
      'off' => 'uit',
      'On' => 'Aan',
      'on' => 'aan',
      'Online Agent: %s' => 'Online Agent: %s',
      'Online Customer: %s' => 'Online klant: %s',
      'Password' => 'Wachtwoord',
      'Pending till' => 'In wachtstand tot',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'A.u.b. geëscaleerde tickets beantwoorden om terug te komen in de normale wachtwij',
      'Please contact your admin' => 'Vraag uw systeembeheerder',
      'please do not edit!' => 'A.u.b. niet wijzigen!',
      'possible' => 'mogelijk',
      'Preview' => '',
      'QueueView' => 'Wachtrijen',
      'reject' => 'afwijzen',
      'replace with' => 'vervangen met',
      'Reset' => 'leegmaken',
      'Salutation' => 'Aanhef',
      'Session has timed out. Please log in again.' => 'Sessie is verlopen. Opnieuw inloggen AUB.',
      'Show closed Tickets' => 'Gesloten tickets tonen',
      'Signature' => 'Handtekening',
      'Size' => 'Grootte',
      'Sorry' => 'Sorry',
      'Stats' => 'Statistieken',
      'Subfunction' => 'Sub-functie',
      'submit' => 'versturen',
      'submit!' => 'versturen!',
      'system' => 'systeem',
      'Take this Customer' => 'Selecteer deze klant',
      'Take this User' => 'Selecteer deze gebruiker',
      'Text' => 'Tekst',
      'The recommended charset for your language is %s!' => 'De aanbevolen karakterset voor uw taal is %s!',
      'Theme' => 'Thema',
      'There is no account with that login name.' => 'Er is geen account met deze gebruikersnaam',
      'Timeover' => 'Timeover',
      'To: (%s) replaced with database email!' => 'Aan: (%s) vervangen met database email!',
      'top' => 'Bovenkant',
      'Type' => '',
      'update' => 'wijzigen',
      'Update' => 'Wijzigen',
      'update!' => 'wijzigen!',
      'Upload' => '',
      'User' => 'Gebruiker',
      'Username' => 'Gebruikersnaam',
      'Valid' => 'Geldig',
      'Warning' => 'Waarschuwing',
      'week(s)' => 'we(e)k(en)',
      'Welcome to OTRS' => 'Welkom bij OTRS',
      'Word' => 'Woord',
      'wrote' => 'schreef',
      'year(s)' => 'ja(a)r(en)',
      'yes' => 'ja',
      'Yes' => 'Ja',
      'You got new message!' => 'U heeft een nieuw bericht!',
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
      'CreateTicket' => 'Ticket aanmaken',
      'Custom Queue' => 'Aangepaste wachtrij',
      'Follow up notification' => 'Bericht bij vervolgvragen',
      'Frontend' => 'Voorkant',
      'Mail Management' => 'Mail beheer',
      'Max. shown Tickets a page in Overview.' => 'Max. getoonde tickets per pagina in overzichtsscherm.',
      'Max. shown Tickets a page in QueueView.' => 'Max. getoonde tickets per pagina in wachtrijscherm',
      'Move notification' => 'Bericht bij het verplaatsen',
      'New ticket notification' => 'Bericht bij een nieuw ticket',
      'Other Options' => 'Overige opties',
      'PhoneView' => 'Telefoonscherm',
      'Preferences updated successfully!' => 'Voorkeuren zijn gewijzigd!',
      'QueueView refresh time' => 'Verversingstijd wachtrij',
      'Screen after new ticket' => 'Scherm na een nieuw ticket',
      'Select your default spelling dictionary.' => 'Selekteer uw standaard spellingsbibliotheek.',
      'Select your frontend Charset.' => 'Karakterset kiezen',
      'Select your frontend language.' => 'Kies een taal',
      'Select your frontend QueueView.' => 'Wachtrij weergave kiezen',
      'Select your frontend Theme.' => 'thema kiezen',
      'Select your QueueView refresh time.' => 'Verversingstijd kiezen',
      'Select your screen after creating a new ticket.' => 'Selecteer het vervolgscherm na het invoeren van een nieuw ticket',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Stuur een bericht als een klant een vervolgvraag stelt en ik de eigenaar van het ticket ben.',
      'Send me a notification if a ticket is moved into one of "My Queues".' => ' Stuur mij een bericht als een bericht wordt verplaatst in een aangepaste wachtrij',
      'Send me a notification if a ticket is unlocked by the system.' => 'Stuur  me een bericht als een ticket wordt ontgrendeld door het systeem.',
      'Send me a notification if there is a new ticket in "My Queues".' => 'Stuur mij een bericht als er een nieuw ticket in mijn aangepaste wachtrij komt.',
      'Show closed tickets.' => 'Gesloten tickets tonen',
      'Spelling Dictionary' => 'Spelling bibliotheek',
      'Ticket lock timeout notification' => 'Bericht van tijdsoverschreiding van een vergrendeling',
      'TicketZoom' => 'Inhoud ticket',

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
      'Bounce' => '',
      'Cc' => 'Cc',
      'Close' => 'Sluiten',
      'closed' => 'geschlossen',
      'closed successful' => 'succesvol gesloten',
      'closed unsuccessful' => 'niet succesvol gesloten',
      'Compose' => 'Maken',
      'Created' => 'Gemaakt',
      'Createtime' => 'Gemaakt op',
      'email' => 'e-mail',
      'eMail' => 'e-mail',
      'email-external' => 'E-mail naar extern',
      'email-internal' => 'E-mail naar intern',
      'Forward' => 'Doorsturen',
      'From' => 'Van',
      'high' => 'hoog',
      'History' => 'Geschiedenis',
      'If it is not displayed correctly,' => 'Als dit niet juist wordt weergegeven,',
      'lock' => '',
      'Lock' => '',
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
      'This is a HTML e-mail. Click here to show it.' => 'Dit is een e-mail in HTML-formaat. Hier klikken om te bekijken.',
      'This message was written in a character set other than your own.' => 'Dit bericht is geschreven in een andere karakterset dan degene die u nu heeft ingesteld.',
      'Ticket' => 'Ticket',
      'Ticket "%s" created!' => 'Ticket "%s" aangemaakt',
      'To' => 'Aan',
      'to open it in a new window.' => 'om deze in een nieuw venster te openen',
      'unlock' => '',
      'Unlock' => '',
      'very high' => 'zeer hoog',
      'very low' => 'zeer laag',
      'View' => 'Weergave',
      'webrequest' => 'Verzoek via web',
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
      'Add' => 'Toevoegen',
      'Attachment Management' => 'Bijlage beheer',

    # Template: AdminAutoResponseForm
      'Auto Response From' => 'Autoreply Van',
      'Auto Response Management' => 'Autoreply beheer',
      'Note' => 'Notitie',
      'Response' => 'Antwoord',
      'to get the first 20 character of the subject' => 'voor de eerste 20 tekens van het onderwerp',
      'to get the first 5 lines of the e-mail' => 'voor de eerste 5 regels van het bericht',
      'to get the from line of the email' => 'voor de Van: kop',
      'to get the realname of the sender (if given)' => 'voor de echte naam van de afzender (indien beschikbaar)',
      'to get the ticket id of the ticket' => 'voor het ticket #',
      'to get the ticket number of the ticket' => 'voor het ticket-nummer',
      
    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Userbeheer klanten',
      'Customer user will be needed to have an customer histor and to to login via customer panels.' => 'Klanten moeten een klanthistorie hebben en inloggen via de klantschermen',
      'Result' => 'Resultaat',
      'Search' => 'Zoek',
      'Search for' => 'Zoek naar',
      'Select Source (for add)' => 'Selecteer bron (voor toevoegen)',
      'Source' => 'Bron',
      'The message being composed has been closed.  Exiting.' => 'Het bericht dat werd aangemaakt is gesloten.',
      'This values are required.' => 'Deze waarden zijn verplicht',
      'This window must be called from compose window' => 'Dit scherm moet van het scherm opstellen worden aangeroepen',
    
    # Template: AdminCustomerUserGeneric
      '"}: <font color="red">$Text{"' => '',

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Wijzig instellingen voor %s',
      'Customer User <-> Group Management' => 'Klanten <-> Groepenbeheer',
      'Full read and write access to the tickets in this group/queue.' => 'Volledige lees- en schrijfrechten op de tickets in deze groep/wachtrij',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Als er geen selectie is gemaakt dan zijn er geen rechten voor deze groep (tickets zullen die beschikbaar zijn voor de gebruiker).',
      'Permission' => 'Rechten',
      'Read only access to the ticket in this group/queue.' => 'Leesrechten op het ticket in deze groep/wachtrij',
      'ro' => '',
      'rw' => '',
      'Select the user:group permissions.' => 'Selecteer de gebruiker/groep rechten',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Wijzigen van gebruiker <-> groep toekenning',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Admin e-mail adres',
      'Body' => 'berichttekst',
      'OTRS-Admin Info!' => 'OTRS-Admin informatie!',
      'Recipents' => 'Ontvangers',
      'send' => 'verstuur',

    # Template: AdminEmailSent
      'Message sent to' => 'Bericht verstuurd naar',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Maak nieuwe groepen om toegangsrechten te regelen voor verschillende groepen van agenten (bijv. verkoopafdeling, supportafdeling, enz. enz.).',
      'Group Management' => 'Groepenbeheer',
      'It\'s useful for ASP solutions.' => 'Zeer bruikbaar voor ASP-oplossingen.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => 'Leden van de admingroep mogen in het administratiegedeelte, leden van de Stats groep hebben toegang tot het statistiekgedeelte.',

    # Template: AdminLog
      'System Log' => 'Systeem logboek',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin e-mail adres',
      'Attachment <-> Response' => 'Bijlage <-> Antwoord',
      'Auto Response <-> Queue' => 'Autoreply <-> Wachtrij',
      'Auto Responses' => 'Autoreply instellingen',
      'Customer User' => 'Klant beheer',
      'Customer User <-> Groups' => 'Klanten <-> Groepen beheer',
      'Email Addresses' => 'E-mail adressen',
      'Groups' => 'Groepen',
      'Logout' => 'Uitloggen',
      'Misc' => 'Overige',
      'Notifications' => 'Notificaties',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => 'PostMaster POP3 Account',
      'Responses' => 'Antwoorden',
      'Responses <-> Queue' => 'Antwoorden <-> Wachtrij',
      'Select Box' => 'SQL select query',
      'Session Management' => 'Sessiebeheer',
      'Status' => 'Status',
      'System' => 'Systeem',
      'User <-> Groups' => 'Gebruikers <-> Groepen',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Config opties (b.v. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Notificatie beheer',
      'Notifications are sent to an agent or a customer.' => 'Notificaties worden verstuurd naar een agent of een klant',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'Opties van de huidige user data van de klant (b.v. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'Opties van de user die deze actie heeft aangevraagd (b.v. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'Opties voor de ticketeigenaar (b.v. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Alle binnenkomende e-mail\'s in een account zullen worden geplaatst in de geselecteerde wachtrij',
      'Dispatching' => 'Dispatching',
      'Host' => 'Server',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Wanneer uw account te vertrouwen is, zal de x/otrs header (voor prioriteit, ...) worden gebruikt',
      'POP3 Account Management' => 'POP3 account-beheer',
      'Trusted' => 'Te vertrouwen',

    # Template: AdminPostMasterFilterForm
      'Login' => 'Login',
      'Match' => '',
      'PostMasterFilter Management' => '',
      'Set' => '',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Wachtrij<-> Automatisch antwoorden beheer',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = geen escalatie',
      '0 = no unlock' => '0 = geen ontgrendeling',
      'Customer Move Notify' => 'Klant notificatie bij verplaatsen',
      'Customer Owner Notify' => 'Klant notificatie andere eigenaar',
      'Customer State Notify' => 'Klant notificatie andere status',
      'Escalation time' => 'Escalatietijd',
      'Follow up Option' => 'Follow up optie',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Wanneer een ticket wordt gesloten and de klant stuurt een follow-up wordt het ticket vergrendeld door de oude eigenaar',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Als een ticket niet binnen deze tijd is beantwoord zal alleen dit ticket worden getoond',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Wanneer een agent een ticket vergrendeld en hij/zij stuurt geen antwoord binnen deze tijd dan zal het ticket automatisch ontgrendeld worden. Het ticket kan dan door andere agenten worden ingezien.',
      'Key' => 'Key',
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
      'Std. Responses <-> Queue Management' => 'Antwoorden <-> Wachtrij beheer',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Antwoord',
      
    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Std. antwoorden <-> Std. bijlagen beheer',

    # Template: AdminResponseAttachmentForm
      
    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Een antworord is een standaard-tekst om sneller antwoorden te kunnen opstellen.',
      'All Customer variables like defined in config option CustomerUser.' => 'Alle klantvariabelen zoals vastgelegd in de configuratieoptie Klantgebruiker.',
      'Don\'t forget to add a new response a queue!' => 'Vergeet niet om een antwoord aan de wachtrij toe te kennen!',
      'Next state' => 'Volgende status',
      'Response Management' => 'Antwoordbeheer',
      'The current ticket state is' => 'De huidige ticketstatus is',
      'Your email address is new' => 'Uw e-mail adres is nieuw',

    # Template: AdminSalutationForm
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
      'Agent' => '',
      'kill all sessions' => 'Alle sessies afsluiten',
      'Overview' => '',
      'Sessions' => '',
      'Uniq' => '',

    # Template: AdminSessionTable
      'kill session' => 'Sessie afsluiten',
      'SessionID' => 'Sessie #',

    # Template: AdminSignatureForm
      'Signature Management' => 'handtekeningbeheer',

    # Template: AdminStateForm
      'See also' => 'Zie ook',
      'State Type' => 'Status Type',
      'System State Management' => 'Systeem-status beheer',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Bewaak dat u ook de default statussen in uw Kernel/Config.pm bijwerkt!',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alle binnenkomende emails met deze "To:" worden in de gekozen wachtrij geplaatst.',
      'Email' => 'Email',
      'Realname' => 'Echte naam',
      'System Email Addresses Management' => 'Systeem E-mailadressen beheer',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Vergeet niet om groepen aan deze gebruiker toe te kennen!',
      'Firstname' => 'Voornaam',
      'Lastname' => 'Achternaam',
      'User Management' => 'Gebruikersbeheer',
      'User will be needed to handle tickets.' => 'Gebruikers zijn nodig om tickets te behandelen.',

    # Template: AdminUserGroupChangeForm
      'create' => 'Aanmaken',
      'move_into' => 'verplaats naar',
      'owner' => 'eigenaar',
      'Permissions to change the ticket owner in this group/queue.' => 'Rechten om de ticketeigenaar in deze groep/wachtrij te wijzigen',
      'Permissions to change the ticket priority in this group/queue.' => 'Rechten om de prioriteit van een ticket in deze groep/wachtrij te wijzigen',
      'Permissions to create tickets in this group/queue.' => 'Rechten om tickets in deze groep/wachtrij aan te maken',
      'Permissions to move tickets into this group/queue.' => 'Rechten om tickets naar deze groep/wachtrij te verplaatsen',
      'priority' => 'prioriteit',
      'User <-> Group Management' => 'Gebruiker <-> Groep beheer',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => 'Adresboek',
      'Discard all changes and return to the compose screen' => 'Veranderingen niet toepassen en ga terug naar het berichtscherm',
      'Return to the compose screen' => 'Terug naar berichtscherm',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Een bericht moet een ontvanger (aan:) hebben!',
      'Bounce ticket' => 'Bounce ticket',
      'Bounce to' => 'Bounce naar',
      'Inform sender' => 'Informeer afzender',
      'Next ticket state' => 'Volgende status van het ticket',
      'Send mail!' => 'bericht versturen!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'In het Aan-veld is een E-mail adres nodig!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Je email met ticket nummer "<OTRS_TICKET>" is gebounced naar "<OTRS_BOUNCE_TO>". Contacteer dit adres voor meer informatie.',

    # Template: AgentBulk
      'A message should have a subject!' => 'Een bericht moet een onderwerp hebben!',
      'Back' => 'Terug',
      'New Queue' => 'Nieuwe wachtrij',
      'Note type' => 'Notitietype',
      'Note!' => 'Notitie!',
      'Options' => 'Opties',
      'Spell Check' => 'Spellingscontrole',
      'Ticket Bulk Action' => 'Ticket Bulk Aktie',
    
    # Template: AgentClose
      ' (work units)' => '(werk eenheden)',
      'A message should have a body!' => 'Een bericht moet een berichttekst hebben!',
      'Close ticket' => 'Sluit ticket',
      'Close type' => 'Sluit-type',
      'Close!' => 'Sluit!',
      'Note Text' => 'Notitietekst',
      'Time units' => 'Tijdseenheden',
      'You need to account time!' => 'Het is verplicht tijd te verantwoorden!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Van een bericht moet de spelling gecontroleerd worden',
      'Attach' => 'Bijlage',
      'Compose answer for ticket' => 'Bericht opstellen voor',
      'for pending* states' => 'voor nog hangende* statussen',
      'Is the ticket answered' => 'Is het ticket beantwoord?',
      'Pending Date' => 'Nog hangende datum',

    # Template: AgentCustomer
      'Change customer of ticket' => 'Wijzig klant van een ticket',
      'CustomerID' => 'KlantID',
      'Search Customer' => 'Klanten zoeken',
      'Set customer user and customer id of a ticket' => 'Wijs de klantgebruiker en klantID van een ticket toe',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Alle klanttickets',
      'Customer history' => 'Klantgeschiedenis',

    # Template: AgentCustomerMessage
      'Follow up' => 'Follow up',

    # Template: AgentCustomerView
      'Customer Data' => 'Klantgegevens',

    # Template: AgentEmailNew
      'All Agents' => 'Alle agents',
      'Clear From' => 'Wis Van',
      'Compose Email' => 'E-mail opstellen',
      'new ticket' => 'nieuw ticket',

    # Template: AgentForward
      'Article type' => 'Artikel-type',
      'Date' => 'Datum',
      'End forwarded message' => 'Beëindig doorgestuurd bericht',
      'Forward article of ticket' => 'Artikel van ticket doorsturen',
      'Forwarded message from' => 'Doorgestuurd bericht van',
      'Reply-To' => 'Antwoord aan',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Verander de vrije tekstvelden van een bericht',
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
      '"}' => '',
      '"}","14' => '',
      'Shows the detail view of this ticket!' => 'Toont het detailscherm van dit ticket!',
      'Unlock this ticket!' => 'Unlock dit ticket!',

    # Template: AgentMove
      'Move Ticket' => 'Verplaats Bericht',
      'New Owner' => 'Nieuwe eigenaar',
      'Previous Owner' => 'Vorige eigenaar',
      'Queue ID' => 'WachtrijID',

    # Template: AgentNavigationBar
      'Bulk Action' => 'Bulk aktie',
      'Locked tickets' => 'Eigen tickets',
      'new message' => 'Nieuw bericht',
      'Preferences' => 'Voorkeuren',
      'Ticket selected for bulk action!' => 'Ticket geselecteerd voor bulk aktie!',

    # Template: AgentNote
      'Add note to ticket' => 'Notitie toevoegen aan ticket',
      
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

    # Template: AgentPlain
      'ArticleID' => 'ArtikelID',
      'Plain' => 'Zonder opmaak',
      'TicketID' => 'TicketID',

    # Template: AgentPreferencesCustomQueue
      'My Queues' => 'Mijn wachtrijen',
      'You also get notified about this queues via email if enabled.' => 'Indien ingeschakeld, ontvangt u ook notificaties via e-mail over deze wachtrijen.',
      'Your queue selection of your favorite queues.' => 'Selectie van uw favoriete wachtrijen.',

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
      'Spell Checker' => 'Spellingscontrole',
      'spelling error(s)' => 'Spelfout(en)',

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

    # Template: AgentTicketLink
      'Link' => '',
      'Link to' => 'Link naar',
      'Delete Link' => 'Verwijder link',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket vergrendeld!',
      'Ticket unlock!' => 'Ticket ontgrendeld!',

    # Template: AgentTicketPrint
      'by' => 'door',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Geregistreerde tijd',
      'Escalation in' => 'Escalatie om',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => '(b.v. 10*5155 or 105658*)',
      '(e. g. 234321)' => '(b.v. 234321)',
      '(e. g. U5150)' => '(b.v. U5150)',
      'and' => 'en',
      'Customer User Login' => 'Klant login',
      'Delete' => 'Verwijder',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fulltext-Search in artikel (b.v. "Mar*in" of "Baue*")',
      'No time settings.' => 'Geen tijdinstellingen',
      'Profile' => 'Profiel',
      'Result Form' => 'Resultaatformulier',
      'Save Search-Profile as Template?' => 'Zoekprofiel als template bewaren ?',
      'Search-Template' => 'Zoektemplate',
      'Select' => 'Selecteer',
      'Ticket created' => 'Ticket aangemaakt',
      'Ticket created between' => 'Ticket aangemaakt tussen',
      'Ticket Search' => 'Zoek ticket',
      'TicketFreeText' => '',
      'Times' => 'Malen',
      'Yes, save it with name' => 'Ja, sla op met naam',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'zoeken in klantgeschiednis',
      'Customer history search (e. g. "ID342425").' => 'Klantgeschiedenis zoeken (bijv. "ID342425").',
      'No * possible!' => 'Geen * mogelijk!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => 'Verander zoekopties',
      'Results' => 'Resultaten',
      'Search Result' => 'Zoekresultaat',
      'Total hits' => 'Totaal gevonden',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

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
      
    # Template: AgentZoomArticle
      'Split' => 'splitsing',

    # Template: AgentZoomBody
      'Change queue' => 'Wachtrij wisselen',

    # Template: AgentZoomHead
      'Lock it to work on it!' => 'Ticket locken om eraan te werken!',

    # Template: AgentZoomStatus
      '"}","18' => '',
      'Locked' => '',

    # Template: Copyright
      'Print' => 'Afdrukken',
      'printed by' => 'afgedrukt door',

    # Template: CustomerCreateAccount
      'Create Account' => 'Maak account',

    # Template: CustomerError
      'Traceback' => 'Terug traceren',

    # Template: CustomerFAQArticleHistory
      'Edit' => 'Wijzig',
      'FAQ History' => 'FAQ Geschiedenis',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Categorie',
      'Keywords' => '',
      'Last update' => 'Laatste wijziging',
      'Solution' => 'Oplossing',
      
    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => 'FAQ Systeem geschiedenis',

    # Template: CustomerFAQArticleView
      'FAQ Article' => 'FAQ artikel',
      'Modified' => 'Gewijzigd',

    # Template: CustomerFAQOverview
      'FAQ Overview' => '',

    # Template: CustomerFAQSearch
      'FAQ Search' => '',
      'Fulltext' => '',
      'Keyword' => '',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'FAQ zoekresultaat',

    # Template: CustomerFooter
      'Powered by' => 'Powered by',

   # Template: CustomerLostPassword
      'Lost your password?' => 'Wachtwoord vergeten?',
      'Request new password' => 'Vraag een nieuw wachtwoord aan',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'CompanyTickets' => 'Bedrijfstickets',   
      'Create new Ticket' => 'Maak een nieuw Ticket',
      'FAQ' => 'FAQ',
      'MyTickets' => 'Mijn Tickets',      
      'New Ticket' => 'Nieuw ticket',
      'Welcome %s' => 'Welkom %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Mijn tickets',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning
    
    # Template: DWPFAQArticleView

    # Template: DWPFAQSearch
    
    # Template: Error
      'Click here to report a bug!' => 'Klik hier om een fout te rapporteren',

    # Template: FAQArticleDelete
      'FAQ Delete' => '`FAQ verwijderen',
      'You really want to delete this article?' => 'Wilt u dit artikel echt verwijderen ?',

    # Template: FAQArticleForm
      'A article should have a title!' => 'Een artikel moet een titel hebben!',      
      'Comment (internal)' => 'Interne opmerking',
      'Filename' => 'Bestandsnaam',
      'Title' => 'Titel',
      
    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => 'FAQ Categorie',
      'Name is required!' => 'Naam is verplicht!',

    # Template: FAQLanguageForm
      'FAQ Language' => 'FAQ taal',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => 'FAQ status',

    # Template: Footer
      'Top of Page' => 'Bovenkant pagina',

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
      'Use utf-8 it your database supports it!' => '',
      'Webfrontend' => '',

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Geen rechten',

    # Template: Notify
      'Info' => 'Informatie',

    # Template: PrintFooter
      'URL' => 'URL',

    # Template: PrintHeader
      'printed by' => 'afgedrukt door',

    # Template: QueueView
      'All tickets' => 'Alle tickets',
      'Page' => 'Pagina',
      'Queues' => 'Wachtrij',
      'Tickets available' => 'Tickets beschikbaar',
      'Tickets shown' => 'Tickets getoond',

    # Template: SystemStats
      'Graphs' => 'Grafieken',

    # Template: Test
      'OTRS Test Page' => 'OTRS Testpagina',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ticket escalatie!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Notitie toevoegen',

    # Template: Warning

    # Template: css
      'Home' => '',

    # Template: customer-css
      'Contact' => 'Contact',
      'Online-Support' => 'Online support',
      'Products' => 'Produkten',
      'Support' => '',

    # Misc
      'A message should have a From: recipient!' => 'Een bericht moet een Van: afzender hebben!',
      'Add a note to this ticket!' => 'Notitie aan dit ticket toevoegen!',
      'Add auto response' => 'Autoreply toevoegen',
      'Addressbook' => 'Adresboek',      
      'AgentFrontend' => 'Agent weergave',
      'Article free text' => 'Artikel tekst',
      'BackendMessage' => 'Systeembericht',
      'Change Response <-> Attachment settings' => 'Wijzigingsbericht <-> Bijlage beheer',
      'Change answer <-> queue settings' => 'Wijzigingsbericht <-> Wachtrij beheer',
      'Change auto response settings' => 'Verander autoreply instellingen',
      'Change the ticket customer!' => 'Wijzig klant voor dit ticket!',
      'Change the ticket free fields!' => 'Wijzig vrije tekstvelden voor dit ticket!',
      'Change the ticket owner!' => 'Wijzig eigenaar van dit ticket!',
      'Change the ticket priority!' => 'Wijzig prioriteit van dit ticket!',      
      'Charset' => 'karakterset',
      'Charsets' => 'Karaktersets',
      'Close this ticket!' => 'Sluit dit ticket!',
      'Closed' => 'Gesloten',
      'Create' => 'Aanmaken',
      'Customer info' => 'Klantinfo',
      'Free Fields' => 'Vrije velden',
      'Link this ticket to an other one!' => 'Link dit ticket aan een ander ticket!',
      'Lock Ticket' => '',
      'My Tickets' => 'Mijn tickets',
      'New ticket via call.' => 'Nieuw ticket vanaf een telefoongeprek',
      'New user' => 'Nieuwe gebruiker',
      'Please go away!' => 'Ga alstublieft weg!',
      'Print this ticket!' => 'Print dit ticket!',
      'Problem' => 'Probleem',
      'Search in' => 'Zoek in',
      'Select source:' => 'Selecteer bron',
      'Select your custom queues' => 'Selecteer uw custom wachtrijen',
      'Set this ticket to pending!' => 'Ticket aanhouden!',
      'Short Description' => 'Korte omschrijving',
      'Show all' => 'Alle getoond',
      'Shown Tickets' => 'Angezeigte Tickets',
      'Shows the ticket history!' => 'Toont de ticketgeschiedenis!',
      'Symptom' => 'Symptoom',
      'System Charset Management' => 'Systeem karakterset beheer',
      'Ticket-Overview' => '',
      'Time till escalation' => 'Tijd tot escalatie',
      'Utilities' => '',
      'With Priority' => 'Met priotiteit',
      'With State' => 'Met status',
      'by' => 'door',
      'invalid-temporarily' => 'tijdelijk ongeldig',
      'phone call' => 'telefoongesprek',
      'search' => 'zoeken',
      'store' => 'opslaan',
      'tickets' => 'tickets',
      'valid' => 'geldig',
      'No such Ticket Number "%s"! Can\'t link it!' => 'Ticketnummer "%s" niet gevonden! Kan niet gelinkt worden!',
      'Passwords dosn\'t match! Please try it again!' => 'Passwords komen niet overeen! Probeer het opnieuw!',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;
