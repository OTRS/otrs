# --
# Kernel/Language/German.pm - provides german languag translation
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Dutch.pm,v 1.1 2002-11-15 14:11:40 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::Dutch;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;

    # --
    # some common words
    # --
    $Self->{Lock} = 'Vergrendelen';
    $Self->{Unlock} = 'Vrijgeven';
    $Self->{unlock} = 'vrijgeven';
    $Self->{Zoom} = 'Inhoud';
    $Self->{History} = 'Geschiedenis';
    $Self->{'Add Note'} = 'Notitie toevoegen';
    $Self->{Bounce} = 'Terugsturen';
    $Self->{Age} = 'Leeftijd';
    $Self->{Priority} = 'Prioriteit';
    $Self->{State} = 'Status';
    $Self->{From} = 'Van';
    $Self->{To} = 'Aan';
    $Self->{Cc} = 'Cc';
    $Self->{Subject} = 'Betreft';
    $Self->{Move} = 'Verplaatsen';
    $Self->{Queues} = 'Wachtrij';
    $Self->{Close} = 'Sluiten';
    $Self->{Compose} = 'Maken';
    $Self->{Pending} = 'Wachtend';
    $Self->{end} = 'Onderkant';
    $Self->{top} = 'Bovenkant';
    $Self->{day} = 'dag';
    $Self->{days} = 'dagen';
    $Self->{hour} = 'uur';
    $Self->{hours} = 'uren';
    $Self->{minute} = 'minuut';
    $Self->{minutes} = 'minuten';
    $Self->{Owner} = 'Eigenaar';
    $Self->{Sender} = 'Afzender';
    $Self->{Article} = 'Artikel';
    $Self->{Ticket} = 'Ticket';
    $Self->{Createtime} = 'Gemaakt op';
    $Self->{Created} = 'Gemaakt';
    $Self->{View} = 'Weergave';
    $Self->{plain} = 'zonder opmaak';
    $Self->{Plain} = 'zonder opmaak';
    $Self->{Action} = 'Actie';
    $Self->{Attachment} = 'Bijlage';
    $Self->{User} = 'Gebruiker';
    $Self->{Username} = 'Gebruikersnaam';
    $Self->{Password} = 'Wachtwoord';
    $Self->{Back} = 'Terug';
    $Self->{store} = 'bewaren';
    $Self->{phone} = 'telefoon';
    $Self->{Phone} = 'Telefoon';
    $Self->{email} = 'email';
    $Self->{Email} = 'Email';
    $Self->{'Language'} = 'Taal';
    $Self->{'Languages'} = 'Talen';
    $Self->{'Salutation'} = 'Aanhef';
    $Self->{'Signature'} = 'Handtekening';
    $Self->{currently} = 'op dit moment';
    $Self->{Customer} = 'Klant';
    $Self->{'Customer info'} = 'Klanten info';
    $Self->{'Set customer id of a ticket'} = 'Stel het klantnummer in van een ticket';
    $Self->{'All tickets of this customer'} = 'Alle tickets van deze klant';
    $Self->{'New CustomerID'} = 'Nieuw klantennummer';
    $Self->{'for ticket'} = 'voor ticket';
    $Self->{'new ticket'} = 'nieuw ticket';
    $Self->{'New Ticket'} = 'Nieuw ticket';
    $Self->{'Start work'} = 'Start werkzaamheden';
    $Self->{'Stop work'} = 'Stop werkzaamheden';
    $Self->{'CustomerID'} = 'Klant #';
    $Self->{'Compose Answer'} = 'Antwoord opstellen';
    $Self->{'Contact customer'} = 'Klant contacteren';
    $Self->{'Change queue'} = 'Wachtrij wisselen';
    $Self->{'go!'} = 'start!';
    $Self->{'go'} = 'start';
    $Self->{'all'} = 'alle';
    $Self->{'All'} = 'Alle';
    $Self->{'Sorry'} = 'Sorry';
    $Self->{'No'} = 'Nee';
    $Self->{'no'} = 'nee';
    $Self->{'Yes'} = 'Ja';
    $Self->{'yes'} = 'ja';
    $Self->{'Off'} = 'Uit';
    $Self->{'off'} = 'uit';
    $Self->{'On'} = 'Aan';
    $Self->{'on'} = 'aan';
    $Self->{'update!'} = 'verversen!';
    $Self->{'update'} = 'verversen';
    $Self->{'submit!'} = 'versturen!';
    $Self->{'change!'} = 'veranderen!';
    $Self->{'change'} = 'veranderen';
    $Self->{'Change'} = 'Veranderen';
    $Self->{'click here'} = 'klik hier';
    $Self->{'settings'} = 'configuratie';
    $Self->{'Settings'} = 'Configuratie';
    $Self->{'Comment'} = 'Commentaar';
    $Self->{'Valid'} = 'Geldig';
    $Self->{'Forward'} = 'Doorsturen';
    $Self->{'Name'} = 'Naam';
    $Self->{'Group'} = 'Groep';
    $Self->{'Response'} = 'Antwoord';
    $Self->{'Preferences'} = 'Voorkeuren';
    $Self->{'Description'} = 'Omschrijving';
    $Self->{'description'} = 'omschrijving';
    $Self->{'Key'} = 'Sleutel';
    $Self->{'top'} = 'Bovenkant';
    $Self->{'Line'} = 'Regel';
    $Self->{'Subfunction'} = 'sub-functie';
    $Self->{'Module'} = 'Module';
    $Self->{'Modulefile'} = 'Modulebestand';
    $Self->{'No Permission'} = 'Geen rechten';
    $Self->{'You have to be in the admin group!'} = 'U moet hiervoor in de admin-groep staan!';
    $Self->{'You have to be in the stats group!'} = 'U moet hiervoor in de statisiek groep staan!';
    $Self->{'Message'} = 'Bericht';
    $Self->{'Error'} = 'Fout';
    $Self->{'Bug Report'} = 'Foutrapport';
    $Self->{'Click here to report a bug!'} = 'Klik hier om een fout te rapporteren';
    $Self->{'This is a HTML email. Click here to show it.'} = 'Dit is een Email in HTML-formaat. Hier klikken om te bekijken.';
    $Self->{'AgentFrontend'} = 'Agent weergave';
    $Self->{'Attention'} = 'Let op';
    $Self->{'Time till escalation'} = 'Tijd tot escalatie';
    $Self->{'Groups'} = 'Groepen';
    $Self->{'User'} = 'Gebruikers';
    $Self->{'none!'} = 'niet ingevoerd!';
    $Self->{'none'} = 'geen';
    $Self->{'none - answered'} = 'geen - beantwoord';
    $Self->{'German'} = 'Duits';
    $Self->{'English'} = 'Engels';
    $Self->{'French'} = 'Frans';
    $Self->{'Chinese'} = 'Chinees';
    $Self->{'Czech'} = 'Tjechisch';
    $Self->{'Danish'} = 'Deens';
    $Self->{'Spanish'} = 'Spaans';
    $Self->{'Greek'} = 'Grieks';
    $Self->{'Italian'} = 'Italiaans';
    $Self->{'Korean'} = 'Koreaans';
    $Self->{'Dutch'} = 'Nederlands';
    $Self->{'Polish'} = 'Pools';
    $Self->{'Brazilian'} = 'Braziliaans';
    $Self->{'Russian'} = 'Russisch';
    $Self->{'Swedish'} = 'Zweeds';
    $Self->{'Lite'} = 'Eenvoudig';
