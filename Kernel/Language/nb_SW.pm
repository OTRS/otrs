# -- 
# Kernel/Language/nb_SW.pm - Swedish language translation
# Copyright (C) 2004 Mats Eric Olausson <mats@synergy.se>
# --
# $Id: nb_SW.pm,v 1.1 2004-05-30 16:48:11 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::Language::nb_SW.pm;

use strict;

use vars qw($VERSION);
$VERSION = q$Revision: 1.1 $;
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub Data {
    my $Self = shift;
    my %Param = @_;
    my %Hash = ();

    # $$START$$
    # Last translation Fri May 21 19:28:37 2004 by Mats Eric Olausson

    # possible charsets
    $Self->{Charset} = ['iso-8859-1', 'iso-8859-15', ];
    # date formats (%A=WeekDay;%B=LongMonth;%T=Time;%D=Day;%M=Month;%Y=Jear;)
    $Self->{DateFormat} = '%D/%M %Y %T';
    $Self->{DateFormatLong} = '%A %D. %B %Y %T';
    $Self->{DateInputFormat} = '%D.%M.%Y';
    $Self->{DateInputFormatLong} = '%D.%M.%Y - %T';

    %Hash = (
    # Template: AAABase
      ' 2 minutes' => ' 2 minuter',
      ' 5 minutes' => ' 5 minuter',
      ' 7 minutes' => ' 7 minuter',
      '(Click here to add)' => '(Klicka här för att lägga till)',
      '10 minutes' => '10 minuter',
      '15 minutes' => '15 minuter',
      'AddLink' => 'Lägg till länk',
      'Admin-Area' => 'Admin-område',
      'agent' => 'agent',
      'Agent-Area' => 'Agent-område',
      'all' => 'alla',
      'All' => 'Alla',
      'Attention' => 'OBS',
      'before' => 'före',
      'Bug Report' => 'Rapportera fel',
      'Cancel' => 'Avbryt',
      'change' => 'ändra',
      'Change' => 'Ändra',
      'change!' => 'ändra!',
      'click here' => 'klicka här',
      'Comment' => 'Kommentar',
      'Customer' => 'Kund',
      'customer' => 'kund',
      'Customer Info' => 'Kundinfo',
      'day' => 'dag',
      'day(s)' => 'dag(ar)',
      'days' => 'dagar',
      'description' => 'beskrivning',
      'Description' => 'Beskrivning',
      'Dispatching by email To: field.' => 'Skickar iväg enligt epostmeddelandets Till:-fält.',
      'Don\'t show closed Tickets' => 'Visa inte låsta tickets',
      'Don\'t work with UserID 1 (System account)! Create new users!' => 'Det är inte rekommenderat att arbeta som userid 1 (systemkonto)! Skapa nya användare!',
      'Done' => 'Klar',
      'end' => 'slut',
      'Error' => 'Fel',
      'Example' => 'Exempel',
      'Examples' => 'Exempel',
      'Facility' => 'Innrättning',
      'FAQ-Area' => 'FAQ-område',
      'Feature not active!' => 'Funktion inte aktiverad!',
      'go' => 'Starta',
      'go!' => 'Starta!',
      'Group' => 'Grupp',
      'Hit' => 'Träff',
      'Hits' => 'Träffar',
      'hour' => 'timme',
      'hours' => 'timmar',
      'Ignore' => 'Ignorera',
      'invalid' => 'ogiltig',
      'Invalid SessionID!' => 'Ogiltigt SessionID!',
      'Language' => 'Språk',
      'Languages' => 'Språk',
      'last' => 'sista',
      'Line' => 'Rad',
      'Lite' => 'Enkel',
      'Login failed! Your username or password was entered incorrectly.' => 'Inloggningen misslyckades! Angivet användarnamn och/eller lösenord är inte korrekt.',
      'Logout successful. Thank you for using OTRS!' => 'Utloggningen lyckades.  Tack för att du använde OTRS!',
      'Message' => 'Meddelande',
      'minute' => 'minut',
      'minutes' => 'minuter',
      'Module' => 'Modul',
      'Modulefile' => 'Modulfil',
      'month(s)' => 'månad(er)',
      'Name' => 'Namn',
      'New Article' => 'Ny artikel',
      'New message' => 'Nytt meddelande',
      'New message!' => 'Nytt meddelande!',
      'No' => 'Nej',
      'no' => 'inga',
      'No entry found!' => 'Ingen inmatning funnen!',
      'No suggestions' => 'Inga förslag',
      'none' => 'inga',
      'none - answered' => 'inga - besvarat',
      'none!' => 'inga!',
      'Normal' => 'Normal',
      'Off' => 'Av',
      'off' => 'av',
      'On' => 'På',
      'on' => 'på',
      'Password' => 'Lösenord',
      'Pending till' => 'Väntande tills',
      'Please answer this ticket(s) to get back to the normal queue view!' => 'Vänligen besvara denna/dessa tickets för att komma tillbaka till den normala kö-visningsbilden!',
      'Please contact your admin' => 'Vänligen kontakta administratören',
      'please do not edit!' => 'Var vänlig och ändra inte detta!',
      'Please go away!' => 'Systemet anser att du inte är auktoriserad att utföra åtgärden du forsöker göra.  Ta kontakt med administratören om du anser att detta inte stämmer.',
      'possible' => 'möjlig',
      'Preview' => 'Forhandsvisning',
      'QueueView' => 'Köer',
      'reject' => 'Avvisas',
      'replace with' => 'Ersätt med',
      'Reset' => 'Nollställ',
      'Salutation' => 'Hälsning',
      'Session has timed out. Please log in again.' => 'Sessionstiden har löpt ut.  Vänligen logga på igen.',
      'Show closed Tickets' => 'Visa låsta tickets',
      'Signature' => 'Signatur',
      'Sorry' => 'Beklagar',
      'Stats' => 'Statistik',
      'Subfunction' => 'Underfunktion',
      'submit' => 'Skicka',
      'submit!' => 'Skicka!',
      'system' => 'System',
      'Take this User' => 'Välj denna användare',
      'Text' => 'Text',
      'The recommended charset for your language is %s!' => 'Den rekommenderade teckenuppsättningen för ditt språk är %s!',
      'Theme' => 'Tema',
      'There is no account with that login name.' => 'Det finns inget konto med detta namn.',
      'Timeover' => 'Tidsöverträdelse',
      'To: (%s) replaced with database email!' => 'Till: (%s) ersatt med epost från databas!',
      'top' => 'topp',
      'update' => 'uppdatera',
      'Update' => 'Uppdatera',
      'update!' => 'Uppdatera!',
      'User' => 'Användare',
      'Username' => 'Användarnamn',
      'Valid' => 'Giltigt',
      'Warning' => 'Varning',
      'week(s)' => 'vecka(or)',
      'Welcome to OTRS' => 'Välkommen till OTRS',
      'Word' => 'Ord',
      'wrote' => 'skrev',
      'year(s)' => 'år',
      'yes' => 'ja',
      'Yes' => 'Ja',
      'You got new message!' => 'Du har fått ett nytt meddelande!',
      'You have %s new message(s)!' => 'Du har %s nya meddelanden!',
      'You have %s reminder ticket(s)!' => 'Du har %s påminnelse-tickets!',

    # Template: AAAMonth
      'Apr' => 'apr',
      'Aug' => 'aug',
      'Dec' => 'dec',
      'Feb' => 'feb',
      'Jan' => 'jan',
      'Jul' => 'jul',
      'Jun' => 'jun',
      'Mar' => 'mar',
      'May' => 'maj',
      'Nov' => 'nov',
      'Oct' => 'okt',
      'Sep' => 'sep',

    # Template: AAAPreferences
      'Closed Tickets' => 'Låsta tickets',
      'CreateTicket' => 'Skapa Ticket',
      'Custom Queue' => 'Utvald kö',
      'Follow up notification' => 'Meddelande om uppföljning',
      'Frontend' => 'Gränssnitt',
      'Mail Management' => 'Eposthantering',
      'Max. shown Tickets a page in Overview.' => 'Max. visade tickets per sida i Översikt.',
      'Max. shown Tickets a page in QueueView.' => 'Max. visade tickets per side i Kö-bild.',
      'Move notification' => 'Meddelande om ändring av kö',
      'New ticket notification' => 'Meddelande om nyskapad ticket',
      'Other Options' => 'Andra tillval',
      'PhoneView' => 'Tel.samtal',
      'Preferences updated successfully!' => 'Inställningar lagrade!',
      'QueueView refresh time' => 'Automatisk uppdateringsintervall fö Kö-bild',
      'Screen after new ticket' => 'Skärm efter inmatning av ny ticket',
      'Select your default spelling dictionary.' => 'Välj standard ordbok for stavningskontroll.',
      'Select your frontend Charset.' => 'Välj teckenuppsättning.',
      'Select your frontend language.' => 'Välj språk.',
      'Select your frontend QueueView.' => 'Välj Kö-bild.',
      'Select your frontend Theme.' => 'Välj stil-tema.',
      'Select your QueueView refresh time.' => 'Välj automatisk uppdateringsintervall för Kö-bild.',
      'Select your screen after creating a new ticket.' => 'Välj skärmbild som visas efter registrering av ny hänvisning/ticket.',
      'Send me a notification if a customer sends a follow up and I\'m the owner of this ticket.' => 'Skicka mig ett meddelande om kundkorrespondens för tickets som jag står som ägare till.',
      'Send me a notification if a ticket is moved into a custom queue.' => 'Skicka mig ett meddelande ifall en ticket flyttas över till en av mina utvalda köer.',
      'Send me a notification if a ticket is unlocked by the system.' => 'Skicka mig ett meddelande ifall systemet tar bort låset på en ticket.',
      'Send me a notification if there is a new ticket in my custom queues.' => 'Skicka mig ett meddelande ifall det kommer ett nytt meddelande till mina utvalda köer.',
      'Show closed tickets.' => 'Visa låsta tickets.',
      'Spelling Dictionary' => 'Stavningslexikon',
      'Ticket lock timeout notification' => 'Meddelan mig då tiden gått ut för ett ticket-lås',
      'TicketZoom' => 'Ticket Zoom',

    # Template: AAATicket
      '1 very low' => '1 Planeras',
      '2 low' => '2 låg',
      '3 normal' => '3 medium',
      '4 high' => '4 hög',
      '5 very high' => '5 kritisk',
      'Action' => 'Åtgärd',
      'Age' => 'Ålder',
      'Article' => 'Artikel',
      'Attachment' => 'Bifogat dokument',
      'Attachments' => 'Bifogade dokument',
      'Bcc' => 'Bcc',
      'Bounce' => 'Studsa',
      'Cc' => 'Cc',
      'Close' => 'Stäng',
      'closed successful' => 'Löst och stängt',
      'closed unsuccessful' => 'Olöst men stängt',
      'Compose' => 'Författa',
      'Created' => 'Skapat',
      'Createtime' => 'Tidpunkt för skapande',
      'email' => 'email',
      'eMail' => 'eMail',
      'email-external' => 'email externt',
      'email-internal' => 'email internt',
      'Forward' => 'Vidarebefordra',
      'From' => 'Från',
      'high' => 'hög',
      'History' => 'Historik',
      'If it is not displayed correctly,' => 'Ifall det inte visas korrekt,',
      'lock' => 'låst',
      'Lock' => 'Lås',
      'low' => 'låg',
      'Move' => 'Flytta',
      'new' => 'ny',
      'normal' => 'normal',
      'note-external' => 'notis externt',
      'note-internal' => 'notis internt',
      'note-report' => 'notis till rapport',
      'open' => 'öppen',
      'Owner' => 'Ägare',
      'Pending' => 'Väntande',
      'pending auto close+' => 'väntar på att stängas (löst)',
      'pending auto close-' => 'väntar på att stängas (olöst)',
      'pending reminder' => 'väntar på påminnelse',
      'phone' => 'telefon',
      'plain' => 'rå',
      'Priority' => 'Prioritet',
      'Queue' => 'Kö',
      'removed' => 'borttagen',
      'Sender' => 'Avsändare',
      'sms' => 'sms',
      'State' => 'Status',
      'Subject' => 'Ämne',
      'This is a' => 'Detta är en',
      'This is a HTML email. Click here to show it.' => 'Detta är ett HTML-email. Klicka här för att visa.',
      'This message was written in a character set other than your own.' => 'Detta meddelande är skrivet med en annan teckenuppsättning än den du använder.',
      'Ticket' => 'Ticket',
      'Ticket "%s" created!' => 'Ticket "%s" skapad!',
      'To' => 'Till',
      'to open it in a new window.' => 'för att öppna i ett nytt fönster',
      'unlock' => 'lås upp',
      'Unlock' => 'Lås upp',
      'very high' => 'kritisk',
      'very low' => 'planeras',
      'View' => 'Bild',
      'webrequest' => 'web-anmodan',
      'Zoom' => 'Zoom',

    # Template: AAAWeekDay
      'Fri' => 'fre',
      'Mon' => 'mån',
      'Sat' => 'lör',
      'Sun' => 'sön',
      'Thu' => 'tor',
      'Tue' => 'tis',
      'Wed' => 'ons',

    # Template: AdminAttachmentForm
      'Add' => 'Lägg till',
      'Attachment Management' => 'Hantering av bifogade dokument',

    # Template: AdminAutoResponseForm
      'Add auto response' => 'Lägg till autosvar',
      'Auto Response From' => 'autosvar-avsändare',
      'Auto Response Management' => 'Autosvar-hantering',
      'Change auto response settings' => 'Ändra autosvar-inställningar',
      'Note' => 'Notis',
      'Response' => 'Svar',
      'to get the first 20 character of the subject' => 'för att få fram de förste 20 tecknen i ämnesbeskrivningen',
      'to get the first 5 lines of the email' => 'för att få fram de första 5 raderna av emailen',
      'to get the from line of the email' => 'för att få fram avsändarraden i emailen',
      'to get the realname of the sender (if given)' => 'för att få fram avsändarens fulla namn (om möjligt)',
      'to get the ticket id of the ticket' => 'för att få fram intern ticket-id',
      'to get the ticket number of the ticket' => 'för att få fram ticket-nummer',
      'Type' => 'Typ',
      'Useable options' => 'Användbara tillägg',

    # Template: AdminCustomerUserForm
      'Customer User Management' => 'Kundanvändare',
      'Customer user will be needed to to login via customer panels.' => 'Kundanvändare måste logga in via kundsidorna.',
      'Select source:' => 'Välj källa',
      'Source' => 'Källa',

    # Template: AdminCustomerUserGeneric

    # Template: AdminCustomerUserGroupChangeForm
      'Change %s settings' => 'Ändra %s-inställningar',
      'Customer User <-> Group Management' => 'Kundanvändare <-> gruppr',
      'Full read and write access to the tickets in this group/queue.' => 'Fulla läs- och skrivrättigheter till tickets i denna grupp/kö.',
      'If nothing is selected, then there are no permissions in this group (tickets will not be available for the user).' => 'Om ingenting är valt finns inga rättigheter i denna grupp (tickets i denna grupp kommer inte att finnas tillgängliga för användaren).',
      'Permission' => 'Rättighet',
      'Read only access to the ticket in this group/queue.' => 'Endast läsrättighet till tickets i denna grupp/kö.',
      'ro' => 'ro',
      'rw' => 'rw',
      'Select the user:group permissions.' => 'Välj användar:grupp-rettigheter.',

    # Template: AdminCustomerUserGroupForm
      'Change user <-> group settings' => 'Ändra användar- <-> grupp-inställningar',

    # Template: AdminCustomerUserPreferencesGeneric

    # Template: AdminEmail
      'Admin-Email' => 'Admin-email',
      'Body' => 'Meddelandetext',
      'OTRS-Admin Info!' => 'OTRS-Admin Info!',
      'Recipents' => 'Mottagare',
      'send' => 'Skicka',

    # Template: AdminEmailSent
      'Message sent to' => 'Meddelande skicakt till',

    # Template: AdminGroupForm
      'Create new groups to handle access permissions for different groups of agent (e. g. purchasing department, support department, sales department, ...).' => 'Skapa nya gruppr för att kunna handtera olika rättigheter för skilda gruppr av agenter (t.ex. inköpsavdelning, supportavdelning, försäljningsavdelning, ...).',
      'Group Management' => 'gruppr',
      'It\'s useful for ASP solutions.' => 'Nyttigt för ASP-lösningar.',
      'The admin group is to get in the admin area and the stats group to get stats area.' => '\'admin\'-gruppen ger tillgång till Admin-arean, \'stats\'-gruppen till Statistik-arean.',

    # Template: AdminLog
      'System Log' => 'Systemlogg',

    # Template: AdminNavigationBar
      'AdminEmail' => 'Admin-email',
      'Attachment <-> Response' => 'Bifogat dokument <-> Svar',
      'Auto Response <-> Queue' => 'Autosvar <-> Kö',
      'Auto Responses' => 'Autosvar',
      'Customer User' => 'Kundanvändare',
      'Customer User <-> Groups' => 'Kundanvändare <-> gruppr',
      'Email Addresses' => 'Emailadresser',
      'Groups' => 'gruppr',
      'Logout' => 'Logga ut',
      'Misc' => 'Div',
      'Notifications' => 'Meddelanden',
      'PostMaster Filter' => '',
      'PostMaster POP3 Account' => 'Postmaster POP3-konto',
      'Responses' => 'Svar',
      'Responses <-> Queue' => 'Svar <-> Kö',
      'Select Box' => 'SQL-access',
      'Session Management' => 'Sessionshantering',
      'Status' => '',
      'System' => '',
      'User <-> Groups' => 'Användare <-> gruppr',

    # Template: AdminNotificationForm
      'Config options (e. g. &lt;OTRS_CONFIG_HttpType&gt;)' => 'Konfigurationsval (t.ex. &lt;OTRS_CONFIG_HttpType&gt;)',
      'Notification Management' => 'Meddelandehantering',
      'Notifications are sent to an agent or a customer.' => 'Meddelanden skickats till agenter eller kunder.',
      'Options of the current customer user data (e. g. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)' => 'ger tillgång till data för gällande kund (t.ex. &lt;OTRS_CUSTOMER_DATA_USERFIRSTNAME&gt;)',
      'Options of the current user who requested this action (e. g. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)' => 'ger tillgång till data för agenten som utför handlingen (t.ex. &lt;OTRS_CURRENT_USERFIRSTNAME&gt;)',
      'Ticket owner options (e. g. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)' => 'ger tillgang till data för agenten som står som ägare till ticketen (t.ex. &lt;OTRS_OWNER_USERFIRSTNAME&gt;)',

    # Template: AdminPOP3Form
      'All incoming emails with one account will be dispatched in the selected queue!' => 'Inkommande email från POP3-konton sorteras till vald kö!',
      'Dispatching' => 'Fördelning',
      'Host' => 'Host',
      'If your account is trusted, the x-otrs header (for priority, ...) will be used!' => 'Ifall detta är ett betrott konto används X-OTRS Header!',
      'Login' => '',
      'POP3 Account Management' => 'Administration av POP3-Konto',
      'Trusted' => 'Betrodd',

    # Template: AdminPostMasterFilterForm
      'Match' => 'Träff',
      'PostMasterFilter Management' => '',
      'Set' => 'Set',

    # Template: AdminQueueAutoResponseForm
      'Queue <-> Auto Response Management' => 'Hantering av Kö <-> Autosvar',

    # Template: AdminQueueAutoResponseTable

    # Template: AdminQueueForm
      '0 = no escalation' => '0 = ingen upptrappning',
      '0 = no unlock' => '0 = ingen upplåsning',
      'Customer Move Notify' => 'Meddelande om flytt av kund',
      'Customer Owner Notify' => 'Meddelande om byte av ägare av Kund',
      'Customer State Notify' => 'Meddelande om statusändring för Kund',
      'Escalation time' => 'Upptrappningstid',
      'Follow up Option' => 'Korrespondens på låst ticket',
      'If a ticket is closed and the customer sends a follow up the ticket will be locked for the old owner.' => 'Ifall en kund skickar uppföljningsmail på en låst ticket, blir ticketen låst till förra ägaren.',
      'If a ticket will not be answered in thos time, just only this ticket will be shown.' => 'Ifall en ticket inte blir besvarad inom denna tid, visas enbart denna ticket.',
      'If an agent locks a ticket and he/she will not send an answer within this time, the ticket will be unlock automatically. So the ticket is viewable for all other agents.' => 'Ifall en ticket som är låst av en agent men ändå inte blir besvarad inom denna tid, kommer låset automatiskt att tas bort.',
      'Key' => 'Nyckel',
      'OTRS sends an notification email to the customer if the ticket is moved.' => 'OTRS skickar ett meddelande till kunden ifall ticketen flyttas.',
      'OTRS sends an notification email to the customer if the ticket owner has changed.' => 'OTRS skickar ett meddelande till kunden vid ägarbyte.',
      'OTRS sends an notification email to the customer if the ticket state has changed.' => 'OTRS skickar ett meddelande till kunden vid statusuppdatering.',
      'Queue Management' => 'Köhantering',
      'Sub-Queue of' => 'Underkö till',
      'Systemaddress' => 'Systemadress',
      'The salutation for email answers.' => 'Hälsningsfras för email-svar.',
      'The signature for email answers.' => 'Signatur för email-svar.',
      'Ticket lock after a follow up' => 'Ticket låses efter uppföljningsmail',
      'Unlock timeout' => 'Tidsintervall för borttagning av lås',
      'Will be the sender address of this queue for email answers.' => 'Avsändaradress för email i denna Kö.',

    # Template: AdminQueueResponsesChangeForm
      'Std. Responses <-> Queue Management' => 'Hantering av standardsvar <-> Köhantering',

    # Template: AdminQueueResponsesForm
      'Answer' => 'Svar',
      'Change answer <-> queue settings' => 'Ändra var <-> Köinställningar',

    # Template: AdminResponseAttachmentChangeForm
      'Std. Responses <-> Std. Attachment Management' => 'Hantering av standardsvar <-> Bifogade dokument',

    # Template: AdminResponseAttachmentForm
      'Change Response <-> Attachment settings' => 'Ändra Svar <-> Inställningar för bifogade dokument',

    # Template: AdminResponseForm
      'A response is default text to write faster answer (with default text) to customers.' => 'Ett svar er en standardtext för att underlätta besvarandet av vanliga kundfrågor.',
      'Don\'t forget to add a new response a queue!' => 'Kom ihåg att lägga till ett nytt svar till en kö!',
      'Next state' => 'Nästa tillstånd',
      'Response Management' => 'Hantera svar',
      'The current ticket state is' => 'Nuvarande ticket-status',

    # Template: AdminSalutationForm
      'customer realname' => 'Fullt kundnamn',
      'for agent firstname' => 'för agents förnamn',
      'for agent lastname' => 'för agents efternamn',
      'for agent login' => 'för agents login',
      'for agent user id' => 'för agents användar-id',
      'Salutation Management' => 'Hantering av Hälsningsfraser',

    # Template: AdminSelectBoxForm
      'Max Rows' => 'Max rader',

    # Template: AdminSelectBoxResult
      'Limit' => '',
      'Select Box Result' => 'Select Box Resultat',
      'SQL' => '',

    # Template: AdminSession
      'Agent' => '',
      'kill all sessions' => 'Terminera alla sessioner',
      'Overview' => 'Översikt',
      'Sessions' => 'Sessioner',
      'Uniq' => '',

    # Template: AdminSessionTable
      'kill session' => 'Terminera session',
      'SessionID' => '',

    # Template: AdminSignatureForm
      'Signature Management' => 'Signaturhantering',

    # Template: AdminStateForm
      'See also' => 'Se också',
      'State Type' => 'Statustyp',
      'System State Management' => 'Hantering av systemstatus',
      'Take care that you also updated the default states in you Kernel/Config.pm!' => 'Se till att du också uppdaterade standardutgångslägena i Kernel/Config.pm!',

    # Template: AdminSystemAddressForm
      'All incoming emails with this "Email" (To:) will be dispatched in the selected queue!' => 'Alla inkommande mail till denna adressat (To:) delas ut till vald kö.',
      'Email' => 'Email',
      'Realname' => 'Fullständigt namn',
      'System Email Addresses Management' => 'Hantera System-emailadresser',

    # Template: AdminUserForm
      'Don\'t forget to add a new user to groups!' => 'Glöm inte att lägga in en ny användare i en grupp!',
      'Firstname' => 'Förnamn',
      'Lastname' => 'Efternamn',
      'User Management' => 'Användarhantering',
      'User will be needed to handle tickets.' => 'Användare krävs för att hantera tickets.',

    # Template: AdminUserGroupChangeForm
      'create' => 'Skapa',
      'move_into' => 'Flytta till',
      'owner' => 'Ägare',
      'Permissions to change the ticket owner in this group/queue.' => 'Rätt att ändra ticket-ägare i denna grupp/Kö.',
      'Permissions to change the ticket priority in this group/queue.' => 'Rätt att ändra prioritet i denna grupp/Kö.',
      'Permissions to create tickets in this group/queue.' => 'Rätt att skapa tickets i denna grupp/Kö.',
      'Permissions to move tickets into this group/queue.' => 'Rätt att flytta tickets i denna grupp/Kö.',
      'priority' => 'prioritet',
      'User <-> Group Management' => 'Hantera användare <-> grupp',

    # Template: AdminUserGroupForm

    # Template: AdminUserPreferencesGeneric

    # Template: AgentBook
      'Address Book' => 'Adressbok',
      'Discard all changes and return to the compose screen' => 'Bortse från ändringarna och stäng fönstret',
      'Return to the compose screen' => 'Stäng fönstret',
      'Search' => 'Sök',
      'The message being composed has been closed.  Exiting.' => 'Det tilhörande redigeringsfönstret har stängts. Avslutar.',
      'This window must be called from compose window' => 'Denne funktion måste startas från redigeringsfönstret',

    # Template: AgentBounce
      'A message should have a To: recipient!' => 'Ett meddelande måste ha en mottagare i Till:-fältet!',
      'Bounce ticket' => 'Skicka över ticket',
      'Bounce to' => 'Skicka över till',
      'Inform sender' => 'Informera avsändare',
      'Next ticket state' => 'Nästa ticketstatus',
      'Send mail!' => 'Skicka mail!',
      'You need a email address (e. g. customer@example.com) in To:!' => 'I Till-fältet måste anges en giltig emailadress (t.ex. kund@exempeldomain.se)!',
      'Your email with ticket number "<OTRS_TICKET>" is bounced to "<OTRS_BOUNCE_TO>". Contact this address for further informations.' => 'Emailen med ticketnummer "<OTRS_TICKET>" har skickats över till "<OTRS_BOUNCE_TO>". Vänligen kontakta denna adress för vidare hänvisningar.',

    # Template: AgentClose
      ' (work units)' => ' (arbetsenheter)',
      'A message should have a body!' => 'Ett meddelande måste innehålla en meddelandetext!',
      'A message should have a subject!' => 'Ett meddelande måste ha en Ämnesrad!',
      'Close ticket' => 'Stäng ticket',
      'Close type' => 'Stängningstillstånd',
      'Close!' => 'Stäng!',
      'Note Text' => 'Anteckingstext',
      'Note type' => 'Anteckningstyp',
      'Options' => 'Tillval',
      'Spell Check' => 'Stavningskontroll',
      'Time units' => 'Tidsenheter',
      'You need to account time!' => 'Du måste redovisa tiden!',

    # Template: AgentCompose
      'A message must be spell checked!' => 'Stavningskontroll måste utföras på alla meddelanden!',
      'Attach' => 'Bifoga',
      'Compose answer for ticket' => 'Författa svar till ticket',
      'for pending* states' => 'för väntetillstånd',
      'Is the ticket answered' => 'Är ticketen besvarad',
      'Pending Date' => 'Väntar till',

    # Template: AgentCustomer
      'Back' => 'Tilbaka',
      'Change customer of ticket' => 'Ändra kund för ticket',
      'CustomerID' => 'Organisations-ID',
      'Search Customer' => 'Sök kund',
      'Set customer user and customer id of a ticket' => 'Markera kundanvändare och organisations-id för ticket',

    # Template: AgentCustomerHistory
      'All customer tickets.' => 'Alla tickets för kund.',
      'Customer history' => 'Kundehistorik',

    # Template: AgentCustomerMessage
      'Follow up' => 'Uppföljning',

    # Template: AgentCustomerView
      'Customer Data' => 'Kunddata',

    # Template: AgentEmailNew
      'All Agents' => 'Alla agenter',
      'Clear From' => 'Nolställ Från:',
      'Compose Email' => 'Skriv email',
      'Lock Ticket' => 'Lås ticket',
      'new ticket' => 'Ny ticket',

    # Template: AgentForward
      'Article type' => 'Artikeltyp',
      'Date' => 'Dato',
      'End forwarded message' => 'Avsluta vidarebefordrat meddelande',
      'Forward article of ticket' => 'Vidarebefordrad artikel från ticket',
      'Forwarded message from' => 'Vidarebefordrat meddelande från',
      'Reply-To' => '',

    # Template: AgentFreeText
      'Change free text of ticket' => 'Ändra friatextfält i ticket',
      'Value' => 'Innehåll',

    # Template: AgentHistoryForm
      'History of' => 'Historik för',

    # Template: AgentMailboxNavBar
      'All messages' => 'Alla meddelanden',
      'down' => 'sjunkande',
      'Mailbox' => 'Mailbox',
      'New' => 'Nytt',
      'New messages' => 'Nya meddelanden',
      'Open' => 'Öppna',
      'Open messages' => 'Öppna meddelanden',
      'Order' => 'Sortering',
      'Pending messages' => 'Väntande meddelanden',
      'Reminder' => 'Påminnelse',
      'Reminder messages' => 'Påminnelsemeddelanden',
      'Sort by' => 'Sortera efter',
      'Tickets' => 'Tickets',
      'up' => 'stigande',

    # Template: AgentMailboxTicket
      '"}' => '',
      '"}","14' => '',

    # Template: AgentMove
      'Move Ticket' => 'Flytta ticket',
      'New Owner' => 'Ny ägare',
      'New Queue' => 'Ny Kö',
      'Previous Owner' => 'Tidigare ägare',
      'Queue ID' => 'Kö-id',

    # Template: AgentNavigationBar
      'Locked tickets' => 'Låsta tickets',
      'new message' => 'Nytt meddelande',
      'Preferences' => 'Inställningar',
      'Utilities' => 'Verktyg',

    # Template: AgentNote
      'Add note to ticket' => 'Lägg till anteckning till ticket',
      'Note!' => 'Observera!',

    # Template: AgentOwner
      'Change owner of ticket' => 'Ändra ägare av ticket',
      'Message for new Owner' => 'Meddelande till ny ägare',

    # Template: AgentPending
      'Pending date' => 'Väntande datum',
      'Pending type' => 'Väntande typ',
      'Pending!' => 'Väntar!',
      'Set Pending' => 'Markera som väntande',

    # Template: AgentPhone
      'Customer called' => 'Kundeuppringning',
      'Phone call' => 'Telefonsamtal',
      'Phone call at %s' => 'Telefonsamtal %s',

    # Template: AgentPhoneNew

    # Template: AgentPlain
      'ArticleID' => '',
      'Plain' => 'Enkel',
      'TicketID' => '',

    # Template: AgentPreferencesCustomQueue
      'Select your custom queues' => 'Välj dina egna Köer ("PersonalQueue")',

    # Template: AgentPreferencesForm

    # Template: AgentPreferencesGeneric

    # Template: AgentPreferencesPassword
      'Change Password' => 'Ändra lösenord',
      'New password' => 'Nytt lösenord',
      'New password again' => 'Nytt lösenord igen',

    # Template: AgentPriority
      'Change priority of ticket' => 'Ändra prioritet för ticket',

    # Template: AgentSpelling
      'Apply these changes' => 'Verkställ ändringar',
      'Spell Checker' => 'Stavningskontroll',
      'spelling error(s)' => 'Stavfel',

    # Template: AgentStatusView
      'D' => 'N',
      'of' => 'av',
      'Site' => 'plats',
      'sort downward' => 'Sortera sjunkande',
      'sort upward' => 'Sortera stigande',
      'Ticket Status' => 'Ticketstatus',
      'U' => 'U',

    # Template: AgentStatusViewTable

    # Template: AgentStatusViewTableNotAnswerd

    # Template: AgentTicketLink
      'Link' => 'Länk',
      'Link to' => 'Länk till',

    # Template: AgentTicketLocked
      'Ticket locked!' => 'Ticket låst',
      'Ticket unlock!' => 'Ticket upplåst',

    # Template: AgentTicketPrint
      'by' => 'av',

    # Template: AgentTicketPrintHeader
      'Accounted time' => 'Redovisad tid',
      'Escalation in' => 'Upptrappning om',

    # Template: AgentUtilSearch
      '(e. g. 10*5155 or 105658*)' => 't.ex. 10*5144 eller 105658*',
      '(e. g. 234321)' => 't.ex. 234321',
      '(e. g. U5150)' => 't.ex. U5150',
      'and' => 'og',
      'Customer User Login' => 'kundanvändare loginnamn',
      'Delete' => 'Radera',
      'Fulltext-Search in Article (e. g. "Mar*in" or "Baue*")' => 'Fritextsök i artiklar (t.ex. "Mar*in" eller "Baue*")',
      'No time settings.' => 'Inga tidsinställningar.',
      'Profile' => 'Profil',
      'Result Form' => 'Resultatbild',
      'Save Search-Profile as Template?' => 'Spara sökkriterier som mall?',
      'Search-Template' => 'Sökmall',
      'Select' => 'Välj',
      'Ticket created' => 'Ticket skapad',
      'Ticket created between' => 'Ticket skapat mellan',
      'Ticket Search' => 'Ticket-sök',
      'TicketFreeText' => '',
      'Times' => 'Tider',
      'Yes, save it with name' => 'Ja, spara med namn',

    # Template: AgentUtilSearchByCustomerID
      'Customer history search' => 'Kundhistorik',
      'Customer history search (e. g. "ID342425").' => 'Sök efter kundhistorik (t.ex. "ID342425").',
      'No * possible!' => 'Wildcards * inte tillåtna!',

    # Template: AgentUtilSearchNavBar
      'Change search options' => 'Ändra sökinställningar',
      'Results' => 'Resultat',
      'Search Result' => 'Sökeresultat',
      'Total hits' => 'Totalt hittade',

    # Template: AgentUtilSearchResult
      '"}","15' => '',

    # Template: AgentUtilSearchResultPrint

    # Template: AgentUtilSearchResultPrintTable
      '"}","30' => '',

    # Template: AgentUtilSearchResultShort

    # Template: AgentUtilSearchResultShortTable

    # Template: AgentUtilSearchResultShortTableNotAnswered

    # Template: AgentUtilTicketStatus
      'All closed tickets' => 'Alla låsta tickets',
      'All open tickets' => 'Alla öppna tickets',
      'closed tickets' => 'låsta tickets',
      'open tickets' => 'öppna tickets',
      'or' => 'eller',
      'Provides an overview of all' => 'Gir en oversikt over alle',
      'So you see what is going on in your system.' => 'Så att du kan se vad som sker i ditt system.',

    # Template: AgentZoomAgentIsCustomer
      'Compose Follow up' => 'Skriv uppföljningssvar',
      'Your own Ticket' => 'Din egen ticket',

    # Template: AgentZoomAnswer
      'Compose Answer' => 'Skriv svar',
      'Contact customer' => 'Kontakta kund',
      'phone call' => 'Telefonsamtal',

    # Template: AgentZoomArticle
      'Split' => 'Dela',

    # Template: AgentZoomBody
      'Change queue' => 'Ändra kö',

    # Template: AgentZoomHead
      'Free Fields' => 'Lediga fält',
      'Print' => 'Skriv ut',

    # Template: AgentZoomStatus
      '"}","18' => '',

    # Template: CustomerCreateAccount
      'Create Account' => 'Skapa konto',

    # Template: CustomerError
      'Traceback' => '',

    # Template: CustomerFAQArticleHistory
      'Edit' => 'Redigera',
      'FAQ History' => '',

    # Template: CustomerFAQArticlePrint
      'Category' => 'Kategori',
      'Keywords' => 'Nyckelord',
      'Last update' => 'Senast ändrat',
      'Problem' => 'Problem',
      'Solution' => 'Lösning',
      'Symptom' => 'Symptom',

    # Template: CustomerFAQArticleSystemHistory
      'FAQ System History' => '',

    # Template: CustomerFAQArticleView
      'FAQ Article' => '',
      'Modified' => 'Ändrat',

    # Template: CustomerFAQOverview
      'FAQ Overview' => 'FAQ Översikt',

    # Template: CustomerFAQSearch
      'FAQ Search' => 'FAQ Sök',
      'Fulltext' => 'Fritext',
      'Keyword' => 'Nyckelord',

    # Template: CustomerFAQSearchResult
      'FAQ Search Result' => 'FAQ Sökresultat',

    # Template: CustomerFooter
      'Powered by' => '',

    # Template: CustomerHeader
      'Contact' => 'Kontakt',
      'Home' => 'Hem',
      'Online-Support' => 'Online-support',
      'Products' => 'Produkter',
      'Support' => 'Support',

    # Template: CustomerLogin

    # Template: CustomerLostPassword
      'Lost your password?' => 'Glömt lösenordet?',
      'Request new password' => 'Be om nytt lösenord',

    # Template: CustomerMessage

    # Template: CustomerMessageNew

    # Template: CustomerNavigationBar
      'Create new Ticket' => 'Skapat ny ticket',
      'FAQ' => 'FAQ',
      'New Ticket' => 'Ny ticket',
      'Ticket-Overview' => 'Ticket-översikt',
      'Welcome %s' => 'Välkommen %s',

    # Template: CustomerPreferencesForm

    # Template: CustomerPreferencesGeneric

    # Template: CustomerPreferencesPassword

    # Template: CustomerStatusView
      'My Tickets' => 'Mina tickets',

    # Template: CustomerStatusViewTable

    # Template: CustomerTicketZoom

    # Template: CustomerWarning

    # Template: Error
      'Click here to report a bug!' => 'Klicka här för att rapportera ett fel!',

    # Template: FAQArticleDelete
      'FAQ Delete' => 'Radera FAQ',
      'You really want to delete this article?' => 'Vill du verkligen radera denna artikel?',

    # Template: FAQArticleForm
      'Comment (internal)' => 'Kommentar (intern)',
      'Filename' => 'Filnamn',
      'Short Description' => 'Kort beskrivning',

    # Template: FAQArticleHistory

    # Template: FAQArticlePrint

    # Template: FAQArticleSystemHistory

    # Template: FAQArticleView

    # Template: FAQCategoryForm
      'FAQ Category' => 'FAQ Kategori',

    # Template: FAQLanguageForm
      'FAQ Language' => 'FAQ Språk',

    # Template: FAQNavigationBar

    # Template: FAQOverview

    # Template: FAQSearch

    # Template: FAQSearchResult

    # Template: FAQStateForm
      'FAQ State' => 'FAQ Status',

    # Template: Footer
      'Top of Page' => 'Början av sidan',

    # Template: Header

    # Template: InstallerBody
      'Create Database' => 'Skapa databas',
      'Drop Database' => 'Radera databas',
      'Finished' => 'Klar',
      'System Settings' => 'Systeminställningar',
      'Web-Installer' => 'Web-installation',

    # Template: InstallerFinish
      'Admin-User' => 'Admin-användare',
      'After doing so your OTRS is up and running.' => 'Efter detta är OTRS igång.',
      'Have a lot of fun!' => 'Ha det så roligt!',
      'Restart your webserver' => 'Starta om din webserver',
      'Start page' => 'Startsida',
      'To be able to use OTRS you have to enter the following line in your command line (Terminal/Shell) as root.' => 'För att kunna använda OTRS, måste följende rad skrivas på kommandoraden som root.',
      'Your OTRS Team' => 'Ditt OTRS-Team',

    # Template: InstallerLicense
      'accept license' => 'godkänn licens',
      'don\'t accept license' => 'godkänn inte licens',
      'License' => 'Licens',

    # Template: InstallerStart
      'Create new database' => 'Skapa ny databas',
      'DB Admin Password' => 'DB Adminlösenord',
      'DB Admin User' => 'DB Adminanvändare',
      'DB Host' => 'DB host',
      'DB Type' => 'DB typ',
      'default \'hot\'' => 'default \'hot\'',
      'Delete old database' => 'Radera gammal databas',
      'next step' => 'nästa steg',
      'OTRS DB connect host' => 'OTRS DB connect host',
      'OTRS DB Name' => 'OTRS DB namn',
      'OTRS DB Password' => 'OTRS DB lösenord',
      'OTRS DB User' => 'OTRS DB användare',
      'your MySQL DB should have a root password! Default is empty!' => 'Din MySQL-databas bör ha ett root-lösenord satt!  Default är inget lösenord!',

    # Template: InstallerSystem
      '(Checks MX recordes of used email addresses by composing an answer. Don\'t use CheckMXRecord if your OTRS machine is behinde a dial-up line $!)' => '(Kontrollerar mx-uppslag för uppgivna emailadresser i meddelanden som skrivs.  Använd inte CheckMXRecord om din OTRS-maskin är bakom en uppringd lina!)',
      '(Email of the system admin)' => '(Email till systemadmin)',
      '(Full qualified domain name of your system)' => '(Fullt kvalificerat dns-namn för ditt system)',
      '(Logfile just needed for File-LogModule!)' => '(Logfile behövs enbart för File-LogModule!)',
      '(The identify of the system. Each ticket number and each http session id starts with this number)' => '(Unik id för detta system.  Alla ticketnummer och http-sesssionsid börjar med denna id)',
      '(Ticket identifier. Some people want toset this to e. g. \'Ticket#\', \'Call#\' or \'MyTicket#\')' => '(Ticket-identifierare, t.ex. \'Ticket#\', \'Call#\' eller \'MyTicket#\')',
      '(Used default language)' => '(Valt standardspråk)',
      '(Used log backend)' => '(Valt logg-backend)',
      '(Used ticket number format)' => '(Valt format för ticketnummer)',
      'CheckMXRecord' => '',
      'Default Charset' => 'Standard teckenuppsättning',
      'Default Language' => 'Standardspråk',
      'Logfile' => 'Logfil',
      'LogModule' => '',
      'Organization' => 'Organisation',
      'System FQDN' => '',
      'SystemID' => '',
      'Ticket Hook' => '',
      'Ticket Number Generator' => 'Ticket-nummergenerator',
      'Use utf-8 it your database supports it!' => 'Använd utf-8 ifall din databas stödjer det!',
      'Webfrontend' => 'Web-gränssnitt',

    # Template: Login

    # Template: LostPassword

    # Template: NoPermission
      'No Permission' => 'Ingen åtkomst',

    # Template: Notify
      'Info' => '',

    # Template: PrintFooter
      'URL' => '',

    # Template: PrintHeader
      'printed by' => 'utskrivet av',

    # Template: QueueView
      'All tickets' => 'Alla tickets',
      'Page' => 'Sida',
      'Queues' => 'Köer',
      'Tickets available' => 'Tillgängliga tickets',
      'Tickets shown' => 'Tickets som visas',

    # Template: SystemStats
      'Graphs' => 'Grafer',

    # Template: Test
      'OTRS Test Page' => 'OTRS Test-sida',

    # Template: TicketEscalation
      'Ticket escalation!' => 'Ticket-upptrappning!',

    # Template: TicketView

    # Template: TicketViewLite
      'Add Note' => 'Lägg till anteckning',

    # Template: Warning

    # Misc
      'Addressbook' => 'Adressbok',
      'AgentFrontend' => 'Agent-gränssnitt',
      'Article free text' => 'Artikel-fritext',
      'BackendMessage' => 'Backend-meddelande',
      'Bottom of Page' => 'Slutet av sidan',
      'Charset' => 'Teckenuppsättning',
      'Charsets' => 'Teckenuppsättningar',
      'Closed' => 'Låst',
      'Create' => 'Skapa',
      'CustomerUser' => 'Kundanvändare',
      'New ticket via call.' => 'Ny ticket via samtal.',
      'New user' => 'Ny användare',
      'Search in' => 'Sök i',
      'Show all' => 'Visa alla',
      'Shown Tickets' => 'Tickets som visas',
      'System Charset Management' => 'Hantering av systemets teckenuppsättning',
      'Time till escalation' => 'Tid till upptrappning',
      'With Priority' => 'Med prioritet',
      'With State' => 'Med status',
      'invalid-temporarily' => 'temporärt ogiltig',
      'search' => 'sök',
      'store' => 'lagra',
      'tickets' => 'tickets',
      'valid' => 'giltig',
    );

    # $$STOP$$
    $Self->{Translation} = \%Hash;
}
# --
1;