#    $Self->{'Standard'} = 'Standaard';
    $Self->{'This message was written in a character set other than your own.'} = 
     'Dit bericht is geschreven in een andere karakterset dan degene die u nu heeft ingesteld.';
    $Self->{'If it is not displayed correctly,'} = 'Als dit niet juist wordt weergegeven,';
    $Self->{'This is a'} = 'Dit is een';
    $Self->{'to open it in a new window.'} = 'om deze in een nieuw venster getoond te krijgen';
    # --
    # admin interface
    # --
    # common adminwords
    $Self->{'Useable options'} = 'Te gebruiken opties';
    $Self->{'Example'} = 'Voorbeeld';
    $Self->{'Examples'} = 'Voorbeelden';
    # nav bar
    $Self->{'Admin Area'} = 'Admininistratie schermen';
    $Self->{'Auto Responses'} = 'Automatische antwoorden'; 
    $Self->{'Responses'} = 'Antwoorden';
    $Self->{'Responses <-> Queue'} = 'Antwoorden <-> Wachtrijen';
    $Self->{'User <-> Groups'} = 'Gebruikers <-> Groepen';
    $Self->{'Queue <-> Auto Response'} = 'Wachtrijen <-> Automatische antwoorden';
    $Self->{'Auto Response <-> Queue'} = 'Automatische antwoorden <-> Wachtrijen';
    $Self->{'Session Management'} = 'Sessiebeheer';
    $Self->{'Email Addresses'} = 'Email-adressen';
    # user
    $Self->{'User Management'} = 'Gebruikersbeheer';
    $Self->{'Change user settings'} = 'Wijzigen van gebruikersinstellingen';
    $Self->{'Add user'} = 'Gebruiker toevoegen';
    $Self->{'Update user'} = 'Gebruiker actualiseren';
    $Self->{'Firstname'} = 'Voornaam';
    $Self->{'Lastname'} = 'Achternaam';
    $Self->{'(Click here to add a user)'} = '(Hier klikken - Gebruiker toevoegen)';
    $Self->{'User will be needed to handle tickets.'} = 'Gebruikers zijn nodig om Tickets te behandelen.';
    $Self->{'Don\'t forget to add a new user to groups!'} = 'Vergeet niet om groepen aan deze gebruiker toe te kennen!';
    # group
    $Self->{'Group Management'} = 'Groepenbeheer';
    $Self->{'Change group settings'} = 'Wijzigen van een groep';
    $Self->{'Add group'} = 'Groep toevoegen';
    $Self->{'Update group'} = 'Groep aktualiseren';
    $Self->{'(Click here to add a group)'} = '(Hier klikken - groep toevoegen)';
    $Self->{'The admin group is to get in the admin area and the stats group to get stats area.'} =
     'Leden van de admingroep mogen in het administratiegedeelte, leden van de Stats groep hebben toegang tot het statitsiekgedeelte.';
    $Self->{'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).'} =
     'Maak nieuwe groepen om toegangsrechten te regelen voor verschillende groepen van agenten (bijv. verkoopafdeling, supportafdeling, enz. enz.).';
    $Self->{'It\'s useful for ASP solutions.'} = 'Zeer bruikbaar voor ASP-oplossingen.';
    # user <-> group
    $Self->{'User <-> Group Management'} = 'Gebruiker <-> Groep beheer';
    $Self->{'Change user <-> group settings'} = 'Wijzigen van gebruiker <-> groep toekenning';
    # queue
    $Self->{'Queue Management'} = 'Wachtrijbeheer';
    $Self->{'Add queue'} = 'Wachtrij toevoegen';
    $Self->{'Change queue settings'} = 'Wachtrij wijzigen';
    $Self->{'Update queue'} = 'Wachtrij actualiseren';
    $Self->{'(Click here to add a queue)'} = '(Hier klikken - Wachtrij toevoegen)';
    $Self->{'Unlock timeout'} = 'Vrijgave tijdoverschrijding';
    $Self->{'Escalation time'} = 'Escalatietijd';
    # Response
    $Self->{'Response Management'} = 'Antwoordenbeheer';
    $Self->{'Add response'} = 'Antwoord toevoegen';
    $Self->{'Change response settings'} = 'Antwoord wijzigen';
    $Self->{'Update response'} = 'Antwoorden actualiseren';
    $Self->{'(Click here to add a response)'} = '(Hier klikken - Antwoord toevoegen)'; 
    $Self->{'A response is default text to write faster answer (with default text) to customers.'} =
     'Een antworord is een standaard-tekst om sneller antwoorden te kunnen opstellen.';
    $Self->{'Don\'t forget to add a new response a queue!'} = 'Een antwoord moet ook een wachtrij toegekend krijgen!';
    # Responses <-> Queue
    $Self->{'Std. Responses <-> Queue Management'} = 'Standaard antwoordenn <-> Wachtrij beheer';
    $Self->{'Standart Responses'} = 'Standaard-antwoorden';
    $Self->{'Change answer <-> queue settings'} = 'Wijzigen van antwoorden <-> wachtrij toekenning';
    # auto responses
    $Self->{'Auto Response Management'} = 'Automatisch-antwoorden beheer';
    $Self->{'Change auto response settings'} = 'Wijzigen van een automatisch-antwoord';
    $Self->{'Add auto response'} = 'Automatisch antwoord toevoegen';
    $Self->{'Update auto response'} = 'Automatisch antwoord aktualiseren';
    $Self->{'(Click here to add an auto response)'} = '(Hier klikken - Automatisch antwoord toevoegen)';
    # salutation
    $Self->{'Salutation Management'} = 'Aanhef beheer';
    $Self->{'Add salutation'} = 'Aanhef toevoegen';
    $Self->{'Update salutation'} = 'Aanhef actualiseren';
    $Self->{'Change salutation settings'} = 'Aanhef wijzigen';
    $Self->{'(Click here to add a salutation)'} = '(Hier klikken - Aanhef toevoegen)';
    $Self->{'customer realname'} = 'werkelijke klantnaam';
    # signature
    $Self->{'Signature Management'} = 'handtekeningbeheer';
    $Self->{'Add signature'} = 'Handtekening toevoegen';
    $Self->{'Update signature'} = 'Handtekening akcualiseren';
    $Self->{'Change signature settings'} = 'Handtekening wijzigen';
    $Self->{'(Click here to add a signature)'} = '(Hier klikken - handtekening toevoegen)';
    $Self->{'for agent firstname'} = 'voor voornaam van agent';
    $Self->{'for agent lastname'} = 'voor achternaam van agent';
    # queue <-> auto response
    $Self->{'Queue <-> Auto Response Management'} = 'Wachtrij<-> Automatisch antwoorden toekenning';
    $Self->{'auto responses set'} = 'Automatische antwoorden ingesteld';
    # system email addesses
    $Self->{'System Email Addresses Management'} = 'Email systeemadressen beheer';
    $Self->{'Change system address setting'} = 'Systeemadres wijzigen';
    $Self->{'Add system address'} = 'Systeem emailadres toevoegen';
    $Self->{'Update system address'} = 'Systeem emailadres actualiseren';
    $Self->{'(Click here to add a system email address)'} = '(Hier klikken - systeem-emailadres toevoegen)';
    $Self->{'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!'} = 'Alle binnenkomede emails met deze "To:" worden in de gekozen wachtrij geplaatst.';
    # charset
    $Self->{'System Charset Management'} = 'Systeem karakterset beheer';
    $Self->{'Change system charset setting'} = 'Andere systeem karakterset';
    $Self->{'Add charset'} = 'Karakterset toevoegen';
    $Self->{'Update charset'} = 'Karakterset actualiseren';
    $Self->{'(Click here to add charset)'} = '(Hier klikken - karakterset toevoegen';
    # states
    $Self->{'System State Management'} = 'Systeem-status beheer';
    $Self->{'Change system state setting'} = 'Wijzig systeemstatus';
    $Self->{'Add state'} = 'Status toevoegen';
    $Self->{'Update state'} = 'Status actualiseren';
    $Self->{'(Click here to add state)'} = '(Hier klikken - Status toevoegen)';
    # language
    $Self->{'System Language Management'} = 'Systeemtaal beheer';
    $Self->{'Change system language setting'} = 'Andere Systeemtaal';
    $Self->{'Add language'} = 'Taal toevoegen';
    $Self->{'Update language'} = 'Taal actualiseren';
    $Self->{'(Click here to add language)'} = '(Hier klikken - taal toevoegen)';
    # session
    $Self->{'Session Management'} = 'Sessiebeheer';
    $Self->{'kill all sessions'} = 'Alle sessies wissen';
    $Self->{'kill session'} = 'Sessie wissen';
    # select box
    $Self->{'Max Rows'} = 'Max. rijen';

    # --
    # agent interface
    # --
    # nav bar
    $Self->{Logout} = 'Afmelden';
    $Self->{QueueView} = 'Wachtrij weergave';
    $Self->{PhoneView} = 'Telefoon weergave';
    $Self->{Utilities} = 'Tools';
    $Self->{AdminArea} = 'Administratiegedeelte';
    $Self->{Preferences} = 'Voorkeuren';
    $Self->{'Locked tickets'} = 'Eigen tickets';
    $Self->{'new message'} = 'Nieuw bericht';
    $Self->{'You got new message!'} = 'Nieuw bericht binnen!';
    # ticket history
    $Self->{'History of Ticket'} = 'Geschiedenis van Ticket';
    # ticket note
    $Self->{'Add note to ticket'} = 'Notitie toevoegen aan ticket';
    $Self->{'Note type'} = 'Notitie-type';
    # queue view
    $Self->{'Tickets shown'} = 'Tickets getoond';
    $Self->{'Ticket available'} = 'Ticket beschikbaar';
    $Self->{'Show all'} = 'Alle getoond';
    $Self->{'tickets'} = 'tickets';
    $Self->{'All tickets'} = 'Alle tickets';
    $Self->{'Ticket escalation!'} = 'Ticket escalatie!';
    $Self->{'Please answer this ticket(s) to get back to the normal queue view!'} = 
     'A.u.b. geëscaleerde tickets beantwoorden om terug tekomen in de normale wachtwij';
    # locked tickets
    $Self->{'All locked Tickets'} = 'Alle vergrendelde tickets';
    $Self->{'New message'} = 'Nieuw bericht';
    $Self->{'New message!'} = 'Nieuw bericht!';
    # util
    $Self->{'Hit'} = 'Gevonden';
    $Self->{'Total hits'} = 'Totaal gevonden';
    $Self->{'search'} = 'zoeken';
    $Self->{'Search again'} = 'Nogmaals zoeken';
    $Self->{'max viewable hits'} = 'max. gevonden zichtbaar';
    $Self->{'Utilities/Search'} = 'Tools/zoeken';
    $Self->{'search (e. g. 10*5155 or 105658*)'} = 'zoeken (bijv. 10*5155 of 105658*)';
    $Self->{'Fulltext search (e. g. "Mar*in" or "Baue*" or "martin+hallo")'} = 'Zoeken in tekst (bijv. "Mar*in" of "Boe*" of "Martin+hallo")';
    $Self->{'Customer history search'} = 'zoeken in klantgeschiednis';
    $Self->{'No * possible!'} = 'Geen * mogelijk!';
    $Self->{'Fulltext search'} = 'Zoeken in alle tekst';
    $Self->{'Customer history search (e. g. "ID342425").'} = 'Klantgeschiedenis zoeken (bijv. "ID342425").';
    # compose
    $Self->{'Compose message'} = 'Bericht opstellen';
    $Self->{'please do not edit!'} = 'A.u.b. niet wijzigen!';
    $Self->{'Send mail!'} = 'bericht versturen!';
    $Self->{'wrote'} = 'schreef';
    $Self->{'Compose answer for ticket'} = 'Bericht opstellen voor';
    $Self->{'Ticket locked!'} = 'Ticket vergrendeld!';
    $Self->{'A message should have a To: recipient!'} = 'Een bericht moet een Aan: ontvanger te hebben!';
    $Self->{'A message should have a subject!'} = 'Een bericht moet een ondewerp hebben!';
    $Self->{'You need a email address (e. g. customer@example.com) in To:!'} = 'In het Aan-veld hebben we een Email-adres nodig!';
    # forward
    $Self->{'Forward article of ticket'} = 'Artikel van ticket doorsturen';
    $Self->{'Article type'} = 'Artikel-type';
    $Self->{'Next ticket state'} = 'Volgende status van het ticket';

    # preferences
    $Self->{'User Preferences'} = 'Gebruikersinstellingen';
    $Self->{'Change Password'} = 'Wachtwoord wijzigen';
    $Self->{'New password'} = 'Nieuw wachtwoord';
    $Self->{'New password again'} = 'Nieuw wachtwoord herhalen';
    $Self->{'Select your custom queues'} = 'Voorkeurs wachtrijen kiezen';
    $Self->{'Select your QueueView refresh time.'} = 'Verversingstijd van de wachtrijweergave kiezen';
    $Self->{'Select your frontend language.'} = 'Kies een taal voor weergave';
    $Self->{'Select your frontend Charset.'} = 'Karakterset voor weergave kiezen';
    $Self->{'Select your frontend Theme.'} = 'weergave thema kiezen';
    $Self->{'Follow up notification'} = 'Bericht bij vervolgvragen';
    $Self->{'Send follow up notification'} = 'Stuur een bericht bij een vervolgvraag';
    $Self->{'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.'} = 'Stuur een bericht als een klant een vervolgvraag stelt en ik de eigenaar van het ticket ben.';
    $Self->{'New ticket notification'} = 'Bericht bij een nieuw ticket';
    $Self->{'Send new ticket notification'} = 'Toesturen van een bericht bij een nieuw ticket';
    $Self->{'Send me a notification if there is a new ticket in my custom queues.'} = 'Stuur mij een bericht als er een nieuw ticket in mijn aangepaste wachtrij komt.';
    $Self->{'Ticket lock timeout notification'} = 'Bericht van tijdsoverschreiding van een vergrendeling';
    $Self->{'Send ticket lock timeout notification'} = 'Stuur bericht bij tijdsoverschreiding van een vergrendeling';
    $Self->{'Send me a notification if a ticket is unlocked by the system.'} = 'Stuur  me een bericht als een ticket wordt ontgrendeld door het systeemk.';
  
    $Self->{'Frontend Language'} = 'Taalweergave kiezen';
    $Self->{' 2 minutes'} = ' 2 minuten';
    $Self->{' 5 minutes'} = ' 5 minuten';
    $Self->{' 7 minutes'} = ' 7 minuten';
    $Self->{'10 minutes'} = '10 minuten';
    $Self->{'15 minutes'} = '15 minuten';
    $Self->{'Move notification'} = 'Notitie verplaatsen';
    $Self->{'Send me a notification if a ticket is moved into a custom queue.'} = ' Stuur mij een bericht als een bericht wordt verplaatst in een aangepaste wachtrij';  
    $Self->{'Select your frontend QueueView.'} = 'Wachtrij weergave kiezen';
    # change priority
    $Self->{'Change priority of ticket'} = 'Prioriteit wijzigen voor ticket';
    # some other words ...
    $Self->{'AddLink'} = 'Link toevoegen';
    $Self->{'Logout successful. Thank you for using OTRS!'} = 'Afgemeld! Wij danken u voor het gebruikeen van OTRS!';
#    $Self->{} = '';
#    $Self->{} = '';

    # stats
    $Self->{'Stats'} = 'Statistiek';
    $Self->{'Status'} = 'Status';
    $Self->{'Graph'} = 'Diagram';
    $Self->{'Graphs'} = 'Diagrammen';

    # phone view
    $Self->{'Phone call'} = 'Telefoongesprek';
    $Self->{'phone call'} = 'telefoongesprek';
    $Self->{'Phone call at'} = 'Gebeld om';
    $Self->{'A message should have a From: recipient!'} = 'Een bericht moet een Van: afzender hebben!';
    $Self->{'You need a email address (e. g. customer@example.com) in From:!'} = 'In het Van-veld hebben we een Email-adres nodig!';

    # states
    $Self->{'new'} = 'nieuw';
    $Self->{'open'} = 'open';
    $Self->{'closed succsessful'} = 'succesvol gesloten';
    $Self->{'closed unsuccsessful'} = 'niet succesvol gesloten';
    $Self->{'removed'} = 'verwijderd';
    # article types
    $Self->{'email-external'} = 'Email naar extern';
    $Self->{'email-internal'} = 'Email naar intern';
    $Self->{'note-internal'} = 'Notitie voor intern';
    $Self->{'note-external'} = 'Notitie voor extern';
    $Self->{'note-report'} = 'Notitie voor rapportage';

    # priority
    $Self->{'very low'} = 'zeer laag';
    $Self->{'low'} = 'laag';
    $Self->{'normal'} = 'normaal';
    $Self->{'high'} = 'hoog';
    $Self->{'very high'} = 'zeer hoog';

    # --
    # customer panel
    # --
    $Self->{'My Tickets'} = 'Mijn tickets';
    $Self->{'Welcome'} = 'Welkom';

    return;
}
# --

1;

